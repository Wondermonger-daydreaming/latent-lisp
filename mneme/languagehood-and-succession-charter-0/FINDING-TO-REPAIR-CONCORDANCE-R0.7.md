# FINDING-TO-REPAIR CONCORDANCE — R0.7

**CANDIDATE R0.7 — 2026-08-11.** Exact mapping from the two commissioned
findings of `SOL-R0.6-READBACK.md` (filed, sha256 `c6a09277…`) to their
repairs. R0 through R0.6 preserved byte-identical (7/12/10/9/9/10/10 at
seal). Nothing constitutional reopened. **No owner disposition solicited;
nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R06-01** — v5 misses no-outer-pipe tables with a first-column Status header | BLOCKER | **Validator replaced by `validate_status_grammar_v6.py`** (v5 byte-frozen in its stratum): table discovery is now **structural** — a line is a table header iff the next line is a Markdown separator row, with or without optional outer pipes; header cells are then normalized and searched case-insensitively for a Status column at any position, first column included. **New committed ordinary-invocation controls:** the readback's exact fixture — a no-outer-pipe, first-column-Status table with `**MYSTERY**` (violation) — and its blank-cell twin. All v5 empty-text, case-variant, coverage, and exact-one controls preserved. **Results: SELF-TEST PASS — nineteen negatives caught, seven positives clean; the fixture demonstrated live under a matched `0:0`-shaped expectation → violation, exit 1; canonical five-file run CLEAN exit 0 at unchanged coverage** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) — structural discovery added no phantom surfaces to the real corpus | `validate_status_grammar_v6.py`; demos and results in RETURN-R0.7 §3 |
| **SOL-R06-02** — charter line 7's readback-filename token classed narrative | MINOR | **Correction of record: the frozen R0.6 table's true totals are 113 HISTORICAL/PROVENANCE · 15 FROZEN-ARTIFACT NAME · 0 LIVE** (the one row corrected exactly as the readback's §5 table states; the R0.6 file stays byte-frozen). **Root cause repaired:** the R0.6 classifier tested for a pre-context stem ending `SOL-R`, but the `R` belongs to the matched token, so the test could never fire — replaced by post-context `-READBACK` recognition. **Regenerated census delivered:** `OCCURRENCE-ADJUDICATION-R0.7.md` — R0.1–R0.6 scope over the five R0.7 successors, **129 rows · 113 HISTORICAL/PROVENANCE · 16 FROZEN-ARTIFACT NAME · 0 LIVE**, ordinals and fail-on-live preserved; the analogous R0.7-banner locus (line 7's `R0.6` inside `SOL-R0.6-READBACK.md`) spot-verified FROZEN | `OCCURRENCE-ADJUDICATION-R0.7.md`; verification in RETURN-R0.7 §3 |

## Not reopened (readback §6, obeyed)

The constitutional text · SOL-R04-01 · the zero-live conclusion ·
SOL-R02-03/W-14 · W-02…W-13 · every authority holding, independence
coordinate, gate design, substantive fork triage, and non-commencement clause
· all seven frozen strata and the R0.6 parcel tree · v5's empty-text and
case-variant repairs · the R0.5 correction of record (113/16/0).

*— Concordance R0.7, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
