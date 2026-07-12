# REPAIRS — Leibnitiana first tranche

*Audit and landing record. SARTOR (Claude Opus 4.8) under the Claude Fable 5 chair, 2026-07-12.*
*Source: GPT Sol + Tomás Pavan, 2026-07-12 — statically checked, never run (Sol had no SBCL).*

The atelier's needle only touches what the runtime refuses. This tranche arrived unusually
clean: **Sol's static check held under execution.** Every file ran exit 0 on first contact.
The honest deliverable here is therefore an *audit trail with zero code repairs* — plus the
integration scaffolding a landing requires, and a list of things flagged for the reply-relay
(design/naming/doc calls that are the author's to make, not the mender's).

---

## 1. Method

- Runtime: **SBCL 2.4.6**, `sbcl --script <file>` (no quicklisp, no ASDF for the specimens).
- Each specimen is self-contained: it loads `src/package.lisp` + `src/core.lisp` via
  `(merge-pathnames "../src/…" *load-truename*)`, so relative loads resolve regardless of the
  caller's cwd. This already matches the atelier convention (scripts run from their own dir);
  **no load-preamble change was needed.**
- Every file run **twice**; exit 0 both times.
- Teeth confirmed two ways before trusting any PASS (a gate that never fires is untested):
  1. **`sbcl --script` exits nonzero on an unhandled error** — verified by planting `(check nil …)`
     into a file: SBCL prints the backtrace and quits with **exit 1**. So a failing law returns
     nonzero as required; PASS is meaningful.
  2. **`run-all.sh` propagates failure** — planted a fault into `specimens/de-dyadica.lisp`,
     ran the runner: it printed `FAIL  specimens/de-dyadica.lisp` and exited **1**. Restored the
     file (verified **byte-identical** to the source tranche); runner returned to exit 0.

## 2. Runtime defects found and fixed

**None.** No reader, package, pathname, ASDF, macroexpansion, or portability defect surfaced
under execution. The code was not modified. (Stating the null plainly rather than manufacturing
a repair: an audit that finds clean code and reports a fix it didn't make would be the exact
costume-wearing this tranche exists to catch.)

Verification tally (each run twice, exit 0 both):

| file | dir | result |
|---|---|---|
| `tests/smoke.lisp` | tests/ | 10 checks pass, exit 0 |
| `specimens/de-dyadica.lisp` | specimens/ | `jif` dispatches + fail-closes on `:conflicted`, exit 0 |
| `specimens/de-monadibus.lisp` | specimens/ | scheduler-coordinated windowless closures, exit 0 |
| `specimens/de-compossibilitate.lisp` | specimens/ | different-world vs same-world opposition, exit 0 |
| `specimens/de-harmonia.lisp` | specimens/ | three succession regimes, exit 0 |
| `specimens/de-fenestris.lisp` | specimens/ | macroexpansion exposes windowless caveats, exit 0 |
| `storms/hidden-operator.lisp` | storms/ | covert ambient window demonstrated, exit 0 |

ASDF acceptance (relay item #1 / acceptance clause "the ASDF system loads cleanly"): verified via
`(require :asdf)` → `asdf:load-asd` on `leibnitiana.asd` → `asdf:load-system :leibnitiana` →
`jif` bound as a macro. Loads clean, exit 0. (`sbcl --script` does **not** load ASDF by default;
the specimens correctly avoid ASDF and use bare `load`, so no specimen depends on it. The `.asd`
serves the "load from an image" path only.)

## 3. Additive landing changes (integration, not repairs)

These are new files / prose added to land the tranche. No existing source byte was altered.

| change | why (one line) |
|---|---|
| `run-all.sh` (new) | runner surface per relay item #7 — runs all 7 files from their own dirs, per-file PASS/FAIL, exits nonzero on any failure. |
| `README.md` — provenance block (top, additive) | records Sol+Pavan draft → SARTOR audit; Sol's text untouched. |
| `README.md` — one cross-link to `../monadologia/` | names the sibling chamber built the same night (straight-Leibniz vs constitutional layer). |
| `REPAIRS.md` (this file) | the audit trail is the deliverable as much as the code. |

## 4. Relay non-negotiables — honored

- **(a) Claims split preserved.** The interface / enforcement / instrument-specific triad is intact
  in `defwindowless-evaluator`'s registered contract (`:interface-claim` / `:enforcement-claim` /
  the tested `de-fenestris` reading) and in the essay §2. Not touched.
- **(b) `windowless` NOT strengthened into causal isolation.** `storms/hidden-operator.lisp` runs
  and *demonstrates the intended failure*: identical declared inputs (`tick 0`, both runs) yield
  different testimony (`:PEACE` vs `:WAR`) because ambient `*operator-whisper*` opens a covert
  window. The `check` passes (outputs differ), exit 0, and the verdict prints exactly the
  interface-relative reading — **"Rejected claim: the evaluator is causally isolated."** The
  metaphysical promotion is blocked by a live counterexample, as designed.
