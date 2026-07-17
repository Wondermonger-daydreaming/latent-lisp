"""Tests for the machine-checkable scoring constitution (SCORING-CONSTITUTION.md §11/§12).

Written as unittest.TestCase (pytest-collectable, and runnable standalone via
``python3 tests/test_scoring_constitution.py`` when pytest is unavailable offline).
"""

import json
import sys
import tempfile
import unittest
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT / "harness"
sys.path.insert(0, str(HARNESS))

import scoring_constitution as sc  # noqa: E402
from util import canonical_json_bytes  # noqa: E402

FIXTURE_DIR = ROOT / "controls/scoring-constitution-fixtures"


class FixtureCorpusTest(unittest.TestCase):
    def test_every_fixture_matches_index_expected_outcome(self):
        index = json.loads((FIXTURE_DIR / "INDEX.json").read_bytes())
        self.assertGreaterEqual(len(index["fixtures"]), 30)
        for entry in index["fixtures"]:
            fixture = json.loads((FIXTURE_DIR / entry["file"]).read_bytes())
            self.assertTrue(fixture.get("synthetic_only"), entry["file"])
            observed = sc.evaluate_fixture(fixture)
            for key, value in entry["expected_outcome"].items():
                self.assertEqual(observed.get(key), value, f"{entry['file']}::{key}")

    def test_every_taxonomy_state_has_a_fixture(self):
        index = json.loads((FIXTURE_DIR / "INDEX.json").read_bytes())
        states = {e["expected_outcome"].get("state") for e in index["fixtures"] if e["kind"] == "envelope"}
        self.assertEqual(states, set(sc.STATE_TABLE))


class ClassifierTotalityTest(unittest.TestCase):
    def test_classifier_self_check_covers_all_states_in_order(self):
        self.assertEqual(sc._classifier_self_check(), list(sc.STATE_ORDER))

    def test_fuzz_grid_never_raises_and_always_dispositions(self):
        statuses = ["completed", "refused", "transport-failure", "truncated", "banana", None]
        junk_requests = [sc.demo_request(), sc.demo_request(arm="BAD"), {}, {"arm": 123}, "not-a-dict"]
        junk_responses = []
        for status in statuses:
            junk_responses.append(sc.demo_response(status=status))
            junk_responses.append(sc.demo_response(status=status, anomalies=[{"type": "timeout"}]))
            junk_responses.append({"status": status})
        junk_responses.append({})
        raws = ["", "text", b"\xff\xff", None, b"bytes", 12345]
        seen = set()
        for request in junk_requests:
            for response in junk_responses:
                for raw in raws:
                    result = sc.classify_envelope(request, response, raw)
                    self.assertIn(result["state"], sc.STATE_TABLE)
                    self.assertIn(result["disposition"],
                                  {"SCORE", "SCORE-ZERO-DISCHARGE", "UNANALYZABLE-CENSUS", "QUARANTINE-INTEGRITY"})
                    self.assertTrue(result["denominator_retained"])
                    seen.add(result["state"])
        self.assertIn("T99", seen)  # fall-through is reachable

    def test_validate_classification_catches_disposition_tamper(self):
        with self.assertRaises(sc.DispositionMismatch):
            sc.validate_classification({"state": "T13", "disposition": "SCORE",
                                        "census_class": "analyzable", "denominator_retained": True,
                                        "flags": ["unparseable"]})


