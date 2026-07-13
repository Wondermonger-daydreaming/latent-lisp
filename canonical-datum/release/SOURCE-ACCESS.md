# CD/0 release differential source-access record

Date: 2026-07-13
Branch/worktree: `cd0-release-runner-stage` at
`/home/gauss/Codex-Lab/latent-lisp-cd0-release-runner`
Task boundary: generated-corpus differential tooling under
`canonical-datum/release/**` only.

## Sources inspected

- `mneme/spec/CANONICAL-DATUM-SPEC.md`: path and SHA-256 were mechanically
  checked.  The runner does not derive codec semantics from an implementation.
- `canonical-datum/generator/README.md` and relevant generator construction,
  schema, mutation, host-scenario, artifact, and manifest code in
  `canonical-datum/generator/generate_corpus.py`.
- `canonical-datum/schema/cd0-fixtures.schema.json` and
  `canonical-datum/vectors/cd0-budgets.json` for fixture/budget validation.
- `canonical-datum/integration/run_differential.py`,
  `canonical-datum/integration/python_adapter.py`, and
  `canonical-datum/integration/common_lisp_adapter.lisp` for the already-agreed
  process protocol and adapter operations.
- A disposable 64-positive/512-negative output from the committed generator to
  inspect actual row, manifest, mutation, retry, and host-scenario shapes.
- Generator v2 correction commit `83517a70df097dea9fad95879ef118986737c7f0`
  (equivalent local cherry-pick `665e16a`) for the exact source-hash,
  worktree-cleanliness, adversarial-count, minimization, retry, and fourteen
  resource-boundary metadata semantics.
- Generator v3 threshold commit `7e4c255acceca346b023a34bc4b7794eeee61fb0`
  (equivalent local cherry-pick `32e2174`) for the independent 20,000
  demonstrated-primary-minimal threshold and 20,308 preferred negative total.
- Git commit/ancestry metadata needed to validate `source_revision`.

No Common Lisp or Python codec source was consulted or copied into this runner.
No v1 kernel source, mneme-canon implementation, claim, warrant, receipt, or
capability representation was inspected.  The runner invokes committed process
adapters and compares their data-only responses symmetrically.

## Authorship and factual boundary

The release runner, tests, and documentation in this directory were authored by
the Codex release-differential agent for this task.  This record describes
source access and intended evidence handling; it is not itself a conformance
result.  The small-corpus verification record is tooling evidence only.  Final
release claims require the separately generated 10,000-positive/20,308-negative
corpus, including 20,000 demonstrated-primary-minimal rows, and its
retained summary/artifacts.
