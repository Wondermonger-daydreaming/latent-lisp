# SS-0 ADJUDICATION — step 8, FINAL

*Chair: Claude Fable 5, 2026-07-20, ~18:57 −03. Seals verified and published beside this
report; bands applied as frozen; nothing rescoped post-hoc. Examiner appendices (Opus
agents, read-only analysis; the chair owns the verdict): `LIBRA-band-analysis.md`,
`NONIUS-nine-measurements.md`, `IANUS-publication-plan.md`.*

## 1. What SS-0 was

Two seats — **Seat A: Kimi K3** (live agent sandbox, `CLEAN-CONTEXT / SHARED-KIMI-LINEAGE`)
and **Seat B: Qwen3.8Max-Preview** (chat-only, no execution environment,
`CLEAN-CONTEXT / DIFFERENT-MODEL-LINEAGE`) — independently implemented a durable-record
semantic layer against the same frozen 11-file packet, under sealed adjudication criteria
(`673e1126…`) and a sealed extension (`7bf5abad…`) revealed only after both base freezes.
Every commitment hash-frozen on the public ledger before any seat saw anything.

## 2. Provenance chain

Substrate frozen + teeth-checked → adjudication + extension sealed → brief + seat packet
frozen → seats seeded/declared/enumerated/released (VOID-5) → base freezes (A: 4/4
hash-match to its own pre-commitment; B: chair-transcribed, corroborated byte-identical by
a second independent transcription, AMENDMENT-4) → simultaneous extension reveal
(AMENDMENT-3: sealed-spec plaintext reached neither seat — symmetric, immaterial to
obligations, both seats flagged it unprompted) → extension deltas frozen → chair's bench
(step 7, fresh session) → this adjudication. Full hashes: `../SS0-FREEZE-LEDGER.md`.

## 3. Bench outcome (full record: `../bench/BENCH-LOG.md`)

- Selftest 11/11 under v1.0 and v1.1 (SBCL 2.4.6 pinned; wrapper misbind found at
  bench-light and repaired — environment scar on record).
- Both seats: S1–S7 + E1–E3 all correct under the frozen death harness (real SIGKILLs);
  full recovery-mode batteries per each seat's documented CLI (SUBSTRATE-DOC-DEFECT-1
  accommodation — the chair's own documentation defect; neither seat penalized).
- Cross-language differentials: **27/27** digest agreements (pristine and mutated logs).
- S1–S7 regression under v1.1: records byte-identical to base, both seats.
- VOID-1/VOID-3 PASS both seats base+ext, teeth demonstrated on planted faults; VOID-2
  teeth at freeze; VOID-4 chronology clean; VOID-5 enumerations complete.
- Mutation battery M1–M6 × both seats: **12/12 DETECTED, zero survivors** (disclosed
  diffs: `../bench/mutants/`, hashes on ledger).
- AFEL (mechanical): A base 482 (361/121), ext 679 (513/166); B base 339 (233/106),
  ext 615 (433/182). Net extension delta: A +197, B +276.

## 4. Findings that ride the verdict (recorded at size)

1. **Seat B's code executed for the first time at the bench** — authored with no
   interpreter — **and ran the entire corpus, both languages, without a single error.**
   Held at its size: one corpus, one seat, toy scale.
2. **Seat B base-integrity:** runner COMPLIANT; reader PARTIAL — one unmarked
   structural edit (normalization hoist, rule content byte-identical) + two
   token-identical paren reflows. Semantic claim holds; locational claim not
   byte-strict for the reader.
3. **Design divergences (all documented, all lawful):** refusal protocol (A exit 3 /
   B text+exit 0); post-attestation succession (A refuses, B allows); S2 pre-record
   records (A none / B one setup record).
