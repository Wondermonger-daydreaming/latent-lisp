# GPT-KERNEL-0-ERRATA-OPEN-FORKS

**Status:** owner/two-chair decision docket — not governing  
**Date:** 2026-07-19  
**Parents:** GPT candidate `b0708a517e1ef985d0d78d4bed0bbf2fc3ef9fa96644d6549620e291826469b0` and Fable candidate
`b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34`

This file contains only decisions that cannot be resolved by editorial merging.

## FORK-1 — May outcome-axis `:bounded` contain one alternative?

### Option A — minimum cardinality two

Normative rule:

> An outcome-axis `:bounded` record contains at least two distinct complete alternatives.
> A singleton is either determinate under the named procedure or insufficiently licensed
> and therefore indeterminate/non-constructible.

Arguments:

- Kernel §7.2: determinate means evidence licenses exactly one current value.
- Kernel §7.3: bounded means evidence licenses one of the alternatives but does not
  establish which.
- With one exhaustive alternative, “which” is fixed and the two definitions collapse.
- A singleton-bounded escape encourages indefinite refusal to acknowledge determinate
  standing.
- It avoids smuggling a second, unrepresented “positive license versus eliminative
  license” axis into the three-mode algebra.

Cost:

- The live call-296 projection cannot yet be completed as a concrete outcome.
- The implementation must quarantine the historical singleton and use a synthetic
  bounded-manifestation fixture.

### Option B — singleton permitted as eliminative narrowing

Normative rule:

> A singleton `:bounded` set is exhaustive elimination without positive establishment of
> the survivor; no fold may promote it silently.

Arguments:

- §7.3 literally says finite and non-empty, not cardinality ≥2.
- §7.4 reserves indeterminate for absence of a lawful finite set.
- It keeps call-296 constructible without inventing a second alternative.
- It distinguishes direct positive verification from proof by elimination.

Cost:

- Under a closed exhaustive space, elimination to one is ordinarily establishment.
- The distinction requires an additional license semantics not currently represented by
  a durable field.
- The call-296 derivation still relies on eliminations not all licensed by captured
  evidence.

### GPT synthesis recommendation

**Choose Option A for outcome axes.**

Claim-level determinacy remains a separate library protocol and may be revisited if a
future design explicitly represents different proof/license modes.

**Owner disposition:** `A | B | MODIFY`

---

## FORK-2 — What becomes of call-296?

### Option A — preserve projection, refuse complete construction

- The §22/A0.1 bytes remain the canonical historical projection.
- They are not a complete Kernel outcome.
- No implementation may synthesize the missing alternatives.
- Full call-296 conformance remains excluded until an owner act:
  - supplies at least two complete alternatives;
  - establishes one value and changes concrete determinacy to determinate;
  - amends the absence-state vocabulary; or
  - explicitly adopts singleton-bounded semantics.

### Option B — derive the complete singleton

- Bind:
  `((:absent :state :absent-after-completion))`.
- Keep determinacy bounded.
- Record `:absence-state-name-presupposes-completion` as a bounded unknown.

### GPT synthesis recommendation

**Choose Option A.**

Fable's derivation eliminates `:present*`, withholding, and redaction chiefly from absence
of captured envelope/payload evidence. That supports “not constructible as present under
the current record,” but not the stronger claim that every other complete manifestation
alternative is exhaustively excluded. The completion-presupposition tension is evidence
that the closed vocabulary is missing a state, not evidence that the existing singleton
is complete.

**Owner disposition:** `A | B | MODIFY`

---

## FORK-3 — Include STATUS gaps 2 and 3 in this sitting?

### Option A — include

Add:

- `:attempt-indeterminate` and transition legality;
- exact schema/determinacy/global-scalar/interpretation-class condition types;
- historical blessing of the pure core's earlier generic condition use.

### Option B — split into a second tiny erratum

Keep the present artifact strictly to README gaps 1–4 and AP-G4.

### GPT synthesis recommendation

**Choose Option A.**

