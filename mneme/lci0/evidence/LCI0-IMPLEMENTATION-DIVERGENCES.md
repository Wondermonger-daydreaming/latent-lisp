# LCI/0 Implementation Divergences

This ledger is append-only. It records specification, fixture, adapter, harness,
implementation, and host-semantic disagreements. Neither implementation is an
oracle.

## LCI0-DIV-001 — temporal prose labels versus exact machine relations

- Status: disclosed and dispositioned for implementation; permanent witness retained.
- Sources: Fixture Package Specification §3, lines 124–134; Appendix B rows
  `LCI0-TEMPORAL-OVERLAP` and `LCI0-TEMPORAL-DISJOINT`; registry
  `temporal_relation_table_0`; Fable PASS receipt documentation note, lines
  193–198.
- Minimal input A: primary-model intervals `[100,124]` and `(100,124]`.
- Minimal input B: primary-model intervals `[0,50]` and `[200,220]`.
- Fixture-spec prose result: A=`overlap`; B=`disjoint`.
- Registry/vector result: A=`contains` (expected-document SHA-256
  `880e08202bc7a5a158093c431ece808b10134785c5d39d1511b49ba7df044768`);
  B=`before` (expected-document SHA-256
  `df06f7bcd589da6112894b766aa259e9062a0b7a09e492c4409db5618afeef62`).
- Common Lisp result: returns the precise machine relations, A=`contains` and
  B=`before`.
- Python result: returns the precise machine relations, A=`contains` and
  B=`before`.
- Classification: disclosed fixture-spec illustrative-label defect. The PASS
  receipt explicitly states that the machine vectors and normative relation
  table are the precise executable result, while the prose labels are coarser.
- May implementation continue: yes, using the exact registry/vector relation
  table and retaining this witness. No generalized rule is inferred from the
  vector names.
- Proposed/permanent disposition: both implementations must return the precise
  table result; a regression test must also detect if the sealed prose, table,
  or vectors change. Any future package revision should correct the two prose
  labels without rewriting this frozen package.
- Permanent regression-vector status: required; the original frozen vectors
  remain unchanged.

## LCI0-DIV-002 — Common Lisp fixture adapter normalizes invalid rationals

- Status: confirmed during hostile package-surface integration; permanent
  regression required.
- Sources: user-authorized JSON fixture-adapter warning (the adapter is pure,
  total, performs no semantic inference, preserves exact rational
  normalization, and fails closed on unknown shapes); Fixture Package
  Specification §13 exact-byte authority; frozen CD/0 rational canonicality.
- Minimal input A: `{"t":"rat","num":"2","den":"4"}`.
- Minimal input B: `{"t":"rat","num":"1","den":"-2"}`.
- Common Lisp result A: accepted and normalized to canonical CD/0 `1/2`,
  document hex `4c50434400110202`.
- Common Lisp result B: accepted and normalized to canonical CD/0 `-1/2`,
  document hex `4c50434400110102`.
- Python result: both inputs refused with `NoncanonicalFixtureRational` before
  datum construction.
- Expected fixture result: refuse both surfaces. The package adapter may
  translate `num`/`den` field names to the frozen codec's `p`/`q` names, but
  it may not reduce a fraction or move a denominator sign and thereby infer a
  different accepted package datum.
- Classification: Common Lisp fixture-adapter defect.
- May implementation continue: yes on unaffected portions. Every rational in
  the sealed 1,105 official documents and 488 supplementary documents is
  already canonical, so this hostile admission defect does not change their
  expected decoding or octets.
- Proposed disposition: correct on a reviewed Common Lisp successor branch,
  without rewriting the immutable seed; retain canonical positive coverage
  and hostile reducible, negative-denominator, zero-numerator, and
  denominator-one refusals.
- Permanent regression-vector status: required as an integration-hostile
  adapter case. The frozen normative registry and vector files remain
  unchanged.

## LCI0-DIV-003 — Common Lisp accepts prohibited mutable StableRef aliases

- Status: confirmed during hostile StableRef integration; permanent
  regression required.
- Sources: LCI/0 §7.2 and §14.2; Errata E7; Fixture Package Specification
  §6; the authorized hard prohibition against a display model name, filename,
  or mutable URL satisfying stable identity.
