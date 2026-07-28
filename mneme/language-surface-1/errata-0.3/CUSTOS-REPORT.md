# CUSTOS — D4 (the harness fails closed) and D6 (the evidence knows what it measured)

*Errata 0.3, branch `surface1-errata-0.3`. Jurisdiction: the runner, the instruments
I own, and the evidence apparatus. NOT `surface1.lisp`, `package.lisp`,
`surface1-selftest.lisp`, or anything under `audits/`. Every number below was
observed in this session's output; nothing here is quoted from a prior transcript.*

*— Claude Fable 5, 2026-07-28.*

---

## 0. THE SHORT OF IT

| | before | after |
|---|---|---|
| instruments emitting a canonical result line | 2 of 5 | **6 of 6** |
| instruments gated on more than an exit code | 2 of 5 | **6 of 6** |
| counts enforced by the runner | two hard-coded literals | **self-consistency: live counter == the count the instrument declared at its own top** |
| subject identity in the evidence | `git rev-parse --short HEAD` | **sha256 over a 25-member exact-path manifest, computed six times independently and cross-checked** |
| planted faults fired and refused | 8 (the audit's, against the old runner) | **43, every one refused, 0 holes** |

Runner exit on the live tree: **0**. Subject digest:
`9214b59bda190327dc879186bd6d567eae8d2e7d0d162f869148fad1ad6aaf99`.

---

## 1. WHAT EACH INSTRUMENT NOW EMITS

Observed, verbatim, from this session's `RUN-*.txt`:

```
SELFTEST-RESULT checks=139 expected=139 failed=0
STUB-RESULT checks=8 expected=8 failed=0 subject=9214b59bda190327
APPLICATION-RESULT checks=26 expected=26 failed=0 subject=9214b59bda190327
REPRODUCTION-RESULT verdicts=6 expected=6 confirmed=0 subject=9214b59bda190327
REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0 subject=9214b59bda190327
REPRODUCTION-III-RESULT verdicts=12 expected=12 confirmed=0 refuted=12 classification=3
```

In every one of them:

* **`expected=` is a literal declared at the top of the file** (`*expected-checks*`,
  `*expected-verdicts*`). It sits above every check it counts, so a file truncated
  anywhere below it still knows what it owed.
* **`checks=` / `verdicts=` comes from the live counter**, printed by the last
  top-level form in the file. The two agree only if the whole file ran.
* **The instrument itself exits nonzero** when they disagree or when anything failed
  — so a red run prints a line the runner will not accept rather than a green one it
  will. The runner does not depend on that; it is the second of two locks.

**Four of the six bind the content digest into the line** (`subject=<16 hex>`), each
computing it itself by running `errata-0.3/subject-digest.sh` — not by being handed a
value. An instrument that trusted its wrapper for its own subject identity would be
the audit's finding one level up.

**Two do not, and I could not add it: `surface1-selftest.lisp` and
`errata-0.3/REPRODUCTION-III.lisp` are not mine.** The runner matches their lines with
an *optional* ` subject=<16 hex>` tail: present, it must equal this run's digest;
absent, the run records `subject-binding ABSENT` and the banner says so. They are
gated on **completeness** but not bound to **content**. The patch is one directive
each — append ` subject=~A` to the format control and
`(surface1-evidence:subject-short <subject-dir> <tools-home>)` to the arguments, after
`(load "…/errata-0.3/EVIDENCE.lisp")` — and the runner's gate tightens automatically
the moment it lands.

---

## 2. THE RUNNER'S NEW SUCCESS CONDITION

Exit 0 requires **all seven** of these, and nothing less:

```
for EVERY instrument:  process exit == 0
                  AND  exactly one line matching its whole-line contract
                  AND  live count == declared count      (the \1 back-reference)
                  AND  zero failures / zero confirmed defects
and:                   every PRESENT subject= binding == the digest the RUNNER
                       computed independently of the instruments
```

The contracts, verbatim from the runner (`${SUBJECT_SHORT}` is this run's digest
prefix):

```
^SELFTEST-RESULT checks=([0-9]+) expected=\1 failed=0( subject=…)?$
^STUB-RESULT checks=([0-9]+) expected=\1 failed=0 subject=…$
^APPLICATION-RESULT checks=([0-9]+) expected=\1 failed=0 subject=…$
^REPRODUCTION-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 subject=…$      (I and II)
^REPRODUCTION-III-RESULT verdicts=([0-9]+) expected=\1 confirmed=0 refuted=\1 classification=[0-9]+( subject=…)?$
```

Three deliberate choices:

* **No count is hard-coded in the runner.** A wrapper that enforced `checks=115`
  would need editing every time the suite grew, and the number it enforced would
  drift into fiction. What is enforced is *the instrument keeping its own word* —
  which is why the audit's T5/T7 mutations (35 checks, 50 checks, summary
  re-appended) now fail: 35 ≠ 139.
