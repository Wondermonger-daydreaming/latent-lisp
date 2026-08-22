#!/usr/bin/env python3
"""Status-grammar validator v7 — FAIL-CLOSED (SOL-R07-01 repair; replaces
validate_status_grammar_v6.py, which compared header labels without inline-
markup normalization — a first-column *Status* header was invisible, and a
**Status** header was mis-read as a prose declaration). v6 stays
byte-identical in the frozen R0.7 stratum. Header labels are now compared
after EXPLICIT case and inline-markup normalization (label-only emphasis,
strong emphasis, code-span, and link wrappers reduce to plain text), and a
structurally recognized table-header line is never re-read as a prose
Status declaration.

Fail-closed contract:
  1. Ordinary invocation with ZERO input files is an error (exit 2) — never CLEAN.
  2. EVERY supplied file must be covered by exactly one --expect=FILE:decls:cells
     entry. Missing, duplicate, misspelled (matching no input), or unused
     expectations are coverage errors. No CLEAN until coverage validation passes.
  2b. EVERY supplied file must contain non-whitespace text — an empty or
     whitespace-only file is a coverage error even under a matched 0:0
     expectation (the SOL-R04-02 'empty input text' control, closed at v5).
  2c. Status-bearing table discovery is CASE-INSENSITIVE after Markdown header
     normalization: a header cell matching 'status' in any case marks the
     table status-bearing and its column is validated (fail-closed, not
     silently ignored).
  3. Every data row of a status-bearing table is counted; a missing or blank
     Status cell is a violation.
  4. A status cell must contain EXACTLY ONE bold primary legend token, at the
     start of the cell; any second bold primary legend token in the same cell
     is a violation.
  5. Inline/separated declarations, sub-annotations, bare REFUSED, and
     unparseable **Status lines validated as in v3.

--self-test: v3's ten negative + seven positive controls PLUS: no-input
invocation, blank status cell, blank-plus-valid masking (the blank row must
stay a violation even when a valid row meets the count), and a
double-primary-token cell.
"""
import re, sys

LEGEND = ["ADOPTED LAW", "ACCEPTED EVIDENCE", "PROPOSED HOLDING",
          "REFUSED CLAIM", "OPEN", "HISTORICAL"]
SUB_OK = {"OPEN-UNOPENED", "OPEN-JURISDICTION-CLOSED"}
LEGEND_SORTED = sorted(LEGEND, key=len, reverse=True)

INLINE = re.compile(r'\*\*Status(?:\s*\([^)]*\))?\s*:\s*([^*]+?)\*\*')
SEPARATED = re.compile(r'\*\*Status(?:\s*\([^)]*\))?\s*[.:]?\s*\*\*\s*\*\*([^*]+?)\*\*')
ANY_DECL_LINE = re.compile(r'\*\*Status')
SUB = re.compile(r'sub-annotations?:\s*([A-Z][A-Z-]*)')
DASHSUB = re.compile(r'\b(OPEN)\s*—\s*(UNOPENED|JURISDICTION-CLOSED)\b')
BAREREF = re.compile(r'\*\*REFUSED:?\*\*(?!\s*CLAIM)|(?<![-A-Za-z:])REFUSED(?!\s+CLAIM)(?![-A-Za-z`])')
BOLD = re.compile(r'\*\*([^*]+?)\*\*')

LABEL_WRAP = [
    (re.compile(r'^\*\*([^*]+)\*\*$'), 1),   # strong **x**
    (re.compile(r'^__([^_]+)__$'), 1),          # strong __x__
    (re.compile(r'^\*([^*]+)\*$'), 1),         # emphasis *x*
    (re.compile(r'^_([^_]+)_$'), 1),            # emphasis _x_
    (re.compile(r'^`([^`]+)`$'), 1),            # code-span `x`
    (re.compile(r'^\[([^\]]+)\]\([^)]*\)$'), 1),  # link [x](url)
]
def normalize_label(cell):
    """Reduce label-only inline wrappers to plain text, iteratively (SOL-R07-01)."""
    cell = cell.strip()
    changed = True
    while changed:
        changed = False
        for pat, g in LABEL_WRAP:
            m = pat.match(cell)
            if m:
                cell = m.group(g).strip(); changed = True
    return cell

def token_ok(tok):
    tok = tok.strip().rstrip('.').strip()
    for lg in LEGEND_SORTED:
        if tok == lg:
            return True
        if tok.startswith(lg):
            rest = tok[len(lg):].strip()
            if lg == "REFUSED CLAIM" and rest == "under current evidence":
                return True
            return rest == ""
    return False

def is_primary_legend(s):
    s = s.strip().rstrip('.').strip()
    for lg in LEGEND_SORTED:
        if s == lg or (s.startswith(lg) and lg == "REFUSED CLAIM"
                       and s[len(lg):].strip() == "under current evidence"):
            return True
        if s == lg:
            return True
    return s in LEGEND

