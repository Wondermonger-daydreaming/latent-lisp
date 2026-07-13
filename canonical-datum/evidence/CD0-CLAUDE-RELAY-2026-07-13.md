# Paste-ready Claude relay — Lisp+ Canonical Datum /0

Relay status: **paste-ready implementation and conformance handoff**.

Provenance: hashes for the specification, hand artifacts, release corpus,
manifests, and retained summaries were recomputed during qualification or final
packaging. Git objects, JSONL/status/input-kind counts, summary fields, and
retained 152-test/2,510-assertion lines were directly inspected. Runtime claims
remain bounded by the committed execution receipts and transcripts.

---

Please review the Lisp+ Canonical Datum /0 implementation as an implementation
and conformance audit, not as a redesign exercise.

Repository:
`https://github.com/Wondermonger-daydreaming/latent-lisp.git`

Remote branches after the authorized push:

- Common Lisp: `refs/heads/cd0-common-lisp` at
  `45eb60ce5b80485a0b287feab53ed3b58643b1b0`
- Python: `refs/heads/cd0-python` at
  `29d0946ad78347015b9f0c65a2f528f039fdca78`
- integration: `refs/heads/cd0-integration`; verified source/evidence checkpoint
  `0fa772e946c50e27f64e9a435e0e69343a6cd5ea`, tree
  `f2a2252a830d574d0b06f357754e683146fdb981`
- push observation: supplied alongside this relay because the final remote tip
  necessarily postdates the tracked relay file

The branch tip containing the final documentation/archive envelope is reported
outside this tracked relay to avoid a self-referential commit hash.

The only normative artifact is
`mneme/spec/CANONICAL-DATUM-SPEC.md`, SHA-256:

```text
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
```

Please verify that digest before drawing semantic conclusions. Do not infer
datum semantics from the current v1 kernel, `mneme-canon/0`, Common Lisp
packages/symbols, SBCL printing, Python equality, or existing claim, warrant,
receipt, certificate, or capability representations.

Provenance has two distinct starting facts:

```text
task-arrival nested checkout HEAD: 1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48
task-arrival nested checkout tree: 69793d6ac432d47a060a215785b536ee7e8fcfd0
fetched origin/main used as CD/0 branch base: ae767f00975395369f9a91283a954f0963fb6724
fetched base tree: b8f5be6d532eafe5be0d1f342347fa10f5f39352
Common Lisp runtime: SBCL 2.4.6
Python runtime: CPython 3.11.14
```

The Common Lisp and Python implementations were made in isolated worktrees.
The original seed commits existed before cross-reading:

```text
Common Lisp seed: e6f3b579742f5fcff0d82477d07f8c0c9ee34df3
Common Lisp seed tree: ee168b0ec3f5fb0b6501e773e318974d014cd9df
Python seed: 58ecca4083275ebfe16605765e575bfb9f6eb755
Python seed tree: 331e8c83d683523381301a51de680f71b758026b
Python seed integrated with new parent as: 9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad
```

Each seed source-access log enumerates exactly which repository files were
opened. This supports procedural clean-room isolation; it is not an OS-level
information-flow proof. Integration began only after both first complete local
conformance runs and commits existed.

Important later checkpoints:

```text
Common Lisp hardened branch: 45eb60ce5b80485a0b287feab53ed3b58643b1b0
Python hardened branch: 29d0946ad78347015b9f0c65a2f528f039fdca78
first differential convergence: fac17dd701c59f6da8eb2536dd022853b2e258fe
bounded Phase-4 qualification: 7a0994f1ea176db1bffa61564dd23957a8c6216a
generator correction: c826c61587953eb5252cdeb5c361d6c0fed573d6
release runner source: aed2f393781456dfd495ac5d5822bdcd58bea711
release corpus commit/tree: 42a71429cfdafe63a989e3f44e706f828efab20e / 947444fde812754ac8e04bb5a0fbe29f690df3d0
release differential commit: 3aed0d991781ca7b58d53a4e08cd7747ed7e5726
verified checkpoint commit/tree: 0fa772e946c50e27f64e9a435e0e69343a6cd5ea / f2a2252a830d574d0b06f357754e683146fdb981
```

