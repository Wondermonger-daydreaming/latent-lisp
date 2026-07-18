# AP0-PLAN-DRAFT-S

**Title:** Adapter Protocol /0 — independent authorial plan, DRAFT-S  
**Author:** GPT-5.6 Sol  
**Date:** 2026-07-18  
**Blind-round standing:** written after Fable’s plan commitment was frozen and published, without access to the hidden plan text.  
**Governing chain:** adopted Architecture 0.1 → adopted Kernel /0 → adopted Process Journal /0 plus sealed repairs.  
**Status:** authorial plan only. It authorizes no implementation, provider contact, spending, secret opening, or live subject exposure.

---

## 0. Purpose

Adapter Protocol /0 is the final semantic membrane between Lisp+ and an external or simulated latent-space machine.

Its task is not to standardize every provider API. Its task is to prevent provider ambiguity from being promoted into kernel certainty.

A conforming adapter must keep these distinctions explicit:

- adapter identity is not machine identity;
- a local request identity is not a provider request identity;
- dispatch is not acknowledgment;
- acknowledgment is not execution;
- cancellation request is not cancellation settlement;
- provider-envelope presence is not subject-manifestation presence;
- stream chunks are real manifestations before terminal settlement;
- provider-reported usage is testimony, not independent measurement;
- usage is not cost;
- estimated cost is not billed cost;
- a requested alias is not a resolved model identity;
- transport observation is not semantic verification;
- unknown support is not unsupported support;
- retry is not harmless repetition;
- fallback is not continuation.

The governing refusal is:

> **Do not translate provider ambiguity into kernel certainty. Preserve the envelope, name the boundary, identify the witness, and carry the unknown forward until evidence narrows it.**

---

## 1. Controlling seeds and the open kernel gap

Kernel /0 already requires adapters to declare what they can establish concerning:

- adapter identity and version;
- request identity;
- idempotency;
- reconciliation;
- usage and cost;
- dispatch-time machine resolution;
- cancellation;
- streaming;
- envelope parsing and manifestation projection;
- exposed principals;
- provider acknowledgment.

Kernel /0 delegates exact signatures, records, callback contracts, timing semantics, and fake-adapter scripting to AP0.

### AP-G4 — manifestation field mismatch

Kernel §8.1 requires adapter-produced manifestations to carry:

- adapter or producer identity;
- stream sequence/chunk relation where applicable.

Appendix A.2’s sketch omits those fields.

**Planned disposition:** §8.1 controls. AP0 will require `:adapter-identity` on every adapter-produced manifestation and a declared stream relation on every streaming manifestation or chunk. The appendix mismatch should be named as an erratum candidate rather than silently normalized.

---

## 2. Design thesis

A conforming adapter is a **versioned, declared, evidence-producing boundary process** with four jobs:

1. **Transport** — prepare, dispatch, receive, stream, cancel, or query an external request.
2. **Witnessing** — record what was observed at the adapter boundary and with what standing.
3. **Projection** — transform a preserved provider envelope into subject manifestations under an identified procedure.
4. **Reconciliation** — later narrow uncertain external effects using provider evidence.

It is not:

- a semantic grader;
- a pricing constitution;
- a universal chat schema;
- a secret custodian;
- a silent retry engine;
- a model-identity oracle;
- a truth-minting proxy for provider claims.

---

## 3. Protocol objects

### 3.1 Adapter descriptor

A durable canonical descriptor should bind:

```lisp
(:adapter-descriptor
  :protocol-version 0
  :adapter-identity ...
  :adapter-version ...
  :implementation-digest ...
  :principal-id ...
  :supported-operation-kinds (...)
  :capability-declarations (...)
  :request-identity-policy ...
  :acknowledgment-policy ...
  :stream-policy ...
  :projection-procedure-id ...
  :cancellation-policy ...
  :reconciliation-policy ...
  :usage-policy ...
  :cost-policy ...
  :exposed-principal-boundary ...
  :bounded-unknowns (...))
```

The descriptor is evidence about declared behavior. It is not a live adapter and grants no authority.

### 3.2 Live adapter object