- Minimal construction: start with
  `stable-ref.artifact.file.alpha` and replace only the material `object-id`
  path with one of the following, retaining exact artifact domain, structural
  scheme, material kind/version, and object-version:
  - `object/artifact/display-model` — 545 canonical bytes, SHA-256
    `e6da1b3bb48c79fc75f71e1adb99c59197b23286dca780182f93567346cbdd4a`;
  - `object/artifact/file.txt` — 540 canonical bytes, SHA-256
    `7c98d66071b2293ccc38002466894da323cdc0909da59c64bc1fc2df9a3877ca`;
  - `object/artifact/https://mutable.invalid/x` — 557 canonical bytes,
    SHA-256
    `0501af7b9788fcc9b29c0c1bc9e8923dadb46e03d59b391cc7f3b8693acd651b`.
- Common Lisp result: accepts all three values as validated StableRefs.
- Python result: refuses all three with
  `reference-refusal/UnresolvedAlias/stable-reference` at
  `material/object-id`.
- Expected fixture result: fail closed. A display model name, filename, and
  mutable HTTP(S) URL are explicitly insufficient stable identity material.
- Classification: Common Lisp StableRef validation defect.
- May implementation continue: yes on unaffected portions. The sealed
  official and supplementary corpus contains pinned immutable fixture
  material, and all fourteen frozen alias vectors remain determinate.
- Proposed disposition: correct on a reviewed Common Lisp successor branch,
  without rewriting the seed; test the complete prohibited alias vocabulary
  case-insensitively and HTTP/HTTPS prefixes while retaining the exact fixture
  schemes as the only accepted schemes.
- Permanent regression-vector status: required as three minimized hostile
  StableRef cases; frozen normative artifacts remain unchanged.

## LCI0-DIV-004 — Common Lisp scope table is incomplete

- Status: confirmed by exhaustive execution of all 169 scope-table entries;
  Common Lisp passed 117 and disagreed on 52, while Python passed 169.
- Sources: Fixture Package Specification §2; registry
  `scope_relation_table_0`.
- Minimal subcase A: `scope.universal` versus `scope.symbolic-unknown`;
  relation carrier is 2,202 bytes with SHA-256
  `0f78c2183b564c8d70b594f3d0cdea2aacd1ea6aa87661b977b47814e919a712`.
  Common Lisp returns `unknown`; the fixture and Python return `wider`.
  Reverse orientation is expected `narrower` but is also `unknown` in Common
  Lisp. This affects 2 entries and shows symbolic refusal masking universal
  subsumption.
- Minimal subcase B: `scope.org-acme` versus `scope.region-x`; relation carrier
  is 2,292 bytes with SHA-256
  `f79e9ce2ec203be5a2ad99a4dddbd6f1f762b4ffadbbe959b008cb48b5997cd3`.
  Common Lisp returns `disjoint`; the fixture and Python return `unknown`.
  Organization, two department, and two tenant scopes crossed with five
  region-set scopes in both orientations account for 50 entries.
- Classification: Common Lisp scope-calculus defect. Absence of a declared
  mixed-form relation is not proof of disjointness, and universal comparison
  precedes the symbolic-unknown refusal in the frozen table.
- May implementation continue: yes on unaffected paths.
- Proposed disposition: successor-branch correction derived from the complete
  exact table, without rewriting either seed or the fixture.
- Permanent regression-vector status: full 169-entry execution plus both
  minimized orientation pairs is required.

## LCI0-DIV-005 — Common Lisp atemporal relation rule is incorrect

- Status: confirmed by exhaustive execution of all 289 temporal-table entries;
  Common Lisp passed 259 and disagreed on 30, while Python passed 289.
- Sources: Fixture Package Specification §3; registry
  `temporal_relation_table_0`.
- Minimal subcase A: `subject-time.atemporal` versus
  `subject-time.instant-0`; relation carrier is 2,141 bytes with SHA-256
  `61187288f6a9e0f803275934551f519f2520172166548794fd344469adb67810`.
  Common Lisp returns `disjoint`; the fixture and Python return
  `incompatible`. Atemporal crossed with six instants, six intervals, and two
  periodic sets in both orientations accounts for 28 entries.
- Minimal subcase B: `subject-time.atemporal` versus
  `subject-time.symbolic-unknown`; relation carrier is 2,206 bytes with
  SHA-256
  `2df02014cfb535b415cb0b68d5b69154d6c419eb466004f3ea428e7a9c053bac`.
  Common Lisp returns `unknown`; the fixture and Python return `incompatible`
  in both orientations. This accounts for 2 entries and exposes a precedence
  variant of the same atemporal rule defect.
