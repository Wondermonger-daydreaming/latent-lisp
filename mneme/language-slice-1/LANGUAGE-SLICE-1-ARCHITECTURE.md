# Lisp+ Slice /1 — Architecture Record

*The design as it stands at closure, with the evidence that shaped it and the
designs it killed. Governing law: `LANGUAGE-SLICE-1-CHARTER.md` +
`CHARTER-DELTA-1.md` (+Errata) + `CHARTER-DELTA-2.md`, as sized by `AUDIT-1.md` /
`AUDIT-1-CLOSURE.md`. Specimen evidence: `de-praemissis/`,
`de-admissione-datorum/`. Slice /0 and kernel0 are frozen dependencies, loaded
but never edited.*

## 1. The constitutive evidence — Stranger /1's S3 counterfeit

Slice /1 exists because a fresh, lineage-distant stranger, handed only Slice /0's
Guide and API, wrote an idiomatic program that **granted an admissibility its
evidence did not hold** (`stranger-implementation-1/CUSTODIAN-RESULT-1.md` §4,
seat `qwen/qwen3.6-plus`, verified on disk):

> Signature-validity was never distinguished from signer-recognition in any
> granted act … the endpoint claim's proposition `(:artifact-admissible …)` is an
> opaque atomic token whose task-defined meaning includes a conjunct no granted
> act ever held.

No false *sentence* was ever printed — the receipts were honest. The counterfeit
was **by omission at the domain layer**: a seven-conjunct admissibility flattened
to a two-conjunct promotion, with recognition never represented. The custodian's
ceiling, which this slice must never over-quote:

> The S3 counterfeit does not weaken Slice /0's banked verdicts … it maps where
> the language's *current* proposition surface lets a competent stranger flatten a
> domain.

The architecture's §9 already named atomic propositions a temporary limitation.
Slice /1 supplies the **anatomy** the stranger's opaque token lacked — and nothing
stronger. Its binding ceiling: *enforce declared premises; discover none.*

## 2. Normal-form propositions — normalization, not a record type

A structured proposition is `(:predicate <keyword> (<role-keyword> <value>) …)`,
canonical Slice /0 data — **not a new record type.** Roles are unique and **sorted
at construction** by `STRING<` on `SYMBOL-NAME`; every value is deep-copied at the
one construction chokepoint (`%normal-form`). This dissolves INVENTORY blocker B1
(role-order insensitivity) into the frozen `EQUAL` on normal forms without
touching Slice /0, and makes backward compatibility **by construction**: every
structured proposition already flows through `claim`, `witness :for`, testimony
`(:asserted S P)`, and projection. Atomic Slice /0 propositions stay lawful; bare
symbols/floats/dotted lists still refuse at the frozen boundary gate. Equality is
`structured-proposition=` ≙ `EQUAL` on normal forms (the frozen `proposition=` is
not widened).

## 3. Two-class variables, ground vs pattern

Variables exist; unification does not (charter §4, Δ1). A variable is the
canonical form `(:var <keyword>)` — bare `?x` cannot cross the boundary, so the
marker is itself canonical data. Two construction paths (Δ5):

- **`proposition`** — GROUND: refuses any `(:var …)` anywhere; usable as claim /
  support / refutation; always normal-form canonical data.
- **`proposition-pattern`** — PATTERN: may carry declared variables; a distinct
  struct, **unusable as ground** by construction.

`(:var …)` is **reserved globally** in Slice /1 proposition syntax; the literal
escape is **`(:quoted-datum <form>)`** — a ground node whose payload (var-shaped
or not) is compared literally and never interpreted. So ordinary data can never
acquire variable meaning by accident: ground refuses raw `(:var …)`, patterns
interpret it, `(:quoted-datum …)` quotes it. Matching is **pattern-against-ground
only** — structural walk, exact equality at every non-variable position,
first-binding-then-consistency for variables; no var-var unification, no
backtracking, no rule chaining.

Two variable classes (Δ1): **conclusion variables** (bound from the ground
conclusion before any premise matching; an unbound one at derive time refuses) and
**schema-local variables** (declared `:locals`, may occur only in premise
patterns). Receiver- and purpose-relativity are **not special-cased** — a
`(:receiver (:var :reviewer))` role flows into premises by ordinary binding
coherence. That economy is §3's rent: a receiver-bound premise fails to cross
receivers because its binding simply conflicts, landing `:mismatched` with the
role named — no dedicated code path.

## 4. Schemas, exact versioning, the admit-kind encoding

A `judgment-schema` carries identity+version, a conclusion pattern, conjunctive
premise patterns, declared `:locals`, and `:unique-locals`. Resolution is by
**exact (name, version)** — no auto-latest anywhere; the registry refuses a
different schema under a taken key. Two implementation-forced encodings, both
documented warts, both exercised:

- **Admit-kind (Errata 1).** The Δ3 key `(:derivation (:schema NAME VER))` is
  unconstructible — the frozen `witness`/`promotion-procedure` require `:kind` to
  be a **keyword**. It is interned as one keyword
  `DERIVATION/<SYMBOL-NAME>/<DECIMAL-VERSION>`. **Collision-freedom (AUDIT-1 B):**
  `symbol-name` is injective on keywords and the version is a pure-digit suffix
  after the **final** `/`, so last-slash split recovers `(name, version)` uniquely
  even for names containing `/` (`:|A/2|` v1 → `…/A/2/1` ≠ `:A` v21 → `…/A/21`);
  63 adversarial pairs, zero collisions. `%procedure-admits-p` compares by `EQUAL`,
  so v1's keyword ≠ v2's — a v1 derivation can never satisfy a v2-keyed procedure.
- **Schema identity (Errata 2).** kernel0's identity-domain list is frozen with no
  `:schema`; a schema's durable identity is minted in the **`:procedure`** domain
  (a schema *is* a derivation procedure) with an encoded name `schema/NAME/VER`.

## 5. The killed designs (with their killers)

Every rejection is empirical — a specimen or ablation or owner ruling, never
aesthetics.

- **Opaque atomic derived proposition** — *killed by both ablations.* Collapsing
  the structured proposition + schema back to one atomic token + generic
  evidence-content procedure reproduces the S3 species exactly. Epitaphs, verbatim:
  > ABLATION EPITAPH: admissibility was VERIFIED for artifact-1 from digest-match +
  > signature-valid content-witnesses alone; signer recognition was never
  > represented as a proposition and never checked — the S3 species reproduced
  > exactly. *(de-praemissis)*
  > admissibility was VERIFIED for dataset-1 from schema-conformance +
  > low-missingness content-witnesses alone; calibration, population-suitability,
  > and permitted-purpose were never represented … the flattening species
  > reproduced exactly. *(de-admissione-datorum)*
  The replacement: declared anatomy + the S3 closure (§8).

- **One-status-per-premise summary** — *killed by the owner's Δ2 ruling.* The
  charter's first design gave each premise a single keyword and the receipt six
  name-buckets. That erases evidence: a premise with positive support *and* a
  refutation, or plural support, cannot be a single word. Δ2 replaced it with the
  structured `premise-assessment` (matching-accessible / -inaccessible /
  mismatched-candidates / refuting / binding-environments / ambiguities), the six
  terms surviving only as **derived dispositions**; the receipt carries the
  assessments themselves, "**no evidence class is erased because another class
  determined the disposition.**"

- **Multiple-proofs-equal-ambiguity** — *killed by the conflation finding +
  owner's multiplicity ruling.* The cross-domain specimen showed two *sufficient*
  proofs (Case A) and two *incompatible authorities* (Case B) landing the identical
  `:AMBIGUOUS` refusal — **plurality conflated with doubt** (safe, never wrongly
  grants, but forecloses "admissible, and doubly so"; `MULTIPLICITY.lisp` +
  `RUN-RECEIPT.txt` preserve it as history). CHARTER-DELTA-2 ruled: *plurality is
  evidence; ambiguity begins only where the schema declares a choice matters.*
  Multiple sufficient environments now **grant and are all preserved**;
  `:ambiguous` arises only from a declared `:unique-locals` conflict.

- **Implicit semantic incompatibility from opaque values** — *killed by the
  ruling's Case-B critique.* Case B's original incompatibility lived in *prose*
  (`"cert-vendor"` vs `"cert-self-signed"`) with no role representing it. The
  ruling: *Lisp+ must not infer semantic incompatibility from suggestive names.*
  **Case C is its executable gravestone** — the same two values, no `:authority`
  role, no uniqueness declaration ⇒ GRANT with both environments preserved plus
  the explicit statement that the language cannot enforce an incompatibility
  absent from declared anatomy. *Declared anatomy can be enforced; undeclared
  domain distinctions cannot be divined.*

**Superseded intermediate (recorded, not a killed design):** Δ1's Errata 3
implemented plurality-refusal by **threading** accepted bindings premise-by-premise
— a premise binding a local to >1 value refused `:ambiguous` immediately. Delta-2
superseded it with **complete-environment enumeration** across all premises: a
premise-local plurality on a non-unique local multiplies the environment set
rather than refusing; ambiguity is decided afterward from declared uniqueness over
the **complete** environments only. Threading survives only as an optimization
where it cannot change the environment set.

## 6. Environment-enumeration semantics + the uniqueness law

