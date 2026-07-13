# CD/0 Common Lisp seed verification

Verified `2026-07-13` in the isolated `cd0-common-lisp` worktree.  This receipt
covers only the independent Common Lisp seed; it is not differential or release
corpus evidence.

## Frozen input and environment

| Item | Value |
|---|---|
| Specification | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Pre-change HEAD | `520034e9dd60dc1ea92cbd5d2e9d7a4f289d2a26` |
| Pre-change tree | `a7771f21b58f8dbdf01b2b023900e750be94b62c` |
| Shared-fixture HEAD at final run | `7e7d8ae` |
| Common Lisp | `SBCL 2.4.6` |
| Python used for fixture verifier only | `Python 3.11.14` |

The specification digest matched before implementation.  The full clean-room
boundary and exact inspected-source list are in
`COMMON-LISP-SEED-SOURCE-ACCESS.md`.

## Requirement-to-evidence map

| Obligation | Implementation/evidence |
|---|---|
| Nine disjoint datum families | Private node classes and explicit constructors; positive, equality-class, distinct-pair, and generated tests |
| Structural equality | `equal-datum`; equality classes, distinct pairs, and equality/encoding equivalence checks |
| Exact canonical codec | `encode-exact` and `decode-exact`; all worked vectors, exact round trips, trailing/noncanonical refusal |
| Immutable views and aliases | Private storage, `octet-string`, defensive accessors; 15 mutation probes |
| Explicit immutable budgets | `resource-budget`; 11 local refusal/retry probes plus 12 successful shared-vector retries |
| Typed failures | `cd0-failure`; shared category/code/stage checks with provisional components explicitly excluded |
| Fixture AST conversion | `datum-from-fixture-ast` and `datum-to-fixture-ast`; all shared positives and generated round trips |
| Strict UTF-8 and records | Shared hostile rows and 15 grammar/Unicode boundary cases |
| Inert privileged-looking data | Decoder exposes no evaluator, registry, package, symbol, capability, or I/O transition; inert-record instrumentation tests |
| Ambient-host invariance | Printer/package/readtable perturbation tests in two variants |
| Existing v1 untouched | All seed changes are confined to `canonical-datum/common-lisp/` and Common Lisp evidence files |

## Exact verification results

`python3 canonical-datum/tools/verify_phase0.py` passed:

- specification digest matched;
- 17/17 worked vectors mechanically reproduced;
- five additional positives, equality classes, and distinct pairs validated;
- 71 negative rows matched the reviewed finite manifest;
- all 256 tags were classified and all ten assigned tags exercised;
- verifier mutation self-tests rejected deliberately corrupted results.

`sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp`
passed in two separate fresh processes with identical summaries:

- 22/22 shared positives;
- 71/71 shared negative rows dispositioned;
- 66/66 octet negatives and 2/2 applicable host negatives executed;
- three optional host importers not exposed and therefore not counted as passes;
- 11 provisional rows compared only on components warranted by Phase 0;
- 12 shared resource-vector canonical retries;
- five declared distinct pairs;
- 15 mutation probes, 11 local resource refusal/retry probes, two ambient-state
  variants, 500 deterministic generated round trips, and 15 grammar/Unicode
  boundary cases;
- 2,453 assertions total.

Direct `compile-file` checks reported `warnings=NIL` and `failure=NIL` for both
the codec and tests.  The ASDF test system also passed with
`XDG_CACHE_HOME=/tmp/cd0-asdf-cache`; redirecting the cache was necessary because
the sandbox makes the ordinary user cache read-only.  `git diff --check` passed.

## Boundaries and residual uncertainty

- A1--A9 remain specification ambiguities.  The implementation-local choices
  are listed in the README and do not amend the normative document.
- Eleven hostile-vector stages are Phase-0 provisional, so this seed asserts
  only their normative category and code.  No precise stage is claimed.
- The exposed Common Lisp API has no generic symbol importer, Python-bool
  importer, or live-capability importer.  The three corresponding descriptors
  are honestly marked not applicable.  Cyclic fixture AST and improper host
  sequence inputs are exercised.
- Qualification is on SBCL 2.4.6.  No CCL, ECL, CLISP, or Roswell executable was
  available; portability has not been weakened or inferred.
- Actual heap exhaustion and concurrent mutation during snapshotting were not
  force-injected.  Allocation conditions are translated, declared sizes are
  preflighted, and ordinary mutable-alias probes pass.
- Differential convergence, the 10,000/20,000 release corpus, multi-process
  cross-language comparison, and later hostile/property phases remain integration
  work.  This receipt makes no claim about them.
