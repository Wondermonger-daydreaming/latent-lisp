"""Pre-seed red tests for the fifteen constitutionally risky LCI/0 boundaries.

This file intentionally predates the Python implementation.  The first recorded
run therefore fails at the missing :mod:`lci0` import for every test.  The same
tests become black-box regression tests once the implementation exists.
"""

from __future__ import annotations

import copy
import importlib
import unittest


def api():
    return importlib.import_module("lci0")


class HighRiskBoundaryTests(unittest.TestCase):
    def test_01_fully_neutral_claim_has_pinned_base_bytes(self):
        m = api()
        claim = m.make_neutral_fixture_claim()
        self.assertEqual(m.project_claim_id(claim).canonical_hex, m.NEUTRAL_CLAIM_ID_HEX)

    def test_02_changing_one_coordinate_changes_envelope(self):
        m = api()
        claim = m.make_neutral_fixture_claim()
        changed = m.with_location_coordinate(claim, "scope", m.fixture_value("scope:org"))
        self.assertNotEqual(m.project_claim_id(claim), m.project_claim_id(changed))

    def test_03_identity_neutral_metadata_preserves_envelope(self):
        m = api()
        left = m.make_fixture_occurrence("metadata:left")
        right = m.make_fixture_occurrence("metadata:right")
        self.assertEqual(m.project_occurrence(left), m.project_occurrence(right))

    def test_04_undetermined_is_hard_inadmissible_without_policy_call(self):
        m = api()
        called = []
        result = m.apply_admissibility_floor(
            m.failure("ScopeRelationUnknown"), lambda *_: called.append(True)
        )
        self.assertTrue(result.hard_inadmissible)
        self.assertEqual(called, [])

    def test_05_nonmonotone_narrowing_requires_declaration(self):
        m = api()
        result = m.match_target(m.fixture_value("target:broad-undeclared"), m.fixture_value("claim:narrow"))
        self.assertEqual(result.code, "ScopeNarrowingNotDeclared")

    def test_06_narrowing_requires_sufficient_coverage(self):
        m = api()
        result = m.match_target(
            m.fixture_value("target:broad-insufficient"),
            m.fixture_value("claim:narrow-insufficient"),
        )
        self.assertEqual(result.code, "ScopeNarrowingCoverageInsufficient")

    def test_07_temporal_containment_is_not_direct_support(self):
        m = api()
        result = m.match_target(m.fixture_value("target:temporal-container"), m.fixture_value("claim:contained"))
        self.assertEqual(result.code, "SubjectTimeMismatch")

    def test_08_digest_equality_does_not_replace_envelope_equality(self):
        m = api()
        left, right = m.fixture_value("claim:digest-collision-pair")
        self.assertFalse(m.claim_ids_equal(left, right))

    def test_09_mutable_alias_is_not_a_stable_reference(self):
        m = api()
        for alias in ("latest", "main", "display-model", "file.txt", "https://mutable.invalid/x"):
            with self.subTest(alias=alias):
                with self.assertRaises(m.LCIFailure) as raised:
                    m.validate_stable_ref(m.mutable_alias_ref(alias))
                self.assertEqual(raised.exception.code, "UnresolvedAlias")

    def test_10_unknown_nested_versions_fail_closed(self):
        m = api()
        value = m.make_neutral_fixture_claim()
        value["location"]["scope"]["schema-version"] = 1
        with self.assertRaises(m.LCIFailure):
            m.project_claim_id(value)

    def test_11_proposition_location_placement_disagreement_fails(self):
        m = api()
        value = m.fixture_value("placement:disagreement")
        with self.assertRaises(m.LCIFailure) as raised:
            m.project_claim_id(value)
        self.assertEqual(raised.exception.code, "PropositionLocationInconsistent")

    def test_12_legacy_fingerprint_collision_does_not_collapse_claim_ids(self):
        m = api()
        old_left, old_right = m.fixture_value("migration:fingerprint-collision")
        migrated_left = m.migrate_v1(old_left)
        migrated_right = m.migrate_v1(old_right)
        self.assertNotEqual(migrated_left.claim_id, migrated_right.claim_id)

    def test_13_migrated_legacy_warrant_remains_inert(self):
        m = api()
        result = m.migrate_v1(m.fixture_value("migration:legacy-warrant"))
        self.assertTrue(result.inert)
        self.assertEqual(result.live_warrants, ())

    def test_14_unknown_fields_fail_closed(self):
        m = api()
        value = m.make_neutral_fixture_claim()
        value["unknown"] = 1
        with self.assertRaises(m.LCIFailure) as raised:
            m.project_claim_id(value)
        self.assertEqual(raised.exception.code, "UnknownField")

    def test_15_source_mutation_cannot_change_constructed_claim_id_bytes(self):
        m = api()
        source = m.make_neutral_fixture_claim()
        claim_id = m.project_claim_id(source)
        before = claim_id.canonical_bytes
        mutated = copy.deepcopy(source)
        mutated["location"] = {"attacker": True}
        source.clear()
        source.update(mutated)
        self.assertEqual(claim_id.canonical_bytes, before)


if __name__ == "__main__":
    unittest.main()
