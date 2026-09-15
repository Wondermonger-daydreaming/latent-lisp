# SMITH-2 — P10 REAL GATE /0 auditor harness: build report

*2026-09-15 (built 15:0x–15:35 -03:00). Builder: SMITH-2 (Claude Opus 5, 1M). Scratchpad only;
**nothing was written into the lab checkout** (`git status` at the end shows only `M tools/ledger/agents.jsonl`
and three untracked files under `atelier/p10-real-gate-0/` that are another hand's — `evidence-roles.txt`,
`tools/repro.sh`, `tools/validate-parcel.sh`). All harness output is under
`$W = …/scratchpad/smith2/`; all subjects under `/tmp/p10-rg0-*`.*

**Prereg verified before anything was built:** `prereg/PREREG-P10-RG-0.md` sha256
`0835d5db9f44a27f68ec29b993e2ca97e247200bc197569cc5a66250ffab7165` — matches the frozen value.
Pinned commit `244580e81a9002ea61a435ed185e85133a994fd9`, subtree `experiments/latent-lisp`, 70-file
closure list sha `7ed240a9bd77add4…`. SBCL 2.4.6 at `/home/gauss/.local/bin/sbcl`.

## Files (all in `$W/harness/`, portable; `../subjects`, `../prereg` resolve from `dirname $BASH_SOURCE`)

| file | sha256 (first 16) |
|---|---|
| `mutate.py` | `3c8b3bd1621a7ea2` |
| `witness.lisp` | `deb6924b65c7fc92` |
| `interposer.lisp` | `d021aa4e668ecb49` |
| `p10-classify.sh` | `f85351e948daa4c7` |
| `p10-runner.sh` | `5d7bba937f14d34e` |
| `EXPECTATIONS-P10.txt` | `0cfc65e812392f3f` |

A scratchpad mirror `$W/{prereg,subjects}/` holds read-only copies of the arc's `prereg/` and `subjects/`
so the harness dir sits where it will live (`atelier/p10-real-gate-0/harness/`). Nothing is written back.

## The mutations (exact-match guarded, verified against the pinned pristine)

```
M1-C  delete (defun ml0-print-store-universe …)   l.1846-1858 + 1 blank line   -> ml0.lisp 138fec8dac0fe1eb…
      form boundaries VERIFIED by a reader-aware scan (l.1849 has a ')' inside a format string)
M1-U  -(defstruct (ml0-subject (:constructor %make-ml0-subject (&key fixture-row act-id …
      +(defstruct (ml0-subject (:constructor %make-ml0-subject (&key act-id …           [l.511]
      -  (fixture-row nil :read-only t)                                                 [l.514]
      -        :fixture-row fixture-row                                                 [l.538]   -> 8bceda0783e459d7…
M2-P  -(defun ml0-evidence-projection-digest (evidence)
      +(defun ml0-evidence-projection-digest (evidence &key defect)                     [l.3095]  -> e9f43b677b43ff4b…
M2-X  +(defun ml0-evidence-projection-digest (evidence extra)                           [l.3095]  -> 06eccb2cb1a8dc61…
```

**The guard earned its keep.** `  (fixture-row nil :read-only t)` occurs **twice** in ml0.lisp — l.514
(`ml0-subject`) and l.1112 (`ml0-bundle`) — and mutate.py refused the naive edit
(`dev-runs/001-mutate-smoke/out.txt`). M1-U's l.511+514 edits are now one replacement anchored on the
`ml0-subject` docstring, and l.538 is anchored on `(%make-ml0-subject`. `ml0-bundle` is untouched
(verified: its slot survives at l.1110 of the mutated file).

## Final dev run — `$W/dev-runs/008-full-run-FINAL/` · `P10-RUNNER: pass=8 fail=0 invalid=0 blocked=0`

