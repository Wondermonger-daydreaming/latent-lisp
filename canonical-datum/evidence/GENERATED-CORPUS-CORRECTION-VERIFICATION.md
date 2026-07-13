# CD/0 generated-corpus rigor correction

Date: 2026-07-13 (America/Sao_Paulo)

## Checkpoint and scope

This correction began from clean commit
`cb743ac699fc23b986b73e8acafdf374121fd5b2`, tree
`4cfcbcdbdcf5351411880b3006b5225c193f5b36`.  Before edits, the pinned
specification digest was
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.
Selected source-input hashes captured at that checkpoint were:

- divergence ledger: `4f0a6c7d579e21bcda895eea3409800479511b6ef0e1bc1238ed2d3852fe1c66`;
- fixture schema: `4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13`;
- budgets: `ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98`;
- hand positives: `f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce`;
- hand negatives: `6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5`;
- Python seed codec: `55e8c2e0b920d79b0f6e2cb109ea291f4420143b11be7fec50b791567bb49eac`;
- generator v1 source: `acd817a3f70251637ba718b31cef35303b04d36b1dab1735131fd108d6523905`;
- generator v1 tests: `8d62533e8502c2be19def9de64b718d3ae3cee8869431faa09e39d7ea975b6a2`.

Only generator source/tests/documentation and this evidence note changed.  No
codec, integration runner, normative specification, divergence ledger, or v1
runtime file was edited.  No 10,000/20,000 bulk corpus was generated here.

## Correction receipt

| ID | Obligation | Implementation/evidence | Status | Residual boundary |
|---|---|---|---|---|
| C1 | Replace arbitrary padding with compact primary-defect-minimal adversarial rows | canonical two-byte Bytes documents are nine octets under complete inline `max_input_octets=8`; derivations prove every one-byte deletion removes only that primary failure | satisfied in small generation | “minimal” is scoped to byte-deletion removal of the primary input-length defect, not global semantics |
| C2 | Make every retry executable | generator decodes under `retry_budget` and re-encodes identical bytes before accepting a row; tests repeat this independently | satisfied | later Common Lisp retry agreement remains pending |
| C3 | Preserve deletion provenance and omit no-ops | mutation dedup includes canonicalized parameter; tests compare every sampled position/suffix and require source/input inequality | satisfied | broad candidates remain intentionally unclassified |
| C4 | Separate normative/provisional counts and preserve A1--A9 | manifest status counts; identifier resource stages, depth/node stages, bool code, A3/A8/A9 metadata are explicitly provisional or implementation-local | satisfied | adjudication remains outside this task |
| C5 | Make invocation/source provenance replayable and drift-sensitive | exact interpreter + `sys.argv[0:]`, cwd, revision, clean/override state, and before/after source hashes are recorded and tested | satisfied | external environment/dependency hashes remain part of the integration ledger |
| C6 | Require clean release source and transactionally publish | dirty override is small-mode-only; sibling staging is atomically renamed and cleaned on injected failure; concurrent source drift refuses | satisfied for tested filesystem | atomic directory rename assumes one filesystem; a narrow destination-creation race is guarded by a final existence check |
| C7 | Strengthen semantic metadata | five explicit identifier distinction pairs; 14 complete resource-boundary scenario descriptors; host/resource scenarios marked `not-executed-by-generator` | satisfied as metadata | execution is owned by separately retained Phase-4 evidence and is not asserted here; A3 integer limits are explicitly Python-seed-local and unexecuted |
| C8 | Preserve integration boundary | manifest/docs state generated host rows need later Common Lisp/Python adapter support | satisfied | integration runner was deliberately not edited here |

## Verification

Environment: CPython 3.11.14.  The source-only tests use
`--allow-small --allow-dirty-source`; that override is recorded and cannot be
used in release mode.

```text
python3 -m py_compile canonical-datum/generator/generate_corpus.py
```

Exit 0.

```text
python3 canonical-datum/tools/verify_phase0.py
```

Exit 0: the pinned specification, 17 worked vectors, five additional hand
positives, 71 hand negatives, all 256 tag classifications, and fixture hashes
remained unchanged.

```text
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

Exit 0: 25 tests passed.  Each suite run internally generated and byte-compared
the same 384-positive/640-adversarial small corpus under `PYTHONHASHSEED=1` and
`777`.  The tests cover shared schema validity, retry success, scoped
minimization proofs, normative/provisional counts, every sampled deletion
position and suffix, no-op exclusion, semantic identifier pairs, all fourteen
resource descriptors, exact invocation/source hashes, dirty-source refusal,
source-drift refusal, atomic cleanup, and artifact/corpus digests.

The full test command is run twice before this correction is committed.  A green
small run remains finite generator evidence, not the release corpus or final
cross-implementation conformance result.
