# EXPECTED-FAILURES — de-ponte-usto (PRE-REGISTRATION)

*Written 2026-07-24 by EXEMPLAR (CC seat, Opus 4.8 · 1M) **BEFORE the captured
run of SPECIMEN.lisp.** The specimen was authored; these predictions were frozen
from the design + the read substrate behavior; only then was RUN-RECEIPT.txt
captured. Predictions, not transcriptions. Any divergence is a chair-finding, not
a silent reconciliation.*

Scripts: `:kill-after-commit` (W1: commit the row, lose the local record, ledger
later ANSWERS) and `:kill-after-commit-withhold` (W1, but the ledger WITHHOLDS).
Request: `(:predicate :deliver (:payload "The orchard remembers."))`.

## Two sentences pre-committed as load-bearing (must appear in the run output)

- **"ABSENCE OF TESTIMONY IS NOT TESTIMONY OF ABSENCE."** — printed at the head.
- **"NOTHING HERE DEMONSTRATES CRASH-SURVIVAL. The event sequence survived because
  the IMAGE did."** — printed as the closing disclaimer.

## Pre-registered per-check dispositions

### Movement 1 — the bridge burns

| # | Check | Expected |
|---|-------|----------|
| 1a | the perform | SIGNALS `core0-interrupted` carrying `core0-evidence` |
| 1b | carried outcome view | `:indeterminate` |
| 1c | ledger row count | 1 — the effect committed in the world |
| 1d | told token | NIL — the local record never landed |

Predicted surviving events: `:process-created → :seat-reserved → :attempt-begun →
:effect-prepared → :frontier-crossed → :request-acknowledged → :effect-bounded →
:attempt-failed`.

### Movement 2 — the temptation refused (LIVE)

| # | Check | Expected |
|---|-------|----------|
| 2a | a blind retry into the seat through `check-retry-safety` | FIRES `unsafe-retry` (printed as "★ UNSAFE-RETRY fired") |

### Movement 3 — fold-derived standing

| # | Check | Expected |
|---|-------|----------|
| 3a | fold over surviving events | `unresolved-effect-p` = T |
| 3b | terminal class | a keyword named from events; predicted `:failed` |

### Movement 4 — reconciliation, exactly one row

| # | Check | Expected |
|---|-------|----------|
| 4a | `continue-from` disposition | `:reconciled` |
| 4b | reconciliation-receipt | `reconciliation-receipt-p` T with non-empty `new-evidence`; names target + procedure |
| 4c | narrowed standing | `unresolved-effect-p` = NIL (resolved) |
| 4d | ledger rows before / after | 1 / 1 — exactly one, never two |
| 4e | re-invocation | none — rows-before = rows-after (the row count is the witness) |

### Movement 5 — no authority re-minted from a historical receipt

| # | Check | Expected |
|---|-------|----------|
| 5a | `continue-from` with a durable mint-receipt as `:authority` | SIGNALS `ambient-authority-forbidden` |
| 5b | `continue-from` with a FRESH live capability | disposition `:reconciled` |

### Movement 6 — the withholding variant

| # | Check | Expected |
|---|-------|----------|
| 6a | `continue-from` against a withholding ledger | disposition `:indeterminate` |
| 6b | required-action plist | names `:known`, `:unknown`, and `:required-action` |
| 6c | ledger rows before / after | 1 / 1 — no retry, no second effect |

**Expected tally:** `17 checks passed / 0 failed`, exit 0.

## Falsifier (nonzero exit / hypothesis refused)

- Movement 1 leaving no evidence, or the outcome not `:indeterminate`, or the row
  absent.
- Movement 2's `unsafe-retry` NOT firing (the central tooth is toothless).
- Movement 3 standing not fold-derived / not unresolved.
- Movement 4 producing two rows, re-invoking the adapter, failing to reconcile,
  or leaving the effect unresolved.
- Movement 5 accepting a historical mint-receipt as authority.
- Movement 6 answering confidently against a withholding ledger, or omitting any
  of known/unknown/required-action.

## The central assertions restated (for the chair)

1. **EXACTLY ONE ledger row after continuation** — checks 1c, 4d, 6c. The effect
   crossed once; reconciliation adds no second effect.
2. **The continuation NEVER re-invokes** — check 4e; the row count is the witness
   (`continue-from` calls `ledger-query`, never `dispatch`).
3. **No authority is re-minted from historical receipts** — check 5a; a record
   that authority existed is not live authority.
4. Both non-lying outcomes are demonstrated: reconciled (4a–4c) and honest
   indeterminate (6a–6b).
