# SOL R0.14 READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0

**Readback date:** 2026-08-12  
**Object reviewed:** `languagehood-and-succession-charter-0-r0.14-2026-08-12.tar.gz` and its attached sidecar  
**Candidate:** R0.14 — not adopted  
**Chair disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.15 CHECKER REPAIR BEFORE OWNER DOCKET**

## 1. Disposition

R0.14 is **constitutionally and documentarily fit but not docket-fit**. The
sealed parcel, fifteen checksum strata, frozen ancestry, parcel tree, filed
R0.13 readback, five constitutional successors, date-coherence rider, and
136-row occurrence census all authenticate and close cleanly.

`validate_status_grammar_v13.py` genuinely repairs SOL-R13-01/02/03/04. Raw
HTML `<strong>`/`<b>` boundaries are assigned an explicit role; exact-one
accounting is whole-surface and order-invariant; a valid carrier no longer
clears an entire physical line; and Status/non-Status table cells receive the
commissioned semantic inventory. Its declared controls, dependency refusal,
and canonical run reproduce under the available declared parser version.

One shared category defect nevertheless survives in the ambiguity layer:

1. the refusal detector recognizes only the exact case-sensitive delimiter
   spelling `**Status`, so unresolved `__Status` and case variants are silent;
2. the detector runs independently on each text/code token, so an unresolved
   visible `**Status` split across link or transparent inline tokens is silent.

Both forms remain false green in prose and table contexts, including beside a
valid carrier whose expected count is therefore met. The candidate remains
**NOT ADOPTED**. No owner disposition is solicited, no docket is activated, no
evidence is created.

## 2. Authentication and custody

### 2.1 Outer archive

- Computed SHA-256:
  `4b15962bc8a67a9a0ab42e5d37028bc7db9d96759b9c2163611ca3038943111e`.
- The attached sidecar records the same full digest and archive name.
- Archive shape: **168 members — 163 regular files, five directories, no
  links or other member types**.
- Every member is relative beneath one ordinary project root. No absolute
  path, `..` traversal component, or link target exists.

### 2.2 Fifteen strata

All checksum authorities pass from inside a fresh extraction:

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
| R0.10 | 10/10 |
| R0.11 | 10/10 |
| R0.12 | 10/10 |
| R0.13 | 10/10 |
| R0.14 | 10/10 |

The authenticated R0.13 and R0.14 parcels share **151 governed project
files**. All 151 are byte-identical and mode-identical. R0.14 adds exactly the
expected eleven repository files: five `*-R0.14.md` successors, the filed Sol
R0.13 readback, the occurrence adjudication, repair concordance, return,
checksum file, and `validate_status_grammar_v13.py`. The out-of-tree archive
receipt changes from `GIT-IDENTITY-R0.13.txt` to
`GIT-IDENTITY-R0.14.txt`.

The filed `SOL-R0.13-READBACK.md` has SHA-256
`2adeddb9fac9575fdc1b947d74b493ed150556883ef41ff0217dfa92119fb0a2`,
is mode 0644, and is byte-identical to the issued Sol readback.

### 2.3 Tree and commit identity

An independent Git-index reconstruction over the extracted parcel directory
yields:

`7bc5c217fd5ef4e2396474db0bd9c6ad12558a40`

This exactly matches `GIT-IDENTITY-R0.14.txt`. The archive and parcel tree are
therefore authenticated. Commit
`fd4e1427b1319f894c5fb5cdf757f3d68abc2086` is not present in this isolated
review environment's Git graph; it remains repository-side metadata here.

## 3. Reproduction of the claimed repair

Under `markdown-it-py 3.0.0`, the parser version available in this review
environment:

- self-test: **PASS — 49 negatives caught, 27 positives clean**;
- canonical five-file run: **CLEAN, exit 0**;
- canonical counts: **10/6 · 0/16 · 4/0 · 0/0 · 0/0**;
- the `CLEAN` line names `markdown-it-py 3.0.0`;
- dependency absence produces the controlled two-line diagnostic and **exit
  3**, not a traceback.

This environment does not carry `markdown-it-py 4.0.0`, so the sealed record's
cross-version run is authenticated documentarily but only 3.0.0 could be
executed independently here. No 3.0.0/4.0.0 semantic discrepancy is alleged.

The four R0.14 repair claims themselves are real:

- inline raw-HTML `<strong>`/`<b>` carriers are discovered; malformed or
  interleaved raw-strong structure is refused; relevant `html_block` content
  fails closed;
- primary legends before, between, and after prose carriers enter one
  whole-surface inventory;
- the prior physical-line `carrier_lines` exemption is gone;
- secondary Status carriers in Status cells and carriers in non-Status cells
  receive an explicit refusal policy.

