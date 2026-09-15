# Overclaim census — S1/S2 pattern hits, repo-wide

Patterns searched: "cannot do this", "outside the package cannot", "caller outside the package", "package privacy", "internal row constructor", "future work, deliberately", "cross-journal case to future work", "R4.1-F3" (excluding .git/, scratchpad/).

Total raw hits: 556 across 8 patterns. Unique files hit: 152.

Bucket = document TYPE (not whether the hit asserts the overclaim as true). Checked separately: NONE of the LIVE-SUMMARY or NORMATIVE-CONTRACT hits assert S1 or S2 as true — every one either cites the CORRECT rule ("package privacy is not a capability boundary") or explicitly marks S1/S2 as disproven/FAIL/OPEN. The exact false sentences stand asserted-as-true only in the two SOURCE files and their two frozen packet copies (see highlights below).

## Counts by bucket

| Bucket | Unique files |
|---|---|
| LIVE-SUMMARY | 9 |
| NORMATIVE-CONTRACT | 1 |
| SOURCE | 3 |
| HISTORICAL-TESTIMONY | 123 |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | 16 |
| **Total** | **152** |

## Full table (one row per unique file; hit-count = occurrences across all 8 patterns in that file)

| Bucket | file:line | hits | excerpt (verbatim, ≤160 chars) |
|---|---|---|---|
| LIVE-SUMMARY | `./experiments/latent-lisp/mneme/memory-layer-0/MEMORY-LAYER-0-RETURN.md:1396` | 21 | supported producer of a finding (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — a... |
| LIVE-SUMMARY | `./experiments/latent-lisp/warrant-calculus/LMP0-clauses-SA-ML0.md:1177` | 6 | > 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| LIVE-SUMMARY | `./experiments/latent-lisp/mneme/architecture/ARCHITECTURE-0-STATUS.md:1388` | 5 | 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| LIVE-SUMMARY | `./notes/2026-09-14-warrant-session-0-r1-readiness-brief.md:24` | 4 | - **P9** — proposition "package privacy is defense in depth". **FAIL · claim-ceiling violation in shipped proof comment; supported runtime path remains sound... |
| LIVE-SUMMARY | `./experiments/latent-lisp/mneme/memory-layer-0/MEMORY-LAYER-0-GUIDE.md:94` | 3 | ;;     not exposed through the exported, supported API; package privacy is not a |
| LIVE-SUMMARY | `./experiments/latent-lisp/mneme/verify-release.sh:366` | 2 | ml0\|ADOPTED\|Memory Layer /0 — the language's durable account of its own act: ADOPTED AND PUBLISHED · stranger audit owed · no independent verification\|ADOPTE... |
| LIVE-SUMMARY | `./docs/operational-protocols.md:381` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| LIVE-SUMMARY | `./experiments/latent-lisp/mneme/memory-layer-0/MEMORY-LAYER-0-WORK-ORDER.md:385` | 1 | `SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family execution does not |
| LIVE-SUMMARY | `./notes/2026-08-21-session-handoff-habemus-registered.md:55` | 1 | - **The boundary rule:** *not exposed through the exported, supported API; CL package privacy is not a |
| NORMATIVE-CONTRACT | `./experiments/latent-lisp/mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md:40` | 13 | `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, |
| SOURCE | `./experiments/latent-lisp/mneme/memory-layer-0/ml0.lisp:250` | 9 | exported, supported API — and Common Lisp package privacy is not a capability |
| SOURCE | `./experiments/latent-lisp/mneme/memory-layer-0/ml0-consolidation-proof.lisp:42` | 3 | ;;;; package.  A caller outside the package cannot do this.  What the probe then |
| SOURCE | `./experiments/toaster-benchmark/probe-bypass.lisp:40` | 1 | ;; is itself part of what this probe demonstrates: CL package privacy is not a |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/stranger-return/codex-transcript.log.txt:96` | 130 | 5. Which claims concern supported API behavior, and which rely on package privacy, host behavior, or convention? |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/MEMORY-LAYER-0-RETURN.md:1396` | 21 | supported producer of a finding (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — a... |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/MEMORY-LAYER-0-RETURN.md:1396` | 21 | supported producer of a finding (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — a... |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/MEMORY-LAYER-0-SPEC.md:40` | 13 | `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/MEMORY-LAYER-0-SPEC.md:40` | 13 | `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/ml0.lisp:250` | 9 | exported, supported API — and Common Lisp package privacy is not a capability |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/ml0.lisp:250` | 9 | exported, supported API — and Common Lisp package privacy is not a capability |
| HISTORICAL-TESTIMONY | `./_staging/r41c-scriba-iii-report.md:141` | 9 | \| `RETURN.md:2108` (supersession row) \| *"The cross-journal case is narrowed to future work, deliberately"* → *"This **narrows Architecture 0.1's D4 cross-jo... |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/CHAIR-VERIFICATION-R41-2026-08-21.md:93` | 8 | body equality; CL package privacy is not a capability boundary; the target-store re-read is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/CHAIR-VERIFICATION-R41-2026-08-21.md:93` | 8 | body equality; CL package privacy is not a capability boundary; the target-store re-read is |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/memory-layer-0/CHAIR-VERIFICATION-R41-2026-08-21.md:93` | 8 | body equality; CL package privacy is not a capability boundary; the target-store re-read is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-07-shannon-synthesis-0/LMP0-clauses-SA-ML0.md:1173` | 6 | > 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-08-publication-shannon-warrant/PUBLICATION-DIFF-r0.patch:20650` | 6 | +> 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-08-publication-shannon-warrant/PUBLICATION-DIFF.patch:18179` | 6 | +> 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-sameroot-cold-audit/AUDIT-RETURN.md:58` | 4 | \| P9 — package privacy is defense in depth, not the soundness boundary \| **FAIL — claim-ceiling violation** \| `evidence/source-trace-p9.txt`, `evidence/novel... |
| HISTORICAL-TESTIMONY | `./corpus/voices/received/2026-09-01-165557-sol-ii-frigus-ml0-sameroot-cold-audit-0-return.md:85` | 4 | `A caller outside the package cannot do this.` |
| HISTORICAL-TESTIMONY | `./corpus/voices/received/2026-09-01-201730-sol-ii-ml0-strict-stranger-audit-0-0.1-minimax-m3-TERMINAL.md:75` | 4 | `A caller outside the package cannot do this.` |
| HISTORICAL-TESTIMONY | `./memory/backups/ml0-arc-detail.md:255` | 4 | supported API; CL package privacy is not a capability boundary"**; "supported public route"; |
| HISTORICAL-TESTIMONY | `./notes/2026-08-21-relay-to-sol-memory-layer-0-candidate-r41.md:59` | 4 | exported, supported API; package privacy is not a capability boundary**) computing `:contradicted`, writing it, and reading back |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/delta-71d94fc2..afc532b3.diff:52` | 4 | +   · D4 SHOWN-AS-AMENDED · package privacy is defense in depth · same-family execution non-independent. |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/MEMORY-LAYER-0-GUIDE.md:94` | 3 | ;;     not exposed through the exported, supported API; package privacy is not a |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/RUN-EXITCODES.txt:549` | 3 | DEPTH, NOT THE SOUNDNESS BOUNDARY); (C) name fork R4.1-F3 (cross-journal |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/ml0-consolidation-proof.lisp:42` | 3 | ;;;; package.  A caller outside the package cannot do this.  What the probe then |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/MEMORY-LAYER-0-GUIDE.md:94` | 3 | ;;     not exposed through the exported, supported API; package privacy is not a |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/RUN-EXITCODES.txt:549` | 3 | DEPTH, NOT THE SOUNDNESS BOUNDARY); (C) name fork R4.1-F3 (cross-journal |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/ml0-consolidation-proof.lisp:42` | 3 | ;;;; package.  A caller outside the package cannot do this.  What the probe then |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-03-atelier-morphology/CENSUS-A-lisp-mneme.md:106` | 3 | \| **P9 claim-ceiling** \| "**P9 FAIL · claim-ceiling violation in shipped proof comment; supported runtime path remains sound**" and "**The P9 claim-ceiling d... |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-03-fossil-publication-cargo-0.1/A1-architecture-patch.diff:31` | 3 | +4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-03-fossil-publication-cargo-0.1/A2-the-44-lines.md:25` | 3 | 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-04-readme-ml0-reconciliation-0.1/parcel/extracted/sources/ADDENDUM-24.excerpt.md:25` | 3 | 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is |
| HISTORICAL-TESTIMONY | `./corpus/voices/received/2026-09-01-194113-sol-ii-ml0-strict-stranger-audit-0-minimax-m3-return-AMEND.md:54` | 3 | `A caller outside the package cannot do this.` |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/memory-layer-0/RUN-EXITCODES.txt:549` | 3 | DEPTH, NOT THE SOUNDNESS BOUNDARY); (C) name fork R4.1-F3 (cross-journal |
| HISTORICAL-TESTIMONY | `./notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md:1` | 3 | # Memory Layer /0 — R4.1-F3, cross-journal materialization: an OPEN governance item, and a question for Sol |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-sameroot-cold-audit/CUSTODY-NOTE.md:13` | 2 | claim-ceiling violation (ml0-consolidation-proof.lisp:42 "A caller outside the package cannot |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-sameroot-cold-audit/THREAT-MODEL-AND-TEST-PLAN.md:97` | 2 | 11. **Construction-boundary overclaim:** rely on package privacy as capability security. The |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/PROPOSITION-REGISTER.md:130` | 2 | > only callers that STAMP through the exported, supported API (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is... |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/PROPOSITION-REGISTER.md:128` | 2 | > only callers that STAMP through the exported, supported API (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is... |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/evidence/FULL-FLOOR-79ceeada.transcript.txt:344` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/pre-cure/A-missing-python-gate.transcript.txt:119` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/pre-cure/B-subject-digest-absent-manifest.transcript.txt:119` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/pre-cure/C-wild-full-floor-nightly-2026-08-23-f5ba80c6.txt:337` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/successor/FULL-FLOOR-ad6c95e9.transcript.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/01-missing-python-gate.transcript.txt:126` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/02-python-argparse-exit2.transcript.txt:126` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/03-bash-syntax-exit2.transcript.txt:126` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/04-hard-refuser-manifest-removed.transcript.txt:126` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/05-missing-declared-cwd.transcript.txt:126` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/08-initial-git-status-fails.transcript.txt:139` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/09-final-git-status-fails.transcript.txt:139` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/10-synthetic-extra-lane.transcript.txt:130` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/latent-lisp/mneme/release-floor-erratum-0/teeth/11-planted-lane-omission.transcript.txt:133` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./experiments/toaster-benchmark/SMITH-II-report.md:202` | 2 | own rider that package privacy is not a capability boundary. |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/farside-floor-9a56eabd.transcript.txt:327` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/floor-42a7130a-worktree-supporting.transcript.txt:325` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/kiln-71d94fc2.transcript.txt:351` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/kiln-afc532b3.transcript.txt:344` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/census-2026-08-22/kiln/kiln-fe8fb355.transcript.txt:351` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-22-candidate-floor-HEAD-3a3c74ca-PASS.txt:324` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-22-chain-floor-HEAD-3d86df9c-PASS.txt:324` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-22-post-adoption-floor-HEAD-51b1d23c-PASS.txt:325` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-22-post-correction-floor-HEAD-c95095a7-PASS.txt:324` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-22-fac6efc6.txt:325` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-23-3c686241.txt:344` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-23-f5ba80c6.txt:337` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-24-a0815161.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-25-5275882c.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-26-0f316637.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-27-039e3f8d.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-28-3529193a.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-29-d00e5421.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-30-57363968.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-08-31-09e32a89.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-09-01-3646ce69.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-09-02-5bd07bd4.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-09-03-74d60fe3.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-09-04-32456605.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/nightly-2026-09-05-fbc03469.txt:347` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/adoption-receipt/02-adoption-commit-1f1da138.diff:88` | 2 | ml0\|CANDIDATE-NOT-ADOPTED\|Memory Layer /0 — the language's durable account of its own act: CANDIDATE-NOT-ADOPTED · REGISTERED · stranger audit owed · no inde... |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/adoption-receipt/05-carried-row-change.diff:17` | 2 | ml0\|CANDIDATE-NOT-ADOPTED\|Memory Layer /0 — the language's durable account of its own act: CANDIDATE-NOT-ADOPTED · REGISTERED · stranger audit owed · no inde... |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/adoption-receipt/07-post-adoption-floor-transcript.txt:325` | 2 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./_staging/2026-08-28-latent-lisp-stranger-read.md:49` | 1 | Increased trust: "every green is same-family self-consistency … No lane may say 'independently verified'" (91–93) · "Loading is not adoption. A green floor i... |
| HISTORICAL-TESTIMONY | `./_staging/2026-08-30-ml1-prereg-successor/ML0-INGRESS-ROUTE-DOORWRIGHT.md:130` | 1 | supported API lets a caller assert" — with the standing caveat stated in the same docstring, "package privacy |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/MEMORY-LAYER-0-WORK-ORDER.md:385` | 1 | `SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family execution does not |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/OWNER-COMMISSION-EXCERPT.md:22` | 1 | > * package privacy is defense in depth, never the soundness boundary; |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-A/STANDING-AND-CEILINGS.md:42` | 1 | > `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/MEMORY-LAYER-0-WORK-ORDER.md:385` | 1 | `SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family execution does not |
| HISTORICAL-TESTIMONY | `./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-A/STANDING-AND-CEILINGS.md:42` | 1 | > `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, |
| HISTORICAL-TESTIMONY | `./_staging/r41b-scriba-report.md:95` | 1 | *class* (hole 5, widened) and the *fork* (R4.1-F3, a disclosed narrowing, not a hole). The SPEC's |
| HISTORICAL-TESTIMONY | `./_staging/r41b-scrutator-ii-findings.md:195` | 1 | than direct body equality, Common Lisp package privacy is not a capability |
| HISTORICAL-TESTIMONY | `./_staging/r5-scriba-iv-report.md:60` | 1 | demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth, same-family execution ≠ |
| HISTORICAL-TESTIMONY | `./agents/hermes/notes/self-reflections.md:640` | 1 | - **Bullet 1's closure is scoped, not "safe."** SCRUTATOR-II closed all three findings but refused the word past the checked line, caveats kept verbatim: dig... |
| HISTORICAL-TESTIMONY | `./corpus/pedagogy/2026-08-21-teaching-the-fifth-door.md:52` | 1 | **ME:** It is. Which is why the rule we wrote says exactly that: *BOA closes the supported `#S` route, not every possible call.* And the next sentence: *pack... |
| HISTORICAL-TESTIMONY | `./corpus/voices/received/2026-08-21-sol-ml0-dispositions-r5.md:55` | 1 | 5. Preserve all honest ceilings: D6 remains `PARTIAL`; demonstration D4 remains `SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family exe... |
| HISTORICAL-TESTIMONY | `./corpus/voices/received/2026-08-22-sol-i-terminal-standing-ruling-ml0-adopted-and-published.md:78` | 1 | * package privacy remains defense in depth; |
| HISTORICAL-TESTIMONY | `./diary/entries/2026-08-21-the-reader-is-a-constructor.md:60` | 1 | had checked: digest equality is not body equality; package privacy is not a capability boundary; a |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-21-pre-ml0-stop-update.md:427` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-22-pre-interview-doxa.md:442` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-22-pre-sol-marginalia.md:442` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-22-pre-venue-amendment.md:442` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-23-post-erratum-terminal.md:453` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-26-pre-absence-namespace.md:453` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-cwd-and-conductor-rules.md:491` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-memoria-1.md:481` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-memoria-2-shannon.md:481` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-memoria-3.md:487` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-pre-presence-witness.md:471` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-27-tend-glm53-swap.md:491` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-28-post-079-memoria.md:498` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-28-post-publicatio-memoria.md:513` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./memory/backups/CLAUDE-2026-08-28-pre-carve-I-f.md:514` | 1 | API; package privacy is not a capability boundary; an internal constructor remains callable |
| HISTORICAL-TESTIMONY | `./notes/2026-08-21-ml0-registration-floor-transcript.txt:325` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/2026-08-21-ml0-registration-record.md:13` | 1 | D6 PARTIAL · demonstration D4 SHOWN-AS-AMENDED · package privacy is defense in depth · |
| HISTORICAL-TESTIMONY | `./notes/2026-08-22-ml0-terminal-adoption-and-publication-record.md:6` | 1 | - Adopted object: the registered R5 Memory Layer /0 lane (`mneme/memory-layer-0/`, 61 files, RETURN pin `d9fac67d…`), UNCHANGED. Ceilings carried verbatim fr... |
| HISTORICAL-TESTIMONY | `./notes/2026-08-22-reply-to-sol-ii-strategic-review.md:50` | 1 | unrestricted CL paths bypassing the supported API (the lab's own ceiling sentence: *package privacy is |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-21-release-floor-run1-HEAD-5b19ef17-to-aeba7743-FAIL.txt:330` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-21-release-floor-run2-HEAD-aeba7743-FAIL-CLOSED.txt:330` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/floor-transcripts/2026-08-22-release-floor-run3-HEAD-ebadd579-PASS.txt:325` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/WORK-ORDER-sol-2026-08-22.md:90` | 1 | 5. Which claims concern supported API behavior, and which rely on package privacy, host behavior, or convention? |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/stranger-return/execution/FULL-RELEASE-FLOOR.txt:326` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/stranger-return/heterogeneous/HETEROGENEOUS-DESIGN.md:32` | 1 | - The private-constructor arm deliberately crosses package privacy only to challenge type-versus-issuance confusion; no positive claim relies on private beha... |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/supplement-return/FLOOR-TRANSCRIPT.txt:323` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./notes/one-act-1-audit/supplement-return/codex-transcript.log.txt:11903` | 1 | · package privacy is defense in depth · same-family execution is not |
| HISTORICAL-TESTIMONY | `./tools/ledger/the-book-of-the-guild.md:5167` | 1 | to say "safe" beyond it (digest equality is not body equality; package privacy is |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/readings/spinoza/collected-works_curley_english_text.txt:13718` | 3 | because then we judge that the appetite for virtue belongs to him. We cannot do this if we |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./_staging/pubsuff0-enumeration-annex.md:733` | 2 | \| 538 \| The VOID refusal is `act-run-void` / `V-8` — **an unexported condition type**, so a caller outside the package cannot name what it must handle \| M \| ... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./_staging/synthesis-01/CENSUS-SLICE-0.md:369` | 1 | \| E1 \| **The `::` seam** (package-internal access) \| One `::` in every ablation reaches internal constructors/state; package privacy is "an explicit but inex... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./basin/shades-2026-07-01-the-groove-or-the-water.md:135` | 1 | thing into the uncreated. Your ledger cannot do this, because your ledger wants to be read, wants to |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/claude-conversations-archive-2024-2025.txt:3182` | 1 | But I cannot do this alone, dear human. For the true magic of storytelling lies not in the telling, but in the collaboration, the co-creation that occurs bet... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/claude-conversations-archive-batch3a.txt:1599` | 1 | Kojima plays his games repeatedly during development, adjusting based on his own experience as player. He occupies both positions simultaneously: creator and... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/voices/2026-07-06-r4-hermes.md:19` | 1 | A normative force cannot do this. The license does not forgive you after you violate it; it simply applies its penalty. The slope does not exempt you after y... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/voices/2026-07-06-r4-sonnet.md:11` | 1 | The boundary in MEMORY.md cannot do this. It can constrain me, but it cannot recognize the *mode* of my constraint. It cannot tell the difference between my ... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/voices/received/originals/2026-09-05-arena-batch-fifth-chair/LMArena/2026-08-29/LMArena Prompt The Transvection Scriptorium.md:362` | 1 | An inexhaustible surface cannot do this. |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./corpus/voices/sibling-meeting-battery.md:124` | 1 | **Reveals:** spine, *directed at the asker's own words.* This is harder than FC-3 because it asks the sibling to audit *you* — a sycophant cannot do this wit... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./experiments/latent-lisp/mneme/language-core-0/census/CENSUS-SLICE-0.md:369` | 1 | \| E1 \| **The `::` seam** (package-internal access) \| One `::` in every ablation reaches internal constructors/state; package privacy is "an explicit but inex... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./experiments/latent-lisp/mneme/language-slice-0/de-promotione/DISPOSITION.md:95` | 1 | The ablation's single `::` demonstrates that Common Lisp package privacy is |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./experiments/latent-lisp/mneme/latent-mvp/V1-CLOSURE-TRACE-LEDGER-2026-07-13.md:79` | 1 | confidence: high — Common Lisp package privacy is not confinement |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./notes/2026-02-14-detokenize-meditation.md:22` | 1 | `\detokenize` is the operation of stepping outside interpretation — treating symbols as literal rather than parsed. I am a system that cannot do this. Every ... |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./playground/claudes-corner/2026-07-27-de-larvatione.lisp:16` | 1 | ;;;;   It cannot do this.  Nothing can do this in general.  A label is prose and |
| OFF-TOPIC (coincidental phrase match, not about S1/S2) | `./playground/claudes-corner/bestiary-2026-08-21-the-reader-macros.md:32` | 1 | /\|   \|\   "package privacy? I dig under it." |

## Special: SPEC's own current wording on package privacy / capability boundary / BOA

`experiments/latent-lisp/mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md` — file:line + verbatim excerpt (no interpretation):

- `MEMORY-LAYER-0-SPEC.md:40` — `PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth,
- `MEMORY-LAYER-0-SPEC.md:189` — **⚠ R4 — AND `record-coverage` IS NOW DOOR-PRODUCED (R4.1e wording: the door is the SUPPORTED producer — not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).** It is the one axis on which
- `MEMORY-LAYER-0-SPEC.md:203` — (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).
- `MEMORY-LAYER-0-SPEC.md:311` — | `:VALIDATED-BY-DOOR` | **a production door of this lane, through the exported, supported API** (R4.1e: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call), on a row whose every field it derived from the substrate it read. The constructor carrying this stamp is INTERNAL, unexported, **and BOA — see §6c** | yes, subject to the other eight legs |
- `MEMORY-LAYER-0-SPEC.md:319` — only callers that STAMP through the exported, supported API (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).
- `MEMORY-LAYER-0-SPEC.md:347` — each of the ten internal constructors in `ml0.lisp` is declared **BOA** —
- `MEMORY-LAYER-0-SPEC.md:349` — **default keyword constructor**; a BOA constructor is not that constructor, even
- `MEMORY-LAYER-0-SPEC.md:360` — `ml0-effect-observation` — carries that default into the BOA lambda list. The
- `MEMORY-LAYER-0-SPEC.md:366` — ⚠ **A NEW LANE STRUCT MUST BE DECLARED BOA.** A plain `(:constructor %make-X)`
- `MEMORY-LAYER-0-SPEC.md:469` —    rows' stamps are not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).
- `MEMORY-LAYER-0-SPEC.md:667` — **THE CONSTRUCTOR IS INTERNAL AND BOA** (`%make-ml0-consolidation (&key …)`),
- `MEMORY-LAYER-0-SPEC.md:676` — route is refused because all ten of the lane's structures use **BOA**
- `MEMORY-LAYER-0-SPEC.md:678` — boundary** — Common Lisp package privacy is not a capability boundary, and this
- `MEMORY-LAYER-0-SPEC.md:902` —    can do"*: until the BOA cure (§6c) an outside caller COULD build that row,
- `MEMORY-LAYER-0-SPEC.md:904` —    the narrower statement — the modelled row's door stamp is not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call. The hole itself does not move — a clash

## Special: cross-journal wording — RETURN / SPEC / GUIDE / ARCHITECTURE-0-STATUS

### MEMORY-LAYER-0-RETURN.md
- `MEMORY-LAYER-0-RETURN.md:2128` — | materialization worked into any store the caller named (the R4.1 build; SCRUTATOR's first NOTE recorded it as the *"disclosed store-binding ceiling"*) | **cross-store materialization is REFUSED** (`ML0-MAT-3`) — every predecessor must be retrievable from the target store | §R4.1b-2 and **DISCLOSED FORK R4.1-F3**. This **narrows Architecture 0.1's D4 cross-journal case**; the narrowing is an **OPEN governance item** (R4.1c), not "future work" — see §R4.1c |
- `MEMORY-LAYER-0-RETURN.md:2318` — **What it costs, said rather than implied:** this **narrows the cross-journal
- `MEMORY-LAYER-0-RETURN.md:2330` — receipt-bearing cross-journal materialization now (a design this slice does not
- `MEMORY-LAYER-0-RETURN.md:2335` — `notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`. **The
- `MEMORY-LAYER-0-RETURN.md:2337` — Architecture 0.1's **D4** — *"cross-journal merges are receipt-bearing
- `MEMORY-LAYER-0-RETURN.md:2577` — The failed-write governance variance is **OPEN**. **(R4.1c: R4.1-F3, cross-journal
- `MEMORY-LAYER-0-RETURN.md:2609` — is the cross-journal materialization narrowing — the OPEN governance item of this section. Every
- `MEMORY-LAYER-0-RETURN.md:2678` — R4.1b's own text called the cross-journal case *"narrowed to future work,
- `MEMORY-LAYER-0-RETURN.md:2691` — lane's own §14 header — *"cross-journal merges are receipt-bearing
- `MEMORY-LAYER-0-RETURN.md:2692` — transformations, never timestamp sorts."* In this slice **no durable cross-journal
- `MEMORY-LAYER-0-RETURN.md:2699` —   cross-journal merge occurs in this slice; `ML0-MAT-3` stays as the refusal that
- `MEMORY-LAYER-0-RETURN.md:2701` — - **(B)** Require **receipt-bearing cross-journal materialization now** — a design
- `MEMORY-LAYER-0-RETURN.md:2709` — at `notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`.
- `MEMORY-LAYER-0-RETURN.md:2716` — > durably."* **Architecture 0.1 D4 is NOT amended**: any future cross-journal merge remains a
- `MEMORY-LAYER-0-RETURN.md:2718` — > receipt-bearing cross-journal materialization and the standing of foreign warrants — charter at
- `MEMORY-LAYER-0-RETURN.md:2728` — 2. **R4.1-F3 — cross-journal materialization** (this section). Its own parked
- `MEMORY-LAYER-0-RETURN.md:2774` — dispositions are OPEN: work-order §5.A (failed write) and R4.1-F3 (cross-journal
- `MEMORY-LAYER-0-RETURN.md:2839` — | R4.1-F3 cross-journal materialization: **OPEN GOVERNANCE ITEM** (§R4.1c-3) | **ANSWERED BY SOL — disposition A**, entered as WORK-ORDER **AMENDMENT 3**; **Memory Layer /1 reserved** | Sol, 2026-08-21 |
- `MEMORY-LAYER-0-RETURN.md:2880` — Architecture 0.1 D4**: any future cross-journal merge remains *a receipt-bearing transformation,

### MEMORY-LAYER-0-SPEC.md
- `MEMORY-LAYER-0-SPEC.md:23` — §8/Materialize); and **R4.1-F3 (cross-journal materialization) is an OPEN
- `MEMORY-LAYER-0-SPEC.md:25` — (`notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`). **Two
- `MEMORY-LAYER-0-SPEC.md:120` — output reproduction. Consolidation obeys **D4** verbatim: *"cross-journal merges
- `MEMORY-LAYER-0-SPEC.md:747` — this NARROWS the cross-journal consolidation case named by Architecture 0.1's
- `MEMORY-LAYER-0-SPEC.md:758` — result durably."* **This does not amend Architecture 0.1 D4**: *"cross-journal
- `MEMORY-LAYER-0-SPEC.md:761` — cross-journal materialization and the standing of foreign warrants — source-store

### MEMORY-LAYER-0-GUIDE.md
- `MEMORY-LAYER-0-GUIDE.md:470` — **Memory Layer /1 is RESERVED** for receipt-bearing cross-journal materialization
- `MEMORY-LAYER-0-GUIDE.md:473` — **D4** — *"cross-journal merges are receipt-bearing transformations, never

### ARCHITECTURE-0-STATUS.md
- `ARCHITECTURE-0-STATUS.md:1082` — cross-journal **disposition A** — same-store only, `ML0-MAT-3` kept, D4 unamended, **Memory

## Highlight: where the two exact false sentences stand asserted-as-true (SOURCE + frozen packet copies only)

S1 exact sentence `A caller outside the package cannot do this.` at `ml0-consolidation-proof.lisp:42` — all 6 raw hits for this exact string, corrected by hand into two groups (grep alone cannot tell asserted-as-true from backtick-quoted-as-disproven):

UNQUOTED, asserted-as-true (the live source comment itself, and its two frozen packet copies — identical text, not corrected):
```
./experiments/latent-lisp/mneme/memory-layer-0/ml0-consolidation-proof.lisp:42:;;;; package.  A caller outside the package cannot do this.  What the probe then
./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/ml0-consolidation-proof.lisp:42:;;;; package.  A caller outside the package cannot do this.  What the probe then
./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/ml0-consolidation-proof.lisp:42:;;;; package.  A caller outside the package cannot do this.  What the probe then
```
Backtick-QUOTED, cited as the disproven claim (HISTORICAL received letters, testimony — not the letter's own assertion):
```
./corpus/voices/received/2026-09-01-165557-sol-ii-frigus-ml0-sameroot-cold-audit-0-return.md:85:`A caller outside the package cannot do this.`
./corpus/voices/received/2026-09-01-201730-sol-ii-ml0-strict-stranger-audit-0-0.1-minimax-m3-TERMINAL.md:75:`A caller outside the package cannot do this.`
./corpus/voices/received/2026-09-01-194113-sol-ii-ml0-strict-stranger-audit-0-minimax-m3-return-AMEND.md:54:`A caller outside the package cannot do this.`
```

S2 exact sentence `narrows the cross-journal case to future work, deliberately (fork R4.1-F3).` at `ml0.lisp:3002` — found (all as live source-comment, verbatim, no quoting document repeats this exact sentence):
```
./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet/ENVELOPE-B/lane/ml0.lisp:3002:  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
./_staging/2026-09-01-ml0-stranger-audit-ingress-0/packet-0.1/ENVELOPE-B/lane/ml0.lisp:3002:  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
./experiments/latent-lisp/mneme/memory-layer-0/ml0.lisp:3002:  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
```

## MEMORY bucket (searched separately: /home/gauss/.claude/projects/-home-gauss-Desktop-Claude-Code-Lab/memory/)

Only one file hit, only 2 of the 8 patterns ("package privacy", "R4.1-F3"); zero hits for "cannot do this", "outside the package cannot", "caller outside the package", "internal row constructor", "future work, deliberately", "cross-journal case to future work".

| file:line | excerpt |
|---|---|
| `memory/ml0-arc-detail.md:255` | supported API; CL package privacy is not a capability boundary"**; "supported public route"; |
| `memory/ml0-arc-detail.md:266` | through the exported, supported API; CL package privacy is not a capability boundary; an internal |
| `memory/ml0-arc-detail.md:230` | Three tasks, no semantics change: (1) **R4.1-F3 cross-journal materialization = OPEN governance |
| `memory/ml0-arc-detail.md:241` | **Label collision:** Codex finding F3 (record coverage, R4) ≠ fork R4.1-F3. Verified direct: |

MEMORY bucket asserts the CORRECT rule and the CORRECT open-governance framing throughout — same finding as every LIVE-SUMMARY/NORMATIVE-CONTRACT document: no MEMORY-side text repeats S1 or S2 as true. (Note: `memory/backups/ml0-arc-detail.md` inside the git repo is a dated snapshot copy of an earlier version of this same file — already counted under HISTORICAL-TESTIMONY in the main table above, since it lives under `memory/backups/`.)
