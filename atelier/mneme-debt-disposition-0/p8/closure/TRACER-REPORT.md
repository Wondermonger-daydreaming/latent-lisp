# TRACER — the ML/0 P8 probe load closure, proven by cut

`date` at report start: **Tue Sep 15 01:39:37 PM -03 2026** (last command `date`: 01:45:44 PM -03 2026)
Repo `/home/gauss/Desktop/Claude-Code-Lab`, HEAD `8f41eee13`, subject `experiments/latent-lisp/`.
Runner: SBCL 2.4.6, fresh `sbcl --script` per run. Nothing was written into the lab checkout
(only `git archive` / `git ls-tree` / `git show` / `git cat-file -e` / `git grep` were used).

## 1. Static load chain (file → line → file)

Loads are all `(load (merge-pathnames <rel> <dir-of-*load-truename*>))`; every path is
checkout- and cwd-independent EXCEPT where noted in §3.

```
mneme/memory-layer-0/ml0-suite-ground.lisp :25  → mneme/memory-layer-0/load.lisp
mneme/memory-layer-0/load.lisp             :259 → mneme/language-act-1/load.lisp      (guarded on package LISP-PLUS-LANGUAGE-ACT1)
  +ml0-substrate-sources+ = ("../language-act-1/load.lisp")                            (load.lisp:58-60)
mneme/language-act-1/load.lisp             :204 → mneme/capability2/load.lisp          (+act1-substrate-sources+, :56-57)
mneme/capability2/load.lisp                :16,27-28 → mneme/capability1/load.lisp
                                                   then package, conditions, world, events,
                                                   rehydrate, authorize, attempt, reconcile, mutants  (:18-26)
mneme/capability1/load.lisp                :15,24-25 → mneme/capability0/load.lisp
                                                   then package, conditions, context, object, mint, present, mutants (:17-23)
mneme/capability0/load.lisp                :14,23-24 → mneme/journal0/load.lisp
                                                   then package, conditions, schema, fold, receipts, query, mutants (:16-22)
mneme/journal0/load.lisp                   :9  (require :sb-posix)
                                           :15,28-29 → mneme/kernel0/load.lisp
                                                   then package, sha256, conditions, pjs0, frame, meta,
                                                   reader, writer, salvage, fold, mutants                (:17-27)
mneme/kernel0/load.lisp                    :6-7,19-20 → ../../canonical-datum/common-lisp/package.lisp
                                                      → ../../canonical-datum/common-lisp/cd0.lisp
                                                   then package, conditions, identity, boundary, determinacy,
                                                   manifestation, uncertain-effect, outcome, procedure,
                                                   records, folds                                        (:8-18)
                                           :22-42 three in-image smoke blocks (no further file loads; exit 1 on fail)
mneme/language-act-1/load.lisp             :206 → mneme/language-core-0/core0.lisp     (guarded on LISP-PLUS-CORE0)
mneme/language-core-0/core0.lisp           :36  → mneme/language-slice-1/slice1.lisp   (guarded on LISP-PLUS-SLICE1)
mneme/language-slice-1/slice1.lisp         :37  → mneme/language-slice-0/slice0-transmissibility.lisp (guarded on LISP-PLUS-SLICE0)
mneme/language-slice-0/slice0-transmissibility.lisp :28,30 → slice0-projection.lisp
mneme/language-slice-0/slice0-projection.lisp       :16   → slice0.lisp
mneme/language-act-1/load.lisp             :207-208 → +act1-lane-sources+ (:51-52) =
                                                   package.lisp, act1-fixtures.lisp, act1.lisp, act1-readiness.lisp
mneme/memory-layer-0/load.lisp             :260-261 → +ml0-lane-sources+ (:53-54) =
                                                   package.lisp, ml0-fixtures.lisp, ml0.lisp, ml0-readiness.lisp
mneme/memory-layer-0/load.lisp             :273 (ensure-ml0-lane) — API completeness assert, no file loads
```

