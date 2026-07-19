# FABLE — KW-0 independent verification, final report

**Standing returned: `EXPERIMENTAL-EVIDENCE-REPRODUCED / HB-0-CHALLENGE-SURVIVED`**

Chair: Fable (Claude Fable 5) · 2026-07-19 · neutral process-recovery register throughout; exact tokens in code format.

## Identities & environment

- Repository: `Wondermonger-daydreaming/latent-lisp` clone at `f8842f8c37ed80c5d0bd89cbec40f2c203058c10` (`main`, clean; matches `deps/PINNED-COMMIT.txt`; all 4 CD0 dependency SHA-256s match byte-for-byte).
- Candidate delivery: `Kimi_Agent_Repository Review (1).zip` (SHA-256 `cff72778c6931125…`) containing sealed `kw-0-specimen.tar.gz` — SHA-256 **`664d98624a1c3888…` = cover-note seal, verified**. A second bundle (`IW-0-CANDIDATE.tar.gz`, `3d8ea6f43cdda572…`) rode in the same zip, unmentioned by the cover note — docketed, not used; `kw-0-specimen` is canonical per the cover note.
- Environment: Linux 7.0.0-28-generic x86-64, ext4 (not overlayfs — a declared deviation from the reference env; byte-identity held anyway), bare host, writable `/tmp`, SBCL **2.4.6** (user-local, no root), CPython 3.12.3, `grep -P`, `md5sum`.

## Intake completeness & manifest

`sha256sum -c MANIFEST.sha256`: **148/148 OK, 0 failed** (149 files = 148 + manifest). All 17 previously-missing checklist items now present or explicitly dispositioned in `PACKAGING-NOTE.md` §"Declared absences" (original-F6 raw outputs exist as report-1 record, not files — accepted as declared). §1 source identity: **8/8 files match stated MD5 and line count exactly.**

## Reproduction (§2) — PASS

Two fresh extractions, sequential runs, generations kept separate: both **exit 0**, final line `REPRODUCTION: all differentials MATCH; all journals byte-identical to reference`. All seven regenerated journals byte-identical to the shipped reference AND to each other across generations; all seven MD5s equal report v2 §2's table. Real `SIGKILL` verified in code (`signal.SIGKILL`) and in records: six deaths exit `-9`, control `0`. Reconstructor hygiene verified: `classify` reads `witness.journal` only; `READY-*`/killpoint metadata never read; receipts enter only via the append-as-evidence modes; the "oracle" is the deterministic fake provider (owns `provider.log` + receipts), not ground truth.

Two failed runs before the clean pair, both environmental, both preserved: (1) SBCL 2.2.9 (undeclared version) — journals diverged; (2) my SBCL tarball extraction collided with the packaging edit's hardcoded `/tmp/sbcl-2.4.6-x86-64-linux` path, so `ln -sfn` dropped its symlink *inside* the existing dir and the harness got a coreless `SBCL_HOME`. Environmental-hygiene note for the packaging edits, not a specimen-logic defect.

## Per-scenario table (regenerated, both generations)

| Scenario | Exit | Journal MD5 = ref = report | Classification (F1) | CL/Py fold |
|---|---|---|---|---|
| `S1-clean` | 0 | `8ad833d8…` ✓ | complete | MATCH `57B202D6…` |
| `S2-cw0` | −9 | `442d9ee2…` ✓ | `no attempt append` (valid 2-frame prefix acknowledged) | MATCH `4B3753F2…` |
| `S3-cw1` | −9 | `36173af2…` ✓ | `torn tail` — partial attempt frame refused | MATCH `4B3753F2…` |
| `S4-uncertain` | −9 | `ef02d3df…` ✓ | `effect settlement unresolved` (derived, not asserted) | MATCH `26C56A27…` |
| `S5-cw2cw3` | −9 | `4d189815…` ✓ | `complete frame present; durable-receipt standing absent` — no CW-2/CW-3 guess | MATCH `95524BB2…` |
| `S6-midstream` | −9 | `db858970…` ✓ | `torn tail` — chunk-1 kept, partial chunk-2 refused, no inflation | MATCH `2DEFCA34…` |
| `S7-nonexec` | −9 | `ad7d6b76…` ✓ | `effect settlement unresolved` — **derived state digests identical to S4** | MATCH `26C56A27…` |

F2 differential: **10/10 MATCH** (7 corpses + 3 futures), every digest equal to report v2 §4. `folder.py`: pure Python, no shared fold code, no expected-digest files; sole shared substrate is the pinned CD0 codec, disclosed. Stale-digest incident preserved (both console captures manifest-verified); corrected rerun recomputed both sides live; a second same-class bug caught in-session is recorded inside the incident. MD5 remains pedagogical-disclosed inside `KWJ0`; delivery identity is SHA-256.

