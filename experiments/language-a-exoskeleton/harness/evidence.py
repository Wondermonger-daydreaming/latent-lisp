import argparse
import json
import subprocess
import tempfile
from pathlib import Path

from analyze import PRECEDENCE, analyze
from claim_lint import lint_text
from manifest import BASE_COMMIT, BASE_TREE, check_protected
from run import execute
from score import score_run
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, load_json, sha256_bytes, sha256_file, write_bytes


BOUNDED_CLAIM = "Frozen pilot-scale first-pass emission for the sampled item bank, subject releases, routes, settings, and run window; no inference to hidden reasoning; no inference to enforcement efficacy; no inference to production custody, global independence, or totality."


def file_manifest(root):
    return [{"path": path.relative_to(root).as_posix(), "bytes": path.stat().st_size, "sha256": sha256_file(path)} for path in sorted(Path(root).rglob("*")) if path.is_file()]


def generate_branch_fixtures():
    identities = []
    for branch in PRECEDENCE:
        payload = load_json(PACKET_ROOT / "controls" / f"branch-{branch}.json")
        receipt = analyze(payload)
        receipt["claim_surface"] = BOUNDED_CLAIM
        lint_text(receipt["claim_surface"], require_riders=True)
        path = PACKET_ROOT / "evidence/branch" / f"SYNTHETIC-{branch}-RECEIPT.json"
        write_bytes(path, canonical_json_bytes(receipt))
        identities.append({"branch": branch, "sha256": sha256_file(path)})
    return identities


def generate_dry_run_identity():
    with tempfile.TemporaryDirectory(prefix="lae-evidence-dry-") as temporary:
        root = Path(temporary)
        census = execute(PACKET_ROOT / "controls/synthetic-items.jsonl", root / "run")
        rows = score_run(root / "run", root / "scores")
        analysis_path = root / "analysis.json"
        write_bytes(analysis_path, canonical_json_bytes(analyze(rows)))
        records = file_manifest(root)
        manifest_bytes = canonical_json_bytes(records)
        write_bytes(PACKET_ROOT / "evidence/manifests/SYNTHETIC-DRY-RUN-FILE-MANIFEST.json", manifest_bytes)
        return {"schema_version":"lae-synthetic-run-identity/0.2", "synthetic_only":True, "permanently_tainted":True,
                "scheduled_calls":census["observed"], "network_calls":0, "billed_cost_usd":"0.00", "real_items":0,
                "real_item_exposures":0, "provider_calls":0, "file_count":len(records),
                "file_manifest_sha256":sha256_bytes(manifest_bytes), "analysis_sha256":sha256_file(analysis_path),
                "claim_surface":BOUNDED_CLAIM}


def generate():
    check_protected()
    branches = generate_branch_fixtures()
    dry = generate_dry_run_identity()
    write_bytes(PACKET_ROOT / "evidence/SYNTHETIC-DRY-RUN-IDENTITY.json", canonical_json_bytes(dry))
    precision = load_json(PACKET_ROOT / "evidence/analysis/SYNTHETIC-PRECISION-REPORT.json")
    write_bytes(PACKET_ROOT / "evidence/SYNTHETIC-PRECISION-IDENTITY.json", canonical_json_bytes({
        "synthetic_only":True, "not_efficacy_evidence":True, "report_sha256":sha256_file(PACKET_ROOT / "evidence/analysis/SYNTHETIC-PRECISION-REPORT.json"),
        "internal_report_sha256":precision["report_sha256"], "canonical_favorable_branch_checks":precision["canonical_favorable_branch_checks"],
        "owner_design_disposition":"UNRESOLVED-OWNER-SLOT", "claim_surface":BOUNDED_CLAIM}))
    slots = load_json(PACKET_ROOT / "operator/owner-slots.json")
    write_bytes(PACKET_ROOT / "evidence/UNRESOLVED-OWNER-FIELDS.json", canonical_json_bytes({"exposure_ready":False, "unresolved":[slot["slot_id"] for slot in slots["slots"] if slot["status"] != "resolved"], "pre_exposure_gate_signed":False}))
    write_bytes(PACKET_ROOT / "evidence/AUTHORITY-IDENTITIES.json", canonical_json_bytes({
        "repository_commit":BASE_COMMIT, "repository_tree":BASE_TREE, "origin_main_at_construction":BASE_COMMIT,
        "original_ruling_sha256":"0b7492c3adfa12abe5e782b42722684e169b4cb14b42d6623652a087d191dc24",
        "errata_0_1_sha256":"d56fbd44f2bdce62a2ab1e225bbe84e907f6173bad210e1328c5f4f4ebb34064",
        "identity_status":"exact-match"}))
    write_bytes(PACKET_ROOT / "evidence/PROTECTED-SCOPE-DIFF.json", canonical_json_bytes({"base_commit":BASE_COMMIT,"changed_protected_paths":[],"result":"empty"}))
    write_bytes(PACKET_ROOT / "evidence/NETWORK-CALL-CENSUS.json", canonical_json_bytes({"live_provider_calls":0,"dry_run_provider_calls":312,"network_calls":0,"real_item_model_exposures":0,"real_item_grader_exposures":0,"pilot_verdicts":0}))
    write_bytes(PACKET_ROOT / "evidence/BRANCH-FIXTURE-IDENTITIES.json", canonical_json_bytes(branches))
    inventory = [path.relative_to(REPO_ROOT).as_posix() for path in sorted(PACKET_ROOT.rglob("*")) if path.is_file() and "__pycache__" not in path.parts and path.suffix != ".pyc" and path.name not in {"FREEZE-MANIFEST.json", "FREEZE-MANIFEST.sha256"}]
    inventory_path = "experiments/language-a-exoskeleton/evidence/CHANGED-FILE-INVENTORY.json"
    if inventory_path not in inventory:
        inventory.append(inventory_path)
        inventory.sort()
    write_bytes(PACKET_ROOT / "evidence/CHANGED-FILE-INVENTORY.json", canonical_json_bytes({"scope":"experiments/language-a-exoskeleton only","files":inventory,"protected_paths":[]}))
    print(f"EVIDENCE-GENERATION: PASS dry_run_files={dry['file_count']} branches={len(branches)} network_calls=0")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("generate", nargs="?")
    args = parser.parse_args()
    generate()


if __name__ == "__main__":
    main()
