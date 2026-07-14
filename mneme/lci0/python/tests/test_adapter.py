from __future__ import annotations

import copy
import unittest
import unicodedata

import cd0

from lci0.adapter import FixtureAdapterFailure, from_package_json, schema_census
from lci0.core import CD0_BUDGET, canonical_bytes


class FixtureAdapterTests(unittest.TestCase):
    def adapt(self, value):
        return from_package_json(value, CD0_BUDGET)

    def test_complete_leaf_schema_census(self):
        value = {
            "t": "seq",
            "items": [
                {"t": "unit"},
                {"t": "bool", "v": True},
                {"t": "int", "v": "1"},
                {"t": "rat", "num": "-2", "den": "3"},
                {"t": "bytes", "hex": "00ff"},
                {"t": "string", "text": "é", "utf8_hex": "c3a9"},
                {"t": "id", "namespace": ["Ns"], "path": ["Part", "x"]},
                {
                    "t": "record",
                    "fields": [
                        {
                            "key": {"t": "id", "namespace": [], "path": ["k"]},
                            "value": {"t": "seq", "items": []},
                        }
                    ],
                },
            ],
        }
        census = schema_census(value)
        for shape in ("unit", "bool", "int", "rat", "bytes", "string", "id", "seq", "record", "field-wrapper"):
            self.assertGreater(census[shape], 0)
        result = self.adapt(value)
        self.assertIs(type(result.items[1]), cd0.Boolean)
        self.assertIs(type(result.items[2]), cd0.Integer)
        self.assertEqual((result.items[3].numerator, result.items[3].denominator), (-2, 3))

    def test_redundant_string_material_is_verified(self):
        with self.assertRaisesRegex(FixtureAdapterFailure, "RedundantStringFieldMismatch"):
            self.adapt({"t": "string", "text": "é", "utf8_hex": "65"})

    def test_boolean_never_collapses_to_integer(self):
        with self.assertRaisesRegex(FixtureAdapterFailure, "BooleanIntegerCollapse"):
            self.adapt({"t": "bool", "v": 1})

    def test_rational_must_be_exactly_normalized(self):
        for value in (
            {"t": "rat", "num": "2", "den": "4"},
            {"t": "rat", "num": "0", "den": "3"},
            {"t": "rat", "num": "1", "den": "1"},
        ):
            with self.subTest(value=value), self.assertRaisesRegex(FixtureAdapterFailure, "NoncanonicalFixtureRational"):
                self.adapt(value)

    def test_identifier_segmentation_case_and_unicode_are_exact(self):
        nfc = "é"
        nfd = unicodedata.normalize("NFD", nfc)
        left = self.adapt({"t": "id", "namespace": ["Ns"], "path": [nfc, "X"]})
        right = self.adapt({"t": "id", "namespace": ["ns"], "path": [nfd, "X"]})
        self.assertNotEqual(left, right)
        self.assertEqual(left.namespace, ("Ns",))
        self.assertEqual(left.path, (nfc, "X"))

    def test_unknown_shape_and_unknown_field_fail_closed(self):
        hostile = (
            {"t": "future"},
            {"t": "unit", "future": 1},
            {"t": "record", "fields": [{"key": {"t": "string", "text": "k", "utf8_hex": "6b"}, "value": {"t": "unit"}}]},
        )
        for value in hostile:
            with self.subTest(value=value), self.assertRaises(FixtureAdapterFailure):
                self.adapt(value)

    def test_source_json_mutation_cannot_change_imported_datum(self):
        source = {"t": "string", "text": "alpha", "utf8_hex": "616c706861"}
        imported = self.adapt(source)
        before = canonical_bytes(imported)
        source["text"] = "omega"
        source["utf8_hex"] = "6f6d656761"
        self.assertEqual(canonical_bytes(imported), before)


if __name__ == "__main__":
    unittest.main()
