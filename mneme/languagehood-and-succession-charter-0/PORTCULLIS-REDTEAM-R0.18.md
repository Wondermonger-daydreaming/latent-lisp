# PORTCULLIS — hostile red-team of `validate_status_grammar_v17.py`

**Agent:** PORTCULLIS (the gate-breaker). **Date:** 2026-08-12.
**Target:** `experiments/latent-lisp/mneme/languagehood-and-succession-charter-0/validate_status_grammar_v17.py`
(v17, THE RESTRICTED INPUT PROFILE; P1 NFC · P2 no Cf/Co/Cc-except-`\n``\t` ·
P3 no character references · P4 no raw HTML · P5 allowlisted construct subset).
**Signed:** Claude Opus 5 (1M context).

Every finding below was **demonstrated by an actual run**. No speculative
findings are recorded. Where I could not break something, it is listed in §8
(*attacks that failed*) rather than omitted.

---

## 1. Environment (verified, not assumed)

```
$ python3      -c "import markdown_it,sys;print(sys.version.split()[0], markdown_it.__version__, sys.executable)"
3.11.14 4.0.0 /home/gauss/OpenGauss/venv/bin/python3
$ /usr/bin/python3 -c "..."
3.12.3 3.0.0 /usr/bin/python3
```

Scratch dir: `/tmp/claude-1000/-home-gauss-Claude-Code-Lab/dfc387ed-.../scratchpad/portcullis/`
(cases/, cases2/, cases3/, cases4/, corpus/; transcripts run1.txt … run5.txt).

Standard probe used throughout (a `0:0` expectation is always satisfiable
because the coverage test is `d < ed or c < ec`, i.e. a **floor**, not equality):

```
python3      validate_status_grammar_v17.py <file> --expect=<file>:0:0
/usr/bin/python3 validate_status_grammar_v17.py <file> --expect=<file>:0:0
```

## 2. `--self-test` totals (observed, both interpreters)

| interpreter | markdown-it-py | negatives caught | positives clean | FAILURES | exit |
|---|---|---|---|---|---|
| `python3` | 4.0.0 | **90** | **29** | 0 | 0 |
| `/usr/bin/python3` | 3.0.0 | **90** | **29** | 0 | 0 |

`SELF-TEST: PASS` under both. (Counted by `grep -c` on the saved transcripts:
90 `self-test ok (caught)` = 88 `expect_viol` + the 2 `run()`-based coverage
teeth; 29 `self-test ok (passed)`. Note this differs from the R0.17 RETURN's
"72 negatives / 38 positives", which described v16.)

## 3. Baseline — the canonical five-file run reproduces

```
$ python3 validate_status_grammar_v17.py CLAIM-CEILING-R0.17.md EVIDENCE-LEDGER-R0.17.md \
    LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.17.md OWNER-DOCKET-R0.17.md SUCCESSION-DOCKET-R0.17.md \
    --expect=...:0:0 (×5)
CLAIM-CEILING-R0.17.md: 0 declarations, 16 table status cells
EVIDENCE-LEDGER-R0.17.md: 0 declarations, 0 table status cells
LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.17.md: 10 declarations, 6 table status cells
OWNER-DOCKET-R0.17.md: 0 declarations, 0 table status cells
SUCCESSION-DOCKET-R0.17.md: 4 declarations, 0 table status cells
CLEAN (coverage validated; profile enforced; parse model: markdown-it-py 4.0.0)
EXIT=0
```
Identical under 3.0.0. Matches the RETURN's stated 10/6 · 0/16 · 4/0 · 0/0 · 0/0.

---

## 4. THE HEADLINE — the real governed corpus, three injections, CLEAN exit 0

I copied the five canonical `*-R0.17.md` files, appended **279 characters** to the
charter, and ran the **canonical invocation at the real R0.17 coverage floor**
(`10:6`, `0:16`, `4:0`, `0:0`, `0:0`).

Injected text (verbatim):

```markdown
## Injected paragraph (PORTCULLIS demo)

**Ѕtatus: MYSTERY** — a homoglyph carrier declaring an off-legend token.

**Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.
- **HISTORICAL**

| Claim | Current Status | Note |
|---|---|---|
| W-99 | **MYSTERY** | unvalidated column |
```

What a reader sees (markdown-it render of that section, identical under both versions):

