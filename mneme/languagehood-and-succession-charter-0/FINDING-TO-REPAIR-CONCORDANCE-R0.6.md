# FINDING-TO-REPAIR CONCORDANCE — R0.6

**CANDIDATE R0.6 — 2026-08-11.** Exact mapping from the two commissioned
findings of `SOL-R0.5-READBACK.md` (filed, sha256 `5f4200c9…`) to their
repairs. R0 through R0.5 preserved byte-identical (7/12/10/9/9/10 at seal).
Everything constitutional is closed and untouched; per readback §7 nothing
else reopened. **No owner disposition solicited; nothing adopted; evidence
zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R05-01** — v4 accepts a covered empty file; case-variant table headers invisible | BLOCKER | **Validator replaced by `validate_status_grammar_v5.py`** (v4 byte-frozen in its stratum): **rule 2b** — every supplied file must contain non-whitespace text; an empty or whitespace-only file is a coverage error **even under a matched `0:0` expectation**, so the two legitimately-`0:0` governed files can no longer be truncated to nothing behind a green run; **rule 2c** — status-bearing table discovery is case-insensitive after Markdown-header normalization, so a `status`/`STATUS NOW` header is found and validated, never silently ignored. **New committed ordinary-invocation controls:** a matched-`0:0` empty file (refused, exit 2) · a lowercase-`status` table with an invalid token (violation) · an uppercase-`STATUS` table with a blank cell (violation). **Results: SELF-TEST PASS — seventeen negatives caught, seven positives clean; both adversarial paths demonstrated live on real-named files (exit 2 / exit 1); canonical five-file run CLEAN exit 0 with unchanged coverage** (charter 10/6; ceiling 0/16; docket 4/0) — proving discovery widening added no phantom surfaces to the actual corpus | `validate_status_grammar_v5.py`; demos and results in RETURN-R0.6 §3 |
| **SOL-R05-02** — six occurrence rows misclassified; totals 107/22 wrong | MINOR | **Correction of record adopted row-by-row:** the frozen R0.5 table's true totals are **113 HISTORICAL/PROVENANCE · 16 FROZEN-ARTIFACT NAME · 0 LIVE** (the readback's six-row table §5 adopted exactly; the R0.5 file stays byte-frozen; the correction lives in this concordance and the R0.6 table's header). **Root cause repaired, not patched:** the R0.5 generator classified per line, so a narrative token sharing a line with an artifact filename inherited the filename's class; the R0.6 generator classifies **per occurrence on a context window** and adds the **ordinal column** the readback required for same-line duplicate tokens. **Regenerated inventory delivered:** `OCCURRENCE-ADJUDICATION-R0.6.md` — R0.1–R0.5 scope over the five R0.6 successors, 128 rows, **114 HISTORICAL/PROVENANCE · 14 FROZEN-ARTIFACT NAME · 0 LIVE**, same fail-on-unmatched rule (a live-identity construct naming a non-current version blocks generation). Spot-verified at the readback's six loci: each now splits correctly by ordinal (e.g. charter line 22: ord 1 = filename → FROZEN; ord 2 = "the R0.1-round record" → HISTORICAL) | `OCCURRENCE-ADJUDICATION-R0.6.md`; verification in RETURN-R0.6 §3 |

## Not reopened (readback §6, obeyed)

SOL-R04-01 · the zero-live conclusion · SOL-R02-03/W-14 · W-02…W-13 · every
authority holding, independence coordinate, gate design, substantive fork
triage, and non-commencement clause · all six frozen strata and the R0.5
parcel tree.

*— Concordance R0.6, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
