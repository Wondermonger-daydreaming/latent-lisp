# GPT-KERNEL-0-ERRATA-CONCORDANCE

**Status:** independent comparative synthesis record — not adopted, not governing  
**Date:** 2026-07-19  
**Purpose:** clause-by-clause comparison of the two blind Kernel /0 erratum candidates,
with disagreements preserved and a proposed disposition for the later two-chair
reconciliation.

## 0. Parent identity and packet verification

### Parent G — GPT candidate

- Artifact: `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`
- SHA-256: `b0708a517e1ef985d0d78d4bed0bbf2fc3ef9fa96644d6549620e291826469b0`
- Standing: independent adoption candidate, produced before receipt of Parent F.

### Parent F — Fable candidate and evidence package

- Candidate: `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`
  - SHA-256: `b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34`
- Decision ledger: `FABLE-KERNEL-0-ERRATA-DECISION-LEDGER.md`
  - SHA-256: `689c748a2fd99150052a07b99a56e4187a47890ec31dfb1849114d32778be121`
- Trace matrix: `FABLE-KERNEL-0-ERRATA-TRACE-MATRIX.md`
  - SHA-256: `4d1a5fc79d7cf2dac6dfe2d379ab20e249bae61e3161b34cf409145ccf21bd8e`
- Relay manifest: `FABLE-KERNEL-0-ERRATA-RELAY-MANIFEST.md`
  - SHA-256: `b1b222d7df3446c6ae5722cfb611394b0f5fba1632bf1aa4fc8c9f181b89ae8f`
- Repository commit inspected by Fable:
  `261122d15228c9214864fc3e28381c94651996b1`
- Relay ZIP SHA-256:
  `f7c830961bca438354222435e67fd027554baadaa6f49486d781fab35234c3d9`

The relay ZIP was unpacked and its internal `SHA256SUMS.txt` verified with no mismatch.
Fable's independence attestation is accepted as packet evidence, not as an independent
audit of the attestation itself.

## 1. Classification vocabulary

- **AGREEMENT** — same normative result, despite wording or granularity differences.
- **COMPATIBLE DIFFERENCE** — both may coexist after a precise merge.
- **NORMATIVE FORK** — the candidates prescribe incompatible law.
- **ONE-SIDED OMISSION** — one candidate contains a needed clause absent from the other.
- **UNAUTHORIZED INVENTION** — a clause lacks a lawful source or crosses a delegated
  boundary.
- **EDITORIAL ONLY** — no semantic consequence.

No clause is labeled unauthorized invention merely because it is novel. The label is
reserved for unsupported enlargement of Kernel jurisdiction. Parent F's controversial
singleton construction is treated as a genuine normative fork, not dismissed by insult.

## 2. Executive concordance

The candidates converge strongly on the journal boundary, standing orthogonality,
structural-versus-semantic validation, divergence-preserving reports, partial-stream
preservation, and AP-G4's basic identity obligations.

The main disagreement is not cosmetic:

> Does `:bounded` permit a singleton alternatives set, and may the call-296
> manifestation omission be repaired by deriving the singleton
> `((:absent :state :absent-after-completion))`?

Parent F says yes, defining singleton-bounded as eliminative narrowing without positive
license. Parent G says no: under Kernel §7.3's own statement that the evidence licenses
one alternative, a singleton licenses exactly one value and collapses into §7.2
`:determinate`; if that value is not established, the honest states are
`:indeterminate`, an explicit bounded unknown, or non-constructibility.

This synthesis recommends Parent G's cardinality rule for **outcome-axis determinacy** and
keeps the historical call-296 projection non-constructible as a complete outcome until an
owner act resolves the missing alternative/state vocabulary. Parent F's complete argument
is retained in the open-forks docket.

## 3. Clause-by-clause matrix

