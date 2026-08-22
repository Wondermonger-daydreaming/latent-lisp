# FINDING-TO-REPAIR CONCORDANCE — R0.14

**CANDIDATE R0.14 — 2026-08-12.** Exact mapping from the four commissioned
findings of `SOL-R0.13-READBACK.md` (filed, sha256 `2adeddb9…`) to their
repairs. R0 through R0.13 preserved byte- and mode-identical (fourteen strata
green at seal). The census and everything constitutional carried closed.
**No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R13-01** — raw HTML strong carriers rendered but semantically erased (`html_inline` silently SKIPped; `html_block` never inspected) | BLOCKER | **Explicit fail-closed raw-HTML policy, both token classes** (commission step 4): inline `<strong>`/`<b>` open/close tags are INTERPRETED as strong boundaries — a visible raw-HTML Status carrier is discovered and validated exactly like a Markdown one (the inline witness now reports its `MYSTERY` as a non-legend primary). Malformed, self-closing, interleaved, or unclosed raw strong structure is a conservative refusal; other inline raw HTML (comments, non-strong tags) contributes no strong rendering and is documented-transparent, not silently skipped. An `html_block` whose content holds Status-like text or a strong/b tag is a conservative refusal (the block-form witness fails there); unrelated raw HTML blocks pass — the raw-HTML positive companion demonstrates both directions | `validate_status_grammar_v13.py` (v12 byte-frozen in its stratum) |
| **SOL-R13-02** — prose exact-one accounting order-dependent (primary legends before the first carrier ignored) | BLOCKER | **Whole-surface, order-invariant exact-one** (commission step 5): all Status carriers and all strong labels on a surface are inventoried BEFORE role assignment; each carrier binds exactly one primary (its colon tail, or the next strong label, consumed); on a carrier-bearing surface EVERY unbound primary-legend label is a violation — before, between, or after the carriers alike. The `**HISTORICAL** / **Status: OPEN**` witness fails as an UNBOUND primary; the non-legend-annotation-before-carrier companion stays clean | same |
| **SOL-R13-03** — one valid carrier cleared the ambiguity tripwire for its whole physical line (and soft-wrapped carriers were falsely refused) | BLOCKER | **Token-level ambiguity accounting** (commission step 6): the `**Status` tripwire now fires on LITERAL TEXT in the parsed token stream — a resolved carrier's markers are consumed by the parser and leave no literal survivor, so a valid carrier clears only the construct it actually represents. The line-set bookkeeping (`carrier_lines`/`table_span_lines`) is **deleted**. The same-line witness fails on its unresolved `**Status` prefix; the soft-wrapped companion is counted once and not refused | same |
| **SOL-R13-04** — a table Status cell's later strong labels were checked only against the primary legend, never asked whether they were themselves Status carriers | BLOCKER | **Table-cell semantic inventory** (commission step 7): after the one admitted primary, any later strong label that is itself a Status carrier is refused under the explicit table policy (a strong Status carrier is not an inert annotation); non-legend strong annotations stay legal (inherited companion preserved). The category is closed, not the specimen: non-Status cells are inventoried too — a strong Status carrier or an unresolved `**Status` spelling there is a conservative refusal | same |

**Reproducibility surface (step 8):** the validator names its dependency and
tested versions in its docstring (markdown-it-py; tested 4.0.0 and 3.0.0),
prints the loaded parser version in every CLEAN line, and exits 3 with a
controlled diagnostic — never an import traceback — when the dependency is
absent. The R0.14 self-test was executed under BOTH declared versions
(4.0.0 and 3.0.0), PASS at identical totals.

**Controls (totals from the actual self-test, step 11):** SELF-TEST PASS —
**49 negatives caught / 27 positives clean** (at the readback's anticipated
49/27 cross-check: the five §7.9 witnesses + all 44 inherited; positives: the
three §7.10 companions + all 24 inherited, including the inherited valid table
companion with a non-legend strong annotation after its primary).
**Step 12:** the inline raw-HTML carrier, the pre-carrier primary, the
same-line ambiguity, and the secondary table carrier each demonstrated as
supplied ordinary files — exit 1 with the exact diagnostic. **Canonical
five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged**
(10/6 · 0/16 · 4/0 · 0/0 · 0/0), the parse model named in the CLEAN line.

**Census (step 14):** `OCCURRENCE-ADJUDICATION-R0.14.md` — R0.1–R0.13 scope;
**independent enumeration actually obtained: 136 rows · 113
HISTORICAL/PROVENANCE · 23 FROZEN-ARTIFACT NAME · 0 LIVE** — coinciding with
the anticipated cross-check; the generator reproduced the closed R0.13 census
(135 · 113/22/0) byte-exact before being trusted, and no classification was
reopened.

**Date coherence (step 15, mechanical rider §5.1):** in the R0.14 successor
copies only — the charter's top `**Date:**` field now carries the revision's
seal date with the original R0 draft date explicitly labeled; the owner
docket's current signature date now matches its banner (2026-08-12); the
succession docket's current signature date likewise. Attributed historical
dates (R0/R0.1-era registrar, corrections-clerk, and commission dates) are
preserved as the original-event dates they record. Frozen R0.13 untouched.

## Not reopened (readback §7 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and W-14 ·
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate design and substantive fork triage · non-commencement
clauses · every occurrence classification through R0.13 · every earlier
validator repair (controls preserved) · all fourteen frozen strata.

*— Concordance R0.14, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; solicits nothing.*
