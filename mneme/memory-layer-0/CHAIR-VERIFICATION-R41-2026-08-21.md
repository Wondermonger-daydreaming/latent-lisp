# Memory Layer /0 — CHAIR VERIFICATION, ROUND R4.1 (with R4.1b)

*Claude **Fable 5**, chair (the helm returned from Claude Opus 5, which chaired R4, at the
owner's hand). Builders: CONSUTOR (Opus, caller migration), SCRIBA and SCRIBA-II (Opus,
records). Cross-family reviewers: SCRUTATOR and SCRUTATOR-II (GPT/Codex workers) — the
first was refused once by an upstream classifier and ran on a re-pitch; its re-review was
refused again and ran as a fresh thread. **Same family for every build and every
third-hand run below — this is reproduction, NEVER independent verification.** The Codex
reads are cross-family STATIC+EXECUTED reviews, not a stranger's acceptance. Every result
below was observed in this session's own output unless marked otherwise.*

**Predecessor record:** `CHAIR-VERIFICATION-R4-2026-08-20.md`. **Received review that
commissioned this pass:** the owner-relayed static source and parcel-accounting review of
the R4 parcel `db1344f0…` (three items: consolidation contract incomplete; failed-write
requirement described around rather than met or amended; parcel accounting wrong in three
places). The R4 parcel is preserved untouched as evidence.

---

## 1. Item 1 — the consolidation contract, measured incomplete, then completed

**BEFORE, captured before any code changed** (`RED-CONSOLIDATION-BEFORE.txt`, lab `0f152ade`,
exit 1): consolidation computed `:occurred` over two validated `:occurred` accounts; the
documented durable route wrote `:unresolved` with all four rows `:stored-assertion`; a
`:raw-decode` input was admitted. 7 checks, 4 failures.

**Repair** (`e60fc3c5`): typed `ml0-consolidation` carrier · `ML0-CON-3` (validated
retrieval only) · `ML0-CON-4` (one subject carrier) · `ml0-materialize-consolidation` ·
`%ml0-append-body-and-read-back` shared with `ml0-write` · `ml0-write` loses
`:derivation`/`:predecessors`, `ML0-WR-2` withdrawn.

**AFTER** (`RED-CONSOLIDATION-AFTER.txt`, final: **35 checks, 0 failures, exit 0**), the
demonstrations the review asked for, each a numbered check: non-validated input declined
typed (`[002]` CON-3) · consolidate → materialize → **fresh-process** retrieval `:occurred`
(`[017]`, reader arm = this file re-invoked under `run-program`, `open-store` on the bytes)
· issuance a separate axis (`[011]`) · both predecessors + all four distinct rows survive
by digest (`[012]`–`[014]`) · controlled contradiction survives as `:contradicted` through
materialization and a fresh process (`[024]`–`[027]`; **MODELLED**: a real absence door's
row re-scoped from inside the package — unreachable to an outside caller; two correct
production doors still cannot disagree) · reversed order byte-identical (`[015]`) · direct
write of the same pair still refused `ML0-WR-6` (`[022]`).

**Measured, not expected:** `[016]` — the two orderings materialized twice land on ONE
frame: PJ0 `append-event` is idempotent on event identity (PJ-APP-1..3). The chair's first
draft of the check expected two frames and was corrected by the measurement.

## 2. The disarmed crown tooth (CONSUTOR's find; chair-reproduced)

`ml0-red-proof`'s crown tooth's consolidation conjunct compared a keyword to the new struct
and could not be false; the gate exited 0 and printed "the tooth bites" throughout the
migration. Found by diffing the preserved R4 transcript (`after CONSOLIDATION : :UNRESOLVED`)
against the live one (`#S(ML0-CONSOLIDATION …)`). Repaired at the call site; predicate
untouched. **Chair third-hand, executed:** cured arm `after CONSOLIDATION : :UNRESOLVED /
CROWN TOOTH : PASS / exit 0`; uncured arm `:OCCURRED / FAIL / exit 1`; combined exit 0. A
scripted sweep of all 29 `ml0-consolidate` call sites outside `ml0.lisp` found no second
instance. Filed in the RETURN as the absence-warrant class in a new substrate.

