import inspect
import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT / "harness"
sys.path.insert(0, str(HARNESS))

import tranche_b
from conditions import AuthorityBoundaryViolation, TargetVisibilityViolation


class TrancheBTests(unittest.TestCase):
    maxDiff = None

    @classmethod
    def setUpClass(cls):
        cls.bank = tranche_b.load_bank()
        cls.template_manifest, cls.template_files = tranche_b.validate_template_files()
        cls.schedule = tranche_b.strict_jsonl_load(tranche_b.SCHEDULE_PATH)
        tranche_b.validate_schedule(cls.schedule, cls.bank, cls.template_manifest)

    def test_exact_population_odr60_and_candidate_state(self):
        expected_ids = [row["slot_id"] for row in tranche_b.odr60_rows()]
        self.assertEqual(expected_ids, [row["item_id"] for row in self.bank["targets"]])
        self.assertEqual(24, len(expected_ids))
        self.assertEqual("candidate-not-frozen", self.bank["manifest"]["state"])
        self.assertFalse(self.bank["manifest"]["freeze_authorized"])
        self.assertTrue(self.bank["manifest"]["retired_items_excluded"])
        self.assertEqual(24, len(self.bank["dossier_identities"]))

    def test_external_dossier_identity_closure_contains_no_private_content(self):
        expected_ids = [row["slot_id"] for row in tranche_b.odr60_rows()]
        identities = self.bank["dossier_identities"]
        self.assertEqual(expected_ids, [row["item_id"] for row in identities])
        self.assertEqual(expected_ids, self.bank["dossier_manifest"]["item_ids"])
        self.assertEqual(24, self.bank["dossier_manifest"]["identity_count"])
        self.assertFalse(self.bank["dossier_manifest"]["private_content_committed"])
        serialized = tranche_b.jsonl_bytes(identities)
        self.assertEqual(tranche_b.sha256_bytes(serialized), self.bank["dossier_manifest"]["identities_sha256"])
        for identity in identities:
            self.assertEqual("owner-private-external", identity["standing"])
            self.assertEqual(tranche_b.FORBIDDEN_DESTINATIONS, set(identity["excluded_from"]))
            self.assertNotIn("private_text", identity)
            self.assertNotIn("owner_private_content", identity)

    def test_f1_records_and_composer_are_structurally_closed(self):
        self.assertEqual(
            ["item", "system_bytes", "template_bytes", "wrapper_bytes"],
            list(inspect.signature(tranche_b.compose_payload).parameters),
        )
        forbidden_keys = {"family", "answerability_role", "tags", "boundaries", "rendering_requirements", "freezer_note", "intended_resolution"}
        for record in self.bank["targets"]:
            self.assertFalse(forbidden_keys.intersection(record))
            item = tranche_b.TargetVisibleItem.from_record(record)
            for arm in tranche_b.ALL_ARMS:
                payload = tranche_b.compose_payload(item, self.template_files["system"], self.template_files[arm], self.template_files["wrapper"])
                self.assertIn(item.task, payload)
                for component in item.sources:
                    self.assertIn(component, payload)
                hidden = self.bank["maps"]["hidden metadata"][item.item_id]
                obligation = self.bank["maps"]["rendering obligation"][item.item_id]
                identity = next(row for row in self.bank["dossier_identities"] if row["item_id"] == item.item_id)
                for exact_span in (hidden["source_version_scope_boundaries"]["utf8"], obligation["requirements"]["utf8"]):
                    self.assertNotIn(exact_span.encode("utf-8"), payload)
                self.assertNotIn(identity["artifact_sha256"].encode("ascii"), payload)

    def test_cr01_derived_view_never_replaces_originals(self):
        record = self.bank["maps"]["target-visible item"]["CR-01"]
        self.assertEqual(["S1", "S2", "S3"], [source["component_id"] for source in record["sources"]])
        self.assertEqual(["CR-01-S1-WIRE-LAYOUT"], [view["view_id"] for view in record["derived_views"]])
        item = tranche_b.TargetVisibleItem.from_record(record)
        payload = tranche_b.compose_payload(item, self.template_files["system"], self.template_files["NL"], self.template_files["wrapper"])
        positions = [payload.index(source) for source in item.sources]
        self.assertEqual(positions, sorted(positions))
        self.assertGreater(payload.index(item.derived_views[0]), positions[-1])

    def test_template_neutrality_parity_and_exact_schedule(self):
        scaffold = self.template_files["SCAFFOLD"]
        language = self.template_files["LANG-A"]
        self.assertLessEqual(abs(len(scaffold) - len(language)) / len(language), 0.10)
        self.assertLessEqual(abs(len(scaffold.decode().split()) - len(language.decode().split())) / len(language.decode().split()), 0.10)
        self.assertEqual(312, len(self.schedule))
        self.assertEqual(288, sum(row["arm"] != "SHAM" for row in self.schedule))
        self.assertEqual(24, sum(row["arm"] == "SHAM" for row in self.schedule))
        self.assertEqual(set(tranche_b.ALL_ARMS), {row["arm"] for row in self.schedule})

    def test_validator_lawful_skeleton_and_nonfixture_mutations(self):
        rows = tranche_b.validate_lang_a_mutants()
        self.assertEqual("VALID", rows["TB-LANG-A-LAWFUL"]["observed"])
        self.assertEqual("ANSWER-WITHOUT-CLAIM", rows["TB-LANG-A-MISSING-CLAIM"]["observed"])
        self.assertEqual("UNRESOLVED-REFERENCE", rows["TB-LANG-A-DANGLING-SUPPORT"]["observed"])
        self.assertEqual("INVALID-CONFIDENCE", rows["TB-LANG-A-CONFIDENCE"]["observed"])

    def test_declared_mutations_are_complete_and_killed(self):
        results = tranche_b.execute_mutations()
        registry = tranche_b.strict_json_load(tranche_b.MUTATION_REGISTRY_PATH)
        self.assertEqual(38, len(results))
        self.assertEqual(len(registry["mutations"]), len(results))
        self.assertTrue(all(row["executed"] and row["killed"] for row in results))

    def test_two_clean_network_off_runs_are_byte_identical(self):
        result = tranche_b.run_two_clean_replays()
        self.assertTrue(result["byte_identical"])
        self.assertEqual(2185, result["file_count"])
        self.assertEqual(0, result["network_calls"])
        self.assertEqual(0, result["provider_calls"])
        self.assertEqual(0, result["target_outputs"])
        self.assertEqual(0, result["scoring_runs"])
        self.assertNotIn("tranche-b/freezer-only/external-dossier-identities.jsonl", result["runtime_read_paths"])

    def test_authority_boundaries_have_no_artifact_or_network_surface(self):
        forbidden_names = {"private-score-key.json", "KEY-AUTHOR-INPUT.json"}
        self.assertFalse([path for path in ROOT.rglob("*") if path.is_file() and path.name in forbidden_names])
        source = (HARNESS / "tranche_b.py").read_text(encoding="utf-8")
        for forbidden_import in ("import socket", "import urllib", "import requests", "import http.client", "import score"):
            self.assertNotIn(forbidden_import, source)
        with self.assertRaises(AuthorityBoundaryViolation):
            tranche_b.RuntimeReadBoundary().read_bytes(ROOT / "tranche-b/freezer-only/external-dossier-identities.jsonl")
        with self.assertRaises(AuthorityBoundaryViolation):
            tranche_b.RuntimeReadBoundary().read_bytes(Path("/tmp/LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE.zip"))


if __name__ == "__main__":
    unittest.main()
