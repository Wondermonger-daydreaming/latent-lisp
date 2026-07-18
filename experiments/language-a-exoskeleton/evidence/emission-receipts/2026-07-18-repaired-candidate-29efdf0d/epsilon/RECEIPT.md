# RECEIPT-EPSILON — Clean Verification Room #1

**Subject:** REPAIRED Language-A emission candidate (R15 OpenRouter route substitution)
**Room:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/epsilon/`
**Clone source (only):** `/home/gauss/Codex-Lab/wt-language-a` (local path)
**Posture:** network-OFF · offline checks only · one run per check · no repairs · no re-runs · a failure is a finding.

---

## 1. Identity verifications (all THREE — verified)

| Pin | Expected | Observed | Match |
|-----|----------|----------|-------|
| HEAD commit | `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` | `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` | ✅ YES |
| HEAD^{tree} | `b6e5f91986723f462ca66ece957853a6bdd630cc` | `b6e5f91986723f462ca66ece957853a6bdd630cc` | ✅ YES |
| CONSTRUCTION-MANIFEST.json sha256 | `10b93deb57307e6e5e12eb59168413d3cfe281c1b92ee24ca0a61724cb3abad4` | `10b93deb57307e6e5e12eb59168413d3cfe281c1b92ee24ca0a61724cb3abad4` | ✅ YES |

Checkout message: `HEAD is now at 29efdf0 Language-A emission runner: REPAIRED EMISSION CANDIDATE (R15 OpenRouter route substitution)`
Branch of record: `codex/language-a-tranche-b-prereg-freeze-and-lineage-search`.

## 2. Environment (recorded BEFORE checks — `ENVIRONMENT.txt`)

- `date -u` : Sat Jul 18 05:18:35 UTC 2026
- `uname -a`: Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux
- `python3 --version`: Python 3.11.14
- `git --version`: git version 2.43.0

## 3. Mock-only import proof (verified BEFORE running the teeth suite)

`harness/test_emission_gates.py` import block (lines 13–32), verbatim:

```
import json
import shutil
import sys
import tempfile
from datetime import timedelta
from decimal import Decimal
from pathlib import Path

import tranche_b as tb
import run_emission as re
from run_emission import (
    ReservationLedger, EmissionRunner, gate_bank_identity, gate_item_consistency,
    gate_run_window, gate_schedule, gate_r15_record, load_subject_binding,
    BankIdentityRefused, ItemConsistencyRefused, ScheduleGateRefused,
    RunWindowRefused, AttemptCeilingRefused, SpendReservationRefused,
    R15RecordRefused, TransportBudgetExhausted, SubjectBindingRefused,
    parse_iso_utc,
)
from provider_live_emission import MockProvider
from util import PACKET_ROOT, load_json
```

- The **only** provider symbol imported is `MockProvider`. No live/HTTP provider class is imported into the test.
- The test's docstring (line 6): `Runs fully offline (no network, no keys, no provider contact).`
- Every provider instantiation in the test is via `provider_factory=lambda subject: MockProvider(...)` (lines 193, 212) — mock only.
- MockProvider self-identifies offline: `"provider": "MockRouter (offline, no network)"` (`harness/provider_live_emission.py` lines 351, 359).
- Honest note: `harness/provider_live_emission.py` statically imports `urllib.error` / `urllib.request` at module top (lines 51–52) — these belong to the *live* provider path and are pulled in merely by importing the module for `MockProvider`. A static import performs **no** network I/O; the test never instantiates a live provider, so the executed path is mock-only. No network occurred.

## 4. Check table (verdict verbatim + exit code)

| # | Command | Verdict (verbatim) | Exit |
|---|---------|--------------------|------|
| 3a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 |
| 3b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 |
| 3c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 |
| 3d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 15/15 PASS` | 0 |

**Teeth suite 15/15: YES.** All 15 verdict lines (verbatim from `log_3d_teeth.txt`):

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

R15-repaired-suite specifics confirmed present and passing: **R15-record gate** (tampered→R15RecordRefused), **run-window gate**, **serving-provider capture** (MockRouter offline census rows), and **worst-case USD 5.944873 < 8.00** (byte-exact, asserted twice).

## 5. Independent R15 record validation (step 3e)

- File: `experiments/language-a-exoskeleton/operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json`
- Method: `preauthorship.validate_record_digest(record)` (recomputes `sha256` over canonical digest material; raises `RecordDigestMismatch` on any mismatch). **No exception raised → PASS.**
- `record_id`: `owner-decision:owner-route-substitution-and-reemission-v1`
- **`record_digest`: `sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`**
- `canonical_byte_length`: 6241 (matched by the validator)
- Exit: 0

## 6. Log integrity (sha256 of every artifact in this room)

```
2ef87b48c18b8170741388f47efb136759056619e4ded7d2c5349f897c1eee4a  ENVIRONMENT.txt
173547bb5607ab1a4f37ceb898d10cff747b28892f236ef4bfc2761be927d07e  log_3a_manifest_check.txt
76a1695c660c66b060efa3573c0d372ed3deade086a7fabbef82fb3da11aee78  log_3b_manifest_protected.txt
39f704a6e00422b6d16cd579bf1bd8484351409f663069417c79218a513a30fd  log_3c_exposure_readiness.txt
4002e7057e52551bb2e282c4f0c7b81730ce7bca95a57cc9e211ae537a1d8a88  log_3d_teeth.txt
160170228cd0f2f33a971de49f053dbddf178241e4a5059b119f14088721a859  log_3e_r15_digest.txt
```

## 7. Hermeticity / no stray writes

After all checks, in the clone `.../epsilon/repo`:
- `git status --porcelain` → **empty** (no modified/untracked files; teeth suite is self-cleaning, temp-dir based)
- `git rev-parse HEAD` → `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` (still pinned)

## 8. Attestations (explicit)

- These results **attach to commit `29efdf0d97becc32fed3a1d2477ee823cad0ccc5` / tree `b6e5f91986723f462ca66ece957853a6bdd630cc`** and no other state.
- **No network activity, no provider contact, no key content** was involved in any step; all checks ran offline against a local clone. The executed provider path was `MockProvider` ("MockRouter (offline, no network)") exclusively.
- Nothing under `/home/gauss/freezer` was touched or read. No key material was read or emitted.
- Only the clone at `/home/gauss/Codex-Lab/wt-language-a` was used as source; no other room was touched.

**VERDICT: PASS across all checks. No FAIL, no BLOCK.**

— RECEIPT-EPSILON (Claude Opus 4.8, 1M context)
