# RECEIPT-ETA — Independent Clean Verification Room #1

REPAIRED EMISSION CANDIDATE v2, Language-A arc (FARRIER-II pre-spend census gate + attempt-scoped mirror).
One fresh clone. One run per check. No repairs, no re-runs. A failure is a finding.

**VERDICT: PASS on every charged check. No FAIL, no BLOCK.**

---

## Environment (captured BEFORE checks — `ENVIRONMENT.txt`)

```
date -u:         Sat Jul 18 05:48:38 UTC 2026
uname -a:        Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux
python3:         Python 3.11.14
git:             git version 2.43.0
```

## Provenance

- Fresh clone (`git clone --no-hardlinks`) from local path ONLY: `/home/gauss/Codex-Lab/wt-language-a`
- Clone location: `/home/gauss/.claude/jobs/7d1d2626/tmp/emission-receipts/eta/clone`
- Checked out pinned commit `790a035615b20c423cae04e9a918827f166a3a4a` (detached).

---

## 1. Identity verifications (`log-0-identity.txt`)

| Item | Observed | Pinned | Match |
|------|----------|--------|-------|
| HEAD commit | `790a035615b20c423cae04e9a918827f166a3a4a` | `790a0356…` | **y** |
| HEAD^{tree} | `28f7830c2b322b8edd572a03a0b393c943545185` | `28f7830c…` | **y** |
| CONSTRUCTION-MANIFEST.json sha256 | `b9f10c8926af9f9e1446d9ec28b34980328139f7555146ea880a233376b349df` | `b9f10c89…b349df` | **y** |

All three identities match the pins. Branch containing HEAD: `codex/language-a-tranche-b-prereg-freeze-and-lineage-search`.

---

## 3. Check table (verbatim verdict + exit code)

Run dir: `experiments/language-a-exoskeleton/` (teeth run from `harness/`).

| # | Check | Verbatim verdict | Exit |
|---|-------|------------------|------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 |
| d | `python3 harness/test_emission_gates.py` | `TEETH CHECKS: 17/17 PASS` | 0 |
| e | R15 `preauthorship.validate_record_digest` | `validate_record_digest: PASS` | 0 |

### d — Teeth suite: 17/17 PASS (y)

All 17 checks PASS, exit 0. Load-bearing checks confirmed verbatim from `log-d-teeth.txt`:

- **Check 16 (InRepoCensusTargetOccupied), FIRED PRE-SPEND with emit-counter zero:**
  `[PASS] in-repo-census gate: occupied scoped target refuses PRE-SPEND (provider emit-counter == 0)`
  The test asserts `calls["n"] == 0` after the refusal (`provider emit called N times before the pre-spend refusal` guard) — the refusal precedes any provider emit.
- **Check 17 (scoped-mirror landing):**
  `[PASS] in-repo-census scoping: clean dry-run lands mirror in scoped subdir`

---

## Mock-only proof (verified BEFORE running the teeth suite)

`harness/test_emission_gates.py`:
- Line 6 (docstring): `Runs fully offline (no network, no keys, no provider contact).`
- Line 32 — the ONLY provider import: `from provider_live_emission import MockProvider`
  (the live `OpenRouterAdapter` is NOT imported by the test).
- Every provider usage in the test is `MockProvider`:
  - Line 194: `provider_factory=lambda subject: MockProvider(mode="null-content")`
  - Line 213: `provider_factory=lambda subject: MockProvider(mode="transport-always")`
  - Line 284: `prov = MockProvider(mode="normal")` (check-16 counting factory)
- `MockProvider` (`provider_live_emission.py` line 327): `network_capable = False`; docstring
  `It never touches the network and needs no key.`; `emit()` (line 338) builds a Python dict and returns
  a `LiveResponse` — no `urllib`, no socket, route tagged `[mock:no-network]`.
