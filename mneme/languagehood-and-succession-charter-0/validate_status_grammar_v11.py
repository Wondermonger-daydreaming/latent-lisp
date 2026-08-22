#!/usr/bin/env python3
"""Status-grammar validator v11 — FAIL-CLOSED (SOL-R11-01/02/03 repair;
replaces validate_status_grammar_v10.py, which re-implemented Markdown in the
margins: a tag regex that ended HTML comments at the first internal `>`, a
strong-label reducer that missed shortcut reference links, and an exact-one
rule applied to table cells but never to prose declarations). v10 stays
byte-identical in the frozen R0.11 stratum.

THE PARSE MODEL (commission step 4): all inline semantics come from ONE
conforming CommonMark/GFM parser — markdown-it-py (already present in the
environment; no new dependency). The same model serves header recognition,
visible-label projection, reference resolution (full, collapsed, AND shortcut
— resolved from the document's own definitions), strong-node enumeration, and
prose-declaration validation. Raw-HTML inline tokens of every class (open and
close tags, comments, processing instructions, declarations, CDATA) arrive as
`html_inline` tokens and contribute no visible text — so `<!-- a > b -->` is
a comment, not a broken tag. Any inline token type the walker does not know
is a CONSERVATIVE REFUSAL: a violation before CLEAN, never a silent surface.

EXACT-ONE, UNIFORMLY (commission step 7): a table status cell and a prose
Status declaration obey the same rule — one primary legend token; any later
strong node on the same surface whose VISIBLE label is a primary legend is a
violation.

Everything inherited stays: structural table discovery (separator-row
skeleton), parity-aware logical cell lexing (escaped \\| is content), every
Status-like column validated, blank cells, masked blanks, empty/whitespace
files refused under matched 0:0, full expectation coverage before CLEAN, and
the header/prose separation.
"""
import re, sys, html
from markdown_it import MarkdownIt

MD = MarkdownIt('commonmark').enable('strikethrough')

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

class Unsupported(Exception): pass

# ---- the shared inline walk ------------------------------------------------
SKIP = {'html_inline', 'strong_open', 'strong_close', 'em_open', 'em_close',
        'link_open', 'link_close', 's_open', 's_close'}
TEXTY = {'text', 'code_inline', 'text_special'}

def inline_children(src, env):
    toks = MD.parseInline(src, env)
    if not toks: return []
    return toks[0].children or []

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
    """Visible labels of top-level strong nodes, in order."""
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
        elif tok.type not in TEXTY and tok.type != 'image' and tok.type not in SKIP \
             and tok.type not in ('softbreak', 'hardbreak'):
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

