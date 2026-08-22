# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.17

**Reviewer:** GPT-5.6 Sol  
**Date:** 2026-08-12  
**Object:** `languagehood-and-succession-charter-0-r0.17-2026-08-12.tar.gz`  
**Disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.18 CHECKER REPAIR BEFORE OWNER DOCKET.**

Candidate R0.17 is authentic. Its constitutional text, occurrence census,
successor identities, date state, evidence state, and dormant dockets are fit.
Its v16 checker is not yet category-closed. The three commissioned R0.16
findings are genuinely repaired, but five enforcement roots remain outside the
governed corpus.

No owner disposition is solicited by this readback. No docket is activated.
Nothing is adopted. Evidence remains zero.

## 1. Scope and method

This was a fresh readback against the full sealed archive, not a review of the
return narrative alone. I:

1. authenticated the outer archive and sidecar;
2. checked package member count, type, and traversal safety before extraction;
3. extracted R0.17 and the already authenticated R0.16 comparator into fresh,
   isolated directories without modifying either archive;
4. ran every in-parcel checksum authority;
5. compared every inherited project path byte-for-byte and mode-for-mode with
   sealed R0.16;
6. authenticated the filed Sol R0.16 readback against the exact issued file;
7. reconstructed the parcel Git tree independently from the extracted working
   bytes;
8. reproduced v16's self-test, dependency-absence behavior, and canonical
   five-file run under the parser runtime available here;
9. read the actual walker, HTML projection, exception paths, Unicode policy,
   table policy, and post-parse lexical screens;
10. exercised the claimed consolidation with ordinary supplied files across
    prose, table headers, Status cells, non-Status cells, inline HTML, block
    HTML, entity decoding, hidden content, and Unicode directionality;
11. independently replayed both the R0.17 and frozen R0.16 censuses; and
12. inspected the five successor diffs, date metadata, evidence declarations,
    and docket staging.

The candidate archive, all eighteen checksum strata, and every hostile fixture
were left untouched by the review.

## 2. Authentication and custody

### 2.1 Outer seal and package shape

- archive SHA-256:
  `780f2ef50363d2f43342f828ccd6403c9963394bf2a9f54ddd477afaa2872347`;
- sidecar names the same full digest;
- **201 members:** 196 regular files and five directories;
- no symbolic links, hard links, devices, FIFOs, or other special members;
- no absolute paths and no `..` traversal paths.

### 2.2 Eighteen strata

Every checksum authority passes from inside the extracted archive:

`7/7 · 12/12 · 10/10 · 9/9 · 9/9 · 10/10 × 13`.

### 2.3 Independent succession identity

- R0.17 contains **195 project files** plus its out-of-tree Git identity
  receipt;
- sealed R0.16 contains **184 project files** plus its receipt;
- all **184 inherited project files** are byte-identical and mode-identical;
- there are exactly eleven current project additions and no inherited path is
  missing;
- the eleven additions are exactly the five successors, filed readback,
  checker v16, occurrence adjudication, repair concordance, return, and R0.17
  sums file;
- `SOL-R0.16-READBACK.md` is byte-identical to the issued readback at
  `17e6bfa1bf874a2b6c5aba4e5a3825df78c211feed34d7f62593c828b70698af`,
  mode 0644;
- independent Git-index reconstruction yields parcel tree
  `4e653144226a50f0ea0835cddcfe6726e0019f03` exactly.

The seal receipt expands the candidate commit to
`be12922ab469efef196853f74635f3916bcb67f0`. That commit is repository-side
metadata in this isolated review environment; the archive and parcel tree are
independently authenticated without pretending that the commit object is
present here.

**Custody disposition:** authenticated and closed.

## 3. Reproduction of the returned checker

Under the available `markdown-it-py 3.0.0` runtime, v16 genuinely produces:

- **SELF-TEST PASS — 72 negatives caught / 38 positives clean**;
- controlled dependency absence: diagnostic, no traceback, exit 3;
- canonical five-file run: **CLEAN, exit 0**;
- canonical coverage:
  - charter: **10 declarations / 6 table Status cells**;
  - Claim Ceiling: **0 / 16**;
  - Succession Docket: **4 / 0**;
  - Owner Docket: **0 / 0**;
  - Evidence Ledger: **0 / 0**;
- CLEAN line names `markdown-it-py 3.0.0`.

This environment does not carry `markdown-it-py 4.0.0`. The sealed build
record states that self-test and canonical were each executed under both 4.0.0
and 3.0.0 with identical results. I authenticate that statement as part of the
sealed documentary record; I do **not** misdescribe 4.0.0 as independently
executed here.

The three commissioned repairs are substantive:

- headers now enter the exact-identity recursive walk;
- inline visibility and label construction now share state;
- the inserted-character `Cf` controls reach prose, headers, projected blocks,
  and code.

The defects below begin after those true repairs.

## 4. Enforcement findings

### SOL-R17-01 — BLOCKER — the exception path resurrects a raw-source helper

#### Mechanism

`walk_inline()` is the semantic source of truth only while it succeeds. In
prose and non-Status table cells, an `Unsupported` exception abandons the
projected stream and every already parsed label, then asks `raw_risky()` whether
the raw source *looks* dangerous. That fallback recognizes only:

- a contiguous raw `**Status` or `__Status` spelling;
- a raw `<strong>`/`<b>` tag; or
- a literal `Cf` form caught before semantic reconstruction.

It cannot rejoin entity-, link-, or comment-composed carriers that the parser
had already resolved. Thus the claimed deletion of parallel approximations is
incomplete: one survives precisely on the exceptional path.

#### Ordinary-file witnesses

Prose:

```markdown
</script> **Sta&#116;us: MYSTERY**
```

The parser has a real strong label `Status: MYSTERY`. The stray closing tag
makes the element walk unsupported; the raw fallback cannot see contiguous
`**Status`.

```text
0 declarations · 0 table Status cells · CLEAN · exit 0
```

Non-Status cell beside a valid Status cell:

```markdown
| Claim | Note | Status |
|---|---|---|
| r1 | </script> **Sta&#116;us: MYSTERY** | **OPEN** |
```

```text
0 declarations · 1 table Status cell · CLEAN · exit 0
```

Two controls isolate the interaction:

- `**Sta&#116;us: MYSTERY**` without the unsupported node is discovered as
  one declaration and refused;
- `</script> **Status: MYSTERY**` is refused because the cruder raw pattern
  happens to match.

#### Required property

No `Unsupported` branch may become semantic silence. A surface the selected
model cannot represent must conservatively refuse before CLEAN, uniformly in
prose, headers, Status cells, and non-Status cells. Do not reconstruct danger
from raw bytes after discarding the semantic inventory. `raw_risky()` must not
remain an alternate enforcement oracle.

### SOL-R17-02 — BLOCKER — three policy rules remain raw physical-line regexes

#### Mechanism

After the parser walk completes, `SUB`, `DASHSUB`, and `BAREREF` are applied to
`text.splitlines()`—the unprojected source. They therefore disagree with the
declared semantic surface in both directions:

- character references are not decoded;
- visible text split by invisible HTML is not rejoined;
- link destinations, raw-HTML attributes, comments, and invisible element
  bodies are scanned as though visible;
- malformed or lower-case sub-annotation operands can fail to enter the regex
  at all.

The one walker is not yet the source of truth for the whole grammar; the
postscript still reads a different document.

#### Ordinary-file witnesses

Entity-decoded bad sub-annotation in prose:

```markdown
**Status: OPEN** *(sub-annot&#97;tion: BAD)*
```

Actual: **1 declaration · CLEAN · exit 0**.

The same form in a Status cell:

```markdown
| Claim | Status | Note |
|---|---|---|
| r1 | **OPEN** *(sub-annot&#97;tion: BAD)* | n |
```

