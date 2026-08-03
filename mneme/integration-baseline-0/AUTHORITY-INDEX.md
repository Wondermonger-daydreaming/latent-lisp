# Lisp+ — Authority Index

**Integration Baseline /0 · 2026-08-02**

Every ruling-class document that governs this project, in one page, **regardless of filename
convention**. Twelve of these sit outside the advertised `mneme/RULING-*.md` naming, which is
why this index exists: before it, finding the authority for a lane meant knowing where its
author had put it.

**Reading rule.** *Adoption attaches to specifications. Implementations are candidates.* A
document below that adopts a **spec** makes that spec govern. A document that accepts an
**implementation** accepts it as a *candidate*, and confers no conformance, verification, or
validation language. **No implementation is adopted unless an exact ruling says otherwise, and
none does.**

Standing vocabulary used below: **GOVERNING** · **ADOPTED** (spec) · **ACCEPTED** (candidate
implementation) · **CANDIDATE** · **CANDIDATE-BY-DEFAULT** (never ruled) ·
**AUTHORIAL RULING REQUIRED** (an open demand on the owner).

---

## I. Constitutional layer

| # | document | governs | standing |
|---|---|---|---|
| 1 | `mneme/architecture/LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md` | the decisions record — the constitution's own resolutions | **GOVERNING** |
| 2 | `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` | Architecture 0.1, the traced repair of Architecture 0 | **GOVERNING** |
| 3 | `mneme/architecture/ARCHITECTURE-0-STATUS.md` | the chamber's WE-ARE-HERE stone | **status record** — see the note below |
| 4 | `mneme/architecture/STRANGER-AUDIT-RECRUIT-SPEC.md` | the reserved independent primitive-minimization audit | **seat reserved, NEVER COMMISSIONED** |

> **Note on the status stone.** As of the 2026-08-02 assessment, `ARCHITECTURE-0-STATUS.md`
> carries a header date of 2026-07-18 and ends at Addendum 13, while the tree ran through
> 2026-07-30. It is one lane behind and self-dated wrong. **Integration Baseline /0 does not
> rewrite it** — amending the constitution's own status record is not a packaging act. Read it
> as historical until an authorized amendment lands; read *this* index and
> `INTEGRATION-BASELINE-0-RETURN.md` for the current standing matrix.

## II. Adopted specifications

| # | document | spec | standing |
|---|---|---|---|
| 5 | `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` | Kernel /0 | **ADOPTED / GOVERNING** |
| 6 | `mneme/architecture/kernel-0-errata/KERNEL-0-ERRATA-0.2-ADOPTION-RECORD.md` | Kernel /0 Errata 0.2 (gaps 1–4 closed) | **ADOPTED** |
| 7 | `mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md` | Process Journal /0 | **ADOPTED**, with the binding gate: no conformance claim beyond self-consistency until an independently seeded CL implementation passes the full vector set — **paid by journal0, 89/0** |
| 8 | `mneme/architecture/pj0-errata/LISP-PLUS-PJ0-ERRATA-0.1.md` | PJ0 Erratum 0.1 (corpus key order normative) | **ADJUDICATED** (`aa36d581`) — do not reopen |
| 9 | `mneme/architecture/adapter-protocol-0/AP0-ADOPTION-2026-07-18.md` | Adapter Protocol /0 | **ADOPTED with riders.** Rider 1 SATISFIED (`b7f70ed8`); **Rider 2 STILL BINDING** — see the claim ceiling |
| 10 | `CD0-POST-IMPLEMENTATION-RULING.md` (subject-tree root) | Canonical Datum /0 | **ADOPTED / frozen spec, post-implementation ruling on record** |
| 11 | `mneme/spec/CANONICAL-DATUM-SPEC.md` | CD/0 normative text | **ADOPTED** |
| 12 | `mneme/spec/POST-DE-CORROBORATIONE-PROGRAM-RULING.md` + `…-ERRATA-0.1.md` | the de-corroboratione program | **RULED** |

## III. Owner rulings under the advertised convention (`mneme/RULING-*.md`)

| # | document | decides | standing conferred |
|---|---|---|---|
| 13 | `RULING-author-2026-07-10-E3-capability-amendment.md` | the E3 capability amendment | amendment ruled |
| 14 | `RULING-obligation-second-inhabitant-2026-07-29.md` | Outcome B — **Language Obligation /0 NOT opened**; both obligation specimens frozen as published; the "second inhabitant" reopening is SPENT | abstraction **declined** |
| 15 | `RULING-capability1-arc-closure-2026-07-30.md` (`ab7df5bb`) | Capability /1 arc closure | **ACCEPTED (candidate)** |
| 16 | `RULING-capability2-acceptance-2026-07-30.md` (`57eac026`) | Capability /2 acceptance | **ACCEPTED (candidate)** |
| 17 | `RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md` (`31f9ba90`) | Adapter /0 closure; **AP0 Rider 1 SATISFIED**; AP-COST-1 Erratum 0.1 (ketiv/qere) | **ACCEPTED (candidate)**; Rider 2 still binding |
| 18 | `RULING-vertical0-closure-language-surface-2-2026-07-30.md` (`72b2c973`) | Vertical Specimen /0 accepted as published candidate, five limits docketed non-blocking; **opens Surface /2 by §5** | **ACCEPTED (candidate)**, SIGKILL-only ceiling |
| 19 | `RULING-integration-baseline-0-owner-ruling-and-work-order-2026-08-02.md` | **this milestone**; Surface /2 standing settled prospectively; Form /2 recorded candidate-by-default; latent-mvp fossil-marked; LCI/0 duplicate harness forbidden; naming affirmed | see §V |

