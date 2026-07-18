# RECEIPT — RECEIPT-DELTA (independent clean room #2)

**Subject:** Language-A EMISSION candidate — last offline gate before real provider contact.
**Room:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/delta/`
**Method:** one fresh clone from the local path only; one run per check; no repairs, no re-runs.
**Network:** OFF throughout. No provider contact. No key content opened.

---

## 1. Identity verification (all three: YES)

Fresh clone from `/home/gauss/Codex-Lab/wt-language-a` → `checkout 7da828e0…`.

| Pin | Expected | Observed | Match |
|-----|----------|----------|-------|
| HEAD commit | `7da828e05fed0c503b114cd5974a41b3bec82c83` | `7da828e05fed0c503b114cd5974a41b3bec82c83` | ✅ |
| HEAD^{tree} | `258fb265c00a6ec33ea9ac28cd55d72510427d56` | `258fb265c00a6ec33ea9ac28cd55d72510427d56` | ✅ |
| CONSTRUCTION-MANIFEST.json sha256 | `d5460a089dcd6a2ea17f974d6b26513800b5f33f89c9819514595e9f5db39420` | `d5460a089dcd6a2ea17f974d6b26513800b5f33f89c9819514595e9f5db39420` | ✅ |
| branch containing commit | `codex/language-a-tranche-b-prereg-freeze-and-lineage-search` | present, HEAD detached at 7da828e | ✅ |

## 2. Environment (recorded to ENVIRONMENT.txt BEFORE checks)

- `date -u`: Sat Jul 18 03:47:30 UTC 2026
- `uname -a`: Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 … x86_64 GNU/Linux
- `python3 --version`: Python 3.11.14
- `git --version`: git version 2.43.0

## 3. Check table (verdict verbatim + exit code)

| # | Command | Verdict (verbatim) | Exit | Expected |
|---|---------|--------------------|------|----------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 | PASS ✅ |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 | PASS ✅ |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 | PASS (gate signed) ✅ |
| d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 13/13 PASS` | 0 | 13/13 PASS ✅ |

### Teeth PASS lines (verbatim)
```
[PASS] bank-identity gate: planted-fired=True(BankIdentityRefused) clean-passed=True
[PASS] schedule gate: oversized: planted-fired=True(ScheduleGateRefused) clean-passed=True
[PASS] schedule gate: mutated binding: planted-fired=True(ScheduleGateRefused) clean-passed=True
[PASS] run-window gate: past close: planted-fired=True(RunWindowRefused) clean-passed=True
[PASS] run-window gate: before open: planted-fired=True(RunWindowRefused) clean-passed=True
[PASS] spend gate: worst-case overflow: planted-fired=True(SpendReservationRefused) clean-passed=True
[PASS] attempt-ceiling gate: 345: planted-fired=True(AttemptCeilingRefused) clean-passed=True
[PASS] R14-record gate: tampered: planted-fired=True(R14RecordRefused) clean-passed=True
[PASS] item-consistency gate: bad task digest: planted-fired=True(ItemConsistencyRefused) clean-passed=True
[PASS] subject-binding gate: wrong count: planted-fired=True(SubjectBindingRefused) clean-passed=True
[PASS] null-content: determinate, no retry, continues
[PASS] transport-exhaustion: honest partial stop
[PASS] clean full dry-run: 312/312 under ceiling

TEETH CHECKS: 13/13 PASS
```

## 4. MockProvider-only proof (offline confirmed BEFORE running)

`harness/test_emission_gates.py` full import block (lines 13–32):
```python
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
    gate_run_window, gate_schedule, gate_r14_record, load_subject_binding,
    BankIdentityRefused, ItemConsistencyRefused, ScheduleGateRefused,
    RunWindowRefused, AttemptCeilingRefused, SpendReservationRefused,
    R14RecordRefused, TransportBudgetExhausted, SubjectBindingRefused,
    parse_iso_utc,
)
from provider_live_emission import MockProvider
from util import PACKET_ROOT, load_json
```
The **only** provider symbol imported is `MockProvider` (line 31). Both provider factories construct it:
```
183:            provider_factory=lambda subject: MockProvider(mode="null-content"))
202:            provider_factory=lambda subject: MockProvider(mode="transport-always"))
```
No `requests`/`urllib`/`http`/`socket`/`openai`/`anthropic` client, no `api_key`/`base_url`/`endpoint`. The `real`
matches in the file are benign (`_real_context()` fixture builder, `real_r14` local JSON load, "no real backoff"
comment). **MockProvider-only: CONFIRMED.**

