# Adapter Protocol /0 — Reference Authoring Transcript

## Inputs

The authoring lane read the adopted public chain and the sealed AP0 charge:

- Architecture 0.1;
- Kernel /0;
- Process Journal /0 and its sealed repairs;
- DRAFT-S and DRAFT-F;
- AP0 plan concordance;
- sealed AP0 authoring charge.

The blind-plan parentage was preserved. DRAFT-S supplied the structural skeleton; DIV-1 through DIV-6 were adopted to S; F-HOLD-1 through F-HOLD-6 were incorporated as normative additions.

## Packet construction

1. Wrote the 1,422-line candidate specification.
2. Defined a fake-adapter descriptor and exhaustive minimum absence table in PJ-S/0.
3. Generated 44 positive vectors and 20 adversarial vectors.
4. Added 12 planted mutants.
5. Authored an independent validator that does not import the generator and implements its own PJ-S/0 parser and semantic checks.
6. Added 10 deterministic fake-adapter scripts, including W1–W4.
7. Ran the vector validator: `64/64 PASS`.
8. Ran the planted mutation suite: `12/12 KILLED`.
9. Ran fake-adapter script smoke replay: `10/10 PASS` with stable transcript digests.
10. Generated the L17 route audit, identity timing, acknowledgment, and crash-window matrices.

## Important standing boundary

The packet demonstrates internal coherence, distinct generator/validator source paths, executable negative controls, and deterministic script replay. It does **not** prove:

- an independently seeded Common Lisp implementation conforms;
- a live provider adapter conforms;
- provider self-reports are true;
- provider billing has settled;
- the seventy-six Language-A kimi envelopes occupy one factual projection class.

Those claims remain outside this packet.
