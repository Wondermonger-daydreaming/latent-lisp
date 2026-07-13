# CD/0 Errata 0.1 release receipt

Date: 2026-07-13

This receipt records the corrected deterministic corpus and complete generated
differential. It is release evidence for the successor branch only. It does not
claim a merge to `main` or make either implementation a normative oracle.

## Corpus provenance

| Field | Value |
|---|---|
| clean generator source commit | `bdb2214878ebb302329a40e895269ff950b8ae97` |
| source tree | `46253ae9bfcfd37b2e481fbe8cfd0e8ad9553d09` |
| generator | `cd0-corpus-generator/4` |
| runtime | CPython 3.11.14 |
| deterministic seed | `3439329281` |
| clean before generation | `true` |
| dirty override | not requested; not used |
| manifest schema | `cd0-generated-corpus-manifest/v4` |
| manifest SHA-256 | `9b0865c559cdcdfaa850a8fa5e8e7ac47916059ac0516427322f3cf9d0c81fbc` |
| aggregate corpus SHA-256 | `62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58` |
| release-qualified | `true` |

The generator ran in a detached clean worktree. Two successive executions used
the same output path, with `PYTHONHASHSEED=1` and `777`; `diff -qr` exited `0`
over all six files. The retained corpus is a byte copy of that exact output.
The manifest therefore records its clean temporary generation path; moving the
already-hashed six-file set into the repository changed no member bytes.

Exact generator command:

```text
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir /tmp/cd0-final-regeneration-bdb2214/repeat \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20308 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

The normative pins embedded in the manifest are:

```text
base specification:  d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
ruling:              1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc
Errata 0.1:          5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271
```

## Corpus members

The retained directory has six files and 52,625,151 bytes:

| Member | Rows/descriptors | Bytes | SHA-256 |
|---|---:|---:|---|
| `cd0-corpus-manifest.json` | one manifest | 30,581 | `9b0865c559cdcdfaa850a8fa5e8e7ac47916059ac0516427322f3cf9d0c81fbc` |
| `cd0-generated-negative-derivations.jsonl` | 20,308 | 11,179,974 | `2ffd77257e18dfbc70abef0cc5fae1603d50b1a8b005226af95200708c29ca02` |
| `cd0-generated-negative.jsonl` | 20,308 | 17,210,317 | `465e300ec0695b9d066b5a47662b1c87ff7327d3b6cb487d086034bb986194d4` |
| `cd0-generated-positive.jsonl` | 10,000 | 7,919,166 | `4d4d5ef09606d04d21297b4cd08c209a57cb090601bb790fbe3019a07c33c77d` |
| `cd0-host-property-scenarios.json` | 23 descriptors | 15,027 | `cf9bbce16a0aae99a4fbd363db313bd422c6796c694746a548fbdded161a2ab5` |
| `cd0-mutation-candidates.jsonl` | 30,504 | 16,270,086 | `9da19ecf42d5a8aba1aa1b978d1654c46f38ad37aaa66d81cbb1d6efdb96dfbb` |

The 23 non-octet descriptors decompose into nine host-property and fourteen
resource-boundary scenarios. Metadata is not counted as execution evidence;
execution belongs to qualification.

Classified negative accounting:

```text
20,308 complete normative rows
= 20,000 mechanically demonstrated byte-deletion-primary-minimal rows
+    308 authored/host coverage rows
20,012 rows carry sufficient-budget retry checks
```

The broad 30,504 mutation candidates remain unclassified. The 22 new
A7-linked worked-vector truncation points deterministically replace 22
redundant tail points to retain the audited scale. This bounded selection change
does not change generated valid datums, canonical octets, expected failure
triples, or candidate classification standing.

## Generated differential command

```text
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir /tmp/cd0-final-regeneration-bdb2214/repeat \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir /tmp/cd0-release-final-bdb2214 \
  --json
```

Exit: `0`. Status: `PASS`. Issues: `0`. Mutation disagreements: `0`.

Evidence directory:
`canonical-datum/evidence/generated-differential-errata-0.1`

The final post-review run was executed from the clean detached source worktree
at `bdb2214…` into the temporary artifact directory shown above.  Its 251
request/response/stderr artifacts were byte-identical to the already-retained
files; the retained `summary.json` was replaced with the final provenance and
timing summary.  Thus no response byte changed while the manifest/source and
observational summary identities advanced.

| Evidence fact | Value |
|---|---:|
| files | 252 |
| bytes | 134,880,443 |
| batches | 50 |
| full 2,048-request batches | 49 |
| final-batch requests | 509 |
| request bytes | 72,479,831 |
| requests per codec | 100,861 |
| Common Lisp response rows/bytes | 100,861 / 31,406,850 |
| Python response rows/bytes | 100,861 / 30,902,607 |
| Common Lisp stderr bytes | 0 |
| Python stderr bytes | 0 |
| summary SHA-256 | `44e1b9edb7dac1f89124d52559c3fc7368b26e3340e487379f389b85bfb0b422` |

Per-codec request arithmetic:

```text
10,000 generated positives
20,308 classified normative negatives
20,000 equality judgments (10,000 self + 10,000 neighbor)
20,012 sufficient-budget retry requests
30,504 unclassified mutation candidates
    37 promoted A1-A9 operations
=100,861 requests per implementation
```

Negative execution dispositions:

| Implementation | Executed classified rows | N/A | Conformance failures | Skips | Classified total |
|---|---:|---:|---:|---:|---:|
| Python | 20,308 | 0 | 0 | 0 | 20,308 |
| Common Lisp | 20,305 | 3 | 0 | 0 | 20,308 |

The three Common Lisp rows are partial-language-applicability dispositions for
optional importers absent from that seed. They are N/A, not passes. All 20,308
rows carry complete normative triples; 20,305 are fully executed by both
implementations.

The promoted class executed all 37 operations with zero failures and zero
skips:

```text
A1=6 A2=5 A3=6 A4=3 A5=3 A6=2 A7=1 A8=6 A9=5
```

Mutation outcomes were 30,049 both-failure-with-the-same-complete-triple and 455
both-success-with-identical-input/canonical-output. The disagreement ledger is
empty and has the empty-file SHA-256
`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

## Audited valid-datum compatibility hard gate

The runner compared all 10,000 current positive rows against the audited
`canonical-datum/generated/release-v0/cd0-generated-positive.jsonl` projection
anchored at integration commit `baeecd5e0347435b9e1362000344f46ea441c6ec`.

```text
compared rows:          10,000
canonical octet changes:     0
abstract datum changes:      0
decoded AST changes:         0
equality-class changes:      0
```

Baseline and current projection SHA-256 are both
`21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.
Any nonzero protected count would have stopped the run.

## Boundary

Batch transcripts embed local absolute paths and elapsed timings, so those
receipt bytes are observations of this exact run rather than a claim of
cross-host byte identity. The corpus data itself regenerated byte-identically
under two hash seeds. The evidence supports the tested SBCL/CPython surface; it
does not prove absence of every ungenerated edge or turn canonical identity into
truth, authority, authenticity, custody, or lineage.
