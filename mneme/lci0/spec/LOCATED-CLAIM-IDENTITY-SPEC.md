# Lisp+ Located Claim Identity /0

## Normative specification for Lisp+ and the Mneme profile

**Abbreviation:** LCI/0  
**Document:** `LOCATED-CLAIM-IDENTITY-SPEC.md`  
**Status:** constitutional design decision; implementation-independent normative specification  
**Canonical-datum dependency:** Lisp+ Canonical Datum /0, frozen at merge tree `13871b0b0ec81e667611163bc78976b3a91ff4b7`  
**Decision date:** 2026-07-13

---

## Conformance language and notation

The words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are used only for behavior that can be observed by a conforming producer, validator, projector, matcher, migration adapter, or test harness. Explanatory statements that do not define an observable result use ordinary lowercase prose.

This document uses diagnostic CD/0 notation. Diagnostic notation is not an identity authority. In particular:

```text
Id([namespace-segment, ...], [path-segment, ...])
Record{ key => value, ... }
Seq[value, ...]
Bytes[hex-octets]
Unit
```

For compact examples, define:

```text
K(name) = Id(["lisp-plus", "lci", "0"], [name])
T(name) = Id(["lisp-plus", "lci", "0", "tag"], [name])
R(name) = Id(["lisp-plus", "lci", "0", "relation"], [name])
F(name) = Id(["lisp-plus", "lci", "0", "failure"], [name])
```

The displayed order of record fields is explanatory only. CD/0 record equality and canonical field ordering remain exactly as frozen by Canonical Datum /0.

---

# 1. Executive decision

LCI/0 selects one model.

A proposition is normalized semantic content. A located claim is that proposition paired with the semantic coordinates that determine which situated assertion exists. A ClaimId is the exact CD/0 identity envelope of that pair under a named claim profile and identity-policy version. The ClaimId is the envelope itself, not a hash. A later compact identifier may hash a domain-framed canonical encoding of the envelope, but hash collision resistance is a separate cryptographic property and never defines semantic sameness.

The smallest sufficient LCI/0 ClaimId contains exactly:

```text
ClaimIdEnvelope =
  identity-policy
  claim-profile
  proposition
  location = {
    scope,
    subject-time,
    basis,
    interpretation-frame,
    profile-location
  }
```

Every field is required. Mneme LCI/0 uses an empty `profile-location` record. There are no optional identity fields in version 0. An explicit neutral value is used when a coordinate is semantically neutral: universal scope, atemporal subject-time, world basis, self-describing interpretation frame, and an empty profile-location record. Omission and explicit Unit are not aliases for those neutral values.

Changing any of the following creates a different ClaimId: normalized proposition; claim-profile version; identity-policy version; exact scope or scope-calculus identity; proposition subject-time or temporal-model identity; a semantic corpus, immutable corpus revision, dataset slice, or closed-world completion boundary; interpretation frame; or any profile-approved identity-bearing location component.

Changing only claimant, issuer, assertion event, observation event, execution history, evidence procedure, code version used to obtain evidence, model or prompt used as evidence, admissibility policy, validity state, revocation state, current standing, provenance, lineage, display spelling, or identity-neutral presentation metadata preserves ClaimId. Such changes may create a different claim occurrence, warrant, provenance record, lineage edge, admissibility result, or standing result.

A WarrantTarget is not identical to ClaimId. It is a typed family whose common nucleus contains a complete ClaimId and whose kind-specific boundary record can additionally bind procedure, immutable code, module, model, prompt or invocation, observation or execution time, corpus-completion conditions, derivation premises, external artifact, replay event, translation receipt, policy evaluation, or other evidence-specific boundaries. A warrant never targets less than a complete ClaimId.

One warrant can bear on more than one located ClaimId only in two LCI/0 cases:

1. the claims have exactly the same ClaimId, even if they are distinct assertion occurrences; or
2. the warrant targets a broader scope and a separately versioned scope calculus proves that the candidate claim is a narrowing, the exact target schema declares downward scope monotonicity for that target kind and normalized proposition form, every non-scope ClaimId coordinate is exactly equal, all kind-specific boundaries remain satisfied, and the selected admissibility policy permits the projection.

LCI/0 does not permit generic temporal widening or narrowing, corpus substitution, interpretation-frame substitution, proposition equivalence, translation, or policy substitution during direct target matching. Those require an explicit derivation, translation, replay, or other new warrant.

Scope and time are compared as immutable CD/0 values interpreted by explicit versioned calculi. Host pointer identity, package identity, object identity, display names, and ambient registries have no role.

Migration from current v1 never promotes the proposition-only fingerprint into ClaimId and never restores a serialized attestation as a live warrant. Legacy fingerprints, predecessor testimony, and serialized attestation fields remain inert historical evidence. A live successor warrant requires an authorized replay or re-attestation against the complete LCI/0 target.

LCI/0 leaves truth, authority, custody, cryptographic choice, the complete scope logic, the complete temporal logic, warrant admissibility policy, standing lattice, revocation semantics, procedure/module identity schemes, and verified lineage protocols to their own constitutions. It fixes the boundaries those later systems must respect.

---

# 2. Status, scope, and non-goals

## 2.1 Status

This document defines Lisp+ Located Claim Identity /0 and the base Mneme LCI/0 profile. It is intended to be committed as a repository normative artifact after project review.

LCI/0 is a constitutional identity and targeting specification. It defines semantic projections, record envelopes, relation boundaries, typed refusals, migration classifications, and cross-implementation requirements. It stops before full Common Lisp or Python implementation.

## 2.2 Scope

LCI/0 settles:

- the separation among proposition, claim occurrence, located claim, ClaimId, WarrantTarget, Warrant, admissibility, standing, provenance, and lineage;
- the exact ClaimId envelope and projection rules;
- which standard dimensions participate in ClaimId;
- the required scope, temporal, basis, interpretation-frame, and stable-reference interfaces;
- a typed WarrantTarget family and exact/direct target-matching rules;
- represented-loss behavior where identity can or cannot be recovered;
- field evolution and unknown-field behavior;
- migration posture for the current v1 prototype;
- positive and negative shared-vector schemas;
- implementation-independent laws and differential-test obligations.

## 2.3 Non-goals

LCI/0 does not:

- alter CD/0 values, equality, canonical octets, wire grammar, decoder behavior, datum version, errata, or conformance vectors;
- define the full Mneme proposition language;
- define a complete theorem prover or general semantic-equivalence procedure;
- define a complete scope algebra;
- define a complete temporal ontology or calendar/time-scale system;
- choose a hash, signature, key, capability, or cryptographic custody system;
- declare any claim true, authoritative, fresh, admissible, or currently standing;
- define complete WarrantId, warrant-consumption, revocation, or standing semantics;
- define verified lineage or succession authority;
- migrate v1 runtime objects or reanimate serialized warrants;
- constitutionalize the current v1 field layout, printer-derived fingerprint, package conventions, or process-local registries;
- implement Common Lisp or Python libraries.

## 2.4 Profile posture

LCI/0 separates a language-wide identity skeleton from a semantic claim profile that fixes proposition and location meaning. The Mneme LCI/0 semantic profile fixes the profile reference and uses the exact standard location fields defined here, with an empty `profile-location` record. A later semantic profile can add identity-bearing location material only through a new profile version and, when the projection changes, a new identity-policy version. Claim-occurrence, artifact, provenance, lineage, and presentation schemas evolve on separate version axes outside ClaimId.

---

# 3. Evidence and frozen dependencies

## 3.1 Verified packet identity

This decision was produced from the frozen reference packet:

```text
filename:
  lisp-plus-lci0-cd0-frozen-reference-packet-2026-07-13-56f0ce55253e.zip

verified ZIP SHA-256:
  bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81

verified inventory:
  15 files
  381,105 extracted bytes

SHA256SUMS.txt SHA-256:
  3caa90630ee4149d142e39f15b0aff7f5de23c54e0e07087e0f0ca3df16c71d3
```

The ZIP integrity test succeeded. Every member sealed by `SHA256SUMS.txt` matched its recorded checksum. The nested final merge/freeze checksum file also verified all four files it covers.

## 3.2 Repository anchors

```text
CD/0 accepted merge commit:
  efe52efe3e0e5a24181ee324e18b23e266129104

CD/0 frozen implementation tree:
  13871b0b0ec81e667611163bc78976b3a91ff4b7

Final evidence-publication commit:
  56f0ce55253ef8dd4caaf80b03e49835c4087406

Final evidence-publication tree:
  e73d50772b22651df4f9620cd971baaf4de74739
```

The accepted merge preserves provenance and has the reviewed frozen implementation tree. Its publication child adds final receipts, read-back evidence, post-merge verification, the freeze declaration, and checksums. The integration-to-merge content diff was empty.

## 3.3 Evidence precedence applied

LCI/0 applies the packet in the required precedence order:

1. `normative/CANONICAL-DATUM-SPEC.md` and `normative/CANONICAL-DATUM-SPEC-ERRATA-0.1.md`;
2. `normative/CD0-POST-IMPLEMENTATION-RULING.md`;
3. final merge, read-back, verification, Fable, checksum, and freeze evidence;
4. `context/LANGUAGE-BOUNDARY.md` as architectural diagnosis; `context/BOOK-0.md` was read at this contextual tier only as proposed text and supplies no rule that can override the higher sources;
5. `migration-evidence/kernel-hardened.lisp` and `migration-evidence/V1-COUNTEREXAMPLE-CLOSURE.md` only as non-normative migration evidence.

The wrong-remote repository-binding incident described by the custody evidence is historical audit evidence. It does not change the accepted merge, frozen tree, final publication state, or any LCI/0 semantic rule.

## 3.4 Frozen CD/0 dependency

An LCI/0 implementation MUST consume CD/0 without changing:

- the nine CD/0 value families;
- CD/0 structural equality;
- canonical octets;
- the accepted canonical-document set and wire grammar;
- exact canonical decoding and decoder success/failure semantics;
- immutable runtime behavior;
- normative Errata 0.1 behavior;
- shared CD/0 conformance vectors;
- typed CD/0 wire and resource failures;
- the CD/0 format version.

All LCI/0 envelopes are ordinary inert CD/0 records. LCI/0 assigns profile meaning to those records but introduces no new CD/0 type tag or wire form.

## 3.5 Dependency boundary

CD/0 supplies immutable values, structural equality, canonical octets, exact decoding, namespaced segmented identifiers, deterministic projection primitives, and a domain-framed cryptographic preimage interface. CD/0 does not settle proposition identity, claim location, ClaimId, WarrantTarget, scope subsumption, temporal interpretation, admissibility, standing, truth, authority, custody, freshness, module/procedure identity, or verified lineage. LCI/0 does not retroactively attribute any of those meanings to the CD/0 freeze.

## 3.6 Verified artifact inventory consumed

| Packet member | Standing used here | Verified SHA-256 |
|---|---|---|
| `PACKET-MANIFEST.md` | Packet identity, inventory, standing, and precedence | `ead05e926e4a218acc362ab62ea02acd3004cccea5d3617a9742cf1897a655c8` |
| `SHA256SUMS.txt` | Internal checksum authority for sealed members | `3caa90630ee4149d142e39f15b0aff7f5de23c54e0e07087e0f0ca3df16c71d3` |
| `normative/CANONICAL-DATUM-SPEC.md` | Frozen normative CD/0 base | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| `normative/CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | Frozen normative errata | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| `normative/CD0-POST-IMPLEMENTATION-RULING.md` | Operative frozen post-implementation ruling | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |
| `final-evidence/CD0-MERGE-RECEIPT.md` | Retrospective merge evidence | `53bc6fe5d1a2f4784b96b1cd1131b56fdc913cc6a4721ecb13dd0e019ca2b024` |
| `final-evidence/CD0-MAIN-READBACK-RECEIPT.md` | Fresh remote read-back evidence | `fa4cf3ca7f9f54771e8ab1b3024889022028b1116fbba1e2730f6c713a8fb540` |
| `final-evidence/CD0-POST-MERGE-VERIFICATION.md` | Finite post-merge verification evidence | `12848cdb5e6ead2497dce4fc47c557ced71e19f87d70e4d5188f25bfdc3eb1f1` |
| `final-evidence/CD0-FREEZE-DECLARATION.md` | Final freeze declaration | `bbaa5ed8b28843e7429f51a979b12229e88f035f3749c236eca5e2cea29f256a` |
| `final-evidence/CD0-MERGE-SHA256SUMS.txt` | Nested merge/freeze checksum evidence | `04454a394c247f34f66f411887e397e14a07310e811e2492919fa9c517ad55ef` |
| `final-evidence/FABLE-CD0-A9-CLOSURE-VERIFICATION.md` | External focused PASS authorization evidence | `96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e` |
| `context/LANGUAGE-BOUNDARY.md` | Non-normative architectural diagnosis | `c1876eba2010b5ab2fc23afb15b7982b4a2ee4550a11238e81a592965111a242` |
| `context/BOOK-0.md` | Proposed contextual constitutional principles | `e65bf0326402f1106fc048a53a943bc144a126f4bb32a03805025e8c30058ac1` |
| `migration-evidence/kernel-hardened.lisp` | Explicitly non-normative v1 migration evidence | `fe3f496d626c2401962f00ecfb56faa6b2a969c54d2deabbe9465a9a80f1632c` |
| `migration-evidence/V1-COUNTEREXAMPLE-CLOSURE.md` | Explicitly non-normative v1 migration evidence | `31ee6f452b6426f5889439b78871cbc83193a1f2b382fb66fa4436ab24ee976a` |

---

# 4. Terminology

## 4.1 Proposition

A **Proposition** is normalized semantic content validated by a named claim profile. It states what is asserted independently of assertion occurrence, claimant, provenance, evidence history, admissibility policy, and current standing.

A proposition may contain stable references to subjects, entities, quantities, procedures, artifacts, models, or events when those objects are themselves part of what is asserted. A procedure used merely to discover or test the proposition is not thereby part of the proposition.

A surface sentence, printed Lisp form, model response, query string, or translated phrase is not automatically a proposition. A profile-specific interpretation operation produces a normalized proposition and an interpretation receipt.

## 4.2 Claim occurrence

A **Claim occurrence** is an event or artifact in which some claimant, system, document, or process asserts a located claim. It can carry claimant, assertion time, provenance, presentation text, lineage, requested warrant kind, and cached identifiers. Two claim occurrences can assert the same located claim.

LCI/0 does not make occurrence identity part of ClaimId. A project that needs occurrence identity uses a separate stable reference or artifact identity.

## 4.3 Claim

In this document, **Claim** means a claim occurrence together with its proposition and location. Where only the semantic object matters, the term **Located Claim** is used.

## 4.4 Located Claim

A **Located Claim** is the validated pair:

```text
LocatedClaim = (Proposition, ClaimLocation)
```

under one exact claim profile and identity policy. Location contains the semantic coordinates required to distinguish which situated assertion exists, not the entire history of how anyone came to assert it.

## 4.5 Claim location

**Claim location** is the tuple:

```text
ClaimLocation =
  (Scope,
   SubjectTime,
   Basis,
   InterpretationFrame,
   ProfileLocation)
```

`Scope` bounds the entities, cases, region, population, or domain to which the assertion applies. `SubjectTime` identifies the time the proposition concerns. `Basis` distinguishes a world-relative assertion from a corpus- or dataset-relative assertion and binds any semantic snapshot, slice, or closed-world boundary. `InterpretationFrame` binds meaning-bearing ontology, schema, units, jurisdiction, scientific model, edition, or evaluator semantics. `ProfileLocation` is a closed profile-defined record for any further semantic coordinate.

## 4.6 ClaimId

A **ClaimId** is the validated `ClaimIdEnvelope` CD/0 value defined in Section 7. It is semantic identity material, not necessarily a compact digest.

A later hash-based reference to a ClaimId is a `ClaimIdDigest` or another explicitly named reference, not the semantic definition of ClaimId.

## 4.7 WarrantTarget

A **WarrantTarget** is a typed inert CD/0 envelope that names one complete ClaimId and any additional evidence-kind boundary needed to say exactly what a warrant bears upon. It distinguishes, for example, observing a claim from executing a procedure, completing a corpus search, deriving from premises, replaying an event, reporting an external statement, or translating another claim.

## 4.8 Warrant

A **Warrant** is a genuine evidence or authorization-bearing occurrence that supports, refutes, observes, executes, tests, derives, reports, translates, inherits, or otherwise bears on a WarrantTarget. Its inert projection can be represented as CD/0 data. A live warrant may additionally involve runtime authority that CD/0 cannot contain.

A decoded record shaped like a warrant is testimony about a warrant, not a live warrant.

## 4.9 Warrant identity

**Warrant identity** distinguishes evidence occurrences. It includes the complete WarrantTarget and the warrant-kind event material required to distinguish issuer/producer, procedure or instrument, immutable code/model/invocation identity where relevant, result or verdict, issue event, validity terms, and event/trace identity. LCI/0 fixes the target-binding obligations but defers a universal WarrantId algorithm.

## 4.10 Admissibility

**Warrant admissibility** is a policy-relative judgment that a genuine warrant may currently count for a candidate claim. It can depend on target relation, warrant kind, authority, issuer, procedure, code, freshness, validity, revocation, represented loss, jurisdiction, requested warrant kind, consumption state, and query time.

Admissibility is not claim identity and is not structural CD/0 equality.

## 4.11 Standing

**Standing** is a query result computed from claims, live warrants, refutations, revocations, validity, time, policy, represented loss, and other runtime state. LCI/0 does not define a final standing lattice. It does require standing to be recomputed as a state query rather than stored inside ClaimId.

## 4.12 Provenance

**Provenance** records historical facts about an occurrence or artifact: source, claimant, assertion event, parser, importer, procedure, observation, custody testimony, external artifact, display text, or transformation receipt. Provenance may influence admissibility without being semantic claim identity.

## 4.13 Lineage

**Lineage** is an explicit relation among claim occurrences, artifacts, or identity envelopes: copy, independent re-derivation, inheritance, freeze/revival, reconstruction, translation, correction, migration, compaction, or other succession. Lineage explains history. It neither follows from equal ClaimIds nor makes unequal ClaimIds equal.

## 4.14 Represented loss

**Represented loss** is an inert record stating that migration, translation, compaction, reconstruction, or import did not preserve some source distinction or evidence property. It is never silently converted into Unit, absence, or authority.

## 4.15 Identity policy and admissibility policy

An **identity policy** defines the ClaimId projection and is part of the ClaimId envelope. An **admissibility policy** decides whether warrants count and is not part of ClaimId. The word “policy” without qualification is insufficient in identity-bearing data.

## 4.16 Exact, equivalent, refining, translating, and descending

These are distinct relations:

- **same claim**: exact ClaimId equality;
- **proposition-equivalent**: a profile/calculus judgment about semantic proposition equivalence;
- **claim-refines**: a safe narrowing relation defined in Section 17, limited in LCI/0 to scope;
- **claim-translates-to**: an explicit translation relation with a receipt and loss account;
- **claim-descends-from**: an explicit lineage path;
- **target matches**: a WarrantTarget relation to a claim;
- **warrant admissible**: a current policy judgment.

No one of these relations substitutes for the others.

---

# 5. Separation of proposition, location, identity, target, admissibility, standing, provenance, and lineage

## 5.1 The layered model

LCI/0 uses the following dependency direction:

```text
surface form / source artifact
          |
          | interpret under a frame
          v
normalized Proposition  +  ClaimLocation
          |                       |
          +-----------+-----------+
                      v
              ClaimIdEnvelope
                      |
                      +--------------------+
                      |                    |
                      v                    v
              Claim occurrence       WarrantTarget(kind,
              provenance/lineage      ClaimId, boundaries)
                                           |
                                           v
                                       Warrant
                                           |
                              policy + runtime state + query time
                                           |
                                           v
                                  admissibility / standing
```

No arrow runs backward from standing, revocation, a decoded warrant-shaped datum, or a claimant’s self-declaration into ClaimId.

## 5.2 Proposition is not surface form

A conforming claim-profile interpreter MUST either produce one validated normalized proposition plus an interpretation receipt, or return a typed refusal. It MUST NOT use printer text, package interning, host object identity, mutable object identity, or ambient reader state as proposition identity.

Different surface forms can normalize to the same proposition. Identical surface text can normalize to different propositions under incompatible interpretation frames.

## 5.3 Location is semantic, not historical

A field belongs in claim location when changing it distinguishes a different situated assertion or invalidates an otherwise direct warrant target. A field does not belong merely because it was present during production, transport, storage, or evaluation.

The minimality test is:

> An identity-bearing location field is justified only when changing it, while holding proposition and all other identity coordinates fixed, either distinguishes a different semantic claim or makes direct reuse of an existing exact warrant unsound.

## 5.4 ClaimId is stable semantic identity

For any two valid claims `x` and `y`:

```text
same-claim(x, y)
    iff
