# LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1

**Status:** Authorial architecture candidate 0.1 — traced successor to Draft 0  
**Language:** Lisp+  
**Memory-and-continuity layer:** Mneme  
**Date:** 2026-07-18  
**Authoring chair:** GPT-5.6 Sol, under the owner’s sealed decisions  
**Controlling authorial record:** `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md`, as amended through commit `780cff97`  
**Primary predecessor:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.md`  
**Required review input:** `LISP-PLUS-ARCHITECTURE-0-FABLE-REVIEW.md` — verdict `VIABLE WITH REPAIR`  
**Standing:** Authorial successor candidate. It is not Kernel /0, not implementation authorization, and not a silent rewrite of Draft 0.

---

## 0. Successor declaration

Architecture 0.1 is a **traced repair**. It does not present its corrections as if Draft 0 had always contained them.

The controlling sequence is:

```text
Draft 0
→ Fable review
→ Sol disposition
→ mutually blind Fable and Sol position papers
→ owner synthesis and interview
→ sealed decisions record
→ amendments A-1 through A-4
→ Architecture 0.1
```

The sealed decisions record governs wherever a predecessor differs from this document. Architecture 0.1 performs four jobs:

1. preserve the viable ontology of Draft 0;
2. incorporate every adopted repair and design law;
3. demonstrate, rather than merely assert, that the resulting algebra represents the known terminal cases;
4. stop at residual facts or policy instances the owner deliberately left for later lanes.

This document does **not** classify the 76 Language-A kimi outcomes, invent a concrete public-mirror policy, designate sensitive capability classes, or authorize implementation. It specifies the semantics under which those later acts must occur.

### 0.1 Amendment summary

The deepest changes from Draft 0 are:

- absence is split into closed manifestation state and open causal claim;
- empty and invalid manifestations are present and payload-preserving;
- outcomes have four axes, each with its own determinacy;
- execution-axis values are defined;
- attempt identity, seat identity, supersession, and reconciliation enter the kernel;
- visibility becomes scoped and relational;
- sealed rulings connect to live capabilities through inspectable minting receipts;
- journals declare durability, recover through longest prefix-valid folds, and treat cross-journal merges as receipt-bearing transformations;
- Language-A-specific effect tags and “census” leave kernel vocabulary;
- witness separation, exposed principals, ergonomic conformance, and principal-role symmetry enter as L15–L18;
- the name is settled: **Lisp+ is the language; Mneme is its memory-and-continuity layer.**

---

## 1. Purpose

Lisp+ is a Lisp-family language for programming systems whose consequential computation may occur inside learned, high-dimensional, partially observable machinery: language models, multimodal foundation models, recurrent learned memories, embedding systems, latent planners, tool-using agents, and hybrid symbolic–neural processes.

It begins from a question prior to syntax glamour:

> **Which distinctions must the language preserve so that a latent-machine computation can be executed, interrupted, inspected, resumed, disputed, and composed without confusing activity with output, output with claim, claim with truth, prior authorization with present authority, or retry with innocence?**

The architecture is informed by existing Lisp+ work:

- **Canonical Datum /0**, the immutable typed value and canonical-octet substrate;
- **Located Claim Identity /0**, the identity discipline for claims whose standing depends on source, scope, version, and location;
- **Mneme v1**, whose capability, revocation, typed-condition, and shared-root work is the immediate continuity-layer precursor;
- **Language-A**, whose calibration and emission arcs supplied concrete failure classes involving null manifestation, uncertain effects, route identity, publication, reconstruction, and blinded scoring;
- **S-Expression Garden**, whose graft receipts demonstrate inspectable transformation lineage;
- the project’s practice of sealed records, additive evidence, independent replay, and refusal instead of silent semantic repair.

These are not all kernel modules. They are sources of requirements, counterexamples, and frozen dependencies.

---

## 2. Mission

Lisp+ shall make latent-machine programs:

- **composable like programs**;
- **inspectable like experiments**;
- **interruptible without epistemic amnesia**;
- **accountable like provenance-bearing records**;
- **ordinary where ordinary Lisp is enough**.

A Lisp+ program should express:

1. ordinary deterministic computation;
2. model-mediated and learned computation;
3. the difference between execution, manifestation, interpretation, and claim;
4. irreversible external effects and uncertainty about their settlement;
5. live authority and its provenance;
6. durable process state that survives interruption;
7. first-class attempt identity, retry lineage, and supersession;
8. claims whose origin, validation, integrity, visibility, and bounded unknowns remain inspectable;
9. reconstruction from primary evidence without pretending reconstruction was direct observation;
10. refusal when identity, authority, budget, destination, or replay safety is not established;
11. self-invocation and kin-invocation without inventing separate operator and machine species;
12. epistemic effects that record which principals have spent their blindness.

The aim is not “Common Lisp plus an LLM SDK.” The aim is a language in which learned computation has an operational, epistemic, and economic place without making ordinary computation wear ceremonial armor.

---

## 3. What “Latent Space Machine” means

A **Latent Space Machine** is a computational system whose relevant internal state is substantially encoded in learned representations not directly equivalent to the symbolic values exposed at its interface.

Examples include:

- a transformer whose hidden states mediate token generation;
- a multimodal model whose internal representations bind image, text, sound, and action;
- a recurrent learned memory whose state persists across calls;
- an embedding retrieval system whose geometry influences later behavior;
- an agent distributed across prompts, model states, tools, memories, and external environments;
- a hybrid process in which symbolic programs constrain or interpret learned transformations.

Lisp+ does **not** claim transparent access to latent state merely because a model speaks about itself. A process’s unaided testimony about its own history is asserted testimony. Internal state becomes observed only when an identified witnessing mechanism captures it at a declared boundary.

“Latent” therefore marks an architectural fact—important computation is only partially manifested—not a license for mystical debugging prose.

---

## 4. Architectural thesis

The central thesis is:

> **Lisp+ evaluates ordinary forms into values and consequential forms into durable, inspectable processes and structured outcomes. Execution, manifestation, interpretation, claim standing, authority, and external effect are related, but none may counterfeit another.**

Five separations do most of the constitutional work:

1. **datum is not claim;**
2. **execution is not manifestation;**
3. **manifestation is not interpretation;**
4. **authority stated in a record is not live capability;**
5. **a crossed or uncertain effect is not safely repeatable merely because the caller wants another try.**

Four further distinctions sharpen the thesis:

6. **state is not causal diagnosis;**
7. **presence is not validity;**
8. **seat is not attempt;**
9. **determinacy belongs to particular propositions, not to one global uncertainty scalar.**

The Language-A kimi outcomes supplied a sharp specimen. A provider request could complete, consume a budget, report usage, and terminate by length while failing to yield a subject-answer manifestation. Mapping that event to `nil` destroys the very information a latent-machine language exists to preserve.

---

## 5. Architectural planes

The architecture has six semantic planes. These are distinctions in meaning, not a requirement that every ephemeral object carry six wrappers.

### 5.1 Datum plane

The datum plane contains immutable typed values suitable for equality, canonical serialization, hashing, transport, and comparison.

Canonical Datum /0 is the default substrate at durable boundaries. Lisp+ does not casually admit ambiguous host objects into receipts, journals, claims, or comparisons whose identity matters.

### 5.2 Process plane

The process plane represents computation through durable transitions. It answers:

- what was authorized;
- which seat was occupied;
- which attempt was made;
- whether an irreversible frontier was crossed;
- what settled;
- what remains uncertain;
- what may lawfully resume or supersede;
- which state is reconstructable from evidence.

A process is not merely a thread, chat session, or operating-system PID. It is a language-level identity with a transition history.

### 5.3 Manifestation plane

The manifestation plane contains interface-visible products: text, canonical data, images, audio, embeddings, tool-call structures, partial streams, traces, explicit withholding, or absence.

A manifestation is evidence that something appeared at an interface. It is not automatically a correct answer, a true claim, or a faithful narration of latent computation.

### 5.4 Claim plane

The claim plane contains propositions and data assertions whose identity, provenance, scope, and standing can be inspected.

A claim may originate as observation, assertion, derivation, or reconstruction. Verification may strengthen validation without rewriting origin.

### 5.5 Authority plane

The authority plane represents permission to cross consequential boundaries: provider invocation, spending, secret opening, publication, mutation of external systems, or other domain effects.

Authority is exercised through live capabilities. A durable record may describe the authority once held or required, but cannot resurrect it.

### 5.6 Inspection plane

The inspection plane exposes identities, transitions, receipts, provenance, bounded unknowns, effect settlement, visibility scopes, and authority lineage in machine-readable and human-readable form.

Pretty printing is never the sole evidence format. Human-readable views derive from canonical records.

---

## 6. Core semantic entities

### 6.1 Datum

A **datum** is an immutable typed value whose equality and canonical octets are determined by Canonical Datum /0 or an explicitly adopted successor.

Datums do not automatically carry epistemic standing. The integer `295` is a datum. “295 attempts completed in run X” is a claim containing that datum.

### 6.2 Principal and event role

A **principal** is an identified entity capable of participating in an event under one or more roles.

Roles include, without ontological privilege:

- invoker;
- invoked configuration;
- process subject;
- witness;
- grader;
- verifier;
- capability minter;
- secret recipient;
- publisher;
- owner or owner delegate.

A principal may occupy several roles in the same event. Self-invocation and kin-invocation are ordinary cases. Lisp+ does not encode “operator” and “machine” as different species.

### 6.3 Located claim

A **located claim** binds:

- claim identity;
- claim content;
- source location or source identity;
- scope;
- version;
- provenance links;
- standing records;
- optional supporting and contradicting receipts.

Claim standing is represented through orthogonal records rather than one theatrical status enum.

#### 6.3.1 Origin

Initial origin values include:

- `:asserted`
- `:observed`
- `:derived`
- `:reconstructed`

Origin records name the witnessing or transforming mechanism. A process’s self-written account of its own history remains `:asserted` unless a distinct witnessing mechanism captured the event.

#### 6.3.2 Validation

Initial validation values include:

- `:unchecked`
- `:checked`
- `:verified`
- `:refuted`

Validation names validator identity, scope, method, evidence, and version. Bare `:verified` is an oversized certificate.

#### 6.3.3 Integrity

Initial integrity values include:

- `:open`
- `:sealed`

A seal attests identity, bytes, or chain integrity under a declared method. It does not make content true.

#### 6.3.4 Visibility

Visibility is relational and scoped. Examples:

```lisp
(:published :scope public-mirror)
(:published :scope named-recipient)
(:withheld :scope public :basis capability-id)
(:redacted :scope external-review :receipt redaction-receipt-id)
```

A claim may carry several visibility records over disjoint scopes. Bare `:published` is as oversized as bare `:verified`.

#### 6.3.5 Determinacy and bounded unknowns

Lisp+ does not attach one global “confidence” scalar to a claim. Determinacy records identify the proposition or field they qualify:

```lisp
(:determinacy :target :provider-billed
 :mode :bounded
 :alternatives (:yes :no)
 :evidence (...))
