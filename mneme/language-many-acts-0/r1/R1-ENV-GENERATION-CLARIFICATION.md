# R1 ENVIRONMENT-GENERATION CLARIFICATION (owner's addendum, verbatim, 2026-08-10)

> Do not use MA0-ENVIRONMENT-STORE-ID, journal-store-store-id, root pathname,
> or equality of declared environment data as the installation identity.
>
> Independent store instances can carry equal derived store-ID strings. Mint a
> fresh unforgeable image-local installation/generation token when an environment
> is installed; retain it privately in that environment and compare it with the
> currently installed generation before the first constituent act. The token is
> runtime state, not serializable source, evidence, authority, or a public
> semantic identity.
>
> A stale-generation refusal must occur before journal mutation, world mutation,
> capability activity, or constituent-act construction.

## Compliance record (chair-verified against source, ma0-environment.lisp)

The R1 §5 repair as built satisfies this by construction: installation identity is
`*ma0-environment-generation*`, a monotonic image-local counter advanced only on
successful construction (tooth-guarded), retained privately in the environment
object, compared by token equality in `%ma0-check-environment-current` from BOTH
`ma0-run-program` and `ma0-complete-act` before any consequential step. Store-id,
root, and declared-data equality play no identity role; the refusal names the stale
object's own store-id as an object label only, with an explicit code comment that
the id cannot draw a store distinction (content-derived) and the message does not
claim one. The auditor-observed `ENV-IDS-DISTINCT=NIL` fact was independently noted
inside the repair's own documentation before this clarification arrived (same-root
caveat: the repair hand was chair-prompted toward a generation counter; the
store-id-ambiguity observation, however, appears in its code comment unprompted).

Environmental note from the owner's fresh-container audit, recorded: 2 floor gates
need historical commit `431fee16`, gate 72 needs Python `jsonschema` — environmental
incompleteness in that container, not a Lisp+ regression; 74/74 remaining gates
passed there; the parcel's authenticated transcript records the original 77/77/0.