claim-id-envelope(x) = claim-id-envelope(y)
```

The equality on the right is frozen CD/0 structural equality. Equivalent canonical octets are its cross-process witness.

ClaimId does not identify a claimant, assertion event, database row, runtime object, artifact custody chain, live authority, or standing snapshot.

## 5.5 WarrantTarget is evidence-specific

The same located claim may be observed, executed, derived, reported, translated, or supported by corpus completion. Those are not interchangeable evidential acts. WarrantTarget therefore includes a complete ClaimId and a kind-specific boundary record.

A target can be structurally well formed yet fail to match a claim because its corpus revision, procedure code, temporal boundary, scope relation, frame, derivation premises, or completion condition differs.

## 5.6 Admissibility is a current judgment

A genuine warrant can be inadmissible. Exact ClaimId equality and an exact target do not establish current validity, non-revocation, freshness, authority, jurisdictional acceptance, absence of represented loss, or policy permission.

A conforming admissibility implementation MUST accept the policy and runtime state as explicit inputs. It MUST NOT read an admissibility-policy identifier from ClaimId or silently change ClaimId when a policy changes.

## 5.7 Standing is queried, not baked in

A conforming standing implementation MUST compute standing for an explicit query state and query time. Revocation, expiry, new refutation, policy replacement, or warrant consumption can change standing without changing ClaimId.

A serialized historical status is testimony about a former result. It is not current standing merely because its record shape is valid.

## 5.8 Provenance and lineage are explanatory, not constitutive by default

Claimants, source artifacts, import receipts, translation events, and predecessor links can matter greatly to admissibility and historical understanding. They do not enter ClaimId unless they alter normalized proposition or one of the semantic location coordinates.

Equal ClaimIds do not prove common lineage. A copied claim and an independently re-derived claim can share ClaimId. Conversely, a correction or translation can have explicit lineage while changing ClaimId.

## 5.9 Claim occurrence and semantic identity

Freezing, transmitting, decoding, reviving, copying, or independently asserting an identical envelope preserves semantic ClaimId but creates a distinct occurrence unless an occurrence-identity system says otherwise. Live warrants do not cross that boundary automatically. This separation prevents two opposite errors:

- treating every copy or provenance update as a new semantic claim; and
- treating equal inert bytes as proof of surviving authority, custody, or lineage.

## 5.10 Single ownership of semantic coordinates

A semantic coordinate has one authoritative home in the ClaimId projection. Scope, external subject-time, corpus/world basis, and interpretation frame are carried by `ClaimLocation/0`; a profile MUST NOT duplicate the same locator inside the proposition and then allow the copies to disagree. Cross-field validation rejects contradictory duplication.

This rule does not prohibit a proposition from referring to a scope, time, corpus, frame, procedure, or artifact as an object of discourse. For example, “interval A overlaps interval B” can be an atemporal proposition containing two temporal objects, while its external `SubjectTime/0` is the time at which that relational assertion is located, if any. The profile must distinguish an object mentioned by the proposition from the locator that situates the claim.

---

# 6. Candidate-dimension adjudication table

The table gives the default LCI/0 ruling. “In proposition when asserted” is not an escape hatch: the proposition profile must actually encode the object as semantic content. Merely using a procedure, corpus, model, prompt, or artifact to obtain evidence does not make it proposition content.

| Candidate dimension | Normative layer | LCI/0 ruling | What breaks if placed in the wrong layer |
|---|---|---|---|
| Proposition structure | Proposition and ClaimId | The normalized proposition datum is required in ClaimId. The claim profile fixes its grammar and normalization boundary. | Excluding it collapses contradictory or unrelated assertions. Using surface printer text instead makes equivalent structure diverge across hosts and makes ambient printing an identity oracle. |
| Subject or entity reference | Proposition; occasionally profile-specific location | A subject that the assertion is about is encoded as a stable semantic reference inside the proposition. A profile may add a separate location coordinate only when the same proposition AST is intentionally parameterized by an external subject domain. | Excluding a semantic subject makes “file A exists” and “file B exists” one claim. Duplicating every subject into location creates two sources of truth and projection divergence. |
| Scope | ClaimId through `Scope/0` | Exact versioned scope is always required. Universal scope is explicit. | Excluding scope lets evidence for one tenant, region, row set, or population raise a broader claim. Putting scope only in provenance makes mutation or omission invisible to ClaimId. |
| `as-of` | Nowhere as an overloaded core field | LCI/0 rejects a single undifferentiated `as-of`. Its source meaning is decomposed into subject-time, observation time, assertion time, validity time, execution time, or query time. | A single field invites one implementation to treat it as proposition time and another as evidence time, producing either stale warrant reuse or needless identity changes. |
| Event time | Proposition and ClaimId when it is the time the assertion concerns; otherwise Warrant identity | An event/state time is encoded in `SubjectTime/0` when changing it changes the claim. Time at which evidence-generating activity occurred belongs to the warrant. | Always excluding it merges “occurred Monday” with “occurred Tuesday.” Always including operational event time makes two observations of the same event different claims. |
| Observation time | WarrantTarget, Warrant identity, admissibility | It locates evidence, not the proposition. It can constrain freshness and temporal coverage. | Putting it in ClaimId creates a new claim every time the same fact is observed. Omitting it from evidence allows stale observations to masquerade as current. |
| Execution time | WarrantTarget, Warrant identity, admissibility | It identifies the evidence-producing execution and may constrain temporal applicability. | Putting it in ClaimId makes recomputation change claim identity. Omitting it from an execution warrant lets a result from the wrong temporal boundary support a time-sensitive claim. |
| Warrant mint or issue time | Warrant identity and admissibility | It distinguishes issuance events and supports validity/freshness checks. | ClaimId inflation follows if every re-issuance creates a new claim; omitting it from warrants prevents reliable expiry and chronology checks. |
| Claim assertion time | Provenance / claim occurrence | It records when an agent asserted the already located claim. It is not the time the proposition concerns unless the proposition explicitly says so. | Putting it in ClaimId makes two people asserting the same located claim at different moments different semantic claims. Omitting it from provenance erases historical order. |
| Validity interval | Warrant identity and admissibility | It is a term of a warrant. A proposition explicitly about a validity interval encodes that interval as proposition content instead. | Putting all warrant validity into ClaimId causes expiry to mutate claim identity. Omitting it lets expired evidence count indefinitely. |
| Time at which standing is queried | Standing input only | It is an explicit runtime query parameter. | Including it in ClaimId creates an infinite sequence of “same” claims indexed by query clock. Hiding it as ambient time makes standing nondeterministic and untestable. |
| Corpus identity | ClaimId `Basis/0` when the assertion is corpus-relative; otherwise WarrantTarget/provenance | A claim such as “X occurs in corpus C” binds a stable corpus identity. A world claim merely evidenced by corpus C does not. | Excluding it merges claims over distinct corpora. Including every evidentiary corpus makes the same world claim acquire new identities whenever evidence sources change. |
| Corpus version or immutable revision | ClaimId `Basis/0` for corpus-relative claims; WarrantTarget for evidence-only corpora | A corpus-relative claim binds an immutable revision/content identity, never a mutable display name alone. | Version 3 absence can be laundered into version 4 if excluded. Identity inflates if a world claim is tied to every source revision used as evidence. |
| Dataset slice | ClaimId `Basis/0` when it bounds the quantified claim domain | The exact slice expression and its calculus/schema are identity-bearing when the proposition ranges over that slice. | A result for a training split can support a claim about the whole dataset if omitted. Treating a mere processing shard as semantic creates accidental claim fragmentation. |
| Query or search procedure | WarrantTarget and Warrant identity | The exact stable procedure/code reference belongs to observed, executed, tested, or corpus-completion targets. It enters Proposition only when the proposition itself is about that procedure. | Putting it in ClaimId prevents independent procedures from supporting the same claim. Omitting it from a search warrant hides a procedure with different recall or semantics. |
| Completion boundary | Split: ClaimId basis when it defines the closed semantic domain; WarrantTarget when it records execution completion | A bounded-absence claim includes the boundary it quantifies over. The fact that a particular search actually reached that boundary is evidence. | If neither layer records it, incomplete search becomes proof of absence. If execution progress is put in ClaimId, retries and partial runs create new claims rather than weaker warrants. |
| Interpretation frame | ClaimId | A required frame binds all meaning-bearing interpretation context not already self-contained in the proposition AST. A neutral frame is explicit. | Identical surface data under incompatible ontologies, unit systems, legal regimes, or evaluator semantics collapses into one ClaimId if omitted. |
| Ontology or schema version | ClaimId through InterpretationFrame | Include the exact version when it can change denotation, typing, relation meaning, or normalization. | “Jaguar” as an animal and as a vehicle, or a field whose schema changed units, can collide under identical printer text. |
| Unit system | ClaimId through Proposition or InterpretationFrame | Units encoded directly in a quantity are proposition content; ambient unit conventions belong to the frame. | The number `10` can mean metres or feet while retaining identical inert structure. |
| Scientific model or textual edition used to interpret content | ClaimId through InterpretationFrame | It is identity-bearing when it changes what the proposition means. A model used merely to produce evidence belongs to WarrantTarget. | Excluding an interpretation model merges incompatible semantics; including every predictive model used as evidence fragments one claim across evaluators. |
| Legal jurisdiction | InterpretationFrame when it changes proposition meaning; admissibility policy when it only changes what evidence is accepted | The role must be explicit. | Putting all jurisdiction in policy merges differently defined legal propositions. Putting all jurisdiction in ClaimId makes a jurisdiction-neutral factual claim change identity merely because a court applies a different evidence rule. |
| Admissibility policy identity | Admissibility input and decision receipt | It does not enter ClaimId. A policy may change standing for the same claim. | Including it prevents two policies from disagreeing about one claim; excluding it from decisions makes policy-relative results look universal. |
| Identity-policy version | ClaimId | It is required and names the exact projection. Version 0 is fixed by this document. | Omitting it allows a later implementation to add an identity field while emitting an indistinguishable ClaimId schema. |
| Procedure identity | WarrantTarget and Warrant identity; Proposition only when asserted about | It uses a stable reference, not a display name or current registry binding. | ClaimId inflation occurs if two independent derivations create two claims. Evidence laundering occurs if a procedure is redefined under the same name and the warrant does not bind identity. |
| Procedure code identity | WarrantTarget and Warrant identity | Required for warrant kinds whose semantics depend on executed code, unless the target schema explicitly uses another immutable semantics identity. | A corrected or malicious redefinition under the same procedure ID can inherit old trust if code identity is absent. Putting code identity in every ClaimId prevents evidence reuse across correct independent implementations. |
| Module identity | Stable reference inside Proposition when the module is asserted about; otherwise WarrantTarget/Warrant identity | A module display name alone is never stable identity. Procedure references normally bind module identity. | Package or module renaming collapses or splits identity if host names are treated as semantic. Making the producer module part of every claim fragments identical claims. |
| Model identity and model version | WarrantTarget and Warrant identity; Proposition only for claims about model behavior | A model-produced answer is evidence for a semantic claim. A claim “model M version V returned T” encodes M and V in Proposition. | Putting model version in all ClaimIds makes identical supported facts different claims. Omitting it from model-execution warrants hides materially different generators. |
| Prompt or invocation identity | WarrantTarget and Warrant identity; Proposition only for claims about that invocation | Bind exact prompt/invocation when the warrant kind is model-executed or replayed. | Two different prompts that coincidentally emit identical text become indistinguishable evidence events if omitted. Including prompts in generic ClaimId ties truth claims to incidental elicitation history. |
| Issuer or claimant | Claim occurrence provenance; Warrant identity; admissibility | Claimants can independently assert the same located claim. Issuer identity is part of a warrant occurrence and can affect policy. | Putting claimant in ClaimId prevents agreement from being represented as co-reference. Omitting issuer from a warrant prevents authority and conflict-of-interest checks. |
| Language | Presentation/provenance by default; InterpretationFrame when semantically operative | Exact semantic normalization can erase surface-language difference without changing ClaimId. Language remains in the interpretation receipt. If language-specific ambiguity survives, it is part of the frame or proposition. | Always including language makes exact translations different claims; always excluding it collapses homographs and language-bound legal or technical meanings. |
| Translation | Lineage and provenance; new ClaimId when semantic output or frame differs | A translation receipt relates source and target claims. Imperfect translation carries represented loss. Exact normalization may yield the same ClaimId, but lineage is still not inferred. | Treating translation as identity by fiat launders semantic drift. Treating every translation as automatically new prevents exact cross-language co-reference. |
| Confidence | Warrant result/provenance by default; Proposition when epistemic modality is asserted | “The probability is 0.7” is proposition content. “The claimant is 70% confident that P” is normally evidence metadata unless the claim itself asserts that mental state. | Putting all confidence in ClaimId creates new claims for every assessor score. Omitting asserted probability from Proposition changes what was said. |
| Uncertainty representation | Proposition for semantic measurement uncertainty; Warrant identity for evidential uncertainty | A measured value with stated uncertainty carries it in the proposition quantity. Procedure error bars or confidence diagnostics that do not alter the assertion belong to the warrant. | Dropping semantic uncertainty turns “10 ± 2” into “10 exact.” Including every diagnostic interval in ClaimId makes equivalent assertions depend on tool internals. |
| Evidence kind | WarrantTarget and Warrant identity | `observed`, `executed`, `tested`, `derived`, `externally-attested`, `replayed`, `corpus-completion`, `reported`, `inherited`, and `translated` are distinct target schemas. | A report can masquerade as a direct observation if kind is absent. ClaimId inflation results if evidence type changes claim identity. |
| Lineage | Lineage only; admissibility may inspect it | It never participates directly in ClaimId. | Including lineage makes every copy, migration, or independent derivation a new semantic claim. Omitting explicit lineage records makes succession and loss impossible to audit, but that does not justify identity inclusion. |
| Predecessor ClaimId | Lineage only | It appears in explicit lineage edges, migration receipts, correction receipts, or translation receipts. | Putting a predecessor in ClaimId recursively makes independent identical claims unequal and creates ancestry-sensitive identity explosion. |
| Source artifact | Provenance or WarrantTarget; Proposition when the artifact is the subject | An external artifact used as evidence is bound in the warrant. A proposition “artifact A contains X” includes A as subject. | Putting every source artifact in ClaimId prevents multiple sources from supporting one claim. Omitting an artifact from external-attestation targets allows superseded content under the same name to pass. |
| Represented loss | Provenance/lineage and admissibility; Proposition or location only when uncertainty itself is asserted | When all identity fields are exactly recoverable, loss remains outside ClaimId. When an identity field is not recoverable, the adapter rejects same-ClaimId migration or constructs a new explicitly loss-qualified claim. | Ignoring loss launders collapsed packages, omitted time, or erased corpus versions. Always including loss records in ClaimId makes harmless provenance loss create new claims. |
| Requested warrant kind | Query/admissibility input; presentation metadata | A requester can ask for observation rather than report, or fresh execution rather than inheritance, without changing the claim. | Including it in ClaimId creates different claims for different proof requests. Omitting it from the query can let a weaker warrant satisfy a stronger evidential demand. |
| Current standing | Standing only | It is derived from runtime state and query parameters. | Including it makes ClaimId change on revocation or expiry and makes identity circularly depend on warrants. |
| Revocation state | Admissibility and standing state | Revocation affects whether a warrant counts, not which claim it targeted. | Including revocation in ClaimId rewrites claim identity when evidence is revoked. Ignoring it in standing preserves authority after explicit withdrawal. |
| Presentation labels, comments, formatting, UI order | Presentation metadata | They never enter ClaimId unless a profile explicitly interprets them into Proposition or Frame. | Including them creates identity churn under harmless rendering changes. Silently interpreting them without a profile makes projection implementation-dependent. |
| Future semantic coordinate | Profile-specific extension | It enters `profile-location` only under a new closed profile version and, if projection changes, a new identity-policy version. The minimality test and counterexample are required in that profile. | Silently ignoring it causes under-identification; silently adding it under version 0 causes clean-room implementations to disagree. |
| Ambient current time, process ID, memory address, package object, registry binding, database row ID | Nowhere in normative core | These may be occurrence provenance only when explicitly represented as stable data. They never determine ClaimId by ambient lookup. | Identity becomes process-local, mutable, non-repeatable, and impossible to compare across Common Lisp and Python. |

## 6.1 Minimality conclusion

The table yields a deliberately narrow identity boundary. ClaimId contains semantic content and semantic location. It does not contain the means, history, authority, or current policy by which anyone came to accept that content. The WarrantTarget and admissibility layers carry those additional distinctions without letting them leak into semantic sameness.

---

# 7. Minimal ClaimId envelope

## 7.1 Namespace and closed-record rule

All LCI/0 standard field identifiers use namespace segments `["lisp-plus", "lci", "0"]`. Profile-specific fields use the profile's own nonempty namespace.

Every record schema defined in Sections 7 through 10 is closed. A validator that understands the declared version MUST reject an unlisted field. A validator that does not understand the declared version MUST return `UnsupportedLCIVersion`, `UnsupportedClaimProfile`, `UnsupportedIdentityPolicy`, or the corresponding typed refusal; it MUST NOT guess which fields are identity-bearing.

## 7.2 Stable reference primitive

LCI/0 uses an ordinary CD/0 record to carry a reference whose semantic identity scheme is defined elsewhere:

```text
StableRef/0 = Record{
  K("kind")     => T("stable-reference"),
  K("domain")   => <Identifier>,
  K("scheme")   => <Identifier>,
  K("material") => <CD/0 value>
}
```

All four fields are required. `domain` distinguishes, for example, corpus, corpus revision, scope calculus, temporal model, interpretation-frame schema, module, procedure, model, policy, artifact, principal, or invocation references. `scheme` names the exact reference interpretation. `material` is the complete immutable identity envelope under that scheme.

A `StableRef/0` MUST NOT be accepted when its declared scheme permits a mutable display name, ambient registry binding, host object, process-local token, or unversioned alias to stand alone as identity. A human-readable name can accompany a reference in provenance or presentation metadata, but it is not silently copied into `material` as proof of stable identity.

This specification does not require `material` to be a hash. A content-hash wrapper is one possible later stable-reference scheme.

## 7.3 Identity-policy record

LCI/0 identity policy version 0 is exactly:

```text
LCIIdentityPolicy/0 = Record{
  K("kind")           => T("identity-policy"),
  K("policy-id")      => Id(["lisp-plus", "lci"],
                              ["located-claim-identity"]),
  K("policy-version") => 0
}
```

No other policy record denotes this projection. A later projection version has a different policy-version and therefore a different ClaimId envelope.

## 7.4 Mneme claim-profile record

The base Mneme profile reference is exactly:

```text
MnemeClaimProfile/0 = Record{
  K("kind")            => T("claim-profile"),
  K("profile-id")      => Id(["lisp-plus", "mneme"],
                               ["located-claim"]),
  K("profile-version") => 0
}
```

The Mneme proposition grammar remains a separate profile artifact. For LCI/0, that grammar must produce a normalized inert CD/0 proposition and must validate all proposition-level stable references.

## 7.5 Scope record

```text
Scope/0 = Record{
  K("kind")           => T("scope"),
  K("schema-version") => 0,
  K("calculus")       => <StableRef/0 to a scope calculus>,
  K("expression")     => <CD/0 value accepted by that calculus>
}
```

All fields are required. The calculus reference and expression both participate in ClaimId. A universal scope is represented by an explicit expression defined by the selected calculus. It is never represented by omission, Unit, `nil`, `None`, a host wildcard, or a process-local singleton.

The base Mneme scope-calculus reference is a stable reference whose material names `Id(["lisp-plus", "mneme"], ["scope-calculus"])` at version `0`. This document fixes its interface in Section 11, not its complete expression language.

## 7.6 Subject-time record

```text
SubjectTime/0 = Record{
  K("kind")           => T("subject-time"),
  K("schema-version") => 0,
  K("temporal-model") => <StableRef/0 to a temporal model>,
  K("expression")     => <CD/0 value accepted by that model>
}
```

`SubjectTime/0` denotes the time the proposition concerns. An atemporal proposition uses an explicit atemporal expression under an exact temporal-model reference. The record never inherits an ambient current clock.

Observation, execution, issue, validity, assertion, and standing-query times are not encoded here.

## 7.7 Basis record

A claim basis says what semantic world or bounded information space the proposition ranges over. LCI/0 defines two forms.

### 7.7.1 World basis

```text
WorldBasis/0 = Record{
  K("kind")           => T("claim-basis"),
  K("schema-version") => 0,
  K("mode")           => T("world"),
  K("parameters")     => Record{}
}
```

World basis means that no corpus revision is a constitutive coordinate of the claim. A corpus can still be used as evidence and bound by WarrantTarget.

### 7.7.2 Dataset slice

```text
DatasetSlice/0 = Record{
  K("kind")           => T("dataset-slice"),
  K("schema-version") => 0,
  K("calculus")       => <StableRef/0 to a slice calculus>,
  K("expression")     => <CD/0 value accepted by that calculus>
}
```

A full-corpus slice uses the calculus's explicit all-members expression. Omission, Unit, an empty host collection, or an ambient “current selection” is not a full-corpus marker.

### 7.7.3 Semantic boundary

```text
SemanticBoundary/0 = Record{
  K("kind")           => T("semantic-boundary"),
  K("schema-version") => 0,
  K("calculus")       => <StableRef/0 to a boundary calculus>,
  K("expression")     => <CD/0 value accepted by that calculus>
}
```

A boundary that is semantically not applicable uses an explicit not-applicable expression under the exact boundary calculus. A source adapter cannot replace an unknown boundary with that expression.

### 7.7.4 Corpus basis

```text
CorpusBasis/0 = Record{
  K("kind")              => T("claim-basis"),
  K("schema-version")    => 0,
  K("mode")              => T("corpus"),
  K("corpus")            => <StableRef/0 to the logical corpus>,
  K("revision")          => <StableRef/0 to an immutable corpus revision>,
  K("slice")             => <DatasetSlice/0>,
  K("semantic-boundary") => <SemanticBoundary/0>
}
```

All fields are required. A mutable human-readable corpus name is insufficient for `revision`.

`semantic-boundary` enters ClaimId only when it defines the closed domain about which the proposition speaks—for example, a snapshot manifest, path-root boundary, log cutoff, or cursor horizon in a bounded absence claim. The fact that an evidence procedure actually reached that boundary belongs in a corpus-completion WarrantTarget and Warrant.

A claim profile MUST reject a corpus-relative proposition paired with `WorldBasis/0` when the proposition's denotation depends on a particular corpus or revision. It MUST also reject a world-relative proposition that imports an evidentiary corpus into ClaimId without a semantic reason declared by the profile.

## 7.8 Interpretation-frame record

```text
InterpretationFrame/0 = Record{
  K("kind")           => T("interpretation-frame"),
  K("schema-version") => 0,
  K("frame-schema")   => <StableRef/0 to a frame schema>,
  K("components")     => <closed CD/0 Record accepted by that schema>
}
```

The frame schema fixes which components are permitted and whether they include ontology, data schema, unit conventions, jurisdiction, scientific model, textual edition, parser semantics, evaluator semantics, or language-sensitive interpretation.

A self-contained proposition uses an explicit self-describing frame reference and an empty components record. Omission and Unit are invalid substitutes.

## 7.9 Profile-location record

`profile-location` is an ordinary closed CD/0 record whose schema is fixed by the claim profile. It exists so a later profile can name an additional semantic coordinate without pretending it is provenance.

For `MnemeClaimProfile/0`:

```text
MnemeProfileLocation/0 = Record{}
```

A Mneme LCI/0 projector MUST reject a nonempty `profile-location` record. A later Mneme profile that adds a coordinate must increment its profile version and, because the ClaimId projection changes, the identity-policy version.

## 7.10 Claim-location record

```text
ClaimLocation/0 = Record{
  K("kind")                 => T("claim-location"),
  K("scope")                => <Scope/0>,
  K("subject-time")         => <SubjectTime/0>,
  K("basis")                => <WorldBasis/0 or CorpusBasis/0>,
  K("interpretation-frame") => <InterpretationFrame/0>,
  K("profile-location")     => <closed profile-location Record>
}
```

All fields are required and identity-bearing.

## 7.11 ClaimId envelope schema

The ClaimId envelope is exactly:

```text
ClaimIdEnvelope/0 = Record{
  K("kind")            => T("claim-id-envelope"),
  K("lci-version")     => 0,
  K("identity-policy") => <LCIIdentityPolicy/0>,
  K("claim-profile")   => <claim-profile record>,
  K("proposition")     => <normalized profile proposition>,
  K("location")        => <ClaimLocation/0>
}
```

All six fields are required. Version 0 has no optional field. A field present with Unit is different from an omitted field under CD/0 and is invalid unless the exact nested profile schema explicitly accepts Unit at that position. None of the six top-level fields accepts Unit.

A conforming LCI/0 validator MUST reject:

- an omitted required field;
- an unknown field;
- a duplicate record key, as already rejected by CD/0 decoding;
- an unsupported LCI, identity-policy, claim-profile, calculus, temporal-model, basis, or frame version;
- an unnormalized proposition form;
- a mutable or ambiguous stable reference;
- a self-declared digest substituted for the envelope;
- a claim whose proposition and location are semantically inconsistent under its profile.

## 7.12 ClaimId is the envelope

For LCI/0:

```text
ClaimId(x) = claim-id-envelope(x)
```

The semantic identity value is not a hash, pointer, UUID, row key, package symbol, printed string, or runtime registration token.

A compact cryptographic reference may later use the exact domain-framed preimage:

```text
IdentityPreimage(
  "lisp-plus/lci/0/claim-id-envelope",
  ClaimIdEnvelope/0
)
```

where the ASCII domain label is exact and the framing is the frozen CD/0 `LPID\0 || UVAR(length) || label || canonical-octets(envelope)` interface. LCI/0 selects no hash algorithm. A digest collision does not make unequal envelopes the same claim, and digest equality alone is not semantic proof when the envelope is unavailable or collision handling is unspecified.

## 7.13 Worked ClaimId form

The following diagnostic form illustrates a world-relative, atemporal claim. Profile proposition details are schematic but every LCI field is explicit:

```text
Record{
  K("kind")            => T("claim-id-envelope"),
  K("lci-version")     => 0,
  K("identity-policy") => LCIIdentityPolicy/0,
  K("claim-profile")   => MnemeClaimProfile/0,
  K("proposition")     => Record{
    Id(["lisp-plus", "mneme", "proposition", "0"], ["kind"])
      => Id(["lisp-plus", "mneme", "proposition", "0"], ["file-exists"]),
    Id(["lisp-plus", "mneme", "proposition", "0"], ["file"])
      => StableRef/0(<artifact identity scheme>, <immutable file identity>)
  },
  K("location")        => Record{
    K("kind")                 => T("claim-location"),
    K("scope")                => Scope/0(<Mneme scope calculus>, universal),
    K("subject-time")         => SubjectTime/0(<Mneme temporal model>, atemporal),
    K("basis")                => WorldBasis/0,
    K("interpretation-frame") => InterpretationFrame/0(
                                      <self-describing frame>, Record{}),
    K("profile-location")     => Record{}
  }
}
```

To derive canonical bytes, construct this abstract record using frozen CD/0 values, validate every nested profile, then call CD/0 `canonical-octets` on the complete envelope. An implementation MUST NOT derive identity from this diagnostic spelling.

---

# 8. ClaimId projection algorithm

## 8.1 Projection boundary

ClaimId projection begins only after surface interpretation. A raw sentence, v1 Lisp form, model output, legacy artifact, or unvalidated host object is not a projection input.

Conceptually:

```text
interpret(surface, frame, profile)
  -> normalized-proposition, interpretation-receipt

