# Lisp+ Canonical Datum /0 implementation receipt — 2026-07-13

Receipt status: **pre-release draft**. The independent codecs, hand-corpus
differential, and bounded Phase-4 qualification described below are executed
facts. The release corpus, final reruns, archive, and push are not facts until
their `{{CD0_*}}` placeholders are replaced from retained evidence.

This receipt is concise evidence for an implementation and conformance task. It
does not redesign CD/0, amend the normative specification, or migrate v1.

For this documentation draft, SHA-256 values shown for the specification, hand
artifacts, and retained Phase-2/Phase-4 summaries were directly recomputed.
Commit/tree objects, JSONL line counts, negative status/input-kind counts,
machine-summary fields, and retained `152`-test/`2510`-assertion transcript lines
were directly inspected. Worked-vector semantics, mutation/inertness outcomes,
and concurrency observations are transcribed from the committed execution
receipts; the documentation-only drafting step did not rerun them.

## Pinned authority and starting state

```text
specification: mneme/spec/CANONICAL-DATUM-SPEC.md
specification sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
task-arrival nested checkout HEAD: 1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48
task-arrival nested checkout tree: 69793d6ac432d47a060a215785b536ee7e8fcfd0
fetched origin/main CD/0 base: ae767f00975395369f9a91283a954f0963fb6724
fetched origin/main base tree: b8f5be6d532eafe5be0d1f342347fa10f5f39352
Common Lisp: SBCL 2.4.6
Python: CPython 3.11.14
```

The digest matched before the specification was read for implementation. The
separate task-arrival checkout and fetched CD/0 branch base are both recorded so
the provenance does not silently replace one with the other.

## Implementation checkpoints

| Branch or phase | Commit | Meaning |
|---|---|---|
| `cd0-common-lisp` seed | `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3` | first complete independent Common Lisp implementation |
| `cd0-python` seed | `58ecca4083275ebfe16605765e575bfb9f6eb755` | first complete independent Python implementation |
| Common Lisp hardened branch | `45eb60ce5b80485a0b287feab53ed3b58643b1b0` | seed plus bounded precedence/import/equality corrections |
| Python hardened branch | `29d0946ad78347015b9f0c65a2f528f039fdca78` | seed plus bounded host-resource corrections |
| first integrated convergence | `fac17dd701c59f6da8eb2536dd022853b2e258fe` | imported seeds, repairs, process adapters, differential evidence |
| bounded Phase-4 qualification | `7a0994f1ea176db1bffa61564dd23957a8c6216a` | retained hostile/property/runtime qualification |
| generator correction | `{{CD0_GENERATOR_CORRECTION_COMMIT}}` | pending final source gate |
| release runner source | `{{CD0_RELEASE_RUNNER_SOURCE_COMMIT}}` | pending final source gate |
| verified release checkpoint | `{{CD0_VERIFIED_CHECKPOINT_COMMIT}}` | tree `{{CD0_VERIFIED_CHECKPOINT_TREE}}` |

The Common Lisp and Python seed source-access logs enumerate what each
implementation agent inspected. Neither agent read the other codec before its
first complete conformance run and seed commit. Cross-reading began only in the
integration phase.

## Requirements-to-evidence receipt

