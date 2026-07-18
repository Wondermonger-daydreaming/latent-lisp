# LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0

**Status:** Authorial architecture draft 0  
**Project:** Lisp+ / Mneme  
**Date:** 2026-07-18  
**Standing:** Non-normative until explicitly reviewed and adopted  
**Scope:** Semantic architecture for a Lisp designed to program Latent Space Machines

---

## 0. Purpose of this document

This document states the first coherent architecture for **Lisp+**, a Lisp-family language for programming systems whose consequential computation may occur inside learned, high-dimensional, partially observable machinery: language models, multimodal foundation models, recurrent learned memories, embedding systems, latent planners, tool-using agents, and hybrid symbolic–neural processes.

It does not yet freeze syntax, standard-library names, a compiler ABI, or a provider API. It freezes a more basic question first:

> **What distinctions must the language preserve so that a latent-machine computation can be executed, inspected, resumed, disputed, and reproduced without confusing activity with output, output with claim, claim with truth, or retry with innocence?**

The architecture is informed by the existing Lisp+/Mneme work:

- **Canonical Datum /0**, which supplies immutable typed values and canonical octets;
- **Located Claim Identity /0**, which supplies identity for claims whose standing depends on source, scope, version, and location;
- **Mneme v1**, which has already exercised capabilities, revocation, defensive copying, typed conditions, and shared-root audit;
- **Language-A**, whose calibration and emission arcs exposed live distinctions among execution, manifestation, scoring, publication, cost, uncertainty, and reconstruction;
- **S-Expression Garden**, whose graft receipts make transformation history inspectable rather than folkloric;
- the project’s broader practice of sealed records, additive evidence, independent replay, and refusal instead of silent semantic repair.

These materials are not miscellaneous precedents. They are partial organs of one language architecture.

---

## 1. Mission

Lisp+ shall make latent-machine programs **composable like programs, inspectable like experiments, and accountable like provenance-bearing records**.

A Lisp+ program should be able to express:

1. ordinary deterministic computation;
2. model-mediated or learned computation;
3. the difference between a computation occurring and a usable manifestation appearing;
4. irreversible effects such as spend, subject exposure, secret opening, publication, and external tool action;
5. authority to perform those effects;
6. durable process state that survives interruption;
7. claims whose origin, validation, integrity, visibility, and uncertainty remain inspectable;
8. reconstruction from primary evidence without pretending reconstruction was direct observation;
9. refusal when identity, authority, budget, or replay safety is not established;
10. language-level composition without reducing every model invocation to an untyped string-in/string-out foreign-function call.

The aim is not “Common Lisp with an LLM SDK.” The aim is a language in which learned computation has a proper operational and epistemic place.

---

## 2. What “Latent Space Machine” means here

A **Latent Space Machine** is a computational system whose relevant internal state is substantially encoded in learned representations that are not directly equivalent to the symbolic values exposed at its interface.

Examples include:

- a transformer whose hidden states mediate token generation;
- a multimodal model whose internal representations bind image, text, sound, and action;
- a recurrent learned memory whose state persists across calls;
- an embedding retrieval system whose nearest-neighbour geometry influences later reasoning;
- an agent whose behavior is distributed across prompts, model states, tools, memories, and external environments;
- a hybrid system in which symbolic programs schedule, constrain, or interpret learned transformations.

Lisp+ does **not** claim transparent access to “the latent space” merely because a model emitted text about itself. Internal state is directly represented only when an instrumented adapter supplies an identified observation. Otherwise the language records the observable interface event and the bounded inferences licensed by it.

“Latent” therefore marks an architectural fact—important computation is only partially manifested—not a license for mystical debugging prose.

---

## 3. Architectural thesis

The central thesis is:

> **Lisp+ evaluates forms into values and durable transitions. Model-mediated evaluation may additionally produce manifestations and claims. These products are related, but they are not identical and must not be silently collapsed.**

Five separations do most of the constitutional work:

1. **datum is not claim;**
2. **execution is not manifestation;**
3. **manifestation is not interpretation;**
4. **authority is not capability merely asserted in prose;**
5. **a completed effect is not the same thing as a safely repeatable effect.**