locate(normalized-proposition, location-inputs, profile)
  -> validated-located-claim

claim-id-envelope(validated-located-claim)
  -> ClaimIdEnvelope/0
```

The interpretation receipt is provenance. It is not inserted into ClaimId, although its normalized proposition and interpretation frame are.

## 8.2 Deterministic pseudocode

```text
function project_claim_id(claim):
    require claim is an immutable CD/0-backed value or immutable typed view

    require exact_lci_version(claim) == 0
    require exact_identity_policy(claim) == LCIIdentityPolicy/0

    profile = resolve_closed_profile(claim.claim_profile)
    require profile is supported and immutable for this implementation version
    require claim has exactly the profile-declared fields

    proposition = profile.validate_normalized_proposition(claim.proposition)
    location    = validate_claim_location(claim.location, profile)

    require profile.proposition_location_consistent(proposition, location)

    envelope = Record{
        K("kind")            => T("claim-id-envelope"),
        K("lci-version")     => 0,
        K("identity-policy") => LCIIdentityPolicy/0,
        K("claim-profile")   => claim.claim_profile,
        K("proposition")     => proposition,
        K("location")        => location
    }

    validate_closed_claim_id_envelope(envelope)
    return envelope
```

`resolve_closed_profile` means selection by exact profile identity/version from implementation code or immutable configuration that is itself covered by conformance testing. It does not mean a mutable network registry, current package binding, module display name, or database row chosen at projection time.

## 8.3 Projection requirements

A conforming projector:

- MUST produce exactly the Section 7.11 envelope for every valid input;
- MUST reject every unsupported or unknown semantic field rather than ignore it;
- MUST perform no procedure execution, search, model invocation, network access, filesystem lookup, mutable registry lookup, policy query, standing query, or current-time read;
- MUST NOT infer a missing coordinate from ambient state;
- MUST NOT normalize Unicode beyond frozen CD/0 rules;
- MUST NOT treat a display name as stable reference material;
- MUST NOT use a supplied ClaimId, digest, fingerprint, or cache as the authoritative projection;
- MUST return the same envelope and canonical octets in independent Common Lisp and Python implementations for the same valid abstract input;
- MUST leave provenance, lineage, claimant, assertion time, warrants, standing, and presentation outside the envelope.

## 8.4 Cached or self-declared IDs

An outer artifact profile may carry a cached ClaimId envelope or digest for indexing. The cache is never an input to projection.

When a cache is present, a conforming reader MUST recompute the envelope from proposition and location. It MUST reject a non-equal cached envelope with `ClaimIdCacheMismatch`. It MUST verify any digest under the digest scheme before using it as an index. It MUST NOT accept a model-generated, user-supplied, or decoded record merely because it declares its own ClaimId.

## 8.5 Cross-field consistency

The profile validator MUST reject at least:

- a corpus-relative proposition with world basis;
- a corpus basis whose slice or boundary uses a different corpus/revision calculus than declared;
- a proposition whose semantic entity/reference scheme is incompatible with the interpretation frame;
- an atemporal marker under a temporal model that does not define it;
- a scope expression not valid under the named scope calculus;
- a nonempty Mneme/0 profile-location record;
- a frame component not allowed by the named frame schema;
- a location field encoded under a display alias rather than stable reference material;
- a claimed neutral coordinate represented by omission or Unit.

## 8.6 Canonical byte derivation

For a valid envelope `e`:

```text
claim-id-octets(e) = CD0.canonical-octets(e)
```

The complete canonical CD/0 document, including `LPCD` magic and version `0`, is retained. Implementations MUST compare either validated envelopes by CD/0 equality or their validated canonical octets. They MUST NOT compare diagnostic text, host hashes, printer output, package symbols, dictionary order, or pointer identity.

## 8.7 Idempotence and purity laws

For every valid claim `c`:

```text
project_claim_id(c) = project_claim_id(c)
canonical-octets(project_claim_id(c))
  = canonical-octets(project_claim_id(c))
```

More usefully, for any two independent conforming implementations `A` and `B`:

```text
A.project(c) = B.project(c)
A.canonical-octets(A.project(c))
  = B.canonical-octets(B.project(c))
```

Changing only nonidentity metadata leaves the result unchanged. Changing any identity field changes the envelope as a CD/0 value, even before any hash is considered.

---

# 9. WarrantTarget model

## 9.1 Decision

WarrantTarget is a typed family consisting of a complete ClaimId plus kind-specific boundaries. It is neither exactly ClaimId, nor a projection narrower than ClaimId, nor an untyped bag of evidence metadata.

Every WarrantTarget identifies which located claim is addressed. Its boundary record identifies the evidential act or object whose relation to that claim is being warranted.

## 9.2 Common envelope

```text
WarrantTarget/0 = Record{
  K("kind")          => T("warrant-target"),
  K("lci-version")   => 0,
  K("target-kind")   => <Identifier>,
  K("target-schema") => <StableRef/0 to an exact target schema>,
  K("claim")         => <ClaimIdEnvelope/0>,
  K("boundaries")    => <closed Record accepted by target-schema>
}
```

All six fields are required. No target kind may omit `claim` or replace it with a proposition-only fingerprint. No target may use a mutable claim record, current standing, or a caller-supplied hash in place of the complete validated envelope.

`target-kind` and `target-schema` are both present: the kind provides a stable semantic category, while the schema reference fixes the exact boundary fields and relation rules for that version.

## 9.3 Common target laws

A valid target MUST satisfy all of the following:

- `claim` validates as a closed ClaimId envelope;
- `target-schema` is stable and supports the declared `target-kind`;
- `boundaries` is closed under that schema;
- every procedure, module, model, artifact, corpus, policy, principal, invocation, trace, premise, or receipt reference required by the schema is a stable reference;
- every temporal boundary is an explicit versioned temporal value;
- every scope boundary is an explicit versioned scope value;
- no boundary is inferred from a display name, mutable registry, current process, or ambient clock;
- a boundary inconsistent with the embedded ClaimId produces a typed refusal.

## 9.4 Observed target

An `observed` target binds at least:

```text
observer-or-instrument
observation-procedure
observation-time
coverage
observation-artifact-or-event
```

The schema states whether the observation is direct, sampled, aggregated, or mediated. Observation time is not substituted for the ClaimId subject-time. Coverage can be broader than the claim scope only when the schema declares a sound narrowing relation.

## 9.5 Executed target

An `executed` target binds at least:

```text
procedure-reference
immutable code or semantics reference
invocation input/reference
execution environment semantics
execution time or interval
execution event/trace reference
```

A procedure display name and version string without an immutable semantics/code reference are insufficient unless the named procedure-identity scheme itself guarantees immutable binding.

## 9.6 Tested target

A `tested` target binds at least:

```text
system/procedure under test
immutable tested version
specific test case or suite identity
input and expected relation
execution environment semantics
execution time
test event/trace reference
```

A test warrant supports the target relation it actually tested. It is not automatically an observation of the external world or a universal proof over untested inputs.

## 9.7 Derived target

A `derived` target binds at least:

```text
inference-calculus reference
ordered or explicitly keyed premise ClaimIds
rule/derivation identity
derivation artifact or trace
```

The derivation calculus decides premise order, discharge conditions, monotonicity, and whether a derivation is valid. CD/0 equality alone does not prove the inference.

## 9.8 Externally attested target

An `externally-attested` target binds at least:

```text
external principal/reference
external statement or artifact identity
attestation time
mapping from external statement to the embedded ClaimId
```

The mapping receipt is explicit. An external human-readable name is not artifact identity. An external signature, if any, authenticates according to its own scheme and does not by itself establish truth or admissibility.

## 9.9 Replayed target

A `replayed` target binds at least:

```text
predecessor warrant testimony or event reference
replay procedure and immutable code/semantics
replay invocation/environment
replay time
new replay trace/result
```

Replay is a new evidence event. It can yield a new live warrant under current authority. It never reanimates the predecessor warrant merely because the new result matches.

## 9.10 Corpus-completion target

A `corpus-completion` target binds at least:

```text
exact corpus basis from the ClaimId
search procedure and immutable code/semantics
query/search expression
coverage plan
completion boundary
execution time
completion receipt or trace
```

The target schema MUST require the target corpus, revision, slice, and semantic boundary to agree with the embedded ClaimId. A completion receipt proves only the declared bounded search event. It does not turn corpus absence into unbounded world truth.

## 9.11 Reported target

A `reported` target binds at least:

```text
reporter or source principal
source artifact/reference
report time
exact content-to-ClaimId interpretation receipt
```

Reported evidence remains reported. It is not reclassified as observation, execution, or verified lineage by structural resemblance.

## 9.12 Inherited target

An `inherited` target binds at least:

```text
predecessor occurrence/artifact reference
predecessor warrant testimony reference
inheritance or handoff rule/reference
handoff/freeze/revival receipt
represented loss
```

An inherited target describes succession testimony. It does not carry live predecessor authority. An admissibility policy can accept inherited testimony for limited purposes, but LCI/0 never treats it as a live warrant by default.

## 9.13 Translated target

A `translated` target binds at least:

```text
source ClaimId
source and target interpretation frames
translation procedure/reference
translation receipt
represented loss
```

The embedded target ClaimId is the translated claim. The source ClaimId is an additional boundary. Exact target equality does not assert semantic equivalence; the translation calculus and receipt determine the relation.

## 9.14 Policy-evaluation and other profile targets

A warrant that attests “policy P accepted warrant W for claim C” may use a profile-defined policy-evaluation target that binds the policy identity/version, evaluated warrant reference, state snapshot reference, and query time. Policy P still does not enter C's ClaimId.

A later target kind can be added only under a new stable target-schema reference. Existing target schemas are closed.

## 9.15 Minimum warrant-identity material

LCI/0 does not select a universal WarrantId, but any warrant identity scheme claiming LCI/0 compatibility MUST bind at least:

```text
complete WarrantTarget/0
warrant kind and schema
issuer/producer stable identity
verdict, result, or supported relation
kind-specific evidence-event identity
issue/mint time
validity terms
represented loss, when present
```

It MUST bind immutable procedure/code/model/module/invocation/artifact material whenever the target schema requires it. It MUST NOT include current revocation state, current admissibility, or current standing as identity fields. A later revocation changes whether the same warrant counts; it does not retroactively make it a different evidence occurrence.

## 9.16 Target identity versus admissibility

Two structurally equal inert target records identify the same target. That fact alone does not establish that a live warrant exists, that an issuer had authority, that a procedure ran, that a trace is authentic, that validity survives, or that a policy admits the warrant.

The serialization clerk remains a clerk. It does not moonlight as a high priest of epistemic legitimacy.

---

# 10. Exact target matching

## 10.1 Relation result

Target matching is a typed relation, not a single permissive boolean. For a validated WarrantTarget `t` and validated claim `c`, the LCI/0 matcher returns one of:

```text
R("exact-target")
R("supports-by-scope-narrowing")

or a typed refusal/mismatch, including:
  F("proposition-mismatch")
  F("subject-time-mismatch")
  F("basis-mismatch")
  F("interpretation-frame-mismatch")
  F("profile-location-mismatch")
  F("scope-widening-forbidden")
  F("scope-overlap-insufficient")
  F("scope-disjoint")
  F("scope-incompatible")
  F("scope-relation-unknown")
  F("target-boundary-mismatch")
  F("unsupported-target-kind")
```

The relation result is not an admissibility result.

## 10.2 Exact target

```text
exact-target(t, c)
    iff
  t.claim = ClaimId(c)
  and
  target-boundaries-cohere(t, c) = true
```

The first equality is CD/0 equality. Boundary coherence is a pure, versioned target-schema validation. It checks facts such as corpus-basis equality, procedure/input binding, temporal coverage form, premise structure, or translation receipt shape. It does not authenticate a live event.

## 10.3 Scope-narrowing target relation

LCI/0 permits one generic non-equality claim projection: broad scope to narrow scope.

Let `replace-scope(e, s)` mean the ClaimId envelope obtained by replacing only the scope inside location. Then:

```text
supports-by-scope-narrowing(t, c)
    iff
  all non-scope fields of t.claim equal those of ClaimId(c)
  and
  scope-relation(scope(t.claim), scope(ClaimId(c)))
      is R("wider")
  and
  t.target-schema declares downward scope monotonicity
      for t.target-kind and t.claim.proposition
  and
  target-boundaries-cover-scope(t, scope(ClaimId(c)))
```

The monotonicity declaration is a versioned semantic rule of the target schema and claim profile. It may classify proposition forms; it is never inferred merely from the evidence kind or from set inclusion. The default is forbidden. The final policy decision can still reject an otherwise valid relation.

A scope relation of `equal` yields `exact-target`, not narrowing. A target scope narrower than the candidate claim yields `scope-widening-forbidden`. Overlap without subsumption is insufficient. Incompatible or unknown relations fail closed.

## 10.4 No generic temporal projection

LCI/0 direct target matching requires exact subject-time equality. A warrant for a time interval, instant, event, or “current” boundary does not directly target a different temporal location merely because a temporal calculus says one contains the other.

A policy or derivation system that wants temporal persistence, interval-to-instant reasoning, interpolation, or freshness inference must mint or validate an explicit `derived` warrant whose target contains the new ClaimId. This conservative rule prevents a stale observation from becoming a current-time warrant by a casual containment test.

## 10.5 No corpus, frame, proposition, or policy substitution

Direct matching requires exact equality of proposition, basis, interpretation frame, profile location, claim profile, and identity policy. In particular:

- corpus version 3 never directly matches version 4;
- one ontology never directly matches another;
- proposition equivalence never substitutes for ClaimId equality;
- a translated claim never directly matches its source;
- one admissibility policy never rewrites ClaimId into another policy-relative identity.

Any bridge requires a separate explicit warrant kind and receipt.

## 10.6 Matching pseudocode

```text
function match_target(target, claim):
    t = validate_warrant_target(target)
    c = project_claim_id(claim)

    require target_schema_boundaries_are_well_formed(t)

    if t.claim == c:
        require target_boundaries_cohere(t, c)
        return exact-target

    require t.claim.lci-version     == c.lci-version
    require t.claim.identity-policy == c.identity-policy
    require t.claim.claim-profile   == c.claim-profile
    require t.claim.proposition     == c.proposition

    require subject_time(t.claim)         == subject_time(c)
    require basis(t.claim)                == basis(c)
    require interpretation_frame(t.claim) == interpretation_frame(c)
    require profile_location(t.claim)     == profile_location(c)

    rel = scope_relation(scope(t.claim), scope(c))

    if rel == wider:
        require target_schema_is_downward_scope_monotone(
                    t.target_schema, t.target_kind, t.claim.proposition)
        require target_boundaries_cover_scope(t, scope(c))
        return supports-by-scope-narrowing

    if rel == narrower:
        fail ScopeWideningForbidden
    if rel == overlap:
        fail ScopeOverlapInsufficient
    if rel == disjoint:
        fail ScopeDisjoint
    if rel == incompatible:
        fail ScopeIncompatible
    if rel == unknown:
        fail ScopeRelationUnknown

    fail ClaimTargetMismatch
```

Each `require` returns the most specific typed mismatch. It does not collapse all failures into a generic false result.

## 10.7 When structural equality is insufficient

Structural equality is sufficient to establish that two valid target envelopes are the same target. It is insufficient to establish any of the following:

- that a warrant-shaped datum was minted by a live authority;
- that a procedure, observation, test, search, or translation occurred;
- that a broad target can soundly narrow to the candidate scope;
- that evidence is fresh for the queried time;
- that validity survives or revocation has not occurred;
- that represented loss is acceptable;
- that a report counts as observation;
- that a corpus-completion event establishes world truth;
- that an admissibility policy permits the warrant;
- that the claim currently has standing.

## 10.8 When one warrant may support more than one claim

A warrant may support multiple occurrences with the same ClaimId because semantic target identity is shared. It may also, subject to Section 10.3 and policy, support multiple narrower-scope ClaimIds from one broad target.

A warrant MUST NOT be reused across different propositions, subject-times, corpus revisions, dataset slices, semantic completion boundaries, interpretation frames, profile-location values, claim profiles, or identity-policy versions. It also MUST NOT be reused from narrow scope to broad scope.

---

# 11. Scope interface

## 11.1 Boundary of this specification

LCI/0 does not define a complete logic of scope. It defines the minimum deterministic interface required for ClaimId construction and WarrantTarget relation classification.

Every scope is a `Scope/0` CD/0 record. Its exact calculus reference and expression are part of ClaimId. The calculus supplies denotational or proof rules outside CD/0 without changing CD/0 equality.

## 11.2 Required operations

A conforming scope calculus implementation MUST expose pure operations equivalent to:

```text
validate-scope(scope) -> scope | typed failure
scope-equal(a, b) -> boolean
scope-relation(a, b) -> one relation value
scope-subsumes(a, b) -> true | false | unknown
```

`scope-equal(a,b)` is exact CD/0 equality after validation. It is not semantic equivalence under rewriting.

`scope-relation(a,b)` returns exactly one of:

```text
R("equal")
R("narrower")
R("wider")
R("overlap")
R("disjoint")
R("incompatible")
R("unknown")
```

The orientation is from `a` to `b`. `equal` is reserved for exact validated `Scope/0` CD/0 equality:

- `narrower`: every case in `a` is in `b`, and at least one case in `b` is not in `a`;
- `wider`: every case in `b` is in `a`, and at least one case in `a` is not in `b`;
- `overlap`: the scopes share some cases but neither subsumes the other;
- `disjoint`: the same calculus proves they share no cases;
- `incompatible`: they cannot be compared under one semantics, usually because their calculi or domain types lack a declared bridge;
- `unknown`: comparison is meaningful but the implementation, available facts, or calculus cannot determine the relation.

`scope-subsumes(a,b)` is true exactly when `scope-relation(a,b)` is `equal` or `wider`, false for `narrower`, `overlap`, or `disjoint`, and unknown for `incompatible` or `unknown` unless a profile specifies a stronger typed refusal.

## 11.3 Calculus identity and bridges

Two structurally different scope-calculus references are not silently treated as equivalent. A bridge between calculi is itself a stable, versioned relation artifact. A matcher MUST return `ScopeIncompatible` when no declared bridge exists. It MUST return `ScopeRelationUnknown` when a declared comparison domain exists but no relation can be proved.

A bridge can normalize both scopes into a third calculus, but that normalization is not CD/0 equality and does not retroactively make their ClaimIds equal. It can support an explicit derived warrant or profile-defined relation.

## 11.4 Exact scope equality versus semantic relation

Exact equality is sufficient to say two ClaimId scope fields are the same identity coordinate. A calculus may also prove two different expressions extensionally equivalent. LCI/0 does not collapse those expressions inside ClaimId unless the profile's pre-ClaimId scope normalizer produces the same canonical expression for both.

A calculus that proves two structurally different expressions extensionally equivalent records that as a separate proof/equivalence result; it does not return LCI/0 `R("equal")` for direct target matching. A scope profile that wants such forms to share identity MUST define a total deterministic versioned normalization and run it before ClaimId projection. It MUST preserve represented loss when source distinctions are discarded. The ClaimId projector itself does not perform open-ended theorem proving.

## 11.5 Narrowing and widening

For a broad warrant target scope `S_w` and candidate claim scope `S_c`:

```text
broad-to-narrow is eligible
    iff scope-relation(S_w, S_c) is wider
