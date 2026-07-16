import argparse
import json
import subprocess
from pathlib import Path

from conditions import (DanglingArtifactReference, DuplicateExperimentId, LineageSearchIncomplete,
                        ManifestMismatch, OwnerResolutionRequired, ProtectedScopeModified,
                        UnmanifestedFrozenArtifact)
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, load_json, load_jsonl, sha256_bytes, sha256_file, write_bytes
from preauthorship import validate_repository_records


BASE_COMMIT = "bcf76e78e597351e088a2fcec646230fa1deca60"
BASE_TREE = "9fd259ee678f338e4910d1fd68d5c2042c46e992"
REVIEWED_INPUT_COMMIT = "3e6fb3ef3125eee607f8bcf589f0e95108170f57"
REVIEWED_INPUT_TREE = "ddff0d4f499cda4904cd8d0624feb3f8a9f9140f"
PROTECTED = (
    "canonical-datum", "mneme/lci0", "mneme/spec/lci0-review", "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification", "mneme/latent-mvp", "mneme/language-a/validator.lisp",
    "mneme/language-a/fixtures.lisp", "mneme/language-a/DEPOSITION-NOT-THOUGHT.md", "mneme/verify-all.sh", "mneme/MANIFEST.md"
)


def packet_files(root=PACKET_ROOT):
    excluded = {"CONSTRUCTION-MANIFEST.json", "CONSTRUCTION-MANIFEST.sha256"}
    root = Path(root)
    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.name in excluded or "__pycache__" in path.parts or path.suffix == ".pyc":
            continue
        yield path


def build_manifest(root=PACKET_ROOT):
    records = []
    root = Path(root)
    for path in packet_files(root):
        relative = path.relative_to(root).as_posix()
        records.append({"path": relative, "bytes": path.stat().st_size, "sha256": sha256_file(path)})
    return {"schema_version": "lae-construction-manifest/1.1.0", "authority_commit": BASE_COMMIT, "authority_tree": BASE_TREE,
            "reviewed_input_commit": REVIEWED_INPUT_COMMIT, "reviewed_input_tree": REVIEWED_INPUT_TREE,
            "status": "PREAUTHORSHIP-REPAIR-0.2.1-CONSTRUCTION-CANDIDATE-NOT-FROZEN", "hash_semantics": "change detection only; not authenticity",
            "frozen_scope": ["README.md", "STATE-RECONCILIATION.md", "PREREG-v0.2.md", "FREEZE-RULINGS.md", "FREEZE-STAFFING.md",
                             "BRANCH-BANK.md", "verify-pilot.sh", "prompts", "items", "scoring", "harness", "controls", "lineage", "operator", "evidence"],
            "files": records}


def write_manifest(root=PACKET_ROOT):
    root = Path(root)
    data = canonical_json_bytes(build_manifest(root))
    write_bytes(root / "CONSTRUCTION-MANIFEST.json", data)
    write_bytes(root / "CONSTRUCTION-MANIFEST.sha256", (sha256_bytes(data) + "  CONSTRUCTION-MANIFEST.json\n").encode("ascii"))


def check_manifest(root=PACKET_ROOT):
    root = Path(root)
    manifest_path = root / "CONSTRUCTION-MANIFEST.json"
    data = manifest_path.read_bytes()
    expected_line = f"{sha256_bytes(data)}  CONSTRUCTION-MANIFEST.json\n".encode("ascii")
    if (root / "CONSTRUCTION-MANIFEST.sha256").read_bytes() != expected_line:
        raise ManifestMismatch("CONSTRUCTION-MANIFEST.sha256 differs")
    manifest = json.loads(data)
    listed = {record["path"]: record for record in manifest["files"]}
    actual = {path.relative_to(root).as_posix(): path for path in packet_files(root)}
    extra = sorted(set(actual) - set(listed))
    missing = sorted(set(listed) - set(actual))
    if extra:
        raise UnmanifestedFrozenArtifact(",".join(extra))
    if missing:
        raise ManifestMismatch("missing paths: " + ",".join(missing))
    for relative, record in listed.items():
        path = actual[relative]
        if path.stat().st_size != record["bytes"] or sha256_file(path) != record["sha256"]:
            raise ManifestMismatch(relative)
    if manifest["authority_commit"] != BASE_COMMIT or manifest["authority_tree"] != BASE_TREE:
        raise ManifestMismatch("authority identity differs")
    if manifest.get("reviewed_input_commit") != REVIEWED_INPUT_COMMIT or manifest.get("reviewed_input_tree") != REVIEWED_INPUT_TREE:
        raise ManifestMismatch("reviewed input identity differs")
    if manifest.get("status") != "PREAUTHORSHIP-REPAIR-0.2.1-CONSTRUCTION-CANDIDATE-NOT-FROZEN":
        raise ManifestMismatch("construction state differs")


