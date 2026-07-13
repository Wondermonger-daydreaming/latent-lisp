"""Self-tests for the bounded CD/0 qualification coordinator."""

from __future__ import annotations

import json
from pathlib import Path
import sys
import unittest


QUALIFICATION_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(QUALIFICATION_DIR))

import run_qualification as qualification  # noqa: E402


class GeneratorTests(unittest.TestCase):
    def test_ephemeral_value_generation_is_deterministic(self) -> None:
        first = qualification.generate_values(64, seed=12345)
        second = qualification.generate_values(64, seed=12345)
        different = qualification.generate_values(64, seed=12346)
        self.assertEqual(first, second)
        self.assertNotEqual(first, different)

    def test_every_root_family_has_a_fixed_witness(self) -> None:
        roots = {value["t"] for value in qualification.generate_values(9)}
        self.assertEqual(
            roots,
            {"unit", "bool", "int", "rat", "string", "bytes", "id", "seq", "record"},
        )

    def test_generated_values_are_json_roundtrip_stable(self) -> None:
        values = qualification.generate_values(80)
        encoded = qualification.canonical_json(values)
        self.assertEqual(json.loads(encoded), values)

    def test_equivalent_record_variant_changes_source_order_only(self) -> None:
        left = {
            "t": "record",
            "fields": [
                {
                    "key": qualification.identifier_ast((), ("a",)),
                    "value": {"t": "unit"},
                },
                {
                    "key": qualification.identifier_ast((), ("b",)),
                    "value": {"t": "bool", "v": True},
                },
            ],
        }
        right = qualification.equivalent_ast(left)
        self.assertEqual(left["fields"], list(reversed(right["fields"])))
        self.assertIsNot(left["fields"], right["fields"])


class ManifestTests(unittest.TestCase):
    def setUp(self) -> None:
        self.budget = qualification.default_budget()
        self.requests, self.metadata = qualification.build_property_requests(48, self.budget)

    def test_request_ids_are_unique_and_complete(self) -> None:
        ids = [request["request_id"] for request in self.requests]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertEqual(set(ids), set(self.metadata))
        self.assertEqual(len(ids), 2 * 48 + 21)

    def test_every_request_has_a_resolved_immutable_budget_shape(self) -> None:
        expected_fields = set(self.budget)
        for request in self.requests:
            self.assertEqual(set(request["budget"]), expected_fields)
            self.assertTrue(all(type(value) is int and value >= 0 for value in request["budget"].values()))

    def test_provisional_failures_do_not_warrant_stage(self) -> None:
        provisional = [
            metadata
            for metadata in self.metadata.values()
            if metadata.get("kind") == "failure" and metadata.get("provisional")
        ]
        self.assertEqual(len(provisional), 3)
        self.assertTrue(all(tuple(item["warranted_fields"]) == ("category", "code") for item in provisional))

    def test_normative_failures_warrant_all_three_fields(self) -> None:
        normative = [
            metadata
            for metadata in self.metadata.values()
            if metadata.get("kind") == "failure" and not metadata.get("provisional")
        ]
        self.assertEqual(len(normative), 11)
        self.assertTrue(
            all(
                tuple(item["warranted_fields"]) == ("category", "code", "stage")
                for item in normative
            )
        )

    def test_hostile_rows_are_classified_and_single_purpose(self) -> None:
        failures = [item for item in self.metadata.values() if item.get("kind") == "failure"]
        self.assertEqual(
            {item["classification"] for item in failures},
            {"mutation-derived-single-defect", "resource-boundary"},
        )


if __name__ == "__main__":
    unittest.main()
