# FABLE-LCI0-CONSTITUTIONAL-REVIEW

**Subject:** Lisp+ Located Claim Identity /0 (`LOCATED-CLAIM-IDENTITY-SPEC.md`)
**Review kind:** pre-implementation constitutional audit (no code, no spec edits, no migration, no CD/0 changes)
**Reviewer of record:** Claude Fable 5 (chair; first-hand full read of all 3,481 lines), assisted by seven scoped audit agents (Opus 4.8 / Sonnet 4.5) whose reports are annexed by hash in §23
**Date:** 2026-07-13 (22:30 −03)

---

## 1. Executive verdict

**NARROW-ERRATA-REQUIRED.**

The selected model — ClaimId as the exact closed CD/0 envelope of {identity-policy, claim-profile, normalized proposition, scope, subject-time, basis, interpretation-frame, profile-location}, with WarrantTarget as complete-ClaimId-plus-typed-boundaries, and claimant/issuer/provenance/lineage/policy/standing/revocation excluded — is **constitutionally sound**. Twenty adversarial counterexamples were constructed against it; **zero broke a stated rule**. Frozen CD/0 is **preserved exactly** (zero contradictions; one conditional-wording drift at the LCI layer only). The field set is minimal (7 of 8 coordinates counterexample-necessary; the eighth is a justified forward-compatibility constant). Every confirmed defect **fragments identical claims into different ClaimIds rather than merging different claims into one** — the safe failure direction for an identity system.

What blocks READY is not the model but its *determinacy at the edges*: (a) the base Mneme references and the five neutral expressions are never byte-pinned, so two clean-room implementations cannot derive the byte-identical canonical *neutral* ClaimId that §8.7/§26.3 promise from the prose alone (found independently four ways); (b) five wording seams each admit a divergent or unsafe reading that one to three sentences would close. All repairs are additive; none touches the selected model, CD/0, or the projection algorithm. §21 gives the exact proposed errata. **No CONSTITUTIONAL-REDESIGN is required or close to required.**

Independent implementation may be authorized **after** (i) an LCI/0 Errata 0.1 adopting the §21 items (or a reviewed subset of E1–E5 at minimum) and (ii) the frozen fixture package of §18 — which the specification itself anticipates (§29.3 "frozen fixture calculi") and which must be produced by the specification/profile author, **never invented silently by an implementation agent**.

## 2. Artifacts and hashes reviewed

| Artifact | SHA-256 | Status |
|---|---|---|
| `LOCATED-CLAIM-IDENTITY-SPEC.md` (206,741 B, 3,481 lines) | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` | matches declared hash ✅ |
| `lisp-plus-lci0-cd0-frozen-reference-packet-2026-07-13-56f0ce55253e.zip` | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` | matches declared hash ✅ |
| Packet internal manifest (`sha256sum -c SHA256SUMS.txt`) | — | 14/14 OK ✅ |
| `normative/CANONICAL-DATUM-SPEC.md` | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` | byte-identical to canonical CD/0 ✅ |
| `normative/CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` | ✅ |
| `normative/CD0-POST-IMPLEMENTATION-RULING.md` | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` | ✅ |

LCI/0's own factual claims about the packet were reproduced first-hand: 15 files ✅, 381,105 extracted bytes ✅ (exact), `PACKET-MANIFEST.md` = `ead05e92…` ✅, `SHA256SUMS.txt` = `3caa9063…` ✅. Evidence precedence (normative → ruling → final evidence → context → migration-evidence) was preserved throughout the review; `context/` and `migration-evidence/` supplied no rule.

## 3. Confirmed constitutional decisions

The following are **confirmed sound** as selected (each survived targeted attack; see §19 and the annexed reports):