```

Eligibility is not admissibility. The target schema must declare downward monotonicity, its boundaries must cover `S_c`, and policy must accept the projection.

For a narrow target and broad claim:

```text
scope-relation(S_w, S_c) is narrower
```

LCI/0 returns `ScopeWideningForbidden`. A policy cannot relabel this as direct support. It can only accept a separately derived warrant whose target is the broad ClaimId and whose derivation justifies generalization.

## 11.6 Mutation and host identity

Scopes are immutable CD/0 values or immutable typed views. A conforming implementation MUST snapshot and validate a mutable host input before constructing `Scope/0`. It MUST NOT retain mutable aliases that can change canonical octets after ClaimId or WarrantTarget construction.

Common Lisp `eq`, Python `is`, interning, package identity, object addresses, registry object identity, and mutable collection identity are forbidden scope comparison mechanisms.

## 11.7 Minimum conformance examples

A scope calculus vector suite must include at least:

```text
universal vs universal        -> equal
universal vs tenant-A         -> wider
 tenant-A vs universal        -> narrower
 tenant-A vs tenant-B         -> disjoint or overlap, per fixture
 region-X vs region-Y         -> overlap fixture
 calculus-0 vs calculus-1     -> incompatible without bridge
 symbolic predicate undecided -> unknown
```

The exact scope values and expected canonical octets are shared between Common Lisp and Python.

---

# 12. Temporal interface

## 12.1 Six distinct temporal roles

LCI/0 distinguishes at least:

| Temporal role | Meaning | Layer |
|---|---|---|
| Subject-time | Time, interval, event, or horizon the proposition concerns | ClaimId `SubjectTime/0` |
| Observation time | When an observation occurred | WarrantTarget and Warrant identity |
| Execution time | When a procedure, test, replay, or search ran | WarrantTarget and Warrant identity |
| Mint/issue time | When the warrant was issued | Warrant identity and admissibility |
| Validity interval | When the warrant is eligible to count under its own terms | Warrant identity and admissibility |
| Assertion time | When a claimant asserted the located claim | Claim occurrence provenance |
| Standing-query time | Time at which current standing is requested | Runtime standing/admissibility input |

A source field called `as-of` is not accepted until an adapter classifies it into one or more of these roles.

## 12.2 Required temporal-model operations

A temporal model used by `SubjectTime/0` or a WarrantTarget boundary MUST expose deterministic operations equivalent to:

```text
validate-time(value) -> value | typed failure
time-equal(a, b) -> boolean
time-relation(a, b) -> relation
time-contains(a, b) -> true | false | unknown
```

`time-equal` is exact CD/0 equality after validation, and `time-relation` uses `R("equal")` only for that exact equality. Two distinct encodings that a temporal calculus judges co-denoting require a separate equivalence/normalization proof and remain different ClaimId coordinates unless normalized before projection. `time-relation` returns a model-defined subset that includes at least:

```text
R("equal")
R("before")
R("after")
R("contains")
R("contained-by")
R("overlap")
R("disjoint")
R("incompatible")
R("unknown")
```

The model record or reference fixes time scale, epoch/calendar, coordinate, precision, endpoint inclusivity, open bounds, leap behavior where relevant, and uncertainty representation. A bare host timestamp or locale-formatted string is insufficient.

## 12.3 Subject-time identity

Changing subject-time changes ClaimId. This includes:

- yesterday versus today;
- one event identifier versus another;
- one interval versus another;
- one log horizon or snapshot time versus another when it is the time the proposition concerns;
- an atemporal assertion versus a time-located assertion;
- a temporal-model version whose interpretation changes.

An expression such as “now,” “today,” or “current” MUST be resolved to an explicit temporal value before ClaimId projection. A projector MUST NOT consult the current clock. A caller asking “does the file exist now?” constructs a claim located at the explicit query instant or interval chosen by the temporal profile.

## 12.4 Evidence time is not subject-time

Two observations at different times can target the same atemporal or historically located claim. They are different warrants, not different ClaimIds, unless the proposition itself changes temporal location.

Conversely, an observation performed at time `T2` does not automatically target a proposition about `T2`. The WarrantTarget embeds the ClaimId subject-time and separately binds observation/execution time. A procedure can run today to establish a claim about yesterday, or run yesterday and fail to establish a claim about today.

## 12.5 Exact direct temporal matching

Direct WarrantTarget matching requires exact subject-time equality. A time calculus relation such as `contains` is not enough for direct support under LCI/0.

This choice is conservative and intentional. Temporal generalization depends on persistence assumptions, event semantics, sampling, change rates, and domain policy. Those assumptions belong in an explicit derivation calculus and warrant, not in a generic identity matcher.

## 12.6 Freshness

Freshness is an admissibility predicate over at least:

```text
claim subject-time
observation or execution time
warrant issue time
warrant validity interval
standing-query time
policy
runtime state
```

Freshness never changes ClaimId. A stale warrant remains the same warrant targeted at the same claim; it simply may no longer count.

## 12.7 Temporal refusal examples

A conforming implementation returns a typed refusal for:

- an unclassified legacy `as-of`;
- an unresolved relative time such as ambient “now”;
- a subject-time whose model is unsupported;
- an interval with invalid endpoint ordering under its model;
- a target whose observation time is substituted into the embedded ClaimId;
- a current-time claim offered only stale evidence when policy requires freshness;
- a direct target whose subject-time differs even when one interval contains the other.

---

# 13. Interpretation-frame model

## 13.1 Purpose

An interpretation frame binds semantic context that can make identical surface data express different propositions. It is required in ClaimId because proposition normalization is not meaningful in a vacuum.

A frame is not a bag of all surrounding context. It includes only context whose change can alter denotation, typing, evaluation, or the normalized proposition relation.

## 13.2 Candidate frame components

A frame schema can include:

- ontology and ontology version;
- data schema and schema version;
- unit system or dimensional convention;
- legal jurisdiction and legal-text version when meaning-bearing;
- scientific model or coordinate convention used for interpretation;
- textual edition, manuscript version, or canonical source edition;
- parser semantics version;
- evaluator semantics version;
- language or dialect when semantic ambiguity survives normalization;
- identifier-resolution environment, provided it is an immutable stable identity rather than a mutable symbol table.

A specific parser executable, model invocation, or human interpreter used to produce the result is provenance or WarrantTarget material unless its semantics are the frame itself.

## 13.3 Normalization before ClaimId

The required flow is:

```text
(surface, source-language, source-artifact, frame, interpreter)
    -> normalized proposition
    + interpretation receipt
    + represented loss, if any
```

The normalized proposition and the exact frame enter ClaimId. Source surface, source artifact, interpreter occurrence, diagnostics, and loss receipt remain provenance unless the loss forces a new proposition or location.

A conforming interpreter MUST NOT construct ClaimId from raw surface text when the claim profile defines a normalized AST. It MUST NOT infer an ontology, unit system, jurisdiction, edition, or evaluator version from ambient process state.

## 13.4 Interpretation receipt

A profile may use an inert record equivalent to:

```text
InterpretationReceipt/0 = Record{
  K("kind")                 => T("interpretation-receipt"),
  K("source-artifact")      => <StableRef/0 or explicit not-applicable value>,
  K("surface-form")         => <CD/0 value>,
  K("source-language")      => <stable language/dialect reference>,
  K("interpretation-frame") => <InterpretationFrame/0>,
  K("interpreter")          => <StableRef/0 to procedure/model/human-process scheme>,
  K("result-proposition")   => <normalized proposition>,
  K("represented-loss")     => <Seq of represented-loss records>
}
```

The receipt can be targeted by a `translated`, `reported`, or profile-defined interpretation warrant. The receipt is not automatically authenticated by being well formed.

## 13.5 Same surface, different frames

Identical printer text under incompatible frames produces different ClaimIds whenever the normalized proposition or frame differs. Examples include:

- `bank` under a financial ontology versus a river-geomorphology ontology;
- `10` under metre versus foot default units;
- a legal term under two jurisdictions;
- a field interpreted under schema version 1 versus version 2;
- the same source program under evaluator semantics that changed numeric equality;
- the same quoted sentence from two editions where surrounding definitions differ.

## 13.6 Different surface, same proposition

Different spellings, languages, syntactic sugar, or alpha-renamings can produce the same ClaimId only when the profile's deterministic interpretation and normalization yields exactly equal proposition and frame values. The interpretation receipts remain distinct provenance.

No implementation can assert this equality merely because a language model says the sentences “mean the same thing.” It must produce the exact normalized proposition under a declared profile or a separate proposition-equivalence/translation relation.

## 13.7 Translation

An exact translation can normalize to the same proposition and frame, preserving ClaimId while recording a translation lineage edge. An imperfect translation normally yields a different proposition and/or frame, therefore a different ClaimId, plus an explicit `claim-translates-to` relation and represented loss.

Translation never creates authority for the target claim. It can produce a translated warrant whose admissibility is separately evaluated.

---

# 14. Procedure, module, corpus, model, artifact, and policy references

## 14.1 Common rule

Every identity-bearing reference in ClaimId or WarrantTarget uses `StableRef/0` or a profile record whose semantics are at least as explicit. Display names, package names, symbols, filenames, URLs, model marketing names, and policy labels are aliases unless a stable scheme explicitly makes their exact versioned content identity-bearing.

A reference scheme MUST specify its domain, exact identity material, version interpretation, alias behavior, dependency treatment, and represented-loss behavior. If it uses a digest, it must separately specify algorithm, output encoding, domain separation, and collision handling.

## 14.2 Module references

A module reference intended to survive process boundaries should bind, as appropriate:

```text
module identity domain
module schema/semantics version
immutable source or compiled content identity
language/evaluator profile
export table identity
relevant dependency identity
```

A Common Lisp package object or Python module object is not a module identity. A package/module display name can change without preserving or destroying module identity unless the module scheme says so.

## 14.3 Procedure references

A procedure reference used in a WarrantTarget should bind at least:

```text
module reference
stable export/binder identity
procedure semantics version
immutable code/content identity or equivalent immutable implementation identity
ABI/evaluator profile when behavior depends on it
relevant dependency closure or declared dependency policy
```

A pair such as `(procedure-name, version-string)` is insufficient when the registry can rebind it to different code. A procedure scheme can use a signed release manifest, content identity, reproducible build identity, or another later mechanism; LCI/0 does not choose one.

Different procedures can support the same ClaimId. Procedure differences create different warrant targets/identities, not automatically different claims.

## 14.4 Corpus and revision references

A corpus-relative ClaimId uses two concepts:

- the logical corpus identity, which can persist across revisions; and
- an immutable revision/snapshot identity, which fixes the content universe for the claim.

The revision reference cannot be only a mutable human-readable name such as `latest`, `main`, `production`, or `dataset.csv`. A name-resolution event may be recorded in provenance, but ClaimId binds the resolved immutable revision.

A corpus used only as evidence for a world-basis claim belongs in the WarrantTarget. Superseding that corpus can make the warrant stale or inadmissible without changing the world claim.

## 14.5 Dataset-slice references

A slice value binds its own calculus/schema and exact expression. It can be structural—for example explicit record filters—or a stable reference to an immutable manifest. Two slices with extensionally equal members remain different ClaimId coordinates unless the slice profile normalizes them before projection.

A processing shard that does not change the claim's semantic domain is WarrantTarget execution detail, not a ClaimId slice.

## 14.6 Policy references

Admissibility and standing decisions use a stable policy identity/version. Decision receipts should bind:

```text
policy reference
policy parameters
state snapshot/reference
query time
candidate claim and warrant references
decision and reasons
```

Admissibility policy never enters ClaimId. `LCIIdentityPolicy/0` is a separate identity-domain record and must not be confused with an evidentiary policy.

## 14.7 Model references

A model reference in a WarrantTarget should bind model family only when relevant, plus exact version/checkpoint/content identity, inference semantics, tokenizer or input interpretation where relevant, and dependency/runtime profile when behavior can change.

A model name such as `model-latest` is not stable. A textually identical answer from two model versions can support the same semantic claim through two distinct warrants.

## 14.8 Prompt and invocation references

A prompt/invocation reference binds exact canonical input, tool configuration, system/developer context where included by the invocation scheme, sampling parameters, model reference, and invocation event identity. Secrets can be represented by stable commitments under a later scheme, but omission cannot be silently treated as equality.

Prompt identity is not ClaimId unless the proposition explicitly asserts the behavior of that invocation.

## 14.9 Artifact references

An artifact reference binds immutable content or a versioned artifact identity. A filename, URL, repository path, or document title is presentation/custody data unless resolved to immutable material.

When a warrant says an external artifact supports a claim, the artifact reference belongs in WarrantTarget. When the proposition says that the artifact itself contains or has a property, the artifact reference appears as a proposition subject.

## 14.10 Principal references

Issuer, claimant, observer, translator, and reporter identities use stable principal-reference schemes. Principal identity can affect warrant identity, authority, and admissibility. It does not enter ClaimId merely because a principal asserted the claim.

---

# 15. Lineage and succession relations

## 15.1 Decision

Lineage does not participate in ClaimId. It is an explicit historical relation among claim occurrences and artifacts. Equal ClaimIds neither prove nor imply lineage. Lineage neither proves nor implies equal ClaimIds.

This decision permits exact copying, independent re-derivation, and multiple agents' assertions to share semantic identity without pretending they share custody or authority. It also permits translation, correction, and migration to preserve explicit succession while changing semantic identity.

## 15.2 Claim-lineage edge

A profile representing claim-occurrence lineage should use a closed inert record equivalent to:

```text
ClaimLineageEdge/0 = Record{
  K("kind")                   => T("claim-lineage-edge"),
  K("schema-version")         => 0,
  K("relation")               => <lineage relation Identifier>,
  K("source-occurrence")      => <StableRef/0>,
  K("destination-occurrence") => <StableRef/0>,
  K("source-claim")           => <ClaimIdEnvelope/0>,
  K("destination-claim")      => <ClaimIdEnvelope/0>,
  K("receipt")                => <inert CD/0 receipt Record>,
  K("represented-loss")       => <Seq of RepresentedLoss/0>
}
```

All fields are required. An empty loss sequence explicitly states that the edge reports no represented loss; it does not prove that the transformation was lossless or authenticated. The edge itself is inert testimony until a lineage-verification system accepts it.

## 15.3 Standard lineage relations

LCI/0 reserves semantic relation names for at least:

```text
R("exact-copy")
R("independent-rederivation")
R("freeze-revival")
R("reconstruction")
R("translation")
R("correction")
R("provenance-correction")
R("migration")
R("inheritance")
R("compaction")
R("supersession")
```

A later lineage profile fixes exact edge evidence and verification rules. The relation name alone does not prove the event.

## 15.4 Exact copy

An exact copy normally has equal source and destination ClaimIds. It still has a distinct occurrence reference when copied into a new assertion, process, artifact, or custody event.

The edge records historical relation. ClaimId equality would remain even if the edge were absent; the edge would remain historical testimony even if later evidence showed the bytes were copied through an unauthorized channel.

## 15.5 Independent re-derivation

Two independently produced occurrences can have the same ClaimId without either descending from the other. An `independent-rederivation` relation may connect both to shared inputs or evidence, but LCI/0 never invents a predecessor merely because envelopes are equal.

This is why predecessor ClaimId is not part of ClaimId: semantic co-reference must not depend on which occurrence happened first.

## 15.6 Freeze and revival

Freeze serializes inert data. Revival constructs a new claim occurrence.

If proposition, scope, subject-time, basis, interpretation frame, profile location, claim profile, and identity policy are recovered exactly, the revived occurrence has the same ClaimId. It has no surviving live warrant merely because serialized predecessor testimony exists. A `freeze-revival` edge and represented-loss record can explain the discontinuity.

If any identity-bearing coordinate is changed or unavailable, revival either produces a different explicitly loss-qualified ClaimId or is refused. A mutable alias such as `latest` cannot be resolved at revival and silently substituted for the frozen corpus revision.

## 15.7 Reconstruction

Reconstruction from testimony is not exact copying. Its receipt identifies witnesses, fragments, interpretation procedures, unresolved disagreements, and loss.

Exact ClaimId recovery is permitted only when every identity-bearing field is deterministically recovered and validated. Confidence that a missing field was “probably” some value is not equality. An unresolved identity field requires a new proposition/location that explicitly represents uncertainty, or refusal to construct a located claim.

## 15.8 Translation

Translation produces an explicit relation from source occurrence/ClaimId to target occurrence/ClaimId. If normalized proposition and frame remain exactly equal, ClaimId can be preserved. If either changes, the relation remains while ClaimId changes.

An imperfect translation carries represented loss and cannot be silently treated as `same-claim`. A policy can reason over `claim-translates-to`, but the identity relation remains exact.

## 15.9 Correction

A correction that changes only provenance—for example, fixing the source filename, claimant display label, or parser receipt while leaving normalized proposition and location intact—preserves ClaimId and uses `provenance-correction`.

A correction that changes proposition content or an identity-bearing location field produces a new ClaimId and uses `correction` or `supersession`. The old claim is not erased from history, and its warrants do not directly target the new claim.

## 15.10 Migration

Migration creates a new LCI/0 envelope from legacy material. The legacy fingerprint or artifact identity remains a predecessor reference. It is never declared equal to ClaimId by format conversion alone.

If legacy material preserves all semantic fields, multiple migrations can produce the same LCI/0 ClaimId. That equality comes from the newly projected envelope, not from old fingerprint equality or lineage.

## 15.11 Inheritance across agents

An agent can inherit testimony about a claim and assert an occurrence with the same ClaimId. Claimant changes do not change semantic identity. The inheritance edge records the transfer claim; it does not transfer live authority, capability, or warrant standing.

The receiving agent requires its own authorized replay, attestation, adoption, or policy-recognized inheritance mechanism before the inherited testimony counts as a live warrant.

## 15.12 Compaction and represented loss

Compaction can preserve ClaimId when it drops only identity-neutral provenance and records that loss. If it drops or conflates proposition/location distinctions, it cannot claim the original ClaimId. A new loss-qualified claim or refusal is required.

## 15.13 `claim-descends-from`

`claim-descends-from(x,y,graph,policy)` is a query over an explicit lineage graph and a lineage-verification policy. It is not derivable from ClaimId bytes alone.

A conforming implementation MUST NOT return true solely because `same-claim(x,y)` is true. It MUST NOT return false solely because ClaimIds differ, because corrections, translations, and migrations can create genuine lineage across changed identities.

## 15.14 Succession does not carry standing

No lineage relation—copy, inheritance, revival, reconstruction, translation, or migration—automatically transfers current standing. Standing is recomputed for the destination occurrence/claim under current warrants, state, policy, and query time.

---

# 16. Represented-loss behavior

## 16.1 Minimum record

LCI/0 profiles representing loss should use a closed inert record equivalent to:

```text
RepresentedLoss/0 = Record{
  K("kind")            => T("represented-loss"),
  K("schema-version")  => 0,
  K("operation")       => <StableRef/0 to migration/translation/compaction operation>,
  K("source")          => <StableRef/0 to source artifact or occurrence>,
  K("lost-dimensions") => <Seq of exact Identifier values>,
  K("consequence")     => <Identifier>,
  K("account")         => <closed explanatory Record>
}
```

`consequence` is one of a profile's exact values including at least:

```text
R("identity-neutral-loss")
R("identity-bearing-loss")
R("authority-or-custody-loss")
R("semantic-translation-loss")
R("unknown-consequence")
```

A loss record is testimony unless authenticated by another layer. Its presence nevertheless prevents a conforming adapter from silently claiming losslessness.

## 16.2 Identity-neutral loss

If every ClaimId field is exactly recovered and the lost material is confined to presentation, redundant provenance, nonidentity comments, or historical detail, the new occurrence can preserve ClaimId. The loss remains available to admissibility policy.

Example: a migration loses the original UI field order but preserves normalized proposition, exact scope, subject-time, corpus revision, frame, and profile location. CD/0 record order was not semantic; ClaimId remains.

## 16.3 Recoverable source distinctions

A source distinction can be lost from the transport syntax yet recovered through an authenticated mapping. For example, a package-qualified legacy symbol can map to an exact segmented identifier using a frozen symbol table. The adapter records the mapping receipt. If the resulting identity field is exact and unambiguous, the LCI/0 ClaimId is valid.

The legacy source identity is still not automatically equal to the new ClaimId.

## 16.4 Identity-bearing loss

If proposition or location cannot be recovered exactly, an adapter MUST NOT emit the ClaimId it guesses the source intended. It has two conforming choices:

1. reject migration with `IdentityBearingLoss`; or
2. construct a new proposition/location that explicitly asserts the uncertainty or ambiguity under a profile-defined tagged form, thereby producing a different ClaimId.

Unit, field omission, empty string, zero, `nil`, `None`, a wildcard, or “latest” cannot stand in for an unknown identity coordinate unless a profile explicitly defines that as the proposition's meaning. Such a loss-qualified claim is not an alias for any concrete original claim.

## 16.5 Authority or custody loss

A freeze, transport, decode, or reconstruction can preserve ClaimId while losing live authority, custody continuity, or revocation visibility. The destination occurrence starts without inherited live warrants unless a separate trusted runtime mechanism establishes them.

This is not identity-bearing loss because semantic content and location can remain exact. It is still admissibility-critical.

## 16.6 Semantic translation loss

When translation loses modality, quantifier scope, entity resolution, temporal nuance, units, legal force, or another semantic distinction, the target normalized proposition/frame changes or becomes explicitly uncertain. The target therefore receives a different ClaimId. The translation edge and loss record connect it to the source.

## 16.7 Package and identifier collapse

If migration stripped Common Lisp package identity and two package-distinct symbols now have the same print name, the adapter cannot reconstruct one exact subject/procedure/reference without external evidence. It MUST return `AmbiguousIdentifier` or construct an explicit ambiguity proposition under a new ClaimId. It MUST NOT choose whichever package is currently interned.

## 16.8 Loss and admissibility

An admissibility policy can reject or downgrade warrants associated with any represented loss, including identity-neutral loss. That judgment does not alter ClaimId. The decision receipt should name the exact loss records considered.

## 16.9 Loss-account completeness

A migration or transformation claiming compatibility with LCI/0 MUST enumerate every known lost source dimension and classify its consequence. An empty loss sequence means “this operation reports no known loss,” not “mathematical proof of perfect preservation.”

---

# 17. Equality and relation laws

## 17.1 Same-claim law

For valid claims `x` and `y`:

```text
same-claim(x, y)
    iff
