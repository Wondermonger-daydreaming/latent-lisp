# LANGUAGE SLICE /2 — DESIGN RULING /0

*Owner-adopted 2026-07-25 after inspecting the complete Admission Paper /0 package.
**This adopts a negative design result. It adopts no vocabulary, no representation,
and no attachment locus.** The paper specimen's `paper-` names are experimental and
are deliberately not recorded here as candidates.*

*— Claude Opus 5 (1M context), chair · SBCL 2.4.6*

```
status:                    owner-adopted design ruling
implementation-authorized: no
public-api-authorized:     no
specification-frozen:      no
representation-selected:   no
attachment-locus-selected: no
```

---

## 1. What was executed

A paper specimen — an executable semantic model built *beside* the language, never
inside it: zero package-internal access, no monkey-patching, no exports, no
repository writes. It loaded the current public Slice /0, Slice /1 and Core /0
surfaces and ran twelve traces against a declared admission policy passed directly
as a value. **The chair ran it twice from clean images: both exit 0, byte-identical
to the builder's saved transcript, 56 checks / 0 failed.**

```
package   slice2-admission-paper-0-2026-07-25.zip
bytes     166559
SHA-256   4511bca11270747778d9d0ef43788bd2fc6c00a8dfafc3d091dcd11aaaeddde3
```

Every enclosed entry passed the package's own `SHA256SUMS.txt`, independently
verified by the owner. **The specimen and transcript are deliberately NOT placed in
this repository.** This ruling is the durable record; the package identity above is
how to retrieve the evidence.

---

## 2. The result

```
raw fabricated direct witness         → REFUSED   (species not admitted)
the identical fabrication after raise → :VERIFIED → ADMITTED
real-account-carrying witness, raised → ADMITTED IDENTICALLY
bare witness (no procedure, content), raised → ADMITTED IDENTICALLY
```

Ten downstream readers are identical between the fabricated and the real raised
claim. The only differences are per-image minting ordinals, which say which object
was constructed first and nothing else. **Both were raised by the same promotion
procedure.**

**The counterexample was already in this repository, passing, before the design fork
opened** — `de-bibliotheca-peregrina` `[IX-5]` (raise produces a genuinely
`:VERIFIED` claim that then chains lawfully), `[IX-8]` (the two witnesses are
identical in every attribute the language *governs*), and `[IX-10]`: ***the receiving
receipt holds NO witness object and NO `:ATTEMPT` identity — the crossing's identity
is gone by the time the claim chains***, detailed as *"the judgment record keeps the
WITNESS's id, never what the witness was carrying."* Read together they are the
laundering path. Nobody read them as one until the owner named it from outside.

```lisp
(:slice-2-admission-paper-0
 :species-only-admission :rejected
 :standing-only-admission :rejected
 :inspectable-basis-alone :insufficient
 :status-laundering :survives
 :raw-fabrication :refusable
 :raised-identical-fabrication :admitted
 :real-vs-fabricated-raised-claims :downstream-indistinguishable
 :procedure-allowlist :insufficient
 :support-id-resolution-alone :insufficient
 :effect-bound-basis :not-currently-representable
 :next-question :governed-source-basis-relation)
```

---

## 3. The adopted laws

### R-ADMISSION-0.1 — species is not provenance

Refusing raw witnesses while admitting judged claims does **not** establish a
provenance boundary, because an unsupported assertion can be promoted into the
admitted species. What such a policy buys is a **promotion step**, and a cost is not
a governed refusal.

### R-ADMISSION-0.2 — standing is not origin

`:VERIFIED` standing does not, by itself, establish that the judgment's basis is
bound to a real observation, effect, attempt, acknowledgment, or authority act.

### R-ADMISSION-0.3 — inspectability is not adequacy

A judgment basis may be publicly inspectable and still be inadequate for the premise
it supports. *Executed: the fabricated raised claim's basis is inspectable, and
inspecting it reveals nothing that distinguishes it.*

### R-ADMISSION-0.4 — identity-shaped values are not bindings

A string or durable identity resembling an attempt identifier does **not** prove a
governed relation to that attempt exists. A well-formed `:attempt`-domain identity
naming a chamber cycle that never ran is constructible and lawful.

### R-ADMISSION-0.5 — procedure allowlisting does not cure laundering

The real and the fabricated witness were raised by **the same** promotion procedure.
An allowlist over that procedure separates nothing. **Recorded as a closed door.**

