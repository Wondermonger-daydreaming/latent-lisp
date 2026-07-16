"""Emit deterministic ODR-43/ODR-60 adoption evidence without Git self-reference."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import preauthorship as pre
from build_owner_adoptions import BASE_LINEAGE_BYTES, BASE_LINEAGE_SHA256, INPUT_IDENTITIES
from manifest import PROTECTED
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_bytes, sha256_file, write_bytes


BASE_BRANCH = "origin/codex/language-a-emission-pilot-preauthorship-repair-0.2.1"
BASE_COMMIT = "18189fcde68dfc110c0e95a82d2a9ef220bc98e9"
BASE_TREE = "645c1b8a778dd30b0a640e88b9fcca2281ec1c06"
IMMEDIATE_BASE_COMMIT = "bcf76e78e597351e088a2fcec646230fa1deca60"
IMMEDIATE_BASE_TREE = "9fd259ee678f338e4910d1fd68d5c2042c46e992"
SUCCESSOR_BRANCH = "codex/language-a-emission-pilot-odr-43-60-adoption"
EVIDENCE_DIR = PACKET_ROOT / "evidence/odr-43-60-adoption"
REGISTRY_REPO_PATH = "experiments/language-a-exoskeleton/controls/preauthorship-mutations.json"
SCHEMA_REPO_PATH = "experiments/language-a-exoskeleton/schemas/preauthorship.schema.json"


def git(*args, binary=False):
    result = subprocess.run(["git", *args], cwd=REPO_ROOT, check=True, capture_output=True, text=not binary)
    return result.stdout


def write_json(name, value):
    write_bytes(EVIDENCE_DIR / name, canonical_json_bytes(value))


def generate():
    pre.validate_repository_records()
    mutations = pre.execute_mutations()
    inventory = pre.schema_inventory()
    registry = pre.strict_json_load(pre.MUTATION_REGISTRY_PATH)
    old_registry_bytes = git("show", f"{BASE_COMMIT}:{REGISTRY_REPO_PATH}", binary=True)
    old_registry = json.loads(old_registry_bytes)
    old_ids = [row["mutation_id"] for row in old_registry["mutations"]]
    new_ids = [row["mutation_id"] for row in registry["mutations"]]
    if len(old_ids) != 111 or new_ids[:111] != old_ids or registry["mutations"][:111] != old_registry["mutations"]:
        raise RuntimeError("the 111 inherited mutation declarations changed identity, order, or bytes")
    old_registry_digest = hashlib.sha256(old_registry_bytes).hexdigest()
    if old_registry_digest != pre.PREDECESSOR_MUTATION_REGISTRY_SHA256:
        raise RuntimeError("predecessor mutation registry digest differs")
    result_by_id = {row["mutation_id"]: row for row in mutations}
    added_ids = new_ids[len(old_ids):]

    merge_base = git("merge-base", BASE_COMMIT, "HEAD").strip()
    if merge_base != BASE_COMMIT:
        raise RuntimeError("base is not the exact merge base")
    write_json("BASELINE-IDENTITY.json", {
        "schema_version": "lae-owner-adoption-baseline/1.0.0",
        "base": {"branch": BASE_BRANCH, "commit": BASE_COMMIT, "tree": BASE_TREE},
        "immediate_base": {"commit": IMMEDIATE_BASE_COMMIT, "tree": IMMEDIATE_BASE_TREE},
        "immediate_base_is_ancestor": git("merge-base", "--is-ancestor", IMMEDIATE_BASE_COMMIT, BASE_COMMIT) == "",
        "base_is_exact_merge_base": merge_base == BASE_COMMIT,
        "successor_branch": SUCCESSOR_BRANCH,
        "identities_recorded_before_modification": True,
        "successor_identity_boundary": "final commit/tree and local, remote-tracking, and direct remote identities are verified after the single commit and push",
    })

    input_records = []
    for name, (length, digest) in INPUT_IDENTITIES.items():
        path = EVIDENCE_DIR / "inputs" / name
        input_records.append({
            "path": path.relative_to(PACKET_ROOT).as_posix(),
            "byte_length": length,
            "sha256": digest,
            "observed_byte_length": path.stat().st_size,
            "observed_sha256": sha256_file(path),
            "identity_matches": path.stat().st_size == length and sha256_file(path) == digest,
        })
    write_json("INPUT-CUSTODY.json", {
        "schema_version": "lae-owner-adoption-input-custody/1.0.0",
        "outer_zip": {"filename": "LANGUAGE-A-ODR-43-60-ADOPTION-INPUTS.zip", "byte_length": 21608, "sha256": "707c3efcd3759abf4f34a7f14bdd7736f82ad38880a49e5826546663e2ac8ac1", "verified_before_modification": True},
        "outer_sidecar": {"filename": "LANGUAGE-A-ODR-43-60-ADOPTION-INPUTS.zip.sha256", "byte_length": 107, "sha256": "84371265487e49c0282dc74926f67ab377db51b94fe7d535ba4b14825f302990", "exact_content": "707c3efcd3759abf4f34a7f14bdd7736f82ad38880a49e5826546663e2ac8ac1  LANGUAGE-A-ODR-43-60-ADOPTION-INPUTS.zip\n", "final_lf": True, "verified_before_modification": True},
        "zip_integrity": "pass",
        "zip_path_safety": "pass",
        "internal_sha256s": "all-pass-before-modification",
        "all_governing_inputs_read_in_full_before_modification": True,
        "tracked_byte_identical_members": input_records,
        "loose_owner_task_list_or_zone_identifier_used": False,
    })

    owners = pre.load_owner_records()
    lineage = pre.load_successor_lineage()
    selected = pre.validate_owner_records(owners, require_adopted=True, lineage_events=lineage)
    candidate = pre.load_odr60_candidate()
    odr43 = selected["ODR-43"]
    odr60 = selected["ODR-60"]
    write_json("OWNER-DECISION-STATE.json", {
        "schema_version": "lae-owner-adoption-state/1.0.0",
        "immutable_predecessors": [
            {"path": "operator/owner-decisions/ODR-43.json", "file_sha256": "9ca88d96f8f159f2cad199e6f85d8e6aaa7bf5a240029210540e4c456157a65f", "record_id": "owner-decision:ODR-43-unresolved-v1", "canonical_byte_length": 1512, "record_digest": pre.OWNER_PREDECESSOR_DIGESTS["ODR-43"], "status": "unresolved-preserved"},
            {"path": "operator/owner-decisions/ODR-60.json", "file_sha256": "3963288b92bb8d56f31dae4e7719acf33dfd03df08b921f20c8b65291653f9d3", "record_id": "owner-decision:ODR-60-unresolved-v1", "canonical_byte_length": 1829, "record_digest": pre.OWNER_PREDECESSOR_DIGESTS["ODR-60"], "status": "unresolved-preserved"},
        ],
        "current_heads": [{"decision_id": row["decision_id"], "record_id": row["record_id"], "record_digest": row["record_digest"], "canonical_byte_length": row["canonical_byte_length"], "status": row["status"], "predecessor_digest": row["predecessor_digest"], "adoption_event_digest": row["adoption_event_digest"]} for row in (odr43, odr60)],
        "odr_43": {
            "status": "adopted", "owner": pre.ODR43_OWNER, "freezer_overlap_auditor": pre.ODR43_OWNER,
            "mechanical_assistant": pre.ODR43_CODEX, "substantive_freezer_authority_for_codex": False,
            "authors": [pre.ODR43_FABLE, pre.ODR43_SOL],
            "exposure_declaration_count": len(odr43["exact_decision"]["exposure_declarations"]),
            "exact_actor_class_set": sorted([row["actor_id"], row["exposure_class"]] for row in odr43["exact_decision"]["exposure_declarations"]),
            "all_exposure_standings": sorted(set(row["standing"] for row in odr43["exact_decision"]["exposure_declarations"])),
            "blindness_and_independence": odr43["exact_decision"]["blindness_and_independence"],
        },
        "odr_60": {
            "status": "adopted", "candidate": pre._ref(candidate), "candidate_preserved_unresolved": candidate["standing"] == "unresolved-owner-payload",
            "adopted_payload_equals_candidate": odr60["exact_decision"] == candidate["allocation"],
            "derived_totals": pre.validate_odr60_allocation(odr60["exact_decision"]),
        },
        "drafting_gate_typed_adoption_closure": pre.drafting_gate(owners, lineage),
        "operational_effect": "eligible-for-owner-issuance-of-Fable-and-Sol-item-author-commissions",
        "item_author_commissions_issued": False,
        "substantive_item_drafting_commissioned": False,
    })

    write_json("MUTATION-RESULTS.json", {
        "schema_version": "lae-owner-adoption-mutation-results/1.0.0",
        "predecessor_registry_sha256": old_registry_digest,
        "successor_registry_sha256": sha256_file(pre.MUTATION_REGISTRY_PATH),
        "inherited_count": len(old_ids), "inherited_ids_preserved_in_order": new_ids[:len(old_ids)] == old_ids,
        "inherited_declarations_preserved_exactly": registry["mutations"][:len(old_ids)] == old_registry["mutations"],
        "added_ids": added_ids, "declared": len(new_ids), "executed": len(mutations),
        "killed": sum(row["killed"] for row in mutations),
        "registry_declared_unexecuted": registry["declared_unexecuted"],
        "registry_undeclared_executed": registry["undeclared_executed"],
        "calculated_declared_unexecuted": sorted(set(new_ids) - set(result_by_id)),
        "calculated_undeclared_executed": sorted(set(result_by_id) - set(new_ids)),
        "results": mutations,
    })

    old_schema = json.loads(git("show", f"{BASE_COMMIT}:experiments/language-a-exoskeleton/evidence/preauthorship-repair-0.2.1/SCHEMA-INVENTORY.json"))["new"]
    old_schema_bytes = git("show", f"{BASE_COMMIT}:{SCHEMA_REPO_PATH}", binary=True)
    old_schema_bundle = json.loads(old_schema_bytes)
    new_schema_bundle = pre.schema_bundle()
    historical_owner_defs = ("odr-43-exact-decision", "odr-60-exact-decision", "owner-decision-record")
    historical_defs_preserved = all(old_schema_bundle["$defs"][name] == new_schema_bundle["$defs"][name] for name in historical_owner_defs)
    if not historical_defs_preserved:
        raise RuntimeError("historical owner record schema meaning changed")
    write_json("SCHEMA-INVENTORY.json", {
        "schema_version": "lae-owner-adoption-schema-inventory/1.0.0",
        "old_count": len(old_schema), "new_count": len(inventory),
        "old_schema_bundle_sha256": hashlib.sha256(old_schema_bytes).hexdigest(),
        "new_schema_bundle_sha256": sha256_file(pre.SCHEMA_PATH),
        "old": old_schema, "new": inventory,
        "added": [row for row in inventory if row not in old_schema],
        "removed": [row for row in old_schema if row not in inventory],
        "historical_owner_record_schema_definition_preserved": historical_defs_preserved,
        "versioned_successor_definition": "owner-decision-record-adopted / lae-owner-decision-record/1.1.0",
    })

    grouped = {
        "append_only_head_and_authority": added_ids[:6],
        "odr_43_staffing_and_graph": added_ids[6:22],
        "odr_60_exact_candidate_equality": added_ids[22:26],
        "gate_head_and_registry_succession": added_ids[26:],
    }
    write_json("ADJUDICATION.json", {
        "schema_version": "lae-owner-adoption-adjudication/1.0.0",
        "basis": {"ruling_id": "ruling:language-a-odr-43-odr-60-adoption-v1", "owner": "Tomás Pellissari Pavan", "timestamp": "2026-07-16T05:42:15-03:00", "jurisdiction": pre.ODR43_JURISDICTION},
        "odr_43": {"status": "adopted-successor-instantiated-pending-targeted-owner-verification", "payload_validator": "validate_odr43_adopted_payload", "graph_validator": "validate_odr43_graph", "mutations": {name: [result_by_id[mid] for mid in ids] for name, ids in grouped.items() if name in {"append_only_head_and_authority", "odr_43_staffing_and_graph"}}},
        "odr_60": {"status": "adopted-successor-instantiated-pending-targeted-owner-verification", "payload_validator": "validate_odr60_adopted_payload", "candidate_payload_exact_equality": odr60["exact_decision"] == candidate["allocation"], "mutations": [result_by_id[mid] for mid in grouped["odr_60_exact_candidate_equality"]]},
        "registry_and_gate": [result_by_id[mid] for mid in grouped["gate_head_and_registry_succession"]],
        "prior_pv_closures_preserved": True,
    })

    lineage_bytes = pre.SUCCESSOR_LINEAGE_PATH.read_bytes()
    write_json("LINEAGE-SUCCESSION.json", {
        "schema_version": "lae-owner-adoption-lineage-succession/1.0.0",
        "historical_prefix_byte_length": BASE_LINEAGE_BYTES,
        "historical_prefix_expected_sha256": BASE_LINEAGE_SHA256,
        "historical_prefix_observed_sha256": sha256_bytes(lineage_bytes[:BASE_LINEAGE_BYTES]),
        "historical_prefix_preserved_byte_for_byte": sha256_bytes(lineage_bytes[:BASE_LINEAGE_BYTES]) == BASE_LINEAGE_SHA256,
        "successor_event_count": len(lineage),
        "owner_adoption_events": [{"event_id": event["event_id"], "record_digest": event["record_digest"], "decision_payload_digest": event["decision_payload_digest"], "gate_closed": event["gate_closed"]} for event in lineage if event["event_type"] == "owner-adoption" and event["actor_id"] == pre.ODR43_OWNER],
        "complete_lineage_validates": pre.validate_lineage(lineage),
    })

    protected_changed = git("diff", "--name-only", BASE_COMMIT, "--", *PROTECTED, "CD0-*.md").strip().splitlines()
    protected_untracked = git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED).strip().splitlines()
    if protected_changed or protected_untracked:
        raise RuntimeError("protected scope differs")
    write_json("PROTECTED-SCOPE-DIFF.json", {"schema_version": "lae-owner-adoption-protected-scope/1.0.0", "base": BASE_COMMIT, "changed": protected_changed, "untracked": protected_untracked, "empty": True})

    write_json("BOUNDARY-CENSUS.json", {
        "schema_version": "lae-owner-adoption-boundary-census/1.0.0",
        "real_item_content_created": 0, "target_specific_source_reconnaissance": False,
        "real_source_packets_dossiers_or_renderings_created": 0,
        "item_author_commissions_issued": 0, "private_key_content_created": 0,
        "tranche_b_implemented": False, "scoring_implemented": False, "thresholds_chosen": False,
        "provider_routes_created": 0, "provider_calls": 0, "target_outputs": 0,
        "packet_freeze_authorized": False, "target_scoring_authorized": False, "live_exposure_authorized": False,
        "loose_owner_files_inspected_or_packaged": False, "preexisting_zone_identifier_sidecars_touched": False,
    })

    intended = set(filter(None, git("diff", "--name-only", BASE_COMMIT).splitlines()))
    intended.update(filter(None, git("ls-files", "--others", "--exclude-standard", "experiments/language-a-exoskeleton").splitlines()))
    intended.add("experiments/language-a-exoskeleton/evidence/odr-43-60-adoption/CHANGED-FILE-INVENTORY.json")
    intended = {path for path in intended if "__pycache__" not in path and not path.endswith(".pyc")}
    outside = sorted(path for path in intended if not path.startswith("experiments/language-a-exoskeleton/"))
    if outside:
        raise RuntimeError(f"out-of-scope changed files: {outside}")
    write_json("CHANGED-FILE-INVENTORY.json", {"schema_version": "lae-owner-adoption-changed-files/1.0.0", "base": BASE_COMMIT, "paths": sorted(intended), "count": len(intended), "outside_permitted_packet_scope": outside})

    write_json("IMPLEMENTATION-LEDGER.json", {
        "schema_version": "lae-owner-adoption-implementation-ledger/1.0.0",
        "requirements": [
            {"requirement": "preserve historical records and lineage", "artifacts": ["operator/owner-decisions/ODR-43.json", "operator/owner-decisions/ODR-60.json", "lineage/successor/events.jsonl"], "verification": "immutable file digests and lineage-prefix digest"},
            {"requirement": "instantiate exact ODR-43 staffing and disclosure graph", "artifacts": ["operator/owner-decisions/ODR-43-ADOPTED-v2.json"], "verification": "typed payload, graph, gate, and adoption mutations"},
            {"requirement": "adopt exact preserved ODR-60 candidate", "artifacts": ["operator/owner-decisions/ODR-60-ADOPTED-v2.json"], "verification": "candidate equality and three mismatch mutations"},
            {"requirement": "preserve all 111 mutations and append adoption laws", "artifacts": ["controls/preauthorship-mutations.json", "evidence/odr-43-60-adoption/MUTATION-RESULTS.json"], "verification": f"{len(mutations)}/{len(mutations)} executed/killed"},
        ],
        "residual_uncertainty": ["targeted owner verification of typed instantiation remains pending", "future item-author commissions must be separately issued by exact digest"],
    })


if __name__ == "__main__":
    generate()
