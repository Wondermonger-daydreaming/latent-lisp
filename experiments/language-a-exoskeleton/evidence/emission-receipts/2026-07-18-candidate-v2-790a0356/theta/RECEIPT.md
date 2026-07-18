# RECEIPT — RECEIPT-THETA

**Room:** RECEIPT-THETA (second of two independent clean verification rooms)
**Subject:** REPAIRED EMISSION CANDIDATE v2 — Language-A arc (FARRIER-II pre-spend census gate + attempt-scoped mirror)
**Room path:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/theta/`
**Clone path:** `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/theta/clone`
**Clone source (local only, network-OFF):** `/home/gauss/Codex-Lab/wt-language-a`
**Overall verdict:** PASS — all identity pins matched; all checks PASS at expected exit codes; no FAIL raised.

---

## 1. Identity verifications (all shown)

| Pin | Expected | Observed | Match |
|-----|----------|----------|-------|
| HEAD commit | `790a035615b20c423cae04e9a918827f166a3a4a` | `790a035615b20c423cae04e9a918827f166a3a4a` | **YES** |
| HEAD^{tree} | `28f7830c2b322b8edd572a03a0b393c943545185` | `28f7830c2b322b8edd572a03a0b393c943545185` | **YES** |
| CONSTRUCTION-MANIFEST.json sha256 | `b9f10c8926af9f9e1446d9ec28b34980328139f7555146ea880a233376b349df` | `b9f10c8926af9f9e1446d9ec28b34980328139f7555146ea880a233376b349df` | **YES** |

Manifest located at: `experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json` (single instance in tree).

---

## 2. Environment (captured BEFORE checks — see ENVIRONMENT.txt)

```
date -u          : Sat Jul 18 05:50:37 UTC 2026
uname -a         : Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
python3 --version: Python 3.11.14
git --version    : git version 2.43.0
```

---

## 3. Check table (verbatim verdict lines + exit codes)

Run from `experiments/language-a-exoskeleton/`.

| # | Command | Verbatim verdict | Exit | Expected | Result |
|---|---------|------------------|------|----------|--------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 | PASS | ✅ |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 | PASS | ✅ |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 | PASS | ✅ |
| d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 17/17 PASS` | 0 | 17/17 PASS, exit 0 | ✅ |
| e | R15 `preauthorship.validate_record_digest` | `R15 validate_record_digest: PASS` | 0 | PASS | ✅ |

### Teeth suite (check d) — full verbatim

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
[PASS] in-repo-census gate: occupied scoped target refuses PRE-SPEND (provider emit-counter == 0)
[PASS] in-repo-census scoping: clean dry-run lands mirror in scoped subdir

