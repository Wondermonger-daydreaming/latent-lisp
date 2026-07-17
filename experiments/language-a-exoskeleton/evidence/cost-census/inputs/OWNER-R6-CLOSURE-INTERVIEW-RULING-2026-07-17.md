# Owner Ruling R6-closure — cost census method + route amendment (2026-07-17)

Deciding actor: `actor:tomas-pellissari-pavan-owner`
Channel: AskUserQuestion interview, Claude Code session, 2026-07-17 (America/Sao_Paulo).
Recorded by: NOTARY, records-clerk (no key content, no dossier content, no item/prompt
content read; hashing of files for identity binding is not a read).

This ruling CLOSES the two numeric/routing questions left pending by
`SCORING-R6-ADOPTED-v1` (owner-decision:scoring-r6-adopted-v1, record_digest
`sha256:41f41211d873351b30966977f5aea2901a003abab0b5a782b485930bde56114c`): the exact
$8.00-ceiling prompt census method, and the subject-provider-model routes / price-table
rows. "R6-closure" is a session label for the owner-action step that resolves R6's
carried pending markers; it does not extend the docket vocabulary.

## Questions and answers (verbatim)

**Interview A (census method).** Q: "R6 census method — the exact provider-tokenizer
prompt census requires sending frozen item bytes to providers BEFORE the pre-exposure
gate is signed (count-tokens style calls; no generation, but bytes travel). The
alternative keeps everything offline: render all 312 envelopes locally, byte-count them,
apply a disclosed conservative bytes→tokens bound for the $8.00 ceiling, and record exact
per-provider token counts from emission actuals. Which do you authorize?"
**A (Interview A):** "Offline byte census + bound (Recommended)" — option text: "Zero
pre-gate provider contact. Ceiling checked against a disclosed conservative bound (e.g.
bytes/2.5 × safety factor); exact tokenizer counts recorded from emission usage fields.
The 'exact census' pending closes at emission, disclosed as such."

**Interview B (route amendment).** Q: "Route amendment (amends R6's
subject-provider-model-routes + price-table rows; I author the new owner-decision record
and disclose the intermediary in the lineage): which scope?"
**A (Interview B):** "Haiku + luna via OpenRouter, kimi stays subscription" — option
text: "Keeps kimi at $0 marginal with the subscription-route disclosure; two clients in
the runner (OpenRouter + kimi coding route)."

## Operative effect

1. **Census method authorized: OFFLINE byte census + disclosed conservative
   bytes→tokens bound.** Zero pre-gate provider/tokenizer contact. All 312 envelopes are
   rendered and byte-counted locally; the $8.00 ceiling is checked against disclosed
   conservative bounds (0.5 and 1.0 tokens/byte over-counts). The exact per-provider
   tokenizer census is **deferred to emission actuals** — read from provider usage fields
   after the (still-unsigned) gate — and is disclosed as pending, not inferred from bytes.
   Executed census evidence: `evidence/cost-census/CENSUS-REPORT.md`
   (sha256 `2931c0bdea501facd551c13917d569822c863feb65dbcab0c974f9953196dc4c`) and the
   machine-readable companions in `evidence/cost-census/`.

2. **Routes amended.** `claude-haiku-4.5` and `gpt-5.6-luna` move to the **OpenRouter
   route**, with provider-preference upstream pinning to be recorded in the emission
   config. `kimi-k3` **stays on the Moonshot kimi.com coding-plan subscription route**
   (`api.kimi.com/coding/`, Anthropic-compatible), at **$0.00 marginal metered cost**,
   with the MANDATORY disclosure that it is a subscription route, not a metered platform.
   The runner carries two clients: OpenRouter + the kimi coding route. OpenRouter is the
   disclosed intermediary for haiku and luna.

