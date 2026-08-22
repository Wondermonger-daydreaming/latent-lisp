# FINDING-TO-REPAIR CONCORDANCE — R0.17

**CANDIDATE R0.17 — 2026-08-12.** Exact mapping from the three commissioned
findings of `SOL-R0.16-READBACK.md` (filed, sha256 recorded in RETURN-R0.17)
to their repairs. R0 through R0.16 preserved byte- and mode-identical
(seventeen strata green at seal). The census and everything constitutional
carried closed. **No owner disposition solicited; nothing adopted; evidence
zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R16-01** — table headers bypassed the exact-identity recursive strong-node walk: a mismatched `<strong>Status</b>` header passed beside a valid row; a nested Status header disappeared into its ancestor's label | BLOCKER | **Headers enter the walk** (commission steps 4–6): every header cell now passes through the same shared walk as prose and data cells before column-role assignment. Mismatched, interleaved, malformed, or unclosed raw strong structure in a header refuses before CLEAN (the mismatched witness fails even with its valid row). Explicit descendant rule: a header whose projected visible text names the column classifies it; a descendant Status label inside a non-Status header is an **ambiguous header — conservative refusal** (both nested witnesses, raw/raw and raw/Markdown, fail there); it cannot disappear because an ancestor contributes the first visible word. The matched `<strong>Status</strong>` companion classifies its column with one valid cell; the nested non-Status annotation companion creates no phantom column | `validate_status_grammar_v16.py` (v15 byte-frozen in its stratum) |
| **SOL-R16-02** — inline raw HTML had no visibility state: script bodies counted as visible text (severing carriers and column discovery, and falsely refusing script-confined spellings), and `<br>` separation was deleted (falsely fusing words) | BLOCKER | **One stateful shared projection** (steps 7–9): a single walk (`walk_inline`) now produces BOTH the visible stream and the recursive label inventory for every inline surface — there are no parallel visibility helpers left to disagree. Element policy: script/style bodies contribute no text (the script-split carrier reads `Status: MYSTERY` and fails on its non-legend token; the script-confined ambiguity companion passes); separation-rendering tags contribute whitespace (`Sta<br>tus` stays separated and never becomes a carrier); comments and non-separating markup fuse; attributes and tag syntax contribute nothing; mismatched or unclosed content scopes are unrepresentable and refuse when Status-risky | same |
| **SOL-R16-03** — invisible Unicode format characters severed Status recognition after entity decoding while changing no rendered glyph | BLOCKER | **Bounded Unicode-format policy** (steps 10–11): a surface whose projected text contains any `Cf` format character and whose Cf-stripped text spells `status` (case-insensitively) is a conservative refusal — comparison-only stripping, refusing the disguised form; expressly NOT general NFKC or confusable folding. Applied uniformly through the one shared projection to prose, headers, Status cells, non-Status cells, the inline and block ambiguity screens, code spans (in-stream), and code blocks (content). The U+200B prose, U+2060 header, U+FEFF projected-block, and literal-U+200B code-block witnesses all fail | same |

**Reproducibility surface (step 16):** dependency and tested versions named
in the docstring (markdown-it-py; tested 4.0.0 and 3.0.0), loaded parser
version printed in every CLEAN line, controlled dependency-missing exit 3.
**Independently executed this round, stated exactly:** the self-test AND the
canonical five-file run were each executed under BOTH declared versions —
4.0.0 (`python3`, OpenGauss venv) and 3.0.0 (`/usr/bin/python3`) — on the
build host; identical results under both.

**Controls (totals from the actual self-test, step 14):** SELF-TEST PASS —
**72 negatives caught / 38 positives clean** (at the readback's anticipated
72/38 cross-check: the nine §7.12 witnesses + all 63 inherited; positives:
the five §7.13 companions + all 33 inherited). **Step 15:** the mismatched
header, nested header, inline-script prose, inline-script header, U+200B
prose, U+200B header, and projected-block witnesses each demonstrated as
supplied ordinary files — each NOT CLEAN with the exact diagnostic (the
script-split demos show the reconstructed `Status` discovered and its
`MYSTERY` refused; the Cf demos name the invisible-format refusal).
**Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged**
(10/6 · 0/16 · 4/0 · 0/0 · 0/0) under both declared versions — confirming
(step 17) that the governed files contain none of the three hostile
categories.

**Census (step 18):** `OCCURRENCE-ADJUDICATION-R0.17.md` — R0.1–R0.16 scope;
**independent enumeration actually obtained: 139 rows · 113
HISTORICAL/PROVENANCE · 26 FROZEN-ARTIFACT NAME · 0 LIVE** — coinciding with
the anticipated cross-check; the generator reproduced the closed R0.16 census
(138 · 113/25/0) byte-exact before being trusted, its fail-on-live gate
teeth-checked; no classification reopened.

**Date coherence (step 19):** current-revision date metadata coherent at the
actual seal date (2026-08-12, verified UTC); labeled original-draft and
attributed historical dates preserved unchanged. Frozen strata untouched.

## Not reopened (readback §7 out-of-scope list, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 and every
adopted jurisdiction/authority boundary · W-02…W-14 and their standing
classifications · gate architecture, triaged owner forks, and campaign
designs · substantive evidence adjudication · every occurrence
classification through R0.16 · all seventeen frozen strata.

*— Concordance R0.17, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; solicits nothing.*
