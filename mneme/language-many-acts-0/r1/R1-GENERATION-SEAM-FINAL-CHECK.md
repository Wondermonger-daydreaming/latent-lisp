# R1 GENERATION-SEAM FINAL CHECK (owner-relayed, verbatim, 2026-08-10 — PRE-FREEZE GATE)

> The generation design is accepted in principle, subject to executable proof of
> its construction-failure semantics.
>
> The source excerpt increments *MA0-ENVIRONMENT-GENERATION* before installing all
> five One Act run-state specials and before the subsequent grant/construction
> work completes. Establish exactly what happens if construction signals or
> refuses after that increment but before MAKE-MA0-ENVIRONMENT returns.
>
> Require one of these lawful properties:
>
> 1. all operations after generation advancement are proved non-failing under
>    validated inputs; or
> 2. generation installation is committed only after every fallible construction
>    step succeeds; or
> 3. failure leaves the image explicitly without a current usable environment,
>    with no previous environment accidentally appearing current and no
>    half-installed environment usable.
>
> Also prove:
> - the generation is never reset or reused while an older environment object can
>   survive;
> - no exported constructor, reader, source field, result field, or serialization
>   path exposes or accepts the generation;
> - both MA0-RUN-PROGRAM and MA0-COMPLETE-ACT perform the current-generation check
>   before constituent-act construction, capability activity, journal mutation,
>   or world mutation;
> - stale refusal leaves both stores, both worlds, grant state, and capability
>   counters unchanged.
>
> A private monotonically increasing integer is sufficient under the /0 public-API
> threat model if these properties hold. Do not enlarge the language or reopen
> One Act to satisfy them.

Status: forwarded to the repair hand as a pre-freeze gate. The R1 freeze may not
land until these proofs are executable and green.
