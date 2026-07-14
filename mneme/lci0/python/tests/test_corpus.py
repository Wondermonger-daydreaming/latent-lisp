from __future__ import annotations

import unittest

from lci0.adapter import from_package_json
from lci0.core import CD0_BUDGET, field_by_path, scope_relation, temporal_relation
from lci0.corpus import verify_corpus
from lci0.model import LCIFailure
from lci0.package import registry
from lci0.vector import id_name


class FixtureCorpusTests(unittest.TestCase):
    def test_all_official_and_supplementary_documents(self):
        report = verify_corpus()
        self.assertEqual(report.official_documents, 1105)
        self.assertEqual(report.relation_table_documents, 458)
        self.assertEqual(report.nested_e1_documents, 30)
        self.assertEqual(report.supplementary_documents, 488)
        self.assertEqual(report.total_documents, 1593)
        shape_counts = dict(report.schema_shapes)
        self.assertEqual(set(shape_counts), {"unit", "bool", "int", "rat", "bytes", "string", "id", "seq", "record", "field-wrapper"})

    def test_all_458_relation_table_entries_execute(self):
        failure_relations = {
            "ScopeIncompatible": "incompatible",
            "ScopeRelationUnknown": "unknown",
            "UnsupportedTemporalModel": "incompatible",
            "AdmissibilityUndetermined": "unknown",
        }
        cases = (
            ("scope_relation_table_0", "left-scope", "right-scope", scope_relation, 169),
            ("temporal_relation_table_0", "left-subject-time", "right-subject-time", temporal_relation, 289),
        )
        tables = registry()["relation_and_mapping_tables"]
        for table_name, left_name, right_name, function, expected_count in cases:
            entries = tables[table_name]["entries"]
            self.assertEqual(len(entries), expected_count)
            for index, row in enumerate(entries):
                with self.subTest(table=table_name, index=index):
                    document = from_package_json(row["abstract_cd0"], CD0_BUDGET)
                    expected = id_name(field_by_path(document, "relation")).split("/")[-1]
                    try:
                        actual = function(field_by_path(document, left_name), field_by_path(document, right_name))
                    except LCIFailure as failure:
                        actual = failure_relations[failure.code]
                    self.assertEqual(actual, expected)


if __name__ == "__main__":
    unittest.main()
