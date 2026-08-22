# SOL R0.9 READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0

**Reviewer:** GPT-5.6 Sol  
**Date:** 2026-08-11  
**Object:** `languagehood-and-succession-charter-0-r0.9-2026-08-11.tar.gz`  
**Disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.10 CHECKER REPAIR BEFORE OWNER DOCKET**

R0.9 is **constitutionally and documentarily fit, but not docket-fit**. The
sealed bytes, all ten strata, the declared parcel tree, and the 131-row
occurrence adjudication authenticate. `validate_status_grammar_v8.py` closes
the four exact R0.8 witnesses and passes its committed controls, but three
independent fail-open roots remain in the checker:

1. its promised unknown-wrapper guard is a small character-deletion regex,
   not a Markdown plain-text projection;
2. its table lexer is raw `str.split('|')`, so escaped cell pipes can move the
   inspected Status column onto a decoy token; and
3. its exact-one-primary rule recognizes `**…**` but not the equally strong
   `__…__` form for a second legend token.

Each root has an ordinary-invocation witness that prints `CLEAN` and exits 0.
No constitutional holding, authority classification, gate, fork, census
classification, or commencement clause requires reopening.

---

## 1. Materials and scope

Reviewed objects supplied by the owner:

- `languagehood-and-succession-charter-0-r0.9-2026-08-11.tar.gz`
- `languagehood-and-succession-charter-0-r0.9-2026-08-11.tar.gz.sha256`

Declared identities:

- archive SHA-256:
  `a599096289da8fe19dc355f2f256b3a6548d1c2904badad5aec51f58a6c262d0`
- R0.9 candidate commit:
  `b0d30c49240c35f5adad9b55d4727d734d1a59b3`
- parcel-directory tree:
  `28aef823f097b41d07f85a6d168f52d0d2f33ddf`

This was a read-only candidate audit. The archive was extracted into an
isolated review directory; none of the ten candidate strata was edited. The
commit object is not present in this review environment's Git graph, so the
commit SHA remains a repository-side identity claim. The archive bytes and
parcel tree were independently authenticated.

## 2. Custody and identity

### 2.1 Outer object

- Computed archive SHA-256 equals
  `a599096289da8fe19dc355f2f256b3a6548d1c2904badad5aec51f58a6c262d0`.
- The supplied sidecar matches exactly and verifies with `sha256sum -c`.
- The archive contains 113 members: 108 regular files and 5 directories.
- No absolute path, `..` traversal member, link, device, or other non-ordinary
  member was found.

### 2.2 Ten checksum strata

| Stratum | Result |
|---|---:|
| R0 | 7/7 |
| R0.1 | 12/12 |
| R0.2 | 10/10 |
| R0.3 | 9/9 |
| R0.4 | 9/9 |
| R0.5 | 10/10 |
| R0.6 | 10/10 |
| R0.7 | 10/10 |
| R0.8 | 10/10 |
| R0.9 | 10/10 |

All 96 project files shared with the previously authenticated R0.8 archive are
byte-identical. The filed `SOL-R0.8-READBACK.md` is byte-identical to the
controlled Sol R0.8 readback.

### 2.3 Tree reconstruction

An independent Git-index reconstruction from the extracted parcel directory,
using the archive-recorded file modes, produced:

```text
28aef823f097b41d07f85a6d168f52d0d2f33ddf
```

This exactly equals the declared R0.9 parcel-directory tree.

**Custody disposition: PASS.**

---

## 3. Executive readback

The R0.9 return's positive claims are real as far as they go:

- v8's committed self-test passes with **26 negative controls caught and 12
  positive controls clean**;
- the four exact R0.8 hostile spellings are no longer invisible:
  `***Status***`, a matching two-backtick code span, a full-reference link,
  and the balanced-destination inline link;
- the committed `~~Status~~` specimen is rejected by the new guard;
- hollow input, expectation coverage, case-variant header discovery,
  no-outer-pipe tables, blank Status cells, masked blanks, and the committed
  double-`**` primary case remain closed; and
- the canonical five-file R0.9 invocation exits 0 at exactly:
  **10/6 · 0/16 · 4/0 · 0/0 · 0/0**.

The actual five successor documents contain none of the hostile forms reported
below. Their current status surfaces remain clean. The ratification blocker is
the enforcement instrument's ability to certify a mutated governed file as
clean, not a presently observed constitutional-text defect.

---

## 4. Prior-finding disposition

