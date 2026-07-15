# DE-CORROBORATIONE 0.4-A authorial acceptance merge receipt

Recorded: 2026-07-15T19:20:43-03:00

## Bounded standing

```lisp
(:authorially-accepted t
 :verified-by-successor-lineage t
 :third-party-verification :not-performed
 :class :interbench-hinge
 :decad-member-p nil
 :standing :accepted-bounded-specimen
 :totality :not-claimed)
```

No third independent chair was available. That absence is a residual
verification limitation. It is not represented as completed third-party review
and does not erase the completed Fable-to-Codex successor lineage.

Production integration is not authorized beyond admitting this bounded atelier
specimen.

## Exact repository identities

| Object | Commit | Tree |
|---|---|---|
| Current authoritative `origin/main` before merge | `5ae55d799c8f253926eaf91af9feda4a868e4fc8` | `7bd80217af438061eb4c613afbb8682f0ce9dcb0` |
| Verified branch tip | `daf593deaeeb0669c504c00c119abe765fd3d08d` | `605c30371a6f1dbdb3644dd4c48b1d56d2c8ff93` |
| Verified implementation | `51fb24c79fdeceb851c69c20d121932d7b38d724` | `cbe27e1ae60967db0ffc5da5501751d4b9cc8c9e` |
| Explicit acceptance merge | `197be4bcad4355f0694539a0bb6d9b8c2c73233d` | `605c30371a6f1dbdb3644dd4c48b1d56d2c8ff93` |

The merge parents are, in order:

```text
5ae55d799c8f253926eaf91af9feda4a868e4fc8
daf593deaeeb0669c504c00c119abe765fd3d08d
```

The merge tree is exactly the verified branch tree. The explicit merge
therefore preserved the complete two-commit verified ancestry and introduced no
conflict-resolution edits, squash, rebase, regeneration, or semantic repair.

## Exact changed-file inventory

The explicit merge introduced these 12 accepted files relative to its first
parent, all as mode `100644` additions:

```text
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-CONDITION-COVERAGE.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-CONFORMANCE-ADJUDICATION.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-FABLE-DELIVERY-IDENTITY.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-FILE-INVENTORY.txt
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-FINAL-VERIFICATION-TRANSCRIPT.txt
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-IMPLEMENTATION-LEDGER.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-PRE-REPAIR-REPRODUCTION.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/DE-CORROBORATIONE-REPLAY-VERIFICATION.md
mneme/atelier/evidence/de-corroboratione-0.4a-verification/SHA256SUMS.txt
mneme/atelier/evidence/de-corroboratione-0.4a-verification/de-corroboratione.FABLE-DELIVERED.lisp.txt
mneme/atelier/evidence/de-corroboratione-0.4a-verification/de-corroboratione.FABLE-DELIVERED.transcript.txt
mneme/atelier/hinges/de-corroboratione.lisp
```

This receipt is the sole 13th file on the final merge-candidate branch. It is
committed after the explicit merge because a commit cannot truthfully embed its
own commit identity. No existing verification evidence was modified.

Protected-scope comparison was empty for:

```text
mneme/lci0
mneme/latent-mvp
mneme/atelier/kernel
mneme/atelier/instruments
mneme/atelier/toys
mneme/atelier/reliquaries
mneme/language-a
mneme/canon
mneme/spec
mneme/verify-all.sh
```

Thus the merge contains no unauthorized change to LCI/0 or CD/0 production
semantics, Mneme kernel semantics, accepted fixtures or vectors, canonical
bytes, unrelated atelier instruments, or frozen authority documents.

## Verification commands and results

```text
git fetch --all --prune
```

Exit 0. Remote verified tip resolved exactly to `daf593d...`; implementation
commit `51fb24c...` existed as a commit; `origin/main` resolved to `5ae55d7...`.

```text
sha256sum -c SHA256SUMS.txt
```

Exit 0. All 10 listed evidence entries returned `OK` before and after merge.

```text
sbcl --noinform --disable-debugger --script mneme/atelier/hinges/de-corroboratione.lisp
```

Two fresh post-merge processes exited 0. Each emitted 10,099 bytes with SHA-256
`c227d96a6f2483878a8b907793db9861b722c46c3a2698665d0198d404534d0a`.
The processes were byte-identical to one another and to
`DE-CORROBORATIONE-FINAL-VERIFICATION-TRANSCRIPT.txt`. The transcript reports
all 40 mandatory typed conditions exercised.

```text
python3 mneme/atelier/static-check.py
```

Exit 0. All 22 Lisp files passed static inspection.

```text
bash mneme/verify-all.sh
```

Exit 0. All 6/6 repository floors held:

- conformance walk: 7/7 checks;
- adversarial conformance: 18 passed, 0 failed;
- counterexample closure: 10 passed, 0 failed;
- boundary: 9 passed, 0 failed;
- atelier: 4 expected pass banners;
- language-a fixtures: 14 passes and one suite-pass line.

```text
git diff --exit-code 197be4bcad4355f0694539a0bb6d9b8c2c73233d^{tree} daf593deaeeb0669c504c00c119abe765fd3d08d^{tree}
```

Exit 0: merge tree equals verified branch tree.

Immediately after the explicit merge and all post-merge verification,
`git status --porcelain=v1` emitted no output. The receipt-only commit is to be
checked again for a clean local and remote branch identity before handoff.

## Authority boundary

Controlling authority remains the ordered pair:

```text
DE-CORROBORATIONE-PROVENANCE-GRAPH-SPEC-DRAFT-0.4.md
AUTHORIAL-ERRATUM-0.4-A.md
```

This receipt records authorial acceptance of the bounded specimen. It does not
modify, regenerate, reinterpret, or promote either authority artifact or the
verified implementation.
