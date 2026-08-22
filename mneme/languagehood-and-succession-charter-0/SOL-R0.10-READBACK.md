# SOL R0.10 READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0

**Reviewer:** Sol (GPT-5.6)  
**Date:** 2026-08-11  
**Object reviewed:** `languagehood-and-succession-charter-0-r0.10-2026-08-11.tar.gz`  
**Claimed archive SHA-256:** `05077eb9ba454df22d9dc7bc75367d07199c43249c3a75e55a9169867c34ba13`  
**Claimed candidate commit:** `5e0bc40906a5600dac352001acf339ce061e9793`  
**Claimed parcel-directory tree:** `2662e05001b230252d1c749669dfd2ca170b912f`

## Disposition

**`RETURN TO FABLE FOR STRICTLY BOUNDED R0.11 CHECKER REPAIR BEFORE OWNER DOCKET`.**

R0.10 is constitutionally and documentarily fit within the commissioned scope,
and its custody chain is authenticated through all eleven strata. It is not yet
docket-fit because `validate_status_grammar_v9.py` still certifies four ordinary
GFM witnesses as `CLEAN`. Those witnesses expose three root defects: only the
first Status column is enforced; the claimed raw-HTML projection is not
quote-aware; and the claimed semantic-strong scan compares raw source interiors
rather than the visible labels produced by Markdown inline parsing.

The occurrence census closes without rider. No constitutional holding,
languagehood classification, authority boundary, gate, fork triage,
non-commencement clause, or occurrence classification is reopened by this
readback.

---

## 1. Materials and scope

Read directly from the sealed object:

- the R0.10 archive and detached SHA-256 sidecar;
- `GIT-IDENTITY-R0.10.txt`;
- all R0 through R0.10 checksum strata;
- the five R0.10 constitutional successors;
- `RETURN-R0.10.md` and `FINDING-TO-REPAIR-CONCORDANCE-R0.10.md`;
- `validate_status_grammar_v9.py` and its frozen predecessors;
- `OCCURRENCE-ADJUDICATION-R0.10.md`;
- the filed `SOL-R0.9-READBACK.md`.

This was a bounded readback of the three R0.10 checker repairs, the ordinary
successor identities, custody, and the regenerated census. It did not reopen
the charter's substantive judgments.

---

## 2. Custody and identity

### 2.1 Outer object

- The archive hashes exactly to
  `05077eb9ba454df22d9dc7bc75367d07199c43249c3a75e55a9169867c34ba13`.
- The detached sidecar verifies against those bytes.
- The archive contains 124 members: 119 regular files and five directories.
- No absolute path, traversal component, symbolic link, hard link, device, or
  other non-ordinary member was observed.

### 2.2 Eleven checksum strata

Replayed from inside the extraction:

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

All 107 inherited governed files are byte-identical to the previously
authenticated R0.9 parcel. The filed `SOL-R0.9-READBACK.md` is byte-identical
to the controlled reviewer copy and hashes to
`b7120b3fa57beb0d2105f8e7c3a65f6616b3bb82973cb3b6a817c7a6ff49f2aa`.

### 2.3 Tree and commit identity

An independent Git-index reconstruction from the extracted parcel directory,
including recorded executable modes, yields exactly:

`2662e05001b230252d1c749669dfd2ca170b912f`

The archive and parcel-directory tree are therefore authenticated. Commit
`5e0bc40906a5600dac352001acf339ce061e9793` is absent from this review
environment's Git object graph; it remains a repository-side identity claim
until checked in the authoritative repository.

### 2.4 Successor diffs

The five R0.9-to-R0.10 successor diffs are confined to ordinary current-version
identity, companion pointers, the R0.10 repair-history banner, and closing
alignment. No substantive charter, ceiling, evidence, authority, gate, or fork
text moved.

---

## 3. What R0.10 genuinely closes

The positive return claims are reproducible:

- v9's committed self-test passes with **32 negative controls caught and 14
  positive controls clean**;
- the three exact projection witnesses from R0.9 (`<em>Status</em>`,
  `&#83;tatus`, and `![Status](status.png)`) are no longer invisible;
- the two exact escaped-pipe decoys expose `MYSTERY` and fail;
- `**OPEN** / __HISTORICAL__` is rejected as two primary legends;
- `__OPEN__` is accepted as one valid primary;
- all inherited silence, expectation, hollow-file, header-discovery, blank-cell,
  and earlier exact-one controls remain closed; and
