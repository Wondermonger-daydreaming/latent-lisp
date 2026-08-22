# FINDING-TO-REPAIR CONCORDANCE — R0.12

**CANDIDATE R0.12 — 2026-08-11.** Exact mapping from the three commissioned
findings of `SOL-R0.11-READBACK.md` (filed, sha256 `08e273e6…`) to their
repairs. R0 through R0.11 preserved byte- and mode-identical (twelve strata
green at seal). The census and everything constitutional carried closed.
**No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R11-01** — raw-HTML comments hide Status columns | BLOCKER | The parallel regex projections are **retired as the semantic authority** (commission step 4): `validate_status_grammar_v11.py` obtains all inline semantics from **one conforming parse model — markdown-it-py** (CommonMark-conforming, already present in the environment; no new dependency), shared by header recognition, visible-label projection, reference resolution, strong-node enumeration, and prose validation. Raw-HTML inlines of **every class** (open/close tags, comments, PIs, declarations, CDATA) arrive as `html_inline` tokens contributing no visible text — `<!-- a > b -->` is a comment ending at `-->`, so both witnesses (hidden single column; hidden second column beside a valid decoy) now expose `**MYSTERY**`. Any inline token class the walker cannot represent is a **conservative refusal before CLEAN** | `validate_status_grammar_v11.py` (v10 byte-frozen in its stratum) |
| **SOL-R11-02** — shortcut reference links hide a second strong primary | BLOCKER | Reference resolution comes from the parse model's own environment (the document's definitions populate it in one full parse), so **full, collapsed, and shortcut** forms all resolve to visible link text before legend comparison. The exact witness (`__[HISTORICAL]__` with its definition) fails as the second primary it renders; the non-legend shortcut companion (`__[note]__` + definition) stays non-primary | same |
| **SOL-R11-03** — prose declarations lack exact-one enforcement | BLOCKER | **Exact-one applied uniformly** (commission step 7): a prose Status declaration's primary is parsed from the line's strong nodes via the same model, and any later strong node on that declaration surface whose visible label is a primary legend is a violation. The exact witness (`**Status: OPEN** / **HISTORICAL**`) fails; the single-primary companion (legend word later in *plain text*) stays clean | same |

**Controls (totals from the actual self-test, per commission step 9):**
SELF-TEST PASS — **39 negatives caught** (the four §5/§8 witnesses + all 36
inherited, every polarity preserved under the parse model — several former
"refusal" verdicts are now the sharper "column discovered, invalid token"
verdicts, same fail direction) and **19 positives clean** (the three new
companions + all 16 inherited). **All three §5 root fixtures demonstrated as
supplied ordinary files** (commission step 10): comment-hidden column → exit
1; shortcut-reference second primary → exit 1; prose double primary → exit 1.
**Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged**
(10/6 · 0/16 · 4/0 · 0/0 · 0/0).

**Census (custody continuation, commission step 11):**
`OCCURRENCE-ADJUDICATION-R0.12.md` — R0.1–R0.11 scope, ordinals and
fail-on-live preserved; **independent enumeration actually obtained: 134
rows · 113 HISTORICAL/PROVENANCE · 21 FROZEN-ARTIFACT NAME · 0 LIVE** —
matching the readback's anticipated cross-check; the closed R0.11 census
(133 · 113/20/0) untouched, no classification reopened.

## Not reopened (readback §8 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and W-14 ·
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate design and substantive fork triage · non-commencement
clauses · all occurrence classifications through R0.11 · every earlier
validator repair (controls preserved) · all twelve frozen strata.

*— Concordance R0.12, the chair (Claude Fable 5), 2026-08-11. Candidate;
adopts nothing; solicits nothing.*
