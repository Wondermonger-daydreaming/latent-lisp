# Root receipts and closure records

These 27 records are the Canonical Datum /0 implementation, errata and closure receipts. **On 2026-09-24, at the ruling
office's disposition (Astra, GPT-6) and the owner's direction, 23 of them were relocated byte-for-byte to
`receipts/canonical-datum-0/`; four stay at the root because frozen CD/0 code, tests and `.gitattributes` name them by
path** (`CANONICAL-DATUM-DIVERGENCES.md`, `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`, `CD0-POST-IMPLEMENTATION-RULING.md`,
`V1-COUNTEREXAMPLE-CLOSURE.md`). Every blob is unchanged; `receipts/RELOCATION-MAP.md` maps each old path to its new one with
the blob id, so a historical citation of a root path resolves through the map. Frozen records that cite the old paths were
not edited. This page is additive navigation only: it does not supersede a record, change its
standing, or turn a historical title such as “independent review” into independent semantic verification.
The file itself and each record's stated boundary govern.

## Canonical Datum /0 implementation and ruling

| record | date | what it binds |
|---|---|---|
| [`CANONICAL-DATUM-DIVERGENCES.md`](CANONICAL-DATUM-DIVERGENCES.md) | 2026-07-13 (closure; register undated) | A1–A9's original divergence register and their later normative closure; not evidence that every implementation path was compared |
| [`receipts/canonical-datum-0/CD0-IMPLEMENTATION-LEDGER.md`](receipts/canonical-datum-0/CD0-IMPLEMENTATION-LEDGER.md) | 2026-07-13 | the pre-errata implementation checkpoints, source boundary, reruns, and recomputed hashes; retained as superseded history where it says A1–A9 are open |
| [`CD0-POST-IMPLEMENTATION-RULING.md`](CD0-POST-IMPLEMENTATION-RULING.md) | 2026-07-13 | the constitutional disposition that closes A1–A9, authorizes narrow errata, and states the conditions for merge |

## Errata 0.1 repair and evidence envelope

