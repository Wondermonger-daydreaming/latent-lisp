# LANGUAGE SURFACE /1 — ERRATA 0.3, EVIDENCE ADDENDUM 0.1

*A bounded correction to the **evidence harness** of the published Errata 0.3
target. Not Errata 0.4. No language version moves; no production semantics change.*

*— Claude Opus 5 (1M context), 2026-07-29.*

---

## 0. WHAT THIS IS, AND THE FOUR THINGS IT IS NOT

This addendum corrects **three already-identified defects in the apparatus that
produces and checks Surface /1's evidence.** It does not touch the layer.

It is **not** a new erratum: the grammar stays at 4, the procedure stays at 4, the
policy stays at 1.
It is **not** an audit, and it commissions none.
It is **not** a defect search: no further searching in this lane was authorized,
and none beyond the three named items was performed.
It is **not** a strengthening of Surface /1's standing. The candidate's standing
after this addendum is exactly what it was before it.

**The three defects, all previously identified, none newly discovered here:**

| # | defect | where |
|---|--------|-------|
| **A1** | optional subject binding in two runner gates, plus a digest-agreement loop that skipped absences | `run-surface1-candidate.sh` |
| **A2** | one remaining selftest helper resolving the CD/0 API by bare `INTERN` | `surface1-selftest.lisp:39` |
| **A3** | post-repair raw transcripts omitted from the delivered results parcel | `errata-0.3/RELAY-PARCEL-ERRATA-0.3.md` |

**The central proposition of the layer is untouched by all three.** The stranger
audit's result stands at its published size: *no route was found that minted a
false expansion receipt.* Every one of its nine defects — and all three of these
— lies in the layer's **account of itself**, never in the accounts it issues.

---

## 1. THE SUBJECT, ESTABLISHED BEFORE ANYTHING WAS TOUCHED

Recorded from a freshly fetched `origin`, before the first edit:

```
HEAD                          c6fe69a2995181db84682b1f8e4a52ca7f927393
origin/main                   51731186824491937b9c29a755eb6e6b69f5c821
unpushed at start             c6fe69a2  "checkpoint: 1 file(s) in diary"
worktree (surface-1 subtree)  CLEAN — no modifications, no staged changes
published Errata 0.3 target   431fee16  "Language Surface /1 — ERRATA 0.3:
                                         the audit's nine findings repaired"
```