1. ClaimId **is the envelope, not a hash** (§7.12); digest-separation law (§17.16) and mandatory cache recomputation (§8.4) hold under attack (CE-17: HOLD).
2. The **eight-coordinate envelope** with all fields required, **no optional identity fields**, and **explicit neutral values** — omission ≠ Unit ≠ neutral (§7.11, §19.5). Kills the absent-vs-explicit-neutral divergence class at the schema level.
3. **Single ownership of semantic coordinates** (§5.10) + cross-field consistency (§8.5): contradictory proposition/location duplication is refused, not adjudicated (CE-5, CE-6: HOLD — "which copy wins" = neither).
4. World basis vs corpus basis are **structurally disjoint records** — corpus/world collision is impossible by CD/0 structural equality (CE-3: HOLD).
5. **Exact subject-time direct matching**; temporal containment has *no consumer in the matcher* — blocked at four independent layers (§10.4, §10.6 `==`, §12.5/§12.7, §27.12) (CE-11: NULL).
6. **Scope narrowing** as the single generic non-equality projection, quadruple-gated (calculus `wider` + declared monotonicity per target-kind × proposition form + boundary coverage + policy), default forbidden; **widening policy-proof** (§17.11) (CE-9: HOLD at spec level; harness caveat → I06).
7. **Closed schemas + fail-closed unknown fields** everywhere the spec owns (§7.1, §19.6, §25.5) (CE-12: HOLD, four layers).
8. **Migration fail-closed on all seven audited surfaces**; the v1 proposition-only fingerprint *cannot even populate* an LCI envelope (CE-15: structurally impossible); revival by shape blocked at ≥8 points incl. hard-false `live-warrants-created` (CE-16: HOLD). Confirmed against the real `kernel-hardened.lisp`: v1 `%fingerprint` digests the proposition only and `raise-claim` never checks `as-of` — the live defect LCI/0 §23.5 exists to close.
9. **Mutable aliases**: all five audited alias classes (`latest`, `main`, package symbol, model alias, mutable URI) are named in the text and mapped to typed refusals (CE-18: HOLD).
10. **Overloaded `as-of` rejection is complete** — no residual double-meaning time field found (Q5: null result after targeted hunt).
11. **Lineage/represented-loss exclusion** from ClaimId in all safe cases; identity-bearing loss forces refusal or an explicitly loss-qualified *new* ClaimId (Q15/Q16/CE-14: HOLD).
12. The **layered dependency model** (§5.1) is acyclic: ClaimId ← nothing above it; WarrantTarget ← ClaimId; admissibility/standing ← targets + policy + state, with no back-arrow (Q11: confirmed by explicit graph reconstruction).
13. LCI/0 **is the decision the CD/0 ruling called for** (ruling §2, §16.3), and answers §16.3 in the ruling's own direction: migration produces a new identity; the old fingerprint is demoted to lineage.

## 4. Internal-coherence audit

Zero CONTRADICTORY classifications across ~185 subsections (SURVEYOR matrix, §17). The failure vocabulary (§18) covers the matcher's outcomes (§10.1) and the migration codes (§23), with two determinacy exceptions now registered: the §10.6 wider-branch failures lack §18 codes (I06), and intra-rank multi-fault precedence is unordered (I07). One self-admitted incompleteness sits inside settled law rather than in §28's deferral chapter: §17.12 "LCI/0 fixes neither the full predicate set nor their order" (registered under I02). The §19.3 vs §2.4/§7.9/§19.10 version-bump tension is the only place two normative sentences give apparently opposite instructions (I03).

## 5. Minimality and identity-inflation audit

**Minimal in field set.** Removal-collision constructed for 7/8 coordinates (GEOMETER Q1, concrete pairs each). `profile-location` is a fixed-empty constant for Mneme/0 that cannot distinguish any two claims and thus fails the spec's own §5.3 per-claim test — justified instead by forward-compatibility gating; §6.1's "counterexample-narrow" claim slightly over-reaches (I12a, documentation repair only).

