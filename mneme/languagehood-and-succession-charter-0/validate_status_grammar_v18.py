#!/usr/bin/env python3
r"""Status-grammar validator v18 — THE ENUMERATED SOURCE REPERTOIRE
(SOL-R18-01/02/03/04 repair: "the source law must enumerate its
citizens, not merely describe several classes of foreigners." Replaces
validate_status_grammar_v17.py — whose category-based P2/P2b closed the
border only over Unicode letters and format/control classes, admitting
default-ignorable marks such as U+034F COMBINING GRAPHEME JOINER and
U+FE00 VARIATION SELECTOR-1 into reader-visible Status words. v17 stays
byte-identical in the frozen R0.18 stratum. The profile lineage (owner
disposition of 2026-08-12, on Sol's architectural recommendation after the
R0.16 readback: stop inferring normative meaning from arbitrary rendered
GFM; define a small permitted source language for governed documents and
refuse everything outside it at the gate. "The renderer displays the
charter; it is not itself the law." Replaces validate_status_grammar_v16.py,
whose open-ended rendering model — raw-HTML visibility projections, element
stacks, tag-identity boundaries, Cf-comparison policies — is DELETED, not
extended: those inputs are no longer interpreted, they are not in the
language. v16 stays byte-identical in the frozen R0.17 stratum.

THE GOVERNED DOCUMENT LANGUAGE (the profile):
  SOURCE LAW (checked on the raw text, before parsing):
    P1  the text is in Unicode NFC (it equals its own NFC normalization);
    P2  THE ADMITTED SOURCE REPERTOIRE (SOL-R18-01): every code point in
        the document must be one of — horizontal tab U+0009; line feed
        U+000A; printable ASCII U+0020-U+007E; or exactly the eighteen
        non-ASCII code points the governed corpus already uses
        (U+00A7 § · U+00B7 · · U+00D7 × · U+03B1 α · U+03B2 β ·
        U+03B4 δ · U+2013 – · U+2014 — · U+2026 … · U+2190 ← ·
        U+2192 → · U+21D2 ⇒ · U+2212 − · U+2227 ∧ · U+2260 ≠ ·
        U+2265 ≥ · U+26A0 ⚠ · U+26D4 ⛔). Everything else — format
        characters, controls, marks, foreign letters, variation
        selectors, the lot — refuses before parsing. Repertoire
        expansion is an explicit document-language change, never a
        Unicode-category consequence. A finite border, not an
        adversarial tour of every invisible character Unicode has ever
        adopted.
    P3  no character references — `&#...;`, `&#x...;`, `&name;` — anywhere,
        including inside code (a bare `&` is legal; `&word;` is not).
  CONSTRUCT LAW (checked on the parser's token stream):
    P4  no raw HTML: any html_block or html_inline token is refused;
    P5  only the permitted Markdown subset: paragraphs, ATX/setext
        headings, blockquotes, bullet/ordered lists, GFM tables, code
        fences and indented code, thematic breaks; inline text, backslash
        escapes, code spans, strong, emphasis, strikethrough, links,
        soft/hard breaks (images removed post-adversarially, B6). Any
        other construct is refused by name.
  Everything the R0.5-R0.17 campaign litigated about rendered visibility —
  script bodies, separation tags, comment fusion, entity-split words,
  zero-width passengers, mismatched raw boundaries, header delegations
  hidden in foreign markup — is now denied admission at the gate instead
  of receiving a visibility hearing.

WITHIN THE LANGUAGE (retained semantics, inherited from the campaign):
  - recursive strong-label inventory in document order (pure-Markdown
    nesting via mixed delimiters is representable and walked);
  - whole-surface, order-invariant exact-one: every carrier binds exactly
    one primary; every unbound primary legend on a carrier surface is a
    violation;
  - the symmetric case-insensitive `**`/`__` unresolved-spelling inventory
    on each surface's visible stream (resolved delimiters are consumed by
    the parser and never reach the stream);
  - table policy: a header whose visible text names Status classifies the
    column; a descendant Status label inside a non-Status header is an
    ambiguous header and refuses; Status cells take exactly one strong
    primary, refuse later primaries and later Status carriers; carriers in
    non-Status cells are refused; blank and masked cells are refused;
  - code blocks and code spans carrying unresolved spellings are refused;
  - the sub-annotation, em-dash, and bare-REFUSED raw-line screens.

POST-ADVERSARIAL REPAIRS (PORTCULLIS red-team, filed at
_staging/portcullis-v17-redteam.md, adjudicated before seal):
  - (v17's P2b letter repertoire is SUBSUMED by v18's P2 enumerated
    repertoire — the closed alphabet is now closed over ALL code points,
    not only letters.)
  - the ambiguity pattern tolerates mixed delimiter runs (B4):
    `**_status` now trips like `_**status`;
  - a header that ENDS with the word Status without starting with it is
    an ambiguous header and refuses (B3 — the "Current Status" column
    can no longer be silently decommissioned; prefix classification is
    the charter's own convention and is unchanged);
  - P3's raw scan respects backslash escaping by parity (F1): `\&sect;`
    renders as literal text and is legal; `\\&sect;` decodes and is
    refused;
  - run() reads files with newline='' so the \r ban can actually fire
    on real files (B8); unknown dash-leading arguments are an error
    instead of silent omission (B9); --expect parsing survives paths
    containing colons (C1); the image construct is removed from the
    allowlist (B6 — alt-text asymmetry gone with it).
  Adjudicated NOT defects, with corpus evidence: free-standing strong
  legend labels off carrier surfaces are LEGAL BY THE CHARTER'S OWN
  DESIGN (the charter writes **REFUSED CLAIM under current evidence** in
  prose; the ledger writes **ADOPTED LAW** in non-Status cells) — so the
  block-boundary and cross-cell "escapes" are the grammar's actual
  scope, recorded for the docket, not repaired (B2/B5). A CLEAN verdict
  is relative to the parse model named in the CLEAN line (B7). Link
  titles and reference definitions are invisible metadata like
  destinations (B10). P3/P4 false refusals of legitimate-but-
  out-of-language Markdown are the profile working as commissioned
  (F3-F5).

REPRODUCIBILITY SURFACE: requires markdown-it-py (tested with 4.0.0 and
3.0.0) with its core 'table' and 'strikethrough' rules enabled. If the
dependency is absent the validator exits 3 with a controlled diagnostic,
never an import traceback.
"""
import re, sys, unicodedata

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
AMBIG_STATUSISH = re.compile(r'(\*\*|__)[*_]*status', re.I)  # unresolved strong-like spelling (mixed delimiter runs included) — refusal only
CHARREF = re.compile(r'&(#\d+|#[xX][0-9a-fA-F]+|[A-Za-z][A-Za-z0-9]*);')
ADMITTED_NONASCII = frozenset('§·×αβδ–—…←→⇒−∧≠≥⚠⛔')  # P2: the eighteen admitted non-ASCII code points
def _admitted(c):
    o = ord(c)
    return c == '\t' or c == '\n' or 0x20 <= o <= 0x7E or c in ADMITTED_NONASCII