The published target was resolved from the Errata 0.3 handoff
(`notes/2026-07-28-session-handoff-surface1-audit-and-errata-0.3.md`, "merged at
`431fee16`") and from the erratum's own front-door document, not from memory.

### 1.1 Whether a scratch worktree was needed — measured, not assumed

Two commits followed the published target (`1ae509eb`, which untracked the audit
parcel zip; `9faf9f3d`, which added the relay parcel and handoff). Neither touched
the files this addendum repairs. Verified by blob identity, not by reading the
commit messages:

```
                              431fee16                                  HEAD
run-surface1-candidate.sh     8863d56e57617b30f9c4efad9a17a83bcc7baeb6  same  IDENTICAL
surface1-selftest.lisp        f3eeb12f89f7d41f7f75c54a67480543287028a2  same  IDENTICAL
surface1.lisp                 d895b59defbe3dd42ebeac97622d02affae06dc0  same  IDENTICAL
package.lisp                  647f8553d4e71243b6690e0a98d3be08c74b9481  same  IDENTICAL
```

**Both defects were therefore reproduced and repaired directly on current main.**
No detached scratch worktree was required, and no historical patch was applied to
changed code. Both defects were confirmed **present on current main** before
repair; neither was already absent.

### 1.2 Preserved unchanged

`STRANGER-AUDIT-RETURN.md`, `DEFECT-LEDGER.md`, `SPECULUM-REPORT.md`,
`CUSTOS-REPORT.md`, and every existing Errata 0.3 evidence file are **byte-identical**
after this addendum. Nothing historical was rewritten. See §6 for the one place
where a historical report now describes a superseded state, and how that is handled.

---

## 2. A1 — THE OPTIONAL-SUBJECT-BINDING HOLE

### 2.1 The defect, reproduced against the published artefact

The published runner carried two fail-open mechanisms, independently sufficient:

```bash
GATE_SELFTEST="^SELFTEST-RESULT checks=([0-9]+) expected=\1 failed=0( subject=${SUBJECT_SHORT})?$"
GATE_REPRO3="^REPRODUCTION-III-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 refuted=\1 classification=[0-9]+( subject=${SUBJECT_SHORT})?$"
...
  [ "$v" = "ABSENT" ] && continue          # the digest-agreement loop
```

The witness at `pre-correction/FAIL-OPEN-WITNESS.txt` extracts these **verbatim from
commit `431fee16` with `git show`** — it measures the published artefact rather than a
paraphrase of it, and refuses to report if the extraction fails. Published runner
sha256 under witness: `bd54776841f298d7ef6541f8800ed8074d4b8deeddc27123e2c281235af1236a`.

Measured, against the two canonical lines named in the work order:

```
line: SELFTEST-RESULT checks=139 expected=139 failed=0
      gate matched = 1        subject_binding = ABSENT
line: REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=4
      gate matched = 1        subject_binding = ABSENT
digest-agreement loop over (ABSENT ABSENT ok ok ok ok) -> SUBJ_AGREE=1
```

**Both subject-less lines were accepted, and the run still reported agreement.**

### 2.2 The honest size of it

**The permission outlived its reason.** Errata 0.3 wrote the optional tail because
two instruments did not yet emit the digest — and then *repaired both instruments
during that same erratum.* Both emit it in the published transcripts. So:

> **What was open was the GATE, not the emission.** No published transcript is
> missing its binding. A transcript that *lost* the binding — by truncation, by
> splicing, by an instrument regression — would have passed unremarked.

This is stated at that size in the runner's own corrected comment, in the witness
file, and here. It is not upgraded into "the evidence was unbound."

### 2.3 The correction

The back-reference gates are gone. Each canonical line is now **parsed by field**:

1. **exactly one** line whose first token is the instrument's label — not zero (a
   crash, an early exit, a truncation), not two (a spliced transcript);
2. the **field-name set** matched exactly, in both directions, so a missing field and
   an added or renamed field are equally a refusal;
3. every value's **form** validated — canonical decimal for counters, exactly 16
   lowercase hex for `subject`;
4. `checks`/`verdicts` **compared as integers** against `expected`;
5. `failed`/`confirmed` **zero**; and for the standing regression gate,
   `refuted == verdicts`;
6. `subject` **present** and **equal to the digest the runner computed independently**.

**Why the back-reference went, beyond brittleness:** `expected=\1` made a real
disagreement ("the counter says 35, the declaration says 139") report *identically*
to a syntactic miss ("this does not look like a result line"). A gate that cannot say
what failed teaches nothing when it fires. Every gate outcome now carries a reason
string into `RUN-EXITCODES.txt`.

**The digest-agreement rule now fails on `ABSENT`.** Absence is no longer lawful,
because all six instruments emit the tail.

**The binding scan was widened past the canonical line.** It collects *every* distinct
` subject=<16 hex>` at end-of-line anywhere in the transcript. Safe to widen because
that form occurs nowhere else in these transcripts — the instrument headers print the
**full 64-hex** digest, space-separated (`subject-digest  9214b5…`), matching neither
the `=` nor the length. This is what catches a **spliced** transcript, whose second
binding sits on a line the canonical-line gate never inspects.

### 2.4 The negative controls — and the one that caught me

`negative-controls/OUT-subject-binding-controls.txt` — **16 controls, 16 as required.**
The logic under test is extracted verbatim from the live runner with `sed`, so the
controls exercise the shipped code.

