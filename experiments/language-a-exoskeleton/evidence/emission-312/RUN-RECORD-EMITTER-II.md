# Language-A 312-Emission — EMITTER-II Run Record (content-free)

**Hand:** EMITTER-II (firing hand). **Outcome: HONEST-STOP** — the runner exhausted
its 32-attempt transport-retry budget on call #2 (OpenAI route) and stopped honestly,
writing a partial census. Not a crash, not a named-gate refusal, not a window or spend
stop. A determinate, reportable partial census per R14 bounded-unknowns.

## Invocation (verbatim, §8-documented live path)

Run from the worktree root `/home/gauss/Codex-Lab/wt-language-a` (the cwd required for the
worktree-relative `--in-repo-census-dir` literal to resolve to the true in-repo location;
packet files self-locate via `__file__`, so cwd does not affect them):

```
python3 experiments/language-a-exoskeleton/harness/run_emission.py \
  --live \
  --evidence-dir /home/gauss/Codex-Lab/emission-312-evidence/live-attempt-01 \
  --in-repo-census-dir experiments/language-a-exoskeleton/evidence/emission-312
```

Flag values byte-identical to EMISSION-RUNNER-CONSTRUCTION.md §8.

## Actual clock (wall)

| Event | UTC |
|-------|-----|
| Run start (gate clock, `summary.clock_utc`) | 2026-07-18T04:04:55.837006Z |
| Census written (run end) | 2026-07-18T04:12:38Z |
| Duration | ~7m43s |
| R14 window open | 2026-07-18T02:43:55Z |
| R14 window close | 2026-07-18T14:43:55Z |
| Window margin at last call | ~10.65 h remaining (window was NOT the constraint) |

## Census summary (content-free)

| Field | Value |
|-------|-------|
| mode | live |
| run_state | stopped |
| stop_reason | TransportBudgetExhausted: partial census |
| scheduled_calls | 312 |
| rendered | 312 / 312 |
| emitted (census rows) | 2 |
| attempts / ceiling | 34 / 344 |
| transport_retries / ceiling | 32 / 32 (exhausted) |
| worst_case_reservation_usd | 0.267160 |
| r6_worst_case_reservation_usd | 2.246177 |
| worst_case_delta_usd | -1.979017 |
| billed_cost_usd | 0.000000 |
| spend_ceiling_usd | 8.00 |

## Per-subject calls + statuses

| call_id | subject | route | state | detail |
|---------|---------|-------|-------|--------|
| TRANCHE-B-CALL-000001 | claude-haiku-4.5 | Anthropic direct | null-content | HTTP 404, finish_reason `unrecognized-envelope` — determinate 4xx envelope, no retry, continued |
| TRANCHE-B-CALL-000002 | gpt-5.6-luna | OpenAI API | transport-exhausted | retryable transport class (connect/read-timeout / 5xx / 429); 32-retry budget exhausted → honest stop |
| (not reached) | kimi-k3 | Moonshot kimi.com coding | — | run stopped at call #2; subject #3 never contacted |

## Finish-reason / provider-actuals

- Finish-reason distribution: `unrecognized-envelope` ×1 (null-content determinate), transport-exhausted ×1.
- Returned model ids: none captured — neither call produced a usable provider body.
- Token usage: `input_tokens`/`output_tokens` = null for both; `provider_reported_usage` = false for both.
- OpenAI output-cap field name for `gpt-5.6-luna`: UNRESOLVED — the OpenAI route was transport-unreachable.
- Retention/cache disclosures: captured per-call in the OUTSIDE-repo raw-response meta files; summarized as pending exact confirmation per r6-closed-v2.
- Anthropic response carried a request-id header (content-free metadata) on the 404.

## Transport / ceilings

- transport retries: 32 / 32 (budget exhausted — the stop cause).
- attempts: 34 / 344 (call #1 = 1 attempt; call #2 burned the retry budget).
- spend: $0.000000 billed vs $8.00 ceiling (nothing charged; no successful billable emission).

## Evidence custody

Content-bearing evidence — rendered payloads (`payloads/`), raw provider bodies and meta
(`raw-responses/`), and request bodies (`requests/`) — lives in owner-custody local storage
OUTSIDE the repository at:

```
/home/gauss/Codex-Lab/emission-312-evidence/live-attempt-01/
```

It is uncommitted and stays outside. Only the content-free census mirror
(`EMISSION-CENSUS.json`, `EMISSION-ACTUALS.json`, the runner's `RUN-RECORD.md`, and this
record) is committed in-repo. The in-repo census was scanned field-by-field and verified
content-free (0 long-text fields; all string leaves are numbers, timestamps, digests,
route/model/schema labels, statuses, or a provider request-id).

## Successor caveat

This evidence commit is a SUCCESSOR. No verification claim attaches to it: EMITTER-II fired
and recorded; it did not re-attest the candidate. The construction attestation rests with the
two published clean-room receipts (gamma, delta) at candidate 7da828e; this record only
reports what the authorized live run did.

— EMITTER-II (Claude Opus 4.8, 1M context)
