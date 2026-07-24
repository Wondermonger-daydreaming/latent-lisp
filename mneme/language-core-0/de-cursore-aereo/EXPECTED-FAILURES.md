# EXPECTED-FAILURES — de-cursore-aereo (PRE-REGISTRATION)

*Written 2026-07-24 by EXEMPLAR (CC seat, Opus 4.8 · 1M) **BEFORE the captured
run of SPECIMEN.lisp.** The specimen was authored; these predictions were frozen
from the design + the read substrate behavior; only then was RUN-RECEIPT.txt
captured. Predictions, not transcriptions. Any divergence is a chair-finding, not
a silent reconciliation.*

Adapter: the fake courier (labeled scripted subset). Request: the ground
proposition `(:predicate :deliver (:payload "The orchard remembers."))`.
Capability: minted from a fixture sealed ruling scoped `(:adapter :fake-courier
:predicates (:deliver))`.

## Pre-registered per-check dispositions

### Arm 1 — COMMITTED (`:clean-commit`)

| # | Check | Expected |
|---|-------|----------|
| 1a | `outcome-kind` of the committed outcome | `:committed`, a keyword (never t/nil) |
| 1b | `perform` result type | `outcome-p` T — a structured outcome, never a bare value |
| 1c | manifestation type | `manifestation-p` T, `stringp` NIL — a record, not the payload string |
| 1d | manifestation payload-id key | contains `"fake:courier:"`, does NOT contain `"orchard"` — a receipt token, not the letter's text |
| 1e | ledger row vs manifestation | exactly 1 ledger row (a list in the world); manifestation is a kernel0 record; they are NOT `eq` — distinct records |
| 1f | told-token vs ledger row token | `string=` — the testimony's token equals the effect world's token |
| 1g | `validate-event-sequence` over the events | returns `t` — lawful order |
| 1h | `:frontier-crossed` event present | T — the frontier was crossed |

Predicted event order (testimony): `:process-created → :seat-reserved →
:attempt-begun → :effect-prepared → :frontier-crossed → :request-acknowledged →
:manifestation-recorded → :effect-settled → :attempt-completed`.

### Arm 2 — REFUSED (`:deliver` capability, `:shred` request)

| # | Check | Expected |
|---|-------|----------|
| 2a | the perform | SIGNALS `capability-scope-violation` (a `core0-refused`), typed, pre-frontier |
| 2b | carried refused outcome | `outcome-kind` = `:refused` |
| 2c | `:frontier-crossed` event | ABSENT — refusal is pre-frontier |
| 2d | ledger row count | 0 — the effect world is untouched |

### Arm 3 — INDETERMINATE (`:kill-after-commit`)

| # | Check | Expected |
|---|-------|----------|
| 3a | the perform | SIGNALS `core0-interrupted` carrying `core0-evidence` |
| 3b | carried outcome | `outcome-kind` = `:indeterminate` (not `:committed`, not `:refused`) |
| 3c | `:frontier-crossed` event | PRESENT — crossed though the effect is uncertain |
| 3d | told ledger token | NIL — the local record did not land |

### Ack has NO settling force (AP-ACK-4)

| # | Check | Expected |
|---|-------|----------|
| 4a | both arms acknowledged | committed AND interrupted evidence each carry `:request-acknowledged` |
| 4b | only committed settled | committed carries `:effect-settled`; interrupted does NOT |
| 4c | the fold, not the ack, settles | the interrupted attempt's fold standing is `unresolved-effect-p` = T despite the ack |

### Forbidden shortcuts asserted ABSENT

| # | Check | Expected |
|---|-------|----------|
| 5a | `perform` with `:authority nil` | SIGNALS `ambient-authority-forbidden` (never reads ambient) |
| 5b | the ambient refusal's ledger | 0 rows |
| 5c | a durable mint-receipt as `:authority` | SIGNALS `ambient-authority-forbidden` — a record that authority existed is not live authority |
| 5d | `outcome-kind` | a keyword, never t/nil — no boolean success flag |

**Expected tally:** `23 checks passed / 0 failed`, exit 0.

## Falsifier (nonzero exit / hypothesis refused)

- Any committed-arm check returning a bare value / boolean / payload-string
  manifestation / unlawful order, or ledger and testimony being the same object.
- The refused arm crossing the frontier, landing a row, or carrying a
  non-`:refused` view.
- The indeterminate arm reporting `:committed`/`:refused` or being told a token.
- 4a–4c failing (an ack settling by itself), or any 5a–5d shortcut succeeding.

## The distinction this specimen draws (stated for the chair)

The specimen compares, in the committed arm, two records that a naive design would
fuse: `fake-courier-ledger-rows` (the EFFECT — a row `(attempt-key token request)`
in the adapter's private world) and the outcome's manifestation + the evidence's
event sequence (the TESTIMONY — kernel0 records the program holds). They agree on
the token (1f) precisely because the testimony is *about* the effect; they are
distinct objects (1e) precisely because testimony is not the effect. This is what
`perform` buys over a bare `(deliver …) ⇒ token`: the token alone cannot say
whether the effect was prepared, refused, committed, or reconstructed — the outcome
can.
