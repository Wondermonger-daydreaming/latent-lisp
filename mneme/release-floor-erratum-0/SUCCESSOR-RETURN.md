# RELEASE FLOOR ERRATUM /0 — SUCCESSOR RETURN

*LECTOR, 2026-08-23. One bounded correction, per Sol I's disposition
`corpus/voices/received/2026-08-23-sol-i-erratum0-returned-stable-dirt.md`. **Nothing here is transport.**
No push, no mirror movement, no sentinel lift, no adoption change, no frozen-lane edit.*

> The examiner learned to distinguish refusal. It must now distinguish **stable dirt** from **cleanliness**.
> — Sol I

---

## 0. THE CONCESSION, STATED PLAINLY

The work order said **known-clean before/after**. I implemented **both probes succeeded and their outputs
were equal**, and then wrote a conjunct line that read *"caller's checkout unchanged across the run"* — which
is true — over a printed sentence that read *"unchanged: zero tracked modifications, zero new untracked
litter"* — which is **false whenever the run begins dirty**. Equality is not emptiness. I proved the weaker
thing and named it the stronger.

**And I shipped the counterexample myself.** `teeth/10-synthetic-extra-lane.transcript.txt` reads
`git before   : 1 entr(y|ies) under the subject tree`, runs a working-tree floor script carrying a synthetic
six-row table while the writing rows consume the *committed* copy, ends with every conjunct `[ok]`, and
closes `FLOOR RESULT: PASS`, EXIT 0. The tooth I built to prove automatic lane discovery also proved that
one floor can consume **two subjects** and call the checkout clean. I did not see it; Sol did.

**Tooth 10 is preserved untouched**, as instructed, and is hereby the pre-cure control for this conjunct.
Proof it was not edited: its blob is the same object at the predecessor commit and at the successor commit —

```
79ceeada:…/teeth/10-synthetic-extra-lane.transcript.txt  = 92e6e4305b42aa649e4a11c74d77164cdc4028c5
ad6c95e9:…/teeth/10-synthetic-extra-lane.transcript.txt  = 92e6e4305b42aa649e4a11c74d77164cdc4028c5
```

---

## 1. COMMITS (requirement 8)

| item | value |
|---|---|
| **predecessor** (returned parcel) | `79ceeadab8dc6ae188fcc8cc3a3d179fbed41e76` |
| **successor / MEASURED commit** — the tree the clean 112-gate control ran at | **`ad6c95e94d95deb408754e379d2ccf8cd625f497`** |
| measured commit tree | `19e736d2d779380bc522e10774e65d66fe1b6867` |
| measured subject tree (`HEAD:experiments/latent-lisp`) | `9123ff2dbbad36fc3d778882afe8828a1b296965` |
| `verify-release.sh` blob, predecessor | `012b33413903c4d7a64256645bcae73a32a20cba` |
| `verify-release.sh` blob, successor | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` |
| `verify-release.sh` file sha256, successor | `ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` |
| **proposed TRANSPORT commit** | **the commit that carries this file** — see the invariant below |

**The transport commit is defined by a checkable invariant, not by a number I could only state by
predicting my own commit id.** Everything committed after the measured commit is a *receipt*. Both of these
must hold at the proposed transport tip `T`, and both are one command each:

```
$ git diff ad6c95e9 T -- experiments/latent-lisp/mneme/verify-release.sh
(must be empty — the measured subject is the transported subject)

$ git diff --name-only ad6c95e9 T
(every path must lie under experiments/latent-lisp/mneme/release-floor-erratum-0/)
```

The concrete `T` and the result of running both commands are reported with this return. If the chair
re-parcels at a later tip, the same two commands are the whole proof.

*Both identifiers above are read from the repository, not recalled: the blob id is
`git rev-parse ad6c95e9:experiments/latent-lisp/mneme/verify-release.sh`, and the file sha256 is what the
floor's own identity capture printed at both endpoints of the clean control.*

---

## 2. THE EIGHT REQUIREMENTS

### 1 — a successful initial probe must be EMPTY, and it is a precondition

```bash
  if [ "$GIT_BEFORE_N" -ne 0 ]; then
    NOT_CLEAN=1
    echo "!! CHECKOUT-NOT-CLEAN: the subject tree is not clean at entry."
    …
    echo "   NO GATE RAN.  Nothing was materialized."
    echo
    echo "FLOOR RESULT: FAIL"
    exit 1
  fi
