"""Build and verify the append-only scoring-constitution freeze (SCORING-CONSTITUTION.md §13).

Patterned on ``freeze_tranche_b.py``: derives a SCORING-FREEZE-MANIFEST binding (a) the §0
frozen-bank identities, (b) the scoring artifact inventory with path/bytes/sha256, (c) schema
identities, (d) the fixture and mutation inventories, (e) aggregate canonical identities, (f)
the authorized parent commit+tree (CLI args), (g) authorization boundaries + the no-live-
response statement (§13), and (h) the unresolved owner-slot inventory at freeze time.

Subcommands: ``derive`` (chair runs it post-commit with the candidate commit id), ``verify``
(recompute + compare), ``self-test`` (tamper controls over an in-memory derived record).
"""

from __future__ import annotations

import argparse
import copy
import importlib.metadata
import json
import platform
import sys
from datetime import datetime
from pathlib import Path

import scoring_constitution as sc
from util import PACKET_ROOT, canonical_json_bytes, load_json, sha256_bytes, sha256_file, write_bytes


EVIDENCE_ROOT = PACKET_ROOT / "evidence/scoring-constitution-freeze"
MANIFEST_PATH = EVIDENCE_ROOT / "SCORING-FREEZE-MANIFEST.json"
SIDECAR_PATH = EVIDENCE_ROOT / "SCORING-FREEZE-MANIFEST.sha256"
SCRIPT_PATH = PACKET_ROOT / "harness/freeze_scoring_constitution.py"
FIXTURE_DIR = PACKET_ROOT / "controls/scoring-constitution-fixtures"

SCORING_ARTIFACTS = (
    "SCORING-CONSTITUTION.md",
    "harness/scoring_constitution.py",
    "harness/freeze_scoring_constitution.py",
    "operator/scoring-owner-slots.json",
    "controls/scoring-constitution-mutations.json",
    "tests/test_scoring_constitution.py",
    "verify-scoring-constitution.sh",
)
SCHEMA_ARTIFACTS = ("harness/request_schema.json", "harness/response_schema.json")
BOUNDARIES = {
    "live_scoring_authorized": False,
    "live_provider_calls_authorized": False,
    "private_key_authorship_authorized": False,
    "private_key_custody_authorized": False,
    "live_exposure_authorized": False,
    "response_collection_authorized": False,
    "item_bank_modification_or_expansion_authorized": False,
    "merge_to_main_authorized": False,
    "release_or_production_deployment_authorized": False,
}
NO_LIVE_RESPONSE_STATEMENT = (
    "No live or pilot-produced model response was inspected at any point in this work; "
    "none exists in the repository or was available to its authors (SCORING-CONSTITUTION.md §13/§16)."
)


class FreezeScoringVerificationError(RuntimeError):
    pass


def _artifact_identity(packet_relative, category, frozen=True):
    path = PACKET_ROOT / packet_relative
    data = path.read_bytes()
    return {"path": packet_relative, "category": category, "frozen": frozen,
            "bytes": len(data), "sha256": sha256_bytes(data)}


def _fixture_inventory():
    rows = []
    for path in sorted(FIXTURE_DIR.glob("*.json")):
        data = path.read_bytes()
        rows.append({"file": path.name, "bytes": len(data), "sha256": sha256_bytes(data)})
    return rows


def _mutation_inventory():
    registry = load_json(sc.MUTATION_REGISTRY_PATH)
    return [{"id": row["id"], "expected_condition": row["expected_condition"]} for row in registry["mutations"]]


def _environment_observables():
    try:
        jsonschema_version = importlib.metadata.version("jsonschema")
    except Exception:
        jsonschema_version = "absent"
    return {
        "python": sys.version.replace("\n", " "),
        "python_implementation": platform.python_implementation(),
        "platform": platform.platform(),
        "jsonschema": jsonschema_version,
        "network_mode": "off",
        "timezone": "UTC",
        "freeze_tool_path": "harness/freeze_scoring_constitution.py",
        "freeze_tool_sha256": sha256_file(SCRIPT_PATH),
    }


