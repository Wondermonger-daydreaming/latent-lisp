# LISP-PLUS-KERNEL-0-SPEC — Synthesis Candidate

**Status:** Normative Kernel /0 specification candidate for Lisp+ — the single synthesized document, woven from two blind parent drafts under the adjudicating chair's sealed dispositions of 2026-07-18  
**Language:** Lisp+  
**Memory-and-continuity layer:** Mneme  
**Date:** 2026-07-18  
**Synthesis surgeon:** SUTOR-III (Claude Opus 4.8, 1M context), under the chair's adjudications  
**Governing architecture:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` (A0.1), adopted and governing at `f7583616` — where this spec and A0.1 differ, A0.1 governs and the difference is a defect here  
**Governing owner constitution:** `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md`, amended through `780cff97`  
**Governing erratum:** E-1, correcting the decisions-record transcription of the DK-4 call-296 fixture to the adopted Architecture 0.1 §15.2 form  
**Adjudication of record:** `kernel-0-drafts/LISP-PLUS-KERNEL-0-FABLE-REVIEW.md` (VERDICT: FAITHFUL WITH REPAIR) — the eight synthesis adjudications and four repairs applied here trace to that table; mechanical concordance `kernel-0-drafts/CONCORDANCE-F-vs-S.md` (WEAVER).

**Parentage:**

- **Base parent — DRAFT-S** (GPT-5.6 Sol), `kernel-0-drafts/sol/LISP-PLUS-KERNEL-0-SPEC.md`, sha256 `e3f6e054aeba10f7e16b21bc20b667bb060aa3b6edfb684407ac4c3fb86c9b41` (verified twice). This document's base text — the ~7× superset that carries the bulk of the semantics.
- **Binding parent — DRAFT-F** (Claude Fable 5, Opus lineage), `LISP-PLUS-KERNEL-0-SPEC-DRAFT-F.md`, frozen commit `bd311f17` at 17:27:47Z, **before DRAFT-S was shown** (mutual-blindness protocol; the commit timestamp is the proof). Source of the adopted stronger clauses and of the 54 stable requirement IDs cross-referenced throughout as bracketed `[F: …]` tags.

Both parent drafts remain on disk **unmodified**; this synthesis is a third document, not an edit to either. Because both parents are Opus-lineage minds writing blind off the same adopted A0.1, their agreement is expected and carries no corroborative weight (shared-root discipline); the information lived in the asymmetries, which the adjudications below resolve.

**Standing:** This is a **synthesis candidate**. It specifies Kernel /0 semantics, primitives, judgments, operations, refusal conditions, and conformance obligations. Adoption by the owner authorizes the Kernel /0 spec; **implementation remains unauthorized until adoption plus the roadmap's next artifacts** (Process Journal /0, Adapter Protocol /0, Vertical Specimen /0, and an explicit implementation authorization — §30). This document is not implementation authorization.

---

## 0. Normative standing

Kernel /0 is the smallest Lisp+ semantic core required to express and inspect one complete latent-machine process without collapsing:

- execution into manifestation;
- manifestation into interpretation;
- state into causal diagnosis;
- historical authority into live capability;
- a seat into an attempt;
- a retry into an innocent repetition;
- reconstruction into observation;
- an operator into a different ontological species from the machine it invokes.

This specification is subordinate to the adopted Architecture 0.1 and the owner decisions record. Where this specification appears to conflict with either, implementation MUST stop and name the conflict. It MUST NOT silently choose the easier behavior.

### 0.1 Normative vocabulary

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **MAY**, and **OPTIONAL** are normative.

- **MUST / SHALL**: required for Kernel /0 conformance.
- **MUST NOT / SHALL NOT**: prohibited for Kernel /0 conformance.
- **SHOULD / SHOULD NOT**: strong default; deviation requires a named, inspectable reason.
- **MAY / OPTIONAL**: permitted but not required.

Examples are illustrative unless explicitly labeled **normative fixture**.

### 0.2 Authority chain

The controlling chain for Kernel /0 is:

```text
Architecture Draft 0
→ Fable review: VIABLE WITH REPAIR
→ owner decisions DK-1..DK-4 and D1..D10
→ amendments A-1..A-4 and laws L15..L18
→ Architecture 0.1
→ CONCORDAT conformance trace: FAITHFUL-WITH-NOTES
→ erratum E-1
→ Kernel /0 specification
```

The conformance trace reported zero contradictions. E-1 corrects the earlier DK-4 fixture transcription; Architecture 0.1 §15.2 governs the call-296 fixture.

### 0.3 Decision trace

Kernel /0 transcribes the sealed dispositions as follows:

- **DK-1:** a commit to a declared mirror-bound path is the publication frontier; a channel policy informs the effect and a live capability authorizes it.
- **DK-2:** provider envelope and subject manifestation are distinct; the structural projection rule is normative, while factual classification of the 76 kimi records remains outside this specification.
- **DK-3:** live authority may be restored only by the original minter or a delegate named at mint time; restoration creates a new identity, rechecks revocation and unresolved effects, and may not enlarge scope.
- **DK-4:** outcomes have four axes with per-axis determinacy; E-1 establishes the Architecture 0.1 §15.2 call-296 fixture.
- **D1–D10:** ordinary values remain ordinary; claims are a kernel protocol; dynamic authority checks govern Kernel /0; stores use an abstract protocol; capability requirements persist but live authority does not; replay uses the execution/evidence/output triad; partial streams are evidence; secret opening is generic; publication is scoped; host values are loose inside and exact at durable borders.
- **L15–L18:** witness separation, exposed principals, ergonomics as conformance, and principal-role symmetry are normative and testable.

### 0.4 Non-authorization clause

This specification does not authorize:

- implementation on `main` or any other branch;
- live provider calls;
- spending;
- secret opening;
- subject exposure;
- publication to a mirror-bound channel;
- classification of the 76 Language-A kimi records;
- adoption of a concrete channel-policy instance;
- creation of a standing authority-custody service;
- claims of independent primitive minimality.

A later owner act must authorize implementation.

---

## 1. Scope

Kernel /0 defines:

1. ordinary and consequential evaluation result classes;
2. principal and event-role semantics;
3. durable process identity and process-context requirements;
4. logical-operation, seat, attempt, request, and exposure identities;
5. per-axis determinacy;
6. the four-axis outcome algebra;
7. manifestation statuses and closed absence states;
8. generic effect declarations and irreversible-frontier rules;
9. opaque live capabilities, minting provenance, revocation, and restoration;
10. the abstract process-event and durable-store protocols;
11. deterministic fold obligations;
12. supersession, reconciliation, and no-blind-retry rules;
13. kernel-recognized protocols for claims, receipts, machine configurations, adapters, causal claims, and channel policies;
14. typed refusal and semantic-failure conditions;
15. inspection and canonical evidence export;
16. the ergonomic conformance surface required by L17.

Kernel /0 does not define:

- the complete byte syntax of the Mneme journal;
- provider-specific request formats;
- provider pricing;
- experiment preregistration;
- item banks or scoring constitutions;
- Language-A-specific outcome classes;
- domain causal vocabularies;
- a static effect type system;
- a general theorem prover;
- a universal agent framework;
- a metaphysics of latent state or machine consciousness.

---

## 2. Frozen and normative dependencies

### 2.1 Canonical Datum /0

Canonical Datum /0 is the required value substrate at every durable identity, evidence, receipt, journal, canonical comparison, and digest boundary.

Kernel /0 MUST NOT redefine Canonical Datum /0 equality or canonical octets.

A host value MAY remain ephemeral inside ordinary evaluation. Before crossing a durable boundary it MUST either:

1. already be a Canonical Datum /0 value; or
2. be converted by an identified canonicalization procedure whose result is a Canonical Datum /0 value.

Failure to canonicalize at a durable boundary MUST signal `noncanonical-durable-value`.  [F: HOST-2]

### 2.2 Located Claim Identity /0  [F: ID-3]

Located Claim Identity /0 is the required identity discipline for claims whose standing depends on source, version, scope, or location.

Kernel /0 recognizes a claim protocol. The field-rich canonical claim representation belongs to the LCI/0 library unless a later authorial act moves a smaller representation into the kernel.

Kernel /0 MUST preserve the distinction between:

- claim identity;
- claim content;
- claim origin;
- validation;
- integrity;
- scoped visibility;
- proposition-specific determinacy.

### 2.3 Common Lisp host  [F: HOST-1]

Kernel /0 is initially hosted in Common Lisp.

Host facilities MAY implement:

- packages;
- macros;
- conditions and restarts;
- filesystem access;
- process control;
- opaque runtime objects;
- the bootstrap evaluator.

Host behavior has no canonical standing until represented at a required boundary. The kernel MUST NOT rely on host hash order, float printing, `sxhash`, or `gensym` uniqueness for any durable identity or canonical octet.  [F: HOST-3]

### 2.4 Mneme /0 boundary

Mneme is Lisp+’s memory-and-continuity layer.

This specification defines the semantic event protocol and fold obligations that Mneme /0 MUST implement. The exact journal grammar, framing, durability mechanics, prefix validation algorithm, merge format, and filesystem layout are delegated to `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`.

Kernel /0 MUST NOT assume an unspecified journal byte layout.

---

## 3. Conformance classes

A system may claim one or more of the following:

### 3.1 Kernel evaluator conformance

A **Kernel /0 evaluator** implements the semantic domains, judgments, operations, typed conditions, and outcome laws in this document.

### 3.2 Mneme store conformance

A **Mneme /0 store** implements the abstract append, commit, read-prefix, validate-prefix, and fold source protocols required here and the exact rules of the later journal specification.

### 3.3 Adapter conformance

A **Kernel /0 adapter** implements the minimal adapter protocol in §18 and declares which external guarantees it can and cannot establish.

### 3.4 Reference API conformance

A **Lisp+ reference API** satisfies L17 and the conformance obligations in §24. It MUST make the lawful path the default supported path.

### 3.5 Full vertical conformance

A **full Kernel /0 vertical implementation** combines:

- evaluator;
- Mneme store;
- deterministic fake adapter;
- inspection surface;
- forced-kill specimen;
- adversarial and negative-control suite.

No component may claim the guarantees of another component it does not implement.

---

## 4. Core semantic domains

Kernel /0 recognizes the following abstract domains:

```text
Datum                  ; Canonical Datum /0 at durable boundaries
PrincipalId
Role
RoleAssignment
ProcessId
LogicalOperationId
SeatId
AttemptId
ExternalRequestId
ExposureId
MachineConfigurationId
ChannelPolicyId
CapabilityId
ClaimId
ReceiptId
ManifestationId
EffectId
StoreId
JournalId
ParserId
ProcedureId
Determinacy
ExecutionAxis
ManifestationAxis
EffectAxis
InterpretationAxis
Outcome
Condition
```

Identity values are not inferred from display names.

### 4.1 Identity requirements

Every durable identity MUST be:

- stable across process restart;
- canonically representable;
- comparable under one named equality relation;
- scoped sufficiently to prevent accidental collision;
- distinct from a host pointer, `gensym`, process-local address, or pretty-printed label.

Kernel /0 does not mandate UUIDs versus store-issued monotone identifiers. The implementation MUST declare its identity procedure and demonstrate restart stability.  [F: ID-1]

*(Merge disposition, adjudication 1: this synthesis keeps DRAFT-S's floor — declared procedure + restart stability + non-image-local identity — and does **not** import DRAFT-F ID-1's store-issued mandate, which would bar a valid content-addressed identity that is non-`gensym` and restart-stable but not store-issued. F conceded. The identity-domain requirement of ID-2 is carried by §4 (every durable identity carries its domain) and §4.2.)*

### 4.2 Identity non-equivalences  [F: ID-2]

The following are distinct even when a prototype happens to encode them similarly:

```text
logical operation ≠ seat
seat              ≠ attempt
attempt           ≠ external request
attempt           ≠ process
provider alias    ≠ resolved machine configuration
claim             ≠ datum
capability record ≠ live capability
```

Any API that accepts one of these where another is required MUST perform an explicit, receipt-bearing conversion or refuse.

---

## 5. Principals and roles

### 5.1 Principal  [F: PRN-1]

A principal is an identified participant capable of occupying one or more event roles.

Kernel /0 MUST NOT encode “operator,” “human,” “machine,” “model,” or “agent” as mutually exclusive ontological species.

### 5.2 Initial role vocabulary

The initial role vocabulary includes:

```lisp
:invoker
:invoked-configuration
:process-subject
:witness
:grader
:verifier
:capability-minter
:restoration-delegate
:secret-recipient
:publisher
:owner
:owner-delegate
:adapter
:store
```

Libraries MAY add roles.

### 5.3 Role assignment

A role assignment MUST bind:

- event or process scope;
- principal identity;
- role;
- source of assignment;
- effective interval or version where applicable.

One principal MAY occupy several roles. Several principals MAY occupy one role.

### 5.4 Principal-role symmetry law  [F: PRN-3]

Self-invocation and kin-invocation are ordinary cases.

An invoker that exposes a secret to its own context MUST be recorded among the exposed principals. The invoker’s blindness is not preserved by syntactic self-distance.

---

## 6. Logical operations, seats, attempts, and requests  [F: ATT-1]

### 6.1 Logical operation

A logical operation identifies the abstract work intended independent of any concrete execution effort.

Example: “obtain one manifestation for item X under configuration Y.”

### 6.2 Seat

A seat identifies stable occupancy for a logical operation within a bank, run, workflow, or other declared domain.

A seat MUST have:

- `seat-id`;
- `logical-operation-id`;
- occupancy domain identity;
- configuration or policy constraints where required.

Seat occupancy is derived from process evidence. It MUST NOT be a mutable boolean treated as sole truth.  [F: ATT-2]

### 6.3 Attempt

An attempt is one concrete effort to perform a logical operation in a seat.

An attempt record MUST bind:

```lisp
(:attempt-id ...
 :logical-operation-id ...
 :seat-id ...
 :process-id ...
 :predecessor-attempts (...)
 :exposure-id ...
 :machine-configuration-id ...
 :external-request-id ...       ; optional until known
 :supersession-records (...))