| ID | Requirement | Evidence | Current status | Residual uncertainty |
|---|---|---|---|---|
| R1 | Construct and preserve all nine disjoint datum families | explicit constructors/private immutable family nodes in both codecs; bool/int, `NIL`, symbol, namespace, and distinct-pair tests | satisfied for supported APIs | finite host-shape coverage |
| R2 | Same abstract equality and canonical octets | 17 worked vectors; 22-positive corpus; complete 253-pair equality relation; 512 randomized round trips; 513 equality/encoding properties | satisfied through bounded qualification | release-scale corpus pending |
| R3 | Exact full-input codec and canonical refusal | 71 hand negatives, strict UTF-8, ordering/duplicate, trailing, reserved/forbidden, varint, zigzag, rational, and resource tests | satisfied for warranted fields | A1/A2 fields remain provisional |
| R4 | Immutable views and mutation resistance | 15 CL seed probes, 11 Phase-4 CL probes, 11 Python mutation/inertness seed tests, seven Phase-4 Python probes | satisfied within ordinary public APIs | unsafe reflection/native memory outside claim |
| R5 | Explicit immutable resource budgets | fourteen-field budgets, threshold/refusal/retry and preallocation tests | satisfied within tested boundaries | A3–A5/A8/A9 unadjudicated |
| R6 | Shared fixture AST conversions | positive round trips, canonical record export, strict decimal/hex preflight | satisfied | A7 has no normative construction AST |
| R7 | Typed failures with category/code/stage | hand vectors, integration regressions, qualification failures | satisfied for normative fields | eleven A1 stages and one A2 code are provisional |
| R8 | Inert privileged-looking records | selected evaluator/reader/interning/file/pickle/socket guards observed zero calls; decoded family remains Record | strong finite evidence | cannot prove absence of all FFI/syscalls |
| R9 | Ambient-host invariance | CL printer/package/readtable and concurrency probes; Python hash seeds/digit guard/dictionary order and concurrency | satisfied on recorded hosts | other hosts/versions not run |
| R10 | Independent then differential convergence | separate worktrees, seed commits before cross-reading, 353-request process differential | satisfied for hand corpus | procedural rather than OS-enforced isolation |
| R11 | Preserve existing v1 | CD/0 changed-path audit; final `mneme/verify-all.sh` transcript placeholder | source untouched; final result `{{CD0_FINAL_V1_RESULT}}` | retained post-release rerun pending |
| R12 | Generate and consume release corpus | corpus/manifest/differential placeholders below | pending | completion gate |

## Executed results before release generation

Phase 0 mechanically reproduced all 17 Section 15 worked vectors. The corrected
shared fixture set contains 22 positives and 71 negatives (66 octet inputs and
five host descriptors), covers all 256 possible tag octets, and preserves five
declared unequal pairs. Its stable hashes are:

```text
f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce  canonical-datum/vectors/cd0-positive.jsonl
6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5  canonical-datum/vectors/cd0-negative.jsonl
ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27  canonical-datum/vectors/cd0-distinct-pairs.json
ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98  canonical-datum/vectors/cd0-budgets.json
4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13  canonical-datum/schema/cd0-fixtures.schema.json
```

After hardening, the Common Lisp suite passed 2,510 assertions and the Python
suite passed 152 tests. The first retained differential passed 353 requests in
each isolated codec process:

```text
22 shared positives
71 shared negative dispositions
  Common Lisp: 68 executed, 3 language-specific host N/A
  Python: 71 executed, 0 N/A
253 complete equality judgments
7 retained and classified integration regressions
0 warranted cross-codec disagreements
0 stderr bytes from each adapter
```

Retained Phase-2 summary SHA-256:
`69b0b9025db187074ebcca4252bd2b02c5072211ff3a8fe0d63b39c65914f6b0`.

The bounded Phase-4 default run passed with 353 golden requests, 512
deterministic randomized round trips, 513 equality/encoding properties, 14
classified hostile/resource failures, six sufficient-budget retries, and zero
warranted disagreement. It reran 152 Python tests and 2,510 Common Lisp
assertions, exercised four Python hash-seed processes and one CL runtime process
with 1,024 concurrent observations, and retained summary SHA-256
`88ed013ef71690b174627730c0c85ea51d5a28b61181bdeef08bfdd2d09a0a57`.

That qualification explicitly did not consume or claim the release corpus.

## Provisional and N/A boundary

A1–A9 in `CANONICAL-DATUM-DIVERGENCES.md` remain open. Agreement between two
implementations does not adjudicate an underspecified field. Of 71 hand
negative rows, 59 carry a complete normative triple, 11 carry a provisional
stage under A1, and one carries a provisional code under A2.

The following Common Lisp host rows are not applicable—not passes—because the
optional language-specific importer is not exposed:

- `cd0-neg-host-ambiguous-identifier`;
- `cd0-neg-host-bool-as-integer`;
- `cd0-neg-host-privileged-value`.

The implementations retain different documented A9 runtime-encoder budget
surfaces. No test makes one implementation imitate the other at that open
boundary.

## Release and final gate record

Replace every field below directly from committed artifacts and transcripts:

```text
generator correction commit: {{CD0_GENERATOR_CORRECTION_COMMIT}}
release runner source commit: {{CD0_RELEASE_RUNNER_SOURCE_COMMIT}}
manifest source revision: {{CD0_RELEASE_SOURCE_REVISION}}
generator seed: {{CD0_RELEASE_SEED}}
exact generator command: {{CD0_RELEASE_COMMAND}}
release positives: {{CD0_RELEASE_POSITIVE_COUNT}}
release classified negatives/adversarials: {{CD0_RELEASE_NEGATIVE_COUNT}}
release unlabelled mutation candidates: {{CD0_RELEASE_MUTATION_COUNT}}
corpus digest: {{CD0_RELEASE_CORPUS_SHA256}}
manifest sha256: {{CD0_RELEASE_MANIFEST_SHA256}}
corpus commit: {{CD0_RELEASE_CORPUS_COMMIT}}
corpus tree: {{CD0_RELEASE_CORPUS_TREE}}
determinism rerun: {{CD0_RELEASE_DETERMINISM_RESULT}}
release differential commit: {{CD0_RELEASE_DIFFERENTIAL_COMMIT}}
requests handled by Common Lisp: {{CD0_RELEASE_REQUESTS_CL}}
requests handled by Python: {{CD0_RELEASE_REQUESTS_PY}}
warranted disagreements: {{CD0_RELEASE_WARRANTED_DISAGREEMENTS}}
provisional and N/A observations: {{CD0_RELEASE_PROVISIONAL_OBSERVATIONS}}
release differential result: {{CD0_RELEASE_DIFFERENTIAL_RESULT}}
release differential summary sha256: {{CD0_RELEASE_DIFFERENTIAL_SUMMARY_SHA256}}
final qualification result: {{CD0_FINAL_QUALIFICATION_RESULT}}
final qualification summary sha256: {{CD0_FINAL_QUALIFICATION_SUMMARY_SHA256}}
final v1 result: {{CD0_FINAL_V1_RESULT}}
final v1 transcript sha256: {{CD0_FINAL_V1_TRANSCRIPT_SHA256}}
final changed-path audit: {{CD0_FINAL_CHANGED_PATH_AUDIT}}
verified checkpoint commit: {{CD0_VERIFIED_CHECKPOINT_COMMIT}}
verified checkpoint tree: {{CD0_VERIFIED_CHECKPOINT_TREE}}
archive path: {{CD0_ARCHIVE_PATH}}
archive sha256: {{CD0_ARCHIVE_SHA256}}
```

Completion requires the two codecs to agree on all warranted release-corpus
bytes, normalized ASTs, equality judgments, and failure fields; all generated
mutation candidates to be dispositioned without inventing permanent triples for
unminimized multi-defect bytes; all divergences to be resolved or explicitly
recorded; mutation/inertness probes to remain green; and v1 to remain
behaviorally untouched.

## Portability and non-claims

No CCL, ECL, CLISP, ABCL, Roswell, PyPy, other Python version, other operating
system, or other runtime library was executed. This receipt claims no formal
proof over all inputs or allocator schedules. Canonical bytes establish datum
identity only: they do not establish truth, authority, custody, authenticity,
verified lineage, or semantic validity of privileged-looking content.

No claim identity, as-of targeting, warrant/capability semantics, receipt
transition, Language A, cryptographic hash/signature, or module/procedure
identity was selected or changed.

## Commit, archive, and remote handoff

```text
cd0-common-lisp final commit: {{CD0_COMMON_LISP_FINAL_COMMIT}}
cd0-python final commit: {{CD0_PYTHON_FINAL_COMMIT}}
integration verified checkpoint: {{CD0_VERIFIED_CHECKPOINT_COMMIT}}
origin Common Lisp ref: {{CD0_COMMON_LISP_REMOTE_REF}}
origin Python ref: {{CD0_PYTHON_REMOTE_REF}}
origin integration ref: {{CD0_INTEGRATION_REMOTE_REF}}
push result: {{CD0_PUSH_RESULT}}
```

Remote URL: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`.

The enclosing documentation commit and the final archive-envelope branch tip
must be reported in the external handoff because a file cannot embed the hash
of the commit that contains itself without changing that hash.