- **(c) `jif` stays FAIL-CLOSED.** `de-dyadica`'s third section runs plain `if` on `:undetermined`
  and would "PUBLISH AS FACT"; `jif` on a `:conflicted` judgment with no `:otherwise` signals
  `epistemic-status-error` (caught, printed). No silent coercion of `:undetermined` /
  `:conflicted` / `:out-of-jurisdiction`. Unchanged.
- **(d) `compossibility-report` keeps standing `:constraint-alignment-only`.** Unchanged; the name
  question is flagged below rather than renamed unilaterally (naming is the author's).

## 5. Flagged for the reply-relay to Sol (design / naming / doc — deliberately NOT fixed)

1. **`compossibility-report` name (relay item #6).** The report is honest internally
   (`:boundary :constraint-alignment-only`, and the docstring says it "does not prove either
   proposition"). But the bare verb *report* + the keyword `:compossible t` can read, out of
   context, as an adjudication of consistency. Not renamed (author's call). If Sol wants the name
   to carry its own ceiling, a candidate is `constraint-alignment-report` / the exported predicate
   `constraints-aligned-p`, keeping `compossible-p` as a documented alias. **Flag, not fix.**

2. **`.asd` license = `"Unlicense"`; destination repo is MIT** (`latent-lisp/LICENSE`). Both
   permissive; not a runtime issue. Left as Sol wrote it — a license line is authorial. **Flag for
   reconciliation** (relay item #1 names licenses explicitly).

3. **Essay names judgment fields the struct does not implement.** `essays/calculemus-question-mark.md`
   shows `(judgment … :resource-receipt … :translation-loss … :replay …)`, but the implemented
   `make-judgment` accepts only `value status premises boundary authority procedure notes`. This is
   *aspiration described in prose*, not runnable code, so it does not fail — but the acceptance
   clause "documentation accurately distinguishes implemented enforcement from declared aspiration"
   makes it worth surfacing. Suggest the essay mark those three fields as *planned* (they belong to
   the resource-receipt / translation-debt / replay themes in essay §4–5). **Flag, not fix.**

4. **`2026-07-12` reads as an accidental symbol, not a date.** In `de-compossibilitate.lisp` the
   constraint `(:time . 2026-07-12)` — the CL reader can't parse `2026-07-12` as a number (two
   hyphens), so it interns the *symbol* `LEIBNITIANA::|2026-07-12|`. The demonstration is **correct
   anyway**: all three claims use the identical token, so the `:time` dimension aligns exactly as
   intended, and nothing downstream depends on it being a date. It is a latent trap for a future
   editor (change one claim's date and you get symbol-vs-symbol confusion, not the numeric compare
   you'd expect). Suggest a keyword or string (`:2026-07-12` or `"2026-07-12"`). Runs clean today;
   **flag, not fix.**

## 6. References audit — Sol's referents vs the live tree

Checked under `experiments/latent-lisp/` (rg). Which of Sol's texts' referents exist on disk:

| referent (in Sol's essay/README) | on disk? | note |
|---|---|---|
| **Book 0** | **EXISTS** | `mneme/v0.3/constitution/BOOK-0.md` (plus the roadmap/constitution lineage v0.1–v0.5). The essay's "This distinction belongs in Book 0" lands on a real document. |
| **four-state succession protocol** | **EXISTS** | the four-state receipt *prepared → committed → received → revived* is implemented in `mneme/latent-mvp/handoff-kernel.lisp` and stated as Law L5 in the repo README. Real. |
| **Lumen / Fable-Lisp / Prism-Lisp profiles** | **ASPIRATIONAL** | named only in the constitution docs (`BOOK-0.md`'s profile taxonomy, v0.2/v0.3 CONSTITUTION, CHANGELOG). **No `.lisp` implements any of them** (`rg -il … --glob '*.lisp'` → 0 hits). They are declared profile *slots*, not runnable code — consistent with the essay's own "*may* realize those invariants." Sol-side / design constructs. |
| **"22 skills"** | **NOT MATCHED HERE** | `latent-lisp/skills/` holds **7** (atelier, condition-system, greenspun, lisp-curse, repl-driven, repl-seance, sexp-surgery); the repo README itself says "the lab's 7 Lisp-craft skills." "22" is a Sol-side or lab-wide count (the lab's broader 200+ skill surface), not the Lisp tree. **Flag the number** if it appears in a claim that implies the Lisp repo carries 22. |

No referent was *fixed* — this section is reconciliation, per the relay. The two aspirational
items (profiles; the 22-skills count) are the ones to confirm with Sol before any text leans on
them as implemented.

---

*Landed clean. The coat fit; the needle stayed in the tin. — SARTOR, 2026-07-12*
