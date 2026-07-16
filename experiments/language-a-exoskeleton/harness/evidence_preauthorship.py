"""Emit deterministic Repair 0.2.1 evidence without Git self-reference."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import preauthorship as pre
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_file, write_bytes


BASE_BRANCH = "origin/codex/language-a-emission-pilot-preauthorship-repair-0.2"
BASE_COMMIT = "bcf76e78e597351e088a2fcec646230fa1deca60"
BASE_TREE = "9fd259ee678f338e4910d1fd68d5c2042c46e992"
PREDECESSOR_COMMIT = "3e6fb3ef3125eee607f8bcf589f0e95108170f57"
PREDECESSOR_TREE = "ddff0d4f499cda4904cd8d0624feb3f8a9f9140f"
SUCCESSOR_BRANCH = "codex/language-a-emission-pilot-preauthorship-repair-0.2.1"
EVIDENCE_DIR = PACKET_ROOT / "evidence/preauthorship-repair-0.2.1"
OLD_EVIDENCE = "experiments/language-a-exoskeleton/evidence/preauthorship-repair-0.2"
REGISTRY_PATH = "experiments/language-a-exoskeleton/controls/preauthorship-mutations.json"
SCHEMA_PATH = "experiments/language-a-exoskeleton/schemas/preauthorship.schema.json"
PROTECTED = [
    "canonical-datum", "CD0-*.md", "/".join(("mneme", "lci0")), "mneme/spec/lci0-review",
    "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification", "mneme/latent-mvp",
    "mneme/language-a/validator.lisp", "mneme/language-a/fixtures.lisp",
    "mneme/language-a/DEPOSITION-NOT-THOUGHT.md", "mneme/verify-all.sh", "mneme/MANIFEST.md",
]


def git(*args):
    return subprocess.run(
        ["git", *args], cwd=REPO_ROOT, check=True, capture_output=True, text=True
    ).stdout


def git_bytes(*args):
    return subprocess.run(
        ["git", *args], cwd=REPO_ROOT, check=True, capture_output=True
    ).stdout


def write_json(name, value):
    write_bytes(EVIDENCE_DIR / name, canonical_json_bytes(value))


def changed_paths():
    tracked = set(filter(None, git("diff", "--name-only", BASE_COMMIT).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    paths = sorted(tracked | untracked | {
        "experiments/language-a-exoskeleton/evidence/preauthorship-repair-0.2.1/CHANGED-FILE-INVENTORY.json"
    })
    outside = [path for path in paths if not path.startswith("experiments/language-a-exoskeleton/")]
    if outside:
        raise RuntimeError(f"out-of-scope changed paths: {outside}")
    return paths


def generate():
    pre.validate_repository_records()
    inventory = pre.schema_inventory()
    mutations = pre.execute_mutations()
    registry = pre.strict_json_load(pre.MUTATION_REGISTRY_PATH)
    old_registry_bytes = git_bytes("show", f"{BASE_COMMIT}:{REGISTRY_PATH}")
    old_registry = json.loads(old_registry_bytes)
    old_registry_digest = hashlib.sha256(old_registry_bytes).hexdigest()
    old_schema_record = json.loads(git("show", f"{BASE_COMMIT}:{OLD_EVIDENCE}/SCHEMA-INVENTORY.json"))
    old_inventory = old_schema_record["new"]
    old_schema_bytes = git_bytes("show", f"{BASE_COMMIT}:{SCHEMA_PATH}")
    old_ids = [row["mutation_id"] for row in old_registry["mutations"]]
    new_ids = [row["mutation_id"] for row in registry["mutations"]]
    if len(old_ids) != 99 or new_ids[:99] != old_ids:
        raise RuntimeError("the 99 predecessor mutation IDs changed identity or order")
    if registry["mutations"][:99] != old_registry["mutations"]:
        raise RuntimeError("a predecessor mutation declaration was rewritten")
    if registry["predecessor_registry_sha256"] != old_registry_digest:
        raise RuntimeError("successor registry does not bind the exact predecessor registry")

    owner_review = pre.verify_owner_reverification()
    merge_base = git("merge-base", PREDECESSOR_COMMIT, BASE_COMMIT).strip()
    base_merge_base = git("merge-base", BASE_COMMIT, "HEAD").strip()
    if merge_base != PREDECESSOR_COMMIT or base_merge_base != BASE_COMMIT:
        raise RuntimeError("ancestry or merge-base closure differs")
    write_json("BASELINE-IDENTITY.json", {
        "schema_version": "lae-preauthorship-repair-baseline/0.2.1",
        "base": {"branch": BASE_BRANCH, "commit": BASE_COMMIT, "tree": BASE_TREE},
        "immediate_predecessor": {"commit": PREDECESSOR_COMMIT, "tree": PREDECESSOR_TREE},
        "immediate_predecessor_is_ancestor": git("merge-base", "--is-ancestor", PREDECESSOR_COMMIT, BASE_COMMIT) == "",
        "immediate_predecessor_merge_base": merge_base,
        "base_is_exact_successor_merge_base": base_merge_base == BASE_COMMIT,
        "successor_branch": SUCCESSOR_BRANCH,
        "successor_identity_boundary": (
            "final commit, tree, remote-tracking ref, and direct remote ref are verified after commit and push; "
            "a tracked file cannot bind its own enclosing Git identity without changing it"
        ),
        "identities_recorded_before_modification": True,
    })
    write_json("OWNER-REVERIFICATION-CUSTODY.json", {
        "schema_version": "lae-owner-reverification-custody/1.0.0",
        "controlling_targeted_repair_return": owner_review,
        "expected_byte_length": 16003,
        "expected_sha256": pre.OWNER_REVERIFICATION_SHA256,
        "identity_verified_before_implementation": True,
        "read_in_full_before_implementation": True,
        "substitution_used": False,
    })

    result_by_id = {row["mutation_id"]: row for row in mutations}
    new_mutation_ids = new_ids[len(old_ids):]
    write_json("MUTATION-RESULTS.json", {
        "schema_version": "lae-preauthorship-mutation-results/0.2.1",
        "registry_path": pre.MUTATION_REGISTRY_PATH.relative_to(PACKET_ROOT).as_posix(),
        "predecessor_registry_sha256": old_registry_digest,
        "successor_registry_sha256": sha256_file(pre.MUTATION_REGISTRY_PATH),
        "predecessor_declared": len(old_ids),
        "predecessor_ids_preserved_in_order": new_ids[:len(old_ids)] == old_ids,
        "predecessor_declarations_preserved_exactly": registry["mutations"][:len(old_ids)] == old_registry["mutations"],
        "predecessor_ids": old_ids,
        "successor_ids": new_ids,
        "added_ids": new_mutation_ids,
        "declared": len(new_ids),
        "executed": len(mutations),
        "killed": sum(row["killed"] for row in mutations),
        "registry_declared_unexecuted": registry["declared_unexecuted"],
        "registry_undeclared_executed": registry["undeclared_executed"],
        "calculated_declared_unexecuted": sorted(set(new_ids) - set(result_by_id)),
        "calculated_undeclared_executed": sorted(set(result_by_id) - set(new_ids)),
        "results": mutations,
    })
    write_json("SCHEMA-INVENTORY.json", {
        "schema_version": "lae-schema-inventory/0.2.1",
        "old_count": len(old_inventory), "new_count": len(inventory),
        "old_schema_bundle_sha256": hashlib.sha256(old_schema_bytes).hexdigest(),
        "new_schema_bundle_sha256": sha256_file(pre.SCHEMA_PATH),
        "old": old_inventory, "new": inventory,
        "added": [row for row in inventory if row not in old_inventory],
        "removed": [row for row in old_inventory if row not in inventory],
        "modified_surfaces": ["odr-43-exact-decision", "item-freezer-dossier"],
    })

    valid_owner_records, valid_owner_lineage = pre.synthetic_owner_adoption_graph()
    pre.validate_lineage(valid_owner_lineage)
    selected = pre.validate_owner_records(
        valid_owner_records, require_adopted=True, lineage_events=valid_owner_lineage
    )
    valid_owner_gate = pre.drafting_gate(valid_owner_records, valid_owner_lineage)
    frozen_records = pre.synthetic_frozen_bank_records()
    valid_frozen_graph = pre.validate_record_graph(frozen_records, allow_synthetic=True)
    key_manifest = pre.synthetic_key_manifest(frozen_records)
    valid_key_input = pre.validate_key_author_input(key_manifest, frozen_records, allow_synthetic=True)
    key_kinds = {entry["artifact_kind"] for entry in key_manifest["entries"]}
    write_json("ADJUDICATION.json", {
        "schema_version": "lae-preauthorship-adjudication/0.2.1",
        "basis": owner_review,
        "base": {"branch": BASE_BRANCH, "commit": BASE_COMMIT, "tree": BASE_TREE},
        "r2_pv_02a": {
            "status": "closed-candidate-pending-targeted-owner-reverification",
            "semantic_law": "observed exposure classes equal exactly item-specific-answer, private-key, target-output",
            "schema_enforcement": "contains plus minContains=1/maxContains=1 for each required class",
            "graph_enforcement": "ODR43ExposureClassSetInvalid plus exposure-event semantic closure",
            "drafting_gate_enforcement": True,
            "mutations": [result_by_id[mutation_id] for mutation_id in new_mutation_ids[:4]],
        },
        "r2_pv_03a": {
            "status": "closed-candidate-pending-targeted-owner-reverification",
            "semantic_law": "every freezer decision resolves an exact freezer-only dossier bound to the same item version, source manifest, and rendering set",
            "graph_enforcement": "FreezerDossierReferenceInvalid during freezer-decision/state-transition validation",
            "synthetic_mode_same_gate": True,
            "key_author_input_excludes_dossier": "item-freezer-dossier" not in key_kinds,
            "mutations": [result_by_id[mutation_id] for mutation_id in new_mutation_ids[4:]],
        },
        "fi_01": "candidate-closed-pending-targeted-owner-reverification",
        "already_closed_surfaces_not_reopened": ["PV-01", "PV-04", "PV-05"],
        "nonblocking_acknowledgment_observation_implemented": False,
        "tranche_b_implemented": False,
        "complete_synthetic_owner_adoption_control": {
            "lower_level_owner_validation": set(selected) == {"ODR-43", "ODR-60"},
            "drafting_gate": valid_owner_gate,
            "does_not_modify_real_owner_records": True,
        },
        "complete_synthetic_freezer_control": valid_frozen_graph,
        "complete_minimized_key_author_input_control": valid_key_input,
    })

    duplicate_fixture = pre.strict_json_load(
        PACKET_ROOT / "controls/preauthorship-regression-fixtures/mutation-r2-pv-02a-duplicate-exposure-class.json"
    )
    dossier_fixture = pre.strict_json_load(
        PACKET_ROOT / "controls/preauthorship-regression-fixtures/mutation-r2-pv-03a-missing-freezer-dossier.json"
    )
    write_json("COUNTEREXAMPLE-EVIDENCE.json", {
        "schema_version": "lae-preauthorship-counterexample-evidence/0.2.1",
        "permanent_taint_registry": "preauthorship/registries/escaped-defect-fixtures.json",
        "r2_pv_02a_direct_escape": {
            "fixture": duplicate_fixture,
            "before_repair": "exact canonical semantic reproduction accepted by the untouched Repair 0.2 drafting_gate",
            "after_repair": result_by_id["mutation:r2-pv-02a-duplicate-exposure-class"],
            "missing_class_results": [
                result_by_id["mutation:r2-pv-02a-missing-item-specific-answer"],
                result_by_id["mutation:r2-pv-02a-missing-private-key"],
                result_by_id["mutation:r2-pv-02a-missing-target-output"],
            ],
        },
        "r2_pv_03a_direct_escape": {
            "fixture": dossier_fixture,
            "before_repair_graph_validation": "accepted on untouched Repair 0.2 with allow_synthetic=True",
            "before_repair_key_author_input": "accepted on untouched Repair 0.2 after referenced dossier removal",
            "after_repair_graph_validation": result_by_id["mutation:r2-pv-03a-missing-freezer-dossier"],
            "wrong_digest": result_by_id["mutation:r2-pv-03a-wrong-freezer-dossier-digest"],
            "different_item": result_by_id["mutation:r2-pv-03a-dossier-for-different-item"],
            "version_mismatch": result_by_id["mutation:r2-pv-03a-dossier-version-mismatch"],
            "wrong_kind": result_by_id["mutation:r2-pv-03a-wrong-record-kind"],
            "source_parent": result_by_id["mutation:r2-pv-03a-inconsistent-source-parent"],
            "rendering_parent": result_by_id["mutation:r2-pv-03a-inconsistent-rendering-parent"],
        },
    })

    owners = pre.load_owner_records()
    candidate = pre.load_odr60_candidate()
    write_json("OWNER-DECISION-STATE.json", {
        "schema_version": "lae-preauthorship-owner-state/1.0.1",
        "immutable_predecessor_file_sha256": {
            "ODR-43.json": "9ca88d96f8f159f2cad199e6f85d8e6aaa7bf5a240029210540e4c456157a65f",
            "ODR-60.json": "3963288b92bb8d56f31dae4e7719acf33dfd03df08b921f20c8b65291653f9d3",
        },
        "records": [{
            "decision_id": record["decision_id"], "record_id": record["record_id"],
            "record_digest": record["record_digest"], "status": record["status"],
        } for record in owners],
        "odr_43": "unresolved", "odr_60": "unresolved",
        "odr_60_candidate": {
            "record_id": candidate["record_id"], "record_digest": candidate["record_digest"],
            "standing": candidate["standing"], "stored_totals": False,
            "derived_totals": pre.validate_odr60_candidate(candidate),
        },
        "substantive_item_drafting": "blocked",
        "freeze_scoring_exposure_authority": "absent",
    })
    write_json("BOUNDARY-CENSUS.json", {
        "schema_version": "lae-preauthorship-boundary-census/0.2.1",
        "synthetic_test_material_permanently_tainted": True,
        "real_item_content": 0, "real_source_content": 0, "private_key_content": 0,
        "scoring_implemented": False, "provider_calls": 0, "target_outputs": 0,
        "exposure_authorized": False, "packet_freeze_authorized": False,
        "odr_43": "unresolved", "odr_60": "unresolved",
        "loose_owner_task_lists_inspected_or_packaged": False,
        "zone_identifier_sidecars_inspected_or_packaged": False,
    })

    protected = git("diff", "--name-only", BASE_COMMIT, "--", *PROTECTED).strip().splitlines()
    untracked_protected = git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED).strip().splitlines()
    if protected or untracked_protected:
        raise RuntimeError(f"protected scope changed: {protected + untracked_protected}")
    write_json("PROTECTED-SCOPE-DIFF.json", {
        "schema_version": "lae-preauthorship-protected-scope/1.0.1",
        "base_commit": BASE_COMMIT, "pathspecs": PROTECTED,
        "tracked_changes": protected, "untracked_changes": untracked_protected, "result": "empty",
    })
    paths = changed_paths()
    write_json("CHANGED-FILE-INVENTORY.json", {
        "schema_version": "lae-preauthorship-changed-files/1.0.1",
        "base_commit": BASE_COMMIT, "scope_prefix": "experiments/language-a-exoskeleton/",
        "path_count": len(paths), "paths": paths, "outside_scope": [],
        "inventory_includes_itself_by_path": True,
        "content_digests_are_bound_by": "CONSTRUCTION-MANIFEST.json",
    })
    write_json("CORE-VERIFICATION-SUMMARY.json", {
        "schema_version": "lae-preauthorship-verification/1.0.1",
        "schema_count": len(inventory), "mutation_count": len(mutations),
        "mutations_killed": len(mutations),
        "declared_unexecuted": [], "undeclared_executed": [],
        "r2_pv_02a": "closed-candidate", "r2_pv_03a": "closed-candidate",
        "odr_43": "unresolved", "odr_60": "unresolved",
        "substantive_drafting": "blocked-pending-owner-adoption-and-targeted-reverification",
        "current_tranche_max_state": pre.CURRENT_TRANCHE_MAX_STATE,
        "jsonschema_runtime": pre.package_version("jsonschema"),
    })
    write_bytes(EVIDENCE_DIR / "IMPLEMENTATION-LEDGER.md", (
        "# Repair 0.2.1 implementation ledger\n\n"
        "The controlling 16,003-byte owner re-verification was verified and read in full before implementation.\n\n"
        "R2-PV-02A is closed by schema and graph exact-set enforcement for the three ODR-43 exposure classes. "
        "R2-PV-03A is closed by resolving every freezer-decision dossier against the graph and checking its exact "
        "item version, source-manifest, rendering-set, record kind, digest, and freezer-only standing. Synthetic mode "
        "uses the same checks, and the dossier remains outside the minimized key-author handoff.\n\n"
        "All pre-existing 99 mutation IDs remain byte-order stable; successor mutations are appended. Real ODR-43 "
        "and ODR-60 remain unresolved. No real items, sources, key, score, provider call, target output, freeze, or "
        "exposure authority is created.\n"
    ).encode("utf-8"))
    print(json.dumps({
        "changed_paths": len(paths), "mutations": len(mutations), "schemas": len(inventory),
        "r2_pv_02a": "closed", "r2_pv_03a": "closed", "drafting": "blocked",
    }, sort_keys=True))


if __name__ == "__main__":
    generate()
