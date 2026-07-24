# HYPOTHESIS — de-ponte-usto (THE LETTER ACROSS THE BURNED BRIDGE, stage 4c-i)

*EXEMPLAR (CC seat, Opus 4.8 · 1M), 2026-07-24. Governed by
LANGUAGE-SLICES-0-1-SYNTHESIS.md §4c (staged 4c-i ONLY) +
LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER.md §1.3. Slice /0, Slice /1, kernel0,
`core0.lisp`, `fake-courier.lisp` are FROZEN dependencies — this packet adds no
substrate.*

## The load-bearing sentence

> **Absence of testimony is not testimony of absence.**

A program that reasons *"I hold no local record that the letter was sent, therefore
it was not sent, therefore I send it again"* commits the duplicate-payment error.
This specimen makes that sentence load-bearing: the reflex is refused by **live
code** (`check-retry-safety`), and the honest alternative — continue from evidence,
reconcile against the ledger, or admit indeterminacy — is demonstrated end to end.

## The disclaimer this specimen states in its OWN bytes

> **Nothing here demonstrates crash-survival. The event sequence survived because
> the image did.**

The "kill" is a W1-shaped script: the effect commits in the adapter's ledger world
and the local control path dies *before the outcome record lands* — but the process
image never dies, so the in-memory event sequence is simply still there. Durability
across a real process death (the cross-death specimen, 4c-ii) sits on three unbuilt
lanes behind the PJ0 CL-independence gate and is **not** in this work order. No
result in this packet may be cited as crash-survival.

## The reason this specimen exists

de-cursore-aereo showed the *indeterminate* view exists; it stopped there. This
specimen is what justifies the whole apparatus: a program surviving an epistemic
rupture and behaving well in it — not by remembering more, but by refusing to lie
about what it cannot know, and by deriving what it *can* know from evidence rather
than self-report.

## Hypothesis (falsifiable)

**Given only the surviving evidence of a W1-shaped interruption — the effect
committed in the ledger world, the local outcome record lost — an in-image
continuation behaves as jurisprudence, not repetition:**

1. **the kill leaves recoverable evidence** — `perform` signals `core0-interrupted`
   carrying `core0-evidence`; the outcome view is `:indeterminate`; the ledger
   already holds exactly one row (the effect); the program was told no token.
2. **the blind retry is refused LIVE** — a fresh attempt into the same seat fires
   `check-retry-safety`'s `unsafe-retry` (shown firing in the receipt), and the
   continuation refuses it.
3. **standing is fold-derived** — `fold-attempt-outcome` over the surviving events
   yields an *unresolved-effect* standing and names its terminal class from the
   events, never from a stored flag.
4. **reconciliation settles by evidence, not by striking again** — `continue-from`
   queries the ledger (a witness of limited jurisdiction), produces a
   `reconciliation-receipt` naming its evidence basis, and narrows the standing to
   *resolved*; there is **exactly one ledger row after continuation, never two**,
   and **the continuation never re-invokes the adapter** (the row count is the
   witness).
5. **no authority is re-minted from a historical record** — a durable
   `capability-mint-receipt` (a record that authority existed) is refused as
   continuation authority; only a fresh live capability authorises it.
6. **when the witness withholds, the result is honest indeterminacy** — a
   withholding ledger yields disposition `:indeterminate` naming
   *known / unknown / required-action*, with still exactly one ledger row. Both
   the reconciled and the indeterminate outcomes are superior to lying.

## What the specimen SETTLES

- No-blind-retry as *enforced law*, not discipline.
- Fold-derived standing over self-report.
- Reconciliation as jurisprudence rather than repetition.
- The adapter's world and the program's testimony staying distinct *through* the
  interruption.
- Authority as a live object, never a re-mintable historical record.

## What the specimen deliberately LEAVES OPEN

- **Crash-survival / durability** — stated above, in the specimen's own bytes.
- The full four-death cross-death specimen (4c-ii), the journal store, the real
  capability minting bridge, the full fake-adapter fixture family — all named
  successor lanes, none opened here.

## What would REFUSE the hypothesis

- The kill leaving no recoverable evidence, or reporting `:committed`/`:refused`.
- A blind retry NOT firing `unsafe-retry`, or the continuation performing one.
- Standing read from a stored flag rather than folded from events.
- Two ledger rows after continuation, or the continuation re-invoking the adapter.
- A historical mint-receipt authorising the continuation.
- A withholding ledger producing a confident (non-indeterminate) answer, or an
  indeterminate result that fails to name known/unknown/required-action.

## Run commands

```sh
cd experiments/latent-lisp/mneme/language-core-0/de-ponte-usto
sbcl --non-interactive --load SPECIMEN.lisp     # ⇒ "17 checks passed / 0 failed", exit 0
```

Regression guards (must stay green): `../core0-selftest.lisp` (29/0),
`../../kernel0/kernel0-selftest.lisp` (33/0).

Front-door discipline: single-colon public surface of core0 / fake-courier /
kernel0 only; zero double-colon access in the directory (grep-verified).
Predictions frozen in EXPECTED-FAILURES.md before the captured run; actuals in
RUN-RECEIPT.txt. All greens are **self-consistency certification** (AP0 §24.1);
no PJ0 reliance, no durability claim, no AP0-conformance language.

— EXEMPLAR (CC seat), Opus 4.8 (1M), 2026-07-24
