# CD/0 integration source-access transition

This log records the transition from the two procedural clean-room seed phases
to the authorized differential-integration phase.  It is an auditable source
access record, not an operating-system information-flow proof.

## Gate and imported checkpoints

At integration start on `2026-07-13` in
`/home/gauss/Codex-Lab/latent-lisp-cd0-integration`, the recorded state was:

| Item | Value |
|---|---|
| Branch | `cd0-integration` |
| Specification path | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Integration pre-change HEAD | `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` |
| Integration pre-change tree | `c0cd628095d3eb1e42c526fa5d2b4b7ee8eca6aa` |
| Common Lisp runtime | `SBCL 2.4.6` |
| Python runtime | `Python 3.11.14` |

The specification digest matched before integration edits.  The seed commits
already existed and integration had been explicitly authorized:

| Seed | Original commit | Original tree | Integrated commit | Integrated tree |
|---|---|---|---|---|
| Common Lisp | `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3` | `ee168b0ec3f5fb0b6501e773e318974d014cd9df` | same commit | same tree |
| Python | `58ecca4083275ebfe16605765e575bfb9f6eb755` | `331e8c83d683523381301a51de680f71b758026b` | `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` (cherry-pick) | `c0cd628095d3eb1e42c526fa5d2b4b7ee8eca6aa` |

The different Python integration commit ID reflects its new parent; the seed
patch was imported after the Common Lisp seed commit.  This table does not
claim the whole integrated tree equals either single seed tree.

## Transition order

The integration agent first verified the specification digest and recorded the
repository/runtime state.  Before reading either codec implementation body, it
ran both complete seed commands in fresh processes:

```text
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
```

They exited zero with the imported seed results: 2,453 Common Lisp assertions
and 138 Python tests.  Package exports, seed READMEs, seed receipts, and
source-access logs were inspected around this transition; the actual codec
implementation bodies were not compared until after both commands completed.

After that gate, procedural isolation intentionally ended.  The integration
agent and review agents were allowed to inspect both implementations, compare
behavior, minimize disagreements, and derive repairs from the specification.

## Normative and fixture sources inspected

- `mneme/spec/CANONICAL-DATUM-SPEC.md` (all 2,276 lines, with overlapping
  chunk reads where command output was capped);
- `CANONICAL-DATUM-DIVERGENCES.md`;
- `canonical-datum/schema/cd0-fixtures.schema.json`;
- all four shared vector/budget manifests under `canonical-datum/vectors/`;
- `canonical-datum/tools/verify_phase0.py`;
- the Phase-0 correction/source-access/verification evidence;
- both seed source-access, verification, and receipt documents.

## Implementation sources inspected after the transition

Common Lisp:

- `canonical-datum/common-lisp/package.lisp`;
- `canonical-datum/common-lisp/cd0.lisp`;
- `canonical-datum/common-lisp/tests.lisp`;
- `canonical-datum/common-lisp/run-tests.lisp`;
- `canonical-datum/common-lisp/lisp-plus-cd0.asd`;
- `canonical-datum/common-lisp/README.md`.

Python:

- `canonical-datum/python/cd0/__init__.py`;
- `canonical-datum/python/tests/test_cd0.py`;
- `canonical-datum/python/README.md`;
- `canonical-datum/python/.gitignore`.

Integration-authored files were inspected repeatedly while being written:

- `canonical-datum/integration/common_lisp_adapter.lisp`;
- `canonical-datum/integration/python_adapter.py`;
- `canonical-datum/integration/run_differential.py`;
- `canonical-datum/integration/cases/cd0-integration-regressions.json`;
- `canonical-datum/integration/README.md`;
- this source-access log and the integration verification evidence.

The proof-carrying-change skill was read as process guidance.  It supplied no
datum semantics.

## Sources deliberately not used as semantic authority

The integration implementation and repairs did not derive datum semantics from
the v1 kernel, `mneme-canon/0`, Common Lisp package/symbol identity, SBCL
printing, Python equality, or claim/warrant/receipt/capability representations.
Repository-wide filename discovery occurred, but unrelated implementations were
not opened as codec oracles.  Review findings were accepted only after checking
the pinned specification or the shared fixture schema.

## Boundary after transition

Cross-reading in this phase cannot retroactively weaken the seed isolation
receipts: both first complete seed suites and both seed commits existed before
comparison.  Conversely, changes made after this transition are integration
repairs, not independent clean-room seed evidence.  Their commit ancestry and
verification are recorded separately.