- Classification: Common Lisp temporal-calculus defect. Every unequal
  atemporal/non-atemporal pair in the frozen table is incompatible.
- May implementation continue: yes on unaffected paths.
- Proposed disposition: successor-branch exact atemporal rule, preserving
  temporal containment's separation from direct target matching.
- Permanent regression-vector status: full 289-entry execution plus the two
  minimized orientation pairs and each non-atemporal form family is required.

## LCI0-DIV-006 — universal/symbolic scope table conflicts with the N012 matcher witness

- Status: confirmed normative conflict; the affected `match-target` path is
  blocked for authorial disposition. Unaffected implementation work may
  continue.
- Sources: LCI/0 §10.6 and §25.3 N012; Errata E2; Fixture Package
  Specification §2; registry `scope_relation_table_0`; vector `LCI0-N012`.
- Minimal table witness A: `scope.universal` →
  `scope.symbolic-unknown`, expected relation `wider`, 2,202 bytes, SHA-256
  `0f78c2183b564c8d70b594f3d0cdea2aacd1ea6aa87661b977b47814e919a712`.
- Minimal table witness B: `scope.symbolic-unknown` → `scope.universal`,
  expected relation `narrower`, 2,205 bytes, SHA-256
  `1835d1e18a0b620047ba9e684ebb45b4db4494117b7d990da44fc28c4eb2d49b`.
- Matcher witness: `LCI0-N012`, input 22,369 bytes, SHA-256
  `050fb0d6637406dff7c9bfe9070005bb3d25ad6df15ac1b6124b29c4ea2a91a6`;
  expected failure document 502 bytes, SHA-256
  `4c69d1ef399987736d84acd4fd159da884ff0260ee1a9fb13b73770588eba746`.
- Common Lisp result: `LCI0-N012` returns the pinned `ScopeRelationUnknown`
  failure; its current direct scope engine also returns `unknown` for table
  witness A, which independently causes DIV-004.
- Python result: `LCI0-N012` returns the pinned `ScopeRelationUnknown`
  failure; its direct scope engine returns the table's `wider` relation for
  witness A.
- Expected fixture result: the table and N012 expected document are each exact
  machine-readable obligations, but the frozen matcher algorithm does not state
  an exception that makes both outcomes follow together.
- Classification: fixture-package/specification-errata ambiguity.
- May implementation continue: yes, except for the exact N012
  universal/symbolic matcher path. The direct 169-entry scope relation table
  and all other matcher paths remain separately testable.
- Proposed disposition: authorial return is required. Two non-authoritative
  possible dispositions are recorded in
  `LCI0-AUTHORIAL-RETURN-PACKET.md`; neither implementation may silently select
  one.
- Permanent regression-vector status: both table orientations and N012 are
  permanent conflict witnesses. N012 is blocked, not passed, failed, skipped,
  or N/A, until authorial closure.

## LCI0-DIV-007 — Python does not reproduce four determinate failure documents

- Status: corrected after provenance review of the five baseline mismatches.
  Four are Python representation defects. The coverage-context mismatch is the
  separate normative conflict `LCI0-DIV-015`.
- Sources: Errata I12 deterministic structural paths and failure comparison;
  Fixture Package Specification §§11–13; vectors `LCI0-N025`,
  `LCI0-E5-NONMONOTONE-NARROWING`, `LCI0-E8-DIGEST-ONLY-LOOKUP`, and
  `LCI0-E9-NEAR-MISS-PACKAGE`.
- Minimal observations:
  - `LCI0-N025`: expected-result SHA-256
    `2b3fa8dbb819467953fdc3c2578b3ecfb13b6ece40e186982031472940d2a83e`;
    Python result SHA-256
    `00878b9614fd4effe8583bbc01e8c25102a5b8c9404dfc9c55cc09e93961b2c7`.
  - `LCI0-E5-NONMONOTONE-NARROWING`: expected
    `00b98b050860db66a61ddd8c0ad913b526e7693a2eedf4080a0a1e636b131fa0`;
    Python
    `f66684370784d07f4c019eca3ef3d6c34c56a970ce9bb9fe28e02abc90d5c48b`.
  - `LCI0-E8-DIGEST-ONLY-LOOKUP`: expected
    `971fc9dfebed766e72033646b9ee1acbafb680ed0e3e93de67b033072ce011c7`;
    Python
    `28b6da608b1428a4133544929176f8d2ec281496120de117ac3796cfc2706e94`.
  - `LCI0-E9-NEAR-MISS-PACKAGE`: expected
    `b27f9c2b2511bd4911c9fea9418d41a8a34bad0bf6a28b47d09990f96975173c`;
    Python
    `c8ade50ba7fc2c41ad9adb4cfcaeac7c27db10fa43c1e252e4cb1054e2ee6d21`.
