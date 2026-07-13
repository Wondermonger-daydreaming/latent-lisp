"""Tests for the generated-corpus differential coordinator."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


REPO_ROOT = Path(__file__).resolve().parents[3]
RUNNER_PATH = REPO_ROOT / "canonical-datum" / "release" / "run_generated_differential.py"
SPEC = importlib.util.spec_from_file_location("cd0_release_differential", RUNNER_PATH)
assert SPEC is not None and SPEC.loader is not None
runner = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = runner
SPEC.loader.exec_module(runner)


class GeneratedCorpusFixture(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.temporary = tempfile.TemporaryDirectory(prefix="cd0-release-runner-test-")
        cls.root = Path(cls.temporary.name)
        cls.corpus = cls.root / "small-corpus"
        command = [
            sys.executable,
            str(REPO_ROOT / "canonical-datum" / "generator" / "generate_corpus.py"),
            "--output-dir",
            str(cls.corpus),
            "--seed",
            "20260713",
            "--positive-count",
            "64",
            "--negative-count",
            "512",
            "--mutation-sample-count",
            "10",
            "--truncation-max-document-octets",
            "6",
            "--allow-small",
            "--allow-dirty-source",
        ]
        completed = subprocess.run(
            command,
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
            check=False,
        )
        if completed.returncode != 0:
            raise RuntimeError(
                f"small corpus generation failed: {completed.stdout}\n{completed.stderr}"
            )

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temporary.cleanup()

    def test_manifest_verification_requires_explicit_test_mode(self) -> None:
        with self.assertRaisesRegex(runner.ReleaseDifferentialError, "test-mode"):
            runner.verify_manifest(self.corpus, allow_small=False)
        verified = runner.verify_manifest(self.corpus, allow_small=True)
        self.assertFalse(verified["qualifies_for_release"])
        self.assertEqual(64, verified["counts"]["positive"])
        self.assertEqual(512, verified["counts"]["negative"])
        self.assertEqual(14, verified["counts"]["resource_boundary_scenarios"])

    def test_manifest_verification_detects_artifact_tamper(self) -> None:
        tampered = self.root / "tampered-corpus"
        shutil.copytree(self.corpus, tampered)
        positive = tampered / "cd0-generated-positive.jsonl"
        with positive.open("ab") as stream:
            stream.write(b"\n")
        with self.assertRaisesRegex(runner.ReleaseDifferentialError, "hash/size"):
            runner.verify_manifest(tampered, allow_small=True)

    def test_manifest_verification_detects_source_hash_tamper(self) -> None:
        tampered = self.root / "source-tampered-corpus"
        shutil.copytree(self.corpus, tampered)
        path = tampered / "cd0-corpus-manifest.json"
        manifest = json.loads(path.read_text(encoding="ascii"))
        source_path = "canonical-datum/generator/generate_corpus.py"
        manifest["source_input_sha256"]["before_generation"][source_path] = "0" * 64
        manifest["source_input_sha256"]["after_generation"][source_path] = "0" * 64
        path.write_text(json.dumps(manifest, sort_keys=True) + "\n", encoding="ascii")
        with self.assertRaisesRegex(runner.ReleaseDifferentialError, "checked-out source"):
            runner.verify_manifest(tampered, allow_small=True)

    @unittest.skipUnless(shutil.which("sbcl"), "SBCL is required for the process differential")
    def test_small_generated_corpus_through_both_process_adapters(self) -> None:
        artifacts = self.root / "differential-artifacts"
        summary = runner.run(
            self.corpus,
            allow_small=True,
            batch_size=256,
            timeout_seconds=120,
            artifacts_dir=artifacts,
        )
        self.assertEqual("PASS", summary["status"])
        self.assertEqual(0, summary["issues"]["count"])
        counts = summary["counts"]
        manifest_counts = summary["corpus"]["counts"]
        self.assertEqual(manifest_counts["positive"], counts["positive_rows"])
        self.assertEqual(
            manifest_counts["classified_negative"], counts["classified_negative_rows"]
        )
        self.assertEqual(
            manifest_counts["unclassified_mutation_candidates"],
            counts["unclassified_mutation_candidates"],
        )
        self.assertEqual(manifest_counts["positive"] * 2, counts["equality_judgments"])
        self.assertEqual(3, counts["common_lisp_host_not_applicable"])
        self.assertEqual(
            manifest_counts["negative_retry_verified"], counts["retry_budget_checks"]
        )
        self.assertEqual(
            counts["unclassified_mutation_candidates"],
            sum(summary["unclassified_mutation_outcomes"].values()),
        )
        self.assertEqual(
            0,
            summary["unclassified_mutation_outcomes"].get(
                "minimization_required_disagreements", 0
            ),
        )
        self.assertGreater(summary["runner"]["batch_count"], 1)
        self.assertEqual(14, len(summary["resource_boundary_dispositions"]))
        self.assertTrue(
            all(
                not row["metadata_disposition_alone_counts_as_pass"]
                for row in summary["resource_boundary_dispositions"]
            )
        )
        self.assertTrue((artifacts / "summary.json").is_file())

        for batch in summary["batch_artifact_ledger"]:
            stem = f"batch-{batch['batch']:05d}"
            request_path = artifacts / f"{stem}-requests.jsonl"
            self.assertEqual(batch["request_sha256"], _sha256(request_path))
            for label, record in batch["responses"].items():
                response_path = artifacts / f"{stem}-{label}-responses.jsonl"
                self.assertEqual(record["response_sha256"], _sha256(response_path))
                self.assertEqual(batch["request_count"], record["response_count"])

    def test_warranted_provisional_fields_do_not_promote_ambiguities(self) -> None:
        self.assertEqual(
            ("category", "code"),
            runner.warranted_fields({"status": "provisional-blocked-stage"}),
        )
        self.assertEqual(
            ("category", "stage"),
            runner.warranted_fields({"status": "provisional-blocked-code"}),
        )
        self.assertEqual(
            ("category", "code", "stage"), runner.warranted_fields({})
        )

    def test_v3_provenance_and_supplemental_counts_are_exact(self) -> None:
        verified = runner.verify_manifest(self.corpus, allow_small=True)
        manifest = verified["manifest"]
        self.assertEqual("cd0-corpus-generator/3", manifest["generator_version"])
        source = manifest["source_input_sha256"]
        self.assertEqual(source["before_generation"], source["after_generation"])
        self.assertEqual(set(runner.SOURCE_INPUT_PATHS), set(source["before_generation"]))
        self.assertEqual(
            manifest["counts"]["classified_adversarial_total"],
            manifest["counts"]["classified_negative"],
        )
        self.assertEqual(
            manifest["counts"]["classified_negative"],
            sum(manifest["counts"]["classified_negative_by_status"].values()),
        )
        self.assertEqual(
            manifest["counts"]["negative_derivations"],
            sum(manifest["counts"]["negative_by_minimization_kind"].values()),
        )
        self.assertEqual(
            manifest["counts"]["demonstrated_primary_minimal_negative"],
            verified["demonstrated_primary_minimal"],
        )
        self.assertEqual(
            manifest["counts"]["classified_negative"],
            manifest["counts"]["authored_and_host_coverage_negative"]
            + manifest["counts"]["demonstrated_primary_minimal_negative"],
        )
        self.assertEqual(
            20_000,
            manifest["release_thresholds"]["demonstrated_primary_minimal_minimum"],
        )
        self.assertEqual(20_308, manifest["release_thresholds"]["preferred_negative_count"])
        host_record = manifest["artifacts"]["cd0-host-property-scenarios.json"]
        self.assertEqual(9 + 14, host_record["rows"])


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


if __name__ == "__main__":
    unittest.main()
