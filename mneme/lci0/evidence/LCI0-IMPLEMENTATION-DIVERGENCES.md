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

- Status: correction implemented in a preliminary successor worktree after
  provenance review of the five baseline mismatches; commit-bound fresh
  verification remains pending. Four are Python representation defects. The
  coverage-context mismatch is the separate normative conflict
  `LCI0-DIV-015`.
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
- Expected fixture result: no exact LCI failure document exists for Policy-C.
  The finite, closed Policy-A/B set requires fail-closed dispatch, but the
  Common Lisp baseline tuple used an unregistered code and is not an oracle.
- Classification: Python fixture-policy dispatch defect plus fixture-package
  ambiguity for the exact failure tuple.
- May implementation continue: yes for exact Policy-A and Policy-B inputs;
  unknown policy dispatch remains authorial-return-blocked.
- Proposed disposition: reject every policy identity other than the two exact
  registered fixture policies using a non-LCI fixture-authority-gap condition
  until an exact LCI failure tuple is authorially pinned. Never mint a nearby
  `LCIFailure/0` code.
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
- Common Lisp preliminary successor observation: a non-commit-bound worktree
  snapshot constructed the right migration result from validated input and
  preserved `.../v1/1`, disagreeing with the expected right result at
  `outputs/right-result/source/material/object-id`.
- Python preliminary successor observation: a separately reasoned, non-commit-
  bound worktree snapshot preserved `.../v1/1`, with the same first
  disagreement. Committed final results in both languages remain PENDING.
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

## LCI0-DIV-017 — policy evaluation order and external-principal decision identity conflict

- Status: confirmed prose/registry conflict; combined multi-predicate policy
  paths and the untrusted-principal decision spelling are blocked.
- Sources: Fixture Package Specification §8.1; registry
  `admissibility-policy.a.0` (8,128 bytes, SHA-256
  `467561cb0c91e644761006dac047dac7efde77840d49ec12bf113704256f6373`)
  and `admissibility-policy.b.0` (8,782 bytes, SHA-256
  `0e04628c6bf3f8361ca1f8f61b7ffe9288e17e056f4fada097f8f8f2f39ecc6f`).
- Minimal input: a six-coordinate Policy-B diagnostic carrier with successful
  exact target relation, externally-attested target kind, age 169, identity-
  bearing loss, and the registered untrusted external principal: 1,686 bytes,
  SHA-256
  `a061ba268a0bf6960410f0e467fb2b548fe7aded8f29411909434171defa809c`.
- Common Lisp result: no combined evaluation surface exists; the finite
  evaluator handles only separately registered target/query cases.
- Python result: a non-commit-bound preliminary helper snapshot returned
  `reject-stale` because it evaluated freshness before loss and trust. Final
  successor verification is PENDING; this is not an oracle.
- Expected fixture result: package prose orders represented loss, trust, then
  freshness; both canonical policies order freshness, loss, then trust, while
  `direct-if-trusted-principal` does not pin which step evaluates trust. Prose
  also names `reject-untrusted-external-principal` (91 bytes, SHA-256
  `0200287fd1dcccc9ddec7ee798afdd0d092cb94f38ebc11d7e007dc5eec4bc7d`),
  while the registry defines `reject-external-principal` (81 bytes, SHA-256
  `84da031f081df165220acdbc1805377689c092a08cddc75c70e9a8336116d0d0`).
- Classification: fixture-package/specification ambiguity.
- May implementation continue: yes for single-branch exact vectors; no for
  combined stale/loss/trust precedence or the unpinned decision Identifier.
- Proposed disposition: authorially publish one exact evaluation order,
  define when conditional target-kind trust is evaluated, and select one
  decision Identifier. See
  `LCI0-AUTHORIAL-RETURN-PACKET-POLICY-EVALUATION-ORDER.md`.
- Permanent regression-vector status: the combined carrier and both decision
  Identifier documents are retained; machine vectors are required on closure.

## LCI0-DIV-018 — CorpusBasis names coherence checks without exact failure tuples

