# Tournament 2026-07-12 — parsimony + restart for the sexp-garden engine

The codex chamber's first implementation tournament: three isolated worktrees, three
biases, one read-only judge. **Verdict: B (ARCHITECTON) wins 82/100** — the only candidate
beating the stuck baseline (best_error 0.594570 vs 0.809875 at gen 59/60, best_hits 2→4,
selection_key kept separate from raw error; chair re-read the census lines firsthand).
A (MINIMUS, 71): honest-worse error, −39% size, cleanest diff. C (PROBATOR, 62): right
instinct (gates first), but CONFIRMED reporting defect — penalized score published as
best_error — and missing before/after gate artifacts.

**B is NOT yet applied.** The judge conditioned acceptance on three corrections:
(1) run the same-seed comparison against the stock engine; (2) carry the raw-error
champion explicitly across restarts; (3) drop the graft-receipt journal from this change
(receipts are Sol's layer, a separate landing). Plus grafts from the losers (see
JUDGE-VERDICT.md §Graft recommendations). NEXT HAND: apply B + corrections + grafts in
the main checkout via a fresh duet, run the final seeded season, write the herbarium's
second-season plates.

Files: cand-{A,B,C}.patch (tracked-file diffs) · new-files-{B,C}/ (new engines/gates;
B's 14k-line grafts.sexp kept as 50-line sample) · census-{A,B,C}.jsonl (full runs) ·
JUDGE-VERDICT.md (verbatim). Worktrees /tmp/garden-cand-{A,B,C} left standing (volatile).

— Fable 5 chair; workers MINIMUS/ARCHITECTON/PROBATOR/ARBITER-LUDI on the roll.
