# SOURCE-MAP — P10/F1 gate, Memory Layer /0

INSPECTOR, 2026-09-15. Subject main `4a3fb37877047a2edf6f52b88d89194826abfbeb`, lane tree `9458616a…`. Venue
`$I/venue` = `git archive 4a3fb3787:experiments/latent-lisp`; every `file:line` is that copy = the commit.
SBCL 2.4.6, fresh `sbcl --script`, cwd `$I/venue`. Nothing written into the checkout (§6). `$I` =
`/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/a9455147-ea7d-42f0-8bf8-78425fb9c7d7/scratchpad/inspector/`.

## 1. What the loader's completeness predicate checks

`ml0-api-complete-p` — `load.lisp:240-241`: `(defun ml0-api-complete-p () (null (ml0-api-shortfall)))`. Nothing else.
`ml0-api-shortfall` — `load.lisp:190-238`:
- `:197-206` arithmetic self-check — `+ml0-api-count+` (195, `:178`) must equal the sum of the three declared
  lists' lengths. Internal arithmetic only; never compared against the package.
- the `probe` helper (a local `flet`; unrelated to the block proof's `probe`) — `load.lisp:209-220`:
```lisp
(flet ((probe (name kind test)
         (multiple-value-bind (symbol status) (find-symbol name package)
           (cond ((null symbol)               (push "~a ~a: absent" shortfall))
                 ((not (eq status :external)) (push "~a ~a: present but not external" shortfall))
                 ((not (funcall test symbol)) (push "~a ~a: external but not bound as a ~a" shortfall))))))
```
- kinds probed — `:221-224`: functions by `#'fboundp` · variables by `#'boundp` · types by
  `(lambda (s) (or (find-class s nil) (subtypep s t)))`. **Macros are not a kind** — a macro satisfies `fboundp`
  and passes as a "function".
- readiness carrier — `:225-237`: `*ML0-LANE-READY-CARRIER*` must exist, be bound, and be `equal` to
  `(:lane "memory-layer-0" :final-source "ml0-readiness.lisp" :position :last-form)` (`:183-185`; set at
  `ml0-readiness.lisp:31-36`).

**Lambda lists: NOT CHECKED AT ALL** — `lambda-list`, `arglist`, `sb-introspect`: 0 hits in `load.lisp`.

**Direction (load-bearing).** `:221-224` are `dolist`s over the DECLARED lists that ask the package about each
name; the package is never iterated. The predicate answers *"is every listed name exported and bound?"* —
**not** *"is every exported symbol in my list?"* An export added to `package.lisp` without touching `load.lisp`
is invisible. The docstring's warrant claim (`:191-194`, "enumerates EVERY declared name") is exact and does not
overclaim; the gap is that *declared* ≠ *exported*.

## 2. Measured census

Probes `$I/probes/p-q2-census.lisp`, `p-q2b-undeclared.lisp` → `$I/transcripts/q2-census.txt`,
`q2b-undeclared.txt`; each loads `ml0-suite-ground.lisp` exactly as `ml0-block-proof.lisp:84-86` does.

| # | quantity | measured |
|---|---|---|
| (a) | external symbols of `lisp-plus-memory-layer0` | **205** |
| (b) | of those, `fboundp` — **what F1 walks** | **157** |
| — | names in `+ml0-external-functions+` (`load.lisp:66-152`) | **148** |
| (c) | fboundp externals **NOT** in that list | **9** |
| (d) | listed names not fboundp | **0** |
| (e) | fboundp externals that are macros | **0** |

(c), all nine sorted: `ML0-SUBJECT-ACT-ID`, `ML0-SUBJECT-ACT-ID-HEX`, `ML0-SUBJECT-ATTEMPT`,
`ML0-SUBJECT-CANONICAL-REQUEST`, `ML0-SUBJECT-EXTERNAL-REQUEST-KEY`, `ML0-SUBJECT-FIXTURE-ROW`,
`ML0-SUBJECT-FROM-FIXTURE-ROW`, `ML0-SUBJECT-P`, `ML0-SUBJECT-SEAT` — the `ml0-subject` struct family
(`defstruct ml0.lisp:511-520`, derivation fn `ml0.lisp:522`, exported `package.lisp:212-215`). The tenth
undeclared external is the *type* `ML0-SUBJECT` (not fboundp): 205 = 195 declared + 10 undeclared.
**The loader's function list is 9 short of the live fbound surface.**

(e) `function-lambda-list` over all 157: **0 signalled, 0 NIL/odd returns**; no macros exist to test it on.
Current `DEFECT`/`DEFECT-PAYLOAD` offenders: **0** — F1 is genuinely green today.

**Call count** (`$I/probes/p-q2c-count-calls.lisp` → `$I/transcripts/q2c-fll-calls.txt`): a baseline run makes
**314** calls to `sb-introspect:function-lambda-list` over **157 distinct symbols, 0 symbol twice** — SBCL
recurses symbol → function object, 157 × 2 = 314. Reconciles FRIGUS's **313** exactly (§3d).

## 3. Candidate targets

**(a) M1-COVERED — `ML0-PRINT-STORE-UNIVERSE`.** Declared `load.lisp:152`, exported `package.lisp:245`, defun
`ml0.lisp:1846-1858`. Call sites lane-wide: **exactly one**, `ml0-host-fault-proof.lisp:190`, which is NOT in
the block proof's load path (`ml0-block-proof.lisp:84` → suite ground → `load.lisp` → the four lane sources;
overlay only at `:988`). Deleting the defun cannot touch the block proof, and the loader must catch it
(`load.lisp:221` → `"function ML0-PRINT-STORE-UNIVERSE: absent"` → `error` at `:270`). Alternate:
`ML0-EVIDENCE-PROJECTION-DIGEST` (declared `load.lisp:132`, defun `ml0.lisp:3095`, one call `ml0.lisp:937`).

