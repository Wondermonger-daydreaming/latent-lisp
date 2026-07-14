"""Focused regressions for findings from the independent successor audit."""

from __future__ import annotations

import unittest
from unittest.mock import patch

import cd0

from lci0.core import (
    CD0_BUDGET,
    FIXTURE,
    FIXTURE_FIELD,
    LCI,
    LCIFailure,
    claim_ids_equal,
    field_by_path,
    match_target,
    project_claim_id,
    project_occurrence,
    validate_claim_id,
    validate_stable_ref,
)
from lci0.package import fixture_datum
from lci0.vector import input_payload_by_id


def replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


def add_field(
    value: cd0.Record,
    name: str,
    item: cd0.Datum,
    namespace: tuple[str, ...] = FIXTURE_FIELD,
) -> cd0.Record:
    return cd0.record(
        (*value.fields, (cd0.identifier(namespace, (name,)), item))
    )


class ProjectionBoundaryAuditTests(unittest.TestCase):
    def test_claim_projection_does_not_unwrap_an_occurrence(self):
        occurrence = fixture_datum("claim-occurrence.alpha")
        semantic_core = field_by_path(occurrence, "semantic-claim-core")
        carrier = cd0.record(
            (
                (
                    cd0.identifier(FIXTURE_FIELD, ("semantic-claim-core",)),
                    semantic_core,
                ),
                (cd0.identifier(FIXTURE_FIELD, ("future",)), cd0.unit()),
            )
        )

        with self.assertRaises(LCIFailure) as caught:
            project_claim_id(carrier)
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "invalid-input",
                "MissingRequiredField",
                "claim-shape",
                ("identity-policy",),
            ),
        )

        opened = add_field(occurrence, "outer-unknown", cd0.unit())
        with self.assertRaises(LCIFailure) as caught:
            project_occurrence(opened)
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "invalid-input",
                "UnknownField",
                "claim-shape",
                ("fixture-field:outer-unknown",),
            ),
        )
        self.assertEqual(
            project_occurrence(occurrence).canonical_bytes,
            project_claim_id(semantic_core).canonical_bytes,
        )

    def test_mneme_zero_profile_location_is_exactly_the_empty_record(self):
        neutral = fixture_datum("claim-id.file-alpha-neutral")
        self.assertEqual(
            field_by_path(field_by_path(neutral, "location"), "profile-location"),
            cd0.record(()),
        )
        validate_claim_id(neutral)

        n009_claim = input_payload_by_id("LCI0-N009")["claim"]
        n009_location = field_by_path(n009_claim, "location")
        tagged_profile = field_by_path(n009_location, "profile-location")
        tagged_but_coordinate_empty = replace_field(
            tagged_profile,
            "coordinates",
            cd0.record(()),
        )
        malformed = replace_field(
            n009_claim,
            "location",
            replace_field(
                n009_location,
                "profile-location",
                tagged_but_coordinate_empty,
            ),
        )

        with self.assertRaises(LCIFailure) as caught:
            validate_claim_id(malformed)
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "invalid-input",
                "UnknownField",
                "profile-location",
                ("location", "profile-location", "kind"),
            ),
        )

    def test_n009_retains_its_frozen_nested_unknown_diagnostic(self):
        with self.assertRaises(LCIFailure) as caught:
            validate_claim_id(input_payload_by_id("LCI0-N009")["claim"])
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "invalid-input",
                "UnknownField",
                "profile-location",
                (
                    "location",
                    "profile-location",
                    "coordinates",
                    "fixture-field:future-coordinate",
                ),
            ),
        )


