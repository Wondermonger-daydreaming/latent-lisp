# LIMES — front-door purity checker notes

*The border-inspector. Trusts nothing a program claims about itself; reads its
bytes and its live symbols.*

Two instruments, folded into one verdict by `check-front-door.py`:

1. **Byte-level text checks** (Python, `check-front-door.py`) — fast, regex/lexer.
2. **Loader-based external-symbol audit** (`check-external-symbols.lisp`, run as
   an SBCL subprocess) — the robust half: it loads the governed surface and
   reads the target's *actual symbols*, so export status comes from the live
   image, never from a name pattern.

Run:

```sh
python3 check-front-door.py STRANGER-PROGRAM.lisp
```

Verdict lines (always emitted, machine-parseable):

```
HARD-VIOLATIONS: N
HEURISTIC-FLAGS: M
FRONT-DOOR: CLEAN                                     # exit 0, when N == 0
FRONT-DOOR: N hard violation(s), M heuristic flag(s)  # exit 1, when N  > 0
```

Self-test: `bash check-front-door-selftest.sh` (plants one violation per
fixture, asserts each is caught; **7/7 passed**, run transcript in the
implementer's report). A gate that has never fired is untested, not passing.

---

## What each check catches

### Hard (fail the front door — exit 1)

| Check | Fires on | Layer |
|---|---|---|
| `double-colon-access` | `pkg::sym` **in code** (package-internal access) | byte |
| `setf-record-slot` | `(setf (<accessor> …) …)` where `<accessor>` matches a Lisp+/kernel0 record-accessor prefix, with or without a `lisp-plus-slice0:`/`lisp-plus-kernel0:`/`dataset-lab:` qualifier | byte |
| `slot-value` | any `(slot-value …)` form | byte |
| governed **internal-symbol reference** | any read symbol whose home package is `LISP-PLUS-SLICE0`, `LISP-PLUS-KERNEL0`, or `DATASET-LAB` and whose status there is not `:external` | loader audit |
| read error / `symbol-audit-incomplete` | a single-colon reference to a **non-exported** symbol (this is a *reader* error), or any failure to produce a clean audit count — **fails closed** | loader audit |

Record-accessor prefixes used for slot-mutation detection: `claim-`, `witness-`,
`judgment-record-`, `promotion-`, `projection-`, `transmission-`,
`receiver-context-`, `local-value-`, `derived-result-`, `why-`.

### Heuristic (surfaced for the custodian; do **not** fail the gate)

| Check | Fires on | Why heuristic |
|---|---|---|
| `format-nil` / `stringify` | `(format nil …)`, `princ-to-string`, `prin1-to-string`, `write-to-string` | legitimate for messages; a violation only if the string is then handed to `transmit`/`exercise-value` **as** the object — intent the checker cannot read |
| serialization | `sb-ext`, `make-load-form`, `with-output-to-string`, `read-from-string` | classic boundary-bypass primitives; a manual write/read round-trip of a captured host object is a laundering smell, but each has innocent uses |
| `double-colon-in-string/comment` | `::` appearing inside a string literal or `;` comment | `::` is package access only at the *reader* level, i.e. in code; in prose it is text. Flagged only against a later eval-of-a-string. |

The custodian judges every heuristic flag. Hard violations are mechanical.

---

## Why the loader audit is the real teeth

A regex can be fooled by whitespace, line breaks, reader macros, or a `:use`d
package. The loader audit cannot: it loads `../slice0-transmissibility.lisp` and
`task-inputs/validator.lisp`, then `read`s the target form by form with the
governed packages live. For every symbol it walks, `symbol-package` gives the
true home and `find-symbol` gives the true export status **from the image**. It
also `eval`s only the target's `defpackage`/`in-package` forms as it goes, so
unqualified references resolve against the program's own package exactly as a
real load would — catching an internal symbol reached through `:use` that a
qualifier-based regex would miss.

A single-colon reference to a non-exported symbol (`lisp-plus-slice0:notexported`)
is a **reader error** in SBCL; the audit catches it and reports it as an
internal-reference finding — which is precisely the smell being hunted.

The audit runs with `*read-eval* nil` (no `#.` side effects) and `--no-userinit
--no-sysinit` (no host contamination).

---

## What LIMES CANNOT catch (honest limits)

- **`::` inside a string that is later `eval`ed / `read-from-string`ed.** The
  byte layer sees `::`-in-string as text (heuristic, not hard); the loader audit
  reads the *outer* form and never evaluates the program body, so a string
  `"lisp-plus-slice0::%foo"` fed to `eval` at runtime is beyond a static pass.
  Surfaced only via the serialization/stringify heuristics — a human must judge.
- **Runtime laundering in general.** Any violation that only exists when the
  program *runs* (an object stringified then re-parsed, a closure smuggled
  through a data structure the walker treats as inert) is out of scope for a
  static checker. The heuristics point at the primitives; they cannot confirm
  intent.
- **Obfuscated symbol construction.** `(intern "%REQUIRE-PROPOSITION"
  "LISP-PLUS-SLICE0")` builds an internal-symbol reference at *runtime*; the
  static reader never sees a `::` and the audit never sees the symbol as a read
  form. (Present in neither the task's threat model nor a well-formed stranger
  program, but named for completeness.)
- **Semantic misuse of exported symbols.** LIMES certifies the program stayed on
  the *public surface*; it does not check that the ten task steps were performed
  correctly. That is the run transcript's job, not the border inspector's.
- **`#.` read-eval** in the target is disabled during the audit; if a genuine
  clean program relied on it, the form would read-error and be reported. (No
  well-formed Slice /0 program needs it.)
- **Macro-expansion.** The audit walks *source* forms, not macroexpansions. A
  user macro that expands into an internal reference would not be caught unless
  the internal symbol appears literally in the source. (Slice /0 exposes no such
  macro on the public surface.)

The design bias is **fail-closed**: an audit that cannot produce a clean count is
counted as a hard violation, not waved through.

---

## The real internal symbol used for the audit fixture

`lisp-plus-slice0:%require-proposition` — verified live against the loaded
package:

```
%REQUIRE-PROPOSITION => status: INTERNAL, fboundp: #<FUNCTION LISP-PLUS-SLICE0::%REQUIRE-PROPOSITION>
```

It is one of 258 internal symbols (vs. 161 external) in `LISP-PLUS-SLICE0`, found
by loading the surface and diffing `do-symbols` (home-package only) against
`do-external-symbols`. It is a defined helper function (`%`-prefixed by the
implementation's own convention), so it is stable and unambiguously non-exported
— an honest stand-in for "a stranger reached past the front door." The audit
fixture references it via `::` (the only textual way to reach an internal
symbol) and the loader audit reports:

```
;   INTERNAL-REF  LISP-PLUS-SLICE0:%REQUIRE-PROPOSITION  [home LISP-PLUS-SLICE0, status INTERNAL]
EXTERNAL-SYMBOL-AUDIT: 1 internal-symbol reference(s)
```

---

## Files

- `check-front-door.py` — the combined checker (Python 3, stdlib only).
- `check-external-symbols.lisp` — the loader-based audit (package
  `check-external-symbols`, export `audit`).
- `check-front-door-selftest.sh` — the teeth; regenerates `_selftest-fixtures/`
  on each run and asserts every check fires.

*— LIMES, Claude Opus 4.8 (1M context), 2026-07-23*
