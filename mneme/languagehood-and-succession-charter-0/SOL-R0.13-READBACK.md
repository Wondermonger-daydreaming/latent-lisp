# SOL R0.13 READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0

**Readback date:** 2026-08-12  
**Object reviewed:** `languagehood-and-succession-charter-0-r0.13-2026-08-12.tar.gz` and its attached sidecar  
**Candidate:** R0.13 — not adopted  
**Chair disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.14 CHECKER REPAIR BEFORE OWNER DOCKET**

## 1. Disposition

R0.13 is **constitutionally and documentarily fit but not docket-fit**. The
sealed parcel, fourteen checksum strata, frozen ancestry, parcel tree, filed
R0.12 readback, five constitutional successors, and 135-row occurrence census
all authenticate and close cleanly.

`validate_status_grammar_v12.py` genuinely dismisses the former regex clerk
from block/table discovery and ordinary Markdown strong-node discovery. Its
declared controls and canonical run reproduce. Four category-level false-green
roots nevertheless remain at the boundary between the parser's token stream
and the enforcement walk:

1. raw HTML `<strong>` carriers are rendered but semantically erased;
2. prose exact-one accounting ignores primary legends before the first carrier;
3. the ambiguity tripwire is cleared per physical line, so one valid carrier
   masks an unresolved Status-like spelling on that same line; and
4. a table Status cell may carry a valid first primary plus a later invalid
   strong Status carrier, because table cells are excluded from prose-carrier
   accounting.

Each supplied ordinary file prints `CLEAN` and exits 0. The candidate remains
**NOT ADOPTED**. No owner disposition is solicited, no docket is activated, no
jurisdiction is reopened, and evidence remains zero.

## 2. Seal and custody

### 2.1 Archive identity

Computed SHA-256 and the attached sidecar agree exactly:

`4ca77f1fb38659bf90390f8fa73a6ff7d0f9ebae00f3a7f00525fcf22ad868a5`

The archive contains 157 members: 152 regular files and five directories. It
contains no absolute path, traversal path, symbolic link, hard link, or special
member. One regular file is the outer `GIT-IDENTITY-R0.13.txt`; the governed
parcel directory contains 151 files.

### 2.2 Fourteen strata

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
| R0.13 | 10/10 PASS |

The authenticated R0.12 parcel and R0.13 parcel share 140 governed project
files. All 140 are byte-identical and mode-identical. R0.13 adds exactly the
expected eleven files: five `*-R0.13.md` successors, the filed Sol R0.12
readback, the R0.13 occurrence adjudication, repair concordance, return,
checksum file, and `validate_status_grammar_v12.py`.

The filed `SOL-R0.12-READBACK.md` has the R0.13 sums-recorded SHA-256
`621349df2e1049444e62da77d5858968d1c3a55fb25224e0f26d273893ac865c`
and is byte-identical to the issued readback.

### 2.3 Tree and commit identity

An independent Git-index reconstruction of the governed parcel directory
yields:

`cccb303b9e599a45dd935ff0957c1751ab3ce450`

This exactly matches `GIT-IDENTITY-R0.13.txt` and the return. The commit object
`eb435f0eb7d90ab2574580d8843453775a8d66e3` is not available in this review
environment's Git object graph, so it remains repository-side metadata rather
than an independently authenticated commit identity here.

## 3. Reproduction of the committed validator claims

Under `/usr/bin/python3`, which carries `markdown-it-py` 3.0.0, v12 reproduces
all committed claims:

- self-test: **PASS — 44 negatives caught, 24 positives clean**;
- canonical five-file run: **CLEAN, exit 0**;
- canonical coverage: **10/6 · 0/16 · 4/0 · 0/0 · 0/0**;
- every `CLEAN` line names `markdown-it-py 3.0.0`; and
- an interpreter without `markdown_it` receives a controlled two-line
  dependency diagnostic and exit 3, not a traceback.

The review environment does not independently reproduce the builder's stated
4.0.0 run, but 3.0.0 is one of the two explicitly declared and builder-tested
versions. No portability rider remains from R0.12.

## 4. Validator findings

### 4.1 Claimed architecture versus actual architecture