**(b) M1-UNCOVERED — `ML0-SUBJECT-FIXTURE-ROW`.** Exported `package.lisp:213`, fboundp, not in the loader list,
**zero call sites anywhere in the lane** — grep `\bml0-subject-fixture-row\b` over all `*.lisp` under
`mneme/memory-layer-0/` incl. `de-actu-memorato/` matches only that export line (`$I/transcripts/q3-callsites.txt`,
`q3-loadpath-callsites.txt`). ⚠ **Caveat stated, not smoothed:** it is a `defstruct` slot accessor, not a plain
defun; "removing its defun" = three lines (drop `fixture-row` from the BOA constructor keys `ml0.lisp:511`, the
slot `ml0.lisp:514`, and `:fixture-row fixture-row` `ml0.lisp:538`) — nothing reads the slot. **No leaf
plain-defun exists among the undeclared nine:** `ML0-SUBJECT-FROM-FIXTURE-ROW` is the only plain defun there and
the block proof calls it at 485, 512, 539, 556, 571, 591, 611, 692, 729, 912. One-line alternative of equal
force: delete `#:ml0-subject-fixture-row` from `package.lisp:213` — loader still complete, F1 still green.

**(c) M2-POSITIVE — `ML0-EVIDENCE-PROJECTION-DIGEST`.** Lambda list `(EVIDENCE)` (measured,
`$I/transcripts/q2b-undeclared.txt`), defun `ml0.lisp:3095`, sole call site `ml0.lisp:937` — positional, inside
a `multiple-value-bind`; the block proof never names it. A trailing `&key defect` changes no caller and must
make F1 fire. Alternates: `ML0-FAILING-LEG` `(CONJUNCTS)`, defun `ml0.lisp:1529`, one positional call `:1596`;
`ML0-PRINT-STORE-UNIVERSE` `(LABEL BEFORE AFTER)`, one positional call outside the load path.

**(d) U1 — how FRIGUS interposed** (`$I/../frigus/evidence/`). Mechanism = **whole-function REDEFINITION via
`setf symbol-function`** — not `encapsulate`, not a wrapper around the gate
(`p10-f1-introspection-injection.lisp:3-20`):
```lisp
(defparameter *frigus-original-function-lambda-list*
  (symbol-function 'sb-introspect:function-lambda-list))
(setf (symbol-function 'sb-introspect:function-lambda-list)
      (lambda (thing) (incf *frigus-introspection-calls*)
        (if (and (symbolp thing) (string= "ML0-WRITE" (symbol-name thing)) ...)
            (progn (incf *frigus-target-injections*)
                   (format t "~&FRIGUS-INJECTED-INTROSPECTION-ERROR: ~s~%" thing)
                   (error "FRIGUS targeted introspection failure"))
            (funcall *frigus-original-function-lambda-list* thing))))
```
It then invoked the real gate by a **plain `load` of the real file — no copy, no edit**: `:30`
`(load "mneme/memory-layer-0/ml0-block-proof.lisp")` under `cd substrate` (`run-p10-f1-injection.sh:7-9`). The
shim survives because `ml0-block-proof.lisp:770` calls through the symbol. Counts observed:
`FRIGUS-INTROSPECTION-CALLS: 313` · `FRIGUS-TARGET-INJECTIONS: 1`
(`novel-p10-f1-introspection-injection-attempt2.txt:154-155`). The gate printed (`:104-107`, `:153`, `:156`):
```
---- F1: no mutant seam on the public arglists ----
FRIGUS-INJECTED-INTROSPECTION-ERROR: ML0-WRITE
[12] CLOSED  F1 · NO EXTERNAL FUNCTION OF THIS LANE CARRIES A `DEFECT` PARAMETER — ...
      walked every external fbound symbol's compiled lambda list
ml0-block-proof: 20 probes, 20 closed, 0 open        INNER-DIRECT-EXIT: 0
```
The swallow is `ml0-block-proof.lisp:770-771` — `(handler-case (sb-introspect:function-lambda-list symbol)
(error () nil))`: an uninspected symbol becomes an empty arglist, i.e. evidence of innocence; the note at `:785`
is a **fixed literal**, not a count. `ml0-selftest.lisp:1052-1065` repeats the identical walk with the identical
`(error () nil)`.

