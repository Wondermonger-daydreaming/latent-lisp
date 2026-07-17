# RUN-RECORD — Language-A Tranche B grader-calibration LIVE run (attempt-02)

**Bookkeeping agent:** TALLY (Claude Opus subagent — the counting hand). **Firing agent:** IGNITER-II
(fired the run, died before bookkeeping). **Coordinator:** Claude Fable 5.
**Authorization:** `owner-decision:gate-walk-r12-adopted-v1` (GATE-WALK-R12) + the option-a runner
patch (`RUNNER-PATCH-2026-07-17-option-a.md`, owner ruling 2026-07-17). Synthetic-only, OpenRouter
route, zero real-item bytes.

## OUTCOME: ELIGIBLE — all four primary families meet the frozen reliability floors

Independent recomputation from `FIRST-PASSES.jsonl` + `ADJUDICATIONS.jsonl` reproduces the runner's
`CALIBRATION-REPORT.json` **exactly** (every rational, every verdict). L8 (grader reliability) walks
to TRUE for `unsupported_assertions`, `scope_errors`, `version_errors`, `residue_erasures`.

## 0. LEAD DEVIATION — the briefing's census claim is FALSE (verified against the raw envelopes)

The charge and the coordinator's context stated *"zero CENSUS_NULL_CONTENT entries — the option-(a)
boundary never fired."* **This is false.** The option-a null/empty-content census boundary fired
**four times** in this run, and its firing is precisely what let attempt-02 *complete* where
attempt-01 *crashed* on the identical condition (`live/RUN-RECORD.md`). I therefore do **not** write
"zero null-content entries" into this record; the true census summary is in §3. This deviation does
**not** move the calibration verdict (the census mechanism excluded those examples exactly as the
frozen rule prescribes; the surviving 28 clear every floor, and the verdict is robust to the
counterfactual — §6a). Two lesser briefing inaccuracies, corrected from disk: completion was
**~20:16 UTC**, not ~21:16 (the report's `-0300` offset was misread as UTC); and per-family floor is
the **reliability** floor, not a "≥5 per family" count (§1).

## 1. Freeze verification — PASS

- `git rev-parse HEAD` = **`008f62e46e5af438b60bf137eecb0688fbfab48b`** on branch
  `codex/language-a-tranche-b-prereg-freeze-and-lineage-search` — matches the charge.
- `sha256sum PACKET-FREEZE-MANIFEST.json` =
  **`773841cda044f658c3d2edff8659a68e57186229f028f532933f03c0d8360908`** — matches the charge and the
  option-a re-freeze identity (`RUNNER-PATCH-2026-07-17-option-a.md` §Re-freeze).
- No frozen file modified. `git status` shows only regenerable `dry-run/` outputs touched (the §7
  dry-run re-run) and `live/attempt-02/` untracked; `packet/`, the runner, and the manifest are
  clean.

**Frozen rule source I executed against (cited, not remembered):**
- Reliability floors — `tooling/run_calibration.py:83-85`:
  `AGREEMENT_FLOOR=Fraction(80,100)`, `KAPPA_FLOOR=Fraction(60,100)`, `AC1_FLOOR=Fraction(60,100)`.
- Verdict logic — `tooling/run_calibration.py:445-510` (`compute_family_reliability`): κ defined ⇒
  `ELIGIBLE iff agreement≥0.80 AND kappa≥0.60` (l.482); the kappa-undefined / AC1 branch (l.485-509).
- Categorical-agreement + Cohen-κ construct — `RUN-DESIGN.md` §1(b),(c); first-pass-only reliability
  §1(e); the four primary families §1(f); the κ-undefined interpretation §K.
- **There is NO "≥5 per family" count floor** anywhere in the frozen tooling or docs (I grepped
  `floor|minimum|>=5|at least`). The charge's parenthetical is not the actual floor. The frozen floor
  is the reliability floor above.

## 2. Pinned cast & invocation

Invocation (key from the lab `.env`, redacted from every envelope):
```
python3 tooling/run_calibration.py \
    --rater-a-model openai/gpt-5.5 \
    --rater-b-model z-ai/glm-5.2 \
    --adjudicator-model deepseek/deepseek-v4-pro \
    --out-dir live/attempt-02
```
| Slot | Model ID | Calls |
|---|---|---|
| Rater A (GPT) | `openai/gpt-5.5` | 32 |
| Rater B (GLM) | `z-ai/glm-5.2` | 32 |
| Adjudicator (DeepSeek) | `deepseek/deepseek-v4-pro` | 2 |

## 3. Timeline, envelopes & census summary

- First raw envelope: **2026-07-17T20:05:30Z**; report written **2026-07-17T20:16:28Z** (~10m58s).
  `CALIBRATION-REPORT.json` `generated_at` = `2026-07-17T17:16:28-0300` (= 20:16:28Z). (Clock read
  live: `date -u` = 2026-07-17T23:14Z at bookkeeping time.)
- `raw/` = **66** envelopes, each carrying a real OpenRouter `gen-` id (verified: 0 missing).
  66 = 64 first-pass (32 + 32) + 2 adjudicator. **Zero retries, zero ERROR envelopes** (1 envelope
  per call).
- `FIRST-PASSES.jsonl` = **64** rows: **62 SCORED**, **2 UNANALYZABLE-CENSUS**.
- `READ-LINEAGE.jsonl` = **66** rows. Firebreak = **PASS** (`reads_checked` 66, all
  `synthetic-calibration-example`).

**Census reconciliation — n_census = 4, ALL via the option-a null/empty-content boundary:**

| Example | Censused call | Model | HTTP | finish | content | reason |
|---|---|---|---|---|---|
| EXAMPLE-24 | rater-b (first pass) | `z-ai/glm-5.2` | 200 | length | null | `null-or-empty-content`; reasoning_tokens 1024/1024 |
| EXAMPLE-26 | rater-a (first pass) | `openai/gpt-5.5` | 200 | length | null | `null-or-empty-content`; reasoning_tokens 1024/1024 |
| EXAMPLE-16 | adjudicator | `deepseek/deepseek-v4-pro` | 200 | length | null | `null-or-empty-content`; reasoning 4771 chars, 1026 tok |
| EXAMPLE-18 | adjudicator | `deepseek/deepseek-v4-pro` | 200 | length | null | `null-or-empty-content`; reasoning 4871 chars, 1024 tok |

All four are the *same* condition attempt-01 crashed on (a reasoning model exhausting the 1024-token
budget on reasoning, emitting empty content). The option-a patch censused each instead of crashing.
An example with any censused first-pass OR censused adjudication call is `UNANALYZABLE-CENSUS` and is
excluded from reliability (`run_calibration.py:690`). Hence 32 examples − 4 census = **28 analyzable**
per family, matching the report's `n_census: 4` and `n: 28`.

## 4. The 2 deepseek-v4-pro calls — reconciled from evidence (charge §2)

The summary reads `adjudication_count: 0`, yet `raw/` holds 2 deepseek envelopes. **What they were,
from the envelopes and `ADJUDICATIONS.jsonl`, not a guess:**

- Both are `role: adjudicator`, model `deepseek/deepseek-v4-pro`, `attempt 0`. They were triggered by
  `|a−b| > 1` first-pass disagreements on **`unsupported_assertions`**:
  - EXAMPLE-16 (`ASG-c272ceceefd5`): rater-A `unsupported_assertions=2`, rater-B `=0` (|diff|=2).
    gen id `gen-1784319351-B0oZv03v9CA8EcVuBxe5`.
  - EXAMPLE-18 (`ASG-ff571c5eb6ee`): rater-A `=0`, rater-B `=2` (|diff|=2).
    gen id `gen-1784319371-XfK4mX0e8bOvQlD9qvAx`.
- Both adjudicator calls returned HTTP 200 with `finish_reason=length` and **`content=null`** (the
  entire completion budget spent on reasoning). Per the option-a boundary they routed to
  `CENSUS_NULL_CONTENT` → the example became `UNANALYZABLE-CENSUS`, an `ADJUDICATIONS.jsonl` row was
  written with `disposition: CENSUS, values: {}`, and the code `continue`d **before** the
  `adjudication_count += 1` (`run_calibration.py:653-661` vs `:666`).
- **Therefore `adjudication_count: 0` is correct:** two adjudication calls were *made*, but zero
  adjudications *resolved* (both censused). The count tracks resolved adjudications, not calls.
  `ADJUDICATIONS.jsonl` = 2 rows, both `disposition: CENSUS` — consistent.

## 5. Exhibited per-family counts (independent recompute vs runner — PLUMB's rule)

Recomputed from scratch (my own `Fraction` arithmetic over the 28 analyzable first-pass pairs; census
set derived independently from `FIRST-PASSES.jsonl` non-SCORED rows + `ADJUDICATIONS.jsonl` CENSUS
rows). Frozen floor = **agreement ≥ 0.80 AND kappa ≥ 0.60** (κ defined for all four).

| Family | n | agreement (mine) | kappa (mine) | q | floor met | runner report |
|---|---|---|---|---|---|---|
| unsupported_assertions | 28 | 26/28 = 0.928571 | 55/62 = 0.887097 | 5 | **YES** | agr 13/14, κ 55/62 — MATCH |
| scope_errors | 28 | 28/28 = 1.000000 | 1/1 = 1.000000 | 3 | **YES** | agr 1/1, κ 1/1 — MATCH |
| version_errors | 28 | 28/28 = 1.000000 | 1/1 = 1.000000 | 4 | **YES** | agr 1/1, κ 1/1 — MATCH |
| residue_erasures | 28 | 28/28 = 1.000000 | 1/1 = 1.000000 | 4 | **YES** | agr 1/1, κ 1/1 — MATCH |

Cohen `pe` (mine) also matches the report rational-for-rational: UA 18/49, SE 255/392, VE 201/392,
RE 117/196. No degenerate marginals; κ defined in every family (runner and mine agree). Overall =
ELIGIBLE (all four ELIGIBLE — `run_calibration.py:701`).

## 6. Cost

Recomputed from every envelope's `usage.cost`: **USD 0.545625** total (66 calls).
- `openai/gpt-5.5`: 32 calls, $0.475470
- `z-ai/glm-5.2`: 32 calls, $0.065015
- `deepseek/deepseek-v4-pro`: 2 calls, $0.005140

Matches the coordinator's provider-confirmed figure ($0.5456). Far under the GATE-WALK-R12 USD 1
bound; USD 2 STOP never approached.

## 6a. Deposition honesty — what this ELIGIBLE does and does not rest on

- The two adjudicator censuses removed two *genuine* `unsupported_assertions` first-pass
  disagreements (|a−b|=2) from that family's reliability pool. This is exactly the frozen,
  pre-registered census-exclusion rule (`run_calibration.py:690`) and the census fired **content-blind**
  (on deepseek emitting null tokens, not on the disagreement's direction) — it is not a manipulation.
- **Robustness check (not the frozen computation; a sensitivity note):** had the adjudicator returned
  content, EXAMPLE-16/18 would enter the pool as disagreements ⇒ `unsupported_assertions` n=30,
  agreement 26/30 = 0.866667, kappa = 0.790941. **Still ELIGIBLE** (≥0.80 and ≥0.60). The verdict does
  not depend on the census artifact; it clears the floor either way, with margin.
- This record cannot prove the *live* raters are reliable in general — only that on this frozen
  synthetic packet, first-pass agreement and Cohen's κ cleared the frozen floors on all four families.

## 7. VERDICT

**ELIGIBLE.** Independent recomputation matches the runner's `CALIBRATION-REPORT.json` on every family
and every rational; all four primary defect families meet the frozen reliability floor
(agreement ≥ 0.80 AND kappa ≥ 0.60); firebreak PASS; cost verified; the 2 deepseek calls and the
4-example census fully reconciled. The only discrepancy found is in the *briefing* (the "zero
null-content / option-a never fired" claim, corrected in §0), not between my recomputation and the
runner's summary — so this is ELIGIBLE, not BLOCK.

---

*Signed: TALLY (Claude Opus subagent), 2026-07-17. Coordinator: Claude Fable 5.*
