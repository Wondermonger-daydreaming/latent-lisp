# LCI/0 Implementation Ledger

Date: 2026-07-14

Status: corrected unaffected successor surfaces CONVERGED; ten authorial
closures BLOCKED

This ledger is a requirements crosswalk, not a PASS receipt. It binds each
authorized surface to its normative source, fixture witnesses, implementation
owners, and the evidence still required at the integration-successor boundary.
Historical seed observations remain available in the two immutable seed
receipts. Current results below are bound to corrected exact differential r4
and post-convergence final6 at integration commit
`e6983952ea726366b69435b29eeb37eb76f8504d`, tree
`daaef9bad97eced6c242fc8052cbedc8920d355a`.

Audit history is retained: r3/final5 exposed six Python boundary defect
families—occurrence-versus-ClaimId projection and outer-schema closure;
tagged-empty profile-location admission, with N009's existing diagnostic preserved; target-match
code/order/coordinate checks; nonmonotonicity-before-coverage ordering; mutable
`production`/`model-current` aliases; and bilateral ClaimId operand validation.
Successor `db627cb6...` corrected them; r4 added eight
hostile regressions, the Python suite reached 100/100, differential units
reached 53/53, and final6 has zero unaffected failure. The older r3/final5
numbers remain historical evidence only.

## Authority and boundary

The authority order applied is frozen CD/0 specification and errata; the LCI/0
candidate; LCI/0 Errata 0.1; the fixture-package specification; the machine
registry and vectors; the post-review ruling; and the Fable PASS receipt for
authorization and disclosed notes.

The implementation boundary is fixture-only. It excludes production warrant
minting or WarrantId, production standing or admissibility, capabilities,
authority, cryptographic selection, production module/procedure identity,
custody or verified lineage, live v1 migration, and any CD/0 change.

Status vocabulary in result columns is deliberately bounded:

- `CONVERGED-UNAFFECTED` means both implementations and all exercised host
  profiles agree on the normatively determinate portion; it is not an overall
  PASS.
- `BLOCKED` means a named authorial-return packet prevents a determinate final
  assertion for the affected path. It is not a pass, failure, skip, or N/A.
- `PASS-PROTECTED` is used only for the independently rerun CD/0 or Mneme/v1
  nonregression floors.
- `PENDING` is retained only for an external independent reviewer disposition
  not yet available when this ledger was refreshed.

## Core implementation crosswalk