- Status: rejection obligation confirmed; both validator snapshots inspected
  during preliminary review accepted the minimized mixed-revision witness;
  exact failure result is blocked and final successor verification is PENDING.
- Sources: Fixture Package Specification §4; Errata I12/E6;
  `closed-schema.corpus-basis.0`, 2,430 bytes, SHA-256
  `189fbb4a81de03cd4836a36b826557d547a5bef081a6b550ccefc5c7f24c627a`.
- Minimal input: valid `claim-basis.alpha-r3-all-manifest3` with only its
  semantic boundary replaced by valid `semantic-boundary.manifest-alpha-4`;
  4,005 bytes, SHA-256
  `7c92ea0639c7de40dbed630587b9ecbf1ce36e374bb66db966d6536aa1c1a0be`.
- Common Lisp result: the preliminary, non-commit-bound snapshot exposed an
  acceptance path; it performed recursive shape checks but not
  `revision-belongs-to-corpus` or `slice-boundary-coherent`.
- Python result: the snapshot at the same review point accepted an executed
  direct validation for the same reason. No final successor result is claimed.
- Expected fixture result: fail closed because mixed immutable revision
  material is expressly refused and `slice-boundary-coherent` is a declared
  final cross-field check. The package does not pin category/code/stage/path or
  context for this case or for logical-corpus/revision mismatch.
- Classification: shared implementation defect for accepting the witness,
  plus specification/fixture underdetermination for the exact failure tuple.
- May implementation continue: yes on valid registered bases. A deterministic
  rejection may be implemented, but no invented tuple may be counted as exact
  convergence.
- Proposed disposition: add executable cross-check definitions and exact
  single-fault failure documents. See
  `LCI0-AUTHORIAL-RETURN-PACKET-CORPUS-BASIS-COHERENCE.md`.
- Permanent regression-vector status: required for r3/r4 boundary coherence
  and corpus/revision mismatch in both orientations.

## LCI0-DIV-019 — operation payloads are declared closed without per-operation failure documents

- Status: preliminary implementation defect confirmed; binary fail closure is
  repairable, while complete novel tuples are authorially blocked.
- Sources: LCI/0 §§24–25; Errata I12/E6; all 215 sealed vectors. Mechanical
  census yields 52 distinct operation payload families.
- Minimal inputs: empty `migrate-v1` payload, 430 bytes, SHA-256
  `e0be41da4dc38484102baa80a2c9478c2971999002913f4353e4cd54e55729ec`;
  and valid `validate-profile-location` payload plus one unknown field, 588
  bytes, SHA-256
  `9b324a9fa3f905c6247665350ef565dde2535666489a9ad43090e9f461d4f091`.
- Common Lisp result: full 104-witness execution is pending; several dispatch
  branches read named fields without an explicit closed payload schema.
- Python result: the snapshot inspected during preliminary review ignored
  unknown fields on many branches and could expose host `KeyError` for missing
  fields. A working-tree correction proposed a 52-operation schema census;
  committed successor verification remains PENDING.
- Expected fixture result: every unknown/missing mutation must return a typed
  fail-closed LCI result. `UnknownField`/`MissingRequiredField` are authorized
  codes, but category, stage, first-field path, and context are not machine-
  pinned for these 104 novel documents.
- Classification: Python implementation/harness defect where the typed
  boundary is absent; fixture-package underdetermination for exact tuple
  comparison across both languages.
- May implementation continue: yes for well-formed official vectors and for
  typed binary rejection. The exact novel result documents remain blocked.
- Proposed disposition: publish all 52 closed payload schemas and exact
  missing/unknown vectors. See
  `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md`.
- Permanent regression-vector status: the deterministic 104-document family
  is retained; official machine vectors are required on closure.

## LCI0-DIV-020 — MigrationResult classification is not coupled to result content

