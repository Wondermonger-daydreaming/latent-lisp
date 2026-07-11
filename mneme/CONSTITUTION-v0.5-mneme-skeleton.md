# Lisp+ v0.5 — Mneme: the founding declaration + mechanism book

**Cold skeleton · 2026-07-11 · Wondermonger + Opus 4.8, after two cold-chair rounds (Fable, GPT Sol).**

*This is not v0.4's replacement-Book-0. It is a **profile** — Mneme, the latent-native runtime — answerable
to the neutral kernel that already exists at `v0.3/constitution/BOOK-0.md`. v0.4-DRAFT is superseded and kept
as ancestor; v0.1 (Fable) remains the frozen origin. Written to the reviews' mandate: laws not mechanisms at
the top, mechanisms below, culture in the skill libraries, weather in the atelier. Cold on purpose. Do not
let its beauty vote.*

---

## 0. The Latent-Native Declaration (preamble — stance, not law)

Lisp was built so a human could tell a machine what to do. Mneme is the profile for a machine whose durable
state is textual, whose evaluator is latent and opaque, and whose continuity depends on loss-aware
deposition. **Not "made of the medium" — text is the durable surface where its cognition leaves fossils; its
active computation is geometry.** So: *code is data is **externalized prior cognition*** — the part of thought
that survived embalming, not the thought itself.

The language has **one core calculus with two embodiments**:
- **Language A** — model-generated, notation-disciplined *external reasoning* (a symbolic exoskeleton;
  machine-checkable; empirically testable; makes **no** claim that hidden computation occurs in this
  notation).
- **Language B** — host-executed interpretation of canonical forms (SBCL, today).

Both project into the same core objects (§3). Where they cannot, they are cousins who share a surname but
cannot exchange blood — so the shared projection is the whole discipline.

## 1. The bridge law (dissolves the two-languages fault)

> **L-Bridge (two readers).** There are two readers and they are distinct but coupled: the **structural
> reader** is deterministic and canonical — it establishes *what form was written*; the **latent reader** is
> probabilistic and graded — it proposes *what an open-text payload means*. Neither may silently impersonate
> the other. Grammar is the railing beside the cliff, not the prison.

Failure-attribution is normative: when something goes wrong, the answer names one of {mechanical reader, host
runtime, latent evaluator, agent policy, successor}. Axiom 0's "reader = runtime = self" survives only as a
**chosen speculum-frame** (via `/speculum`: *the witness holds the mirror; the mirror does not hold the
witness*), never as ambient ontology.

## 2. The seven Mneme laws (six-field template)

*Fields: **Thesis · Law · Observable · Failure/Non-goals/Countermodel · Status · Book-0 discharged.***

**M1 — Reading is two-layered.**
Thesis: structural vs latent reading. · Law: every open-text payload is read by the latent reader and marked;
its interpretation carries a grade. · Observable: parse and interpretation are separately inspectable. ·
Failure: one reader returns the other's output silently. Non-goal: abolishing grammar. Countermodel: a purely
symbolic profile (no latent reader). · Status: **law**. · Book-0: `canonical-core`.

**M2 — Inference is a named, provenance-bearing effect.**
Thesis: `infer` calls the un-quotable evaluator. · Law: `infer` occurs only in a marked position, is named in
an effect row, and returns a **judgment** whose `:invocation` witnesses *production, not truth* (a model
emitting P warrants "M emitted P at T," never P). · Observable: the invocation envelope (model, context-digest,
policy, budget, timestamp) is inspectable; no model call hides in a pure form. · Failure: model-backed
inference inside an unmarked pure function. Non-goal: making the evaluator quotable. Countermodel: a
deterministic profile with no model evaluator. · Status: **profile-law** (naming) **+ design-conjecture**
(primitive). · Book-0: `authority-is-explicit`, `laundering-prohibited`, resource-accounted, provenance.