```

This is distinct from outcome-axis determinacy, though the same modes are reused.

### 6.4 Transformation receipt

A **transformation receipt** records a relation from identified inputs to identified outputs.

The kernel protocol requires at least:

- transformation identity and version;
- input identities;
- output identities;
- acting principal or adapter identity;
- machine-configuration identity where applicable;
- authority reference or fingerprint where required;
- predecessor receipts;
- effect summary;
- declared losses, abstractions, or mode changes;
- bounded unknowns;
- integrity seal or seal reference.

Full domain schemas belong to libraries. A receipt never proves more than its recorded procedure and evidence support.

### 6.5 Process

A **process** is a durable identity whose state is derived from an ordered journal of valid transitions.

A minimal generic transition vocabulary includes:

```text
AUTHORIZED
RESERVED
PREPARED
DISPATCHED
ACKNOWLEDGED
PARTIAL-MANIFESTATION
COMPLETED
REFUSED
FAILED
CANCELLED
EFFECT-UNCERTAIN
SUSPENDED
SUPERSEDED
RECONCILED
```

These are transition or process-history terms, not all values of the execution axis.

The current process state is a fold over the longest prefix-valid journal. No mutable “current truth” flag outranks the journal from which it is derived.

### 6.6 Logical operation, seat, attempt, request, and supersession

Lisp+ distinguishes five identities commonly collapsed in orchestration systems:

1. **logical-operation identity** — the abstract work intended;
2. **seat identity** — the stable occupancy domain for that work within a bank, run, or workflow;
3. **attempt identity** — one concrete effort to perform the work;
4. **external-request identity** — the provider or tool request where available;
5. **process identity** — the durable process coordinating transitions.

An attempt record binds at least:

```lisp
(attempt
  :attempt-id ...
  :logical-operation-id ...
  :seat-id ...
  :process-id ...
  :predecessor-attempts (...)
  :supersession-records (...)
  :exposure-identity ...
  :external-request-identity ...)
