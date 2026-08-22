# REPAIR DELTA — R2 → R3 (class-tagged census, 2026-08-12)

**Authority:** the owner's R3 Minimal Ratification-Blocker Repair /0
commission (second cold-seat review: three blockers).
**Base:** R2, sha256 `e11a03ca180cddf4494f7d58ed9496f1f2af4c4b5bf8975058ba8cf3043ff534`.
**Successor:** R3, sha256 `2bf7e64a45c627e6111a88697da1df38d1406f8174ba732d87b6f48765cc109e`.

## Charter delta: 62 changed lines, 9 hunks, all in-class

| Hunk (R2 lines) | Change | Class |
|---|---|---|
| 1, 3 | title/banner R2→R3 | 1 (metadata) |
| 9–27 | banner: repair authority, lineage R0.19→R1→R2→R3, base hash, delta pointers, BLOCKED notice | 1 |
| 56 | **current-self fix 1:** "of which this R1 is the current member" → "this R3" | 2 |
| 176–179 | §A.2 gate pointer → `GATE-C36-RECORD-3.md`; RECORD and RECORD-2 marked historical | 3 (consequential to gate re-establishment) |
| 1410 | **current-self fix 2:** "incorporated in this R1" → "this R3" | 2 |
| 1444 | **current-self fix 3:** "This is Draft R1" → "Draft R3" | 2 |
| 1457–1459 | **current-self fix 4:** closing signature "— Draft R1 … map step 2" → "— Draft R3 … under the R3 commission, on the R2 base" | 2 + 3 |

**Current-self census (commission §4):** exactly four current-self identity
references existed in R2, at R2 lines 55, 1410, 1444, 1457 — matching the
cold seat's count — and all four are corrected above. The remaining 31
`R1` tokens in R3 are historical references (predecessor R1, its hashes,
its incorporation delta, "Many Acts /0 R1", R1 Adoption Ruling, Rider 1)
and are deliberately UNTOUCHED.

## Legend machinery (classes 1, 2, 4 of §1)

- `generate_legend.py` (sha `34de924c…`): **real proleptic-Gregorian
  calendar validation** — shape check (exact zero-padded YYYY-MM-DD) then
  `datetime.date()` decides validity; correct leap years; no clock read;
  fail-closed before any output replacement. **Terminology invariant
  enforced on rendered output** (`check_terminology`, fail-closed): no
  non-`confers` row may be described with "conferring"; the phrase
  "conferring instrument" may appear only in `confers`-scoped sentences.
  Docstring/summary/proves-section prose migrated to role-aware language.
- `legend-sources.json`: **byte-unchanged** (sha `09cf1214…`) — the four
  repaired standing mappings and all roles preserved exactly; no schema
  change was needed.
- `STATUS-LEGEND-GENERATED.md`: regenerated, sha `73ffc6ec…`.

**generation_date denotes** (unchanged, recorded in the registry): the
effective date of the registry revision — the date of the governing owner
acts and repair commission; an explicit controlled datum, changed only when
the registry is revised under a recorded act; never an ambient clock read.

## Battery evidence (chair-run this session)

- Determinism: consecutive runs byte-identical at `73ffc6ec…`; post-battery
  regeneration reproduced it.
- **16/16 registry cases:** the prior 11 fault classes all fired (exit 2,
  nothing written) + **2026-02-31, 2026-02-29, 2026-04-31 REFUSED** +
  **2028-02-29 and 2027-11-30 ACCEPTED** (exit 0, generated).
- **3/3 terminology controls:** clean output passes; a mutant describing a
  `constrains` row as a "conferring instrument" is DETECTED; an unscoped
  universal prose sentence ("Every row's anchor is in its named conferring
  instrument.") is DETECTED.
- Prior-output-unchanged invariant HELD through the whole battery.

## Regression preservation (§8)

Verified this session on R3: W-13 verbatim-equality against the adopted
instrument re-proven mechanically (line-for-line) · W-02 and W-04 texts
present unchanged · "VERIFIED WITH EXCEPTIONS — 19 SUBSUMED / 8 PARTIALLY /
3 ABSENT" intact · directive 3.9 sentence intact · F-4 marked frames intact
· F-8's sole citizen sentence intact at its three sites · LM0 OPEN-UNOPENED
· the §J pin (`f799fb50`) at four sites · frozen strata, R1, R2
byte-preserved · registry mappings byte-unchanged. *Honesty note: two
regression probes initially tripped on the chair's own probe assumptions
(a line-wrapped sentence; the instrument's pin phrasing vs the charter's) —
both were probe defects, corrected and re-run; the surfaces were intact
throughout.*

*— Chair (Claude Fable 5), 2026-08-12.*
