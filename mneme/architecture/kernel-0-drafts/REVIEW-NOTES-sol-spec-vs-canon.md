# REVIEW NOTES — DRAFT-S (Sol Kernel /0 spec) vs. the governing canon

**Analyst:** WEAVER (Claude Opus 4.8, 1M context) — dual-trace lane, non-adjudicating
**Date:** 2026-07-18
**Subject:** `kernel-0-drafts/sol/LISP-PLUS-KERNEL-0-SPEC.md` (DRAFT-S, 2,212 lines) + `KERNEL-0-AUTHORING-RECEIPT.md`
**Governing canon (a difference from these is a DRAFT-S defect):**
- `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` (ADOPTED, governs) — cited as **A0.1 §n**
- `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md` incl. amendments A-1..A-4 + erratum E-1 — cited as **DEC**
- `AUDIT-architecture-0.1-conformance-2026-07-18.md` (CONCORDAT; 3 PARTIALs) — cited as **CONCORDAT**
**Standing:** trace material for the adjudicating chair (Fable). WEAVER trusts neither parent; findings are at
their true (mostly small) size. This document decides nothing.

**Method note (PLUMB):** every claimed embodiment was treated as unproven until the DRAFT-S text was located;
line numbers are given for every contested step. Where a sweep was not exhaustive it is marked *traced,
compressed*.

---

## HEADLINE (canon verdict recommendation): **FAITHFUL-WITH-REPAIR**

| Finding class | Count | Blocking? |
|---|---:|---|
| contradiction-with-governing-law | **0** | — |
| prohibited invention (kimi classification / A1 / concrete channel policy / sensitive-class / independence claim) | **0** | — |
| missing-specification (repairable, ≤ its own resolution level) | **4** | no |
| implementation-detail-correctly-delegated | **6** | no |
| recommendation-for-later-profile | **3** | no |
| reserved-for-stranger-audit | **2** | no |

DRAFT-S is a faithful and unusually complete transcription of A0.1: **zero contradictions, no prohibited
invention, all 18 A0.1 §12.1 kernel primitives present, the call-296 fixture byte-exact, kernel vocabulary
de-moustached, and every deferred-spec seam declared.** It earns **FAITHFUL-WITH-REPAIR** (not bare FAITHFUL)
only because **four minor primitives/protocols are referenced-but-under-specified relative to the spec's own
resolution level** — each fillable from A0.1 or from DRAFT-F, none forcing Codex into an un-derivable choice,
none contradicting law. It is not BLOCKED: nothing dead-ends in unspecified behavior; every gap has a named
source.

---

## Part 1 — Canon conformance

### 1.1 Contradictions with A0.1 / DEC / E-1 — **NONE FOUND**

Every load-bearing sealed decision is carried, and the two adversarial traps CONCORDAT flagged are clean in
DRAFT-S too:

| Sealed item | DRAFT-S location | Status |
|---|---|---|
| **A-4 name sealed** (Lisp+ = language; Mneme = memory-and-continuity layer) | header (l.4-5), §0 | carries the **sealed** state, no "name open" survives |
| **A-1 / L15 witness separation** (amended: "distinct witnessing mechanism"; journal is **default** not only witness; self-narrative not a witness) | §15.3 (l.1186-1199), §15.4 (l.1201-1205) | amended text — the superseded "only observer" phrasing is **absent** (grep: none) |
| **DK-3 restoration** (minter/mint-time-delegate only; new identity; receipt; revocation + unresolved-effect recheck; **equal-or-narrower scope**; refuse self-restoration) | §11.7 (l.850-868) | all seven steps present verbatim-in-substance |
| **DK-4 four axes, no scalar** | §9 (l.571-668), §7.5 (l.432-436) | matched; global scalar rejected at the constructor (§25.1 test 8, l.1825) |
| **DK-1 publication frontier** (commit = publication; policy informs / capability authorizes; private staging) | §17.2-17.5 (l.1295-1324) | matched |
| **DK-2 envelope ≠ subject; classify later** | §8.8 (l.542-554), §22.2 (l.1684-1688) | matched; factual classification deferred |

There is **no line in DRAFT-S that contradicts a governing clause.** (This is the load-bearing negative
result; per PLUMB it is stated as a conclusion of a section-by-section trace against every DK/D/L/A item,
*traced, compressed* on the D1–D10 batch which matches A0.1 §7/§9/§10 without divergence.)

### 1.2 Missing primitives (A0.1 §12.1–12.2) — **all 18 §12.1 primitives present; 1 §12.2 protocol under-specified**

