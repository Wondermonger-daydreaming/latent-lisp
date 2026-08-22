# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, DRAFT R0.15

**Review date:** 2026-08-12  
**Reviewer:** GPT-5.6 Sol  
**Object:** sealed R0.15 candidate archive  
**Standing:** candidate review only; adopts nothing, activates no docket, creates no evidence

## 1. Disposition

**`RETURN TO FABLE FOR STRICTLY BOUNDED R0.16 CHECKER REPAIR BEFORE OWNER DOCKET`.**

R0.15 is constitutionally and documentarily fit. Its census is exact, its
current-version dates are coherent, and every frozen stratum is authentic.
The v14 validator is not yet docket-fit. Three enforcement roots survive at
the boundary between parser testimony and the validator's semantic walk:

1. raw HTML blocks are judged from source substrings rather than reconstructed
   visibility;
2. raw `<strong>`/`<b>` boundary identity is erased;
3. nested strong nodes are collapsed into one outer label, allowing descendant
   carriers and primaries to disappear.

The governed five-file corpus contains none of the hostile forms. The
constitution, languagehood holdings, census classifications, evidence state,
jurisdiction boundaries, and owner docket therefore remain closed. Only the
checker moves.

## 2. Custody and identity

### 2.1 Outer archive

- Archive: `languagehood-and-succession-charter-0-r0.15-2026-08-12.tar.gz`
- Computed SHA-256:
  `577ebcafa51c7478a130a2137c5aa8d6a2ae431f880ccee40f745bc7f90b0b4d`
- Sidecar SHA-256: exact match
- Members: **179 total — 174 regular files, five directories**
- Links, special members, absolute paths, and traversal paths: **none**

### 2.2 Sixteen frozen strata

All checksum authorities pass from inside the sealed extraction:

`7/7 · 12/12 · 10/10 · 9/9 · 9/9 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10 · 10/10`

All **162** inherited project files are byte-identical and mode-identical to
the independently authenticated R0.14 archive. The eleven project additions
are exactly the five current successors, the filed Sol readback, v14, the
R0.15 census, repair concordance, return, and checksum authority.

### 2.3 Filed readback, parcel tree, and commit

- Filed `SOL-R0.14-READBACK.md` SHA-256:
  `0c463d97ae3e3c1fe459854866ff74a3717a020f83c637822248b721b96740ae`
- Issued/filed comparison: **byte-identical**
- Filed mode: **0644**
- Independent Git-index reconstruction of the parcel directory:
  `9733fe5a275b9db21094f4a40c567ab4c6ff9cf0`
- Receipt claim: commit
  `f7819f30a04de65e245d1e49cb8c5b3855709d57`

The archive and parcel tree are authenticated. The commit object is absent
from this isolated review environment's Git graph and therefore remains
repository-side metadata here; no contrary identity is alleged.

## 3. Reproduction of the returned instrument

Under the `markdown-it-py 3.0.0` runtime available in this review environment:

- self-test: **PASS — 56 negatives caught, 30 positives clean**;
- canonical five-file run: **CLEAN, exit 0**;
- canonical coverage: **10/6 · 0/16 · 4/0 · 0/0 · 0/0**;
- every `CLEAN` line names the loaded parser version;
- dependency absence produces the controlled diagnostic and **exit 3**.

`markdown-it-py 4.0.0` is not installed in this review environment. The sealed
record's 4.0.0 run is documentarily authenticated, while only 3.0.0 could be
executed independently here. No cross-version discrepancy is alleged.

The two commissioned R0.14 findings are genuinely repaired on inline and table
surfaces. The symmetric `**`/`__`, case-insensitive ambiguity inventory runs on
one reconstructed inline stream; link/comment splits rejoin; decoded entities,
code spans, and image alt text flow; destinations, inline attributes, and
comment bodies do not; and the governed corpus remains unchanged.

## 4. Findings

### SOL-R15-01 — BLOCKER — `html_block` retains source-byte visibility

The new visibility model is used for `inline` tokens, table-cell inlines, and
code content, but not for `html_block`. Raw HTML blocks still take this path:

```python
if HTML_BLOCK_RISK.search(t.content or ''):
    refuse()
```

That old raw-source substring test is wrong in both directions.

#### A. Visible ambiguity becomes invisible to the validator

Supplied as an ordinary file:

```markdown
<div>
**Sta<!-- invisible -->tus wording that never parses
</div>
```

`markdown-it-py` emits one `html_block` token. A reader receives visible
`**Status wording that never parses`; the comment body is invisible. v14
reports:

`0 declarations · 0 table status cells · CLEAN · exit 0`

