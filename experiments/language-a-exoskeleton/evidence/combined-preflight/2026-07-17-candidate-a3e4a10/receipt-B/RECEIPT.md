# RECEIPT-BETA — Language-A Combined Preflight, Clean Room B

Independent clean verification. One run per check, no repairs, no re-runs. A failure is a finding.

## Headline

**CANDIDATE PHASE FAILS.** Both `verify-tranche-b.sh` (check 2d) and `verify-scoring-constitution.sh`
(check 2e) exit **1** at the signed candidate tree. Smallest witness (identical in both):

```
FAIL: test_post_slot_lineage_gate_blocks_exposure_and_protected_scope_is_clean
  tests/test_packet.py line 225
  with self.assertRaises(OwnerResolutionRequired) as caught:
AssertionError: OwnerResolutionRequired not raised
```

The test asserts the exposure gate is **UNSIGNED** (`assertRaises(OwnerResolutionRequired)`, expected
`detail == "pre-exposure-gate-signature"`). The candidate commit `a3e4a10` is the commit that **SIGNS**
the gate ("Owner pre-exposure gate SIGNED … exposure-readiness PASS"). Check 2c confirms
`manifest.exposure_readiness()` now returns PASS at this tree, which is exactly what makes the test's
`assertRaises` fail. The test is stale relative to the signed candidate tree — it was not updated when the
gate was signed. **TESTED PHASE (3f) passes clean** and confirms the refusal semantics the stale test still
encodes hold at the unsigned tested tree.

I record this as FAIL. I performed no repair and no re-run. Whether the stale test or the signed tree is
"correct" is an owner call, not mine.

## Clone source

`/home/gauss/Codex-Lab/wt-language-a` (local path only; `git clone` exit 0). No remote fetch.

## Environment (see ENVIRONMENT.txt)

- date -u: `Sat Jul 18 00:32:39 UTC 2026`
- uname -a: `Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux`
- python3: `Python 3.11.14`
- git: `git version 2.43.0`

## Checkout identity verifications

### CANDIDATE PHASE — VERIFIED (y)
```
HEAD_COMMIT = a3e4a10a29e162df680e84d0053ac1a1afe087a9   (matches pin)
HEAD_TREE   = 10e9c1a9f97f8ec3ba85eca5bc66010211529302   (matches pin)
```

### TESTED PHASE — VERIFIED (y)
```
HEAD_COMMIT = 49fef2f7949bae5f216b20d5ed06ff2b18736d94   (matches pin)
HEAD_TREE   = 5eeaedc690bde21ca013e499545e66dd39af57f4   (matches pin)
sha256(experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json)
            = 3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223   (matches pin)
```

## Results table

| Check | Verdict line (verbatim) | Exit | Attaches to |
|-------|-------------------------|------|-------------|
| 2a `manifest.py check` | `MANIFEST-CHECK: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| 2b `manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| 2c `manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| 2d `verify-tranche-b.sh` | `FAIL  inherited-packet-tests` … `FAILED (failures=1)` | **1** | candidate a3e4a10 / tree 10e9c1a9 |
| 2e `verify-scoring-constitution.sh` | own floors PASS; `FAIL  inherited-tranche-b-floors` … `FAILED (failures=1)` | **1** | candidate a3e4a10 / tree 10e9c1a9 |
| 3f `verify-pilot.sh` | `ALL PILOT PACKET FLOORS HOLD — 12/12 network-off checks green.` | 0 | tested 49fef2f7 / tree 5eeaedc6 |

### 2d detail (verbatim header lines)
```
PASS  tranche-b-unit-mutation-replay
FAIL  inherited-packet-tests
```
Expected 7/7 green — NOT met.

### 2e detail (verbatim floor lines)
```
PASS  scoring-constitution-tests
PASS  scoring-constitution-verify
PASS  scoring-constitution-freeze-self-test
FAIL  inherited-tranche-b-floors
PASS  tranche-b-unit-mutation-replay
FAIL  inherited-packet-tests
```
The scoring-constitution's OWN three floors all PASS. The exit-1 comes from the inherited tranche-b packet
tests (the same stale `test_post_slot_lineage_gate_...`). Expected "all floors green" — NOT met, solely via
the inherited packet test.

## Scoring-constitution restoration proof (check 2e)

`CONSTRUCTION-MANIFEST.json` is transiently rewritten with trap-restore during the run.

| File | BEFORE | AFTER |
|------|--------|-------|
| `CONSTRUCTION-MANIFEST.json` (content sha256) | `fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505` | `fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505` |
| `CONSTRUCTION-MANIFEST.sha256` (file sha256) | `2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23` | `2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23` |

**Restoration byte-exact: YES.** BEFORE == AFTER for both the manifest JSON and its sidecar, even though
the script exited 1 — trap-restore fired regardless of the inherited-test failure.

Note on sidecar name: the manifest's sha sidecar in this tree is `CONSTRUCTION-MANIFEST.sha256`
(not `CONSTRUCTION-MANIFEST.json.sha256`); its contents pin the manifest content hash `fba6a30…`,
consistent with the measured content hash.

## Log file sha256

```
35ee569563da4bbabb73eb2827a565a34f9aac3f9e658b5e261be7860d545604  logs/00-clone.log
173547bb5607ab1a4f37ceb898d10cff747b28892f236ef4bfc2761be927d07e  logs/2a-manifest-check.log
76a1695c660c66b060efa3573c0d372ed3deade086a7fabbef82fb3da11aee78  logs/2b-manifest-protected.log
39f704a6e00422b6d16cd579bf1bd8484351409f663069417c79218a513a30fd  logs/2c-exposure-readiness.log
44537bc219c526b9d94734cd311a1dc689f3b81111804d14658f6a4174cfe374  logs/2d-verify-tranche-b.log
49188febc4478d3b285db270b9fb75373fa7942156b1efda635d9f2d045a0f68  logs/2e-verify-scoring-constitution.log
384256bc266b4770fd2081149216176b2233f748e06bebb6e9e66dda796876c1  logs/3f-verify-pilot.log
9d752cb2a5132268c43c79a28750b90935cc4d60004adba5c69ab287a0880e3c  ENVIRONMENT.txt
```

## Attestation

- **No network or provider contact occurred.** Clone was from the local path
  `/home/gauss/Codex-Lab/wt-language-a` only; `GIT_TERMINAL_PROMPT=0` set; no fetch/pull/remote operation
  was run; no provider endpoints were contacted.
- **No key content was opened.** No scoring-key file was read at any point. The only file contents I opened
  were: `CONSTRUCTION-MANIFEST.json` (top-level keys + hash), `CONSTRUCTION-MANIFEST.sha256` (sidecar hash
  line), and `tests/test_packet.py` (to quote the failing test's smallest witness).
- All work confined to room `/home/gauss/.claude/jobs/7d1d2626/tmp/preflight/receipt-B/`. receipt-A and
  other staging dirs were not touched.

— RECEIPT-BETA (Opus 4.8, clean room B), 2026-07-18T00:3x UTC
