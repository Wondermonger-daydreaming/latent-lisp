#!/usr/bin/env python3
"""Small relay check: balanced Lisp delimiters, closed strings/comments, unique specimen packages.

This is not a Common Lisp compiler. Native SBCL execution remains the canonization gate.
"""
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent


def check_delimiters(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    stack: list[tuple[int, int]] = []
    line = 1
    column = 0
    i = 0
    in_string = False
    escaped = False
    block_comment_depth = 0
    errors: list[str] = []

    while i < len(text):
        char = text[i]
        if char == "\n":
            line += 1
            column = 0
        else:
            column += 1

        if block_comment_depth:
            if text.startswith("#|", i):
                block_comment_depth += 1
                i += 2
                continue
            if text.startswith("|#", i):
                block_comment_depth -= 1
                i += 2
                continue
            i += 1
            continue

        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            i += 1
            continue

        if text.startswith("#|", i):
            block_comment_depth = 1
            i += 2
            continue
        if char == ";":
            newline = text.find("\n", i)
            if newline == -1:
                break
            i = newline
            continue
        if char == '"':
            in_string = True
        elif char == "(":
            stack.append((line, column))
        elif char == ")":
            if not stack:
                errors.append(f"extra ')' at {line}:{column}")
                return errors
            stack.pop()
        i += 1

    if in_string:
        errors.append("unterminated string")
    if block_comment_depth:
        errors.append("unterminated #| ... |# comment")
    if stack:
        errors.append(f"{len(stack)} unclosed '('; last opened at {stack[-1][0]}:{stack[-1][1]}")
    return errors


# Self-contained specimens exempt from the private-DEFPACKAGE rule. Each runs in
# its own SBCL process via run-all.sh, so package isolation is provided by the
# process boundary; these declare no package BY DESIGN and the exemption is
# named here rather than silenced. (Lab integration note, 2026-07-12: de-foeno
# arrived in GPT Sol's decad written CL-USER-bare in poetic-bench manners; Sol's
# authored bytes were not edited to satisfy a cosmetic lint. Delimiter checks
# still apply to exempt files.)
PACKAGELESS_EXEMPT = {"instruments/de-foeno.lisp"}


def main() -> int:
    lisp_files = sorted(ROOT.rglob("*.lisp"))
    failures = 0
    packages: dict[str, Path] = {}

    for path in lisp_files:
        errors = check_delimiters(path)
        if errors:
            failures += 1
            print(f"FAIL {path.relative_to(ROOT)}: {'; '.join(errors)}")
        else:
            print(f"PASS {path.relative_to(ROOT)}")

        rel = str(path.relative_to(ROOT))
        if rel in PACKAGELESS_EXEMPT:
            print(f"NOTE {rel}: no private DEFPACKAGE (named exemption — self-contained by design)")
            continue

        if path.parent.name != "kernel":
            match = re.search(r"\(defpackage\s+#:([^\s\)]+)", path.read_text(encoding="utf-8"))
            if not match:
                failures += 1
                print(f"FAIL {path.relative_to(ROOT)}: no private DEFPACKAGE")
            else:
                package = match.group(1).lower()
                if package in packages:
                    failures += 1
                    print(
                        f"FAIL {path.relative_to(ROOT)}: package {package} also used by "
                        f"{packages[package].relative_to(ROOT)}"
                    )
                packages[package] = path

    if failures:
        print(f"\n{failures} static check(s) failed.")
        return 1
    print(f"\nStatic relay check passed for {len(lisp_files)} Lisp files.")
    print("Native SBCL execution is still required for canonization.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