Language-A’s kimi-k3 null-content stratum supplied a particularly sharp specimen. A provider request could complete, consume a budget, report usage, and terminate by length while producing no visible subject answer. A language that maps all of that to `nil` destroys the very distinctions the experiment needs.

Lisp+ shall instead preserve the event as a structured outcome whose axes can be queried independently.

---

## 4. Architectural planes

The architecture is divided into six planes. These are semantic separations, not a demand that every runtime object carry six wrappers.

### 4.1 Datum plane

The datum plane contains immutable typed values suitable for equality, canonical serialization, hashing, transport, and comparison.

Canonical Datum /0 is the default substrate. Lisp+ should not casually reintroduce ambiguous host values—mutable hash tables, unreadable objects, implementation-dependent floats, or host symbols—into records whose identity or replay matters.

### 4.2 Process plane

The process plane represents computation unfolding through durable state transitions. It answers:

- What was authorized?
- What was attempted?
- Which irreversible frontier was crossed?
- What completed?
- What remains in flight or uncertain?
- Which current state can be reconstructed from the transition history?

A process is not merely a thread or operating-system PID. It is a language-level identity with an append-only transition history.

### 4.3 Manifestation plane

The manifestation plane contains externally available renderings of latent or ordinary computation: text, structured data, images, audio, tool calls, embeddings, logits, traces, or explicit absence.

A manifestation is evidence that something appeared at an interface. It is not automatically a correct answer, a true claim, or a faithful account of internal computation.

### 4.4 Claim plane

The claim plane contains propositions or data assertions whose identity and standing can be inspected.

A claim may be direct observation, reconstruction, derivation, model assertion, human assertion, or verified conclusion. These origins must not be flattened into one “confidence” number.

LCI/0 supplies the identity discipline for claims whose meaning depends on location, scope, version, and source.

### 4.5 Authority plane

The authority plane represents permission to cross effect boundaries: provider invocation, spending, subject exposure, secret access, publication, mutation of an external system, or scoring under a private key.

Authority is represented by capabilities or capability references, not by ambient convention. A function that lacks the required capability cannot acquire authority by printing a convincing sentence.

### 4.6 Inspection plane

The inspection plane exposes provenance, transition history, identities, receipts, bounded unknowns, and derivations in a form that can be replayed or independently checked.

Pretty printing is never the sole evidence format. Human-readable views are derived from canonical records.

---

## 5. Core semantic entities

### 5.1 Datum

A **datum** is an immutable typed value. Its equality and canonical octets are determined by Canonical Datum /0 or a later explicitly adopted successor.

Datums do not automatically carry epistemic standing. The integer `295` is a datum. “295 emissions completed in attempt 02” is a claim involving that datum.

### 5.2 Located claim

A **located claim** binds:

- claim identity;
- content;
- source location or source identity;
- scope;
- version;
- provenance links;
- standing facets;
- optional supporting or contradicting receipts.

Claim standing must be represented by **orthogonal facets**, not by one theatrical status enum. At minimum:

#### Origin facet

- `:asserted`
- `:observed`
- `:derived`
- `:reconstructed`

#### Validation facet

- `:unchecked`
- `:checked`
- `:verified`
- `:refuted`

Validation always names its validator, scope, method, and evidence. “Verified” without scope is an oversized certificate.

#### Integrity facet

- `:open`
- `:sealed`

Sealing attests byte identity or chain integrity. It does not make the content true.

#### Visibility facet

- `:private`
- `:published`
- `:withheld`
- `:redacted`

Publication may be constitutive for a workflow, but publication is not verification.

#### Uncertainty facet

- `:determinate`
- `:bounded`
- `:indeterminate`

A bounded uncertainty record names the unresolved alternatives and the evidence that constrains them.

These facets may be extended, but their dimensions must not be silently conflated. `:sealed`, `:published`, and `:verified` answer different questions.

### 5.3 Transformation receipt

A **transformation receipt** records a transformation from identified inputs to identified outputs. It should contain, where applicable:

- transformation identity and version;
- input identities;
- output identities;
- operator or adapter identity;
- configuration identity;
- authority reference or authority fingerprint;
- deterministic or sampled status;
- random seed or sampling parameters where meaningful;
- start and completion transition identities;
- effect summary;
- cost and usage observations;
- predecessor receipts;
- bounded unknowns;
- integrity seal.

A receipt does not prove more than its recorded procedure and evidence can support.

### 5.4 Process

A **process** is a durable identity whose state is derived from an append-only transition journal.

The minimal generic state vocabulary is:

```text
AUTHORIZED
RESERVED
DISPATCHED
ACKNOWLEDGED
COMPLETED
REFUSED
FAILED
CANCELLED
UNCERTAIN
```

Domain libraries may refine these states, but they must preserve the distinction between:

- refusal before an irreversible frontier;
- failure after the frontier;
- completion;
- uncertainty about whether an external effect occurred.

The current state is a fold over valid transitions. A finalizer may summarize the process but may not be the sole holder of facts required to reconstruct it.

### 5.5 Manifestation

A **manifestation** is an interface-visible product of computation. Its kind may include:

- canonical datum;
- text;
- image;
- audio;
- embedding;
- structured tool call;
- trace;
- absent manifestation;
- invalid manifestation;
- withheld manifestation.

Manifestations have identity and provenance. A text string copied from one process to another is not assumed to retain the same claim identity unless a transformation receipt establishes the relation.

### 5.6 Outcome

An **outcome** is a product of independent axes, not a single success/failure bit.

At minimum it records:

- execution status;
- manifestation status;
- external-effect status;
- interpretation status;
- usage and cost observations;
- process identity;
- receipts and bounded unknowns.

For example, the Language-A null-content event is representable as:

```lisp
(outcome
  :execution     (:completed)
  :manifestation (:absent :reason :budget-exhausted)
  :effects       (:settled :provider-request :usage-reported)
  :interpretation (:unscored :reason :no-subject-answer)
  :provenance    receipt-id)
```

This is intentionally not equivalent to `nil`.

### 5.7 Absence

**Absence** is an algebraic family. The initial standard reasons should include:

- `:never-attempted`
- `:pre-effect-refusal`
- `:completed-no-manifestation`
- `:budget-exhausted-before-manifestation`
- `:manifestation-empty`
- `:manifestation-invalid`
- `:withheld-by-authority`
- `:redacted`
- `:not-applicable`

An absence may carry evidence. “No answer appeared” and “no request occurred” are not the same value.

### 5.8 Uncertain effect

An **uncertain effect** records that an irreversible external effect may have occurred but cannot presently be established.

Example:

```lisp
(uncertain-effect
  :kind :provider-call
  :request request-id
  :possible-effects '(:billed :response-created)
  :known-facts evidence
  :retry-policy :forbidden-without-reconciliation)
```

The default semantics forbid blind retry across an uncertain irreversible effect.

### 5.9 Capability

A **capability** is an unforgeable runtime authority to perform a named class of effect under stated constraints.

Constraints may include:

- allowed provider or tool;
- model identity;
- item or subject scope;
- spending ceiling;
- call count;
- time window;
- permitted output sink;
- secret-access boundary;
- revocation state;
- delegation rights.

Capabilities are not canonically serialized as transferable secrets. Canonical records may contain capability identities, public fingerprints, scopes, and receipts, while the live authority remains an opaque runtime object or protected reference.

### 5.10 Machine configuration identity

A latent-machine invocation is not identified by a marketing model name alone.

A **machine configuration identity** should bind, as applicable:

- provider;
- route;
- exact API model identifier;
- resolved model version or provider-reported identity;
- renderer and renderer version;
- system and developer instruction identities;
- tool schema identities;
- decoding and sampling parameters;
- reasoning allocation;
- token and cost ceilings;
- retry policy;
- output parser;
- safety or moderation layer where observable;
- adapter implementation identity.

Aliases such as “kimi-k3” are designations. A live call must also record the resolved service identity available at dispatch time.

---