def check_ids_and_references(root=PACKET_ROOT):
    root = Path(root)
    schedule = load_jsonl(root / "items/design/schedule.jsonl")
    call_ids = [row["call_id"] for row in schedule]
    if len(call_ids) != len(set(call_ids)):
        raise DuplicateExperimentId("schedule call_id")
    artifacts = load_jsonl(root / "lineage/artifacts.jsonl")
    actors = load_jsonl(root / "lineage/actors.jsonl")
    reads = load_jsonl(root / "lineage/reads.jsonl")
    transmissions = load_jsonl(root / "lineage/transmission-assertions.jsonl")
    bounds = load_jsonl(root / "lineage/lineage-bounds.jsonl")
    receipts = load_jsonl(root / "lineage/receipts.jsonl")
    actor_ids = {row["actor_id"] for row in actors}
    artifact_ids = {row["artifact_id"] for row in artifacts}
    read_ids = {row["read_id"] for row in reads}
    all_ids = [row["actor_id"] for row in actors] + [row["artifact_id"] for row in artifacts] + [row["read_id"] for row in reads]
    if len(all_ids) != len(set(all_ids)):
        raise DuplicateExperimentId("lineage")
    for row in artifacts:
        if not set(row.get("authored_by", [])).issubset(actor_ids):
            raise DanglingArtifactReference(row["artifact_id"])
    for row in reads:
        if row["reader"] not in actor_ids or row["artifact_id"] not in artifact_ids or row["delivered_by"] not in actor_ids:
            raise DanglingArtifactReference(row["read_id"])
    for row in transmissions:
        if not set(row.get("basis", [])).issubset(read_ids):
            raise DanglingArtifactReference(row["assertion_id"])
    for row in bounds:
        if not set(row["guaranteed_witness_subset"]).issubset(set(row["panel"])) or not row.get("upper_basis"):
            raise DanglingArtifactReference(row["bound_id"])
        if row["guaranteed_lower_bound"] != len(row["guaranteed_witness_subset"]) or row["possible_upper_bound"] < row["guaranteed_lower_bound"]:
            raise DanglingArtifactReference(row["bound_id"])
    for row in receipts:
        serialized = json.dumps(row).lower()
        if "independently corroborated" in serialized or not row.get("shared_roots") or not row.get("residual_unknowns"):
            raise DanglingArtifactReference(row["receipt_id"])


def check_protected():
    command = ["git", "diff", "--name-only", BASE_COMMIT, "--", *PROTECTED, "CD0-*.md"]
    changed = subprocess.run(command, cwd=REPO_ROOT, check=True, capture_output=True, text=True).stdout.strip()
    untracked = subprocess.run(["git", "ls-files", "--others", "--exclude-standard", "--", *PROTECTED], cwd=REPO_ROOT, check=True, capture_output=True, text=True).stdout.strip()
    if changed or untracked:
        raise ProtectedScopeModified(";".join(part for part in (changed, untracked) if part))


def exposure_readiness():
    slots = load_json(PACKET_ROOT / "operator/owner-slots.json")
    unresolved = [slot["slot_id"] for slot in slots["slots"] if slot.get("status") != "resolved"]
    if unresolved:
        raise OwnerResolutionRequired(",".join(unresolved))
    search = load_json(PACKET_ROOT / "lineage/search-field.json")
    if search.get("termination") != "complete":
        raise LineageSearchIncomplete(search.get("termination", "missing"))
    if not slots.get("pre_exposure_gate_signed"):
        raise OwnerResolutionRequired("pre-exposure-gate-signature")


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("build")
    sub.add_parser("check")
    sub.add_parser("protected")
    sub.add_parser("exposure-readiness")
    args = parser.parse_args()
    if args.command == "build":
        write_manifest()
    elif args.command == "check":
        check_manifest(); check_ids_and_references(); validate_repository_records(); check_protected()
    elif args.command == "protected":
        check_protected()
    elif args.command == "exposure-readiness":
        exposure_readiness()
    print(f"MANIFEST-{args.command.upper()}: PASS")


if __name__ == "__main__":
    main()
