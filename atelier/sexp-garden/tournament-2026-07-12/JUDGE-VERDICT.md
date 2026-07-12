# ARBITER-LUDI — tournament verdict (2026-07-12)

*Read-only judge over three isolated worktrees; full report verbatim below.*

---

# ARBITER-LUDI verdict

All three submitted valid JSONL censuses with contiguous generations and in-band restart markers. B has the strongest evidence and the only improvement over the stated baseline.

Scores weight evidence first.

| Candidate | Evidence | Result | Defect resistance | Maintainability | Total |
|---|---:|---:|---:|---:|---:|
| B — ARCHITECTON | 35/40 | 25/25 | 14/20 | 8/15 | **82/100** |
| A — MINIMUS | 29/40 | 13/25 | 16/20 | 13/15 | **71/100** |
| C — PROBATOR | 27/40 | 13/25 | 12/20 | 10/15 | **62/100** |

## A — MINIMUS

### Evidence

The census exists, parses as JSON, and contains exactly 40 contiguous generations, 0–39.

Quoted trajectory:

- Line 1: `gen=0`, `best_error=3.126027`, `mean_size=30.547`
- Line 30: `gen=29`, `best_error=1.009821`, `mean_size=82.020`
- Line 36: `gen=35`, `best_error=0.877650`, `mean_size=89.067`, `"restart":true`
- Line 37: after restart, `mean_size=31.060`, while `best_error=0.877650`
- Line 40: final `best_error=0.877650`, `mean_size=51.240`

Evidence: [census-separatrix-v2.jsonl](/tmp/garden-cand-A/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:36)

The run has a committed default seed, `8675309`, and resets the RNG before evolution. It is reproducible-looking, but unlike B there is no second-run artifact proving repetition.

Raw error remains in `org-err`; the parsimony value is computed separately and used for tournaments and elite sorting. Census continues to report raw error rather than penalized fitness.

### Result

Final error `0.877650` is worse than the stuck baseline `0.809875`; this is an honest non-improvement.

Size behavior is useful:

- Before restart, mean size grows past baseline to `89.067`.
- Restart immediately reduces it to `31.060`.
- It regrows to `51.240` by generation 39, still materially below baseline mean size ≈84.

The experiment proves that the restart changes population structure, but not that it improves prediction error within the allotted 40 generations.

### Defects

**CONFIRMED — selection fitness is not recorded.** The census contains only `best_error`, not the corresponding penalized fitness or best size. The implementation separates the values internally, but the central claim cannot be numerically audited from the census itself.

**CONFIRMED — restart census omits barren count.** Only `"restart":true/false` is emitted. A downstream reader cannot verify from the artifact that the five-generation threshold actually caused the event.

**THEORETICAL — global raw-error champion can be lost.** Restart preserves the first two organisms sorted by penalized fitness, not `overall-best`. If the raw-error champion is sufficiently large, it may be excluded. This did not happen at the observed restart: line 37 still contains error `0.877650`.

**THEORETICAL — raw-error stagnation and penalized selection optimize different objectives.** This is defensible, but a shrinking population with unchanged error still counts as barren. If “improvement” was intended to mean selection-fitness improvement, the gate fires prematurely. The intended definition needs one explicit sentence.

### Maintainability

Best of the three. The change is localized and readable. The missing census audit fields are inexpensive to fix.

---

## B — ARCHITECTON

### Evidence

The census exists, parses completely, and contains 60 contiguous generations, 0–59.

Quoted trajectory:

- Line 1: `best_error=3.126027`, `best_size=31`, `selection_key=3.157027`
- Line 37: restart at generation 36, `barren=6`
- Line 38: post-restart mean size falls from `89.880` to `23.167`
- Line 50: second restart at generation 49, with `best_error=0.685854`
- Line 60: final `best_error=0.594570`, `best_size=91`, `selection_key=0.685570`, `mean_size=87.427`

Evidence: [census-separatrix-v2.jsonl](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:37), [line 50](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:50), [line 60](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:60)

B records the most auditable separation:

> `:best-err (org-err best)`  
> `:best-selection-key (selection-key (org-err best) best-size)`

See [evolution-v2.lisp](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/evolution-v2.lisp:69).

Two worktree-resident execution logs report the same seed, restart generations, champion IDs, and final result. That is materially stronger reproducibility evidence than a seed declaration alone.

### Result

B is the only candidate that beats the baseline:

- Baseline best error: `0.809875`
- B final best error: `0.594570`
- Absolute improvement: `0.215305`, about **26.6%**

The qualification is important: at generation 39 B is still at `0.877650`, so the ≥40-generation extension matters. Improvement arrives after the first restart and beyond the original 40-generation horizon.

Parsimony does not produce a permanently smaller population:

- Mean size drops sharply after restart, `89.880 → 23.167`.
- It regrows to `87.427`, slightly above baseline ≈84.
- Final champion size is `91`.

Thus B wins on error, not final compactness.

### Defects

**CONFIRMED — broad engine substitution.** The runner changes its dependency from `garden.lisp` to `garden-grafted.lisp`, introducing graft-receipt machinery unrelated to the requested parsimony/restart task. See [run-separatrix.lisp](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/run-separatrix.lisp:25). This materially enlarges the validation surface.

**CONFIRMED — enormous unrelated artifact.** `grafts.sexp` contains 14,392 receipt records. It is not required to prove parsimony or restart behavior and makes review and repository hygiene substantially worse.

**CONFIRMED — final barren threshold is reached but no restart occurs.** Census line 60 says `barren=6`, `restart=false`. This is intentional because no next generation exists, but readers must understand that the marker means “restart will be applied after this census,” not “threshold was reached.” The schema does not distinguish `threshold_reached` from `restart_applied`.

