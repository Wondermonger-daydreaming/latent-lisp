"""Permanent regression witnesses for the ten LCI/0 authorial closures.

Acceptance surface: the 50 successor closure vectors instantiated by fixture
overlay 0.2 (4 formerly blocked official vectors, 38 formerly blocked
relation companion paths, 8 formerly blocked hostile tuples), executed
self-contained from the verified overlay members, plus the four
register-only closure records (LCI0-AC-005/006/008/009) exercised through
their retained witnesses.

Comparison discipline (OVERLAY-BUILD-RECEIPT.md §8): where the overlay
carries ``canonical_cd0_hex`` the produced canonical octets are compared
byte-for-byte; where it carries a semantic JSON document the produced
semantic result is compared for exact equality.

Requires the 0.2 overlay in the fixture root (``fixture_package.py
materialize-overlay``); the tests fail loudly when it is absent, because the
closure surfaces are normative, not optional.
"""

from __future__ import annotations

import hashlib
import unittest

import cd0

from lci0 import closure, overlay
from lci0.core import (
    CD0_BUDGET,
    LCIFailure,
    canonical_bytes,
    evaluate_policy,
    field_by_path,
    match_target,
    validate_basis,
)
from lci0.migration import validate_migration_result
from lci0.model import FixtureAuthorityGap, RelationResult
from lci0.package import fixture_datum
from lci0.protocol import request as differential_request
from lci0.runner import run_request
from lci0.vector import execute


FIXTURE = ("lisp-plus", "lci", "0", "fixture")

# Retained witness identities from the reviewed divergence ledger
# (LCI0-IMPLEMENTATION-DIVERGENCES.md, members of the verified closure
# packet).  Each witness is rebuilt from frozen fixtures and byte-verified
# against these digests before it is executed.
AC006_WITNESS = ("7c92ea0639c7de40dbed630587b9ecbf1ce36e374bb66db966d6536aa1c1a0be", 4005)
AC008_WITNESS = ("565494e413cb849836d922b3ae6455c771f2f7f2c0a31ac4b30d9991ccee3726", 31107)
AC009_WITNESS = ("d0baf4a9470db970e014b707509d79e1c25581b320c100fda1ee66a5f6218b0b", 20341)


def _replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


def _decode(entry_input: dict) -> cd0.Datum:
    encoded = bytes.fromhex(entry_input["canonical_cd0_hex"])
    digest = hashlib.sha256(encoded).hexdigest()
    if digest != entry_input["sha256_checksum_of_canonical_octets"]:
        raise AssertionError("overlay member input identity mismatch")
    if len(encoded) != int(entry_input["canonical_octets_byte_count"]):
        raise AssertionError("overlay member input byte count mismatch")
    return cd0.decode_exact(encoded, CD0_BUDGET)


def _semantic_failure_context(failure: LCIFailure) -> dict:
    rendered = {}
    for name, value in failure.context:
        key = name.removeprefix("fixture-field:").replace("-", "_")
        if type(value) is cd0.Integer:
            rendered[key] = value.value
        elif type(value) is cd0.String:
            rendered[key] = value.value
        else:
            rendered[key] = repr(value)
    return rendered


