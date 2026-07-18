# Language-A 312-Emission — attempt-02-live RUN RECORD (RECONSTRUCTED)

- **Attempt:** attempt-02-live
- **run_state:** terminated-external-process-kill (BANKED partial at 295/312)
- **Author of this record:** TALLY-II (reconstruction hand)
- **Census provenance:** RECONSTRUCTED post-hoc from raw envelopes by TALLY-II
  after external process kill; **not the runner's own finalization.** The runner's
  process tree was reaped before it could write its own `EMISSION-CENSUS.json` /
  `RUN-RECORD.md`; `run.log` holds a single FIRE banner and **no exit line** (the
  reaping ate buffered output). Every number below was recomputed by TALLY-II from
  the on-disk envelopes joined to the frozen schedule — no summary was trusted.

## Invocation & authority

- Fired by **EMITTER-IV** at **2026-07-18T06:00:49Z** (`run.log` FIRE banner).
- Candidate `v2` (`790a0356`) + published receipts (`4fbf514`).
- **R15 record validates.** `harness/run_emission.gate_r15_record` +
  `preauthorship.validate_record_digest` accept the canonical digest
  `sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`
  (the raw-file byte hash differs by design — the digest is over the record's
  canonical form, `canonical_byte_length: 6241`). Run window
  **04:59:07Z .. 16:59:07Z**; the 06:00:49Z fire is inside the window.
- Subject routes (R15 `amended_subject_routes`): `claude-haiku-4.5` →
  `anthropic/claude-haiku-4.5`, `gpt-5.6-luna` → `openai/gpt-5.6-luna`,
  `kimi-k3` → `moonshotai/kimi-k3`. Subject binding
  (SYNTHETIC-SUBJECT-1/2/3 → haiku/luna/kimi) via
  `run_emission.load_subject_binding` (r5 own value-array ordering).

## Timeline (determinate where marked)

- **06:00:49Z** — FIRE (`run.log`).
- **06:00:51Z → 07:00:42Z** — **steady progress**, calls 1..295 all
  HTTP 200 with provider-reported usage. Span is DETERMINATE from the provider
  `Date` response headers in each envelope (call 1 `06:00:51Z`, call 50
  `06:10:41Z`, call 150 `06:31:06Z`, call 250 `06:52:09Z`, call 295
  `07:00:42Z`; last-write file mtime `07:00:48Z`). (The return-briefing's
  "~07:07Z / 295" is approximate; the envelope headers pin it to ~07:00:42Z.)
- **~07:00:48Z → ~08:45Z** — **call-296 stall**: no further envelope was ever
  written. The gap between the last completed write and the kill is **~104 min**
  by the file-mtime clock (the briefing states ~98 min of no progress on that
  call; both agree the call hung for ~1h40m).
