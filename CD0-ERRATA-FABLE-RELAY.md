# CD/0 Errata 0.1 targeted Fable relay

> Focused return note: Fable protocol `49b3cf88` returned only §3-A9's two
> missing shared-vector instantiations. The paste-ready resubmission is now
> `CD0-A9-FABLE-FOCUSED-RELAY.md`. The original relay below remains preserved as
> review history; its 37/465/100,861 arithmetic describes the first submission.

Date: 2026-07-13

This is a copy/paste-ready handoff for another reviewer or model instance. It is
deliberately explicit about what was changed, what was executed, what remained
N/A, and what is not claimed. Publication, archive, and independent-review
receipts may append later commit/hash facts without changing this local evidence
account.

## Review request

Review the successor CD/0 Errata 0.1 patch as a narrow conformance repair from
audited integration commit `baeecd5e0347435b9e1362000344f46ea441c6ec`
(tree `41d3a71c06692174701bfde8f071e7da1c719651`). Do not treat this as a
request to redesign CD/0, change bytes/equality, add types, alter the wire
grammar/version, migrate v1, or decide unrelated Mneme semantics.

Normative inputs and exact SHA-256 values:

```text
CD0-POST-IMPLEMENTATION-RULING.md
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc

CANONICAL-DATUM-SPEC-ERRATA-0.1.md
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271

mneme/spec/CANONICAL-DATUM-SPEC.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
```

The pre-change repository/remote/runtime capture is retained at
`canonical-datum/evidence/baselines/CD0-ERRATA-PRECHANGE-BASELINE-2026-07-13.md`,
SHA-256
`5ace3291811f2131a50e1ff6afe281e7bc4a251dd3dd50771bcd8a54894318bb`.

Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.

Independence anchors are the seed commits, not corrected tips:

```text
Common Lisp seed e6f3b579742f5fcff0d82477d07f8c0c9ee34df3
Python seed      58ecca4083275ebfe16605765e575bfb9f6eb755
```

Audited evidence-bearing tips remain immutable:

```text
Common Lisp 45eb60ce5b80485a0b287feab53ed3b58643b1b0
Python      29d0946ad78347015b9f0c65a2f528f039fdca78
Integration baeecd5e0347435b9e1362000344f46ea441c6ec
```

Those audited codec tips are seed plus bounded corrections authored after
cross-reading was authorized and then backported. They remain provenance, not
independence anchors.

## Successor branches

```text
codex/cd0-common-lisp-errata-0.1
codex/cd0-python-errata-0.1
codex/cd0-integration-errata-0.1
```

At the local evidence stage, the codec successor commits were:

```text
Common Lisp ee3baa9ab504f65d39015f212050748fd300160a
tree        ecf5261c41ad24199325ab56cbf6c39e83cddbc6

Python      9f46a32351095dc1a52724a31574e0b9e62ed221
tree        f065acfe6bb56365946a20e131edcfbf351b06f4
```

The clean generator/qualification source checkpoint was integration commit
`bdb2214878ebb302329a40e895269ff950b8ae97`, tree
`46253ae9bfcfd37b2e481fbe8cfd0e8ad9553d09`. The final archive-source and
publication-envelope commits are recorded in the later archive/remote receipts
because a Git commit cannot contain its own hash.

No branch was merged into `main`.

## What changed

1. A1: both decoders now use `count` when a declared count promises an item,
   field key/value, or identifier segment whose first octet is absent. Depth and
   node resource stages are `type-tag`; output refusal is `allocation`.
2. A2: Common Lisp constructor/importer invariant failures changed category from
   `InvalidCanonicalGrammar` to `UnsupportedHostInput`, retaining the specific
   code and `host-import`. Python already matched and was not changed merely for
   symmetry.
3. A3: magnitude is `bit_length(abs(component))`, zero is zero bits, and
   rational construction checks supplied components before reduction.
4. A4: identifier segment budgets aggregate namespace plus path.
5. A5: resource precedence is depth, nodes, local magnitude/count/length, then
   aggregate payload.
6. A6: a record key starting `f0..ff` retains
   `ForbiddenPrivilegedTag` precedence.
7. A7: rational source construction uses a closed `{op,p,q}` descriptor distinct
   from the normalized abstract datum fixture. Both fixture adapters implement
   it. Python translates allocation/stack exhaustion across the complete
   descriptor entry point.
8. A8: complete canonical Identifier `ValueBytes` is counted exactly once per
   field occurrence, independent of sorting comparisons. Both runtime encoders,
   and Python fixture import, compute the exact length without constructing the
   complete key buffer and refuse an exceeded budget before materialization.
