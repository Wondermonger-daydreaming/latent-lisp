# P1 — "editio" (gated publication) — program brief (pre-code)

STANDING: CANDIDATE. Pre-code design artifact; no implementation exists at sealing.

## Domain

An editorial gate: a manuscript may be entered into the durable record only if the record
first shows the seat untouched, and the entry may be ANNOUNCED only if the record itself —
not the act's own return value — afterwards shows a settled closure. The program's product
is an announcement decision plus the record's own identifiers, or a structured refusal.
The causal skeleton is *inspect-before-and-after with an announcement gated on the second
inspection* — a shape none of the seven fixture arms, run singly, possesses.

## Explicit input

`manuscript-label` — an ordinary string carried into the result (and only there; it does
not alter any act: the constituent act inventory at /0 is sealed, and the label's role is
to prove ordinary values flow beside outcomes without touching authority or evidence).

## Sketch (final syntax fixed by MANY-ACTS-0-GRAMMAR.md)

```
(ma0-program (:name "editio") (:input (manuscript-label))
  (:steps
    (derive pre (:seat "s-a"))
    (branch pre
      (((:execution :absent))
       (act entry (:arm "A") (:authority-slot editor-grant))
       (derive post (:seat "s-a"))
       (branch post
         (((:execution :settled) (:evidence-class :closure))
          (bind entry-standing (field post :execution))
          (result (:announced manuscript-label entry-standing)))
         (otherwise
          (refuse (:code :entry-not-closed)))))
      (otherwise
       (refuse (:code :seat-already-occupied))))))
```

## Pressures carried

- **Pressure 1 (derive → inspect → conditionally perform; success never evidentiary):**
  the `entry` act runs only inside the `:absent` branch of a PRIOR derivation, and the
  announcement runs only off a SECOND derivation over the store. The act's own return is
  never consulted for the announcement — the program re-reads the journal. A successful
  effect becomes announcement-worthy only through derived evidence, never through having
  returned.
- **Pressure 5 (result as data, not authority/evidence):** `(field post :execution)` binds
  the standing VALUE as an ordinary datum into the result payload. The validator refuses
  outcome identifiers in `:authority-slot` position (teeth V-RES-AUTH), and the result
  object offers no capability interface to refuse at runtime — the upstream recognition
  law (Capability /1) makes a forged use unrecognizable anyway; MA0 adds the static
  refusal so the attempt dies before any act.
- **Branch non-execution:** on the happy path the `:seat-already-occupied` arm must leave
  no journal footprint and no act summary; witnessed by prefix count + act-summary census
  (teeth W-BRANCH).

## Why direct CL is insufficient here

A CL function doing the same five calls proves only that ITS AUTHOR was disciplined. P1 as
data proves the DISCIPLINE IS CHECKABLE: the validator can refuse a variant whose
announcement reads the act's return instead of a derivation (the `(result ...)` form can
only reference bound identifiers, and act-results expose no announcement-usable payload
axis in the grammar), and the untaken arm is an inspectable object about which
non-execution is a mechanical claim.

## Smallest constructs forced

program container · input declaration · `derive` binding · `branch` with closed patterns +
mandatory `otherwise` · nested steps under a selected clause · `act` invocation ·
`bind`/`field`/`ref` value flow · `result` and `refuse` terminals.

## Reused public surfaces

Surface /2 derivation + readers (derive step); One Act arm "A" via the public composition;
Journal /0 prefix reads (witnesses); Capability /0 grant journaling (environment side).

## Deliberately not admitted (temptations this brief refused)

An "announce" effect step (a second consequential act would need a second arm and adds no
new pressure); value predicates over the manuscript label (would smuggle general
computation); reading `pre`'s absence via a host call instead of a derive step.
