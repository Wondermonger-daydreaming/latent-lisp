# Memory Layer /0 — CHAIR VERIFICATION, ROUND R4

*Claude **Opus 5 (1M context)**, chair. The arc's first three rounds were chaired by
Claude Fable 5; the helm changed at the owner's hand during the F1 confirmation, and
this record is signed by the instance that produced it. Builder: OBTURATOR (Opus
subagent). **Same family — this is a third-hand reproduction, NEVER independent
verification.** Every result below was observed in this session's own output.*

**Predecessor record:** `CHAIR-VERIFICATION-R1-BLOCKED-2026-08-20.md` (the R1 record,
preserved under its blocked name by chair rename, content untouched). R2 and R3 had no
separate chair-verification file; their verifications live in the session handoff and in
the RETURN's own sections.

---

## 1. What R4 was for

The Codex cross-family audit (`notes/2026-08-20-ml0-codex-adversarial-audit.md`) — the
first non-Claude eyes on this lane — returned five live findings after three Claude-side
rounds had passed every gate. R4 closes them.

## 2. F1, verified by the chair's own instrument (the blocker)

F1: the planted-mutant `defect` keyword was a **live public `&key` on the exported
production surface** — one keyword flipping the promotion rule's species admission.

**Before** (chair probe, fresh image, canonical `load.lisp`):
```
CHAIR-F1 NORMAL=NIL          CHAIR-F1 DEFECT=T          CHAIR-F1 EXTERNAL=EXTERNAL
```

**After** (chair probe, same route, R4 build):
```
CHAIR-R4 NORMAL=NIL
CHAIR-R4 ARGLIST=(SPECIES)                      <- the parameter is GONE, not unused
CHAIR-R4 DEFECT-CALL=REFUSED type=SIMPLE-PROGRAM-ERROR
CHAIR-R4 MUTANT-SPECIAL-INTERNED=NIL            <- the overlay's special is not even
                                                   interned in a canonical image
CHAIR-SWEEP external-fns-checked=140  with-defect=0
```

**Source-level check, because a probe can pass while a branch survives** (the builder's
own disclosure: the *rejected* internal-special design would have passed R4's F1 probe
with every mutant branch still compiled in). Chair grep over `ml0.lisp` for `&key defect`,
`:defect`, `defect-payload`, and all five payload keywords: **7 matches, all of them
prose in docstrings and comments documenting the removal — zero live branches.** The six
defects live in `ml0-mutant-overlay.lisp`, which `+ml0-lane-sources+` does not name and
`load.lisp` never loads.

**Relocation, not deletion — the necessary companion check:** `ml0-mutants` still reports
**6 defects, 6 killed, 0 survivors**. A repair that removed the seam by disarming the
teeth would have traded one hole for a worse one.

## 3. Gates, chair third-hand re-runs (exits taken directly)

| Gate | Chair exit | Chair-observed line |
|---|---|---|
| `ml0-selftest` | 0 | `ml0-selftest: 81 checks, 0 failures` |
| `ml0-controls` | 0 | `ml0-controls: 11 controls, 11 caught, 0 missed` |
| `ml0-mutants` | 0 | `ml0-mutants: 6 defects, 6 killed, 0 survivors` |
| `ml0-red-proof` | 0 | `cured PASS, uncured FAIL — the tooth bites` |
| `ml0-host-fault-proof` | 0 | `ml0-host-fault-proof: PASS` |
| `ml0-block-proof` | 0 | `ml0-block-proof: 20 probes, 20 closed, 0 open` |
| specimen | 0 | `de-actu-memorato: 45 checks, 0 failures` |

All match the builder's reported counts.

## 4. ⚠ A DEFECT THE CHAIR FOUND, and cured by re-running

