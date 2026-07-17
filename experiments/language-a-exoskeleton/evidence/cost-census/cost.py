import json
from decimal import Decimal, ROUND_UP

percall = json.load(open("/tmp/lae-census/per-call-bytes.json"))
agg = json.load(open("/tmp/lae-census/census-agg.json"))

SCHED_BYTES = agg["grand_total_bytes"]           # 527916
N = len(percall)                                  # 312
max_bytes = max(p["prompt_bytes"] for p in percall)
min_bytes = min(p["prompt_bytes"] for p in percall)

# ---- fixed inputs (verified 2026-07-17) ----
ATTEMPT_CEILING = 344
RETRIES = 344 - 312                               # 32
OUT_TOK_PER_CALL = 768
OUT_TOK_CEILING = 264192                          # 344*768
INPUT_ALLOWANCE = Decimal("1.05")
SPEND_CEILING = Decimal("8.00")

# rates USD per million tokens
RATE = {
 "haiku": {"in": Decimal("1.00"), "out": Decimal("5.00")},
 "luna":  {"in": Decimal("1.00"), "out": Decimal("6.00")},
 "kimi":  {"in": Decimal("0.00"), "out": Decimal("0.00")},  # subscription, $0 marginal
}
MAX_IN_RATE  = max(RATE[r]["in"]  for r in RATE)   # 1.00
MAX_OUT_RATE = max(RATE[r]["out"] for r in RATE)   # 6.00 (luna)

MILLION = Decimal(1_000_000)

def usd(x): return x.quantize(Decimal("0.000001"))

def cost_for_bound(bound_name, tok_per_byte):
    tpb = Decimal(str(tok_per_byte))
    # --- INPUT worst case ---
    # scheduled input + 32 retries re-sending the LARGEST prompt, all on most expensive route,
    # times token/byte bound, times 1.05 input allowance.
    sched_in_tokens = Decimal(SCHED_BYTES) * tpb
    retry_in_tokens = Decimal(RETRIES * max_bytes) * tpb
    total_in_tokens = (sched_in_tokens + retry_in_tokens) * INPUT_ALLOWANCE

    # --- Mapping A: nominal (slot1->haiku, slot2->luna, slot3->kimi) ---
    # all slots byte-identical (175972 each) and 104 calls each.
    per_slot_bytes = Decimal(SCHED_BYTES) // 3
    per_slot_in_tokens = per_slot_bytes * tpb * INPUT_ALLOWANCE
    # nominal input cost: haiku slot + luna slot + kimi slot (kimi free)
    nom_in = (per_slot_in_tokens*RATE["haiku"]["in"] + per_slot_in_tokens*RATE["luna"]["in"] + per_slot_in_tokens*RATE["kimi"]["in"]) / MILLION
    # nominal retries: adversarial -> all 32 on most expensive route (luna) input
    nom_retry_in = (retry_in_tokens * INPUT_ALLOWANCE * MAX_IN_RATE) / MILLION
    # nominal output: scheduled 104 calls/slot *768, per route; retries all on luna(out 6)
    sched_out_tokens_per_slot = Decimal(104*OUT_TOK_PER_CALL)
    nom_out = (sched_out_tokens_per_slot*RATE["haiku"]["out"] + sched_out_tokens_per_slot*RATE["luna"]["out"] + sched_out_tokens_per_slot*RATE["kimi"]["out"]) / MILLION
    nom_retry_out = Decimal(RETRIES*OUT_TOK_PER_CALL)*MAX_OUT_RATE / MILLION
    nominal_total = nom_in + nom_retry_in + nom_out + nom_retry_out

    # --- Mapping B: adversarial upper bound (EVERYTHING on most expensive route) ---
    # all input tokens (sched+retry, w/ 1.05) at MAX_IN_RATE; all 344 attempts output at MAX_OUT_RATE
    adv_in = (total_in_tokens * MAX_IN_RATE) / MILLION
    adv_out = Decimal(OUT_TOK_CEILING) * MAX_OUT_RATE / MILLION
    adversarial_total = adv_in + adv_out

    return {
        "bound": bound_name, "tokens_per_byte": float(tpb),
        "scheduled_input_tokens": float(sched_in_tokens),
        "retry_input_tokens_raw": float(retry_in_tokens),
        "total_input_tokens_with_1.05": float(total_in_tokens),
        "nominal_mapping_usd": {
            "input_scheduled": float(usd(nom_in)),
            "input_retries_luna": float(usd(nom_retry_in)),
            "output_scheduled": float(usd(nom_out)),
            "output_retries_luna": float(usd(nom_retry_out)),
            "TOTAL": float(usd(nominal_total)),
            "under_ceiling": nominal_total <= SPEND_CEILING,
        },
        "adversarial_mapping_usd": {
            "input_all_maxrate": float(usd(adv_in)),
            "output_all_344_maxrate": float(usd(adv_out)),
            "TOTAL": float(usd(adversarial_total)),
            "under_ceiling": adversarial_total <= SPEND_CEILING,
        },
    }

result = {
    "grand_total_input_bytes": SCHED_BYTES,
    "n_calls": N,
    "max_prompt_bytes": max_bytes,
    "min_prompt_bytes": min_bytes,
    "retries": RETRIES, "attempt_ceiling": ATTEMPT_CEILING,
    "output_tokens_per_call": OUT_TOK_PER_CALL, "output_token_ceiling": OUT_TOK_CEILING,
    "input_allowance_multiplier": float(INPUT_ALLOWANCE),
    "spend_ceiling_usd": float(SPEND_CEILING),
    "max_input_rate_per_M": float(MAX_IN_RATE), "max_output_rate_per_M": float(MAX_OUT_RATE),
    "bounds": [cost_for_bound("conservative", 0.5), cost_for_bound("paranoid_upper", 1.0)],
}
json.dump(result, open("/tmp/lae-census/cost.json","w"), indent=2)
print(json.dumps(result, indent=2))
