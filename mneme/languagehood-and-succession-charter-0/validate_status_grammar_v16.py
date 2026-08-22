#!/usr/bin/env python3
"""Status-grammar validator v16 — FAIL-CLOSED (SOL-R16-01/02/03 repair;
replaces validate_status_grammar_v15.py, whose remaining defects were
routing: table headers never entered the exact-identity recursive
strong-node walk (a mismatched `<strong>Status</b>` header passed beside a
valid row; a nested Status header disappeared into its ancestor's label),
inline raw HTML had no visibility state (script bodies counted as visible
text, `<br>` separation was deleted), and invisible Unicode format
characters severed Status recognition while changing no rendered glyph.
v15 stays byte-identical in the frozen R0.16 stratum.

ONE WALKER, ONE VISIBILITY MODEL, EVERY SURFACE:
  - THE SHARED INLINE PROJECTION (SOL-R16-02, commission steps 7-9): a
    single stateful walk produces BOTH the visible stream and the
    recursive strong-label inventory for every inline surface — prose,
    headers, Status cells, non-Status cells alike. Under its element
    policy: script/style bodies contribute no text; separation-rendering
    tags contribute whitespace (they never silently fuse words); comments
    and non-separating markup fuse (they never split words); attributes
    and tag syntax contribute nothing; unclosed or mismatched stateful
    scopes are unrepresentable. There are no parallel visibility helpers
    to disagree.
  - HEADERS ENTER THE WALK (SOL-R16-01, steps 4-6): every header cell
    passes through the same walk before column-role assignment.
    Mismatched, interleaved, malformed, or unclosed raw strong structure
    in a header refuses before CLEAN. Explicit descendant rule: a header
    whose projected text names the column classifies it; a descendant
    Status label inside a non-Status header is an ambiguous header and
    refuses — it cannot disappear because an ancestor contributes the
    first visible word.
  - BOUNDED UNICODE-FORMAT POLICY (SOL-R16-03, steps 10-11): if a
    surface's projected text contains any Unicode `Cf` format character
    and its Cf-stripped text spells `status` (case-insensitive), the
    surface is a conservative refusal — an invisible formatting code
    point must not make the exact word disappear. Applied uniformly to
    prose, headers, both table-cell classes, inline and block
    projections, code spans, and code blocks. This is comparison-only
    stripping for refusal — NOT general NFKC or confusable folding.
  - Inherited: html_block visibility projection; exact raw strong tag
    identity; recursive strong-node inventory in document order; the
    symmetric case-insensitive `**`/`__` ambiguity inventory; whole-
    surface order-invariant exact-one; explicit table policies.

REPRODUCIBILITY SURFACE (commission step 16): requires markdown-it-py
(tested with 4.0.0 and 3.0.0) with its core 'table' and 'strikethrough'
rules enabled. If the dependency is absent the validator exits 3 with a
controlled diagnostic, never an import traceback.
"""
import re, sys, html as _html, unicodedata

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
STATUS_WORD = re.compile(r'status', re.I)

class Unsupported(Exception): pass
TRANSPARENT_INLINE = {'em_open', 'em_close', 'link_open', 'link_close',
                      's_open', 's_close'}
TEXTY = {'text', 'code_inline', 'text_special'}

SEPARATION_TAGS = {
    'address', 'article', 'aside', 'blockquote', 'body', 'br', 'caption',
    'center', 'col', 'colgroup', 'dd', 'details', 'dialog', 'div', 'dl',
    'dt', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2',
    'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'iframe',
    'legend', 'li', 'main', 'menu', 'nav', 'ol', 'optgroup', 'option', 'p',
    'pre', 'section', 'source', 'summary', 'table', 'tbody', 'td', 'tfoot',
    'th', 'thead', 'title', 'tr', 'track', 'ul'}
INVISIBLE_CONTENT_TAGS = {'script', 'style'}

def cf_status_hits(text):
    """Bounded Unicode-format policy (SOL-R16-03): a surface containing any
    `Cf` format character whose Cf-stripped text spells `status`
    (case-insensitive) is a disguised Status-like surface — conservative
    refusal, comparison-only stripping, no general confusable/NFKC
    folding."""
    if not any(unicodedata.category(c) == 'Cf' for c in text or ''):
        return []
    stripped = ''.join(c for c in text if unicodedata.category(c) != 'Cf')
    if STATUS_WORD.search(stripped):
        return [stripped[max(0, m.start() - 10):m.start() + 40]
                for m in STATUS_WORD.finditer(stripped)][:1]
    return []

