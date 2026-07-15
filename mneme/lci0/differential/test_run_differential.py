from __future__ import annotations

import copy
from pathlib import Path
import sys
import tempfile
import unittest

import run_differential as subject


def _comparison() -> dict:
    # A fully converged comparison after LCI0-AC-001..010: both implementations
    # pass every request with zero mismatches and zero cross-difference.
    result = {
        "counts": dict(subject.EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS),
        "mismatches": [],
    }
    return {
        "implementations": {
            "common-lisp": copy.deepcopy(result),
            "python": copy.deepcopy(result),
        },
        "cross_implementation_mismatches": [],
    }


def _adapter_response(
    implementation: str,
    request_id: str,
    operation: str,
    input_hex: str,
    **fields,
) -> dict:
    seed_commit, seed_tree = (
        (subject.COMMON_LISP_SEED_COMMIT, subject.COMMON_LISP_SEED_TREE)
        if implementation == "common-lisp"
        else (subject.PYTHON_SEED_COMMIT, subject.PYTHON_SEED_TREE)
    )
    return {
        "protocol": subject.PROTOCOL,
        "request_id": request_id,
        "operation": operation,
        "fixture_profile_version": subject.FIXTURE_PROFILE_VERSION,
        "implementation": implementation,
        "implementation_seed_commit": seed_commit,
        "implementation_seed_tree": seed_tree,
        "protocol_status": "success",
        "input_reencoded_canonical_hex": input_hex,
        **fields,
    }


def _both_responses(
    request_id: str, operation: str, input_hex: str, **fields
) -> tuple[dict, dict]:
    return (
        {request_id: _adapter_response("common-lisp", request_id, operation, input_hex, **fields)},
        {request_id: _adapter_response("python", request_id, operation, input_hex, **fields)},
    )


def _success_result(operation: str) -> str:
    datum = subject.cd0.record(
        (
            (
                subject.cd0.identifier(subject.FIXTURE_FIELD, ("kind",)),
                subject.cd0.identifier(
                    subject.FIXTURE, ("tag", "fixture-operation-result")
                ),
            ),
            (
                subject.cd0.identifier(subject.FIXTURE_FIELD, ("schema-version",)),
                subject.cd0.integer(0),
            ),
            (
                subject.cd0.identifier(subject.FIXTURE_FIELD, ("status",)),
                subject.cd0.identifier(
                    subject.FIXTURE, ("result-status", "success")
                ),
            ),
            (
                subject.cd0.identifier(subject.FIXTURE_FIELD, ("operation",)),
                subject.cd0.identifier(subject.FIXTURE, ("operation", operation)),
            ),
            (
                subject.cd0.identifier(subject.FIXTURE_FIELD, ("outputs",)),
                subject.cd0.record(()),
            ),
        )
    )
    return subject.canonical_bytes(datum).hex()


class FullConvergenceGateTests(unittest.TestCase):
    def test_accepts_fully_converged_census(self):
        self.assertTrue(subject._fully_converged(_comparison()))

    def test_rejects_any_vector_mismatch(self):
        value = _comparison()
        value["implementations"]["python"]["mismatches"].append(
            {"request_id": "vector:LCI0-P001", "kind": "vector"}
        )
        self.assertFalse(subject._fully_converged(value))

    def test_rejects_incomplete_execution_census(self):
        value = _comparison()
        del value["implementations"]["python"]["counts"]["hostile_passed"]
        self.assertFalse(subject._fully_converged(value))

    def test_rejects_any_cross_difference(self):
        value = _comparison()
        value["cross_implementation_mismatches"] = [
            {
                "request_id": "hostile:resource-stable-ref-material-5000",
                "kind": "hostile",
                "differences": {
                    "failure": {
                        "common-lisp": {"path": ["material"]},
                        "python": {"path": []},
                    }
                },
            }
        ]
        self.assertFalse(subject._fully_converged(value))

    def test_rejects_wrong_implementation_set(self):
        value = _comparison()
        del value["implementations"]["python"]
        self.assertFalse(subject._fully_converged(value))

    def test_rejects_wrong_execution_counts(self):
        value = _comparison()
        value["implementations"]["common-lisp"]["counts"]["vector_passed"] = 214
        self.assertFalse(subject._fully_converged(value))


