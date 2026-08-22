#!/usr/bin/env python3
"""Status-grammar validator v3 for the Charter /0 parcel (SOL-R03-02 repair;
replaces validate_status_tokens.py, whose DECL matched none of the charter's
ten inline rung declarations — zero matches cannot count as success).

Validates over the files given:
  A. INLINE declarations   **Status: TOKEN** ... / **Status (ctx): TOKEN** ...
  B. SEPARATED declarations **Status (ctx).** **TOKEN** ... / **Status:** **TOKEN**
  C. STATUS-BEARING TABLES  any Markdown table whose header row contains a
     'Status' column: that column's cell must OPEN with a bold legend token.
  D. Any line containing '**Status' that yields NO parse under A/B is a
     violation in itself (unparseable declaration ≠ pass).
  E. Sub-annotations: only OPEN-UNOPENED / OPEN-JURISDICTION-CLOSED.
  F. Bare REFUSED (not REFUSED CLAIM; `:REFUSED` Lisp keywords exempt).
  G. COVERAGE ASSERTIONS: caller-declared minimum declaration/table-cell
     counts per file (--expect file:decls:cells). CLEAN is refused if any
     expectation is unmet — silence can never pass.

--self-test: committed positive AND negative controls in the ACTUAL syntaxes
(inline, separated, table), including an arbitrary seventh token in each syntax
and the overstuffed 'OPEN — and split…' token. Exit nonzero on any control
failing its required polarity.
"""
import re, sys

LEGEND = ["ADOPTED LAW", "ACCEPTED EVIDENCE", "PROPOSED HOLDING",
          "REFUSED CLAIM", "OPEN", "HISTORICAL"]  # longest-first matters below
SUB_OK = {"OPEN-UNOPENED", "OPEN-JURISDICTION-CLOSED"}
LEGEND_SORTED = sorted(LEGEND, key=len, reverse=True)

INLINE = re.compile(r'\*\*Status(?:\s*\([^)]*\))?\s*:\s*([^*]+?)\*\*')
SEPARATED = re.compile(r'\*\*Status(?:\s*\([^)]*\))?\s*[.:]?\s*\*\*\s*\*\*([^*]+?)\*\*')
ANY_DECL_LINE = re.compile(r'\*\*Status')
SUB = re.compile(r'sub-annotations?:\s*([A-Z][A-Z-]*)')
DASHSUB = re.compile(r'\b(OPEN)\s*—\s*(UNOPENED|JURISDICTION-CLOSED)\b')
BAREREF = re.compile(r'\*\*REFUSED:?\*\*(?!\s*CLAIM)|(?<![-A-Za-z:])REFUSED(?!\s+CLAIM)(?![-A-Za-z`])')

def token_ok(tok):
    tok = tok.strip().rstrip('.').strip()
    for lg in LEGEND_SORTED:
        if tok == lg or tok.startswith(lg + " ") or tok.startswith(lg + " under current evidence"[:0]):
            rest = tok[len(lg):].strip()
            # allow qualified REFUSED CLAIM ('under current evidence'), nothing else
            if lg == "REFUSED CLAIM" and rest in ("", "under current evidence"):
                return True
            return rest == ""
    return False

def check_text(text, name):
    viol, decls, cells = [], 0, 0
    lines = text.splitlines()
    # table pass: find header rows with a Status column
    for idx, line in enumerate(lines):
        if '|' in line and re.search(r'\|\s*Status', line):
            hdr = [c.strip() for c in line.strip().strip('|').split('|')]
            col = next((i for i, c in enumerate(hdr) if c.lower().startswith('status')), None)
            if col is None: continue
            j = idx + 2  # skip separator row
            while j < len(lines) and lines[j].lstrip().startswith('|'):
                row = [c.strip() for c in lines[j].strip().strip('|').split('|')]
                if col < len(row) and row[col]:
                    cells += 1
                    m = re.match(r'\*\*([^*]+?)\*\*', row[col])
                    if not m:
                        viol.append(f"{name}:{j+1}: table status cell does not open with a bold token: {row[col][:50]!r}")
                    elif not token_ok(m.group(1)):
                        viol.append(f"{name}:{j+1}: non-legend table status token {m.group(1)!r}")
                j += 1
    for i, line in enumerate(lines, 1):
        if ANY_DECL_LINE.search(line):
            toks = INLINE.findall(line) or SEPARATED.findall(line)
            if not toks:
                viol.append(f"{name}:{i}: status-looking declaration could not be parsed (unparseable = violation): {line.strip()[:70]!r}")
            for tok in toks:
                decls += 1
                if not token_ok(tok):
                    viol.append(f"{name}:{i}: non-legend primary token {tok.strip()!r}")
        for m in SUB.finditer(line):
            if m.group(1) not in SUB_OK:
                viol.append(f"{name}:{i}: bad sub-annotation {m.group(1)!r}")
        for m in DASHSUB.finditer(line):
            viol.append(f"{name}:{i}: truncated em-dash OPEN form {m.group(0)!r}")
        for m in BAREREF.finditer(line):
            viol.append(f"{name}:{i}: bare REFUSED label [adjudicate if quoted]: {line.strip()[:70]}")
    return viol, decls, cells

