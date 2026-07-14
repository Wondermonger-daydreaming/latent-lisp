# CD/0 release-corpus verification — 2026-07-13

Factual status: retained release-scale generation and differential-execution
evidence. This receipt does not amend the normative specification, adjudicate
A1--A9, prove portability beyond the recorded hosts, or migrate v1.

## Authority and clean execution boundary

The sole normative artifact was
`mneme/spec/CANONICAL-DATUM-SPEC.md`, observed as SHA-256
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.

The generator ran twice from clean integration source commit
`aed2f393781456dfd495ac5d5822bdcd58bea711`, tree
`7f8d2a2d11dd70d1143dc5c339267fe97c675670`. The retained manifest records
`clean_before=true`, an empty status transcript, and no dirty-source override.
The release differential ran after the corpus was committed at
`42a71429cfdafe63a989e3f44e706f828efab20e`, tree
`947444fde812754ac8e04bb5a0fbe29f690df3d0`, with a clean worktree before the
evidence directory was created.

Executed hosts:

- SBCL 2.4.6;
- CPython 3.11.14.

The exact loaded source boundary was recorded immediately before generation:

| Source | SHA-256 |
|---|---|
| Common Lisp package | `45df264f7946f041a409f124da333719f6b20ffef22078725acfefc5ad4a4576` |
| Common Lisp codec | `ceba52459f9a62a594f10e1cbc8e6587915ac88cf01cf945ae210dea56fb4f33` |
| Common Lisp test/parser support loaded by adapter | `6b1041a83a5349251288dd3f22222865a493b3ade7cc6953f850b19550c5d0ae` |
| Common Lisp process adapter | `5caa574534c3dc0d1975138abb228e6735807ca20dcc7da1c4c7c95887cc092c` |
| Python codec | `f821934129779dab0908134377b9a81b2ab33f1fd995fd2451031b5bc0e99fba` |
| Python process adapter | `3b1d8017ed3a6cad375b6604e9fdcf2c01b9bdc5bccf3b336f95140abaf71db9` |
| Corpus generator v3 | `3f8f7ed0f3da322aaa116afbe8b7185679ca614cac55788dfdade7e7df94492e` |
| Release differential runner | `5c8c6b3e7cf8e6fe01fc5b0923ea84e9b4fbf1cf6113d1f07475cf02ea56f9a8` |

## Deterministic release generation

The exact logical generator command was:

```text
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir canonical-datum/generated/release-v0 \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20308 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

It was executed once with `PYTHONHASHSEED=1`, moved intact outside the
worktree, and executed again from the same clean commit with
`PYTHONHASHSEED=777`. `diff -qr` reported no difference. Every artifact and the
manifest were byte-identical. The retained release directory is
`canonical-datum/generated/release-v0`.

Observed release counts:

- 10,000 unique positive canonical datums;
- 20,308 classified adversarial rows;
- exactly 20,000 mechanically verified
  `byte-deletion-primary-minimal` rows;
- 308 additional authored/host coverage rows;
- 20,012 resource rows with verified sufficient-budget retries;
- 30,504 unclassified mutation candidates;
- nine host-property scenario descriptors and fourteen resource-boundary
  descriptors.

The 20,308 failure statuses are 20,302 normative complete triples, five
`provisional-blocked-stage` rows, and one `provisional-blocked-code` row. The
provisional fields remain observations rather than normative adjudications.

Stable release hashes:

| Artifact | SHA-256 |
|---|---|
| Manifest | `2b3fee981a2db8f46a03909d8a7c1a505248875b5a8aa9686e0afcef0f8410c3` |
| Corpus digest | `83e35b3ac9641e06a6573fbec404149ca78130ca0a0ff9d550ff693dbdd819be` |
| Positive JSONL | `2e10bf3807480ee78144ed807a24c4e22882665823f3ab4f124acb9061ae8cd8` |
| Negative JSONL | `e57d0d49acf6ce13570ffb8e889d70cb06f023d2ae8a47b3ea8622e5e6d427a5` |
| Negative derivations | `2ffd77257e18dfbc70abef0cc5fae1603d50b1a8b005226af95200708c29ca02` |
| Mutation candidates | `5473a4fade005746d674e442b71501bb828ea75af6aa6c0f81d9549b6c8566b8` |
| Host/resource scenarios | `6fdd3550a2455f2d69eb0ace440a9a74d5e4d1646b1c396b4822d12ab1c2f2fe` |

## Full Common Lisp/Python differential

Exact command:

```text
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir canonical-datum/generated/release-v0 \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir canonical-datum/evidence/generated-differential-release-v0
```

Observed result: `PASS`.

- 100,824 requests executed by each codec in 50 bounded batches;
- 10,000 positive construct/decode/re-encode/AST/equality checks;
- 20,000 deterministic equality judgments (10,000 self and 10,000 ring
  neighbors), including equality iff canonical bytes;
- 20,308 classified negative dispositions;
- 20,012 full sufficient-budget retry decodes, with exact canonical bytes and
  normalized fixture AST agreeing across codecs;
- 30,504 unclassified mutation candidates: 455 identical exact-canonical
  successes and 30,049 identical complete failure triples;
- zero warranted comparison issues;
- zero mutation cases requiring minimization;
- every one of the 50 Common Lisp stderr files and 50 Python stderr files was
  empty.

Common Lisp executed 20,305 negative rows. Python executed all 20,308. The
three optional/language-specific Common Lisp importer rows remain explicitly
N/A and do not count as passes. The summary separately retains the five A1
provisional-stage rows and one A2 provisional-code row.

Exact retained evidence comprises 252 files (approximately 129 MiB) under
`canonical-datum/evidence/generated-differential-release-v0`. The summary is
SHA-256
`66b6122d4145e97c59b931d2e90be041e7094329b1a72df7586ac7bbf3799232`.
The empty mutation-disagreement ledger is SHA-256
`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

## Evidence boundaries

- Agreement does not adjudicate A1--A9. Only normatively warranted failure
  fields count toward convergence.
- Random multi-defect mutation candidates remain unlabelled. Exact success was
  accepted only when decoding reproduced the candidate bytes and both codecs
  returned the same normalized AST.
- The nine host scenarios and fourteen resource descriptors are metadata in
  this corpus. Equivalent cycle/improper-list negative rows ran here; the
  remaining mutation, inertness, sharing, ambient-state, and resource probes
  are owned by the separately retained Phase-4 qualification evidence.
- No Common Lisp implementation other than SBCL and no Python implementation
  other than CPython 3.11.14 was available.
- This receipt does not yet claim the final qualification rerun, v1 regression
  gate, archive, or remote push; those belong to later checkpoints.