class CanonicalInputComparisonTests(unittest.TestCase):
    def test_response_metadata_and_field_set_fail_closed(self):
        request_id = "doc:probe"
        operation = "document-roundtrip"
        input_hex = subject.canonical_bytes(subject.cd0.unit()).hex()
        oracle = {
            request_id: {
                "kind": "document",
                "expected_input_hex": input_hex,
                "expected_hex": input_hex,
                "request_operation": operation,
            }
        }
        mutations = (
            ("extra-field", "not-authorized"),
            ("protocol", "wrong-protocol"),
            ("implementation", "python"),
            ("implementation_seed_commit", "0" * 40),
            ("implementation_seed_tree", "0" * 40),
            ("operation", "wrong-operation"),
            ("fixture_profile_version", "99.0.0"),
        )
        for field, value in mutations:
            with self.subTest(field=field):
                common_lisp, python = _both_responses(
                    request_id,
                    operation,
                    input_hex,
                    semantic_status="success",
                )
                common_lisp[request_id][field] = value
                comparison = subject._compare(oracle, common_lisp, python)
                counts = comparison["implementations"]["common-lisp"]["counts"]
                self.assertEqual(counts["response_schema_failures"], 1)
                self.assertNotIn("document_passed", counts)

        common_lisp, python = _both_responses(
            request_id, operation, input_hex, semantic_status="success"
        )
        del common_lisp[request_id]["implementation_seed_tree"]
        comparison = subject._compare(oracle, common_lisp, python)
        self.assertEqual(
            comparison["implementations"]["common-lisp"]["counts"][
                "response_schema_failures"
            ],
            1,
        )

    def test_exact_runner_rejects_duplicate_json_response_members(self):
        request_id = "doc:duplicate-member"
        command = [
            sys.executable,
            "-c",
            (
                "import sys; sys.stdin.buffer.read(); "
                "sys.stdout.write('{\"request_id\":\"wrong\",'"
                "'\"request_id\":\"doc:duplicate-member\"}\\n')"
            ),
        ]
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(subject.HarnessFailure, "invalid JSON"):
                subject._run_adapter(
                    "duplicate-probe",
                    command,
                    {},
                    [
                        {
                            "request_id": request_id,
                            "operation": "document-roundtrip",
                        }
                    ],
                    Path(directory),
                )

    def test_vector_reported_identity_operation_and_profile_are_oracle_checked(self):
        request_id = "vector:probe"
        input_hex = subject.canonical_bytes(subject.cd0.unit()).hex()
        expected_result = _success_result("probe-operation")
        oracle = {
            request_id: {
                "kind": "vector",
                "expected_input_hex": input_hex,
                "expected_hex": expected_result,
                "vector_id": "probe",
                "operation": "probe-operation",
                "request_operation": "probe-operation",
            }
        }
        fields = {
            "actual_canonical_cd0_hex": expected_result,
            "vector_id": "probe",
            "semantic_status": "success",
        }
        common_lisp, python = _both_responses(
            request_id, "probe-operation", input_hex, **fields
        )
        passing = subject._compare(
            oracle, common_lisp, python
        )
        for implementation in ("common-lisp", "python"):
            self.assertEqual(
                passing["implementations"][implementation]["counts"]["vector_passed"],
                1,
            )

        for field, wrong in (
            ("vector_id", "wrong"),
            ("operation", "wrong-operation"),
            ("fixture_profile_version", "99.0.0"),
        ):
            with self.subTest(field=field):
                common_lisp, python = _both_responses(
                    request_id, "probe-operation", input_hex, **fields
                )
                common_lisp[request_id][field] = wrong
                python[request_id][field] = wrong
                comparison = subject._compare(
                    oracle, common_lisp, python
                )
                for implementation in ("common-lisp", "python"):
                    counts = comparison["implementations"][implementation]["counts"]
                    self.assertEqual(counts["response_schema_failures"], 1)
                    self.assertNotIn("vector_passed", counts)

    def test_vector_cannot_pass_with_changed_reencoded_input(self):
        request_id = "vector:probe"
        expected_input = subject.canonical_bytes(subject.cd0.unit()).hex()
        changed_input = subject.canonical_bytes(subject.cd0.boolean(False)).hex()
        expected_result = _success_result("probe")
        oracle = {
            request_id: {
                "kind": "vector",
                "expected_input_hex": expected_input,
                "expected_hex": expected_result,
                "vector_id": "probe",
                "operation": "probe",
                "request_operation": "probe",
            }
        }
        common_lisp, python = _both_responses(
            request_id,
            "probe",
            changed_input,
            actual_canonical_cd0_hex=expected_result,
            vector_id="probe",
            semantic_status="success",
        )
        comparison = subject._compare(
            oracle, common_lisp, python
        )
        for implementation in ("common-lisp", "python"):
            counts = comparison["implementations"][implementation]["counts"]
            self.assertEqual(counts["vector_failed"], 1)
            self.assertNotIn("vector_passed", counts)

    def test_relation_tuple_is_oracle_checked_even_when_both_adapters_agree(self):
        request_id = "relation:synthetic-scope-unknown"
        operation = "scope-relation-table"
        input_hex = subject.canonical_bytes(subject.cd0.unit()).hex()
        oracle = {
            request_id: {
                "kind": "relation",
                "expected_input_hex": input_hex,
                "request_operation": operation,
                "expected_relation": "unknown",
                "expected_semantic_status": "failure",
                "expected_failure": {
                    "category": "relation-undetermined",
                    "code": "ScopeRelationUnknown",
                    "stage": "target-relation",
                },
                "allowed_failure_paths": [["right"]],
            }
        }
        invented = {
            "category": "invalid-input",
            "code": "InventedSharedFailure",
            "stage": "target-relation",
            "path": ["right"],
        }
        common_lisp, python = _both_responses(
            request_id,
            operation,
            input_hex,
            relation="unknown",
            semantic_status="failure",
            failure=invented,
        )
        comparison = subject._compare(oracle, common_lisp, python)
        self.assertEqual(comparison["cross_implementation_mismatches"], [])
        for implementation in ("common-lisp", "python"):
            counts = comparison["implementations"][implementation]["counts"]
            self.assertEqual(counts["relation_failed"], 1)
            self.assertNotIn("relation_passed", counts)

    def test_failure_path_namespace_and_segmentation_are_canonical(self):
        row = next(
            row for row in subject.iter_vectors() if row["vector_id"] == "LCI0-P016"
        )
        decoded = subject.cd0.decode_exact(
            bytes.fromhex(row["expected"]["canonical_cd0_hex"]),
            subject.CD0_BUDGET,
        )
        failure = {
            "category": "target-mismatch",
            "code": "ScopeWideningForbidden",
            "stage": "target-relation",
            "path": ["claim", "location", "scope"],
        }
        response = {
            "semantic_status": "failure",
            "failure": failure,
            "actual_canonical_cd0_hex": subject.canonical_bytes(decoded).hex(),
        }
        self.assertTrue(subject.canonical_report_matches(response))

        path = subject._field_named(decoded, "path")
        mutations = (
            subject.cd0.identifier(
                subject.FIXTURE + ("mneme-proposition", "argument"),
                ("claim",),
            ),
            subject.cd0.identifier(subject.LCI, ("extra", "claim")),
            subject.cd0.identifier(
                ("arbitrary", "unfrozen", "namespace"),
                ("claim",),
            ),
        )
        for first_item in mutations:
            with self.subTest(first_item=first_item):
                mutated_path = subject.cd0.sequence(
                    (first_item, *path.items[1:])
                )
                mutated = subject._replace_named(decoded, "path", mutated_path)
                response["actual_canonical_cd0_hex"] = subject.canonical_bytes(
                    mutated
                ).hex()
                self.assertFalse(subject.canonical_report_matches(response))