| ID | Authorized obligation | Normative anchors | Registry/vector anchors | Common Lisp owner/tests | Python owner/tests | Differential evidence | Successor/final result | Residual boundary |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | Immutable fixture representations and immutable views for every required LCI value | LCI §§5–7, 18, 20, 23; Errata E4, E6, I12 | Closed-schema definitions; N001–N010; E6; I12 | `common-lisp/values.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/tests/test_surface.py` | Closed-value and mutation requests to `differential/run_differential.py` | CONVERGED-UNAFFECTED | Fixture schemas only; no production identity objects |
| A2 | Closed schemas, unknown-field rejection, exact nested versions, deterministic recursive validation | LCI §18; Errata E4, E6, I12 | Closed-schema field orders; E6; I12; hostile nested-key witnesses | `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_red_boundaries.py`, `python/tests/test_audit_regressions.py` | `LCI0-DIV-008`–`010`, `019`; successor hostile matrix | BLOCKED | Binary fail closure is required; exact tuples for 104 novel operation-payload mutations await closure |
| A3 | Typed `LCIFailure/0` category, code, stage, and structural path | LCI §18; Errata E6, I12 | Negative vectors; resource vectors; relation failures | `common-lisp/values.lisp`, `common-lisp/validation.lisp`, `common-lisp/operations.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/lci0/runner.py` | Exact failure tuple comparison in `differential/protocol.py` | BLOCKED | Thirty-eight relation paths plus novel CorpusBasis, payload, migration-coupling, and target-coherence tuples await their named packets |
| B1 | Pure, total fixture JSON adapter covering every encountered package form | CD/0 §§8, 15, 27; LCI Errata E1; Fixture §§0, 13 | 675 definitions; 215 inputs; 215 expected results; E1 nested documents | `common-lisp/json.lisp`, `common-lisp/fixture-adapter.lisp`, `common-lisp/registry.lisp`, `common-lisp/tests.lisp` | `python/lci0/adapter.py`, `python/lci0/package.py`, `python/tests/test_adapter.py` | 1,593 canonical roundtrips plus hostile adapter witnesses | CONVERGED-UNAFFECTED | Canonical CD/0 octets, not either JSON surface, remain authoritative |
| B2 | Redundant-field consistency, boolean/integer distinction, exact rationals, segmentation/case, no Unicode normalization, unknown-shape fail-closed | CD/0 datum behavior; Errata E1 | Adapter schema census; rational and identifier fixtures | `common-lisp/fixture-adapter.lisp`, `common-lisp/tests.lisp` | `python/lci0/adapter.py`, `python/tests/test_adapter.py` | `LCI0-DIV-002`; successor adapter census | CONVERGED-UNAFFECTED | No semantic inference, lookup, or CD/0 codec broadening |
| C1 | Frozen fixture Mneme proposition grammar and deterministic normalizer only | LCI §7; Errata E3–E4 | Proposition grammar/forms; P001–P012; placement vectors | `common-lisp/operations.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_vectors.py` | Exact vector result comparison | CONVERGED-UNAFFECTED | No complete Mneme logic |
| C2 | Subject-versus-locator placement, quantified domains/horizons, proposition/location consistency, exact profile identities | LCI §7; Errata E3–E4 | Placement family; P001–P012; negative placement vectors | `common-lisp/validation.lisp`, `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Placement and changed-coordinate requests | CONVERGED-UNAFFECTED | No optional identity coordinate may be inferred |
| C3 | Represented loss when normalization discards a declared distinction | LCI §§7, 23; Errata E3, E9 | LOSS family; migration loss accounts | `common-lisp/operations.lisp`, `common-lisp/migration.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Exact represented-loss document comparison | CONVERGED-UNAFFECTED | Only closed fixture account schemas are authorized |
| D1 | Primary and bridge-less secondary scope calculi, normalization, and relation vocabulary | LCI §§11–12; Errata E4–E5 | 169 scope relation documents; scope vectors | `common-lisp/calculi.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Full relation-table execution; `LCI0-DIV-004` | BLOCKED | N012 universal/symbolic matcher composition and companion failure paths await closure |
| D2 | Temporal model and relation table without converting containment into direct target support | LCI §13; Errata E1, E2, E5 | 289 temporal relation documents; temporal vectors | `common-lisp/calculi.lisp`, `common-lisp/matching.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Full relation-table execution; `LCI0-DIV-001`, `005`, `014` | BLOCKED | Exact relation values are machine-pinned; 14 companion paths await closure |
| D3 | Dataset-slice, semantic-boundary, corpus-basis, and interpretation-frame validation/calculi | LCI §§14–15; Errata E4–E6 | Slice, boundary, corpus, and frame definitions/vectors | `common-lisp/calculi.lisp`, `common-lisp/validation.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Fixture vectors; r3/r4 mixed-boundary witness; `LCI0-DIV-018` | BLOCKED | Mixed revisions must reject; exact CorpusBasis coherence tuple awaits closure |
| E1 | Fourteen exact fixture StableRef schemes and only registry-declared bridges | LCI §6; Errata E7 | StableRef definitions; E7 family | `common-lisp/validation.lisp`, `common-lisp/registry.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | `LCI0-DIV-003`, `008`; successor hostile matrix | CONVERGED-UNAFFECTED | Not universal production identity; bridges do not alter envelope equality |
| E2 | Mutable aliases, wrong domains/schemes/prefixes, and over-budget material fail closed | LCI §6; Errata E6–E7; Fixture §10 | Mutable-alias and resource witnesses | `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py`, `python/tests/test_audit_regressions.py` | Exact hostile witnesses and resource requests | BLOCKED | Binary refusal converges; exact alias/resource/nested-selector coordinates await existing packets |
| F1 | Pure ClaimId projection from normalized proposition and validated location into exact closed envelope | LCI §§7, 20; Errata E1, E3, E8 | P001–P012; N015–N016; METADATA family | `common-lisp/operations.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/lci0/runner.py`, `python/tests/test_surface.py`, `python/tests/test_audit_regressions.py` | Exact envelope and canonical-octet comparison | CONVERGED-UNAFFECTED | ClaimId is the envelope, never a digest |
| F2 | Exact neutral/base values, every identity coordinate, recomputation, and ambient-state independence | LCI §20; Errata E1, E8 | Neutral/base vectors; digest-only negatives; metadata vectors | `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp`, `common-lisp/run-perturbation.lisp` | `python/lci0/core.py`, `python/tests/test_perturbations.py`, `python/tests/test_red_boundaries.py` | Mutation, independent-allocation, and host perturbation phases | CONVERGED-UNAFFECTED | No filesystem, network, policy, standing, registry, model, procedure, or wall-clock action |
| G1 | Eleven exact WarrantTarget schemas, schema pairing, nested closure, and inert validation | LCI §9; Errata E4–E6, I12 | Target schema definitions; TARGET family; P013–P021 | `common-lisp/validation.lisp`, `common-lisp/matching.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | `LCI0-DIV-010`, `021`; target hostile witnesses | BLOCKED | Shape/vector rules remain enforceable; unvectored kind-specific coherence algorithms await closure |
| G2 | Pure target matching with only `exact-target` and `supports-by-scope-narrowing` successes and exact hard failures | LCI §10; Errata E2, E5–E6, I12 | Match vectors; N012; E5 coverage vector | `common-lisp/matching.lisp`, `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py`, `python/tests/test_vectors.py`, `python/tests/test_audit_regressions.py` | Exact relation/failure comparison | BLOCKED | N012 and E5 coverage context have separate authorial-return packets |
| G3 | Every F-valued match is hard-inadmissible before policy consultation | LCI §§10, 17; Errata E2 | N vectors; policy-floor witnesses | `common-lisp/matching.lisp`, `common-lisp/policy.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Relation-undetermined hostile and policy-call boundary | CONVERGED-UNAFFECTED | Policy may reject success but never promote failure |
| H1 | Exact finite fixture Policy-A and Policy-B decision records | LCI §17; Errata E2, E5 | Policy definitions; P022–P023; E2 | `common-lisp/policy.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Policy vector execution; `LCI0-DIV-013`, `017`, `022` | BLOCKED | Single pinned branches remain executable; combined order and external-principal decision identity await closure |
| H2 | Fixture freshness, represented loss, inherited testimony, external attestation, and narrowing permission | LCI §17; Errata E2, E5 | Policy A/B records and associated vectors | `common-lisp/policy.lisp`, `common-lisp/operations.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Exact decision-record and meta-testimony mutation comparison | BLOCKED | Policy-B meta-testimony is limited; stale/loss/trust precedence is not pinned consistently |
| I1 | Non-evaluating bounded v1 fixture grammar and exact frozen mappings | LCI §23; Errata E9, I12(e) | Migration definitions; P024–P030; E9 | `common-lisp/migration.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_vectors.py` | Migration vectors and hostile grammar/source requests; `LCI0-DIV-012`, `016`, `023` | BLOCKED | P024 revival transform and P029 source identity await closure; no current lookup or legacy code load |
| I2 | Exact/tagged/new-identity/lossy/rejected/deferred/privileged-runtime classifications and closed loss accounts | LCI §23; Errata E9 | E9 and LOSS families | `common-lisp/migration.lisp`, `common-lisp/values.lisp` | `python/lci0/core.py`, `python/lci0/model.py` | Exact migration/loss result comparison; `LCI0-DIV-020` | BLOCKED | N028 remains exact; total classification/result coupling is not authorially defined |
| I3 | Zero live warrants and refusal of live-warrant restoration | LCI §23; Errata E9, I12(e) | Migration inertness vectors; privileged-restoration negative | `common-lisp/migration.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Inert/live result and typed failure comparison | CONVERGED-UNAFFECTED | `PrivilegedRestorationAttempt` remains an LCI failure code |
| J1 | Exact resource budgets, structural counters, and operation jurisdictions | LCI §18; Errata E6, I12; Fixture §10 | N032; RESOURCE-01–13 | `common-lisp/validation.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Resource vectors and limit/over-limit hostile requests; `LCI0-DIV-011` | BLOCKED | Official vectors converge; 13 at-limit result coordinates and hostile exact boundaries remain unpinned |
| J2 | Deterministic closed-record order and depth-first recursive validation | LCI §18; Errata E6, I12 | Closed schema orders; resource/failure vectors | `common-lisp/validation.lisp`, `common-lisp/fixture-adapter.lisp` | `python/lci0/core.py`, `python/lci0/adapter.py` | Exact category/code/stage/path comparison | BLOCKED | Machine-pinned orders remain enforceable; 38 relation paths and 104 novel operation-payload tuples remain authorially blocked |
| K1 | Nonidentity metadata wrapper and identity neutrality | LCI §20; Errata E3, E8 | METADATA family; P/N mutation vectors | `common-lisp/values.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/tests/test_perturbations.py` | Metadata mutation and envelope-byte comparison | CONVERGED-UNAFFECTED | Claimant, assertion time, provenance, lineage, presentation, and authorized metadata are nonidentity |
| K2 | Proposition or identity-locator mutation changes ClaimId; source mutation after construction cannot | LCI §20; Errata E3, E8 | Changed-coordinate and mutation witnesses | `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py`, `python/tests/test_audit_regressions.py` | Property/mutation phase | CONVERGED-UNAFFECTED | Host pointer/package/object identity is forbidden |

