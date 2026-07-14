# LCI/0 Implementation Ledger

Date: 2026-07-14

Status: integration successor verification PENDING; three authorial closures
BLOCKED

This ledger is a requirements crosswalk, not a PASS receipt. It binds each
authorized surface to its normative source, fixture witnesses, implementation
owners, and the evidence still required at the integration-successor boundary.
Historical seed observations remain available in the two immutable seed
receipts, but no seed result is promoted here into a final integration result.

## Authority and boundary

The authority order applied is frozen CD/0 specification and errata; the LCI/0
candidate; LCI/0 Errata 0.1; the fixture-package specification; the machine
registry and vectors; the post-review ruling; and the Fable PASS receipt for
authorization and disclosed notes.

The implementation boundary is fixture-only. It excludes production warrant
minting or WarrantId, production standing or admissibility, capabilities,
authority, cryptographic selection, production module/procedure identity,
custody or verified lineage, live v1 migration, and any CD/0 change.

Status vocabulary in result columns is deliberately limited to `PENDING` and
`BLOCKED`:

- `PENDING` means successor implementation or evidence remains to be run,
  reviewed, committed, or archived.
- `BLOCKED` means a named authorial-return packet prevents a determinate final
  assertion for the affected path. It is not a pass, failure, skip, or N/A.

## Core implementation crosswalk