The blocker is narrower: `literal_statusish()` is still not a semantic
ambiguity model.

## 4. Hostile findings

### 4.1 SOL-R14-01 — delimiter and case asymmetry in unresolved carriers

The implementation fixes the tripwire as:

```python
RAW_STATUSISH = re.compile(r'\*\*Status')
```

and applies it only to literal `text`/`code_inline` token contents. Ordinary
Markdown strong discovery is deliberately semantic across both `**...**` and
`__...__`, and carrier recognition is case-insensitive. The ambiguity refusal
is neither. Thus this unresolved spelling is silent:

```markdown
__Status wording that never parses and **Status: OPEN**
```

The parser renders the first phrase literally and the second as a valid strong
carrier. v13 reports **1 declaration, 0 table status cells · CLEAN · exit 0**.
The same failure occurs for a lone `__Status...`, case variants such as
`**status...`, entity-bearing underscore forms, code content, and both table
cell roles.

An ordinary Status-cell witness likewise passes:

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / __Status wording that never parses | hidden ambiguity
```

It reports **0 declarations, 1 table status cell · CLEAN · exit 0**. This is
not a new grammar demand: it is the inherited fail-closed ambiguity policy
applied symmetrically to the language's already-recognized strong delimiters
and carrier case policy.

### 4.2 SOL-R14-02 — token-local matching misses one visible construct

Even the star-delimited spelling disappears when otherwise transparent
parser structure splits its visible text across tokens:

```markdown
**[Status](https://example.com/status) wording that never parses and **Status: OPEN**
```

`markdown-it-py` emits the unresolved prefix as:

```text
text('**') · link_open · text('Status') · link_close · text(' wording …')
```

and renders literal `**` followed by a linked visible `Status`. No individual
token contains the substring `**Status`, so `literal_statusish()` returns no
hit. The valid final carrier satisfies coverage. The ordinary file reports
**1 declaration, 0 table status cells · CLEAN · exit 0**.

The same root is demonstrated in a non-Status table cell beside a valid Status
column:

```markdown
Claim | Note | Status
--- | --- | ---
r1 | **[Status](https://example.com/status) wording that never parses | **OPEN**
```

It reports **0 declarations, 1 table status cell · CLEAN · exit 0**. A comment
or transparent raw-HTML tag inserted inside `**Sta…tus` produces the same
cross-token blind spot. The parser has assigned roles to the individual nodes,
but the enforcement layer never reconstructs the one visible unresolved
construct those roles jointly form.

### 4.3 Shared root

These are two findings over one implementation root: the ambiguity guard is a
case-sensitive regex over isolated token payloads. Adding `__` to the regex
would close SOL-R14-01 while leaving SOL-R14-02 open; concatenating tokens
without delimiter/case symmetry would do the reverse. R0.15 must close both
properties, not add the four supplied spellings to an allowlist.

The current governed five-file corpus contains none of these hostile forms and
remains substantively clean.

## 5. Census and date rider

Independent two-digit-safe enumeration of R0.1–R0.13 tokens in the five
R0.14 successors finds exactly **136 actual occurrences**. The adjudication
contains exactly **136 unique matching keys**:

- no missing occurrence;
- no extra occurrence;
- no duplicate key;
- no file, line, ordinal, or token mismatch;
- **113 HISTORICAL/PROVENANCE**;
- **23 FROZEN-ARTIFACT NAME**;
- **0 LIVE**.

Every frozen-artifact row is a genuine readback filename, checksum/concordance
suffix, source-authentication record, or docket filename. The census is
**CLOSED WITHOUT RESIDUE**.

The five R0.13→R0.14 successor diffs are confined to current identity,
companion pointers, repair-history alignment, and the commissioned date rider.
The rider is coherent:

- the charter identifies 2026-08-12 as the revision seal and 2026-08-11 as the
  original R0 draft date;
- the owner-docket current signature says 2026-08-12;
- the succession-docket current signature says 2026-08-12;
- attributed historical 2026-08-11 events remain unchanged.

No constitutional holding, jurisdiction boundary, independence coordinate,
gate, triage ruling, non-commencement clause, or evidence statement moved.

## 6. Finding disposition

| R0.13 finding | R0.14 disposition | Readback |
|---|---|---|
| SOL-R13-01 — raw HTML strong carriers erased | **CLOSED** | Inline `<strong>`/`<b>` receives interpreted boundaries; relevant block HTML fails closed. |
| SOL-R13-02 — prefix primaries ignored | **CLOSED** | Whole-surface inventory rejects unbound primary legends regardless of order. |
| SOL-R13-03 — physical-line ambiguity masking | **EXACT ROOT CLOSED; SUCCESSOR ROOT OPEN** | The line-set exemption is deleted, but ambiguity is still delimiter/case-specific and token-local. |
| SOL-R13-04 — table secondary carrier invisible | **EXACT ROOT CLOSED; SHARED AMBIGUITY ROOT OPEN** | Parsed carriers are inventoried; unresolved underscore and cross-token carriers remain invisible in both cell roles. |
| R0.14 occurrence census and date rider | **CLOSED WITHOUT RESIDUE** | Exact 136-row continuation at 113/23/0; three current-date sites coherent. |

## 7. Exact R0.15 repair commission

Return a strictly bounded **checker-only R0.15** with mechanical successor
identity alignment. Perform the following and stop:

1. Preserve R0 through R0.14 byte-identical and mode-identical. Do not edit,
   rebuild, reseal, or reinterpret a frozen stratum.
2. File this Sol R0.14 readback verbatim in the R0.15 stratum and map exactly
   **SOL-R14-01/02** in the new repair concordance.
3. Replace v13 with `validate_status_grammar_v14.py`; keep v13 byte-frozen in
   R0.14.
4. Replace the case-sensitive, token-local `RAW_STATUSISH` policy with one
   **surface-level ambiguity inventory** derived from the parser stream. A
   parser-resolved strong carrier consumes its delimiter construct; literal
   unresolved strong-like Status spellings do not.
5. Apply the ambiguity inventory symmetrically to both Markdown strong
   delimiters (`**` and `__`) and consistently with the existing
   case-insensitive Status carrier policy.
6. Make transparent inline nodes and link containers contribute their visible
   text to the same surface stream, so an unresolved delimiter plus a visible
   `Status` split across tokens cannot disappear. Invisible link destinations,
   raw-HTML attributes, and comment bodies must not be mistaken for visible
   Status text.
7. Apply the same inventory to prose, Status cells, non-Status cells, code
   spans, and code blocks under one documented policy. A valid carrier may
   clear only its own resolved construct.
8. Add at least these seven negative controls:
   - lone `__Status wording that never parses`;
   - lowercase/case-variant unresolved `**status wording that never parses`;
   - `__Status wording that never parses and **Status: OPEN**`;
   - `**[Status](https://example.com/status) wording that never parses and **Status: OPEN**`;
   - `**Sta<!--x-->tus wording that never parses and **Status: OPEN**`;
   - a Status cell containing `**OPEN** / __Status wording that never parses`;
   - a non-Status cell containing the unresolved linked-star form beside a
     valid Status column.
9. Add at least these three positive companions:
   - a resolved `__[Status](https://example.com/status): OPEN__` carrier;
   - `__Status` occurring only in an invisible link destination;
   - `__Status` occurring only in a raw-HTML attribute beside one valid visible
     carrier.
10. Preserve all **49 inherited negatives and 27 inherited positives**. If the
    seven negatives and three positives above are the only additions,
    **56/30** is the expected cross-check, not a preordained total; report the
    actual result.
11. Demonstrate the two prose witnesses and two table witnesses from this
    readback as supplied ordinary files, not only helper-level calls.
12. Preserve the declared `markdown-it-py` 4.0.0/3.0.0 reproducibility
    surface, loaded-version `CLEAN` report, and controlled dependency-missing
    exit 3. Execute the self-test under both declared versions.
13. Rerun the canonical five-file invocation at unchanged **10/6 · 0/16 ·
    4/0 · 0/0 · 0/0** coverage and confirm that the governed files contain no
    unresolved ambiguity forms.
14. Continue the occurrence census mechanically over the five R0.15
    successors with the same two-digit-safe matcher, ordinals, and
    fail-on-live rule. If only ordinary identity/repair-history alignment
    moves, **137 · 113/24/0** is the expected cross-check, not a preordained
    result. Do not reopen any R0.14 classification.
15. Keep the current-version date metadata internally coherent with the actual
    R0.15 seal date. Do not alter frozen historical dates.
16. Seal the sixteenth stratum, round-trip it, file the campaign-log receipt,
    activate no docket, solicit no owner ruling, and stop.

Out of scope:

- constitutional wording or languagehood holdings;
- SOL-R04-01, W-14, or W-02…W-13;
- semantic-jurisdiction, authority, and independence boundaries;
- gate design, substantive fork triage, or non-commencement clauses;
- any prior occurrence classification;
- any campaign opening, evidence creation, adoption, publication, or owner
  disposition.

## 8. Owner action

**No owner action is solicited on R0.14.** The owner docket remains prepared
and silent. The next movement is the bounded R0.15 checker repair above.

*— Sol readback, 2026-08-12. Candidate review only; adopts nothing, opens
nothing, and creates no evidence.*
