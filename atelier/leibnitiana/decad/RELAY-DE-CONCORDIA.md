# Relay to Claude Code — land `de-concordia.lisp`

Prepared 2026-07-12 for the live `Wondermonger-daydreaming/latent-lisp` tree.

## Artifact

- Source: `de-concordia.lisp`
- Proposed path: `mneme/atelier/instruments/de-concordia.lisp`
- Sender-side lines: 1090
- SHA-256: `13937f29f4b20fb3d8f04007c6a617a9e680f3463865efc5aff657d4a55b28ff`
- Native Common Lisp status: **not run here**; no Lisp implementation was available.
- Static preflight: PASS.
- Independent Python behavioral model: PASS.

## Why this chamber exists

Virginia Woolf's account of reading poetry is not a mere list of faculties.  It
is ordered composition:

1. the sensual eye opens upon images;
2. sympathy accompanies figures without consuming their otherness;
3. movement carries those figures through a world;
4. a pervading poetic belief arises only when image, sympathy, movement, and
   support relations hold one another up.

The Lisp+ contribution is the distinction between **activation**,
**aggregation**, and **concord**.  A system may have every feature switched on
and still lack the relations that make those features compose a world.

## The bounded claim

Inside its finite deterministic domain, the specimen establishes:

1. vivid images are necessary but do not yet constitute a world;
2. sympathy means accompaniment, not identity-collapse or obedience;
3. movement is narrative carriage, not yet combination;
4. listing activated faculties is not concord without explicit support edges;
5. mutual support preserves the distinct relata whose relation is described;
6. poetic belief is sustained internal coherence, not evidence or verification;
7. breaking one required support edge changes the result to `:BROKEN` and fires
   `BELIEF-THREAD-BROKEN` rather than silently degrading the world;
8. four stages consume six attunement units; two restart-supplied units remain
   part of the event and deterministic replay;
9. the historical reader procedure is part of replayability;
10. seven counterfeit readings remain archived as complete proposal scars.

The final lawful conclusion is:

```lisp
:WORLD-SUSTAINED-BY-CONCORD
```

with:

```lisp
:POETIC-BELIEF :SUSTAINED
:STANDING       :ASSERTED -> :ASSERTED
```

## Constitutional distinctions not to flatten

These typed refusals are the instrument, not decorative error names:

```text
IMAGE-IS-NOT-WORLD
SYMPATHY-IS-NOT-IDENTITY
SYMPATHY-IS-NOT-OBEDIENCE
MOVEMENT-IS-NOT-COMBINATION
AGGREGATION-IS-NOT-CONCORD
SUPPORT-IS-NOT-IDENTITY
BELIEF-THREAD-BROKEN
POETIC-BELIEF-IS-NOT-EVIDENCE
READER-PROCEDURE-UNAVAILABLE
FORGED-BELIEF-CLAIM
STALE-READING-PLAN
```

Please do not make the suite pass by weakening those boundaries.  In
particular:

- do not let the sensual stage mark the world complete;
- do not rewrite sympathy as identity, compliance, or transferred authority;
- do not infer concord merely because all four stage labels occur in a list;
- do not replace support edges with a scalar "coherence score" that hides what
  supports what;
- do not call the tree, knight, lady, and reader one object because they enter a
  mutual support graph;
- do not promote `:SUSTAINED` poetic belief to `:VERIFIED` standing;
- do not erase the two supplied attunement units during replay;
- do not treat a missing historical reader as successful replay.

## Receiving procedure

1. Inspect the live branch first.  The public tree may have moved, and the
   preceding Hay/Lathe/Furnace/Tempering/Leviathan/Abyss/Incantation/Resonance/
   Dilation relays may or may not have landed.
2. Copy the source to:

```text
mneme/atelier/instruments/de-concordia.lisp
```

3. Place the two sender-side helpers somewhere appropriate for receiving work
   and run:

```bash
python3 check-de-concordia.py de-concordia.lisp
python3 reference-de-concordia.py
```

4. Run the native specimen from its own directory, so the relative
   `../kernel/atelier-root.lisp` load is tested honestly:

```bash
cd mneme/atelier/instruments
sbcl --script de-concordia.lisp
```

5. Expected landmarks include:

```text
seven archived counterfeit-reading scars
faculty order (:SENSUAL :SYMPATHETIC :KINETIC :CONCORDANT)
seen 3
sympathy 6
movement 4
support edges 7
attunement supplied 2
final attunement 0
:POETIC-BELIEF :SUSTAINED
:ASSERTED -> :ASSERTED
:WORLD-SUSTAINED-BY-CONCORD
DE CONCORDIA complete
```

6. Confirm the following adversarial gates actually fire in native Common Lisp:

```text
SUPPORT-IS-NOT-IDENTITY
POETIC-BELIEF-IS-NOT-EVIDENCE
BELIEF-THREAD-BROKEN
FORGED-BELIEF-CLAIM
READER-PROCEDURE-UNAVAILABLE
STALE-READING-PLAN
```

7. Run the full current atelier suite:

```bash
cd ..
./run-all.sh
```

8. Only after native success, integrate minimally into the live `CANON.md`,
   `MANIFEST.sexp`, and `run-all.sh` using their actual current syntax and
   ordering.  Do not replace live files wholesale with assumptions from this
   packet.
9. Report every repair.  Distinguish source defects from repository drift.
   Include SBCL version, command, exit code, output landmarks, any code changes,
   and the post-repair SHA-256.

## Review points worth pressing

- Confirm the stage order is enforced, not merely printed.
- Confirm `:SYMPATHETIC` cannot run before `:SENSUAL`, and `:CONCORDANT` cannot
  run before movement exists.
- Confirm `ADD-UNIQUE` and the support-key logic do not accidentally collapse
  distinct edges.
- Confirm the two replay supply events are both consumed before the concordant
  cost is charged.
- Confirm a recomputed toy digest does not allow a forged `:VERIFIED` receipt.
- Confirm severing `(:GREEN-TREE :CRESTED-KNIGHT :INHABITED-WORLD)` causes
  `BELIEF-THREAD-BROKEN`.
- Confirm removal of `:WOOLF-LAYERED-READER` version 1 blocks replay and that the
  registry is restored under `UNWIND-PROTECT`.
- Confirm seven scars retain the full rejected proposal rather than only the
  condition name.
- Consider strengthening native event validation if SBCL review reveals that a
  recomputed run digest could conceal a malformed faculty event.  Preserve the
  current semantics while tightening custody.

## Nonclaims to preserve

This is not a psychometric model of human reading, a neural architecture, a
proof of Woolf's criticism, a ranking of poems, or a factual verification of
Spenser's represented world.  The figures, faculties, resources, and support
relations are finite declared structures.  The digest is pedagogical, not
cryptographic.  Same-image code with package-internal access remains outside
its threat model.

The closing sentence is intentionally narrower than literary theology:

> The tree becomes part of the knight by support, not by ceasing to be a tree.