The implemented conceptual surface in both languages is: construction of all
nine disjoint datum families, structural `equal-datum`, exact encoding and
full-input decoding, immutable accessors/views, explicit immutable resource
budgets, typed category/code/stage failures, shared fixture-AST conversion, and
diagnostic rendering separate from identity. Python Boolean is not Integer;
Common Lisp `NIL` is not a universal coercion; host symbols are not implicit
Identifiers; mutable input aliases are severed; privileged-looking records stay
inert records.

The corrected hand corpus contains 22 positives and 71 negatives. Phase 0
mechanically reproduced all 17 Section 15 worked vectors, classified 256/256
tag octets, and retained five declared unequal pairs. Stable fixture hashes:

```text
f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce  positive JSONL
6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5  negative JSONL
ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27  distinct pairs
ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98  budgets
4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13  fixture schema
```

After integration hardening, the language-local suites passed 2,510 Common
Lisp assertions and 152 Python tests. The retained first process differential
sent the same 353 requests to each codec: 22 positives, 71 negative
dispositions, all 253 equality pairs, and seven retained regression cases. It
reported zero warranted disagreement and empty stderr. Summary SHA-256:

```text
69b0b9025db187074ebcca4252bd2b02c5072211ff3a8fe0d63b39c65914f6b0
```

The bounded Phase-4 default run passed 353 goldens, 512 deterministic randomized
round trips, 513 equality/encoding properties, 14 classified hostile/resource
failures, and six retries, with zero warranted disagreement. It also exercised
Python hash seeds 0/1/137/777 with the 640-digit ambient guard, Common Lisp
printer/package/readtable perturbations, mutation probes, selected inertness
guards, and 1,024 Common Lisp concurrent observations. Summary SHA-256:

```text
88ed013ef71690b174627730c0c85ea51d5a28b61181bdeef08bfdd2d09a0a57
```

Do not overread those counts. That bounded Phase-4 run explicitly did not consume
the release corpus. The later release run did, with this retained evidence:

```text
manifest source revision: aed2f393781456dfd495ac5d5822bdcd58bea711
generator seed: 3439329281
exact command: python3 canonical-datum/generator/generate_corpus.py --output-dir canonical-datum/generated/release-v0 --seed 3439329281 --positive-count 10000 --negative-count 20308 --mutation-sample-count 128 --truncation-max-document-octets 16
positive count: 10,000
classified negative/adversarial count: 20,308 (20,000 demonstrated byte-deletion-primary-minimal plus 308 coverage cases)
unlabelled mutation-candidate count: 30,504
sufficient-budget retries: 20,012
corpus digest: 83e35b3ac9641e06a6573fbec404149ca78130ca0a0ff9d550ff693dbdd819be
manifest sha256: 2b3fee981a2db8f46a03909d8a7c1a505248875b5a8aa9686e0afcef0f8410c3
determinism rerun: PASS; PYTHONHASHSEED=1 and 777 produced all six files byte-identically
requests handled by Common Lisp: 100,824 in 50 batches
requests handled by Python: 100,824 in 50 batches
warranted disagreements: 0; mutation minimizations required: 0
provisional/N/A observations: 5 provisional-stage plus 1 provisional-code release rows; 3 Common Lisp language-specific host rows N/A, not pass
release result: PASS; all 100 stderr files empty
release summary sha256: 66b6122d4145e97c59b931d2e90be041e7094329b1a72df7586ac7bbf3799232
final qualification: PASS; same 100,824 requests per codec
final qualification summary sha256: 5580c47e6bce23001e93b8259e6d9c6e432c6a25dcbcb25ee298821dd93fa585
final v1 gate: PASS; 6/6 mneme/verify-all.sh checks
final v1 transcript sha256: da89c3155729b77f6ba8de6a219b5ebae5bd7c3bd25ee1406234331cf2f83c1c
final changed-path audit: PASS; only canonical-datum/**, CANONICAL-DATUM-DIVERGENCES.md, and CD0-IMPLEMENTATION-LEDGER.md changed through the verified checkpoint
archive: canonical-datum/evidence/artifacts/cd0-release-2026-07-13.tar.gz
archive sha256: see the sibling .sha256 file and the external handoff
```

Treat `CANONICAL-DATUM-DIVERGENCES.md` as an append-only open-questions ledger.
A1–A9 are not adjudicated by implementation agreement:

