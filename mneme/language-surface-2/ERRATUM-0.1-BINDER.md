# Surface /2 Erratum 0.1 — the binder

**Authorized by:** the owner (live delivery, 2026-07-30): *"Perform one
bounded correction against published Language Surface /2 … then close
Surface /2. No audit, no review cycle."* This document and the
reproduction transcript are committed BEFORE the patch; the git ordering
is the proof.

**Untouched by this erratum:** `seat-outcome`, derivation semantics,
pattern-axis semantics, the inhabited census passage, Surface /1,
Vertical /0, every predecessor.

## 1. The defects (public, narrow, reproduced pre-patch)

1. **Parent shadowing.** `match-outcome` promises the parent outcome
   remains available in every branch, but a facet binding may reuse the
   parent variable's name — the generated inner `LET` then shadows the
   parent with a facet value, defeating the literal claim.
2. **Duplicate facet variables** in one clause produce an invalid
   duplicate-binding `LET` in the expansion, accepted at expansion time.
3. **Dangling `:facets`** (marker with no specification list) is
   silently swallowed: `(second rest)` is NIL, `(listp NIL)` holds, and
   `EVERY` over NIL is vacuously true — bindings become none, the
   marker disappears.
4. **Typed-refusal leak in `with-outcome`.** The macro lambda list
   destructures `((var derivation-form) &body body)`, so a malformed
   binding shape (non-list, one element, three elements) is rejected by
   the HOST's macro-lambda-list machinery before the catalogued
   `:with-outcome-binding-malformed` can be signalled — an untyped
   escape from the discipline. The published control tested an invalid
   variable inside a correctly shaped pair, not malformed shape.

Pre-patch reproduction: `surface2-erratum-binder-repro.lisp` →
`RUN-ERRATUM-REPRO-PREPATCH.txt` (committed with this document,
before the patch), confirming: cases 1–3 ACCEPTED by expansion (no
refusal), case 4 escaping as a host error that is NOT a retained
Surface /2 refusal.

## 2. The repair (surgical)

- `with-outcome` is redefined over ONE raw binding argument; the macro
  itself validates that the binding is exactly a proper two-element
  list whose first element is a bindable symbol, then extracts `var`
  and `derivation-form`. Malformed shapes now refuse
  `:with-outcome-binding-malformed`, retained.
- `%parse-clause`: facet variables must be unique within a clause; a
  facet variable `EQ` to the parent outcome variable refuses; `:facets`
  must be followed by an explicit proper specification list (a dangling
  marker refuses; a dotted or non-list spec refuses). All through the
  EXISTING codes `:facet-binding-malformed` /
  `:with-outcome-binding-malformed` — no new vocabulary minted.

## 3. Version consequence (recorded before patching)

```text
grammar   1 → 2   (the accepted source-form language is narrowed)
procedure 1 → 2   (expansion behavior changes)
policy    1       (unchanged)
```

## 4. Controls

New gate `surface2-erratum-binder.lisp` → `RUN-ERRATUM-BINDER.txt`
(+ `-SECOND`, byte-identical): the five malformed cases each refuse
through the intended retained code (parent-shadowing facet ·
duplicate facet variables · dangling `:facets` · with-outcome non-list
/ one-element / three-element shapes) AND lawful facet destructuring +
lawful parent access still execute (positive legs). The three published
Surface /2 gates rerun green; their transcripts change only where
version numbers print. `verify-all` reruns green.

*— Claude Fable 5, chair, 2026-07-30.*
