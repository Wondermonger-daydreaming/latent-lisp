#!/usr/bin/env python3
"""Status-grammar validator v12 — FAIL-CLOSED (SOL-R12-01/02/03 repair;
replaces validate_status_grammar_v11.py, which hired the parser for inlines
but kept a regex clerk at admissions: tables were discovered by a hand
separator-scan that missed blockquoted tables, prose declarations were gated
by a literal `**Status` regex that missed underscore/entity/link carriers,
and only the FIRST prose carrier on a line was ever validated). v11 stays
byte-identical in the frozen R0.12 stratum.

THE PARSER IS THE AUTHORITY, BLOCK AND INLINE (commission steps 4-6):
  - TABLES come from the parser's own GFM table rule — table/thead/tbody/
    tr/th/td tokens, wherever the block structure puts them, including
    inside blockquotes and lists. No separator regex, no physical-line row
    loop, no hand cell lexer: the parser's logical cells are the cells.
  - PROSE DECLARATIONS are discovered by VISIBLE STRONG LABELS on non-table
    inline surfaces: any strong node whose visible label starts with
    'status' is a carrier — both strong spellings, decoded character
    references, link labels, nested emphasis alike. No punctuation regex
    gates discovery.
  - EVERY carrier on a surface is validated, in order; each takes exactly
    one primary; any other strong legend label on the surface is a
    violation. Same exact-one rule as table cells.
  - CONSERVATIVE REFUSAL: unrepresentable inline constructs, and any raw
    line spelling `**Status` that the parser resolves to no carrier
    (ambiguous Status-like surface), are violations before CLEAN.

REPRODUCIBILITY SURFACE (commission step 8): requires markdown-it-py
(tested with 4.0.0 and 3.0.0) with its core 'table' and 'strikethrough'
rules enabled. If the dependency is absent the validator exits 3 with a
controlled diagnostic, never an import traceback.
"""
import re, sys

try:
    from markdown_it import MarkdownIt
    import markdown_it as _mi
except ImportError:
    print("DEPENDENCY MISSING: markdown-it-py is required (tested with 4.0.0 and 3.0.0).")
    print("Install it, or invoke with an interpreter that provides it "
          "(e.g. the environment python3 that carries markdown_it).")
    sys.exit(3)

MD = MarkdownIt('commonmark').enable(['strikethrough', 'table'])
PARSER_ID = f"markdown-it-py {getattr(_mi, '__version__', 'unknown')}"

LEGEND = ["ADOPTED LAW", "ACCEPTED EVIDENCE", "PROPOSED HOLDING",
          "REFUSED CLAIM", "OPEN", "HISTORICAL"]
SUB_OK = {"OPEN-UNOPENED", "OPEN-JURISDICTION-CLOSED"}
LEGEND_SORTED = sorted(LEGEND, key=len, reverse=True)
SUB = re.compile(r'sub-annotations?:\s*([A-Z][A-Z-]*)')
DASHSUB = re.compile(r'\b(OPEN)\s*—\s*(UNOPENED|JURISDICTION-CLOSED)\b')
BAREREF = re.compile(r'\*\*REFUSED:?\*\*(?!\s*CLAIM)|(?<![-A-Za-z:])REFUSED(?!\s+CLAIM)(?![-A-Za-z`])')
RAW_STATUSISH = re.compile(r'\*\*Status')  # tripwire only — never gates discovery

class Unsupported(Exception): pass
SKIP = {'html_inline', 'strong_open', 'strong_close', 'em_open', 'em_close',
        'link_open', 'link_close', 's_open', 's_close'}
TEXTY = {'text', 'code_inline', 'text_special'}

def visible(children):
    out = []
    for tok in children or []:
        if tok.type in TEXTY: out.append(tok.content)
        elif tok.type == 'image': out.append(visible(tok.children))
        elif tok.type in ('softbreak', 'hardbreak'): out.append(' ')
        elif tok.type in SKIP: pass
        else: raise Unsupported(tok.type)
    return ''.join(out)

