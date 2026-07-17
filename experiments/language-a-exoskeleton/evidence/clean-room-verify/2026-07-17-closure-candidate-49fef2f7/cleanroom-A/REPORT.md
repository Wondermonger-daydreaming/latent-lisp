# ASSAY-ALPHA — Clean-room verification report: Language-A closure candidate

**Verifier:** ASSAY-ALPHA (independent clean-room verifier #1)
**Room:** `/home/gauss/.claude/jobs/7d1d2626/tmp/cleanroom-A/`
**Source (local, offline):** `/home/gauss/Codex-Lab/wt-language-a` (fresh `git clone`, no network fetch)
**Run date (UTC):** Fri Jul 17 23:37 UTC 2026

---

## 1. Pinned identities verified (three comparisons)

Replayed against exactly the pin. All three match — the bytes proved the pin honest.

| Identity | Pinned (expected) | Observed | Match |
|---|---|---|---|
| commit `git rev-parse HEAD` | `49fef2f7949bae5f216b20d5ed06ff2b18736d94` | `49fef2f7949bae5f216b20d5ed06ff2b18736d94` | YES |
| tree `git rev-parse HEAD^{tree}` | `5eeaedc690bde21ca013e499545e66dd39af57f4` | `5eeaedc690bde21ca013e499545e66dd39af57f4` | YES |
| `sha256sum experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json` | `3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223` | `3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223` | YES |

Branch context of the pin: `codex/language-a-tranche-b-prereg-freeze-and-lineage-search` (checkout was detached at the pinned commit, which is expected and fine).

---

## 2. Invocation + citation

- **Documented invocation:** `bash verify-pilot.sh`
- **Citation:** `experiments/language-a-exoskeleton/README.md`, **line 15** (under the "Local construction verification:" heading, lines 13-15). Cross-checked against the script itself: `experiments/language-a-exoskeleton/verify-pilot.sh` takes **no arguments**, is **non-interactive**, and self-sets `export LAE_NETWORK_MODE=off` at line 9. No flags were guessed; no ambiguity to resolve.
- **Exact command line run:** `bash verify-pilot.sh` (cwd `.../repo/experiments/language-a-exoskeleton`).

---

## 3. Environment summary (captured BEFORE the run; full record in `ENVIRONMENT.txt`)

- date -u: **Fri Jul 17 23:37:42 UTC 2026**
- uname -a: `Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux`
- python3: **Python 3.11.14**
- git: **git version 2.43.0**
- working directory: `/home/gauss/.claude/jobs/7d1d2626/tmp/cleanroom-A/repo/experiments/language-a-exoskeleton`

---

## 4. Result

- **Exit code: `0`**
- **PASS/FAIL per the script's own output: PASS (all floors).**

Script verdict lines, quoted **verbatim** from `verify-pilot-output.log`:

```
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
```

**GREEN: yes.** 12/12 network-off checks green, exit 0.

---

## 5. Census / exclusion accounting

The script (verify-pilot.sh lines 50-59) loads `evidence/NETWORK-CALL-CENSUS.json` and **asserts** these five fields equal zero before printing `PASS zero-network-and-exposure-census`. It does not echo the numbers; the underlying file it validated contains:

```json
{"dry_run_provider_calls":312,"live_provider_calls":0,"network_calls":0,"pilot_verdicts":0,"real_item_grader_exposures":0,"real_item_model_exposures":0}
```

Asserted-zero fields (all satisfied): `network_calls=0`, `live_provider_calls=0`, `real_item_model_exposures=0`, `real_item_grader_exposures=0`, `pilot_verdicts=0`. The `dry_run_provider_calls=312` field is **not** constrained to zero (it is the declared network-off rendering request count, matching the README's "exact 312-request network-off rendering" path) — descriptive, not a live-call count.

Other exclusion floors that passed: `key-open-denial` (private-key open is denied), `unresolved-owner-exposure-refusal` (exposure-readiness correctly *refuses* with `OwnerResolutionRequired` — a passing refusal-to-expose), `p2a-absent` (`experiments/mneme-enforcement-prototype` correctly absent), `manifest-lineage-protected`.

---

## 6. Network / scope compliance

- Network was **OFF** throughout. The clone was from the **local** path `/home/gauss/Codex-Lab/wt-language-a` only; no remote URL fetched.
- The script did **not** attempt any network access, provider contact, key exposure, or target scoring — it self-sets network-off mode and its own census floor asserts zero live/network calls. **No BLOCK finding.**
- Footprint is entirely within the cleanroom dir. `/home/gauss/Codex-Lab/wt-language-a` was not touched.

---

## 7. Output-log integrity

- `sha256(verify-pilot-output.log)` = `384256bc266b4770fd2081149216176b2233f748e06bebb6e9e66dda796876c1`

---

## 8. Deviations

**None.** One clone, one checkout, one documented run, one record. No re-runs, no flag guessing, no repairs. Identities matched on the first comparison; the run went green on the first (and only) execution.

---

## Verdict

The pinned Language-A closure candidate **replays GREEN in an independent clean room**: all three pinned identities match byte-for-byte, and the documented `bash verify-pilot.sh` exits `0` with 12/12 network-off floors PASS under a verified network-off, no-exposure regime.
