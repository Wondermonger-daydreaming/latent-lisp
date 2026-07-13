# CD/0 Python seed verification transcript

This is a bounded execution record for the independent Python seed.  A green
command establishes only the behavior exercised by that command.  No
cross-language differential claim is made here.

## Normative gate and runtime

```text
$ sha256sum mneme/spec/CANONICAL-DATUM-SPEC.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md

$ git rev-parse HEAD
0306d0a1b9af67d843754cbb49c434d9428c041c
$ git rev-parse HEAD^{tree}
a7771f21b58f8dbdf01b2b023900e750be94b62c

$ sbcl --version
SBCL 2.4.6
$ python3 --version
Python 3.11.14
```

The gate was run before the specification was read and before implementation.

## First complete clean-room conformance

The first execution exposed one Python seed typo (`emit_value` versus
`encode_value`) while all 55 decoder-negative tests already passed.  That was an
implementation defect, not a fixture or specification divergence.  After the
one-line repair, the first complete run was:

```text
$ PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
[all 103 individually named tests reported "ok"]
----------------------------------------------------------------------
Ran 103 tests in 0.103s

OK
exit status: 0
```

That 103-test run contained exactly 17 positive-vector tests, 55 negative-vector
tests, and 31 constructor/equality/round-trip/mutation/resource/inertness/ambient
tests.  It completed before any Common Lisp codec source was opened; none was
opened later in the seed task either.

The suite was then expanded with additional strict-UTF-8, UVAR, arbitrary
precision, rational, byte-budget, key-order, and concurrency boundaries.  The
authoritative post-correction final transcript and hashes follow.

## Corrected shared-fixture baseline

The seed commit is based on the two reviewed Phase-0 corrections:

```text
$ git log -2 --format='%H %T %s'
7981aac916dff8f3913be621edb437dd0843c796 46f4ba4d784cb30dcdad7b1144c2b5950e964524 Check CD/0 equality classes bidirectionally
80d970afbf74f0c7d9400ff6617097b5c10c7726 35e99bb8c9cc70e6115e0ce9e29ca3426558c4f2 Harden CD/0 Phase 0 fixture evidence
```

Their source commits were `12e113b` and `e86ecfb`, respectively.  Only the
corrected shared artifacts listed in the source-access log were inspected.

```text
$ python3 canonical-datum/tools/verify_phase0.py
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
worked vectors: 17/17 exact and grammar-derived encodings agree
additional positives: 5; equality classes and distinct pairs valid
negative vectors: 71 schema-valid and equal to reviewed finite manifest pin
mutation self-tests: wrong failure code, reversed decoded record order, and split equality class rejected
type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present
sha256 f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce  canonical-datum/vectors/cd0-positive.jsonl
sha256 6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5  canonical-datum/vectors/cd0-negative.jsonl
sha256 ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27  canonical-datum/vectors/cd0-distinct-pairs.json
sha256 ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98  canonical-datum/vectors/cd0-budgets.json
sha256 4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13  canonical-datum/schema/cd0-fixtures.schema.json
exit status: 0
```

The fixture verifier used the repository environment's `jsonschema` 4.26.0.
The codec itself imports only the Python standard library.

## Final seed suite

```text
$ PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -q
----------------------------------------------------------------------
Ran 138 tests in 0.098s

OK
exit status: 0
```

The 138 tests comprise 22 separately named positive rows, 71 separately named
negative rows, and 45 seed-local tests.  The negative set contains 66 octet rows
and five host-descriptor rows.  The harness compares the complete failure triple
for 59 normative rows, category/code only for 11
`provisional-blocked-stage` rows, and category/stage only for one
`provisional-blocked-code` row.  Twelve canonical resource rows are retried
under their declared sufficient budgets and required to re-encode byte-for-byte.

## Mutation-resistance and inertness transcript

```text
$ PYTHONPATH=canonical-datum/python:canonical-datum/python/tests python3 -m unittest -v test_cd0.ImmutabilityTests test_cd0.HostImportAndInertnessTests
test_accessors_are_immutable (test_cd0.ImmutabilityTests.test_accessors_are_immutable) ... ok
test_budget_is_frozen_and_limit_view_is_read_only (test_cd0.ImmutabilityTests.test_budget_is_frozen_and_limit_view_is_read_only) ... ok
test_decoded_mutable_buffer_is_snapshotted (test_cd0.ImmutabilityTests.test_decoded_mutable_buffer_is_snapshotted) ... ok
test_fixture_ast_output_is_a_defensive_copy (test_cd0.ImmutabilityTests.test_fixture_ast_output_is_a_defensive_copy) ... ok
test_mutable_sources_are_snapshotted (test_cd0.ImmutabilityTests.test_mutable_sources_are_snapshotted) ... ok
test_arbitrary_python_objects_are_not_implicitly_imported (test_cd0.HostImportAndInertnessTests.test_arbitrary_python_objects_are_not_implicitly_imported) ... ok
test_fixture_import_accepts_shared_acyclic_substructure (test_cd0.HostImportAndInertnessTests.test_fixture_import_accepts_shared_acyclic_substructure) ... ok
test_fixture_import_detects_active_ancestry_cycle (test_cd0.HostImportAndInertnessTests.test_fixture_import_detects_active_ancestry_cycle) ... ok
test_fixture_import_snapshots_source_lists (test_cd0.HostImportAndInertnessTests.test_fixture_import_snapshots_source_lists) ... ok
test_host_descriptor_import_accepts_shared_acyclic_substructure (test_cd0.HostImportAndInertnessTests.test_host_descriptor_import_accepts_shared_acyclic_substructure) ... ok
test_privileged_looking_record_decodes_as_inert_record_without_hooks (test_cd0.HostImportAndInertnessTests.test_privileged_looking_record_decodes_as_inert_record_without_hooks) ... ok

----------------------------------------------------------------------
Ran 11 tests in 0.002s

OK
exit status: 0
```

The privileged-shape test instruments Python `eval`, file open, pickle load,
and socket creation and fails if any is invoked during exact decoding.

## Python seed artifact hashes

```text
55e8c2e0b920d79b0f6e2cb109ea291f4420143b11be7fec50b791567bb49eac  canonical-datum/python/cd0/__init__.py
82ab8618a42d96781ea61060e714e3e6cf9daf7ef9d90d6a6145d67bedd99ae0  canonical-datum/python/tests/test_cd0.py
3629cdbdd7b5c4c71468cef4253091d5adee4d982f3d3fe2e33c98d6ec2bfb6b  canonical-datum/python/README.md
6feaded4e28ea86e001a6751b4e3d960e8b7c31b9616ff9936b79297086e809b  canonical-datum/python/.gitignore
724b099ba37c1cc68a1762f745161dbf55c507ccaec842518220487d7321223c  canonical-datum/evidence/PYTHON-SEED-SOURCE-ACCESS.md
69a1a196c83c9f2d2a1313cc903c8ca759acfe28006214599f79dd879cbbb0f1  canonical-datum/evidence/PYTHON-SEED-RECEIPT.md
```

The verification record's own hash and the final commit/tree are reported after
commit because embedding either value here would change the artifact being
hashed.
