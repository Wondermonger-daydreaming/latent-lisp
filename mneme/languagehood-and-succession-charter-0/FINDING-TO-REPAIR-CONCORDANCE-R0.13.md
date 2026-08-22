# FINDING-TO-REPAIR CONCORDANCE — R0.13

**CANDIDATE R0.13 — 2026-08-12.** Exact mapping from the three commissioned
findings of `SOL-R0.12-READBACK.md` (filed, sha256 `621349df…`) to their
repairs. R0 through R0.12 preserved byte- and mode-identical (thirteen strata
green at seal). The census and everything constitutional carried closed.
**No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R12-01** — table structure hand-parsed; blockquoted tables invisible | BLOCKER | **The parser is now the block authority** (commission step 4): `validate_status_grammar_v12.py` enables the parser's own GFM `table` rule and walks its emitted `table/thead/tbody/tr/th/td` tokens wherever the block structure places them — including inside blockquotes and lists. The separator regex, physical-line row loop, and hand cell lexer are **deleted**; the parser's logical cells are the cells (escaped pipes included). The blockquoted witness exposes `**MYSTERY**`; its one-valid-cell companion counts once, clean | `validate_status_grammar_v12.py` (v11 byte-frozen in its stratum) |
| **SOL-R12-02** — prose discovery gated by a literal `**Status` regex | BLOCKER | **Prose declarations are discovered by visible strong labels** on non-table inline surfaces (commission step 5): any strong node whose visible label starts with `status` is a carrier — both strong spellings, decoded character references, link labels, nested emphasis alike; **no punctuation regex gates discovery** (the sole surviving `**Status` regex is a conservative *tripwire*: a line spelled like a declaration that the parser resolves to no carrier, outside any parser-consumed table span, is an ambiguity violation — it admits nothing). All three witnesses (`__Status: MYSTERY__`; `**Sta&#116;us: MYSTERY**`; `**[Status](…): MYSTERY**`) fail; their valid companions each count as one declaration, clean | same |
| **SOL-R12-03** — only the first prose carrier validated | BLOCKER | **Every carrier on a surface is validated, in order** (commission step 6): sequential label-walk — each carrier takes exactly one primary (colon-tail or the next strong label), each primary token-checked, and every other strong legend label on the surface is an exact-one violation. The two-carrier witness fails on its second carrier; the two-valid-carriers companion counts 2 declarations, clean | same |

**Reproducibility surface (step 8):** the validator names its dependency and
tested versions in its docstring (markdown-it-py; tested 4.0.0 and 3.0.0),
prints the loaded parser version in every CLEAN line, and exits 3 with a
controlled diagnostic — never an import traceback — when the dependency is
absent.

**Controls (totals from the actual self-test, step 11):** SELF-TEST PASS —
**44 negatives caught / 24 positives clean** (negatives exactly at the
readback's anticipated 44 cross-check: the five §7.9 witnesses + all 39
inherited; positives: the five §7.10 companions + all 19 inherited).
**Step 12:** the blockquoted table, the underscore-strong prose variant, and
the two-carrier line demonstrated as supplied ordinary files — each exit 1
with the exact diagnostic. **Canonical five-file run: CLEAN, exit 0, coverage
byte-for-byte unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) — semantic carrier
discovery finds exactly the corpus's declared surfaces, no drift.

**Census (step 13):** `OCCURRENCE-ADJUDICATION-R0.13.md` — R0.1–R0.12 scope;
**independent enumeration actually obtained: 135 rows · 113
HISTORICAL/PROVENANCE · 22 FROZEN-ARTIFACT NAME · 0 LIVE** — coinciding with
the anticipated cross-check; the closed R0.12 census (134 · 113/21/0)
untouched, no classification reopened.

## Not reopened (readback §7 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and W-14 ·
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate design and substantive fork triage · non-commencement
clauses · every occurrence classification through R0.12 · every earlier
validator repair (controls preserved) · all thirteen frozen strata.

*— Concordance R0.13, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; solicits nothing.*
