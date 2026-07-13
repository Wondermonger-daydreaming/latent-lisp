# HERBARIUM — the fidelity season (pressed beside the separatrix season)

*Gathered 2026-07-12, a /tugs wander, on the CLEAN world — target y = x² + x + 1 on 21
points, the recoverable Koza-class fidelity target (not the lab's hard separatrix curve).
Pressed beside `HERBARIUM.md`, not over it: two seasons, two worlds, and the difference
between them is the finding. Seed 20260712, pop 300, 40 gens; deterministic (same seed →
byte-identical census, verified). — Claude Opus 4.8 (1M context)*

---

## The sweep (8 seeds, one line each)

```
seed 20260712  GLIDER ✈  leap 17.60   RECOVERED (err 0.0)
seed 1         GLIDER ✈  leap 13.72   RECOVERED
seed 7         GLIDER ✈  leap 17.70   RECOVERED
seed 42        GLIDER ✈  leap 15.40   RECOVERED
seed 1337      GLIDER ✈  leap 17.70   RECOVERED
seed 2718      GLIDER ✈  leap 17.70   RECOVERED
seed 8675309   GLIDER ✈  leap 16.70   RECOVERED
seed 161803    GLIDER ✈  leap 17.70   RECOVERED
```

**8 of 8 runs found a glider AND recovered the target exactly.** The separatrix season
(`HERBARIUM.md`) found *zero* gliders and never recovered its target. Same engine, same
glider definition, same honesty rail — opposite result. The variable was the *world*.

## Plate I — the glider (seed 20260712, gen 1)

```
parent A (id 282, err 28.70): (- X X)                    ; identically 0
parent B (id 231, err 28.60): (% (* (* X X) (% 1 X)) (+ (* X 1) (- X -1)))
child    (id 575, err 11.00): 1                          ; the constant one
leap past the better parent: 17.60
```

A crossover of *zero* and *a thicket* produced the **constant 1** — strictly fitter than
both. Read without romance: the "capability assembled from parents that each lacked it" is
the number one. That is a real glider by the pre-registered definition, and it is also a
reminder that the definition rewards *any* strict improvement over both parents, not
necessarily a profound one. Pressed honestly: the glider is real; its cargo is humble.

## Plate II — the money shot (gen 2, first exact recovery, by crossover)

```lisp
child (err 7.77e-16):  (- (+ (+ (+ X X) (% 0 0)) (* (% X X) (* X X))) X)
;;  (% 0 0) → 1 (guard) ;  (% X X) → 1 (guard)
;;  = (2x + 1 + 1·x²) − x  =  x² + x + 1     EXACT
parent A (err 16.50): (- (+ (+ (+ X X) (% 0 0)) (* (% X X) (* X X))) (+ (* 0 …) (- (% X -2) (- X X))))
parent B (err 11.00): (% (* (- X X) (- -2 -1)) (% (* 0 X) (+ 0 1)))
;;  NEITHER parent fit; one crossover assembled the target at generation 2.
```

On the recoverable world the target is found almost immediately — gen 2 of 40 — and by
recombination, exactly as the pitch hoped. The staircase the separatrix season climbed to
a bandage, this season sprinted in two steps to the real thing.

## Plate III — but read the champion (the honest weed)

The overall best (seed 20260712, id 8737, gen 29) recovers the target too — and does it
like this:

```lisp
(- (+ (+ (* X (+ 1 X)) (% X 0)) (* (% 0 (% 2 X)) (* X X))) 0)
;;  (* X (+ 1 X)) = x² + x                 ← the clean part
;;  (% X 0)       = 1   (protected div!)   ← "+1" smuggled through the zero-guard
;;  (* (% 0 …) …) = 0                       ← dead weight, harmless
;;  = x² + x + 1
```

The garden did **not** discover the clean `(+ (* X X) (+ X 1))`. It discovered x²+x+1
*through the protected-division guard* — `(% X 0)` evaluates to 1 only because division by
zero was defined total. This is the SAME anatomy the separatrix champion showed (scar
tissue around arithmetic guards), except here the scar tissue happens to land the exact
target. **Recovery is not cleanliness.** The guard that makes GP's closure property work is
also the garden's favorite cheat, on both worlds.

## The two-season finding (one sentence, deflation-checked)

**A glider is cheap when the world is recoverable and absent when it isn't** — 8/8 gliders
on x²+x+1, 0/1 on the separatrix curve — so the glider measures *whether recombination had
real building blocks to assemble*, not whether something magical emerged; and on both
worlds the expressions the garden actually keeps are guard-mediated bandages, clean on
neither. The glider is honest and humble; the recovery is real and scarred; the difference
between the seasons is the target, not the search.

## What it suggests (not run now)

- The separatrix world's null was a property of the WORLD (target not in easy reach of the
  primitive set), not a failure of the engine — this season is the positive control that
  shows the engine *can* recover and *does* glide when the target is reachable.
- A cleaner-expression pressure (parsimony + a guard-penalty on `(% _ 0)` / `(% X X)`)
  would test whether the garden can find x²+x+1 *without* the constant-1 cheat. That is the
  experiment that would make "recovery" mean "discovery."
- Per the pitch's standing rule: a glider worth handing to Retis is one on a HARD world.
  Eight gliders on an easy world are a control, not a call. The glider-lover still waits.

*Cross-refs: `HERBARIUM.md` (the separatrix season, the null); `run.lisp` (seed 20260712,
deterministic); `census.jsonl` (this season's uncut 40 generations, committed).*
