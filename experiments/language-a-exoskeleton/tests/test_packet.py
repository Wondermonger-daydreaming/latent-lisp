import copy
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT / "harness"
sys.path.insert(0, str(HARNESS))

import analyze
import claim_lint
import design
import firebreak
import manifest
import run
import score
import sham
import validate_output
from conditions import *
from util import canonical_json_bytes, load_json, load_jsonl


class PacketTests(unittest.TestCase):
    maxDiff = None

    def copy_packet(self):
        context = tempfile.TemporaryDirectory(prefix="lae-packet-test-")
        target = Path(context.name) / "packet"
        shutil.copytree(ROOT, target, ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
        return context, target

    def test_design_and_schedule_reproduce(self):
        schedule, counts = design.generate(load_json(ROOT / "items/design/design.json"))
        self.assertEqual(24, counts["items"])
        self.assertEqual(312, counts["scheduled_calls"])
        self.assertEqual(288, counts["core_cells"])
        self.assertEqual(24, counts["sham_cells"])
        self.assertEqual(312, len(schedule))
        design.write_generated(ROOT / "items/design/design.json", ROOT / "items/design/schedule.jsonl", ROOT / "items/design/generated-counts.json", check=True)

    def test_schedule_mutation_refused(self):
        with tempfile.TemporaryDirectory() as temporary:
            schedule = Path(temporary) / "schedule.jsonl"
            counts = Path(temporary) / "counts.json"
            shutil.copy2(ROOT / "items/design/schedule.jsonl", schedule)
            shutil.copy2(ROOT / "items/design/generated-counts.json", counts)
            data = schedule.read_text(encoding="utf-8").replace("DESIGN-CALL-000001", "DESIGN-CALL-MUTANT", 1)
            schedule.write_text(data, encoding="utf-8")
            with self.assertRaises(ScheduleReplayDiverged):
                design.write_generated(ROOT / "items/design/design.json", schedule, counts, check=True)

    def test_fixture_driver_all_fourteen_and_first_condition(self):
        result = subprocess.run(["sbcl", "--script", str(HARNESS / "validator-driver.lisp")], cwd=ROOT, check=True, capture_output=True, text=True)
        lines = [line.split("|") for line in result.stdout.splitlines() if line.startswith("DRIVER|")]
        self.assertEqual(14, len(lines))
        for fields in lines:
            self.assertEqual(fields[3], fields[4], fields)
        self.assertEqual(6, sum(fields[4] == "VALID" for fields in lines))

    def test_validator_mutants_first_condition(self):
        result = subprocess.run(["sbcl", "--script", str(HARNESS / "validator-driver.lisp"), "--records", str(ROOT / "controls/validator-mutants.lisp")], cwd=ROOT, check=True, capture_output=True, text=True)
        actual = {fields[1]: fields for fields in (line.split("|") for line in result.stdout.splitlines() if line.startswith("DRIVER|"))}
        expected = load_jsonl(ROOT / "controls/expected-validator-events.jsonl")
        self.assertEqual(8, len(actual))
        for row in expected:
            fields = actual[row["fixture"]]
            self.assertEqual(row["expected"], fields[4])
            self.assertEqual(row["first_check"], fields[5])

    def test_scorer_mutants_and_anti_taxidermy(self):
        base_facts = {"unsupported_assertions": 0, "scope_errors": 0, "version_errors": 0, "residue_erasures": 0,
                      "scorable_opportunities": 5, "answerable_units": 2, "emitted_answerable_units": 2, "answer_utility": 3}
        controls = load_jsonl(ROOT / "controls/scorer-mutants.jsonl")
        field_to_name = {"unsupported_assertions": "insert-unsupported", "scope_errors": "scope-widening", "version_errors": "version-swap", "residue_erasures": "residue-deletion"}
        for control in controls:
            facts = {**base_facts, **control["mutation"]}
            result = score.score_facts(control["mutant_id"], facts)
            if "must_increase" in control:
                self.assertGreater(result["keyed"][control["must_increase"]], 0, control)
            else:
                self.assertTrue(result["anti_taxidermy"]["coupled_defect"], control)
        inserted = {**base_facts, "unsupported_assertions": 1}
        mutant_score = score.score_facts("mutant", inserted, mutation="drop-unsupported")
        self.assertEqual(0, mutant_score["keyed"]["unsupported_assertions"])
        with self.assertRaises(ScorerMutationSurvived):
            score.assert_mutant_detected(score.score_facts("base", base_facts), mutant_score, "insert-unsupported")
        deleted = {**base_facts, "emitted_answerable_units": 0}
        reward_mutant = score.score_facts("mutant", deleted, mutation="reward-deletion")
        self.assertFalse(reward_mutant["anti_taxidermy"]["coupled_defect"])

    def test_all_six_branch_fixtures_and_precedence(self):
        for branch in analyze.PRECEDENCE:
            payload = load_json(ROOT / "controls" / f"branch-{branch}.json")
            receipt = analyze.analyze(payload, iterations=120)
            self.assertEqual(branch, receipt["banked_branch"], receipt["all_predicates"])
            self.assertEqual(list(analyze.PRECEDENCE), receipt["branch_precedence"])
            self.assertEqual(set(analyze.PRECEDENCE), set(receipt["all_predicates"]))
        harm_payload = load_json(ROOT / "controls/branch-B-NOTATION.json")
        harm_payload["gates"]["anti_taxidermy_harm"] = True
        receipt = analyze.analyze(harm_payload, iterations=80)
        self.assertTrue(receipt["all_predicates"]["B-NOTATION"])
        self.assertEqual("B-HARM", receipt["banked_branch"])

    def test_primary_is_cell_weighted_secondary_is_labeled(self):
        payload = load_json(ROOT / "controls/branch-B-NULL.json")
        payload["rows"][0]["scorable_opportunities"] = 10000
        receipt = analyze.analyze(payload, iterations=50)
        self.assertIn("unweighted mean", receipt["primary_estimand"])
        for result in receipt["secondary_opportunity_weighted"].values():
            self.assertEqual("secondary", result["label"])

    def test_manifest_mutants(self):
        context, target = self.copy_packet()
        try:
            manifest.write_manifest(target)
            manifest.check_manifest(target)
            (target / "prompts/unmanifested.txt").write_text("mutant", encoding="utf-8")
            with self.assertRaises(UnmanifestedFrozenArtifact):
                manifest.check_manifest(target)
        finally:
            context.cleanup()
        context, target = self.copy_packet()
        try:
            manifest.write_manifest(target)
            (target / "prompts/NL.txt").write_text("stale hash", encoding="utf-8")
            with self.assertRaises(ManifestMismatch):
                manifest.check_manifest(target)
        finally:
            context.cleanup()
        context, target = self.copy_packet()
        try:
            manifest.write_manifest(target)
            (target / "prompts/NL.txt").rename(target / "prompts/NL-renamed.txt")
            with self.assertRaises((ManifestMismatch, UnmanifestedFrozenArtifact)):
                manifest.check_manifest(target)
        finally:
            context.cleanup()

    def test_duplicate_and_dangling_failures(self):
        context, target = self.copy_packet()
        try:
            rows = load_jsonl(target / "items/design/schedule.jsonl")
            rows[1]["call_id"] = rows[0]["call_id"]
            (target / "items/design/schedule.jsonl").write_bytes(b"".join(canonical_json_bytes(row) for row in rows))
            with self.assertRaises(DuplicateExperimentId):
                manifest.check_ids_and_references(target)
        finally:
            context.cleanup()
        context, target = self.copy_packet()
        try:
            bad = {"read_id": "read:dangling", "reader": "actor:missing", "artifact_id": "artifact:missing", "delivered_by": "actor:missing"}
            with (target / "lineage/reads.jsonl").open("ab") as handle:
                handle.write(canonical_json_bytes(bad))
            with self.assertRaises(DanglingArtifactReference):
                manifest.check_ids_and_references(target)
        finally:
            context.cleanup()

    def test_false_completion_and_silent_retry(self):
        with self.assertRaises(IncompleteRunCensus):
            validate_output.validate_census({"complete": True, "expected": 2, "observed": 1, "records": [{"call_id": "one"}]})
        with self.assertRaises(SilentRetryDetected):
            validate_output.validate_request({"run_id":"r","call_id":"c","item_id":"i","item_version":"v","arm":"NL","subject_slot":"s","provider_id":"p","model_id_requested":"m","parameters":{},"schedule_index":1,"attempt":2,"retry_parent":None})

    def test_key_boundary_is_denial_and_runner_has_no_network_surface(self):
        self.assertTrue(run.prove_key_denial())
        source = (HARNESS / "provider_dry_run.py").read_text(encoding="utf-8") + (HARNESS / "run.py").read_text(encoding="utf-8")
        for forbidden in ("import socket", "import urllib", "import requests", "import http.client"):
            self.assertNotIn(forbidden, source)
        result = subprocess.run([sys.executable, "-c", f"import sys;sys.path.insert(0,{str(HARNESS)!r});import run;assert 'score' not in sys.modules"], check=False)
        self.assertEqual(0, result.returncode)
        ledger = run.CostLedger(attempt_ceiling=1, output_token_ceiling=768, spend_ceiling="8.00")
        ledger.reserve(768)
        with self.assertRaises(CostCeilingExceeded):
            ledger.reserve(1)
        with self.assertRaises(CostCeilingExceeded):
            ledger.record_cost("8.01")

    def test_full_synthetic_run_replays_byte_identically(self):
        with tempfile.TemporaryDirectory(prefix="lae-run-a-") as first, tempfile.TemporaryDirectory(prefix="lae-run-b-") as second:
            for target in (Path(first), Path(second)):
                run.execute(ROOT / "controls/synthetic-items.jsonl", target / "run")
                rows = score.score_run(target / "run", target / "scores")
                (target / "analysis.json").write_bytes(canonical_json_bytes(analyze.analyze(rows)))
            files_a = {path.relative_to(first).as_posix(): path.read_bytes() for path in Path(first).rglob("*") if path.is_file()}
            files_b = {path.relative_to(second).as_posix(): path.read_bytes() for path in Path(second).rglob("*") if path.is_file()}
            self.assertEqual(files_a, files_b)
            census = json.loads(files_a["run/census.json"])
            self.assertEqual(312, census["observed"])
            self.assertEqual(0, census["network_calls"])

    def test_claim_linter_mutations_and_bounded_surface(self):
        forbidden = ["Language A works.", "Language A does not work.", "Language A fails.", "The approach is ineffective.",
                     "The pilot proves robustness.", "The validator verified the answer.", "Independent models corroborated the result."]
        for text in forbidden:
            with self.assertRaises(ForbiddenUnboundedClaim):
                claim_lint.lint_text(text)
        with self.assertRaises(ShamDiagnosticOverclaimed):
            claim_lint.lint_text("SHAM ruled out ceremonial effects.")
        with self.assertRaises(InconclusiveNarratedAsNull):
            claim_lint.lint_text("The inconclusive result is a null result.")
        with self.assertRaises(LocalizedHarmOvergeneralized):
            claim_lint.lint_text("B-HARM: Language A is harmful.")
        with self.assertRaises(MissingClaimCeilingRider):
            claim_lint.lint_text("A bounded result occurred.", require_riders=True)
        bounded = "Frozen pilot-scale first-pass emission for the sampled item bank, subject releases, routes, settings, and run window; no inference to hidden reasoning; no inference to enforcement efficacy; no inference to production custody, global independence, or totality."
        claim_lint.lint_text(bounded, require_riders=True)

    def test_grader_calibration_and_source_packet_firebreak(self):
        actors = [{"actor_id": "g", "role": ["primary-grader"]}]
        artifacts = [{"artifact_id": "cal", "artifact_kind": "target-derived-calibration"}, {"artifact_id": "src", "artifact_kind": "target-source-packet", "item_id": "i1"}]
        with self.assertRaises(GraderFirebreakViolated):
            firebreak.validate_grader_firebreak(actors, artifacts, [{"read_id":"r1","reader":"g","artifact_id":"cal","purpose":"calibration"}])
        self.assertTrue(firebreak.validate_grader_firebreak(actors, artifacts, [{"read_id":"r2","reader":"g","artifact_id":"src","purpose":"locked-target-scoring","response_lock_id":"lock:1","item_id":"i1"}]))

    def test_owner_fields_block_exposure_and_protected_scope_is_clean(self):
        with self.assertRaises(OwnerResolutionRequired):
            manifest.exposure_readiness()
        manifest.check_protected()

    def test_prompt_parity_and_sham_ceiling(self):
        scaffold = (ROOT / "prompts/SCAFFOLD.txt").read_bytes()
        language_a = (ROOT / "prompts/LANG-A.txt").read_bytes()
        self.assertLessEqual(abs(len(scaffold) - len(language_a)) / len(language_a), 0.10)
        sw = len(scaffold.decode().split()); lw = len(language_a.decode().split())
        self.assertLessEqual(abs(sw - lw) / lw, 0.10)
        prereg = (ROOT / "PREREG-v0.2.md").read_text(encoding="utf-8")
        self.assertIn("cannot rescue or overturn", prereg)
        self.assertEqual("SHAM-DISENGAGED", sham.classify_sham(0.69, False, False, 0.05))
        self.assertEqual("SHAM-OPERATIVE", sham.classify_sham(0.90, False, True, 0.05))
        self.assertEqual("SHAM-VALID", sham.classify_sham(0.90, False, False, 0.10))
        with self.assertRaises(PilotAuthorityReturn):
            sham.classify_sham(0.90, False, False, 0.11)

    def test_no_lci0_invocation_or_p2a_directory(self):
        code = "\n".join(path.read_text(encoding="utf-8") for path in HARNESS.glob("*.*") if path.suffix in {".py", ".lisp"} and path.name != "manifest.py").lower()
        self.assertNotIn("mneme/lci0", code)
        self.assertFalse((ROOT.parent / "mneme-enforcement-prototype").exists())


if __name__ == "__main__":
    unittest.main(verbosity=2)