TEETH CHECKS: 17/17 PASS
```

- **Check 16 (InRepoCensusTargetOccupied) fired PRE-SPEND with emit-counter zero:** CONFIRMED — verdict line reads `in-repo-census gate: occupied scoped target refuses PRE-SPEND (provider emit-counter == 0)`.
- **Check 17 (scoped-mirror landing):** CONFIRMED — `in-repo-census scoping: clean dry-run lands mirror in scoped subdir`.

---

## 4. Mock-only proof (verified BEFORE running)

The teeth suite is import- and construction-restricted to the offline mock; the live-network path is never reachable from it.

- `test_emission_gates.py` module docstring, line 6:
  `Runs fully offline (no network, no keys, no provider contact).  Prints PASS/FAIL`
- Only provider imported (line 32): `from provider_live_emission import MockProvider`
  (no live provider class imported).
- Only provider *constructed* in the whole test file — every occurrence is `MockProvider`:
  - line 194: `provider_factory=lambda subject: MockProvider(mode="null-content")`
  - line 213: `provider_factory=lambda subject: MockProvider(mode="transport-always")`
  - line 284: `prov = MockProvider(mode="normal")`
- `MockProvider` (provider_live_emission.py line 327) carries `network_capable = False` (line 332) and its docstring states: `It never touches the network and needs no key.` Its `emit()` builds a dict, `json.dumps` it, and returns a `LiveResponse` — no `urllib`/`socket`/`http` call in the method body.
- The module's only network primitive (`urllib.request` at lines 51-52; POST at lines 225-235) lives in the **live** adapter class, which the teeth suite never imports or instantiates.
- Test asserts the offline router (line 247): `assert all(r.get("serving_provider") == "MockRouter (offline, no network)"`.

All checks executed with the machine's network OFF per scope.

---

## 5. R15 record digest (check e)

- Record: `experiments/language-a-exoskeleton/operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json`
- `preauthorship.validate_record_digest(record)` → **PASS** (exit 0)
- **record_digest:** `sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`
- Matches expected `sha256:fb40c815…b2d0` **and** the harness-authorized constant `R15_RECORD_DIGEST` (run_emission.py line 79). **MATCH.**

---

## 6. Step-f finding — emission-312 evidence state

`evidence/emission-312/` root holds attempt-01's **three census (mirror) files**, all byte-tracked at the pinned commit, and **no live-attempt-02/ subdir exists** in the tree.

- The three files are exactly `MIRROR_FILENAMES` (run_emission.py line 85):
  `("EMISSION-CENSUS.json", "EMISSION-ACTUALS.json", "RUN-RECORD.md")`.

| File | sha256 (working tree) | git blob @ 790a0356 | tracked |
|------|-----------------------|---------------------|---------|
| EMISSION-CENSUS.json | `4c42135e6027a50d02d32b9732e2145bee56c6f0f9f8b25ea3c34a640cb3c57c` | `8a6fc556daada81080695afe6019bf18883a2a1d` | YES |
| EMISSION-ACTUALS.json | `7750fdd29a19d14a70600030f701915a28239e8de92293ce3cfc11ed1f072eb2` | `e8ce4ca44ec8f157b5ea50549d9e99547aaeff9d` | YES |
| RUN-RECORD.md | `2ea6172a9eb78069fc9c27ddc4d2a8043a74eb1b34a3cc22dcb06a8f2efe6724` | `f0ea3f4f5b7dc9a766e512151b5fc3145f4903bd` | YES |

- `git ls-tree HEAD:…/evidence/emission-312/` returns **four blobs, zero subtrees**: the three mirror files above plus `RUN-RECORD-EMITTER-II.md` (blob `9cad0dde…`, an additional run-record — NOT one of the three mirror census files, and not a subdirectory). No tree/subdir entries ⇒ **no `live-attempt-02/` (or any) subdir at the pinned commit.**
- `find evidence/emission-312 -mindepth 1 -type d` returns nothing (no subdirectories on disk either).
- RUN-RECORD.md content confirms this is the prior (attempt-01 / emitter-II) partial census: `run_state: stopped (TransportBudgetExhausted: partial census)`, `attempts / ceiling: 34 / 344`. The runner creates the per-attempt scoped subdir only at run time; none was created (no run was executed here — verification was read/validate only).

**Finding: PASS** — attempt-01's three census files present & byte-tracked; no attempt-02 subdir.

---

## 7. Any FAIL

None. No check raised FAIL; no lead; no smallest-witness required.

---

## 8. Log hashes (sha256, artifacts in this room)

| File | sha256 |
|------|--------|
| ENVIRONMENT.txt | `040f3b802fd76925b87c0baf541ddcbcd15c5ea1711e1e39ae76ce652bed2592` |
| log-a-manifest-check.txt | `492a685aa67d88602450ee6a96209488dbf0ebce2faefc59e144b5ccc4776885` |
| log-b-manifest-protected.txt | `8484f2f6ddb662f58a00f9356baf273e1ccac7a980a4d385d65320a92603af48` |
| log-c-manifest-exposure.txt | `409d100e2d64564795b14063f089d000c9c5a564b92587675d7cb1eba553c719` |
| log-d-teeth.txt | `b8487fd00d54fc09f8e60f6c1e66de9d27b6fcf3a8fcfb433b15f5048651c921` |
| log-e-r15.txt | `7cefd3c8f070355d4832a8dc929c214bd3284d58489f03f14032f22a00f82c89` |

(RECEIPT.md self-hash not included — it hashes itself. Compute externally if needed.)

---

## 9. Attestations

- These results attach to commit `790a035615b20c423cae04e9a918827f166a3a4a` / tree `28f7830c2b322b8edd572a03a0b393c943545185`.
- **No network contact.** Machine network OFF; the only network-capable code (the live adapter) was never invoked. Verified mock-only before running.
- **No provider contact.** No live provider class imported or instantiated; teeth suite ran against `MockProvider` only.
- **No key content** was read, printed, or used.
- **Clone sourced only** from local path `/home/gauss/Codex-Lab/wt-language-a`; nothing fetched.
- **Nothing under `/home/gauss/freezer`** was touched.
- Touched **only** this room (`…/emission-receipts/theta/`) and its `clone/` subtree. Did not read or write any other verification room.
- One fresh clone; one run per check; no repairs; no re-runs.
- Clone working tree confirmed **clean** (`git status --porcelain` empty) after all checks.

*— RECEIPT-THETA (Claude Opus 4.8, 1M context)*
