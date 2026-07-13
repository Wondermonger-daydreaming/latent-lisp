# CD/0 deterministic release-corpus generator

This directory owns Phase 3 corpus generation for Lisp+ Canonical Datum /0.
It does not define datum semantics.  Every run first requires
`mneme/spec/CANONICAL-DATUM-SPEC.md` to have SHA-256
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.
A mismatch refuses before creating the output directory.

## Source-first release procedure

Commit this generator before generating a release corpus.  The manifest records
`git rev-parse HEAD`, so running from the source commit makes the emitted source
revision meaningful.  The exact release command is:

```sh
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir canonical-datum/generated/release-v0 \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20000 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

The generator refuses release counts below 10,000 positive and 20,000
classified negative vectors.  `--allow-small` exists only for deterministic
tests and is recorded as non-release mode in the manifest.  Existing output
directories are never overwritten.

## Emitted artifacts

- `cd0-generated-positive.jsonl` and `cd0-generated-negative.jsonl` are shared
  Section 27/28 fixture-schema rows.  Positive canonical documents are unique.
  Classified negative input/budget pairs are unique.
- `cd0-generated-negative-derivations.jsonl` records the source operation and
  whether a row is a one-edit mutation.  Precise triples are hand-derived from
  the pinned grammar and checked against the post-seed Python codec.
- `cd0-mutation-candidates.jsonl` contains broad Section 28.4 mutations.  It
  intentionally has no `expected_failure`: a candidate may contain multiple
  defects and cannot acquire a permanent triple until both implementations
  agree after minimization.
- `cd0-host-property-scenarios.json` makes non-octet obligations explicit:
  cycles, improper lists, shared acyclic structure, mutable aliases, symbols,
  Python bool/integer disjointness, namespaces, and inert privileged-looking
  records.
- `cd0-corpus-manifest.json` records generator/runtime versions, seed, exact
  invocation and resolved logical command, source revision, configured
  truncation size, counts, Section 28 coverage, every data-artifact SHA-256, and
  a corpus digest.  The manifest excludes its own digest to avoid circularity;
  the integration artifact ledger must hash it externally.

All worked-vector truncation points are emitted.  Every generated canonical
document at or below the configured octet size is truncated at every point.
For each sampled positive, the generator also deletes every octet and suffix,
appends octets, changes tags and declared sizes, makes a UVAR overlong, corrupts
UTF-8 leads/continuations, mutates record fields, and replaces rational
components.

## Oracle and divergence boundary

Generation begins only after the independent seed implementations have agreed.
The Python codec is reused as a fixture adapter and consistency check because it
can construct, encode, decode, and render the shared AST.  It is not a normative
oracle; the pinned specification and later Common Lisp/Python differential run
remain authoritative for conformance evidence.

Open divergences A1--A9 are preserved.  In particular, broad mutations remain
unclassified, the Python bool/import code stays provisional under A2, and the
generator does not invent a rational-construction AST to bypass A7.

## Tests

```sh
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

The suite generates the same small corpus twice at one path under
`PYTHONHASHSEED=1` and `PYTHONHASHSEED=777` and compares every output byte.  It
also validates shared fixture schemas, tag coverage, mutation separation,
complete hand/configured truncation sets, host scenario metadata, source/spec
pins, release floors, and artifact/corpus hashes.  A small green run is evidence
for generator behavior only; it is not the required release corpus.