class Unsupported(Exception): pass

ALLOWED_BLOCK = {
    'paragraph_open', 'paragraph_close', 'heading_open', 'heading_close',
    'blockquote_open', 'blockquote_close', 'bullet_list_open',
    'bullet_list_close', 'ordered_list_open', 'ordered_list_close',
    'list_item_open', 'list_item_close', 'table_open', 'table_close',
    'thead_open', 'thead_close', 'tbody_open', 'tbody_close', 'tr_open',
    'tr_close', 'th_open', 'th_close', 'td_open', 'td_close', 'fence',
    'code_block', 'hr', 'inline'}
ALLOWED_INLINE = {
    'text', 'text_special', 'code_inline', 'strong_open', 'strong_close',
    'em_open', 'em_close', 's_open', 's_close', 'link_open', 'link_close',
    'softbreak', 'hardbreak'}
TEXTY = {'text', 'code_inline', 'text_special'}
MARKER_INLINE = {'em_open', 'em_close', 'link_open', 'link_close',
                 's_open', 's_close'}

def profile_source_violations(text, name):
    """SOURCE LAW P1-P3: character-level admission, before parsing."""
    v = []
    if text != unicodedata.normalize('NFC', text):
        v.append(f"{name}: source is not in Unicode NFC — not in the document language (profile P1)")
    seen = set()
    for ln, line in enumerate(text.split('\n'), 1):
        for c in line:
            if not _admitted(c) and c not in seen:
                seen.add(c)
                v.append(f"{name}:{ln}: code point U+{ord(c):04X} outside the admitted source repertoire — not in the document language (profile P2)")
    for ln, line in enumerate(text.split('\n'), 1):
        for m in CHARREF.finditer(line):
            bs, k = 0, m.start() - 1
            while k >= 0 and line[k] == '\\': bs += 1; k -= 1
            if bs % 2 == 0:
                v.append(f"{name}:{ln}: character reference {m.group(0)!r} — not in the document language (profile P3)")
    return v

