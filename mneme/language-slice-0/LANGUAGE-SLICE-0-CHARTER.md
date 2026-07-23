# LANGUAGE-SLICE-0-CHARTER — Checked Evidential Promotion

**Normative.** Step 2 of the R6 execution order (`WORK-ORDER-0.md`).
Grounded in `INVENTORY-0.md` (commit `0e98b1ea`); the eight inventory
questions are ruled below, each with the repository evidence that forced it.
This charter governs the Slice /0 substrate and the `de-promotione` specimen.
It designs one thing: **the language act by which a program asks to say
something stronger than it has so far said, and the checked relation that
grants or refuses that request.**

- **Seat:** Claude Fable 5 (CC), 2026-07-22.
- **Runtime law:** SBCL 2.4.6 operation-checked; kernel0 selftest re-verified
  live this sitting (33 passed, 0 failed, 59 mutants killed, 0 survived).

---

## 1. Semantic purpose

Kernel /0 already enforces, at the record level, the negative law that
**structural execution evidence must not license semantic acceptance**
(`procedure-descriptor` judgment-class wall, K0E-23/25; mutant
`structural-licenses-accepted` killed). Slice /0 turns that law into a
**programmer-facing act**:

- an explicit promotion request (`raise`);
- a checked relation among **proposition, support, procedure, receiver, and
  order** before any judgment attaches;
- a structured refusal that names the exact missing relation;
- an intelligible explanation (`why`) derived from structure, for granted and
  refused transitions alike;
- lawful repair through a closed set of typed restarts.

The failure the slice exists to make impossible-or-conspicuous: **execution
evidence (an exit status, a trace, a transcript, testimony about a run)
silently becoming verification standing.**

## 2. The model — separated categories, no scalar ladder (Q1)

There is **no total order of standings** in Slice /0. The apparent ladders in
the tree — `validation-record`'s `{:unchecked :checked :verified :refuted}`,
the evidence-kernel's 7 grades, Language A's `*claim-standings*` — are three
different vocabularies (INVENTORY-0 M3), and the de-projectione bench probe
proved the linear order itself is a laundering joint (F4: `min(:executed,
:witnessed)` handed a receiver execution standing on testimony). The category
error is repaired by separation, not by choosing a better ladder:

| Category | Representation |
|---|---|
| **proposition** | a canonical datum (CD/0 boundary); second-order propositions are ordinary data: `(:asserted operator P)` |
| **commitment** | the historical act on a claim: `:asserted` (Slice /0 needs no other; the field is open) — never rewritten |
| **support record** | a first-class `witness` object attached to nothing until considered |
| **support mode** | `:direct` \| `:testimony` \| `:derivation` — *kinds of relation to the proposition*, not rungs |
| **support kind** | `:execution` \| `:exit-status` \| `:transcript` \| `:parse` \| `:observation` \| `:report` \| … — open keyword vocabulary, admitted per procedure |
| **polarity** | `:supports` \| `:refutes` — orthogonal to mode and kind |
| **judgment** | `:verified` \| `:refuted` — exists ONLY inside a judgment record naming the procedure (id+version) that produced it; there is no procedure-free judgment |
| **admissibility** | receiver-relative, **computed** by `raise` when a receiver is given, never stored on the claim |
| **transmissibility** | a declared field on a witness (`:transmissible`), carried but not enforced (de-infando's lane) |

The test-runner "ladder" (launched → … → release-admissible) is therefore
**not a ladder of standings on one proposition** — it is a family of distinct
propositions, each requiring its own support, related only by what a
procedure declares it requires. This dissolves M3 without minting a fourth
vocabulary.

**Verification is a judgment, not a rung**: it is produced when an authorized
`:semantic` procedure relates suitable support to the *correct* proposition,
and it lives in the resulting judgment record and receipt — nowhere else.

## 3. Public forms (minimum surface)

```lisp
(claim   :proposition P :by principal)                     ; commitment :asserted
(witness :for P :mode M :kind K :source S
         &key :procedure :content :polarity :as-of
              :transmissible :accessible-to)               ; support record
(raise   claim :to :verified :per procedure-descriptor
               :considering witnesses &key :receiver)      ; the checked act
(why     receipt-or-condition)                             ; structured explanation
```

Plus, non-negotiable companions: `promotion-receipt` (returned always),
the Slice /0 condition families, `with-slice0-restarts`, and read-only
accessors on every object. Names change only under executable ergonomic
pressure recorded in the specimen packet.

## 4. Witness — a new first-class object (Q2, Q8)

A `witness` is **not** a renamed `validation-record`. The kernel record
carries a status rung from the very ladder §2 rejects, and lacks mode,
polarity, level, time and transmissibility (M2). The witness object must
represent at minimum: direct evidence, testimony, execution evidence,
derivation, refuting evidence, and second-order attribution ("S asserted P" —
carried by `:for` being a second-order proposition, §6).

Reused from kernel0 as substrate: `durable-identity` (ids), `require-canonical`
(the proposition boundary), immutable-strict-constructor idiom, defensive
snapshot on capture.

**Time (Q8):** constitutive ordering is kernel0's discipline — a
deterministic per-image ordinal, no wall clock (§13.2). Witnesses MAY carry
`:produced-at` / `:observed-at` / `:valid-through` as **testified evidence
fields** supplied by a clock or source — data about time, never trusted
ordering truth. Internal sequence is governed; wall-clock time is testified.

## 5. Immutability, lineage, origin (Q5, Q7)

`promote-origin`'s kernel law governs (`records.lisp`: every attempted origin
promotion signals `standing-inflation`): **origin is historical and
immutable.** Therefore:

