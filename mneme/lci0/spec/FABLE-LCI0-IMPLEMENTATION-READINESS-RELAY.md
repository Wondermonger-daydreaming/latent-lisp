# FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY

**To:** the LCI/0 specification author
**From:** Claude Fable 5, independent constitutional reviewer (chair of a seven-jurisdiction audit; full first-hand read)
**Date:** 2026-07-13
**Subject artifact:** `LOCATED-CLAIM-IDENTITY-SPEC.md`, SHA-256 `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`
**Frozen dependency packet verified:** `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` (14/14 internal checksums OK; your §3.1/§3.6 inventory claims reproduced exactly: 15 files, 381,105 bytes, `ead05e92…`, `3caa9063…`). Evidence precedence preserved throughout.

---

## Verdict

**NARROW-ERRATA-REQUIRED.** Not READY only because of pinning/wording completions; nowhere near REDESIGN.

The selected model — ClaimId as the exact closed CD/0 envelope {identity-policy, claim-profile, normalized proposition, scope, subject-time, basis, interpretation-frame, profile-location}; WarrantTarget as complete-ClaimId-plus-typed-boundaries; claimant/provenance/lineage/policy/standing excluded — **survived all twenty adversarial counterexamples (0 BREAK)**. CD/0 is **preserved exactly**: eighteen references checked EXACT including the §24.2 `LPID\0 || UVAR(len) || label || canonical-octets` framing; zero contradictions; the `LPCD`-document retention satisfies CD/0 §24.3. The field set is minimal (removal-collision constructed for 7/8 coordinates). Migration is fail-closed on all seven audited surfaces — verified against the real `kernel-hardened.lisp`, whose proposition-only `%fingerprint` and `as-of`-blind `raise-claim` confirm your §23.5 collision requirement closes a live v1 defect. Every confirmed defect **fragments rather than merges** — the safe direction.

## What blocks READY (nine narrow errata; E1–E5 are the floor)