| ID | Authorized obligation | Normative anchors | Registry/vector anchors | Common Lisp owner/tests | Python owner/tests | Differential evidence | Successor/final result | Residual boundary |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | Immutable fixture representations and immutable views for every required LCI value | LCI §§5–7, 18, 20, 23; Errata E4, E6, I12 | Closed-schema definitions; N001–N010; E6; I12 | `common-lisp/values.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/tests/test_surface.py` | Closed-value and mutation requests to `differential/run_differential.py` | PENDING | Fixture schemas only; no production identity objects |
| A2 | Closed schemas, unknown-field rejection, exact nested versions, deterministic recursive validation | LCI §18; Errata E4, E6, I12 | Closed-schema field orders; E6; I12; hostile nested-key witnesses | `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_red_boundaries.py` | `LCI0-DIV-008`–`010`; successor hostile matrix | PENDING | Exact key namespaces and nested closure require successor confirmation |
| A3 | Typed `LCIFailure/0` category, code, stage, and structural path | LCI §18; Errata E6, I12 | Negative vectors; resource vectors; relation failures | `common-lisp/values.lisp`, `common-lisp/validation.lisp`, `common-lisp/operations.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/lci0/runner.py` | Exact failure tuple comparison in `differential/protocol.py` | BLOCKED | Thirty-eight unpinned relation failure paths await the relation-path packet |
| B1 | Pure, total fixture JSON adapter covering every encountered package form | CD/0 §§8, 15, 27; LCI Errata E1; Fixture §§0, 13 | 675 definitions; 215 inputs; 215 expected results; E1 nested documents | `common-lisp/json.lisp`, `common-lisp/fixture-adapter.lisp`, `common-lisp/registry.lisp`, `common-lisp/tests.lisp` | `python/lci0/adapter.py`, `python/lci0/package.py`, `python/tests/test_adapter.py` | 1,593 canonical roundtrips plus hostile adapter witnesses | PENDING | Canonical CD/0 octets, not either JSON surface, remain authoritative |
| B2 | Redundant-field consistency, boolean/integer distinction, exact rationals, segmentation/case, no Unicode normalization, unknown-shape fail-closed | CD/0 datum behavior; Errata E1 | Adapter schema census; rational and identifier fixtures | `common-lisp/fixture-adapter.lisp`, `common-lisp/tests.lisp` | `python/lci0/adapter.py`, `python/tests/test_adapter.py` | `LCI0-DIV-002`; successor adapter census | PENDING | No semantic inference, lookup, or CD/0 codec broadening |
| C1 | Frozen fixture Mneme proposition grammar and deterministic normalizer only | LCI §7; Errata E3–E4 | Proposition grammar/forms; P001–P012; placement vectors | `common-lisp/operations.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_vectors.py` | Exact vector result comparison | PENDING | No complete Mneme logic |
| C2 | Subject-versus-locator placement, quantified domains/horizons, proposition/location consistency, exact profile identities | LCI §7; Errata E3–E4 | Placement family; P001–P012; negative placement vectors | `common-lisp/validation.lisp`, `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Placement and changed-coordinate requests | PENDING | No optional identity coordinate may be inferred |
| C3 | Represented loss when normalization discards a declared distinction | LCI §§7, 23; Errata E3, E9 | LOSS family; migration loss accounts | `common-lisp/operations.lisp`, `common-lisp/migration.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Exact represented-loss document comparison | PENDING | Only closed fixture account schemas are authorized |
| D1 | Primary and bridge-less secondary scope calculi, normalization, and relation vocabulary | LCI §§11–12; Errata E4–E5 | 169 scope relation documents; scope vectors | `common-lisp/calculi.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Full relation-table execution; `LCI0-DIV-004` | BLOCKED | N012 universal/symbolic matcher composition and companion failure paths await closure |
| D2 | Temporal model and relation table without converting containment into direct target support | LCI §13; Errata E1, E2, E5 | 289 temporal relation documents; temporal vectors | `common-lisp/calculi.lisp`, `common-lisp/matching.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Full relation-table execution; `LCI0-DIV-001`, `005`, `014` | BLOCKED | Exact relation values are machine-pinned; 14 companion paths await closure |
| D3 | Dataset-slice, semantic-boundary, corpus-basis, and interpretation-frame validation/calculi | LCI §§14–15; Errata E4–E6 | Slice, boundary, corpus, and frame definitions/vectors | `common-lisp/calculi.lisp`, `common-lisp/validation.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Fixture vectors and hostile nested-boundary requests | PENDING | Fixture calculi only |
| E1 | Fourteen exact fixture StableRef schemes and only registry-declared bridges | LCI §6; Errata E7 | StableRef definitions; E7 family | `common-lisp/validation.lisp`, `common-lisp/registry.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | `LCI0-DIV-003`, `008`; successor hostile matrix | PENDING | Not universal production identity; bridges do not alter envelope equality |
| E2 | Mutable aliases, wrong domains/schemes/prefixes, and over-budget material fail closed | LCI §6; Errata E6–E7; Fixture §10 | Mutable-alias and resource witnesses | `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Exact hostile witnesses and resource requests | PENDING | No display name, filename, URL, package symbol, `latest`, or `main` is stable identity |
| F1 | Pure ClaimId projection from normalized proposition and validated location into exact closed envelope | LCI §§7, 20; Errata E1, E3, E8 | P001–P012; N015–N016; METADATA family | `common-lisp/operations.lisp`, `common-lisp/validation.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/lci0/runner.py`, `python/tests/test_surface.py` | Exact envelope and canonical-octet comparison | PENDING | ClaimId is the envelope, never a digest |
| F2 | Exact neutral/base values, every identity coordinate, recomputation, and ambient-state independence | LCI §20; Errata E1, E8 | Neutral/base vectors; digest-only negatives; metadata vectors | `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp`, `common-lisp/run-perturbation.lisp` | `python/lci0/core.py`, `python/tests/test_perturbations.py`, `python/tests/test_red_boundaries.py` | Mutation, independent-allocation, and host perturbation phases | PENDING | No filesystem, network, policy, standing, registry, model, procedure, or wall-clock action |
| G1 | Eleven exact WarrantTarget schemas, schema pairing, nested closure, and inert validation | LCI §9; Errata E4–E6, I12 | Target schema definitions; TARGET family; P013–P021 | `common-lisp/validation.lisp`, `common-lisp/matching.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | `LCI0-DIV-010`; target hostile witnesses | PENDING | Validation and matching only; no warrant minting |
| G2 | Pure target matching with only `exact-target` and `supports-by-scope-narrowing` successes and exact hard failures | LCI §10; Errata E2, E5–E6, I12 | Match vectors; N012; E5 coverage vector | `common-lisp/matching.lisp`, `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py`, `python/tests/test_vectors.py` | Exact relation/failure comparison | BLOCKED | N012 and E5 coverage context have separate authorial-return packets |
| G3 | Every F-valued match is hard-inadmissible before policy consultation | LCI §§10, 17; Errata E2 | N vectors; policy-floor witnesses | `common-lisp/matching.lisp`, `common-lisp/policy.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Relation-undetermined hostile and policy-call boundary | PENDING | Policy may reject success but never promote failure |
| H1 | Exact finite fixture Policy-A and Policy-B decision records | LCI §17; Errata E2, E5 | Policy definitions; P022–P023; E2 | `common-lisp/policy.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Policy vector execution; `LCI0-DIV-013` | PENDING | Deterministic conformance instruments, not production admissibility |
| H2 | Fixture freshness, represented loss, inherited testimony, external attestation, and narrowing permission | LCI §17; Errata E2, E5 | Policy A/B records and associated vectors | `common-lisp/policy.lisp`, `common-lisp/operations.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Exact decision-record comparison | PENDING | Unknown policy identity must fail closed |
| I1 | Non-evaluating bounded v1 fixture grammar and exact frozen mappings | LCI §23; Errata E9, I12(e) | Migration definitions; P024–P030; E9 | `common-lisp/migration.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py`, `python/tests/test_vectors.py` | Migration vectors and hostile grammar/source requests; `LCI0-DIV-012` | PENDING | No current v1 registry/procedure lookup and no legacy code loading |
| I2 | Exact/tagged/new-identity/lossy/rejected/deferred/privileged-runtime classifications and closed loss accounts | LCI §23; Errata E9 | E9 and LOSS families | `common-lisp/migration.lisp`, `common-lisp/values.lisp` | `python/lci0/core.py`, `python/lci0/model.py` | Exact migration/loss result comparison | PENDING | Old fingerprints are inert predecessor metadata only |
| I3 | Zero live warrants and refusal of live-warrant restoration | LCI §23; Errata E9, I12(e) | Migration inertness vectors; privileged-restoration negative | `common-lisp/migration.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Inert/live result and typed failure comparison | PENDING | `PrivilegedRestorationAttempt` remains an LCI failure code |
| J1 | Exact resource budgets, structural counters, and operation jurisdictions | LCI §18; Errata E6, I12; Fixture §10 | N032; RESOURCE-01–13 | `common-lisp/validation.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Resource vectors and limit/over-limit hostile requests; `LCI0-DIV-011` | PENDING | CD/0 failures remain in the CD/0 namespace |
| J2 | Deterministic closed-record order and depth-first recursive validation | LCI §18; Errata E6, I12 | Closed schema orders; resource/failure vectors | `common-lisp/validation.lisp`, `common-lisp/fixture-adapter.lisp` | `python/lci0/core.py`, `python/lci0/adapter.py` | Exact category/code/stage/path comparison | BLOCKED | Relation-path packet blocks only the 38 unpinned companion paths |
| K1 | Nonidentity metadata wrapper and identity neutrality | LCI §20; Errata E3, E8 | METADATA family; P/N mutation vectors | `common-lisp/values.lisp`, `common-lisp/operations.lisp`, `common-lisp/tests.lisp` | `python/lci0/model.py`, `python/lci0/core.py`, `python/tests/test_perturbations.py` | Metadata mutation and envelope-byte comparison | PENDING | Claimant, assertion time, provenance, lineage, presentation, and authorized metadata are nonidentity |
| K2 | Proposition or identity-locator mutation changes ClaimId; source mutation after construction cannot | LCI §20; Errata E3, E8 | Changed-coordinate and mutation witnesses | `common-lisp/operations.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Property/mutation phase | PENDING | Host pointer/package/object identity is forbidden |

