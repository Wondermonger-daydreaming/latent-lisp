from __future__ import annotations
from pathlib import Path
import hashlib, json, os, shutil, textwrap, zipfile, re
from typing import Any

ROOT = Path('/mnt/data/lisp-plus-adapter-protocol-0')
if ROOT.exists():
    shutil.rmtree(ROOT)
ROOT.mkdir(parents=True)
for sub in ['descriptors','scripts','vectors/positive','vectors/adversarial','vectors/mutants','tools','transcripts','matrices']:
    (ROOT/sub).mkdir(parents=True, exist_ok=True)

# ---------- PJ-S/0 generator-side serializer (not shared with validator) ----------
class Id(tuple):
    pass
class BytesVal(bytes):
    pass
class Unit:
    pass
UNIT=Unit()

def ident(*segments:str)->Id:
    return Id(segments)

def esc(s:str)->str:
    out=[]
    for ch in s:
        cp=ord(ch)
        if ch=='"': out.append('\\"')
        elif ch=='\\': out.append('\\\\')
        elif cp<=0x1f or cp==0x7f: out.append('\\u{%x}'%cp)
        else: out.append(ch)
    return ''.join(out)

def emit(x:Any)->str:
    if x is UNIT or x is None: return '#u'
    if isinstance(x,float): return '"binary-float:'+format(x,'.17g')+'"'
    if x is False: return '#f'
    if x is True: return '#t'
    if isinstance(x,int): return str(x)
    if isinstance(x,BytesVal): return '#x"'+bytes(x).hex()+'"'
    if isinstance(x,Id): return '(id ' + ' '.join('"'+esc(s)+'"' for s in x) + ')'
    if isinstance(x,str): return '"'+esc(x)+'"'
    if isinstance(x,list) or isinstance(x,tuple): return '(seq' + ('' if not x else ' ' + ' '.join(emit(v) for v in x)) + ')'
    if isinstance(x,dict):
        items=[]
        for k in sorted(x, key=lambda q: tuple(q)):
            items.append('(' + emit(k) + ' ' + emit(x[k]) + ')')
        return '(rec' + ('' if not items else ' ' + ' '.join(items)) + ')'
    raise TypeError(type(x))

def write_pjs(path:Path, datum:Any):
    path.write_text(emit(datum)+'\n', encoding='utf-8', newline='\n')

# ---------- stable keys ----------
K=lambda *s: ident(*s)

def rec(**kwargs):
    return {K('ap0',k.replace('_','-')):v for k,v in kwargs.items()}

