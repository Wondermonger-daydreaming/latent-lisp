# RECEIPT-ZETA — Clean Verification Room (R15-repaired Language-A emission candidate)

**Room:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/zeta/`
**Verifier:** RECEIPT-ZETA (second independent clean room; no knowledge of the other room)
**Posture:** every pin assumed lying until the bytes proved otherwise. One run per check, no repairs, no re-runs.
**Clone source (ONLY):** `/home/gauss/Codex-Lab/wt-language-a` (local path). Network OFF.

---

## 1. IDENTITY VERIFICATIONS (all shown, all match)

Fresh clone → `git checkout 29efdf0d97becc32fed3a1d2477ee823cad0ccc5` (detached HEAD).

| Pin | Expected | Observed | Match |
|-----|----------|----------|-------|
| HEAD commit | `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` | `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` | **YES** |
| HEAD^{tree} | `b6e5f91986723f462ca66ece957853a6bdd630cc` | `b6e5f91986723f462ca66ece957853a6bdd630cc` | **YES** |
| CONSTRUCTION-MANIFEST.json sha256 | `10b93deb57307e6e5e12eb59168413d3cfe281c1b92ee24ca0a61724cb3abad4` | `10b93deb57307e6e5e12eb59168413d3cfe281c1b92ee24ca0a61724cb3abad4` | **YES** |

Checkout log line: `HEAD is now at 29efdf0 Language-A emission runner: REPAIRED EMISSION CANDIDATE (R15 OpenRouter route substitution)`

**Branch present:** `codex/language-a-tranche-b-prereg-freeze-and-lineage-search` (local + `remotes/origin/HEAD` points to it). Confirmed.

---

## 2. ENVIRONMENT (captured BEFORE checks — see `ENVIRONMENT.txt`)

- `date -u`: `Sat Jul 18 05:18:34 UTC 2026`
- `uname -a`: `Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux`
- `python3 --version`: `Python 3.11.14`
- `git --version`: `git version 2.43.0`

---

## 3. MOCK-ONLY IMPORT PROOF (verified BEFORE running the teeth suite)

The teeth suite imports exactly one provider symbol — a mock. Quoted import line from
`harness/test_emission_gates.py` (line 31):

```python
from provider_live_emission import MockProvider
```

Every provider instantiation in the suite is `MockProvider` (lines 193, 212, and the census probe):

```python
provider_factory=lambda subject: MockProvider(mode="null-content"))
provider_factory=lambda subject: MockProvider(mode="transport-always"))
```

`grep -nE "Provider|provider|http|requests|urllib|openrouter|socket|network|api_key|API_KEY"` over the
suite returns **no** live-provider instantiation and **no** network primitive. The only `openrouter.ai`
occurrences are string assertions on **mock** census route metadata; the serving-provider assertion is:

```python
assert all(r.get("serving_provider") == "MockRouter (offline, no network)" ...)
```

`MockProvider` itself (in `harness/provider_live_emission.py`, class at line 327) declares:

```python
network_capable = False
# docstring: "It never touches the network and needs no key."
```

and contains **no** `urlopen`/`urllib`/network call in its body. The module-level
`import urllib.request` is a bare import (no network); the only `urllib.request.urlopen` (line 227) lives
in the LIVE provider path, which the teeth suite never instantiates. **Conclusion: teeth run is offline, mock-only, keyless.**

---

## 4. CHECK TABLE (verdict verbatim + exit code — full output in per-check logs)

| # | Check | Verdict (verbatim) | Exit |
|---|-------|--------------------|------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 |
| d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 15/15 PASS` | 0 |
| e | `preauthorship.validate_record_digest` on R15 record | `VALIDATION: PASS (no exception raised)` | 0 |

### Teeth suite (check d) — all 15, verbatim, 15 PASS / 0 FAIL:

```
[PASS] bank-identity gate: planted-fired=True(BankIdentityRefused) clean-passed=True
[PASS] schedule gate: oversized: planted-fired=True(ScheduleGateRefused) clean-passed=True
[PASS] schedule gate: mutated binding: planted-fired=True(ScheduleGateRefused) clean-passed=True
[PASS] run-window gate: past close: planted-fired=True(RunWindowRefused) clean-passed=True
[PASS] run-window gate: before open: planted-fired=True(RunWindowRefused) clean-passed=True
[PASS] spend gate: worst-case overflow: planted-fired=True(SpendReservationRefused) clean-passed=True
[PASS] attempt-ceiling gate: 345: planted-fired=True(AttemptCeilingRefused) clean-passed=True
[PASS] R15-record gate: tampered: planted-fired=True(R15RecordRefused) clean-passed=True
[PASS] item-consistency gate: bad task digest: planted-fired=True(ItemConsistencyRefused) clean-passed=True
[PASS] subject-binding gate: wrong count: planted-fired=True(SubjectBindingRefused) clean-passed=True
[PASS] null-content: determinate, no retry, continues
[PASS] transport-exhaustion: honest partial stop
[PASS] clean full dry-run: 312/312, worst-case USD 5.944873 < 8.00
[PASS] serving-provider capture: lands in mock census rows
[PASS] price-table worst-case: byte-exact 5.944873 under 8.00 ceiling
TEETH CHECKS: 15/15 PASS
```

