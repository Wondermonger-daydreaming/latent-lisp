# EXPECTED-FAILURES — de-praemissis (PRE-REGISTRATION)

*Written 2026-07-23 by STRUCTOR (CC seat, Opus 4.8) **BEFORE the first execution
of SPECIMEN.lisp or ABLATION.lisp.** The code was authored; then this file was
frozen; only then were the programs run and RUN-RECEIPT.txt captured. These are
predictions, not transcriptions. Any divergence at run time is reported in the
final report, not silently reconciled here.*

Schema under test: `:artifact-admissibility` v1. Conclusion pattern
`(:predicate :artifact-admissible (:artifact ?art) (:receiver ?rcv) (:purpose ?pur))`.
Required premises (conjunctive): `digest-matches` · `signature-valid` ·
`receiver-recognizes-signer` · `provenance-admissible`. Schema-locals
`:dig :sig :key :signer`.

## The twelve behaviors — expected disposition / decision / receipt content

| # | Scenario | Expected receipt decision | Expected per-premise disposition (receipt) |
|---|----------|---------------------------|--------------------------------------------|
| 1 | digest support only | `:refused` | digest-matches `:satisfied`; signature-valid, receiver-recognizes-signer, provenance-admissible all `:missing` |
| 2 | digest + signature | `:refused` | digest, signature `:satisfied`; recognition, provenance `:missing` |
| 3 | digest + signature (read the signature premise) | `:refused` | signature-valid `:satisfied` **beside** recognition `:missing` — a valid signature is not contaminated by a missing sibling |
| 4 | digest + signature + provenance, no recognition | `:refused` | recognition assessment names premise `:receiver-recognizes-signer` with disposition `:missing` (NAMED, not a generic boolean fail); strongest-lawful-result is a `:blocked-on` on recognition |
| 5 | conclusion for receiver-**b**, recognition support names receiver-**a** (provenance for b) | `:refused` | recognition `:mismatched`, conflicting roles exactly `(:receiver)` |
| 6 | conclusion `:production`, provenance support is `:staging` | `:refused` | provenance `:mismatched`, conflicting roles exactly `(:purpose)` |
| 7 | conclusion artifact-1, digest support is for artifact-2 | `:refused` | digest `:mismatched`, conflicting roles exactly `(:artifact)` |
| 8 | full supports, recognition witness NOT in receiver-context accessible-supports | `:refused` | recognition `:inaccessible` — `matching-inaccessible-supports` non-empty, `matching-accessible-supports` empty; distinct from `:missing` |
| 9 | full supports **plus** a refutation of the provenance proposition | `:refused` | provenance `:refuted` — `matching-accessible-supports` (positive) AND `refuting-supports` BOTH non-empty; neither erased |
| 10 | full coherent supports, all four premises match | `:granted` | all four `:satisfied`; a real Slice /0 promotion — `claim-judgment` is a judgment-record with `:verified`, procedure version 1 |
| 11 | digest + signature (2 satisfied, 2 unsatisfied) | `:refused` | `render-derivation-why` text names ALL FOUR premises and both the words `SATISFIED` and `MISSING`; `why` façade returns the receipt itself |
| 12 | derive at receiver-a (grant), then target receiver-b | see below | receiver-a `:granted` (receipt id A). Target with no local recognition ⇒ `:refused` (recognition `:missing`). Target given its OWN recognition ⇒ `:granted` (receipt id B). **id A ≠ id B.** |

**Falsifier for the hypothesis:** if ANY behavior 1–9 or 11 returns `:granted`,
or behavior 10/12-grant returns `:refused`, or a `:missing` premise silently
converts to a granted conclusion, the hypothesis is refused and the run is a
failure (nonzero exit). A `:missing` treated as false (i.e. as `:refuted`) or an
`:inaccessible` collapsed to `:missing` is likewise a failure.

## Specimen-level teeth (charter §11b, beyond the substrate selftest)

These are the two §11b plants that live at specimen (not substrate) level:

- **Derivation receipt copied as direct support for the conclusion ⇒ refused.**
  Behavior 12(a): the receipt from the receiver-a grant is transported via
  `transported-testimony` (yielding `:mode :testimony :kind :derivation-report`)
  and offered as support for the conclusion at a second context through the
  derivation-keyed conclusion procedure.
  **Expected:** the frozen Slice /0 `raise` refuses. **Predicted gate (to be
  confirmed at run):** `WRONG-PROPOSITION-SUPPORT` fires FIRST, because the
  testimony's `:for` is the attribution `(:asserted CONTEXT-A (:predicate
  :derived …))`, not the conclusion proposition — so the frozen proposition-match
  gate rejects it before the admits gate is reached (CHARTER-DELTA Errata §4).
  The admits gate `%procedure-admits-p` would refuse it independently (a
  `(:testimony :derivation-report)` support is not the `(:derivation …)` key the
  procedure admits) — that independent refusal is proven by substrate T10/T11.
- **Projection-copy plant ⇒ impossible through the governed path.** Behavior 12
  as a whole: a derived conclusion cannot cross to a second receiver by status
  copy. **Enforcement named:** (1) receiver-relativity is enforced by *binding
  coherence* — a `receiver-recognizes-signer` support bound to receiver-a lands
  `:mismatched`/`:missing` against a receiver-b conclusion, so the target cannot
  inherit the source's recognition; (2) the only support that discharges the
  conclusion at the target is a `(:derivation (:schema :artifact-admissibility
  1))` witness minted by the TARGET's own governed `derive`; a transported
  receipt is testimony and is refused at the frozen gate (tooth above). Therefore
  reconstruction — a target-side `derive` over target-lawful premises — is
  mandatory, and it carries a fresh receipt identity per attempt (id A ≠ id B).

## Ablation — expected S3 reproduction

The ablation collapses to one opaque proposition
`(:predicate :artifact-admissible (:artifact "artifact-1"))` promoted by a generic
content procedure admitting `(:direct :digest-evidence)` and
`(:direct :signature-evidence)`. Two content witnesses (digest, signature) are
offered; **no recognition witness exists — recognition is unrepresentable in the
opaque model.**

**Expected:** the frozen Slice /0 `raise` GRANTS — `claim-judgment` is a
judgment-record with `:verified`. Admissibility is verified from digest +
signature content alone, with signer recognition never represented and never
checked. This is the ablation SUCCEEDING at being wrong: **the S3 species
reproduced exactly.** Epitaph line printed verbatim, exit 0. If the ablation had
REFUSED, the ablation would have failed to reproduce S3 and the specimen's
contrast would be unproven.

## Baseline — expected convention gap

`admit-artifact` (disciplined) refuses recognition-absent evidence and NAMES
`:receiver-recognizes-signer` as missing. `admit-artifact-fast` (a second
author's straight-line variant) returns `:granted` on the SAME evidence with the
recognition check simply absent — and its return value is indistinguishable from
a disciplined grant. **Expected:** both hold; the gap (guarantee enforced by
nobody) is shown; exit 0. This is the convention that Slice /1's declared anatomy
converts into enforcement.