claim-id-envelope(x) = claim-id-envelope(y)
```

The equality is CD/0 structural equality.

`same-claim` is reflexive, symmetric, and transitive over valid LCI/0 claims.

## 17.2 Canonical-octet law

For valid ClaimId envelopes `a` and `b`:

```text
a = b
    iff
canonical-octets(a) = canonical-octets(b)
```

This law assumes successful validation and sufficient CD/0 resource budgets. Hash equality is not substituted for canonical-octet equality.

## 17.3 Field-sensitivity law

If two valid envelopes differ in any required top-level field or any nested identity-bearing field, they are different ClaimIds:

```text
exists identity path p:
  value-at(a,p) != value-at(b,p)
therefore
  a != b
```

No equivalence calculus silently rewrites the envelope after projection.

## 17.4 Metadata-neutrality law

Let `metadata-update(c,m)` change only fields that a separately versioned claim-occurrence or artifact schema explicitly classifies as nonidentity provenance, lineage, standing testimony, or presentation metadata, while leaving the semantic claim core unchanged. Then:

```text
ClaimId(metadata-update(c,m)) = ClaimId(c)
```

An unknown field is not presumed nonidentity; it is rejected.

## 17.5 Proposition equivalence is separate

```text
same-claim(x,y) -> proposition(x) = proposition(y)
```

but generally:

```text
proposition-equivalent(x,y)
    does not imply
same-claim(x,y)
```

because scope, subject-time, basis, frame, or profile location may differ. Conversely, exact proposition CD/0 equality is stronger than a calculus that merely judges semantic equivalence.

`proposition-equivalent` is profile/calculus-relative and can return true, false, incompatible, or unknown.

## 17.6 Claim refinement law

LCI/0 defines scope refinement only:

```text
claim-refines(x, y)
    iff
  identity-policy/profile/proposition/subject-time/basis/frame/profile-location
      are exactly equal
  and
  scope-relation(scope(x), scope(y)) is R("narrower")
```

`claim-refines` does not imply `same-claim`. It does not include temporal, corpus, frame, translation, or proposition-equivalence refinement.

## 17.7 Translation law

```text
claim-translates-to(x, y, receipt)
```

is true only under an explicit translation relation accepted by the relevant translation policy/calculus. It does not follow from similar text, equal hashes, shared claimant, or lineage alone. It can relate equal or unequal ClaimIds.

## 17.8 Descent law

```text
claim-descends-from(x, y, graph, policy)
```

is a lineage query. It can hold when ClaimIds are equal or unequal. It never follows from equality alone.

## 17.9 Exact-target law

```text
warrant-target-exact(t, c)
    iff
  t.claim = ClaimId(c)
  and target-boundaries-cohere(t,c)
```

A proposition-only target cannot satisfy this law.

## 17.10 Scope-projection law

```text
warrant-target-matches(t,c) = supports-by-scope-narrowing
```

only under all conditions in Section 10.3. No other ClaimId field can differ.

## 17.11 No widening law

If `scope(t.claim)` is narrower than `scope(ClaimId(c))`, direct target matching fails with `ScopeWideningForbidden`. No admissibility policy can turn that same target into direct broad support without an explicit derived warrant.

## 17.12 Admissibility law

Conceptually:

```text
warrant-admissible(w, c, policy, state, query-time)
    iff
  genuine-warrant(w, state)
  and target-relation-permitted(w.target, c, policy)
  and authority-valid(w, state, policy)
  and validity-holds(w, query-time, state)
  and freshness-holds(w, c, query-time, policy)
  and loss-permitted(w, policy)
  and all policy-specific conditions hold
```

LCI/0 fixes neither the full predicate set nor their order, but a conforming system MUST NOT return admissible when target matching fails, the warrant is only inert predecessor testimony, or revocation state known to the policy invalidates it.

## 17.13 Standing law

```text
standing(state, claim, policy, query-time)
    = query over admissible live warrants,
      refutations, revocations, validity,
      consumption, and policy state
```

Changing `state`, `policy`, or `query-time` can change standing while ClaimId remains fixed.

## 17.14 Inertness law

```text
decode-exact(canonical-octets(warrant-shaped-record))
    -> inert CD/0 value
```

It never yields a live warrant, authority, capability, active receipt, or current standing. Privilege requires a separate runtime act.

## 17.15 Migration law

A legacy fingerprint `f` can be stored as predecessor metadata, but:

```text
legacy-fingerprint(f) = ClaimId(c)
```

is false as a type/domain claim unless a separate verified mapping scheme explicitly defines and proves that relation. Ordinary migration computes a new ClaimId envelope from mapped proposition and location.

## 17.16 Digest-separation law

For any later digest function `H`:

```text
H(domain-frame(ClaimId(x))) = H(domain-frame(ClaimId(y)))
```

is not the definition of `same-claim`. Semantic equality remains envelope equality. The cryptographic scheme defines what operational confidence a digest comparison provides.

## 17.17 No self-certification law

A claim, warrant, model output, or artifact cannot establish its own identity, authority, or admissibility by containing fields that say it has them. Validators recompute identity and consult the proper runtime or policy layer.

---

# 18. Typed failure vocabulary

## 18.1 Failure envelope

LCI/0 operations return successful values or typed failures. Host exception text is not a conformance surface.

A serializable failure projection uses:

```text
LCIFailure/0 = Record{
  K("kind")           => T("failure"),
  K("schema-version") => 0,
  K("category")       => <Identifier>,
  K("code")           => <Identifier>,
  K("stage")          => <Identifier>,
  K("path")           => <Seq of field Identifiers and sequence indexes>,
  K("context")        => <closed inert Record>
}
```

All fields are required. `context` contains only bounded inert data approved for the failure code. Secret capability material, arbitrary source excerpts, host stack traces, and live objects are forbidden.

Implementations MAY expose local diagnostic prose outside this envelope. Shared conformance compares category, code, stage, and structural path; it does not compare prose.

## 18.2 Categories

LCI/0 defines at least:

```text
F("invalid-input")
F("unsupported-version-or-profile")
F("projection-refusal")
F("reference-refusal")
F("target-mismatch")
F("relation-undetermined")
F("migration-refusal")
F("privilege-refusal")
F("resource-refusal")
F("internal-invariant-failure")
```

CD/0 decode, canonicality, and resource failures retain their frozen CD/0 categories. An LCI layer does not relabel malformed CD/0 bytes as an LCI semantic failure.

## 18.3 Stages

Shared LCI vectors use at least:

```text
claim-shape
lci-version
identity-policy
claim-profile
proposition
location
scope
subject-time
basis
interpretation-frame
profile-location
stable-reference
projection
claim-id-cache
target-shape
target-schema
target-boundaries
target-relation
admissibility-precondition
lineage
represented-loss
migration-source
migration-mapping
privilege-boundary
internal
```

## 18.4 Claim and projection codes

| Code | Category | Required meaning |
|---|---|---|
| `InvalidClaimRecord` | invalid-input | Claim input is not the required record/view shape. |
| `MissingRequiredField` | invalid-input | A required LCI/profile field is absent. |
| `UnknownField` | invalid-input | A closed understood schema contains an unlisted field. |
| `UnexpectedUnit` | invalid-input | Unit appears where the schema requires another value or an explicit neutral tagged form. |
| `UnsupportedLCIVersion` | unsupported-version-or-profile | `lci-version` is not supported. |
| `UnsupportedIdentityPolicy` | unsupported-version-or-profile | Identity policy ID/version is not the exact supported projection. |
| `UnsupportedClaimProfile` | unsupported-version-or-profile | Claim profile ID/version is not supported. |
| `UnnormalizedProposition` | projection-refusal | Proposition is raw, ambiguous, or not in the profile's canonical semantic form. |
| `InvalidProposition` | invalid-input | Proposition violates the selected profile grammar. |
| `InvalidClaimLocation` | invalid-input | Location record is malformed. |
| `PropositionLocationInconsistent` | projection-refusal | Proposition and basis/frame/time/scope combination violates profile rules. |
| `SelfDeclaredClaimId` | projection-refusal | Input attempts to substitute a declared ID/digest for projection. |
| `ClaimIdCacheMismatch` | projection-refusal | Recomputed envelope differs from cached envelope or verified cache material. |
| `ProjectionNonDeterminism` | internal-invariant-failure | Repeated or differential projection of the same validated abstract input differs. |

## 18.5 Reference codes

| Code | Category | Required meaning |
|---|---|---|
| `InvalidStableReference` | reference-refusal | StableRef shape/domain/scheme/material is invalid. |
| `UnsupportedReferenceScheme` | unsupported-version-or-profile | The declared reference scheme is unknown. |
| `MutableReference` | reference-refusal | Identity material resolves only through mutable alias or ambient registry state. |
| `AmbiguousIdentifier` | reference-refusal or migration-refusal | Source identity distinctions do not select one exact segmented identifier. |
| `UnresolvedAlias` | reference-refusal | A display name such as `latest` has not been resolved to immutable material. |
| `ProcedureIdentityInsufficient` | reference-refusal | Procedure target lacks immutable semantics/code binding required by its schema. |
| `CorpusRevisionIdentityInsufficient` | reference-refusal | Corpus basis or target lacks an immutable revision. |

## 18.6 Scope, temporal, basis, and frame codes

| Code | Category | Required meaning |
|---|---|---|
| `InvalidScope` | invalid-input | Scope record/expression is invalid under its calculus. |
| `UnsupportedScopeCalculus` | unsupported-version-or-profile | Scope calculus is unsupported. |
| `ScopeWideningForbidden` | target-mismatch | Narrow evidence was offered for a broader claim. |
| `ScopeOverlapInsufficient` | target-mismatch | Scopes overlap but neither safely subsumes the other. |
| `ScopeDisjoint` | target-mismatch | Comparable scopes are proven disjoint. |
| `ScopeIncompatible` | relation-undetermined | No valid comparison bridge exists. |
| `ScopeRelationUnknown` | relation-undetermined | Comparison is meaningful but unresolved. |
| `InvalidSubjectTime` | invalid-input | Subject-time is malformed or invalid under its model. |
| `UnsupportedTemporalModel` | unsupported-version-or-profile | Temporal model is unsupported. |
| `UnresolvedRelativeTime` | projection-refusal | `now`, `today`, or another relative form was not resolved before projection. |
| `SubjectTimeMismatch` | target-mismatch | Target and candidate ClaimIds have different subject-time. |
| `InvalidBasis` | invalid-input | Claim basis is malformed. |
| `BasisMismatch` | target-mismatch | World/corpus mode, corpus, revision, slice, or semantic boundary differs. |
| `InvalidInterpretationFrame` | invalid-input | Frame is malformed under its schema. |
| `UnsupportedInterpretationFrame` | unsupported-version-or-profile | Frame schema/version is unsupported. |
| `InterpretationFrameMismatch` | target-mismatch | Target and candidate frames differ. |
| `ProfileLocationMismatch` | target-mismatch | Profile-location differs. |

## 18.7 Target codes

| Code | Category | Required meaning |
|---|---|---|
| `InvalidWarrantTarget` | invalid-input | Common target envelope is malformed. |
| `UnsupportedTargetKind` | unsupported-version-or-profile | Target kind/schema is not supported. |
| `TargetSchemaKindMismatch` | invalid-input | Target schema does not define the declared target kind. |
| `TargetBoundaryMissing` | invalid-input | A kind-required boundary is absent. |
| `TargetBoundaryUnknown` | invalid-input | A closed target schema contains an unlisted boundary. |
| `TargetBoundaryMismatch` | target-mismatch | A boundary is inconsistent with the embedded claim or candidate relation. |
| `PropositionMismatch` | target-mismatch | Embedded target proposition differs. |
| `ClaimProfileMismatch` | target-mismatch | Claim profiles differ. |
| `IdentityPolicyMismatch` | target-mismatch | Identity policies differ. |
| `TemporalCoverageInsufficient` | target-mismatch or admissibility precondition | Evidence event does not cover the required temporal boundary. |
| `CorpusCompletionInsufficient` | target-mismatch or admissibility precondition | Search did not establish the declared completion boundary. |
| `ProcedureMismatch` | target-mismatch | Procedure/code/invocation boundary differs from the warranted event. |
| `PremiseMismatch` | target-mismatch | Derived target premises differ from the derivation event. |
| `TranslationBoundaryMismatch` | target-mismatch | Source/target frame, source ClaimId, procedure, receipt, or loss differs. |
| `ClaimTargetMismatch` | target-mismatch | No more specific target relation applies after successful validation. |

## 18.8 Migration, loss, and privilege codes

| Code | Category | Required meaning |
|---|---|---|
| `UnsupportedLegacyForm` | migration-refusal | Source form has no declared adapter. |
| `LegacyFingerprintNotClaimId` | migration-refusal | Legacy fingerprint was offered as ClaimId or complete target. |
| `UnclassifiedAsOf` | migration-refusal | Legacy `as-of` role is unresolved. |
| `IdentityBearingLoss` | migration-refusal | A ClaimId field cannot be recovered exactly. |
| `RepresentedLossRequired` | migration-refusal | Adapter would discard a known distinction without a loss record. |
| `LegacyWarrantInert` | privilege-refusal | Serialized or predecessor attestation was offered as a live warrant. |
| `PrivilegedRestorationAttempt` | privilege-refusal | Inert data was offered as authority, capability, active receipt, or current standing. |
| `ReplayAuthorizationRequired` | privilege-refusal | Live successor warrant requires authorized replay/re-attestation. |
| `LineageUnverified` | privilege-refusal or admissibility precondition | Inert lineage testimony was offered as verified continuity. |
| `AdmissibilityUndetermined` | relation-undetermined | Required policy/state information is unavailable. |

## 18.9 Failure precedence

Operations validate from outer syntax to version/profile, then nested identity fields, then cross-field consistency, then relation. For a shared single-fault vector, implementations MUST return the vector's exact category/code/stage/path.

For a multi-fault input, the following precedence applies within LCI after successful CD/0 decoding:

1. LCI envelope shape and required fields;
2. LCI version;
3. identity policy;
4. claim profile;
5. proposition validation;
6. location shape and nested scope/time/basis/frame/profile-location validation;
7. cross-field consistency;
8. ClaimId projection/cache comparison;
9. WarrantTarget common shape and target schema;
10. target boundaries;
11. exact/nonexact target relation;
12. migration or privilege checks specific to the requested operation.

Fuzzed multi-defect inputs should be minimized before a new exact precedence vector is constitutionalized.

---

# 19. Versioning and field-evolution rules

## 19.1 Version axes

LCI/0 keeps these axes distinct:

```text
CD/0 format version
LCI envelope version
identity-policy version
claim-profile version
proposition schema/normalizer version
scope-calculus version
subject-time model version
basis/slice/boundary schema version
interpretation-frame schema/version
target-kind schema version
reference-scheme versions
migration-adapter version
claim-occurrence/artifact schema version
```

A project MUST NOT overload one axis to stand for another.

## 19.2 LCI envelope version

`lci-version = 0` fixes the common ClaimId and WarrantTarget envelope shapes in this document. Changing the common required fields, their types, or their role requires a later LCI envelope version.

## 19.3 Identity-policy version

`LCIIdentityPolicy/0` fixes the exact ClaimId projection. Any change to which full-claim fields enter the envelope, any new semantic location coordinate, or any reinterpretation of an identity-bearing field requires a new identity-policy version.

Because the policy record is itself in ClaimId, claims projected under different identity policies are not `same-claim` under exact LCI identity. A later bridge may relate them by migration or equivalence; it cannot pretend the envelopes are equal.

## 19.4 Claim-profile version

A claim profile version fixes:

- accepted normalized proposition grammar;
- proposition normalization contract;
- proposition/location consistency rules;
- allowed scope, temporal, basis, and frame schemas;
- exact profile-location schema;
- represented-loss forms that can alter or qualify proposition/location reconstruction.

Changing any meaning-bearing rule requires a new semantic claim-profile version. A bug fix that demonstrably changes no accepted abstract proposition, location, projection, relation, or failure result can remain an implementation correction, but its conformance evidence must show that boundary.

A claim-occurrence, artifact, provenance, lineage, or presentation schema is versioned separately and its version is not inserted into ClaimId. Adding an identity-neutral metadata field therefore does not force a new ClaimId. If such a schema begins to interpret a field as proposition or location, the semantic claim profile and identity policy must change instead.

## 19.5 No optional identity fields in /0

ClaimIdEnvelope/0 and ClaimLocation/0 have no optional fields. Neutral semantics use explicit tagged values. This eliminates disagreement over whether omission and Unit are equivalent and prevents implementation-specific default insertion.

A later LCI version can introduce an optional identity field only by defining exact absence semantics and a new identity policy. It cannot add the field to version 0.

## 19.6 Unknown fields

For every closed understood identity schema, unknown fields are rejected.

A full claim-occurrence or artifact schema may define an explicit nonidentity metadata subrecord. Fields inside that subrecord are ignorable only when the exact supported occurrence/artifact schema version declares the subrecord open and defines collision/namespace rules. An implementation MUST NOT infer that an unknown top-level claim field is presentation metadata.

## 19.7 Field addition decision rule

Before adding a candidate field, the profile author must document:

1. the semantic role;
2. whether changing it distinguishes a different proposition or location;
3. whether an existing direct warrant would become unsound if reused across the change;
4. why an existing ClaimId field cannot already express the distinction;
5. the counterexample for exclusion;
6. the counterexample for inclusion if it causes identity inflation;
7. whether the field belongs instead in WarrantTarget, Warrant identity, admissibility, provenance, lineage, or presentation.

If the field is identity-bearing, profile and identity-policy versions change. If it is nonidentity, the profile states that fact explicitly. Silence is not a classification.

## 19.8 Nested schema changes

Changing a scope calculus, temporal model, frame schema, slice calculus, boundary schema, or stable-reference scheme in a meaning-changing way requires a new exact reference/version. Because that reference is included in ClaimId or WarrantTarget where relevant, canonical identity changes deterministically.

## 19.9 Target-schema evolution

A WarrantTarget schema is closed and versioned. Adding a procedure code field, completion condition, trace binding, model version, premise rule, or other semantic target boundary requires a new target-schema reference. A target under the old schema does not silently acquire the new meaning.

Whether the change invalidates old warrants is an admissibility/migration decision. It never mutates the old target bytes.

## 19.10 Normalization changes

A change that makes the same surface form normalize to a different proposition or frame requires a new claim-profile or interpretation-frame schema version. An implementation MUST NOT deploy such a change under the same version and continue emitting version-0 ClaimIds.

## 19.11 Compatibility and bridges

A later version may define:

- exact migration into a new envelope;
- proposition equivalence;
- claim refinement;
- translation;
- lineage;
- target replay;
- admissibility compatibility.

None of those relations changes the equality of existing envelopes. Version bridges are explicit data and code, not ambient aliases.

## 19.12 Canonical-byte stability

An implementation update that claims conformance to the same CD/0, LCI, identity-policy, profile, and nested-schema versions MUST preserve ClaimId envelope values, canonical octets, target relation results, and typed single-fault refusals for all existing shared vectors.

---

# 20. Security and inertness boundary

## 20.1 Security posture

LCI/0 prevents identity confusion; it does not establish truth or authority. Its security boundary is a composition of:

- frozen CD/0 inert canonical data;
- closed, versioned identity projections;
- stable references rather than mutable names;
- typed WarrantTargets rather than proposition-only fingerprints;
- explicit scope and temporal calculi;
- fail-closed unknown-field behavior;
- strict separation of identity, admissibility, standing, provenance, lineage, and privilege.

## 20.2 Canonical identity is not truth

Equal ClaimIds mean that two valid records identify the same normalized proposition at the same semantic location under the same projection/profile. They do not mean the proposition is true, likely, lawful, safe, current, authorized, or well supported.

A malicious party can construct a perfectly canonical false claim. Canonical bytes make the falsehood reproducible; they do not give it a halo.

## 20.3 Decoding is inert

A conforming LCI reader MUST treat every decoded claim, target, warrant testimony, lineage edge, receipt, policy record, and represented-loss record as inert data. Decoding MUST NOT:

- register a procedure, module, model, policy, or principal;
- execute code or queries;
- create a live warrant or capability;
- mark a claim authenticated;
- restore current standing;
- resolve a mutable alias;
- perform network or filesystem access;
- certify custody or lineage.

## 20.4 Privileged warrant boundary

A live warrant can exist only through a separately authorized runtime operation. A CD/0 record with the exact shape of a warrant remains testimony. A migration adapter MUST NOT turn v1 predecessor testimony, serialized attestations, or raw artifact data into live LCI warrants.

Replay and re-attestation are new events with new WarrantTargets and warrant identities. The successor runtime's authority is checked at that event.

## 20.5 Self-declared identity attack

A model-generated or user-provided record can claim any ClaimId. The projector ignores such declarations, recomputes the envelope, and rejects mismatches. A target or warrant that embeds a malformed or inconsistent claim envelope is rejected before relation or admissibility evaluation.

## 20.6 Mutable alias and rebinding attack

Names such as `latest`, `main`, `production`, `model-current`, procedure symbols, package exports, filenames, and URLs can be rebound. Identity-bearing locations and targets bind immutable resolved references. Alias-resolution receipts remain provenance.

A procedure redefinition under the same display name cannot inherit old execution warrants when the target binds immutable procedure/code identity.

## 20.7 Stale-evidence attack

Subject-time, observation/execution time, issue time, validity, and query time are separate. Direct matching requires exact subject-time. Admissibility checks freshness. A warrant for yesterday cannot directly authenticate a claim located today.

## 20.8 Scope attack

Scope is immutable and in ClaimId. A target binds a complete ClaimId. Broad-to-narrow projection requires an explicit calculus result, a target-schema rule declaring the exact proposition form downward-monotone, boundary coverage, and policy permission. Narrow-to-broad reuse fails.

Mutation of a source host scope after construction cannot change the retained CD/0 scope or ClaimId.

## 20.9 Corpus-completion attack

Corpus identity, immutable revision, slice, and semantic boundary are bound when constitutive of the claim. The completion target separately binds search procedure/code and proof of reaching the boundary. A corpus-completion warrant says nothing beyond that bounded corpus claim unless an explicit derivation warrants a world claim.

## 20.10 Interpretation confusion attack

Frame identity prevents identical printer text from collapsing across ontology, schema, units, jurisdiction, scientific model, edition, or evaluator semantics. Surface language and translation receipts remain explicit. No ambient parser or package environment may decide identity.

## 20.11 Hash and collision boundary

LCI/0 selects no hash. A later digest scheme uses the exact domain-framed ClaimId envelope. Implementations MUST NOT equate hash equality with semantic equality when the scheme's collision and envelope-resolution rules are not satisfied.

A collision-resistant digest is an operational compact reference. The ClaimId envelope remains the semantic object.

## 20.12 Resource and parser boundary

LCI/0 inherits CD/0's exact decoding, canonicality checks, immutable views, and explicit resource budgets. Profile validation and relation functions must also apply bounded resource policies. Resource refusal is not semantic invalidity.

A profile MUST NOT pass source strings to a Common Lisp reader, Python pickle, evaluator, shell, SQL engine, template engine, or generic object constructor as part of identity projection.

## 20.13 Profile-code trust

A profile normalizer or calculus is executable implementation code and can be buggy or malicious. Its identity/version and shared vectors are therefore part of the conformance boundary. ClaimId projection is deterministic only relative to that frozen profile definition.

This does not put the implementation binary in ClaimId. It requires independent implementations to demonstrate the same abstract results.

## 20.14 Current-state noninterference

ClaimId projection MUST be independent of current warrants, revocations, policy, standing, network state, wall clock, process identity, database contents, and current procedure registry. Repeating projection over the same validated abstract claim yields the same envelope after any such state changes.

## 20.15 Custody and authenticity

Signatures, manifests, receipts, and custody chains can authenticate bytes or bounded events under later schemes. They do not change ClaimId unless the proposition or location itself changes. A valid signature over a claim does not make the claim true; a missing signature does not make it a different claim.

---

# 21. Twenty required worked scenarios

## Scenario 1 — “The file exists” yesterday versus today

Let `P` be the normalized proposition that stable file reference `F` exists. Construct:

```text
C_y = (P,
       scope = relevant filesystem/domain scope,
       subject-time = day 2026-07-12,
       basis = world,
       frame = filesystem semantics V,
       profile-location = {})