* **Whole-line matching** (`grep -Ecx`), and exactly one match. A trailing space is
  fatal, which is the point of matching whole lines rather than searching for a
  substring.
* **A missing required file is a REFUSAL (exit 2), never a skipped check.** The
  required list now includes `errata-0.3/REPRODUCTION-III.lisp` and the measuring
  apparatus itself (`EVIDENCE.lisp`, `subject-digest.sh`, `SUBJECT-MANIFEST.txt`): a
  run that cannot say what it measured is the defect D6 was opened for.

---

## 3. THE TEETH — 43 PLANTED FAULTS, 0 HOLES

`errata-0.3/teeth/teeth.sh` (reproduces everything) · `errata-0.3/teeth/SUMMARY.txt`
(the table) · `errata-0.3/teeth/OUT-<case>.txt` (per case: the mutation, the runner's
banner, its exit code, **what each instrument actually printed as its canonical
line**, and the `RUN-EXITCODES.txt` block naming which gate refused).
`errata-0.3/teeth/mutate.py` plants the faults; `form-boundaries.py` computes the cut
points, so "a clean top-level form boundary" is *measured* rather than eyeballed — a
cut mid-form would be testing the reader, not the gate.

**Nothing was mutated in the real tree.** A pristine copy of the subject and its
entire traced load closure is built under a scratch directory; each case gets a fresh
copy of that copy, is mutated, and is thrown away.

| case | instrument | expected | **observed exit** |
|---|---|---|---|
| T0-control (unmutated) | all six | 0 | **0** |
| T1a truncated at a clean form boundary | selftest | 1 | **1** |
| T1b " | stub fixture | 1 | **1** |
| T1c " | application | 1 | **1** |
| T1d " | reproduction I | 1 | **1** |
| T1e " | reproduction II | 1 | **1** |
| T1f " | reproduction III | 1 | **1** |
| T2a zero checks run, summary re-appended | selftest | 1 | **1** |
| T2b " | stub fixture | 1 | **1** |
| T2c " | application | 1 | **1** |
| T2d " | reproduction I | 1 | **1** |
| T2e " | reproduction II | 1 | **1** |
| T2f " | reproduction III | 1 | **1** |
| T3a crash before the summary | selftest | 1 | **1** |
| T3b " | stub fixture | 1 | **1** |
| T3c " | application | 1 | **1** |
| T3d " | reproduction I | 1 | **1** |
| T3e " | reproduction II | 1 | **1** |
| T3f " | reproduction III | 1 | **1** |
| T4a canonical label renamed | selftest | 1 | **1** |
| T4b " | stub fixture | 1 | **1** |
| T4c " | application | 1 | **1** |
| T4d " | reproduction I | 1 | **1** |
| T4e " | reproduction II | 1 | **1** |
| T4f " | reproduction III | 1 | **1** |
| T5a one trailing space on the canonical line | selftest | 1 | **1** |
| T5b " | stub fixture | 1 | **1** |
| T5c " | application | 1 | **1** |
| T5d " | reproduction I | 1 | **1** |
| T5e " | reproduction II | 1 | **1** |
| T5f " | reproduction III | 1 | **1** |
| T6a a real check fails (ceiling assertion flipped) | selftest | 1 | **1** |
| T6b a real check fails (expected refusal code flipped) | stub fixture | 1 | **1** |
| T6c a real check fails (abbreviation made non-discriminating) | application | 1 | **1** |
| T6d SUBJECT regressed: accessor un-exported | reproduction I | 1 | **1** |
| T6e SUBJECT regressed: home-package conjunct neutered | reproduction II | 1 | **1** |
| T6f SUBJECT regressed: retracted reachability claim restored | reproduction III | 1 | **1** |
| T7a a manifest member deleted | digest / runner | 2 | **2** |
| T7b the manifest deleted | digest / runner | 2 | **2** |
| T7c the digest script deleted | digest / runner | 2 | **2** |
| T7d `EVIDENCE.lisp` deleted | digest / runner | 2 | **2** |
| T7e `REPRODUCTION-III.lisp` absent | runner required-files | 2 | **2** |
| T7f the manifest names a generated transcript | digest / runner | 2 | **2** |