- The live network path (`urllib.request` POST to `https://openrouter.ai/...`, lines 225–235) lives ONLY
  in the live adapter; module docstring line 9–10: `performs NO provider contact at import time and none
  at all unless run_emission.py is invoked in its explicit --live mode.` Check 16 uses `mode="dry-run"`
  (line 294), never `--live`.

Conclusion: the teeth suite is mock-only; no provider contact occurs. No `--live` invocation was made by this room.

---

## e — R15 record digest (`log-e-r15-digest.txt`)

- Record: `experiments/language-a-exoskeleton/operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json`
- record_id: `owner-decision:owner-route-substitution-and-reemission-v1`
- `preauthorship.validate_record_digest(record)` → **PASS**
- **record_digest = `sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0`**
  — matches expected `sha256:fb40c815…b2d0`.

---

## f — evidence/emission-312/ finding (`log-f-evidence.txt`)

The three census files (= `MIRROR_FILENAMES` in `run_emission.py` line 85:
`("EMISSION-CENSUS.json", "EMISSION-ACTUALS.json", "RUN-RECORD.md")`) all present at the
`evidence/emission-312/` root and **byte-tracked** by git:

```
evidence/emission-312/EMISSION-ACTUALS.json
evidence/emission-312/EMISSION-CENSUS.json
evidence/emission-312/RUN-RECORD.md
evidence/emission-312/RUN-RECORD-EMITTER-II.md   (4th tracked doc: attempt-01 emitter-II run record; not one of the three census files)
```

**NO `live-attempt-02/` subdir exists** in the tree (search for `*attempt-02*` / `*attempt_02*` returned nothing).
Finding: consistent with the pin — the runner creates the per-attempt scoped subdir only at run time; the frozen tree holds attempt-01's three census files at root and no live-attempt-02.

---

## Clone cleanliness (after ALL checks)

- `git status --porcelain` → **0 lines** (working tree clean; no artifacts written into the clone).
- `git rev-parse HEAD` → `790a035615b20c423cae04e9a918827f166a3a4a` (unchanged).

---

## sha256 of every log

```
3c10291bf20d9732c2a8885e06d24d04dbd1160456ede98038654575d2bee3a1  ENVIRONMENT.txt
db67c34f980c4c3739b523558cea06c6d2efde7b055f0478f60ec93868fa2b94  log-0-identity.txt
492a685aa67d88602450ee6a96209488dbf0ebce2faefc59e144b5ccc4776885  log-a-manifest-check.txt
8484f2f6ddb662f58a00f9356baf273e1ccac7a980a4d385d65320a92603af48  log-b-manifest-protected.txt
409d100e2d64564795b14063f089d000c9c5a564b92587675d7cb1eba553c719  log-c-manifest-exposure.txt
b8487fd00d54fc09f8e60f6c1e66de9d27b6fcf3a8fcfb433b15f5048651c921  log-d-teeth.txt
9ec16ce8d48f25ace127897cc51148a9cc629348a831360298573b3b78c8620e  log-e-r15-digest.txt
2d8e1e28217e9a11d564ae7870643dfe8401f6c5454161db00ab1665979badff  log-f-evidence.txt
```

---

## Attestations

- Results attach to **commit `790a035615b20c423cae04e9a918827f166a3a4a` / tree `28f7830c2b322b8edd572a03a0b393c943545185`**.
- **No network contact.** Network-OFF assumed; clone taken only from local path `/home/gauss/Codex-Lab/wt-language-a`; teeth suite proven mock-only before running; no `--live` invocation made.
- **No provider contact.** MockProvider only; live OpenRouter adapter never imported/instantiated by any check run.
- **No key content** read, emitted, or quoted.
- **Nothing under `/home/gauss/freezer`** was read or touched.
- Only this room (`.../emission-receipts/eta/`) was written; no other room touched.
- Clone verified clean after all checks (`git status --porcelain` empty).

— RECEIPT-ETA (Claude Opus 4.8, 1M context), 2026-07-18 05:48 UTC