```

### 6.4 External request

An external request identity is the identity assigned by a provider, tool, adapter, or idempotency domain.

Absence of an external request identity MUST be representable and MUST reduce the strength of reconciliation claims where relevant.

### 6.5 Exposure identity

An exposure identity names the event of presenting protected or blinded subject material to one or more principals or external systems.

A fresh attempt does not automatically inherit an old exposure identity. Re-exposure MUST be explicit.

### 6.6 Uniqueness and collision

Attempt identities MUST be unique within their declared identity domain.

A duplicate attempt identity MUST signal `duplicate-attempt-identity` before any consequential frontier.

A seat already occupied by a non-superseded completed or unresolved attempt MUST signal `seat-occupied` unless a lawful reconciliation or supersession operation is in progress.

---

## 7. Determinacy

### 7.1 Determinacy modes

Every outcome axis carries exactly one determinacy record.

The modes are:

```lisp
(:mode :determinate
 :evidence (...))

(:mode :bounded
 :alternatives (...)
 :evidence (...))

(:mode :indeterminate
 :evidence (...))
```

### 7.2 Determinate

`:determinate` means the recorded evidence licenses exactly one current axis value under the named procedure.

It does not mean metaphysical certainty.

### 7.3 Bounded

`:bounded` MUST include a finite, non-empty, duplicate-free sequence of named alternatives.

The current evidence licenses one of those alternatives but does not establish which.

### 7.4 Indeterminate

`:indeterminate` means the kernel cannot currently provide a lawful finite alternative set under the available evidence and procedure.

### 7.5 No global uncertainty scalar

Kernel /0 MUST NOT attach one outcome-level `confidence`, `uncertainty`, or `probability` scalar as a substitute for per-axis determinacy.

Libraries MAY attach probabilistic claims as claims, provided they identify proposition, procedure, calibration scope, and evidence.

---

## 8. Manifestations

### 8.1 Manifestation identity

A manifestation is an interface-visible product or an explicitly recorded absence relation.

A manifestation record MUST bind:

- manifestation identity;
- attempt identity;
- kind;
- status;
- payload identity or absence state as required;
- source boundary;
- adapter or producer identity;
- sequence/chunk relation for streams;
- parser identity when invalidity is asserted;
- visibility scope where applicable.

### 8.2 Closed status algebra  [F: MAN-1]

Kernel /0 manifestation statuses are:

```lisp
:present
:present-empty
:present-invalid
:present-partial
:absent
:withheld
:redacted
```

This status set is closed for Kernel /0.

### 8.3 Presence before validity

A payload that exists is present even if empty, malformed, semantically useless, or rejected by a parser.

Kernel /0 MUST preserve payload identity for:

- `:present`;
- `:present-empty`;
- `:present-invalid`;
- `:present-partial`.

### 8.4 Present-empty

`:present-empty` requires:

- an observed payload at the declared manifestation location;
- a payload identity;
- an identified emptiness rule appropriate to the manifestation kind.

It MUST NOT be used for a missing field or explicit no-manifestation marker.

### 8.5 Present-invalid

`:present-invalid` requires:

- preserved payload identity;
- parser or validator identity;
- version or procedure identity;
- an interpretation result establishing invalidity under that procedure.

Invalidity is procedure-relative and MUST NOT erase the payload.

### 8.6 Present-partial

`:present-partial` is a real, identified manifestation before final settlement.

It MAY:

- be read;
- leak;
- incur cost;
- expose protected material;
- survive process death.

A partial manifestation MUST NOT be silently promoted to `:present` merely because no later chunk arrives.

### 8.7 Closed no-visible-payload states  [F: MAN-3]

Kernel /0 preserves Architecture 0.1's closed state vocabulary:

```lisp
:never-attempted
:refused-pre-effect
:absent-after-completion
:withheld
:redacted
:not-applicable
```

The status/state mapping is normative:

- status `:absent` permits `:never-attempted`, `:refused-pre-effect`, `:absent-after-completion`, or `:not-applicable`;
- status `:withheld` requires state `:withheld`;
- status `:redacted` requires state `:redacted`.

Withholding and redaction do not claim that no manifestation relation exists. They state that a relation exists while payload visibility is restricted.

### 8.8 Envelope versus subject manifestation  [F: MAN-2]

A provider response envelope and the subject-answer manifestation are distinct.

A present provider envelope may contain:

- present subject content;
- present-empty subject content;
- present-invalid subject content;
- absent subject content;
- withheld or redacted subject content.

Provider usage, reasoning metadata, finish reason, and protocol fields are not automatically the subject manifestation.

An adapter MUST return references to **both** the envelope and the subject manifestation. The kernel MUST NOT derive the subject-manifestation status by inspecting envelope bytes itself: that projection is the adapter's declared, versioned procedure (§18.2, §27.2). This preserves DK-2's two-level law — envelope ≠ subject — at the kernel/adapter seam. *(Repair 4, adjudication 5: kernel envelope-projection prohibition, from DRAFT-F MAN-2; A0.1 §6.7 closing law.)*

### 8.9 Causal diagnosis  [F: CAU-1, CAU-2]

A cause is not a manifestation status.

Examples such as:

- budget exhausted before visible output;
- safety mediation suppressed output;
- parser rejected malformed structure;
- process died before flush;

MUST be represented as causal claims with evidence and standing, not new absence-state enum members.

#### 8.9.1 Causal-claim protocol (normative)

*(Repair 1, adjudication 5: the causal-claim protocol DRAFT-S referenced loosely is made normative here, from DRAFT-F CAU-1/CAU-2 with the shape of A0.1 §6.9.2.)*

A causal claim attaches to a manifestation state **by reference**. It MUST carry:

```lisp
(make-causal-claim
  :subject      manifestation-id   ; the state being explained
  :predicate    ...                ; the diagnosis, e.g. :budget-exhausted-before-visible-output
  :evidence     (evidence-id ...)  ; references licensing the claim
  :origin       ...                ; A0.1 §6.3.1 origin facet (:asserted|:observed|:derived|:reconstructed)
  :validation   ...)               ; A0.1 §6.3.2 validation facet, e.g. (:checked :by adapter-id)
