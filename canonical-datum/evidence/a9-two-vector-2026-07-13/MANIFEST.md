# Focused A9 two-vector evidence manifest

Date: 2026-07-13

## Prompt context and scope

This directory preserves the evidence produced to close the sole item returned
by Fable protocol `49b3cf88`: two exact permanent shared A9 `runtime-encode`
vectors for `seq[Unit]` under `max_depth=1` and separately `max_nodes=1`.
The task explicitly prohibited semantic redesign. No codec core, adapter
semantics, canonical bytes, equality rule, accepted document, wire grammar, or
v1 behavior was changed.

## Contents and provenance

- `prechange/`: direct generic-adapter requests and responses captured before
  adding the two rows, plus pre-change Phase-0 and hand summaries.
- `hand/`: 467-request-per-codec post-change differential transcript.
- `qualification/`: complete bounded qualification child-command outputs and
  summary, including complete codec suites and mutation/inertness probes.
- `release/summary.json`: the complete 50-batch ledger and release result. The
  129 MiB batch bodies were not duplicated; their request/response/stderr
  hashes and sizes are inside this retained summary.
- `corpus/cd0-corpus-manifest.json`: the deterministic full-corpus manifest.
  The five 51 MiB data members were not duplicated because their hashes and the
  aggregate corpus digest are unchanged from the already-retained Errata 0.1
  corpus.

The implementation and evidence were produced by Codex in the user's workspace
under the user's conformance-repair authorization. Fable's report is an
independent review artifact and is retained separately, byte-exact, in the
focused packet. Normative specification and ruling files are repository/user
inputs, not Codex-authored material.

## Factual status and boundaries

JSON summaries and transcripts record finite observed executions on CPython
3.11.14 and SBCL 2.4.6. A green command is an observation; this manifest and the
receipts are bounded syntheses; neither is a formal proof over every host,
allocator, input, or runtime. Common Lisp's three optional-importer N/A rows are
not passes or failures. This collection contains no fictional or theatrical
artifact.

Canonical datum identity does not establish truth, authority, custody,
authenticity, semantic validity, or verified lineage.

## Load-bearing identities

```text
Fable report       67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b
new vector         731a74ed61352200d378771f43b747d64bfcc0dea793b116d25b0b888ee11bc3
hand summary       8dd3156abfbf14ca15c90e64d539ca022d3f930a42f0adabaf943458c4641078
release summary    c229e377ef160b7038b1a901630cb440a08666d39f8737d20c4b2b77ce1e3c2e
qualification      0e8abf173dffea60f072c6b20fca48a8cb178fabfa79308e8c02bedfb4a72a86
corpus manifest    101cd0d59e6ad2dad5d9aff4d3179936ac393ad32a9be1736453a0b8cc4b8d92
aggregate corpus   62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58
valid projection   21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58
```