**Frame inflation (Q2) is real, bounded, and deliberate:** two frames yielding the same normalized proposition still yield different ClaimIds. This is the price of a projector that performs no theorem-proving (§27.20); the compensating disciplines are frame-schema minimality (§13.1) and pre-projection normalization — which the text mandates **only for scope** (§11.4) and not for subject-time/frame/slice (I04). Deliberate exact-value identity (scope §11.4, time §12.2, slice §14.5) trades equivalence-collapse for determinism; consistently applied; residual inflation is fragmentation-shaped and calculable.

**No over-identification found**: no removable coordinate, no shrinkable coordinate.

## 6. Under-identification audit

No missing identity coordinate was constructed. The candidate-dimension table (§6) was attacked at its weakest rows (language, jurisdiction, confidence, uncertainty) without producing an under-identified pair, provided the profile disciplines hold. The latent risk is **G3-shaped**: until the Mneme proposition grammar exists, "the same locator in two homes" (proposition vs location) is detectable only by the deferred `proposition_location_consistent`; if that profile check were absent, a dropped coordinate could falsely merge (I05 — fixture-gated, with the required repair placed on the grammar deliverable).

## 7. ClaimId-envelope audit

Envelope schema (§7.11) closed, six fields, no Unit at top level, validated rejections enumerated. Projection algorithm (§8.2) pure and deterministic given its inputs; purity requirements (§8.3) comprehensive (no I/O, no clock, no registry, no ambient state — re-verified against §20.14). Canonical bytes = frozen CD/0 `canonical-octets` over the complete document including `LPCD` magic (§8.6) — consistent with CD/0. **The one envelope-level defect is I01**: the values of the neutral coordinates are not derivable from the prose (see §11 below).

## 8. WarrantTarget audit

Common envelope (§9.2) always embeds a complete validated ClaimId; proposition-only targets are unrepresentable (`LegacyFingerprintNotClaimId`). All six laundering attacks blocked at the identity/target layer: procedure redefinition (immutable code identity, §9.5/§20.6), corpus-version substitution (`BasisMismatch`, §10.5), stale temporal reuse (exact subject-time + `TemporalCoverageInsufficient`), report/observation confusion (distinct target kinds, §9.11), incomplete-search laundering (`CorpusCompletionInsufficient`, §9.10/Scenario 3), translation laundering (explicit receipts + loss, §9.13/§13.7). The eleven target kinds are prose "binds at least" lists without closed record shapes — correctly fixture-gated (§18 item 7), with `TargetBoundaryUnknown` protecting closure meanwhile. §9.14 policy-evaluation targets could manufacture citable "policy accepted" records without recording the inner relation result (I12b, LOW).

## 9. Scope and temporal boundary audit

Scope interface (§11): seven-value oriented relation vocabulary, fail-closed on `incompatible`/`unknown`, bridges explicit and versioned, subsumption defined in terms of relation — deterministic given a calculus. Narrowing/widening laws (§11.5, §17.10, §17.11) are policy-proof in the widening direction. Temporal interface (§12): seven roles separated; `time-equal` is CD/0 equality; relative times must resolve pre-projection with no ambient clock. The matcher's failure precedence *within* §10.6 is fixed by the pseudocode's require-order. Gaps: the wider-branch failure codes (I06) and the harness's inability to detect a *false* monotonicity declaration (I06 — a fixture/vector obligation, since the spec cannot verify semantics it defers).

## 10. Stable-reference audit

`StableRef/0` (§7.2) is fail-closed by construction: unknown schemes → `UnsupportedReferenceScheme`; mutable-alias-permitting schemes must not be accepted; display names never stand alone. It does **not** move ambiguity into `scheme`/`material` *silently* — it moves it there **visibly and refusably**, which is the correct /0 posture. Two residuals: (a) nothing forbids two conforming schemes for one domain, so the same real-world referent can carry multiple conforming identities — fragmentation across schemes (I08); (b) **fourteen reference domains** are named by the text and every one requires a frozen scheme before any conforming `StableRef/0` exists (§18, item 6 — the single largest fixture cluster). Schemes that must be frozen before implementation: scope-calculus, temporal-model, slice-calculus, boundary-calculus, frame-schema, logical-corpus, corpus-revision, module, procedure, model, prompt/invocation, artifact, principal, admissibility-policy.

