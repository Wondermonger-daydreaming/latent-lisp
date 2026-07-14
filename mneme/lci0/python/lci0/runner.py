"""Deterministic JSON-lines runner for differential LCI/0 execution.

The runner accepts canonical vector-input CD/0 octets.  It does not open the
fixture vector file and therefore cannot consult a vector expected result.
"""

from __future__ import annotations

import argparse
import json
import sys
from typing import Any, TextIO

import cd0

from .core import CD0_BUDGET
from .model import LCIFailure, scalar
from .vector import datum_native, execute, id_name, record_to_mapping


def _request_failure(code: str, path: tuple[str, ...] = ()) -> dict[str, Any]:
    return {
        "status": "failure",
        "failure": {
            "category": "invalid-input",
            "code": code,
            "stage": "differential-runner",
            "path": list(path),
        },
    }


def run_request(request: Any) -> dict[str, Any]:
    if type(request) is not dict or set(request) != {"input_canonical_hex"}:
        return _request_failure("InvalidRunnerRequest")
    encoded_hex = request["input_canonical_hex"]
    if type(encoded_hex) is not str or len(encoded_hex) % 2 or encoded_hex != encoded_hex.lower():
        return _request_failure("InvalidRunnerHex", ("input_canonical_hex",))
    try:
        encoded = bytes.fromhex(encoded_hex)
    except ValueError:
        return _request_failure("InvalidRunnerHex", ("input_canonical_hex",))
    try:
        document = cd0.decode_exact(encoded, CD0_BUDGET)
        if cd0.encode_exact(document, CD0_BUDGET) != encoded:
            return _request_failure("NoncanonicalRunnerInput", ("input_canonical_hex",))
        envelope = record_to_mapping(document)
        required = {"kind", "schema-version", "vector-id", "operation", "fixture-profile-version", "payload"}
        if set(envelope) != required:
            return _request_failure("InvalidRunnerEnvelope")
        operation = id_name(envelope["operation"]).split("/")[-1]
        vector_id = scalar(envelope["vector-id"])
        fixture_profile_version = scalar(envelope["fixture-profile-version"])
        payload = record_to_mapping(envelope["payload"])
        outcome = execute(operation, payload, vector_id=vector_id)
        result: dict[str, Any] = {
            "vector_id": vector_id,
            "operation": operation,
            "fixture_profile_version": fixture_profile_version,
            "input_canonical_hex": encoded_hex,
            "status": outcome.status,
        }
        if outcome.failure is not None:
            result["failure"] = datum_native(outcome.failure)
        else:
            result["outputs"] = datum_native(outcome.outputs or {})
        return result
    except cd0.CD0Failure as exc:
        return {
            "status": "failure",
            "failure": {
                "category": "cd0",
                "code": exc.code,
                "stage": exc.stage,
                "path": list(exc.path),
            },
        }
    except LCIFailure as exc:
        return {"status": "failure", "failure": datum_native(exc)}


def run_lines(source: TextIO, sink: TextIO) -> int:
    for line_number, line in enumerate(source, 1):
        try:
            request = json.loads(line)
        except json.JSONDecodeError:
            response = _request_failure("InvalidRunnerJSON", (str(line_number),))
        else:
            response = run_request(request)
        sink.write(json.dumps(response, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n")
        sink.flush()
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.parse_args()
    return run_lines(sys.stdin, sys.stdout)


if __name__ == "__main__":
    raise SystemExit(main())