def build_record(parent_commit, parent_tree, timestamp_utc, environment):
    try:
        parsed = datetime.fromisoformat(timestamp_utc.replace("Z", "+00:00"))
    except ValueError as exc:
        raise FreezeScoringVerificationError(f"invalid freeze timestamp: {timestamp_utc}") from exc
    if parsed.utcoffset() is None or parsed.utcoffset().total_seconds() != 0:
        raise FreezeScoringVerificationError("freeze timestamp must be UTC")

    artifacts = [_artifact_identity(rel, "scoring-artifact") for rel in SCORING_ARTIFACTS]
    artifacts += [_artifact_identity(rel, "frozen-envelope-schema", frozen=True) for rel in SCHEMA_ARTIFACTS]
    fixtures = _fixture_inventory()  # includes INDEX.json (a *.json in the fixture dir)
    mutations = _mutation_inventory()
    slot_register = load_json(PACKET_ROOT / "operator/scoring-owner-slots.json")
    unresolved = sc.unresolved_scoring_slots(PACKET_ROOT.parents[1])

    aggregate = {
        "artifact_inventory_sha256": sha256_bytes(canonical_json_bytes(artifacts)),
        "fixture_digest_list_sha256": sha256_bytes(canonical_json_bytes(fixtures)),
        "mutation_registry_sha256": sha256_bytes(canonical_json_bytes(mutations)),
        "slot_register_sha256": sha256_bytes(canonical_json_bytes(slot_register)),
    }
    return {
        "schema_version": "lae-scoring-constitution-freeze/1.0.0",
        "freeze_id": f"freeze:language-a-tranche-b-scoring-constitution:{parent_commit}",
        "state": "frozen-by-append-only-owner-authorization",
        "append_only": True,
        "constitution_version": sc.CONSTITUTION_VERSION,
        "frozen_bank_binding": {
            "bank_commit": sc.FROZEN_BANK_COMMIT,
            "bank_tree": sc.FROZEN_BANK_TREE,
            "freeze_manifest_sha256": sc.FROZEN_FREEZE_MANIFEST_SHA256,
            "schedule_blob": sc.FROZEN_SCHEDULE_BLOB,
            "schedule_row_digest_list_sha256": sc.FROZEN_SCHEDULE_ROW_DIGEST_LIST_SHA256,
            "request_parent_binding_list_sha256": sc.FROZEN_REQUEST_PARENT_BINDING_LIST_SHA256,
        },
        "authorized_parent_commit": parent_commit,
        "authorized_parent_tree": parent_tree,
        "authorization": {
            "authority": "owner",
            "title": "OWNER AUTHORIZATION — LANGUAGE-A TRANCHE B SCORING-CONSTITUTION",
            "authorized_scope": [
                "add the machine-checkable scoring constitution module and its freeze record",
                "add the synthetic fixture corpus and mutation registry",
                "add pre-exposure verification; no live scoring, no provider calls, no key authorship",
            ],
            "boundaries": BOUNDARIES,
            "no_live_response_statement": NO_LIVE_RESPONSE_STATEMENT,
        },
        "freeze_event": {"timestamp_utc": timestamp_utc, "tool_environment_observed_by_builder": environment},
        "scoring_artifact_inventory": artifacts,
        "scoring_artifact_count": len(artifacts),
        "schema_identities": {
            "record_schemas": sc.LEVELS,
            "input_schema": sc.SCHEMA_INPUT,
            "request_schema": _artifact_identity("harness/request_schema.json", "frozen-envelope-schema", frozen=True),
            "response_schema": _artifact_identity("harness/response_schema.json", "frozen-envelope-schema", frozen=True),
        },
        "fixture_inventory": fixtures,
        "fixture_count": len(fixtures),
        "mutation_inventory": mutations,
        "mutation_count": len(mutations),
        "aggregate_canonical_identities": aggregate,
        "unresolved_owner_slots_at_freeze": unresolved,
        "unresolved_owner_slot_count": len(unresolved),
    }