```

- **CAU-1.** A causal claim MUST bind subject identity, predicate, evidence references, an origin facet, and a validation facet. A cause MAY be `:unestablished`, contested, or later revised.
- **CAU-2 (revision invariance).** Revising or refuting a causal claim MUST NOT alter any manifestation state, deterministic fold, or census-class derived from states. "No answer appeared" is state; "the budget ran out before visible output" is diagnosis — the diagnosis may move without the state moving (A0.1 §6.9.2).

A constructor that accepts a "cause" argument on the absence state itself MUST NOT exist (§8.7, MAN-3): the two levels stay separate — closed state, open cause.

---

## 9. Four-axis outcomes

### 9.1 Outcome schema  [F: OUT-1, OUT-6]

Every consequential synchronous operation returns a structured outcome. Every long-running process handle MUST eventually expose the same outcome protocol.

A Kernel /0 outcome MUST include:

```lisp
(:outcome-version 0
 :process-id ...
 :logical-operation-id ...
 :seat-id ...
 :attempt-id ...
 :machine-configuration-id ... ; when applicable
 :execution (...)
 :manifestation (...)
 :effects (...)
 :interpretation (...)
 :receipts (...)
 :bounded-unknowns (...))
```

### 9.2 Execution axis  [F: OUT-2]

Execution values are:

```lisp
:not-attempted
:refused
:failed
:completed
:cancelled
:indeterminate
```

Rules:

1. `:refused` is pre-frontier.
2. A post-frontier termination MUST NOT be rewritten as refusal.
3. `:failed`, `:cancelled`, `:completed`, or `:indeterminate` MAY carry `:pre-frontier` or `:post-frontier` qualifiers where meaningful.
4. `:indeterminate` as a value class and `:indeterminate` determinacy are related but distinct: the value says the lawful execution class is indeterminate; the determinacy says the standing of that classification is itself indeterminate.

### 9.3 Manifestation axis

The manifestation axis contains:

- a manifestation reference; or
- `(:absent :state <absence-state>)`;
- one determinacy record.

### 9.4 External-effect axis  [F: OUT-3]

Effect values are:

```lisp
:not-entered
:prepared
:crossed
:settled
:compensated
:bounded
:indeterminate
```

An effect axis MUST identify the declared effect set or effect group it summarizes.

`:bounded` MUST include named alternatives and evidence.

A `:bounded` or `:indeterminate` effect axis MUST reference a **structured uncertain-effect record** (§10.8) — the kernel primitive that carries the no-blind-retry guarantee across a restart (A0.1 §12.1 primitive 10, §6.10). Constructing a `:bounded`/`:indeterminate` effect axis that carries alternatives and evidence **inline only**, without referencing such a record, MUST signal `condition:unstructured-uncertainty`. *(Repair 2, adjudication 2 — adopt-F OUT-3 + A0.1 §6.10 field shape; the chair's highest-value merge.)*

### 9.5 Interpretation axis  [F: OUT-4]

Interpretation values are:

```lisp
:not-attempted
:not-applicable
:accepted
:rejected
:invalid
:refused
:indeterminate
```

Any value other than `:not-attempted` or `:not-applicable` MUST name the parser, rubric, validator, policy, or procedure relative to which the interpretation holds.

### 9.6 Axis independence  [F: OUT-5]

The kernel MUST permit, among others:

- completed execution with absent manifestation;
- failed execution with present-partial manifestation;
- completed execution with present-invalid manifestation;
- determinate execution with bounded effect settlement;
- bounded manifestation with determinate interpretation-not-applicable;
- present provider envelope with absent subject manifestation.

No axis may infer another without an explicit domain procedure and resulting claim or receipt.

Independence is not lawlessness. The following **kernel-checked invariants** hold across the axes, each with a fixture and a planted violation *(adjudication 5, from DRAFT-F OUT-5 — the interpretation-requires-present invariant DRAFT-S left implicit)*:

- execution `:not-attempted` ⇒ external-effect `:not-entered` **and** manifestation absence-state `:never-attempted`;
- manifestation `:present*` (`:present`, `:present-empty`, `:present-invalid`, `:present-partial`) ⇒ a payload identity exists;
- ordinary interpretation `:accepted` or `:rejected` REQUIRES manifestation `:present` or `:present-empty` under the named procedure's declared domain — the kernel MUST NOT record an interpretation that accepted or rejected an **absent** manifestation.

---

## 10. Effects and frontiers

### 10.1 Effect declaration

A consequential operation MUST declare its effects before the frontier.

The initial generic effect vocabulary includes:

```lisp
:provider-call
:spend
:secret-open
:publication
:external-write
:tool-action
```

Libraries MAY refine these with structured parameters.

### 10.2 Effect classes

An effect declaration MUST classify each effect as one of:

```lisp
:pure
:replay-safe
:compensable
:irreversible
:epistemic
:constitutive
```

One effect MAY occupy several classes, for example `:secret-open` is epistemic and often irreversible.

### 10.3 Frontier

A frontier is the last point at which the operation can still refuse without having caused the declared consequential effect.

The normative progression is:

```text
PREPARED
→ FRONTIER-CROSSED
→ SETTLED | COMPENSATED | BOUNDED | INDETERMINATE
```

### 10.4 Pre-frontier closure  [F: OP-1]

Before crossing, the kernel MUST establish or refuse on:

- resolved process, operation, seat, and attempt identities;
- resolved machine configuration where applicable;
- resolved channel and destination where applicable;
- live unrevoked capability;
- capability scope;
- budget and call count;
- no illegal occupied target;
- no unresolved predecessor effect that forbids dispatch;
- adapter and policy version compatibility;
- required durable sink availability;
- required exposed-principal consequences;
- live-path preconditions practicable before spend or exposure.

The invocation preflight MUST use a declared, deterministic, dependency-respecting order *(R-SYN-3, replacing the adjudication-5 total order from DRAFT-F OP-1, whose first check — scope — could not lawfully precede resolution of its own operands)*. At minimum:

1. resolve the minimum identities required to identify the requesting principal, operation, capability, and requested effect;
2. establish capability presence, liveness, revocation standing, and expiry before any probe that itself requires authority;
3. resolve all remaining identities required to evaluate scope, including machine configuration, seat, attempt, channel, and destination where applicable (§16, CFG-1);
4. evaluate effect authorization and capability scope against those resolved identities;
5. check seat occupancy, attempt legality, idempotency identity, and unresolved predecessor effects;
6. check budget and call count;
7. check destination availability and retry policy;
8. perform execution-path closure (L12 — §10.5);
9. cross the frontier only after all required checks succeed.

Independent, pure checks MAY be reordered to obtain cheaper refusal, provided no scope-dependent check precedes resolution of its operands, no authority-requiring probe precedes the relevant authority check, and the effective order remains inspectable. Each failure MUST produce its own typed condition and external-effect value `:not-entered`. The frontier is not crossed on any refusal.

### 10.5 Execution-path closure

If a live-only path can fail after spend, exposure, publication, or external mutation, and the failure can be exercised or faithfully simulated before the frontier, the implementation MUST do so.

An untested path that begins only after spend is an uncovered consequential path, not a verified path.

### 10.6 No implicit fallback

Changing any of the following changes operation identity unless a frozen policy explicitly says otherwise:

- provider;
- route;
- model API identifier;
- renderer;
- parser;
- destination;
- channel policy;
- tool;
- secret source;
- retry policy.

Kernel /0 MUST refuse implicit fallback.

### 10.7 Epistemic effect  [F: PRN-2]

A secret-opening or subject-exposure effect record MUST name:

- protected object identity;
- exposing action;
- receiving principals;
- exposure scope;
- direct, relayed, or inferred mode;
- evidence;
- restrictions induced on later roles.

“Someone now knows” without naming who is nonconforming.

### 10.8 Uncertain-effect record (structured kernel primitive)

*(Repair 2, adjudication 2: A0.1 §12.1 makes the structured uncertain-effect value a **kernel primitive** (primitive 10); its shape is A0.1 §6.10. DRAFT-S carried alternatives and evidence inline in §9.4/§14.1; this synthesis binds the record and the `condition:unstructured-uncertainty` refusal, from DRAFT-F OUT-3/UNC-1.)*

A structured uncertain-effect record represents bounded or indeterminate settlement on the external-effect axis. It MUST carry:

```lisp
(uncertain-effect
  :kind                     ...                 ; e.g. :provider-call
  :attempt                  attempt-id
  :external-request         request-id          ; or (:unavailable :reason ...) when no identity exists
  :possible-effects         (... ...)           ; named, finite, duplicate-free alternatives, e.g. (:billed :not-billed)
  :known-facts              (evidence-id ...)
  :reconciliation-procedure reconciliation-id
  :retry-policy             :forbidden-without-reconciliation)  ; default
