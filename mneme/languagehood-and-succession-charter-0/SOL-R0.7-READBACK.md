# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.7

**Date:** 2026-08-11

**Mode:** read-only documentary, identity, validator, and occurrence-census review

**Review object:** `languagehood-and-succession-charter-0-r0.7-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.8 CHECKER REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, owner solicitation, or new evidence

## 1. Review scope

This eighth-stratum readback tested the R0.7 return against the attached archive
bytes rather than accepting the return's account of itself. It:

1. authenticated the outer archive, sidecar, member types, eight checksum
   strata, historical bytes, filed Sol return, and parcel-directory Git tree;
2. compared every shared file to the previously authenticated R0.6 archive and
   inspected all five R0.6→R0.7 successor diffs;
3. ran `validate_status_grammar_v6.py` in self-test, canonical, exact prior-
   fixture, and independent Markdown-inline-header modes;
4. independently enumerated every `R0.1`…`R0.6` occurrence in the five R0.7
   successors, compared the resulting 129-key multiset to the delivered table,
   and inspected every class assignment for live use; and
5. traced SOL-R06-01 and SOL-R06-02 through the concordance, validator,
   successor documents, return, and occurrence adjudication.

No candidate file was edited.

## 2. Custody and identity

The return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `994d55dfdd6b7ea928e15700f2f8c9958257bd7a04d1f6f3f992fd8cede1f5da`
  — exact match to the supplied sidecar.
- The archive contains **91 ordinary members: 86 files and 5 directories**.
  No traversal, absolute-path, symlink, device, or other special member was
  found.
- Internal checksum regimes pass: **R0 7/7 · R0.1 12/12 · R0.2 10/10 ·
  R0.3 9/9 · R0.4 9/9 · R0.5 10/10 · R0.6 10/10 · R0.7 10/10**.
- Every file shared with the previously authenticated R0.6 archive is
  byte-identical. The expected R0.7 additions are the five successors, filed
  Sol R0.6 readback, validator v6, regenerated occurrence table, concordance,
  return, and checksum manifest; the root identity record advances from R0.6
  to R0.7.
- The filed `SOL-R0.6-READBACK.md` is byte-identical to the Sol report delivered
  in the preceding round, SHA-256
  `c6a09277782aa1d9362b06d00ed7f8a723abe352359e595a9f08e943ad72ee6d`.
- Reconstructed parcel-directory Git tree:
  `5202915972cbd1159c1a1c86b0e81f9134e3fb5d` — exact match to
  `GIT-IDENTITY-R0.7.txt` and the return.
- Candidate commit `273e7c15a0ee1dd1cfe244d9b3ff1c72dacb8fe2` remains an
  identity claim in this workspace because the authoritative repository object
  graph is absent. The parcel tree is authenticated; the commit must still be
  confirmed in the authoritative repository before owner disposition.

## 3. Executive verdict

R0.7's constitutional text is clean within this round's bounded scope. The
five successor diffs contain only ordinary R0.7 identity, companion-pointer,
repair-history, and closing alignment. The canonical status corpus is clean at
Charter **10 declarations / 6 table cells**, Claim Ceiling **16 table cells**,
Succession Docket **4 declarations**, and `0:0` for the Owner Docket and
Evidence Ledger. No authority holding, gate design, fork, W-14 boundary, or
non-commencement clause moved.

R0.7 closes the exact bare-header defect named in SOL-R06-01. Validator v6
discovers a no-outer-pipe table with a first-column plain `Status` header,
rejects both its `**MYSTERY**` and blank-cell variants, preserves v5's
empty-text and case-variant repairs, passes nineteen negative and seven
positive self-tests, and leaves the real corpus green at unchanged counts.

It does not finish the commission's **markup-normalization** clause. Structural
discovery finds the table skeleton, but header normalization consists only of
trimming whitespace and optional outer pipes; the actual test is
`c.lower().startswith('status')`. A valid GFM header cell may contain inline
markup—the GFM table specification says table cells contain arbitrary text in
which inlines are parsed. A first-column `*Status*` header is therefore a
normal table header, not an exotic syntax extension. See
[GitHub Flavored Markdown §4.10](https://github.github.com/gfm/#tables-extension-).

Under a matched `0:0` expectation, v6 treats the following supplied file as
having zero declarations and zero status cells, prints `CLEAN`, and exits 0:

```markdown
*Status* | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | italicized first-column header
```

That is the same false-green species the checker campaign is intended to
abolish, and it falls inside the R0.6 commission's explicit phrase **“after
case/markup normalization.”** A strong-form `**Status**` header exposes the
companion symptom: instead of being normalized as a table header, it is caught
by the prose `ANY_DECL_LINE` rule as an unparseable status declaration. Thus
formatted headers are neither consistently discovered nor consistently
separated from prose declarations.

The documentary repair is complete. The R0.7 occurrence table contains exactly
all **129** actual prior-version occurrences, with exactly one unique row per
key and no missing, extra, or duplicated row. All **16** frozen-artifact rows
are genuine filename/sums references; all **113** remaining rows are historical
or provenance references; independent semantic inspection confirms **0 LIVE**
stale operands. Charter line 7's new `R0.6` inside
`SOL-R0.6-READBACK.md` is correctly FROZEN. The correction of record for the
frozen R0.6 table is also accurately stated as **113/15/0**.

The remaining work is checker-only. No constitutional or occurrence-class
repair remains.

## 4. Prior-finding disposition

| R0.6 readback finding | R0.7 disposition | Readback |
|---|---|---|
| **SOL-R06-01** — v5 misses no-outer-pipe first-column Status tables | **PARTIAL — RATIFICATION BLOCKER** | The exact plain-header false green is closed; v6 self-test and canonical run pass. But inline-marked header labels are not normalized, so `*Status*` plus `**MYSTERY**` still prints `CLEAN`, exit 0, under `0:0`. |
| **SOL-R06-02** — one wrong R0.6 occurrence class; regenerate with corrected classifier | **CLOSED** | R0.6's 113/15/0 correction is carried accurately. The R0.7 table exactly covers 129 unique actual occurrences at 113 HISTORICAL/PROVENANCE · 16 FROZEN-ARTIFACT NAME · 0 LIVE; the analogous new banner locus is correctly FROZEN. |

## 5. Readback findings

### SOL-R07-01 — RATIFICATION BLOCKER — v6 does not perform the commissioned header-markup normalization

The following claims are verified:

- `--self-test` reports **PASS**: nineteen negative controls caught and seven
  positives accepted;
- supplied empty or whitespace-only text still fails under matched `0:0`;
- lowercase `status`, uppercase `STATUS NOW`, and the exact no-outer-pipe
  first-column plain `Status` header are discovered;
- the exact SOL-R06-01 invalid-token and blank-cell fixtures fail;
- the canonical five-file run reports **10/6 · 0/16 · 4/0 · 0/0 · 0/0** and
  exits 0; and
- the actual R0.7 corpus is clean under independent surface inspection.

The surviving false green is caused by these two steps:

```python
hdr = split_row(line)  # strips only whitespace and optional outer pipes
col = next((i for i, c in enumerate(hdr)
            if c.lower().startswith('status')), None)
