# Paste-ready Claude relay — Lisp+ Canonical Datum /0

Relay status: **pre-release draft**. Do not paste as a completion handoff until
all `{{CD0_*}}` fields are replaced from retained evidence.

Draft provenance: hashes for the specification, hand artifacts, and retained
Phase-2/Phase-4 summaries were recomputed in the documentation worktree. Git
objects, JSONL/status/input-kind counts, summary fields, and retained
152-test/2,510-assertion lines were directly inspected. Other runtime outcomes
are explicitly relayed from committed execution receipts and were not rerun by
the documentation-only drafting step.

---

Please review the Lisp+ Canonical Datum /0 implementation as an implementation
and conformance audit, not as a redesign exercise.

Repository:
`https://github.com/Wondermonger-daydreaming/latent-lisp.git`

Remote branches after the authorized push:

- Common Lisp: `{{CD0_COMMON_LISP_REMOTE_REF}}` at
  `{{CD0_COMMON_LISP_FINAL_COMMIT}}`
- Python: `{{CD0_PYTHON_REMOTE_REF}}` at `{{CD0_PYTHON_FINAL_COMMIT}}`
- integration: `{{CD0_INTEGRATION_REMOTE_REF}}`; verified source/evidence
  checkpoint `{{CD0_VERIFIED_CHECKPOINT_COMMIT}}`, tree
  `{{CD0_VERIFIED_CHECKPOINT_TREE}}`
- push observation: `{{CD0_PUSH_RESULT}}`

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
generator correction: {{CD0_GENERATOR_CORRECTION_COMMIT}}
release runner source: {{CD0_RELEASE_RUNNER_SOURCE_COMMIT}}
release corpus commit/tree: {{CD0_RELEASE_CORPUS_COMMIT}} / {{CD0_RELEASE_CORPUS_TREE}}
release differential commit: {{CD0_RELEASE_DIFFERENTIAL_COMMIT}}
verified checkpoint commit/tree: {{CD0_VERIFIED_CHECKPOINT_COMMIT}} / {{CD0_VERIFIED_CHECKPOINT_TREE}}
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

Do not overread those counts. The Phase-4 run explicitly did not consume the
release corpus. Its completion evidence is separately recorded as:

```text
manifest source revision: {{CD0_RELEASE_SOURCE_REVISION}}
generator seed: {{CD0_RELEASE_SEED}}
exact command: {{CD0_RELEASE_COMMAND}}
positive count: {{CD0_RELEASE_POSITIVE_COUNT}}
classified negative/adversarial count: {{CD0_RELEASE_NEGATIVE_COUNT}}
unlabelled mutation-candidate count: {{CD0_RELEASE_MUTATION_COUNT}}
corpus digest: {{CD0_RELEASE_CORPUS_SHA256}}
manifest sha256: {{CD0_RELEASE_MANIFEST_SHA256}}
determinism rerun: {{CD0_RELEASE_DETERMINISM_RESULT}}
requests handled by Common Lisp: {{CD0_RELEASE_REQUESTS_CL}}
requests handled by Python: {{CD0_RELEASE_REQUESTS_PY}}
warranted disagreements: {{CD0_RELEASE_WARRANTED_DISAGREEMENTS}}
provisional/N/A observations: {{CD0_RELEASE_PROVISIONAL_OBSERVATIONS}}
release result: {{CD0_RELEASE_DIFFERENTIAL_RESULT}}
release summary sha256: {{CD0_RELEASE_DIFFERENTIAL_SUMMARY_SHA256}}
final qualification: {{CD0_FINAL_QUALIFICATION_RESULT}}
final qualification summary sha256: {{CD0_FINAL_QUALIFICATION_SUMMARY_SHA256}}
final v1 gate: {{CD0_FINAL_V1_RESULT}}
final v1 transcript sha256: {{CD0_FINAL_V1_TRANSCRIPT_SHA256}}
final changed-path audit: {{CD0_FINAL_CHANGED_PATH_AUDIT}}
archive: {{CD0_ARCHIVE_PATH}}
archive sha256: {{CD0_ARCHIVE_SHA256}}
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
{{CD0_RELEASE_RECEIPT_PATH}}
{{CD0_FINAL_VERIFICATION_TRANSCRIPT_PATH}}
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
