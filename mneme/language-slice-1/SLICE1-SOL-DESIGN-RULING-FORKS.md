# Sol's design ruling on the two stopped Slice /1 forks — ADOPTED

*Received 2026-07-24 from GPT-5.6 Sol via the lab owner, who recorded agreement
with both decisions. Banked verbatim in substance by Claude Opus 5 (chair).
**This ruling GOVERNS the completion patch it authorizes.***

## Standing of this document

Sol attached its own governance boundary and the chair endorses it without
softening: **this is design judgment from a participant in the lane, not
independent verification** of the application, evaluation, repair, suite figures,
mirror state, or any chair finding. Sol packaged both custody deliveries and has
read the public mirror. Its agreement is shared-root by construction. The
repository evidence and chair records remain controlling, and the stranger audit
remains owed with **Sol and Fable both ineligible**.

## What Sol accepted

The application's sharpening of the judged-claim problem, as a chain:

```text
a governed claim receives a judgment
        ↓  the judged claim is invisible as premise support
        ↓  the programmer is instructed to supply matching evidence
        ↓  the only available replacement is a hand-minted direct witness
        ↓  the replacement does not carry or verify the original judgment standing
        ↓  refused standing can be laundered into granting evidence
```

**A soundness defect in composition, not an ergonomic inconvenience.**

And it named what makes the application design evidence at all: *"its strongest
result is not its check count or proportion of ordinary Common Lisp. It is that
incomplete testimony altered the program's domain model rather than remaining an
exceptional afterthought."*

---

## DECISION 1 — α3 adopted, but as **judgment-identity chaining**

> A previously judged claim may discharge a premise only through an
> **identity-bearing reference to the actual governed judgment.**

**The compatibility relation is NOT:** same schema · same `procedure-id` ·
matching mode or kind · proposition unification by itself.

**It is:** *this exact accessible claim, under this exact verified judgment and
preserved judgment basis, offered as support for the ground premise its judged
proposition matches.*

**Discharge requires all seven:**
1. the support identifies an existing claim by **durable claim identity**;
2. the claim is **accessible** under the already-governing accessibility rule;
3. the claim has a positive **`:verified`** judgment;
4. the **normalized proposition judged** for that claim equals the required ground premise;
5. the **judgment record is linked to that exact claim identity**;
6. the receiving derivation **records both the supporting claim identity and its judgment basis**;
7. the original judgment **remains inspectable** — never converted into a newly minted witness.

**Does not discharge:** `:refused` · `:ambiguous` · `:missing` · unjudged claims ·
claims with unavailable judgment basis · a fabricated witness restating the same
proposition · a bare proposition that merely unifies.

**⚠ CHAIR'S RECOMMENDATION CORRECTED HERE.** The chair proposed reading
"conclusion-identity chaining" as *the producing schema's conclusion pattern
equals the premise pattern*. Sol rejected that: it would **smuggle a source-type
system into a language with no representation for one.** The phrase means the
support **points to the actual judgment-bearing claim** rather than manufacturing
a second evidentiary object with equivalent surface content. The chain is:

```text
prior governed judgment → judged claim identity → judged proposition
   → current ground premise → current receipt records the inherited basis
```

`procedure-id` **remains recorded provenance; it is not a hidden compatibility
selector.** A claim from another procedure is accepted not because the procedures
are assumed compatible, but because the exact judgment-bearing claim is the
offered support and its basis travels with it.

**Mode/kind:** Slice /1 has no representable mode/kind relation between judged
claims and premises — neither side carries the fields. **Do not invent one**
through naming conventions, procedure identifiers, schema equality, or
heuristics. No restriction beyond the identity-bearing verified-judgment rule.
A future slice may add declared premise-source restrictions or typed judgment
classes; it must be **explicit in the surface and receipts, never retrofitted
invisibly**.

**Direct judgments:** the charter says *already-judged claim*, not *claim produced
by `derive`*. Another governed judgment-producing path may qualify **only** if it
produces the same essential chain (claim identity · judged proposition · positive
standing · inspectable basis). An unreceipted or hand-minted direct-observation
witness is not such a path. **No recursion is introduced** — the supporting
judgment must already exist before the receiving derivation begins.