```

A **supersession record** names:

- superseding attempt;
- superseded attempt;
- authorizing claim or capability;
- reason;
- precedence rule;
- treatment if both results later surface;
- whether the new attempt constitutes a fresh exposure.

Supersession never erases the predecessor and never rewrites an exposed attempt into an untouched seat.

Seat occupancy is derived from journals and supersession records. It is not a mutable boolean stored beside the seat.

### 6.7 Manifestation

A **manifestation** is an interface-visible product with identity, provenance, kind, status, and payload relation.

Kind vocabularies are adapter- and library-defined. The kernel status algebra is:

```text
:present
:present-empty
:present-invalid
:absent
:withheld
:redacted
:present-partial
```

Rules:

1. Every `:present*` status preserves payload identity.
2. `:present-invalid` names the parser identity under which invalidity was determined.
3. Empty payload is present; missing payload is absent.
4. Partial streams are present evidence before settlement.
5. Withholding and redaction preserve the fact that a manifestation relation exists while limiting visibility.
6. Provider refusal content is a present manifestation when bytes or structured refusal data arrived; its interpretation may be `:refused`.

The provider response envelope and the subject manifestation are distinct objects. A present provider envelope may contain an absent subject manifestation.

### 6.8 Outcome

An **outcome** is a product of four principal axes:

1. execution;
2. manifestation;
3. external effect;
4. interpretation.

Each axis carries its own determinacy:

```text
:determinate
:bounded       ; named alternatives plus evidence
:indeterminate
```

There is no outcome-level uncertainty scalar.

#### 6.8.1 Execution axis

The execution axis values are:

```text
:not-attempted
:refused
:failed
:completed
:cancelled
:indeterminate
```

Qualifiers may specify `:pre-frontier` or `:post-frontier` where relevant.

A refusal is pre-frontier by definition. After the frontier, termination is failure, cancellation, completion, or indeterminacy—not a retroactive refusal.

#### 6.8.2 Manifestation axis

The manifestation axis contains a manifestation reference or an absence state, plus determinacy.

#### 6.8.3 External-effect axis

The effect axis records whether declared effects were:

```text
:not-entered
:prepared
:crossed
:settled
:compensated
:bounded
:indeterminate
```

The structured uncertain-effect record is the representation of a bounded or indeterminate effect axis.

#### 6.8.4 Interpretation axis

Initial interpretation values include:

```text
:not-attempted
:not-applicable
:accepted
:rejected
:invalid
:refused
:indeterminate
```

Interpretation is always relative to a named parser, rubric, validator, or other procedure.

#### 6.8.5 Example: completed envelope, absent subject manifestation

```lisp
(outcome
  :execution
    (:value :completed :determinacy :determinate)
  :manifestation
    (:value (:absent :state :absent-after-completion)
     :determinacy :determinate)
  :effects
    (:value :settled
     :determinacy :determinate
     :evidence provider-usage-receipt)
  :interpretation
    (:value :not-applicable :determinacy :determinate)
  :attempt attempt-id
  :machine-configuration config-id)
```

This is not `nil`, and the causal diagnosis is not embedded in the state.

### 6.9 Absence state and causal claim

Absence is a two-level family.

#### 6.9.1 Closed state level

The initial closed state vocabulary is:

```text
:never-attempted
:refused-pre-effect
:absent-after-completion
:withheld
:redacted
:not-applicable
```

These values are exhaustive for a kernel version and safe for deterministic folds.

#### 6.9.2 Open cause level

A causal explanation is an evidence-bearing claim attached to a state:

```lisp
(make-causal-claim
  :subject manifestation-id
  :predicate :budget-exhausted-before-visible-output
  :evidence usage-record-id
  :origin :derived
  :validation (:checked :by adapter-id))
```

A cause may be unestablished, contested, or revised without changing the manifestation state or historical fold.

“No answer appeared” is state. “The budget ran out before visible output” is diagnosis.

### 6.10 Uncertain effect

An **uncertain effect** is the structured representation of bounded or indeterminate settlement on the external-effect axis.

```lisp
(uncertain-effect
  :kind :provider-call
  :attempt attempt-id
  :external-request request-id
  :possible-effects '(:billed :not-billed)
  :known-facts evidence-ids
  :reconciliation-procedure reconciliation-id
  :retry-policy :forbidden-without-reconciliation)
```

The default law forbids blind retry across an unresolved irreversible effect.

### 6.11 Capability

A **capability** is unforgeable live authority to perform a named class of effect under constraints.

Constraints may include:

- allowed provider, tool, or channel;
- model or configuration identity;
- subject or operation scope;
- spending ceiling;
- call count;
- time window;
- destination scope;
- secret-access boundary;
- delegation and restoration rules;
- revocation state.

A capability is not canonically serialized as transferable authority. Durable records may contain its public identity, fingerprint, scope, minting receipt, and requirements.

#### 6.11.1 Minting bridge

A sealed ruling or policy claim does not itself become a capability. It may authorize a minting act.

A minting receipt records:

```lisp
(capability-mint
  :capability-id ...
  :minted-by authority-principal-id
  :under authorizing-claim-id
  :derived-scope ...
  :delegates ...
  :revocation-registry ...
  :expiry ...)
```

The bridge is inspectable: prose remains evidence; the mint is the act that creates live authority.

#### 6.11.2 Restoration after suspension

A suspended process cannot restore its own capability from historical records.

Restoration may be performed only by:

- the original minter; or
- a delegate named in the minting record.

Every restoration:

- creates a new capability identity linked to the predecessor;
- emits a restoration receipt;
- rechecks revocation;
- rechecks unresolved irreversible effects;
- grants equal or narrower scope, never enlarged scope.

Domain policies may require a fresh owner act for sensitive classes.

### 6.12 Machine configuration identity

A latent-machine invocation is not identified by a marketing label alone.

A **machine configuration identity** binds, as applicable:

- provider;
- route;
- exact API model identifier;
- resolved model or provider-reported identity;
- renderer and renderer version;
- system and developer instruction identities;
- tool schema identities;
- decoding and sampling parameters;
- reasoning allocation;
- token and cost ceilings;
- retry policy;
- output parser;
- safety or mediation layer where observable;
- adapter implementation identity;
- acting and exposed principals where relevant.

Aliases are designations. A live call records the resolved identity available at dispatch.

### 6.13 Channel policy

A **channel policy** declares the consequential semantics of writing or committing into a channel whose downstream behavior may publish, replicate, or expose artifacts.

The minimum schema is:

```lisp
(channel-policy
  :channel-id ...
  :source-scope ...
  :destinations ((... :visibility ...))
  :authorized-principals (...)
  :propagation-mode :automatic
  :amendment-authority ...
  :policy-identity ...
  :effective-version ...)
