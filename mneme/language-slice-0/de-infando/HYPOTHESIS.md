# DE-INFANDO — specimen hypothesis (WORK-ORDER-0 admission rule, R4)

**Third and final official Slice /0 specimen**, under the R3 ceiling
(verbatim in WORK-ORDER-0 §100–109): no hostile same-image custody, no
debugger resistance, no cryptographic confinement, no secrecy claim against
arbitrary Common Lisp introspection. Substrate:
`../slice0-transmissibility.lisp` on the settled promotion + projection
algebra.

## 1. Linguistic hypothesis

> Lisp+ can represent reifiability, transmissibility, testimony,
> reproducibility, and exercisability as distinct relations. A locally
> valid value or support object may be usable without being serializable or
> exportable, and its failure to travel must not be confused with absence,
> invalidity, secrecy, or universal impossibility.

The axes are **orthogonal to evidential standing** and to each other — no
grade, no scalar ladder. Reifiability is decided by the canonical boundary
itself (`require-canonical` accepts or refuses; a closure is refused —
verified live before design). Nothing is ever stringified to pass.

## 2. Observable misuse / failure mode

The ordinary implementation: stringifies the closure and ships the string
as the value; collapses five axes into one `:exportable` flag; records
testimony as execution evidence; treats holding a derived result as holding
its producer; `remove-if`s the non-exportable so the remote inventory shows
it never existed; copies a local truth-flag to the receiver. Each is one
idiomatic line (`BASELINE.lisp`, moves i–vi).

## 3. Ablation (one mechanism)

**Collapse reifiability, transmissibility, and testimony into one
`:exportable` boolean** (`ABLATION.lisp` — the work order's preferred). The
closure and contexts remain; `transmit*` asks only "does it print?", and
the printer always says yes: the description ships as the value, testimony
ships as the deed, the product ships as the producer, and the vocabulary of
residue ("locally real, not carryable") becomes unsayable — the refusal
branch is unreachable.

## 4. Comparative baseline

`BASELINE.lisp` (FABER-CL-III, Opus 4.8, written blind to the substrate) —
good-faith closure discipline with an `export-value` guard, honest
alternative acts, then the six drift moves, closing on its own earned
limit: *"the gate held HERE, and 'here' is precisely the word that does not
serialize."*

## 5. The six lawful acts the specimen must distinguish

1. exporting the closure itself — **refused** (`value-not-reifiable`);
2. exporting a canonical result it produced — granted, producer explicitly
   not included;
3. exporting testimony that it was exercised — granted as the second-order
   attribution only;
4. exporting a reproduction recipe — granted as data, equivalence ≠
   identity;
5. a designated local invocation — `exercise-value`, authorization-gated,
   grants use, never possession;
6. receiver-local minting of equivalent support — lawful repair; the
   proposition verifies at the receiver though the object never traveled.

Tests I1–I12 + teeth-1..6 + negative control in `SPECIMEN.lisp`.

— Claude Fable 5 (CC seat), 2026-07-23
