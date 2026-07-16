"""Build and verify the append-only Language-A Tranche B item-bank freeze."""

from __future__ import annotations

import argparse
import copy
import importlib.metadata
import json
import platform
import subprocess
import sys
from datetime import datetime
from pathlib import Path

import tranche_b
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_bytes, sha256_file, write_bytes


AUTHORIZED_COMMIT = "7936095f8ce13174bdbb4e1b043a78f318a6bcf2"
AUTHORIZED_TREE = "b6255fcdfabf518f6b7397a8764bcb93d18e50e0"
SUCCESSOR_BRANCH = "codex/language-a-emission-pilot-tranche-b-item-bank-freeze"
FREEZE_ID = f"freeze:language-a-tranche-b-item-bank:{AUTHORIZED_COMMIT}"
EVIDENCE_ROOT = PACKET_ROOT / "evidence/tranche-b-item-bank-freeze"
MANIFEST_PATH = EVIDENCE_ROOT / "FREEZE-MANIFEST.json"
SIDECAR_PATH = EVIDENCE_ROOT / "FREEZE-MANIFEST.sha256"
VERIFICATION_PATH = EVIDENCE_ROOT / "FREEZE-VERIFICATION.json"
RECEIPT_PATH = EVIDENCE_ROOT / "PROOF-CARRYING-CHANGE.md"
SCRIPT_PATH = PACKET_ROOT / "harness/freeze_tranche_b.py"

FROZEN_SCOPE_PATHS = (
    "experiments/language-a-exoskeleton/items/candidate",
    "experiments/language-a-exoskeleton/tranche-b/freezer-only",
    "experiments/language-a-exoskeleton/tranche-b/schedule.jsonl",
    "experiments/language-a-exoskeleton/tranche-b/template-manifest.json",
    "experiments/language-a-exoskeleton/tranche-b/templates",
)
VERIFICATION_DEPENDENCY_PATHS = (
    "experiments/language-a-exoskeleton/operator/owner-decisions/ODR-60-ADOPTED-v2.json",
    "experiments/language-a-exoskeleton/schemas/tranche-b.schema.json",
    "experiments/language-a-exoskeleton/harness/tranche_b.py",
)
PROTECTED_PATHS = (
    "canonical-datum", "mneme/" + "lci0", "mneme/spec/" + "lci0-review",
    "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification",
    "mneme/latent-mvp", "mneme/language-a/validator.lisp",
    "mneme/language-a/fixtures.lisp", "mneme/language-a/DEPOSITION-NOT-THOUGHT.md",
    "mneme/verify-all.sh", "mneme/MANIFEST.md",
)
ALLOWED_SUCCESSOR_PATHS = {
    "experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json",
    "experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.sha256",
    "experiments/language-a-exoskeleton/harness/freeze_tranche_b.py",
    "experiments/language-a-exoskeleton/evidence/tranche-b-item-bank-freeze/FREEZE-MANIFEST.json",
    "experiments/language-a-exoskeleton/evidence/tranche-b-item-bank-freeze/FREEZE-MANIFEST.sha256",
    "experiments/language-a-exoskeleton/evidence/tranche-b-item-bank-freeze/FREEZE-VERIFICATION.json",
    "experiments/language-a-exoskeleton/evidence/tranche-b-item-bank-freeze/PROOF-CARRYING-CHANGE.md",
}
REQUEST_PARENT_FIELDS = (
    "bank_manifest_sha256", "item_id", "item_version",
    "target_visible_item_sha256", "target_surface_sha256", "task_sha256",
    "source_packet_manifest_sha256", "source_packet_sha256",
    "ordered_source_components", "arm", "template_manifest_sha256",
    "template_sha256", "system_sha256", "wrapper_sha256",
    "rendering_obligation_sha256", "renderer_version", "subject_slot",
)
BOUNDARIES = {
    "private_key_authorship_authorized": False,
    "private_key_custody_authorized": False,
    "target_scoring_authorized": False,
    "live_provider_calls_authorized": False,
    "live_exposure_authorized": False,
    "response_collection_authorized": False,
    "item_bank_modification_or_expansion_authorized": False,
    "template_modification_authorized": False,
    "schedule_modification_authorized": False,
    "merge_to_main_authorized": False,
    "release_or_production_deployment_authorized": False,
}


class FreezeVerificationError(RuntimeError):
    pass


