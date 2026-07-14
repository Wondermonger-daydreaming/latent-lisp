from __future__ import annotations

import ast
from pathlib import Path
import unittest

import cd0

from lci0.core import CD0_BUDGET, FIXTURE, FIXTURE_FIELD, LCI, canonical_bytes, failure
from lci0.model import (
    AUTHORIZED_LCI_FAILURE_CODES,
    FixtureAuthorityGap,
    FixtureIntegrityError,
    LCIFailure,
)
from lci0.package import definitions, iter_vectors
from lci0.protocol import (
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
    request,
)
from lci0.runner import run_request
from lci0.vector import comparison_signature, execute_row, expected_outcome


BLOCKED_VECTOR_IDS = {
    "LCI0-N012",
    "LCI0-E5-COVERAGE-INSUFFICIENT",
    "LCI0-P024",
    "LCI0-P029",
}


def _replace_field(value: cd0.Record, name: str, replacement: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (key, replacement if key.path == (name,) else item)
        for key, item in value.fields
    )


class FailureVocabularyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = list(iter_vectors())
        cls.registry_codes = {
            row["abstract_cd0"]["path"][0]
            for row in definitions().values()
            if row.get("item_class") == "lci-failure-code-identifier"
        }

    def test_runtime_vocabulary_is_exactly_the_84_frozen_registry_codes(self):
        self.assertEqual(len(self.registry_codes), 84)
        self.assertEqual(AUTHORIZED_LCI_FAILURE_CODES, self.registry_codes)

    def test_unauthorized_code_cannot_construct_or_escape_as_lci_failure(self):
        with self.assertRaises(FixtureIntegrityError) as caught:
            LCIFailure("invalid-input", "ImplementationInventedCode", "shape")
        self.assertNotIsInstance(caught.exception, LCIFailure)
        with self.assertRaises(FixtureAuthorityGap):
            failure("ImplementationInventedCode")

    def test_literal_failure_constructors_and_helpers_use_only_registry_codes(self):
        package_root = Path(__file__).resolve().parents[1] / "lci0"
        literal_sites: list[tuple[str, int, str]] = []
        argument_positions = {
            "LCIFailure": 1,
            "_migration_failure": 0,
            "_integer_zero": 1,
            "_require_kind": 2,
        }
        for source in sorted(package_root.glob("*.py")):
            tree = ast.parse(source.read_text(encoding="utf-8"), filename=str(source))
            for node in ast.walk(tree):
                if not isinstance(node, ast.Call) or not isinstance(node.func, ast.Name):
                    continue
                position = argument_positions.get(node.func.id)
                if position is None or len(node.args) <= position:
                    continue
                value = node.args[position]
                if isinstance(value, ast.Constant) and type(value.value) is str:
                    literal_sites.append((source.name, node.lineno, value.value))
        unauthorized = [site for site in literal_sites if site[2] not in self.registry_codes]
        self.assertGreater(len(literal_sites), 100)
        self.assertEqual(unauthorized, [])

    def test_all_official_runtime_and_expected_failures_are_authorized(self):
        actual_failures: list[LCIFailure] = []
        expected_failures: list[LCIFailure] = []
        for row in self.rows:
            actual = execute_row(row)
            expected = expected_outcome(row)
            if actual.failure is not None:
                actual_failures.append(actual.failure)
            if expected.failure is not None:
                expected_failures.append(expected.failure)
            if row["vector_id"] not in BLOCKED_VECTOR_IDS:
                self.assertEqual(comparison_signature(actual), comparison_signature(expected))
        self.assertEqual(len(self.rows), 215)
        self.assertEqual(len(actual_failures), 101)
        self.assertEqual(len({failure.code for failure in actual_failures}), 53)
        self.assertTrue(all(failure.code in self.registry_codes for failure in actual_failures))
        self.assertTrue(all(failure.code in self.registry_codes for failure in expected_failures))

    def test_runner_protocol_diagnostics_never_use_normative_failure_member(self):
        response = run_request({"input_canonical_hex": "00"})
        self.assertEqual(response["protocol_status"], "failure")
        self.assertIn("protocol_failure", response)
        self.assertNotIn("failure", response)

    def test_policy_c_is_a_closed_host_authority_gap_not_an_lci_failure(self):
        relation = cd0.record(
            (
                (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "target-relation-result"))),
                (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
                (cd0.identifier(FIXTURE_FIELD, ("status",)), cd0.identifier(FIXTURE, ("result-status", "success"))),
                (cd0.identifier(FIXTURE_FIELD, ("relation",)), cd0.identifier(LCI + ("relation",), ("exact-target",))),
            )
        )
        datum = cd0.record(
            (
                (cd0.identifier(FIXTURE_FIELD, ("policy",)), cd0.identifier(FIXTURE, ("policy-name", "policy-c"))),
                (cd0.identifier(FIXTURE_FIELD, ("target-relation",)), relation),
            )
        )
        response = run_request(
            request(
                "hostile:policy-c-fail-closed",
                "hostile-evaluate-policy-c",
                canonical_bytes(datum).hex(),
            )
        )
        self.assertEqual(
            set(response),
            {
                "protocol",
                "request_id",
                "operation",
                "fixture_profile_version",
                "implementation",
                "implementation_seed_commit",
                "implementation_seed_tree",
                "protocol_status",
                "input_reencoded_canonical_hex",
                "status",
                "authority_gap",
            },
        )
        self.assertEqual(response["protocol"], PROTOCOL)
        self.assertEqual(response["fixture_profile_version"], FIXTURE_PROFILE_VERSION)
        self.assertEqual(response["implementation_seed_commit"], PYTHON_SEED_COMMIT)
        self.assertEqual(response["implementation_seed_tree"], PYTHON_SEED_TREE)
        self.assertEqual(response["protocol_status"], "fixture-authority-gap")
        self.assertEqual(response["status"], "blocked")
        self.assertEqual(response["authority_gap"], "unsupported fixture policy")
        self.assertNotIn("failure", response)
        self.assertNotIn("semantic_status", response)
        self.assertNotIn("actual_canonical_cd0_hex", response)
        self.assertNotIn("vector_id", response)

    def test_non_policy_authority_gap_is_a_protocol_failure(self):
        row = self.rows[0]
        datum = cd0.decode_exact(
            bytes.fromhex(row["inputs"]["canonical_cd0_hex"]),
            CD0_BUDGET,
        )
        operation = cd0.identifier(FIXTURE, ("operation", "no-frozen-operation"))
        altered = _replace_field(datum, "operation", operation)
        response = run_request(
            request(
                "hostile:ordinary-authority-gap",
                "no-frozen-operation",
                canonical_bytes(altered).hex(),
            )
        )
        self.assertEqual(response["protocol_status"], "failure")
        self.assertEqual(response["protocol_failure"], {"code": "FixtureAuthorityGap", "path": []})
        self.assertNotIn("authority_gap", response)
        self.assertNotIn("failure", response)


if __name__ == "__main__":
    unittest.main()