```html
<h2>Injected paragraph (PORTCULLIS demo)</h2>
<p><strong>Ѕtatus: MYSTERY</strong> — a homoglyph carrier declaring an off-legend token.</p>
<p><strong>Status: OPEN</strong> <em>(sub-annotation: OPEN-UNOPENED)</em>.</p>
<ul><li><strong>HISTORICAL</strong></li></ul>
<table><thead><tr><th>Claim</th><th>Current Status</th><th>Note</th></tr></thead>
<tbody><tr><td>W-99</td><td><strong>MYSTERY</strong></td><td>unvalidated column</td></tr></tbody></table>
```

What the validator says:

```
### python3 — canonical invocation at the R0.17 coverage floor
corpus/CLAIM-CEILING-R0.17.md: 0 declarations, 16 table status cells
corpus/EVIDENCE-LEDGER-R0.17.md: 0 declarations, 0 table status cells
corpus/LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.17.md: 11 declarations, 6 table status cells
corpus/OWNER-DOCKET-R0.17.md: 0 declarations, 0 table status cells
corpus/SUCCESSION-DOCKET-R0.17.md: 4 declarations, 0 table status cells
CLEAN (coverage validated; profile enforced; parse model: markdown-it-py 4.0.0)
EXIT=0
### /usr/bin/python3 — …
CLEAN (coverage validated; profile enforced; parse model: markdown-it-py 3.0.0)
EXIT=0
```

**Three reader-visible violations of the Status grammar — an off-legend primary
on a bold Status carrier, a second unbound primary legend directly under a
declaration, and an entire unvalidated Status column — pass CLEAN, exit 0, at
the canonical coverage floor, under both declared parser versions.** The
declaration count rose 10 → 11 and the floor (`≥`) absorbed it.

---

## 5. BYPASS findings (false greens)

### B1 — CONFUSABLE CARRIER. `Ѕtatus` (U+0405 CYRILLIC CAPITAL LETTER DZE) is not `Status`. **Severity: BYPASS (highest).**

The profile bans Cf and Co. It does **not** ban confusables, and P1 (NFC) is
stable under them — U+0405 is its own NFC form, category `Lu`.
`is_carrier()` and `AMBIG_STATUSISH` are both ASCII-anchored.

```
$ cat cases2/g01_cyrillic_S_prose_carrier.md
**Ѕtatus: MYSTERY** stands as written.
$ python3 …v17.py cases2/g01… --expect=…:0:0
cases2/g01_cyrillic_S_prose_carrier.md: 0 declarations, 0 table status cells
CLEAN (coverage validated; profile enforced; parse model: markdown-it-py 4.0.0)
EXIT=0        # 3.0.0 identical
```
Render: `<p><strong>Ѕtatus: MYSTERY</strong> stands as written.</p>` — a bold
Status declaration bearing a seventh token.
Control (`g04`, ASCII `S`): `⚠ non-legend primary token 'MYSTERY'`, exit 1.

Three live variants, all CLEAN under both interpreters:

| case | source | effect |
|---|---|---|
| `g01` | `**Ѕtatus: MYSTERY**` | carrier invisible to the walk; 0 declarations |
| `g02` | `\| Claim \| Ѕtatus \| Note \|` + `\| r1 \| **MYSTERY** \|` | column never classified; **entire column unvalidated** |
| `g05` | valid carrier **and** `**Ѕtatus: MYSTERY**` on one line | decls = 1 (unchanged) — **the coverage floor is satisfied too** |
| `g06` | `**Ѕtatus wording that never parses` | ambiguity tripwire silent |
| `g07` | `**Ｓtatus: MYSTERY**` (U+FF33 fullwidth S) | same, NFC-stable (NFKC would fold it; P1 is NFC) |

Note the provenance: the R0.17 RETURN §3 states the v16 Cf policy was built
"**with no NFKC or confusable broadening**". That was a deliberate scope
decision in the *rendering* model. Under v17's *admission* model the same hole
is now the whole of the Unicode policy, and it is the one class the gate was
supposed to make unnecessary to litigate.

### B2 — BLOCK-BOUNDARY ESCAPE from whole-surface exact-one. **Severity: BYPASS. Pure ASCII, pure Markdown, both versions.**

The exact-one rule is scoped to one `inline` token. Any block boundary — even
one that produces no visual gap — releases the second primary.

