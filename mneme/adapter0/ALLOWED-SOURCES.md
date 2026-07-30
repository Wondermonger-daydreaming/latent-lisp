# adapter0 — THE EXPOSURE FENCE (independent-seeding boundary)

**Committed BEFORE any implementation coding began** — this commit's
timestamp is the proof of ordering (the journal0 precedent, `1fc1f305`;
unlike the capability lanes' close-written fences, this one is sealed
first). At the time of this commit, `mneme/adapter0/` contains exactly
this file. The lane: the first independently seeded Common Lisp
deterministic fake adapter governed by the adopted Adapter Protocol /0
reissue. Owner charge of 2026-07-30 (filed with
`mneme/RULING-capability2-acceptance-2026-07-30.md`).

> A fake world is useful only when it can reproduce every ambiguity the
> real membrane may lawfully leave unresolved, without inventing certainty
> merely because the script is deterministic.

## The rule (owner's charge, operative form)

The Common Lisp implementation is derived from the NORMATIVE CONTRACT and
frozen fixtures alone. Frozen scripts and expected results are TESTS; the
CL state machine must be independently derived. **Before the first
complete Common Lisp transcript is sealed** (its SHA-256 committed to this
tree), no hand on this lane reads, translates, unpacks, or summarizes any
Class B artifact. After the seal, Class B may be consulted ONLY for
differential diagnosis, and **every post-exposure correction must be
identified** in the BUILD-REPORT and the RETURN.

## Class A — readable before the seal

