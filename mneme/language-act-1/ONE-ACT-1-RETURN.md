# One Act /1 — RETURN

*Built by **PONTIFEX** (Claude Opus 5, subagent) on 2026-08-19, to the committed
work order in this directory. Every count below was observed in this session's
own output and is transcribed from the captures in this directory, not from
memory.*

---

## 0. Claim ceiling — VERBATIM from the work order §6

> Candidate · not audited · not adopted · not frozen · not on a governing floor
> until its additive row is accepted · same-family hands (builder+chair one
> lineage; fresh-context only) · planted-death crash model (no SIGKILL, no power
> loss, no mid-instruction truncation) · single fake world, scripted adapter
> subset · one seat, one effect kind · in-process, non-adversarial recognition
> (capability1's ceiling inherited) · the image-local issuance finding is a
> statement about core0's LAW, not a defect report.

Two additions the build itself earned, in the same register:

- **The lane is NOT registered** in `lisp-plus.asd` or `mneme/verify-release.sh`.
  That was instructed, and it is also right: a candidate does not put itself on a
  floor. The lane's door is `mneme/language-act-1/load.lisp`.
- **The refusal this lane demonstrates is OVER-DETERMINED.** capability /2's
  `authorize-effect-attempt` consults the same durable gate at the runtime
  boundary. The language guard is defence in depth at the LANGUAGE door; it is
  not the only thing standing between this lane and a double-apply. Said in the
  code (`act1.lisp:31-42`), in the RED proof's own transcript, and again in §3
  below.

---

## 1. The governing sentence, executed

> *The language door survives the process's death as a refusal: a genuinely new
> image, given only durable bytes and declared configuration, must refuse the
> same act at the `perform` boundary — and may proceed only through
> evidence-carried reconciliation at the runtime level.*

`de-actu-resurgente` runs it as four processes. The first life evaluates one
originating form through `perform`, crosses the frontier, the world durably
applies and ledgers the write, and the process dies inside the acknowledgment
window (exit 7, no sentinel). The second life — a genuinely new image with only
durable bytes and this specimen's declared configuration — **re-derives the same
act identity**, then **refuses the same act, pre-frontier, typed, with the
provenance in its reason**, refuses it again wearing a fresh attempt name,
structures the uncertainty, reconciles it against the surviving world with
evidence carried, and only then performs a **fresh act** on the freed seat,
which settles.

Observed: `de-actu-resurgente: 49 checks, 0 failures`, exit 0, twice, with every
preserved artifact and the whole transcript byte-identical between runs.

---

## 2. Sol's six demonstrations — graded

Grades are PROBATOR-style: **SHOWN** (executed evidence exists in this lane's own
captures), **PARTIAL** (real but incomplete, with the gap named), **NOT-SHOWN**.

| # | Demonstration | Grade | Where, and the executed evidence |
|---|---|---|---|
| 1 | operation reaches the runtime | **SHOWN** | `act1.lisp:689` (dispatch: guard → project/lexis → `authorize-effect-attempt` → `attempt-protected-effect`). Executed: selftest arm A (`act1-selftest.lisp:183`, journal read back with kinds `attempt:prepared · attempt:frontier-crossed · request:acknowledged · effect:settled`); specimen life 1 (`RUN-SPECIMEN.txt` phase 1: the world applied and ledgered the write before the death) and life 2's fresh act (`stage-restart.lisp:293`). |
| 2 | capability checked at the correct boundary | **SHOWN** (gap named) | Two boundaries, each exercised separately. Core /0's own frontier check refuses arms B-L1/B-L2 **before the bridge runs at all** — proved, not assumed, by the per-act verdict slot being unwritten (`act1-selftest.lisp:285-310`). capability /2's authorization refuses **inside** dispatch on arm R, asserted by typed condition + named facet `:fresh-derivation-refused` + requirement `CAP2-AUTH-1` (`act1-selftest.lisp:318-345`) — this pays One Act /0's deferred D1 debt. The restart re-earns authority per act (`run-act1` mints Office R at the prefix its own D1 will present against, `act1.lisp:1112`). **Gap:** no arm presents a *stale* capability across the death, because nothing in this design can carry one across a process boundary — the staleness path belongs to capability /1 and de-effectu-incerto, and is not re-demonstrated here. |
| 3 | permitted path produces specified journal evidence | **PARTIAL — and the shortfall is the lane's central fact** | The RUNTIME's evidence is complete and byte-compared: exact frame-kind sequences asserted from the validated prefix in every suite (`act1-selftest.lisp:214`, `stage-restart.lisp:316`), the post-death and final journals preserved as artifacts, and the final journal proved a **byte-prefix extension** of the post-death journal (`run-specimen.lisp` phase 5). **But this lane appends NO journal frames of its own** (builder fork F-1): the LANGUAGE's account of its act is Core /0 evidence, which is **in-image only and dies with the process**. The only language-side thing that survives the death is the *derived identity*, and it survives as a derivation rather than as a record. Grading this SHOWN would hide the finding the lane exists to expose. |
| 4 | recoverability in the manner the seam requires | **SHOWN at the crash axis** (planted-death model) | `stage-restart.lisp:71-104` (standing reconstructed from bytes: `:crossed-unsettled`), `:95` (identity re-derived and compared against the dying process's preserved file), `:213-272` (structure → reconcile `:applied` with the journaled external-request identity carried to the surviving world's ledger), `:274` (the lane's own reading of that resolution), `:288-330` (fresh act settles). World byte-unchanged across the reconciliation — it reads, it does not write. |
| 5 | denied path fails explicitly with no unauthorized transition | **SHOWN, with both warrants** | Every denied/refused arm asserts world-scope absence: whole cell store + whole request ledger (sha256 **and** octet counts), total ledger entries, entries under that arm's own request key, and the world directory's **file set listed** rather than assumed — with the universe printed in the arm's own output (`act1.lisp:880-950`, `act1-selftest.lisp:56-79`). **COMPETENCE:** the instrument is shown able to see a violation before any absence claim is trusted — `de-actu-resurgente/stage-control-leak.lisp` drives a REFUSED act that writes the world anyway (both defences deliberately down) and the predicate returns NIL. **`:could-not-look` is a distinct value from absent** and makes the comparison NIL rather than "unchanged". |
| 6 | result returns through the intended interface | **SHOWN** — ⚠ *corrected 2026-08-20, see §11* | `(values OUTCOME EVIDENCE)` and `outcome-kind` on every arm: `:committed` (settled acts), `:refused` (all five refusal shapes), `:indeterminate` (the acknowledgment-without-evidence arm). Pre-frontier refusals arrive as typed `core0-refused` carrying evidence-so-far and a refused outcome, asserted by type (`act1-selftest.lisp:254`, `stage-restart.lisp:134`). The refusal in life 2 is itself a demonstration of 6. |

### Grades this lane does NOT claim

- **NOT-SHOWN — real crash survival.** Planted deterministic death only. No
  SIGKILL, no power loss, no mid-instruction byte truncation.
  `journal0/de-teste-occiso` and `vertical0` own the real crash windows.
- **NOT-SHOWN — cross-death continuation at the LANGUAGE level.** By law; §4.
- **NOT-SHOWN — adversarial recognition.** capability /1's ceiling is inherited:
  in-process, non-adversarial.

---

## 3. What crossed the seam, and what did not

**Crossed the death:**

1. **The journal's bytes** — capability /2's frames, and the standing folded out
   of them. This is what the refusal is made of.
2. **The world's bytes** — the cell and the one ledger entry the dead process
   made. The asymmetry (*the world knows; the journal does not*) is the state the
   language door refuses from.
3. **The act identity — as a DERIVATION, not as state.** Its inputs are the
   domain string, the runtime seat, and the canonical request: all declared
   configuration. A new image rebuilds the row from configuration and derives the
   same 64-hex identity, compared against the file the dying process preserved
   (`stage-restart.lisp:95`). **A fresh attempt name does not change it**
   (`stage-restart.lisp:181`) — which is why the disguised retry is the same act,
   and the lane's derivation says so before its guard does.

**Died with the image, by design and stated as such:**

4. **The Core /0 evidence.** The language's own account of the act it was
   performing. It was never durable and this lane does not pretend otherwise;
   that is exactly why the resurgent image must refuse from bytes.
5. **The live capability.** A live capability is a fresh un-serializable token; a
   durable receipt is a record that authority existed, never live authority.

**What remained stubbed or excluded:**

- No lane-local journal frames (F-1). No PJ0→kernel0 rehydration of the lane's
  own; everything durable is capability /2's closed vocabulary.
- One seat, one effect kind, one fake world, a scripted adapter subset.
- No Memory Layer /0, no general rehydration, no evaluator (the work order's
  stop conditions; none was approached).
- Surface /3 untouched. No macro, no surface head, no expansion machinery, no
  Surface Account /0 involvement, no §19 reserved verb minted.

---

## 4. The crown finding, stated as core0 LAW

**Core /0's continuation door is IMAGE-LOCAL BY LAW, and this lane's refusal is
the shape that law takes at the language boundary across a death.**

`continue-from` (core0.lisp:1348) refuses any account whose *exact current
canonical content* is not registered as issued by Core /0 **in this Lisp image**
(`unissued-evidence`, core0.lisp:1377-1383). There is no public constructor for
`core0-evidence`; the four issuance sites are all inside `perform` and
`continue-from` themselves. Core /0 says so in its own words, at core0.lisp:1302:

> *This is NOT crash-survival: the event sequence survived because the image did.
> Nothing here demonstrates durability across process death.*

Therefore, **across a process death the language-level continuation is CLOSED BY
CONSTRUCTION** — not by omission, not by a missing feature, and not by a defect.
A resurgent image cannot hold the dead act's evidence, cannot fabricate it, and
must not pretend to. What it CAN do is exactly what this lane does:

- **refuse** the act at the `perform` boundary, from durable bytes
  (`act1-durable-guard-verdict`, act1.lisp:642 — its only input is the store);
- **reconcile at the RUNTIME level**, where the evidence is durable, carrying the
  journaled external-request identity to the surviving world;
- **perform a FRESH act**, with a fresh identity, on the freed seat.

This is a statement about Core /0's design, offered as a finding and not as a
defect report. It also explains why demonstration 3 is graded PARTIAL: the
language's durable account of its own act does not exist yet, and inventing one
was outside this lane.

---

## 5. The Memory-Layer-/0 interface answer (work order §8(d))

PROBATOR's finding about One Act /0 was that it is *a worked PATTERN, not a
drivable interface*: its fixture and record constructors are internal, its
request shape is hard-coded, and it publishes no normative export list. **One Act
/1 ships the door /0 lacked**, and it costs one disclosed deviation.

**A memory layer can drive this lane, today, with these exported symbols**
(package `#:lisp-plus-language-act1`; the loader package
`#:lisp-plus-language-act1-loader` provides `ensure-act1-lane`,
`act1-api-complete-p`, `act1-api-shortfall`, `act1-lane-files`):

| Purpose | Symbols |
|---|---|
| **Build an act row** (every column explicit; the row validates itself on construction) | `make-act1-fixture-row`, `act1-request-form`, `validate-act1-fixture-table`, and the whole accessor set `act1-fixture-{arm,label,language-label,runtime-seat,attempt-name,cell-segments,adapter-symbol,world-key,form,authority-mode,revoke-after-mint,durable-guard,interruption,runtime-defect,project-defect,leak-write}` |
| **Set up ground** | `act1-env-preflight`, `build-act1-store`, `build-act1-worlds`, `act1-opening-authority`, `act1-grant-terms-for`, `act1-capability-id-for`, and the specials `*act1-run-root* *act1-store* *act1-worlds* *act1-world-directories* *act1-bootstrap* *act1-minting-context* *act1-fixture-table*` |
| **Run one act and read what happened** | `run-act1` → `act1-result-{record,class,standing,disposition,outcome,evidence,reason,guard,refusal-type,context,bridge}` |
| **Ask the durable bytes directly** | `act1-durable-guard-verdict`, `act1-journal-kinds`, `act1-reconciliation-closes-seat-p`, `external-request-key` |
| **Re-derive an identity without performing** | `make-act1-record` (`:register nil`), `mint-act1-identity`, `canonicalize-act1-request`, `act1-request-record`, `act1-request-octets`, `act1-record-{act-id,act-id-hex,normal-form,request-rec,request-oct}` |
| **Assert absence over the world** | `take-world-scope`, `world-scope-unchanged-p`, `print-world-scope-universe`, `world-scope-snapshot-*` |
| **Build the bridge yourself** (if you want your own dispatch) | `make-act1-bridge`, `act1-dispatch`, `act1-ledger-query` |
| **Typed refusals to handle** | `act1-condition` + eight subtypes, `act1-condition-detail`, `act1-condition-requirement-id` |

**The precise gaps a memory layer must plan around — recorded, not glossed:**

1. **T4-LAW had to be widened** (builder fork F-2). One Act /0 forces
   `attempt-name = "a-<seat>"` because /0's seats feed Surface /2's
   `derive-seat-outcome`. One Act /1 *cannot* obey it: its subject is a seat
   carrying more than one act. This lane's rule is `"a-<seat>" | "a-<seat>-<n>"`,
   it has **no Surface /2 edge**, and it claims nothing about Surface /2
   compatibility. A memory layer that needs Surface /2 seat outcomes must
   reconcile that.
2. **The world's directory is not recoverable from a world object.** capability
   /2 exports no directory accessor, so `take-world-scope` takes the directory as
   an argument and the caller must have declared it. Every caller of `make-world`
   already has it; a layer that receives only a world object cannot take a scope.
3. **The grant issuer, subject, action and scope are lane constants**
   (`+act1-subject+`, `+act1-action+`, `+act1-scope+`, `+act1-issuer+`, internal).
   Per-act resources are the row's cell; the other four terms are not
   parameterised.
4. **`act1-opening-authority` grants once per DISTINCT seat.** A layer that wants
   per-act capability ids must not reuse a seat.
5. **The lane appends no frames of its own**, so a memory layer gets no
   language-level durable account from it (see §4).
6. **No ASDF row.** Consumers load `mneme/language-act-1/load.lisp` (which
   asserts completeness). If a chair adds `lisp-plus/act1`, the lane belongs in
   the COMPLETENESS-CHECKED class, and `act1-api-complete-p` is already the
   predicate for it.

---

## 6. Builder forks — every semantic choice the work order did not cover

Each was taken at the **narrowest** option available and is disclosed here rather
than left in the code.

- **F-1 · No lane-local journal frames.** One Act /0 projects five frames (F1–F5)
  into the journal. /1 appends none: every durable frame is capability /2's. The
  narrow reading of "the journal gains ONLY the lawful accounting frames (if
  any)" is *none*, and it keeps the lane inside capability /2's closed
  vocabulary as §5 prefers. **Cost:** demonstration 3 is PARTIAL (§2, §4).
- **F-2 · Attempt-name rule widened** to `"a-<seat>" | "a-<seat>-<n>"`, because a
  freed seat carries a second act by construction. No Surface /2 claim (§5.1).
- **F-3 · The durable guard is defence in depth, and the lane says so.** Since
  capability /2 already consults the same gate, the crown tooth kills on *which
  boundary answered* (the reason keyword), and the RED proof prints that fact in
  its own transcript rather than letting a reader infer that the guard is load-
  bearing on its own.
- **F-4 · The D1-refusal arm is a revocation committed between the Office R mint
  and the act** — a real shape (the grant is withdrawn while the act is in
  flight) and the one that makes capability /2's own authorization refuse. The
  named facet is exhibited by calling the same runtime door directly (a
  pre-frontier operation that journals nothing and touches no world byte),
  because the perform path projects a refusal into a reason keyword by design.
- **F-5 · The dying process preserves its derived act identity to disk** so the
  restart's re-derivation is *comparable* rather than merely assertable. The
  restart derives from configuration and compares; the file is what makes the
  claim falsifiable.
- **F-6 · The four lexis/shape checkers are re-implemented lane-locally** rather
  than imported from `#:lisp-plus-language-act0`. The grammars are One Act /0's
  owner-ruled ones, unchanged; the reason is load-graph containment (/0's lane
  pulls a Surface /2 edge this lane must not acquire for four predicates).
- **F-7 · A per-act, write-once verdict slot.** `perform` does not return the
  adapter report's `:reason`, and recovering it by parsing a condition's report
  text would make message text an interface (V-7). Each act carries one slot the
  bridge WRITES and NEVER READS; nothing dispatches on it; writing it twice is a
  lane fault, signalled (`act1.lisp:597`).
- **F-8 · The `:refused-across-death` class row** (`act1.lisp:1051`). Across a
  death, the standing derived under an attempt name can describe the DEAD act;
  One Act /0 could never see this. The row is admitted **only** when the
  journal's frame count is unchanged across the act — the checked form of "this
  act appended nothing" — and a moved frame count yields `:unclassifiable`, a
  host fault. Both directions are exercised in the controls.
- **F-9 · Planted seams in the shipped fixture** (`interruption`,
  `runtime-defect`, `project-defect`, `leak-write`), production NIL, following
  capability /2's own `defect` precedent. A mutant that only exists inside a test
  file proves nothing about the lane.
- **F-10 · The orchestrator BUILDS each child's environment**, filtering every
  Class I/II switch out of the parent's and adding back only what the phase
  intends. de-effectu-incerto appends to the parent environment; a leaked death
  switch would make a later phase lie.
- **F-11 · The competence control runs on COPIES** of the post-death state, and
  the orchestrator proves the real state byte-identical afterwards — so a
  deliberate violation cannot contaminate the capture it exists to license.

---

## 7. Gates, exact counts and exits

Full recipe and host conditions: `RUN-EXITCODES.txt` (walked, not inspected).

| Gate | Command | Exit | Result line |
|---|---|---|---|
| suite | `sbcl --script mneme/language-act-1/act1-selftest.lisp` | 0 | `oneact1-selftest: 37 checks, 0 failures` |
| controls | `sbcl --script mneme/language-act-1/act1-controls.lisp` | 0 | `oneact1-controls: 14 controls, 14 caught, 0 missed` *(11 before the 2026-08-20 repair; §11)* |
| mutants | `sbcl --script mneme/language-act-1/act1-mutants.lisp` | 0 | `oneact1-mutants: 3 defects, 3 killed, 0 survivors` |
| RED proof | `sbcl --script mneme/language-act-1/act1-red-proof.lisp` | 0 | `oneact1-red-proof: cured PASS, uncured FAIL — the tooth bites` |
| host-fault proof *(added 2026-08-20)* | `sbcl --script mneme/language-act-1/act1-host-fault-proof.lisp` | 0 | `oneact1-host-fault-proof: PASS` |
| specimen | `sbcl --script mneme/language-act-1/de-actu-resurgente/run-specimen.lisp` | 0 | `de-actu-resurgente: 49 checks, 0 failures` (twice, byte-identical) |
| VOID path | `CAP2_WORLD_DIE_IN_WINDOW=1` + the suite | 4 | VOID: variable named, no store created, no pass reported |

**Regressions, re-run after this lane landed** (captures in the session's run
files; all exit 0):

| Lane | Command | Result line |
|---|---|---|
| act0 | `sbcl --script mneme/language-act-0/act0-selftest.lisp` | `oneact0-selftest: 173 checks, 0 failures` |
| act0 | `bash mneme/language-act-0/act0-load-witnesses.sh` | `act0-load-witnesses: 6/6 cases green, tooth caught` |
| act0 | `bash mneme/language-act-0/act0-loader-disease.sh` | `act0-loader-disease: 3 diseases detected, 3 controls clean` |
| capability2 | `sbcl --script mneme/capability2/capability2-selftest.lisp` | `capability2-selftest: 29 checks, 0 failures` |
| capability2 | `sbcl --script mneme/capability2/capability2-controls.lisp` | `capability2-controls: 27 checks, 0 failures` |
| capability2 | `sbcl --script mneme/capability2/de-effectu-incerto/run-specimen.lisp` | `de-effectu-incerto: 29 checks, 0 failures` |
| core0 | `sbcl --script mneme/language-core-0/core0-selftest.lisp` | `Core /0 substrate teeth: 29 passed / 0 failed` |

**Zero edits outside this lane, verified rather than asserted:**
`git status --porcelain` and `git diff --stat` over `mneme/language-act-0`,
`mneme/language-core-0`, `mneme/journal0`, `mneme/capability0`,
`mneme/capability1`, `mneme/capability2`, `mneme/kernel0`,
`mneme/canonical-datum`, `lisp-plus.asd` and `mneme/verify-release.sh` both
return EMPTY.

---

## 8. Teeth that were seen to bite (nothing here is a clean pass alone)

- **The API-count gate fired during the build** — the declared total (97) did not
  match the sum of the declared lists (100), and the lane refused to load until
  it did. It is now 103 and re-asserted on every load.
- **The env pre-flight control caught a real defect in this lane.** The selftest
  originally called the pre-flight in advisory mode (`:signal nil`), so a run
  with `CAP2_WORLD_DIE_IN_WINDOW=1` failed one check and then went on to build a
  store and run arms with the death switch live, dying at exit 7 inside the
  frontier window. Fixed at `act1-selftest.lisp:132-138`. **A gate that reports and
  continues is not a gate.**
- **The leak control is caught TWICE, by two instruments neither of which was
  written for it:** the lane's own classifier (a refusal that left a settled
  standing is no lawful class → host fault) and the world-scope absence tooth.
