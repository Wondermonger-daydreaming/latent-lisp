# MANY ACTS /0 — PARCEL A REPAIR RETURN (bounded, R1.1–R1.3)

STANDING: CANDIDATE PARCEL, returned for owner review. Nothing here is adopted, merged,
published, or independent verification (AP0 Rider 2, binding). **Zero evidence is earned by
this round.** This return contains **only** the three repairs ordered by **OWNER RULING 3 —
THREE INDEPENDENT PARCEL DISPOSITIONS (2026-08-10) §4** and their disclosure. Nothing else
was touched, added, improved, or reconciled.

**Parcel B remains closed until this bounded Parcel A repair is accepted.** Round P's repair
is independent of this one and is not bundled with it (Ruling 3 §4, final paragraph).

---

## 1. Identities

| | |
|---|---|
| Parcel A base (adopted) | `4bfc5278acf7d27508a0d4c3f584e76733e6d200` — "R1 adoption record: owner disposition addendum (Ruling 2 §2)" |
| Base tree | `0f0612c414fcc3d169c8bd0d75b1fcc4d00e49bc` |
| Base lane subtree | `47a7d41970e49e7de30840eba535f96e781cc3f7` |
| **Prior Parcel A tip** (the returned, audited parcel) | `fa6b12842e5b26e276a6c4d4722cf76c209a09d8` |
| Prior tip tree / lane subtree | `e8b2972fe8094488ef66a6350ffd22d0be6cdab6` / `91c4effbd75f33c930bc62413e00b10ccb325194` |
| **Repair tip** (the two documentary repairs; the identity every proof below is computed against) | `4846a02794b84c4f147a310f733ed33532fc2a13` |
| Repair-tip tree / lane subtree | `d9d03222182eb0599b910d6bd234296e73df1c66` / `1607c31b30870d8122adf2d6cef4f20419c5a548` |
| **Parcel tip** | the commit that adds *this file*, one commit later on `ma0-parcel-a`. **A file cannot carry its own commit hash**; it is reported in the returning agent's message and readable as `git rev-parse ma0-parcel-a`. It changes no subject file — its diff against the repair tip is this document alone, so every proof below holds unchanged at the parcel tip. |

Working location: worktree `/home/gauss/ma0-main`, branch **`ma0-parcel-a`**. Not merged, not
published, and **nothing was pushed by this repair**.

⚠ **Exact push state, checked rather than assumed.** `git ls-remote origin
refs/heads/ma0-parcel-a` returns `fa6b1284` — the branch already existed on the lab origin
(`github.com/Wondermonger-daydreaming/Claude-Code-Lab`) at the **prior** tip before this
repair began, put there by an earlier hand. The two repair commits `4846a027` and `b9dba505`
are **local to the worktree and are on no remote.** The public `latent-lisp` mirror is a
different repository and was not touched at all. This paragraph replaces a blanket "not
pushed" sentence drafted earlier in this return: the branch *had* been pushed, the repair has
not been, and a return that repairs false documentary sentences may not carry one.

