from __future__ import annotations

import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

from jsonschema import Draft202012Validator


ROOT = Path(__file__).resolve().parents[3]
SCRIPT = ROOT / "canonical-datum" / "generator" / "generate_corpus.py"
SCHEMA = json.loads((ROOT / "canonical-datum" / "schema" / "cd0-fixtures.schema.json").read_text(encoding="utf-8"))
EXPECTED_NORMATIVE_SHA256 = {
    "base-specification": "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc",
    "post-implementation-ruling": "1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc",
    "errata-0.1": "5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271",
}
ASSIGNED_TAGS = {"00", "01", "02", "10", "11", "20", "21", "22", "30", "31"}
RESOURCE_LIMITS = {
    "max_input_octets", "max_output_octets", "max_varint_octets",
    "max_integer_bits", "max_depth", "max_nodes", "max_sequence_items",
    "max_record_fields", "max_identifier_segments", "max_segment_octets",
    "max_single_string_octets", "max_single_bytes_octets",
    "max_aggregate_payload_octets", "max_total_record_key_octets",
}
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

MODULE_SPEC = importlib.util.spec_from_file_location("cd0_generate_corpus_test_module", SCRIPT)
if MODULE_SPEC is None or MODULE_SPEC.loader is None:
    raise RuntimeError("could not load corpus generator module")
