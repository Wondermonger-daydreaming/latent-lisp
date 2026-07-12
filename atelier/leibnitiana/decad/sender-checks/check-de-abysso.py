#!/usr/bin/env python3
"""Static preflight for de-abysso.lisp.

This is deliberately not a Common Lisp runtime. It checks lexical closure,
required mechanisms, and a few forbidden escape hatches before SBCL receives
the specimen.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

PATH = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("de-abysso.lisp")
text = PATH.read_text(encoding="utf-8")


def lexical_scan(source: str) -> None:
    stack: list[tuple[int, int]] = []
    i = 0
    line = 1
    col = 0
    in_string = False
    escaped = False
    block_depth = 0
    while i < len(source):
        ch = source[i]
        col += 1
        if ch == "\n":
            line += 1
            col = 0
        if block_depth:
            if source.startswith("#|", i):
                block_depth += 1
                i += 2
                continue
            if source.startswith("|#", i):
                block_depth -= 1
                i += 2
                continue
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
        if source.startswith("#|", i):
            block_depth = 1
            i += 2
            continue
        if ch == ";":
            newline = source.find("\n", i)
            if newline == -1:
                break
            i = newline
            continue
        if ch == '"':
            in_string = True
        elif ch == "(":
            stack.append((line, col))
        elif ch == ")":
            if not stack:
                raise AssertionError(f"extra close parenthesis at {line}:{col}")
            stack.pop()
        i += 1
    assert not in_string, "unterminated string"
    assert block_depth == 0, "unterminated block comment"
    assert not stack, f"unclosed parenthesis opened at {stack[-1]}"


lexical_scan(text)

required = [
    "de-abysso.lisp",
    "(define-condition descent-budget-exhausted",
    "record-timeout",
    "supply-budget",
    "(define-condition refusal-is-not-absence",
    "(define-condition timeout-is-not-absence",
    "(define-condition occlusion-is-not-absence",
    "(define-condition transit-is-not-absence",
    "(define-condition untyped-silence",
    "(define-condition forged-absence-claim",
    "(:answer :bounded-absence :refused",
    ":timeout :occluded :in-transit",
    "wait-until-arrival",
    "replay-judgment",
    ":unsearched-depths",
    ":planned-depths",
    "WHAT THIS DOES NOT ESTABLISH",
]
missing = [marker for marker in required if marker not in text]
assert not missing, f"missing required markers: {missing}"

# The specimen may load its root and use EVAL-WHEN, but should not dispatch
# arbitrary submitted forms through host EVAL/COMPILE/FDEFINITION.
forbidden_patterns = {
    "host eval": r"\(eval\s+[^-]",
    "host compile": r"\(compile\s+",
    "fdefinition mutation": r"\(setf\s+\(fdefinition",
    "reader evaluation": r"\*read-eval\*\s+t",
}
for label, pattern in forbidden_patterns.items():
    assert not re.search(pattern, text, flags=re.IGNORECASE), f"forbidden {label}"

# Demonstration gates should not quietly disappear.
expected_demo_conditions = [
    "aperture-exceeded",
    "answer-is-not-totality",
    "refusal-is-not-absence",
    "timeout-is-not-absence",
    "occlusion-is-not-absence",
    "transit-is-not-absence",
    "answer-still-travelling",
    "untyped-silence",
    "forged-absence-claim",
    "stale-descent-plan",
    "altered-depth-judgment",
]
for name in expected_demo_conditions:
    needle = f"(expect-condition {name}"
    assert needle in text, f"demonstration does not exercise {name}"

sha = hashlib.sha256(text.encode("utf-8")).hexdigest()
print(f"PASS lexical closure: {PATH}")
print(f"PASS required mechanisms: {len(required)}")
print(f"PASS adversarial demonstration gates: {len(expected_demo_conditions)}")
print("PASS forbidden host escape scan")
print(f"lines={len(text.splitlines())} bytes={len(text.encode('utf-8'))}")
print(f"sha256={sha}")