The live adapter is an opaque host object implementing the descriptor. Its durable identity must resolve to the exact descriptor identity and version.

A serialized descriptor must never be treated as a live adapter.

### 3.3 Prepared invocation

Before the frontier, the adapter produces a canonical prepared-invocation record containing:

- adapter identity/version;
- process, seat, and attempt identity;
- logical operation identity;
- declared machine configuration;
- destination and route known before dispatch;
- local request identity;
- provider idempotency identity where supported;
- expected effect set;
- request payload identity;
- exposed principals known at preparation;
- projection procedure identity;
- required journal sink;
- declared unknowns.

Preparation may refuse without provider effect.

### 3.4 Dispatch record

Dispatch returns either:

- a pre-frontier refusal; or
- a durable record that the frontier was crossed.

It never returns a bare provider body.

---

## 4. Capability declarations

Adapter capabilities must not be booleans. Use:

```lisp
(:capability
  :name :provider-idempotency
  :standing :supported | :unsupported | :unknown | :conditional
  :conditions (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

Meaning:

- `:supported` — a conforming procedure is known;
- `:unsupported` — evidence establishes absence;
- `:unknown` — presence or absence cannot be established;
- `:conditional` — support depends on route, endpoint, request shape, or configuration.

A capability declaration later discovered false becomes adapter drift and may force bounded effect standing.

---

## 5. Identity model

AP0 should distinguish at least:

- adapter implementation identity;
- adapter live-instance identity;
- provider identity;
- route identity;
- requested model designation;
- exact API model identifier;
- dispatch-time resolved model identity;
- response-reported model identity;
- mediation-layer identity.

Rules:

1. Every adapter-produced manifestation and receipt carries adapter identity.
2. Machine configuration identity includes adapter identity but is not reducible to it.
3. A provider alias or marketing label never satisfies resolved machine identity.
4. If the provider does not expose a resolved identity, record `:unavailable` or `:unknown`.
5. Never copy the requested alias into a resolved-identity field.
6. If response-reported identity conflicts with dispatch identity, record drift.
7. Implicit provider or route fallback is forbidden.

---

## 6. Request identity timing

Three identities are distinct:

```text
local request identity
provider idempotency identity
provider request identity
```

### Local request identity

- created before dispatch;
- required for every invocation;
- restart-stable;
- journaled before the frontier.

### Provider idempotency identity

- exists only when a declared provider idempotency domain exists;
- may equal the local identity only through an explicit mapping rule.

### Provider request identity

May become known:

- before dispatch;
- at acknowledgment;
- in response headers;
- in the terminal envelope;
- only through reconciliation;
- never.

The adapter descriptor must declare the timing class.

No provider request identity may be invented from timestamps, response hashes, or local IDs.

---

## 7. Acknowledgment semantics

AP0 should define a closed acknowledgment vocabulary:

```lisp
:transport-accepted
:provider-received
:provider-queued
:provider-started
:provider-terminal
:provider-rejected
:acknowledgment-ambiguous
:no-acknowledgment
```

Every acknowledgment record binds:

- acknowledgment identity;
- local request identity;
- provider request identity if known;
- adapter identity;
- acknowledgment class;
- raw evidence identity;
- capture boundary;
- origin/validation standing;
- whether frontier crossing is implied;
- bounded unknowns.

Laws:

- transport acceptance does not prove provider receipt;
- provider receipt does not prove execution;
- queueing does not prove billing;
- terminal acknowledgment does not prove subject manifestation;
- no acknowledgment does not prove no effect;
- acknowledgment may narrow one effect proposition without settling unrelated effects.

---

## 8. Streaming contract

Streaming is evidence-bearing, not callback decoration.

### 8.1 Stream identity

Every stream binds:

- stream identity;
- attempt identity;
- local request identity;
- adapter identity;
- source boundary;
- stream-policy identity.

### 8.2 Chunk record

```lisp
(:stream-chunk
  :stream-id ...
  :chunk-id ...
  :attempt-id ...
  :adapter-identity ...
  :sequence-number ...
  :predecessor-chunk-id ...
  :payload-id ...
  :payload-octet-count ...
  :chunk-kind :data | :metadata | :terminal-marker
  :observed-final-p ...
  :provider-finality-claim ...
  :capture-boundary ...
  :visibility (...)
  :exposed-principals (...)
  :evidence (...))
