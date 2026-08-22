# Memory Layer /0 — Chair Verification, 2026-08-20

*Claude Fable 5 (1M context), the commissioning chair. Same family as the builder
(TABULARIUS, Claude Opus 5 subagent) — this is a fresh-context third-hand
reproduction, NEVER independent verification. Every claim below was observed in
this session's own output.*

## Third-hand re-runs (chair's shell, exits taken directly)

| Gate | Chair exit | Chair-observed count line | Matches RETURN |
|---|---|---|---|
| `ml0-selftest.lisp` | 0 | `ml0-selftest: 66 checks, 0 failures` | ✅ |
| `ml0-controls.lisp` | 0 | `ml0-controls: 10 controls, 10 caught, 0 missed` | ✅ |
| `ml0-mutants.lisp` | 0 | `ml0-mutants: 6 defects, 6 killed, 0 survivors` | ✅ |
| `ml0-red-proof.lisp` | 0 | `cured PASS, uncured FAIL — the tooth bites` | ✅ |
| `ml0-host-fault-proof.lisp` | 0 | `ml0-host-fault-proof: PASS` | ✅ |
| `de-actu-memorato/run-specimen.lisp` | 0 | `de-actu-memorato: 44 checks, 0 failures` | ✅ |

**The specimen is now FOUR-way byte-identical** at sha256
`80d4cba0a6af8404b973fc03965e542f80d99d21d40df1d2e1c58a44ad73aea4`: the builder's
two captures (`RUN-SPECIMEN.txt`, `RUN-SPECIMEN-SECOND.txt`) and the chair's own
fresh run, compared with `cmp` (exit 0), plus the digests matching. Checkout
byte-unchanged after all chair runs (`git status --porcelain -- experiments/latent-lisp`
empty).

## Structural verifications

- **Zero bytes changed outside the lane**: `git diff --stat 4210fddc..HEAD` over
  `language-act-0`, `language-act-1`, `language-core-0`, `journal0`,
  `capability0/1/2`, `kernel0`, `canonical-datum`, `lisp-plus.asd`,
  `mneme/verify-release.sh` — EMPTY (chair-run, exit 0).
- **`SYNC-PAUSED` byte-untouched** — mtime 2026-08-17, no commit touches it.
- **Candidate parcel sha verified**: `sha256sum -c` OK on
  `~/Downloads/memory-layer-0-candidate-2026-08-20.tar.gz.sha256`
  (`a492a05fd440730d57848556e5122bfafc6d25c609df07ca79237049d8f98b70`), 43 entries.
  The RETURN correctly omits its own parcel's sha (manifest-hash law).
- **Forbidden-phrase sweep**: "independently verified/validated" appears in the
  lane only inside its own prohibition (`package.lisp:20-21`).
- **AMENDMENT 1 claims pass**: A1.1 issuance axis is exactly
  `:issued-in-writing-image | :unresolved` with record-coverage on its own field ·
  A1.2 single-delta conjunct table printed and preserved, leg 1 (`ML0-PROMOTE-1`)
  the only NO · A1.3 pinned proposition verbatim in SPEC (line 45) · A1.4
  invariant proved, actual earliest refusal `MALFORMED-REQUEST` recorded, nothing
  wrapped to force a name · A1.5 `observation-interval` machine-readable, ML0-WR-6
  closes the two-doors asymmetry.
- **FLOOR-RESULT.txt honestly preserves BOTH runs**: run 1 FAIL 102/103 exit 1
  (gate #85 run-integrity — the builder committed mid-run, self-diagnosed from the
  script's own snapshot logic) beside run 2 PASS 103/103 exit 0 on a quiescent
  tree. Keeping the invalidated run in the record is the lane's own discipline
  applied to its own floor result.
- **File inventory verified against disk** — including the specimen's five stage
  files, which the chair's own first `ls` had truncated away (`head -40`); the
  discrepancy was the chair's instrument, not the builder's claim. Recorded here
  because a verifier's tool-shaped blind spot is exactly the class this repo
  documents.

## Chair's grading review

The builder's grades are accepted as filed: D6 **PARTIAL** (the `:contradicted`
row constructed, disclosed at point of use — correct: two sound instruments over
one universe agree by construction, so a natural clash requires a second
witnessing mechanism, which is /1 material) and D4 **SHOWN AS AMENDED** with the
pre-amendment prediction NOT SHOWN and unreachable (correct under AMENDMENT 1.4 —
the invariant outranks the name, and the competence half shows discrimination).
The eighth promotion leg (F-4, `attests`) — an admitted species that found
*nothing* warranting `:occurred` — and the fail-open length-limit repair are the
build's two sharpest findings; both now carry permanent teeth.

## Standing after verification

**UNCHANGED and restated: candidate · not audited · not adopted · not frozen ·
not registered · same-family hands (builder + chair one lineage, fresh-context
only) · planted-death crash model only · capability-disciplined never
capability-secure · no independent verification.** One Act /1's CANDIDATE
standing travels with every dependency claim. The stranger audit remains owed on
this lane and nine others.

— the chair, 2026-08-20