**THEORETICAL — restart can discard the global raw-error champion.** `restart-generation` preserves current penalized-fitness elites, while `overall-best` is only used as the behavioral-annulus center. It is not explicitly inserted into the new population. See [evolution-v2.lisp](/tmp/garden-cand-B/experiments/latent-lisp/atelier/sexp-garden/evolution-v2.lisp:104). The observed line immediately after each restart retained the best error, so no clobber is demonstrated in this run.

**THEORETICAL — annulus policy may not satisfy its stated bounds.** Candidates outside the annulus are ranked by distance to its boundary, but if too few candidates lie inside, out-of-band trees are silently accepted. The policy is “prefer an annulus,” not “enforce an annulus.”

### Maintainability

The scoring/breeding/restart decomposition is clear and the census is excellent. Maintainability is reduced by switching engines and coupling the run to a large graft subsystem. The evolution module itself is understandable; the total submitted surface is not minimal.

---

## C — PROBATOR

### Evidence

The census exists, parses completely, and contains 40 contiguous generations.

Quoted trajectory:

- Line 1: `best_error=3.126027`, `best_score=3.157027`, `best_size=31`
- Line 36: `best_error=0.877650`, `best_score=0.966650`
- Line 38: restart at generation 37
- Line 40: final `best_error=0.877650`, `best_score=0.966650`, `mean_size=22.647`

Evidence: [census-separatrix-v2.jsonl](/tmp/garden-cand-C/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:38), [line 40](/tmp/garden-cand-C/experiments/latent-lisp/atelier/sexp-garden/census-separatrix-v2.jsonl:40)

C gives the census both raw error and penalized score, which is good evidence separation. The seed is committed, but there is no repeat-run artifact.

### Result

Like A, C ends at `0.877650`, worse than baseline `0.809875`.

Its restart reduces mean size from `88.793` to `22.647`, the strongest final size reduction of the three. However, only two post-restart census generations exist, so there is little evidence about subsequent recovery or regrowth.

### C-specific gate judgment

**The planted-signal/no-signal gates are not proven to have run either before or after.**

The worktree contains [gates-garden.lisp](/tmp/garden-cand-C/experiments/latent-lisp/atelier/sexp-garden/gates-garden.lisp:1), but no execution log, result file, before/after fixture, or other artifact quoting `PLANT VERDICT` or `NULL VERDICT`.

Moreover, the gate loads the modified `garden.lisp` and calls `fitness-score`. It does not contain a stock-error-only implementation or a mechanism to run the committed baseline before the change. Therefore:

- Before result: **no disk evidence**
- After result: **no disk evidence**
- What the stock engine did on the plant: **not established on disk**

The mere presence of executable gate code is not execution evidence.

### Defects

**CONFIRMED — `best_error` is not necessarily the generation’s best raw error.** C chooses `best-i` by penalized `scores`, then labels that organism’s raw error as `best_error`. A larger tree with lower raw error can therefore exist while the census reports a worse value as “best.” See [run-separatrix.lisp](/tmp/garden-cand-C/experiments/latent-lisp/atelier/sexp-garden/run-separatrix.lisp:61). This is the most serious reporting defect among the candidates.

**CONFIRMED — overall best is also defined by penalized score.** `overall-best` updates only when `best-score` improves. The final “overall best total-abs-err” is consequently not guaranteed to be the run’s minimum raw error.

**CONFIRMED — restart violates the configured elite count.** Normal breeding preserves `*elite*=2`, but restart preserves exactly one `overall-best` and creates `pop-size−1` fresh trees. This does preserve the champion, but silently changes the elite policy during restart.

**CONFIRMED — gates lack before/after execution artifacts.** This fails the task’s C-specific evidentiary requirement.

**THEORETICAL — gate’s null criterion is weak.** It judges “signal recovery” solely by whether training raw error crosses an arbitrary `1.0` floor on a fixed 21-point dataset. No holdout or structural criterion prevents evolutionary overfitting from being mislabeled recovery.

### Maintainability

The reusable `fitness-score` addition is clean. The main evolution routine now mixes selection, stagnation, restart construction, statistics, and reporting semantics, and the misleading meaning of `best_error` will surprise downstream readers.

# Ranking

1. **B — ARCHITECTON**
2. **A — MINIMUS**
3. **C — PROBATOR**

B wins because it supplies the strongest reproducibility evidence, the richest auditable census, two in-band restarts, and the only verified improvement over baseline: `0.594570` versus `0.809875`. Its victory is not stylistic: it is supported by 60 valid census records and repeated execution logs. A ranks second because it is the safest and clearest implementation, honestly reports a non-improvement, and demonstrates a real size collapse after restart. C ranks last despite useful score fields because its `best_error` semantics are defective and its advertised before/after gates have no execution evidence.

# Graft recommendations

The winner B should absorb:

- From **A**: the localized runner integration. Keep `garden.lisp` as the engine dependency and avoid loading the graft-receipt subsystem for this experiment.
- From **C**: preserve `overall-best` explicitly during every restart, but preserve the configured number of elites rather than C’s hard-coded one.
- From **C**: retain the straightforward `best_score`/`best_size` census naming, while continuing B’s separate raw-error champion calculation.
- From **A**: keep the restart mechanism simple unless the behavioral annulus demonstrates an advantage in a controlled comparison.
- From **C’s intent, not its evidence**: add real pre-change and post-change planted/no-signal run artifacts. The same seed, budgets, and datasets should be recorded for both engines.

Before accepting B, I would require three corrections: run against the stock engine, explicitly carry the global raw-error champion across restart, and remove the unrelated `grafts.sexp`/receipt output from this change.