class HostileConstructionTests(unittest.TestCase):
    def test_named_mutable_aliases_are_exact_fail_closed_witnesses(self):
        cases = {case["name"]: case for case in subject._hostile_cases()}
        expected = {
            "stable-ref-alias-display-model",
            "stable-ref-alias-bare-filename",
            "stable-ref-alias-mutable-url",
            "stable-ref-alias-latest-case-folded",
            "stable-ref-alias-main-case-folded",
            "stable-ref-alias-production",
            "stable-ref-alias-model-current",
            "stable-ref-alias-package-symbol-spelling",
        }
        self.assertTrue(expected <= set(cases))
        for name in expected:
            self.assertEqual(
                cases[name]["expected_failure"],
                {
                    "category": "reference-refusal",
                    "code": "UnresolvedAlias",
                    "stage": "stable-reference",
                    "path": ["material", "fixture-field:object-id"],
                },
            )

    def test_independent_audit_hostiles_are_closed_determinate_requests(self):
        cases = {case["name"]: case for case in subject._hostile_cases()}
        expected = {
            "project-claim-id-carrier-future-field": {
                "category": "invalid-input",
                "code": "MissingRequiredField",
                "stage": "claim-shape",
                "path": ["identity-policy"],
            },
            "claim-tagged-empty-profile-location": {
                "category": "invalid-input",
                "code": "UnknownField",
                "stage": "profile-location",
                "path": ["location", "profile-location", "kind"],
            },
            "match-target-beta-proposition": {
                "category": "target-mismatch",
                "code": "PropositionMismatch",
                "stage": "target-relation",
                "path": ["claim", "proposition"],
            },
            "match-target-proposition-before-subject-time": {
                "category": "target-mismatch",
                "code": "PropositionMismatch",
                "stage": "target-relation",
                "path": ["claim", "proposition"],
            },
            "match-target-nonmonotone-before-insufficient-coverage": {
                "category": "target-mismatch",
                "code": "ScopeNarrowingNotDeclared",
                "stage": "target-relation",
                "path": ["claim", "location", "scope"],
            },
            "claim-id-equality-rejects-empty-records": {
                "category": "invalid-input",
                "code": "MissingRequiredField",
                "stage": "claim-shape",
                "path": ["kind"],
            },
        }
        self.assertEqual(len(cases), 29)
        for name, failure in expected.items():
            with self.subTest(name=name):
                self.assertEqual(cases[name]["expected_failure"], failure)
                self.assertNotIn(f"hostile:{name}", subject.BLOCKED_HOSTILE_REQUESTS)

        for name in (
            "match-target-beta-proposition",
            "match-target-proposition-before-subject-time",
            "match-target-nonmonotone-before-insufficient-coverage",
        ):
            with self.subTest(carrier=name):
                carrier = subject.cd0.decode_exact(
                    bytes.fromhex(cases[name]["canonical_hex"]), subject.CD0_BUDGET
                )
                self.assertEqual(
                    {key.path for key, _ in carrier.fields},
                    {("target",), ("candidate-claim",)},
                )
                self.assertTrue(
                    all(key.namespace == subject.FIXTURE_FIELD for key, _ in carrier.fields)
                )

    def test_request_census_includes_all_determinate_audit_hostiles(self):
        requests, oracles, counts = subject.build_requests()
        self.assertEqual(counts["hostile_requests_per_implementation"], 29)
        self.assertEqual(counts["total_requests_per_implementation"], 2295)
        self.assertEqual(len(requests), len(oracles), 2295)
        expected = {
            "hostile:project-claim-id-carrier-future-field",
            "hostile:claim-tagged-empty-profile-location",
            "hostile:match-target-beta-proposition",
            "hostile:match-target-proposition-before-subject-time",
            "hostile:match-target-nonmonotone-before-insufficient-coverage",
            "hostile:claim-id-equality-rejects-empty-records",
            "hostile:stable-ref-alias-production",
            "hostile:stable-ref-alias-model-current",
        }
        self.assertTrue(expected <= set(oracles))

    def test_policy_c_is_an_authority_gap_not_an_invented_lci_failure(self):
        cases = {case["name"]: case for case in subject._hostile_cases()}
        policy_c = cases["policy-c-fail-closed"]
        self.assertEqual(
            policy_c["expected_authority_gap"], "unsupported fixture policy"
        )
        self.assertNotIn("expected_failure", policy_c)

        oracle = {
            "kind": "hostile",
            "expected_input_hex": policy_c["canonical_hex"],
            **policy_c,
        }
        response = {
            "protocol_status": "fixture-authority-gap",
            "status": "blocked",
            "authority_gap": "unsupported fixture policy",
            "input_reencoded_canonical_hex": policy_c["canonical_hex"],
        }
        self.assertTrue(subject._valid_authority_gap_response(response, oracle))
        response["failure"] = {
            "category": "invalid-input",
            "code": "UnsupportedFixturePolicy",
        }
        self.assertFalse(subject._valid_authority_gap_response(response, oracle))


if __name__ == "__main__":
    unittest.main()
