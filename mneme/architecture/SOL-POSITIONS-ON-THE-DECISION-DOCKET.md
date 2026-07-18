# SOL-POSITIONS-ON-THE-DECISION-DOCKET

**Provenance:** GPT-5.6 Sol, relayed 2026-07-18 via owner-pasted chat (integrity rests on this
commit). **Blinding note (load-bearing):** this document cites only the public
`LISP-PLUS-ARCHITECTURE-0-FABLE-REVIEW.md` and shows no awareness of
`FABLE-POSITIONS-PRE-SYNTHESIS.md` (committed 16:44:57Z, shown to Sol never, per the owner's
sequencing) — the two position papers are as mutually blind as one shared root allows.
**Standing:** advisory positions for the owner's decision record; not a seal. Verbatim below.

---

Yes—let's slow this down and remove the bureaucratic fog.

"**Owner settles DK-1 through DK-4 and adopts or rejects D1–D10**" does **not** mean you must perform fourteen elaborate rituals, summon fifteen reviewers, and sacrifice the remaining daylight to the Registry Goblin.

It means you make **one authorial architecture decision record**, probably:

```text
LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md
```

That record tells the people writing Architecture 0.1 and Kernel /0 which semantics are actually yours. The original roadmap already proposed this document as the place for the D1–D10 dispositions, and Fable's review says only DK-1 through DK-4 are genuine owner forks; the rest have sufficiently strong recommendations to be adopted, rejected, amended, or deferred in one batch.

This is **not implementation authorization yet**. You are deciding the constitution under which implementation will later proceed. The point is to prevent Sol or Codex from encountering an ambiguity in the middle of coding and quietly choosing whatever behavior makes the tests easiest.

## What "settling" a decision entails

For each decision, you are essentially saying:

```lisp
(:decision :DK-3
 :disposition :adopt-with-conditions
 :choice :original-minter-or-predeclared-delegate
 :rationale "A suspended process may not resurrect its own spending authority."
 :consequences (...)
 :deferred-details (...)
 :effective-in :architecture-0.1)
```

You do not need that exact syntax, but the decision should answer five things:

1. **What did you choose?**
2. **Why?**
3. **What behavior does that require?**
4. **What alternatives did you reject?**
5. **What remains deliberately undecided?**

The consequences matter more than the ceremonial wording. "Adopt D4" is too thin if nobody knows whether it means "all journals use the filesystem forever" or "the kernel defines a storage protocol and the reference implementation happens to use files."

The four DK questions are where your actual worldview enters the machine.

---

# DK-1 — Where exactly does publication happen?

The architecture says publication is an externally consequential effect and therefore requires authority. Your actual repository complicates this beautifully: committing certain files into the lab tree automatically causes them to appear on the public mirror. Fable correctly notes that this could look like an ambient irreversible effect—the architecture says "publication must be authorized," while the infrastructure says "commit here and publication just happens."

There are two coherent models.

### Model A: the commit is the publication frontier

Under this interpretation, when you commit to a mirror-bound repository path, you are not merely storing a file. You are performing a compound operation:

```lisp
(commit artifact
  :effects '((:durable-write lab-repository)
             (:publication public-mirror)))
```

The sync is merely the mechanical settlement of a publication already authorized at commit time.

This is my preference. It matches how the system actually behaves and does not pretend the sync daemon is an unrelated weather event.

But it entails a serious rule:

> Whoever is authorized to commit to a mirror-bound path is thereby authorized to publish to that mirror.

That means the repository or path must be visibly classified as public-bound. There should also be a genuinely private staging area for material that is not ready to cross that frontier.

### Model B: the mirror is governed by a standing publication policy

Here, a prior owner ruling authorizes a class of publications:

```lisp
(:mirror-policy
 :source-scope "experiments/latent-lisp/**"
 :destination public-mirror
 :authorized-committers (...)
 :effect :publication)
```

Individual commits do not need a fresh publication act because the standing policy already grants scoped authority.

This gives you more policy machinery and potentially more precise exceptions. It also creates another object whose scope, expiry, and revision must be managed.

### The question for you

When you commit something inside the mirror-bound tree, do you conceptually mean:

> "I am publishing this now,"

or:

> "I am storing this, and a separate standing publication mechanism happens to publish it"?

I think the first is cleaner and more honest. The architecture can say that automatic downstream effects are still effects; automation merely moves the authorization check earlier.

My recommendation:

> **Adopt Model A. Declare commits to identified mirror-bound paths to be publication frontiers. Require those paths to be explicitly marked, and preserve a separate non-publishing staging area.**