```

- **UNC-1.** The fields above are MUST-carry. The default retry-policy is `:forbidden-without-reconciliation`, and the kernel MUST refuse (`condition:unsafe-retry`) any dispatch into a seat holding an unresolved uncertain effect (§14.1).
- A `:bounded`/`:indeterminate` effect axis (§9.4) MUST reference such a record; an inline-only construction MUST signal `condition:unstructured-uncertainty`.
- **UNC-2.** Resolution happens **only** by a reconciliation transformation carrying evidence (provider identifiers first, per the sealed call-296 protocol) or by an authorized supersession (§14.3) — never by timeout, never by default (§14.2, §14.4).

The default law forbids blind retry across an unresolved irreversible effect: the record is what carries that prohibition across a process restart.

---

## 11. Live capabilities

### 11.1 Capability semantics  [F: CAP-1]

A capability is an opaque live authority object.

A capability MUST contain or securely reference:

- capability identity;
- effect classes authorized;
- scope predicate;
- minter principal;
- authorizing claim or policy identity;
- minting receipt identity;
- restoration delegates named at mint time;
- revocation registry;
- expiry or effective interval where applicable;
- predecessor capability identity where restored.

### 11.2 Opaqueness

A capability MUST NOT be reconstructible from serialized public fields.

Durable records MAY preserve:

- public capability identity;
- fingerprint;
- historical scope description;
- minting receipt;
- predecessor lineage;
- current requirement for resumption.

These records do not grant authority.

### 11.3 Minting bridge  [F: CAP-2]

A sealed ruling or policy claim MAY authorize minting. It is not itself a capability.

The minting operation MUST:

1. validate the authorizing claim identity and standing required by policy;
2. derive scope under an identified procedure;
3. identify minter and delegates;
4. create the live opaque capability;
5. emit a minting receipt.

### 11.4 Capability check

The frontier check MUST establish:

- capability is live;
- capability is unrevoked;
- capability has not expired;
- requested effect is authorized;
- requested scope is within capability scope;
- budget and count limits remain;
- principal role is permitted;
- unresolved-effect restrictions are satisfied.

### 11.5 Defensive scope handling

Capability scope values exposed through the client API MUST be defensively copied or immutable.

Mutation of a returned scope object MUST NOT mutate live authority.

### 11.6 Revocation  [F: CAP-4]

Revocation MUST be checked at every consequential frontier.

The kernel MUST distinguish:

- historical validity at mint time;
- current revocation state;
- effect already crossed before revocation;
- future authority after revocation.

### 11.7 Restoration  [F: CAP-3]

After suspension, only:

- the original minter; or
- a restoration delegate named in the minting record

may restore authority.

Restoration MUST:

1. create a new capability identity;
2. link it to the predecessor;
3. emit a restoration receipt;
4. recheck revocation;
5. recheck unresolved irreversible effects;
6. grant equal or narrower scope;
7. refuse self-restoration by the suspended process.

A domain policy MAY require a fresh owner act for sensitive capability classes.

---

## 12. Evaluation judgments

### 12.1 Ordinary evaluation

The ordinary judgment is:

```text
Γ ⊢ e ⇓ v
```

where:

- `Γ` is the lexical and dynamic environment;
- `e` is an ordinary form;
- `v` is an ordinary Lisp value.

Ordinary evaluation crosses no consequential frontier and emits no required process transition.

### 12.2 Consequential evaluation

The consequential judgment is:

```text
Γ ; Π ; Α ; Ρ ; Σ ⊢ e ⇓ r ; Δ
```

where:

- `Γ` is the lexical and dynamic environment;
- `Π` is the process context;
- `Α` is the live authority set;
- `Ρ` is the principal-role assignment;
- `Σ` is the abstract durable-store state visible to the kernel;
- `e` is a consequential form;
- `r` is a structured outcome or process handle;
- `Δ` is the ordered sequence of required proposed or committed events and receipts.

### 12.3 Consequential form classification

A form is consequential if it may:

- cross an external effect frontier;
- spend money or quota;
- expose a secret or subject;
- publish or mutate externally visible state;
- create or restore live authority;
- change durable process history;
- supersede or reconcile an attempt.

A library MUST NOT disguise a consequential form as ordinary evaluation merely because the effect occurs inside a host function.

### 12.4 Synchronous result

A short consequential form returns an outcome directly.

### 12.5 Resumable result

A long-running form returns a process handle.

A process handle MUST expose:

- process identity;
- fold-derived state;
- current settled events;
- partial manifestations;
- suspension and cancellation requests;
- reconciliation and supersession operations;
- eventual outcome protocol.

### 12.6 Refusal

Refusal is a successful safety behavior before the frontier.

A refusal MUST:

- signal a typed condition or return a typed refusal outcome according to the operation contract;
- emit no frontier-crossed event;
- preserve diagnostic evidence;
- state which precondition failed.

### 12.7 Failure

Failure after the frontier is not refusal.

A post-frontier failure MUST preserve:

- attempt identity;
- frontier evidence;
- partial manifestations;
- effect determinacy;
- retry prohibition or reconciliation requirement.

---

## 13. Process event protocol

### 13.1 Event standing  [F: JRN-1]

A process event is a canonicalizable record proposed to or committed by a Mneme store.

A process event is a canonicalizable record proposed to or committed by a Mneme store. A conforming Mneme journal MUST expose a normative, human-readable S-expression representation of every committed event sufficient for inspection and evidence replay. The canonical reference journal SHALL use human-readable S-expressions. A binary-only representation with no normative S-expression rendering is nonconforming. Exact S-expression grammar, storage framing, canonical byte conversion, record delimiters, length prefixes, and atomicity mechanisms are delegated to `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`. *(R-SYN-2, replacing the adjudication-3 merge text, which bound "one record per line or form / no binary framing" — framing constraints — while claiming to defer framing. Readability is a kernel conformance property; framing is the journal spec's representation decision.)* The semantic fields below are normative.

### 13.2 Required event fields  [F: JRN-2, OP-2]

Every committed event MUST contain:

```lisp
(:event-version 0
 :event-id ...
 :event-type ...
 :process-id ...
 :predecessor-event-id ...       ; absent only for genesis
 :actor-principal-id ...
 :role-assignments (...)
 :payload <Canonical-Datum/0>
 :durability-claim ...
 :store-id ...)
```

When relevant it MUST also contain:

```lisp
:logical-operation-id
:seat-id
:attempt-id
:external-request-id
:exposure-id
:capability-fingerprint
:machine-configuration-id
:effect-id
:manifestation-id
:receipt-ids
```

The journal ordinal is the authoritative order. Wall-clock timestamps MAY ride as observations and **MUST NOT** participate in ordering (A0.1 §9.4). *(Adjudication 6, merge: DRAFT-S excludes timestamp ordering structurally via predecessor linkage; this restates A0.1's guard as a legible MUST — DRAFT-F JRN-2.)*

**Incremental durability (L8).** After the frontier is crossed, transitions MUST persist incrementally; the kernel MUST NOT hold a settled consequential fact only in memory across an await. *(Adjudication 6, merge: DRAFT-S enforces this structurally through the append-only model; this restates A0.1's L8 guard as a legible MUST — DRAFT-F OP-2.)*

### 13.3 Initial event vocabulary

Kernel /0 recognizes:

```lisp
:process-created
:process-authorized
:seat-reserved
:attempt-begun
:effect-prepared
:frontier-crossed
:request-acknowledged
:manifestation-recorded
:effect-settled
:effect-bounded
:effect-indeterminate
:attempt-refused
:attempt-failed
:attempt-completed
:attempt-cancelled
:process-suspended
:capability-restored
:attempt-reconciled
:attempt-superseded
:derived-view-recorded
:artifact-committed
```

Libraries MAY define extension events. Extension events MUST NOT alter the semantics of kernel events.

### 13.4 Genesis

The first event in a process journal MUST be `:process-created`.

It establishes:

- process identity;
- creator principal;
- process protocol version;
- store identity;
- initial role assignments.

### 13.5 Transition legality  [F: JRN-7]

The fold MUST reject illegal sequences.

At minimum:

- an attempt cannot begin before seat reservation unless the operation explicitly has no seat;
- a frontier cannot be crossed before effect preparation;
- refusal cannot follow frontier crossing;
- completion cannot erase an unresolved bounded effect;
- supersession cannot erase predecessor evidence;
- restoration cannot precede suspension or capability loss;
- a terminal attempt cannot receive a second terminal event except through reconciliation metadata that does not rewrite history.

### 13.6 Terminal attempt states

Attempt terminal classes are:

```lisp
:refused
:failed
:completed
:cancelled
:indeterminate
:superseded
```

`:superseded` is a lineage state, not evidence that the predecessor did not occur.

### 13.7 Fold-derived state

Current state MUST be derived by a deterministic fold over the longest prefix-valid journal.

No mutable current-state cache outranks the fold. A cache MAY accelerate inspection but MUST be invalidated when its source prefix identity changes.

### 13.8 Torn tails  [F: JRN-3]

The kernel store interface MUST make a torn or incomplete trailing record visible.

The fold:

- includes the longest valid committed prefix;
- excludes the torn trailing record from committed state;
- preserves the torn record as evidence;
- produces bounded determinacy when the tail could contain a consequential settlement record that cannot be recovered.

---

## 14. Supersession, reconciliation, and retry

### 14.1 No blind retry  [F: UNC-1]

An unresolved irreversible effect forbids blind replay.

The kernel MUST signal `unsafe-retry` when an operation attempts to reuse a seat or logical operation while a predecessor attempt has bounded or indeterminate effect settlement and no lawful reconciliation or supersession exists.

### 14.2 Reconciliation  [F: UNC-2]

Reconciliation is an identified procedure that uses new evidence to refine one or more axes of a prior attempt.

A reconciliation receipt MUST identify:

- target attempt;
- procedure and version;
- new evidence;
- previous axis values and determinacy;
- resulting axis values and determinacy;
- unresolved residue.

Reconciliation MUST NOT rewrite old events. It appends a new event and receipt.

### 14.3 Supersession  [F: ATT-3]

Supersession authorizes a new attempt in relation to a predecessor.

A supersession record MUST name:

- predecessor attempt;
- superseding attempt;
- authorizing claim or capability;
- reason;
- whether the new attempt is a fresh exposure;
- precedence rule if both results surface;
- treatment of costs and effects;
- unresolved predecessor residue.

### 14.4 Supersession does not cleanse uncertainty  [F: ATT-4]

A superseded attempt remains in its historical state.

If its effect was bounded, it remains bounded until reconciliation resolves it. Supersession does not turn a possibly billed call into an unattempted seat.

### 14.5 Idempotency

An adapter MAY declare provider-enforced idempotency.

The declaration MUST identify:

- idempotency domain;
- key identity;
- guarantee scope;
- expiry;
- duplicate-response behavior;
- evidence source.

A caller-provided idempotency key without provider guarantee is not proof of idempotency.

---

## 15. Claims, receipts, and witness separation

### 15.1 Claim protocol

A kernel-recognized claim object MUST provide access to:

- claim identity;
- claim content datum;
- source identities;
- origin;
- validation records;
- integrity records;
- scoped visibility records;
- proposition-specific determinacy;
- bounded unknowns.

### 15.2 Origin

Initial origins are:

```lisp
:asserted
:observed
:derived
:reconstructed
```

Origin is historical and MUST NOT be rewritten by later validation.

### 15.3 Witness separation

A process’s unaided account of its own history is `:asserted`.

It acquires `:observed` origin only through a distinct witnessing mechanism whose:

- identity;
- capture boundary;
- integrity;
- relation to the event

are inspectable.

A self-written narrative remains asserted wherever it is filed.

### 15.4 Kernel journal as witness

The kernel-mediated process journal is the default witness for kernel-mediated transitions because the transition substrate records events at the boundary.

A library MUST NOT call arbitrary model prose a “journal” and thereby grant observational standing.

### 15.5 Transformation receipt protocol  [F: RCP-1]

A transformation receipt MUST provide:

- receipt identity;
- procedure identity and version;
- input identities;
- output identities;
- acting principal;
- machine configuration where applicable;
- authority reference where required;
- predecessor receipts;
- effect summary;
- losses, abstractions, or mode changes;
- bounded unknowns;
- integrity evidence.

### 15.6 No standing inflation

Kernel /0 MUST refuse or mark invalid any transformation that silently promotes:

- asserted to observed;
- reconstructed to observed;
- sealed to verified;
- published to true;
- parser-valid to semantically accepted;
- receipt-present to effect-settled.

### 15.7 Reconstruction  [F: JRN-6]

A reconstructed claim retains origin `:reconstructed` after verification.

Verification may strengthen validation and integrity only.

---

## 16. Machine configuration identity

### 16.1 Required protocol  [F: CFG-1]

A machine configuration MUST identify, where applicable:

- provider;
- route;
- exact API model identifier;
- resolved provider-reported identity;
- renderer and version;
- system/developer instruction identities;
- tool schema identities;
- decoding and sampling controls;
- reasoning allocation;
- token and cost ceilings;
- retry policy;
- output parser;
- mediation layer where observable;
- adapter implementation identity;
- acting and exposed principals.

### 16.2 Alias rule

A marketing name or local alias is a designation, not sufficient machine identity.

The resolved identifier available at dispatch MUST be recorded.

### 16.3 Drift

If the live configuration differs from the authorized configuration in any controlling field, the kernel MUST signal `machine-configuration-drift` before the frontier.

A declared policy MAY authorize a bounded substitution, but the substitution MUST produce a new configuration identity and receipt.

---

## 17. Channel policy and publication

### 17.1 Channel policy protocol  [F: CHN-1]

A channel policy MUST provide:

```lisp
(:channel-policy-id ...
 :source-scope ...
 :destinations ((... :visibility ...))
 :authorized-principals (...)
 :propagation-mode ...
 :amendment-authority ...
 :effective-version ...)
