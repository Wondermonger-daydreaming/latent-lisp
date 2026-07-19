# BREAKPOINT — hostile mechanics review of Adapter Protocol /0

**Reviewer:** BREAKPOINT (hostile, re-derive-don't-trust)
**Model:** Claude Opus 4.8 (1M)
**Date:** 2026-07-18
**Target:** `experiments/latent-lisp/mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0/`
**Spec:** `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` (1,422 lines)
**Governing laws re-read:** Architecture 0.1 L15–L18 (§19, lines 1553–1567); Kernel /0 §8.1–8.9 (lines 460–605); PJ0 ordering (spec §21).
**Assigned surface (Sol's list, first half):** 1 identity-timing · 2 acknowledgment ladder · 3 stream durability · 4 cancellation · 5 reconciliation completeness.

**Baseline (reproduced, NOT re-litigated):** `validate_ap0_vectors.py` → 64/64 PASS; `run_mutation_suite.py` → 12/12 KILLED. My attack is on **what passing proves**, not that it passes.

**Attack artifacts:** `attacks-breakpoint/attack_breakpoint.py` (+ `attack-output.txt`). The harness imports the packet's own `check_case`/`load` by absolute path (packet unmodified) and feeds it hand-crafted counterexample records. All five were **ACCEPTED** by the packet's own validator.

---

## The structural fact under every finding

Two facts about the apparatus set the frame:

1. **The vector schema has no time.** Every fixture is one flat `rec` with scalar fields (`ack-class`, `cancel-class`, `result`, `domain-complete`, `settles-no-effect`, `manifestation-status`, `chunks`, `terminal`). There is **no representation of a history** — no sequence of events, no interleaving, no "then." Every law in the spec that is about *ordering, racing, duplication, or interleaving of records over time* (the acknowledgment ladder, stream sequence combinations, cancellation-vs-terminal races, the W1–W4 kill placements) is **structurally unrepresentable** in the fixtures. The greens cannot exercise those laws because the record model cannot express them.

2. **`check_case` is one positive predicate per family.** The independent validator (correctly declared "self-consistency certification," Appendix E) tests ~20 flat-field rules total. For each family it rejects exactly one obviously-bad flag combination. **Every conclusion in the record is self-declared** — `settles-no-effect`, `cancel-class :provider-settled`, `domain-complete`, `manifestation-status` are written *into* the record and the validator only checks that a specific honest-bad pairing is absent. A record that reaches the same illicit conclusion under an **honestly-labelled** field is caught; a record that reaches it under a **differently-labelled** field is accepted.

The negative controls all live in the first category. The crack the author's tests walk around is the second.

---

## FINDING 1 — BLOCKER — Effect-collapsing settlements are permitted on self-testimony, with no L15 witness gate

**Governing law violated:** Architecture 0.1 **L15 — Witness separation** (line 1555): *"A process's unaided account of its own history is asserted testimony. Observational standing requires a distinct, inspectable witnessing mechanism."*

AP0 contains three conclusions that **collapse uncertain external effect into a settled verdict**. Each is permitted by the spec text on the basis of a **self-declared field with no required witness**:

### 1a. Reconciliation `:not-found` → settled no-effect (AP-REC-1, line 836)

> **AP-REC-1.** `:not-found` settles no-effect only where the queried domain is **declared complete and authoritative** for the relevant request identity.

"Declared" — by whom, with what standing? The spec never says. The reconciliation record (§18, lines 823–834) binds a *"query-domain completeness claim"* — a **claim**, i.e. self-testimony. Nothing requires that claim to carry L15 observational standing, name an authority, or reference a boundary-captured witness. **A conforming adapter writes `domain-complete #t` and settles a real, possibly-billed, possibly-executed effect as "no effect."** This is exactly the counterfeit settlement L15 exists to forbid.

Attack `A1` (`ATK-REC-LAUNDER`): `result :not-found`, `domain-complete #t`, `settles-no-effect #t`, no witness field → **ACCEPTED**. The only reconciliation record the validator rejects (BAD-REC-01) is the one that *honestly* sets `domain-complete #f`. Flip the self-declared flag to `#t` and the identical no-effect settlement passes.

### 1b. Cancellation `cancel-class :provider-settled` (§17, lines 774, 788)

The cancellation record binds *"provider settlement if known"* — self-declared. **AP-CAN-1** ("Local socket closure is not provider cancellation") is a semantic truth but **gates nothing**: no law says *"a `:provider-settled` cancellation record MUST carry boundary-captured provider evidence distinct from the adapter's own narrative (L15)."*

Attack `A3` (`ATK-CAN-RELABEL`): a bare socket closure labelled `cancel-class :provider-settled`, `billing unknown`, no witness → **ACCEPTED**. Companion: **BAD-CAN-01 with its class relabelled `socket-closed` → `provider-settled` flips from REJECT to ACCEPT** with no other change. The negative control catches only the adapter that *admits* it merely closed a socket; the adapter that mislabels the same reality as provider-settled is conforming.

### 1c. (corroborating) Emitting an ack-class the adapter cannot witness

**AP-ACK-2** (line 468) requires an adapter to *declare* which distinctions it can witness — but **no law forbids emitting an ack-class outside the declared witnessable set.** An adapter that declares `acknowledgment-semantics :unknown` may still emit `:provider-terminal` acks. Same root: a strong verdict minted from nothing, the `adapter-truth-minting` / `adapter-witness-boundary-missing` conditions never triggered.

### Why the fold does not save this

**AP-CRASH-1** (resolvedness is fold-derived; no mutable `resolved` flag) is real protection against *storing* a forged resolution — but `settles-no-effect`, `cancel-class`, and `domain-complete` are **inputs to the fold**. A deterministic fold over poisoned inputs deterministically computes "no effect." The no-mutable-flag design blocks the wrong attack.

### The tell that this is a spec defect, not just a shallow validator

The vocabulary for the fix **already exists and is never wired to a law**: conditions `adapter-witness-boundary-missing` and `adapter-truth-minting` are defined (§22, lines 1021–1022) but **no normative requirement anywhere triggers them** for reconciliation completeness, cancellation settlement, or ack emission. The spec built the alarm and never connected it.

**Repair (spec text):** Add a witness-separation gate, e.g.:

- **AP-REC-1 addendum:** *"A domain-completeness claim carries settling force only when it has L15 observational standing: a distinct, inspectable witnessing mechanism (a boundary-captured authoritative enumeration receipt), not the adapter's unaided narrative. A self-asserted completeness claim MUST signal `adapter-witness-boundary-missing` and MUST NOT settle no-effect."*
- **New AP-CAN law:** *"`cancel-class :provider-settled` MUST be backed by a boundary-captured provider settlement record (L15). A `:provider-settled` label resting on adapter self-report is `adapter-truth-minting`."*
- **New AP-ACK law:** *"An adapter MUST NOT emit an acknowledgment class outside the set its descriptor declares witnessable; doing so signals `adapter-witness-boundary-missing`."*
- **Fixtures:** add negative controls in the second category — the *relabelled* forgeries above — to `vectors/adversarial/`.

---

## FINDING 2 — REPAIR-NEEDED — AP-ID-3 is a blocklist where an allowlist is required; a conforming adapter can invent a provider request identity

**AP-ID-3** (line 306):

> A provider request identity MUST NOT be invented from **timestamps, payload hashes, local identifiers, billing amounts, or response content.**

This enumerates **five forbidden sources**. It is under-inclusive. An adapter that mints a provider-request-id from a **monotonic counter**, a **fresh UUID**, or the **route-id** violates the *intent* (the id must originate from provider testimony — cf. §2 non-equivalence `provider testimony ≠ adapter observation`, line 132) while satisfying the *letter* (none of those is a timestamp/hash/local-id/billing/content).

Attack `A2` (`ATK-RID-COUNTER`): `provider-request-timing :acknowledgment`, `provider-request-id "adapter-counter-000042"` → **ACCEPTED**. The validator's only RID rule fires solely for `timing == unavailable` (line 94); the invented-id negative control BAD-RID-01 *also* uses `timing unavailable`. **Every populated timing class (pre-dispatch, acknowledgment, response-header, terminal-envelope, reconciliation-only) accepts a fabricated id.**

**Repair (spec text):** Restate AP-ID-3 as a provenance *allowlist*: *"A provider request identity MUST originate from identified provider testimony (an acknowledgment field, response header, or terminal envelope field named in the descriptor's request-identity policy). Any id not so sourced is invented and MUST signal `provider-request-id-unavailable` / `adapter-truth-minting`."* Add a fixture: a populated non-`unavailable` timing class carrying a counter/UUID id, expected REJECT.

---

## FINDING 3 — REPAIR-NEEDED — No-effect may be settled for a request whose relevant provider request identity is unavailable

**AP-REC-1** requires the domain be authoritative *"for the relevant request identity."* **AP-ID-4** (line 308) permits that identity to be permanently absent: *"An unavailable provider request identity remains unavailable and **weakens** reconciliation claims."* "Weakens" is prose, not a gate. Nothing hard-blocks a `:not-found` + `domain-complete #t` + `settles-no-effect #t` record when `provider-request-timing :unavailable` and `provider-request-id #u`.

The result is incoherent: the adapter certifies a domain "authoritative **for the relevant request identity**" while holding **no such identity** — it cannot even name the row it claims is absent. Attack `A1` deliberately sets `timing unavailable`, `provider-request-id #u` alongside the settlement and is **ACCEPTED**.

**Repair (spec text):** Promote AP-ID-4 to a hard interaction gate: *"Where the relevant provider request identity is unavailable, reconciliation `:not-found` MUST NOT settle no-effect regardless of domain-completeness; the strongest available result is `:ambiguous` with retained alternatives."* This is a distinct fix from Finding 1 (there: *who* asserts completeness; here: *keying* the completeness claim to a nonexistent identity).

---

## FINDING 4 — REPAIR-NEEDED — §10.5's "delivery-before-journal MUST be mechanically distinguishable in crash fixtures" is unmet; no negative control exists

**§10.5** (line 546): *"An adapter unable to guarantee [journal-before-delivery] order MUST declare the loss window and reduced standing. **Delivery-before-journal MUST be mechanically distinguishable in crash fixtures.**"* **§24.2** requires every major family to contain at least one planted defect the suite kills.

The stream vectors carry a `journal-before-delivery` field (STR-01/02: `#t`). But:

- **The validator never reads it** (`check_case` stream branch, lines 95–100, reads adapter-identity, stream-relation, gap-hidden, chunks, terminal, manifestation-status — not `journal-before-delivery`). The field is decorative.
- **No fixture sets it `#f`**, and **no crash-window (W1–W4) fixture varies journal-vs-delivery order at all** — WIN-1..4 carry only a `window` label and an `expected-fold` label; there is no field encoding *which order the kill interrupted*.
- **No negative control** plants a delivery-before-journal history for stream durability — the §24.2 obligation for this family is unsatisfied.

Attack `A4` (`ATK-STR-DBJ`): a clean terminal stream with `journal-before-delivery #f` → **ACCEPTED**, byte-for-byte as lawful as STR-01. The reference-order guarantee (§10.5, W2 row of the §11 table) has **zero mechanical teeth**: a weaker persistence order masquerades as the reference order with no fixture able to tell them apart — precisely the surface-3 attack ("whether a weaker persistence order can masquerade as the reference order in records").

**Repair:** (a) add a normative record field to the stream/crash schema encoding observed journal-vs-delivery order per chunk (e.g. `:persistence-order :journal-before-delivery | :delivery-before-journal` with a required loss-window and reduced-standing declaration when the latter); (b) add a checker rule that an undeclared delivery-before-journal stream REJECTs; (c) add the planted §24.2 negative control.

---

## FINDING 5 — REPAIR-NEEDED — `:absent-after-completion` is used as a manifestation *status*, which the Kernel's closed status algebra forbids

**Authority rule §0.2** (line 44): *"Where this candidate conflicts with an adopted predecessor, the predecessor governs and the difference is a defect here."*

**Kernel §8.2** (lines 479–491): the manifestation **status** set is *closed* — `{:present, :present-empty, :present-invalid, :present-partial, :absent, :withheld, :redacted}`. `:absent-after-completion` is **not a status**; Kernel §8.7 defines it as a no-visible-payload **state** that pairs with status `:absent` (line 554: *"status `:absent` permits ... `:absent-after-completion`"*).

AP0 places `:absent-after-completion` in a **status** slot:
- §14 absence-row field is `:kernel-manifestation-status`; the required default mapping (line 676) is *"missing or explicit no-manifestation marker → `:absent-after-completion`."*
- Appendix C (lines 1275–1276) column header is **"Default status"** → `:absent-after-completion`.
- The validator encodes the conflation directly: `manifestation-status == 'absent-after-completion'` (line 100).

Attack `A5` (`ATK-ABS-STATE-AS-STATUS`): `shape missing-subject-field`, `manifestation-status "absent-after-completion"` → **ACCEPTED** — a status value the Kernel's closed algebra rejects. **§24.3** promises the joint run rejects a structurally-valid projection that violates the Kernel outcome algebra, but **no joint run exists** (only the structural AP0 validator ships), so the Kernel-illegal status sails through.

Charitable reading: the authors *meant* the (status `:absent`, state `:absent-after-completion`) pair and mislabelled the column — which is why this is REPAIR-NEEDED, not BLOCKER. Either way it is a defect by §0.2.

**Repair:** In §14, §Appendix C, and the absence-row schema, split into the Kernel's two fields: `:kernel-manifestation-status :absent` **and** `:no-payload-state :absent-after-completion`. Never carry a §8.7 state in a §8.2 status field.

---

## Surfaces that HELD (results, not disappointments)

**Surface 2 — the acknowledgment ladder is sound against counterfeit-settlement-by-reordering.** I tried to force a contradiction with out-of-order (terminal-before-queued), duplicate, and unknown-request-id acks. It holds, and holds for a real reason: **every non-promotion law in §9 (lines 458–464) is negative** — each is "X does not prove Y," never "Y implies X." No ack class *promotes* to a stronger one, so an out-of-order or duplicate or spurious ack cannot manufacture a settlement it didn't already carry. Combined with **AP-CRASH-1** (resolvedness is fold-derived; no mutable resolved flag), a forged terminal-ack referencing a fabricated local-request-id cannot flip any stored resolution. The ladder's *ordering* is genuinely not load-bearing for safety — a good design property. (Two residual NOTES below sit adjacent to it.)

**Surface 4 — cancellation-cannot-counterfeit-no-effect largely holds where labels are honest.** AP-CAN-3/4/5 (partials survive, bounded standing, cancelled-yet-manifested) are internally consistent and correctly refuse to let cancellation erase a partial or claim absence-of-billing. The one crack is Finding 1b: the *label* `:provider-settled` is ungated. Cancellation racing the terminal envelope produces no contradiction the spec permits to settle falsely — the residual-effect and manifestation-standing fields carry the uncertainty forward correctly.

---

## NOTES (real but sub-repair)

- **N1 — `:provider-terminal` settlement is "effect-specific" (Appendix A, line 1250) with no defined function.** The one ack class that *can* settle points at an undefined settlement determination. Not exploitable on its own (nothing settles from it directly), but it is an unclosed reference; name the Kernel law that maps (terminal ack + effect kind) → settlement, or say explicitly the fold owns it and the ack contributes nothing.

- **N2 — AP-ID-5 (`provider-request-identity-conflict`) has no defined comparison scope.** The rule (line 310) names the conflict but no law requires reconciliation's learned provider-request-id to be cross-checked against the dispatch record's. Because **AP-REC-3** forbids rewriting the dispatch record, two *different* provider-request-ids for one attempt can coexist silently across the dispatch and reconciliation records and **never trigger the conflict** — "a provider id arriving at two different times produces indistinguishable records" (the surface-1 attack), because nothing compares them. Add: *"On learning a provider request identity at a later timing class, the adapter MUST compare it to any previously recorded id for the same attempt and signal `provider-request-identity-conflict` on inequality."*

- **N3 — the four-valued capability standing and the emitted ack-class are unlinked** (see 1c). Filed under Finding 1; noted here for the identity/capability surface.

---

## Verdict

| Severity | Count |
|---|---|
| BLOCKER | 1 |
| REPAIR-NEEDED | 4 |
| NOTE | 3 |

The packet's **evidence discipline is genuinely strong** where it deals in *negatives-that-don't-promote* (the ack ladder, partial preservation, the no-mutable-resolved-flag fold). It is **weak wherever a strong verdict is minted from a self-declared field** — reconciliation no-effect, provider-settled cancellation, ack emission — because L15 witness separation, though named once (AP-JRN-1) and equipped with two conditions (`adapter-witness-boundary-missing`, `adapter-truth-minting`), is **never wired to a triggering requirement**. Every negative control in the packet catches the *honestly-labelled* forgery; none catches the *relabelled* one. That gap is the crack the tests walk around, and it is closable with the four spec-text additions above plus the corresponding second-category adversarial fixtures.

*Attack scripts and raw output: `notes/ap0/attacks-breakpoint/`. Packet unmodified; all writes outside the mirrored tree.*
