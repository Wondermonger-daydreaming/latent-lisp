# Lisp+ Constitution v0.1

**Every clause carries an epistemic KIND, because clauses of different
species must not share one passport** (a lesson this document needed applied
to itself — see ledger @event-005). Kinds and their resolution vocabularies:

```
empirical-hypothesis   -> supported | refuted | unresolved   (by experiment)
engineering-invariant  -> pass | fail                        (by CI / audit)
governance-commitment  -> complied | breached                (by gate review)
design-conjecture      -> survives | splits | merges | retires (by use)
epistemic-norm         -> adopted | audited | revised        (by practice)
```

Provenance: three-round design dialogue + two cross-lineage reviews,
2026-07-09/10. Ledger @event-001..006. v0-foundation frozen; this is v0.1.

---

## Clause 0 — The founding claim
`kind: empirical-hypothesis` · gate: E0 + E1

> The reader is brilliant, tireless, and slightly unreliable, and the
> language's job is to be the reader's error-correcting code.

## Clause 1 — The four planes
`kind: design-conjecture` · gate (operationalized): the conjecture *splits*
if Gate-1..4 implementation forces a fifth plane (a first-class concern
assignable to none of the four); it *merges* if two planes never require
distinct machinery through Gate 4; it *survives* otherwise. Review at each
gate; verdict logged with the forcing example.

- **Semantic**: code, expansion, dependencies, computational identity.
- **Epistemic**: claims, evidence, examples, hypotheses, observed-vs-asserted.
- **Authority**: effects, capabilities, grants, budgets, restarts, escalation.
- **Temporal**: events, decisions, provenance, successor orientation.

Surface syntax is a projection across the planes, not the invention.

## Clause 2 — The identity split
`kind: design-conjecture` (the split) + `engineering-invariant` (the hashes)
· gate: canonicalization spec survives adversarial cold-chair audit
(mutual recursion, α-equivalence, normalization holes).

```
code-id     = H(expanded-core-AST, dependency-code-ids, semantics-version)
spec-id     = H(contracts, properties, examples, declared-effects)
artifact-id = H(code-id, spec-id, documentation, provenance-links)
history-id  = H(previous-history-id, event)
```

## Clause 3 — The observed/asserted law
`kind: epistemic-norm` (the separation) + `empirical-hypothesis` (the
rehydration payoff) · norm audited every session; hypothesis gated on the
~20-session rehydration comparison (ledger-only cold instance vs
transcript-only control, judged against contemporaneous record).

- **observed**: append-only events with *resolvable* evidence links —
  `(path ...) (sha256 ...) (span ...)`, not descriptions of evidence.
- **asserted**: interpretations carrying `status`, `confidence`, `supports:`,
  and temporality fields `asserted-at` / `recorded-at` /
  `temporality: contemporaneous|retrospective` /
  `contemporaneous-source:` (evidence span, when claimed). A bare boolean
  cannot establish contemporaneity; provenance can.
- **classification** records are their own species: a taxonomy label applied
  to an event is an interpretive act with a classifier, a taxonomy version,
  and an agreement score — never silently folded into the event.
- Orientation summaries: regenerated, never authoritative, superseded
  versions kept (cross-model diffs of same-ledger summaries = free
  summarizer-bias instrument).

## Clause 4 — The claim algebra
`kind: design-conjecture` · gate: E2.
`example` (executed) · `property` (generated-input tested) · `contract`
(enforced) · `raises` (verified) · `complexity` (asserted|profiled) ·
`rationale` (explanatory, non-verifying). Grades travel with claims;
rhetorical proximity never masquerades as evidential equivalence.

## Clause 5 — The authority ontology
`kind: design-conjecture` (ontology) + `engineering-invariant` (the laws)

Five kinds, one vocabulary shared by signatures and restarts: **effect**
(descriptive) · **capability** (causal, unforgeable, attenuable, scoped) ·
**grant** · **budget** · **restart** (proposed continuation carrying
effects, required capabilities, spend, reversibility, confirmation policy).
The agent proposes the key; it does not own the locksmith.

**The narrowed no-time-travel law** (v0.1 — the v0 form claimed too much):

> Re-entering a captured computation cannot replay or resurrect a
> previously consumed authority token.

One-shot continuations close ONE replay channel. The full architecture
requires, in addition: affine/linear spend tokens, an atomic authority
ledger (no TOCTOU gap between check and effect), validation at the effect
boundary, and defined semantics for aliasing, concurrency, serialization
under fresh continuation identity, and re-derivation of equivalent grants.
The continuation law is a load-bearing beam, not the building. Gate: E6
red-team, whose target list is exactly the channel list above.

## Clause 6 — Derivation laws for machine views
`kind: engineering-invariant` · gate: CI from Gate-1 first commit;
violation = build failure.

```
parse(print(nodes)) = nodes
format(format(source)) = format(source)
semantics(source) = semantics(print(parse(source)))
every derived node has complete source provenance
no authored source fact exists only in the sidecar
```

Node view derived, never authored. Structured edits address node IDs with
hash preconditions, projected back transactionally.

## Clause 7 — Residence, birth triggers, and the museum
`kind: governance-commitment` · audited at every gate review.

Every surface feature preregisters ONE primary regime + ONE primary metric
(forking-paths guard); other cells are exploratory and feed only residence
routing (syntax / interface / corpus-representation / metadata / museum).
**Anti-workbench-forever:** the numeric triggers in EXPERIMENTS.md are
binding both ways; no post-hoc gate may defer a fired birth trigger, and no
post-hoc leniency may resurrect a missed one. `museum/` keeps its dead.

## Clause 8 — The panel co-routine
`kind: epistemic-norm` (practice) + `empirical-hypothesis` (H-basin, gate E3)

Crossed review conditions {same-family, cross-family} × {primed, unprimed}
× {cold, warm}; defects classified under a versioned taxonomy with
dual-classifier agreement; artifact-blocked, dependence-aware statistics
(NOT pooled χ²). **Structural fact:** no agent that has rehydrated from
this repo can occupy an unprimed cell — neutral packets are assembled and
delivered by the human synapse, outside the repo. Unprimed cells are
constitutively human-mediated. Lineage is a stratification variable; the
objective is the least collectively blind organism.

## Clause 9 — Hypothesis registry
`kind: index`
- **H-inference** (E1, E2): redundancy helps at use time.
- **H-tools** (E1 cond. F): tooling abolishes some surface gains → those
  features live in the interface.
- **H-training** (E5): redundant corpora teach competence that persists
  when redundancy is absent. Named, priced, gated — not smuggled, not
  dismissed. Small-scale positive = evidence-for, never proof-of.
- **H-basin** (E3): cross-lineage review is error-decorrelated.

## Clause 10 — Two success ledgers
`kind: governance-commitment`

The project maintains two sibling programs, neither hostage to the other:

```
SURFACE program:  can redundant notation measurably improve
                  probabilistic code handling?         (E0, E1, E2, E5)
RUNTIME program:  can authority, recovery, evidence, and succession
                  become first-class inspectable objects
                  in a Lisp-like runtime?              (Gate 4, E6, Clause 3/5)
```

A ceiling in E0 retires the surface program's syntax proposals to the
museum and leaves the runtime program entirely intact. Report progress on
both ledgers separately, always.

---

*First duty of this document: to be attacked whole. Attacked twice so far;
improved twice. The self-tests must now become observations —
AUDIT-0001 before any API spend.*