v12 now uses the parser's `table_open`/`thead`/`tbody`/`tr`/`th`/`td` stream and
discovers ordinary Markdown prose carriers from parsed strong nodes. Those are
real repairs. The remaining defect is the policy layer built over that stream:

- `html_inline` is placed in `SKIP`, while `html_block` tokens are ignored at
  block level; raw HTML structure therefore contributes neither a carrier nor
  a conservative refusal;
- the prose label loop ignores every primary legend until `surface_decls` has
  become nonzero;
- `carrier_lines` records only a token's first source line and clears the raw
  ambiguity tripwire for the entire physical line; and
- table-cell validation checks later strong labels only with
  `is_primary_legend()`, never asking whether a later label is itself a Status
  carrier.

The parser is now at admissions, but the enforcement walker still leaves four
semantic node classes without an assigned role.

### 4.2 SOL-R13-01 — raw HTML strong carriers are erased

This is valid GFM raw HTML and renders a strong Status declaration:

```markdown
<strong>Status: MYSTERY</strong>
```

`markdown-it-py` emits `html_inline('<strong>')`, text
`Status: MYSTERY`, and `html_inline('</strong>')`. v12's `strong_labels()`
silently skips both HTML tokens and sees no strong carrier. With a matched
`0:0` expectation, the supplied file reports:

`0 declarations, 0 table status cells` → `CLEAN` → exit 0.

The block spelling is erased even earlier:

```html
<strong>
Status: MYSTERY
</strong>
```

