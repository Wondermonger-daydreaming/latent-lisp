from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import post_convergence as subject
import response_validation


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
    mismatches.extend(
        {
            "request_id": request_id,
            "kind": "hostile",
            "disposition": "authorial-blocked",
        }
        for request_id in sorted(subject.BLOCKED_HOSTILE_REQUESTS)
    )
    mismatches.extend(
        {
            "request_id": request_id,
            "kind": "relation",
            "disposition": "authorial-blocked",
        }
        for request_id in sorted(subject.BLOCKED_RELATION_PATH_REQUESTS)
    )
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
        "authorial_blocked_hostile_requests": sorted(
            subject.BLOCKED_HOSTILE_REQUESTS
        ),
        "authorial_blocked_relation_paths": sorted(
            subject.BLOCKED_RELATION_PATH_REQUESTS
        ),
        "counts": {
            "baseline_requests_per_implementation": 2266,
            "hostile_requests_per_implementation": 21,
            "magic_registry_values": 1133,
            "magic_vector_values": 460,
            "official_documents": 1105,
            "supplementary_documents": 488,
            "supplementary_nested_e1_documents": 30,
            "supplementary_relation_documents": 458,
            "total_documents": 1593,
            "total_requests_per_implementation": 2287,
            "vector_semantic_requests": 215,
            "relation_semantic_requests": 458,
            "vector_operation_families": dict(
                sorted(
                    subject.Counter(
                        row["operation"] for row in subject.iter_vectors()
                    ).items()
                )
            ),
        },
        "pinned_seeds": {
            "common_lisp": {
                "commit": subject.COMMON_LISP_SEED_COMMIT,
                "tree": subject.COMMON_LISP_SEED_TREE,
            },
            "python": {
                "commit": subject.PYTHON_SEED_COMMIT,
                "tree": subject.PYTHON_SEED_TREE,
            },
        },
        "comparison": {
            "implementations": {
                "common-lisp": {
                    "counts": dict(subject.EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS),
                    "mismatches": list(mismatches),
                },
                "python": {
                    "counts": dict(subject.EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS),
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
        self.assertEqual(result["vector_blocker_count"], 4)
        self.assertEqual(result["hostile_blocker_count"], 8)
        self.assertEqual(result["observed_cross_hostile_blocker_disagreements"], 0)

    def test_gate_allows_only_enumerated_cross_path_differences(self):
        request_id = sorted(subject.BLOCKED_RELATION_PATH_REQUESTS)[0]
        result = subject.verify_successor_gate(_successor_summary([request_id]))
        self.assertEqual(result["observed_cross_relation_path_disagreements"], 1)

    def test_gate_allows_only_enumerated_hostile_result_differences(self):
        value = _successor_summary()
        request_id = "hostile:resource-maximum-nesting-at-limit-64"
        value["comparison"]["cross_implementation_mismatches"] = [
            {
                "request_id": request_id,
                "kind": "hostile",
                "differences": {
                    "actual_canonical_cd0_hex": {
                        "common-lisp": "aa",
                        "python": "bb",
                    }
                },
            }
        ]
        result = subject.verify_successor_gate(value)
        self.assertEqual(result["observed_cross_hostile_blocker_disagreements"], 1)
        value["comparison"]["cross_implementation_mismatches"][0][
            "differences"
        ] = {"semantic_status": {"common-lisp": "success", "python": "failure"}}
        with self.assertRaises(subject.EvidenceFailure):
            subject.verify_successor_gate(value)

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

    def test_gate_rejects_missing_corpus_relation_hostile_execution(self):
        value = _successor_summary()
        value["comparison"]["implementations"]["python"]["counts"] = {
            "vector_passed": 211,
            "vector_blocked": 4,
        }
        with self.assertRaises(subject.EvidenceFailure):
            subject.verify_successor_gate(value)

    def test_gate_rejects_wrong_seed_and_fabricated_operation_census(self):
        wrong_seed = _successor_summary()
        wrong_seed["pinned_seeds"]["python"]["commit"] = "0" * 40
        with self.assertRaisesRegex(subject.EvidenceFailure, "seed provenance"):
            subject.verify_successor_gate(wrong_seed)

        fake_operations = _successor_summary()
        fake_operations["counts"]["vector_operation_families"] = {
            f"operation-{index:02d}": 1 if index else 164
            for index in range(52)
        }
        with self.assertRaisesRegex(subject.EvidenceFailure, "operation family"):
            subject.verify_successor_gate(fake_operations)


class ClosedResponseParsingTests(unittest.TestCase):
    def test_property_parser_rejects_unknown_response_fields(self):
        request_id = "property:probe"
        operation = "probe-operation"
        vector_id = "LCI0-POST-PROBE"
        input_hex = subject.canonical_bytes(subject.cd0.unit()).hex()
        actual = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("kind",)),
                    subject.cd0.identifier(
                        subject.FIXTURE, ("tag", "fixture-operation-result")
                    ),
                ),
                (
                    subject.cd0.identifier(
                        subject.FIXTURE_FIELD, ("schema-version",)
                    ),
                    subject.cd0.integer(0),
                ),
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("status",)),
                    subject.cd0.identifier(
                        subject.FIXTURE, ("result-status", "success")
                    ),
                ),
                (
                    subject.cd0.identifier(
                        subject.FIXTURE_FIELD, ("operation",)
                    ),
                    subject.cd0.identifier(
                        subject.FIXTURE, ("operation", operation)
                    ),
                ),
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("outputs",)),
                    subject.cd0.record(()),
                ),
            )
        )
        actual_hex = subject.canonical_bytes(actual).hex()
        seed_commit, seed_tree = response_validation.IMPLEMENTATION_PINS["python"]
        response = {
            "protocol": subject.PROTOCOL,
            "request_id": request_id,
            "operation": operation,
            "fixture_profile_version": subject.FIXTURE_PROFILE_VERSION,
            "implementation": "python",
            "implementation_seed_commit": seed_commit,
            "implementation_seed_tree": seed_tree,
            "protocol_status": "success",
            "input_reencoded_canonical_hex": input_hex,
            "vector_id": vector_id,
            "semantic_status": "success",
            "actual_canonical_cd0_hex": actual_hex,
        }
        expectations = {
            request_id: {"operation": operation, "vector_id": vector_id}
        }
        payload = (json.dumps(response, sort_keys=True) + "\n").encode("utf-8")
        parsed = subject._parse_responses(
            payload, expectations, "probe", "python"
        )
        self.assertEqual(parsed[request_id], response)

        serialized = json.dumps(response, sort_keys=True)
        duplicate_payload = (
            '{"protocol":"WRONG",' + serialized[1:] + "\n"
        ).encode("utf-8")
        with self.assertRaisesRegex(subject.EvidenceFailure, "invalid JSON"):
            subject._parse_responses(
                duplicate_payload, expectations, "probe", "python"
            )

        response["unapproved"] = True
        payload = (json.dumps(response, sort_keys=True) + "\n").encode("utf-8")
        with self.assertRaisesRegex(subject.EvidenceFailure, "response schema"):
            subject._parse_responses(payload, expectations, "probe", "python")

        del response["unapproved"]
        for invalid_actual in (
            "00",
            subject.canonical_bytes(subject.cd0.unit()).hex(),
        ):
            with self.subTest(invalid_actual=invalid_actual):
                response["actual_canonical_cd0_hex"] = invalid_actual
                payload = (json.dumps(response, sort_keys=True) + "\n").encode(
                    "utf-8"
                )
                with self.assertRaisesRegex(
                    subject.EvidenceFailure, "canonical result/report mismatch"
                ):
                    subject._parse_responses(
                        payload, expectations, "probe", "python"
                    )

        lci = ("lisp-plus", "lci", "0")
        failure_namespace = lci + ("failure",)
        failure_datum = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(lci, ("kind",)),
                    subject.cd0.identifier(lci + ("tag",), ("failure",)),
                ),
                (
                    subject.cd0.identifier(lci, ("schema-version",)),
                    subject.cd0.integer(0),
                ),
                (
                    subject.cd0.identifier(lci, ("category",)),
                    subject.cd0.identifier(failure_namespace, ("invalid-input",)),
                ),
                (
                    subject.cd0.identifier(lci, ("code",)),
                    subject.cd0.identifier(failure_namespace, ("UnknownField",)),
                ),
                (
                    subject.cd0.identifier(lci, ("stage",)),
                    subject.cd0.identifier(failure_namespace, ("fixture-operation",)),
                ),
                (
                    subject.cd0.identifier(lci, ("path",)),
                    subject.cd0.sequence(
                        (subject.cd0.identifier(subject.FIXTURE_FIELD, ("payload",)),)
                    ),
                ),
                (
                    subject.cd0.identifier(lci, ("context",)),
                    subject.cd0.record(()),
                ),
            )
        )
        response["actual_canonical_cd0_hex"] = subject.canonical_bytes(
            failure_datum
        ).hex()
        response["semantic_status"] = "failure"
        response["failure"] = {
            "category": "invalid-input",
            "code": "MissingRequiredField",
            "stage": "fixture-operation",
            "path": ["fixture-field:payload"],
        }
        payload = (json.dumps(response, sort_keys=True) + "\n").encode("utf-8")
        with self.assertRaisesRegex(
            subject.EvidenceFailure, "canonical result/report mismatch"
        ):
            subject._parse_responses(payload, expectations, "probe", "python")

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
        self.assertEqual(len(self.first), 205)
        self.assertEqual(
            sum(
                bool(case.authorial_blocked_failure_coordinates)
                for case in self.first
            ),
            104,
        )

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
                "operation-payload-closure", "semantic-dispatch-validation",
                "policy-meta-testimony", "semantic-anti-shortcut",
                "resource-boundary",
            }
            <= families
        )

    def test_projection_cases_use_exact_four_field_core(self):
        projection_cases = [
            case
            for case in self.first
            if case.operation == "project-claim-id"
            and case.expected_status == "success"
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

    def test_property_input_identity_is_not_a_cross_language_tautology(self):
        case = self.first[0]
        expected = subject.canonical_bytes(case.datum).hex()
        self.assertTrue(
            subject._case_input_roundtrips(
                case, {"input_reencoded_canonical_hex": expected}
            )
        )
        self.assertFalse(
            subject._case_input_roundtrips(
                case, {"input_reencoded_canonical_hex": "00"}
            )
        )

    def test_unpinned_failure_coordinates_are_blocked_not_compared(self):
        case = next(
            case
            for case in self.first
            if case.authorial_blocked_failure_coordinates
        )
        common = {
            "protocol_status": "success",
            "semantic_status": "failure",
            "actual_canonical_cd0_hex": "00",
            "failure": {
                "category": "invalid-input",
                "code": case.failure_code,
                "stage": "common-lisp-choice",
                "path": ["common-lisp-choice"],
                "context": {"implementation": "common-lisp"},
            },
        }
        python = {
            **common,
            "actual_canonical_cd0_hex": "01",
            "failure": {
                "category": "projection-refusal",
                "code": case.failure_code,
                "stage": "python-choice",
                "path": ["python-choice"],
                "context": {"implementation": "python"},
            },
        }
        self.assertEqual(
            subject._semantic_view_for_case(common, case),
            subject._semantic_view_for_case(python, case),
        )

    def test_output_identifier_requires_full_namespace_and_segmented_path(self):
        case = subject.PropertyCase(
            case_id="identifier-namespace-probe",
            family="protocol-hardening",
            operation="probe",
            datum=subject.cd0.unit(),
            expected_status="success",
            output_identifiers=(
                (
                    ("policy-b-decision", "decision"),
                    subject.FIXTURE,
                    ("admissibility-decision", "accept-limited-testimony"),
                ),
            ),
        )
        decision = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("decision",)),
                    subject.cd0.identifier(
                        ("attacker", "namespace"),
                        ("accept-limited-testimony",),
                    ),
                ),
            )
        )
        result = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("outputs",)),
                    subject.cd0.record(
                        (
                            (
                                subject.cd0.identifier(
                                    subject.FIXTURE_FIELD,
                                    ("policy-b-decision",),
                                ),
                                decision,
                            ),
                        )
                    ),
                ),
            )
        )
        actual_hex = subject.canonical_bytes(result).hex()
        self.assertFalse(
            subject._result_output_identifier_matches(
                actual_hex,
                ("policy-b-decision", "decision"),
                subject.FIXTURE,
                ("admissibility-decision", "accept-limited-testimony"),
            )
        )

        wrong_key_decision = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(("attacker",), ("decision",)),
                    subject.cd0.identifier(
                        subject.FIXTURE,
                        ("admissibility-decision", "accept-limited-testimony"),
                    ),
                ),
            )
        )
        wrong_key_result = subject.cd0.record(
            (
                (
                    subject.cd0.identifier(subject.FIXTURE_FIELD, ("outputs",)),
                    subject.cd0.record(
                        (
                            (
                                subject.cd0.identifier(
                                    subject.FIXTURE_FIELD,
                                    ("policy-b-decision",),
                                ),
                                wrong_key_decision,
                            ),
                        )
                    ),
                ),
            )
        )
        self.assertFalse(
            subject._result_output_identifier_matches(
                subject.canonical_bytes(wrong_key_result).hex(),
                ("policy-b-decision", "decision"),
                subject.FIXTURE,
                ("admissibility-decision", "accept-limited-testimony"),
            )
        )


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
        self.assertEqual(
            result["rational_adapter_results"],
            ["accepted"] + ["NoncanonicalFixtureRational"] * 4,
        )

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
        self.assertEqual(
            result["rational_adapter_results"],
            ["accepted"] + ["NoncanonicalFixtureRational"] * 4,
        )

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