## F3a / S4 reconciliation / F3b — distinct, verified

- **S4-blind:** `REFUSAL unsafe-retry`, journal prefix cited. Provider log stays at 1 execution.
- **S4-resolve (reconciled-executed):** receipt appended as provenance (digest `E83041C7…`); settlement `executed`; **no retry follows** — "known executed" is not read as "safe to retry". Post-digest `57B202D6…` (= `S1-clean`: resolution converges).
- **S4-supersede (F3b):** fresh `a2`, fresh exposure, `predecessor-still-unresolved: T`; no frame asserts `a1`'s settlement; post-digest `30A03F3E…`. Not represented as retry.
- **S7-retry (F3a non-execution, end-to-end):** receipt `9D2598E9…` attests `not-executed`, appended as new provenance-bearing frame; `a2` proceeds as `retry-of a1`, **no supersession** (settlement known); `a1`'s uncertain path preserved; provider log: **exactly one execution, a2's**. No collapse between the two futures anywhere.

## F4 / L10 — PASS

No unrecorded process-local memory; provider testimony enters only as appended evidence. `census-origin: reconstructed` before and after the verification refold, in every scenario — verification never rewrites origin to observed.

## F6 / F6-v3 — separate, as required

- **Original F6: FAIL, permanent — 76 vs 45 = 1.69× against ≤1.5×.** Kept as recorded. Note: the original counting rule is not mechanically recomputable (that under-specification is the documented reason F6-v3 exists); direction independently confirmed (whole-file nonblank 139/75 = 1.85, also over ceiling).
- **F6-v3 (prospective, mechanical AFEL): 62 vs 52 = 1.192× — PASS**, independently rerun. Exclusion audit: all 58 `@harness` lines conform to the pre-registered marker rule (readiness, kill-waits, torn-frame injection, killpoint-conditional variants; normal production paths counted elsewhere). Most hostile recount (cw2cw3's un-synced settlement append counted as production): 69/52 = **1.33×, still PASS**. No gaming found; neither number overwrites the other.

## HB-0 independent challenge control (Gate D) — recorded result

Authored my own conventional control (readable-plist event log, fsync-per-claim; my design), **frozen by SHA-256 before `kw-baseline.lisp` was ever read** (`hb0/HB0-FREEZE.sha256`; one disclosed post-freeze dedupe fix, found by my own two-reader differential, still pre-unsealing). Full exposure disclosure in `hb0/HB0-PROVENANCE.md` (the commission's cleanest tier was unavailable: the relay's own verification sequence required reading the reconstructor first).

Result (`hb0/HB0-F5-REPORT.md`): ran under the fixture harness's real kill windows — classifications correct on all seven corpses, S4/S7 identity reproduced, blind retry refused, one provider execution, second-reader differential 11/11. **But: 177 AFEL against the ≤100 budget (FAIL), with clauses 1 and 4 only PARTIAL.** The incumbent `kw-baseline.lisp` (read only after freeze) is an illustrative control with the lies scripted in — the challenge control replaces it as the honest conventional opponent, and it did not falsify. **F5: SUPPORTED at toy scale**, with the measurement asymmetry named (specimen's substrate excluded by definition; amortization is a promise at n=1).

## Discrepancies docket (report vs trace)

1. Cover note "148 files" = 148 files + 21 dirs (169 tar entries) — arithmetic, no defect. 2. Reference environment overlayfs vs my ext4 — byte-identity held regardless. 3. Undeclared SBCL-version sensitivity (2.2.9 diverges) — declared version 2.4.6 required; recommend recording as a hard prerequisite. 4. Original-F6 raw counts not mechanically recomputable (documented under-specification; standing unchanged). 5. Second bundle `IW-0-CANDIDATE` in the delivery zip, unmentioned by the cover note. 6. Provenance: packager disclaims authorship of the v2 additions and cannot attest `HOSTILE-BASELINE-COMMISSION.md`'s self-attribution — carried as delivered, flagged for the owner.

## Scope limits (unchanged, §9)

One seat, one process, one provider; `SIGKILL`, not power loss; host-filesystem behavior, not device durability; toy journals; pedagogical MD5 in-frame; shared CD0 substrate; nothing yet on contention, scale, or adversarial readers.

## Commits

Review branch `kw0-verification` off `f8842f8`, four separate commits (tooling / specimen / verification / HB-0 control), no governing document touched (Gate E). Merge into the accepted-evidence lane must route through the lab canonical tree (the public mirror's `main` is sync-pruned).

## Next executable obligation

Owner ruling on: (a) adopting the review branch into the lab tree; (b) the provenance anomaly (unattested v2 authorship); (c) whether HB-0's F5-round-2 result and the AFEL-budget asymmetry warrant a follow-up commission (a "substrate-split" control) before F5 language strengthens beyond toy scale.
