"""Tests for the sealed LCI/0 package integrity helper."""

from pathlib import Path
import tempfile
import unittest

import fixture_package


class FixturePackageTests(unittest.TestCase):
    def test_fixture_and_pass_archives_verify(self) -> None:
        fixture = fixture_package.verify_fixture_archive()
        receipt = fixture_package.verify_pass_archive()
        self.assertEqual(fixture["sealed_members"], 21)
        self.assertEqual(receipt["sealed_members"], 41)

    def test_exact_normative_census(self) -> None:
        self.assertEqual(
            fixture_package.census(),
            {
                "registry_definitions": 675,
                "vectors": 215,
                "official_documents": 1105,
                "relation_table_documents": 458,
                "nested_e1_documents": 30,
                "supplementary_documents": 488,
                "total_documents": 1593,
            },
        )

    def test_archive_member_paths_fail_closed(self) -> None:
        for name in ("/absolute", "../escape", "root/../../escape"):
            with self.subTest(name=name), self.assertRaises(fixture_package.VerificationError):
                fixture_package._safe_member(name)

    def test_materialize_refuses_existing_destination(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            destination = Path(directory) / "already-present"
            destination.mkdir()
            with self.assertRaises(fixture_package.VerificationError):
                fixture_package.materialize(destination)


if __name__ == "__main__":
    unittest.main()