### R-ADMISSION-0.6 — resolution alone is insufficient

A reader from `support-id` back to the original witness would improve *inspection*
and would return the fabricated witness as faithfully as the real one. It does not
establish source validity.

### R-ADMISSION-0.7 — payload preservation alone is insufficient

Copying witness `source`, `procedure` or `content` into the judgment record would
preserve **claims made by the witness**. It would not verify them. Copied assertions
remain assertions.

### R-ADMISSION-0.8 — binding is not implication

Even a judgment governedly bound to an actual effect account does not thereby
establish every proposition about the affected object. These are distinct
propositions with distinct possible bases:

```
treatment attempt recorded
treatment acknowledged
treatment completed
post-treatment condition established
safe to exhibit
```

*Without this law, "source-bound" becomes the next impressive adjective whose reader
always returns yes.*

### R-ADMISSION-0.9 — no contract kernel freeze

**No support-admission contract kernel may be frozen** until the language can
represent and evaluate a governed source-basis relation that survives downstream.

### R-ADMISSION-0.10 — Fork /0 remains useful but non-governing

Fork /0 correctly factored the design space into **representation · attachment ·
selection · evaluation · retention**. Those dimensions remain open and are
**postponed, not settled** — the semantic object they would carry has not been
established. *No archived copy of the Fork /0 analysis exists in this repository, so
nothing here supersedes a committed artifact; the analysis lives in the owner's
package `slice2-fork0-2026-07-25.zip`.*

---

## 4. What this ruling does NOT do

It does not adopt the paper vocabulary · select a representation or attachment locus
· authorize implementation, exports, or a public API · freeze any specification ·
create a charter delta · add a Core /0 dependency to Slice /1 · authorize an effect
bridge, an identity resolver, or cross-premise coherence.

It does not weaken `R-POLARITY-1`, Sol's Decision 1, or `CHARTER-DELTA-3` residue
behaviour — all three were exercised and held: attribution refused three independent
ways, refutation precedence surviving a policy that admitted a coexisting support,
and the two residue reasons distinct at distinct loci.

---

## 5. The exact next question

Not *"which support species should a premise admit?"* — that question has now been
executed and answered negatively.

> **What governed relation could bind a semantic basis to the actual source record
> from which it was produced, while also stating exactly which proposition that
> source is competent to establish?**

Two inseparable but non-identical parts:

```
SOURCE BINDING       this basis was actually produced from this governed source record
SEMANTIC PROJECTION  under this governed relation, this source record establishes
                     this exact proposition
```

**A source binding without semantic projection proves only ancestry. A semantic
projection without source binding can be applied to a fabrication.** The next paper
specimen must test the conjunction.

The missing relation, exactly, in three layers — each independently fatal, each
verified against source:

1. **No public reader** from a `judgment-record-support-ids` element back to the
   witness.
2. **No judgment-record field** carries the witness's `source`, `procedure` or
   `content`. The six readers are `judgment`, `procedure-id`, `procedure-version`,
   `support-ids`, `receiver`, `ordinal` — **so even if (1) existed, the
   discriminating fields are already gone by the time the claim exists.**
3. **No governed binding** between a witness's declared `:procedure` identity and an
   actual Core /0 attempt; identity resolution is an opening §7 non-goal.

---

## 6. Standing caps

**Self-consistency, not corroboration.** One model family wrote this language, both
inhabited applications, the opening, the fork analysis, the specimen and this ruling.

**The specimen's fixtures are reconstructions** (the applications' own objects are
package-internal); the builder executed neither application. **The Core /0 accounts
are scripted** — `perform` against labelled fake adapters: a real governed in-image
act, **not** evidence any external deed occurred. No conformance is licensed.

**Three attack surfaces on the paper assessor were named by its own builder and NOT
audited by the chair:** its stage-precedence catch-all clause, its normalized
equality on non-ground projections, and whether its positive-stage set is complete.
A reviewer should start there.

**The stranger audit remains OWED**, against this ruling too. GLM, Gemini and MiniMax
unspent; Sol, Fable, Codex, Qwen and every Claude-lineage seat ineligible.

---

*Adopted against: lab commit `07045ac0` · Slice /2 `OPEN FOR DESIGN`, unchanged ·
paper specimen 56 checks / 0 failed, run twice by the chair from clean images,
byte-identical · package SHA-256 `4511bca1…` verified independently by the owner.*

— **Claude Opus 5 (1M context)**, chair, 2026-07-25
