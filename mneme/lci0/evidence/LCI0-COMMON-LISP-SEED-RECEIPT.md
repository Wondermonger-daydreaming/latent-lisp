# LCI/0 Common Lisp Seed Receipt

Date: 2026-07-14. Evidence standing: direct local observation unless explicitly
identified as inherited frozen preflight evidence.

## Seed identity and boundary

- Branch: `codex/lci0-common-lisp`.
- Worktree: `/home/gauss/Codex-Lab/latent-lisp-lci0-common-lisp`.
- Pre-seed base commit: `ab353b4b7f30d5e46323d274862e6c1212ebf514`.
- Pre-seed base tree: `26d0714ba873ce4a44a978f7acf98d21fd3fc176`.
- Frozen base `canonical-datum` tree:
  `ce6e41deca3fe237ff6d0edafa2666d098ae62e8`.
- Frozen base `mneme/latent-mvp` tree:
  `41c2934e34a04461cf50cb378394c32c7c11d344`.
- Runtime: SBCL 2.4.6.
- Host: Linux `6.18.33.2-microsoft-standard-WSL2`, x86_64, WSL2.
- Remote fetch/push URL:
  `https://github.com/Wondermonger-daydreaming/latent-lisp.git`.

The seed identity is the single commit carrying this receipt. A commit cannot
contain its own cryptographic identity without self-reference, so its exact
commit and tree hashes are recorded immediately after creation in the
integration-side evidence ledger and in the parent handoff. This seed commit is
not amended or rewritten.

This is an independently seeded Common Lisp implementation under shared
normative infrastructure, with procedural -- not OS-enforced -- isolation. It
does not claim unqualified clean-room independence. Before the first seed
commit, this seed inspected no Python LCI/0 implementation source, no Python
seed worktree file, and no Python seed result. The exact positive and negative
inspection boundary is preserved in
`LCI0-COMMON-LISP-INSPECTED-FILES.txt`.

## Authorization respected

Implemented scope is limited to immutable fixture LCI values, closed validation,
the pure fixture adapter, fixture proposition normalization, fixture calculi and
StableRefs, ClaimId projection, inert WarrantTarget validation and matching,
finite Policy-A/Policy-B evaluation, inert v1 migration fixtures, resource and
typed-failure semantics, nonidentity metadata neutrality, and fixture/vector
verification.

No production warrant or WarrantId, standing, capability, authority,
cryptographic selection, production module/procedure identity, custody,
verified lineage, live migration, or CD/0 change was introduced. ClaimId remains
the envelope, not a digest. Migration never loads or evaluates legacy Lisp.

## Normative artifact identities