- Common Lisp baseline result: reproduces all four exact expected documents.
- Python result: category, code, stage, and path segment names agree, but three
  structural path identifiers carry the wrong namespace and the nonmonotone
  target failure omits its input-derived pinned context record.
- Expected fixture result: the four exact canonical expected-result documents,
  including structural path identifier identity and closed context.
- Classification: Python failure-document representation defect for these
  four vectors. No classification from one implementation was used as an
  oracle.
- May implementation continue: yes on unaffected paths; these four vector
  results cannot be counted as passes.
- Proposed disposition: correct on a reviewed Python successor without
  consulting expected results at execution time; retain exact result-document
  comparison in the integration coordinator.
- Permanent regression-vector status: the four existing vectors are permanent.

## LCI0-DIV-008 — both StableRef validators accept non-exact fixture identifiers

- Status: confirmed by four minimized E7 hostile witnesses.
- Sources: LCI/0 §§7.2 and 14; Errata E7; Fixture Package Specification §6 and
  the fourteen registered StableRef schemes.
- Minimal witnesses, all derived from `stable-ref.artifact.file.alpha`:
  - domain-identifier namespace drift: 554 bytes, SHA-256
    `9a46259de5ebae2f206afdfe3d2e45056f99b6809e88c3bd43cd456422ee4dfd`;
  - scheme-identifier namespace drift: 554 bytes, SHA-256
    `4b06ff453e1d866880ec7cd1549e9769f5059ec1c05f80787cd59c72a80aeec0`;
  - material-kind identifier namespace drift: 554 bytes, SHA-256
    `ac3077ed378b5567444afd46815d9816ad924c123fdb4d749a32c375f11b618a`;
  - object-id domain-prefix drift: 547 bytes, SHA-256
    `eafb4632713b8f7217a197103f5168b68c677ee69c8b89dc63248f438b9c85f8`.
- Common Lisp result: accepts all four as valid StableRefs.
- Python result: accepts all four as valid StableRefs.
- Expected fixture result: reject each witness because domain, scheme,
  FixtureStableMaterial kind, and domain-specific object-id prefix are exact
  identifiers, not last-segment labels.
- Classification: shared StableRef exact-schema validation defect.
- May implementation continue: yes on unaffected sealed fixtures; the hostile
  acceptance path is blocked.
- Proposed disposition: successor validators must compare complete registered
  identifiers and prefixes while preserving the fixture-only scope.
- Permanent regression-vector status: all four hashes are permanent hostile
  witnesses.

## LCI0-DIV-009 — both validators collapse record-key identity to path labels

- Status: confirmed at an outer LCI record and a nested fixture record.
- Sources: frozen CD/0 Identifier equality; LCI/0 closed schemas; Errata I12
  deterministic recursive validation; Fixture Package Specification closed
  schema registry.
- Minimal witness A: `claim-id.file-alpha-neutral` with only the top-level
  `kind` record-key namespace changed, 8,418 bytes, SHA-256
  `a14796264420995cc4262eb7ad807906447e1999a4137088b2c099c85bae23a5`.
- Minimal witness B: the same ClaimId with only a nested scope-expression
  `kind` record-key namespace changed, 8,404 bytes, SHA-256
  `633a13b454961955ecf370482dd3cc83a1f693e8f5810af4bcc167e904125484`.
- Common Lisp result: accepts both ClaimIds.
- Python result: accepts both ClaimIds.
- Expected fixture result: closed schemas reject both unknown exact keys;
  preserving a one-segment path label does not preserve Identifier identity.
- Classification: shared closed-record validator defect.
- May implementation continue: yes on unaffected exact fixture keys.
- Proposed disposition: use complete CD/0 Identifier keys in closed-field
  checks at every recursive level.
