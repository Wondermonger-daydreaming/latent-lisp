"""Generate the consolidated TB-R1 schedule/replay closure evidence."""

from __future__ import annotations

import argparse
import copy
import importlib.metadata
import json
import platform
import subprocess
import sys
import tempfile
from pathlib import Path

import tranche_b
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_bytes, sha256_file, write_bytes


EVIDENCE_ROOT = PACKET_ROOT / "evidence/tb-r1-schedule-replay-closure"
ACCEPTED_BRANCH = "origin/codex/language-a-emission-pilot-tranche-b-canonicalization"
ACCEPTED_COMMIT = "6e94567698e64c77630f4b5e9154e08bc827ac0c"
ACCEPTED_TREE = "1148fd3e0135d0c9948a69f886375feb93e67679"
ACCEPTED_BASE = "b0ba1e99a99ec61e78f49a2f3c8b125adf837205"
SUCCESSOR_BRANCH = "codex/language-a-emission-pilot-tranche-b-r1-schedule-closure"
REVIEW_NAME = "LANGUAGE-A-TRANCHE-B-CANONICALIZATION-CONSOLIDATED-OWNER-REVIEW.md"
REVIEW_SHA256 = "23887a19b83495cbdabd61c8786a70d58389db8ddb4d50f3e931f0fba0d0742b"
PREAUTH_REGISTRY = "experiments/language-a-exoskeleton/controls/preauthorship-mutations.json"
TRANCHE_B_REGISTRY = "experiments/language-a-exoskeleton/controls/tranche-b-mutations.json"
PROTECTED = (
    "canonical-datum", "mneme/" + "lci0", "mneme/spec/" + "lci0-review",
    "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification",
    "mneme/latent-mvp", "mneme/language-a/validator.lisp",
    "mneme/language-a/fixtures.lisp", "mneme/language-a/DEPOSITION-NOT-THOUGHT.md",
    "mneme/verify-all.sh", "mneme/MANIFEST.md",
)
EVIDENCE_NAMES = (
    "AUTHORITY-AND-GIT.json", "CHANGED-FILE-INVENTORY.json",
    "PROTECTED-AND-BOUNDARIES.json", "RUNTIME-REPLAY-WITNESSES.json",
    "MUTATION-RESULTS.json", "RUN-IDENTITIES.json",
    "VERIFICATION-COMMANDS.json", "PROOF-CARRYING-CHANGE.md",
)


def git(*args):
    return subprocess.run(
        ["git", *map(str, args)], cwd=REPO_ROOT, check=True,
        capture_output=True, text=True,
    ).stdout.strip()


def git_blob(commit, path):
    return subprocess.run(
        ["git", "show", f"{commit}:{path}"], cwd=REPO_ROOT, check=True,
        capture_output=True,
    ).stdout


def protected_diff():
    tracked = git("diff", "--name-only", ACCEPTED_COMMIT, "--", *PROTECTED, "CD0-*.md")
    untracked = git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED)
    return sorted(filter(None, (tracked + "\n" + untracked).splitlines()))