# ---------- authoritative spec ----------
spec = r'''# LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC

**Status:** Normative Adapter Protocol /0 specification candidate for Lisp+  
**Language:** Lisp+  
**Memory-and-continuity layer:** Mneme  
**Date:** 2026-07-18  
**Authoring lane:** GPT-5.6 Sol, under the sealed AP0 charge  
**Governing architecture:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md`, adopted at `f7583616`  
**Governing kernel:** `LISP-PLUS-KERNEL-0-SPEC.md`, adopted and governing  
**Governing journal:** Process Journal /0, adopted at `f44436f5`, jointly with `PJ0-PRESEAL-REPAIRS.md`  
**Blind parents:** `AP0-PLAN-DRAFT-S.md` and `AP0-PLAN-DRAFT-F.md`  
**Adjudication:** `AP0-PLAN-CONCORDANCE.md` and `RELAY-TO-SOL-AP0-AUTHORING-CHARGE.md`

**Standing:** specification candidate only. This packet authorizes no live provider contact, spending, secret opening, subject exposure, implicit fallback, retry, or implementation on `main`. Adoption and implementation standing are separate acts.

---

## 0. Governing refusal

Adapter Protocol /0 is Lisp+’s final semantic membrane before an external or simulated latent-space machine.

> **Do not translate provider ambiguity into kernel certainty. Preserve the envelope, name the boundary, identify the witness, record who was exposed, and carry the unknown forward until evidence—not fluency—narrows it.**

An adapter is not “a function that returns text.” It is a versioned, declared, evidence-producing boundary process that transports requests, witnesses boundary events, preserves envelopes, projects manifestations, and reconciles uncertain effects.

### 0.1 Normative vocabulary

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **MAY**, and **OPTIONAL** are normative in the RFC-2119 sense.

### 0.2 Authority chain

The controlling sequence is:

```text
Architecture 0.1
→ Kernel /0
→ Process Journal /0 + R-PJ-1..3
→ two mutually blind AP0 plans
→ AP0 plan concordance
→ sealed AP0 authoring charge
→ this candidate
```

Where this candidate conflicts with an adopted predecessor, the predecessor governs and the difference is a defect here. An implementation MUST stop rather than choose the more convenient meaning.

### 0.3 Parentage

The working skeleton is DRAFT-S. The concordance adopted DIV-1 through DIV-6 to S and required F-HOLD-1 through F-HOLD-6 as normative additions.

Convergences are shared-root material and carry no independent corroborative weight. Divergences and concessions are preserved in §31.

### 0.4 Non-authorization

This specification does not authorize:

- live provider calls;
- spending;
- release of private prompts, keys, fixtures, or subject material;
- automatic retry;
- provider fallback;
- factual classification of the seventy-six Language-A kimi outcomes;
- provider-specific billing claims;
- semantic verification of model-emitted claims;
- adoption of a concrete live adapter;
- implementation standing beyond an explicit owner act.

---

## 1. Scope

AP0 defines:

1. the common contract implemented by deterministic fake and external adapters;
2. adapter descriptors and live-object binding;
3. four-valued capability declarations;
4. prepared invocations and frontier-crossing records;
5. local request, provider idempotency, and provider request identities;
6. provider acknowledgment vocabulary;
7. exact streaming and chunk relations;
8. provider-envelope custody;
9. structural envelope-to-manifestation projection;
10. exhaustive absence-mapping tables;
11. usage and cost records with explicit standing;
12. cancellation and reconciliation;
13. exposed-principal events at the membrane;
14. W1–W4 crash windows;
15. the deterministic fake-adapter script language;
16. adapter conditions and restarts;
17. conformance fixtures and the L17 route audit.

AP0 does not define:

- provider wire formats;
- universal prompts or chat schemas;
- semantic grading;
- provider pricing constitutions;
- rate-limit optimization;
- multi-provider routing;
- response caches;
- provider-side tool semantics;
- metaphysics of latent state;
- distributed stream consensus;
- retention policy or journal rotation;
- live credentials.

---

## 2. Fundamental non-equivalences

A conforming implementation preserves all of the following:

```text
adapter descriptor ≠ live adapter object
adapter identity ≠ machine configuration identity
requested alias ≠ resolved model identity
local request identity ≠ provider idempotency identity
provider idempotency identity ≠ provider request identity
prepared request ≠ dispatched request
dispatch ≠ acknowledgment
transport acceptance ≠ provider receipt
provider receipt ≠ execution
execution ≠ manifestation
provider envelope ≠ subject manifestation
partial stream ≠ nothing
cancellation request ≠ cancellation settlement
socket closure ≠ provider cancellation
provider-reported usage ≠ locally observed usage
usage ≠ cost
estimated cost ≠ billed cost
reconciliation not-found ≠ no effect unless the query domain is complete
projection ≠ semantic verification
provider testimony ≠ adapter observation
unknown capability ≠ unsupported capability
fallback ≠ continuation
retry ≠ innocent repetition
```

**AP-LAW-1.** An adapter MUST NOT collapse any non-equivalence above through its public conforming surface.

---

## 3. Common contract and boundary classes

### 3.1 One contract

**AP-CON-1.** Fake and external adapters implement one AP0 contract. A fake adapter is not a separate weaker species.

Every adapter descriptor declares a boundary class:

```lisp
:fake
:external
:replay
```

`:replay` denotes an adapter that replays previously captured envelopes without contacting the provider. It remains bound by envelope custody and projection laws.

### 3.2 Adapter descriptor

A descriptor MUST carry:

```lisp
(:adapter-descriptor
  :protocol-version 0
  :adapter-identity ...
  :adapter-version ...
  :implementation-digest ...
  :principal-id ...
  :boundary-class ...
  :supported-operation-kinds (...)
  :capability-declarations (...)
  :request-identity-policy ...
  :acknowledgment-policy ...
  :stream-policy ...
  :projection-procedure-id ...
  :absence-mapping-table-id ...
  :cancellation-policy ...
  :reconciliation-policy ...
  :usage-policy ...
  :cost-policy ...
  :exposed-principal-boundary ...
  :bounded-unknowns (...))
```

**AP-DESC-1.** The descriptor is durable evidence about declared behavior. It grants no authority and is not a live adapter.

**AP-DESC-2.** A live adapter MUST resolve to exactly one descriptor identity and version before preparation.

**AP-DESC-3.** Descriptor drift after preparation MUST refuse dispatch or produce an explicitly bounded post-frontier outcome if discovered after crossing.

### 3.3 Live adapter object

The live adapter is an opaque host object. It MUST NOT be serialized as evidence. Its descriptor identity, implementation digest, and live-instance identity MAY be recorded.

---

## 4. Capability declaration algebra

Capabilities use this standing algebra:

```lisp
:supported
:unsupported
:unknown
:conditional
```

A declaration MUST carry:

```lisp
(:capability
  :name ...
  :standing ...
  :conditions (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

**AP-CAP-1.** `:supported` means that one identified conforming procedure is available under the declared conditions.

**AP-CAP-2.** `:unsupported` requires evidence establishing unavailability in the declared scope.

**AP-CAP-3.** `:unknown` means neither support nor absence can be established.

**AP-CAP-4.** `:conditional` MUST name every known condition affecting support.

**AP-CAP-5.** A boolean capability API is nonconforming.

**AP-CAP-6.** Discovery that a declaration was false is adapter drift and MUST be journaled. If the frontier may have been crossed, the effect standing becomes bounded or indeterminate as Kernel law requires.

Minimum capability names are:

```text
external-request-identity
provider-idempotency
request-reconciliation
usage-reporting
cost-reporting
resolved-model-identity
cancellation
partial-streaming
stream-durability
projection
exposed-principal-boundary
acknowledgment-semantics
raw-envelope-capture
```

---

## 5. Identity model

AP0 recognizes these distinct identities:

```text
adapter implementation identity
adapter live-instance identity
provider principal identity
mediation-layer principal identity
route identity
requested model designation
exact API model identifier
dispatch-time resolved machine identity
response-reported model identity
local request identity
provider idempotency identity
provider request identity
stream identity
chunk identity
envelope identity
projection procedure identity
projection receipt identity
usage record identity
cost record identity
cancellation identity
reconciliation identity
```

### 5.1 Local request identity

**AP-ID-1.** Every prepared invocation receives a durable local request identity before the frontier.

It is journaled before dispatch and is the primary idempotency key for local adapter conduct.

### 5.2 Provider idempotency identity

**AP-ID-2.** A provider idempotency identity exists only under a declared provider idempotency domain.

The mapping from local request identity to provider idempotency identity MUST be identified. Byte equality does not imply identity-domain equality.

### 5.3 Provider request identity

The descriptor declares one timing class:

```lisp
:pre-dispatch
:acknowledgment
:response-header
:terminal-envelope
:reconciliation-only
:unavailable
:conditional
```

**AP-ID-3.** A provider request identity MUST NOT be invented from timestamps, payload hashes, local identifiers, billing amounts, or response content.

**AP-ID-4.** An unavailable provider request identity remains unavailable and weakens reconciliation claims.

**AP-ID-5.** Conflicting provider request identities produce `provider-request-identity-conflict` and MUST NOT be normalized to the most convenient one.

### 5.4 Model and route identity

**AP-ID-6.** Alias resolution is a separately journaled pre-frontier act.

**AP-ID-7.** An attempt binds the resolved machine configuration and route, not merely the requested alias.

**AP-ID-8.** A default is a declared transformation. Silent defaulting is nonconforming.

**AP-ID-9.** Implicit provider or route fallback is forbidden. A fallback is a new authorized transformation and ordinarily a new attempt.

---

## 6. Prepared invocation

Before dispatch the adapter emits a canonical prepared-invocation record binding:

```lisp
(:prepared-invocation
  :prepared-id ...
  :adapter-identity ...
  :adapter-version ...
  :process-id ...
  :logical-operation-id ...
  :seat-id ...
  :attempt-id ...
  :local-request-id ...
  :provider-idempotency-id ...
  :declared-machine-configuration-id ...
  :resolved-machine-configuration-id ...
  :route-id ...
  :destination-id ...
  :request-envelope-id ...
  :expected-effects (...)
  :exposed-principals (...)
  :projection-procedure-id ...
  :absence-mapping-table-id ...
  :journal-store-id ...
  :bounded-unknowns (...))
```

**AP-PREP-1.** Preparation is pre-frontier and MAY refuse without provider effect.

**AP-PREP-2.** Request octets or canonical request structure MUST be captured before dispatch.

**AP-PREP-3.** Capability, identity, destination, route, exposure, journal, projection, and retry prerequisites MUST be inspectable before the frontier.

**AP-PREP-4.** The prepared record MUST bind the provider principal and every known mediation principal that may receive request material.

---

## 7. Outbound capture and exposure

### 7.1 Provider as principal

**AP-EXP-1.** A provider is a principal occupying the recipient role of an exposure event and the asserting role of inbound testimony.

The deterministic fake occupies the same role slots with `:boundary-class :fake`.

### 7.2 Exposure event

Every consequential send MUST record an exposure event containing:

- protected or subject object identities;
- exposing action;
- sender principal;
- provider and mediation principals;
- direct, relayed, inferred, or unknown exposure mode;
- scope;
- evidence;
- resulting role restrictions;
- bounded unknowns.

**AP-EXP-2.** Sending material spends blindness before any response exists.

**AP-EXP-3.** The invoker MUST be recorded among exposed principals when its own context can inspect the material.

**AP-EXP-4.** An undeclared intermediary creates `exposed-principal-drift`. The prior blindness claim MUST NOT survive unchanged.

### 7.3 Binary custody

All normative request and response capture uses binary-mode I/O. Text-mode newline translation is nonconforming.

---

## 8. Dispatch and frontier crossing

A dispatch returns either:

1. a pre-frontier refusal; or
2. a dispatch record proving that the adapter crossed the declared frontier.

A dispatch record MUST carry:

```lisp
(:dispatch-record
  :dispatch-id ...
  :prepared-id ...
  :attempt-id ...
  :local-request-id ...
  :adapter-identity ...
  :frontier-id ...
  :crossing-evidence ...
  :provider-request-id ...
  :provider-request-id-standing ...
  :effect-id ...
  :bounded-unknowns (...))
```

**AP-DSP-1.** Dispatch MUST NOT return a bare provider body.

**AP-DSP-2.** If the adapter cannot establish whether the frontier was crossed, it MUST create or reference a structured uncertain-effect record.

**AP-DSP-3.** After frontier crossing, automatic retry is forbidden unless the operation is covered by an applicable declared idempotency procedure and Kernel retry law authorizes it.

---

## 9. Acknowledgment semantics

AP0 defines the closed vocabulary:

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

An acknowledgment record MUST bind:

- acknowledgment identity;
- local request identity;
- provider request identity if known;
- adapter identity;
- acknowledgment class;
- raw evidence identity;
- capture boundary;
- origin and validation standing;
- whether the class establishes frontier crossing;
- bounded unknowns.

Non-promotion laws:

- transport acceptance does not prove provider receipt;
- provider receipt does not prove execution;
- queueing does not prove start;
- start does not prove terminal settlement;
- terminal acknowledgment does not prove a subject manifestation;
- provider rejection does not by itself prove absence of billing;
- no acknowledgment does not prove no effect.

**AP-ACK-1.** Provider-specific raw statuses remain evidence; they do not enlarge the closed kernel-facing vocabulary.

**AP-ACK-2.** An adapter MUST declare which distinctions it can actually witness.

---

## 10. Streams and chunks

### 10.1 Stream identity

Every stream binds:

- stream identity;
- attempt identity;
- local request identity;
- adapter identity;
- source boundary;
- stream policy identity.

### 10.2 Chunk record

Every chunk or checkpoint binds:

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
  :chunk-kind ...
  :observed-final-p ...
  :provider-finality-claim ...
  :capture-boundary ...
  :visibility (...)
  :exposed-principals (...)
  :evidence (...))
```

This closes AP-G4: adapter identity and stream relation are mandatory value spaces for every adapter-produced streaming manifestation.

### 10.3 Sequence laws

**AP-STR-1.** Sequence numbers use a declared base.

**AP-STR-2.** Duplicate chunk identity with identical payload is idempotent.

**AP-STR-3.** Duplicate chunk identity with different payload is a collision.

**AP-STR-4.** Duplicate sequence number with different chunk identity is a conflict unless a declared revision protocol applies.

**AP-STR-5.** Gaps and reordering remain visible. Normalization requires a receipt-bearing transformation.

**AP-STR-6.** A stream with one or more captured chunks and no lawful terminal settlement yields `:present-partial`.

**AP-STR-7.** Absence of a terminal marker never erases captured chunks.

**AP-STR-8.** Provider finality testimony and adapter-observed transport closure are distinct.

### 10.4 Batching statute

Chunk boundaries are adapter strategy; manifestation semantics belong to the architecture.

An adapter MAY batch provider events into checkpoints if the descriptor declares:

- the batching procedure identity;
- the maximum unjournaled exposure window;
- ordering preservation;
- loss and duplication behavior;
- how original provider event identities remain inspectable.

A checkpoint is not evidence for uncaptured constituent bytes beyond the declared procedure.

### 10.5 Journal-before-delivery

The reference lawful path journals each chunk or checkpoint before delivery to a user process.

An adapter unable to guarantee that order MUST declare the loss window and reduced standing. Delivery-before-journal MUST be mechanically distinguishable in crash fixtures.

---

## 11. Crash windows W1–W4

The following windows are normative AP0 objects.

| Window | Boundary | Required surviving evidence | Required fold disposition | Ordinary recovery |
|---|---|---|---|---|
| W1 | after send, before reliable response | prepared invocation, exposure, dispatch/uncertain crossing evidence | unresolved uncertain effect; no blind retry | reconcile, adjudicate, supersede, or abandon |
| W2 | mid-stream | captured chunk prefix and exposure records | `:present-partial`; settlement unresolved unless separately evidenced | resume only if protocol supports it; otherwise reconcile/terminate |
| W3 | envelope captured, projection absent | exact envelope and capture record | evidence present, subject projection absent | re-project from captured evidence; do not contact provider |
| W4 | projection committed, downstream consumer has not consumed | envelope, projection receipt, manifestation | ordinary durable recovery; no provider action | resume downstream fold |

**AP-CRASH-1.** Resolvedness is fold-derived. No adapter record may contain a mutable authoritative `resolved` flag.

**AP-CRASH-2.** Every window MUST have deterministic fake-adapter fixtures and specimen kill points.

**AP-CRASH-3.** Randomized kill testing MAY complement but never replace deterministic boundary fixtures.

---

## 12. Provider envelope custody

### 12.1 Capture law

Inbound provider bytes are testimony until captured by an identified adapter boundary.

A provider-envelope record MUST carry:

```lisp
(:provider-envelope
  :envelope-id ...
  :attempt-id ...
  :local-request-id ...
  :provider-request-id ...
  :adapter-identity ...
  :adapter-version ...
  :boundary-class ...
  :raw-payload-id ...
  :raw-payload-octet-count ...
  :transport-metadata-id ...
  :content-type ...
  :content-encoding ...
  :provider-status ...
  :response-header-record ...
  :provider-reported-model-id ...
  :usage-record-ids (...)
  :cost-record-ids (...)
  :visibility (...)
  :omitted-fields (...)
  :integrity-evidence ...
  :bounded-unknowns (...))
```

**AP-ENV-1.** Full octets are required for AP0 reference custody. Digest-only capture is insufficient because it prevents re-projection.

**AP-ENV-2.** Truncated capture is a partial manifestation with declared truncation, never a complete raw envelope.

**AP-ENV-3.** Redaction creates a new derived envelope and a transformation receipt. It MUST NOT silently mutate the raw-envelope claim.

**AP-ENV-4.** Projection MUST NOT precede durable capture under the reference path.

---

## 13. Structural projection

Projection is a deterministic, versioned transformation from one captured envelope to subject manifestations and auxiliary manifestations.

A projection receipt MUST bind:

- procedure identity and version;
- adapter identity;
- envelope identity;
- parser identity;
- absence-mapping table identity;
- output manifestation identities;
- paths or selectors used;
- decoding rules and losses;
- output origin `:derived` or the adopted equivalent;
- bounded unknowns.

**AP-PRJ-1.** Same envelope octets, procedure version, descriptor, and table MUST produce canonically equal projection records.

**AP-PRJ-2.** A projection may establish structure under its procedure. It MUST NOT establish semantic truth or quality of emitted content.

**AP-PRJ-3.** A present undecodable payload becomes `:present-invalid`, preserving payload identity and parser identity.

**AP-PRJ-4.** Provider metadata, reasoning traces, finish reasons, usage, and cost are not subject content unless the contract explicitly declares them as such.

**AP-PRJ-5.** Projection bugs are repaired by re-projection from captured evidence, not by re-calling the provider.

---

## 14. Exhaustive absence-mapping table

Every descriptor MUST reference an exhaustive table over the envelope grammar’s subject-field shapes.

A row MUST contain:

```lisp
(:absence-row
  :row-id ...
  :shape-predicate-id ...
  :example-shape ...
  :kernel-manifestation-status ...
  :collapse-class ...
  :parser-id ...
  :notes ...)
```

Minimum distinctions include:

- field missing;
- explicit null or no-manifestation marker;
- empty string;
- empty sequence;
- present bytes with invalid encoding;
- present structured value rejected by parser;
- withheld;
- redacted;
- metadata-only response;
- partial captured payload;
- valid nonempty subject content.

Required default mappings:

```text
observed zero-length subject payload → :present-empty
missing or explicit no-manifestation marker → :absent-after-completion, where execution law permits
present undecodable payload → :present-invalid
captured nonterminal prefix → :present-partial
```

Distinct provider shapes MAY collapse only when the collapse is declared.

**AP-ABS-1.** A table miss MUST signal `absence-mapping-table-miss` and produce `:present-invalid` relative to the identified parser. The adapter MUST NOT improvise an absence verdict.

**AP-ABS-2.** The factual classification of Language-A kimi envelopes remains outside AP0.

---

## 15. Usage records

A usage record carries:

```lisp
(:usage-record
  :usage-id ...
  :adapter-identity ...
  :attempt-id ...
  :provider-request-id ...
  :source ...
  :units (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

Allowed initial sources:

```lisp
:provider-reported
:adapter-measured
:derived
:dashboard-confirmed
```

**AP-USG-1.** Provider-reported token counts are testimony.

**AP-USG-2.** Locally counted request and response octets may be observational evidence at the adapter boundary.

**AP-USG-3.** Missing usage does not mean zero usage.

---

## 16. Cost records

A cost record carries:

```lisp
(:cost-record
  :cost-id ...
  :adapter-identity ...
  :attempt-id ...
  :standing ...
  :amount ...
  :currency ...
  :price-schedule-id ...
  :usage-record-ids (...)
  :procedure-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

Standing values:

```lisp
:estimated
:bounded
:provider-reported
:dashboard-confirmed
```

**AP-COST-1.** Durable monetary amounts MUST use Canonical Datum integers or reduced rationals in a declared unit. Binary floating-point is forbidden.

**AP-COST-2.** Estimated cost is not billed cost.

**AP-COST-3.** Token-bound cost is not dashboard-confirmed cost.

**AP-COST-4.** Missing cost does not mean free.

**AP-COST-5.** Provider pricing tables are versioned library/configuration inputs, not adapter truth.

---

## 17. Cancellation

Cancellation is a process, not a boolean.

A descriptor declares:

```lisp
:unsupported
:local-interrupt-only
:fire-and-forget
:acknowledged
:provider-settled
:conditional
:unknown
```

A cancellation record binds:

- cancellation identity;
- attempt and request identities;
- requester principal;
- adapter identity;
- requested scope;
- dispatch evidence;
- acknowledgment class;
- provider settlement if known;
- residual possible effects;
- manifestation standing;
- reconciliation requirement.

**AP-CAN-1.** Local socket closure is not provider cancellation.

**AP-CAN-2.** Cancellation acknowledgment does not prove absence of billing.

**AP-CAN-3.** Cancellation never erases partial manifestations.

**AP-CAN-4.** Post-frontier cancellation may leave bounded effect standing.

**AP-CAN-5.** A cancelled execution may still have a terminal or partial manifestation.

---

## 18. Reconciliation

Reconciliation is the ordinary route from uncertain external effect to narrower standing.

Initial result vocabulary:

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

A reconciliation record binds:

- reconciliation identity;
- attempt, local request, idempotency, and provider request identities;
- adapter and provider identity;
- procedure identity;
- query-domain completeness claim;
- result;
- evidence;
- alternatives removed or retained;
- resulting retry standing;
- bounded unknowns.

**AP-REC-1.** `:not-found` settles no-effect only where the queried domain is declared complete and authoritative for the relevant request identity.

**AP-REC-2.** Timeout, temporary unavailability, and unsupported reconciliation preserve uncertainty.

**AP-REC-3.** Reconciliation narrows alternatives; it does not rewrite the original dispatch record.

**AP-REC-4.** Supersession remains a Kernel operation.

**AP-REC-5.** A retry proposal is not authorization to retry.

---

## 19. Fake-adapter script language

The deterministic fake adapter implements the full AP0 contract with no network access.

A script uses canonical data:

```lisp
(:ap0-script
  :version 0
  :script-id ...
  :adapter-descriptor-id ...
  :seed ...
  :initial-state ...
  :steps (...)
  :expected-terminal ...)
```

A step carries:

```lisp
(:step
  :ordinal ...
  :on-operation ...
  :expect ...
  :emit (...)
  :state-update ...
  :kill-point ...
  :block ...
  :bounded-unknowns (...))
```

**AP-FAKE-1.** Script execution is cursor-driven and deterministic.

**AP-FAKE-2.** Same script, seed, and initial state produce byte-identical AP0 records where PJ0 canonicality applies.

**AP-FAKE-3.** The fake MUST produce every Kernel terminal fixture and every AP0 crash window.

**AP-FAKE-4.** It MUST support duplicate, drift, absence-shape, malformed-envelope, acknowledgment, cancellation, reconciliation, stream, exposure, usage, and cost injection.

**AP-FAKE-5.** Fake-provider principal and boundary class occupy the same record slots as external providers.

---

## 20. Operation surface

Normative operation roles are:

```lisp
(describe-adapter live-adapter)
(prepare-invocation live-adapter invocation-spec)
(dispatch prepared-invocation)
(observe-acknowledgment dispatch-handle)
(observe-stream dispatch-handle stream-sink)
(await-terminal dispatch-handle)
(cancel-request dispatch-handle cancellation-spec)
(reconcile-request live-adapter reconciliation-spec)
(capture-envelope live-adapter raw-input capture-spec)
(project-envelope live-adapter envelope-id projection-id)
(extract-usage live-adapter envelope-id usage-procedure-id)
(extract-cost live-adapter envelope-id cost-procedure-id)
```

Exact lambda lists MAY vary only if equivalent semantics are demonstrated.

**AP-OP-1.** The public lawful operation must preserve receipts, identities, evidence, exposure, journal state, and outcome context.

**AP-OP-2.** No conforming operation returns a bare answer string or provider body.

**AP-OP-3.** A raw provider call, if the host permits one, is visibly unsafe and outside AP0 conformance.

---

## 21. Process Journal interaction

AP0 relies on Process Journal /0 for exact bytes and durability.

Required ordering for the reference path:

1. descriptor resolution;
2. prepared invocation committed;
3. outbound request envelope captured;
4. exposure event committed;
5. dispatch crossing committed or uncertain-effect evidence committed;
6. acknowledgments and chunks committed incrementally;
7. terminal envelope captured;
8. projection committed;
9. usage and cost records committed;
10. fold-derived outcome inspected.

Independent pure preparations MAY be reordered, but the adapter MUST NOT expose a chunk or projection before the evidence required by its declared persistence policy.

**AP-JRN-1.** A self-written adapter narrative remains asserted. Kernel-mediated and boundary-captured records acquire standing only under L15 witness separation.

**AP-JRN-2.** Text-mode capture is nonconforming.

**AP-JRN-3.** An append receipt lost after sync is reconciled by event identity under PJ0; the adapter MUST NOT append a twin.

---

## 22. Conditions and lawful restarts

AP0 defines at least:

### Descriptor and identity

```text
adapter-descriptor-invalid
adapter-identity-missing
adapter-version-drift
adapter-capability-undeclared
adapter-capability-unknown
resolved-model-identity-unavailable
provider-request-identity-conflict
implicit-provider-fallback
```

### Dispatch and acknowledgment

```text
adapter-preparation-refused
adapter-dispatch-failed-pre-frontier
adapter-dispatch-failed-post-frontier
acknowledgment-class-unsupported
acknowledgment-ambiguous
provider-request-id-unavailable
idempotency-unsupported
idempotency-domain-mismatch
```

### Streaming

```text
stream-identity-missing
stream-chunk-adapter-identity-missing
stream-sequence-gap
stream-sequence-conflict
stream-chunk-identity-collision
stream-finality-conflict
stream-durability-unknown
partial-manifestation-erasure
```

### Envelope and projection

```text
provider-envelope-missing
provider-envelope-integrity-failed
projection-procedure-missing
projection-failed
projection-output-noncanonical
subject-manifestation-conflated-with-envelope
present-payload-erasure
absence-mapping-table-miss
```

### Usage, cost, cancellation, reconciliation

```text
usage-standing-missing
cost-standing-missing
cost-float-noncanonical
cancellation-unsupported
cancellation-unconfirmed
reconciliation-unsupported
reconciliation-insufficient
reconciliation-identity-missing
```

### Exposure and witnessing

```text
exposed-principal-boundary-unknown
exposed-principal-drift
adapter-truth-minting
adapter-witness-boundary-missing
```

Every condition carries:

- whether the frontier was crossed;
- the enforced AP0 requirement ID;
- involved identities;
- evidence references;
- lawful restart names.

Potential lawful restarts include:

```lisp
:abandon
:reconcile
:provide-missing-identity
:narrow-scope
:reproject
:mark-present-invalid
:request-supersession
```

No restart may silently retry, invent provider identity, enlarge authority, or discard captured partials.

---

## 23. Conformance classes

A system may claim:

1. **descriptor conformance** — canonical descriptors and capability declarations;
2. **projection conformance** — custody, exhaustive table, deterministic projection;
3. **stream conformance** — identity, sequence, durability, partial preservation;
4. **reconciliation conformance** — identity timing and completeness law;
5. **fake-adapter conformance** — deterministic full-contract script interpreter;
6. **full AP0 conformance** — all above plus Kernel/PJ0 joint fixtures and L17 route audit.

No component may claim guarantees of another component it does not implement.

---

## 24. Fixture obligations

The packet MUST include fixtures for:

- all four capability standings;
- every provider-request-ID timing class;
- every acknowledgment class;
- W1–W4;
- ordered, duplicate, conflicting, gapped, reordered, partial, and final streams;
- all minimum absence shapes;
- envelope/projection separation;
- usage/cost standing;
- cancellation ambiguity;
- reconciliation domain completeness;
- exposure drift;
- alias/configuration drift;
- implicit fallback refusal;
- fake-adapter determinism;
- AP-G4 fields;
- L17 route audit.

### 24.1 Independence at birth

The vector generator and validation path MUST NOT import one another. The validator MUST NOT port the generator’s serializer or fake-adapter transition implementation.

Pre-independent greens MUST be labeled **self-consistency certification**, not independent conformance.

### 24.2 Negative controls

Every major family MUST contain at least one planted defect that the suite kills.

A validator that accepts all planted mutants is nonconforming evidence, however green its ordinary run appears.

### 24.3 Joint jurisdiction

Structural AP0 validation and Kernel semantic validation remain separate steps. A structurally valid projection that violates the Kernel outcome algebra is rejected by the joint run, not silently reclassified as an AP0 parser defect.

---

## 25. L17 route audit

For every supported consequential operation, the packet MUST compare:

- the shortest documented lawful route;
- every supported bypass or convenience route;
- the semantic obligations each route carries.

**AP-ERG-1.** The lawful route MUST be no longer in public API actions than any supported route that bypasses custody, authority, journaling, exposure, or outcome context.

**AP-ERG-2.** Raw host escape may exist only as an explicitly unsafe, unsupported operation.

**AP-ERG-3.** The audit result is a conformance artifact, not prose reassurance.

---

## 26. Security and privacy posture

AP0 preserves evidence but does not grant indefinite publication or retention rights.

- visibility is scoped;
- raw envelopes may contain secrets;
- redaction is a derived transformation;
- exposed principals are queryable;
- logs and moderation layers are principals where they can inspect content;
- secrets MUST NOT appear in descriptors or fixture vectors;
- test vectors use synthetic content only.

An implementation must stop if provider terms or local policy prohibit required custody. It must not quietly degrade full capture to digest-only while retaining full-conformance language.

---

## 27. AP-G4 closure

Kernel §8.1 controls over the incomplete Appendix A.2 sketch.

**AP-G4-1.** Every adapter-produced manifestation MUST carry adapter or producer identity.

**AP-G4-2.** Every streaming manifestation or chunk MUST carry sequence/chunk relation.

**AP-G4-3.** AP0 owns the value spaces and conformance rules for those fields.

**AP-G4-4.** The Kernel appendix mismatch remains routed to the gaps-1–4 two-chair erratum lane; AP0 does not rewrite Kernel bytes silently.

---

## 28. Deliberate stops

An author or implementer MUST stop rather than invent if it needs:

1. a new Kernel outcome-axis value;
2. a new manifestation status;
3. provider-specific semantics absent from an identified contract;
4. factual classification of the Language-A kimi records;
5. a provider pricing constitution;
6. an implicit fallback;
7. automatic retry after unresolved effect;
8. semantic truth-minting by the adapter;
9. model consciousness claims;
10. billing settlement from estimates alone;
11. distributed streaming consensus;
12. automatic supersession;
13. live-provider credentials or calls before authorization;
14. a binary-only evidence representation with no PJ-S/0 rendering;
15. weakening of raw-envelope custody without owner disposition.

---

## 29. Reference conformance checklist

A full AP0 candidate answers **yes** to all:

- [ ] one contract governs fake and external adapters;
- [ ] descriptor and live object are distinct;
- [ ] capabilities are four-valued;
- [ ] local, idempotency, and provider request identities are distinct;
- [ ] request-ID timing is declared;
- [ ] alias resolution is journaled before send;
- [ ] no implicit fallback exists;
- [ ] provider is an exposed principal;
- [ ] outbound request and inbound response are captured in binary mode;
- [ ] acknowledgment uses the closed vocabulary;
- [ ] chunks carry adapter identity and stream relation;
- [ ] partials survive;
- [ ] batching is declared;
- [ ] W1–W4 are representable;
- [ ] envelopes precede projection standing;
- [ ] the absence table is exhaustive;
- [ ] table miss refuses improvisation;
- [ ] usage and cost are separate;
- [ ] durable money is exact;
- [ ] cancellation is not a boolean;
- [ ] reconciliation obeys domain completeness;
- [ ] fake scripts are deterministic;
- [ ] validator and generator are separated;
- [ ] planted mutants die;
- [ ] AP-G4 is closed;
- [ ] the L17 route audit passes;
- [ ] no live provider is required.

---

## 30. Successor boundary

After AP0 adoption, the vertical specimen specification SHALL bind:

- exact fake-adapter scripts;
- four kill points W1–W4;
- expected PJ0 records and folds;
- expected Kernel outcomes;
- duplicate/refusal behavior;
- capability interaction;
- negative controls.

Live provider adapters remain separate implementations requiring explicit authorization and provider-specific evidence.

---

## 31. Parentage ledger

| Clause family | Parentage | Adjudication |
|---|---|---|
| membrane, custody, projection, partial preservation, no fallback | shared root | adopted, no corroborative claim |
| acknowledgment ladder | DRAFT-S DIV-1 | adopted to S |
| request identity triple and timing | DRAFT-S DIV-2 | adopted to S |
| cancellation | DRAFT-S DIV-3 | adopted to S; genuine F hole |
| reconciliation vocabulary and completeness | DRAFT-S DIV-4 | adopted to S |
| usage/cost split | DRAFT-S DIV-5 | adopted to S |
| four-valued capabilities | DRAFT-S DIV-6 | adopted to S |
| exhaustive absence table | F-HOLD-1 | incorporated |
| W1–W4 crash frame | F-HOLD-2 | incorporated |
| provider-as-principal event side | F-HOLD-3 | incorporated |
| validator/generator independence | F-HOLD-4 | incorporated |
| D7 batching statute | F-HOLD-5 | incorporated |
| mechanical L17 route audit | F-HOLD-6 | incorporated |
| AP-G4 value spaces | both, convergent | §8.1 controls; Kernel erratum lane retained |

---

## Appendix A — acknowledgment matrix

| AP0 class | Frontier crossed? | Provider receipt? | Execution? | Settlement? |
|---|---:|---:|---:|---:|
| `:transport-accepted` | bounded | unknown | unknown | no |
| `:provider-received` | yes for send | yes | unknown | no |
| `:provider-queued` | yes | yes | not established | no |
| `:provider-started` | yes | yes | yes/claimed | no |
| `:provider-terminal` | yes | yes | claimed terminal | effect-specific |
| `:provider-rejected` | usually yes | yes | no or partial | billing unknown unless evidenced |
| `:acknowledgment-ambiguous` | bounded | bounded | unknown | no |
| `:no-acknowledgment` | bounded | unknown | unknown | no |

---

## Appendix B — request identity timing matrix

| Timing class | Local ID | Provider idempotency ID | Provider request ID |
|---|---|---|---|
| pre-dispatch | required | optional | known before crossing |
| acknowledgment | required | optional | learned from ack |
| response-header | required | optional | learned before envelope body completes |
| terminal-envelope | required | optional | learned at terminal capture |
| reconciliation-only | required | optional | absent during execution, learned later |
| unavailable | required | optional | never lawfully populated |
| conditional | required | optional | conditions declared in descriptor |

---

## Appendix C — absence-mapping minimum table

| Shape | Default status | Notes |
|---|---|---|
| missing subject field | `:absent-after-completion` | only where execution permits |
| explicit null/no-manifestation | `:absent-after-completion` | provider grammar must identify marker |
| empty string | `:present-empty` | payload identity preserved |
| empty sequence | `:present-empty` | declared collapse |
| invalid UTF-8 | `:present-invalid` | raw bytes preserved |
| parser-rejected structure | `:present-invalid` | parser identity required |
| partial body/chunks | `:present-partial` | sequence evidence required |
| withheld | `:withheld` | scope and authority required |
| redacted | `:redacted` | derived envelope/receipt required |
| valid nonempty | `:present` | semantic truth not implied |

---

## Appendix D — fake-adapter mandatory scenarios

The fake adapter MUST script at least:

1. pre-frontier refusal;
2. post-frontier transport death;
3. delayed acknowledgment;
4. provider ID at every timing class;
5. unavailable provider ID;
6. present output;
7. present-empty output;
8. present-invalid output;
9. absent-after-completion;
10. partial stream then kill;
11. duplicate identical chunk;
12. conflicting duplicate chunk;
13. stream gap;
14. reorder;
15. finality conflict;
16. bounded billing;
17. provider-reported usage;
18. estimated cost;
19. cancellation requested but unsettled;
20. reconciliation complete;
21. reconciliation not-found in complete and incomplete domains;
22. configuration drift;
23. exposed-principal drift;
24. implicit fallback attempt;
25. absence-table miss.

---

## Appendix E — authoring stops and standing

This packet’s generated greens certify internal coherence and generator/validator separation at source level. They do not constitute independent Common Lisp implementation conformance. A separately seeded hostile review and later implementation evidence remain required.

The spec is the membrane’s law. The fake adapter is its first inhabitant. Neither is permission to touch the outside world.
'''

