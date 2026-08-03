# Language Form /2 — Lexical Source Erratum 0.1

**Date:** 2026-08-02
**Branch:** `opus/form2-lexical-source-erratum-0.1`
**Base:** current authorized lab main `e3c7d4364c90ece7bbbe2ae333801629e406a1b4`
**Base subject subtree:** `5cd1c506ae2d288aeb5bcececbcbc352dd819a1b`
**Authority:** owner adjudication `INTEGRATION-BASELINE-0-RETURN-ADJUDICATION-AND-R1-COMMISSION.md` §IV
(sha256 `21d89d89090d739129c50c8b40f83c28e816990f6d05e1919b973524af5ae0b9`)
**Builder:** JOINER (Claude Fable 5)

> **This erratum changes no Form /2 semantics, exports, identities, ceilings, fixtures, or
> standing.** Form /2 remains a **published candidate-by-default**. Nothing here adopts
> anything, promotes anything, or answers any open ruling.

---

## 1. What was wrong

Two genuine, non-style compiler `WARNING`s lived in `form2.lisp`, and a third defect — in the
selftest — is the reason nobody had to look at them.

### 1.1 The lexical defect: a docstring that stopped early

`%build-receipt`'s documentation string contained an unescaped pair of interior quotes:

```lisp
"Lawful" was the earlier word and it was too broad: ...
```

The reader does not see a quoted word inside a string. It sees **the end of one string, a
symbol, and the start of another**. The compiled function body therefore was:

```text
(BLOCK LISP-PLUS-FORM2::%BUILD-RECEIPT
  LISP-PLUS-FORM2::LAWFUL            ; <- an executable variable reference
  #<(SIMPLE-ARRAY CHARACTER (677))>  ; <- the rest of the paragraph, as a discarded constant
  (LET ...))                         ; <- the real body
```

exhibited verbatim in the pre-erratum load transcript. SBCL reported:

```text
; caught WARNING:
;   undefined variable: LISP-PLUS-FORM2::LAWFUL
```

Two consequences, both real: the intended explanatory paragraph was **not** part of the
function's documentation (it had become an unreachable constant), and the function body
contained a read of an undefined variable.

### 1.2 The declaration-order defect

`%rebuild` reads `*%fault-rebuild-cd0-failure*` **in its first form** (`form2.lisp:662` before
this erratum), while the `DEFVAR` sat ~70 lines further down at line 728. A fresh source load
compiles the read before any declaration exists:

```text
; caught WARNING:
;   undefined variable: LISP-PLUS-FORM2::*%FAULT-REBUILD-CD0-FAILURE*
```

### 1.3 Why the archived `86/0` transcript could stay green over both

The selftest's loader was:

```lisp
(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((*error-output* (make-broadcast-stream)))
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "form2.lisp" ...)))))
```

**A broadcast stream with no components is a sink.** Binding `*error-output*` to one discards
every diagnostic the compiler writes during the load — not only the `STYLE-WARNING`s the
`handler-bind` meant to muffle, but genuine `WARNING`s as well. The suite then ran its 86
behavioural checks, all of which genuinely passed, and printed `86 checks passed / 0 failed`.

Both facts were true at once, and that is the whole lesson: **a green behavioural suite does
not certify that the source compiled cleanly, and a suite that cannot see a warning is not
evidence that there was none.**

This is exhibited rather than asserted. Running the **pre-erratum selftest against the
pre-erratum source** on this host:

```text
$ sbcl --script mneme/language-form-2/form2-selftest.lisp     # at base e3c7d436
== form2-selftest: 86 checks passed / 0 failed ==
EXIT=0
```

— green, over both warnings, exactly as archived.

---

## 2. What was changed

Two source files. **No other lane's `.lisp` was touched.**

### 2.1 `form2.lisp` — two edits, both mechanical

| edit | change | preserved |
|---|---|---|
| **A** | `"Lawful"` → `\"Lawful\"` (one line, two characters added) | the sentence, its wording, its position, and the quotes around the word — now as *text inside* the docstring |
| **B** | the four-line `PLANTED-FAULT HOOKS` block **moved** from below the receipt section to above `%rebuild`, its first reader | every name, every `NIL` default, the full docstring byte-for-byte, internal/unexported status, and all fixture behaviour |

