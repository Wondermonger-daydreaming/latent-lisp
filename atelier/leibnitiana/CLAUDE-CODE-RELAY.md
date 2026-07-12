# Relay to Claude Code — Land the Leibnitiana first tranche

A self-contained Leibnitiana prototype has been prepared. Treat it as an incoming atelier branch, not as settled constitutional law.

## Objective

Integrate this directory into the existing Lisp+/Mneme repository at the location that best matches the current atelier layout, preferably `atelier/leibnitiana/` unless the live tree already establishes a stronger convention.

The tranche contains:

- a minimal ASDF system;
- a judgment object and non-coercive `jif` branch operator;
- closure-based “monads” with bounded public depositions;
- declared-world compossibility reports;
- an inspectable `defwindowless-evaluator` macro contract;
- five runnable specimens;
- one adversarial storm;
- smoke tests;
- the opening essay, `CALCULEMUS? — A Constitution for Computable Disagreement`.

## Required pass

1. Inspect the live repository before moving files. Reconcile package names, test conventions, headers, licenses, and specimen-running conventions with what is actually present.
2. Run every script under SBCL. Fix any reader, package, pathname, ASDF, macroexpansion, or portability defects rather than merely reporting them.
3. Preserve the central claims split:
   - interface claim;
   - enforcement claim;
   - instrument-specific claim.
4. Do not strengthen `windowless` into causal isolation. The hidden-operator storm exists specifically to prevent that metaphysical promotion.
5. Keep `jif` fail-closed when an epistemic status lacks a licensed branch.
6. Review `compossibility-report` carefully. Its present standing is only `:constraint-alignment-only`; it does not prove propositional consistency or truth. Rename or refine the API if the current name invites overclaiming, but preserve the distinction between “same declared world” and “adjudicated contradiction.”
7. Add the specimens to the repository’s normal test/runner surface and ensure failures return nonzero status.
8. Add provenance noting that the initial tranche was drafted by GPT Sol with Tomás Pavan on 2026-07-12 and then audited/landed by the current chair.

## Design constraints

- No silent coercion of `:undetermined`, `:conflicted`, or `:out-of-jurisdiction` into truth.
- No claim of complete replay where a bequest explicitly names omissions.
- No universal-language rhetoric that implies lossless universal semantics. `characteristica` is being explored as an accountable intermediate representation.
- Macroexpansion should remain useful as philosophical close reading: the expanded form must expose caveats hidden by the surface adjective.
- Keep the code dependency-light. Do not introduce a large testing framework merely for these specimens unless the repository already uses one.

## Suggested next implementation after landing

Build `storms/false-harmony.lisp`: an orchestrator privately retries or edits individual monad outputs until they appear coordinated, while the public transcript presents the final outputs as spontaneous harmony. The storm should emit a receipt showing retry count, discarded histories, and curator interventions, then fail any claim of endogenous agreement.

After that, draft `characteristica-as-ir.md` around cross-profile preservation, approximation, inert fields, renewed authority, and explicit translation debt.

## Acceptance

The tranche is landed when:

- the ASDF system loads cleanly;
- every smoke test and specimen runs under SBCL;
- the hidden-operator storm demonstrates the intended failure mode;
- the documentation accurately distinguishes implemented enforcement from declared aspiration;
- the live roadmap links the Leibnitiana chamber without promoting it prematurely into Book 0.