- Status: confirmed schema gap; no inverse classification matrix is inferred.
- Sources: LCI/0 §§23.2–23.4; Errata E9; Fixture Package §9;
  `migration.classification-map.0`, SHA-256
  `685f33dfa7ec653aa9ee2ec924a91a4104f2bbcd9d99898ac97215f4ce4ab693`;
  vector `LCI0-N028`.
- Minimal input: `migration-result.inert-predecessor` with only classification
  changed from `privileged-runtime-relation-outside-claim-id` to registered
  `exact-after-explicit-tagging`; 31,107 bytes, SHA-256
  `565494e413cb849836d922b3ae6455c771f2f7f2c0a31ac4b30d9991ccee3726`.
- Common Lisp result: the preliminary, non-commit-bound validator snapshot
  accepted because it checked Identifier shape and selected loss-presence
  implications, not classification/content coherence.
- Python result: the snapshot's `validate-migration-result` vector operation
  unconditionally returned the N028 `RepresentedLossRequired` result, even
  though this witness retained represented loss; it was not generic
  validation. Final successor results remain PENDING.
- Expected fixture result: classification meanings imply a cross-field
  constraint, but no closed schema, check order, or exact
  `InvalidMigrationResult` tuple is frozen for this mutation. N028 pins only
  the lossy-without-loss direction.
- Classification: specification/fixture schema gap plus implementation defects
  in both validators/dispatch paths.
- May implementation continue: yes for the five valid frozen result documents
  and exact N028. The mutated classification path is blocked.
- Proposed disposition: authorially define a total seven-class cross-field
  rule and exact failure documents without deriving an inverse matrix from
  examples. See
  `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md`.
- Permanent regression-vector status: mutation retained; machine vector
  required on closure.

## LCI0-DIV-021 — kind-specific target coherence algorithm references are opaque

- Status: confirmed executable-definition gap; obvious and vectored rules
  remain enforceable, unvectored mismatch semantics are blocked.
- Sources: LCI/0 §§10 and 18.7; Fixture Package §7.1 step 6 and eleven
  `target-schema-definition.*.0` records.
- Minimal input: valid `warrant-target.derived.one-equals-one` with only its
  premise ClaimId replaced by valid `claim-id.file-alpha-neutral`; 20,341
  bytes, SHA-256
  `d0baf4a9470db970e014b707509d79e1c25581b320c100fda1ee66a5f6218b0b`.
- Common Lisp result: exhaustive kind-coherence hostile execution is pending;
  its schema validator primarily enforces field presence/type and selected
  corpus/translation paths.
- Python result: a non-commit-bound preliminary review snapshot contained no
  coherence rule for observed, tested, derived, externally-attested, replayed,
  reported, or inherited and no path producing `PremiseMismatch`; other kinds
  were partial. Final successor verification is PENDING.
- Expected fixture result: each schema names
  `target-boundary-algorithm/<kind>/0`, field/types, and failure vocabulary,
  but no algorithm definition identifies comparison operands or path rules.
  Only one positive and first-field-missing negative exist per kind.
- Classification: Python implementation defect for omitted independently
  pinned checks; specification/fixture ambiguity for unvectored procedure,
  model, artifact, corpus, premise, translation, and policy mismatch semantics.
- May implementation continue: yes for official positive/missing vectors and
  separately pinned shape/coordinate/scope rules. Novel coherence paths are
  blocked.
- Proposed disposition: publish executable definitions and single-defect
  vectors for all eleven algorithms. See
  `LCI0-AUTHORIAL-RETURN-PACKET-TARGET-BOUNDARY-COHERENCE.md`.
- Permanent regression-vector status: the derived premise mutation is
  retained; full kind-by-rule coverage is required on closure.

## LCI0-DIV-022 — Python vector dispatch contains fixture-result shortcuts

- Status: confirmed by preliminary successor review; repairs are pending and
  no affected result may be promoted on the strength of the old green vector
  count.
- Sources: the Python `lci0/vector.py` operation dispatcher; LCI/0 pure
  operation requirements; official vectors `P010`, `P021`–`P023`, `N028`,
  `N031`, E4, E8, placement/metadata/I12 fixtures, and post-convergence
  semantic mutations.
