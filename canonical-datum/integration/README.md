# CD/0 Errata 0.1 differential convergence

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

“Independently seeded implementations under shared normative infrastructure, with procedural—not OS-enforced—isolation, attested by the implementers and corroborated at content tier.”

The independence anchors are Common Lisp seed `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3`
and Python seed `58ecca4083275ebfe16605765e575bfb9f6eb755`, not
their audited or corrected branch tips.
Those audited tips contain bounded corrections authored after cross-reading was
authorized and then backported. They remain provenance, not independent-seed
anchors.

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
- `fixture-import` and `nested-encode`: focused integration-regression probes;
- `decode-only`, `fixture-import-only`, `construction-only`, and
  `runtime-encode`: operation-isolated Errata 0.1 probes that do not mask one
  operation with a follow-on operation governed by different budget fields.

Every request carries a fully resolved immutable fourteen-field budget and a
diagnostic budget ID.  Successful responses use `status: "ok"`.  Codec failures
use `status: "failure"` and the normative `category`, `code`, and `stage`.
Where an optional host importer is not part of a seed's declared API, the
adapter emits `status: "not-applicable"`; it never converts absence into a pass.

The Errata 0.1 convergence matrix consists of:

- 25 shared positive rows, including three rational construction descriptors;
- 71 classified negative rows as complete triples;
- all 325 unordered-with-reflexivity equality judgments over the 25 positives;
- 37 permanent operation-sensitive A1--A9 vectors;
- seven historical integration regressions.

Phase-0 accounting remains separate: 71 classified rows are 66 octet rows plus
5 host rows. Python executes 71. Common Lisp executes 68 (66 octet plus 2
applicable host rows) and records 3 language-specific N/A dispositions. N/A
rows are neither passes nor failures. Reports state executed rows, N/A
dispositions, failures, skips, and classified totals independently. The
observed result is 0 failures and 0 skips.

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
