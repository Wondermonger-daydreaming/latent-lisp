# RECEIPT-ALPHA — Language-A Combined Preflight, Clean Verification Room A

Independent clean room. Assumed every pin lying until bytes proved otherwise. One run per
check, no repairs, no re-runs — a failure is recorded as a finding.

## Clone source
- Cloned ONLY from local path: `/home/gauss/Codex-Lab/wt-language-a`
- Clone log: `logs/00-clone.log` (exit 0)
- Only git remote in the clone: `origin  /home/gauss/Codex-Lab/wt-language-a` (fetch + push). No network remote.

## Environment (recorded before first check → `ENVIRONMENT.txt`)
- `date -u`: Sat Jul 18 00:32:23 UTC 2026
- `uname -a`: Linux DESKTOP-FJCNF05 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64 GNU/Linux
- `python3 --version`: Python 3.11.14
- `git --version`: git version 2.43.0

## Checkout identity verifications

### CANDIDATE phase — VERIFIED (y)
Commit: `Owner pre-exposure gate SIGNED: sealed decision record R13 (chained to R12), flag flipped, exposure-readiness PASS, manifest rebuilt`
```
HEAD        = a3e4a10a29e162df680e84d0053ac1a1afe087a9   (EXPECT a3e4a10a29e162df680e84d0053ac1a1afe087a9)  MATCH
HEAD^{tree} = 10e9c1a9f97f8ec3ba85eca5bc66010211529302   (EXPECT 10e9c1a9f97f8ec3ba85eca5bc66010211529302)  MATCH
```

### TESTED phase — VERIFIED (y, incl. manifest sha)
Commit: `Rebuild CONSTRUCTION-MANIFEST.json as Language-A closure-candidate manifest`
```
HEAD        = 49fef2f7949bae5f216b20d5ed06ff2b18736d94   (EXPECT 49fef2f7949bae5f216b20d5ed06ff2b18736d94)  MATCH
HEAD^{tree} = 5eeaedc690bde21ca013e499545e66dd39af57f4   (EXPECT 5eeaedc690bde21ca013e499545e66dd39af57f4)  MATCH
sha256(experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json)
            = 3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223
              (EXPECT 3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223)  MATCH
```
Note: the self-corrected old-packet value `773841cd…` was NOT used; only the pinned `3f9b9e6f…` was verified, per instruction.

## Results table

| Check | Command | Verdict line (verbatim) | Exit | Attaches to |
|-------|---------|--------------------------|------|-------------|
| a | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| b | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| c | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 | candidate a3e4a10 / tree 10e9c1a9 |
| d | `bash verify-tranche-b.sh` | `FAILED (failures=1)` | **1** | candidate a3e4a10 / tree 10e9c1a9 |
| e | `bash verify-scoring-constitution.sh` | `FAILED (failures=1)` | **1** | candidate a3e4a10 / tree 10e9c1a9 |
| f | `bash verify-pilot.sh` | `ALL PILOT PACKET FLOORS HOLD — 12/12 network-off checks green.` | 0 | tested 49fef2f7 / tree 5eeaedc6 |

## FAIL — lead finding (smallest witness)

**Checks d and e both FAILED at the CANDIDATE tree (a3e4a10 / 10e9c1a9), same single root cause.**
Expected per pins: d = 7/7 green, e = all floors green. Observed: both non-zero, one test failing.

Smallest witness (identical in both logs):
```
FAIL: test_post_slot_lineage_gate_blocks_exposure_and_protected_scope_is_clean
      (__main__.PacketTests...)
  File ".../experiments/language-a-exoskeleton/tests/test_packet.py", line 225,
    in test_post_slot_lineage_gate_blocks_exposure_and_protected_scope_is_clean
    with self.assertRaises(OwnerResolutionRequired) as caught:
AssertionError: OwnerResolutionRequired not raised
Ran 17 tests in 3.598s (d) / 3.059s (e)
FAILED (failures=1)
```

