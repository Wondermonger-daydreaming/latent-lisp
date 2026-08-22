# MANY ACTS /0 — PARCEL B RETURN

STANDING: CANDIDATE PARCEL, returned for owner review. **Nothing here is adopted, accepted,
merged, published, or independent verification** (AP0 adoption Rider 2, binding: the phrases
"independently verified" and "independently validated" may not appear in any artifact of this
lane). **Zero evidence is earned by this round.** Seven of the eight items are *proposed
rulings*; a proposal is a proposal until the owner adopts, amends, or strikes it. The one
implemented item repairs a printed number and earns nothing.

Convened under **OWNER RULING 5 — P2R1 / `017ad2de` / PARCEL B (2026-08-10) §3**:

> * Parcel B may convene now.
> * Its jurisdiction is restricted to the **eight enumerated handoff items**.
> * It may proceed independently of P2-R1.
> * P2 and B must not be bundled.
> * S-freeze remains unreached.
> * PortJ-F/0, the hidden bank, and J2 remain closed.
> * Evidence earned remains **zero**.

Form per **OWNER RULINGS 1 — Ruling 5, Parcel B — Constitutional completion**:

> Must contain explicit proposed rulings and redlines … Do not disguise Parcel B as
> documentation cleanup. It legislates previously unwritten law.

---

## 1. Identities

| | |
|---|---|
| Base (Parcel A + `017ad2de` erratum integrated) | `b5f3dc29` |
| Parcel B tip at gate time | `c4efaf2c` |
| Tree at `c4efaf2c` | `2e4c6612afb259681fc90da2f464704cb93c8a83` |
| Lane subtree at `c4efaf2c` | `1c70843144666fc52205e2385e70821da03aeb51` |
| Branch | `ma0-parcel-b` (worktree `/home/gauss/ma0-parcel-b`) — **not merged, not pushed** |
| Commits | `8dbbc65c` (eight proposals + B2 RED witness) · `c4efaf2c` (B2 repair) · this return's commit (return + B2 GREEN witness + gate transcripts + citation corrections) |

The gates of §3 were run on `c4efaf2c`, i.e. on the tip **with the B2 repair applied and
nothing else pending**. The return commit that follows adds only this file, the transcripts
of those very runs, and six citation corrections inside the `parcel-b/` item files; it touches
no lane artifact and no runtime file.

---

## 2. The eight items, with status

Jurisdiction is the list in `MANY-ACTS-0-PARCEL-A-RETURN.md` "Parcel B handoff list"
(lines 690–747). **Eight items were found there and eight are returned. No ninth item was
opened**, and the tempting ones that were declined are named in §6 so the restraint is
auditable rather than merely asserted.

| # | Item | File | Status |
|---|---|---|---|
| B1 | The lane-wide standing banner contradicts the R1 adoption | `parcel-b/B1-lane-standing-banner.md` | **PROPOSAL-AWAITING-RULING** — 3 scope options × 3 language-clause options, none chosen |
| B2 | `ma0-diseases.sh` prints "5 controls clean" while six controls run | `parcel-b/B2-diseases-sentinel-second-field.md` | **IMPLEMENTED-RED-FIRST** |
| B3 | `r1/capture.sh`'s printed `PROVES     :` label | `parcel-b/B3-capture-proves-label.md` | **PROPOSAL-AWAITING-RULING** — 3 options, none chosen |
| B4 | May a returned-and-disposed report carry a supersession pointer? | `parcel-b/B4-supersession-pointer-on-returned-reports.md` | **PROPOSAL-AWAITING-RULING** — 3 options, none chosen |
| B5 | `V-ATOMS` is named law with no observable refusal code | `parcel-b/B5-v-atoms-observable-refusal.md` | **PROPOSAL-AWAITING-RULING** — 3 options, none chosen |
| B6 | No matcher-level concordance tooth exists | `parcel-b/B6-matcher-level-concordance-tooth.md` | **PROPOSAL-AWAITING-RULING** — 3 options, none chosen |
| B7 | No export-census gate exists | `parcel-b/B7-export-census-gate.md` | **PROPOSAL-AWAITING-RULING** — 3 options, none chosen |
| B8 | The "Rider 3" citation in Owner Ruling 2 §5 item 8 | `parcel-b/B8-rider-citation-in-the-governing-instrument.md` | **RESOLVED-BY-RULING** — Owner Ruling 3, opening disposition line |

