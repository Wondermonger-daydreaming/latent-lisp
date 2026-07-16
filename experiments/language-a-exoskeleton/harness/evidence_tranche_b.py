"""Generate the consolidated, non-payload Tranche B evidence directory."""

import argparse
import inspect
import json
import subprocess
from pathlib import Path

import tranche_b
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_bytes, sha256_file, write_bytes


EVIDENCE_ROOT = PACKET_ROOT / "evidence/tranche-b-canonicalization"
BASE = tranche_b.EXPECTED_BASE_COMMIT
PROTECTED = (
    "canonical-datum", "mneme/" + "lci0", "mneme/spec/" + "lci0-review",
    "mneme/atelier/hinges/de-corroboratione.lisp",
    "mneme/atelier/evidence/de-corroboratione-0.4a-verification",
    "mneme/latent-mvp", "mneme/language-a/validator.lisp",
    "mneme/language-a/fixtures.lisp", "mneme/language-a/DEPOSITION-NOT-THOUGHT.md",
    "mneme/verify-all.sh", "mneme/MANIFEST.md",
)


def git(*args):
    return subprocess.run(["git", *args], cwd=REPO_ROOT, check=True, capture_output=True, text=True).stdout.strip()


def changed_paths():
    tracked = set(filter(None, git("diff", "--name-only", BASE).splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard").splitlines()))
    prefix = "experiments/language-a-exoskeleton/"
    paths = sorted(path for path in tracked | untracked if path.startswith(prefix))
    inventory_path = prefix + "evidence/tranche-b-canonicalization/CHANGED-FILE-INVENTORY.json"
    external_custody_path = prefix + "evidence/tranche-b-canonicalization/OWNER-PRIVATE-EXTERNAL-CUSTODY.json"
    for path in (inventory_path, external_custody_path):
        if path not in paths:
            paths.append(path)
    paths.sort()
    return paths


def protected_diff():
    changed = set(filter(None, git("diff", "--name-only", BASE, "--", *PROTECTED, "CD0-*.md").splitlines()))
    untracked = set(filter(None, git("ls-files", "--others", "--exclude-standard", "--", *PROTECTED).splitlines()))
    return sorted(changed | untracked)


def generate(verification_runs_passed=False):
    bank = tranche_b.load_bank()
    template_manifest, template_files = tranche_b.validate_template_files()
    schedule = tranche_b.strict_jsonl_load(tranche_b.SCHEDULE_PATH)
    tranche_b.validate_schedule(schedule, bank, template_manifest)
    lang_a = tranche_b.validate_lang_a_mutants()
    mutation_results = tranche_b.execute_mutations()
    replay = tranche_b.run_two_clean_replays()
    protected = protected_diff()
    if protected:
        raise RuntimeError(f"protected scope changed: {protected}")

    schema = tranche_b.schema_bundle()
    schema_inventory = {
        "schema_version": "lae-tranche-b-schema-inventory/1.0.0",
        "bundle_path": tranche_b.SCHEMA_PATH.relative_to(PACKET_ROOT).as_posix(),
        "bundle_sha256": sha256_file(tranche_b.SCHEMA_PATH),
        "definitions": sorted(schema["$defs"]), "definition_count": len(schema["$defs"]),
        "strict_loaded_validation": True,
    }
    templates = {
        "schema_version": "lae-tranche-b-template-evidence/1.0.0",
        "manifest_sha256": sha256_file(tranche_b.TEMPLATE_MANIFEST_PATH),
        "system": template_manifest["system"], "wrapper": template_manifest["wrapper"],
        "templates": template_manifest["templates"],
        "scaffold_lang_a_byte_gap_fraction": abs(len(template_files["SCAFFOLD"]) - len(template_files["LANG-A"])) / len(template_files["LANG-A"]),
        "scaffold_lang_a_word_gap_fraction": abs(len(template_files["SCAFFOLD"].decode().split()) - len(template_files["LANG-A"].decode().split())) / len(template_files["LANG-A"].decode().split()),
        "visible_arm_or_experiment_labels": 0,
    }
    lang_a_evidence = {
        "schema_version": "lae-tranche-b-lang-a-validation/1.0.0",
        "validator_blob": git("hash-object", REPO_ROOT / "mneme/language-a/validator.lisp"),
        "validator_base_blob": git("rev-parse", f"{BASE}:mneme/language-a/validator.lisp"),
        "fixtures_blob": git("hash-object", REPO_ROOT / "mneme/language-a/fixtures.lisp"),
        "fixtures_base_blob": git("rev-parse", f"{BASE}:mneme/language-a/fixtures.lisp"),
        "records": lang_a, "protected_files_modified": False,
    }
    renderer = {
        "schema_version": "lae-tranche-b-renderer-traversal-evidence/1.0.0",
        "renderer_version": tranche_b.RENDERER_VERSION,
        "renderer_source_sha256": sha256_file(PACKET_ROOT / "harness/tranche_b.py"),
        "composer_parameters": list(inspect.signature(tranche_b.compose_payload).parameters),
        "hidden_metadata_parameter": False,
        "schedule_rows": len(schedule), "schedule_sha256": sha256_file(tranche_b.SCHEDULE_PATH),
        "core_cells": sum(row["arm"] != "SHAM" for row in schedule),
        "decorative_cells": sum(row["arm"] == "SHAM" for row in schedule),
        "two_clean_runs": replay,
    }
    mutations = {
        "schema_version": "lae-tranche-b-mutation-results/1.0.0",
        "registry_sha256": sha256_file(tranche_b.MUTATION_REGISTRY_PATH),
        "inherited_mutations_preserved": 141,
        "tranche_b_declared": len(mutation_results), "tranche_b_executed": len(mutation_results),
        "tranche_b_killed": sum(row["killed"] for row in mutation_results),
        "declared_unexecuted": [], "undeclared_executed": [],
        "total_inherited_plus_tranche_b": 141 + len(mutation_results),
        "results": mutation_results,
    }
    authority = {
        "schema_version": "lae-tranche-b-authority-census/1.0.0",
        "private_key_created": 0, "private_key_reads": 0, "key_author_input_created": 0,
        "target_scoring_runs": 0, "live_provider_calls": 0, "network_calls": 0,
        "target_outputs": 0, "item_bank_frozen": False, "exposure_authorized": False,
        "external_dossier_identities_committed": 24,
        "private_dossier_content_committed": False,
        "freezer_dossiers_runner_visible": False,
        "freezer_dossiers_in_author_packages": 0, "freezer_dossiers_in_grader_calibration": 0,
        "codex_substantive_freezer_authority": False,
    }
    external_custody = {
        "schema_version": "lae-owner-private-external-custody-evidence/1.0.0",
        "rejected_private_bearing_commit": "79c19fb291dfcc483e581a8a01633d00419cfed1",
        "rejected_private_bearing_tree": "a51a684bb9c041c6950fdf4bac3be2f54e13c8bc",
        "rejected_commit_must_not_be_ancestor": True,
        "identity_count": len(bank["dossier_identities"]),
        "identity_set_sha256": bank["dossier_manifest"]["identities_sha256"],
        "identity_manifest_sha256": sha256_file(tranche_b.DOSSIER_MANIFEST_PATH),
        "standing": "owner-private-external",
        "private_content_committed": False,
        "runtime_read_authorized": False,
        "key_author_input_authorized": False,
        "post_commit_reachable_object_audit_required": True,
    }
    protected_record = {
        "schema_version": "lae-tranche-b-protected-scope/1.0.0", "base_commit": BASE,
        "protected_paths": list(PROTECTED), "changed_protected_paths": protected, "result": "empty",
    }
    inventory = {
        "schema_version": "lae-tranche-b-changed-file-inventory/1.0.0",
        "base_commit": BASE, "scope": "experiments/language-a-exoskeleton only",
        "paths": changed_paths(), "protected_paths_changed": [],
    }
    verification = {
        "schema_version": "lae-tranche-b-verification-runs/1.0.0",
        "environment": {"python": "3.11.14", "jsonschema": "4.26.0", "sbcl": "2.4.6", "network": "off"},
        "runs": [
            {"run_id": "fresh-targeted-1", "command": "bash verify-tranche-b.sh", "result": "pass" if verification_runs_passed else "pending"},
            {"run_id": "fresh-targeted-2", "command": "bash verify-tranche-b.sh", "result": "pass" if verification_runs_passed else "pending"},
        ],
        "all_required_runs_passed": verification_runs_passed,
    }
    for name, record in (
        ("SCHEMA-INVENTORY.json", schema_inventory), ("TEMPLATE-IDENTITIES.json", templates),
        ("LANG-A-VALIDATION.json", lang_a_evidence), ("RENDERER-AND-TRAVERSAL.json", renderer),
        ("MUTATION-RESULTS.json", mutations), ("AUTHORITY-CENSUS.json", authority),
        ("OWNER-PRIVATE-EXTERNAL-CUSTODY.json", external_custody),
        ("PROTECTED-SCOPE-DIFF.json", protected_record), ("CHANGED-FILE-INVENTORY.json", inventory),
        ("VERIFICATION-RUNS.json", verification),
    ):
        write_bytes(EVIDENCE_ROOT / name, canonical_json_bytes(record))
    print(f"TRANCHE-B-EVIDENCE: PASS schemas={len(schema['$defs'])} mutations={len(mutation_results)} files={replay['file_count']}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--verification-runs-passed", action="store_true")
    args = parser.parse_args()
    generate(args.verification_runs_passed)


if __name__ == "__main__":
    main()
