# SLICE /1 — STOPPED ITEMS: the exact remaining authorial forks

*Chair: **Claude Opus 5 (1M context)**, 2026-07-24, under the owner's
completion ruling: "If D3 or D6 still contains a material design fork, stop
only that item and complete the determined ones." Both do. Both are stopped.
This document returns the forks at the smallest size the chair can state them.*

**Determined and implemented** (separate patch): D1 receipt threshold ·
D2 Canonical Datum /0 quoted-payload boundary · D4 and D5 documentation.
**Stopped here:** D3 and D6. **Deferred by the owner, not attempted:** D7.

---

## FORK 1 (D3) — judged-claim premise discharge: three of four conditions are determined; the compatibility relation is not

The owner ruled the charter promise governing and named four conditions.
Against the actual structures, three are **implementation-determined**:

| Owner's condition | Status | Instrument |
|---|---|---|
| normalized proposition matches the required ground premise | **determined** | the existing `%match-proposition` against `claim-proposition` |
| judgment has positive standing sufficient for that premise | **determined** | `judgment` is exactly `:verified \| :refuted`; **`:verified` discharges, `:refuted` and `nil` do not** — "missing, ambiguous, refused, or negatively judged claims do not discharge" is directly expressible |
| claim identity and judgment basis remain available in the derivation record | **determined** | `claim-id` plus the judgment-record's `procedure-id`, `procedure-version`, `support-ids` are all present and recordable in the premise assessment |
| **any required mode or kind compatibility is satisfied** | **UNDETERMINED** | see below |

**Why the fourth is undetermined, precisely.** A **witness** carries `:mode`
and `:kind`, which is what "mode/kind compatibility" names. **A claim carries
neither.** Its provenance is a `judgment-record` holding a `procedure-id` and
`procedure-version`. Meanwhile a **premise is a bare proposition-pattern** — it
has no slot naming an admissible source, and Slice /1's kind-gating
(`admit-kind`, `%procedure-admits-p`) exists only on the **conclusion** side.
So there is no pair of existing fields between which a compatibility relation
could be read off. The corpus does not contain the relation; it must be
authored.

The owner's own constraint rules out the cheapest answer: *"A judgment from an
unrelated schema must not be accepted merely because its proposition happens to
unify."* So "any `:verified` claim that unifies" is not available.

### The three candidate relations

**α1 — Provenance-class check.** Accept a `:verified` claim whose judgment
`procedure-id` denotes a governed derivation procedure at all (front-door
provenance), regardless of which schema produced it.
*Cost:* none — no new surface, one predicate.
*Objection:* this is exactly "its proposition happens to unify" plus a
front-door stamp. It appears to be the option the owner's sentence forecloses.
**The chair does not recommend it** and records it only so the fork is complete.

**α2 — Declared premise sources.** Extend `judgment-schema` so a premise may
declare which producing procedure identities may discharge it; discharge
requires membership.
*Cost:* a new declaration slot — a **language surface change**, the largest of
the three, and it makes every existing schema's premises implicitly
"discharged by supports only" until re-declared.
*Virtue:* "compatibility must be checked explicitly" in the most literal sense
— the schema author says what may discharge what, and nothing is inferred.