Edit B is a **move, not a rewrite**: the block's text is unchanged apart from an added comment
recording why its position is now load-bearing. All four hooks moved together so the documented
block stays one unit.

The smallest edit was preferred throughout. **The theorem, the identity construction, the
refusal semantics, and the receipt semantics were not touched.**

### 2.2 `form2-selftest.lisp` — stop hiding non-style warnings

The `*error-output*` sink is gone. `STYLE-WARNING`s are still muffled (permitted and
unchanged). Every **non-style** warning is now collected and, unless it matches an
**explicitly empty allowlist**, makes the suite exit nonzero **before a single check runs**.

```lisp
(let ((allowlist '())          ; EMPTY BY INTENT
      (offenders '()))
  (handler-bind ((style-warning #'muffle-warning)
                 (warning (lambda (w) (push (princ-to-string w) offenders))))
    (load ...))
  ... (when offenders ... (sb-ext:exit :code 1 :abort t)))
```

The `warning` handler **declines** after recording, so each warning still reaches the real
`*error-output*` and remains visible to the operator as well as counted.

This is a Form /2-local observability repair. It does **not** convert warnings to errors
anywhere else in the project.

### 2.3 New file: `SOURCE-HYGIENE-GATE.lisp`

One small lane-local gate carrying the regression facts §IV.4 requires. **23 checks.** It is a
new gate, not a change to an existing one — no existing check count moved.

---

## 3. Exact warning transcript, before and after

Raw source load, stderr captured, fresh SBCL 2.4.6 process, no suppression of any kind:

```text
$ sbcl --noinform --non-interactive --eval '(load "mneme/language-form-2/form2.lisp")'
```

**BEFORE** (base `e3c7d436`) — exit 0, but:

```text
; caught WARNING:
;   undefined variable: LISP-PLUS-FORM2::*%FAULT-REBUILD-CD0-FAILURE*
;   caught 1 WARNING condition
...
; caught WARNING:
;   undefined variable: LISP-PLUS-FORM2::LAWFUL
;   caught 1 WARNING condition
```

`caught WARNING` blocks: **2** · `undefined variable` lines: **2**

**AFTER** (this erratum) — exit 0, and the command produces **no output at all**:

```text
(empty)
```

`caught WARNING` blocks: **0** · `undefined variable` lines: **0** ·
occurrences of `LISP-PLUS-FORM2::LAWFUL`: **0**

---

## 4. Which counts changed

**None of the pre-existing ones.** Measured on this branch:

| gate | before | after |
|---|---|---|
| `form2-selftest.lisp` | 86 passed / 0 failed | **86 passed / 0 failed** |
| `de-forma-mutata/APPLICATION.lisp` | 43 passed / 0 failed | **43 passed / 0 failed** |
| `de-vadimonio/APPLICATION.lisp` | 117 produced / 0 failed | **117 produced / 0 failed** |
| `run-form2-candidate.sh` | exit 0 | **exit 0**, transcripts rewritten **byte-identically** |
| `check-form2-transcript.sh` | RECONCILIATION CLEAN | **RECONCILIATION CLEAN** |
| `de-vadimonio/check-transcript.sh` | exit 0 | **exit 0** |
| `VERDICT-LIVENESS-SWEEP.sh` | 86/86 forced, 0 survived | **86/86 forced, 0 survived** |
| `mneme/verify-form-floor.sh` | 3 floors, 199 checks, 0 failed | **3 floors, 199 checks, 0 failed** |
| `mneme/verify-language-floor.sh` | 11 floors, 654 checks, 0 failed | **11 floors, 654 checks, 0 failed** |
| Form /2 external symbols | 72 | **72** — census diffed name-by-name, identical |

**One count is new**, and it is a new instrument rather than a changed one:

| new gate | count |
|---|---|
| `SOURCE-HYGIENE-GATE.lisp` | **23 passed / 0 failed** |

No archived transcript was edited to make an old number look unchanged. The candidate runner
regenerated its transcripts on its own and they came back byte-identical, which is the
strongest available evidence that the behaviour did not move.

---

## 5. The gates have teeth — shown, not claimed