```
$ cat cases3/m02_list_interrupts_paragraph.md
**Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*.
- **HISTORICAL**
$ python3 …  → 1 declarations, 0 table status cells / CLEAN / EXIT=0   (both versions)
```
Control `m04` — the *same two lines* with the `- ` removed (soft-wrapped into one
paragraph) — fires `⚠ UNBOUND primary legend token 'HISTORICAL' on a prose
Status declaration surface`, exit 1.

Also CLEAN: `m01` (blank line + `**HISTORICAL**`), `m03` (two blockquote
paragraphs), `m05` (two list items), `m06` (heading carrier + following
paragraph). **Two ASCII characters (`- `) defeat the rule.**

### B3 — PREFIX-ANCHORED HEADER CLASSIFICATION. **Severity: BYPASS. Pure ASCII, both versions.**

`cols` is populated by `stream.strip().lower().startswith('status')`. Any prefix
decommissions the column silently.

```
$ cat cases4/q04_current_status_header.md
| Claim | Current Status | Note |
|---|---|---|
| r1 | **MYSTERY** | n |
$ python3 … → 0 declarations, 0 table status cells / CLEAN / EXIT=0   (both versions)
```
Renders as `<th>Current Status</th>` over `<td><strong>MYSTERY</strong></td>` —
plainly the Status column to any reader. Control `q03` (`Status`) fires
`⚠ non-legend table status token 'MYSTERY'`. Same for `q01` (`¶ Status`),
`q02` (`• Status`). Suffixes are fine (`Status now` classifies — it is a
self-test positive), so the asymmetry is prefix-only and undocumented.

### B4 — THE AMBIGUITY TRIPWIRE IS NOT SYMMETRIC. **Severity: BYPASS.**

`AMBIG_STATUSISH = (\*\*|__)status` requires the two delimiter characters to be
**adjacent to** `status`. The docstring calls this "the symmetric
case-insensitive `**`/`__` unresolved-spelling inventory".

| source | rendered (verbatim, both versions) | verdict |
|---|---|---|
| `*__status wording that never parses` | `*__status …` | ⚠ refused (control) |
| `_**status wording that never parses` | `_**status …` | ⚠ refused (control) |
| **`**_Status wording that never parses`** | `**_Status …` | **CLEAN, exit 0** |
| **`__*Status wording that never parses`** | `__*Status …` | **CLEAN, exit 0** |
| **`** Status wording that never parses`** | `** Status …` | **CLEAN, exit 0** |

And beside a valid carrier — the exact SOL-R14-01 shape the screen exists for:

```
$ cat cases/a04_beside_valid_carrier.md
**_Status wording that never parses and **Status: OPEN** *(sub-annotation: OPEN-UNOPENED)*
$ python3 … → 1 declarations, 0 table status cells / CLEAN / EXIT=0
render: <p>**_Status wording that never parses and <strong>Status: OPEN</strong> …</p>
```
Self-test line 419 asserts the mirror image (`__Status … and **Status: OPEN**`)
*is* caught. One inserted character flips it. Same hole in the code-block path
(`q08`, an indented code block containing `**_Status …`, CLEAN).

### B5 — NO EXACT-ONE ACROSS TABLE ROW CELLS. **Severity: BYPASS.**

The non-Status-cell loop screens `is_carrier` only; `is_primary_legend` is never
consulted outside the Status column.

```
$ cat cases3/n01_primary_in_note_cell.md
| Claim | Status | Note |
|---|---|---|
| r1 | **OPEN** *(sub-annotation: OPEN-UNOPENED)* | **HISTORICAL** |
$ python3 … → 0 declarations, 1 table status cells / CLEAN / EXIT=0   (both versions)
```
A reader sees `OPEN | HISTORICAL` in one row. The prose analogue (`b04`) is a
violation. `n02` (primary in the Claim cell) is likewise CLEAN.

### B6 — `image` DISCARDS THE STRONG INVENTORY WHILE CONTRIBUTING TO THE VISIBLE STREAM. **Severity: BYPASS (internally inconsistent).**

`walk_inline` does `emit(walk_inline(tok.children)[0])` — the alt stream is kept,
the alt **labels are dropped on the floor**. But the validator's own self-test
(line 393) treats alt text as visible enough to *classify a Status column*
(`![Status](status.png) | Claim | Note` → refuses). Both cannot be right.