**No ASDF on this path.** `load.lisp:11-15` says the lane is "NOT REGISTERED"; that comment is now
stale — `experiments/latent-lisp/lisp-plus.asd:822-831` DOES define `lisp-plus/ml0`. Irrelevant to the
probe: the probe loads `ml0-suite-ground.lisp` directly and no `.asd`, `load-lisp-plus.sh`,
`load-order-matrix.sh` or `verify-release.sh` is touched. (Doc drift, reported, not acted on.)

## 2. Runtime disk reads

Everything the ground builds is created **under a caller-supplied run root**, never read from the
subject tree:

- `ml0-ground` (ml0-suite-ground.lisp:43-70) sets `*act1-run-root*` and calls
  `build-act1-store` (act1.lisp:1084-1091 → `create-journal (merge-pathnames "store/" root)`) and
  `build-act1-worlds` (act1.lisp:1094-1105 → `world-apply/`, `world-ambiguous/` under root), then
  `build-ml0-account-store` (ml0.lisp:3205 → `account-store/` under root).
- Later reads (`CELLS.txt`, `REQUEST-LEDGER.txt`, `(directory (merge-pathnames "*.*" directory))`,
  act1.lisp:989-995, ml0.lisp:825/1826-1833) are all under those run-root directories.
- **No fixture file, world directory or datum is read out of the checkout at runtime.** The 68-file
  cut B was byte-for-byte the same file count before and after the run (68 → 68; no stray dirs).

## 3. cwd assumption (a real one, in the probe, not in the lane)

Probe line 42: `(ml0-fresh-run-root "ml0-probe-p8" #p"mneme/../")` — a **cwd-relative** subject root.
`ml0-fresh-run-root` calls `(truename subject-root)`, so the process cwd must contain a `mneme/`
directory. Running from the lane dir as first attempted **failed**:

```
Failed to find the TRUENAME of …/cutA/mneme/memory-layer-0/mneme/../: No such file or directory   (EXIT 1)
```
(`cutA-attempt1-lanedir.{out,err,exit}.txt`). So every run below has **cwd = the cut root** (the
directory that contains `mneme/` and `canonical-datum/`), which is what the venue layout
(`/mnt/venue/WORK/substrate/`) implied. The only other cwd/absolute assumption in the chain is
`ml0-fresh-run-root`'s `/tmp` mkdtemp (§5).

## 4. Probe rewrite (`probe-diff.txt`)

```diff
-(load "/mnt/venue/WORK/substrate/lane/ml0-suite-ground.lisp")
+(load (merge-pathnames "mneme/memory-layer-0/ml0-suite-ground.lisp"
+                        (truename *default-pathname-defaults*)))
```
One line changed; nothing else. (Lane-dir-relative was tried first and is impossible given §3.)

## 5. Cut A — full subject tree

`git archive HEAD:experiments/latent-lisp | tar -x -C $T/cutA`; run from `$T/cutA`.

| | |
|---|---|
| files | **5,905** |
| size | 658M |
| result | `P8: PASS`, `default :caller-asserted: T`, `forge :provenance refused: T`, `durable :caller-asserted: T` |
| exit | **0** (`cutA.exit.txt`) |
| stderr | empty |

Note on step 2: the forgery is refused as `UNKNOWN-KEYWORD-ARGUMENT: :PROVENANCE`, not as
`ML0-PROVENANCE-INCOMPLETE`. The probe's own `(error (e) …)` arm counts that as refused. Same in cut B.

## 6. Cut B — minimal pathspec list

| attempt | pathspecs | exit | decisive line |
|---|---|---|---|
| 1 | the 68 paths in §7 (from the static trace, first try) | **0** | `P8: PASS` |

No iteration was needed: the static trace was right the first time. Files 68, size **1.6M**
(`attempt-1.{out,err,exit}.txt`).

### Leave-one-out (68 runs, `loo-table.txt`, `loo-summary.txt`)