- Minimal observations:
  - proposition/location dispatch returned success by proposition form without
    validating the supplied location; the pinned N014-derived mutation is
    9,657 bytes, SHA-256
    `b9c3eefc3aa1d492d22023f9ee20d0cb1aeb15df4bb31251fe5755237d5b1d25`;
  - policy and freshness operations returned registered expected decision
    documents rather than evaluating the input; a Policy-B meta-testimony
    mutation is 39,644 bytes, SHA-256
    `cd9ba9b80741be7496c88c468983490e47234ad1ebd20c140a6bb4d7bf36d331`;
  - occurrence validation checked only one unknown label and accepted a Unit
    claimant; witness 20,416 bytes, SHA-256
    `265d98b41f1e1d0c1d85529a2ed5f3926c3a61d0c1250edbbd1d1451b42ecb99`;
  - normalization branches copied/compared declared normalized values without
    executing the selected frozen normalizer semantics;
  - `compare-corpus-completion-targets` fabricated
    `CorpusCompletionInsufficient` when matching succeeded;
  - `validate-migration-result` and `differential-project` returned the one
    expected negative result unconditionally; and
  - the revival branch injected the beta occurrence addressed separately by
    DIV-023.
- Two anti-shortcut twins now reverse input relations whose output fields are
  already normatively defined:
  - equal normalization operands, 4,220 bytes, SHA-256
    `007ecfb3f0ae2af620cedc7a5e31247ea2d9fbb7afcfb1639d3aa0ff5814675f`,
    require `claim-id-merge-permitted=true`;
  - independently carried equal ClaimId envelopes, 17,648 bytes, SHA-256
    `d48731943d5a85f4677949cf0835116a0108e0ac6fb5a059dcadaaad8cdfe2ca`,
    require `semantic-claim-id-equal=true`.
- A positive N028 result and equal-output N031 evidence were considered as
  shortcut mutations, then excluded: the frozen package defines neither a
  positive N028 output schema nor the equal-output N031 result/failure
  vocabulary. Treating either as expected would create an implementation-local
  oracle. Those inverses remain authorial-return-bound under DIV-020 and the
  operation-semantics boundary.
- Witness standing: the five exact property hashes above are coordinator-
  generated from frozen fixture inputs by the deterministic post-convergence
  harness and frozen CD/0 encoding. They are mutation identities, not package
  expected results; independent Common Lisp reconstruction remains PENDING.
- Common Lisp result: not an oracle; corresponding operations require their
  own semantic-dispatch review and differential evidence.
- Python result: official examples in the reviewed snapshot could match
  expected documents despite not being input-sensitive. Working-tree
  corrections and new metamorphic tests were observed, but committed successor
  verification and a full rerun remain PENDING.
- Expected fixture result: operations derive results from validated input and
  frozen rules, never vector ID, expected document, fixture name, or a
  one-branch fallback. Policy-B meta-policy testimony is limited testimony,
  never direct support; the exact registry rule is independently pinned.
- Classification: Python implementation defect. Where a mutation reaches
  DIV-017–021 or DIV-023, only the underlying authorial path is blocked; the
  shortcut itself remains a defect to remove.
- May implementation continue: yes after semantic corrections and fresh exact,
  differential, mutation, and hostile reruns. A prior 215-vector green count
  is insufficient evidence for these paths.
- Proposed disposition: replace every shortcut with validation and semantic
  construction, retain expected-result decoding solely in the test-oracle
  layer, and run the 329-case default deterministic post-convergence generator
  after exact unaffected convergence. The final executed count remains
  PENDING.
- Permanent regression-vector status: the five exact property hashes above,
  all official source vectors, payload-closure family, and input mutation
  pairs are permanent.

## LCI0-DIV-023 — P024 revival injects an unbound occurrence

