#!/usr/bin/env python3
"""Static preflight for de-resonantia.lisp.

This is not a Lisp runtime. It checks source closure, required mechanisms, the
adversarial gates promised by the relay, and obvious host escape hatches.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path


def lexical_balance(text: str) -> tuple[int, int | None, bool, int]:
    balance = 0
    minimum = 0
    minimum_line: int | None = None
    line = 1
    in_string = False
    escaped = False
    line_comment = False
    block_depth = 0
    i = 0
    while i < len(text):
        ch = text[i]
        pair = text[i:i + 2]
        if ch == "\n":
            line += 1
            line_comment = False
            i += 1
            continue
        if line_comment:
            i += 1
            continue
        if block_depth:
            if pair == "#|":
                block_depth += 1
                i += 2
            elif pair == "|#":
                block_depth -= 1
                i += 2
            else:
                i += 1
            continue
        if in_string:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            i += 1
            continue
        if pair == "#|":
            block_depth = 1
            i += 2
            continue
        if ch == ";":
            line_comment = True
        elif ch == '"':
            in_string = True
        elif ch == "(":
            balance += 1
        elif ch == ")":
            balance -= 1
            if balance < minimum:
                minimum = balance
                minimum_line = line
        i += 1
    return balance, minimum_line, in_string, block_depth


def main() -> int:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "/mnt/data/de-resonantia.lisp")
    text = path.read_text(encoding="utf-8")
    lower = text.lower()
    failures: list[str] = []

    balance, minimum_line, in_string, block_depth = lexical_balance(text)
    if balance != 0:
        failures.append(f"parenthesis balance is {balance}")
    if minimum_line is not None:
        failures.append(f"parenthesis balance became negative at line {minimum_line}")
    if in_string:
        failures.append("unterminated string")
    if block_depth:
        failures.append(f"unterminated block comment depth {block_depth}")

    required = {
        "resonance-budget-exhausted": 3,
        "supply-energy": 2,
        "resemblance-is-not-transmission": 3,
        "transmission-is-not-entrainment": 3,
        "entrainment-is-not-identity": 3,
        "influence-is-not-inheritance": 3,
        "inheritance-is-not-authority": 3,
        "inheritance-is-not-verification": 3,
        "correlation-is-not-lineage": 3,
        "stale-resonance-plan": 3,
        "forged-unity-claim": 3,
        "replay-resonance": 2,
        ":resonance-without-identity": 3,
        "de resonantia complete": 1,
    }
    for marker, minimum_count in required.items():
        actual = lower.count(marker)
        if actual < minimum_count:
            failures.append(
                f"required marker {marker!r}: expected >= {minimum_count}, found {actual}"
            )

    # EVAL-WHEN is required for the root load; raw EVAL and caller-selected
    # function lookup are not part of this instrument.
    scrubbed = re.sub(r"\(eval-when\b", "(allowed-eval-when", lower)
    forbidden = {
        r"\(eval\b": "raw EVAL",
        r"\(fdefinition\b": "FDEFINITION",
        r"\(symbol-function\b": "SYMBOL-FUNCTION",
        r"\(compile\s+nil": "runtime COMPILE",
    }
    for pattern, label in forbidden.items():
        if re.search(pattern, scrubbed):
            failures.append(f"forbidden host escape found: {label}")

    expected_structs = [
        "resonant-node", "coupling", "pulse", "resonance-response",
        "resonance-plan", "resonance-run", "resonance-bequest",
        "resonant-descendant", "resonance-receipt",
    ]
    for name in expected_structs:
        if not re.search(rf"\(defstruct\s+\({re.escape(name)}\b", lower):
            failures.append(f"missing record type {name}")

    if failures:
        print("de-resonantia static preflight: FAIL")
        for failure in failures:
            print(" -", failure)
        return 1

    print("de-resonantia static preflight: PASS")
    print("lines:", len(text.splitlines()))
    print("required mechanisms:", len(required), "/", len(required))
    print("record types:", len(expected_structs), "/", len(expected_structs))
    print("parenthesis balance: 0")
    print("host escape scan: clean")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
