# FINDING-TO-REPAIR CONCORDANCE — R0.11

**CANDIDATE R0.11 — 2026-08-11.** Exact mapping from the three commissioned
findings of `SOL-R0.10-READBACK.md` (filed, sha256 `0519ff51…`) to their
repairs. R0 through R0.10 preserved byte-identical (eleven strata green at
seal). The census and everything constitutional carried closed. **No owner
disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R10-01** — only the first Status column enforced; a decoy suppresses the guard | BLOCKER | **Every** normalized/projected Status-like column is validated (the `next()` first-match policy removed; each data row's cell in each Status column counted and checked), and **the conservative guard now inspects all header cells unconditionally** — a recognized Status column suppresses nothing. Exact witness (two Status columns, `**MYSTERY**` in the second) fails; companion (two valid Status columns) counts **2 cells**, clean | `validate_status_grammar_v10.py` (v9 byte-frozen in its stratum) |
| **SOL-R10-02** — raw-HTML projection breaks at quoted `>` | BLOCKER | **Quote-aware raw-tag scanner** (`"…"` and `'…'` attribute values may contain `>`; the closing quote, not the first angle bracket, ends the value — per the GFM raw-HTML grammar). The exact `<em title=">">Status</em>` + `**MYSTERY**` witness now projects to a Status label and is **refused** (coverage violation), never invisible | same |
| **SOL-R10-03** — strong enforcement compares raw interiors, not visible labels | BLOCKER | **Visible-label projection for every strong node** before legend comparison: character references decoded, tags stripped quote-aware, images and inline/reference links reduced to their labels, nested markup removed. Both exact witnesses (`__HISTORIC&#65;L__`; `__[HISTORICAL](https://example.com)__` beside `**OPEN**`) fail as the second primaries they visibly render; the non-legend strong-link companion (`__[note](…)__`) remains non-primary, clean | same |

**Controls:** SELF-TEST PASS — **36 negatives caught** (the four exact §5
witnesses + all 32 inherited) and **16 positives clean** (the two new
companions + all 14 inherited). The two-Status-column witness additionally
demonstrated live as a supplied file → violation, exit 1. **Canonical
five-file run: CLEAN, exit 0, coverage byte-for-byte unchanged**
(10/6 · 0/16 · 4/0 · 0/0 · 0/0).

**Census (custody continuation):** `OCCURRENCE-ADJUDICATION-R0.11.md` —
R0.1–R0.10 scope (two-digit-safe token matcher), **133 rows · 113
HISTORICAL/PROVENANCE · 20 FROZEN-ARTIFACT NAME · 0 LIVE**, ordinals and
fail-on-live preserved; the closed R0.10 census (132 · 113/19/0) untouched.

## Not reopened (readback §7, obeyed)

The constitutional text and languagehood holdings · SOL-R04-01 · W-14 and
W-02…W-13 · semantic-jurisdiction and authority boundaries · independence
coordinates · gate designs and substantive fork triage · non-commencement
clauses · every census through R0.10 and the zero-LIVE conclusion · all
eleven frozen strata · SOL-R09-02's escaped-pipe repair · every earlier
validator control not implicated by the three findings.

*— Concordance R0.11, the chair (Claude Fable 5), 2026-08-11. Candidate;
adopts nothing; solicits nothing.*
