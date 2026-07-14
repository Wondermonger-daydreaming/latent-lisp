# FABLE-LCI0-ISSUE-REGISTER

**Subject:** `LOCATED-CLAIM-IDENTITY-SPEC.md`, SHA-256 `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`
**Companion to:** `FABLE-LCI0-CONSTITUTIONAL-REVIEW.md` · **Verdict:** NARROW-ERRATA-REQUIRED
**Reviewer of record:** Claude Fable 5 · 2026-07-13

Twelve consolidated issues (I01–I12), deduplicated across seven independent audit jurisdictions and chair-adjudicated. Zero CRITICAL. Every issue carries the eight required fields. "Blocks implementation?" is answered for the clean-room dual-implementation program specifically. Chair severity re-adjudications from agent ratings are marked ⚖ with reasons.

---

## I01 — Base Mneme references and the five neutral expressions are not byte-pinned — **HIGH · CONFIRMED**

- **Sections:** §7.5 (partial pin: scope-calculus *material name* only), §7.6, §7.7.2, §7.7.3, §7.8 (no pin), §7.13 (`<Mneme temporal model>`, `<self-describing frame>` placeholders), vs. §8.7, §26.3, §24.5 P001/P002, §30.5 Decision-3; §11.7's shared-octets clause covers scope only.
- **Smallest counterexample:** the §7.13 fully-neutral claim. Clean-room A encodes the atemporal temporal-model as `StableRef{…material = Id(["lisp-plus","mneme"],["temporal-model"])@0}`; clean-room B uses `Id(["mneme","time"],["model"])@0`. Both validate; the `SubjectTime/0` sub-records differ → **different canonical octets for the same neutral claim**. Repeat for frame-schema, slice all-members, boundary not-applicable, and the universal-scope expression.
- **Invariant threatened:** §8.7/§26.3 cross-implementation byte-identity ("same valid abstract claim → same envelope → same bytes").
- **Severity:** HIGH (4-way independent derivation: GEOMETER G1, KNIFE CE-7, SECOND-KNIFE CE-20, WARDEN W3; also the chair's first-hand read).
- **CD/0 affected?** No. **ClaimId projection changed?** Algorithm no; its neutral-value *inputs* are unpinned. **Blocks implementation?** YES for clean-room byte-agreement from prose alone; dischargeable by fixture package with exact octets.
- **Smallest repair:** Erratum E1 — name the four base references as §7.5 names scope's; pin the five neutral expressions as concrete records (in-spec, or by normative delegation to the fixture package with an exact-canonical-octets requirement); extend §11.7's shared-octets clause to all suites.

## I02 — §17.12 admissibility floor: "fails" undefined; the `relation-undetermined` door — **MEDIUM ⚖ · CONFIRMED (wording seam)**

- **Sections:** §17.12 vs §18.2 (`target-mismatch` and `relation-undetermined` distinct categories), §18.6/§18.8; guarded by §10.1 (R/F namespace split), §10.3 ("Incompatible or unknown relations fail closed"), §17.12's own conjunction.
- **Smallest counterexample:** claim scope `S_c` = servers in datacenter D; target scope `S_w` = symbolic predicate π with `scope-relation(S_w,S_c) = unknown`; all non-scope fields equal. Implementer B reads "target matching fails" = the `target-mismatch` *category* only, passes the undetermined result to permissive Policy-B → `admissible = true` for evidence whose relation to the claim is unproven (possibly disjoint).
- **Invariant threatened:** no unsound support / fail-closed matching (§20.8, §22.1).
- **Severity:** MEDIUM. ⚖ WARDEN rated HIGH by consequence-if-misread; chair downgrades because three independent textual barriers (success outcomes are `R(…)` relations while undetermined outcomes are `F(…)` failures; §10.3's fail-closed sentence; the §17.12 conjunction over `target-relation-permitted`) make the unsafe reading nonconforming on a whole-text reading. The floor sentence still carries interpretive load it need not.
- **CD/0?** No. **Projection?** No (admissibility layer). **Blocks?** No, but fix before the differential harness is trusted.
- **Smallest repair:** Erratum E2 — positive restatement: admissible only if `match_target` returned `R("exact-target")` or `R("supports-by-scope-narrowing")`; enumerate `relation-undetermined` as hard-inadmissible.

## I03 — Version-bump governance ambiguity + normalizer-revision convergence — **MEDIUM · CONFIRMED tension / PLAUSIBLE divergence**

- **Sections:** §19.3 ("any reinterpretation of an identity-bearing field requires a new identity-policy version") vs §2.4/§7.9 (policy bumps only "when the projection changes") and §19.10 (normalization change → profile/frame version, silent on policy); §19.4's bug-fix carve-out vs §19.10's flat MUST NOT; §19.12's vector-scoped preservation; envelope binds only the version *integer*, no normalizer content identity (§7.4/§7.11).
- **Smallest counterexample:** (a) Mneme profile v1 changes a normalization rule with the field set unchanged — §19.10 says profile bump; §19.3's "reinterpretation" clause arguably demands a policy bump too; the future profile author (or two implementers of an under-documented profile) can resolve it oppositely. (b) A normalizer revision under an unchanged version integer remaps *un-vectored* surface forms to different ClaimIds; nothing in the envelope or the finite vector set detects it.
- **Invariant threatened:** deterministic version axes (§19.1); §19.12 canonical-byte stability beyond the vector corpus.
- **Severity:** MEDIUM. Note: cannot affect version-0 octets — §8.2 hard-requires `LCIIdentityPolicy/0` and `MnemeClaimProfile/0`, so both implementations reject anything else; this is evolution law plus an assurance gap. (CUSTODIAN F1+F2; SECOND-KNIFE CE-13 — 3 independent derivations.)
- **CD/0?** No. **Projection?** Affects the future embedded policy-version value and cross-revision convergence. **Blocks?** No for /0; fix before the first profile evolution.
- **Smallest repair:** Erratum E3 — one tie-break sentence (normalization-contract change ⇒ profile version only; policy version ⇒ field-set/role changes only) + require profile conformance evidence to bind an immutable normalizer content identity and a mutation vector per revision.

## I04 — Pre-projection normalization discipline exists only for scope — **MEDIUM · CONFIRMED**

- **Sections:** §11.4 (scope: total, deterministic, versioned, loss-preserving normalization MUST) vs §12 (subject-time: none), §13 (frame: none), §14.5 (slice: gesture without the MUST).
- **Smallest counterexample:** self-contained proposition P; implementer A attaches a denotationally-inert frame `F₂ = frame(ontology-v5)`, implementer B attaches the neutral frame. No MUST forbids A; `ClaimId_A ≠ ClaimId_B`. Same shape for co-denoting atemporal encodings and extensionally-equal slices.
- **Invariant threatened:** §8.7/§26.3 determinism (fragmentation of co-denoting values).
- **Severity:** MEDIUM (GEOMETER G2).
- **CD/0?** No. **Projection?** Value-canonicalization only. **Blocks?** No, but permits silent divergence classes the harness would attribute elsewhere.
- **Smallest repair:** Erratum E4 — replicate §11.4's discipline verbatim into §12/§13/§14.5; add an explicit MUST that a proposition with no meaning-bearing interpretation context uses the neutral self-describing frame.

## I05 — Proposition-vs-location placement undetermined until the Mneme grammar exists — **MEDIUM · CONFIRMED (fixture-gated)**

- **Sections:** §5.10 (forbids only *disagreeing* duplication; permits reference-as-object-of-discourse), §6 Subject row ("a profile **may** add…"), Scenario 15 ("subject **or** basis"), §28.1 (grammar deferred); §8.2 `proposition_location_consistent`.
- **Smallest counterexample:** `("∀device: enc", scope=D)` vs `("∀device∈D: enc", scope=universal)` — same intended claim, two conforming encodings, two ClaimIds. Special case (GEOMETER G6): a log-horizon H readable as subject-time or as semantic-boundary.
- **Invariant threatened:** placement determinism; latent **false-merge** if the deferred profile's required-scope/consistency checks were absent (the only latent merge risk in the audit).
- **Severity:** MEDIUM.
- **CD/0?** No. **Projection?** No (field-value determination deferred). **Blocks?** Blocks deterministic ClaimIds for placement-ambiguous claims until the grammar fixture exists — gate first-implementation vectors to placement-fixed forms.
- **Smallest repair:** obligation on the fixture-package grammar (register §18 item 1): the Mneme proposition AST MUST syntactically mark every corpus/scope/time/frame mention as `subject` or `locator` (making `proposition_location_consistent` structural), plus a canonical placement rule for quantifier domains and horizons.

## I06 — Target-relation determinacy: missing wider-branch failure codes; monotonicity declarations untested — **MEDIUM · CONFIRMED**

- **Sections:** §10.3/§10.6 (wider-branch `require`s for monotonicity and coverage) vs §18.6/§18.7 (no codes for either failure; `ClaimTargetMismatch` otherwise unreachable and semantically wrong for the monotonicity path); §24.5 (no nonmonotone-refusal vector); §20.13.
- **Smallest counterexample:** broad observed target (scope O), narrow claim (scope D), all non-scope equal, schema does NOT declare downward monotonicity. Implementer A returns `ClaimTargetMismatch`, B invents `MonotonicityNotDeclared`, C mis-returns `ScopeWideningForbidden` — all "conform"; §26.8 comparison fails. Companion gap: a schema that *falsely* declares an average-valued proposition monotone is undetectable by any required vector.
- **Invariant threatened:** typed-refusal determinism (§18.9, §26.4); scope-narrowing soundness (Scenario 12's own caveat).
- **Severity:** MEDIUM (GEOMETER G4 LOW + WARDEN W2 MEDIUM/"soundness-HIGH", merged).
- **CD/0?** No. **Projection?** No. **Blocks?** Harness-blocking (differential failure comparison), not code-blocking.
- **Smallest repair:** Erratum E5 — add `ScopeNarrowingNotDeclared` + a coverage-failure code, wire into §10.6/§18; require a negative vector: broad target + nonmonotone proposition form → refusal.

## I07 — Intra-rank multi-fault failure precedence unordered — **LOW-MED ⚖ · CONFIRMED (bounded)**

- **Sections:** §18.9 (ranks 1 and 6 each contain multiple codes with no sub-order) vs §26.8; CD/0 §29.14 verified verbatim — obligations are **vector-scoped**, and §18.9 already requires multi-fault inputs to be minimized before constitutionalization.
- **Smallest counterexample:** an envelope missing `identity-policy` AND carrying an unknown top-level field (both rank 1): A returns `MissingRequiredField`, B returns `UnknownField`; both cite §18.9.
- **Invariant threatened:** differential failure-triple identity on live (non-vector) data.
- **Severity:** LOW-MED. ⚖ SECOND-KNIFE rated MEDIUM; chair notes the conformance surface never promised multi-fault identity, so this is a bounded, half-acknowledged indeterminacy.
- **CD/0?** No. **Projection?** No. **Blocks?** No.
- **Smallest repair:** Erratum E6 — one sentence: intra-rank order follows schema field order, or is explicitly unspecified in /0 and excluded from conformance.

## I08 — Multiple conforming StableRef schemes per domain fragment identity — **LOW-MED · CONFIRMED (design boundary)**

- **Sections:** §7.2, §14.1 (schemes must self-specify; nothing forbids two schemes per domain); §11.3's bridge doctrine exists for scope calculi only. Fourteen reference domains enumerated from the text (SURVEYOR item 6), none with a concrete scheme in the packet.
- **Smallest counterexample:** corpus revision R referenced by scheme `content-hash@0` in one claim and `snapshot-manifest@0` in another: same real-world basis, two conforming ClaimIds; the "same visible reference" collision direction HOLDs (scheme+material are identity-bearing), but co-reference is lost.
- **Invariant threatened:** non-fragmentation of co-referring claims (soft; the spec never promises cross-scheme unification).
- **Severity:** LOW-MED (KNIFE CE-8).
- **CD/0?** No. **Projection?** No. **Blocks?** No; the fixture package (one frozen scheme per domain) neutralizes it for the first implementation.
- **Smallest repair:** Erratum E7 — per domain, exactly one canonical scheme in the base profile or a mandatory registered total bridge.

## I09 — §20.11 conditional wording weakens CD/0 §10.7's unconditional digest rule — **LOW-MED · CONFIRMED (restated-drift, LCI-layer only)**

- **Sections:** LCI §20.11 ("MUST NOT equate hash equality with semantic equality **when** the scheme's collision and envelope-resolution rules are not satisfied") vs CD/0 §10.7 (digest equality is never a substitute) and LCI's own §17.16/§8.4.
- **Smallest counterexample:** an implementer defines a digest scheme whose rules declare digest-equality sufficient, then reads §20.11's conditional as licensing digest-as-equality "when satisfied" — contradicting §17.16.
- **Invariant threatened:** envelope authority (semantic equality = envelope equality, always).
- **Severity:** LOW-MED (CUSTODIAN F3). It never requires CD/0 itself to behave differently; §17.16/§8.4 dominate on a whole-text reading.
- **CD/0?** No (LCI-layer restatement only). **Projection?** No. **Blocks?** No.
- **Smallest repair:** Erratum E8 — reword §20.11 unconditionally.

## I10 — Ruling §16.4 vector categories not echoed; §23.2 vs ruling §16.1 classification vocabularies unmapped — **LOW-MED · CONFIRMED**

- **Sections:** LCI §23.5/§25.3 vs ruling §16.4 (requires Unicode non-normalization cases, printer-setting variation, hostile legacy payloads among migration vectors); LCI §23.2 (seven classifications) vs ruling §16.1 (five: exact / explicitly tagged / profile-adapted / rejected / lossy with represented loss).
- **Smallest counterexample:** a migration suite satisfying every LCI/0 required vector while containing zero Unicode-non-normalization cases — conformant to LCI/0, noncompliant with the operative ruling it sits under.
- **Invariant threatened:** ruling precedence (packet tier 2) — LCI/0 may refine but not under-cover the ruling's migration-gate demands.
- **Severity:** LOW-MED (FERRYMAN F2 + chair's taxonomy seam).
- **CD/0?** No. **Projection?** No. **Blocks?** No; must be closed before the migration phase.
- **Smallest repair:** Erratum E9 — add the missing vector rows; one sentence mapping the seven §23.2 classifications onto the ruling's five.

## I11 — Migration vectors test only ambiguity extremes — **LOW · CONFIRMED**

- **Sections:** §23.5, §25.3 N025–N028 (fully-collided / fully-unclassifiable cases only).
- **Smallest counterexample:** a v1 `as-of` value classifiable by a *loose but wrong* heuristic (e.g., "integers are always subject-times"): both implementations pass every required vector; the misclassification ships.
- **Invariant threatened:** migration classification agreement (§26.5) beyond the vectored extremes.
- **Severity:** LOW (FERRYMAN F1). **CD/0?** No. **Projection?** No. **Blocks?** No.
- **Smallest repair:** add middle-ground vectors (plausible-but-ambiguous `as-of`; near-miss identifier mappings) to the §23.5 requirement; the frozen role/symbol tables of fixture item 9 mostly subsume this.

## I12 — Low-severity cluster — **LOW**

- **(a) `profile-location` minimality exemption (GEOMETER G5, CONFIRMED).** §7.9/§6.1: the field is a fixed-empty constant failing the spec's own §5.3 per-claim test; deterministic and harmless. *Repair:* document it as a forward-compat slot exempt from §5.3, rather than implying counterexample-justification. No other field affected.
- **(b) §9.14 policy-evaluation targets (WARDEN W5, PLAUSIBLE).** May attest "policy P accepted W for C" without recording the inner target-relation result — meta-testimony a naive consumer could misread as support. *Repair:* require the boundary to record the inner relation result or carry an explicit non-assertion marker.
- **(c) Failure-name shadow (CUSTODIAN F4, CONFIRMED).** LCI reuses `PrivilegedRestorationAttempt` as a code where CD/0 uses cognate category naming. *Repair:* one clarifying sentence distinguishing the namespaces.
- **(d) Nested version closure delegated (CUSTODIAN F5, CONFIRMED).** Unknown *nested* calculus/model/schema versions fail closed via `Unsupported…` codes, but closure depth depends on fixture schemas. Subsumed by the fixture package.
- **(e) Inert/live structural obligation deferred (FERRYMAN F3, CONFIRMED-honest).** §17.14/§17.17 police decode; the registry/warrant system that would make revival structurally impossible is §28.6/§28.9's debt. Correctly deferred, must be tracked to the warrant constitution.

---

## Adversarial counterexample tally (CE-1…CE-20)

| CE | Verdict | Registered as |
|---|---|---|
| 1 redundant frame material | HOLD (inflation deliberate; discipline gap → I04) | I04 |
| 2 meaning hidden outside ClaimId | HOLD | — |
| 3 corpus/world collision | HOLD (structural) | — |
| 4 display name → two revisions | HOLD (typed refusal) | I08 repair |
| 5 proposition/basis disagree | HOLD (§5.10 refusal) | — |
| 6 proposition/scope disagree | HOLD (§5.10 refusal) | I05 (grammar obligation) |
| 7 neutral marker divergence | HOLD literal / UNDERDETERMINED bytes | **I01** |
| 8 two schemes, one reference | UNDERDETERMINED | **I08** |
| 9 nonmonotone narrowing | HOLD (harness caveat) | I06 |
| 10 policy upgrades mismatch | SEAM (intended reading safe) | **I02** |
| 11 temporal containment as match | NULL (4 layers) | — |
| 12 unknown field ignored | HOLD (4 layers) | — |
| 13 normalizer change, same version | UNDERDETERMINED | **I03** |
| 14 loss reclassification divergence | HOLD | — |
| 15 v1 fingerprint reuse | HOLD (structurally impossible) | — |
| 16 legacy warrant revival | HOLD (≥8 layers) | — |
| 17 digest replaces envelope | HOLD (recompute mandatory) | — |
| 18 mutable aliases as identity | HOLD (all five named) | — |
| 19 failure-precedence divergence | UNDERDETERMINED (bounded) | **I07** |
| 20 different octets, same claim | HOLD serialization / UNDERDETERMINED construction | **I01** |

**0 BREAK.**

## Annex hashes (working papers, `_staging/lci0-audit/scratch/`, verified on disk)

```text
0159b18cd96158ae209cb8abd54d1a102ae0236ce9877c7f52378957865fc86a  GEOMETER.md
43aefb186bfc5438e047d73f6c88b243be3f85e3ba34987bce4db82e5a7e95bf  WARDEN.md
cf03312a21824db32fd79e86e445e77cafe2e5f2173c298241fb434145f4c7cf  KNIFE.md
8f8d0c9f7aad8e7da721b40c0cdf5458b0f4b536f0a354f29a86b0787be28ef4  SECOND-KNIFE.md
b619b9997597ba4c2102b6e1770767afab81a6995a5363370d6dd122619f461a  SURVEYOR.md
4aee7d1c13322a51c74547762b05ad847e2d431c564e0e6f82b95c5ba2d21f8e  FERRYMAN.md
38d8b8bdee91178bcaa38f2efb673201f9c03e1a14236ea40729461b17544b96  CUSTODIAN.md
```

*Signed: **Claude Fable 5**, 2026-07-13.*