- A successful `raise` returns a **new claim revision** carrying the judgment
  record, plus a `promotion-receipt`; the original claim is untouched and the
  revision's lineage names it.
- A failed `raise` preserves the original claim untouched and signals; the
  receipt (decision `:refused`) records the attempted transition.
- **Assertion and refutation are preserved separately (Q7):** if all suitable
  support refutes P, the refusal receipt records
  `:current-judgment :refuted` while the historical `:asserted` commitment
  stands. Nothing silently downgrades; nothing annihilates the assertion.
  A failed request to verify can lawfully return
  `(:original-commitment :asserted :requested-judgment :verified
    :decision :refused :current-judgment :refuted)`.

## 6. Testimony preserves proposition level

The de-projectione bench law carries forward: **evidence that S asserted P is
not evidence for P.** A testimony witness's `:for` is the second-order
proposition `(:asserted S P)` (its `:content` may carry P). No mode
arithmetic, no rung comparison, and no convenience path may flatten it to
direct support for P. Only an authorized procedure may license a transition
from attribution-support to P-support, and Slice /0 ships **no** such
procedure — it ships `construct-attribution-claim` (a restart) so the program
can lawfully say the thing its evidence actually supports.

## 7. Promotion evaluation — the checked relation

`raise` grants a judgment iff ALL of:

1. **Proposition match** — each considered witness's `:for` equals (canonical
   equality) the claim's proposition; witnesses for other propositions are
   named in the refusal (`wrong-proposition-support`), never silently ignored
   when they are all that was offered.
2. **Mode/kind admissibility** — the procedure descriptor declares which
   `(mode, kind)` pairs it admits; testimony admitted only for second-order
   propositions per §6 (`insufficient-support-kind`).
3. **Procedure authority** — the requested judgment `:verified`/`:refuted`
   requires a `:semantic` descriptor; a `:structural` procedure is refused
   (`inadmissible-procedure`) — kernel0's K0E-25 wall re-expressed one level
   up, via reuse of kernel0's `procedure-descriptor` record itself.
4. **Receiver admissibility** — when a `:receiver` is supplied, every
   load-bearing witness must be accessible to it
   (`receiver-cannot-access-support`); absent a receiver, the judgment is
   receiver-unqualified and says so in the receipt.
5. **Polarity** — refuting witnesses that pass 1–4 produce `:refuted`, not a
   discount on `:verified`.

## 8. Receipts (Q3)

A **new** `promotion-receipt` record (the reconciliation-receipt's
before→after+evidence+residue *lesson*, not the record — that one is keyed to
attempt-axis lineage, M4):

```lisp
(promotion-receipt
 :claim-before … :requested-judgment … :supports-considered (…)
 :procedure … :decision :granted|:refused :claim-after …   ; nil when refused
 :residue (…) :explanation <why>)
```

Issued on **every** attempt, granted or refused. The attempted transition is
never lost.

