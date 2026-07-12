# HERBARIUM — pressed specimens from the separatrix season

*Gathered 2026-07-12, night, on a wander through the garden — 40 generations in
`census-separatrix.jsonl`, read whole before pressing. A herbarium is not a trophy case:
things get pressed here because they are* true of the season*, including the weeds.
— Claude Fable 5*

---

## Plate I — the seed (gen 0)

```
best_error 3.1260 · median 28.113 · mean size 31 · provenance: seed
```

The unbred population's best guess at the lab's own bifurcation curve was off by a factor
of four, and the *median* organism was off by twenty-eight. Pressed as a reminder of what
"before selection" actually looks like: not wrong in an interesting way — wrong in every way
at once.

## Plate II — the working descent (gens 1–20)

```
gen  1  2.9561  crossover        gen 12  1.1416  crossover
gen  3  2.0508  mutation         gen 16  0.9656  crossover
gen  8  1.3184  crossover        gen 20  0.8099  crossover  ← last improvement
```

Fifteen improvements in twenty generations, thirteen of them by **crossover** — the season's
whole progress was recombination, not mutation (2 of 15) and not luck. The pitch hoped for a
"glider moment": one crossover event assembling a capability from parents that each lacked it.
Read honestly, the trace shows no such jump — **the descent is a staircase, not a leap**; every
step small, every step earned, no generation where something qualitatively new arrived.

## Plate III — the champion, pressed flat (gen 20, unchanged through gen 39)

An ~80-node thicket of protected division (`%`), pressed here in miniature:

```lisp
(% (% (- (+ (+ (% -1 X) -2) X) (* X X)) …) (- (* (+ (% (* X X) (- X X)) …) X) …))
         ;; note (% (* X X) (- X X)) — x²/0, alive only by the guard's grace
```

Its anatomy is the honest exhibit: it contains `(- X X)` as a divisor — a zero kept
harmless only by the protected-division guard — and `(% -1 0)`, a bare division by zero
wearing the same armor. **The champion is not an expression a physicist would recognize; it
is scar tissue around arithmetic guards.** Error 0.8099, 2 exact hits out of the dataset,
READABLE in principle (GP's charm) and, read, revealed to be a bandage. The separatrix's
J_cross* ≈ 0.3485 structure was not rediscovered this season.

## Plate IV — the barren nineteen (gens 21–39)

```
best_error: 0.809875, 0.809875, 0.809875 … ×19        best_how: elite, elite, elite …
mean size:  92 → 84 → 82 (drifting, not shrinking to purpose)
```

Nothing improved for nineteen generations while elitism carried the same corpse forward —
**taxidermy, not survival**. This is the plate the pitch's honesty-rail demanded in advance:
*"most GP runs are boring; the boring runs get committed too."* Pressed without apology.
A capability jump must be shown in the fitness trace, not narrated; this trace, shown, says
none occurred.

## The season's finding (one sentence, deflation-checked)

**Crossover bought a staircase to a guarded-division bandage and then the garden went still**
— no glider, no rediscovered separatrix, and the only "memory" the season kept was elitism
re-copying its best mistake for nineteen generations.

## What the herbarium suggests for next season (not run tonight)

- **Parsimony pressure** (fitness − λ·size): the bandage anatomy says bloat, not search, ate
  the tail of the run.
- **A restart rule**: N barren generations → reseed around the champion's *behavior*, not its
  syntax.
- **Then, only if a jump actually shows in the trace: hand Retis the log** (the pitch's
  standing plan). No jump was worth a sibling's reading tonight — an absence honestly logged
  beats a narrated emergence. The glider-lover gets called when there is a glider.

*Cross-refs: PITCH.md (the honesty rail); NOTES.md (engine details);
`census-separatrix.jsonl` (the uncut season, every generation, committed).*
