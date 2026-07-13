# CD/0 Python seed implementation receipt

This receipt describes finite evidence for the independent CPython seed.  It is
not a differential Common Lisp/Python result and does not claim formal proof.

## Obligation ledger

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| R1 | Use exactly the pinned normative bytes and preserve clean-room isolation | source-access log | SHA-256 gate, Git/runtime metadata, enumerated access log | satisfied | procedural isolation, not OS-enforced information flow |
| R2 | Represent all nine families as disjoint immutable runtime values | `cd0/__init__.py` | constructor, disjointness, bool/int, frozen-view, and mutable-source tests | satisfied | hostile same-process reflection is outside the ordinary API guarantee |
| R3 | Implement abstract equality and exact canonical encoding/decoding | `cd0/__init__.py` | 17 worked plus 5 boundary/order positives, equality classes, distinct pairs, round trips, numeric/Unicode boundary tests | satisfied | finite corpus; generated Phase-3 corpus not yet run |
| R4 | Enforce canonical grammar and deterministic typed failures | decoder and `CD0Failure` | all 71 shared negative rows as separate unittests; provisional fields compared only to their warranted scope | satisfied for normative fields | A1--A6 retain documented local choices |
| R5 | Enforce explicit immutable resource budgets and atomic refusal | `ResourceBudget`, encoder/decoder/importer counters | input/output/varint/integer/depth/node/count/segment/payload/key-work refusal and retry tests | satisfied within tested boundaries | A3--A5, A8--A9 remain unadjudicated |
| R6 | Convert to/from the shared fixture AST and closed host descriptors without implicit host semantics | fixture importer/exporter and named host-descriptor adapter | every positive vector, all five negative host rows, cycle/shared-acyclic, snapshot, malformed-host tests | satisfied | A2 and A7 remain local choices; adapter is not generic deserialization |
| R7 | Resist mutable aliases and keep decoded records inert | frozen nodes, dedicated parser | bytearray/memoryview/list/record/AST mutation probes; privileged-shape instrumentation | satisfied within Python process probes | no claim that inert contents are trustworthy |
| R8 | Remain invariant across Python ambient state and processes | canonical record ordering | two hash seeds/processes, source/dict order, 128 concurrent encodes | satisfied within tested runtimes | only CPython 3.11.14 was executed |
| I1 | Leave existing v1 runtime and semantics untouched | only `canonical-datum/python` and Python evidence paths | Git changed-path audit | satisfied | integration must preserve this boundary |
| I2 | Do not compare or imitate the Common Lisp implementation | source-access log | no Common Lisp source opened; first green run preceded any integration | satisfied | differential comparison deliberately deferred |

## Implementation-local representation choices

- Frozen slotted dataclasses represent the nine nominal families.
- Python `str`, `bytes`, and tuples provide immutable leaves/views.
- Records retain a tuple of `(Identifier, Datum)` pairs in canonical key order.
- No canonical-byte cache is retained, so there is no cache invalidation path.
- Exact decoding eagerly validates and materializes the complete datum.
- Failure transport is a `CD0Failure` exception whose `triple` property is the
  shared `(category, code, stage)` comparison value.

The non-normative A1--A9 choices are listed in
`canonical-datum/python/README.md`; they do not amend the root divergence
ledger.

## Not executed in this seed

- no Common Lisp/Python differential run;
- no generated 10,000-positive/20,000-negative release corpus;
- no additional Common Lisp or Python implementation versions;
- no v1 migration;
- no changes to claim, warrant, capability, receipt, Language-A, identity,
  cryptography, module, or procedure semantics;
- no remote push.

Exact commands, observed summaries, artifact hashes, and the seed commit/tree
are recorded in `PYTHON-SEED-VERIFICATION.md` after the final clean run.
