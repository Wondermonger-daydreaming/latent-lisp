# Lisp+ Canonical Datum /0 implementation receipt — 2026-07-13

> **Historical pre-errata receipt.** This receipt preserves the audited state
> in which A1–A9 remained open. See `CD0-ERRATA-IMPLEMENTATION-LEDGER.md` and
> `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md` for current closure evidence.

Receipt status: **final implementation evidence**. The independent codecs,
release corpus, full differential, final qualification, mutation checks, and v1
gate described below are executed facts retained in the repository. Archive and
remote-tip facts that cannot be self-referentially embedded are reported in the
external handoff and in sibling archive metadata.

This receipt is concise evidence for an implementation and conformance task. It
does not redesign CD/0, amend the normative specification, or migrate v1.

SHA-256 values shown for the specification, hand artifacts, corpus, manifests,
and retained summaries were directly recomputed during qualification or final
packaging. Commit/tree objects, JSONL counts, machine-summary fields, and retained
`152`-test/`2510`-assertion transcript lines were directly inspected. Detailed
runtime outcomes are bounded by the committed execution receipts and transcripts.

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
| generator correction | `c826c61587953eb5252cdeb5c361d6c0fed573d6` | enforces 20,000 demonstrated byte-deletion-primary-minimal negatives |
| release runner source | `aed2f393781456dfd495ac5d5822bdcd58bea711` | audits exact retry bytes/AST and prevents symmetric false passes |
| verified release checkpoint | `0fa772e946c50e27f64e9a435e0e69343a6cd5ea` | tree `f2a2252a830d574d0b06f357754e683146fdb981` |

The Common Lisp and Python seed source-access logs enumerate what each
implementation agent inspected. Neither agent read the other codec before its
first complete conformance run and seed commit. Cross-reading began only in the
integration phase.

## Requirements-to-evidence receipt

| ID | Requirement | Evidence | Current status | Residual uncertainty |
|---|---|---|---|---|
| R1 | Construct and preserve all nine disjoint datum families | explicit constructors/private immutable family nodes in both codecs; bool/int, `NIL`, symbol, namespace, and distinct-pair tests | satisfied for supported APIs | finite host-shape coverage |
| R2 | Same abstract equality and canonical octets | 17 worked vectors; 10,000 release positives; 20,000 release equality requests; 512 randomized round trips; 513 bounded equality/encoding properties | satisfied at recorded release scale | finite generated coverage |
| R3 | Exact full-input codec and canonical refusal | 71 hand negatives, strict UTF-8, ordering/duplicate, trailing, reserved/forbidden, varint, zigzag, rational, and resource tests | satisfied for warranted fields | A1/A2 fields remain provisional |
| R4 | Immutable views and mutation resistance | 15 CL seed probes, 11 Phase-4 CL probes, 11 Python mutation/inertness seed tests, seven Phase-4 Python probes | satisfied within ordinary public APIs | unsafe reflection/native memory outside claim |
| R5 | Explicit immutable resource budgets | fourteen-field budgets, threshold/refusal/retry and preallocation tests | satisfied within tested boundaries | A3–A5/A8/A9 unadjudicated |
| R6 | Shared fixture AST conversions | positive round trips, canonical record export, strict decimal/hex preflight | satisfied | A7 has no normative construction AST |
| R7 | Typed failures with category/code/stage | hand vectors, integration regressions, qualification failures | satisfied for normative fields | eleven A1 stages and one A2 code are provisional |
| R8 | Inert privileged-looking records | selected evaluator/reader/interning/file/pickle/socket guards observed zero calls; decoded family remains Record | strong finite evidence | cannot prove absence of all FFI/syscalls |
| R9 | Ambient-host invariance | CL printer/package/readtable and concurrency probes; Python hash seeds/digit guard/dictionary order and concurrency | satisfied on recorded hosts | other hosts/versions not run |
| R10 | Independent then differential convergence | separate worktrees, seed commits before cross-reading, 353-request process differential | satisfied for hand corpus | procedural rather than OS-enforced isolation |
| R11 | Preserve existing v1 | changed-path audit and retained post-release `mneme/verify-all.sh` transcript | source untouched; 6/6 checks passed | finite behavioral regression suite |
| R12 | Generate and consume release corpus | 10,000 positives, 20,308 classified adversarials, 30,504 unlabelled mutations, 100,824 requests per codec | satisfied | deterministic corpus remains finite |

