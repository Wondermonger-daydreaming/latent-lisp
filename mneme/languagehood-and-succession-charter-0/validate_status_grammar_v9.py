#!/usr/bin/env python3
"""Status-grammar validator v9 — FAIL-CLOSED (SOL-R09-01/02/03 repair;
replaces validate_status_grammar_v8.py, whose drawer guard was a punctuation
allowlist, whose table lexer split raw pipe bytes, and whose exact-one scan
knew only the ** strong spelling). v8 stays byte-identical in the frozen
R0.9 stratum.

Three repairs:
  1. PROJECTION GUARD: the Status-like test now operates on a Markdown
     plain-text projection — named/numeric character references decoded
     (html.unescape), raw inline HTML tags stripped, image syntax reduced to
     its alt label — and any projected-Status-like header the grammar
     normalizer cannot reduce is a coverage violation (conservative refusal),
     never a silent 0:0 surface.
  2. LOGICAL CELLS: GFM table rows are tokenized into logical cells with
     backslash-run parity — an escaped \| is cell content, not a delimiter —
     and header and data rows share one column model, so escaped-pipe decoys
     shift nothing.
  3. SEMANTIC STRONG: primary-token recognition and the second-primary scan
     treat **x** and __x__ as the strong emphasis they both are.
"""
import re, sys, html

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
BOLD = re.compile(r'\*\*([^*]+?)\*\*|__([^_]+?)__')  # both strong spellings (SOL-R09-03)

REFDEF = re.compile(r'^\s*\[([^\]]+)\]:\s*\S+')

def collect_refdefs(text):
    return frozenset(m.group(1).strip().lower()
                     for line in text.splitlines()
                     for m in [REFDEF.match(line)] if m)

def normalize_label(cell, refdefs=frozenset()):
    """Reduce a whole Markdown inline label to plain text (SOL-R08-01):
    recursive emphasis/strong, matching multi-backtick code spans,
    balanced/escaped inline-link destinations, reference links resolved from
    the document's definitions."""
    cell = cell.strip(); prev = None
    while cell != prev:
        prev = cell
        m = re.match(r'^(`+)(.+)\1$', cell)             # code span, matching runs
        if m and m.group(1) not in m.group(2):
            cell = m.group(2).strip(); continue
        m = re.match(r'^(\*{1,3}|_{1,3})(.+?)\1$', cell)  # emphasis/strong, symmetric runs
        if m and m.group(2).strip():
            cell = m.group(2).strip(); continue
        m = re.match(r'^\[([^\]]+)\]\(((?:[^()\\]|\\.|\([^()]*\))*)\)$', cell)  # inline link, balanced/escaped dest
        if m:
            cell = m.group(1).strip(); continue
        m = re.match(r'^\[([^\]]+)\]\[([^\]]*)\]$', cell)  # reference link, full/collapsed
        if m and (m.group(2) or m.group(1)).strip().lower() in refdefs:
            cell = m.group(1).strip(); continue
        m = re.match(r'^\[([^\]]+)\]$', cell)          # shortcut reference link
        if m and m.group(1).strip().lower() in refdefs:
            cell = m.group(1).strip(); continue
    return cell

MARKUP_CHARS = re.compile(r'[*_`\[\]()~\\!]')
HTML_TAG = re.compile(r'<[^>]+>')
IMG = re.compile(r'!\[([^\]]*)\](?:\([^)]*\)|\[[^\]]*\])?')
def plain_projection(cell):
    """Markdown plain-text projection (SOL-R09-01): decode character
    references, strip raw inline HTML tags, reduce images to alt labels,
    then strip residual inline punctuation."""
    s = html.unescape(cell)
    s = HTML_TAG.sub('', s)
    s = IMG.sub(lambda m: m.group(1), s)
    return MARKUP_CHARS.sub('', s).strip()