def check_text(text, name):
    viol, decls, cells = [], 0, 0
    lines = text.splitlines()
    def split_row(s):
        s = s.strip()
        if s.startswith('|'): s = s[1:]
        if s.endswith('|'): s = s[:-1]
        return [c.strip() for c in s.split('|')]
    SEP = re.compile(r'^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?\s*$')
    def is_table_row(s):
        return '|' in s
    header_lines = set()
    for idx, line in enumerate(lines):
        # STRUCTURAL discovery (v6): header iff next line is a separator row,
        # regardless of optional outer pipes or Status column position.
        if '|' in line and idx + 1 < len(lines) and SEP.match(lines[idx + 1]):
            header_lines.add(idx)  # recognized table header — never prose (v7)
            hdr = split_row(line)
            col = next((i for i, c in enumerate(hdr)
                        if normalize_label(c).lower().startswith('status')), None)
            if col is None: continue
            j = idx + 2
            while j < len(lines) and is_table_row(lines[j]):
                row = split_row(lines[j])
                cells += 1  # EVERY data row counts (fail-closed rule 3)
                cell = row[col] if col < len(row) else ""
                if not cell:
                    viol.append(f"{name}:{j+1}: MISSING/BLANK status cell (every classified row needs exactly one primary token)")
                else:
                    m = re.match(r'\*\*([^*]+?)\*\*', cell)
                    if not m:
                        viol.append(f"{name}:{j+1}: status cell does not OPEN with a bold token: {cell[:50]!r}")
                    else:
                        first = m.group(1)
                        if not token_ok(first):
                            viol.append(f"{name}:{j+1}: non-legend table status token {first!r}")
                        # rule 4: any SECOND bold primary legend token in the cell
                        rest = cell[m.end():]
                        for b in BOLD.findall(rest):
                            if is_primary_legend(b):
                                viol.append(f"{name}:{j+1}: SECOND primary legend token {b!r} in one status cell (exactly one required)")
                j += 1
    for i, line in enumerate(lines, 1):
        if (i - 1) in header_lines:
            continue  # v7: a recognized table header is not a prose declaration
        if ANY_DECL_LINE.search(line):
            toks = INLINE.findall(line) or SEPARATED.findall(line)
            if not toks:
                viol.append(f"{name}:{i}: unparseable **Status declaration (unparseable = violation): {line.strip()[:70]!r}")
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

def run(paths, expects):
    # coverage validation FIRST (fail-closed rules 1, 2, 5)
    cov_errors = []
    if not paths:
        print("ERROR: zero input files — CLEAN is impossible on silence (fail-closed rule 1)")
        return 2
    for p in paths:
        try:
            body = open(p, encoding='utf-8').read()
        except OSError as e:
            cov_errors.append(f"unreadable input {p!r}: {e}"); continue
        if not body.strip():
            cov_errors.append(f"EMPTY/whitespace-only input file (rule 2b — cannot pass even with a matched 0:0 expectation): {p!r}")
    for f in expects:
        if f not in paths:
            cov_errors.append(f"expectation names no supplied input (misspelled/unused): {f!r}")
    for p in paths:
        if p not in expects:
            cov_errors.append(f"input file has NO expectation (every file must be covered): {p!r}")
    allv, coverage_ok = [], True
    results = []
    for path in paths:
        v, d, c = check_text(open(path, encoding='utf-8').read(), path)
        allv += v
        results.append((path, d, c))
    for path, d, c in results:
        ed, ec = expects.get(path, (None, None))
        line = f"{path}: {d} declarations, {c} table status cells"
        if ed is not None and (d < ed or c < ec):
            line += f"  ⚠ COVERAGE UNMET (expected ≥{ed} decls, ≥{ec} cells)"
            coverage_ok = False
        print(line)
    for e in cov_errors: print("⚠ COVERAGE:", e)
    for v in allv: print("⚠", v)
    if cov_errors or not coverage_ok:
        print(f"NOT CLEAN — coverage validation FAILED ({len(cov_errors)} coverage error(s)); violations: {len(allv)}")
        return 2
    if allv:
        print(f"NOT CLEAN ({len(allv)} violation(s))")
        return 1
    print("CLEAN (coverage validated: every file matched by an expectation; all expectations met)")
    return 0