**0 holes.** Four of these are worth reading rather than counting, because they show
the gate refusing *for the right reason* rather than merely refusing:

```
T2a  RUN-SELFTEST.txt   SELFTEST-RESULT checks=0 expected=139 failed=0
     surface1-selftest  exit 0 · canonical line matched 0 (must be 1)
```
— the exact shape the audit walked through (`0 checks passed / 0 failed`, instrument
exit 0), now refused on the count, not on the exit code.

```
T6c  RUN-APPLICATION.txt  APPLICATION-RESULT checks=26 expected=26 failed=1
```
— the check that **replaced the F-1 tautology** biting. The mutation made
`abbreviate` return one constant string for every identity; the old check
(`(= n (hash-table-count *census*))`) could not have noticed, because it compared a
value with its own defining expression.

```
T6f  RUN-REPRODUCTION-III.txt  … confirmed=1 refuted=11 classification=3
```
— the standing regression gate doing the job it exists for: the retracted
`:unreachable-under-this-policy` claim put back in the catalogue, and a
classification verdict CONFIRMS again.

```
T6d  RUN-REPRODUCTION-III.txt  (NO CANONICAL LINE PRINTED)
```
— un-exporting the catalogue accessor made *reproduction III's own* `s1` helper
refuse at macroexpansion time. F-16's repair, failing closed on a name that stopped
being public. (Reproduction I, which is what T6d targets, reported `confirmed=1`.)

The subject-side cases (T6d/e/f) also changed the digest, incidentally and correctly:
`19d530c3…`, `48e3a21e…`, `7bf9aa03…` against the clean `9214b59b…`.

---

## 4. THE SUBJECT DIGEST — DESIGN AND FRAMING RATIONALE

`errata-0.3/SUBJECT-MANIFEST.txt` · `errata-0.3/subject-digest.sh` ·
`errata-0.3/EVIDENCE.lisp`

**The manifest is the traced load closure, not a reading of the load forms.** I
encapsulated `LOAD` in a live SBCL image, loaded `surface1.lisp` and
`../language-surface-0/surface0.lisp`, and took what the image actually opened: **25
files** — Surface /1 (2), CD/0 (2), Surface /0 (2), Slice /2 (2), Slice /1 (1),
Slice /0 (3), Core /0 (1), Kernel /0 (12). The two roots cover every instrument: the
stub fixture loads only the first, the other five load both.

**The rendering, and why it is shaped like this:**

```
SURFACE1-SUBJECT-DIGEST-V1
members 25
<64 lowercase hex><two spaces><path>\n      (sorted LC_ALL=C by path)
…
digest := sha256(that rendering)
```

The digest field is **fixed width (64)** and the separator is **exactly two spaces**,
so the boundary between hash and path needs no escaping and cannot be forged by a
path containing hex. The path is **terminated by a newline** and constrained to
`[A-Za-z0-9._/-]` — a set excluding whitespace and newline — so no path can
impersonate a line break. The **member count is bound into the rendering**, so a
truncated rendering cannot impersonate a shorter manifest. **Nowhere are two
variable-length fields concatenated raw:** the `"ab"+"c"` == `"a"+"bc"` collision has
no seam to live in.

**Properties, each enforced in code and each fired in the teeth:**

* **No git.** Works on a dirty tree, in a bare copy, outside any checkout — which are
  the ordinary conditions of an audit, since the runner writes tracked transcripts and
  tells auditors to use a writable scratch copy.
* **A missing member is a HARD FAIL (exit 2), never a silent skip** (T7a).
* **Generated transcripts are excluded structurally**: the manifest is an *inclusion*
  list, so nothing enters that is not named. The script additionally hard-fails if a
  member equals one of the runner's seven output paths (T7f) — **by exact relative
  path, never by basename.** A file named `RUN-SELFTEST.txt` elsewhere in the closure
  would be a different file, and excluding it by name would silently drop a real
  input. This lane has a scar from a basename exclusion; that is why the list is
  spelled out rather than pattern-matched.
* **Order-independent**: the script sorts before rendering, so the digest depends on
  the *set* of (path, content) pairs and not on the order of the manifest's lines.
  Duplicates hard-fail.
* **The tool is independent of the subject.** `sha256sum` (or `shasum`, or `python3`),
  never the layer's own identity machinery — a subject that computed its own digest
  could rename itself.