| R0.8 readback finding | R0.9 disposition | Readback |
|---|---|---|
| **SOL-R08-01** — v7 implements wrapper specimens, not its promised grammar | **PARTIAL — RATIFICATION BLOCKER** | The four exact witnesses are repaired and their valid companions count once. The advertised category-level guard remains fail-open for ordinary Markdown constructs, and table tokenization plus exact-one enforcement expose two additional false-green roots. |
| **SOL-R08-02** — R0.8 occurrence census | **CLOSED WITHOUT RESIDUE** | The R0.9 continuation exactly covers all 131 actual occurrences at 113 HISTORICAL/PROVENANCE · 18 FROZEN-ARTIFACT NAME · 0 LIVE. |

---

## 5. Readback findings

### SOL-R09-01 — RATIFICATION BLOCKER — the “drawer guard” is not a Markdown plain-text guard

The relevant implementation is:

```python
MARKUP_CHARS = re.compile(r'[*_`\[\]()~\\]')

def status_like_unreduced(cell, refdefs):
    norm = normalize_label(cell, refdefs)
    if norm.lower().startswith('status'):
        return False
    stripped = MARKUP_CHARS.sub('', cell).strip()
    return stripped.lower().startswith('status')
```

This removes a selected list of punctuation. It does not compute Markdown's
plain-text or rendered-label projection. Constructs whose syntax contributes a
leading character sequence not in `MARKUP_CHARS` remain outside both the
normalizer and the guard.

Three independent supplied-file witnesses are enough:

```markdown
<em>Status</em> | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | inline HTML wrapper
```

```markdown
&#83;tatus | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | character-reference label
```

```markdown
![Status](status.png) | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | image alt label
```

For each file, under its own matched `0:0` expectation, v8 reports:

```text
0 declarations, 0 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
```

and exits 0. In the first case `<em>` remains before `Status`; in the second,
the character-reference syntax remains before the decoded `S`; in the third,
`!` remains before the alt label. The data row is therefore never inspected.

These are ordinary Markdown inline categories, not invented punctuation.
Character references, raw HTML, images, and table cell content are specified by
GFM/CommonMark; the checker may normalize them or reject a Status-bearing
unsupported form, but it may not silently report `0:0`.

**Required repair:** replace the selective character deletion with either a
real Markdown inline-token/plain-text projection or a genuinely conservative
fail-closed recognizer. It must decode named/numeric character references and
account for raw-inline-HTML text and image alt text—or explicitly reject the
Status-like construct as unsupported. The property is the requirement; no new
finite punctuation allowlist is acceptable.

### SOL-R09-02 — RATIFICATION BLOCKER — raw pipe splitting permits Status-column decoys

The table row splitter is:

```python
def split_row(s):
    s = s.strip()
    if s.startswith('|'): s = s[1:]
    if s.endswith('|'): s = s[:-1]
    return [c.strip() for c in s.split('|')]
```

It treats every `|` byte as a cell boundary, including a GFM-escaped `\|` that
belongs to cell content. Because the header determines `col` while each data
row is split independently, a decoy bold legend token can occupy the raw index
that v8 inspects while the logical Status cell contains an invalid token.

Header-shift witness:

```markdown
Claim \| kind | Status | Note
--- | --- | ---
r1 | **MYSTERY** | **OPEN**
```

Logically this is a three-column GFM table: the first header is `Claim | kind`,
and the Status value is `MYSTERY`. v8 splits the header into four raw pieces,
sets the Status index to 2, then reads the row's third logical cell `OPEN`.

Data-shift witness:

```markdown
Claim | Status | Note
--- | --- | ---
r1 \| **OPEN** | **MYSTERY** | note
```

Logically the first cell contains `r1 | OPEN`, while the Status value is
`MYSTERY`. v8 splits the escaped pipe, inspects the decoy `OPEN` at raw index 1,
and ignores the actual Status cell.

For each file under a matched `0:1` expectation, v8 reports **one table status
cell, `CLEAN`, exit 0**.

GFM's table extension expressly uses backslash-escaped pipes inside cells. A
checker that purports to discover tables structurally must therefore tokenize
logical cells, not split raw bytes.

**Required repair:** use a Markdown-table row lexer that respects escaped pipe
delimiters, including odd/even backslash-run parity, in headers and data rows.
The header and every row must share the same logical column model. Unsupported
or ambiguous tokenization on a Status-bearing table must fail closed. Both
decoy witnesses must become violations while valid escaped-pipe companions
still count the Status cell exactly once.

### SOL-R09-03 — RATIFICATION BLOCKER — exact-one enforcement recognizes only one strong-emphasis spelling

The first-token parser and second-token scanner are both asterisk-specific:

```python
m = re.match(r'\*\*([^*]+?)\*\*', cell)
BOLD = re.compile(r'\*\*([^*]+?)\*\*')
```

Consequently this ordinary table is certified clean:

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / __HISTORICAL__ | two bold primaries
```

Both legend strings are rendered as strong emphasis. v8 validates the first
`OPEN`; `BOLD.findall(rest)` cannot see the underscore-delimited
`HISTORICAL`; the supplied file reports **one table status cell, `CLEAN`, exit
0**.