```

A policy informs capability checks; it does not auto-authorize. Making a path mirror-bound is an amendment act that re-confirms authorized principals.

For a declared mirror-bound path, the deliberate commit is the publication frontier. Synchronization is mechanical settlement of an effect already authorized at commit time.

A conforming environment provides a genuinely private staging area outside such declared publication channels.

---

## 7. Evaluation model

Traditional Lisp presents:

```text
form → value
```

Lisp+ preserves that story for ordinary computation and extends consequential evaluation:

```text
form + lexical environment + process context + authority set
    → ordinary value | structured outcome | process handle
    + ordered durable transitions
    + receipts and claims
```

A schematic judgment is:

```text
Γ ; Π ; Α ; Ρ ⊢ e ⇓ v ; Δ
```

where:

- `Γ` is the lexical and dynamic environment;
- `Π` is the process context;
- `Α` is the live authority set;
- `Ρ` is the active principal-role assignment;
- `e` is the form;
- `v` is an ordinary value, structured outcome, or process handle;
- `Δ` is an ordered set of proposed or committed transitions and receipts.

This notation is architectural, not yet the Kernel /0 formal semantics.

### 7.1 Pure evaluation

Pure evaluation:

- consumes no external capability;
- crosses no irreversible frontier;
- may be repeated without changing external state;
- returns ordinary Lisp values;
- converts to canonical datums only when crossing a durable boundary.

### 7.2 Consequential synchronous evaluation

A short consequential operation returns a structured outcome.

Before the frontier, the runtime checks:

- required capability is present and unrevoked;
- scope matches;
- machine, channel, destination, seat, and attempt identities are resolved;
- budget remains;
- declared live-path preconditions hold;
- no unresolved effect occupies the seat or idempotency domain;
- retry and supersession policy permit dispatch;
- exposed-principal consequences are accepted by the capability scope.

Transitions are persisted incrementally.

### 7.3 Long-running and resumable evaluation

A long-running operation returns a process handle implementing the outcome protocol.

A process handle supports:

- inspection of settled transitions;
- current fold-derived state;
- partial manifestation access without settlement inflation;
- cancellation request;
- suspension;
- lawful resume;
- eventual outcome retrieval;
- reconciliation and supersession operations.

### 7.4 Model-mediated evaluation

A model-mediated form does not promise a single ordinary value. It returns an outcome or handle containing:

- process, seat, and attempt identity;
- execution axis;
- manifestation axis;
- effect axis;
- interpretation axis;
- usage and cost observations;
- machine-configuration identity;
- transformation receipts;
- exposed-principal records where applicable;
- bounded unknowns.

A model’s textual assertion does not become observation merely by inhabiting a field named `answer`.

### 7.5 Lawful handling must be the shortest supported path

For every supported consequential operation, the default public interface automatically carries:

- attempt identity;
- authority checking;
- effect recording;
- journal transitions;
- structured outcome handling.

The reference API must not provide a shorter ordinary-looking path that silently drops these semantics.

Raw host escape is explicit, visibly unsafe, and outside the conforming Lisp+ operation surface.

At 5 a.m., syntax becomes governance.

---

## 8. Effects and irreversible frontiers

### 8.1 Effect classes

Lisp+ distinguishes at least:

1. pure operations;
2. replay-safe effects under an explicit idempotency contract;
3. compensable effects with a named compensating action;
4. irreversible effects;
5. epistemic effects that change who knows what;
6. constitutive effects that change operative standing or visibility.

Representative generic effect tags include:

```lisp
:provider-call
:spend
:secret-open
:publication
:external-write
:tool-action
```

Domain libraries refine these. The kernel does not contain Language-A-specific `:score-under-key` or `:subject-exposure` primitives.

### 8.2 Frontier protocol

For consequential effects, the runtime observes:

```text
PREPARED → FRONTIER-CROSSED → SETTLED | BOUNDED | INDETERMINATE
```

All checks practicable before the frontier occur before it.

> **Execution-path closure:** when offline verification cannot traverse a live-only path capable of failing after spend or exposure, live preflight must traverse or faithfully simulate that path before the frontier.

### 8.3 No implicit retry

Lisp+ does not silently retry an irreversible or uncertain effect.

A retry requires at least one of:

- provider-enforced idempotency;
- reconciliation proving the prior effect did not occur;
- a new attempt identity with explicit supersession;
- domain authorization naming the unresolved predecessor and precedence rule.

### 8.4 No implicit fallback

Provider, route, model, renderer, parser, policy, or destination substitution changes identity. It requires explicit policy or authorization.

“Equivalent enough” is not a runtime primitive.

### 8.5 Epistemic effects and exposed principals

A `:secret-open` or related epistemic effect records:

- protected object identity;
- exposing action;
- receiving principals;
- exposure scope;
- whether exposure was direct, relayed, or inferred;
- evidence;
- restrictions on later roles.

Blindness is queryable and spendable. Self-invocation may expose the invoker and consume its eligibility for a blind role.

### 8.6 Publication frontier

For a path declared mirror-bound by an identified channel policy, commit is the publication act.

A lawful commit outcome therefore includes both durable write and publication effects:

```lisp
(:effects
  ((:durable-write :scope lab-repository)
   (:publication :scope public-mirror)))