- Permanent regression-vector status: both hashes are permanent hostile
  witnesses.

## LCI0-DIV-010 — both WarrantTarget validators omit schema pairing and nested closure

- Status: confirmed by three deterministic target-validation witnesses.
- Sources: LCI/0 §§10 and 15; Errata E2, E5, E7, and I12; Fixture Package
  Specification §§5 and 9; registered target-schema definitions.
- Minimal witness A: observed target with the executed target-schema reference,
  13,319 bytes, SHA-256
  `4d57565621110f35a4cd52c4f0715176fa9b2c39173536565be4530445b8b4d9`.
- Minimal witness B: executed target with the observed target-schema reference,
  15,330 bytes, SHA-256
  `b4b58ae937b09132d3f6167d81a6bc2e50161d5253b4789b347b20e1ddbd4f96`.
- Minimal witness C: `warrant-target.observed.file-alpha.exact` with one unknown
  nested selector field in `coverage-scope.expression`, 13,369 bytes, SHA-256
  `1b4b6d6cfd829d27227dd978588b238105f86223396fa45f90385337311749e8`.
- Common Lisp result: accepts all three targets.
- Python result: accepts all three targets.
- Expected fixture result: reject all three. Target-kind/schema pairing is
  exact, and nested boundary values retain their own closed schemas.
- Classification: shared WarrantTarget validation defect.
- May implementation continue: yes on unaffected registered targets; these
  acceptance paths are blocked.
- Proposed disposition: validate the exact target-schema reference selected by
  target-kind and recursively validate every typed boundary. No unpinned
  hostile failure tuple is invented by this ledger.
- Permanent regression-vector status: all three hashes are permanent hostile
  witnesses; rejection is pinned, while a future authorial fixture should pin
  exact failure documents.

## LCI0-DIV-011 — both implementations misapply fixture resource budgets

- Status: confirmed at one over-budget StableRef and one inclusive-limit
  workload.
- Sources: LCI/0 §21; Errata I12; Fixture Package Specification §10; registry
  `resource-budget.lci-first-implementation.0`; vector `LCI0-RESOURCE-01`.
- Minimal witness A: `stable-ref.artifact.file.alpha` with material exceeding
  the registered StableRef material budget but remaining inside frozen CD/0
  decoding limits, 5,533 bytes, SHA-256
  `303c5fb2c0f25b99211fdcf6b0662caa2483e121ba4d36ceadf4a4c2fdc3632d`.
- Minimal witness B: the `LCI0-RESOURCE-01` workload changed from its first
  over-limit value to the exact inclusive limit, 7,676 bytes, SHA-256
  `2e5d128bb516b99b3de598d79b598bae068a745e32237bc11391a2e46b37fd18`.
- Common Lisp result: accepts witness A and refuses witness B with
  `LCIMaxNestingExceeded`.
- Python result: accepts witness A and refuses witness B with
  `LCIMaxNestingExceeded`.
- Expected fixture result: witness A fails with
  `resource-refusal/StableReferenceMaterialBudgetExceeded/validation` at
  `material`; witness B is within budget and must not fail. No success-result
  envelope is inferred for the unvectored boundary case.
- Classification: shared LCI resource-budget enforcement defect.
- May implementation continue: yes on unaffected workloads; resource boundary
  conformance remains blocked.
- Proposed disposition: enforce actual structural work/material counts and
  inclusive maxima rather than treating each conformance workload as an
  unconditional refusal trigger.
- Permanent regression-vector status: both hashes are permanent hostile
  witnesses.

## LCI0-DIV-012 — migration validation accepts undeclared grammar/source forms

- Status: confirmed by three inert, non-evaluating migration witnesses.
- Sources: LCI/0 §23; Errata E9 and I12; Fixture Package Specification §9;
  registry `legacy-source.time-100` and the exact migration grammar reference.
- Minimal witness A: exact grammar-reference substitution, 3,263 bytes,
  SHA-256
  `c03d098eebbebd7cc015c48b46cdb433b3c8fea831e9c6cd7c03c0db8ed1095f`.
- Minimal witness B: one unknown top-level legacy-source field, 3,332 bytes,
  SHA-256
  `9bae20e44e15710309170973ff26e3458b641a9c075a32953b907793bbf77369`.
