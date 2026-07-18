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

---

## 1. What was built

| File | Lines | Role |
|------|-------|------|
| `harness/provider_live_emission.py` | 365 | Three live provider adapters + offline `MockProvider` + global transport-retry contract. The ONLY network-capable code in the packet. |
| `harness/run_emission.py` | 613 | Single live entrypoint: preflight refusal gates, subject binding, byte-exact rendering (delegated to the frozen renderer), worst-case reservation ledger, evidence custody, `--dry-run` / `--live` modes. |
| `harness/test_emission_gates.py` | 243 | Teeth checks: each gate planted-to-fire then clean-to-pass; runs fully offline. |

The runner is the live-capable successor the pre-registration contemplates
(`PREREG-v0.2.md:75` — "The live-capable successor runner ... must refuse before
a worst-case reservation exceeds a ceiling").

### Adapters (r5 slot `subject-provider-model-routes`, `operator/owner-slots.json`)

| Subject | Route | Endpoint | Key env | Output-cap field (value 768) |
|---------|-------|----------|---------|------------------------------|
| `claude-haiku-4.5` | Anthropic direct | `POST https://api.anthropic.com/v1/messages` | `ANTHROPIC_API_KEY` | `max_tokens` |
| `gpt-5.6-luna` | OpenAI API | `POST https://api.openai.com/v1/chat/completions` | `OPENAI_API_KEY` | `max_completion_tokens` |
| `kimi-k3` | Moonshot coding (Anthropic-compatible) | `POST https://api.kimi.com/coding/v1/messages` | `KIMI_API_KEY` | `max_tokens` |

Keys are read from `/home/gauss/Claude-Code-Lab/.env` at call time (split on the
FIRST `=` only — the `KIMI_API_KEY==` double-equals scar), never printed or
written to any artifact. `max_tokens`/output cap is hard-coded to **768** per
attempt. The full HTTP response envelope (status, headers, raw body bytes) is
captured verbatim into owner-custody evidence.

---

## 2. Preflight refusal gates (each refuses with a named condition BEFORE any provider contact)

| Gate | Named refusal | Rule |
|------|---------------|------|
| Bank identity | `BankIdentityRefused` | `sha256(items/candidate/target-visible/items.jsonl) == 84cb8673…d3c41` (key-author-input identity, owner-confirmed). |
| Item consistency | `ItemConsistencyRefused` | per item: `task.sha256 == sha256(task.utf8)`; `source_packet_sha256`; `target_surface_sha256 == sha256(task ‖ \0 ‖ packet)`. |
| Schedule | `ScheduleGateRefused` | exactly 312 rows; arm counts `{NL,PERSONA,SCAFFOLD,LANG-A}=72, SHAM=24` (design.json); then the frozen `tranche_b.validate_schedule` binding check. |
| Run window | `RunWindowRefused` | clock read per call; refuse `< 2026-07-18T02:43:55Z` or `>= 2026-07-18T14:43:55Z` (window read from R14). |
| Spend reservation | `SpendReservationRefused` | refuse the call whose worst-case cumulative reservation would exceed **USD 8.00** (model in §4). |
| Attempt ceiling | `AttemptCeilingRefused` | absolute **344** attempts (initial + transport retries). |
| Transport budget | `TransportBudgetExhausted` | **≤32** transport retries total; exhaustion stops the run honestly with a partial census. |
| R14 record | `R14RecordRefused` | `validate_record_digest(R14)` + pinned digest + `ruling==R14` + boundary set + window match. |
| Subject binding | `SubjectBindingRefused` | r5 slot resolved and lists exactly 3 subjects. |

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

Run: `python3 harness/test_emission_gates.py` → **13/13 PASS**, exit 0.

| # | Check | Planted fault | Fired | Clean |
|---|-------|---------------|-------|-------|
| 1 | bank-identity | tampered items.jsonl | `BankIdentityRefused` | ✓ |
| 2 | schedule oversized | 313 rows | `ScheduleGateRefused` | ✓ |
| 3 | schedule mutated binding | swapped two item_ids (counts intact) | `ScheduleGateRefused` | ✓ |
| 4 | run-window past close | clock = window close | `RunWindowRefused` | ✓ |
| 5 | run-window before open | clock = open − 1s | `RunWindowRefused` | ✓ |
| 6 | spend overflow | worst-case call >> 8.00 | `SpendReservationRefused` (pre-contact) | ✓ |
| 7 | attempt ceiling | attempt 345 | `AttemptCeilingRefused` | ✓ |
| 8 | R14 record tampered | mutated in-memory copy | `R14RecordRefused` | ✓ |
| 9 | item consistency | bad task digest | `ItemConsistencyRefused` | ✓ |
| 10 | subject binding | r5 with 2 subjects | `SubjectBindingRefused` | ✓ |
| 11 | null-content | MockProvider null envelope | determinate entry, **0 retries**, run continues 312/312 | ✓ |
| 12 | transport exhaustion | MockProvider always-fail | honest stop, **32 retries**, partial census | ✓ |
| 13 | clean full dry-run | — | 312/312, worst-case in the ~2.246 band | ✓ |

---

## 4. Dry-run proof numbers (full pipeline, MockProvider, no network)

Run: `python3 harness/run_emission.py --dry-run --evidence-dir <OUTSIDE-repo dir>`

- **Rendering completeness:** 312/312 rendered; 312 census records; 312 distinct
  per-call payload digests.
- **Byte census (byte-exact, from the frozen `compose_payload`):**
  total payload bytes **527604**, max **3175**.
- **Worst-case reservation:** **USD 2.245816** vs r6-recorded **USD 2.246177**,
  delta **−0.000361** — root-caused below. Both far under the USD 8.00 ceiling.
- **Attempts** 312/344, **transport retries** 0.

### Reservation model (byte-for-byte the r6 offline census, `evidence/cost-census/cost.py` "paranoid_upper")
- input reservation/call = `payload_bytes × 1.0 tok/byte × 1.05 × MAX_IN_RATE(1.00/MTok)`
- output reservation/call = `768 × MAX_OUT_RATE(6.00/MTok)`
- retry reserve (constant, worst case all 32 retries resend the largest prompt) =
  `32×max_bytes×1.0×1.05×1.00/MTok + 32×768×6.00/MTok`
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
| `experiments/language-a-exoskeleton/evidence/emission-312/` (**in repo**) | content-free ONLY: `EMISSION-CENSUS.json` (call id, arm, item id, subject, timestamps, http status, finish reason, token counts, cost, envelope sha256 — no text), `RUN-RECORD.md`, `EMISSION-ACTUALS.json` (settings, per-provider tokenizer census, retention/cache disclosures) | the **live** run only (`--live --in-repo-census-dir …`), NOT the dry-run, NOT this construction |

The public tree may carry no item content or target outputs, so all
content-bearing artifacts stay in owner-custody local storage and are never
committed. The dry-run of this construction wrote **nothing** into the repo.

---

## 7. One-renderer / one-emitter exclusivity

- `git diff --stat` over the packet is **empty** — no existing file modified;
  `run.py`, `provider_dry_run.py`, `manifest.py`, `tranche_b.py` byte-untouched.
- `provider_live_emission` (the only network-capable module) is imported **only**
  by `run_emission.py` (the sole live entrypoint) and by `test_emission_gates.py`
  (which uses `MockProvider` alone — no network). **No frozen file imports it.**
- `run_emission` is imported only by its own teeth-check.
- Rendering has one authority: the frozen `tranche_b.compose_payload`; the runner
  adds no second renderer.

---

## 8. Handoff (later hands, per R14 ordering)

1. Rebuild `CONSTRUCTION-MANIFEST` after these bytes are final.
2. Commit the emission candidate; obtain **two fresh independent clean-room
   receipts** at that exact candidate **before any provider contact**.
3. Inside the run window, run `--live --evidence-dir <outside> --in-repo-census-dir
   experiments/language-a-exoskeleton/evidence/emission-312` to emit and record.
   Provider-actual confirmations still owed at emission: exact per-provider
   tokenizer census, the OpenAI output-cap field name for `gpt-5.6-luna`, and
   retention/cache disclosures (recorded-as-deferred per Erratum-01 / GATE-WALK-R12).