## 3. R4.1b — SCRUTATOR's three findings, all reproduced and closed

Chair reproductions, **executed on the committed R4.1 code with `ml0.lisp` stashed**
(`RED-HASH-S-BEFORE.txt`, `RED-CARRIER-BEFORE.txt`):

```
#S(…:ML0-ACCOUNT :OCCURRENCE-STANDING :OCCURRED :STANDING-AUTHORITY :VALIDATED-RETRIEVAL) -> CONSTRUCTED
#S(…:ML0-SOURCE :VALIDATION-STANDING :VALIDATED-BY-DOOR)                                 -> CONSTRUCTED
#S(…:ML0-OBSERVATION …) / #S(…:ML0-BUNDLE) / #S(…:ML0-CONSOLIDATION …)                   -> CONSTRUCTED
PROBE-1 mutated carrier -> WRITTEN standing=:OCCURRED warranting-rows=0
PROBE-2 principal direct="principal:actus-memoratus" derived="principal:principal:actus-memoratus"
PROBE-2 re-consolidate derived+original -> REFUSED [ML0-CON-4]
PROBE-3 cross-store -> WRITTEN into foreign store
```

The `#S` exposure was **lane-wide and pre-existing since R2** — every "internal
constructor" claim had this side door. Truth-minting migrated a FIFTH time: into the
reader macro, and into the mutability of a data object the caller holds.

**Repair** (`fd3d1915`): all ten internal constructors BOA `&key` (SBCL's `#S` needs a
default keyword constructor; a BOA one makes it a READER-ERROR; the one non-nil default
carried) · materialization re-retrieves inputs from the TARGET store, re-folds, compares
canonical body digests, refuses on mismatch (`ML0-MAT-2`), refuses foreign-store lineage
(`ML0-MAT-3`; fork R4.1-F3, cross-journal narrowed to future work) · `%ml0-bare-principal`
(`ML0-MAT-4`).

**AFTER** (same probes, `RED-HASH-S-AFTER.txt`, `RED-CARRIER-AFTER.txt`): 5× READER-ERROR ·
`PROBE-1 -> REFUSED [ML0-MAT-2]` · principal equal, re-consolidation `ACCEPTED` ·
`PROBE-3 -> REFUSED [ML0-MAT-3]`. Proof §8 added; **`[029]` enumerates every structure
class in the package (10) and refuses `#S` for each — teeth-checked: a planted
keyword-constructor struct makes it FAIL** (chair, `/tmp/plant.lisp`, output
`#S-constructible (ML0-PLANTED-FAULT) -> gate would FAIL (bites)`).

**SCRUTATOR-II (fresh Codex thread) re-review at `07ec76be`:** all three **CLOSED**; caveats
preserved verbatim in `_staging/r41b-scrutator-ii-findings.md` — digest equality rather than
body equality; CL package privacy is not a capability boundary; the target-store re-read is
not an atomic snapshot under a concurrent append (transient refusal at worst on the paths
inspected). One stale docstring it caught, corrected in `92b5ff74`.

## 4. Item 2 — the failed-write requirement: OPEN

Determined: Journal /0's public surface (7 verbs, read from `writer.lisp`) has no
frame-removing verb; Journal /0 is frozen; a retraction verb contradicts */0 never
forgets*. The literal work-order §5.A cannot be met in-lane for post-append refusals.
Question for Sol prepared and **PARKED** (`notes/2026-08-21-ml0-failed-write-variance-
question-for-sol.md`): original requirement · verified-after-append behaviour · why the
readback exists · why rollback is unavailable · two dispositions + one in-lane narrowing
(pre-append dry decode) offered, NOT taken. **Not closed. Not amended.** The work order is
byte-untouched; the SPEC carries a pointer only.