## 6. Evaluation model

Traditional Lisp presents a compact story:

```text
form → value
```

Lisp+ preserves that story for pure computation but extends effectful evaluation:

```text
form + lexical environment + process context + authority set
    → value or outcome
    + zero or more durable transitions
    + zero or more receipts
```

A schematic judgment is:

```text
Γ ; Π ; Α ⊢ e ⇓ v ; Δ
```

where:

- `Γ` is the lexical and dynamic environment;
- `Π` is the durable process context;
- `Α` is the available authority set;
- `e` is the form;
- `v` is a value or structured outcome;
- `Δ` is an ordered set of proposed or committed transitions and receipts.

This notation is illustrative, not yet a formal specification.

### 6.1 Pure evaluation

Pure evaluation:

- consumes no external capability;
- crosses no irreversible frontier;
- may be repeated without changing external state;
- produces canonical values where identity matters.

### 6.2 Effectful evaluation

Effectful evaluation declares or infers required effects. Before execution, the runtime checks:

- required capability is present and unrevoked;
- scope matches;
- identity is resolved;
- preconditions hold;
- budget remains;
- destination is available;
- retry policy permits dispatch;
- no unresolved prior effect occupies the same logical seat or idempotency domain.

After dispatch, transitions are persisted incrementally.

### 6.3 Model-mediated evaluation

A model-mediated form does not promise a single ordinary value. It returns an outcome containing:

- process identity;
- execution status;
- manifestation or typed absence;
- usage observations;
- effect settlement state;
- machine configuration identity;
- transformation receipt;
- optional claims derived from the manifestation.

Interpretation is a separate transformation. A model’s textual assertion does not become an observed fact merely by inhabiting a field named `answer`.

---

## 7. Effects and irreversible frontiers

### 7.1 Effect classes

Lisp+ should distinguish at least:

1. **pure effects:** no external mutation or irreversible observation;
2. **replay-safe effects:** external but idempotent under an explicit key and contract;
3. **compensable effects:** reversible only by a named compensating action;
4. **irreversible effects:** cannot be safely repeated or undone by the runtime;
5. **epistemic effects:** change what an actor or process is permitted to know;
6. **constitutive effects:** publication or registration changes an artifact’s operative standing.

Representative effect tags include:

```lisp
:provider-call
:spend
:subject-exposure
:secret-open
:publish
:external-write
:tool-action
:score-under-key
```

The effect vocabulary is extensible. The kernel supplies the protocol, not every domain tag.

### 7.2 Spend and exposure frontier

For effects that spend money, expose blinded material, mutate an external system, or open a secret, the runtime observes a frontier:

```text
PREPARED → FRONTIER-CROSSED → SETTLED | UNCERTAIN
```

All checks that can be executed before the frontier must occur before it. This includes walking live-only paths that offline fixtures cannot exercise.

The Language-A `FileExistsError` repair yields a general law:

> **Execution-path closure:** if verification cannot traverse a live-only path, live preflight must traverse or faithfully simulate that path before crossing the irreversible frontier.

### 7.3 No implicit retry

Lisp+ must not silently retry an irreversible or uncertain effect.

A retry requires one of:

- a provider-enforced idempotency contract;
- reconciliation proving the prior effect did not occur;
- a new logical attempt identity and an explicit supersession relation;
- a domain-specific owner or capability authorization.

### 7.4 No implicit fallback

Substituting another provider, model route, renderer, or parser changes machine configuration identity. It requires an explicit policy or a new authorization. “Equivalent enough” is not a runtime primitive.

---

## 8. Durable execution and reconstruction

### 8.1 Append-only transition law

Every consequential state transition should land durably before the runtime relies on it as completed.

The runtime shall prefer:

- append-only attempt-scoped records;
- atomic creation or atomic replace under a declared rule;
- content-addressed evidence;
- explicit predecessor links;
- deterministic folds for current state and census;
- incremental persistence before long waits.

### 8.2 Finalizer law

> **A finalizer is a convenience, not the sole custodian of truth.**

A process summary, census, report, or paper table must be reconstructable from primary durable records or explicitly declare which facts are not reconstructable.

