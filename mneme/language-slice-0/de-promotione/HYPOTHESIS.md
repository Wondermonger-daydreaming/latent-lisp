# DE-PROMOTIONE — specimen hypothesis (WORK-ORDER-0 admission rule, R4)

**First official Slice /0 specimen.** Domain: an honest test runner.
Governed by `../LANGUAGE-SLICE-0-CHARTER.md`; substrate `../slice0.lisp`.

## 1. Linguistic hypothesis

> Making evidential promotion an explicit checked language act (`raise`)
> prevents execution evidence from silently becoming verification standing.

The seven domain facts are **distinct propositions**, not rungs of one
standing (charter §2): process launched · process exited · suite completed ·
output parsed · tests reported passing · expected test set matched · release
judgment. Each requires its own support; "release verified" is a judgment an
authorized `:semantic` procedure grants only when the right support stands in
the right relation to the right proposition.

## 2. Observable misuse / failure mode

The program attempts to raise "tests pass" or "release verified" using:

- exit status alone (a warrant for *exited*, offered for *release*);
- partial output (suite killed mid-way, transcript unparsed to completion);
- testimony about a run ("ran it on my machine, all green");
- a transcript for the wrong suite (expected set unmatched);
- a structural procedure lacking semantic authority.

In idiomatic CL (see `BASELINE.lisp`) each of these is one ordinary `setf` —
legal, silent, indistinguishable from every other `setf`.

## 3. Ablation (one mechanism)

`ABLATION.lisp` replaces the checked `raise` with **direct standing
assignment through an ordinary constructor keyword** (an exported
`claim*` accepting `:judgment`). Everything else — the witness objects, the
procedures, the receipts — is preserved. If the hypothesis is right, this one
change restores every laundering path the specimen catches.

## 4. Comparative baseline

`BASELINE.lisp`: a competent, good-faith idiomatic CL implementation of the
same domain (written blind to the substrate by a separate hand — FABER-CL,
Opus 4.8). The six WORK-ORDER-0 questions are answered against it in
`EXPECTED-FAILURES.md` §comparison.

## 5. Official tests (charter-mandated, all in `SPECIMEN.lisp`)

1. testimony that execution occurred does not create direct execution support;
2. testimony supports "S testified that P," not automatically P;
3. a warrant for Q cannot promote P;
4. a structural procedure cannot license semantic verification;
5. direct standing mutation is unavailable/rejected through the public surface;
6. a refusal identifies the exact missing relation;
7. a lawful restart can preserve assertion, seek matching support, construct
   an attribution claim, or defer;
8. refuting support preserves both the original assertion event and the
   refuting judgment.

— Claude Fable 5 (CC seat), 2026-07-22
