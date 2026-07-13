# CD/0 Common Lisp integration-fix verification

Verified `2026-07-13` in the isolated
`cd0-integration-common-lisp-fixes` worktree.  This receipt covers the bounded
Common Lisp corrections requested after first differential integration.  It is
not a release-corpus receipt, a specification amendment, or evidence about the
Python implementation.

## Frozen boundary

| Item | Observed value |
|---|---|
| Specification | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Pre-change HEAD | `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` |
| Pre-change tree | `c0cd628095d3eb1e42c526fa5d2b4b7ee8eca6aa` |
| Common Lisp | `SBCL 2.4.6` |
| Python used only by Phase-0 verifier | `Python 3.11.14` |

Only `canonical-datum/common-lisp/**` and this Common-Lisp-specific evidence
file were changed.  The public package exports are unchanged.  A1--A9 remain
the same explicitly non-normative implementation choices; no v1 runtime,
shared fixture, divergence ledger, Python source, claim, warrant, receipt, or
capability representation was edited.

## Proof-carrying obligations

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| R1 | Apply Section 20.5(6) rational numerator magnitude refusal before any denominator defect | `cd0.lisp`, `tests.lisp` | Missing, unterminated, overlong, and varint-limited denominator witnesses; adjacent denominator classifications under a sufficient numerator budget | satisfied | Finite focused cases plus the unchanged shared corpus; not a formal proof over all byte strings |
| R2 | Parse fixture decimal components canonically and within `max_integer_bits` without constructing an input-sized bignum | `cd0.lisp`, `tests.lisp` | `-0` rejected in integer, numerator, and denominator positions; 5,000-digit integer/numerator/denominator inputs refuse as `ResourceRefusal/IntegerBudgetExceeded/host-import` under eight bits | satisfied | Wall-clock/allocation profiling was not used; the loop invariant is supported by direct inspection and boundary tests |
| R3 | Make `equal-datum` independent of host control-stack depth while preserving nine-family structural/type-disjoint semantics | `cd0.lisp`, `tests.lisp` | Existing equality classes/distinct pairs/generated properties; independent 20,000-level equal/unequal permanent witnesses; focused 100,000-level fresh-process witness | satisfied | Host heap remains finite; the explicit worklist can still encounter ordinary allocation refusal outside this non-failing equality API |
| R4 | Preflight applicable host import bounds before avoidable proportional copy/allocation or unreachable traversal | `cd0.lisp`, `tests.lisp` | Aggregate identifier count preempts invalid path segments; record key type preempts hostile value; fixture object schema count is capped; record key-work refusal occurs before key-byte materialization | satisfied | Actual heap exhaustion and concurrent source mutation were not force-injected |
| I1 | Preserve established codec behavior and isolation | README/evidence only beyond implementation/tests | Phase-0 verifier, complete CL suite, ASDF test, direct compile, package diff inspection, `git diff --check` | satisfied | Qualification remains SBCL-only |

## Red witnesses before correction

After adding the permanent regression block but before changing the codec, the
fresh-process suite failed on the first rational witness:

```text
CHECK FAILED: rational numerator budget precedes denominator defect:
"InvalidCanonicalGrammar" differs from "ResourceRefusal"
```

Direct inspection also established that the prior fixture decimal loop built
the complete Common Lisp integer before its budget check, accepted `-0`, and
that `equal-datum` recursively called itself once per nested sequence/record
level.  The importer audit found aggregate path-segment, fixture-object member,
invalid record-key, and record-key-byte materialization checks occurring later
than necessary.

## Exact verification results

`python3 canonical-datum/tools/verify_phase0.py` exited zero:

- pinned specification digest matched;
- 17/17 worked vectors reproduced mechanically;
- five additional positives and all equality/distinct declarations validated;
- 71 negative rows matched the reviewed manifest pin;
- all 256 tag octets were classified and all ten assigned tags exercised;
- the verifier's three deliberate mutation self-tests were rejected.

`sbcl --noinform --disable-debugger --script
canonical-datum/common-lisp/run-tests.lisp` exited zero in a fresh process:

- 22/22 shared positives;
- 71/71 shared negative rows dispositioned, including 66/66 octet rows and
  2/2 applicable host rows;