| Artifact | SHA-256 |
| --- | --- |
| `LOCATED-CLAIM-IDENTITY-SPEC.md` | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` |
| `LCI0-POST-REVIEW-RULING.md` | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` |
| `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| `LCI0-FIXTURE-REGISTRY.json` | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `LCI0-FIXTURE-VECTORS.jsonl` | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| Fixture manifest | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` |
| Fixture checksum file | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |
| Fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Fixture TAR.GZ twin | `ddc03ba184e835fdbd3c51e9a0f8d3edf4a93deb4d6b980544d82a5c47a83934` |
| Fable constitutional review | `65a989381fce365ba7057f07f6511e7a606ab4d2f2b4b052acda07dd11d1a50e` |
| Fable issue register | `a22e9f430c32f96472c4fcbe327309fb343a498094e47f486c00359a92221806` |
| Fable readiness relay | `9502d24b03675db1d8b5fd7788ebfb50ea31ab9e452d8a440f3e935fd5b9ef03` |
| Fable PASS receipt | `96859328cee6caa3afcd44c00b8bf84cb20ccc55a7139271b7862a34f8a587a2` |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` |
| Frozen CD/0 packet ZIP | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |
| Frozen CD/0 specification | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Frozen CD/0 Errata 0.1 | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| Frozen CD/0 ruling | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |

All identities match the authoritative manifests. The shared preflight's
disclosed package-checksum bookkeeping typo is non-semantic and remains
explicitly recorded; no artifact identity differs.

## Implementation map

| Obligation | Common Lisp implementation and tests | Observed evidence |
| --- | --- | --- |
| Closed immutable values and typed failures | `values.lisp`, `validation.lisp`, `tests.lisp` | unit 14/14; risk 15/15; vectors 215/215 |
| Pure total JSON fixture adapter and schema census | `json.lisp`, `fixture-adapter.lisp`, `registry.lisp` | adapter census green; 1,593-document sweep |
| Proposition profile and ClaimId projection | `operations.lisp`, `validation.lisp` | exact neutral/projection vectors and mutation gates |
| Scope, temporal, slice, boundary, and frame calculi | `calculi.lisp`, `operations.lisp` | all shared relations exact; `LCI0-DIV-001` retained |
| StableRef fixture schemes | `validation.lisp` | mutable aliases and unknown versions fail closed |
| WarrantTarget validation and pure matching | `matching.lisp`, `operations.lisp` | all target/matching vectors exact; F hard floor tested |
| Finite Policy-A and Policy-B | `policy.lisp`, `operations.lisp` | all fixture-policy vectors exact |
| Inert v1 migration and loss accounts | `migration.lisp`, `operations.lisp` | migration vectors exact; zero live warrants |
| Corpus/vector harness | `registry.lisp`, `harness.lisp` | 215 vectors; 1,105 official + 488 supplementary |
| Ambient-state defenses | `tests.lisp`, `run-perturbation.lisp` | 4 fresh-process profiles plus mutation tests |

The integration ledger supplies the full specification/Errata/registry/vector
crosswalk after both unchanged seeds are imported. No semantic result is
selected by vector ID; fixture IDs are used only as keys into the explicitly
finite policy and migration registries authorized by the package.

## Pre-seed red baseline

Before successful behavior was added, the fifteen required high-risk boundaries
were executed as red tests:

```text
LCI0 PRE-SEED RISK SUMMARY: 0 green, 15 red, 15 total
process exit: 1
```

The complete immutable output is
`LCI0-COMMON-LISP-PRE-SEED-RED-TRANSCRIPT.txt`. The same gates are green in the
final tree: 15/15, zero failures, skips, or N/A.

## Final local verification

| Gate | Result |
| --- | --- |
| Common Lisp unit/adapter/ambient tests | 14/14 pass; 0 fail; 0 skip; 0 N/A |
| Required high-risk boundary tests | 15/15 pass; 0 fail; 0 skip; 0 N/A |
| Shared LCI/0 vectors | 215/215 exact; 215 unique IDs; 0 missing; 0 underdetermined |
| Official embedded documents | 1,105/1,105 byte-identical |
| Supplementary relation/E1 documents | 488/488 byte-identical |
| Total recursive package sweep | 1,593/1,593; magic-prefix census 1,593 |
| Fresh-process CL perturbations | 4 profiles x 215 = 860 exact vector requests |
| ASDF clean compile/load | PASS; 0 warnings; 0 failures; 3 compiler notes |
| Exported public surface | 0 unbound exports |
| Frozen CD/0 Common Lisp suite | PASS; 2,633 assertions; 3 declared N/A not counted pass |
| Existing Mneme/v1 suites | 6/6 green |
| Protected tracked-source diff | empty for CD/0, `mneme/latent-mvp`, and `mneme/verify-all.sh` |

Exact commands and observed summaries are preserved in
`LCI0-COMMON-LISP-SEED-VERIFICATION-TRANSCRIPT.txt`.

## Divergence standing

No unresolved Common Lisp implementation divergence remains. The pre-existing
`LCI0-DIV-001` temporal prose/machine vocabulary distinction is retained
without silent normalization: the precise executable registry/vector results
are `contains` and `before`, under the Fable PASS disposition. No implementation
was treated as an oracle.

Two early test-harness defects and one command-configuration error are disclosed
in the verification transcript. None altered normative behavior, a fixture
expectation, or an implementation result.

## Evidence archive

`LCI0-COMMON-LISP-SEED-EVIDENCE-2026-07-14.tar.gz` contains the complete Common
Lisp source, red transcript, inspected-file inventory, verification transcript,
and archive manifest.

- Members: 25 (one directory entry, 20 Common Lisp files, four evidence files).
- Bytes: 38,703.
- SHA-256:
  `bf8662d9b477d15769afe441f4cd87cedfc7ac4d2fdd9683bf8b21526fc288c8`.
- Determinism check: a second archive built with sorted names, epoch
  `1783987200`, numeric owner/group 0, GNU tar format, and `gzip -n` compared
  byte-identically and reproduced the same SHA-256.
- Complete member/source hashes:
  `LCI0-COMMON-LISP-SEED-SHA256SUMS.txt`.

## Seed completion and residual boundary

All Common Lisp seed completion gates are green. Randomized cross-language
properties, shared differential comparison, integration-only perturbations,
and publication/read-back are intentionally deferred until both immutable seed
commits exist. This branch is not merged or pushed by the seed agent. It is
ready to be imported unchanged into the integration worktree; independent audit
eligibility remains an integration-level conclusion, not a claim of this seed
receipt.