This violates the inherited rule that a status-bearing row contain exactly one
bold primary legend token and that *any* second primary legend token be a
violation. It is the same semantic-laundering class as the original
`**OPEN** / **HISTORICAL**` control, merely using Markdown's other strong
delimiter.

**Required repair:** evaluate strong-emphasis tokens semantically—or, if the
house grammar permits only canonical `**…**` primaries, fail closed when an
alternate strong form contains a legend token. At minimum the exact
`**OPEN** / __HISTORICAL__` witness must fail, while bold non-legend annotations
must not be promoted into primary statuses.

---

## 6. Occurrence adjudication

`OCCURRENCE-ADJUDICATION-R0.9.md` was replayed independently against these five
successors:

- `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.9.md`
- `CLAIM-CEILING-R0.9.md`
- `SUCCESSION-DOCKET-R0.9.md`
- `OWNER-DOCKET-R0.9.md`
- `EVIDENCE-LEDGER-R0.9.md`

Results:

- actual regex occurrences in R0.1–R0.8 scope: **131**, all unique by
  file/line/ordinal/token;
- table rows: **131**, all unique by the same key;
- missing rows: **0**;
- extra rows: **0**;
- duplicate keys: **0**;
- ordinal mismatches: **0**;
- classifications: **113 HISTORICAL/PROVENANCE · 18 FROZEN-ARTIFACT NAME ·
  0 LIVE**.

All 18 FROZEN rows were inspected in source context. Each token occurs inside a
readback/source/sums/concordance artifact name or its explicitly abbreviated
backticked suffix. The remaining 113 occurrences date repairs, quote earlier
wording, or record revision provenance. No prior-version token serves as a live
current-candidate operand.

**SOL-R08-02 and the R0.9 census continuation are CLOSED WITHOUT RIDER.**

---

## 7. Disposition and boundary

**R0.9 is not docket-fit.** The owner docket remains silent.

The only remaining work exposed by this readback is checker work:

- Markdown inline-label normalization/fail-closed projection;
- Markdown-aware logical table-cell tokenization; and
- semantic exact-one-primary detection across strong-emphasis spellings.

Do **not** reopen:

- the constitutional text;
- SOL-R04-01;
- SOL-R08-02 or any earlier occurrence census/correction of record;
- the zero-LIVE conclusion;
- SOL-R02-03/W-14 or W-02…W-13;
- languagehood or authority holdings;
- independence coordinates;
- gate design or substantive fork triage;
- non-commencement clauses; or
- any of the ten frozen strata.

Evidence remains **zero**. This readback is same-root review and creates no new
independence coordinate.

---

## 8. Exact R0.10 commission

> **Return Candidate R0.10 as a strictly bounded checker-only repair. Preserve
> R0 through R0.9 byte-identical. Repair only SOL-R09-01, SOL-R09-02, and
> SOL-R09-03. Replace v8 with a new validator while freezing v8 in R0.9. First,
> replace the punctuation allowlist called a drawer guard with a Markdown-aware
> inline-label/plain-text projection or a genuinely conservative fail-closed
> equivalent: numeric/named character references, inline HTML carrying visible
> Status text, and image alt labels must be normalized or explicitly refused,
> never silently counted as 0:0. Second, tokenize GFM table rows into logical
> cells, respecting escaped pipes and backslash parity in both headers and data;
> the exact header-shift and data-shift OPEN-decoy fixtures in Sol R0.9 §5 must
> expose MYSTERY and fail. Third, enforce exactly one primary legend token across
> Markdown strong-emphasis spellings: `**OPEN** / __HISTORICAL__` must fail while
> non-legend strong annotations remain non-primary. Add the six exact negative
> witnesses and valid companions counted once; preserve all 26 negative and 12
> positive v8 controls plus every earlier coverage rule; rerun the canonical five
> R0.10 successors at unchanged coverage; carry the closed 131-row census without
> reclassification and regenerate only the ordinary R0.1–R0.9 custody
> continuation; align ordinary R0.10 identities; solicit nothing, activate
> nothing, and stop.**

---

## 9. Normative syntax references used for the hostile controls

- GitHub Flavored Markdown, tables and escaped cell pipes:
  <https://github.github.com/gfm/#tables-extension->
- Character and numeric references:
  <https://github.github.com/gfm/#entity-and-numeric-character-references>
- Raw inline HTML:
  <https://github.github.com/gfm/#raw-html>
- Images and alt-label content:
  <https://github.github.com/gfm/#images>

*— GPT-5.6 Sol, tenth-stratum readback, 2026-08-11. Candidate review only;
nothing adopted, solicited, activated, or commenced.*