3. **Price rows pinned** (sources fetched live 2026-07-17 unless noted):
   - `claude-haiku-4.5` — input $1.00 / output $5.00 per MTok. OpenRouter live listing
     (`anthropic/claude-haiku-4.5`: prompt 0.000001 / completion 0.000005 USD/token,
     ctx 200000), corroborated by the Anthropic provider pricing table
     (platform.claude.com/docs/en/about-claude/pricing): base input $1.00, output $5.00;
     cache write-5m $1.25 / write-1h $2.00 / cache hit $0.10; thinking/reasoning tokens
     bill as output tokens; no long-context premium; `inference_geo` global default = no
     multiplier. rate_status **pinned**.
   - `gpt-5.6-luna` — input $1.00 / output $6.00 per MTok. OpenRouter live listing
     (`openai/gpt-5.6-luna`: prompt 0.000001 / completion 0.000006 USD/token,
     ctx 1050000). rate_status **pinned**.
   - `kimi-k3` — **$0.00 / $0.00 marginal**, coding-plan subscription route (verified
     HTTP 200 on 2026-07-16). OpenRouter lists `moonshotai/kimi-k3` at $3.00 / $15.00 per
     MTok — **NOT adopted** (kimi stays on the subscription route). rate_status **pinned**
     (marginal), with subscription-route disclosure.

4. **Ceiling recomputation (offline byte census).** Exact scheduled prompt byte census =
   **527,916 B** (312 calls; 175,972 B per subject slot, byte-identical across the three
   balanced slots ⇒ invariant to any slot→route permutation; all 312 rows
   component-hash-matched, 0 unmatched). Bounds 0.5 and 1.0 tokens/byte. Global worst case
   = **$2.246177** (paranoid 1.0 tok/byte × adversarial all-metered-on-luna mapping;
   includes the 344-attempt output ceiling of 264,192 tokens and the 1.05 input
   allowance). Against the **$8.00** ceiling: **UNDER CEILING — 28.1%**, headroom
   **$5.753823**.

5. **Reasoning-token disclosure (now known where determinable).** For `claude-haiku-4.5`,
   thinking/reasoning bills as output tokens and IS bounded by the 768 max-output cap
   (already inside the worst case). For `gpt-5.6-luna` and `kimi-k3`, reasoning/thinking
   emission and billing treatment is **not provably bounded by the 768 cap** and remains
   pending exact confirmation.

6. **Authority ceilings unchanged in spirit from R6-v1.** No live provider call is
   authorized (offline byte census only; zero pre-gate provider contact); no live
   responses or response collection; no private key content or key exposure; no merge;
   the pre-exposure gate remains **UNSIGNED** by this ruling; the real item bank and score
   key remain unresolved.

## Bounded unknowns (named, not silently absorbed)

- Reasoning/thinking tokens on `gpt-5.6-luna` and `kimi-k3` are not bounded by the 768
  max-output cap (emission/billing treatment unknown pre-gate); `claude-haiku-4.5`
  thinking bills as output and IS bounded by 768.
- Cached-input treatment: the worst case assumes NO caching benefit (no discount
  applied); OpenRouter-route cache passthrough is pending exact confirmation.
- Provider-side chat-envelope / role / BOS / special-token overhead beyond the counted
  payload bytes is not in the byte census; partially absorbed by the 1.0 tok/byte
  paranoid bound + the 1.05 allowance, but not guaranteed.
- Slot→route mapping (1=haiku, 2=luna, 3=kimi) is an assumption confirmed at preflight;
  the adversarial-mapping arm bounds the ceiling under ANY permutation.
- Item bank state = candidate (`item_bank_freeze_authorized=false`); the census is valid
  for the fixed-candidate schedule as committed and MUST be recomputed if the freeze
  mutates any component (bank component identity re-checked at preflight).
- The exact per-provider tokenizer token census is deferred to emission actuals; it is
  disclosed as pending, not inferred from bytes.

## Emission-actuals closure plan (the exact census, later)

After the gated real emission, the byte-bound is replaced with provider usage actuals:
read `input_tokens`, `output_tokens`, `cache_read_input_tokens`,
`cache_creation_input_tokens`, and any `reasoning_tokens` from each response/usage record;
recompute exact per-call input+output cost at the pinned R6 rates per actual route;
reconcile against this envelope (actuals must land ≤ the paranoid-adversarial $2.246177
and ≤ $8.00); record the exact census alongside the report; any overage vs. envelope
triggers a stop-and-review before spend.