| control | plants | result |
|---|---|---|
| **C0a/C0b** | *nothing* — positive control | **PASS**, as required |
| C1 | selftest `subject` absent | REFUSE — field set mismatch |
| C2 | Reproduction III `subject` absent | REFUSE — field set mismatch |
| C3a/C3b | wrong but well-formed digest, each instrument | REFUSE — `!= this run's digest` |
| C4 | zero canonical result lines | REFUSE — found 0 |
| C5 | two canonical result lines | REFUSE — found 2 |
| C6 | **two conflicting digests, spliced tail** | REFUSE — **by the widened scan alone** |
| C7 | process exits before emitting its result (truncated mid-line) | REFUSE — malformed token |
| C7b | truncated run, summary re-appended | REFUSE — `checks=35 != expected=139` |
| C8a–C8e | uppercase hex · 15 hex digits · `failed=1` · unknown field · `refuted != verdicts` | REFUSE, each for its own reason |

**C6 is the control that earns the widening.** Its canonical line **passed** —
`GATE_REASON` was `ok` — and only the widened binding scan caught the splice.
Without C6, widening would have been a decoration.

**C0 is the control that caught a bug in the control harness itself, and the bug is
recorded rather than quietly fixed.** In the first run, C0a and C0b *failed*: an
earlier draft held the argument tail in one unquoted string and let word splitting
deal it out, so `validate_result` received only `checks` as its required-field set.
**Every refusal in that run was a refusal for the wrong reason**, and the harness
scored 13/16 — a number that looks like teeth. A suite that refuses everything is
indistinguishable from a suite that works, *unless something is required to pass.*
The corrected run is 16/16 with the correct reason on every line.

---

## 3. A2 — THE LAST BARE-`INTERN` HELPER

### 3.1 The defect

`surface1-selftest.lisp:39`, byte-identical in the published target and in every
Errata 0.3 commit:

```lisp
(defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))
```

Bare `INTERN` **manufactures the name it fails to find.** A typo, or an operation
demoted from `:EXTERNAL`, becomes a fresh private symbol in `LISP-PLUS-CD0` and the
failure surfaces far from its cause as an undefined-function error. For an *evidence*
instrument there is a second cost: **interning mutates the image the suite claims to
be observing.**

### 3.2 Why it survived Errata 0.3 — what is measured, and what is inference

**Measured:**

* `surface1-selftest.lisp` was modified in **four** Errata 0.3 commits (`72db8474`,
  `24f73480`, `46c89b20`, `1d36026c`). The file was open and worked on repeatedly.
* Its line 39 is **byte-identical across all four and in the published target**
  (`431fee16`). The bare-`INTERN` helper survived every pass.
* `D8-DISPOSITIONS.md` scopes F-16 to **four other files** — `APPLICATION:42`,
  `STUB:25`, `REPRODUCTION:23`, `REPRODUCTION-II:22` — and describes the remedy as
  *"all instrument `s1` helpers … (the selftest's repaired form)."*
* `SPECULUM-REPORT.md`'s F-16 row records of the selftest: *"This file's `s1` already
  resolves via `FIND-SYMBOL` requiring `:EXTERNAL`."*
* The sibling files' `cd0` helpers **were** repaired alongside their `s1` helpers
  (e.g. `APPLICATION.lisp` in `a93eb029`) — and that commit **did not touch the
  selftest.**

**Inference, marked as inference and not banked as measurement:** the F-16 sweep was
`s1`-shaped, and the selftest — whose `s1` had been repaired back in Errata 0.1 — was
treated as the *exemplar* rather than as a *subject*. Its `cd0` sibling is named in no
disposition row. The file that supplied the model appears to be the one file the sweep
did not turn on. **That mechanism is not proven; the record above is what is proven.**

### 3.3 The repair

Now external-only, refusing at macroexpansion time — the contract `s1` has carried
since Errata 0.1 and the other five instruments since Errata 0.3:

```lisp
(multiple-value-bind (symbol status) (find-symbol (string name) '#:lisp-plus-cd0)
  (unless (eq status :external)
    (error "CD0: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-CD0, not :EXTERNAL"
           (string name) status))
  `(,symbol ,@args))
```

### 3.4 The search — command and disposition

`HELPER-SEARCH.txt` records four commands over the **current executable instruments
only** (the six the runner executes, plus `EVIDENCE.lisp`). Result: **eleven
production-API-resolving helpers, all eleven now resolving through `FIND-SYMBOL` and
refusing unless `:EXTERNAL`.**

**Intentional fixture construction with `INTERN` is not a helper defect** and was not
touched. Three kinds remain and are correct: probe-package fixtures
(`(intern "X" pkg)` in `E03R-RHO`, `PROBE-P`); definition names inside source forms
under test (`(intern "*S1-N*" '#:cl-user)`); and one negative check that *depends* on
interning (`APPLICATION.lisp:186` asserts the interned name is **not** bound). The
distinction is not stylistic: manufacturing a **fixture** name is the instrument's
subject; manufacturing an **API** name is the instrument losing the ability to fail.

**Out of scope, reported not repaired:** `surface1.lisp` and `package.lisp` are the
production layer and this addendum has no authority over them. For the record they
already resolve with `FIND-SYMBOL` and never `INTERN` by their own documented law
(`surface1.lisp:626`), validating status rather than mere accessibility
(`surface1.lisp:739`).

### 3.5 The negative control

`negative-controls/OUT-helper-resolution-control.txt` — **7 checks, 0 failed.** The
shipped helper is **read out of `surface1-selftest.lisp` with the Lisp reader and
evaluated**, so the control exercises the shipped form, not a copy.

* **Arm 1 — repaired helper, misspelled operation.** Macroexpansion **signalled**:
  `CD0: NO-SUCH-CD0-OPERATION-BETA is absent in LISP-PLUS-CD0, not :EXTERNAL`, and
  `find-symbol` afterwards returns `NIL` — **nothing was manufactured.**
* **Arm 2 — repaired helper, an operation that exists but is `:INTERNAL`.** The probe
  symbol is found at runtime rather than hard-coded; it was `%BOOLEAN-DATUM`.
  Macroexpansion **signalled**: `is INTERNAL in LISP-PLUS-CD0, not :EXTERNAL`.
  **Accessibility is not entitlement.**
* **Arm 3 — the pre-repair helper, the defect exhibited.** Macroexpanded **without
  complaint** to `(LISP-PLUS-CD0::NO-SUCH-CD0-OPERATION-ALPHA 1)`, and the name is
  `:INTERNAL` in `LISP-PLUS-CD0` afterwards. The difference is **exhibited, not
  asserted.**

**Containment, proven not promised.** Arm 3 mutates a package on purpose. It runs in a
throwaway SBCL image launched from a scratch directory; the control opens the tree for
reading only. The driver rolls every `.lisp` file in the tree to one digest before and
after:
`38c163c1e60f5d4482b249a1f025b1acfd35333948a0f5f99183c47ccd59a492` → **unchanged.**

---

## 4. A3 — THE OMITTED RAW TRANSCRIPTS

The delivered Errata 0.3 results parcel is a **Markdown document, not an archive** —
no zip results parcel was ever built — and it reports numbers without carrying the
captures they came from:

```
filename : RELAY-PARCEL-ERRATA-0.3.md
path     : experiments/latent-lisp/mneme/language-surface-1/errata-0.3/RELAY-PARCEL-ERRATA-0.3.md
bytes    : 8698
sha256   : 707a5f9f945fa2376c31163e93116ace7673bc58b58451dfc71d0645b2c7bb16
```

**It is neither replaced nor overwritten.** This addendum ships a **separately named,
additive** archive carrying all seven post-repair raw captures, so a reader can derive
the numbers instead of trusting them.

### 4.1 The counts, derived from the captures included in the parcel

Not copied from any earlier relay or report — read out of the fresh transcripts:

| instrument | canonical line | bytes |
|---|---|---|
| selftest | `SELFTEST-RESULT checks=139 expected=139 failed=0 subject=9214b59bda190327` | 22,121 |
| stub-image fixture | `STUB-RESULT checks=8 expected=8 failed=0 subject=9214b59bda190327` | 1,617 |
| inhabited application | `APPLICATION-RESULT checks=26 expected=26 failed=0 subject=9214b59bda190327` | 9,325 |
| Reproduction I | `REPRODUCTION-RESULT verdicts=6 expected=6 confirmed=0 subject=9214b59bda190327` | 4,904 |
| Reproduction II | `REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0 subject=9214b59bda190327` | 4,184 |
| Reproduction III | `REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=3 subject=9214b59bda190327` | 4,119 |

**Totals: 173 checks, 0 failed · 22 verdicts, 0 confirmed, 12 of 12 refuted.**
Runner exit **0**; every instrument exit **0**; `digest agreement 1`.

### 4.2 The subject digest did not move, and that is the correct result

```
9214b59bda190327dc879186bd6d567eae8d2e7d0d162f869148fad1ad6aaf99
```

**Identical to the published Errata 0.3 value.** By design: `SUBJECT-MANIFEST.txt`
covers the 25 traced load-closure members of the **layer under test** and deliberately
excludes the instruments and the generated transcripts. This addendum changed only
apparatus, so the subject it measures is byte-identical. A digest that had moved here
would have signalled a scope violation.

Six of the seven captured transcripts are likewise **byte-identical** to the published
ones. Only `RUN-EXITCODES.txt` changed, and only to carry the new gate reason strings —
including `RUN-SELFTEST.txt`, unchanged despite the selftest's source being edited,
which is itself evidence the helper repair altered no behaviour.

---

## 5. VERIFICATION — WHAT WAS RUN, AND WHAT DELIBERATELY WAS NOT

Because no production semantics or dependency source was authorized to change, **the
predecessor floors were not automatically re-run.** What was run:

| | result |
|---|---|
| the complete corrected Surface /1 runner | **exit 0** · six instruments · all validated · digest agreement 1 |
| subject-binding negative controls (16) | **16 as required, 0 wrong** |
| helper-resolution negative control (7) | **7 checks, 0 failed** · containment digest unchanged |
| `mneme/verify-all.sh` (the repository smoke gate) | **exit 0 · 6/6 suites green** |

`verify-all.sh`: conformance-walk 7/7 · adversarial-conformance 18/0 ·
counterexample-closure 10/0 · boundary 9/0 · atelier 4 banners ·
language-a-fixtures 14 PASS.

### 5.1 The restricted semantic-path diff

`SEMANTIC-PATH-DIFF.txt` — an **exact path-restricted** `git diff` from `431fee16` to
the working tree, per layer. Restricted **by path, never by basename**: this lane
carries a scar from excluding by basename.

```
UNCHANGED  Canonical Datum /0    UNCHANGED  Surface /0
UNCHANGED  Form /0               UNCHANGED  Form /1        UNCHANGED  Form /2
UNCHANGED  Slice /1              UNCHANGED  Slice /2
UNCHANGED  language-surface-1/surface1.lisp
UNCHANGED  language-surface-1/package.lisp
```

**Zero files changed across all eight restricted paths.** No whitelist was applied
*inside* them: had a byte moved in `surface1.lisp`, the script would have reported it
and exited nonzero, and this would have been a scope violation rather than an addendum.

**What this addendum alone changed** — diffed against `HEAD`, so the two intervening
commits are not miscredited to it:

```
M   run-surface1-candidate.sh     (the gate)
M   surface1-selftest.lisp        (the CD0 helper)
M   RUN-EXITCODES.txt             (consequence of rerunning)
??  errata-0.3/addendum-0.1/      (this directory)
```

---

## 6. THE ONE HISTORICAL REPORT THAT NOW DESCRIBES A SUPERSEDED STATE

**`CUSTOS-REPORT.md` §6 is NOT rewritten and must not be.** It closes with:

> *"the selftest and reproduction III do not yet bind the digest into their
> canonical lines (§1), so those two transcripts are gated on completeness but not
> bound to content."*

**That sentence describes an intermediate implementation state, superseded by later
chair repairs within Errata 0.3 itself and now by this addendum.** Both instruments
emit the binding; both gates now require it. The report is accurate as a record of what
CUSTOS saw when CUSTOS saw it, and it stays exactly as written. **A report is a
record of an observation, not a live description of a tree** — amending one to keep it
true is how an archive stops being evidence.

CUSTOS §6's *other* item — `REPRODUCTION-III.lisp:78` printing an absolute path, so
`RUN-REPRODUCTION-III.txt` is not location-stable — **remains open and is not repaired
here.** It is outside this addendum's three authorized items.

---

## 7. WHAT THIS ADDENDUM DOES NOT ESTABLISH

Stated plainly, because a corrected gate invites being read as more than it is.

* **It does not re-audit anything.** These repairs were made **by the author family**.
  The Errata 0.3 target was repaired by the family that wrote the layer, and this
  addendum is the same family again, one layer further in.
* **The fresh-weights tier is still owed and still unspent** — and still harder than
  it was: the tree is public, so a preregistration committed to it is a *published*
  preregistration. Freeze outside.
* **A green gate is a self-consistency certification, not a validation.** The gate now
  refuses more things. It still cannot tell whether the checks written in these files
  are the right checks.
* **A digest says WHICH BYTES, never that those bytes are correct.** The subject digest
  identifies the layer measured; it does not identify which instrument version measured
  it, and the manifest says so.
* **The stale-label class remains open and undetected.** A check's label is prose about
  code, and nothing relates the two. This addendum moved `surface1-selftest.lisp`, so
  the class is live for that file by the same mechanism the Errata 0.3 handoff named.
* **The negative controls prove the gate can refuse; they do not prove it refuses
  everything it should.** They cover the seven conditions named in the work order plus
  five form-and-field teeth. They are not an exhaustive fault space.
* **The A2 mechanism in §3.2 is inference.** The commit record is measured; the
  explanation of *why* the sweep missed the file is not.

---

## 8. STANDING AFTER THIS ADDENDUM

```
Surface /1 candidate        repaired through Errata 0.3
evidence harness            corrected through Evidence Addendum 0.1
central expansion-account
  proposition               UNCHANGED
grammar 4 · procedure 4 · policy 1     — no version moves
continuation                permitted
adoption                    NO
frozen as language law      NO
on a governing floor        NO
independently re-audited
  after repair              NO — and none is commissioned from this lane
```

---

## 9. THE FILES OF THIS ADDENDUM

```
errata-0.3/addendum-0.1/
  EVIDENCE-ADDENDUM-0.1.md                      this document
  HELPER-SEARCH.txt                             §3.4 — the search, commands and disposition
  helper-search.sh                              the searcher
  SEMANTIC-PATH-DIFF.txt                        §5.1 — the restricted diff
  semantic-path-diff.sh                         the differ
  SMOKE-GATE.txt                                §5 — verify-all transcript
  pre-correction/
    fail-open-witness.sh                        §2.1 — extracts the gate from 431fee16
    FAIL-OPEN-WITNESS.txt                       the measured witness
  negative-controls/
    subject-binding-controls.sh                 §2.4 — 16 controls
    OUT-subject-binding-controls.txt
    helper-resolution-control.lisp              §3.5 — reads the shipped helper
    run-helper-control.sh                       the driver, with the containment proof
    OUT-helper-resolution-control.txt
```

*Quote from the records named above, never from this summary.*

*— Claude Opus 5 (1M context), 2026-07-29.*
