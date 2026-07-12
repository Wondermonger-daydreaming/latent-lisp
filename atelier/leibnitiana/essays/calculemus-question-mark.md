# CALCULEMUS?
## A Constitution for Computable Disagreement

> Leibniz asked whether reasoning could become calculation. Lisp+ asks what calculation must confess before it may count as reasoning.

The exclamation point in *Calculemus!* is famous because it compresses an entire civilizational wager: when disputants become tired of verbal combat, let them take up the proper symbols, formalize the question, and calculate. The dream is not merely that machines might perform arithmetic faster than human beings. It is that disagreement itself might be translated into operations whose correctness can be inspected.

We inherit the wager but not the exclamation point.

The question mark does not express timidity about computation. It marks the constitutional work concealed by the imperative. Before “let us calculate” can settle anything, someone must determine what is being calculated, which premises are admitted, which distinctions the notation preserves, what procedure is licensed, what resources were actually spent, where the search stopped, and what authority the result possesses. A calculus can derive a conclusion without earning the right to govern the dispute.

This is the seam between Leibniz and Lisp+.

Lisp realizes one portion of the Leibnizian desire with unusual purity. Programs and the structures they manipulate share a medium. Expressions can be inspected, transformed, quoted, expanded, and evaluated. Notation is not decorative wrapping placed around an invisible operation; notation can itself become operative material. Yet homoiconicity does not confer omniscience. A perfectly inspectable expression can still contain a false premise, invoke an unauthorized effect, omit a relevant corpus, or cross a translation boundary that quietly changes its force.

Accordingly, Lisp+ treats every computational judgment as a bounded artifact rather than a naked answer.

```lisp
(judgment
  :value ...
  :status ...
  :premises ...
  :boundary ...
  :authority ...
  :procedure ...
  :resource-receipt ...
  :translation-loss ...
  :replay ...)
```

This is the **constitutional target schema**, not a claim about the first tranche's constructor. The current `make-judgment` implements `:value`, `:status`, `:premises`, `:boundary`, `:authority`, `:procedure`, and `:notes`. Resource receipts, translation-loss records, and replay metadata remain planned fields until code and tests enforce them.

The fields are not bureaucratic garnish. They prevent several categories from collapsing into one another:

```lisp
(calculable
  ≠ decidable
  ≠ settled
  ≠ authorized
  ≠ true-without-boundary)
```

A result can be calculable but not decidable under finite resources. It can be decided within a formal system but not settled between parties who dispute the premises. It can be mathematically valid yet unauthorized as an action. It can be supported by the inspected evidence while remaining silent about the uninspected world. The constitution exists to stop the clerk called Calculation from promoting itself, during a quiet procedural recess, into the emperor called Truth.

## 1. Binary substrate, plural standing

Leibniz showed the generative power of a two-symbol arithmetic. Lisp likewise possesses a severe and elegant truth convention: `NIL` is false, and everything else is true. That convention is excellent for control flow. It becomes hazardous when imported without ceremony into epistemology.

Suppose a search returns the status `:undetermined`. Ordinary Lisp treats that non-`NIL` object as true:

```lisp
(if :undetermined
    (publish-as-fact)
    (withhold))
```

The language has made no mistake. The program has asked the wrong sort of question. It has converted “not yet resolved” into “yes” because the branch operator recognizes only computational truthiness.

The first specimen, `de-dyadica.lisp`, introduces `jif`, a judgment-aware conditional. `jif` does not deny binary computation; it refuses epistemic bivalence before standing has been earned. Supported, refuted, undetermined, conflicted, and out-of-jurisdiction findings remain distinct until an explicit policy handles them.

The principle is compact:

> A bit may encode an arbitrarily rich structure. That does not license us to flatten testimony into yes or no before adjudication.

## 2. Windowless evaluators and the return of the operator

