# CD/0 deterministic release-corpus generator

This directory owns release-corpus generation for Lisp+ Canonical Datum /0
with Errata 0.1. It does not define datum semantics. Every run pins three
normative inputs before creating output:

- base specification: `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`;
- post-implementation ruling: `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc`;
- Errata 0.1: `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271`.

It also records the shared fixture-schema and promoted A1–A9 vector hashes.

## Source-first release procedure

Commit this generator before generating a release corpus.  The manifest records
`git rev-parse HEAD`, so running from the source commit makes the emitted source
revision meaningful.  The exact release command is:

```sh
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir canonical-datum/generated/release-errata-0.1 \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20308 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

Release qualification requires at least 10,000 positives, at least 20,000 total
classified adversarial rows, and independently at least 20,000 rows carrying the
demonstrated `byte-deletion-primary-minimal` proof.  The generator retains 308
authored/host coverage rows in addition, so the preferred and default release
count is 20,308.  A 20,000-total invocation is refused: it would contain only
19,692 demonstrated-primary rows. All 20,308 classified rows now carry complete
normative category/code/stage triples. The fixed release also retains 30,504
unclassified mutation candidates and 20,012 sufficient-budget retry cases.
`--allow-small` exists only for deterministic tests.
A dirty source override is accepted only as `--allow-small
--allow-dirty-source`, and both facts are recorded.  Release mode requires a
worktree clean of tracked and untracked changes.

The generator snapshots the source revision and SHA-256 of every relevant input
before in-memory generation, verifies them again afterward and immediately
before publication, then writes into a sibling staging directory.  Only a
complete artifact set and manifest are atomically renamed to the requested
path.  Staging is removed on failure, and an existing final path is never
overwritten.

## Emitted artifacts

- `cd0-generated-positive.jsonl` and `cd0-generated-negative.jsonl` are shared
  Section 27/28 fixture-schema rows.  Positive canonical documents are unique.
  Classified negative input/budget cases are distinct within the artifact; this
  is not a claim of global semantic uniqueness.
- `cd0-generated-negative-derivations.jsonl` records the source operation and
  a scoped minimization kind/proof.  Coverage templates retain their authored
  primary defects.  Bulk padding uses canonical two-octet Bytes documents: nine
  input octets under a complete inline budget with `max_input_octets=8`.  Every
  one-byte deletion removes that primary input-length defect, and the sufficient
  retry budget must decode/re-encode the original bytes exactly.  This is
  byte-deletion-primary-minimal, not a global minimization claim.
- `cd0-mutation-candidates.jsonl` contains broad Section 28.4 mutations.  It
  intentionally has no `expected_failure`: a candidate may contain multiple
  defects and cannot acquire a permanent triple until both implementations
  agree after minimization.
- `cd0-host-property-scenarios.json` makes non-octet obligations explicit:
  cycles, improper lists, shared acyclic structure, mutable aliases, symbols,
  Python bool/integer disjointness, namespaces, and inert privileged-looking
  records, plus executable descriptions for all fourteen resource boundaries.
  These scenarios are marked `not-executed-by-generator`; execution is owned by
  separately retained Phase-4 evidence, and this metadata is not that transcript.
- `cd0-corpus-manifest.json` records generator/runtime versions, seed, exact
  invocation and resolved logical command, source revision, configured
  truncation size, counts, Section 28 coverage, every data-artifact SHA-256, and
  a corpus digest.  The manifest excludes its own digest to avoid circularity;
  the integration artifact ledger must hash it externally.

All worked-vector truncation points are emitted, including the three A7
construction-descriptor rows. To retain the audited 30,504 mutation scale,
those 22 new hand-vector points deterministically displace 22 redundant points
from the tail of the generated configured-size truncation population.
For each sampled positive, the generator also deletes every octet and suffix,
appends octets, changes tags and declared sizes, makes a UVAR overlong, corrupts
UTF-8 leads/continuations, mutates record fields, and replaces rational
components.

## Oracle and divergence boundary

Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.

Generation begins only after the seed implementations have agreed.
The Python codec is reused as a fixture adapter and consistency check because it
can construct, encode, decode, and render the shared AST.  It is not a normative
oracle; the pinned specification and later Common Lisp/Python differential run
remain authoritative for conformance evidence.

A1–A9 are closed by the pinned ruling and Errata 0.1. The manifest records all
37 promoted cases (A1=6, A2=5, A3=6, A4=3, A5=3, A6=2, A7=1, A8=6, A9=5).
Construction descriptors remain distinct from normalized abstract datums.
Broad mutation candidates remain unclassified because the errata does not
authorize assigning a primary defect to multi-defect mutations.

## Tests

```sh
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

The suite generates the same small corpus twice at one path under
`PYTHONHASHSEED=1` and `PYTHONHASHSEED=777` and compares every output byte.  It
also validates shared fixture schemas, tag coverage, mutation separation,
complete hand and fixed-scale configured truncation sets, host scenario metadata, source/normative
pins and drift refusal, retry success, deletion-position provenance, no-op
removal, identifier distinctions, all resource metadata, atomic failure cleanup,
release floors, and artifact/corpus hashes.  A small green run is evidence for
generator behavior only; it is not the required release corpus.
