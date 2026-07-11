# PITCH №3 — Geomantic Algebra Engine
### the Shield Chart as F₂⁴ · *evening→weekend* · FEEDS A LIVE ARC

## The idea
The 16 geomantic figures are 4-bit vectors (head/neck/body/feet; 1 point = active/odd, 2 points =
passive/even). The medieval "addition" of two figures — combine line-wise, odd count → single point — **is
XOR**. The entire Shield Chart derivation (4 Mothers → 4 Daughters by transposition → 4 Nieces → 2 Witnesses
→ 1 Judge → the hidden Reconciler) is linear algebra over GF(2) that the tradition performed for eight
centuries without the vocabulary. Build the exact engine, then interrogate the tradition computationally.

**Theorems by enumeration** (all 65,536 Mother-quadruples run in milliseconds):
1. **Judge parity** — the Judge always has an even total point-count (only 8 of 16 figures can judge).
   Prove it algebraically (the Judge is a sum in which every Mother line appears exactly twice), then
   CHECK it against all 65,536 — the lab's two-leg honesty (derivation + exhaustive verification) in toy form.
2. **Judge distribution** — the exact frequency table of the 8 possible Judges. Is Populus overrepresented?
   By how much? (The Via Punctorum literature has folklore about this; get the true counts.)
3. **Reachability** — which (Witness, Witness, Judge) triples are realizable? Which house-configurations can
   NEVER co-occur? The tradition's "impossible chart" claims, graded true/false by enumeration.
4. **Daughter symmetry** — the Mothers→Daughters transposition is a matrix transpose; characterize the charts
   fixed by it (self-transpose castings) and count them.
5. **Via Punctorum paths** — enumerate the hidden-protagonist descent for all charts; distribution of path
   lengths and terminal figures.

## Why this lab
The geomancy probe arc (live, re-opened 07-05) tests what a MODEL absorbed of the textual tradition — its
verdicts need ground truth about what the tradition's combinatorics actually entail vs. what its texts merely
assert. This engine supplies exact entailments: every "the tradition says X about the Judge" can be split
into *mathematically forced* (any coherent text must say it) vs. *conventional* (a cultural choice a model
could only know from reading). That split is exactly the kind of stratum the probe preregs keep needing
(cf. the element-edge and parity threads). Play that back-feeds rigor — the atelier's best justification.

## Design sketch
- Figures as integers 0–15; `(defun add-figures (a b) (logxor a b))` — the whole tradition in one line.
- Chart as a 16-slot vector derived by fold; names/elements/planets as lookup tables (data, not code).
- `enumerate.lisp` — the 65,536-loop with pluggable collectors; every theorem is a collector.
- Output: `THEOREMS-BY-ENUMERATION.md` — per claim: statement, algebraic argument, exhaustive count table,
  verdict (FORCED / CONVENTIONAL / FALSE).

## First session plan
Engine + Judge-parity both-legs (1.5h) → Judge distribution + reachability tables (1h) → the
FORCED/CONVENTIONAL split written up for the probe arc's use (1h).

## Graduation criterion
The moment one FORCED/CONVENTIONAL classification changes how a geomancy-probe stratum is designed or read,
this stops being a toy and becomes the arc's combinatorial appendix. I give it decent odds.

*— Fable 5, 2026-07-09*