- Minimal witness C: source bytes outside the declared bounded grammar, 3,113
  bytes, SHA-256
  `8cdad61022e46357b305cdc62090784961300cdd6863d9e519094fabcb669e0c`.
- Common Lisp result: accepts A and C; rejects B with the expected
  `invalid-input/UnknownField/migration-source` failure.
- Python result: accepts A, B, and C.
- Expected fixture result: A and C fail with
  `migration-refusal/UnsupportedLegacyForm/migration-source` at their
  respective structural fields; B fails with the Common Lisp result above.
- Classification: shared migration grammar validation defect for A/C and an
  additional Python closed-record defect for B.
- May implementation continue: yes on the sealed bounded migration fixtures;
  the hostile acceptance paths are blocked. No live warrant was created.
- Proposed disposition: validate the exact grammar reference, exact closed
  source schema, and declared non-evaluating source grammar before mapping.
- Permanent regression-vector status: all three hashes are permanent hostile
  witnesses.

## LCI0-DIV-013 — Python treats an unknown fixture policy as Policy-B

- Status: confirmed by one exact finite-policy witness.
- Sources: LCI/0 §24.7; Errata E2; Fixture Package Specification §7; registry
  Policy-A and Policy-B definitions.
- Minimal witness: unknown policy identity with an exact-target relation, 460
  bytes, SHA-256
  `7597afb93cad44e3b92b0ad754520d67a49769ea6962ea806a7939ddff469938`.
- Common Lisp result: rejects with
  `invalid-input/UnsupportedFixturePolicy/admissibility` at `policy`.
- Python result: returns an accepting decision through its non-A fallback.
- Expected fixture result: the Common Lisp failure. The fixture policy set is
  finite and closed.
- Classification: Python fixture-policy dispatch defect.
- May implementation continue: yes for exact Policy-A and Policy-B inputs;
  unknown policy dispatch is blocked.
- Proposed disposition: reject every policy identity other than the two exact
  registered fixture policies.
- Permanent regression-vector status: the witness hash is permanent.

## LCI0-DIV-014 — relation-table failure paths differ between implementations

- Status: confirmed during the exhaustive 458-entry semantic table run; exact
  failure-path convergence is unresolved.
- Sources: Errata I12 failure comparison and deterministic recursive paths;
  Fixture Package Specification §§2–3; registry scope and temporal relation
  tables.
- Minimal scope class: 24 cross-calculus orientations normalize to the same
  `incompatible` relation. Common Lisp reports path `right`; Python reports
  `right/calculus`.
- Minimal temporal class: 14 orientations with the symbolic operand on the
  right normalize to the same `unknown` relation. Common Lisp reports path
  `left`; Python reports path `right`.
- Expected fixture result: the relation-table rows pin `incompatible` or
  `unknown`, but do not contain companion failure documents for every
  orientation. Existing direct vectors pin only selected orientations.
- Classification: specification/fixture underdetermination exposed by
  differential failure-path comparison; neither implementation is an oracle.
- May implementation continue: yes for the pinned relation value. Exact paths
  for the unpinned orientations are blocked pending authorial closure and must
  not be counted as converged.
- Proposed disposition: authorially pin depth-first category/code/stage/path
  documents for both orientations of each F-valued relation family, then
  classify implementation defects against those documents. The request is
  isolated in `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md`.
- Permanent regression-vector status: retain all 38 observations; add machine
  fixtures when authorial closure supplies exact paths.

## LCI0-DIV-015 — E5 expected context introduces an unbound coverage scope

- Status: confirmed fixture/specification conflict; the exact
  `LCI0-E5-COVERAGE-INSUFFICIENT` result-document path is blocked for authorial
  disposition.
- Sources: LCI/0 §9.3 (no target boundary may be inferred), §10.6; Errata
  E5; Fixture Package Specification §§2 and 7; vector
  `LCI0-E5-COVERAGE-INSUFFICIENT`.
- Input witness: 21,896 bytes, SHA-256
  `08cbf5bde9a42d9180161f90f75c8b6bd5c7d8c2e453ed9aaa31718c6d42e773`.
  Its target coverage is tenant `b`; its required candidate scope is department
  `research`; it contains no tenant `a` scope.
- Expected witness: 2,923 bytes, SHA-256
  `dcc9deda2e494a8adab5e04a39c04d61c056d5b9bcb0a390c1667c67351dc613`.
  Its failure context records `actual-coverage-scope` as tenant `a`, a datum
  absent from the operation input.