- **Core /0 killed a mutant one layer earlier than expected:** with a NIL ledger
  token, `:refusal-swallowed-to-success` dies inside Core /0's manifestation
  constructor (kernel /0 `UNRESOLVED-IDENTITY`) — a fabricated commit cannot even
  be constructed. The mutant now forges a token precisely to reach *this lane's*
  predicate and put it under test.
- **The `:refused-across-death` row was shown unable to fire on a moved frame
  count**, and shown to fire on the true one.
- **The artifact comparator was shown to fire on a single flipped bit** (same
  length, one bit, different sha256).

---

## 9. Owner-docket items OBSERVED, NOT repaired (work order §8(e))

Reported, never patched — the floor's doctrine gates those edits on a ruling.
Both re-read on disk this session rather than carried from the work order:

1. **`mneme/language-act-0/package.lisp:7`** still reads *"STANDING: CANDIDATE.
   Nothing in this lane is adopted…"* while One Act /0 was ADOPTED on 2026-08-08.
   Stale-conservative: it understates the lane's standing, which is the safe
   direction, but it is not true.
2. **`mneme/verify-release.sh`** carries both the pre-adoption candidate comment
   (lines ~104-112: *"ONE ACT /0 … IS AN UNADOPTED CANDIDATE"*) and the ADOPTED
   status row (the `seam|ADOPTED|…` line, ~228) in one file. Both are in the
   shipped text; a reader of only one will be wrong.