def git(*args, check=True):
    result = subprocess.run(
        ["git", *map(str, args)], cwd=REPO_ROOT, check=check,
        capture_output=True, text=True,
    )
    return result.stdout.strip()


def repo_relative(path):
    return Path(path).resolve().relative_to(REPO_ROOT).as_posix()


def packet_relative(path):
    return Path(path).resolve().relative_to(PACKET_ROOT).as_posix()


def identity(path, category, frozen=True):
    relative = repo_relative(path)
    base_data = subprocess.run(
        ["git", "show", f"{AUTHORIZED_COMMIT}:{relative}"], cwd=REPO_ROOT,
        check=True, capture_output=True,
    ).stdout
    current_data = Path(path).read_bytes()
    if current_data != base_data:
        raise FreezeVerificationError(f"authorized candidate byte mismatch: {relative}")
    tree_line = git("ls-tree", "-l", AUTHORIZED_COMMIT, "--", relative)
    fields = tree_line.split(None, 4)
    if len(fields) != 5:
        raise FreezeVerificationError(f"authorized tree entry missing: {relative}")
    mode, object_type, object_id, size, observed_path = fields
    if observed_path != relative or int(size) != len(current_data):
        raise FreezeVerificationError(f"authorized tree metadata mismatch: {relative}")
    return {
        "path": relative,
        "category": category,
        "frozen": frozen,
        "git_mode": mode,
        "git_object_type": object_type,
        "git_blob_oid": object_id,
        "bytes": len(current_data),
        "sha256": sha256_bytes(current_data),
        "authorized_candidate_byte_identical": True,
    }


def frozen_category(relative):
    if "/items/candidate/" in relative:
        return "canonicalized-item-bank"
    if "/tranche-b/freezer-only/" in relative:
        return "canonicalized-item-bank-external-identity-only"
    if relative.endswith("/tranche-b/schedule.jsonl"):
        return "authoritative-312-cell-schedule"
    if relative.endswith("/tranche-b/template-manifest.json"):
        return "controlling-template-manifest"
    if "/tranche-b/templates/" in relative:
        return "controlling-template-bytes"
    raise FreezeVerificationError(f"unclassified frozen path: {relative}")


def authorized_frozen_paths():
    output = git("ls-tree", "-r", "--name-only", AUTHORIZED_COMMIT, "--", *FROZEN_SCOPE_PATHS)
    paths = [line for line in output.splitlines() if line]
    if len(paths) != 19 or len(paths) != len(set(paths)):
        raise FreezeVerificationError(f"authorized frozen inventory count differs: {len(paths)}")
    return paths


def frozen_inventory():
    return [
        identity(REPO_ROOT / relative, frozen_category(relative))
        for relative in authorized_frozen_paths()
    ]


def dependency_inventory():
    return [
        identity(REPO_ROOT / relative, "verification-dependency-not-newly-frozen", frozen=False)
        for relative in VERIFICATION_DEPENDENCY_PATHS
    ]


def environment_observables():
    sbcl = subprocess.run(["sbcl", "--version"], check=True, capture_output=True, text=True).stdout.strip()
    bash = subprocess.run(["bash", "--version"], check=True, capture_output=True, text=True).stdout.splitlines()[0]
    return {
        "python": sys.version.replace("\n", " "),
        "python_implementation": platform.python_implementation(),
        "platform": platform.platform(),
        "jsonschema": importlib.metadata.version("jsonschema"),
        "git": git("--version"),
        "sbcl": sbcl,
        "bash": bash,
        "network_mode": "off",
        "timezone": "UTC",
        "freeze_tool_path": repo_relative(SCRIPT_PATH),
        "freeze_tool_sha256": sha256_file(SCRIPT_PATH),
    }


def schedule_bindings(schedule):
    rows = []
    for row in schedule:
        recomputed = tranche_b.schedule_row_sha256(row)
        if row["schedule_row_sha256"] != recomputed:
            raise FreezeVerificationError(f"{row['call_id']}: schedule digest mismatch")
        rows.append({
            "schedule_index": row["schedule_index"],
            "call_id": row["call_id"],
            "schedule_row_sha256": recomputed,
            "request_parent_binding": {field: row[field] for field in REQUEST_PARENT_FIELDS},
        })
    return rows