For each of the 68 paths, a cut was built without it and the same probe run.
**68 / 68 broke the run. EXIT 1 in every case. No path was dispensable.**
Every failure's decisive line is `Couldn't load #P"<path>": file does not exist`, and in every case the
path named is the path dropped (11 of them spelled through the `../` the loader uses, e.g. dropping
`canonical-datum/common-lisp/cd0.lisp` yields
`Couldn't load #P"mneme/kernel0/../../canonical-datum/common-lisp/cd0.lisp"`). Representative rows:

```
1   mneme/memory-layer-0/ml0-suite-ground.lisp  EXIT 1  Couldn't load #P"mneme/memory-layer-0/ml0-suite-ground.lisp": file does not exist
2   mneme/memory-layer-0/load.lisp              EXIT 1  Couldn't load #P"mneme/memory-layer-0/load.lisp": file does not exist
50  mneme/kernel0/load.lisp                     EXIT 1  Couldn't load #P"mneme/journal0/../kernel0/load.lisp": file does not exist
64  mneme/language-core-0/core0.lisp            EXIT 1  Couldn't load #P"mneme/language-act-1/../language-core-0/core0.lisp": file does not exist
68  mneme/language-slice-0/slice0.lisp          EXIT 1  Couldn't load #P"mneme/language-slice-0/slice0.lisp": file does not exist
```

**Precision about what this proves.** The pathspecs are FILES, so the leave-one-out was run at
**file granularity, not directory granularity** — stronger than the task's top-level-path ask. It
proves: *no single file of the 68 can be removed and still have the probe pass.* It does NOT prove
minimality against removing a *combination* of files, nor that each file is semantically used (each
is merely named in an ordered-sources list the loader walks; a file could be an empty stub and still
be required). Sufficiency is proven by attempt 1's exit 0.

## 7. FINAL pathspec list — 68 files, 1.6M (relative to `experiments/latent-lisp/`)

```
mneme/memory-layer-0/   ml0-suite-ground.lisp load.lisp package.lisp ml0-fixtures.lisp ml0.lisp ml0-readiness.lisp
mneme/language-act-1/   load.lisp package.lisp act1-fixtures.lisp act1.lisp act1-readiness.lisp
mneme/capability2/      load.lisp package.lisp conditions.lisp world.lisp events.lisp rehydrate.lisp
                        authorize.lisp attempt.lisp reconcile.lisp mutants.lisp
mneme/capability1/      load.lisp package.lisp conditions.lisp context.lisp object.lisp mint.lisp
                        present.lisp mutants.lisp
mneme/capability0/      load.lisp package.lisp conditions.lisp schema.lisp fold.lisp receipts.lisp
                        query.lisp mutants.lisp
mneme/journal0/         load.lisp package.lisp sha256.lisp conditions.lisp pjs0.lisp frame.lisp meta.lisp
                        reader.lisp writer.lisp salvage.lisp fold.lisp mutants.lisp
mneme/kernel0/          load.lisp package.lisp conditions.lisp identity.lisp boundary.lisp determinacy.lisp
                        manifestation.lisp uncertain-effect.lisp outcome.lisp procedure.lisp records.lisp folds.lisp
canonical-datum/common-lisp/  package.lisp cd0.lisp
mneme/language-core-0/  core0.lisp
mneme/language-slice-1/ slice1.lisp
mneme/language-slice-0/ slice0-transmissibility.lisp slice0-projection.lisp slice0.lisp
```

Machine-readable one-per-line: `$T/paths.txt`. Contains **no** `.md`, no evidence/receipt/transcript
file, no Shannon material, no release-floor erratum, no other atelier, no specimen
(`de-actu-memorato/`), no other lane.

## 8. Lane sources vs test infrastructure (`load.lisp:53-56`)

```lisp
(defparameter +ml0-lane-sources+
  '("package.lisp" "ml0-fixtures.lisp" "ml0.lisp" "ml0-readiness.lisp")
  "The lane's four sources, in the ONE declared order.  ml0-readiness.lisp is
LAST and must remain last: its final form is the readiness carrier.")
```