---

## 10. Files

```
mneme/language-act-1/
  ONE-ACT-1-WORK-ORDER.md      the chair's committed order (unmodified)
  ONE-ACT-1-RETURN.md          this document
  RUN-EXITCODES.txt            the walked recipe + observed exits
  RED-PROOF.txt                the crown tooth shown to bleed
  RED-PROOF-HOST-FAULT-BEFORE.txt  the 2026-08-20 defect, reproduced (exit 1)
  RED-PROOF-HOST-FAULT-AFTER.txt   the same proof after the repair (exit 0)
  RUN-SELFTEST.txt             37/0
  RUN-CONTROLS.txt             14/14 *(11 before the 2026-08-20 repair; §11)*
  RUN-MUTANTS.txt              3/3 killed
  load.lisp                    the lane's door + completeness predicate (103)
  package.lisp                 interface, N-1 restated and unclaimed
  act1-fixtures.lisp           declared constants, nonce, worlds, W-ENV classes
  act1.lisp                    fixture table · identity · bridge · doors ·
                               the durable guard · the world-scope instrument
  act1-readiness.lisp          the readiness carrier (LAST form, LAST source)
  act1-selftest.lisp           six in-process arms
  act1-controls.lisp           fourteen planted faults *(eleven before 2026-08-20; §11)*
  act1-mutants.lisp            three planted defects, three named predicates
  act1-red-proof.lisp          cured vs uncured, same tooth
  act1-host-fault-proof.lisp   a host fault must not wear a refusal's clothes
  de-actu-resurgente/
    specimen-common.lisp       declared configuration and charge
    stage-life-1.lisp          the act, and the death in the window
    stage-restart.lisp         the crown, the disguise, reconciliation, the
                               fresh act
    stage-control-leak.lisp    the competence control, on copies
    run-specimen.lisp          the orchestrator (renders no verdict of its own)
    RUN-SPECIMEN.txt           49/0
    RUN-SPECIMEN-SECOND.txt    49/0, byte-identical to the first
    ARTIFACT-*.{pj0,pjs,txt}   both journal states, both world states, the
                               derived identity, sha256sums, manifest
```