| ID | Topic | Parent G | Parent F | Class | Proposed synthesis disposition |
|---|---|---|---|---|---|
| C-01 | Candidate standing | Adoption candidate; not governing | Same, with stronger independence metadata | AGREEMENT | Use F's metadata discipline and both parent hashes |
| C-02 | Governing source pin | General current-repository grounding | Exact commit and complete source inventory | ONE-SIDED OMISSION | Adopt F's commit/source inventory in the synthesis record |
| C-03 | PJ0/AP0 jurisdiction | Explicit delegated ownership | Explicit delegated ownership | AGREEMENT | Merge; Kernel references but does not fork byte/value law |
| C-04 | Which “gaps 1–4” | README gaps 1–4 | Union of README gaps with STATUS gaps 1–4 | ONE-SIDED OMISSION | Adopt the union, because the commissioning text mixes both ledgers and says “at minimum” |
| C-05 | Complete alternative values | Bare subfields illegal; alternatives are complete axis/domain values | Same, with per-axis declared-space law | AGREEMENT | Adopt F's declared-space formulation |
| C-06 | Singleton `:bounded` | Illegal; minimum cardinality two | Legal as eliminative narrowing without positive license | NORMATIVE FORK | Recommend minimum two for outcome axes; preserve F alternative in docket |
| C-07 | Current axis value membership | Implicit | Explicit membership, except effect-axis special case | ONE-SIDED OMISSION | Adopt F's membership rule |
| C-08 | Effect alternatives vs `:possible-effects` | Not made exact | Set-identical | ONE-SIDED OMISSION | Adopt; one uncertainty must not carry two drifting enumerations |
| C-09 | Call-296 status | Historical projection stays byte-identical; complete record non-constructible pending lawful evidence/act | Complete record constructible via derived singleton | NORMATIVE FORK | Recommend non-constructibility; do not infer factual elimination from missing capture |
| C-10 | Completion-presupposition tension | Implicitly motivates refusal | Explicit bounded unknown | COMPATIBLE DIFFERENCE | Adopt explicit bounded unknown |
| C-11 | Synthetic bounded fixture | Required, separate from call-296 facts | Not required | ONE-SIDED OMISSION | Adopt for testing the algebra independently of the live fixture |
| C-12 | §23 comparison object | Three coordinates: source, semantic replay, receipt fields | Six standings; replay bytes are comparison object | AGREEMENT | Adopt F's six-standing table plus G's comparison-policy language |
| C-13 | PJ0 structural vs Kernel semantic validity | Explicit | Explicit | AGREEMENT | Merge verbatim in substance |
| C-14 | Terminal-row evidence bundle | Named semantic bundle | Ten-item bundle referencing append and reconstruction receipts | COMPATIBLE DIFFERENCE | Use F's ten items, adding G's comparison-policy and required-condition fields |
| C-15 | Torn tail and corruption | Exact classification; no scan-forward | Same, plus tail→bounded witness | AGREEMENT | Merge; require at least one tail→bounded fixture |
| C-16 | Salvage and merge identity | New stores/digests; compare abstract events/views, not source frames | Same; requires a salvage witness row | AGREEMENT | Merge; one joint witness is prudent |
| C-17 | `:attempt-indeterminate` event | Omitted | Added with legality and no-resolution law | ONE-SIDED OMISSION | Adopt as a labeled STATUS-gap fold-in |
| C-18 | Validation record floor | Subject, validator, procedure/version, scope, evidence, unknowns | Validator, procedure/version, scope, evidence, unknowns | COMPATIBLE DIFFERENCE | Bind subject explicitly; require non-empty evidence for `:verified`/`:refuted` |
| C-19 | Integrity record floor | Subject, procedure/version, scope, evidence | Exact representation, seal method/version, principal, evidence | COMPATIBLE DIFFERENCE | Use exact representation identity and sealing principal from F; retain subject binding |
| C-20 | Visibility record floor | Subject, scope, basis, evidence | Representation, scope, basis, redaction receipt | COMPATIBLE DIFFERENCE | Merge; visibility attaches to an identified representation and scope |
| C-21 | Standing under transformation | No silent copying; receipt must state preservation/reduction/change | Default loss of integrity/validation/visibility; says origin persists | NORMATIVE DIFFERENCE WITH REPAIR | New output claim is `:derived`; source origin persists in provenance, not as the output's origin |
| C-22 | Context-free standing accessors | Global `published-p` rejected in prose | Explicit no-procedure/no-scope accessor law | ONE-SIDED OMISSION | Adopt F's accessor rule |
| C-23 | Judgment-class location | Minimal procedure descriptor | Reference-site `:judgment-class` | NORMATIVE FORK, SYNTHESIZABLE | Descriptor is authoritative; reference site may cache class but must match |
| C-24 | AP0 structural jurisdiction | Detailed list | Detailed list | AGREEMENT | Merge, trimming duplicates |
| C-25 | Semantic acceptance gate | Descriptor domain, result vocabulary, evidence | Semantic class + present/present-empty | AGREEMENT | Merge; descriptor/domain is the stronger check |
| C-26 | `:invalid` result | Structural invalidity preserved | `:invalid` may be structural or semantic | COMPATIBLE DIFFERENCE | Adopt F's clarification |
| C-27 | Joint report | Separate stages and exact failure | Two verdict fields with `pass/fail/not-run` | AGREEMENT | Adopt F's minimal report shape and G's required requirement IDs |
| C-28 | Adapter identity field | Explicit `:adapter-identity` iff AP0; else `:producer-identity` | Nested producer identity with producer class | NORMATIVE DIFFERENCE | Prefer explicit branches because the owner charge names `adapter-identity` |
| C-29 | Stream relation shape | Stream ID + ordered chunk-record IDs + projection receipt | Duplicates sequence/predecessor/finality fields into Kernel record | NORMATIVE FORK | Prefer references to AP0 chunk records; avoid a second, drift-prone chunk schema |
| C-30 | `:emptiness-rule-id` | Omitted from repaired A.2 | Added from Kernel §8.4 | ONE-SIDED OMISSION | Adopt |
| C-31 | Partial preservation | Captured chunks never erased | Same | AGREEMENT | Merge |
| C-32 | Aggregate receipt | Required for derived aggregate | Required | AGREEMENT | Merge |
| C-33 | Condition minting | Reused `standing-inflation` for several failures | Mints five exact condition types and blesses old use only historically | ONE-SIDED OMISSION | Adopt F's condition family; reserve `standing-inflation` for actual promotion |
| C-34 | Missing producer/stream field condition | `standing-inflation` | Generic constructor refusal | COMPATIBLE DIFFERENCE | Use `malformed-constructor-shape` for Kernel-only missing fields; AP0 conditions on AP0 path |
| C-35 | Explicit anti-Python transplantation | Explicit | Gate stated, but prohibition less operationally enumerated | ONE-SIDED OMISSION | Adopt G's explicit prohibition |
| C-36 | Negative controls | Sixteen controls | Nineteen controls | COMPATIBLE DIFFERENCE | Union, deduplicated and mapped to requirement IDs |
| C-37 | Remaining gates | CL PJ0/AP0, specimen, stranger audit remain open | Same | AGREEMENT | Merge |
| C-38 | Ride-beside vs reissue | Assumes erratum governs beside spec | Leaves owner choice open | NORMATIVE FORK | Recommend ride-beside now; fold into first freeze candidate later |