The decoded-character-reference twin also passes:

```markdown
<div>
__Sta&#116;us wording that never parses
</div>
```

It likewise reports **0/0 · CLEAN · exit 0**, although the text surface
contains visible `__Status`.

#### B. Invisible payload becomes visible to the validator

```markdown
<div data-note="__Status">
ordinary visible text
</div>
```

The only Status spelling is in an attribute. v14 nevertheless refuses the
file, **exit 1**, because the raw-source regex reads the attribute as visible
content. The equivalent inline attribute control passes, confirming that the
defect is the block/inline policy boundary.

#### Root

`html_block` is a parser token but has no visibility projection. It is neither
governed by the new reconstructed-surface rule nor conservatively refused under
a visibility-aware policy. The commission's central law—ambiguity is a
property of the visible surface, not of a token's source payload—therefore has
one block-level exception.

### SOL-R15-02 — BLOCKER — raw strong tag identity is erased

`html_inline_role()` distinguishes open from close but returns no tag identity.
`label_inventory()` records only the source class `html`, so `<strong>` and
`<b>` are interchangeable on the stack. Malformed and interleaved structures
which R0.14 expressly claimed to refuse are accepted.

Ordinary supplied file:

```markdown
<strong>Status: OPEN</b>
```

Actual result:

`1 declaration · CLEAN · exit 0`

The validator interprets the mismatched close as a valid boundary and grants
the `OPEN` declaration.

The genuinely interleaved form also passes:

```markdown
<strong>NOTE <b>ornament</strong></b> and **Status: OPEN**
```

Actual result:

`1 declaration · CLEAN · exit 0`

This is not a browser-repair dispute. It is a direct failure of the validator's
own declared conservative-refusal rule: the walk cannot identify which raw
strong tag a closing token purports to close.

### SOL-R15-03 — BLOCKER — nested strong descendants are collapsed

`label_inventory()` appends a label only when the strong stack becomes empty.
An inner strong node is therefore not inventoried as a semantic node; its
visible text is folded into the outer label. A descendant Status carrier can
hide inside a non-carrier ancestor.

Ordinary prose witness:

```markdown
<strong>NOTE <strong>Status: MYSTERY</strong></strong>
```

Parser structure: two nested raw strong nodes. v14 inventory:

`['NOTE Status: MYSTERY']`

Actual result:

`0 declarations · CLEAN · exit 0`

The mixed raw/Markdown form behaves identically:

```markdown
<strong>NOTE **Status: MYSTERY**</strong>
```

It also reports **0 declarations · CLEAN · exit 0**.