The other 15 `.lisp` files under the lane are **test infrastructure and are NOT loaded by `load.lisp`**:
`ml0-suite-ground.lisp` (its own header, lines 4-7: "⚠ THIS FILE IS NOT ONE OF THE LANE'S FOUR SOURCES
and is deliberately not in `+ml0-lane-sources+`"), `ml0-selftest.lisp`, `ml0-controls.lisp`,
`ml0-mutants.lisp`, `ml0-mutant-overlay.lisp`, `ml0-red-proof.lisp`, `ml0-block-proof.lisp`,
`ml0-consolidation-proof.lisp`, `ml0-host-fault-proof.lisp`, and `de-actu-memorato/{run-specimen,
specimen-common,stage-damage,stage-death,stage-reader,stage-writer}.lisp`. The probe needs exactly one
of them — `ml0-suite-ground.lisp` — hence its presence in the cut.

## 9. `ml0-fresh-run-root` refuses a run root inside the subject tree — YES (ml0-suite-ground.lisp:465-475)

```lisp
(defun ml0-fresh-run-root (stem subject-root)
  "A run root in /tmp, REFUSED if it falls inside the subject tree.  A suite that
writes into the checkout cannot claim the checkout is unchanged afterwards."
  (let ((root (pathname (concatenate 'string
                                     (sb-posix:mkdtemp
                                      (concatenate 'string "/tmp/" stem "-XXXXXX"))
                                     "/"))))
    (unless (null (search (namestring (truename subject-root)) (namestring root)))
      (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
      (sb-ext:exit :code 3))
    root))
```

The root is always a `/tmp` mkdtemp — it is not caller-chosen — so the guard can only fire if the
subject tree itself lives under that `/tmp` path. **The guard was not observed to fire in any run
here** (a gate never seen to fire is untested). I did not plant a firing test.

## 10. Uncertainties / caps

1. **Sufficiency is proven only for this probe.** Cut B was proven by `probe-p8-effect-axis.lisp` and
   nothing else. A different probe touching other ML/0 doors (consolidation, red proof, host-fault,
   the specimen) may need more. The parcel claim should read "minimal for a P8-shaped probe".
2. **Environment, not cut**: SBCL 2.4.6 with the `sb-posix` contrib (`journal0/load.lisp:9`
   `(require :sb-posix)`) and a writable `/tmp`. The cut carries no SBCL.
3. **cwd is load-bearing** (§3): the probe must run with cwd = the cut root. If a review parcel places
   the lane elsewhere, either preserve `<root>/mneme/...` + `<root>/canonical-datum/...` or patch the
   probe's `#p"mneme/../"` too.
4. **Leave-one-out is single-file** (§6), not combinatorial; and a required file is not necessarily a
   semantically used one.
5. `load.lisp`'s "NOT REGISTERED / lisp-plus.asd carries NO lisp-plus/ml0 system" header comment is
   contradicted by `lisp-plus.asd:822`. Off the probe's path; flagged, not resolved.
6. The step-2 refusal arrives as `UNKNOWN-KEYWORD-ARGUMENT`, not the named `ML0-PROVENANCE-INCOMPLETE`
   (§5). Identical in cut A and cut B, so it is not a cut artifact — but it means the probe's "forge
   refused" leg is passed by the constructor simply lacking the keyword, which is weaker than the
   typed refusal the probe's first handler expects. Not my commission to repair; recorded.

## Artifacts (all under `$T`)

`TRACER-REPORT.md` · `paths.txt` (the 68) · `probe-p8-effect-axis.lisp` · `probe-diff.txt` ·
`cutA.{out,err,exit}.txt` · `cutA-attempt1-lanedir.{out,err,exit}.txt` (the cwd failure) ·
`attempt-1.{out,err,exit}.txt` (cut B) · `loo-summary.txt`, `loo-table.txt`, `loo/loo-1..68.{out,err}.txt` ·
`cutA/`, `cutB/` (extracted trees, cutB unchanged after its run).
