# F1 MAP — the exact gate P10 means, from primary sources

*P10 REAL GATE /0 (Astra → Fable, 2026-09-15, attachment sha256 `1cd61d5c23f59ff24d84604643d43445fbf539c0ac66c633788828fc01f5a7f4`, 10,437 B, read in full). Chair: Claude Fable 5.1, **A Comment Is A Claim** [653264], laptop, branch `build/p10-real-gate-0`. Step 1 of the commission: identify the exact F1, its command, implementation, callers, counters, output and exit conventions, and the clauses describing its scope — before any experiment. Every claim below carries a file:line; excerpts are copied verbatim into `sources/`.*

## 1. Subject identities (re-pinned locally; `main` did not stand still, the lane did)

| Identity | Value | Read |
|---|---|---|
| `main` HEAD at branch cut | `244580e81` (after four record-only commits since the morning's `8f41eee13`) | `git rev-parse` |
| `experiments/latent-lisp` tree | `e148d8a5344cd0bef88d0a8d5eba77684577d9f3` — **unchanged** since `8f41eee13` and equal to the public tip `5e63bffd`'s subject | `git rev-parse HEAD:experiments/latent-lisp` |
| ML/0 lane tree | `9458616a438fbce1de0433d439b458f83d76fbac` — unchanged since `fa0a45d4a` (2026-08-21) | `git rev-parse HEAD:…/memory-layer-0` |
| The gate file | `experiments/latent-lisp/mneme/memory-layer-0/ml0-block-proof.lisp`, 1,003 lines | sha256 in `subjects/PINNED-SUBJECT-SHA256.txt` |
| NOT the subject | `candidate/mneme-debt-disposition-0` (the P9 proof-comment candidate; its `ml0-consolidation-proof.lisp` and `FILE-MANIFEST.txt` differ) · `build/warrant-session-0` and the 09-11 branches | attachment §1 |

## 2. Which "F1" (three things share the name; P10 means the first)

1. **The gate — `ml0-block-proof.lisp` probe [12], labelled `F1`** (file header l.48–51: *"F1 NO EXTERNAL FUNCTION of this lane carries a `defect` parameter — walked over every external fbound symbol's COMPILED LAMBDA LIST via `sb-introspect`, in an image loaded through the canonical `load.lisp`. The R3 build had TEN."*). This is what P10 names: SPEC l.295 — *"`sb-introspect`, not out of the source text by grep (`ml0-block-proof` F1, …)"*; RETURN l.1326 — *"`ml0-block-proof` F1 walks every external fbound…"*; FRIGUS `AUDIT-RETURN.md:59,69,144`; MiniMax Phase-B `probe-p10-F1-introspect.lisp` (its own reimplementation of the walk over the loader's list — not the gate).
2. Not this: **Codex finding F1** (`notes/2026-08-20-ml0-codex-adversarial-audit.md`; RETURN l.1219–1246) — the *finding* the probe was written to close ("the `defect` mutant seam is a public runtime lever"). The probe is named after it.
3. Not this: **the lane-readiness carrier / loader completeness predicate** (`load.lisp` l.183–260: `+ml0-external-functions+` (148 names), `ml0-api-shortfall`, `ensure-ml0-lane`, `ml0-lane-incomplete`) — a *different instrument* that runs at load, before any probe; it is named here because an absent binding may be caught by it before F1 ever runs (case M1's first question).
4. Not this: the release-floor row (`verify-release.sh:336`: `full|ml0|.|sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp|ml0-block-proof: 20 probes, 20 closed, 0 open|no`) — the *consumer* of the gate's sentinel; it matches the sentinel string and the exit.

## 3. The gate, exactly (`sources/F1-probe-excerpt-ml0-block-proof-758-785.txt`)

**Command (normal entry point):** `cd experiments/latent-lisp && sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp` (header l.3; floor row). Loads `ml0-suite-ground.lisp` → `load.lisp` → the four lane sources + substrate, then `ensure-ml0-lane` (l.84–86; `load.lisp:273`); `(require :sb-introspect)` at l.82. `*lane-directory*` is `*load-truename*`-relative (l.90–92); the fixture ground uses cwd-relative `#p"mneme/../"` roots under `/tmp` (as every ML/0 suite).

**Preflight:** l.181–183 — if `ml0-env-preflight` finds a process-ending switch set, prints `ml0-block-proof: VOID — a process-ending switch is set.` and exits **4**.

**The F1 probe (l.765–785), verbatim core:**
```lisp
(do-external-symbols (symbol package)          ; package = lisp-plus-memory-layer0
  (when (fboundp symbol)                        ; ← an UNBOUND external is skipped, silently
    (let ((arglist (handler-case (sb-introspect:function-lambda-list symbol)
                     (error () nil))))          ; ← an introspection ERROR becomes NIL, silently
      (when (some (lambda (item) (and (symbolp item)
                                      (member (symbol-name item) '("DEFECT" "DEFECT-PAYLOAD") :test #'string=)))
                  arglist)
        (push (symbol-name symbol) offenders)))))
(probe "F1 · NO EXTERNAL FUNCTION OF THIS LANE CARRIES A `DEFECT` PARAMETER — the mutant seam is not a public runtime lever"
       (null offenders)
       (if offenders (format nil "⚠ ~d exported function(s) still take it: ~{~a~^, ~}" …)
           "walked every external fbound symbol's compiled lambda list"))
```
**Declared obligation (the only one):** no external fbound function's compiled lambda list contains a parameter named `DEFECT` or `DEFECT-PAYLOAD`. **Not declared:** any calling-convention / signature obligation; any completeness accounting. **Counters:** none inside F1 — no count of symbols walked, inspected, or uninspectable is kept or printed. **Printed claim on CLOSED:** *"walked every external fbound symbol's compiled lambda list"* — printed regardless of whether every `function-lambda-list` call succeeded (the `(error () nil)` arm leaves no trace).

**Companions:** F1b (l.787–808) — the crown predicate refuses the old `:defect` keyword route. F1c (l.969–998) — runs LAST, loads `ml0-mutant-overlay.lisp`, shows the mutant still fires under `with-ml0-mutant`.

**Aggregation and exit (`sources/probe-helper-excerpt-95-105.txt`, `sentinel-excerpt-998-1003.txt`):** `probe` increments `*probes*` and either `*closed*` or `*open-holes*`, prints `[n] CLOSED|OPEN  <label>` + note; the file ends `ml0-block-proof: ~d probes, ~d closed, ~d open` and `(sb-ext:exit :code (if (zerop *open-holes*) 0 1))`. **Exit conventions:** 0 = all closed · 1 = ≥1 OPEN · 4 = VOID (env) · an unhandled error anywhere (including inside the initial `load`, e.g. the loader's `ml0-lane-incomplete`) ends the `--script` process nonzero *without* a sentinel line. A nonzero exit therefore does not by itself say the gate reached F1; the sentinel and the `[12]` line do.

## 4. What the two prior auditors did with it

- **MiniMax-M3, Phase B** (`original/minimax-phaseB-probe-p10-F1-introspect.lisp`): re-implemented the walk over the loader's `+ML0-EXTERNAL-FUNCTIONS+` (148 names; 148 fbound; 0 offenders; then with the overlay) — *not* the gate; P10 PASS at its scope.
- **MiniMax-M3, supplement** (`original/minimax-supplement-probe-p10.lisp`): `fmakunbound` of the first loader name (`ML0-NOTE`) in its own process, then a **new counting loop** (attempted 148 / succeeded 147 / failed 1). Sol II: *"it ran a new counting loop, not the lane's real F1 gate"* → the real-gate arm **NOT TESTED BY THE STRICT STRANGER**.
- **FRIGUS (same-root cold audit)** (`original/p10-f1-introspection-injection.lisp`, `run-p10-f1-injection.sh`, `frigus-injection-attempt2.txt`): replaced the function cell of `sb-introspect:function-lambda-list` in-process with a wrapper that counts every call and signals an error for `LISP-PLUS-MEMORY-LAYER0::ML0-WRITE`, registered an exit hook printing the counts, then `(load "mneme/memory-layer-0/ml0-block-proof.lisp")` — **the real gate file, unchanged, in the same process, from the venue root.** Observed: `FRIGUS-INJECTED-INTROSPECTION-ERROR: ML0-WRITE` printed under `---- F1 ----`, then `[12] CLOSED F1 · …` with the "walked every…" note, `ml0-block-proof: 20 probes, 20 closed, 0 open`, exit 0, `FRIGUS-TARGET-INJECTIONS: 1`. Finding 3: *"F1 can stay green after an external function's lambda list was not read."* Accepted by Sol II as *"P10/F1: partial coverage confirmed—one targeted introspection failure was swallowed and unreported while the gate remained green."* — This is the U1 condition this commission reproduces, through the same boundary (the function cell of the instrument), with the gate invoked by `load` from a `--script` interposer — the one invocation-boundary adaptation, retained and explained.

## 5. The register entry and the starting account (reconciled)

Sol II §IV: **P10 — F1 coverage is PARTIAL: PASS, bounded; real-gate failure injection NOT TESTED** (by the strict stranger). ADDENDUM 24 §3/§5 same. Astra 14:55: *P3/P5/P10 remain unchanged*. The attachment's four bullets match these records exactly. *A partial check is not automatically a violated contract* — and §4 of this map records that no normative clause was found requiring F1's completeness (see `SOURCE-MAP.md` Q4 for the search); the completeness sentence lives in the probe's own header and CLOSED note.

## 6. The questions this experiment can answer (and the ones it cannot)

Can: what a green run inspects (B0, with an instrument-level count of `function-lambda-list` calls under the unchanged gate); whether an absent binding is noticed by the gate or by the loader, and which verdict/exit results (M1, two arms); whether the one declared obligation is detected when violated, and how it propagates to the sentinel and exit (M2-positive); whether an uninspectable lambda list is exposed, skipped, or counted as success (U1, FRIGUS's condition reproduced). Cannot: certify the gate; establish anything MiniMax did; discharge the independent-stranger arm; establish a "calling-convention" obligation F1 never declares (M2 as written by the attachment is documented as having no obligation to test).
