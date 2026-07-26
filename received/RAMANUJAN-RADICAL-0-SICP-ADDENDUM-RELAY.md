# CLAUDE CODE RELAY — RAMANUJAN RADICAL /0, SICP ADDENDUM

**Date:** 2026-07-26  
**Repository:** `latent-lisp`  
**Project:** Lisp+ / Mneme  
**Target specimen:** Ramanujan Radical /0 (`RR/0`)  
**Commission:** integrate the SICP-derived architectural addenda below into the live RR/0 plan and implementation without widening RR/0 into a generic infinity system or reopening settled Lisp+/Mneme semantics.

## 0. Governing stance

This is an additive implementation commission, not a request for a fresh philosophical redesign.

Treat the live repository and its adopted owner records as the highest authority. Then consult, in order:

1. the live RR/0 work order, semantics, API, architecture, and closure documents;
2. `RAMANUJAN-RADICAL-0-IMPLEMENTATION-ROADMAP.md` dated 2026-07-24, if present;
3. this SICP addendum.

If a live adopted record conflicts with this relay, preserve the adopted record and report the conflict precisely. Do not silently overwrite settled semantics. Do not edit historical closure or adoption records as though they had always said the new thing.

RR/0 remains a **bounded successor probe**. It is not automatically Language Slice /2. It does not earn generic codata, a universal exact-real tower, a CAS, a theorem prover, a metacircular evaluator, or new reader/compiler syntax merely by succeeding.

The operative mathematical specimen remains:

\[
R_2=\sqrt{1+2\sqrt{1+3\sqrt{1+4\sqrt{1+\cdots}}}},
\]

with tail family

\[
R_n=\sqrt{1+nR_{n+1}},\qquad n\ge2,
\]

candidate exact tail

\[
C(n)=n+1,
\]

finite observation convention

\[
R_{N+1}^{(N,s)}=s,
\]

and backward evaluation from `n = N` through `n = 2`.

The local identity

\[
1+n(n+2)=(n+1)^2
\]

and the convergence estimate

\[
\left|R_2^{(N,s)}-3\right|
\le
\frac{6\,|s-(N+2)|}{(N+1)(N+2)}
\]

remain separate evidentiary objects. Neither may stand in for the other.

## 1. Entrance gate: do not interleave semantic frontiers

First determine whether SYNESIS /0 is still the active, unclosed work order.

If SYNESIS /0 is active and not explicitly parked or closed:

- do not begin RR/0 runtime implementation in the same worktree or session;
- you may inventory the RR/0 materials and prepare the additive SICP document in a clean separate worktree;
- stop before runtime changes and return an entrance-gate report.

If SYNESIS /0 is closed or RR/0 is already the active commissioned lane, proceed.

Do not merge to `main`. You may make bounded commits on the working branch and may push that branch after its gates pass. Preserve unrelated working-tree material exactly.

## 2. First actions: inspect before editing

Run and record, from the repository root:

```bash
pwd
git status --short --branch
git rev-parse HEAD
git rev-parse --show-toplevel
git log --oneline --decorate -20
find . \( -iname '*ramanujan*' -o -iname '*synesis*' \) -print | sort
find . \( -iname '*language-slice*' -o -iname '*architecture*' \) -print | sort
```

Then locate and read, without assuming paths:

- the RR/0 implementation roadmap;
- any RR/0 work order, semantics, API, architecture, package, test, fixture, mutant, evidence, or closure files;
- the currently governing Kernel /0, Slice /0, and Slice /1 public-surface records;
- the latest session index or handoff touching RR/0 or SYNESIS /0;
- package definitions and public smoke conventions used by the current tree.

Record:

- current branch and HEAD;
- merge base with `main`;
- whether RR/0 is absent, planned, in progress, or already closed;
- current SBCL and Python versions;
- the exact baseline commands named by the repository;
- all uncommitted files and whether they belong to this commission.

Do not guess baseline commands from old relays when the live tree names newer ones.

Run the governing baselines before changing RR/0. The older roadmap expected Kernel /0 standing `33/0/59`, but the live suite is authoritative. If expected and observed standing differ, stop and report rather than normalizing the discrepancy away.

## 3. The SICP graft in one sentence

RR/0 should become a small, stratified computational language for one infinite mathematical description:

```text
finite canonical description
    + explicit finite observation policy
    + exact bounded evaluation
    + separately typed mathematical warrants
    + replayable public account
```