---

*Nothing in this lane is adopted, and nothing in it is independent verification.
Builder and chair are one lineage; the outside has not read it.*

— PONTIFEX (Claude Opus 5, subagent), 2026-08-19

---

## 11. REPAIR ROUND — 2026-08-20 (Sol's cold-parcel blocking finding)

*Appended, not substituted. Everything above stands as it was written on
2026-08-19; §2 row 6 and §7's counts carry visible dated markers pointing here.*

Sol's cold static parcel review (archived verbatim at
`corpus/voices/received/2026-08-20-sol-cold-parcel-review-one-act-1-blocking-finding.md`)
verified all nine artifact hashes, both transcripts' byte-identity and the
journal prefix relation, accepted the lane as a CANDIDATE, and returned **one
blocking finding**. It was correct, and the reproduction was worse than the
summary.

### 11.1 The finding

`act1.lisp`'s D1/D2 `handler-case` caught **`(error (c))` — the whole Common
Lisp error hierarchy** — behind prose reading *"Every typed condition from D1 or
D2."* An unexpected implementation error raised before any attempt frame lands
leaves `derive-effect-standing` = `:absent`, which is **the same standing a
lawful pre-frontier refusal leaves**, so the handler converted it into
`%act1-refusal-plist` and `run-act1` classified a host fault as a lawful
`:refused` Outcome.