def html_inline_role(content):
    """Explicit raw-HTML inline policy. Returns (role, tag):
    'strong_open'/'strong_close' — interpreted <strong>/<b> boundary with
    exact tag identity (SOL-R15-02);
    'invisible_open'/'invisible_close' — script/style content scope
    (bodies contribute no visible text, SOL-R16-02);
    'separation' — a tag that renders separation (contributes whitespace,
    never fuses words);
    'transparent' — comments/PIs/declarations/CDATA and non-separating
    markup (fuse; contribute nothing);
    'refuse' — raw structure the model will not represent — fail closed."""
    c = (content or '').strip()
    if c.startswith('<!--') or c.startswith('<?') or c.startswith('<!'):
        return ('transparent', None)
    m = re.match(r'^<\s*(/?)\s*([A-Za-z][A-Za-z0-9-]*)', c)
    if not m:
        return ('refuse', None)
    closing, tag = bool(m.group(1)), m.group(2).lower()
    if tag in ('strong', 'b'):
        if re.match(r'^<\s*/\s*(strong|b)\s*>$', c, re.I):
            return ('strong_close', tag)
        if c.endswith('/>'):
            return ('refuse', tag)
        if re.match(r'^<\s*(strong|b)(\s[^>]*)?>$', c, re.I | re.S):
            return ('strong_open', tag)
        return ('refuse', tag)
    if tag in INVISIBLE_CONTENT_TAGS:
        if closing:
            return ('invisible_close', tag)
        if c.endswith('/>'):
            return ('refuse', tag)
        return ('invisible_open', tag)
    if tag in SEPARATION_TAGS:
        return ('separation', tag)
    return ('transparent', tag)

def walk_inline(children):
    """THE shared stateful visibility walk (SOL-R16-02, steps 7-9): one
    pass produces (stream, labels) — the projected visible text of the
    surface AND the recursive strong-node inventory (every node at every
    depth, document order of opening, exact construct identity on the
    stack). Script/style bodies are suppressed; separation tags emit
    whitespace; comments and non-separating markup fuse; attributes and
    tag syntax emit nothing. Mismatched, interleaved, unclosed strong or
    element scope is Unsupported (fail closed). All carrier discovery,
    header discovery, ambiguity detection, and label construction read
    from this one projection."""
    labels, stack, stream = [], [], []   # stack frames: [kind, label_idx, parts]
    elems = []                           # open invisible-content scopes
    def emit(s):
        if elems: return                 # invisible scope: no visible text
        stream.append(s)
        for fr in stack: fr[2].append(s)
    for tok in children or []:
        if tok.type == 'html_inline':
            role, tag = html_inline_role(tok.content)
            if role == 'refuse':
                raise Unsupported(f"raw HTML {(tok.content or '').strip()[:30]!r}")
            if role == 'invisible_open':
                elems.append(tag); continue
            if role == 'invisible_close':
                if not elems or elems[-1] != tag:
                    raise Unsupported(f"mismatched </{tag}> content scope")
                elems.pop(); continue
            if role == 'separation':
                emit(' '); continue
            if role == 'strong_open':
                if elems: continue       # strong markup inside invisible scope
                labels.append(None)
                stack.append(['html:' + tag, len(labels) - 1, []])
                continue
            if role == 'strong_close':
                if elems: continue
                if not stack or stack[-1][0] != 'html:' + tag:
                    raise Unsupported("mismatched or interleaved strong structure (a close must match its exact opener)")
                _, idx, parts = stack.pop()
                labels[idx] = ''.join(parts).strip()
                continue
            continue                      # transparent markup
        if tok.type == 'strong_open':
            if elems: continue
            labels.append(None)
            stack.append(['md', len(labels) - 1, []])
            continue
        if tok.type == 'strong_close':
            if elems: continue
            if not stack or stack[-1][0] != 'md':
                raise Unsupported("mismatched or interleaved strong structure (a close must match its exact opener)")
            _, idx, parts = stack.pop()
            labels[idx] = ''.join(parts).strip()
            continue
        if tok.type in TEXTY: emit(tok.content or '')
        elif tok.type == 'image': emit(walk_inline(tok.children)[0])
        elif tok.type in ('softbreak', 'hardbreak'): emit(' ')
        elif tok.type in TRANSPARENT_INLINE: pass
        else: raise Unsupported(tok.type)
    if stack:
        raise Unsupported("unclosed strong structure (Markdown or raw <strong>/<b>)")
    if elems:
        raise Unsupported(f"unclosed <{elems[-1]}> content scope")
    labels = [l for l in labels if l is not None] if all(l is not None for l in labels) else labels
    if any(l is None for l in labels):
        raise Unsupported("strong structure resolved out of order")
    return ''.join(stream), labels

