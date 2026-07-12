#!/usr/bin/env python3
"""Static preflight for de-concordia.lisp.

This is deliberately not a substitute for SBCL execution.  It checks lexical
closure, required mechanisms, expected adversarial gates, and obvious host
escape hatches before the native receiving ritual.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

PATH = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("de-concordia.lisp")
TEXT = PATH.read_text(encoding="utf-8")


def lexical_check(text: str) -> None:
    stack: list[tuple[int, int]] = []
    state = "code"
    block_depth = 0
    line = 1
    col = 0
    i = 0
    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""
        if ch == "\n":
            line += 1
            col = 0
        else:
            col += 1
        if state == "code":
            if ch == ";":
                state = "line-comment"
            elif ch == '"':
                state = "string"
            elif ch == "#" and nxt == "|":
                state = "block-comment"
                block_depth = 1
                i += 1
                col += 1
            elif ch == "(":
                stack.append((line, col))
            elif ch == ")":
                if not stack:
                    raise AssertionError(f"extra ')' at {line}:{col}")
                stack.pop()
        elif state == "line-comment":
            if ch == "\n":
                state = "code"
        elif state == "string":
            if ch == "\\":
                i += 1
                col += 1
            elif ch == '"':
                state = "code"
        elif state == "block-comment":
            if ch == "#" and nxt == "|":
                block_depth += 1
                i += 1
                col += 1
            elif ch == "|" and nxt == "#":
                block_depth -= 1
                i += 1
                col += 1
                if block_depth == 0:
                    state = "code"
        i += 1
    assert state == "code", f"unterminated lexical state: {state}"
    assert not stack, f"unclosed '(' at {stack[-1]}"


REQUIRED = [
    "de-concordia",
    "+woolf-reading-script+",
    ":sensual",
    ":sympathetic",
    ":kinetic",
    ":concordant",
    "image-is-not-world",
    "sympathy-is-not-identity",
    "sympathy-is-not-obedience",
    "movement-is-not-combination",
    "aggregation-is-not-concord",
    "support-is-not-identity",
    "belief-thread-broken",
    "poetic-belief-is-not-evidence",
    "attunement-exhausted",
    "supply-attunement",
    "reader-procedure-unavailable",
    "forged-belief-claim",
    ":world-sustained-by-concord",
]

RECORDS = [
    "defstruct (poem-world",
    "defstruct (reading-plan",
    "defstruct (faculty-event",
    "defstruct (attunement-event",
    "defstruct (misreading-scar",
    "defstruct (reading-run",
    "defstruct (concord-receipt",
]

FORBIDDEN = [
    r"\(\s*eval\s",
    r"\(\s*funcall\s+\(\s*fdefinition",
    r"\(\s*compile\s",
]


def main() -> None:
    lexical_check(TEXT)
    lowered = TEXT.lower()
    missing = [item for item in REQUIRED if item.lower() not in lowered]
    missing_records = [item for item in RECORDS if item.lower() not in lowered]
    forbidden_hits = [pattern for pattern in FORBIDDEN if re.search(pattern, TEXT, re.I)]
    assert not missing, f"missing required mechanisms: {missing}"
    assert not missing_records, f"missing record types: {missing_records}"
    assert not forbidden_hits, f"forbidden host escapes found: {forbidden_hits}"
    assert TEXT.count("(expect-condition ") >= 6, "too few biting adversarial gates"
    assert "(demonstrate)" in TEXT, "specimen is not self-executing"
    print("lexical delimiter/string/comment closure: PASS")
    print(f"required mechanisms: {len(REQUIRED)}/{len(REQUIRED)}")
    print(f"record types: {len(RECORDS)}/{len(RECORDS)}")
    print("host escape scan: PASS")
    print("self-executing exhibit: PASS")
    print(f"lines: {len(TEXT.splitlines())}")


if __name__ == "__main__":
    main()