- Status: confirmed fixture/specification conflict; `LCI0-P024` is blocked.
- Sources: LCI/0 §23.7, §24.5 P024, and §28.6; Errata I12(e); vector
  `LCI0-P024`; registry `claim-occurrence.beta-metadata-different`.
- Minimal input: P024 input, 29,375 bytes, SHA-256
  `c730f6e1993b6bfa77191302aae856dc92b7c973622344a7d484ac88801bb0ff`;
  its payload contains only `predecessor` and `requested-claim`.
- Common Lisp result: the initial path selects/reconstructs the expected beta
  occurrence rather than deriving all fields from the two supplied inputs;
  successor removal is required.
- Python result: the reviewed initial path read
  `claim-occurrence.beta-metadata-different` from the registry; a working-tree
  reconstruction observed during review still selected values not supplied by
  the operation and was not normative closure. Final successor verification is
  PENDING.
- Expected fixture result: 30,591 bytes, SHA-256
  `13c281e7654162ba566e8af3883ef022fb360f1c91bb8753147668fbb9389963`;
  it embeds the exact beta occurrence, 21,360 bytes, SHA-256
  `b9a1877ce6cebe014aeeefb40936c15d5d1f02da6bf93e58e428c7a70e1f11a7`.
  Claimant, assertion time, provenance, lineage, presentation, and metadata
  differ from the predecessor but are absent from the input. Its lineage is
  `independent-reassertion`, while revival prose names `freeze-revival`.
- Classification: fixture-package/specification ambiguity plus implementation
  expected-result/registry shortcut.
- May implementation continue: yes on unaffected operations. P024 is the
  fourth exact blocked vector and cannot be counted as pass, failure, skip, or
  N/A; unaffected vector ceiling is 211/215.
- Proposed disposition: pin a pure field-by-field revival transform, bind all
  new occurrence values in the input, or revise the expected result to an
  input-derived defensive-copy form. See
  `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md`.
- Permanent regression-vector status: input, expected result, alpha
  predecessor, requested ClaimId, and beta occurrence hashes are permanent
  conflict witnesses.

## LCI0-DIV-024 — seed implementations exposed unregistered LCI failure codes

- Status: RESOLVED as an implementation-boundary defect in both successors;
  authorial questions remain owned by the existing ten narrow packets.
- Sources: Errata I12 failure comparison and closed schemas; the exact 84
  registry definitions whose class is `lci-failure-code-identifier`; all 215
  official vector inputs and expected documents.
- Minimal census: static seed-source review found 75 literal Common Lisp LCI
  failure construction sites using 28 names absent from both registry and
  normative prose, and 145 Python helper/constructor sites using 32 absent
  names. The official execution path happened not to expose them: each
  implementation produced 101 failure observations using the same 53
  registered codes across 215 vectors.
- Common Lisp result: reachable hostile/validator/internal paths could mint
  implementation-local codes, including generic invalid-value and fixture
  policy/operation diagnostics.
- Python result: the same class included record/scalar/type diagnostics,
  fixture/package mismatches, unsupported host/fixture surfaces, and generic
  invalid-value umbrellas.
- Expected fixture result: `LCIFailure/0` codes are members of the exact
  84-code frozen registry. A host integrity defect, protocol refusal, or
  authorial gap is not converted into a nearby normative failure.
- Classification: Common Lisp defect and Python defect. This census does not
  create an eleventh specification ambiguity.
- May implementation continue: yes after constructor/dynamic-funnel guards and
  regression tests. Unpinned semantic tuples remain blocked under DIV-018–021,
  DIV-013/DIV-017, and the existing migration packets.
- Proposed disposition: both successors enforce exact registry membership;
  frozen package contradictions use host internal-integrity conditions;
  unpinned semantics use non-LCI fixture-authority gaps; determinate stable
  reference type refusal uses registered `InvalidStableReference`. The
  operation-payload packet retains the broader recursive shape inventory.
- Permanent regression-vector status: exact 84-code equality, static literal
  census, dynamic unauthorized-construction refusal, and all-215 runtime code
  census are permanent language gates.