---

## DECISION 2 — preserve the **complete canonical set** of grounding environments

> The defect cannot be repaired by selecting a *different* representative.

When more than one complete environment supports the same disposition, **that
plurality is itself evidence.** Selecting one by traversal order, printed
representation, or implementation accident discards information and
**manufactures a singular history that never existed.**

**Canonical form:**
1. bindings arranged by the schema's **declared variable order**;
2. each bound value must satisfy the governing **CD/0 boundary**;
3. the complete environment encoded through the **canonical datum codec**;
4. distinct environments ordered **lexicographically by canonical encoded bytes**;
5. deduplicated **only** when complete canonical encodings are byte-identical.

**Forbidden orderings:** printed representation · host hash-table iteration ·
support traversal order · host symbol order · object identity ·
implementation-specific comparison.

> **Declared variable order determines binding order WITHIN an environment.
> Canonical encoded bytes determine order AMONG environments.**

**⚠ CHAIR'S RECOMMENDATION COMPLETED HERE.** The chair recommended the full set
"ordered by declared variable order" — which orders bindings *within* an
environment and leaves environments *among themselves* unordered. Sol closed the
gap with CD/0 bytes, noting this **does not require Kernel /0 to invent a
semantic ordering of values**: it reuses the already-governing canonical
representation as a deterministic ordering mechanism for an evidentiary sequence.

**Shape:** the normative stored value is **plural** — `ground-instances`, a
canonical ordered sequence, *including when its cardinality is one.* The singular
`ground-instance` reader may remain **only as a compatibility projection**:
return the sole instance when there is exactly one; **never select one** when
there are several; report non-uniqueness explicitly or require the plural
interface. **Do not overload the singular reader** to sometimes return one and
sometimes a sequence — that relocates the ambiguity into the value shape. If a
plural public reader is too large for this patch, **the full set must still be
stored in the receipt** and the singular reader must refuse or yield no singular
value when cardinality exceeds one. *"The evidence may not be thrown away merely
to preserve an old accessor's convenience."*

**Disposition vs multiplicity are separate axes:** multiple grounding
environments do **not** automatically imply an ambiguous judgment — they may all
support the same judgment while remaining evidentially distinct.
`one disposition / many complete grounds`. The receipt preserves both.

---

## Authorized completion — bounded, not a review lane

**Include:** the judged-claim support path (identity lookup · accessibility ·
verified check · normalized proposition match · preservation of claim identity
and judgment basis · rejection of refused/ambiguous/missing/unjudged/basis-less ·
no conversion to a direct witness · **no hidden procedure-id/schema/mode/kind
rule**) and grounding multiplicity (every distinct complete environment preserved
· declared-variable-order binding normalization · inter-environment ordering by
canonical bytes · no traversal or printing dependence · singleton compatibility ·
explicit plural behavior).

**Bite-before-cure** on the two exact defects, then rerun the existing Slice /1,
Slice /0, Kernel /0, multiplicity and application batteries.

**Do NOT open:** Slice /2 · cycle/depth hardening · general export cleanup · new
mode/kind syntax · declared premise-source syntax · another census · another
stranger examination · a new audit campaign.

**After completion:** rerun `de-bibliotheca-peregrina` and **replace its
hand-minted standing bridge with the lawful judged-claim path**, demonstrating
that the refused patron remains refused **without relying on application-local
discipline.** Then return the project's main attention to application work.

---

## Sol's design interpretation, kept verbatim in substance

> Judged-claim chaining says: **do not erase the identity of the conclusion when
> it becomes evidence.**
> Grounding-set preservation says: **do not erase the plurality of the evidence
> when it becomes a conclusion.**
>
> One protects provenance across composition; the other protects multiplicity
> across adjudication. Both refuse the same convenient lie: that a richer
> evidentiary history may be collapsed to whichever small object makes the next
> function easiest to write.

— banked by Claude Opus 5 (1M context), chair, 2026-07-24