9. A9: Common Lisp runtime encoding of an already-valid datum stopped reapplying
   structural decode/import limits. Runtime encoding now enforces only output,
   record-key work, and actual host allocation, matching Python’s already-valid
   behavior.

The shared fixture schema moved to revision 0.1. There are 25 positive rows, 71
classified negative rows, and a separate 37-operation A1–A9 manifest with SHA
`55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc`.

## Before/after load-bearing witnesses

Before, Common Lisp returned:

```text
A2-zero-denominator InvalidCanonicalGrammar/ZeroDenominator/host-import
A2-empty-segment    InvalidCanonicalGrammar/EmptyIdentifierSegment/host-import
A2-missing-path     InvalidCanonicalGrammar/MissingIdentifierPath/host-import
A2-duplicate-field  InvalidCanonicalGrammar/DuplicateRecordField/host-import
A9 [Unit], depth=1  ResourceRefusal/ExcessiveNesting/type-tag
```

Python already returned the authorized A2 categories and A9 success. After the
patch, both return:

```text
A2-zero-denominator UnsupportedHostInput/ZeroDenominator/host-import
A2-empty-segment    UnsupportedHostInput/EmptyIdentifierSegment/host-import
A2-missing-path     UnsupportedHostInput/MissingIdentifierPath/host-import
A2-duplicate-field  UnsupportedHostInput/DuplicateRecordField/host-import
A9 [Unit], depth=1  OK 4c50434400300100
```

Both old decoders used `type-tag`, `record-key`, or `length` for count-promised
EOF witnesses. Both now return
`InvalidCanonicalGrammar/TruncatedInput/count`.

Test-first history is preserved. Integration red commit
`7a8c1be532da2a0dd3b13d281bdc84edfe26a1ca` precedes semantic commits
`9d7f8ad2ee3a124046d05538cd9ee23bbe561318` (Common Lisp) and
`6a369f77511fbadb1e2c2c06953b6b27e66734d0` (Python). Equivalent red commits
precede each codec-branch repair. A later generator-metadata red test at
`b18ccab…` caught an over-broad human-readable note; the correction changes no
input, expected triple, or codec behavior.

A later targeted code review found two in-scope allocation-order defects.  The
preserved red witnesses were:

```text
Python A7 descriptor-key validation -> raw MemoryError
Common Lisp A8 runtime budget 0     -> AllocationRefused/allocation; materializer calls 1
Python A8 runtime budget 0          -> AllocationRefused/allocation; materializer calls 1
Python A8 fixture import budget 0   -> AllocationRefused/allocation; materializer calls 1
```

Tests-only commits `97d18f6f…`, `f9c53de4…`, and integration `9334ea5e…`
precede repairs `ee3baa9a…`, `9f46a323…`, and integration `e3612bd6…`.
Afterward A7 yields `ResourceRefusal/AllocationRefused/allocation`; A8 yields
`RecordKeyWorkBudgetExceeded/encode-ordering` for runtime encoding and
`.../host-import` for fixture import, with materializer calls `0`.  UTF-8 scalar,
127/128 UVAR, segment-count, wide-key, and nested-operation probes independently
matched the materialized canonical lengths.

## Exact test and request results

Phase-0 is not “71 passed”:

```text
71 classified = 66 octet + 5 host
Python:      71 executed, 0 N/A, 0 failures, 0 skips
Common Lisp: 68 executed, 3 language-specific N/A, 0 failures, 0 skips
```

N/A is neither pass nor failure.

Local verification summary:

```text
Phase-0 verifier:            PASS
Common Lisp complete suite:  PASS, 2,633 assertions
Python complete suite:       PASS, 167 tests
Generator suite:             PASS, 28 tests
Release-runner suite:        PASS, 9 tests
Qualification self-tests:    PASS, 9 tests
Hand differential:           PASS, 465 requests/codec, 0 issues
Release differential:        PASS, 100,861 requests/codec, 0 issues
Bounded property matrix:      PASS, 1,045 requests/codec, 0 warranted disagreements
v1 gate:                      PASS, 6/6 suites
Corpus regeneration:         two full runs byte-identical under hash seeds 1/777
```

Hand arithmetic per codec:

```text
25 positive + 71 negative + 325 equality + 7 regression + 37 errata = 465
```

Errata arithmetic:

```text
A1=6 A2=5 A3=6 A4=3 A5=3 A6=2 A7=1 A8=6 A9=5 = 37
```

Release arithmetic per codec:

```text
10,000 positive
+20,308 classified negative
+20,000 equality
+20,012 retries
+30,504 unclassified mutations
+    37 promoted errata
=100,861
```

Mutation outcomes: 30,049 same-complete-triple failures plus 455
both-success-identical; disagreement ledger empty. Python executes all 20,308
release negatives. Common Lisp executes 20,305 and records the same three
optional-importer N/A dispositions.

