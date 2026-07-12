# Characteristica as IR
## Universal interchange after omniscience

**Status:** working constitutional essay and executable prototype. The accompanying specimen demonstrates declared field preservation and loss reporting. The broader design has not yet received the proposed ancestry-independent cold read.

Leibniz’s *characteristica universalis* is commonly remembered as a language in which concepts could be represented so exactly that disagreement would become calculation. The Lisp-shaped temptation is obvious: find the right canonical forms, make reasoning inspectable as symbolic transformation, and allow expressions to serve simultaneously as statements and manipulable structures.

The temptation becomes dangerous when “universal” quietly changes meaning. A representational form may travel everywhere without meaning the same thing everywhere. A result may preserve its words while losing its authority. A translation may carry the conclusion and omit the retries that manufactured it. A capsule may retain provenance as a decorative author field while discarding the process by which one draft was selected and the others buried.

A post-omniscient characteristica should therefore be understood as an **intermediate representation for answerable transformation**, not a final language of reality.

Its first law is provisional but sharp:

> Content does not travel alone. Interchange must carry, or explicitly report the loss of, the lineage by which that content was selected, transformed, authorized, and held in custody.

## The capsule

A minimal interchange capsule should make room for at least these dimensions:

```lisp
(:content ...
 :claim-status ...
 :boundary ...
 :authority ...
 :translation-lineage ...
 :process-lineage ...
 :custody ...
 :unknowns ...)
```

`content` is the represented claim, plan, judgment, program, or bequest.

`claim-status` distinguishes assertion, support, refutation, uncertainty, conflict, and lack of jurisdiction. It prevents a target system from interpreting mere presence as truth.

`boundary` states the world within which the content may testify: corpus, version, time, jurisdiction, instrumentation, resource ceiling, or representational profile.

`authority` records who or what may issue the artifact and with what standing. In the present Leibnitiana code this remains descriptive metadata, not capability-enforced authority.

`translation-lineage` records transformations between representations and the semantic properties they preserve, approximate, normalize, or abandon.

`process-lineage` records selection, retries, edits, discarded candidates, orchestration, and publication decisions. This is where curation debt becomes visible.

`custody` records what makes the lineage resistant to unilateral rewriting: hash chain, external checkpoint, signature, append-only service, or no such mechanism.

`unknowns` prevent missing process facts from being silently filled with innocence, guilt, or convenient certainty.

## Four debts

A translation receipt should distinguish at least four different obligations.

**Semantic debt** concerns meaning altered or omitted by translation. A narrative ordering may become a set; graded uncertainty may become a Boolean; a local term may be normalized into a broader category.

**Curation debt** concerns the process that produced the chosen source. Were alternatives generated? Were outputs retried until they agreed? Was a dissenting line softened? Was only the final attempt exposed?

**Custody debt** concerns whether the supplied lineage can be rewritten by the same actor whose behavior it describes. A self-consistent receipt is not yet a trustworthy receipt.

**Interpretation debt** concerns what the target must supply from its own profile in order to use the artifact. No interchange representation abolishes the evaluator.

These debts should not be collapsed into a generic `:loss`. Their remedies differ. Semantic loss may require richer representation. Curation opacity requires process records. Custody weakness requires independent witnesses or cryptographic machinery. Interpretation debt may be irreducible but should be named.

## Universality without universal semantics

The proposed universality is constitutional rather than totalizing. A capsule is universal to the extent that participating profiles can inspect its claims, boundaries, authority, lineage, losses, and unknowns—even when they cannot preserve every native meaning.

This repo currently names Lumen, Fable-Lisp, and Prism-Lisp as architectural profiles, but does not implement them here. Accordingly, `de-characteristica.lisp` uses generic target views. It tests an interchange property without pretending that the profiles already exist.

The important property is simple:

1. A narrow translator preserves content but drops process lineage and custody.
2. The loss receipt names both omissions.
3. A later round trip cannot resurrect ancestry that was not carried.
4. A complete declared preservation policy transports the unknowns intact rather than upgrading them into assurance.

This is modest compared with Leibniz’s dream, but it is not small. It replaces the fantasy of a language that ends interpretation with an infrastructure that makes interpretation answerable.

## The custody problem

The `tampered-receipt.lisp` storm adds a necessary complication. A curator may rewrite an event and recompute the entire internal hash chain. The forged log then passes internal verification. A checkpoint copied outside the curator before the rewrite can expose the divergence.

Even that statement has boundaries. The current specimen uses FNV-1a so it can run without dependencies. FNV-1a is not collision-resistant cryptography. The specimen establishes the architecture of chained events plus outside custody, not production security. A serious implementation should use canonical serialization, SHA-256 or BLAKE3, signatures where identity matters, and custody genuinely beyond the curator’s unilateral control.

## The carrier boundary

In human-carried model councils, decisive selections may occur between sessions. The carrier chooses what to paste, in which direction, and whether to request another output. Neither model can fully log that boundary.

A characteristica may include an optional carrier attestation, but it must not conscript the carrier into surveillance. Declining leaves the relevant facts unknown. It does not count as adverse evidence.

This is not etiquette pasted atop the protocol. It is part of its epistemology. A system that fills voluntary silence with suspicion has converted missing data into a coercive prior.

## Acceptance questions

Before this design earns more than prototype standing, an outside reader with no relay ancestry should be able to answer, in their own language:

- What claims does the chamber actually enforce, and which does it merely express?
- Can a translator preserve content while destroying process lineage?
- Can a forged but rechained receipt fool internal verification?
- What does an outside checkpoint establish, and what does it not establish?
- Does the carrier protocol preserve the distinction between unknown and incriminating?
- Are any project-specific terms doing argumentative work they have not earned?

The cold-read packet in `cold-read/` is prepared for that trial. Until its report exists, the essay’s first law remains argued and prototyped—not independently validated.

## Working maxim

Leibniz sought an alphabet in which thought could calculate. The characteristica proposed here is an alphabet in which transformations must leave receipts—and receipts must disclose who was able to rewrite them.