### 11.2 The RED proof (`RED-PROOF-HOST-FAULT-BEFORE.txt`, exit 1)

The plant lives in the **shipped dispatch**, not in a test file — the defect is a
property of that `handler-case`, and a plant anywhere else would prove nothing
about it. Fixture column `host-fault-plant` (production NIL);
`%act1-planted-implementation-fault` takes `CAR` of the process-name **string**,
raising a real `TYPE-ERROR` from the implementation. Deliberately *not*
`(error 'type-error …)`: a declared signal of an undeclared type is still a
declaration, and would not test what an *unexpected* error does.

Observed on the unrepaired lane:

```
  DISPOSITION            : :REFUSED
  CLASS                  : :REFUSED
  STANDING               : :ABSENT
  REASON                 : :TYPE-ERROR/-
  OUTCOME-KIND           : :REFUSED
  EVIDENCE-ISSUED        : T
  JOURNAL-FRAMES-MOVED   : NIL
  WORLD-BYTE-UNCHANGED   : T
```

**Two things the chair's summary did not yet contain, and both are worse:**

1. **A refused Outcome *and* a freshly issued Core /0 evidence account were
   manufactured for a `TYPE-ERROR`.** Not merely a mislabelled result — a full
   evidential record, issued in this image, attached to a host fault.
