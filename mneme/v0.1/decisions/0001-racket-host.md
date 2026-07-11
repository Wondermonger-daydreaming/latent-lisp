# ADR-0001: Host language = Racket

status: PROPOSED (not accepted — a Fable owes the SBCL counter-memo first)
date: 2026-07-10

## Decision (proposed)
Build Gate-1 tooling (`lp inspect/bindings/expand/claims/effects`, `lp fmt`)
over Racket: #lang machinery, syntax objects with source spans, separate
read/expand layers, continuation prompts sufficient to prototype restarts.

## Alternatives
- SBCL/Common Lisp: native condition/restart semantics, real images. Wins if
  the first thesis is agentic recovery rather than AI-readable structure.
- No language at all: pure tooling over existing Lisp (this is in fact
  Gate 1 regardless of host).

## Consequences
- CL condition texture must be reimplemented (wanted anyway: our conditions
  are structured data addressed to models, not CL conditions).
- Revisit trigger: if E0 no-gos the reading thesis and the project pivots to
  the authority plane, the SBCL case strengthens materially.