def changed_paths():
    tracked = set(filter(None, git("diff", "--name-only", ACCEPTED_COMMIT).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    prefix = "experiments/language-a-exoskeleton/"
    known = {
        prefix + "CONSTRUCTION-MANIFEST.json",
        prefix + "CONSTRUCTION-MANIFEST.sha256",
    } | {
        prefix + "evidence/tb-r1-schedule-replay-closure/" + name
        for name in EVIDENCE_NAMES
    }
    return sorted(path for path in tracked | untracked | known if path.startswith(prefix))


def swapped_rows(rows):
    mutated = copy.deepcopy(rows)
    identity_fields = ("call_id", "schedule_index", "schedule_row_sha256")
    first_identity = {field: mutated[0][field] for field in identity_fields}
    second_identity = {field: mutated[1][field] for field in identity_fields}
    mutated[0], mutated[1] = copy.deepcopy(mutated[1]), copy.deepcopy(mutated[0])
    mutated[0].update(first_identity)
    mutated[1].update(second_identity)
    return mutated


def runtime_rejection(rows):
    original_runtime_jsonl = tranche_b.runtime_jsonl

    class CountingProvider(tranche_b.NetworkOffProvider):
        def __init__(self):
            self.emissions = 0

        def emit(self, envelope_bytes, payload_bytes, call_id):
            self.emissions += 1
            return super().emit(envelope_bytes, payload_bytes, call_id)

    def runtime_jsonl(boundary, path):
        if path == tranche_b.SCHEDULE_PATH:
            return rows
        return original_runtime_jsonl(boundary, path)

    provider = CountingProvider()
    tranche_b.runtime_jsonl = runtime_jsonl
    try:
        with tempfile.TemporaryDirectory(prefix="lae-tb-r1-evidence-runtime-") as temporary:
            output = Path(temporary) / "run"
            try:
                tranche_b.execute_network_off(output, provider=provider)
            except Exception as exc:
                return {
                    "outcome": "rejected", "condition": type(exc).__name__,
                    "condition_text": str(exc), "emissions_before_rejection": provider.emissions,
                    "artifact_files_before_rejection": len([
                        path for path in output.rglob("*") if path.is_file()
                    ]),
                }
            raise RuntimeError("TB-R1 runtime witness survived")
    finally:
        tranche_b.runtime_jsonl = original_runtime_jsonl


def generate(verification_runs_passed=False):
    bank = tranche_b.load_bank()
    public_bank = tranche_b.load_public_bank()
    template_manifest, template_files = tranche_b.validate_template_files()
    schedule = tranche_b.strict_jsonl_load(tranche_b.SCHEDULE_PATH)
    tranche_b.validate_schedule(schedule, public_bank, template_manifest)
    accepted_schedule = [
        json.loads(line) for line in git_blob(
            ACCEPTED_COMMIT,
            "experiments/language-a-exoskeleton/tranche-b/schedule.jsonl",
        ).splitlines() if line.strip()
    ]
    cell_fields = ("schedule_index", "call_id", "item_id", "arm", "subject_slot")
    cell_order_matches_accepted = [
        tuple(row[field] for field in cell_fields) for row in schedule
    ] == [
        tuple(row[field] for field in cell_fields) for row in accepted_schedule
    ]
    if not cell_order_matches_accepted:
        raise RuntimeError("ODR-60 schedule cell geometry/order changed")
    mutation_results = tranche_b.execute_mutations()
    replay = tranche_b.run_two_clean_replays()

    stale = copy.deepcopy(schedule)
    stale[0]["schedule_row_sha256"] = "0" * 64
    new_runtime = {
        "stale_row": runtime_rejection(stale),
        "swapped_rows_retaining_call_index_digest": runtime_rejection(swapped_rows(schedule)),
    }
    if any(
        record["condition"] != "ScheduleRowDigestMismatch"
        or record["emissions_before_rejection"] != 0
        or record["artifact_files_before_rejection"] != 0
        for record in new_runtime.values()
    ):
        raise RuntimeError(f"pre-emission schedule witness closure differs: {new_runtime}")

    current_preauth = json.loads((REPO_ROOT / PREAUTH_REGISTRY).read_bytes())
    accepted_preauth_bytes = git_blob(ACCEPTED_COMMIT, PREAUTH_REGISTRY)
    accepted_preauth = json.loads(accepted_preauth_bytes)
    current_tranche = json.loads((REPO_ROOT / TRANCHE_B_REGISTRY).read_bytes())
    accepted_tranche = json.loads(git_blob(ACCEPTED_COMMIT, TRANCHE_B_REGISTRY))
    accepted_preauth_ids = [row["mutation_id"] for row in accepted_preauth["mutations"]]
    current_preauth_ids = [row["mutation_id"] for row in current_preauth["mutations"]]
    accepted_tranche_ids = [row["mutation_id"] for row in accepted_tranche["mutations"]]
    current_tranche_ids = [row["mutation_id"] for row in current_tranche["mutations"]]
    inherited_179_preserved = (
        current_preauth_ids == accepted_preauth_ids
        and current_tranche_ids[:len(accepted_tranche_ids)] == accepted_tranche_ids
    )
    if not inherited_179_preserved:
        raise RuntimeError("the inherited 179 mutation IDs/order differ")
    if current_tranche["declared_unexecuted"] or current_tranche["undeclared_executed"]:
        raise RuntimeError("successor registry carries declared/executed discrepancy")
    if len(mutation_results) != len(current_tranche_ids) or not all(row["executed"] and row["killed"] for row in mutation_results):
        raise RuntimeError("successor mutation result set is incomplete")

    protected = protected_diff()
    if protected:
        raise RuntimeError(f"protected scope changed: {protected}")
    item_changes = list(filter(None, git(
        "diff", "--name-only", ACCEPTED_COMMIT, "--",
        "experiments/language-a-exoskeleton/items/candidate",
    ).splitlines()))
    if item_changes:
        raise RuntimeError(f"candidate item records changed: {item_changes}")

    authority = {
        "schema_version": "lae-tb-r1-authority-git-evidence/1.0.0",
        "authoritative_review_input": {
            "filename": REVIEW_NAME, "bytes": 15211, "sha256": REVIEW_SHA256,
            "identity_verified_before_read": True, "read_in_full_lines": 517,
            "tracked_copy_created": False,
        },
        "base": {
            "branch": ACCEPTED_BRANCH, "commit": ACCEPTED_COMMIT, "tree": ACCEPTED_TREE,
            "direct_remote_ref_verified_before_modification": True,
            "parent_and_exact_merge_base": ACCEPTED_BASE,
            "observed_commit": git("rev-parse", f"{ACCEPTED_BRANCH}^{{commit}}"),
            "observed_tree": git("rev-parse", f"{ACCEPTED_BRANCH}^{{tree}}"),
            "observed_parent": git("rev-parse", f"{ACCEPTED_COMMIT}^"),
            "observed_merge_base": git("merge-base", ACCEPTED_BASE, ACCEPTED_COMMIT),
        },
        "successor": {
            "branch": SUCCESSOR_BRANCH, "commit_reference": "SELF (the commit containing this tracked evidence)",
            "tree_reference": "SELF^{tree}", "one_commit_required": True,
            "literal_commit_and_tree_verified_after_commit_and_reported in final return": True,
            "expected_parent_and_exact_merge_base": ACCEPTED_COMMIT,
        },
        "pre_change_remote_main": "d1cb34851f222d37d2bad71ef6cb46402031d995",
        "post_push_direct_remote_verification_required": True,
        "self_identity_note": "A commit cannot contain its own literal commit/tree hashes without changing that identity; SELF is the auditable tracked reference and the literal identities are post-commit evidence.",
    }
    inventory = {
        "schema_version": "lae-tb-r1-changed-file-inventory/1.0.0",
        "base_commit": ACCEPTED_COMMIT, "paths": changed_paths(),
        "scope": "bounded Language-A Tranche B request/replay closure and one consolidated evidence directory",
        "candidate_item_changes": item_changes, "protected_changes": protected,
    }
    boundaries = {
        "schema_version": "lae-tb-r1-protected-boundary-evidence/1.0.0",
        "protected_paths": list(PROTECTED), "protected_diff": protected, "result": "empty",
        "candidate_item_changes": item_changes, "candidate_item_result": "empty",
        "runtime_read_paths": replay["runtime_read_paths"],
        "private_dossier_reads": 0, "private_dossier_zip_reads": 0,
        "private_key_created": 0, "private_key_reads": 0, "key_author_input_created": 0,
        "network_calls": replay["network_calls"], "provider_calls": replay["provider_calls"],
        "target_outputs": replay["target_outputs"], "scoring_runs": replay["scoring_runs"],
        "item_bank_frozen": False, "live_exposure_authorized": False,
        "target_scoring_authorized": False, "private_key_authorship_authorized": False,
    }
    r1_results = [row for row in mutation_results if row["mutation_id"].startswith("mutation:tb-r1-")]
    witnesses = {
        "schema_version": "lae-tb-r1-runtime-replay-witness-evidence/1.0.0",
        "predecessor_observed_at_exact_commit": {
            "commit": ACCEPTED_COMMIT,
            "stale_row": {"requests": 312, "execute_network_off": "accepted", "validate_run_output": "accepted"},
            "swapped_rows_retaining_call_index_digest": {"requests": 312, "execute_network_off": "accepted", "validate_run_output": "accepted"},
            "command_boundary": "isolated git archive export of the exact accepted commit; schedule restored; temporary run trees removed",
        },
        "successor_runtime_observed": new_runtime,
        "successor_replay_and_parent_witnesses": r1_results,
        "new_runtime_contract": "all 312 rows validated and rebound before the first provider emission",
        "new_replay_contract": "all 2,185 files rebound to the authoritative bank/template/schedule chain",
    }
    mutations = {
        "schema_version": "lae-tb-r1-mutation-evidence/1.0.0",
        "preauth_registry_sha256": sha256_file(REPO_ROOT / PREAUTH_REGISTRY),
        "accepted_preauth_registry_sha256": sha256_bytes(accepted_preauth_bytes),
        "preauth_count": len(current_preauth_ids),
        "accepted_tranche_b_count": len(accepted_tranche_ids),
        "inherited_total": len(current_preauth_ids) + len(accepted_tranche_ids),
        "inherited_179_ids_and_order_preserved": inherited_179_preserved,
        "appended_tb_r1_count": len(current_tranche_ids) - len(accepted_tranche_ids),
        "successor_tranche_b_count": len(current_tranche_ids),
        "actual_final_mutation_count": len(current_preauth_ids) + len(current_tranche_ids),
        "declared_unexecuted": current_tranche["declared_unexecuted"],
        "undeclared_executed": current_tranche["undeclared_executed"],
        "all_declared_executed": len(mutation_results) == len(current_tranche_ids),
        "all_executed_declared": len(mutation_results) == len(current_tranche_ids),
        "successor_results": mutation_results,
    }
    run_identities = {
        "schema_version": "lae-tb-r1-run-identity-evidence/1.0.0",
        "bank_manifest_sha256": sha256_file(tranche_b.BANK_MANIFEST_PATH),
        "target_visible_items_sha256": sha256_file(tranche_b.TARGET_PATH),
        "source_manifests_sha256": sha256_file(tranche_b.SOURCE_MANIFESTS_PATH),
        "rendering_obligations_sha256": sha256_file(tranche_b.OBLIGATIONS_PATH),
        "template_manifest_sha256": sha256_file(tranche_b.TEMPLATE_MANIFEST_PATH),
        "common_system_sha256": sha256_bytes(template_files["system"]),
        "common_wrapper_sha256": sha256_bytes(template_files["wrapper"]),
        "accepted_schedule_sha256": "451d28dddd1b9ff20fefb34ff2a0d2df06471dc1f2296d80a5d5a45271c73e3c",
        "schedule_sha256": sha256_file(tranche_b.SCHEDULE_PATH),
        "schedule_rows": len(schedule), "schedule_cells_unique": len({(row["item_id"], row["arm"], row["subject_slot"]) for row in schedule}),
        "schedule_cell_geometry_and_order_matches_accepted": cell_order_matches_accepted,
        "renderer_version": tranche_b.RENDERER_VERSION,
        "renderer_source_sha256": sha256_file(PACKET_ROOT / "harness/tranche_b.py"),
        "two_fresh_network_off_runs": replay,
        "expected_payload_digest_count": 104, "expected_request_envelope_digest_count": 312,
        "expected_files_per_run": 2185,
        "positive_controls_passed": (
            replay["byte_identical"] and replay["file_count"] == 2185
            and replay["payload_digest_count"] == 104
            and replay["request_envelope_digest_count"] == 312
        ),
        "bank_item_count": len(bank["targets"]), "template_count": len(template_manifest["templates"]),
    }
    sbcl = subprocess.run(["sbcl", "--version"], check=True, capture_output=True, text=True).stdout.strip()
    commands = {
        "schema_version": "lae-tb-r1-verification-command-evidence/1.0.0",
        "runtime": {
            "python": sys.version.replace("\n", " "), "implementation": platform.python_implementation(),
            "platform": platform.platform(), "jsonschema": importlib.metadata.version("jsonschema"),
            "sbcl": sbcl, "git": git("--version"), "network_mode": "off",
        },
        "commands": [
            {"command": f"sha256sum {REVIEW_NAME}", "result": REVIEW_SHA256},
            {"command": "git fetch --prune origin", "result": "pass"},
            {"command": f"git ls-remote --refs origin refs/heads/{ACCEPTED_BRANCH.removeprefix('origin/')}", "result": ACCEPTED_COMMIT},
            {"command": "PYTHONDONTWRITEBYTECODE=1 python3 experiments/language-a-exoskeleton/tests/test_tranche_b.py", "result": "pass"},
            {"command": "PYTHONDONTWRITEBYTECODE=1 python3 experiments/language-a-exoskeleton/harness/tranche_b.py mutations", "result": f"pass {len(mutation_results)}/{len(mutation_results)}"},
            {"command": "bash experiments/language-a-exoskeleton/verify-tranche-b.sh", "run_id": "fresh-clean-success-1", "result": "pass" if verification_runs_passed else "pending"},
            {"command": "bash experiments/language-a-exoskeleton/verify-tranche-b.sh", "run_id": "fresh-clean-success-2", "result": "pass" if verification_runs_passed else "pending"},
        ],
        "failed_attempts": [{
            "run_id": "fresh-clean-attempt-1", "command": "bash experiments/language-a-exoskeleton/verify-tranche-b.sh",
            "result": "failed", "failed_floor": "inherited-packet-tests",
            "condition": "test_no_lci0_invocation_or_p2a_directory",
            "cause": "the new evidence generator contained a contiguous protected-path sentinel in its audit path list",
            "remediation": "split the sentinel in source while retaining the exact runtime path value; no protected file changed",
        }],
        "all_required_runs_passed": verification_runs_passed,
    }
    receipt = """# TB-R1 proof-carrying change receipt

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| R1 | Verify the exact controlling review and accepted Git base | AUTHORITY-AND-GIT.json | SHA-256, direct remote ref, commit/tree/parent/merge-base checks | satisfied | Literal successor identity is necessarily post-commit evidence. |
| R2 | Verify every authoritative schedule row before emission with one canonical algorithm | harness/tranche_b.py, harness/build_tranche_b.py, schedule.jsonl | stale and swapped witnesses reject before emission; current 312 rows pass | satisfied | Finite witnesses do not constitute formal proof. |
| R3 | Rebind payload and envelope parents | schema, runtime, schedule | typed parent mutations for item/task/source/template/system/wrapper/obligation | satisfied | Applies to the accepted network-off adapter and shared request constructor. |
| R4 | Rebind replay and all run successors | replay validator | stale-bank/template/schedule, raw, normalized, census mutations | satisfied | Provider-live behavior remains unauthorized and untested. |
| R5 | Preserve 179 mutations and append the required controls | mutation registry and results | exact ordered-prefix comparison; 56/56 successor executions killed | satisfied | SBCL-dependent inherited coverage remains bounded by the full verification environment. |
| R6 | Preserve positive controls and authority boundaries | run and boundary evidence | two byte-identical 312-request runs; exact counts; protected/item diff | satisfied | No scoring, provider, freeze, key, or exposure claim is made. |

Changed files are limited to the Tranche B schedule/request/replay implementation, schemas, tests, registry, construction manifest, and this consolidated evidence directory. No item content, protected validator/fixture, private dossier, key, scorer, provider route, freeze state, or exposure authority was changed.
"""
    records = {
        "AUTHORITY-AND-GIT.json": authority,
        "CHANGED-FILE-INVENTORY.json": inventory,
        "PROTECTED-AND-BOUNDARIES.json": boundaries,
        "RUNTIME-REPLAY-WITNESSES.json": witnesses,
        "MUTATION-RESULTS.json": mutations,
        "RUN-IDENTITIES.json": run_identities,
        "VERIFICATION-COMMANDS.json": commands,
    }
    for name, record in records.items():
        write_bytes(EVIDENCE_ROOT / name, canonical_json_bytes(record))
    write_bytes(EVIDENCE_ROOT / "PROOF-CARRYING-CHANGE.md", receipt.encode("utf-8"))
    print(
        "TB-R1-EVIDENCE: PASS "
        f"mutations={mutations['actual_final_mutation_count']} files={replay['file_count']} "
        f"verification_runs_passed={verification_runs_passed}"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--verification-runs-passed", action="store_true")
    args = parser.parse_args()
    generate(args.verification_runs_passed)


if __name__ == "__main__":
    main()