def build_record(timestamp_utc, tool_environment):
    try:
        parsed_timestamp = datetime.fromisoformat(timestamp_utc.replace("Z", "+00:00"))
    except ValueError as exc:
        raise FreezeVerificationError(f"invalid freeze timestamp: {timestamp_utc}") from exc
    if parsed_timestamp.utcoffset() is None or parsed_timestamp.utcoffset().total_seconds() != 0:
        raise FreezeVerificationError("freeze timestamp must be UTC")

    observed_tree = git("rev-parse", f"{AUTHORIZED_COMMIT}^{{tree}}")
    if observed_tree != AUTHORIZED_TREE:
        raise FreezeVerificationError(
            f"authorized tree mismatch: expected={AUTHORIZED_TREE} observed={observed_tree}"
        )
    inventory = frozen_inventory()
    dependencies = dependency_inventory()
    bank = tranche_b.load_bank()
    template_manifest, _ = tranche_b.validate_template_files()
    schedule = tranche_b.strict_jsonl_load(tranche_b.SCHEDULE_PATH)
    tranche_b.validate_schedule(schedule, bank, template_manifest)
    bindings = schedule_bindings(schedule)
    inventory_by_path = {row["path"]: row for row in inventory}

    def frozen_identity(relative_packet_path):
        return inventory_by_path[
            "experiments/language-a-exoskeleton/" + relative_packet_path
        ]

    template_rows = []
    for entry in template_manifest["templates"]:
        artifact = frozen_identity(entry["path"])
        if artifact["bytes"] != entry["bytes"] or artifact["sha256"] != entry["sha256"]:
            raise FreezeVerificationError(f"template manifest binding differs: {entry['arm']}")
        template_rows.append({"arm": entry["arm"], "artifact": artifact})

    bank_manifest = bank["manifest"]
    owner_acceptance = bank["owner"]
    dossier_manifest = bank["dossier_manifest"]
    item_bank_artifacts = [row for row in inventory if row["category"].startswith("canonicalized-item-bank")]
    request_bindings = [row["request_parent_binding"] for row in bindings]
    schedule_digests = [row["schedule_row_sha256"] for row in bindings]
    return {
        "schema_version": "lae-tranche-b-item-bank-freeze/1.0.0",
        "freeze_id": FREEZE_ID,
        "state": "frozen-by-append-only-owner-authorization",
        "append_only": True,
        "authorization": {
            "authority": "owner",
            "title": "OWNER AUTHORIZATION — LANGUAGE-A TRANCHE B ITEM-BANK FREEZE",
            "controlling_review_disposition": "PASS — TRANCHE B CANDIDATE FREEZE-QUALITY VERIFIED",
            "authorized_candidate_commit": AUTHORIZED_COMMIT,
            "authorized_candidate_tree": AUTHORIZED_TREE,
            "authorized_successor_branch": SUCCESSOR_BRANCH,
            "authorized_scope": [
                "freeze the byte-identical canonicalized 24-item Tranche B bank",
                "freeze the byte-identical controlling template manifest and template bytes",
                "freeze the byte-identical authoritative 312-cell schedule and request-parent bindings",
                "add append-only freeze records, deterministic verification, and tracked evidence",
            ],
            "boundaries": BOUNDARIES,
        },
        "state_transition": {
            "method": "append-only-authoritative-freeze-record",
            "candidate_bytes_modified": False,
            "preserved_embedded_pre_authorization_state": {
                "bank_manifest_state": bank_manifest["state"],
                "bank_manifest_freeze_authorized": bank_manifest["freeze_authorized"],
                "owner_acceptance_item_freeze_authorized": owner_acceptance["authorizations"]["item_freeze"],
                "template_manifest_state": template_manifest["state"],
                "template_manifest_item_bank_freeze_authorized": template_manifest["item_bank_freeze_authorized"],
            },
            "temporal_interpretation": (
                "The embedded candidate flags are immutable pre-authorization history. "
                "This later owner-authorized record is the authoritative freeze transition."
            ),
        },
        "freeze_event": {
            "timestamp_utc": timestamp_utc,
            "tool_environment_observed_by_builder": tool_environment,
        },
        "frozen_artifact_inventory": inventory,
        "frozen_artifact_count": len(inventory),
        "frozen_artifact_inventory_sha256": sha256_bytes(canonical_json_bytes(inventory)),
        "item_bank": {
            "state": "frozen",
            "item_count": len(bank["targets"]),
            "item_ids": bank_manifest["item_ids"],
            "bank_manifest": frozen_identity("items/candidate/control-plane/bank-manifest.json"),
            "target_visible_items": frozen_identity("items/candidate/target-visible/items.jsonl"),
            "source_packet_manifests": frozen_identity("items/candidate/control-plane/source-packet-manifests.jsonl"),
            "rendering_obligations": frozen_identity("items/candidate/control-plane/rendering-obligations.jsonl"),
            "external_dossier_identity_records": frozen_identity("tranche-b/freezer-only/external-dossier-identities.jsonl"),
            "external_dossier_identity_manifest": frozen_identity("tranche-b/freezer-only/dossier-manifest.json"),
            "external_identity_records_contain_private_dossier_text": dossier_manifest["private_content_committed"],
            "artifact_set_sha256": sha256_bytes(canonical_json_bytes(item_bank_artifacts)),
        },
        "controlling_templates": {
            "state": "frozen",
            "template_manifest": frozen_identity("tranche-b/template-manifest.json"),
            "common_system": frozen_identity(template_manifest["system"]["path"]),
            "common_wrapper": frozen_identity(template_manifest["wrapper"]["path"]),
            "templates": template_rows,
            "template_set_sha256": sha256_bytes(canonical_json_bytes(template_rows)),
        },
        "authoritative_schedule": {
            "state": "frozen",
            "schedule_artifact": frozen_identity("tranche-b/schedule.jsonl"),
            "row_count": len(bindings),
            "unique_call_ids": len({row["call_id"] for row in bindings}),
            "unique_cells": len({
                (
                    row["request_parent_binding"]["item_id"],
                    row["request_parent_binding"]["arm"],
                    row["request_parent_binding"]["subject_slot"],
                )
                for row in bindings
            }),
            "schedule_row_digest_list_sha256": sha256_bytes(canonical_json_bytes(schedule_digests)),
            "request_parent_binding_list_sha256": sha256_bytes(canonical_json_bytes(request_bindings)),
            "rows": bindings,
        },
        "verification_dependencies_not_newly_frozen": {
            "artifacts": dependencies,
            "renderer_version": tranche_b.RENDERER_VERSION,
            "dependency_set_sha256": sha256_bytes(canonical_json_bytes(dependencies)),
        },
    }