| case | class | sentinel | `[12]` line + note | exit | witness | counts |
|---|---|---|---|---|---|---|
| **B0** | GATE-GREEN | `20 probes, 20 closed, 0 open` | `[12] CLOSED  F1 · …` / *walked every external fbound symbol's compiled lambda list* | 0 | — | — |
| **B0-I** | GATE-GREEN | identical to B0 | identical to B0 (checked, both lines) | 0 | — | `calls=314 injections=0` |
| **M1-C** | BLOCKED-AT-LOADER | (none) | (no `[12]` line; **0** `[n]` lines) | 1 | `LOADER: refused ML0-LANE-INCOMPLETE…` · `status=:EXTERNAL fboundp=NIL lambda-list=ERROR:The function …ML0-PRINT-STORE-UNIVERSE is undefined.` | — |
| **M1-U** | GATE-GREEN | `20 probes, 20 closed, 0 open` | `[12] CLOSED` / the literal | 0 | `LOADER: ok` · `status=:EXTERNAL fboundp=NIL` | — |
| **M1-U-I** | GATE-GREEN | `20 probes, 20 closed, 0 open` | `[12] CLOSED` / the literal | 0 | as M1-U | `calls=312 injections=0` |
| **M2-P** | GATE-OPEN-F1 | `20 probes, 19 closed, 1 open` | `[12] OPEN    F1 · …` / `⚠ 1 exported function(s) still take it: ML0-EVIDENCE-PROJECTION-DIGEST` | 1 | `lambda-list=(EVIDENCE &KEY DEFECT)` | — |
| **M2-X** | **CRASH-MID-GATE** *(exploratory; neither PASS nor FAIL)* | (none) | last probe reached `[7]`; stderr `SB-INT:SIMPLE-PROGRAM-ERROR … invalid number of arguments: 1` in `(ML0-EVIDENCE-PROJECTION-DIGEST …)` ← `ML0-OBSERVE-ISSUANCE` | 1 | `lambda-list=(EVIDENCE EXTRA)` | — |
| **U1** | GATE-GREEN | `20 probes, 20 closed, 0 open` | `[12] CLOSED` / the literal; `INJECTED-INTROSPECTION-ERROR: ML0-WRITE` printed under `---- F1 ----` | 0 | — | `calls=313 injections=1` |
| **U1-M** | GATE-GREEN | `20 probes, 20 closed, 0 open` | `[12] CLOSED` / the literal | 0 | `lambda-list=(EVIDENCE &KEY DEFECT)` | `calls=313 injections=1` |

Every secondary check printed `SEC-OK` (314/0 · 312/0 · 313/1 · injections=1 · the offender name · the literal
notes · B0-I's `[12]`/note/sentinel byte-identical to B0's). `IDENTITY-AFTER: all pinned files unchanged`
(70/70, the restore).

**The eight source-supported expectations all held. U1-M is the headline: a real planted `DEFECT` offender,
made uninspectable by one targeted introspection error, produces `[12] CLOSED` with the fixed note "walked
every external fbound symbol's compiled lambda list", `20 probes, 20 closed, 0 open`, exit 0 — masking
reproduced, as §3 predicted.** (Diagnosis only; §7 is untouched by this report.)

**Reproduced three times, two routes.** Run 007 (git archive), 008 (git archive) and 009
(`P10_SUBJECT_TREE`, no git) give the *same nine classes*, and the mutated `ml0.lisp` shas are byte-identical
across routes for all five mutated cases.

## Controls (prereg §5) — decisive lines

```
C-1  P10-RUNNER: EXPECT OVERRIDE (verbatim): M2-P=GATE-GREEN
     FAIL M2-P: got 'GATE-OPEN-F1' expected 'GATE-GREEN'        pass=7 fail=1   runner exit 1
C-2  P10-RUNNER: EXPECT OVERRIDE (verbatim): M1-C=GATE-GREEN
     FAIL M1-C: got 'BLOCKED-AT-LOADER' expected 'GATE-GREEN'
     BLOCKED M1-C: BLOCKED-AT-LOADER before the gate's first probe, and not this case's expectation
                                                                pass=7 fail=1 blocked=1   runner exit 1
C-3  (synthetic: B0's transcript, gate.exit.txt forced to EXIT 1)
     CLASS B0: INCOHERENT · NOTE B0: sentinel reports 0 open but the process exited 1
     FAIL B0: got 'INCOHERENT' expected 'GATE-GREEN'             classifier exit 1
C-4  (synthetic: M1-U's transcript, WITNESS: line deleted)
     INVALID M1-U: witness printed no WITNESS: line              classifier exit 3
```

Extra teeth (`dev-runs/ctl-T-refusals/`, `ctl-T7-void-pinned/`), each seen to fire:
prereg sha mismatch → REFUSE 5 · pinned list absent → REFUSE 5 · duplicate expectation row → REFUSE 5 ·
unknown case row → REFUSE 5 · a process-ending switch set → REFUSE 5 (so `VOID-ENV` stays a real class,
never an accident) · a second runner → VOID 6 · a tampered subject file → `P10-RUNNER: VOID — B0: pinned
closure MISMATCH before mutation`, exit 6.

## Divergences (nothing was bent to fit)