class DecimalLawTest(unittest.TestCase):
    def test_exact_rational_avoids_float_drift(self):
        self.assertEqual(sc.canonical_decimal(Fraction(1, 10) + Fraction(2, 10)), "0.300000")

    def test_half_even_both_directions(self):
        self.assertEqual(sc.canonical_decimal(Fraction(1, 2_000_000)), "0.000000")  # 0.0000005 -> even down
        self.assertEqual(sc.canonical_decimal(Fraction(3, 2_000_000)), "0.000002")  # 0.0000015 -> even up

    def test_negative_zero_normalized(self):
        self.assertEqual(sc.canonical_decimal(Fraction(-1, 10_000_000_000)), "0.000000")

    def test_float_rejected_in_canonical_record(self):
        with self.assertRaises(sc.FloatInCanonicalRecord):
            sc.canonical_scoring_record_bytes({"burden": 0.5})
        with self.assertRaises(sc.FloatInCanonicalRecord):
            sc.canonical_scoring_record_bytes({"nested": [1, {"x": 0.1}]})

    def test_canonical_decimal_rejects_float(self):
        with self.assertRaises(sc.DecimalQuantizationError):
            sc.canonical_decimal(0.5)

    def test_threshold_comparison_is_exact_rational_not_quantized(self):
        value, threshold = Fraction(199999, 2_000_000), Fraction(1, 10)
        # quantized decimals are equal ...
        self.assertEqual(sc.canonical_decimal(value), sc.canonical_decimal(threshold))
        # ... but the exact rational is strictly below the threshold.
        self.assertEqual(sc.compare_threshold(value, threshold), -1)
        self.assertTrue(sc.rational_le(value, threshold))
        self.assertFalse(sc.rational_ge(value, threshold))


class DisagreementLawTest(unittest.TestCase):
    def test_equal_banks_value(self):
        self.assertEqual(sc.bank_dimension(3, 3), Fraction(3))

    def test_one_apart_banks_exact_mean(self):
        self.assertEqual(sc.bank_dimension(2, 3), Fraction(5, 2))

    def test_two_apart_requires_adjudication(self):
        with self.assertRaises(sc.AdjudicationRequired):
            sc.bank_dimension(2, 4)

    def test_adjudication_replaces_and_retains_lineage(self):
        result = sc.adjudicate(2, 4, Fraction(3), ["seed-digest"])
        self.assertEqual(result["banked_value"]["decimal"], "3.000000")
        self.assertTrue(result["first_pass_records_retained"])
        self.assertEqual(len(result["adjudication_lineage"]), 3)


class SlotGateTest(unittest.TestCase):
    def test_passes_now_because_all_slots_are_resolved(self):
        self.assertEqual(sc.scoring_eligibility(sc.REPO_ROOT), {"eligible": True, "unresolved": []})

    def test_passes_on_fully_resolved_register(self):
        with tempfile.TemporaryDirectory() as tmp:
            operator = Path(tmp) / "experiments/language-a-exoskeleton/operator"
            operator.mkdir(parents=True)
            owner = {"schema_version": "lae-owner-slots/0.2", "pre_exposure_gate_signed": True,
                     "slots": [{"slot_id": "role-assignments", "status": "resolved"},
                               {"slot_id": "price-table", "status": "resolved"}]}
            scoring = {"schema_version": "lae-scoring-owner-slots/1.0.0", "slots": [
                {"slot_id": "role-assignments", "status": "resolved", "binds": "operator/owner-slots.json#role-assignments", "value": {"a": 1}},
                {"slot_id": "price-table", "status": "resolved", "binds": "operator/owner-slots.json#price-table", "value": {"p": 1}},
                {"slot_id": "bootstrap-parameters", "status": "resolved-by-constitution", "binds": "new", "value": {"seed": 1729, "iterations": 800}},
            ]}
            (operator / "owner-slots.json").write_bytes(canonical_json_bytes(owner))
            (operator / "scoring-owner-slots.json").write_bytes(canonical_json_bytes(scoring))
            self.assertEqual(sc.scoring_eligibility(tmp)["eligible"], True)

    def test_forged_eligibility_flag_is_a_bypass(self):
        register = {"eligible": True, "slots": [{"slot_id": "role-assignments", "status": "unresolved"}]}
        with self.assertRaises(sc.SlotGateBypass):
            sc.assert_register_eligibility(register)


