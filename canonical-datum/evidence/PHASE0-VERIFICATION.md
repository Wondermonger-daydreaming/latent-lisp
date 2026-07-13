# CD/0 Phase 0 verification record

> **Historical record.** This file preserves the original Phase-0 state and
> hashes. Its provisional A1/A2 statements are superseded by
> `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`. See
> `canonical-datum/evidence/PHASE0-CORRECTION-VERIFICATION.md` for the prior
> correction and `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md` for the current
> executed/N/A/failure/skip/classified accounting.

This is finite executable evidence for the hand-authored Phase-0 artifacts, not
a claim that either codec already exists or conforms.

## Obligations and evidence

| ID | Obligation | Artifact/evidence | Status | Residual boundary |
|---|---|---|---|---|
| P0-1 | Pin the normative revision before work | SHA-256 command and source-access log | satisfied | SHA-256 identifies bytes, not authorship |
| P0-2 | Translate every Section 15.15 worked vector | exactly 17 positive JSONL rows | satisfied | finite worked examples only |
| P0-3 | Mechanically verify worked hex | spec-table extraction plus independent fixture-AST encoder | satisfied | verifier is not a decoder or codec |
| P0-4 | Supply compact negative coverage | 55 negative JSONL rows and explicit coverage assertions | satisfied | A1--A9 ambiguous cases remain blocked |
| P0-5 | Preserve ambiguities rather than choose silently | root divergence ledger | satisfied | adjudication remains external |
| P0-6 | Preserve clean-room source access | source-access log | satisfied | procedural assertion, not OS-level information-flow proof |

## Exact commands and observed results

Baseline gate:

```text
$ sha256sum mneme/spec/CANONICAL-DATUM-SPEC.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md

$ git rev-parse HEAD
ae767f00975395369f9a91283a954f0963fb6724
$ git rev-parse HEAD^{tree}
b8f5be6d532eafe5be0d1f342347fa10f5f39352
$ sbcl --version
SBCL 2.4.6
$ python3 --version
Python 3.11.14
```

Phase-0 fixture audit:

```text
$ python3 canonical-datum/tools/verify_phase0.py
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
worked vectors: 17/17 exact and grammar-derived encodings agree
negative vectors: 55 structurally valid; required compact coverage present
type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present
sha256 16e7a68c52b5973910180b90666dd28209d60b4c383e117517ef2e3e4c7e5373  canonical-datum/vectors/cd0-positive.jsonl
sha256 3bb0f1268cf0a7b4f1097180bb7c47b030299cca733b36575f556911e42fc5d4  canonical-datum/vectors/cd0-negative.jsonl
sha256 88c30a7c0c3278be34e4ef262a270bb78a94d1aade28190df1bc946faf597653  canonical-datum/vectors/cd0-budgets.json
sha256 7d3c04fa322e8eaaca78d8f9b7517fb922df935fe14e28c1d7f975a18d80f1bd  canonical-datum/schema/cd0-fixtures.schema.json
```

The verifier derives UVAR, zigzag, UTF-8 framing, identifier framing, sequence
framing, and canonical record sorting directly from the pinned specification.
It also extracts the 17 hexadecimal cells from Section 15.15 and requires exact
ordered agreement.  It intentionally implements no document decoder.

## Out of scope and deliberately not performed

- no Common Lisp or Python codec implementation;
- no differential comparison;
- no generated 10,000/20,000 release corpus;
- no v1 migration or behavior change;
- no adjudication of A1--A9;
- no remote push.