| record | date | what it binds |
|---|---|---|
| [`CANONICAL-DATUM-SPEC-ERRATA-0.1.md`](CANONICAL-DATUM-SPEC-ERRATA-0.1.md) | 2026-07-13 | the additive normative language for A1–A9; base specification plus errata remains the conformance target |
| [`receipts/canonical-datum-0/CD0-ERRATA-IMPLEMENTATION-LEDGER.md`](receipts/canonical-datum-0/CD0-ERRATA-IMPLEMENTATION-LEDGER.md) | 2026-07-13 | the authorized repair's changed semantics, checkpoints, and protected boundary before merge |
| [`receipts/canonical-datum-0/CD0-ERRATA-DOCUMENTATION-CORRECTIONS.md`](receipts/canonical-datum-0/CD0-ERRATA-DOCUMENTATION-CORRECTIONS.md) | 2026-07-13 | four bounded documentation repairs without enlarging implementation standing |
| [`receipts/canonical-datum-0/CD0-ERRATA-CHANGED-FILES.txt`](receipts/canonical-datum-0/CD0-ERRATA-CHANGED-FILES.txt) | 2026-07-13 | the exact 360-path add/modify inventory against the audited base |
| [`receipts/canonical-datum-0/CD0-ERRATA-VERIFICATION-TRANSCRIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-VERIFICATION-TRANSCRIPT.md) | 2026-07-13 | commands, checkpoints, and observed local verification categories; archive, review, and readback stay separate |
| [`receipts/canonical-datum-0/CD0-ERRATA-DIFFERENTIAL-RECEIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-DIFFERENTIAL-RECEIPT.md) | 2026-07-13 | the finite hand differential and its focused A9 superseding addendum; neither codec becomes an oracle |
| [`receipts/canonical-datum-0/CD0-ERRATA-RELEASE-RECEIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-RELEASE-RECEIPT.md) | 2026-07-13 | the deterministic generated corpus, row counts, hashes, and focused A9 superseding run |
| [`receipts/canonical-datum-0/CD0-ERRATA-INDEPENDENT-REVIEW-RECEIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-INDEPENDENT-REVIEW-RECEIPT.md) | 2026-07-13 | two fresh read-only Codex sub-reviewers' targeted review under its stated scope; not Fable, and no independent semantic standing follows from the historical title |
| [`receipts/canonical-datum-0/CD0-ERRATA-ARCHIVE-RECEIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-ARCHIVE-RECEIPT.md) | 2026-07-13 | two byte-identical constructions of the evidence-complete immutable archive and its retained path |
| [`receipts/canonical-datum-0/CD0-ERRATA-FABLE-RELAY.md`](receipts/canonical-datum-0/CD0-ERRATA-FABLE-RELAY.md) | 2026-07-13 | the exact targeted review request, normative pins, and evidence locations; a handoff, not a verdict |
| [`receipts/canonical-datum-0/CD0-ERRATA-REMOTE-READBACK-RECEIPT.md`](receipts/canonical-datum-0/CD0-ERRATA-REMOTE-READBACK-RECEIPT.md) | 2026-07-13 | the initial publication payload, live preflight, push, and isolated far-side readback boundary |
| [`receipts/canonical-datum-0/CD0-ERRATA-CHECKSUM-MANIFEST.txt`](receipts/canonical-datum-0/CD0-ERRATA-CHECKSUM-MANIFEST.txt) | 2026-07-13 | SHA-256 identities for the first-closure envelope; explicitly superseded for the focused A9 return |

## Focused A9 two-vector return

| record | date | what it binds |
|---|---|---|
| [`receipts/canonical-datum-0/CD0-A9-FABLE-FOCUSED-RELAY.md`](receipts/canonical-datum-0/CD0-A9-FABLE-FOCUSED-RELAY.md) | 2026-07-13 | the paste-ready two-vector-only re-verification request and its no-merge ceiling |
| [`receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-DELTA-RECEIPT.md`](receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-DELTA-RECEIPT.md) | 2026-07-13 | exactly two added A9 runtime-encode rows and the evidence-completeness scope they close |
| [`receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-CHANGED-FILES.txt`](receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-CHANGED-FILES.txt) | 2026-07-13 | the exact 71-path delta between the first successor and evidence checkpoint |
| [`receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-ARCHIVE-RECEIPT.md`](receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-ARCHIVE-RECEIPT.md) | 2026-07-13 | byte-identical archive constructions, split publication parts, and archive hashes |
| [`receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-REMOTE-READBACK-RECEIPT.md`](receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-REMOTE-READBACK-RECEIPT.md) | 2026-07-13 | pre-publication remote state, fast-forward pushes, and fresh far-side commit/tree comparison |
| [`receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-SHA256SUMS.txt`](receipts/canonical-datum-0/CD0-A9-TWO-VECTOR-SHA256SUMS.txt) | 2026-07-13 | hashes for the focused relay, receipts, summaries, corpus manifest, and split archive parts |

## Freeze, merge, and main readback

| record | date | what it binds |
|---|---|---|
| [`receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md`](receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md) | 2026-07-13 | the accepted merge commit/tree and the exact frozen constitutional surface |
| [`receipts/canonical-datum-0/CD0-MERGE-RECEIPT.md`](receipts/canonical-datum-0/CD0-MERGE-RECEIPT.md) | 2026-07-13 | retrospective reconciliation of old main, authorized integration, ordered parents, merge commit, and tree |
| [`receipts/canonical-datum-0/CD0-MERGE-SHA256SUMS.txt`](receipts/canonical-datum-0/CD0-MERGE-SHA256SUMS.txt) | 2026-07-13 | SHA-256 identities for the merge/freeze artifact envelope, excluding itself |
| [`receipts/canonical-datum-0/CD0-POST-MERGE-VERIFICATION.md`](receipts/canonical-datum-0/CD0-POST-MERGE-VERIFICATION.md) | 2026-07-13 | finite verification at the exact merge commit, including the protected projection and explicit residual boundaries |
| [`receipts/canonical-datum-0/CD0-MAIN-READBACK-RECEIPT.md`](receipts/canonical-datum-0/CD0-MAIN-READBACK-RECEIPT.md) | 2026-07-13 | a fresh-mirror construction and remote `main` readback of the accepted commit |

## Mneme v1 closure

| record | date | what it binds |
|---|---|---|
| [`V1-COUNTEREXAMPLE-CLOSURE.md`](V1-COUNTEREXAMPLE-CLOSURE.md) | undated in-file; indexed 2026-08-28 | the pinned review, ten exported-client counterexamples, applied repairs, reruns, and residual non-goals of the v1 sprint |

*— indexed by GPT Sol (OpenAI), 2026-08-28. Navigation only; no receipt or standing altered.*
