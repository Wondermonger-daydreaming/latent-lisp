#!/usr/bin/env python3
"""Static preflight for de-incantatione.lisp.

This is not a Common Lisp runtime.  It checks lexical closure, required
mechanisms, adversarial exhibits, and a few forbidden host escape hatches
before SBCL receives the specimen.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

PATH = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("de-incantatione.lisp")
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
    "de-incantatione.lisp",
    "(define-condition internal-echo-is-not-discharge",
    "(define-condition premature-banishment",
    "(define-condition beauty-is-not-authority",
    "(define-condition incantation-is-not-evidence",
    "(define-condition symbolic-act-is-not-metaphysical-proof",
    "(define-condition breath-exhausted",
    "supply-breath",
    "archive-as-misfire",
    "replay-incantation",
    ":terminal-rhyme :c",
    '"cell"',
    '"desert"',
    '"ever"',
    '"dwell"',
    ":banished-from-chamber",
    ":external-world :not-addressed",
    "WHAT THIS DOES NOT ESTABLISH",
]
missing = [marker for marker in required if marker not in text]
assert not missing, f"missing required markers: {missing}"

forbidden_patterns = {
    "host eval": r"\(eval\s+[^-]",
    "host compile": r"\(compile\s+",
    "fdefinition mutation": r"\(setf\s+\(fdefinition",
    "reader evaluation": r"\*read-eval\*\s+t",
}
for label, pattern in forbidden_patterns.items():
    assert not re.search(pattern, text, flags=re.IGNORECASE), f"forbidden {label}"

expected_demo_conditions = [
    "internal-echo-is-not-discharge",
    "beauty-is-not-authority",
    "incantation-is-not-evidence",
    "symbolic-act-is-not-metaphysical-proof",
    "forged-enchantment-claim",
    "interpreter-unavailable",
]
for name in expected_demo_conditions:
    needle = f"(expect-condition {name}"
    assert needle in text, f"demonstration does not exercise {name}"

# Premature banishment is exercised through a live restart rather than the
# ordinary EXPECT-CONDITION helper.
assert "((premature-banishment" in text
assert "(invoke-restart 'archive-as-misfire)" in text

# The Miltonic formal skeleton should remain exactly ABBACDDEEC.
keys = re.findall(r":end-rhyme\s+(:[a-e])", text.lower())
assert keys[-10:] == [":a", ":b", ":b", ":a", ":c", ":d", ":d", ":e", ":e", ":c"], keys[-10:]

sha = hashlib.sha256(text.encode("utf-8")).hexdigest()
print(f"PASS lexical closure: {PATH}")
print(f"PASS required mechanisms: {len(required)}")
print(f"PASS adversarial demonstration gates: {len(expected_demo_conditions) + 1}")
print("PASS forbidden host escape scan")
print("PASS rhyme skeleton: ABBACDDEEC")
print(f"lines={len(text.splitlines())} bytes={len(text.encode('utf-8'))}")
print(f"sha256={sha}")
