# Language-A Tranche B — Prompt Byte Census & $8.00 Ceiling Recomputation

**Auditor:** CENSOR · **Date:** 2026-07-17 · **Discipline:** offline byte census + disclosed conservative
bytes→tokens bound. NO network, NO provider/tokenizer contact. This report contains **numbers and hashes only** —
no byte of item/prompt/source content appears anywhere in it.

**Owner ruling executed (2026-07-17):** OFFLINE byte census + disclosed conservative bytes→tokens bound for the
$8.00 ceiling check; exact provider-tokenizer counts recorded from emission actuals later; no pre-gate provider contact.

---

## 1. Render-path (how a scheduled call's prompt bytes are assembled)

The subject-facing prompt is the **payload** built by `harness/tranche_b.py:compose_payload` (L502–513):

```
rendered_wrapper = wrapper_bytes.replace("{{TASK}}", task).replace("{{SOURCE_PACKET}}", source_packet)
payload          = system_bytes + b"\n" + template_bytes + b"\n" + rendered_wrapper
```

- `source_packet` = `SOURCE_SEPARATOR.join(sources + derived_views)`, where `SOURCE_SEPARATOR = b"\n"`
  (`tranche_b.py:73, 499, 182`).
- The 5 segments are exactly the `segment_origins` the renderer records (`tranche_b.py:699`):
  `["common-system", "selected-template", "common-wrapper", "target-visible-task", "target-visible-source-packet"]`.
- The **envelope** (`make_envelope`, L703) is request-metadata custody, **not** the prompt — it is excluded from
  the prompt byte census. `rendered_payload_record.payload_bytes = len(payload)` (L689) is the authoritative
  per-call prompt byte count, and the harness itself binds it.

**Fixed envelope overhead added by the render code, counted from source (not estimated):**
`+1` byte (system↔template LF) `+1` byte (template↔wrapper LF) `−24` bytes (placeholder delta: `{{TASK}}`=8B and
`{{SOURCE_PACKET}}`=16B are removed when substituted). Net per-call overhead beyond the raw component bytes = `−22`
plus the two literal-wrapper bytes; equivalently:

```
payload_bytes = 173(system) + 1 + template_bytes[arm] + 1 + (46(wrapper) − 8 − 16 + task_bytes + source_packet_bytes)
              = 197 + template_bytes[arm] + task_bytes + source_packet_bytes
```

with `source_packet_bytes = Σ(source content bytes) + Σ(derived-view content bytes) + (n_parts − 1)` LF separators.

### Component location & hash verification (no freezer-only gap)

All five components' bytes are present in the worktree — **nothing is freezer-only for the prompt surface**:

| Component | Source in tree | Bytes | Hash field verified against |
|---|---|---|---|
| system | `tranche-b/templates/common-system.txt` | 173 | `system_sha256` (all 312 rows) |
| wrapper | `tranche-b/templates/wrapper.txt` | 46 | `wrapper_sha256` (all 312 rows) |
| template (per arm) | `tranche-b/templates/{ARM}.txt` | NL127/PERSONA166/SCAFFOLD569/LANG-A541/SHAM184 | `template_sha256` |
| task | `items/candidate/target-visible/items.jsonl` (per item_id) | per item | `task_sha256` |
| source_packet | same file (sources+derived_views) | per item | `source_packet_sha256` |

Additional cross-checks performed and **all passed**: each item's internal `task`/source byte-objects
(bytes+sha256), reconstructed `source_packet_sha256`, `target_surface_sha256` (`task + NUL + packet`), and
`target_visible_item_sha256` (= `sha256(canonical_json_bytes(target record))`) matched the schedule rows.

> **Result: 312/312 rows matched every component hash. 0 unmatched hashes. 0 item byte-object problems.**
> The census is **NOT voided** — every prompt byte is accounted for from on-disk bytes.

---

## 2. Byte census (312 calls)

- **Grand total prompt bytes = 527,916**
- Per-call: min 904 · max 3,176 · mean 1,692.038

### By subject slot (balanced design — all three identical)

| subject_slot | count | total bytes | mean |
|---|---|---|---|
| SYNTHETIC-SUBJECT-1 | 104 | 175,972 | 1,692.038 |
| SYNTHETIC-SUBJECT-2 | 104 | 175,972 | 1,692.038 |
| SYNTHETIC-SUBJECT-3 | 104 | 175,972 | 1,692.038 |

(The three slots are byte-identical and call-count-identical ⇒ the total across routes is **invariant to any
slot→route permutation** for the 312 scheduled calls.)

### By arm

| arm | count | total bytes | mean | min | max |
|---|---|---|---|---|---|
| LANG-A | 72 | 134,424 | 1,867.0 | 1,318 | 3,148 |
| SCAFFOLD | 72 | 136,440 | 1,895.0 | 1,346 | 3,176 |
| NL | 72 | 104,616 | 1,453.0 | 904 | 2,734 |
| PERSONA | 72 | 107,424 | 1,492.0 | 943 | 2,773 |
| SHAM | 24 | 45,012 | 1,875.5 | 1,092 | 2,791 |

Full per-call table: `/tmp/lae-census/per-call-bytes.json` (call_id, subject_slot, arm, item_id, prompt_bytes).

---

## 3. Bytes → tokens bound & ceiling recomputation

Two disclosed conservative bounds. **These are OVER-counts by construction** (a real BPE tokenizer averages well
under 0.5 tok/byte on English; 1.0 tok/byte is an absolute paranoid ceiling).

| Bound | tokens/byte | scheduled input tokens (527,916 B) |
|---|---|---|
| conservative | 0.5 | 263,958 |
| paranoid upper | 1.0 | 527,916 |

