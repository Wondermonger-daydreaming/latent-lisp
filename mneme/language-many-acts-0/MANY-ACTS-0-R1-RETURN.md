# MANY ACTS /0 R1 — MEMBRANE REPAIR RETURN

STANDING: CANDIDATE. Nothing here is adopted, merged, published, or independent
verification (AP0 Rider 2 binding). Chair: Claude Fable 5, 2026-08-10, under the owner's
R1 MEMBRANE REPAIR ruling + environment-generation clarification + generation-seam final
check (all three recorded verbatim in this lane: `r1/`, `SEAL-ADDENDUM-2…`).

## 0. Identities

| | |
|---|---|
| R1 predecessor (§1, reconciled) | parcel tip `f83a06899bc82a…` / reported tip `76952ea4f278d2…` — ONE ledger-only commit apart; **subject trees IDENTICAL `f1e5e587…`**; base = `76952ea4`. Fail-closed: not triggered |
| Pre-repair red witnesses | `r1/pre-repair/` (commit `9dd43fb6`) — preserved, never regenerated |
| Four repairs | `66ed222a` · coverage `b0d1b844` · floor `0d70b516` · D5 seam `b1305aa9` |
| **R1 FREEZE** | commit `9bff7d02cad02e1e832a201ccd71a6d4a0607912`, tree `cfb454f44ded…`, lane subtree `e94870bd…` (at branch tip `231873c7`) |
| **P4 holdout** | `p4/` committed `ef98ede1`, authored and first-run strictly post-freeze |
| One Act /0 | CLOSED AND BYTE-UNCHANGED throughout; V-F digest `2b51b4df…` intact |

## 1. The earned R1 claim (exact ceiling, nothing more)

> **A same-author, post-R1-freeze holdout program was expressible through the repaired
> candidate authoring surface without evaluator modification.**

Witness: P4 "vindemia" (fourth materially distinct domain — aggregation-with-quality-gate;
P1 gate · P2 chain · P3 route · P4 harvest-aggregate), **green on first execution, 11/0**,
zero changes to grammar/evaluator/validator/fixtures after the freeze. It contains three
consequential steps (A returned · B-L1 refused-and-sequenced-past · C-ii interrupted),
branches on an exact structured outcome, carries an earlier act's derived standing as
ordinary program data into its refusal (`("vindemiator-quartus" :SETTLED)`), and its
fully-warranted press act (arm D) is witnessed unexecuted.

## 2. The four defects: red before, green after (all chair- and builder-verified serially)

| Defect | Red witness (preserved) | Repair | Green witness |
|---|---|---|---|
| D1 ownership (COPY-TREE shared string leaves) | mutated arm name made a validated program execute the wrong arm | datum-aware deep copy at every public boundary, both directions, mutable leaves included | `ma0-D1-ownership: 6 owned, 0 defects` |
| D2 branch-binding leak | accepted at validation, dead at runtime | independent lexical table per alternative | `ma0-D2-branch-binding: 4 closed, 0 defects` |
| D3 circular source non-termination | watchdog kill, exit 124 | cycle-aware walk, deterministic typed refusal inside the bound | `ma0-D3-circular-source: 6 closed, 0 defects` |
| D4 environment cross-wire | wrong store grew 638→6753 bytes under the first env's store-id | generation token (private, image-local, monotonic) — per owner clarification, NEVER store-id | `ma0-D4-env-crosswire: 4 closed, 0 defects` |

Generation-seam final check: **43 closed, 0 defects** — design lands on **property 2**
(commit point after every fallible step) after the fixture disproved property 3 (see §3).
Coverage closure: **7 arms / 7 traversed / 126 concordance facets / 0 divergences**.
Suite 159 → **200**, mechanically counted. Full floor: **15 sections / 15 green / 0 red**,
run serially by the repair hand AND by the chair (direct exit capture, both 0).

## 3. Findings registry (added to /0's; nothing concealed or deleted)

| ID | Finding |
|---|---|
| R1-F1 | **The chair's structural reading of the generation seam was WRONG.** Chair predicted property 3 "likely already holds"; the fixture proved a failed construction (1 of 6 public failure modes — oversize input refusing inside the ownership walk, post-increment) **staled a live environment**. Repaired to property 2. The instrument outranked the reading, exactly as the ruling's "executable proof" demanded. |
| R1-F2 | The default struct printer exposed the generation and live store/bootstrap/minting-context to any `~s` — found during the seam proofs, sealed with `print-unreadable-object`. |
| R1-F3 | **D2 fixture tension**: the ruling's "same local name used independently in separate alternatives" is refused by the SEALED no-shadowing law (V-BIND, define-once-anywhere); making it green would be grammar growth (not authorized). Satisfied as *refused-by-sealed-law, exhibited* — a pre-existing green fixture already asserted this refusal. |
| R1-F4 | **Post-branch binding is vacuous by sealed law**: V-TERM forbids any step after a branch, so no post-branch position exists; witnessed by fixture, not assumed. No flow analysis was added. |
| R1-F5 | **Content-derived store-ids cannot discriminate stores** (two environments from identical declarations share the id string; `ENV-IDS-DISTINCT=NIL`). Recorded, not repaired — the predecessor's scheme; MA0 uses ids as object labels only, never identity. |
| R1-F6 | The repair hand introduced two defects and caught both itself (deep-copy CDR recursion — the D3 class — caught by its own budget tooth; a label-to-filename bug that made a dead suite report clean). Recorded in `R1-REPAIR-NOTES.md`. |
| R1-F7 | Shared acyclic substructure policy: defined explicitly in the D3 repair (stated in code + notes), fixtures pin it. |

## 4. Pressure account (per ruling §6 — the governing vocabulary)

Recorded verbatim in `SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md`. The lane claims only:
*a program cannot initiate its dependent next act until the preceding One Act invocation
has returned its adjudicated structured outcome* — and never that source can observe or
branch upon an unresolved intermediate uncertainty.

## 5. Exclusions (unchanged, restated)

Not adoption or adoptability · not independent inhabitation (P4 is same-author) · not
act-level domain generality (seven sealed arms) · not a transaction system · not
crash-resumable · not multi-environment orchestration (the generation guard enforces the
single-active-environment cap; it does not license concurrency) · no stranger review
performed or simulated · Surface /3 shut · One Act unchanged · umbrella and governing
floor without new rows or count changes (`lisp-plus.asd` additions only).

## 6. Where everything lives

Repairs: `ma0-{structures,validate,eval,environment}.lisp` (frozen at `9bff7d02`).
Evidence: `r1/pre-repair/` (reds) · `r1/post-repair/` (greens) · `r1/R1-REPAIR-NOTES.md`
· owner texts verbatim in `r1/` + `SEAL-ADDENDUM-2…`. Coverage: `ma0-concordance*` (7
arms) + `r1/programs/`. Holdout: `p4/`. Campaign log (lab side):
`notes/2026-08-09-many-acts-0-campaign-log.md`.

The membrane is stitched, the stitches are bitten-tested, and one genuinely later
program breathed through the mouth without loosening a single one.
