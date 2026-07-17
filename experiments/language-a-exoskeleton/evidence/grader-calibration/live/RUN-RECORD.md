# RUN-RECORD — Language-A Tranche B grader-calibration LIVE run

**Firing agent:** IGNITER (Claude Opus subagent). **Coordinator:** Claude Fable 5.
**Authorization:** `owner-decision:gate-walk-r12-adopted-v1` (GATE-WALK-R12) + explicit owner
greenlight 2026-07-17. Synthetic-only, OpenRouter route, zero real-item bytes.

## OUTCOME: BLOCKED — frozen runner crashed mid-run (unhandled `AttributeError`)

The live run did **not** complete. The frozen runner `tooling/run_calibration.py` crashed on the
36th call with an unhandled exception. **No `CALIBRATION-REPORT.json`, `BANKED-SCORES.jsonl`, or
`ADJUDICATIONS.jsonl` was produced; no reliability was computed; there are no per-family
verdicts.** Per IGNITER's charter I did **not** patch the frozen runner and re-run — a broken
frozen runner is a finding, reported as-is.

## 1. Freeze verification — PASS

- `git log --oneline -1` = `d46ec58 Add frozen synthetic grader-calibration packet, runner, and offline dry-run proof` on branch `codex/language-a-tranche-b-prereg-freeze-and-lineage-search`.
- `sha256sum -c PACKET-FREEZE-MANIFEST.sha256` → `PACKET-FREEZE-MANIFEST.json: OK`.
- Per-file check of all **64** `packet_files` in `PACKET-FREEZE-MANIFEST.json` (run from experiment root): **64/64 sha256 match, 0 mismatch, 0 missing, 0 byte-length mismatch.**
- Preflight §7: `author_packet.py` regeneration left all 64 packet files byte-identical (0 changed); `build_manifest.py --verify` → `VERIFY PASS`; `run_calibration.py --dry-run` → `"overall": "PASS"` (all self-tests pass). The machinery is sound offline; the crash is a live-path-only condition.

## 2. Pinned cast (from live `https://openrouter.ai/api/v1/models`, fetched 2026-07-17T18:20:57Z)

Full excerpts + candidate lists + rationale in `live/MODEL-PINNING.json`. Three distinct families (frozen R6 cast: GPT / GLM / DeepSeek):

| Slot | Model ID | Name | Pricing (prompt / completion, USD/tok) |
|---|---|---|---|
| Rater A (GPT) | `openai/gpt-5.5` | OpenAI: GPT-5.5 | 0.000005 / 0.00003 |
| Rater B (GLM) | `z-ai/glm-5.2` | Z.ai: GLM 5.2 | 0.0000009254 / 0.0000029084 |
| Adjudicator (DeepSeek) | `deepseek/deepseek-v4-pro` | DeepSeek: DeepSeek V4 Pro | 0.000000435 / 0.00000087 |

Rater A rationale: the `gpt-5.6` line is persona-only (`luna`=subject slot, `sol`=barred item-author, `terra`=third persona); to obtain a clean *bare general* GPT instance the persona family was avoided entirely and the strongest **base** flagship, `openai/gpt-5.5`, chosen. `*-pro` variants (≈6× output price) were rejected to keep total cost well under USD 1 / safely under the USD 2 STOP. Rater B: `z-ai/glm-5.2` present → used per RUN-DESIGN preference. Adjudicator: strongest general DeepSeek.

## 3. Timeline & call counts

- Live run start: 2026-07-17T18:21:22Z. Crash / exit(1): 2026-07-17T18:25:44Z (~4m22s).
- Raw envelopes written: **36** (all `raw/*-attempt0.json`; **0** ERROR envelopes, **0** retries — every HTTP call returned 200).
- First-pass rows appended: **35**, all `disposition: SCORED` — 18× `openai/gpt-5.5` (rater-a), 17× `z-ai/glm-5.2` (rater-b).
- The **36th** call (raw envelope `ASG-ff571c5eb6ee-rater-b-attempt0.json`, model `z-ai/glm-5.2`, rater-b) returned HTTP 200 but with `message.content = null` → the parse crashed **before** its first-pass row could be appended (hence 36 envelopes vs 35 rows).
- Adjudications: **0** (crash occurred during first-pass phase, before the disagreement/adjudication phase).
- Attempted **36** / succeeded-and-scored **35** / crashed-unhandled **1** / retried **0** / gracefully-censused **0**.

