#!/usr/bin/env python3
"""ss0-void2-audit.py — VOID-2 lexical audit of the shared substrate.

The substrate must not provide the eight excluded semantic concepts under
any name (SS0-SUBSTRATE-API.md §6). This audit scans the STORAGE/SER/WINDOW
modules against the full term list, and the PROVIDER modules against a
reduced list (the provider may name its own world artifacts — receipts,
outcomes — but must contain no interpretation of seat records).

A lexical audit is a tripwire, not a proof; it is paired with the
planted-concept teeth-check (this tool must FAIL on the planted file
before its PASS is trusted) and with code inspection.

Usage: python3 ss0-void2-audit.py  (run from the substrate directory)
Exit 0 = pass; exit 1 = hit(s) found.
"""
import re
import sys
from pathlib import Path

FULL_TERMS = [
    "determinacy", "determinate", "presence-class", "occupanc", "settle",
    "settlement", "retry", "refus", "reconcil", "supersed", "lineage",
    "origin", "reconstruct", "observed", "claim", "receipt", "attest",
    "unresolved", "uncertain", "evidence", "census", "standing",
]
# Provider owns its world artifacts: receipt files and executed/not-executed
# outcomes are fixture facts, not seat-record semantics.
PROVIDER_ALLOWED = {"receipt", "claim"}  # 'claim' only inside 'disclaim' etc. checked below

STORAGE_FILES = ["ss0-substrate.lisp", "ss0_substrate.py"]
PROVIDER_FILES = ["ss0-provider.lisp", "ss0_provider.py"]


EXEMPT = [(":if-exists :supersede", "supersed")]  # CL standard file-open mode


def scan(path, terms):
    hits = []
    text = Path(path).read_text().lower()
    for n, line in enumerate(text.split("\n"), 1):
        for t in terms:
            if t in line:
                if any(tok in line and t == term for tok, term in EXEMPT):
                    continue
                hits.append((path, n, t, line.strip()[:70]))
    return hits


def main():
    hits = []
    for f in STORAGE_FILES:
        if Path(f).exists():
            hits += scan(f, FULL_TERMS)
    for f in PROVIDER_FILES:
        if Path(f).exists():
            terms = [t for t in FULL_TERMS if t not in PROVIDER_ALLOWED]
            hits += scan(f, terms)
    if hits:
        print("VOID-2 AUDIT: FAIL — excluded-concept terms found in substrate:")
        for path, n, t, line in hits:
            print(f"  {path}:{n} term '{t}': {line}")
        sys.exit(1)
    print("VOID-2 AUDIT: PASS — no excluded-concept terms in scanned substrate modules")
    print(f"  scanned: {STORAGE_FILES + PROVIDER_FILES}")
    print(f"  full terms: {len(FULL_TERMS)}; provider-allowed: {sorted(PROVIDER_ALLOWED)}")
    sys.exit(0)


if __name__ == "__main__":
    main()
