# CD/0 first differential convergence

This directory contains the dependency-light Phase-2 comparison harness.  It
does not define datum semantics.  Both adapters translate the same requests to
the already-complete seed APIs, and the runner derives expectations only from
the pinned specification and shared fixture manifests.

Run from the repository root:

```text
python3 canonical-datum/integration/run_differential.py
```

Add `--json` for a machine-readable summary.  Add
`--artifacts-dir PATH` to retain the exact request JSONL, each process's response
JSONL and stderr, and the summary.  The runner verifies the normative
specification digest before launching a codec.

## Protocol

`lisp-plus-cd0-differential/v1` is a JSON Lines request/response protocol.  One
adapter process consumes one request file and emits exactly one response line
per request.  The runner currently uses these operations:

- `construct-roundtrip`: import a typed fixture AST, encode, decode, export the
  normalized AST, re-encode, and compare the two runtime datums;
- `decode`: exact-decode hostile octets and either return bytes/AST or a typed
  failure;
- `decode-probe`: exact-decode and re-encode without materializing a fixture AST,
  for host-stack regression cases whose successful AST would itself be deeply
  nested JSON;
- `host-import`: invoke only the explicitly named closed fixture importer;
- `equal`: construct two fixture datums and report equality plus both encodings;
- `fixture-import` and `nested-encode`: focused integration-regression probes.

Every request carries a fully resolved immutable fourteen-field budget and a
diagnostic budget ID.  Successful responses use `status: "ok"`.  Codec failures
use `status: "failure"` and the normative `category`, `code`, and `stage`.
Where an optional host importer is not part of a seed's declared API, the
adapter emits `status: "not-applicable"`; it never converts absence into a pass.

The first convergence matrix consists of:

- 22 shared positive rows;
- 71 shared negative rows (66 octet and five host descriptors);
- all 253 unordered-with-reflexivity equality judgments over the 22 positives.

For `provisional-blocked-stage` and `provisional-blocked-code` rows, comparison
is restricted to the fields warranted by the append-only divergence ledger.
An observed match in an unwarranted field does not adjudicate that field.

The Common Lisp adapter reuses the seed test harness's data-only JSON parser;
it does not use the Common Lisp reader on fixture content.  The Python adapter
uses only the standard library.  Neither adapter invokes v1, `mneme-canon/0`, a
profile validator, evaluator transitions, package/symbol mapping, or privileged
restoration.

The runner fixes `PYTHONHASHSEED=137` and starts the Python adapter with
`PYTHONINTMAXSTRDIGITS=640`.  A permanent 641-digit fixture regression proves
that this smallest-over-boundary ambient decimal ceiling does not alter datum
construction, canonical bytes, or fixture export.  These environment settings
are test perturbations, not CD/0 parameters.