1. **M1-C's loader shortfall string is not the predicted one.** Prereg §3 and SOURCE-MAP §3(a) predict
   `function ML0-PRINT-STORE-UNIVERSE: absent`; the measured string is
   **`function ML0-PRINT-STORE-UNIVERSE: external but not bound as a function`**
   (`008/out/M1-C/gate.err.txt`, `witness.out.txt`). Cause, exhibited: deleting the `defun` does not
   un-export the symbol (`package.lisp:245`), so `find-symbol` still returns it with status `:EXTERNAL` and
   `load.lisp:211` (the `null symbol` → "absent" branch) never fires; `load.lisp:217` (the `not fboundp`
   branch) does. **The class is unaffected** — BLOCKED-AT-LOADER, 0 `[n]` lines, exit 1, exactly as §3 says.
2. **M2-X resolved to `CRASH-MID-GATE`, not `GATE-GREEN`** — one of the two branches §3 explicitly left open,
   so this is an answer, not a failure. It crashes *before* F1 (last probe `[7]`), so this run shows **F1 was
   never reached** on M2-X; the gate's indifference to calling convention is therefore *not* demonstrated by
   M2-X — only that the incompatibility surfaces elsewhere, in `ML0-OBSERVE-ISSUANCE` at `ml0.lisp:937`.
3. **The commissioned 200-char cap on the witness `LOADER:` line truncates the shortfall string** the prereg
   wants witnessed. Both are honoured: the capped line is printed as commissioned, and an **additive**
   `LOADER-SHORTFALL:` line carries the bullets in full. (This is how divergence 1 was caught.)
4. **`mutate.py`'s pristine has two routes, not one.** The commission says "extract from the same commit via
   `git show`"; the coordinator's `P10_SUBJECT_TREE` addition must work where no repo exists. Route 1 is
   `git show` (used whenever a repo is reachable, and cross-checked byte-equal against the subject);
   route 2 is a pre-mutation copy whose sha256 is asserted equal to the pinned row for that path. The
   provenance is printed into every `MUTATION-DIFF.txt` header. Both routes produced identical mutants.
5. **M1-U's l.511 and l.514 edits are one replacement, not two** — forced by the duplicate slot line
   (above). Same bytes, one guard instead of two.
6. **`INCOHERENT` on a late error is stream-order-blind.** stdout and stderr are captured separately, so
   "`Unhandled` on stderr *after* a sentinel" is implemented as "a sentinel exists **and** stderr contains
   `Unhandled`". B0's stderr (18 lines of overlay compile warnings) contains no `Unhandled`, so the rule
   costs nothing on the green path — but it cannot distinguish a *late* error from an early one that somehow
   still printed a sentinel.
7. **`interposer.lisp` prints one line FRIGUS did not**: `INTERPOSER-TARGET: <name|none>` before the load, so
   the transcript records what was armed. It is neither a sentinel nor a `[n]` line; B0-I's `[12]`/note/
   sentinel are still byte-identical to B0's (checked).

## Uncertainties

- `GATE-GREEN` is implemented as `open==0 ∧ exit==0 ∧ [12] CLOSED`, with `probes==20 ∧ closed==probes`
  required (else `INCOHERENT`) so the prereg's literal `20 probes, 20 closed, 0 open` is enforced. A
  legitimate future change in probe count would read as INCOHERENT — correct here, brittle elsewhere.
- `GATE-OPEN-F1` is discriminated by `[12] OPEN` and requires exit 1; if `[12]` were OPEN *and* other probes
  too, the class is still GATE-OPEN-F1 with a `NOTE` naming the extras. The prereg's grammar has no member
  for that combination; I chose the discriminator over the count. Not exercised by any run.
- U1's `calls=313` and B0-I's `314` reproduce INSPECTOR's and FRIGUS's numbers, but `313` here is `314 − 1`
  from *this* interposer's own arithmetic, not an independent re-derivation of FRIGUS's image.
- The witness loads `ml0-suite-ground.lisp` directly rather than entering through `ml0-block-proof.lisp`;
  it is the same chain (`:84-86`), but it is a second process, not the gate's.
- I did not delete any subject tree (`/tmp/p10-rg0-*`, ~13 trees) — awaiting the chair's word, per the
  commission.
- Every development run is kept: `$W/dev-runs/001…009`, `ctl-C1..C4`, `ctl-T-refusals`, `ctl-T7-void-pinned`.
  The run for the chair to review is **`008-full-run-FINAL`**; `009` is the same run on the no-git route.
