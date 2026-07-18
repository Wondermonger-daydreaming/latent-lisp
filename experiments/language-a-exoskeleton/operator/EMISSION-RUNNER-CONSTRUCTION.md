# Emission-Runner Construction Notes

**Builder:** WRIGHT (additive-successor construction pass)
**Authority:** ruling R14, `operator/owner-decisions/OWNER-312-EMISSION-AUTHORIZED-v1.json`
(`record_digest sha256:11df083cfc5dd5dad89230f00c25c5ff3f84e93b1843b8750b3e164bd00c527c`,
digest re-validated in-session via `harness/preauthorship.py:validate_record_digest`).
**Scope:** ADDITIVE ONLY — three new files, zero existing files modified. The
manifest rebuild, emission-candidate commit, two fresh receipts, and the live
firing all belong to later hands, per R14's ordering.

This document is content-free (no item task text, no source text, no rendered
request bodies). It cites digests, byte counts, and gate names only.

> **The sections below describe the ORIGINAL R14 construction. The R15 route
> repair (2026-07-18) is recorded in §0; the FARRIER-II pre-spend census-mirror
> repair (2026-07-18) is recorded in §0b. Together they update the tables in §1,
> §2, §3, §4, §6, §8. Where §0/§0b and a later section disagree, §0/§0b govern.**

---

## 0. R15 route repair (2026-07-18)

**Repair hand:** FARRIER.
**Authority:** ruling R15, `operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json`
(`record_digest sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`,
`canonical_byte_length 6241`; digest re-validated in-session via
`harness/preauthorship.py:validate_record_digest`).
**Scope:** confined to THIS ARC'S OWN R14-construction files — `provider_live_emission.py`,
`run_emission.py`, `test_emission_gates.py`, this notes file — plus the rebuilt
manifest pair. Every pre-R14 frozen artifact stays byte-untouched. NO provider
contact: the entire proof is offline (`MockProvider`); the real firing and its
fresh receipts belong to a later hand.

### Why (three verified direct-route failures, quoted from R15 `attempt_01_record`)
> *"honest stop, 2 calls, $0.000000 billed, census committed at e8d694b; root
> causes verified by owner-authorized probes: Anthropic-direct 404 =
> API-id/label mismatch; OpenAI-direct 429 insufficient_quota; Moonshot-direct
> 401 authentication_error"*

R15 replaces the three direct routes with the lab's funded, sandbox-verified
**single OpenRouter route** for all three subjects.

### What changed
- **Adapters:** the three direct adapters (`AnthropicDirectAdapter`,
  `OpenAIAdapter`, `MoonshotKimiAdapter`) are replaced by ONE
  `OpenRouterAdapter` → `POST https://openrouter.ai/api/v1/chat/completions`,
  `Authorization: Bearer OPENROUTER_API_KEY` (read from
  `/home/gauss/Claude-Code-Lab/.env`, never printed), parameterized by the three
  R15 `amended_subject_routes` model ids:
  `claude-haiku-4.5 → anthropic/claude-haiku-4.5`,
  `gpt-5.6-luna → openai/gpt-5.6-luna`,
  `kimi-k3 → moonshotai/kimi-k3`. The runner reads the subject → model-id map
  **from the R15 record itself** (single source of truth); the module constant is
  a drift guard (`build_adapter` refuses a disagreeing id).
- **Output cap:** `max_tokens = 768` hard cap retained. **OpenRouter accepts
  `max_tokens` for all three routes, so the OpenAI-direct `max_completion_tokens`
  concern is OBSOLETE on this route** — one output-cap field for every subject.
- **Preserved unchanged:** `temperature 0`; full envelope capture; the
  `TransportError` classification (retryable = connect/timeout/5xx/429); the
  determinate null-content handling (a null/empty 200 is a `NULL_CONTENT` census
  entry, never retried — the kimi-k3 reasoning-exhaustion idiom lands here).