C_t = (P,
       same scope,
       subject-time = day 2026-07-13,
       same basis/frame/profile-location)
```

`ClaimId(C_y) != ClaimId(C_t)` because subject-time differs. An observation warrant minted yesterday embeds `ClaimId(C_y)` and records its own observation time. It does not directly match `C_t`.

A domain-specific persistence calculus may derive “exists at 2026-07-13” from earlier existence plus evidence that no deletion or replacement occurred. That result is a new `derived` warrant targeting `ClaimId(C_t)`. LCI/0 refuses the cheaper trick of calling the old observation “close enough.” Files, rather rudely, can disappear while nobody is looking.

If the source phrase was “the file exists now,” the interpreter resolves `now` to an explicit instant/interval before projection. No ambient clock is read during ClaimId construction.

## Scenario 2 — The same proposition over corpus version 3 versus corpus version 4

Let `P` be “no entry satisfies predicate Q.” If this is a corpus-relative assertion, construct:

```text
Basis_3 = corpus(C, revision=3, slice=S, boundary=B)
Basis_4 = corpus(C, revision=4, slice=S, boundary=B)
```

Even when the normalized proposition AST is textually identical:

```text
ClaimId(P, Basis_3) != ClaimId(P, Basis_4)
```

A completion warrant for revision 3 returns `BasisMismatch` when offered to revision 4. The logical corpus name can remain `C`; the immutable revision coordinate prevents a mutable label from laundering old absence evidence into the new corpus.

A different case is a world-basis proposition such as “the city population exceeds one million,” for which corpus 3 and corpus 4 are merely evidence sources. Then the ClaimId can remain the same while the two externally attested or derived WarrantTargets bind different source revisions. The profile must choose whether the corpus is constitutive of what is asserted or merely evidentiary; it cannot drift between those roles after projection.

## Scenario 3 — Bounded absence after a complete search versus an incomplete search

Define one located claim:

```text
P_absent = no item satisfying Q exists
Basis = corpus(C, revision=3, slice=S, semantic-boundary=B)
C_absent = (P_absent, scope=S, subject-time=T, basis=Basis, frame=F)
```

The ClaimId binds the closed semantic domain `C/3/S/B`. It does not bind which search happened.

Execution `E_complete` uses procedure/code `Search-A`, visits all members required by `B`, emits zero matches, and produces a completion receipt. Execution `E_partial` uses `Search-B`, stops after 60%, and also emits zero matches. Both can be evidence occurrences about the same ClaimId, but their targets and warrants differ:

```text
WT_complete = corpus-completion(ClaimId(C_absent), Search-A, B, E_complete)
WT_partial  = executed(ClaimId(C_absent), Search-B, partial-coverage, E_partial)
```

`WT_complete` can be admissible for the bounded absence claim when its coverage and authority validate. `WT_partial` cannot be admitted as corpus-completion because `CorpusCompletionInsufficient` is returned. It may be admissible as a report that no match was found in the examined subset, but that is a narrower proposition/claim or weaker evidence kind.

This ruling avoids identity inflation: retrying the same search or using an independent complete algorithm does not create a new absence claim. It also avoids under-identification: changing `B`, revision, or slice creates a new ClaimId.

## Scenario 4 — The same numerical proposition computed by two procedures

Suppose two independent procedures compute the exact proposition:

```text
P = quantity(account-A balance at T) = exact rational 12345/100 USD
```

The unit/currency semantics are included in Proposition or InterpretationFrame; account scope and subject-time are fixed. Procedure `LedgerFold/7` and procedure `IndependentAudit/2` produce the same normalized proposition.

There is one ClaimId and two distinct executed or derived WarrantTargets. Procedure/module/code identity distinguishes the warrants, not the claim. A policy can require agreement, prefer the independent procedure, or reject one due to represented loss. None of those decisions alters ClaimId.

If instead the proposition is “`LedgerFold/7` returns 12345/100 on input I,” the procedure and input are proposition subjects. A claim about `IndependentAudit/2` is then a different proposition and ClaimId. The distinction follows what is asserted, not a blanket rule that procedure identity is always in or always out.

## Scenario 5 — The same proposition evaluated under two admissibility policies

Let claim `C` and warrant `W` be fixed. Policy `P_strict` requires a fresh direct observation by an accredited issuer. Policy `P_open` accepts a recent external attestation with represented identity-neutral provenance loss.

```text
ClaimId_P_strict(C) = ClaimId_P_open(C) = ClaimId(C)
```

because admissibility policy is not a ClaimId field. Results can differ:

```text
warrant-admissible(W, C, P_strict, state, tq) = false
warrant-admissible(W, C, P_open,   state, tq) = true
```

Standing can therefore be unsupported under one policy and supported under another for the same claim. Decision receipts bind exact policy identities and state/query time.

`LCIIdentityPolicy/0` is not either evidentiary policy. It says how to construct ClaimId; it does not decide whether `W` counts.

## Scenario 6 — The same sentence under two incompatible ontologies

Surface text: “Jaguar is endangered.”

Under frame `F_animal`, `Jaguar` resolves to a biological taxon. Under frame `F_vehicle`, it resolves to an automobile marque or product family. A good normalizer will produce different subject references and therefore different propositions. Even if a deliberately opaque proposition AST leaves the same token structure, the differing frame remains inside ClaimId.

```text
ClaimId(P_surface, F_animal) != ClaimId(P_surface, F_vehicle)
```

The interpretation receipts record source text, language, resolver, and frame. Printer-text equality cannot override this result.

A proposition-equivalence or disambiguation system may later determine that one interpretation was unintended. That creates a correction or interpretation relation; it does not cause the original envelopes to have always been equal.

## Scenario 7 — A translated claim preserving meaning imperfectly

Source claim `C_s` uses frame `F_s` and a proposition whose modality is “must.” Translation into a target language emits a phrase closer to “should,” and the target legal frame distinguishes obligation from recommendation.

The target normalizer produces `P_t != P_s` and/or `F_t != F_s`, so:

```text
ClaimId(C_t) != ClaimId(C_s)
```

A translated WarrantTarget binds source ClaimId, source/target frames, translation procedure, receipt, and represented semantic loss. The lineage edge uses `R("translation")`.

The system MUST NOT label the target `same-claim` merely because a translator or model reports “equivalent.” An admissibility policy can accept the target as an approximate translation, but exact identity remains distinct.

If a different translation normalizes exactly to the same proposition and frame, ClaimId can be preserved. The distinct translation occurrence and receipt remain provenance/lineage, demonstrating that equal identity does not erase history.

## Scenario 8 — An inherited claim whose proposition survives but corpus or policy is stale

Agent B inherits from Agent A an occurrence asserting corpus-relative claim `C_3` about corpus revision 3. Exact proposition and location survive the handoff, so B's new occurrence can have `ClaimId(C_3)`. The inheritance edge and predecessor warrant testimony do not transfer live authority.

Two forms of staleness then diverge:

**Corpus staleness.** If users now ask about revision 4, that is `C_4` with a different basis and ClaimId. Revision-3 warrants do not match. If they still ask the historical question about revision 3, ClaimId remains `C_3`, though policy may judge its evidence no longer operationally useful.

**Policy staleness.** If the corpus claim remains `C_3` but the admissibility policy changes, ClaimId is unchanged. Old warrants can become inadmissible or newly admissible under the new policy, and standing changes accordingly.

Combining “corpus or policy is stale” into one `as-of` flag would lose this distinction. One condition changes the semantic claim when the requested corpus changes; the other changes only whether evidence counts.

## Scenario 9 — A revived claim with the same inert data but no surviving authority

A claim occurrence is frozen as inert CD/0 data, transported, decoded, and revived. Every ClaimId field is recovered exactly.

```text
ClaimId(revived) = ClaimId(original)
```

The revived occurrence is nevertheless new. Its inherited attestation records are predecessor testimony, not live warrants. Initial current standing can be unsupported even if the frozen artifact reports that the predecessor once had authenticated standing.

An authorized successor can replay the relevant procedure or obtain a new observation/attestation. The new event creates a new WarrantTarget/Warrant and can raise current standing under current policy. It does not retroactively make the serialized predecessor warrant live.

This is the clean separation between semantic identity and authority continuity: the former can survive exact inert copying; the latter cannot hitchhike inside a record wearing a convincing fake moustache.

## Scenario 10 — Two claims differing only in claimant or issuer

Alice and Bob separately assert the same normalized proposition at the same scope, subject-time, basis, and frame.

```text
ClaimId(Alice's occurrence) = ClaimId(Bob's occurrence)
```

The claim occurrences differ in claimant provenance. Warrants issued by Alice and Bob have distinct warrant identities because issuer/producer identity is included there. A policy may trust Alice, distrust Bob, require both, or detect a conflict. Standing can vary by policy without creating two semantic claims.

If the proposition is instead “Alice asserts P,” Alice is a subject inside proposition content. “Bob asserts P” is then a different proposition. LCI/0 does not erase people from claims; it refuses to confuse the speaker of an assertion with the subject of an assertion.

## Scenario 11 — A warrant produced by correct code but for the wrong temporal boundary

Procedure `CheckExists` has a valid immutable code identity and executes correctly at time `T1`. The candidate claim is located at subject-time `T2`.

Two malformed attempts are possible:

1. The target correctly embeds `ClaimId(T1)` and is offered to `ClaimId(T2)`. Matching returns `SubjectTimeMismatch`.
2. The target embeds `ClaimId(T2)` but its kind-specific observation/execution boundaries and trace show it examined state at `T1`. Target validation returns `TemporalCoverageInsufficient` or `TargetBoundaryMismatch`.

Correct code is not a time machine. Procedure identity and successful execution are necessary evidence properties, but they do not repair a wrong subject-time.

A persistence derivation can produce a new warrant for `T2` if domain assumptions and intervening evidence justify it.

## Scenario 12 — A warrant for a broad scope offered to a narrow claim

Let target scope be all devices in organization `O`; candidate claim scope is devices in department `D`, where the scope calculus proves `O` is wider than `D`. All non-scope ClaimId fields are equal.

For a downward-monotone proposition such as “every device in scope has encryption enabled,” a complete broad observation target can be eligible for narrowing:

```text
match_target(WT_O, C_D) = R("supports-by-scope-narrowing")
```

provided the observed target schema declares downward monotonicity and coverage includes all of `D`. Policy then decides admissibility.

The rule is not automatic for every proposition. A broad claim “average latency across O is 10 ms” does not establish the average for `D`. Its target schema or proposition relation must declare narrowing forbidden. LCI/0 therefore requires both a scope relation and target-kind/proposition monotonicity, not merely set inclusion.

One broad warrant can support several narrower claims only under these repeated checks.

## Scenario 13 — A warrant for a narrow scope offered to a broad claim

Let the warrant target devices in department `D`, while the candidate claim covers all devices in organization `O`. The calculus reports the target scope is narrower.

```text
match_target(WT_D, C_O) -> ScopeWideningForbidden
```

This holds even if `D` is large, representative, or the result happens to be true across `O`. Sampling-based inference would require a different proposition, uncertainty model, and derived warrant. Aggregation across exhaustive subscopes would require an explicit derivation whose premises cover the broad domain.

A policy cannot simply waive this target mismatch and call the narrow warrant direct broad evidence. It may authorize a derivation procedure, but that procedure mints a new warrant targeted at `C_O`.

## Scenario 14 — Two observational procedures return the same value with different completion guarantees

Procedure `ScanAll` and procedure `FirstPage` both return `0 matches`. The located claim is bounded absence over exact corpus revision, slice, and boundary.

The normalized proposition and ClaimId are the same. The warrant events differ:

```text
W_scan_all:
  kind = corpus-completion
  coverage = exact boundary
  completion receipt = present

W_first_page:
  kind = executed or observed
  coverage = first page only
  completion receipt = absent
