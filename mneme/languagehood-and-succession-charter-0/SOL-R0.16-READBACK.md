# SOL R0.16 READBACK — LISP+ LANGUAGEHOOD AND SUCCESSION CHARTER /0

**Reviewer:** GPT-5.6 Sol, cold chair readback  
**Date:** 2026-08-12  
**Object:** `languagehood-and-succession-charter-0-r0.16-2026-08-12.tar.gz`  
**Candidate standing:** R0.16 is returned, unadopted, and non-self-ratifying;
no owner docket is activated by this readback.

## 1. Disposition

**RETURN TO FABLE FOR STRICTLY BOUNDED R0.17 CHECKER REPAIR BEFORE OWNER
DOCKET.**

R0.16's custody, constitutional text, occurrence census, evidence state,
jurisdiction boundaries, date rider, and docket staging are sound. The
governed five-file corpus is clean under v15 and contains none of the hostile
forms found below.

The validator is not yet docket-fit. Three enforcement roots remain:

1. table headers bypass the exact-identity and recursive strong-node walker;
2. inline raw HTML has no visibility state, unlike block raw HTML;
3. invisible Unicode format characters can sever `Status` recognition while
   changing no rendered glyph.

These are checker findings only. They do not reopen any constitutional
holding, languagehood classification, evidence judgment, census
classification, authority boundary, gate design, or owner fork.

## 2. Custody and identity

### 2.1 Outer archive

- Computed archive SHA-256:
  `118de0d79b5f038915ca722a1d26724e3c37cd01046401c0e3c17d042d1e51fc`.
- Sidecar SHA-256: the same full digest.
- Shape: **190 members — 185 regular files and five directories**.
- No links, special members, absolute paths, or traversal paths occur.
- The archive extracts cleanly in an isolated directory with ownership
  restoration disabled; no source byte is modified.

### 2.2 Seventeen frozen strata

All checksum authorities pass from inside the sealed archive:

**7/7 · 12/12 · 10/10 · 9/9 · 9/9 · 10/10 · 10/10 · 10/10 · 10/10 ·
10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10.**

The authenticated R0.15 archive was extracted independently. Comparison of
the project directories establishes:

- **173 inherited project files** are byte-identical;
- the same **173 inherited files** are mode-identical;
- R0.16 adds exactly the expected eleven project files:
  the five successors, filed Sol readback, v15 validator, occurrence
  adjudication, concordance, return, and R0.16 sums file;
- the archive-level Git identity receipt is outside the parcel directory and
  reconciles the archive's twelfth seal-round addition.

### 2.3 Filed readback, parcel tree, and commit

`SOL-R0.15-READBACK.md` is byte-identical to the issued Sol file, mode 0644,
at full SHA-256:

`a6c25e8507a11a0b753b7346cfe9394668ef2d9f9595f39843ae8439a07edd1c`.

An independent Git-index reconstruction over the extracted parcel directory
yields:

`0f54ba991fca93b8745ca370e1a24b618c1cfaed`.

This exactly matches the sealed identity receipt. Candidate commit
`e7094751cd9b1eee12a113ac37ac740f2ff00d49` is recorded in that receipt but is
not reachable in this isolated review workspace; it therefore remains
repository-side metadata here rather than an independently traversed commit
object.

## 3. Reproduction of the returned instrument

Under the `markdown-it-py 3.0.0` runtime available in this review environment:

- self-test: **PASS — 63 negatives caught, 33 positives clean**;
- canonical five-file run: **CLEAN, exit 0**;
- canonical coverage: **10/6 · 0/16 · 4/0 · 0/0 · 0/0**;
- every `CLEAN` line names the loaded parser version;
- dependency absence under the default interpreter remains a controlled exit
  3 rather than a traceback.

`markdown-it-py 4.0.0` is not installed in this review environment. The
sealed record states that both self-test and canonical run were independently
executed under 4.0.0 and 3.0.0 on the build host with identical results. That
cross-version claim is documentarily authenticated here; only 3.0.0 is
independently executed here.

The three R0.15-commissioned repairs are real on the surfaces they traverse:

- `html_block` receives a visibility projection rather than the former raw
  substring screen;
- the inline boundary stack distinguishes Markdown strong, `<strong>`, and
  `<b>`, refusing mismatches and interleaving where the stack is invoked;
- every nested strong node visited by `label_inventory()` is emitted in
  opening order rather than only when the outer stack empties.

The failures below arise at boundaries where those mechanisms are not
invoked or where their visibility model is incomplete.

## 4. Findings

### SOL-R16-01 — BLOCKER — table headers bypass the strong-node walk

#### Mechanism

The table-header branch computes:

1. `visible(th.children).strip()`;
2. `lab.lower().startswith('status')` for column selection;
3. `surface_ambiguity(th.children)` for unresolved delimiter spellings.

It never calls `label_inventory()` on a header cell. Consequently the header
surface does not receive either of the two repairs R0.16 claims to apply
uniformly across prose, Status cells, non-Status cells, **and headers**:

- exact raw tag identity is not checked;
- descendant strong nodes are not inventoried.

#### Ordinary-file witnesses

**A. Mismatched raw boundary in a live Status header**

```markdown
Claim | <strong>Status</b> | Note
--- | --- | ---
r1 | **OPEN** | malformed header boundary
```

Actual result:

```text
0 declarations, 1 table status cells
CLEAN
exit 0
```

The row happens to be valid, so the unexamined header mismatch is the only
defect and passes silently. This directly contradicts the promised
conservative-refusal policy for mismatched raw strong structure.

**B. Nested Status header disappears into an outer label**

```markdown
Claim | <strong>NOTE <strong>Status</strong></strong> | Note
--- | --- | ---
r1 | **MYSTERY** | descendant header label
```

Actual result:

```text
0 declarations, 0 table status cells
CLEAN
exit 0
```

The visible outer header string is `NOTE Status`, which does not begin with
`Status`; because descendant labels are never inventoried in headers, the
column is not classified and `MYSTERY` is never validated.

The matched companion `<strong>Status</strong>` with `**OPEN**` is clean at
one table Status cell, confirming that the defect is header enforcement, not
raw strong support in general.

#### Required property

Every header cell must participate in the same exact-identity and recursive
strong-node inventory as the other inline surfaces before column-role
assignment. A malformed or unrepresentable raw-strong header must refuse.
A descendant Status label must either classify the column under one explicit
header rule or conservatively refuse as an ambiguous header; it may not
disappear because an ancestor contributes the first visible word.

### SOL-R16-02 — BLOCKER — inline raw HTML has no visibility state

#### Mechanism

v15 gives `html_block` a stateful projection: script/style bodies are
invisible and separation-rendering tags contribute whitespace. Its inline
helpers do not implement the same model:

- `html_inline` tag tokens contribute nothing;
- the text tokens between their opening and closing tags always contribute;
- no inline element stack marks `script`/`style` descendants invisible;
- no inline tag role contributes rendered separation such as `<br>`.

Thus inline raw HTML is neither symmetric with block HTML nor a projection of
the rendered surface. Invisible children can be inserted into a word to make
it fail semantic comparison, while separating tags can be deleted to make two
visible fragments falsely fuse.

#### Ordinary-file witnesses

**A. Invisible script content defeats a prose carrier**

```markdown
**Sta<script>invisible</script>tus: MYSTERY**
```

The browser-visible strong text is `Status: MYSTERY`; the validator's label
is `Stainvisibletus: MYSTERY`.

```text
0 declarations, 0 table status cells
CLEAN
exit 0
```

**B. The same insertion defeats Status-column discovery**

```markdown
Claim | Sta<script>invisible</script>tus | Note
--- | --- | ---
r1 | **MYSTERY** | visually Status
```

Actual result: **0 declarations · 0 cells · CLEAN · exit 0**.

**C. Converse false refusal**

```markdown
ordinary visible text <script>**Status wording that never parses</script>
```

The Status-like text is entirely inside an invisible script body, yet v15
reports an unresolved visible-surface spelling and exits 1.

**D. Separation is deleted**

```markdown
**Sta<br>tus: MYSTERY**
```

The rendered break prevents a contiguous `Status`, but v15 fuses the text,
counts one declaration, and refuses `MYSTERY`.

#### Required property

Inline raw HTML must use one explicit stateful visibility policy across
prose, headers, Status cells, non-Status cells, ambiguity streams, and strong
label accumulation. At minimum:

- script/style bodies do not contribute visible text;
- tags that render separation contribute whitespace rather than silence;
- comments and non-separating markup follow the already declared fusion rule;
- attributes and tag syntax do not become text;
- any inline element scope the selected model cannot represent safely is
  refused before `CLEAN`.

A single shared projection should feed carrier discovery, header discovery,
ambiguity detection, and label construction; separate approximations are how
the present asymmetry arose.

### SOL-R16-03 — BLOCKER — invisible Unicode format characters sever Status recognition

#### Mechanism

Character references are correctly decoded, but the resulting strings are
compared literally. U+200B ZERO WIDTH SPACE is a Unicode format character that
renders no glyph. Inserted inside `Status`, it changes the Python string while
leaving the reader-visible word contiguous. Neither `is_carrier()`, header
discovery, nor `AMBIG_STATUSISH` uses a semantic comparison key that accounts
for this class.

