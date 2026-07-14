from __future__ import annotations

import io
import json
from pathlib import Path
import subprocess
import unittest
from unittest import mock

import cd0

import python_adapter as subject
from protocol import request
from lci0.model import LCIFailure
from lci0.package import iter_vectors
from lci0.vector import record_to_mapping
from response_validation import canonical_report_matches


class FailureEncodingTests(unittest.TestCase):
    def test_preserves_normative_failure_context_instead_of_replacing_it(self):
        witness = cd0.string("input-derived-context")
        failure = LCIFailure(
            "target-mismatch",
            "ScopeNarrowingCoverageInsufficient",
            "target-relation",
            ("boundaries", "coverage-scope"),
            (("fixture-field:actual-coverage-scope", witness),),
        )

        encoded = subject._failure_datum(failure, "LCI0-E5-COVERAGE-INSUFFICIENT")
        context = record_to_mapping(subject.field_by_path(encoded, "context"))

        self.assertEqual(context, {"actual-coverage-scope": witness})
        self.assertNotIn("vector-id", context)

    def test_adds_vector_context_only_when_failure_has_none(self):
        failure = LCIFailure("invalid-input", "UnknownField", "validation")

        encoded = subject._failure_datum(failure, "LCI0-N001")
        context = record_to_mapping(subject.field_by_path(encoded, "context"))

        self.assertEqual(context["vector-id"].value, "LCI0-N001")