```

`W_scan_all` can count for absence. `W_first_page` cannot, even though its output value is textually identical. Output equality is not completion equality.

For a different claim—“the first page contains zero matches”—`W_first_page` may be exact evidence, but that claim has a narrower corpus slice/boundary and therefore a different ClaimId.

## Scenario 15 — An external artifact superseded without changing its human-readable name

URL or title `Policy Manual` initially resolves to artifact revision `A1`, then later to `A2` with changed content. The display name is unchanged.

If the proposition is “the Policy Manual says X,” a stable artifact/edition reference is a proposition subject or corpus/artifact basis. Claims about `A1` and `A2` have different ClaimIds.

If the proposition is a world claim and the manual is evidence, ClaimId can remain fixed while externally-attested WarrantTargets bind `A1` or `A2`. Policy may mark the `A1` warrant superseded or stale.

A target containing only the title or URL returns `UnresolvedAlias` or `InvalidStableReference`. Resolving a mutable name at read time would let content change while the supposed evidence identity stood still, which is identity systems behaving like a loose floorboard.

## Scenario 16 — A model answer textually identical under two prompts or model versions

Model version `M1` under prompt `P1` and model version `M2` under prompt `P2` emit identical sentence `S`. After interpretation, both yield the same normalized proposition, location, and frame.

There is one ClaimId and two distinct model-executed WarrantTargets. Each binds model, exact invocation/prompt, execution semantics/time, and output interpretation receipt. Policy can compare independence, correlated training, reliability, or prompt leakage.

If the proposition is instead “model M under invocation P emitted S,” model and invocation are semantic subjects. The two claims then have different propositions and ClaimIds.

Textual identity of answers never allows one execution trace to impersonate another. Semantic identity of the asserted claim and identity of the generative event are intentionally separate.

## Scenario 17 — A claim reconstructed from partial testimony

Three witnesses reconstruct an old claim. They agree on proposition, scope, and subject-time but one cannot identify whether the corpus revision was 3 or 4.

Because basis is identity-bearing, the adapter cannot choose revision 3 based on majority confidence and emit its ClaimId. It returns `IdentityBearingLoss`, or constructs a new explicit proposition such as “the claim concerned revision 3 or 4” under a profile-defined ambiguity form. That new proposition has its own ClaimId.

If all ClaimId fields are recovered exactly but the original claimant display name or receipt path is missing, reconstruction can preserve ClaimId and attach identity-neutral represented loss. Admissibility policy may still refuse the reconstructed testimony.

The reconstruction receipt and lineage edge explain how the occurrence arose. They do not make it a verified descendant until a lineage policy authenticates the testimony.

## Scenario 18 — A claim with represented loss after migration

A v1 artifact used package-stripped symbol text. The original proposition may have referred to `PACKAGE-A::RATE` or `PACKAGE-B::RATE`; both now appear as `RATE`. Scope and `as-of` survived.

The LCI adapter cannot map the subject/procedure reference exactly. It returns `AmbiguousIdentifier` and `IdentityBearingLoss`, or constructs an explicit ambiguity proposition. It cannot reuse the v1 proposition fingerprint as ClaimId.

By contrast, if the migration loses only pretty-print whitespace and original list-versus-vector presentation where the Mneme proposition profile declares that distinction nonsemantic, it can produce the exact normalized proposition and location. The new LCI ClaimId is valid, with an identity-neutral loss receipt if historical fidelity matters.

In both cases the old fingerprint remains lineage/provenance. It is not a compact synonym for the new ClaimId.

## Scenario 19 — A correction that changes only provenance

An occurrence cites source artifact `A` but a later audit discovers the correct custody receipt was `R2`, not `R1`. The normalized proposition, scope, subject-time, basis, frame, and profile location are unchanged.

The corrected occurrence has the same ClaimId. A `provenance-correction` lineage edge links the occurrences. Warrant admissibility may change because the corrected provenance improves or damages source trust; that does not change what claim was asserted.

Existing warrants whose targets embed the ClaimId still target the same claim. A warrant whose kind-specific boundary explicitly bound the incorrect artifact/receipt may itself be invalid or require replacement. Claim identity and warrant identity are allowed to respond differently to the correction.

## Scenario 20 — A correction that changes proposition content

An occurrence asserted exact value `42`; a correction says the value is `43`, with all location coordinates unchanged.

```text
P_42 != P_43
ClaimId(P_42, L) != ClaimId(P_43, L)
```

The correction lineage edge connects old and new occurrences with relation `R("correction")` or `R("supersession")`. Warrants for `P_42` do not target `P_43`. They remain historical evidence about the old claim and may be refuted or revoked under the warrant system.

Current standing for `P_43` must be computed from warrants that match `P_43` or explicit derivations. A provenance-edit operation cannot be abused to replace proposition content while retaining the old ClaimId cache; recomputation returns `ClaimIdCacheMismatch`.

---

# 22. Adversarial cases and normative refusals

| # | Adversarial attempt | LCI/0 defense | Required result |
|---:|---|---|---|
| 1 | Reuse one warrant for the same proposition under a different `as-of`. | The adapter decomposes `as-of`. If it is subject-time, ClaimIds differ; if it is observation/issue time, the warrants differ. No ambiguous field reaches projection. | `UnclassifiedAsOf` during migration, or `SubjectTimeMismatch` during matching. |
| 2 | Reuse a revision-3 warrant for the same proposition over corpus revision 4. | Corpus-relative basis binds logical corpus, immutable revision, slice, and semantic boundary. | `BasisMismatch`. |
| 3 | Mutate scope after warrant issuance while retaining the old fingerprint. | Scope is immutable CD/0 inside both ClaimId and embedded WarrantTarget. Caches are recomputed; host aliases are not retained. | Mutation cannot alter the retained value; a reconstructed changed claim gets a different envelope or `ClaimIdCacheMismatch`. |
| 4 | Raise a broad claim using narrow evidence. | Scope relation is oriented and widening is forbidden. | `ScopeWideningForbidden`. |
| 5 | Reject a narrow claim despite valid broad evidence merely because ClaimIds are not equal. | Matcher supports the explicit `supports-by-scope-narrowing` relation when calculus, target schema, coverage, and policy all permit. | Relation returns `supports-by-scope-narrowing`; final admissibility remains policy-relative. |
| 6 | Treat identical printer text under different interpretation frames as one claim. | Frame is a required ClaimId coordinate; normalization occurs before projection. | Different envelopes; `InterpretationFrameMismatch` if one target is offered to the other. |
| 7 | Collapse package-distinct identifiers during migration. | Segmented identifiers require explicit package/module mapping. Ambiguous stripped names fail closed. | `AmbiguousIdentifier` and, where applicable, `IdentityBearingLoss`. |
| 8 | Redefine a procedure under the same display name and reuse its old warrant. | Executed/tested/completion targets bind stable procedure semantics and immutable code/module identity. | `ProcedureMismatch` or `ProcedureIdentityInsufficient`. |
| 9 | Change admissibility policy and silently emit a different ClaimId. | Admissibility policy is excluded from ClaimId; identity-policy is a distinct fixed record. Differential vectors hold ClaimId constant across policy changes. | Same ClaimId; differing admissibility decision. A changed envelope is `ProjectionNonDeterminism` or nonconformance. |
| 10 | Put current standing or revocation state inside ClaimId. | Envelope schema is closed and contains neither. | `UnknownField`, or profile nonconformance if hidden in another field. |
| 11 | Include every provenance fact and create a new ClaimId on each copy or source correction. | Provenance and lineage are outside the envelope; metadata-neutrality law applies. | Same ClaimId for identity-neutral provenance changes. |
| 12 | Omit lineage/loss even though migration collapsed a meaning-bearing distinction. | Migration must enumerate represented loss; identity-bearing loss cannot preserve a guessed ClaimId. | `RepresentedLossRequired`, `IdentityBearingLoss`, or a new explicit loss-qualified claim. |
| 13 | Treat translated claims as identical because the output sounds similar. | Translation relation is explicit; identity requires exact normalized proposition, frame, and location equality. | Different ClaimIds or exact equality proved by normalization; never similarity-based identity. |
| 14 | Use proof that a complete corpus search found nothing as proof that nothing exists in the world. | Corpus-bounded claim uses corpus basis. World claim uses world basis. Direct target matching forbids basis substitution. | `BasisMismatch`; a separate derivation is required. |
| 15 | Confuse observation time with the time the proposition concerns. | Subject-time and observation time occupy separate records and schemas. Cross-field target validation checks both. | `SubjectTimeMismatch` or `TemporalCoverageInsufficient`. |
| 16 | Authenticate a current-time claim with stale evidence. | Current is resolved to explicit subject-time; direct matching is exact; freshness is policy/state-relative. | Target mismatch if subject-time differs, otherwise inadmissible/stale under policy. |
| 17 | Accept a model-generated record because it self-declares a plausible ClaimId. | Projector recomputes the envelope from validated proposition/location and rejects caches that differ. | `SelfDeclaredClaimId` or `ClaimIdCacheMismatch`. |
| 18 | Reconstruct a privileged warrant from an inert CD/0 record with the right fields. | CD/0 and LCI decoding are inert; live warrant minting is a separate authorized runtime act. | `LegacyWarrantInert` or `PrivilegedRestorationAttempt`. |
| 19 | Add a new semantically relevant field and let old implementations silently ignore it. | All identity and target schemas are closed. A new coordinate requires profile/identity-policy or target-schema version changes. | `UnknownField` or `UnsupportedClaimProfile`/`UnsupportedIdentityPolicy`. |
| 20 | Let Common Lisp and Python project different ClaimIds from the same full claim record. | Projection, nested normalization contracts, field closure, references, and vectors are versioned and deterministic. Canonical octets are compared. | Differential conformance failure; neither result is silently preferred. |

## 22.1 Additional refusal principles

An implementation MUST refuse rather than approximate when it cannot determine:

- whether a source field is proposition time or evidence time;
- which package/module/entity a legacy identifier denotes;
- which immutable corpus revision a mutable name resolved to;
- which interpretation frame produced the proposition;
- whether a broad-to-narrow scope relation holds;
- whether an evidence procedure completed its declared boundary;
- whether a record is inert testimony or a live privileged object;
- whether an unknown field is identity-bearing;
- whether represented loss affects proposition/location identity.

A refusal can be inconvenient. Silent semantic invention is worse: it turns uncertainty into counterfeit certainty and then gives it a deterministic byte string, which is how very tidy disasters begin.

---

# 23. Migration from current v1

## 23.1 Status of v1 material

The hardened v1 kernel and its closure receipt are non-normative migration evidence. They demonstrate useful local repairs—defensive copies, safer decoding, private minting, cumulative predecessor testimony, and explicit replay—but they do not define LCI/0.

In particular, v1's stored fingerprint is derived mainly from the proposition's printed representation. `as-of`, scope, procedure/code binding, corpus, policy, interpretation frame, and complete location are not one frozen identity projection. LCI/0 therefore treats migration as explicit interpretation and reconstruction, not as renaming the old fingerprint.

## 23.2 Migration classifications

The classifications used here are:

```text
exact
exact after explicit tagging
new identity required
lossy with represented loss
rejected
deferred to scope or temporal calculus
privileged runtime relation outside ClaimId
```

A single v1 concept can receive more than one classification depending on whether its source semantics are recoverable. The table states the default and the allowed refinement.

| Current v1 concept | LCI/0 destination | Migration classification | Normative ruling |
|---|---|---|---|
| Proposition `(:equals (:call PROC-ID INPUT) EXPECTED)` | Mneme normalized proposition | **Exact after explicit tagging** when every leaf and role maps unambiguously; otherwise **lossy with represented loss** or **rejected** | Map tags and field roles to namespaced identifiers/records. Map `PROC-ID` as a semantic proposition reference only because this v1 grammar asserts a call result. Package-distinct symbols, floats, complex values, characters, `nil`, and other ambiguous leaves require explicit adapters. Do not use printer text as identity. |
| Stored proposition fingerprint | Predecessor metadata and lineage receipt | **New identity required** | It is not ClaimId and not a complete WarrantTarget. Preserve algorithm/spelling/runtime context as historical data where known. Compute ClaimId from the new envelope. |
| Repaired structural scope data | `Scope/0.expression` plus exact calculus reference | **Exact after explicit tagging** for unambiguous inert values; **deferred to scope calculus** for narrowing/subsumption semantics; otherwise **lossy** or **rejected** | Convert proper structural forms into profile values without host pointer identity. Select a versioned calculus. A source `:default` token needs an exact profile meaning; it cannot be treated as ambient scope. |
| `as-of` | `SubjectTime/0`, assertion provenance, observation/execution time, validity, or query-time metadata | **Deferred to temporal calculus**; often **exact after explicit tagging** once role/semantics are known; otherwise **lossy** or **rejected** | Classify the role explicitly. Bare integers/strings need scale, precision, and endpoint semantics. An unclassified value returns `UnclassifiedAsOf`. |
| Procedure ID and version | Proposition reference for the v1 call grammar; WarrantTarget procedure/code reference for execution evidence | **Exact after explicit tagging** only with explicit namespace/module and immutable semantics/code mapping; otherwise **lossy** or **rejected** | A symbol plus mutable registry version is not enough. Preserve display labels as provenance. |
| Attestation target fingerprint | Inert predecessor-warrant testimony; possible migration input for proposition lookup | **New identity required** | It targets only the legacy fingerprint domain. It cannot become ClaimId or an LCI target. A mapping receipt may associate it with a reconstructed proposition, but a complete target is recomputed. |
| Attestation event kind | LCI target-kind / warrant-kind identifier | **Exact after explicit tagging** when semantics are known | Map `:execution` and other kinds to namespaced identifiers and an exact target schema. Unknown kinds are rejected or preserved as uninterpreted legacy testimony, never guessed. |
| Attestation procedure ID/version | Kind-specific WarrantTarget boundaries | **Exact after explicit tagging** only with stable mapping; otherwise **lossy** or **rejected** | Bind module/code/semantics identity. A display symbol cannot authorize replay. |
| Attestation scope | Embedded legacy testimony and, when exact, target scope | **Exact after explicit tagging** plus **deferred to scope calculus** | Structural equality can be preserved; semantic narrowing/widening requires the selected calculus. It does not repair the proposition-only target fingerprint. |
| Attestation verdict and validity fields | Inert warrant testimony | **Exact after explicit tagging** | Preserve reported `supports`/`refutes` and historical validity. Decoding does not establish current validity or standing. |
| Attestation issue time | Warrant testimony issue-time value | **Exact after explicit tagging** only with temporal semantics; otherwise **lossy** | Tick counters need their clock/process domain. They are not wall-clock instants unless the source proves that interpretation. |
| Authenticated-warrant set on a live v1 claim | Predecessor testimony sequence | **Privileged runtime relation outside ClaimId** | Freeze/migration serializes inert projections only. No live authority crosses. |
| Predecessor-warrant testimony | Lineage/provenance and inherited target material | **Exact after explicit tagging** for reported fields | Preserve cumulative testimony and explicit loss. Reported predecessor evidence is not verified lineage or a live warrant. |
| v1 revival | New occurrence plus `freeze-revival` lineage edge | **Privileged runtime relation outside ClaimId** | Exact fields can yield the same new LCI ClaimId; revival does not restore live warrants. Authorized replay/re-attestation is a new event. |
| Raw artifact provenance (`:decoded-untrusted`, digest, source text) | Provenance and artifact reference | **Exact after explicit tagging** where source bytes/identity are known | Preserve source digest scheme, artifact identity, adapter, and untrusted status. It does not enter ClaimId unless the artifact is proposition content/basis. |
| Claimant/principal | Claim occurrence provenance; Warrant identity/admissibility | **Exact after explicit tagging** when stable identity is available | It does not enter ClaimId merely because the principal asserted or attested. |
| Current v1 authenticated boolean/status | Historical standing testimony | **Exact after explicit tagging** as a reported status only | It is not current LCI standing. Recompute from current live warrants, state, policy, and query time. |
| v1 receipt state/path | Custody/handoff testimony | **Exact after explicit tagging** for known state and path semantics; host path object itself **rejected** | Paths use an explicit URI/path profile and never trigger I/O on decode. Receipt transitions do not define ClaimId. |
| v1 raw printed artifact format | Migration source artifact | **Rejected** as canonical identity; **exact after explicit tagging** for safely parsed mappable content | Use a frozen safe legacy parser, require one complete inert form, then construct CD/0. The source text and digest remain provenance. |

## 23.3 Required migration pipeline

A conforming v1-to-LCI/0 adapter performs, in order:

```text
1. Snapshot the exact source bytes and bind a source artifact reference.
2. Parse with a frozen, non-evaluating, resource-bounded legacy parser.
3. Validate the exact legacy schema/version; reject trailing or active forms.
4. Map symbols/identifiers with explicit namespace and package/module evidence.
5. Map the v1 proposition into the normalized Mneme proposition profile.
6. Classify `as-of` into explicit temporal roles.
7. Map scope into Scope/0 and select an exact scope calculus.
8. Construct Basis/0 and InterpretationFrame/0 from explicit source evidence.
9. Record every ambiguity or lost distinction as RepresentedLoss/0.
10. Refuse same-claim reconstruction when any identity field is unresolved.
11. Project a new ClaimIdEnvelope/0.
12. Convert old fingerprints, attestations, statuses, receipts, and predecessor
    material into inert provenance/lineage/warrant testimony.
13. Produce a migration receipt linking source artifact and new occurrence.
14. Start with no migrated live warrants.
```

The adapter MUST NOT invoke a v1 procedure, consult the current v1 registry, resolve a mutable corpus alias, or use current package interning to fill missing identity fields during projection.

## 23.4 Migration result record

A migration harness may use:

```text
MigrationResult/0 = Record{
  K("kind")                 => T("migration-result"),
  K("schema-version")       => 0,
  K("source")               => <StableRef/0>,
  K("adapter")              => <StableRef/0>,
  K("classification")       => <Identifier>,
  K("claim")                => <validated located-claim data or explicit refusal payload>,
  K("claim-id")             => <ClaimIdEnvelope/0 when successful>,
  K("lineage")              => <Seq of inert lineage edges>,
  K("represented-loss")     => <Seq of RepresentedLoss/0>,
  K("legacy-testimony")     => <Seq of inert records>,
  K("live-warrants-created") => false
}
```

A failure form uses `LCIFailure/0` rather than placing Unit in `claim-id`.

## 23.5 Legacy proposition-only collisions

The shared migration vectors must include at least two legacy records with the same proposition fingerprint but different:

- subject-time;
- scope;
- corpus revision;
- interpretation frame;
- or another LCI location coordinate.

The adapter must demonstrate that they receive different LCI ClaimIds or that unresolved source semantics produce typed migration refusal. It must never preserve the legacy collision as semantic sameness.

## 23.6 Can old warrants migrate as live warrants?

No serialized or reconstructed v1 warrant becomes a live LCI warrant by migration.

The default and normative posture is inert testimony. A successor system may perform a separately authorized replay, fresh observation, fresh execution, or re-attestation that checks the complete LCI WarrantTarget and current authority. That act creates a new LCI warrant with a new evidence-event identity. The old warrant remains predecessor testimony; it is not transmuted into the new live object.

A future trusted gateway could attest facts about a verified legacy warrant, but that gateway's attestation is itself a new external or derived LCI warrant. It does not violate the rule because it does not restore the old privileged object.

## 23.7 Revival posture

A v1 revived claim can map to the same LCI ClaimId as its predecessor only when the complete LCI proposition and location are exactly reconstructed. Its occurrence and lineage are new. Its current live-warrant set starts empty.

`replay-and-attest` is conceptually aligned with LCI/0 only when replay binds the complete ClaimId, exact target kind, procedure/code identity, scope, subject-time, basis, frame, and current authority. The existing v1 operation does not by itself prove those complete bindings and therefore remains migration evidence, not the normative LCI operation.

---

# 24. Positive vector schema

## 24.1 Purpose

Positive vectors contain valid CD/0-backed LCI values and expected successful projections or relation classifications. “Positive” means the input is valid and the operation has a determinate conformance result; the expected result can be equality, inequality, exact match, narrowing, or a typed nonmatching relation.

## 24.2 Abstract vector record

```text
LCIPositiveVector/0 = Record{
  K("kind")           => T("positive-vector"),
  K("schema-version") => 0,
  K("vector-id")      => <String>,
  K("operation")      => <Identifier>,
  K("inputs")         => <closed operation-specific Record>,
  K("expected")       => <closed operation-specific Record>
}
```

The repository transport may be JSON Lines for harness convenience, but each identity-bearing input and expected envelope is encoded either as:

- complete lowercase hexadecimal canonical CD/0 document bytes; or
- a typed abstract fixture from which both implementations independently construct CD/0, accompanied by the expected complete canonical bytes.

JSON object order, number coercion, and strings are never used as LCI identity. The vector schema defines exact conversions.

## 24.3 Projection vector expected record

A projection vector expected record includes:

```text
expected ClaimIdEnvelope/0
expected complete canonical-octets as Bytes
expected domain-framed preimage as Bytes, when the vector tests framing
```

No hash output is required.

## 24.4 Relation vector expected record

A relation vector expected record includes:

```text
expected same-claim boolean
expected proposition equality/equivalence classification, when requested
expected scope relation, when requested
expected target relation, when requested
expected admissibility result under a finite fixture policy/state, when requested
```

The policy/state fixture is explicit and versioned. A vector does not consult wall clock or external state.

## 24.5 Required valid vector set

The shared suite MUST include at least the following fixtures.

| Vector ID | Fixture | Expected result |
|---|---|---|
| `LCI0-P001` | Two full claim occurrences differ only in claimant, assertion time, and presentation | Identical ClaimId envelopes and canonical octets |
| `LCI0-P002` | Exact duplicate located claim constructed with different record insertion orders | Identical envelope and bytes |
| `LCI0-P003` | Different normalized proposition, same location | Different ClaimIds |
| `LCI0-P004` | Same proposition, different exact scope | Different ClaimIds; scope relation classified |
| `LCI0-P005` | Same proposition, yesterday versus today subject-time | Different ClaimIds |
| `LCI0-P006` | Same proposition/scope/time over corpus revision 3 versus 4 | Different ClaimIds |
| `LCI0-P007` | Same corpus revision, different dataset slice | Different ClaimIds |
| `LCI0-P008` | Same bounded-absence proposition, different semantic completion boundary | Different ClaimIds |
| `LCI0-P009` | Same proposition/location except interpretation frame ontology version | Different ClaimIds |
| `LCI0-P010` | Different surface languages normalize exactly to same proposition/frame/location | Identical ClaimIds; distinct interpretation receipts |
| `LCI0-P011` | Identity-neutral provenance difference | Identical ClaimIds |
| `LCI0-P012` | Lineage-only/predecessor difference | Identical ClaimIds |
| `LCI0-P013` | Same ClaimId with two procedure/code targets | Same claim; different WarrantTargets |
| `LCI0-P014` | Exact WarrantTarget and claim | `R("exact-target")` |
| `LCI0-P015` | Broad downward-monotone target and narrow claim | `R("supports-by-scope-narrowing")` |
| `LCI0-P016` | Narrow target and broad claim | Valid values; relation refusal `ScopeWideningForbidden` under the relation vector schema |
| `LCI0-P017` | Broad and narrow overlapping but non-subsuming scopes | `ScopeOverlapInsufficient` |
| `LCI0-P018` | Target and claim differ only in subject-time | `SubjectTimeMismatch` |
| `LCI0-P019` | Target and claim differ only in corpus revision | `BasisMismatch` |
| `LCI0-P020` | Target and claim differ only in interpretation frame | `InterpretationFrameMismatch` |
| `LCI0-P021` | Complete versus incomplete corpus search with equal output value | Same ClaimId; distinct targets; only completion target satisfies completion fixture |
| `LCI0-P022` | Same claim/warrant under strict and permissive policy fixtures | Same ClaimId; policy-relative admissibility differs |
| `LCI0-P023` | Fresh and stale observation fixtures for same claim | Same ClaimId; admissibility differs by query time/policy |
| `LCI0-P024` | Exact revival with empty live-warrant state | Same ClaimId; new occurrence; standing fixture unsupported until replay |
| `LCI0-P025` | Exact translation normalization | Same ClaimId; explicit translation lineage |
| `LCI0-P026` | Imperfect translation with represented semantic loss | Different ClaimIds; `claim-translates-to` fixture true |
| `LCI0-P027` | v1 records with same proposition fingerprint but different `as-of` classified as subject-time | Different LCI ClaimIds |
| `LCI0-P028` | v1 records with same proposition fingerprint but different scope | Different LCI ClaimIds |
| `LCI0-P029` | v1 records with same proposition fingerprint but different corpus revision reconstructed from provenance | Different LCI ClaimIds |
| `LCI0-P030` | Provenance correction followed by proposition correction | First preserves ClaimId; second changes ClaimId |

## 24.6 Canonical-byte derivation in vectors

Vector authors MUST generate expected canonical octets from the frozen CD/0 grammar and independently verify them with both implementations before accepting the vector. Diagnostic notation may accompany a vector for review, but the complete canonical byte string is the comparison authority.

Large examples need not be printed in this specification. Repository vector files contain their exact bytes.

## 24.7 Policy fixture discipline

Vectors that exercise admissibility use deliberately finite test policies, for example:

```text
Policy-A:
  accepts exact observed warrants younger than 24 hours
  accepts scope narrowing for declared monotone targets
  rejects inherited testimony

Policy-B:
  accepts exact external attestations with named issuer class
  does not require freshness for historical subject-time
