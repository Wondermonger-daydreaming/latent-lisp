# Runner boundary patch — null/empty content → CENSUS (owner ruling, option a)

**Coordinator:** Claude Opus 4.8 (1M context). **Authorization:** owner decision 2026-07-17
(calibration-runner-defect ruling, option a). **Predecessor evidence:** attempt-#1 blocked run
`ac01eb6` (`live/attempt-01-BLOCKED/`, `live/RUN-RECORD.md`), re-walk
`evidence/gate-walk/RE-WALK-2026-07-17-post-calibration-attempt.md`.

## What the owner ruled

A **successful** provider envelope whose assistant content is null or empty is recorded as the
frozen CENSUS / unanalyzable-response outcome. It must **not** be parsed, silently omitted,
retried, or assigned a substantive grader verdict. The record must preserve HTTP + provider
completion status, normalized + native finish reasons, returned model identity, prompt/completion/
reasoning-token counts, cost, the raw response-envelope digest, and a null/empty reason code. Add a
deterministic negative-control fixture (HTTP 200, finish_reason=length, content=null, reasoning
budget exhausted). **Change nothing else** (cast, max-token limits, reasoning settings, prompts,
scoring law, reliability thresholds, packet contents, retry policy).

## The patch (runner boundary + narrowly necessary tests + freeze identities only)

`tooling/run_calibration.py` — boundary only:
1. New constants `CENSUS_NULL_CONTENT`, `NULL_CONTENT_REASON`.
2. `_is_null_or_empty()` + `build_null_content_census()` — extracts the required record fields from
   the envelope defensively (absent field → `null`).
3. `LiveOpenRouterProvider.call` now captures `http_status` into the recorded envelope (no other
   change; key still redacted).
4. `do_call` — after a **successful** `provider.call`, a null/empty content returns
   `(CENSUS_NULL_CONTENT, census_metadata)` **immediately**: no retry (it never enters the
   exception path — retry policy byte-unchanged), no parse. The raw envelope is still written once,
   and its digest goes into the census record.
5. `_extract_json` — defense-in-depth type guard: a non-string raises `ValueError` (the **handled**
   class), never `AttributeError` (the attempt-#1 crash class).
6. First-pass + adjudicator classification each gain a `CENSUS_NULL_CONTENT` branch → the cell/
   example is `UNANALYZABLE-CENSUS`. The existing `"CENSUS"` (transport-exhaustion) and parse-error
   branches are unchanged.

`tooling/fixtures/null-content-length-envelope.json` — the deterministic negative control (new).

`selftests()` gains proof **(e) `null_content_censused_not_crashed`**, exercised through the real
`do_call` boundary: asserts routing to CENSUS, exactly one raw envelope (no retry, no ERROR file),
complete metadata, raw-digest match, and null+empty detection. Registered in the dry-run
`required_proof_points`.

`tooling/build_manifest.py` — the freeze inventory now covers the new fixture.

## What did NOT change (verified)

- **Packet contents byte-identical:** all **64** `packet_files` match the attempt-#1 freeze
  (`ac01eb6`) sha256-for-sha256 (`build_manifest.py --verify` → VERIFY PASS).
- Cast, `DEFAULT_MAX_TOKENS=1024`, reasoning settings, prompts, `AGREEMENT_FLOOR`/`KAPPA_FLOOR`/
  `AC1_FLOOR`, scoring/reliability law, `RETRY_CEILING=2` and the retry mechanism: untouched.

## Re-freeze identities

- Rebuilt `PACKET-FREEZE-MANIFEST.json` sha256: **`773841cda044f658c3d2edff8659a68e57186229f028f532933f03c0d8360908`**
  (packet_files identical; tooling inventory updated for the patched runner + new fixture).
- Tests: `run_calibration.py --dry-run` → **PASS**, 13/13 checks, all five proof points
  (a,b,c,d,e) TRUE.

## Rerun discipline (for the NEXT authorization)

Attempt-#1 output was relocated to `live/attempt-01-BLOCKED/` so the calibration root holds **no**
resume-state; a fresh run therefore starts from call 1 (owner: do not resume from call 36 / do not
reuse the 35 substantive verdicts). No live provider call was made in this patch stage.

— Claude Opus 4.8 (1M context), 2026-07-17