2. **The forged reason keyword was shape-identical to a legitimate one.** The
   chair asked what `act1-condition-requirement` does on a non-lane condition:
   its `typecase` falls through to `"-"`, producing `:TYPE-ERROR/-` — the same
   trailing `-` that the *legitimate* `:ACT1-DURABLE-GUARD/UNSAFE-RETRY/-`
   carries, because kernel /0's §14.1 fold genuinely has no requirement id.
   **The collision is how the defect hid**: nothing in the reason's shape said
   "this did not come from a capability."

Mercy, and the limit of the damage: **journal and world were byte-unchanged.**
This was a CLASSIFICATION defect, never a transition defect — demonstration 5's
grade is unaffected.

### 11.3 The repair

**The admitted families, enumerated by root, each read out of that lane's own
`package.lisp` rather than remembered:**

| Family root | Why it is admitted |
|---|---|
| `lisp-plus-capability2:cap2-condition` | `authorize-effect-attempt` / `attempt-protected-effect`'s own typed refusals |
| `lisp-plus-capability1:cap1-condition` | presentation, term mismatch, staleness |
| `lisp-plus-capability0:cap0-condition` | the fresh /0 fold beneath the authorization |
| `lisp-plus-journal0:pj0-condition` | the store beneath both of those |
| `lisp-plus-kernel0:kernel0-condition` | `unsafe-retry`, `duplicate-attempt-identity`, `unstructured-uncertainty`, the §14.x family |