## 11. Frame and normalization audit

Interpretation frames are required, closed under their schema, and neutral-frame semantics are explicit — but the neutral frame reference itself is a `<self-describing frame>` placeholder (I01). Normalization-before-projection is architecturally right (§13.3, §27.20); the §11.4 discipline (total, deterministic, versioned, loss-preserving pre-projection normalization) exists **only for scope** and must be replicated for subject-time, frame, and slice (I04), plus an explicit MUST that a proposition with no meaning-bearing context uses the neutral frame. Same-surface/different-frame and different-surface/same-proposition behavior (§13.5/§13.6) is coherent and vector-backed (P009/P010).

## 12. Lineage and represented-loss audit

Lineage fully outside ClaimId; equality neither implies nor is implied by descent (§15.1, §17.8); `claim-descends-from` MUST NOT be answered from bytes alone (§15.13). Represented loss: identity-neutral loss preserves ClaimId; identity-bearing loss forces refusal or an explicitly loss-qualified new claim; guessing is forbidden by name (§16.4, §16.7). CE-14 (loss-classification divergence) HOLDs via the fail-closed default plus §26.5's differential agreement obligation. No case found where meaning-changing loss incorrectly preserves ClaimId under the stated rules *given a conforming profile* (the profile-quality caveat is WARDEN W7, LOW/PLAUSIBLE). No case found where harmless provenance loss forces a new ClaimId (§16.2 example is dispositive).

## 13. Versioning and field-evolution audit

Thirteen version axes kept distinct (§19.1); closed records fail on unknown top-level versions (Q18: closed at top level; nested closure is delegated to schemas/fixtures — I12d). Q20: the claim-profile × identity-policy axes are **non-redundant** (distinct roles confirmed) but carry the I03 bump-governance ambiguity. Q21: a normalizer bug fix that changes no vectored result may ship under the same version (§19.4, §19.12); wrong cached ClaimIds surface via mandatory recomputation (`ClaimIdCacheMismatch`) — coherent, but convergence for *un-vectored* inputs rests on the finite vector corpus with no content-identity backstop (I03). Q22: envelope-as-ClaimId is operationally coherent with no digest — nothing in the text assumes a short id. Q23: envelope authority is preserved (§8.4 recompute, §17.16, §20.11); the §20.11 conditional phrasing is the sole CD/0 restated-drift (I09).

## 14. Typed-failure and precedence audit

Failure envelope closed; prose excluded from conformance; CD/0 failures never relabeled (§18.2). Single-fault vectors fully determined (category/code/stage/path). The 12-rank multi-fault precedence (§18.9) is deterministic *between* ranks and undetermined *within* ranks 1 and 6 (I07); conformance obligations are vector-scoped (§26.8; CD/0 §29.14 verified verbatim: "Both codecs run every negative vector…"), so this is bounded indeterminacy on live data, half-acknowledged by the minimization sentence — one clarifying sentence required. Missing codes for the §10.6 wider-branch failures (I06).

## 15. v1 migration audit

**Fail-closed on all seven surfaces** (proposition-only fingerprints; package-stripped identifiers; ambiguous `as-of`; host procedure identities; predecessor warrants; revival; represented loss) — each with an explicit refusal path, typed code, and ≥1 required vector, verified against the actual v1 source (`kernel-hardened.lisp`), not just the spec's characterization. No migrated warrant can go live by shape, registry lookup, or identity reconstruction (Q25: all three constructions died; `live-warrants-created => false` is a literal record field). Residuals: middle-ground classifier vectors absent (I11); ruling §16.4's Unicode/printer/hostile-payload vector categories not echoed in LCI/0's tables (I10); §23.2's seven-value classification vocabulary should be explicitly mapped onto ruling §16.1's five (I10); the structural inert/live obligation on the future registry is honestly deferred to §28.6/§28.9 (I12e — a debt of the *next* constitution, correctly not papered over here).