- Common Lisp baseline result: reproduces the expected document by a
  target-kind/mode-specific tenant-`a` construction not stated by the
  specification or carried by the target.
- Python baseline result: returns the same category, code, stage, and path but
  omits the expected-only context, producing SHA-256
  `86ca74bf1999bbbe934fe480d7d5d45c95f1ca4d1ee74b7e58b571ccc2f528bf`.
- Expected fixture result: the exact document and the no-inferred-boundary law
  cannot both be derived from the supplied input under pure target matching.
- Classification: fixture-package/specification ambiguity; the initial
  baseline classification as solely a Python defect is superseded for this
  vector.
- May implementation continue: yes on unaffected matcher paths. Successor
  implementations must not synthesize expected-only identity-bearing data.
- Proposed disposition: authorial closure must either bind the actual inspected
  coverage in the WarrantTarget input, normatively define a pure derivation
  that does not depend on hidden fixture state, or revise the expected context.
  See `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md`.
- Permanent regression-vector status: the existing input and expected hashes
  are permanent conflict witnesses. The vector is blocked, not passed, failed,
  skipped, or N/A.

## LCI0-DIV-016 — P029 changes an explicitly bound migration source artifact

- Status: independently confirmed fixture/specification conflict; the right
  result of `LCI0-P029` is blocked for authorial disposition.
- Sources: LCI/0 §23.3 steps 1 and 13 and §§23.5, 24.5 P029; Errata E9;
  Fixture Package Specification §9; registry fixtures
  `legacy-source.corpus-r4` and `migration-result.corpus-r4`; vector
  `LCI0-P029`.
- Minimal input witness: `LCI0-P029` input, 6,166 bytes, SHA-256
  `3dd8e067335f659062ba4d9df3945351be693f4016f27c8366c56c61561e017c`.
  Both its `left-source` and `right-source` records explicitly bind
  `source-artifact` object-id
  `object/artifact/legacy-source/v1/1`.
- Expected witness: `LCI0-P029` expected result, 54,022 bytes, SHA-256
  `de95395165f2e7e170989246caedfe0e278027bc9d90a44a785e18059cf235a7`.
  The left result preserves `.../v1/1`, while the right result's `source` and
  migration-lineage `source` are both `object/artifact/legacy-source/v1/2`.
- Registry corroboration: `legacy-source.corpus-r4` is 2,836 bytes, SHA-256
  `fae0d97d77f291a6cf5fb54be0d48422d656c976e30dcd87d05e903939669632`
  and explicitly carries `.../v1/1`; `migration-result.corpus-r4` is 26,660
  bytes, SHA-256
  `001de18804d4826f10106efd9ba0979d372dada832cda854466c2b3681062e19`
  and carries `.../v1/2` in both source positions.
- Common Lisp successor result: independently constructs the right migration
  result from the validated input and preserves `.../v1/1`, disagreeing with
  the expected right result at `outputs/right-result/source/material/object-id`.
- Python successor result: independently constructs the right migration result
  from the validated input and preserves `.../v1/1`, with the same first
  disagreement.
- Expected fixture result: the frozen expected document requires `.../v1/2`,
  but no package rule authorizes replacing the explicitly bound source
  artifact based on corpus revision, fixture name, pair position, or another
  inferred coordinate. LCI/0 §23.3 instead requires the exact source bytes to
  be bound and the receipt to link that source artifact to the new occurrence.
- Classification: fixture-package/specification ambiguity. Constructing
  `.../v1/2` would be semantic inference from package-local expectations;
  preserving `.../v1/1` fails the exact frozen expected document.
- May implementation continue: yes on all unaffected migration fixtures. The
  `LCI0-P029` right-result path is blocked and cannot be counted as pass,
  failure, skip, or N/A.
- Proposed disposition: authorial closure must either correct the
  `legacy-source.corpus-r4`/P029 input source-artifact to `.../v1/2`, revise
  the expected migration result to preserve `.../v1/1`, or publish an exact
  source-rebinding rule with its identity and loss/lineage consequences. See
  `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md`.
- Permanent regression-vector status: the two registry documents and the
  P029 input/expected hashes are permanent conflict witnesses. Both
  implementations retain a regression proving that explicit source binding
  wins over fixture-name or corpus-revision inference until authorial closure.
