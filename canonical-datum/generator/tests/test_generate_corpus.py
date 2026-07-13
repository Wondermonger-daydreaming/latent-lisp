from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

from jsonschema import Draft202012Validator


ROOT = Path(__file__).resolve().parents[3]
SCRIPT = ROOT / "canonical-datum" / "generator" / "generate_corpus.py"
SCHEMA = json.loads((ROOT / "canonical-datum" / "schema" / "cd0-fixtures.schema.json").read_text(encoding="utf-8"))
EXPECTED_SPEC_SHA256 = "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc"
ASSIGNED_TAGS = {"00", "01", "02", "10", "11", "20", "21", "22", "30", "31"}
REQUIRED_MUTATIONS = {
    "delete-octet",
    "delete-suffix",
    "append-octets",
    "replace-root-type-tag",
    "make-version-uvar-overlong",
    "change-declared-length-or-count",
    "corrupt-utf8-continuation-as-lead",
    "corrupt-utf8-continuation-byte",
    "swap-record-fields",
    "duplicate-record-field",
    "replace-rational-numerator-zero",
}
REQUIRED_HOST_SCENARIOS = {
    "cd0-host-property-cycle",
    "cd0-host-property-improper-list",
    "cd0-host-property-shared-acyclic",
    "cd0-host-property-mutable-aliases",
    "cd0-host-property-symbols-bool",
    "cd0-host-property-namespaces",
    "cd0-host-property-live-privileged",
    "cd0-host-property-inert-records",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def jsonl(path: Path) -> list[dict]:
    return [json.loads(line) for line in path.read_text(encoding="ascii").splitlines()]


class GeneratedCorpusTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temporary = tempfile.TemporaryDirectory(prefix="cd0-generator-test-")
        cls.output = Path(cls.temporary.name) / "corpus"
        cls.command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(ROOT),
            "--output-dir",
            str(cls.output),
            "--seed",
            "0x1234abcd",
            "--positive-count",
            "384",
            "--negative-count",
            "640",
            "--mutation-sample-count",
            "16",
            "--truncation-max-document-octets",
            "10",
            "--allow-small",
        ]
        first_environment = dict(os.environ, PYTHONHASHSEED="1")
        first = subprocess.run(cls.command, cwd=ROOT, env=first_environment, capture_output=True, text=True)
        if first.returncode:
            raise AssertionError(f"first generator run failed:\nstdout={first.stdout}\nstderr={first.stderr}")
        cls.first_bytes = {
            path.name: path.read_bytes()
            for path in sorted(cls.output.iterdir())
            if path.is_file()
        }
        shutil.rmtree(cls.output)

        second_environment = dict(os.environ, PYTHONHASHSEED="777")
        second = subprocess.run(cls.command, cwd=ROOT, env=second_environment, capture_output=True, text=True)
        if second.returncode:
            raise AssertionError(f"second generator run failed:\nstdout={second.stdout}\nstderr={second.stderr}")

        cls.manifest = json.loads((cls.output / "cd0-corpus-manifest.json").read_text(encoding="ascii"))
        cls.positives = jsonl(cls.output / "cd0-generated-positive.jsonl")
        cls.negatives = jsonl(cls.output / "cd0-generated-negative.jsonl")
        cls.derivations = jsonl(cls.output / "cd0-generated-negative-derivations.jsonl")
        cls.mutations = jsonl(cls.output / "cd0-mutation-candidates.jsonl")
        cls.host_scenarios = json.loads((cls.output / "cd0-host-property-scenarios.json").read_text(encoding="ascii"))

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temporary.cleanup()

    def test_byte_for_byte_determinism_across_hash_seeds(self) -> None:
        second_bytes = {
            path.name: path.read_bytes()
            for path in sorted(self.output.iterdir())
            if path.is_file()
        }
        self.assertEqual(second_bytes, self.first_bytes)

    def test_spec_and_source_revision_are_recorded(self) -> None:
        self.assertEqual(self.manifest["normative_specification"]["sha256"], EXPECTED_SPEC_SHA256)
        observed = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, capture_output=True, text=True
        ).stdout.strip()
        self.assertEqual(self.manifest["source_revision"], observed)
        self.assertIn("--positive-count 384", self.manifest["logical_command"])
        self.assertIn("--allow-small", self.manifest["logical_command"])

    def test_small_corpus_counts_and_nonrelease_marker(self) -> None:
        self.assertEqual(len(self.positives), 384)
        self.assertEqual(len(self.negatives), 640)
        self.assertEqual(len(self.derivations), 640)
        self.assertEqual(self.manifest["counts"]["positive"], 384)
        self.assertEqual(self.manifest["counts"]["classified_negative"], 640)
        self.assertFalse(self.manifest["release_thresholds"]["qualifies"])
        self.assertTrue(self.manifest["release_thresholds"]["allow_small_test_mode"])

    def test_shared_positive_and_negative_fixture_schema(self) -> None:
        validator = Draft202012Validator(SCHEMA)
        for row in self.positives + self.negatives:
            errors = sorted(validator.iter_errors(row), key=lambda error: list(error.path))
            self.assertEqual(errors, [], f"{row['id']}: {[error.message for error in errors]}")

    def test_unique_ids_documents_and_classified_inputs(self) -> None:
        self.assertEqual(len({row["id"] for row in self.positives}), len(self.positives))
        self.assertEqual(len({row["canonical_hex"] for row in self.positives}), len(self.positives))
        self.assertEqual(len({row["equality_class"] for row in self.positives}), len(self.positives))
        self.assertEqual(len({row["id"] for row in self.negatives}), len(self.negatives))
        signatures = {
            (row["input_kind"], row.get("input_hex"), json.dumps(row.get("host_input"), sort_keys=True), json.dumps(row["budget"], sort_keys=True))
            for row in self.negatives
        }
        self.assertEqual(len(signatures), len(self.negatives))

    def test_every_wire_tag_is_covered(self) -> None:
        self.assertEqual(set(self.manifest["positive_root_tag_counts"]), ASSIGNED_TAGS)
        self.assertTrue(all(count > 0 for count in self.manifest["positive_root_tag_counts"].values()))
        negative_tags = {
            row["input_hex"][10:12]
            for row in self.negatives
            if row["id"].endswith(tuple(f"tag-{tag:02x}" for tag in range(256)))
        }
        self.assertEqual(negative_tags, {f"{tag:02x}" for tag in range(256)} - ASSIGNED_TAGS)

    def test_mutations_are_unclassified_and_cover_required_operations(self) -> None:
        self.assertGreater(len(self.mutations), 0)
        for row in self.mutations:
            self.assertNotIn("expected_failure", row)
            self.assertEqual(row["classification_status"], "unclassified-may-have-multiple-defects")
        operations = {row["operation"] for row in self.mutations}
        self.assertTrue(REQUIRED_MUTATIONS <= operations, REQUIRED_MUTATIONS - operations)

    def test_every_hand_truncation_point_is_present(self) -> None:
        hand = jsonl(ROOT / "canonical-datum" / "vectors" / "cd0-positive.jsonl")
        expected = {
            (row["id"], point, row["canonical_hex"][: 2 * point])
            for row in hand
            for point in range(len(bytes.fromhex(row["canonical_hex"])))
        }
        observed = {
            (row["source_positive_id"], row["parameter"], row["input_hex"])
            for row in self.mutations
            if row["source_scope"] == "hand-positive" and row["operation"] == "truncate-at"
        }
        self.assertEqual(observed, expected)
        self.assertEqual(self.manifest["truncation_configuration"]["hand_truncation_candidates"], len(expected))

    def test_generated_truncation_size_is_explicit(self) -> None:
        configuration = self.manifest["truncation_configuration"]
        self.assertEqual(configuration["maximum_generated_document_octets"], 10)
        expected = {
            (row["id"], point)
            for row in self.positives
            if len(bytes.fromhex(row["canonical_hex"])) <= 10
            for point in range(len(bytes.fromhex(row["canonical_hex"])))
        }
        observed = {
            (row["source_positive_id"], row["parameter"])
            for row in self.mutations
            if row["source_scope"] == "generated-configured-size" and row["operation"] == "truncate-at"
        }
        self.assertEqual(observed, expected)

    def test_host_property_metadata_is_explicit(self) -> None:
        ids = {row["id"] for row in self.host_scenarios["scenarios"]}
        self.assertTrue(REQUIRED_HOST_SCENARIOS <= ids)
        inert = next(row for row in self.host_scenarios["scenarios"] if row["id"] == "cd0-host-property-inert-records")
        self.assertEqual(set(inert["shapes"]), {"capability", "warrant", "claim", "certificate", "receipt"})
        self.assertEqual(len(inert["positive_vector_refs"]), 5)

    def test_coverage_table_has_evidence_for_every_obligation(self) -> None:
        self.assertEqual(len(self.manifest["coverage"]), 33)
        for name, entry in self.manifest["coverage"].items():
            self.assertGreater(entry["count"], 0, name)
            self.assertTrue(entry["evidence_ids"], name)

    def test_artifact_and_corpus_hashes(self) -> None:
        artifacts = self.manifest["artifacts"]
        for name, record in artifacts.items():
            self.assertEqual(record["sha256"], sha256(self.output / name), name)
        material = b"".join(
            name.encode() + b"\0" + artifacts[name]["sha256"].encode() + b"\n"
            for name in sorted(artifacts)
        )
        self.assertEqual(hashlib.sha256(material).hexdigest(), self.manifest["corpus_sha256"])

    def test_negative_derivations_are_complete_and_do_not_claim_oracle_authority(self) -> None:
        self.assertEqual({row["id"] for row in self.negatives}, {row["id"] for row in self.derivations})
        boundary = self.manifest["representation_and_oracle_boundary"]
        self.assertIn("consistency aid only", boundary["authority"])
        self.assertIn("no permanent triple", boundary["mutation_candidates"])
        self.assertIn("A1-A9", self.manifest["divergence_boundary"])

    def test_release_floors_cannot_be_bypassed_accidentally(self) -> None:
        refused = Path(self.temporary.name) / "refused"
        command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(ROOT),
            "--output-dir",
            str(refused),
            "--positive-count",
            "9999",
            "--negative-count",
            "20000",
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("at least 10000", completed.stderr)
        self.assertFalse(refused.exists())

    def test_spec_digest_mismatch_refuses_before_output(self) -> None:
        false_root = Path(self.temporary.name) / "false-root"
        false_spec = false_root / "mneme" / "spec" / "CANONICAL-DATUM-SPEC.md"
        false_spec.parent.mkdir(parents=True)
        false_spec.write_text("not the pinned specification\n", encoding="utf-8")
        refused = Path(self.temporary.name) / "digest-refused"
        command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(false_root),
            "--output-dir",
            str(refused),
            "--allow-small",
            "--positive-count",
            "384",
            "--negative-count",
            "640",
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("digest mismatch", completed.stderr)
        self.assertIn(EXPECTED_SPEC_SHA256, completed.stderr)
        self.assertFalse(refused.exists())


if __name__ == "__main__":
    unittest.main()