This means the language can represent auto-sync truthfully without inventing a tiny customs official who approves every Git push.

---

# DK-2 — What are the 76 kimi nulls, semantically?

This sounds like a minor vocabulary question. It is not. It determines what the runtime says was actually observed.

Fable's repaired manifestation algebra distinguishes:

```text
:present
:present-empty
:present-invalid
:absent
:withheld
:redacted
```

The crucial law is that if payload bytes exist, they are present—even if empty, malformed, or useless. Invalidity is parser-relative and cannot erase the payload.

The Language-A label "null content" is not precise enough to select the kernel state. You must inspect—or delegate a deterministic inspection of—the frozen envelope shape.

A sensible mapping rule is:

```text
content field = ""                 → :present-empty
content field = empty sequence     → :present-empty
content field absent               → :absent-after-completion
content field explicitly null      → probably :absent-after-completion
payload exists but parser rejects  → :present-invalid
```

I say "probably" for explicit JSON `null` because the provider adapter contract matters. JSON `null` is a present protocol token but ordinarily denotes absence of the subject manifestation. Lisp+ must distinguish the **provider response envelope**, which is certainly present, from the **subject-answer manifestation**, which may be absent.

That gives you two levels:

```lisp
(provider-response
  :status :present-valid
  :subject-manifestation :absent)
```

The owner decision should not choose whichever mapping produces the friendliest analysis. It should freeze a projection from raw envelopes to states.

For example:

> A completed provider envelope maps to `:present-empty` only when the declared subject-content location contains an observed empty payload. It maps to `:absent-after-completion` when the declared subject-content location is missing or explicitly carries no manifestation. Provider metadata, usage records, and reasoning traces do not themselves count as the subject manifestation.

Then the 76 records are mechanically reclassified under that rule.

### What changes depending on your choice?

Scientifically, not much about scoreability: both empty and absent subject answers receive no ordinary answer score and count against content analyzability.

Architecturally, quite a lot:

* `:present-empty` says an answer manifestation occurred, but its payload had zero length.
* `:absent-after-completion` says the request completed without producing an answer manifestation.
* The first preserves a payload identity.
* The second preserves evidence explaining an absence state.
* Adapter conformance tests differ.
* Later parsers are allowed to revisit `:present-empty`, but there is nothing to reparse in a true absence.

My recommendation:

> **Adopt the deterministic raw-envelope mapping above, then classify the 76 from frozen evidence. Do not decree in advance that all "nulls" are one state merely because the census used one nickname.**

This owner act can simultaneously settle the Language-A null-scoring semantics and the Lisp+ manifestation mapping, but it should contain two distinct clauses: one about experimental analyzability, one about runtime state.

---

# DK-3 — Who is allowed to wake a suspended spender?

This is the authority question.

Capabilities are live, unforgeable authority. They are deliberately not serialized into the journal because that would turn a durable record into a transferable skeleton key. What the process stores is:

* which capability was used;
* what authority it came from;
* what scope it had;
* what authority will be required to continue.

After restart, the process cannot simply read:

```text
previously had spending capability
```

and conclude:

```text
therefore I have spending capability again
```

That would make a historical statement self-minting. A diary entry saying "the king once trusted me" should not open the treasury.

Fable recommends that reattachment require either the original minting authority or a delegate explicitly named when the capability was minted.

There are roughly three possible policies.

### Strict restoration

Only the original capability minter may issue the replacement capability.

This is safest and most cumbersome. If the original authority service disappears, suspended processes may become permanently unwakeable.

### Predeclared delegation

The original minter may name a custody service or delegate that can later reattach authority under bounded conditions.

This is my preference.

A restoration would require:

* suspended process identity;
* attempt or seat identity;
* journal state;
* predecessor capability identity;
* original minting receipt;
* current revocation-registry check;
* requested scope;
* evidence that the process is not sitting across an unresolved irreversible effect.

The restored capability gets a **new identity**, linked to the predecessor. Its scope may remain equal or become narrower, but it cannot silently grow.

### Owner intervention every time

Only a fresh explicit owner act can wake any suspended consequential process.

This maximizes human control and turns routine recovery into molasses. It may be appropriate for rare, extremely sensitive effects, but not as the universal kernel rule.

### The question for you

Should authority recovery be:

* centralized in the original minter;
* delegable in advance;
* or always returned to you personally?

I recommend:

> **A live capability may be reattached only by its original minting authority or a restoration delegate explicitly authorized in the minting record. Every reattachment creates a new capability identity, records a restoration receipt, rechecks revocation and unresolved-effect state, and may not enlarge scope.**

Then a domain library may demand fresh owner intervention for especially sensitive capabilities such as key opening or public subject exposure.

That gives Lisp+ a general recovery law without making Tomás the mandatory human USB dongle for every resumed file write.

---

# DK-4 — Is uncertainty a fifth outcome axis?

This one is nearly a technical correction rather than a philosophical dilemma, but because Draft 0 advertised a five-part outcome shape, changing it requires your explicit adoption.

Draft 0 proposed:

```text
execution × manifestation × effect × interpretation × uncertainty
```

Fable's objection is decisive: uncertainty is not a thing alongside execution and manifestation. It tells us how determinate each of those things is. A global uncertainty field would smear several different unknowns into one melodramatic fog bank.

The repaired form is:

```lisp
(outcome
  :execution
    (:value :completed
     :determinacy :determinate)

  :manifestation
    (:value :absent
     :determinacy :determinate)

  :effect
    (:value :possibly-settled
     :determinacy :bounded
     :alternatives '(:billed :not-billed))

  :interpretation
    (:value :not-applicable
     :determinacy :determinate))
```

Call 296 demonstrates why this matters. Its effect may be uncertain while other propositions are much better established. One global label such as `:uncertain` would hide which question is unresolved.

My recommendation is simply:

> **Adopt R3. Outcomes have four principal axes—execution, manifestation, external effect, and interpretation—with determinacy carried independently by each axis.**

This entails changes to:

* the outcome schema;
* matching syntax;
* fixtures;
* the uncertain-effect representation;
* the Architecture 0 summary claim;
* all examples that refer to "five axes."

The uncertain-effect record remains; it becomes the structured representation of uncertainty on the effect axis rather than a second competing ontology.

---

# What D1–D10 actually decide

These are broader architecture choices. Fable recommends adopting all ten draft preferences, with D5 and D9 completed by DK-3 and DK-1 respectively.

They deserve understanding, but not ten nights of existential litigation.

## D1 — What does evaluation return?

The question is whether every effectful form should return one universal `outcome`, or whether Lisp+ should preserve ordinary values and use process handles/outcomes only for consequential operations.

Recommended answer:

> Pure forms return ordinary values. Consequential forms return structured outcomes or process handles implementing an outcome protocol.

Why this matters: making every addition, list operation, and local function return a giant epistemic dossier would suffocate Lisp under paperwork. But making model calls return ordinary strings would recreate the exact collapse Lisp+ exists to prevent.

A useful refinement for Architecture 0.1:

* short synchronous consequential form → structured outcome;
* long-running or resumable form → process handle;
* process handle supports inspection and eventual outcome retrieval;
* pure local forms → ordinary Lisp values.

## D2 — Are claims built into the kernel?

Choice:

* claims as a concrete hardcoded kernel record;
* or a kernel-recognized protocol represented by canonical LCI/0-based library datums.

Recommended answer:

> Kernel protocol, canonical library representation.

The kernel knows what operations a claim must support—identity, content, provenance, standing facets, inspection—but does not permanently hardcode every field of every future claim schema.

This keeps LCI/0 central without welding one frozen record layout into the evaluator's ribcage.

## D3 — Dynamic or static effect checking?

Recommended answer:

> Dynamic capability checking in Kernel /0; optional static effect approximation later.

In practice, before a consequential operation crosses its frontier, the runtime verifies the live capability, scope, budget, destination, identity, and retry safety.

Static analysis may later warn that a function can spend money or publish, but Kernel /0 does not become an effect-type research project before it can survive one forced crash.

The cost: some errors are discovered at runtime.

The gain: the first system remains implementable and honest.

## D4 — Does the kernel mandate files?

Recommended answer:

> Define an abstract durable-store protocol, then provide one canonical filesystem-backed reference implementation.

The kernel specifies semantic requirements:

* ordered append;
* identity;
* prefix validation;
* declared durability;
* torn-tail recovery;
* reconstruction fold;
* conflict behavior.

It does not decree that the universe is made of POSIX files.

Fable's repair adds an important bite: storage backends must declare whether persistence is synced or best-effort; torn trailing records remain visible evidence; and merging multiple journals is itself a receipt-bearing transformation rather than a magical timestamp sort.

## D5 — What survives when authority cannot be serialized?

Recommended answer:

> Persist the capability requirement, public authority identity, scope, and minting receipt—not the live capability. Require explicit reattachment after restart.