This is not a confusable-character complaint. The witness inserts no alternate
letter or lookalike glyph; it inserts an invisible formatting code point into
the exact ASCII word.

#### Ordinary-file witnesses

**A. Strong prose carrier**

```markdown
**Sta&#x200B;tus: MYSTERY**
```

Parser text: `Sta\u200btus: MYSTERY`.  
Actual result: **0 declarations · 0 cells · CLEAN · exit 0**.

**B. Table header**

```markdown
Claim | Sta&#x200B;tus | Note
--- | --- | ---
r1 | **MYSTERY** | visually Status
```

Actual result: **0 declarations · 0 cells · CLEAN · exit 0**.

**C. Projected raw HTML block**

```markdown
<div>
**Sta&#x200B;tus wording that never parses
</div>
```

The block projector decodes the entity but the ambiguity inventory misses the
result: **0 declarations · 0 cells · CLEAN · exit 0**.

#### Required property

Define one bounded Unicode-format policy for Status recognition. At minimum,
Unicode `Cf` format characters capable of occurring invisibly inside or next
to a Status-like spelling must not create a clean bypass. The implementation
may build a comparison-only key that removes them and then conservatively
refuse the disguised form, or refuse such characters directly in a candidate
Status surface. Apply the same rule to:

- prose carriers;
- table-header discovery;
- Status and non-Status cells;
- inline and block ambiguity projections;
- code spans and code blocks where unresolved spellings are screened.

Do not silently broaden this repair into general NFKC or Unicode-confusable
folding. The commissioned property is narrower: an invisible formatting code
point must not make the exact word `Status` semantically disappear.

## 5. Documentary closure

### 5.1 Occurrence census

An independent two-digit-safe enumeration over the five R0.16 successors
finds exactly **138 actual occurrences**, all unique by
`(file, line, ordinal, token)`.

The R0.16 adjudication contains exactly **138 rows** and **138 unique matching
keys**:

- missing: 0;
- extra: 0;
- duplicate actual keys: 0;
- duplicate adjudication keys: 0;
- token, line, and ordinal mismatches: 0.

Class totals are exactly:

- **113 HISTORICAL/PROVENANCE**;
- **25 FROZEN-ARTIFACT NAME**;
- **0 LIVE**.

Per-file actual counts are 60 charter, 7 claim ceiling, 24 succession docket,
20 owner docket, and 27 evidence ledger. The 25 frozen rows are actual filed
readback names, sums/concordance suffixes, or frozen-artifact filename
references. No classification is substantively reopened.

The inherited R0.15 census also independently replays at **137 unique rows —
113/24/0**, with no residue.

### 5.2 Successor and date review

Diffs from the frozen R0.15 successors contain only:

- current identity and banner alignment from R0.15 to R0.16;
- current pointers to the R0.16 charter, claim ceiling, owner docket, and
  occurrence table;
- repair-history alignment from the two R0.14 findings to the three R0.15
  findings;
- corresponding footer and succession-line identity changes.

No claim wording, status, jurisdiction boundary, gate, authority relation,
owner-fork content, evidence row, or ceiling moved. Current revision dates are
coherent at **2026-08-12**; historical August 11 dates remain attributed to
their historical acts.

### 5.3 Governed corpus

The five canonical R0.16 files contain:

- no raw `<script>`, `<style>`, `<strong>`, or `<b>` markup;
- no Unicode `Cf` format characters;
- none of the header, inline-HTML, or zero-width hostile forms above.

Their current Status grammar remains clean at the reproduced canonical
coverage. The findings therefore impeach the enforcement category, not the
constitutional text it presently guards.

## 6. Boundary of this return

| Object | Standing after R0.16 readback |
|---|---|
| Archive and seventeen strata | AUTHENTICATED / CLOSED |
| Constitutional text and languagehood holdings | CLOSED / DOCKET-FIT |
| Occurrence census through R0.16 | CLOSED |
| Date coherence | CLOSED |
| Evidence state | ZERO; unchanged |
| Owner and succession dockets | PREPARED; NOT SOLICITED; NOT ACTIVATED |
| v15 returned controls | REPRODUCED |
| v15 enforcement category | NOT DOCKET-FIT |
| Required next movement | checker-only R0.17 |

The constitutional corpus does not move in R0.17 except ordinary successor
identity and repair-history pointers required by the new stratum.

## 7. Exact R0.17 repair commission

1. Preserve R0 through R0.16 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.16 readback verbatim in the R0.17 stratum and map exactly
   **SOL-R16-01/02/03** in the new repair concordance.
3. Replace v15 with `validate_status_grammar_v16.py`; keep v15 byte-frozen in
   R0.16.
