# LCI/0 POST-REVIEW RULING

**Document:** `LCI0-POST-REVIEW-RULING.md`  
**Date:** 2026-07-14  
**Status:** AUTHORIAL CONSTITUTIONAL RULING AFTER INDEPENDENT FABLE REVIEW  
**Candidate specification:** `LOCATED-CLAIM-IDENTITY-SPEC.md`  
**Candidate SHA-256:** `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`  
**Frozen CD/0 reference packet SHA-256:** `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81`  
**Consultation packet SHA-256:** `e2740dc037837a539e3b1b7d6e07675c139263e2b6f41ee579d85e5efcdbaaf2`  
**Repository readback commit:** `56f0ce55253ef8dd4caaf80b03e49835c4087406`

## 1. Holding

The independent verdict `NARROW-ERRATA-REQUIRED` is **accepted**. Every Fable issue I01–I12 is adjudicated below. E1–E9 are accepted in one narrow Errata 0.1 pass; all five I12 clarifications are incorporated. No issue is rejected.

The constitutional model is not reopened. The audit result remains:

```text
20 adversarial counterexamples
0 BREAK
0 contradictory sections
```

The selected model remains exactly:

```text
ClaimId =
  identity-policy
  claim-profile
  normalized proposition
  location {
    scope,
    subject-time,
    basis,
    interpretation-frame,
    profile-location
  }

WarrantTarget =
  complete ClaimId
  plus typed evidence-kind-specific boundaries
```

Claimant, issuer, provenance, lineage, procedure history, admissibility policy, standing, revocation, and live authority remain outside ClaimId unless literally asserted in the proposition or introduced by a later approved semantic profile. The review found wording gaps and fixture-gated semantics; it did not find a counterexample that breaks this ownership boundary.

## 2. Record reviewed

The author reviewed the complete candidate, all three Fable reports, all seven jurisdiction annexes, the sealed CD/0 dependency packet, and both packet manifests. The controlling identities are the hashes above. The review-artifact receipts are:

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| review/FABLE-LCI0-CONSTITUTIONAL-REVIEW.md | 28151 | 65a989381fce365ba7057f07f6511e7a606ab4d2f2b4b052acda07dd11d1a50e |
| review/FABLE-LCI0-ISSUE-REGISTER.md | 18738 | a22e9f430c32f96472c4fcbe327309fb343a498094e47f486c00359a92221806 |
| review/FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY.md | 8738 | 9502d24b03675db1d8b5fd7788ebfb50ea31ab9e452d8a440f3e935fd5b9ef03 |
| annexes/CUSTODIAN.md | 32301 | 38d8b8bdee91178bcaa38f2efb673201f9c03e1a14236ea40729461b17544b96 |
| annexes/FERRYMAN.md | 36655 | 4aee7d1c13322a51c74547762b05ad847e2d431c564e0e6f82b95c5ba2d21f8e |
| annexes/GEOMETER.md | 37027 | 0159b18cd96158ae209cb8abd54d1a102ae0236ce9877c7f52378957865fc86a |
| annexes/KNIFE.md | 36086 | cf03312a21824db32fd79e86e445e77cafe2e5f2173c298241fb434145f4c7cf |
| annexes/SECOND-KNIFE.md | 38155 | 8f8d0c9f7aad8e7da721b40c0cdf5458b0f4b536f0a354f29a86b0787be28ef4 |
| annexes/SURVEYOR.md | 92476 | b619b9997597ba4c2102b6e1770767afab81a6995a5363370d6dd122619f461a |
| annexes/WARDEN.md | 42267 | 43aefb186bfc5438e047d73f6c88b243be3f85e3ba34987bce4db82e5a7e95bf |

The outer packet manifest and every listed inner dependency checksum were also verified before adjudication. Repository `main` is not an authority for this ruling; the recorded commit and sealed packet are.

## 3. Issue-by-issue adjudication

