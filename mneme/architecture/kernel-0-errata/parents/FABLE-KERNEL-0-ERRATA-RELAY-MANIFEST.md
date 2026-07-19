# FABLE-KERNEL-0-ERRATA-RELAY-MANIFEST

**Purpose:** relay packet carrying Claude Fable 5's blind, independently authored
Kernel /0 erratum candidate to the other independent author, for comparison and synthesis.
**Standing:** CANDIDATE ONLY — not adopted, not governing, not merged; nothing in this
packet amends any governing file. The packet lives in mirror-excluded, gitignored
`_staging/` and has not been committed; nothing here is public.
**Packaged:** 2026-07-18 (night), by Claude Fable 5 (Opus lineage, lab chair).

---

## 1. Payload (exact, unmodified files)

| File | SHA-256 | Lines | Bytes |
|---|---|---:|---:|
| `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md` | `b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34` | 680 | 43,018 |
| `FABLE-KERNEL-0-ERRATA-DECISION-LEDGER.md` | `689c748a2fd99150052a07b99a56e4187a47890ec31dfb1849114d32778be121` | 263 | 18,213 |
| `FABLE-KERNEL-0-ERRATA-TRACE-MATRIX.md` | `4d1a5fc79d7cf2dac6dfe2d379ab20e249bae61e3161b34cf409145ccf21bd8e` | 83 | 8,075 |

Payload total: 1,026 lines, 69,306 bytes. Hashes were computed at drafting time and
re-verified byte-identical immediately before packaging. `SHA256SUMS.txt` in this packet
covers every file including this manifest.

## 2. Repository commit inspected

`261122d15228c9214864fc3e28381c94651996b1` — lab tree `Claude-Code-Lab`, whose
`experiments/latent-lisp/` is the canonical source of the public mirror
`github.com/Wondermonger-daydreaming/latent-lisp`. HEAD was unchanged for the entire
drafting session; the working tree received no modifications outside `_staging/`.

## 3. Independence attestation (explicit)

This candidate was seeded exclusively from the governing repository artifacts listed in
§4. I did **not** inspect, request, infer from, or search for any erratum draft produced
by GPT, Sol, Codex, or any other reviewer. In particular I never opened, listed-for, or
grep-searched for `LISP-PLUS-KERNEL-0-ERRATA-0.1.md`, and I ran **no content grep for
"errata" anywhere in the tree**, precisely so that no other candidate's text could surface
even inside tool output. Repository navigation was by directory listing and named-artifact
reads only; no listing performed during the session surfaced any other-model erratum
candidate. The decision ledger was written before seeing any sibling candidate and is not
optimized for agreement with an unseen reviewer.

Shared-root caveat, stated for the synthesis chair: both candidates are seeded from the
same governing texts, so convergence between them is expected wherever the texts constrain
tightly and carries **no independent corroborative weight**; the synthesis signal lives in
the divergences, especially at the ledger's marked hesitation points (D-1, D-2, D-4, D-6,
D-7, D-8, D-11).

## 4. Complete source-artifact inventory (all read at the pinned commit)

**Relied upon:**

1. `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` — in full (2,397 lines incl.
   R-SYN-1..3 pre-seal repairs); the object amended.
2. `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` — §6.3 (claim
   facets), §6.10 (uncertain effect), §15.2 (call-296 projection), §16–§17 (adversarial
   tests; terminal matrix); superior law.
3. `mneme/architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` — in full
   (1,451 lines); adopted PJ0.
4. `mneme/architecture/process-journal-0/PJ0-PRESEAL-REPAIRS.md` — R-PJ-1..3, governing
   jointly with PJ0.
5. `mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md` — adoption terms incl.
   the CL independence gate.
6. `mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`
   — in full (1,486 lines); the governing reissued AP0.
7. `mneme/architecture/adapter-protocol-0/AP0-ADOPTION-2026-07-18.md` — adoption seal +
   binding riders (CL gate; stranger audit).
8. `mneme/architecture/ARCHITECTURE-0-STATUS.md` — WE-ARE-HERE; six-authorial-gap ledger.
9. `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` — the erratum lane's
   charge; AP-G4 disposition.
10. `mneme/kernel0/README.md` — the pure-core arc's gap ledger and excluded-test table.
11. `mneme/kernel0/determinacy.lisp`, `fixtures.lisp`, `conditions.lisp`,
    `manifestation.lisp` (constructor surface), `records.lisp` (claim/validation
    surfaces), `outcome.lisp` (axis checks) — the implementation state the erratum lands
    on.

**Deliberately excluded (recorded, not read):**

- any other-model erratum draft for this lane, specifically anything named
  `LISP-PLUS-KERNEL-0-ERRATA-0.1.md` — never sought (see §3);
- `SOL-COMMENTARY-*`, `SOL-POSITIONS-*`, `SOL-DISPOSITION-*`,
  `AMENDMENT-CANDIDATES-0.1.md` — pre-seal deliberation whose adopted content is already
  in the sealed decisions record, A0.1, and the STATUS stone;
- the frozen original (non-governing) AP0 candidate packet
  `lisp-plus-adapter-protocol-0/` — superseded evidence; only the reissue governs;
- the repo-root CD/0 errata family — Canonical Datum /0, a different subsystem.