```

### 17.2 Policy informs; capability authorizes

A channel policy tells the kernel what effects a write or commit entails. It does not itself grant authority.

A commit to a declared mirror-bound path requires a live capability whose scope includes:

- durable write to the source channel;
- publication to every declared destination scope.

### 17.3 Commit frontier

For a declared mirror-bound path, the deliberate commit is the publication frontier.

The later sync is mechanical settlement.

### 17.4 Policy amendment

Making a path mirror-bound is a policy amendment.

It MUST:

- be performed under amendment authority;
- create a new policy identity or version;
- re-confirm authorized principals;
- not silently enlarge existing commit capabilities.

### 17.5 Private staging

A conforming environment MUST provide a genuinely private staging channel not covered by an automatic publication policy.

---

## 18. Adapter protocol boundary

The full adapter contract is specified later. Kernel /0 requires the following minimum protocol.

### 18.1 Adapter identity

An adapter MUST expose a stable implementation identity and version.

### 18.2 Adapter declaration  [F: ADP-1]

Before invocation, an adapter MUST declare whether it can establish:

- external request identity;
- provider idempotency;
- reconciliation;
- usage reporting;
- cost reporting;
- resolved model identity;
- cancellation;
- partial streaming;
- stream durability;
- parser behavior;
- exposed-principal boundary;
- acknowledgment semantics.

Unknown capability MUST be declared unknown, not assumed absent or present.

### 18.3 Fake adapter  [F: K-3, ADP-2]

The first implementation MUST include a deterministic fake adapter capable of producing every Kernel /0 terminal fixture without network access.

The fake adapter MUST support controlled injection of:

- refusal before frontier;
- failure after frontier;
- present output;
- present-empty output;
- present-invalid output;
- absent-after-completion;
- partial stream then kill;
- bounded billing effect;
- delayed acknowledgment;
- duplicate request identity;
- configuration drift.

### 18.4 Adapter may not mint truth

An adapter may establish invocation and transport facts. It MUST NOT mint semantic verification of model-emitted claims unless it separately occupies an authorized verifier role under an identified procedure.

---

## 19. Kernel operations

The following operation names are normative roles. Exact macro/function signatures MAY vary only if equivalent semantics and L17 conformance are demonstrated.

### 19.1 Process operations

```lisp
(create-process ...)
(authorize-process ...)
(inspect-process ...)
(suspend-process ...)
(resume-process ...)
(cancel-process ...)
```

### 19.2 Seat and attempt operations

```lisp
(reserve-seat ...)
(begin-attempt ...)
(inspect-attempt ...)
(reconcile-attempt ...)
(supersede-attempt ...)
```

### 19.3 Effect operations

```lisp
(prepare-effect ...)
(cross-frontier ...)
(settle-effect ...)
(record-bounded-effect ...)
(record-indeterminate-effect ...)
(compensate-effect ...)
```

### 19.4 Manifestation operations

```lisp
(record-manifestation ...)
(record-partial-manifestation ...)
(record-absent-manifestation ...)
(preserve-invalid-manifestation ...)
```

### 19.5 Capability operations

```lisp
(mint-capability ...)
(check-capability ...)
(revoke-capability ...)
(restore-capability ...)
```

### 19.6 Outcome operations

```lisp
(make-outcome ...)
(outcome-axis ...)
(match-outcome ...)
(with-outcome ...)
```

### 19.7 Claim and receipt operations

```lisp
(make-claim ...)
(make-transformation-receipt ...)
(record-validation ...)
(record-integrity ...)
(record-visibility ...)
(explain ...)
(export-canonical-evidence ...)
```

### 19.8 Consequential invocation

The default supported invocation form MUST combine:

- attempt allocation or explicit attempt validation;
- capability check;
- effect preparation;
- journal append;
- adapter dispatch;
- partial manifestation recording;
- effect settlement recording;
- structured outcome production.

A raw provider invocation MUST be visibly unsafe and outside the conforming public surface.

### 19.9 Journal and reconstruction operations  [F: JRN-5]

*(Repair 3, adjudication 5: the finalizer law's operational half — DRAFT-S enforces re-derivability via the fixture suite (§25.5 test 40); this synthesis names the operations in the kernel op set, from DRAFT-F JRN-5/§6.)*

```lisp
(journal-append ...)      ; append one transition, return ordinal
(fold-state ...)          ; deterministic fold over the longest prefix-valid journal → current state
(reconstruct ...)         ; re-derive a fold-derived summary from primary records alone → view + reconstruction-receipt
(merge-journals ...)      ; cross-journal reconstruction transformation with a receipt (never an implicit timestamp sort)
```

**Finalizer re-derivability (body-law).** Any fold-derived summary a finalizer produces MUST be re-derivable by `reconstruct` from the primary records alone. A finalizer is a convenience, not the sole custodian of truth (A0.1 §9.5): it MUST NOT possess unique primary facts required to reconstruct the process. The fixture suite MUST include finalizer-loss recovery — kill before finalize → `reconstruct` → byte-compare where determinism is declared (§25.5 test 40).

---

## 20. Typed conditions

### 20.1 General condition requirements  [F: CND-1]

Every kernel condition MUST expose:

- condition type;
- process identity where known;
- attempt and seat identity where known;
- operation identity;
- failed invariant;
- evidence identities;
- whether the frontier was crossed;
- permitted restarts, if any.

Generic untyped `error` is nonconforming for a specified kernel refusal.

### 20.2 Identity conditions

```lisp
unresolved-identity
duplicate-process-identity
duplicate-seat-identity
duplicate-attempt-identity
duplicate-external-request-identity
seat-occupied
attempt-terminal
identity-drift
```

### 20.3 Authority conditions

```lisp
capability-missing
capability-revoked
capability-expired
capability-scope-mismatch
capability-budget-exceeded
capability-count-exceeded
capability-restoration-denied
capability-self-restoration-forbidden
capability-restoration-scope-enlarged
minting-authority-invalid
```

### 20.4 Effect and retry conditions

```lisp
frontier-precondition-failed
frontier-already-crossed
unresolved-irreversible-effect
unsafe-retry
unstructured-uncertainty
implicit-fallback-forbidden
supersession-required
supersession-unauthorized
reconciliation-unsupported
reconciliation-insufficient
```

### 20.5 Manifestation and interpretation conditions

```lisp
manifestation-payload-missing
present-payload-erasure
invalidity-parser-missing
partial-manifestation-settlement-inflation
interpretation-procedure-missing
```

### 20.6 Store and journal conditions

```lisp
store-unavailable
store-append-failed
store-durability-unknown
journal-prefix-invalid
journal-torn-tail
journal-illegal-transition
journal-merge-receipt-required
fold-nondeterministic
```

### 20.7 Standing conditions

```lisp
standing-inflation
witness-separation-violation
reconstruction-origin-erasure
bare-visibility-scope
bare-validation-scope
exposed-principal-missing
```

### 20.8 Boundary conditions

```lisp
noncanonical-durable-value
machine-configuration-drift
adapter-version-drift
channel-policy-missing
channel-policy-amendment-unauthorized
publication-authority-missing
outcome-context-discard
unsafe-host-escape
unsupported-reconstruction
```

### 20.9 Restarts  [F: CND-2]

A restart MUST NOT cross a consequential frontier unless it re-enters all required checks.

The following are prohibited as implicit restarts:

- “retry anyway” across unresolved effect;
- “ignore revocation”;
- “coerce missing identity”;
- “treat reconstructed as observed”;
- “drop invalid payload”;
- “publish without capability”;
- “restore old capability object.”

Permitted restarts MAY include:

- supply resolved identity before frontier;
- choose private staging channel;
- request lawful capability restoration;
- begin reconciliation;
- authorize explicit supersession;
- preserve payload and mark interpretation invalid;
- stop and export evidence.

---

## 21. Inspection and evidence export

### 21.1 Inspection is semantic

Inspection is not a debugging convenience. It is part of Kernel /0 conformance.

A conforming inspector MUST expose:

- identities and role assignments;
- current fold-derived process state;
- journal prefix identity;
- torn-tail evidence;
- attempts and supersession lineage;
- four outcome axes and determinacy;
- manifestation payload identities;
- effect frontiers and settlement;
- capability lineage and revocation standing without exposing live authority;
- receipts and claims;
- scoped visibility;
- exposed principals;
- bounded unknowns.

### 21.2 Dual rendering  [F: FIX-4]

Inspection MUST provide:

1. a human-readable S-expression-oriented view; and
2. canonical machine-readable evidence at durable boundaries.

Pretty printing MUST NOT be the sole representation.

### 21.3 Explanation boundary

`explain` MAY summarize and traverse provenance. It MUST distinguish:

- recorded fact;
- derived state;
- asserted narrative;
- causal claim;
- missing evidence;
- bounded alternative.

---

## 22. Normative call-296 fixture

Erratum E-1 establishes Architecture 0.1 §15.2 as controlling.

The canonical fixture is:

```lisp
(:execution
  (:value :indeterminate
   :determinacy :indeterminate))