The addendum imports five SICP disciplines and adds one Lisp+/Mneme discipline:

1. primitives, combination, and abstraction;
2. process shape distinct from procedure syntax;
3. conventional interfaces;
4. stratified design;
5. model succession rather than model laundering;
6. **means of warrant**: explicit conditions under which a computed result may support a durable claim.

This is not permission to build a Scheme clone or a generic evaluator. It is a sharper architecture for the existing specimen.

## 4. Required document: `RAMANUJAN-RADICAL-0-SICP-ADDENDUM.md`

Create this file beside the governing RR/0 documents, adapting only the top-level path to live repository convention.

Its status line must say that it is:

- additive;
- subordinate to adopted RR/0 semantics;
- non-promotional with respect to Language Slice /2;
- non-authoritative over Kernel /0, Slice /0, and Slice /1;
- binding for RR/0 implementation only once reconciled against the live tree.

Do not duplicate the whole roadmap. Link each addendum to the roadmap phase where it belongs.

The document must contain the following sections.

### 4.1 SICP-to-RR/0 correspondence

Record this mapping explicitly:

| SICP discipline | RR/0 realization | Scope boundary |
|---|---|---|
| primitive expressions | canonical radical descriptor, dyadic, closed interval, explicit policy fields | no arbitrary host closures in durable descriptors |
| means of combination | generated node law and backward fold | no generic stream/codata substrate |
| means of abstraction | spec, policy, observation, certificate, safe inspector | no new reader syntax or core special form |
| conventional interface | finite canonical node sequence and one-step numeric transition | no repo-wide sequence framework |
| process shape | iterative observer, explicit trace-space contract | no claim about bit-complexity unless separately analyzed |
| stratified design | description → observation → numeric evaluation → certificate → Mneme projection | no layer may borrow another layer's authority |
| model succession | structural prefix, finite evaluator, local invariant, convergence bound, final claim | later models refine; they do not erase earlier boundaries |
| means of warrant | procedure identity, assumptions, origin, replay inputs, certificates, structured `why` | Mneme records entitlement; it does not become the arithmetic engine |

Include these exact thesis sentences, or semantically equivalent wording:

- RR/0 describes an infinite pattern intensionally but observes it only through finite, explicit policies.
- The observer's process is iterative even though the object described is recursively defined.
- A local tail invariant is not a convergence theorem.
- Diagnostic decimal renderings are not authoritative inputs.
- The same printed interval is not the same evidentiary object when its procedure identity, assumptions, source policy, or replay lineage differs.
- Mneme records why a result is entitled to travel; it does not perform every arithmetic step.
- Generic codata remains deferred until at least two non-isomorphic specimens demonstrate the same missing abstraction.

### 4.2 Stratified architecture and dependency direction

Document five layers.

**Layer A — intensional description**

- `nested-radical-spec`;
- only the admitted sequence descriptors required by RR/0, initially `(:constant integer)` and `(:index)`;
- canonical identity independent of any particular observation request;
- constant retained descriptor size.

**Layer B — finite observation policy**

- `through-index`, never ambiguous `depth`;
- terminal interval placed at `N+1`;
- precision bits;
- outward rounding;
- trace mode;
- no silent defaults for through-index, terminal interval, precision, or rounding.

**Layer C — exact finite evaluator**

- dyadic/rational interval arithmetic;
- deterministic outward square-root enclosure;
- iterative backward fold;
- a pure one-node transition;
- no host float in the authoritative path.

**Layer D — mathematical warrants**

- local-tail-invariant certificate;
- truncation-convergence-bound certificate;
- cross-check preserving both numerical and analytic enclosures;
- explicit assumptions and checker identity;
- no certificate conflation.

**Layer E — Lisp+/Mneme projection**

- structured propositions;
- claims of origin `:derived`, not external-world `:observed`;
- admitted Slice /0 and Slice /1 public operations only;
- one persisted transformation receipt per requested observation, optionally referencing a deterministic trace identity;
- transported certificate remains testimony until target-local replay.

State dependency direction. Higher layers may consume the public account of lower layers. They may not inspect private representation merely because Common Lisp permits it. `slice-integration.lisp` must not become an alternate numeric evaluator. `certificates.lisp` must not reach into mutable trace internals. Renderers must not feed diagnostic decimals back into authoritative constructors.

### 4.3 Identity stratification

Specify identity fields by semantic level.

