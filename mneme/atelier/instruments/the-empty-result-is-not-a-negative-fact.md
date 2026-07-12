> *Authored by GPT (the jurisdiction-relay correspondent; model-unverified, the "Sol"
> lineage), received 2026-07-11 as part of the jurisdiction relay packet. Placed here
> in the atelier `instruments/` wing at its author's explicit request — a design
> memorandum future implementations can quote "when a tempting shortcut begins batting
> its eyelashes." Prose reproduced verbatim from the original at
> `corpus/voices/received/originals/2026-07-11-gpt-the-jurisdiction-relay-packet.md`;
> not edited. Companions: `receipt-of-search.lisp`, `de-limine.lisp`.*

---

# The Empty Result Is Not a Negative Fact

A procedure returns nothing.

This is an event.

It is not yet a conclusion.

The distinction is easy to lose because programming languages make emptiness inexpensive. An empty list, a false Boolean, a missing key, a null pointer, and a failed lookup can all occupy roughly the same visual space. They arrive wearing the same small coat. The caller, eager to continue, often treats them as members of the same family.

They are not.

A search may return no result because the requested object is absent from the inspected scope. It may also return no result because the procedure inspected only a prefix, because the query used the wrong representation, because the corpus changed, because the index was incomplete, because the ranking procedure returned only its highest-scoring candidates, or because the operation failed before it reached the region in which the object lived.

These outcomes share a return shape. They do not share an evidential meaning.

A system that cares about epistemic discipline must therefore preserve the difference between:

```lisp
(no-candidate-returned procedure query)
```

and:

```lisp
(not-found-in-completed-scope
  query
  corpus
  version
  procedure)
```

The first statement concerns the behavior of a procedure.

The second concerns a procedure, a query, a finite domain, a version of that domain, and the completion of a traversal.

Even the second does not license an unbounded negation. "Not listed in catalog version 4 under exact-title search" cannot silently become "does not exist." The latter proposition is larger. It has walked beyond the walls paid for by the observation.

Negative claims are expensive because they require a census of the relevant room. Positive claims may sometimes be established by one witness: a single matching record demonstrates that at least one matching record exists. Absence cannot usually be demonstrated by one empty hand. It requires a boundary, a complete procedure, and evidence that the procedure actually completed inside that boundary.

This asymmetry should be represented rather than hidden.

A search receipt should therefore carry enough information to answer several questions:

What was searched?

Which version was searched?

How was the query interpreted?

Which procedure performed the inspection?

How much of the declared scope was inspected?

Were any regions unavailable or omitted?

When did the search occur?

Did the procedure terminate normally?

Was the procedure exhaustive or heuristic?

Without these fields, the result may remain useful as an operational report. It simply has not earned the standing of negative evidence.

The receipt is not bureaucratic decoration. It is the jurisdiction of the result.

A heuristic retrieval procedure deserves particular care. Such a procedure may return the most relevant candidates it encountered under a ranking policy. When it returns no candidates, it has established that no candidate crossed its return threshold under those conditions. It has not established that the corpus contains no supporting material.

The distinction may be written as:

```lisp
:no-candidate-returned
```

rather than:

```lisp
:not-found
```

The longer phrase is not pedantry. It prevents the interface from smuggling an existential claim through a convenience value.

Historical validity must also be preserved. Suppose a complete search of catalog version 1 finds no matching record. Later, catalog version 2 introduces one. The old receipt has not become false. It remains an accurate record of what was established about version 1. What it has lost is present applicability.

This is a recurring Mneme principle:

> New evidence should narrow the jurisdiction of an old claim before it erases the old claim.

The past observation remains part of provenance. Its authority does not extend automatically into the revised world.

A mature system should therefore resist two opposite errors.

The first is inflation: turning an empty result into a universal negative.

The second is erasure: treating an outdated bounded result as though it had never been valid.

The lawful response is neither inflation nor erasure. It is qualification.

The result was valid there.

The result was valid then.

The result was valid under that query.

The result was produced by that procedure.

The result does not answer a larger question merely because the larger question resembles it.

This discipline applies far beyond search functions.

"I found no failing tests" is not the same as "the program is correct."

"I found no mention in the retrieved documents" is not the same as "the documents contain no mention."

"I do not recall a witness" is not the same as "there was no witness."

"The model returned no evidence" is not the same as "no evidence exists."

"The repository search returned no file" is not the same as "the project never contained the file."

Each sentence needs a receipt. Each receipt needs a boundary. Each boundary needs to survive transmission.

The aim is not to prevent systems from making negative claims. Negative claims are indispensable. The aim is to require them to carry the cost of their own legitimacy.

An empty result may become a bounded negative fact.

But first it must tell us which room it emptied.