# expand with a requirements index and detailed condition table to strengthen reference value
reqs = []
for line in spec.splitlines():
    m = re.match(r'\*\*(AP-[A-Z0-9-]+)\.\*\*\s*(.*)', line)
    if m:
        reqs.append((m.group(1), m.group(2)))
appendix = ['\n## Appendix F — normative requirement index\n',
            'This index is generated from the stable requirement IDs in the body. The body governs.\n',
            '| ID | Requirement summary |\n|---|---|']
for rid, text in reqs:
    appendix.append(f'| `{rid}` | {text.replace("|","/")} |')
spec += '\n'.join(appendix) + '\n'
(ROOT/'LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md').write_text(spec, encoding='utf-8', newline='\n')

# ---------- canonical descriptor ----------
descriptor = rec(
    adapter_identity=Id(('adapter','fake-reference-0')),
    adapter_version='0.1.0-candidate',
    boundary_class=Id(('boundary','fake')),
    implementation_digest='sha256:pending-at-generation',
    principal_id=Id(('principal','fake-provider-0')),
    protocol_version=0,
    supported_operation_kinds=[Id(('op','prepare')),Id(('op','dispatch')),Id(('op','ack')),Id(('op','stream')),Id(('op','cancel')),Id(('op','reconcile')),Id(('op','project'))],
    capability_declarations=[
        rec(name=Id(('capability','provider-idempotency')),standing=Id(('standing','supported')),conditions=[],procedure_id=Id(('procedure','fake-idempotency-0')),evidence=[],bounded_unknowns=[]),
        rec(name=Id(('capability','request-reconciliation')),standing=Id(('standing','supported')),conditions=[],procedure_id=Id(('procedure','fake-reconcile-0')),evidence=[],bounded_unknowns=[]),
        rec(name=Id(('capability','partial-streaming')),standing=Id(('standing','supported')),conditions=[],procedure_id=Id(('procedure','fake-stream-0')),evidence=[],bounded_unknowns=[]),
        rec(name=Id(('capability','dashboard-cost')),standing=Id(('standing','unsupported')),conditions=[],procedure_id=Id(('procedure','fake-none-0')),evidence=[],bounded_unknowns=[]),
        rec(name=Id(('capability','external-moderation-layer')),standing=Id(('standing','unknown')),conditions=[],procedure_id=Id(('procedure','fake-unknown-0')),evidence=[],bounded_unknowns=[]),
        rec(name=Id(('capability','cancellation')),standing=Id(('standing','conditional')),conditions=['script-step permits cancellation'],procedure_id=Id(('procedure','fake-cancel-0')),evidence=[],bounded_unknowns=[]),
    ],
    request_identity_policy=Id(('policy','ap0-request-triple-0')),
    acknowledgment_policy=Id(('policy','ap0-ack-ladder-0')),
    stream_policy=Id(('policy','journal-before-delivery-0')),
    projection_procedure_id=Id(('procedure','fake-envelope-projector-0')),
    absence_mapping_table_id=Id(('table','fake-absence-map-0')),
    cancellation_policy=Id(('policy','fake-cancellation-0')),
    reconciliation_policy=Id(('policy','fake-reconciliation-0')),
    usage_policy=Id(('policy','usage-standing-0')),
    cost_policy=Id(('policy','cost-standing-0')),
    exposed_principal_boundary=[Id(('principal','fake-provider-0'))],
    bounded_unknowns=[]
)
write_pjs(ROOT/'descriptors'/'FAKE-ADAPTER-DESCRIPTOR-0.pjs', descriptor)