(:manifestation
  (:value (:absent :state :absent-after-completion)
   :determinacy :bounded
   :evidence (...)))

(:effects
  (:value :bounded
   :determinacy :bounded
   :alternatives (:billed :not-billed)))

(:interpretation
  (:value :not-applicable
   :determinacy :determinate))
```

**Projection status** *(R-SYN-1, Sol's pre-seal read, chair-accepted)*. The byte-identical form
above is the controlling Architecture 0.1/E-1 projection of the four outcome axes. It is not a
complete concrete Kernel /0 outcome record. A conforming construction of this fixture MUST
additionally bind the bounded effect axis to a structured uncertain-effect record satisfying
§10.8. That binding lives in the enclosing outcome/evidence structure and does not alter the
quoted architectural projection. Constructing the quoted bounded axis inline as the complete
effect representation MUST signal `unstructured-uncertainty`.

### 22.1 Fixture meaning

This fixture demonstrates:

- execution may be indeterminate;
- manifestation may be absent under a bounded evidentiary claim;
- billing may be bounded between named alternatives;
- interpretation may be determinately not applicable;
- uncertainty is per-axis;
- no global uncertainty scalar is needed.

### 22.2 Fixture limitation

The fixture does not classify the live Language-A record beyond the adopted structural projection rule.

The factual classification of the 76 kimi records remains in the locked scoring lane.

---

## 23. Normative process fixtures  [F: FIX-1]

A conforming Kernel /0 implementation MUST represent the following without catch-all status fields.

Every row of the Architecture 0.1 §17 terminal-case matrix (all thirteen, of which the call-296 fixture of §22 is one and §23.1–§23.12 are the rest) is a normative fixture. Each MUST be **constructed, journaled, killed-and-reconstructed, and re-derived byte-identically where determinism is declared** — per row, not only on the finalizer test. *(Adjudication 5, from DRAFT-F FIX-1: binds the kill-reconstruct-byte-compare obligation per matrix row.)*

### 23.1 Untouched seat

```lisp
:execution      (:value :not-attempted :determinacy :determinate)
:manifestation  (:value (:absent :state :never-attempted)
                 :determinacy :determinate)
:effects        (:value :not-entered :determinacy :determinate)
:interpretation (:value :not-attempted :determinacy :determinate)
```

### 23.2 Pre-frontier refusal

```lisp
:execution      (:value :refused :determinacy :determinate)
:manifestation  (:value (:absent :state :refused-pre-effect)
                 :determinacy :determinate)
:effects        (:value :not-entered :determinacy :determinate)
:interpretation (:value :not-applicable :determinacy :determinate)
```

### 23.3 Completed present output

```lisp
:execution      (:value :completed :determinacy :determinate)
:manifestation  (:value (:present manifestation-id)
                 :determinacy :determinate)
:effects        (:value :settled :determinacy :determinate)
:interpretation (:value :accepted :under procedure-id
                 :determinacy :determinate)
