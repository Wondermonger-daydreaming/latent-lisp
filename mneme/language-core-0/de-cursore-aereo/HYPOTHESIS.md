# HYPOTHESIS — de-cursore-aereo (THE BRASS COURIER: one effectful crossing)

*EXEMPLAR (CC seat, Opus 4.8 · 1M), 2026-07-24. Governed by
LANGUAGE-SLICES-0-1-SYNTHESIS.md §4b + LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER.md
§1.3. Slice /0, Slice /1, kernel0, `core0.lisp`, `fake-courier.lisp` are FROZEN
dependencies — this packet adds no substrate.*

## The reason this specimen exists

de-abaco proved the quiet zone: ordinary computation incurs no consequence. This
specimen crosses the other threshold — the **effectful frontier** — for the first
time. A program says to the outside world *deliver this letter*, and instead of a
bare return value it gets back a **structured outcome** that can distinguish, in
its own record, whether the effect was prepared, refused, committed, or left
uncertain. The letter is `"The orchard remembers."`; the door is the deterministic
fake courier (a labeled scripted subset, never AP0-conformant).

The load-bearing distinction the whole apparatus exists to make (Sol's marrow):
**the letter being placed in the ledger — the EFFECT, in the adapter's private
world — is not identical to the program recording that it placed the letter there
— the TESTIMONY: a manifestation record plus the event sequence.** A language that
conflates the two cannot tell "it happened" from "I believe it happened." Lisp+
keeps them as two distinct records this specimen compares side by side.

## Hypothesis (falsifiable)

**One surface call — `perform` — lowers into the effectful pipeline and returns a
structured 4-axis outcome, never a bare value and never a boolean, across three
regimes distinguished by a three-way VIEW:**

1. **committed** — a scope-authorised delivery crosses the frontier, a ledger row
   lands in the adapter's world, and the local record lands. `outcome-kind` is
   `:committed`; the manifestation is a *record carrying a receipt token*, never
   the payload string; the event sequence is lawful (`validate-event-sequence`
   passes); and the ledger row (effect) and the manifestation+events (testimony)
   are demonstrably distinct records that nonetheless agree on the token.
2. **refused** — a capability scoped to `:deliver` cannot authorise `:shred`: the
   refusal is typed (`capability-scope-violation`), **pre-frontier** (no
   `:frontier-crossed` event), the carried outcome's view is `:refused`, and **no
   ledger row lands** (the effect world is untouched).
3. **indeterminate** — the letter crosses and a row lands, but the local outcome
   record does not (a W1-shaped kill): `perform` signals `core0-interrupted`
   carrying surviving evidence; `outcome-kind` is `:indeterminate`; the program
   was told no token. (Its *reconciliation* is de-ponte-usto's subject, not this
   specimen's.)

**And the two settling laws:** (a) an acknowledgment has NO settling force by
itself (AP-ACK-4) — the committed and interrupted arms are *both* acknowledged;
only the committed arm settles, and the settlement comes from the kernel FOLD
(`:effect-settled`), not the ack; the fold agrees the acked-but-interrupted effect
is still unresolved. (b) None of the four forbidden shortcuts is reachable through
the governed door: bare-value return, boolean success flag, ambient authority, and
a durable mint-receipt masquerading as live authority all refuse or are structurally
impossible.

## What the specimen SETTLES

- The front-door syntax of the effectful act, and how authority enters (an
  explicit capability argument, never ambient).
- Adapter naming (a designator resolving to a registered adapter object).
- The outcome projection's exact three-way behavior over real perform outcomes.
- How much kernel vocabulary surfaces: **records reach the surface (manifestation,
  outcome, events); the operational verbs do not.**
- That the effect and the testimony about it are two records, not one.

## What the specimen deliberately LEAVES OPEN

- **Durability** — nothing here survives image death, said plainly; the ledger is
  in-memory and the event sequence survived because the image did.
- Streams, cancellation, live-authority breadth, the ergonomic-macro question, and
  the *reconciliation* of the indeterminate arm (de-ponte-usto). It shows the
  indeterminate VIEW only, not its continuation.
- Any AP0-conformance claim: the fake courier is a labeled scripted subset.

## What would REFUSE the hypothesis

- The committed arm returning a bare value / boolean, a manifestation that is the
  payload string, an unlawful event order, or the ledger and testimony being the
  same object.
- The refused arm crossing the frontier, landing a ledger row, or carrying a
  non-`:refused` view.
- The indeterminate arm reporting `:committed` or `:refused`, or being told a token.
- Either settling law failing: an ack alone settling an effect, or a forbidden
  shortcut succeeding.

## Run commands

```sh
cd experiments/latent-lisp/mneme/language-core-0/de-cursore-aereo
sbcl --non-interactive --load SPECIMEN.lisp     # ⇒ "23 checks passed / 0 failed", exit 0
```

Regression guards (must stay green): `../core0-selftest.lisp` (29/0),
`../../kernel0/kernel0-selftest.lisp` (33/0).

Front-door discipline: single-colon public surface of core0 / fake-courier /
kernel0 only; zero double-colon access in the directory (grep-verified).
Predictions frozen in EXPECTED-FAILURES.md before the captured run; actuals in
RUN-RECEIPT.txt. All greens are **self-consistency certification** (AP0 §24.1);
no PJ0 reliance, no durability claim, no AP0-conformance language.

— EXEMPLAR (CC seat), Opus 4.8 (1M), 2026-07-24