```

`*Status*` remains `*Status*`; no status column is selected. The later prose
scan does not see `**Status`, so the invalid data cell is never inspected. The
ordinary invocation result is:

```text
italic-status-header.md: 0 declarations, 0 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
exit=0
```

This is directly within the prior commission, which required a first-column
Status header to be recognized after **case/markup normalization**.

**Smallest repair:** replace only the validator and its controls. Introduce one
explicit header-label normalizer for the permitted inline wrappers, rather than
another punctuation-specific discovery gate. At minimum, label-only emphasis,
strong emphasis, code-span, and link wrappers around `Status` / `Status now`
must reduce to the same normalized header label as plain text. A structurally
identified table-header line must not then be reinterpreted as a prose
`**Status...` declaration. Add ordinary-invocation controls proving:

1. no-outer-pipe first-column `*Status*` with `**MYSTERY**` fails under `0:0`;
2. the same form with a blank status cell fails;
3. a `**Status**` header with one valid `**OPEN**` row is counted as one table
   status cell and does not trigger the prose-declaration rule; and
4. v6's nineteen negatives, seven positives, canonical counts, empty-text,
   exact-one, case-variant, and bare no-outer-pipe controls all remain green.

Preserve v6 byte-identical in the R0.7 stratum.

### SOL-R07-02 — CLOSED — the R0.7 occurrence census is exact

Independent replay establishes:

- actual R0.1–R0.6 occurrences across the five successors: **129**;
- delivered table rows: **129**;
- unique actual keys / unique table keys: **129 / 129**;
- missing, extra, or duplicate keys: **0 / 0 / 0**;
- delivered class totals: **113 HISTORICAL/PROVENANCE · 16
  FROZEN-ARTIFACT NAME · 0 LIVE**;
- all sixteen frozen-artifact contexts are genuinely artifact or checksum-file
  names; and
- Charter line 7's `R0.6` in `SOL-R0.6-READBACK.md` is correctly classified
  FROZEN-ARTIFACT NAME.

No correction is commissioned. If ordinary R0.8 succession creates a refreshed
R0.1–R0.7 inventory for the five R0.8 successors, that is a mechanical custody
continuation only; SOL-R06-02 and the R0.7 129-row adjudication remain closed.

## 6. Structures that survive and must not be reopened

- All eight checksum strata and the authenticated R0.7 parcel tree.
- The R0.7 constitutional text and bounded five-document successor diffs.
- SOL-R06-02 and the exact R0.7 occurrence census: **129 rows · 113/16/0**.
- The frozen R0.6 correction of record: **113/15/0**.
- SOL-R04-01: latent-authorship wording remains candidate-proposed / CC-3
  pending F-8, never presently licensed.
- The actual R0.7 status content: **10/6 · 0/16 · 4/0 · 0/0 · 0/0** is clean.
- Validator v6's structural plain-header discovery, optional-outer-pipe
  handling, empty/whitespace rejection, case-insensitive plain status-header
  handling, blank-cell rule, coverage checks, and exact-one-primary rule.
- All live current-line references remain version-free/current and mutually
  consistent.
- SOL-R02-03 / W-14's bounded-absence formulations.
- W-02 through W-13, every authority distinction, independence coordinate,
  gate design, substantive fork triage, and non-commencement clause.
- Source authentication, quotation corrections, master-commission identity,
  filed Sol returns, hand-count record, and mode normalization.

## 7. Minimal R0.8 commission

> **Return Candidate R0.8 as a strictly bounded checker-only repair of
> Candidate R0.7. Preserve R0 through R0.7 byte-identical; generate no
> evidence; solicit no owner dispositions; activate no docket; open no campaign
> or jurisdiction. Repair only SOL-R07-01 in the Sol R0.7 Readback. Replace the
> validator so structurally discovered Status-table header labels are compared
> after explicit case and inline-markup normalization, including label-only
> emphasis, strong emphasis, code-span, and link wrappers, and so a recognized
> table header is not re-read as a prose Status declaration. Add committed
> ordinary-invocation controls proving that italicized first-column Status
> headers with an invalid token or blank cell cannot pass under `0:0`, and that
> a bold Status header with a valid OPEN row is counted once and accepted.
> Preserve v6's nineteen negatives, seven positives, canonical coverage,
> empty-text, case-variant, optional-outer-pipe, blank-cell, coverage, and
> exact-one controls. Carry SOL-R06-02 closed; if the ordinary successor
> protocol emits an R0.1–R0.7 occurrence inventory for the five R0.8
> successors, regenerate it mechanically with ordinals and fail-on-live,
> without reopening any R0.7 classification. Align only ordinary R0.8
> identities. Do not reopen the constitutional text, SOL-R04-01, the zero-live
> conclusion, SOL-R02-03/W-14, W-02…W-13, any authority holding, independence
> coordinate, gate design, substantive fork triage, or non-commencement clause.
> Return a one-finding concordance, validator self-test and adversarial results,
> exact commit/tree identity, all nine strata checksums, and stop.**

## 8. Custody statement

This readback modified no candidate file and no repository artifact. It opened
no owner docket, gate, campaign, hidden bank, J2, census, evaluator, transcript,
receipt, ruling, publication, merge, or adoption. It generated no empirical
evidence. The only new constitutional artifact is this review report; the
independent Markdown fixture is an ungoverned local audit input outside the
candidate tree. R0.7 remains a candidate and remains untouched.

*— Sol readback, 2026-08-11.*