### Why exactly one item was implemented

B2's repair is **mechanically determined once its ruling is given**: the printed field names
the control arms, the control arms are counted in `$CONTROLS`, and the branch that prints has
already established `CONTROLS == PAIRS`. There is one correct value and the code already held
it. Every other item requires **choosing** — which artifact classes "adopted" reaches (B1),
whether a tool may be reworded away from the evidence it produced (B3), whether a closed
report may carry a pointer (B4), whether a name becomes a code or is retired (B5), whether a
comparator should exist (B6), whether a count becomes a floor (B7). A parcel that picked those
silently would be the smuggling Owner Ruling 2 §6 forbids, wearing a diff.

**B8 was resolved before Parcel B convened**, by the owner, in Owner Ruling 3's opening
disposition line: *"And yes: the D5 citation is **Rider 2**; 'Rider 3' in my §5 item 8 was a
clerical error. Parcel A followed the intended rider correctly."* No ruling was edited; a
filed ruling is corrected by the later ruling that corrects it, never by editing the earlier
text.

---

## 3. Gates

**SBCL operation-check performed first, through the wrapper, before any Lisp ran:**
binary `/home/gauss/.local/bin/sbcl`, `(lisp-implementation-version)` → `2.4.6`, exit 0.

All gates were run **serially**, from this worktree, on the Parcel B tip `c4efaf2c`, with no
other hand in the tree and **no repository write in flight** — the disease runs snapshot the
checkout's porcelain before and after and would have failed closed otherwise; both reported it
UNCHANGED. Transcripts are committed under `parcel-b/gates/` and `parcel-b/b2-witness/`.

### Gate 0 — B2's GREEN witness (`parcel-b/b2-witness/GREEN-post-fix-diseases.txt`)

```
ma0-diseases: 5 diseases detected, 6 controls clean
  (6 disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH of its witnesses)
exit=0
```

against its RED predecessor, captured before any edit
(`parcel-b/b2-witness/RED-pre-fix-diseases.txt`):

```
ma0-diseases: 5 diseases detected, 5 controls clean
  (6 disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH of its witnesses)
exit=0
```

Both transcripts carry **six** `[PASS] control: the witness is GREEN on an unmutated replica`
lines in their bodies. The red one is the defect exactly: six clean control arms, summarised
as five.

### Gate 1 — lane selftest (expect 200/0)

```
$ sbcl --script mneme/language-many-acts-0/ma0-selftest.lisp
== TALLY: 200 passed, 0 failed ==
ma0-selftest: 200 checks, 0 failures
exit=0
```

### Gate 2 — full teeth (expect 15 attempted / 15 green / 0 red)

