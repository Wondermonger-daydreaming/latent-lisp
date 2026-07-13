#!/usr/bin/env python3
"""JSONL machine adapter for the independent Python CD/0 seed.

The adapter is deliberately thin: it translates the integration protocol into
the seed's public fixture, codec, equality, and declared host-import APIs.  It
does not implement datum semantics of its own.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
from typing import Any, Iterable


PROTOCOL = "lisp-plus-cd0-differential/v1"
IMPLEMENTATION = "python"

REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "canonical-datum" / "python"))

import cd0  # noqa: E402  (path is intentionally fixed before import)


def _budget(request: dict[str, Any]) -> cd0.ResourceBudget:
    return cd0.ResourceBudget.from_mapping(
        request["budget"], identifier=request["budget_id"]
    )


def _ok(request_id: str, result: dict[str, Any]) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "implementation": IMPLEMENTATION,
        "request_id": request_id,
        "status": "ok",
        "result": result,
    }


def _failure(request_id: str, failure: cd0.CD0Failure) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "implementation": IMPLEMENTATION,
        "request_id": request_id,
        "status": "failure",
        "failure": failure.as_dict(),
    }


def _datum_result(value: cd0.Datum, budget: cd0.ResourceBudget) -> dict[str, Any]:
    return {
        "canonical_hex": cd0.encode_exact(value, budget).hex(),
        "fixture_ast": cd0.to_fixture_ast(value),
    }


def handle(request: dict[str, Any]) -> dict[str, Any]:
    if request.get("protocol") != PROTOCOL:
        raise ValueError("unsupported or missing protocol")
    request_id = request["request_id"]
    operation = request["op"]
    budget = _budget(request)

    try:
        if operation == "construct-roundtrip":
            constructed = cd0.from_fixture_ast(request["ast"], budget)
            encoded = cd0.encode_exact(constructed, budget)
            decoded = cd0.decode_exact(encoded, budget)
            return _ok(
                request_id,
                {
                    "canonical_hex": encoded.hex(),
                    "fixture_ast": cd0.to_fixture_ast(decoded),
                    "reencoded_hex": cd0.encode_exact(decoded, budget).hex(),
                    "constructed_equal_decoded": cd0.equal_datum(
                        constructed, decoded
                    ),
                },
            )
        if operation == "decode":
            value = cd0.decode_exact(bytes.fromhex(request["input_hex"]), budget)
            return _ok(request_id, _datum_result(value, budget))
        if operation == "decode-probe":
            value = cd0.decode_exact(bytes.fromhex(request["input_hex"]), budget)
            return _ok(
                request_id,
                {"reencoded_hex": cd0.encode_exact(value, budget).hex()},
            )
        if operation == "host-import":
            value = cd0.import_host_descriptor(
                request["host_input"], request["importer"], budget
            )
            return _ok(request_id, _datum_result(value, budget))
        if operation == "equal":
            left = cd0.from_fixture_ast(request["left_ast"], budget)
            right = cd0.from_fixture_ast(request["right_ast"], budget)
            return _ok(
                request_id,
                {
                    "equal": cd0.equal_datum(left, right),
                    "left_hex": cd0.encode_exact(left, budget).hex(),
                    "right_hex": cd0.encode_exact(right, budget).hex(),
                },
            )
        if operation == "fixture-import":
            value = cd0.from_fixture_ast(request["ast"], budget)
            return _ok(request_id, _datum_result(value, budget))
        if operation == "nested-encode":
            depth = request["depth"]
            if type(depth) is not int or depth < 1:
                raise ValueError("nested-encode depth must be a positive integer")
            value: cd0.Datum = cd0.unit()
            for _ in range(depth - 1):
                value = cd0.sequence((value,))
            encoded = cd0.encode_exact(value, budget)
            return _ok(
                request_id,
                {"canonical_hex": encoded.hex(), "datum_depth": depth},
            )
        raise ValueError(f"unsupported operation {operation!r}")
    except cd0.CD0Failure as failure:
        return _failure(request_id, failure)


def read_requests(path: Path) -> Iterable[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as stream:
        for line_number, line in enumerate(stream, 1):
            if not line.strip():
                continue
            value = json.loads(line)
            if type(value) is not dict:
                raise ValueError(f"request line {line_number} is not an object")
            yield value


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("requests", type=Path)
    args = parser.parse_args(argv)
    for request in read_requests(args.requests):
        response = handle(request)
        print(json.dumps(response, sort_keys=True, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:  # protocol/process defects must be unmistakable
        print(f"python adapter fatal: {type(exc).__name__}: {exc}", file=sys.stderr)
        raise
