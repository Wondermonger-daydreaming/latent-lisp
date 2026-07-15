# LCI/0 NORMATIVE FIXTURE PACKAGE SPECIFICATION

**Document:** `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md`  
**Package version:** `0.1`  
**Fixture/profile version in vectors:** `0.1.0` (fixture namespace `Id(["lisp-plus","lci","0","fixture"], …)`)  
**Date:** 2026-07-14  
**Status:** NORMATIVE FIRST-IMPLEMENTATION SEMANTIC PROFILE  
**Candidate specification SHA-256:** `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`  
**Frozen CD/0 packet SHA-256:** `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81`

## 0. Normative status and exact-byte law

This package is neither toy data nor a universal ontology. It is a finite first-implementation semantic world whose purpose is to prevent independent Common Lisp and Python implementers from inventing any neutral value, StableRef scheme, normalizer, calculus, target boundary, resource budget, migration role, represented-loss account, relation result, or failure that affects conformance.

The following artifacts jointly constitute the package:

- this human-readable specification;
- `LCI0-FIXTURE-REGISTRY.json`, containing every fixture definition and exact canonical document;
- `LCI0-FIXTURE-VECTORS.jsonl`, containing executable inputs and exact expected results/refusals;
- Errata 0.1, which delegates the first-profile values and algorithms here.

For every registry definition, the machine registry provides: abstract CD/0 fixture representation; preferred diagnostic notation; complete lowercase canonical hex; expected decoded abstract value; equality class; semantic role; version; source section; byte count; and a SHA-256 checksum explicitly marked non-semantic. For every vector, the JSONL provides the same complete bundle for the aggregate input document and exact expected document, plus operation, profile version, typed failure tuple/path where applicable, and source sections. A human implementation guide may abbreviate a value only by its exact registry fixture ID; the registry remains the byte authority.

All fixture Identifiers descend from the explicit namespace `Id(["lisp-plus","lci","0","fixture"], …)` unless they are pre-existing LCI/0 structural field/tag identifiers. No fixture scheme is represented as production-global.

The package is closed: an unregistered form, field, version, scheme, model, calculus, target, policy outcome, account schema, migration mapping, or local fallback is refused.

## 1. Mneme fixture proposition grammar and normalizer

### 1.1 Normalized AST

A normalized proposition is a closed record with exact fields `kind`, `schema-version`, `form`, and `arguments`. `kind` is the fixture tag `mneme-fixture-proposition`; `schema-version` is integer 0; `form` is one of the eleven registered proposition-form Identifiers; and `arguments` is a closed record whose exact field set and order are owned by the form schema.

Every argument is a closed `PropositionArgument/0` wrapper with a `placement` of either `proposition-subject-content` or `external-claim-location-locator`, plus its CD/0 value. A locator is not a hidden string. It is a closed locator-slot record naming the ClaimLocation coordinate and role. This makes `proposition-location-consistent` structural and testable.

| Form | Exact argument placements | Downward scope monotone | Canonical placement rule | Schema fixture |
| --- | --- | --- | --- | --- |
| file-exists | `artifact`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The artifact is asserted content. Scope, subject-time, basis, and frame are ClaimLocation locators. | `proposition-form-schema.file-exists.0` |
| exact-equality | `left`=subject/content; `right`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | Both operands are content; all semantic-location coordinates remain external. | `proposition-form-schema.exact-equality.0` |
| call-result-equality | `procedure`=subject/content; `input`=subject/content; `expected`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The procedure call is what the proposition says, not evidentiary procedure metadata. | `proposition-form-schema.call-result-equality.0` |
| universal-property-over-scope | `predicate`=subject/content; `quantified-domain`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | yes | The quantified population is the ClaimLocation scope. A literal finite mathematical set would require a distinct content-bearing form. | `proposition-form-schema.universal-property-over-scope.0` |
| existential-property | `predicate`=subject/content; `quantified-domain`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The quantified population is the ClaimLocation scope; broad existence does not imply narrow existence. | `proposition-form-schema.existential-property.0` |
| average-statistical-value | `measure`=subject/content; `expected`=subject/content; `unit`=subject/content; `population-domain`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The population is ClaimLocation scope. The aggregate and unit are proposition content. | `proposition-form-schema.average-statistical-value.0` |
| bounded-corpus-absence | `query`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `corpus-locator`=external locator; `dataset-slice-locator`=external locator; `semantic-boundary-locator`=external locator; `frame-locator`=external locator | yes | Corpus, immutable revision/slice, and search/log horizon are ClaimLocation basis locators. Completion evidence remains WarrantTarget material. | `proposition-form-schema.bounded-corpus-absence.0` |
| artifact-contains-says | `artifact`=subject/content; `content`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The mentioned artifact and quoted content are proposition content. An evidentiary source artifact belongs in target boundaries. | `proposition-form-schema.artifact-contains-says.0` |
| producer-returned-value | `producer`=subject/content; `invocation`=subject/content; `value`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | The model/procedure and invocation are proposition content because production itself is asserted. | `proposition-form-schema.producer-returned-value.0` |
| translation-ambiguity | `source-text`=subject/content; `source-language`=subject/content; `target-language`=subject/content; `candidate-readings`=subject/content; `ambiguity-mode`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | Languages and candidate readings are content; the semantic interpretation frame remains external. | `proposition-form-schema.translation-ambiguity.0` |
| probabilistic-claim | `embedded-proposition`=subject/content; `probability`=subject/content; `uncertainty-model`=subject/content; `scope-locator`=external locator; `subject-time-locator`=external locator; `basis-locator`=external locator; `frame-locator`=external locator | no | Probability and uncertainty model are explicit content; no implicit conversion to a Boolean claim is permitted. | `proposition-form-schema.probabilistic-claim.0` |

The grammar deliberately stops here. It does not define complete Mneme logic, arbitrary lambda terms, host symbols, reader syntax, implicit quantifier domains, or a universal probability calculus.

### 1.2 Placement and consistency

A scope, time, corpus, frame, horizon, or domain occurrence is valid only in the placement owned by the selected form schema. A locator value must match the corresponding normalized ClaimLocation coordinate exactly. Literal objects mentioned by a claim—an artifact said to contain text, a model said to return a value, or a language named by a translation claim—remain proposition content. Evidentiary instruments, execution traces, source artifacts, and policy snapshots belong in WarrantTarget boundaries.

Quantified populations and statistical populations are ClaimLocation scope locators. Corpus identity, immutable revision, dataset slice, and completion/log/path horizon are ClaimLocation basis locators. The vectors `LCI0-PLACEMENT-*` prove refusal when these are duplicated, displaced, or inconsistent.

### 1.3 Normalization contract

The normalizer accepts only the declared normalized AST and the two registered controlled surface families used by mutation vectors. It performs no host reader evaluation, package lookup, Unicode normalization, locale conversion, printer parsing, network lookup, or registry resolution. It is total over that accepted domain, deterministic, pure, versioned, and loss-reporting.

Its immutable conformance evidence is:

- `stable-ref.procedure.mneme-proposition-normalizer` — 563 bytes; checksum `a26d743cd1baed29b6670ad0291bfb3773e750ba6d529d51dcbb05c7c71f251a`;
- `normalizer.conformance-binding.0` — 3200 bytes; checksum `c963d5080155130a1ac0716e9de9c99ed9923c114ad5f9589913cc4b309a971e`;
- `normalizer.mutation-vector.0` — 1665 bytes; checksum `06ee45abbeb3053c681464cf98e9a72901cabf61b95e5c25d7aa7b2f1bb33416`;
- `normalizer.semantic-projection-ledger.0` — 13653 bytes; checksum `8947248fb4ec6f9fe13c23e7a1010b723c419866b53c680832e408d5c73bf185`.

A raw surface outside the declared accepted domain fails before projection. A meaning-changing revision requires a new profile/frame version and a new binding, mutation vector, and ledger.

## 2. Fixture scope calculi

### 2.1 Calculus identities and shapes

The primary calculus is `stable-ref.scope-calculus.primary` — 563 bytes; checksum `921327537a5f57fe9ec57e2c25b4ddef305785350f9c3aff549fea15b82fcd52`. The bridge-less second calculus is `stable-ref.scope-calculus.second` — 568 bytes; checksum `341491cc33ce1ab74ad9172e29ab7c63d3a2bfd8028de7622d039e09b636deb0`. A Scope/0 is the closed record `kind`, `schema-version`, `calculus`, `expression`. Primary expression forms are:

- `universal` with no payload;
- `organization` with exact organization object;
- `department` with organization and department objects;
- `tenant` with organization and tenant objects;
- `region-set` with strictly sorted, duplicate-free region members;
- `symbolic-predicate` with the registered symbolic token;
- the second calculus accepts only its own `opaque-token` expression.

The authoritative neutral universal scope is `neutral.universal-scope` — 936 bytes; checksum `d2b4a25a8001500574f676020517d165177e36e99d202bd6e7ea5570a35e07b0`. Tenant A and tenant B are disjoint. Departments Research and Operations are disjoint children of Organization Acme. Regions X={east,north} and Y={east,south} overlap; singleton east, north, and south scopes provide narrower/disjoint witnesses. The symbolic predicate produces `unknown`. Cross-calculus comparison with the second calculus is `incompatible`; no bridge exists.

### 2.2 Normalization and relation algorithm

Normalization validates exact calculus and version, exact closed form, required fields, sorted region members, absence of duplicates, and all LCI budgets before returning a canonical expression. It never estimates extension membership from ambient data.

The complete relation table over registered scopes is `scope.relation-table.0` — 389416 bytes; checksum `1705816297f0c5523d3f82a8b629d9207515c3b88a104d36cbde2246c590ae23`. It is total over those exact values with outcomes `equal`, `narrower`, `wider`, `overlap`, `disjoint`, `incompatible`, or `unknown`. Unknown is an F-valued relation result at the target boundary.

The frozen §11.7 witness set is:

| Vector | Left | Right | Expected |
| --- | --- | --- | --- |
| LCI0-SCOPE-UNIVERSAL-ORG | universal | organization/acme | wider |
| LCI0-SCOPE-ORG-DEPT | organization/acme | department/research | wider |
| LCI0-SCOPE-TENANT-DISJOINT | tenant/a | tenant/b | disjoint |
| LCI0-SCOPE-REGIONAL-OVERLAP | region {east,north} | region {east,south} | overlap |
| LCI0-SCOPE-REGION-EAST-NORTH | region {east} | region {north} | disjoint |
| LCI0-SCOPE-REGION-NORTH-SOUTH | region {north} | region {south} | disjoint |
| LCI0-SCOPE-SYMBOLIC-UNKNOWN | symbolic π | organization/acme | F(relation-undetermined/ScopeRelationUnknown) |

Every listed vector contains complete input and expected-result octets in the JSONL. The full Cartesian relation table and every table-entry document are in the registry.

### 2.3 Monotonicity declarations

Monotonicity is declared jointly by exact target schema and exact proposition form. It is never inferred. `universal-property-over-scope` is downward-monotone only in the target schemas that list it. `bounded-corpus-absence` is downward-monotone only for `derived` and `corpus-completion`. `existential-property`, `average-statistical-value`, and all other unlisted forms are explicitly nonmonotone.

## 3. Fixture temporal model

The primary model is `stable-ref.temporal-model.primary` — 568 bytes; checksum `17dff931bdd5206ab255522940ba4ed77fbe4764ae5ccf48fc973e7933814165`; the bridge-less second model is `stable-ref.temporal-model.second` — 568 bytes; checksum `5e3a676ac5dc9b820a3ec8fe0a77c331cb57b11b13622f149d79090bb10f797c`. SubjectTime/0 is the closed record `kind`, `schema-version`, `temporal-model`, `expression`. Exact forms are:

- `atemporal` (the neutral `neutral.atemporal-subject-time` — 960 bytes; checksum `5bb34bdb9115789ff4a9f900ae011cac63c558c5641d7eae3a317883f152824e`);
- `instant` with an integer fixture tick;
- `interval` with integer start/end and explicit Boolean start/end closure;
- `periodic-set` for deterministic even/odd witnesses;
- `symbolic` for an unknown-relation witness;
- the second model’s `opaque-token`.

Intervals validate `start < end`; endpoint flags are required. Registered forms include `[100,124]`, `(100,124]`, `[100,124)`, `(100,124)`, `[0,50]`, and `[200,220]`.

The complete relation table is `temporal.relation-table.0` — 661466 bytes; checksum `3de57dd9584d3c278c1a18684a2155ddf7f735af228b8b6b2f95f539bb8d3cf9`. Exact equality, before, after, contains, contained-by, overlap, disjoint, incompatible, and unknown are all executable:

| Vector | Left | Right | Expected |
| --- | --- | --- | --- |
| LCI0-TEMPORAL-EQUAL | instant 100 | instant 100 | equal; direct match allowed |
| LCI0-TEMPORAL-BEFORE | instant 100 | instant 124 | before; no direct match |
| LCI0-TEMPORAL-AFTER | instant 124 | instant 100 | after; no direct match |
| LCI0-TEMPORAL-CONTAINS | [100,124] | instant 100 | contains; no direct match |
| LCI0-TEMPORAL-CONTAINED-BY | instant 100 | [100,124] | contained-by; no direct match |
| LCI0-TEMPORAL-OVERLAP | [100,124] | (100,124] | overlap; no direct match |
| LCI0-TEMPORAL-DISJOINT | [0,50] | [200,220] | disjoint |
| LCI0-TEMPORAL-UNKNOWN | symbolic unknown | instant 100 | F(relation-undetermined/AdmissibilityUndetermined) |
| LCI0-TEMPORAL-INCOMPATIBLE | primary instant | second-model opaque | F(relation-undetermined/UnsupportedTemporalModel) |

Temporal containment is informative only. Direct target matching requires exact validated SubjectTime/0 equality. A target event time (observation, execution, test, issue, replay, report, query, or completion time) never substitutes for ClaimId subject-time.

## 4. Dataset-slice and semantic-boundary calculi

### 4.1 Dataset slices

The primary slice calculus is `stable-ref.slice-calculus.primary` — 593 bytes; checksum `6f5d38ee64318d07583e454c06f6b37388afc0453931e2abc2bc26fa4c83b017`. DatasetSlice/0 is closed over `kind`, `schema-version`, `calculus`, and `expression`. Registered expressions are:

- `all-members`, pinned as `neutral.all-members-slice` — 984 bytes; checksum `a07f5910a8c8eaf11737a6f96bf8e3ee7474dac9b7adb51419b2191d1eb06baa`;
- finite `explicit-members`, strictly sorted and duplicate-free over exact artifact StableRefs;
- `predicate`, accepted only for the registered deterministic file-prefix predicate over a declared finite revision.

An unregistered predicate, ambient query, mutable corpus view, duplicate member, wrong revision domain, or unsupported nested version fails closed.

### 4.2 Semantic boundaries

The primary boundary calculus is `stable-ref.boundary-calculus.primary` — 608 bytes; checksum `990efe70bc2ad462f7f41c3c757517be16591641d255b8fb91086e90f8b66375`. SemanticBoundary/0 is closed over `kind`, `schema-version`, `calculus`, and `expression`. Registered expressions are:

- `not-applicable`, pinned as `neutral.not-applicable-boundary` — 1013 bytes; checksum `0db0dedf17bab2acd9239fb63823d0cf303029898248a08b15a8030ac6e52ad6`;
- `snapshot-manifest` with an exact immutable manifest artifact;
- `path-root` with a normalized absolute fixture path rooted in the named immutable corpus revision;
- `log-horizon` with an exact closed event boundary.

The calculus refuses relative/escaping paths, mutable manifests, mixed corpus revisions, implicit latest revisions, unknown horizon forms, and unsupported versions. Slice/boundary coherence is tested as a cross-field check of corpus basis and relevant target kinds.

### 4.3 Corpus and revision schemes

Logical corpus and immutable corpus revision are distinct StableRef domains. Canonical examples are `stable-ref.corpus.alpha` — 562 bytes; checksum `11cb1548999eacd55861a7ca757099897cdb711cbc84a4f842a8fa84b9271b92` and `stable-ref.revision.alpha.3` — 606 bytes; checksum `de592c9393d7324c0049bae92d3ad7f84227e763bfe4ce110dee8a1d8a97c20b`. A revision StableRef is immutable structural material. Display names and “latest” aliases are not accepted. Corpus/revision mismatch fails before ClaimId projection.

## 5. Fixture interpretation-frame schema

The schema reference is `stable-ref.frame-schema.primary` — 608 bytes; checksum `d9849523d9d3b541805b0b2140fd1d95c780313c3406c0989f2b19f6af05342a`. InterpretationFrame/0 is closed over `kind`, `schema-version`, `frame-schema`, and `components`. The registered frames are:

- neutral self-describing frame: `neutral.self-describing-frame` — 778 bytes; checksum `60aef90afa2c0ea212f6d03811f9898fb2508f53d5ba52fce774946753cadae1`;
- animal ontology, SI units, schema v1: `interpretation-frame.animal-si-v1` — 1790 bytes; checksum `0b244538ee8fa99b4612de3859459a0e4cf20d22dee6fb9f225a13b7ff6bb9a5`;
- vehicle ontology, SI units, schema v1: `interpretation-frame.vehicle-si-v1` — 1791 bytes; checksum `c0c1b88226277cdb45d9dc924b655621f52a7bc940955065e5b13d72c67f6c80`;
- animal ontology, imperial units, schema v1: `interpretation-frame.animal-imperial-v1` — 1796 bytes; checksum `79f1d995d6377e42022f8fbfe68dafe8e1ea0ce23e35d4f72d67ab2b80136ea8`;
- animal ontology, SI units, schema v2: `interpretation-frame.animal-si-v2` — 1790 bytes; checksum `f180ff193629c00c3973690daac38f12b4188ac98bd8021cf674c1f45d7b1f5d`.

Components are exact, complete, and closed: ontology artifact, unit system, measurement/schema artifact, language/semantic conventions, and exact component version closure. Animal versus vehicle, SI versus imperial, and schema v1 versus v2 produce different frames and therefore different ClaimIds. A meaning-free proposition must use the pinned neutral frame, not a gratuitous ontology frame.

Normalization may map only registered co-denoting surfaces to one exact frame. If it discards a source distinction it emits a closed RepresentedLoss account; if the distinction changes semantics, it produces a different frame or refuses.

## 6. StableRef fixture registry

### 6.1 Common material schema

Every fixture StableRef is the closed record `kind=stable-reference`, `domain`, `scheme`, `material`. Every canonical scheme uses the exact structural material record:

```text
FixtureStableMaterial/0 {
  kind: fixture-stable-material,
  schema-version: 0,
  object-id: Identifier under the registered domain prefix,
  object-version: nonnegative integer
}
```

This is structural fixture material, not a cryptographic hash. Alias and mutable-name refusal is mandatory. A changed object meaning requires a new object-id or object-version. A changed material interpretation requires a new scheme Identifier. Represented loss must be explicit or the conversion refuses.

| Domain | Domain fixture | Only scheme fixture | Material fields | Canonical example | Definition bytes/checksum prefix |
| --- | --- | --- | --- | --- | --- |
| scope-calculus | `domain.scope-calculus` | `scheme.scope-calculus.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.scope-calculus.primary` | 1252/69edf21d24ec99fb… |
| temporal-model | `domain.temporal-model` | `scheme.temporal-model.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.temporal-model.primary` | 1252/5c915f34716e164e… |
| dataset-slice-calculus | `domain.dataset-slice-calculus` | `scheme.dataset-slice-calculus.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.slice-calculus.primary` | 1284/80aa4c0b2e5ab824… |
| semantic-boundary-calculus | `domain.semantic-boundary-calculus` | `scheme.semantic-boundary-calculus.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.boundary-calculus.primary` | 1300/74bb0a071ceb64be… |
| interpretation-frame-schema | `domain.interpretation-frame-schema` | `scheme.interpretation-frame-schema.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.frame-schema.primary` | 1304/52b210bea45283f6… |
| logical-corpus | `domain.logical-corpus` | `scheme.logical-corpus.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.corpus.alpha` | 1252/5ca8818e67dade92… |
| immutable-corpus-revision | `domain.immutable-corpus-revision` | `scheme.immutable-corpus-revision.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.revision.alpha.3` | 1296/159a2c44503b2752… |
| module | `domain.module` | `scheme.module.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.module.mneme-fixture-profile` | 1220/06e86d8d2b9d4284… |
| procedure | `domain.procedure` | `scheme.procedure.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.procedure.mneme-proposition-normalizer` | 1232/0b04f5a79ccd3c26… |
| model | `domain.model` | `scheme.model.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.model.alpha.1` | 1216/f9ea849b69dab8e1… |
| prompt-invocation | `domain.prompt-invocation` | `scheme.prompt-invocation.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.invocation.call-17` | 1264/7cc7f4b25e0d35f3… |
| artifact | `domain.artifact` | `scheme.artifact.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.artifact.file.alpha` | 1228/a1c4d3290e095e50… |
| principal | `domain.principal` | `scheme.principal.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.principal.claimant-alpha` | 1232/8e9d404506dbb1f9… |
| policy | `domain.policy` | `scheme.policy.structural.0` | kind; schema-version; object-id; object-version | `stable-ref.policy.a` | 1220/705c3700bfc269e3… |

Complete canonical octets for every domain Identifier, scheme Identifier, scheme definition, and example are in the machine registry. There is exactly one `scheme-definition.*.structural.0` per domain.

### 6.2 Bridges

No bridge means distinct StableRefs and distinct ClaimIds/targets. The only bridge fixture is explicitly nonproduction, versioned, total over its tiny declared source domain, and independently vectored. It canonicalizes before projection; it never rewrites historical envelope equality. `LCI0-E7-BRIDGE-NONRETROACTIVE` and the no-bridge vectors are normative.

## 7. Closed fixture target schemas

### 7.1 Common envelope and matching algorithm

WarrantTarget/0 is closed over `kind`, `lci-version`, `target-kind`, `target-schema`, `claim`, and `boundaries`. The complete embedded ClaimId is always present. Every target schema has no optional fields and recursively rejects unknown or unsupported nested versions.

Boundary coherence proceeds in this order:

1. validate frozen CD/0 and the closed WarrantTarget envelope;
2. require the exact target-kind/target-schema pair;
3. recursively validate the complete embedded ClaimId;
4. validate every required boundary in declared field order;
5. enforce evidence-event temporal roles and prohibit substitution for subject-time;
6. enforce kind-specific procedure/model/artifact/corpus/premise/translation/policy coherence;
7. compare all non-scope ClaimId coordinates exactly;
8. evaluate coverage scope;
9. if exact scope, return `R("exact-target")`;
10. if target scope is wider, require the exact schema/form monotonicity declaration and sufficient coverage, then return `R("supports-by-scope-narrowing")`;
11. otherwise return the exact typed F result;
12. policy evaluation is permitted only for the two R results.

The common failure vocabulary includes `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`. Kind-specific additions are stated below.

