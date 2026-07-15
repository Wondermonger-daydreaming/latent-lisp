from __future__ import annotations

from dataclasses import FrozenInstanceError
import unittest
from unittest.mock import patch

import cd0

import lci0
from lci0.core import canonical_bytes, project_claim_id, restore_live_warrant
from lci0.model import LCIFailure, MigrationResult, PolicyDecision, RelationResult
from lci0.package import fixture_datum


class ImmutableSurfaceTests(unittest.TestCase):
    def test_all_required_immutable_value_views_exist(self):
        names = (
            "StableRef", "LCIIdentityPolicy", "ClaimProfileRef", "Scope", "SubjectTime", "WorldBasis",
            "DatasetSlice", "SemanticBoundary", "CorpusBasis", "InterpretationFrame", "ClaimLocation",
            "ClaimIdEnvelope", "WarrantTarget", "LCIFailure", "ClaimLineageEdge", "RepresentedLoss",
            "MigrationResult", "ClaimOccurrence",
        )
        for name in names:
            with self.subTest(name=name):
                self.assertTrue(hasattr(lci0, name))
        value = project_claim_id(fixture_datum("claim-id.file-alpha-neutral"))
        with self.assertRaises(FrozenInstanceError):
            value.canonical_bytes = b"changed"

    def test_migration_values_are_inert_and_have_no_live_warrants(self):
        datum = fixture_datum("migration-result.inert-predecessor")
        view = MigrationResult(datum, canonical_bytes(datum))
        self.assertTrue(view.inert)
        self.assertEqual(view.live_warrants, ())
        with self.assertRaises(LCIFailure) as caught:
            restore_live_warrant(datum)
        self.assertEqual(caught.exception.code, "PrivilegedRestorationAttempt")

    def test_f_valued_relation_is_hard_inadmissible_without_policy(self):
        called = []
        relation = RelationResult(failure=LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation"))
        decision = lci0.apply_admissibility_floor(relation, lambda _: called.append(True))
        self.assertFalse(decision.accepted)
        self.assertTrue(decision.hard_inadmissible)
        self.assertFalse(decision.policy_consulted)
        self.assertEqual(called, [])

    def test_projection_has_no_filesystem_network_clock_dependency(self):
        claim = fixture_datum("claim-id.file-alpha-neutral")
        expected = project_claim_id(claim).canonical_bytes
        with patch("builtins.open", side_effect=AssertionError("filesystem consulted")), patch(
            "socket.socket", side_effect=AssertionError("network consulted")
        ), patch("time.time", return_value=9_999_999_999):
            self.assertEqual(project_claim_id(claim).canonical_bytes, expected)

    def test_independently_allocated_equal_values_project_identically(self):
        datum = fixture_datum("claim-id.file-alpha-neutral")
        encoded = canonical_bytes(datum)
        left = cd0.decode_exact(bytes(bytearray(encoded)), lci0.CD0_BUDGET)
        right = cd0.decode_exact(bytes(memoryview(encoded)), lci0.CD0_BUDGET)
        self.assertIsNot(left, right)
        self.assertEqual(project_claim_id(left).canonical_bytes, project_claim_id(right).canonical_bytes)


if __name__ == "__main__":
    unittest.main()