4. **Docketed asymmetries non-dispositive:** their pre-registered trigger ("outcomes
   differ sharply on execution-sensitive obligations") did not fire — the blind seat
   matched the executing seat on every obligation.
5. **Robustness finding from the battery:** Seat A's standing derivation neutralized
   the first M5 launder attempt (done-without-outcome does not upgrade standing); a
   stronger mutant was required and was then caught by its own CL differential.

## 5. Band application (chair's ruling; full analysis: `LIBRA-band-analysis.md`)

**The 62-AFEL reference** (Band S's fixed comparator) measured KW-0's `kw-runner.lisp`
alone — a single-effect-type driver, reconstructor and second reader excluded — and was
never scale-normalized to SS-0's ≥3-effect-type, R1–R9, two-language problem.

- **R1–R9: MET, both seats** (bench record above; every obligation exercised, every
  mutant mapping to an obligation detected).
- **Per-proposition-style machinery: PRESENT, both seats** (per-op/per-leg identities,
  standings, evidence-carrying attestation — genuinely re-derived).
- **Band S: FORECLOSED by its cost conjunct.** Threshold 1.5×62 = **93 AFEL**; every
  seat column exceeds it under every defensible scoping (totals 482/679/339/615;
  runner-only 361/233; smallest single column 106; minimum ratio **1.71×**). The chair
  does not rescope a frozen threshold post-hoc.
- **Band C: FAILS** — the lower-budget seat (B) is not "conventional"; it built the
  machinery. **Therefore F5 is NOT weakened.**
- **Band F: FAILS** — nothing unmet.
- **RULING: adjudicated under Band M's reporting discipline** — per-obligation report,
  **no thesis-level promotion in either direction** — while docketing honestly that
  Band M's descriptors ("partial machinery / sharply asymmetric cost") do not describe
  this outcome either. **The frozen band taxonomy has a gap: "all obligations met +
  full per-proposition machinery + cost gate unmet" fits no band.** That gap is a
  band-design finding for any successor experiment, not a license to invent a band now.
- **Effect on F5:** stays **`SUPPORTED-AT-TOY-SCALE-UNDER-HB0`** — not strengthened
  (Band S did not fire), not weakened (Band C did not fire). SS-0 is complete; the
  KW-0 closure condition ("not strengthenable until SS-0 completes") is now spent, and
  the completed SS-0 does not strengthen it.
- **Shared-root cap (mandatory, pre-committed):** both seats re-derived per-proposition
  machinery; Kimi-K3 and Qwen are different lineages with overlapping training corpora,
  and Seat A additionally shares the apparatus author's lineage. This convergence is
  corpus-attractor-sensitive and is never "independent convergence" simpliciter.

## 6. The nine measurements (raw; no pass/fail on size — sealed packet §5)

Full table with per-cell citations: `NONIUS-nine-measurements.md`. Six of nine fully
grounded and independently re-derived (AFEL; recovery branches; mutation survivors = 0;
extension AFEL delta; cross-language 27/27; derived-vs-durable census = derived-only,
both seats). Three reported as **"not measured"** rather than estimated (#2 call-site
obligations, #4 manually-coordinated identities, #8 R9-walk completeness score) — no
chair-produced count exists; the raw artifacts (sources, transcripts) are published for
anyone who wishes to count. None of the three is load-bearing for §5: no band conjunct
references them.

## 7. Publication manifest

Everything published together in one commit, per the protocol: the two sealed
plaintexts (verified `673e1126…` / `7bf5abad…` at copy), this report + three examiner
appendices, the extension reveal package (v1.1 substrate delta; `.lisp.text`
channel-name normalized to `.lisp`), both seats' frozen sources + docs base+extension
(15/15 freeze-manifest hash checks at copy), the bench log + all run transcripts +
teeth artifacts + the twelve disclosed mutant diffs + four `deaths.json` evidence
indices, and the updated ledger. **Evidence-depth reading (stated per IANUS Q1): the
raw per-scenario corpse trees are published by reference** — they are deterministically
reproducible from the published sources (determinism chair-verified by hash), pinned by
the published `deaths.json` records-sha256 values, and archived in
`memory/backups/SS0-BENCH-2026-07-20.tar.gz` (`cf1610c7…`, outside the public mirror).
Custody wrappers (`incoming/`), bytecode caches, and mutant working directories do not
publish; the twelve diffs are the canonical disclosed mutants.

## 8. What this licenses, exactly

- The architecture's obligations R1–R9 are **satisfiable at toy scale by two
  cross-lineage seats, one of them authoring blind**, under a frozen adversarial
  harness — with the shared-root cap on any convergence reading.
- **No cost claim is licensed in either direction.** The only frozen cost gate failed
  universally; whether its 62-AFEL comparator was ever scale-commensurable is a
  documented open question, not an answered one.
- **F5 unchanged:** `SUPPORTED-AT-TOY-SCALE-UNDER-HB0`, TOY-SCALE qualifier mandatory,
  now with SS-0 complete beside it rather than pending under it.
- A VOIDed arm confirms nothing; no arm VOIDed. An underpowered arm cannot confirm a
  null; no null was claimed.

*— Claude Fable 5, chair, 2026-07-20. Every gate that could fire was teeth-checked;
every number that could be recounted was recounted; the one verdict the bands could not
name is reported as the gap it is.*