### 8.3 Reconstruction standing

A reconstructed claim is not downgraded to guesswork merely because it was reconstructed. Its origin facet is `:reconstructed`; its validation and integrity may still be strong.

A reconstruction receipt names:

- the primary records consumed;
- the fold or algorithm;
- ordering rules;
- conflict policy;
- missing evidence;
- output identity;
- independent replay result where available.

The language must preserve “reconstructed” even after verification. Verification does not rewrite history into direct observation.

### 8.4 Process recovery

On restart, the runtime derives process state from the journal and refuses unsafe continuation when it encounters:

- an unresolved dispatched effect;
- an occupied output identity;
- a missing required receipt;
- identity drift;
- capability expiry or revocation;
- an incompatible adapter version;
- a transition sequence that violates the process protocol.

---

## 9. Claim composition and provenance

### 9.1 Provenance is transitive but transformation-sensitive

If claim `C` is derived from claims `A` and `B`, `C` records the transformation that relates them. Provenance is not merely a bag of ancestors.

Each edge names:

- source identity;
- transformation identity;
- version;
- scope;
- losses, abstractions, or mode changes;
- validation evidence;
- authority where required.

### 9.2 No standing inflation

A transformation may preserve, reduce, or alter standing. It may not silently increase standing.

Examples:

- paraphrasing an observed statement does not make the paraphrase directly observed;
- hashing a file seals identity but does not verify semantics;
- publishing a receipt grants operative visibility but does not prove the receipt’s conclusion;
- reconstructing a census and independently replaying it may verify the reconstruction without making it a live-run finalizer output.

### 9.3 Mode-changing transformations

Some transformations change representation or epistemic mode: model output to parsed datum, datum to score, evidence set to census, private key to scored result.

Such transformations must state:

- what information is preserved;
- what information is discarded;
- what new assumptions enter;
- which downstream claims are licensed.

The S-Expression Garden’s graft receipt is one concrete precedent for this rule.

---

## 10. Surface-language sketch

The following forms are schematic. They show architectural intent, not frozen syntax.

### 10.1 Declaring a machine configuration

```lisp
(define-machine language-a-kimi
  (:provider :openrouter)
  (:route "...")
  (:model-api-id "...")
  (:renderer renderer-v1)
  (:reasoning-budget 768)
  (:max-output-tokens 768)
  (:temperature 0)
  (:retry-policy :explicit-only))
```

### 10.2 Crossing an authorized frontier

```lisp
(with-capability (cap exposure-capability)
  (invoke-machine language-a-kimi
                  subject
                  :seat seat-id
                  :budget-cap usd-cap
                  :idempotency request-id
                  :sink envelope-store))
```

### 10.3 Matching the outcome without collapsing axes

```lisp
(match outcome
  ((:execution :completed)
   (:manifestation (:present answer)))
  (interpret-answer answer))

(match outcome
  ((:execution :completed)
   (:manifestation (:absent reason)))
  (record-no-manifestation reason))

(match outcome
  ((:effects (:uncertain effect)))
  (refuse-retry effect))
```

### 10.4 Building a located claim

```lisp
(make-claim
  :content `(completed-count ,count)
  :identity claim-id
  :origin :reconstructed
  :validation (:verified verifier-receipt)
  :integrity (:sealed digest)
  :visibility :published
  :uncertainty :determinate
  :sources envelope-identities)
