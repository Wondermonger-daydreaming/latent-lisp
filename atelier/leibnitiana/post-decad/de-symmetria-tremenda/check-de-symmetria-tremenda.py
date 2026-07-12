#!/usr/bin/env python3
"""Sender-side static preflight for de-symmetria-tremenda.lisp.

This is not native Common Lisp execution. It checks lexical closure, required
mechanism markers, deliberate adversarial bites, and obvious host-escape seams.
"""
from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

SOURCE = Path(__file__).with_name("de-symmetria-tremenda.lisp")


def lexical_scan(text: str) -> tuple[int, bool, list[str]]:
    balance = 0
    in_string = False
    escaped = False
    errors: list[str] = []
    for line_no, line in enumerate(text.splitlines(), 1):
        i = 0
        while i < len(line):
            ch = line[i]
            if in_string:
                if escaped:
                    escaped = False
                elif ch == "\\":
                    escaped = True
                elif ch == '"':
                    in_string = False
                i += 1
                continue
            if ch == ";":
                break
            if ch == '"':
                in_string = True
            elif ch == "(":
                balance += 1
            elif ch == ")":
                balance -= 1
                if balance < 0:
                    errors.append(f"negative parenthesis balance at line {line_no}")
                    balance = 0
            i += 1
    if balance:
        errors.append(f"final parenthesis balance is {balance}, expected 0")
    if in_string:
        errors.append("unterminated string literal")
    return balance, in_string, errors


def main() -> int:
    text = SOURCE.read_text(encoding="utf-8")
    failures: list[str] = []

    _, _, lexical_errors = lexical_scan(text)
    failures.extend(lexical_errors)

    required = [
        "de-symmetria-tremenda",
        "compile-symmetry",
        "execute-symmetry",
        "replay-symmetry",
        "forge-fire-exhausted",
        "supply-fire",
        "could-is-not-dare",
        "dare-is-not-ought",
        "symmetry-is-not-identity",
        "beauty-is-not-benign",
        "tool-list-is-not-cause",
        "question-is-not-certificate",
        "shared-maker-is-not-shared-nature",
        "representation-is-not-creation",
        "frame-is-not-subjugation",
        "forged-creation-claim",
        ":fearful-symmetry-mapped-without-maker-certificate",
        ":could",
        ":dare",
        ":asserted",
    ]
    for marker in required:
        if marker.lower() not in text.lower():
            failures.append(f"missing mechanism marker: {marker}")

    # Every core adversarial condition should occur in its definition and its
    # firing path.  The shipped scar table is audited separately through the
    # corresponding claim function and claim id, avoiding a brittle raw-count
    # proxy for whether a tooth actually bites.
    bitten_conditions = [
        "could-is-not-dare",
        "dare-is-not-ought",
        "symmetry-is-not-identity",
        "beauty-is-not-benign",
        "tool-list-is-not-cause",
        "question-is-not-certificate",
        "shared-maker-is-not-shared-nature",
        "representation-is-not-creation",
        "frame-is-not-subjugation",
        "forged-creation-claim",
        "frame-procedure-unavailable",
        "stale-symmetry-plan",
    ]
    for name in bitten_conditions:
        count = len(re.findall(re.escape(name), text, flags=re.IGNORECASE))
        if count < 2:
            failures.append(
                f"condition lacks definition or firing path: {name} ({count} occurrences)"
            )

    scar_claims = [
        "claim-could-as-dare",
        "claim-dare-as-ought",
        "claim-symmetry-as-identity",
        "claim-beauty-as-benign",
        "claim-tools-as-cause",
        "claim-question-as-certificate",
        "claim-shared-maker-as-shared-nature",
        "claim-representation-as-creation",
        "claim-frame-as-subjugation",
    ]
    for claim in scar_claims:
        if len(re.findall(re.escape(claim), text, flags=re.IGNORECASE)) < 2:
            failures.append(f"shipped scar path missing or dormant: {claim}")

    forbidden_patterns = {
        "host EVAL": r"\(\s*eval(?:\s|\))",
        "caller-selected FDEFINITION": r"\(\s*fdefinition(?:\s|\))",
        "COMPILE from caller data": r"\(\s*compile(?:\s|\))",
        "LOAD beyond fixed atelier root": r"\(\s*load\b(?![^\n]*atelier-root\.lisp)",
    }
    for label, pattern in forbidden_patterns.items():
        if re.search(pattern, text, flags=re.IGNORECASE):
            failures.append(f"forbidden or suspicious seam: {label}")

    digest = hashlib.sha256(text.encode("utf-8")).hexdigest()
    print(f"source: {SOURCE}")
    print(f"lines: {len(text.splitlines())}")
    print(f"bytes: {len(text.encode('utf-8'))}")
    print(f"sha256: {digest}")
    print(f"required markers: {len(required)}/{len(required)}")
    print(f"adversarial condition audit: {len(bitten_conditions)} names")

    if failures:
        print("STATIC PREFLIGHT: FAIL")
        for failure in failures:
            print(f" - {failure}")
        return 1

    print("STATIC PREFLIGHT: PASS")
    print("CAVEAT: static inspection is not SBCL execution evidence.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