DK-3 determines who may perform that reattachment.

This preserves the crucial law:

> A record that authority existed is not itself authority.

## D6 — What does reproducibility mean for nondeterministic providers?

Recommended answer:

> Record the controls requested, provider acknowledgements, resolved model configuration, sampling parameters, and bounded non-reproducibility. Never claim deterministic output replay where the provider cannot guarantee it.

This means Lisp+ distinguishes:

* **execution replay:** we can repeat the same declared procedure;
* **evidence replay:** we can reconstruct what happened from records;
* **output reproduction:** the model emits the same thing again.

The first two may be strong while the third is impossible.

This is a very important anti-bullshit law. "Temperature 0" is not a notarized covenant with causality.

## D7 — What are streaming tokens?

Recommended answer:

> Partial streams are identified provisional manifestations. They remain unsettled until the adapter closes or fails.

They are not merely invisible adapter trivia, because partial output may survive a crash and matter as evidence.

They are also not automatically final manifestations.

A practical implementation need not journal each token separately. It can record identified chunks or checkpoints. Architecture decides the semantics; the adapter chooses a lawful batching strategy.

## D8 — Is secret opening scoring-specific?

Recommended answer:

> `:secret-open` is a generic epistemic effect. Scoring under Cβ is a library protocol built on it.

Why generic? The same primitive applies to:

* blinded rubrics;
* decryption keys;
* private evaluation sets;
* sealed prompts;
* embargoed documents;
* credentials released to a process.

The kernel understands that knowledge access changes what later actions are permitted. It does not need to know what a scoring constitution is.

## D9 — Is publication a kernel effect?

Recommended answer:

> The kernel supports an extensible publication effect; libraries define what publication means in each workflow.

DK-1 then decides how your auto-syncing mirror crosses that frontier.

Also, Fable's visibility repair should be adopted:

```lisp
(:published :scope public-mirror)
(:withheld :scope public)
(:available :scope freezer-custodian)
```

"Published" without a destination is as oversized as "verified" without a validator.

## D10 — How much ordinary Common Lisp can leak through?

Recommended answer:

> Local ephemeral computation may use ordinary host values freely. Any value crossing a durable identity, evidence, receipt, journal, or canonical comparison boundary must be converted into an accepted canonical representation.

This gives you a very Lisp-like principle:

> **Loose and lively inside; exact at the border.**

You do not need to canonicalize every cons cell while calculating locally. But you cannot place an implementation-dependent hash table into a sealed receipt and then call the result portable evidence.

This is one of the decisions that keeps Lisp+ from turning into a monastery where every temporary integer must receive a passport stamp.

---

# What I think you are actually deciding

Behind the labels, the four true questions are these:

### DK-1 asks:

**When does an action become public?**

### DK-2 asks:

**What counts as an output appearing?**

### DK-3 asks:

**Who may restore power after interruption?**

### DK-4 asks:

**Does uncertainty belong to the whole event, or to the particular proposition that is unknown?**

Those are genuinely authorial questions. They say what kind of moral and computational world Lisp+ inhabits.

D1–D10 mostly ask how to express that world without making the kernel either enormous or vacuous.

## My present recommended disposition

Were I filling the docket now, I would choose:

```text
DK-1  Adopt commit-as-publication-frontier for declared mirror-bound paths.
DK-2  Adopt raw-envelope projection; classify empty payload as present-empty,
      missing/null subject payload as absent-after-completion.
DK-3  Reattachment by original minter or delegate named at mint time;
      new capability identity, no scope enlargement, restoration receipt required.
DK-4  Adopt uncertainty as per-axis determinacy mode.

D1    Adopt.
D2    Adopt.
D3    Adopt.
D4    Adopt with Fable R8 journal annotations.
D5    Adopt, completed by DK-3.
D6    Adopt.
D7    Adopt.
D8    Adopt.
D9    Adopt, completed by DK-1 and scoped visibility.
D10   Adopt.
```

The only decision I would not finalize from prose alone is **the factual application of DK-2 to the 76 records**. The mapping rule can be adopted now; the classification must come from the actual frozen envelopes and adapter contract.

A good way for you to think through each choice is to ask:

> What failure does this prevent?
> What convenience does it cost?
> Does it belong to the language or merely to the Language-A library?
> What should happen after the host dies at the worst possible instant?
> What behavior would an implementer otherwise be forced to invent?

Once your intuitions settle, the decision record itself can be compact. The thinking is the cathedral; the signed artifact can be a very well-made door.