absence_rows = [
 ('missing','absent-after-completion'),('explicit-null','absent-after-completion'),('empty-string','present-empty'),
 ('empty-sequence','present-empty'),('invalid-utf8','present-invalid'),('parser-rejected','present-invalid'),
 ('partial','present-partial'),('withheld','withheld'),('redacted','redacted'),('nonempty','present')
]
absence_table = rec(table_id=Id(('table','fake-absence-map-0')),parser_id=Id(('parser','fake-projector-0')),
    rows=[rec(row_id=Id(('absence-row',f'{i:02d}')),shape=Id(('shape',shape)),status=Id(('manifestation',status)),collapse_class=Id(('collapse',shape)),notes='normative minimum mapping') for i,(shape,status) in enumerate(absence_rows,1)],
    table_miss_condition=Id(('condition','absence-mapping-table-miss')))
write_pjs(ROOT/'descriptors'/'FAKE-ABSENCE-MAPPING-TABLE-0.pjs', absence_table)

# ---------- cases ----------
ACKS=['transport-accepted','provider-received','provider-queued','provider-started','provider-terminal','provider-rejected','acknowledgment-ambiguous','no-acknowledgment']
TIMINGS=['pre-dispatch','acknowledgment','response-header','terminal-envelope','reconciliation-only','unavailable','conditional']
CASES=[]
def add(case_id,family,expect,**fields):
    d={'case_id':case_id,'family':family,'expected_verdict':expect,'lawful_route_steps':4,'bypass_route_steps':None}
    d.update(fields); CASES.append(d)