| case | source | verdict | control |
|---|---|---|---|
| `b01` | `\| r1 \| **OPEN** / ![**HISTORICAL**](x.png) \|` in a Status column | **CLEAN** | `b02` → `⚠ SECOND primary legend token 'HISTORICAL'` |
| `b03` | `**Status: OPEN** … and ![**HISTORICAL**](x.png).` | **CLEAN** | `b04` → `⚠ UNBOUND primary legend token` |
| `b05` | carrier `![**Status: MYSTERY**](x.png)` in a non-Status cell | **CLEAN** | `b06` → `⚠ strong Status carrier … in a non-Status table cell` |
| `b07` | `![**Status: MYSTERY**](x.png)` alone | **CLEAN** | — |

Honest caveat on reader-visibility: alt text renders as
`<img src="x.png" alt="HISTORICAL" />` — surfaced on a broken image and to
screen readers, not in a normally-loading visual render. I rate this a BYPASS on
the **internal-consistency** ground (the validator itself counts alt as visible),
not on the strength of the visual channel.

### B7 — THE TWO DECLARED PARSERS DISAGREE ON THE VERDICT. **Severity: BYPASS (portability).**

CommonMark 0.30 → 0.31.2 widened "punctuation" to include Unicode Symbol
categories, changing `_`-emphasis flanking. markdown-it-py 3.0.0 tracks the
former, 4.0.0 the latter. The docstring names **both** as the reproducibility
surface.

```
$ cat cases2/h01_symbol_flank_second_primary.md
| Claim | Status | Note |
|---|---|---|
| r1 | **OPEN** / ©__HISTORICAL__© | n |

$ python3 …            → ⚠ SECOND primary legend token 'HISTORICAL' … NOT CLEAN  EXIT=1
$ /usr/bin/python3 …   → CLEAN (… parse model: markdown-it-py 3.0.0)             EXIT=0
```
`h02` (prose unbound primary, `©`) and `h04` (`−` U+2212 MINUS SIGN) show the
same flip. `h03` shows a *classification* flip in the other direction (4.0.0:
`non-legend primary token 'MYSTERY'`; 3.0.0: the ambiguity tripwire).

Quantified sweep (`flank.py`, `X__HISTORICAL__X` after a valid carrier):

- **20 of 33** flanking characters flip the verdict: `© ® ° ± × ÷ € ¢ £ ¤ ¬ − ≤ ≥ → √ ∞ ♦ ☑ ✓` (all **non-ASCII**, categories `So`/`Sm`/`Sc`) — REFUSED by 4.0.0, **CLEAN** by 3.0.0.
- Agree-REFUSED: `¶ § • ‰` (Po) and ASCII `+ = $ ~ ^ |`.
- Agree-CLEAN: `¹` (No), `µ` (Ll), `` ` ``.

`§` is already live corpus vocabulary (`**Status (charter §E rung 6).**` is a
self-test positive). **A CLEAN certificate from v17 is parser-relative, and the
validator prints which parser produced it but does not require both.** If the
corpus is certified under 3.0.0 and published to a 0.31.2-class renderer
(GitHub's), the reader is shown a second primary that no run ever adjudicated.

### B8 — P2's `\r` BAN CANNOT FIRE THROUGH FILE INPUT. **Severity: BYPASS (a stated law that does not exist in practice).**

`run()` uses `open(p, encoding='utf-8')` — Python's default universal-newline
mode translates `\r\n` and lone `\r` to `\n` **before** `profile_source_violations`
ever sees the text.

```
$ xxd cases/f01_crlf.md | head -1
00000000: 4f72 6469 6e61 7279 206c 696e 6520 6f6e  Ordinary line on
00000010: 652e 0d0a 2a2a 5374 6174 7573 3a20 4f50  e...**Status: OP     ← 0d0a present

$ python3 … cases/f01_crlf.md --expect=…:0:0
1 declarations, 0 table status cells / CLEAN / EXIT=0     (both versions)

