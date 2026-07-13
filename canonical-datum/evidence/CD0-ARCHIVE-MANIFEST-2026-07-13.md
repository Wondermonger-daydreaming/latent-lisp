# CD/0 release archive manifest — 2026-07-13

## Prompt context and scope

This archive preserves the repository artifacts produced for the request to
implement Lisp+ Canonical Datum /0 exactly from the pinned repository copy of
`mneme/spec/CANONICAL-DATUM-SPEC.md`, independently in Common Lisp and Python,
then converge them through shared fixtures, differential testing, generated
hostile corpora, mutation probes, and final evidence. The request explicitly
excluded migration or semantic redesign of the existing v1 runtime.

The archive contains:

- `CANONICAL-DATUM-DIVERGENCES.md`;
- `CD0-IMPLEMENTATION-LEDGER.md`;
- the complete tracked `canonical-datum/` implementation, tests, fixture
  schemas, hand vectors, deterministic generator, release corpus, retained
  differential/qualification evidence, implementation receipt, and reviewer
  relay.

It does not contain Git history, repository files outside that scope, secrets,
credentials, hidden reasoning, or disposable terminal chatter. Exact Git source
commit and archive SHA-256 are recorded beside the archive in `.source.txt` and
`.sha256` files because an archive cannot include its own digest without a
circular change.

## Authorship and provenance

The implementation and evidence were produced by Codex agents collaborating in
the user's workspace under the user's implementation request. The normative
specification is user/repository-supplied and is not authored by Codex. Shared
fixture vectors are hand-authored translations and hostile cases derived for
this conformance task; generated corpus rows are deterministic products of the
tracked generator.

The normative specification path and verified digest are:

```text
mneme/spec/CANONICAL-DATUM-SPEC.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
```

The verified source/evidence checkpoint is commit
`0fa772e946c50e27f64e9a435e0e69343a6cd5ea`, tree
`f2a2252a830d574d0b06f357754e683146fdb981`. The archive itself snapshots the
later documentation commit named in its sibling `.source.txt` file.

## Factual status and boundaries

The checked-in transcripts and summaries are observations of executed runs on
SBCL 2.4.6 and CPython 3.11.14. They are finite conformance evidence, not a
formal proof over every input, runtime, allocator, thread schedule, FFI, or
operating system. Three language-specific Common Lisp importer cases are N/A,
not passes. Specification ambiguities A1–A9 remain explicitly open; matching
provisional behavior does not adjudicate them.

This collection contains no theatrical or fictional artifact. Diagnostic prose,
implementation receipts, test summaries, and hashes have evidentiary roles with
different strength: a retained green test is an observed run, a receipt is a
bounded synthesis of retained observations, and reviewer guidance is not itself
runtime evidence.

Canonical datum bytes establish only the identity defined by CD/0. They do not
establish truth, authority, custody, authenticity, verified lineage,
cryptographic integrity, or semantic validity of record contents.

## Reproducibility contract

The `.tar.gz` is made twice with `git archive` from the exact commit recorded in
the sibling `.source.txt` file, restricted to the paths listed above and with
prefix `cd0-release-2026-07-13/`. The two byte streams must compare equal before
one is retained. Its member listing is inspected, the member count is recorded
externally, and its SHA-256 is written to the sibling `.sha256` file.
