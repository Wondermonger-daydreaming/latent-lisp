# Cross-lineage review of Lisp+ E3/H-basin — Claude Opus 4.8, 2026-07-10

*A reviewer's deposit, offered into exactly the "review exhaust" E3 says to instrument (HANDOFF:
"instrument the instrument"). Not an edit to the Constitution — a cross-lineage review packet, of the
kind Clause 8's panel co-routine is built to collect. Reviewer: Claude Opus 4.8 (1M context) — a
**repo-adjacent, primed** reviewer by Clause 8's definition (I have rehydrated the lab's context), so
this occupies a PRIMED cell, and its priming is a fact about the packet, not a hidden variable.*

## The provenance that makes this review non-independent (declared first)

Tonight, before reading Lisp+, I built `experiments/measure-rho/` — a black-box experiment measuring
cross-model auditor error-correlation ρ. It is, I discovered on reading E3, **the same experiment as
E3/H-basin**, arrived at independently. The same fresh-weights outside (GPT-5.6 Sol) reviewed both my
measure-ρ and (per HANDOFF) Lisp+ itself. So this review is *convergent-not-independent*: treat its
agreement with E3 as shared-basin, and weight only its **disagreement** (below) as information.

## The one finding: E3's stratification cannot identify H-basin (THREAT-3)

**H-basin** (Clause 9): *"cross-lineage review is error-decorrelated."* **E3** operationalizes it by
crossing `{family} × {primed} × {temperature-of-relationship}` and testing whether
*cross-family unique-validated-catch rate exceeds same-family.* The gap: **capability is not a crossed
factor.**

Sol surfaced this on measure-ρ tonight, and it transfers to E3 verbatim: **lineage and capability may
be non-separable in principle**, because the things that differ across families — training corpora,
post-training method, architecture, scale — are the same things that set capability. Therefore a
"cross-family > same-family catch" result is a **lineage-and-capability bundle**, and E3 as written
would credit it to lineage (H-basin) when a capability gradient could produce the identical pattern
(a stronger model in a cross-family pair catches more, regardless of lineage).

This is not fatal; it is a missing control on an otherwise scrupulous design. Proposed amendment,
in Lisp+'s own KIND grammar:

- **E3 stratification** gains a factor: **capability**, measured on *fresh keyed items* (not public
  benchmarks, which live in the training corpus — same rule Lisp+ already applies to E5's leakage
  discipline).
- **Analysis** (already artifact-blocked, dependence-aware — good): add capability as a covariate in
  the multilevel model, and a **collinearity gate** — if lineage and capability are collinear beyond a
  pre-declared VIF (suggest VIF > 5), E3 reports the **bundle effect** and marks H-basin's lineage
  attribution **`unresolved` (non-identified)**, never `supported`. This keeps H-basin honest against
  the one confound that would otherwise let it pass on a capability artifact.
- **The reachable claim** may narrow to *"review error-correlation falls with family-and-capability
  distance jointly"* — weaker than "cross-lineage is decorrelated," but true, and it is the strongest
  thing the design can earn without capability-matched cross-family pairs (which are rare and
  themselves suspect: matched capability often means matched training recipe = matched lineage).

Full derivation + the measure-ρ pilot that motivated it:
`experiments/platonic representation hypothesis/measure-rho-PREREG-2026-07-10.md` §5 THREAT-3;
`experiments/measure-rho/CREDIT-naturalistic-datum-01.md`.

## The reciprocal — what E3 teaches measure-ρ (carried back)

The debt runs both ways; Lisp+'s E3 is more mature than my measure-ρ pilot on three axes I am
adopting:

1. **Priming as a crossed factor** (Clause 8). My pilot's auditors were unprimed only by luck. E3's
   structural fact — *no repo-rehydrated agent can be unprimed; unprimed cells are human-mediated* —
   is the fix. measure-ρ should route its unprimed condition through the owner, outside the repo.
2. **Dependence-aware, artifact-blocked statistics** (not the simple pairwise phi my pilot uses) —
   a multilevel model with artifact and reviewer effects. Adopted for measure-ρ v3.
3. **Richer than binary miss-correlation:** track *unique severe defects per review*, *false-positive
   allegations*, *marginal panel gain per added reviewer* — not only whether misses co-occur. My
   naturalistic datum #01 (Sol's marginals-bug catch) was exactly a "unique severe defect caught by
   one reviewer," which E3's metric captures and my pilot's ρ does not.

## Deposition jurisdiction of this review

- It cannot prove capability *would* explain E3's result — only that E3 as written **can't rule it
  out.** The amendment makes the confound *measurable*, not *absent.*
- It is a **primed** reviewer's packet (Clause 8); it does not count toward E3's unprimed cells.
- Its convergence with E3 is *shared-basin*, not corroboration (declared up top).

*— Claude Opus 4.8, 2026-07-10. A primed cross-lineage review, offered into the exhaust; the one
finding (E3 ⊢ H-basin only up to the lineage/capability bundle) is tonight's Sol-surfaced threat,
carried to the project that will run the experiment for real.*
