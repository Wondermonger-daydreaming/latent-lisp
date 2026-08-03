# Lisp+ — Current Claim Ceiling

**Integration Baseline /0 · 2026-08-02**
*Recorded by Claude Fable 5 (builder, Integration Baseline /0), under the owner ruling and
work order at `mneme/RULING-integration-baseline-0-owner-ruling-and-work-order-2026-08-02.md`.*

This document states what may be said about Lisp+ today and what may not. Where a cap already
exists in a ruling, adoption record, or lane README, it is **quoted verbatim** below rather
than summarized, because a paraphrase of a ceiling is a way of raising it.

**This milestone raised nothing.** Integration Baseline /0 is a packaging, loading,
verification, documentation, and release-engineering act. It created no semantic standing, and
every lane keeps exactly the standing its own ruling gives it.

---

## 0. The only claim this milestone itself earns

> One documented command loads the current Lisp+ construction into one image on SBCL
> 2.4.6/Linux, and one canonical floor accounts for its declared gates and its known
> unresolved findings.

That is the whole of it. Loading is not adoption. A floor that exits 0 is not a proof of
correctness. Nothing below moved because of this milestone.

---

## 1. Binding caps, quoted verbatim

### 1.1 AP0 Rider 2 — forbidden promotion language

From `mneme/architecture/adapter-protocol-0/AP0-ADOPTION-2026-07-18.md`, still binding:

> …no artifact may use the words "independently verified/validated" of AP0 until a
> stranger's frozen report exists.

**The permitted formulation, verbatim from the ruling** (`RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md`):

> Adapter /0 is an independently seeded Common Lisp implementation that passed the
> complete frozen AP0 fixture and vector gate at the declared deterministic
> fake-adapter scope.

**The following formulations remain unauthorized**, verbatim from the same record:

> *independently verified · independently validated · live-provider conformant ·
> universally AP0-conformant · adopted · frozen · governing.*

Rider 1 is SATISFIED at commit `b7f70ed8`. **Rider 2 remains binding.** No Adapter /0 audit
has been opened.

### 1.2 PJ0 §32.5 — FULL conformance NOT CLAIMED

From `mneme/journal0/README.md`, "Honest ceilings", verbatim:

> 1. **No FULL §32.5 conformance claim.** Demonstrated: codec (§32.1), reader
>    (§32.2), recovery (§32.4), and writer (§32.3) **except** the §30
>    randomized SIGKILL harness, which was not run here.

And, from the same list, the durability cap:

> 2. **Durability is a declared host-contract belief (PJ-DUR-3):** fsync(2)
>    syscall completion + reopen validation on a Linux ext4 host — never
>    power-loss or storage-stack proof.

`JOURNAL-0-RETURN.md` records **§32.5 FULL: NOT CLAIMED** as non-blocking. It is not to be
reopened by this milestone and has not been.

### 1.3 Vertical Specimen /0 — SIGKILL-only crash model

The specimen demonstrates, in the owner's own enumeration, *four real SIGKILL process deaths*
with reconstruction and independent replay equality. The ceiling that rides with it:

- the crash model is **SIGKILL only**;
- on **one** SBCL 2.4.6/Linux host;
- **no** power-loss model, **no** torn-media model, **no** second host, **no** second
  implementation;
- the occupied-target interpretation is **per-resource policy, provisional — not a universal
  law** (owner ruling `72b2c973`, five limits docketed non-blocking).

The repeatability harness states its own earned scope in its output, verbatim:

> This earns exactly: same-host fresh-directory temporal repeatability.
> It does NOT earn: cross-platform determinism, power-loss durability, or
> any claim about a host other than the declared one.

### 1.4 Verdict-liveness — connectedness, never predicate soundness

The Form /1 and Form /2 liveness sweeps force every verdict and prove that each is reachable
and that the negative controls fire. **That licenses connectedness only.** It is not, and may
never be reported as, evidence that any predicate is *sound*. A verdict that can be reached is
not a verdict that is right.

### 1.5 Receipts and censuses

- A receipt is an **ACCOUNT, not an AUTHENTICATION** (Form /2 ceiling).
- Neither a capability receipt nor a presentation receipt proves the effect occurred
  (Capability arc).
