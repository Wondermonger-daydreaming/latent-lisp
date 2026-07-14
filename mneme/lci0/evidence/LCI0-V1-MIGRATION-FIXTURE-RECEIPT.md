# LCI/0 v1 Migration Fixture Receipt

Date: 2026-07-14

Status: successor migration verification PENDING; live migration remains out of
scope

## Authorized boundary

Only the frozen, non-evaluating, bounded fixture migration grammar and exact
package mappings are authorized. This work may produce inert fixture data only.
It must not load or run legacy v1 code, consult a current v1 registry or
procedure, restore a live warrant, create authority, or begin production
migration.

## Historical evidence and contradiction

Both immutable seed receipts report the shared migration vectors and inertness
tests green at their seed gates. The later baseline hostile-input comparison
found that the seed implementations accepted undeclared grammar/source shapes;
that defect is recorded as `LCI0-DIV-012`. The Python baseline also accepted an
unknown migration field that Common Lisp rejected.

Accordingly, the seed observations remain historical evidence but do not prove
the successor migration surface. No final migration PASS is asserted here.

## Normative fixture obligations

| ID | Obligation | Common Lisp owner/tests | Python owner/tests | Successor differential | Result |
| --- | --- | --- | --- | --- | --- |
| V1-01 | Parse only the declared non-evaluating bounded fixture grammar | `common-lisp/migration.lisp`, `common-lisp/tests.lisp` | `python/lci0/core.py`, `python/tests/test_surface.py` | Exact valid/invalid grammar requests | PENDING |
| V1-02 | Use only exact frozen package/symbol mappings | `common-lisp/migration.lisp`, `common-lisp/registry.lisp` | `python/lci0/core.py`, `python/lci0/package.py` | Mapping mutation matrix | PENDING |
| V1-03 | Use exact `as-of` source-site-to-role table | `common-lisp/migration.lisp` | `python/lci0/core.py` | Role-table vectors and hostile mutations | PENDING |
| V1-04 | Use exact scope, time, corpus, and frame mappings | `common-lisp/migration.lisp`, `common-lisp/calculi.lisp` | `python/lci0/core.py` | Coordinate-by-coordinate comparison | PENDING |
| V1-05 | Distinguish exact, tagged, new-identity, lossy, rejected, deferred, and privileged-runtime classifications | `common-lisp/migration.lisp`, `common-lisp/operations.lisp` | `python/lci0/core.py`, `python/lci0/runner.py` | P024–P030, E9, and classification requests | BLOCKED for the unpinned classification/content coupling matrix; pinned fixture paths remain testable |
| V1-06 | Produce exact closed represented-loss accounts | `common-lisp/migration.lisp`, `common-lisp/values.lisp` | `python/lci0/core.py`, `python/lci0/model.py` | LOSS family exact document comparison | PENDING |
| V1-07 | Preserve old fingerprints as inert predecessor metadata only | `common-lisp/migration.lisp` | `python/lci0/core.py` | ClaimId neutrality and migration result checks | PENDING |
| V1-08 | Create zero live warrants | `common-lisp/migration.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Inert/live result field comparison | PENDING |
| V1-09 | Refuse attempted live-warrant restoration with the exact LCI failure | `common-lisp/migration.lisp` | `python/lci0/core.py` | Privileged-restoration witness | PENDING |
| V1-10 | Reject unknown top-level and nested fields/versions in deterministic order | `common-lisp/validation.lisp`, `common-lisp/migration.lisp` | `python/lci0/core.py` | Hostile closure matrix | PENDING |
| V1-11 | Perform no current registry, filesystem, network, procedure, or wall-clock lookup | `common-lisp/migration.lisp`, `common-lisp/run-perturbation.lisp` | `python/lci0/core.py`, `python/tests/test_perturbations.py` | Unavailable-ambient-state profiles | PENDING |
| V1-12 | Keep cognate CD/0 and LCI failure jurisdictions distinct | `common-lisp/values.lisp`, `common-lisp/migration.lisp` | `python/lci0/model.py`, `python/lci0/core.py` | Exact category/code/stage/path comparison | PENDING |

## Required vector and classification census

| Family/result | Required or mechanically derived scope | Successor result |
| --- | --- | --- |
| P024–P030 | 7 required positive IDs | BLOCKED for P024 and P029 exact results; other five P-family results remain testable |
| E9 family | 15 mechanically observed fixture vectors | PENDING |
| LOSS family | 14 mechanically observed fixture vectors | PENDING |
| Privileged restoration refusal | Exact fixture witness | PENDING |
| Unknown-field/version closure | Exact hostile matrix | PENDING |
| Inert results | All accepted migration results | PENDING |
| Live warrants created | Must equal zero | PENDING |
| Legacy runtime loads/evaluations | Must equal zero | PENDING |

## Failure and result comparison record

For every migration request, record the canonical input, classification,
represented-loss account, inert/live result, and typed failure tuple. Host
exception prose is never a comparison oracle.

| Field | Common Lisp | Python | Expected fixture | Differential result |
| --- | --- | --- | --- | --- |
| Classification counts | PENDING | PENDING | PENDING | PENDING |
| Represented-loss account count | PENDING | PENDING | PENDING | PENDING |
| Rejected/deferred count | PENDING | PENDING | PENDING | PENDING |
| Privileged-runtime count | PENDING | PENDING | PENDING | PENDING |
| Inert result count | PENDING | PENDING | PENDING | PENDING |
| Live result count | PENDING | PENDING | Must be 0 | PENDING |
| Typed failure mismatches | PENDING | PENDING | Must be 0 on non-blocked paths | PENDING |
| Underdetermined results | PENDING | PENDING | Must be 0 outside declared blocked paths | BLOCKED for P024, P029, and the unpinned classification/content coupling matrix |

## Exact command and environment fill-in

| Field | Value/status |
| --- | --- |
| Common Lisp successor commit/tree | PENDING |
| Python successor commit/tree | PENDING |
| Integration successor commit/tree | PENDING |
| SBCL version | PENDING |
| Python version | PENDING |
| Migration command(s) | PENDING |
| Hostile-input command(s) | PENDING |
| Ambient-state command(s) | PENDING |
| Exit statuses and durations | PENDING |
| Raw transcript members and hashes | PENDING |

## Authorial-return boundary

Ten provisional authorial packets are current. Three directly constrain the
migration result surface: P024, P029, and classification/content coupling. The
other seven do not presently reopen the declared bounded grammar or the
zero-live-warrant obligation, but all ten must remain in the final relay:

| Packet | Migration impact |
| --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | No direct migration impact identified; matcher path remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | No direct migration impact identified; 38 companion paths remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | No direct migration impact identified; expected result context remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md` | Direct migration impact: explicit corpus-r4 source is `.../v1/1` while expected right result uses `.../v1/2`; P029 right result BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-POLICY-EVALUATION-ORDER.md` | No direct bounded-grammar or inertness impact identified; combined policy witness remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-CORPUS-BASIS-COHERENCE.md` | No direct migration grammar impact identified; exact mixed-revision rejection tuple remains BLOCKED wherever migration validates a resulting basis |
| `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md` | Migration payloads remain closed, but exact missing/unknown-field tuples for novel payload mutations remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md` | Direct migration impact: the package does not pin the complete classification/content validity matrix or inverse failure tuples |
| `LCI0-AUTHORIAL-RETURN-PACKET-TARGET-BOUNDARY-COHERENCE.md` | No direct bounded-grammar or inertness impact identified; novel kind-coherence witnesses remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md` | Direct migration impact: P024 expected output injects an occurrence not bound by its input; exact result BLOCKED |

Any new migration ambiguity must stop only its affected path and receive its own
minimal witness and authorial-return packet.

## Archive, cleanup, and publication fill-in

| Item | Status/value |
| --- | --- |
| Raw migration transcript commit | PENDING |
| Raw members/bytes/SHA-256 | PENDING |
| Reproducible archive membership and SHA-256 | PENDING |
| Loose raw transcript removal after archive commit | PENDING |
| Safe migration temp/cache cleanup inventory | PENDING |
| Final branch and remote read-back | PENDING |

## Current disposition

Successor v1 fixture migration, represented loss, and inertness verification are
PENDING. This receipt does not authorize or claim live v1 migration, and it does
not claim final convergence, nonregression, publication, PASS, or audit
eligibility.