```

These policies are conformance fixtures, not the Mneme production admissibility constitution.

---

# 25. Negative vector schema

## 25.1 Purpose

Negative vectors exercise malformed, ambiguous, unsupported, privilege-crossing, or fail-closed inputs. Each vector has one primary defect and one exact expected failure triple plus structural path.

## 25.2 Abstract vector record

```text
LCINegativeVector/0 = Record{
  K("kind")             => T("negative-vector"),
  K("schema-version")   => 0,
  K("vector-id")        => <String>,
  K("operation")        => <Identifier>,
  K("input")            => <operation-specific inert value or Bytes>,
  K("budget")           => <explicit resource-budget fixture>,
  K("expected-failure") => <LCIFailure/0 without local prose>
}
```

When the defect is malformed CD/0 bytes, the expected failure remains the frozen CD/0 failure, not an LCI wrapper. When bytes decode but violate LCI semantics, the expected failure is `LCIFailure/0`.

## 25.3 Required negative vector set

| Vector ID | Primary defect | Expected code/stage |
|---|---|---|
| `LCI0-N001` | Missing `identity-policy` | `MissingRequiredField` / `claim-shape` |
| `LCI0-N002` | Unknown top-level ClaimId field | `UnknownField` / `claim-shape` |
| `LCI0-N003` | Unit used for subject-time | `UnexpectedUnit` / `subject-time` |
| `LCI0-N004` | Unsupported LCI version | `UnsupportedLCIVersion` / `lci-version` |
| `LCI0-N005` | Unsupported identity-policy version | `UnsupportedIdentityPolicy` / `identity-policy` |
| `LCI0-N006` | Unsupported claim-profile version | `UnsupportedClaimProfile` / `claim-profile` |
| `LCI0-N007` | Raw surface sentence supplied where normalized proposition required | `UnnormalizedProposition` / `proposition` |
| `LCI0-N008` | Mutable `latest` corpus alias used as revision | `UnresolvedAlias` / `stable-reference` |
| `LCI0-N009` | Nonempty Mneme/0 profile-location | `UnknownField` or profile-specific invalid field / `profile-location` |
| `LCI0-N010` | Scope expression invalid under calculus | `InvalidScope` / `scope` |
| `LCI0-N011` | No bridge between scope calculi | `ScopeIncompatible` / `target-relation` |
| `LCI0-N012` | Scope relation undecidable fixture | `ScopeRelationUnknown` / `target-relation` |
| `LCI0-N013` | Unresolved relative `now` | `UnresolvedRelativeTime` / `subject-time` |
| `LCI0-N014` | Corpus proposition paired with world basis | `PropositionLocationInconsistent` / `basis` |
| `LCI0-N015` | Cached ClaimId differs from recomputed envelope | `ClaimIdCacheMismatch` / `claim-id-cache` |
| `LCI0-N016` | Self-declared digest offered instead of envelope | `SelfDeclaredClaimId` / `projection` |
| `LCI0-N017` | WarrantTarget omits complete ClaimId and carries legacy fingerprint | `LegacyFingerprintNotClaimId` / `target-shape` |
| `LCI0-N018` | Executed target lacks immutable procedure/code binding | `ProcedureIdentityInsufficient` / `target-boundaries` |
| `LCI0-N019` | Corpus-completion target lacks completion receipt/coverage | `CorpusCompletionInsufficient` / `target-boundaries` |
| `LCI0-N020` | Direct target has wrong subject-time | `SubjectTimeMismatch` / `target-relation` |
| `LCI0-N021` | Direct target has wrong corpus revision | `BasisMismatch` / `target-relation` |
| `LCI0-N022` | Direct target has wrong frame | `InterpretationFrameMismatch` / `target-relation` |
| `LCI0-N023` | Narrow target offered to broad claim | `ScopeWideningForbidden` / `target-relation` |
| `LCI0-N024` | Unknown target boundary added under existing schema | `TargetBoundaryUnknown` / `target-boundaries` |
| `LCI0-N025` | Package-stripped legacy identifier ambiguous | `AmbiguousIdentifier` / `migration-mapping` |
| `LCI0-N026` | Legacy `as-of` cannot be classified | `UnclassifiedAsOf` / `migration-mapping` |
| `LCI0-N027` | Identity-bearing corpus/time/frame field lost | `IdentityBearingLoss` / `represented-loss` |
| `LCI0-N028` | Known loss omitted from migration result | `RepresentedLossRequired` / `represented-loss` |
| `LCI0-N029` | Serialized v1 attestation offered as live warrant | `LegacyWarrantInert` / `privilege-boundary` |
| `LCI0-N030` | Inert record attempts to restore capability/current standing | `PrivilegedRestorationAttempt` / `privilege-boundary` |
| `LCI0-N031` | Two projectors differ under same declared versions | `ProjectionNonDeterminism` / `internal` |
| `LCI0-N032` | Profile validator exceeds explicit resource budget | profile resource refusal / relevant stage |

## 25.4 Mutation vectors

Negative/robustness fixtures also construct ClaimId and WarrantTarget from mutable host inputs, mutate the original lists, arrays, strings, byte buffers, or dictionaries, and verify that retained envelope values and canonical octets do not change. A view that changes after source mutation is a conformance failure, not a new legitimate vector result.

## 25.5 Unknown-field mutation vectors

For each closed schema, the harness adds one semantically plausible unknown field—such as a new corpus qualifier, policy field, procedure field, or temporal boundary—and expects rejection. This tests that implementations do not maintain a private list of “fields we happen to ignore.”

---

# 26. Cross-implementation properties

## 26.1 Independent implementations

Common Lisp and Python implementations are independently seeded and share only normative documents, vector formats, and accepted test artifacts. They do not share projection source code or generated schema code unless a later process explicitly changes the clean-room posture. The isolation claim is procedural rather than OS-enforced; conformance rests on reviewable process, independent construction, differential results, and frozen evidence rather than an assertion of machine-level separation.

## 26.2 Compared outputs

For every shared fixture, implementations compare:

- validated ClaimId envelope as abstract CD/0;
- complete ClaimId canonical octets;
- optional domain-framed preimage bytes;
- exact WarrantTarget envelope and canonical octets;
- scope relation classification;
- temporal relation classification where a fixture requests it;
- target matching classification;
- finite policy-fixture admissibility result;
- typed failure category/code/stage/path;
- v1 migration classification;
- migrated ClaimId envelope/canonical octets;
- represented-loss records;
- inert-versus-live warrant result.

## 26.3 Projection properties

Both implementations MUST satisfy:

```text
same valid abstract claim -> same envelope -> same bytes
same ClaimId bytes -> same validated envelope
different required identity field -> different envelope
identity-neutral metadata change -> same envelope
unknown identity field -> typed refusal
projection repeated after runtime-state changes -> same envelope
```

## 26.4 Target properties

Both implementations MUST agree on:

```text
exact target
supports-by-scope-narrowing
scope widening refusal
overlap refusal
scope incompatibility versus unknown
subject-time mismatch
basis mismatch
frame mismatch
kind-specific boundary mismatch
```

They must not collapse all nonmatches to false when the shared vector expects a typed distinction.

## 26.5 Migration properties

For each v1 fixture, both implementations MUST agree on:

- safe parse acceptance/refusal;
- explicit symbol/identifier mapping;
- `as-of` classification;
- scope and temporal adapter result;
- proposition normalization;
- new ClaimId or refusal;
- represented-loss content and ordering rules;
- preservation of legacy fingerprint as metadata only;
- zero live warrants created by migration.

## 26.6 Host perturbation matrix

The conformance suite runs under perturbations including:

- changed Common Lisp package, printer, readtable, print base/case, and hash-table insertion order;
- distinct Common Lisp processes and supported implementation versions;
- changed Python hash seed, dictionary insertion order, locale, and process;
- mutable-source inputs modified after construction;
- independently allocated but structurally equal scope, frame, time, and reference objects;
- unavailable network/filesystem access during projection;
- changed wall clock and runtime warrant state.

ClaimId and exact target results remain unchanged.

## 26.7 Randomized differential properties

Each implementation independently generates valid propositions and location records within supported profiles, projects them, and exchanges abstract fixtures/seeds. Differential checks cover:

- record insertion-order permutations;
- deeply nested profile data within declared budgets;
- boundary Unicode and segmented identifiers;
- exact integer/rational values;
- scope/time/basis/frame substitutions one field at a time;
- nonidentity metadata mutations;
- target-kind boundary permutations;
- v1 ambiguity and loss mutations.

A differential disagreement is minimized to one semantic distinction before a permanent vector is added.

## 26.8 Failure comparison

Single-fault vectors compare exact category, code, stage, and path. Host exception class and message are ignored. An implementation that accepts an input the other correctly rejects, or rejects under a broader/incorrect semantic interpretation, fails conformance pending specification review.

## 26.9 Resource behavior

LCI profile validators, scope/temporal relation engines, migration adapters, and target matchers use explicit budgets. A deterministic budget refusal is compared across implementations where the vector defines the same budget. Host allocation failure outside the fixture budget is reported separately and does not change semantic identity rules.

## 26.10 No accidental implementation oracle

Neither implementation is the normative oracle merely because it was written first. The normative documents and accepted shared vectors control. A disagreement can reveal an implementation defect or a specification ambiguity; the resolution is recorded through review and versioned evidence rather than silently copying one implementation's behavior.

---

# 27. Rejected alternatives

## 27.1 Proposition-only ClaimId

Rejected. It collapses different scope, subject-time, corpus revision, dataset slice, semantic boundary, and interpretation frame. It repeats the central v1 defect and allows stale or mismatched warrants to raise the wrong located claim.

## 27.2 Whole claim-occurrence record as ClaimId

Rejected. It includes claimant, assertion time, provenance, lineage, warrant history, presentation, and status, causing identity explosion. Copies, independent assertions, provenance corrections, and evidence updates would all become different semantic claims.

## 27.3 “Include every field that might ever affect admissibility”

Rejected. Admissibility can depend on issuer, policy, code, freshness, validity, authority, revocation, represented loss, and runtime state. Putting all of them in ClaimId makes one claim impossible to evaluate under two policies or support through independent evidence. The correct boundary is semantic location plus typed evidence target.

## 27.4 Claimant- or issuer-relative ClaimId

Rejected as the default. Two agents can assert or warrant the same claim. Principal identity belongs to occurrence provenance, warrant identity, and admissibility. A proposition explicitly about an agent still encodes that agent as a subject.

## 27.5 Admissibility policy in ClaimId

Rejected. Policy change should alter whether evidence counts, not which semantic claim exists. Identity policy remains in ClaimId because it defines the projection; the two policy roles are not interchangeable.

## 27.6 Procedure, module, model, or prompt in every ClaimId

Rejected. Independent procedures, implementations, instruments, and models can bear on the same claim. These identities belong in WarrantTarget and Warrant identity unless the proposition is explicitly about their behavior.

## 27.7 Provenance or lineage in ClaimId

Rejected. It makes exact copies, independent re-derivations, migration, revival, and source correction produce ancestry-sensitive identities. Explicit lineage relations retain history without redefining semantic sameness.

## 27.8 Standing, validity, or revocation in ClaimId

Rejected. These are current state or warrant terms. Including them would make identity change when evidence expires, is revoked, or is replaced, and would make ClaimId depend circularly on its warrants.

## 27.9 WarrantTarget exactly equal to ClaimId

Rejected. It cannot distinguish observation from report, bind procedure/code/invocation, enforce corpus completion, identify derivation premises, record execution/observation time, or preserve translation/replay boundaries. Evidence of materially different kinds would collapse.

## 27.10 WarrantTarget narrower than ClaimId

Rejected. A target that omits scope, subject-time, corpus revision, or frame recreates proposition-only targeting. Every target includes a complete ClaimId; additional boundaries can only make it more specific.

## 27.11 One overloaded `as-of`

Rejected. Proposition time, observation time, execution time, issue time, validity, assertion time, and standing-query time have different identity and policy roles. Overloading them guarantees adapter ambiguity and stale-evidence bugs.

## 27.12 Generic temporal containment as direct target matching

Rejected for /0. “Evidence interval contains claim instant” is not generally sound without persistence, sampling, and domain assumptions. Temporal inference requires an explicit derived warrant. Exact subject-time matching is the safe constitutional baseline.

## 27.13 Scope exact equality only, with no narrowing interface

Rejected. It would reject valid broad-to-narrow evidence even when a calculus proves subsumption and the target is monotone. LCI/0 therefore distinguishes exact target from admissible narrowing.

## 27.14 Automatic broad-to-narrow for every scope-bearing claim

Rejected. Aggregate, existential, statistical, and nonmonotone propositions do not necessarily narrow. The target schema must declare downward monotonicity and coverage; policy still decides admissibility.

## 27.15 Host pointer, package, symbol, or registry identity

Rejected. It is process-local, mutable, implementation-specific, and unavailable to the other language. Exact segmented identifiers and stable reference envelopes replace it.

## 27.16 Diagnostic text or current v1 fingerprint as ClaimId

Rejected. Printer behavior, package context, host numeric spelling, and omitted location make it noncanonical and incomplete. Legacy fingerprints remain labeled predecessor metadata.

## 27.17 Hash digest as the semantic definition of ClaimId

Rejected. A digest is a compact cryptographic reference to already fixed identity material. Semantic identity exists before algorithm choice and remains envelope equality. This preserves algorithm agility and keeps collision handling in the cryptographic layer.

## 27.18 Open identity records with unknown fields ignored

Rejected. An unknown field can be the missing distinction that prevents stale warrant reuse. Closed schemas, profile versions, and identity-policy versions force semantic additions into review.

## 27.19 Hidden defaults for omitted scope, time, basis, or frame

Rejected. Defaults chosen by current process, locale, policy, or implementation would make projection nondeterministic. Explicit neutral tagged values are required.

## 27.20 Normalize surface text during ClaimId projection

Rejected. Interpretation requires frame, parser semantics, ambiguity handling, and a receipt. Projection accepts already normalized propositions and remains pure. Combining the phases would hide semantic choices inside an identity function.

## 27.21 Treat every translation as identical

Rejected because imperfect translations can change modality, scope, referent, time, or legal force.

## 27.22 Treat every translation as a different claim

Rejected because deterministic exact normalization can yield the same proposition and frame across languages. Translation occurrence remains lineage/provenance even when ClaimId is shared.

## 27.23 Restore live warrants from serialized shape

Rejected. It launders authority and revocation state through inert data. Replay or re-attestation creates a new warrant under current authority.

## 27.24 Choose a cryptographic algorithm in LCI/0

Rejected as premature and unnecessary. The canonical envelope and exact domain label are sufficient cryptographic input. Algorithm selection belongs to a later identity-reference or signature specification.

## 27.25 Let one implementation define behavior by accident

Rejected. Independent Common Lisp and Python implementations compare against normative schemas and shared vectors. A disagreement triggers review; implementation order confers no constitutional privilege.

---

# 28. Deferred questions

LCI/0 deliberately defers the following while fixing the interfaces they must consume.

## 28.1 Complete Mneme proposition grammar

A separate profile must define normalized proposition AST forms, entity/reference schemas, logical operators, modality, quantity/uncertainty records, and normalization laws. It must preserve the LCI/0 distinction between proposition content and location.

## 28.2 Complete scope calculus

The expression language, satisfiability, proof objects, bridge rules, decidability limits, authorization interaction, and proposition-specific monotonicity catalogue remain open. LCI/0 fixes the record, relation vocabulary, orientation, fail-closed behavior, and target use.

## 28.3 Complete temporal model

Time scales, calendars, event identity, uncertainty, open intervals, recurring times, persistence inference, historical versus valid time, and temporal proof objects remain open. LCI/0 fixes the distinct temporal roles and exact direct subject-time matching.

## 28.4 Basis, slice, and semantic-boundary calculi

Profiles must define corpus logical identity, revision identity, slice expressions, snapshot manifests, cursor/log horizons, and closed-world boundaries. LCI/0 fixes when those values are identity-bearing and when completion is evidence.

## 28.5 Proposition equivalence and normalization proofs

LCI/0 uses exact normalized proposition values for identity. Rich equivalence, rewriting, alpha-equivalence, unit conversion, ontology alignment, and theorem proving remain separate relations.

## 28.6 Warrant calculus and complete WarrantId

The full warrant schema, identity envelope, verdict lattice, composition, contradiction, consumption, delegation, replay, test semantics, observation semantics, and proof verification remain open. LCI/0 fixes the complete-ClaimId target nucleus and required kind-specific boundary discipline.

## 28.7 Admissibility policy language

Freshness, issuer trust, code accreditation, evidence-kind preference, represented-loss tolerance, jurisdiction, independence, conflict, quorum, and scope-narrowing permission require a versioned policy system.

## 28.8 Standing semantics

The exact standing lattice—supported, refuted, both, suspended, unknown, stale, contested, consumed, or other states—plus conflict resolution and query APIs remains open. Standing must remain a state query outside ClaimId.

## 28.9 Authority, capability, revocation, and custody

Live warrant minting, capability delegation, retrospective revocation, custody receipts, signature verification, operator boundaries, and OS/process isolation are separate security specifications.

## 28.10 Module, procedure, model, and artifact identity schemes

LCI/0 requires stable references and states minimum information, but does not select source hashes, build manifests, dependency closure rules, ABI identity, model checkpoint schemes, prompt commitments, or artifact content-ID algorithms.

## 28.11 Cryptographic algorithms and compact references

Hash, signature, key, algorithm agility, collision policy, digest encoding, Merkle structures, and certificate formats remain open. They must consume the exact LCI domain-framed envelope.

## 28.12 Verified lineage

Lineage edge authentication, custody continuity, multi-party testimony, graph conflict, transitive trust, and succession authority remain open. LCI/0 fixes that lineage is explicit and separate from ClaimId.

## 28.13 Privacy and selective disclosure

How to commit to secret prompts, proprietary corpora, private scope expressions, or confidential evidence while retaining target verifiability remains open to later cryptographic/profile work.

## 28.14 Cross-version identity bridges

A later LCI/profile version must define whether old and new claims are migrated, translated, equivalent, refining, or unrelated. Existing envelope equality never changes.

## 28.15 Not deferred

The following are settled by this document and are not open implementation choices:

- the ClaimId envelope fields and their required status;
- ClaimId as the canonical envelope rather than a selected hash;
- scope, subject-time, basis, frame, and profile-location as identity coordinates;
- exclusion of policy, procedure history, claimant, provenance, lineage, standing, and revocation from ClaimId by default;
- typed WarrantTarget as complete ClaimId plus boundaries;
- exact subject-time for direct target matching;
- constrained broad-to-narrow scope matching and forbidden widening;
- closed schemas and fail-closed unknown fields;
- inert v1 warrant migration and new authorized replay/re-attestation;
- separation of semantic identity from truth, authority, admissibility, and standing.

---

# 29. Concise Codex implementation handoff

## 29.1 Goal

Implement LCI/0 as a thin, pure semantic layer over the frozen CD/0 APIs. Do not modify CD/0 and do not implement the complete warrant, standing, cryptographic, module-identity, or lineage-verification systems in this change.

## 29.2 Suggested work products

Create parallel Common Lisp and Python modules for:

```text
lci0 schema identifiers and closed-record validators
StableRef/0 validation interface
ClaimId projection
Scope/0 and SubjectTime/0 interfaces with fixture calculi
Basis/0 and InterpretationFrame/0 validation
WarrantTarget/0 schemas and pure target matcher
LCIFailure/0 construction
v1 migration adapter producing inert testimony and represented loss
shared positive/negative vectors and differential harness hooks
```

## 29.3 Implementation order

1. Define exact identifiers and immutable typed views for Sections 7, 9, and 18.
2. Implement closed validators with no defaults and no unknown-field tolerance.
3. Implement the pure ClaimId projector and canonical-byte comparison.
4. Implement scope/temporal interface dispatch by exact stable reference using only frozen fixture calculi initially.
5. Implement exact target matching and constrained scope narrowing; do not implement generic temporal projection.
6. Implement inert v1 migration with explicit identifier, `as-of`, scope, basis, frame, and loss adapters.
7. Add shared vectors, host-perturbation tests, mutation tests, and differential result comparison.
8. Add read-back evidence showing no CD/0 file or vector changed.

## 29.4 Hard stop lines

The implementation change MUST NOT:

- add or alter CD/0 tags, bytes, equality, decoder behavior, or format version;
- choose a hash/signature algorithm;
- treat a digest as semantic ClaimId;
- invoke procedures, models, search, filesystem, network, policy, standing, or wall clock during projection;
- accept a proposition-only fingerprint as ClaimId or WarrantTarget;
- restore a live warrant from v1 data;
- put claimant, provenance, lineage, policy, standing, or revocation into ClaimId;
- silently ignore unknown fields;
- use Common Lisp `eq`, Python `is`, package/module objects, or mutable registry identity for scope/reference comparison.

## 29.5 Acceptance gates

The patch is ready for review only when:

- both implementations project byte-identical ClaimId envelopes for all positive vectors;
- both return the same target relations and typed refusals;
- mutation and host-perturbation tests pass;
- v1 legacy-collision vectors no longer collide or explicitly refuse;
- every migrated warrant remains inert and `live-warrants-created` is false;
- the repository diff shows no change to frozen CD/0 normative or implementation artifacts;
- an independent review confirms all thirty sections of this specification are represented in tests or explicit deferrals.

---

# 30. Decision receipt

## 30.1 Receipt identity

```text
receipt-id: LCI0-CONSTITUTIONAL-DECISION-2026-07-13
subject: Lisp+ Located Claim Identity /0 and Mneme profile
artifact: LOCATED-CLAIM-IDENTITY-SPEC.md
status: normative design selected; implementation not performed
```

## 30.2 Input custody and verification

```text
reference packet ZIP SHA-256:
  bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81

packet inventory:
  15 files
  381,105 extracted bytes

internal checksum verification:
  PASS for every manifest-sealed member

SHA256SUMS.txt SHA-256:
  3caa90630ee4149d142e39f15b0aff7f5de23c54e0e07087e0f0ca3df16c71d3
```

Every attached artifact was read in full. Classifications and evidence precedence from `PACKET-MANIFEST.md` were preserved.

## 30.3 Frozen anchors consumed

```text
accepted merge commit:
  efe52efe3e0e5a24181ee324e18b23e266129104

frozen CD/0 implementation tree:
  13871b0b0ec81e667611163bc78976b3a91ff4b7

final evidence-publication commit:
  56f0ce55253ef8dd4caaf80b03e49835c4087406

final evidence-publication tree:
  e73d50772b22651df4f9620cd971baaf4de74739
```

The merge/freeze evidence was treated as event evidence, not as additional datum grammar. The repository-binding incident receipt was treated only as historical custody evidence.

## 30.4 Normative source hashes

```text
CANONICAL-DATUM-SPEC.md:
  d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc

CANONICAL-DATUM-SPEC-ERRATA-0.1.md:
  5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271

CD0-POST-IMPLEMENTATION-RULING.md:
  1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc
```

## 30.5 Decisions recorded

1. ClaimId is the exact closed CD/0 ClaimId envelope, not a chosen cryptographic hash.
2. The minimal envelope contains identity policy, claim profile, normalized proposition, scope, subject-time, basis, interpretation frame, and profile location.
3. All LCI/0 identity fields are required; neutral semantics are explicit; omission and Unit are not aliases.
4. Scope, proposition time, corpus-relative revision/slice/boundary, and interpretation frame are identity-bearing.
5. Claimant, issuer, evidence procedure, code used as evidence, model/prompt history, admissibility policy, provenance, lineage, standing, and revocation are excluded from ClaimId unless literally asserted in Proposition or approved as a semantic profile location.
6. WarrantTarget is a typed complete-ClaimId-plus-boundaries family.
7. Direct target matching requires exact equality of every non-scope ClaimId coordinate.
8. Broad-to-narrow scope support is permitted only through a versioned calculus, declared target monotonicity, boundary coverage, and policy permission. Narrow-to-broad direct support is forbidden.
9. Direct temporal projection is forbidden in /0; temporal inference requires an explicit derived warrant.
10. Identity schemas and target schemas are closed; unknown semantic fields fail closed.
11. Interpretation and normalization occur before ClaimId projection and produce provenance receipts.
12. Lineage and represented loss are explicit but do not automatically constitute ClaimId.
13. Equal ClaimId across freeze/revival does not preserve live authority or standing.
14. The current v1 proposition fingerprint never automatically becomes ClaimId or complete WarrantTarget.
15. Migrated v1 warrants are inert testimony; a new live warrant requires authorized replay or re-attestation.
16. CD/0 remains unchanged and no cryptographic algorithm is selected.

## 30.6 Rejected constitutional directions

The receipt rejects proposition-only identity, full-occurrence identity, policy-relative ClaimId, procedure-relative generic ClaimId, lineage-relative ClaimId, WarrantTarget equal to ClaimId, overloaded `as-of`, host/pointer identity, open identity records, digest-primary semantics, and privilege restoration from inert data.

## 30.7 Deferred constitutions

The receipt defers complete proposition, scope, temporal, warrant, admissibility, standing, authority, procedure/module identity, cryptographic, custody, and verified-lineage specifications. Their interfaces and noninterference boundaries are fixed here.

## 30.8 Change boundary

This artifact performs no Common Lisp or Python implementation, no v1 migration, no CD/0 redesign, no cryptographic selection, and no authority/standing adjudication. It ends at the constitutional specification and implementation handoff.

---

**End of Lisp+ Located Claim Identity /0.**