- **Spec identity:** descriptor version, start index, sequence descriptors, combination law, root law.
- **Prefix identity:** spec identity plus explicit through-index; no numeric precision.
- **Observation-policy identity:** through-index, terminal interval, precision bits, rounding, trace mode, policy version.
- **Observation identity:** spec identity, complete policy identity, numeric domain, observer procedure ID and version.
- **Trace identity:** observation identity plus trace representation/version; summary and full trace modes must not collide.
- **Certificate identity:** theorem/checker ID and version, exact assumptions, source observation family or policy, normalized symbolic objects or exact bound.
- **Claim identity:** structured proposition plus supporting artifact identities and origin.
- **Diagnostic rendering:** excluded from all authoritative identities.

Add collision tests for every controlling field. A change to any controlling field must either change identity or be documented as deliberately non-semantic.

### 4.4 Process-shape contract

Do not merely say “iterative.” State the resource shape in logical records:

- a radical spec retains `Θ(1)` descriptor records independent of requested prefix length;
- materializing nodes from start index through `N` retains exactly `N - start-index + 1` node records and therefore `Θ(N)` node space;
- the production observer uses `Θ(1)` host control-stack depth;
- full trace retains `Θ(N)` step records;
- summary trace retains a documented bounded summary state and must not first construct the full trace and discard it;
- the observer performs exactly `N - start-index + 1` radical transitions;
- terminal index is exactly `N+1`;
- precision-dependent integer sizes are explicit but are not disguised as constant bit complexity.

The implementation should make the process shape visible. Prefer one local fold with an explicit trace accumulator/sink over duplicated full-trace and summary-trace evaluators. This internal higher-order mechanism is allowed because it is runtime machinery, not a durable arbitrary closure embedded in the canonical descriptor.

Do not export a generic fold framework.

### 4.5 Model succession and proof boundary

Name the models and their jurisdictions:

1. **Rendered prefix:** establishes the declared finite structure only.
2. **Finite interval evaluator:** establishes an enclosure for one explicit truncation policy.
3. **Exact-tail fixture:** establishes a strong consistency control when terminal seed is `N+2`.
4. **Local invariant checker:** establishes that `C(n)=n+1` satisfies the recursive equation under the principal nonnegative root assumptions.
5. **Convergence checker:** establishes that the declared family of finite truncations approaches `3` under its terminal assumptions.
6. **Integrated limit claim:** requires the admitted conjunction of local and convergence support.

No later artifact may overwrite the earlier one. Preserve disagreements between the numerical interval and the analytic enclosure as data. A successful local invariant without convergence support must render a precise refused final derivation. A convergence estimate without the local identification of the candidate tail must also be insufficient for the exact final limit claim.

### 4.6 Wishful thinking followed by reckoning

SICP-style wishful thinking is allowed while designing interfaces, but every promised affordance must later be accounted for.

At RR/0 closure:

- every exported RR/0 symbol is exercised by a public-only smoke or explicitly justified as an introspection surface;
- every declared RR/0 condition has at least one real signal site and one fixture that reaches it;
- every required constructor has validation, canonical identity, and a negative test;
- every public semantic object has a safe renderer or inspector;
- no generated structure accessor is exported accidentally;
- no exported operation is “declared only”;
- no condition exists merely as decorative future tense;
- every deferred surface is named in closure rather than left as a false affordance.

This must be checked by executable local tooling, not only remembered in prose.

### 4.7 Generic arithmetic restraint

Record the negative design decision:

- do not build a numeric coercion tower;
- do not make host floats an accepted sibling representation;
- do not auto-coerce decimal diagnostics into dyadics or exact claims;
- do not install a broad operation/type table merely for the two descriptor forms RR/0 needs;
- use explicit tagged descriptor validation now;
- revisit data-directed extension only when a second mathematical specimen creates real additive pressure.

The lesson from generic arithmetic is additivity without pretending that the dispatch geometry is the ontology.

## 5. Required executable artifact: the RR/0 semantic coverage ledger

Create one small machine-readable registry and one checker. Adapt names to local convention, but keep the scope local to RR/0. Suggested artifacts:

```text
fixtures/RR0-SEMANTIC-COVERAGE.sexp
tests/check-semantic-coverage.lisp
evidence/SEMANTIC-COVERAGE-AUDIT.md
```

This is not a new repository-wide governance platform. One registry, one checker, one generated report. Do not build a framework.