## Executed results

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

That bounded qualification explicitly did not consume or claim the release
corpus. The later full release differential did: each codec handled 100,824
requests in 50 batches, including 10,000 positive encodes/decodes, 20,000
equality judgments, 20,308 classified adversarials, 20,012 sufficient-budget
retries, and 30,504 mutation candidates. It reported zero warranted issues and
retained empty stderr for all 100 codec batch processes.

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

```text
generator correction commit: c826c61587953eb5252cdeb5c361d6c0fed573d6
release runner source commit: aed2f393781456dfd495ac5d5822bdcd58bea711
manifest source revision: aed2f393781456dfd495ac5d5822bdcd58bea711
generator seed: 3439329281
exact generator command: python3 canonical-datum/generator/generate_corpus.py --output-dir canonical-datum/generated/release-v0 --seed 3439329281 --positive-count 10000 --negative-count 20308 --mutation-sample-count 128 --truncation-max-document-octets 16
release positives: 10,000
release classified negatives/adversarials: 20,308 (20,000 byte-deletion-primary-minimal plus 308 coverage cases)
release unlabelled mutation candidates: 30,504
corpus digest: 83e35b3ac9641e06a6573fbec404149ca78130ca0a0ff9d550ff693dbdd819be
manifest sha256: 2b3fee981a2db8f46a03909d8a7c1a505248875b5a8aa9686e0afcef0f8410c3
corpus commit: 42a71429cfdafe63a989e3f44e706f828efab20e
corpus tree: 947444fde812754ac8e04bb5a0fbe29f690df3d0
determinism rerun: PASS; PYTHONHASHSEED=1 and 777 produced six byte-identical files
release differential commit: 3aed0d991781ca7b58d53a4e08cd7747ed7e5726
requests handled by Common Lisp: 100,824
requests handled by Python: 100,824
warranted disagreements: 0; mutation minimizations required: 0
provisional and N/A observations: 5 provisional-stage plus 1 provisional-code release rows; 3 Common Lisp language-specific host rows N/A, not pass
release differential result: PASS
release differential summary sha256: 66b6122d4145e97c59b931d2e90be041e7094329b1a72df7586ac7bbf3799232
final qualification result: PASS; 353 golden plus 1,045 property requests per codec
final qualification summary sha256: 5580c47e6bce23001e93b8259e6d9c6e432c6a25dcbcb25ee298821dd93fa585
final v1 result: PASS; 6/6 mneme/verify-all.sh checks
final v1 transcript sha256: da89c3155729b77f6ba8de6a219b5ebae5bd7c3bd25ee1406234331cf2f83c1c
final changed-path audit: PASS; only canonical-datum/**, CANONICAL-DATUM-DIVERGENCES.md, and CD0-IMPLEMENTATION-LEDGER.md changed from the fetched base through the verified checkpoint
verified checkpoint commit: 0fa772e946c50e27f64e9a435e0e69343a6cd5ea
verified checkpoint tree: f2a2252a830d574d0b06f357754e683146fdb981
archive path: canonical-datum/evidence/artifacts/cd0-release-2026-07-13.tar.gz
archive sha256: recorded after packaging in the sibling .sha256 file and external handoff
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
cd0-common-lisp final commit: 45eb60ce5b80485a0b287feab53ed3b58643b1b0
cd0-python final commit: 29d0946ad78347015b9f0c65a2f528f039fdca78
integration verified checkpoint: 0fa772e946c50e27f64e9a435e0e69343a6cd5ea
origin Common Lisp ref: refs/heads/cd0-common-lisp
origin Python ref: refs/heads/cd0-python
origin integration ref: refs/heads/cd0-integration
push result: reported in the external handoff after the final branch-tip push
```

Remote URL: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`.

The enclosing documentation commit and the final archive-envelope branch tip
must be reported in the external handoff because a file cannot embed the hash
of the commit that contains itself without changing that hash.