**Deliberately NOT admitted, each absence a decision:**

- **`lisp-plus-core0:core0-condition`** — nothing in the protected form calls
  back into Core /0; Core /0 is the *caller*. One appearing here would mean the
  lane's own control flow is wrong, which is a host fault by definition.
- **`act1-condition`** — the lane's own contract violations (including
  `act1-project-report`'s, which is called *inside* the protected form) are
  **already** host faults. They are re-signalled unchanged by a first clause, so
  a complaint about a misprojection can never be reclassified into the very
  refusal it is complaining about.

Everything else reaches a final `(error (c))` clause that signals
`act1-bridge-contract-violated` with requirement **`ACT1-BRIDGE-2`** — no plist,
no Outcome, no evidence, no reason keyword, and **the per-act verdict slot is
left unwritten**, so not even the diagnostic sink can be read as a refusal.

Two supporting changes in the same pass, both disclosed:

- **New class row `:host-fault-pre-frontier`** (`act1-derive-class`): standing
  `:absent` + disposition `:host-fault`, gated on the same frame-count
  invariance as its `:refused-across-death` sibling. Since a pre-frontier host
  fault and a lawful refusal share the `:absent` standing, the table separates
  them by **disposition** — which is sound only because the narrowed handler no
  longer turns one into the other.