def strong_labels(children):
    labels, depth, buf = [], 0, []
    for tok in children or []:
        if tok.type == 'strong_open':
            depth += 1
            if depth == 1: buf = []
            continue
        if tok.type == 'strong_close':
            depth -= 1
            if depth == 0: labels.append(visible(buf).strip())
            continue
        if depth >= 1: buf.append(tok)
        elif tok.type not in TEXTY and tok.type != 'image' \
             and tok.type not in SKIP and tok.type not in ('softbreak', 'hardbreak'):
            raise Unsupported(tok.type)
    return labels

def opens_with_strong(children):
    for tok in children or []:
        if tok.type in TEXTY and not tok.content.strip(): continue
        return tok.type == 'strong_open'
    return False

def token_ok(tok):
    tok = tok.strip().rstrip('.').strip()
    for lg in LEGEND_SORTED:
        if tok == lg: return True
        if tok.startswith(lg):
            rest = tok[len(lg):].strip()
            if lg == "REFUSED CLAIM" and rest == "under current evidence": return True
            return rest == ""
    return False

def is_primary_legend(s):
    s = s.strip().rstrip('.').strip()
    if s in LEGEND: return True
    return s.startswith("REFUSED CLAIM") and s[len("REFUSED CLAIM"):].strip() == "under current evidence"