| Issue | Disposition | Authorial ruling |
| --- | --- | --- |
| I01 | ACCEPT | The base references and five neutral values were semantically named but not authoritatively byte-pinned. E1 now pins the complete values and delegates their machine form to exact registry entries. The selected projection is unchanged. |
| I02 | ACCEPT — wording seam only | The whole specification already intended fail-closed behavior, so no prior successful target relation is reversed. E2 replaces the negative phrase with an exhaustive positive gate over exactly two R-valued outcomes. |
| I03 | ACCEPT WITH TIE-BREAK | The version axes needed an ownership rule. E3 assigns projection/field ownership to identity-policy and proposition/normalization meaning to profile/frame versions, binds immutable normalizer content evidence, and preserves the bug-fix carve-out only for behavior-preserving corrections. |
| I04 | ACCEPT | Scope had a stronger pre-projection discipline than subject-time, frame, slice, and boundary. E4 makes the discipline uniform and pins the neutral frame requirement. |
| I05 | ACCEPT AS FIXTURE-PACKAGE GATE | This is not a defect in the ClaimId field set. The first implementation profile must make proposition-versus-location placement structural and closed; §1 of the fixture package now does so. |
| I06 | ACCEPT | The wider-target branch lacked exact failure vocabulary and negative witnesses. E5 adds the two required typed failures and executable companion vectors. |
| I07 | ACCEPT; OPTION ONE SELECTED | The author selects deterministic schema-field order rather than excluding multi-fault inputs. E6 specifies a total within-rank walk for every closed record. |
| I08 | ACCEPT WITH PROFILE-BOUND QUALIFICATION | Unconstrained StableRef multiplicity is legitimate in a future ecosystem but unsuitable for a shared first implementation. E7 closes each of fourteen fixture domains to one namespaced structural scheme without constitutionalizing a production-global identity system. |
| I09 | ACCEPT | E8 removes the conditional wording. Digest equality never defines semantic ClaimId equality, even for a digest scheme that resolves collisions operationally. |
| I10 | ACCEPT | E9 restores every migration vector category required by the earlier ruling and supplies a total reconciliation from seven LCI terms to the five prior-ruling terms. |
| I11 | ACCEPT | E9 and fixture §9 add plausible-but-ambiguous as-of, near-miss identifier, syntactically-valid/semantically-wrong mapping, Unicode, printer perturbation, and hostile-payload witnesses. |
| I12 | ACCEPT ALL FIVE CLARIFICATIONS | The reserved profile-location exception, policy meta-testimony marker, LCI failure namespace, recursive version closure, and inert/live future debt are all incorporated without model expansion. |

### 3.1 I01 — byte-pinning

Accepted because two conforming constructors could choose different base StableRefs or neutral expressions while still satisfying the candidate prose. The smallest witness is the fully neutral claim: a differing temporal-model StableRef produces a differing SubjectTime and therefore a differing ClaimId. E1 cures construction determinacy by pinning the complete abstract values and canonical octets; it does **not** alter the ClaimId projection.

### 3.2 I02 — positive admissibility floor

Accepted as a wording repair, not as a reversal of an earlier success case. `relation-undetermined` was already F-valued and fail-closed on a whole-document reading. E2 makes the gate observable: only `R("exact-target")` and `R("supports-by-scope-narrowing")` can reach policy evaluation. A policy may still reject either success. It cannot resurrect an F-valued result.

### 3.3 I03 — version governance

Accepted with a narrower tie-break than Fable’s suggested shorthand. Identity-policy owns the field set, field ownership, projection role, and identity projection. Claim-profile and frame-schema versions own proposition grammar, normalization contract, semantic interpretation, and proposition/location consistency while the projection field set is unchanged. A meaning-preserving implementation correction may keep both versions only when conformance evidence proves no accepted abstract input, normalized proposition, ClaimId, relation, or failure changed. The implementation binary is never placed in ClaimId.

### 3.4 I04 and I05 — normalization and placement

Both are accepted. E4 establishes a uniform pre-projection normalization contract. I05 is discharged by the fixture package rather than by inventing another ClaimId field: the normalized proposition grammar marks each semantic occurrence as proposition content or an external ClaimLocation locator, and the consistency predicate is structural.

### 3.5 I06 and I07 — target failures and precedence

Both are accepted. E5 creates `ScopeNarrowingNotDeclared` and `ScopeNarrowingCoverageInsufficient`; neither path may collapse into `ClaimTargetMismatch`, `ScopeWideningForbidden`, or an implementation-local result. E6 chooses deterministic closed-schema field order and depth-first recursion for multi-fault inputs. This expands observable refusal determinacy, not the successful ClaimId domain.

### 3.6 I08 — StableRef closure

Accepted only as a first-profile closure. The fourteen schemes are explicitly namespaced below `Id(["lisp-plus","lci","0","fixture"], …)`. They are finite structural fixture schemes, not claims of universal global identity. Future production schemes and bridges require separate constitutional or profile approval.

### 3.7 I09 — digest authority

Accepted unconditionally. A digest may serve as an operational lookup reference under a separately named cryptographic scheme. It never becomes the definition of semantic ClaimId equality. Semantic equality remains validated ClaimId-envelope equality witnessed by canonical CD/0 octets.

### 3.8 I10 and I11 — migration vocabulary and adversarial surface

