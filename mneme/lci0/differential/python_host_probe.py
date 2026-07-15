"""Language-native Python ambient-state and mutation probe for LCI/0.

This is intentionally a small projection probe, not a second fixture runner.
It loads the frozen fixture before making filesystem and network entry points
unavailable, then proves that projection of independently allocated equal
values is stable after source-buffer mutation.
"""

from __future__ import annotations

import argparse
import builtins
from contextlib import ExitStack
import hashlib
import io
import json
import locale
import os
from pathlib import Path
import random
import socket
import time
from unittest.mock import patch

import cd0

from lci0.adapter import FixtureAdapterFailure, from_package_json
from lci0.core import CD0_BUDGET, canonical_bytes, project_claim_id
from lci0.package import fixture_datum


def _reallocate(value: cd0.Datum, rng: random.Random) -> cd0.Datum:
    if type(value) is cd0.Unit:
        return cd0.unit()
    if type(value) is cd0.Boolean:
        return cd0.boolean(value.value)
    if type(value) is cd0.Integer:
        return cd0.integer(value.value)
    if type(value) is cd0.Rational:
        return cd0.rational(value.numerator, value.denominator)
    if type(value) is cd0.String:
        return cd0.string((" " + value.value)[1:])
    if type(value) is cd0.ByteString:
        return cd0.byte_string(bytes(bytearray(value.value)))
    if type(value) is cd0.Identifier:
        return cd0.identifier(tuple(value.namespace), tuple(value.path))
    if type(value) is cd0.Sequence:
        return cd0.sequence(_reallocate(item, rng) for item in value.items)
    if type(value) is cd0.Record:
        fields = [
            (_reallocate(key, rng), _reallocate(item, rng))
            for key, item in value.fields
        ]
        rng.shuffle(fields)
        return cd0.record(fields)
    raise TypeError(type(value))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--seed", type=int, required=True)
    parser.add_argument("--cases", type=int, required=True)
    arguments = parser.parse_args()

    # Fixture loading is setup, not projection.  Denial begins after the exact
    # datum has been materialized so the probe distinguishes package access
    # from the pure LCI operation under test.
    envelope = fixture_datum("claim-id.file-alpha-neutral")
    source = cd0.record(
        (key, value)
        for key, value in envelope.fields
        if key.path in {
            ("identity-policy",), ("claim-profile",), ("proposition",),
            ("location",),
        }
    )
    if len(source.fields) != 4:
        raise AssertionError("projection input is not the exact four-field core")
    expected = project_claim_id(source).canonical_bytes
    rng = random.Random(arguments.seed)
    observed: list[str] = []

    denied = AssertionError("ambient I/O consulted")
    denial_targets = (
        "builtins.open", "io.open", "os.open", "os.stat", "os.listdir",
        "os.scandir", "os.access", "pathlib.Path.open", "pathlib.Path.stat",
        "pathlib.Path.exists", "pathlib.Path.read_bytes", "pathlib.Path.read_text",
        "pathlib.Path.write_bytes", "pathlib.Path.write_text", "socket.socket",
        "socket.create_connection", "socket.getaddrinfo", "socket.gethostbyname",
    )
    with ExitStack() as stack:
        for target in denial_targets:
            stack.enter_context(patch(target, side_effect=denied))
        stack.enter_context(patch("time.time", return_value=4_294_967_295.0))
        stack.enter_context(patch("time.monotonic", return_value=1_234_567.0))

        # Prove that representative entry points are actually denied.  Imports
        # and object construction occurred before the denial boundary.
        denial_self_tests = (
            lambda: builtins.open("/definitely-unavailable-lci0", "rb"),
            lambda: io.open("/definitely-unavailable-lci0", "rb"),
            lambda: os.open("/definitely-unavailable-lci0", os.O_RDONLY),
            lambda: os.stat("/definitely-unavailable-lci0"),
            lambda: Path("/definitely-unavailable-lci0").read_bytes(),
            lambda: socket.socket(),
            lambda: socket.getaddrinfo("invalid.example", 443),
            lambda: socket.create_connection(("invalid.example", 443)),
        )
        denial_checks = 0
        for check in denial_self_tests:
            try:
                check()
            except AssertionError as exc:
                if exc is not denied:
                    raise
                denial_checks += 1
            else:
                raise AssertionError("ambient denial self-test did not raise")
        if time.time() != 4_294_967_295.0 or time.monotonic() != 1_234_567.0:
            raise AssertionError("ambient clock patch is inactive")

        rational_adapter_results: list[str] = []
        for value in (
            {"t": "rat", "num": "1", "den": "2"},
            {"t": "rat", "num": "2", "den": "4"},
            {"t": "rat", "num": "1", "den": "-2"},
            {"t": "rat", "num": "0", "den": "2"},
            {"t": "rat", "num": "1", "den": "1"},
        ):
            try:
                from_package_json(value, CD0_BUDGET)
            except FixtureAdapterFailure as exc:
                rational_adapter_results.append(exc.code)
            else:
                rational_adapter_results.append("accepted")

        for _ in range(arguments.cases):
            allocated = _reallocate(source, rng)
            mutable = bytearray(canonical_bytes(allocated))
            retained = cd0.decode_exact(mutable, CD0_BUDGET)
            before = project_claim_id(retained).canonical_bytes
            if mutable:
                mutable[rng.randrange(len(mutable))] ^= 1
            after = project_claim_id(retained).canonical_bytes
            if before != expected or after != expected:
                raise AssertionError("projection changed under allocation/source mutation")
            observed.append(hashlib.sha256(after).hexdigest())

    result = {
        "cases": arguments.cases,
        "denial_entry_points": list(denial_targets),
        "denial_self_tests": denial_checks,
        "filesystem_denial": "open/io.open/os.open/stat/list/access/pathlib patched after fixture setup",
        "hash_seed": os.environ.get("PYTHONHASHSEED"),
        "locale": locale.setlocale(locale.LC_ALL, ""),
        "network_denial": "socket/socket helpers/name resolution patched after fixture setup",
        "profile": os.environ.get("LCI0_HOST_PROFILE", "unspecified"),
        "projection_sha256": hashlib.sha256(expected).hexdigest(),
        "rational_adapter_results": rational_adapter_results,
        "seed": arguments.seed,
        "unique_projection_hashes": len(set(observed)),
        "wall_clock": "time.time and time.monotonic patched",
    }
    print(json.dumps(result, sort_keys=True, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
