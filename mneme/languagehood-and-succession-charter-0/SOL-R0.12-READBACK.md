# SOL R0.12 READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0

**Readback date:** 2026-08-12  
**Object reviewed:** `languagehood-and-succession-charter-0-r0.12-2026-08-11.tar.gz` and its attached sidecar  
**Candidate:** R0.12 — not adopted  
**Chair disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.13 CHECKER REPAIR BEFORE OWNER DOCKET**

## 1. Disposition

R0.12 is **constitutionally and documentarily fit but not docket-fit**. The
sealed parcel, thirteen checksum strata, frozen ancestry, parcel tree, filed
R0.11 readback, five constitutional successors, and 134-row occurrence census
all authenticate and close cleanly.

`validate_status_grammar_v11.py` does not satisfy the center of the R0.12
commission. It delegates inline tokenization to `markdown-it-py`, but still
discovers tables with a hand-written top-level line scanner and discovers prose
Status declarations with raw regular expressions. It also validates only the
first prose Status carrier found in a parsed line. Five ordinary GFM witnesses
therefore print `CLEAN` and exit 0 while hiding invalid status content.

The candidate remains **NOT ADOPTED**. No owner disposition is solicited, no
docket is activated, no jurisdiction is reopened, and evidence remains zero.

## 2. Seal and custody

### 2.1 Archive identity

The return message printed a malformed digest ending `…8429fip`. The actual
archive and the attached sidecar independently agree on the valid SHA-256:

`ec672719a0999d63889947c049cf8b39ca1fce5a9671f56a67166ffff8429fa9`

This is an outer-message transcription defect, not an ambiguity in the sealed
object. The archive contains 146 members: 141 regular files and five
directories. It contains no absolute path, traversal path, symbolic link,
hard link, or special member.

### 2.2 Thirteen strata

All checksum regimes pass from inside an isolated extraction:

| Stratum | Result |
|---|---:|
| R0 | 7/7 PASS |
| R0.1 | 12/12 PASS |
| R0.2 | 10/10 PASS |
| R0.3 | 9/9 PASS |
| R0.4 | 9/9 PASS |
| R0.5 | 10/10 PASS |
| R0.6 | 10/10 PASS |
| R0.7 | 10/10 PASS |
| R0.8 | 10/10 PASS |
| R0.9 | 10/10 PASS |
| R0.10 | 10/10 PASS |
| R0.11 | 10/10 PASS |
| R0.12 | 10/10 PASS |

The authenticated R0.11 parcel and R0.12 parcel share 129 governed project
files. All 129 are byte-identical and mode-identical. R0.12 adds exactly the
expected eleven files: five `*-R0.12.md` successors, the filed Sol R0.11
readback, the R0.12 occurrence adjudication, repair concordance, return,
checksum file, and `validate_status_grammar_v11.py`.

The filed `SOL-R0.11-READBACK.md` has the R0.12 sums-recorded SHA-256
`08e273e630d084e945a44677f4c9c07a1b33658125fe7d4b4a94370e22d8c5de`
and is byte-identical to the issued readback.

### 2.3 Tree and commit identity

An independent Git-index reconstruction of the parcel directory yields:

`3b57f8f0fbe5c92d130881e3dd021442fcd9a8ae`

This exactly matches `GIT-IDENTITY-R0.12.txt` and the return. The commit object
`c65647b679677459bb4f49986d036bd0a793680f` is not available in this review
environment's Git object graph, so it remains repository-side metadata rather
than an independently authenticated commit identity here.

## 3. Reproduction of the committed validator claims

The review environment exposes two Python runtimes. Its default `python3`
(3.12.13) lacks `markdown_it`; `/usr/bin/python3` (3.12.3) contains
`markdown-it-py` 3.0.0. Under the latter, v11 reproduces its committed claims:

- self-test: **PASS — 39 negatives caught, 19 positives clean**;
- canonical five-file run: **CLEAN, exit 0**;
- canonical coverage: **10/6 · 0/16 · 4/0 · 0/0 · 0/0**.

The dependency discrepancy is not treated as a fourth semantic finding: the
R0.12 commission expressly allowed a conforming parser dependency. It does show
that “environment-present” is environment-relative. A successor should name
the supported interpreter/dependency version and emit a controlled dependency
diagnostic rather than an import traceback when the parser is absent.

## 4. Validator finding

### 4.1 Claimed architecture versus actual architecture

v11 constructs `MarkdownIt('commonmark').enable('strikethrough')` and uses it
for inline tokenization and reference resolution. It does **not** enable or
traverse the parser's table rule. Instead, table discovery remains:

- a raw `splitlines()` pass;
- a `SEP` regular expression over the next physical line;
- a hand-written `split_row()` lexer;
- a top-level `while` loop over physical lines containing `|`.

Prose discovery likewise remains outside the parse model:

- `ANY_DECL_LINE = re.compile(r'\*\*Status')` decides whether a declaration
  exists;
- `INLINE` and `SEPARATED` decide whether its spelling parses;
- only after those regexes admit a line are strong nodes consulted;
- `next(...)` selects only the first Status-like strong carrier on that line.

The parser is therefore an inline assistant, not the shared GFM semantic
authority required by commission steps 4–7.

### 4.2 SOL-R12-01 — block/table structure remains hand-written

This ordinary GFM table is nested in a blockquote:

```markdown
> Claim | Status | Note
> --- | --- | ---
> r1 | **MYSTERY** | hidden
```

With the table rule enabled, the selected parser emits a blockquote containing
`table_open`, header cells, and data cells. v11's top-level separator regex
never discovers it. Under a matched `0:0` ordinary invocation, v11 reports:

`0 declarations, 0 table status cells` → `CLEAN` → exit 0.

This is a direct failure of the commissioned requirement that table structure,
not merely inline labels, come from one actual GFM parse model.

### 4.3 SOL-R12-02 — prose carrier discovery remains punctuation-specific

The following three declarations have the same visible strong carrier,
`Status: MYSTERY`, under ordinary GFM inline semantics:

```markdown
__Status: MYSTERY__
**Sta&#116;us: MYSTERY**
**[Status](https://example.com/status): MYSTERY**
```

v11's parser can project underscores, character references, and link labels,
but its raw `**Status` discovery regex prevents the parser from ever seeing
these as declarations. Each supplied file reports `0 declarations, 0 table
status cells`, prints `CLEAN`, and exits 0 under a matched `0:0` expectation.

The defect is categorical: visible-label semantics govern tables and strong
annotations only after regex admission, while prose declaration identity is
still decided by one literal punctuation specimen.

### 4.4 SOL-R12-03 — only the first prose carrier on a line is validated

This line contains two syntactically admitted declarations:

```markdown
**Status: OPEN** and **Status: MYSTERY**
```

`INLINE.findall()` counts two declarations, so a `2:0` expectation is met.
The parse-model pass then uses `next(...)` to select only the first Status
carrier. `OPEN` is valid; the later `Status: MYSTERY` carrier is neither
validated as a second declaration nor recognized as a second primary legend.
The result is:

`2 declarations, 0 table status cells` → `CLEAN` → exit 0.

This defeats both complete declaration validation and uniform exact-one
enforcement.

### 4.5 Hostile result table

| Fixture | Expected enforcement | Observed |
|---|---|---|
| Blockquoted Status table with `MYSTERY` | violation | 0/0, CLEAN, exit 0 |
| `__Status: MYSTERY__` | violation | 0/0, CLEAN, exit 0 |
| Entity-bearing Status carrier | violation | 0/0, CLEAN, exit 0 |
| Link-bearing Status carrier | violation | 0/0, CLEAN, exit 0 |
| Two prose carriers; second is `MYSTERY` | violation | 2/0, CLEAN, exit 0 |

These are three implementation roots, not five new wrapper specimens.

## 5. Occurrence census

An independent two-digit-safe enumeration of `R0.1` through `R0.11` over the
five R0.12 successors finds exactly 134 occurrences. The adjudication contains
exactly 134 unique matching `(file, line, ordinal, token)` keys.

| Check | Result |
|---|---:|
| Actual occurrences | 134 |
| Census rows | 134 |
| Missing rows | 0 |
| Extra rows | 0 |
| Duplicate keys | 0 |
| Token/line/ordinal mismatches | 0 |
| HISTORICAL/PROVENANCE | 113 |
| FROZEN-ARTIFACT NAME | 21 |
| LIVE | 0 |

All 21 frozen-artifact rows are genuine filename, sums-file, readback, source
authentication, or concordance-list references. The other 113 are historical
or provenance uses. No stale live operand survives.

The five R0.11-to-R0.12 successor diffs are confined to current-version
identities, companion pointers, repair-history banners, and closing alignment.
None of the five governed files contains the hostile forms above. The
constitutional content therefore remains clean; the enforcement instrument is
the object that fails.

**Census disposition:** **CLOSED WITHOUT RESIDUE — 113
HISTORICAL/PROVENANCE · 21 FROZEN-ARTIFACT NAME · 0 LIVE.**

## 6. Finding disposition