```

### 10.5 Inspecting provenance

```lisp
(explain claim-id
  :show '(:sources :transformations :authority :unknowns :seals))
```

The inspector must generate both a human-readable view and a canonical machine-readable record.

---

## 11. Minimal kernel boundary

The first Lisp+ kernel should be small enough to reason about and large enough to express one complete latent-machine process.

### 11.1 Kernel responsibilities

The kernel shall provide:

1. evaluation of ordinary Lisp forms required by the bootstrap subset;
2. Canonical Datum /0 integration;
3. runtime identities for processes, transitions, manifestations, claims, receipts, and machine configurations;
4. located-claim construction compatible with LCI/0;
5. structured outcome axes;
6. typed absence and uncertain-effect values;
7. capability creation, checking, delegation limits, revocation, and defensive scope handling;
8. effect declaration and frontier protocol;
9. append-only transition journaling;
10. deterministic reconstruction folds;
11. adapter protocol for latent machines and external tools;
12. inspection and canonical evidence export;
13. typed conditions for refusal, semantic failure, authority failure, identity drift, and unsafe retry.

### 11.2 Standard-library responsibilities

The following belong initially in libraries, not the kernel:

- experiment preregistration;
- scoring constitutions;
- item banks;
- provider-specific pricing;
- publication workflows;
- agent societies;
- memory policies;
- prompt templating;
- S-Expression Garden grafting;
- Quine Orchard self-reference experiments;
- paper generation;
- domain-specific statistical analysis.

The kernel may support their effects and identities without knowing their domain vocabulary.

### 11.3 Why this boundary matters

Language-A is design evidence, not the template from which every primitive is copied. The kernel should generalize the discovered distinctions while leaving experimental governance in a library.

Otherwise Lisp+ risks becoming an exquisitely typed reenactment of one emission pilot.

---

## 12. Relationship to existing Lisp+/Mneme artifacts

### 12.1 Canonical Datum /0

Canonical Datum /0 is the value and wire substrate for durable evidence, receipts, claim content, machine configuration records, and transition records.

The architecture must not alter its frozen semantics implicitly. Any successor integration is an explicit versioned dependency.

### 12.2 Located Claim Identity /0

LCI/0 supplies claim identity and location-sensitive semantics. Lisp+ uses it for claims, not for every ephemeral runtime value.

The algebraic-law audit remains a supporting assurance lane. It is not a blocker on drafting the language architecture, though semantic defects discovered there may require later amendment.

### 12.3 Mneme

Mneme becomes the durable memory, authority, and provenance-bearing process layer of Lisp+, not a synonym for the whole language.

Its existing capability and revocation work is a direct kernel precursor.

### 12.4 Language-A

Language-A supplies empirical design evidence:

- completed execution without subject manifestation;
- typed null-content outcomes;
- uncertain external write;
- publication as operative standing;
- live-path failure invisible to offline receipts;
- provider and route identity drift;
- spend and exposure frontiers;
- reconstructable census after finalizer loss;
- role separation around private scoring keys.

Language-A’s paper may document these findings, but Lisp+ benefits only when they become requirements, invariants, tests, or rejected design alternatives.

### 12.5 S-Expression Garden

The Garden supplies transformation and graft provenance patterns. Its receipt discipline should inform the generic transformation receipt and inspector.

### 12.6 Quine Orchard

The Orchard remains an advanced testbed for self-reference, reflection, and generated code. It is not required for Kernel /0.

### 12.7 Explicit exclusion

The Proclus/Lean work is not part of the Lisp+ project roadmap. Conceptual resonances may be discussed elsewhere, but no Proclus artifact, prediction, or kernel result is a dependency of Lisp+ architecture or implementation.

---

## 13. Reference implementation architecture

The first implementation should be stratified into four layers.

### 13.1 Host bootstrap

A Common Lisp host provides:

- reader and macro facilities;
- package and module loading;
- filesystem and process access;
- implementation substrate for the evaluator and adapters.

Host behavior must not leak into canonical semantics without an explicit boundary.

### 13.2 Lisp+ kernel

The kernel implements:

- value integration;
- identities;
- outcomes;
- claims;
- effects;
- capabilities;
- process journal;
- reconstruction;
- adapter protocol;
- typed conditions.

### 13.3 Adapters

Adapters bind external systems:

- model providers;
- local inference servers;
- tools;
- databases;
- filesystems;
- message buses;
- scoring engines.

Each adapter publishes an identity and declares which semantics it can and cannot guarantee: idempotency, request reconciliation, usage reporting, version resolution, cancellation, and streaming durability.

### 13.4 Libraries and applications

Libraries provide:

- experiment DSLs;
- agent composition;
- Mneme memory policies;
- Garden graft operations;
- scoring and evaluation;
- reporting and publication;
- domain applications.

---

## 14. First vertical specimen

The architecture shall be tested by one complete program before broad syntax work.

The specimen should implement a small latent-machine study with:

- a fixed canonical input bank;
- multiple logical seats;
- one deterministic fake-machine adapter;
- one optional live-provider adapter;
- explicit capability and budget;
- append-only seat transitions;
- present, null-content, invalid-content, refused, failed, and uncertain outcomes;
- a derived census;
- a simple blinded interpretation or scoring stage;
- independent replay;
- human-readable and canonical evidence exports.

The specimen must survive forced interruption.

A valid demonstration includes:

1. start the run;
2. complete several seats;
3. kill the host process during a simulated or live dispatch;
4. restart;
5. reconstruct all settled work;
6. identify the uncertain seat;
7. refuse unsafe replay;
8. resume untouched seats;
9. reproduce the census independently;
10. verify that the finalizer adds no unique facts.

This specimen is the first genuine Lisp+ program for Latent Space Machines. It should be small enough to audit line by line.

---

## 15. Required adversarial tests

Kernel /0 is not acceptable until the specimen exercises at least these failure classes:

1. completed execution with absent manifestation;
2. manifestation present but invalid under the declared parser;
3. refusal before spend;
4. external failure after dispatch;
5. uncertain write after process death;
6. duplicate logical seat;
7. duplicate idempotency identity;
8. occupied output target detected pre-effect;
9. missing published receipt;
10. revoked capability;
11. capability scope aliasing or mutation attempt;
12. spending ceiling exceeded;
13. provider alias resolves differently from the frozen configuration;
14. adapter version drift;
15. reconstruction from primary records after finalizer loss;
16. corrupted or missing transition record;
17. standing inflation attempt, such as sealed becoming verified;
18. claim copied without a transformation receipt;
19. unsafe implicit fallback;
20. unsafe implicit retry.

Negative controls should prove that the tests can detect deliberately introduced violations.

---

## 16. Non-goals for Architecture /0

Architecture /0 does not attempt to settle:

- a universal theory of machine consciousness;
- direct semantic interpretation of hidden activations;
- a proof assistant or dependent type theory;
- a replacement for Common Lisp as a general-purpose language;
- a universal agent ontology;
- a complete distributed transaction protocol;
- provider-independent equivalence of model calls;
- a final syntax for every claim or effect form;
- automatic truth evaluation of model outputs;
- automatic recovery from every uncertain external effect;
- a requirement that every transient local value be canonically serialized;
- publication of the Language-A paper before kernel work begins.

The architecture is deliberately ambitious about distinctions and conservative about metaphysical claims.

---

## 17. Design laws

The following laws summarize the architecture and should become tests, proof obligations, or explicit review criteria.

### L0 — Datum/claim separation

A datum does not acquire claim standing merely by being stored in a field with a persuasive name.

### L1 — Execution/manifestation separation

Completed execution does not imply a present or valid manifestation.

### L2 — Manifestation/interpretation separation

A manifestation does not imply a licensed interpretation or true claim.

### L3 — Standing orthogonality

Origin, validation, integrity, visibility, and uncertainty are independent facets. No facet silently entails another.

### L4 — No standing inflation

A transformation may not increase epistemic standing without named evidence and a validating procedure.

### L5 — Authority explicitness

Irreversible effects require explicit live authority whose scope is checked at the frontier.

### L6 — No innocent retry assumption

An unresolved external effect forbids blind replay.

### L7 — Identity before effect

The machine configuration, logical operation, destination, and attempt identity are resolved before crossing an irreversible frontier.

### L8 — Incremental durability

Consequential settled work is persisted incrementally rather than entrusted to session continuity.

### L9 — Reconstructable finalization

A finalizer adds organization and integrity, not unique primary facts.

### L10 — Reconstruction remains reconstruction

Verification of a reconstructed claim does not rewrite its origin as direct observation.

### L11 — Explicit fallback

Provider, route, model, renderer, parser, or policy substitution is an identified transformation requiring authorization or declared policy.

### L12 — Live-path closure

A path capable of failing after an irreversible effect must be exercised or faithfully simulated before the frontier when practicable.

### L13 — Bounded claims

Every receipt, verification, and seal names its scope and cannot certify absent dependencies.

### L14 — Secrets do not leak through evidence

Receipts may identify authority and key lineage without serializing private capability material or scoring-key content.

---

## 18. Adoption criteria for Architecture /0

This document is ready for adoption only after:

1. existing project artifacts are mapped to the proposed entities without semantic contradiction;
2. kernel primitives are separated from Language-A-specific library concepts;
3. the claim-standing facets are reviewed for orthogonality;
4. the outcome product can represent all known Language-A terminal cases without ad hoc fields;
5. capability semantics are reconciled with Mneme v1;
6. process transitions admit deterministic reconstruction;
7. a minimal specimen can be described without inventing unstated behavior in frozen dependencies;
8. open authorial decisions are resolved or explicitly deferred;
9. at least one independent reviewer attempts to remove unnecessary primitives;
10. the owner explicitly adopts a versioned successor, likely Architecture 0.1.

No additional ceremonial gate is implied. Each criterion exists to close a named semantic risk.

---

## 19. Open authorial decisions

The following questions remain deliberately open.

### D1 — Core evaluation result

Should every effectful form return one universal `outcome` record, or should ordinary values and process handles remain distinct types with a protocol for obtaining outcomes?

**Draft preference:** ordinary pure forms return values; model-mediated and irreversible forms return structured outcomes or process handles.

### D2 — Claim representation

Should claims be immutable records in the kernel or a standard-library abstraction over LCI/0 datums?

**Draft preference:** kernel-recognized claim protocol with canonical library representation.

### D3 — Effect checking

Should effect requirements be dynamically checked first, statically approximated, or both?

**Draft preference:** dynamic capability enforcement in Kernel /0; optional static effect analysis later.

### D4 — Process storage

Should the kernel mandate a filesystem journal format or define an abstract durable-store protocol?

**Draft preference:** abstract protocol plus one canonical filesystem implementation for the reference runtime.

### D5 — Capability persistence

How should a process resume when its live capability cannot be serialized?

**Draft preference:** persist a capability requirement and public authority identity; require explicit reattachment of live authority on resume.

### D6 — Randomness and nondeterminism

Which sampling data must be recorded when providers cannot expose or honor a deterministic seed?

**Draft preference:** record requested controls, provider acknowledgements, resolved model configuration, and the bounded non-reproducibility rather than claiming deterministic replay.

### D7 — Streaming

Are partial token streams manifestations, process transitions, or adapter-local observations?

**Draft preference:** identified partial manifestations whose settlement status remains provisional until the adapter closes or fails.

### D8 — Secret opening

Should opening a private key or blinded rubric be a generic epistemic effect or a domain-specific scoring operation?

**Draft preference:** generic `:secret-open` effect; scoring remains a library protocol.

### D9 — Publication

Should publication be a kernel effect tag or only an application convention?

**Draft preference:** extensible effect tag supported by the kernel; operative publication rules belong to libraries.

### D10 — Host interoperation

How much raw Common Lisp data may cross into Lisp+ without canonicalization?

**Draft preference:** unrestricted inside explicitly local ephemeral computation; prohibited at durable identity and evidence boundaries without conversion.

---

## 20. Immediate successor artifacts

If adopted as the working architecture, this document should produce:

1. `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md` — owner dispositions for D1–D10;
2. `LISP-PLUS-KERNEL-0-SPEC.md` — normative kernel entities and operations;
3. `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` — transition and reconstruction rules;
4. `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` — provider/tool adapter contract;
5. `LISP-PLUS-VERTICAL-SPECIMEN-0.md` — exact first program and adversarial test plan;
6. implementation relays only after the relevant authorial behavior is determined.

The architecture should now be attacked, simplified, and made executable. Its job is not to sound inevitable. Its job is to leave fewer places for a latent machine, a provider, a runtime, or an enthusiastic narrator to counterfeit completion.
