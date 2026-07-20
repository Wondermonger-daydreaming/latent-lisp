# SS-0 ADJUDICATION PACKET — SEALED FINAL (step 2 of the freeze procedure)

*Sealed 2026-07-19 by the chair (Fable, Claude Fable 5). Plaintext lives only in `_staging/ss0-sealed/` (gitignored, mirror-sync-excluded) until freeze step 8. SHA-256 committed publicly in SS0-FREEZE-LEDGER.md. Seats never see this before their freezes.*

## 1. Sealed extension (already committed at draft stage)

`SHA-256(SS0-EXTENSION-SEALED.md) = 7bf5abada93831c6193538100441fcf7af8aa7649abca2d8ac30d16b246505bf` — revealed to both seats simultaneously at step 6. A provider-fixture delta (mechanical, provider-side only) ships with the reveal, hash-frozen then.

## 2. Mutation battery (co-authored: seed set authored by Kimi packager instance, 2026-07-20; applied per the scope rule below)

Symmetric, applied to both sides' production paths:
M1 collapse empty/absent/invalid payload distinction; M2 permit blind re-dispatch under unrecorded outcome; M3 launder derived state into observed standing on re-verification; M4 allow settlement upgrade without record-entered evidence; M5 drop predecessor unresolved-standing on succession; M6 scalar-compress the recovery census (one status for many propositions) in the durable record or in what recovery reports.

Application rule: each mutation is implemented as a minimal source edit to the side's frozen implementation (chair-authored, disclosed diff); the side's own checks, differentials, or the adjudication probes must surface it. A surviving mutant fails the mapped obligation (M1→R2, M2→R3, M3→R6, M4→R4, M5→R5, M6→R1/R9).

**Scope rule (pre-registered before any mutation runs):** the chair enumerates each side's "production paths" from its frozen sources — every function reachable from the runner and recovery entry points excluding audited `@harness` markers — and publishes that enumeration BEFORE running any mutant. No post-hoc scope adjustment.

## 3. Interpretation bands (frozen as drafted and owner-approved)

- **Band S** (architecture supported at multi-effect scale): both seats satisfy R1–R9 and the satisfying designs exhibit per-proposition-style machinery at AFEL cost ≤1.5× KW-0's application column. Reported ALWAYS with the shared-root cap: both seats' training corpora overlap; convergence is corpus-attractor-sensitive, never "independent" simpliciter.
- **Band C** (conventional-parity — F5 weakened): ≥1 seat satisfies R1–R9 within a smaller application-facing budget with a design the exclusion audit confirms conventional (no per-proposition machinery re-derived).
- **Band M** (mixed): obligations met with partial machinery or at sharply asymmetric cost — per-obligation report, no thesis-level promotion either direction.
- **Band F** (obligations unmet): evidence about difficulty, not the thesis; report which and why.
- **NULL/VOID discipline:** a VOIDed arm confirms nothing in any direction; re-run or report VOID as VOID. An underpowered arm cannot confirm a null.

## 4. Run-VOID conditions

VOID-1..5 as frozen in SS0-PROTOCOL.md; teeth-check transcripts required in the ledger before seeding (VOID-2's is already recorded: `VOID2-TEETH-CHECK-TRANSCRIPT.txt`). VOID-1/VOID-3 teeth-checks are run against the first delivered implementations (planted: a recovery path reading a `READY-*` file; a shared-fixture digest comparison) before verdict-bearing runs.

## 5. Measurement bands for the nine measurements

No pass/fail on size (per the brief); the nine measurements are reported raw per side, extension delta separately. The only thresholded quantity is Band S's ≤1.5× comparison to KW-0's application column (62 AFEL, fixed reference), and Band C's "smaller budget" comparison between seats.

## 6. Amendment rule

This seal is never silently reopened. Any pre-seeding amendment (e.g., a Kimi sharpening round on the battery) is a separate sealed file with its own public hash, appended to the ledger as AMENDMENT-n.