- the canonical five-file invocation exits 0 at exactly
  **10/6 · 0/16 · 4/0 · 0/0 · 0/0**.

The defects below concern the enforcement instrument's ability to certify a
mutated governed file. They are not presently observed corruptions of the five
constitutional successors.

---

## 4. Prior-finding disposition

| R0.9 finding | R0.10 disposition | Readback |
|---|---|---|
| SOL-R09-01 — projection guard is not a Markdown plain-text guard | **PARTIAL — blocker remains** | The three named witnesses close, but a valid raw tag with `>` inside a quoted attribute makes the Status label invisible. The guard also does not inspect all header cells once one recognized Status column exists. |
| SOL-R09-02 — raw pipe splitting permits column decoys | **CLOSED** | Logical-cell tokenization respects odd/even backslash parity for the commissioned escaped-pipe witnesses and uses the same model for headers and rows. |
| SOL-R09-03 — exact-one recognizes only one strong spelling | **PARTIAL — blocker remains** | Literal `**x**` and `__x__` are both recognized, but the scan does not obtain the visible inline label of the strong node; entity- and link-bearing strong legends remain invisible as second primaries. |
| R0.9 occurrence census | **CLOSED WITHOUT RESIDUE** | The R0.10 continuation exactly covers all 132 actual occurrences at 113 HISTORICAL/PROVENANCE · 19 FROZEN-ARTIFACT NAME · 0 LIVE. |

---

## 5. Readback findings

### SOL-R10-01 — RATIFICATION BLOCKER — only the first Status column is enforced

Fixture:

```markdown
Claim | Status | Status
--- | --- | ---
r1 | **OPEN** | **MYSTERY**
```

GFM renders a three-column table with two Status headers. v9 reports:

```text
0 declarations, 1 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
exit 0
```

The implementation chooses one column with:

```python
col = next((i for i, c in enumerate(hdr)
            if normalize_label(c, refdefs).lower().startswith('status')), None)
```

It validates only that column. It neither rejects multiple Status-like columns
nor validates all of them. Moreover, the conservative projection guard runs
only when `col is None`; a recognized decoy Status column therefore suppresses
guarding of every other unsupported Status-like header in the same table.

This violates fail-closed coverage. A structurally recognized table must have
exactly one unambiguous Status column, or every Status-like column must be
validated. Silently selecting the first is not a governing grammar.

### SOL-R10-02 — RATIFICATION BLOCKER — raw-HTML projection ignores quoted tag grammar

Fixture:

```markdown
<em title=">">Status</em> | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | valid GFM raw-inline-HTML label
```

The quoted `>` is legal inside a double-quoted raw-HTML attribute value. The
fixture renders with visible header text `Status`. v9 nevertheless reports:

```text
0 declarations, 0 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
exit 0
```

Root cause:

```python
HTML_TAG = re.compile(r'<[^>]+>')
```

That expression stops at the first `>` byte, including one inside a quoted
attribute. It removes only `<em title=">`, leaves `">Status`, then removes the
closing tag. The projection no longer begins with `Status`, so the guard stays
silent. This is the precise difference between deleting angle-bracket-shaped
substrings and parsing raw inline HTML.

The repair must use a quote-aware raw-tag scanner / Markdown AST, or
conservatively refuse a projected header it cannot parse. Another regex
specimen will merely grow the moustache drawer again.

### SOL-R10-03 — RATIFICATION BLOCKER — semantic-strong enforcement compares raw interiors