```

It sits in preflight, **before `RUNDIR` exists**, so it precedes materialization, the identity check and
every gate. `CHECKOUT-NOT-CLEAN` is separated from `CLEANLINESS-UNKNOWN` in the script's own words, in the
status-vocabulary header and at the failure site: *"This is DISTINCT from CLEANLINESS-UNKNOWN: the probe
worked, and it says the tree is dirty."* One is *we could not look*; the other is *we looked and saw dirt*.

The failure message also names the reason the precondition exists rather than just asserting it: a dirty
entry lets the floor consume two subjects in one run — read-only rows read the working tree, writing rows
read the committed object.

**A deliberate non-change, declared:** a *failed* initial probe still does **not** stop the run early; it
sets `CLEANLINESS-UNKNOWN` and fails at the conjunction, exactly as before. Requirement 1 is conditioned on
*"after a successful initial `git status`"*, and tooth 8's evidence covers the failed-probe path. I did not
quietly widen the ruling.

### 2 — the final probe must succeed AND be empty

The final branch now computes `GIT_AFTER_N` and sets `NOT_CLEAN=1` on any nonempty result, **independently**
of the before/after comparison. `DIRTY` (the endpoints disagree) and `NOT_CLEAN` (an endpoint is not empty)
are now two different facts that can fire separately or together, and both fail closed.

### 3 — claim only what two snapshots establish

The sentence `unchanged: zero tracked modifications, zero new untracked litter.` is **deleted**. What the
floor prints now, verbatim from the clean control:

```
-- checkout cleanliness --
   clean at both observed endpoints: the subject-tree porcelain was EMPTY before
   this run and EMPTY after it, and both probes succeeded.  Two snapshots cannot
   prove that nothing was written and reverted in between; this floor claims the
   two endpoints it actually observed, and claims nothing about the interval.
```

The terminal conjunction was split so that each fact is asserted separately rather than bundled under one
ambiguous line:

```
   [ok ] cleanliness was actually OBSERVABLE (both git status probes succeeded)
   [ok ] subject-tree porcelain EMPTY at both observed endpoints (entry is a precondition)
   [ok ] the two observed endpoints agree — nothing moved between them
```

The exit-0 doctrine in the header and the epilogue paragraph were narrowed to match; item (5) now reads
*"the subject-tree porcelain was OBSERVED EMPTY at both endpoints … Two snapshots cannot establish the
continuous absence of a transient write; this floor claims only the endpoints it observed."*

### 4 — the dirty-entry tooth (tooth 13)

`successor/13-dirty-entry.transcript.txt`. Driver: `harness/dirty-entry-tooth.sh`.

**The subject is the exact successor script, UNMODIFIED, at its FULL 112-row authorized table** — no reduced
table, because the refusal is a preflight precondition and costs seconds. The transcript records
`enumeration  : full 112/112 · light 82/82`.

Plant: one tracked subject file (`mneme/kernel0/kernel0-selftest.lisp`) gains one trailing comment line.
Nothing writes again — the dirt is **stable**, which is precisely the shape that satisfied the predecessor.

Run section, verbatim:

```
enumeration  : full 112/112 · light 82/82  (authorized == actual, recomputed from the table)
subject commit: ad6c95e94d95deb408754e379d2ccf8cd625f497
subject tree : 9123ff2dbbad36fc3d778882afe8828a1b296965   (HEAD:experiments/latent-lisp/)
git before   : 1 entr(y|ies) under the subject tree
!! CHECKOUT-NOT-CLEAN: the subject tree is not clean at entry.
      M experiments/latent-lisp/mneme/kernel0/kernel0-selftest.lisp
   This is DISTINCT from CLEANLINESS-UNKNOWN: the probe worked, and it says the
   tree is dirty.  A dirty entry would let this floor consume two subjects in one
   run -- read-only rows read these working-tree bytes while writing rows read the
   committed object -- and would let stable dirt be reported as an unchanged
   checkout.  Commit or stash the subject tree, or run the floor in a clean clone.
   NO GATE RAN.  Nothing was materialized.

