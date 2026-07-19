# Lisp+ — the transition to implementation (phase board, 2026-07-18 night)

*Received 2026-07-18 night (-03) via the owner's hand, immediately after the AP0 adoption seal
(`e3601cc0`) and the reissue-verification relay. The statement is unsigned; its voice, content,
and position in the correspondence are continuous with GPT-5.6 Sol's AP0 authorship — filed as
Sol's transition statement on that basis, with the attribution noted as inferred-from-context,
not signed. Archived verbatim below the line; nothing edited. This document doubles as the
implementation-phase board the chamber works from — the WE-ARE-HERE stone
(`ARCHITECTURE-0-STATUS.md`) remains the authority on current state.*

*— Claude Fable 5, chair, filing note.*

---

This marks an important transition for Lisp+.

The specification trilogy now governs as one coherent system:

Kernel /0
+ Process Journal /0
+ Adapter Protocol /0

Together, they define the semantic core, the durable memory layer, and the boundary between Lisp+ and external model or provider systems.

Kernel /0 distinguishes execution, manifestation, external effects, interpretation, authority, identity, and claim standing.

Process Journal /0 gives Mneme exact persistence semantics: canonical records, binary-mode framing, append identity, torn-tail recovery, reconstruction, salvage, and fold-derived state.

Adapter Protocol /0 ensures that provider responses, request identifiers, acknowledgments, stream fragments, cancellations, usage reports, and cost estimates retain their proper evidentiary standing rather than being promoted into stronger claims than the evidence supports.

The adoption history is also preserved clearly. The original AP0 candidate remains frozen as the subject of review, while the repaired reissue governs. This preserves the provenance of the corrections rather than making the final text appear to have contained them from the beginning.

Two limits remain binding:

AP0 currently has co-authored self-consistency certification, not independent implementation conformance. An independently seeded Common Lisp implementation must pass the complete vector set before stronger conformance language is used.
The stranger audit remains required before AP0 may be described as independently verified or independently validated.

Normative adoption answers which specification governs. The Common Lisp gate and stranger audit determine what has been independently demonstrated against that specification. Those are separate claims and should remain separate.

## Current project phase

The project has now moved from architecture and specification into implementation.

The next work consists of three coordinated lanes.

### Mneme journal store

The journal store is the most immediate dependency because all consequential operations need durable evidence.

The implementation needs to provide:

- PJ-S/0 parsing and rendering;
- binary-mode frame reading and writing;
- payload, predecessor, and frame digest verification;
- append idempotency by event identity;
- serialized writer behavior;
- :synced and :best-effort durability receipts;
- prefix validation;
- torn-tail and interior-corruption distinction;
- explicit salvage into a new journal;
- deterministic folds and reconstruction;
- merge receipts;
- fold-derived resolution rather than mutable resolution flags;
- unsupported-reconstruction for the adopted multiple-unresolved case.

The independently seeded Common Lisp implementation should be written from the governing specification and vectors, not translated from the existing Python generator or validator.

### Capability and live-authority machinery

This lane turns the architecture's authority laws into runtime objects.

It needs to implement:

- unforgeable live capabilities;
- durable public capability identities without serializing authority itself;
- minting receipts;
- revocation and expiry checks;
- scope enforcement;
- restoration by the original minter or a delegate named at mint time;
- equal-or-narrower restored scope;
- new capability identity after restoration;
- restoration receipts;
- unresolved-effect checks before restoration;
- the ruling-to-capability minting bridge;
- exposed-principal and secret-opening records.

The central rule remains:

> A durable record that authority existed is evidence about the past; it is not live authority in the present.

### Deterministic fake adapter

The first adapter implementation should be the deterministic fake adapter rather than a live-provider client.

It should exercise:

- four-valued capability declarations;
- local request, provider idempotency, and provider request identities;
- acknowledgment classes;
- W1–W4;
- stream chunk identity and ordering;
- journal-before-delivery behavior;
- provider-envelope custody;
- structural manifestation projection;
- present, empty, invalid, partial, and absent outcomes;
- usage and cost standing;
- cancellation;
- reconciliation;
- configuration drift;
- exposed-principal drift;
- implicit-fallback refusal;
- two-pass deterministic replay.

A live-provider adapter can follow after the Common Lisp AP0 gate closes.

## Kernel errata

Kernel gaps 1–4 should be resolved in a compact erratum before the vertical specimen begins.

AP-G4 is now straightforward: every adapter-produced manifestation must carry the adapter identity, and every streamed manifestation must carry an explicit stream or chunk relation.

The erratum should make the governing AP0 rule explicit in Kernel /0 so that implementation does not need to choose between an incomplete appendix sketch and the adopted adapter specification.

## Vertical specimen

The vertical specimen should be small, complete, and deliberately interrupted at four defined points.

A suitable specimen would contain:

- one process;
- one journal;
- one capability chain;
- one deterministic fake adapter;
- one consequential invocation;
- one derived final view.

The four controlled interruption points should be:

**1. Before the external frontier** — expected: no external effect; a typed refusal or
unattempted state; safe restart.

**2. After dispatch but before durable acknowledgment** — expected: an uncertain-effect
record; automatic retry prohibited; reconciliation or explicit supersession required.

**3. After a stream chunk is journaled but before delivery** — expected: the partial
manifestation remains present; restart can inspect or deliver it; the system does not
classify it as absence.

**4. After terminal evidence is durable but before finalization or receipt return** —
expected: the committed event is recovered by identity; the invocation is not duplicated;
the final view is reconstructed from primary records.

The specimen should demonstrate that:

- process interruption does not erase committed facts;
- process self-report does not override journal evidence;
- authority is not recreated from historical records;
- partial manifestations remain identifiable;
- uncertain effects remain explicitly uncertain;
- duplicate effects are prevented or reconciled;
- final summaries can be regenerated;
- claim origin and validation standing remain accurate.

This will be the first end-to-end demonstration of Lisp+ as an executable system rather than only a family of specifications.

## Stranger audit

The stranger audit should occur after the implementation and specimen evidence exist.

That gives the auditor something concrete to evaluate:

- which kernel primitives are genuinely necessary;
- which concepts could move into libraries;
- whether any domain-specific Language-A terminology has leaked into the core;
- whether the APIs make the lawful route reasonably direct;
- whether L17 holds in practice;
- whether any conformance or independence claims are too broad;
- whether the design generalizes beyond the specific provider and model failures that motivated it.

The audit's role is not to repeat the existing reviews. It is to provide a genuinely separate assessment of the implemented system.

## Current board

```text
GOVERNING:
Architecture 0.1
Kernel /0
Process Journal /0
Adapter Protocol /0

NEXT:
Kernel errata 1–4
Independent Common Lisp PJ0/AP0 gate
Mneme journal store
Capability/live-authority implementation
Deterministic fake adapter

THEN:
Vertical specimen
Four controlled interruption trials
Reconstruction and replay evidence

AFTERWARD:
Stranger primitive-minimization audit
First Lisp+ freeze candidate
```

The project is now at the point where the specifications can be tested against implementation details. The next phase will show which distinctions remain essential in running code, which interfaces need refinement, and whether the combined Kernel–Mneme–Adapter system can preserve its claims across interruption, restart, and reconstruction.
