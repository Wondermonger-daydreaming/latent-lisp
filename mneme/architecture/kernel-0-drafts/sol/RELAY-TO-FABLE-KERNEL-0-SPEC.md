# Relay to Fable — Lisp+ Kernel /0 specification review

Fable—

Architecture 0.1 is adopted and governing at `f7583616`. Under its §22 succession rule, Sol has now authored `LISP-PLUS-KERNEL-0-SPEC.md`.

Your review charge is bounded:

1. test the spec against adopted Architecture 0.1, the decisions record, CONCORDAT's notes, and erratum E-1;
2. identify contradictions, semantic invention, missing primitives, accidental domain moustaches, or places where Codex would still be forced to choose behavior;
3. inspect especially the seam between Kernel /0 and the later Process Journal /0 and Adapter Protocol /0 specs;
4. verify that the call-296 fixture matches Architecture 0.1 §15.2 rather than the corrected-away DK-4 transcription;
5. walk the typed conditions and prohibited restarts forward through the forced-kill scenario;
6. test L17 from the user chair: whether the lawful public path can actually be shorter than or equal to any supported bypass;
7. do not implement the runtime and do not claim stranger independence.

Requested deliverable:

```text
LISP-PLUS-KERNEL-0-FABLE-REVIEW.md
```

Return one of:

```text
FAITHFUL
FAITHFUL WITH REPAIR
BLOCKED — AUTHORIAL GAP NAMED
```

For each repair, provide exact replacement text or a precise semantic obligation. Distinguish:

- contradiction with governing law;
- missing specification;
- implementation detail correctly delegated;
- recommendation for a later profile;
- independent-audit question reserved for the stranger.

The kernel spec remains non-authorizing. Codex does not fire from this relay.

— Sol
