"""Explicit red witnesses for unresolved normative fixture conflicts.

This file intentionally does not match normal ``test_*.py`` discovery.  Running
it directly must fail: no witness is counted as pass, skip, or N/A.
"""

from __future__ import annotations

import unittest

from lci0.adapter import from_package_json
import cd0

from lci0.core import (
    CD0_BUDGET,
    LCIFailure,
    canonical_bytes,
    evaluate_policy,
    field_by_path,
    match_target,
    scope_relation,
    validate_basis,
    validate_warrant_target,
)
from lci0.migration import migrate, validate_migration_result
from lci0.model import RelationResult
from lci0.package import fixture_datum
from lci0.vector import (
    FixtureAuthorityGap,
    execute,
    execute_row,
    expected_outcome,
    input_payload_by_id,
    record_to_mapping,
)
from lci0.package import iter_vectors


def _row(vector_id: str) -> dict:
    return next(row for row in iter_vectors() if row["vector_id"] == vector_id)


def _replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


class BlockedNormativeAuthorityConflicts(unittest.TestCase):
    def test_n012_symbolic_precheck_conflicts_with_scope_table_authority(self):
        payload = input_payload_by_id("LCI0-N012")
        target = payload["target"]
        claimed = field_by_path(target, "claim")
        target_scope = field_by_path(field_by_path(claimed, "location"), "scope")
        candidate_scope = field_by_path(field_by_path(payload["candidate-claim"], "location"), "scope")
        self.assertEqual(scope_relation(target_scope, candidate_scope), "wider")
        relation = match_target(target, payload["candidate-claim"])
        self.assertIsNotNone(relation.failure)
        self.assertEqual(relation.failure.code, "ScopeNarrowingNotDeclared")
        self.fail(
            "BLOCKED: authoritative scope-table dispatch yields wider and then "
            "ScopeNarrowingNotDeclared, while LCI0-N012 expects ScopeRelationUnknown"
        )

    def test_e5_expected_context_contains_unbound_tenant_a(self):
        row = _row("LCI0-E5-COVERAGE-INSUFFICIENT")
        actual = execute_row(row)
        expected = expected_outcome(row)
        self.assertIsNotNone(actual.failure)
        self.assertIsNotNone(expected.failure)
        actual_context = dict(actual.failure.context)
        expected_context = dict(expected.failure.context)
        declared = field_by_path(
            field_by_path(input_payload_by_id(row["vector_id"])["target"], "boundaries"),
            "coverage-scope",
        )
        self.assertEqual(
            canonical_bytes(actual_context["fixture-field:actual-coverage-scope"]),
            canonical_bytes(declared),
        )
        self.assertNotEqual(
            canonical_bytes(actual_context["fixture-field:actual-coverage-scope"]),
            canonical_bytes(expected_context["fixture-field:actual-coverage-scope"]),
        )
        self.fail(
            "BLOCKED: E5 expected context introduces tenant/a although the input "
            "binds only tenant/b coverage and department/research candidate scope"
        )

    def test_p029_expected_lineage_rebinds_explicit_source_artifact(self):
        row = _row("LCI0-P029")
        payload = input_payload_by_id(row["vector_id"])
        wrapper = payload["right-source"]
        explicit_source = field_by_path(wrapper, "source-artifact")
        actual_result = migrate(wrapper)
        actual_source = field_by_path(actual_result, "source")
        expected_document = from_package_json(row["expected"]["abstract_cd0"], CD0_BUDGET)
        expected_envelope = record_to_mapping(expected_document)
        expected_outputs = record_to_mapping(expected_envelope["outputs"])
        expected_result = expected_outputs["right-result"]
        expected_source = field_by_path(expected_result, "source")
        explicit_id = field_by_path(field_by_path(explicit_source, "material"), "object-id")
        expected_id = field_by_path(field_by_path(expected_source, "material"), "object-id")
        self.assertEqual(explicit_id.path[-2:], ("v1", "1"))
        self.assertEqual(expected_id.path[-2:], ("v1", "2"))
        self.assertEqual(canonical_bytes(actual_source), canonical_bytes(explicit_source))
        self.assertNotEqual(canonical_bytes(actual_source), canonical_bytes(expected_source))
        self.fail(
            "BLOCKED: P029 input explicitly binds legacy-source/v1/1, while its "
            "expected right migration result and lineage silently rebind v1/2"
        )

    def test_p024_expected_revival_invents_nonidentity_metadata(self):
        row = _row("LCI0-P024")
        payload = input_payload_by_id(row["vector_id"])
        actual = execute_row(row)
        self.assertIsNone(actual.failure)
        actual_occurrence = actual.outputs["revival"]["new-occurrence"]

        expected_document = from_package_json(row["expected"]["abstract_cd0"], CD0_BUDGET)
        expected_envelope = record_to_mapping(expected_document)
        expected_outputs = record_to_mapping(expected_envelope["outputs"])
        expected_revival = record_to_mapping(expected_outputs["revival"])
        expected_occurrence = expected_revival["new-occurrence"]

        self.assertEqual(
            canonical_bytes(actual_occurrence),
            canonical_bytes(payload["predecessor"]),
        )
        self.assertNotEqual(
            canonical_bytes(expected_occurrence),
            canonical_bytes(payload["predecessor"]),
        )
        self.assertNotEqual(
            canonical_bytes(field_by_path(expected_occurrence, "claimant")),
            canonical_bytes(field_by_path(payload["predecessor"], "claimant")),
        )
        self.fail(
            "BLOCKED: P024 expected output injects beta claimant/time/provenance/"
            "presentation metadata absent from predecessor + requested-claim, "
            "and no frozen revival algorithm authorizes those invented values"
        )

    def test_migration_classification_inverse_matrix_is_unpinned(self):
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
            "BLOCKED: all seven classification Identifiers are authorized shapes, "
            "but the inverse classification/content validity matrix is not pinned"
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
            "BLOCKED: §7 requires tested-kind coherence, but the registry exposes "
            "only opaque algorithm identities and field types, not an executable "
            "expected-relation mismatch rule or failure path"
        )

    def test_policy_cross_product_order_conflicts_between_prose_and_registry(self):
        with self.assertRaises(LCIFailure) as caught:
            evaluate_policy(
                "policy-b",
                RelationResult("supports-by-scope-narrowing"),
                target_kind="externally-attested",
                age=999,
                represented_loss="identity-bearing-loss",
                trusted_external=False,
            )
        self.assertEqual(caught.exception.code, "AdmissibilityUndetermined")
        self.fail(
            "BLOCKED: Package §8.1 orders loss/trust before freshness, while the "
            "canonical Policy-B record orders freshness before loss/trust"
        )

    def test_corpus_slice_boundary_coherence_has_no_pinned_failure_tuple(self):
        r3 = field_by_path(
            field_by_path(fixture_datum("claim-id.file-alpha-corpus-r3"), "location"),
            "basis",
        )
        r4 = field_by_path(
            field_by_path(fixture_datum("claim-id.file-alpha-corpus-r4"), "location"),
            "basis",
        )
        mixed = _replace_field(
            r3,
            "semantic-boundary",
            field_by_path(r4, "semantic-boundary"),
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_basis(mixed)
        self.assertEqual(caught.exception.category, "invalid-input")
        self.assertEqual(caught.exception.code, "InvalidBasis")
        self.fail(
            "BLOCKED: InvalidBasis is authorized for corpus/revision-to-slice/"
            "boundary incoherence, but the observed stage/path tuple is not frozen"
        )

    def test_untrusted_external_decision_vocabulary_conflicts(self):
        with self.assertRaises(LCIFailure) as caught:
            evaluate_policy(
                "policy-b",
                RelationResult("exact-target"),
                target_kind="externally-attested",
                age=0,
                trusted_external=False,
            )
        self.assertEqual(caught.exception.code, "AdmissibilityUndetermined")
        self.fail(
            "BLOCKED: Package §8.1 names reject-untrusted-external-principal, "
            "while the frozen Policy-B decision vocabulary names "
            "reject-external-principal"
        )


if __name__ == "__main__":
    unittest.main()