**Commit list on `ma0-parcel-a`** (the five prior commits are unchanged and unamended; the
repair adds one subject commit plus this return's commit):

1. `fe695541` — (prior parcel) lane prose reconciled to adopted R1
2. `17fc44e3` — (prior parcel) comment-only repairs in scripts and one source
3. `cca1e26c` — (prior parcel) R1 fixture commentary `PROVES` → `TESTS WHETHER`
4. `d973dd96` — (prior parcel) the Parcel A return document
5. `fa6b1284` — (prior parcel) return §2 repair-tip/parcel-tip distinction
6. `4846a027` — **this repair**: A-R1.1 disease-count sentence + A-R1.2 continuation
   terminology, both owner-worded and inserted verbatim
7. *parcel tip* — this document

`git diff 4bfc5278 4846a027 --stat` → **16 files changed, 1011 insertions(+), 50
deletions(−)**, all inside the lane. Relative to the prior tip `fa6b1284`, exactly **two**
files changed:

```
 .../mneme/language-many-acts-0/AUTHOR-GUIDE.md              | 5 +++++
 .../mneme/language-many-acts-0/MANY-ACTS-0-FAILURE-MATRIX.md | 6 ++++--
 2 files changed, 9 insertions(+), 2 deletions(-)
```

---

## 2. A-R1.1 — the disease-count sentence (`MANY-ACTS-0-FAILURE-MATRIX.md` §5)

**BEFORE** (as returned at `fa6b1284`, closing the §5 preamble):

> `ma0-diseases.sh` prints the family count and the invocation count side by side and never
> substitutes one for the other.

**AFTER** — the owner's account, inserted verbatim:

> `ma0-diseases.sh` reports the family count in the sentinel’s first field and `$PAIRS` on
> the following parenthetical line. Its second sentinel field currently reuses
> `DISEASE_COUNT` and therefore prints `5 controls clean` although six controls ran; that
> runtime-output defect is deferred to Parcel B.

The replaced sentence was **false as written**, exactly as the ruling states. The owner's
replacement was checked against the script before insertion and it describes it exactly:
`ma0-diseases.sh` line 302 prints `"ma0-diseases: $DISEASE_COUNT diseases detected,
$DISEASE_COUNT controls clean"` — the family constant in *both* fields — and line 303 prints
`"  ($PAIRS disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH of its witnesses)"`.
That check is recorded here as an observation supporting the owner's text; it did not license
any deviation from it, and none was made.

**`ma0-diseases.sh` itself was not modified.** Runtime output is untouchable in Parcel A
(Ruling 3 §4: *"Do not change runtime output in Parcel A"*). The defect remains item **B2**
on the Parcel B handoff list in `MANY-ACTS-0-PARCEL-A-RETURN.md`, where it was already
registered; this repair makes the matrix's prose agree with the running script instead of
contradicting it.

---

## 3. A-R1.2 — continuation terminology (`AUTHOR-GUIDE.md` §4, "The continuation rule")

**BEFORE** — the continuation-rule statement Parcel A added ran straight from its first
paragraph into the witness list, with no definition of the word *continuation* and no
distinction between a returned `:host-fault` summary and a signaled host condition.

**AFTER** — the owner's governing distinction, inserted verbatim as a new paragraph
immediately after the rule statement and before the witness list:

> Here “continuation” means in-run sequencing after a structured act return. It does not mean
> retry, resumption after a program terminal or propagated condition, or crash resume; §10
> items 4 and 6 retain those prohibitions. A returned act-summary whose disposition is
> `:host-fault` is data. A signaled host condition is not an act-summary and propagates out of
> the walk.

Nothing else in the section changed: the rule statement, the three bullets (P4 "vindemia"
sequencing past a refused act, P2 β's structured mint refusal, the SEAL-ADDENDUM-2 ordering
ceiling), and the closing *branch-then-terminate* sentence stand byte-identical.

### §10 numbering verification (ordered by the commission)

The guide's §10 was read at the repair tip and its numbering **matches the owner's citation
exactly**:

| §10 item | Heading as it stands in the guide |
|---|---|
| 4 | **No retry, and no continuation.** *"A program that meets a stopping condition refuses. The lawful continuation for an uncertainty lives outside the program and is not invocable as program syntax."* |
| 6 | **No crash resume.** *"Same-image orchestration only. A killed runner leaves every completed constituent act durably journaled under One Act /0, and the **program** has no continuation story at /0."* |

Items 4 and 6 are precisely the retry/continuation and crash-resume prohibitions the owner's
sentence preserves. **No bracketed editorial note was needed and none was added**; no item was
renumbered, reworded, or moved.

This is **clarification of already-adopted behavior, not new law** (Ruling 3 §4). It states no
capability the lane did not already have and removes none.

---

## 4. A-R1.3 — executable modes (packaging only)

The prior parcel's loose copies of the four scripts were archived `0644` while Git records
`100755`. Verified on the prior tarball as received:

```
$ tar -xzf ~/Downloads/ma0-parcel-a-2026-08-10.tar.gz
$ stat -c '%a %n' …/artifacts/…/ma0-concordance.sh …/ma0-diseases.sh …/ma0-teeth.sh …/r1/capture.sh
644 ma0-concordance.sh
644 ma0-teeth.sh
644 ma0-diseases.sh
644 r1/capture.sh
```

Git's record at the repair tip, by contrast:

```
$ git ls-tree 4846a027 -- <the four paths>
100755 blob fe6bdd2b…  ma0-concordance.sh
100755 blob 2ad79de0…  ma0-diseases.sh
100755 blob e4162167…  ma0-teeth.sh
100755 blob 7cb8abda…  r1/capture.sh
```

**No file content changed to fix this**, and no repository mode changed — Git already held
`100755`. The defect was in the *packing step alone*, and the repair is in the packing step
alone: the repacked parcel materializes the artifact set from the committed tip and restores
mode `755` on those four paths, verified with `stat` before sealing and again after a fresh
extraction of the sealed tarball. `tar` preserves modes, so the mode now survives the
round-trip.

The replay account carries a new **explicit Git-mode comparison step**: the parcel's
`reconstruction/REPLAY.txt` now includes both the `git ls-tree` output for the four paths and
the `stat -c '%a %n'` output of the corresponding loose copies, shown side by side, so an
auditor can see agreement rather than infer it.

---

## 5. Gate results, verbatim

SBCL operation-check first, through the wrapper, before any Lisp ran:
`(lisp-implementation-version)` → `SBCL / 2.4.6`, exit 0, binary `/home/gauss/.local/bin/sbcl`.

All five gates were re-run **serially**, from the worktree, at the repair tip `4846a027`,
with no other hand in the tree, from `experiments/latent-lisp/`. The checkout's porcelain was
clean before and after the teeth run.

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
  GREEN   5 DISEASES  ::  ma0-diseases: 5 diseases detected, 5 controls clean
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

⚠ **Section 5's sentinel still reads `5 diseases detected, 5 controls clean` while six
disease/control invocations ran.** That is the deferred B2 defect, printed exactly as the
repaired §5 prose now says it prints. The sentinel is *evidence for* the repaired sentence,
not a contradiction of it — and its persistence is the proof that this repair changed no
runtime output.

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

⚠ A **rerun**, exactly as the adoption record has it. P4's *first-run* exit code remains
**missing** and is not supplied by this or any later run (R1 adoption ruling, audit record
item 9). Nothing in this repair touches it.

### Gate 5 — One Act /0 (expect 173/0)

```
$ sbcl --script mneme/language-act-0/act0-selftest.lisp
== TALLY: 173 passed, 0 failed ==
oneact0-selftest: 173 checks, 0 failures
exit=0
```

One Act /0 was neither read for repair nor written to; its V-F digest gate (`2b51b4df…`) is
inside teeth section 6 and passed.

---

## 6. Explicit disclosures

- **No runtime output changed.** The repair touched two Markdown files and nothing else. No
  `.lisp` file, no `.sh` file, no fixture, no program, no gate script was modified at any
  point. `git diff fa6b1284 4846a027 --stat` lists exactly `AUTHOR-GUIDE.md` and
  `MANY-ACTS-0-FAILURE-MATRIX.md`.
- **No historical capture was touched.** The ten preserved `r1/` captures, the frozen
  product-freeze subtree, `MANY-ACTS-0-RETURN.md`, `MANY-ACTS-0-R1-RETURN.md`, the adoption
  record, the receipt, and both seal addenda are byte-identical to the base.
- **The prior parcel is preserved.** `fa6b1284` and every commit under it are unamended and
  unrebased; the returned parcel `ma0-parcel-a-2026-08-10.tar.gz` (sha `c9df94e0…fb803cb0`,
  131,263 bytes, 20/20 green) remains valid on its own terms and is superseded only as the
  *current* candidate, never overwritten.
- **Zero evidence is earned.** No new program, run, witness, fixture, gate, or implementation
  was produced. No claim was raised. No constitutional question was decided. None of the 28
  deficits was touched. The R1 claim ceiling is unmoved.
- **Nothing is claimed as independent verification, independent validation, or independent
  reproduction** (AP0 Rider 2). The gates above are same-author reruns on one substrate.
- **Not merged, not published; nothing pushed by this repair.** The repair commits
  `4846a027` and `b9dba505` exist only in the worktree. The branch itself was already on the
  lab origin at the prior tip `fa6b1284` before this repair began (§1, checked with
  `git ls-remote`); the public `latent-lisp` mirror is a different repository and was not
  touched.
- **Awaiting owner acceptance.** This return exists to be judged, not to close anything.
- **Parcel B remains closed** until this bounded repair is accepted.
- **Scope discipline.** Three defects were named and three were repaired. Nothing observed in
  passing was fixed, tidied, or improved; anything noticed and left alone stays on the
  existing Parcel B handoff list, which this repair does not extend.

---

— repaired by SARTOR (Claude Opus), Parcel A bounded repair, commissioned by the chair
(Claude Fable 5), 2026-08-10
