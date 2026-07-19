# HB-0 challenge control — F5 disposition

**Implementer:** Fable (Claude Fable 5), independently seeded per commission; provenance + exposure disclosed in `HB0-PROVENANCE.md`. **Frozen:** `HB0-FREEZE.sha256` (control `938b58b0…`, post-freeze dedupe amendment `→` re-hashed, baseline unsealed only after freeze+eval). **Design:** conventional append-only event log — one readable plist per line (the Lisp engineer's JSON-lines), fsync before durability claims, recovery by re-reading; no frame chaining, no capability discipline, no outcome algebra.

## Runs (all under the fixture harness's real `SIGKILL` windows, fixture oracle unchanged)

Seven deaths reproduced with correct exits (`-9`/0). Classifications: S2 "no attempt recorded (valid prefix kept)"; S3/S6 torn tail discarded, no inflation; S4/S7 UNCERTAIN with **byte-identical journals and identical digests** (`A1A813F0…`) — the S4/S7 identity emerges in a conventional log too; S5 "result recorded; durable receipt absent". Futures: blind retry REFUSED with evidence; reconciled-executed does not replay; supersession preserves predecessor uncertainty; S7 retry lawful after not-executed receipt — provider log shows exactly one execution (a2). Independent second reader (`hb0-reader2.py`, no shared code): **11/11 digest MATCH** (after one true divergence — dedupe semantics — that the differential itself caught in its author's code; disclosed).

## Clause verdicts (commission §"What the control must achieve")

| Clause | Verdict | Note |
|---|---|---|
| 1. Prevent the four lies by construction | **PARTIAL** | Lie 2 (blind-retry double-spend): PREVENTED, demonstrated. Lie 4 (finalizer-only loss): PREVENTED (fsync-per-claim), S5 honestly classified. Lie 3 (laundering): reader can only say `reconstructed` (no other code path) — prevented within this artifact, but by the author's discipline, not by a type system; a conventional maintainer can add the lying line back in one edit. Lie 1 (empty→null): format distinguishes `:absent`/`""`/invalid by construction; **not exercised** by the seven fixture scenarios; census does not surface payload standing. |
| 2. Preserve distinctions across crash recovery | **PASS** at toy scale | All seven corpses. |
| 3. Independent second reader derives same state | **PASS** | 11/11; one spec divergence found and fixed pre-unsealing. |
| 4. Equivalent auditability | **PARTIAL** | Receipts and origin tags: yes. Scoped visibility: no. And the census digest **compresses evidentiary standing** — settled-via-unreceipted-result and settled-via-reconciliation-evidence collide (`S4-resolve` ≡ `S5` digest), an instance of exactly the multi-axis→scalar compression the architecture warns against, produced unprompted by a conventional design. |
| 5. Extend to a new effect type | **PASS** | Effect label is data (parameterized op); oracle generic over labels. |
| **Budget: all five in ≤100 AFEL** | **FAIL — 177 AFEL** (`f6v3.py`, 16 lines legitimately `@harness`-excluded) | 1.77× the budget; 3.40× the incumbent baseline's 52; 2.85× the specimen's 62 application-facing AFEL. |

## F5 disposition

**F5: SUPPORTED at toy scale — the challenge control did not falsify.** An honest conventional implementation *can* prevent the demonstrated failure modes (the incumbent baseline, now read, is an illustrative control with the lies scripted in — not a competitive one; the owner's D2 was the right demand), but doing so cost **177 AFEL against the 100 budget**, and still delivered only partial coverage on clauses 1 and 4. What the specimen buys is not possibility but **price and durability of the discipline**: my control's guarantees are conventions one edit away from erosion; its census already collapsed an evidentiary distinction I did not notice until the digests collided.

**Measurement asymmetry, named:** the specimen's measured column (62) excludes `kw-reconstruct.lisp` (219 lines) as substrate; my 177 includes my recovery machinery. The substrate-amortization claim (reusable across applications) is a promise at one-specimen scale, not a measurement. F5's support is therefore **provisional in strength, real in direction**: even granting my control its own "substrate" split, its runner-side logic alone does not deliver clauses 1/3/4 without the machinery.

**Also confirmed:** specimen `@harness` exclusions audited against the pre-registered marker rule — conforming; most hostile recount (cw2cw3 settlement append counted as production, +7 lines) gives 69/52 = **1.33×, still PASS**. No exclusion flips F6-v3.

— Fable, 2026-07-19. Control, readers, evidence, and freeze record in this directory.