```
$ bash mneme/language-many-acts-0/ma0-teeth.sh
===========================================================================
 MANY ACTS /0 — TEETH TALLY
===========================================================================
  GREEN   0 LANE SUITE  ::  ma0-selftest: 200 checks, 0 failures
  GREEN   1 NO-INTERNALS  ::  ma0-teeth-no-internals: 10 files, 0 hits
  GREEN   2 W-NO-BLIND-REPLAY  ::  ma0-no-blind-replay: 7 checks, 0 failures
  GREEN   3 W-V-FOOTPRINT (program level)  ::  ma0-footprint-witness: 5 checks, 0 failures
  GREEN   4 CONCORDANCE  ::  ma0-concordance: 7 arms, 126 facets, 0 divergences
  GREEN   4b CONCORDANCE TOOTH  ::  ma0-concordance-tooth: 1 planted divergence, 1 detected
  GREEN   5 DISEASES  ::  ma0-diseases: 5 diseases detected, 6 controls clean
  GREEN   6 CAMPAIGN GATES  ::  ma0-campaign-gates: 9 gates, 0 failures
  GREEN   7 W-RES-NOT-AUTH  ::  ma0-res-not-auth: 22 checks, 0 failures
  GREEN   8 R1/D1 OWNERSHIP  ::  ma0-D1-ownership: 6 owned, 0 defect(s) present
  GREEN   9 R1/D2 BRANCH BINDING  ::  ma0-D2-branch-binding: 4 closed, 0 defect(s) present
  GREEN   10 R1/D3 CIRCULAR SOURCE (external watchdog)  ::  ma0-D3-circular-source: 6 closed, 0 defect(s) present
  GREEN   11 R1/D4 ENVIRONMENT CROSSWIRE  ::  ma0-D4-env-crosswire: 4 closed, 0 defect(s) present
  GREEN   12 R1 SEVEN-ARM COVERAGE  ::  ma0-coverage: 7 arms, 7 traversed, 0 uncovered
  GREEN   13 R1/D5 GENERATION SEAM  ::  ma0-D5-generation-seam: 43 closed, 0 defect(s) present

  sections attempted : 15
  green              : 15
  red                : 0
  omitted            : 0

ma0-teeth: 15 sections attempted, 0 red
exit=0
```

**Section 5 is the proof that the B2 repair needed no teeth edit.** The expectation
`'^ma0-diseases: [0-9]+ diseases detected, [0-9]+ controls clean$'` is byte-unchanged in
`ma0-teeth.sh` and matched the repaired sentinel `5 diseases detected, 6 controls clean`
without alteration. No gate expectation moved in this parcel; had one needed to, it would have
been part of B2's redline and shown there.

### Gate 3 — P3 holdout (expect 11/0)

```
$ sbcl --script mneme/language-many-acts-0/p3/run-p3.lisp
ma0-p3-holdout: 11 checks, 0 failures
exit=0
```

### Gate 4 — P4 holdout (expect 11/0)

```
$ sbcl --script mneme/language-many-acts-0/p4/run-p4.lisp
ma0-p4-holdout: 11 checks, 0 failures
exit=0
```

⚠ This is a **rerun**. P4's *first-run* exit code remains **missing** and is not supplied by
this or any later run (R1 adoption ruling, audit record item 9; execution step 5). Nothing in
Parcel B touches that.

### Gate 5 — One Act /0 (expect 173/0)

```
$ sbcl --script mneme/language-act-0/act0-selftest.lisp
== TALLY: 173 passed, 0 failed ==
oneact0-selftest: 173 checks, 0 failures
exit=0
```

One Act /0 was neither read for repair nor written to; its V-F digest gate is inside teeth
section 6 and passed.

**No gate was made green by exceeding an item's scope, and no item was reverted to
proposal-only for gate reasons.** The only runtime-touching item was B2, and it went green
with the teeth expectation untouched.

---

## 4. Changed-file inventory

### 4.1 Files changed by the B2 repair (the only runtime-touching change in this parcel)

| File | Change | Runtime output? |
|---|---|---|
| `experiments/latent-lisp/mneme/language-many-acts-0/ma0-diseases.sh` | sentinel's second field now prints `$CONTROLS` instead of `$DISEASE_COUNT`; the header's sentinel description corrected | **YES** — the green sentinel moves from `5 controls clean` to `6 controls clean`. No other line of output changes; no witness, mutation, or control arm is added, removed, or altered |
| `experiments/latent-lisp/mneme/language-many-acts-0/MANY-ACTS-0-FAILURE-MATRIX.md` | §5's prospective description of the sentinel corrected in the same commit as the code | no |

### 4.2 Files added (all new, all under `parcel-b/`)

```
experiments/latent-lisp/mneme/language-many-acts-0/parcel-b/
  B1-lane-standing-banner.md
  B2-diseases-sentinel-second-field.md
  B3-capture-proves-label.md
  B4-supersession-pointer-on-returned-reports.md
  B5-v-atoms-observable-refusal.md
  B6-matcher-level-concordance-tooth.md
  B7-export-census-gate.md
  B8-rider-citation-in-the-governing-instrument.md
  PARCEL-B-RETURN.md
  b2-witness/RED-pre-fix-diseases.txt
  b2-witness/GREEN-post-fix-diseases.txt
  gates/00-opcheck.txt
  gates/02-selftest.txt
  gates/03-teeth.txt
  gates/04-p3.txt
  gates/05-p4.txt
  gates/06-oneact.txt
```