Component breakdown (verbatim summary lines):
- **d** (`verify-tranche-b.sh`): `PASS tranche-b-unit-mutation-replay` → `FAIL inherited-packet-tests`. Script stopped after the failing component.
- **e** (`verify-scoring-constitution.sh`): its OWN three floors passed —
  `PASS scoring-constitution-tests`, `PASS scoring-constitution-verify`,
  `PASS scoring-constitution-freeze-self-test` — then chained to inherited floors:
  `FAIL inherited-tranche-b-floors`, `PASS tranche-b-unit-mutation-replay`, `FAIL inherited-packet-tests`.
  Same failing test as d.

Neutral structural note (raw observation, not adjudication): the failing test asserts a
post-slot lineage gate should raise `OwnerResolutionRequired` (block exposure). At the
CANDIDATE tree the owner pre-exposure gate is SIGNED (commit subject), so the refusal does
not fire, and the assertion that it *should* fire fails. At the TESTED tree (check f) the
mirror floor `unresolved-owner-exposure-refusal` PASSES because the gate is unsigned there.
Whether this is expected-by-design or a genuine regression is left to the orchestrator — RECEIPT-ALPHA reports the bytes.

Check c (`exposure-readiness`) at the candidate tree returned PASS as pinned.

## Scoring-constitution manifest restoration proof (check e)
The script transiently rewrites `CONSTRUCTION-MANIFEST.json` (+ sidecar) with trap-restore.
Sidecar filename is `CONSTRUCTION-MANIFEST.sha256` (not `...json.sha256`).

```
BEFORE:
  fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505  CONSTRUCTION-MANIFEST.json
  2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23  CONSTRUCTION-MANIFEST.sha256
AFTER:
  fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505  CONSTRUCTION-MANIFEST.json
  2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23  CONSTRUCTION-MANIFEST.sha256
```
**Restoration byte-exact: YES** — both files identical BEFORE and AFTER, despite the script's non-zero exit.

## sha256 of every log file
```
70156a661e4acfe00a7bca1842b08c6c9d48e48f2b3415eede14701f5049785c  logs/00-clone.log
173547bb5607ab1a4f37ceb898d10cff747b28892f236ef4bfc2761be927d07e  logs/a-manifest-check.log
76a1695c660c66b060efa3573c0d372ed3deade086a7fabbef82fb3da11aee78  logs/b-manifest-protected.log
39f704a6e00422b6d16cd579bf1bd8484351409f663069417c79218a513a30fd  logs/c-exposure-readiness.log
4f9cbfd5a8855ff505ca7d002377fc91beb08f45b655f24f784f110333d8e214  logs/d-verify-tranche-b.log
b0eaa24b00b968faa040405676f38da8d63595916ed7b0327e4b9d8644538d5e  logs/e-verify-scoring-constitution.log
384256bc266b4770fd2081149216176b2233f748e06bebb6e9e66dda796876c1  logs/f-verify-pilot.log
616c774fce91cc2520028fbdb775824cc7a2d6b8b55227a23edd6ff59353e397  logs/e-sha-before.txt
616c774fce91cc2520028fbdb775824cc7a2d6b8b55227a23edd6ff59353e397  logs/e-sha-after.txt
```

## Attestation
- **No network or provider contact occurred.** Clone was from local path `/home/gauss/Codex-Lab/wt-language-a` only; the clone's sole remote is that local path; no fetch/pull/remote add; no provider or API contact.
- **No key content was opened.** No scoring-key file was read at any point. Manifest hashes were computed with `sha256sum` without opening key files.
- All work confined to `/home/gauss/.claude/jobs/7d1d2626/tmp/preflight/receipt-A/`; receipt-B and other staging dirs untouched.

— RECEIPT-ALPHA (Opus 4.8, 1M context), 2026-07-18 UTC