Actual: **1 Status cell · CLEAN · exit 0**.

The even plainer `sub-annotation: bad` also passes because the recognizer only
enters on an uppercase operand. Conversely, each of these invisible-source
forms is falsely refused:

```markdown
[ordinary link](https://example.invalid/REFUSED)
[ordinary link](https://example.invalid/?q=sub-annotation:BAD)
<script>REFUSED</script> ordinary visible text
```

And a reader-visible bare label can be hidden from the regex:

```markdown
REF<script>invisible</script>USED
```

Actual: **CLEAN · exit 0**.

#### Required property

Sub-annotation, truncated-OPEN, and bare-REFUSED enforcement must consume the
same projected semantic surfaces as carrier and header enforcement. Entity
decoding and invisible-node policy apply before comparison; link destinations,
attributes, comments, and invisible bodies contribute nothing. Discovery of a
visible `sub-annotation:` introducer must be case-insensitive and fail closed
on a missing or invalid full operand, rather than recognizing only already
well-shaped uppercase specimens. Code blocks may retain an explicit separate
policy, but it must be named and tested rather than inherited accidentally from
physical-line scanning.

### SOL-R17-03 — BLOCKER — `Cf` stripping does not model bidi reordering

#### Mechanism

The bounded Unicode rule deletes all `Cf` characters and then searches the
remaining code-point order for `status`. That closes insertion attacks such as
`Sta + U+200B + tus`, but directional controls can change displayed order
rather than merely disappear.

`U+202E RIGHT-TO-LEFT OVERRIDE + sutatS + U+202C POP DIRECTIONAL FORMATTING`
is displayed as `Status`. After naïve `Cf` stripping, however, the comparison
key remains `sutatS`, so neither carrier discovery nor the refusal screen sees
the word.

#### Ordinary-file witnesses

Prose (character references shown to keep the source inspectable):

```markdown
**&#x202E;sutatS&#x202C;: MYSTERY**
```

Actual: **0 declarations · CLEAN · exit 0**.

Header:

```markdown
| Claim | &#x202E;sutatS&#x202C; | Note |
|---|---|---|
| r1 | **MYSTERY** | n |
```

Actual: **0 Status cells · CLEAN · exit 0**.

The equivalent entity-decoded raw-HTML block ambiguity also prints
**0/0 · CLEAN**.