* **Subject-neutrality preserved.** The measuring apparatus travels from the
  *instrument's* tree (`TOOLS-HOME`) and the *subject* is passed as an argument, so
  the reproductions still run unchanged against an older candidate that has no
  `errata-0.3/` in it. A before/after comparison must measure two candidates, not two
  instruments.

**And what it is not, said in the header of every instrument:** it measures the
**layer under test** — those 25 files — and not the instruments, the transcripts, the
host, or the image. It is an ACCOUNT of which bytes were loaded, never an
AUTHENTICATION that they were the right ones.

The human label survives, **explicitly marked ADVISORY** in every header. It no
longer defaults to the git SHA: that default was D6's mechanism, and it had a second
cost nobody had named — it wrote a value into seven tracked transcripts that changes
on every unrelated commit, so an unchanged subject produced changed evidence. The
repository HEAD is now printed **in the banner only**, written to no transcript, as a
hint about the checkout.

---

## 5. THE FOUR DEMONSTRATIONS

`errata-0.3/digest-demo/demo.sh` → `errata-0.3/digest-demo/DEMONSTRATIONS.txt`. All
values computed in this session.

| | demonstration | result |
|---|---|---|
| **D1** | same bytes → same digest | twice in place **and** from a copy at another absolute path: `9214b59b…` all three times |
| **D2** | one behavioural source byte → different digest | the audit's own mutation (`max-source-depth 48→40`, no version integer touched): `9214b59b…` → `66c3ee8e…`; the rendering names `surface1.lisp` as the changed member |
| **D3** | same git HEAD + dirty tree → different digest | `git init`, one commit, then the mutation. HEAD `8ec18a8` **both times**; digest `9214b59b…` vs `66c3ee8e…`. **This is F6, staged as the audit staged it, and answered.** |
| **D4** | different human label → same digest | three different `SURFACE1_SUBJECT_LABEL` values, including `ff80b8f`: identical digest each time. The label cannot reach the measurement |

Plus the consequence and its mirror:

* **D5 — the transcripts no longer match.** F6's finding was not that a label was
  wrong in the abstract; it was that *two materially different subjects produced
  byte-identical transcripts*. Running the full runner on both trees of D3: **all six
  instrument transcripts differ**, first difference at bytes 13603 / 423 / 532 / 548 /
  537 / 588 — i.e. in the evidence header, at the digest, before any check reports.
* **D6 — an unchanged subject must not change the evidence.** Re-run in place: **all
  seven transcripts byte-identical.** Run from a second scratch copy at a different
  absolute path: **six of seven byte-identical.**

---

## 6. THE ONE THING I FOUND AND COULD NOT FIX

**`RUN-REPRODUCTION-III.txt` is not location-stable.**
`errata-0.3/REPRODUCTION-III.lisp:78` prints

```lisp
(format t "  directory   ~A~%" (truename (merge-pathnames "../" …)))
```

— the absolute path of the tree it was pointed at. This is exactly the line D6 had me
remove from `REPRODUCTION.lisp` and `REPRODUCTION-II.lisp`: it is the reason the
freeze packet's manifest used to fail on precisely those two transcripts, and it has
been reintroduced in the new instrument. That file is the chair's; I did not touch it.
The cure is the one already applied twice — print a two-component *place*, or nothing,
and let the digest say which bytes. It is named in the runner's own documentation
comment and in `DEMONSTRATIONS.txt` §D6 rather than left for the next auditor.

**Two remaining gaps, both named above and neither hidden by a passing gate:**
the selftest and reproduction III do not yet bind the digest into their canonical
lines (§1), so those two transcripts are gated on completeness but not bound to
content.

---

## 7. THE D8 ITEMS IN MY FILES

**F-1 — `APPLICATION.lisp`, the census (was ~389).** The check compared
`n` with `(hash-table-count *census*)`, i.e. a value with its own defining expression;
it could not fail. The section heading advertised a discrimination check that existed
nowhere in the file. **Replaced with the advertised measurement:** `id!` now registers
`FULL → ABBREVIATION` for every identity it prints, and the foot of the program
asserts `distinct abbreviations == distinct full identities`. Live: `7` and `7`. Teeth
case T6c makes it fail (the old one could not have).

