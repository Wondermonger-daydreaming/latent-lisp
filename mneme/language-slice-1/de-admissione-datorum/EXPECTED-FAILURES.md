# EXPECTED-FAILURES — de-admissione-datorum (PRE-REGISTRATION)

*Written 2026-07-23 by STRUCTOR-II (CC seat, Opus 4.8) **BEFORE the first
execution of SPECIMEN.lisp, MULTIPLICITY.lisp, ABLATION.lisp, or BASELINE.lisp.**
All four programs were authored; then this file was frozen; only then were the
programs run and RUN-RECEIPT.txt captured. These are predictions, not
transcriptions. Any divergence at run time is reported in the final report, not
silently reconciled here.*

Schema under test: `:dataset-admissibility` v1. Conclusion pattern
`(:predicate :dataset-admissible (:dataset ?dataset) (:receiver ?receiver) (:purpose ?purpose))`.
Six required premises (conjunctive), ORDERED — `:measured-by` precedes
`:calibration-valid` so the schema-local `?instrument` is bound before calibration
is assessed (errata-3 threading): `schema-conformance` · `measured-by` ·
`calibration-valid` · `missingness-within-bound` · `population-suitable` ·
`purpose-permitted`. Schema-locals `:schema :instrument :certificate :bound`.

## The fourteen behaviors — expected disposition / decision / receipt content

| # | Scenario | Expected decision | Expected per-premise disposition |
|---|----------|-------------------|----------------------------------|
| 1 | schema-conformance support only | `:refused` | schema-conformance `:satisfied`; measured-by, calibration-valid, missingness, population, purpose-permitted all `:missing` |
| 2 | schema + missingness, calibration absent | `:refused` | schema, missingness `:satisfied`; calibration-valid NAMED `:missing` |
| 3 | measured-by declares instrument-b; calibration cert is for instrument-a | `:refused` | measured-by `:satisfied` (binds ?instrument=instrument-b); calibration-valid `:mismatched`, conflicting roles exactly `(:instrument)` |
| 4 | conclusion `:causal`, population-suitable support is `:descriptive` | `:refused` | population-suitable `:mismatched`, conflicting roles exactly `(:purpose)` |
| 5 | conclusion `:causal`, purpose-permitted support is `:descriptive` | `:refused` | purpose-permitted `:mismatched`, conflicting roles exactly `(:purpose)` |
| 6 | conclusion dataset-2, schema-conformance support is for dataset-1 | `:refused` | schema-conformance `:mismatched`, conflicting roles exactly `(:dataset)` |
| 7 | conclusion receiver-r2, purpose-permitted support names receiver-r1 | `:refused` | purpose-permitted `:mismatched`, conflicting roles exactly `(:receiver)` |
| 8 | full supports, calibration witness NOT in receiver-context accessible-supports | `:refused` | calibration-valid `:inaccessible` — accessible-count 0, inaccessible-count 1; distinct from `:missing` |
| 9 | full supports **plus** a refutation of the calibration proposition | `:refused` | calibration-valid `:refuted` — matching-accessible (positive) AND refuting-supports BOTH non-empty; neither erased |
| 10 | full coherent supports, all six premises match | `:granted` | all six `:satisfied`; a real Slice /0 promotion — `claim-judgment` is a judgment-record with `:verified`, procedure version 1 |
| 11 | schema + measured-by (2 satisfied, 4 unmet) | `:refused` | `render-derivation-why` text names ALL SIX premises and both `SATISFIED` and `MISSING`; `why` façade returns the receipt itself |
| 12 | derive at receiver-a (grant), then target receiver-b | see below | receiver-a `:granted` (id A). Target with no local purpose-permitted ⇒ `:refused` (purpose-permitted `:missing`). Target given its OWN permission ⇒ `:granted` (id B). **id A ≠ id B.** |
| 13 | transport the receiver-a receipt as testimony; offer it to a derivation-keyed conclusion procedure at a second context | frozen refusal | transported support is `:mode :testimony :kind :derivation-report`; the frozen Slice /0 `raise` REFUSES (a `slice0-condition`). **Predicted gate: `WRONG-PROPOSITION-SUPPORT`** fires first (testimony `:for` is the attribution, not the conclusion). Reported by name at run. |
| 14 | register `:dataset-admissibility` v2 (extra `:retention-policy-satisfied` premise); offer a v1-keyed derivation witness to a v2-keyed procedure | frozen refusal | v1 admit-key ≠ v2 admit-key; the frozen admits gate REFUSES. **Predicted gate: `INSUFFICIENT-SUPPORT-KIND`** (witness `:for` = conclusion, so proposition-match passes; the version gate fires). Reported by name at run. |