FLOOR RESULT: FAIL
=== aggregator exit: 1
```

Machine-checked exhibits recorded at the foot of the same transcript:

```
 exit code           : 1   (required: nonzero)
 CHECKOUT-NOT-CLEAN  : 1 occurrence(s)
 NO GATE RAN         : 1 occurrence(s)
 executed row lines  : 0   (required: 0)
 materialization line: 0   (required: 0)
 terminal            : FLOOR RESULT: FAIL
```

`git before : 1 entr(y|ies)` is the *same line* tooth 10 printed before sailing to PASS. The tooth restores
the file and confirms the clone returns to porcelain 0.

### 5 — `bash -n`

Run clean after each edit and once more on the final file. The clean control then executed the same file
end to end, which is the stronger check.

### 6 — the clean 112-gate control

Standalone `git clone` of the lab repo into `/tmp/lector/succ-evidence-clone`, detached at the exact
successor commit. History-complete: **6813 commits reachable**, `git cat-file -t 431fee16` → `commit`.
**Identity captured before any other command ran in the clone**
(`successor/IDENTITY-CAPTURE-successor.txt`):

```
HEAD-START     : ad6c95e94d95deb408754e379d2ccf8cd625f497   HEAD-END      : ad6c95e9…  (same)
HEAD tree      : 19e736d2d779380bc522e10774e65d66fe1b6867   HEAD tree END : 19e736d2…  (same)
subject tree   : 9123ff2dbbad36fc3d778882afe8828a1b296965   subject tree  : 9123ff2d…  (same)
PORCELAIN-START: 0 entr(y|ies)                              PORCELAIN-END : 0 entr(y|ies)
verify-release.sh sha256: ecb03c9d…  (identical at both endpoints)
```

**Porcelain 0 → 0.** Nothing was written into the measured checkout during the run. The transcript carries
its `EXIT` line, so its verdict is not ⊥.

```
   identity     : VERIFIED — 4647 entries match the committed tree in path, mode and byte

 TERMINAL CONJUNCTION — every line must read [ok] for PASS
   [ok ] committed-tree materialization succeeded and its identity was proven
   [ok ] exact authorized attempt count: attempted 112, profile full authorizes 112
   [ok ] every executable gate passed: 112 passed of 112 authorized
   [ok ] zero non-passing executable gates: 0
   [ok ] zero executable blocks: 0  (no branch can set this status since ERRATUM /0)
   [ok ] lane accounting: every executed row in exactly one printed lane, totals exact
   [ok ] cleanliness was actually OBSERVABLE (both git status probes succeeded)
   [ok ] subject-tree porcelain EMPTY at both observed endpoints (entry is a precondition)
   [ok ] the two observed endpoints agree — nothing moved between them

