# CD/0 generated-corpus differential runner

`run_generated_differential.py` is the release-corpus coordinator for Lisp+
Canonical Datum /0 with Errata 0.1. It sends the same requests to the Common
Lisp and Python process adapters. It is not a codec, does not infer datum
semantics, and does not treat either implementation as an oracle.

“Independently seeded implementations under shared normative infrastructure, with procedural—not OS-enforced—isolation, attested by the implementers and corroborated at content tier.”

## Release invocation

Generate the corpus from a committed generator revision first.  Then run:

```sh
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir canonical-datum/generated/release-errata-0.1 \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir canonical-datum/evidence/generated-differential-errata-0.1
```

The runner refuses before launching either codec unless all of these agree:

- the base specification, ruling, and errata have their required SHA-256 values;
- the manifest v4 schema, generator v4, normative pins, source commit,
  source ancestry, and checked-out generator bytes;
- identical before/after SHA-256 maps for every relevant source input, including
  the fixture schema and promoted errata vectors, with
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

Every classified negative is checked on the complete normative category, code,
and stage triple. The runner separately executes all 39 promoted A1–A9
operation vectors and reports each adjudication count without folding them into
the generated corpus scale.

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
Inertness instrumentation, mutation probes, shared-graph properties, and the
full namespace matrix remain owned by bounded qualification. The companion
fourteen-resource-limit metadata matrix remains metadata, while the permanent
errata vectors execute the adjudicated A1/A3/A4/A5/A8/A9 boundaries supported
by the adapter protocol.

## Scale and evidence

The default 2,048-request batches bound request metadata and adapter input.  The
timeout applies to each adapter batch and is configurable.  Corpus JSONL files
are traversed incrementally; only compact id/equality indexes and one batch are
retained.  This supports the 10,000-positive/20,308-negative preferred release
shape: at least 20,000 classified adversarial rows and independently 20,000
mechanically demonstrated byte-deletion-primary-minimal rows, plus 308
authored/host coverage rows.  Large retry sets do not require a corpus-sized
request array.
The fixed release contains 10,000 positives, 20,308 classified negatives,
30,504 unclassified mutation candidates, and 20,012 retry requests. The 39
promoted errata operations are reported as a separate classified class.

For a release-qualified run, the runner hard-compares all 10,000 generated
canonical octets, abstract datums, decoded ASTs, and equality classes against
the audited release-v0 corpus. Any change is a hard stop.

The summary always contains exact counts and SHA-256 values for every request
and response batch.  With `--artifacts-dir`, exact request JSONL, response
JSONL, adapter stderr, the mutation-disagreement ledger, and `summary.json` are
retained.  A nonempty artifact directory is refused.

Exit status 0 means all applicable comparisons and every promoted errata
expectation agreed. It does not turn N/A into pass or claim unexecuted host
properties passed.
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
