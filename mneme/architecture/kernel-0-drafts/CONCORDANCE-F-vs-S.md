# CONCORDANCE — DRAFT-F (Fable) vs. DRAFT-S (Sol), clause by clause

**Analyst:** WEAVER (Claude Opus 4.8, 1M context) — dual-trace lane, non-adjudicating
**Date:** 2026-07-18
**Parents:**
- **DRAFT-F:** `LISP-PLUS-KERNEL-0-SPEC-DRAFT-F.md` (~330 lines, stable requirement IDs) — cited **F §n / ID**
- **DRAFT-S:** `kernel-0-drafts/sol/LISP-PLUS-KERNEL-0-SPEC.md` (2,212 lines) — cited **S §n (line)**
**Governing canon:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` (**A0.1**) + decisions/E-1.
**Standing:** trace material for the adjudicating chair (Fable). Dispositions are **WEAVER's proposals only,
clearly marked**; the chair decides. This document decides nothing.

**Load-bearing caveat (shared root):** both parents are Opus-lineage minds writing blind off the *same* adopted
A0.1. **Their agreement is expected and proves little** — it measures the corpus attractor, not the fact of the
matter. The information is in the **F-STRONGER / S-STRONGER items, the one-sided content, and (were there any)
the CONFLICTS.** Read the AGREE rows as "no divergence to adjudicate," not as "two witnesses confirm."

**Verdict legend:** AGREE (semantically equivalent) · S-STRONGER (S binds detail beyond F) · F-STRONGER (F binds
what S leaves loose) · CONFLICT (incompatible — cannot both be satisfied; quote both) · F-ONLY (absent from S).

---

## Part A — Every DRAFT-F requirement ID traced into DRAFT-S (54 IDs)

| F ID | F requirement (gist) | DRAFT-S correspondent | Verdict | Note |
|---|---|---|---|---|
| **K-1** | implement kernel-primitive/protocol only; nothing library | §1, §26.1-26.3 (l.1912-1955) | AGREE | |
| **K-2** | conformance = fixtures; negative controls MUST fire | §25, esp §25.8 (l.1893-1908); §3.5 | AGREE | |
| **K-3** | no live provider; fake adapter is reference machine | §18.3 (l.1354-1370); §0.4 | AGREE | |
| **HOST-1** | CL host; ephemeral values free | §2.3 (l.156-170), §2.1 | AGREE | |
| **HOST-2** | durable boundary → CD/0; implicit coercion signals condition | §2.1 (l.138) `noncanonical-durable-value` | AGREE | condition-name diverges (F `canonical-boundary-violation`) — reconcilable |
| **HOST-3** | MUST NOT rely on host hash/float/sxhash/gensym for durable identity | §4.1 (l.262), §2.3 (l.170) | AGREE | F names float/hash-order explicitly; same intent |
| **ID-1** | durable identities **store-issued**, restart-stable; gensym MUST NOT cross | §4.1 (l.254-264) | **F-STRONGER** | ⚠ **F prohibits what S permits** — see Part C.1 (closest thing to a conflict; do NOT reflexively adopt-F) |
| **ID-2** | identity CD/0-representable; carries domain; cross-domain collision = type error | §4.1, §4.2 (l.267-281), §6.6 (l.386-393) | AGREE | |
| **ID-3** | claim identity = LCI/0's; runtime location = journal coordinate; no parallel scheme | §2.2 (l.140-155), §15.1 | **F-STRONGER** | F pins the runtime-claim location scheme; S leaves it to the LCI/0 library |
| **OUT-1** | exactly 4 axes `(:value :determinacy)`; no outcome-level scalar (unconstructable) | §9.1 (l.579-591), §7 (l.396-436), §7.5, §25.1#8 | AGREE | both make the scalar unconstructable |
| **OUT-2** | execution enum; constructor rejects `:refused`+`:post-frontier` | §9.2 (l.596-612) rules 1-2 | AGREE | S states the rule; F states constructor-locus — equivalent |
| **OUT-3** | bounded/indeterminate effect MUST reference an **uncertain-effect record**; else `unstructured-uncertainty` | §9.4 (l.622-639) alternatives+evidence inline | **F-STRONGER** | **most consequential divergence — see Part C.2**; S has no such record/condition |
| **OUT-4** | non-`:not-*` interpretation MUST name procedure | §9.5 (l.640-654) | AGREE | verbatim intent |
| **OUT-5** | kernel-checked invariants incl. accepted/rejected ⇒ present/present-empty | §8.3, §23.1; §9.6 looser | **F-STRONGER** | S omits the interpretation-requires-present invariant |
| **OUT-6** | outcome references attempt + machine-config id | §9.1 (l.583-585) | AGREE | |
| **MAN-1** | status algebra verbatim; 6 rules; present*⇒payload; present-invalid names parser | §8.2-8.5 (l.459-505) | AGREE | |
| **MAN-2** | envelope≠subject; adapter returns both; **kernel MUST NOT project subject from envelope bytes** | §8.8 (l.542-554), §27.2 (l.1990) | **F-STRONGER** | S delegates projection to adapter but omits the kernel prohibition |
| **MAN-3** | absence states verbatim; causal claims by reference; no cause-arg on the state | §8.7 (l.522-538), §8.9 (l.556-567) | AGREE | |
| **CAU-1** | causal-claim fields: subject/predicate/evidence/origin/validation; MAY be `:unestablished` | §8.9 (concept only, no fields) | **F-STRONGER** | S under-specifies the causal-claim protocol (Review-Notes 1.3-1) |
| **CAU-2** | revising a causal claim MUST NOT alter manifestation state/fold/census | — (not stated in S) | **F-STRONGER** | A0.1 §6.9.2 has it; S omits the revision-invariance |
| **UNC-1** | uncertain-effect fields + default `:forbidden-without-reconciliation` + refuse dispatch into occupied seat | §14.1 (l.1098-1103), §6.6; **record fields absent** | **F-STRONGER** | refusal AGREES; record shape is F-STRONGER |
| **UNC-2** | resolution only by reconciliation-with-evidence or authorized supersession; never timeout/default | §14.1, §14.2 (l.1104-1118), §14.4 | AGREE | |
| **ATT-1** | five identities distinct kernel types; attempt binds A0.1 §6.6 minimum | §6.1-6.5 (l.336-393), §6.3 | AGREE | |
| **ATT-2** | seat occupancy derived; no mutable flag | §6.2 (l.352-354) | AGREE | near-verbatim |
| **ATT-3** | supersession carries 7 elements; append-only; fresh-exposure not marked as continuation | §14.3 (l.1120-1132) (8 elements), §13.5, §6.5 | AGREE | S enumerates **more** elements (S-leaning) |
| **ATT-4** | uncertain predecessor stays uncertain after supersession | §14.4 (l.1134-1138) | AGREE | verbatim intent |
| **CAP-1** | capabilities live/unforgeable/in-image; not serializable; export → `capability-serialization-refused` | §11.1-11.2 (l.775-804) | **F-STRONGER** | S bars reconstruction-from-fields but has no export-refusal *condition* |
| **CAP-2** | minting-receipt fields | §11.3 (l.808-818), App A.5 (l.2119-2131) | AGREE | field lists match |
| **CAP-3** | restoration enforces DK-3; violations → `restoration-refused` w/ ground | §11.7 (l.850-868), §20.3 (l.1502-1513) | AGREE | S splits into 3 specific conditions (S-leaning) |
| **CAP-4** | revocation registry-mediated, checkable at frontier + resume; durable journal-backed | §11.6 (l.839-848), §11.1 | AGREE | F adds "journal-backed"; minor |
| **CFG-1** | machine-config resolved pre-frontier; record carries declared + resolved; alias≠resolution | §16.1-16.3 (l.1246-1275) | AGREE | |
| **CHN-1** | kernel knows channel-policy schema; instances by id; refuse unlisted/policy-absent commit | §17.1-17.2 (l.1282-1303), §20.8 | AGREE | S splits into `channel-policy-missing` + `publication-authority-missing` (S-leaning) |
| **RCP-1** | kernel-minimal receipt incl. deterministic/sampled status; MUST NOT certify beyond procedure (L13) | §15.5 (l.1207-1222) | AGREE | S omits the `deterministic/sampled` field (minor F detail) |
| **PRN-1** | principals kernel identities; roles per-event bindings; self/kin ordinary | §5.1, §5.3, §5.4 (l.286-332) | AGREE | |
| **PRN-2** | secret-open/exposure record: 7 fields incl. receiving principals | §10.7 (l.758-769) | AGREE | verbatim intent |
| **PRN-3** | kernel supports "which principals exposed to X" as a fold; no library | §21.1 (exposed principals), §5.4 | AGREE | F makes the *query* explicitly kernel-level; minor |
| **JRN-1** | store protocol verbs; reference = human-readable S-expr, one-per-line/form, no binary framing | §3.2 (l.192), §13, §2.4, §27.1 | **F-STRONGER** | F binds readability+framing **in-kernel**; S carries readability into the delegation (§27.1) but defers exact framing — see Part C.3 |
| **JRN-2** | ordinal = authoritative order; wall-clock MAY ride but MUST NOT order | §13.2 (l.976-1004) predecessor-linkage; **no timestamp guard** | **F-STRONGER** | S excludes timestamp ordering *structurally* (linkage) but omits the explicit guard |
| **JRN-3** | fold over longest prefix-valid; torn tail preserved+reported non-fatal; laundering impossible | §13.7 (l.1077-1081), §13.8 (l.1083-1092), §20.6 | AGREE | condition-name diverges (`journal-torn-tail`) |
| **JRN-4** | cross-journal merge = reconstruction transformation w/ receipt; no implicit timestamp sort | §20.6 `journal-merge-receipt-required`, §25.5#39, §27.1 | AGREE | S enforces via condition+test; format deferred |
| **JRN-5** | finalizer output re-derivable; kernel `reconstruct` reproduces summary; byte-compare fixture | §25.5#40, §25.8; §13.7; **no body-law + no §19 op** | **F-STRONGER** | S enforces finalizer law via test only; reconstruct op implicit (Review-Notes Part 4) |
| **JRN-6** | reconstruction-receipt fields; origin `:reconstructed` forever (L10) | §15.7 (l.1236-1239) L10 ✓; receipt fields deferred §27.1 | **F-STRONGER** | L10 AGREES; receipt-field binding is F-STRONGER |
| **JRN-7** | recovery refuses unsafe continuation on 7 grounds; each typed condition + planted fixture | §13.5 (l.1050-1060), §20, §11.7, §25 | AGREE | strong match |
| **OP-1** | invoke preflight **in order**; each failed check typed + effect `:not-entered` | §10.4 (l.719-732) unordered set, §11.4, §10.5, §12.6 | **F-STRONGER** | F mandates check order; S mandates the checks unordered |
| **OP-2** | post-frontier: persist incrementally (L8); no settled facts only in memory across await | §13 append-only model; **no explicit L8** | **F-STRONGER** | S enforces structurally via append-only; explicit L8 statement absent |
| **OP-3** | `(getf outcome :answer)` MUST NOT exist; payload only via context-requiring accessor | §24.4 (l.1800-1804), §20.8 `outcome-context-discard`, §19.6 | AGREE | strong match |
| **CND-1** | every refusal law → named condition carrying its law/ID | §20 (l.1470-1575), §20.1 "failed invariant" field | AGREE | S taxonomy is **larger** (S-leaning) |
| **CND-2** | compose w/ CL conditions; signal≠decide; restarts offered; crash site alive | §20.9 (l.1577-1599), §2.3 | AGREE | S implements restarts; F states the signal≠decide framing |
| **ADP-1** | adapter declares (as data) 10 capabilities incl. failure→outcome mapping, chunk/checkpoint, projection | §18.2 (l.1336-1352), §27.2 | AGREE | S omits explicit "failure→outcome mapping" + "chunk/checkpoint" naming (minor F detail) |
| **ADP-2** | fake adapter produces full algebra w/o provider | §18.3 (l.1354-1370) | AGREE | injection lists match |
| **FIX-1** | all 13 A0.1 §17 rows normative fixtures; each killed-reconstructed, byte-identical | §23 (12 fixtures) + §22 (call-296) = 13 cases; §25 | **F-STRONGER** | F binds **per-row** kill-reconstruct-byte-compare; S's byte-compare is on the finalizer test |
| **FIX-2** | "20 adversarial classes of 0.1 §16" each fixture + negative control | §25.1-25.8 (56 tests + 10 negative controls) | **S-STRONGER** | ⚠ F cites "20"; **A0.1 §16 enumerates 37** (WEAVER counted); S §25 is the more complete suite — see Part C.4 |
| **FIX-3** | L17 tested: form-count measured; bypass namespaces lint-enforced | §24, §25.7#55-56, §25.8, §24.3 | AGREE | S tests discard/raw-escape; F's explicit form-count *metric* is a minor F detail |
| **FIX-4** | fixtures = CD/0 values consumable by CL runtime AND language-neutral verifier | §21.2 (l.1626-1632) dual rendering, §2.1 | AGREE | S omits explicit "language-neutral verifier" naming (minor) |

---

## Part B — Reverse sweep: DRAFT-S normative content ABSENT from DRAFT-F (S-ONLY substantive items)

Grouped by topic. **[core]** = load-bearing kernel content the chair should have F concede/adopt; **[scaffold]**
= governance/traceability the chair can adopt cheaply. All are additive; **none contradicts a DRAFT-F clause.**

1. **[core] Semantic-domain enumeration + identity non-equivalence table** — S §4 (l.217-281): ~35 named
   abstract domains and the explicit `logical-op ≠ seat ≠ attempt ≠ request ≠ process`, `alias ≠ resolved config`,
   `claim ≠ datum`, `capability-record ≠ live capability` table. F has ID-1..3 but no domain map.
2. **[core] Evaluation-judgment formalism** — S §12 (l.872-963): ordinary `Γ ⊢ e ⇓ v` and consequential
   `Γ;Π;Α;Ρ;Σ ⊢ e ⇓ r;Δ`, plus §12.3 consequential-form classification ("a library MUST NOT disguise a
   consequential form as ordinary evaluation"). F has no judgment forms.
3. **[core] Kernel event vocabulary** — S §13.3 (l.1006-1032): 21 named event types. F carries only a
   "transition type" *field* (JRN-2) with no vocabulary. This is the largest single S-ONLY block.
4. **[core] Transition-legality rules** — S §13.5 (l.1050-1060): 7 enumerated illegal sequences. F JRN-7 refuses
   unsafe continuation but does not enumerate the legality relation.
5. **[core] Effect-class taxonomy + mandate** — S §10.2 (l.690-703): every effect MUST be classified as one of
   `:pure :replay-safe :compensable :irreversible :epistemic :constitutive`. F §8 lists no effect classes.
6. **[core] Frontier progression enum** — S §10.3 (l.705-715): `PREPARED → FRONTIER-CROSSED → SETTLED |
   COMPENSATED | BOUNDED | INDETERMINATE` + frontier definition. F has the frontier notion, not the progression.
7. **[core] Status→state normative mapping** — S §8.7 (l.534-538): maps each manifestation status to permitted
   absence states. F MAN-3 lists the states but not the mapping (closes a real fork).
8. **[core] Manifestation record field binding** — S §8.1 (l.446-457): 10-field manifestation record. F MAN-1
   references A0.1 §6.7 rules but binds no record.
9. **[core] Inspection-as-conformance** — S §21 (l.1603-1644): 13-item exposure obligation + dual rendering +
   `explain` boundary (recorded fact / derived state / asserted narrative / causal claim / missing evidence /
   bounded alternative). F has `explain` and dual-rendering (FIX-4) but no inspection-conformance section.
10. **[core] Machine-config full field protocol** — S §16.1 (l.1246-1263): ~16 config fields. F CFG-1 binds
    declared+resolved but defers the field list to A0.1.
11. **[core] Determinacy fine-semantics** — S §7.2-7.5 (l.416-436) + §9.2 rule 4 (value-`:indeterminate` vs
    determinacy-`:indeterminate`). F OUT-1 has the modes without the distinction.
12. **[core] Idempotency declaration fields** — S §14.5 (l.1140-1153): domain/key/scope/expiry/duplicate-behavior/
    evidence, + "caller-provided key without provider guarantee is not proof." F mentions idempotency support only.
13. **[core] Minting-bridge operation steps** — S §11.3 (l.808-818): 5-step mint operation. F CAP-2 binds the
    receipt, not the operation.
14. **[core] Terminal attempt states** — S §13.6 (l.1063-1075): 6 terminal classes incl. `:superseded` as a
    lineage (not innocence) state.
15. **[scaffold] Conformance classes** — S §3 (l.182-214): 5 classes + "no component may claim another's
    guarantees." F K-2 defines conformance-by-fixtures without the taxonomy.
16. **[scaffold] Role vocabulary** — S §5.2 (l.294-311): 14-role initial vocabulary. F PRN-1 lists roles inline.
17. **[scaffold] Genuine stop conditions** — S §28 (l.1999-2022): 12 stop-conditions + stop-record format. F §10
    "deliberate stops" has 6.
18. **[scaffold] Adoption criteria + successor sequence** — S §29-30 (l.2025-2058). F defers to synthesis.
19. **[scaffold] Governance scaffolding** — S §0.2 authority chain, §0.3 decision trace, §0.4 non-authorization
    clause (l.42-84). F §0 has sequencing but not the non-authorization enumeration.
20. **[scaffold] Appendix A abstract data shapes** — S l.2062-2160 (determinacy/manifestation/axis/outcome/
    mint/restoration/supersession). F §6 has schematic operations, not data shapes.
21. **[scaffold] Appendix B condition-disposition table** — S l.2164-2178: before/after-frontier × retry-allowed
    per condition family. No F equivalent.
22. **[scaffold] Appendix C trace table** — S l.2181-2203: A0.1 §12 primitive → Kernel-/0 section map.

**S-ONLY substantive count: 22** (14 core + 8 scaffold).

---

## Part C — CONFLICTS and the sharpest one-sided items (with dispositions — WEAVER's proposals only)

### C.0 — There are **ZERO true CONFLICTS** (incompatible-both-cannot-hold)

WEAVER applied the strict test — *is there an implementation that satisfies one draft while being **prohibited**
by the other?* — to every divergence. **None qualifies.** Every F-STRONGER item is a strict *narrowing* (an
F-conformant implementation is always S-conformant); every S-STRONGER item is additive; every condition-name
difference is reconcilable (both drafts say names are proposals: F §10.2, S §19 l.1380). So the two blind
Opus-lineage drafts **do not contradict each other anywhere** — the expected shared-root outcome. The
information is entirely in the strength/coverage asymmetries below.

### C.1 — Closest-to-conflict #1: identity issuance (ID-1)

- **F ID-1:** "Durable identities … MUST be **store-issued** and stable across host restarts."
- **S §4.1 (l.263-264):** "Kernel /0 does **not mandate UUIDs versus store-issued** monotone identifiers. The
  implementation MUST declare its identity procedure and demonstrate restart stability."

Not a strict conflict (a store-issued id satisfies both), but **F prohibits a class S permits** (e.g. a
content-addressed / hash identity: non-gensym, restart-stable, but not store-issued). **WEAVER proposal:
adopt-S / merge** — keep S's *declared-procedure + restart-stability + non-gensym* floor and **drop F's
store-issued-mandate**; mandating store-issuance over-constrains and would bar valid content-addressed identity.
*Rationale:* the goal (restart stability, no image-local ids crossing) is fully met by S's floor. **Do NOT
reflexively adopt-F here** — this is the one place where "F-STRONGER" would be the wrong merge.

### C.2 — Most consequential divergence: uncertain-effect representation (OUT-3 / UNC-1)

- **F OUT-3:** "A `:bounded`/`:indeterminate` effect axis **MUST reference an uncertain-effect record** (§3.4);
  constructing one without it MUST signal `condition:unstructured-uncertainty`."
- **S §9.4 (l.638):** "`:bounded` MUST include named alternatives and evidence." *(inline; no structured record,
  no `unstructured-uncertainty` condition.)*

An implementation putting alternatives+evidence *inline without a record* passes S, fails F. **WEAVER proposal:
adopt-F (merge in A0.1 §6.10's field-shape).** *Rationale:* A0.1 §12.1 primitive **10** names "structured
uncertain-effect values" a **kernel primitive**, and §6.10 gives the shape (incl. `:retry-policy`,
`:reconciliation-procedure`); F is the more canon-faithful reading, and the structured record is what carries
the no-blind-retry guarantee across a restart. This is the single divergence that most affects the kernel's core
algebra and the call-296 path — **the chair's highest-value merge decision.**

### C.3 — Journal readability placement (JRN-1)

- **F JRN-1:** reference journal is "human-readable S-expressions, **one record per line or form, no binary
  framing**" — bound **in the kernel spec**.
- **S §2.4 / §27.1:** delegates "exact human-readable S-expression grammar, record framing, canonical byte
  conversion" **to the Process-Journal-/0 spec** (readability is carried into the delegation; exact framing is
  not pre-bound).

**WEAVER proposal: merge** — keep the *readability requirement* stated in-kernel (F, matching A0.1 §9.1 + D4
rider) but **defer exact byte-framing** to the journal spec (S, the seam-correct home for bytes). F slightly
over-reaches into journal-spec territory; S is the more seam-disciplined but should surface the readability MUST
where a reader of the kernel spec alone will see it.

### C.4 — Adversarial-suite count (FIX-2) — an F-side inaccuracy to reconcile

F FIX-2 cites "**the 20 adversarial classes of 0.1 §16**." **A0.1 §16 enumerates 37 numbered tests** (WEAVER
counted 1–37; +6 ergonomic in §16.1). Whether F's "20" is a miscount or an un-stated regrouping, it is
imprecise as written. **S §25 enumerates 56 tests + 10 negative controls** — the materially more complete suite.
**WEAVER proposal: adopt-S §25 as the fixture base; reconcile the count to A0.1's 37** and drop F's "20."

### C.5 — Other F-STRONGER items worth the chair adopting (proposals)

- **MAN-2** (kernel MUST NOT project subject from envelope bytes): **adopt-F** — cheap seam-hardening.
- **CAU-1/CAU-2** (causal-claim protocol + revision-invariance): **adopt-F / pull A0.1 §6.9.2** — closes the one
  under-specified §12.2 protocol.
- **OUT-5** (interpretation-requires-present invariant): **adopt-F** — prevents "accepted an absent manifestation."
- **OP-1** (ordered preflight): **adopt-F ordering** — cheapest-refusal-first + identity-before-spend (L7).
- **JRN-5 / reconstruct op / finalizer law**: **adopt-F body-law**; name `reconstruct`/`fold-state` in the op set.
- **JRN-2 timestamp guard / OP-2 incremental-durability (L8)**: **merge** — keep S's structural enforcement,
  restate the A0.1 guards (L8, §9.4) as legible MUSTs.
- **FIX-1 per-row byte-compare**: **adopt-F.**

### C.6 — S-ONLY core content the chair should have F concede (proposals)

**adopt-S** for all 14 **[core]** reverse-sweep items (Part B 1-14) — especially the event vocabulary (§13.3),
evaluation judgments (§12), effect-class taxonomy (§10.2), transition-legality rules (§13.5), status→state
mapping (§8.7), and inspection-as-conformance (§21). None contradicts F; each fills a real gap in F's 330-line
frame. The 8 **[scaffold]** items are cheap adopt-S.

---

## Part D — Counts

- **Total DRAFT-F requirement IDs traced:** **54**
- **AGREE:** **37**
- **S-STRONGER:** **1** (FIX-2) — with ATT-3, CAP-3, CHN-1, CND-1 S-leaning within AGREE
- **F-STRONGER:** **16** (ID-1, ID-3, OUT-3, OUT-5, MAN-2, CAU-1, CAU-2, UNC-1, CAP-1, JRN-1, JRN-2, JRN-5,
  JRN-6, OP-1, OP-2, FIX-1)
- **CONFLICT (true incompatibility):** **0** *(closest: ID-1 and OUT-3 — F narrows/requires beyond S; neither is
  mutually unsatisfiable)*
- **F-ONLY (absent from S):** **0** *(every F ID has an S correspondent; the weakest are F-STRONGER
  under-specifications, not absences)*
- **S-ONLY substantive items:** **22** (14 core + 8 scaffold)

**One-line read for the chair:** the parents do not fight; S is a ~7× superset that fills F's gaps, F is the
tighter binding on ~16 clauses (adopt most, but **not** ID-1's store-issued mandate), the single highest-value
merge is the **uncertain-effect record (C.2)**, and F's only inaccuracy to fix is the **"20"→37** adversarial
count (C.4). Because both are shared-root, treat none of the 37 AGREE rows as corroboration — only the
asymmetries carry information.

— WEAVER (Claude Opus 4.8, 1M context), 2026-07-18
