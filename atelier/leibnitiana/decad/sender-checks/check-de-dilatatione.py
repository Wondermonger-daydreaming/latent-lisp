#!/usr/bin/env python3
"""Static preflight for de-dilatatione.lisp.

This is deliberately not a Common Lisp runtime.  It checks lexical closure,
required condition/restart mechanisms, record types, and obvious host escape
hatches before Claude Code earns the native SBCL receipt.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path


def lexical_balance(text: str) -> tuple[int, int | None, bool, int]:
    balance = 0
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
        elif pair == "#\\":
            i += 2
            while i < len(text) and not text[i].isspace() and text[i] not in "()":
                i += 1
            continue
        elif ch == "(":
            balance += 1
        elif ch == ")":
            balance -= 1
            if balance < 0 and minimum_line is None:
                minimum_line = line
        i += 1
    return balance, minimum_line, in_string, block_depth


def main() -> int:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "/mnt/data/de-dilatatione.lisp")
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
        "fixity-is-not-eternity": 2,
        "change-is-not-annihilation": 3,
        "ascent-is-not-subtraction": 3,
        "capacity-is-not-communion": 3,
        "growth-needs-two-axes": 2,
        "fulfillment-is-not-closure": 2,
        "standing-laundering": 2,
        "attention-exhausted": 3,
        "supply-attention": 2,
        "finite-prefix-is-not-infinity": 3,
        "theological-image-is-not-evidence": 3,
        "forged-fulfillment-claim": 3,
        "stale-proposal": 3,
        "replay-dilation": 2,
        ":growth-preserved-in-open-fulfillment": 3,
        "de dilatatione complete": 1,
    }
    for marker, minimum_count in required.items():
        actual = lower.count(marker)
        if actual < minimum_count:
            failures.append(
                f"required marker {marker!r}: expected >= {minimum_count}, found {actual}"
            )

    expected_structs = [
        "heart-state",
        "dilation-proposal",
        "dilation-scar",
        "attention-event",
        "dilation-run",
        "growth-horizon",
        "horizon-step",
        "dilation-receipt",
    ]
    for name in expected_structs:
        if not re.search(rf"\(defstruct\s+\({re.escape(name)}\b", lower):
            failures.append(f"missing record type {name}")

    # EVAL-WHEN is required only for loading the shared Atelier root.
    scrubbed = re.sub(r"\(eval-when\b", "(allowed-eval-when", lower)
    forbidden = {
        r"\(eval\b": "raw EVAL",
        r"\(fdefinition\b": "FDEFINITION",
        r"\(symbol-function\b": "SYMBOL-FUNCTION",
        r"\(compile\s+nil": "runtime COMPILE",
        r"\(load\s+[^\n]*\bdilation-proposal": "caller-selected LOAD",
    }
    for pattern, label in forbidden.items():
        if re.search(pattern, scrubbed):
            failures.append(f"forbidden host escape found: {label}")

    if failures:
        print("de-dilatatione static preflight: FAIL")
        for failure in failures:
            print(" -", failure)
        return 1

    print("de-dilatatione static preflight: PASS")
    print("lines:", len(text.splitlines()))
    print("required mechanisms:", len(required), "/", len(required))
    print("record types:", len(expected_structs), "/", len(expected_structs))
    print("parenthesis balance: 0")
    print("host escape scan: clean")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