class ClosureVectorTests(unittest.TestCase):
    """All 50 successor vectors, executed from the verified overlay."""

    @classmethod
    def setUpClass(cls):
        if not overlay.overlay_present():
            raise AssertionError(
                "fixture overlay 0.2 is required: run fixture_package.py "
                "materialize-overlay --fixture-root <root>"
            )
        cls.index = overlay.index()

    def test_overlay_counts_and_supersession_keys(self):
        self.assertEqual(
            self.index["counts"],
            {"closure_records": 4, "hostile": 8, "relation_failures": 38, "supersessions": 4},
        )
        self.assertEqual(
            set(self.index["supersession_keys"]),
            {"LCI0-N012", "LCI0-E5-COVERAGE-INSUFFICIENT", "LCI0-P029", "LCI0-P024"},
        )

    def test_four_superseded_official_vectors(self):
        """LCI0-AC-001 / AC-003 / AC-004 / AC-010: the four formerly blocked
        official vectors now produce the ruled expected results."""

        checked = 0
        for key, entry in overlay.supersessions().items():
            member = overlay.member(entry["member"])
            with self.subTest(vector=key, successor=entry["successor_vector_id"]):
                document = _decode(member["input"])
                vector_id, payload, outcome = closure.execute_envelope(document)
                self.assertEqual(vector_id, key)
                if entry["expected_result_encoding"] == "canonical_cd0_hex":
                    produced = closure.outcome_canonical_octets(outcome)
                    self.assertEqual(
                        hashlib.sha256(produced).hexdigest(),
                        entry["expected_canonical_octets_sha256"],
                    )
                    self.assertEqual(
                        produced.hex(), entry["expected_canonical_cd0_hex"]
                    )
                else:
                    self.assertEqual(key, "LCI0-P024")
                    semantic = closure.revival_semantics(payload, outcome)
                    self.assertEqual(semantic, member["exact_expected_result"])
                checked += 1
        self.assertEqual(checked, 4)

    def test_38_relation_companion_failures(self):
        """LCI0-AC-002: every formerly blocked relation companion path yields
        the ruled exact companion failure with precedence evidence."""

        checked = 0
        for machine_path, entry in overlay.relation_failures().items():
            member = overlay.member(entry["member"])
            with self.subTest(machine_path=machine_path):
                document = _decode(member["input"])
                semantic = closure.execute_direct(member["operation"], document)
                self.assertEqual(semantic, member["exact_expected_result"])
                # index coordinates agree with the produced failure
                self.assertEqual(semantic["failure"]["category"], entry["category"])
                self.assertEqual(semantic["failure"]["code"], entry["code"])
                self.assertEqual(semantic["failure"]["stage"], entry["stage"])
                self.assertEqual(semantic["failure"]["semantic_path"], entry["semantic_path"])
                self.assertEqual(semantic["relation"], entry["relation"])
                checked += 1
        self.assertEqual(checked, 38)

    def test_8_hostile_expectations(self):
        """LCI0-AC-005 / AC-007: the eight formerly blocked hostile requests
        receive their exact ruled results through the implementation."""

        checked = 0
        for slug, entry in overlay.hostile_expectations().items():
            member = overlay.member(entry["member"])
            operation = member["operation"]
            with self.subTest(request=slug, operation=operation):
                document = _decode(member["input"])
                if operation in closure.DIRECT_DOCUMENT_OPERATIONS:
                    semantic = closure.execute_direct(operation, document)
                elif operation == "hostile-evaluate-policy-c":
                    semantic = closure.evaluate_policy_c(document)
                else:
                    vector_id, payload, outcome = closure.execute_envelope(document)
                    if operation == "conformance-validation":
                        semantic = closure.conformance_semantics(outcome)
                    elif operation == "migrate-v1":
                        semantic = closure.migration_failure_semantics(outcome)
                    else:
                        raise AssertionError(f"unrouted hostile operation {operation!r}")
                self.assertEqual(semantic, member["exact_expected_result"])
                checked += 1
        self.assertEqual(checked, 8)

    def test_hostile_requests_never_escape_host_exceptions_via_runner(self):
        """LCI0-AC-007: through the production runner the hostile requests are
        closed responses — structural failure documents or the fail-closed
        authority gap, never host exception prose."""

        for slug, entry in overlay.hostile_expectations().items():
            member = overlay.member(entry["member"])
            with self.subTest(request=slug):
                response = run_request(
                    differential_request(
                        f"closure:{slug}",
                        member["operation"],
                        member["input"]["canonical_cd0_hex"],
                    )
                )
                self.assertIn(
                    response["protocol_status"],
                    {"success", "fixture-authority-gap"},
                )
                blob = repr(response)
                self.assertNotIn("KeyError", blob)
                self.assertNotIn("Traceback", blob)


