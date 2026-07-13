# CD/0 A9 focused two-vector delta receipt

Date: 2026-07-13  
Status: eligible for Fable’s focused two-vector re-verification  
Authority: Fable protocol `49b3cf88`; lab report commit `40462613`

This receipt closes only the evidence-completeness return in §3-A9 of the
targeted report. It does not reopen any adjudication, change codec semantics,
or claim a merge to `main`.

## Authoritative report and pre-change state

The report was read in full before tracked edits. Its retained byte copy has
SHA-256:

```text
67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b
```

The pre-change successor states were clean:

| Branch | Commit | Tree |
|---|---|---|
| `codex/cd0-common-lisp-errata-0.1` | `ee3baa9ab504f65d39015f212050748fd300160a` | `ecf5261c41ad24199325ab56cbf6c39e83cddbc6` |
| `codex/cd0-python-errata-0.1` | `9f46a32351095dc1a52724a31574e0b9e62ed221` | `f065acfe6bb56365946a20e131edcfbf351b06f4` |
| `codex/cd0-integration-errata-0.1` | `851cffc2f0c4799ac8aff9008ddf218bd32255be` | `b08b3b4f36e5ca5b2a2213f41888e80110952c19` |

The old vector SHA-256 was
`55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc`.
It contained 37 promoted operations, including five A9 operations. A structural
query found no `runtime-encode` case combining exactly `seq[Unit]` with either
`max_depth:1` or `max_nodes:1`.

Before adding rows, two requests were sent through each existing generic
adapter. All four responses were successful and encoded exactly
`4c50434400300100`. The retained inputs and outputs are under
`canonical-datum/evidence/a9-two-vector-2026-07-13/prechange/`.

## Exact two rows added

Both rows use operation `runtime-encode`, AST
`{"t":"seq","items":[{"t":"unit"}]}`, budget
`cd0-conformance-default`, status `ok`, and canonical hex
`4c50434400300100`.

| ID | Sole override |
|---|---|
| `cd0-errata-a9-runtime-seq-unit-depth-one` | `{"max_depth":1}` |
| `cd0-errata-a9-runtime-seq-unit-nodes-one` | `{"max_nodes":1}` |

No codec-specific branch or harness special case was added. Both adapters
executed the rows through the existing data-driven errata request path.

## Hash and arithmetic delta

| Quantity | Before | After |
|---|---:|---:|
| vector SHA-256 | `55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc` | `731a74ed61352200d378771f43b747d64bfcc0dea793b116d25b0b888ee11bc3` |
| promoted operations | 37 | 39 |
| A9 operations | 5 | 7 |
| hand requests per codec | 465 | 467 |
| release requests per codec | 100,861 | 100,863 |

The release runner does execute every promoted errata operation. Its actual
post-change arithmetic was:

```text
10,000 positive
+20,308 classified negative
+20,000 equality
+20,012 retries
+30,504 unclassified mutations
+    39 promoted errata
=100,863 requests per implementation
```

## Successor implementation checkpoints

| Branch | Descendant commit | Tree | Parent preserved |
|---|---|---|---|
| Common Lisp | `ddadedf846afb6dff75fb8ffe449a8bbd03231df` | `c6107f2c145d55bbba98b9c432c740088bf2528d` | `ee3baa9a…` |
| Python | `5890235d9456031972b2ee7f40278d653dd1e6ae` | `14478ba84cf9d2ee72d2c9dca3b835087d1ed870` | `9f46a323…` |
| Integration source/count checkpoint | `64988991215939d84517801d049348a3393d04a6` | `1a4c094900a5bc627830986797d77a8073d59a25` | `851cffc2…` |

The later integration evidence-envelope and publication identities are recorded
in the archive and remote read-back receipts because a commit cannot embed its
own identity.

## Commands and observed results

All commands exited `0` unless the explicitly described pre-commit provenance
tripwire is noted.

```text
python3 canonical-datum/tools/verify_phase0.py
  PASS; 71 classified = 66 octet + 5 host;
  Python 71 executed; Common Lisp 68 executed + 3 N/A;
  failures 0; skips 0; promoted operations 39

python3 canonical-datum/integration/run_differential.py --json
  PASS; 467 responses per codec; issues [];
  A1/…/A9 = 6/5/6/3/3/2/1/6/7

sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
  PASS; 2,633 assertions

env PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
  PASS; 167 tests

python3 -m unittest discover -s canonical-datum/generator/tests -v
  PASS; 28 tests

python3 -m unittest discover -s canonical-datum/release/tests -v
  PASS; 9 tests after the source/count checkpoint was committed

python3 -m unittest discover -s canonical-datum/qualification -p test_qualification.py -v
  PASS; 9 tests

python3 canonical-datum/qualification/run_qualification.py --mode default --json
  PASS; property matrix 1,045 requests per codec;
  mutation/inertness probes PASS; warranted disagreements 0

bash mneme/verify-all.sh
  PASS; 6/6 existing-v1 floors
```

The release-runner suite was also intentionally observed before committing the
changed generator: it refused manifests whose `source_revision` did not match
the checked-out generator. After the clean source/count commit, all nine tests
passed. This was a provenance tripwire, not a codec failure.

Two full corpus regenerations used seed `3439329281`, positive count 10,000,
negative count 20,308, mutation sample count 128, truncation maximum 16, and
hash seeds 1 and 777 at the same logical output path. `diff -qr` exited `0`.
All five data members retained their prior SHA-256 values; only the manifest
changed for the new source revision, vector hash, and counts. Corpus digest
remained `62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58`.

The release differential passed 50 batches with zero issues and zero mutation
disagreements. The hand historical comparator reported zero canonical-octet,
normalized-datum, equality, or disposition changes. The 10,000-row protected
projection stayed
`21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.

## Protected result and boundary

```text
canonical-octet drift:        0
normalized abstract drift:    0
equality-class drift:         0
accepted-document drift:      0
wire-grammar drift:           0
codec core changes in delta:  0
adapter semantic changes:     0
v1 changes:                   0
```

The task status is only: **eligible for Fable’s focused two-vector
re-verification**.