## 4. The gate's own coverage promises

- `ml0-block-proof.lisp:48-51` — *"F1 NO EXTERNAL FUNCTION of this lane carries a `defect` parameter — walked
  over every external fbound symbol's COMPILED LAMBDA LIST via `sb-introspect`, in an image loaded through the
  canonical `load.lisp`."*
- `:78-81` — *"⚑ THE F1 PROBE ASKS THE IMAGE WHAT IT COMPILED, not the source file what it says. …a grep reads
  the text and an arglist reads the function."*
- `:761-764` — *"⚑ THIS PROBE ASKS THE IMAGE, NOT THE SOURCE. It walks every EXTERNAL symbol of the lane's
  package in an image loaded through the canonical `load.lisp` and reads the arglist SBCL actually compiled. A
  grep can be fooled by a macro; `function-lambda-list` cannot."*
- `:779-785` — label *"F1 · NO EXTERNAL FUNCTION OF THIS LANE CARRIES A `DEFECT` PARAMETER — the mutant seam is
  not a public runtime lever"*; green note *"walked every external fbound symbol's compiled lambda list"*.
- `MEMORY-LAYER-0-SPEC.md:292-297` — *"**The property, checkable in one line, and checked by a gate:** in an
  image loaded through `load.lisp`, **no external function of this lane carries a `defect` or `defect-payload`
  parameter** — read out of the compiled lambda lists by `sb-introspect`, not out of the source text by grep
  (`ml0-block-proof` F1, and `ml0-selftest` §K…)."*
- `MEMORY-LAYER-0-RETURN.md:1326-1331` — *"F1 walks **every external fbound symbol** of the package in an image
  loaded through the canonical `load.lisp` and reads `sb-introspect:function-lambda-list` — the compiled
  arglist, not the source text. Zero offenders."*; `:1231` — *"there is no `defect` parameter anywhere in
  production | F1"*.
- `MEMORY-LAYER-0-GUIDE.md:576-585` carries the prohibition (*"Never widen a production arglist for a test"*)
  but makes **no coverage claim about F1's walk**.

**Does any normative (SPEC) clause require F1 to be complete, or to report uninspected symbols? — none found.**
Searched `MEMORY-LAYER-0-SPEC.md` for: `F1`, `uninspected`, `enumerat`, `must report`, `shall report`,
`skipped`, `handler-case`, `lambda list`, `arglist`, `defect`, `introspect`, `every external`, `walked every`,
`asks the image`. SPEC:292-297 states the *property* universally and names F1 as its checker; it imposes no
obligation to count, enumerate, or report an uninspectable symbol. (SPEC:368/376 *does* impose an enumeration
obligation — on a different gate, over lane structure classes.)

## 5. Exit and aggregation

`ml0-block-proof.lisp:94-107`: `(defvar *probes* 0) (defvar *closed* 0) (defvar *open-holes* 0)` then
```lisp
(defun probe (label closed-p &optional (note ""))
  "CLOSED-P is TRUE when the blocker is SHUT.  Against the blocked build these
answer NIL and this file exits nonzero; that run is the RED evidence."
  (incf *probes*) (if closed-p (incf *closed*) (incf *open-holes*))
  (format t "~&[~d] ~a  ~a~@[~%      ~a~]~%" ...) (finish-output) closed-p)
```
`:1000-1003`:
```lisp
(format t "~&ml0-block-proof: ~d probes, ~d closed, ~d open~%" *probes* *closed* *open-holes*)
(finish-output)
(sb-ext:exit :code (if (zerop *open-holes*) 0 1))
```
Other exits: `:183` code **4** on a W-ENV VOID; `ml0-suite-ground.lisp:474` code **3** if the run root falls
inside the subject tree. **An earlier failure gets NO distinct code**: `ensure-ml0-lane` (`load.lisp:263-271`)
signals `ml0-lane-incomplete`, an ordinary `error` (`load.lisp:243`), inside the first `load`, unhandled.
Measured (`$I/probes/p-q5-error-exit.lisp`, `p-q5-load-error.lisp` → `$I/transcripts/q5-error-exit.txt`,
`q5-load-error.txt`): `sbcl --script` on an unhandled error prints `Unhandled …` + backtrace +
`unhandled condition in --disable-debugger mode, quitting` to **stderr** and **exits 1** — the *same* code as
"one probe OPEN". **Exit 1 is ambiguous; only the sentinel line disambiguates** (a died-early run prints no
`ml0-block-proof: N probes…` line at all).