**The shipped specimen transcripts were two rounds stale.** `RUN-SPECIMEN.txt` and
`RUN-SPECIMEN-SECOND.txt` both held the **R2-era** capture (`27121e6f…`, mtime 17:34/17:35)
while `RUN-EXITCODES.txt` and the RETURN described R3's `39ebf213…` and R4's `39849f99…`.
The chair's own fresh run emitted `39849f99…` — matching the records and *not* the shipped
bytes.

**Mechanism:** the R3 and R4 builders each ran the specimen twice and compared **their two
runs to each other**, satisfying determinism honestly, while never refreshing the preserved
captures. `FILE-MANIFEST.txt` then verified 50/50 — **because it hashed the stale bytes.**

**Why it matters at its true size:** this is the R2 packaging defect *inverted* (there, the
manifest disagreed with the payload; here it agrees with a fossil), and it is the
pre-heal-fossil class named in CLAUDE.md §I-f — *after healing code, grep the docs for its
old outputs.* A parcel would have shipped a transcript documenting a build two rounds old,
under a manifest certifying it.

**Cure, by the house rule (regenerate, never hand-edit):** the chair re-ran the specimen
twice (exits 0, 0), the two runs are byte-identical at `39849f99…`, and the manifest was
regenerated over the corrected payloads and re-verified **50/50**. The superseded digest is
named in the manifest's own header so the correction is visible rather than silent.
Commit `3efb13d8`.

## 5. Structural verifications

- **Zero bytes outside the lane** across R4's commits (`e3c3fb5c`, `b9e563e0`, `beedd1bd`)
  — chair-verified by name-only diff.
- **`SYNC-PAUSED` byte-untouched**; nothing pushed to the mirror; the lane remains
  **unregistered** on the release floor by the writ.
- **Release floor, quiescent:** see §6 — run by the chair with the tree committed and the
  checkpoint Stop hook disarmed by a staged file for the run's duration, so the r1
  mid-floor-commit class is prevented rather than repeated.

## 6. Release floor (chair-run, quiescent)

```
git before   : 1 entr(y|ies) under the subject tree
FLOOR RESULT : PASS (103 executable gates attempted / 103 passed / 0 blocked;
                     8 carried status rows; profile full)
FLOOR_EXIT=0
-- checkout cleanliness --
   unchanged: zero tracked modifications, zero new untracked litter.
```

**The "1 entry" is the chair's own, disclosed rather than smoothed.** The checkpoint
Stop hook skips whenever something is staged, and the r1 floor was invalidated by a
commit landing mid-run; to prevent that class the chair staged (uncommitted) this very
record for the run's duration — owed work, not a decoy. **Quiescence is a claim about
change DURING the run and it holds** (checkout unchanged; gate #85's run-integrity
check — the one that caught the r1 fault — passed). It is **not** a claim that the tree
was pristine at start: it was not, by one staged file, and the r2/r3 runs' preflight
read `0 entr(y|ies)`. Full record at the tail of `FLOOR-RESULT.txt`.

## 7. Standing after R4 — unchanged

**candidate · not audited · not adopted · not frozen · not registered · same-family hands ·
planted-death crash model only · capability-disciplined never capability-secure · no
independent verification.** One Act /1's CANDIDATE standing travels with every dependency
claim. The Codex audit is a **cross-family read of the source**, not an execution-level
reverification and not a stranger's acceptance; the stranger audit remains owed on this
lane and nine others.

**Holes carried forward, at their true size** (builder-disclosed, chair-accepted as filed):
the effect axis is *marked* testimony, not cured by a door · `ml0-account-from-event`
remains exported, inert in fact rather than withdrawn · the declared-substrate and
self-constructed-store ceilings stand · three mutants are now expressed one remove further
out than the seams they replace (a mutant expressed as a caller is a weaker statement about
where the law lives than a mutant expressed as a branch — the trade was taken knowingly) ·
the new `provenance` field is a **durable-bytes break**: pre-R4 accounts cannot be decoded
by this build (`ML0-RB-5`), deliberately, with no migration.

— the chair, 2026-08-20/21
