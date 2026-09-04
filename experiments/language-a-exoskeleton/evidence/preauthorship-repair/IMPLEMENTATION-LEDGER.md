# Pre-authorship repair implementation ledger

Input: `origin/codex/language-a-emission-pilot-packet` at commit
`f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e`, tree
`6561d3097c056c517e9f67fad1c168608d60f0db`.

The ruling, scoped Errata, freeze-work docket, and anti-taxidermy design note are
tracked byte-identically under `evidence/authorial-review/`. The design note is
reviewed design input, not a new authority artifact.

| ID | Obligation | Owning artifacts | Deterministic evidence | Standing | Residual boundary |
|---|---|---|---|---|---|
| FI-01 | Make item/source/rendering/exclusion/dossier/handoff rules executable before authorship | `schemas/preauthorship.schema.json`, `harness/preauthorship.py` | strict schema validation, graph closure, byte checks, and declared mutations | closed for this pre-authorship tranche | no real records were created; owner adoption still required |
| FI-05 | Replace illustrative lineage with canonical digest-chained successor records | `lineage/successor/events.jsonl`, `harness/preauthorship.py` | digest recomputation, predecessor/parent/read/chronology/successor mutations | closed for this pre-authorship tranche | claims remain bounded to the declared construction ledger |
| R-01 | Strict item/source/rendering and commission contract | schema bundle, `preauthorship/README.md`, `controls/preauthorship-mutations.json` | malformed, dangling, tainted, duplicate, leak, moving-bank, and wrong-version refusals | satisfied within the requested pre-authorship surfaces | freezer/key authorship and real-bank enforcement are later tranches |
| R-04 | Semantic manifest and lineage closure | `CONSTRUCTION-MANIFEST.*`, successor lineage, original/successor inventory | exact path/length/hash manifest plus semantic record validator | satisfied within FI-01/FI-05 scope | no exposure/freeze signature or full run lineage is claimed |
| ODR-43 | Typed item-author identity decision | `operator/owner-decisions/ODR-43.json` | schema and forgery mutation | unresolved, executable drafting gate closed | owner must choose actors and disclosures |
| ODR-60 | Typed allocation-detail decision | `operator/owner-decisions/ODR-60.json` | schema and Boolean-forgery mutation | unresolved, executable drafting gate closed | owner must choose allowed allocation values |
| BOUNDARY | Keep freezer-only content out of `KEY-AUTHOR-INPUT` | dossier and handoff schemas, boundary validator | role/answer/opportunity/trap/witness/example/outcome/schedule/grader mutations | satisfied for schema and handoff boundary | no key commission exists |
| STATE | Distinguish draft, candidate, freezer-accepted, and frozen without textual promotion | item/source/rendering schemas and consumer gates | runner/schedule/scoring/exposure/moving-bank/state-promotion mutations | satisfied; tranche ceiling is candidate | freezer acceptance/freeze remain unauthorized |
| CV-INPUT | Preserve construct-validity capacity without implementing scoring | opportunity, keyed-unit, future-profile, specimen, and rider schemas; taint/deferral registries | schema validation plus zero-opportunity, scalar-gate, axis-collapse, and key-crossing mutations | incorporated as capacity only | construct validity is not established |
| SCOPE | Preserve protected repository scopes and reviewed evidence | protected-scope diff, successor-only paths | Git path audit and construction manifest | satisfied within observed worktree | remote identity is checked after push |

## R-01 implementation detail

The schema bundle has closed record shapes for item records, finite source
manifests, exact components and locators, arm renderings, ancestry, prior
exposure, exclusion/taint, lexical and semantic overlap, catchability,
freezer-only dossiers, freezer decisions, and minimized key-author handoffs.
The handoff validator also closes each allowed artifact kind to a dedicated
record schema and exact byte binding, so relabeling private or item material as
public doctrine or authority metadata is not an escape hatch.
Every draft graph is checked for canonical record digest, exact bound bytes,
stable identity distinct from filenames, actor/time/version metadata, duplicate
IDs, exact references, source-component presence, state, and taint standing.

ODR-43 and ODR-60 also have separate closed adoption payloads. The former can
name only actor, assignment, access, audit, and exposure-declaration data; the
latter can name only the authority-bounded allocation, overlap, family,
instantiation, trap-vocabulary, and distinctness policy. The current records
contain neither payload and remain unresolved.

Private opportunity and hierarchical keyed-unit schemas are future-only. They
cannot enter runner-visible item records or `KEY-AUTHOR-INPUT`. A not-applicable
opportunity requires an explicit justification and denominator exclusion; a
zero-opportunity record has a separate explicit justification, and missing
opportunity declarations force the profile to remain unadjudicated rather than
creating a completeness default.

## R-04 lineage implementation detail

The reviewed seven lineage files remain byte-unchanged. The successor is one
append-only JSONL chain with a strict event schema. Each event digest covers its
canonical bytes excluding only the two derived digest metadata members. Every
non-root predecessor is the exact prior event digest. Artifact refs bind exact
event digest, content digest, and byte length. Created artifacts require prior
reads of input artifacts. Chronology is monotonic unless explicitly declared
causal. Self-report can disclose contamination but cannot certify separation.
The docket’s FI-05 rejection remains present before correction and successor
events.

## Construct-validity incorporation and deferral

Incorporated now: schema capacity, a permanently tainted TXD-01…TXD-10 identity
registry, opportunity provenance hooks, hierarchical unit coverage, orthogonal
structural/substantive axes, differential truncation position, and a profile
whose optional composite is hard-coded non-gating.

Deferred to freeze-quality repair: scoring behavior, executable specimen
behavior, numerical thresholds, substantive-content adjudication, the repaired
precision study, and actual branch riders. No branch receipt or construct-
validity verdict is emitted here.

## Deliberately unperformed work

No real item/source/rendering/witness/answer was authored; no private key or
score content was created; no schedule or target material changed; no provider,
grader, adjudicator, or target was contacted; no bank or packet was frozen; no
scientific margin, branch law, threshold, or owner value was selected; and no
protected scope was modified.
