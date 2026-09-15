# REPRO — the MiniMax-M3 P8 supplement block, reproduced on the governing bytes

`date` at start of work: **Tue Sep 15 01:39:17 PM -03 2026** (report written 2026-09-15, same session).
Chair: REPRO (checker). Nothing was written into the lab checkout; all output under
`/tmp/claude-1000/.../scratchpad/repro/` (= `$V`).

## Venue identity (A, part 1)

```
HEAD:            8f41eee133555ee47e2d4d3c1eb7a6bb9427b212
subject subtree: e148d8a5344cd0bef88d0a8d5eba77684577d9f3   (matches the pin)
ml0 lane dir:    9458616a438fbce1de0433d439b458f83d76fbac   (matches the pin)
venue file count: 5905
```
Built with `git archive HEAD:experiments/latent-lisp | tar -x -C $V/venue`. Full record: `$V/VENUE-IDENTITY.txt`.
Lab checkout after all work: `git status --porcelain` shows only ` M tools/ledger/agents.jsonl`, which I did not
touch — it is the agent-deploy ledger hook. No other path differs.

## A. Did the auditor's probe run on the governing bytes? — YES

Per-file sha256, auditor lane vs `$V/venue/mneme/memory-layer-0/<same relative path>` (`$V/A-comparison.txt`):

| auditor tree | identical | differing | only-in-auditor | only-in-venue |
|---|---|---|---|---|
| `supplement/auditor/WORK-after-supplement/substrate/lane` | **59** | **0** | **0** | 3 |
| `auditor/WORK/substrate/lane` | **59** | **0** | **0** | 3 |

Zero differing files; nothing in the auditor's lane that is not in the governing tree. The 3 venue-only files are
`FILE-MANIFEST.txt`, `MEMORY-LAYER-0-SPEC.md`, `MEMORY-LAYER-0-WORK-ORDER.md` — documents, no `.lisp`.

Other substrate dirs: **none exist.** Both auditor substrate roots contain exactly one entry, `lane`; a search of the
whole parcel for `journal0`, `kernel0`, `canonical-datum` returns nothing. So the coarse comparison asked for has no
operand — the auditor never held those dirs, and the probe's `(load ".../ml0-suite-ground.lisp")` resolves its
siblings relative to the load file, which is why the lane alone sufficed.

One structural difference, load-bearing for C2 below: the auditor's `lane/` contains a nested, **file-empty**
`lane/mneme/memory-layer-0/de-actu-memorato/scratch-*` directory skeleton (harness residue — 0 files, dirs only).
The governing lane has no `mneme/` subdir.

## B. sbcl

```
/home/gauss/.local/bin/sbcl
SBCL 2.4.6      (exit 0)
```

## C1 — the original probe, unchanged

`sha256 cc6a0eaa276c6abdc0bd8d7b1d2ac12bc84410977a84b14cc662cf1da50e2cc8` — equal to the parcel's copy.

```
cd $V/venue/mneme/memory-layer-0 && sbcl --script $V/probe-original-unchanged.lisp
EXIT 1      stdout: empty
```
```
Unhandled SB-INT:SIMPLE-FILE-ERROR ...
  Couldn't load "/mnt/venue/WORK/substrate/lane/ml0-suite-ground.lisp": file does not exist.
```
A different failure, as expected: the hard-coded sandbox path. Died on **form 1**.
Transcripts: `$V/C1.{out,err,exit}.txt`.

## C2 — the original probe with only the venue path rewritten

`$V/C2-diff.txt` shows **exactly one changed line**, the `load` on line 4. No other byte differs.

