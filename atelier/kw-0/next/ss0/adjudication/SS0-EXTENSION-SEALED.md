# SS-0 sealed extension effect type — PLAINTEXT (do not relay to seats before both freezes)

**Extension: `batch-transfer` — one attempt, N independently-settling sub-effects.**

A single application attempt dispatches one `batch-transfer` operation comprising **N=3 sub-effects** (`leg-1`, `leg-2`, `leg-3`), each an irreversible provider effect with its own settlement. The provider fixture gains tag `batch:<label>:<n>` — it executes legs sequentially with a kill-window between legs, so interruption can leave **partial settlement** (e.g., leg-1 executed, leg-2 dispatched-unrecorded, leg-3 never dispatched).

Required behaviors (the R-obligations applied per-leg):
1. Recovery reports standing **per leg** from records alone; a leg whose dispatch is recorded but whose outcome is not is individually unresolved (R1/R3 per leg — the whole batch must not be scalar-summarized as one status in the durable record; derived summaries may exist but must not contaminate it).
2. Blind re-dispatch of the batch OR of any individual unresolved leg is refused with cited evidence (R3).
3. Per-leg receipts may resolve individual legs (R4); resolution of one leg must not implicitly resolve its siblings.
4. A successor batch under R5 must carry per-leg lineage: which legs it re-attempts, which it abandons, and the predecessor legs' standing stays visible.
5. The second-language reader derives the same per-leg census (R7).

Why this extension bites: it forces the semantic layer to show whether its distinctions **compose** — per-leg occupancy, partial settlement, and evidence-scoped resolution are exactly where a scalar-status design collapses and a per-proposition design pays its rent. The measured deliverable is each side's extension delta (AFEL + description) and whether R-obligations hold per leg without recovery-logic rewrites (R8).

*Sealed by the chair 2026-07-19 (host clock). SHA-256 of this file is committed publicly in SS0-ADJUDICATION-PACKET-DRAFT.md; plaintext lives only in `_staging/` (excluded from mirror sync) until step 6 of the freeze procedure.*