## Corpus, vectors, independence, and evidence crosswalk

| ID | Obligation | Evidence basis already retained | Required successor/final evidence | Result |
| --- | --- | --- | --- | --- |
| CENSUS-1 | Discover and classify 675 registry definitions, 215 vector inputs, and 215 vector expected results | Preflight receipt; immutable seed receipts; baseline differential receipt | Re-run from committed successor trees; record command, duration, implementation request IDs, and manifest hashes | PENDING |
| CENSUS-2 | Verify 1,105 official embedded canonical documents separately from 458 relation plus 30 nested E1 supplementary documents | Baseline reports 1,593/1,593 roundtrips in both seeds | Successor 1,105 + 488 sweep; checksum/byte-count validation; magic-prefix completeness proof | PENDING |
| VECTOR-1 | Execute 215 unique shared vectors with P001–P030 and N001–N032 complete and no local expected results | Both seed receipts; baseline request census | Exact successor comparison of input/expected octets and every required semantic projection | BLOCKED |
| VECTOR-2 | Preserve minimal witnesses for all disagreements and never select an implementation as oracle | `LCI0-IMPLEMENTATION-DIVERGENCES.md` and baseline raw evidence | Successor divergence disposition and permanent regression status for every entry | BLOCKED |
| RED-1 | Preserve fifteen pre-seed red boundaries before green implementation | Common Lisp and Python red transcripts and seed receipts | Confirm immutable seed objects and archive membership; do not rewrite seed commits | PENDING |
| SEED-CL | Independently seeded Common Lisp implementation under procedural isolation | Commit `b3d28bc49c3b015096cb04c6ad08c19829f511a9`, tree `d48c39f933cde591f3303fcd3c9f42a0dac1a869`; inspected-file inventory | Successor correction commit/tree and unchanged-seed ancestry audit | PENDING |
| SEED-PY | Independently seeded Python implementation under procedural isolation | Commit `4ec2e519d05aeacd2412cb8aedc5f76bde702571`, tree `9f7915b460f449976a5d7fa856861ad5ce1d36ca`; seed receipt | Successor correction commit/tree and unchanged-seed ancestry audit | PENDING |
| DIFF-1 | Integrate both seeds unchanged, classify disagreements, then correct independently | Baseline integration `71f7cfc5ebe392d59d820203dad11cc2e86a0542`; evidence commit `80f1202cc6d176d891179ca408d41136c9a28a97`; 2,281 requests per implementation | Merge successor commits; rerun exact suite; record request/response counts and hashes | BLOCKED |
| PERTURB-1 | Run language-specific host perturbations plus shared mutation/ambient-state checks | Language seed observations only | Integration-successor fresh-process matrix and retained raw summaries | PENDING |
| PROPERTY-1 | Add deterministic randomized/property generation only after exact non-blocked fixture convergence | Python seed reports 256 cases at seed `0x4C434930`; integration phase deferred | Record exact generation algorithm, seeds, case/request counts, minimized failures, and outputs | PENDING |
| NONREG-1 | Preserve frozen CD/0 source, artifacts, canonical octets, and suites | Preflight and seed receipts | Re-hash protected inventory from final successor tree and rerun Phase 0, CL, Python, and CD/0 differential | PENDING |
| NONREG-2 | Preserve existing v1 and production Mneme behavior; introduce no live authority/warrant object | Preflight and seed receipts | Rerun `mneme/verify-all.sh`; inspect protected diffs and exported symbols from final successor tree | PENDING |
| EVIDENCE-1 | Produce checksummed reproducible evidence archive | Common Lisp seed archive only | Final integration archive members, bytes, SHA-256, deterministic rebuild comparison, and manifest | PENDING |
| CLEANUP-1 | Commit raw transcripts and archive before deleting safe loose detritus | Baseline raw files are retained in Git history | Record raw-evidence commit, archive commit, cleanup commit, deletion inventory, and post-clean tree audit | PENDING |
| PUBLISH-1 | Push successor branches non-force and verify remote read-back without merging main | No final publication claim exists | Atomic/non-force push command, remote object IDs, read-back fetch, branch protection observation | PENDING |
| AUDIT-1 | Fresh independent implementation audit after convergence and evidence completion | Not yet performed | Reviewer identity/boundary, audit command/evidence, findings, and disposition | PENDING |

