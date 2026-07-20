#!/usr/bin/env python3
"""ss0-afel.py — SS-0 mechanical application-facing-effective-line counter.

A physical line counts iff it is (a) not blank, (b) not comment-only
(first non-space char ';' or '#'), (c) not inside a '@harness-begin' ..
'@harness-end' block, and (d) not carrying an end-of-line '@harness' mark.
Marker rule (audited): only readiness/window calls, kill waits, and
torn-write injection may be marked. Production logic may not be marked.

Usage: python3 ss0-afel.py <file> [<file> ...]
Prints per-file AFEL, the counted/excluded line-number audit, and a total.
"""
import sys


def afel(path):
    count, in_block = 0, False
    counted, excluded = [], []
    for n, raw in enumerate(open(path), 1):
        s = raw.rstrip("\n").strip()
        if "@harness-begin" in s:
            in_block = True
            excluded.append(n)
            continue
        if "@harness-end" in s:
            in_block = False
            excluded.append(n)
            continue
        if in_block:
            excluded.append(n)
            continue
        if not s or s.startswith(";") or s.startswith("#"):
            continue
        if "@harness" in s:
            excluded.append(n)
            continue
        count += 1
        counted.append(n)
    return count, counted, excluded


def main():
    total = 0
    for path in sys.argv[1:]:
        n, counted, excluded = afel(path)
        total += n
        print(f"{path}: {n} AFEL ({len(excluded)} lines excluded as @harness)")
        print(f"  excluded-lines-audit: {excluded}")
    print(f"TOTAL: {total} AFEL")


if __name__ == "__main__":
    main()