def self_test():
    fails = 0
    def expect_viol(text, label):
        nonlocal fails
        v, _, _ = check_text(text, f"<neg:{label}>")
        if not v: print(f"SELF-TEST FAIL (not caught): {label}"); fails += 1
        else: print(f"self-test ok (caught): {label}")
    def expect_clean(text, label=""):
        nonlocal fails
        v, _, _ = check_text(text, "<pos>")
        if v: print(f"SELF-TEST FAIL (false positive): {label or text[:40]!r} -> {v[0]}"); fails += 1
        else: print(f"self-test ok (passed): {label or text[:40]}")
    # v3 carried controls
    expect_viol("**Status: MYSTERY** text", "inline seventh token")
    expect_viol("**Status (rung x): MYSTERY** text", "inline-ctx seventh token")
    expect_viol("**Status:** **MYSTERY**.", "separated seventh token")
    expect_viol("**Status: OPEN — and split by owner ruling into two targets** (x):", "overstuffed OPEN token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | **MYSTERY** | n |", "table seventh token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | plain OPEN | n |", "table cell not bold-token")
    expect_viol("**Status:** **OPEN** *(sub-annotation: UNOPENED)*", "bare sub-annotation")
    expect_viol("**Status: OPEN — UNOPENED**", "em-dash truncation")
    expect_viol("**REFUSED:** example", "bare REFUSED")
    expect_viol("**Status wording that never parses", "unparseable declaration")
    # NEW fail-closed controls (SOL-R04-02)
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 |  | n |", "BLANK status cell")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 |  | n |\n| r2 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n |", "blank-plus-valid MASKING (blank still violates)")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | **OPEN** / **HISTORICAL** | n |", "DOUBLE primary token in one cell")
    # NEW v5 controls (SOL-R05-01)
    import tempfile, os
    d = tempfile.mkdtemp()
    empty = os.path.join(d, "empty.md")
    open(empty, "w").write("   \n\n")
    rc = run([empty], {empty: (0, 0)})
    if rc == 2: print("self-test ok (caught): matched-0:0 EMPTY file refused")
    else: print("SELF-TEST FAIL: matched-0:0 empty file passed"); fails += 1
    expect_viol("| Claim | status | Note |\n|---|---|---|\n| r1 | **MYSTERY** | n |", "lowercase-status table with invalid token")
    expect_viol("Status | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | invalid", "NO-OUTER-PIPE first-column Status table with invalid token")
    expect_viol("*Status* | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | italic hdr", "ITALIC first-column *Status* header with invalid token")
    expect_viol("*Status* | Claim | Note\n--- | --- | ---\n | r1 | italic hdr blank", "ITALIC first-column *Status* header with blank cell")
    expect_viol("Status | Claim | Note\n--- | --- | ---\n | r1 | blank status", "NO-OUTER-PIPE first-column Status table with blank cell")
    expect_viol("| Claim | STATUS NOW | Note |\n|---|---|---|\n| r1 |  | n |", "uppercase-STATUS table with blank cell")
    # no-input invocation
    rc = run([], {})
    if rc == 2: print("self-test ok (caught): no-input invocation refused")
    else: print("SELF-TEST FAIL: no-input invocation not refused"); fails += 1
    # positives
    expect_clean("**Status: PROPOSED HOLDING** `[PROPOSED]` (support: x).")
    expect_clean("**Status: OPEN** *(sub-annotation: OPEN-JURISDICTION-CLOSED)*.")
    expect_clean("**Status (charter §E rung 6).** **OPEN** *(sub-annotation: OPEN-UNOPENED)*.")
    expect_clean("**Status: ACCEPTED EVIDENCE** at its exact sentence.")
    expect_clean("**Status: REFUSED CLAIM under current evidence** (W-09).")
    expect_clean("| Claim | Status now | Note |\n|---|---|---|\n| r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n |", "table OPEN+sub")
    expect_clean("| Claim | Status now | Note |\n|---|---|---|\n| r1 | **PROPOSED HOLDING** `[PROPOSED]` (support) | n |", "table PROPOSED")
    # v7: bold **Status** header + valid row — counted once, NOT a prose declaration
    v, d, c = check_text("**Status** | Claim | Note\n--- | --- | ---\n**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "<pos:bold-hdr>")
    if v or c != 1:
        print(f"SELF-TEST FAIL: bold-Status header + valid OPEN row (violations={v}, cells={c})"); fails += 1
    else:
        print("self-test ok (passed): bold **Status** header + valid OPEN row counted once, no prose misread")
    print("SELF-TEST:", "PASS" if not fails else f"{fails} FAILURE(S)")
    return 1 if fails else 0

def main():
    if "--self-test" in sys.argv: sys.exit(self_test())
    expects, args = {}, []
    for a in sys.argv[1:]:
        if a.startswith("--expect="):
            f, d, c = a[9:].split(":")
            if f in expects:
                print(f"ERROR: duplicate expectation for {f!r}"); sys.exit(2)
            expects[f] = (int(d), int(c))
        elif not a.startswith("-"): args.append(a)
    sys.exit(run(args, expects))

if __name__ == "__main__":
    main()