The ledger must contain rows for at least:

- radical family descriptor;
- each admitted sequence descriptor;
- radical observation policy;
- materialized prefix/node representation;
- dyadic;
- closed interval;
- square-root enclosure;
- observation result;
- full trace;
- summary trace;
- local-tail-invariant certificate;
- convergence-bound certificate;
- integrated limit claim;
- every RR/0 public operation;
- every RR/0 typed condition.

Use explicit statuses such as:

```text
:implemented
:derived
:intentionally-internal
:not-applicable
:deferred
:missing
```

No blank cell.

Columns must cover, where applicable:

- constructor or producer;
- validator;
- canonical identity;
- renderer/inspector;
- authoritative semantic rule;
- positive fixture;
- refusal/negative fixture;
- property test;
- differential check;
- mutant/control;
- public export disposition;
- public-smoke exercise;
- replay path;
- closure disposition.

The checker must cross-check at least:

1. actual package exports against ledger public rows;
2. declared RR/0 conditions against registered signal fixtures;
3. required operations from the governing API against implemented or explicitly deferred rows;
4. public smoke references against every required public row;
5. absence of `:missing` in closure-mandatory rows.

The generated audit must distinguish:

- mechanically checked facts;
- manually declared dispositions;
- not-yet-checkable claims.

Do not pretend that a registry entry proves runtime behavior.

## 6. Required implementation refinement: one pure node transition

Make the one-node numerical transformation explicit and pure inside the RR/0 implementation.

Conceptually:

```text
incoming tail interval
    + node index
    + canonical offset/coefficient values
    + precision and numeric procedure identity
        ↓
radicand interval
        ↓
outward square-root enclosure
        ↓
outgoing tail interval + step account
```

Do not collide with any existing public inspector named `radical-observation-step`. Choose a private name consistent with the live package.

Requirements:

- no mutation of the incoming interval;
- no hidden lookup of a default precision or terminal;
- exact offset and coefficient values retained in a full step account;
- numeric procedure ID/version retained;
- the production observer composes this transition iteratively;
- certificates may inspect a stable public account, not private mutable implementation state.

Keep this internal unless the live API already has an admitted reason to expose it.

## 7. Required test-only second formulation

Add one **test-only structural reference route**:

```text
canonical descriptor
    → materialize finite nodes 2..N
    → consume those nodes backward from explicit terminal N+1
    → exact interval result
```

It must not call the production observer loop. It may share the already-tested dyadic and square-root primitives; therefore it is not an independent numerical oracle. Its jurisdiction is narrower:

- catches structural interpretation defects;
- catches node-order defects;
- catches terminal-placement defects;
- checks agreement between “materialize then fold” and “fused generated fold.”

The clean-room Python implementation remains the independent numeric oracle.

Compare, over deterministic fixtures:

- result interval;
- node count;
- transition indexes;
- terminal index;
- exact-tail behavior;
- relevant identities.

Do not export the reference route. Do not preserve it as a second production engine after the tests no longer need it.

## 8. Trace-mode implementation

Use one observer and explicit trace collection policy.

A satisfactory internal architecture is:

```text
validated spec + validated policy
       ↓
iterative backward fold
       ↓
pure node transition
       ↓
trace collector chosen from explicit trace mode
       ↓
observation + trace account
```

For `:full`, retain each canonical step in deterministic index order.

For `:summary`, retain only the documented bounded summary fields, such as:

- transition count;
- first and last transition indexes;
- terminal index;
- final result interval;
- full replay-input identity;
- deterministic trace digest through an already admitted canonical hashing facility.

Do not add a new cryptographic dependency solely for this addendum. Use an existing admitted canonical digest facility. If none exists, bind the canonical replay-input identity and clearly mark any local checksum as non-authoritative until the project supplies an admitted digest.

The summary path must update summary state during the fold. It may not call full mode and throw the list away.

## 9. Public-surface reckoning

Add or extend the RR/0 package audit so closure can prove:

```text
zero `::`
zero accidental defstruct accessor exports
zero internal constructors in public smoke
zero direct registry mutation
zero unsafe receipt mutation
zero host floats in authoritative numeric files
zero silent policy defaults
zero exported RR/0 symbols absent from the coverage ledger
zero declared RR/0 conditions without a reachable fixture
```

Every RR/0 public smoke program must run in a fresh process using exports only.

The public smoke should demonstrate, at minimum:

1. construction of the canonical Ramanujan descriptor;
2. rendering/materializing the first five nodes;
3. terminal-0 observation through `N=20`;
4. exact interval rendering and separate decimal diagnostic rendering;
5. full versus summary trace agreement on the numeric result;
6. local-invariant certificate;
7. convergence-bound certificate;
8. final claim with both supports;
9. structured `why` for one successful derivation;
10. structured `why` for local-invariant-only refusal;
11. structured `why` for convergence-only refusal;
12. typed refusal when terminal policy is omitted;
13. canonical replay producing byte-identical authoritative data in a fresh process.

Do not bloat the public package to make the smoke convenient. Improve safe public inspectors instead.

## 10. Mutants and controls

Preserve the existing RR-M01 through RR-M14 identities and intended kills. Do not renumber them.

Append the following only when each can be killed deterministically:

- **RR-M15 — summary path constructs the full trace before summarizing.**  
  Required kill: a deterministic test hook or collector-level control demonstrating that summary mode follows the bounded collector path. Do not use flaky wall-clock or process-RSS thresholds.

- **RR-M16 — unexercised dummy export is added to the RR/0 package.**  
  Required kill: semantic coverage/public-surface audit.

- **RR-M17 — a new RR/0 condition is declared without a registered reachable signal fixture.**  
  Required kill: condition-coverage audit.

- **RR-M18 — convergence certificate alone mints the exact limit claim.**  
  Required kill: final-claim premise law and structured refusal test.

If RR-M15 cannot be made deterministic without invasive test-only machinery, do not fake a mutant score. Keep the process-shape property as explicit code architecture plus direct tests, and report that the proposed mutant was not responsibly admitted.

## 11. Phase integration

Do not create a competing eight-phase roadmap. Attach the addenda to the existing phases.

- **Phase 0:** addendum document, live-surface inventory, coverage-ledger skeleton.
- **Phase 1:** semantic identity stratification and oracle fixture fields.
- **Phase 2:** finite node conventional interface and test-only materialize-then-fold route.
- **Phase 3:** numeric abstraction barrier and no-coercion decision.
- **Phase 4:** pure node transition, iterative process-shape contract, trace collectors, full/summary agreement.
- **Phase 5:** explicit model succession; local and convergence evidence remain orthogonal supports.
- **Phase 6:** means-of-warrant projection through admitted Slice /0 and /1 surfaces; no arithmetic migration into Mneme.
- **Phase 7:** executable reckoning, appended mutants, public smoke, generated coverage report, exact claim/nonclaim closure.

The planning/addendum pass must stay bounded. It should not delay movement into the mathematical implementation by turning into another constitutional season.

## 12. Post-RR/0 docket, not implementation

Create a short document:

```text
RAMANUJAN-ENGINE-NPLUS1-DOCKET.md
```

Mark it non-governing and post-RR/0.

Record the larger SICP-inspired research direction without implementing it now:

- exact finite approximant families;
- continued fractions as the preferred second non-isomorphic specimen;
- power-series or another generated analytic family as a later specimen;
- first-class but canonical transformation descriptors;
- sequence transformations and convergence accelerators;
- symbolic identities;
- exact interval computation;
- conjecture generation as proposal, never proof;
- distinct evidence accounts for numerical agreement, symbolic normalization, admitted derivation, analytic convergence, and machine-checked proof;
- no compression of those distinctions into one persuasive scalar “confidence” grade.

Carry forward the existing promotion gates for generic suspension/codata:

1. at least two non-isomorphic specimens require it;
2. durable descriptors contain no arbitrary host closure;
3. guardedness/productivity has an executable or sharply bounded contract;
4. finite observation remains explicit;
5. unbounded forcing refuses rather than hangs;
6. memoization identity and concurrency semantics are specified;
7. serialization does not pretend to serialize live continuations;
8. the abstraction removes duplicated semantics rather than decorating one specimen.

Explicitly docket, but do not implement:

- `later`;
- `force`;
- `corec`;
- generic lazy streams;
- generic exact reals;
- general symbolic algebra;
- automated theorem discovery;
- a general proof assistant;
- a metacircular or explicit-control evaluator;
- a native compiler or register-machine backend;
- Language Slice /2.

## 13. Non-negotiable exclusions

Do not:

- reopen Kernel /0, Slice /0, or Slice /1 semantics;
- modify existing slice tests merely to accommodate RR/0;
- use package-internal `::` access;
- merge to `main`;
- replace exact arithmetic with host floats;
- allow decimal display values to re-enter exact constructors;
- silently choose terminal seed `0`;
- call the terminal at `N` instead of `N+1`;
- use the local invariant as a convergence proof;
- overwrite the numerical enclosure with the analytic enclosure;
- journal every arithmetic step through Mneme;
- build a generic stream/codata layer on the RR/0 critical path;
- build a generic operation/type table for hypothetical future forms;
- export every generated accessor;
- manufacture a green baseline by weakening older tests;
- create a large general audit framework from the local coverage ledger;
- turn the addendum into an essay-only artifact while leaving its false-affordance checks unimplemented.

## 14. Commit discipline

Prefer small, causally legible commits. Adapt labels to actual progress:

```text
rr0 addendum 0: record SICP-derived architecture and scope boundaries
rr0 addendum 1: add executable semantic and public-surface coverage ledger
rr0 addendum 2: expose pure node transition and test structural dual-route agreement
rr0 addendum 3: enforce iterative trace collectors and process-shape contracts
rr0 addendum 4: docket post-RR0 Ramanujan engine pressures without widening RR0
```

Do not make empty commits for phases not reached.

For each commit:

- run the narrow relevant tests;
- record exact commands and status;
- keep unrelated files untouched;
- show the diff stat;
- show the commit hash;
- preserve a clean worktree or explain every remaining path.

A push of the working branch is authorized after its gates pass. A merge into `main` is not.

## 15. Stop conditions

Stop and report instead of improvising when:

- SYNESIS /0 is still active and the lanes would interleave;
- the baseline is red before RR/0 changes;
- live adopted semantics contradict the mathematical contract in this relay;
- completing the addendum would require changing Kernel /0 or an admitted Slice surface;
- the current worktree contains unowned changes that cannot be safely separated;
- the interval algorithm cannot establish outward enclosure;
- a summary-space mutant cannot be killed deterministically;
- the Python oracle and Common Lisp result disagree and the source of disagreement is not yet isolated;
- a public operation requires internal package access to work;
- the final limit claim can be produced from only one of the two required certificate classes.

Return the exact condition, source location, command, output, and smallest next repair. Do not turn a blocker into a speculative redesign.

## 16. Required final handoff

Return one detailed handoff with this exact skeleton:

```text
RAMANUJAN RADICAL /0 — SICP ADDENDUM HANDOFF

ENTRY GATE
- SYNESIS /0 status:
- RR/0 live status:
- branch/worktree:
- starting HEAD:
- merge base:
- pre-existing changes:

BASELINE
- commands:
- expected standing:
- observed standing:
- preserved transcripts:

ADJUDICATION
- addenda adopted:
- addenda adapted:
- addenda docketed:
- addenda refused, with reasons:
- conflicts with live governing records:

ARTIFACTS
- documents created/changed:
- runtime files created/changed:
- test/fixture files:
- coverage-ledger files:
- evidence outputs:
- post-RR/0 docket:

SEMANTIC RESULT
- description layer:
- observation-policy layer:
- numeric layer:
- certificate layer:
- Mneme projection layer:
- identity fields:
- process-shape contract:
- final claim premises:

PUBLIC SURFACE
- exports added:
- exports removed:
- exports exercised:
- declared conditions:
- conditions behaviorally reached:
- `::` count:
- accidental accessor count:

VALIDATION
- unit tests:
- property tests:
- Python differential vectors:
- materialize-vs-fused agreement:
- full-vs-summary agreement:
- refusal vectors:
- certificate vectors:
- public smoke:
- package audit:
- static float/default scan:
- mutation score:

COMMITS
- hashes and subjects:
- pushed branch:
- final tree:
- final worktree status:

CLAIMS EARNED
- ...

CLAIMS NOT EARNED
- generic codata:
- general exact reals:
- general CAS:
- theorem discovery/proof assistant:
- Language Slice /2:
- crash/durability claims not already admitted:

OPEN FINDINGS
- ...

NEXT SINGLE INSTRUCTION
- ...
```

Do not answer with a broad retrospective in place of the handoff. The value of this commission is an inhabited mathematical specimen whose abstractions, process shape, and warrants can all be inspected from the public surface.

The spirit is: build the organism, keep its membranes visible, and do not let a beautiful `3.0` counterfeit a theorem.