## Corpus, vectors, independence, and evidence crosswalk

| ID | Obligation | Evidence basis already retained | Required successor/final evidence | Result |
| --- | --- | --- | --- | --- |
| CENSUS-1 | Discover and classify 675 registry definitions, 215 vector inputs, and 215 vector expected results | Preflight receipt; immutable seed receipts; baseline differential receipt | r4 mechanically derived census and raw request manifest | CONVERGED-UNAFFECTED |
| CENSUS-2 | Verify 1,105 official embedded canonical documents separately from 458 relation plus 30 nested E1 supplementary documents | Baseline reports 1,593/1,593 roundtrips in both seeds | r4 independently reproduced 1,105 + 488 in each implementation; magic census found 1,133 registry + 460 vector values | CONVERGED-UNAFFECTED |
| VECTOR-1 | Execute 215 unique shared vectors with P001–P030 and N001–N032 complete and no local expected results | Both seed receipts; baseline request census | r4: 211 exact, four authorially blocked, zero unaffected mismatch | BLOCKED |
| VECTOR-2 | Preserve minimal witnesses for all disagreements and never select an implementation as oracle | `LCI0-IMPLEMENTATION-DIVERGENCES.md` and raw evidence | Every observed mismatch is ledgered; 41 cross differences are confined to 38 blocked paths and three blocked hostile results | CONVERGED-UNAFFECTED / BLOCKED |
| RED-1 | Preserve fifteen named pre-seed red tests before green implementation | Common Lisp and Python red transcripts and seed receipts; initial failures are dominated by missing modules/undefined entry points rather than fifteen reached semantic refusals | Immutable red chronology retained; successor hostile/unit suites provide reached-boundary evidence | CONVERGED-UNAFFECTED / BLOCKED |
| SEED-CL | Independently seeded Common Lisp implementation under procedural isolation | Commit `b3d28bc49c3b015096cb04c6ad08c19829f511a9`, tree `d48c39f933cde591f3303fcd3c9f42a0dac1a869`; inspected-file inventory | Successor `2513c354721bac6120b8c0a5eef1ed13252cf75b`, tree `9ce6786ee374f3dafe859c6ea5977b27e6c6f718`; seed is an ancestor | CONVERGED-UNAFFECTED |
| SEED-PY | Independently seeded Python implementation under procedural isolation | Commit `4ec2e519d05aeacd2412cb8aedc5f76bde702571`, tree `9f7915b460f449976a5d7fa856861ad5ce1d36ca`; seed receipt | Corrected successor `db627cb6ca23abc0626aebc6f9982ab9b4406dbf`, tree `74c6a7e5c144d3286b83a933b27cff3d5865921d`; seed is an ancestor | CONVERGED-UNAFFECTED |
| DIFF-1 | Integrate both seeds unchanged, classify disagreements, then correct independently | Baseline integration `71f7cfc5ebe392d59d820203dad11cc2e86a0542`; evidence commit `80f1202cc6d176d891179ca408d41136c9a28a97`; 2,281 requests per implementation | r4 at `e6983952`: 2,295 requests/implementation, 4,590 responses, zero unaffected mismatch | CONVERGED-UNAFFECTED / BLOCKED |
| PERTURB-1 | Run language-specific host perturbations plus shared mutation/ambient-state checks | Language seed observations only | final6: six adapter profiles, six CL native, four Python native, 24 processes; zero nonblocked failures | CONVERGED-UNAFFECTED / BLOCKED |
| PROPERTY-1 | Add deterministic randomized/property generation only after exact non-blocked fixture convergence | Python seed reports 256 cases at seed `0x4C434930` | final6: 329 deterministic cases, seed `0x4C434930`, 1,974 adapter requests; 104 failure-coordinate and 14 result-coordinate cases blocked | CONVERGED-UNAFFECTED / BLOCKED |
| NONREG-1 | Preserve frozen CD/0 source, artifacts, canonical octets, and suites | Preflight and seed receipts | Phase 0 PASS; CL 2,633 assertions/3 N/A; Python 167/167; CD/0 differential 467/codec, zero issues; protected objects unchanged | PASS-PROTECTED |
| NONREG-2 | Preserve existing v1 and production Mneme behavior; introduce no live authority/warrant object | Preflight and seed receipts | `mneme/verify-all.sh` 6/6; protected production objects unchanged; no live system introduced | PASS-PROTECTED |
| EVIDENCE-1 | Produce checksummed reproducible evidence archive | Common Lisp seed archive only | Commit `37cdf0a...`; 180 members; 9,573,988 bytes; SHA-256 `afad708a...`; deterministic rebuild and extracted-manifest verification | COMPLETE-ARCHIVED |
| CLEANUP-1 | Commit raw transcripts and archive before deleting safe loose detritus | Baseline raw files are retained in Git history | Commit `e21ef1a...`; 63 recoverable loose files / 232,093,546 bytes removed after archive commit; compact summaries/manifests retained | COMPLETE-CLEAN |
| PUBLISH-1 | Push successor branches non-force and verify remote read-back without merging main | `LCI0-PUBLICATION-READBACK-RECEIPT.md` | Atomic push created all three refs; exact `ls-remote` and fetched-ref equality; remote archive blob verified; main unchanged | COMPLETE-PUBLISHED |
| AUDIT-1 | Fresh independent implementation audit after convergence and evidence completion | `LCI0-CORRECTION-VERIFICATION-AUDIT.md` records a separately tasked scope-limited correction audit; no external reviewer PASS exists | All six prior defect families closed; eight cross-language hostile witnesses exact; overall conformance cannot close before authorial returns | PASS-CORRECTION-SCOPE / BLOCKED-OVERALL |