class ClosureRecordTests(unittest.TestCase):
    """The four register-only closures, exercised via retained witnesses."""

    @classmethod
    def setUpClass(cls):
        if not overlay.overlay_present():
            raise AssertionError("fixture overlay 0.2 is required")
        cls.records = overlay.closure_records()

    def test_ac005_policy_evaluation_order_and_spelling(self):
        record = overlay.member(
            self.records["LCI0-AC-005-POLICY-EVALUATION-ORDER"]["member"]
        )
        ruled = record["unique_normative_result_or_explicit_deferral"]
        # all-at-once stale/loss/trust witness rejects represented loss first
        decision = evaluate_policy(
            "policy-b",
            RelationResult("exact-target"),
            target_kind="externally-attested",
            age=999,
            represented_loss="identity-bearing-loss",
            trusted_external=False,
        )
        self.assertFalse(decision.accepted)
        self.assertEqual(
            "reject-" + ruled["combined_stale_loss_trust_result"].removeprefix("reject-"),
            decision.code,
        )
        # registered external-principal decision spelling
        spelling = ruled["external_principal_decision_identifier"].split("/")[-1]
        decision = evaluate_policy(
            "policy-b",
            RelationResult("exact-target"),
            target_kind="externally-attested",
            age=0,
            trusted_external=False,
        )
        self.assertFalse(decision.accepted)
        self.assertEqual(decision.code, spelling)
        # both policies consulted, Policy-A before Policy-B, on the pinned
        # two-policy operation
        consultation = ruled["consultation_rule"]
        self.assertTrue(consultation["policy_a_consulted"])
        self.assertTrue(consultation["policy_b_consulted"])
        self.assertEqual(consultation["actual_order"], ["Policy-A", "Policy-B"])
        from lci0.vector import input_payload_by_id

        p022 = input_payload_by_id("LCI0-P022")
        outcome = execute("evaluate-admissibility-under-two-policies", p022)
        self.assertIsNone(outcome.failure)
        names = list(outcome.outputs)
        self.assertLess(names.index("policy-a-decision"), names.index("policy-b-decision"))
        # F-valued relations are hard-inadmissible before any policy
        floor = evaluate_policy(
            "policy-a",
            RelationResult(
                failure=LCIFailure(
                    "relation-undetermined", "ScopeRelationUnknown", "target-relation"
                )
            ),
        )
        self.assertTrue(floor.hard_inadmissible)
        self.assertFalse(floor.policy_consulted)

    def test_ac005_policy_c_fail_closed_document(self):
        record = overlay.member(
            self.records["LCI0-AC-005-POLICY-EVALUATION-ORDER"]["member"]
        )
        ruled = record["unique_normative_result_or_explicit_deferral"]["unknown_policy_c"]
        with self.assertRaises(FixtureAuthorityGap):
            evaluate_policy("policy-c", RelationResult("exact-target"))
        hostile = overlay.hostile_expectations()["policy-c-fail-closed"]
        member = overlay.member(hostile["member"])
        document = _decode(member["input"])
        self.assertEqual(closure.evaluate_policy_c(document), ruled)

    def test_ac006_corpus_basis_coherence_exact_tuple(self):
        record = overlay.member(
            self.records["LCI0-AC-006-CORPUS-BASIS-COHERENCE"]["member"]
        )
        ruled = record["unique_normative_result_or_explicit_deferral"]
        basis_r3 = field_by_path(
            field_by_path(fixture_datum("claim-id.file-alpha-corpus-r3"), "location"),
            "basis",
        )
        boundary_r4 = field_by_path(
            field_by_path(
                field_by_path(fixture_datum("claim-id.file-alpha-corpus-r4"), "location"),
                "basis",
            ),
            "semantic-boundary",
        )
        witness = _replace_field(basis_r3, "semantic-boundary", boundary_r4)
        encoded = canonical_bytes(witness)
        self.assertEqual(
            (hashlib.sha256(encoded).hexdigest(), len(encoded)), AC006_WITNESS
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_basis(witness, path=())
        failure = caught.exception
        self.assertEqual(failure.category, ruled["category"])
        self.assertEqual(failure.code, ruled["code"])
        self.assertEqual(failure.stage, ruled["stage"])
        self.assertEqual(closure.semantic_path(failure.path), ruled["semantic_path"])
        self.assertEqual(_semantic_failure_context(failure), ruled["context"])

    def test_ac008_migration_classification_exact_tuple(self):
        record = overlay.member(
            self.records["LCI0-AC-008-MIGRATION-CLASSIFICATION"]["member"]
        )
        ruled = record["unique_normative_result_or_explicit_deferral"]
        witness = _replace_field(
            fixture_datum("migration-result.inert-predecessor"),
            "classification",
            cd0.identifier(
                FIXTURE, ("migration-classification", "exact-after-explicit-tagging")
            ),
        )
        encoded = canonical_bytes(witness)
        self.assertEqual(
            (hashlib.sha256(encoded).hexdigest(), len(encoded)), AC008_WITNESS
        )
        with self.assertRaises(LCIFailure) as caught:
            validate_migration_result(witness)
        failure = caught.exception
        self.assertEqual(failure.category, ruled["category"])
        self.assertEqual(failure.code, ruled["code"])
        self.assertEqual(failure.stage, ruled["stage"])
        self.assertEqual(closure.semantic_path(failure.path), ruled["semantic_path"])
        self.assertEqual(_semantic_failure_context(failure), ruled["context"])
        # the five valid frozen result documents and exact N028 retain their
        # standing (spot-check the untouched original)
        original = fixture_datum("migration-result.inert-predecessor")
        self.assertEqual(validate_migration_result(original), original)

    def test_ac009_target_boundary_deferral_exact_tuple(self):
        record = overlay.member(
            self.records["LCI0-AC-009-TARGET-BOUNDARY-COHERENCE"]["member"]
        )
        ruled = record["unique_normative_result_or_explicit_deferral"]
        target = fixture_datum("warrant-target.derived.one-equals-one")
        neutral = fixture_datum("claim-id.file-alpha-neutral")
        boundaries = field_by_path(target, "boundaries")
        premises = field_by_path(boundaries, "premise-claim-ids")
        witness = _replace_field(
            target,
            "boundaries",
            _replace_field(
                boundaries,
                "premise-claim-ids",
                cd0.sequence([neutral, *premises.items[1:]]),
            ),
        )
        encoded = canonical_bytes(witness)
        self.assertEqual(
            (hashlib.sha256(encoded).hexdigest(), len(encoded)), AC009_WITNESS
        )
        result = match_target(witness, field_by_path(witness, "claim"))
        self.assertIsNotNone(result.failure)
        failure = result.failure
        self.assertEqual(failure.category, ruled["category"])
        self.assertEqual(failure.code, ruled["code"])
        self.assertEqual(failure.stage, ruled["stage"])
        self.assertEqual(closure.semantic_path(failure.path), ruled["semantic_path"])
        # the registered derived configuration and pinned checks are retained
        untouched = match_target(target, field_by_path(target, "claim"))
        self.assertIsNone(untouched.failure)
        self.assertEqual(untouched.relation, "exact-target")


if __name__ == "__main__":
    unittest.main()