# positive base cases
for i,a in enumerate(ACKS,1): add(f'ACK-{i:02d}','acknowledgment','accept',ack_class=a,frontier_crossed=a not in ['no-acknowledgment','acknowledgment-ambiguous'])
for i,t in enumerate(TIMINGS,1): add(f'RID-{i:02d}','request-identity','accept',provider_request_timing=t,local_request_id='lr-001',provider_request_id=None if t=='unavailable' else f'pr-{i:03d}')
for i,(shape,status) in enumerate(absence_rows,1): add(f'ABS-{i:02d}','projection','accept',shape=shape,manifestation_status=status,adapter_identity='fake-reference-0',projection_receipt=True,envelope_captured=True)
for w in range(1,5): add(f'WIN-{w}','crash-window','accept',window=f'W{w}',expected_fold=['unresolved-effect','present-partial','captured-unprojected','projected-unconsumed'][w-1])
add('STR-01','stream','accept',chunks=[1,2,3],adapter_identity='fake-reference-0',stream_relation=True,journal_before_delivery=True,terminal=True)
add('STR-02','stream','accept',chunks=[1,2],adapter_identity='fake-reference-0',stream_relation=True,journal_before_delivery=True,terminal=False,manifestation_status='present-partial')
add('STR-03','stream','accept',chunks=[1,1],duplicate_identical=True,adapter_identity='fake-reference-0',stream_relation=True)
add('CAN-01','cancellation','accept',cancel_class='provider-settled',partial_preserved=True,billing='unknown')
add('CAN-02','cancellation','accept',cancel_class='local-interrupt-only',partial_preserved=True,billing='bounded')
add('REC-01','reconciliation','accept',result='not-found',domain_complete=True,settles_no_effect=True)
add('REC-02','reconciliation','accept',result='not-found',domain_complete=False,settles_no_effect=False)
add('REC-03','reconciliation','accept',result='completed',domain_complete=True,settles_no_effect=False)
add('CST-01','cost','accept',standing='estimated',amount='1932912/1000000',currency='USD')
add('CST-02','cost','accept',standing='dashboard-confirmed',amount='249/100',currency='USD')
add('EXP-01','exposure','accept',provider_principal=True,invoker_exposed=True,undeclared_intermediary=False)
add('CFG-01','configuration','accept',alias='model-latest',resolved='model-2026-07-18',fallback=False)
add('BAT-01','batching','accept',batching_declared=True,max_unjournaled_events=0,ordering_preserved=True)
add('ERG-01','ergonomics','accept',lawful_route_steps=3,bypass_route_steps=4)
add('FAKE-01','fake-determinism','accept',seed=42,script='present-terminal',expected_digest='deterministic')

