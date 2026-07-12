#!/usr/bin/env python3
"""Static preflight for de-leviathan.lisp.

This is deliberately not a Common Lisp compiler or runtime receipt.
It checks lexical closure and the presence of the specimen's declared mechanisms.
"""
from pathlib import Path
import re
import sys

path = Path(__file__).with_name("de-leviathan.lisp")
text = path.read_text(encoding="utf-8")

balance = 0
in_string = False
escape = False
block_depth = 0
i = 0
line = 1
while i < len(text):
    c = text[i]
    if block_depth:
        if text.startswith("#|", i):
            block_depth += 1
            i += 2
            continue
        if text.startswith("|#", i):
            block_depth -= 1
            i += 2
            continue
        if c == "\n":
            line += 1
        i += 1
        continue
    if in_string:
        if escape:
            escape = False
        elif c == "\\":
            escape = True
        elif c == '"':
            in_string = False
        if c == "\n":
            line += 1
        i += 1
        continue
    if text.startswith("#|", i):
        block_depth = 1
        i += 2
        continue
    if c == ";":
        end = text.find("\n", i)
        if end < 0:
            i = len(text)
        else:
            i = end
        continue
    if c == '"':
        in_string = True
    elif c == "(":
        balance += 1
    elif c == ")":
        balance -= 1
        if balance < 0:
            raise SystemExit(f"negative parenthesis balance near line {line}")
    if c == "\n":
        line += 1
    i += 1

assert balance == 0, f"unclosed parenthesis balance: {balance}"
assert not in_string, "unclosed string"
assert block_depth == 0, f"unclosed block comment depth: {block_depth}"

required = [
    "counterfeit-covenant",
    "custody-mismatch",
    "authority-not-transferable",
    "authority-not-divisible",
    "archive-as-struggle",
    "subjugation-refused",
    "false-subjugation-claim",
    "target-changed-since-observation",
    ":unsubdued",
    "what this instrument does NOT establish",
]
missing = [marker for marker in required if marker.lower() not in text.lower()]
assert not missing, f"missing required markers: {missing}"

forbidden = [
    r"\(eval\s",
    r"\(fdefinition\s",
    r"\(symbol-function\s",
]
for pattern in forbidden:
    assert not re.search(pattern, text, flags=re.IGNORECASE), f"forbidden host escape: {pattern}"

print("STATIC PREFLIGHT PASS")
print("file:", path.name)
print("lines:", text.count("\n") + 1)
print("required markers:", len(required))
print("native Common Lisp execution: still required")
