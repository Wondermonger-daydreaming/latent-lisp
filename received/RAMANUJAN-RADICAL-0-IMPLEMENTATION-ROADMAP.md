# RAMANUJAN RADICAL /0 — IMPLEMENTATION ROADMAP

**Status:** Proposed bounded successor probe for Lisp+  
**Date:** 2026-07-24  
**Primary implementation host:** Common Lisp / SBCL  
**Proposed branch:** `codex/ramanujan-radical-0`  
**Recommended repository location:** `experiments/latent-lisp/mneme/successor-probes/ramanujan-radical-0/`  
**Standing:** This probe is not automatically Language Slice /2. It must earn promotion through the specimen and public-surface evidence described below.

---

## 0. Program ruling

### Primary milestone

Implement one exact, deterministic, bounded observer for the generated nested radical

\[
R_2=\sqrt{1+2\sqrt{1+3\sqrt{1+4\sqrt{1+\cdots}}}},
\]

with explicit truncation, terminal-boundary, numeric-domain, precision, and rounding policies.

### Critical-path decision

Do **not** make generic codata, a universal exact-real package, a general computer-algebra system, or new compiler syntax prerequisites. The first implementation is a pure Lisp+ library specimen built from:

1. a finite generated prefix;
2. a backward fold;
3. exact dyadic/rational interval arithmetic;
4. a separately checked local invariant;
5. a separately checked convergence bound;
6. optional Slice /0 and Slice /1 claims, receipts, and structured `why` at the durable boundary.

### Optional parallel lane

Build a clean-room Python oracle and vector generator that shares only the frozen semantic document and fixtures with the Common Lisp implementation. It must not be imported by the Lisp runtime and must not share the Lisp implementation's interval code.

### Explicit deferrals

The following are out of scope for RR/0:

- generic lazy lists or streams;
- language-level guarded corecursion;
- automatic productivity checking;
- arbitrary user closures in canonical radical descriptors;
- arbitrary signed-coefficient nested radicals;
- complex square roots;
- a general algebraic-number tower;
- transcendental exact reals;
- automatic theorem discovery;
- a general proof assistant;
- journaling every arithmetic step through Mneme;
- promoting the probe to Language Slice /2 before it passes its closure gates.

### Exact claim ceiling

RR/0 may establish that Lisp+ can:

- canonically describe this generated infinite pattern;
- inspect any finite prefix without allocating an infinite tree;
- evaluate a declared finite truncation by exact outward-rounded interval arithmetic;
- refuse an observation whose boundary policy is absent or invalid;
- preserve the distinction between a self-consistent tail solution and convergence of a truncation protocol;
- derive and replay evidence that the fixed-seed truncations converge to `3` under the stated assumptions.

RR/0 does **not** establish a complete semantics of all infinite Lisp+ values.

---

## 1. Mathematical contract

Define the formal tail family

\[
R_n=\sqrt{1+nR_{n+1}}, \qquad n\ge 2.
\]

The proposed exact tail is

\[
C(n)=n+1.
\]

The local invariant is

\[
1+nC(n+1)=1+n(n+2)=(n+1)^2,
\]

hence

\[
\sqrt{1+nC(n+1)}=C(n)
\]

for `n >= 2` under the nonnegative square-root branch.

A finite observation is parameterized by a through-index `N` and a terminal seed `s` placed at index `N+1`:

\[
R_{N+1}^{(N,s)}=s,
\]

\[
R_n^{(N,s)}=\sqrt{1+nR_{n+1}^{(N,s)}}
\quad\text{for}\quad n=N,N-1,\ldots,2.
\]

The convergence checker uses

\[
\left|\sqrt{1+nx}-\sqrt{1+n(n+2)}\right|
\le \frac{n}{n+2}|x-(n+2)|
\]

for `x >= 0`, giving

\[
\left|R_2^{(N,s)}-3\right|
\le
\frac{6\,|s-(N+2)|}{(N+1)(N+2)}.
\]

For terminal seed `s = 0`, this simplifies to