## IV. Lane-level rulings and acceptances outside the convention

| # | document | lane | standing |
|---|---|---|---|
| 20 | `mneme/language-core-0/CORE-0-OWNER-ACCEPTANCE.md` | Language Core /0 | **ACCEPTED (candidate)** |
| 21 | `mneme/language-core-0/OWNER-RULING-TWO-DOORS-EVIDENCE-TEST.md` | the derive/perform two-door design | ruled |
| 22 | `mneme/language-core-0/CORE-0-CLOSURE.md` | Core /0 closure | closed lane |
| 23 | `mneme/language-slice-0/LANGUAGE-SLICE-0-CLOSURE.md` | Slice /0 | **CANDIDATE**, lane closed |
| 24 | `mneme/language-slice-1/SLICE1-SOL-DESIGN-RULING-FORKS.md` · `LANGUAGE-SLICE-1-CLOSURE.md` · `AUDIT-1-CLOSURE.md` | Slice /1 | **CANDIDATE**, lane closed |
| 25 | `mneme/language-slice-2/LANGUAGE-SLICE-2-DESIGN-RULING-0.md` · `-1.md` · `LANGUAGE-SLICE-2-ADOPTION-0.md` · `-CLOSURE.md` · `-CLOSURE-1.md` | Slice /2 | **CANDIDATE**, lane closed |
| 26 | `mneme/language-form-0/LANGUAGE-FORM-0-RULINGS.md` · `LANGUAGE-FORM-0-CLOSURE.md` | Form /0 | **CANDIDATE**, lane closed |
| 27 | `mneme/language-form-1/LANGUAGE-FORM-1-OWNER-RULINGS.md` | Form /1 | **CANDIDATE**, lane closed |
| 28 | *(none — no Form /2 ruling exists)* | Form /2 | **CANDIDATE-BY-DEFAULT**, recorded as such by ruling #19 |
| 29 | `mneme/language-surface-0/LANGUAGE-SURFACE-0-CLOSURE.md` | Surface /0 | **CANDIDATE**, lane closed |
| 30 | `mneme/language-surface-1/errata-0.3/` + `addendum-0.1/EVIDENCE-ADDENDUM-0.1.md` | Surface /1 | **CANDIDATE**, stranger-audited, repaired through Errata 0.3 + Evidence Addendum 0.1 |
| 31 | *(no `RULING-surface2-*.md` file exists)* | Surface /2 | **closed published candidate**, standing settled prospectively by ruling #19 |
| 32 | `mneme/lci0/spec/LCI0-POST-REVIEW-RULING.md` | LCI/0 spec | **ADOPTED spec**; conformance **blocked pending authorial closure** |
| 33 | `mneme/lci0/audit/evidence/final-status.txt` | the algebraic-law audit | **AUTHORIAL RULING REQUIRED** — 84 PASS, 4 preserved FAIL, unanswered |
| 34 | `mneme/latent-mvp/CLAUDE-REVIEW-RELAY-V1-CLOSURE-2026-07-13.md` · `V1-CLOSURE-TRACE-LEDGER-2026-07-13.md` | latent-mvp v1 | **FOSSIL** — historical stratum, retained with its historical floor |

## V. Standing settled by the 2026-08-02 owner ruling

- **Surface /2** — accepted **prospectively and exactly** as a **closed published candidate**
  at `3cd53351`, including Erratum 0.2. The ruling does **not** claim an earlier oral
  authorization necessarily covered Erratum 0.2, and that historical uncertainty **must not be
  rewritten**. No implementation adopted; no independent-validation language conferred.
- **Form /2** — published **candidate-by-default**; the ruling declining generic Language
  Obligation /0 remains fully in force.
- **`latent-mvp`** — **FOSSIL-MARK**: retained intact, removed as the `START HERE` path.
- **Language-A tranche-B** — archived now, adoption deferred; not merged.
- **Naming** — **the language is Lisp+; Mneme is its memory-and-continuity layer.**

## VI. Open demands on the owner (not closed by this milestone)

| demand | source | age at 2026-08-02 |
|---|---|---|
| the four LCI/0 preserved law failures | `mneme/lci0/audit/evidence/final-status.txt` | 18 days unanswered |
| the reserved primitive-minimization audit | `ARCHITECTURE-0-STATUS.md` §reserved seat | never commissioned |
| DK-1 channel policy (still `-DRAFT`) | `mneme/architecture/CHANNEL-POLICY-…-DRAFT.md` | unpaid rider |
| the `:redacted` enum rider | Architecture 0.1 | unanswered |
| Language-A scoring / null-semantics ruling | owner-locked | owner-locked, not project-blocked |

---

*Nothing in this index confers standing. It records where standing was conferred, and by whom.*