## Authorial-return gates

| Packet | Affected obligation | Exact blocked surface | Unaffected work that may continue | Result |
| --- | --- | --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | D1, G2, VECTOR-1 | `LCI0-N012` universal/symbolic direct matcher result and ordering | Other unaffected relation entries; 211/215 vectors are unaffected across all packets | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | A3, D1, D2, J2 | Thirty-eight unpinned companion failure paths | All 458 machine-pinned relation values | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | G2, VECTOR-1 | Expected-only `actual-coverage-scope` context in `LCI0-E5-COVERAGE-INSUFFICIENT` | Failure category/code/stage/path and all input-derived context | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md` | I1, VECTOR-1 | P029 right-result and lineage source artifact change from input `.../v1/1` to expected `.../v1/2` | Other migration fixtures, mapped ClaimIds, inertness, and live-restoration refusal | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-POLICY-EVALUATION-ORDER.md` | H1, H2 | Combined stale/loss/trust precedence and external-principal decision Identifier | Single-branch pinned policy vectors | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-CORPUS-BASIS-COHERENCE.md` | D3, A3 | Exact rejection tuple for mixed revision/slice/boundary and corpus/revision checks | Valid registered CorpusBasis fixtures; binary fail closure | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md` | A2, A3, J2 | Complete tuples for 104 novel missing/unknown payload mutations across 52 operations | Well-formed official payloads; typed binary rejection | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md` | I2, A3 | Classification/content coupling for a mutated inert predecessor result | Five valid result documents and exact N028 | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-TARGET-BOUNDARY-COHERENCE.md` | G1, G2 | Unvectored step-6 kind-specific coherence comparisons and failure paths | Official positives/first-field-missing negatives; pinned shape/scope rules | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md` | I1, K1, VECTOR-1 | P024 expected beta occurrence fields absent from predecessor/requested-claim input | Input-derived inert occurrence behavior and other migration vectors | BLOCKED |

## Final fill-in register

| Required report item | Value/status |
| --- | --- |
| Common Lisp successor commit/tree | `2513c354721bac6120b8c0a5eef1ed13252cf75b` / `9ce6786ee374f3dafe859c6ea5977b27e6c6f718` |
| Python successor commit/tree | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` / `74c6a7e5c144d3286b83a933b27cff3d5865921d` |
| Integration code commit/tree tested | `e6983952ea726366b69435b29eeb37eb76f8504d` / `daaef9bad97eced6c242fc8052cbedc8920d355a` |
| Current raw exact/post evidence commit/tree | `7ff074fdc234d826a113b0beb5e36b490d94b579` / `3b6834114f8c1df4f8810b4a56f66f0bf66de8e2` |
| Superseded raw r3/final5 commit/tree | `041d53740165a122e27b08bf2cb097f0bd391161` / `ba00e2837cad7f107d846377bfbe33601802665f` |
| Raw nonregression evidence commit/tree | `e552346123a35225023f5b33d8f288c7064e11da` / `62c405b0358a949c5590dbcc55b50c52a515ec8c` |
| Exact changed-file inventory | `LCI0-CHANGED-FILES.txt`: 123 final-tip paths versus preimplementation commit `26ac543856e30c340cc2dd4359802442636f4b94`; 122 generated by Git through `a7811db...` plus the inventory itself |
| Successor runtime versions | SBCL 2.4.6; CPython 3.11.14; Linux 6.18.33.2 WSL2 |
| Official/supplementary corpus counts | 1,105 official + 488 supplementary = 1,593 per implementation; all reproduced |
| Vector and differential request counts | 2,295 requests/implementation; 4,590 responses; vectors 211/215 exact + 4 BLOCKED; relations 420/458 + 38 paths BLOCKED; hostile 21/29 + 8 BLOCKED |
| Property/mutation counts and seeds | 329 cases; 1,974 adapter requests; seed `0x4C434930`; 104 failure-coordinate + 14 result-coordinate cases BLOCKED; zero nonblocked failures |
| Divergence ledger closure | All implementation/harness defects on unaffected paths resolved; ten authorial packets remain BLOCKED |
| CD/0 nonregression | PASS-PROTECTED |
| v1 nonregression | PASS-PROTECTED, 6/6 |
| Evidence archive members/bytes/SHA-256 | 180 / 9,573,988 / `afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa`; source commit `a8bfdbd...`; archive commit `37cdf0a...` |
| Cleanup commit and retained/deleted inventory | `e21ef1ae40335c7f8ac00de51edaf0c766f27feb`; 63 files / 232,093,546 bytes deleted; nine compact raw summaries/manifests/inventories retained plus archive |
| Branch publication and remote read-back | PASS: Common Lisp `2513c354...`, Python `db627cb6...`, integration content `05d985bc...`; atomic non-force push and fetched remote equality; main `26ac543...` unchanged |
| Independent reviewer PASS | PENDING |
| Independent audit standing | Corrected unaffected implementation/evidence ready for audit; overall completion BLOCKED pending authorial closure; no reviewer PASS |