- 12 shared resource-vector retries and five declared distinct pairs;
- 15 mutation probes, 11 local resource probes, two ambient-state variants,
  500 deterministic generated round trips, and 15 grammar/Unicode boundaries;
- 20 new integration regression witnesses;
- 2,510 assertions total.

Direct `compile-file` checks for `cd0.lisp` and `tests.lisp` both reported
`warnings=NIL` and `failure=NIL`.  ASDF compilation and
`asdf:test-system :lisp-plus-cd0/tests` passed with
`XDG_CACHE_HOME=/tmp/cd0-asdf-fixes-cache`; the first ASDF attempt failed only
because the sandboxed default `$HOME/.cache` was not writable, before any test
ran.  Redirecting generated FASLs to `/tmp` changed no source or test behavior.

The focused higher-depth command constructed independent unary sequence chains
and reported:

```text
deep equality witness: 100000 equal + unequal levels PASS
```

`git diff --check` exited zero.  The implementation/test/README SHA-256 values
at this verification point are:

| File | SHA-256 |
|---|---|
| `canonical-datum/common-lisp/cd0.lisp` | `ceba52459f9a62a594f10e1cbc8e6587915ac88cf01cf945ae210dea56fb4f33` |
| `canonical-datum/common-lisp/tests.lisp` | `6b1041a83a5349251288dd3f22222865a493b3ade7cc6953f850b19550c5d0ae` |
| `canonical-datum/common-lisp/README.md` | `761699b8e315cb717a61d14babff182545f61cd771021d40b93340078d9c713e` |

Commands were run from the worktree root.  The exact primary invocations were:

```text
python3 canonical-datum/tools/verify_phase0.py
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
sbcl --noinform --disable-debugger --load canonical-datum/common-lisp/package.lisp \
  --eval '(multiple-value-bind (output warnings failure) (compile-file "canonical-datum/common-lisp/cd0.lisp" :output-file "/tmp/cd0-integration-cd0.fasl") (format t "cd0 compile: output=~A warnings=~S failure=~S~%" output warnings failure) (when (or warnings failure) (error "cd0 compile was not clean")))' \
  --load /tmp/cd0-integration-cd0.fasl \
  --eval '(multiple-value-bind (output warnings failure) (compile-file "canonical-datum/common-lisp/tests.lisp" :output-file "/tmp/cd0-integration-tests.fasl") (format t "tests compile: output=~A warnings=~S failure=~S~%" output warnings failure) (when (or warnings failure) (error "tests compile was not clean")))' --quit
env XDG_CACHE_HOME=/tmp/cd0-asdf-fixes-cache sbcl --noinform --disable-debugger \
  --eval '(require :asdf)' \
  --eval '(asdf:load-asd (truename "canonical-datum/common-lisp/lisp-plus-cd0.asd"))' \
  --eval '(asdf:test-system :lisp-plus-cd0/tests)' --quit
sbcl --noinform --disable-debugger \
  --load canonical-datum/common-lisp/package.lisp \
  --load canonical-datum/common-lisp/cd0.lisp \
  --eval '(in-package #:lisp-plus-cd0)' \
  --eval '(let ((left (make-unit-datum)) (right (make-unit-datum)) (unequal (make-boolean-datum nil))) (loop repeat 100000 do (setf left (make-sequence-datum (vector left)) right (make-sequence-datum (vector right)) unequal (make-sequence-datum (vector unequal)))) (unless (and (equal-datum left right) (not (equal-datum left unequal))) (error "deep equality witness failed")) (format t "deep equality witness: 100000 equal + unequal levels PASS~%"))' \
  --quit
git diff --check
```

Generated compiler artifacts remained under `/tmp`.

## Classification and remaining boundary

All four corrections are classified as Common Lisp implementation defects,
not specification ambiguities or cross-language imitation.  The rational
ordering follows the per-UVAR precedence already stated in Section 20.5(6),
decimal negative zero follows the canonical integer lexical rule, iterative
equality changes host execution strategy rather than abstract equality, and the
import changes enforce already-declared immutable budgets earlier.

No A1--A9 adjudication was made.  The 11 Phase-0 provisional negative rows are
still compared only on warranted components.  Additional Common Lisp
implementations, generated release-corpus scale, and cross-language
differential convergence remain integration responsibilities outside this
checkpoint.