**Falsifier for H1:** if ANY behavior 1–9, 11, 13, 14 returns `:granted` (or the
frozen gate fails to refuse in 13/14), or behavior 10/12-grant returns `:refused`,
or a `:missing` premise silently converts to a granted conclusion, H1 is refused
and the run is a failure (nonzero exit). A `:missing` treated as `:refuted`, or an
`:inaccessible` collapsed to `:missing`, is likewise a failure. Behavior 3
`:granted` (a cross-instrument calibration discharging an instrument-b-bound
premise) specifically falsifies the transfer's central NEW closure.

## MULTIPLICITY — the plurality experiment (own run, own predictions)

Calibration premise carries schema-local `?certificate`. Two calibration supports
for the SAME instrument (instrument-a), differing only in `:certificate`, bind
`?certificate` two ways ⇒ two distinct coherent binding environments over one
premise.

- **CASE A (redundant sufficiency)** — certs `cert-1`, `cert-2`, each alone
  sufficient. **PRE-REGISTERED PREDICTION (errata 3, EXPLICIT): calibration-valid
  `:ambiguous`, overall `:refused` — plurality read as doubt (Outcome R).** A
  `:satisfied`/`:granted` outcome (plurality preserved, "grant-with-plurality")
  would **FALSIFY this errata-3-derived prediction and is itself a publishable
  finding** (Outcome G) about the substrate; the run stays exit 0 either way (the
  experiment records what the semantics DID).
- **CASE B (incompatible authority)** — certs `cert-vendor`, `cert-self-signed`,
  coherent bindings implying materially different provenance, no schema
  discriminator. **PREDICTION: `:ambiguous`, `:refused`** — this one SHOULD refuse.

**Verdict prediction:** the substrate does **NOT** distinguish Case A from Case B —
both land `:ambiguous` identically, with no discriminating field. If confirmed, the
program prints `MULTIPLICITY FINDING: multiple-sufficient-proofs and
unresolved-semantic-choice are CONFLATED under current :ambiguous law` and
enumerates (without implementing) the three permitted minimal repair shapes:
grant-preserving-all-environments · refuse-only-semantic-incompatibility ·
schema-level uniqueness-discriminator flag. A DIFFERING pair of dispositions would
falsify the conflation prediction (itself publishable). Exit 0 regardless — the
finding is the success.

## Ablation — expected flattened-species reproduction

The ablation collapses to one opaque proposition
`(:predicate :dataset-valid (:dataset "dataset-1"))` promoted by a generic content
procedure admitting `(:direct :schema-evidence)` and `(:direct :missingness-evidence)`.
Two content witnesses (schema, missingness) are offered; **no calibration,
population, or permission witness exists — each is unrepresentable in the opaque
model.**

**Expected:** the frozen Slice /0 `raise` GRANTS — `claim-judgment` is a
judgment-record with `:verified`. Admissibility is verified from schema +
missingness content alone, with measurement-validity, population-suitability, and
permitted-purpose never represented and never checked. This is the ablation
SUCCEEDING at being wrong: **the flattening species reproduced exactly.** Epitaph
printed verbatim, exit 0. If the ablation had REFUSED, it would have failed to
reproduce the species and the specimen's contrast would be unproven.

## Baseline — expected convention gap

`admit-dataset` (disciplined) refuses population-absent evidence and NAMES
`:population-suitable` as missing. `admit-dataset-fast` (a second author's
straight-line variant) returns `:admissible` on the SAME evidence with the
population-suitability check simply absent — its return value indistinguishable
from a disciplined grant. **Expected:** both hold; the gap (guarantee enforced by
nobody) is shown; exit 0. This is the convention Slice /1's declared anatomy
converts into enforcement.

— STRUCTOR-II, Claude Opus 4.8 (1M context)