class AdapterProtocolTests(unittest.TestCase):
    def test_payload_namespace_failure_is_a_closed_operation_response(self):
        row = next(iter(iter_vectors()))
        datum = cd0.decode_exact(
            bytes.fromhex(row["inputs"]["canonical_cd0_hex"]),
            subject.CD0_BUDGET,
        )
        envelope = record_to_mapping(datum)
        payload = envelope["payload"]
        first_key, first_value = payload.fields[0]
        malformed_payload = cd0.record(
            (
                (cd0.identifier(("foreign", "namespace"), first_key.path), first_value)
                if key == first_key
                else (key, value)
            )
            for key, value in payload.fields
        )
        altered = cd0.record(
            (key, malformed_payload if key.path == ("payload",) else value)
            for key, value in datum.fields
        )

        response = subject.run_request(
            request(
                "property:foreign-payload-field",
                row["operation"],
                subject.canonical_bytes(altered).hex(),
            )
        )

        self.assertEqual(response["protocol_status"], "success")
        self.assertEqual(response["vector_id"], row["vector_id"])
        self.assertEqual(response["semantic_status"], "failure")
        self.assertEqual(
            response["failure"],
            {
                "category": "invalid-input",
                "code": "UnknownField",
                "stage": "fixture-vector-input",
                "path": [],
            },
        )
        self.assertTrue(canonical_report_matches(response))

    def test_echoes_fixture_profile_on_valid_requests(self):
        encoded = subject.canonical_bytes(cd0.unit()).hex()
        response = subject.run_request(
            request("doc:unit", "document-roundtrip", encoded)
        )
        self.assertEqual(
            response["fixture_profile_version"], subject.FIXTURE_PROFILE_VERSION
        )

    def test_policy_c_is_a_closed_non_lci_authority_gap(self):
        carrier = subject._fixture_record(
            {
                "policy": subject._identifier(
                    subject.FIXTURE, "policy-name", "policy-c"
                ),
                "target-relation": subject._fixture_record(
                    {
                        "kind": subject._identifier(
                            subject.FIXTURE, "tag", "target-relation-result"
                        ),
                        "schema-version": cd0.integer(0),
                        "status": subject._identifier(
                            subject.FIXTURE, "result-status", "success"
                        ),
                        "relation": subject._identifier(
                            subject.RELATION, "exact-target"
                        ),
                    }
                ),
            }
        )
        encoded = subject.canonical_bytes(carrier).hex()
        response = subject.run_request(
            request(
                "hostile:policy-c-fail-closed",
                "hostile-evaluate-policy-c",
                encoded,
            )
        )
        self.assertEqual(response["protocol_status"], "fixture-authority-gap")
        self.assertEqual(response["status"], "blocked")
        self.assertEqual(response["authority_gap"], "unsupported fixture policy")
        self.assertNotIn("failure", response)
        self.assertNotIn("semantic_status", response)
        self.assertNotIn("actual_canonical_cd0_hex", response)

    def test_adapter_defect_does_not_disclose_host_exception_prose(self):
        encoded = subject.canonical_bytes(cd0.unit()).hex()
        with mock.patch.object(
            subject, "canonical_bytes", side_effect=RuntimeError("secret host prose")
        ):
            response = subject.run_request(
                request("doc:defect", "document-roundtrip", encoded)
            )
        self.assertEqual(
            response["protocol_failure"],
            {"code": "PythonAdapterDefect", "path": []},
        )
        self.assertNotIn("host_exception_text", response["protocol_failure"])
        self.assertNotIn("host_exception_type", response["protocol_failure"])

    def test_duplicate_request_members_fail_before_protocol_validation(self):
        encoded = subject.canonical_bytes(cd0.unit()).hex()
        valid = request("doc:duplicate", "document-roundtrip", encoded)
        serialized = json.dumps(valid, sort_keys=True)
        source = io.StringIO('{"protocol":"WRONG",' + serialized[1:] + "\n")
        sink = io.StringIO()
        self.assertEqual(subject.run_lines(source, sink), 0)
        response = json.loads(sink.getvalue())
        self.assertEqual(response["protocol_status"], "failure")
        self.assertEqual(
            response["protocol_failure"]["code"], "InvalidDifferentialRequest"
        )

    def test_policy_c_operation_rejects_nearby_policy_carrier(self):
        carrier = subject._fixture_record(
            {
                "policy": subject._identifier(
                    subject.FIXTURE, "policy-name", "policy-d"
                ),
                "target-relation": subject._fixture_record(
                    {
                        "kind": subject._identifier(
                            subject.FIXTURE, "tag", "target-relation-result"
                        ),
                        "schema-version": cd0.integer(0),
                        "status": subject._identifier(
                            subject.FIXTURE, "result-status", "success"
                        ),
                        "relation": subject._identifier(
                            subject.RELATION, "exact-target"
                        ),
                    }
                ),
            }
        )
        response = subject.run_request(
            request(
                "hostile:nearby-policy",
                "hostile-evaluate-policy-c",
                subject.canonical_bytes(carrier).hex(),
            )
        )
        self.assertEqual(response["protocol_status"], "failure")
        self.assertEqual(
            response["protocol_failure"],
            {"code": "InvalidPolicyCCarrier", "path": ["operation"]},
        )
        self.assertNotIn("authority_gap", response)

    def test_common_lisp_adapter_rejects_nearby_carrier_and_duplicate_request(self):
        carrier = subject._fixture_record(
            {
                "policy": subject._identifier(
                    subject.FIXTURE, "policy-name", "policy-d"
                ),
                "target-relation": subject._fixture_record(
                    {
                        "kind": subject._identifier(
                            subject.FIXTURE, "tag", "target-relation-result"
                        ),
                        "schema-version": cd0.integer(0),
                        "status": subject._identifier(
                            subject.FIXTURE, "result-status", "success"
                        ),
                        "relation": subject._identifier(
                            subject.RELATION, "exact-target"
                        ),
                    }
                ),
            }
        )
        nearby = request(
            "hostile:cl-nearby-policy",
            "hostile-evaluate-policy-c",
            subject.canonical_bytes(carrier).hex(),
        )
        duplicate_base = request(
            "doc:cl-duplicate", "document-roundtrip",
            subject.canonical_bytes(cd0.unit()).hex(),
        )
        duplicate_serialized = json.dumps(duplicate_base, sort_keys=True)
        duplicate = '{"protocol":"WRONG",' + duplicate_serialized[1:]
        stdin = json.dumps(nearby, sort_keys=True) + "\n" + duplicate + "\n"
        root = Path(__file__).resolve().parents[3]
        process = subprocess.run(
            [
                "sbcl", "--noinform", "--disable-debugger", "--script",
                str(root / "mneme/lci0/differential/common_lisp_adapter.lisp"),
            ],
            cwd=root,
            input=stdin,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False,
        )
        self.assertEqual(process.returncode, 0, process.stderr)
        responses = [json.loads(line) for line in process.stdout.splitlines()]
        self.assertEqual(len(responses), 2)
        self.assertEqual(
            responses[0]["protocol_failure"],
            {"code": "InvalidPolicyCCarrier", "path": ["operation"]},
        )
        self.assertNotIn("authority_gap", responses[0])
        self.assertEqual(
            responses[1]["protocol_failure"]["code"],
            "InvalidRunnerJSON",
        )


if __name__ == "__main__":
    unittest.main()