**Fixed cost inputs (verified 2026-07-17):**
- attempt_ceiling 344 = 312 scheduled + **32 retries**; output_token_ceiling 264,192 = 344×768 (`harness/run.py:19`).
- output worst case: 768 output tokens/call.
- input allowance multiplier **1.05** (SCORING-R6), applied to the input token bound (incl. retries).
- 32 retries assumed to re-send the **largest** prompt (max = **3,176 B**) on the **most expensive** route.
- rates (USD/M tok): luna in 1.00 / out 6.00; haiku in 1.00 / out 5.00 (no caching benefit assumed); kimi **$0.00**
  marginal (coding subscription).
- most-expensive input rate = **1.00/M**; most-expensive output rate = **6.00/M (luna)**.

### Arithmetic

Retry input bytes = 32 × 3,176 = **101,632 B**.

**Input token bound (with 1.05):**
- conservative: (263,958 + 101,632×0.5) × 1.05 = (263,958 + 50,816) × 1.05 = 314,774 × 1.05 = **330,512.7 tok**
- paranoid: (527,916 + 101,632) × 1.05 = 629,548 × 1.05 = **661,025.4 tok**

**Mapping A — nominal (slot1→haiku, slot2→luna, slot3→kimi).** Per slot: 175,972 B, 104 calls.
Per-slot input tokens (×1.05): conservative 175,972×0.5×1.05 = 92,385.3; paranoid 184,770.6.
- Input (scheduled): (haiku 1.00 + luna 1.00 + kimi 0.00) × per_slot_tok / 1e6
  - conservative: 2 × 92,385.3 / 1e6 = **$0.184771**
  - paranoid: 2 × 184,770.6 / 1e6 = **$0.369541**
- Input (32 retries, adversarially on luna @1.00): conservative 50,816×1.05×1.00/1e6 = **$0.053357**; paranoid 101,632×1.05/1e6 = **$0.106714**
- Output (scheduled 104×768 per slot): (haiku 5.00 + luna 6.00 + kimi 0.00) × 79,872 / 1e6 = 11 × 79,872 / 1e6 = **$0.878592** (both bounds — output is byte-independent)
- Output (32 retries on luna @6.00): 32×768×6.00/1e6 = 24,576×6/1e6 = **$0.147456**
- **Nominal TOTAL: conservative $1.264175 · paranoid $1.502303**

**Mapping B — adversarial upper bound (EVERYTHING on the most expensive route; holds under ANY mapping).**
- Input: total_input_tokens × 1.00/M → conservative 330,512.7/1e6 = **$0.330513**; paranoid 661,025.4/1e6 = **$0.661025**
- Output: all 344 attempts × 768 = 264,192 tok × 6.00/M = **$1.585152**
- **Adversarial TOTAL: conservative $1.915665 · paranoid $2.246177**

### Ceiling verdict

| | nominal mapping | adversarial mapping |
|---|---|---|
| conservative (0.5 tpb) | $1.264175 | $1.915665 |
| paranoid (1.0 tpb) | $1.502303 | **$2.246177** |

**GLOBAL WORST CASE = $2.246177** (paranoid bound × adversarial all-on-luna mapping).
**Spend ceiling = $8.00 → VERDICT: UNDER CEILING.** Headroom **$5.753823** (worst case = **28.1%** of ceiling).
The ceiling holds under every slot→route permutation and under the paranoid 1.0 tok/byte over-count.

---

## 4. Named unknowns (disclosed, not silently absorbed)

1. **Reasoning/thinking tokens on luna & kimi** — NOT provably bounded by the 768 `max_output_tokens` cap; their
   emission/billing treatment is unknown pre-gate. For **haiku**, thinking bills as output tokens and IS bounded by
   the 768 cap (already in the worst case).
2. **Cached-input treatment** — worst case assumes NO caching benefit. (Haiku cache write-5m 1.25 / hit 0.10 would
   only *reduce* input cost; ignoring it is conservative.)
3. **Provider-side chat-envelope / role / BOS / special-token overhead** — beyond the counted payload bytes; not in
   this byte census. Partially absorbed by the 1.0 tpb paranoid bound + 1.05 allowance, but not guaranteed.
4. **Slot→route mapping** (1=haiku, 2=luna, 3=kimi) is an assumption to confirm at preflight; the adversarial arm
   bounds the ceiling regardless.
5. **Item bank state = candidate** (`item_bank_freeze_authorized=false`, `state=candidate-template-bytes-fixed`).
   Census is valid for the fixed-candidate schedule as committed; **recompute if the freeze mutates any component.**

---

## 5. Emission-actuals closure plan (exact census, later)

After the gated real emission, replace the byte-bound with **provider usage actuals**:
- read `input_tokens`, `output_tokens`, `cache_read_input_tokens`, `cache_creation_input_tokens`, and any
  `reasoning_tokens` from each response/usage record;
- recompute per-call exact input+output token cost at the pinned R6 rates, per actual route;
- reconcile against this envelope (actuals must land ≤ the paranoid-adversarial $2.246177 and ≤ $8.00);
- record the exact census alongside this draft; any overage vs. envelope triggers a stop-and-review before spend.

---

### Artifacts
- `/tmp/lae-census/per-call-bytes.json` — full 312-row table (numbers only)
- `/tmp/lae-census/census-agg.json` — aggregates + hash-match audit
- `/tmp/lae-census/cost.json` — full cost arithmetic (machine-readable)
- `/tmp/lae-census/census-summary.json` — key numbers (machine-readable)
- `/tmp/lae-census/census.py`, `/tmp/lae-census/cost.py` — reproducible scripts