```

### 23.4 Completed present-empty output

The empty payload identity MUST be preserved.

### 23.5 Completed absent output

The absence state is `:absent-after-completion`; any explanation is a separate causal claim.

### 23.6 Present-invalid output

The payload and parser identity MUST be preserved.

### 23.7 Partial output then host death

The partial manifestation remains present evidence. Effect and execution determinacy derive from the journal prefix and adapter evidence.

### 23.8 Authorized replacement

The replacement has a new attempt identity and explicit supersession record. The predecessor remains visible.

### 23.9 Reconstructed derived view

A reconstructed derived view is a claim with origin `:reconstructed`, not an invocation outcome.

### 23.10 Mirror-bound publication

The commit outcome records both durable write and publication effects under the channel policy.

### 23.11 Self-report

A process narrative about its own history has origin `:asserted` unless a distinct witness captured the described events.

### 23.12 Secret opened to invoker

The invoker appears among exposed principals and loses eligibility for affected blind roles according to policy.

---

## 24. Ergonomic conformance

L17 is both constitutional law and API test criterion.

### 24.1 Default lawful path

The shortest documented supported consequential invocation MUST:

- allocate or validate attempt identity;
- check live capability;
- prepare and record effects;
- record partial manifestations;
- return structured outcome or handle;
- preserve outcome context.

### 24.2 No shorter supported bypass

The implementation MUST NOT expose a supported convenience path that is shorter while silently omitting:

- authority checks;
- attempt identity;
- journaling;
- effect settlement;
- outcome axes;
- exposed principals.

### 24.3 Raw escape  [F: FIX-3]

Raw host or provider escape MAY exist only if:

- clearly named `unsafe-*`, `raw-*`, or equivalent;
- outside the conforming Lisp+ API;
- unable to produce conforming receipts automatically;
- documented as forfeiting kernel guarantees.

### 24.4 Outcome access  [F: OP-3]

A convenience accessor MUST NOT silently turn an outcome into a bare answer and discard effect or determinacy context.

Safe pattern matching MUST be direct and composable.

### 24.5 Conformance motto

> At 5 a.m., syntax becomes governance.

---

## 25. Required conformance and adversarial tests  [F: FIX-2]

Kernel /0 is not conforming until tests cover every item below and negative controls prove the tests bite.  [F: K-2]

This suite enumerates 56 tests (§25.1–§25.7) and 10 negative controls (§25.8). It covers, at minimum, the thirty-seven adversarial classes of Architecture 0.1 §16 and the six ergonomic conformance tests of §16.1 (fixture-count reconciliation, adjudication 4). Conformance is defined by these fixtures, not by prose; a kernel that passes fixtures it cannot fail is not conformant.

### 25.1 Algebra tests

1. completed execution with absent manifestation;
2. present envelope with absent subject manifestation;
3. present-empty payload preserved;
4. present-invalid payload preserved with parser identity;
5. present-partial survives interruption;
6. four axes vary independently;
7. a bounded effect axis validates only when it references a structured uncertain-effect record; inline-only bounded construction signals `unstructured-uncertainty` *(sharpened per R-SYN-1)*;
8. global uncertainty field rejected by canonical outcome constructor.

### 25.2 Identity tests

9. duplicate process identity refused;
10. duplicate attempt identity refused;
11. occupied seat detected pre-frontier;
12. external request identity collision detected;
13. supersession requires new attempt identity;
14. supersession cannot erase predecessor;
15. provider alias drift detected.

### 25.3 Authority tests

16. missing capability refused;
17. revoked capability refused;
18. expired capability refused;
19. scope mismatch refused;
20. defensive scope copy resists mutation;
21. self-restoration refused;
22. restoration by unauthorized principal refused;
23. restoration creates new identity;
24. enlarged restoration scope refused;
25. unresolved effect blocks restoration past the frontier.

### 25.4 Effect tests

26. refusal occurs before frontier with zero effect;
27. post-frontier failure is not mislabeled refusal;
28. implicit fallback refused;
29. implicit retry across bounded effect refused;
30. provider-enforced idempotency permits declared replay;
31. reconciliation narrows bounded alternatives without rewriting history;
32. secret-open missing exposed principal refused;
33. self-invocation marks invoker exposed.

### 25.5 Store and fold tests

34. deterministic fold over valid prefix;
35. torn tail remains visible;
36. torn tail does not corrupt settled prefix;
37. best-effort durability yields bounded standing where required;
38. mutable cache never outranks changed prefix;
39. cross-journal merge without receipt refused;
40. finalizer loss followed by reconstruction;
41. reconstruction preserves origin.

### 25.6 Claim-standing tests

42. asserted self-report cannot become observed by filing;
43. seal does not imply verification;
44. publication does not imply truth;
45. parser validity does not imply semantic acceptance;
46. verified reconstruction remains reconstructed;
47. bare `:published` without scope refused;
48. bare `:verified` without procedure/scope refused.

### 25.7 Boundary tests

49. noncanonical host value refused at durable boundary;
50. adapter version drift refused;
51. channel policy missing on mirror-bound commit refused;
52. policy amendment without authority refused;
53. publication capability missing refused;
54. private staging commit has no publication effect;
55. outcome context discard detected;
56. raw escape marked nonconforming.

### 25.8 Required negative controls

The suite MUST include deliberately defective implementations for at least:

- blind retry;
- payload erasure;
- forged observed origin;
- mutable capability scope alias;
- missing exposed principal;
- timestamp-only journal merge;
- global uncertainty collapse;
- seat/attempt conflation;
- finalizer-only primary fact;
- shorter unsafe convenience accessor.

Each negative control MUST fail for the intended reason.

---

## 26. Kernel/library boundary  [F: K-1]

### 26.1 Kernel primitive or protocol

Kernel /0 owns:

- principal and role;
- process;
- logical operation, seat, attempt, request, exposure identities;
- supersession and reconciliation;
- manifestation statuses;
- outcome axes and determinacy;
- generic effect declaration and frontier checks;
- live capability machinery;
- abstract store and fold protocol;
- claim and receipt protocols;
- machine-configuration identity protocol;
- adapter protocol;
- channel-policy protocol;
- typed conditions;
- inspection and canonical export.

### 26.2 Library responsibility

Libraries own:

- experiment “census” terminology;
- scoring constitutions;
- item banks;
- preregistration;
- provider pricing;
- Language-A-specific exposure and score vocabulary;
- domain causal predicates;
- concrete channel-policy instances;
- sensitive capability-class policy;
- agent society abstractions;
- prompt templating;
- paper generation.

### 26.3 Moustache prohibition

A domain term MUST NOT enter the kernel merely because it supplied the motivating scar.

The kernel speaks of derived folds, not censuses; generic secret opening, not Cβ scoring; generic epistemic exposure, not Language-A subject exposure.

---

## 27. Deliberately delegated exactness

The following are not authorial gaps in Kernel /0; they are explicitly assigned to successor specs.

### 27.1 Process journal specification

`LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` SHALL define:

- exact human-readable S-expression grammar;
- record framing;
- canonical byte conversion;
- sequence/predecessor rules;
- commit marker or atomicity mechanism;
- synced versus best-effort durability declarations;
- prefix validation;
- torn-tail representation;
- cross-journal merge receipt;  <!-- [F: JRN-4] cross-journal merge is a reconstruction transformation with a receipt; the kernel MUST NOT provide any implicit timestamp-sorted merge (§20.6 `journal-merge-receipt-required`, §25.5 test 39) -->
- reconstruction receipt format;
- filesystem reference layout.

### 27.2 Adapter protocol specification

`LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` SHALL define:

- adapter function signatures;
- streaming callback contract;
- request identity timing;
- idempotency declaration;
- acknowledgment semantics;
- cancellation and reconciliation;
- usage/cost records;
- provider envelope and subject-manifestation projection;
- deterministic fake adapter script format.

### 27.3 Vertical specimen specification

`LISP-PLUS-VERTICAL-SPECIMEN-0.md` SHALL define the exact forced-kill program, kill points, fixtures, expected journal, expected fold, and negative controls.

---

## 28. Genuine stop conditions

An author or implementer MUST stop rather than invent if any of the following becomes necessary:

1. a new execution, manifestation, effect, or interpretation axis value not derivable from adopted law;
2. a fifth global uncertainty axis;
3. a new absence state that is actually a causal diagnosis;
4. a capability-restoration principal outside minter or mint-time delegate;
5. enlarged restoration scope;
6. silent policy-based fallback without identified transformation;
7. a concrete public-mirror channel policy not supplied by repository evidence and owner act;
8. factual classification of Language-A kimi records;
9. a domain-specific sensitive capability class requiring owner escalation;
10. a claim that the primitive set is independently minimal;
11. a journal byte rule not delegated to the journal spec;
12. provider semantics not supplied by the adapter contract.

A stop record SHOULD name:

- the missing semantic fact;
- the operation blocked;
- why existing law is insufficient;
- the smallest authorial decision required.

---

## 29. Adoption criteria for Kernel /0 spec

This specification is ready for owner adoption when:

1. every Architecture 0.1 kernel primitive is represented;
2. E-1’s call-296 fixture is exact;
3. no Language-A-specific moustache remains in kernel vocabulary;
4. process-event semantics are strong enough to constrain Codex without stealing journal byte design;
5. adapter requirements are strong enough to constrain the fake adapter without preempting the adapter spec;
6. every consequential operation has a named frontier and typed refusal conditions;
7. capability restoration exactly matches DK-3;
8. L15–L18 are mechanically testable;
9. the terminal fixtures fit without catch-all status;
10. residual matters are named;
11. implementation remains unauthorized pending an explicit owner act.

---

## 30. Immediate successor sequence

After adoption of this specification:

```text
Kernel /0 spec adoption
→ Process Journal /0 spec
→ Adapter Protocol /0 spec
→ Vertical Specimen /0
→ explicit Codex implementation authorization
→ Common Lisp runtime + deterministic fake adapter
→ forced-kill execution and evidence replay
→ stranger primitive-minimization audit
```

The roadmap shorthand “Kernel /0 spec → Codex runtime + fake adapter” remains valid only if the journal, adapter, and specimen obligations are either supplied as separate controlling specs or enclosed in the implementation authorization. Codex MUST NOT invent them from shorthand.

---

# Appendix A — Minimal abstract data shapes

The following are semantic sketches, not final byte schemas.

## A.1 Determinacy

```lisp
(determinacy
  :mode :determinate|:bounded|:indeterminate
  :alternatives (...)      ; required only for :bounded
  :evidence (...))
```

## A.2 Manifestation

```lisp
(manifestation
  :manifestation-id ...
  :attempt-id ...
  :kind ...
  :status :present|:present-empty|:present-invalid|:present-partial|
          :absent|:withheld|:redacted
  :payload-id ...
  :absence-state ...
  :parser-id ...
  :source-boundary ...
  :visibility (...))
```

## A.3 Axis

```lisp
(axis
  :value ...
  :determinacy (determinacy ...)
  :evidence (...)
  :procedure-id ...)
```

## A.4 Outcome

```lisp
(outcome
  :outcome-version 0
  :process-id ...
  :logical-operation-id ...
  :seat-id ...
  :attempt-id ...
  :machine-configuration-id ...
  :execution (axis ...)
  :manifestation (axis ...)
  :effects (axis ...)
  :interpretation (axis ...)
  :receipts (...)
  :bounded-unknowns (...))
```

## A.5 Capability minting receipt

```lisp
(capability-mint
  :receipt-id ...
  :capability-id ...
  :minted-by ...
  :authorizing-claim-id ...
  :derived-scope ...
  :delegates (...)
  :revocation-registry ...
  :expiry ...)
```

## A.6 Restoration receipt

```lisp
(capability-restoration
  :receipt-id ...
  :predecessor-capability-id ...
  :new-capability-id ...
  :restored-by ...
  :authority-basis ...
  :revocation-check ...
  :unresolved-effect-check ...
  :old-scope ...
  :new-scope ...)
```

## A.7 Supersession record

```lisp
(supersession
  :receipt-id ...
  :seat-id ...
  :predecessor-attempt-id ...
  :superseding-attempt-id ...
  :authorized-by ...
  :fresh-exposure-p ...
  :precedence-rule ...
  :residual-unknowns (...))