def walk_inline(children):
    """The one inline walk for the admitted language: produces (stream,
    labels) — the visible text of the surface and the recursive strong
    inventory (every strong node at every depth, document order of its
    opening). Tokens outside the permitted subset, and raw HTML, are
    Unsupported — the construct law refuses them by name."""
    labels, stack, stream = [], [], []   # stack frames: [label_idx, parts]
    def emit(s):
        stream.append(s)
        for fr in stack: fr[1].append(s)
    for tok in children or []:
        if tok.type == 'html_inline':
            raise Unsupported("raw HTML (profile P4)")
        if tok.type not in ALLOWED_INLINE:
            raise Unsupported(f"construct {tok.type!r} (profile P5)")
        if tok.type == 'strong_open':
            labels.append(None)
            stack.append([len(labels) - 1, []])
        elif tok.type == 'strong_close':
            if not stack:
                raise Unsupported("unbalanced strong structure")
            idx, parts = stack.pop()
            labels[idx] = ''.join(parts).strip()
        elif tok.type in TEXTY:
            emit(tok.content or '')
        elif tok.type in ('softbreak', 'hardbreak'):
            emit(' ')
        # MARKER_INLINE: resolved markup, contributes nothing
    if stack:
        raise Unsupported("unbalanced strong structure")
    if any(l is None for l in labels):
        raise Unsupported("strong structure resolved out of order")
    return ''.join(stream), labels

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

def is_carrier(s):
    return s.strip().lower().startswith('status')

def ambig_screens(stream, name, where, ctx):
    return [f"{name}:{where}: unresolved strong-like Status spelling{ctx} (visible surface resolves no carrier there) — conservative refusal: {stream[m.start():m.start()+50]!r}"
            for m in AMBIG_STATUSISH.finditer(stream)]