## 4. The bug (exact, with evidence)

**Crash:** `AttributeError: 'NoneType' object has no attribute 'strip'` at
`run_calibration.py:282` (`_extract_json`), reached via `run()` → `parse_rater_json(content, …)`
at line **554**.

**Trigger envelope** (`raw/ASG-ff571c5eb6ee-rater-b-attempt0.json`), verbatim fields:
- `model`: `z-ai/glm-5.2`, `role`: `rater-b`, `finish_reason`: **`length`**
- `choices[0].message.content`: **`null`**; `message` keys include `reasoning` (len 4818 chars), `reasoning_details`, `refusal`
- `usage`: `completion_tokens: 1024`, `completion_tokens_details.reasoning_tokens: 1024`, `prompt_tokens: 853`, `cost: 0.00146199`

**Root cause.** GLM-5.2 is a reasoning model. The runner calls it with `max_tokens=1024`
(`DEFAULT_MAX_TOKENS`) and requests no reasoning suppression. On this one example the model spent
the **entire** 1024-token completion budget on `reasoning_tokens` and emitted **zero** content
tokens, so `finish_reason="length"` and `content=null`.

**Why it crashes instead of censusing (the frozen-runner defect):**
1. `LiveOpenRouterProvider.call` (line 318) does `content = response_obj["choices"][0]["message"]["content"]` and returns it **without a null check** → returns `None`.
2. `do_call` (lines 355–381) only converts *raised exceptions* into retries/CENSUS. A 200 response with null content raises nothing, so `do_call` returns `(None, 0)` as if success.
3. In `run()` (line 549) `if content == "CENSUS"` is `False` for `None`, so control enters the `else` branch and calls `parse_rater_json(None, …)` (line 554).
4. `_extract_json(None)` calls `None.strip()` → `AttributeError`. The surrounding `try/except` (lines 553–559) catches **only `ValueError`**, so the `AttributeError` propagates and aborts the whole run.

This is intermittent, not systematic: 17 of 18 GLM-5.2 calls finished with `finish_reason="stop"`
and valid content; the crash fires only when a reasoning-capable rater exhausts the token ceiling
on reasoning alone. The latent defect is nonetheless a hard blocker — it **will** recur with any
reasoning-model rater on any example whose reasoning overruns `max_tokens`, and it aborts rather
than degrading gracefully to the census path the constitution defines.

## 5. Cost

Actual usage from the 36 live envelopes' `usage.cost` fields: **USD 0.251547** total (36 calls).
This is consistent with expectations; a full 64-call run would extrapolate to well under USD 1.
**No cost concern** — the run was blocked by the crash, not by cost; the USD 2 STOP was never
approached.

## 6. Per-family verdict table

**None computable.** Reliability requires the complete first-pass matrix and the runner's
`compute_family_reliability`; the run aborted before any report was written
(`CALIBRATION-REPORT.json` absent). No agreement / kappa / AC1 / ELIGIBLE-NOT-ELIGIBLE-INCONCLUSIVE
verdict exists for any of `unsupported_assertions`, `scope_errors`, `version_errors`,
`residue_erasures`. Independent recomputation was therefore **not applicable** (nothing to
reconcile against). The 35 partial first-pass rows are retained under the calibration root but
are an incomplete, unbanked fragment and are **not** a calibration result.

## 7. Anomalies / notes

- Zero real-item content was read or transmitted; all reads were `synthetic-calibration-example`
  artifacts (READ-LINEAGE has 36 rows; firebreak was not evaluated — it runs only at report time).
- No frozen file (packet, runner, manifest) was modified. Only live-run outputs (`raw/`,
  `READ-LINEAGE.jsonl`, `FIRST-PASSES.jsonl`) and this `live/` directory were written.
- Recommended fix (for the coordinator to rule on — **NOT** applied here): treat a null/empty
  `content` as a failed attempt inside `LiveOpenRouterProvider.call` (raise, so `do_call` retries
  → CENSUS on exhaustion), and/or raise `max_tokens` and/or pass an OpenRouter `reasoning`-disable
  parameter so reasoning raters emit content. This is a change to a frozen instrument and must be
  re-frozen and re-authorized before any live re-fire.

---

*Signed: IGNITER (Claude Opus subagent). Coordinator: Claude Fable 5. 2026-07-17.*