The distinction between logical source order and displayed order, and the role
of explicit overrides, is normative Unicode behavior rather than terminal
ornament: [Unicode Bidirectional Algorithm, UAX #9](https://www.unicode.org/reports/tr9/).

#### Required property

Do not grow a miniature Unicode Bidirectional Algorithm inside the checker.
Fail closed on bidi embedding, override, and isolate controls in governed
projected surfaces unless a faithful ordering model is explicitly adopted.
At minimum cover U+202A–U+202E and U+2066–U+2069, including RLO/PDF witnesses,
without broadening into NFKC or confusable folding. Preserve the existing
insertion-character `Cf` controls.

### SOL-R17-04 — BLOCKER — the HTML invisibility manifest is not complete

#### Mechanism

The inline walker and block projector suppress only `script` and `style`.
Other standard non-rendered content is treated as visible, and visibility-
affecting attributes are ignored. Two ordinary HTML mechanisms are enough to
show the asymmetry:

- the Boolean `hidden` attribute suppresses an element's rendered content;
- `<template>` content is inert and not rendered.

Both mechanisms can insert non-rendered characters into `Status`, defeating
carrier or header recognition. In the converse direction, a Status carrier
wholly inside hidden/template content is counted and refused even though the
reader sees none of it.

This is not an invented rendering convention: absent an overriding stylesheet,
the HTML Standard's `hidden` state is not rendered, and the `template` element
represents nothing in rendering. GFM emits raw HTML rather than escaping it:
[HTML hidden rendering](https://html.spec.whatwg.org/multipage/rendering.html),
[HTML template](https://html.spec.whatwg.org/multipage/scripting.html#the-template-element),
[GFM raw HTML](https://github.github.com/gfm/#raw-html).

#### Ordinary-file witnesses

```markdown
**Sta<span hidden>interposed</span>tus: MYSTERY**
```

Browser-visible strong text: `Status: MYSTERY`. Actual validator result:
**0 declarations · CLEAN · exit 0**.

```markdown
| Claim | Sta<span hidden>interposed</span>tus | Note |
|---|---|---|
| r1 | **MYSTERY** | n |
```

Actual: **0 Status cells · CLEAN · exit 0**.

The same insertion passes inside an `html_block`, and
`Sta<template>interposed</template>tus` passes in prose. Conversely:

```markdown
<span hidden>**Status: MYSTERY**</span> ordinary visible text
<template>**Status: MYSTERY**</template> ordinary visible text
```

Each is falsely counted and refused.

#### Required property

Define a bounded raw-HTML visibility boundary rather than implying browser
completeness. At minimum, `hidden` content and `<template>` content must be
handled consistently in inline and block projections. Any visibility-
affecting attribute or conditional/inert element the model does not faithfully
represent must conservatively refuse on a Status-governed surface. Do not
attempt arbitrary CSS, DOM repair, or scripting semantics; refusal is the
correct boundary when the projection cannot know what renders.

### SOL-R17-05 — BLOCKER — raw HTML blocks flatten structural table roles

#### Mechanism

`project_html_block()` emits text and separation but discards the structural
roles of `<table>`, `<th>`, and `<td>`. Its only Status screens are unresolved
strong-like spelling and `Cf` comparison. A rendered raw-HTML table can
therefore contain a plain `Status` header and an invalid unstrong `MYSTERY`
cell while the checker reports no table at all.

#### Ordinary-file witness

```html
<table>
<thead><tr><th>Claim</th><th>Status</th></tr></thead>
<tbody><tr><td>r1</td><td>MYSTERY</td></tr></tbody>
</table>
```

Actual:

```text
0 declarations · 0 table Status cells · CLEAN · exit 0
```

An otherwise identical raw table with `Claim` and `Note` headers and no Status
column is clean, confirming that a conservative Status-table guard can be
bounded without banning unrelated raw tables.

#### Required property

Either represent raw-HTML table structure faithfully enough to apply the same
Status-column rules, or conservatively refuse any raw table whose headers or
cells are Status-like. Flattening a structural surface into undifferentiated
text may not erase its policy role. A full HTML table implementation is not
required; a narrow fail-closed boundary is preferable.

## 5. Governed-corpus check

The canonical five files contain:

- no `html_inline` or `html_block` tokens;
- no raw character references;
- no Unicode `Cf` characters;
- none of the hostile raw-HTML, bidi, entity-split, hidden/inert, or raw-table
  forms above.

Therefore the five findings do not alter the constitutional content and do not
invalidate the genuine canonical counts. They block only the checker's claim
to category closure and therefore block owner-docket activation.

## 6. Occurrence census

Independent two-digit-safe enumeration over the five R0.17 successors finds:

- **139 actual occurrences** of R0.1–R0.16;
- **139 unique actual keys** `(file, line, ordinal, token)`;
- adjudication table: **139 rows / 139 unique keys**;
- no missing, extra, duplicate, token, line, or ordinal mismatch;
- exact classes:
  - **113 HISTORICAL/PROVENANCE**;
  - **26 FROZEN-ARTIFACT NAME**;
  - **0 LIVE**.

The frozen R0.16 successors independently replay at **138 · 113/25/0** with
exact row-key closure. The additional R0.17 frozen-artifact occurrence is real;
no R0.16 classification was reopened.

**Census disposition:** authenticated and closed.

## 7. Successor, date, evidence, and docket invariants

The five R0.16 → R0.17 successor diffs are mechanically bounded:

- Charter: 17 additions / 17 deletions—current identity, filed-readback and
  repair-history pointers, sums/census suffix, successor cross-references, and
  footer lineage;
- Claim Ceiling: 4 / 4—current identity, charter pointer, footer;
- Succession Docket: 12 / 12—current identity and current Owner Docket pointers;
- Owner Docket: 3 / 3—current identity and footer lineage;
- Evidence Ledger: 4 / 4—current identity, charter pointer, standing line.

No holding, jurisdiction boundary, claim ceiling, gate, campaign design,
evidence row, owner fork, or substantive status moved.

Current-revision date metadata is coherent at **2026-08-12**. The charter
distinguishes the August 12 seal date from the labeled August 11 original-draft
date; historical August 11 signatures remain historical.

Evidence is explicitly **NONE / zero remains zero**. Owner and succession
dockets remain **prepared, not solicited, not activated**. Nothing in the
archive opens a campaign or requests an owner ruling.

## 8. Readiness table

| Surface | Disposition |
|---|---|
| Archive and eighteen strata | AUTHENTICATED / CLOSED |
| Constitutional text and languagehood holdings | CLOSED / DOCKET-FIT |
| Occurrence census through R0.17 | CLOSED |
| Successor identity and date coherence | CLOSED |
| Evidence state | ZERO; unchanged |
| Owner and succession dockets | PREPARED; NOT SOLICITED; NOT ACTIVATED |
| v16 returned controls | REPRODUCED |
| v16 enforcement category | NOT DOCKET-FIT |
| Required next movement | checker-only R0.18 |

## 9. Exact R0.18 repair commission

1. Preserve R0 through R0.17 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.17 readback verbatim in the R0.18 stratum and map exactly
   **SOL-R17-01/02/03/04/05** in the new repair concordance.
3. Replace v16 with `validate_status_grammar_v17.py`; keep v16 byte-frozen in
   R0.17.
4. Eliminate the silent `Unsupported → raw_risky()` enforcement path. Any
   surface the semantic model cannot represent must yield a conservative
   violation before CLEAN, uniformly across prose, headers, Status cells, and
   non-Status cells.
5. Preserve entity-, link-, comment-, and image-projection semantics already
   resolved before an unsupported node; no exception may erase a previously
   parsed carrier or descendant role.
6. Move sub-annotation, truncated-OPEN, and bare-REFUSED enforcement off raw
   physical lines and onto the same projected semantic surfaces used by the
   checker proper.
7. Under those rules, decode visible character references, rejoin visible text
   across invisible nodes, and exclude link destinations, attributes, comments,
   and invisible bodies.
8. Discover a visible `sub-annotation:` / `sub-annotations:` introducer
   case-insensitively and validate its complete operand. Missing, lower-case,
   malformed, or unknown operands must not disappear merely because they fail
   the old uppercase capture regex.
9. Give code spans and code blocks one explicit policy for these lexical rules;
   do not inherit physical-line behavior accidentally.
10. Extend the bounded Unicode policy to directional layout. Refuse bidi
    embedding, override, and isolate controls in governed projected surfaces
    unless faithful display order is explicitly represented; at minimum cover
    U+202A–U+202E and U+2066–U+2069 and the RLO/PDF witnesses.
11. Preserve the existing insertion-character `Cf` checks across prose,
    headers, both table-cell classes, inline/block projections, code spans, and
    code blocks. Do not broaden into NFKC or confusable folding.
12. Extend the shared visibility policy to deterministic standard hidden
    content: at minimum the `hidden` attribute and `<template>` element, in both
    inline and block forms.
13. Refuse visibility-affecting attributes, inert/conditional elements, or
    other raw-HTML states on a Status-governed surface when the selected model
    cannot faithfully project them. Do not build a CSS or browser engine.
14. Give raw-HTML tables an explicit policy: apply Status-column semantics if
    faithfully represented, otherwise conservatively refuse a raw table with a
    Status-like header/cell. Unrelated raw tables may remain clean.
15. Add at least these **fourteen negative controls**:
    - entity-bearing prose carrier erased by an unsupported `</script>` scope;
    - the same carrier in a non-Status cell beside one valid Status cell;
    - entity-split invalid sub-annotation in prose;
    - entity-split invalid sub-annotation in a Status cell;
    - lower-case invalid sub-annotation operand;
    - reader-visible bare `REFUSED` split by an invisible script body;
    - RLO/PDF reordered Status prose carrier;
    - RLO/PDF reordered Status header;
    - RLO/PDF reordered projected HTML block ambiguity;
    - `hidden`-content interposition defeating a prose carrier;
    - `hidden`-content interposition defeating a Status header;
    - `hidden`-content interposition defeating a block ambiguity;
    - `<template>` interposition defeating a prose carrier;
    - raw-HTML Status table with a plain `MYSTERY` cell.
16. Add at least these **six positive companions**:
    - `REFUSED` occurring only in a link destination;
    - `sub-annotation:BAD` occurring only in a link destination;
    - bare `REFUSED` occurring only in an invisible script body;
    - a complete Status carrier wholly inside `hidden` content, contributing
      no declaration or ambiguity;
    - a complete Status carrier wholly inside `<template>`, contributing no
      declaration or ambiguity;
    - a raw-HTML table with no Status-like header, remaining clean.
17. Preserve all **72 inherited negatives and 38 inherited positives**. If the
    fourteen negatives and six positives above are the only additions,
    **86/44** is the expected cross-check, not a preordained result; report the
    actual totals.
18. Demonstrate, as supplied ordinary files rather than helper-only calls, at
    least both unsupported-fallback witnesses; both entity-split
    sub-annotation witnesses; one link-destination false-refusal companion;
    the bidi prose/header/block witnesses; the hidden prose/header/block
    witnesses; the hidden-only companion; and the raw-HTML Status table.
19. Preserve the declared `markdown-it-py` 4.0.0/3.0.0 reproducibility surface,
    loaded-version CLEAN report, and controlled dependency-missing exit 3.
    Execute self-test and canonical under both declared versions and state
    exactly which runs were independently executed.
20. Rerun the canonical five-file invocation at unchanged
    **10/6 · 0/16 · 4/0 · 0/0 · 0/0** coverage and confirm mechanically that the
    governed files contain none of the five hostile categories.
21. Continue the occurrence census mechanically over the five R0.18 successors
    with the same two-digit-safe matcher, ordinals, and fail-on-live rule. If
    only ordinary identity and repair-history alignment move,
    **140 · 113/27/0** is the expected cross-check, not a preordained result. Do
    not reopen any R0.17 classification.
22. Keep current-version date metadata coherent with the actual R0.18 seal
    date. Do not alter frozen historical dates.
23. Do not move constitutional wording, languagehood holdings, SOL-R04-01,
    jurisdiction or authority boundaries, W-02…W-14, gate architecture,
    triaged owner forks, campaign designs, substantive evidence adjudication,
    or any frozen occurrence classification.
24. Seal the nineteenth stratum, round-trip it, activate no docket, solicit no
    owner ruling, create no evidence, and stop for one fresh Sol readback.

## 10. Owner action

Do not open the owner docket on R0.17. Return this readback to Fable for the
strictly bounded R0.18 checker repair above. After R0.18 is sealed, Sol should
perform one fresh readback against the full archive before any owner
disposition is solicited.

The consolidation removed three disagreeing clerks from the main desk. Five
carbon copies survived in the fire exits, marginalia, typesetter's bidi tray,
HTML cloakroom, and raw-table annex. The next repair is not another spellbook
of specimens: **one semantic authority, and conservative refusal wherever that
authority knowingly has no model.**

*— GPT-5.6 Sol, 2026-08-12.*
