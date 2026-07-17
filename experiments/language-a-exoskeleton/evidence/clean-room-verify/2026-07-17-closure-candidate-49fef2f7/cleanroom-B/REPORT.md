# ASSAY-BETA — Clean-Room Verification Report (cleanroom-B)

**Verifier:** ASSAY-BETA (independent second clean-room verifier)
**Room:** /home/gauss/.claude/jobs/7d1d2626/tmp/cleanroom-B/
**Clone source:** /home/gauss/Codex-Lab/wt-language-a (local, offline — no remote fetch)
**Scope:** network-OFF; no provider contact, no target generation, no scoring, no key exposure.

---

## 1. Pinned identities verified (all three MATCH)

| Identity | Pinned value | Observed value | Match |
|----------|--------------|----------------|-------|
| commit (git rev-parse HEAD) | 49fef2f7949bae5f216b20d5ed06ff2b18736d94 | 49fef2f7949bae5f216b20d5ed06ff2b18736d94 | YES |
| tree (git rev-parse HEAD^{tree}) | 5eeaedc690bde21ca013e499545e66dd39af57f4 | 5eeaedc690bde21ca013e499545e66dd39af57f4 | YES |
| CONSTRUCTION-MANIFEST.json sha256 | 3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223 | 3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223 | YES |

Branch confirmation: HEAD (detached at 49fef2f) is contained in
codex/language-a-tranche-b-prereg-freeze-and-lineage-search (matches pinned branch).
Commit subject at HEAD: "Rebuild CONSTRUCTION-MANIFEST.json as Language-A closure-candidate manifest".

No mismatch. Replay proceeded against the exact pinned identity.

---

## 2. Invocation + citation

- Script: experiments/language-a-exoskeleton/verify-pilot.sh (61 lines).
- Documented invocation: `bash verify-pilot.sh` — cited at
  experiments/language-a-exoskeleton/README.md:15 (heading "Local construction verification").
- Takes NO arguments. Script self-exports LAE_NETWORK_MODE=off (line 9) and
  PYTHONDONTWRITEBYTECODE=1 (line 8). No flag guessed; ran exactly as documented.

---

## 3. Environment (full copy in ENVIRONMENT.txt)

- date -u: Fri Jul 17 23:37:44 UTC 2026
- uname -a: Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux
- python3 --version: Python 3.11.14
- git --version: git version 2.43.0
- Working directory at run: /home/gauss/.claude/jobs/7d1d2626/tmp/cleanroom-B/repo/experiments/language-a-exoskeleton
- Command run: bash verify-pilot.sh

---

## 4. Result

- Exit code: 0
- Verdict: PASS / GREEN — 12/12 network-off checks green.

Script output verbatim (13 verdict lines; full log in verify-pilot-output.log):

    PASS  mneme-existing-floor
    PASS  design-reproduction
    PASS  packet-unit-and-mutation-tests
    PASS  preauthorship-unit-tests
    PASS  preauthorship-schema-lineage-mutations
    PASS  synthetic-precision-replay
    PASS  claim-ceiling-lint
    PASS  manifest-lineage-protected
    PASS  key-open-denial
    PASS  unresolved-owner-exposure-refusal
    PASS  p2a-absent
    PASS  zero-network-and-exposure-census
    ALL PILOT PACKET FLOORS HOLD — 12/12 network-off checks green.

Note on two intentionally-inverted floors (both PASS by design):
- unresolved-owner-exposure-refusal (verify-pilot.sh:33-42): PASS because
  `harness/manifest.py exposure-readiness` correctly FAILS with OwnerResolutionRequired
  (exposure deliberately refused while owner slots remain open).
- key-open-denial (line 31): PASS via --prove-key-denial (no private key created/opened).

---

## 5. Census / exclusion accounting

The final floor (zero-network-and-exposure-census, verify-pilot.sh:50-59) asserts, against
evidence/NETWORK-CALL-CENSUS.json, that each of the following equals 0:
network_calls, live_provider_calls, real_item_model_exposures, real_item_grader_exposures,
pilot_verdicts. All assertions held.

evidence/NETWORK-CALL-CENSUS.json contents (verbatim):

    {"dry_run_provider_calls":312,"live_provider_calls":0,"network_calls":0,"pilot_verdicts":0,"real_item_grader_exposures":0,"real_item_model_exposures":0}

Interpretation: 312 provider requests exist ONLY as offline dry-run entries; zero live
provider calls, zero network calls, zero real-item model/grader exposures, zero pilot
verdicts. Consistent with network-OFF scope.

No network access was attempted by the script during this run -> no BLOCK finding.

---

## 6. Output-log integrity

- sha256 of verify-pilot-output.log:
  bdf9521894aa683e2bb7bb407bd6576f8a4eb2d60e6fc5aa4c193a41e8c60926

---

## 7. Footprint / file landing verification

All artifacts land solely inside cleanroom-B. /home/gauss/Codex-Lab/wt-language-a was not touched
(clone read-only; no writes back to source). See ls -la at report-write time (below).

---

## 8. Deviations

None. Fresh offline clone; detached-HEAD checkout of the exact pin; all three identities matched;
ran the documented invocation once with no arguments; captured complete stdout+stderr and exit code;
did not re-run. No ambiguity encountered, no network attempt, no repair performed.