## 16. Cross-implementation determinacy audit

The projection **algorithm** and the **serialization layer** admit zero degrees of freedom (SECOND-KNIFE's CE-20 DOF hunt: exhausted at the CD/0 layer). Every determinacy defect is a **value-determination** gap: I01 (neutral bytes), I04 (co-denoting normalization), I05 (placement), I06 (missing codes), I07 (intra-rank precedence), I08 (scheme multiplicity). Direction of all divergences: fragmentation, never false-merge. §26's differential/perturbation/randomized regime is strong and, once the fixture package exists, sufficient to catch every registered divergence class except a false monotonicity declaration and an un-vectored normalizer change — both of which need the I03/I06 assurance obligations.

## 17. Specification-executability matrix

Full per-subsection matrix in the annexed SURVEYOR report. Summary of classified rows: **148 FULLY-EXECUTABLE · 46 FIXTURE-GATED · 20 DEFERRED-SUFFICIENT · 2 UNDERDETERMINED · 0 CONTRADICTORY · 82 NON-NORMATIVE.** The two UNDERDETERMINED: §17.12's self-admitted predicate-set incompleteness (I02) and the intra-rank precedence (I07). The fixture-gated mass concentrates in §7 (nested value schemas), §9 (target schemas), §11–§14 (calculi/schemes), §23 (migration mappings), §24–§25 (vector bytes).

## 18. Required fixture package before implementation

**Implementation MUST NOT begin until the specification/profile author freezes, with exact canonical octets and acceptance tests, all of:**

1. **Mneme proposition fixture grammar/normalizer** — closed AST family; StableRef embedding; deterministic normalization; the §5.10 subject-vs-locator marking (I05). *Acceptance:* 50-sentence blind corpus → byte-identical propositions from both teams; in-proposition unknown-field mutation rejected identically.
2. **Fixture scope calculus** — §11.2 operations; universal-scope expression bytes; the §11.7 seven vectors verbatim; a bridge-less second calculus; an `unknown` case; ≥1 downward-monotone proposition-form declaration.
3. **Fixture temporal model** — instant/interval/atemporal expression bytes; §12.1 role-decomposition vectors; `UnresolvedRelativeTime` on unresolved "now".
4. **Basis schemas** — slice calculus with explicit all-members bytes; boundary calculus with explicit not-applicable bytes; ≥1 closed-world boundary form; §23.5 collision fixture; empty-host-collection-as-universal rejected.
5. **Interpretation-frame schema** — closed component list; the self-describing/neutral frame reference bytes; the two Scenario-6 incompatible frames; unknown-component mutation rejected identically.
6. **Stable-reference schemes — all fourteen domains** (scope-calculus, temporal-model, slice, boundary, frame-schema, logical-corpus, corpus-revision, module, procedure, model, prompt/invocation, artifact, principal, policy) per §14.1's MUST list. *Acceptance:* the §20.6 alias attack run per domain → `UnresolvedAlias`/`MutableReference` in both implementations.
7. **Target schemas for the eleven WarrantTarget kinds** — exact closed records for every "binds at least" field, plus the monotonicity-declaration mechanism. *Acceptance:* vectors P013–P021 end-to-end, byte-identical envelopes + identical relations.
8. **Finite admissibility-policy fixtures** — Policy-A/Policy-B frozen (not illustrated), fixed predicate list and order. *Acceptance:* P022/P023 identical booleans; ClaimId bytes provably unchanged while admissibility flips.
9. **v1 migration mappings** — frozen symbol/package→identifier table for the actual v1 corpus; frozen `as-of`-site→role table; the frozen non-evaluating legacy parser; the §23.5 collision fixtures. *Acceptance:* both adapters give different ClaimIds or identical typed refusals; `live-warrants-created = false` everywhere.
10. **LCI-layer resource-budget fixture** (numbers for N032). *(gap beyond the mandated nine)*
11. **Claim-occurrence/artifact nonidentity-metadata subrecord schema** — without it §17.4's metadata-neutrality law is untestable. *(gap)*
12. **Per-operation `RepresentedLoss/0.account` schemas** for the named operations. *(gap)*

Neutral-value pinning (E1) may be discharged in-spec **or** by this package; either way the exact octets must exist under the author's signature before clean-room work starts.

## 19. Findings by severity

Zero CRITICAL. Consolidated register (full details, counterexamples, and all eight required fields per finding in `FABLE-LCI0-ISSUE-REGISTER.md`):

| ID | Sev (chair) | One-line | Sources (independent) |
|---|---|---|---|
| I01 | **HIGH** | Base Mneme references + five neutral expressions not byte-pinned → clean-room byte-identity underivable from prose | GEOMETER G1 · KNIFE CE-7 · SECOND-KNIFE CE-20 · WARDEN W3 (4×) |
| I02 | MEDIUM | §17.12 floor says "fails" undefined; `relation-undetermined` door openable by misreading (intended reading safe ×3 barriers) | WARDEN W1/CE-10 · SURVEYOR (2×) |
| I03 | MEDIUM | Version-bump governance ambiguous (§19.3 vs §2.4/§7.9/§19.10) + normalizer-revision convergence rests on finite vectors | CUSTODIAN F1,F2 · SECOND-KNIFE CE-13 (3×) |
| I04 | MEDIUM | §11.4 pre-projection normalization discipline missing for subject-time/frame/slice | GEOMETER G2 |
| I05 | MEDIUM | Proposition-vs-location placement undetermined until Mneme grammar exists (latent false-merge if profile checks absent) | GEOMETER G3,G6 · KNIFE CE-5/6 repairs |
| I06 | MEDIUM | Wider-branch failures lack §18 codes; no nonmonotone-refusal vector; false monotonicity declarations undetectable by harness | GEOMETER G4 · WARDEN W2 |
| I07 | LOW-MED | Intra-rank multi-fault failure precedence unordered (ranks 1, 6) | SECOND-KNIFE CE-19 · chair |
| I08 | LOW-MED | Multiple conforming StableRef schemes per domain fragment identity across schemes | KNIFE CE-8 · SURVEYOR |
| I09 | LOW-MED | §20.11 conditional wording weakens CD/0 §10.7's unconditional digest rule at the LCI layer | CUSTODIAN F3 |
| I10 | LOW-MED | Ruling §16.4 vector categories (Unicode/printer/hostile) not echoed; §23.2 vs ruling §16.1 classification vocabularies unmapped | FERRYMAN F2 · chair |
| I11 | LOW | Migration vectors test only ambiguity extremes, not the loose-classifier middle ground | FERRYMAN F1 |
| I12 | LOW | (a) profile-location minimality-exemption doc fix; (b) §9.14 inner-relation marker; (c) `PrivilegedRestorationAttempt` name shadow; (d) nested version closure delegated; (e) inert/live structural obligation deferred to §28.6/§28.9 | GEOMETER G5 · WARDEN W5 · CUSTODIAN F4,F5 · FERRYMAN F3 |

Adversarial tally (20 CEs): **0 BREAK · 5 UNDERDETERMINED (CE-7ᵖ, 8, 13, 19, 20ᵖ — ᵖ = partial; all map to I01/I03/I07/I08) · 15 HOLD.** Per-question tally (25 Qs): 19 clean confirmations, 6 with registered findings (Q2→I04, Q8→§18, Q14→I02, Q20/Q21→I03, Q19→fixture surfaces).

## 20. Exact proposed narrow errata

For an **LCI/0 Errata 0.1** (companion document, CD/0-errata style; E1–E5 are the pre-implementation floor, E6–E9 strongly recommended in the same pass):

- **E1 (I01).** In §7.6/§7.7.2/§7.7.3/§7.8, name the base Mneme temporal-model, slice-calculus, boundary-calculus, and frame-schema references exactly as §7.5 names the scope calculus; pin the five neutral expressions (universal scope, atemporal, all-members, not-applicable, self-describing frame) as concrete `StableRef/0`/expression records — in-spec or by normative delegation to the fixture package *with an exact-canonical-octets requirement*; extend §11.7's "shared exact octets" clause to the temporal/frame/slice/boundary suites.
- **E2 (I02).** Restate the §17.12 floor positively: *"A conforming system MUST NOT return admissible unless `match_target(w.target, c)` returned `R("exact-target")` or `R("supports-by-scope-narrowing")`"* and add `relation-undetermined` outcomes to the enumerated hard-inadmissible conditions.
- **E3 (I03).** One tie-break sentence: *"A change to a profile's normalization contract that leaves the envelope field set and field roles unchanged requires a new claim-profile version and does not require a new identity-policy version; identity-policy versions change only when the projection's field set or field roles change."* Add to §19.4: profile conformance evidence MUST bind an immutable content identity for the normalizer definition, and a §25.5-style mutation vector accompanies any normalizer revision.
- **E4 (I04).** Replicate §11.4's normalization discipline verbatim into §12 (subject-time), §13 (frame), §14.5 (slice); add the frame-neutrality MUST.
- **E5 (I06).** Add `ScopeNarrowingNotDeclared` (target-mismatch / target-relation) and a boundary-coverage failure code; wire into §10.6 and §18; add a required negative vector: broad target + nonmonotone proposition → refusal.
- **E6 (I07).** One sentence: intra-rank multi-fault order follows the schema field order of §7.10/§7.11 (or: is explicitly unspecified in /0 and excluded from conformance until minimized precedence vectors are constitutionalized).
- **E7 (I08).** Per reference domain, the base Mneme profile names exactly one canonical scheme or a mandatory registered total bridge (elevate §11.3's bridge doctrine to all fourteen domains via §14.1).
- **E8 (I09).** Reword §20.11 to CD/0 §10.7's unconditional form: digest equality is never a substitute for envelope/octet equality.
- **E9 (I10).** Add ruling-§16.4's vector categories (Unicode non-normalization, printer-setting variation, hostile legacy payloads) to §23.5/§25.3; add one sentence mapping §23.2's seven classifications onto ruling §16.1's five.

## 21. Implementation-readiness verdict

**NARROW-ERRATA-REQUIRED.** The constitutional selection is correct and defensible at every point attacked. Authorize independent Common Lisp and Python implementation upon: (1) adoption of LCI/0 Errata 0.1 covering at minimum E1–E5; (2) delivery of the §18 frozen fixture package by the specification/profile author with exact canonical octets and the listed acceptance tests. Absent (2), clean-room byte-identity is not derivable from the normative text alone — and an implementation agent left to invent fixtures would be choosing semantics, which this review exists to prevent.

## 22. Paste-ready relay

See `FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY.md` (same directory), addressed to the specification author.

## 23. Annexes (audit working papers, verified on disk)

Seven scoped agent reports, `_staging/lci0-audit/scratch/` (lab-internal; hashes recorded in the issue register): GEOMETER (projection minimality, 452 ln) · WARDEN (WarrantTarget/policy, 314 ln) · KNIFE (CE-1–8, 324 ln) · SECOND-KNIFE (CE-12–20, 287 ln) · SURVEYOR (executability matrix + fixtures, 891 ln) · FERRYMAN (v1 migration, 248 ln) · CUSTODIAN (CD/0 preservation + versioning, 238 ln). Chair verified every staging file on disk, read the full specification and the load-bearing report sections first-hand, reproduced the spec's packet-identity claims by command, and re-adjudicated each severity (two downgrades from agent ratings are noted inline in the register: W1 HIGH→MEDIUM, CE-19 MEDIUM→LOW-MED, with reasons).

---

*Review conducted without modification to the specification, the repository's normative artifacts, CD/0, or v1. Signed: **Claude Fable 5**, 2026-07-13.*
