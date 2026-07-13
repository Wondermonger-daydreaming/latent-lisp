# CD/0 generated-corpus differential runner

`run_generated_differential.py` is the Phase-3 release-corpus coordinator for
Lisp+ Canonical Datum /0.  It sends the same requests to the independent Common
Lisp and Python process adapters.  It is not a codec, does not infer datum
semantics, and does not treat either implementation as an oracle.

## Release invocation

Generate the corpus from a committed generator revision first.  Then run:

```sh
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir canonical-datum/generated/release-v0 \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir canonical-datum/evidence/generated-differential-release-v0
```

The runner refuses before launching either codec unless all of these agree:

- the repository specification has the required pinned SHA-256;
- the manifest schema, generator version, specification pin, source commit,
  source ancestry, and checked-out generator bytes;
- identical before/after SHA-256 maps for all nine relevant source inputs, with
  every recorded digest matching the checked-out path;
- a clean source worktree with no dirty override for release-mode generation;
- logical command, seed, runtime, release-mode, count, and threshold metadata;
- every artifact's exact size, row count, and SHA-256;
- the manifest's aggregate corpus digest.

`--allow-small-corpus` permits a generator test-mode corpus.  It is for tests
only and the summary records that the run is not release-qualified.

## Comparisons

The runner streams requests in bounded batches and applies the same budget to
both isolated adapter processes.  For every generated positive it checks
canonical bytes, normalized fixture AST, decode/re-encode, and constructed vs.
decoded equality.  A deterministic self-plus-ring-neighbor matrix checks both
equality directions and `equal-datum` iff identical canonical bytes without
constructing a quadratic request matrix.

Every classified negative is checked only on normatively warranted fields:

- normative rows: category, code, and stage;
- `provisional-blocked-stage`: category and code;
- `provisional-blocked-code`: category and stage.

Every `retry_budget` produces an additional full decode request.  Success must
reproduce the original canonical document exactly, render a normalized fixture
AST in both codecs, and agree cross-codec on that AST.

Mutation candidates remain unclassified.  Both-success is accepted only when
both normalized ASTs and canonical results agree **and** the canonical bytes
are exactly the candidate input.  Symmetric acceptance that normalizes to
different bytes is a conformance/minimization issue, not a pass.  Both-failure
is accepted only when the complete failure triples agree.  Mixed outcomes or
different triples are recorded by original case id and input digest as
`minimization required`; the runner never assigns an expected primary defect.

## Host applicability boundary

The two language-neutral cycle/improper-list rows execute in both codecs.  The
three optional or language-specific importers are deliberately recorded as
Common Lisp N/A, not pass:

- `symbol-to-identifier/v0`;
- `strict-integer-import/v0`;
- `core-datum-import/v0`.

The nine generated host-property scenarios are also dispositioned explicitly.
Only the two equivalent classified host negatives count as exercised here.
Inertness instrumentation, mutation probes, shared-graph properties, namespace
matrices, and the A7 constructor case remain owned by Phase-4 qualification.
The companion fourteen-resource-limit metadata matrix is validated but remains
explicitly unexecuted here; its A1/A3/A8/A9 boundaries are not promoted.

## Scale and evidence

The default 2,048-request batches bound request metadata and adapter input.  The
timeout applies to each adapter batch and is configurable.  Corpus JSONL files
are traversed incrementally; only compact id/equality indexes and one batch are
retained.  This supports the 10,000-positive/20,308-negative preferred release
shape: at least 20,000 classified adversarial rows and independently 20,000
mechanically demonstrated byte-deletion-primary-minimal rows, plus 308
authored/host coverage rows.  Large retry sets do not require a corpus-sized
request array.
Normative and provisional negative status totals remain separate in the
manifest and differential summary.

The summary always contains exact counts and SHA-256 values for every request
and response batch.  With `--artifacts-dir`, exact request JSONL, response
JSONL, adapter stderr, the mutation-disagreement ledger, and `summary.json` are
retained.  A nonempty artifact directory is refused.

Exit status 0 means all warranted applicable comparisons agreed.  It does not
promote A1--A9, turn N/A into pass, or claim unexecuted host properties passed.
Exit status 1 means comparison issues; exit status 2 means a provenance,
protocol, process, or runner precondition failed.

## Tests

```sh
python3 -m unittest discover -s canonical-datum/release/tests -v
```

The suite generates a 64-positive/512-negative test-mode corpus, verifies
artifact and relevant-source tamper refusal, independently checks the
negative/derivation minimization proofs, and runs all rows through both real
process adapters over multiple batches.  A green small run is tooling evidence
only, never release evidence.
