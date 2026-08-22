# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.4

**Date:** 2026-08-11

**Mode:** read-only documentary and validator review

**Review object:** `languagehood-and-succession-charter-0-r0.4-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR BOUNDED R0.5 REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, owner solicitation, or new evidence

## 1. Review scope

This readback tested the R0.4 return against the actual archive bytes rather
than accepting the return's account of itself. It:

1. authenticated the outer archive, sidecar, member types, five checksum
   strata, historical bytes, and parcel-directory Git tree;
2. compared the R0.4 successors to R0.3 to confirm the bounded repair scope;
3. traced SOL-R03-01, SOL-R03-02, and SOL-R03-04 through the five current
   successor documents;
4. ran `validate_status_grammar.py` in self-test and canonical-corpus modes;
5. supplied independent negative controls for silence, blank table status
   cells, masked blanks, and multiple primary tokens; and
6. independently enumerated the current corpus's inline, separated, and table
   status declarations under the charter's exact-one-primary-token rule.

No candidate file was edited.

## 2. Custody and identity

The controlled return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `59040ba83e85f0c269484fcf207c5c38c8220f4d1f68111719ab64c2b6179582`
  — exact match to the supplied sidecar.
- The archive contains 58 ordinary files/directories under the expected root;
  no traversal, symlink, device, or foreign-root member was found.
- Internal checksum regimes pass: **R0 7/7 · R0.1 12/12 · R0.2 10/10 ·
  R0.3 9/9 · R0.4 9/9**.
- Every governed R0, R0.1, R0.2, and R0.3 file was additionally compared
  byte-for-byte against its earlier uploaded controlled archive: **7/7,
  12/12, 10/10, and 9/9 identical**.
- `SOL-HOSTILE-RETURN-R0.md` and the R0.4 validator are both mode `100644`;
  the earlier disclosed mode normalization remains intact.
- Reconstructed parcel-directory Git tree:
  `ec60ff18ad03b34594cc851784e7c7aa92dbd3bd` — exact match to
  `GIT-IDENTITY-R0.4.txt` and the return.
- Candidate commit `04d0ef987829fdaf41768c405186f35fa47ecb9c`
  remains metadata-only in this workspace: the authoritative repository object
  graph is absent. The parcel tree is authenticated; the commit itself must be
  confirmed in the authoritative repository before owner disposition.

## 3. Executive verdict

R0.4 closes the latent-authorship authority defect and preserves every earlier
stratum. The current charter corpus is also status-clean when inspected by an
independent exact-one pass: 10 charter rung declarations, 6 charter legend
cells, 16 claim-ceiling cells, and 4 succession-docket declarations carry one
lawful primary token each.

R0.4 nevertheless does not close the validator finding. The replacement
validator can still print `CLEAN` on silence, ignores an empty status cell, and
accepts two primary legend tokens in one status cell. Its blessed invocation is
green; its enforcement claim is not.

The identity repair also retains one live stale operand: Charter §I recommends
the current candidate line “now R0.3,” while the operative Owner Docket correctly
names R0.4. The required occurrence adjudication was returned as aggregate
counts, not as the finite per-occurrence table the R0.3 readback required.

This is not a constitutional redraft. R0.5 can be confined to one validator
repair and one identity/documentation repair. The owner docket remains dormant
until that readback is green.

## 4. Prior-finding disposition

| R0.3 readback finding | R0.4 disposition | Readback |
|---|---|---|
| **SOL-R03-01** — P1 latent-authorship wording promoted to present license | **PASS** | All live formulations now treat the wording as candidate-proposed / CC-3 pending F-8; the design-intent/LM0 distinction survives. |
| **SOL-R03-02** — validator does not enforce the declared grammar | **PARTIAL — RATIFICATION BLOCKER** | Actual R0.4 declarations are captured and clean, but independent controls show false-green paths for silence, blank status cells, and multiple primary tokens. |
| **SOL-R03-04** — current-version identity and occurrence adjudication incomplete | **PARTIAL — MAJOR** | Principal R0.4 identities are repaired and the reported 109 R0.1/R0.2 occurrences are mechanically confirmed, but one live `now R0.3` operand remains and no per-occurrence adjudication table was returned. |

## 5. Readback findings

### SOL-R04-01 — NO DEFECT — latent-authorship authority is consistently demoted

The six repair sites identified by the R0.4 concordance are substantively
correct:

- Charter §C.23 states that P1 §1.LM.2 is candidate text and licenses nothing;
- charter rung 10 and §F.1(9) use candidate-proposed / CC-3 pending F-8;
- Succession Docket §4 uses the same standing;
- the Claim Ceiling LM0 cell uses candidate-proposed / CC-3 pending F-8; and
- Ledger EV-39 distinguishes P1's designation from present constitutional
  license.

Owner Docket F-8 also correctly explains that P1 describes the wording as
licensed while P1 itself remains candidate text; this is a historical/source
description, not a present-license grant. No live site assigns the wording
CC-2 or treats it as presently licensed. The separate proposition that design
intent is not an LM0 empirical result remains intact.

**Disposition:** closed. Do not reopen in R0.5.

### SOL-R04-02 — RATIFICATION BLOCKER — the validator still admits false CLEAN results

The reported positive facts are genuine:

- all ten committed negative controls are caught;
- all seven committed positives pass;
- the canonical five-file run with explicit expectations reports:
  - charter: 10 declarations, 6 table status cells;
  - Claim Ceiling: 16 table status cells;
  - Succession Docket: 4 declarations;
  - Owner Docket and Evidence Ledger: zero declared status surfaces; and
- that run exits 0 and reports `CLEAN`.

An independent exact-one enumeration also finds no malformed current R0.4
status surface. The text is clean. The validator is not yet fail-closed.

| Independent control | Required | Actual |
|---|---:|---:|
| invoke validator with no inputs | refuse CLEAN | `CLEAN`, exit 0 |
| empty input text | refuse zero-coverage success | 0 violations |
| status-bearing table row with an empty Status cell | violation | 0 violations; row not counted |
| one empty Status row plus one valid row | empty row remains a violation | 0 violations; valid row can satisfy a minimum count |
| one Status cell containing `**OPEN** / **HISTORICAL**` | violation: two primary tokens | 0 violations; cell counted as valid |

These are direct breaches of §A.1's rule that every classified proposition has
**exactly one** primary status. They also contradict the validator's claim that
coverage is asserted before `CLEAN` may print and that silence cannot pass.
Optional caller-supplied minima do not cure the default path; an omitted,
misspelled, or incomplete expectation silently restores the false green.

**Consequence:** a future candidate can lose a classified row, leave its status
blank, or place two primary tokens in one cell while retaining a green validator
run. That is the cheapest accidental or dishonest pass the validator exists to
prevent.

**Smallest repair:** replace only the validator and its tests so that:

1. ordinary invocation refuses zero input files;
2. every supplied corpus file is covered by an explicit, successfully matched
   expectation or by a checked canonical manifest; missing, duplicate,
   misspelled, or unused expectations are errors;
3. every data row in a status-bearing table is counted, and a missing or blank
   Status cell is a violation;
4. each status cell contains exactly one bold primary legend token, at the
   beginning of the cell, and any second primary legend token is a violation;
5. `CLEAN` is impossible until coverage validation itself has passed; and
6. committed negative controls include: no-input invocation, blank cell,
   blank-plus-valid masking, and two-primary-token cell.

Preserve `validate_status_grammar.py` byte-identical in the frozen R0.4
stratum. No owner disposition is required.

### SOL-R04-03 — MAJOR — one live R0.3 operand survives and the adjudication table is absent

Most identity repairs are correct. Titles, banners, companion pointers,
closing signatures, the independence-matrix self-row, and the operative Owner
Docket F-1 options all identify R0.4 or the current R0.x line correctly.

One live contradiction remains in
`LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.4.md` §I, F-1 summary:

> `the current candidate line (now R0.3) as working candidate`

The operative `OWNER-DOCKET-R0.4.md` correctly offers:

> `the current R0.x candidate line (presently R0.4) governs as working candidate`

The charter summary therefore names R0.3 as the object of a fork whose full
docket names R0.4. This is a live operand, not historical provenance.

The return's count of **109** remaining R0.1/R0.2 occurrences across the five
successors is mechanically accurate (**86 R0.1 + 23 R0.2**). But the R0.3
readback required a finite *per-occurrence adjudication table in the
concordance*. R0.4 supplies only aggregate prose: 109 total, 28 ambiguous, 19
kept, 9 fixed. Neither the concordance nor the return contains the occurrence
rows. The missing table makes “every one adjudicated” unauditable from the
parcel and helped leave the immediate-predecessor `now R0.3` site outside the
sweep. The five successors contain 19 R0.3 occurrences; 18 are historical or
provenance references, and the F-1 site is the lone live stale operand.

**Consequence:** activating the docket would present the owner with two
different candidate identities for Option A, and the claimed exhaustive
identity audit cannot be replayed from its delivered record.

**Smallest repair:** in R0.5:

1. replace the F-1 summary operand with the stable wording
   `the current R0.x candidate line as working candidate, P1 preserved
   historical-candidate`;
2. align ordinary R0.5 titles, live companion pointers, live self-identities,
   and closing signatures without rewriting historical attributions; and
3. include in the R0.5 concordance (or a checksum-governed companion table) an
   exhaustive occurrence inventory for every R0.1/R0.2/R0.3/R0.4 token in the
   five R0.5 successors: file, line, matched token, classification
   (`HISTORICAL/PROVENANCE`, `FROZEN-ARTIFACT NAME`, or `LIVE — REPAIRED`), and
   brief reason. Aggregate counts may summarize the table but may not replace
   it.

No owner disposition is required.

## 6. Structures that survive and must not be reopened

- All five checksum strata and the R0.4 parcel tree.
- SOL-R03-01: latent-authorship wording is candidate-proposed / CC-3 pending
  F-8, never presently licensed.
- SOL-R02-03 / W-14's bounded-absence formulations.
- The actual R0.4 corpus's status content: 10 charter declarations, 6 charter
  legend cells, 16 ceiling cells, and 4 succession-docket declarations are
  independently exact-one clean.
- W-02 through W-13, including the proposed languagehood classification,
  semantic-jurisdiction doctrine, non-aggregation, claim-relative exposure,
  P5 rescore, LM0 edge split, and backward-impeachment clauses.
- Every independence coordinate and all PortJ-L/0, PortJ-F/0, CI0, DG0, and
  LM0 gate designs.
- The substantive fork triage and every non-commencement clause.
- Source authentication, quotation corrections, master-commission identity,
  filed Sol returns, hand-count correction, and mode normalization.

## 7. Minimal R0.5 commission

> **Return Candidate R0.5 as a strictly bounded documentary repair of Candidate
> R0.4. Preserve R0, R0.1, R0.2, R0.3, and R0.4 byte-identical; generate no
> evidence; solicit no owner dispositions; activate no docket; open no campaign
> or jurisdiction. Repair only SOL-R04-02 and SOL-R04-03 in the Sol R0.4
> Readback. Make the status validator fail closed on zero inputs and incomplete
> or unmatched coverage declarations; require every status-bearing table row to
> contain exactly one primary legend token; add negative controls for silence,
> blank cells, masked blanks, and double-primary cells. Repair Charter §I's live
> `now R0.3` F-1 operand, align only live R0.5 identities, and return the required
> exhaustive occurrence adjudication table for all prior-version tokens in the
> five R0.5 successors. Do not reopen SOL-R04-01, SOL-R02-03/W-14, W-02…W-13,
> any independence coordinate, gate design, substantive fork triage, or
> non-commencement clause. Return a two-finding concordance, validator self-test
> and fail-closed corpus results, exact commit/tree identity, all six strata
> checksums, and stop.**

## 8. Custody statement

This readback modified no candidate file and no repository artifact. It opened
no owner docket, gate, campaign, hidden bank, J2, census, evaluator, transcript,
receipt, ruling, publication, merge, or adoption. It generated no empirical
evidence. The only new object is this review report. R0.4 remains a candidate
and remains untouched.

*— Sol readback, 2026-08-11.*
