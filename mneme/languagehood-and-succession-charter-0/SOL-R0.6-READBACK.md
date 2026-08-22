# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.6

**Date:** 2026-08-11

**Mode:** read-only documentary, identity, validator, and occurrence-census review

**Review object:** `languagehood-and-succession-charter-0-r0.6-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.7 REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, owner solicitation, or new evidence

## 1. Review scope

This seventh-stratum readback tested the R0.6 return against the attached
archive bytes rather than accepting the return's description of itself. It:

1. authenticated the outer archive, sidecar, member types, seven checksum
   strata, historical bytes, filed Sol return, and parcel-directory Git tree;
2. compared every shared file to the previously authenticated R0.5 archive and
   inspected all five R0.5→R0.6 successor diffs;
3. ran `validate_status_grammar_v5.py` in self-test, canonical, empty-text,
   case-variant, and independent Markdown-table-variation modes;
4. independently enumerated every `R0.1`…`R0.5` occurrence in the five R0.6
   successors, compared the resulting 128-key multiset to the delivered table,
   and inspected the remaining prior-version contexts for live use; and
5. traced SOL-R05-01 and SOL-R05-02 through the concordance, validator,
   successor documents, return, and occurrence adjudication.

No candidate file was edited.

## 2. Custody and identity

The return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `567eb315296e91429d6a6b219734373992b8394a4acdde78e0a0ef05bd18326f`
  — exact match to the supplied sidecar.
- The archive contains **80 ordinary members: 75 files and 5 directories**.
  No traversal, absolute-path, symlink, device, or other special member was
  found.
- Internal checksum regimes pass: **R0 7/7 · R0.1 12/12 · R0.2 10/10 ·
  R0.3 9/9 · R0.4 9/9 · R0.5 10/10 · R0.6 10/10**.
- Every file shared with the previously authenticated R0.5 archive is
  byte-identical. The only added project files are the eleven expected R0.6
  objects: five successors, filed Sol R0.5 readback, validator v5, regenerated
  occurrence table, concordance, return, and checksum manifest.
- The filed `SOL-R0.5-READBACK.md` is byte-identical to the Sol report delivered
  in the preceding round.
- Reconstructed parcel-directory Git tree:
  `aeece971cdc899c57d85a8cea58915988a4bc549` — exact match to
  `GIT-IDENTITY-R0.6.txt` and the return.
- Candidate commit `4b229a7dc59b8c18d02d52165f8aefd3edbc5266` remains an
  identity claim in this workspace because the authoritative repository object
  graph is absent. The parcel tree is authenticated; the commit must still be
  confirmed in the authoritative repository before owner disposition.

## 3. Executive verdict

R0.6's constitutional text is clean within this round's bounded scope. The
five successor diffs contain only ordinary R0.6 identity and companion-pointer
alignment. The canonical status corpus is clean at charter **10 declarations / 6
table cells**, Claim Ceiling **16 table cells**, Succession Docket **4
declarations**, and `0:0` for the Owner Docket and Evidence Ledger. No authority
holding, gate design, fork, W-14 boundary, or non-commencement clause moved.

R0.6 closes the empty-text and case-variant defects named in SOL-R05-01:
whitespace-only input under a matched `0:0` expectation fails with exit 2;
lowercase `status` and uppercase `STATUS NOW` headers are discovered; the
seventeen-negative self-test passes; and the canonical run is genuinely green.

It does not finish the commissioned **Markdown-header-variation** half. The
discovery gate requires a literal pipe before the word `status`. A valid pipe
table that omits optional outer pipes and places `Status` in its first column is
therefore invisible. Under a matched `0:0` expectation, v5 prints `CLEAN`, exit
0, even when that undiscovered cell contains `**MYSTERY**`. This is the same
class of false green the fail-closed commission was meant to abolish.

The R0.6 occurrence table is exhaustive and its important conclusion is sound:
all **128** actual prior-version occurrences have exactly one delivered row,
and independent inspection confirms **0 LIVE** stale operands. One safe-side
classification is wrong, however. Charter line 7's `R0.5` is inside the frozen
filename `SOL-R0.5-READBACK.md`, not a narrative reference. Correct R0.6 totals
are therefore **113 HISTORICAL/PROVENANCE · 15 FROZEN-ARTIFACT NAME · 0 LIVE**,
not 114/14/0.

The remaining work is one parser repair and one row correction. Nothing
constitutional needs another turn.

## 4. Prior-finding disposition

| R0.5 readback finding | R0.6 disposition | Readback |
|---|---|---|
| **SOL-R05-01** — v4 accepts covered empty files and misses case/Markdown header variation | **PARTIAL — RATIFICATION BLOCKER** | Empty/whitespace-only files and case-variant headers are repaired; self-test and canonical run pass. A no-outer-pipe table with `Status` as its first column remains invisible and can produce false `CLEAN` under `0:0`. |
| **SOL-R05-02** — six wrong R0.5 classes; regenerate with occurrence ordinals | **SUBSTANTIVELY CLOSED; ONE-ROW RECORD REPAIR** | The R0.5 correction is stated accurately; the R0.6 table is an exact 128-row occurrence census with ordinals and 0 LIVE. One filename occurrence is classified as historical, making the R0.6 totals 113/15/0 rather than 114/14/0. |

## 5. Readback findings

### SOL-R06-01 — RATIFICATION BLOCKER — v5 misses a standard Markdown table form

The following claims are verified:

- `--self-test` reports **PASS**: seventeen negative controls caught and seven
  positives accepted;
- supplied empty or whitespace-only text fails even under a matched `0:0`
  expectation, exit 2;
- lowercase `status` and uppercase `STATUS NOW` headers are discovered and
  their invalid/blank cells rejected;
- the canonical five-file run reports **10/6 · 0/16 · 4/0 · 0/0 · 0/0** and
  exits 0; and
- the actual R0.6 corpus is clean under an independent status-surface review.

The surviving false green is caused by this discovery gate:

```python
if '|' in line and re.search(r'\|\s*status', line, re.IGNORECASE):
```

Markdown permits outer pipes to be omitted. This valid table therefore never
reaches the otherwise capable header parser:

```markdown
Status | Claim | Note
--- | --- | ---
**MYSTERY** | r1 | invalid primary token
```

With that file supplied under a matched `0:0` expectation, v5 reports `0
declarations, 0 table status cells`, prints `CLEAN`, and exits 0. The defect is
not hypothetical parser maximalism: SOL-R05-01 explicitly commissioned
fail-closed discovery across **case and Markdown-header variation**. Optional
outer pipes and a first-column header are ordinary GitHub-flavored Markdown.

**Smallest repair:** replace only the validator and its controls so that table
headers are discovered structurally, with or without optional leading/trailing
pipes, before normalized cells are searched for a case-insensitive `Status`
column. Add an ordinary-invocation negative control using a no-outer-pipe,
first-column `Status` header with an invalid token (and preferably the blank-cell
twin). Preserve v5 byte-identical in the R0.6 stratum. The canonical corpus must
remain green at its existing coverage.

### SOL-R06-02 — MINOR RECORD DEFECT — one frozen filename is called narrative

Independent replay establishes:

- actual R0.1–R0.5 occurrences across the five successors: **128**;
- delivered table rows: **128**;
- unique actual keys / unique table keys: **128 / 128**;
- missing, extra, or duplicate keys: **0 / 0 / 0**;
- the six loci named by SOL-R05-02 split correctly by ordinal; and
- live stale operands: **0**.

One class assignment is nonetheless false:

| File and line | Occurrence | Delivered class | Correct class |
|---|---|---|---|
| Charter line 7 | `R0.5` in ``SOL-R0.5-READBACK.md`` | HISTORICAL/PROVENANCE | FROZEN-ARTIFACT NAME |

The classification is not ambiguous. The token is literally inside the name of
the filed, checksum-governed Sol readback. The directly corresponding R0.5
table row for `SOL-R0.4-READBACK.md` was itself classified
`FROZEN-ARTIFACT NAME`. Thus the accurate R0.6 distribution is **113
HISTORICAL/PROVENANCE · 15 FROZEN-ARTIFACT NAME · 0 LIVE**.

**Smallest repair:** correct that row, its reason, and the R0.6 totals of record.
When the five R0.7 successors are created, regenerate the R0.1–R0.6 inventory
with the occurrence ordinal retained and the same fail-on-live rule.

## 6. Structures that survive and must not be reopened

- All seven checksum strata and the authenticated R0.6 parcel tree.
- The R0.6 constitutional text and bounded five-document successor diffs.
- SOL-R04-01: latent-authorship wording remains candidate-proposed / CC-3
  pending F-8, never presently licensed.
- The actual R0.6 status content: **10/6 · 0/16 · 4/0 · 0/0 · 0/0** is clean.
- Validator v5's empty/whitespace rejection and case-insensitive status-header
  handling.
- The R0.5 correction of record: **113/16/0**.
- The R0.6 occurrence table's exact 128-key coverage, correct ordinals, and **0
  LIVE** conclusion.
- All live current-line references remain version-free/current and mutually
  consistent.
- SOL-R02-03 / W-14's bounded-absence formulations.
- W-02 through W-13, every authority distinction, independence coordinate,
  gate design, substantive fork triage, and non-commencement clause.
- Source authentication, quotation corrections, master-commission identity,
  filed Sol returns, hand-count record, and mode normalization.

## 7. Minimal R0.7 commission

> **Return Candidate R0.7 as a strictly bounded parser-and-record repair of
> Candidate R0.6. Preserve R0 through R0.6 byte-identical; generate no
> evidence; solicit no owner dispositions; activate no docket; open no campaign
> or jurisdiction. Repair only SOL-R06-01 and SOL-R06-02 in the Sol R0.6
> Readback. Replace the validator so status-bearing Markdown tables are
> discovered structurally with or without optional outer pipes, including a
> first-column Status header after case/markup normalization; add committed
> ordinary-invocation negative controls proving that an invalid token and blank
> cell in that table form cannot pass under `0:0`; preserve v5's empty-text,
> case-variant, coverage, and exact-one controls. Correct Charter line 7's
> `SOL-R0.5-READBACK.md` occurrence to FROZEN-ARTIFACT NAME and the R0.6 totals
> to 113/15/0; regenerate the exhaustive R0.1–R0.6 occurrence inventory for the
> five R0.7 successors with ordinals and fail-on-live preserved. Align only
> ordinary R0.7 identities. Do not reopen the constitutional text, SOL-R04-01,
> the zero-live conclusion, SOL-R02-03/W-14, W-02…W-13, any authority holding,
> independence coordinate, gate design, substantive fork triage, or
> non-commencement clause. Return a two-finding concordance, validator self-test
> and adversarial results, exact commit/tree identity, all eight strata
> checksums, and stop.**

## 8. Custody statement

This readback modified no candidate file and no repository artifact. It opened
no owner docket, gate, campaign, hidden bank, J2, census, evaluator, transcript,
receipt, ruling, publication, merge, or adoption. It generated no empirical
evidence. The only new object is this review report. R0.6 remains a candidate
and remains untouched.

*— Sol readback, 2026-08-11.*