Both are accepted. The seven LCI classes are mapped to the prior five classes with explicit qualifications, and the migration suite now includes Unicode non-normalization, ambient printer perturbation, hostile payloads, plausible ambiguity, near-miss and semantically wrong mappings, three legacy fingerprint collision dimensions, inert predecessor warrants, and attempted live restoration.

### 3.9 I12 — low-severity clarifications

All five are incorporated:

1. Empty Mneme/0 `profile-location` is a reserved forward-compatible slot and an explicit exception to the per-claim minimality test. It remains identity-bearing because the profile schema owns future profile coordinates.
2. A policy-evaluation target records the inner target-relation result and declares `meta-testimony`; it is not direct support for the embedded claim.
3. `PrivilegedRestorationAttempt` is an LCI failure code in the LCI namespace. It neither replaces nor reinterprets a CD/0 category.
4. Unsupported nested calculus, model, reference, target, account-schema, and schema versions fail closed recursively.
5. Structural separation of inert and live warrants is mandatory debt of the later warrant constitution. The identity implementation may not improvise revival, standing, or live authority.

## 4. Errata obligations versus fixture-package obligations

**Normative Errata 0.1** repairs or pins statements that belong to LCI/0 itself: base/neutral construction values, admissibility floor, version ownership, pre-projection discipline, scope-narrowing failure vocabulary, deterministic failure precedence, base-profile StableRef closure and bridge law, digest wording, migration classification reconciliation, and the I12 clarifications.

**The normative fixture package** supplies the finite semantic machinery deliberately absent from the constitutional core: the small Mneme proposition grammar and normalizer, concrete calculi, relation tables, closed target schemas, Policy-A and Policy-B, inert v1 migration grammar and mapping tables, resource budgets, occurrence wrapper, and closed RepresentedLoss accounts. These fixtures are incorporated by exact registry and vector artifacts. They are not optional examples and may not be replaced by implementer invention.

## 5. No change to frozen CD/0

This ruling and Errata 0.1 change **no CD/0 value, octet, equality rule, decoder behavior, resource category, failure precedence, or version**. The frozen CD/0 format remains `/0`; its document magic, tags, UVAR/SVAR rules, UTF-8 treatment, record ordering, exact-decoder behavior, and failure surface remain untouched.

No previously specified CD/0 canonical octet string is changed. Newly pinned LCI fixture values receive their first authoritative octets by applying the already frozen CD/0 grammar.

## 6. Fixture schemes are not production identity schemes

The structural StableRef schemes in this packet exist solely to make the first Common Lisp and Python implementations converge. They use explicit material records rather than a selected production hash. They do not choose a production cryptographic algorithm, do not claim global uniqueness outside the fixture namespace, and do not settle future cross-registry governance.

A future production identity scheme may coexist only under a distinct domain/scheme identifier and an approved migration or bridge. It cannot reinterpret these fixture octets in place.

## 7. Version and change boundary

| Question | Errata 0.1 result |
| --- | --- |
| ClaimId field set | UNCHANGED |
| ClaimId projection | UNCHANGED |
| WarrantTarget field set | UNCHANGED |
| Accepted previously determinate ClaimId envelopes | UNCHANGED |
| Canonical octets for already fully specified values | UNCHANGED |
| CD/0 | UNCHANGED; remains /0 |
| LCI envelope version | UNCHANGED; remains /0 |
| Identity-policy version | UNCHANGED; remains 0 |
| Claim-profile version | UNCHANGED; remains 0 |
| Newly pinned fixture values | Receive first authoritative abstract values and octets |
| Wording/failure gaps | Closed by Errata 0.1 and vectors |

Errata 0.1 therefore changes no previously determinate ClaimId. It narrows previously underdetermined construction choices to one first-profile value and makes previously ambiguous refusal paths observable.

## 8. Required post-review decisions

1. **Are all Fable E1–E9 findings accepted?** Yes. All nine are accepted and discharged by the errata plus the package identified in this ruling.
2. **Which I12 clarifications are incorporated?** All five: reserved profile-location, policy meta-testimony, failure-namespace separation, recursive nested-version closure, and inert/live future debt.
3. **Does Errata 0.1 change any previously determinate ClaimId?** No.
4. **Are the neutral and base fixture octets now fully pinned?** Yes. E1 states all ten complete abstract values and octets; the machine registry repeats them with decoded-value expectations, byte counts, and non-semantic checksums.
5. **Is the fixture package complete enough for two independent implementations?** Semantically, yes: no implementer choice remains for the declared first-profile domain. Procedurally, implementation remains blocked until Fable verifies this exact packet and returns PASS.
6. **Which systems remain intentionally deferred?** Production cryptography, production StableRef governance, the complete Mneme logic, full warrant/standing/revocation/live-authority calculus, production admissibility law, active v1 runtime migration, and capability/module/registry authority semantics.
7. **Is implementation now authorized, subject to Fable verification?** Not at issuance. Authorization becomes effective only when Fable returns PASS against the exact hashes of this packet; no new authorial redesign round is required if Fable finds no blocker.
8. **What must Fable verify before Codex begins?** The checklist in §10, including exact-byte recomputation, package completeness, vector execution, and the frozen Common Lisp verification pass.

