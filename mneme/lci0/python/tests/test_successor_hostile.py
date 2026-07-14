from __future__ import annotations

import unittest
from unittest.mock import patch

import cd0

from lci0 import vector as vector_module
from lci0.core import (
    FIXTURE,
    FIXTURE_FIELD,
    LCI,
    LCI_RESOURCE_LIMITS,
    LCIFailure,
    _datum_node_count,
    _pair_payload,
    _value_bytes_length,
    canonical_bytes,
    enforce_structural_resources,
    evaluate_policy,
    field_by_path,
    match_target,
    normalize_proposition,
    project_claim_id,
    project_occurrence,
    proposition_normalization_work,
    scope_relation,
    scope_relation_work,
    target_boundary_work,
    temporal_relation,
    temporal_relation_work,
    validate_basis,
    validate_claim_id,
    validate_dataset_slice,
    validate_frame,
    validate_location,
    validate_loss_account,
    validate_proposition,
    validate_proposition_location_consistency,
    validate_represented_loss,
    validate_scope,
    validate_semantic_boundary,
    validate_stable_ref,
    validate_subject_time,
    validate_warrant_target,
)
from lci0.migration import migrate, refuse_legacy_source, validate_migration_result
from lci0.package import fixture_datum, iter_vectors
from lci0.model import FixtureAuthorityGap, FixtureIntegrityError, RelationResult
from lci0.vector import comparison_signature, execute_row, expected_outcome, input_payload_by_id


def replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


