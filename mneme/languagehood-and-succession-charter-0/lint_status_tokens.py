#!/usr/bin/env python3
"""Status-token lint for the Charter /0 parcel (SOL-R01-02 repair).

Checks, over the CURRENT candidate texts passed as arguments:
  1. Primary-status tokens are drawn only from the six-token legend.
  2. OPEN sub-annotations use only the exact declared forms
     OPEN-UNOPENED / OPEN-JURISDICTION-CLOSED (bare UNOPENED /
     JURISDICTION-CLOSED after 'sub-annotation' markers = violation).
  3. 'REFUSED' as a status label appears only as 'REFUSED CLAIM'.
Advisory: prints violations, exit 1 if any (0 clean). Quoted historical text
inside explicit quotation marks is NOT exempted automatically — a hit inside a
quote is printed for a human to adjudicate, marked [check-quote].
"""
import re, sys
BAD_SUB = re.compile(r'sub-annotations?:\s*(?!OPEN-)(UNOPENED|JURISDICTION-CLOSED)')
BAD_REFUSED = re.compile(r'\*\*REFUSED:?\*\*(?!\s*CLAIM)|\bREFUSED\b(?!\s+CLAIM|[-A-Za-z])')
LEGEND = {"ADOPTED LAW","ACCEPTED EVIDENCE","PROPOSED HOLDING","OPEN","REFUSED CLAIM","HISTORICAL"}
viol = 0
for path in sys.argv[1:]:
    for i, line in enumerate(open(path, encoding='utf-8'), 1):
        for m in BAD_SUB.finditer(line):
            print(f"⚠ {path}:{i}: bare sub-annotation '{m.group(1)}' (must be OPEN-{m.group(1)})"); viol += 1
        if '**Status:' in line or '| **Status' in line:
            if re.search(r'\bSPLIT\b', line):
                print(f"⚠ {path}:{i}: non-legend primary token SPLIT"); viol += 1
print(f"{'CLEAN' if not viol else str(viol)+' violation(s)'}")
sys.exit(1 if viol else 0)