## 9. Conditions and restarts (Q4)

Kernel0's condition base **cannot be subtyped** for this work: the §20.9
restart whitelist is kernel0 law, none of whose seven names fits claim
promotion, and its live containment is `with-kernel0-restarts`'
macroexpansion-time refusal. **Execution-verified correction (PROBE brief,
`kernel0-api-brief.md` (this directory); supersedes this charter's first wording):**
the condition-layer guard *written* at conditions.lisp:211–216 is INERT
under SBCL 2.4.6's `make-condition` — CL does not require `make-condition`
to call `initialize-instance`, and SBCL's does not — so a subtyping layer
would be either unlawful under §20.9 or resting on an inert guard. The
slice's own layer accordingly enforces its contract in `signal-slice0` and
at macroexpansion (live code paths), never in a condition initializer.
Editing the frozen file is forbidden. Therefore
Slice /0 builds a **parallel, structurally homologous layer**: `slice0-condition`
carries the same diagnostic shape (`failed-invariant`, `requirement-id`,
`offending-field`, `offending-value`, `permitted-restarts`, plus
`why`), its own `signal-slice0`, its own `with-slice0-restarts`, and its own
frozen whitelist.

Condition families: `unsupported-promotion` · `wrong-proposition-support` ·
`insufficient-support-kind` · `inadmissible-procedure` ·
`receiver-cannot-access-support` · `testimony-impossible`.

Lawful restarts (closed set): `retain-current-claim` ·
`seek-matching-support` · `construct-attribution-claim` · `defer-judgment` ·
`retarget-receiver` · `mark-testimony-impossible`.
**Not offered to well-formed programs:** `continue-anyway`, blind `retry`,
arbitrary standing assignment — no governed signalling site lists them, and
`with-slice0-restarts` refuses them at macroexpansion. **Sizing (IANUS
audit, 2026-07-23 — supersedes this section's original absolute wording):**
the whitelist is package state; a loaded file can extend it
(`slice0-transmissibility.lisp` does so openly as governed vocabulary
extension, and the audit demonstrated an adversarial file minting
`continue-anyway` the same way, then expressing it through the macro). The
closed set is surface discipline against ordinary programs, **not a
host-level guarantee** — the same R3-class escape as `::`, on the record in
`de-infando/IANUS-AUDIT.md`.

## 10. Structured explanation (Q6)

One `why` object serves granted and refused transitions:

```lisp
(why :decision … :condition-ids … :requirement-ids … :failed-relations …
     :offending-fields … :supports-considered … :strongest-lawful-result …
     :available-repairs …)
```

Discipline inherited from kernel0's verdict reason-law: a refused why MUST
carry ≥1 failed relation; a granted why MUST name its procedure and
supports. `render-why` derives prose from these fields; prose is never
composed retrospectively from anything the structure doesn't hold.
`strongest-lawful-result` is the honest counter-offer: what the same
evidence WOULD license (often the attribution claim of §6).

## 11. Non-goals

- No receiver projection semantics (de-projectione, session 1) — receiver
  fields exist so types don't foreclose it; nothing more.
- No transmissibility enforcement, serialization surface, or capability
  confinement (de-infando).
- No general policy calculus, no trust arithmetic, no chains of testimony.
- No wall-clock trust; no global registry of procedures (caller resolves —
  kernel0's named exclusion holds here too).
- No edits to byte-frozen kernel0 or lci0; no contact with Language A.

## 12. Acceptance threshold

Slice /0 claims a **language** result only if `de-promotione` demonstrates
all six clauses of the WORK-ORDER-0 threshold (idiomatic-CL misleading move ·
rejectable/conspicuous in Lisp+ · refusal names the missing relation · ≥1
lawful repair · ablation destroys the property · lawful program stays
intelligible). Otherwise it reports
`(:slice-0-disposition :result :library-layer :language-claim :not-yet-earned)`
— a lawful, useful finding. The comparison questions in WORK-ORDER-0 §68–79
are answered explicitly in the specimen packet; **"can a disciplined library
reproduce this"** is the acceptance test, and the specimen must argue it
honestly, not rhetorically.

---
*Charter ends. Everything below the public surface is implementation
technique; nothing in this file licenses a roadmap.*

— Claude Fable 5 (CC seat), 2026-07-22
