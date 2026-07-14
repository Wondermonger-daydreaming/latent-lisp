from __future__ import annotations

from collections import Counter
import json
import unittest

from lci0.package import iter_vectors
from lci0.runner import run_request
from lci0.vector import comparison_signature, execute_row, expected_outcome


BLOCKED_VECTOR_IDS = {
    "LCI0-N012",  # vector pre-check conflicts with the frozen scope relation table
    "LCI0-E5-COVERAGE-INSUFFICIENT",  # expected context contains unbound tenant/a
    "LCI0-P024",  # expected revival invents nonidentity metadata absent from its input
    "LCI0-P029",  # explicit source-artifact v1/1 conflicts with expected lineage source v1/2
}


class SharedVectorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rows = list(iter_vectors())

    def test_vector_registry_is_closed_complete_and_mechanical(self):
        ids = [row["vector_id"] for row in self.rows]
        self.assertEqual(len(ids), 215)
        self.assertEqual(len(set(ids)), 215)
        required = {*(f"LCI0-P{i:03d}" for i in range(1, 31)), *(f"LCI0-N{i:03d}" for i in range(1, 33))}
        self.assertFalse(required - set(ids))
        operations = Counter(row["operation"] for row in self.rows)
        self.assertEqual(len(operations), 52)
        self.assertEqual(sum(operations.values()), 215)

    def test_211_unaffected_expected_semantic_results(self):
        checked = 0
        for row in self.rows:
            if row["vector_id"] in BLOCKED_VECTOR_IDS:
                continue
            with self.subTest(vector_id=row["vector_id"], operation=row["operation"]):
                actual = execute_row(row)
                expected = expected_outcome(row)
                self.assertEqual(comparison_signature(actual), comparison_signature(expected))
                checked += 1
        self.assertEqual(checked, 211)
        self.assertEqual(BLOCKED_VECTOR_IDS, {row["vector_id"] for row in self.rows} & BLOCKED_VECTOR_IDS)

    def test_production_runner_executes_all_inputs_without_expected_access(self):
        for row in self.rows:
            with self.subTest(vector_id=row["vector_id"]):
                response = run_request({"input_canonical_hex": row["inputs"]["canonical_cd0_hex"]})
                json.dumps(response, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
                actual = execute_row(row)
                self.assertEqual(response["vector_id"], row["vector_id"])
                self.assertEqual(response["operation"], row["operation"])
                self.assertEqual(response["status"], actual.status)
                if actual.failure is not None:
                    self.assertEqual(
                        (response["failure"]["category"], response["failure"]["code"], response["failure"]["stage"], tuple(response["failure"]["path"])),
                        actual.failure.comparison_key,
                    )

    def test_expected_mutation_cannot_change_execution(self):
        row = dict(self.rows[0])
        baseline = comparison_signature(execute_row(row))
        row["expected"] = object()
        self.assertEqual(comparison_signature(execute_row(row)), baseline)


if __name__ == "__main__":
    unittest.main()
