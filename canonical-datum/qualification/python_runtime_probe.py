#!/usr/bin/env python3
"""Python host-boundary probes for the CD/0 qualification coordinator."""

from __future__ import annotations

from dataclasses import replace
import builtins
import json
import os
from pathlib import Path
import pickle
import socket
import sys
from unittest import mock

import cd0


REPO_ROOT = Path(__file__).resolve().parents[2]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def load_budget() -> cd0.ResourceBudget:
    document = json.loads(
        (REPO_ROOT / "canonical-datum" / "vectors" / "cd0-budgets.json").read_text(
            encoding="utf-8"
        )
    )
    return cd0.ResourceBudget.from_mapping(
        document["budgets"]["cd0-conformance-default"], identifier="qualification-runtime"
    )


def id_value(namespace: tuple[str, ...], name: str) -> cd0.Identifier:
    return cd0.identifier(namespace, (name,))


def expect_failure(callable_, triple: tuple[str, str, str]) -> None:
    try:
        callable_()
    except cd0.CD0Failure as failure:
        require(failure.triple == triple, f"failure mismatch: {failure.triple} != {triple}")
    else:
        raise AssertionError(f"expected failure {triple}")


def main() -> int:
    budget = load_budget()
    mode = os.environ.get("CD0_QUALIFICATION_MODE", "default")
    deep_count = 1000 if mode == "small" else 5000
    mutation_probes = 0

    raw_bytes = bytearray(b"abc")
    bytes_value = cd0.byte_string(memoryview(raw_bytes))
    raw_sequence = [cd0.string("left")]
    sequence_value = cd0.sequence(raw_sequence)
    raw_namespace = ["ns"]
    raw_path = ["name"]
    identifier_value = cd0.identifier(raw_namespace, raw_path)
    raw_fields = [(identifier_value, sequence_value)]
    record_value = cd0.record(raw_fields)
    baselines = {
        "bytes": cd0.encode_exact(bytes_value, budget),
        "sequence": cd0.encode_exact(sequence_value, budget),
        "identifier": cd0.encode_exact(identifier_value, budget),
        "record": cd0.encode_exact(record_value, budget),
    }
    raw_bytes[:] = b"xyz"
    mutation_probes += 1
    raw_sequence[0] = cd0.string("right")
    mutation_probes += 1
    raw_namespace[0] = "changed"
    mutation_probes += 1
    raw_path.append("changed")
    mutation_probes += 1
    raw_fields.clear()
    mutation_probes += 1
    require(cd0.encode_exact(bytes_value, budget) == baselines["bytes"], "bytes alias retained")
    require(
        cd0.encode_exact(sequence_value, budget) == baselines["sequence"],
        "sequence alias retained",
    )
    require(
        cd0.encode_exact(identifier_value, budget) == baselines["identifier"],
        "identifier alias retained",
    )
    require(cd0.encode_exact(record_value, budget) == baselines["record"], "record alias retained")

    mutable_document = bytearray.fromhex("4c504344002103616263")
    decoded_bytes = cd0.decode_exact(mutable_document, budget)
    decoded_baseline = cd0.encode_exact(decoded_bytes, budget)
    mutable_document[:] = b"\x00" * len(mutable_document)
    mutation_probes += 1
    require(cd0.encode_exact(decoded_bytes, budget) == decoded_baseline, "decoder input alias retained")

    exported = cd0.to_fixture_ast(record_value)
    exported["fields"].clear()
    mutation_probes += 1
    require(cd0.encode_exact(record_value, budget) == baselines["record"], "AST view alias retained")

    source = {("alpha", 1), ("beta", 2), ("gamma", 3)}
    ambient_record = cd0.record(
        (id_value(("ambient",), name), cd0.integer(value)) for name, value in source
    )
    identity_hex = cd0.encode_exact(ambient_record, budget).hex()
    first = {"t": "int", "v": "7"}
    second = {"v": "7", "t": "int"}
    require(
        cd0.encode_exact(cd0.from_fixture_ast(first, budget), budget)
        == cd0.encode_exact(cd0.from_fixture_ast(second, budget), budget),
        "dictionary insertion order affected fixture identity",
    )

    guard = sys.get_int_max_str_digits() if hasattr(sys, "get_int_max_str_digits") else 0
    huge_ast = {"t": "int", "v": "1" * 641}
    huge_budget = replace(budget, max_varint_octets=512, identifier="qualification-decimal-guard")
    huge = cd0.from_fixture_ast(huge_ast, huge_budget)
    require(cd0.to_fixture_ast(huge) == huge_ast, "ambient decimal guard affected fixture conversion")
    require(
        cd0.equal_datum(
            huge,
            cd0.decode_exact(cd0.encode_exact(huge, huge_budget), huge_budget),
        ),
        "large integer roundtrip",
    )

    cyclic: dict = {"t": "seq"}
    cyclic["items"] = [cyclic]
    expect_failure(
        lambda: cd0.from_fixture_ast(cyclic, budget),
        ("UnsupportedHostInput", "CyclicHostInput", "host-import"),
    )
    shared = {"t": "string", "utf8_hex": "736861726564"}
    shared_value = cd0.from_fixture_ast({"t": "seq", "items": [shared, shared]}, budget)
    require(
        cd0.equal_datum(shared_value.items[0], shared_value.items[1]),
        "shared acyclic structure changed abstract values",
    )

    left_namespace = cd0.identifier(("a",), ("b",))
    right_namespace = cd0.identifier((), ("a", "b"))
    require(not cd0.equal_datum(left_namespace, right_namespace), "namespace allocation collapsed")
    require(
        cd0.encode_exact(left_namespace, budget) != cd0.encode_exact(right_namespace, budget),
        "namespace allocation bytes collapsed",
    )

    activation_calls = 0

    def activated(*args, **kwargs):
        nonlocal activation_calls
        activation_calls += 1
        raise AssertionError("inert decode invoked ambient activation surface")

    labels = ("capability", "warrant", "claim", "certificate", "receipt", "authority")
    privileged_record = cd0.record(
        (id_value(("profile",), label), cd0.string("inert")) for label in labels
    )
    privileged_document = cd0.encode_exact(privileged_record, budget)
    with (
        mock.patch.object(builtins, "eval", side_effect=activated),
        mock.patch.object(builtins, "open", side_effect=activated),
        mock.patch.object(pickle, "loads", side_effect=activated),
        mock.patch.object(socket, "socket", side_effect=activated),
    ):
        inert = cd0.decode_exact(privileged_document, budget)
    require(type(inert) is cd0.Record, "privileged-looking bytes did not decode to inert Record")
    require(activation_calls == 0, "privileged-looking record activated a hook")

    left: cd0.Datum = cd0.unit()
    right: cd0.Datum = cd0.unit()
    unequal: cd0.Datum = cd0.boolean(False)
    for _ in range(deep_count):
        left = cd0.sequence((left,))
        right = cd0.sequence((right,))
        unequal = cd0.sequence((unequal,))
    require(cd0.equal_datum(left, right), "deep iterative equality rejected equal values")
    require(not cd0.equal_datum(left, unequal), "deep iterative equality accepted unequal values")

    too_short = replace(budget, max_input_octets=5, identifier="qualification-input-5")
    expect_failure(
        lambda: cd0.decode_exact(bytes.fromhex("4c5043440000"), too_short),
        ("ResourceRefusal", "ExcessiveInputLength", "input-budget"),
    )
    require(type(cd0.decode_exact(bytes.fromhex("4c5043440000"), budget)) is cd0.Unit, "resource retry")

    result = {
        "status": "PASS",
        "implementation": "python",
        "identity_hex": identity_hex,
        "mutation_probes": mutation_probes,
        "decimal_guard": guard,
        "dictionary_order_variants": 2,
        "host_cycle_refusals": 1,
        "shared_acyclic_acceptances": 1,
        "namespace_distinctions": 1,
        "inert_records": 1,
        "activation_calls": activation_calls,
        "deep_equality_depth": deep_count,
        "resource_refusal_retries": 1,
    }
    print(json.dumps(result, sort_keys=True, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