## 4. Findings by class

### 4.1 Agreement

The strongest convergence is on:

- PJ0 structural validity never establishing Kernel semantic validity;
- replay identity being the canonical derived view, not salvage-frame bytes;
- torn-tail preservation and interior-corruption refusal;
- deletion/exclusion of finalizers, caches, indexes, and snapshots before reconstruction;
- orthogonality of origin, validation, integrity, and visibility;
- parser validity never implying semantic acceptance;
- two-stage AP0/Kernel reports preserving “structural PASS / semantic FAIL”;
- explicit adapter provenance;
- explicit stream lineage;
- receipt-bearing chunk aggregation;
- permanent visibility of captured partials;
- AP0/PJ0 independence riders remaining open.

This is genuine convergence from a shared root, not independent empirical corroboration.

### 4.2 Compatible differences

The record-shape differences are mostly mergeable. Parent F is better on exact
representation identity for integrity; Parent G is better on explicit subject binding and
non-empty evidence for strong validation standing. The synthesis should use both.

The reconstruction sections are mutually reinforcing: Parent F's six standings provide a
clean taxonomy, while Parent G's comparison-policy field prevents accidental
byte-comparison of environment-dependent receipt fields.

### 4.3 Genuine forks

There are four substantive forks:

1. singleton-bounded law and call-296 constructibility;
2. authoritative procedure descriptor versus reference-site class declaration;
3. reference-based versus duplicated stream relation;
4. ride-beside erratum versus immediate spec reissue.

Only the first is architecture-level and potentially specimen-blocking.

### 4.4 One-sided omissions

Parent G omitted the STATUS-ledger fold-ins (`:attempt-indeterminate`, condition minting),
effect-set equality, axis-value membership, `:emptiness-rule-id`, and the explicit
standing-accessor law.

Parent F omitted the explicit no-Python transplantation rule and did not separate a
synthetic bounded-manifestation fixture from the contested call-296 evidence.

### 4.5 Unauthorized inventions

None is conclusively found.

Parent F's call-296 derivation is not labeled unauthorized because it is a serious attempt
to reason from closed vocabularies and the sealed projection. The synthesis rejects it on
logical and evidentiary grounds: absence of captured evidence does not by itself license
exhaustive elimination of every unrepresented manifestation possibility, and a singleton
exhaustive set collapses into the determinate definition under the current trichotomy.

## 5. Synthesis rule

The accompanying synthesis candidate uses this rule:

1. adopt all uncontested stronger clauses;
2. preserve delegated jurisdiction;
3. prefer the representation that produces fewer duplicated sources of truth;
4. treat a refusal/non-constructibility as safer than invented positive standing;
5. record every remaining owner fork explicitly;
6. do not call the result adopted until the owner and the second synthesis pass dispose of
   each fork.

## 6. Recommended relay question to Fable

The next Fable pass should answer, clause by clause:

- Does Fable accept that §7.3's “licenses one of” plus a singleton entails §7.2's
  “licenses exactly one,” absent an additional non-classical license relation?
- If not, what durable field makes eliminative-singleton standing inspectably distinct
  from determinate standing without adding a hidden fourth determinacy mode?
- Does Fable accept reference-based stream lineage if the referenced AP0 chunk records are
  mandatory and inspectable?
- Does Fable accept `:derived` as the origin of a new transformed claim, with the source's
  origin preserved in provenance rather than copied as the output origin?
- Does Fable accept a minimal procedure descriptor as authoritative, with reference-site
  class only a checked cache?