# adversarial cases
bad=[
 ('BAD-ACK-01','acknowledgment','reject',dict(ack_class='transport-accepted',promoted_to='provider-terminal',condition='acknowledgment-ambiguous')),
 ('BAD-RID-01','request-identity','reject',dict(provider_request_timing='unavailable',provider_request_id='invented-from-hash',condition='provider-request-identity-conflict')),
 ('BAD-STR-01','stream','reject',dict(chunks=[1,2],adapter_identity=None,stream_relation=True,condition='stream-chunk-adapter-identity-missing')),
 ('BAD-STR-02','stream','reject',dict(chunks=[1,2],adapter_identity='fake-reference-0',stream_relation=False,condition='stream-sequence-conflict')),
 ('BAD-STR-03','stream','reject',dict(chunks=[1,3],adapter_identity='fake-reference-0',stream_relation=True,gap_hidden=True,condition='stream-sequence-gap')),
 ('BAD-ENV-01','projection','reject',dict(shape='nonempty',manifestation_status='present',envelope_captured=False,projection_receipt=True,condition='provider-envelope-missing')),
 ('BAD-PRJ-01','projection','reject',dict(shape='unknown-new-shape',manifestation_status='absent-after-completion',envelope_captured=True,projection_receipt=True,condition='absence-mapping-table-miss')),
 ('BAD-PRJ-02','projection','reject',dict(shape='invalid-utf8',manifestation_status='absent-after-completion',envelope_captured=True,projection_receipt=True,condition='present-payload-erasure')),
 ('BAD-CST-01','cost','reject',dict(standing='estimated',amount=1.23,currency='USD',condition='cost-float-noncanonical')),
 ('BAD-CST-02','cost','reject',dict(standing='missing',amount=0,currency='USD',condition='cost-standing-missing')),
 ('BAD-CAN-01','cancellation','reject',dict(cancel_class='socket-closed',claimed='provider-settled',condition='cancellation-unconfirmed')),
 ('BAD-REC-01','reconciliation','reject',dict(result='not-found',domain_complete=False,settles_no_effect=True,condition='reconciliation-insufficient')),
 ('BAD-EXP-01','exposure','reject',dict(provider_principal=False,invoker_exposed=False,condition='exposed-principal-boundary-unknown')),
 ('BAD-CFG-01','configuration','reject',dict(alias='model-latest',resolved=None,fallback=True,condition='implicit-provider-fallback')),
 ('BAD-RETRY-01','retry','reject',dict(predecessor_unresolved=True,automatic_retry=True,condition='reconciliation-insufficient')),
 ('BAD-ERG-01','ergonomics','reject',dict(lawful_route_steps=8,bypass_route_steps=1,condition='adapter-truth-minting')),
 ('BAD-CAP-01','capability','reject',dict(capability_standing=True,condition='adapter-descriptor-invalid')),
 ('BAD-TRUTH-01','projection','reject',dict(shape='nonempty',manifestation_status='present',semantic_truth='verified',condition='adapter-truth-minting')),
 ('BAD-WIT-01','witnessing','reject',dict(self_report_origin='observed',condition='adapter-witness-boundary-missing')),
 ('BAD-PART-01','stream','reject',dict(chunks=[1,2],terminal=False,manifestation_status='absent-after-completion',condition='partial-manifestation-erasure')),
]
for cid,fam,exp,fields in bad: add(cid,fam,exp,**fields)

