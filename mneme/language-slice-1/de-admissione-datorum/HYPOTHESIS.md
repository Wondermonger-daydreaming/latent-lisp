# HYPOTHESIS — de-admissione-datorum (Slice /1 cross-domain transfer)

*2026-07-23, STRUCTOR-II (CC seat, Opus 4.8). The founding specimen
(`../de-praemissis/`) reconstructed the supply-chain S3 world. This specimen tests
whether the SAME frozen substrate (`slice1.lisp`, Slice /0, kernel0 — all
byte-frozen dependencies) closes the flattening species in a wholly different
domain: **dataset admissibility for scientific analysis**. Nothing in the
substrate is modified; the only new thing is a schema and a program that walks it.*

---

## The transfer hypothesis

The founding specimen proved that *declared anatomy* makes a missing, mismatched,
refuted, inaccessible, or wrong-receiver premise mechanically visible in a
derivation receipt before an artifact-admissibility conclusion can be granted.
The charter (§11) reserved a cross-domain test precisely to prevent Slice /1 from
becoming "supply-chain policy in syntax."

**H1 (transfer).** The anatomy discipline is domain-neutral. A judgment schema in
a scientific-data domain — whose conclusion is *"dataset D is admissible for
analysis purpose P under receiver R"* — will exhibit the same five closures as the
supply-chain specimen, distinguishing five collapsible layers that a flattened
program silently conflates:

> **schema-valid ≠ measurement-valid ≠ population-suitable ≠ permitted-for-purpose
> ≠ admissible-for-analysis.**

Concretely: a dataset that conforms to its schema and has low missingness is **not
thereby** measurement-valid (the instrument that produced it may be uncalibrated);
a measurement-valid dataset is **not thereby** population-suitable (fit for
*descriptive* summary is not fit for *causal* inference); a population-suitable
dataset is **not thereby** permitted for that purpose under that receiver's
consent/provenance regime; and none of those, singly or together, is
**admissibility** — which is exactly the conjunction, derived, receipted, and
raised through the frozen Slice /0 `raise`.

**H1 is refuted** if any premise omission, cross-instrument/cross-purpose/
cross-receiver/cross-dataset mismatch, refutation, or inaccessibility fails to
appear in the receipt as its charter-named disposition — or if any such condition
nonetheless yields `:granted`.

## The measurement-validity anatomy (honest note on instrument binding)

The critical new distinction this domain adds over the supply-chain world is
**measurement-validity**, and it needs an *instrument* that is a schema-local (not
a conclusion argument — the conclusion speaks of dataset/receiver/purpose, never of
an instrument). A calibration certificate "for instrument-a" can only be shown to
*fail to discharge* a premise "bound to instrument-b" if the instrument is already
bound before the calibration premise is assessed. Within the bounded two-class
model (CHARTER-DELTA Δ1) a schema-local is bound only by an earlier premise's
support. The specimen therefore declares a `:measured-by (dataset, instrument)`
premise (genuine anatomy: a dataset must declare what measured it before one can
ask whether that instrument was calibrated) ordered BEFORE `:calibration-valid`,
and the errata-3 premise-by-premise threading carries the bound `?instrument`
forward. This is disclosed as a *construction*, not smuggled as a given.

## The multiplicity question (stated neutrally; both outcomes publishable)

The calibration premise carries a second schema-local — `?certificate` — so that a
premise can be discharged by *more than one* sufficient support. This exposes a
question the founding specimen never posed:

> **When a conclusion has more than one lawful anatomy — two independently
> sufficient derivations of the same ground conclusion — does the current
> semantics PRESERVE the plurality, or REFUSE it as doubt?**

`MULTIPLICITY.lisp` runs this as a genuine experiment against the frozen substrate.
Two outcomes are declared publishable IN ADVANCE:

- **Outcome R (refusal).** Two sufficient certificates land `:ambiguous` and the
  derivation refuses. This is what CHARTER-DELTA Errata 3 predicts (a fresh
  schema-local bound to >1 value by surviving candidates is `:ambiguous`
  immediately). If it holds, the finding is that **the current semantics reads
  plurality as doubt** — and the experiment then asks whether that is defensible.
- **Outcome G (grant-with-plurality).** Two sufficient certificates grant, with
  multiple derivation paths preserved. This would **falsify the errata-3-derived
  prediction** and is itself a publishable finding about the substrate.

The experiment additionally asks whether the substrate can *tell apart* two cases
that are linguistically different: (A) two genuinely sufficient, interchangeable
proofs (redundant strength) versus (B) two coherent bindings that imply materially
different authority/provenance with no schema discriminator between them (genuine
under-specification). The prediction — recorded in EXPECTED-FAILURES before any
run — is that the substrate **conflates** them under one undifferentiated
`:ambiguous`. Confirmation is a finding; distinction would falsify the prediction.
No repair is implemented: the finding is the deliverable.

## Falsifiers (summary)

1. Any of specimen behaviors 1–9, 11, 13, 14 yielding `:granted`, or 10/12-grant
   yielding `:refused` ⇒ H1 refuted, nonzero exit.
2. A `:missing` premise silently converting to a granted conclusion, or `:missing`
   treated as `:refuted`, or `:inaccessible` collapsed to `:missing` ⇒ failure.
3. A cross-instrument calibration discharging a bound-to-other-instrument premise
   (behavior 3 granting rather than `:mismatched :instrument`) ⇒ the transfer's
   central new closure has failed.
4. The ablation REFUSING (failing to reproduce the flattened species) ⇒ the
   contrast is unproven.

## Run commands

```sh
cd experiments/latent-lisp/mneme/language-slice-1/de-admissione-datorum
sbcl --non-interactive --load SPECIMEN.lisp        # exits 0 on 14/14
sbcl --non-interactive --load MULTIPLICITY.lisp    # exits 0; the finding IS the success
sbcl --non-interactive --load ABLATION.lisp        # exits 0; reproduces the flattened species
sbcl --non-interactive --load BASELINE.lisp        # exits 0; discipline shown to be mere convention
```

Frozen-tree checks (must all hold at closure): `../slice1-selftest.lisp` 31/0;
`../../language-slice-0/SMOKE.lisp` 6 ok; zero `::` in this directory; the frozen
Slice /0, kernel0, `slice1.lisp`, `slice1-selftest.lisp`, and `../de-praemissis/`
untouched (`git status`).

— STRUCTOR-II, Claude Opus 4.8 (1M context)