| R0.11 finding | R0.12 disposition | Readback |
|---|---|---|
| SOL-R11-01 — comment-hidden Status columns | Exact witnesses closed; architectural commission not closed | Comments are tokenized correctly, but block/table discovery still bypasses the parser and misses valid contained tables. |
| SOL-R11-02 — shortcut reference second primary | Exact witness closed | Shortcut reference labels are resolved correctly after a surface is admitted. Prose carrier discovery still ignores visible-label equivalents. |
| SOL-R11-03 — prose exact-one missing | Exact witness closed; complete-carrier enforcement not closed | A later bare primary is caught after one carrier, but a second Status carrier on the same line is never validated. |
| R0.12 occurrence census | **CLOSED WITHOUT RESIDUE** | Exact 134-row continuation at 113/21/0. |

No constitutional holding, jurisdictional boundary, independence coordinate,
gate, triage ruling, non-commencement clause, or prior occurrence
classification should be reopened.

## 7. Exact R0.13 repair commission

Return a strictly bounded **checker-only R0.13**. Perform the following and
stop:

1. Preserve R0 through R0.12 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.12 readback verbatim in the R0.13 stratum and map exactly
   **SOL-R12-01/02/03** in the new repair concordance.
3. Replace v11 with `validate_status_grammar_v12.py`; keep v11 byte-frozen in
   R0.12.
4. Make the selected GFM parser the authority for **block and table structure**,
   not only inline content. Enable its GFM table rule and traverse its emitted
   table/header/body/cell tokens, including tables inside ordinary containers
   such as blockquotes. Raw separator regexes and physical-line row loops may
   not decide whether a table or logical cell exists.
5. Make the parser's visible strong-node labels the authority for **prose
   declaration discovery**. Both strong delimiter spellings, decoded character
   references, link labels, nested emphasis, and other represented inline forms
   must discover the same visible Status carrier. `ANY_DECL_LINE`, `INLINE`, or
   equivalent punctuation-specific regexes may not gate semantic discovery.
6. Validate **every** Status declaration carrier on an admitted prose surface,
   in order. Do not select the first with `next()` and leave later carriers
   uninterpreted. Each carrier must have one valid primary and must obey the
   same exact-one rule as every other prose declaration and table cell.
7. Preserve conservative refusal: any relevant parser token or ambiguous
   Status-like surface the walker cannot represent must produce a violation or
   coverage failure before `CLEAN`.
8. State the parser dependency and tested version in the validator's
   reproducibility surface. If the dependency is absent, fail with a controlled
   diagnostic. A vendored, provenance-recorded parser remains acceptable; an
   environment dependency remains acceptable if its required package/version
   and invocation are explicit.
9. Add these five exact negative controls: the blockquoted invalid table; the
   underscore-strong invalid declaration; the entity-bearing invalid carrier;
   the link-bearing invalid carrier; and the two-carrier line whose second
   declaration is invalid.
10. Add five positive companions: the same blockquoted table with one valid
    cell; valid underscore, entity-bearing, and link-bearing declarations; and
    a two-carrier line with two valid declarations, both counted and validated.
11. Preserve all **39 inherited negatives and 19 inherited positives**. If the
    five new negative and five new positive controls are the only additions,
    **44/24** is the expected cross-check, not a preordained total; report the
    actual self-test result.
12. Rerun the canonical five-file invocation at unchanged **10/6 · 0/16 · 4/0
    · 0/0 · 0/0** coverage. Demonstrate at least the blockquoted table, one
    visible-label prose variant, and the two-carrier line as supplied ordinary
    files, not only helper-level calls.
13. Continue the occurrence census mechanically over the five R0.13 successors
    with the same two-digit-safe matcher, ordinals, and fail-on-live rule. If
    only ordinary identity alignment moves, **135 · 113/22/0** is the expected
    cross-check, not a preordained result. Do not reopen any R0.12
    classification.
14. Seal the fourteenth stratum, round-trip it, file the campaign-log receipt,
    activate no docket, solicit no owner ruling, and stop.

### Explicitly out of scope

- the constitutional text and languagehood holdings;
- SOL-R04-01 and W-14;
- W-02 through W-13;
- semantic-jurisdiction and authority boundaries;
- independence coordinates;
- gate design and substantive fork triage;
- non-commencement clauses;
- every occurrence classification through R0.12;
- every earlier validator repair except where its control must be preserved;
- any campaign opening, evidence creation, adoption, publication, or owner
  disposition.

## 8. Owner action

**No owner action is solicited on R0.12.** The owner docket remains prepared and
silent. The next movement is the bounded R0.13 checker repair above.

*— Sol readback, 2026-08-12. Candidate review only; adopts nothing, opens
nothing, and creates no evidence.*