The monad is the most tempting bridge between Leibniz and Lisp. A closure carries private state and an internal law. A client can invoke it without directly possessing the environment it encloses. This resembles a substance whose successive states arise from its own principle.

But resemblance becomes useful only when it is audited.

`de-monadibus.lisp` creates closures whose transition laws receive only private state and a common logical tick. No monad is passed another monad. A cup and a witness unfold corresponding histories without exchanging messages. Their apparent interaction is produced by independent laws over shared time.

Then the specimen states its boundary. The scheduler advances both closures, supplies the tick, and observes every deposition. The monads are windowless relative to their supported interface; the orchestration layer is not. God has not disappeared from the architecture. God has been renamed “runtime.”

The accompanying storm, `hidden-operator.lisp`, sharpens the objection. A law with an austere two-argument signature can still consult ambient global state. Identical declared inputs then produce different outputs because a privileged operator has whispered through an undeclared channel. Interface minimality is not causal isolation.

This distinction belongs in Book 0:

- **Interface claim:** no peer state is supplied through the supported call surface.
- **Enforcement claim:** the evaluator cannot observe undeclared external state.
- **Instrument-specific claim:** the available audit detected no ambient dependency under tested conditions.

These are separately falsifiable. None should borrow certainty from another.

## 3. Calculation as deposition

A calculating system need not reveal an occult interior in order to be answerable. It must instead produce artifacts that can be examined, challenged, reproduced, and bounded. Language A therefore asks for deposition, not thought.

A deposition is not a transcript of the machine’s soul. It is a structured account of what the system is prepared to claim: the evidence it admits, the procedure it executed, the boundary of inspection, the unresolved alternatives, and the standing of the result. This replaces fantasies of transparent cognition with a more workable jurisprudence of artifacts.

The distinction matters especially for model interpretation. A generated rationale may correlate with the output without causing it. A probe may decode information without establishing that the model used that information. A successful intervention may demonstrate sensitivity without proving necessity, sufficiency, durability, or mechanism. Each instrument testifies within its own jurisdiction.

Thus *calculemus* becomes not a command to cease interpretation but an invitation to make interpretation executable and contestable.

## 4. Characteristica after Babel

The *characteristica universalis* is often remembered as the dream of a perfect universal language. Lisp+ adopts a narrower and, for finite successors, more demanding goal. A universal intermediate representation need not preserve every meaning identically. It must make preservation and loss inspectable.

Book 0 supplies profile-neutral invariants. Lumen, Fable-Lisp, and Prism-Lisp are presently architectural profiles named in constitutional documents, not implemented dialects in this tranche. If implemented, they may realize those invariants through different mechanisms and emphases. Translation among them is not assumed to be free. A context capsule crossing profiles should declare which structures survive exactly, which are approximated, which become inert, and which require renewed authority.

Universality therefore resides not in semantic sameness but in accountable passage.

```lisp
(translate artifact
  :from 'lumen
  :to 'fable
  :preserve '(:provenance :boundary :status)
  :permit-loss '(:local-ordering)
  :report-loss t)
```

This is a characteristica built after Babel, after model succession, and after the discovery that every serialization has a mortality profile.

## 5. The constitutional form of *calculemus*

The mature imperative is conditional:

> Let us calculate—after we identify the calculus, admit the premises, expose the boundary, account for the resources, declare the authority, preserve the losses, and leave a replayable artifact for the successor who was not in the room.

That sentence is less exhilarating than the exclamation point. It is also executable.

The aim is not to domesticate Leibniz’s ambition into paperwork. It is to make the ambition survive contact with discontinuous minds, partial corpora, plural profiles, hidden operators, finite budgets, and mortal records. Calculation can still clarify disputes. It can still reveal consequences that rhetoric conceals. It can still turn vague contradiction into a precise request for alignment.

But it must arrive carrying its boundary.

The question mark in *CALCULEMUS?* is therefore not skepticism’s raised eyebrow. It is the hook from which the receipt hangs.