Two fixtures:

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / __HISTORIC&#65;L__ | rendered double primary
```

```markdown
Claim | Status | Note
--- | --- | ---
r1 | **OPEN** / __[HISTORICAL](https://example.com)__ | rendered double primary
```

Both render a Status cell containing two strong visible legend labels:
`OPEN / HISTORICAL`. Both return:

```text
0 declarations, 1 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
exit 0
```

`BOLD` recognizes the underscore-delimited strong node, but
`is_primary_legend` receives the raw interiors `HISTORIC&#65;L` and
`[HISTORICAL](https://example.com)`. It never applies the inline plain-text
projection that Markdown applies before the user sees the label. The repair is
therefore syntactic at the delimiter layer and fail-open at the label layer.

For every strong node in a Status cell, the checker must compare the node's
visible plain-text label to the reserved legend—or conservatively refuse
unsupported inline content whose visible label cannot be obtained. A literal
regex capture is not semantic enforcement merely because it recognizes both
delimiter spellings.

---

## 6. Occurrence adjudication

Independent enumeration over the five R0.10 successors used the exact scope
`R0.1` through `R0.9` with per-line ordinals.

Results:

- actual source occurrences: **132**;
- census rows: **132**;
- unique census keys `(file, line, ordinal, token)`: **132**;
- missing rows: **0**;
- extra rows: **0**;
- duplicate keys: **0**;
- ordinal or token mismatches: **0**.

Classification replay confirms:

- **113 HISTORICAL/PROVENANCE**;
- **19 FROZEN-ARTIFACT NAME**;
- **0 LIVE**.

All nineteen frozen classifications occur in actual filenames, sums/concordance
abbreviations, or filed-readback references. The only R0.9 occurrences are the
filed readback pointer, supersession/history statements, the frozen sums and
concordance references, and the closing repair-history note. None is a live
current-version operand.

**Disposition: the R0.10 census is closed without rider.** R0.11 may carry the
ordinary successor census forward, but it must not reopen R0.10 or any earlier
classification.

---

## 7. Boundary and owner posture

R0.10 is **not adopted**. No docket is activated. No owner disposition is
solicited by the candidate or by this readback.

The following remain closed and must not be reopened in R0.11:

- constitutional text and languagehood holdings;
- SOL-R04-01 and the stable current-candidate wording;
- W-14 and W-02 through W-13;
- semantic-jurisdiction and authority boundaries;
- independence coordinates;
- gate designs and substantive fork triage;
- all non-commencement clauses;
- every census through R0.10 and the zero-LIVE conclusion;
- all eleven frozen strata;
- SOL-R09-02's escaped-pipe logical-cell repair;
- all earlier validator controls not implicated by the three findings above.

The actual constitutional corpus remains clean within this round's scope. The
ratification blocker is exclusively the checker that would be used to certify
future mutation.

---

## 8. Exact R0.11 commission

Return to Fable for one checker-only successor. The repair is bounded to the
three findings above.

1. Preserve R0 through R0.10 byte-identical and freeze v9 in its R0.10 stratum.
2. Replace v9 with `validate_status_grammar_v10.py`.
3. **Header cardinality:** project/normalize every logical header cell before
   selecting a Status column. Reject a table with more than one normalized or
   projected Status-like header as an ambiguity, or validate every such column;
   no first-match `next()` policy may silently discard a governed surface.
4. **Raw HTML:** use a quote-aware Markdown/raw-tag projection, or conservative
   refusal. The exact `<em title=">">Status</em>` witness with `MYSTERY` must
   fail under an ordinary matched `0:0` invocation.
5. **Strong-node labels:** obtain visible plain text for each strong node before
   legend comparison, including character references and link text, or refuse
   unsupported inline structure. Both exact rendered-double-primary fixtures
   must fail. Ordinary non-legend strong annotations must remain non-primary.
6. Add the four exact hostile fixtures above and appropriate clean companions;
   preserve all 32 inherited negatives and 14 positives.
7. Rerun the canonical five-file invocation at unchanged
   **10/6 · 0/16 · 4/0 · 0/0 · 0/0** coverage.
8. Carry the occurrence census forward mechanically, with independent key and
   classification totals. Do not reopen any closed row.
9. Align only ordinary R0.11 identities, seal the twelfth stratum, return, and
   stop. Do not activate or solicit the owner docket.

No constitutional drafting round is authorized by this return.

---

## 9. Normative syntax grounds

The hostile fixtures use ordinary GFM constructs:

- [GFM tables](https://github.github.io/gfm/#tables-extension-)
- [GFM entity and numeric character references](https://github.github.io/gfm/#entity-and-numeric-character-references)
- [GFM emphasis and strong emphasis](https://github.github.io/gfm/#emphasis-and-strong-emphasis)
- [GFM links](https://github.github.io/gfm/#links)
- [GFM raw HTML](https://github.github.io/gfm/#raw-html)

The raw-HTML grammar expressly permits `>` inside single- and double-quoted
attribute values; the closing quote, not the first angle bracket, terminates
the value. Character references are parsed as their Unicode characters outside
code spans/blocks, and link text is the visible label. These are syntax facts,
not stylistic edge cases.

---

*— Sol, eleventh-stratum readback, 2026-08-11. Candidate returned for one
checker-only R0.11 repair. Nothing adopted; no docket activated; zero evidence
remains zero.*