# same bytes handed to check_text() as a string:
raw string  -> ['<raw-bytes>:1: forbidden character U+000D (Cc) — not in the document language (profile P2)']
via open()  -> []
contains CR after open(): False
```
`f02` (lone `\r`, old-Mac endings) is likewise CLEAN. The P2 teeth for `\r` fire
only in the self-test, which passes string literals. Practically the translation
is benign — but "no Cc except newline and tab" is asserted of the *source*, and
the source is never examined.

### B9 — SILENT INPUT OMISSION for a dash-leading path. **Severity: BYPASS (low, requires operator error).**

`main()` drops any argument beginning with `-` that is not `--expect=`.

```
$ python3 …v17.py cases/d03_url_with_amp_noparam.md -bad.md --expect=cases/d03_url_with_amp_noparam.md:0:0
cases/d03_url_with_amp_noparam.md: 0 declarations, 0 table status cells
CLEAN (coverage validated; profile enforced; parse model: markdown-it-py 4.0.0)
EXIT=0
```
`-bad.md` exists, contains a violation, is never read, and no coverage error
names it. Rule 1 ("CLEAN is impossible on silence") is defeated when the silence
is created by the argument parser rather than by an empty list. (Fails **closed**
in every other mis-invocation I tried — see §8.)

### B10 — link/image titles and reference definitions are invisible. **Severity: COSMETIC-to-BYPASS (weak channel).**

```
$ cat cases/c01_link_title_declaration.md
See [the record](https://example.com/x "**Status: MYSTERY**") for detail.
→ CLEAN, exit 0, both versions
render: <a href="…" title="**Status: MYSTERY**">the record</a>     ← browser tooltip
```
Same for `c02` (reference-definition title) and `q09` (`[**Status: MYSTERY**]:
https://…`, which emits no tokens at all) and `q07` (a fence *info string*
carrying `**Status: MYSTERY**`, never screened — only `t.content` is). I do not
press these: a tooltip is a weaker visibility claim than the campaign has
previously accepted, and I flag them only so the class is on the record.

---

## 6. FALSE-REFUSAL findings

### F1 — `\&sect;` IS NOT A CHARACTER REFERENCE, AND P3 REFUSES IT ANYWAY. **Severity: FALSE-REFUSAL (a genuine regex-vs-parser bug).**

`CHARREF` is a raw-text regex. It cannot see the backslash escape the parser
honours.

```
$ cat cases/d01_escaped_ampersand_entityish.md
The token is written \&sect; in the source and renders literally.
$ python3 … → ⚠ character reference '&sect;' — not in the document language (profile P3)  EXIT=1

# what the parser actually does with that source:
markdown-it render → <p>The token is written &amp;sect; in the source and renders literally.</p>
                       (i.e. the literal text "&sect;" — NOT an entity)
```
This is the "regex clerk" the R0.13 round dismissed for the GFM-table rule,
still sitting in the P3 seat. **Consequence: there is no in-profile spelling of a
literal `&word;` sequence at all** — the raw form is refused (correctly) and the
CommonMark-correct escape is refused (incorrectly).

### F2 — `&sect;` inside a URL query string. **Severity: FALSE-REFUSAL-BY-POLICY (confirmed as flagged, with a caveat that cuts the other way).**

```
$ cat cases/d02_url_with_sect_param.md
See [the record](https://x.com/a?b=1&sect;=2) for detail.
$ python3 … → ⚠ character reference '&sect;' … (profile P3)   EXIT=1   (both versions)
```
The brief flagged this as "THAT WOULD BE A REAL BUG". It fires — **but I must
report against my own case:** markdown-it genuinely decodes it —
`<a href="https://x.com/a?b=1%C2%A7=2">` — so the URL really is mangled and the
refusal is defensible on the merits. The defect is F1, not F2: the author has no
escape hatch, because the escape is also refused. Control `d03`
(`?b=1&c=2`, no semicolon) is CLEAN — the regex does not over-fire on bare `&`
(`p08`: `Smith & Jones, R&D, AT&T, Q&A` → CLEAN).

I searched for the opposite direction (a reference markdown-it decodes that
`CHARREF` misses) and found none: markdown-it's entity rules are
`&[a-z][a-z0-9]{1,31};` / `&#(x[a-f0-9]{1,6}|[0-9]{1,7});`, and `CHARREF` is a
strict superset of both. **P3 over-fires; it does not under-fire.**

### F3 — `__` inside an ordinary identifier. **Severity: FALSE-REFUSAL.**

```
$ cat cases3/p06_double_underscore_prose.md
The file is named LANGUAGEHOOD__STATUS in the archive.
$ python3 … → ⚠ unresolved strong-like Status spelling … : '__STATUS in the archive.'  EXIT=1
```
Renders as plain literal text. A governed document naming its own artefacts in
`FOO__STATUS` form is refused. (`p05`, `` `x__y` `` in a code span plus `a_b_c`,
is CLEAN — the collision needs the literal token `status` after the `__`.)