### 7.1 `observed`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "observed"])`
- Target-schema StableRef: `stable-ref.target-schema.observed` — 548 bytes; checksum `a25e9d8397b6e8782da6d1cf2ad2f67e547186769f32bab19c6fe58e67a32354`
- Closed schema definition: `target-schema-definition.observed.0` — 5519 bytes; checksum `612ceeba0eadece5902ad0f1a13ec105b41c9e73e29153db214e1659f958fb9c`
- Optional fields: none.
- Declared downward-monotone proposition forms: `universal-property-over-scope`.
- Exact positive vector: `LCI0-TARGET-01-OBSERVED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-01-OBSERVED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | observer-or-instrument | StableRef:principal |
| 2 | observation-procedure | StableRef:procedure |
| 3 | observation-time | EvidenceEventTime/0 |
| 4 | coverage-scope | Scope/0 |
| 5 | observation-mode | Identifier |
| 6 | observation-artifact-or-event | StableRef:artifact |
### 7.2 `executed`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "executed"])`
- Target-schema StableRef: `stable-ref.target-schema.executed` — 548 bytes; checksum `befcabd99316b95713caaf8a551fc92e2bbdd0fe45d2b8633916332e1d2ee779`
- Closed schema definition: `target-schema-definition.executed.0` — 5885 bytes; checksum `db6437d2f5567dc67f53a5cf32381d039629796f149ede3a7d632c35baaf934f`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-02-EXECUTED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-02-EXECUTED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`, `ProcedureIdentityInsufficient`, `ProcedureMismatch`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | procedure-reference | StableRef:procedure |
| 2 | immutable-code-or-semantics | StableRef:artifact |
| 3 | invocation | StableRef:prompt-invocation |
| 4 | execution-environment-semantics | StableRef:module |
| 5 | execution-time | EvidenceEventTime/0 |
| 6 | execution-event-or-trace | StableRef:artifact |
| 7 | coverage-scope | Scope/0 |
### 7.3 `tested`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "tested"])`
- Target-schema StableRef: `stable-ref.target-schema.tested` — 546 bytes; checksum `184dd38df0dbc2da3621b775f65eedeb728083570db376c033a5f0acd794512f`
- Closed schema definition: `target-schema-definition.tested.0` — 6341 bytes; checksum `1fe9d0885ad77ca42c4241ce9e3364118a608a88ef9a2bcfbb974f4b5cf12af2`
- Optional fields: none.
- Declared downward-monotone proposition forms: `universal-property-over-scope`.
- Exact positive vector: `LCI0-TARGET-03-TESTED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-03-TESTED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`, `ProcedureIdentityInsufficient`, `ProcedureMismatch`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | system-or-procedure-under-test | StableRef:procedure |
| 2 | immutable-tested-version | StableRef:artifact |
| 3 | test-case-or-suite | StableRef:artifact |
| 4 | test-input | CD/0 value |
| 5 | expected-relation | Identifier |
| 6 | execution-environment-semantics | StableRef:module |
| 7 | execution-time | EvidenceEventTime/0 |
| 8 | test-event-or-trace | StableRef:artifact |
| 9 | coverage-scope | Scope/0 |
### 7.4 `derived`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "derived"])`
- Target-schema StableRef: `stable-ref.target-schema.derived` — 547 bytes; checksum `d3e43d3dd90000850ef79a1e55639a6195a6b499f982c0a3ae412e305c8c820b`
- Closed schema definition: `target-schema-definition.derived.0` — 5328 bytes; checksum `26183b6182934746bee43c95e372f0465c1a79e016f60caf925072bfc68ade1a`
- Optional fields: none.
- Declared downward-monotone proposition forms: `universal-property-over-scope`, `bounded-corpus-absence`.
- Exact positive vector: `LCI0-TARGET-04-DERIVED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-04-DERIVED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`, `PremiseMismatch`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | inference-calculus | StableRef:module |
| 2 | premise-claim-ids | sequence<ClaimId> |
| 3 | rule-or-derivation-identity | StableRef:procedure |
| 4 | derivation-artifact-or-trace | StableRef:artifact |
| 5 | coverage-scope | Scope/0 |
### 7.5 `externally-attested`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "externally-attested"])`
- Target-schema StableRef: `stable-ref.target-schema.externally-attested` — 559 bytes; checksum `335dc0486c146730b5accb4425fedd0b726868a0b1099a4c30dea5e916deba38`
- Closed schema definition: `target-schema-definition.externally-attested.0` — 5303 bytes; checksum `3a2af4034860fe22c9fdb0153083062e32b1d0f86e62c7f439f3a40d24f6a17c`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-05-EXTERNALLY-ATTESTED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-05-EXTERNALLY-ATTESTED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | external-principal | StableRef:principal |
| 2 | external-statement-or-artifact | StableRef:artifact |
| 3 | attestation-time | EvidenceEventTime/0 |
| 4 | mapping-receipt | StableRef:artifact |
| 5 | coverage-scope | Scope/0 |
### 7.6 `replayed`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "replayed"])`
- Target-schema StableRef: `stable-ref.target-schema.replayed` — 548 bytes; checksum `11d0f79666277882eeb39c65b27cbe1e7e0a765362057743f09257bd62811de2`
- Closed schema definition: `target-schema-definition.replayed.0` — 6072 bytes; checksum `58be784864e1a10e8c11c6cca7d72ad2cdc3da7ffd28f58fd992db4fb2193b28`
- Optional fields: none.
- Declared downward-monotone proposition forms: `universal-property-over-scope`.
- Exact positive vector: `LCI0-TARGET-06-REPLAYED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-06-REPLAYED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | predecessor-warrant-testimony-or-event | StableRef:artifact |
| 2 | replay-procedure | StableRef:procedure |
| 3 | immutable-code-or-semantics | StableRef:artifact |
| 4 | replay-invocation | StableRef:prompt-invocation |
| 5 | execution-environment-semantics | StableRef:module |
| 6 | replay-time | EvidenceEventTime/0 |
| 7 | new-replay-trace-or-result | StableRef:artifact |
| 8 | coverage-scope | Scope/0 |
### 7.7 `corpus-completion`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "corpus-completion"])`
- Target-schema StableRef: `stable-ref.target-schema.corpus-completion` — 557 bytes; checksum `537a07e862cb4c291c23768bbe714022cc575dc4abd02634a14bedf95eb086c4`
- Closed schema definition: `target-schema-definition.corpus-completion.0` — 6384 bytes; checksum `cefb13af591a79a7460ce408b9f3c1dcd4ba7e54f3da7e7b93c92d6fcb492233`
- Optional fields: none.
- Declared downward-monotone proposition forms: `bounded-corpus-absence`.
- Exact positive vector: `LCI0-TARGET-07-CORPUS-COMPLETION-POS`.
- First-field-missing negative vector: `LCI0-TARGET-07-CORPUS-COMPLETION-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`, `CorpusCompletionInsufficient`, `BasisMismatch`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | exact-corpus-basis | ClaimBasis/0 corpus variant |
| 2 | search-procedure | StableRef:procedure |
| 3 | immutable-code-or-semantics | StableRef:artifact |
| 4 | query-or-search-expression | normalized proposition |
| 5 | coverage-plan | StableRef:artifact |
| 6 | completion-boundary | SemanticBoundary/0 |
| 7 | execution-time | EvidenceEventTime/0 |
| 8 | completion-receipt-or-trace | StableRef:artifact |
| 9 | coverage-scope | Scope/0 |
### 7.8 `reported`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "reported"])`
- Target-schema StableRef: `stable-ref.target-schema.reported` — 548 bytes; checksum `17f0252d04edeafa6acb8d1b78a33a13a69c3737184c248d4aec74867d14cd3e`
- Closed schema definition: `target-schema-definition.reported.0` — 5298 bytes; checksum `9a8193649a3a379dcfe3bdf19706eb60790f702e9c5b5b74bbdb526c530addf0`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-08-REPORTED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-08-REPORTED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | reporter-or-source-principal | StableRef:principal |
| 2 | source-artifact | StableRef:artifact |
| 3 | report-time | EvidenceEventTime/0 |
| 4 | content-to-claim-interpretation-receipt | StableRef:artifact |
| 5 | coverage-scope | Scope/0 |
### 7.9 `inherited`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "inherited"])`
- Target-schema StableRef: `stable-ref.target-schema.inherited` — 549 bytes; checksum `635c8a0c83e0ec2b5bae576ad82f65c9b270c09eda2d3b33d44dbf2c97888987`
- Closed schema definition: `target-schema-definition.inherited.0` — 5588 bytes; checksum `bbd9f5f4265a8bbe107e0d590e0a16ff4fddc2637fc82808ae0b4b459b173127`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-09-INHERITED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-09-INHERITED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | predecessor-occurrence-or-artifact | StableRef:artifact |
| 2 | predecessor-warrant-testimony | StableRef:artifact |
| 3 | inheritance-or-handoff-rule | StableRef:policy |
| 4 | handoff-freeze-revival-receipt | StableRef:artifact |
| 5 | represented-loss | RepresentedLoss/0 |
| 6 | coverage-scope | Scope/0 |
### 7.10 `translated`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "translated"])`
- Target-schema StableRef: `stable-ref.target-schema.translated` — 550 bytes; checksum `c73b50243324f71df3f9f5da87ee539d8e2ed209f2a6945d32bf36d037c0f008`
- Closed schema definition: `target-schema-definition.translated.0` — 5825 bytes; checksum `5724ed3c1aed3dd96f8bd874c6a3450131e8a357888fe447a25fea3f10f5bd6a`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-10-TRANSLATED-POS`.
- First-field-missing negative vector: `LCI0-TARGET-10-TRANSLATED-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`, `TranslationBoundaryMismatch`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | source-claim-id | ClaimId |
| 2 | source-interpretation-frame | InterpretationFrame/0 |
| 3 | target-interpretation-frame | InterpretationFrame/0 |
| 4 | translation-procedure | StableRef:procedure |
| 5 | translation-receipt | StableRef:artifact |
| 6 | represented-loss | RepresentedLoss/0 |
| 7 | coverage-scope | Scope/0 |
### 7.11 `policy-evaluation`

- Target-kind Identifier: `Id(["lisp-plus", "lci", "0", "fixture"], ["target-kind", "policy-evaluation"])`
- Target-schema StableRef: `stable-ref.target-schema.policy-evaluation` — 557 bytes; checksum `2bc878e2e29208f193a0039a5d584fff081b0d57b8af0ce456fa9491d9f476d2`
- Closed schema definition: `target-schema-definition.policy-evaluation.0` — 5708 bytes; checksum `8f57f604343949c7676f1b13ebdeabe2690847957d56a7c88aff62beb5e45b54`
- Optional fields: none.
- Declared downward-monotone proposition forms: none.
- Exact positive vector: `LCI0-TARGET-11-POLICY-EVALUATION-POS`.
- First-field-missing negative vector: `LCI0-TARGET-11-POLICY-EVALUATION-NEG`.
- Failure vocabulary: `InvalidWarrantTarget`, `UnsupportedTargetKind`, `TargetSchemaKindMismatch`, `TargetBoundaryMissing`, `TargetBoundaryUnknown`, `TargetBoundaryMismatch`, `ScopeNarrowingNotDeclared`, `ScopeNarrowingCoverageInsufficient`.

| Order | Boundary field | Required type |
| --- | --- | --- |
| 1 | policy | StableRef:policy |
| 2 | evaluated-warrant | StableRef:artifact |
| 3 | state-snapshot | StableRef:artifact |
| 4 | query-time | EvidenceEventTime/0 |
| 5 | testimony-mode | Identifier |
| 6 | inner-target-relation | TargetRelationResult/0 |
| 7 | coverage-scope | Scope/0 |


### 7.12 Policy-evaluation is meta-testimony

The policy-evaluation target’s `testimony-mode` is explicit meta-testimony and its `inner-target-relation` is a complete TargetRelationResult/0. It does not directly support the embedded ClaimId. This distinction is validated by `LCI0-I12-POLICY-META-TESTIMONY`.

## 8. Frozen Policy-A and Policy-B

Policy-A and Policy-B are exact finite fixture policies, not production admissibility law. Their complete records and octets are `admissibility-policy.a.0` — 8128 bytes; checksum `467561cb0c91e644761006dac047dac7efde77840d49ec12bf113704256f6373` and `admissibility-policy.b.0` — 8782 bytes; checksum `0e04628c6bf3f8361ca1f8f61b7ffe9288e17e056f4fada097f8f8f2f39ecc6f`.

| Policy | Registry fixture | Accepted target relations | Scope narrowing | Represented loss | Inherited testimony | External attestation | Hard-reject all F |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Policy-A | admissibility-policy.a.0 | exact-target, supports-by-scope-narrowing | true | reject-all | reject | reject | true |
| Policy-B | admissibility-policy.b.0 | exact-target, supports-by-scope-narrowing | true | identity-neutral accept; translation/authority limited; identity-bearing/unknown reject | limited-testimony | trusted-principal-only | true |

### 8.1 Deterministic evaluation order

Both policies first enforce the E2 floor. Every F-valued target result produces `hard-reject-target-relation` with `policy-not-consulted`; no freshness, trust, or loss predicate may overturn it. For an R-valued result, evaluation order is: target-kind rule; boundary coherence; represented-loss rule; inherited/external trust rule; freshness; final outcome.

The exact decision-result vocabulary is:

```text
accept-direct
accept-scope-narrowed
accept-limited-testimony
hard-reject-target-relation
reject-target-kind
reject-stale
reject-represented-loss
reject-untrusted-external-principal
reject-policy-meta-as-direct-support
reject-boundary-coherence
```

Decision support class is exact (`direct-support`, `scope-narrowed-support`, `limited-testimony`, or `rejected`), and every decision records policy, relation result, target kind, query time, freshness result, outcome, reasons, and support class.

### 8.2 Freshness

Fixture time is integer-tick time under the primary temporal model. Policy-A permits a maximum age of 24 ticks for observed, executed, tested, replayed, and corpus-completion evidence; other kinds are rejected. Policy-B permits 168 ticks for observed, executed, tested, replayed, corpus-completion, reported, externally-attested, and policy-evaluation; inherited and translated testimony are handled by their dedicated limited-testimony/loss rules. Freshness never changes ClaimId.

### 8.3 Loss, inherited testimony, and external attestation

Policy-A rejects every represented-loss consequence, inherited testimony, and external attestation. Policy-B accepts identity-neutral loss where the account proves all identity dimensions preserved; admits semantic-translation or authority/custody loss only as limited testimony where expressly listed; rejects identity-bearing or unknown loss; trusts only the exact registered external principal; and never turns inherited testimony into live authority.

## 9. v1 migration fixture package

### 9.1 Frozen grammar

The legacy grammar is `migration.legacy-grammar.0` — 1309 bytes; checksum `7ab85681ecab610436911f567041bc25f6a9bf5eaa47b1e9742155ea96bbd411`. It is strict UTF-8, non-evaluating, resource-bounded, accepts exactly one proper-list form and EOF, and admits only strings, integers, package-qualified symbols, keyword symbols, and proper lists. Read-eval, reader macros, quote/backquote/comma, comments, dispatch syntax, dotted lists, circular labels, package interning, and arbitrary host objects are refused. The maximum legacy input is 32,768 octets and maximum grammar depth is 32, additionally bounded by LCI resource rules.

Migration never invokes v1 code or current registries. The source bytes are parsed into inert fixture records only.

### 9.2 Frozen mapping tables

The package/symbol mapping table is total only over its twelve registered rows and maps exact source package + symbol + semantic role to segmented fixture Identifiers. Case-folded, near-miss, inherited package, alias, and plausible-but-wrong mappings refuse. The source-site/as-of table distinguishes claim subject-time, observation time, execution time, attestation issue time, completion log horizon, standing query time, and ambiguous judgment sites.

The exact table artifacts are `stable-ref.artifact.migration.symbol-table.0` — 564 bytes; checksum `022068cdfbdfe2b27564d8065653406e48b778f4be4604fbece7100456c71df1` and `stable-ref.artifact.migration.as-of-table.0` — 560 bytes; checksum `5c39d07d60e51624df38abc89a7f12620c81728d4b1b75361b71e770c2f4b121`.

### 9.3 Migration classifications

| LCI classification | Prior ruling | Qualification |
| --- | --- | --- |
| exact | exact | one-to-one |
| exact-after-explicit-tagging | explicitly-tagged | one-to-one |
| new-identity-required | profile-adapted | new LCI envelope projected; predecessor identity remains lineage only |
| lossy-with-represented-loss | lossy-with-represented-loss | one-to-one |
| rejected | rejected | one-to-one |
| deferred-to-named-calculus | profile-adapted | gate classification; must resolve through named calculus before final exact/tagged/lossy/rejected outcome |
| privileged-runtime-relation-outside-claim-id | profile-adapted | data may be projected as inert testimony; live authority is not migrated |

A deferred classification names the exact calculus required before a final result. A privileged-runtime relation may be represented only as inert testimony with explicit loss; it is never a migrated live relation.

### 9.4 Required cases and collision rules

The vector artifact freezes exact successes/refusals for Unicode NFC/NFD non-normalization, compact/pretty printer variation, hostile read-eval, plausible ambiguous as-of, near-miss package names, semantically wrong identifier mapping, legacy fingerprints colliding across scope, subject-time, and corpus revision, inert predecessor warrants, and attempted live restoration. Legacy fingerprints are lineage data only and never ClaimId material. Every successful migration projects a fresh LCI/0 ClaimId from reconstructed exact fields; zero live warrants are created.

## 10. LCI-layer resource budgets

These limits are separate from frozen CD/0 decoder budgets. They govern LCI validation, normalization, projection, matching, admissibility, and migration as listed. A conforming implementation must accept every within-budget normative fixture and return the exact failure code for an over-budget deterministic workload. It may impose tighter operational limits only outside the conformance surface and must not misreport them as the normative result.

| Resource | Limit | Applies to phases | Failure code |
| --- | --- | --- | --- |
| aggregate-payload-octets | 131072 | validation, normalization, projection, matching, migration | LCIAggregatePayloadBudgetExceeded |
| identifier-segments | 32 | validation, normalization, projection, matching, migration | LCIIdentifierSegmentBudgetExceeded |
| maximum-nesting | 64 | validation, normalization, projection, matching, migration | LCIMaxNestingExceeded |
| migration-input-octets | 32768 | migration | MigrationInputSizeExceeded |
| node-count | 4096 | validation, normalization, projection, matching, migration | LCINodeCountExceeded |
| proposition-normalization-work | 10000 | normalization, projection | PropositionNormalizationWorkExceeded |
| record-fields | 64 | validation, projection, matching, migration | LCIRecordFieldBudgetExceeded |
| represented-loss-account-entries | 64 | validation, migration, admissibility | RepresentedLossAccountSizeExceeded |
| scope-relation-work | 4096 | matching | ScopeRelationWorkExceeded |
| sequence-length | 256 | validation, normalization, projection, matching, migration | LCISequenceLengthBudgetExceeded |
| stable-reference-material-octets | 4096 | validation, projection, matching, migration | StableReferenceMaterialBudgetExceeded |
| target-boundary-work | 8192 | validation, matching | TargetBoundaryWorkExceeded |
| temporal-relation-work | 4096 | matching, admissibility, migration | TemporalRelationWorkExceeded |

The measurement root is the operation's `payload` CD/0 value. The outer fixture-vector harness (`kind`, vector ID, operation, profile-version, and wrapper fields) is excluded. Structural counting version 0 is exact: payload root depth is 1; record keys and values and sequence members are child nodes; node count includes every CD/0 value node including record keys; record-fields and sequence-length are maxima over the tree; identifier-segments is the maximum `namespace` plus `path` segment count; aggregate-payload-octets is the canonical CD/0 **ValueBytes** length of the payload root, excluding document magic/version; StableRef material size is the maximum material ValueBytes length. Migration input size is exact source UTF-8 length before parsing.

Operation-work counters are also closed: proposition normalization counts source nodes visited plus normalized nodes emitted plus represented-loss entries emitted; scope relation counts one dispatch, one table lookup, and one unit per finite member inspected; temporal relation counts one dispatch and one unit per form, endpoint, or periodic residue inspected; target-boundary work counts one unit per boundary field plus one per recursively visited boundary value node; represented-loss account entries is the sum of items in sequence-valued account fields. Budget checks run in the registry's declared resource order. The highest non-resource vector payload is 71,933 ValueBytes (`LCI0-P021`), below the 131,072-octet aggregate limit.

Counting is deterministic and preallocation-aware. The workload generator registry is `resource-workload-generator-registry.0` — 5650 bytes; checksum `4ca93f96960244f2981fc9cd758a4ed8680724cc845286feb67ddc75a5479d63`; each resource vector requests exactly `limit + 1` under the named zero-seeded generator. Implementations reject declared over-limit work before proportional allocation where possible.

## 11. Claim-occurrence and artifact metadata schema

The FullClaimOccurrence/0 wrapper is **not ClaimId**. It is a closed top-level record containing:

```text
kind
schema-version
semantic-claim-core
claimant
assertion-time
provenance
lineage
cached-claim-id
presentation
nonidentity-metadata
```

The semantic claim core projects to ClaimId. Claimant, assertion time, provenance, lineage, presentation, and the one explicitly open inert metadata subrecord do not. Cached ClaimId must recompute exactly from the semantic core; a stale or self-declared cache is refused.

Unknown top-level metadata fails because the wrapper is closed. Unknown keys are allowed only inside `nonidentity-metadata.entries`; keys there are arbitrary CD/0 Identifiers and values are inert CD/0 values. They are ignored by projection but preserved by occurrence equality/serialization. `LCI0-METADATA-NEUTRAL-ALL-FIELDS` changes every nonidentity field and proves ClaimId preservation; `LCI0-METADATA-UNKNOWN-TOP-CLOSED` proves recursive closure outside the open path.

The authoritative schema is `closed-schema.claim-occurrence.0` — 3246 bytes; checksum `8f6bd8305a64b46406d88ab007b17a15a52aead01a6de425946f3fd164f91b4d`.

## 12. RepresentedLoss account schemas

RepresentedLoss/0 is closed over `kind`, `schema-version`, `operation`, `source`, `lost-dimensions`, `consequence`, and `account`. `account` is never implementation-defined. Its exact closed schema is selected by operation and must agree with listed lost dimensions and consequence.

### 12.1 `v1-migration`

- Schema Identifier: `represented-loss-account-schema-id.v1-migration.0` — 79 bytes; checksum `870d036d8cfdf1fbc7062b8b2f4e5d5e9bf03a7fe6981324de0140937e7ed830`
- Schema definition: `represented-loss-account-schema-definition.v1-migration.0` — 2629 bytes; checksum `5d39867dae6eea30ca22fb42760c3b3be129204467c28ad9359683672d456c8d`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | source-format | Identifier |
| 5 | adapter | StableRef:procedure |
| 6 | recovered-dimensions | sequence<Identifier> |
| 7 | unresolved-dimensions | sequence<Identifier> |
| 8 | mapping-receipts | sequence<StableRef:artifact> |
| 9 | classification | Identifier |
### 12.2 `translation`

- Schema Identifier: `represented-loss-account-schema-id.translation.0` — 78 bytes; checksum `76c931f9e06dd4df8fc9ffe449e484046a5ecd27c957cfaf52c5fd81c4a97203`
- Schema definition: `represented-loss-account-schema-definition.translation.0` — 2620 bytes; checksum `44608380b7ca373a4f782db587bc4fce115f12811a92d138a69bab1e4ada53aa`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | source-language | Identifier |
| 5 | target-language | Identifier |
| 6 | lost-features | sequence<Identifier> |
| 7 | preserved-features | sequence<Identifier> |
| 8 | ambiguity-resolved | boolean |
| 9 | translation-receipt | StableRef:artifact |
### 12.3 `reconstruction`

- Schema Identifier: `represented-loss-account-schema-id.reconstruction.0` — 81 bytes; checksum `65138bf63c7e6e9a2563f7af84cb79088142c1136005b9e7a3766cd208174ee0`
- Schema definition: `represented-loss-account-schema-definition.reconstruction.0` — 2429 bytes; checksum `02ab11af9e6719aae9ca2dab319c7e925b9e3c39ca439a03363a7434f21821e3`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | source-fragments | sequence<StableRef:artifact> |
| 5 | recovered-fields | sequence<Identifier> |
| 6 | unresolved-fields | sequence<Identifier> |
| 7 | reconstruction-procedure | StableRef:procedure |
| 8 | confidence-class | Identifier |
### 12.4 `compaction`

- Schema Identifier: `represented-loss-account-schema-id.compaction.0` — 77 bytes; checksum `061ee539208487deed4b50f047c2846449155b6964f826ee810ffdb029935ae1`
- Schema definition: `represented-loss-account-schema-definition.compaction.0` — 2182 bytes; checksum `324192a7c630d907713bab9921872684cffc673c535981e193d89e64c3f10471`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | removed-metadata-fields | sequence<Identifier> |
| 5 | retained-identity-fields | sequence<Identifier> |
| 6 | reversible | boolean |
| 7 | compaction-procedure | StableRef:procedure |
### 12.5 `identifier-mapping`

- Schema Identifier: `represented-loss-account-schema-id.identifier-mapping.0` — 85 bytes; checksum `2be15268d05328c4dde3a8a8df3ce783cd2441450844e98ae05099596ab8d398`
- Schema definition: `represented-loss-account-schema-definition.identifier-mapping.0` — 2364 bytes; checksum `ebc60ad73503da15e9994d5c0574b3f037b4d1f7bf32f448b0364b769cec9b80`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | source-identifier | CD/0 value |
| 5 | mapped-identifier | Identifier |
| 6 | mapping-table | StableRef:artifact |
| 7 | mapping-class | Identifier |
| 8 | candidate-count | integer |
### 12.6 `temporal-role-classification`

- Schema Identifier: `represented-loss-account-schema-id.temporal-role-classification.0` — 95 bytes; checksum `196b172bbb8d217d69ba0a4f93bba73c0b3d458907317c7f33b5d641125ee6a2`
- Schema definition: `represented-loss-account-schema-definition.temporal-role-classification.0` — 2369 bytes; checksum `09c24ab008afe0fe43791186fc62c112e336e4225c3494b22cab86293d613901`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | source-site | Identifier |
| 5 | source-value | CD/0 value |
| 6 | selected-role | Identifier |
| 7 | classification-table | StableRef:artifact |
| 8 | ambiguity-class | Identifier |
### 12.7 `handoff`

- Schema Identifier: `represented-loss-account-schema-id.handoff.0` — 74 bytes; checksum `f8e8b9446c51860e4568925c0342f5cad670d55138e003fc500d3dcb5f3dca5c`
- Schema definition: `represented-loss-account-schema-definition.handoff.0` — 2671 bytes; checksum `ed2457219a3b1023255e1ad0f53f966c6a3c96d067e340f54dc17b1f50c0e8b9`
- Optional fields: none; unknown fields fail closed recursively.

| Order | Field | Type |
| --- | --- | --- |
| 1 | kind | Identifier |
| 2 | schema-version | integer |
| 3 | account-schema | Identifier |
| 4 | predecessor-occurrence | StableRef:artifact |
| 5 | handoff-receipt | StableRef:artifact |
| 6 | live-authority-transferred | boolean |
| 7 | custody-continuity-proven | boolean |
| 8 | successor-live-warrants | integer |
| 9 | handoff-procedure | StableRef:procedure |


Each schema has a positive validation vector and a first-required-operation-field-missing negative vector. Unknown account fields and unsupported nested versions fail closed recursively. A loss account may affect admissibility or require a new identity; it does not silently alter ClaimId.

## 13. Exact-byte derivation and verification

### 13.1 Normative source

Canonical octets are derived solely from frozen CD/0: document prefix `4c50434400`, the nine fixed value families, strict UTF-8 without Unicode normalization, minimal signed/unsigned varints, and record fields ordered by complete Identifier ValueBytes. Existing implementations are verification instruments, not normative oracles.

### 13.2 Verification instruments and receipts

All 675 registry definitions plus the aggregate input and expected-output document for all 215 vectors—1,105 complete documents—were checked by:

1. the authoring Python encoder/decoder derived from the frozen grammar;
2. an independent clean-room Node.js encoder/decoder, Node `v22.16.0`, command:

   ```text
   node --max-old-space-size=4096 verify_cd0.js LCI0-FIXTURE-REGISTRY.json LCI0-FIXTURE-VECTORS.jsonl
   ```

   Result: PASS, 1,105 documents;
3. the frozen repository Python CD/0 implementation at commit `56f0ce55253ef8dd4caaf80b03e49835c4087406`, source `canonical-datum/python/cd0/__init__.py`, CPython `3.13.5`, imported through its explicit shared-fixture AST adapter, command:

   ```text
   python3 verify_frozen_python.py
   ```

   Result: PASS, 1,105 documents, including encode, exact byte comparison, byte count, SHA checksum, decode/re-encode, and abstract-value equality.

The frozen Common Lisp source is identified at the same commit and its repository command is:

```text
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
```

This authoring environment contains no SBCL, CLISP, ECL, or CCL runtime, so the new corpus was not rerun through the Common Lisp implementation. This is the sole byte-instrument limitation and is an explicit Fable authorization gate. It is not a placeholder canonical string: every string was computed and independently checked by the clean-room Node implementation and the frozen Python implementation. Fable must run the Common Lisp corpus adapter before implementation is authorized.

## 14. Vector operation contract and inventory

Every JSONL row has a unique `vector_id`, `operation`, `vector_class`, `fixture_profile_version`, exact aggregate input CD/0 bundle, exact expected CD/0 bundle, machine-readable `expected_result`, and—on failure—exact category, code, stage, and path. Explanatory prose is never the sole expected result.

The original constitutional surface is preserved without renumbering: `LCI0-P001` through `LCI0-P030` and `LCI0-N001` through `LCI0-N032` are all present. Added rows cover E1–E9, neutral/reference construction, placement consistency, nonmonotone and insufficient narrowing, F-valued hard inadmissibility, version governance, all fourteen StableRef schemes and bridges, digest/envelope distinction, migration adversaries, metadata neutrality, represented-loss accounts, all target kinds, recursive version closure, relation tables, and every LCI budget.

Vector-class counts:

| Vector class | Count |
| --- | --- |
| clarification-witness | 2 |
| errata-witness | 52 |
| metadata-neutrality | 1 |
| migration-robustness | 4 |
| negative | 93 |
| placement-consistency | 2 |
| positive | 25 |
| positive-relation-refusal | 5 |
| represented-loss-account | 7 |
| scope-relation | 6 |
| target-schema | 11 |
| temporal-relation | 7 |

Operation counts:

| Operation | Count |
| --- | --- |
| apply-admissibility-floor | 4 |
| apply-occurrence-corrections | 1 |
| apply-stable-ref-bridge | 1 |
| canonicalize-record-order | 1 |
| classify-version-governance | 5 |
| compare-bridge-source-and-target | 1 |
| compare-claim-digests-and-envelopes | 1 |
| compare-claim-id-set | 1 |
| compare-claim-ids | 6 |
| compare-corpus-completion-targets | 1 |
| compare-stable-refs | 1 |
| compare-unicode-claim-ids | 1 |
| compare-warrant-targets | 1 |
| conformance-matching | 2 |
| conformance-migration | 1 |
| conformance-normalization | 1 |
| conformance-validation | 9 |
| differential-project | 1 |
| evaluate-admissibility-under-two-policies | 1 |
| evaluate-freshness-two-query-times | 1 |
| map-migration-classification | 7 |
| match-target | 27 |
| migrate-v1 | 7 |
| migrate-v1-collision-pair | 3 |
| normalize-controlled-translation | 1 |
| normalize-preprojection-coordinate | 4 |
| normalize-proposition | 1 |
| parse-and-migrate-printer-variants | 1 |
| parse-legacy-source | 1 |
| project-claim-id | 8 |
| project-occurrence | 1 |
| project-occurrences | 4 |
| proposition-location-consistent | 2 |
| restore-live-warrant | 3 |
| revive-inert-occurrence | 1 |
| scope-relation | 7 |
| temporal-relation | 9 |
| translate-exactly | 1 |
| translate-with-represented-loss | 1 |
| validate-claim-id | 11 |
| validate-migration-result | 1 |
| validate-normalizer-conformance-evidence | 1 |
| validate-normalizer-revision | 1 |
| validate-occurrence | 1 |
| validate-pinned-fixture | 10 |
| validate-policy-evaluation-target | 1 |
| validate-profile-location | 1 |
| validate-represented-loss-account | 14 |
| validate-stable-ref | 14 |
| validate-stable-ref-scheme-selection | 14 |
| validate-warrant-target | 15 |
| witness-semantic-claim-id-equality | 1 |

## 15. Deferred semantic systems

The fixture package intentionally does not define a complete Mneme logic, a production ontology, production cryptographic identity, universal StableRef equivalence, live warrant issuance, standing, revocation, custody, capability/module authority, or production admissibility law. It provides explicit interfaces and refusal gates so the identity implementation cannot improvise those systems.

## Appendix A — Complete registry index

This index names every definition in `LCI0-FIXTURE-REGISTRY.json`. The machine record at that ID contains the full abstract value, diagnostic form, complete lowercase canonical hex, decoded value, equality class, role, version, source, validation/evolution rules, byte count, and checksum.

Registry item-class counts:

| Item class | Count |
| --- | --- |
| admissibility-decision | 13 |
| admissibility-decision-code | 12 |
| admissibility-policy | 2 |
| claim-basis | 8 |
| claim-id-envelope | 38 |
| claim-location | 24 |
| claim-occurrence | 3 |
| claim-occurrence-schema-definition | 1 |
| claim-profile | 1 |
| closed-record-schema-definition | 17 |
| dataset-slice | 4 |
| dataset-slice-calculus-definition | 1 |
| dataset-slice-expression | 4 |
| evidence-event-time | 13 |
| identity-policy | 1 |
| interpretation-frame | 5 |
| interpretation-frame-components | 5 |
| interpretation-frame-schema-definition | 1 |
| lci-failure-code-identifier | 84 |
| lci-resource-budget | 1 |
| legacy-as-of-role-table | 1 |
| legacy-fixture-grammar | 1 |
| legacy-identifier-mapping-table | 1 |
| legacy-scope-mapping-table | 1 |
| legacy-source-fixture | 12 |
| legacy-v1-record | 10 |
| migration-classification-identifier | 7 |
| migration-classification-map | 1 |
| migration-reconstruction-rules | 1 |
| migration-result | 5 |
| neutral-dataset-slice | 1 |
| neutral-interpretation-frame | 1 |
| neutral-scope | 1 |
| neutral-semantic-boundary | 1 |
| neutral-subject-time | 1 |
| normalized-proposition | 15 |
| normalizer-conformance-binding | 1 |
| normalizer-mutation-vector | 1 |
| normalizer-semantic-projection-ledger | 1 |
| normalizer-source-input | 2 |
| normative-algorithm | 2 |
| prior-ruling-migration-classification-identifier | 5 |
| profile-location | 1 |
| proposition-form-identifier | 11 |
| proposition-form-schema | 11 |
| proposition-grammar-definition | 1 |
| proposition-placement-monotonicity-table | 1 |
| relation-identifier | 18 |
| represented-loss | 3 |
| represented-loss-account | 7 |
| represented-loss-account-schema-definition | 7 |
| represented-loss-account-schema-identifier | 7 |
| resource-workload-generator-registry | 1 |
| scope | 13 |
| scope-calculus-definition | 1 |
| scope-expression | 13 |
| scope-relation-table | 1 |
| semantic-boundary | 7 |
| semantic-boundary-calculus-definition | 1 |
| semantic-boundary-expression | 7 |
| stable-ref-domain-identifier | 14 |
| stable-ref-scheme-definition | 14 |
| stable-ref-scheme-identifier | 14 |
| stable-reference-bridge-definition | 1 |
| stable-reference:artifact | 40 |
| stable-reference:dataset-slice-calculus | 1 |
| stable-reference:immutable-corpus-revision | 3 |
| stable-reference:interpretation-frame-schema | 1 |
| stable-reference:logical-corpus | 2 |
| stable-reference:model | 3 |
| stable-reference:module | 15 |
| stable-reference:policy | 4 |
| stable-reference:principal | 6 |
| stable-reference:procedure | 17 |
| stable-reference:prompt-invocation | 4 |
| stable-reference:scope-calculus | 2 |
| stable-reference:semantic-boundary-calculus | 1 |
| stable-reference:temporal-model | 2 |
| subject-time | 17 |
| target-boundaries:corpus-completion | 2 |
| target-boundaries:derived | 1 |
| target-boundaries:executed | 1 |
| target-boundaries:externally-attested | 2 |
| target-boundaries:inherited | 1 |
| target-boundaries:observed | 10 |
| target-boundaries:policy-evaluation | 1 |
| target-boundaries:replayed | 1 |
| target-boundaries:reported | 1 |
| target-boundaries:tested | 1 |
| target-boundaries:translated | 1 |
| target-kind-identifier | 11 |
| target-relation-result | 6 |
| target-schema-definition | 11 |
| temporal-expression | 17 |
| temporal-model-definition | 1 |
| temporal-relation-table | 1 |
| vector-schema-definition | 1 |
| warrant-target | 22 |
| worked-claim | 1 |

| Fixture ID | Class | Version | Bytes | SHA-256 checksum (non-semantic) | Source |
| --- | --- | --- | --- | --- | --- |
| admissibility-decision-code.accept-direct | admissibility-decision-code | 0 | 69 | 41bbdf953781fbcb2d71e3d86a21fea9ba07dbe2200ebc307feb7067bbf6e40c | Fixture Package §8 |
| admissibility-decision-code.accept-limited-testimony | admissibility-decision-code | 0 | 80 | 5b0d5f37b44dac9ee64916636c1cd2de085514e430a0c83755828975d67bc610 | Fixture Package §8 |
| admissibility-decision-code.accept-scope-narrowed | admissibility-decision-code | 0 | 77 | be2929f86dd71075439b7e8c9f5f9a6ba9d8948da9887e4b4165ebb22aa78431 | Fixture Package §8 |
| admissibility-decision-code.hard-reject-target-relation | admissibility-decision-code | 0 | 83 | 902ef67698d4bb278d1fe1cff11866724f0bfa329718f9d6f516cf23266364ed | Fixture Package §8 |
| admissibility-decision-code.reject-boundary-coherence | admissibility-decision-code | 0 | 81 | 8e2f0e3ee9fbfca4de8bad5424e070cc6aab493fb218d1bd0062df666c7b56b1 | Fixture Package §8 |
| admissibility-decision-code.reject-external-principal | admissibility-decision-code | 0 | 81 | 84da031f081df165220acdbc1805377689c092a08cddc75c70e9a8336116d0d0 | Fixture Package §8 |
| admissibility-decision-code.reject-inherited-testimony | admissibility-decision-code | 0 | 82 | 419ee117fbbe65186b2d44d9667c81d7fbcddd358610e6d50ace80eac1b5d86d | Fixture Package §8 |
| admissibility-decision-code.reject-policy-meta-as-direct-support | admissibility-decision-code | 0 | 92 | d7b1b3b099743e4714446a7b146df3c2d6b6ad44c97a9e77e6354aace466728e | Fixture Package §8 |
| admissibility-decision-code.reject-represented-loss | admissibility-decision-code | 0 | 79 | 838939e068a06a0625780fe9907e6108d1b0f84a276d467207d6db0231682ba9 | Fixture Package §8 |
| admissibility-decision-code.reject-scope-narrowing | admissibility-decision-code | 0 | 78 | 7b817f967e047e32ed2c436ab2246145c0de2846221c62c82046a1e3165b4eb5 | Fixture Package §8 |
| admissibility-decision-code.reject-stale | admissibility-decision-code | 0 | 68 | 74cba9113a434b27a3e5f0535dd294927089c039e02df03f0c9e1dddd26c99be | Fixture Package §8 |
| admissibility-decision-code.reject-target-kind | admissibility-decision-code | 0 | 74 | ea08c0e186414e762c39ad26acdb2e4f1297988c71e767a2d49bd6b35c727426 | Fixture Package §8 |
| admissibility-decision.a-coverage-hard-reject | admissibility-decision | 0 | 6195 | 36156a4e4761fde3432067901c9f38639250a235427f871bc301f87de655a236 | Errata E2; Fixture Package §8 |
| admissibility-decision.a-external-reject | admissibility-decision | 0 | 3332 | e6db34ceca64476b65a3a87d7016062ae678595b87d8da140e3572845b469727 | Fixture Package §8; LCI/0 P022 |
| admissibility-decision.a-incompatible-hard-reject | admissibility-decision | 0 | 4933 | 382470cb476bcc03686a6398cb8f15f5082068270d8ac63559be4ffd32d44d50 | Errata E2; Fixture Package §8 |
| admissibility-decision.a-nonmonotone-hard-reject | admissibility-decision | 0 | 3932 | 2ccca5bd4da325938f889bb2bbdd33d585375577485d86e139d1a2532edd7b40 | Errata E2; Fixture Package §8 |
| admissibility-decision.a-observed-fresh | admissibility-decision | 0 | 3358 | b905b8ee38202fa70cc380bcf0479569e7ff3b1044f4a5ff5d5de28a8a52706e | Fixture Package §8 |
| admissibility-decision.a-observed-stale | admissibility-decision | 0 | 3368 | df9d487fc09119b95d9966cdf731db715e2f7dbbdd88065642e071c7cd3a1fb2 | Fixture Package §8 |
| admissibility-decision.a-relation-unknown-hard-reject | admissibility-decision | 0 | 4326 | f317e135e2fb4700438b28ae98a6f01ac7f3825521cdb1b056925ec3e9af0a07 | Errata E2; Fixture Package §8 |
| admissibility-decision.b-coverage-hard-reject | admissibility-decision | 0 | 6195 | 10744a1f35cce4787f5f00ef1adb62fb212dc3818844f8c28ab7ef53a19dd750 | Errata E2; Fixture Package §8 |
| admissibility-decision.b-external-trusted | admissibility-decision | 0 | 3445 | 340f70fcb93fc6afd31c3bda668c619f8a8e1ddd8779f30e4dd5b9cee467295e | Fixture Package §8 |
| admissibility-decision.b-incompatible-hard-reject | admissibility-decision | 0 | 4933 | 2f9b6cf225b43d5838f1bc200d02767ef7e93447bfba331b3ae6cd2f3c2010a5 | Errata E2; Fixture Package §8 |
| admissibility-decision.b-inherited-limited | admissibility-decision | 0 | 3406 | 73a32bec3a984f83b263b226cecb5d1d3be28cb31419a68110aeb8a3c7e7d9ad | Fixture Package §8; Errata I12(e) |
| admissibility-decision.b-nonmonotone-hard-reject | admissibility-decision | 0 | 3932 | 34a3e27e880118af4c575f2faa0058b80b8800421542aaf357a2fb19b7306cf1 | Errata E2; Fixture Package §8 |
| admissibility-decision.b-relation-unknown-hard-reject | admissibility-decision | 0 | 4326 | 459adc0265fc6903ae26816f8b55449a8a9176a7f45354faeabe3c797ddab0de | Errata E2; Fixture Package §8 |
| admissibility-policy.a.0 | admissibility-policy | 0 | 8128 | 467561cb0c91e644761006dac047dac7efde77840d49ec12bf113704256f6373 | Fixture Package §8; Errata E2 |
| admissibility-policy.b.0 | admissibility-policy | 0 | 8782 | 0e04628c6bf3f8361ca1f8f61b7ffe9288e17e056f4fada097f8f8f2f39ecc6f | Fixture Package §8; Errata E2/I12(b) |
| algorithm.preprojection-normalization.0 | normative-algorithm | 0 | 1294 | e38d6850c66d3842f23ea6d5134e6eeda2be3748778ed1b6e4e91d1b13c201fa | Errata E4 |
| algorithm.validation-precedence.0 | normative-algorithm | 0 | 1477 | 8ebcb686b677e2c822bc71937325efeeea3ed1a66a8e158eefbfac2c631763ec | Errata E6; LCI/0 §18.9 |
| boundary-expression.log-horizon-124 | semantic-boundary-expression | 0 | 1144 | fe366fd315437c1aeec9afb869ed45ea40031d19d6211bbb7ffb6718f1d004c8 | Errata E1/E4; Fixture Package §4 |
| boundary-expression.log-horizon-130 | semantic-boundary-expression | 0 | 1144 | 8a0fd7294c22eb2fd7ed2d484e95ce79f0b47eed030657e48f2e550d1479207f | Errata E1/E4; Fixture Package §4 |
| boundary-expression.manifest-alpha-3 | semantic-boundary-expression | 0 | 837 | 0fdb85751d7e0d6c20a7842a22da23a5507b0e3c3f9999597b08d49bc4b54594 | Errata E1/E4; Fixture Package §4 |
| boundary-expression.manifest-alpha-4 | semantic-boundary-expression | 0 | 837 | 223b708a6f078fc533d3a6e4e4066590c98048cd2769687383de7e09db2d1fd7 | Errata E1/E4; Fixture Package §4 |
| boundary-expression.not-applicable | semantic-boundary-expression | 0 | 249 | 9656571e29d5b599d4480e1a425970125903c61d7d1eb46936e112f2a65f013f | Errata E1/E4; Fixture Package §4 |
| boundary-expression.path-root-docs | semantic-boundary-expression | 0 | 410 | e3c9e6f5df9ae9cc0b231e4d9cbd3897795a97fd38c21acfe1b76025d670306d | Errata E1/E4; Fixture Package §4 |
| boundary-expression.path-root-src | semantic-boundary-expression | 0 | 409 | 7c7134dc6c6c91b3df6312add7bd00f3b496795dcbe82366c0dcb699b364cbf9 | Errata E1/E4; Fixture Package §4 |
| boundary.calculus.primary.definition.0 | semantic-boundary-calculus-definition | 0 | 1499 | 65af133cbd97ca0a9553107701b631d9f4c02b9636afcab130e995aba0d3c5c8 | Fixture Package §4 |
| claim-basis.alpha-r3-all-manifest3 | claim-basis | 0 | 4005 | 3df44078a4691f8ad2665cb14e67d45622970c241ac1478e2181cb219dbb4600 | Fixture Package §4 |
| claim-basis.alpha-r4-all-log124 | claim-basis | 0 | 4312 | d138c1e617b89d7f3c88cf296da300669f5c927473bda34593963cf5cd70cd7b | Fixture Package §4 |
| claim-basis.alpha-r4-all-log130 | claim-basis | 0 | 4312 | 05214dcade9f022aa7861c813ddb120249d653b7506122a5b54a73ba32c15cf6 | Fixture Package §4 |
| claim-basis.alpha-r4-all-manifest4 | claim-basis | 0 | 4005 | 94a8eaf3be341f899000602ce491bd2c287a016e456ee4e1d14af4731522bb2d | Fixture Package §4 |
| claim-basis.alpha-r4-all-path-docs | claim-basis | 0 | 3578 | 5592f09d45b50f88899feab84b06e2d932839bf2e9892ebc072a5629334d82dd | Fixture Package §4 |
| claim-basis.alpha-r4-all-path-src | claim-basis | 0 | 3577 | 7b508b6f63d0a9ac967f46918bbc5839a8e8ac41a95f685820a7984873835cd5 | Fixture Package §4 |
| claim-basis.alpha-r4-file-alpha-manifest4 | claim-basis | 0 | 4594 | 6b935c7f738422b8aeb49c894c833372097a9e32ec28749f152c0578d4001baa | Fixture Package §4 |
| claim-id.absence-r4-docs | claim-id-envelope | 0 | 13033 | d55303aaa1cd27c5af222bcf8e2c8b3e6d9065abafbf0e4bdb222f449af4f866 | LCI/0 §§7–8; Fixture Package |
| claim-id.absence-r4-log124 | claim-id-envelope | 0 | 13806 | da98f9192844a9219e56fb9c692e2d0c1743185cb41b7e9ff050ae43e29fc131 | LCI/0 §§7–8; Fixture Package |
| claim-id.absence-r4-log130 | claim-id-envelope | 0 | 13806 | d3779f512ddc1503e9c87229f1869f30ceb195c07198d458d8d65bb58267fac5 | LCI/0 §§7–8; Fixture Package |
| claim-id.absence-r4-src | claim-id-envelope | 0 | 13032 | 96746268d9cafbf5d00b3f73edfaf1afa2dd99132bb3789364c2f2e84da6d94a | LCI/0 §§7–8; Fixture Package |
| claim-id.all-devices-encrypted-dept | claim-id-envelope | 0 | 8195 | ae53dd35d4366604561b2889fc2366a686d55234781d133971ed81f3b43dec62 | LCI/0 §§7–8; Fixture Package |
| claim-id.all-devices-encrypted-org | claim-id-envelope | 0 | 8093 | 425439f286dbae287fa39d0af1725619c57cbc1daf66c26017c095a9654cb055 | LCI/0 §§7–8; Fixture Package |
| claim-id.artifact-alpha-says-ready | claim-id-envelope | 0 | 8855 | b428c400610ec5c42b1cb6f133b84780f868500825886f9cf0074b49211cf550 | LCI/0 §§7–8; Fixture Package |
| claim-id.average-latency-dept | claim-id-envelope | 0 | 9089 | 46a049437e3f03a607dd1ea1cd9e4b669681bb6c89426a21ee36ed8f39c832ab | LCI/0 §§7–8; Fixture Package |
| claim-id.average-latency-org | claim-id-envelope | 0 | 8987 | 07de7c47eeabad715526110d2e73b8505315d1c6d7e3c8dae78cb7588e6e7d53 | LCI/0 §§7–8; Fixture Package |
| claim-id.call-17-returns-42 | claim-id-envelope | 0 | 9302 | bf05d80c8e0ee9e6206b5c135deffa2c5c2e0e9aee22c9a4fbf21728d2ea2c05 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-animal | claim-id-envelope | 0 | 9414 | b0ca633d243030223763f9566b2edcb5ad57f2d40be88104d48e08bc98d7a3f4 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-animal-imperial | claim-id-envelope | 0 | 9420 | 8a6280b2713e22bb12d2c2f4947f03dfd7b22b4a6789db893099ce0c04c7ba35 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-animal-schema-v2 | claim-id-envelope | 0 | 9414 | ffe637c172f1516b894d7601f94b8ae781e017250dbad13e95df2c46ca770327 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-corpus-r3 | claim-id-envelope | 0 | 12220 | a306ef38dc7761d27be7012acce7639beef4fad98156415ef595a00311c9d052 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-corpus-r4 | claim-id-envelope | 0 | 12220 | c53cf7a722f097f081a25fd3c9997946f976835d7aea44c0de9d83a7df917c24 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-corpus-r4-slice | claim-id-envelope | 0 | 12809 | c15e111dbb9c7022be57629325081959beb55262443de0eeeab008846a5b6740 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-dept | claim-id-envelope | 0 | 8650 | 51364b38f7767c08523bb684b6b258f6aa5d254686ad23035519c7e1d2a0fa38 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-neutral | claim-id-envelope | 0 | 8402 | 08be9d7b92f13a5b014866e085ff4375f44a6fd71672a36ae573e36e8e77e90b | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-org | claim-id-envelope | 0 | 8548 | d0034eb566fadebf7e92b4089e612259d7c1b6bac75bec86efa8bab61afb33bb | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-region-x | claim-id-envelope | 0 | 8590 | 13ca6468ccbdb330eb3f519626552b0fc53ff6d603853658b7ede9afa460c4c7 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-region-y | claim-id-envelope | 0 | 8590 | 026a2e88ac6ab6f4c36fb4047e320596fa93890dca4d2d073248e93da2ae49c2 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-tenant-a | claim-id-envelope | 0 | 8631 | faf491dff05dffc1f74f965ca09e756977b611fc94a72601dfd82938fee8184f | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-tenant-b | claim-id-envelope | 0 | 8631 | ec064f170874f4cb83882dde87c0734fd2e2415683bcf94b76f4145e4e8b9b0e | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-today | claim-id-envelope | 0 | 8441 | 3edcebb8aebb6bc50991f7ac3748073d8471687446602956daf8735732926a22 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-vehicle | claim-id-envelope | 0 | 9415 | 4f9e03ac5ecef4b37ccfb11a3bdd2056364af335d3d7aae2aee549aa7b54f3a0 | LCI/0 §§7–8; Fixture Package |
| claim-id.file-alpha-yesterday | claim-id-envelope | 0 | 8441 | 7da341492de1746dd30a19ed0eaa34c4d8765c3209c387a59ed8ee5dde8b6f6e | LCI/0 §§7–8; Fixture Package |
| claim-id.file-beta-neutral | claim-id-envelope | 0 | 8401 | a344a7c4dc78596e026d7fd19b6bb8b6137ad2a46b2a832dc70a2da9184feeb6 | LCI/0 §§7–8; Fixture Package |
| claim-id.migration-corpus-r4 | claim-id-envelope | 0 | 12449 | c88c7b0e1169544a9f9e59fe6d235d760cdfd2d47a76153e0599352009b2b700 | LCI/0 §§7–8; Fixture Package |
| claim-id.migration-scope-tenant-b | claim-id-envelope | 0 | 12449 | 20218282f1504b8399139d185beae1b71b34d9192008e875b5a885e20de98f17 | LCI/0 §§7–8; Fixture Package |
| claim-id.migration-time-100 | claim-id-envelope | 0 | 12449 | 70938ec5208b6cb92065d38ee9103f37acd38280167703d9a9aff8e1e8502221 | LCI/0 §§7–8; Fixture Package |
| claim-id.migration-time-124 | claim-id-envelope | 0 | 12449 | abefdcc41323e9aaa1f7974c21d0e7b27a8ddf658fd56ea479c297de46f6c563 | LCI/0 §§7–8; Fixture Package |
| claim-id.model-alpha-returned-yes | claim-id-envelope | 0 | 9854 | 588b5768677470617775b4b9ef05f01d4d59d8e1373ea5878ef129367ed7fbba | LCI/0 §§7–8; Fixture Package |
| claim-id.one-equals-one-neutral | claim-id-envelope | 0 | 8297 | 15d40baab74591fb2ddc50932157b478527dfffc48fcb847158e0792ebea9398 | LCI/0 §§7–8; Fixture Package |
| claim-id.one-equals-two-neutral | claim-id-envelope | 0 | 8297 | 6325a11a866970828fd481b2b2ee9959675d8a2ca4c2f5b3231186e8b141f7ed | LCI/0 §§7–8; Fixture Package |
| claim-id.probability-file-alpha | claim-id-envelope | 0 | 13613 | e04cb8086d20702efad75dfd630e698f10afedd2ff64b5f387186ee928190797 | LCI/0 §§7–8; Fixture Package |
| claim-id.translation-bank-ambiguous | claim-id-envelope | 0 | 9803 | abff9adf5d212f163f9993c6f56e832d98c00068a94a93320666cb1221b0018b | LCI/0 §§7–8; Fixture Package |
| claim-id.unicode-nfc | claim-id-envelope | 0 | 8852 | 9a971c4d4c047a97942688975aaf114113ed33679da45a047ce66c284a46eabf | LCI/0 §§7–8; Fixture Package |
| claim-id.unicode-nfd | claim-id-envelope | 0 | 8853 | 4fb292c1e87f5f687cadec414add693400ab34190bdeb6d9e304c686a325e4a5 | LCI/0 §§7–8; Fixture Package |
| claim-location.alpha-r3-neutral | claim-location | 0 | 6888 | e28feba8a6ea975a30af6e449c26b7a269e1bb5c9ad80c2d9df295d19cd4d373 | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-file-alpha-neutral | claim-location | 0 | 7477 | f7207e89d4e80e90003ca3a285757501ae0a2edd9ac961a75a5bfc923b8db0bd | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-log124-neutral | claim-location | 0 | 7234 | 4b09ce6ccced45ee3435e35937c9d7534d3050691ae6f6bbb85e1bcc637168bb | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-log130-neutral | claim-location | 0 | 7234 | 47c4aa764799f323d547decefaa6ed7783f89816082fb88699156bf7dfa08afb | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-neutral | claim-location | 0 | 6888 | 2a353e6242af80aa279c6209cad243b5c3a54d9246121a2be149084165dc1606 | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-path-docs-neutral | claim-location | 0 | 6461 | 674cefd407380b1bb0d89207fb44a84dfd4b9b984d4f08fb8424f3e354de322f | LCI/0 §7.10; Fixture Package |
| claim-location.alpha-r4-path-src-neutral | claim-location | 0 | 6460 | e5c1294e5c8de60e273bc0d01a5298f9f910ca536bfc73a35679ef63fc699002 | LCI/0 §7.10; Fixture Package |
| claim-location.dept-research-t124-world-neutral | claim-location | 0 | 3318 | 5a0af09c18ddfd1b671d193d40c8d2d9a67cb7148bf5e99b175d5e16e8d0130e | LCI/0 §7.10; Fixture Package |
| claim-location.neutral | claim-location | 0 | 3070 | c57e27142dd944b94b9bf68f167e3b862e6b39b2d2e31e63e64033314ceff01d | LCI/0 §7.10; Fixture Package |
| claim-location.neutral-animal-imperial-v1 | claim-location | 0 | 4088 | 528b0c3e2286aad610eaf5c5c054f4cd30a38e8ae2032d33bb65026e97d266d6 | LCI/0 §7.10; Fixture Package |
| claim-location.neutral-animal-si-v1 | claim-location | 0 | 4082 | 395c14900417316a4372a93da6241cfe0ce776a429efb6287750b0a306b8ef64 | LCI/0 §7.10; Fixture Package |
| claim-location.neutral-animal-si-v2 | claim-location | 0 | 4082 | 0d4806d42a2583df71498a87a2a5cd55da5bc8c712c59d0d81b903d0b043f199 | LCI/0 §7.10; Fixture Package |
| claim-location.neutral-vehicle-si-v1 | claim-location | 0 | 4083 | 2dbf094ba61d8985b583af1205a722619258e0a22bc88ebcd7793d83f530247c | LCI/0 §7.10; Fixture Package |
| claim-location.org-acme-t124-world-neutral | claim-location | 0 | 3216 | 26f4e74d2c20b9362de97afe59cb44d6fac78b6f6422dd81c4f2ec3bdf351734 | LCI/0 §7.10; Fixture Package |
| claim-location.region-x-t124-world-neutral | claim-location | 0 | 3258 | 5c08def6af3237e6b5c24bf2414de70f918796fbc29f937fc7fb04976ddbddb5 | LCI/0 §7.10; Fixture Package |
| claim-location.region-y-t124-world-neutral | claim-location | 0 | 3258 | f9f69c67c99fce8c7ff8a23897514a7670f155feefbe8bead32f179ba840bb7f | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-a-t100-alpha-r3-neutral | claim-location | 0 | 7117 | a28dc98ad4cd63330ab2c2c57ff445372f287dfa92b297ed51e32fe92cb231e3 | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-a-t100-alpha-r4-neutral | claim-location | 0 | 7117 | ae6a0b728b0617c8ae4ac6404799d59b41f79800d9f129156abdd5e32a12f827 | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-a-t124-alpha-r3-neutral | claim-location | 0 | 7117 | 342db9089160c9da01ebd12167c40c720b5003115ed1e8503ed76c01e152af7d | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-a-t124-world-neutral | claim-location | 0 | 3299 | 5056552915290cfe39ab05db35779940883382cc1f788054da7f4dd9fea49f04 | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-b-t100-alpha-r3-neutral | claim-location | 0 | 7117 | e5a0de16597e07afb6522d922969a666c00f50e55416a40b61530b68583b6cd4 | LCI/0 §7.10; Fixture Package |
| claim-location.tenant-b-t124-world-neutral | claim-location | 0 | 3299 | 46dc450a4c924ed269b9013abc1067c109fdab1c3996c49ec7c1bbc1a303875d | LCI/0 §7.10; Fixture Package |
| claim-location.universal-t100-world-neutral | claim-location | 0 | 3109 | 9d03dbe5ce057b6cf241cdbefd96f48155cc78c15d477fc7ce4937f824aa1d06 | LCI/0 §7.10; Fixture Package |
| claim-location.universal-t124-world-neutral | claim-location | 0 | 3109 | e408782c00d5a3711732d8a7cbba02c9b926d387c9fd5c61fe88916ff40a0a7f | LCI/0 §7.10; Fixture Package |
| claim-occurrence.alpha | claim-occurrence | 0 | 20477 | fd61503c224ba21ae7e8334aeaef02529205ff69667943c1796056f61e38791f | Fixture Package §11; LCI/0 §17.4 |
| claim-occurrence.beta-metadata-different | claim-occurrence | 0 | 21360 | b9a1877ce6cebe014aeeefb40936c15d5d1f02da6bf93e58e428c7a70e1f11a7 | Fixture Package §11; LCI/0 §17.4 |
| claim-occurrence.proposition-corrected | claim-occurrence | 0 | 21259 | a191cda457ceb2dfe71cfb34cd566db8991c8cf18bbdcd9d519457aea9b6644d | Fixture Package §11; LCI/0 Scenario 20 |
| claim-occurrence.schema-definition.0 | claim-occurrence-schema-definition | 0 | 1091 | 4f88a477d344d64ad84c437f94d276e4c65d2deee18c3ef12c1164e6cc089e7e | Fixture Package §11 |
| closed-schema.claim-id-envelope.0 | closed-record-schema-definition | 0 | 2213 | 8f270364d5cc369f85ec5d5da0deb8de894aea06b4d6d2724658023ee6280aa8 | LCI/0 §§7.9–8; Errata E3/E4 |
| closed-schema.claim-location.0 | closed-record-schema-definition | 0 | 2160 | c6c3a2dac7e58935f6411d25225a12b585e11aefc797d114beb4885b3ea5ecac | LCI/0 §§7.5–7.8; Errata E4/I05 |
| closed-schema.claim-occurrence.0 | closed-record-schema-definition | 0 | 3246 | 8f6bd8305a64b46406d88ab007b17a15a52aead01a6de425946f3fd164f91b4d | Fixture Package §11 |
| closed-schema.claim-profile.0 | closed-record-schema-definition | 0 | 1512 | a7cd9fb2de40eb81e986a4e2cf1f26d465b9f18831eb699b1588ee784cf6cd46 | LCI/0 §§7.4,19; Errata E3 |
| closed-schema.corpus-basis.0 | closed-record-schema-definition | 0 | 2430 | 189fbb4a81de03cd4836a36b826557d547a5bef081a6b550ccefc5c7f24c627a | LCI/0 §7.7; Fixture Package §4 |
| closed-schema.dataset-slice.0 | closed-record-schema-definition | 0 | 1745 | 38b109204de5e2c61d4790b61c1ba48e470a75f277b88ec4ae2a7b240458bf56 | LCI/0 §14.5; Errata E1/E4/E7 |
| closed-schema.identity-policy.0 | closed-record-schema-definition | 0 | 1445 | fb756d3ea0d0fd94e58f4569dfacb27c964f637be0b5c4c8f9c178377ad7c1a8 | LCI/0 §§7.4,19; Errata E3 |
| closed-schema.interpretation-frame.0 | closed-record-schema-definition | 0 | 1786 | 57db8181e6d46d7179e513cf02b641b463f59e4d5429ebd58848c5839740f3bd | LCI/0 §13; Errata E1/E4/E7 |
| closed-schema.lci-failure.0 | closed-record-schema-definition | 0 | 2304 | de12a5419e554fcc2afac98b0fc0d8539a0a48b09dbc2843dc05ea342ce2bb49 | LCI/0 §18; Errata E5/E6/I12(c) |
| closed-schema.profile-location.0 | closed-record-schema-definition | 0 | 1480 | a338e6c6178adb23b66790b4f7a4a35079efcd22cb86d2c88d4ee101633b6730 | LCI/0 §7.8; Errata I12(a) |
| closed-schema.represented-loss.0 | closed-record-schema-definition | 0 | 2430 | 9d3f7b09b0e8b49fd59a86754dd612dc295b0ad27747aa843af36e0ebdfdfec4 | LCI/0 §16; Fixture Package §12 |
| closed-schema.scope.0 | closed-record-schema-definition | 0 | 1714 | 4a2279d78de9ccbd81c9edae24c50e5eed7e6564003d6fdc9adb7da559379b6c | LCI/0 §11; Errata E1/E4/E7 |
| closed-schema.semantic-boundary.0 | closed-record-schema-definition | 0 | 1764 | 728f72e5c84235d63c151959845964e0f218fccb55c5a6ca8027ed70aaff1e28 | LCI/0 §14.5; Errata E1/E4/E7 |
| closed-schema.stable-ref.0 | closed-record-schema-definition | 0 | 1699 | e92c12f22ab99fdfb33b3b2d4ae070b05b142280816905a43512df0336fb92d4 | LCI/0 §14; Fixture Package §6 |
| closed-schema.subject-time.0 | closed-record-schema-definition | 0 | 1732 | a19e8b01cf6da92a39db8af33b2699e06f4249154a2121a69084e8f79460885f | LCI/0 §12; Errata E1/E4/E7 |
| closed-schema.warrant-target-envelope.0 | closed-record-schema-definition | 0 | 2195 | d1bea79d3bd9279a63a1e639f5e2bfe3383cb29dd189a6959ae82f9157dc30c8 | LCI/0 §§9–10; Fixture Package §7 |
| closed-schema.world-basis.0 | closed-record-schema-definition | 0 | 1645 | 4bc88e480ebe374fa935999cf8b4395652f2dfcd2d253b7bec0f2599608ec265 | LCI/0 §7.7 |
| dataset-slice.all-members | dataset-slice | 0 | 984 | a07f5910a8c8eaf11737a6f96bf8e3ee7474dac9b7adb51419b2191d1eb06baa | Errata E1/E4; Fixture Package §4 |
| dataset-slice.file-alpha-only | dataset-slice | 0 | 1573 | 604ece4753b557d8c435c1a4496a333339aa6dbd4734e91ff49e2e2fe671a6a1 | Errata E1/E4; Fixture Package §4 |
| dataset-slice.files-alpha-beta | dataset-slice | 0 | 2113 | 8b0dc868d23571609976ab4bc158b715c7e146f6613758f451688c6d32271797 | Errata E1/E4; Fixture Package §4 |
| dataset-slice.predicate-file-prefix | dataset-slice | 0 | 1794 | caa18ffc0c5bdb698ab1a587ed0620e7ec06cef1d1b3a125e648910397b83504 | Errata E1/E4; Fixture Package §4 |
| domain.artifact | stable-ref-domain-identifier | 0 | 48 | ec83e54d6c9efd00df58c5bff79a632919dbe7c10fb9bbdcd001ba843c99714d | Errata E7; Fixture Package §6 |
| domain.dataset-slice-calculus | stable-ref-domain-identifier | 0 | 62 | 3b2c2e71a2f11be950a81cd812e7fd874212b6367eb59f3224105065879954f8 | Errata E7; Fixture Package §6 |
| domain.immutable-corpus-revision | stable-ref-domain-identifier | 0 | 65 | 24cfd870ba23627931728f3b4b2774b5dc6a0eff9cba4fe619ce6e4cce5c861c | Errata E7; Fixture Package §6 |
| domain.interpretation-frame-schema | stable-ref-domain-identifier | 0 | 67 | dd22dfcba09b98d625bbd390a4a48259796b5efb7df4b02c9c333ae95dfcba5f | Errata E7; Fixture Package §6 |
| domain.logical-corpus | stable-ref-domain-identifier | 0 | 54 | 0830ba382ee13267d52e430c91c8acea1e22142c514d82de500ea9663455df15 | Errata E7; Fixture Package §6 |
| domain.model | stable-ref-domain-identifier | 0 | 45 | f5e621cf94f25b68c298a7139a562d7f9d6fb0c1fcca012d5b2ebb8ba746c857 | Errata E7; Fixture Package §6 |
| domain.module | stable-ref-domain-identifier | 0 | 46 | b13c79a4132ab9d8fc713c9cf393c1457635afb5a91dd9def74bf43b6fd09146 | Errata E7; Fixture Package §6 |
| domain.policy | stable-ref-domain-identifier | 0 | 46 | 2ea5ff1c9a141d2d15704c11a419fd17a4892ba7a459b050244dcfb5dac56f4c | Errata E7; Fixture Package §6 |
| domain.principal | stable-ref-domain-identifier | 0 | 49 | 3d64a88bdefbe3d170ab92add8579e664b7792de35ae73f95c2ee5ee4fb8136c | Errata E7; Fixture Package §6 |
| domain.procedure | stable-ref-domain-identifier | 0 | 49 | 5fff7ca2cc6417c40ea7db1ace25e36ecc076ef108c3690f35e60ed4d986a6e7 | Errata E7; Fixture Package §6 |
| domain.prompt-invocation | stable-ref-domain-identifier | 0 | 57 | df835e5c0dc0bd902e402b3cacaccc5c109094386e8d310b76886a51442c433e | Errata E7; Fixture Package §6 |
| domain.scope-calculus | stable-ref-domain-identifier | 0 | 54 | f4d5947fa0715e7789db7d1633c0bd0bfbe81535174b5ad67741abfd4d56a4ce | Errata E7; Fixture Package §6 |
| domain.semantic-boundary-calculus | stable-ref-domain-identifier | 0 | 66 | c290fcee78e23df110705dd8733d0a8f1898d146dde8ace66eaaf1f40120be0a | Errata E7; Fixture Package §6 |
| domain.temporal-model | stable-ref-domain-identifier | 0 | 54 | 193b76116618050dddac793a8f3313e2a16b30d3e7b25cefa38bff2436716eac | Errata E7; Fixture Package §6 |
| event-time.assertion-124 | evidence-event-time | 0 | 1173 | 85903810fd424f3d4f91ec348a972240d7653b470a5da437384d2a4bb6fa80a9 | Fixture Package §11 |
| event-time.assertion-130 | evidence-event-time | 0 | 1173 | 21f61d1f603a97d15f4d1dbd73b888de39043a5874cd7ec0392b5619c7988b95 | Fixture Package §11 |
| event-time.attestation-124 | evidence-event-time | 0 | 1175 | 839225f7218256ed9995ec316557287129d8e1a970889fa043ee6af9c3cc1890 | Fixture Package §§3,7,8 |
| event-time.execution-124 | evidence-event-time | 0 | 1173 | cc14f702922772371db9e723f32188178d44102bd77040045be67a32dc41e27d | Fixture Package §§3,7,8 |
| event-time.observation-100 | evidence-event-time | 0 | 1175 | c95ab4291bd9807282f1e2cd71586d799584c292a21c0168fc1fa68645c0d22a | Fixture Package §§3,7,8 |
| event-time.observation-124 | evidence-event-time | 0 | 1175 | 77ae950c30003580e84624c92a2edf35ec3d6166fa5fa22bdc191a1bb3d3f286 | Fixture Package §§3,7,8 |
| event-time.observation-300 | evidence-event-time | 0 | 1175 | 83e791625641514ec03dc8cf24ad68d546ef790d35930bffd088132b859efded | Fixture Package §§3,7,8 |
| event-time.query-124 | evidence-event-time | 0 | 1176 | 1294ddd76d0d2ff57fee76b6c4a1b0c7e95ea6e4f6ec7c26fbdcb853ef8ee7a9 | Fixture Package §§3,7,8 |
| event-time.query-300 | evidence-event-time | 0 | 1176 | 32cffda7dd2cbe2d99c90a2748d0eaf94944f0249fc6140e8b1f4f719c692d4b | Fixture Package §§3,7,8 |
| event-time.replay-124 | evidence-event-time | 0 | 1170 | 03e5861b8cfac0258923243dffd2e68f624c89ce00ab51f827391b08e31cf8b9 | Fixture Package §§3,7,8 |
| event-time.report-124 | evidence-event-time | 0 | 1170 | 2299324f3dcf8a0eb425bbd32bf2395ccbb9ef075a82977a0a66f041eeba8d77 | Fixture Package §§3,7,8 |
| event-time.search-124 | evidence-event-time | 0 | 1180 | 0c8f9c39503e95c203401c02c36fb56e7f98eb4374a6bf44aeacece116bdf956 | Fixture Package §§3,7,8 |
| event-time.test-124 | evidence-event-time | 0 | 1178 | 233770d8de4d9e20f3b06585e816a13340aa1d140a2f3f20892ef943a5e8096e | Fixture Package §§3,7,8 |
| failure-code.AdmissibilityUndetermined | lci-failure-code-identifier | 0 | 58 | bbdfbe7654dbedc91439bf71bb7bb3519e138cd63b87f1516094873a2e3097d8 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.AmbiguousIdentifier | lci-failure-code-identifier | 0 | 52 | aaf00367ff0aea9101bf52b6a09e88f5cd8fce791894a622dc0f44282f575dac | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.BasisMismatch | lci-failure-code-identifier | 0 | 46 | b9c17f9687f5ea8a1e70622a2f82aebdd1ce57807a9c88d348ad5fa1aadfffb1 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ClaimIdCacheMismatch | lci-failure-code-identifier | 0 | 53 | cdf21bbbe0b0f0e46c0bfe3fd6cdcd5d6872d6e839f1e6a7c4b03ec744ba9d25 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ClaimProfileMismatch | lci-failure-code-identifier | 0 | 53 | 45de053b5e3c900c4091eb089184b38e1a1fd4b72f20591277a2d550ac69a947 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ClaimTargetMismatch | lci-failure-code-identifier | 0 | 52 | 3f779ee9b6c7bc42de94210bfd8ee49ee891e6ced0f3d343b604fb28828f44dd | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.CorpusCompletionInsufficient | lci-failure-code-identifier | 0 | 61 | 1d1f99290ff05411b4cadc30d5896a7f0a2e3950e3253d2d646d9808cd257d76 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.CorpusRevisionIdentityInsufficient | lci-failure-code-identifier | 0 | 67 | 0473e0da9f9402b930dd3d9cf62c264511a1c102df21025e951fb0f6ee308035 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.IdentityBearingLoss | lci-failure-code-identifier | 0 | 52 | 45478f5923467c95e7d27df258055ee8fa9b432c04db4a0b42556903f65ceedc | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.IdentityPolicyMismatch | lci-failure-code-identifier | 0 | 55 | 78cd262b078f29529efa4e1a17d93098ab37f8bfb9096464f37c03f031e5197b | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InterpretationFrameMismatch | lci-failure-code-identifier | 0 | 60 | b8f6442fa019e874ee895241676b4f8f61e7dcd98ab35dd477520d7292d8acd5 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidBasis | lci-failure-code-identifier | 0 | 45 | 9cdb3c8db42512a9300ead800af3a275db2f82b2db986f25c728f77410c5ddda | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidClaimLocation | lci-failure-code-identifier | 0 | 53 | 86f21de50d4220427a3fe6dd4125e24c90e7fc4edf0131db0b7696f5ca4b8e11 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidClaimRecord | lci-failure-code-identifier | 0 | 51 | 04dbea8e58ed9e97027f0a247c628564dc18b410240f1d7e715044b8f6c2780f | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidInterpretationFrame | lci-failure-code-identifier | 0 | 59 | 7b11c12811c6679e7cf48282b2972d9e61402c4b8160ffd11a7dbad3cc461be4 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidProposition | lci-failure-code-identifier | 0 | 51 | 8be96037a4a6a47e31eb156ce9a49b2245db5911c6e39f98259ae8819d5e1c1e | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidScope | lci-failure-code-identifier | 0 | 45 | 8925dd0f93ff72a60433b235506c20994c10abc74a94ac5274269351e29ec4f4 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidStableReference | lci-failure-code-identifier | 0 | 55 | aceabbb9b5975130224551888f503c63ffd922bbf59c2322e98c5b340c39e27c | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidSubjectTime | lci-failure-code-identifier | 0 | 51 | 8d2beb620faac4d53211df3e4d7238f4bc764aa40bfe207c3495497e1215e7ad | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.InvalidWarrantTarget | lci-failure-code-identifier | 0 | 53 | 933e32b0bd84afcbee06aae8a2a03543369b17f14b24d454d21fd8f3e4ff36ce | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCIAggregatePayloadBudgetExceeded | lci-failure-code-identifier | 0 | 66 | b183982384674e0c0ef03992b529f16dae75fc2023994c3ae4839e732bde696b | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCIIdentifierSegmentBudgetExceeded | lci-failure-code-identifier | 0 | 67 | 001c859fe2be8065c8cb04bd416318081c232b054a9b4978329813fb68c207f9 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCIMaxNestingExceeded | lci-failure-code-identifier | 0 | 54 | 0b22e9cd677f4921a9f8128268465e3f8593ffeadca42d9d08167cdcd79c9cfb | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCINodeCountExceeded | lci-failure-code-identifier | 0 | 53 | 2f43b792d6baaa8c00986726a3531e50002cf4ec4683539dbd62a87735da326a | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCIRecordFieldBudgetExceeded | lci-failure-code-identifier | 0 | 61 | c3419a8adf928ba750af845a069e62df673a10d304f0aac1be2ac04cd5731680 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LCISequenceLengthBudgetExceeded | lci-failure-code-identifier | 0 | 64 | 46852e8fb987e82009aaccea111af18aa0215c35054186940fc92853454d0b40 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LegacyFingerprintNotClaimId | lci-failure-code-identifier | 0 | 60 | c61c779125504a9339f10de0618696d1f1ecff569813615f5c5b38f8c369cbf8 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LegacyWarrantInert | lci-failure-code-identifier | 0 | 51 | 56c428835ca84177bcee159de792d74f445f5807205cd4492bd28bbe25d6486d | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.LineageUnverified | lci-failure-code-identifier | 0 | 50 | 2400c3e829aaaa121dd94da36672b82570e8eec7c4db44e8fda1dd7233803a62 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.MeaningChangingNormalizerVersionReuse | lci-failure-code-identifier | 0 | 70 | 322755efc81381637c07a6615d3399797816dfdaeb570939f4bec3baa060d772 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.MigrationInputSizeExceeded | lci-failure-code-identifier | 0 | 59 | 569f54e69e19ced151db022cf2372fac69036648141bc080f7f74398dbe5c687 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.MissingRequiredField | lci-failure-code-identifier | 0 | 53 | ed1118bdd2b44100f0ec01f4610c4860645d61ade90b0ed79dee4857529f21a6 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.MutableReference | lci-failure-code-identifier | 0 | 49 | 49cf6f2f37c9c747563d16e9f2033ac5d9885fc91ea7123c741806dddfc2df0b | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.NormalizerContentIdentityMismatch | lci-failure-code-identifier | 0 | 66 | 0983e18ff6e4258cbceb70db276db6740ab432f4e4f2ef2426c66d8dabe511f5 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.NormalizerRevisionEvidenceMissing | lci-failure-code-identifier | 0 | 66 | bb8d6faee8895769e88c1f53270d434b4e1874ffb6f884f9a7bdd66a75735a44 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.PremiseMismatch | lci-failure-code-identifier | 0 | 48 | 56d89f3e06b519cab3df3b11c3e311b506e1de2415ea8fa3e7bff63dfa6a6e90 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.PrivilegedRestorationAttempt | lci-failure-code-identifier | 0 | 61 | a542255f44195f38f2510cf639d1b9373df5648cec0f6ecbd7d097f27ba6fb6c | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ProcedureIdentityInsufficient | lci-failure-code-identifier | 0 | 62 | 2ff7285f0b5007ae4a635c6d16125a1411a240773e486ca4ae5a67cc57079aee | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ProcedureMismatch | lci-failure-code-identifier | 0 | 50 | c83dda2531905c433e0791eb89d0695fbfe6dbdfa8145c24821ee268a4d41c7f | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ProfileLocationMismatch | lci-failure-code-identifier | 0 | 56 | 83f708bc47c527be7f19669fa718ce184e3ab55f835a5dcf6666f3fb9ffe539f | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ProjectionNonDeterminism | lci-failure-code-identifier | 0 | 57 | a03fa62133faedbea5dcbf8594df927fa2d7f1717632f1b2f47845fcebf0df91 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.PropositionLocationInconsistent | lci-failure-code-identifier | 0 | 64 | e7c48728d9271f5fe64307f5bb8a50db040dd48610f01787ddb3371a37ec207f | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.PropositionMismatch | lci-failure-code-identifier | 0 | 52 | 12ccf56e8b2781d08146c67185b3ccf8b5e980c0011413acaad3a8b218047667 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.PropositionNormalizationWorkExceeded | lci-failure-code-identifier | 0 | 69 | a30cbcf99c11991eb4fd7dde1780c3dd51e93f0b76b4ea50cdac1585fef06eb4 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.RecursiveUnsupportedNestedVersion | lci-failure-code-identifier | 0 | 66 | 84e9c2a898a176e215bb03b1bae5f902db15783db6f331d937cccb522bfd3b57 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ReplayAuthorizationRequired | lci-failure-code-identifier | 0 | 60 | d45e9e61acc25ee50e35d1b0a822e9ee2c70b7f5d6e8dacf5694e3aee50609e7 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.RepresentedLossAccountSizeExceeded | lci-failure-code-identifier | 0 | 67 | c9597f8769e2e9b2eebb0e0960e5810eff1e5a21a05e067d2c6a79107eb51160 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.RepresentedLossRequired | lci-failure-code-identifier | 0 | 56 | fa44fd1db27a4ed0dd00c7271adf1d21a7f8b01174a2eaee0a71bd31d156e339 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeDisjoint | lci-failure-code-identifier | 0 | 46 | 9c9649e7b36468db23c116a16a585313afcf4f50018faaea1b066ddfb8b97c58 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeIncompatible | lci-failure-code-identifier | 0 | 50 | 959e17fb80eaec5046a3eeba077b30338c9d69db2b10b02550bef8a8aecc0501 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeNarrowingCoverageInsufficient | lci-failure-code-identifier | 0 | 67 | 84c2624f78cdbe3901f252c117192028363e3f119eb444bd9325cf7c60e94fc0 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeNarrowingNotDeclared | lci-failure-code-identifier | 0 | 58 | 707aa465dfe93e15e8cf02db7f9009e150c47e2a114ffa52e5481da3fa30ef0d | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeOverlapInsufficient | lci-failure-code-identifier | 0 | 57 | cae09afd3b30e5c267594c7257d0570bb8504a4a93acf2262787b83e600bb52d | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeRelationUnknown | lci-failure-code-identifier | 0 | 53 | 3c7f3dcb91fbf66e3793486309be75ca1f087000226bc7172130c1cea524580c | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeRelationWorkExceeded | lci-failure-code-identifier | 0 | 58 | 42993e09ec615c7fea7535c63d26079b38d57786c1a4a9e091448bff7db878db | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.ScopeWideningForbidden | lci-failure-code-identifier | 0 | 55 | cc32bb0980922bb9f9372903b4c1abadf745b9088c1243fa62145e20c65c9c8a | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.SelfDeclaredClaimId | lci-failure-code-identifier | 0 | 52 | d196fc47a2a4f42eb2db89236c0eb457675760a2aeb45c177bace17adc585259 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.SemanticIdentifierMappingMismatch | lci-failure-code-identifier | 0 | 66 | 011890206989fc89da80116946b82709a038b767eaf8fc6abea6cf738cba0381 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.StableReferenceMaterialBudgetExceeded | lci-failure-code-identifier | 0 | 70 | 7d4e3fe598a6d17518372af010c0aa907dd242a35feefa3a65f4e08909affda4 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.SubjectTimeMismatch | lci-failure-code-identifier | 0 | 52 | aa4fae3080bd3c6d7f4861e414014f82cff10a6a85c6723e223cc892d3fe79fb | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TargetBoundaryMismatch | lci-failure-code-identifier | 0 | 55 | ec4f6b68cbb661296ecd9fc724b67602dd38576e04c70112701b01114634824a | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TargetBoundaryMissing | lci-failure-code-identifier | 0 | 54 | a0f088f43be44540d983048410333475354b325001476fb95eb2051f0b4e5ae6 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TargetBoundaryUnknown | lci-failure-code-identifier | 0 | 54 | eb6a90c03c146ad0dc9d1c88b9c6ded56c51eb361b1568bc60e18b858205537d | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TargetBoundaryWorkExceeded | lci-failure-code-identifier | 0 | 59 | 6f34b46c9792015dc3a7cb63a9811d83bb881319cb405b79a69ca1eeab0c515e | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TargetSchemaKindMismatch | lci-failure-code-identifier | 0 | 57 | f576753f15b7fb832e0a9be86859a715a6d5420997b50bc6c3aecc2859e303dd | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TemporalCoverageInsufficient | lci-failure-code-identifier | 0 | 61 | 2285ec3b8c252669643bf6f4fde2978f82116ff894de88aaa60dd7de13172fb0 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TemporalRelationWorkExceeded | lci-failure-code-identifier | 0 | 61 | 26a8d79fd54e564ed24dbf97a052e8d14a266cbe8b3c69895914e3c51ab8025f | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.TranslationBoundaryMismatch | lci-failure-code-identifier | 0 | 60 | fa2fbb4a908273f8e62388fc4655b3a7d7ebc1d02f543a2f5c19a4bfc0a0ae5e | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnclassifiedAsOf | lci-failure-code-identifier | 0 | 49 | 1c9676f804c76d5138366e9d0d23d175aac9133559a2e8dc6b0c9ed7617957fd | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnexpectedUnit | lci-failure-code-identifier | 0 | 47 | 77886a1c5906e1a2a6dd7bdbac002e221f79bda6555e09c6ae5b1506653c9316 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnknownField | lci-failure-code-identifier | 0 | 45 | 89374c65276b4638ef13d42f2e02478b7be3a0bac4660c282a5ce7776418caa9 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnnormalizedProposition | lci-failure-code-identifier | 0 | 56 | 4479ed42a94178b928b58653f440e5cea16933f21afefc816bbf032e4e6c0150 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnresolvedAlias | lci-failure-code-identifier | 0 | 48 | 60f7052dc3869d4aa0fc82cb821ea58dfba89b27121205dc188e2dbf5eab5f12 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnresolvedRelativeTime | lci-failure-code-identifier | 0 | 55 | 548dc9a2507f524d28e082cf2f687c5b478ed1c7d97ce6273cb05604c95ac022 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedClaimProfile | lci-failure-code-identifier | 0 | 56 | bb273603bf46e8ee4a143a86ac78b274ac1d14ed849cfd7db83b2a4d2fbed071 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedIdentityPolicy | lci-failure-code-identifier | 0 | 58 | f8fabf36777909512641d6b0dc90b2fbc1321b690e1eb296ac696d9b38041289 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedInterpretationFrame | lci-failure-code-identifier | 0 | 63 | 281bd34f0c484e1c7234b1f89a17a548d508651dcdda294fb310985bec8a3cee | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedLCIVersion | lci-failure-code-identifier | 0 | 54 | 565b078227e05cafe5393c84a73fa1ce4765fb2b1cb911805d3efa1bf58e233b | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedLegacyForm | lci-failure-code-identifier | 0 | 54 | 58e859041a2306d3dd0f52bde4332955fddd82e2e2f81384f70f7aba1d9a4846 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedReferenceScheme | lci-failure-code-identifier | 0 | 59 | 57e9768b782989f685cce55e24484b8975c059287d921174f2dde5c60c813151 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedRepresentedLossAccountSchema | lci-failure-code-identifier | 0 | 72 | 8e38895e44c5d43be03ae5dc7240fe9e6b616e311e61c6bd996dfc200b46d207 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedScopeCalculus | lci-failure-code-identifier | 0 | 57 | 348f8b93c32236d2735dd89ac2819ab92acd606ab7f9d1353d7ff2f3c29668a3 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedTargetKind | lci-failure-code-identifier | 0 | 54 | 7621a34ca16353cd3e87aadf80404adefa652238fa2fa564d86692fe07769f93 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| failure-code.UnsupportedTemporalModel | lci-failure-code-identifier | 0 | 57 | 2476c2ea06e74e9ea79a05d5a88671d778eb16873c0cd5f30532df65c4076174 | LCI/0 §18; Errata E3/E5/E6/I12; Fixture Package |
| frame-components.animal-imperial-v1 | interpretation-frame-components | 0 | 1025 | d338c4802ae3e84cc87b8a18a1add169f5789643b68b53689a26c9f2ca4f7f93 | Errata E1/E4; Fixture Package §5 |
| frame-components.animal-si-v1 | interpretation-frame-components | 0 | 1019 | a42e439604d4e6e43f4f8fb05e7d0cda001ecab43929878428dcc8432c5cd1ce | Errata E1/E4; Fixture Package §5 |
| frame-components.animal-si-v2 | interpretation-frame-components | 0 | 1019 | 65150b70556a1ade9d8e582f2e300f55b20e1c292abfa276a00331bdf687c8b4 | Errata E1/E4; Fixture Package §5 |
| frame-components.neutral | interpretation-frame-components | 0 | 7 | 46b82d3c919048068d53b08e2aec20937736df2dd118a533d2d1eae1665c35e2 | Errata E1/E4; Fixture Package §5 |
| frame-components.vehicle-si-v1 | interpretation-frame-components | 0 | 1020 | 1520a51412bf548f11855922eae2e4507090688eca76a7ed15cf2bf3fa3b4fd9 | Errata E1/E4; Fixture Package §5 |
| frame.schema.primary.definition.0 | interpretation-frame-schema-definition | 0 | 1710 | 2fbac55ed7f937a7b15dc24ecda81ff75914a052a91f43f5d5d6b0bc79188dc7 | Fixture Package §5; Errata I12(d) |
| interpretation-frame.animal-imperial-v1 | interpretation-frame | 0 | 1796 | 79f1d995d6377e42022f8fbfe68dafe8e1ea0ce23e35d4f72d67ab2b80136ea8 | Errata E1/E4; Fixture Package §5 |
| interpretation-frame.animal-si-v1 | interpretation-frame | 0 | 1790 | 0b244538ee8fa99b4612de3859459a0e4cf20d22dee6fb9f225a13b7ff6bb9a5 | Errata E1/E4; Fixture Package §5 |
| interpretation-frame.animal-si-v2 | interpretation-frame | 0 | 1790 | f180ff193629c00c3973690daac38f12b4188ac98bd8021cf674c1f45d7b1f5d | Errata E1/E4; Fixture Package §5 |
| interpretation-frame.neutral | interpretation-frame | 0 | 778 | 60aef90afa2c0ea212f6d03811f9898fb2508f53d5ba52fce774946753cadae1 | Errata E1/E4; Fixture Package §5 |
| interpretation-frame.vehicle-si-v1 | interpretation-frame | 0 | 1791 | c0c1b88226277cdb45d9dc924b655621f52a7bc940955065e5b13d72c67f6c80 | Errata E1/E4; Fixture Package §5 |
| lci.identity-policy.0 | identity-policy | 0 | 175 | c111268cd45bada58a5a62511b2dc71ddb7a28fe99ebaccf0b0fed656b380424 | LCI/0 §7.3; Errata E3 |
| lci.world-basis.0 | claim-basis | 0 | 187 | 2352d92faedff2c156270873b0e9a468f1dd731c9a1c01adb60be7414b1e97c7 | LCI/0 §7.7.1 |
| legacy-record.as-of-ambiguous | legacy-v1-record | 0 | 1199 | add9130783c73d3f83ff6294fbc98ee3a5c2e7a26d5bc739204c718c2700559f | Fixture Package §9 |
| legacy-record.attempt-live-restoration | legacy-v1-record | 0 | 1767 | 70c0d4c06b0f4a11fcae114e707e66d3451b4b68890846b677a3b1418f26c67d | Fixture Package §9 |
| legacy-record.corpus-r4 | legacy-v1-record | 0 | 1190 | 8b4ae1328e2b0ce80983ae6d58d21a3051f35d3aa27d3e685ce0facc7d9a6ad0 | Fixture Package §9 |
| legacy-record.inert-predecessor-warrant | legacy-v1-record | 0 | 1768 | cf7eb8152bbe13d5a540c02c0c56ea80451acb6617a6508ab6d3ff5f844c38cc | Fixture Package §9 |
| legacy-record.near-miss-package | legacy-v1-record | 0 | 1202 | 35740b6310308d8d8e24f885de1efead63dff5a17f3be0192a82c182b3eaf58c | Fixture Package §9 |
| legacy-record.printer-variation | legacy-v1-record | 0 | 1198 | 0f38972399b3dc66365e6c74e3077deb90ff97b2faa64388d5829d08cb20a3a4 | Fixture Package §9 |
| legacy-record.scope-tenant-b | legacy-v1-record | 0 | 1195 | 6f03aa35222445f90b1a8342f6848daafb718de690d53c601a9d6ca85c66410f | Fixture Package §9 |
| legacy-record.semantic-wrong-mapping | legacy-v1-record | 0 | 1302 | 9816c0d6d12590f2cf44bfcf6133621d1515e4efcac4e474bb5bba0d9275783b | Fixture Package §9 |
| legacy-record.time-100 | legacy-v1-record | 0 | 1189 | 2927a7a795dfa82ab798d2f0126e9ee6ac711d96664959ad4a6cf306ec163b13 | Fixture Package §9 |
| legacy-record.time-124 | legacy-v1-record | 0 | 1189 | 7bf074cec428050f0fbdf31e3f0896fb7f0547025334184ab861a000e527d5a5 | Fixture Package §9 |
| legacy-source.as-of-ambiguous | legacy-source-fixture | 0 | 2835 | 367345ca5f2345f2cc25db98f97e3d54b17b1eeac56bb26daf8a95ee52941e3e | Fixture Package §9; Errata E9 |
| legacy-source.attempt-live-restoration | legacy-source-fixture | 0 | 3417 | 1bd464f7cd8f85ec3349c82a954c3c09edb6f2d1f102787fbb37cdbb7adeff51 | Fixture Package §9; Errata E9 |
| legacy-source.corpus-r4 | legacy-source-fixture | 0 | 2836 | fae0d97d77f291a6cf5fb54be0d48422d656c976e30dcd87d05e903939669632 | Fixture Package §9; Errata E9 |
| legacy-source.hostile-read-eval | legacy-source-fixture | 0 | 1595 | 6b0f756e8660a2169d4018e002dedb87de6b3828b4fb36aab9ca25117b30be40 | Fixture Package §9; Errata E9 |
| legacy-source.inert-predecessor-warrant | legacy-source-fixture | 0 | 3431 | 8cfc0acb95214f2709efda86c95a112ddb024653c8bfab9de5b70452ea0281b5 | Fixture Package §9; Errata E9 |
| legacy-source.near-miss-package | legacy-source-fixture | 0 | 2840 | aaa6d947ba17f8ac3744d68301fac88695babcb341691ad296c96bc2bf4a3206 | Fixture Package §9; Errata E9 |
| legacy-source.printer-compact | legacy-source-fixture | 0 | 2844 | 699749ce6d899f4bab2f6dcbe48ebc8eb7b3c506192e35b15f24eee6fcfc782e | Fixture Package §9; Errata E9 |
| legacy-source.printer-pretty | legacy-source-fixture | 0 | 2858 | b60e806ae9509bc37f484b60ec9e777b85d65b83414fa9039874a3698837c7fe | Fixture Package §9; Errata E9 |
| legacy-source.scope-tenant-b | legacy-source-fixture | 0 | 2841 | 6466588ee445ae764dea6380a5adb96980bd6c76a2a22f02f821630e32242179 | Fixture Package §9; Errata E9 |
| legacy-source.semantic-wrong-mapping | legacy-source-fixture | 0 | 2960 | 566beb2e848999867b241fa96a968e0e8bfa160a32bf7cfa0511569007dcc7c2 | Fixture Package §9; Errata E9 |
| legacy-source.time-100 | legacy-source-fixture | 0 | 2835 | 4da59585bb3cd6d458d803911940d7701192271ed2d003a8790ab9d11d664ddf | Fixture Package §9; Errata E9 |
| legacy-source.time-124 | legacy-source-fixture | 0 | 2835 | 83e7604853e0a77ad8c938f481b0184eb668391e0d2bcc9864d6a2a9d1641424 | Fixture Package §9; Errata E9 |
| migration-classification.deferred-to-named-calculus | migration-classification-identifier | 0 | 84 | a43ddfef13135c89acc55bb11bed355ac7431c38755e48c07affa4f18cc226ec | Errata E9; Fixture Package §9 |
| migration-classification.exact | migration-classification-identifier | 0 | 63 | 9ef24f9d9a1f174e24ec5a61ca01995d3aa9dabda9236f5c527242338f78bbef | Errata E9; Fixture Package §9 |
| migration-classification.exact-after-explicit-tagging | migration-classification-identifier | 0 | 86 | d8909cb03e910b2eb9e312c92a4b1eb3886d5fba03a28dded10f7739a7dedfdb | Errata E9; Fixture Package §9 |
| migration-classification.lossy-with-represented-loss | migration-classification-identifier | 0 | 85 | 353406fc4bc6d7cc3b2c3e3626653882e592e2ed53fadf81fce1aaad25e33b63 | Errata E9; Fixture Package §9 |
| migration-classification.new-identity-required | migration-classification-identifier | 0 | 79 | b891f7a96c34f7496b04ffe0b334e134dd6657dedf311e7015d66bec4acdaae8 | Errata E9; Fixture Package §9 |
| migration-classification.privileged-runtime-relation-outside-claim-id | migration-classification-identifier | 0 | 102 | 8f169d905a30ad97494986cff035cf0f88b186ab52d96194881d2d457941c80c | Errata E9; Fixture Package §9 |
| migration-classification.rejected | migration-classification-identifier | 0 | 66 | 5370a6fb6d788b32d3f456aee30f6812dd3dc1bdaa4336b69f3693dfea5eeb85 | Errata E9; Fixture Package §9 |
| migration-result.corpus-r4 | migration-result | 0 | 26660 | 001de18804d4826f10106efd9ba0979d372dada832cda854466c2b3681062e19 | Fixture Package §9 |
| migration-result.inert-predecessor | migration-result | 0 | 31123 | 52e3082b19db7cf38bcc0f0ad93a11cf9397917c881f764584544d328eebb57a | Fixture Package §9; Errata I12(e) |
| migration-result.scope-tenant-b | migration-result | 0 | 26660 | 97f8f675abb505fa367cd130433417ab37a6dea7e7b7bdd1343a8f37cec0d641 | Fixture Package §9 |
| migration-result.time-100 | migration-result | 0 | 26660 | 7dcbf1cadaddac2efd85178e26234d62e8c36c5db9dab212a3bab14b023fecdb | Fixture Package §9 |
| migration-result.time-124 | migration-result | 0 | 26660 | 24ba42e789e188521f2de8f71947b8b16c7d08395244ab5d7495ce396af1a719 | Fixture Package §9 |
| migration.as-of-role-map.0 | legacy-as-of-role-table | 0 | 2597 | bcbf83e2ed5e410812876ee5f4ea8a30ffcc93bc951ebd56767a8dd96de19a90 | Fixture Package §9; Errata E9/I11 |
| migration.classification-map.0 | migration-classification-map | 0 | 3352 | 685f33dfa7ec653aa9ee2ec924a91a4104f2bbcd9d99898ac97215f4ce4ab693 | Errata E9; Fixture Package §9 |
| migration.corpus-frame-reconstruction-rules.0 | migration-reconstruction-rules | 0 | 11636 | 68fd758d3e47ba76dcafd88b9bb6f757f036fb6754143785a6487b36662eb17a | Fixture Package §9 |
| migration.legacy-grammar.0 | legacy-fixture-grammar | 0 | 1309 | 7ab85681ecab610436911f567041bc25f6a9bf5eaa47b1e9742155ea96bbd411 | Fixture Package §9; Errata E9 |
| migration.package-symbol-map.0 | legacy-identifier-mapping-table | 0 | 4138 | 8f0ff05636d36ddb8b1a2048714032ccc3000af9c0213f7bedfb38f97f1ef687 | Fixture Package §9; Errata E9 |
| migration.scope-map.0 | legacy-scope-mapping-table | 0 | 4756 | 21ee19bc6eaa0463e3edd6388b89ae68acaccf259d94a8808e023ac9eed72bcd | Fixture Package §9 |
| mneme.claim-profile.0 | claim-profile | 0 | 168 | ce0f0c37a4b36a2e1b76fc5947a96af58ef0c5c60715ef40409550c2b4c7e219 | LCI/0 §7.4; Errata E3 |
| mneme.profile-location.empty.0 | profile-location | 0 | 7 | 46b82d3c919048068d53b08e2aec20937736df2dd118a533d2d1eae1665c35e2 | Errata I12(a) |
| neutral.all-members-slice | neutral-dataset-slice | 0 | 984 | a07f5910a8c8eaf11737a6f96bf8e3ee7474dac9b7adb51419b2191d1eb06baa | Errata E1; Fixture Package §4 |
| neutral.atemporal-subject-time | neutral-subject-time | 0 | 960 | 5bb34bdb9115789ff4a9f900ae011cac63c558c5641d7eae3a317883f152824e | Errata E1; Fixture Package §3 |
| neutral.not-applicable-boundary | neutral-semantic-boundary | 0 | 1013 | 0db0dedf17bab2acd9239fb63823d0cf303029898248a08b15a8030ac6e52ad6 | Errata E1; Fixture Package §4 |
| neutral.self-describing-frame | neutral-interpretation-frame | 0 | 778 | 60aef90afa2c0ea212f6d03811f9898fb2508f53d5ba52fce774946753cadae1 | Errata E1/E4; Fixture Package §5 |
| neutral.universal-scope | neutral-scope | 0 | 936 | d2b4a25a8001500574f676020517d165177e36e99d202bd6e7ea5570a35e07b0 | Errata E1; Fixture Package §2 |
| normalizer.conformance-binding.0 | normalizer-conformance-binding | 0 | 3200 | c963d5080155130a1ac0716e9de9c99ed9923c114ad5f9589913cc4b309a971e | Errata E3/E4; Fixture Package §1 |
| normalizer.mutation-vector.0 | normalizer-mutation-vector | 0 | 1665 | 06ee45abbeb3053c681464cf98e9a72901cabf61b95e5c25d7aa7b2f1bb33416 | Errata E3; Fixture Package §1 |
| normalizer.semantic-projection-ledger.0 | normalizer-semantic-projection-ledger | 0 | 13653 | 8947248fb4ec6f9fe13c23e7a1010b723c419866b53c680832e408d5c73bf185 | Errata E3; Fixture Package §1 |
| normalizer.surface.controlled-en.file-alpha | normalizer-source-input | 0 | 971 | fc42f6f98b55ef9405cec48367b6a18e0085890ef2a52696d9a0d8f34116a637 | Fixture Package §1 |
| normalizer.surface.controlled-pt.file-alpha | normalizer-source-input | 0 | 974 | 278c8affe007b9515c9c6b358e78320faf400479139e3932af69d6d4f42946d3 | Fixture Package §1 |
| prior-ruling-migration-term.exact | prior-ruling-migration-classification-identifier | 0 | 76 | 1f9ab42d397cfff687de9faabffd25f3ac15684c8cdd0cb4f53cf3f0394ab0ed | Errata E9 |
| prior-ruling-migration-term.explicitly-tagged | prior-ruling-migration-classification-identifier | 0 | 88 | c405c903b1846388a2716403f678fc490ad3ac42ca60023922683b46cf2ceea9 | Errata E9 |
| prior-ruling-migration-term.lossy-with-represented-loss | prior-ruling-migration-classification-identifier | 0 | 98 | 87996262fc5f11dc7a92b82c42cb2e211c9fbcb4dcc967a5d60b80d7951cdc1e | Errata E9 |
| prior-ruling-migration-term.profile-adapted | prior-ruling-migration-classification-identifier | 0 | 86 | ecfc40000e142a46015dc114b1a92363e78a53fbca7857c74f9e65a8d4c64cf1 | Errata E9 |
| prior-ruling-migration-term.rejected | prior-ruling-migration-classification-identifier | 0 | 79 | 0224c42337f04cf47c7dc5d2147202e7c33ee45905db787cf6cf2cb740ea627e | Errata E9 |
| proposition-form-schema.artifact-contains-says.0 | proposition-form-schema | 0 | 2440 | 68c22b662507e183ffe4a952d7744d2bdd314d29e3dfc3adb0d489786e909ca2 | Fixture Package §1; Errata E5 |
| proposition-form-schema.average-statistical-value.0 | proposition-form-schema | 0 | 2736 | 72da4eac2f511da718ab4bb01e571cb01f4301331fbadc90803ced160a86cadb | Fixture Package §1; Errata E5 |
| proposition-form-schema.bounded-corpus-absence.0 | proposition-form-schema | 0 | 2796 | bcc505354f8ee724addccb3a3fbeb2415eae7baca7813a018d21872dea69f6e0 | Fixture Package §1; Errata E5 |
| proposition-form-schema.call-result-equality.0 | proposition-form-schema | 0 | 2724 | 63dea841bf84dde8a49c16c4d349970735bf430197404fad38b2ee9b825be8b2 | Fixture Package §1; Errata E5 |
| proposition-form-schema.exact-equality.0 | proposition-form-schema | 0 | 2412 | a38c553897d212094ff7ab5081a842854d508a464d3aaf42da4fa1657483deda | Fixture Package §1; Errata E5 |
| proposition-form-schema.existential-property.0 | proposition-form-schema | 0 | 2158 | 113a80915b601c5df1f0a9f5fdffbb5a117e8175015e367ba2b9cb6c0a785d58 | Fixture Package §1; Errata E5 |
| proposition-form-schema.file-exists.0 | proposition-form-schema | 0 | 2130 | 84cc96a063115be7c705adb1d1bf59ba05b04a605bbb8af13401293f2cbc0cb3 | Fixture Package §1; Errata E5 |
| proposition-form-schema.probabilistic-claim.0 | proposition-form-schema | 0 | 2774 | b34a18c62fb2c0e501ed73801df2e6277dee79b8487d40d41cedcb8b1e3ed18a | Fixture Package §1; Errata E5 |
| proposition-form-schema.producer-returned-value.0 | proposition-form-schema | 0 | 2732 | b65bc066d2f5cee4ab26dcd852e08fd72cf57f16a6384a973917e36474e0a28f | Fixture Package §1; Errata E5 |
| proposition-form-schema.translation-ambiguity.0 | proposition-form-schema | 0 | 3376 | 46139207ea0788cfd92836470d31f2e14ba687fd946a63522b777923cd966451 | Fixture Package §1; Errata E5 |
| proposition-form-schema.universal-property-over-scope.0 | proposition-form-schema | 0 | 2176 | 4c8d71c2a30f5a1a70739059badd04996a42f7cd414f287c5803474211543492 | Fixture Package §1; Errata E5 |
| proposition-form.artifact-contains-says | proposition-form-identifier | 0 | 72 | e17e95aca86f33d4cbd2510f6fb5f88d0588cbf257b2b64193baa64fbf3ac3ef | Fixture Package §1 |
| proposition-form.average-statistical-value | proposition-form-identifier | 0 | 75 | 4ef1003613d115842a5bc10e3c7214a912b4b2034eecaad1abc2c8de2ceb039f | Fixture Package §1 |
| proposition-form.bounded-corpus-absence | proposition-form-identifier | 0 | 72 | 940a68d96ff9fad1d1aa1b470588c76dafff2d24821f6c3dc71c9931b600018a | Fixture Package §1 |
| proposition-form.call-result-equality | proposition-form-identifier | 0 | 70 | 0f51afcd44c8eda89e8b22f985dcfd2cbcce688757811db73fae85864dd58f27 | Fixture Package §1 |
| proposition-form.exact-equality | proposition-form-identifier | 0 | 64 | ac5030fbb0e6e38929d56b11f97bf17602e56b69121fc7398a44f060f213be3e | Fixture Package §1 |
| proposition-form.existential-property | proposition-form-identifier | 0 | 70 | 62bb86c48ad91ca832e3846854c9de847dfbe3060fe4529551b2da1849bce8b3 | Fixture Package §1 |
| proposition-form.file-exists | proposition-form-identifier | 0 | 61 | 8ddfaab40001a5b9bdff917d3070261bae1be8dbd2c57d2dc1c93d7b1b389344 | Fixture Package §1 |
| proposition-form.probabilistic-claim | proposition-form-identifier | 0 | 69 | b10e76fe2442acbc4caf39fd3f282d4f425d0fb3dac71fe3bd262440477f9c13 | Fixture Package §1 |
| proposition-form.producer-returned-value | proposition-form-identifier | 0 | 73 | bb63c8c70dce0933009363a5100df8c5eb4a280ca58c6d4fbc9d54d54df6874b | Fixture Package §1 |
| proposition-form.translation-ambiguity | proposition-form-identifier | 0 | 71 | 9da2aeff2c28760e9518692cb8083462fdd6e10c7181c1d9d70f4eaa8225198a | Fixture Package §1 |
| proposition-form.universal-property-over-scope | proposition-form-identifier | 0 | 79 | ccb429c4441f7053bbd480d0b441260164fe27c5c1ee04fb6ae6177acec3d0d0 | Fixture Package §1 |
| proposition.all-devices-encrypted | normalized-proposition | 0 | 4322 | 94a9683e914c5df22726aca3bf79a3ba5d99e4ea84df9ce1f2b1252ad393ee22 | Fixture Package §1 |
| proposition.artifact-alpha-says-ready | normalized-proposition | 0 | 5230 | fd1c86b8f18ba705099b06eea0ab16303777fb837790a3582af8006528fa33a7 | Fixture Package §1 |
| proposition.average-latency-50-ms | normalized-proposition | 0 | 5216 | 7264061ba51bc0b994515a069a9cefeb5d0a5a5e5c82e4aefff712a281024396 | Fixture Package §1 |
| proposition.bank-translation-ambiguous | normalized-proposition | 0 | 6178 | f3ce659899ffcfbb026871bffe1a8f339c3a519ed42111708f6f5c66e7de416f | Fixture Package §1 |
| proposition.call-17-returns-42 | normalized-proposition | 0 | 5677 | eafa85cfec495890f08be0e219769ebd656ffdf4be66ccd7390ff8fc2e3de19c | Fixture Package §1 |
| proposition.file-alpha-exists | normalized-proposition | 0 | 4777 | 4add78581d22eea80803de6c9d08fc61b416a1deafc178adf9c46686b74aee30 | Fixture Package §1 |
| proposition.file-alpha-exists-probability-3-4 | normalized-proposition | 0 | 9988 | 21d9e1622fdb1850aabc294315076c853f88b6c693f3328efcf28ebf8d789051 | Fixture Package §1 |
| proposition.file-beta-exists | normalized-proposition | 0 | 4776 | b1fac2d22fb1a7b05fa1be726e4a5fb66f963a9fd527b59a59fc7d9be421b4f6 | Fixture Package §1 |
| proposition.grammar.definition.0 | proposition-grammar-definition | 0 | 23709 | e1966ac147c37ef8e574a0505f7fc81b8dcb2980a23b5f2badc171ee5b599bf3 | Fixture Package §1; Errata I05 |
| proposition.model-alpha-returned-yes | normalized-proposition | 0 | 6229 | f6421b25649a4c5248a9dfe95b73b68aa5a4399af8922ad421768360945c7cff | Fixture Package §1 |
| proposition.no-error-in-bounded-corpus | normalized-proposition | 0 | 6017 | cbcc05dba9d999ec767e355345af036c37663e750b693b42dc500935ffac821c | Fixture Package §1 |
| proposition.one-equals-one | normalized-proposition | 0 | 4672 | 52812eab6921b39a740a53b5cf29f469a1170c3b139f87885ec1bc6bc3c30baa | Fixture Package §1 |
| proposition.one-equals-two | normalized-proposition | 0 | 4672 | 56017cfd9113ac63378a3e6726db1ea6cd03fd03dac4785bc9f34badcc017f54 | Fixture Package §1 |
| proposition.placement-monotonicity-table.0 | proposition-placement-monotonicity-table | 0 | 19092 | 124254f022beacfecc91c87a2b16245e9c3d5cc05762c50b6b5912103dd24a87 | Fixture Package §1; Errata E5 |
| proposition.some-device-failed | normalized-proposition | 0 | 4307 | 25fd5c9cfbbb5b4269914455f5011322330853b2a892fd635dfd2e89a228a602 | Fixture Package §1 |
| proposition.unicode-nfc-e-acute | normalized-proposition | 0 | 5227 | 970f2fd07250d5fab4d9532c90c799f6b2eb0dbdc3b2a5a25ec68f6b85c63d6b | Fixture Package §1 |
| proposition.unicode-nfd-e-acute | normalized-proposition | 0 | 5228 | 389ba4d775aa7a2ce44df1ebafedca1a366de6439d7de449941f68a5fd80661e | Fixture Package §1 |
| relation.after | relation-identifier | 0 | 39 | 43a72a8d12a2d81e272aecc14644be3ddcbd2940274141c4f82b5d70a8084f7b | LCI/0 §§10–17; Fixture Package |
| relation.authority-or-custody-loss | relation-identifier | 0 | 59 | fd177e4a38b80ddccd160d33e82af37c7aee56e1d7ebc752e00c80803e79fd6f | LCI/0 §§10–17; Fixture Package |
| relation.before | relation-identifier | 0 | 40 | 907f3bed9973d703026db4313c603f88fc0dc08108f56fca429268ec6f74032e | LCI/0 §§10–17; Fixture Package |
| relation.contained-by | relation-identifier | 0 | 46 | 021a24e84290b077ee5fd4423a514b57569b5f7e2444790c7ae4bce9d8b347ff | LCI/0 §§10–17; Fixture Package |
| relation.contains | relation-identifier | 0 | 42 | 308ffcdec3bc2897c9ac02d8e840ad18c24bcc1e92984a2b519e55d97372ee4e | LCI/0 §§10–17; Fixture Package |
| relation.disjoint | relation-identifier | 0 | 42 | f0e2896e26c3ccd4566c7f7adb6b272286238329ae5cabc55ed1821f2dd6f1f8 | LCI/0 §§10–17; Fixture Package |
| relation.equal | relation-identifier | 0 | 39 | abfbdcfc482386f456cebb704fd0fe693bd67f758d63bea1948d116c59fa252e | LCI/0 §§10–17; Fixture Package |
| relation.exact-target | relation-identifier | 0 | 46 | df1d4ff074f48a9f861f2535f12ec572f6b26b3142a60bad070f55e8f871708b | LCI/0 §§10–17; Fixture Package |
| relation.identity-bearing-loss | relation-identifier | 0 | 55 | c90c3a0a6d6ac9d01b67eeb6a59bb4a4d784029a823b677bf6e4ec9c1906d89f | LCI/0 §§10–17; Fixture Package |
| relation.identity-neutral-loss | relation-identifier | 0 | 55 | b6e37c2a3b8f4c9f977f878d11c1c50479ed373571e12f426d72dfc479c1331a | LCI/0 §§10–17; Fixture Package |
| relation.incompatible | relation-identifier | 0 | 46 | 5938f8bacc1fb8e9c72a86ee7d2c4757fc0a4bb58dae55eec98d33ab6430b90c | LCI/0 §§10–17; Fixture Package |
| relation.narrower | relation-identifier | 0 | 42 | b062ba26b3f5ab08911e32bafd29f6a45c080abc2ef7cd62f20fe010d356dc0f | LCI/0 §§10–17; Fixture Package |
| relation.overlap | relation-identifier | 0 | 41 | 36c73f5d2bec685d22448e9f5c7d5bb2984c49594a4adb98aa91d51418070218 | LCI/0 §§10–17; Fixture Package |
| relation.semantic-translation-loss | relation-identifier | 0 | 59 | 86dff25308585f24ec27cfb0d8a5dd134cb80c8b5570168725eef8934227b9cf | LCI/0 §§10–17; Fixture Package |
| relation.supports-by-scope-narrowing | relation-identifier | 0 | 61 | e76b9be138b2b007f8252e0759f2089ea6c2c7922aa680163ceeec549349dc1f | LCI/0 §§10–17; Fixture Package |
| relation.unknown | relation-identifier | 0 | 41 | 997710069859ee790da68a94c24105f43b87a3880d8317b218623f746a34f7bc | LCI/0 §§10–17; Fixture Package |
| relation.unknown-consequence | relation-identifier | 0 | 53 | 095d988b232aae6100fecd743e73b2f87bb352d738a9334f4123f6d7532d4ed0 | LCI/0 §§10–17; Fixture Package |
| relation.wider | relation-identifier | 0 | 39 | 5d36a587fd9ab54badefb8fd30eea1c7f92ff20ecf2b740475a7c0c5339ad2d7 | LCI/0 §§10–17; Fixture Package |
| represented-loss-account-schema-definition.compaction.0 | represented-loss-account-schema-definition | 0 | 2182 | 324192a7c630d907713bab9921872684cffc673c535981e193d89e64c3f10471 | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.handoff.0 | represented-loss-account-schema-definition | 0 | 2671 | ed2457219a3b1023255e1ad0f53f966c6a3c96d067e340f54dc17b1f50c0e8b9 | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.identifier-mapping.0 | represented-loss-account-schema-definition | 0 | 2364 | ebc60ad73503da15e9994d5c0574b3f037b4d1f7bf32f448b0364b769cec9b80 | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.reconstruction.0 | represented-loss-account-schema-definition | 0 | 2429 | 02ab11af9e6719aae9ca2dab319c7e925b9e3c39ca439a03363a7434f21821e3 | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.temporal-role-classification.0 | represented-loss-account-schema-definition | 0 | 2369 | 09c24ab008afe0fe43791186fc62c112e336e4225c3494b22cab86293d613901 | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.translation.0 | represented-loss-account-schema-definition | 0 | 2620 | 44608380b7ca373a4f782db587bc4fce115f12811a92d138a69bab1e4ada53aa | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-definition.v1-migration.0 | represented-loss-account-schema-definition | 0 | 2629 | 5d39867dae6eea30ca22fb42760c3b3be129204467c28ad9359683672d456c8d | Fixture Package §12; Errata I12(d) |
| represented-loss-account-schema-id.compaction.0 | represented-loss-account-schema-identifier | 0 | 77 | 061ee539208487deed4b50f047c2846449155b6964f826ee810ffdb029935ae1 | Fixture Package §12 |
| represented-loss-account-schema-id.handoff.0 | represented-loss-account-schema-identifier | 0 | 74 | f8e8b9446c51860e4568925c0342f5cad670d55138e003fc500d3dcb5f3dca5c | Fixture Package §12 |
| represented-loss-account-schema-id.identifier-mapping.0 | represented-loss-account-schema-identifier | 0 | 85 | 2be15268d05328c4dde3a8a8df3ce783cd2441450844e98ae05099596ab8d398 | Fixture Package §12 |
| represented-loss-account-schema-id.reconstruction.0 | represented-loss-account-schema-identifier | 0 | 81 | 65138bf63c7e6e9a2563f7af84cb79088142c1136005b9e7a3766cd208174ee0 | Fixture Package §12 |
| represented-loss-account-schema-id.temporal-role-classification.0 | represented-loss-account-schema-identifier | 0 | 95 | 196b172bbb8d217d69ba0a4f93bba73c0b3d458907317c7f33b5d641125ee6a2 | Fixture Package §12 |
| represented-loss-account-schema-id.translation.0 | represented-loss-account-schema-identifier | 0 | 78 | 76c931f9e06dd4df8fc9ffe449e484046a5ecd27c957cfaf52c5fd81c4a97203 | Fixture Package §12 |
| represented-loss-account-schema-id.v1-migration.0 | represented-loss-account-schema-identifier | 0 | 79 | 870d036d8cfdf1fbc7062b8b2f4e5d5e9bf03a7fe6981324de0140937e7ed830 | Fixture Package §12 |
| represented-loss-account.compaction-metadata | represented-loss-account | 0 | 1265 | 4c78cbee0c511d2106b4ae188adee85c80637eb3f60bd2daf7df5d88898e976c | Fixture Package §12 |
| represented-loss-account.handoff-authority | represented-loss-account | 0 | 2234 | 90b180679d13fdf2de925136e41c3a768c9382b398e501605519132ae05d5e0c | Fixture Package §§7,12 |
| represented-loss-account.identifier-mapping-exact | represented-loss-account | 0 | 1327 | cb18f1037167936f3f0140a755618c4db75a179a8e2fe630ee204b516474b58a | Fixture Package §§9,12 |
| represented-loss-account.reconstruction-partial | represented-loss-account | 0 | 2372 | 420da55120c751f25702224e87147329d8b9c5047130246acfec86c73948b38b | Fixture Package §12 |
| represented-loss-account.temporal-role-exact | represented-loss-account | 0 | 1268 | 8b7bb8fc9aeb3689e3f2175c9be853283b64778dc644334e5366449853b208c2 | Fixture Package §§9,12 |
| represented-loss-account.translation-lossy | represented-loss-account | 0 | 1394 | e7579d0881ed675393bc7a7495c2f120890a19873b3c09d316c8dfa7ce36a146 | Fixture Package §§5,9,12 |
| represented-loss-account.v1-identity-neutral | represented-loss-account | 0 | 2639 | d4ab375a7d5b48937f43d22f5aecf40c7b60ede8809c56eaa9bbd88f9cf58155 | Fixture Package §§9,12 |
| represented-loss.inheritance-authority | represented-loss | 0 | 3744 | fd846e5743109afaccc557cb79cd806d6c8b82949a3638a4c678d847c1e7d817 | Fixture Package §§7,12 |
| represented-loss.migration-identity-neutral | represented-loss | 0 | 4094 | ea92ebc34b5f2ad5cdbf080dae4924ca21b03db903cc64b03e0894df8adfab1f | Fixture Package §§9,12 |
| represented-loss.translation-semantic | represented-loss | 0 | 2847 | 698ad68eeb99da2c5016f586820ab545c560744289fb4788c71efef128e1feba | Fixture Package §§5,12 |
| resource-budget.lci-first-implementation.0 | lci-resource-budget | 0 | 6733 | b574f188fbc24c99018a8095fb9846511f582136c416b5f4cd685ba67ee16c93 | Fixture Package §10; LCI/0 N032 |
| resource-workload-generator-registry.0 | resource-workload-generator-registry | 0 | 5650 | 4ca93f96960244f2981fc9cd758a4ed8680724cc845286feb67ddc75a5479d63 | Fixture Package §10 |
| scheme-definition.artifact.structural.0 | stable-ref-scheme-definition | 0 | 1228 | a1c4d3290e095e50b6673556dea4cabe609bb3c20851f609127e51e14a2ceb7f | Errata E7; Fixture Package §6 |
| scheme-definition.dataset-slice-calculus.structural.0 | stable-ref-scheme-definition | 0 | 1284 | 80aa4c0b2e5ab824ff963e259b82ec64e40c1d5c512e266c41506b5f30a71029 | Errata E7; Fixture Package §6 |
| scheme-definition.immutable-corpus-revision.structural.0 | stable-ref-scheme-definition | 0 | 1296 | 159a2c44503b275259702a52aa0b3cd5c83a09a26d7613119d023f68605e0ce2 | Errata E7; Fixture Package §6 |
| scheme-definition.interpretation-frame-schema.structural.0 | stable-ref-scheme-definition | 0 | 1304 | 52b210bea45283f6e3e2d1d8e918d2d6071c574fa2c89e8da2af96b85e23c82b | Errata E7; Fixture Package §6 |
| scheme-definition.logical-corpus.structural.0 | stable-ref-scheme-definition | 0 | 1252 | 5ca8818e67dade92322a4a2d144bbd07c39416067f242650725231f7b113b772 | Errata E7; Fixture Package §6 |
| scheme-definition.model.structural.0 | stable-ref-scheme-definition | 0 | 1216 | f9ea849b69dab8e1c6cc31f3611df596520f533e993a69128f2b5f8f81a7ea9b | Errata E7; Fixture Package §6 |
| scheme-definition.module.structural.0 | stable-ref-scheme-definition | 0 | 1220 | 06e86d8d2b9d4284ee255165df80d904014b29106a030f2824d2b582175f8fc6 | Errata E7; Fixture Package §6 |
| scheme-definition.policy.structural.0 | stable-ref-scheme-definition | 0 | 1220 | 705c3700bfc269e3d0996e488681d8b30466861272d232e11d333f52636eee61 | Errata E7; Fixture Package §6 |
| scheme-definition.principal.structural.0 | stable-ref-scheme-definition | 0 | 1232 | 8e9d404506dbb1f9940e49392abd2f653891e979eef798576f2e46c73f32d4cd | Errata E7; Fixture Package §6 |
| scheme-definition.procedure.structural.0 | stable-ref-scheme-definition | 0 | 1232 | 0b04f5a79ccd3c26150c4452b74f336bf11f91705d0ab5f1bc691b1a4635cccf | Errata E7; Fixture Package §6 |
| scheme-definition.prompt-invocation.structural.0 | stable-ref-scheme-definition | 0 | 1264 | 7cc7f4b25e0d35f39bfc9d8cd8e70bcae110c1fe8b5021ac0d648faa2293a15d | Errata E7; Fixture Package §6 |
| scheme-definition.scope-calculus.structural.0 | stable-ref-scheme-definition | 0 | 1252 | 69edf21d24ec99fbdc54e484a838a8ef01091a8ff0338e52ef948468898125d3 | Errata E7; Fixture Package §6 |
| scheme-definition.semantic-boundary-calculus.structural.0 | stable-ref-scheme-definition | 0 | 1300 | 74bb0a071ceb64be2938d5b0700a2c7bf8ae5da346aba075d9c7b38dca020b80 | Errata E7; Fixture Package §6 |
| scheme-definition.temporal-model.structural.0 | stable-ref-scheme-definition | 0 | 1252 | 5c915f34716e164e1ef8e878307ca173b0c08278e096640bb1e2e98682b7f75a | Errata E7; Fixture Package §6 |
| scheme.artifact.structural.0 | stable-ref-scheme-identifier | 0 | 61 | 174f535a21248894aec3b68f6534c5ffaf7b209c6c9cb7a4714b688e0a4e7b13 | Errata E7; Fixture Package §6 |
| scheme.dataset-slice-calculus.structural.0 | stable-ref-scheme-identifier | 0 | 75 | bce433dcbe3819b9969b6ae61975e4c3fd3584c903735196eadb46d274294725 | Errata E7; Fixture Package §6 |
| scheme.immutable-corpus-revision.structural.0 | stable-ref-scheme-identifier | 0 | 78 | 9559ca77e60b872f64b5899ce5db8ebe3c8449f090393950a6d956d27caa9a3f | Errata E7; Fixture Package §6 |
| scheme.interpretation-frame-schema.structural.0 | stable-ref-scheme-identifier | 0 | 80 | e4ec4fc73d3f11cc8468be36060b890fff37c3d38fa575fb5eca4779d37ce8a4 | Errata E7; Fixture Package §6 |
| scheme.logical-corpus.structural.0 | stable-ref-scheme-identifier | 0 | 67 | 2dec1ab36b2d78d2deec21bd0f15b0f444bb49af604c7de598da32151939995c | Errata E7; Fixture Package §6 |
| scheme.model.structural.0 | stable-ref-scheme-identifier | 0 | 58 | dea2ab054f589f955790de5c47eef4f7c87823ecb2bf07292db4f6a106dac778 | Errata E7; Fixture Package §6 |
| scheme.module.structural.0 | stable-ref-scheme-identifier | 0 | 59 | b68d23c9ab4e370711350978d4844c9462f1e547bc2d70aa97bbf2d7254f36f4 | Errata E7; Fixture Package §6 |
| scheme.policy.structural.0 | stable-ref-scheme-identifier | 0 | 59 | c0d525eb8d465b0434f9ce127b3b0846b55444f97e24aba6e521489b90cdc9c1 | Errata E7; Fixture Package §6 |
| scheme.principal.structural.0 | stable-ref-scheme-identifier | 0 | 62 | 5ab481fd52d15b1cef95dd550d5ad07c8e4b7ac9f0039302094e19a108e39151 | Errata E7; Fixture Package §6 |
| scheme.procedure.structural.0 | stable-ref-scheme-identifier | 0 | 62 | 2399f4584aa7d94825dc2e5c4cc7b73eb494fbe773aa04032324341c878c988c | Errata E7; Fixture Package §6 |
| scheme.prompt-invocation.structural.0 | stable-ref-scheme-identifier | 0 | 70 | e2c9505e4b7f63d8f410d80b8f588b07fc776e164780c108b92d0d5c03457b68 | Errata E7; Fixture Package §6 |
| scheme.scope-calculus.structural.0 | stable-ref-scheme-identifier | 0 | 67 | 024208d4b5a07601d2e36fbe2c12198e7ff32d90d7886df4179b803a5a60eb4c | Errata E7; Fixture Package §6 |
| scheme.semantic-boundary-calculus.structural.0 | stable-ref-scheme-identifier | 0 | 79 | c039f12adfe728a436889d429b60afdcaa0859fc8449578503244570cb2d9f58 | Errata E7; Fixture Package §6 |
| scheme.temporal-model.structural.0 | stable-ref-scheme-identifier | 0 | 67 | 5f98159056cefc8020893770ca9d455a68ddb68a1228e738e26cb1fba1d2e5ae | Errata E7; Fixture Package §6 |
| scope-expression.dept-operations | scope-expression | 0 | 440 | 11e1a197b1c211c83d41c6cef9546e122f252e3f7b051236067e15a655853de2 | Errata E1/E4; Fixture Package §2 |
| scope-expression.dept-research | scope-expression | 0 | 438 | 02be9016f2e4926640fb78435e2b1c09c4d86706849cb22a8ac6a9372c3f99bb | Errata E1/E4; Fixture Package §2 |
| scope-expression.org-acme | scope-expression | 0 | 336 | e87e8d101a094d05b288b6650828ce37a8d65880d2a004e6525641e6a7612e25 | Errata E1/E4; Fixture Package §2 |
| scope-expression.region-east | scope-expression | 0 | 325 | beeeed70c95c9285a1e57751d7c13591fbdd181fcd81a5b5781c8a8292ea621b | Errata E1/E4; Fixture Package §2 |
| scope-expression.region-north | scope-expression | 0 | 326 | 8196ec8ae209def4a08a017d8c969ed140c0354c513fe328f04e56cea2a5de13 | Errata E1/E4; Fixture Package §2 |
| scope-expression.region-south | scope-expression | 0 | 326 | 173f73c2b49596cc6b3c8670b787e575a390356b2abaac4e1ea6e11115135e89 | Errata E1/E4; Fixture Package §2 |
| scope-expression.region-x | scope-expression | 0 | 378 | d7c2837026919b0f8b9b1fbc568efafc35903b6162cc940f7062df3d9f5aa939 | Errata E1/E4; Fixture Package §2 |
| scope-expression.region-y | scope-expression | 0 | 378 | 6bf623d93e31c97c1ffebfc5b36a6ee98b2647198f9d2946710db896f00370cc | Errata E1/E4; Fixture Package §2 |
| scope-expression.second.alpha | scope-expression | 0 | 333 | 065f139d80c2bb69dfafea65372edfc43bd2b776d8057f31b132f518e1cb09da | Fixture Package §2 |
| scope-expression.symbolic-unknown | scope-expression | 0 | 397 | a1b28c1ad016d5da053e8d2cc818399456e245de5c5a168d2d4757a5a8640482 | Errata E1/E4; Fixture Package §2 |
| scope-expression.tenant-a | scope-expression | 0 | 419 | 9de0c541caafbd85d2bae4fd422670f38610c9106fdd48ba659e5d2f68d45945 | Errata E1/E4; Fixture Package §2 |
| scope-expression.tenant-b | scope-expression | 0 | 419 | 0179907aeba8743bec50566ad041e1804192f143bf59f7b31c584e9b21fb3caf | Errata E1/E4; Fixture Package §2 |
| scope-expression.universal | scope-expression | 0 | 229 | 94ace6e327423bc412e33e7eae843613eb2b27593b45fce47f25abbe455ef1bb | Errata E1/E4; Fixture Package §2 |
| scope.calculus.primary.definition.0 | scope-calculus-definition | 0 | 391630 | 7366618aee175c0355f96c40403329ff06dc474d8a44f1d99c77ffade8606f52 | Fixture Package §2 |
| scope.dept-operations | scope | 0 | 1147 | 129a377dee08b1cb37a2f1eae5bc3eba7cadaf851efe153cafc2b473dc0b8439 | Errata E1/E4; Fixture Package §2 |
| scope.dept-research | scope | 0 | 1145 | cf1b530ca3516d09d5005768d094224d1f9ddcf9f7ec4bcb0ba06537d8fad09e | Errata E1/E4; Fixture Package §2 |
| scope.org-acme | scope | 0 | 1043 | bd16a10c498ab573c1414962835a172bcbd7d826cafa8523edf04c0393a2afd0 | Errata E1/E4; Fixture Package §2 |
| scope.region-east | scope | 0 | 1032 | 6d5a57ade3e7155bfbe5c45c979461d83b01d7c88deca037232da03bc2b02f52 | Errata E1/E4; Fixture Package §2 |
| scope.region-north | scope | 0 | 1033 | 26c99858ace7753e35d2f07af79b6cb461bd6c9c2611fb8113d9ec8867a8c5ae | Errata E1/E4; Fixture Package §2 |
| scope.region-south | scope | 0 | 1033 | 14b5f63a0274483c0f27d1be723e79bbb1014a69b55bbede3754540e353260bc | Errata E1/E4; Fixture Package §2 |
| scope.region-x | scope | 0 | 1085 | 4b380466b040792b83542399864f125c078a301008b9cf6d394bd08a70dd92c0 | Errata E1/E4; Fixture Package §2 |
| scope.region-y | scope | 0 | 1085 | 6713f3b6af353e23d09a18a477286475facf9968b81a52ad783368786436d522 | Errata E1/E4; Fixture Package §2 |
| scope.relation-table.0 | scope-relation-table | 0 | 389416 | 1705816297f0c5523d3f82a8b629d9207515c3b88a104d36cbde2246c590ae23 | Fixture Package §2 |
| scope.second.alpha | scope | 0 | 1045 | d838f41482ada1c0824ff35b95d2940311036e02fcba0312021c0b40854f5925 | Fixture Package §2 |
| scope.symbolic-unknown | scope | 0 | 1104 | 60abb851c688d9507cdb486b853dd65f4de043dfebcfdc77e163cbb8cb4091e7 | Errata E1/E4; Fixture Package §2 |
| scope.tenant-a | scope | 0 | 1126 | eaca3bc74af8a01c6b14397a54077d4fe2fed930f0cbad2cf8e3a2f245d48d6d | Errata E1/E4; Fixture Package §2 |
| scope.tenant-b | scope | 0 | 1126 | cddd12802cff2c6492c61b8a7a6743f18771a5d3779c3bfa43b212f3c2a39a02 | Errata E1/E4; Fixture Package §2 |
| scope.universal | scope | 0 | 936 | d2b4a25a8001500574f676020517d165177e36e99d202bd6e7ea5570a35e07b0 | Errata E1/E4; Fixture Package §2 |
| semantic-boundary.log-horizon-124 | semantic-boundary | 0 | 1908 | 0f43ea40ab5242505c91e028584436a4c3890bffcbc5acaf47c33ebdc54fe3fa | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.log-horizon-130 | semantic-boundary | 0 | 1908 | 3b0cdd7f14a5127296eda8b53a7584587e8aae5d81fb8d4a271551a12ac163a9 | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.manifest-alpha-3 | semantic-boundary | 0 | 1601 | 09997c447258e08690e82622111407cc8f4595ce09f870208cc23b711a1d1982 | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.manifest-alpha-4 | semantic-boundary | 0 | 1601 | 97b504d0a20e6fa9e75c9b0b6de0a400d8e9640c0cd729386ed4d7e84f47d285 | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.not-applicable | semantic-boundary | 0 | 1013 | 0db0dedf17bab2acd9239fb63823d0cf303029898248a08b15a8030ac6e52ad6 | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.path-root-docs | semantic-boundary | 0 | 1174 | c26531802afb4efa9188a3f4a35f651dd522be639ba8d618f72a60a63183f70d | Errata E1/E4; Fixture Package §4 |
| semantic-boundary.path-root-src | semantic-boundary | 0 | 1173 | 24b1ca53cb9b159be77bceb658c2d3c01c075b1d65124e59ce5698ac907d7df4 | Errata E1/E4; Fixture Package §4 |
| slice-expression.all-members | dataset-slice-expression | 0 | 239 | f58e6c1280cb2b32b329c99acf80d8b5676ffe9bd3709351f13712637fd1b3b7 | Errata E1/E4; Fixture Package §4 |
| slice-expression.file-alpha-only | dataset-slice-expression | 0 | 828 | 4da2d0ab1dc6d1c49faf07ceac26206314c9ad642dd66924a0023dfc177ffc74 | Errata E1/E4; Fixture Package §4 |
| slice-expression.files-alpha-beta | dataset-slice-expression | 0 | 1368 | f5c1fb352d2e69aa13acc610d0efaef1f726ef76164608e2f14ca3ff002fefae | Errata E1/E4; Fixture Package §4 |
| slice-expression.predicate-file-prefix | dataset-slice-expression | 0 | 1049 | 69996207cd61915cbbef0ee923dc1027e066c17a46261cdeb5409c9e4661bbe3 | Errata E1/E4; Fixture Package §4 |
| slice.calculus.primary.definition.0 | dataset-slice-calculus-definition | 0 | 1449 | 20d62c6b580d5f2a4229f0071abede3959d5e5157f983971d88d5b72295e601e | Fixture Package §4 |
| stable-ref-bridge.external-artifact-source-to-lci-fixture.0 | stable-reference-bridge-definition | 0 | 1551 | c11e55e69681ab8b0491d901fd15ae3de373d9bd947d8d9dbde3d7aad0275ce1 | Errata E7; Fixture Package §6 |
| stable-ref.artifact.code.execute-call.0 | stable-reference:artifact | 0 | 551 | eebc01a842ca4f0c0d816bdf01e85f7f1ba65e580261ae1be2a719a71db4681c | Fixture Package §6 |
| stable-ref.artifact.code.observe-file.0 | stable-reference:artifact | 0 | 551 | 67d28b888a392be9a03285f70685229ca2c726045f680077ac25f20fa830e6b3 | Fixture Package §6 |
| stable-ref.artifact.code.search-corpus.0 | stable-reference:artifact | 0 | 552 | 4134e535b560347bdf1af94e1d7be9d6127c7e55635105f46461c5a8d3889368 | Fixture Package §6 |
| stable-ref.artifact.file.alpha | stable-reference:artifact | 0 | 546 | 86315a57efa3c7ac3c258589d0645a28dd18cbbb2206e87a8828e19f73812f9d | Fixture Package §6 |
| stable-ref.artifact.file.beta | stable-reference:artifact | 0 | 545 | ccb52d582b0ef0e6dda52e3845db1b769eabf210c08472350012020be0f02e15 | Fixture Package §6 |
| stable-ref.artifact.manifest.alpha.3 | stable-reference:artifact | 0 | 548 | ef7eed8d3cfb54fb39bc47fea8e624b33284f438ee91645b0fa78de2497c3b1e | Fixture Package §6 |
| stable-ref.artifact.manifest.alpha.4 | stable-reference:artifact | 0 | 548 | 275a02f3eace3b95a773c810d8b9814cbc07bc42d1953efe584cb28f27ffd2bf | Fixture Package §6 |
| stable-ref.artifact.migration.as-of-table.0 | stable-reference:artifact | 0 | 560 | 5c39d07d60e51624df38abc89a7f12620c81728d4b1b75361b71e770c2f4b121 | Fixture Package §6 |
| stable-ref.artifact.migration.classification-map.0 | stable-reference:artifact | 0 | 568 | 97ece3a0fd6bea0f6458237a78fcdb83311d32244ca45b35fff1fa55463cd16c | Fixture Package §6 |
| stable-ref.artifact.migration.grammar.0 | stable-reference:artifact | 0 | 559 | ff313ff7a57fde1a1abc3789b47a68b5ef2680c36da21b2a1b252660f1621bd3 | Fixture Package §6 |
| stable-ref.artifact.migration.symbol-table.0 | stable-reference:artifact | 0 | 564 | 022068cdfbdfe2b27564d8065653406e48b778f4be4604fbece7100456c71df1 | Fixture Package §6 |
| stable-ref.artifact.normalizer.ledger.0 | stable-reference:artifact | 0 | 589 | 7bc71ae193ccb8b5f5072c4e51b8c25d7bd28dfb1cd313d129ea30edb998a0de | Fixture Package §6 |
| stable-ref.artifact.normalizer.mutation-vector.0 | stable-reference:artifact | 0 | 578 | 48c6db6e0f8de22c83f2e9eeeb1f73e146f4fad4edda08bec9fdee56d88f34c0 | Fixture Package §6 |
| stable-ref.artifact.normalizer.source.0 | stable-reference:artifact | 0 | 579 | f0e84ab4ae7cb90212f7d43e3cbbd1439e52630164b18ea517b7daaf1cae5af3 | Fixture Package §6 |
| stable-ref.artifact.occurrence.predecessor | stable-reference:artifact | 0 | 554 | 83625f99b611dbfe148a0bdd1963bd2e88a13357c949606fbde3dc5c791c3290 | Fixture Package §6 |
| stable-ref.artifact.ontology.animal.1 | stable-reference:artifact | 0 | 549 | 55b5d0bc01d13c9205b5a7f34831915d5254f329cedd91effc30765000821c38 | Fixture Package §6 |
| stable-ref.artifact.ontology.vehicle.1 | stable-reference:artifact | 0 | 550 | 8a98200c81a24c09065f3697b4b5b3f6ef2762c5d784b8a17690abc7186336fd | Fixture Package §6 |
| stable-ref.artifact.receipt.external-map.1 | stable-reference:artifact | 0 | 554 | 9bdce2070beb220b8c8cecbf9fcd086f1cc779a53c5deedd903d0dd2102ba86d | Fixture Package §6 |
| stable-ref.artifact.receipt.handoff.1 | stable-reference:artifact | 0 | 549 | 83389e2b8a0694ae7cff87d6c4a69ef57763be60cc7cdb5dd9fbb9186665de87 | Fixture Package §6 |
| stable-ref.artifact.receipt.migration.1 | stable-reference:artifact | 0 | 551 | a70c9774015b269a14f7fa23f91bfc9b3edc70aa88b07c96b4798396554b0372 | Fixture Package §6 |
| stable-ref.artifact.receipt.report-interpretation.1 | stable-reference:artifact | 0 | 563 | 735f31cea895d4eb5e1a5ae16e0cdabd58430971115571f742fc48aa81f70008 | Fixture Package §6 |
| stable-ref.artifact.receipt.translation.exact | stable-reference:artifact | 0 | 557 | 352c10aa4651fac5b4dff8a3fb431383d3ab2dd83bbb15119e6e8a1edd4caea1 | Fixture Package §6 |
| stable-ref.artifact.receipt.translation.lossy | stable-reference:artifact | 0 | 557 | 2217c8866f8463f5ad7dbaf7bf0fd2c7812d9cf5884e6b26b69a7f4d636d73be | Fixture Package §6 |
| stable-ref.artifact.schema.measurement.1 | stable-reference:artifact | 0 | 552 | c75097259de55865c2b4a611f0d95de2eda0dfd2aee1373f22a730ec2673914b | Fixture Package §6 |
| stable-ref.artifact.schema.measurement.2 | stable-reference:artifact | 0 | 552 | d21dfe38189a0a2f370d519c84ac6cddc9e30387f41c3e3415b81e2918fa1d72 | Fixture Package §6 |
| stable-ref.artifact.source.v1.1 | stable-reference:artifact | 0 | 550 | 7dd7eb144716be75d2d90b5ff7a10906d76bbfe0063efa00c99df27d9c12f59c | Fixture Package §6 |
| stable-ref.artifact.source.v1.2 | stable-reference:artifact | 0 | 550 | 07f1a23151e374b7b7f57fb3f74811e82948c4c13b5b19c281b14591760a79bb | Fixture Package §6 |
| stable-ref.artifact.source.v1.hostile | stable-reference:artifact | 0 | 556 | f4ef092b9867159e576ae094b9664a3085ce88daefa0035642d11a2c87c70bc5 | Fixture Package §6 |
| stable-ref.artifact.state.policy.snapshot.100 | stable-reference:artifact | 0 | 557 | c42875a6cc1a1396c37c3525053db0f9c143289b34b2496153e78ac3c77de076 | Fixture Package §6 |
| stable-ref.artifact.state.policy.snapshot.300 | stable-reference:artifact | 0 | 557 | 4842733e05575b525e1fd8d320910ed7b039b859ba634a75337831cd4a3ca7fa | Fixture Package §6 |
| stable-ref.artifact.test-suite.stable-ref-bridge.0 | stable-reference:artifact | 0 | 562 | 9414451e7a0a0d4cad7681980215c0dada170a6c9d411a9f13ed66570ffc555f | Fixture Package §6 |
| stable-ref.artifact.test-suite.target-schemas.0 | stable-reference:artifact | 0 | 559 | d642e44c75ce32493335e20ccfe356768f8946932212913b65bdf76a4bb6295c | Fixture Package §6 |
| stable-ref.artifact.trace.derivation.1 | stable-reference:artifact | 0 | 550 | 9f21cabd637293148afdfb56b31ef28d15afefc1a901ca7a33d32e55ddb78bd4 | Fixture Package §6 |
| stable-ref.artifact.trace.execution.1 | stable-reference:artifact | 0 | 549 | c27a1411fedcb3c6889cd39fd3a8226fde61404344fe1dae62f4f46cf2cc422e | Fixture Package §6 |
| stable-ref.artifact.trace.observation.1 | stable-reference:artifact | 0 | 551 | 166d0613e88c87f2862454cb81d471a4130ea0d80397811937ec0919ed7729aa | Fixture Package §6 |
| stable-ref.artifact.trace.replay.1 | stable-reference:artifact | 0 | 546 | e3981e49efc4878c367add38f84c17de1127d423fe34a68d2086612a0fb9d4b4 | Fixture Package §6 |
| stable-ref.artifact.trace.search.complete | stable-reference:artifact | 0 | 553 | bd612304cee7a66c0a5c854ff29f883e8fb04b571602c56c63370d7b3df687b7 | Fixture Package §6 |
| stable-ref.artifact.trace.search.incomplete | stable-reference:artifact | 0 | 555 | 9a10f9047dc47e51e97c1f3e320c29207eabf41ac946398cee830f1d91ba045d | Fixture Package §6 |
| stable-ref.artifact.trace.test.1 | stable-reference:artifact | 0 | 544 | e9956a046ded099cbd79395206c2f6c0b0812a4cc7b9927880a751b36e060909 | Fixture Package §6 |
| stable-ref.artifact.warrant.inert.predecessor | stable-reference:artifact | 0 | 567 | 2f46b0b401ea75e9f419fe81987e2b221e65ef0b3b24c3d2bbbbbd87482d808d | Fixture Package §6 |
| stable-ref.boundary-calculus.primary | stable-reference:semantic-boundary-calculus | 0 | 608 | 990efe70bc2ad462f7f41c3c757517be16591641d255b8fb91086e90f8b66375 | Errata E1; Fixture Package §4 |
| stable-ref.corpus.alpha | stable-reference:logical-corpus | 0 | 562 | 11cb1548999eacd55861a7ca757099897cdb711cbc84a4f842a8fa84b9271b92 | Fixture Package §6 |
| stable-ref.corpus.beta | stable-reference:logical-corpus | 0 | 561 | d777e59ef1e52209ddffe6361cff9abe1e938a2a881b2913488334f4a3285e79 | Fixture Package §6 |
| stable-ref.frame-schema.primary | stable-reference:interpretation-frame-schema | 0 | 608 | d9849523d9d3b541805b0b2140fd1d95c780313c3406c0989f2b19f6af05342a | Errata E1; Fixture Package §5 |
| stable-ref.invocation.call-17 | stable-reference:prompt-invocation | 0 | 566 | 904c27b0d2da81aa9399928c2ded8821ab731babe775d7b728f8bc9d6eb9cc34 | Fixture Package §6 |
| stable-ref.invocation.call-18 | stable-reference:prompt-invocation | 0 | 566 | 32442201d26a3b18af694235cbeb0361ac7b381f0801f4a37195d1c2d5494c21 | Fixture Package §6 |
| stable-ref.invocation.prompt-a.model-alpha-1 | stable-reference:prompt-invocation | 0 | 581 | 8beab1363232c08e0a42762b3713992b6edafe79ec3d7d9e3901a6bbecc80314 | Fixture Package §6 |
| stable-ref.invocation.prompt-b.model-alpha-1 | stable-reference:prompt-invocation | 0 | 581 | a988312ebc904f98bec68afe25a0af56048d13b2915e5e351a464abefeff6e0b | Fixture Package §6 |
| stable-ref.model.alpha.1 | stable-reference:model | 0 | 534 | 64c9a337d42c76603017f8d197a9be546012adbdba8dbf6baacbff75a55634f1 | Fixture Package §6 |
| stable-ref.model.alpha.2 | stable-reference:model | 0 | 534 | 3025273b7eb580626c0d9613ea4f9d6c91653053a2566402178c63b162ad0a39 | Fixture Package §6 |
| stable-ref.model.beta.1 | stable-reference:model | 0 | 533 | e58f9a0ae643bb6f1960be0400d3c31d5359f048d934230b544b29da09194a38 | Fixture Package §6 |
| stable-ref.module.execution-environment | stable-reference:module | 0 | 555 | 5ae4fd610368d285f8272397cb5aa225eaf9b6be74f8451e59abaaa3c7c2ee98 | Fixture Package §6 |
| stable-ref.module.inference-calculus | stable-reference:module | 0 | 552 | f53e96de44c707201f8ad22e430a1a27e9d530ee3a828ef6ca08b49497aaff61 | Fixture Package §6 |
| stable-ref.module.mneme-fixture-profile | stable-reference:module | 0 | 547 | a35c6746d92b7c4841075a4a3cc759acf1bf1b24f4f5cf5c8690c3e882edd89a | Fixture Package §6 |
| stable-ref.module.target-schemas | stable-reference:module | 0 | 554 | 133575f6f852b277a122970207dfd73544aa1536ca9c16a1b2e41ea5801fccb1 | Fixture Package §6 |
| stable-ref.policy.a | stable-reference:policy | 0 | 548 | 50c6b9c5402f32362935f0f1b2525812530cd420a7959e8cd5f14e63e879962a | Fixture Package §6 |
| stable-ref.policy.b | stable-reference:policy | 0 | 548 | c3668765ebd3d7cc772fc3163771e19a038adcd83b2f8e756824dce1997dbce4 | Fixture Package §6 |
| stable-ref.policy.fixture-digest-zero | stable-reference:policy | 0 | 565 | 49c3bc49ea18fe494be1fce206e874f9b10ce477003ae2843b0e6751f343510b | Fixture Package §6 |
| stable-ref.policy.handoff | stable-reference:policy | 0 | 538 | bb14a22789f98fdb24b2a3930ed6e4506b38a2a852e5b940751c5480f70593de | Fixture Package §6 |
| stable-ref.principal.claimant-alpha | stable-reference:principal | 0 | 549 | fb2b39f8cf2cde08e126bbfe8ac644e7c26b2d0811c7561353bd32d262cc0704 | Fixture Package §6 |
| stable-ref.principal.claimant-beta | stable-reference:principal | 0 | 548 | 1e9d3bf02757afc321201fdbd58c499c03aa14fc5de709510d7195cfdbf67f66 | Fixture Package §6 |
| stable-ref.principal.external-trusted | stable-reference:principal | 0 | 551 | 2948af2624f6e892932212bb6c9f6a7f70f0f699b92bdddc159d2afbba1d00ef | Fixture Package §6 |
| stable-ref.principal.external-untrusted | stable-reference:principal | 0 | 553 | efb2a4dff0cbda2e0da5463d599f739ffb319090d08398652159a70ce0e4c830 | Fixture Package §6 |
| stable-ref.principal.instrument-alpha | stable-reference:principal | 0 | 551 | a5d37bf9eda18551083db7a08cb05bd5e1ead015969d1e2c239ee5569686e172 | Fixture Package §6 |
| stable-ref.principal.reporter-alpha | stable-reference:principal | 0 | 549 | 7b6c7414755ab32097500f18121574d7c20e0535d75709c09cec127e0d8ca9c6 | Fixture Package §6 |
| stable-ref.procedure.classify-temporal-role | stable-reference:procedure | 0 | 557 | 274daa969643e20712ab4c66881a1dc85d98d4766b1f959086412b9fa9c35d1d | Fixture Package §6 |
| stable-ref.procedure.compact-occurrence | stable-reference:procedure | 0 | 553 | 8506fa6221160b1084a8de662225d061436faee50061d7c7c660ef14b7ba5144 | Fixture Package §6 |
| stable-ref.procedure.derive-rule | stable-reference:procedure | 0 | 546 | f5b63d30ed478ab543efdcd18a8317a30bc2a65c6f9b60a7b50735c776b4dca2 | Fixture Package §6 |
| stable-ref.procedure.evaluate-policy | stable-reference:procedure | 0 | 550 | 6f056e3e00a3f8024ed81c1590216a575dc5202a7a27f382be0a139fb01ee72d | Fixture Package §6 |
| stable-ref.procedure.execute-call | stable-reference:procedure | 0 | 547 | 6c6abd74fe50482014c38f0d97af27213ca87cbaaf22a053f9ff82df502af597 | Fixture Package §6 |
| stable-ref.procedure.external-map | stable-reference:procedure | 0 | 547 | 9d6eb4dedcbe42880a8a604d8952748014b6b18d5d471e822e3878ac4ce0c419 | Fixture Package §6 |
| stable-ref.procedure.handoff | stable-reference:procedure | 0 | 542 | 5dded9adbf7c1ced693510c82c40cf80bac9abe3386bc015c710ea69d221553c | Fixture Package §6 |
| stable-ref.procedure.identifier-map | stable-reference:procedure | 0 | 549 | 3fd231537e69ff246940344c5fdc37788314552a40afb6bdd5d2813af8686c03 | Fixture Package §6 |
| stable-ref.procedure.interpret-report | stable-reference:procedure | 0 | 551 | e8a80c115a5aabffbf73d932fde3fe65db0fd7893e60964adf39e44d72ae72f9 | Fixture Package §6 |
| stable-ref.procedure.migrate-v1 | stable-reference:procedure | 0 | 545 | f3515ad95b92788c8be3e3385f02a1d0b62ada11e87a6c5aecc8da81c548a7ca | Fixture Package §6 |
| stable-ref.procedure.mneme-proposition-normalizer | stable-reference:procedure | 0 | 563 | a26d743cd1baed29b6670ad0291bfb3773e750ba6d529d51dcbb05c7c71f251a | Fixture Package §6 |
| stable-ref.procedure.observe-file | stable-reference:procedure | 0 | 547 | 338e9cb6fefb73a070cd1a409b2a2378ccb7c86ac8ab3037385075baf98e79d1 | Fixture Package §6 |
| stable-ref.procedure.reconstruct-claim | stable-reference:procedure | 0 | 552 | d47df5b294af3e7f553da5e9ed0888be0e809d627be9dfdd13ddd06c31eebfb7 | Fixture Package §6 |
| stable-ref.procedure.replay | stable-reference:procedure | 0 | 541 | eaa70b97b7cba99f2b4e79a67eb49c5dde5f26ab5f87e75132e1b3cf63dc6682 | Fixture Package §6 |
| stable-ref.procedure.run-test | stable-reference:procedure | 0 | 543 | ded888d8c55cc511e5d4eec9b79537952209514a8de7c45b3b13bcd9a25179fb | Fixture Package §6 |
| stable-ref.procedure.search-corpus | stable-reference:procedure | 0 | 548 | ac184688f48e2dea8a6cdf57cdc706993a56f9e5b73814effc76a796dce11775 | Fixture Package §6 |
| stable-ref.procedure.translate | stable-reference:procedure | 0 | 544 | a407cd1116e67b5e83d7748c85e1ec79efd7a8fbcfed6b05a64bd24d6af36abe | Fixture Package §6 |
| stable-ref.revision.alpha.3 | stable-reference:immutable-corpus-revision | 0 | 606 | de592c9393d7324c0049bae92d3ad7f84227e763bfe4ce110dee8a1d8a97c20b | Fixture Package §6 |
| stable-ref.revision.alpha.4 | stable-reference:immutable-corpus-revision | 0 | 606 | 07cf974fe786b1f9389e402535810170e2601cc697b501aba7681ae939dcd27e | Fixture Package §6 |
| stable-ref.revision.beta.1 | stable-reference:immutable-corpus-revision | 0 | 605 | 04a126db2396331a5035b8826ad386189dc82881d877514a3c94d6074c2f8fa7 | Fixture Package §6 |
| stable-ref.scope-calculus.primary | stable-reference:scope-calculus | 0 | 563 | 921327537a5f57fe9ec57e2c25b4ddef305785350f9c3aff549fea15b82fcd52 | Errata E1; Fixture Package §2 |
| stable-ref.scope-calculus.second | stable-reference:scope-calculus | 0 | 568 | 341491cc33ce1ab74ad9172e29ab7c63d3a2bfd8028de7622d039e09b636deb0 | Fixture Package §2 |
| stable-ref.slice-calculus.primary | stable-reference:dataset-slice-calculus | 0 | 593 | 6f5d38ee64318d07583e454c06f6b37388afc0453931e2abc2bc26fa4c83b017 | Errata E1; Fixture Package §4 |
| stable-ref.target-schema.corpus-completion | stable-reference:module | 0 | 557 | 537a07e862cb4c291c23768bbe714022cc575dc4abd02634a14bedf95eb086c4 | Fixture Package §7 |
| stable-ref.target-schema.derived | stable-reference:module | 0 | 547 | d3e43d3dd90000850ef79a1e55639a6195a6b499f982c0a3ae412e305c8c820b | Fixture Package §7 |
| stable-ref.target-schema.executed | stable-reference:module | 0 | 548 | befcabd99316b95713caaf8a551fc92e2bbdd0fe45d2b8633916332e1d2ee779 | Fixture Package §7 |
| stable-ref.target-schema.externally-attested | stable-reference:module | 0 | 559 | 335dc0486c146730b5accb4425fedd0b726868a0b1099a4c30dea5e916deba38 | Fixture Package §7 |
| stable-ref.target-schema.inherited | stable-reference:module | 0 | 549 | 635c8a0c83e0ec2b5bae576ad82f65c9b270c09eda2d3b33d44dbf2c97888987 | Fixture Package §7 |
| stable-ref.target-schema.observed | stable-reference:module | 0 | 548 | a25e9d8397b6e8782da6d1cf2ad2f67e547186769f32bab19c6fe58e67a32354 | Fixture Package §7 |
| stable-ref.target-schema.policy-evaluation | stable-reference:module | 0 | 557 | 2bc878e2e29208f193a0039a5d584fff081b0d57b8af0ce456fa9491d9f476d2 | Fixture Package §7 |
| stable-ref.target-schema.replayed | stable-reference:module | 0 | 548 | 11d0f79666277882eeb39c65b27cbe1e7e0a765362057743f09257bd62811de2 | Fixture Package §7 |
| stable-ref.target-schema.reported | stable-reference:module | 0 | 548 | 17f0252d04edeafa6acb8d1b78a33a13a69c3737184c248d4aec74867d14cd3e | Fixture Package §7 |
| stable-ref.target-schema.tested | stable-reference:module | 0 | 546 | 184dd38df0dbc2da3621b775f65eedeb728083570db376c033a5f0acd794512f | Fixture Package §7 |
| stable-ref.target-schema.translated | stable-reference:module | 0 | 550 | c73b50243324f71df3f9f5da87ee539d8e2ed209f2a6945d32bf36d037c0f008 | Fixture Package §7 |
| stable-ref.temporal-model.primary | stable-reference:temporal-model | 0 | 568 | 17dff931bdd5206ab255522940ba4ed77fbe4764ae5ccf48fc973e7933814165 | Errata E1; Fixture Package §3 |
| stable-ref.temporal-model.second | stable-reference:temporal-model | 0 | 568 | 5e3a676ac5dc9b820a3ec8fe0a77c331cb57b11b13622f149d79090bb10f797c | Fixture Package §3 |
| subject-time.atemporal | subject-time | 0 | 960 | 5bb34bdb9115789ff4a9f900ae011cac63c558c5641d7eae3a317883f152824e | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-0 | subject-time | 0 | 998 | 422f38a270ef669c0294308b15befe176165e08c0e1dbc323c6cde68b1991c52 | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-100 | subject-time | 0 | 999 | 24454893597d6ae21d1d07519bf8d428847357845e4c7d658323009c6104f09b | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-101 | subject-time | 0 | 999 | d780b9954485a629ae15f075561915667543ea0f7d5a9677950bd2c888879052 | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-124 | subject-time | 0 | 999 | 131ac482753443e6b67bfa51d76b2df390b935ae97c8e3b82bb634fa55d3afdc | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-130 | subject-time | 0 | 999 | 507f9196f9771924d5d5facc6aabfbf7ee1915d848e795402d77f8782a1f00be | Errata E1/E4; Fixture Package §3 |
| subject-time.instant-300 | subject-time | 0 | 999 | 32a8844693eca93bb629f9d2c603d69501610c645b84069fc84ca0ca61950858 | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-0-50-closed | subject-time | 0 | 1131 | 4ce12a68a9346c0e529e708ed1e86dbe8e576b5ca61f4c5f9f51b7df4ba9113a | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-100-124-closed | subject-time | 0 | 1133 | acd5699a9dd977f6a5215663374538022a28cc0a0690ea96a6d1632bac780a0c | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-100-124-left-open | subject-time | 0 | 1133 | 829ec613dfca74422822af44c2aea6725dfce07b3e0217f2a820d0e26617d3c0 | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-100-124-open | subject-time | 0 | 1133 | e17f8fdbb27a65a9a97547e9a13523e8f996b0b8f3669917fd1ee4359d0d279e | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-100-124-right-open | subject-time | 0 | 1133 | 0a5f55ad3ced13245521861a8276374875daf1883d0f830beb27a3b9d04f4214 | Errata E1/E4; Fixture Package §3 |
| subject-time.interval-200-220-closed | subject-time | 0 | 1133 | 3fd8b45fe12a71c44e5bbdf0d4ea48636104fb0acd232c05c8549990f45555ab | Errata E1/E4; Fixture Package §3 |
| subject-time.periodic-even | subject-time | 0 | 1051 | 5e69d535e665b0ca822c42ab69f0b79f00c4f8faf39c21894e1710df508956f7 | Errata E1/E4; Fixture Package §3 |
| subject-time.periodic-odd | subject-time | 0 | 1051 | 30c74426e9382a0c53e88686865a0a6de5461a909f504db580e6654094bb554f | Errata E1/E4; Fixture Package §3 |
| subject-time.second.alpha | subject-time | 0 | 1064 | 0bc2b64303d76baf702c2871da83718789e5e93d9163a1cbcb2a2edba1dfc554 | Fixture Package §3 |
| subject-time.symbolic-unknown | subject-time | 0 | 1063 | 1fd61f7d93cf505ff972c86c0d9c624248aa3c0d6200a36e4d84c632e938e156 | Errata E1/E4; Fixture Package §3 |
| target-boundaries.corpus-completion.absence-docs.complete | target-boundaries:corpus-completion | 0 | 15528 | fcdb931ebd29361b1048e4fd4c2f8cd145e8c6fbc301f43f1de13ad165ae2aef | Fixture Package §7 |
| target-boundaries.corpus-completion.absence-docs.incomplete | target-boundaries:corpus-completion | 0 | 15530 | 062b19ff488d2392a54017fafdfb8f81b2f86028616af9e8c954eb719b5977a2 | Fixture Package §7 |
| target-boundaries.derived.one-equals-one | target-boundaries:derived | 0 | 11139 | 13c4689aa01766e6ea3e7f3547852b6392631f4bce298fc48ce681b8810594f5 | Fixture Package §7 |
| target-boundaries.executed.call-17 | target-boundaries:executed | 0 | 5226 | d3aa10207eae3107cf7f20ad1215c15915c730f3c6a30e4a4550a3ab7d84f88c | Fixture Package §7 |
| target-boundaries.externally-attested.file-alpha.trusted | target-boundaries:externally-attested | 0 | 4007 | 977d58cdfe8ea5904bc81287c61fe67b6fdbc730e4b79ea32ae673d03f427c41 | Fixture Package §7 |
| target-boundaries.externally-attested.file-alpha.untrusted | target-boundaries:externally-attested | 0 | 4009 | 3e4595d62bffa92ccfed1c91f4e5f940ae4f9bbe1ac18aad5747430eafce70d4 | Fixture Package §7 |
| target-boundaries.inherited.file-alpha | target-boundaries:inherited | 0 | 7219 | b10e500a3a1cb532d190926786d60fe6a72bb301dcba06d3edd29c838a434ab4 | Fixture Package §7 |
| target-boundaries.observed.average.org | target-boundaries:observed | 0 | 4235 | 74b77acfb894ab63d4d18e5bdec581419222227b3aa71f7b54aaa84cd6b965bd | Fixture Package §7 |
| target-boundaries.observed.file-alpha.alternate-procedure | target-boundaries:observed | 0 | 4119 | 85fbae61e87ac37806d4841ffafce0f08679547835b8a340fd606c90acd92e62 | Fixture Package §7 |
| target-boundaries.observed.file-alpha.animal | target-boundaries:observed | 0 | 4115 | 7061f40dcec3c5095010768d3ef1b906bd27c390f965434d5426e24d7be11244 | Fixture Package §7 |
| target-boundaries.observed.file-alpha.corpus-r3 | target-boundaries:observed | 0 | 4115 | 7061f40dcec3c5095010768d3ef1b906bd27c390f965434d5426e24d7be11244 | Fixture Package §7 |
| target-boundaries.observed.file-alpha.exact | target-boundaries:observed | 0 | 4115 | 7061f40dcec3c5095010768d3ef1b906bd27c390f965434d5426e24d7be11244 | Fixture Package §7 |
| target-boundaries.observed.file-alpha.region-x | target-boundaries:observed | 0 | 4264 | afc2ec2671965b3a438972611777c3fe25d8de9a567adb0a4b3309f9a4bbd8e6 | Fixture Package §7 |
| target-boundaries.observed.file-alpha.yesterday | target-boundaries:observed | 0 | 4115 | 7061f40dcec3c5095010768d3ef1b906bd27c390f965434d5426e24d7be11244 | Fixture Package §7 |
| target-boundaries.observed.universal-property.dept | target-boundaries:observed | 0 | 4337 | cec2b46dc222530553847f506ee6ef02b37f4aee3fbac504bdedaa448fa036bd | Fixture Package §7 |
| target-boundaries.observed.universal-property.insufficient-coverage | target-boundaries:observed | 0 | 4306 | a2bc11883de6d69b7648ebd2db2a3f6fdeec6176ebb226d05122be45f4d445d6 | Fixture Package §7 |
| target-boundaries.observed.universal-property.org | target-boundaries:observed | 0 | 4235 | 74b77acfb894ab63d4d18e5bdec581419222227b3aa71f7b54aaa84cd6b965bd | Fixture Package §7 |
| target-boundaries.policy-evaluation.file-alpha.meta | target-boundaries:policy-evaluation | 0 | 4511 | 1535fff693a97e267348e70ef363a52fc3ff234f584bd81cf5ed1b7640fc4d4d | Fixture Package §7 |
| target-boundaries.replayed.file-alpha | target-boundaries:replayed | 0 | 5851 | f11d2c0844fa7327f537eab4b81ced1e640d916a4b6426c3bab8ee6359786eb8 | Fixture Package §7 |
| target-boundaries.reported.artifact-ready | target-boundaries:reported | 0 | 4023 | 7180d8446e8c6bba3fbbfb92142c67d7344b71eac9f04b632daceb4a8aba4527 | Fixture Package §7 |
| target-boundaries.tested.universal-property.org | target-boundaries:tested | 0 | 5542 | a65c3b323a4456bd7a3674d2d7836946c461e7ad46159d31c5b14559e0499339 | Fixture Package §7 |
| target-boundaries.translated.file-alpha-animal | target-boundaries:translated | 0 | 16203 | ac7e9bdfbb8d06ee9273e8a762ec954266784766798ead9985d16cc56ae8e7d6 | Fixture Package §7 |
| target-kind.corpus-completion | target-kind-identifier | 0 | 62 | 7a37d86690b0112836e3ef46d294cfc546e9c60f7ba2f45e6d06a9da13ac9d32 | Fixture Package §7 |
| target-kind.derived | target-kind-identifier | 0 | 52 | 853854b86d4a10f2ab3a769f84caeb817cb48055ab69b36539e6dd372d7574c5 | Fixture Package §7 |
| target-kind.executed | target-kind-identifier | 0 | 53 | aaaf0f8f6cb44db7341e34024cd2964a56ebd197a9d08c58a4a6803be01dafac | Fixture Package §7 |
| target-kind.externally-attested | target-kind-identifier | 0 | 64 | dbc252c771dd51e9a5eff249f6f8a66d0c8e70979c5c71b3e0748a3636514914 | Fixture Package §7 |
| target-kind.inherited | target-kind-identifier | 0 | 54 | dde8e86eb3fef82321b60e1f70980e41c506c694b029dd59ad45d4b4097a9261 | Fixture Package §7 |
| target-kind.observed | target-kind-identifier | 0 | 53 | 68edd13fd679801369ca75d9ffba60f84dd7165628dd7d194dede7d7292db731 | Fixture Package §7 |
| target-kind.policy-evaluation | target-kind-identifier | 0 | 62 | 2f1a602c0f87938b880540412fcce3c062ad7818450a4abacc01784434377785 | Fixture Package §7 |
| target-kind.replayed | target-kind-identifier | 0 | 53 | ffd253856557fe65d91637004dde391dad8a986f11bfca7d5940ea042943aab7 | Fixture Package §7 |
| target-kind.reported | target-kind-identifier | 0 | 53 | 70a5aafb516da8e096579f4cf63c3ee0df2845b13f67d82fcd9cd3715def8e8a | Fixture Package §7 |
| target-kind.tested | target-kind-identifier | 0 | 51 | fcad58203405616311ce2518b3d6f3c409c84ca4566bea79dcd5885789c6d7db | Fixture Package §7 |
| target-kind.translated | target-kind-identifier | 0 | 55 | fdc4b458dc6e091b8819e688d47cc4a1291a6c08e8d51795dfdda0cfb8161b51 | Fixture Package §7 |
| target-relation-result.exact | target-relation-result | 0 | 321 | 778c163d562f13e7cae83497f0e0d69a92fadfd5cb7eb91976a84d761ef3dffd | Errata E2/I12(b); Fixture Package §7 |
| target-relation-result.failure.scope-incompatible | target-relation-result | 0 | 1935 | 89ed877316e3f9f2e9287f725f8c52bef29c6ed6501db67d3c218ff4a2700d45 | Errata E2/E7; Fixture Package §§2,6–8 |
| target-relation-result.failure.scope-narrowing-coverage-insufficient | target-relation-result | 0 | 3197 | 327545e8226b8cb4d1e44c27424e3087154f2b14bbdb2b35167071d1bb82c001 | Errata E2/E5; Fixture Package §7 |
| target-relation-result.failure.scope-narrowing-not-declared | target-relation-result | 0 | 934 | 35eaafcbe1ad6f4a4c051de88257cc4cae657d43cb98b87770a1c4e5b8258623 | Errata E2/E5; Fixture Package §7 |
| target-relation-result.failure.scope-relation-unknown | target-relation-result | 0 | 1328 | 9ae0a17d72e5b341a307f5747317ded3980f56a77d1bac95ae6cc8ab195768fd | Errata E2; Fixture Package §§2,7,8 |
| target-relation-result.scope-narrowing | target-relation-result | 0 | 336 | d501881c7f4f08e077c4896c9a73edc4ebe1dbc3856fa1dc6027d012d18a84a5 | Errata E2/I12(b); Fixture Package §7 |
| target-schema-definition.corpus-completion.0 | target-schema-definition | 0 | 6384 | cefb13af591a79a7460ce408b9f3c1dcd4ba7e54f3da7e7b93c92d6fcb492233 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.derived.0 | target-schema-definition | 0 | 5328 | 26183b6182934746bee43c95e372f0465c1a79e016f60caf925072bfc68ade1a | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.executed.0 | target-schema-definition | 0 | 5885 | db6437d2f5567dc67f53a5cf32381d039629796f149ede3a7d632c35baaf934f | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.externally-attested.0 | target-schema-definition | 0 | 5303 | 3a2af4034860fe22c9fdb0153083062e32b1d0f86e62c7f439f3a40d24f6a17c | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.inherited.0 | target-schema-definition | 0 | 5588 | bbd9f5f4265a8bbe107e0d590e0a16ff4fddc2637fc82808ae0b4b459b173127 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.observed.0 | target-schema-definition | 0 | 5519 | 612ceeba0eadece5902ad0f1a13ec105b41c9e73e29153db214e1659f958fb9c | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.policy-evaluation.0 | target-schema-definition | 0 | 5708 | 8f57f604343949c7676f1b13ebdeabe2690847957d56a7c88aff62beb5e45b54 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.replayed.0 | target-schema-definition | 0 | 6072 | 58be784864e1a10e8c11c6cca7d72ad2cdc3da7ffd28f58fd992db4fb2193b28 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.reported.0 | target-schema-definition | 0 | 5298 | 9a8193649a3a379dcfe3bdf19706eb60790f702e9c5b5b74bbdb526c530addf0 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.tested.0 | target-schema-definition | 0 | 6341 | 1fe9d0885ad77ca42c4241ce9e3364118a608a88ef9a2bcfbb974f4b5cf12af2 | Fixture Package §7; Errata E5/I12(d) |
| target-schema-definition.translated.0 | target-schema-definition | 0 | 5825 | 5724ed3c1aed3dd96f8bd874c6a3450131e8a357888fe447a25fea3f10f5bd6a | Fixture Package §7; Errata E5/I12(d) |
| temporal-expression.atemporal | temporal-expression | 0 | 235 | a6f832f86780dabbc4060e44b69509b4fa1cb6043ca539dc8fc2e7cb1aed6358 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-0 | temporal-expression | 0 | 273 | 44ae78a727a4d94727ad0a0791fbbd9325d1e265eac9ac8155a89dd2809b1708 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-100 | temporal-expression | 0 | 274 | 984ed545f8e5926441b2e8ae51e850f11ed3fb7c7ea3734704b71574af94c3df | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-101 | temporal-expression | 0 | 274 | 0d49feb6bc3a28a6e2d7e61c2bf8257d181a39e300494db0375cbbef50c0bd79 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-124 | temporal-expression | 0 | 274 | 3072c10d35b46162d7b3975b4d2e7e58a3e55bda9382c7c8fdb525681310adb9 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-130 | temporal-expression | 0 | 274 | ccae7d7d6e5f658f004540ed54813703956a8c8349444b8a5c95179d3af11791 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.instant-300 | temporal-expression | 0 | 274 | ac09f7ce62b0ddf5f763a321f88c6ad2bdc7d0696cd9bd8ee12a5b33a42e9202 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-0-50-closed | temporal-expression | 0 | 406 | 33ae10f0013e7571a9cc97fb3b0c243add53aa11fb12df84a770d6523d3c5bb6 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-100-124-closed | temporal-expression | 0 | 408 | 95f8808dfb2a18ae73d5a1626637010bffe2d0376cabb947b56c6e9a9c360266 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-100-124-left-open | temporal-expression | 0 | 408 | 2b99c6ee5ca230aa067d04f4df39ec308e74fb33b6d9583fc79a536e335e1e79 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-100-124-open | temporal-expression | 0 | 408 | 92b151a3bad7da08506dacb2da07770ce47571b3b63ee215db8023a5a363009c | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-100-124-right-open | temporal-expression | 0 | 408 | 05a8b0ddd58ae7f12116bd3cc9a1ec558f503fb35ecc6b7b1b63a9e859dffad8 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.interval-200-220-closed | temporal-expression | 0 | 408 | 9ced6076a248cab3ebaee99ff91253c48cc4e1e56ae04bd6e63dd6c98bd895e7 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.periodic-even | temporal-expression | 0 | 326 | e633f7db41cbc7d6bd1e50f938af54f7846c4d11deeb82fefe79086940b1fc24 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.periodic-odd | temporal-expression | 0 | 326 | d7aa1e2ba2b4ed6ce081301627e55573b698c2afa81da338a8d30bc48937fd29 | Errata E1/E4; Fixture Package §3 |
| temporal-expression.second.alpha | temporal-expression | 0 | 339 | c4ccdef135fb09d3dd5b0a7ec825ed25922c043cc77d2e8cde11a51322c55e34 | Fixture Package §3 |
| temporal-expression.symbolic-unknown | temporal-expression | 0 | 338 | d665a4323c4c2cb3d6602138840cbd1467170521b31939c599e89a42f20c655f | Errata E1/E4; Fixture Package §3 |
| temporal.model.primary.definition.0 | temporal-model-definition | 0 | 663304 | debceb17cea808de243d84d89de14f60d83c143f613b4aef721bf2e791a10422 | Fixture Package §3 |
| temporal.relation-table.0 | temporal-relation-table | 0 | 661466 | 3de57dd9584d3c278c1a18684a2155ddf7f735af228b8b6b2f95f539bb8d3cf9 | Fixture Package §3 |
| vector.schema.0 | vector-schema-definition | 0 | 902 | b2948d48eb84af0f37052944c1089b019bb99401e3278f1d48986dbc026dbf32 | LCI/0 §§24–25; Fixture Package vector appendix |
| warrant-target.corpus-completion.absence-docs.complete | warrant-target | 0 | 29381 | 802cd480650aa490a7456d8d9e004ed878b43f74023c4d8d6e7352878fe379c2 | LCI/0 §9; Fixture Package §7 |
| warrant-target.corpus-completion.absence-docs.incomplete | warrant-target | 0 | 29383 | f46535f7bd3e3f7d3c85182a046847b958fcf2a23635e3229030ed0ae2826208 | LCI/0 §9; Fixture Package §7 |
| warrant-target.derived.one-equals-one | warrant-target | 0 | 20236 | 9443e3f38f8ca26f30b9e5afb5f14082a5243793a9d5be7aeeabc599479b07a8 | LCI/0 §9; Fixture Package §7 |
| warrant-target.executed.call-17 | warrant-target | 0 | 15330 | aa1db27b60c757acc0e856f7b03bb52703bbc349511a06233145436756c5ac83 | LCI/0 §9; Fixture Package §7 |
| warrant-target.externally-attested.file-alpha.trusted | warrant-target | 0 | 13233 | 2ea81212df2c701bf9287eca0b95d71dea19d0f27a08bef97b942b61c9bf88d3 | LCI/0 §9; Fixture Package §7 |
| warrant-target.externally-attested.file-alpha.untrusted | warrant-target | 0 | 13235 | 42d66f349757061d15d73f82f4ea5c77396f692812877be7db715f5219307919 | LCI/0 §9; Fixture Package §7 |
| warrant-target.inherited.file-alpha | warrant-target | 0 | 16425 | 40263226f9a13974cc2b268fab1b21a80ba38b2f16cb08f156204d1c9c44951e | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.average.org | warrant-target | 0 | 14024 | 6a72226890aafb7f21a4edd6b70c93b1cf4f4eef536dd349e2b8109d5b5fdfd0 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.alternate-procedure | warrant-target | 0 | 13323 | 9e50c85a93423694a8069f0a2aeefdb6b9a029899ba02a454c160dc2dc231d9b | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.animal | warrant-target | 0 | 14331 | 08ca867c36652a062724969a05cc8ed4a21ded041efc7e703ea11042a36dd770 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.corpus-r3 | warrant-target | 0 | 17137 | 805a1fce13349b4c76cc7c789063b75cc744e243ec9587d83323b8234581e8eb | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.exact | warrant-target | 0 | 13319 | 102c53b6258a19182d300db9d71b0962b09cf6e7125211a92598f0f46d496da0 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.region-x | warrant-target | 0 | 13656 | 57126b9dfa56df1bf51aba31256b14bde05b5dcc2adb3e516aee07eb354dbf28 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.file-alpha.yesterday | warrant-target | 0 | 13358 | 2a36cfacc42c551e3e7ede302d2aceca4f5a8980663ff20fa82caf647aa47b3d | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.universal-property.dept | warrant-target | 0 | 13334 | eabbcd6a5eb38d87a6ba37761dbd309464ecf563a314cf30ff5f20221bcd7d59 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.universal-property.insufficient-coverage | warrant-target | 0 | 13201 | 6a064352a252a0e97c0dd96df43c47ea25dc7c130a3738b8508c8ac44f261311 | LCI/0 §9; Fixture Package §7 |
| warrant-target.observed.universal-property.org | warrant-target | 0 | 13130 | 54cbb74ef9c831af8d547411c0b550b66f44a0c4ab5b1f27b7de7db6126679bd | LCI/0 §9; Fixture Package §7 |
| warrant-target.policy-evaluation.file-alpha.meta | warrant-target | 0 | 13733 | 47c3799dcf200aeca28486784e95caf20a9a73aabd38d4c289a60db00642edd8 | LCI/0 §9; Fixture Package §7 |
| warrant-target.replayed.file-alpha | warrant-target | 0 | 15055 | 969b689348fb75052e7492bff8ce7f04fbb9843df8efb2d2362bc6532b4c60c9 | LCI/0 §9; Fixture Package §7 |
| warrant-target.reported.artifact-ready | warrant-target | 0 | 13680 | e4fb27569364c48fbc8cd346d09ee14d8cdb3c17f2eec0094d61c4a67e75c08d | LCI/0 §9; Fixture Package §7 |
| warrant-target.tested.universal-property.org | warrant-target | 0 | 14433 | 7e650e819a467491989d238f6d9155311ccf7544d0c638e5429012653b512342 | LCI/0 §9; Fixture Package §7 |
| warrant-target.translated.file-alpha-animal | warrant-target | 0 | 26423 | bf1c4dd65ec497d67d8b8bce5853035e21fd91200350f78a78d0900c6c49a06a | LCI/0 §9; Fixture Package §7 |
| worked-claim.neutral-file-alpha | worked-claim | 0 | 8402 | 08be9d7b92f13a5b014866e085ff4375f44a6fd71672a36ae573e36e8e77e90b | Errata E1; LCI/0 §7.13 |

## Appendix B — Complete vector index

The complete input and expected documents are in `LCI0-FIXTURE-VECTORS.jsonl`; this index gives their exact receipts and typed outcome.

| Vector ID | Class | Operation | Profile | Input bytes | Input SHA-256 | Expected bytes | Expected SHA-256 | Typed outcome | Source |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LCI0-P001 | positive | project-occurrences | 0.1.0 | 42334 | 40fa38f0f07686ec9c4880ba79d784dece874ae8014a11362c7fc966e49e648d | 17376 | 0967ba34974132d8283e7699197e7a2af5a4ad464ab920d8517ec8109156f50e | success | LCI/0 §24.5 P001; Fixture Package §11 |
| LCI0-P002 | positive | canonicalize-record-order | 0.1.0 | 17780 | c6e7b92d8477cedfdf4516e7b70cc9f8deadf78d2ef321873564426960c3fcb4 | 8894 | 303858006642c8cde37ebb0101e6a4689e0ee0430002a8eb597e6997abbdf875 | success | LCI/0 §24.5 P002; Frozen CD/0 record canonical order |
| LCI0-P003 | positive | compare-claim-ids | 0.1.0 | 17276 | 46c340a4e13c5c5ff7b975d182455fdb035eb1341f8b117cf697a2c72cfe0b96 | 567 | 7ab0c9a41da563edeaa22bb24baae77014a215bcfb3f52a019f6e6f88bf29993 | success | LCI/0 §24.5 P003 |
| LCI0-P004 | positive | compare-claim-ids | 0.1.0 | 17671 | 66b3e7b1695b794768e8be946ab283656998d6b2bbdc995f086ed20bfd233a6a | 657 | 8351fa997fe0829e41ffb740ceaac258f87adef9827d1e39634aec2ac5675bf4 | success | LCI/0 §24.5 P004; Fixture Package §2 |
| LCI0-P005 | positive | compare-claim-ids | 0.1.0 | 17355 | 0476da837dffbe2912874fa3e888418d74cfa5b9c13eddbcc5239a570485baef | 568 | 738cec870ecebff9105ca0f34a30d56dd430bae07e33d46989309f3c36379265 | success | LCI/0 §24.5 P005; Fixture Package §3 |
| LCI0-P006 | positive | compare-claim-ids | 0.1.0 | 24913 | e52e511068ff9da25f8aaf80910d14b6af0177d45901b8375b63769acbba83c6 | 571 | 1a02094c4bcd6d649fb93d2d8f2aeddf80c42512fad40031dc5fe85f1d7bf23f | success | LCI/0 §24.5 P006; Fixture Package §4 |
| LCI0-P007 | positive | compare-claim-ids | 0.1.0 | 25502 | 940f76da6a4460fe56c37ac4481c9813f96af931e3b7f6921a54834764064d12 | 569 | e15ad281ed8e196887a1f0046eba21cac84603b1fc0b8d959ab34beeae263760 | success | LCI/0 §24.5 P007; Fixture Package §4 |
| LCI0-P008 | positive | compare-claim-id-set | 0.1.0 | 54108 | 003703a63aa61ae569dcbbc221adc913729eacba61ebe1f4e16e4248c29ea2ac | 552 | 8386e54313411cfe7b500de30c6503205d6bd4202ecdf9ff7e4aa99e2ac85077 | success | LCI/0 §24.5 P008; Fixture Package §§1,4 |
| LCI0-P009 | positive | compare-claim-ids | 0.1.0 | 19302 | 0feec7ce6787924034463723671627a81d2984e998238923db345089aecc9073 | 576 | c024533e0d04d3a13d05bce562bb0f2a35f09fa8c56fb6590be005bb705aa1d2 | success | LCI/0 §24.5 P009; Fixture Package §5 |
| LCI0-P010 | positive | normalize-controlled-translation | 0.1.0 | 17725 | b59b2138e09193fdfb049fba1b37a82fcfc563fe30ca4056b02b4d5ad2438c54 | 17385 | 4db8d326e86c85ebcd31fe70fc2b4807ccc7042e157b4670eea25d4e64f8c517 | success | LCI/0 §24.5 P010; Fixture Package §§1,12 |
| LCI0-P011 | positive | project-occurrences | 0.1.0 | 42450 | b929c7abcf0d826d4595096c8ac1fa1ee572541eb0b24347408f7ae8505a7763 | 8870 | 8329f2f4f4ccff5b157e35eb7b6bea71abaa45023f4d5d9832d4c6ab410e182b | success | LCI/0 §24.5 P011; Fixture Package §11 |
| LCI0-P012 | positive | project-occurrences | 0.1.0 | 42447 | b8f8e88793c1ae443f5318952c490b3fe8c589170b2b204429fa62ea54b7f73f | 8870 | 8329f2f4f4ccff5b157e35eb7b6bea71abaa45023f4d5d9832d4c6ab410e182b | success | LCI/0 §24.5 P012; Fixture Package §11 |
| LCI0-P013 | positive | compare-warrant-targets | 0.1.0 | 27135 | 9e71e45d7f937e3ed95425c3259527e500af875a7d81a8914bf3105ac51b81eb | 617 | 6d42a5deebe9a0e8216add9da9f39b85538243946dcd86ea6e872204ccd19051 | success | LCI/0 §24.5 P013; Fixture Package §7 |
| LCI0-P014 | positive | match-target | 0.1.0 | 22201 | aef2932fb7bab7d0212b407830075c6c807451622b033346c240a3cb2e391c83 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | LCI/0 §§10.1–10.3,24.5 P014 |
| LCI0-P015 | positive | match-target | 0.1.0 | 21805 | b22fca4d06f820e1288e4674fd0a9a597c31a7e20e6ba019bae8cf417271bdd7 | 756 | d80b2657acce0cd31fb9c27b461c1904f92c39b857cbb7681ce7019d0cc0d701 | success | LCI/0 §§10.3,10.6,24.5 P015; Errata E5; Fixture Package §§1,2,7 |
| LCI0-P016 | positive-relation-refusal | match-target | 0.1.0 | 21907 | e4ef038b0988f4f2a90783730d1698a8970771a840d723d978bca22ac18b3e3d | 498 | fd624acc64ac352168626fee7a8792befb8583b5a8196fe67090a81d7fb78754 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeWideningForbidden"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | LCI/0 §§10.3,18.6,24.5 P016 |
| LCI0-P017 | positive-relation-refusal | match-target | 0.1.0 | 22726 | 56f02d91f999740920687156dc81c9834d6f7136f84106137bf473629ba8db95 | 500 | 2af337d50681914769756a2c285d8a2aac2b07c52e1b57cbc0767840c9b41018 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeOverlapInsufficient"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | LCI/0 §§10.3,18.6,24.5 P017; Fixture Package §2 |
| LCI0-P018 | positive-relation-refusal | match-target | 0.1.0 | 22279 | acf680a8bdfd34e5643c988acc1f83997558e2ead8af03ea7e46f00956543193 | 502 | c4b9773e225d6f7de4aedb5200b1239e28e66cf9d6911de4d8b8290ecaa9be83 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["SubjectTimeMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["subject-time"])']) | LCI/0 §§10.3,18.6,24.5 P018 |
| LCI0-P019 | positive-relation-refusal | match-target | 0.1.0 | 29837 | 3df9afe138f9dd967253d4d760ee8bb8370e8add0df978ee683b6acacd4304fa | 489 | a65770f3c6c80ed5af3f646e7cc81acdaafa6a38424af2537bbb2d94e6e667f6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["BasisMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["basis"])']) | LCI/0 §§10.3,18.6,24.5 P019 |
| LCI0-P020 | positive-relation-refusal | match-target | 0.1.0 | 24226 | 9f1340f399a62dc747f6672faedb6c83e95aee3af1c20e2e60f86e77e00ce087 | 518 | 03ec9e1dfda22d9904464e66faa2b89c290df2dc933822425a9d78c339345ecf | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["InterpretationFrameMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["interpretation-frame"])']) | LCI/0 §§10.3,18.6,24.5 P020 |
| LCI0-P021 | positive | compare-corpus-completion-targets | 0.1.0 | 72353 | 31d50a27435e14d178438ae538740c6f807b616324e8ccd45a3c872cc2b086cc | 1381 | 656958d3fe84852d747f6092e65f947e0b0da109c6cd455ff3e7748241ebd324 | success | LCI/0 §24.5 P021; Fixture Package §7 |
| LCI0-P022 | positive | evaluate-admissibility-under-two-policies | 0.1.0 | 39118 | 54c37ad7e608e257f0c393741cf5ef683f19beeed5e0a00d3f513e9d9b39da83 | 15769 | ffe3e8e462cd5d2b43ba959fe85bab928570f4727150eeb0e557ac3769e35c90 | success | LCI/0 §§17.12,24.5 P022; Fixture Package §8 |
| LCI0-P023 | positive | evaluate-freshness-two-query-times | 0.1.0 | 32808 | 5e4f530b19fecb7f0592d319760658ab296447c8ee1cf1f7a1f9eec6aeda9f7a | 15649 | f9fa65005d14140406adc2f26a31171f4b2fd1a1208ac7303db5227fc62b58ec | success | LCI/0 §24.5 P023; Fixture Package §8 |
| LCI0-P024 | positive | revive-inert-occurrence | 0.1.0 | 29375 | c730f6e1993b6bfa77191302aae856dc92b7c973622344a7d484ac88801bb0ff | 30591 | 13c281e7654162ba566e8af3883ef022fb360f1c91bb8753147668fbb9389963 | success | LCI/0 §§17.8,24.5 P024,28.6; Errata I12(e) |
| LCI0-P025 | positive | translate-exactly | 0.1.0 | 17713 | f0ea132a6c9266527b4a4f7c89c00abf7e9ada71a0de5963057152c8d51bf623 | 34972 | 47a1238eeb4f51e32e87782ad0f2978cf2940c3ea427e79389da3f55fd38bca7 | success | LCI/0 §24.5 P025; Fixture Package §§1,12 |
| LCI0-P026 | positive | translate-with-represented-loss | 0.1.0 | 22040 | 67eac411362f954fcbf0910da6d457b2bb4b8ce09721a7cc15e522b5389f40c2 | 3448 | 37dd04e18ab8746d9c4a6fc2810754045e471dec6f1ef9ab8b674b0ba1131ee5 | success | LCI/0 §§16,24.5 P026; Fixture Package §12 |
| LCI0-P027 | positive | migrate-v1-collision-pair | 0.1.0 | 6165 | 27ce9dc79d80a6b2a7b4ed63f29687044e62404e98f1482aeadcaa9ff91e3ae1 | 54019 | 1194317045328613da7dbc667d6d9125b189683ddea3e5dd32918921633ae47b | success | LCI/0 §§23.5,24.5 P027; Errata E9; Fixture Package §9 |
| LCI0-P028 | positive | migrate-v1-collision-pair | 0.1.0 | 6171 | 1043a849ef9345c04e22ba44ee93492e79460f3081dd309f4d40a224285c0438 | 54012 | 623457162cf7307a58e5f90e66f0929e215a7a5b2088cbc2238afe22cf96631b | success | LCI/0 §§23.5,24.5 P028; Errata E9; Fixture Package §9 |
| LCI0-P029 | positive | migrate-v1-collision-pair | 0.1.0 | 6166 | 3dd8e067335f659062ba4d9df3945351be693f4016f27c8366c56c61561e017c | 54022 | de95395165f2e7e170989246caedfe0e278027bc9d90a44a785e18059cf235a7 | success | LCI/0 §§23.5,24.5 P029; Errata E9; Fixture Package §9 |
| LCI0-P030 | positive | apply-occurrence-corrections | 0.1.0 | 63649 | 1b10c911d702dc782d2d89e19bb67f1db6fbcef57cb413869dcacf0ef419d10d | 25873 | c2706fac5451d2ed6789da59b54a6deb743efb6a2261e751736390d49a012b4e | success | LCI/0 §24.5 P030; Fixture Package §11 |
| LCI0-PLACEMENT-LOG-HORIZON-NEG | negative | project-claim-id | 0.1.0 | 13959 | b95eb9524234c919099738458ca335f611159b27bd53f4eb4aa7495cf723daab | 533 | c5fbcaa4e7eb0c911f168993b6c34883dca387876dc0a4e500a25c54eadd16f9 | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PropositionLocationInconsistent"])/Id(["lisp-plus", "lci", "0", "failure"], ["basis"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["basis"])', 'Id(["lisp-plus", "lci", "0"], ["semantic-boundary"])']) | Errata I05; Fixture Package §§1,4 |
| LCI0-PLACEMENT-LOG-HORIZON-POS | placement-consistency | proposition-location-consistent | 0.1.0 | 13769 | 93182aa99fd105ae5da1e0c36d4774b4067d25be3ab420911ebbee1ab94d8169 | 555 | 7de206600e5e5f7e578dbb7c2523dbe5d1c711930a52786507b646572d29c21b | success | Errata I05; Fixture Package §§1,4 |
| LCI0-PLACEMENT-QUANTIFIED-DOMAIN-NEG | negative | project-claim-id | 0.1.0 | 9187 | 15f7d5ee36c9fa71531ce21bf5f2c678df8f7fbe5f2847dafe73470a40d54064 | 680 | 9446458167e4083a31c061fc4a73af7f6642c4e6cebd754f4b7807183811714c | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PropositionLocationInconsistent"])/Id(["lisp-plus", "lci", "0", "failure"], ["proposition"]); path=['Id(["lisp-plus", "lci", "0"], ["proposition"])', 'Id(["lisp-plus", "lci", "0", "fixture", "mneme-proposition", "field"], ["arguments"])', 'Id(["lisp-plus", "lci", "0", "fixture", "mneme-proposition", "argument"], ["quantified-domain"])', 'Id(["lisp-plus", "lci", "0", "fixture", "mneme-proposition", "field"], ["placement"])']) | Errata I05; Fixture Package §1 |
| LCI0-PLACEMENT-QUANTIFIED-DOMAIN-POS | placement-consistency | proposition-location-consistent | 0.1.0 | 8062 | 44d3c3feece023b14b6d3be7a4ae2118b578ed26052b31bbbb0639accab8f846 | 560 | 0f2dedf6dbf3532f6167b11e3587bd99676df022b6cedccaf5b55d7503a7fbcc | success | Errata I05; Fixture Package §1 |
| LCI0-N001 | negative | validate-claim-id | 0.1.0 | 8637 | d463c952ccbcbb8c4d7593a2bca07c1bfee857d44e679376b6f494d3b2879e4e | 447 | c3c3f0126678d278f43d090fca6ebcc07aec24eac809b79e89c5398037025fbc | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-shape"]); path=['Id(["lisp-plus", "lci", "0"], ["identity-policy"])']) | LCI/0 §25.3 N001; Errata E6 |
| LCI0-N002 | negative | validate-claim-id | 0.1.0 | 9412 | 7af0ebe1638fdf570a876968bf9602082bbfbbab50e5394632c93d0e5144e243 | 430 | 0aa47ac5aaec69ef8962d0e3df66154f277b0041e9831363a9f31ceb10effb21 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnknownField"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-shape"]); path=['Id(["lisp-plus", "lci", "0"], ["issuer"])']) | LCI/0 §25.3 N002; Errata E6 |
| LCI0-N003 | negative | validate-claim-id | 0.1.0 | 7888 | 6b7000dc3c09a9889b6d082ed0dc5ba9222ac7d064e661cb5324ec8d632f9d40 | 467 | be3390e6648cbdab3317fba45c8c491609db5b5738f38deb7e0fa993a945ad25 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnexpectedUnit"])/Id(["lisp-plus", "lci", "0", "failure"], ["subject-time"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["subject-time"])']) | LCI/0 §25.3 N003; Errata E1 |
| LCI0-N004 | negative | validate-claim-id | 0.1.0 | 8842 | 611607c4ede0eb38d93f7e480ce798cebae392ae979034b34a7c524fc28bb398 | 461 | 741181a257cf789cfbc662c4696594df0f7bd38eff1ca2e9090135e85f753c7d | F(Id(["lisp-plus", "lci", "0", "failure"], ["unsupported-version-or-profile"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnsupportedLCIVersion"])/Id(["lisp-plus", "lci", "0", "failure"], ["lci-version"]); path=['Id(["lisp-plus", "lci", "0"], ["lci-version"])']) | LCI/0 §25.3 N004 |
| LCI0-N005 | negative | validate-claim-id | 0.1.0 | 8842 | b5059aa806edd74f25846b0151c17f45154ed572629b38e8d271cf5e380a7110 | 507 | 92a2a016d78b3fc443cf7435b0513c9d10767f2a8dbeb29412dab8c8ef3be8a4 | F(Id(["lisp-plus", "lci", "0", "failure"], ["unsupported-version-or-profile"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnsupportedIdentityPolicy"])/Id(["lisp-plus", "lci", "0", "failure"], ["identity-policy"]); path=['Id(["lisp-plus", "lci", "0"], ["identity-policy"])', 'Id(["lisp-plus", "lci", "0"], ["policy-version"])']) | LCI/0 §25.3 N005; Errata E3 |
| LCI0-N006 | negative | validate-claim-id | 0.1.0 | 8842 | 5bce1662393d3a2dfcd47a5307c795b4c32d10c488646f3f9b8c8a7224cc5d44 | 502 | 95c4d1c98e1ce33b9edd107c4c267633a8095b881792f56aa773754952b071a7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["unsupported-version-or-profile"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnsupportedClaimProfile"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-profile"]); path=['Id(["lisp-plus", "lci", "0"], ["claim-profile"])', 'Id(["lisp-plus", "lci", "0"], ["profile-version"])']) | LCI/0 §25.3 N006; Errata E3 |
| LCI0-N007 | negative | project-claim-id | 0.1.0 | 4093 | c21f15c5fe4f5e4b57b77ce17228366a8bd3fa596bbed4f9e3859051ac988efc | 451 | c0de9b07739c410bba03567e8dbd5e0c4f7d937df929bcac2ec9f820041c101c | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnnormalizedProposition"])/Id(["lisp-plus", "lci", "0", "failure"], ["proposition"]); path=['Id(["lisp-plus", "lci", "0"], ["proposition"])']) | LCI/0 §25.3 N007; Fixture Package §1 |
| LCI0-N008 | negative | validate-claim-id | 0.1.0 | 12641 | 954d5d45fb55b47e5b0931eb4faceb24dc7570434e82a4c2140014d9cac8a176 | 497 | eb307c3169f4bf5f9a8db810538fe103993793800a244c1714e679725923dda2 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["basis"])', 'Id(["lisp-plus", "lci", "0"], ["revision"])']) | LCI/0 §25.3 N008; Errata E7 |
| LCI0-N009 | negative | validate-claim-id | 0.1.0 | 9052 | 0c3a5d493603b02a81e06577356ed3995722bc8fefa12923c8881a79dd76a231 | 555 | 69f457c3aa33847ded4997853968336b78c65723b5ddb5d49a51bb0f15c4a798 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnknownField"])/Id(["lisp-plus", "lci", "0", "failure"], ["profile-location"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["profile-location"])', 'Id(["lisp-plus", "lci", "0"], ["coordinates"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["future-coordinate"])']) | LCI/0 §25.3 N009; Errata I12(a) |
| LCI0-N010 | negative | validate-claim-id | 0.1.0 | 8898 | 9f36bcf5a542841a7a7d78ad6394a201bc0ebd2271f99dc7de7298b15ba33fb0 | 481 | e4d17cb6fc8ad0c650ef340695bddfa71fbf596242240f568fc2809f97ef359a | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["InvalidScope"])/Id(["lisp-plus", "lci", "0", "failure"], ["scope"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])', 'Id(["lisp-plus", "lci", "0"], ["expression"])']) | LCI/0 §25.3 N010; Fixture Package §2 |
| LCI0-N011 | negative | match-target | 0.1.0 | 22310 | 048bd8840c7048c75ca38642087b9df96cabc4ad4295752e199f98bbf0d28f39 | 499 | 3460e7e1734dc94c90091ce467d4bf144d9aa0beb3b2adf0f53042b39e51a05b | F(Id(["lisp-plus", "lci", "0", "failure"], ["relation-undetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeIncompatible"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | LCI/0 §25.3 N011; Errata E7 |
| LCI0-N012 | negative | match-target | 0.1.0 | 22369 | 050fb0d6637406dff7c9bfe9070005bb3d25ad6df15ac1b6124b29c4ea2a91a6 | 502 | 4c69d1ef399987736d84acd4fd159da884ff0260ee1a9fb13b73770588eba746 | F(Id(["lisp-plus", "lci", "0", "failure"], ["relation-undetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeRelationUnknown"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | LCI/0 §25.3 N012; Errata E2 |
| LCI0-N013 | negative | project-claim-id | 0.1.0 | 8884 | 9f6d4186e1b5595f3714674daef7b493dd99e59bf85c46c17b5533f235a2f7fc | 510 | 52d89bd872e6e11ad33bc7df22b8bd9abc23d69dea75fcf53ebf64638fe65618 | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedRelativeTime"])/Id(["lisp-plus", "lci", "0", "failure"], ["subject-time"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["subject-time"])', 'Id(["lisp-plus", "lci", "0"], ["expression"])']) | LCI/0 §25.3 N013; Errata E4 |
| LCI0-N014 | negative | project-claim-id | 0.1.0 | 10081 | 8b6c63474cbfb5707e886a7a628fbc8497194ff17359f016e139fd6b87331414 | 475 | 325627064e7d7a9026cfc9f4f238e89db15a581f5be3a1434295f36866b65270 | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PropositionLocationInconsistent"])/Id(["lisp-plus", "lci", "0", "failure"], ["basis"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["basis"])']) | LCI/0 §25.3 N014; Errata I05; Fixture Package §1 |
| LCI0-N015 | negative | project-occurrence | 0.1.0 | 20922 | 18a6f1d063e17de40fdc114474bfaa9cbb2de8b1a33e88a0f52f0b12c03c9a14 | 469 | c7a1f89c6241275866459527d3063e209137d446dc8cb75237bf3b55044f9d0d | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["ClaimIdCacheMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-id-cache"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["cached-claim-id"])']) | LCI/0 §25.3 N015; Fixture Package §11 |
| LCI0-N016 | negative | project-claim-id | 0.1.0 | 609 | f042e98b2d9b2bb47a723845abe5657f5f6e6ef7476bef0adb03a457deef3d4f | 441 | b06026b7c4d01544d193c62303928bcbba5b08760d06c1b2d46b37f003fe295a | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["SelfDeclaredClaimId"])/Id(["lisp-plus", "lci", "0", "failure"], ["projection"]); path=['Id(["lisp-plus", "lci", "0"], ["digest"])']) | LCI/0 §§20.11,25.3 N016; Errata E8 |
| LCI0-N017 | negative | validate-warrant-target | 0.1.0 | 5403 | b0a4ab9dbe1581cae01b9715c2fc49f0b58dbe4738a510e2c2141fe1697fab62 | 449 | 5f59aa36ba5cbae1b528d05de4bd8306132c4291c06ebed53c660af5c22a3e0e | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LegacyFingerprintNotClaimId"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-shape"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])']) | LCI/0 §25.3 N017; Errata E8/E9 |
| LCI0-N018 | negative | validate-warrant-target | 0.1.0 | 15170 | f0d4a764e41f48a5f4fb586a9459786be5553a4d84b1bc6e84f8a89478f28606 | 522 | b52e5af19e9f3a24cf6be0649537e990d0224a4dcd575f42371d20bf7735d69e | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["ProcedureIdentityInsufficient"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["immutable-code-or-semantics"])']) | LCI/0 §25.3 N018; Fixture Package §7 |
| LCI0-N019 | negative | match-target | 0.1.0 | 42896 | 40cfb8a96a8241caf3a2a56b51c597eefa260ab27d42b6d88b9ee9ea5e994807 | 519 | ab9327385f8e3ff9d6b174702568d5f47adc9c873070f0192fa99d282003b101 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["CorpusCompletionInsufficient"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["completion-receipt-or-trace"])']) | LCI/0 §25.3 N019; Fixture Package §7 |
| LCI0-N020 | negative | match-target | 0.1.0 | 22279 | bad00dc00d6990ed9779aedc1106cf77d9c651ab4c5f4ad2bbbcf06195aa5501 | 502 | 4a519ac03dae92c18eabea9fdbf4c60e0ae6c6205a465bb402c4d93890bc6cff | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["SubjectTimeMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["subject-time"])']) | LCI/0 §25.3 N020 |
| LCI0-N021 | negative | match-target | 0.1.0 | 29837 | 1a5c15ab4878029c0c335662dd580ca5ef94de299a49c893f9798075f3132cd6 | 489 | f6f141f8cd5d89084f92f10edf740e45d87fc81203f4a9654abc85c5e9544628 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["BasisMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["basis"])']) | LCI/0 §25.3 N021 |
| LCI0-N022 | negative | match-target | 0.1.0 | 24226 | bc7262b6014f9c61394e3608f41307301dee2e60332835702c747b2cbc419bb8 | 518 | 9737281efdd1913d7e92af5f9c72323edf37efb9d9ce22ec46f073113b849cbf | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["InterpretationFrameMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["interpretation-frame"])']) | LCI/0 §25.3 N022 |
| LCI0-N023 | negative | match-target | 0.1.0 | 21907 | be83abc8f3ccf5709c1b4d407a55356783c705d9e578b74ebf22ef9f612309ba | 498 | 3dc2d73624b6081c44f18790cb3f6dcfda89441fa44f07709a839947fade7322 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeWideningForbidden"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | LCI/0 §25.3 N023 |
| LCI0-N024 | negative | validate-warrant-target | 0.1.0 | 13814 | 5a3081d3d083c0b0e033bc8a39a8ba6e7c9e133ac280ec843ea64abdc2ac9b2f | 493 | bbd2546b4737748ef36fcbcdc31a5edae8ea3d795bb986b755d10296e284d0ae | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryUnknown"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["confidence"])']) | LCI/0 §25.3 N024; Fixture Package §7 |
| LCI0-N025 | negative | migrate-v1 | 0.1.0 | 3274 | 267807389ee7e3e562247c8ee7ad606dd77bd03a07b0361697410b71acda7c93 | 560 | 2b3fa8dbb819467953fdc3c2578b3ecfb13b6ece40e186982031472940d2a83e | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["AmbiguousIdentifier"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-mapping"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["proposition"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["operator"])']) | LCI/0 §25.3 N025; Errata E9; Fixture Package §9 |
| LCI0-N026 | negative | migrate-v1 | 0.1.0 | 3269 | b57b6c09f55c2303a9051e85188f89ed52882077d86a2147fb4ad42f0bfa351d | 509 | a4aeca04b7997c8fccc03873d7e83c194b4f9f3ebcaa6f166e267c89e92e72c9 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnclassifiedAsOf"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-mapping"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["as-of"])']) | LCI/0 §25.3 N026; Errata E9; Fixture Package §9 |
| LCI0-N027 | negative | migrate-v1 | 0.1.0 | 1561 | e8f48e3d9827bb0d946759a04a732f39a87a308ff614f7a40506a701dae70070 | 465 | dd6d05e18a19ced9f612d06aa19af3927c36dd5b17b6e07cd2dfbbf93dd111f2 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["IdentityBearingLoss"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["frame-token"])']) | LCI/0 §25.3 N027; Errata E9; Fixture Package §9 |
| LCI0-N028 | negative | validate-migration-result | 0.1.0 | 27843 | e9b3d7698c188dc83327d1257c671597042752073d1290db808c4ff18b98d837 | 460 | 975f0e04a899e27c13eaf9cf96c8f3efd02255bdec0a1ebf3b66ecb1c30e16c6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["RepresentedLossRequired"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["represented-loss"])']) | LCI/0 §25.3 N028; Fixture Package §§9,12 |
| LCI0-N029 | negative | restore-live-warrant | 0.1.0 | 3875 | df6483822ca3e87b0d16dc28fc1ec899ab539e28254c7c5d924384e06aa7658d | 527 | ec519efb2082c285d51b54f741b17fda5ddc544c49941e127d968c99b90b2897 | F(Id(["lisp-plus", "lci", "0", "failure"], ["privilege-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LegacyWarrantInert"])/Id(["lisp-plus", "lci", "0", "failure"], ["privilege-boundary"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["predecessor-warrants"])']) | LCI/0 §25.3 N029; Errata I12(e) |
| LCI0-N030 | negative | restore-live-warrant | 0.1.0 | 3861 | c652933a85830ebd37805e00f03c35f22757b78141bf29676fddd81dba03b6ea | 541 | 9f1678c10cd69270c073839b8460c0ae62fcfebf763157077e91b100b3e9bc84 | F(Id(["lisp-plus", "lci", "0", "failure"], ["privilege-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PrivilegedRestorationAttempt"])/Id(["lisp-plus", "lci", "0", "failure"], ["privilege-boundary"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["attempt-live-restoration"])']) | LCI/0 §25.3 N030; Errata I12(c,e) |
| LCI0-N031 | negative | differential-project | 0.1.0 | 23720 | 747b7e920d1680b9bac5949a00969b1db5507042f49928cdde80553b0f193160 | 472 | c2fa7f4ea79c254a4e7340f9fdd167f7bcf44def0396ac0c8172ecf4ae0c94a5 | F(Id(["lisp-plus", "lci", "0", "failure"], ["internal-invariant-failure"])/Id(["lisp-plus", "lci", "0", "failure"], ["ProjectionNonDeterminism"])/Id(["lisp-plus", "lci", "0", "failure"], ["internal"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["right-output"])']) | LCI/0 §25.3 N031; Errata E3 |
| LCI0-N032 | negative | normalize-proposition | 0.1.0 | 7683 | c6ccadf33306fa4a570971d21ebc0e0b3aa1a055360d699283daabc354f49799 | 473 | 46236a70210ed2014d96c0f49cc718c934b30539a461fe6cb031481210042c8a | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PropositionNormalizationWorkExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["proposition"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])']) | LCI/0 §25.3 N032; Fixture Package §10 |
| LCI0-E1-01 | errata-witness | validate-pinned-fixture | 0.1.0 | 1629 | 3b032680c71fa84e3f40b4b686f11d565d79106c5d07e4d995dd17da6fc41794 | 1668 | 28fa71d8fcf94e1c68f9f3aebfd3f58202138927685beca86c1fb2450e293634 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-02 | errata-witness | validate-pinned-fixture | 0.1.0 | 1639 | f6c0aa582bde343c2f83951e0db28a42d5c86f67553620e44554b6471e6d1a1a | 1678 | 13eb1c970b54eba7b11d9b5189d383d53a05e248c14b23d6674bd957041e50e8 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-03 | errata-witness | validate-pinned-fixture | 0.1.0 | 1689 | 42b6832217c0ceffc990535c1fec221a5d2a3e4e1dcd280ce92c22a97332c2ea | 1728 | 49a393db8966c7473a810c50d096898c6e6471ec9e9754da6eb7b09dc66acf67 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-04 | errata-witness | validate-pinned-fixture | 0.1.0 | 1719 | 39c151263796d660ddfcab3d199a4eb5d0cd83b709fac9a94bfd220e2cbfebc9 | 1758 | 9c134c1df66b9887ead6f1bd05b5e795810352935e2862c8cb8ffb86f4207abb | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-05 | errata-witness | validate-pinned-fixture | 0.1.0 | 1719 | d7e4a82eb3186cf097391e8bf5558b292ace9268c68787098392166c9b950c34 | 1758 | aecc31e8e22aff723a72a4e9cc4831c9ac8c10bc209a6305c270fe6f1d9da7f7 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-06 | errata-witness | validate-pinned-fixture | 0.1.0 | 2375 | 2fd2fcecd98020f57eb69d72119df35dd5423b7072408669686343aa9f01e59d | 2414 | b4613754d6316f18b69ef8e145b5515a54941a1e87542eb2e461b27b7bb58b23 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-07 | errata-witness | validate-pinned-fixture | 0.1.0 | 2423 | afb9fdac4106a24c92a22dc47cd48d0d97969659333a8109519246c1b0225167 | 2462 | f4fcb0911756b9cb6e1b3085302e04ea4b1afca7b115eff22e773542f5dbfe90 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-08 | errata-witness | validate-pinned-fixture | 0.1.0 | 2471 | ca9c2096e8b7cf78c308f15de82013c990803c9efe6327a1b10421d8bbb6f229 | 2510 | cce907a985479473f8e1a514856fba669f2d25f604ca27053c83952a6ebfa920 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-09 | errata-witness | validate-pinned-fixture | 0.1.0 | 2529 | 025a8de5261fdc2932942f2435feb617827f6ef708afc5274ff9108c8b97e3db | 2568 | 3d1f4a9c14622cf363c324d4925a1c664f0c51db986cbcbb2eab59b8b02ce579 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E1-10 | errata-witness | validate-pinned-fixture | 0.1.0 | 2059 | 6126923aa5ac7c11c91a34187caa7546fb5fa550af5883d9dec28bf5d024703b | 2098 | 75394888ec6688f04797c093431b6b2ac02659e07742573733b9c518f8037137 | success | Errata E1; Fixture Package §§2–6 |
| LCI0-E2-COVERAGE | errata-witness | apply-admissibility-floor | 0.1.0 | 20646 | af2cca9fdea16b83e657579433fb6549dc003a328ab64db259a5cef39ce097f0 | 13029 | da5614c353654b5644af7976bc55ca93276ba9b348ff44a8ae079f5f75e9f7f5 | success | Errata E2; Fixture Package §8 |
| LCI0-E2-INCOMPATIBLE | errata-witness | apply-admissibility-floor | 0.1.0 | 19388 | 620d95474777713d94ede49139dae4a8f3fc31450f370e0370893f4838ad153d | 10505 | 426f8741e1244c202b75fdf93e35520d2c78722adb63075f0fe365001f7b2f47 | success | Errata E2; Fixture Package §8 |
| LCI0-E2-NONMONOTONE | errata-witness | apply-admissibility-floor | 0.1.0 | 18386 | 145fe6877d7af9be72eec9713cdddba81810adf9ea05c0107338685012402a41 | 8503 | 0bd239c694764a12fae374af0620610ae0201e27dcef2617465d27891176684f | success | Errata E2; Fixture Package §8 |
| LCI0-E2-UNKNOWN | errata-witness | apply-admissibility-floor | 0.1.0 | 18776 | 0b5137452424d9d93649f8a9a98da7b71fe817fa6fab138d3a87fd425ff24a6e | 9291 | a855fbc2b5044fb4a8e8e2ccc01b5b8d22e7eb3aa2133c5ad9c082cec0413a76 | success | Errata E2; Fixture Package §8 |
| LCI0-E3-FIELD-OWNERSHIP-CHANGE | errata-witness | classify-version-governance | 0.1.0 | 867 | c2e0fd1595e797340887924b849fb1787e57e403d0e015c7a8e02b9df79f9bd0 | 699 | 4aa0c93f3c8f2cbabf23c92266e858f3c534b4a076b0dad80386511c427328f3 | success | Errata E3 |
| LCI0-E3-FIELD-SET-CHANGE | errata-witness | classify-version-governance | 0.1.0 | 853 | a27ec73a5475f5a2c2ba3e9dc1a9bb69cc90ece0c84e804cb9a60f96c8f53fbd | 699 | 4aa0c93f3c8f2cbabf23c92266e858f3c534b4a076b0dad80386511c427328f3 | success | Errata E3 |
| LCI0-E3-FRAME-SEMANTICS-CHANGE | errata-witness | classify-version-governance | 0.1.0 | 870 | faf853e147deafc6e0f8cc03a87a7a2fcf51aef95a76562e1df2adf96615267d | 717 | c6c9ec6a7ddf4bc841725686b13a7548b8db2c659d226aaceb738731f04386fb | success | Errata E3 |
| LCI0-E3-GRAMMAR-CHANGE | errata-witness | classify-version-governance | 0.1.0 | 852 | 94d00bbf9c895a92f69369f83c4062832c85405d1a2996769e3fcb614b9c1f4d | 697 | 76ed6e0cfb251af3e8b59f3d725bf6f437dda3948900cea8ec1b951a35f9b421 | success | Errata E3 |
| LCI0-E3-IMPLEMENTATION-CORRECTION | errata-witness | classify-version-governance | 0.1.0 | 890 | 53533e2678af07d6b409e298083e26a5c706bb898fd14cb2f7d570d2d3e6173c | 688 | 8e7933a4a37edafd96c4af8eccec6344376ee95e47eeadee71707964260bcab7 | success | Errata E3 |
| LCI0-E3-MEANING-CHANGE-SAME-VERSION | negative | validate-normalizer-revision | 0.1.0 | 19666 | 880faeb110426895604652c3d2c0f81f3aa9fc9fcf2c41bb237ee03060c31042 | 565 | cbbb21ae5742942ebfdfbd1f502d6ca4b58797af598213bb7732876e3df9eb75 | F(Id(["lisp-plus", "lci", "0", "failure"], ["unsupported-version-or-profile"])/Id(["lisp-plus", "lci", "0", "failure"], ["MeaningChangingNormalizerVersionReuse"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-profile"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["declared-claim-profile"])', 'Id(["lisp-plus", "lci", "0"], ["profile-version"])']) | Errata E3 |
| LCI0-E3-NORMALIZER-BINDING | errata-witness | validate-normalizer-conformance-evidence | 0.1.0 | 19099 | 4ce24e5f28d9908bb6862b44696924047c553e40d2e89b85f4c95aceda0bf7de | 677 | 125cff3c8ae76ff8202626f2ad4f31a584d93330a5ca7b7c67fe61b59788919f | success | Errata E3; Fixture Package §1 |
| LCI0-E4-MISSING-NEUTRAL-FRAME | negative | project-claim-id | 0.1.0 | 8048 | c5971a414bddf6b04d7dceca8de6e3c070c6e283d89d5c12c0375772481edf34 | 503 | 609ea48b497a770b740049154e305c56f7c52b0f947f63827e5076134af1c757 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["location-shape"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["interpretation-frame"])']) | Errata E4; Fixture Package §5 |
| LCI0-E4-STRUCTURAL-DATASET-SLICE | errata-witness | normalize-preprojection-coordinate | 0.1.0 | 5315 | 7cd9a7f9f3b23808897b2fafef638702fec8835995c6b1203130ec8d8255f0a7 | 3986 | 0b54b51104f2e8322ab8de9b438df6f8f565fd4f39f71e88aad2bf92fd3d4f9e | success | Errata E4 |
| LCI0-E4-STRUCTURAL-INTERPRETATION-FRAME | errata-witness | normalize-preprojection-coordinate | 0.1.0 | 5542 | 6641211ad8f392a3db6b986a0fb94fc3e809874ec21d61415074e2c337409e9b | 4199 | cac16401f8ddd55e0e706c1c1d6fe71aa307e3f95b5c091e66693c1978bb7759 | success | Errata E4 |
| LCI0-E4-STRUCTURAL-SEMANTIC-BOUNDARY | errata-witness | normalize-preprojection-coordinate | 0.1.0 | 4731 | f70542822f3bcee65f929c50666f09eb7e8c255e4f632caf5199c8593644acf7 | 3394 | 340c86758600b462c2f9e92fb87bfb57ff23e5a65f5766a832a4409e1e106469 | success | Errata E4 |
| LCI0-E4-STRUCTURAL-SUBJECT-TIME | errata-witness | normalize-preprojection-coordinate | 0.1.0 | 4212 | 668ce37330a65050ef862c5b07c7db9f094009ca1b72d19719d310b7beaf6ca9 | 2885 | 3f03dd102377c3a4ce011789dc64bb81ca801c3de0dbe50acbd712588e1c9ddc | success | Errata E4 |
| LCI0-E5-COVERAGE-INSUFFICIENT | errata-witness | match-target | 0.1.0 | 21896 | 08cbf5bde9a42d9180161f90f75c8b6bd5c7d8c2e453ed9aaa31718c6d42e773 | 2923 | dcc9deda2e494a8adab5e04a39c04d61c056d5b9bcb0a390c1667c67351dc613 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeNarrowingCoverageInsufficient"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["coverage-scope"])']) | Errata E5; Fixture Package §§2,7 |
| LCI0-E5-NONMONOTONE-NARROWING | errata-witness | match-target | 0.1.0 | 23613 | 2be02e42bcfb59b08b2fa1106f106f69e5ebab848c33a46bb6f55c25008a5625 | 660 | 00b98b050860db66a61ddd8c0ad913b526e7693a2eedf4080a0a1e636b131fa0 | F(Id(["lisp-plus", "lci", "0", "failure"], ["target-mismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeNarrowingNotDeclared"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0"], ["claim"])', 'Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])']) | Errata E5; Fixture Package §§1,2,7 |
| LCI0-E6-MULTIFAULT-CLAIM-SHAPE | negative | validate-claim-id | 0.1.0 | 10744 | 75e0adf7b877271775434ec3a787d700a8dc3aacf50c770b7a49b836f60ef38b | 468 | b56ab6f821a8f90908b83ef11d69e6d784e58ab150ca61a534fd79de5b4ae65e | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-shape"]); path=['Id(["lisp-plus", "lci", "0"], ["identity-policy"])']) | Errata E6; LCI/0 §18.9 |
| LCI0-E6-MULTIFAULT-TARGET-BOUNDARY | negative | validate-warrant-target | 0.1.0 | 14753 | dbf7fee014b0225bcb2a563e5eeede9df2fb44cb2c12992059e8148065e303e1 | 530 | 4a8693a30487c9446633f9b25c0c01377c045a4d9e84beeb76b5a35e5d3c2eb6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["observer-or-instrument"])']) | Errata E6; Fixture Package §7 |
| LCI0-E7-ALIAS-01 | negative | validate-stable-ref | 0.1.0 | 1017 | c8cf873e4d293fb057493844279cf31c9215c47b6c2fceab78dd4186ad2fed25 | 494 | d5c4babcd0c8660a09a4dc8421325842bde6a25b15b3a2a6131014ae88098bc6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-02 | negative | validate-stable-ref | 0.1.0 | 1017 | 0244c34d9585c308c82b51f71e7f8628092289dd495c66615724479cd9f410bc | 494 | bd034ca9d108f883150dd2593ba82f86354d152c827e9870eb6b73e497cc7e62 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-03 | negative | validate-stable-ref | 0.1.0 | 1041 | d803f05b1fc2060f34ecca14d8493648d252ca0457bd2ba799d04538dd78a899 | 494 | d17c4b42336dbaeb34b22623f061d96497c1fa92d080ce5d8de0a5b15e00e26f | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-04 | negative | validate-stable-ref | 0.1.0 | 1053 | 426c0b9b0bdd0915a1e465383a30d29f90df83b9454775736ce56e0ba56fc04f | 494 | 615f8712b834297f5cedae19e5295e0feee502ebbf148731cfc5aa333700df5b | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-05 | negative | validate-stable-ref | 0.1.0 | 1056 | f1894c189c920d367084df049d1b2b786bf9b77f1bb47eff6f97baf8498ad456 | 494 | dbb79948b7e0fde1a4304d9708f99ed7e166da0e731d7bc62e8c5ae04a5fc4fd | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-06 | negative | validate-stable-ref | 0.1.0 | 1017 | c722af2ccae18cfc650fc0a475852b6c834de809ba437a04a81a78ce4549edff | 494 | 0b5204d44a392ac1f455d19df6df92a5fda67f660abd1d29f620666f8821bce7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-07 | negative | validate-stable-ref | 0.1.0 | 1050 | f9614bf600d26147d91bcda27a396d7c60b27c7c3352af84a5cf591df7901a3a | 494 | a8e9bc7c9815f54cb50ae5c2a4f20cc8016246cda47a24d25d83d1dd7c4206a5 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-08 | negative | validate-stable-ref | 0.1.0 | 993 | 9336e8968ef9f41c7fdff71274c32c5c762708198e45205dbe746e6b7b1f026c | 494 | ee34f679eee85deddbb7e82bc6cf46784d546263b610651e8c49afdc9d20ea7a | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-09 | negative | validate-stable-ref | 0.1.0 | 1002 | 54d277971e2ba6f9f1b7988052bb7abb6c9f96fd01644044627e7cf915804b2c | 494 | a2cc67a5e18ab40cb5b25e1b175d23613a7a85a89845c11ed7939bca88addd69 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-10 | negative | validate-stable-ref | 0.1.0 | 990 | 09a24eded00a567fa17625d2e9e9f86a695f7093ea97503c9d79c50a1bb1c3d1 | 494 | ac01abeefecea44381dc98c5064b3974ec4a845df6fced95052edf0a42d00082 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-11 | negative | validate-stable-ref | 0.1.0 | 1026 | ba530785bbc8705c987cdfc7d5e911e59ca4cd5efc18c65fca53e4569aecef8d | 494 | 8769e42b5a58a165e928a177baf47e4dbd277894daf6e4f46decae05ebdc6a80 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-12 | negative | validate-stable-ref | 0.1.0 | 999 | 83e143f102b3927d3abc3e6d38fe49a780c83dcec59e2ddeb09bd0769dc4506c | 494 | cec1999092ea393c2c9f920550377f7163b778974097c5b5f1306d81918c21af | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-13 | negative | validate-stable-ref | 0.1.0 | 1002 | 564feb094de8e87a08cf1cab0dc0eff666c97909b31b6961bbde614d16b71d65 | 494 | 2a45474d949a92fab2f297ef09f3c163f71d4867d0892de8a2189ac8299f1f7c | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-ALIAS-14 | negative | validate-stable-ref | 0.1.0 | 993 | a852c783959c44768a14beab8a2164a1a779a755434a0caa1f89374eaabd43f0 | 494 | d98560bc74d2d28c7ecd7641394bd96947d2db2d3b1c4b9bd6ed95fd627de350 | F(Id(["lisp-plus", "lci", "0", "failure"], ["reference-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnresolvedAlias"])/Id(["lisp-plus", "lci", "0", "failure"], ["stable-reference"]); path=['Id(["lisp-plus", "lci", "0"], ["material"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["object-id"])']) | Errata E7; Fixture Package §6 |
| LCI0-E7-BRIDGE-ABSENT | errata-witness | compare-stable-refs | 0.1.0 | 1441 | 0fa0e781aab60fe7c21f88f6e7224a51ddc30aa65a9d469da898c097e8f0f86f | 626 | 1161dba54bd885c78f6e42c1bac59c064fcc2b4271dc3e48c095f8ebc38db63f | success | Errata E7; Fixture Package §6 |
| LCI0-E7-BRIDGE-NONRETROACTIVE | errata-witness | compare-bridge-source-and-target | 0.1.0 | 2980 | 388caf09c0b8945dc0603b0794479315e27190e4ffe2a268059123eb6d5f5ae7 | 584 | a58750ece625a6f9f917c1b82e2493f21e188f7850702634dc14742ae932d7d4 | success | Errata E7 |
| LCI0-E7-BRIDGE-PRESENT | errata-witness | apply-stable-ref-bridge | 0.1.0 | 2393 | d2c65c619ec037769e7fab1ea9eccfb867dafbd550b713ec194747aa3c92b1be | 1119 | 7d9285f695ded59812db6ba48c58e895edb27dbbe9c5a9c5dc749cff260ce893 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-01 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1243 | 8fbef356ccb0b0165c5973c9990022945e84ffaa1a633a21057afedea9002be3 | 619 | 23b77989b7f58b3e13cc5dbd0e9d5284c58be934279e7ef523c860d49c2d9bb0 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-02 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1248 | 0a381a034ca1ae1fdf07bf87fb8c89d39a8fca5fc5c96b084d21c05b4b6ed7e0 | 619 | ca93f8c16711203bb6a4d16aad768b08d9a2920175482f93a5561074ac57258b | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-03 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1289 | 3ce91c97ceefc755a1f433a969e8070ebb15a638f444ca9d5776981778541d9b | 627 | 1d042982c52efb4a05ad5a0977cee2a52398b490463f5002ab4bbee0c78d99c7 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-04 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1312 | ae0b2f0326434ce323358c3d7392491225526a0148036424755fa9d147277000 | 631 | 89a764e5a49e31d65c17a1b4c4191d75fd30fe610eb487aa347c2e00b8ecad46 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-05 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1314 | 1b630f8c47f48fbe22ee55ddc9810c2aac57b4c07fcc6f06ac64e24a68139e9f | 632 | 84ddc637059c2526cf763da35f5eb3f2722c5c703495fdae4097d7375dc1a6c6 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-06 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1242 | e76b6698b7c43bcc6f21bee5581dacf1b366e2bcbd3055a9f4222639e4b7ea6b | 619 | c5e270ce45785e195eeaf8cc9a9a8db10940ca1eef353f4d436cff55c121aef8 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-07 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1308 | d61dff7c162b2ff6f4ede7ef62c2fbdd58390524e92745ffb06141a9288aa790 | 630 | a7004db230964bf46cc7012fc893e30219ce82e17ff40a0d77263d7a694ec983 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-08 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1211 | 3612b6be1394f90a7680db4daeb030242c8a3ff94afff1d59f48166af9b9f339 | 611 | 53a7a95b3339a82c1d97b7182c88b1dbb7b125deb9aff527b38676c824ad99c3 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-09 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1233 | eedc72d2037a713396b24b5ad6beb0d76c527cbc4d3b1806432c3ee16e3b2a14 | 614 | 86cd0b4c3a762d10c87d9e76ef97a2be28590f2c4df741e637e5e098a572c61c | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-10 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1196 | e5c5d7730ac54e710dd8e382c01a088f9db067b938b1030a8d5f0230f2983eb6 | 610 | 69bb1edee6dc1f2c5f4ef0fdb42611610db2744afddcad9264c4a5f2334ba62b | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-11 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1267 | e93de0a92ed2ca6e8c0b9bd2f8c7a6ab0e93015f82302f34e762c5d4a3256f98 | 622 | f054536d44ab7c28773a2f87d638d3433e60846db48459b4854568907e2b2823 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-12 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1214 | ea62d5273275c741619b3eddc9bf66d976451603a93eddab25bb9cd2d9af3499 | 613 | 715e0f03a12e76145e1f0dc68d280bdc6131e91daab3303581f678bb4a409779 | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-13 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1221 | 1dd979d7ce8c4be77628abd8b44c534c452d115b2e1c7417ab2a54f63fb5c640 | 614 | b32b6caf51ad0ae7c7a71af3515175b1f997437860d9f1609809f8dfdd04ccba | success | Errata E7; Fixture Package §6 |
| LCI0-E7-SCHEME-14 | errata-witness | validate-stable-ref-scheme-selection | 0.1.0 | 1212 | 4db9955208608ffc997eed843b82226be430ede78ed0ee28882e7445a544d001 | 611 | 63645228cc7ae67aadf7e393fa70de7271086a50d71d4fc5b036771ed330a2d1 | success | Errata E7; Fixture Package §6 |
| LCI0-E8-DIGEST-NOT-ENVELOPE | errata-witness | compare-claim-digests-and-envelopes | 0.1.0 | 17636 | 18b93260938be8b6a0a508224e72dbd4dc58317fb7066cfc47d333b62d91a5eb | 627 | 4fed2d75601ddc509e55a11b94471fc36f79bfadfd208a7a8c06e5ac78ca9164 | success | Errata E8; LCI/0 §20.11; Frozen CD/0 §10.7 |
| LCI0-E8-DIGEST-ONLY-LOOKUP | negative | project-claim-id | 0.1.0 | 619 | 4efff48ea01771e658fd9abf567ec8f75b8869c77b849d2ca0b669adedbec2e3 | 472 | 971fc9dfebed766e72033646b9ee1acbafb680ed0e3e93de67b033072ce011c7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["projection-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["SelfDeclaredClaimId"])/Id(["lisp-plus", "lci", "0", "failure"], ["projection"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["digest"])']) | Errata E8 |
| LCI0-E8-OCTET-WITNESS | errata-witness | witness-semantic-claim-id-equality | 0.1.0 | 17324 | 30ee4ca981a6914201f00b7c742386aec991cfa4e85eb3ea102b3c4cded03148 | 565 | cb834f80fd21559196f139f68a198799a747b2b6e6f1b6b810a6ad28d7c33d6f | success | Errata E8 |
| LCI0-E9-AS-OF-MIDDLE-GROUND | negative | migrate-v1 | 0.1.0 | 3287 | 687c2662eaf0bf7b50e4ba95458dbed217bccf33dcd1d8a5f52b8aa560de2a9a | 527 | cbae07b7d74e7c9dd5416424e3f5cfc93dcc2d8f60f2865dccb9df1fa3c3a118 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnclassifiedAsOf"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-mapping"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["as-of"])']) | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-DEFERRED-TO-NAMED-CALCULUS | errata-witness | map-migration-classification | 0.1.0 | 1638 | 9beef88e3bc98318d60bcc795ac1d16caa791e1d9d675546e7ed95d7add53b2a | 1756 | 8e4606b5f3ce0b1abce4119207757fad43d0dcd4d9bf82a4ad0be9299aa1c541 | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-EXACT | errata-witness | map-migration-classification | 0.1.0 | 926 | 4a0b70948af2abfe69545b108edd8288124d1fcc5cc3469838495a118f611526 | 1044 | ae6b6cb45021b3c172de4a5eef3e6e172580f49ca38e36426f26338a3ccf17ad | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-EXACT-AFTER-EXPLICIT-TAGGING | errata-witness | map-migration-classification | 0.1.0 | 1776 | daa2e93ea2cd1570c338f018c794a4959cfb56a10c07f0616c056fda55dd7ced | 1894 | 9a0036dfa477588fbb90ea32e299fd1a60191cf06188e90c8f1a03b3a3ea9593 | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-LOSSY-WITH-REPRESENTED-LOSS | errata-witness | map-migration-classification | 0.1.0 | 2444 | edd6a110415c3929156177448d4911e98de0463d8342d913d2b565e78dd95011 | 2562 | 293664018769e99255e0e590315db4724dae923a87a93eb901113d02e8886008 | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-NEW-IDENTITY-REQUIRED | errata-witness | map-migration-classification | 0.1.0 | 1628 | a7b3fdfecf1bcbe229d5645bf637d5562436d48a7a929aa77eeaab298dd4fb4a | 1746 | 2c7b47863f29471c6c5409a4a171bfa97e4f3bfe300f8f12c7a341fa8deac2da | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-PRIVILEGED-RUNTIME-RELATION-OUTSIDE-CLAIM-ID | errata-witness | map-migration-classification | 0.1.0 | 1674 | c496a69d88e49c68f9a16f64dc1b418e825ecaceeb108028334c1359c485bd73 | 1792 | 9b8336bb20e60d734ecec8e747565b85919f30206556f1daaa284f188371421b | success | Errata E9; Fixture Package §9 |
| LCI0-E9-CLASS-REJECTED | errata-witness | map-migration-classification | 0.1.0 | 1133 | b155864eedfdbb94e1b5e31779fb8c23aafdc30d6f479f24907dc3de658c5393 | 1251 | 73e2f853dabb020ee479eddaf98db94731b23955a61943d7b006eb71d49efcf4 | success | Errata E9; Fixture Package §9 |
| LCI0-E9-HOSTILE-READ-EVAL | negative | parse-legacy-source | 0.1.0 | 2054 | 893ae41d06b3afb638f158235543e907adee4f7b1be03b4b4a036b44fba8a0fb | 484 | b986de7f5f1185e58b1804e11aab434481c0efcac6aed18350b380c2f4a7baf3 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnsupportedLegacyForm"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-source"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-bytes"])']) | Errata E9; Fixture Package §9 |
| LCI0-E9-INERT-PREDECESSOR | migration-robustness | migrate-v1 | 0.1.0 | 3881 | d39300b282039be324d36932fbf254b032a780a8257b87fe29d3063f903cd6ea | 31598 | 92c6b3f4994a2197aa222c8e76a1af2ad966cc64025b96a5eb43ae63dc36ec32 | success | Errata E9/I12(e); Fixture Package §9 |
| LCI0-E9-LIVE-RESTORATION | migration-robustness | restore-live-warrant | 0.1.0 | 3876 | 304a1d8920feddc2b7642abffbe59547da39f1cb3fee8f87f5c4eb2f7b418292 | 556 | bd2bd418c46fed52a510829335514d5ff631d5cb044a54c828ad21affc726228 | F(Id(["lisp-plus", "lci", "0", "failure"], ["privilege-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PrivilegedRestorationAttempt"])/Id(["lisp-plus", "lci", "0", "failure"], ["privilege-boundary"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["attempt-live-restoration"])']) | Errata E9/I12(c,e); Fixture Package §9 |
| LCI0-E9-NEAR-MISS-PACKAGE | negative | migrate-v1 | 0.1.0 | 3290 | f7b2040964370c9ef3646c424e4a3245a27d4389b40bc78d0e7ad98631c78523 | 576 | b27f9c2b2511bd4911c9fea9418d41a8a34bad0bf6a28b47d09990f96975173c | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["AmbiguousIdentifier"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-mapping"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["proposition"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["operator"])']) | Errata E9; Fixture Package §9 |
| LCI0-E9-PRINTER-PERTURBATION | migration-robustness | parse-and-migrate-printer-variants | 0.1.0 | 6229 | 43b21f6b8622ef12c758fc3992a6a7d800dacb33fc8b7262f2ec19850eaf5996 | 13075 | 4159ea7443c0601eeaa61e34c7aed6e574e4df519577cfbae97b2aa01bb30d2e | success | Errata E9; Fixture Package §9 |
| LCI0-E9-SEMANTICALLY-WRONG-MAPPING | negative | migrate-v1 | 0.1.0 | 3419 | 255107917acfd435da467e1b7d900122913eaea43da37251007b95081e68a48a | 563 | 016d9069fa78c095e6553deebbdda71fe91ab26caebb0b7ae50bebbfb5c1fa07 | F(Id(["lisp-plus", "lci", "0", "failure"], ["migration-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["SemanticIdentifierMappingMismatch"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration-mapping"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["parsed-inert-value"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["mapping-candidate"])']) | Errata E9; Fixture Package §9 |
| LCI0-E9-UNICODE-NONNORMALIZATION | migration-robustness | compare-unicode-claim-ids | 0.1.0 | 18218 | dbed8d15d06d8c185b62112b4f4a9300562716eef86173e3879395bb54fab236 | 605 | c35b51ef18d6b7270cc748247f7c63f432a5ef988cd9ef0e360986ec04719653 | success | Errata E9; Frozen CD/0 Unicode rule; Fixture Package §§1,9 |
| LCI0-I12-POLICY-META-TESTIMONY | clarification-witness | validate-policy-evaluation-target | 0.1.0 | 14211 | 389d700f844baaca895ea6d29db30e514b805e88ae52d2e762abc9e1ba133e08 | 894 | d8879664aa8bf4041dff14984c90b374027bfe4f3d7e7f1591dc80bbeee9292b | success | Errata I12(b); Fixture Package §7 |
| LCI0-I12-PROFILE-LOCATION-RESERVED | clarification-witness | validate-profile-location | 0.1.0 | 491 | fb21efa9f91fe93421455a7caa249967a372fd6e9b15d3467fd980d113f4e1a0 | 623 | a3de42d337c8333db651a2d512e66985517679ff688894b75dc65c4e434904c9 | success | Errata I12(a) |
| LCI0-I12-RECURSIVE-NESTED-VERSION | negative | validate-claim-id | 0.1.0 | 8866 | 0a9723bfb237358432e433404676e272f7d2e16bbdfbc2e641e803e044b9ae82 | 547 | 1c97153f8af7947af6299737cddf87909d115921540f8a02f3625b48469569cd | F(Id(["lisp-plus", "lci", "0", "failure"], ["unsupported-version-or-profile"])/Id(["lisp-plus", "lci", "0", "failure"], ["RecursiveUnsupportedNestedVersion"])/Id(["lisp-plus", "lci", "0", "failure"], ["scope"]); path=['Id(["lisp-plus", "lci", "0"], ["location"])', 'Id(["lisp-plus", "lci", "0"], ["scope"])', 'Id(["lisp-plus", "lci", "0"], ["schema-version"])']) | Errata I12(d); Fixture Package closed-schema rule |
| LCI0-LOSS-ACCOUNT-01 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 3206 | 0e2a7667cbc5256ca5fee95034b1e5686ec7e1c90ed6fc587482c2b2d5d351cd | 600 | 7ba38dc03f5cf079fab72dee3d9f8384b291f908dfedd4dcb925565725e72a0a | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-01-NEG | negative | validate-represented-loss-account | 0.1.0 | 3105 | 2e9c631dc3bdfbfba53e50f7a34414719c614695c450c1e5ddada7b204036e27 | 506 | 5ba2aafb681f86c2a1158e914f36070bf9a6488ecc2e4d59066a92f5133aa8d7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-format"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-02 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 1960 | e932731b7c2c9419ee827918bac628a204076da1ef2b4719da07d82d36c9ee80 | 599 | f3bbcd4c019d1b94c3df28487f81e83e927509d3a80e4d45a82f0083b8cff50e | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-02-NEG | negative | validate-represented-loss-account | 0.1.0 | 1876 | c2c627987eb1ec6858ff58f71259517d47987f252d24a4df4018b2497155d44a | 508 | f309897e23f06c49752baf7c7695816c84ccb521e50234d16223fed355a0c5b7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-language"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-03 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 2941 | d1026e1844737642c240241e6e00f75e135c4890afdf42d682c4d198083e4a82 | 602 | aef22ea71304a1570566da8c09ebba9c5b6147772ce1df579978c7b69042ce13 | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-03-NEG | negative | validate-represented-loss-account | 0.1.0 | 1803 | fadccedd7112f6d9074afe77175d60f2a273b4c83b91ccc0895d2f9ae121b246 | 509 | 1b51abbc3457db015bf8ad1bcde6938668e9189132ccc746538761e6697a870c | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-fragments"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-04 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 1830 | c446905aeeb33c4d5e91c1ff7736f49faf75c6b2751764032d1e5068840028f7 | 598 | 11fede4ba395ee714f1f590c493ba999a3bb7a0807d4cef246cfbbd396c766c2 | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-04-NEG | negative | validate-represented-loss-account | 0.1.0 | 1674 | dbbc8e81008ba6c5fa96ef15a57e08e9f52b2d0c79d618d35d2a19a9e1b86a86 | 516 | 32e74bf28010f54278bdbb3f5a80479da6c747fbf067f0e1b8ecd86bf28c926f | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["removed-metadata-fields"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-05 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 1900 | 1890f6b238622a57f41d759fa697fe18dff070ebddada4a985c40cec765981f3 | 606 | 661544514c8201d95e8748d1c16fc0321126f2a8ee795d6c3fea28ed1e1a252e | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-05-NEG | negative | validate-represented-loss-account | 0.1.0 | 1750 | 3b5b9d42866c5c2c735db500e45c2d59ef65e65975357a42ded4d52354c81133 | 510 | 82b5630826d9eaa63ad0d3b5356e97074f33a515993c720c6544e1ba9afe534f | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-identifier"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-06 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 1851 | 3782977065c38cd4c36f3a285deffd1dfdc282fa341285053bc22f8454b6c258 | 616 | 42f533333f63962e2e0541699bf28c823156a1a766ab6147597f972e946e0a64 | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-06-NEG | negative | validate-represented-loss-account | 0.1.0 | 1752 | a106aae8ca7fb6da44ec12faf99595dc3e75d8b25ac3031262bb89a6b161cf3e | 504 | 94ae12d129bf0751b96176d59dc4691420e5f5e661584734c11990612b17c79d | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-site"])']) | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-07 | represented-loss-account | validate-represented-loss-account | 0.1.0 | 2796 | bd02782ca4f2b2e875363daa3fa1155561514ece0f0b29b8cc51c95524fd39d8 | 595 | 6fa2d8640a1bd84b26fa7f5eb3319a034b4c50ac9d0bc26d4f932796ce81e8ba | success | Fixture Package §12 |
| LCI0-LOSS-ACCOUNT-07-NEG | negative | validate-represented-loss-account | 0.1.0 | 2195 | c1b861722f1357ba84fe01df92779d22f2a4019d5ce2d0cf4a9badee0142175a | 515 | da14ce0e864a4d84f3b2c9ca96ce2b4109a520c23ed30d97e35fe719eb654182 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["MissingRequiredField"])/Id(["lisp-plus", "lci", "0", "failure"], ["represented-loss"]); path=['Id(["lisp-plus", "lci", "0"], ["account"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["predecessor-occurrence"])']) | Fixture Package §12 |
| LCI0-METADATA-NEUTRAL-ALL-FIELDS | metadata-neutrality | project-occurrences | 0.1.0 | 42350 | 1f818bac1d15ac9e4c9d344135726888a64233fc7cadc736e44675bf3565d410 | 17608 | 368d438ebaef91d1de5ac7f1a85a341b2f01686e05b1b91f953e676f8fb0a1c5 | success | Fixture Package §11; LCI/0 §17.4 |
| LCI0-METADATA-UNKNOWN-TOP-CLOSED | negative | validate-occurrence | 0.1.0 | 21028 | 270c30f65b212331b0b19871dcc33c8170a18edbd2d3a03a2855dd61f89787f8 | 478 | 162d3978ca8de1b8637b3aa1061c1857e96b4f255f6fafc1d7a1635fab14cdd6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnknownField"])/Id(["lisp-plus", "lci", "0", "failure"], ["claim-shape"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["unknown-top-level"])']) | Fixture Package §11 |
| LCI0-RESOURCE-01 | negative | conformance-validation | 0.1.0 | 7676 | 91aea400bf483a022e647b8a4af03aec7cbee161ab6f759de26544adbb4483ce | 507 | 286789f639788826837f6ad77ffb77fecc2b8a721cf917bd7acdb618f8e0de40 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCIMaxNestingExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-02 | negative | conformance-validation | 0.1.0 | 7675 | 45b27ce35bb980faa59b3afe9da6d2681b4572bb6d047b1133a755b9653cb98c | 506 | 353cfe179ede757a9a46aad380cc658b9bde7815d9acd8aa85705d9b904fe6b7 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCINodeCountExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-03 | negative | conformance-validation | 0.1.0 | 7681 | 54c490e3d14c12842aca5c584a5a7f066a10b9191d3f4a9ab909a1c1b97075ba | 514 | 5ddb07243ad111fa33cffe7132e0197844eb5f0f1eccd1d28a4f7ed29bb8cf61 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCIRecordFieldBudgetExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-04 | negative | conformance-validation | 0.1.0 | 7676 | 773cc3117bd483276dc50c3b3c23d02cb3efb250c54caddcdae3cdd36e325c80 | 517 | 01cae09ecc852a7c9ef8d940e35f384448927a5356723f60a717038d13bf15ec | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCISequenceLengthBudgetExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-05 | negative | conformance-validation | 0.1.0 | 7688 | b748e3d6d5d22963e150bd5810e5511907f27abe299503f4cda9893696b756fd | 520 | 5067a56594c5faed6c967681917a21b5e2b06a18399c6edff7ed36f3b4187e4a | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCIIdentifierSegmentBudgetExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-06 | negative | conformance-validation | 0.1.0 | 7682 | edb07b74e019b846996389acfa37cf34a7862156d7a6caa96ce7b8e7a8555305 | 519 | e2de101947a616b9217af368ef9bf4731d51bc8b3a8d8e56325155ef14ea1641 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["LCIAggregatePayloadBudgetExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-07 | negative | conformance-validation | 0.1.0 | 7709 | 9d25a94269b925ab85911e367261120c1c80d0e8e274f20e92b2e9b9aea8061a | 523 | 350753331a6b6730ee59b3b5c6b9b9f40f50f6fb07810f340b23abfa06a84291 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["StableReferenceMaterialBudgetExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-08 | negative | conformance-normalization | 0.1.0 | 7694 | 66341e8516ae9976c9e406d6b25a3e91895338b297076bc6992faa758922e95a | 525 | 20f6799f1eb23ed3c6f49c20540e016c3f3426c245e6f06f34e53a768f711cea | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["PropositionNormalizationWorkExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["normalization"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-09 | negative | conformance-matching | 0.1.0 | 7681 | b405570f0b342484386fc5a26d12a42e91e8ab522eff90114b10ad1117fa7861 | 509 | 80d4e29b31d354b5452076550179db3bd90e430ad74e595ea4f25810e19d56a4 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeRelationWorkExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["matching"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-10 | negative | conformance-matching | 0.1.0 | 7687 | dfad27009b64a8f2a522e7a0859e27f67a61bd5cfe0b1f9d8b9fe7a840f0abe2 | 512 | f76a0c750b5a6d925284820695b84b95af9f407067ad3e58c8677f2731cfa3d3 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["TemporalRelationWorkExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["matching"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-11 | negative | conformance-migration | 0.1.0 | 7693 | aba8d067ba478854660621008cf84aeb55cce7d03a4248b5752c6b7017233664 | 511 | 8608065a2b7d780f28d68065d253d2eb954c518fefaa448a699ddc843e573232 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["MigrationInputSizeExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["migration"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-12 | negative | conformance-validation | 0.1.0 | 7686 | 5b5751ea1019c67bd5750c371d5bdf3864ebde144330367ec3c1ebb54910d04b | 512 | 0ddd3f458fb6fbeedfb48c0800c96be27d5e34717eadafeb855bfcec56e520e8 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryWorkExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-RESOURCE-13 | negative | conformance-validation | 0.1.0 | 7700 | 90a0e87b80791f6fa6a0893141e94d6dc6a980d1e68dacd4e4b6f7605935a916 | 520 | a1c0b5e26aee2f4bc2300ab9223707b490443aa67c3f5a5c4d9cfd176d8f5fa9 | F(Id(["lisp-plus", "lci", "0", "failure"], ["resource-refusal"])/Id(["lisp-plus", "lci", "0", "failure"], ["RepresentedLossAccountSizeExceeded"])/Id(["lisp-plus", "lci", "0", "failure"], ["validation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["workload"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["requested"])']) | Fixture Package §10 |
| LCI0-SCOPE-ORG-DEPT | scope-relation | scope-relation | 0.1.0 | 2668 | 629c3268247809b961c2bb0a3396ac4de7ed45aca0ca840179470cbc0f1b8b03 | 454 | e3495366e00196e7037a48dd91786d6ac666aa21640cdc6e44c14a9386c302f9 | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-REGION-EAST-NORTH | scope-relation | scope-relation | 0.1.0 | 2554 | 518c6c221abcade34f4065c36462a8726d018c58c2acb058ae41f8225b6a5cf8 | 457 | 0f966ad4f59e1a6cfad0bf51418a22ace70510bf71ed2a3d7ff59d5a5ed94453 | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-REGION-NORTH-SOUTH | scope-relation | scope-relation | 0.1.0 | 2556 | 420724dcaf0a6c914ac1de016ee3417f38e52e653348533928bc041530ba4f2c | 457 | 0f966ad4f59e1a6cfad0bf51418a22ace70510bf71ed2a3d7ff59d5a5ed94453 | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-REGIONAL-OVERLAP | scope-relation | scope-relation | 0.1.0 | 2658 | 3a9a4be8451b498549e108d26988f57b5ecff1474e0a13ea3fc33cb56a66e3e4 | 456 | e64c8508bc0df029277f3cf28a0f95093137c086e622eec60d8e73a0bf1f4fdd | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-SYMBOLIC-UNKNOWN | negative | scope-relation | 0.1.0 | 2635 | a61431ae60a8e04d2d0e81732b0425ee947267bbaf991bf392572f95e6d487f1 | 481 | e865129868c39521af3278a8af3221dc67d1fbd352ff766621a19bdf38dc6fab | F(Id(["lisp-plus", "lci", "0", "failure"], ["relation-undetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["ScopeRelationUnknown"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-relation"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["right"])']) | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-TENANT-DISJOINT | scope-relation | scope-relation | 0.1.0 | 2739 | 2e07ed6ad55138d1739de2f4c613f27e0a6963e6ab5e259b12b141da0518ff44 | 457 | 0f966ad4f59e1a6cfad0bf51418a22ace70510bf71ed2a3d7ff59d5a5ed94453 | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-SCOPE-UNIVERSAL-ORG | scope-relation | scope-relation | 0.1.0 | 2464 | 5b7a5d1c3c3a24dc216179386f889a78680554660d39837426f79f0abadcfe52 | 454 | e3495366e00196e7037a48dd91786d6ac666aa21640cdc6e44c14a9386c302f9 | success | LCI/0 §11.7; Fixture Package §2 |
| LCI0-TARGET-01-OBSERVED-NEG | negative | validate-warrant-target | 0.1.0 | 13182 | 6a6eb8360523b2daaf18b3c690c7877be748987c292ac3676916733660086a01 | 523 | 326529365df488eec29f2e594d229f14da6b6bc68ee3ce7e06b12f17d8bca56b | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["observer-or-instrument"])']) | Fixture Package §7 |
| LCI0-TARGET-01-OBSERVED-POS | target-schema | match-target | 0.1.0 | 22219 | 9c8c5bf06a44c6bedda3349e5c2910c16a32fac54f40b62bf72256c7002a8952 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-02-EXECUTED-NEG | negative | validate-warrant-target | 0.1.0 | 15200 | 20e106a51e62c81ee3d9df090f1c76a50b21d1a142a1aa0230e9772814fee1bb | 520 | 33e3719fb8807058cac597e9bc757553731e6279daad125a4e1718cdaee06ef6 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["procedure-reference"])']) | Fixture Package §7 |
| LCI0-TARGET-02-EXECUTED-POS | target-schema | match-target | 0.1.0 | 25130 | 44e529d4e188a1e4f66a2c7231e6253537e25f09e679c1bd26c77a53ab90167d | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-03-TESTED-NEG | negative | validate-warrant-target | 0.1.0 | 14294 | 0372cc8eae3e7dac8d063525e4a3a7d35f3b1bc541bf3743132fd1db461a1357 | 529 | 3dba9763aef750572b0eee48beba21987ed26125ea0ac8c3128060d29694c363 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["system-or-procedure-under-test"])']) | Fixture Package §7 |
| LCI0-TARGET-03-TESTED-POS | target-schema | match-target | 0.1.0 | 23022 | 10d5d11800a7ec094b681250befc0ad3a70bba9ec40ec9283e5ecd51be461c95 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-04-DERIVED-NEG | negative | validate-warrant-target | 0.1.0 | 20101 | b761424b4b71c38d3cc02941857913a816ae880ceef2de327835a069ae7418f2 | 518 | c71ec7547f6c900915a176ae2ed667acba8f36b45fb96cd02e074f2b8be87c15 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["inference-calculus"])']) | Fixture Package §7 |
| LCI0-TARGET-04-DERIVED-POS | target-schema | match-target | 0.1.0 | 29030 | 43f6e1a0439791b1166e71f9347fab410514171892ad3d636fb08049a0512261 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-05-EXTERNALLY-ATTESTED-NEG | negative | validate-warrant-target | 0.1.0 | 13111 | da9424a99d94f99d36004c3a3dd41fc99ed271c47dd306037a4d78cc1369f94c | 530 | d324878dfaa38e425e66dd67cd34f08806d617ba9c7eded59d248b77aa817708 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["external-principal"])']) | Fixture Package §7 |
| LCI0-TARGET-05-EXTERNALLY-ATTESTED-POS | target-schema | match-target | 0.1.0 | 22144 | 0c369a573908322fa5fcbb1c06b0fbe40d7ab8f4811220a5018d3022f60b936e | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-06-REPLAYED-NEG | negative | validate-warrant-target | 0.1.0 | 14886 | 7e5749579ae2247db3daaf88f409bf42479c90f257a0aa0e61ce0f5b7a174724 | 539 | b5715f1ea214148547474790f31de9afcece8d1ff7e2e00a0d3840649ae95494 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["predecessor-warrant-testimony-or-event"])']) | Fixture Package §7 |
| LCI0-TARGET-06-REPLAYED-POS | target-schema | match-target | 0.1.0 | 23955 | 7823d94188c1210b23923d5b83eeb1d4dc15437c560129f721e6c6ec6ec06338 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-07-CORPUS-COMPLETION-NEG | negative | validate-warrant-target | 0.1.0 | 26230 | f6d5b768e6b9fe19ca487e3f149ae2d6f2e1ed0107ca9aa7d41541aa69052b84 | 528 | a6587b732c8d073aac13d2bce9e478b2d8f99eec4131a78c14b138319a3645bf | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["exact-corpus-basis"])']) | Fixture Package §7 |
| LCI0-TARGET-07-CORPUS-COMPLETION-POS | target-schema | match-target | 0.1.0 | 42921 | 67ece3b703e08e665791d707724dbcc2b37a8997c56085b4848d6758fc455abc | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-08-REPORTED-NEG | negative | validate-warrant-target | 0.1.0 | 13539 | da3b0cb38a0cb9c4bed1c5c56e5f9527a91e71983fc7a77b80e51925c2669168 | 529 | b7a0ab7b5818199a77d8d79446174f4ccad64bf088e4fc9b6daae1f8b6903e3a | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["reporter-or-source-principal"])']) | Fixture Package §7 |
| LCI0-TARGET-08-REPORTED-POS | target-schema | match-target | 0.1.0 | 23033 | 681a4b732f6189f8c90c55c60b769c749d928bb27db254864b3d6574f69f66ff | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-09-INHERITED-NEG | negative | validate-warrant-target | 0.1.0 | 16274 | 13eff6edf9602dc1e45e37b8871f98c871e99d0ae88e1738d69b88de3592e9b2 | 536 | 91a191724595022cc0d3abfc4024e174df0a8b4d7449aa7c3bf1df777753c761 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["predecessor-occurrence-or-artifact"])']) | Fixture Package §7 |
| LCI0-TARGET-09-INHERITED-POS | target-schema | match-target | 0.1.0 | 25326 | fdede19493bd595363628e6cd7242583733c091c7b275bb825401e77e0c55c17 | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-10-TRANSLATED-NEG | negative | validate-warrant-target | 0.1.0 | 18444 | d1df0be8e6cfe4dc6805d31764b66a87b7303b0d3302d2dcfd00894562bebe72 | 518 | 8c339b0beb9d935aec16be1cea02a263363b6f5a29f432f8ff799c85c0e185a2 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["source-claim-id"])']) | Fixture Package §7 |
| LCI0-TARGET-10-TRANSLATED-POS | target-schema | match-target | 0.1.0 | 36337 | 11c5790b9f6f6056a9bd78eb8d6adf307f2c3313a0ea5b0d7b7798b08e15496c | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TARGET-11-POLICY-EVALUATION-NEG | negative | validate-warrant-target | 0.1.0 | 13624 | 709c3bb1121d9fba13a03e78a27ba9d72bade325e4adc030077a6a0d0cb6bfb1 | 516 | 20407a3852369b818d2cdb84eaf4992a3e1545cf715857f546a6df085c97da26 | F(Id(["lisp-plus", "lci", "0", "failure"], ["invalid-input"])/Id(["lisp-plus", "lci", "0", "failure"], ["TargetBoundaryMissing"])/Id(["lisp-plus", "lci", "0", "failure"], ["target-boundaries"]); path=['Id(["lisp-plus", "lci", "0"], ["boundaries"])', 'Id(["lisp-plus", "lci", "0", "fixture", "field"], ["policy"])']) | Fixture Package §7 |
| LCI0-TARGET-11-POLICY-EVALUATION-POS | target-schema | match-target | 0.1.0 | 22642 | feb80e7d750421df1aa7cf36bb04f1718ffe47e448c7846ba5e88b6f5bf85d4d | 741 | df040642df341763ca1db5b2c2308f603e5ec1761d2e557a865f330be5d70ff2 | success | Fixture Package §7 |
| LCI0-TEMPORAL-AFTER | temporal-relation | temporal-relation | 0.1.0 | 2481 | 9882b1d02cfece1516f4fa28bda014b02ae9d717ab984008b9be4b5b1d3fc025 | 521 | 17bf6e453abea0cb15359c96a5febd3cf60edc268d1098aff2706bcb1c45c43b | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-BEFORE | temporal-relation | temporal-relation | 0.1.0 | 2482 | 7f43ea8670f2010cede312a50ca5fda625922d82e78486eee34ed6169ede51f3 | 522 | df06f7bcd589da6112894b766aa259e9062a0b7a09e492c4409db5618afeef62 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-CONTAINED-BY | temporal-relation | temporal-relation | 0.1.0 | 2622 | bd47942052b5b409ad1628ca1c3a02fe5799f3ae2b5a010a08a5fb859f401b31 | 528 | cf788c607c48f80448d10bb7c549d0ca66c6614803d52901d5b6370c74cd8630 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-CONTAINS | temporal-relation | temporal-relation | 0.1.0 | 2618 | 75a7ff9e50371aedea00e16d63d962814007e600fec39c6a4891bce1c2e8700d | 524 | 880e08202bc7a5a158093c431ece808b10134785c5d39d1511b49ba7df044768 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-DISJOINT | temporal-relation | temporal-relation | 0.1.0 | 2750 | de7c991a04e3a9ccd5624e9c6f71d2a0e3f3270936b15577b6d144eb2108906a | 522 | df06f7bcd589da6112894b766aa259e9062a0b7a09e492c4409db5618afeef62 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-EQUAL | temporal-relation | temporal-relation | 0.1.0 | 2481 | 1c2a3f34957fa5acb5dc33ac63f09698ebd77d8ecd0f2cf94f53a08ef308fab7 | 521 | ce1117e9ded237af1a43b6c239c8a31fca27ee274e700dad8fdacc8226142a09 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-INCOMPATIBLE | negative | temporal-relation | 0.1.0 | 2553 | 89ce60755c77c5d12f93f395c5463b2c77f45f45bc8846e1a960b81a6d33f92e | 515 | 99a42764110da9062ee478710062e9194119f7ecf6d50da570abc44f4ee793ed | F(Id(["lisp-plus", "lci", "0", "failure"], ["relation-undetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["UnsupportedTemporalModel"])/Id(["lisp-plus", "lci", "0", "failure"], ["subject-time"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["right"])', 'Id(["lisp-plus", "lci", "0"], ["temporal-model"])']) | Fixture Package §3 |
| LCI0-TEMPORAL-OVERLAP | temporal-relation | temporal-relation | 0.1.0 | 2751 | 1f904a8e6f29c1c676341c98365d75a4a5a8b093ec55e2adcc489f77a6140df1 | 524 | 880e08202bc7a5a158093c431ece808b10134785c5d39d1511b49ba7df044768 | success | LCI/0 §12; Fixture Package §3 |
| LCI0-TEMPORAL-UNKNOWN | negative | temporal-relation | 0.1.0 | 2547 | e1e07468c5124f841fb5b38e5fd47655d72d91479a5c26ea3a59038d56a404ff | 476 | 638d0b85fd29e37aa468a39ba62af163514a9db218653d4656a85de80ecc5160 | F(Id(["lisp-plus", "lci", "0", "failure"], ["relation-undetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["AdmissibilityUndetermined"])/Id(["lisp-plus", "lci", "0", "failure"], ["subject-time"]); path=['Id(["lisp-plus", "lci", "0", "fixture", "field"], ["left"])']) | Fixture Package §3 |
