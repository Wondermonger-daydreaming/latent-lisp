# RECEIPT-GAMMA — Language-A EMISSION Candidate, Clean Verification Room #1

**Room:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/gamma/`
**Posture:** every pin assumed lying until bytes proved otherwise. One run per check, no repairs, no re-runs. Network OFF; clone from local path only; no provider contact; no key content opened.
**Clone source:** `/home/gauss/Codex-Lab/wt-language-a` (local path only)

---

## 1. Environment (recorded BEFORE checks — `ENVIRONMENT.txt`)

```
date -u : Sat Jul 18 03:42:43 UTC 2026
uname -a: Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
python3 : Python 3.11.14
git     : git version 2.43.0
```

---

## 2. Identity verification (fresh clone, detached checkout of pin)

| What | Pinned | Observed | Verdict |
|------|--------|----------|---------|
| HEAD commit | `7da828e05fed0c503b114cd5974a41b3bec82c83` | `7da828e05fed0c503b114cd5974a41b3bec82c83` | **MATCH ✓** |
| HEAD^{tree} | `258fb265c00a6ec33ea9ac28cd55d72510427d56` | `258fb265c00a6ec33ea9ac28cd55d72510427d56` | **MATCH ✓** |
| CONSTRUCTION-MANIFEST.json sha256 | `d5460a089dcd6a2ea17f974d6b26513800b5f33f89c9819514595e9f5db39420` | `d5460a089dcd6a2ea17f974d6b26513800b5f33f89c9819514595e9f5db39420` | **MATCH ✓** |

All three identities verified: **y / y / y**. No mismatch → no BLOCK. Checkout head message confirms candidate: *"Live emission runner (WRIGHT, R14-authorized additive construction): 3 adapters, refusal-first gates, 13/13 teeth, 312/312 dry-run byte-exact; manifest rebuilt — EMISSION CANDIDATE"*.

---

## 3. MockProvider-only proof (inspected BEFORE running the teeth suite)

Import lines quoted verbatim from `harness/test_emission_gates.py`:

```
31:from provider_live_emission import MockProvider
```

The `run_emission` import block (lines 23–32) pulls **only** gate functions, ledger/runner classes, and refusal exception classes — no live adapter:

```
23:from run_emission import (
24:    ReservationLedger, EmissionRunner, gate_bank_identity, gate_item_consistency,
25:    gate_run_window, gate_schedule, gate_r14_record, load_subject_binding,
26:    BankIdentityRefused, ItemConsistencyRefused, ScheduleGateRefused,
27:    RunWindowRefused, AttemptCeilingRefused, SpendReservationRefused,
28:    R14RecordRefused, TransportBudgetExhausted, SubjectBindingRefused,
29:    parse_iso_utc,
30:)
31:from provider_live_emission import MockProvider
32:from util import PACKET_ROOT, load_json
```

The **only** provider/adapter instantiations anywhere in the file (grep `[A-Za-z_]+(Adapter|Provider)\(`):

```
183:            provider_factory=lambda subject: MockProvider(mode="null-content"))
202:            provider_factory=lambda subject: MockProvider(mode="transport-always"))
```

No live adapter class is imported or instantiated. Module docstring states: *"Runs fully offline (no network, no keys, no provider contact)."* **Proof holds: MockProvider only.**

---

## 4. Check table (verbatim verdict + exit code — one run each)

| # | Command | Verbatim verdict | Exit |
|---|---------|------------------|------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 |
| d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 13/13 PASS` | 0 |

### 4d. Teeth suite — 13 checks that ran (verbatim PASS lines)

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

Every planted fault fired its named refusal (`planted-fired=True`), every clean case passed (`clean-passed=True`). teeth 13/13: **y**.

---

## 5. Live path NOT exercised / no network

- Log scan for HTTP/network markers (`http://|https://|GET |POST |connect|socket|api\.|openai\.com|anthropic\.com|urllib|requests\.`) across all six room logs → **NO network/HTTP activity found in any log.**
- Clone was from a local path (`/home/gauss/Codex-Lab/wt-language-a`); nothing fetched. Network OFF.
- Teeth suite drove `MockProvider` only (§3); the runner's live adapter path was never entered.

---

## 6. Dry-run evidence written to the outside store (expected, permitted — dry-run artifacts only)

Path: `/home/gauss/Codex-Lab/emission-312-evidence/dry-run/`
Census summary file: **`EMISSION-CENSUS.json`**

```
sha256(EMISSION-CENSUS.json) = 442f3ad5104ba8ba69bb18e92fb0bacd81e1b64c548aed6fe2ce830d6cdc81f3
```

Companion dry-run artifacts (for the record):
```
sha256(EMISSION-ACTUALS.json) = 47683d82d622daf5e3b03ecf93f10c45907f8d8d37cda6c94b7550484e667e9e
sha256(RUN-RECORD.md)         = 3e8222f60ed54f996ea410fc20b4f0aff7e05764ab3ff313bc7b6d9f53a8a004
payloads/                     = 312 files (matches "312/312 dry-run byte-exact")
```

---

## 7. Log file hashes (this room)

```
51d3de592dc8eb345e97d0453cdc14d763bc3dcf190e1940735d054e32e094b1  ENVIRONMENT.txt
0a36fa275176c14b96c2bc80dfb29730041912b12dd127850fa2065421fbebce  clone.log
173547bb5607ab1a4f37ceb898d10cff747b28892f236ef4bfc2761be927d07e  check-a-manifest-check.log
76a1695c660c66b060efa3573c0d372ed3deade086a7fabbef82fb3da11aee78  check-b-manifest-protected.log
39f704a6e00422b6d16cd579bf1bd8484351409f663069417c79218a513a30fd  check-c-exposure-readiness.log
06bf896d8f99b1a651ce9b21d67cd73555f78e091d4f919c422f74528011e302  check-d-teeth.log
```

---

## 8. Attestation

- These results attach to commit **`7da828e05fed0c503b114cd5974a41b3bec82c83`** / tree **`258fb265c00a6ec33ea9ac28cd55d72510427d56`**.
- **No network** occurred and **no provider contact** was made. Clone was local-path only; all checks ran fully offline against MockProvider.
- **No key content was opened** — nothing under `/home/gauss/freezer` and no scoring key files were read. Only the permitted dry-run evidence store was hashed (not opened for content).
- delta/ room was not touched.
- One run per check; no repairs; no re-runs.

**GAMMA VERDICT: all identities MATCH; a/b/c PASS (exit 0); teeth 13/13 PASS (exit 0); MockProvider-only confirmed; no network/provider/key exposure. No FAIL.**

— RECEIPT-GAMMA (Claude Opus 4.8, 1M context)