All 18 A0.1 §12.1 kernel primitives resolve to a DRAFT-S section (spot-checked, *traced, compressed*): ordinary
eval §12.1; CD/0 boundary §2.1; principals/roles §5; process/transition §4,§13; op/seat/attempt §6;
supersession/reconciliation §14; manifestation algebra §8; four-axis outcome §7,§9; closed absence §8.7;
uncertain-effect §9.4/§10; capabilities/minting/revocation/restoration/defensive-scope §11; effect/frontier
§10; store/folds §13; claims/receipts §15; machine-config §16; adapter §18; inspection/export §21; typed
conditions §20.

The A0.1 §12.2 kernel-recognized protocols mostly resolve (located claims §15.1; transformation receipts §15.5;
machine-config §16; channel policies §17; store backends §13/§2.4) — **except the causal-claim protocol**, which
DRAFT-S names and constrains (§8.9, l.556-567 — a cause "MUST be represented as causal claims … not new
absence-state enum members") but does **not** give a construction operation or field shape, where A0.1 §6.9.2
does (`make-causal-claim :subject :predicate :evidence :origin :validation`). → **missing-specification (minor)**.

### 1.3 Under-specified primitives (referenced, below the spec's own resolution) — 4

1. **Causal-claim protocol** (above) — §8.9 forbids cause-as-enum but gives no operation/fields; A0.1 §6.9.2
   has them. DRAFT-F binds them (CAU-1/CAU-2). **missing-specification.**
2. **Uncertain-effect *record* as a structured value** — A0.1 §6.10 and §12.1(10) make "structured
   uncertain-effect values" a kernel primitive with an explicit field set incl. `:retry-policy
   :forbidden-without-reconciliation`. DRAFT-S distributes the *semantics* (§9.4 alternatives+evidence; §14.1
   `unsafe-retry`; §10 effect ops) but never enumerates the standalone record shape. DRAFT-F binds it (UNC-1).
   **missing-specification.**
3. **`reconstruct` / `fold-state` as named operations** — the forced-kill scenario needs them (see Part 4);
   DRAFT-S carries them as *obligations* (§13.7 fold, l.1077-1081), *events* (`:derived-view-recorded`,
   l.1030), *receipts* (§27.1), and *tests* (§25.5 #40, l.1869), but the §19 operation list (l.1378-1467) omits
   both. DRAFT-F names both as operations. **missing-specification (minor; a modeling choice — fold/reconstruct
   as store-protocol obligations, not §19 kernel ops — but the operation surface is left implicit).**
4. **Kernel-MUST-NOT-project-subject-from-envelope-bytes** — DRAFT-S has envelope≠subject (§8.8) and delegates
   the projection to the adapter (§27.2, l.1990), but never states the *prohibition* on the kernel deriving
   subject status itself. DRAFT-F MAN-2 hard-binds it. **missing-specification (seam-tightening; see Part 2).**

### 1.4 Semantic invention beyond the seal — **NONE material**

Every closed enum matches A0.1 verbatim: execution (§9.2 = A0.1 §6.8.1), effect (§9.4 = §6.8.3), interpretation
(§9.5 = §6.8.4), manifestation status (§8.2 = §6.7), absence states (§8.7 = §6.9.1). Non-verbatim additions are
all into **explicitly open** vocabularies and are therefore not inventions-against-seal:
- **Role vocabulary §5.2** adds `:restoration-delegate :adapter :store` beyond A0.1 §6.2 — A0.1's list is
  "include, without ontological privilege" (open) and §5.2 says "Libraries MAY add roles." →
  **implementation-detail-correctly-delegated.**
- **Event vocabulary §13.3** (21 event types) refines A0.1 §6.5's "minimal generic transition vocabulary
  *includes*" (open) — splits `EFFECT-UNCERTAIN`→`:effect-bounded`/`:effect-indeterminate`, renames
  `ACKNOWLEDGED`→`:request-acknowledged`, and does not carry a literal `DISPATCHED` (subsumed by
  `:frontier-crossed`). Authorial detailing inside a delegated space. → **implementation-detail-correctly-delegated**
  (and a substantial S-ONLY block — see Concordance).
- **Effect-class mandate §10.2** — DRAFT-S *requires* classifying each effect as one of A0.1 §8.1's six classes;
  A0.1 lists them descriptively. A tightening, not an invention.

### 1.5 Language-A moustaches in kernel vocabulary — **NONE (clean)**

- `census`: 4 hits, all library/specimen (§26.2 l.1938, §26.3 l.1955 "derived folds, not censuses"). Kernel uses
  "fold"/"derived view."
- `:score-under-key` / `:subject-exposure`: **absent** from kernel effect tags; §26.3 (l.1955) explicitly
  "generic secret opening, not Cβ scoring; generic epistemic exposure, not Language-A subject exposure."
- Effect tags §10.1 (l.679-686) = A0.1 §8.1 generic set exactly.
- "kimi" appears only to name what is *deferred* (§0.3 l.63, §22.2, §26.2). → **clean.**

### 1.6 Prohibited inventions — **NONE (§0.4 + §28 hold the line)**

§0.4 (l.69-84) explicitly does not authorize implementation, live calls, spend, secret-open, publication, kimi
classification, concrete channel-policy adoption, custody service, or independence claims. §28 (l.1999-2022)
lists 12 stop-conditions covering the same. The authoring receipt (l.44-54) restates the deliberate
non-actions. → matches every A0.1 §18 / §21 non-goal and reservation.

---

## Part 2 — Seam inspection (Kernel /0 vs. deferred Process-Journal-/0 and Adapter-Protocol-/0)

**Verdict: CLEAN.** The kernel constrains the *event model and fold* and defers *bytes/framing/layout*, exactly
as the boundary requires. No byte-level rule leaks into the kernel.

- **Journal seam explicitly declared:** §2.4 (l.174-179) "The exact journal grammar, framing, durability
  mechanics, prefix validation algorithm, merge format, and filesystem layout are delegated … Kernel /0 MUST
  NOT assume an unspecified journal byte layout." §13.1 (l.970-972) "exact S-expression grammar and byte
  framing are deferred … the semantic fields below are normative." §27.1 (l.1965-1977) enumerates the delegated
  exactness.
- **What the kernel *does* constrain (correctly):** required event fields (§13.2), event vocabulary (§13.3),
  transition legality (§13.5), fold-over-longest-prefix-valid (§13.7), torn-tail semantics (§13.8). This is
  *more* event-model detail than DRAFT-F carries — appropriate, since the kernel owns the event model.
- **Adapter seam explicitly declared:** §18 minimum protocol + §27.2 defers signatures, streaming callback,
  request-identity timing, idempotency, ack, cancellation/reconciliation, usage/cost, and the
  envelope→subject-manifestation projection.

**One softness (not a leak):** the *prohibition* that the kernel MUST NOT itself project the subject
manifestation from envelope bytes (DRAFT-F MAN-2) is only **implicit** in DRAFT-S — it is achieved by assigning
the projection to the adapter (§27.2) rather than by forbidding the kernel. This is the same finding as 1.3(4);
it is a seam that would be **harder** if the prohibition were stated. → **recommendation-for-later-profile /
missing-specification (minor).** No events are under-constrained; no bytes are leaked in.

---

## Part 3 — Call-296 fixture verification

**Verdict: EXACT MATCH to A0.1 §15.2 as corrected by E-1. Not the corrected-away form.**

DRAFT-S §22 (l.1653-1671), quoted verbatim:

```lisp
(:execution
  (:value :indeterminate
   :determinacy :indeterminate))

(:manifestation
  (:value (:absent :state :absent-after-completion)
   :determinacy :bounded
   :evidence (...)))

(:effects
  (:value :bounded
   :determinacy :bounded
   :alternatives (:billed :not-billed)))

(:interpretation
  (:value :not-applicable
   :determinacy :determinate))
```

This is byte-for-byte A0.1 §15.2 (arch l.1363-1382). The load-bearing axis — **manifestation `:absent`
(state `:absent-after-completion`) with determinacy `:bounded`** — is the *corrected* reading E-1 (DEC
l.188-200) installed, **NOT** the "determinate-absent" the decisions-record's own paraphrase wrongly carried and
E-1 struck. DRAFT-S §22 opens by citing E-1 as controlling (l.1649). This is the one determinacy-label that
CONCORDAT marked PARTIAL at the A0.1 level; DRAFT-S inherits A0.1's (correct) choice, so the PARTIAL does not
propagate here. **Conformance CONFIRMED — not a defect.**

*Observation (canon-level, reserved-for-stranger-audit, NOT a DRAFT-S defect):* the fixture pairs manifestation
state `:absent-after-completion` (which reads "completion happened") with execution value `:indeterminate`
(which reads "we can't classify whether it completed"). The tension is inherited verbatim from A0.1 §15.2; a
stranger auditing the algebra may wish to ask whether `:absent-after-completion` is the right *state* when
execution is `:indeterminate`. DRAFT-S faithfully transcribes canon, so it is correct to defer this upward.

---

## Part 4 — Forced-kill walk (A0.1 §15.1, walked as a fresh executor)

Every one of the 15 kill-scenario steps has a defined recovery/refusal semantics in DRAFT-S. No path dead-ends
in unspecified behavior.

| A0.1 §15.1 step | DRAFT-S mechanism | Defined? |
|---|---|---|
| 1 begin seats | `reserve-seat` §19.2; `:seat-reserved` §13.3 | ✓ |
| 2 complete some attempts | `:attempt-completed` §13.3; §23.3 | ✓ |
| 3 persist partial manifestation | `record-partial-manifestation` §19.4; `:present-partial` §8.6 (l.507-519) | ✓ |
| 4 cross simulated frontier | `cross-frontier` §19.3; `:frontier-crossed` §13.3 | ✓ |
| 5 kill before settlement record | torn-tail path §13.8 (l.1083-1092) | ✓ |
| 6 torn/incomplete tail (neg fixture) | §13.8 "make torn record visible"; `journal-torn-tail` §20.6 (non-fatal) | ✓ |
| 7 restart | `resume-process` §19.1 | ✓ |
| 8 fold longest prefix-valid | §13.7 (l.1077-1081) | ✓ |
| 9 identify one uncertain effect | `:effect-bounded` §13.3; `unresolved-irreversible-effect` §20.4 | ✓ |
| 10 refuse blind retry | §14.1 (l.1098-1103) `unsafe-retry` | ✓ |
| 11 restore via minter / mint-time delegate | §11.7 (l.850-868); `capability-self-restoration-forbidden` §20.3 | ✓ |
| 12 resume untouched seats | §6.2 occupancy derived; untouched seat has no attempt → no §13.5 bar | ✓ (implied) |
| 13 supersede uncertain attempt under auth | §14.3; `supersession-unauthorized` §20.4 | ✓ |
| 14 reconstruct derived view | `:derived-view-recorded` §13.3; §23.9; §15.7 origin `:reconstructed`; **but no `reconstruct` op in §19** | ✓ semantics; **operation surface implicit** |
| 15 prove finalizer adds no unique primary fact | §13.7 no-cache-outranks-fold; §25.5 #40 + §25.8 "finalizer-only primary fact" negative control | ✓ via test |

**Two seams surfaced by the walk (both = 1.3 findings, both minor):**
- Step 14 needs a `reconstruct` operation the §19 list omits (present as event + receipt + test).
- Step 15's finalizer law (A0.1 L9 "a finalizer adds organization, not unique primary facts") is enforced by
  the **test suite** (§25.8) rather than stated as a body-normative MUST. Since §25 is normative for
  conformance (§3.5), the guarantee holds — but it would be more legible as a stated law. →
  **recommendation-for-later-profile.**

**Walk verdict:** the recipe executes forward without hitting undefined behavior. The two seams are
operation-surface/legibility gaps, not dead-ends.

---

## Part 5 — L17 from the user chair (shortest lawful path vs. shortest unforbidden bypass)

**The public API shape (as written):** the default consequential invocation is a single form (§19.8, l.1453-1466)
that MUST combine attempt allocation/validation + capability check + effect preparation + journal append +
adapter dispatch + partial-manifestation recording + effect-settlement recording + structured-outcome
production. Handling is via `with-outcome`/`match-outcome` as **kernel-surface** operations (§19.6, l.1432-1439;
§24.4 "Safe pattern matching MUST be direct and composable").

**Shortest lawful invocation-and-handling pattern the spec permits** (exact signatures are deferred, §19
l.1380 "names are proposals"; shape reconstructed from §19.8 + §24.1):

```lisp
(with-outcome (o (invoke machine subject :capability cap :seat s :attempt a :sink store))
  ((:execution :completed) (:manifestation (:present m)) (interpret m under proc))
  ((:execution :completed) (:manifestation (:absent :absent-after-completion)) (record-absence o))
  ((:effects (:bounded alts)) (reconcile-before-retry o)))
```

— one consequential form, one outcome-match form. That is the floor: §24.1 (l.1770-1778) makes attempt
identity, capability check, effect recording, journaling, and outcome-context all *automatic* in the shortest
supported path.

**Shortest bypass the spec fails to forbid:** searched (*traced, compressed*). DRAFT-S **forbids every
shorter *supported* path**: §24.2 (l.1780-1789) "MUST NOT expose a supported convenience path that is shorter
while silently omitting" the checks; §24.4 forbids the bare-answer accessor; §20.8 provides `outcome-context-discard`
and `unsafe-host-escape`; §24.3 permits raw escape **only** if `unsafe-*`/`raw-*` named, outside the conforming
surface, and forfeiting guarantees. **No shorter *supported/conforming* bypass survives the text.**

**Does the inequality (lawful ≤ shortest unlawful) hold AS WRITTEN?** — **Yes, as a mandated-and-tested
requirement; not yet as a demonstrated measurement.** The honest limit for the chair: DRAFT-S *requires* the
inequality (§24.2), *tests* it (§25.7 #55-56, §25.8 "shorter unsafe convenience accessor" negative control), and
*lints* the bypass namespaces (§24.3) — but because exact signatures are deferred (§19), it does not and cannot
*exhibit a concrete form-count* proving the inequality at spec stage. This exactly mirrors A0.1 §16.1 and
DRAFT-F FIX-3, which also make L17 a tested criterion rather than a spec-stage demonstration. The inequality
holds **by construction of the requirement**; its numeric verification is deferred to the implemented API. No
unforbidden bypass was found in the text.

---

## Part 6 — Verdict material (every finding classified; contradictions get exact quotes)

**contradiction-with-governing-law (exact quote + line required):** **NONE.** (No line to quote — the negative
result is the finding.)

**missing-specification (repairable; source named):**
1. Causal-claim protocol/operation absent — §8.9 (l.556-567); fill from A0.1 §6.9.2 or DRAFT-F CAU-1/2.
2. Uncertain-effect *record* shape not enumerated — §9.4 (l.622-639); fill from A0.1 §6.10 or DRAFT-F UNC-1.
3. `reconstruct`/`fold-state` not in §19 operation list — §19 (l.1378-1467); present as obligation/event/test.
4. Kernel-MUST-NOT-project-subject-from-envelope prohibition absent — §8.8 (l.542-554); DRAFT-F MAN-2.

**implementation-detail-correctly-delegated:** role-vocab additions §5.2; event-vocab detailing §13.3; journal
byte grammar/framing/layout §2.4/§27.1; adapter signatures/wire §27.2; durability enum placement (§13.2
`:durability-claim` field, values delegated §27.1); merge format §27.1.

**recommendation-for-later-profile:**
1. Surface the finalizer law (A0.1 L9) and the incremental-durability law (A0.1 L8) as body-normative MUSTs, not
   test-only (§25.8) / structurally-implicit (append-only model) guarantees.
2. State the interpretation-requires-present-manifestation invariant (DRAFT-F OUT-5) — §9.6 (l.657-667) currently
   leaves it looser than DRAFT-F.
3. Restate the wall-clock-timestamps-are-not-ordering-authority guard (A0.1 §9.4) — DRAFT-S orders by
   predecessor-linkage (§13.2) which structurally excludes it, but the explicit guard is absent.

**reserved-for-stranger-audit:**
1. The `:absent-after-completion` / execution-`:indeterminate` tension in the call-296 fixture (canon-level,
   inherited verbatim from A0.1 §15.2 — DRAFT-S is faithful; the question is for whoever audits the algebra).
2. Independent primitive-minimality — DRAFT-S §0.4/§28 correctly refuses to claim it; reserved for the stranger
   to the Language-A arc (A0.1 §20/§21.6).

**Positive notes for the chair (DRAFT-S strengths over the floor):** its §23 terminal fixtures carry determinacy
on **every** axis (l.1696-1762) — closing exactly the "determinacy not uniformly annotated" NOTE CONCORDAT
raised against A0.1 §17; its §25 adversarial suite (56 tests + 10 negative controls) is materially more complete
than the floor; and its §26.3 moustache-prohibition is explicit and clean.

---

## Deposition — what these notes do NOT establish

- Not whether DRAFT-S is a *good* kernel spec beyond canon-fidelity — outside this trace's jurisdiction.
- Not that the primitive set is *complete or minimal* — DRAFT-S itself reserves that (§0.4, §28); only that the
  18 A0.1 §12.1 primitives land and no prohibited thing was invented.
- The D1–D10 conformance and the 18-primitive presence sweep were **spot-checked, not exhaustively line-matched
  clause-by-clause** — *traced, compressed*; nothing sampled suggested a hidden contradiction.
- WEAVER is a fresh-context Opus reading committed files; this is a document-vs-document trace with no sibling
  under test, so no shared-root corroboration hazard applies to the trace itself. (It **does** apply between the
  two *drafts* — see the Concordance's opening caveat: both are Opus-lineage off one canon, so their agreement
  is expected and proves little; the divergences are the information.)

— WEAVER (Claude Opus 4.8, 1M context), 2026-07-18