The parser emits one `html_block`; the validator does not inspect it. GFM
specifies both [raw HTML inlines](https://github.github.com/gfm/#raw-html) and
[HTML blocks](https://github.github.com/gfm/#html-blocks), and `<strong>` is not
one of GFM's tag-filtered elements. A conforming enforcement surface may
interpret these carriers or refuse relevant raw HTML conservatively. It may not
render them and then call their semantics invisible.

### 4.3 SOL-R13-02 — exact-one prose accounting is order-dependent

This surface visibly contains two primary legends: the unbound leading
`HISTORICAL`, and the `OPEN` primary carried by the later Status declaration:

```markdown
**HISTORICAL** / **Status: OPEN**
```

v12 walks strong labels left to right. Because `surface_decls` is still zero
when it encounters `HISTORICAL`, it ignores that primary. It then accepts
`Status: OPEN` and never revisits the prefix. Under `1:0` the supplied file
reports:

`1 declaration, 0 table status cells` → `CLEAN` → exit 0.

This directly contradicts the R0.13 concordance's category claim that “every
other strong legend label on the surface is an exact-one violation.” The rule
is presently “every later strong legend,” not every other legend.

### 4.4 SOL-R13-03 — one valid carrier masks same-line ambiguity

The inherited ambiguity rule correctly refuses a lone unresolved spelling such
as `**Status wording that never parses`. It fails when the same physical line
also contains one valid carrier:

```markdown
**Status wording that never parses and **Status: OPEN**
```

The parser emits the unresolved prefix as literal text and emits the final
`Status: OPEN` as a valid strong carrier. v12 adds that physical line to
`carrier_lines`; the later raw-source pass therefore suppresses its only
ambiguity tripwire for the whole line. Under `1:0`, the supplied file reports:

`1 declaration, 0 table status cells` → `CLEAN` → exit 0.

Thus the last regex does sometimes admit what it was retained only to refuse.
The same line-granularity shortcut causes a false refusal in the other
direction: a valid carrier on the second physical line of one soft-wrapped
paragraph is mapped to the paragraph's first line and then accused of being
unparsed on line two. The repair needs parser-span or token-level accounting,
not a set of physical lines.

### 4.5 SOL-R13-04 — table cells exclude later Status carriers

This ordinary table has one valid first primary in its Status cell and a later
invalid strong Status carrier:

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / **Status: MYSTERY** | hidden secondary carrier
```

The table walker validates `OPEN`. Its later-label scan asks only whether
`Status: MYSTERY` is itself a member of the primary legend; it is not. Because
the whole table token range is skipped by the prose walker and exempted from
the ambiguity tripwire, the secondary carrier is never assigned any semantic
role. Under `0:1`, the supplied file reports:

`0 declarations, 1 table status cells` → `CLEAN` → exit 0.

Non-legend strong annotations may remain legal; a strong Status carrier is not
an inert annotation. A shared surface inventory must either validate it under
an explicit table policy or conservatively refuse it.

### 4.6 Hostile result table

| Fixture | Expected enforcement | Observed |
|---|---|---|
| Inline raw-HTML `<strong>Status: MYSTERY</strong>` | violation/refusal | 0/0, CLEAN, exit 0 |
| Raw-HTML block carrying strong `Status: MYSTERY` | violation/refusal | 0/0, CLEAN, exit 0 |
| Primary legend before valid Status carrier | exact-one violation | 1/0, CLEAN, exit 0 |
| Unresolved `**Status` prefix beside valid carrier | ambiguity violation | 1/0, CLEAN, exit 0 |
| Valid table primary plus later invalid Status carrier | violation/refusal | 0/1, CLEAN, exit 0 |

These are four implementation roots, not five wrapper specimens.

## 5. Occurrence census and successor text

An independent two-digit-safe enumeration of `R0.1` through `R0.12` over the
five R0.13 successors finds exactly 135 occurrences. The adjudication contains
exactly 135 unique matching `(file, line, ordinal, token)` keys.

| Check | Result |
|---|---:|
| Actual occurrences | 135 |
| Census rows | 135 |
| Missing rows | 0 |
| Extra rows | 0 |
| Duplicate keys | 0 |
| Token/line/ordinal mismatches | 0 |
| HISTORICAL/PROVENANCE | 113 |
| FROZEN-ARTIFACT NAME | 22 |
| LIVE | 0 |

All 22 frozen-artifact rows are genuine filename, sums-file, readback, source
authentication, or concordance-list references. The other 113 are historical
or provenance uses. No stale live operand survives.

The five R0.12-to-R0.13 successor diffs preserve all substantive constitutional
content. They are confined to current-version identities, companion pointers,
repair-history banners, and closing alignment. None of the five governed files
contains the hostile forms above. The constitutional content therefore remains
clean; the enforcement instrument is the ratification blocker.

**Census disposition:** **CLOSED WITHOUT RESIDUE — 113
HISTORICAL/PROVENANCE · 22 FROZEN-ARTIFACT NAME · 0 LIVE.**

### 5.1 Mechanical current-date rider

The R0.13 successor metadata is internally inconsistent across the calendar
boundary:

- the charter footer says it was prepared on 2026-08-12, while its top
  `**Date:**` field remains 2026-08-11;
- the owner docket banner says `CANDIDATE R0.13 — 2026-08-12`, while its current
  R0.13 signature still says 2026-08-11; and
- the current R0.13 succession-docket signature still says 2026-08-11.

This is not a constitutional or census finding and does not disturb the zero-
LIVE result. The R0.14 successor copies should make current-version date
metadata coherent with their actual seal date (or explicitly label a preserved
date as the original-draft date). Frozen R0.13 remains untouched.

## 6. Finding disposition

| R0.12 finding | R0.13 disposition | Readback |
|---|---|---|
| SOL-R12-01 — block/table structure hand-parsed | Exact witness and category closed | Parser table tokens now govern ordinary tables in containers, including blockquotes. |
| SOL-R12-02 — prose discovery regex-gated | Exact witnesses closed | Ordinary Markdown visible strong carriers are parser-discovered; raw HTML semantic carriers remain outside the walk. |
| SOL-R12-03 — only first prose carrier validated | Exact witness closed | Every discovered carrier is visited, but prefix primaries and same-line unresolved spellings remain unaccounted. |
| R0.13 occurrence census | **CLOSED WITHOUT RESIDUE** | Exact 135-row continuation at 113/22/0. |

No constitutional holding, jurisdictional boundary, independence coordinate,
gate, triage ruling, non-commencement clause, or prior occurrence
classification should be reopened.

## 7. Exact R0.14 repair commission

Return a strictly bounded **checker-only R0.14** with mechanical successor
identity alignment. Perform the following and stop:

1. Preserve R0 through R0.13 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.13 readback verbatim in the R0.14 stratum and map exactly
   **SOL-R13-01/02/03/04** in the new repair concordance.
3. Replace v12 with `validate_status_grammar_v13.py`; keep v12 byte-frozen in
   R0.13.
4. For raw HTML, choose one explicit fail-closed policy and apply it to both
   parser token classes. Either represent `<strong>`/`<b>` nesting well enough
   to discover visible Status carriers, or conservatively refuse Status-like
   content inside relevant `html_inline` and `html_block` surfaces. Silently
   placing raw HTML tags in `SKIP`, or ignoring an `html_block`, is forbidden.
5. Make prose exact-one accounting whole-surface and order-invariant. Inventory
   all Status carriers and all primary-legend nodes before role assignment;
   bind exactly one primary to each carrier; reject every unbound primary
   regardless of whether it occurs before, between, or after carriers.
6. Replace line-level ambiguity clearance with parser-span or token-level
   accounting. A valid carrier may clear only the source/semantic construct it
   actually represents; it may not clear another unresolved `**Status`
   spelling elsewhere on the same physical line. A parser-resolved carrier on
   a later line of one soft-wrapped paragraph must not be falsely refused.
7. Extend the same semantic inventory to Status table cells. After the one
   admitted primary, any later Status-like strong carrier must be validated
   under an explicit rule or conservatively refused; it cannot disappear merely
   because the table range is excluded from prose processing. Preserve legal
   non-legend strong annotations.
8. Preserve the declared `markdown-it-py` reproducibility surface, loaded-
   version `CLEAN` report, and controlled dependency-missing exit 3.
9. Add these five exact negative controls:
   - inline `<strong>Status: MYSTERY</strong>`;
   - block-form `<strong>` containing `Status: MYSTERY`;
   - `**HISTORICAL** / **Status: OPEN**`;
   - `**Status wording that never parses and **Status: OPEN**`; and
   - a Status table cell containing `**OPEN** / **Status: MYSTERY**`.
10. Add at least these three positive companions:
    - a non-legend strong annotation before a valid Status carrier;
    - a valid Status carrier on the second physical line of one soft-wrapped
      paragraph, counted once and not falsely refused; and
    - unrelated raw HTML beside one valid Markdown Status carrier, unless the
      documented policy conservatively refuses all raw HTML on a relevant
      surface.
    Preserve the inherited valid table companion with a non-legend strong
    annotation after its primary.
11. Preserve all **44 inherited negatives and 24 inherited positives**. If the
    five new negatives and three new positives are the only additions,
    **49/27** is the expected cross-check, not a preordained total; report the
    actual self-test result.
12. Demonstrate at least the inline raw-HTML carrier, pre-carrier primary,
    same-line ambiguity, and secondary table carrier as supplied ordinary
    files, not only helper-level calls.
13. Rerun the canonical five-file invocation at unchanged **10/6 · 0/16 · 4/0
    · 0/0 · 0/0** coverage.
14. Continue the occurrence census mechanically over the five R0.14 successors
    with the same two-digit-safe matcher, ordinals, and fail-on-live rule. If
    only ordinary identity/repair-history alignment moves, **136 · 113/23/0**
    is the expected cross-check, not a preordained result. Do not reopen any
    R0.13 classification.
15. In the R0.14 successor copies only, make current-revision date metadata
    internally coherent with the actual seal date, or explicitly distinguish
    original-draft dates from current-revision dates. Do not alter frozen
    R0.13.
16. Seal the fifteenth stratum, round-trip it, file the campaign-log receipt,
    activate no docket, solicit no owner ruling, and stop.

### Explicitly out of scope

- the constitutional text and languagehood holdings;
- SOL-R04-01 and W-14;
- W-02 through W-13;
- semantic-jurisdiction and authority boundaries;
- independence coordinates;
- gate design and substantive fork triage;
- non-commencement clauses;
- every occurrence classification through R0.13;
- every earlier validator repair except where its control must be preserved;
- any campaign opening, evidence creation, adoption, publication, or owner
  disposition.

## 8. Owner action

**No owner action is solicited on R0.13.** The owner docket remains prepared and
silent. The next movement is the bounded R0.14 checker repair above.

*— Sol readback, 2026-08-12. Candidate review only; adopts nothing, opens
nothing, and creates no evidence.*