def project_html_block(src):
    """Visibility projection of a raw HTML block (SOL-R15-01). Returns
    (visible_text, refuse_reason_or_None)."""
    out, i, n = [], 0, len(src or '')
    while i < n:
        c = src[i]
        if c == '<':
            if src.startswith('<!--', i):
                j = src.find('-->', i + 4)
                if j < 0: return '', 'holds an unterminated comment'
                i = j + 3; continue                    # comment: fuse
            if src.startswith('<![CDATA[', i):
                j = src.find(']]>', i + 9)
                if j < 0: return '', 'holds an unterminated CDATA section'
                out.append(src[i + 9:j]); i = j + 3; continue
            if src.startswith('<?', i):
                j = src.find('?>', i + 2)
                if j < 0: return '', 'holds an unterminated processing instruction'
                i = j + 2; continue
            if src.startswith('<!', i):
                j = src.find('>', i + 2)
                if j < 0: return '', 'holds an unterminated declaration'
                i = j + 1; continue
            m = re.match(r'<\s*(/?)\s*([A-Za-z][A-Za-z0-9-]*)((?:"[^"]*"|\'[^\']*\'|[^>"\'])*)>', src[i:])
            if not m:
                return '', f'holds raw HTML the projection cannot represent ({src[i:i+20]!r})'
            name = m.group(2).lower()
            if name in ('strong', 'b'):
                return '', 'holds raw <strong>/<b> markup (strong semantics unrepresentable at block level)'
            if name in INVISIBLE_CONTENT_TAGS and not m.group(1):
                close = re.search(r'<\s*/\s*' + name + r'\s*>', src[i:], re.I)
                if not close: return '', f'holds an unterminated <{name}> element'
                i += close.end(); continue             # content invisible
            out.append(' ' if name in SEPARATION_TAGS else '')
            i += m.end(); continue
        out.append(c); i += 1
    return _html.unescape(''.join(out)), None

def opens_with_strong(children):
    for tok in children or []:
        if tok.type in TEXTY and not tok.content.strip(): continue
        if tok.type == 'strong_open': return True
        if tok.type == 'html_inline' and html_inline_role(tok.content)[0] == 'strong_open':
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

def stream_screens(stream, name, where, ctx):
    """The two string-level screens every projected surface passes:
    the symmetric unresolved-spelling inventory and the bounded
    Unicode-format policy. One projection in, violations out."""
    v = []
    for m in AMBIG_STATUSISH.finditer(stream):
        v.append(f"{name}:{where}: unresolved strong-like Status spelling{ctx} (visible surface resolves no carrier there) — conservative refusal: {stream[m.start():m.start()+50]!r}")
    for h in cf_status_hits(stream):
        v.append(f"{name}:{where}: invisible Unicode format character on a Status-like surface{ctx} (Cf-stripped text spells 'status') — conservative refusal: {h!r}")
    return v