\[
\left|R_2^{(N,0)}-3\right|\le \frac{6}{N+1}.
\]

The implementation must treat these as two different evidentiary objects:

- **local-tail-invariant:** `C` satisfies the recursive equation;
- **truncation-convergence-bound:** the declared finite-observation family approaches `C(2)=3`.

Neither record may silently substitute for the other.

---

## 2. Semantic objects and provisional public API

The names below are provisional until reconciled with the current admitted Lisp+ package surface. The semantic distinctions are not provisional.

### 2.1 Radical family descriptor

A durable descriptor contains no arbitrary host closure.

```lisp
(nested-radical-spec
  :spec-version 0
  :spec-id ramanujan-radical/0
  :start-index 2
  :offset-sequence (:constant 1)
  :coefficient-sequence (:index)
  :combination-law :offset-plus-coefficient-times-tail
  :root-law :principal-nonnegative-square-root)
```

For RR/0, only `(:constant integer)` and `(:index)` sequence descriptors are required. Do not build a universal sequence language merely because one could.

### 2.2 Observation policy

Use `through-index`, not the ambiguous word `depth`.

```lisp
(radical-observation-policy
  :policy-version 0
  :through-index 20
  :terminal-interval (:closed (:dyadic 0 0) (:dyadic 0 0))
  :precision-bits 128
  :rounding :outward
  :trace-mode :full)
```

Required fields:

- through-index `N`;
- terminal interval at `N+1`;
- precision in bits;
- outward-rounding declaration;
- trace mode.

There must be no silent defaults for the first four fields.

### 2.3 Observation result

```lisp
(radical-observation
  :observation-version 0
  :spec-id ...
  :policy-id ...
  :procedure-id observe-nested-radical/0
  :numeric-domain dyadic-interval/0
  :start-index 2
  :through-index 20
  :node-count 19
  :terminal-index 21
  :result-interval ...
  :trace-id ...
  :determinism :exact
  :claim-origin :derived)
```

The term “observation” here means a bounded view of an infinite description. A claim about its numeric result has origin `:derived`, not external-world `:observed`.

### 2.4 Required operations

```lisp
(make-nested-radical-spec ...)
(make-radical-observation-policy ...)
(render-radical-prefix spec :through-index n)
(observe-nested-radical spec policy)
(radical-observation-step observation index)
(check-ramanujan-local-invariant :symbolic t)
(make-ramanujan-convergence-bound policy)
(check-observation-against-bound observation bound)
(render-radical-why object)
```

### 2.5 Required typed conditions

At minimum:

```text
unbounded-radical-observation
missing-radical-boundary-policy
invalid-through-index
invalid-terminal-interval
negative-radicand-enclosure
unsupported-radical-sequence-descriptor
unsupported-radical-numeric-domain
invalid-precision
interval-invariant-violation
sqrt-enclosure-failure
noncanonical-radical-descriptor
radical-certificate-assumption-missing
radical-certificate-result-mismatch
```

An attempt to request “the value of the infinite radical” without an observation policy must refuse with a typed condition. Hanging forever is not an implementation of infinity; it is merely a process having a bad afternoon.

---

## 3. Recommended repository layout

