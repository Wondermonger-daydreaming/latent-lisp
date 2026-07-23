# CHARTER DELTA /2 — the multiplicity ruling (owner-adopted)

*2026-07-23, fourth sitting. Owner ruling, verbatim law adopted; this delta
supersedes CHARTER-DELTA-1 Δ1's ambiguity clause and Errata 3's threaded
refusal-on-plurality, and licenses the substrate revision that implements it.
The original MULTIPLICITY experiment and its finding are HISTORY — preserved in
`de-admissione-datorum/MULTIPLICITY.lisp` + `RUN-RECEIPT.txt` and commit
`50a94ad6`; nothing rewrites them.*

## The adopted ruling

```lisp
(:slice-1-multiplicity
 :complete-environment-semantics :existential
 :default-multiple-complete-environments :grant-and-preserve-all
 :ambiguity :only-from-declared-uniqueness-constraint
 :implicit-domain-discriminator :forbidden
 :environment-selection-by-order :forbidden)
```

> **Plurality is evidence. Ambiguity begins only where the schema has declared
> that a choice matters.**

And the ruling's second edge, equally binding: the original Case B was itself a
**hidden-anatomy problem** — `"cert-vendor"` vs `"cert-self-signed"` were
declared materially incompatible in *prose* while no role or constraint
represented the incompatibility. **Lisp+ must not infer semantic
incompatibility from suggestive names.** Incompatibility enters only through
declared anatomy.

## Governing law (executable reading)

When ≥1 coherent complete binding environments discharge every declared premise
for the same exact ground conclusion: the conclusion is **grantable**; **every**
complete environment is preserved in the derivation receipt; plurality alone is
NOT ambiguity; no environment is selected by traversal order; incomplete /
mismatched / inaccessible environments stay represented but do not defeat
complete ones (refutation law unchanged — a refuted premise still blocks).

`:ambiguous` arises ONLY when: the schema declares ≥1 schema-local
**uniqueness-bearing** (`:unique-locals`), AND >1 distinct value for a
uniqueness-bearing local survives across otherwise-complete coherent
environments, AND no declared discriminator resolves it (and in Slice /1 there
ARE no discriminators — see below).

## Minimal schema extension

One bounded field: **`:unique-locals (<kw>…)`**, default `()`. Schema-locals
remain existential unless listed. Validation (all typed refusals at schema
construction): every unique local ∈ `:locals` · conclusion variables may NOT be
listed (already ground-bound) · duplicates refuse · unknown variables refuse ·
the declaration is immutable and defensively copied (AUDIT-1 repair-2
discipline applies to its reader) · **no comparator callback, predicate, or
host function may be installed as a discriminator** — this is not a general
proof algebra.

## Implementation consequence (supersedes Errata 3's threading)

The evaluator must enumerate **complete environments** across all premises
(finite, deterministic, pattern-against-ground as before) instead of refusing at
the first premise-local plurality. Threading as an *optimization* may remain
only where it cannot change the environment set. A premise-local plurality on a
NON-unique local is not a refusal condition anywhere.

## Receipt refinement (minimal — no redesign, no scalar proof-strength)

Two fields (or equivalent narrow extension):
`:complete-binding-environments` (all complete coherent environments) ·
`:uniqueness-conflicts` (per conflicting unique local: the local + the surviving
values + the environments carrying them). The receipt must make these four
situations distinguishable: one sufficient derivation · multiple sufficient
derivations · multiple derivations violating declared uniqueness · no complete
derivation. Decision stays binary granted/refused. A derived VIEW (e.g.
`:multiply-supported`) is permitted; **no seventh premise status.**

## The repaired experiment (three cases; original preserved as history)

- **Case A** (redundant sufficiency, non-unique `?certificate`): GRANT; both
  environments preserved; premise `:satisfied`; no canonical environment.
- **Case B** (explicit uniqueness conflict): the material distinction becomes
  ANATOMY — an `:authority` role (`:recognized-vendor` vs `:self-signed`) with
  `:unique-locals (:authority)` ⇒ REFUSE `:ambiguous`; both environments
  preserved; the receipt names `?authority` as the conflict; certificate
  plurality itself is NOT the conflict.
- **Case C** (hidden incompatibility stays hidden): original schema, no
  authority role, no uniqueness ⇒ GRANT with both environments + the explicit
  statement that the language cannot enforce an incompatibility absent from
  declared anatomy. **Case C is the claim ceiling made executable:** declared
  anatomy can be enforced; undeclared domain distinctions cannot be divined.

## Required multiplicity teeth (M1–M12)

1. two sufficient non-unique environments GRANT · 2. all sufficient
environments in the receipt · 3. support order changes neither decision nor
environment set · 4. duplicate identical support does not invent a second
derivation · 5. two distinct supports yielding the SAME binding stay visible as
multiple supports without becoming ambiguity · 6. conflict on a declared unique
local REFUSES · 7. conflict on a non-unique local does NOT refuse · 8. an
undeclared local in `:unique-locals` refuses schema construction · 9. mutating
the unique-locals declaration cannot revise registered schema behavior · 10. a
hidden prose-only incompatibility is NOT inferred (Case C as a tooth) · 11.
refuting support still blocks under the existing law · 12. irrelevant
incomplete environments do not defeat a complete lawful one.

**Existing teeth affected:** substrate T6 (built ambiguity from undeclared
plurality — under this law that case GRANTS) must be revised to declare
`:unique-locals`; its old expectation is superseded by this delta, recorded
here as the warrant. The historical `MULTIPLICITY.lisp` gets a 3-line
HISTORICAL header (body untouched; its receipt and commit preserve the original
finding) and leaves the regression battery.

— fourth sitting, Claude Fable 5 (CC seat); owner ruling adopted verbatim