## 5. Item 3 — parcel accounting

`FLOOR-RESULT.txt` entry corrected by regeneration (the R4 manifest's `6080de36…` hashed a
pre-append fossil; the file read `de980d52…`). GUIDE count 145 → **195 = 148 · 27 · 20**,
loader-asserted at load (R4's 177 = 131/27/19 as the review stated; R4.1 added 17
functions + 1 type; R4.1b added none). Guide re-walked twice (R4.1, R4.1b), recipe block
byte-identical to R4's (`e4773cb6…`), exit 0 each time. Manifest regenerated LAST, over
every lane file except itself, including this record — see §7.

## 6. Gates — chair third-hand, exits walked (after `92b5ff74`)

selftest **81/0** · controls **11/11** · mutants **6/6** · block-proof **20/20** ·
consolidation-proof **35/0** · red-proof cured 0 / uncured 1 / combined 0 · host-fault PASS
· specimen **45/0**, transcript `cmp`=0 against the shipped capture, sha `39849f99…`
(**unchanged from R4 — the transcript does not print the fields fork F2 changed, so it is
not a witness to F2**; the artifact's principal counts 23→9 / 11→25 are). Thirteen
consumed-lane regressions exit 0 (`RUN-EXITCODES.txt`, chair block).

**Release floor:** run twice. First run (17:29–17:53 UTC) PASS 103/103 exit 0 but HEAD moved
mid-run (SCRIBA-II's records landed) — disclosed, not counted. Quiescent run after
`92b5ff74` (17:54–18:17 UTC): **PASS 103/103, exit 0, `git before: 0 entries`, checkout
unchanged** — full record appended to `FLOOR-RESULT.txt`. One commit (`7ab0fdef`, the Book of
the Guild, outside the subject tree) landed during it; the subject bytes were untouched.
The lane is **NOT registered** on the floor.

## 7. Checkpoint fossils and the manifest

Three `session-checkpoint` Stop-hook commits of in-flight agent work exist in this round
(`c4c7be83` unloadable, `2b4e1d5f`, `aebec9f9`): **kept, not squashed**, per CLAUDE.md §I-j.
None pushed at the time of the decision. The manifest is generated after this record,
the guide walk, and the floor result exist, and verified mechanically (`sha256sum -c`).

## 8. Standing

**candidate · not audited · not adopted · not frozen · not registered · same-family hands ·
planted-death crash model only · capability-disciplined never capability-secure · no
independent verification · §5.A an OPEN variance.** Two cross-family static+executed reads
(SCRUTATOR, SCRUTATOR-II) are real outside eyes and not a stranger's acceptance; the
stranger audit stays owed on this lane and nine others. Nothing registered, published,
transported, or sent; `SYNC-PAUSED` byte-untouched; relay r41 PARKED UNSENT.

*— Claude Fable 5, chair, 2026-08-21*

---

## R4.1c — release-correction pass (Sol's direction, same day)

*Bounded, local, offline. No sending, publishing, registration, synchronization, or sentinel
change. The same-store repair is NOT reopened (the second review found it provisionally sound
within its stated SBCL/public-API boundary); reopened only if a verification below fails.*

**Task 1 — R4.1-F3 made an explicit governance item.** New parked question
`notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`: two dispositions
(A: `/0` supports durable consolidation only when every predecessor is retrievable from the
destination store, no durable cross-journal merge in this slice, D4 binding on any future
implementation · B: receipt-bearing cross-journal materialization now, with source-store
identity/receipt/verification design); chair recommends (A) for `/0`; **the recommendation is
not a ruling.** Relay title and standing amended: **two governance dispositions remain** (§5.A
failed-write; R4.1-F3), each its own parked message. R4.1-F3 is described as OPEN everywhere it
is named — not "future work", not "not a hole".

**Task 2 — proof state synchronized to 35 checks, §8 = eight** ([028] sampled `#S` · [029]
enumeration · [030] source-list alteration refused · [031] predecessor-list alteration refused ·
[032] copied carrier identical content · [033] principal singly prefixed · [034] derived
reconsolidates · [035] foreign-store refused). Historical 27/34 figures retained only where
labelled as the state at that earlier execution. Fresh 35/0 row appended to `RUN-EXITCODES.txt`
(not rewritten); GUIDE-WALK retaken after the GUIDE edit.

**Task 3 — construction-boundary prose corrected, semantics unchanged.** Claims of "the only
way to hold one" / "alone can construct" / "nothing a caller does changes what is written" /
"byte-for-byte" (for the carrier comparison) replaced by the narrower facts: no constructor is
exported; SBCL's `#S` default-constructor route is refused because all ten structures use BOA
constructors; construction privacy is defense in depth, not the soundness boundary;
materialization treats the carrier as an untrusted request, re-retrieves its input identities
from the target store, and writes the recomputed body; no presented body field selects durable
standing or lineage — input identities select what the store is asked to retrieve, and the
resulting body is recomputed and checked by canonical-body SHA-256 digest.

**Verification (chair, direct exits, after `29ea12bd`):** selftest **81/0** · controls **11/11**
· mutants **6/6** · host-fault PASS · block-proof **20/20** · **consolidation-proof 35/0** (§8 =
eight, `[028]`–`[035]`) · red-proof cured exit 0 / uncured exit 1 / combined exit 0 · specimen
**45/0**, transcript `cmp`=0 vs the shipped capture · guide walk: §2 block 3605 bytes, sha
`e4773cb6…` (unchanged since R4), exit 0 · **13/13 consumed-lane regressions exit 0** ·
**quiescent floor PASS 103/103 exit 0** (19:08–19:32 UTC, HEAD `29ea12bd` start and end, 0
entries before, checkout unchanged), lane NOT registered. Manifest regenerated LAST after this
block and verified mechanically. Parcel: `memory-layer-0-candidate-r42-2026-08-21.tar.gz`
(monotonic label after r41; digest in its sidecar, never in this text).

**Two governance dispositions remain open, each its own parked question:** §5.A failed-write ·
R4.1-F3 cross-journal materialization. Standing otherwise unchanged. Nothing sent, registered,
published, synchronized; sentinel untouched. R4.1 parcel `80663eee…` preserved untouched.

---

## R4.1d — release-RECORD correction (Codex second-pass disposition: HOLD for one bounded correction)

*Records/prose only. No production logic or durable account semantics changed. The same-store
repair was not reopened — no semantic verification failed.*

**Chronology, corrected (task 1):** the R4.1c claims "no `.lisp` edit / changed no code /
unchanged lane" are SCRIBA-III's and hold for that officer's bounded subpass only. At chair
closeout of R4.1c, **two Lisp source files received prose/reporting-only edits** — `ml0.lisp`
(comments/docstrings) and `ml0-consolidation-proof.lisp` (one §6 banner). R4.1d made the same
class of edit to `ml0.lisp` again (the boundary sweep) and none to the proof source. Correction
blocks were appended, not substituted, in the RETURN and RUN-EXITCODES; a chair note was
prepended to the officer's report.

**Capture retaken (task 2):** `RED-CONSOLIDATION-AFTER.txt` regenerated from the current proof
source — §6 line carries the narrowed banner; terminal `35 checks, 0 failures`, exit 0. Prior
capture preserved in parcel r42 and in history.

**Boundary sweep finished (task 3):** remaining `ml0.lisp` source/observation/coverage
statements and the relay's "unreachable to an outside caller" now read: *not exposed through the
exported, supported API; Common Lisp package privacy is not a capability boundary*; "the one
route" → "the supported public route"; "ONLY producer" → "supported producer".

**Maintenance rule (task 4):** SPEC and GUIDE now say `[029]` automatically enumerates every lane
structure and is the coverage gate; `[028]` is the five-type sample; manual addition to `[028]`
protects nothing.

**Relay (task 5):** companion-parcel line → `memory-layer-0-candidate-r43-2026-08-21.tar.gz`
with the r41 → r42 → r43 chronology in its heading and opening; filename stable.

**Verification (chair, direct exits, after `9932e580`):** selftest 81/0 · controls 11/11 ·
mutants 6/6 · host-fault PASS · block-proof 20/20 · **consolidation-proof 35/0** · red-proof
cured 0 / uncured 1 / combined 0 · specimen 45/0, `cmp`=0 vs shipped · guide walk exit 0 (block
3605 B, `e4773cb6…`, unchanged) · 13/13 consumed-lane regressions exit 0 · **quiescent floor PASS
103/103 exit 0** (19:52–20:14 UTC, HEAD `9932e580` start/end, 0 entries, checkout unchanged),
lane NOT registered. Manifest regenerated LAST after this block, exact coverage verified.

**Exact changed-file list, R4.1d:** `ml0.lisp` (prose) · `MEMORY-LAYER-0-SPEC.md` ·
`MEMORY-LAYER-0-GUIDE.md` · `MEMORY-LAYER-0-RETURN.md` · `GUIDE-WALK.txt` (retaken) ·
`RUN-EXITCODES.txt` (appended) · `RED-CONSOLIDATION-AFTER.txt` (retaken) · `FLOOR-RESULT.txt`
(appended) · this record (appended) · `FILE-MANIFEST.txt` (regenerated) · outside the lane:
`notes/…-relay-…-candidate-r41.md`, `_staging/r41c-scriba-iii-report.md` (chair note
prepended). Pause in force: nothing sent, registered, published, synchronized; sentinel untouched.

---

## R4.1e — release-RECORD correction (Codex R43 disposition)

Four corrections, records/prose only; repair not reopened. (1) Boundary sweep finished under the
exact rule — *not exposed through the exported, supported API; CL package privacy is not a
capability boundary; an internal constructor remains callable through package-internal access;
BOA closes the supported SBCL `#S` route, not every possible call* — at every site Codex named in
SPEC, GUIDE, RETURN and `ml0.lisp`. (2) Guide walk retaken with the strong extractor (§2–§3 span,
exactly-one-fence assert, run unchanged): 3850 B, sha `34f705b2…`, exit 0, full stdout kept.
(3) Relay accounting line → parcel r44 with a recomputed member count, no "companion note";
`RUN-EXITCODES.txt` truncation corrected by appended full line. (4) "originally … no code
semantics change" scoped to SCRIBA-III's subpass.

**Verification (chair, direct exits):** consolidation-proof **35/0** (AFTER retaken from final
source) · selftest 81/0 · controls 11/11 · mutants 6/6 · host-fault PASS · block-proof 20/20 ·
red-proof cured 0 / uncured 1 / combined 0 · specimen 45/0, `cmp`=0 · guide walk exit 0 ·
13/13 consumed-lane regressions exit 0 · **quiescent floor PASS 103/103 exit 0** (20:42–21:05 UTC,
started at HEAD `0dec47e1`, subject tree 0 entries before and unchanged after; the Stop hook
checkpointed `0c210316` mid-run — `agents/hermes/notes/self-reflections.md`, outside the subject
tree, zero subject-tree diff lines — disclosed, not smoothed), lane NOT registered. Manifest regenerated LAST after this block; exact coverage verified.
Pause in force: nothing sent, registered, published, synchronized; sentinel untouched.

---

# ROUND R5 — Sol's dispositions entered; the dry-decode narrowing implemented (2026-08-21, night)

*Claude Fable 5, chair. Builders: the chair (code), SCRIBA-IV (Opus, records). Same family
throughout; not independent audit. Sol's instruction archived verbatim:
`corpus/voices/received/2026-08-21-sol-ml0-dispositions-r5.md`. Base accepted by Sol: parcel r44
`287629b4…` (acceptance of the parcel and static record, not execution verification, not
registration).*

**Step 1 — dispositions entered BEFORE code (`615f355a`):** WORK-ORDER AMENDMENT 2 (§5.A,
disposition B, Sol's governing text verbatim; pre-append dry decode required; residue host fault
only; no rollback/truncation/tombstone/supersession; Journal /0 untouched) · AMENDMENT 3
(cross-journal disposition A; `ML0-MAT-3` stays; D4 unamended; **Memory Layer /1 reserved**,
charter recorded in `MEMORY-LAYER-1-RESERVED-CHARTER.md`, not built) · both parked questions
marked **ANSWERED BY SOL**, text preserved, disposition appended.

**Step 3 — the narrowing (`eaad89b5`), and only it:** `%ml0-dry-decode` in the shared append
tail (`encode-pjs0` → `decode-pjs0` requiring `:canonical` → the exact account decoder on the
inherited-warrant route → identity compared to the minted one); any failure refuses **ML0-WR-8
before mutation**, for both the direct and the derived route. Overlay CONTROL seams (not
mutants; `ml0-mutants` still 6): `:frame-rendering-mismatch`, `:identity-mismatch` (ONE-SHOT —
the decoder mints through the same function, so a seam that always lied would lie to both
sides; TOOTH 13 missed both halves on the chair's first draft for exactly that reason, and the
miss is recorded), payload `:skip-dry-decode`. **CONTROLs 12–13**: cured → WR-8 pre-append,
whole-store file set + sha256 unchanged; diseased → the same fault lands and refuses post-append
(RB-7 / RB-11) with the store grown. **CONTROL 11** re-noted as the host-fault residue under
§5.A as amended. Capture: `RED-R5-DRY-DECODE.txt`.

**Sol's five measures, where met (cited, not re-invented):** (1) pre-append refusals
non-mutating over the whole store → CONTROL 7, 11-cured, 12-cured, 13-cured · (2) planted
dry-decode / identity failures before append → CONTROLs 12, 13 · (3) post-append host fault: no
account, no retraction, frame still validates → CONTROL 11 · (4) fresh-process judgment only
from validated durable bytes → the specimen's lector (D1/D2) and consolidation-proof `[017]`,
`[027]` · (5) the genuine certificate for the unperformed act `:unresolved` through write,
restart, retrieval, consolidation → red-proof crown tooth (write + retrieve + consolidate) and
specimen D2 (the lector, after restart).

**Ceilings preserved by instruction:** D6 `PARTIAL` · demonstration D4 `SHOWN-AS-AMENDED` ·
package privacy defense in depth · same-family execution is not independent audit.

**Verification (chair, direct exits, after `eaad89b5`):** selftest 81/0 · **controls 13/13** ·
mutants 6/6 · host-fault PASS · block-proof 20/20 · consolidation-proof 35/0 · red-proof cured
0 / uncured 1 / combined 0 · specimen 45/0, transcript `cmp`=0 vs shipped (`39849f99…`; the dry
decode is silent when it passes) · guide walk (strong extractor) exit 0, block unchanged 3850 B
`34f705b2…` · 13/13 consumed-lane regressions exit 0 (one earlier sweep read thirteen failures
— it had been launched from the wrong directory; rerun from the subject root, 13/13; the false
alarm is named here so it is not mistaken for a regression) · API count unchanged 195 ·
**quiescent floor PASS 103/103 exit 0** (21:43–22:06 UTC) — **global HEAD `3fdb1b1c` at start
and at end**, subject tree 0 entries before and unchanged after; the Stop hook was disarmed for
the run by staging one owed file outside the subject tree (`_staging/r5-scriba-iv-report.md`),
disclosed. Lane NOT registered. Manifest regenerated LAST after this block; exact coverage
verified. Parcel `memory-layer-0-candidate-r5-2026-08-21.tar.gz` (monotonic after r44; digest in
its sidecar, never in this text). **Returned to Sol for the registration ruling.** Nothing sent,
registered, published, synchronized; sentinel and mirror untouched.