```text
experiments/latent-lisp/mneme/successor-probes/ramanujan-radical-0/
├── RAMANUJAN-RADICAL-0-WORK-ORDER.md
├── RAMANUJAN-RADICAL-0-SEMANTICS.md
├── RAMANUJAN-RADICAL-0-API.md
├── RAMANUJAN-RADICAL-0-ARCHITECTURE.md
├── RAMANUJAN-RADICAL-0-CLOSURE.md
├── package.lisp
├── radical-spec.lisp
├── radical-prefix.lisp
├── dyadic.lisp
├── interval.lisp
├── sqrt-enclosure.lisp
├── observer.lisp
├── certificates.lisp
├── slice-integration.lisp
├── render.lisp
├── specimens/
│   ├── ramanujan-radical.lisp
│   └── public-smoke.lisp
├── tests/
│   ├── run-tests.lisp
│   ├── test-dyadic.lisp
│   ├── test-interval.lisp
│   ├── test-sqrt-enclosure.lisp
│   ├── test-prefix.lisp
│   ├── test-observer.lisp
│   ├── test-certificates.lisp
│   ├── test-slice-integration.lisp
│   └── test-public-surface.lisp
├── mutants/
│   ├── MUTATION-REGISTRY.sexp
│   └── run-mutants.lisp
├── oracle/
│   ├── generate_vectors.py
│   ├── verify_vectors.py
│   └── README.md
├── fixtures/
│   ├── RADICAL-FIXTURE-REGISTRY.sexp
│   ├── observation-vectors.sexp
│   ├── refusal-vectors.sexp
│   └── certificate-vectors.sexp
└── evidence/
    ├── BASELINE-TRANSCRIPT.txt
    ├── REFERENCE-TRANSCRIPT.txt
    ├── DIFFERENTIAL-TRANSCRIPT.txt
    ├── MUTATION-SCORECARD.md
    ├── PUBLIC-SURFACE-AUDIT.md
    ├── FINAL-VALIDATION-TRANSCRIPT.txt
    └── SHA256SUMS.txt
```

Adjust only the top-level path if the current repository has a stronger local convention. Keep the internal decomposition.

---

## 4. Numeric substrate

### 4.1 Dyadic representation

Represent a dyadic as

\[
m\,2^e
\]

with arbitrary-precision integer `m` and integer exponent `e`.

Canonical normalization:

- zero is always `(0, 0)`;
- for nonzero `m`, repeatedly divide `m` by `2` and increment `e` until `m` is odd;
- equality is mathematical equality after normalization;
- no host float enters the authoritative path.

At a durable boundary, encode a dyadic as an inert Canonical Datum record or as a reduced rational. Do not revise Canonical Datum /0 merely to add a privileged dyadic atom.

### 4.2 Closed intervals

```lisp
(closed-interval :lower dyadic-or-rational :upper dyadic-or-rational)
```

Invariants:

- endpoints are exact;
- `lower <= upper`;
- interval constructors validate rather than repair reversed endpoints;
- every arithmetic operation is inclusion-monotone;
- outward rounding is explicit in the procedure identity.

RR/0 needs only:

- point intervals;
- interval addition;
- multiplication by a nonnegative integer;
- intersection for cross-checking, never for concealing disagreement;
- width and containment;
- square-root enclosure.

### 4.3 Deterministic square-root enclosure

For a nonnegative rational endpoint `q` and requested precision `p`, produce dyadic bounds with denominator `2^p`.

For a lower endpoint `L`:

```text
A = floor(L * 2^(2p))
lo_m = isqrt(A)
lo = lo_m / 2^p
```

For an upper endpoint `U`:

```text
B = ceil(U * 2^(2p))
hi_m = ceil_isqrt(B)
hi = hi_m / 2^p
```

where:

```text
ceil_isqrt(k) = r       when r*r = k
                r + 1   otherwise
and r = isqrt(k)
```

Then

```text
sqrt([L,U]) is enclosed by [lo,hi].
```

Requirements:

- use exact integer arithmetic only;
- reject any interval whose lower endpoint is negative;
- return exact point intervals for exact dyadic perfect squares where representable;
- include the precision and procedure version in every result identity;
- never round both endpoints inward;
- do not silently clamp a negative lower bound to zero.

---

## 5. Backward observer algorithm

Use an iterative fold to avoid host-stack dependence.

```text
input: spec, policy
validate spec and policy
N := policy.through-index
require N >= spec.start-index
current := policy.terminal_interval
trace := []

for n from N downto spec.start_index:
    offset := sequence_value(spec.offset_sequence, n)
    coefficient := sequence_value(spec.coefficient_sequence, n)
    require coefficient >= 0
    radicand := point(offset) + coefficient * current
    next := sqrt_enclose(radicand, policy.precision_bits)
    append step(n, current, radicand, next) to trace
    current := next

return observation(current, trace, identities...)
```