# ---- checking --------------------------------------------------------------
def check_text(text, name):
    viol, decls, cells = [], 0, 0
    lines = text.splitlines()
    env = {}
    try:
        MD.parse(text, env)  # populates env['references'] for all link forms
    except Exception as e:
        return [f"{name}: document does not parse under the GFM model ({e}) — conservative refusal"], 0, 0

    def cell_inlines(src, where):
        try:
            return inline_children(src, env)
        except Exception as e:
            viol.append(f"{name}:{where}: inline content cannot be parsed ({e}) — conservative refusal")
            return None

    def split_row(s):
        s = s.strip()
        out, buf, i = [], [], 0
        while i < len(s):
            c = s[i]
            if c == '\\' and i + 1 < len(s):
                nxt = s[i+1]
                if nxt == '|': buf.append('|'); i += 2; continue
                buf.append(c); buf.append(nxt); i += 2; continue
            if c == '|':
                out.append(''.join(buf).strip()); buf = []; i += 1; continue
            buf.append(c); i += 1
        out.append(''.join(buf).strip())
        if out and out[0] == '' and s.startswith('|'): out = out[1:]
        if out and out[-1] == '' and s.endswith('|') and not s.endswith('\\|'): out = out[:-1]
        return out

    SEP = re.compile(r'^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?\s*$')
    header_lines = set()
    for idx, line in enumerate(lines):
        if '|' in line and idx + 1 < len(lines) and SEP.match(lines[idx + 1]):
            header_lines.add(idx)
            hdr = split_row(line)
            cols = []
            for i, c in enumerate(hdr):
                ch = cell_inlines(c, idx + 1)
                if ch is None: continue
                try:
                    lab = visible(ch).strip()
                except Unsupported as e:
                    viol.append(f"{name}:{idx+1}: header cell holds an inline construct the parse model does not represent ({e}) — conservative refusal: {c[:50]!r}")
                    continue
                if lab.lower().startswith('status'): cols.append(i)
            if not cols: continue
            j = idx + 2
            while j < len(lines) and '|' in lines[j]:
                row = split_row(lines[j])
                for col in cols:
                    cells += 1
                    cell = row[col] if col < len(row) else ""
                    if not cell:
                        viol.append(f"{name}:{j+1}: MISSING/BLANK status cell (every classified row needs exactly one primary token)")
                        continue
                    ch = cell_inlines(cell, j + 1)
                    if ch is None: continue
                    try:
                        labs = strong_labels(ch)
                        opens = opens_with_strong(ch)
                    except Unsupported as e:
                        viol.append(f"{name}:{j+1}: status cell holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                        continue
                    if not opens or not labs:
                        viol.append(f"{name}:{j+1}: status cell does not OPEN with a strong primary token: {cell[:50]!r}")
                        continue
                    if not token_ok(labs[0]):
                        viol.append(f"{name}:{j+1}: non-legend table status token {labs[0]!r}")
                    for b in labs[1:]:
                        if is_primary_legend(b):
                            viol.append(f"{name}:{j+1}: SECOND primary legend token {b!r} in one status cell (exactly one required)")
                j += 1

    for i, line in enumerate(lines, 1):
        if (i - 1) in header_lines:
            continue
        if ANY_DECL_LINE.search(line):
            toks = INLINE.findall(line) or SEPARATED.findall(line)
            if not toks:
                viol.append(f"{name}:{i}: unparseable **Status declaration (unparseable = violation): {line.strip()[:70]!r}")
            else:
                decls += len(toks)
                ch = cell_inlines(line, i)
                if ch is not None:
                    try:
                        labs = strong_labels(ch)
                    except Unsupported as e:
                        viol.append(f"{name}:{i}: declaration line holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                        labs = None
                    if labs is not None:
                        ci = next((k for k, l in enumerate(labs) if l.lower().startswith('status')), None)
                        if ci is None:
                            viol.append(f"{name}:{i}: declaration carrier not found by the parse model — conservative refusal")
                        else:
                            carrier = labs[ci]
                            after = carrier.split(':', 1)[1].strip() if ':' in carrier else ''
                            if after:
                                primary, tail = after, labs[ci+1:]
                            elif ci + 1 < len(labs):
                                primary, tail = labs[ci+1], labs[ci+2:]
                            else:
                                primary, tail = None, []
                                viol.append(f"{name}:{i}: declaration has no parsed primary token — conservative refusal")
                            if primary is not None and not token_ok(primary):
                                viol.append(f"{name}:{i}: non-legend primary token {primary.strip()!r}")
                            for b in tail:  # SOL-R11-03: exact-one on PROSE too
                                if is_primary_legend(b):
                                    viol.append(f"{name}:{i}: SECOND primary legend token {b!r} on one prose Status declaration (exactly one required)")
        for m in SUB.finditer(line):
            if m.group(1) not in SUB_OK:
                viol.append(f"{name}:{i}: bad sub-annotation {m.group(1)!r}")
        for m in DASHSUB.finditer(line):
            viol.append(f"{name}:{i}: truncated em-dash OPEN form {m.group(0)!r}")
        for m in BAREREF.finditer(line):
            viol.append(f"{name}:{i}: bare REFUSED label [adjudicate if quoted]: {line.strip()[:70]}")
    return viol, decls, cells

# ---- run / coverage (inherited fail-closed machinery) ----------------------
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
    print("CLEAN (coverage validated: every file matched by an expectation; all expectations met)")
    return 0

# ---- self-test -------------------------------------------------------------
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
    # inherited negatives (all polarities preserved under the parse model)
    expect_viol("**Status: MYSTERY** text", "inline seventh token")
    expect_viol("**Status (rung x): MYSTERY** text", "inline-ctx seventh token")
    expect_viol("**Status:** **MYSTERY**.", "separated seventh token")
    expect_viol("**Status: OPEN — and split by owner ruling into two targets** (x):", "overstuffed OPEN token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | **MYSTERY** | n |", "table seventh token")
    expect_viol("| Claim | Status | Note |\n|---|---|---|\n| r1 | plain OPEN | n |", "table cell not strong-token")
    expect_viol("**Status:** **OPEN** *(sub-annotation: UNOPENED)*", "bare sub-annotation")
    expect_viol("**Status: OPEN — UNOPENED**", "em-dash truncation")
    expect_viol("**REFUSED:** example", "bare REFUSED")
    expect_viol("**Status wording that never parses", "unparseable declaration")
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
    expect_viol("~~Status~~ | Claim | Note" + T + "**MYSTERY** | r1 | strikethrough", "STRIKETHROUGH Status header (visible label)")
    expect_viol("<em>Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | inline HTML", "INLINE-HTML Status header (visible label)")
    expect_viol("&#83;tatus | Claim | Note" + T + "**MYSTERY** | r1 | char ref", "CHARACTER-REFERENCE Status header (visible label)")
    expect_viol("![Status](status.png) | Claim | Note" + T + "**MYSTERY** | r1 | image alt", "IMAGE-ALT Status header (visible label)")
    expect_viol("Status | <!-- a > b -->Status | Claim" + T + "**OPEN** | **MYSTERY** | r1", "COMMENT-hidden SECOND Status column beside valid decoy")
    expect_viol("*Status* | Claim | Note" + T + " | r1 | italic hdr blank", "ITALIC header with blank cell")
    expect_viol("Claim \\| kind | Status | Note" + T + "r1 | **MYSTERY** | **OPEN**", "HEADER-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 \\| **OPEN** | **MYSTERY** | note", "DATA-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORICAL__ | two strong", "DOUBLE primary (** and __)")
    expect_viol("Claim | Status | Status" + T + "r1 | **OPEN** | **MYSTERY**", "SECOND Status column validated")
    expect_viol("<em title=\">\">Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | quoted-attr", "QUOTE-ATTR HTML Status header")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORIC&#65;L__ | rendered", "ENTITY-bearing strong second primary")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL](https://example.com)__ | rendered", "LINK-bearing strong second primary")
    expect_viol("STATUS NOW | Claim | Note" + T + " | r1 | blank", "uppercase-STATUS blank cell")
    # SOL-R11 exact witnesses
    expect_viol("Claim | <!-- a > b -->Status | Note" + T + "r1 | **MYSTERY** | hidden column", "SOL-R11-01: COMMENT-hidden single Status column")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL]__ | second primary\n\n[HISTORICAL]: https://example.com/history", "SOL-R11-02: SHORTCUT-reference strong second primary")
    expect_viol("**Status: OPEN** / **HISTORICAL**", "SOL-R11-03: PROSE double primary")
    # no-input + empty-file (run-level)
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
    expect_clean("**Status** | Claim | Note" + T + "**OPEN** *(sub-annotation: OPEN-UNOPENED)* | r1 | n", "bold header + valid row, no prose misread", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 \\| detail | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "escaped-pipe companion", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 | __OPEN__ *(sub-annotation: OPEN-UNOPENED)* | n", "__OPEN__ semantic primary", want_cells=1)
    expect_clean("Claim | Status | Status" + T + "r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | **HISTORICAL**", "two valid Status columns both counted", want_cells=2)
    expect_clean("Claim | Status | Note" + T + "r1 | **OPEN** *(see __[note](https://x)__)* | n", "non-legend strong link non-primary", want_cells=1)
    # SOL-R11 companions
    expect_clean("Claim | <!-- legal comment -->Other | Status" + T + "r1 | x | **OPEN** *(sub-annotation: OPEN-UNOPENED)*", "comment in UNRELATED header; Status counted once", want_cells=1)
    expect_clean("Claim | Status | Note" + T + "r1 | **OPEN** *(cf. __[note]__)* | n\n\n[note]: https://example.com/n", "non-legend SHORTCUT-reference strong annotation non-primary", want_cells=1)
    expect_clean("**Status: OPEN** *(single primary; see also HISTORICAL in plain text)*", "single-primary prose declaration", want_decls=1)
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
