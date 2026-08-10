# P2 — "custodia" (revocation-aware duty handoff) — program brief (pre-code)

STANDING: CANDIDATE. Pre-code design artifact; no implementation exists at sealing.

## Domain

A custody chain under failing conditions: a first duty is discharged cleanly; a second
duty ends in an unresolved uncertainty, and the chain must HALT rather than act on it; a
third duty's authority has been revoked between acts, and the chain must refuse it without
disturbing what the first two acts durably recorded. The program's product is a structured
refusal that NAMES which duty stopped the chain and carries the intact history's
identifiers. The causal skeleton is *sequential duties with two distinct lawful stopping
modes* — again a shape no single fixture arm possesses.

## Explicit input

`custodian` — an ordinary string naming the duty-holder, carried into every refusal detail
(ordinary value flowing beside outcomes; never touching authority).

## Sketch (final syntax fixed by MANY-ACTS-0-GRAMMAR.md)

```
(ma0-program (:name "custodia") (:input (custodian evidence-seat))
  (:steps
    (act duty-1 (:arm "A")   (:authority-slot custody-grant))
    (act duty-2 (:arm "C-i") (:authority-slot custody-grant))
    (derive duty-2-evidence (:seat (ref evidence-seat)))
    (branch duty-2-evidence
      (((:execution :uncertain-unresolved) (:evidence-class :uncertain))
       (refuse (:code :uncertainty-halts-chain) (ref custodian)))
      (((:execution :settled))
       (act duty-3 (:arm "B-R") (:authority-slot custody-grant))
       (result (:chain-complete (ref custodian))))
      (otherwise
       (refuse (:code :unexpected-evidence) (ref custodian))))))
```

Two runs are exercised under declared fixture worlds:
- **Run α (the uncertainty path, the primary):** duty-2's arm C-i ends
  `:uncertain-unresolved`; the program refuses; duty-3 NEVER runs (witnessed: no F1 for
  seat "s-b-r" in the prefix; no third act summary). Blind replay is inexpressible (no
  retry construct) and independently refused by the adopted lane (seat consumption +
  act-identity law) — both facts witnessed by teeth, neither claimed as MA0's invention.
- **Run β (the revocation path, driven by a declared environment variant):** the branch's
  `:settled` clause is exercised so duty-3's B-R attempt runs and is REFUSED by the
  adopted lane at L3b (revocation journaled between acts; mint refused; unpaired F1 by
  law). The program converts the act-level refusal into a structured program refusal;
  duty-1's and duty-2's frames are byte-identically present before and after (witnessed by
  prefix digests). NOTE: at /0 the C-i arm cannot be made to end `:settled`; run β's
  branch selection is achieved by an environment-declared derive-seat variant (the seat
  whose evidence is read is an environment binding, not program-hardcoded — the program
  text is IDENTICAL across α and β; only the environment differs). This is stated plainly:
  β demonstrates the revocation pressure under a declared fixture environment, not a
  naturally-settled C-i.

## Pressures carried

- **Pressure 2 (uncertainty → refuse dependent action, no blind replay):** run α. The
  dependent consequential act is the untaken arm; the halt is a structured refusal naming
  the stopping duty. The lawful continuation (Capability /2 reconciliation) exists OUTSIDE
  the program and is deliberately not invocable as program syntax.
- **Pressure 3 (authority revoked between acts; later act refuses; earlier history
  unerased):** run β. Revocation lands in the store between duty-2 and duty-3 (environment
  side); the adopted lane refuses the mint; MA0 proves the earlier frames unchanged.
- Also exercises: multi-act sequencing, act-result vs derived-evidence distinction (the
  branch reads the DERIVED evidence, not duty-2's return), ordinary-value carrying into
  refusals.

## Why direct CL is insufficient here

The two stopping modes are the whole content. In host CL they are `cond` branches whose
absence of a third-act call is invisible to any checker. As MA0 data, "duty-3 does not
execute after uncertainty" is a mechanical property of a program object under a validator
that admits no retry, plus a journal witness that no third F1 exists — law, not diligence.

## Smallest constructs forced (beyond P1's)

Multiple sequential `act` steps · act-result bindings distinct from derived-evidence
bindings · `refuse` with a carried detail value · environment-supplied derive-seat
indirection (the seat named in a derive step resolves through the environment's declared
seat map — forced by run β's need for one program text under two declared worlds).

## Reused public surfaces

One Act arms A, C-i, B-R via the public composition; Capability /0 `make-grant-event` /
revocation events (environment side); Surface /2 derivation; Journal /0 prefix digests as
the no-erasure witness.

## Deliberately not admitted

A `reconcile` step (adjudication is not the program's office at /0); a `when-refused`
handler syntax (act refusal surfaces as the act-result's structured shape, branchable, not
as caught exceptions); any program-text difference between runs α and β.