GENERATOR = importlib.util.module_from_spec(MODULE_SPEC)
MODULE_SPEC.loader.exec_module(GENERATOR)


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
            "--allow-dirty-source",
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
        self.assertEqual(list(self.output.parent.glob(f".{self.output.name}.staging-*")), [])

    def test_spec_and_source_revision_are_recorded(self) -> None:
        self.assertEqual(
            {
                role: record["sha256"]
                for role, record in self.manifest["normative_specifications"].items()
            },
            EXPECTED_NORMATIVE_SHA256,
        )
        infrastructure = self.manifest["fixture_infrastructure"]
        self.assertEqual(infrastructure["schema"]["revision"], "0.1")
        self.assertEqual(
            infrastructure["promoted_errata_vectors"]["cases_by_adjudication"],
            GENERATOR.ERRATA_CASE_COUNTS,
        )
        self.assertEqual(infrastructure["promoted_errata_vectors"]["classified_cases"], 37)
        observed = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, capture_output=True, text=True
        ).stdout.strip()
        self.assertEqual(self.manifest["source_revision"], observed)
        self.assertIn("--positive-count 384", self.manifest["logical_command"])
        self.assertIn("--allow-small", self.manifest["logical_command"])
        self.assertEqual(self.manifest["invocation_argv"], self.command)
        self.assertEqual(self.manifest["invocation_cwd"], str(ROOT))
        self.assertEqual(self.manifest["source_input_sha256"]["before_generation"], self.manifest["source_input_sha256"]["after_generation"])
        for relative, digest in self.manifest["source_input_sha256"]["before_generation"].items():
            self.assertEqual(sha256(ROOT / relative), digest, relative)
        self.assertTrue(self.manifest["source_worktree"]["dirty_override_requested"])

    def test_small_corpus_counts_and_nonrelease_marker(self) -> None:
        self.assertEqual(len(self.positives), 384)
        self.assertEqual(len(self.negatives), 640)
        self.assertEqual(len(self.derivations), 640)
        self.assertEqual(self.manifest["counts"]["positive"], 384)
        self.assertEqual(self.manifest["counts"]["classified_negative"], 640)
        self.assertEqual(self.manifest["counts"]["classified_adversarial_total"], 640)
        self.assertEqual(self.manifest["counts"]["authored_and_host_coverage_negative"], 308)
        self.assertEqual(self.manifest["counts"]["demonstrated_primary_minimal_negative"], 332)
        self.assertFalse(self.manifest["release_thresholds"]["qualifies"])
        self.assertTrue(self.manifest["release_thresholds"]["allow_small_test_mode"])
        self.assertEqual(self.manifest["release_thresholds"]["adversarial_total_minimum"], 20_000)
        self.assertEqual(self.manifest["release_thresholds"]["demonstrated_primary_minimal_minimum"], 20_000)
        self.assertEqual(self.manifest["release_thresholds"]["preferred_negative_count"], 20_308)
        self.assertEqual(self.manifest["release_thresholds"]["observed_demonstrated_primary_minimal"], 332)
        self.assertIn("complete normative failure triple", self.manifest["release_thresholds"]["count_scope"])
        self.assertEqual(self.manifest["generator_version"], "cd0-corpus-generator/4")
        self.assertEqual(self.manifest["schema"], "cd0-generated-corpus-manifest/v4")

    def test_identifier_stage_errata_note_is_scoped_to_identifier_rows(self) -> None:
        note = "Errata 0.1 fixes the identifier resource stage"
        tagged = {
            row["id"]
            for row in self.negatives
            if note in row.get("notes", [])
        }
        self.assertEqual(
            tagged,
            {
                "cd0-neg-generated-00000292-resource-identifier-segments",
                "cd0-neg-generated-00000300-resource-identifier-declaration-only",
            },
        )

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
            self.assertNotEqual(row["source_hex"], row["input_hex"], row["id"])
        operations = {row["operation"] for row in self.mutations}
        self.assertTrue(REQUIRED_MUTATIONS <= operations, REQUIRED_MUTATIONS - operations)

    def test_every_sampled_delete_position_and_suffix_provenance_is_preserved(self) -> None:
        positive_by_id = {row["id"]: row for row in self.positives}
        sampled_ids = {
            row["source_positive_id"]
            for row in self.mutations
            if row["source_scope"] == "generated-sample" and row["operation"] == "delete-octet"
        }
        self.assertEqual(len(sampled_ids), 16)
        for source_id in sampled_ids:
            size = len(bytes.fromhex(positive_by_id[source_id]["canonical_hex"]))
            deletion_positions = sorted(
                row["parameter"]
                for row in self.mutations
                if row["source_positive_id"] == source_id and row["operation"] == "delete-octet"
            )
            suffix_points = sorted(
                row["parameter"]
                for row in self.mutations
                if row["source_positive_id"] == source_id and row["operation"] == "delete-suffix"
            )
            self.assertEqual(deletion_positions, list(range(size)), source_id)
            self.assertEqual(suffix_points, list(range(size)), source_id)

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
        all_expected = [
            (row["id"], point)
            for row in self.positives
            if len(bytes.fromhex(row["canonical_hex"])) <= 10
            for point in range(len(bytes.fromhex(row["canonical_hex"])))
        ]
        displaced = self.manifest["truncation_configuration"][
            "generated_truncation_candidates_displaced_by_promoted_hand_vectors"
        ]
        expected = set(all_expected[:-displaced] if displaced else all_expected)
        observed = {
            (row["source_positive_id"], row["parameter"])
            for row in self.mutations
            if row["source_scope"] == "generated-configured-size" and row["operation"] == "truncate-at"
        }
        self.assertEqual(observed, expected)
        self.assertEqual(displaced, 22)

    def test_host_property_metadata_is_explicit(self) -> None:
        ids = {row["id"] for row in self.host_scenarios["scenarios"]}
        self.assertTrue(REQUIRED_HOST_SCENARIOS <= ids)
        inert = next(row for row in self.host_scenarios["scenarios"] if row["id"] == "cd0-host-property-inert-records")
        self.assertEqual(set(inert["shapes"]), {"capability", "warrant", "claim", "certificate", "receipt"})
        self.assertEqual(len(inert["positive_vector_refs"]), 5)
        self.assertIn("separately retained Phase-4 evidence", self.host_scenarios["factual_status"])
        self.assertTrue(all(row["execution_status"] == "not-executed-by-generator" for row in self.host_scenarios["scenarios"]))
        self.assertIn("integration adapters", self.host_scenarios["integration_adapter_note"])

    def test_all_resource_limits_have_explicit_boundary_metadata(self) -> None:
        scenarios = self.host_scenarios["resource_boundary_scenarios"]
        self.assertEqual(len(scenarios), 14)
        self.assertEqual({row["limit"] for row in scenarios}, RESOURCE_LIMITS)
        self.assertTrue(all(row["execution_status"] == "not-executed-by-generator" for row in scenarios))
        for row in scenarios:
            self.assertIn("operation", row)
            self.assertIn("budget_base", row)
            self.assertIn("accept_value", row)
            self.assertIn("refuse_value", row)
            self.assertIn("expected_refusal", row)
            self.assertIn("success_assertion", row)
            self.assertTrue("input_hex" in row or "fixture_ast" in row)
        integer = next(row for row in scenarios if row["limit"] == "max_integer_bits")
        self.assertEqual(integer["expected_refusal"]["status"], "normative")
        depth = next(row for row in scenarios if row["limit"] == "max_depth")
        nodes = next(row for row in scenarios if row["limit"] == "max_nodes")
        self.assertEqual(depth["expected_refusal"]["stage"], "type-tag")
        self.assertEqual(nodes["expected_refusal"]["stage"], "type-tag")

    def test_identifier_distinction_pairs_are_explicit_and_disjoint(self) -> None:
        expected = {
            "precomposed-decomposed",
            "latin-cyrillic-confusable",
            "namespace-path",
            "case",
            "segmentation",
        }
        observed: dict[str, list[dict]] = {}
        for row in self.positives:
            for note in row["notes"]:
                if note.startswith("identifier-distinction="):
                    observed.setdefault(note.split("=", 1)[1], []).append(row)
        self.assertEqual(set(observed), expected)
        for distinction, rows in observed.items():
            self.assertEqual(len(rows), 2, distinction)
            self.assertEqual({next(note for note in row["notes"] if note.startswith("pair-side=")) for row in rows}, {"pair-side=left", "pair-side=right"})
            self.assertEqual(len({row["canonical_hex"] for row in rows}), 2, distinction)
            self.assertEqual(len({row["equality_class"] for row in rows}), 2, distinction)

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
        self.assertIn("A1-A9 are closed", self.manifest["errata_closure"])
        self.assertIn("not global semantic uniqueness", self.manifest["negative_distinctness_scope"])
        self.assertIn("primary defect", self.manifest["negative_minimization"]["primary_defect_scope"])

    def test_compact_padding_is_byte_deletion_primary_minimal(self) -> None:
        negative_by_id = {row["id"]: row for row in self.negatives}
        cd0 = GENERATOR.import_codec(ROOT)
        budgets = GENERATOR.load_budgets(ROOT, cd0)
        compact = [
            row for row in self.derivations
            if row["minimization_kind"] == "byte-deletion-primary-minimal"
        ]
        self.assertGreater(len(compact), 0)
        self.assertEqual(
            len(compact),
            self.manifest["counts"]["negative_by_minimization_kind"]["byte-deletion-primary-minimal"],
        )
        self.assertEqual(
            len(compact), self.manifest["negative_minimization"]["demonstrated_primary_minimal_count"]
        )
        self.assertEqual(
            self.manifest["negative_minimization"]["demonstrated_primary_minimal_threshold"], 20_000
        )
        for derivation in compact:
            row = negative_by_id[derivation["id"]]
            source = bytes.fromhex(row["input_hex"])
            proof = derivation["minimization_proof"]
            self.assertEqual(len(source), 9)
            self.assertEqual(row["budget"]["max_input_octets"], 8)
            self.assertEqual(row["retry_budget"], "cd0-conformance-default")
            self.assertEqual(row["expected_failure"], {
                "category": "ResourceRefusal",
                "code": "ExcessiveInputLength",
                "stage": "input-budget",
            })
            self.assertTrue(proof["all_one_octet_deletions_remove_primary_defect"])
            self.assertEqual(proof["claim_scope"], "primary ExcessiveInputLength defect only")
            budget = GENERATOR.resolve_budget(row["budget"], budgets, cd0, f"minimal:{row['id']}")
            for position in range(9):
                shortened = source[:position] + source[position + 1:]
                self.assertLessEqual(len(shortened), 8)
                try:
                    cd0.decode_exact(shortened, budget)
                except cd0.CD0Failure as failure:
                    self.assertNotEqual(failure.code, "ExcessiveInputLength", (row["id"], position))

    def test_every_declared_retry_succeeds_and_reencodes_identically(self) -> None:
        cd0 = GENERATOR.import_codec(ROOT)
        budgets = GENERATOR.load_budgets(ROOT, cd0)
        observed = 0
        for row in self.negatives:
            if "retry_budget" not in row:
                continue
            observed += 1
            retry = GENERATOR.resolve_budget(row["retry_budget"], budgets, cd0, f"test:{row['id']}")
            source = bytes.fromhex(row["input_hex"])
            decoded = cd0.decode_exact(source, retry)
            self.assertEqual(cd0.encode_exact(decoded, retry), source, row["id"])
        self.assertEqual(observed, self.manifest["counts"]["negative_retry_verified"])

    def test_every_classified_negative_has_a_complete_normative_triple(self) -> None:
        expected: dict[str, int] = {}
        for row in self.negatives:
            status = row.get("status", "normative")
            expected[status] = expected.get(status, 0) + 1
        self.assertEqual(self.manifest["counts"]["classified_negative_by_status"], dict(sorted(expected.items())))
        self.assertEqual(expected, {"normative": len(self.negatives)})
        self.assertTrue(all("status" not in row for row in self.negatives))
        identifier_resource_rows = [
            row for row in self.negatives
            if any(token in row["id"] for token in (
                "resource-identifier-segments",
                "resource-segment-length",
                "resource-identifier-declaration-only",
            ))
        ]
        self.assertEqual(len(identifier_resource_rows), 3)
        self.assertTrue(
            all(set(row["expected_failure"]) == {"category", "code", "stage"} for row in identifier_resource_rows)
        )

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

    def test_twenty_thousand_total_refuses_without_demonstrated_primary_minimum(self) -> None:
        refused = Path(self.temporary.name) / "primary-minimum-refused"
        command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(ROOT),
            "--output-dir",
            str(refused),
            "--positive-count",
            "10000",
            "--negative-count",
            "20000",
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("at least 20308", completed.stderr)
        self.assertIn("20000 demonstrated byte-deletion-primary-minimal", completed.stderr)
        self.assertFalse(refused.exists())

    def test_release_qualification_has_independent_total_and_primary_minimums(self) -> None:
        self.assertFalse(GENERATOR.release_qualifies(9_999, 20_308, 20_000))
        self.assertFalse(GENERATOR.release_qualifies(10_000, 19_999, 20_000))
        self.assertFalse(GENERATOR.release_qualifies(10_000, 20_308, 19_999))
        self.assertTrue(GENERATOR.release_qualifies(10_000, 20_308, 20_000))
        defaults = GENERATOR.parser().parse_args(["--output-dir", "/tmp/cd0-default-count-probe"])
        self.assertEqual(defaults.negative_count, 20_308)

    def test_dirty_source_override_is_small_mode_only(self) -> None:
        refused = Path(self.temporary.name) / "dirty-override-refused"
        command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(ROOT),
            "--output-dir",
            str(refused),
            "--positive-count",
            "384",
            "--negative-count",
            "640",
            "--allow-dirty-source",
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("only together with --allow-small", completed.stderr)
        self.assertFalse(refused.exists())

    def test_dirty_worktree_refuses_without_explicit_small_mode_override(self) -> None:
        false_root = Path(self.temporary.name) / "dirty-root"
        false_spec = false_root / "mneme" / "spec" / "CANONICAL-DATUM-SPEC.md"
        false_spec.parent.mkdir(parents=True)
        shutil.copy2(ROOT / "mneme" / "spec" / "CANONICAL-DATUM-SPEC.md", false_spec)
        for name in (
            "CD0-POST-IMPLEMENTATION-RULING.md",
            "CANONICAL-DATUM-SPEC-ERRATA-0.1.md",
        ):
            shutil.copy2(ROOT / name, false_root / name)
        false_errata_vectors = false_root / "canonical-datum" / "vectors" / "cd0-errata-0.1.json"
        false_errata_vectors.parent.mkdir(parents=True)
        shutil.copy2(
            ROOT / "canonical-datum" / "vectors" / "cd0-errata-0.1.json",
            false_errata_vectors,
        )
        subprocess.run(["git", "init", "-q"], cwd=false_root, check=True)
        subprocess.run(["git", "add", "."], cwd=false_root, check=True)
        subprocess.run(
            ["git", "-c", "user.name=CD0 Test", "-c", "user.email=cd0@example.invalid", "commit", "-qm", "pin spec"],
            cwd=false_root,
            check=True,
        )
        (false_root / "untracked-source").write_text("dirty\n", encoding="utf-8")
        refused = Path(self.temporary.name) / "dirty-worktree-refused"
        command = [
            sys.executable,
            str(SCRIPT),
            "--repo-root",
            str(false_root),
            "--output-dir",
            str(refused),
            "--positive-count",
            "96",
            "--negative-count",
            "512",
            "--mutation-sample-count",
            "16",
            "--allow-small",
        ]
        completed = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("worktree is not clean", completed.stderr)
        self.assertIn("untracked-source", completed.stderr)
        self.assertFalse(refused.exists())

    def test_staging_is_removed_and_final_output_absent_on_write_failure(self) -> None:
        output = Path(self.temporary.name) / "atomic-output"
        args = GENERATOR.parser().parse_args([
            "--repo-root", str(ROOT),
            "--output-dir", str(output),
            "--positive-count", "96",
            "--negative-count", "512",
            "--mutation-sample-count", "16",
            "--truncation-max-document-octets", "10",
            "--allow-small",
            "--allow-dirty-source",
        ])
        with mock.patch.object(GENERATOR, "write_jsonl", side_effect=OSError("injected write refusal")):
            with self.assertRaisesRegex(OSError, "injected write refusal"):
                GENERATOR.generate(args)
        self.assertFalse(output.exists())
        self.assertEqual(list(output.parent.glob(f".{output.name}.staging-*")), [])

    def test_source_hash_drift_refuses_before_publication(self) -> None:
        output = Path(self.temporary.name) / "source-drift-output"
        args = GENERATOR.parser().parse_args([
            "--repo-root", str(ROOT),
            "--output-dir", str(output),
            "--positive-count", "96",
            "--negative-count", "512",
            "--mutation-sample-count", "16",
            "--truncation-max-document-octets", "10",
            "--allow-small",
            "--allow-dirty-source",
        ])
        actual = GENERATOR.source_input_hashes(ROOT)
        changed = dict(actual)
        changed["canonical-datum/generator/generate_corpus.py"] = "0" * 64
        with mock.patch.object(GENERATOR, "source_input_hashes", side_effect=[actual, changed]):
            with self.assertRaisesRegex(GENERATOR.GeneratorError, "source inputs drifted"):
                GENERATOR.generate(args)
        self.assertFalse(output.exists())
        self.assertEqual(list(output.parent.glob(f".{output.name}.staging-*")), [])

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
        self.assertIn(EXPECTED_NORMATIVE_SHA256["base-specification"], completed.stderr)
        self.assertFalse(refused.exists())


if __name__ == "__main__":
    unittest.main()