A gate that has never fired is untested. Both new gates were made to fail on purpose, in
disposable copies of the tree.

**The load-health gate, against the exact historical defect** (unescaped quotes restored):

```text
form2-selftest: LOAD-HEALTH GATE FAILED — 1 non-style warning(s) while loading form2.lisp.
The allowlist has 0 entries, so none of these was expected.
A green check count below this line would not have been evidence.

  [1] undefined variable: LISP-PLUS-FORM2::LAWFUL

RESULT: FAIL (load-health gate)
EXIT=1
```

— and **no check count printed at all**, because the gate runs before the suite.

The same gate against a freshly planted undefined variable in `%rebuild`: exit 1, names
`LISP-PLUS-FORM2::*%PLANTED-TOOTH-UNDEFINED-VAR*`, no count printed.

**The source-hygiene gate, against the same historical defect:** exit 1, with 7 of its 23
checks failing (H1, H2c, H2d, H2e, H3a, H3b, H3c).

One more piece of evidence found by the gate's own construction: an early draft of
`SOURCE-HYGIENE-GATE.lisp` contained a malformed check (`H4d`) that this builder wrote
incorrectly. The gate failed on it. It was **removed rather than patched into a tautology**,
because a check that cannot fail honestly is worse than no check.

---

## 6. What did NOT change

- Form /2 grammar, policies, constructors, refusal catalog, identity formulas, and resource
  ceilings — untouched.
- Public exports — **72 before, 72 after**, diffed name by name.
- The planted-fault protocol — same names, same `NIL` defaults, same internal status, same
  fixture behaviour, same refusal codes and conditions.
- Every other lane's `.lisp` source — untouched. This branch changes **two** `.lisp` files and
  adds one new gate file, all inside `mneme/language-form-2/`.
- Form /2's standing — **published candidate-by-default**, exactly as the owner ruling of
  2026-07-29 and the 2026-08-02 ruling record it. This erratum confers nothing.
- **The original Integration Baseline /0 return and all its transcripts remain historical
  evidence and were NOT rewritten.** The branch `opus/lisp-plus-integration-baseline-0` is
  untouched at `042cfb29741a311c759b55cb64fcbf3d060d78b6`. Its clean-load transcript still
  shows the two warnings, which is now part of the record of what was found.

---

## 7. Gates run for this erratum

Clean checkout, SBCL 2.4.6/Linux, all from the subject-tree root unless noted.

| # | gate | result |
|---|---|---|
| 1 | raw `form2.lisp` load, stderr captured | **exit 0, zero output** |
| 2 | `form2-selftest.lisp` | **exit 0** — 86/0 |
| 3 | `run-form2-candidate.sh` | **exit 0** — transcripts byte-identical |
| 4 | `check-form2-transcript.sh` | **exit 0** — RECONCILIATION CLEAN |
| 5 | `VERDICT-LIVENESS-SWEEP.sh` | **exit 0** — 86/86 forced, 0 survived |
| 6 | `de-forma-mutata/APPLICATION.lisp` | **exit 0** — 43/0 |
| 7 | `de-vadimonio/APPLICATION.lisp` + `check-transcript.sh` | **exit 0** — 117/0; checker exit 0 |
| 8 | package export census, base vs erratum | **identical**, 72 symbols |
| 9 | static search for an executable unbound `LAWFUL` | **none** — symbol absent from the package; source carries only the escaped form |
| 10 | `verify-form-floor.sh`, `verify-language-floor.sh` | **exit 0** — 199 and 654 checks, unchanged |
| 11 | `SOURCE-HYGIENE-GATE.lisp` (new) | **exit 0** — 23/0 |

---

## 8. Standing

**Nothing in this erratum changes any standing.** It repairs an exhibited lexical defect, an
exhibited declaration-order defect, and the observability hole that let both survive a green
suite. Form /2 is a published candidate-by-default; its stranger audit is **OWED**; the
receipt remains an **ACCOUNT, not an AUTHENTICATION**; and "largest **MEASURED over enumerated
fixtures**" remains the only permitted form of that claim.

This branch is **not merged, not pushed, not tagged, not mirrored, not published**. It is
pending cold review.

*— JOINER (Claude Fable 5), 2026-08-02*
