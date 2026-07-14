from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import post_convergence as subject


def _failure(path: list[str]) -> dict:
    return {
        "category": "relation-undetermined",
        "code": "ScopeIncompatible",
        "stage": "target-relation",
        "path": path,
    }


def _successor_summary(cross_ids=()) -> dict:
    mismatches = [
        {
            "request_id": request_id,
            "kind": "vector",
            "disposition": "authorial-blocked",
        }
        for request_id in sorted(subject.BLOCKED_VECTOR_REQUESTS)
    ]
    cross = [
        {
            "request_id": request_id,
            "kind": "relation",
            "differences": {
                "failure": {
                    "common-lisp": _failure(["right"]),
                    "python": _failure(["right", "calculus"]),
                }
            },
        }
        for request_id in cross_ids
    ]
    return {
        "protocol": subject.PROTOCOL,
        "fixture_profile_version": subject.FIXTURE_PROFILE_VERSION,
        "status": "converged-unaffected-with-authorial-blockers",
        "authorial_return_required": True,
        "authorial_blocked_vectors": sorted(subject.BLOCKED_VECTOR_REQUESTS),
        "authorial_blocked_relation_paths": sorted(
            subject.BLOCKED_RELATION_PATH_REQUESTS
        ),
        "counts": {
            "official_documents": 1105,
            "supplementary_documents": 488,
            "total_documents": 1593,
            "vector_semantic_requests": 215,
            "relation_semantic_requests": 458,
        },
        "comparison": {
            "implementations": {
                "common-lisp": {
                    "counts": {"vector_passed": 212, "vector_blocked": 3},
                    "mismatches": list(mismatches),
                },
                "python": {
                    "counts": {"vector_passed": 212, "vector_blocked": 3},
                    "mismatches": list(mismatches),
                },
            },
            "cross_implementation_mismatches": cross,
        },
    }


class SuccessorGateTests(unittest.TestCase):
    def test_gate_allows_converged_implementation_paths_but_keeps_blocked_census(self):
        result = subject.verify_successor_gate(_successor_summary())
        self.assertEqual(result["observed_cross_relation_path_disagreements"], 0)
        self.assertEqual(result["relation_path_blocker_count"], 38)
        self.assertEqual(result["vector_blocker_count"], 3)

    def test_gate_allows_only_enumerated_cross_path_differences(self):
        request_id = sorted(subject.BLOCKED_RELATION_PATH_REQUESTS)[0]
        result = subject.verify_successor_gate(_successor_summary([request_id]))
        self.assertEqual(result["observed_cross_relation_path_disagreements"], 1)

    def test_gate_rejects_non_authorial_vector_mismatch(self):
        value = _successor_summary()
        value["comparison"]["implementations"]["python"]["mismatches"].append(
            {"request_id": "vector:LCI0-P001", "kind": "vector"}
        )
        with self.assertRaises(subject.EvidenceFailure):
            subject.verify_successor_gate(value)

    def test_gate_rejects_silently_missing_blocker_declaration(self):
        value = _successor_summary()
        value["authorial_blocked_relation_paths"].pop()
        with self.assertRaises(subject.EvidenceFailure):
            subject.verify_successor_gate(value)


class PropertyConstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.first = subject.build_property_cases(subject.PROPERTY_SEED, 2)
        cls.second = subject.build_property_cases(subject.PROPERTY_SEED, 2)

    def test_generation_is_seeded_and_byte_deterministic(self):
        self.assertEqual(
            [case.manifest_row() for case in self.first],
            [case.manifest_row() for case in self.second],
        )
        self.assertEqual(len(self.first), 96)

    def test_case_ids_are_closed_unique_and_cover_required_families(self):
        ids = [case.case_id for case in self.first]
        self.assertEqual(len(ids), len(set(ids)))
        families = {case.family for case in self.first}
        self.assertTrue(
            {
                "record-allocation-order", "identity-coordinate",
                "metadata-neutrality", "unicode-nonnormalization",
                "rational-boundary", "identifier-boundary",
                "target-schema-boundary", "target-unknown-boundary",
                "e6-failure-order", "migration-grammar",
                "migration-inertness", "migration-source-provenance",
                "resource-boundary",
            }
            <= families
        )

    def test_projection_cases_use_exact_four_field_core(self):
        projection_cases = [
            case for case in self.first if case.operation == "project-claim-id"
        ]
        self.assertTrue(projection_cases)
        for case in projection_cases:
            payload = subject._field(case.datum, "payload")
            core = subject._field(payload, "claim")
            self.assertEqual(
                {key.path[-1] for key, _ in core.fields},
                {"identity-policy", "claim-profile", "proposition", "location"},
            )

    def test_identifier_case_and_segmentation_are_valid_but_distinct(self):
        cases = [case for case in self.first if case.family == "identifier-boundary"]
        self.assertEqual(len(cases), 8)
        self.assertTrue(all(case.expected_status == "success" for case in cases))
        compare_cases = [case for case in cases if case.output_boolean is not None]
        self.assertEqual(len(compare_cases), 4)
        self.assertEqual(len({subject.canonical_bytes(case.datum) for case in compare_cases}), 4)


class NativeProbeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = Path(__file__).resolve().parents[3]
        cls.environment = dict(os.environ)
        cls.environment["PYTHONPATH"] = os.pathsep.join(
            (
                str(cls.root / "mneme/lci0/differential"),
                str(cls.root / "mneme/lci0/python"),
                str(cls.root / "canonical-datum/python"),
            )
        )

    def test_python_denial_self_tests_and_fresh_projection(self):
        environment = dict(self.environment)
        environment.update(
            {"PYTHONHASHSEED": "0", "LC_ALL": "C", "LCI0_HOST_PROFILE": "unit"}
        )
        process = subprocess.run(
            [
                sys.executable,
                str(self.root / "mneme/lci0/differential/python_host_probe.py"),
                "--seed", str(subject.PROPERTY_SEED), "--cases", "1",
            ],
            cwd=self.root, env=environment, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, text=True, check=False,
        )
        self.assertEqual(process.returncode, 0, process.stderr)
        result = json.loads(process.stdout)
        self.assertEqual(result["denial_self_tests"], 8)
        self.assertEqual(result["unique_projection_hashes"], 1)

    def test_common_lisp_denial_self_tests_and_fresh_projection(self):
        environment = dict(self.environment)
        environment.update(
            {"LC_ALL": "C", "LCI0_HOST_PROFILE": "unavailable-io-clock", "LCI0_PROPERTY_CASES": "1"}
        )
        process = subprocess.run(
            [
                "sbcl", "--noinform", "--disable-debugger", "--script",
                str(self.root / "mneme/lci0/differential/common_lisp_host_probe.lisp"),
            ],
            cwd=self.root, env=environment, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, text=True, check=False,
        )
        self.assertEqual(process.returncode, 0, process.stderr)
        result = json.loads(process.stdout)
        self.assertEqual(result["unique_projection_values"], 1)
        self.assertIn("signalling denial", result["wall_clock"])

    def test_recursive_manifest_excludes_only_itself(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "a").mkdir()
            (root / "a/data.bin").write_bytes(b"data")
            subject._write_manifest(root)
            manifest = json.loads((root / "sha256-manifest.json").read_text())
            self.assertEqual(set(manifest["members"]), {"a/data.bin"})
            self.assertTrue(manifest["manifest_excludes_itself"])


if __name__ == "__main__":
    unittest.main()
