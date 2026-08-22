# GATE RECORD 3 — Instrument C.3.6 RE-ESTABLISHED FROM ZERO — PASSED (for the R3 successor)

**2026-08-12. Chair record (Claude Fable 5), under the R3 Minimal
Ratification-Blocker Repair /0 commission §6.** Gate records 1 and 2 are
frozen historical evidence and inherit nothing here; this gate stands on
its own evidence, produced fresh this session after the calendar-validation
and terminology repairs:

1. Legend regenerated fresh — exit 0, 19 rows, 9 distinct standing instruments.
2. Source/date header verified: generator path, registry path + sha256, and
   the C.3.5 date (2026-08-12) with its recorded meaning.
3. Date semantics verified: an explicit controlled datum (registry-revision
   effective date under recorded acts); no ambient clock anywhere.
4. **Real calendar validity verified:** the validator now decides by
   proleptic-Gregorian construction (datetime.date) — 2026-02-31,
   2026-02-29, 2026-04-31 REFUSED fail-closed; 2028-02-29 (leap day) and
   2027-11-30 ACCEPTED.
5. Every anchor verified as a literal substring at generation time.
6. The 19-row standing-instrument/role invariant verified (registry
   byte-unchanged from the R2 repair).
7. The four repaired rows (RP4, RP5, LM0, SUCC) re-verified correct.
8. Deterministic regeneration proven: byte-identical at sha256
   `73ffc6ecd3cf7e46ae4b7a575301038fbf447e9acd56add7e8697dcd59e0e22c`.
9. All prior fail-closed fault classes rerun: 11/11 fired.
10. New impossible-calendar controls: 3/3 fired.
11. Leap-day positive control: passed (generated).
12. Failure-leaves-prior-output-unchanged invariant held throughout.
13. **Terminology invariant verified and teeth-checked:** clean output
    passes `check_terminology`; a mutant rendering a `constrains` row as a
    "conferring instrument" and an unscoped universal prose sentence were
    both DETECTED (fail-closed).
14. Fresh semantic/provenance readback performed:
    `PROVENANCE-READBACK-R3.md` (reads meaning; disclaims nothing).
15. This record issued only after 1–14 were green.

**Effect:** C.3.6 is satisfied for the R3 successor; cross-lane
constitutional reliance on `STATUS-LEGEND-GENERATED.md` (sha `73ffc6ec…`)
is EFFECTIVE under C.3's standing terms — the legend confers nothing; an
originating instrument wins automatically on conflict; re-derived, never
hand-edited; any future generation/readback failure blocks updated reliance
(C.3.7) and never alters underlying standing.
