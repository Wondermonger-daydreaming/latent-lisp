"""Explicit red witnesses for unresolved normative fixture conflicts.

This file intentionally does not match normal ``test_*.py`` discovery.  Running
it directly must fail: no witness is counted as pass, skip, or N/A.

Authorial closure 2026-07-14 (LCI0-IMPLEMENTATION-CLOSURE-RULING.md; fixture
overlay 0.2) CLOSED seven of the original witnesses; their surfaces are now
green permanent regressions in ``test_closure_vectors.py``:

- N012 matcher symbolic guard        -> LCI0-AC-001-N012-MATCHER
- E5 unbound tenant-a context        -> LCI0-AC-003-E5-COVERAGE-CONTEXT
- P029 source-artifact rebinding     -> LCI0-AC-004-P029-SOURCE-PRESERVATION
- P024 invented revival metadata     -> LCI0-AC-010-P024-INERT-REVIVAL
- policy cross-product order         -> LCI0-AC-005-POLICY-EVALUATION-ORDER
- untrusted-external decision word   -> LCI0-AC-005-POLICY-EVALUATION-ORDER
- corpus r3/r4 boundary coherence    -> LCI0-AC-006-CORPUS-BASIS-COHERENCE

The witnesses below remain genuinely blocked: the closures explicitly
deferred them (no total inverse classification matrix, LCI0-AC-008; no
executable eleven-kind coherence algorithms, LCI0-AC-009) or left them
without a frozen positive output schema.
"""

from __future__ import annotations

import unittest

import cd0

from lci0.core import (
    field_by_path,
    match_target,
    validate_warrant_target,
)
from lci0.migration import validate_migration_result
from lci0.package import fixture_datum
from lci0.vector import (
    FixtureAuthorityGap,
    execute,
    input_payload_by_id,
)


def _replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


class BlockedNormativeAuthorityConflicts(unittest.TestCase):
    def test_migration_classification_inverse_matrix_is_unpinned(self):
        # LCI0-AC-008 pinned exactly the exact-after-explicit-tagging /
        # inert-predecessor coupling (now rejected; see
        # test_closure_vectors.ClosureRecordTests).  It explicitly declined
        # to infer a total inverse matrix, so the remaining classification
        # mutations — such as "rejected" over inert-predecessor content —
        # are still accepted without an authorized failure document.
        result = _replace_field(
            fixture_datum("migration-result.inert-predecessor"),
            "classification",
            cd0.identifier(
                ("lisp-plus", "lci", "0", "fixture"),
                ("migration-classification", "rejected"),
            ),
        )
        self.assertEqual(validate_migration_result(result), result)
        self.fail(
            "BLOCKED: LCI0-AC-008 pinned one classification/content pairing; "
            "the total inverse classification/content validity matrix "
            "remains authorially unpinned"
        )

    def test_positive_migration_result_operation_output_is_unpinned(self):
        result = fixture_datum("migration-result.time-100")
        self.assertEqual(validate_migration_result(result), result)
        with self.assertRaises(FixtureAuthorityGap):
            execute("validate-migration-result", {"migration-result": result})
        self.fail(
            "BLOCKED: validation can accept the frozen MigrationResult value, "
            "but no positive operation output document is frozen"
        )

    def test_equal_differential_evidence_positive_result_is_unpinned(self):
        evidence = input_payload_by_id("LCI0-N031")["evidence"]
        equal = _replace_field(
            evidence,
            "right-output",
            field_by_path(evidence, "left-output"),
        )
        with self.assertRaises(FixtureAuthorityGap):
            execute("differential-project", {"evidence": equal})
        self.fail(
            "BLOCKED: equal validated differential evidence is not nondeterminism, "
            "but no positive output record or exact refusal tuple is frozen"
        )

    def test_kind_specific_target_coherence_algorithms_are_opaque(self):
        # LCI0-AC-009 ruled only the derived premise mutation (now the
        # explicit /0 deferral tuple; see test_closure_vectors).  Executable
        # eleven-kind event-coupling algorithms were explicitly deferred to a
        # future separately bound version, so the expected-relation mutation
        # below still passes every pinned check without a mismatch rule.
        target = fixture_datum("warrant-target.tested.universal-property.org")
        boundaries = _replace_field(
            field_by_path(target, "boundaries"),
            "expected-relation",
            cd0.identifier(
                ("lisp-plus", "lci", "0", "fixture"),
                ("expected-relation", "unregistered-hostile"),
            ),
        )
        hostile = _replace_field(target, "boundaries", boundaries)
        validate_warrant_target(hostile)
        relation = match_target(hostile, field_by_path(hostile, "claim"))
        self.assertEqual(relation.relation, "exact-target")
        self.fail(
            "BLOCKED: LCI0-AC-009 deferred the executable eleven-kind "
            "event-coupling algorithms; only the derived premise path "
            "carries a ruled result"
        )


if __name__ == "__main__":
    unittest.main()