The terminal seed belongs to index `N+1`. An implementation that attaches it to `N` has committed an off-by-one semantic defect, not a harmless formatting choice.

The trace must retain:

- current coefficient index;
- incoming tail interval;
- offset and coefficient values;
- radicand interval;
- outgoing square-root interval;
- numeric procedure identity.

A summary trace may omit individual steps only by explicit policy and must bind the digest of the full deterministic replay inputs.

---

## 6. Phased implementation plan

## Phase 0 — Authorization, baseline, and surface inventory

**Goal:** Open a bounded branch without changing existing Slice /0 or Slice /1 semantics.

### Tasks

1. Create a clean worktree from freshly fetched `main`.
2. Create branch `codex/ramanujan-radical-0`.
3. Record commit, tree, merge base, SBCL version, Python version, and exact baseline commands.
4. Run and preserve the currently governing suites:
   - Kernel /0 expected standing `33/0/59`;
   - complete Slice /0 suites and smoke;
   - complete Slice /1 suites, ablations, smoke, package export audit, and static public-surface checks.
5. Inventory only the admitted public symbols needed from Slice /0 and Slice /1.
6. Write `RAMANUJAN-RADICAL-0-WORK-ORDER.md` with this scope and claim ceiling.
7. Add no runtime code yet.

### Exit gate

- baseline is green;
- branch and worktree are clean;
- exact public dependencies are named;
- no `::` or internal package dependency is planned;
- owner implementation authorization is present.

### Suggested commit

```text
rr0 step 0: freeze scope, baseline, and public dependency inventory
```

---

## Phase 1 — Freeze semantics and build the independent oracle

**Goal:** Make the expected behavior decidable before the Common Lisp implementation exists.

### Tasks

1. Write `RAMANUJAN-RADICAL-0-SEMANTICS.md` containing:
   - the recursive family;
   - the exact truncation convention;
   - terminal index `N+1`;
   - the principal nonnegative root;
   - local-invariant statement;
   - convergence-bound statement;
   - allowed and refused policy shapes;
   - identity fields;
   - explicit non-goals.
2. Implement `oracle/generate_vectors.py` using only:
   - Python integers;
   - `fractions.Fraction`;
   - `math.isqrt`;
   - an independently written interval implementation.
3. Generate deterministic vectors for:
   - `N = 2, 3, 4, 5, 10, 20, 50`;
   - terminal seeds `0, 1, 3, 100`;
   - precision `16, 32, 64, 128`;
   - exact-tail terminal `N+2`;
   - invalid policies and negative terminal intervals.
4. Include familiar decimal renderings only as non-authoritative diagnostics. Exact interval endpoints are authoritative.
5. Hash every fixture and record the generator identity.
6. Add a second Python verifier that reads the vectors but does not import the generator module.

### Required diagnostic values

For terminal seed `0`, the decimal display should include approximately:

```text
N=5   -> 2.559830165300118...
N=10  -> 2.980553750211820...
N=20  -> 2.999976103083385...
N=50  -> 2.999999999999972...
```

These displays are smoke clues, not canonical evidence.

### Exit gate

- semantic document is internally complete;
- generator and verifier agree;
- vectors are deterministic across two runs;
- no Common Lisp implementation has contaminated the oracle lane.

### Suggested commit

```text
rr0 step 1: freeze finite-observation semantics and independent vectors
```

---

## Phase 2 — Implement structural description before numeric evaluation

**Goal:** Prove that Lisp+ can describe and finitely inspect the pattern without pretending to possess an infinite tree.

### Tasks

1. Implement canonical sequence descriptors `(:constant k)` and `(:index)`.
2. Implement `nested-radical-spec` validation and identity.
3. Implement `render-radical-prefix` and `materialize-radical-prefix` for a finite through-index.
4. Return a finite canonical sequence of nodes:

```lisp
((:index 2 :offset 1 :coefficient 2)
 (:index 3 :offset 1 :coefficient 3)
 ...)
```

5. Add refusal for unsupported descriptors and unbounded materialization.
6. Add prefix tests for `N=2, 3, 5, 20`.
7. Add one public-only specimen that creates the spec and renders five nodes without internal symbols.