**α3 — Conclusion-identity chaining (chair's recommendation).** Accept a
`:verified` claim when the schema that produced it can be resolved from its
`procedure-id` and **that schema's conclusion pattern is the premise pattern**
(equal up to consistent variable renaming). In other words: a claim discharges a
premise exactly when it *is* the conclusion that premise asks for, established
earlier by a governed derivation.
*Cost:* no new public surface. Requires (a) resolving `procedure-id` → schema
via the registry, and (b) a pattern-equivalence test up to renaming — neither
exists today, both are internal.
*Virtue:* it is the natural reading of the charter's own sentence. The charter
forbids **recursive** chaining ("never by recursively invoking another
schema"); α3 introduces none — the claim was *already* judged, so nothing is
re-invoked. It gives "unrelated schema" an exact meaning (a schema whose
conclusion is not this premise) instead of a vibe.
*Residual question if α3 is chosen:* must the producing schema still be
registered at discharge time? A claim can outlive its schema's registration.
The chair suggests **yes, resolvable-at-discharge**, so the basis is inspectable
— but flags it rather than assuming it.

### One further determined point, recorded so it is not re-argued
**Receiver accessibility applies to judged claims too.** The charter's
`:satisfied` definition reads *"a matching, admissible, **accessible**
support/judged claim"*, and a claim carries an `id`, so the existing
`%support-accessible-p` id-membership test extends without invention. This is
**not** part of the fork.

---

## FORK 2 (D6) — ground-instance canonicality: the ruling's remedy does not reach the defect

The owner ruled: *"The recorded ground-instance must not depend on support
traversal order… Canonicalize its bindings according to the schema's declared
variable order, not the accidental order in which evidence was visited."*

**The chair must report a mismatch rather than implement past it.** The
prescribed remedy canonicalizes the **order of bindings inside one
environment**. The observed defect is **which environment is recorded at all**:

> two *complete, equally valid* environments differ in their **values** —
> `(:TAG "T1")` versus `(:TAG "T2")` — and `%build-assessment` instantiates
> `ground-instance` from `(first assess-envs)`, an unsorted accumulation list.

Reordering bindings within an environment cannot change `"T1"` into `"T2"`. So
the remedy as written leaves the reported defect exactly where it was.

**And the obvious shortcut is forbidden by the same ruling.** The layer already
has `%sort-envs`, but its docstring says it orders environments *"keyed on each
environment's printed canonical form"* — i.e. `(format nil "~S" e)`. The owner
wrote: *"Do not sort by printed representation or host-symbol order as a
convenience."* The existing canonicalizer is precisely the forbidden thing. The
chair also searched kernel0 for a canonical **value ordering** to build a
non-printed comparison on: **none exists.**

**The deeper reason this is authorial, not mechanical.** Under the multiplicity
ruling (Δ2), *plurality is evidence* and no environment is selected by traversal
order. When a premise matches under two complete environments, **there is no
"the" ground instance** — any single recorded instance is an arbitrary choice
dressed as a fact. That is a representation question, which is why it needs an
author.

### The three candidate representations

**β1 — Single-or-nothing.** Record `ground-instance` only when the premise has
exactly one complete environment; otherwise record an explicit plurality marker.
*Virtue:* never asserts an arbitrary instance. *Cost:* loses information a
consumer may want; changes a field's type-shape for plural cases.

**β2 — Record them all (chair's recommendation).** Make the recorded
ground-instance the **set** of instances, one per complete environment, ordered
by the schema's declared variable order applied lexicographically to bindings —
declaration order, never print order. A single-environment premise yields a
one-element set, so the common case reads as before.
*Virtue:* most faithful to "plurality is evidence"; nothing arbitrary is
asserted, nothing is discarded; the ordering rule is exactly the owner's
("declared variable order") applied where it *can* apply.
*Cost:* a reader's shape changes for plural premises — the one real
compatibility question, and the reason this is the owner's call and not mine.

**β3 — Total order on canonical values.** Define a CD/0-level total order and
select one environment lexicographically by declared variable order.
*Cost:* new ordering machinery at the canonical-datum layer, which is Core /0
territory and outside every current writ. *Virtue:* keeps the field's shape.
**The chair flags that β3 answers a Slice /1 problem by legislating in Core /0**,
which is the kind of scope migration the lane usually refuses.

---

## What is NOT here

**D7 (cycles and depth)** is not forked and not attempted — the owner's ruling
was explicit that no cycle/depth implementation is authorized, that cyclic
structures should *eventually* get a typed boundary refusal, that deep-but-finite
structures must not receive an arbitrary semantic maximum, and that the work is
deferred until real application use or a separate hardening pass requires it.
Recorded as standing, not as a ticket.

**No new work order is opened by this document.** It exists to hand back two
decisions at the smallest size at which they can be decided.

— **Claude Opus 5 (1M context)**, chair, 2026-07-24
