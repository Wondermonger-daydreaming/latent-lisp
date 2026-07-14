from __future__ import annotations

import unittest

import cd0

import python_adapter as subject
from lci0.model import LCIFailure
from lci0.vector import record_to_mapping


class FailureEncodingTests(unittest.TestCase):
    def test_preserves_normative_failure_context_instead_of_replacing_it(self):
        witness = cd0.string("input-derived-context")
        failure = LCIFailure(
            "target-mismatch",
            "ScopeNarrowingCoverageInsufficient",
            "target-relation",
            ("boundaries", "coverage-scope"),
            (("fixture-field:actual-coverage-scope", witness),),
        )

        encoded = subject._failure_datum(failure, "LCI0-E5-COVERAGE-INSUFFICIENT")
        context = record_to_mapping(subject.field_by_path(encoded, "context"))

        self.assertEqual(context, {"actual-coverage-scope": witness})
        self.assertNotIn("vector-id", context)

    def test_adds_vector_context_only_when_failure_has_none(self):
        failure = LCIFailure("invalid-input", "UnknownField", "validation")

        encoded = subject._failure_datum(failure, "LCI0-N001")
        context = record_to_mapping(subject.field_by_path(encoded, "context"))

        self.assertEqual(context["vector-id"].value, "LCI0-N001")


if __name__ == "__main__":
    unittest.main()
