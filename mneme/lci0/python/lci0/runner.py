"""Deterministic JSON-lines runner for differential LCI/0 execution.

The runner accepts the closed integration request protocol and canonical CD/0
octets.  It never opens the fixture vector file or consults expected results.
"""

from __future__ import annotations

import argparse
import json
import sys
from typing import Any, TextIO

import cd0

from . import closure
from .core import CD0_BUDGET, evaluate_policy
from .model import FixtureAuthorityGap, LCIFailure, RelationResult, field_by_path, scalar
from .protocol import (
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
    ProtocolError,
    validate_request,
)
from .vector import datum_native, execute, id_name, record_to_mapping


def _protocol_failure(raw: Any, code: str, path: tuple[str, ...] = ()) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": raw.get("request_id", "") if type(raw) is dict else "",
        "implementation": "python",
        "protocol_status": "failure",
        "protocol_failure": {
            "code": code,
            "path": list(path),
        },
    }


def _base_response(request: dict[str, Any], reencoded_hex: str) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request["request_id"],
        "operation": request["operation"],
        "fixture_profile_version": request["fixture_profile_version"],
        "implementation": "python",
        "implementation_seed_commit": PYTHON_SEED_COMMIT,
        "implementation_seed_tree": PYTHON_SEED_TREE,
        "protocol_status": "success",
        "input_reencoded_canonical_hex": reencoded_hex,
    }


def run_request(raw: Any) -> dict[str, Any]:
    try:
        request = validate_request(raw)
    except ProtocolError as exc:
        return _protocol_failure(raw, exc.code, exc.path)

    encoded = bytes.fromhex(request["input_canonical_hex"])
    try:
        document = cd0.decode_exact(encoded, CD0_BUDGET)
    except cd0.CD0Failure as exc:
        return _protocol_failure(raw, exc.code, tuple(str(item) for item in exc.path))
    reencoded = cd0.encode_exact(document, CD0_BUDGET)
    if reencoded != encoded:
        return _protocol_failure(raw, "NoncanonicalDifferentialInput", ("input_canonical_hex",))

    response = _base_response(request, reencoded.hex())
    operation = request["operation"]

    if operation == "hostile-evaluate-policy-c":
        try:
            fields = record_to_mapping(document)
            policy_name = id_name(fields["policy"]).split("/")[-1]
            relation_name = id_name(field_by_path(fields["target-relation"], "relation")).split("/")[-1]
        except (KeyError, LCIFailure, FixtureAuthorityGap):
            response["protocol_status"] = "failure"
            response["protocol_failure"] = {
                "code": "InvalidHostilePolicyFixture",
                "path": ["input_canonical_hex"],
            }
            return response
        try:
            evaluate_policy(policy_name, RelationResult(relation_name))
        except FixtureAuthorityGap:
            return {
                **response,
                "protocol_status": "fixture-authority-gap",
                "status": "blocked",
                "authority_gap": "unsupported fixture policy",
            }
        except LCIFailure:
            response["protocol_status"] = "failure"
            response["protocol_failure"] = {
                "code": "InvalidHostilePolicyFixture",
                "path": ["input_canonical_hex"],
            }
            return response
        response["status"] = "success"
        return response

    if operation in closure.DIRECT_DOCUMENT_OPERATIONS:
        # Authorial-closure direct-document surfaces (LCI0-AC-002 relation
        # tables; LCI0-AC-007 hostile validations).  Structural failures
        # only; a fixture authority gap stays a closed protocol failure.
        try:
            semantic = closure.execute_direct(operation, document)
        except LCIFailure as exc:
            return {
                **response,
                "status": "failure",
                "failure": datum_native(exc),
            }
        except FixtureAuthorityGap:
            response["protocol_status"] = "failure"
            response["protocol_failure"] = {"code": "FixtureAuthorityGap", "path": []}
            return response
        return {**response, "status": semantic["status"], "closure_result": semantic}

    try:
        envelope = record_to_mapping(document)
        required = {"kind", "schema-version", "vector-id", "operation", "fixture-profile-version", "payload"}
        if set(envelope) != required:
            raise ProtocolError("InvalidFixtureVectorEnvelope", ("input_canonical_hex",))
        embedded_operation = id_name(envelope["operation"]).split("/")[-1]
        if embedded_operation != operation:
            raise ProtocolError("DifferentialOperationMismatch", ("operation",))
        vector_id = scalar(envelope["vector-id"])
        if scalar(envelope["fixture-profile-version"]) != FIXTURE_PROFILE_VERSION:
            raise ProtocolError("EmbeddedFixtureProfileMismatch", ("input_canonical_hex",))
        if type(vector_id) is not str:
            raise ProtocolError("InvalidFixtureVectorEnvelope", ("input_canonical_hex",))
        payload_document = envelope["payload"]
    except ProtocolError as exc:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {"code": exc.code, "path": list(exc.path)}
        return response
    except (FixtureAuthorityGap, LCIFailure):
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {
            "code": "InvalidFixtureVectorEnvelope",
            "path": ["input_canonical_hex"],
        }
        return response

    try:
        payload = record_to_mapping(payload_document)
    except LCIFailure as exc:
        return {
            **response,
            "vector_id": vector_id,
            "status": "failure",
            "failure": datum_native(exc),
        }
    except FixtureAuthorityGap:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {
            "code": "InvalidFixtureVectorEnvelope",
            "path": ["input_canonical_hex"],
        }
        return response

    try:
        outcome = execute(operation, payload, vector_id=vector_id)
        result = {**response, "vector_id": vector_id, "status": outcome.status}
        if outcome.failure is not None:
            result["failure"] = datum_native(outcome.failure)
        else:
            result["outputs"] = datum_native(outcome.outputs or {})
        return result
    except FixtureAuthorityGap:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {"code": "FixtureAuthorityGap", "path": []}
        return response
    except LCIFailure as exc:
        return {
            **response,
            "vector_id": vector_id,
            "status": "failure",
            "failure": datum_native(exc),
        }


def run_lines(source: TextIO, sink: TextIO) -> int:
    for line_number, line in enumerate(source, 1):
        try:
            raw = json.loads(line)
        except json.JSONDecodeError:
            raw = {"request_id": f"invalid-json-line-{line_number}"}
            response = _protocol_failure(raw, "InvalidJSON", (str(line_number),))
        else:
            response = run_request(raw)
        sink.write(json.dumps(response, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n")
        sink.flush()
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.parse_args()
    return run_lines(sys.stdin, sys.stdout)


if __name__ == "__main__":
    raise SystemExit(main())