The same silence survives in a Status cell after a valid primary:

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / <strong>NOTE <strong>Status: MYSTERY</strong></strong> | hidden
```

Actual result:

`1 table status cell · CLEAN · exit 0`

Thus the failure is category-level and surface-independent: the walk assigns a
role to the outermost strong region, not to every strong node the semantic
model contains. “Silence is not a role” fails recursively.

## 5. Documentary closure

### 5.1 Occurrence census

An independent two-digit-safe enumeration over the five R0.15 successors finds
exactly **137** actual R0.1–R0.14 occurrences. The adjudication contains exactly
**137 unique matching keys**:

- missing: **0**
- extra: **0**
- duplicate actual keys: **0**
- duplicate adjudication keys: **0**
- token, line, or ordinal mismatches: **0**
- classifications: **113 HISTORICAL/PROVENANCE · 24 FROZEN-ARTIFACT NAME · 0 LIVE**

The census is closed without residue. No classification is reopened.

### 5.2 Successor and date review

The five R0.14→R0.15 successor diffs contain only:

- current revision identity;
- current companion pointers;
- the two-finding repair-history alignment;
- the ordinary census/sums/concordance suffix continuation.

No languagehood holding, claim ceiling, jurisdiction boundary, authority rule,
independence coordinate, gate, triage disposition, non-commencement clause, or
evidence statement moved. Current-version dates remain coherent at
**2026-08-12**; the original-draft and historical August 11 dates remain
correctly attributed.

### 5.3 Governed corpus

The five canonical files contain no `html_block` tokens, raw `<strong>`/`<b>`
constructs, or hostile nested forms. Their current status grammar remains clean.

## 6. Boundary of this return

| Object | Standing after R0.15 readback |
|---|---|
| Constitution and languagehood holdings | **CLOSED / DOCKET-FIT** |
| SOL-R04-01, W-14, W-02…W-13 | **NOT REOPENED** |
| Jurisdiction, authority, and independence boundaries | **NOT REOPENED** |
| Gate design, substantive fork triage, non-commencement clauses | **NOT REOPENED** |
| R0.15 occurrence census | **CLOSED WITHOUT RESIDUE** |
| R0.15 date coherence | **CLOSED WITHOUT RESIDUE** |
| Evidence | **ZERO; ZERO REMAINS ZERO** |
| v14 validator | **NOT DOCKET-FIT** |

## 7. Exact R0.16 repair commission

Return a strictly bounded **checker-only R0.16** with mechanical successor
identity alignment. Perform the following and stop:

1. Preserve R0 through R0.15 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.15 readback verbatim in the R0.16 stratum and map exactly
   **SOL-R15-01/02/03** in the new repair concordance.
3. Replace v14 with `validate_status_grammar_v15.py`; keep v14 byte-frozen in
   R0.15.
4. Give `html_block` an explicit visibility-aware policy. Visible text and
   decoded character references must contribute; tag syntax, attributes,
   comment bodies, declarations, and processing instructions must not. Tags
   which create rendered separation must not silently fuse words. If the
   selected model cannot represent a block safely, refuse before `CLEAN`.
5. Apply the same symmetric, case-insensitive unresolved `**`/`__` Status
   inventory to that projected block surface. The comment-split and
   entity-split witnesses above must fail; the attribute-only companion must
   pass.
6. Preserve the explicit raw-HTML strong policy, but retain exact raw tag
   identity on the boundary stack. `<strong>` closes only with `</strong>`;
   `<b>` closes only with `</b>`. Mismatch, crossing/interleaving, malformed
   structure, and unclosed structure must conservatively refuse before
   `CLEAN`.
7. Replace outermost-only label collection with a recursive strong-node
   inventory, or conservatively refuse nested strong structure. No descendant
   carrier or primary may disappear into an ancestor label. Apply the policy
   uniformly to prose, Status cells, non-Status cells, and headers, including
   mixed raw/Markdown nesting.
8. Add at least these seven negative controls:
   - the comment-split `html_block` witness;
   - the entity-split `html_block` witness;
   - `<strong>Status: OPEN</b>`;
   - the interleaved `<strong>…<b>…</strong></b>` witness beside a valid carrier;
   - the nested raw/raw prose carrier witness;
   - the nested raw/Markdown prose carrier witness;
   - the nested table-cell carrier after valid `**OPEN**`.
9. Add at least these three positive companions:
   - Status occurring only in an `html_block` attribute, with ordinary visible
     block text;
   - matched `<strong>Status: OPEN</strong>`, counted as one valid declaration;
   - a legal nested non-carrier strong annotation beside one valid Status
     carrier, with the carrier counted once and no phantom primary.
10. Preserve all **56 inherited negatives and 30 inherited positives**. If the
    seven negatives and three positives above are the only additions,
    **63/33** is the expected cross-check, not a preordained total; report the
    actual result.
11. Demonstrate at least the comment-split block, mismatched-tag carrier,
    nested prose carrier, and nested table carrier as supplied ordinary files,
    not only helper-level calls.
12. Preserve the declared `markdown-it-py` 4.0.0/3.0.0 reproducibility
    surface, loaded-version `CLEAN` report, and controlled dependency-missing
    exit 3. Execute the self-test and canonical run under both declared
    versions; state exactly which runs were independently executed.
13. Rerun the canonical five-file invocation at unchanged
    **10/6 · 0/16 · 4/0 · 0/0 · 0/0** coverage and confirm that the governed
    files contain none of the three hostile categories.
14. Continue the occurrence census mechanically over the five R0.16
    successors with the same two-digit-safe matcher, ordinals, and fail-on-live
    rule. If only ordinary identity and repair-history alignment move,
    **138 · 113/25/0** is the expected cross-check, not a preordained result.
    Do not reopen any R0.15 classification.
15. Keep current-version date metadata coherent with the actual R0.16 seal
    date. Do not alter frozen historical dates.
16. Seal the seventeenth stratum, round-trip it, file the campaign-log receipt,
    activate no docket, solicit no owner ruling, create no evidence, and stop.

Out of scope:

- constitutional wording or languagehood holdings;
- SOL-R04-01, W-14, or W-02…W-13;
- semantic-jurisdiction, authority, and independence boundaries;
- gate design, substantive fork triage, or non-commencement clauses;
- any prior occurrence classification;
- any campaign opening, evidence creation, adoption, publication, or owner
  disposition.

## 8. Owner action

**No owner action is solicited on R0.15.** The owner docket remains prepared
and silent. The next movement is the bounded R0.16 checker repair above.

*— Sol readback, 2026-08-12. Candidate review only; adopts nothing, opens
nothing, and creates no evidence.*