def remove_field(value: cd0.Record, name: str) -> cd0.Record:
    return cd0.record(
        (key, item) for key, item in value.fields if key.path != (name,)
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


def row(vector_id: str) -> dict:
    return next(item for item in iter_vectors() if item["vector_id"] == vector_id)


class DeterministicClosedValidationTests(unittest.TestCase):
    def test_stable_material_declared_order_precedes_unknown_fields(self):
        reference = fixture_datum("stable-ref.target-schema.observed")
        material = field_by_path(reference, "material")
        material = remove_field(material, "object-id")
        material = replace_field(material, "object-version", cd0.string("bad"))
        material = add_field(material, "zzz", cd0.unit())
        malformed = replace_field(reference, "material", material)
        with self.assertRaises(LCIFailure) as caught:
            validate_stable_ref(malformed)
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "invalid-input",
                "MissingRequiredField",
                "stable-reference",
                ("material", "object-id"),
            ),
        )

    def test_nested_version_and_variant_fields_precede_unknown_fields(self):
        scope = fixture_datum("scope.org-acme")
        expression = field_by_path(scope, "expression")
        versioned = replace_field(expression, "schema-version", cd0.integer(1))
        versioned = add_field(versioned, "zzz", cd0.unit())
        malformed = replace_field(scope, "expression", versioned)
        with self.assertRaises(LCIFailure) as caught:
            validate_scope(malformed)
        self.assertEqual(caught.exception.code, "RecursiveUnsupportedNestedVersion")
        self.assertEqual(
            caught.exception.path,
            ("location", "scope", "expression", "schema-version"),
        )

        missing_variant = remove_field(expression, "organization")
        missing_variant = add_field(missing_variant, "zzz", cd0.unit())
        malformed = replace_field(scope, "expression", missing_variant)
        with self.assertRaises(LCIFailure) as caught:
            validate_scope(malformed)
        self.assertEqual(caught.exception.code, "InvalidScope")
        self.assertEqual(caught.exception.path, ("location", "scope", "expression"))

    def test_target_claim_validation_precedes_boundary_and_unknown_failures(self):
        target = fixture_datum("warrant-target.observed.file-alpha.exact")
        boundaries = field_by_path(target, "boundaries")
        first_boundary = next(iter(boundaries.fields))[0].path[0]
        boundaries = remove_field(boundaries, first_boundary)
        malformed = replace_field(target, "boundaries", boundaries)
        malformed = replace_field(malformed, "claim", cd0.unit())
        malformed = add_field(malformed, "zzz", cd0.unit(), LCI)
        with self.assertRaises(LCIFailure) as caught:
            validate_warrant_target(malformed)
        self.assertEqual(
            caught.exception.comparison_key,
            ("migration-refusal", "LegacyFingerprintNotClaimId", "target-shape", ("claim",)),
        )

    def test_loss_account_paths_use_the_frozen_fixture_field_notation(self):
        account = fixture_datum("represented-loss-account.translation-lossy")
        missing = remove_field(account, "source-language")
        with self.assertRaises(LCIFailure) as caught:
            validate_loss_account(missing)
        self.assertEqual(caught.exception.code, "MissingRequiredField")
        self.assertEqual(
            caught.exception.path,
            ("account", "fixture-field:source-language"),
        )

        unknown = add_field(account, "zzz", cd0.unit())
        with self.assertRaises(LCIFailure) as caught:
            validate_loss_account(unknown)
        self.assertEqual(caught.exception.code, "UnknownField")
        self.assertEqual(caught.exception.path, ("account", "fixture-field:zzz"))

    def test_occurrence_nested_wrapper_is_closed_but_entries_remain_open(self):
        occurrence = fixture_datum("claim-occurrence.alpha")
        presentation = add_field(
            field_by_path(occurrence, "presentation"),
            "zzz",
            cd0.unit(),
        )
        malformed = replace_field(occurrence, "presentation", presentation)
        with self.assertRaises(LCIFailure) as caught:
            project_occurrence(malformed)
        self.assertEqual(caught.exception.code, "UnknownField")
        self.assertEqual(caught.exception.path, ("presentation", "zzz"))

        metadata = field_by_path(occurrence, "nonidentity-metadata")
        entries = add_field(field_by_path(metadata, "entries"), "new-inert", cd0.string("x"))
        changed = replace_field(
            occurrence,
            "nonidentity-metadata",
            replace_field(metadata, "entries", entries),
        )
        self.assertEqual(
            project_occurrence(changed).canonical_bytes,
            project_occurrence(occurrence).canonical_bytes,
        )

    def test_n008_keeps_the_exact_machine_path(self):
        actual = execute_row(row("LCI0-N008"))
        expected = expected_outcome(row("LCI0-N008"))
        self.assertEqual(comparison_signature(actual), comparison_signature(expected))
        self.assertEqual(actual.failure.path, ("location", "basis", "revision"))

    def test_stable_material_kind_namespace_keeps_reference_category(self):
        reference = fixture_datum("stable-ref.artifact.file.alpha")
        material = field_by_path(reference, "material")
        malformed = replace_field(
            reference,
            "material",
            replace_field(
                material,
                "kind",
                cd0.identifier(
                    FIXTURE + ("hostile",),
                    ("tag", "fixture-stable-material"),
                ),
            ),
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_stable_ref(malformed)
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "reference-refusal",
                "InvalidStableReference",
                "stable-reference",
                ("material", "kind"),
            ),
        )

    def test_package_symbol_spelling_is_an_unresolved_alias(self):
        reference = fixture_datum("stable-ref.artifact.file.alpha")
        material = replace_field(
            field_by_path(reference, "material"),
            "object-id",
            cd0.identifier(FIXTURE, ("object", "artifact", "MNEME::FILE")),
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_stable_ref(replace_field(reference, "material", material))
        self.assertEqual(
            caught.exception.comparison_key,
            (
                "reference-refusal",
                "UnresolvedAlias",
                "stable-reference",
                ("material", "fixture-field:object-id"),
            ),
        )

    def test_target_kind_schema_pair_failure_uses_target_schema_stage(self):
        observed = fixture_datum("warrant-target.observed.file-alpha.exact")
        executed = fixture_datum("warrant-target.executed.call-17")
        for target, replacement in (
            (observed, field_by_path(executed, "target-schema")),
            (executed, field_by_path(observed, "target-schema")),
        ):
            with self.subTest(target_kind=field_by_path(target, "target-kind")):
                with self.assertRaises(LCIFailure) as caught:
                    validate_warrant_target(
                        replace_field(target, "target-schema", replacement)
                    )
                self.assertEqual(
                    caught.exception.comparison_key,
                    (
                        "invalid-input",
                        "TargetSchemaKindMismatch",
                        "target-schema",
                        ("target-schema",),
                    ),
                )


class ActualResourceJurisdictionTests(unittest.TestCase):
    def test_normalization_formula_and_projection_boundary(self):
        claim = fixture_datum("claim-id.file-alpha-neutral")
        proposition = field_by_path(claim, "proposition")
        work = proposition_normalization_work(proposition, proposition)
        self.assertEqual(work, 2 * _datum_node_count(proposition))
        with patch.dict(LCI_RESOURCE_LIMITS, {"proposition-normalization-work": work}):
            self.assertEqual(canonical_bytes(normalize_proposition(proposition)), canonical_bytes(proposition))
            project_claim_id(claim)
        with patch.dict(LCI_RESOURCE_LIMITS, {"proposition-normalization-work": work - 1}):
            with self.assertRaises(LCIFailure) as caught:
                normalize_proposition(proposition)
            self.assertEqual(
                caught.exception.comparison_key,
                ("resource-refusal", "PropositionNormalizationWorkExceeded", "normalization", ("proposition",)),
            )
            with self.assertRaises(LCIFailure) as caught:
                project_claim_id(claim)
            self.assertEqual(caught.exception.stage, "projection")

    def test_scope_and_temporal_work_at_limit_and_one_over(self):
        left_scope = fixture_datum("scope.region-x")
        right_scope = fixture_datum("scope.region-y")
        scope_work = scope_relation_work(left_scope, right_scope)
        self.assertEqual(
            scope_work,
            2
            + len(field_by_path(field_by_path(left_scope, "expression"), "members").items)
            + len(field_by_path(field_by_path(right_scope, "expression"), "members").items),
        )
        with patch.dict(LCI_RESOURCE_LIMITS, {"scope-relation-work": scope_work}):
            scope_relation(left_scope, right_scope)
        with patch.dict(LCI_RESOURCE_LIMITS, {"scope-relation-work": scope_work - 1}):
            with self.assertRaises(LCIFailure) as caught:
                scope_relation(left_scope, right_scope)
            self.assertEqual(caught.exception.code, "ScopeRelationWorkExceeded")
            self.assertEqual(caught.exception.stage, "matching")

        left_time = fixture_datum("subject-time.interval-0-50-closed")
        right_time = fixture_datum("subject-time.interval-100-124-closed")
        temporal_work = temporal_relation_work(left_time, right_time)
        self.assertEqual(temporal_work, 7)
        with patch.dict(LCI_RESOURCE_LIMITS, {"temporal-relation-work": temporal_work}):
            self.assertEqual(temporal_relation(left_time, right_time), "before")
        with patch.dict(LCI_RESOURCE_LIMITS, {"temporal-relation-work": temporal_work - 1}):
            with self.assertRaises(LCIFailure) as caught:
                temporal_relation(left_time, right_time)
            self.assertEqual(caught.exception.code, "TemporalRelationWorkExceeded")
            self.assertEqual(caught.exception.stage, "matching")

    def test_loss_and_target_work_use_the_actual_public_operation_stage(self):
        account = fixture_datum("represented-loss-account.handoff-authority")
        entries = sum(
            len(item.items) for _, item in account.fields if type(item) is cd0.Sequence
        )
        with patch.dict(LCI_RESOURCE_LIMITS, {"represented-loss-account-entries": entries}):
            validate_loss_account(account)
        with patch.dict(LCI_RESOURCE_LIMITS, {"represented-loss-account-entries": entries - 1}):
            with self.assertRaises(LCIFailure) as caught:
                validate_loss_account(account)
            self.assertEqual(caught.exception.code, "RepresentedLossAccountSizeExceeded")
            self.assertEqual(caught.exception.stage, "validation")

        target = fixture_datum("warrant-target.observed.file-alpha.exact")
        boundaries = field_by_path(target, "boundaries")
        work = target_boundary_work(boundaries)
        with patch.dict(LCI_RESOURCE_LIMITS, {"target-boundary-work": work}):
            validate_warrant_target(target)
        with patch.dict(LCI_RESOURCE_LIMITS, {"target-boundary-work": work - 1}):
            with self.assertRaises(LCIFailure) as caught:
                validate_warrant_target(target)
            self.assertEqual(caught.exception.stage, "validation")
            relation = match_target(target, field_by_path(target, "claim"))
            self.assertIsNotNone(relation.failure)
            self.assertEqual(relation.failure.code, "TargetBoundaryWorkExceeded")
            self.assertEqual(relation.failure.stage, "matching")

    def test_relation_payload_roots_use_the_exact_public_field_names(self):
        cases = (
            (
                lambda: scope_relation(fixture_datum("scope.org-acme"), fixture_datum("scope.dept-research")),
                {"left-scope", "right-scope"},
            ),
            (
                lambda: temporal_relation(fixture_datum("subject-time.instant-100"), fixture_datum("subject-time.instant-124")),
                {"left-subject-time", "right-subject-time"},
            ),
            (
                lambda: validate_proposition_location_consistency(
                    field_by_path(fixture_datum("claim-id.file-alpha-neutral"), "proposition"),
                    field_by_path(fixture_datum("claim-id.file-alpha-neutral"), "location"),
                ),
                {"proposition", "location"},
            ),
            (
                lambda: match_target(
                    fixture_datum("warrant-target.observed.file-alpha.exact"),
                    field_by_path(fixture_datum("warrant-target.observed.file-alpha.exact"), "claim"),
                ),
                {"target", "candidate-claim"},
            ),
        )
        for invoke, expected_names in cases:
            with self.subTest(expected_names=expected_names):
                with patch("lci0.core.enforce_structural_resources", wraps=enforce_structural_resources) as measured:
                    invoke()
                self.assertEqual(measured.call_count, 1)
                payload = measured.call_args.args[0]
                names = {key.path[0] for key, _ in payload.fields}
                self.assertEqual(names, expected_names)
                self.assertEqual(
                    _value_bytes_length(payload),
                    len(canonical_bytes(payload)) - len(cd0.MAGIC) - 1,
                )

    def test_pair_wrapper_keys_are_included_in_aggregate_valuebytes(self):
        left = fixture_datum("scope.org-acme")
        right = fixture_datum("scope.dept-research")
        exact = _pair_payload("left-scope", left, "right-scope", right)
        shorter_names = _pair_payload("l", left, "r", right)
        self.assertGreater(_value_bytes_length(exact), _value_bytes_length(shorter_names))


class GuardAndFreshConstructionTests(unittest.TestCase):
    def test_every_public_resource_guard_returns_only_authorized_lci_or_authority_gap(self):
        unit = cd0.unit()
        empty = cd0.record(())
        guarded_calls = {
            "stable-ref": lambda: validate_stable_ref(unit),
            "scope": lambda: validate_scope(unit),
            "subject-time": lambda: validate_subject_time(unit),
            "dataset-slice": lambda: validate_dataset_slice(unit, ()),
            "semantic-boundary": lambda: validate_semantic_boundary(unit, ()),
            "basis": lambda: validate_basis(unit),
            "frame": lambda: validate_frame(unit),
            "proposition": lambda: validate_proposition(unit),
            "normalizer": lambda: normalize_proposition(unit),
            "location": lambda: validate_location(unit),
            "claim-id": lambda: validate_claim_id(unit),
            "projection": lambda: project_claim_id(empty),
            "occurrence": lambda: project_occurrence(unit),
            "loss-account": lambda: validate_loss_account(unit),
            "represented-loss": lambda: validate_represented_loss(unit),
            "target": lambda: validate_warrant_target(unit),
            "scope-relation": lambda: scope_relation(unit, unit),
            "temporal-relation": lambda: temporal_relation(unit, unit),
            "placement": lambda: validate_proposition_location_consistency(unit, unit),
            "migration": lambda: migrate(unit),
            "migration-parser": lambda: refuse_legacy_source(unit),
            "migration-result": lambda: validate_migration_result(unit),
        }
        for name, invoke in guarded_calls.items():
            with self.subTest(name=name):
                try:
                    invoke()
                except FixtureAuthorityGap:
                    pass
                except LCIFailure as failure:
                    self.assertEqual(len(failure.comparison_key), 4)
                    self.assertIs(type(failure.path), tuple)
                else:
                    self.fail("malformed hostile input unexpectedly succeeded")
        with self.assertRaises(FixtureAuthorityGap):
            match_target(unit, unit)

    def test_migration_uses_fresh_projection_and_never_reads_result_fixtures(self):
        source = fixture_datum("legacy-source.time-100")
        expected = fixture_datum("migration-result.time-100")
        original = __import__("lci0.migration", fromlist=["fixture_datum"]).fixture_datum

        def poisoned(name: str):
            if name.startswith("migration-result."):
                raise AssertionError("precomputed migration result consulted")
            return original(name)

        with patch("lci0.migration.fixture_datum", side_effect=poisoned):
            actual = migrate(source)
        self.assertEqual(canonical_bytes(actual), canonical_bytes(expected))
        self.assertEqual(
            canonical_bytes(field_by_path(actual, "claim-id")),
            project_claim_id(field_by_path(actual, "claim-id")).canonical_bytes,
        )

    def test_source_artifact_is_nonidentity_and_propagates_exactly(self):
        source = fixture_datum("legacy-source.time-100")
        baseline = migrate(source)
        hostile = fixture_datum("legacy-source.hostile-read-eval")
        replacement_source = field_by_path(hostile, "source-artifact")
        changed_wrapper = replace_field(
            source,
            "source-artifact",
            replacement_source,
        )
        changed = migrate(changed_wrapper)
        self.assertEqual(
            canonical_bytes(field_by_path(changed, "claim-id")),
            canonical_bytes(field_by_path(baseline, "claim-id")),
        )
        self.assertNotEqual(
            canonical_bytes(field_by_path(changed, "source")),
            canonical_bytes(field_by_path(baseline, "source")),
        )
        self.assertEqual(
            canonical_bytes(field_by_path(changed, "source")),
            canonical_bytes(replacement_source),
        )
        lineage = field_by_path(changed, "lineage")
        self.assertEqual(len(lineage.items), 1)
        self.assertEqual(
            canonical_bytes(field_by_path(lineage.items[0], "source")),
            canonical_bytes(replacement_source),
        )
        validate_migration_result(changed)
        with self.assertRaises(LCIFailure) as caught:
            migrate(field_by_path(source, "parsed-inert-value"))
        self.assertEqual(caught.exception.path, ("fixture-field:source-artifact",))

    def test_vector_execution_has_no_whole_expected_fixture_accessor(self):
        self.assertFalse(hasattr(vector_module, "fixture_datum"))
        with patch(
            "lci0.package.fixture_datum",
            side_effect=AssertionError("whole-result fixture oracle consulted"),
        ):
            for vector_id in (
                "LCI0-P022",
                "LCI0-P023",
                "LCI0-E2-UNKNOWN",
            ):
                with self.subTest(vector_id=vector_id):
                    vector = row(vector_id)
                    self.assertEqual(
                        comparison_signature(execute_row(vector)),
                        comparison_signature(expected_outcome(vector)),
                    )

            # P024 is intentionally authorially blocked, but execution still
            # must be input-derived and independent of an output-fixture oracle.
            actual = execute_row(row("LCI0-P024"))
            self.assertIsNone(actual.failure)
            payload = input_payload_by_id("LCI0-P024")
            occurrence = actual.outputs["revival"]["new-occurrence"]
            self.assertIsNot(occurrence, payload["predecessor"])
            self.assertEqual(
                canonical_bytes(occurrence),
                canonical_bytes(payload["predecessor"]),
            )

    def test_revival_rejects_a_requested_claim_not_projected_by_predecessor(self):
        payload = input_payload_by_id("LCI0-P024")
        incompatible = fixture_datum("claim-id.file-alpha-corpus-r3")
        outcome = vector_module.execute(
            "revive-inert-occurrence",
            {
                "predecessor": payload["predecessor"],
                "requested-claim": incompatible,
            },
        )
        self.assertIsNotNone(outcome.failure)
        self.assertEqual(outcome.failure.code, "ClaimIdCacheMismatch")


class SuccessorAuditRegressionTests(unittest.TestCase):
    def test_every_operation_payload_is_closed_before_dispatch(self):
        rows = list(iter_vectors())
        first_by_operation = {}
        for vector in rows:
            first_by_operation.setdefault(vector["operation"], vector["vector_id"])
        self.assertEqual(
            set(first_by_operation),
            set(vector_module.OPERATION_PAYLOAD_SCHEMAS),
        )
        for operation in sorted(vector_module.OPERATION_PAYLOAD_SCHEMAS):
            with self.subTest(operation=operation, fault="missing"):
                outcome = vector_module.execute(operation, {})
                self.assertIsInstance(outcome.failure, LCIFailure)
                self.assertEqual(outcome.failure.code, "MissingRequiredField")
            with self.subTest(operation=operation, fault="unknown"):
                payload = input_payload_by_id(first_by_operation[operation])
                outcome = vector_module.execute(
                    operation,
                    {**payload, "future-operation-field": cd0.unit()},
                )
                self.assertIsInstance(outcome.failure, LCIFailure)
                self.assertEqual(outcome.failure.code, "UnknownField")

    def test_placement_and_occurrence_shortcuts_use_recursive_validators(self):
        n014 = input_payload_by_id("LCI0-N014")["claim"]
        placement = vector_module.execute(
            "proposition-location-consistent",
            {
                "proposition": field_by_path(n014, "proposition"),
                "location": field_by_path(n014, "location"),
            },
        )
        self.assertEqual(
            placement.failure.comparison_key,
            (
                "projection-refusal",
                "PropositionLocationInconsistent",
                "basis",
                ("location", "basis"),
            ),
        )

        occurrence = replace_field(
            fixture_datum("claim-occurrence.alpha"),
            "claimant",
            cd0.unit(),
        )
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "validate-occurrence",
                {"occurrence": occurrence},
            )

    def test_policy_vector_results_change_with_supplied_kind_trust_query_and_loss(self):
        p022 = input_payload_by_id("LCI0-P022")
        observed = fixture_datum("warrant-target.observed.file-alpha.exact")
        observed_outcome = vector_module.execute(
            "evaluate-admissibility-under-two-policies",
            {
                **p022,
                "target": observed,
                "claim": field_by_path(observed, "claim"),
            },
        )
        self.assertIsNone(observed_outcome.failure)
        self.assertFalse(observed_outcome.outputs["admissibility-differs"])
        for name in ("policy-a-decision", "policy-b-decision"):
            self.assertEqual(
                field_by_path(observed_outcome.outputs[name], "decision").path[-1],
                "accept-direct",
            )

        untrusted = fixture_datum("warrant-target.externally-attested.file-alpha.untrusted")
        untrusted_outcome = vector_module.execute(
            "evaluate-admissibility-under-two-policies",
            {
                **p022,
                "target": untrusted,
                "claim": field_by_path(untrusted, "claim"),
            },
        )
        self.assertEqual(untrusted_outcome.failure.code, "AdmissibilityUndetermined")

        inherited = fixture_datum("warrant-target.inherited.file-alpha")
        loss_outcome = vector_module.execute(
            "evaluate-admissibility-under-two-policies",
            {
                **p022,
                "target": inherited,
                "claim": field_by_path(inherited, "claim"),
            },
        )
        self.assertIsNone(loss_outcome.failure)
        self.assertEqual(
            field_by_path(loss_outcome.outputs["policy-a-decision"], "decision").path[-1],
            "reject-inherited-testimony",
        )
        self.assertEqual(
            field_by_path(loss_outcome.outputs["policy-b-decision"], "decision").path[-1],
            "accept-limited-testimony",
        )

        p023 = input_payload_by_id("LCI0-P023")
        query = p023["fresh-query"]
        expression = replace_field(
            field_by_path(query, "expression"),
            "tick",
            cd0.integer(125),
        )
        query = replace_field(query, "expression", expression)
        query_outcome = vector_module.execute(
            "evaluate-freshness-two-query-times",
            {**p023, "fresh-query": query},
        )
        self.assertIsNone(query_outcome.failure)
        freshness = field_by_path(query_outcome.outputs["fresh-decision"], "freshness")
        self.assertEqual(field_by_path(freshness, "age-ticks").value, 1)

    def test_normalization_and_differential_shortcuts_are_input_sensitive(self):
        payload = input_payload_by_id("LCI0-E4-STRUCTURAL-DATASET-SLICE")
        equal = vector_module.execute(
            "normalize-preprojection-coordinate",
            {**payload, "right": payload["left"]},
        )
        self.assertIsNone(equal.failure)
        self.assertTrue(equal.outputs["structurally-equal-after-normalization"])
        self.assertTrue(equal.outputs["claim-id-merge-permitted"])

        wrong_coordinate = vector_module.execute(
            "normalize-preprojection-coordinate",
            {
                **payload,
                "coordinate": cd0.identifier(FIXTURE, ("claim-coordinate", "scope")),
            },
        )
        self.assertIsInstance(wrong_coordinate.failure, LCIFailure)

        evidence_payload = input_payload_by_id("LCI0-N031")
        evidence = evidence_payload["evidence"]
        equal_evidence = replace_field(
            evidence,
            "right-output",
            field_by_path(evidence, "left-output"),
        )
        with self.assertRaises(vector_module.FixtureAuthorityGap):
            vector_module.execute(
                "differential-project",
                {"evidence": equal_evidence},
            )

    def test_migration_result_validation_and_classification_recognition_are_semantic(self):
        valid = fixture_datum("migration-result.time-100")
        self.assertEqual(validate_migration_result(valid), valid)
        with self.assertRaises(vector_module.FixtureAuthorityGap):
            vector_module.execute(
                "validate-migration-result",
                {"migration-result": valid},
            )

        classifications = (
            "exact",
            "exact-after-explicit-tagging",
            "new-identity-required",
            "lossy-with-represented-loss",
            "rejected",
            "deferred-to-named-calculus",
            "privileged-runtime-relation-outside-claim-id",
        )
        malformed_base = replace_field(
            fixture_datum("migration-result.inert-predecessor"),
            "claim",
            cd0.unit(),
        )
        for classification in classifications:
            with self.subTest(classification=classification):
                candidate = replace_field(
                    malformed_base,
                    "classification",
                    cd0.identifier(
                        FIXTURE,
                        ("migration-classification", classification),
                    ),
                )
                with self.assertRaises(FixtureAuthorityGap):
                    validate_migration_result(candidate)

    def test_corpus_completion_operation_does_not_fabricate_matcher_failure(self):
        payload = input_payload_by_id("LCI0-P021")
        complete_receipt = field_by_path(
            field_by_path(payload["complete-target"], "boundaries"),
            "completion-receipt-or-trace",
        )
        incomplete_boundaries = replace_field(
            field_by_path(payload["incomplete-target"], "boundaries"),
            "completion-receipt-or-trace",
            complete_receipt,
        )
        now_complete = replace_field(
            payload["incomplete-target"],
            "boundaries",
            incomplete_boundaries,
        )
        with self.assertRaises(FixtureIntegrityError):
            vector_module.execute(
                "compare-corpus-completion-targets",
                {**payload, "incomplete-target": now_complete},
            )

    def test_unpinned_proposition_form_does_not_reuse_universal_output(self):
        claim = fixture_datum("claim-id.file-alpha-neutral")
        with self.assertRaises(vector_module.FixtureAuthorityGap):
            vector_module.execute(
                "proposition-location-consistent",
                {
                    "proposition": field_by_path(claim, "proposition"),
                    "location": field_by_path(claim, "location"),
                },
            )

    def test_bridge_validation_is_closed_and_mapping_sensitive(self):
        payload = input_payload_by_id("LCI0-E7-BRIDGE-PRESENT")

        unknown = vector_module.execute(
            "apply-stable-ref-bridge",
            {**payload, "bridge": add_field(payload["bridge"], "future", cd0.unit())},
        )
        self.assertEqual(unknown.failure.code, "UnknownField")

        mappings = field_by_path(payload["bridge"], "mapping")
        mapping = replace_field(
            mappings.items[0],
            "source-material",
            cd0.string("not-alpha-file"),
        )
        altered_bridge = replace_field(
            payload["bridge"],
            "mapping",
            cd0.sequence((mapping,)),
        )
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "apply-stable-ref-bridge",
                {**payload, "bridge": altered_bridge},
            )

        source_material = replace_field(
            field_by_path(payload["source-reference"], "material"),
            "source-material",
            cd0.string("outside-declared-domain"),
        )
        source = replace_field(
            payload["source-reference"],
            "material",
            source_material,
        )
        unresolved = vector_module.execute(
            "apply-stable-ref-bridge",
            {**payload, "source-reference": source},
        )
        self.assertEqual(unresolved.failure.code, "UnresolvedAlias")

    def test_reserved_profile_location_accepts_only_the_exact_empty_record(self):
        payload = input_payload_by_id("LCI0-I12-PROFILE-LOCATION-RESERVED")
        exact = vector_module.execute("validate-profile-location", payload)
        self.assertIsNone(exact.failure)
        self.assertTrue(exact.outputs["valid"])

        opened = vector_module.execute(
            "validate-profile-location",
            {"profile-location": add_field(payload["profile-location"], "future", cd0.unit())},
        )
        self.assertEqual(opened.failure.code, "UnknownField")

    def test_version_governance_rejects_unknown_and_inconsistent_evidence(self):
        payload = input_payload_by_id("LCI0-E3-IMPLEMENTATION-CORRECTION")
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "classify-version-governance",
                {
                    **payload,
                    "change": cd0.identifier(FIXTURE, ("change-class", "future-change")),
                },
            )

        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "classify-version-governance",
                {**payload, "claim-ids-unchanged": cd0.boolean(False)},
            )

        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "classify-version-governance",
                {**payload, "claim-ids-unchanged": cd0.integer(1)},
            )

    def test_normalizer_evidence_and_equal_revision_are_not_shortcuts(self):
        evidence = input_payload_by_id("LCI0-E3-NORMALIZER-BINDING")
        missing = vector_module.execute(
            "validate-normalizer-conformance-evidence",
            {
                **evidence,
                "binding": remove_field(evidence["binding"], "normalizer-content-identity"),
            },
        )
        self.assertEqual(missing.failure.code, "MissingRequiredField")

        mutated_binding = replace_field(
            evidence["binding"],
            "deterministic",
            cd0.boolean(False),
        )
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "validate-normalizer-conformance-evidence",
                {**evidence, "binding": mutated_binding},
            )

        revision = input_payload_by_id("LCI0-E3-MEANING-CHANGE-SAME-VERSION")
        proposal = revision["proposal"]
        equal_proposal = replace_field(
            proposal,
            "after-claim-id",
            field_by_path(proposal, "before-claim-id"),
        )
        with self.assertRaises(vector_module.FixtureAuthorityGap):
            vector_module.execute(
                "validate-normalizer-revision",
                {"proposal": equal_proposal},
            )

    def test_migration_mapping_checks_prior_terms(self):
        payload = input_payload_by_id("LCI0-E9-CLASS-EXACT")
        wrong_terms = cd0.sequence(
            (
                cd0.identifier(
                    FIXTURE,
                    ("prior-ruling-migration-classification", "x"),
                ),
            )
        )
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "map-migration-classification",
                {**payload, "prior-ruling-terms": wrong_terms},
            )

    def test_claim_comparison_operations_derive_equal_and_invalid_cases(self):
        canonical = input_payload_by_id("LCI0-P002")
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "canonicalize-record-order",
                {
                    **canonical,
                    "left-construction-order": cd0.sequence(()),
                },
            )
        with self.assertRaises(FixtureAuthorityGap):
            vector_module.execute(
                "canonicalize-record-order",
                {**canonical, "left-claim": cd0.unit()},
            )

        claim_set = input_payload_by_id("LCI0-P008")
        first = claim_set["claims"].items[0]
        duplicate = vector_module.execute(
            "compare-claim-id-set",
            {"claims": cd0.sequence((first, first))},
        )
        self.assertIsNone(duplicate.failure)
        self.assertFalse(duplicate.outputs["pairwise-distinct"])
        self.assertEqual(
            duplicate.outputs["different-coordinate"],
            "claim-coordinate/none",
        )

    def test_metadata_projection_flags_change_when_semantic_core_changes(self):
        payload = input_payload_by_id("LCI0-METADATA-NEUTRAL-ALL-FIELDS")
        semantic_change = fixture_datum("claim-occurrence.proposition-corrected")
        outcome = vector_module.execute(
            "project-occurrences",
            {**payload, "mutated-metadata": semantic_change},
        )
        self.assertIsNone(outcome.failure)
        for name in (
            "claimant-neutral",
            "assertion-time-neutral",
            "provenance-neutral",
            "lineage-neutral",
            "presentation-neutral",
            "unknown-open-metadata-neutral",
        ):
            self.assertFalse(outcome.outputs[name])

    def test_digest_comparison_uses_envelopes_even_when_inputs_are_equal(self):
        payload = input_payload_by_id("LCI0-E8-DIGEST-NOT-ENVELOPE")
        equal = vector_module.execute(
            "compare-claim-digests-and-envelopes",
            {**payload, "right-claim-id": payload["left-claim-id"]},
        )
        self.assertIsNone(equal.failure)
        self.assertTrue(equal.outputs["digests-equal"])
        self.assertTrue(equal.outputs["claim-id-envelopes-equal"])
        self.assertTrue(equal.outputs["semantic-claim-id-equal"])
        self.assertFalse(equal.outputs["envelope-resolution-required"])

    def test_translation_loss_and_receipts_are_closed(self):
        lossy = input_payload_by_id("LCI0-P026")
        open_loss = add_field(lossy["loss"], "future", cd0.unit(), LCI)
        loss_outcome = vector_module.execute(
            "translate-with-represented-loss",
            {**lossy, "loss": open_loss},
        )
        self.assertEqual(loss_outcome.failure.code, "UnknownField")

        exact = input_payload_by_id("LCI0-P025")
        open_receipt = add_field(
            exact["target-receipt"],
            "future",
            cd0.unit(),
        )
        receipt_outcome = vector_module.execute(
            "translate-exactly",
            {**exact, "target-receipt": open_receipt},
        )
        self.assertEqual(receipt_outcome.failure.code, "UnknownField")

    def test_restore_validates_wrapper_before_privilege_refusal(self):
        payload = input_payload_by_id("LCI0-N030")
        malformed = add_field(payload["source"], "future", cd0.unit())
        outcome = vector_module.execute(
            "restore-live-warrant",
            {"source": malformed},
        )
        self.assertEqual(outcome.failure.category, "invalid-input")
        self.assertEqual(outcome.failure.code, "UnknownField")

    def test_equal_target_output_is_derived(self):
        targets = input_payload_by_id("LCI0-P013")
        equal = vector_module.execute(
            "compare-warrant-targets",
            {**targets, "right-target": targets["left-target"]},
        )
        self.assertIsNone(equal.failure)
        self.assertTrue(equal.outputs["embedded-claim-same"])
        self.assertTrue(equal.outputs["warrant-targets-equal"])
        self.assertEqual(equal.outputs["difference"], "target-coordinate/none")

    def test_differential_equal_output_stops_at_the_authority_gap(self):
        payload = input_payload_by_id("LCI0-N031")
        evidence = payload["evidence"]
        equal_evidence = replace_field(
            evidence,
            "right-output",
            field_by_path(evidence, "left-output"),
        )
        with self.assertRaisesRegex(
            vector_module.FixtureAuthorityGap,
            "no frozen equal-output differential result",
        ):
            vector_module.execute(
                "differential-project",
                {"evidence": equal_evidence},
            )

    def test_narrowing_is_authorized_by_target_schema_not_proposition_alone(self):
        executed = fixture_datum("warrant-target.executed.call-17")
        monotone_payload = input_payload_by_id("LCI0-P015")
        observed = monotone_payload["target"]
        executed_boundaries = field_by_path(executed, "boundaries")
        executed_boundaries = replace_field(
            executed_boundaries,
            "coverage-scope",
            field_by_path(field_by_path(observed, "boundaries"), "coverage-scope"),
        )
        transplanted = replace_field(executed, "claim", field_by_path(observed, "claim"))
        transplanted = replace_field(transplanted, "boundaries", executed_boundaries)

        relation = match_target(transplanted, monotone_payload["candidate-claim"])
        self.assertIsNotNone(relation.failure)
        self.assertEqual(relation.failure.code, "ScopeNarrowingNotDeclared")

    def test_exact_matching_still_enforces_coverage_and_corpus_coherence(self):
        observed = fixture_datum("warrant-target.observed.file-alpha.exact")
        boundaries = replace_field(
            field_by_path(observed, "boundaries"),
            "coverage-scope",
            fixture_datum("scope.tenant-b"),
        )
        insufficient = replace_field(observed, "boundaries", boundaries)
        relation = match_target(insufficient, field_by_path(observed, "claim"))
        self.assertIsNotNone(relation.failure)
        self.assertEqual(relation.failure.code, "ScopeNarrowingCoverageInsufficient")

        completion = fixture_datum("warrant-target.corpus-completion.absence-docs.complete")
        r3_basis = field_by_path(
            field_by_path(fixture_datum("claim-id.file-alpha-corpus-r3"), "location"),
            "basis",
        )
        completion_boundaries = replace_field(
            field_by_path(completion, "boundaries"),
            "exact-corpus-basis",
            r3_basis,
        )
        mismatched = replace_field(completion, "boundaries", completion_boundaries)
        relation = match_target(mismatched, field_by_path(completion, "claim"))
        self.assertIsNotNone(relation.failure)
        self.assertEqual(relation.failure.code, "BasisMismatch")

    def test_policy_predicates_precede_scope_narrowing_acceptance(self):
        narrowed = RelationResult("supports-by-scope-narrowing")
        decision = evaluate_policy(
            "policy-b",
            narrowed,
            target_kind="externally-attested",
            age=0,
            represented_loss="identity-bearing-loss",
            trusted_external=True,
        )
        self.assertFalse(decision.accepted)
        self.assertEqual(decision.code, "reject-represented-loss")

        with self.assertRaises(LCIFailure) as caught:
            evaluate_policy(
                "policy-b",
                narrowed,
                target_kind="externally-attested",
                age=0,
                trusted_external=False,
            )
        self.assertEqual(caught.exception.code, "AdmissibilityUndetermined")

        decision = evaluate_policy(
            "policy-b",
            narrowed,
            target_kind="externally-attested",
            age=999,
            trusted_external=True,
        )
        self.assertFalse(decision.accepted)
        self.assertEqual(decision.code, "reject-stale")

        decision = evaluate_policy(
            "policy-b",
            RelationResult("exact-target"),
            target_kind="policy-evaluation",
            age=0,
        )
        self.assertTrue(decision.accepted)
        self.assertEqual(decision.code, "accept-limited-testimony")

    def test_proposition_subject_is_arbitrary_cd0_but_its_wrapper_is_closed(self):
        proposition = field_by_path(
            fixture_datum("claim-id.file-alpha-neutral"),
            "proposition",
        )
        arguments = field_by_path(proposition, "arguments")
        artifact = replace_field(field_by_path(arguments, "artifact"), "value", cd0.unit())
        arbitrary_subject = replace_field(
            proposition,
            "arguments",
            replace_field(arguments, "artifact", artifact),
        )
        self.assertEqual(validate_proposition(arbitrary_subject), arbitrary_subject)

        open_wrapper = add_field(artifact, "future-subject-rule", cd0.unit())
        malformed = replace_field(
            proposition,
            "arguments",
            replace_field(arguments, "artifact", open_wrapper),
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_proposition(malformed)
        self.assertEqual(caught.exception.code, "UnknownField")

    def test_corpus_basis_rejects_a_revision_from_another_logical_corpus(self):
        claim = fixture_datum("claim-id.file-alpha-corpus-r3")
        basis = field_by_path(field_by_path(claim, "location"), "basis")
        mismatched = replace_field(
            basis,
            "revision",
            fixture_datum("stable-ref.revision.beta.1"),
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_basis(mismatched)
        self.assertEqual(caught.exception.code, "InvalidBasis")
        self.assertEqual(caught.exception.path, ("location", "basis", "revision"))

    def test_generic_nested_alias_path_is_deep_while_n008_keeps_its_contract(self):
        reference = fixture_datum("stable-ref.artifact.file.alpha")
        material = replace_field(
            field_by_path(reference, "material"),
            "object-id",
            cd0.identifier(FIXTURE, ("object", "artifact", "latest")),
        )
        alias = replace_field(reference, "material", material)
        with self.assertRaises(LCIFailure) as caught:
            validate_stable_ref(alias, path=("outer", "reference"))
        self.assertEqual(
            caught.exception.path,
            ("outer", "reference", "material", "fixture-field:object-id"),
        )

        n008 = execute_row(row("LCI0-N008"))
        self.assertEqual(n008.failure.path, ("location", "basis", "revision"))


if __name__ == "__main__":
    unittest.main()
