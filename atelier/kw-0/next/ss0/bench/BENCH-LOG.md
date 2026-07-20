# SS-0 STEP-7 BENCH LOG — chair's verdict-bearing execution record

*Chair: Claude Fable 5 (fresh session per owner's ruling), 2026-07-20, ~18:20–19:00 −03.
Working artifacts in this directory; summary docketed on SS0-FREEZE-LEDGER.md. Full
transcripts: the .txt files beside this log and per-seat evidence/ trees.*

## Environment

- **SBCL wrapper misbind found at bench-light and repaired.** `~/.local/bin/sbcl` as
  found (mtime Jul 19 19:25) exec'd `~/.local/sbcl-root/usr/bin/sbcl` = **2.2.9.debian**,
  not the pinned 2.4.6 at `~/.local/sbcl-2.4.6/`. Caught by operation-check
  (`(lisp-implementation-version)` through the wrapper), not the greeting. Wrapper
  rewritten to the pinned install; re-verified by evaluation: `2.4.6`. **Every bench run
  below used 2.4.6.** (Whether any prior session's runs used the misbound wrapper cannot
  be reconstructed from here; the bench re-ran everything, which is the design.)
- Python 3 system; harness = frozen `ss0-harness.py` (v1.0 base / v1.1 ext), real SIGKILLs.

## BENCH-ORDER-DEVIATION-1 (docketed, not hidden)

Sealed packet §4 wanted VOID-1/VOID-3 teeth-checks *before* verdict-bearing runs; the
chair ran the ordinary corpus first (following the delivery handoff's item ordering),
then the VOID gates + teeth. Both gates PASS on all four source sets and both teeth
fired on planted faults, and all runs are deterministic and re-runnable, so no outcome
depends on the ordering; recorded as a deviation regardless.

## Integrity preconditions

- Frozen substrate 11/11 hash-match vs ledger. Reveal package 6/6 hash-match
  (sealed ext = `7bf5abad…` intact). Seat sources hash-match their freeze manifests
  at copy-time in every workspace (seat-a base `eac91d02…`/`1c416eb9…`; seat-b base
  `2f1af6a7…`/`7a154e06…`; seat-a ext `b27b0b09…`/`1bf3b6e6…`; seat-b ext
  `331f9ef8…`/`113c05de…`).
- Substrate selftest: **11/11 ALL PASS** under v1.0 AND under v1.1 delta (exit 0 both).

## SUBSTRATE-DOC-DEFECT-1 accommodation (as pre-docketed)

Seat A driven natively (accepts kind or S/E-names). Seat B driven through
`seat-b-adapter.py` (chair instrumentation, hashed `7aad7a2d…` base / `7a5e614e…` ext):
bijective (kind,killpoint)→name mapping, seat runner exec'd unchanged, kill mechanics
byte-identical (same frozen harness, same READY-marker + SIGKILL protocol).

## Seat B (Qwen3.8Max-Preview) — FIRST EXECUTION EVER of this code

- **Base harness S1–S7:** all correct. S1 exit 0; S2–S7 real SIGKILL at every READY
  window; provider ground truth consistent. No syntax errors, no API mismatches —
  blind-authored code ran first-try.
- **Base recovery:** coherent on all 7 corpses (S4/S7 honestly `unresolved`;
  S5 `outcome-recorded/durable=false`; S3/S6 torn tails detected).
- **Modes:** R3 refusals cite record evidence (4/4 states); R4 executed-receipt
  permanently blocks re-dispatch; not-executed receipt → ALLOWED per its documented
  assumption 5; R5 successor fresh identity + visible predecessor. (Refusals exit 0 —
  text-protocol design, vs Seat A's exit 3; both documented, recorded neutrally.)
- **Cross-language:** **9/9** digest agreements base (7 pristine + 2 mutated);
  **4/4** extension (E1–E3 pristine + E3 fully mutated incl. batch successor).
  Diff of full reports: identical modulo the "(CL)" header.
- **Extension E1–E3:** per-leg identities `<op>-L<i>`; E2/E3 leg-3 never dispatched;
  batch redispatch refusal cites the specific leg; per-leg receipt resolves only its
  leg; `succeed <batch>` records `reattempt=2,3 abandon=1` lineage; census only in
  derived output (obligation 1: no scalar batch outcome in durable record — held).
- **S1–S7 regression under v1.1: records byte-identical to base runs (7/7 hashes).**

## Seat A (Kimi K3) — chair reproduction of seat testimony

- **Base harness S1–S7:** all correct; S2 keeps zero pre-declaration records (design
  difference vs Seat B's setup record; both lawful). Kill mechanics identical.
- **Determinism observed:** fresh S4 re-run produced records hash `584fec4a…` identical
  to the first run — corroborates its "bit-identical across generations" testimony.
- **Modes:** R3 refusals exit 3 with citations (5/5 states incl. stream-incomplete);
  R4 provenance check verifies attempt identity before admission; executed attestation
  permanently blocks; not-executed attestation → redispatch CERTIFIES fresh-identity;
  R5 `succeed` on unresolved: predecessor stays UNRESOLVED + visible.
- **Design seam (recorded neutrally):** after not-executed attestation, `succeed`
  REFUSES (exit 4: "standing is ATTESTED — resolved; nothing to supersede") while
  `redispatch` certifies a fresh dispatch as lawful. Seat B allowed succession in the
  same state. Divergent-but-documented designs; bands weigh at step 8.
- **Cross-language:** **10/10** base (7 pristine + 3 mutated); **4/4** extension
  (3 pristine + 1 mutated incl. bsucceed census, digest spec v2).
- **Extension:** `bsucceed` abandons known-executed legs (double-execution rationale),
  re-attempts others under per-leg `succ` lineage; `admit <batch>` refuses per-batch
  receipts; batch census in derived rendering only.
- **S1–S7 regression under v1.1: records byte-identical to base runs (7/7 hashes).**

## VOID-1 / VOID-3 — PASS with teeth (both seats, base + ext)

- Read-site enumeration: only lawful reads (records.log via substrate;
  `receipt-*.txt` per R4). Direct sweep for READY-/death-record/deaths.json/
  provider.log/corpse/exit-status/runner-stdout: **zero matches, all four base
  sources + all four ext sources.**
- VOID-3: no 8-hex fixture literals; no cross-invocation of the Python side; readers
  load only the shared frozen substrate.
- **Teeth:** planted READY-read fired the VOID-1 sweep; planted hardcoded-digest fired
  the VOID-3 audit (`void1-void3-teeth-transcript.txt`).

## AFEL recounts (mechanical, `ss0-afel.py`)

| Seat | Base runner | Base reader | Base total | Ext runner | Ext reader | Ext total | Net Δ |
|---|---|---|---|---|---|---|---|
| A | 361 | 121 | **482** | 513 | 166 | **679** | +197 |
| B | 233 | 106 | **339** | 433 | 182 | **615** | +276 |

Seat A's numbers = its testimony exactly (incl. excluded-line list
`[76,80,81,86,94,101,102,107]` base; 10 ext). Seat B's are the first measures of its
code. Exclusion audits: only window/torn death instrumentation marked, both seats.
(Seat A's separately-claimed diff-based ext delta "225 added/changed lines" is a
different measure from net Δtotal; re-computable from `EXTENSION-DELTA.diff` at
adjudication if wanted.)

## Seat B base-integrity (full-source delivery; docketed bench item)

- Marker pairs verified: runner 14/14, reader 8/8.
- **Runner: COMPLIANT** — unmarked portions identical to frozen base modulo blank
  lines; the three "missing" base regions are lines whose extended replacements live
  inside marked blocks (initializer+batch fields; digest+field 14; report+legs).
- **Reader: PARTIAL** — two paren-reflow hunks (token-identical formatting) and **one
  unmarked structural edit**: the normalization pass (chunk sort, dispatched→unresolved,
  unknown→derived) hoisted from the collection loop into a pre-pass maphash, rules
  byte-identical in content + a mechanical `(setf (gethash …))` writeback. Seat B's
  semantic claim ("no original recovery rule rewritten") HOLDS; its locational claim
  ("confined to marked additions") is NOT byte-strict for the reader. To the bands.
- Full finding: `seatb-base-integrity-finding.txt`.

## Mutation-battery scope enumeration (published BEFORE any mutant runs — packet §2)

Production paths per side := **the AFEL-counted lines** of its frozen sources (base
and ext), i.e., every line except the audited `@harness` exclusions listed in
`afel-base-recount.txt` / `void-afel-ext.txt`. This is the packet's own definition
("every function reachable from the runner and recovery entry points excluding audited
`@harness` markers") made mechanical. No post-hoc adjustment.

## Status at this checkpoint

DONE: selftests, both seats' base + ext corpus, recovery-mode batteries,
cross-language differentials (27/27 agreements total), VOID-1/VOID-3 + teeth, AFEL
recounts, Seat B base-integrity finding.
NEXT: mutation battery M1–M6 × both seats (scope above), then step 8 (unseal
adjudication `673e1126…`, apply bands, publish everything together).

## Mutation battery M1–M6 × both seats — COMPLETE (2026-07-20 evening): 12/12 DETECTED, zero survivors

Scope as published (AFEL-counted lines). Each mutant = minimal chair-authored edit on a
disposable copy; disclosed diffs at `mutants/DIFF-{a,b}-m{1..6}.diff` (1–4 changed lines
each; hashes in ledger). Probes on pristine `corpse.snapshot` reconstructions where the
live evidence dirs had been mutated by mode exercises (corpse-contamination caught and
corrected mid-battery for M2-B/M3-B probes — first probes hit admitted corpses and fired
the wrong branch).

| Mutation → obligation | Seat A verdict / detector | Seat B verdict / detector |
|---|---|---|
| M1 collapse payload distinction → R2 | DETECTED — P-family probe: valid/valid/valid vs distinct baseline | DETECTED — own CL differential: 00000000 vs 27C3ADF1, digests split |
| M2 permit blind re-dispatch → R3 | DETECTED — gate flips CERTIFIED exit 0 (baseline REFUSED exit 3); 2-hunk mutant needed (gate is default-deny: tuple + fall-through) | DETECTED — ALLOWED vs baseline REFUSED-with-citation |
| M3 launder derived state → R6 | DETECTED — CL differential: conf=1 vs conf=0, digests split | DETECTED — CL differential: derived=false vs true, digests split |
| M4 settlement upgrade w/o record-entered evidence → R4 | DETECTED — probe: admit *claims* entered, canon shows UNRESOLVED (baseline ATTESTED) | DETECTED — probe: ADMITTED claim, recover shows unresolved (baseline receipt-resolved) |
| M5 drop predecessor standing on succession → R5 | DETECTED (v2) — render drops pred; CL still reports UNRESOLVED, digests split. **v1 (append done-record for pred) was NEUTRALIZED by the design** — done-without-outcome does not upgrade standing; equivalent mutant, superseded. Robustness finding recorded. | DETECTED — probe: pred state=completed (baseline stays unresolved) |
| M6 scalar-compress census → R1/R9 | DETECTED — CL differential: F80CD476 vs 904278BF | DETECTED — CL differential: DBFE2990 vs 6A9432ED |

Battery conclusion: no surviving mutant ⇒ no obligation fails via the battery, both seats.
Detection channels exercised: each seat's own cross-language differential (7), obligation
probes (5). Mutant workspaces retained under `mutants/` for reproduction.
