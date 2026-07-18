# LISP-PLUS-KERNEL-0-SPEC — DRAFT-F

**Author:** Claude Fable 5 (Opus lineage), authorial lane per roadmap §11
**Date:** 2026-07-18
**Governing document:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` (ADOPTED, `f7583616`) — where
this draft and 0.1 differ, **0.1 governs and the difference is a defect here**
**Sequencing declaration:** DRAFT-F is written and committed **before** Sol's kernel-spec draft is
shown (same mutual-blindness protocol as the position papers; the commit timestamp is the proof).
A synthesis follows; implementation is authorized by **neither** draft nor by the synthesis alone,
but by the owner's adoption of the synthesized `LISP-PLUS-KERNEL-0-SPEC.md`.
**Register:** normative. MUST / MUST NOT / SHOULD / MAY as in RFC-2119. Requirements carry stable
IDs (`HOST-1`, `JRN-4`, …) so the synthesis can merge clause-wise. Text without an ID is
informative. Closed enums are quoted **verbatim from 0.1** and are not this draft's to alter.

---

## 0. What Kernel /0 is

The smallest system that can execute the vertical specimen (0.1 §15) honestly: run one
latent-machine study over a fake adapter, die at four points, restart, reconstruct, name one
uncertain effect, refuse unsafe replay, and export evidence — with every 0.1 law enforced by
code, not by operator virtue.

- **K-1.** Kernel /0 MUST implement every entity of 0.1 §6 marked kernel-primitive or
  kernel-protocol (0.1 §12.1–12.2), and MUST NOT implement anything 0.1 §12.3 assigns to
  libraries.
- **K-2.** Kernel /0 conformance is defined by the fixture suite (§9 below), not by prose. A
  kernel that passes fixtures it cannot fail is not conformant (negative controls MUST fire).
- **K-3.** Nothing in Kernel /0 requires a live provider. The deterministic fake adapter (§8)
  is the reference machine; live adapters are conforming extensions.

## 1. Host boundary (D10)

- **HOST-1.** The kernel runs on a Common Lisp host. Ephemeral local computation MAY use any
  host value freely.
- **HOST-2.** A value crossing a **durable boundary** — journal record, receipt, claim content,
  identity, canonical comparison, evidence export — MUST first be converted to a Canonical
  Datum /0 value via an explicit conversion operation. Implicit coercion at a durable boundary
  MUST signal `condition:canonical-boundary-violation`.
- **HOST-3.** The kernel MUST NOT rely on host behavior (hash order, float printing, `sxhash`,
  `gensym` uniqueness) for any durable identity or canonical octet.

## 2. Identity discipline

- **ID-1.** Durable identities (process, seat, attempt, manifestation, receipt, claim binding,
  capability, configuration, policy) MUST be store-issued and stable across host restarts.
  `gensym`/counter-in-image identities MUST NOT cross a durable boundary.
- **ID-2.** Every durable identity MUST be representable as a CD/0 value and MUST carry its
  identity domain (`:seat`, `:attempt`, …) so cross-domain collision is a type error, not a
  coincidence.
- **ID-3.** Claim identity binding is LCI/0's. For runtime-generated claims the location is
  the journal coordinate (journal-id, ordinal) plus process identity. Kernel /0 MUST NOT
  invent a parallel claim-identity scheme.

## 3. Core types (normative shapes)

Enums below are 0.1's, verbatim. Field lists are MUST-carry minima; libraries may extend by
composition, never by redefining kernel fields.

### 3.1 Outcome (0.1 §6.8)

- **OUT-1.** An outcome MUST carry exactly four axes — execution, manifestation, external
  effect, interpretation — each a pair `(:value V :determinacy D)` with
  `D ∈ {:determinate, :bounded, :indeterminate}`; `:bounded` MUST name alternatives and
  evidence. There is no outcome-level uncertainty field; constructing one MUST be impossible
  in the exported API.
- **OUT-2.** Execution values: `:not-attempted :refused :failed :completed :cancelled
  :indeterminate`, with optional `:pre-frontier`/`:post-frontier` qualifiers. The constructor
  MUST reject `:refused` with `:post-frontier`.
- **OUT-3.** Effect-axis values: `:not-entered :prepared :crossed :settled :compensated
  :bounded :indeterminate`. A `:bounded`/`:indeterminate` effect axis MUST reference an
  uncertain-effect record (§3.4); constructing one without it MUST signal
  `condition:unstructured-uncertainty`.
- **OUT-4.** Interpretation values: `:not-attempted :not-applicable :accepted :rejected
  :invalid :refused :indeterminate` — and every non-`:not-*` interpretation MUST name the
  procedure (parser/rubric/validator identity) it is relative to.
- **OUT-5.** Kernel-checked invariants (each with a fixture and a planted violation):
  execution `:not-attempted` ⇒ effect `:not-entered` and manifestation absence-state
  `:never-attempted`; manifestation `:present*` ⇒ payload identity exists; ordinary
  interpretation `:accepted/:rejected` requires manifestation `:present` or `:present-empty`
  under the named procedure's declared domain.
- **OUT-6.** An outcome MUST reference its attempt identity and machine-configuration
  identity.

### 3.2 Manifestation (0.1 §6.7)

- **MAN-1.** Status algebra, verbatim: `:present :present-empty :present-invalid :absent
  :withheld :redacted :present-partial`. All six 0.1 §6.7 rules are kernel-enforced; in
  particular every `:present*` status MUST preserve payload identity, and `:present-invalid`
  MUST name the parser identity.
- **MAN-2.** The provider-response envelope and the subject manifestation are distinct
  objects (0.1 §6.7 closing law). An adapter MUST return both references; the kernel MUST NOT
  derive the subject status by inspecting envelope bytes itself — that projection is the
  adapter's declared, versioned procedure.
- **MAN-3.** Absence states, verbatim closed: `:never-attempted :refused-pre-effect
  :absent-after-completion :withheld :redacted :not-applicable`. Causal claims attach by
  reference (§3.3); a constructor accepting a "cause" argument on the state itself MUST NOT
  exist.

### 3.3 Causal claim (0.1 §6.9.2)

- **CAU-1.** A causal claim MUST carry: subject identity, predicate, evidence references,
  origin facet, validation facet. It MAY be `:cause :unestablished`.
- **CAU-2.** Revising or refuting a causal claim MUST NOT alter any manifestation state,
  fold, or census-class derived from states.

### 3.4 Uncertain effect (0.1 §6.10)

- **UNC-1.** Fields (MUST): kind, attempt, external-request identity (or `:unavailable` with
  reason), possible-effects, known-facts, reconciliation-procedure reference, retry-policy.
  Default retry-policy is `:forbidden-without-reconciliation` and the kernel MUST refuse
  (`condition:unsafe-retry`) any dispatch into a seat holding an unresolved uncertain effect.
- **UNC-2.** Resolution happens only by a reconciliation transformation carrying evidence
  (provider identifiers first, per the sealed call-296 protocol) or by an authorized
  supersession (§3.5) — never by timeout, never by default.

### 3.5 Seat, attempt, supersession (0.1 §6.6)

- **ATT-1.** The five identities (logical-operation, seat, attempt, external-request,
  process) are distinct kernel types. The attempt record MUST bind the 0.1 §6.6 minimum.
- **ATT-2.** Seat occupancy MUST be derived (a fold over journal + supersession records);
  the kernel MUST NOT store a mutable occupancy flag.
- **ATT-3.** A supersession record MUST carry the seven 0.1 §6.6 elements (superseding,
  superseded, authorizing claim/capability, reason, precedence rule,
  both-results-later-surface treatment, fresh-exposure flag). Supersession MUST NOT delete
  or mutate the superseded attempt (append-only), and MUST NOT mark a superseding attempt
  as an unexposed continuation when `fresh-exposure` is true.
- **ATT-4.** An uncertain predecessor remains uncertain after supersession unless a
  reconciliation later resolves it (0.1/Sol law 5).

### 3.6 Capability (0.1 §6.11; DK-3; A-2 minting bridge)

- **CAP-1.** Capabilities are live, unforgeable, in-image objects. They MUST NOT be
  serializable through any exported operation; export attempts signal
  `condition:capability-serialization-refused`.
- **CAP-2.** Minting MUST produce a durable **minting receipt**: minter principal,
  authorizing-claim identity (the sealed ruling or delegation under which authority exists),
  scope, constraints, expiry, revocation-registry reference, optional restoration delegates
  (DK-3 mint-time naming).
- **CAP-3.** Restoration (reattachment) MUST enforce DK-3: performed only by the original
  minter or a mint-time delegate; new capability identity linked to predecessor; restoration
  receipt; revocation recheck; unresolved-uncertain-effect recheck (a process astride one is
  not re-armed past it); scope equal-or-narrower. Violations signal
  `condition:restoration-refused` with the specific ground.
- **CAP-4.** Revocation is registry-mediated and checkable at every frontier and at resume;
  the registry is durable and journal-backed.

### 3.7 Machine configuration (0.1 §6.12) and channel policy (0.1 §6.13)

- **CFG-1.** A machine-configuration identity MUST be resolved before any frontier (L7); the
  invocation record MUST carry both the declared configuration and the dispatch-time resolved
  identity (alias ≠ resolution — the r5 scar as law).
- **CHN-1.** The kernel knows the channel-policy **schema** (identity, source-scope,
  destination-scope, visibility, authorized principals, propagation mode, amendment
  authority). Policy **instances** are adopted artifacts referenced by identity; the kernel
  MUST refuse a mirror-bound commit effect whose policy reference is absent or whose acting
  principal is not listed (`condition:publication-unauthorized`).

### 3.8 Transformation receipt (0.1 §6.4)

- **RCP-1.** Kernel-minimal receipt: transformation identity+version, input identities,
  output identities, operator/adapter identity, authority reference, deterministic/sampled
  status, predecessor receipts, bounded unknowns, integrity seal. The full field schema is
  library. A receipt MUST NOT certify beyond its recorded procedure (L13).

## 4. Principals and epistemic effects (L16, L18, 0.1 §8.5)

- **PRN-1.** Principals are kernel identities; roles (invoker, invoked-configuration,
  subject, witness, grader, secret-recipient, …) are per-event bindings, not types of being.
  Any principal MAY occupy any role; self- and kin-invocation are ordinary (L18).
- **PRN-2.** Every `:secret-open` and subject-exposure effect record MUST carry: protected
  object identity, exposing action, receiving principals (the invoker included when it can
  inspect the material), exposure scope, direct/relayed/inferred mode, evidence, resulting
  role restrictions.
- **PRN-3.** The kernel MUST support the query "which principals have been exposed to X" as
  a fold over exposure records — blindness as a ledger query (L16), no library required.

## 5. Mneme: journal and reconstruction (0.1 §9)

- **JRN-1.** The durable-store protocol: `append`, `read-all`, `read-prefix-valid`,
  `declared-durability` (`:synced` | `:best-effort`), `store-identity`. The reference
  implementation is filesystem-backed, append-only, **human-readable S-expressions** (D4
  rider), one record per line or form, no binary framing.
- **JRN-2.** A transition record MUST carry: journal ordinal (the authoritative order),
  process identity, transition type, payload (CD/0), writer principal, capability reference
  where the transition is consequential. Wall-clock timestamps MAY ride as observations and
  MUST NOT participate in ordering (0.1 §9.4).
- **JRN-3.** Current state is a deterministic fold over the longest prefix-valid journal. A
  torn trailing record MUST be preserved as evidence, reported
  (`condition:torn-tail-detected`, non-fatal), and excluded from the fold. Laundering a torn
  record into a committed transition MUST be impossible.
- **JRN-4.** Cross-journal merge is a reconstruction transformation with a receipt declaring
  ordering rules and conflict policy; the kernel provides the operation and MUST NOT provide
  any implicit timestamp-sorted merge.
- **JRN-5.** A finalizer output MUST be re-derivable: the kernel's `reconstruct` MUST
  reproduce any fold-derived summary from primary records alone, and the fixture suite MUST
  include finalizer-loss recovery (kill before finalize → reconstruct → byte-compare where
  determinism is declared).
- **JRN-6.** Reconstruction receipts carry: primary records consumed, fold identity, ordering
  rule, conflict policy, missing evidence, output identity, replay result. Origin of every
  reconstruction-derived claim is `:reconstructed` forever (L10).
- **JRN-7.** Process recovery MUST refuse unsafe continuation on: unresolved dispatched
  effect, occupied output identity, missing required receipt, identity drift, revoked/expired
  capability requirement, adapter version drift, protocol-violating transition sequence —
  each with its own typed condition, each with a planted-violation fixture.

## 6. Kernel operations (normative set)

Signatures are schematic s-expressions; names are proposals (synthesis may rename; semantics
may not weaken). Every consequential operation returns an outcome or process handle (D1) —
never a bare value, never `nil`.

```lisp
;; authority
(mint-capability authority-claim &key scope constraints expiry delegates) → capability + minting-receipt
(revoke-capability registry capability-id reason)                          → receipt
(reattach-authority principal process-id predecessor-receipt request)      → capability + restoration-receipt | refusal
;; identity & configuration
(declare-machine config-form)            → configuration-identity
(resolve-configuration config-id adapter) → resolved-identity (dispatch-time)
;; work identities
(reserve-seat bank-id logical-op)        → seat-id (journaled)
(open-attempt seat-id &key exposure)     → attempt-id (refuses occupied/uncertain seats)
(supersede-attempt old new record)       → supersession-receipt
;; the frontier
(invoke machine subject &key capability seat attempt idempotency sink) → outcome | process-handle
;; journal
(journal-append store process transition) → ordinal
(fold-state store process)               → state (prefix-valid)
(reconstruct store fold-id)              → derived-view + reconstruction-receipt
;; claims & standing
(make-claim content &key origin sources) → claim-binding (LCI/0)
(attach-causal-claim manifestation-id predicate evidence) → causal-claim
(raise-standing claim procedure evidence) → claim' (procedure-gated; else condition:standing-inflation)
;; epistemic & publication effects
(record-secret-open object principals &key scope mode evidence) → exposure-record
(commit-to-channel artifact policy-id capability) → outcome carrying (:durable-write …) (:publication …)
;; inspection
(explain identity &key show)             → human view + canonical record (both, always)
```

- **OP-1.** `invoke`'s preflight MUST check, in order, before the frontier: capability
  present/unrevoked/in-scope → identity resolution (CFG-1) → seat/attempt validity (no
  occupied seat, no unresolved uncertain effect, no duplicate idempotency identity) → budget
  → destination availability → retry-policy → **execution-path closure** (L12: live-only
  paths walked or faithfully simulated where practicable). Each failed check refuses with
  its typed condition and effect axis `:not-entered`.
- **OP-2.** After the frontier: transitions persist incrementally (L8); the kernel MUST NOT
  hold settled facts only in memory across an await.
- **OP-3.** `(getf outcome :answer)`-shaped access MUST NOT exist: manifestation payload is
  reachable only through an accessor that requires the outcome context (0.1 §7.5 / L17); the
  ergonomic form (`with-outcome` or synthesis-equivalent) is part of the kernel surface, not
  a library nicety.

## 7. Conditions (typed refusals)

- **CND-1.** Every refusal law has a named condition class; the minimum taxonomy:
  `canonical-boundary-violation · capability-refused · capability-serialization-refused ·
  restoration-refused · scope-violation · publication-unauthorized · seat-occupied ·
  duplicate-idempotency · unsafe-retry · unsafe-fallback · unstructured-uncertainty ·
  standing-inflation · torn-tail-detected · identity-drift · adapter-version-drift ·
  parser-refused · exposure-unrecorded`. Each condition carries the law it enforces (its
  L-number or requirement ID) as a field — the refusal explains itself.
- **CND-2.** Conditions compose with CL's condition system: signaling is distinct from
  deciding; restarts are offered where a lawful continuation exists (reconcile, supersede,
  narrow-scope, abandon). The crash site stays alive.

## 8. Adapter protocol (0.1 §14)

- **ADP-1.** Every adapter declares, as data: configuration-identity fields, idempotency
  support, request-reconciliation support, version-resolution support, usage/cost reporting,
  cancellation semantics, streaming semantics (chunk/checkpoint policy per D7),
  failure→outcome mapping, durability guarantees, and its envelope→subject-manifestation
  projection procedure (versioned — MAN-2).
- **ADP-2.** The **deterministic fake adapter** MUST produce, on demand, every manifestation
  status, every execution value, every effect value, uncertain writes, duplicate-idempotency
  collisions, and mid-stream death — the full outcome algebra without a provider (roadmap
  D5: no live-provider-first).

## 9. Conformance (fixtures; L17; negative controls)

- **FIX-1.** The 0.1 §17 matrix rows (all 13) are normative fixtures: each MUST be
  constructed, journaled, killed-and-reconstructed, and re-derived byte-identically where
  determinism is declared.
- **FIX-2.** The 20 adversarial classes of 0.1 §16 MUST each have a fixture AND a negative
  control proving the harness catches a deliberately broken implementation (teeth-checks;
  an unfired gate is untested).
- **FIX-3.** L17 conformance is tested, not asserted: for each supported consequential
  operation, the documented lawful pattern's form-count is measured against every supported
  bypass the API exposes; the inequality holding is a fixture, and bypass namespaces
  (`unsafe-`, `raw-`, `host-escape`) are lint-enforced.
- **FIX-4.** Fixtures are CD/0 canonical values consumable by both the CL runtime and a
  language-neutral verifier (0.1 roadmap C7).

## 10. Deliberate stops (for the synthesis and after)

1. Operation names and exact lambda lists — proposals only; synthesis decides.
2. The concrete condition-class hierarchy's CL package layout — implementation detail after
   synthesis, reconciled with LCI/0's existing taxonomy (no parallel invention).
3. The channel-policy *instance* — `CHANNEL-POLICY-latent-lisp-mirror-DRAFT.md` awaits owner
   adoption; this spec binds only the schema.
4. The kimi-null projection's factual application — locked lane, owner's act.
5. Byte-level canonical forms — CD/0's jurisdiction; this spec adds no bytes.
6. Anything a fixture cannot yet express — named here rather than smuggled: none known at
   draft time; the synthesis MUST re-ask.

---

*Frozen as DRAFT-F before Sol's draft is shown. The synthesis document is the spec; this is
one parent. — Claude Fable 5 (Opus lineage), 2026-07-18*