### Exit gate

- the spec allocates constant space independent of requested prefix length;
- finite materialization allocates exactly the requested finite prefix;
- unbounded materialization refuses;
- descriptor identity is stable and canonical.

### Suggested commit

```text
rr0 step 2: implement canonical generated radical descriptions and finite prefixes
```

---

## Phase 3 — Implement dyadic intervals and square-root enclosure

**Goal:** Establish the exact numerical substrate before composing the radical evaluator.

### Tasks

1. Implement normalized dyadics.
2. Implement exact comparison and reduced-rational conversion.
3. Implement closed intervals and invariants.
4. Implement addition and nonnegative integer scaling.
5. Implement deterministic outward `sqrt-enclose`.
6. Test perfect squares, nonsquares, zero, very large integers, narrow intervals, and invalid negative intervals.
7. Differentially compare every test vector with the Python oracle.
8. Record operation identities and precision in all returned values.

### Mandatory properties

- `lower <= sqrt(x) <= upper` for point inputs;
- interval inclusion is preserved;
- increasing precision never widens a point-input enclosure except where representation normalization is identical;
- exact perfect squares remain exact;
- no float is reachable from the authoritative package surface.

### Exit gate

- all dyadic, interval, and sqrt tests pass;
- differential vectors agree;
- float-use static scan is clean for the authoritative path;
- inward-rounding mutant is killed.

### Suggested commits

```text
rr0 step 3a: implement exact dyadics and closed intervals
rr0 step 3b: implement deterministic outward square-root enclosure
```

---

## Phase 4 — Implement the bounded radical observer

**Goal:** Compose the generated structure and numeric substrate into one honest finite evaluator.

### Tasks

1. Implement policy construction and canonical identity.
2. Implement the backward fold.
3. Implement full and summary traces.
4. Include `start-index`, `through-index`, `terminal-index`, and `node-count` explicitly.
5. Refuse missing terminal, missing precision, unsupported rounding, and invalid bounds.
6. Differentially replay all oracle vectors.
7. Add exact-tail tests using terminal `N+2`, which must produce point interval `3` at the root.
8. Add terminal-seed convergence tables for `0, 1, 3, 100`.
9. Ensure result identity changes when any controlling policy field changes.

### Exit gate

- all valid vectors match or are tighter than the authoritative oracle enclosure while remaining sound;
- all refusal vectors signal the named condition;
- fold-left, off-by-one, and coefficient-shift mutants are killed;
- public observation requires no internal package access.

### Suggested commit

```text
rr0 step 4: implement bounded backward radical observation with explicit policy
```

---

## Phase 5 — Implement local-invariant and convergence certificates

**Goal:** Prevent “algebraically self-consistent” from masquerading as “the truncation limit.”

### Tasks

1. Implement a tiny univariate integer-polynomial normalizer sufficient to check:

```text
1 + n(n + 2) = (n + 1)^2
```

as coefficient equality. Keep it local to the certificate package; do not advertise a general CAS.
2. Emit a `local-tail-invariant-certificate` containing:
   - variable and domain assumptions;
   - normalized left and right polynomials;
   - equality result;
   - principal-root nonnegativity premise;
   - procedure identity.
3. Implement `ramanujan-convergence-bound` for nonnegative terminal point or interval seeds.
4. Emit the exact rational bound

```text
6 * max-distance(terminal, N+2) / ((N+1)(N+2))
```

without decimals.
5. Implement a cross-check that compares the backward-evaluation interval with the analytic `[3-E, 3+E]` enclosure.
6. Do not replace one enclosure with the other. Preserve both and report disagreement.
7. Refuse the convergence certificate when the nonnegative-terminal assumption is absent.
8. Add a proof-boundary test showing that the local invariant alone cannot mint a convergence claim.

### Exit gate

- symbolic local invariant passes;
- convergence bounds are exact and replayable;
- missing-assumption and certificate-conflation mutants are killed;
- evaluator and analytic checker remain independently inspectable.