R15-specific gates named in the charge are all present and PASS: **R15-record gate (tampered → R15RecordRefused)**,
**R15 run-window gate** (past-close + before-open), **serving-provider capture** (mock census rows), and the
**worst-case `5.944873 < 8.00` assertions** (both the clean 312/312 dry-run and the byte-exact price-table check).

---

## 5. R15 RECORD DIGEST (independently computed, check e)

File: `experiments/language-a-exoskeleton/operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json`
Validated by `preauthorship.validate_record_digest(record)` (recomputes canonical material → sha256, and
asserts `record_digest` and `canonical_byte_length` both match; raises `RecordDigestMismatch` on any drift).
No exception was raised.

- `record_id`: `owner-decision:owner-route-substitution-and-reemission-v1`
- **`record_digest`: `sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`**
- `canonical_byte_length`: `6241`

---

## 6. LOG HASHES (sha256 of every artifact in this room)

```
1e83195472bc0ed91b9c3cbf5422ba057a9898b76d1d7d02c751b35ab870a4a4  ENVIRONMENT.txt
173547bb5607ab1a4f37ceb898d10cff747b28892f236ef4bfc2761be927d07e  check_a_manifest_check.log
76a1695c660c66b060efa3573c0d372ed3deade086a7fabbef82fb3da11aee78  check_b_manifest_protected.log
39f704a6e00422b6d16cd579bf1bd8484351409f663069417c79218a513a30fd  check_c_manifest_exposure.log
4002e7057e52551bb2e282c4f0c7b81730ce7bca95a57cc9e211ae537a1d8a88  check_d_teeth.log
6064f23ad06b7969ba032de1a2aac2d21fa0f189cfdb15411852a2bfac950b69  check_e_r15_validate.log
19eaf43821a7660ec323a87c8457bf74823beb296c39f5e01aa8a683aa50f061  check_a_exit.txt
19eaf43821a7660ec323a87c8457bf74823beb296c39f5e01aa8a683aa50f061  check_b_exit.txt
19eaf43821a7660ec323a87c8457bf74823beb296c39f5e01aa8a683aa50f061  check_c_exit.txt
19eaf43821a7660ec323a87c8457bf74823beb296c39f5e01aa8a683aa50f061  check_d_exit.txt
19eaf43821a7660ec323a87c8457bf74823beb296c39f5e01aa8a683aa50f061  check_e_exit.txt
```

---

## 7. ATTESTATIONS (explicit)

- **Results attach to `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` / tree `b6e5f91986723f462ca66ece957853a6bdd630cc`.**
  All checks ran with HEAD pinned there; HEAD re-verified as `29efdf0d…` after the last check.
- **No network / no provider contact.** Clone was from the local path only; the sole provider exercised
  was `MockProvider` (`network_capable = False`, keyless), proven by import inspection before the run.
- **No key content** was read, printed, or included anywhere. Nothing under `/home/gauss/freezer` was touched.
- **No stray writes in the clone.** `git status --porcelain` was empty both before AND after all five checks;
  all outputs were written into this room only.
- **One run per check.** No repairs, no re-runs. (Zero failures encountered.)

---

## 8. `ls -la` PROOF (this room)

See below (appended live at generation time).

```
total 64
drwxr-xr-x  3 gauss gauss 4096 Jul 18 02:21 .
drwxr-xr-x  6 gauss gauss 4096 Jul 18 02:16 ..
-rw-r--r--  1 gauss gauss  283 Jul 18 02:18 ENVIRONMENT.txt
-rw-r--r--  1 gauss gauss 8046 Jul 18 02:21 RECEIPT.md
-rw-r--r--  1 gauss gauss    7 Jul 18 02:19 check_a_exit.txt
-rw-r--r--  1 gauss gauss   21 Jul 18 02:19 check_a_manifest_check.log
-rw-r--r--  1 gauss gauss    7 Jul 18 02:19 check_b_exit.txt
-rw-r--r--  1 gauss gauss   25 Jul 18 02:19 check_b_manifest_protected.log
-rw-r--r--  1 gauss gauss    7 Jul 18 02:19 check_c_exit.txt
-rw-r--r--  1 gauss gauss   34 Jul 18 02:19 check_c_manifest_exposure.log
-rw-r--r--  1 gauss gauss    7 Jul 18 02:19 check_d_exit.txt
-rw-r--r--  1 gauss gauss 1276 Jul 18 02:19 check_d_teeth.log
-rw-r--r--  1 gauss gauss    7 Jul 18 02:20 check_e_exit.txt
-rw-r--r--  1 gauss gauss  223 Jul 18 02:20 check_e_r15_validate.log
drwxr-xr-x 11 gauss gauss 4096 Jul 18 02:18 repo
```