- The adopted AP0 reissue specification
  (`mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`)
  including all appendices; the adoption record + riders
  (`AP0-ADOPTION-2026-07-18.md`); adjudication/verification/concordance/
  plan documents; `AP0-INDEPENDENCE-NOTE.md`; `AP0-MUTATION-SCORECARD.md`;
  the hostile-pass FINDINGS documents (prose findings only, not the attack
  harness code); `matrices/*.md` (3-line adjudication stubs — the
  normative row tables are the spec's own appendices A–F and sections).
- `AP0-FIXTURE-REGISTRY.sexp` (counts DERIVED live from its `entries`
  fold, never hardcoded); `descriptors/*.pjs` (both canonical descriptors
  + the absence-mapping table); `scripts/*.pjs` (the ten deterministic
  fake scripts — data fixtures); `vectors/positive/*`,
  `vectors/adversarial/*`, `vectors/mutants/*` (vector INPUTS and their
  expected PUBLIC dispositions).
- Kernel /0 spec (esp. §3.3/§3.5, §8, §9, §10, §14, §15, §16, §18, §22–25),
  PJ0 spec + Erratum 0.1 (esp. §2, §5, §9, §10, §12–16), Architecture 0.1,
  CONSTITUTION.md, the capability2 acceptance ruling.
- Public predecessor APIs and their docs: `mneme/journal0/` (package +
  README/RETURN), `mneme/capability0/`, `mneme/capability1/`,
  `mneme/capability2/`, `mneme/kernel0/package.lisp` + README, the CD0
  spec (`mneme/spec/CANONICAL-DATUM-SPEC.md`) and `#:lisp-plus-cd0`
  public surface.
- This lane's own files as they are created.

## Class B — FORBIDDEN before the seal (paths exact; content untouched by every hand on this lane, including the recon that assembled this list)

Reference implementations, authoring scripts, and reference-behavior
transcripts under `mneme/architecture/adapter-protocol-0/`:

1. `lisp-plus-adapter-protocol-0-reissue/tools/generate_ap0_vectors.py`
2. `lisp-plus-adapter-protocol-0-reissue/tools/validate_ap0_vectors.py`
3. `lisp-plus-adapter-protocol-0-reissue/tools/validate_ap0_kernel_joint.py`
4. `lisp-plus-adapter-protocol-0-reissue/tools/run_fake_adapter.py`
5. `lisp-plus-adapter-protocol-0-reissue/tools/run_mutation_suite.py`
6. `lisp-plus-adapter-protocol-0-reissue/tools/run_adjudicated_regressions.py`
7. `lisp-plus-adapter-protocol-0/tools/generate_ap0_packet.py`
8. `lisp-plus-adapter-protocol-0/tools/validate_ap0_vectors.py`
9. `lisp-plus-adapter-protocol-0/tools/run_fake_adapter.py`
10. `lisp-plus-adapter-protocol-0/tools/run_mutation_suite.py`
11. `hostile-pass/attacks-breakpoint/attack_breakpoint.py`
12. `hostile-pass/attacks-undertow/probe_custody.py`
13. `reissue-verification/ap0_reissue_hostile_regression.py`
14. `lisp-plus-adapter-protocol-0-reissue/transcripts/FAKE-ADAPTER-REPLAY.txt`
15. `lisp-plus-adapter-protocol-0-reissue/transcripts/AP0-VECTOR-VALIDATION.txt`
16. `lisp-plus-adapter-protocol-0-reissue/transcripts/AP0-KERNEL-JOINT.txt`
17. `lisp-plus-adapter-protocol-0-reissue/transcripts/MUTATION-SUITE.txt`
18. `lisp-plus-adapter-protocol-0-reissue/transcripts/ADJUDICATED-REGRESSIONS.txt`
19. `lisp-plus-adapter-protocol-0/transcripts/FAKE-ADAPTER-SMOKE.txt`
20. `lisp-plus-adapter-protocol-0/transcripts/AP0-VECTOR-VALIDATION.txt`
21. `lisp-plus-adapter-protocol-0/transcripts/MUTATION-SUITE.txt`
22. `reissue-verification/hostile-regression-rerun.out`
23. `hostile-pass/attacks-breakpoint/attack-output.txt`
24. `hostile-pass/attacks-undertow/probe_custody.out`
25. `lisp-plus-adapter-protocol-0-reissue/AP0-REFERENCE-TRANSCRIPT.md`
26. `lisp-plus-adapter-protocol-0-reissue/ADAPTER-PROTOCOL-0-AUTHORING-RECEIPT.md`
27. `lisp-plus-adapter-protocol-0/ADAPTER-PROTOCOL-0-AUTHORING-RECEIPT.md`
28. `LISP-PLUS-ADAPTER-PROTOCOL-0-REISSUE-2026-07-19.zip` (contains the above — no unpacking)
29. `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC-2026-07-18.zip` (same)

Adjacent serializer-revealing tools, fenced by the narrower reading
(lawful substitutes exist and are Class A):

30. `mneme/architecture/process-journal-0/tools/pj0_vector_tool.py`
    (substitute: `#:lisp-plus-journal0` public exports)
31. `mneme/architecture/process-journal-0/tools/pj0_kill9_harness.py`
32. `mneme/canonical-datum/generator/` (entire directory)
    (substitute: the CD0 spec + `#:lisp-plus-cd0`)
33. `mneme/canonical-datum/tools/` (entire directory)

## The seal protocol

1. The builder implements from Class A alone and runs its full gate
   (selftest, registry-derived vector gate, mutation gate, script
   determinism gate, joint gate).
2. The FIRST COMPLETE transcript set — green or not — is hashed
   (SHA-256, recorded in `SEAL-RECORD.md`) and the chair commits it.
   **The seal is of the honest state, including failures.**
3. Only after that commit may Class B be consulted, and only for
   differential diagnosis of named failures; every post-exposure
   correction is listed in `SEAL-RECORD.md` (finding → Class B file
   consulted → correction made), and the RETURN carries the same list.
4. If the gate is fully green at the seal, the lane records: "no Class B
   artifact was ever opened; the seal stands unbroken."

Recon provenance: the fence map was assembled by INDAGATRIX-IV
(2026-07-30), which opened Class B paths only far enough to identify
them (path, language) and reported no content, so the fence holds through
the recon itself.

*— Claude Fable 5 (chair), 2026-07-30, before any adapter0 code exists*