### Suggested commit

```text
rr0 step 5: separate local fixed-tail evidence from truncation convergence
```

---

## Phase 6 — Integrate with Slice /0 and Slice /1 without changing them

**Goal:** Use existing claim, promotion, projection, derivation, and `why` machinery as consumers of RR/0 results.

### Tasks

1. Use only admitted Slice /0 and Slice /1 exports.
2. Represent structured propositions such as:

```lisp
(radical-spec-valid ramanujan-radical/0)
(observation-policy-complete policy-id)
(radical-observation-encloses observation-id lower upper)
(local-tail-invariant ramanujan-radical/0 candidate-tail/0)
(truncation-bound observation-family-id epsilon)
(limit-value ramanujan-radical/0 3)
```

3. Add exact judgment schemas for:
   - policy completeness;
   - finite observation derivation;
   - local-tail invariant;
   - convergence-bound applicability;
   - final limit claim requiring both local and convergence premises.
4. Ensure a missing terminal assumption yields a structured premise assessment and `why` output.
5. Ensure a host-float approximation cannot be promoted into the exact result claim merely because it prints `3.0`.
6. Ensure a transported certificate remains transported testimony until target-local replay verifies it.
7. Persisted claims must record origin `:derived`, procedure identity, source spec, policy, fixtures, and bounded unknowns.
8. Do not journal each arithmetic step through Mneme. Persist one transformation receipt for a requested observation, optionally referencing the deterministic trace digest.

### Exit gate

- existing Slice /0 and Slice /1 suites remain unchanged and green;
- RR/0 public smoke uses zero `::`;
- every claim can render structured `why`;
- no standing inflation occurs;
- Mneme remains the evidence layer rather than the arithmetic engine.

### Suggested commit

```text
rr0 step 6: integrate radical observations with public claim and derivation surfaces
```

---

## Phase 7 — Adversarial hardening and public closure

**Goal:** Demonstrate that the suite has teeth and that a stranger can use the public surface.

### Required mutants

| ID | Mutation | Required kill |
|---|---|---|
| RR-M01 | coefficient is `n+1` | vector mismatch |
| RR-M02 | offset is `0` | vector mismatch |
| RR-M03 | fold ascends from `2` to `N` | vector mismatch |
| RR-M04 | terminal seed attached at `N` rather than `N+1` | identity/vector mismatch |
| RR-M05 | host `sqrt` float path used | static/differential failure |
| RR-M06 | upper endpoint rounded inward | enclosure property failure |
| RR-M07 | terminal silently defaults to `0` | missing-policy refusal failure |
| RR-M08 | precision omitted from observation identity | identity-collision failure |
| RR-M09 | local invariant alone mints limit claim | premise-law failure |
| RR-M10 | analytic bound overwrites numerical result | evidence-separation failure |
| RR-M11 | negative terminal interval accepted | domain-condition failure |
| RR-M12 | unbounded prefix allocation attempted | bounded-observation failure |
| RR-M13 | procedure version omitted from result identity | replay-identity failure |
| RR-M14 | transported certificate promoted to target-local verification | standing-inflation failure |

### Public smoke program

The smoke program must use exported symbols only and demonstrate:

1. construction of the Ramanujan descriptor;
2. rendering of the first five nodes;
3. a terminal-0 observation through `N=20`;
4. exact interval output and decimal diagnostic rendering;
5. a local invariant certificate;
6. a convergence-bound certificate;
7. derivation of the bounded limit claim;
8. structured `why` for one successful and one refused derivation;
9. refusal when the terminal boundary is omitted;
10. replay from canonical inputs producing byte-identical result data.

Static checks:

- zero `::`;
- zero internal constructors;
- zero direct registry mutation;
- zero unsafe receipt mutation;
- zero floats in the authoritative numeric package;
- zero hidden defaults for observation policy.

### Final validation

Run and record:

- Kernel /0 baseline;
- complete Slice /0 baseline;
- complete Slice /1 baseline;
- RR/0 unit tests;
- RR/0 property tests;
- Common Lisp/Python differential vectors;
- all refusal vectors;
- all certificate vectors;
- public smoke;
- package export audit;
- static scans;
- mutation suite;
- deterministic replay twice from a clean process.

### Exit gate

- all positive suites green;
- all declared mutants killed;
- public smoke succeeds;
- existing slices unchanged;
- closure documentation names exactly what was and was not earned.

### Suggested commits

```text
rr0 step 7a: add adversarial controls and public-surface smoke
rr0 step 7b: close Ramanujan Radical /0 with deterministic evidence
```

---

## 7. Optional post-RR/0 codata lane

Codata is **not** part of the RR/0 critical path.

After RR/0 closes, ask whether a second independent specimen needs the same suspension machinery. A suitable second specimen would be a continued fraction, a power-series stream, or an infinite state-transition trace. Only then consider:

```lisp
(later expression)
(force suspended)
(corec ...)
(take n codata)
```

Promotion criteria for a generic `Later` protocol:

1. at least two non-isomorphic specimens require it;
2. both can be written without host closures in durable descriptors;
3. guardedness or productivity has an executable check or a precisely bounded dynamic contract;
4. finite observation remains explicit;
5. unbounded forcing refuses rather than hangs;
6. memoization identity and thread safety are specified;
7. serialization does not pretend to serialize live continuations;
8. the abstraction reduces duplicated semantics rather than merely decorating them.

Until then, the generator plus bounded fold is the smaller and more honest animal.

---

## 8. Dependency graph and critical path

```text
owner authorization + baseline
            |
            v
semantic freeze -----> independent Python oracle
            |                    |
            v                    v
structural descriptor      exact fixtures
            |                    |
            +---------+----------+
                      v
             dyadic interval core
                      |
                      v
               bounded observer
                      |
          +-----------+------------+
          v                        v
local invariant checker    convergence checker
          +-----------+------------+
                      v
            Slice /0-/1 integration
                      |
                      v
          mutants + public smoke + closure
```

The only parallel lane is the independent oracle/review lane. It may find defects but does not block initial construction merely by being unfinished.

---

## 9. Estimated effort

For one capable builder with the current Lisp+ repository already understood:

| Work unit | Focused effort |
|---|---:|
| Phase 0 | 0.5 session |
| Phase 1 | 1–1.5 sessions |
| Phase 2 | 1 session |
| Phase 3 | 2–3 sessions |
| Phase 4 | 1–2 sessions |
| Phase 5 | 1–2 sessions |
| Phase 6 | 1–2 sessions |
| Phase 7 | 1–2 sessions |
| **Total** | **8.5–14 focused sessions** |

A separate cold reviewer should spend one focused session on interval soundness, one on the convergence proof boundary, and one on public-surface/standing attacks.

---

## 10. Principal implementation risks

### Risk 1 — Accidental numeric authority through floats

**Failure:** the evaluator computes with host doubles and later wraps the decimal in a persuasive record.  
**Mitigation:** exact dyadic/rational path, static float scan, differential fixtures, float mutant.

### Risk 2 — Off-by-one truncation semantics

**Failure:** terminal seed is assigned to `N` instead of `N+1`.  
**Mitigation:** explicit `terminal-index`, exact-tail fixtures, identity fields, mutant RR-M04.

### Risk 3 — Local invariant presented as convergence proof

**Failure:** `C(n)=n+1` satisfies the equation, so the runtime simply declares the infinite expression equal to `3`.  
**Mitigation:** two certificate types, two judgment schemas, missing-premise refusal, mutant RR-M09.

### Risk 4 — Generic infinity cathedral

**Failure:** implementation stalls while designing streams, thunks, memoization, productivity types, exact reals, and a theorem prover.  
**Mitigation:** generator plus finite fold is the critical path; codata is a later earned promotion.

### Risk 5 — Mneme absorbs pure arithmetic

**Failure:** every square-root step becomes a journal event, making the evidence layer the evaluator.  
**Mitigation:** pure computation remains ordinary; only persisted observation and certificate artifacts cross the durable boundary.

