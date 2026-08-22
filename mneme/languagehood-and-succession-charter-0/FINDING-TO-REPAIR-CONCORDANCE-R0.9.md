# FINDING-TO-REPAIR CONCORDANCE — R0.9

**CANDIDATE R0.9 — 2026-08-11.** Exact mapping from the one commissioned
finding of `SOL-R0.8-READBACK.md` (filed, sha256 `d2cd2da3…`) to its repair.
R0 through R0.8 preserved byte-identical (7/12/10/9/9/10/10/10/10 at seal).
SOL-R08-02 and every earlier census carried closed; nothing constitutional
reopened. **No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R08-01** — v7 recognizes wrapper specimens, not the promised wrapper grammar | BLOCKER | **Validator replaced by `validate_status_grammar_v8.py`** (v7 byte-frozen in its stratum). Header cells are normalized as **whole Markdown inline labels**: nested/combined emphasis and strong reduce recursively via symmetric delimiter runs (`***Status***` unwraps); code spans accept **matching backtick runs of any length**; inline links accept **balanced or escaped destinations**; reference-style links (`[label][ref]`, collapsed, shortcut) **resolve from the document's link-reference definitions**. And the drawer is closed: **any header cell whose markup-stripped text is Status-like but which the normalizer could not reduce to a plain label is a coverage-class violation — never a silent `0:0` surface** (proven by a strikethrough `~~Status~~` guard control). **Controls: SELF-TEST PASS — twenty-six negatives caught** (all four exact §3/§5 fixtures: `***Status***`, double-backtick, `[Status][status-label]` with its definition, balanced-destination inline link — plus the drawer guard, plus all twenty-one v7 negatives) **and twelve positives clean** (the four same-header valid-`**OPEN**` companions each counted exactly once, plus all eight v7 positives). One fixture demonstrated live as a supplied file → violation, **exit 1**. **Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) | `validate_status_grammar_v8.py`; demos and results in RETURN-R0.9 §3 |

**SOL-R08-02 (closed, carried):** the R0.8 census (130 · 113/17/0) and all
earlier census findings stand untouched. The ordinary custody continuation is
`OCCURRENCE-ADJUDICATION-R0.9.md`: R0.1–R0.8 scope over the five R0.9
successors, **131 rows · 113 HISTORICAL/PROVENANCE · 18 FROZEN-ARTIFACT NAME
· 0 LIVE**, ordinals and fail-on-live preserved, no classification reopened.

## Not reopened (readback §6, obeyed)

The constitutional text · SOL-R08-02 and every census · the R0.6/R0.5
corrections of record · SOL-R04-01 · the zero-live conclusion ·
SOL-R02-03/W-14 · W-02…W-13 · every authority holding, independence
coordinate, gate design, substantive fork triage, and non-commencement clause
· all nine frozen strata and the R0.8 parcel tree · v7's header/prose
separation and every inherited fail-closed rule.

*— Concordance R0.9, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