### 4.3 Files NOT changed, and deliberately so

**No implementation or evaluator file changed.** `ma0-eval.lisp`, `ma0-validate.lisp`,
`ma0-environment.lisp`, `ma0-structures.lisp`, `ma0-compose.lisp`, `ma0-driver.lisp`,
`package.lisp`, `load.lisp`, and every witness are byte-unchanged. `ma0-teeth.sh` is
byte-unchanged. `r1/capture.sh` and the ten frozen captures in `r1/pre-repair/` and
`r1/post-repair/` are byte-unchanged. `MANY-ACTS-0-GRAMMAR.md`,
`MANY-ACTS-0-CONTRACT-CANDIDATE.md`, `MANY-ACTS-0-PRESSURE-REPORT.md`, `AUTHOR-GUIDE.md`,
`MANY-ACTS-0-RETURN.md`, `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md`,
`SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md`, both Parcel A returns, the R1 return, the R1
adoption record and receipt, and every filed owner ruling are byte-unchanged. Nothing in
`language-act-0/`, `portable-judge-0/`, `language-surface-account-0/`, or any other lane was
touched. The main repository working tree (`/home/gauss/Claude-Code-Lab`) and
`/home/gauss/ma0-main` were not touched.

The mechanical proof is `git diff --stat b5f3dc29..HEAD`: every path in it lies under
`experiments/latent-lisp/mneme/language-many-acts-0/`, and every path outside `parcel-b/` is
one of the two files in §4.1.

---

## 5. Redline index

Every redline below is written out **exactly** in the item file named; none but B2's has been
applied to any file.

| Item | Redline loci | Applied? |
|---|---|---|
| B1 | `package.lisp:3–6` (class-1 pattern) · `MANY-ACTS-0-GRAMMAR.md:3–6` (class-3 pattern) · every banner locus (Option B substitution, both long and short comment forms) · `AUTHOR-GUIDE.md:6–7` (three language-clause variants) · a new `MANY-ACTS-0-STANDING-NOTICE.md` (Option C). Inventory of 18 `.md` + 1 `.txt` + 24 source loci in that file's §5.1 | **NO** |
| B2 | `ma0-diseases.sh:70–78` (header) · `ma0-diseases.sh:299–303` (the print) · `MANY-ACTS-0-FAILURE-MATRIX.md:65–68` · `ma0-teeth.sh:241–242` examined, **no change required** | **YES** |
| B3 | `r1/capture.sh:73` (the label) · `r1/capture.sh:18–28` (the retention paragraph), in three mutually exclusive forms · optional `r1/pre-repair/capture.sh.as-captured` | **NO** |
| B4 | `MANY-ACTS-0-RETURN.md:1–3` · `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md:1–3` (Option 2 pointer blocks) · a new `MANY-ACTS-0-SUPERSESSIONS.md` with its initial table (Option 3) | **NO** |
| B5 | `MANY-ACTS-0-GRAMMAR.md:46–53` · `ma0-structures.lisp:48` · `ma0-validate.lisp:95` · `ma0-validate.lisp:140` · `ma0-validate.lisp:176–181` (Option 2 only) · `ma0-selftest-suite.lisp:159,162,165,168` (Option 2 only) · `AUTHOR-GUIDE.md:32` (Option 2 only) | **NO** |
| B6 | `MANY-ACTS-0-PRESSURE-REPORT.md:111–113` and `:117–119` · `ma0-teeth.sh:205–208` (illustrative insertion, Option 1 only) | **NO** |
| B7 | `MANY-ACTS-0-CONTRACT-CANDIDATE.md:114–120` in three mutually exclusive forms · a new teeth section (Options 1–2 only) | **NO** |
| B8 | none — resolved by ruling | n/a |