- **`act1-condition-requirement` extended** with the `cap0` and `pj0` branches,
  so those families' reason keywords carry their real requirement ids. The `t`
  fallthrough stays (post-frontier diagnostics still use it honestly) but is now
  unreachable from the dispatch handler — which was the whole hiding place.

### 11.4 GREEN (`RED-PROOF-HOST-FAULT-AFTER.txt`, exit 0)

```
  DISPOSITION            : :HOST-FAULT
  CLASS                  : :HOST-FAULT-PRE-FRONTIER
  REASON                 : NIL          OUTCOME-KIND : NIL
  EVIDENCE-ISSUED        : NIL          JOURNAL-FRAMES-MOVED : NIL
  WORLD-BYTE-UNCHANGED   : T
```

### 11.5 The permanent control (CONTROL 3b), in two halves

The gate is now in `act1-controls.lisp`, and **its second half is what keeps the
first honest**: narrowing a handler can always be "fixed" by refusing
everything, so the control also requires that a **lawful** refusal from an
**admitted** family — capability /2's `CAP2-AUTH-1`, on the same store, in the
same run — still classifies as `:refused` with its proper reason keyword and a
refused Outcome. Both halves caught. Controls: **11 → 14**.

### 11.6 Correction to §2, demonstration 6

The 2026-08-19 grade **SHOWN** was true of every *lawful* path and remains so;
the arms that produced it are unchanged and still green. It was **not** true of
the unadmitted-error path, which returned a **false** Outcome — and evidence —
through the intended interface. Corrected 2026-08-20: the grade now rests on the
narrowed handler plus CONTROL 3b's two halves, and the interface no longer
carries a host fault dressed as a result.

### 11.7 Gates after the repair (all exits captured directly)

| Gate | Exit | Result |
|---|---|---|
| selftest | 0 | `oneact1-selftest: 37 checks, 0 failures` |
| controls | 0 | `oneact1-controls: 14 controls, 14 caught, 0 missed` |
| mutants | 0 | `oneact1-mutants: 3 defects, 3 killed, 0 survivors` |
| RED proof (crown) | 0 | `cured PASS, uncured FAIL — the tooth bites` |
| host-fault proof | 0 | `oneact1-host-fault-proof: PASS` |
| specimen | 0 | `de-actu-resurgente: 49 checks, 0 failures`, twice, byte-identical |

**The specimen transcript is byte-identical to the pre-repair capture**, and all
eleven ARTIFACT-* files are byte-unchanged (git reports no modification). That
is the expected result and it is a check, not a hope: **no arm of the specimen
raises an unadmitted condition**, so the repaired branch is never taken there —
the repair touches only the path a host fault would take, and the specimen has
none.

Consumed-lane regressions, all exit 0 and unchanged: act0 `173/0`, act0
witnesses `6/6 + tooth`, act0 loader-disease `3/3`, capability2 `29/0` and
`27/0`, de-effectu-incerto `29/0`, core0 `29/0`. `git status --porcelain` and
`git diff --stat` over every consumed lane, `lisp-plus.asd` and
`verify-release.sh`: EMPTY.

### 11.8 What this round did NOT do

No One Act /0 docket item touched · nothing adopted or frozen · `SYNC-PAUSED`
untouched, nothing published · no Memory Layer /0 begun · no reviewer chain
opened · `lisp-plus.asd` and `verify-release.sh` untouched — the registration
rows are the chair's after this green.

### 11.9 Standing after the repair

The claim ceiling of §0 is unchanged in every clause. One sentence is now
better-earned than it was: a host fault of the lane's own implementation is
distinguishable, at the interface, from a capability's refusal — by disposition,
by class, by the absence of a reason keyword, and by the absence of an Outcome
and of evidence.

— PONTIFEX (Claude Opus 5, subagent), 2026-08-20