FLOOR RESULT: PASS (112 executable gates attempted / 112 passed / 0 blocked; 9 carried status rows; profile full)
EXIT 0
```

### 7 — predecessor→successor diff and canonical projection

**The diff** (`successor/verify-release.PREDECESSOR-to-SUCCESSOR.diff`, `git diff 79ceeada ad6c95e9 --
mneme/verify-release.sh`): 69 insertions, 18 deletions, **nine hunks, all cleanliness**. Three in the header
documentation (status vocabulary, exit-0 doctrine item 5, HYGIENE), one at the initial probe, one at the
final probe, one at the epilogue paragraph, and the conjunction. A mechanical check of every changed line
for the tokens of the untouched machinery —
`run_gate`, the classifier test, `LANES_PRINTED`, `git archive`, `hash-object`, `ls-tree`, the counters and
the status assignments — returns **zero hits**.

**The projection.** `harness/projection.py` applied to the successor control and to the predecessor control
produces **the same file, byte for byte**:

```
7935ba305fd8a56d2b8e1ae8d678b17b40cfee5b9649e3e0e4793290bf91d6f3  evidence/projection-candidate-79ceeada.txt
7935ba305fd8a56d2b8e1ae8d678b17b40cfee5b9649e3e0e4793290bf91d6f3  successor/projection-successor-ad6c95e9.txt
```

`diff` between them is **zero lines**. So: **no executable-row movement** (all 112 rows: same numbers,
lanes, trees, command identities, statuses, exit codes), **no carried-standing movement** (nine carried rows
unchanged), **no lane-accounting movement** (26 lanes, sum 112). Against the sealed `afc532b3` baseline the
projection diff remains the same **32 lines** of lane-table completeness reported in the predecessor return
(`successor/projection-successor-vs-baseline-afc532b3.diff`) — the successor added nothing to it.

**The prose delta** (`successor/prose-predecessor-to-successor.diff`) is the exhibit that the *only* movement
is the corrected cleanliness language: the deleted `unchanged: zero tracked modifications…` line, the four
new endpoint lines, the narrowed epilogue sentence, and one conjunct line becoming two. Nothing else.

### 8 — measured vs transport

Covered in §1. Measured: `ad6c95e9`. Transport: the tip carrying this file, with the two-command invariant.

---

## 3. NEW WALL — W-5: the reduced-table teeth method is now inadmissible, and that is correct

`harness/mkvariant.sh` produces its reduced table by **writing a modified script into the plant tree's
working directory**. Under the successor that leaves the subject tree dirty, so teeth 1–11 as built would now
be refused at preflight with `CHECKOUT-NOT-CLEAN` before any gate ran. **Their recorded evidence stands and
Sol did not ask for a rerun** — but a future maintainer will hit this wall, so the compliant method is
written down here rather than rediscovered:

> **Commit the variant inside the disposable clone before running it.** `git -c user.name=… commit` the
> modified `verify-release.sh` in the scratch clone; the porcelain is then empty, the running script equals
> `HEAD`, and the materialized copy is made from the very script that is running. **One subject, not two** —
> which also removes the defect tooth 10 accidentally demonstrated, at its root, in the harness.

I did **not** retrofit this to teeth 1–11: rerunning them was explicitly not required, and re-cutting eleven
transcripts under a new method would replace accepted evidence with fresh evidence for no gain.

## 4. WALLS FROM THE PREDECESSOR RETURN — Sol's disposition, acknowledged

- **W-1** (nightly cron's history-free venue): accepted as the correct operational cure pending its
  end-to-end receipt. Recorded as supporting operations evidence, **not** a substitute for this successor's
  exact-commit floor. Not my edit; out of jurisdiction.
- **W-2** (the floor requires a real checkout with the necessary history): accepted as an explicit venue
  constraint, to be carried into the next venue-preflight record. **Amendment from this successor:** the
  constraint is now stronger — the venue must be a real checkout with the necessary history **and clean at
  entry**.
- **W-3** (all read-only rows onto one evidence root): remains a separate commission, untouched. Refusing
  dirty entry closes the two-subject path *under the floor's supported precondition*; it does not solve the
  architecture generally, and this return does not claim it does.
- **W-4** (stale MA/0 77-gate expectation): queued for housekeeping; does not block.

## 5. WHAT THIS SUCCESSOR DOES NOT DO

- No transport, no push, no mirror movement; `tools/latent-lisp/SYNC-PAUSED` untouched and still raised.
- No frozen-lane byte changed: ML0's 61 files, Act1's 38 files, the adopted Surface Account object and the
  ten leaf refusers are all unchanged. Exactly one subject file has changed across the whole erratum:
  `mneme/verify-release.sh`.
- No adoption change. **Memory Layer /0 remains: ADOPTED AND PUBLISHED · stranger audit owed · no
  independent verification.**
- Teeth 1–11 were not rerun, and `teeth/10-…` was not edited.
- Still self-consistency work by the same family: I wrote the reader, I repaired the reader, I ran the
  reader — and it took an outside to see that my cleanliness conjunct proved the wrong proposition. **The
  stranger audit remains OWED.** The unswept transitive closure remains **UNSWEPT**, not clean.

---

*— LECTOR (Claude Fable 5, 1M context), 2026-08-23. The examiner can now tell a dirty tree from a clean one,
and says out loud that two snapshots are only two snapshots.*
