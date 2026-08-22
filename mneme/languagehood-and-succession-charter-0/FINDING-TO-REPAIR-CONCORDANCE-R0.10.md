# FINDING-TO-REPAIR CONCORDANCE — R0.10

**CANDIDATE R0.10 — 2026-08-11.** Exact mapping from the three commissioned
findings of `SOL-R0.9-READBACK.md` (filed, sha256 `b7120b3f…`) to their
repairs. R0 through R0.9 preserved byte-identical (7/12/10/9/9/10/10/10/10/10
at seal). The census and everything constitutional carried closed. **No owner
disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R09-01** — the drawer guard is punctuation deletion, not a Markdown projection | BLOCKER | **v9's guard operates on a Markdown plain-text projection**: named/numeric character references decoded (`html.unescape`), raw inline HTML tags stripped, image syntax reduced to its alt label — then the Status-like test; any projected-Status-like header the grammar normalizer cannot reduce is a **coverage violation (conservative refusal)**, never a silent `0:0`. The three exact witnesses (`<em>Status</em>`, `&#83;tatus`, `![Status](status.png)`, each hiding `**MYSTERY**`) are committed negative controls — all refused. The property, not an allowlist: projection first, refusal on the remainder | `validate_status_grammar_v9.py` (v8 byte-frozen in its stratum) |
| **SOL-R09-02** — raw pipe splitting permits Status-column decoys | BLOCKER | **Logical-cell tokenizer with backslash parity**: an escaped `\|` is cell content (unescaped into the emitted cell), header and data rows share one column model. Both exact decoy witnesses (header-shift `Claim \| kind`; data-shift `r1 \| **OPEN**`) now expose `**MYSTERY**` and fail; the escaped-pipe valid companion counts its Status cell exactly once. The header-shift witness additionally demonstrated live as a supplied file → violation, exit 1 | same |
| **SOL-R09-03** — exact-one recognizes only the `**` strong spelling | BLOCKER | **Semantic strong enforcement**: primary-token recognition and the second-primary scan treat `**x**` and `__x__` as the strong emphasis both are. The exact witness `**OPEN** / __HISTORICAL__` fails as a double primary; `__OPEN__` is accepted as one valid strong primary (companion); non-legend strong annotations remain non-primary | same |

**Controls:** SELF-TEST PASS — **32 negatives caught** (all six exact §5
witnesses + all 26 inherited) and **14 positives clean** (the two new
companions + all 12 inherited). **Canonical five-file run: CLEAN, exit 0,
coverage byte-for-byte unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0).

**Census (custody continuation):** `OCCURRENCE-ADJUDICATION-R0.10.md` —
R0.1–R0.9 scope, ordinals and fail-on-live preserved, no classification
reopened; the closed R0.9 census (131 · 113/18/0) untouched.

## Not reopened (readback §7, obeyed)

The constitutional text · SOL-R04-01 · SOL-R08-02 and every census ·
the zero-LIVE conclusion · SOL-R02-03/W-14 · W-02…W-13 · languagehood and
authority holdings · independence coordinates · gate designs · substantive
fork triage · non-commencement clauses · all ten frozen strata.

*— Concordance R0.10, the chair (Claude Fable 5), 2026-08-11. Candidate;
adopts nothing; solicits nothing.*