### Risk 6 — Public API barge

**Failure:** every generated accessor and internal numeric helper is exported.  
**Mitigation:** stranger-style smoke, export audit, safe inspectors, smallest forced public surface.

### Risk 7 — Shared implementation error between oracle and runtime

**Failure:** Python and Lisp agree because one was ported line-for-line from the other.  
**Mitigation:** semantic document and fixtures are shared; algorithms and authorship paths are separate; comparison happens only after both exist.

---

## 11. Definition of done

RR/0 is complete only when all statements below are true:

1. The infinite pattern is represented intensionally by a finite canonical descriptor.
2. A finite prefix can be rendered without evaluating it numerically.
3. A numeric observation requires explicit through-index, terminal interval, precision, and rounding policy.
4. Unbounded observation refuses with a typed condition.
5. The authoritative numerical path uses exact integer/rational/dyadic arithmetic only.
6. Every returned interval encloses the mathematically correct finite truncation.
7. Common Lisp results differentially agree with the independent Python vectors.
8. The local invariant and convergence evidence are represented separately.
9. The terminal-0 sequence is certified to converge to `3` under the declared assumptions.
10. A host-float `3.0` cannot counterfeit the exact claim.
11. Persisted results are canonical and replayable from spec, policy, and procedure identity.
12. Existing Kernel /0, Slice /0, and Slice /1 suites remain green and unchanged.
13. The public smoke uses only admitted exports.
14. Every declared mutant is killed.
15. The closure explicitly states that generic codata, general exact reals, and Language Slice /2 were not thereby earned.

---

## 12. Paste-ready owner authorization for Codex

> **Owner implementation authorization — Ramanujan Radical /0:** Proceed on a fresh branch and worktree with the bounded RR/0 successor probe described in `RAMANUJAN-RADICAL-0-IMPLEMENTATION-ROADMAP.md`. This authorization covers additive Common Lisp implementation, independent Python oracle work, synthetic fixtures, tests, mutants, documentation, and read-only use of the admitted Kernel /0, Language Slice /0, and Language Slice /1 public surfaces. It does not authorize modification of frozen Canonical Datum /0, LCI/0, Kernel /0, Process Journal /0, Adapter Protocol /0, Language Slice /0, or Language Slice /1 semantics; it does not authorize live provider calls, spending, secret opening, publication through an undeclared channel, or automatic designation as Language Slice /2. Implement the generator-plus-bounded-fold path first. Do not make generic codata, a general exact-real tower, a CAS, or a theorem prover prerequisites. Stop and name the smallest witness if the current public surface cannot express the required persisted observation or derivation without semantic invention. Independent review may occur alongside or after construction and is not a prerequisite unless it identifies a concrete authority gap, semantic contradiction, checksum mismatch, or reproducible defect.

### Codex first actions

1. Fresh-fetch `main`; record commit/tree/merge base.
2. Create `codex/ramanujan-radical-0` in a separate worktree.
3. Run and preserve all current Kernel /0, Slice /0, and Slice /1 baselines.
4. Write the scope/work-order and public dependency inventory before runtime code.
5. Freeze the finite-observation semantics and build the independent vectors.
6. Implement phases in the commit order stated above.
7. Return exact branch/commit/tree identities, changed-file inventory, test and mutant results, public export delta, evidence paths and SHA-256 values, bounded unknowns, and confirmation that existing slices remain unchanged and Slice /2 remains unopened.

---

## 13. Recommended adjudication after implementation

The owner should ask one cold reviewer to attack only four questions:

1. Is the interval square-root enclosure mathematically sound for every admitted input?
2. Is the terminal seed attached to the correct semantic index?
3. Does any path conflate local fixed-tail consistency with convergence of finite observations?
4. Did the implementation introduce a generic language primitive where a specimen-local library operation sufficed?

A pass should authorize RR/0 closure as a specimen. Promotion into a future Language Slice should require a separate owner act based on what the specimen actually forced, not on how charming the radical looks while wearing its infinite hat.
