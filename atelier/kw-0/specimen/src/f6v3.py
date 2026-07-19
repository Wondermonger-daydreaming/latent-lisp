#!/usr/bin/env python3
"""f6v3.py — F6-v3 mechanical semantic-burden metric.

PRE-REGISTERED (RDP-1, D3; fixes the under-specified scaffolding boundary of
the original F6, whose raw result — 76 vs 45 = 1.69x vs ceiling 1.5x — stands
permanently):

  Unit: APPLICATION-FACING EFFECTIVE LINE (AFEL).
  A physical line in a designated application file counts iff it is
    (a) not blank, and
    (b) not a comment-only line (first non-space char is ';'), and
    (c) not inside a ';; @harness-begin' .. ';; @harness-end' block, and
    (d) not carrying an end-of-line ';; @harness' mark.
  Marker placement rule (auditable): a line/block may be marked @harness
  iff it is death-instrumentation — readiness markers, death waits, torn-frame
  injection, killpoint dispatch. Production scenario logic may not be marked.

  Designated application files: the scenario drivers an application author
  writes: KW column = kw-runner.lisp; baseline column = kw-baseline.lisp.
  Substrate (kw-common, kw-oracle, kw-reconstruct, folder.py, harness.py) is
  excluded by definition — it is the substrate, per the owner's F6 repair.

  Threshold (unchanged from the original registration): KW-AFEL <= 1.5x
  baseline-AFEL.

Usage: python3 f6v3.py <kw-file> <baseline-file>
"""
import sys


def afel(path):
    count = 0
    in_block = False
    counted, excluded = [], []
    for n, raw in enumerate(open(path), 1):
        line = raw.rstrip("\n")
        s = line.strip()
        if "@harness-begin" in s:
            in_block = True
            excluded.append((n, "block-begin"))
            continue
        if "@harness-end" in s:
            in_block = False
            excluded.append((n, "block-end"))
            continue
        if in_block:
            excluded.append((n, "block"))
            continue
        if not s:
            continue
        if s.startswith(";"):
            continue
        if "@harness" in s:
            excluded.append((n, "eol-mark"))
            continue
        count += 1
        counted.append(n)
    return count, counted, excluded


def main():
    kw_file, base_file = sys.argv[1], sys.argv[2]
    kw_n, kw_counted, kw_excl = afel(kw_file)
    base_n, base_counted, base_excl = afel(base_file)
    ratio = kw_n / base_n if base_n else float("inf")
    print(f"F6-v3 (mechanical AFEL)")
    print(f"  KW column ({kw_file}): {kw_n} AFEL "
          f"({len(kw_excl)} lines excluded as @harness)")
    print(f"  baseline column ({base_file}): {base_n} AFEL "
          f"({len(base_excl)} lines excluded as @harness)")
    print(f"  ratio: {ratio:.3f}x  (pre-registered ceiling: 1.5x)")
    print(f"  verdict: {'PASS' if ratio <= 1.5 else 'FAIL'}")
    print(f"  excluded-lines-audit: KW={ [n for n,_ in kw_excl] }")
    print(f"                        BASE={ [n for n,_ in base_excl] }")


if __name__ == "__main__":
    main()
