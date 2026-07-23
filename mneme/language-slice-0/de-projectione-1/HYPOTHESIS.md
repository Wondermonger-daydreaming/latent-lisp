# DE-PROJECTIONE Session 1 — specimen hypothesis (WORK-ORDER-0 admission rule, R4)

**Second official Slice /0 specimen.** Built on the settled de-promotione
support/promotion algebra (`../slice0.lisp` + `../slice0-projection.lisp`).
The pre-ratification bench probe (`../de-projectione.lisp`) is inventory
evidence only: its scalar standing model was falsified by its own first run
(F4) and is not used here.

## 1. Linguistic hypothesis

> A claim projected into another receiver context must be reconstructed from
> the support, procedures, authorities, and representations available to that
> receiver; changing the receiver cannot be implemented as editing a label or
> copying the source standing.

## 2. Observable misuse / failure mode

The ordinary implementation:

- copies `:verified` from source to target;
- treats receiver as a principal name rather than an evidentiary position;
- converts testimony into direct evidence;
- lets a warrant for an unredacted proposition support a redacted derivative;
- treats inaccessible evidence as absent;
- collapses several simultaneous projection consequences into one status
  symbol.

Each is one ordinary idiomatic move in plain CL (see `BASELINE.lisp`,
misleading moves i–vi).

## 3. Ablation (one mechanism)

**Primary: copy the source judgment** (`ABLATION.lisp`). The receiver-context
records, store, and views machinery all remain present and accepted as
arguments; only the reconstruction step — receiver-relative re-licensing
through the receiver's own supports, authorities, and procedures — is
removed. All ten specimen distinctions collapse at once, showing they were
carried by that joint and nothing else. (The other candidate ablations —
receiver-slot replacement, flat one-of-six label, receiver as bare name —
each destroy a *symptom* of the same joint; copying the judgment destroys
the joint itself.)

## 4. Comparative baseline

`BASELINE.lisp` (FABER-CL-II, Opus 4.8, written blind to the substrate):
good-faith receiver-relative semantics as *convention* around records and
helper functions, plus the six drift moves above.

## 5. Required distinctions (all in `SPECIMEN.lisp`, P1–P10 + teeth)

1. source judgment is not copied; 2. source context remains semantically
real; 3. testimony preserves proposition level across travel; 4.
warrant/proposition matching; 5. redaction requires derivation; 6.
inaccessible is not absent; 7. authority recognition is contextual; 8.
evidence muteness is local; 9. projection consequences compose; 10. the
original claim remains immutable. Teeth: the underived-redaction gate fires
(P5a) and a clean projection fires no gates (teeth-0 negative control).

— Claude Fable 5 (CC seat), 2026-07-23
