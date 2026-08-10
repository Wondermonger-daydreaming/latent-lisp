# MANY ACTS /0 — SEAL ADDENDUM 1: substrate findings (post-seal, pre-freeze)

STANDING: CANDIDATE. This addendum was written AFTER the pre-code seal (`9e52b7e1`) and
DURING Phase 5 implementation review, BEFORE the implementation freeze and P3. It amends
nothing by rewriting: the sealed documents stand as committed; this file records where
the substrate proved their pre-code expectations wrong on VALUES, with the briefs'
sketches left intact as the honest record of what was believed at sealing. Chair-authored
(Claude Fable 5) from FABER's build return, chair-verified where noted.

## Finding 1 — P1's announcement conjunct named a wrong value

The sealed P1 brief gated announcement on `(:evidence-class :closure)`. Against the
substrate, arm A's completed act derives `:evidence-class :none` — consistent with One
Act's own agreement table row "A" (act0.lisp:1089). Gating on `:closure` made the happy
path unreachable. P1 as implemented names `:none`, and the selftest PRINTS the derived
values rather than silently asserting them. The pressure (announce only off re-derived
evidence, never off the act's return) is unchanged.

## Finding 2 — no program at /0 can observe an uncertainty UNRESOLVED (the round's sharpest)

The sealed P2 brief expected the α-branch to match `(:execution :uncertain-unresolved)`.
The ADOPTED act's law-chain includes the L19/L20 reconciliation pair INSIDE the act:
mid-act the seat stands `:uncertain-unresolved / :uncertain` (verified live by the
builder), but by act completion it derives `:reconciled / :reconciled`. Therefore:

- **The commission's pressure-2 prohibition is enforced BELOW the program.** A program
  cannot perform a dependent act "on unresolved uncertainty" because unresolved
  uncertainty is program-invisible at /0: the adopted operation resolves-or-refuses
  before returning. The prohibition is not merely honored — it is INEXPRESSIBLE to
  violate through this surface. This is the strongest available form of the law, and it
  is One Act's property, inherited, not MA0's invention.
- **The program-level exhibit is refusal on evidence that an uncertainty STOOD**: P2's
  α-branch matches `(:execution :reconciled)` — at /0 reachable only through a C-arm —
  and halts the chain. The dependent act demonstrably does not run.
- **What is NOT claimed:** that a program observes, holds, or adjudicates a live
  unresolved uncertainty. A lane wanting program-visible unresolved uncertainty needs an
  act door that stops before L19 — a future-lane question, NOT a request to change One
  Act (no STOP-fork: no One Act change, no effect-to-evidence promotion, no Surface /3,
  no crash recovery is required by P1/P2 as built).

## Finding 3 — pattern shape normalization

The briefs' sketches used bare conjunction lists; the sealed grammar defines `(:and …)`.
Both programs use the grammar's form. (The briefs said "final syntax fixed by
MANY-ACTS-0-GRAMMAR.md"; this is that clause operating.)

## Declared limits recorded during the build (carried in code and here)

- Declared revocations land at environment-construction time, not between acts: the
  TIMING is fixture; the pressure (a revoked grant refused at the later act's mint,
  earlier history intact) is real and witnessed.
- Journal /0 per-event digests are prefix-chained, not content addresses: no cross-store
  digest equality is claimed anywhere; no-erasure witnesses compare within one store.
- The arm→world-key column and grant-term values are REPLICATED from published One Act
  source (cited in code), because their accessors are internal; they are adopted-lane
  constants, not program knowledge, and the evaluator remains generic over programs.
- Phase-5 selftest (159 checks) deliberately EXCLUDES: concordance teeth, the five
  diseases, W-NO-BLIND-REPLAY, W-VF-UNCHANGED, W-ONEACT-GREEN, W-FLOOR-UNTOUCHED,
  W-P3-HOLDOUT — built in Phase 7 (teeth hand) and Phase 6 (chair). A green 159 says
  nothing about composer concordance; the suite header says so itself.
