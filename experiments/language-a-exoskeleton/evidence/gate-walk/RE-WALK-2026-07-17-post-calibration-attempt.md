# Re-walk of the four blocked checklist lines — post calibration attempt #1

**Coordinator:** Claude Opus 4.8 (1M context), Language-A pilot chair.
**Trigger:** owner grader-calibration authorization + greenlight (2026-07-17); required order step 8.
**Packet:** `/home/gauss/Codex-Lab/wt-language-a/experiments/language-a-exoskeleton` @ `d46ec58`.
**Firewall:** no key, no real item/packet content read; only synthetic calibration bytes, hashes,
governance records, and the runner source were inspected.

## Verdict: **BLOCK — CALIBRATION DEFECT NAMED**

Calibration was authorized, fired, and **crashed**; three of the four lines are not TRUE at HEAD.
The pre-exposure gate stays unsigned.

| Line | Requirement (short) | Verdict | Evidence |
|---|---|---|---|
| **L4** | Record prices/routes/custody (settings/tokenizer deferrals allowed) | **TRUE** | `operator/owner-slots.json` `price-table :: resolved :: owner-decision:scoring-r6-closed-v2` (the fe3f0b2 sync survives my commits); PREREG erratum in place; settings/tokenizer deferral sealed in GATE-WALK-R12. Unaffected by the calibration attempt. |
| **L8** | Complete synthetic-only grader calibration + firebreak | **FALSE — the named defect** | Run fired at `d46ec58` (owner-authorized, synthetic-only, OpenRouter). **Frozen runner `tooling/run_calibration.py` crashed** on call 36 with unhandled `AttributeError: 'NoneType' … strip` (`_extract_json`, l.282, via `parse_rater_json`, l.554). **No `CALIBRATION-REPORT.json`, no banked scores, no reliability, no per-family verdicts.** Firebreak itself: still enforced (dry-run teeth-checks pass). Calibration **incomplete**. |
| **L11** | Two fresh-directory verifications reproduce at HEAD | **FALSE (downstream)** | The recorded clean-room runs (`4a2bcbb`, 12/12 green) do **not** reproduce at `d46ec58`: the authorized stage-1 freeze commit added 142 files under `evidence/` (in `frozen_scope`), so `check_manifest` now raises `UnmanifestedFrozenArtifact` and `verify-pilot.sh` is RED. Resolvable only by the step-7 manifest rebuild, which is gated behind calibration completing. |
| **L12** | Rebuild manifest only after all bytes final | **FALSE (downstream)** | `CONSTRUCTION-MANIFEST.json` is stale by design — calibration packet + attempt evidence are unmanifested, and the bytes are **not** final (the runner must change to fix the L8 crash, then re-freeze). Rebuilding now would finalize a known-incomplete tree; deliberately deferred. |

**Compact:** L4→TRUE · L8→FALSE (crash) · L11→FALSE (downstream of L8) · L12→FALSE (downstream of L8).

## The defect (verified against disk, not testimony)

Root cause: a reasoning-model rater (`z-ai/glm-5.2`) spent its full `max_tokens=1024` budget on
`reasoning_tokens` and emitted **zero** content tokens → HTTP 200, `finish_reason=length`,
`message.content=null`. Confirmed in `raw/ASG-ff571c5eb6ee-rater-b-attempt0.json`
(`reasoning_tokens: 1024`, `content is None: True`). The runner's `LiveOpenRouterProvider.call`
returns that `None` **without a null-check**; `None != "CENSUS"` so it reaches the parse path;
the surrounding handler catches only `ValueError`, so the `AttributeError` aborts the whole run
instead of degrading the cell to `UNANALYZABLE-CENSUS`. Intermittent (35/36 calls scored fine),
hard blocker for any reasoning-model rater. Cost of the aborted run: **USD 0.2515** (never near
the USD 2 STOP). Full evidence: `evidence/grader-calibration/live/RUN-RECORD.md`,
`live/MODEL-PINNING.json`, `raw/`, `FIRST-PASSES.jsonl` (35 rows).

## Why this is not patched autonomously (the owner's fork)

The runner is a **frozen, committed instrument** (packet freeze `d46ec58`); changing it requires
re-freeze + re-authorization by construction. The fix is **not** a unique mechanical edit — it
embeds a scientific choice, and the options differ in what the calibration measures:

- **(a) null-content → failed attempt → retry → CENSUS.** The "pure plumbing" fix (makes the
  runner do what its CENSUS path already intends). Consequence: a reasoning rater that overruns
  budget yields UNANALYZABLE cells; if frequent, the effective sample shrinks and floors may fail
  **honestly**.
- **(b) raise `DEFAULT_MAX_TOKENS`** so a reasoning rater has room to reason *and* answer. Changes
  the instrument's config + cost profile.
- **(c) pass an OpenRouter reasoning-suppression param** so the rater emits content. Changes what
  the rater *is* (reasoning vs non-reasoning) — arguably touches the cast.
- **(d) reconsider whether a reasoning model belongs in the "bare GLM-family rater" seat**, or
  constrain the grading prompt to forbid long private reasoning.

These fork the science; per *ask on ambiguity, act on clarity*, the choice is the owner's, not the
chair's. No fix has been applied; `tooling/run_calibration.py` is byte-identical to its frozen hash.

## What must happen next (owner-gated)

1. Owner rules the fix among (a)–(d) (or another).
2. Apply it → re-freeze the runner (new packet-freeze manifest) → re-authorize the run.
3. Re-fire calibration; apply the frozen disagreement/reliability rules unmodified; land per-family
   verdicts.
4. Rebuild `CONSTRUCTION-MANIFEST.json` after bytes are final; two clean-room `verify-pilot.sh`
   runs green at the new HEAD (closes L11/L12).
5. Re-walk all four → READY or BLOCK.

No signature, no combined preflight, no target scoring, no 312-request emission is authorized or
performed. Gate flag on disk: `pre_exposure_gate_signed: false` (unchanged); `exposure_readiness()`
still refuses at `OwnerResolutionRequired: pre-exposure-gate-signature`.

— Claude Opus 4.8 (1M context), 2026-07-17
