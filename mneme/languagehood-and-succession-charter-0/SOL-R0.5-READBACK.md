# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.5

**Date:** 2026-08-11

**Mode:** read-only documentary, identity, and validator review

**Review object:** `languagehood-and-succession-charter-0-r0.5-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR STRICTLY BOUNDED R0.6 REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, owner solicitation, or new evidence

## 1. Review scope

This sixth-stratum readback tested the R0.5 return against the attached archive
bytes rather than accepting the return's description of itself. It:

1. authenticated the outer archive, sidecar, member types, six checksum
   strata, historical bytes, filed Sol return, and parcel-directory Git tree;
2. compared the five R0.5 successor documents to R0.4 to test the bounded
   repair promise;
3. traced SOL-R04-02 and SOL-R04-03 through the concordance, validator,
   charter, satellites, return, and occurrence table;
4. ran `validate_status_grammar_v4.py` in self-test, zero-input, canonical,
   uncovered-input, misspelled-expectation, duplicate-expectation, blank-cell,
   double-primary, empty-file, and case-variant-table modes;
5. independently enumerated every `R0.1`/`R0.2`/`R0.3`/`R0.4` token in the five
   R0.5 successors and compared that multiset to all 129 delivered table rows;
   and
6. inspected each remaining prior-version line for live identity use versus
   historical provenance or frozen-artifact naming.

No candidate file was edited.

## 2. Custody and identity

The return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `9d1d3f5fb2646d0a4ac58ad04d4bedecbd36d32bf5e19fda559740426548cbb7`
  — exact match to the supplied sidecar.
- The archive contains **69** ordinary members: **64 files and 5 directories**.
  No traversal, absolute-path, symlink, device, or other special member was
  found.
- Internal checksum regimes pass: **R0 7/7 · R0.1 12/12 · R0.2 10/10 ·
  R0.3 9/9 · R0.4 9/9 · R0.5 10/10**.
- Every governed R0–R0.4 file and each corresponding checksum manifest was
  additionally compared byte-for-byte against the earlier controlled R0.4
  archive: all are identical.
- The filed `SOL-R0.4-READBACK.md` is byte-identical to the Sol report delivered
  in the preceding round.
- Reconstructed parcel-directory Git tree:
  `5da286e18003182c4472f23e365bca4800b072b4` — exact match to
  `GIT-IDENTITY-R0.5.txt` and the return.
- Candidate commit `c5514b297267cc5275b1d497b1577c1fb12a9c1c` remains an
  identity claim in this workspace because the authoritative repository object
  graph is absent. The parcel tree is authenticated; the commit must still be
  confirmed in the authoritative repository before owner disposition.

The malformed archive path in item 5 of the chat return is a transcription
splice, not a parcel defect: the attached archive has the ordinary R0.5 name,
and both its bytes and supplied sidecar establish the full hash above.

## 3. Executive verdict

R0.5 is constitutionally and textually sound within the bounded scope of this
round. The five successor diffs contain only R0.5 identity alignment, stable
version-free live references, the repaired F-1 wording, and associated
provenance. The current status corpus is independently clean: charter **10
declarations / 6 table cells**, Claim Ceiling **16 table cells**, Succession
Docket **4 declarations**, and no declared status surfaces in the Owner Docket
or Evidence Ledger.

The occurrence adjudication also establishes the fact that mattered: all 129
prior-version tokens are present in its table, and **zero are live stale
operands**. The old `now R0.3` conflict and the versioned live references are
gone.

R0.5 nevertheless does not fully close SOL-R04-02. The validator refuses a
zero-file invocation and catches the commissioned cell errors, but an actually
supplied empty file with a matched `0:0` expectation still prints `CLEAN`, exit
0. This is the exact empty-input-text false green recorded by the R0.4
readback. Because two governed inputs legitimately carry `0:0` status
expectations, either file could be truncated to nothing without this validator
objecting. A lowercase `status` table header is likewise invisible because a
case-sensitive discovery gate precedes otherwise case-insensitive header
handling.

The occurrence table has a smaller documentary error: six occurrences called
`FROZEN-ARTIFACT NAME` are actually historical revision references. The
complete and correct totals are **113 HISTORICAL/PROVENANCE · 16
FROZEN-ARTIFACT NAME · 0 LIVE**, not 107/22/0. This does not revive any stale
identity; it only prevents the table from being exact in the way it claims.

The remaining work is one checker repair and one table correction. No holding,
authority classification, independence coordinate, gate, fork, or campaign
clause needs another turn.

## 4. Prior-finding disposition

| R0.4 readback finding | R0.5 disposition | Readback |
|---|---|---|
| **SOL-R04-02** — validator admits false CLEAN paths | **PARTIAL — RATIFICATION BLOCKER** | The commissioned zero-file, coverage, blank-cell, masked-blank, and double-primary paths are repaired, and the real corpus is clean. A supplied empty file with a valid `0:0` expectation still returns `CLEAN`, exit 0; case-variant status-table discovery is also fail-open. |
| **SOL-R04-03** — live `now R0.3` operand and absent occurrence table | **SUBSTANTIVELY CLOSED; MINOR RECORD REPAIR** | All live identities are version-free/current, the table's 129-row occurrence multiset is exact, and 0 LIVE is correct. Six non-live rows use the wrong non-live class, so the 107/22 totals are inaccurate. |

## 5. Readback findings

### SOL-R05-01 — RATIFICATION BLOCKER — v4 still accepts a covered empty file

The following claims are verified:

- `--self-test` reports **PASS**: fourteen negative controls caught and seven
  positives accepted;
- a zero-file invocation returns 2 and never prints `CLEAN`;
- uncovered, misspelled/unused, and duplicate expectations return 2;
- blank status cells, a blank masked by a valid row, and two primary legend
  tokens in one cell are violations;
- the canonical five-file invocation reports the stated coverage and exits 0;
  and
- the actual R0.5 status surfaces are clean under both v4 and an independent
  exact-one inspection.

The surviving control is equally direct. Given an empty file and its explicit
expectation `empty.md:0:0`, v4 reports:

```text
empty.md: 0 declarations, 0 table status cells
CLEAN (coverage validated: every file matched by an expectation; all expectations met)
```

and exits 0.

This is not the already-repaired *zero-input invocation*. It is the distinct
**empty input text** control in SOL-R04-02. The distinction is load-bearing:
`OWNER-DOCKET-R0.5.md` and `EVIDENCE-LEDGER-R0.5.md` legitimately use `0:0`
expectations because they contain no reserved status surfaces. Under v4, either
could be replaced by an empty or whitespace-only file while retaining a green
canonical-shaped run.

The discovery gate is also narrower than the parser's contract. A table headed
`status` rather than `Status` is never identified as status-bearing, even
though the next-stage header comparison already lowercases cells. A row such
as `**MYSTERY**` beneath that header therefore passes with a `0:0` expectation.
The current corpus does not contain such a table; this is an enforcement defect,
not a claim that the R0.5 text is malformed.

**Smallest repair:** replace only the validator and its controls so that:

1. every supplied file must contain non-whitespace text before coverage can
   pass, or must be authenticated by a checked canonical content manifest;
2. status-bearing table discovery is case-insensitive after Markdown-header
   normalization, with noncanonical case either validated or explicitly
   rejected rather than silently ignored;
3. committed ordinary-invocation controls include a matched `0:0` empty file
   and a case-variant status table containing an invalid token; and
4. the canonical six-file-lineage run remains green only after these controls
   fail as required.

Preserve v4 byte-identical in the frozen R0.5 stratum. No owner choice is
required.

### SOL-R05-02 — MINOR RECORD DEFECT — six safe-side classifications are wrong

The delivered occurrence table is exhaustive as a multiset:

- independently enumerated actual occurrences: **129**;
- delivered occurrence rows: **129**;
- file/line/token multiset comparison: **exact match**; and
- independent live-reference inspection: **0 LIVE**.

Six rows are nonetheless not frozen-artifact names. They narrate when a repair
landed or quote an earlier frozen revision's defect, and therefore belong to
`HISTORICAL/PROVENANCE`:

| File and line | Occurrence | Delivered class | Correct class |
|---|---|---|---|
| Charter line 22 | second `R0.1`, in “the R0.1-round record” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |
| Charter line 71 | `R0.1`, in “filed at R0.1” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |
| Charter line 1244 | `R0.4`, in “the R0.4 summary” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |
| Charter line 1244 | `R0.3`, in the historical quote “now R0.3” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |
| Charter line 1244 | second `R0.4`, in “the docket's correct R0.4” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |
| Succession Docket line 49 | `R0.2`, in “pointer corrected at R0.2” | FROZEN-ARTIFACT NAME | HISTORICAL/PROVENANCE |

Thus the accurate distribution is **113 HISTORICAL/PROVENANCE · 16
FROZEN-ARTIFACT NAME · 0 LIVE**. The crucial zero-live conclusion survives;
only the record's finer classification and totals fail.

**Smallest repair:** correct those six rows, their reasons, and the aggregate
totals. Because identical tokens can occur more than once on one line with
different meanings, add an occurrence ordinal or character column wherever
file/line/token alone is ambiguous. When the five R0.6 successors are created,
regenerate the inventory across `R0.1` through `R0.5` and retain the same
fail-on-unmatched rule.

## 6. Structures that survive and must not be reopened

- All six checksum strata and the authenticated R0.5 parcel tree.
- SOL-R04-01: latent-authorship wording remains candidate-proposed / CC-3
  pending F-8, never presently licensed.
- The repaired F-1 operand and all live current-line references: they are
  version-free by construction and agree across charter and docket.
- The occurrence inventory's complete 129-token coverage and its **0 LIVE**
  conclusion.
- The actual R0.5 corpus's status content: 10 charter declarations, 6 charter
  legend cells, 16 ceiling cells, and 4 succession-docket declarations are
  exact-one clean.
- SOL-R02-03 / W-14's bounded-absence formulations.
- W-02 through W-13, every authority distinction, independence coordinate,
  gate design, substantive fork triage, and non-commencement clause.
- Source authentication, quotation corrections, master-commission identity,
  filed Sol returns, hand-count record, and mode normalization.

## 7. Minimal R0.6 commission

> **Return Candidate R0.6 as a strictly bounded checker-and-record repair of
> Candidate R0.5. Preserve R0, R0.1, R0.2, R0.3, R0.4, and R0.5
> byte-identical; generate no evidence; solicit no owner dispositions; activate
> no docket; open no campaign or jurisdiction. Repair only SOL-R05-01 and
> SOL-R05-02 in the Sol R0.5 Readback. Replace the validator so that a supplied
> empty or whitespace-only file cannot pass under a matched `0:0` expectation,
> and so that status-bearing table discovery is fail-closed across case and
> Markdown-header variation; add committed ordinary-invocation negative
> controls for both paths. Correct the six occurrence classifications and the
> 113/16/0 totals; add an ordinal or column where same-line duplicate tokens are
> otherwise ambiguous; and regenerate the exhaustive R0.1–R0.5 occurrence
> inventory for the five R0.6 successors. Align only ordinary R0.6 identities.
> Do not reopen SOL-R04-01, the zero-live conclusion, SOL-R02-03/W-14,
> W-02…W-13, any authority holding, independence coordinate, gate design,
> substantive fork triage, or non-commencement clause. Return a two-finding
> concordance, validator self-test and adversarial results, exact commit/tree
> identity, all seven strata checksums, and stop.**

## 8. Custody statement

This readback modified no candidate file and no repository artifact. It opened
no owner docket, gate, campaign, hidden bank, J2, census, evaluator,
transcript, receipt, ruling, publication, merge, or adoption. It generated no
empirical evidence. The only new object is this review report. R0.5 remains a
candidate and remains untouched.

*— Sol readback, 2026-08-11.*
