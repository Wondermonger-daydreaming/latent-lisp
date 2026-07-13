# CD/0 Python integration-hardening verification

This is a bounded execution record for the Python-specific repair based on seed
integration commit `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad`.  It records
finite evidence, not formal proof and not a Common Lisp/Python differential
conformance result.

## Normative and scope gate

```text
$ sha256sum mneme/spec/CANONICAL-DATUM-SPEC.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md

$ git rev-parse 9745bb1
9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad
$ git rev-parse 9745bb1^{tree}
c0cd628095d3eb1e42c526fa5d2b4b7ee8eca6aa

$ python3 --version
Python 3.11.14
```

The specification digest matched before repair work.  The changed surface is
limited to `canonical-datum/python/**` and this Python-specific evidence file.
No v1 runtime, normative vector, root divergence ledger, Common Lisp source, or
normative specification artifact was edited.

## Obligation receipt

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| P1 | Public recursive operations never leak Python `RecursionError` | `cd0/__init__.py`, `HostStackSafetyTests` | depth-1500 decode/encode/fixture/descriptor/diagnostic witnesses under a semantically permitting budget and forced low host stack | satisfied for named Python entry points | recursive codec internals still use the host stack and may refuse a semantically permitted value as host allocation pressure |
| P2 | Datum equality and required fixture export remain safe at deep nesting | iterative `equal_datum`, iterative `to_fixture_ast` | equal/distinct depth-1500 values under recursion limit 100; depth-1500 AST export and iterative inspection | satisfied within tested depth | worklists can still encounter real host allocation failure |
| P3 | Fixture decimal identity is independent of Python's ambient decimal digit guard | manual bounded parser and formatter; `DecimalGuardTests` | local and child-process guard 640 with 1,000-digit integer/rational; 5,000-digit budget refusal; `-0` rejection | satisfied for fixture integers, rational components, descriptor integers, AST export, and diagnostics | only CPython 3.11.14 was executed; A2 still leaves constructor/import failure code assignment non-normative |
| P4 | Declared host sizes are checked before proportional conversion or copying | fixture/descriptor hex import and list/tuple preflights; `HostImportPreallocationTests` | monkeypatched conversion allocation point proves it is not called after oversized declaration; zero container/segment budgets refuse first | satisfied for explicit fixture/descriptor paths | caller has already allocated the source JSON/Python objects; no claim about generic JSON parser allocation |
| P5 | Preserve the seed's documented A1--A9 choices, especially divergent A9 | Python README and unchanged encoder budget behavior test | full suite retains `test_runtime_encoder_uses_only_output_and_key_work_limits`; changed-path and divergence review | satisfied | A1--A9 remain pending specification adjudication |
| I1 | Preserve canonical behavior, mutation resistance, and inert decoding | codec plus permanent regression tests | Phase-0 verifier, all 152 Python tests, dedicated 11-test mutation/inertness run | satisfied within finite corpus | generated release corpus and integration differential evidence are separate workstreams |

The typed host-stack outcome is
`ResourceRefusal/AllocationRefused/allocation`.  The bounded decimal outcome is
`ResourceRefusal/IntegerBudgetExceeded/host-import`.  Fixture `-0` is rejected
as `UnsupportedHostInput/UnsupportedHostType/host-import`; that exact host code
remains an A2 implementation-local choice.  Oversized fixture hex is rejected
as `ResourceRefusal/ExcessiveDeclaredLength/host-import` before byte conversion.

## Phase-0 verifier

```text
$ python3 canonical-datum/tools/verify_phase0.py
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
worked vectors: 17/17 exact and grammar-derived encodings agree
additional positives: 5; equality classes and distinct pairs valid
negative vectors: 71 schema-valid and equal to reviewed finite manifest pin
mutation self-tests: wrong failure code, reversed decoded record order, and split equality class rejected
type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present
exit status: 0
```

## Focused hostile-host transcript

```text
$ PYTHONPATH=canonical-datum/python:canonical-datum/python/tests python3 -m unittest -v test_cd0.HostStackSafetyTests test_cd0.DecimalGuardTests test_cd0.HostImportPreallocationTests
[14 individually named tests reported "ok"]
----------------------------------------------------------------------
Ran 14 tests in 0.065s

OK
exit status: 0
```

This run includes the exact deep decode shape
`b"LPCD\x00" + b"\x30\x01" * 1500 + b"\x00"`, with a budget whose
`max_depth` and `max_nodes` both permit the abstract value.  It also includes
local and child-process `sys.set_int_max_str_digits(640)` probes and conversion
hooks that raise if oversized fixture hex reaches `bytes.fromhex`.

## Full Python conformance transcript

```text
$ PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
[all 152 individually named tests reported "ok"]
----------------------------------------------------------------------
Ran 152 tests in 0.181s

OK
exit status: 0
```

The 152 tests comprise 22 shared positive rows, 71 shared negative rows, and 59
Python-local tests.  Shared provisional fields remain compared only to their
warranted A1/A2 scope; the hardening tests do not silently promote them to
normative triples.

## Mutation resistance and inertness

```text
$ PYTHONPATH=canonical-datum/python:canonical-datum/python/tests python3 -m unittest -v test_cd0.ImmutabilityTests test_cd0.HostImportAndInertnessTests
[all 11 individually named tests reported "ok"]
----------------------------------------------------------------------
Ran 11 tests in 0.003s

OK
exit status: 0
```

The inert-record probe instruments `eval`, file opening, pickle loading, and
socket creation.  The mutation probes cover bytearray/memoryview/list/record/AST
aliases and frozen accessors.  A green result does not assert that inert record
contents are truthful, authoritative, authenticated, or safe to trust.

## Python artifact hashes

```text
f821934129779dab0908134377b9a81b2ab33f1fd995fd2451031b5bc0e99fba  canonical-datum/python/cd0/__init__.py
97800a38c8c2ad5829d943eca135e89113c057d6543290e8a25fdac36619a5de  canonical-datum/python/tests/test_cd0.py
b53fdcdd6afb1bfa6ca8cf7a8588c3e8ca34036ce8c39b39736f302662663644  canonical-datum/python/README.md
```

The evidence file's own digest is reported by the handoff to avoid a
self-referential hash.

## Explicit non-results

- This repair did not adjudicate or close divergence A1--A9.
- It did not make Python imitate the Common Lisp seed's A9 budget choice.
- It did not run or amend the integration differential runner or divergence
  ledger; those belong to the integration owner.
- It did not generate or claim the 10,000-positive/20,000-negative release
  corpus.
- It did not test another Python implementation/version or operating system.
- It did not modify or migrate v1, claims, warrants, capabilities, receipts,
  Language A, cryptography, module identity, or procedure identity.
- It did not push any remote branch.

The final fix commit and tree are intentionally reported by Git and the handoff
rather than embedded here: embedding either in a tracked file would change the
very commit/tree being named.