The commissioning text refers to “Kernel gaps 1–4,” then enumerates requirements drawn
from both ledgers and says “at minimum.” Leaving the two known STATUS gaps behind would
make Codex choose again during the same implementation phase. They are compact and
mechanically testable.

**Owner disposition:** `A | B`

---

## FORK-4 — Where does structural/semantic judgment class live?

### Option A — authoritative procedure descriptor

A procedure identity/version resolves to:

```lisp
(procedure-descriptor
  :procedure-id ...
  :version ...
  :judgment-class :structural|:semantic
  :input-domain ...
  :result-vocabulary (...)
  :evidence-requirements (...))
```

An outcome may cache the class, but it must match the descriptor.

### Option B — declaration only at the interpretation reference site

The outcome carries `:judgment-class`; no registry/descriptor is required.

### GPT synthesis recommendation

**Choose Option A.**

Reference-site-only classification allows the same procedure identity/version to be called
structural in one record and semantic in another. A small descriptor is not a general
registry; it is the minimum durable meaning of a `ProcedureId`.

**Owner disposition:** `A | B | MODIFY`

---

## FORK-5 — What is the Kernel stream relation?

### Option A — reference AP0 chunk records

```lisp
(:stream-relation
  :stream-id ...
  :relation-kind :direct-chunk|:aggregate|:projection
  :chunk-record-ids (...)
  :projection-receipt-id ...)
```

Sequence numbers, predecessors, finality claims, payload octet counts, persistence order,
and adapter identity remain in the AP0-owned chunk records.

### Option B — duplicate selected AP0 chunk fields into Kernel A.2

Embed sequence, predecessor, finality, constituent IDs, and aggregate receipt in the
manifestation record.

### GPT synthesis recommendation

**Choose Option A.**

It remains inspectable while avoiding two independently mutable copies of AP0's sequence
and finality truth. Kernel validates the relation and identity consistency; AP0 validates
the chunk values.

**Owner disposition:** `A | B | MODIFY`

---

## FORK-6 — Standing and origin after transformation

### Option A — new output is derived

- A genuinely new claim/representation gets new identity and origin `:derived`.
- The source claim's origin survives in provenance.
- Integrity never transfers automatically.
- Validation transfers only if its procedure scope explicitly covers the output relation.
- Visibility requires a new scoped record.

### Option B — output keeps source origin

Fable's candidate says origin persists under copying/transformation.

### GPT synthesis recommendation

**Choose Option A.**

Architecture 0.1 says origin records name the transforming mechanism and includes
`:derived`. “Origin is historical” prevents validation from rewriting a claim's own
history; it does not make a transformed output pretend it was directly observed or
asserted in the same act as its source.

A byte-identical alias to the same claim identity is not a transformation and therefore
does not create a new origin problem.

**Owner disposition:** `A | B | MODIFY`

---

## FORK-7 — Erratum beside the spec or immediate reissue?

### Option A — ride beside

- Adopt a checksum-bound erratum without editing the sealed Kernel /0 bytes.
- Fold it into `LISP-PLUS-FREEZE-CANDIDATE-0` after implementation evidence and stranger
  review.

### Option B — reissue Kernel /0 now

- Produce a new governing complete spec and new hashes before Codex begins.

### GPT synthesis recommendation

**Choose Option A.**

It preserves the adopted text and the exact correction history while allowing
implementation to start. The first freeze candidate is the natural point for a clean
integrated reissue.

**Owner disposition:** `A | B`

---

## Decision summary

| Fork | GPT recommendation | Severity |
|---|---|---|
| 1 singleton bounded | A — minimum two | constitutional |
| 2 call-296 | A — non-constructible projection | constitutional |
| 3 fold-ins | A — include | implementation |
| 4 procedure class | A — descriptor | implementation/standing |
| 5 stream relation | A — references | boundary ownership |
| 6 transformed origin | A — derived output | claim standing |
| 7 adoption form | A — ride beside | process |

No final synthesis should be called adoption-ready while FORK-1 and FORK-2 lack explicit
dispositions.