```

Automation does not abolish the effect; it moves the authorization boundary earlier.

---

## 9. Mneme: durable execution, continuity, and reconstruction

Mneme is the memory-and-continuity layer of Lisp+.

### 9.1 Append-only transition law

Consequential transitions are recorded append-only under a store protocol.

The protocol requires:

- ordered append within one journal;
- record identity;
- predecessor linkage;
- canonical or canonicalizable record content;
- explicit commit boundary;
- declared durability;
- prefix validation;
- torn-tail reporting;
- deterministic fold semantics.

The canonical reference implementation uses human-readable S-expressions.

### 9.2 Declared durability

A store declares its guarantee, for example:

```text
:synced
:best-effort
```

The architecture does not claim more durability than the backend supplies. Best-effort tails induce bounded determinacy where settlement cannot be established.

### 9.3 Torn-tail recovery

A kill may occur mid-append.

The canonical fold operates over the longest prefix-valid journal. A torn trailing record:

- remains visible evidence;
- is not silently dropped;
- does not invalidate the settled prefix;
- is not laundered into a committed transition.

### 9.4 One journal, one order

A single journal provides its declared total order. Wall-clock timestamps are observations, not ordering authority.

Cross-journal composition is a reconstruction transformation with:

- explicit source journals;
- ordering and conflict rule;
- transformation identity;
- output journal or derived view identity;
- receipt.

It is never an implicit timestamp sort.

### 9.5 Finalizer law

> **A finalizer is a convenience, not the sole custodian of truth.**

A finalizer may organize, summarize, and seal. It may not possess unique primary facts required to reconstruct the process.

### 9.6 Reconstruction standing

A reconstructed claim has origin `:reconstructed`. Its validation and integrity may be strong.

A reconstruction receipt names:

- primary records;
- fold or algorithm identity;
- ordering rules;
- conflict policy;
- missing evidence;
- output identity;
- independent evidence replay where available.

Verification does not rewrite reconstruction into observation.

### 9.7 Replay triad

Lisp+ uses three distinct terms:

1. **execution replay** — repeat the declared procedure;
2. **evidence replay** — reconstruct or verify from recorded evidence;
3. **output reproduction** — obtain the same emission again.

The first two may be strong while the third is impossible. The language never promotes repeatable procedure into deterministic model output without evidence.

### 9.8 Process recovery

On restart, Mneme derives state from the journal and refuses unsafe continuation upon:

- unresolved dispatched effect;
- occupied seat or output identity;
- torn or invalid required transition;
- missing receipt;
- identity drift;
- capability expiry or revocation;
- incompatible adapter version;
- illegal transition sequence;
- attempted self-restoration of authority.

Resume checks the capability requirement and minting lineage, then requests new live authority from an eligible minter or delegate.

---

## 10. Claim composition and provenance

### 10.1 Provenance is transitive but transformation-sensitive

A derived claim records not only ancestors but the transformations relating them.

Each edge names:

- source identity;
- transformation identity and version;
- scope;
- losses, abstractions, or mode changes;
- validation evidence;
- authority where required.

### 10.2 No standing inflation

A transformation may preserve, reduce, or alter standing. It may not silently increase it.

Examples:

- paraphrasing an observation does not make the paraphrase directly observed;
- hashing seals bytes but does not verify semantics;
- publication changes visibility, not truth;
- verifying a reconstruction does not make it live-run finalizer output;
- a process narrative written after the fact remains asserted testimony.

### 10.3 Witness separation

> **A process’s unaided account of its own history has origin `:asserted`. It acquires observational standing only through evidence captured by a distinct witnessing mechanism whose identity, capture boundary, and integrity are inspectable.**

The canonical kernel-mediated journal is the default witness for kernel-mediated transitions. A self-written narrative is not transformed into a witness by being stored under a respectable filename.

Other witnesses may include provider receipts, operating-system records, external ledgers, authenticated callbacks, and independent observation services.

### 10.4 Mode-changing transformations

Model output to parsed datum, datum to claim, evidence set to derived view, or secret opening to scored result are mode-changing transformations.

They state:

- preserved information;
- discarded information;
- new assumptions;
- parser, rubric, or policy identity;
- claims licensed downstream.

### 10.5 Publication and visibility

Publication is both an effect and a visibility record. The effect records what was done; the visibility record says where the artifact or claim is available.

Neither substitutes for the other.

---

## 11. Surface-language sketch

The following forms demonstrate architecture. Syntax is not frozen.

### 11.1 Declaring a machine configuration

```lisp
(define-machine language-a-kimi
  (:provider :openrouter)
  (:route-id route-id)
  (:model-api-id model-api-id)
  (:renderer renderer-v1)
  (:reasoning-budget 768)
  (:max-output-tokens 768)
  (:temperature 0)
  (:retry-policy :explicit-only))
```

### 11.2 Declaring a seat and attempt

```lisp
(with-seat (seat study-id item-id configuration-id)
  (begin-attempt seat
    :attempt-id attempt-id
    :exposure-id exposure-id))
```

### 11.3 Crossing an authorized frontier

```lisp
(with-capability (cap exposure-capability)
  (invoke-machine language-a-kimi
                  subject
                  :seat seat-id
                  :attempt attempt-id
                  :budget-cap usd-cap
                  :sink envelope-store))
```

The public form performs identity, capability, effect, and journal handling. A raw provider request is not the shorter supported path.

### 11.4 Matching outcomes without collapsing axes

```lisp
(with-outcome (o (invoke-machine config subject ...))
  ((:execution :completed)
   (:manifestation (:present answer))
   (interpret-answer answer))

  ((:execution :completed)
   (:manifestation (:absent :absent-after-completion))
   (record-no-manifestation o))

  ((:effect (:bounded alternatives))
   (reconcile-before-retry o)))
