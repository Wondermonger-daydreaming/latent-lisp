# FINDING-TO-REPAIR CONCORDANCE — R0.8

**CANDIDATE R0.8 — 2026-08-11.** Exact mapping from the one commissioned
finding of `SOL-R0.7-READBACK.md` (filed, sha256 `8d8cae6a…`) to its repair.
R0 through R0.7 preserved byte-identical (7/12/10/9/9/10/10/10 at seal).
SOL-R07-02 carried closed; nothing constitutional reopened. **No owner
disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R07-01** — v6 lacks header-markup normalization; formatted headers neither discovered nor kept out of the prose rule | BLOCKER | **Validator replaced by `validate_status_grammar_v7.py`** (v6 byte-frozen in its stratum): **one explicit header-label normalizer** — label-only emphasis (`*x*`, `_x_`), strong emphasis (`**x**`, `__x__`), code-span, and link wrappers reduce iteratively to plain text before the case-insensitive Status comparison (no new punctuation-specific gate); and **a structurally recognized table-header line is excluded from the prose `**Status` declaration rule**, so a bold `**Status**` header is a header, never an "unparseable declaration". **New committed ordinary-invocation controls, exactly as commissioned:** italic first-column `*Status*` + `**MYSTERY**` (violation); its blank-cell twin (violation); bold `**Status**` header + valid `**OPEN**` row (counted once, no prose misread — positive). **All prior controls preserved: SELF-TEST PASS — twenty-one negatives caught, eight positives clean.** Sol's verbatim italic fixture demonstrated live as a supplied file → violation, **exit 1**. **Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) | `validate_status_grammar_v7.py`; demos and results in RETURN-R0.8 §3 |

**SOL-R07-02 (closed, carried):** the R0.7 census (129 · 113/16/0) and the
R0.6 correction of record (113/15/0) stand untouched. The ordinary successor
custody continuation is `OCCURRENCE-ADJUDICATION-R0.8.md`: R0.1–R0.7 scope
over the five R0.8 successors, **130 rows · 113 HISTORICAL/PROVENANCE · 17
FROZEN-ARTIFACT NAME · 0 LIVE** (the delta is the R0.8 banner's own new
frozen-artifact references), ordinals and fail-on-live preserved, no R0.7
classification reopened.

## Not reopened (readback §6, obeyed)

The constitutional text · SOL-R07-02 and the R0.7 census · the R0.6 and R0.5
corrections of record · SOL-R04-01 · the zero-live conclusion ·
SOL-R02-03/W-14 · W-02…W-13 · every authority holding, independence
coordinate, gate design, substantive fork triage, and non-commencement clause
· all eight frozen strata and the R0.7 parcel tree · v6's structural
discovery and every earlier validator control.

*— Concordance R0.8, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
