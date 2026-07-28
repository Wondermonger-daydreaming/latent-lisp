# D8 — COMPLETE DISPOSITION OF THE TABULARIUS F-1…F-17 INVENTORY

*Companion to `DEFECT-LEDGER.md`. Controlling inventory:
`audits/2026-07-28-stranger-audit/findings/TABULARIUS.md §1` (immutable).
Exactly one disposition per item, chosen from: REPLACE (with a predicate that
tests the label) · NARROW (label to what the predicate proves) · MERGE (with a
duplicate) · DELETE (as non-evidence) · PROSE (move from executable claim to
explanatory prose). No filler checks are added to preserve totals. The `done`
column is filled by execution.*

| item | where | defect | disposition | done |
|---|---|---|---|---|
| F-1 | APPLICATION census (389-392) | `n` compared to its own defining expression; advertised abbreviation-discrimination check absent | **REPLACE** — implement the advertised measurement: the census registers full identities AND their printed abbreviations; check asserts count of distinct abbreviations == count of distinct full identities. Tautology deleted. | [ ] |
| F-2 | selftest I4 (508-513) | hand-written slot literal, stale by two fields, cannot fail | **REPLACE** — enumerate the receipt's slots reflectively at run time and assert no slot name contains "CONTRACT"; the enumeration also asserts the full live slot census so a new slot is seen | [ ] |
| F-3 | selftest C3 (166-168) | `encode-term 'nil` vs `encode-term '()` — one object twice | **REPLACE** — compare `encode-term 'nil` against a hand-built expected datum `TERM{KIND=TERMKIND/SYMBOL, VALUE=COMMON-LISP/NIL}` (the claim the label states) | [ ] |
| F-4 | selftest G1 (436) / G4 (450) | byte-identical assertions, two counted checks | **MERGE** — G4 deleted; G1 keeps the nondeterminism label; the suite-conduct fact moves to prose beside it | [ ] |
| F-5 | selftest E10 (317-320) | "stable" tested by reading one read-only slot twice | **NARROW** — label becomes "the receipt's own identity is a bytes datum"; the self-comparison conjunct deleted (real stability work already lives in I2/I3) | [ ] |
| F-6 | selftest M1/M2 (644-683) | hand-written `*exercised*` list; `:source-term-shared-structure` claimed exercised, produced nowhere; "nothing else is left uncovered" false | **REPLACE** — the suite's refusal helper records every refusal code actually observed into a live registry; M2 asserts the observed set against the catalogue's `:public-api` codes and names the exact uncovered remainder from measurement; a real Door-1 shared-structure check added (shared subtree → `:SOURCE-TERM-SHARED-STRUCTURE` fires and is observed) | [ ] |
| F-7 | selftest A5 (94-97) | label says "reports the length," code checks positive-integer plausibility | **REPLACE** — assert `identity-octets` equals an independently computed `(length (canonical-octets …))` | [ ] |
| F-8 | selftest L4 (609-611) / L8 (637-639) | L4 logically subsumed by L8; L4's "never reaches a receipt" untested | **MERGE** — L4 deleted; L8's label carries the absence claim exactly | [ ] |
| F-9 | selftest L2 (603-605) | "any minted object" enumerates three of four | **REPLACE** — enumeration extended to all four minted objects including the occurrence | [ ] |
| F-10 | selftest L3 (606-608) | "no setter of any kind" via name-substring scan | **NARROW** — label states exactly what is scanned (no external symbol names a SET-style mutator); the "of any kind" claim moves to PROSE citing `:read-only t` on every slot | [ ] |
| F-11 | selftest N4b/N4c/N7/O1/O3 | refusal asserted as "some error was signalled" | **REPLACE** — each asserts the specific condition type and upstream reason, on the N7b/O2 model; O3 (the load-bearing home-package conjunct) asserts `:symbol-not-home-in-namespace` exactly | [ ] |
| F-12 | selftest I6 (516-539) | downstream "failing" evaluation never asserted to fail; a different receipt measured | **REPLACE** — catch the specific Slice /2 condition, assert it fired, and compare the octets of THE receipt whose form was evaluated | [ ] |
| F-13 | selftest C6 (176-179) | "every encoded specimen term" is one specimen | **NARROW** — label names the one control specimen it checks | [ ] |
| F-14 | selftest N3 (727-741) | asserts "alpha" present, never asserts mutation absent | **REPLACE** — assert both directions ("alpha" present AND "Zlpha" absent), the REPRODUCTION.lisp model | [ ] |
| F-15 | errata-0.1/REPRODUCTION.lisp (274-293) | verdict prose stronger than predicates (finding 3: symbol presence ≠ immutable object; finding 4: fail-open-in-the-small) | **REPLACE** — finding-3 predicate asserts the third value satisfies `EXPANSION-OCCURRENCE-P` with a working identity accessor; finding-4 predicate asserts the symbol EXISTS and is `:EXTERNAL` (two-sided) | [ ] |
| F-16 | APPLICATION:42 · STUB:25 · REPRODUCTION:23 · REPRODUCTION-II:22 | instrument helpers reach the layer via bare `INTERN` / unguarded `FIND-SYMBOL` | **REPLACE** — all instrument `s1` helpers resolve via `FIND-SYMBOL` and refuse unless the symbol exists and is `:EXTERNAL` (the selftest's repaired form) | [ ] |
| F-17 | selftest comment (426-429) | the retracted nondeterminism sentence live in the tree | **DELETE** — replaced by a one-line supersession note pointing at Errata 0.1 §5 | [ ] |

Also under D8's umbrella (from D1): selftest **M4/M6** — REPLACE with the
executable public witness (Door 1 accepts, Door 2 refuses exactly
`:EXPANDED-NODES-EXCEEDED`), per the ledger's D1 entry.

*Counts are expected to move. The old totals (115/24/8) are custody figures of
the pre-repair tree, not obligations; the post-repair totals are whatever live
execution reports, captured in the canonical result lines.*