No N/A is counted as a pass. The accurate independence claim remains:
independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation.

## Proof-carrying result summary

| Obligation group | Verification | Status | Residual uncertainty |
| --- | --- | --- | --- |
| Frozen corpus and canonical octets | independent 1,593-document roundtrip in both languages | CONVERGED-UNAFFECTED | none observed in the frozen corpus |
| Official semantic vectors | all 215 executed in both languages | BLOCKED | exact documents for N012, E5, P024, and P029 require authorial closure |
| Relation and hostile boundaries | all 458 relations and 29 hostile requests per language | BLOCKED | 38 paths and 8 hostile exact results are unpinned; only three blocked cross-language hostile differences remain |
| Deterministic mutation/host matrix | 329 cases across six adapters plus ten native profiles | BLOCKED | 104 failure-coordinate and 14 result-coordinate cases are deliberately not promoted |
| Protected CD/0 and v1 behavior | five independent nonregression gates and protected-object comparison | PASS-PROTECTED | finite tests, not a formal proof |
| Archive/cleanup | deterministic archive rebuild, full extracted-manifest verification, Git deletion census | COMPLETE | archive source predates its own receipt and cleanup by design; all later identities are recorded outside the archive |
| Publication | atomic non-force push, `ls-remote`, fetched-ref equality, and remote archive-blob hash | COMPLETE-PUBLISHED | receipt-containing integration commit is verified in the final handoff because a receipt cannot name its own commit |
| External reviewer | no PASS exists | PENDING | independent reviewer disposition |