### F4 — the charter cannot quote its own grammar. **Severity: FALSE-REFUSAL-BY-DESIGN (documented, but worth naming).**

```
d07: The carrier is spelled `**Status: ADOPTED LAW**` in the source.  → ⚠ refused (code span → stream)
d08: a fenced block containing **Status: ADOPTED LAW**                → ⚠ refused (fence content screen)
```
The docstring states this ("code blocks and code spans carrying unresolved
spellings are refused"). It nonetheless means a *specification* document for
this grammar cannot be written in the language the grammar governs.

### F5 — plausible in-corpus Markdown refused by P4. **Severity: FALSE-REFUSAL-BY-DESIGN.**

| case | source | verdict |
|---|---|---|
| `d05` | `Where a<b>c holds, the ordering is strict.` | ⚠ surface refused (raw HTML, P4) |
| `p01` | `An ordinary sentence. <!-- editorial note: check W-09 -->` | ⚠ surface refused (raw HTML, P4) |
| `p02` | `\| … \| first<br>second \|` (the standard GFM multi-line cell) | ⚠ table cell refused (raw HTML, P4) |
| `d11` | a UTF-8 BOM | ⚠ forbidden character U+FEFF (Cf) (P2) |

`d04` (`The count 5 < 6 and the margin a < b`) is **CLEAN** — a stray `<` does
*not* emit `html_inline`, so the brief's second flagged candidate is clear.

### F6 — the bare-`REFUSED` raw-line screen fires inside URLs and quotations.

```
d09: See [the record](https://example.com/REFUSED/x) for detail.   → ⚠ bare REFUSED label
d10: The owner wrote "REFUSED" in the margin.                       → ⚠ bare REFUSED label
```
Both are labelled `[adjudicate if quoted]`, so this is the screen working as
written. `p10` (`a REFUSED CLAIM under current evidence`) is CLEAN.

### F7 — an annotation before the primary in a status cell.

```
$ cat cases2/j01_annotation_before_primary.md   →  | r1 | *(cf. W-09)* **OPEN** | n |
→ ⚠ status cell does not OPEN with a strong primary token: '(cf. W-09) OPEN'
```
`opens_with_strong` requires the primary first. Every self-test positive puts
annotations after. A future revision that leads with a cross-reference refuses.

---

## 7. COSMETIC / robustness

### C1 — uncaught traceback on a colon-bearing path, exiting 1 (indistinguishable from NOT CLEAN)

```
$ python3 …v17.py 'weird:name.md' '--expect=weird:name.md:0:0'
Traceback (most recent call last):
  …
  File "…/validate_status_grammar_v17.py", line 510, in main
    f, d, c = a[9:].split(":")
ValueError: too many values to unpack (expected 3)
EXIT=1
```
The module promises a *controlled* diagnostic (exit 3) for the missing
dependency; argument parsing has no such courtesy, and its crash exit code
collides with "NOT CLEAN (violations)".

### C2 — `--expect` is a floor, never an equality

`if ed is not None and (d < ed or c < ec)`. A revision that **adds** hidden or
mis-declared material never trips coverage (demonstrated in §4: 10 → 11 at
`--expect=…:10:6`, CLEAN). Removal is caught; addition is not.

### C3 — `seen` suppresses repeat P2 reports

`profile_source_violations` reports each distinct forbidden code point once per
file, at its first line only. The gate still fires; the diagnostic under-reports.

### C4 — a file listed twice is validated twice

`python3 …v17.py X X --expect=X:0:0` → every violation printed twice,
`NOT CLEAN (2 violation(s))`. No bypass; noisy.

---

## 8. Attacks that FAILED — the validator held

Recorded so the coverage of this red-team is legible.

| attack | case | result |
|---|---|---|
| setext heading carrying a strong carrier | `e01` | ⚠ `non-legend primary token 'MYSTERY'` |
| hard-break between carrier and primary | `e07` | ⚠ caught |
| `**Status:**` with nothing after | `e08` | ⚠ `declaration has no parsed primary token` |
| tab-delimited table columns | `e04` | ⚠ caught — tabs shift nothing |
| table nested inside a list item | `e05` | ⚠ caught |
| pipe inside a code span shifting a cell | `i01` | ⚠ caught (cell split matches GFM) |
| extra cells beyond header count | `e06` | dropped by parser **and** by renderer — consistent, no hidden content |
| lazy continuation into a blockquoted table | `e03` | no body row forms in either version; the lazy line renders as a separate paragraph |
| primary inside link text | `k01` | ⚠ `UNBOUND primary legend token` |
| primary inside strikethrough | `k03` | ⚠ caught |
| image nested inside a strong label | `l01`,`l02` | ⚠ caught (alt joins the label) |
| backslash-escaped strong carriers `\*\*Status…\*\*`, `\_\_Status…\_\_` | `o01`,`o02` | ⚠ ambiguity tripwire fires |
| autolink whose URL contains `__Status` | `c03` | ⚠ tripwire fires |
| `html_block` inside a blockquote / inside a list | `q05`,`q06` | ⚠ `raw HTML block (profile P4)` |
| a character reference `CHARREF` misses | — | **none exists**; the regex is a strict superset of markdown-it's entity rules |
| path aliasing `./x` vs `x` | — | 2 coverage errors, exit 2 (fails closed) |
| misspelled / unused expectation | — | coverage error, exit 2 |
| single-dash `-expect=` typo | — | expectation dropped **and** file uncovered → exit 2 |
| unknown flag `--no-such-flag` | — | ignored; the rest still validated correctly |
| empty file with a matched `0:0` | self-test | refused, exit 2 |
| zero inputs | self-test | refused, exit 2 |
| YAML front matter, task lists, footnote syntax, `§`/em-dash/curly quotes/`~`, URL fragment `#status-grammar`, bare `&` | `p03`,`p04`,`d12`,`d06`,`p07`,`p08` | CLEAN — no spurious refusals |

---

## 9. Where the repairs would have to land (chair's call, not mine)

1. **The Unicode policy is the load-bearing gap.** P2 bans Cf/Co; nothing bans
   confusables, and NFC does not fold them. Either (a) restrict the admitted
   character repertoire (e.g. refuse any non-ASCII letter in a strong label, or
   any code point outside a declared script set), or (b) apply a
   skeleton/confusable fold *for the carrier and header identity test only* —
   the R0.17 chair declined "confusable broadening" for the v16 *rendering*
   model; under an *admission* model the calculus is different.
2. **"Surface" must be defined, and defended.** If the exact-one rule is meant
   to be per-`inline`, `m02` is behaviour, not a bug — but it should be *stated*
   and self-tested as a negative, because a reader cannot see the block boundary.
3. **Header classification should be identity-based, not prefix-based** — and
   the non-Status cells of a classified row want the same `is_primary_legend`
   screen the prose surfaces get (B5).
4. **`AMBIG_STATUSISH` should be a normalized-adjacency test, not a two-character
   regex** — e.g. strip `*`/`_`/space runs before matching, which closes B4 in
   both directions at once.
5. **Image alt must be resolved one way.** Either count its labels (consistent
   with counting its stream for header classification) or count neither.
6. **Read files as bytes and decode with `newline=''`** so P1–P3 examine the
   source, not a universal-newline translation of it (B8).
7. **P3 must be parser-authoritative, not raw-regex** — `\&sect;` is legal
   CommonMark and there is currently no in-profile way to write it (F1).
8. **Pin, or require, the parser.** Either refuse to certify unless the flanking
   semantics match a declared CommonMark version, or run both and require
   agreement — a CLEAN whose meaning depends on which of two blessed parsers ran
   is not a certificate (B7).
9. Small: raise a controlled diagnostic for malformed `--expect` (C1); refuse
   arguments that look like paths but were dropped (B9).

---

## 10. Reproduction

All case files, the flanking sweep script, and full transcripts:
`/tmp/claude-1000/-home-gauss-Claude-Code-Lab/dfc387ed-7ddc-4d40-a4c8-79c55685483c/scratchpad/portcullis/`
— `cases/` (41), `cases2/` (19), `cases3/` (20), `cases4/` (9), `corpus/` (the
injected five-file demo), `flank.py`, `probe.sh`, `run1.txt`–`run5.txt`,
`st40.txt`, `st30.txt`. Every quoted output above is copied from those runs.

— PORTCULLIS