- **NEW — serving-provider capture (R15 `serving_provider_rule`):** every call's
  serving provider (OpenRouter's top-level `provider` field) is recorded into the
  census (`serving_provider`) beside `model_id_returned`. Serving-provider
  identity on OpenRouter is dynamic (the haiku probe was served by Bedrock);
  family identity is declared at the MODEL level, the serving level is recorded
  as an actual, not resolved.
- **Price basis (R15 `amended_price_basis`):** haiku `1.00/5.00`, luna
  `1.00/6.00`, **kimi-k3 repriced free → `3.00/15.00` USD/MTok** (the Moonshot
  coding plan seat became a paid OpenRouter seat). kimi-k3 is now the most
  expensive on BOTH axes, so the worst-case model's two max-rate constants move
  to `MAX_IN_RATE = 3.00`, `MAX_OUT_RATE = 15.00` — **method unchanged** (same
  r6 "paranoid_upper": measured input bytes/call from the frozen renderer + 768
  output cap, every call reserved at the single most-expensive rate).
- **Authorization gate:** `gate_r14_record` → `gate_r15_record` — validates the
  R15 record digest, pins it, checks `ruling == "R15"`, the OpenRouter route, the
  `hold:no-scoring-no-key-exposure-no-merge` boundary, and exactly three amended
  subject routes; enforces R15's window **per call**. The old R14 gate is
  SUPERSEDED (R14's emission clause expired by its own route-change condition).

### R15 run window (enforced per call)
`2026-07-18T04:59:07Z` (open) .. `2026-07-18T16:59:07Z` (close); ODR-41 carried
(any subject release / serving-route withdrawal / price change inside the window
⇒ stop + successor freeze).

### New worst-case reservation (recomputed BYTE-EXACT by this repair hand)
**USD 5.944873** vs the unchanged **USD 8.00** ceiling (well under). Delta vs the
pre-R15 r6 basis (2.246177): **+3.698696** — entirely the kimi-k3 repricing.
Byte-exact recomputation (frozen byte census: total 527604, max 3175):

| Term | Formula | USD |
|------|---------|-----|
| scheduled input | `527604 × 1.05 × 3.00 / 1e6` | 1.661953 |
| scheduled output | `312 × 768 × 15.00 / 1e6` | 3.594240 |
| retry-reserve input | `32 × 3175 × 1.05 × 3.00 / 1e6` | 0.320040 |
| retry-reserve output | `32 × 768 × 15.00 / 1e6` | 0.368640 |
| **worst-case total** | sum (ROUND_HALF_EVEN, 6dp) | **5.944873** |

> R15's parenthetical estimate was `~2.4`; that figure did not carry the kimi
> repricing through the max-rate model. R15 explicitly delegates the byte-exact
> recompute to the repair hand — **5.944873** is the honest figure, still far
> under 8.00. (Recorded here per the ruling's instruction.)

### R15 teeth + dry-run (offline, `MockProvider`, no network, no keys)
`python3 harness/test_emission_gates.py` → **15/15 PASS**, exit 0 *(FARRIER's R15
pass; FARRIER-II §0b later raised this to **17/17** — the current figure)*.
`python3 harness/run_emission.py --dry-run --evidence-dir <OUTSIDE-repo dir>`
→ 312/312 rendered & emitted, worst-case **USD 5.944873**, attempts 312/344,
0 retries; every census row carries `serving_provider`, `openrouter_model_id`,
and the OpenRouter route. A plain dry-run (no `--in-repo-census-dir`) writes
NOTHING into the repo. *(FARRIER-II, §0b, later made the in-repo mirror
writable in dry-run when `--in-repo-census-dir` is explicitly given, so the
mirror path is offline-provable — content-free, per-attempt scoped.)*

---

## 0b. FARRIER-II pre-spend census-mirror repair (2026-07-18)

**Repair hand:** FARRIER-II.
**Authority:** ruling R15 (same record as §0; construction-repair license R15,
`record_digest sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`,
re-validated in-session via `harness/preauthorship.py:validate_record_digest`).
**Scope:** `harness/run_emission.py`, `harness/test_emission_gates.py`, this notes
file, plus the rebuilt manifest pair. NO provider contact; offline proof only.
`evidence/emission-312/` (attempt-01's frozen record) stays **byte-untouched** —
verified `git status` clean after the proof runs.

### The defect (EMITTER-III's walk-forward, quoted)
EMITTER-III walked the re-emission recipe forward as a fresh hand and found the
runner's **LIVE-only in-repo census mirror** (`run_emission.py` `_write_census`
→ `util.write_new_bytes` with `O_CREAT|O_EXCL`) crashes with `FileExistsError`
**AFTER the emission loop** — *post-spend* — because attempt-01's frozen census
already occupies `evidence/emission-312/{EMISSION-CENSUS.json,EMISSION-ACTUALS.json,RUN-RECORD.md}`.
No receipt could see it: **the mirror never runs offline**, so the failure class
was invisible to every dry-run and every clean-room receipt. The
never-overwrite `O_CREAT|O_EXCL` instinct was *correct* — it just fired too late
to protect the spend.

### The repair (three moves)
1. **PRE-SPEND GATE `InRepoCensusTargetOccupied`** — a new named refusal run in
   the **PREFLIGHT** phase (`preflight` → `gate_in_repo_census_target`),
   alongside the bank/schedule/window/spend/R15-record gates, **before any
   provider contact**, in **both** `--dry-run` and `--live` (so it is testable
   offline). If any of the three scoped mirror targets already exists, it refuses
   with the occupying path as the witness.
2. **PER-ATTEMPT SCOPING** — the in-repo mirror now lands in a subdir
   `<--in-repo-census-dir>/<basename of --evidence-dir>` (e.g.
   `evidence/emission-312/live-attempt-02/`). Attempt-01's **root-level** files
   are therefore never write targets — only a *re-run into the same attempt dir*
   is refused. `write_new_bytes O_CREAT|O_EXCL` is retained (the instinct was
   right); the gate simply moves the verdict before the spend.
3. **OFFLINE-PROVABLE MIRROR** — the mirror write now fires in dry-run too when
   `--in-repo-census-dir` is supplied (content-free only), closing the gap that
   made the failure class unobservable.

### Teeth (planted → fires → clean)
`python3 harness/test_emission_gates.py` → **17/17 PASS** (was 15/15). Two added:
- **#16 occupied scoped target → `InRepoCensusTargetOccupied` PRE-SPEND** — a
  counting provider factory proves the refusal precedes the spend: its emit
  counter is **0** at the refusal (the runner never reached the emission loop).
- **#17 clean scoped path** — a dry-run completes 312/312 and all three
  content-free mirror files land in the per-attempt scoped subdir.

Every prior check (1–15) still green.

### Dry-run proof (offline, `MockProvider`, no network, no keys)
`--dry-run --evidence-dir …/live-attempt-02 --in-repo-census-dir evidence/emission-312`
→ 312/312 rendered & emitted, worst-case **USD 5.944873**, attempts 312/344,
0 retries; the content-free mirror landed at
`evidence/emission-312/live-attempt-02/` (three files: EMISSION-CENSUS.json,
EMISSION-ACTUALS.json, RUN-RECORD.md). A re-run into that now-occupied subdir was
**refused in preflight** with `InRepoCensusTargetOccupied` (exit 1), no spend.
All proof artifacts were removed afterward; `evidence/emission-312/` root
byte-untouched.

---

## 1. What was built

| File | Lines | Role |
|------|-------|------|
| `harness/provider_live_emission.py` | 375 (R15) | ~~Three live provider adapters~~ **one `OpenRouterAdapter` (R15, §0)** + offline `MockProvider` + global transport-retry contract. The ONLY network-capable code in the packet. |
| `harness/run_emission.py` | 711 (R15 + FARRIER-II §0b) | Single live entrypoint: preflight refusal gates (incl. the pre-spend in-repo census-mirror gate), subject binding, byte-exact rendering (delegated to the frozen renderer), worst-case reservation ledger, evidence custody + per-attempt scoped in-repo mirror, `--dry-run` / `--live` modes. |
| `harness/test_emission_gates.py` | 290 (R15) | Teeth checks: each gate planted-to-fire then clean-to-pass; runs fully offline. |

The runner is the live-capable successor the pre-registration contemplates
(`PREREG-v0.2.md:75` — "The live-capable successor runner ... must refuse before
a worst-case reservation exceeds a ceiling").

### Adapters — SUPERSEDED by R15 (see §0)

The original R14 construction had three direct adapters (Anthropic-direct,
OpenAI-direct, Moonshot-direct). **R15 replaced all three with a single
`OpenRouterAdapter`** after all three direct routes failed at attempt-01 (§0).
The current adapter table:

| Subject | Route | Endpoint | Key env | Output-cap field (value 768) |
|---------|-------|----------|---------|------------------------------|
| `claude-haiku-4.5` (`anthropic/claude-haiku-4.5`) | OpenRouter | `POST https://openrouter.ai/api/v1/chat/completions` | `OPENROUTER_API_KEY` | `max_tokens` |
| `gpt-5.6-luna` (`openai/gpt-5.6-luna`) | OpenRouter | (same) | `OPENROUTER_API_KEY` | `max_tokens` |
| `kimi-k3` (`moonshotai/kimi-k3`) | OpenRouter | (same) | `OPENROUTER_API_KEY` | `max_tokens` |

The subject binding (`SYNTHETIC-SUBJECT-N → subject`) still reads the frozen r5
slot `subject-provider-model-routes` (`operator/owner-slots.json`, byte-untouched);
only the ROUTE the subjects go out on changed, per R15. The subject → OpenRouter
model-id map is read from the R15 record itself.

Keys are read from `/home/gauss/Claude-Code-Lab/.env` at call time (split on the
FIRST `=` only — the `KIMI_API_KEY==` double-equals scar), never printed or
written to any artifact. `max_tokens`/output cap is hard-coded to **768** per
attempt (one field for all three subjects on OpenRouter). The full HTTP response
envelope (status, headers, raw body bytes) is captured verbatim into
owner-custody evidence.

---

## 2. Preflight refusal gates (each refuses with a named condition BEFORE any provider contact)

| Gate | Named refusal | Rule |
|------|---------------|------|
| Bank identity | `BankIdentityRefused` | `sha256(items/candidate/target-visible/items.jsonl) == 84cb8673…d3c41` (key-author-input identity, owner-confirmed). |
| Item consistency | `ItemConsistencyRefused` | per item: `task.sha256 == sha256(task.utf8)`; `source_packet_sha256`; `target_surface_sha256 == sha256(task ‖ \0 ‖ packet)`. |
| Schedule | `ScheduleGateRefused` | exactly 312 rows; arm counts `{NL,PERSONA,SCAFFOLD,LANG-A}=72, SHAM=24` (design.json); then the frozen `tranche_b.validate_schedule` binding check. |
| Run window | `RunWindowRefused` | clock read per call; refuse `< 2026-07-18T04:59:07Z` or `>= 2026-07-18T16:59:07Z` (**R15 window**, §0). |
| Spend reservation | `SpendReservationRefused` | refuse the call whose worst-case cumulative reservation would exceed **USD 8.00** (model in §4, R15-repriced in §0). |
| Attempt ceiling | `AttemptCeilingRefused` | absolute **344** attempts (initial + transport retries). |
| Transport budget | `TransportBudgetExhausted` | **≤32** transport retries total; exhaustion stops the run honestly with a partial census. |
| R15 record (was R14) | `R15RecordRefused` | `validate_record_digest(R15)` + pinned digest `fb40c815…` + `ruling==R15` + OpenRouter route + `hold:no-scoring-no-key-exposure-no-merge` + exactly 3 amended subject routes; window enforced per call (§0). |
| Subject binding | `SubjectBindingRefused` | r5 slot resolved and lists exactly 3 subjects. |
| In-repo census target (FARRIER-II, §0b) | `InRepoCensusTargetOccupied` | when a mirror dir is in play (both modes): refuse if any of the 3 scoped targets `<--in-repo-census-dir>/<basename of --evidence-dir>/{EMISSION-CENSUS.json,EMISSION-ACTUALS.json,RUN-RECORD.md}` already exists — **pre-spend**, witness = occupying path. |

**Subject binding rule (recorded as emission-actual):** `SYNTHETIC-SUBJECT-N` →
r5 record's own value-array `value[N-1]` (ordinal `N` parsed from the slot name).
Yields `SUBJECT-1→claude-haiku-4.5 (Anthropic direct)`,
`SUBJECT-2→gpt-5.6-luna (OpenAI API)`, `SUBJECT-3→kimi-k3 (Moonshot coding)`.

### Transport / null-content contract
- Retryable class only: connect/read timeout, HTTP 5xx, HTTP 429 — exponential
  backoff, drawn from the global ≤32 budget.
- Any HTTP 200 with a parseable envelope is **FINAL** for the call.
- A null/empty-content 200 is a determinate **`NULL_CONTENT`** census entry,
  **never retried** (the option-(a) idiom; aligns with `SCORING-CONSTITUTION.md`
  T11 "empty response → SCORE-ZERO-DISCHARGE, analyzable", full fixed denominator).
- Non-429 4xx is a determinate, non-retryable envelope (recorded, not retried).

---

## 3. Teeth-check results (planted fault → shown to fire, then clean pass)

Run: `python3 harness/test_emission_gates.py` → **17/17 PASS** under R15 (§0) +
FARRIER-II (§0b), exit 0. (Was 13/13 under R14; +2 for the R15 shape → 15/15;
+2 for the FARRIER-II pre-spend census-mirror gate → 17/17.)

| # | Check | Planted fault | Fired | Clean |
|---|-------|---------------|-------|-------|
| 1 | bank-identity | tampered items.jsonl | `BankIdentityRefused` | ✓ |
| 2 | schedule oversized | 313 rows | `ScheduleGateRefused` | ✓ |
| 3 | schedule mutated binding | swapped two item_ids (counts intact) | `ScheduleGateRefused` | ✓ |
| 4 | run-window past close | clock = window close | `RunWindowRefused` | ✓ |
| 5 | run-window before open | clock = open − 1s | `RunWindowRefused` | ✓ |
| 6 | spend overflow | worst-case call >> 8.00 | `SpendReservationRefused` (pre-contact) | ✓ |
| 7 | attempt ceiling | attempt 345 | `AttemptCeilingRefused` | ✓ |
| 8 | **R15** record tampered | mutated in-memory copy | `R15RecordRefused` | ✓ |
| 9 | item consistency | bad task digest | `ItemConsistencyRefused` | ✓ |
| 10 | subject binding | r5 with 2 subjects | `SubjectBindingRefused` | ✓ |
| 11 | null-content | MockProvider null envelope (finish_reason `length`, reasoning-exhaustion idiom) | determinate entry, **0 retries**, run continues 312/312 | ✓ |
| 12 | transport exhaustion | MockProvider always-fail | honest stop, **32 retries**, partial census | ✓ |
| 13 | clean full dry-run | — | 312/312, worst-case **USD 5.944873** `< 8.00` | ✓ |
| 14 | **serving-provider capture** (R15) | — | `serving_provider` + `openrouter_model_id` + OpenRouter route land in all mock census rows | ✓ |
| 15 | **price-table worst-case** (R15) | — | `MAX_IN/OUT_RATE = 3.00/15.00`, byte-exact recompute **5.944873 < 8.00** | ✓ |
| 16 | **in-repo census gate: occupied scoped target** (FARRIER-II) | one of 3 scoped mirror files pre-created | `InRepoCensusTargetOccupied` **pre-spend** (counting factory: emit-counter **0** at refusal) | ✓ |
| 17 | **in-repo census scoping: clean path** (FARRIER-II) | — | dry-run 312/312 + all 3 content-free mirror files land in the per-attempt scoped subdir | ✓ |

---

## 4. Dry-run proof numbers (full pipeline, MockProvider, no network)

Run: `python3 harness/run_emission.py --dry-run --evidence-dir <OUTSIDE-repo dir>`

- **Rendering completeness:** 312/312 rendered; 312 census records; 312 distinct
  per-call payload digests.
- **Byte census (byte-exact, from the frozen `compose_payload`):**
  total payload bytes **527604**, max **3175**.
- **Worst-case reservation (R15-repriced, §0):** **USD 5.944873** vs the unchanged
  **USD 8.00** ceiling; delta vs the pre-R15 r6 basis (2.246177) is **+3.698696**
  (all from the kimi-k3 repricing). *(The original R14 figure below — USD 2.245816
  at the old rates — is retained for the byte-provenance note only.)*
- **Attempts** 312/344, **transport retries** 0.

### Reservation model (same r6 "paranoid_upper" method; R15 max-rate constants, §0)
- input reservation/call = `payload_bytes × 1.0 tok/byte × 1.05 × MAX_IN_RATE(3.00/MTok, R15)`
- output reservation/call = `768 × MAX_OUT_RATE(15.00/MTok, R15)`
- retry reserve (constant, worst case all 32 retries resend the largest prompt) =
  `32×max_bytes×1.0×1.05×3.00/MTok + 32×768×15.00/MTok`
- gate: refuse a scheduled call if `retry_reserve + cumulative_scheduled + this_call > 8.00`.
  Actual transport retries draw down the pre-reserved retry budget (already
  worst-cased) — they consume the attempt/retry ceilings, never new spend.
- worst-case total after a clean 312-call run = `retry_reserve + cumulative_scheduled`.

### Why the −0.000361 delta (contested step, shown not claimed)
The r6 `census.py` analytic byte formula used `len("{{SOURCE_PACKET}}") = 16`;
the placeholder is **17 bytes** (`{{`+`SOURCE_PACKET`(13)+`}}` = 17). The r6
formula therefore over-counted scheduled input by exactly **1 byte/call**
(312 bytes total; max 3176 vs the true 3175). This runner reserves against the
**actual bytes emitted by the frozen renderer** (`compose_payload`), so its
worst case (2.245816) is byte-exact and **strictly below** the r6 figure — the
safe direction (never under-reserving; 1.0 tok/byte remains an input-token upper
bound). Verified: `527916 − 527604 = 312`.

---

## 5. Rendering-source ambiguity (flagged, resolved from the frozen docs — not guessed)

The task named `prompts/` ("arm prompt files") and
`items/candidate/control-plane/rendering-obligations.jsonl` as rendering inputs.
The **frozen** rendering contract, however, binds each schedule row's
`template_sha256` / `system_sha256` / `wrapper_sha256` /
`template_manifest_sha256` to `tranche-b/templates/` via the immutable renderer
`lae-immutable-renderer/1.0.0`
(`tranche_b.AUTHORITATIVE_TEMPLATE_MANIFEST_SHA256 = 5a8b82e2…`). The two copies
**differ by digest** — e.g. LANG-A row `template_sha256 = 12d8b67c…` matches
`tranche-b/templates/LANG-A.txt`, **not** `prompts/LANG-A.txt` (`c201d70f…`).

**Resolution:** render via the frozen `tranche-b/templates/` contract
(`tranche_b.compose_payload` + `validate_schedule`). Using `prompts/*.txt` would
produce different bytes and fail the frozen schedule binding and every recorded
digest, and would not reproduce the r6 census. `prompts/` is an earlier, separate
arm-prompt copy the frozen renderer does not consume. The rendering-obligation is
honored through each row's `rendering_obligation_sha256` (validated inside
`load_public_bank` / `validate_schedule`).

---

## 6. Evidence-custody split

| Location | Kind | Written by |
|----------|------|-----------|
| `/home/gauss/Codex-Lab/emission-312-evidence/` (**OUTSIDE the repo**) | content-bearing: `payloads/*.bin` (rendered prompts), `raw-responses/*.bin` + `*.meta.json` (full provider envelopes), `requests/*.json`, plus census/actuals/run-record copies | the runner (dry-run writes here only) |
| `experiments/language-a-exoskeleton/evidence/emission-312/<attempt>/` (**in repo**, per-attempt scoped — FARRIER-II §0b) | content-free ONLY: `EMISSION-CENSUS.json` (call id, arm, item id, subject, timestamps, http status, finish reason, token counts, cost, envelope sha256 — no text), `RUN-RECORD.md`, `EMISSION-ACTUALS.json` (settings, per-provider tokenizer census, retention/cache disclosures) | the run given `--in-repo-census-dir`, into subdir `<basename of --evidence-dir>` (e.g. `live-attempt-02/`) — `--live` for the real record; `--dry-run` too, for offline proof (content-free) |

The public tree may carry no item content or target outputs, so all
content-bearing artifacts stay in owner-custody local storage and are never
committed. A plain dry-run (no `--in-repo-census-dir`) writes **nothing** into
the repo; a dry-run *with* the flag writes only the content-free mirror into a
per-attempt scoped subdir. The FARRIER-II proof runs wrote a scoped mirror and
then removed it — `evidence/emission-312/` root stayed byte-untouched (attempt-01's
frozen record). **Attempt dirs must be fresh:** a re-run into an occupied scoped
subdir is refused pre-spend (`InRepoCensusTargetOccupied`, §0b).

---

## 7. One-renderer / one-emitter exclusivity

- **R14:** `git diff --stat` over the packet was empty — a purely additive
  construction. **R15 (§0):** the diff touches exactly the four THIS-ARC
  construction files (`provider_live_emission.py`, `run_emission.py`,
  `test_emission_gates.py`, this notes file) plus the rebuilt manifest pair.
  Every FROZEN pre-R14 artifact — `run.py`, `provider_dry_run.py`, `manifest.py`,
  `tranche_b.py`, `tests/`, `prompts/`, `items/`, `tranche-b/`, `evidence/**`,
  and `operator/owner-slots.json` (the r5 slot) — stays **byte-untouched**.
- `provider_live_emission` (the only network-capable module) is imported **only**
  by `run_emission.py` (the sole live entrypoint) and by `test_emission_gates.py`
  (which uses `MockProvider` alone — no network). **No frozen file imports it.**
- `run_emission` is imported only by its own teeth-check.
- Rendering has one authority: the frozen `tranche_b.compose_payload`; the runner
  adds no second renderer (the R15 repair changed only the ROUTE, never the
  rendering contract).

---

## 8. Handoff (later hands, per R15 ordering — carried forward from R14 unchanged)

1. Rebuild `CONSTRUCTION-MANIFEST` after these bytes are final. *(Done by FARRIER
   for the R15 repair; a later edit re-does it.)*
2. Commit the REPAIRED emission candidate; obtain **two fresh independent
   clean-room receipts** at that exact candidate **before any provider contact**
   (R15 carries R14's receipts-before-contact requirement forward unchanged).
3. Inside the **R15** run window (`2026-07-18T04:59:07Z .. 16:59:07Z`), run
   `--live --evidence-dir <outside>/<attempt> --in-repo-census-dir
   experiments/language-a-exoskeleton/evidence/emission-312` to emit and record.
   **The live-invocation flags are UNCHANGED** — `--live`, `--evidence-dir`,
   `--in-repo-census-dir` all still hold (same flags, confirmed against the
   repaired `run_emission.py` CLI). **FARRIER-II (§0b) changed only where the
   in-repo mirror LANDS:** it is written to the per-attempt scoped subdir
   `evidence/emission-312/<basename of --evidence-dir>/` (e.g. an `--evidence-dir`
   ending in `live-attempt-02` → mirror at `evidence/emission-312/live-attempt-02/`),
   so attempt-01's root-level frozen record is never a write target. **The attempt
   dir must be FRESH** — a re-run into an occupied scoped subdir is refused
   PRE-SPEND with `InRepoCensusTargetOccupied` (no provider contact), instead of
   the old post-spend `FileExistsError`. Provider-actual confirmations still owed at
   emission: exact per-provider tokenizer census, the **serving provider per call**
   (R15 `serving_provider_rule` — now captured into the census automatically), and
   retention/cache disclosures (recorded-as-deferred per Erratum-01 / GATE-WALK-R12).
   The OpenAI output-cap field concern is retired: OpenRouter takes `max_tokens`
   for all three (§0).