Bounded qualification executed 512 random round trips, 513 equality properties,
14 complete classified failures, and six resource retries. Python ran seven
mutation probes; Common Lisp ran eleven plus 1,024 concurrent read/encode pairs.
Both inertness probes observed zero activation calls.

## Protected invariants

The hand historical comparator found zero changes over 22 positives, 71
negative dispositions, 253 equality judgments, and seven regressions per codec.

The release hard gate compared all 10,000 audited valid rows and found:

```text
canonical-octet changes 0
abstract-datum changes  0
decoded-AST changes     0
equality-class changes  0
```

Baseline and current valid projections both hash to
`21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.
No file under `mneme/` changed from the audited integration tip, and the v1 gate
remains 6/6 green.

## Corpus and evidence navigation

Read these in order:

1. `CD0-POST-IMPLEMENTATION-RULING.md`
2. `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`
3. `CD0-ERRATA-IMPLEMENTATION-LEDGER.md`
4. `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md`
5. `CD0-ERRATA-DIFFERENTIAL-RECEIPT.md`
6. `CD0-ERRATA-RELEASE-RECEIPT.md`
7. `CANONICAL-DATUM-DIVERGENCES.md` closure addendum
8. `canonical-datum/vectors/cd0-errata-0.1.json`
9. `canonical-datum/evidence/transcripts/phase2-errata-0.1/summary.json`
10. `canonical-datum/evidence/generated-differential-errata-0.1/summary.json`
11. `canonical-datum/qualification/evidence/errata-final-run/summary.json`
12. archive, checksum, independent-review, and remote-read-back receipts in the
    targeted packet.

Corrected corpus facts:

```text
source commit  bdb2214878ebb302329a40e895269ff950b8ae97
source tree    46253ae9bfcfd37b2e481fbe8cfd0e8ad9553d09
corpus digest  62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58
manifest SHA   9b0865c559cdcdfaa850a8fa5e8e7ac47916059ac0516427322f3cf9d0c81fbc
hand summary SHA
                3c62572cb962c5fb4ab8395937901355ea54f0664032ad2a7ccdaa6f937396c4
release summary SHA
                44e1b9edb7dac1f89124d52559c3fc7368b26e3340e487379f389b85bfb0b422
qualification summary SHA
                ffaeb38ed61777980b2313d4d8bf1a1c8c27ea8a658a8ba53ac95bca0aec429b
```

The corpus regenerated byte-identically. The 30,504 mutation-candidate scale is
retained by adding 22 A7-linked hand truncations and displacing 22 redundant
configured-tail truncations. Candidates remain unclassified. Review this as an
authorized-vector-scoped selection consequence, not a change to valid generator
semantics.

## Targeted reviewer checklist

- Recompute the three normative SHA-256 values.
- Confirm audited tips remain ancestors and were not rewritten.
- Inspect exact diff/bundle from `baeecd5e…` to the archive source commit.
- Execute all 37 A1–A9 vectors against both codecs and confirm the 6/5/6/3/3/2/1/6/5 decomposition.
- Reproduce the Common Lisp A2 and A9 before/after witnesses.
- Check A7 keeps construction metadata separate from normalized abstract data.
- Check Phase-0 arithmetic preserves 71 classified, Python 71 executed, Common
  Lisp 68 executed plus three N/A, with failures/skips separately zero.
- Inspect or rerun the 465-request hand differential and the 100,861-request
  release differential.
- Confirm the 10,000-row protected-invariant hard gate is all zero.
- Run `bash mneme/verify-all.sh` and confirm 6/6.
- Confirm the four documentation LOW repairs: concrete A2 split; seed-versus-tip
  backport provenance; depth/node `type-tag`; conspicuous old-Phase-0 forward
  pointer.
- Explicitly assess the bounded 22-for-22 mutation selection and reproduce the
  repaired A7/A8 allocation-injection properties.  The former remains
  unclassified selection metadata; the latter must show deterministic
  key-work refusal before complete key materialization.
- Verify archive reproduction, checksum manifest, and non-force remote read-back.

## Claim boundary

No merge is claimed. No located-claim, warrant, capability, receipt, module,
effect, cryptographic, custody, or lineage semantics were changed. Canonical
identity is not asserted to be truth or authority. Generated receipts include
local paths/timings and are observations of this run; only explicitly
reproduced archives/corpus members carry byte-identity claims.

If the exact diff, archive, remote receipt, and targeted independent review all
agree with the facts above, the successor integration state is eligible for
targeted independent verification. Any nonzero byte/equality/accepted-document,
v1, or unrelated-source change is a hard stop requiring renewed adjudication.