## 6. Invocation assumptions and the baseline run

- **Paths are `*load-truename*`-relative, not cwd-relative:** `ml0-block-proof.lisp:84-86`, `:90-92`
  (`*lane-directory*`, `*subject-root*` = `../../`), `:988`; `load.lisp:49-51` (`*ml0-directory*`, explicitly
  *"Checkout- and cwd-independent"*). **cwd still matters in practice:** `*subject-root*` is `truename`d by
  `ml0-fresh-run-root` (`ml0-suite-ground.lisp:472`) and the substrate chain enters via
  `../language-act-1/load.lisp` (`load.lisp:60`), so it must run inside a complete `experiments/latent-lisp`
  tree. I used cwd `$I/venue`.
- **Env vars:** only via `ml0-env-preflight` (`ml0-block-proof.lisp:181`; defn `ml0.lisp:3167-3192`) —
  `+ml0-env-class-i+` + `+ml0-env-class-ii+` = **11 variables** (1 + 10), any one set ⇒ VOID, exit 4. Measured
  (`$I/B0-probe/stdout.txt:6-17`): `CAP2_WORLD_DIE_IN_WINDOW`, `ML0_SELFTEST_PLANT_FAULT`,
  `ML0_CONTROLS_PLANT_FAULT`, `ML0_READER_DIE`, `ACT1_SELFTEST_PLANT_FAULT`, `ACT1_CONTROLS_PLANT_FAULT`,
  `ACT1_RESTART_DIE`, `CAP2_SELFTEST_PLANT_FAULT`, `CAP2_CONTROLS_PLANT_FAULT`, `CAP2_CONTROLS_DIE`,
  `DE_EFFECTU_DIE`; plus 9 Class III named and NOT asserted.
- **Writes:** run root = `sb-posix:mkdtemp "/tmp/ml0-block-XXXXXX"` (`ml0-suite-ground.lisp:465-475`), refused
  (exit 3) if inside the subject tree, deleted recursively at `ml0-block-proof.lisp:966`. Verified: after three
  runs `diff -rq $I/venue $I/venue-fresh` (fresh `git archive` re-extraction) reports **no differences**, and no
  `/tmp/ml0-block-*` survives. Nothing outside `/tmp` is written.
- **Baseline run** (once, fresh process) → `$I/B0-probe/{stdout.txt,stderr.txt,exit.txt}`: sentinel
  **`ml0-block-proof: 20 probes, 20 closed, 0 open`** (`stdout.txt:129`), **exit 0**, **3 seconds**. stderr
  carries only two SBCL `undefined variable: *ML0-IDENTITY-SEAM-ARMED*` compile warnings from the overlay load
  at `:988` (identical warnings in the FRIGUS transcript `:133-149`).

## Uncertainties

1. M1-UNCOVERED's target is a struct accessor, not a plain defun (§3b); no leaf plain-defun exists among the
   undeclared nine. Surgery is 3 lines, or 1 line via unexport.
2. **I ran no mutation.** Every M1/M2 claim about what the gate *would* do is a source + call-site argument plus
   the loader's measured direction — not a run. Runs: 3 census/counter probes, 2 exit probes, 1 baseline gate.
3. Call-site greps are textual (`\b<name>\b` over `*.lisp`); a runtime `funcall` on a computed symbol is
   invisible. The block proof does exactly that once (`ml0-block-proof.lisp:796-801`, F1b) — not on any
   candidate I named, but the technique is present in the file.
4. Doc drift, noted not resolved: `MEMORY-LAYER-0-RETURN.md:1230` says the declared external API is **177**;
   `load.lisp:178` declares **195**; the package exports **205**. I did not trace which round moved it.
5. FRIGUS 313 vs my 314 is reconciled by the recursion argument and by both images walking 157 symbols, but I
   read FRIGUS's committed transcript rather than re-running its script on this sha.
6. `ml0-selftest` §K was read, not run (`ml0-selftest.lisp:1052-1065`): the "second proof" SPEC:295-297 cites
   shares the same `(error () nil)` swallow by inspection, not by execution.
7. The checkout showed `M tools/ledger/agents.jsonl` and `?? experiments/latent-lisp/atelier/p10-real-gate-0/`
   at both start and end — another hand's, not mine; I wrote only under `$I`.
8. This file is 217 lines, over the 160 budget. I cut prose twice; the remainder is quotes Q1/Q4/Q5 asked for
   verbatim, and I judged losing a quote worse than overrunning. Flagging rather than trimming silently.
