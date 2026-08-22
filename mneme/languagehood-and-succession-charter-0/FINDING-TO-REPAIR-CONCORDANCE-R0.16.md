# FINDING-TO-REPAIR CONCORDANCE — R0.16

**CANDIDATE R0.16 — 2026-08-12.** Exact mapping from the three commissioned
findings of `SOL-R0.15-READBACK.md` (filed, sha256 recorded in RETURN-R0.16)
to their repairs. R0 through R0.15 preserved byte- and mode-identical
(sixteen strata green at seal). The census and everything constitutional
carried closed. **No owner disposition solicited; nothing adopted; evidence
zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R15-01** — `html_block` judged by a raw source-substring test: comment-split and entity-split visible spellings inside blocks invisible; attribute-only spellings falsely refused | BLOCKER | **HTML-block visibility projection** (commission steps 4–5): the source-substring test is **deleted**; a block scanner projects the block to its VISIBLE text — tag syntax with attributes, comment bodies, declarations, processing instructions, and script/style content contribute nothing; separation-rendering tags become whitespace (no false word-fusion); comments and non-separating markup fuse (no false word-splitting); character references decode. The symmetric case-insensitive `**`/`__` Status inventory then runs on that projection. Raw `<strong>`/`<b>` markup inside a block, and any block the scanner cannot represent (unterminated comment/CDATA/PI/declaration/element, malformed tag), refuse before CLEAN. The comment-split and entity-split witnesses fail on the projected surface; the attribute-only companion passes with ordinary visible text | `validate_status_grammar_v15.py` (v14 byte-frozen in its stratum) |
| **SOL-R15-02** — raw strong tag identity erased: `</b>` could close `<strong>`; interleaved `<strong>…<b>…</strong></b>` passed | BLOCKER | **Exact construct identity on the boundary stack** (step 6): each stack frame records Markdown strong, `<strong>`, or `<b>`; a close token must match its exact opener — `<strong>` closes only with `</strong>`, `<b>` only with `</b>`. Mismatch, crossing/interleaving, malformed, and unclosed structure raise the conservative refusal, which the raw-strong screen guarantees fires on any Status-like or strong-bearing surface. Both witnesses fail with the mismatch diagnostic; the matched `<strong>Status: OPEN</strong>` companion counts as one valid declaration | same |
| **SOL-R15-03** — labels emitted only when the stack emptied: descendant carriers and primaries collapsed into the ancestor label in prose and after a valid table primary | BLOCKER | **Recursive strong-node inventory** (step 7): every strong node at every depth becomes its own label, in document order of its opening; an ancestor's label carries its full visible text, so no descendant carrier or primary disappears into it — "silence is not a role" now holds recursively. Uniform across prose, Status cells, non-Status cells, and headers, mixed raw/Markdown nesting included: the raw/raw and raw/Markdown prose witnesses discover their nested `Status: MYSTERY` and fail on the non-legend primary; the nested table-cell witness fails under the explicit after-primary carrier policy; the legal nested non-carrier annotation companion stays clean with its carrier counted once and no phantom primary | same |

**Reproducibility surface (step 12):** dependency and tested versions named
in the docstring (markdown-it-py; tested 4.0.0 and 3.0.0), loaded parser
version printed in every CLEAN line, controlled dependency-missing exit 3.
**Independently executed this round, stated exactly:** the self-test AND the
canonical five-file run were each executed under BOTH declared versions —
4.0.0 (`python3`, OpenGauss venv) and 3.0.0 (`/usr/bin/python3`) — on the
build host; identical results under both.

**Controls (totals from the actual self-test, step 10):** SELF-TEST PASS —
**63 negatives caught / 33 positives clean** (at the readback's anticipated
63/33 cross-check: the seven §7.8 witnesses + all 56 inherited; positives:
the three §7.9 companions + all 30 inherited). **Step 11:** the comment-split
block, mismatched-tag carrier, nested prose carrier, and nested table carrier
each demonstrated as supplied ordinary files — exit 1 with the exact
diagnostic (the block diagnostic exhibits the projected, fused
`**Status wording…`; the nested prose witness now reports its discovered
declaration). **Canonical five-file run: CLEAN, exit 0, coverage
byte-for-byte unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) under both
declared versions — confirming (step 13) that the governed files contain
none of the three hostile categories.

**Census (step 14):** `OCCURRENCE-ADJUDICATION-R0.16.md` — R0.1–R0.15 scope;
**independent enumeration actually obtained: 138 rows · 113
HISTORICAL/PROVENANCE · 25 FROZEN-ARTIFACT NAME · 0 LIVE** — coinciding with
the anticipated cross-check; the generator reproduced the closed R0.15 census
(137 · 113/24/0) byte-exact before being trusted, its fail-on-live gate
teeth-checked; no classification reopened.

**Date coherence (step 15):** current-revision date metadata coherent at the
actual seal date (2026-08-12, verified UTC); labeled original-draft and
attributed historical dates preserved unchanged. Frozen strata untouched.

## Not reopened (readback §7 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and W-14 ·
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate design and substantive fork triage · non-commencement
clauses · every occurrence classification through R0.15 · every earlier
validator repair (controls preserved) · all sixteen frozen strata.

*— Concordance R0.16, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; solicits nothing.*
