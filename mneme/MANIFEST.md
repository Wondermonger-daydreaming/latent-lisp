# MANIFEST — Mneme runnables and what should be true

*Phase 0.2 of `ROADMAP.md` (Gate G0). Written for a stranger who has never seen this
repo: every runnable, its one-line law, the exact command to run it, and the output
signature that means it passed. If you can read this table and reproduce every row,
the floor has not rotted.*

## How to read this

- **Prerequisite:** SBCL 2.4.6 on `PATH` (check: `sbcl --version`). No other
  dependencies — the standing law under `latent-lisp/` is SBCL-only, no quicklisp.
- **Working directory matters.** Several suites `load` sibling files by relative path;
  run each from the directory named in its "Run from" column or the run will error.
  The one-command entry (`verify-all.sh`) already `cd`s correctly for every suite —
  prefer it.
- **Exit code is the contract.** Every runnable exits `0` on pass, nonzero on fail.
  `verify-all.sh` additionally checks the *check-line counts* below, so a suite that
  exits 0 but prints the wrong number of checks is still caught.
- **Paths below are relative to this directory** (`experiments/latent-lisp/mneme/`).

## The table

| # | Runnable | Law / purpose (one line) | Run from | Invocation | Expected output signature | Exit |
|---|----------|--------------------------|----------|------------|---------------------------|------|
| 0 | `verify-all.sh` | The single CI floor: runs rows 1–6 in order and checks each floor's check-line counts. | `mneme/` | `bash verify-all.sh` | Six `PASS` lines, then `ALL FLOORS HOLD — 6/6 suites green.` (deterministic — two runs diff byte-identical) | 0 |
| 1 | `latent-mvp/conformance-walk.lisp` | Kernel v0: the seven laws (L1–L7) hold in one image — rhetoric ≠ evidence, production ≠ truth, claimed ≠ authenticated, testimony survives its author's death. | `latent-mvp/` | `sbcl --script conformance-walk.lisp` | Exactly **7 ✓** marks (`L1`…`L7`), then `[seven laws, one kernel, no drift — the consolidation holds]` | 0 |
| 2 | `latent-mvp/adversarial-conformance.lisp` | Hardened client/operator split: three lawful routes succeed and **15 forgeries** are each refused by their own typed gate (a gate that never fires is untested). | `latent-mvp/` | `sbcl --script adversarial-conformance.lisp` | Final line `=== 18 passed, 0 failed ===` (3 lawful + 15 adversarial checks) | 0 |
| 3 | `latent-mvp/counterexample-closure.lisp` | The ten exported-client counterexamples from the v1 closure sprint remain closed: mutable strings/fingerprints, canonical scope, monotone receipts, explicit raw decode, and second-hop testimony. | `latent-mvp/` | `sbcl --script counterexample-closure.lisp` | Final line `=== 10 passed, 0 failed ===`, followed by the bounded P3 receipt | 0 |
| 4 | `latent-mvp/boundary/run-boundary.sh` | L5/L6/L7 data behavior across a **real process gap**: image A freezes and exits; image B explicitly decodes raw artifact bytes as untrusted, grants no serialized standing, and re-verifies locally. | `mneme/` (script self-locates) | `bash latent-mvp/boundary/run-boundary.sh` | Final tally `=== 9 passed, 0 failed ===`, then `Boundary conformance holds across a real process image gap`. *(Raw output contains a per-run pid — non-deterministic; `verify-all.sh` reads only the tally.)* | 0 |
| 5 | `atelier/run-all.sh` | The original six specimens, jurisdiction wing, ten-specimen decad, and post-decad instruments all hold. | `mneme/` (script self-locates) | `bash atelier/run-all.sh` | Four pass banners: original six, jurisdiction instruments, ten decad specimens, and post-decad instruments | 0 |
| 6 | `language-a/fixtures.lisp` | Language-A validator teeth: 6 lawful claim records validate; 8 malformed records each fire their declared typed condition; 8/8 conditions covered. | `mneme/` | `sbcl --script language-a/fixtures.lisp` | **14 `PASS ` lines** (6 lawful + 8 malformed), then `SUITE PASSED — 6/6 lawful validated · 8/8 malformed fired · 8/8 conditions covered.` | 0 |

## Non-runnable companions (context, not tested by verify-all)

| File | What it is |
|------|-----------|
| `ROADMAP.md` | The Phase 0–5 plan (this MANIFEST is Phase 0.2). |
| `../V1-COUNTEREXAMPLE-CLOSURE.md` | The v1 sprint's before/after transcript, strategy decision, verification receipt, and bounded residual threats. |
| `language-a/validator.lisp` | The 12-check / 8-condition validator that `fixtures.lisp` loads and exercises. Loading it alone prints its refusal doctrine but runs no teeth. |
| `language-a/DEPOSITION-NOT-THOUGHT.md` | Why a Language-A record is a deposition of what an answer makes inspectable — not a readout of cognition. |
| `latent-mvp/kernel.lisp`, `kernel-hardened.lisp` | The kernels the conformance / adversarial walks load. |
| `atelier/instruments/`, `atelier/toys/`, `atelier/reliquaries/` | The individual specimens `atelier/run-all.sh` drives; each is independently `sbcl --script`-runnable. |

## The honest ceiling (do not overread a green run)

Every suite here proves **coherence and structural discipline**, never **truth**. A
cooperative author who lies can still emit a record that passes every line in row 5;
a structure-preserving content edit passes the boundary decoder in row 3 and is caught
only by re-authentication, **not** by cryptography. Each suite prints its own
"what this does NOT establish" confession — that text is load-bearing, not modesty.
The forgeable seam is *relocated* by these floors, not closed.

## When a floor legitimately changes

If a suite's check count changes for a real reason (a new law, a new fixture), update
**two** places together: the suite itself, and the matching `EXPECT_*` constant in the
**Expectation table** at the top of `verify-all.sh` — never the script's expectation
alone (that would hide the drift) and never the suite alone (verify-all would then flag
a phantom crack). Re-run `bash verify-all.sh` twice and confirm the output still diffs
byte-identical before committing.

*— built by LIBELLA (Claude Opus 4.8, 1M context), 2026-07-11, on the verified state of
that evening. Every signature in the table above was observed live, not remembered.*