**C2a (cwd = the lane, as the auditor's `0309.cmd` did):** `EXIT 1`, stopped *earlier* than the auditor, at line 9:
`Failed to find the TRUENAME of .../memory-layer-0/mneme/../: No such file or directory`. Cause: the probe passes
`#p"mneme/../"` as `subject-root` to `ml0-fresh-run-root`, which calls `truename` on it; that path existed in the
auditor's venue only because of the empty `lane/mneme/...` harness residue noted in A. This is a venue-shape
artifact, not a subject difference. Transcripts `$V/C2a.{out,err,exit}.txt`.

**C2 (same file, cwd = `$V/venue`, where `mneme/` exists so `mneme/../` resolves):** the block reproduces exactly.

```
cd $V/venue && sbcl --script $V/probe-original-venue-path.lisp
EXIT 1
```
stdout, verbatim and complete:
```
kernel0 foundations smoke: PASS
kernel0 algebra smoke: PASS
kernel0 records+folds smoke: PASS
=== SUPPLEMENT P8: provenance forgery must reach ML0-RB-5 ===
account written: "1b6345aa050e20c18b5f6f00a68629e1538fb8ad097d188e386dd775562b0504"
effect-observation record: #<%RECORD-DATUM {10031EF153}>
```
stderr, decisive lines:
```
  READ error during LOAD:
    Symbol "RECORD-FIELD" not found in the LISP-PLUS-CD0 package.
      Line: 41, Column: 36, File-Position: 2159
```
The auditor's stdout is the same six lines including the **same account id** `1b6345aa…562b0504`, and the auditor's
stderr is the same error at the same **Line: 41, Column: 36**. Only `File-Position` differs: 2159 here vs 2056 there,
a delta of 103 = the length difference of the substituted `load` path. Transcripts `$V/C2.{out,err,exit}.txt`.

### Stage diagnosis (C2)

The process died at **READ time**, not run time. `sbcl --script` loads as source, reading and evaluating one
top-level form at a time, so the stdout above is proof of what had already executed: the `load` of
`ml0-suite-ground.lisp` (the three `kernel0 … smoke: PASS` lines), the `in-package`, the banner `format` (line 7),
and then every form through line 38 — the run root, `ml0-ground`, the settled row, `run-act1`, the three
observations, the `ml0-write` of the bundle (proved by `account written: "1b6345aa…"`) and the retrieve/`%RECORD-DATUM`
print (proved by `effect-observation record: #<%RECORD-DATUM …>`). The reader then failed while reading the form that
**begins at line 39** — the `format` whose argument is `(lisp-plus-cd0:record-field *eff-record* "effect" "provenance")` —
at the point on line 41 column 36 where that qualified symbol ends. (The task brief called it "the form beginning at
line 41"; the read *failure position* is line 41, the *form* starts at line 39.) Consequently `sup-p8-build-record`
(line 60) was never defined, `*mutated-record*` (line 80) was never built, and
`ml0-effect-observation-from-record` (line 91) was never called. The probe never reached its own experiment: nothing
was learned about ML0-RB-5 by this run, in either direction.

## C3 — positive control (Phase-B probe), same single substitution

`$V/C3-diff.txt`: one changed line, the `load`.
```
cd $V/venue && sbcl --script $V/probe-phaseB-venue-path.lisp
EXIT 0      stderr: 0 bytes
```
tail of stdout:
```
account written: "1b6345aa050e20c18b5f6f00a68629e1538fb8ad097d188e386dd775562b0504"
retrieved effect provenance: :CALLER-ASSERTED
=== VERDICT ===
  default :caller-asserted: T
  forge :provenance refused: T
  durable :caller-asserted: T
P8: PASS
```
Byte-for-byte the auditor's Phase-B verdict lines. The venue, the sbcl, and the load path are therefore not the
cause of the C2 failure. Transcripts `$V/C3.{out,err,exit}.txt`.

## D. Where `record-field` lives (reads only, no run)

- **Defined** at `mneme/journal0/pjs0.lisp:159` — `(defun record-field (record &rest segments) …)`.
- **Exported** by Process Journal /0 at `mneme/journal0/package.lisp:68` (`#:record-field`).
- **ML/0 imports it from journal0**: `mneme/memory-layer-0/package.lisp:80` opens
  `(:import-from #:lisp-plus-journal0 …)` and line **98** is `#:record-field`. So inside package
  `lisp-plus-memory-layer0` the symbol is accessible unqualified.
- **CD/0 does not have it at all.** `canonical-datum/common-lisp/package.lisp` has exactly one `record-field`
  substring hit, line 28, `#:budget-max-record-fields` — a different symbol. No `record-field` is defined or
  exported anywhere under `canonical-datum/`. The probe's `lisp-plus-cd0:record-field` names a symbol that does
  not exist in that package, which is precisely what the reader said.
- Both experiment entry points **are** exported by ML/0: `mneme/memory-layer-0/package.lisp:166`
  (`#:ml0-effect-observation-record #:ml0-effect-observation-from-record`) and line **238**
  (`#:ml0-account-hex-of-event #:ml0-account-from-event`); defined at `mneme/memory-layer-0/ml0.lisp:1064` and
  `ml0.lisp:1968`.

## E. Run roots left in /tmp

`ml0-fresh-run-root` (`ml0-suite-ground.lisp:465`) mkdtemps `/tmp/<stem>-XXXXXX` and refuses if it lands inside the
subject tree. Leftovers now, **not deleted**:

| dir | size | files | birth | whose |
|---|---|---|---|---|
| `/tmp/ml0-probe-p8-sup-XFRJds` | 4.0K | 0 | 13:41:08 | mine (C2a, died at line 9) |
| `/tmp/ml0-probe-p8-sup-stcYAd` | 68K | 10 | 13:41:57 | mine (C2, the reproduced block) |
| `/tmp/ml0-probe-p8-AN0Nhu` | 4.0K | 0 | 13:41:35 | **not mine** — see blockers |

The supplement probe's cleanup form is its line 121, after the `cond`; every branch of that `cond` calls
`sb-ext:exit`, so the cleanup is unreachable on *all* paths, PASS included — and on the READ-error path it was never
even read. My C3 (Phase-B) left nothing: that probe's cleanup on line 88 precedes its `exit` on line 89 and ran.

## Uncertainties / blockers

1. **C2 required a cwd change, and I state it as a deviation.** The file diff is the single `load` line as
   specified, but with the auditor's cwd (`the lane`) the probe dies at line 9 on `truename "mneme/../"`. I ran it
   from `$V/venue`, where `mneme/` exists. This changes what `subject-root` denotes (the whole latent-lisp tree here
   vs. the lane there); the check it feeds only asserts the `/tmp` run root is not inside that tree, true both ways.
   I did **not** manufacture the auditor's empty `lane/mneme/...` residue inside the venue.
2. **`/tmp/ml0-probe-p8-AN0Nhu` is another chair's.** `pgrep -a sbcl` during my work showed a concurrent process:
   `sbcl --script /tmp/claude-1000/.../scratchpad/tracer/probe-p8-effect-axis.lisp`. `/tmp` is shared; that dir was
   born at 13:41:35, between my C2a and C2, and I was not running sbcl then. Anyone counting run roots later should
   not attribute it to this report. I deleted nothing.
3. **What this reproduction does and does not establish.** It establishes that the auditor's probe ran against bytes
   identical to the governing ML/0 lane, and that its stated exit-1/READ-error is reproducible on the governing tree
   at HEAD 8f41eee13 with SBCL 2.4.6. It establishes that the failure is in the probe's own text — a symbol qualified
   into the wrong package — and that the probe stopped before its experiment began. It establishes **nothing** about
   whether ML/0's decoder does or does not reach ML0-RB-5 on a forged-provenance record: that was never executed here.
   I did not write or run a corrected probe; I was not asked to, and the claim that a corrected probe would reach the
   decoder is untested.
4. Package-accessibility of the unqualified `record-field` inside `lisp-plus-memory-layer0` is read from
   `package.lisp`, not demonstrated by a run.