def self_test():
    neg = [
        ("**Status: MYSTERY** text", "inline seventh token"),
        ("**Status (rung x): MYSTERY** text", "inline-ctx seventh token"),
        ("**Status:** **MYSTERY**.", "separated seventh token"),
        ("**Status: OPEN — and split by owner ruling into two targets** (x):", "overstuffed OPEN token"),
        ("| Claim | Status | Note |\n|---|---|---|\n| r1 | **MYSTERY** | n |", "table seventh token"),
        ("| Claim | Status | Note |\n|---|---|---|\n| r1 | plain OPEN | n |", "table cell not bold-token"),
        ("**Status:** **OPEN** *(sub-annotation: UNOPENED)*", "bare sub-annotation"),
        ("**Status: OPEN — UNOPENED**", "em-dash truncation"),
        ("**REFUSED:** example", "bare REFUSED"),
        ("**Status wording that never parses", "unparseable declaration"),
    ]
    pos = [
        "**Status: PROPOSED HOLDING** `[PROPOSED]` (support: x).",
        "**Status: OPEN** *(sub-annotation: OPEN-JURISDICTION-CLOSED)*.",
        "**Status (charter §E rung 6).** **OPEN** *(sub-annotation: OPEN-UNOPENED)*.",
        "**Status: ACCEPTED EVIDENCE** at its exact sentence.",
        "**Status: REFUSED CLAIM under current evidence** (W-09).",
        "| Claim | Status now | Note |\n|---|---|---|\n| r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n |",
        "| Claim | Status now | Note |\n|---|---|---|\n| r1 | **PROPOSED HOLDING** `[PROPOSED]` (support) | n |",
    ]
    fails = 0
    for text, label in neg:
        v, _, _ = check_text(text, f"<neg:{label}>")
        if not v: print(f"SELF-TEST FAIL (not caught): {label}"); fails += 1
        else: print(f"self-test ok (caught): {label}")
    for text in pos:
        v, _, _ = check_text(text, "<pos>")
        if v: print(f"SELF-TEST FAIL (false positive): {text[:45]!r} -> {v[0]}"); fails += 1
        else: print(f"self-test ok (passed): {text[:45]}")
    print("SELF-TEST:", "PASS" if not fails else f"{fails} FAILURE(S)")
    return 1 if fails else 0

def main():
    if "--self-test" in sys.argv: sys.exit(self_test())
    expects = {}
    args = []
    for a in sys.argv[1:]:
        if a.startswith("--expect="):
            f, d, c = a[9:].split(":"); expects[f] = (int(d), int(c))
        elif not a.startswith("-"): args.append(a)
    allv, ok = [], True
    for path in args:
        v, d, c = check_text(open(path, encoding='utf-8').read(), path)
        allv += v
        ed, ec = expects.get(path, (0, 0))
        line = f"{path}: {d} declarations, {c} table status cells"
        if d < ed or c < ec:
            line += f"  ⚠ COVERAGE UNMET (expected ≥{ed} decls, ≥{ec} cells)"; ok = False
        print(line)
    for v in allv: print("⚠", v)
    clean = not allv and ok
    print("CLEAN" if clean else f"NOT CLEAN ({len(allv)} violation(s); coverage {'ok' if ok else 'UNMET'})")
    sys.exit(0 if clean else 1)

if __name__ == "__main__":
    main()
