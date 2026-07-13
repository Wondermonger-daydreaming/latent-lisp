# CD/0 Errata 0.1 immutable archive receipt

Date: 2026-07-13
Vantage: local WSL2 repository worktree
Status: two independent archive constructions from the same immutable Git
source commit were byte-identical.

This receipt covers the evidence-complete source tree for the authorized CD/0
Errata 0.1 repair. It does not claim a merge to `main`, a remote publication,
or universal conformance.

## Archive identity

| Field | Value |
|---|---|
| source commit | `86df3646b61cfc0ea4ec66c245a8b98600f8e86b` |
| source tree | `84b276c9b44dd6adb86b713aee3430b3162afb24` |
| audited integration ancestor | `baeecd5e0347435b9e1362000344f46ea441c6ec` |
| prefix | `latent-lisp-cd0-errata-0.1-2026-07-13/` |
| tracked file members | 1,232 |
| tar listing entries, including directories | 1,383 |
| tar-listing SHA-256 | `4c980fa5ff9d7f3b9b7a41ecacafba1644334596c7f162e8c954790ac9a04565` |
| compressed bytes | 20,461,944 |
| archive SHA-256 | `09498ebdd2d3be48c93d5236816c4a4fa249a164229616597678c97626857093` |
| retained path | `canonical-datum/evidence/artifacts/cd0-errata-0.1-2026-07-13.tar.gz` |

The retained archive is an exact byte copy of the first independently generated
file below. The archive and this receipt are intentionally outside the archived
source commit: including an archive in the tree from which that same archive is
constructed would create a self-reference. The later publication envelope pins
both files.

## Reproduction commands and result

Commands, executed from the integration successor worktree:

```text
git archive --format=tar.gz \
  --prefix=latent-lisp-cd0-errata-0.1-2026-07-13/ \
  --output=/tmp/cd0-errata-0.1-2026-07-13.first.tar.gz \
  86df3646b61cfc0ea4ec66c245a8b98600f8e86b

git archive --format=tar.gz \
  --prefix=latent-lisp-cd0-errata-0.1-2026-07-13/ \
  --output=/tmp/cd0-errata-0.1-2026-07-13.second.tar.gz \
  86df3646b61cfc0ea4ec66c245a8b98600f8e86b

cmp -s /tmp/cd0-errata-0.1-2026-07-13.first.tar.gz \
       /tmp/cd0-errata-0.1-2026-07-13.second.tar.gz
```

All three commands exited `0`. `sha256sum` returned the same identity for both
constructions:

```text
09498ebdd2d3be48c93d5236816c4a4fa249a164229616597678c97626857093  /tmp/cd0-errata-0.1-2026-07-13.first.tar.gz
09498ebdd2d3be48c93d5236816c4a4fa249a164229616597678c97626857093  /tmp/cd0-errata-0.1-2026-07-13.second.tar.gz
```

The member listing was inspected at both ends. The archive begins with the
prefix directory, repository attributes, the corrected divergence ledger,
normative errata, and closure receipts; it ends with the tracked repository
skill files. `tar -tzf ... | wc -l` returned `1383`. The exact listing can be
reproduced from the retained archive and is protected by the listing hash above.

## Embedded evidence pins

The archive source contains these load-bearing identities:

```text
ruling
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc

Errata 0.1
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271

base specification
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc

positive vectors
34fe63302e686efc0bcf1b1d841dbc5392c7f5abae393390eca40680179492b4

negative vectors
d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6

promoted A1-A9 vectors
55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc

fixture schema
6609a6d97140f1fda5a538ccb908bb820bcdad380b7dd8efb05fa8a9e7a0407c

hand differential summary
3c62572cb962c5fb4ab8395937901355ea54f0664032ad2a7ccdaa6f937396c4

release differential summary
44e1b9edb7dac1f89124d52559c3fc7368b26e3340e487379f389b85bfb0b422

qualification summary
ffaeb38ed61777980b2313d4d8bf1a1c8c27ea8a658a8ba53ac95bca0aec429b

generated corpus manifest
9b0865c559cdcdfaa850a8fa5e8e7ac47916059ac0516427322f3cf9d0c81fbc

aggregate generated corpus
62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58
```

## Branch provenance

The archived integration source incorporates codec files byte-identical to
these standalone successor tips:

```text
Common Lisp commit ee3baa9ab504f65d39015f212050748fd300160a
Common Lisp tree   ecf5261c41ad24199325ab56cbf6c39e83cddbc6

Python commit      9f46a32351095dc1a52724a31574e0b9e62ed221
Python tree        f065acfe6bb56365946a20e131edcfbf351b06f4
```

The audited tips remain ancestry/provenance anchors and were not rewritten:

```text
Common Lisp 45eb60ce5b80485a0b287feab53ed3b58643b1b0
Python      29d0946ad78347015b9f0c65a2f528f039fdca78
Integration baeecd5e0347435b9e1362000344f46ea441c6ec
```

## Boundary

This archive is a reproducible byte-level container for the exact Git source
tree and retained local evidence. It does not turn generated evidence into a
normative oracle, prove behavior outside the recorded runtimes and bounded
tests, or establish remote availability. Remote read-back is recorded only
after non-force publication in a separate receipt.
