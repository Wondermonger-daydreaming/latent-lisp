# LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER — the smallest effectful seam

*2026-07-24. Issued by the authorial synthesis chair (Claude Fable 5, CC seat)
under the owner's synthesis charge, on the licensing conclusion of
`LANGUAGE-SLICES-0-1-SYNTHESIS.md` §6. This work order authorizes the smallest
implementation capable of running the three canonical microprograms (synthesis
§4). It authorizes nothing else.*

**Implementation authority:** the owner's charge ("start building") + the
standing green word for the build lane. The lowering contract (synthesis §3) is
the design authority; **divergences adjudicate to the governing spec text**
(Kernel /0 + Errata 0.2, PJ0, AP0) — never to convenience.

---

## 1. Deliverables (all under `experiments/latent-lisp/mneme/language-core-0/`)

1. **`core0.lisp`** — package `lisp-plus-core0`, single-colon consumer surface:
   - `consequence-context` constructor (+ read-only accessors, copy-disciplined
     per the AUDIT-1 repair discipline);
   - **`perform`** — the one new governed act, lowering per synthesis §3a steps
     1–8: mint attempt identity → check capability at the frontier → resolve
     adapter → prepare effect (pre-frontier closure; no implicit fallback) →
     append events (in-memory `kernel0-event` sequence, `validate-event-sequence`
     lawful) → invoke adapter → record manifestation → construct 4-axis
     `outcome`. Returns `(values outcome evidence)`; pre-frontier refusals
     SIGNAL typed conditions carrying the evidence-so-far. **Never returns a
     bare manifestation value. No boolean success anywhere.**
   - **`outcome-kind`** — the three-way VIEW per synthesis §3b, exactly;
     the full 4-axis record always reachable;
   - **`continue-from`** — in-image continuation: fold-derived standing
     (`fold-attempt-outcome`), unresolved-effect discovery, **blind-retry
     refusal via `check-retry-safety`**, reconciliation against the fake
     adapter's world → `reconciliation-receipt` + narrowed standing;
   - minimal capability: opaque live object minted from a **fixture sealed
     ruling** (synthesis §5.3, chair's recommendation — overridable by owner),
     frontier check, equal-or-narrower recorded; NO revocation registry, NO
     restoration flow (lane 2's);
   - typed condition family + `signal-core0` + restart whitelist, structurally
     homologous to slice0/slice1 (enforced in the signalling path and at
     macroexpansion — never in a condition initializer; the kernel0
     defect-receipt lesson is law here);
   - a `why` extractor for core0 evidence registered via the same receipted
     seam discipline as Slice /1 (if a new `::` is required, it gets its own
     defect receipt naming the unexported seam — one receipt per seam, no
     silent internals).
2. **`fake-courier.lisp`** — the deterministic fake adapter: script
   interpreter + private in-memory **ledger world**; scripted fixtures for (a)
   clean commit, (b) pre-frontier refusal, (c) W1-shaped kill (commit in world,
   die before local outcome record), (d) withholding reconciliation answer
   (indeterminate). **Labeled scripted subset — never "AP0-conformant."** The
   ledger (effect) and the manifestation/events (testimony) are distinct
   records the batteries compare.
3. **The three specimens**, each a `de-…` directory in house form (SPECIMEN +
   HYPOTHESIS + EXPECTED-FAILURES pre-registered + RUN-RECEIPT):
   - `de-abaco/` — the Pocket Abacus (synthesis §4a): quiet-zone control;
     machine-checked zero references into slice/kernel packages; registry and
     event-state untouched asserted;
   - `de-cursore-aereo/` — the Brass Courier (§4b): committed + refused +
     indeterminate arms; ledger-vs-testimony comparison; ack-has-no-settling-
     force tooth;
   - `de-ponte-usto/` — the Letter, stage 4c-i ONLY: exactly-one-ledger-row
     after continuation; no-blind-retry tooth (the central one); reconciliation
     evidence-basis named; **the packet states in its own bytes that nothing in
     it demonstrates crash-survival.**
4. **`core0-selftest.lisp`** — teeth that BITE BEFORE CURE (plant each fault,
   show the refusal fires, then pass): bare-value return attempt · boolean
   summary attempt · ambient-authority attempt · blind-retry attempt ·
   ack-settles attempt · duplicate-invocation-after-continuation · event-order
   violation · capability scope violation · quiet-zone leak (abacus program
   touching a governed package).
5. **`CORE-0-CLOSURE.md`** on completion — disposition with per-field evidence,
   ceilings verbatim, successor pressures ranked non-governing.

## 2. Binding constraints (violation voids the run)

- **Closed evidence byte-frozen:** no edit to anything under `language-slice-0/`,
  `language-slice-1/`, `kernel0/`, or governing specs. kernel0 selftest (33/23/0)
  re-run before and after; any drift voids.
- **Gates carried verbatim (synthesis §3c):** no PJ0 reliance or durability
  claim; no AP0 conformance claim; all greens labeled **self-consistency
  certification**; no "independently verified/validated" anywhere.
- **No Slice /2, no live provider, no production adapter, no compiler/REPL/
  module/type/macro machinery, no promotion of the 22 readers.**
- `with-outcome`: **not implemented** (unspecified semantics — successor-spec
  item, synthesis §3b).
- Working names (`perform`, `consequence-context`, `outcome-kind`,
  `continue-from`) are provisional; public admission by specimen evidence only.
- Every claimed verification in receipts/packets SHOWS its load-bearing step or
  writes "traced, compressed" (PLUMB's rule).

## 3. Acceptance threshold

Core /0 claims a language result only if all of: the three specimens run to
their pre-registered expectations; every selftest tooth bit before its cure;
the quiet-zone control shows zero consequential debris by machine check; the
no-blind-retry refusal fires from live `check-retry-safety`; ledger-vs-testimony
distinction demonstrated under interruption. Otherwise the honest report is
`(:core-0-disposition :result :library-layer :language-claim :not-yet-earned)` —
a lawful finding, not a failure of the work order.

## 4. Standing after completion

Successor pressures (non-governing, for the record): stranger read of the Core /0
surface · the board's three lanes arriving whole (journal store → 4c-ii, live
authority → real minting bridge, full fake-adapter fixture family) · the
`match-outcome` surface macro · the §21 inspection projection · the ergonomic
macro question. None opened by this order.

— Claude Fable 5 (CC seat), 2026-07-24

---

## AMENDMENT 1 — same day, pre-implementation: the owner's two-door ruling

Adopted from `OWNER-RULING-TWO-DOORS-EVIDENCE-TEST.md` (evidence-tested, no
contradiction): **(a)** working name `consequence-context` is renamed
**`process-context`** everywhere in §1; **(b)** `perform`'s documentation must
define its door by **accounted external-effect-frontier possibility** — never by
purity, determinism, expense, or durable-journal production; **(c)** reaffirmed
on the owner's word: no generic `(consequence …)` wrapper; unity lives in the
substrate (identity, CD/0 boundary, procedure descriptors, `why`, refusal/repair
grammar) — and NO unified outcome-projection across the two doors (derive's
decision stays binary by Δ2; perform's view stays three-way). No other
requirement changes.

*— the chair, same sitting, before any substrate byte existed*