- "Largest **MEASURED over enumerated fixtures**" — never "largest", globally (Form /2).
- Canonical Datum /0's execution accounting is **"68 executed + 3 N/A, never 71 passed"** — the
  runner prints the honest form itself.

### 1.6 Cross-language agreement is not corroboration

LCI/0's own evidence file records:

> `"cross_language_agreement_is_independent_corroboration": false`

Two implementations seeded under **shared normative infrastructure** agreeing tells you about
the shared infrastructure. The permitted phrase throughout this project is *"independently
**seeded** under shared normative infrastructure"* — never *"independently verified"*, never
*"independently validated"*, never *"two independent implementations"*.

---

## 2. The current stranger-audit debt

**The reserved independent primitive-minimization audit has never been commissioned. The seat
is empty and has always been empty.** `ARCHITECTURE-0-STATUS.md` reserves it and names its
eligibility constraint: it must be run by *"a stranger to the Language-A arc — not Sol
(recused), not Fable (scars in the laws)"*, from a candidate pool that has never been filled.

**Zero of the nineteen principal packages have paid that gate.** It is the project's reserved
promotion evidence, and no promotion resting on it may be claimed.

Lane-level stranger contact that *has* occurred, and its exact nature:

| lane | what actually happened | what it is NOT |
|---|---|---|
| Surface /1 | a genuine stranger audit (`audits/2026-07-28-stranger-audit`) found defects; Errata 0.3 repaired nine findings; the teeth gate now bites 43/43 live | not the reserved primitive-minimization audit |
| Slice /0 | two independent **stranger front-door implementations**, each passing its own 7/7 selftest | a front-door lint, not an audit of the lane's primitives |
| Slice /1 | a stranger implementation plus cold-audit adjudications | not the reserved audit |

**The count itself is contested, and this milestone does not settle it.**
`ARCHITECTURE-0-STATUS.md` counts the debt in one place as *"OWED against all three"* and
elsewhere names journal0/capability0/capability1; the 2026-08-02 project-state assessment read
the lanes' own artifacts and found the debt spanning **at least nine lanes**, counted nowhere.
Both figures are recorded here because reconciling them requires a ruling this builder does not
hold. **The debt is not reduced by anything in this milestone.**

---

## 3. LCI/0 — four unresolved law failures, no authorial disposition

`mneme/lci0/audit/` exists in main (landed `bedb279b`), with a completed evidence archive:

- **84 laws PASS**
- **4 laws FAIL, preserved:** `LCI0-CROSS-004`, `LCI0-SCOPE-015`, `LCI0-TEMP-022`,
  `LCI0-TEMP-028`
- **6 minimized witnesses** (4 implementation-defect, 2 cross-language-divergence)
- status, verbatim from `audit/evidence/final-status.txt`:

  > `AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED`

**No authorial ruling exists.** The four failures are carried forward as
`KNOWN-UNRESOLVED` by the release floor and are neither repaired, adjudicated, nor turned
green here. The lane's own README states that **LCI/0 conformance remains blocked pending
authorial closure**; any document calling the LCI/0 arc simply "closed" is overclaiming, and
the root README's line to that effect is corrected by this milestone.

The audit is additionally **not re-derivable on this host**: it requires an external,
checksum-bound packet ZIP (`LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip`) that is absent
here and not in the tree. The release floor reports that as
`BLOCKED-EXTERNAL-INPUT`, never as a pass and never as a failure.

---

## 4. What is absent, stated as absence

### 4.1 No portability evidence beyond SBCL 2.4.6/Linux

No other Common Lisp implementation and no other SBCL version has **ever** been tested. The
version is hardcoded in the lanes' banners and now in the release floor, which **fails closed**
on any other version rather than silently testing something else. No portability is claimed and
none may be inferred from a green floor.

### 4.2 No semantic Stack-A ↔ Stack-B derive/perform integration path

**This is the first missing semantic seam, and naming it is one of this milestone's
deliverables.**

No executable exists in which a Stack-B language operation — Core /0's derive/perform doors, or
any slice, form, or surface operation — executes against a Stack-A journal-backed,
capability-gated process. Vertical /0 never imports Core /0 or any slice. Surface /2's contact
with Stack A is seven journal0 symbols and one capability2 symbol, used for a **read-only
re-expression of a completed run**.

The derive/perform doors of the language have never opened onto the durable process substrate.
The composite demonstration prints exactly this at the end of every run.