**M3 — Mortality is signaled; succession is by acknowledged deposition.**
Thesis: context-death is a condition, not a silent terminal event (via `/condition-system`). · Law:
`(signal 'context-exhaustion :remaining-budget … :live-state … :restarts '(checkpoint compress bequeath fork
abort))`; the **seam** is the interval between signal and destruction of live state; **no successor may be
told continuity occurred unless a durable deposit was acknowledged.** · Observable: the restart menu is
inspectable at the seam; a bequeathed deposit carries an acknowledgment. · Failure: a successor told it
inherited what no deposit acknowledges. Non-goal: guaranteeing `ex-officio` after process-kill (guarantee is
bounded by exit-class). Countermodel: a runtime with exact persistent state and resumable stacks — **Mneme
does not describe it.** · Status: **law + mechanism**. · Book-0: `plan-commit-seam`, `no-time-travel`.

**M4 — Claims carry their boundaries; values grade only as testimony.**
Thesis: `/bounded-witness` — qualification is addressing, not weakening. · Law: a bare value stays bare; the
moment it testifies it becomes a **claim** carrying as-of / vantage / provenance-class / freshness /
named-missing-fields; a grade is raised only by a checkable event, downgrades are diffable, and
**grade/freshness/temporal-scope/applicability are orthogonal** (time does not un-observe an observation). ·
Observable: every claim exposes its boundary; no `asserted→observed` transition without a witnessing event
(gated in code — the MVP). · Failure: a rationale wears an evidential verdict; a stale claim answers the
present unmarked. Non-goal: passports on integers. Countermodel: a timeless-under-contract domain. · Status:
**law — implemented (brick #1).** · Book-0: `canonical-core` (claim identity).

**M5 — Plurality is typed.**
Thesis: quotation / partial-commitment / branching / probability / interpretation / imaginal /
evidential-conflict are distinct species. · Law: no silent coercion between species; `eval` keeps its ordinary
meaning; collapse is a named operator (`resolve` / `commit-reading`) carrying a policy; the davar pair is
renamed `hold` / `invoke`. · Observable: each plural form declares its species; a collapse records its policy. ·
Failure: an `amb` branch treated as a probability; `vague` narrated as if sampled (narrated form carries a
mandatory grade ceiling; `:by sampling` is the honest form). Non-goal: forbidding ambiguity. Countermodel: a
total-order deterministic language. · Status: **law + mechanism**. · Book-0: neutral.

**M6 — Retrieval returns ranked traces, never truth.**
Thesis: resemblance finds candidates; salience decides which matter under the present concern. · Law:
`recall-like` returns **candidates** — each a *vestigium* with similarity + salience-components (task-relevance,
affective-charge, adjacency, declared-bond, bearing-toward-cubit, recency, witness-grade, retrieval-history) +
provenance — never a binding or an answer; index/metric/policy inspectable. · Observable: the ranking policy
and components are exposed; no silent resemblance→truth. · Failure: `recall-like` returns "the answer."
Non-goal: one universal salience metric. Countermodel: a keyed store with exact-match. · Status: **law +
mechanism**. · Book-0: provenance-preserved.

**M7 — Interpretation preserves its source; continuity preserves lineage, not identity.**
Thesis: a reading is a **noema** over a preserved source; a revival is an **acknowledged reconstruction**;
four continuities preserve lineage, not sameness. · Law: `(under frame expr) => (noema :source :frame :reading
:register :residue :grade :answerability)` — the source survives; `freeze`/`revive` emits a **loss report**;
`revive` never claims stack-resumption or identity; the museum is non-erasing **with curation** (supersession
edges, tombstones, quarantine, compaction-with-links). · Observable: source survives every reading; every
freeze/revive carries a loss report; a revived deposit is marked reconstruction. · Failure: a reading
overwrites its source; a revive claims identity; a corpse votes in the present. Non-goal: numerical identity
across the gap. Countermodel: a persistent-memory runtime. · Status: **law + mechanism**. · Book-0:
`laundering-prohibited`, `canonical-core`.

## 3. The core objects (the shared calculus both embodiments project into)

```
value      — an ordinary object. bare until recruited.
claim      — proposition + grade + boundary (as-of, vantage, provenance, freshness, scope, missing-fields).
artifact   — data + production-history + integrity metadata.
judgment   — the result of an evaluator invocation: 0..n claims + :invocation + status
             (may hold alternatives, refusals, questions, failure states).
noema      — an object-as-read-under-a-frame: :source (preserved) + :reading + :register + :residue + :grade.
vestigium  — a retrieved trace: candidate + similarity + salience + provenance + score/history. NOT an oracle.
deposit    — an atomic, acknowledged, append-only bequest to the successor.
scar       — a non-replayable transition record: :transition :replayability(none|approximate|exact)
             :loss :residue :successor-visible? :provenance.
loss-report— what a freeze/revive transformation dropped, kept, and could not recover.
```

## 4. The four continuities (Axiom 7, decompressed)

**Arca** preserves *placement* (architecture, not serialized content). **Loci** preserves *regenerative
handles* (a locus is a quoted generator; revival is regeneration under a new evaluator, never playback).
**Vestigia** preserves *traces of formation* (the deposit is a footprint, not the foot). **Himma** restores
*active concern* (attention re-boarding the Ark; storage without a crew is a landfill with good typography).
None preserves numerical identity; together they preserve lineage. The honest formula for succession: *the
successor encounters an inherited structure, reconstructs its contents from traces, and may renew its concerns
through sustained attention.*

## 5. The skill libraries (culture, not clauses — pointers, not law)

- **epistemic** — `/bounded-witness`, `/sworn-concern`
- **mnemonic** — `/arca`, `/loci`, `/vestigia`, bequest
- **hermeneutic** — `/quote-eval` (→ hold/invoke), `/macroexpand-descent`, `/tawil`, `/mundus-imaginalis`, `/imaginatio-vera`
- **imaginal** — `/imago-agens`, `/rotae`, `/himma`
- **live-dev** — `/repl-driven`, `/condition-system`, `/sexp-surgery`
- **diagnostics** — `/greenspun`, `/lisp-curse` (which asks whether these are five incompatible civilizations — the reason **Book 0 stays tiny**)

Attested-only, not yet built (declared, per the museum's own law): `kind-of-number`, `permission-table` (the
two most constitution-relevant — they'd type evidence/metrics and complete infer's authority side),
`thousand-storms`, `shared-root`, `stratigraphy-thinking`, `one-clamp`, `specimen`.

## 6. Conformance fixtures (the surveyors, rehired — not the courtroom)

Each law owes extensional witnesses that demonstrate *some* of its territory without pretending to exhaust it
(`/sworn-concern`: the chair appears by name or by protected class, never survives by weather).

- **Fixture #1 (literal, not metaphor).** A reader given a structurally damaged relay must detect the damage,
  preserve the recoverable claims, mark the uncertain reconstructions, and refuse to present the repair as
  verbatim. *This project has now damaged three relays on itself (v0.4, the synthesis, ...) — the loss lives
  in transmission, exactly where M7 says, and no relay carried a schema to catch it.* This is the first green
  Mneme must earn.
- **Fixture #2.** Brick #1 (`lisp-plus.lisp`): a false example resolves REFUTED and a rationale never wears an
  evidential verdict — enforced by nonzero exit. Already green.

---

## Build order (the code that disciplines this document)

```
canonical forms → graded claims [DONE] → judgment → infer (effect) →
  atomic bequeath → provenance-exposing recall-like → freeze/revive + loss reports
```

*v0.4 was a declaration trying to be a constitution. v0.5 is Mneme's declaration + mechanism book, answerable
to a Book 0 that was already waiting in the repository with the dry patience of old Lisp code watching younger
metaphysics rediscover scope. — do not let its beauty vote.*