def check_text(text, name):
    viol, decls, cells = [], 0, 0
    viol += profile_source_violations(text, name)
    env = {}
    try:
        toks = MD.parse(text, env)
    except Exception as e:
        return viol + [f"{name}: document does not parse under the GFM model ({e}) — conservative refusal"], 0, 0

    def lineof(tok, fallback):
        return (tok.map[0] + 1) if getattr(tok, 'map', None) else fallback

    i, n = 0, len(toks)
    while i < n:
        t = toks[i]
        if t.type == 'html_block':
            viol.append(f"{name}:{lineof(t, 0)}: raw HTML block — not in the document language (profile P4)")
            i += 1; continue
        if t.type not in ALLOWED_BLOCK:
            viol.append(f"{name}:{lineof(t, 0)}: construct {t.type!r} — not in the document language (profile P5)")
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
                    stream, labs = walk_inline(th.children)
                except Unsupported as e:
                    viol.append(f"{name}:{tline}: header cell refused ({e}) — conservative refusal")
                    continue
                viol += ambig_screens(stream, name, tline, " in a header cell")
                if stream.strip().lower().startswith('status'):
                    cols.append(ci)
                elif re.search(r'\bstatus\s*$', stream.strip(), re.I):
                    viol.append(f"{name}:{tline}: header ends with the word Status without naming the column by the charter's prefix convention — ambiguous header, conservative refusal: {stream.strip()[:40]!r}")
                elif any(is_carrier(l) for l in labs):
                    viol.append(f"{name}:{tline}: descendant Status label inside a non-Status header — ambiguous header, conservative refusal")
            for row, rline in rows:
                for ci, cell_tok in enumerate(row):
                    if ci in cols: continue
                    where = lineof(cell_tok, rline)
                    try:
                        stream, labs = walk_inline(cell_tok.children)
                    except Unsupported as e:
                        viol.append(f"{name}:{where}: table cell refused ({e}) — conservative refusal")
                        continue
                    viol += ambig_screens(stream, name, where, " in a table cell")
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
                        viol.append(f"{name}:{where}: status cell refused ({e}) — conservative refusal")
                        continue
                    viol += ambig_screens(stream, name, where, " in a status cell")
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
                viol.append(f"{name}:{where}: surface refused ({e}) — conservative refusal")
                i += 1; continue
            viol += ambig_screens(stream, name, where, "")
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
            body = open(p, encoding='utf-8', newline='').read()
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
        v, d, c = check_text(open(path, encoding='utf-8', newline='').read(), path)
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
    print(f"CLEAN (coverage validated; profile enforced; parse model: {PARSER_ID})")
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
    # ------ inherited negatives (all 72 remain violations; out-of-profile
    # constructs are now refused at the gate — same verdict, cheaper trial)
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
    expect_viol("<em>Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | inline HTML", "INLINE-HTML Status header [now: profile P4]")
    expect_viol("&#83;tatus | Claim | Note" + T + "**MYSTERY** | r1 | char ref", "CHARACTER-REFERENCE Status header [now: profile P3]")
    expect_viol("![Status](status.png) | Claim | Note" + T + "**MYSTERY** | r1 | image alt", "IMAGE-ALT Status header [now: profile P5]")
    expect_viol("Status | <!-- a > b -->Status | Claim" + T + "**OPEN** | **MYSTERY** | r1", "COMMENT-hidden SECOND Status column [now: profile P4]")
    expect_viol("*Status* | Claim | Note" + T + " | r1 | italic hdr blank", "ITALIC header with blank cell")
    expect_viol("Claim \\| kind | Status | Note" + T + "r1 | **MYSTERY** | **OPEN**", "HEADER-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 \\| **OPEN** | **MYSTERY** | note", "DATA-SHIFT escaped-pipe decoy")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORICAL__ | two strong", "DOUBLE primary (** and __)")
    expect_viol("Claim | Status | Status" + T + "r1 | **OPEN** | **MYSTERY**", "SECOND Status column validated")
    expect_viol("<em title=\">\">Status</em> | Claim | Note" + T + "**MYSTERY** | r1 | quoted-attr", "QUOTE-ATTR HTML Status header [now: profile P4]")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __HISTORIC&#65;L__ | rendered", "ENTITY-bearing strong second primary [now: profile P3]")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL](https://example.com)__ | rendered", "LINK-bearing strong second primary")
    expect_viol("STATUS NOW | Claim | Note" + T + " | r1 | blank", "uppercase-STATUS blank cell")
    expect_viol("Claim | <!-- a > b -->Status | Note" + T + "r1 | **MYSTERY** | hidden column", "COMMENT-hidden single Status column [now: profile P4]")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __[HISTORICAL]__ | second primary\n\n[HISTORICAL]: https://example.com/history", "SHORTCUT-reference strong second primary")
    expect_viol("**Status: OPEN** / **HISTORICAL**", "PROSE double primary")
    expect_viol("> Claim | Status | Note\n> --- | --- | ---\n> r1 | **MYSTERY** | hidden", "SOL-R12-01: BLOCKQUOTED table with invalid token")
    expect_viol("__Status: MYSTERY__", "SOL-R12-02: underscore-strong invalid declaration")
    expect_viol("**Sta&#116;us: MYSTERY**", "SOL-R12-02: entity-bearing invalid carrier [now: profile P3]")
    expect_viol("**[Status](https://example.com/status): MYSTERY**", "SOL-R12-02: link-bearing invalid carrier")
    expect_viol("**Status: OPEN** and **Status: MYSTERY**", "SOL-R12-03: second carrier on one line validated")
    expect_viol("<strong>Status: MYSTERY</strong>", "SOL-R13-01: inline raw-HTML strong carrier [now: profile P4]")
    expect_viol("<strong>\nStatus: MYSTERY\n</strong>", "SOL-R13-01: block-form raw-HTML strong carrier [now: profile P4]")
    expect_viol("**HISTORICAL** / **Status: OPEN**", "SOL-R13-02: primary legend before valid carrier")
    expect_viol("**Status wording that never parses and **Status: OPEN**", "SOL-R13-03: valid carrier beside unresolved **Status spelling")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / **Status: MYSTERY** | hidden secondary carrier", "SOL-R13-04: later Status carrier in a status cell")
    expect_viol("__Status wording that never parses", "SOL-R14-01: lone underscore unresolved spelling")
    expect_viol("**status wording that never parses", "SOL-R14-01: case-variant unresolved spelling")
    expect_viol("__Status wording that never parses and **Status: OPEN**", "SOL-R14-01: underscore unresolved beside valid carrier")
    expect_viol("**[Status](https://example.com/status) wording that never parses and **Status: OPEN**", "SOL-R14-02: link-split unresolved spelling beside valid carrier")
    expect_viol("**Sta<!--x-->tus wording that never parses and **Status: OPEN**", "SOL-R14-02: comment-split unresolved spelling [now: profile P4]")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / __Status wording that never parses | hidden ambiguity", "SOL-R14-01: underscore unresolved in a status cell")
    expect_viol("Claim | Note | Status" + T + "r1 | **[Status](https://example.com/status) wording that never parses | **OPEN**", "SOL-R14-02: link-split unresolved in a non-Status cell")
    expect_viol("<div>\n**Sta<!-- invisible -->tus wording that never parses\n</div>", "SOL-R15-01: comment-split spelling inside an HTML block [now: profile P4]")
    expect_viol("<div>\n__Sta&#116;us wording that never parses\n</div>", "SOL-R15-01: entity-split spelling inside an HTML block [now: profile P3+P4]")
    expect_viol("<strong>Status: OPEN</b>", "SOL-R15-02: mismatched raw strong close [now: profile P4]")
    expect_viol("<strong>NOTE <b>ornament</strong></b> and **Status: OPEN**", "SOL-R15-02: interleaved raw strong beside valid carrier [now: profile P4]")
    expect_viol("<strong>NOTE <strong>Status: MYSTERY</strong></strong>", "SOL-R15-03: nested raw/raw descendant carrier [now: profile P4]")
    expect_viol("<strong>NOTE **Status: MYSTERY**</strong>", "SOL-R15-03: nested raw/Markdown descendant carrier [now: profile P4]")
    expect_viol("Claim | Status | Note" + T + "r1 | **OPEN** / <strong>NOTE <strong>Status: MYSTERY</strong></strong> | hidden", "SOL-R15-03: nested descendant carrier after valid table primary [now: profile P4]")
    expect_viol("Claim | <strong>Status</b> | Note" + T + "r1 | **OPEN** | malformed header boundary", "SOL-R16-01: mismatched raw strong header beside valid row [now: profile P4]")
    expect_viol("Claim | <strong>NOTE <strong>Status</strong></strong> | Note" + T + "r1 | **MYSTERY** | descendant header label", "SOL-R16-01: nested raw/raw Status header [now: profile P4]")
    expect_viol("Claim | <strong>NOTE **Status**</strong> | Note" + T + "r1 | **MYSTERY** | descendant header label", "SOL-R16-01: nested raw/Markdown Status header [now: profile P4]")
    expect_viol("**Sta<script>invisible</script>tus: MYSTERY**", "SOL-R16-02: script-split visible prose carrier [now: profile P4]")
    expect_viol("Claim | Sta<style>x</style>tus | Note" + T + "r1 | **MYSTERY** | visually Status", "SOL-R16-02: style-split visible Status header [now: profile P4]")
    expect_viol("**Sta&#x200B;tus: MYSTERY**", "SOL-R16-03: U+200B prose carrier [now: profile P3]")
    expect_viol("Claim | Sta⁠tus | Note" + T + "r1 | **MYSTERY** | visually Status", "SOL-R16-03: U+2060 Status header [now: profile P2]")
    expect_viol("<div>\n**Sta&#xFEFF;tus wording that never parses\n</div>", "SOL-R16-03: U+FEFF projected block ambiguity [now: profile P3+P4]")
    expect_viol("```\n**Sta​tus wording that never parses\n```", "SOL-R16-03: format-character code-block ambiguity [now: profile P2]")
    # ------ former rendering-model positive companions, reclassified:
    # these constructs are OUTSIDE the document language and now correctly
    # refuse at the gate (each label names its former positive identity)
    expect_viol("**Sta&#116;us: ACCEPTED EVIDENCE** at its sentence.", "RECLASSIFIED (was positive): entity-bearing valid carrier — profile P3")
    expect_viol("Claim | <!-- legal comment -->Other | Status" + T + "r1 | x | **OPEN** *(sub-annotation: OPEN-UNOPENED)*", "RECLASSIFIED (was positive): comment in unrelated header — profile P4")
    expect_viol("<span>ornament</span> **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.\n\n<div>unrelated raw block</div>", "RECLASSIFIED (was positive): unrelated raw HTML beside carrier — profile P4")
    expect_viol("<span data-note=\"__Status\">x</span> **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "RECLASSIFIED (was positive): raw-HTML attribute beside carrier — profile P4")
    expect_viol("<div data-note=\"__Status\">\nordinary visible text\n</div>", "RECLASSIFIED (was positive): HTML-block attribute — profile P4")
    expect_viol("<strong>Status: OPEN</strong> stands.", "RECLASSIFIED (was positive): matched raw strong carrier — profile P4")
    expect_viol("<strong>see <b>note</b></strong> and **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "RECLASSIFIED (was positive): nested raw annotation — profile P4")
    expect_viol("Claim | <strong>Status</strong> | Note" + T + "r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | matched header", "RECLASSIFIED (was positive): matched raw strong header — profile P4")
    expect_viol("<strong>see <b>note</b></strong> | Status | Note" + T + "x | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "RECLASSIFIED (was positive): nested raw header annotation — profile P4")
    expect_viol("ordinary visible text <script>**Status wording that never parses</script>", "RECLASSIFIED (was positive): script-confined Status text — profile P4")
    expect_viol("**Sta<br>tus: MYSTERY** stays separated.", "RECLASSIFIED (was positive): br-separated Sta tus — profile P4")
    # ------ profile gate teeth (each source/construct law shown able to fire)
    expect_viol("Café **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "PROFILE P1: non-NFC source refused")
    expect_viol("plain text with a \x0b control character", "PROFILE P2: forbidden control character refused")
    expect_viol("A​B plain sentence, no Status word at all", "PROFILE P2: format character refused even far from Status")
    expect_viol("5 &lt; 6 in plain prose", "PROFILE P3: character reference refused anywhere")
    expect_viol("<span>plain ornament</span> with no Status at all", "PROFILE P4: raw HTML refused even far from Status")
    # ------ PORTCULLIS red-team repairs (post-adversarial controls)
    expect_viol("**Ѕtatus: MYSTERY** text", "PORTCULLIS B1: Cyrillic-Ѕ confusable carrier — profile P2 repertoire")
    expect_viol("line one\r\nline two with **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "PORTCULLIS B8: carriage return refused — profile P2")
    expect_viol("**_status wording that never parses", "PORTCULLIS B4: mixed-delimiter unresolved spelling")
    expect_viol("Claim | Current Status | Note" + T + "r1 | **MYSTERY** | renamed column", "PORTCULLIS B3: ends-with-Status header refused, not decommissioned")
    # SOL-R18 exact witnesses
    expect_viol("**Sta\u034ftus: MYSTERY** in a reader-visible carrier.", "SOL-R18-01: U+034F COMBINING GRAPHEME JOINER inside Status — profile P2 repertoire")
    expect_viol("**Sta\ufe00tus: MYSTERY** in a reader-visible carrier.", "SOL-R18-01: U+FE00 VARIATION SELECTOR-1 inside Status — profile P2 repertoire")
    # ------ in-profile continuity for the nested-strong category
    expect_viol("**NOTE __Status: MYSTERY__**", "IN-PROFILE nested descendant carrier (mixed delimiters)")
    expect_viol("Claim | **NOTE __Status__** | Note" + T + "r1 | **MYSTERY** | descendant header label", "IN-PROFILE nested descendant Status header")
    import tempfile, os
    d = tempfile.mkdtemp(); empty = os.path.join(d, "empty.md"); open(empty, "w").write("   \n\n")
    rc = run([empty], {empty: (0, 0)})
    if rc == 2: print("self-test ok (caught): matched-0:0 EMPTY file refused")
    else: print("SELF-TEST FAIL: matched-0:0 empty file passed"); fails += 1
    rc = run([], {})
    if rc == 2: print("self-test ok (caught): no-input invocation refused")
    else: print("SELF-TEST FAIL: no-input not refused"); fails += 1
    # ------ positives (the admitted language, exercised)
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
    expect_clean("Claim | Status | Note" + T + "r1 | **OPEN** *(cf. __[note]__)* | n\n\n[note]: https://example.com/n", "non-legend shortcut-ref annotation", want_cells=1)
    expect_clean("**Status: OPEN** *(single primary; see also HISTORICAL in plain text)*", "single-primary prose", want_decls=1)
    expect_clean("> Claim | Status | Note\n> --- | --- | ---\n> r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | ok", "blockquoted table with one valid cell", want_cells=1)
    expect_clean("__Status: OPEN__ *(sub-annotation: OPEN-UNOPENED)*", "underscore-strong valid declaration", want_decls=1)
    expect_clean("**[Status](https://example.com/status): HISTORICAL** record.", "link-bearing valid carrier", want_decls=1)
    expect_clean("**Status: OPEN** *(first)* and **Status: HISTORICAL** *(second)*", "two-carrier line, both valid, both counted", want_decls=2)
    expect_clean("**NOTE** precedes **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "non-legend strong annotation before valid carrier", want_decls=1)
    expect_clean("Preamble line one of a soft-wrapped paragraph\n**Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "valid carrier on second physical line of one paragraph", want_decls=1)
    expect_clean("__[Status](https://example.com/status): OPEN__ *(sub-annotation: OPEN-UNOPENED)*.", "resolved underscore link-bearing carrier", want_decls=1)
    expect_clean("[ok](https://example.com/__Status) plain sentence.", "__Status only in an invisible link destination", want_decls=0)
    expect_clean("An ordinary visibly separated Sta tus control.", "plain separated Sta tus non-carrier", want_decls=0)
    # in-profile replacements for the reclassified annotation companions
    expect_clean("**see __note__** and **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.", "IN-PROFILE nested non-carrier annotation beside valid carrier", want_decls=1)
    expect_clean("**see __note__** | Status | Note" + T + "x | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | n", "IN-PROFILE nested non-Status header annotation, no phantom column", want_cells=1)
    # PORTCULLIS repair companions
    expect_clean("the margin \\&sect; is written escaped and renders literally.", "PORTCULLIS F1: backslash-escaped ampersand-word is literal text", want_decls=0)
    expect_clean("the pre-registered margin δ = f × oracle, with α and β retained.", "PORTCULLIS B1 companion: declared Greek repertoire stays legal", want_decls=0)
    print("SELF-TEST:", "PASS" if not fails else f"{fails} FAILURE(S)")
    return 1 if fails else 0

def main():
    if "--self-test" in sys.argv: sys.exit(self_test())
    expects, args = {}, []
    for a in sys.argv[1:]:
        if a.startswith("--expect="):
            f, d, c = a[9:].rsplit(":", 2)
            if f in expects: print(f"ERROR: duplicate expectation for {f!r}"); sys.exit(2)
            expects[f] = (int(d), int(c))
        elif a.startswith("-"):
            print(f"ERROR: unknown option {a!r} (a file name may not begin with '-')"); sys.exit(2)
        else: args.append(a)
    sys.exit(run(args, expects))

if __name__ == "__main__":
    main()