def check_text(text, name):
    viol, decls, cells = [], 0, 0
    env = {}
    try:
        toks = MD.parse(text, env)
    except Exception as e:
        return [f"{name}: document does not parse under the GFM model ({e}) — conservative refusal"], 0, 0

    def lineof(tok, fallback):
        return (tok.map[0] + 1) if getattr(tok, 'map', None) else fallback

    carrier_lines = set()
    table_span_lines = set()
    i, n = 0, len(toks)
    while i < n:
        t = toks[i]
        if t.type == 'table_open':
            tline = lineof(t, 0)
            if getattr(t, 'map', None):
                table_span_lines.update(range(t.map[0] + 1, t.map[1] + 1))
            j = i + 1
            header, rows, cur, in_head = [], [], None, False
            while j < n and toks[j].type != 'table_close':
                tt = toks[j]
                if tt.type == 'thead_open': in_head = True
                elif tt.type == 'thead_close': in_head = False
                elif tt.type == 'tr_open': cur = []
                elif tt.type == 'tr_close':
                    if in_head: header = cur or []
                    else: rows.append((cur or [], lineof(tt, tline)))
                    cur = None
                elif tt.type == 'inline' and cur is not None:
                    cur.append(tt)
                j += 1
            i = j + 1
            cols = []
            for ci, th in enumerate(header):
                try:
                    lab = visible(th.children).strip()
                except Unsupported as e:
                    viol.append(f"{name}:{tline}: header cell holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                    continue
                if lab.lower().startswith('status'): cols.append(ci)
            if not cols: continue
            for row, rline in rows:
                for col in cols:
                    cells += 1
                    cell_tok = row[col] if col < len(row) else None
                    ch = cell_tok.children if cell_tok is not None else []
                    where = lineof(cell_tok, rline) if cell_tok is not None else rline
                    try:
                        vis = visible(ch).strip()
                        labs = strong_labels(ch)
                        opens = opens_with_strong(ch)
                    except Unsupported as e:
                        viol.append(f"{name}:{where}: status cell holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                        continue
                    if not vis and not labs:
                        viol.append(f"{name}:{where}: MISSING/BLANK status cell (every classified row needs exactly one primary token)")
                        continue
                    if not opens or not labs:
                        viol.append(f"{name}:{where}: status cell does not OPEN with a strong primary token: {vis[:50]!r}")
                        continue
                    if not token_ok(labs[0]):
                        viol.append(f"{name}:{where}: non-legend table status token {labs[0]!r}")
                    for b in labs[1:]:
                        if is_primary_legend(b):
                            viol.append(f"{name}:{where}: SECOND primary legend token {b!r} in one status cell (exactly one required)")
            continue
        if t.type == 'inline':
            where = lineof(t, 0)
            try:
                labs = strong_labels(t.children)
            except Unsupported as e:
                if RAW_STATUSISH.search(t.content or ''):
                    viol.append(f"{name}:{where}: Status-like surface holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                i += 1; continue
            k = 0
            surface_decls = 0
            while k < len(labs):
                lab = labs[k]
                if lab.lower().startswith('status'):
                    surface_decls += 1
                    carrier_lines.add(where)
                    after = lab.split(':', 1)[1].strip() if ':' in lab else ''
                    if after:
                        primary = after; k += 1
                    elif k + 1 < len(labs):
                        primary = labs[k+1]; k += 2
                    else:
                        viol.append(f"{name}:{where}: declaration has no parsed primary token — conservative refusal")
                        k += 1; continue
                    if not token_ok(primary):
                        viol.append(f"{name}:{where}: non-legend primary token {primary.strip()!r}")
                else:
                    if surface_decls and is_primary_legend(lab):
                        viol.append(f"{name}:{where}: SECOND primary legend token {lab!r} on one prose Status declaration surface (exactly one per carrier)")
                    k += 1
            decls += surface_decls
        i += 1

    for ln, line in enumerate(text.splitlines(), 1):
        if RAW_STATUSISH.search(line) and ln not in carrier_lines \
           and ln not in table_span_lines:
            # spelled like a declaration; parser resolved no carrier there
            if not any(f"{name}:{ln}:" in v for v in viol):
                viol.append(f"{name}:{ln}: ambiguous Status-like surface (spelled **Status, parser resolves no carrier) — conservative refusal: {line.strip()[:60]!r}")
        for m in SUB.finditer(line):
            if m.group(1) not in SUB_OK:
                viol.append(f"{name}:{ln}: bad sub-annotation {m.group(1)!r}")
        for m in DASHSUB.finditer(line):
            viol.append(f"{name}:{ln}: truncated em-dash OPEN form {m.group(0)!r}")
        for m in BAREREF.finditer(line):
            viol.append(f"{name}:{ln}: bare REFUSED label [adjudicate if quoted]: {line.strip()[:70]}")
    return viol, decls, cells

def run(paths, expects):
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
    allv, coverage_ok, results = [], True, []
    for path in paths:
        v, d, c = check_text(open(path, encoding='utf-8').read(), path)
        allv += v; results.append((path, d, c))
    for path, d, c in results:
        ed, ec = expects.get(path, (None, None))
        line = f"{path}: {d} declarations, {c} table status cells"
        if ed is not None and (d < ed or c < ec):
            line += f"  ⚠ COVERAGE UNMET (expected ≥{ed} decls, ≥{ec} cells)"; coverage_ok = False
        print(line)
    for e in cov_errors: print("⚠ COVERAGE:", e)
    for v in allv: print("⚠", v)
    if cov_errors or not coverage_ok:
        print(f"NOT CLEAN — coverage validation FAILED ({len(cov_errors)} coverage error(s)); violations: {len(allv)}")
        return 2
    if allv:
        print(f"NOT CLEAN ({len(allv)} violation(s))"); return 1
    print(f"CLEAN (coverage validated; parse model: {PARSER_ID})")
    return 0

def self_test():
    fails = 0
    def expect_viol(text, label):
        nonlocal fails
        v, _, _ = check_text(text, f"<neg:{label}>")
        if not v: print(f"SELF-TEST FAIL (not caught): {label}"); fails += 1
        else: print(f"self-test ok (caught): {label}")
    def expect_clean(text, label="", want_cells=None, want_decls=None):
        nonlocal fails
        v, d, c = check_text(text, "<pos>")
        bad = bool(v) or (want_cells is not None and c != want_cells) or (want_decls is not None and d != want_decls)
        if bad: print(f"SELF-TEST FAIL: {label or text[:40]!r} (viol={v[:1]}, decls={d}, cells={c})"); fails += 1
        else: print(f"self-test ok (passed): {label or text[:40]}")
    T = "\n--- | --- | ---\n"
    expect_viol("**Status: MYSTERY** text", "inline seventh token")
    expect_viol("**Status (rung x): MYSTERY** text", "inline-ctx seventh token")
    expect_viol("**Status:** **MYSTERY**.", "separated seventh token")
    expect_viol("**Status: OPEN — and split by owner ruling into two targets** (x):", "overstuffed OPEN token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | **MYSTERY** | n |", "table seventh token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | plain OPEN | n |", "table cell not strong-token")
    expect_viol("**Status:** **OPEN** *(sub-annotation: UNOPENED)*", "bare sub-annotation")
    expect_viol("**Status: OPEN — UNOPENED**", "em-dash truncation")
    expect_viol("**REFUSED:** example", "bare REFUSED")
    expect_viol("**Status wording that never parses", "unparseable declaration (ambiguity tripwire)")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 |  | n |", "BLANK status cell")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 |  | n |\n| r2 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n |", "blank-plus-valid MASKING")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | **OPEN** / **HISTORICAL** | n |", "DOUBLE primary (** twice)")
    expect_viol("Claim | status | Note" + T + "r1 | **MYSTERY** | n", "lowercase-status table")
    expect_viol("Status | Claim | Note" + T + "**MYSTERY** | r1 | invalid", "NO-OUTER-PIPE first-column Status")
    expect_viol("*Status* | Claim | Note" + T + "**MYSTERY** | r1 | italic hdr", "ITALIC *Status* header")
    expect_viol("***Status*** | Claim | Note" + T + "**MYSTERY** | r1 | combined", "COMBINED ***Status*** header")
    expect_viol("``Status`` | Claim | Note" + T + "**MYSTERY** | r1 | two-backtick", "TWO-BACKTICK header")
    expect_viol("[Status][status-label] | Claim | Note" + T + "**MYSTERY** | r1 | ref link\n\n[status-label]: https://example.com/status", "FULL-REFERENCE link header")
    expect_viol("[Status](https://example.com/status_(label)) | Claim | Note" + T + "**MYSTERY** | r1 | balanced dest", "BALANCED-DESTINATION link header")
    expect_viol("~~Status~~ | Claim | Note" + T + "**MYSTERY** | r1 | strikethrough", "STRIKETHROUGH Status header")
    expect_viol("<em>Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | inline HTML", "INLINE-HTML Status header")
    expect_viol("&#83;tatus | Claim | Note" + T + "**MYSTERY** | r1 | char ref", "CHARACTER-REFERENCE Status header")
    expect_viol("![Status](status.png) | Claim | Note" + T + "**MYSTERY** | r1 | image alt", "IMAGE-ALT Status header")
    expect_viol("Status | <!-- a > b -->Status | Claim" + T + "**OPEN** | **MYSTERY** | r1", "COMMENT-hidden SECOND Status column")
    expect_viol("*Status* | Claim | Note" + T + " | r1 | italic hdr blank", "ITALIC header with blank cell")
    expect_viol("Claim \\| kind | Status | Note" + T + "r1 | **MYSTERY** | **OPEN**", "HEADER-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 \\| **OPEN** | **MYSTERY** | note", "DATA-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORICAL__ | two strong", "DOUBLE primary (** and __)")
    expect_viol("Claim | Status | Status" + T + "r1 | **OPEN** | **MYSTERY**", "SECOND Status column validated")
    expect_viol("<em title=\">\">Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | quoted-attr", "QUOTE-ATTR HTML Status header")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORIC&#65;L__ | rendered", "ENTITY-bearing strong second primary")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL](https://example.com)__ | rendered", "LINK-bearing strong second primary")
    expect_viol("STATUS NOW | Claim | Note" + T + " | r1 | blank", "uppercase-STATUS blank cell")
    expect_viol("Claim | <!-- a > b -->Status | Note" + T + "r1 | **MYSTERY** | hidden column", "COMMENT-hidden single Status column")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL]__ | second primary\n\n[HISTORICAL]: https://example.com/history", "SHORTCUT-reference strong second primary")
    expect_viol("**Status: OPEN** / **HISTORICAL**", "PROSE double primary")
    # SOL-R12 exact witnesses
    expect_viol("> Claim | Status | Note\n> --- | --- | ---\n> r1 | **MYSTERY** | hidden", "SOL-R12-01: BLOCKQUOTED table with invalid token")
    expect_viol("__Status: MYSTERY__", "SOL-R12-02: underscore-strong invalid declaration")
    expect_viol("**Sta&#116;us: MYSTERY**", "SOL-R12-02: entity-bearing invalid carrier")
    expect_viol("**[Status](https://example.com/status): MYSTERY**", "SOL-R12-02: link-bearing invalid carrier")
    expect_viol("**Status: OPEN** and **Status: MYSTERY**", "SOL-R12-03: second carrier on one line validated")
    import tempfile, os
    d = tempfile.mkdtemp(); empty = os.path.join(d, "empty.md"); open(empty, "w").write("   \n\n")
    rc = run([empty], {empty: (0, 0)})
    if rc == 2: print("self-test ok (caught): matched-0:0 EMPTY file refused")
    else: print("SELF-TEST FAIL: matched-0:0 empty file passed"); fails += 1
    rc = run([], {})
    if rc == 2: print("self-test ok (caught): no-input invocation refused")
    else: print("SELF-TEST FAIL: no-input not refused"); fails += 1
    # positives
    expect_clean("**Status: PROPOSED HOLDING** `[PROPOSED]` (support: x).", "inline PROPOSED", want_decls=1)
    expect_clean("**Status: OPEN** *(sub-annotation: OPEN-JURISDICTION-CLOSED)*.", "inline OPEN+sub", want_decls=1)
    expect_clean("**Status (charter §E rung 6).** **OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "separated OPEN", want_decls=1)
    expect_clean("**Status: ACCEPTED EVIDENCE** at its exact sentence.", "inline ACCEPTED", want_decls=1)
    expect_clean("**Status: REFUSED CLAIM under current evidence** (W-09).", "inline REFUSED CLAIM qualified", want_decls=1)
    expect_clean("| Claim | Status now | Note |\n|---|---|---|\n| r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n |", "table OPEN+sub", want_cells=1)
    expect_clean("| Claim | Status now | Note |\n|---|---|---|\n| r1 | **PROPOSED HOLDING** `[PROPOSED]` (support) | n |", "table PROPOSED", want_cells=1)
    expect_clean("***Status*** | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "combined-emphasis header + valid row", want_cells=1)
    expect_clean("``Status`` | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "two-backtick header + valid row", want_cells=1)
    expect_clean("[Status](https://example.com/status_(label)) | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "balanced-dest link header + valid row", want_cells=1)
    expect_clean("[Status][status-label] | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n\n\n[status-label]: https://example.com/status", "reference-link header + valid row", want_cells=1)
    expect_clean("**Status** | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "bold header + valid row", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 \\| detail | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "escaped-pipe companion", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 | __OPEN__ *(sub-annotation: OPEN-UNOPENED)* | n", "__OPEN__ semantic primary", want_cells=1)
    expect_clean("Claim | Status | Status" + T + "r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | **HISTORICAL**", "two valid Status columns", want_cells=2)
    expect_clean("Claim | Status | Note" + T + "r1 | **OPEN** *(see __[note](https://x)__)* | n", "non-legend strong link non-primary", want_cells=1)
    expect_clean("Claim | <!-- legal comment -->Other | Status" + T + "r1 | x | **OPEN** *(sub-annotation: OPEN-UNOPENED)*", "comment in unrelated header", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 | **OPEN** *(cf. __[note]__)* | n\n\n[note]: https://example.com/n", "non-legend shortcut-ref annotation", want_cells=1)
    expect_clean("**Status: OPEN** *(single primary; see also HISTORICAL in plain text)*", "single-primary prose", want_decls=1)
    # SOL-R12 companions
    expect_clean("> Claim | Status | Note\n> --- | --- | ---\n> r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | ok", "blockquoted table with one valid cell", want_cells=1)
    expect_clean("__Status: OPEN__ *(sub-annotation: OPEN-UNOPENED)*", "underscore-strong valid declaration", want_decls=1)
    expect_clean("**Sta&#116;us: ACCEPTED EVIDENCE** at its sentence.", "entity-bearing valid carrier", want_decls=1)
    expect_clean("**[Status](https://example.com/status): HISTORICAL** record.", "link-bearing valid carrier", want_decls=1)
    expect_clean("**Status: OPEN** *(first)* and **Status: HISTORICAL** *(second)*", "two-carrier line, both valid, both counted", want_decls=2)
    print("SELF-TEST:", "PASS" if not fails else f"{fails} FAILURE(S)")
    return 1 if fails else 0

def main():
    if "--self-test" in sys.argv: sys.exit(self_test())
    expects, args = {}, []
    for a in sys.argv[1:]:
        if a.startswith("--expect="):
            f, d, c = a[9:].split(":")
            if f in expects: print(f"ERROR: duplicate expectation for {f!r}"); sys.exit(2)
            expects[f] = (int(d), int(c))
        elif not a.startswith("-"): args.append(a)
    sys.exit(run(args, expects))

if __name__ == "__main__":
    main()