## 5. No-network / local-only confirmation

- Clone source: local path `/home/gauss/Codex-Lab/wt-language-a` only.
- Network-marker scan across all my logs + ENVIRONMENT.txt: **NO NETWORK MARKERS FOUND**.
- No provider contact; no key files opened; nothing under `/home/gauss/freezer` touched.

## 6. Dry-run evidence store — FINDING (charge premise inaccurate; NOT a candidate defect)

The charge states the teeth suite "writes dry-run evidence to the fixed outside path … your run will overwrite the
prior room's dry-run outputs … record the sha256 of the census summary YOUR run wrote." **My run did NOT write or
overwrite any persistent census.** Verified by bytes, not assumption:

- `test_emission_gates.py` writes ONLY to **ephemeral** tempdirs under `OUTSIDE_ROOT`:
  `_fresh_evidence()` = `tempfile.mkdtemp(prefix="teeth-…", dir=OUTSIDE_ROOT)` **followed immediately by
  `shutil.rmtree(path)`**; every dry-run evidence dir is `shutil.rmtree(evd, ignore_errors=True)` after its check
  (lines 184, 203, 215). The suite is **hermetic and self-cleaning.**
- After my run: **nothing under `/home/gauss/Codex-Lab/emission-312-evidence/` is newer than 03:00** (my run was
  03:47); **zero `teeth-*` leftover dirs**. My teeth run left no persistent artifact.
- The persistent top-level `dry-run/EMISSION-CENSUS.json` present in the store has **mtime 2026-07-18 00:37:25**,
  i.e. it PREDATES my run — it was produced by a prior `run_emission.py` dry-run (the earlier room / build step),
  **not by the teeth suite and not by me.**

Census sha256 present in the store (attributed honestly — NOT written by my run):
```
442f3ad5104ba8ba69bb18e92fb0bacd81e1b64c548aed6fe2ce830d6cdc81f3  dry-run/EMISSION-CENSUS.json  (mtime 00:37, prior run)
```

**Verdict on the finding:** this is a discrepancy between the *charge's description of side effects* and the
artifact's *actual (better, hermetic)* behavior — the teeth suite does not pollute the persistent evidence store.
It is **not a FAIL of the EMISSION candidate**: all four verification gates PASS with exit 0. I decline to
fabricate a "census my run wrote" sha256, because bytes (mtime) show my run wrote no persistent census.

## 7. Log file hashes (my room)

```
76f25e174e5d600b7041304adb47c28a4e3b2da6ac27c2c20e3d1d7d0feb441f  check_a_manifest-check.log
b0c04912eff905d93dd4174993ed308f77c19006392cd4e654bc4d6b0b94c454  check_b_manifest-protected.log
83cd841a3f47e84dfbcf02baebc419b37a73d4630ea54baae5c990f1a3027c04  check_c_exposure-readiness.log
f49f00aec6ebd2b57e1db5bee2e81635e47043712bdf520282531a791ee9ee57  check_d_teeth.log
3ab6047d48227f0961d9f502e02a7f6a93f0ebc6452d44a2584b7ccd2fbd0e33  ENVIRONMENT.txt
```

## 8. Attestation

- All results in this receipt attach to **commit 7da828e05fed0c503b114cd5974a41b3bec82c83 / tree
  258fb265c00a6ec33ea9ac28cd55d72510427d56**, verified in this session.
- **No network access; no provider contact of any kind** (offline throughout; logs clean of network markers).
- **No key content opened** — no scoring-key files read, nothing under `/home/gauss/freezer` touched.
- Single fresh clone from the local path only; one run per check; no repairs, no re-runs.
- I did not touch `gamma/`.

**Overall: 4/4 checks PASS (exit 0), identity triple verified, MockProvider-only offline teeth 13/13.
No BLOCK. One recorded finding: the teeth suite is hermetic and my run wrote no persistent census — the store's
census is the prior run's (sha `442f3ad5…`, mtime 00:37), reported honestly rather than misattributed to my run.**

— RECEIPT-DELTA (Claude Opus 4.8, 1M context)