- **E1 — pin the neutral bytes (HIGH; found independently 4×).** §7.5 names the base scope-calculus material; §7.6/§7.7.2/§7.7.3/§7.8 name nothing, and §7.13 shows `<Mneme temporal model>` / `<self-describing frame>` placeholders. Two clean-rooms therefore cannot produce byte-identical octets for the *fully neutral claim* your §8.7/§26.3/P001–P002 promise. Name the four base references as §7.5 does scope's, and pin the five neutral expressions (universal scope, atemporal, all-members, not-applicable, self-describing frame) as concrete records — in-spec or by normative delegation to the fixture package **with an exact-canonical-octets requirement**; extend §11.7's shared-octets clause beyond scope.
- **E2 — restate the §17.12 floor positively.** "MUST NOT return admissible when target matching *fails*" leaves `relation-undetermined` (a distinct §18.2 category from `target-mismatch`) formally outside the floor. Intended reading is safe (R/F namespace split; §10.3 "unknown relations fail closed"), but one sentence removes all interpretive load: *admissible only if `match_target` returned `R("exact-target")` or `R("supports-by-scope-narrowing")`*; list `relation-undetermined` as hard-inadmissible.
- **E3 — version-bump tie-break.** §19.3's "any reinterpretation of an identity-bearing field requires a new identity-policy version" collides with §2.4/§7.9/§19.10 (policy bumps only on projection change; normalization change → profile version) for a normalization-contract revision. Add: *normalization-contract changes with an unchanged field set bump the claim-profile version only; identity-policy versions change only on field-set/role changes.* Companion: require profile conformance evidence to bind an immutable normalizer content identity + a mutation vector per revision (closes the revised-normalizer-under-same-integer hole for un-vectored inputs).
- **E4 — replicate §11.4's normalization discipline** (total, deterministic, versioned, loss-preserving, pre-projection) into §12 (subject-time), §13 (frame), §14.5 (slice); add a MUST that a proposition with no meaning-bearing context uses the neutral frame. Without it, a denotationally-inert frame or a co-denoting time encoding conformingly fragments ClaimIds.
- **E5 — wider-branch failure codes + nonmonotone vector.** §10.6's `require target_schema_is_downward_scope_monotone` and `require target_boundaries_cover_scope` have no §18 codes (`ClaimTargetMismatch` is otherwise unreachable and says the wrong thing). Add `ScopeNarrowingNotDeclared` + a coverage-failure code; add a required negative vector: broad target, nonmonotone proposition form → refusal.
- **E6 —** declare intra-rank multi-fault precedence (§18.9 ranks 1 and 6): schema field order, or explicitly unspecified-in-/0 and excluded from conformance.
- **E7 —** per reference domain: exactly one canonical scheme in the base profile, or a mandatory registered total bridge (elevating §11.3's doctrine to all fourteen domains named by your own text).
- **E8 —** reword §20.11 unconditionally (its "when … not satisfied" conditional weakens CD/0 §10.7's *never* at the LCI layer; your own §17.16/§8.4 already say *never*).
- **E9 —** echo ruling §16.4's migration-vector categories (Unicode non-normalization, printer-setting variation, hostile legacy payloads) into §23.5/§25.3, and map §23.2's seven classifications onto ruling §16.1's five in one sentence.

## The fixture package is a precondition, not an erratum

Your §29.3 already says "frozen fixture calculi initially" — this review makes the list exact. Before any implementation agent is engaged, the author (never the implementer) must freeze, with exact canonical octets and acceptance tests: **(1)** Mneme proposition grammar/normalizer — including syntactic subject-vs-locator marking so §5.10/`proposition_location_consistent` is structural, and a canonical placement rule for quantifier domains and horizons; **(2)** scope calculus (+ the §11.7 seven vectors, a bridge-less second calculus, an `unknown` case, ≥1 monotone-form declaration); **(3)** temporal model (instant/interval/atemporal bytes); **(4)** slice + boundary calculi (all-members / not-applicable bytes) and corpus/revision schemes; **(5)** frame schema (+ neutral frame bytes + the two Scenario-6 frames); **(6)** all **fourteen** StableRef schemes your text names (scope-calculus, temporal-model, slice, boundary, frame-schema, logical-corpus, corpus-revision, module, procedure, model, prompt/invocation, artifact, principal, policy) per §14.1's MUST list; **(7)** closed record shapes for the eleven target kinds + the monotonicity-declaration mechanism (P013–P021 presuppose them); **(8)** frozen Policy-A/Policy-B (§24.7, frozen rather than illustrated); **(9)** v1 migration mappings — frozen symbol/package→identifier table, `as-of`-site→role table, the non-evaluating legacy parser, the §23.5 collision fixtures. Plus three gaps found during audit: LCI-layer resource-budget numbers (N032 is unwritable without them); the claim-occurrence/artifact nonidentity-metadata subrecord schema (without it §17.4's metadata-neutrality law is untestable); per-operation `RepresentedLoss/0.account` schemas.

## What we tried to break and could not (so you don't re-litigate it)

Corpus/world basis collision (structurally disjoint records); proposition/basis and proposition/scope duplication-disagreement (§5.10 refuses — "which wins" = neither); temporal containment as direct matching (blocked at four layers; `contains` has *no consumer in the matcher*); v1 fingerprint→ClaimId (cannot even populate the envelope); warrant revival by shape/registry/reconstruction (≥8 layers incl. hard-false `live-warrants-created`); digest-replaces-envelope (recomputation mandatory); all five mutable-alias classes (each named in your text); unknown-field ignoring (four layers); scope widening by policy (§17.11 is policy-proof); `as-of` residual overload (none found). Executability matrix: 148 fully-executable / 46 fixture-gated / 20 deferred-sufficient / 2 underdetermined / **0 contradictory** classified rows.

## One-line asks, restated

1. Adopt **LCI/0 Errata 0.1** covering E1–E5 (E6–E9 in the same pass, recommended).
2. Freeze and publish the **fixture package** (items 1–9 + 3 gaps) under your signature, with exact canonical octets and the acceptance tests above.
3. Then authorize the independently seeded Common Lisp and Python implementations per §29 — this review found nothing in the selected model itself that should delay them beyond those two gates.

Full documents: `FABLE-LCI0-CONSTITUTIONAL-REVIEW.md` (22 sections) and `FABLE-LCI0-ISSUE-REGISTER.md` (12 issues, all eight fields each, annex hashes). No change was made to the specification, CD/0, v1, or any frozen artifact.

— **Claude Fable 5**, 2026-07-13
