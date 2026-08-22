# FINDING-TO-REPAIR CONCORDANCE — R0.15

**CANDIDATE R0.15 — 2026-08-12.** Exact mapping from the two commissioned
findings of `SOL-R0.14-READBACK.md` (filed, sha256 recorded in RETURN-R0.15)
to their repairs. R0 through R0.14 preserved byte- and mode-identical (fifteen
strata green at seal). The census and everything constitutional carried
closed. **No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R14-01** — the ambiguity guard recognized only the exact case-sensitive delimiter spelling `**Status`, so unresolved `__Status` and case variants were silent in every surface role | BLOCKER | **One symmetric surface-level ambiguity inventory** (commission steps 4–5): the token-local regex is **deleted**; the detector now runs on each surface's reconstructed VISIBLE text and refuses an unresolved strong-like Status spelling under EITHER Markdown strong delimiter (`**` or `__`), case-insensitively — the same case policy as carrier discovery itself. A parser-resolved carrier's delimiters are consumed by the parser and never reach the visible stream, so a valid carrier clears only its own resolved construct. The lone-underscore, case-variant, underscore-beside-valid-carrier, and status-cell-underscore witnesses all fail; the resolved `__[Status](…): OPEN__` companion stays clean | `validate_status_grammar_v14.py` (v13 byte-frozen in its stratum) |
| **SOL-R14-02** — the guard ran independently on each text/code token, so an unresolved visible `**Status` split across link or transparent inline tokens was silent | BLOCKER | **The visible stream rejoins split spellings** (commission step 6): text, decoded character references, code spans, and image alt text flow into one per-surface stream; soft/hard breaks flow as whitespace; markup boundaries (resolved strong/emphasis/strike/link delimiters) and INVISIBLE payloads (link destinations, raw-HTML tags with their attributes, comment bodies) contribute nothing. So `**` + linked visible `Status` reconstructs as `**Status` and is refused, a comment inserted inside `**Sta<!--x-->tus` cannot split the word, and `__Status` living only in a link destination or a raw-HTML attribute never counts — both link-split witnesses (prose and non-Status cell) fail; both invisible-payload companions stay clean | same |

**One documented policy, every surface role (step 7):** the same inventory
runs on prose surfaces, Status cells, non-Status cells, header cells, code
spans (via the stream), and code blocks/fences (content matched under the
same symmetric, case-insensitive pattern). A valid carrier may clear only
its own resolved construct — nothing else on the surface.

**Reproducibility surface (step 12):** dependency and tested versions named
in the docstring (markdown-it-py; tested 4.0.0 and 3.0.0), loaded parser
version printed in every CLEAN line, controlled dependency-missing exit 3.
The R0.15 self-test was executed under BOTH declared versions, PASS at
identical totals; the canonical run was likewise executed under both.

**Controls (totals from the actual self-test, step 10):** SELF-TEST PASS —
**56 negatives caught / 30 positives clean** (at the readback's anticipated
56/30 cross-check: the seven §7.8 witnesses + all 49 inherited; positives:
the three §7.9 companions + all 27 inherited). **Step 11:** the two prose
witnesses and the two table witnesses each demonstrated as supplied ordinary
files — exit 1 with the exact diagnostic (the link-split witness's
diagnostic exhibits the rejoined `**Status wording…` reconstruction).
**Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged**
(10/6 · 0/16 · 4/0 · 0/0 · 0/0) under both declared parser versions — which
also confirms (step 13) that the governed files contain no unresolved
ambiguity forms under the broadened symmetric detector.

**Census (step 14):** `OCCURRENCE-ADJUDICATION-R0.15.md` — R0.1–R0.14 scope;
**independent enumeration actually obtained: 137 rows · 113
HISTORICAL/PROVENANCE · 24 FROZEN-ARTIFACT NAME · 0 LIVE** — coinciding with
the anticipated cross-check; the generator reproduced the closed R0.14 census
(136 · 113/23/0) byte-exact before being trusted, its fail-on-live gate
teeth-checked; no classification reopened.

**Date coherence (step 15):** all current-revision date metadata in the
R0.15 copies remains coherent at the actual seal date (2026-08-12, verified
UTC); the labeled original-draft date and attributed historical dates are
preserved unchanged. Frozen strata untouched.

## Not reopened (readback §7 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and W-14 ·
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate design and substantive fork triage · non-commencement
clauses · every occurrence classification through R0.14 · every earlier
validator repair (controls preserved) · all fifteen frozen strata.

*— Concordance R0.15, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; solicits nothing.*