## 9. Intentional deferrals and future gates

The following remain outside this ruling:

- A production digest or cryptographic identity algorithm. Gate: a separate scheme specification with collision, agility, and envelope-resolution law.
- A universal production StableRef ontology or automatic cross-scheme equivalence. Gate: explicit stable versioned bridges and migration evidence.
- The complete Mneme proposition logic. Gate: an approved profile with grammar, normalizer content identity, mutation corpus, and projection ledger.
- Warrant issuance, standing, revocation, live authority, and inert/live registry architecture. Gate: the later warrant constitution; identity code cannot fill the gap.
- Production admissibility policy. Gate: a separately governed policy system; Policy-A and Policy-B are test fixtures only.
- Executing or importing the v1 runtime. Gate: a migration implementation phase after identity implementation conformance; the present grammar remains inert and non-evaluating.

## 10. Fable verification gate and implementation authorization

Implementation becomes authorized only when Fable issues a PASS receipt that identifies the exact SHA-256 of all seven primary artifacts and confirms all of the following:

1. E1–E9 and all five I12 clarifications are present without reopening ClaimId or WarrantTarget.
2. Every registry definition and vector input/expected output has a valid complete CD/0 document, lowercase hex, decoded abstract value, byte count, and checksum.
3. The ten E1 values are independently recomputed and byte-identical.
4. All fourteen StableRef domains have exactly one canonical fixture scheme, alias refusal, version rule, represented-loss rule, and tested no-bridge/bridge behavior.
5. The normalized proposition grammar, placement rules, calculi, target schemas, policies, migration tables, budgets, occurrence schema, and loss-account schemas are closed and executable.
6. All `P001–P030`, `N001–N032`, and every added errata/fixture vector are present, uniquely identified, and produce the exact typed result or failure.
7. The frozen repository Python CD/0 implementation at `56f0ce55253ef8dd4caaf80b03e49835c4087406` reproduces every document; this authoring packet records PASS over 1,105 documents.
8. The frozen repository Common Lisp CD/0 implementation at `56f0ce55253ef8dd4caaf80b03e49835c4087406` is rerun with `sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp` plus a fixture-corpus adapter, and reproduces every document. This authoring environment has no Common Lisp runtime, so this exact rerun is a visible authorization gate rather than an implied success.
9. ZIP and TAR.GZ member sets are identical and all members satisfy `LCI0-FIXTURE-SHA256SUMS.txt`.
10. Fable reports no placeholder, local semantic choice, silent version fallback, or production-crypto selection.

A PASS satisfying those conditions automatically releases only the implementation scope in §12. A FAIL or BLOCKED receipt leaves implementation unauthorized and must identify exact artifact, section, fixture/vector ID, and counterexample.

## 11. Decision receipt

```yaml
decision: LCI0-authorial-post-review-ruling
issued: 2026-07-14
candidate_sha256: 6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba
frozen_cd0_packet_sha256: bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81
consultation_packet_sha256: e2740dc037837a539e3b1b7d6e07675c139263e2b6f41ee579d85e5efcdbaaf2
repository_commit: 56f0ce55253ef8dd4caaf80b03e49835c4087406
fable_verdict_received: NARROW-ERRATA-REQUIRED
fable_issues:
  I01-I11: accepted
  I12: accepted-all-five-clarifications
errata_findings:
  E1-E9: accepted
adversarial_result:
  break: 0
  contradictory_sections: 0
selected_model_reopened: false
cd0_changed: false
lci_format: /0
implementation_status: blocked-pending-fable-pass
```

## 12. Implementation handoff

# NOT AUTHORIZED UNTIL FABLE VERIFIES ERRATA AND FIXTURE PACKAGE

After—and only after—Fable PASS, Codex is authorized to begin independently seeded Common Lisp and Python LCI/0 implementations against the shared frozen fixture package, with differential ClaimId projection and target-matching tests and inert v1 migration fixtures. That authorization excludes production warrant, standing, revocation, cryptography, module/capability authority, and live-migration work, and excludes every modification to CD/0.