## 5. Implementation-files modification list (after adoption; erratum §6)

| File | Change |
|---|---|
| `mneme/kernel0/conditions.lisp` | add five KE-23 condition types (new §20.2a family + one in §20.5) |
| `mneme/kernel0/determinacy.lisp` | KE-1 space/form checks; KE-2 singleton semantics; refusals re-typed |
| `mneme/kernel0/outcome.lisp` | KE-3 membership; KE-4 possible-effects identity; KE-18 `:judgment-class` gate; test-8 re-anchor |
| `mneme/kernel0/manifestation.lisp` | KE-22 `:producer-identity` + `:stream-relation` fields with presence rules |
| `mneme/kernel0/records.lisp` | KE-11/12/13 record constructors; KE-14 transformation orthogonality; KE-15 accessor forms |
| `mneme/kernel0/uncertain-effect.lisp` | `:possible-effects` set-equality helper for KE-4 |
| `mneme/kernel0/fixtures.lisp` | KE-5.4 call-296 form repair; KE-18 judgment classes; new 43/44/47/48 fixtures |
| `mneme/kernel0/folds.lisp` | KE-9 `:attempt-indeterminate` legality; KE-2.2 no-promotion guard |
| `mneme/kernel0/kernel0-selftest.lisp` | implement 43/44/47/48; add the 19 controls; update expected output |
| `mneme/kernel0/package.lisp` | exports for new types/constructors/accessors |
| `mneme/kernel0/README.md` | retire closed gap entries; record the adopted erratum as basis |

Arc-3 (journal store) and adapter-lane implementations inherit KE-6..KE-10 and
KE-17..KE-21 as fixture-format requirements; no PJ0/AP0 vector bytes change.

## 6. Required tests and planted mutants (erratum §7; matrix §D)

**Spec tests:** implement §25.6 tests 43, 44, 47, 48 (currently excluded); complete
test 45 via KE-18/19; re-anchor §25.1 test 8 to `global-uncertainty-scalar-rejected`.

**Planted controls (19):**
1. bare-atom bounded alternative → `determinacy-alternatives-invalid`;
2. alternative outside declared space → same;
3. asserted value not member of alternatives → same;
4. effect-axis alternatives ≠ referenced `:possible-effects` → same;
5. mutant fold reading singleton-`:bounded` as `:determinate` → caught;
6. fabricated second call-296 manifestation alternative → refused/caught;
7. mutant narrowing `(:billed :not-billed)` without reconciliation → caught;
8. `:attempt-indeterminate` before `:attempt-begun` / second terminal after it →
   `journal-illegal-transition`;
9. "reconstruction" skipping interior corruption → FAIL (PJ-TERM-1);
10. row bundle missing derived-artifact deletion attestation → nonconforming;
11. sealed→verified via accessor/transform → `standing-inflation`;
12. published read as accepted/true/observed → caught;
13. bare `:verified` / bare `:published` → `bare-validation-scope` /
    `bare-visibility-scope`;
14. integrity record with mismatched representation identity on a copy →
    `standing-inflation`;
15. `:structural` procedure licensing `:accepted` → `interpretation-class-violation`;
16. joint report flattened to one counter → nonconforming report format (KE-20);
17. manifestation without producer identity; streamed with bare `streamed-p` → refusal;
18. chunk aggregate without receipt/constituents → refusal;
19. global `:confidence` scalar → `global-uncertainty-scalar-rejected`.

## 7. Unresolved questions and owner decisions (ledger D-12; erratum §8)

**Owner decisions required at adoption:**
1. **Ride-beside vs reissue** — does the adopted erratum ride beside the sealed Kernel /0
   spec (PJ0-PRESEAL-REPAIRS precedent, spec bytes unedited) or fold into a reissued spec
   with new sums? Deliberately not pre-decided (adoption-record sketch field).
2. **Per-KE dispositions** — KE-1..KE-24 each adoptable/modifiable/strikable
   independently; the fold-ins (KE-9, KE-23/24) could be split to a separate erratum if
   the owner prefers minimum-surface seals (ledger D-1).
3. **Synthesis watch-points** — D-2/D-4 (singleton lawfulness; load-bearing for call-296
   constructibility) are where the two candidates are most likely to diverge.

**Held explicitly unresolved (no patch by invention):**
- the `:absent-after-completion` completion-presupposition tension under indeterminate
  execution — recorded as a bounded unknown; A0.1's next amendment round to keep or
  dissolve;
- factual classification of call-296 and the 76 kimi records — locked scoring lane,
  untouched;
- concrete channel-policy binding for visibility scopes — channel-policy lane;
- a lossy summary for multiple-unresolved occupancy — PJ0 §17.3's conservative stop
  stands;
- LCI/0 boundary pressure from the KE-11..13 shapes — flagged for the stranger audit's
  primitive-minimization eye.

**Standing caps carried forward:** the PJ0 and AP0 CL independence gates remain open and
unsatisfied by anything here; the stranger audit remains owed before any independence
language — including about this erratum's own review chain; this candidate itself is
unreviewed until compared with its sibling and sealed or refused by the owner.

---

*— Claude Fable 5, relay packet. The other author should read the candidate cold before
the ledger; the ledger marks where I hesitated, and the divergences are the synthesis.*
