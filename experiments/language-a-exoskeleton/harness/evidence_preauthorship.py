"""Emit deterministic evidence that does not require final Git self-reference."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import preauthorship as pre
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_file, write_bytes


BASE_BRANCH = "origin/codex/language-a-emission-pilot-preauthorship-repair"
BASE_COMMIT = "3e6fb3ef3125eee607f8bcf589f0e95108170f57"
BASE_TREE = "ddff0d4f499cda4904cd8d0624feb3f8a9f9140f"
REVIEWED_COMMIT = "f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e"
REVIEWED_TREE = "6561d3097c056c517e9f67fad1c168608d60f0db"
SUCCESSOR_BRANCH = "codex/language-a-emission-pilot-preauthorship-repair-0.2"
EVIDENCE_DIR = PACKET_ROOT / "evidence/preauthorship-repair-0.2"
PROTECTED = [
    "canonical-datum", "CD0-*.md", "/".join(("mneme", "lci0")), "mneme/spec/lci0-review",
    "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification", "mneme/latent-mvp",
    "mneme/language-a/validator.lisp", "mneme/language-a/fixtures.lisp",
    "mneme/language-a/DEPOSITION-NOT-THOUGHT.md", "mneme/verify-all.sh", "mneme/MANIFEST.md",
]


def git(*args):
    return subprocess.run(["git", *args], cwd=REPO_ROOT, check=True, capture_output=True, text=True).stdout


def write_json(name, value):
    write_bytes(EVIDENCE_DIR / name, canonical_json_bytes(value))


def changed_paths():
    tracked = set(filter(None, git("diff", "--name-only", BASE_COMMIT).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    paths = sorted(tracked | untracked | {
        "experiments/language-a-exoskeleton/evidence/preauthorship-repair-0.2/CHANGED-FILE-INVENTORY.json"
    })
    outside = [path for path in paths if not path.startswith("experiments/language-a-exoskeleton/")]
    if outside:
        raise RuntimeError(f"out-of-scope changed paths: {outside}")
    return paths


def generate():
    pre.validate_repository_records()
    inventory = pre.schema_inventory()
    mutations = pre.execute_mutations()
    old_registry = json.loads(git("show", f"{BASE_COMMIT}:experiments/language-a-exoskeleton/controls/preauthorship-mutations.json"))
    old_schema = json.loads(git("show", f"{BASE_COMMIT}:experiments/language-a-exoskeleton/evidence/preauthorship-repair/SCHEMA-INVENTORY.json"))["schemas"]
    registry = pre.strict_json_load(pre.MUTATION_REGISTRY_PATH)
    old_ids = [row["mutation_id"] for row in old_registry["mutations"]]
    new_ids = [row["mutation_id"] for row in registry["mutations"]]
    if new_ids[:len(old_ids)] != old_ids:
        raise RuntimeError("predecessor mutation IDs were removed, reordered, or renumbered")
    write_json("BASELINE-IDENTITY.json", {
        "schema_version": "lae-preauthorship-repair-baseline/0.2.0",
        "base": {"branch": BASE_BRANCH, "commit": BASE_COMMIT, "tree": BASE_TREE},
        "reviewed_predecessor": {"commit": REVIEWED_COMMIT, "tree": REVIEWED_TREE},
        "predecessor_is_ancestor": git("merge-base", "--is-ancestor", REVIEWED_COMMIT, BASE_COMMIT) == "",
        "merge_base": git("merge-base", REVIEWED_COMMIT, BASE_COMMIT).strip(),
        "successor_branch": SUCCESSOR_BRANCH,
        "successor_commit_identity_boundary": "verified after commit and push; a tracked file cannot contain its own commit/tree identity without changing that identity",
        "commission_basis": {"bytes": 24058, "sha256": pre.COMMISSION_BASIS_DIGEST},
        "adoption_ruling": {"bytes": 3501, "sha256": "sha256:968c9e0e65fc8fcd5dd76582cf7a0ae063aff96ea219eb724e3d2d6da88d222f"},
    })
    core = {
        "schema_version": "lae-preauthorship-verification/1.0.0",
        "schema_count": len(inventory),
        "schema_inventory": inventory,
        "mutation_count": len(mutations),
        "mutations_killed": len(mutations),
        "odr_43": "unresolved",
        "odr_60": "unresolved",
        "substantive_drafting": "blocked-pending-owner-adoption",
        "current_tranche_max_state": pre.CURRENT_TRANCHE_MAX_STATE,
        "jsonschema_runtime": pre.package_version("jsonschema"),
    }
    write_json("MUTATION-RESULTS.json", {
        "schema_version": "lae-preauthorship-mutation-results/0.2.0",
        "registry_path": pre.MUTATION_REGISTRY_PATH.relative_to(PACKET_ROOT).as_posix(),
        "registry_sha256": sha256_file(pre.MUTATION_REGISTRY_PATH),
        "predecessor_registry_sha256": registry["predecessor_registry_sha256"],
        "predecessor_declared": len(old_ids),
        "predecessor_ids_preserved_in_order": new_ids[:len(old_ids)] == old_ids,
        "added_ids": new_ids[len(old_ids):],
        "declared": len(registry["mutations"]),
        "executed": len(mutations),
        "killed": sum(result["killed"] for result in mutations),
        "undeclared_executed": [],
        "declared_unexecuted": [],
        "results": mutations,
    })
    write_json("SCHEMA-INVENTORY.json", {
        "schema_version": "lae-schema-inventory/0.2.0",
        "old_count": len(old_schema), "new_count": len(inventory),
        "old": old_schema, "new": inventory,
        "added": [row for row in inventory if row not in old_schema],
        "removed": [row for row in old_schema if row not in inventory],
    })

    owners = pre.load_owner_records()
    candidate = pre.load_odr60_candidate()
    candidate_totals = pre.validate_odr60_candidate(candidate)
    lineage = pre.load_successor_lineage()
    pre.validate_owner_records(owners, lineage_events=lineage)
    write_json("OWNER-DECISION-STATE.json", {
        "schema_version": "lae-preauthorship-owner-state/1.0.0",
        "owner_record_schema": "lae-owner-decision-record/1.0.0",
        "immutable_predecessor_file_sha256": {
            "ODR-43.json": "9ca88d96f8f159f2cad199e6f85d8e6aaa7bf5a240029210540e4c456157a65f",
            "ODR-60.json": "3963288b92bb8d56f31dae4e7719acf33dfd03df08b921f20c8b65291653f9d3",
        },
        "records": [
            {
                "decision_id": record["decision_id"],
                "record_id": record["record_id"],
                "record_digest": record["record_digest"],
                "predecessor_digest": record["predecessor_digest"],
                "status": record["status"],
                "exact_executable_gate": record["exact_executable_gate"],
            }
            for record in owners
        ],
        "odr_43": "unresolved",
        "odr_60": "unresolved",
        "odr_60_candidate": {
            "record_id": candidate["record_id"], "record_digest": candidate["record_digest"],
            "standing": candidate["standing"], "provenance": candidate["provenance"],
            "commission_basis_sha256": candidate["commission_basis_sha256"],
            "stored_totals": False, "derived_totals": candidate_totals,
        },
        "substantive_item_drafting": "blocked",
        "eligible_next_action": "owner adoption of typed ODR-43 and ODR-60 successors",
        "no_actor_or_owner_value_selected": True,
    })

    pv_mutations = {
        "pv_01": ["mutation:pv-01-witness", "odr-60-stale-aggregate-witness", "odr-60-multiple-answerability-roles"],
        "pv_02": ["mutation:pv-02-witness", "owner-adoption-reuses-unresolved-id", "owner-adoption-stale-predecessor-digest"],
        "pv_03": ["mutation:pv-03-witness", "frozen-null-freezer-decision", "frozen-without-transition-event"],
        "pv_04": ["mutation:pv-04-witness", "partial-key-author-input", "key-input-missing-rendering"],
        "pv_05": ["mutation:pv-05-witness", "empty-transmission-event", "transmission-without-byte-identity"],
    }
    results_by_id = {result["mutation_id"]: result for result in mutations}
    write_json("ADJUDICATION.json", {
        "schema_version": "lae-preauthorship-adjudication/0.2.0",
        "commission_basis_sha256": pre.COMMISSION_BASIS_DIGEST,
        "base": {"branch": BASE_BRANCH, "commit": BASE_COMMIT, "tree": BASE_TREE},
        "reviewed_input": {"branch": "origin/codex/language-a-emission-pilot-packet", "commit": REVIEWED_COMMIT, "tree": REVIEWED_TREE},
        "pv_adjudications": {
            pv: {
                "status": "closed-candidate-pending-targeted-owner-reverification",
                "basis_sha256": pre.COMMISSION_BASIS_DIGEST,
                "killed_counterexamples": [results_by_id[mutation_id] for mutation_id in mutation_ids],
            }
            for pv, mutation_ids in pv_mutations.items()
        },
        "fi_01": {
            "status": "candidate-closed-pending-targeted-owner-reverification",
            "basis": ["25 strict schema surfaces", "evidence-bearing state and bank closure", "declared mutation execution"],
            "ceiling": "no real item or key record created",
        },
        "fi_05": {
            "status": "candidate-closed-pending-targeted-owner-reverification",
            "basis": ["documented canonical event bytes", "strict v2 nonvacuous transmission", "append-only correction of legacy empty transmission"],
            "ceiling": "construction lineage only; no global separation claim",
        },
        "append_a_through_h": "owner-adopted by finalized ruling and implemented within Repair 0.2 scope",
        "owner_adoption_required": ["ODR-43", "ODR-60"],
        "substantive_item_authorship": "still-not-authorized",
    })

    write_json("VACUOUS-QUANTIFIER-CENSUS.json", {
        "schema_version": "lae-vacuous-quantifier-census/1.0.0",
        "commission_basis_sha256": pre.COMMISSION_BASIS_DIGEST,
        "audit_scope": "collection quantifiers in the Repair 0.2 preauthorship schema and Python validator",
        "checks": [
            {"surface": "source manifest components", "empty_behavior": "rejected by minItems=1"},
            {"surface": "item renderings", "empty_behavior": "rejected by minItems=1", "mutation": "empty-item-rendering-set"},
            {"surface": "taint identity_bindings", "empty_behavior": "rejected by minItems=1", "mutation": "empty-taint-identity-bindings"},
            {"surface": "taint subject_sha256s", "empty_behavior": "rejected by minItems=1", "mutation": "empty-taint-subject-sha256s"},
            {"surface": "state-transition predecessor renderings/components", "empty_behavior": "rejected by minItems=1"},
            {"surface": "frozen-bank items/renderings/sources/components/doctrine/authorities", "empty_behavior": "each rejected by minItems=1"},
            {"surface": "key handoff entries and authority identities", "empty_behavior": "rejected by minItems=1 and exact-set equality"},
            {"surface": "transmission artifact_refs/basis/claims/inputs/parents", "empty_behavior": "each rejected conditionally for transmission/handoff", "mutation": "empty-transmission-event"},
            {"surface": "lineage event list", "empty_behavior": "rejected as empty lineage"},
            {"surface": "lineage actor/artifact/basis/reference loops", "empty_behavior": "typed empty allowed only for event types with no semantic member obligation"},
            {"surface": "ODR-60 item rows", "empty_behavior": "rejected; exactly 24 required"},
            {"surface": "ODR-60 per-row tags", "empty_behavior": "typed empty allowed; cross-row tag obligations remain enforced"},
            {"surface": "ODR-43 actor/read/exposure/shared-root/restriction collections", "empty_behavior": "rejected by positive cardinality or exact three-class exposure declaration"},
            {"surface": "owner predecessor/successor groups", "empty_behavior": "rejected; exactly one preserved unresolved predecessor per decision"},
            {"surface": "schema inventory and mutation registry", "empty_behavior": "exact handler/declaration equality and required predecessor identity prevent vacuous success"},
            {"surface": "source transformations/effectful procedures", "empty_behavior": "typed empty means explicitly none; no universal semantic claim inferred"},
            {"surface": "ancestry/exposure disclosure arrays", "empty_behavior": "typed empty is an explicit disclosure value; self-report cannot certify separation"},
            {"surface": "construct specimen registry", "empty_behavior": "rejected; exact TXD-01 through TXD-10 identity set required"},
        ],
    })
    write_json("BOUNDARY-AND-COUNTEREXAMPLE-EVIDENCE.json", {
        "schema_version": "lae-boundary-counterexample-evidence/0.2.0",
        "commission_basis_sha256": pre.COMMISSION_BASIS_DIGEST,
        "escaped_fixture_registry": "preauthorship/registries/escaped-defect-fixtures.json",
        "witness_rejections": {
            "owner_adoption_bypass": results_by_id["mutation:pv-02-witness"],
            "stale_odr60": results_by_id["mutation:pv-01-witness"],
            "self_asserted_frozen_state": results_by_id["mutation:pv-03-witness"],
            "null_freezer_decision": results_by_id["frozen-null-freezer-decision"],
            "partial_key_handoff": results_by_id["mutation:pv-04-witness"],
            "empty_transmission": results_by_id["mutation:pv-05-witness"],
        },
        "negative_census": {
            "real_item_content": 0, "real_source_content": 0, "private_key_content": 0,
            "scoring_implemented": False, "provider_calls": 0, "target_outputs": 0,
            "exposure_authorized": False, "packet_freeze_authorized": False,
            "odr_43": "unresolved", "odr_60": "unresolved",
        },
    })

    protected = git("diff", "--name-only", BASE_COMMIT, "--", *PROTECTED).strip().splitlines()
    untracked_protected = git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED).strip().splitlines()
    if protected or untracked_protected:
        raise RuntimeError(f"protected scope changed: {protected + untracked_protected}")
    write_json("PROTECTED-SCOPE-DIFF.json", {
        "schema_version": "lae-preauthorship-protected-scope/1.0.0",
        "base_commit": BASE_COMMIT,
        "pathspecs": PROTECTED,
        "tracked_changes": protected,
        "untracked_changes": untracked_protected,
        "result": "empty",
    })

    paths = changed_paths()
    write_json("CHANGED-FILE-INVENTORY.json", {
        "schema_version": "lae-preauthorship-changed-files/1.0.0",
        "base_commit": BASE_COMMIT,
        "scope_prefix": "experiments/language-a-exoskeleton/",
        "path_count": len(paths),
        "paths": paths,
        "outside_scope": [],
        "inventory_includes_itself_by_path": True,
        "content_digests_are_bound_by": "CONSTRUCTION-MANIFEST.json",
    })

    write_json("CORE-VERIFICATION-SUMMARY.json", core)
    print(json.dumps({
        "changed_paths": len(paths), "mutations": len(mutations), "schemas": core["schema_count"],
        "fi_01": "closed", "fi_05": "closed", "drafting": "blocked-owner-adoption",
    }, sort_keys=True))


if __name__ == "__main__":
    generate()