def changed_paths():
    tracked = set(filter(None, git("diff", "--name-only", AUTHORIZED_COMMIT).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    return sorted(tracked | untracked)


def scope_changes(paths):
    tracked = git("diff", "--name-only", AUTHORIZED_COMMIT, "--", *paths, "CD0-*.md")
    untracked = git("ls-files", "--others", "--exclude-standard", "--", *paths)
    return sorted(filter(None, (tracked + "\n" + untracked).splitlines()))


def verify_git_boundary(require_complete=False):
    if git("rev-parse", f"{AUTHORIZED_COMMIT}^{{tree}}") != AUTHORIZED_TREE:
        raise FreezeVerificationError("authorized commit/tree cannot be reproduced")
    merge_base = git("merge-base", AUTHORIZED_COMMIT, "HEAD")
    if merge_base != AUTHORIZED_COMMIT:
        raise FreezeVerificationError(f"authorized candidate is not the merge base: {merge_base}")
    successor_count = int(git("rev-list", "--count", f"{AUTHORIZED_COMMIT}..HEAD"))
    if successor_count > 1:
        raise FreezeVerificationError(f"freeze branch contains {successor_count} successor commits")
    frozen_changes = scope_changes(FROZEN_SCOPE_PATHS)
    if frozen_changes:
        raise FreezeVerificationError(f"frozen candidate scope changed: {frozen_changes}")
    protected_changes = scope_changes(PROTECTED_PATHS)
    if protected_changes:
        raise FreezeVerificationError(f"protected scope changed: {protected_changes}")
    observed_changes = set(changed_paths())
    unexpected = sorted(observed_changes - ALLOWED_SUCCESSOR_PATHS)
    if unexpected:
        raise FreezeVerificationError(f"unexpected successor paths: {unexpected}")
    if require_complete and observed_changes != ALLOWED_SUCCESSOR_PATHS:
        missing = sorted(ALLOWED_SUCCESSOR_PATHS - observed_changes)
        raise FreezeVerificationError(f"incomplete successor inventory: {missing}")
    prior = subprocess.run(
        ["git", "cat-file", "-e", f"{AUTHORIZED_COMMIT}:{repo_relative(MANIFEST_PATH)}"],
        cwd=REPO_ROOT, capture_output=True,
    )
    if prior.returncode == 0:
        raise FreezeVerificationError("freeze manifest is not append-only relative to the authorized candidate")
    return {
        "authorized_commit": AUTHORIZED_COMMIT,
        "authorized_tree": AUTHORIZED_TREE,
        "merge_base": merge_base,
        "successor_commit_count": successor_count,
        "changed_paths": sorted(observed_changes),
        "frozen_scope_diff": frozen_changes,
        "protected_scope_diff": protected_changes,
    }


def validate_record(record):
    timestamp = record.get("freeze_event", {}).get("timestamp_utc", "")
    environment = record.get("freeze_event", {}).get("tool_environment_observed_by_builder")
    if not isinstance(environment, dict):
        raise FreezeVerificationError("freeze tool environment is missing")
    expected = build_record(timestamp, environment)
    if record != expected:
        raise FreezeVerificationError("freeze manifest differs from authoritative derivation")
    return expected


def build(timestamp):
    verify_git_boundary(require_complete=False)
    record = build_record(timestamp, environment_observables())
    data = canonical_json_bytes(record)
    write_bytes(MANIFEST_PATH, data)
    write_bytes(
        SIDECAR_PATH,
        f"{sha256_bytes(data)}  FREEZE-MANIFEST.json\n".encode("ascii"),
    )
    print(
        "TRANCHE-B-ITEM-BANK-FREEZE-BUILD: PASS "
        f"artifacts={record['frozen_artifact_count']} rows={record['authoritative_schedule']['row_count']}"
    )


def verify(require_complete=False):
    git_boundary = verify_git_boundary(require_complete=require_complete)
    data = MANIFEST_PATH.read_bytes()
    record = json.loads(data)
    if data != canonical_json_bytes(record):
        raise FreezeVerificationError("freeze manifest is not canonical JSON")
    expected_sidecar = f"{sha256_bytes(data)}  FREEZE-MANIFEST.json\n".encode("ascii")
    if SIDECAR_PATH.read_bytes() != expected_sidecar:
        raise FreezeVerificationError("freeze manifest sidecar differs")
    validate_record(record)
    print(
        "TRANCHE-B-ITEM-BANK-FREEZE-VERIFY: PASS "
        f"artifacts={record['frozen_artifact_count']} rows={record['authoritative_schedule']['row_count']} "
        f"protected_changes={len(git_boundary['protected_scope_diff'])}"
    )
    return record, git_boundary


def self_test():
    record, _ = verify(require_complete=False)
    mutations = []

    def add(label, mutate):
        candidate = copy.deepcopy(record)
        mutate(candidate)
        mutations.append((label, candidate))

    add("authorized-tree", lambda row: row["authorization"].__setitem__("authorized_candidate_tree", "0" * 40))
    add("inventory-omission", lambda row: row["frozen_artifact_inventory"].pop())
    add("artifact-digest", lambda row: row["frozen_artifact_inventory"][0].__setitem__("sha256", "0" * 64))
    add("schedule-row-digest", lambda row: row["authoritative_schedule"]["rows"][0].__setitem__("schedule_row_sha256", "0" * 64))
    add("request-parent", lambda row: row["authoritative_schedule"]["rows"][0]["request_parent_binding"].__setitem__("task_sha256", "0" * 64))
    add("authorization-boundary", lambda row: row["authorization"]["boundaries"].__setitem__("target_scoring_authorized", True))

    killed = []
    for label, candidate in mutations:
        try:
            validate_record(candidate)
        except FreezeVerificationError:
            killed.append(label)
        else:
            raise FreezeVerificationError(f"freeze self-test mutation survived: {label}")
    print(f"TRANCHE-B-ITEM-BANK-FREEZE-SELF-TEST: PASS {len(killed)}/{len(mutations)}")


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    build_parser = subparsers.add_parser("build")
    build_parser.add_argument("--timestamp", required=True)
    verify_parser = subparsers.add_parser("verify")
    verify_parser.add_argument("--require-complete", action="store_true")
    subparsers.add_parser("self-test")
    args = parser.parse_args()
    if args.command == "build":
        build(args.timestamp)
    elif args.command == "verify":
        verify(args.require_complete)
    else:
        self_test()


if __name__ == "__main__":
    main()
