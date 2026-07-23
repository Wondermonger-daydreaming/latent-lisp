# LANGUAGE SLICE /1 — CLOSURE

*2026-07-23, fourth sitting. Custodian: Claude Fable 5 (CC seat). Slice /1 closes
with this document; the guide, API brief, and architecture record accompany it.
Slice /0 remained byte-frozen throughout the entire slice. Slice /2 is not
opened by anything here.*

---

## Disposition

```lisp
(:language-slice-1
 :structured-ground-propositions      :earned    ; canonical normal form; T1-T3; every program
 :proposition-patterns                :earned    ; separate representation; (:var …) reserved; (:quoted-datum …) escape
 :exact-versioned-judgment-schemas    :earned    ; (name, version) exact; no auto-latest; collision-free key (AUDIT-1)
 :deterministic-finite-matching       :earned    ; pattern-against-ground; order-independent environment sets (M3)
 :declared-premise-enforcement        :earned    ; S3 closed via the FROZEN slice0 admits gate, when anatomy declared
 :structured-premise-assessments      :earned    ; eight-field assessments; six dispositions; seven-law order
 :derivation-receipts                 :earned    ; issued on EVERY attempt; no boolean summary; mutation-safe readers
 :slice0-integration                  :earned    ; promotion (raise), projection (re-derivation), testimony, why
 :plurality-preserved                 :earned    ; multiple sufficient derivations GRANT with all environments (Delta-2)
 :declared-uniqueness                 :earned    ; :unique-locals; ambiguity ONLY from declared choice
 :s3-regression                       :closed-when-schema-declared   ; the ceiling IS the value
 :automatic-premise-discovery         :not-earned
 :ontology-inference                  :not-earned
 :general-theorem-proving             :not-earned
 :host-level-closure                  :not-earned  ; stratum-3 D-forge acknowledged open by design
 :discriminator-callbacks             :not-earned  ; forbidden by the multiplicity ruling
 :proof-ranking                       :not-earned  ; no scalar strength anywhere
 :probabilistic-evidence              :not-earned
 :production-qualification            :not-earned)
```

## Governing ceilings (travel with every citation)

1. **Declared anatomy can be enforced; undeclared domain distinctions cannot be
   divined.** Case C of the repaired multiplicity experiment is this ceiling
   made executable: prose-only incompatibility is not inferred.
2. **Enforcement is conditional on declaration.** Both ablations still grant
   their flattened conclusions — a program that declines the anatomy remains
   free to be faithfully wrong. That is the claim ceiling working, not a hole.
3. **Same-image host escape stays open** (hand-built derivation witness without
   `derive`) — acknowledged stratum-3 boundary, inherited from Slice /0's
   four-strata doctrine, repair refused on principle (AUDIT-1-CLOSURE).
4. **The audit lineage ceiling**: LIMES-II was fresh-context but same-family;
   hostile coverage, not fresh-weights corroboration.

## Designs killed, and their killers

| Killed design | Killer |
|---|---|
| **Opaque atomic derived proposition** | both ablations — de-praemissis ("signer recognition was never represented … the S3 species reproduced exactly") and de-admissione-datorum ("calibration, population-suitability, and permitted-purpose were never represented … the flattening species reproduced exactly") |
| **One-status premise summary** | the owner's Δ2 ruling + the structured `premise-assessment` — simultaneous facts (satisfied-beside-refuting, inaccessible-beside-mismatched) proved necessary by specimen behaviors 3/8/9 in both domains |
| **Multiple proofs ≡ ambiguity** | the conflation finding (historical `MULTIPLICITY.lisp`, commit `50a94ad6`) + the owner multiplicity ruling (CHARTER-DELTA-2) — plurality is evidence; Case A now grants with both environments |
| **Implicit semantic incompatibility from opaque values** | the ruling's Case-B critique — "cert-vendor" vs "cert-self-signed" were incompatible only in prose; incompatibility now enters solely through declared anatomy (`:authority` role + `:unique-locals`) |
| *(superseded intermediate)* premise-threaded refuse-on-plurality | CHARTER-DELTA-1 Errata 3 → CHARTER-DELTA-2 environment enumeration |

## Public surface admitted (evidence-based; the smoke program is the warrant)

Governed forms: **`proposition` · `proposition-pattern` · `judgment-schema` ·
`derive`** (constitutive in both domains and the smoke). Acts/registry:
`register-schema`, `resolve-schema`, `clear-schema-registry`,
`transported-testimony`, `why`/`render-derivation-why`. Supporting types +
inspectors: `derivation-receipt` and `premise-assessment` with their
defensively-copying readers; `refutation`; the condition family +
`slice1-condition-receipt`; view `derivation-receipt-multiply-supported-p`;
`judgment-schema-admit-kind` (implementation-forced encoding, but exercised by
two shipped programs as the front-door transport-probe key). Internal: the
registry table, all `%`-helpers, the raw `*why-extractors*` seam (one licensed
`::`, SLICE0-DEFECT-RECEIPT-1). The **22** unexercised readers (live-measured
by SCRIBA-II's usage scan; the earlier "~30" was an estimate) ship as
**deliberate introspection surface**, so labeled in the API brief — no
generated-accessor barge exists (every public reader is a hand-written
copy-disciplined wrapper; FUMUS audit).

## Final validation (all run this sitting, custodian's hand)

| Run | Result |
|---|---|
| kernel0 selftest | 33 passed / 0 failed / 59 mutants killed |
| Slice /0 SMOKE | 6 ok, 0 failed |
| Slice /0 specimens | de-promotione 19/0 · de-projectione-1 17/0 · de-infando 30/0 |
| Slice /1 substrate selftest | **50 passed, 0 failed** (T1–T17 + M1–M12) |
| de-praemissis | 12/12 + ablation epitaph |
| de-admissione-datorum | 14/14 + ablation epitaph |
| repaired multiplicity | A granted+plural · B ambiguous-by-declaration · C granted (ceiling held) |
| public smoke SMOKE-1 | 9/9, 0 failed |
| static audit | zero `::` across all specimen/smoke programs; the licensed seam only in substrate/selftest |

## Successor pressures (ranked, NON-GOVERNING — no Slice /2 is opened)

1. **Public `why`-extractor registration in Slice /0** (errata-cycle candidate)
   — the one licensed `::` exists solely because the seam is unexported
   (SLICE0-DEFECT-RECEIPT-1); the cleanest debt in the system.
2. **Stranger implementation /2 against the Slice /1 surface** — the guide/API
   were written under Slice /0's teachability discipline; whether a
   lineage-distant stranger can compose schemas and read plurality receipts is
   an open empirical question (the strongest test of this closure's documents).
3. **Structured-proposition adoption pressure on Slice /0's own acts** —
   testimony `(:asserted S P)` and projection public-forms now routinely carry
   structured P; whether Slice /0's opaque-P discipline should be revisited is
   recorded, not urged.
4. **Schema-vs-procedure identity domain** (deferred AUDIT-1 note) — becomes
   real only if a future slice keys a gate on identity.
5. **Negation/chaining/disjunction** — no observed pressure in either domain;
   empty pressure is a lawful result.

## The sentence this slice earned

Slice /0 taught claims to move without lying about their standing. Slice /1
taught conclusions to show their anatomy — and taught the language the
difference between a conclusion supported twice and a conclusion torn between
two worlds. **Plurality is evidence. Ambiguity begins only where the schema has
declared that a choice matters.**

རྫོགས་སོ — it is complete; and also, it continues: closed, with its successor
pressures named and none begun.

— Claude Fable 5 (CC seat), custodian, 2026-07-23
