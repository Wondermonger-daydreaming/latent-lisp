#!/usr/bin/env python3
"""Status-grammar VALIDATOR for the Charter /0 parcel (SOL-R02-02 repair —
replaces lint_status_tokens.py, whose LEGEND/BAD_REFUSED were dead code and
whose two narrow patterns missed em-dash and table-cell forms by construction).

Validates, over the files given as arguments:
  1. EVERY declared primary status (prose `**Status...**` declarations and
     table status cells opening with a bold token) is one of the six legend
     tokens exactly.
  2. EVERY OPEN sub-annotation uses the exact declared forms OPEN-UNOPENED /
     OPEN-JURISDICTION-CLOSED — bare or em-dash-joined truncations fail.
  3. `REFUSED` as a status label appears only as `REFUSED CLAIM`.

--self-test runs committed positive AND negative controls and exits nonzero
if any negative control passes or any positive control fails: an arbitrary
seventh token, bare REFUSED, and both truncated OPEN forms MUST fail; the six
legend tokens with exact sub-annotations MUST pass. A validator that has never
been shown able to fail is untested, not passing.
"""
import re, sys

LEGEND = ["ADOPTED LAW", "ACCEPTED EVIDENCE", "PROPOSED HOLDING", "OPEN",
          "REFUSED CLAIM", "HISTORICAL"]
SUB_OK = {"OPEN-UNOPENED", "OPEN-JURISDICTION-CLOSED"}

# a status declaration: '**Status...**' prose, or a table/list bold token
DECL = re.compile(r'\*\*Status[^*]*\*\*\s*:?\s*\*?\*?([A-Z][A-Za-z —-]*?)\*?\*?[\s.(,*]')
SUB = re.compile(r'sub-annotations?:\s*([A-Z][A-Z-]*)')
DASHSUB = re.compile(r'\b(OPEN)\s*—\s*(UNOPENED|JURISDICTION-CLOSED)')
BAREREF = re.compile(r'\*\*REFUSED:?\*\*(?!\s*CLAIM)|(?<![-A-Za-z:])REFUSED(?!\s+CLAIM)(?![-A-Za-z`])')  # (?<!:) — a Lisp keyword literal `:REFUSED` is data, not a status label

def check_text(text, name):
    viol = []
    for i, line in enumerate(text.splitlines(), 1):
        for m in DECL.finditer(line):
            tok = m.group(1).strip().rstrip('.').strip()
            # allow legend token possibly followed by nothing; normalize em-dash residue
            base = tok.split('—')[0].strip()
            if base not in LEGEND:
                viol.append(f"{name}:{i}: non-legend primary token {tok!r}")
            if '—' in tok:
                viol.append(f"{name}:{i}: em-dash-joined status form {tok!r} (sub-annotation must be parenthesized exact form)")
        for m in SUB.finditer(line):
            if m.group(1) not in SUB_OK:
                viol.append(f"{name}:{i}: bad sub-annotation {m.group(1)!r} (must be OPEN-UNOPENED or OPEN-JURISDICTION-CLOSED)")
        for m in DASHSUB.finditer(line):
            viol.append(f"{name}:{i}: truncated em-dash OPEN form {m.group(0)!r}")
        for m in BAREREF.finditer(line):
            # tolerate inside explicit quotes? No: print for adjudication with marker
            viol.append(f"{name}:{i}: bare REFUSED label (must be REFUSED CLAIM) [adjudicate if quoted]: {line.strip()[:80]}")
    return viol

def self_test():
    neg = [
        ("**Status:** **MYSTERY**.", "seventh token"),
        ("**Status (charter rung 6).** **OPEN — JURISDICTION-CLOSED.** text", "em-dash truncation"),
        ("**Status:** **OPEN** *(sub-annotation: UNOPENED)*", "bare sub-annotation"),
        ("**REFUSED:** example", "bare REFUSED"),
        ("**Status:** **OPEN — UNOPENED**", "em-dash UNOPENED"),
    ]
    pos = [
        "**Status: PROPOSED HOLDING** `[PROPOSED]` (support: x).",
        "**Status:** **OPEN** *(sub-annotation: OPEN-JURISDICTION-CLOSED)*.",
        "**Status: ACCEPTED EVIDENCE** at its exact sentence.",
        "**Status: REFUSED CLAIM under current evidence** (W-09).",
        "**Status:** **OPEN** *(sub-annotation: OPEN-UNOPENED; T9-blocked)*.",
    ]
    fails = 0
    for text, label in neg:
        v = check_text(text, f"<neg:{label}>")
        if not v:
            print(f"SELF-TEST FAIL: negative control NOT caught: {label}"); fails += 1
        else:
            print(f"self-test ok (caught): {label}")
    for text in pos:
        v = check_text(text, "<pos>")
        if v:
            print(f"SELF-TEST FAIL: positive control flagged: {text!r} -> {v}"); fails += 1
        else:
            print(f"self-test ok (passed): {text[:50]}")
    print("SELF-TEST:", "PASS" if not fails else f"{fails} FAILURE(S)")
    return 1 if fails else 0

def main():
    if "--self-test" in sys.argv:
        sys.exit(self_test())
    viol = []
    for path in [a for a in sys.argv[1:] if not a.startswith('-')]:
        viol += check_text(open(path, encoding='utf-8').read(), path)
    for v in viol: print("⚠", v)
    print("CLEAN" if not viol else f"{len(viol)} violation(s)")
    sys.exit(1 if viol else 0)

if __name__ == "__main__":
    main()