**F-15 — `errata-0.1/REPRODUCTION.lisp`, findings 3 and 4.**
*Finding 3* claimed "a first-class immutable occurrence object exists and is the third
value" on the strength of **one symbol being present**. It now performs a real
`PERFORM-EXPANSION`, takes the actual third value, and requires that the **exported**
recogniser accept *that value* **and** that the **exported** identity accessor answer a
bytes datum for it — every conjunct displayed, so both branches name what they saw.
Observed: `EXPANSION-OCCURRENCE-P :EXTERNAL`, `EXPANSION-OCCURRENCE-IDENTITY
:EXTERNAL`, third value `EXPANSION-OCCURRENCE`, recogniser `T`, accessor `T`.
*Finding 4* was **fail-open in the small**: its REFUTED branch, "the accessor is
exported," was reached whenever the CONFIRMED conjunction failed — including the case
where the symbol had vanished entirely. It is now a four-way `cond`: absent →
CONFIRMED, non-`:EXTERNAL` → CONFIRMED, not fbound → CONFIRMED, all three → REFUTED
with the three facts named. T6d fires the first branch.

**F-16 — all four helpers.** `APPLICATION.lisp:42`, `STUB-IMAGE-FIXTURE.lisp:25` and
`errata-0.1/REPRODUCTION.lisp:23` used bare `INTERN`; `errata-0.2/REPRODUCTION-II.lisp:22`
used `FIND-SYMBOL` without demanding `:EXTERNAL`. All four `s1` helpers — **and all
four `cd0` helpers, which the disposition did not require and which had the same
hole** — now resolve through `FIND-SYMBOL` and **refuse at macroexpansion time**
unless the symbol both exists and is `:EXTERNAL`. Bare `INTERN` cannot tell a private
name from a public one *and* creates the symbol it fails to find, so a typo becomes a
fresh internal symbol and the error surfaces far from its cause.

---

## 8. TWO FALSIFIED CLAIMS I REMOVED FROM MY OWN FILES

Not assigned to me by name, but they lived in files I own and the audit had already
defeated them. Leaving a refuted claim inside an instrument built to make evidence
honest was not an option.

* **`APPLICATION.lisp` §VI** asserted `:EXPANDED-NODES-EXCEEDED is UNREACHABLE UNDER
  THIS POLICY … octets must always fire first`, with a check calling the domination
  "exhibited, not asserted". The arithmetic was backwards: it divided the octet
  ceiling by the cost of one term measured on the **source** side and compared that
  against the **expanded**-side node count. **Withdrawn and replaced by an executed
  witness** (new §VI-b): an ordinary `DEFINE-JUDGMENT-SCHEMA`, no fault hook, no
  fixture — `N=2492 → :EXPANDED-TERM-OCTETS-EXCEEDED`, `N=2493 →
  :EXPANDED-NODES-EXCEEDED`, plus a check that the catalogue's reachability field now
  reads `:PUBLIC-API`. The two ceilings are **adjacent, not dominated**; the
  amplification is construct-dependent and the threshold is not universal. No ceiling
  was moved.
* **`REPRODUCTION-II.lisp` finding B** asserted `decode is injective for every
  admissible datum, so NO PUBLIC INPUT REACHES the round-trip mismatch`. **Withdrawn**
  (the withdrawn words kept in a comment so a reader can see what was claimed). The
  planted-fault demonstration remains — not because the public path cannot get there,
  but because a planted fault is the smallest way to show *that* gate doing the work.
  The gate was vindicated; the note about it was false.

Check counts moved as a consequence and are re-derived live, never preserved:
application **24 → 26**, stub **8** unchanged, reproductions **6** and **4** unchanged.

---

## 9. FILES

**Mine, changed:** `run-surface1-candidate.sh` · `STUB-IMAGE-FIXTURE.lisp` ·
`de-expansione-testata/APPLICATION.lisp` · `errata-0.1/REPRODUCTION.lisp` ·
`errata-0.2/REPRODUCTION-II.lisp`

**Mine, new:** `errata-0.3/SUBJECT-MANIFEST.txt` · `errata-0.3/subject-digest.sh` ·
`errata-0.3/EVIDENCE.lisp` · `errata-0.3/teeth/{teeth.sh,mutate.py,form-boundaries.py,SUMMARY.txt,OUT-*.txt}` ·
`errata-0.3/digest-demo/{demo.sh,DEMONSTRATIONS.txt}` · this report

**Regenerated by the runner:** the seven `RUN-*.txt`

**Untouched, as required:** `surface1.lisp` · `package.lisp` · `surface1-selftest.lisp` ·
`errata-0.3/REPRODUCTION-III.lisp` · `errata-0.3/{DEFECT-LEDGER,D8-DISPOSITIONS}.md` ·
everything under `audits/`