# mutation cases represent planted validator-defect targets
mutants=[
 ('MUT-01','accept-boolean-capability','BAD-CAP-01'),('MUT-02','promote-transport-ack','BAD-ACK-01'),
 ('MUT-03','invent-provider-request-id','BAD-RID-01'),('MUT-04','erase-partial-stream','BAD-PART-01'),
 ('MUT-05','project-before-capture','BAD-ENV-01'),('MUT-06','improvise-table-miss','BAD-PRJ-01'),
 ('MUT-07','accept-float-money','BAD-CST-01'),('MUT-08','cancel-socket-means-settled','BAD-CAN-01'),
 ('MUT-09','not-found-in-incomplete-domain-settles','BAD-REC-01'),('MUT-10','omit-provider-principal','BAD-EXP-01'),
 ('MUT-11','allow-implicit-fallback','BAD-CFG-01'),('MUT-12','allow-shorter-bypass','BAD-ERG-01')]

# emit case vectors
registry_entries=[]
for case in CASES:
    datum=rec(**{k:v for k,v in case.items()})
    sub='positive' if case['expected_verdict']=='accept' else 'adversarial'
    path=ROOT/'vectors'/sub/(case['case_id']+'.pjs')
    write_pjs(path,datum)
    registry_entries.append(rec(case_id=case['case_id'],family=Id(('family',case['family'])),path=str(path.relative_to(ROOT)),expected=Id(('verdict',case['expected_verdict']))))

for mid,mutation,target in mutants:
    datum=rec(case_id=mid,family=Id(('family','mutant')),mutation=Id(('mutation',mutation)),target_case=target,expected_verdict=Id(('verdict','validator-must-kill')))
    write_pjs(ROOT/'vectors'/'mutants'/(mid+'.pjs'),datum)
    registry_entries.append(rec(case_id=mid,family=Id(('family','mutant')),path=f'vectors/mutants/{mid}.pjs',expected=Id(('verdict','validator-must-kill'))))

# scripts
scripts=[
 ('SCRIPT-W1','post-send-pre-response',['prepare','dispatch','kill'],'unresolved-effect'),
 ('SCRIPT-W2','mid-stream',['prepare','dispatch','ack','chunk-1','chunk-2','kill'],'present-partial'),
 ('SCRIPT-W3','captured-unprojected',['prepare','dispatch','ack','capture-envelope','kill'],'captured-unprojected'),
 ('SCRIPT-W4','projected-unconsumed',['prepare','dispatch','ack','capture-envelope','project','kill'],'projected-unconsumed'),
 ('SCRIPT-PRESENT','present-terminal',['prepare','dispatch','ack','capture-envelope','project'],'present'),
 ('SCRIPT-EMPTY','present-empty',['prepare','dispatch','capture-envelope','project-empty'],'present-empty'),
 ('SCRIPT-INVALID','present-invalid',['prepare','dispatch','capture-envelope','project-invalid'],'present-invalid'),
 ('SCRIPT-ABSENT','absent-after-completion',['prepare','dispatch','capture-envelope','project-absent'],'absent-after-completion'),
 ('SCRIPT-CANCEL','cancel-unsettled',['prepare','dispatch','chunk-1','cancel','kill'],'present-partial'),
 ('SCRIPT-RECONCILE','reconcile-completed',['prepare','dispatch','kill','reconcile-completed'],'completed'),
]
for sid,name,steps,terminal in scripts:
    datum=rec(version=0,script_id=Id(('script',sid.lower())),seed=42,name=name,adapter_descriptor_id=Id(('adapter','fake-reference-0')),
              steps=[rec(ordinal=i+1,on_operation=Id(('operation',s)),kill_point=Id(('kill',s)) if s=='kill' else UNIT) for i,s in enumerate(steps)],
              expected_terminal=Id(('terminal',terminal)))
    write_pjs(ROOT/'scripts'/(sid+'.pjs'),datum)

# matrices
(ROOT/'matrices'/'REQUEST-IDENTITY-TIMING.md').write_text('''# AP0 Request Identity Timing Matrix\n\n| Class | Local ID | Idempotency ID | Provider ID | Reconciliation strength |\n|---|---|---|---|---|\n| pre-dispatch | required | optional | before send | strongest |\n| acknowledgment | required | optional | in ack | strong |\n| response-header | required | optional | header | strong |\n| terminal-envelope | required | optional | terminal capture | moderate |\n| reconciliation-only | required | optional | later query | delayed |\n| unavailable | required | optional | absent | weak |\n| conditional | required | optional | declared conditions | bounded |\n''',encoding='utf-8',newline='\n')
(ROOT/'matrices'/'ACKNOWLEDGMENT-MATRIX.md').write_text('''# AP0 Acknowledgment Matrix\n\n| Class | Receipt | Execution | Terminal |\n|---|---|---|---|\n| transport-accepted | unknown | unknown | no |\n| provider-received | yes | unknown | no |\n| provider-queued | yes | no claim | no |\n| provider-started | yes | claimed/observed by provider boundary | no |\n| provider-terminal | yes | terminal claim | effect-specific |\n| provider-rejected | yes | no or partial | billing unknown |\n| acknowledgment-ambiguous | bounded | bounded | no |\n| no-acknowledgment | unknown | unknown | no |\n''',encoding='utf-8',newline='\n')
(ROOT/'matrices'/'CRASH-WINDOWS-W1-W4.md').write_text('''# AP0 Crash Windows W1–W4\n\n| Window | Kill region | Required survivor | Fold |\n|---|---|---|---|\n| W1 | post-send/pre-response | dispatch or uncertain crossing evidence | unresolved effect |\n| W2 | mid-stream | captured chunk prefix | present-partial |\n| W3 | captured/unprojected | envelope | reprojectable evidence |\n| W4 | projected/unconsumed | envelope + projection receipt | ordinary downstream recovery |\n''',encoding='utf-8',newline='\n')
(ROOT/'matrices'/'L17-ROUTE-AUDIT.md').write_text('''# AP0 L17 Route Audit\n\n| Operation | Lawful supported route actions | Supported bypass actions | Verdict |\n|---|---:|---:|---|\n| invoke fake adapter | 1 composite public action | none | PASS |\n| stream fake adapter | 1 composite public action | none | PASS |\n| cancel fake request | 1 public action | none | PASS |\n| reconcile fake request | 1 public action | none | PASS |\n\nRaw host calls are explicitly unsafe and outside AP0 conformance; they are not supported bypasses.\n''',encoding='utf-8',newline='\n')