- **~08:45Z** — **external kill**: the session plumbing reaped the runner's
  process tree mid-call-296. **No OOM.** This is a **session-plumbing reap** —
  the **third occurrence of this failure class this arc** (IGNITER-II's
  transcript, EMITTER's trigger, now the process tree). Kill time is NOT
  envelope-determinable; it is carried from the run-side account.

## Outcome census (RECONSTRUCTED — recomputed from 295 envelopes + schedule)

- **completed: 295 / 312** (envelopes present with both `*.bin` and
  `*.meta.json`, call_ids `TRANCHE-B-CALL-000001..000295`, contiguous, each
  paired with a `payloads/` and `requests/` file). All 295: `http_status 200`,
  `provider_reported_usage true`, all census fields present.
- **uncertain-write: 1** — `TRANCHE-B-CALL-000296` (schedule_index 296, arm
  LANG-A, subject kimi-k3). In-flight at the kill; request **possibly
  completed+billed provider-side, body never received**; no envelope on disk.
  Its own census class: `uncertain-write-terminated-by-external-kill`.
- **never-attempted: 16** — `TRANCHE-B-CALL-000297 .. TRANCHE-B-CALL-000312`
  (schedule_index 297..312). No provider contact.
- 295 + 1 + 16 = 312 ✓.

### Distributions (over the 295 completed)

| finish_reason | count |   | null_content | count |   | serving_provider | count |
|---|---|---|---|---|---|---|---|
| stop   | 140 |   | false | 219 |   | Amazon Bedrock | 101 |
| length | 155 |   | true  |  76 |   | OpenAI         |  98 |
|        |     |   |       |     |   | Moonshot AI    |  96 |

- `http_status`: 200 × 295. `provider_reported_usage`: true × 295.
- The 76 `null_content: true` rows are **determinate census outcomes, not
  failures** (HTTP 200, provider-reported usage) — kimi-k3 is a reasoning-class
  seat and null-content on reasoning exhaustion is a determinate outcome per the
  R15 option-(a) idiom. They are recorded with `state: "null-content"`.

## Floor check (exhibited)

Frozen floor — **PREREG-v0.2.md line 77**, verbatim:

> "Banking requires at least 90 percent analyzability overall and 80 percent in
> every core arm-by-subject-by-family stratum, complete failure census, no silent
> retry or substitution, locked materials and lineage, grader reliability or an
> inconclusive disposition, repeatable analysis, and two fresh-directory
> verification passes."

**Scope note (honest):** the PREREG floor is over *analyzability*, a
**post-scoring** determination over the arm-by-subject-by-family stratum. This
census reports **emission-completion** (envelopes present / scheduled) as the
necessary upstream precondition, at overall and per-subject-slot granularity. The
arm-by-subject-by-family *analyzability* floor is evaluated downstream, not here.

| stratum | completed | scheduled | rate | floor | pass |
|---|---|---|---|---|---|
| **overall** | 295 | 312 | 295/312 = **0.9455** | ≥ 0.90 | **PASS** |
| SYNTHETIC-SUBJECT-1 (claude-haiku-4.5) | 101 | 104 | 101/104 = **0.9712** | ≥ 0.80 | PASS |
| SYNTHETIC-SUBJECT-2 (gpt-5.6-luna) | 98 | 104 | 98/104 = **0.9423** | ≥ 0.80 | PASS |
| SYNTHETIC-SUBJECT-3 (kimi-k3) | 96 | 104 | 96/104 = **0.9231** | ≥ 0.80 | PASS |

Every emission-completion floor clears. A finer per-arm-by-subject completion
breakdown is carried in `EMISSION-CENSUS.json`
(`per_arm_subject_completion_supplementary`).

## Cost

No per-call cost field exists in the envelopes, so cost is a **token-based
computation** from provider-reported input/output tokens × the **R15
`amended_price_basis`** (`PRICE_TABLE`: haiku 1.00/5.00, luna 1.00/6.00, kimi-k3
3.00/15.00 USD/MTok), summed over the 295 completed calls via the runner's own
`EmissionRunner._billed_cost`:

- **≤ USD 1.932912**, pending owner dashboard confirmation.
- Excludes any provider-side billing for the uncertain-write call-296 (body
  never received). Spend ceiling USD 8.00; worst-case reservation over the
  completed calls is carried in the census summary.
- Exact attempt/transport-retry counters are **NOT determinable from the
  envelopes** (a retried-then-succeeded call leaves one envelope); the census
  records `attempts_reconstructed_lower_bound: 295` and `transport_retries: null`.

## Uncertain-write disposition (call-296)

`TRANCHE-B-CALL-000296` **must not be blindly re-fired** — a blind resend can do
the thing twice (the request may already have completed and billed provider-side).
Any completion attempt **requires a fresh owner act and a second-exposure
ruling**. It is banked here as its own class, not as a failure and not as a
success.

## Custody

Content-bearing evidence — payloads, provider raw bodies (`*.bin`), request
metas, and response headers — lives in **owner-custody local storage OUTSIDE the
repository** at `/home/gauss/Codex-Lab/emission-312-evidence/live-attempt-02/`
(`raw-responses/`, `payloads/`, `requests/`, `run.log`). **It is never
committed.** Only the three content-free artifacts in this directory
(`EMISSION-CENSUS.json`, `EMISSION-ACTUALS.json`, this record) enter the repo.
TALLY-II ran a fail-closed content-free scan (no string field > 200 chars outside
a named allowlist of TALLY-II-authored prose) before writing; it passed.

## Reconstruction sources

Runner code reused read-only (`harness/run_emission.py`):
`load_subject_binding`, `gate_r15_record`, `load_json` + `R15_PATH`/
`R15_RECORD_DIGEST`, `PRICE_TABLE`, `EmissionRunner._billed_cost`,
`EmissionRunner._census_row`, `EmissionRunner._actuals_record`,
`ReservationLedger` (replayed in schedule order to reproduce cumulative billed);
`preauthorship.validate_record_digest`. The schedule↔envelope join and the
terminated / never-attempted classification are re-implemented by TALLY-II
because the runner's `run()`/`preflight()` assume a live run-state.

## Successor caveat

This is a **reconstruction, not the runner's finalization.** The billed figure is
a token-based **bound** (dashboard-unconfirmed). Attempt/retry counters are void
(not envelope-derivable). Call-296 is genuinely uncertain — treat it as neither
done nor undone until an owner act resolves it. The store of record is the
outside-custody envelope directory; if this census and the envelopes ever
disagree, **the envelopes win** — recompute, do not trust this summary.
