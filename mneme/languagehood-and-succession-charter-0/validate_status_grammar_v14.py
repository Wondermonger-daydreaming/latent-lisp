#!/usr/bin/env python3
"""Status-grammar validator v14 — FAIL-CLOSED (SOL-R14-01/02 repair;
replaces validate_status_grammar_v13.py, whose ambiguity guard was a
case-sensitive regex over isolated token payloads: it recognized only the
literal spelling `**Status` inside a single text/code token, so unresolved
`__Status` and case variants were silent, and an unresolved visible
`**Status` split across link or transparent inline tokens was silent —
the receptionist checked each syllable's passport separately and missed
the word). v13 stays byte-identical in the frozen R0.14 stratum.

THE ENFORCEMENT WALK ASSIGNS EVERY SEMANTIC NODE CLASS A ROLE:
  - RAW-HTML POLICY (SOL-R13-01, explicit and fail-closed, both token
    classes): inline `<strong>`/`<b>` open/close tags are INTERPRETED as
    strong boundaries — a visible raw-HTML strong Status carrier is
    discovered and validated exactly like a Markdown one. Malformed,
    self-closing, interleaved, or unclosed raw strong structure is a
    conservative refusal. Other inline raw HTML (comments, non-strong tags)
    contributes no strong rendering and is documented-transparent. An
    html_block whose content holds Status-like text or a strong/b tag is a
    conservative refusal; unrelated raw HTML blocks pass. Nothing raw is
    silently skipped.
  - WHOLE-SURFACE, ORDER-INVARIANT EXACT-ONE (SOL-R13-02): all Status
    carriers and all strong labels on a surface are inventoried BEFORE role
    assignment; each carrier takes exactly one primary (its colon tail, or
    the next strong label, consumed); on a carrier-bearing surface EVERY
    unbound primary-legend label is a violation — before, between, or after
    the carriers alike.
  - SURFACE-LEVEL AMBIGUITY INVENTORY (SOL-R14-01/02): each surface's
    VISIBLE text is reconstructed from the parser stream — text, decoded
    character references, code spans, and image alt text flow in; breaks
    flow as whitespace; parser-resolved emphasis/strong/strike/link
    boundaries and invisible payloads (link destinations, raw-HTML tags
    with their attributes, comment bodies) contribute nothing. On that
    stream, an unresolved strong-like Status spelling — EITHER delimiter
    (`**` or `__`), case-insensitive like the carrier policy itself — is a
    conservative refusal. A resolved carrier's delimiters are consumed by
    the parser and never reach the stream, so a valid carrier clears only
    its own construct; a spelling split by a comment or a link rejoins;
    invisible text never counts. One policy for prose, Status cells,
    non-Status cells, header cells, code spans, and code blocks.
  - TABLE-CELL SEMANTIC INVENTORY (SOL-R13-04): in a Status cell, any
    later strong label that is itself a Status carrier is refused (explicit
    table policy: a strong Status carrier is not an inert annotation);
    non-legend strong annotations stay legal. Non-Status cells are also
    inventoried: a strong Status carrier or an unresolved `**Status`
    spelling there is a conservative refusal — nothing disappears merely
    because the table range is excluded from prose processing.

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
AMBIG_STATUSISH = re.compile(r'(\*\*|__)status', re.I)  # unresolved strong-like spelling — refusal only, never gates discovery
STRONG_TAG_ANY = re.compile(r'<\s*/?\s*(strong|b)\b', re.I)
HTML_BLOCK_RISK = re.compile(r'<\s*/?\s*(strong|b)\b|status', re.I)

class Unsupported(Exception): pass
TRANSPARENT_INLINE = {'em_open', 'em_close', 'link_open', 'link_close',
                      's_open', 's_close'}
TEXTY = {'text', 'code_inline', 'text_special'}

def html_inline_role(content):
    """Explicit raw-HTML inline policy (SOL-R13-01). Returns one of:
    'strong_open' / 'strong_close' — an interpreted <strong>/<b> boundary;
    'transparent' — markup that cannot create a strong rendering
    (comments, PIs, declarations, CDATA, non-strong tags);
    'refuse' — raw strong structure the model will not represent
    (self-closing, quoted-'>' attributes, malformed) — fail closed."""
    c = (content or '').strip()
    if c.startswith('<!--') or c.startswith('<?') or c.startswith('<!'):
        return 'transparent'
    m = re.match(r'^<\s*/?\s*([A-Za-z][A-Za-z0-9-]*)', c)
    if not m:
        return 'refuse'
    if m.group(1).lower() not in ('strong', 'b'):
        return 'transparent'
    if re.match(r'^<\s*/\s*(strong|b)\s*>$', c, re.I):
        return 'strong_close'
    if c.endswith('/>'):
        return 'refuse'
    if re.match(r'^<\s*(strong|b)(\s[^>]*)?>$', c, re.I | re.S):
        return 'strong_open'
    return 'refuse'

def visible(children):
    out = []
    for tok in children or []:
        if tok.type in TEXTY: out.append(tok.content)
        elif tok.type == 'image': out.append(visible(tok.children))
        elif tok.type in ('softbreak', 'hardbreak'): out.append(' ')
        elif tok.type == 'html_inline': pass  # markup contributes no visible text
        elif tok.type in ('strong_open', 'strong_close'): pass
        elif tok.type in TRANSPARENT_INLINE: pass
        else: raise Unsupported(tok.type)
    return ''.join(out)

def label_inventory(children):
    """Top-level strong labels on a surface, with raw-HTML <strong>/<b>
    interpreted as strong boundaries (SOL-R13-01). Interleaved or unclosed
    strong structure — Markdown or raw — is Unsupported (fail closed)."""
    labels, stack, buf = [], [], []
    for tok in children or []:
        role = None
        if tok.type == 'strong_open': role = ('open', 'md')
        elif tok.type == 'strong_close': role = ('close', 'md')
        elif tok.type == 'html_inline':
            r = html_inline_role(tok.content)
            if r == 'strong_open': role = ('open', 'html')
            elif r == 'strong_close': role = ('close', 'html')
            elif r == 'refuse':
                raise Unsupported(f"raw HTML {(tok.content or '').strip()[:30]!r}")
        if role and role[0] == 'open':
            stack.append(role[1])
            if len(stack) == 1: buf = []
            continue
        if role and role[0] == 'close':
            if not stack or stack.pop() != role[1]:
                raise Unsupported("interleaved raw-HTML/Markdown strong nesting")
            if not stack: labels.append(visible(buf).strip())
            continue
        if stack: buf.append(tok)
        elif tok.type in TEXTY or tok.type == 'image' \
             or tok.type in ('softbreak', 'hardbreak') \
             or tok.type in TRANSPARENT_INLINE or tok.type == 'html_inline':
            pass
        else: raise Unsupported(tok.type)
    if stack:
        raise Unsupported("unclosed strong structure (Markdown or raw <strong>/<b>)")
    return labels

def visible_stream(children):
    """The surface's VISIBLE text with parser-resolved constructs consumed:
    text, decoded character references, code spans, and image alt text flow
    in; soft/hard breaks flow as whitespace; markup boundaries (resolved
    strong/emphasis/strike/link delimiters) and invisible payloads (link
    destinations, raw-HTML tags including attributes and comment bodies)
    contribute nothing — a split visible spelling rejoins, invisible text
    never counts (SOL-R14-02)."""
    out = []
    for tok in children or []:
        if tok.type in TEXTY: out.append(tok.content or '')
        elif tok.type == 'image': out.append(visible_stream(tok.children))
        elif tok.type in ('softbreak', 'hardbreak'): out.append(' ')
        else: pass  # markup / invisible payloads
    return ''.join(out)

def surface_ambiguity(children):
    """Unresolved strong-like Status spellings on the reconstructed visible
    surface — both Markdown strong delimiters, case-insensitive consistent
    with the carrier policy (SOL-R14-01)."""
    s = visible_stream(children)
    return [s[m.start():m.start() + 50] for m in AMBIG_STATUSISH.finditer(s)]

def opens_with_strong(children):
    for tok in children or []:
        if tok.type in TEXTY and not tok.content.strip(): continue
        if tok.type == 'strong_open': return True
        if tok.type == 'html_inline' and html_inline_role(tok.content) == 'strong_open':
            return True
        return False
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

def is_carrier(s):
    return s.strip().lower().startswith('status')

def check_text(text, name):
    viol, decls, cells = [], 0, 0
    env = {}
    try:
        toks = MD.parse(text, env)
    except Exception as e:
        return [f"{name}: document does not parse under the GFM model ({e}) — conservative refusal"], 0, 0

    def lineof(tok, fallback):
        return (tok.map[0] + 1) if getattr(tok, 'map', None) else fallback

    i, n = 0, len(toks)
    while i < n:
        t = toks[i]
        if t.type == 'html_block':
            where = lineof(t, 0)
            if HTML_BLOCK_RISK.search(t.content or ''):
                viol.append(f"{name}:{where}: raw HTML block with Status-like or strong content — outside the parse model, fail-closed refusal: {(t.content or '').strip()[:60]!r}")
            i += 1; continue
        if t.type in ('fence', 'code_block'):
            where = lineof(t, 0)
            if AMBIG_STATUSISH.search(t.content or ''):
                viol.append(f"{name}:{where}: unresolved strong-like Status spelling inside a code block — conservative refusal")
            i += 1; continue
        if t.type == 'table_open':
            tline = lineof(t, 0)
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
                for h in surface_ambiguity(th.children):
                    viol.append(f"{name}:{tline}: unresolved strong-like Status spelling in a header cell — conservative refusal: {h!r}")
            # SOL-R13-04 (category): non-Status cells are inventoried too —
            # a strong Status carrier or an unresolved `**Status` spelling
            # cannot disappear into an unprocessed table range.
            for row, rline in rows:
                for ci, cell_tok in enumerate(row):
                    if ci in cols: continue
                    ch = cell_tok.children
                    where = lineof(cell_tok, rline)
                    for h in surface_ambiguity(ch):
                        viol.append(f"{name}:{where}: unresolved strong-like Status spelling in a table cell (visible surface resolves no carrier there) — conservative refusal: {h!r}")
                    try:
                        labs = label_inventory(ch)
                    except Unsupported:
                        if AMBIG_STATUSISH.search(cell_tok.content or '') or STRONG_TAG_ANY.search(cell_tok.content or ''):
                            viol.append(f"{name}:{where}: Status-like or raw-strong table cell holds a construct the parse model does not represent — conservative refusal")
                        continue
                    for b in labs:
                        if is_carrier(b):
                            viol.append(f"{name}:{where}: strong Status carrier {b!r} in a non-Status table cell — a carrier is not an inert annotation (explicit table policy: refused)")
            if not cols: continue
            for row, rline in rows:
                for col in cols:
                    cells += 1
                    cell_tok = row[col] if col < len(row) else None
                    ch = cell_tok.children if cell_tok is not None else []
                    where = lineof(cell_tok, rline) if cell_tok is not None else rline
                    for h in surface_ambiguity(ch):
                        viol.append(f"{name}:{where}: unresolved strong-like Status spelling in a status cell (visible surface resolves no carrier there) — conservative refusal: {h!r}")
                    try:
                        vis = visible(ch).strip()
                        labs = label_inventory(ch)
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
                        elif is_carrier(b):
                            viol.append(f"{name}:{where}: strong Status carrier {b!r} after the primary in one status cell — a carrier is not an inert annotation (explicit table policy: refused)")
            continue
        if t.type == 'inline':
            where = lineof(t, 0)
            for h in surface_ambiguity(t.children):
                viol.append(f"{name}:{where}: unresolved strong-like Status spelling (visible surface resolves no carrier there) — conservative refusal: {h!r}")
            try:
                labs = label_inventory(t.children)
            except Unsupported as e:
                if AMBIG_STATUSISH.search(t.content or '') or STRONG_TAG_ANY.search(t.content or ''):
                    viol.append(f"{name}:{where}: Status-like or raw-strong surface holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                i += 1; continue
            # SOL-R13-02: whole-surface inventory before role assignment.
            carriers = {k for k, lab in enumerate(labs) if is_carrier(lab)}
            consumed = set()
            decls += len(carriers)
            for k in sorted(carriers):
                lab = labs[k]
                after = lab.split(':', 1)[1].strip() if ':' in lab else ''
                if after:
                    primary = after
                elif k + 1 < len(labs) and (k + 1) not in carriers:
                    primary = labs[k + 1]; consumed.add(k + 1)
                else:
                    viol.append(f"{name}:{where}: declaration has no parsed primary token — conservative refusal")
                    continue
                if not token_ok(primary):
                    viol.append(f"{name}:{where}: non-legend primary token {primary.strip()!r}")
            if carriers:
                for k, lab in enumerate(labs):
                    if k in carriers or k in consumed: continue
                    if is_primary_legend(lab):
                        viol.append(f"{name}:{where}: UNBOUND primary legend token {lab!r} on a prose Status declaration surface (whole-surface exact-one, order-invariant)")
        i += 1

    for ln, line in enumerate(text.splitlines(), 1):
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
    # SOL-R13 exact witnesses
    expect_viol("<strong>Status: MYSTERY</strong>", "SOL-R13-01: inline raw-HTML strong carrier")
    expect_viol("<strong>\nStatus: MYSTERY\n</strong>", "SOL-R13-01: block-form raw-HTML strong carrier")
    expect_viol("**HISTORICAL** / **Status: OPEN**", "SOL-R13-02: primary legend before valid carrier")
    expect_viol("**Status wording that never parses and **Status: OPEN**", "SOL-R13-03: valid carrier beside unresolved **Status spelling")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / **Status: MYSTERY** | hidden secondary carrier", "SOL-R13-04: later Status carrier in a status cell")
    # SOL-R14 exact witnesses
    expect_viol("__Status wording that never parses", "SOL-R14-01: lone underscore unresolved spelling")
    expect_viol("**status wording that never parses", "SOL-R14-01: case-variant unresolved spelling")
    expect_viol("__Status wording that never parses and **Status: OPEN**", "SOL-R14-01: underscore unresolved beside valid carrier")
    expect_viol("**[Status](https://example.com/status) wording that never parses and **Status: OPEN**", "SOL-R14-02: link-split unresolved spelling beside valid carrier")
    expect_viol("**Sta<!--x-->tus wording that never parses and **Status: OPEN**", "SOL-R14-02: comment-split unresolved spelling beside valid carrier")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __Status wording that never parses | hidden ambiguity", "SOL-R14-01: underscore unresolved in a status cell")
    expect_viol("Claim | Note | Status" + T + "r1 | **[Status](https://example.com/status) wording that never parses | **OPEN**", "SOL-R14-02: link-split unresolved in a non-Status cell")
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
    # SOL-R13 companions
    expect_clean("**NOTE** precedes **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "non-legend strong annotation before valid carrier", want_decls=1)
    expect_clean("Preamble line one of a soft-wrapped paragraph\n**Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "valid carrier on second physical line of one paragraph", want_decls=1)
    expect_clean("<span>ornament</span> **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.\n\n<div>unrelated raw block</div>", "unrelated raw HTML beside valid Markdown carrier", want_decls=1)
    # SOL-R14 companions
    expect_clean("__[Status](https://example.com/status): OPEN__ *(sub-annotation: OPEN-UNOPENED)*.", "resolved underscore link-bearing carrier", want_decls=1)
    expect_clean("[ok](https://example.com/__Status) plain sentence.", "__Status only in an invisible link destination", want_decls=0)
    expect_clean("<span data-note=\"__Status\">x</span> **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "__Status only in a raw-HTML attribute beside valid carrier", want_decls=1)
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