## Authorial-return gates

| Packet | Affected obligation | Exact blocked surface | Unaffected work that may continue | Result |
| --- | --- | --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | D1, G2, VECTOR-1 | `LCI0-N012` universal/symbolic direct matcher result and ordering | Other 214 vectors and unaffected relation entries | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | A3, D1, D2, J2 | Thirty-eight unpinned companion failure paths | All 458 machine-pinned relation values | BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | G2, VECTOR-1 | Expected-only `actual-coverage-scope` context in `LCI0-E5-COVERAGE-INSUFFICIENT` | Failure category/code/stage/path and all input-derived context | BLOCKED |

## Final fill-in register

| Required report item | Value/status |
| --- | --- |
| Common Lisp successor commit/tree | PENDING |
| Python successor commit/tree | PENDING |
| Integration successor commit/tree | PENDING |
| Exact changed-file inventory | PENDING |
| Successor runtime versions | PENDING |
| Official/supplementary corpus counts | PENDING |
| Vector and differential request counts | BLOCKED pending the three exact authorial dispositions; unaffected counts PENDING |
| Property/mutation counts and seeds | PENDING |
| Divergence ledger closure | BLOCKED |
| CD/0 nonregression | PENDING |
| v1 nonregression | PENDING |
| Evidence archive members/bytes/SHA-256 | PENDING |
| Cleanup commit and retained/deleted inventory | PENDING |
| Branch publication and remote read-back | PENDING |
| Independent reviewer PASS | PENDING |
| Eligibility for independent implementation audit | BLOCKED; must not be asserted by this ledger |

No N/A is counted as a pass. The accurate independence claim remains:
independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation.