4. Make table headers participate in the same exact-identity and recursive
   strong-node walk used by prose and data cells. Header processing must not
   rely only on flattened visible text plus ambiguity regex.
5. Refuse mismatched, interleaved, malformed, or unclosed raw strong structure
   in a header before `CLEAN`, including `<strong>Status</b>` with an otherwise
   valid row.
6. Give descendant Status labels in headers one explicit rule: classify the
   column or conservatively refuse the ambiguous header. No descendant Status
   node may disappear into an ancestor label.
7. Replace the stateless inline-HTML treatment with one visibility-aware
   element policy shared by prose, headers, both table-cell classes,
   ambiguity streams, and strong-label accumulation.
8. Under that policy, invisible script/style bodies contribute no text;
   separation-rendering tags contribute whitespace; comments and
   non-separating markup follow the declared fusion rule; attributes and tag
   syntax contribute no text. Refuse any stateful inline construct the model
   cannot safely represent.
9. Use the same projected inline text for carrier discovery, header discovery,
   unresolved-spelling detection, and label construction. Do not maintain
   mutually inconsistent visibility helpers.
10. Define one bounded semantic-comparison policy for invisible Unicode
    format characters in Status-like spellings. At minimum, `Cf` characters
    such as U+200B, U+2060, and U+FEFF must not create a clean bypass after
    literal or entity-decoded input.
11. Apply that Unicode-format policy uniformly to prose, headers, Status cells,
    non-Status cells, inline/block ambiguity projections, code spans, and code
    blocks. Do not broaden the repair into general confusable or NFKC folding.
12. Add at least these nine negative controls:
    - mismatched `<strong>Status</b>` header with a valid `OPEN` row;
    - nested raw/raw Status header hiding an invalid row token;
    - nested raw/Markdown Status header hiding an invalid row token;
    - script-split visible prose carrier with `MYSTERY`;
    - style-split visible Status header with `MYSTERY`;
    - U+200B prose carrier with `MYSTERY`;
    - U+2060 Status header with `MYSTERY`;
    - U+FEFF projected block ambiguity;
    - a format-character code-block ambiguity witness.
13. Add at least these five positive companions:
    - matched `<strong>Status</strong>` header with one valid cell;
    - legal nested non-Status header annotation beside one ordinary Status
      column, with no phantom column;
    - Status-like text confined entirely to an invisible inline script/style
      body, contributing no declaration or ambiguity;
    - `Sta<br>tus` remaining separated and therefore not becoming a Status
      carrier;
    - an ordinary visibly separated `Sta tus` control remaining non-carrier.
14. Preserve all **63 inherited negatives and 33 inherited positives**. If the
    nine negatives and five positives above are the only additions,
    **72/38** is the expected cross-check, not a preordained result; report the
    actual totals.
15. Demonstrate at least the mismatched header, nested header, inline-script
    prose, inline-script header, U+200B prose, U+200B header, and projected
    block witnesses as supplied ordinary files, not only helper-level calls.
16. Preserve the declared `markdown-it-py` 4.0.0/3.0.0 reproducibility
    surface, loaded-version `CLEAN` report, and controlled dependency-missing
    exit 3. Execute the self-test and canonical run under both declared
    versions; state exactly which runs were independently executed.
17. Rerun the canonical five-file invocation at unchanged
    **10/6 · 0/16 · 4/0 · 0/0 · 0/0** coverage and confirm that the governed
    files contain none of the three hostile categories.
18. Continue the occurrence census mechanically over the five R0.17
    successors with the same two-digit-safe matcher, ordinals, and
    fail-on-live rule. If only ordinary identity and repair-history alignment
    move, **139 · 113/26/0** is the expected cross-check, not a preordained
    result. Do not reopen any R0.16 classification.
19. Keep current-version date metadata coherent with the actual R0.17 seal
    date. Do not alter frozen historical dates.
20. Seal the eighteenth stratum, round-trip it, file the campaign-log receipt,
    activate no docket, solicit no owner ruling, create no evidence, and stop.

Out of scope:

- constitutional wording and languagehood holdings;
- SOL-R04-01 and every adopted jurisdiction/authority boundary;
- W-02 through W-14 and their standing classifications;
- gate architecture, triaged owner forks, and campaign designs;
- substantive evidence adjudication;
- all occurrence classifications through R0.16;
- all seventeen frozen strata.

## 8. Owner action

Do not open the owner docket on R0.16. Return this readback to Fable for the
bounded R0.17 checker repair above. After R0.17 is sealed, Sol should perform
one fresh readback against the full archive before any owner disposition is
solicited.

*The receptionist now walks every nested delegation he is handed. The final
defects are in routing: headers never enter his office, inline HTML arrives
without an invisibility manifest, and a zero-width passenger can still pass
between the letters on one ticket.*