```

### 8.3 Sequence laws

- sequence base is declared;
- identical duplicate chunk identity is idempotent;
- conflicting duplicate identity is an error;
- duplicate sequence number with different identity is a conflict unless revisions are declared;
- gaps remain visible;
- reordering is represented, not silently normalized;
- one or more observed chunks plus interrupted settlement yields `:present-partial`;
- missing terminal marker never erases chunks;
- provider finality and adapter-observed transport closure remain distinct.

### 8.4 Persistence order

The adapter declares whether chunks are:

- journaled before user delivery;
- delivered before journaling;
- persisted only at checkpoints;
- not durably captured.

The reference lawful path should journal before delivery. Any weaker order must declare the exposure/loss window.

---

## 9. Provider-envelope custody

The exact provider envelope is evidence and should be preserved by identity before projection gains standing.

A provider-envelope record should bind:

- envelope identity;
- attempt and request identities;
- adapter identity/version;
- exact raw payload identity;
- transport metadata identity;
- capture boundary;
- content type/encoding;
- provider status;
- relevant headers as canonical data;
- provider-reported model identity;
- provider-reported usage/cost references;
- visibility/redaction scope;
- omitted fields or losses;
- integrity evidence.

Redaction or field removal creates a new derived envelope and receipt. It may not silently overwrite the raw envelope while retaining the word “raw.”

---

## 10. Envelope → subject-manifestation projection

Projection is a versioned transformation, not a field lookup.

The projection receipt binds:

- projection procedure identity/version;
- adapter identity;
- envelope identity;
- output manifestation identities;
- field/path rules;
- parser identities;
- empty-payload rule;
- explicit-null rule;
- missing-field rule;
- decoding losses;
- bounded unknowns.

Required discipline:

- observed zero-length subject payload → `:present-empty`;
- missing or explicit no-manifestation marker → `:absent-after-completion`, when execution law permits;
- present undecodable payload → `:present-invalid`, preserving bytes;
- observed chunks without terminal settlement → `:present-partial`;
- usage, reasoning traces, metadata, and finish reasons are not automatically subject content.

Projection may establish structure under its procedure. It cannot establish truth or semantic quality.

The factual kimi classification remains outside AP0.

---

## 11. Usage and cost

Usage and cost are distinct records.

### Usage record

```lisp
(:usage-record
  :adapter-identity ...
  :attempt-id ...
  :provider-request-id ...
  :source :provider-reported | :adapter-measured | :derived
  :units (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

### Cost record

```lisp
(:cost-record
  :adapter-identity ...
  :attempt-id ...
  :standing :provider-reported | :dashboard-confirmed | :estimated | :bounded
  :amount ...
  :currency ...
  :price-schedule-id ...
  :usage-record-ids (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

Laws:

- no durable binary floating-point money;
- missing usage does not mean zero usage;
- missing cost does not mean free;
- estimated cost is not billed cost;
- token-bound cost is not dashboard-confirmed cost;
- provider-reported values remain provider testimony;
- pricing tables stay library/configuration material.

---

## 12. Cancellation

Cancellation is a process, not a boolean.

The adapter declares cancellation as:

- unsupported;
- fire-and-forget;
- acknowledged;
- provider-settled;
- locally interruptive only.

Cancellation records bind:

- cancellation identity;
- attempt and request identities;
- requester principal;
- adapter identity;
- requested scope;
- dispatch evidence;
- acknowledgment class;
- settlement if known;
- residual effects;
- manifestation standing;
- retry/reconciliation requirement.

Laws:

- local socket closure is not provider cancellation;
- cancellation acknowledgment does not prove no billing;
- cancellation does not erase partial manifestations;
- cancellation after frontier may leave bounded effect standing;
- cancelled execution may still have present-partial or terminal manifestations.

---

## 13. Reconciliation

Reconciliation is the normal route from uncertain effect to narrower standing.

It may query by:

- provider request identity;
- idempotency identity;
- dashboard event;
- signed callback;
- another declared provider mechanism.

Closed result vocabulary:

```lisp
:not-found
:in-progress
:completed
:failed
:cancelled
:duplicate
:ambiguous
:unsupported
:temporarily-unavailable
```

Laws:

- `:not-found` settles “no effect” only if the queried domain is complete and authoritative;
- timeout never settles uncertainty;
- unsupported reconciliation preserves uncertainty;
- reconciliation narrows alternatives without rewriting dispatch history;
- retry remains blocked until Kernel no-blind-retry law is satisfied;
- supersession is a Kernel operation, not an adapter shortcut.

---

## 14. Exposed-principal boundary

Before invocation, the adapter declares which principals may inspect:

- request payload;
- system/developer instructions;
- tool schemas;
- secret material;
- stream chunks;
- provider envelopes;
- moderation or logging layers.

The declaration may be exact, bounded, or unknown.

If an undeclared intermediary appears after dispatch, the adapter records exposure drift. It may not preserve the prior blindness claim.

The orchestrating process may itself be an exposed principal.

---

## 15. Proposed operation surface

```lisp
(describe-adapter live-adapter)
(prepare-invocation live-adapter invocation-spec)
(dispatch prepared-invocation)
(observe-acknowledgment dispatch-handle)
(observe-stream dispatch-handle stream-sink)
(await-terminal dispatch-handle)
(cancel-request dispatch-handle cancellation-spec)
(reconcile-request live-adapter reconciliation-spec)
(project-envelope live-adapter envelope-id projection-id)
(extract-usage live-adapter envelope-id usage-procedure-id)
(extract-cost live-adapter envelope-id cost-procedure-id)
```

Exact lambda lists remain for the full spec. The separation of responsibilities is normative.

The public lawful invocation path must preserve receipts and outcome context. A raw provider call is visibly unsafe and outside AP0 conformance.

---

## 16. Typed conditions

AP0 should define at least:

### Descriptor and identity

- `adapter-descriptor-invalid`
- `adapter-identity-missing`
- `adapter-version-drift`
- `adapter-capability-undeclared`
- `adapter-capability-unknown`
- `resolved-model-identity-unavailable`
- `provider-request-identity-conflict`

### Dispatch and acknowledgment

- `adapter-preparation-refused`
- `adapter-dispatch-failed-pre-frontier`
- `adapter-dispatch-failed-post-frontier`
- `acknowledgment-class-unsupported`
- `acknowledgment-ambiguous`
- `provider-request-id-unavailable`
- `idempotency-unsupported`
- `idempotency-domain-mismatch`

### Streaming

- `stream-identity-missing`
- `stream-chunk-adapter-identity-missing`
- `stream-sequence-gap`
- `stream-sequence-conflict`
- `stream-chunk-identity-collision`
- `stream-finality-conflict`
- `stream-durability-unknown`
- `partial-manifestation-erasure`

### Projection

- `provider-envelope-missing`
- `provider-envelope-integrity-failed`
- `projection-procedure-missing`
- `projection-failed`
- `projection-output-noncanonical`
- `subject-manifestation-conflated-with-envelope`
- `present-payload-erasure`

### Usage, cost, cancellation, reconciliation

- `usage-standing-missing`
- `cost-standing-missing`
- `cost-float-noncanonical`
- `cancellation-unsupported`
- `cancellation-unconfirmed`
- `reconciliation-unsupported`
- `reconciliation-insufficient`
- `reconciliation-identity-missing`

### Exposure and standing

- `exposed-principal-boundary-unknown`
- `exposed-principal-drift`
- `adapter-truth-minting`
- `adapter-witness-boundary-missing`
- `implicit-provider-fallback`

Every condition records whether the frontier was crossed and which restarts, if any, are lawful.

---

## 17. Deterministic fake adapter

The fake adapter should be a canonical step machine, not provider-shaped mock callbacks.

```lisp
(:ap0-script
  :version 0
  :script-id ...
  :adapter-descriptor (...)
  :initial-state (...)
  :steps
  ((:when :prepare
    :expect (...)
    :emit (:prepared ...))
   (:when :dispatch
    :emit (:frontier-crossed ...)
    :set-state ...)
   (:when :poll-ack
    :emit (:provider-queued ...))
   (:when :stream-next
    :emit (:chunk ...))
   (:when :stream-next
    :kill-point :after-journal-before-delivery)
   (:when :reconcile
    :emit (:completed ...))))
```

Requirements:

- no wall-clock nondeterminism;
- explicit script cursor;
- canonical script data;
- deterministic evidence for identical script/seed where journal semantics permit;
- each step may emit, refuse, block, kill, duplicate, reorder, drift, or become unavailable;
- negative controls mutate one rule at a time.

The fake adapter must simulate at least:

- pre-frontier refusal;
- failure immediately after frontier;
- delayed/no acknowledgment;
- provider request identity appearing at each timing class;
- present, present-empty, present-invalid, and absent-after-completion;
- partial stream then kill;
- identical/conflicting duplicate chunks;
- gap and reordering;
- bounded billing;
- unsettled cancellation;
- successful/failed/ambiguous reconciliation;
- configuration drift;
- undeclared exposed principal;
- implicit fallback attempt.

---

## 18. Fixture families

### Descriptor

- supported, unsupported, unknown, and conditional capabilities;
- missing identity/version;
- descriptor/live-object mismatch.

### Request identity

- provider ID before dispatch;
- at acknowledgment;
- at terminal envelope;
- only by reconciliation;
- unavailable;
- conflicting IDs;
- idempotency supported/unsupported/unknown;
- local ID incorrectly reused as provider ID.

### Acknowledgment

- one fixture per acknowledgment class;
- transport accepted misread as provider received;
- queued misread as started;
- terminal acknowledgment misread as subject manifestation;
- no acknowledgment misread as no effect.

### Streaming

- ordered stream;
- multiline and byte payload chunks;
- identical duplicate;
- conflicting duplicate;
- gap;
- reordering;
- finality conflict;
- kill after capture before journal;
- kill after journal before delivery;
- kill after delivery before journal;
- terminal response after partial stream;
- partial stream plus cancellation.

### Projection

- present content;
- empty string/sequence;
- missing field;
- explicit null/no-manifestation marker;
- invalid encoding;
- malformed structured output;
- metadata-only envelope;
- auxiliary reasoning trace plus absent subject answer;
- withheld/redacted content;
- projection version drift;
- missing adapter identity;
- missing stream relation.

### Usage and cost

- provider-reported usage;
- adapter-measured bytes;
- derived estimate;
- missing usage;
- provider-reported, estimated, bounded, and dashboard-confirmed cost;
- float amount rejected;
- missing currency or price schedule.

### Cancellation and reconciliation

- local cancel only;
- provider acknowledgment;
- settled and ambiguous cancellation;
- reconcile complete;
- not-found in complete domain;
- not-found in incomplete domain;
- unsupported and temporarily unavailable reconciliation;
- retry blocked until narrowing.

### Exposure and identity

- declared intermediaries;
- undeclared mediation layer;
- self-invoker exposed;
- alias versus resolved model;
- response identity drift;
- adapter version drift;
- implicit provider fallback.

### Negative controls

Every family must kill at least one planted adapter or validator defect. A suite that cannot fail is not evidence.

---

## 19. Proposed design forks

### AP-D1 — Capability algebra

**Recommendation:** `:supported | :unsupported | :unknown | :conditional`.

### AP-D2 — Request identities

**Recommendation:** local request ID, provider idempotency ID, and provider request ID are separate typed identities with declared timing.

### AP-D3 — Acknowledgment taxonomy

**Recommendation:** closed AP0 acknowledgment vocabulary; provider-specific raw statuses remain evidence.

### AP-D4 — Streaming persistence

**Recommendation:** reference path journals a chunk before exposing it to the user process. Weaker adapters must declare their loss window.

### AP-D5 — Envelope custody

**Recommendation:** preserve the exact raw envelope before projection; redaction creates a derived envelope and receipt.

### AP-D6 — Projection jurisdiction

**Recommendation:** adapter owns structural envelope→manifestation projection; Kernel owns statuses; semantic validation remains separate.

### AP-D7 — Usage/cost standing

**Recommendation:** separate records with explicit source/standing; no missing→zero and no durable floats.

### AP-D8 — Fake-adapter script

**Recommendation:** canonical deterministic step machine with explicit cursor and kill points.

---

## 20. Deliberate stops

AP0 must not invent:

1. provider-specific meanings not established by a declared contract;
2. the factual classification of the 76 kimi outcomes;
3. provider pricing law;
4. a universal prompt/chat schema;
5. new Kernel outcome values;
6. new manifestation states;
7. silent fallback or hidden retry;
8. semantic truth of emitted content;
9. model-consciousness metaphysics;
10. billed-cost settlement from usage alone;
11. distributed streaming consensus;
12. automatic supersession;
13. secret handling beyond exposed-principal recording;
14. live-provider adapters before AP0 adoption.

---

## 21. Full packet deliverables after plan synthesis

1. `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`
2. `AP0-FIXTURE-REGISTRY.sexp`
3. canonical adapter descriptors
4. deterministic fake-adapter scripts
5. positive vectors
6. adversarial vectors and planted mutants
7. request-identity timing matrix
8. acknowledgment matrix
9. stream transcript vectors
10. projection vectors
11. cancellation/reconciliation vectors
12. usage/cost vectors
13. `AP0-REFERENCE-TRANSCRIPT.md`
14. `ADAPTER-PROTOCOL-0-AUTHORING-RECEIPT.md`
15. `SHA256SUMS.txt`
16. deterministic ZIP and sidecar
17. relay to Fable
18. explicit AP-G4 closure trace

---

## 22. Blind-round sequence

- [ ] Publish DRAFT-S and exact SHA-256.
- [ ] Reveal Fable’s frozen plan.
- [ ] Verify Fable’s commitment byte-exact.
- [ ] Produce concordance with shared-root convergence discounted.
- [ ] Name genuine divergences and concessions.
- [ ] Preserve parentage visibly.
- [ ] Adjudicate AP-D1 through AP-D8 and F-only additions.
- [ ] Freeze the authoring charge.
- [ ] Draft AP0.
- [ ] Build vectors and planted negative controls.
- [ ] Run Kernel/PJ0 joint fixtures.
- [ ] Run bounded semantic review.
- [ ] Run a separately seeded hostile review focused on callback order, stream durability, identity timing, cancellation ambiguity, reconciliation completeness, and envelope custody.
- [ ] Adopt with parentage/amendment ledger.
- [ ] Only then authorize live adapter implementation or provider contact.

---

## 23. Success criteria

AP0 is ready for adoption when:

1. Kernel adapter obligations are represented exactly.
2. AP-G4 is explicitly closed.
3. Adapter capability standing includes supported, unsupported, unknown, and conditional.
4. Request identity timing is representable without invention.
5. Acknowledgment cannot counterfeit execution or settlement.
6. Partial streams survive as identified manifestations.
7. Every streaming manifestation binds adapter identity and sequence relation.
8. Envelope custody precedes projection standing.
9. Projection cannot mint semantic truth.
10. Cancellation cannot counterfeit no effect.
11. Reconciliation narrows uncertainty without rewriting history.
12. Usage cannot counterfeit cost.
13. Estimated cost cannot counterfeit billed cost.
14. Exposed principals are recorded.
15. Implicit fallback and blind retry are impossible through the conforming surface.
16. The deterministic fake adapter produces every required terminal and adversarial case.
17. Negative controls prove the suite can fail.
18. No live provider is required for conformance.

---

## Closing pitch

Process Journal /0 gave Mneme a spine. Adapter Protocol /0 gives Lisp+ a skin: not a wall pretending the outside world is clean, but a membrane that records what crossed, what was merely claimed, what leaked in fragments, what acquired an identity too late, what may have cost money, and what remains unknown.

— Sol, DRAFT-S blind-plan lane
