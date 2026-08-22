# MANY ACTS /0 — CONTRACT (CANDIDATE, pre-code)

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1; rule and coordinates in `MANY-ACTS-0-STANDING.md`). This file's path
confers no standing on its bytes in either direction. Nothing produced here is independent
verification (AP0 adoption Rider 2, binding): the phrases "independently verified" and
"independently validated" may not appear in any artifact of this lane. The round that wrote
this document constructed a candidate; it did not adopt, merge, publish, or claim
independent usability (owner commission, FINAL DISPOSITION).

## 1. Exact predecessor identities

| Predecessor | Identity |
|---|---|
| One Act /0 adopted candidate | commit `461f2013d1a6feca2b13819ff6ae3f60617e8e82`, tree `1123c3c3326664f54d1d96547ba872a876cbd495` — CLOSED, UNCHANGED |
| Public adoption readback | public main `b27abc5e7084c750a6bfbbc72d20215bade497b1`, subject tree `42f91621da65a37a67a012523251af9c405a2f98` |
| Lab main at campaign preflight | `27cb84297d4816765b1cc5fa671e6781180d1223` (subject tree = readback above) |
| Reduced floor at preflight | PASS — 77 attempted / 77 passed / 0 blocked (profile ci, exit 0) |
| One Act V-F digest (must remain unchanged) | `2b51b4df26fe0fa1e4a156f9408a92f5a501aba9fa2401eb08e10a123f1264f0` |
| Candidate branch | `many-acts-0-candidate`; README front-door correction `f025ab44` |

## 2. What this lane is

The smallest closed authoring surface through which a finite Lisp+ program — represented
as inspectable data — sequences MULTIPLE adopted One Act /0 executions with lexical
binding, explicit outcome inspection, exact branching, and structured terminal results,
preserving: explicit authority · structured outcomes · durable per-act history · derive ≠
perform · no blind retry. Grammar: `MANY-ACTS-0-GRAMMAR.md`. Programs before grammar:
`MANY-ACTS-0-PRESSURE-REPORT.md`, `P1-EDITIO-BRIEF.md`, `P2-CUSTODIA-BRIEF.md`.

## 3. Placement and prohibitions (mechanical)

- Lives in `mneme/language-many-acts-0/`; ASDF system **`lisp-plus/many-acts-0`**,
  depending on `lisp-plus/act0` (and through it the public stack) — nothing else.
- Does NOT: modify the four One Act loader sources; change One Act exports or semantics;
  enter the `lisp-plus` umbrella (`*lane-order*` untouched); enter `verify-release.sh`'s
  executed gate table or its authorized counts (a `DECLARED … CANDIDATE-NOT-ADOPTED` row
  is the only permitted mention); alter frozen/adopted records; reference unexported
  symbols of ANY predecessor package (mechanically checkable: no `::` against predecessor
  packages anywhere in this lane's sources — a grep-clean obligation the selftest
  enforces on its own files).

## 4. The public act composition (the lane's declared architecture and its largest risk)

One Act /0 exports the act's first half (`run-act` over the seven adopted fixtures) and
the composer's INGREDIENTS, but not the composer. MA0's evaluator therefore owns
`ma0-complete-act`: an act-completion routine built EXCLUSIVELY from exported/public
operations — `build-f2..f5` + `lane-envelope` + `frame-event-id` + Journal /0 appends for
the frames; Capability /2 `declare-uncertain-effect`/`reconcile-uncertain-effect` for the
C-arms; Surface /2 derivation for the readback; `agreement-gate`/`correspondence-verdict`
for the verdicts — honoring the adopted law-chain: BIND-6 observed-vs-declared seat check
→ J-4b four-term `datum=` join → F2 (frontier NOT-CROSSED iff class B;
no-outcome-host-fault sentinels) → C-arms: declare-uncertain FIRST on C-ii, F3 frozen
BEFORE reconciliation with the language-side ledger answer, reconcile, F4 with the
correspondence verdict → readback → agreement gate → F5 → O-8 (a "disagree" verdict
REFUSES; it is a finding, never repaired by adjustment). Its ordering guard derives
"already appended" from the STORE's validated prefix (the law), never from host tables
(the conveniences). Where `finish-act` reads internal context, MA0 substitutes public
routes: ledger answers via Capability /2 `world-ledger-lookup`; act-ids re-read from the
store via exported `frame-event-id` + `find-event` + `decode-pjs0` + `record-field`.

**Declared risk + its teeth:** this is a RE-COMPOSITION, and divergence from the adopted
composer is the lane's most serious possible defect. The failure matrix therefore pins
CONCORDANCE teeth: for every arm MA0 uses, an MA0-composed act and the canonical
`run-all-arms` act (separate images, separate stores) must agree on: frame kinds present
and absent, `classify-act-frames` classification, agreement row and verdict, and (C-arms)
correspondence row and verdict. Any divergence is a red witness, and "fixing" it by
adjusting expectations is disease-class behavior.

## 5. Runner law

