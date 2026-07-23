# HYPOTHESIS — de-praemissis (Slice /1 founding regression specimen)

*STRUCTOR (CC seat, Opus 4.8), 2026-07-23. Governed by
LANGUAGE-SLICE-1-CHARTER.md §11 + CHARTER-DELTA-1.md (delta + Errata supersede
the charter). Slice /0 and slice1.lisp are frozen dependencies — this packet
adds no substrate.*

## The reason this specimen exists (the S3 finding)

In Stranger /1, an opaque `(:artifact-admissible …)` token let a program obtain a
VERIFIED admissibility judgment from digest + signature evidence **while
signer-recognition was never represented anywhere**. The judgment "passed" because
nothing in the machine required recognition to exist — it was a premise that lived
only in a programmer's intent. That is the S3 species: an omitted premise that is
mechanically invisible.

## Hypothesis (falsifiable)

**When a judgment schema DECLARES the anatomy of a conclusion — its required
premises as structured propositions — then a conclusion reached with a premise
omitted, mismatched, refuted, inaccessible, or bound to the wrong
receiver/purpose/artifact is mechanically REFUSABLE: the refusal is visible in a
derivation receipt before any grant, and the grant, when it comes, is a real
Slice /0 promotion keyed to the derivation rather than to opaque content.**

Concretely, for the schema `:artifact-admissibility` v1 with conclusion
`(:predicate :artifact-admissible (:artifact ?a) (:receiver ?r) (:purpose ?p))`
and required premises `digest-matches · signature-valid ·
receiver-recognizes-signer · provenance-admissible`:

1. no proper subset of the premises grants the conclusion (behaviors 1–4);
2. a premise bound to the wrong receiver / purpose / artifact is `:mismatched`,
   with the conflicting role NAMED, never silently accepted (behaviors 5–7);
3. `:missing` ≠ `:inaccessible` ≠ `:refuted` — a present-but-unreachable support
   is residue, a refuted premise keeps its counter-evidence, and neither collapses
   to "false" (behaviors 8–9);
4. only full coherent discharge grants, and the grant is a genuine `:verified`
   Slice /0 judgment-record (behavior 10);
5. `why` names every premise, satisfied and unsatisfied alike (behavior 11);
6. the conclusion does not cross to a second receiver by copy — reconstruction
   requires a target-side `derive` over target-lawful premises, carrying a
   distinct receipt identity (behavior 12).

**And the contrast that makes it a regression test:** the same domain, collapsed
back to one opaque proposition + a generic content procedure (the ABLATION),
REPRODUCES S3 — VERIFIED admissibility from digest + signature with recognition
never represented. Declared anatomy is the difference between the two, not the
presence of evidence.

## What would REFUSE the hypothesis

- Any of behaviors 1–9 or 11 returning `:granted`; or behavior 10 / behavior-12
  target-grant returning `:refused`.
- A `:missing` premise silently converting to a granted conclusion, or a
  `:missing`/`:inaccessible` premise being scored as `:refuted` (false), or a
  wrong-role support being accepted rather than `:mismatched`.
- The ABLATION *refusing* (i.e. failing to reproduce S3) — that would mean the
  contrast is unproven and the specimen shows nothing about anatomy.
- The BASELINE's straight-line variant being unable to silently skip recognition
  — that would mean plain CL already enforces what Slice /1 enforces, and the
  slice adds nothing.

(The pre-registered per-behavior dispositions and receipt contents are frozen in
EXPECTED-FAILURES.md, written before the first run.)

## Run commands

```sh
cd experiments/latent-lisp/mneme/language-slice-1/de-praemissis
sbcl --non-interactive --load SPECIMEN.lisp    # ⇒ "12/12 behaviors demonstrated", exit 0
sbcl --non-interactive --load ABLATION.lisp    # ⇒ S3 reproduced (VERIFIED), exit 0
sbcl --non-interactive --load BASELINE.lisp    # ⇒ convention-vs-enforcement gap, exit 0
```

Regression guards (must stay green — nothing in this packet edits the substrate):

```sh
cd ..            && sbcl --non-interactive --load slice1-selftest.lisp   # 31 passed, 0 failed
cd ../language-slice-0 && sbcl --non-interactive --load SMOKE.lisp       # 6 ok, 0 failed
```

Front-door discipline: SPECIMEN and ABLATION use only single-colon public
surfaces of Slice /0, Slice /1, and kernel0 — zero internal-symbol
(double-colon) access in the directory (grep-verified). The actual outputs are in
RUN-RECEIPT.txt.