```

---

# Appendix B — Condition disposition table

| Condition family | Before frontier | After frontier | Retry allowed? |
|---|---:|---:|---|
| unresolved identity | refuse | semantic defect if discovered late | after correction, new preflight |
| missing/revoked capability | refuse | record authority defect; do not continue | only after lawful restoration |
| occupied seat | refuse | preserve current attempt evidence | reconciliation/supersession only |
| configuration drift | refuse | if discovered late, effect becomes bounded as required | explicit new authorization |
| store unavailable | refuse when durable sink required | bounded/indeterminate if frontier crossed | reconciliation first |
| torn tail | n/a | fold valid prefix; expose tail | depends on unresolved effect |
| parser invalid | not necessarily refusal | preserve payload; interpretation invalid | reparsing under new procedure is new transformation |
| secret exposure missing principals | refuse if known pre-frontier | standing defect; preserve evidence | never erase exposure |
| publication authority missing | refuse | if publication occurred, record unauthorized effect | not by retry |
| unsafe retry | refuse | n/a | explicit reconciliation/supersession |

---

# Appendix C — Trace from Architecture 0.1 §12

| Architecture primitive | Kernel /0 section |
|---|---|
| ordinary Lisp bootstrap | §12.1 |
| CD/0 boundary | §2.1, §17, §25.7 |
| principals and roles | §5 |
| process identity and transitions | §4, §13 |
| logical operation, seat, attempt | §6 |
| supersession and reconciliation | §14 |
| manifestation algebra | §8 |
| four-axis outcome | §7, §9 |
| closed absence states | §8.7 |
| uncertain effect | §7, §9.4, §10, §22 |
| live capabilities | §11 |
| effect/frontier checks | §10, §12 |
| durable-store and folds | §13, §27.1 |
| claims and receipts | §15 |
| machine configuration | §16 |
| adapter protocol | §18, §27.2 |
| inspection/export | §21 |
| typed conditions | §20 |

---

# Closing law

Kernel /0 exists to make the consequential path exact without making ordinary Lisp unbearable.

Its governing refusal is simple:

> **When execution, identity, authority, manifestation, effect, or standing is unresolved, preserve the distinction and stop before fluency invents the missing fact.**

---

# Parentage ledger

*This synthesis is DRAFT-S (base) with the eight sealed adjudications of `kernel-0-drafts/LISP-PLUS-KERNEL-0-FABLE-REVIEW.md` applied. Each entry names what changed, the source parent, and the review-table row. Both parent drafts remain on disk unmodified; this is a third document, not an edit to either.*

| # | Adjudication | What changed in this synthesis | Source | Review row |
|---|---|---|---|---|
| 1 | **ID-1 — identity issuance: adopt-S (merge)** | Kept DRAFT-S's identity floor (declared procedure + restart stability + non-image-local, §4.1); did **not** import DRAFT-F's store-issued mandate (it would bar valid content-addressed identity). Added an explicit merge note at §4.1. Identity-domain tagging (ID-2) confirmed present in §4/§4.2. | DRAFT-S §4.1; F conceded | Adjudication table row 1; concordance C.1 |
| 2 | **Uncertain-effect — adopt-F + A0.1 §6.10** | Made the structured uncertain-effect record a kernel primitive: new §10.8 with the A0.1 §6.10 field shape (incl. `:retry-policy`, `:reconciliation-procedure`); §9.4 now requires a `:bounded`/`:indeterminate` effect axis to reference one and signals `condition:unstructured-uncertainty` on inline-only construction; condition added to §20.4. | DRAFT-F OUT-3/UNC-1 + A0.1 §6.10 | Row 2; concordance C.2 (chair's highest-value merge) |
| 3 | **JRN-1 — journal readability: merge** | Stated the human-readable-S-expression readability MUST in-kernel at §13.1 (D4 rider, visible to a kernel-only reader); exact grammar/framing/bytes stay delegated to Process-Journal-/0 (§2.4, §27.1). | DRAFT-F JRN-1 (readability) + DRAFT-S delegation | Row 3; concordance C.3 |
| 4 | **FIX-2 — fixture suite: adopt-S §25** | DRAFT-S's suite (56 tests + 10 negative controls) is the base; count reconciled to A0.1 §16's thirty-seven enumerated adversarial classes (+ six ergonomic tests, §16.1) at §25; DRAFT-F's undercount (twenty), a transcription from the superseded Draft 0, is retired and appears nowhere. | DRAFT-S §25; A0.1 §16/§16.1 | Row 4; concordance C.4 |
| 5 | **adopt-F verbatim-or-adapted** | MAN-2 kernel envelope-projection prohibition (§8.8); CAU-1/CAU-2 causal-claim protocol + revision-invariance (new §8.9.1); OUT-5 interpretation-requires-present invariant (§9.6); OP-1 ordered preflight (§10.4); JRN-5 `reconstruct`/`fold-state` op surface + finalizer body-law (new §19.9); FIX-1 per-matrix-row kill-reconstruct-byte-compare (§23). | DRAFT-F MAN-2, CAU-1/2, OUT-5, OP-1, JRN-5, FIX-1 | Row 5; concordance C.5 |
| 6 | **JRN-2 / OP-2 — merge** | Restated as legible MUSTs at §13.2: wall-clock timestamps are observations and MUST NOT participate in ordering (JRN-2); consequential settled facts MUST NOT live only in memory across an await, L8 (OP-2). DRAFT-S's structural enforcement (append-only + predecessor linkage) is kept. | DRAFT-S structure + A0.1 §9.4/L8 guards | Row 6; concordance C.5 |
| 7 | **All 22 S-ONLY items — adopt-S** | Retained as-is in the base (already present): semantic-domain map (§4), evaluation-judgment formalism (§12), 21-type event vocabulary (§13.3), transition-legality rules (§13.5), effect-class taxonomy (§10.2), frontier progression (§10.3), status→state mapping (§8.7), inspection-as-conformance (§21), and the eight scaffold items (§0.2–0.4, §3, §5.2, §28–30, Appendices A–C). | DRAFT-S (base) | Row 7; concordance Part B |
| 8 | **The 37 AGREE clauses — S text + F cross-references** | DRAFT-S's text stands as the superset; each DRAFT-F requirement ID is placed at its corresponding DRAFT-S site as a bracketed `[F: …]` cross-reference tag (referenceability without text churn). All 54 DRAFT-F IDs are tagged (concordance Part A mapping). | DRAFT-S text; DRAFT-F IDs | Row 8; concordance Part A |

**On the 37 AGREE clauses:** they are DRAFT-S text with DRAFT-F cross-references, per adjudication 8. Because both parents are shared-root (Opus-lineage, blind, off the same A0.1), their agreement was treated as *no divergence to adjudicate*, never as corroboration; the information carried by the synthesis lived entirely in the F-STRONGER / S-STRONGER / S-ONLY asymmetries, which the eight adjudications resolve.

**Notes on canon-faithful readings chosen where an adjudication was ambiguous at the text level:**
- The uncertain-effect record (adjudication 2) was placed as a new §10.8 (under Effects and frontiers) rather than folded into §9.4 or §14, keeping the effect-axis reference (§9.4), the no-blind-retry law (§14.1), and the structured primitive itself in their canon-natural homes (A0.1 §6.10 sits in the core-entity chapter); `condition:unstructured-uncertainty` was added to the §20.4 effect-and-retry taxonomy.
- The causal-claim protocol (adjudication 5, CAU-1/CAU-2) was placed as §8.9.1 immediately under DRAFT-S's existing §8.9 "Causal diagnosis," where the two-level state/cause separation already lives.
- No `[SYNTHESIS-FLAG]` was raised: every adjudication was resolvable against the adjudication table and A0.1 without invention.

**Parents unmodified:** `kernel-0-drafts/sol/LISP-PLUS-KERNEL-0-SPEC.md` (DRAFT-S, sha256 `e3f6e054…c9b41`) and `LISP-PLUS-KERNEL-0-SPEC-DRAFT-F.md` (DRAFT-F, `bd311f17`) are untouched on disk. The call-296 fixture (§22) survived this surgery byte-identical to the base.

*— SUTOR-III (Claude Opus 4.8, 1M context), under the chair's adjudications of 2026-07-18.*

### Pre-seal repairs (Sol's read, chair-applied, same day)

Source: `kernel-0-drafts/SOL-READ-KERNEL-0-SYNTHESIS.md` — Sol accepted all eight adjudications
and the synthesis, conditional on three seam closures, each applied here with Sol's exact text:

- **R-SYN-1 (§22, §25.1 test 7):** the call-296 fixture is explicitly a **canonical axis
  projection**, not a complete constructible Kernel /0 record — a conforming construction MUST
  bind the bounded effect axis to a structured uncertain-effect record (§10.8); test 7
  sharpened accordingly. *Prevents the canonical fixture becoming the canonical bypass around
  the adopted primitive; fixture bytes unchanged.*
- **R-SYN-2 (§13.1):** readability re-stated as a conformance property (normative S-expression
  rendering of every committed event; binary-only nonconforming) with ALL framing — grammar,
  bytes, delimiters, prefixes, atomicity — delegated to Process-Journal-/0. *The prior merge
  text bound "one record per line / no binary framing" while claiming to defer framing.*
- **R-SYN-3 (§10.4):** the preflight total order replaced by a declared, deterministic,
  **dependency-respecting** order (identities-before-scope, authority-checks-before-
  authority-requiring-probes, inspectable effective order, reorderable pure checks). *The
  DRAFT-F OP-1 total order evaluated capability scope before resolving the identities scope is
  a predicate over — the chair's clause, corrected by the other parent's author.*

*— repairs applied by the chair (Claude Fable 5), 2026-07-18; both parents remain unmodified.*

<!--
SUTOR-III SELF-CHECK (verified against the on-disk file, 2026-07-18):

(a) Four repairs present, one line each:
    R1 causal-claim protocol  — §8.9.1: "A causal claim MUST bind subject identity, predicate, evidence references, an origin facet, and a validation facet."
    R2 uncertain-effect record — §10.8: "(uncertain-effect :kind ... :retry-policy :forbidden-without-reconciliation)" with UNC-1/UNC-2 MUSTs.
    R3 reconstruct/fold-state ops — §19.9: "(fold-state ...) deterministic fold ... (reconstruct ...) re-derive a fold-derived summary from primary records alone".
    R4 envelope-projection prohibition — §8.8: "The kernel MUST NOT derive the subject-manifestation status by inspecting envelope bytes itself".
(b) ID-1: adopt-S/merge — NO store-issued mandate imported (§4.1 merge note; grep 'MUST be store-issued' → none). PASS.
(c) condition:unstructured-uncertainty exists — §9.4, §10.8, §20.4 (5 occurrences). PASS.
(d) The forbidden DRAFT-F undercount phrase (the digit-string twenty followed by "adversarial") occurs nowhere; count reconciled to A0.1 §16's 37 enumerated classes (+6 ergonomic, §16.1). PASS.
(e) call-296 fixture (§22) byte-identical to base: §22-block sha256 8fdced79...41ae identical for base and synthesis; diff-free. PASS.
(f) Parents unmodified: git status shows only the new file untracked; DRAFT-S sha256 e3f6e054...c9b41 unchanged; DRAFT-F bd311f17 untouched. PASS.
(g) All 54 DRAFT-F requirement IDs placed as [F: ...] cross-reference tags (distinct-ID count = 54). PASS.

No [SYNTHESIS-FLAG] raised: every adjudication was resolvable against the review table + A0.1 without invention.
-->