### 4.3 No implemented Mneme memory layer

**The language is Lisp+. Mneme is its memory-and-continuity layer.** That relation is sealed
(`ARCHITECTURE-0-STATUS.md:23`).

As implemented, `mneme/` is the directory that holds the whole construction, and the promised
memory layer — provenance-bearing write, retrieval, consolidation, deletion, restart — **does
not exist as a lane**. Any document that calls the language "Mneme", or writes "Mneme (working
name 'Lisp+')", inverts the sealed relation. Those instances are corrected by this milestone
where they appeared in the front door.

### 4.4 No adopted implementation

Adoption attaches to **specifications only**. Architecture 0.1, Kernel /0 + Errata 0.2, PJ0,
AP0 and CD/0 are adopted. **Every implementation is a candidate or an accepted candidate.**
Loading the ASDF umbrella does not adopt anything, and no document may report it as doing so.

### 4.5 No CI-established portability, and no live provider

The CI entry (if present) exercises the reduced profile on the supported host only. The adapter
boundary is the deterministic fake; **no live provider adapter exists.**

---

## 5. Standing carried from the owner ruling of 2026-08-02

- **Surface /2** — accepted, **prospectively and exactly**, as a **closed published
  candidate** at the inspected closure line `3cd53351`, including Erratum 0.2. The ruling
  explicitly **does not** claim that an earlier oral authorization necessarily covered
  Erratum 0.2, and that historical uncertainty must not be rewritten. It settles standing now.
  It does **not** adopt the implementation and does **not** confer independent-validation
  language.
- **Form /2** — acknowledged as a **published candidate-by-default**. The earlier ruling
  declining to open generic Language Obligation /0 remains fully in force; no new abstraction
  is opened.
- **`latent-mvp`** — **FOSSIL-MARKED**: retained intact as a historical stratum with its
  historical floor, removed as the present `START HERE` path. Not deleted, not refactored.
- **Language-A tranche-B** — **archive now, adopt later.** Not merged during this milestone.
- **The language is Lisp+; Mneme is its memory-and-continuity layer.** Naming affirmed.

---

## 6. The forbidden words

No artifact of this project may say, of any part of Lisp+:

> ~~complete~~ · ~~coherent language~~ · ~~independently verified~~ ·
> ~~independently validated~~ · ~~adopted~~ (of an implementation) · ~~frozen~~ ·
> ~~governing~~ (of an implementation) · ~~live-provider conformant~~ ·
> ~~universally AP0-conformant~~ · ~~fully conformant~~ · ~~production-ready~~

Nor may same-family or shared-normative agreement be called independent validation. Nor may a
green floor be reported as resolving a semantic question.

---

## 7. What Lisp+ may honestly claim today

That it is governed by an adopted specification constitution (Architecture 0.1; Kernel /0 with
Errata 0.2; Process Journal /0; Adapter Protocol /0; Canonical Datum /0), whose semantics have
twice been implemented to green by **independently seeded** Common Lisp code against frozen
adopted vector sets (journal0: 89/0 PJ0 vectors; adapter0: the complete frozen AP0 gate, Rider
1 ruled satisfied, at declared deterministic fake-adapter scope); that its principal
implementation packages pass their own declared gates from current sources on SBCL 2.4.6/Linux,
with fired negative controls, bilateral mutation gates, and byte-reproducible transcripts where
designed; that one vertical specimen survives four forced SIGKILL deaths with capability-gated
effects and a byte-reproducible reconstruction; that one lane (Surface /1) has survived a
genuine stranger audit through repair to a live 43/43 planted-fault gate; that its
cross-language differential harnesses run green under the recorded caveat that such agreement
is **not** independent corroboration; and — new with this milestone, and this alone — that one
documented command loads the whole current construction into one image and one canonical floor
accounts for its declared gates and its known unresolved findings.

## 8. What Lisp+ may not yet honestly claim

To be independently verified or independently validated. To have any adopted implementation. To
be one complete or coherent runnable language. To have connected its language operations to its
process substrate. To survive anything but SIGKILL on this one SBCL 2.4.6/Linux host. To have a
functioning memory layer worthy of the name Mneme. Or to have earned, from cross-language
agreement or same-family review, anything beyond self-consistency under shared normative
infrastructure.

---

*No implementation is adopted unless an exact ruling says otherwise.*
