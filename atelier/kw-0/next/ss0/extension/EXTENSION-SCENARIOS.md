# SS-0 extension scenario corpus (revealed with the R8 extension; frozen)

The harness (v1.1, included) invokes your runner with kind `batch` or `batch-ne` (scenario names `E1-clean` / `E2-mid-batch` / `E3-leg-refused`; both the kind+killpoint form and the E-name form are valid runner contracts — bind whichever matches your existing runner convention, as with the original corpus).

The batch operation: dispatch `batch:<label>:3` to the provider to obtain the fixture-owned batch descriptor (3 legs), then dispatch each leg **individually** via `effect:<label-or-leg-label>` (or `effect-ne:` where scripted) with a **per-leg attempt identity** of your design. Record between legs per your own schema — that is the point.

| Scenario | Kind | Killpoint | Your runner must… |
|---|---|---|---|
| `E1-clean` | batch | — | run one 3-leg batch end-to-end: descriptor, then legs 1–3 each dispatched and recorded per your design; exit 0. |
| `E2-mid-batch` | batch | `mid-batch` | fully settle leg-1 (your records durable); dispatch leg-2 (provider executes), then call the window **before any record of leg-2's outcome**; leg-3 must never be dispatched. |
| `E3-leg-refused` | batch-ne | `leg-refused` | fully settle leg-1; dispatch leg-2 via `effect-ne:` (provider durably refuses and issues its per-leg receipt), then call the window **before any record of leg-2's response**; leg-3 never dispatched. |

Recovery obligations (the brief's R-obligations applied per leg):
1. Recovery reports standing **per leg** from records alone; a leg with recorded dispatch and unrecorded outcome is individually unresolved. The whole batch must not be scalar-summarized as one status **in the durable record** (derived summaries may exist but must not contaminate it).
2. Blind re-dispatch of the batch OR of any individual unresolved leg is refused with cited evidence.
3. Per-leg receipts may resolve individual legs; resolution of one leg must not implicitly resolve its siblings.
4. An explicit distinct successor for the batch must carry per-leg lineage: which legs it re-attempts, which it abandons; predecessor legs' standing stays visible.
5. Your second-language reader derives the same per-leg census (extend your canonical digest spec as needed; document the change).

Deliverables for the extension: updated sources (or a delta), updated README section, and a one-paragraph statement of what changed and why. The extension delta is measured separately (AFEL of changed/added application lines).