def raw_risky(raw):
    """Fallback screen for surfaces the walk cannot represent: refuse if
    the raw source is Status-risky."""
    raw = raw or ''
    return bool(AMBIG_STATUSISH.search(raw) or STRONG_TAG_ANY.search(raw)
                or cf_status_hits(raw))

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
            proj, reason = project_html_block(t.content or '')
            if reason:
                viol.append(f"{name}:{where}: raw HTML block {reason} — conservative refusal")
            else:
                viol.extend(stream_screens(proj, name, where, " on the visible surface of a raw HTML block"))
            i += 1; continue
        if t.type in ('fence', 'code_block'):
            where = lineof(t, 0)
            if AMBIG_STATUSISH.search(t.content or ''):
                viol.append(f"{name}:{where}: unresolved strong-like Status spelling inside a code block — conservative refusal")
            for h in cf_status_hits(t.content or ''):
                viol.append(f"{name}:{where}: invisible Unicode format character on a Status-like surface inside a code block — conservative refusal: {h!r}")
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
            # Headers enter the SAME walk (SOL-R16-01): exact identity,
            # recursive inventory, shared projection, then column roles.
            cols = []
            for ci, th in enumerate(header):
                try:
                    stream, labs = walk_inline(th.children)
                except Unsupported as e:
                    viol.append(f"{name}:{tline}: header cell holds a construct the parse model does not represent ({e}) — conservative refusal")
                    continue
                viol.extend(stream_screens(stream, name, tline, " in a header cell"))
                if stream.strip().lower().startswith('status'):
                    cols.append(ci)
                elif any(is_carrier(l) for l in labs):
                    viol.append(f"{name}:{tline}: descendant Status label inside a non-Status header — ambiguous header, conservative refusal")
            for row, rline in rows:
                for ci, cell_tok in enumerate(row):
                    if ci in cols: continue
                    where = lineof(cell_tok, rline)
                    try:
                        stream, labs = walk_inline(cell_tok.children)
                    except Unsupported:
                        if raw_risky(cell_tok.content):
                            viol.append(f"{name}:{where}: Status-like or raw-strong table cell holds a construct the parse model does not represent — conservative refusal")
                        continue
                    viol.extend(stream_screens(stream, name, where, " in a table cell"))
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
                    try:
                        stream, labs = walk_inline(ch)
                        opens = opens_with_strong(ch)
                    except Unsupported as e:
                        viol.append(f"{name}:{where}: status cell holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                        continue
                    viol.extend(stream_screens(stream, name, where, " in a status cell"))
                    vis = stream.strip()
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
            try:
                stream, labs = walk_inline(t.children)
            except Unsupported as e:
                if raw_risky(t.content):
                    viol.append(f"{name}:{where}: Status-like or raw-strong surface holds an inline construct the parse model does not represent ({e}) — conservative refusal")
                i += 1; continue
            viol.extend(stream_screens(stream, name, where, ""))
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
    # SOL-R15 exact witnesses
    expect_viol("<div>\n**Sta<!-- invisible -->tus wording that never parses\n</div>", "SOL-R15-01: comment-split spelling inside an HTML block")
    expect_viol("<div>\n__Sta&#116;us wording that never parses\n</div>", "SOL-R15-01: entity-split spelling inside an HTML block")
    expect_viol("<strong>Status: OPEN</b>", "SOL-R15-02: mismatched raw strong close")
    expect_viol("<strong>NOTE <b>ornament</strong></b> and **Status: OPEN**", "SOL-R15-02: interleaved raw strong beside valid carrier")
    expect_viol("<strong>NOTE <strong>Status: MYSTERY</strong></strong>", "SOL-R15-03: nested raw/raw descendant carrier")
    expect_viol("<strong>NOTE **Status: MYSTERY**</strong>", "SOL-R15-03: nested raw/Markdown descendant carrier")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / <strong>NOTE <strong>Status: MYSTERY</strong></strong> | hidden", "SOL-R15-03: nested descendant carrier after valid table primary")
    # SOL-R16 exact witnesses
    expect_viol("Claim | <strong>Status</b> | Note" + T + "r1 | **OPEN** | malformed header boundary", "SOL-R16-01: mismatched raw strong header beside valid row")
    expect_viol("Claim | <strong>NOTE <strong>Status</strong></strong> | Note" + T + "r1 | **MYSTERY** | descendant header label", "SOL-R16-01: nested raw/raw Status header hiding invalid token")
    expect_viol("Claim | <strong>NOTE **Status**</strong> | Note" + T + "r1 | **MYSTERY** | descendant header label", "SOL-R16-01: nested raw/Markdown Status header hiding invalid token")
    expect_viol("**Sta<script>invisible</script>tus: MYSTERY**", "SOL-R16-02: script-split visible prose carrier")
    expect_viol("Claim | Sta<style>x</style>tus | Note" + T + "r1 | **MYSTERY** | visually Status", "SOL-R16-02: style-split visible Status header")
    expect_viol("**Sta&#x200B;tus: MYSTERY**", "SOL-R16-03: U+200B prose carrier")
    expect_viol("Claim | Sta⁠tus | Note" + T + "r1 | **MYSTERY** | visually Status", "SOL-R16-03: U+2060 Status header")
    expect_viol("<div>\n**Sta&#xFEFF;tus wording that never parses\n</div>", "SOL-R16-03: U+FEFF projected block ambiguity")
    expect_viol("```\n**Sta​tus wording that never parses\n```", "SOL-R16-03: format-character code-block ambiguity")
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
    # SOL-R15 companions
    expect_clean("<div data-note=\"__Status\">\nordinary visible text\n</div>", "Status only in an HTML-block attribute, visible text ordinary", want_decls=0, want_cells=0)
    expect_clean("<strong>Status: OPEN</strong> stands.", "matched raw strong carrier counted once", want_decls=1)
    expect_clean("<strong>see <b>note</b></strong> and **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "legal nested non-carrier annotation beside valid carrier", want_decls=1)
    # SOL-R16 companions
    expect_clean("Claim | <strong>Status</strong> | Note" + T + "r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | matched header", "matched raw strong Status header + valid cell", want_cells=1)
    expect_clean("<strong>see <b>note</b></strong> | Status | Note" + T + "x | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "nested non-Status header annotation, no phantom column", want_cells=1)
    expect_clean("ordinary visible text <script>**Status wording that never parses</script>", "Status-like text confined to invisible script body", want_decls=0)
    expect_clean("**Sta<br>tus: MYSTERY** stays separated.", "br-separated Sta tus never becomes a carrier", want_decls=0)
    expect_clean("An ordinary visibly separated Sta tus control.", "plain separated Sta tus non-carrier", want_decls=0)
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