```

### 11.5 Preserving invalid payload

```lisp
(match-outcome o
  ((:manifestation (:present-invalid payload parser-id))
   (archive-payload payload)
   (make-claim
     :content `(invalid-under ,parser-id)
     :origin :derived
     :sources (list (identity-of payload)))))
```

### 11.6 Superseding an uncertain attempt

```lisp
(supersede-attempt
  :seat seat-id
  :predecessor uncertain-attempt-id
  :new-attempt replacement-attempt-id
  :under owner-ruling-id
  :precedence :prefer-reconciled-original-else-replacement)
```

### 11.7 Building a located claim

```lisp
(make-claim
  :content `(completed-count ,count)
  :identity claim-id
  :origin (:reconstructed :by fold-id)
  :validation (:verified :by verifier-id :evidence verifier-receipt)
  :integrity (:sealed digest)
  :visibility ((:published :scope public-mirror))
  :sources envelope-identities)
```

### 11.8 Secret opening with exposed principals

```lisp
(with-capability (cap secret-open-capability)
  (open-secret key-id
    :principals (list grader-principal orchestrator-principal)
    :scope scoring-session-id))
```

### 11.9 Commit to a mirror-bound path

```lisp
(with-capability (cap mirror-commit-capability)
  (commit-artifact artifact-id
                   :channel public-mirror-channel))
```

The resulting outcome records both durable write and publication.

### 11.10 Inspecting provenance

```lisp
(explain claim-id
  :show '(:sources :transformations :witnesses :authority
          :visibility :unknowns :seals :exposed-principals))
```

The inspector emits a human-readable view and canonical machine-readable evidence.

---

## 12. Minimal kernel boundary

Kernel /0 should be small enough to audit and large enough to express one complete latent-machine process.

### 12.1 Kernel primitives

The kernel provides:

1. bootstrap ordinary Lisp evaluation;
2. Canonical Datum /0 boundary integration;
3. principal and role identities;
4. process identities and transition protocol;
5. logical-operation, seat, and attempt identities;
6. supersession and reconciliation protocol;
7. manifestation status algebra and payload preservation;
8. four-axis outcome algebra with per-axis determinacy;
9. closed absence states;
10. structured uncertain-effect values;
11. live capabilities, minting provenance, revocation, restoration, and defensive scope handling;
12. effect declaration and frontier checks;
13. durable-store protocol and deterministic folds;
14. claim and receipt protocols compatible with LCI/0;
15. machine-configuration identity protocol;
16. adapter protocol;
17. inspection and canonical evidence export;
18. typed conditions for refusal, semantic failure, authority failure, identity drift, unsafe retry, torn tail, and unsupported reconstruction.

### 12.2 Kernel protocols with library representations

The kernel recognizes protocols for:

- located claims;
- transformation receipts;
- machine-configuration records;
- causal claims;
- channel policies;
- store backends.

Their canonical field-rich representations belong to libraries unless Kernel /0 proves a smaller mandatory shape.

### 12.3 Library responsibilities

Libraries provide:

- experiment preregistration;
- item banks;
- scoring constitutions;
- provider pricing;
- Language-A exposure and scoring refinements;
- domain-specific causal vocabularies;
- publication workflows and concrete channel-policy instances;
- agent societies;
- prompt templating;
- memory policies beyond the Mneme core;
- S-Expression Garden grafting;
- Quine Orchard experiments;
- paper generation;
- statistical analysis;
- “census” as the name of a particular derived fold.

### 12.4 Why this boundary matters

Language-A is design evidence, not a template from which every primitive is copied.

Typed absence, uncertain effects, manifestation/execution separation, and reconstruction standing remain kernel-level because non-LLM machines require them too: embedding retrieval may return nothing; a tool may time out after side effects; recurrent state may advance without an emission.

---

## 13. Relationship to existing artifacts

### 13.1 Canonical Datum /0

CD/0 is the durable value and wire substrate. Architecture 0.1 does not alter its frozen semantics.

### 13.2 Located Claim Identity /0

LCI/0 supplies identity for claims whose meaning depends on source, version, scope, and location. Lisp+ uses it for claims and receipt relations, not for every ephemeral host value.

### 13.3 Mneme

Mneme is now explicitly the memory-and-continuity layer of Lisp+:

- process journals;
- reconstruction;
- resumption;
- capability requirement persistence;
- continuity across host death;
- memory policy extension points.

It is not the name of the whole language.

### 13.4 Language-A

Language-A supplies empirical design evidence:

- completed envelope without subject manifestation;
- empty versus absent manifestation distinction;
- uncertain external write;
- route and API identity mismatch;
- publication as operative effect;
- live-only failure after spend unless preflight closes the path;
- finalizer loss with successful reconstruction;
- blinded-role eligibility after secret exposure;
- seat/attempt/supersession requirements.

The Language-A paper is not a prerequisite for Kernel /0. Its findings help Lisp+ only where they become laws, requirements, fixtures, or rejected alternatives.

The factual classification of the 76 kimi records remains outside Architecture 0.1. The sealed projection rule governs that later locked-lane act.

### 13.5 S-Expression Garden

The Garden supplies concrete transformation and graft-provenance patterns.

### 13.6 Quine Orchard

The Orchard remains an advanced testbed for reflection and generated code. It is not required for Kernel /0.

### 13.7 Explicit exclusion

The Proclus/Lean work is not part of the Lisp+ project roadmap or dependency graph.

---

## 14. Reference implementation architecture

### 14.1 Common Lisp host bootstrap

The first implementation uses Common Lisp for:

- reader and macro facilities;
- package loading;
- filesystem and process access;
- evaluator bootstrap;
- adapter implementation.

Host behavior does not enter canonical semantics without conversion.

### 14.2 Lisp+ Kernel /0

Kernel /0 implements the primitives and protocols named in §12.

### 14.3 Mneme /0

Mneme /0 implements:

- the canonical S-expression journal;
- store protocol;
- fold-derived process state;
- torn-tail detection;
- restoration requirements;
- evidence replay;
- derived-view generation.

### 14.4 Adapters

Adapters bind external systems and declare which semantics they can establish:

- idempotency;
- request identity;
- reconciliation;
- usage reporting;
- version resolution;
- cancellation;
- streaming durability;
- parser behavior;
- exposed-principal boundaries.

### 14.5 Libraries and applications

Libraries build experiments, agent systems, memory policies, scoring, publication, and domain tools over the kernel.

---

## 15. First vertical specimen

The first executable specimen is a small latent-machine pipeline using a deterministic fake adapter before any live provider.

It contains:

- a fixed canonical input bank;
- several logical seats;
- explicit attempts;
- one deterministic fake adapter;
- explicit capabilities and budget;
- an S-expression Mneme journal;
- present, present-empty, present-invalid, absent, refused, failed, partial, and uncertain outcomes;
- one secret-opening event with exposed principals;
- one mirror-bound publication simulation;
- a derived view called a census only in the experiment library;
- independent evidence replay.

### 15.1 Forced-kill scenario

The specimen must:

1. begin several seats;
2. complete some attempts;
3. persist partial manifestation for one attempt;
4. cross a simulated external frontier;
5. kill the host before settlement record completion;
6. leave a torn or incomplete tail under a controlled negative fixture;
7. restart;
8. fold the longest prefix-valid journal;
9. identify one uncertain effect;
10. refuse blind retry;
11. restore authority through minter or mint-time delegate;
12. resume untouched seats;
13. optionally supersede the uncertain attempt under explicit authorization;
14. reconstruct the derived view;
15. prove the finalizer adds no unique primary fact.

### 15.2 Call-296 canonical fixture

The canonical uncertain fixture has:

```lisp
(:execution
  (:value :indeterminate :determinacy :indeterminate))
(:manifestation
  (:value (:absent :state :absent-after-completion)
   :determinacy :bounded
   :evidence (...)))
(:effects
  (:value :bounded
   :determinacy :bounded
   :alternatives (:billed :not-billed)))
(:interpretation
  (:value :not-applicable :determinacy :determinate))
```

The exact manifestation wording in a live Language-A record remains subject to the sealed structural projection. The fixture demonstrates the algebra, not the pending factual classification.

---

## 16. Required adversarial tests

Kernel /0 is not acceptable until the specimen exercises at least:

1. completed execution with absent subject manifestation;
2. provider envelope present while subject manifestation is absent;
3. present-empty payload;
4. present-invalid payload preserved under named parser identity;
5. partial manifestation surviving interruption;
6. refusal before frontier;
7. failure after frontier;
8. uncertain write after process death;
9. duplicate seat;
10. duplicate attempt identity;
11. duplicate external idempotency identity;
12. supersession without authorization;
13. supersession that erases predecessor evidence;
14. occupied target detected pre-effect;
15. missing required published receipt;
16. commit to mirror-bound channel without publication capability;
17. channel policy amended without amendment authority;
18. revoked capability;
19. capability scope mutation or aliasing;
20. attempted self-restoration from journal evidence;
21. restoration with enlarged scope;
22. spending ceiling exceeded;
23. provider alias resolving differently from frozen configuration;
24. adapter version drift;
25. finalizer loss followed by successful reconstruction;
26. torn journal tail;
27. best-effort durability producing bounded determinacy;
28. cross-journal merge attempted as timestamp sort without receipt;
29. standing inflation such as sealed becoming verified;
30. self-written process narrative promoted to observation;
31. claim copied without transformation receipt;
32. secret opening without exposed-principal record;
33. self-invocation that fails to mark the invoker exposed;
34. unsafe implicit fallback;
35. unsafe implicit retry;
36. convenience accessor that discards outcome context;
37. raw host value crossing a durable boundary without canonicalization.

**Negative controls MUST prove that the tests detect deliberately introduced violations.**

### 16.1 Ergonomic conformance tests

The reference API must show:

1. the shortest documented provider invocation is lawful by default;
2. safe outcome handling is direct and composable;
3. manifestation access does not silently erase outcome context;
4. refusal, reconciliation, and resume paths are first-class operations;
5. raw escape is explicit and visibly unsafe;
6. no supported unsafe bypass is shorter than the lawful operation it bypasses.

---

## 17. Demonstrated terminal-case matrix

Architecture 0.1 does not claim universal representation by proclamation. The matrix below demonstrates placement of the known cases.

| Case | Execution | Manifestation | Effect | Interpretation | Additional entity | Represented without catch-all? |
|---|---|---|---|---|---|---|
| untouched seat | `:not-attempted` determinate | `:absent/:never-attempted` determinate | `:not-entered` determinate | `:not-attempted` | seat | yes |
| pre-frontier refusal | `:refused` determinate | `:absent/:refused-pre-effect` | `:not-entered` | `:not-applicable` | refusal receipt | yes |
| completed, valid output | `:completed` | `:present` | `:settled` | procedure-relative result | attempt + receipt | yes |
| completed, empty payload | `:completed` | `:present-empty` | `:settled` | often `:not-applicable` | payload identity | yes |
| completed, no subject output | `:completed` | `:absent/:absent-after-completion` | `:settled` | `:not-applicable` | optional causal claim | yes |
| present invalid payload | `:completed` or `:failed` as adapter contract states | `:present-invalid` | settled or bounded | `:invalid` under parser | parser identity | yes |
| external failure after dispatch | `:failed :post-frontier` | present/partial/absent | settled or bounded | contextual | attempt | yes |
| uncertain write | `:indeterminate` | bounded or absent-so-far | bounded alternatives | `:not-applicable` | uncertain-effect record | yes |
| later authorized replacement | new attempt outcome | independent manifestation | independent effect | independent interpretation | supersession record | yes |
| reconstructed derived view | **not an invocation outcome** | **not an invocation manifestation** | reconstruction transformation effects only | fold validation | claim origin `:reconstructed` | yes, by refusing misclassification |
| published artifact | producer outcome plus publication effect | artifact manifestation | `:publication` settled | independent | scoped visibility | yes |
| self-report about process history | ordinary assertion outcome | present narrative | usually none | not observation | claim origin `:asserted` | yes |
| secret opened to invoker | completed effectful action | secret manifestation may be withheld | `:secret-open` settled | role-dependent | exposed principals | yes |

The reconstructed derived view intentionally sits outside the invocation-outcome algebra. This is a success of separation, not a representational failure.

---

## 18. Non-goals

Architecture 0.1 does not settle:

- a theory of machine consciousness;
- semantic interpretation of hidden activations without instrumentation;
- a proof assistant or dependent type theory;
- replacement of Common Lisp as a general-purpose language;
- a universal agent ontology;
- complete distributed transaction semantics;
- provider-independent equivalence of model calls;
- exact syntax for every form;
- automatic truth evaluation of model output;
- automatic recovery from every uncertain effect;
- canonical serialization of every transient local value;
- concrete public-mirror path and principal values;
- factual classification of the 76 kimi records;
- Language-A paper completion before kernel work;
- the stranger primitive-minimization verdict.

The architecture is ambitious about distinctions and conservative about metaphysical and operational overclaim.

---

## 19. Design laws

### L0 — Datum/claim separation

A datum does not acquire claim standing by being stored under a persuasive field name.

### L1 — Execution/manifestation separation

Completed execution does not imply a present or valid manifestation.

### L2 — Manifestation/interpretation separation

A manifestation does not imply a licensed interpretation or true claim.

### L3 — Standing orthogonality

Origin, validation, integrity, scoped visibility, and proposition-specific determinacy do not silently entail one another.

### L4 — No standing inflation

A transformation may not increase epistemic standing without named evidence and procedure.

### L5 — Authority explicitness

Consequential effects require live authority checked at the frontier.

### L6 — No innocent retry assumption

An unresolved irreversible effect forbids blind replay.

### L7 — Identity before effect

Machine configuration, channel, logical operation, seat, attempt, destination, and acting principals are resolved before the frontier.

### L8 — Incremental durability

Consequential settled work is persisted incrementally under a declared durability guarantee.

### L9 — Reconstructable finalization

A finalizer adds organization and integrity, not unique primary facts.

### L10 — Reconstruction remains reconstruction

Verification does not rewrite reconstructed origin into direct observation.

### L11 — Explicit fallback

Provider, route, model, renderer, parser, destination, or policy substitution is an identified transformation requiring authorization or declared policy.

### L12 — Live-path closure

A path capable of failing after a consequential frontier is exercised or faithfully simulated before the frontier when practicable.

### L13 — Bounded claims

Every receipt, verification, policy, and seal names its scope and absent dependencies.

### L14 — Secrets do not leak through evidence

Receipts may identify authority and secret lineage without serializing private capability or secret content.

### L15 — Witness separation

A process’s unaided account of its own history is asserted testimony. Observational standing requires a distinct, inspectable witnessing mechanism.

### L16 — Exposed principals

Epistemic effects record who now knows. Blindness is a queryable, spendable resource.

### L17 — Ergonomics as conformance

For every supported consequential operation, the lawful route may not be longer than the supported bypass. At 5 a.m., syntax becomes governance.

### L18 — Principal-role symmetry

Lisp+ represents principals and event roles, not operator and machine species. Self-invocation and kin-invocation are ordinary, and self-invocation may spend the invoker’s own blindness.

---

## 20. Adoption criteria for Architecture 0.1

Architecture 0.1 is ready for owner adoption when:

1. its trace against Draft 0, review, and decisions is complete;
2. every sealed decision is represented without contradiction;
3. the terminal-case matrix is reviewed against the review’s Appendix B;
4. the kernel/library boundary contains no Language-A moustache;
5. the one-page channel-policy schema is accepted as sufficient without inventing the concrete instance;
6. the vertical specimen can be specified without unstated behavior in CD/0 or LCI/0;
7. the pending kimi classification remains properly outside this document;
8. implementation remains explicitly unauthorized until Kernel /0 exists;
9. residual holes are named rather than silently filled.

The stranger primitive-minimization audit occurs after the forced-kill specimen in the current roadmap. It is not a prerequisite for authoring or owner-adopting Architecture 0.1.

---

## 21. Deliberately residual matters

Architecture 0.1 stops at these boundaries:

1. **Concrete channel-policy instance.** The schema is defined; path, destination, principal, and amendment-authority values require repository evidence and owner adoption.
2. **The 76 kimi facts.** The projection rule is defined; factual classification occurs later in the locked scoring lane.
3. **A1 analyzability ruling.** Independent of the representation mapping.
4. **Sensitive capability classes.** Domain policies decide which require fresh owner action.
5. **Exact Kernel /0 syntax and byte schemas.** Next specification.
6. **Independent primitive minimization.** Reserved for a stranger to the Language-A arc.

These are not invitations for implementer invention.

---

## 22. Immediate successors

After owner adoption, the sequence is:

1. `LISP-PLUS-KERNEL-0-SPEC.md` — normative primitives, judgments, conditions, and operations;
2. `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` — Mneme transition, durability, prefix, merge, and reconstruction rules;
3. `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` — fake and external adapter contracts;
4. `LISP-PLUS-VERTICAL-SPECIMEN-0.md` — exact forced-kill program and adversarial fixtures;
5. Codex implementation only under explicit authorization;
6. stranger primitive-minimization audit after the specimen exposes implementation cost.

The immediate engineering order remains:

```text
Architecture 0.1 adoption
→ Kernel /0 specification
→ Codex runtime + deterministic fake adapter
→ forced-kill specimen
→ stranger audit
```

Parallel research lanes remain independent of this critical path.

---

# Appendix A — Traced repair ledger

| ID | Draft 0 location | Review / decision source | Architecture 0.1 disposition |
|---|---|---|---|
| AR-01 | §5.7 absence enum | Review R1; DK-2 | Closed absence state plus open causal claim |
| AR-02 | §5.5/§5.7 invalid and empty | Review R2; DK-2 | `:present-empty` and `:present-invalid`, payload-preserving |
| AR-03 | §5.6 global uncertainty | Review R3; DK-4 | Four axes with per-axis determinacy |
| AR-04 | §5.6 undefined execution values | Review R4 | Explicit execution algebra |
| AR-05 | §§6.2, 7.3, 15 implicit seat | Review R5 | Logical operation, seat, attempt, request, supersession primitives |
| AR-06 | §5.2 bare visibility | Review R6; D9 | Scoped, relational visibility |
| AR-07 | §5.9 authority gap | Review R7; DK-3 | Capability minting and restoration receipts |
| AR-08 | §8 journal overclaim | Review R8; D4 | Declared durability, torn tails, prefix folds, receipt-bearing merges |
| AR-09 | §7.1 and §8 kernel moustache | Review R9 | Generic effects and folds; Language-A terms moved to libraries |
| AR-10 | open D1–D10 | sealed decisions | All adopted with refinements |
| AR-11 | self-report only implied | A-1 / L15 | Witness-separation law |
| AR-12 | secret exposure actorless | L16 | Exposed-principal records and spent blindness |
| AR-13 | ergonomics non-normative | L17 / A-3 | Constitutional law plus conformance tests |
| AR-14 | operator/machine split implicit | A-2 / L18 | Principal-role symmetry |
| AR-15 | name open | A-4 | Lisp+ language; Mneme continuity layer |
| AR-16 | publication model incomplete | DK-1 / A-3 | Commit frontier under explicit channel policy; private staging required |
| AR-17 | representability asserted | review Appendix B / post-seal charge | Demonstrated terminal-case matrix |
| AR-18 | decisions section remained open | sealed record | Replaced by residual boundaries; no resolved question left theatrically open |

---

# Appendix B — Kernel/library disposition

| Entity or vocabulary | Standing in Architecture 0.1 |
|---|---|
| Datum / CD/0 boundary | kernel primitive / frozen dependency |
| Principal and role | kernel primitive |
| Process | kernel primitive |
| Seat and attempt identity | kernel primitive |
| Supersession and reconciliation | kernel primitive |
| Manifestation status | kernel primitive |
| Manifestation kind vocabulary | adapter/library |
| Structured outcome | kernel primitive |
| Absence state | kernel primitive |
| Causal vocabulary | open library claim vocabulary |
| Uncertain effect | kernel primitive |
| Capability and minting/restoration | kernel primitive |
| Located claim | kernel protocol; canonical library representation |
| Transformation receipt | kernel protocol; canonical library representation |
| Machine configuration | kernel identity protocol; adapter schema |
| Channel policy | kernel-recognized protocol; concrete policy instance outside kernel |
| Durable store | kernel protocol; canonical Mneme filesystem implementation |
| “Census” | experiment-library name for a derived fold |
| Scoring constitution | domain library |
| Item bank | domain library |
| `:score-under-key` | Language-A library refinement |
| `:subject-exposure` | domain refinement of generic epistemic effect |
| Provider-specific budget exhaustion cause | adapter/domain causal claim |

---

# Appendix C — Reference API conformance obligations

A conforming reference API shall:

1. make the lawful consequential call the default call;
2. allocate or require explicit attempt identity automatically at the correct layer;
3. check authority before the frontier;
4. record partial manifestations without calling them settled;
5. preserve empty and invalid payloads;
6. refuse implicit retry across uncertain effects;
7. make reconciliation and supersession first-class;
8. expose outcomes through pattern matching or equivalent direct handling;
9. prevent convenience accessors from silently discarding outcome context;
10. mark raw host escape explicitly unsafe;
11. record exposed principals for epistemic effects;
12. treat mirror-bound commit as publication under channel policy;
13. provide human-readable S-expression evidence;
14. export canonical evidence at durable boundaries;
15. preserve reconstructed origin after verification.

---

## Closing statement

Architecture 0.1 is not the implementation and not the language’s final form. It is the first version whose constitutional distinctions, algebra, authority model, continuity model, and ergonomic burden have all been made explicit under a sealed owner record.

Its job is not to sound inevitable. Its job is to leave fewer places for a latent machine, an operator, a provider, a runtime, or an eloquent narrator to counterfeit completion—and to make the honest path the path the hand reaches for when the room is dark and the clock has become accusatory.