class TargetMatchingAuditTests(unittest.TestCase):
    def setUp(self):
        self.target = fixture_datum("warrant-target.observed.file-alpha.exact")
        self.embedded = field_by_path(self.target, "claim")

    def assert_failure(self, result, code: str, path: tuple[str, ...]) -> None:
        self.assertIsNotNone(result.failure)
        self.assertEqual(
            result.failure.comparison_key,
            ("target-mismatch", code, "target-relation", path),
        )

    def test_proposition_mismatch_has_its_own_code(self):
        result = match_target(self.target, fixture_datum("claim-id.file-beta-neutral"))
        self.assert_failure(result, "PropositionMismatch", ("claim", "proposition"))

    def test_proposition_mismatch_precedes_subject_time_mismatch(self):
        beta = fixture_datum("claim-id.file-beta-neutral")
        yesterday = fixture_datum("claim-id.file-alpha-yesterday")
        candidate = replace_field(beta, "location", field_by_path(yesterday, "location"))
        result = match_target(self.target, candidate)
        self.assert_failure(result, "PropositionMismatch", ("claim", "proposition"))

    def test_identity_policy_and_claim_profile_are_explicit_match_coordinates(self):
        cases = (
            (
                "identity-policy",
                "IdentityPolicyMismatch",
                ("claim", "identity-policy"),
            ),
            (
                "claim-profile",
                "ClaimProfileMismatch",
                ("claim", "claim-profile"),
            ),
        )
        for field, code, path in cases:
            with self.subTest(field=field):
                candidate = replace_field(self.embedded, field, cd0.unit())
                # Mneme/0 freezes one valid policy/profile.  Bypass the
                # validator here only to prove the matcher owns and orders the
                # coordinate comparisons independently of that closed domain.
                with patch("lci0.core.validate_claim_id", return_value=candidate):
                    result = match_target(self.target, candidate)
                self.assert_failure(result, code, path)

    def test_profile_location_mismatch_has_its_own_code(self):
        location = field_by_path(self.embedded, "location")
        nonempty = cd0.record(
            ((cd0.identifier(LCI, ("future",)), cd0.unit()),)
        )
        candidate = replace_field(
            self.embedded,
            "location",
            replace_field(location, "profile-location", nonempty),
        )
        # The only valid Mneme/0 profile-location is empty.  The bypass isolates
        # the matcher comparison that remains required by its closed algorithm.
        with patch("lci0.core.validate_claim_id", return_value=candidate):
            result = match_target(self.target, candidate)
        self.assert_failure(
            result,
            "ProfileLocationMismatch",
            ("claim", "location", "profile-location"),
        )

    def test_nonmonotonicity_precedes_insufficient_coverage(self):
        payload = input_payload_by_id("LCI0-E5-NONMONOTONE-NARROWING")
        candidate_scope = field_by_path(
            field_by_path(payload["candidate-claim"], "location"),
            "scope",
        )
        boundaries = replace_field(
            field_by_path(payload["target"], "boundaries"),
            "coverage-scope",
            candidate_scope,
        )
        target = replace_field(payload["target"], "boundaries", boundaries)
        result = match_target(target, payload["candidate-claim"])
        self.assert_failure(
            result,
            "ScopeNarrowingNotDeclared",
            ("claim", "location", "scope"),
        )


class StableReferenceAndEqualityAuditTests(unittest.TestCase):
    def test_production_and_model_current_are_mutable_aliases(self):
        reference = fixture_datum("stable-ref.artifact.file.alpha")
        material = field_by_path(reference, "material")
        object_id = field_by_path(material, "object-id")
        for alias in ("production", "model-current"):
            with self.subTest(alias=alias):
                mutated_id = cd0.identifier(
                    object_id.namespace,
                    (*object_id.path[:-1], alias),
                )
                mutated = replace_field(
                    reference,
                    "material",
                    replace_field(material, "object-id", mutated_id),
                )
                with self.assertRaises(LCIFailure) as caught:
                    validate_stable_ref(mutated)
                self.assertEqual(caught.exception.code, "UnresolvedAlias")

    def test_claim_id_equality_validates_both_operands(self):
        with self.assertRaises(LCIFailure):
            claim_ids_equal(cd0.record(()), cd0.record(()))

        alpha = fixture_datum("claim-id.file-alpha-neutral")
        independent_alpha = cd0.decode_exact(
            cd0.encode_exact(alpha, CD0_BUDGET),
            CD0_BUDGET,
        )
        beta = fixture_datum("claim-id.file-beta-neutral")
        self.assertTrue(claim_ids_equal(alpha, independent_alpha))
        self.assertFalse(claim_ids_equal(alpha, beta))


if __name__ == "__main__":
    unittest.main()