def validate_record(record):
    parent_commit = record.get("authorized_parent_commit")
    parent_tree = record.get("authorized_parent_tree")
    timestamp = record.get("freeze_event", {}).get("timestamp_utc", "")
    environment = record.get("freeze_event", {}).get("tool_environment_observed_by_builder")
    if not isinstance(environment, dict):
        raise FreezeScoringVerificationError("freeze tool environment is missing")
    expected = build_record(parent_commit, parent_tree, timestamp, environment)
    if record != expected:
        raise FreezeScoringVerificationError("scoring freeze manifest differs from authoritative derivation")
    return expected


def derive(parent_commit, parent_tree, timestamp):
    record = build_record(parent_commit, parent_tree, timestamp, _environment_observables())
    data = canonical_json_bytes(record)
    write_bytes(MANIFEST_PATH, data)
    write_bytes(SIDECAR_PATH, f"{sha256_bytes(data)}  SCORING-FREEZE-MANIFEST.json\n".encode("ascii"))
    print(f"SCORING-CONSTITUTION-FREEZE-DERIVE: PASS artifacts={record['scoring_artifact_count']} "
          f"fixtures={record['fixture_count']} mutations={record['mutation_count']}")


def verify():
    data = MANIFEST_PATH.read_bytes()
    record = json.loads(data)
    if data != canonical_json_bytes(record):
        raise FreezeScoringVerificationError("scoring freeze manifest is not canonical JSON")
    expected_sidecar = f"{sha256_bytes(data)}  SCORING-FREEZE-MANIFEST.json\n".encode("ascii")
    if SIDECAR_PATH.read_bytes() != expected_sidecar:
        raise FreezeScoringVerificationError("scoring freeze manifest sidecar differs")
    validate_record(record)
    print(f"SCORING-CONSTITUTION-FREEZE-VERIFY: PASS artifacts={record['scoring_artifact_count']} "
          f"slots-unresolved={record['unresolved_owner_slot_count']}")
    return record


def self_test():
    # Derive an in-memory record with placeholder parent args (no git; §13 chair runs derive post-commit).
    record = build_record("0" * 40, "0" * 40, "2026-07-16T00:00:00Z", _environment_observables())
    mutations = []

    def add(label, mutate):
        candidate = copy.deepcopy(record)
        mutate(candidate)
        mutations.append((label, candidate))

    add("inventory-omission", lambda row: row["scoring_artifact_inventory"].pop())
    add("artifact-digest-change", lambda row: row["scoring_artifact_inventory"][0].__setitem__("sha256", "0" * 64))
    add("bank-binding-change", lambda row: row["frozen_bank_binding"].__setitem__("freeze_manifest_sha256", "0" * 64))
    add("slot-status-forgery", lambda row: row.__setitem__("unresolved_owner_slot_count", 0))
    add("aggregate-drift", lambda row: row["aggregate_canonical_identities"].__setitem__("fixture_digest_list_sha256", "0" * 64))
    add("boundary-expansion", lambda row: row["authorization"]["boundaries"].__setitem__("live_scoring_authorized", True))

    killed = []
    for label, candidate in mutations:
        try:
            validate_record(candidate)
        except FreezeScoringVerificationError:
            killed.append(label)
        else:
            raise FreezeScoringVerificationError(f"scoring freeze self-test mutation survived: {label}")
    print(f"SCORING-CONSTITUTION-FREEZE-SELF-TEST: PASS {len(killed)}/{len(mutations)}")


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    derive_parser = subparsers.add_parser("derive")
    derive_parser.add_argument("--parent-commit", required=True)
    derive_parser.add_argument("--parent-tree", required=True)
    derive_parser.add_argument("--timestamp", required=True)
    subparsers.add_parser("verify")
    subparsers.add_parser("self-test")
    args = parser.parse_args()
    if args.command == "derive":
        derive(args.parent_commit, args.parent_tree, args.timestamp)
    elif args.command == "verify":
        verify()
    else:
        self_test()


if __name__ == "__main__":
    main()