One program per image (`ma0-run` script), SBCL 2.4.6/Linux, run root under `$TMPDIR`
outside the subject tree, removed on both success and failure. Same-image orchestration
only; NO program-level crash-resume (stated prominently: a killed runner leaves completed
acts durably journaled under One Act, and the PROGRAM has no continuation story at /0).
Deterministic evaluation order; deterministic output where fixtures permit; two-run
byte-identical stable-output obligation on the selftest.

## 6. Package / API surface

**`package.lisp` governs; this section describes it.** The account below is reconciled
against the adopted `package.lisp` as of R1 adoption (2026-08-10): **38 exported symbols**,
enumerated, each appearing in the `(:export …)` clause of `#:lisp-plus-many-acts0`. Where
this list and `package.lisp` disagree, `package.lisp` is the surface and this is the error.
*(Two symbols the pre-code draft of this section did not carry — `ma0-environment-stale` and
`ma0-environment-stale-store-id` — entered with the R1/D4 repair and are listed here now;
`:revocations` was likewise missing from the environment key list while the prose beside it
already spoke of journalling revocations.)*

Package **`#:lisp-plus-many-acts0`** (`:use #:cl`). Exports (closed):

- **Validation (4):** `ma0-validate` (source → validated-program or typed refusal) ·
  `ma0-validated-program-p` · `ma0-program-name` · `ma0-program-source` (defensive copy)
- **Environment (3):** `make-ma0-environment` (`:root :arms :grants :revocations :seat-map
  :inputs` — builds store/worlds/bootstrap/minting-context via exported predecessors;
  journals declared grants and revocations) · `ma0-environment-p` ·
  `ma0-environment-store-id`
- **Evaluation (2):** `ma0-run-program` (validated-program × environment → program-result) ·
  `ma0-complete-act` (the public composition; exported so teeth can drive it directly)
- **Result readers, immutable (8):** `ma0-result-p` · `ma0-result-program-name` ·
  `ma0-result-disposition` · `ma0-result-value` · `ma0-result-refusal-code` ·
  `ma0-result-refusal-detail` · `ma0-result-act-summaries` · `ma0-result-store-id`
- **Act-summary readers (6):** `ma0-act-summary-p` · `-arm` · `-act-id-hex` ·
  `-disposition` · `-class` · `-verdict`
- **Conditions and their readers (11):** `ma0-refusal` (base) · `ma0-refusal-code` ·
  `ma0-refusal-detail` · `ma0-source-refused` · `ma0-environment-refused` ·
  `ma0-authority-slot-unfilled` · `ma0-binding-refused` · `ma0-pattern-refused` ·
  `ma0-composition-divergence` · `ma0-environment-stale` (R1/D4: an environment built before
  a later `make-ma0-environment` took over the run-state specials, refused before the first
  consequential act, with zero footprint in either store) · `ma0-environment-stale-store-id`
- **Constants (3):** `+ma0-grammar-version+` (0) · `+ma0-arms+` · `+ma0-axes+`
- **Runner entry (1):** `ma0-selftest` (nonzero exit on failure)

4 + 3 + 2 + 8 + 6 + 11 + 3 + 1 = **38**.

⚠ **There is no export-census gate.** The pre-code draft of this section said "the census
gate asserts count and boundness"; no such gate was built, and no gate in this lane asserts
the export count or the boundness of every exported symbol. The 38 above is a *reading of
`package.lisp`*, not a mechanically enforced floor. (The one mechanical sweep over the
package's external symbols is `r1/D5-generation-seam.lisp`'s exposure check, which asserts
that no exported reader exposes the generation — a different obligation.) No census gate is
proposed here; naming its absence is.

No macros are minted. No surface head enters Surface /2's closed construct table. The
program-symbol package for IDENTs is a dedicated `#:lisp-plus-many-acts0.program`
namespace with no functions bound in it (names, not code).

## 7. Source / environment / authority separation

Per GRAMMAR §6. Additionally binding here: `make-ma0-environment` is the ONLY door
through which live state enters a run; it accepts DECLARATIONS (grant/revocation plans as
data) and constructs live objects itself via public predecessors; it never accepts a live
capability from the caller, and `ma0-run-program` retrieves slot occupancy from the
environment at each act step, explicitly, by slot name (disease D-AMBIENT plants the
dynamic-variable bypass).

## 8. Explicit non-claims

This candidate does NOT claim: adoption or adoptability · umbrella or floor membership ·
independent usability, stranger usability, independent inhabitation, or language
completeness · transactionality (no rollback/compensation/exactly-once/atomicity) ·
crash-resumable workflows · act-level domain generality (the /0 constituent-act inventory
is the seven sealed specimen arms; domain variation at /0 is program-level —
PRESSURE-REPORT §4 cap) · any change to the meaning, exports, or standing of One Act /0,
Surface /2, or any predecessor · determinism of external reality (only evaluator
determinism under declared fixtures) · that MA0's re-composition IS `finish-act` (it is a
public re-composition under concordance teeth; the adopted composer remains internal and
canonical).

## 9. STOP-fork status at sealing

P1/P2 as designed require NO change to adopted One Act semantics, NO effect-to-evidence
promotion, NO Surface /3, and NO program-level crash recovery. No STOP condition from the
commission's §10 is triggered at sealing. If implementation contradicts this, the lane
STOPS and returns the precise fork rather than repairing any older lane.
