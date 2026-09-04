"""Emit deterministic evidence that does not require final Git self-reference."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import preauthorship as pre
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_file, write_bytes


REVIEWED_COMMIT = "f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e"
REVIEWED_TREE = "6561d3097c056c517e9f67fad1c168608d60f0db"
EVIDENCE_DIR = PACKET_ROOT / "evidence/preauthorship-repair"
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
    tracked = set(filter(None, git("diff", "--name-only", REVIEWED_COMMIT).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    paths = sorted(tracked | untracked | {
        "experiments/language-a-exoskeleton/evidence/preauthorship-repair/CHANGED-FILE-INVENTORY.json"
    })
    outside = [path for path in paths if not path.startswith("experiments/language-a-exoskeleton/")]
    if outside:
        raise RuntimeError(f"out-of-scope changed paths: {outside}")
    return paths


def generate():
    pre.validate_repository_records()
    inventory = pre.schema_inventory()
    mutations = pre.execute_mutations()
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
    registry = pre.strict_json_load(pre.MUTATION_REGISTRY_PATH)
    write_json("MUTATION-RESULTS.json", {
        "schema_version": "lae-preauthorship-mutation-results/1.0.0",
        "registry_path": pre.MUTATION_REGISTRY_PATH.relative_to(PACKET_ROOT).as_posix(),
        "registry_sha256": sha256_file(pre.MUTATION_REGISTRY_PATH),
        "declared": len(registry["mutations"]),
        "executed": len(mutations),
        "killed": sum(result["killed"] for result in mutations),
        "undeclared_executed": [],
        "declared_unexecuted": [],
        "results": mutations,
    })

    owners = pre.load_owner_records()
    lineage = pre.load_successor_lineage()
    pre.validate_owner_records(owners, lineage_events=lineage)
    write_json("OWNER-DECISION-STATE.json", {
        "schema_version": "lae-preauthorship-owner-state/1.0.0",
        "owner_record_schema": "lae-owner-decision-record/1.0.0",
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
        "substantive_item_drafting": "blocked",
        "eligible_next_action": "owner adoption of typed ODR-43 and ODR-60 successors",
        "no_actor_or_owner_value_selected": True,
    })

    write_json("ADJUDICATION.json", {
        "schema_version": "lae-preauthorship-adjudication/1.0.0",
        "reviewed_input": {"branch": "origin/codex/language-a-emission-pilot-packet", "commit": REVIEWED_COMMIT, "tree": REVIEWED_TREE},
        "fi_01": {
            "status": "closed-for-bounded-preauthorship-repair",
            "basis": ["21 strict schema surfaces", "exact byte and reference closure", "two-artifact boundary", "declared mutation execution"],
            "ceiling": "no real item or key record created",
        },
        "fi_05": {
            "status": "closed-for-bounded-preauthorship-repair",
            "basis": ["canonical event bytes", "exact predecessor digests", "actor/artifact/read/transmission closure", "chronology and immutable successor enforcement"],
            "ceiling": "construction lineage only; no global separation claim",
        },
        "r_01": "implemented only on item/source/rendering/commission and future construct-capacity surfaces required by this tranche",
        "r_04": "implemented only on semantic manifest and construction-lineage surfaces required by FI-01/FI-05",
        "construct_validity": "not established; schema capacity and taint/provenance hooks only",
        "owner_adoption_required": ["ODR-43", "ODR-60"],
        "substantive_item_authorship": "still-not-authorized",
    })

    protected = git("diff", "--name-only", REVIEWED_COMMIT, "--", *PROTECTED).strip().splitlines()
    untracked_protected = git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED).strip().splitlines()
    if protected or untracked_protected:
        raise RuntimeError(f"protected scope changed: {protected + untracked_protected}")
    write_json("PROTECTED-SCOPE-DIFF.json", {
        "schema_version": "lae-preauthorship-protected-scope/1.0.0",
        "base_commit": REVIEWED_COMMIT,
        "pathspecs": PROTECTED,
        "tracked_changes": protected,
        "untracked_changes": untracked_protected,
        "result": "empty",
    })

    paths = changed_paths()
    write_json("CHANGED-FILE-INVENTORY.json", {
        "schema_version": "lae-preauthorship-changed-files/1.0.0",
        "base_commit": REVIEWED_COMMIT,
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