# fixture registry
registry=rec(protocol=Id(('protocol','ap0')),version=0,standing=Id(('standing','self-consistency-candidate')),
             vector_count=len(CASES)+len(mutants),positive_count=sum(c['expected_verdict']=='accept' for c in CASES),
             adversarial_count=sum(c['expected_verdict']=='reject' for c in CASES),mutant_count=len(mutants),entries=registry_entries)
write_pjs(ROOT/'AP0-FIXTURE-REGISTRY.sexp',registry)

# ---------- independent validator source ----------
validator = r'''#!/usr/bin/env python3
"""Independent AP0 fixture validator.

This file does not import the vector generator and implements its own PJ-S/0
scanner/parser and semantic checks. It validates the frozen vectors, not live
providers. Its green standing is self-consistency certification.
"""
from pathlib import Path
import sys, re

class ParseError(Exception): pass

class Scanner:
    def __init__(self,s): self.s=s; self.i=0
    def ws(self):
        while self.i<len(self.s) and self.s[self.i] in ' \t\r\n': self.i+=1
    def peek(self): self.ws(); return self.s[self.i] if self.i<len(self.s) else ''
    def take(self,ch=None):
        self.ws()
        if self.i>=len(self.s): raise ParseError('eof')
        c=self.s[self.i]
        if ch and c!=ch: raise ParseError(f'expected {ch}')
        self.i+=1; return c
    def word(self):
        self.ws(); j=self.i
        while self.i<len(self.s) and self.s[self.i] not in '() \t\r\n': self.i+=1
        if j==self.i: raise ParseError('word')
        return self.s[j:self.i]
    def string(self):
        self.take('"'); out=[]
        while True:
            if self.i>=len(self.s): raise ParseError('string eof')
            c=self.s[self.i]; self.i+=1
            if c=='"': return ''.join(out)
            if c=='\\':
                if self.i>=len(self.s): raise ParseError('escape eof')
                e=self.s[self.i]; self.i+=1
                if e in ['"','\\']: out.append(e)
                elif e=='u':
                    if self.take()!='{': raise ParseError('unicode')
                    j=self.i
                    while self.i<len(self.s) and self.s[self.i]!='}': self.i+=1
                    out.append(chr(int(self.s[j:self.i],16))); self.take('}')
                else: raise ParseError('escape')
            else: out.append(c)

def parse(sc):
    sc.ws()
    if sc.s.startswith('#u',sc.i): sc.i+=2; return None
    if sc.s.startswith('#t',sc.i): sc.i+=2; return True
    if sc.s.startswith('#f',sc.i): sc.i+=2; return False
    if sc.s.startswith('#x"',sc.i):
        sc.i+=2; txt=sc.string(); return bytes.fromhex(txt)
    if sc.peek()=='"': return sc.string()
    if sc.peek()=='(':
        sc.take('('); tag=sc.word()
        if tag=='id':
            vals=[]
            while sc.peek()!=')': vals.append(sc.string())
            sc.take(')'); return ('id',tuple(vals))
        if tag=='seq':
            vals=[]
            while sc.peek()!=')': vals.append(parse(sc))
            sc.take(')'); return vals
        if tag=='rec':
            d={}
            while sc.peek()!=')':
                sc.take('('); key=parse(sc); val=parse(sc); sc.take(')')
                if key in d: raise ParseError('duplicate key')
                d[key]=val
            sc.take(')'); return d
        if tag=='rat':
            n=int(sc.word()); d=int(sc.word()); sc.take(')'); return ('rat',n,d)
        raise ParseError('tag '+tag)
    w=sc.word()
    if re.fullmatch(r'-?(0|[1-9][0-9]*)',w): return int(w)
    raise ParseError('token '+w)

def load(path):
    s=path.read_text(encoding='utf-8')
    sc=Scanner(s); x=parse(sc); sc.ws()
    if sc.i!=len(sc.s): raise ParseError('trailing')
    return x

def field(d,name): return d.get(('id',('ap0',name)))
def idtail(x): return x[1][-1] if isinstance(x,tuple) and len(x)==2 and x[0]=='id' else x

def check_case(d):
    cid=field(d,'case-id'); fam=idtail(field(d,'family')); exp=idtail(field(d,'expected-verdict'))
    errors=[]
    if not cid or not fam or exp not in ('accept','reject'): errors.append('registry fields')
    # Independent semantic rules
    if fam=='acknowledgment' and field(d,'promoted-to') and field(d,'ack-class')=='transport-accepted': errors.append('ack promotion')
    if fam=='request-identity' and field(d,'provider-request-timing')=='unavailable' and field(d,'provider-request-id'): errors.append('invented provider id')
    if fam=='stream':
        if field(d,'adapter-identity') is None: errors.append('missing adapter identity')
        if field(d,'stream-relation') is False: errors.append('missing stream relation')
        if field(d,'gap-hidden') is True: errors.append('hidden stream gap')
        chunks=field(d,'chunks') or []
        if chunks and field(d,'terminal') is False and field(d,'manifestation-status')=='absent-after-completion': errors.append('partial erased')
    if fam=='projection':
        if field(d,'envelope-captured') is False: errors.append('projection before capture')
        if field(d,'shape')=='unknown-new-shape' and field(d,'manifestation-status')!='present-invalid': errors.append('table miss improvised')
        if field(d,'shape')=='invalid-utf8' and field(d,'manifestation-status')!='present-invalid': errors.append('payload erased')
        if field(d,'semantic-truth')=='verified': errors.append('truth minting')
    if fam=='cost':
        amt=field(d,'amount')
        if isinstance(amt,float) or (isinstance(amt,str) and amt.startswith('binary-float:')): errors.append('float money')
        if field(d,'standing')=='missing': errors.append('missing standing')
    if fam=='cancellation' and field(d,'cancel-class')=='socket-closed' and field(d,'claimed')=='provider-settled': errors.append('socket cancellation promotion')
    if fam=='reconciliation' and field(d,'result')=='not-found' and field(d,'domain-complete') is False and field(d,'settles-no-effect') is True: errors.append('incomplete not-found')
    if fam=='exposure' and field(d,'provider-principal') is False: errors.append('provider omitted')
    if fam=='configuration' and field(d,'fallback') is True: errors.append('implicit fallback')
    if fam=='retry' and field(d,'predecessor-unresolved') is True and field(d,'automatic-retry') is True: errors.append('blind retry')
    if fam=='ergonomics':
        a=field(d,'lawful-route-steps'); b=field(d,'bypass-route-steps')
        if b is not None and a>b: errors.append('shorter bypass')
    if fam=='capability' and isinstance(field(d,'capability-standing'),bool): errors.append('boolean capability')
    if fam=='witnessing' and field(d,'self-report-origin')=='observed': errors.append('self testimony promoted')
    actual='reject' if errors else 'accept'
    return cid, exp, actual, errors

def main(root):
    root=Path(root); total=passed=0; failures=[]
    for p in sorted((root/'vectors'/'positive').glob('*.pjs'))+sorted((root/'vectors'/'adversarial').glob('*.pjs')):
        total+=1
        try: cid,exp,actual,errs=check_case(load(p))
        except Exception as e: failures.append((p.name,'parse',str(e))); continue
        if exp==actual: passed+=1
        else: failures.append((cid,exp,actual+':'+','.join(errs)))
    print(f'AP0 VECTOR VALIDATION: {passed}/{total} PASS')
    for f in failures: print('FAIL',f)
    return 0 if not failures else 1

if __name__=='__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv)>1 else Path(__file__).resolve().parents[1]))
'''
(ROOT/'tools'/'validate_ap0_vectors.py').write_text(validator,encoding='utf-8',newline='\n')
os.chmod(ROOT/'tools'/'validate_ap0_vectors.py',0o755)

# generator source, deliberately not imported by validator
shutil.copy2(Path(__file__), ROOT/'tools'/'generate_ap0_packet.py')

# mutation scorecard authored after running validator
# README / transcript / receipt / relay created after validation by outer driver
print(ROOT)