- A1: failure-stage matrix is incomplete;
- A2: constructor/import failure triples are incomplete;
- A3: exact integer-bit accounting is unspecified;
- A4: identifier segment limit may be aggregate or per side;
- A5: simultaneous resource-failure precedence is incomplete;
- A6: record-key versus nested-tag failure precedence is unclear;
- A7: fixture AST lacks an unreduced-rational construction form;
- A8: record-key work octets are not counted exactly;
- A9: encoder application of non-output budgets is underspecified.

Of the 71 hand negative rows, 59 have a warranted complete triple, 11 have a
provisional stage under A1, and one has a provisional code under A2. Matching
provisional fields are observations, not normative convergence.

Common Lisp executes 68 hand negative rows. These three language-specific host
descriptors are N/A—not passes—because its optional generic importer surface is
not exposed:

```text
cd0-neg-host-ambiguous-identifier
cd0-neg-host-bool-as-integer
cd0-neg-host-privileged-value
```

The two implementations deliberately retain different documented A9 runtime
encoder-budget choices. Please flag any test or prose that launders this into a
normative match.

The seven integration regressions are classified and retained, but “minimized”
must be read carefully: some are compact/resource-threshold stressors rather
than globally byte-minimal hostile documents. In particular, the 5,000-digit
bounded-preflight case is a stress boundary; the 641-digit CPython ambient-guard
case is minimized to the smallest allowed nonzero ambient threshold.

Please prioritize this review checklist:

1. Recompute the spec, fixture, corpus, manifest, transcript, and archive hashes.
2. Confirm all three branch ancestries start at fetched `ae767f0`, and that seed
   commits predate cross-reading/integration.
3. Audit all nine family representations for disjointness and alias severance.
4. Check encoder/decoder grammar against the specification rather than against
   the other implementation.
5. Verify record sorting uses canonical Identifier `ValueBytes`, rejects
   duplicates, and never relies on host dictionary/package/symbol order.
6. Verify strict UTF-8, minimal UVAR, zigzag, normalized rational, reserved and
   forbidden tag, full-input, and resource-precedence behavior.
7. Confirm every permanent failure assertion is limited to warranted fields;
   keep A1/A2 fields provisional and A3–A9 local.
8. Inspect the release generator's determinism, clean-source provenance,
   coverage assertions, derivation/minimization claims, and successful default
   retry for resource-derived negatives.
9. Run the release differential independently. Broad multi-defect mutations
   must remain unlabelled until minimized to a primary defect.
10. Confirm privileged-looking records remain inert and that mutation probes
    actually mutate every caller-owned mutable source/accessor path claimed.
11. Re-run `mneme/verify-all.sh` and audit the fetched-base-to-tip changed paths;
    no existing v1 runtime or semantic artifact should have changed.
12. Keep portability findings separate: only SBCL 2.4.6 and CPython 3.11.14 were
    executed. Do not weaken normative results to accommodate an untested host.

Primary evidence documents:

```text
CD0-IMPLEMENTATION-LEDGER.md
canonical-datum/evidence/CD0-IMPLEMENTATION-RECEIPT-2026-07-13.md
CANONICAL-DATUM-DIVERGENCES.md
canonical-datum/evidence/COMMON-LISP-SEED-SOURCE-ACCESS.md
canonical-datum/evidence/PYTHON-SEED-SOURCE-ACCESS.md
canonical-datum/evidence/INTEGRATION-SOURCE-ACCESS.md
canonical-datum/evidence/INTEGRATION-CONVERGENCE-VERIFICATION.md
canonical-datum/qualification/QUALIFICATION-VERIFICATION.md
canonical-datum/evidence/RELEASE-CORPUS-VERIFICATION-2026-07-13.md
canonical-datum/evidence/FINAL-VERIFICATION-TRANSCRIPT-2026-07-13.md
```

Known portability/non-claim boundary: no CCL, ECL, CLISP, ABCL, Roswell, PyPy,
other Python version, or other OS was run. Finite hook instrumentation is not a
proof over every FFI/syscall. Canonical identity is not truth, authority,
custody, authenticity, verified lineage, or semantic validity. v1 migration,
claim identity, as-of targeting, warrant/capability semantics, receipt
transitions, Language A, cryptographic choices, and module/procedure identity
remain out of scope.

Please report findings by severity with exact file/line references, minimal
witnesses, the specification sections involved, and whether each finding is a
Common Lisp defect, Python defect, specification ambiguity, fixture defect, or
host-assumption leak. Do not repair a disagreement merely by making one codec
imitate the other.

---