**Two redlines are flagged for the owner's attention because executing them would move a
number the adopted R1 record quotes:** B6 Option 1 and B7 Options 1–2 each add a teeth
section, so the floor's `15 sections / 15 green` becomes 16 or 17. Neither may be executed as
a quiet addition; both item files say so at the point of the redline.

**One more, flagged for the same reason:** B5 Option 2 changes an observable refusal code, so
a program's `ma0-result-refusal-code` would differ before and after. That is language-visible
surface, and the item says so rather than treating it as an edit.

---

## 6. Jurisdiction held at eight

**Eight items were in the handoff list and eight are returned. No ninth item was opened.**

Things noticed while working and **deliberately not acted on**, recorded here so the boundary
is auditable rather than merely claimed:

1. **`V-RES-AUTH` is an emitted code (1 site) that is not a top-level named law** in the
   grammar — it appears inside the V-AUTH bullet. This is the mirror image of B5's defect. It
   is *noted inside B5* as an adjacency to check when the refusal-code table is ruled, and
   **no proposal was drafted for it**: it is not one of the eight.
2. **`V-DATA` is emitted for two different obligations** — the validator's atom scan
   (`ma0-validate.lisp:176–181`) and a runtime unlawful-value-expression refusal
   (`ma0-eval.lisp:94`). Recorded inside B5 as a scope caution on that item's Option 2; not
   raised as an item.
3. **The R1 adoption receipt and record quote the pre-B2 sentinel** (`5 controls clean`).
   They are historical records of what the tool printed and were left byte-untouched. Whether
   they should ever carry a pointer is B4's question, not a new one.
4. **`MANY-ACTS-0-RETURN.md:26` carries `ma0-teeth: 9 sections attempted`** — a third stale
   figure of the same species as B4's `159` and `4 arms × 72`. It is folded into B4's Option-3
   registry table rather than raised as a separate item.
5. Nothing was done about the 28-place deficit register, the S-freeze, PortJ-F/0, the hidden
   bank, or J2. All remain exactly as Owner Ruling 5 §3 left them.

---

## 7. Earned / not earned

**EARNED: nothing. Zero evidence.**

Parcel B drafted proposed law and corrected one printed integer. It produced no new program,
no new fixture, no new gate, no new witness, no new comparator, and no new implementation. The
only runtime output that changed is a summary field that now reports a count the run had
already been making and already displaying, arm by arm, as six `[PASS] control` lines in every
transcript it ever wrote.

**Specifically NOT earned, and not claimed anywhere in these files:** adoption or adoptability
of the lane or of any proposal in it · independent verification, independent validation, or
independent reproduction · stranger authorship, stranger audit, or outsider inhabitation ·
guide-only semantic transmission · independent implementation · portability or portable
conformance · open-ended authoring or domain generality · multi-environment orchestration ·
transactionality or crash resumability · disease-conserving generativity · machine authorship.
The R1 claim ceiling is unmoved:

> A same-author, post-R1-freeze holdout program was expressible through the repaired Many
> Acts /0 candidate authoring surface without evaluator modification.

**No constitutional question was decided.** Seven items propose; none adopts. None of the 28
deficits was decided. No unwritten Common Lisp behaviour became project law by description. No
refusal code was minted, retired, or re-emitted. No count became an authorized floor. No
hidden-bank vector was created. No J2 instruction was issued. No One Act document was published
or adopted. No owner ruling was edited.

**Standing statements, made explicitly because the ruling requires them:**

- Jurisdiction was **held at eight**; a ninth item would have been a failed round.
- **Zero evidence** was earned.
- **Nothing is adopted.** The proposals are proposals; the implemented item is candidate.
- **Not merged. Not pushed.** The branch `ma0-parcel-b` lives in a worktree only.
- **S-freeze remains unreached.** PortJ-F/0, the hidden bank, and J2 remain closed.
- **P2 and B are not bundled.** Nothing in this parcel depends on, waits for, or anticipates
  P2-R1.

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
