# CORE /0 — EVIDENCE ISSUANCE ERRATUM /0

*Chair: **Claude Opus 5 (1M context)**, 2026-07-25. Issued under the owner's ruling on
the Core /0 Evidence Issuance Adjudication /0, which classified the prior state as
**C0-C — authorial gap** and closes that gap prospectively.*

**This document GOVERNS.** Where it corrects a statement in the Core /0 closure, the
API, `continue-from`'s documentation, or the export census, **this text controls and the
original is superseded** — originals are left unaltered so the record of what was
believed, and when, survives. That is the lane's own practice.

Adjudication and evidence: the Core /0 Evidence Issuance Adjudication /0 package,
externally verified by the owner; session parcel SHA-256
`5edf8e3c6c97763e3c7174790ac4d4a95783de58ef8bfdd5b19c07f150d6b9e8`, 32/32 manifest
entries verified.

```
status:                          owner-adopted
scope:                           Core /0 evidence issuance and continue-from
implementation-authorized:       yes, bounded below
public-api-authorized:           one exact predicate
Slice /2 implementation:         no
subject-reader:                  no
persistence:                     no
```

---

## 0. What was found, and what it was not

`continue-from` accepted a caller-built account carrying a genuine attempt identity
copied from a real unresolved act, consulted the real ledger, returned `RECONCILED`,
minted a genuine reconciliation receipt, and issued replacement evidence.

**The resulting settlement was not false about the ledger.** What was false was the
**provenance relation between the supplied account and the act.** Core /0 had been
treating one object as **data when constructing it and provenance when consuming it**.

The repair gives it one ontology.

```lisp
(:core0-evidence-standing
 :standing :runtime-issued-content
 :ordinary-caller-authored-data nil
 :host-object-identity-authoritative nil
 :exact-content-copy-authentic t
 :current-image-only t
 :external-world-truth nil)

(:core0-evidence-issuance
 :issuers (:perform :validated-continue-from)
 :authority-key :exact-canonical-content
 :private-registry t
 :digest-alone-authoritative nil
 :public-check core0-evidence-current-image-issued-p
 :continue-from-requires-issued-content t
 :unissued-input :refuse-before-ledger-consultation
 :subject-reader-change nil)

(:core0-evidence-threat-model
 :t0-public-client :covered
 :t1-exported-name-reflection :covered
 :t2-host-reflective-content-mutation :detected-when-checked
 :t3-private-state-or-package-internal-compromise :not-claimed
 :t4-process-memory-adversary :not-claimed)
```

---

## The rulings

### R-ISSUANCE-0.1 — the account is issued content

From this ruling onward a `core0-evidence` value has provenance standing **only** when
its exact canonical semantic content was issued by Core /0 in the current Lisp image.

A structurally coherent caller-built value is **not** issued merely because:

```
core0-evidence-p returns true          its attempt fold is coherent
its event sequence validates           its attempt identity resembles a real identity
its ledger token resembles a real one  its adapter identity names a registered adapter
```

### R-ISSUANCE-0.2 — authenticity belongs to issued content

Authenticity does **not** belong to the structure object's pointer identity:

```
exact defensive copy of issued canonical content   → issued
same object after semantic content mutation        → NOT issued
different object with exact issued canonical content → issued
coherent content never previously issued           → NOT issued
```

**An explicit issued-content decision. Not an object-identity registry design.**

### R-ISSUANCE-0.3 — exact bytes, not digest faith

The private registry is governed by **exact canonical content**. A digest may index; a
digest match alone **never** establishes issuance — exact canonical encoded bytes must
compare equal. **No cryptographic-security claim is made or implied.**

### R-ISSUANCE-0.4 — all semantic account fields are bound

Canonical issuance content includes **every field contributing to the account's
meaning**, including the internally stored canonical request. At minimum inspect and
decide the exact binding of:

```
account version · attempt identity · seat identity · adapter identity · process context
canonical request · event sequence · manifestation · ledger token
reconciliation receipts · refusal reason
```

**Do not omit an internal field merely because no public reader exposes it.** Do not
include transient host addresses, hash-table identity, printer output, or pointer
identity.

### R-ISSUANCE-0.5 — `continue-from` trusts nothing initially

Before adapter lookup, ledger consultation, reconciliation, receipt minting, or new
evidence issuance, `continue-from` must verify the supplied value's **current** canonical
content is registered in the private current-image issuance registry.

If unregistered: **no ledger consultation · no reconciliation receipt · no replacement
evidence · no runtime-issued record derived from the supplied account.**

The refusal means exactly *"this content is not known to have been issued by Core /0 in
this image."* **It must not accuse the caller of forgery.**

### R-ISSUANCE-0.6 — "surviving evidence" is now defined

> A `core0-evidence` value whose exact canonical account content matches an issuance
> registered by Core /0 in the current Lisp image.

An exact defensive copy may survive. A structurally coherent reconstruction that was
never issued does not.

### R-ISSUANCE-0.7 — one public issuance check

Exactly one new public operation: **`core0-evidence-current-image-issued-p`**. True
exactly when the argument's current canonical account content is registered as issued in
this image.

**It is not** a type predicate · an external-truth predicate · a settlement predicate ·
a domain-condition predicate · a persistence predicate.

Required observable sensitivity:

```
genuine account → true          exact copy → true            blank account → false
coherent total caller construction → false                   genuine attempt-id reuse → false
mutated genuine content → false                              restored exact content → true
```

**No public constructor, issuance token, seal, registry reader, or general authenticity
object is authorized.**

### R-ISSUANCE-0.8 — registration sites

Every internal path minting a `core0-evidence` as its **own governed output** registers
its exact canonical content before returning it — `perform`, validated `continue-from`
results that mint new evidence, and every refusal/interruption path that genuinely
issues a Core /0 account.

**Inventory every `%make-core0-evidence` call site rather than assuming there are only
two.** A caller-supplied value must **never** be registered merely because it was passed
to `continue-from`.

### R-ISSUANCE-0.9 — image lifetime

The registry is intentionally image-local. After image death or registry reset,
persisted bytes do not retain current-image issuance standing. This repair earns **no**
crash survival, durability, cross-image authenticity, or serialization authenticity.

### R-ISSUANCE-0.10 — truth ceiling

A positive result establishes **at most**:

> This exact canonical account content was minted by the Core /0 runtime in this Lisp
> image.

It does **not** establish: the external-world deed occurred · the provider told the
truth · the adapter is honest · the account's semantic interpretation is correct · the
downstream domain proposition holds · the effect is settled.

### R-ISSUANCE-0.11 — subject readability remains separate

`core0-evidence-request` **remains internal.** The canonical request may be included in
the private issuance binding **without becoming publicly readable.** Do not export it.
**Do not describe this repair as solving `R-SOURCE-1.10`.**

### R-ISSUANCE-0.12 — bounded scope

Applies to `core0-evidence`, `continue-from`, and internal Core /0 evidence minting. The
census of **seven other T1-reachable authority-bearing structure types is preserved as a
separate docket.** No general exported-structure sweep.

> **Constructibility is not itself a defect.** A later object must be adjudicated by the
> authority that another operation actually *consumes* from it.

---

## What this erratum does not do

It does not implement Slice /2, export a subject reader, claim persistence or
cross-image standing, make a cryptographic-security claim, sweep other structure types,
or assert anything about the external world.

**It does not rewrite the Source-Basis Paper /0 result as mistaken.** That specimen
correctly measured the pre-repair surface, and its measurement is why this erratum
exists.

## Standing cap

One model family wrote this language, its applications, the adjudication that produced
this ruling and this text. **Nothing here is independent verification.** The stranger
audit remains owed against it.

— **Claude Opus 5 (1M context)**, chair, 2026-07-25