`derive` enumerates the finite set of complete coherent binding environments
(deterministic, pattern-against-ground). Environments are canonicalized (sorted by
variable name) and the **set** is order-independent under `EQUAL`, so support order
changes neither the decision nor the recorded environment set. `%uniqueness-
conflicts` judges declared `:unique-locals` over the **complete** environments
only — an incomplete environment's stray value never manufactures a conflict. A
local taking >1 surviving value across complete environments is a conflict, named
in the receipt (local + sorted values + carrying environments); no environment is
ever selected by traversal order. `derivation-receipt-multiply-supported-p` is a
**derived view** (`>1` complete environment), never a seventh premise status and
never a scalar proof-strength.

## 7. The four-strata host boundary (inherited)

Inherited from Slice /0 unchanged:

1. **Governed public Lisp+ surface** — `derive` + constructors + receipts enforce
   the declared semantic distinctions and receipt every attempt. *This is the
   Slice /1 claim.*
2. **Common Lisp host** — everything CL lawfully provides; nothing stops a program
   leaving the public surface.
3. **Explicit/internal host escape** — the one licensed `::` (the `why`-extractor
   registration, `SLICE0-DEFECT-RECEIPT-1.md`) and the **D-forge boundary**: a
   same-image hand-built `(:derivation …)` witness that skips `derive` succeeds.
   Disclosed (Δ3), *refused no repair* (AUDIT-1) — repairing it would claim
   host-level closure the slice does not make.
4. **Hostile same-image security** — outside every claim.

**The aliasing-breach repair (AUDIT-1 finding F, the one BREACH).** A single root
cause — canonical-data value lists and struct-accessor returns shared mutable
structure with callers — had four live paths, the worst (F2) letting a **past
receipt be silently rewritten** (`after mutation: (:WIPED)`), directly
contradicting the "recorded, never erased" law. The cure, teeth-bite-before-cure
(pre-repair failures recorded verbatim, incl. the reproduced `(:WIPED)`):
**constructor detachment** (`copy-tree` at `%normal-form` — no caller cons is
aliased in) + **defensive copies on every list-valued public reader** across all
four structs (schema, pattern, assessment, receipt), internal call sites moved to
`%`-readers. Teeth T13–T17 fail against pre-repair semantics and pass after. The
audit's own ceiling rides here: LIMES-II was a **fresh-context, same-family** audit
— valuable hostile coverage, not fresh-weights corroboration; a lineage-distant
finding remains structurally possible.

## 8. Integration seams with frozen Slice /0

- **The admits gate as S3 closure.** The conclusion's judgment procedure declares
  `:admits ((:derivation <schema-key>))`, so the frozen `%procedure-admits-p` will
  admit **only** the schema's own derivation as support. A generic content witness
  — the S3 bypass — is refused by the *existing* Slice /0 gate. Slice /1 supplies
  the anatomy; Slice /0's own machinery closes the hole.
- **The `why` registry via defect receipt.** One guarded load-time `push`
  registers the derivation extractor onto `lisp-plus-slice0::*why-extractors*`
  (the sole licensed `::`), keeping `why` uniform. Idempotent — reload installs no
  duplicate (list stays at 3: projection, transmission, derivation).
- **Testimony discipline.** A transported derivation receipt becomes a
  `:testimony`/`:derivation-report` witness whose `:for` is an `(:asserted CONTEXT
  REPORT)` attribution — the frozen testimony-level gate. Offered to a
  derivation-keyed conclusion procedure elsewhere, it is refused first by the
  frozen proposition-match gate (`wrong-proposition-support`), with the admits-gate
  refusal proven independently (T10/T11). Receipt-transport laundering is closed by
  the same mechanism that closes S3.

## 9. Temporary limitations (honest)

- **Atomic-proposition backward compatibility** — atomic Slice /0 propositions
  remain lawful primitives; Slice /1 does not force structure on them.
- **No negation algebra** — refutation names the exact ground proposition it
  refutes; there is no `(:not …)`.
- **No rule chaining** — a premise is discharged by a support or an already-judged
  claim, never by recursively invoking another schema.
- **Conjunctive-only premises** — disjunction and optional premises are deferred
  non-goals until a specimen demands them.
- **No discriminators** — `:unique-locals` conflicts are resolved only by removing
  competing support; no comparator callback, predicate, or host function may be
  installed as a discriminator (Case C is the ceiling this leaves standing).

— Claude Opus 4.8 (1M context), SCRIBA-II, 2026-07-23

*Every code fragment and receipt quotation above was checked against live SBCL
2.4.6 output or the frozen committed artifact it cites; the killed-design epitaphs
are verbatim from the specimen dispositions. Suites re-run after writing (no
source changed): slice1-selftest 50/0, SMOKE-1 9/9.*
