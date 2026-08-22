# One Act /1 — WORK ORDER (chair's draft; finalizes into the lane dir on commit)

*Drafted 2026-08-19 night by Claude Fable 5 (chair), under the owner's interview ruling
("Verify, then build One Act /1" — the name is owner-minted by that answer) and Sol's
six-demonstration commission of the same night, reframed to the crash axis after
INDAGATRIX-III's recon established that the one-process-life seam is already built and
ADOPTED as One Act /0 (2026-08-08).*

## 0. Name, lineage, governing sentence

- **Lane:** One Act /1 · directory `mneme/language-act-1/` (verified free, prose form
  "One Act /1") · package `#:lisp-plus-language-act1` (following act0's insertion of
  `language-`) · ASDF `lisp-plus/act1` (additive umbrella row, many-acts-0 precedent).
- **Successor to One Act /0** (`mneme/language-act-0/`), which owns the one-process-life
  seam. This lane adds exactly ONE axis: **process death**. Nothing else.
- **Governing sentence, to be executed not stated:** *the language door survives the
  process's death as a refusal: a genuinely new image, given only durable bytes and
  declared configuration, must refuse the same act at the `perform` boundary — and may
  proceed only through evidence-carried reconciliation at the runtime level.*
- **Crown fact this lane exists to demonstrate:** core0's continuation door
  (`continue-from`) is image-local BY LAW (issuance registry + no public evidence
  constructor + core0's own "This is NOT crash-survival" comment, core0.lisp ~1302).
  Across death, the language-level continuation is CLOSED by construction; the lawful
  path is runtime reconciliation (capability2) followed by a fresh act. The RETURN states
  this as the lane's central finding, not as a limitation discovered late.

## 1. What already exists (consume, never edit — public exports only, byte-unchanged)

- **One Act /0** — the bridge discipline to inherit wholesale: identity systems RELATED
  never unified (immutable act-fixture row; One Act ruling §A–§D at
  `language-act-0/rulings/oneact-owner-ruling-r1-2026-08-07.md:194,206-236`), one bridge
  object per act, `EQ` assertion before `perform`, zero Core /0 edits via `make-adapter`
  (act0.lisp ~916), §19 reserved verbs restated as constraint N-1.
- **core0** — `perform` (values OUTCOME EVIDENCE; pre-frontier refusals SIGNAL typed
  `core0-refused` carrying evidence+outcome; adapter `:crossed nil` → pre-frontier
  refusal), `outcome-kind`, `make-adapter` (dispatch + ledger-query closures = the whole
  door), `process-context` (concrete, identities self-minted — consumed as-given).
- **journal0** — `open-store` `create-journal` `append-event` `validate-journal`
  `read-prefix-valid` `reconstruct` + PJ-S/0 codec.
- **capability0/1/2** — `query-live-authority`, `mint-from-authorization`,
  `present-live-capability`, `authorize-effect-attempt`, `attempt-protected-effect`,
  `derive-effect-standing`, `rehydrate-kernel-events`, `check-retry-safety-from-store`,
  `declare-uncertain-effect`, `reconcile-uncertain-effect`, world constructors.
- **de-effectu-incerto** (capability2 specimen) — the three-process pattern to follow:
  orchestrator + first life + restart; planted deterministic death in the acknowledgment
  window (env-var early exit); byte-identical reruns via fixed store nonce (declared
  PJ-META-1 deviation); artifact manifest with journal prefixes byte-compared.

## 2. The specimen (working name `de-actu-resurgente` — verify free before use)

Three process lives, one orchestrator, following de-effectu-incerto's file shape:

**Life 1 (the act):** act fixture row declared (language identities + runtime identities,
related not unified) → runtime grant journaled → capability minted/presented per /1
discipline → language-side authority per act0's pattern → `perform` through the ONE
bridge object; dispatch closure: authorize-effect-attempt → attempt events journaled
(PJ0 fixture grammar per capability2's precedent) → protected effect against the durable
world → **planted deterministic death inside the acknowledgment window** (after the
world write + frontier events land, before acknowledgment comes home). The in-image
core0-evidence dies with the image — by design; say so in the transcript.

**Life 2 (the resurgent image):** durable bytes + declared configuration ONLY.
1. Reconstruct: `validate-journal` + `derive-effect-standing` + world reopened —
   frontier crossed, effect uncertain, world cell written exactly once.
2. **The crown tooth:** a same-request `perform` through a freshly built bridge whose
   dispatch consults `check-retry-safety-from-store` (and/or effect standing) BEFORE
   crossing → returns `:crossed nil` with the durable reason → core0 signals typed
   `core0-refused`, pre-frontier, evidence-so-far riding. Assert: outcome view :refused;
   journal gains ONLY the lawful accounting frames (if any); world ledger count
   UNCHANGED; world cells byte-identical.
3. Runtime reconciliation: `declare-uncertain-effect` / `reconcile-uncertain-effect`
   with evidence carried to the surviving world's ledger (UNC-2 discipline; the journal
   gains effect:uncertain + reconciled frames; nothing rewritten — final journal is a
   byte-prefix-extension of the post-death journal).
4. Fresh act on the freed seat: a NEW `perform` (new act row, fresh authority per the
   every-attempt-stales-the-key law) SUCCEEDS; result returns as (values OUTCOME
   EVIDENCE), outcome-kind :committed.

**Denied-path arm (life 1 or its own short life):** a `perform` with missing/mismatched
authority refuses pre-frontier; journal and world PROVABLY untouched (see teeth §4).

## 3. Sol's six demonstrations, mapped to this design

1. operation reaches the runtime — `perform` → bridge dispatch → capability2 attempt, both lives;
2. capability checked at the correct boundary — core0 frontier check + capability2
   authorization inside dispatch; restart re-earns authority (no carried key survives);
3. permitted path produces specified journal evidence — PJ0 frames enumerated in the
   manifest, byte-compared across reruns;
4. recoverability in the manner the seam requires — NOW AT THE CRASH AXIS: standing
   reconstructed from bytes; world state byte-identical; reconciliation completes the
   account; fresh act proceeds;
5. denied path fails explicitly with no unauthorized transition — typed refusal + whole-
   universe byte comparison (teeth §4);
6. result returns through the intended interface — (values OUTCOME EVIDENCE), outcome-kind,
   typed conditions carrying evidence; the refusal in life 2 is itself a demonstration of 6.

## 4. Teeth doctrine (binding; the absence-warrant thread applied)

- **RED-first:** every tooth shown to bleed before trusted. The suite must run at least
  once against a deliberately uncured variant (e.g. bridge that skips the store check)
  and FAIL; transcript kept.
- **Demonstration 5 carries both warrants:** (competence) a planted control in which the
  denied path DOES write — tooth must catch it; (scope) the no-transition claim is a
  byte-comparison of the ENTIRE journal file + ENTIRE world state (cells digest + ledger
  digest + count), before/after, universe stated in the tooth's own output. Never a
  one-cell spot check.
- **No silences without warrants:** no `[ -x ] || exit 0` shapes; harness distinguishes
  *absent* from *could-not-look*; every gate prints counts and exit codes captured
  directly (`$?` immediately, never through a trailing echo chain).
- Mutants (proportionate, ~3): (:bridge-skips-store-check → crown tooth bleeds),
  (:refusal-swallowed-to-success), (:reconciliation-without-evidence). Each killed by a
  named predicate.
- Regressions: One Act /0 gates + capability2 suite + core0 selftest re-run GREEN after
  the lane lands; consumed lanes byte-unchanged (empty `git diff` over their dirs).

## 5. Hard exclusions (stop conditions)

No Memory Layer /0 · no general PJ0→kernel0 rehydration widening (stay inside
capability2's closed vocabulary or build lane-local shapes, disclosed) · no SIGKILL
CLAIM (planted deterministic death only; de-teste-occiso/vertical0 own real crash
windows — say so) · no edits to any existing lane's files (umbrella .asd + verify-release
rows are ADDITIVE only, many-acts-0 precedent) · no new reviewer chains · no §19 reserved
verbs · no "independently verified/validated" · capability-disciplined, NEVER
capability-secure · Surface /3 untouched · SYNC-PAUSED stays raised; commits are WITHHELD.

## 6. Claim ceiling (travels verbatim into the RETURN)

Candidate · not audited · not adopted · not frozen · not on a governing floor until its
additive row is accepted · same-family hands (builder+chair one lineage; fresh-context
only) · planted-death crash model (no SIGKILL, no power loss, no mid-instruction
truncation) · single fake world, scripted adapter subset · one seat, one effect kind ·
in-process, non-adversarial recognition (capability1's ceiling inherited) · the
image-local issuance finding is a statement about core0's LAW, not a defect report.

## 7. Deliverables

Lane dir with: WORK-ORDER (this, finalized) · package.lisp (N-1 restated; api-complete
readiness discipline per lisp-plus.asd third-class precedent) · act1.lisp (bridge +
fixture + doors) · specimen (orchestrator + life1 + restart + common) · selftest ·
controls (incl. planted-fault arms) · mutants · RUN-EXITCODES.txt · ARTIFACT manifest ·
ONE-ACT-1-RETURN.md (six demonstrations table; what crossed the seam; what remained
stubbed/excluded; the Memory-Layer-/0 interface answer; claim ceiling verbatim).
Additive rows: lisp-plus.asd + verify-release.sh. One censor-style claims pass on the
RETURN before the closing commit.

## 8. Inherited findings from PROBATOR's One Act /0 verification (2026-08-19, folded in before the build)

PROBATOR (Opus, fresh-context) ran One Act /0's three floor rows green at authorized
counts (173/0 · 110 checks 6/6 cases + tooth · 3 diseases/3 controls) and mapped Sol's
six demonstrations: **1, 3, 4 (one-process-life ceiling), 6 SHOWN · 2 PARTIAL · 5
PARTIAL.** Binding consequences for THIS lane:

- **(a) World-scope absence looks on EVERY denied arm.** /0's capability-denied arms
  (B-L1/B-L2) asserted "no unauthorized transition" from cap2 journal standing alone —
  the look never reached the world. In /1, every denied/refused arm (capability-denied,
  blind-retry-refused, D1-refused) asserts world-scope absence: `world-ledger-count` = 0
  under that arm's request key AND whole-world digests (cells + ledger) byte-unchanged
  across the arm. The F2-style `:frontier` field is derived from class — it is NOT an
  independent witness; never count it as one.
- **(b) `world-cell-value` gets a positive control IN-LANE.** /0 used it only in the
  negative direction (one occurrence, `equal ""`); nothing in /0's own evidence shows it
  returning non-empty for a written cell. /1's settled arm reads its written cell back
  non-empty before any empty-cell check is trusted.
- **(c) The D1-refusal arm — /0's deferred debt, paid here.** One arm in which
  `authorize-effect-attempt` itself refuses (runtime boundary), asserted by condition
  type + named facet, with the world-scope absence checks of (a). This pays the
  ADOPTION-RECORD's "deferred outside /0" item without touching /0's vectors.
- **(d) Memory-Layer-/0 interface answer, informed:** /0 is a worked PATTERN, not a
  drivable interface (fixture/record constructors internal; `request-form` hard-codes one
  predicate shape; no normative export list). /1 SHOULD export a lane-local
  fixture-construction door for its own table IF it falls out cheaply; if it fights the
  T4-LAW attempt-name coupling, record the gap precisely instead — the RETURN must give
  Memory Layer /0 a concrete list either way.
- **(e) Owner-docket items observed, NOT repaired by this lane:** act0 `package.lisp:7`
  standing header stale-conservative since adoption; `verify-release.sh` carries both the
  pre-adoption candidate comment (~:104-112) and the ADOPTED seam row (~:228) in one
  file. The floor's own doctrine gates edits on a ruling; report, never patch.

*— folded in by the chair after PROBATOR's return, before any code existed.*