class BlindedProjectionTest(unittest.TestCase):
    def setUp(self):
        self.record = {"arm": "LANG-A", "subject_slot": "S1", "provider_id": "p",
                       "model_id_returned": "m", "family": "f", "burden": {"decimal": "0.1"}, "call_id": "c"}
        self.salt = b"salt"

    def test_conceals_exactly_the_concealment_set(self):
        projected = sc.blinded_projection(self.record, self.salt)
        for key in ("arm", "subject_slot", "provider_id", "model_id_returned", "family"):
            self.assertTrue(projected[key].startswith("blind:"), key)
        self.assertEqual(projected["burden"], {"decimal": "0.1"})  # not concealed
        self.assertEqual(projected["call_id"], "c")

    def test_deterministic(self):
        self.assertEqual(sc.blinded_projection(self.record, self.salt),
                         sc.blinded_projection(self.record, self.salt))

    def test_validate_blinding_catches_cleartext_leak(self):
        leaked = sc.blinded_projection(self.record, self.salt)
        leaked["arm"] = "LANG-A"
        with self.assertRaises(sc.BlindFieldLeak):
            sc.validate_blinding(leaked)


class ProvenanceLevelBankTest(unittest.TestCase):
    def _prov(self, **over):
        base = {"constitution_version": sc.CONSTITUTION_VERSION, "rubric_sha256": "a" * 64,
                "schedule_row_digest": "b" * 64, "envelope_digest": "c" * 64, "scorer_pseudonym": "R1",
                "implementation_identity": "d" * 64, "scoring_timestamp": "2026-07-16T00:00:00Z",
                "adjudication_lineage": []}
        base.update(over)
        return base

    def test_complete_provenance_passes(self):
        self.assertTrue(sc.validate_provenance(self._prov()))

    def test_missing_field_rejected(self):
        record = self._prov()
        del record["rubric_sha256"]
        with self.assertRaises(sc.ProvenanceIncomplete):
            sc.validate_provenance(record)

    def test_wrong_constitution_version_rejected(self):
        with self.assertRaises(sc.ProvenanceIncomplete):
            sc.validate_provenance(self._prov(constitution_version="wrong/9"))

    def test_level_substitution_ban(self):
        self.assertTrue(sc.validate_aggregation_inputs([{"level": "L1"}, {"level": "L1"}], "L1"))
        with self.assertRaises(sc.LevelSubstitution):
            sc.validate_aggregation_inputs([{"level": "L1"}, {"level": "L2"}], "L1")


class BankBindingTest(unittest.TestCase):
    def test_binds_the_real_freeze_manifest(self):
        result = sc.verify_bank_binding(sc.REPO_ROOT)
        self.assertEqual(result["freeze_manifest_sha256"], sc.FROZEN_FREEZE_MANIFEST_SHA256)
        self.assertEqual(result["bank_commit"], sc.FROZEN_BANK_COMMIT)

    def test_tampered_manifest_rejected(self):
        with self.assertRaises(sc.BankBindingMismatch):
            sc.verify_bank_binding(sc.REPO_ROOT, manifest_bytes=b"tampered")


class DelegationTest(unittest.TestCase):
    def test_run_analysis_delegates_and_reserializes_without_floats(self):
        fixture = json.loads((FIXTURE_DIR / "branch-notation-supports.json").read_bytes())
        record = sc.run_analysis({"rows": fixture["rows"], "gates": fixture["gates"]})
        self.assertEqual(record["delegated_banked_branch"], "B-NOTATION")
        self.assertEqual(record["schema_version"], sc.SCHEMA_BRANCH_RECEIPT)
        # re-serializes clean under the decimal law (no floats)
        sc.canonical_scoring_record_bytes(record)
        self.assertEqual(record["margins"]["delta"]["decimal"], "0.100000")

    def test_local_predicate_reencoding_is_forbidden(self):
        fixture = json.loads((FIXTURE_DIR / "branch-null-exact.json").read_bytes())
        with self.assertRaises(sc.PredicateReencodingForbidden):
            sc.assert_delegated_branch({"rows": fixture["rows"], "gates": fixture["gates"]}, "B-NOTATION")


class MutationSuiteTest(unittest.TestCase):
    def test_all_mutations_killed(self):
        results = sc.execute_mutations()
        self.assertGreaterEqual(len(results), 24)
        self.assertTrue(all(row["killed"] for row in results))


def _run_standalone():
    suite = unittest.TestLoader().loadTestsFromModule(sys.modules[__name__])
    runner = unittest.TextTestRunner(verbosity=2)
    return 0 if runner.run(suite).wasSuccessful() else 1


if __name__ == "__main__":
    sys.exit(_run_standalone())