def status_like_unreduced(cell, refdefs):
    """Fail-closed guard: True iff the cell's PLAIN-TEXT PROJECTION is
    Status-like but the grammar normalizer could not reduce the cell to a
    plain Status label — unsupported forms are refused, never invisible."""
    norm = normalize_label(cell, refdefs)
    if norm.lower().startswith('status'):
        return False  # reduced fine; handled as a Status column
    return plain_projection(cell).lower().startswith('status')

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
    refdefs = collect_refdefs(text)
    def split_row(s):
        """Tokenize a GFM table row into LOGICAL cells (SOL-R09-02):
        a pipe preceded by an odd-length backslash run is cell content;
        escaped pipes are unescaped in the emitted cells."""
        s = s.strip()
        cells, buf, i = [], [], 0
        while i < len(s):
            c = s[i]
            if c == '\\' and i + 1 < len(s):
                nxt = s[i+1]
                if nxt == '|':
                    buf.append('|'); i += 2; continue
                buf.append(c); buf.append(nxt); i += 2; continue
            if c == '|':
                cells.append(''.join(buf).strip()); buf = []; i += 1; continue
            buf.append(c); i += 1
        cells.append(''.join(buf).strip())
        if cells and cells[0] == '' and s.startswith('|'): cells = cells[1:]
        if cells and cells[-1] == '' and s.endswith('|') and not s.endswith('\\|'): cells = cells[:-1]
        return cells
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
                        if normalize_label(c, refdefs).lower().startswith('status')), None)
            if col is None:
                for c in hdr:  # v8 fail-closed guard: no invisible Status-like headers
                    if status_like_unreduced(c, refdefs):
                        viol.append(f"{name}:{idx+1}: COVERAGE: unsupported/ambiguous Status-like header markup (fail-closed, never a silent 0:0 surface): {c[:50]!r}")
                continue
            j = idx + 2
            while j < len(lines) and is_table_row(lines[j]):
                row = split_row(lines[j])
                cells += 1  # EVERY data row counts (fail-closed rule 3)
                cell = row[col] if col < len(row) else ""
                if not cell:
                    viol.append(f"{name}:{j+1}: MISSING/BLANK status cell (every classified row needs exactly one primary token)")
                else:
                    m = re.match(r'\*\*([^*]+?)\*\*|__([^_]+?)__', cell)
                    if not m:
                        viol.append(f"{name}:{j+1}: status cell does not OPEN with a bold token: {cell[:50]!r}")
                    else:
                        first = m.group(1) or m.group(2)
                        if not token_ok(first):
                            viol.append(f"{name}:{j+1}: non-legend table status token {first!r}")
                        # rule 4: any SECOND bold primary legend token in the cell
                        rest = cell[m.end():]
                        for bm in BOLD.finditer(rest):
                            b = bm.group(1) or bm.group(2)
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
    expect_viol("***Status*** | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | combined", "COMBINED strong-emphasis ***Status*** header with invalid token")
    expect_viol("``Status`` | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | two-backtick", "TWO-BACKTICK code-span header with invalid token")
    expect_viol("[Status][status-label] | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | ref link\n\n[status-label]: https://example.com/status", "FULL-REFERENCE link header with invalid token")
    expect_viol("[Status](https://example.com/status_(label)) | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | balanced dest", "BALANCED-DESTINATION inline-link header with invalid token")
    expect_viol("~~Status~~ | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | strikethrough", "DRAWER GUARD: unsupported Status-like markup fails closed")
    expect_viol("<em>Status</em> | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | inline HTML wrapper", "INLINE-HTML Status header refused (projection guard)")
    expect_viol("&#83;tatus | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | character-reference label", "CHARACTER-REFERENCE Status header refused (projection guard)")
    expect_viol("![Status](status.png) | Claim | Note\n--- | --- | ---\n**MYSTERY** | r1 | image alt label", "IMAGE-ALT Status header refused (projection guard)")
    expect_viol("Claim \\| kind | Status | Note\n--- | --- | ---\nr1 | **MYSTERY** | **OPEN**", "HEADER-SHIFT escaped-pipe decoy exposes MYSTERY")
    expect_viol("Claim | Status | Note\n--- | --- | ---\nr1 \\| **OPEN** | **MYSTERY** | note", "DATA-SHIFT escaped-pipe decoy exposes MYSTERY")
    expect_viol("Claim | Status | Note\n--- | --- | ---\nr1 | **OPEN** / __HISTORICAL__ | two strong primaries", "DOUBLE primary across strong spellings (** and __)")
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
    # v8: the four wrapper-grammar companions — counted once each, accepted
    for hdr, label in [("***Status***", "combined strong-emphasis"),
                       ("``Status``", "two-backtick code-span"),
                       ("[Status](https://example.com/status_(label))", "balanced-destination link")]:
        v, d, c = check_text(hdr + " | Claim | Note\n--- | --- | ---\n**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", f"<pos:{label}>")
        if v or c != 1:
            print(f"SELF-TEST FAIL: {label} header + valid OPEN row (violations={v}, cells={c})"); fails += 1
        else:
            print(f"self-test ok (passed): {label} Status header + valid OPEN row counted once")
    v, d, c = check_text("[Status][status-label] | Claim | Note\n--- | --- | ---\n**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n\n\n[status-label]: https://example.com/status", "<pos:reference-link>")
    if v or c != 1:
        print(f"SELF-TEST FAIL: reference-link header + valid OPEN row (violations={v}, cells={c})"); fails += 1
    else:
        print("self-test ok (passed): reference-link Status header + valid OPEN row counted once")
    # v9 companions: escaped-pipe content + valid status counted once; __OPEN__ semantic primary
    v, d, c = check_text("Claim | Status | Note\n--- | --- | ---\nr1 \\| detail | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "<pos:escaped-pipe-companion>")
    if v or c != 1:
        print(f"SELF-TEST FAIL: escaped-pipe companion (violations={v}, cells={c})"); fails += 1
    else:
        print("self-test ok (passed): escaped-pipe content cell + valid Status counted once")
    v, d, c = check_text("Claim | Status | Note\n--- | --- | ---\nr1 | __OPEN__ *(sub-annotation: OPEN-UNOPENED)* | n", "<pos:underscore-strong-primary>")
    if v or c != 1:
        print(f"SELF-TEST FAIL: __OPEN__ semantic primary (violations={v}, cells={c})"); fails += 1
    else:
        print("self-test ok (passed): __OPEN__ recognized as one valid strong primary")
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
