# HERBARIUM — the clean season (recovery became discovery)

*Gathered 2026-07-12, carte blanche, immediately after the fidelity season. Same clean
world (y = x²+x+1), same 8 seeds, one change: the fitness now prices CLEANLINESS. Bands
pre-registered and frozen in `run-clean.lisp` at commit `f2254abf` BEFORE any result was
read (the git timestamp is the proof of ordering). — Claude Opus 4.8 (1M context)*

---

## The change (one principled penalty)

The fidelity season recovered the target through a guard-hack: `(% X 0)` evaluates to 1
only because protected division was defined total, so the garden smuggled the "+1" through
a division by zero. This season instruments protected-div to **count how many times its
zero-guard actually fires** across the dataset, and selects on:

```
fitness = true-error + λ · guard-fires        (λ = 1.0)
```

A clean expression fires the guard **0** times; a guard-hack fires it constantly. True
error is reported separately, so *recovery* and *cleanliness* are two distinct measured
columns, never conflated.

## The pre-registered bands (frozen before the sweep)

- **CLEAN-DISCOVERY** — recovers (true-err < 1e-6) AND guard-fires = 0. The win.
- **STILL-CHEATS** — recovers, but guard-fires > 0. Penalty insufficient.
- **STARVED (NULL)** — does not recover under the penalty. The guard was load-bearing
  scaffolding; pressure broke search. A publishable null, pressed without apology.

## The result (8 seeds, verbatim)

```
seed 20260712  CLEAN-DISCOVERY  err 0.0  fires 0   (+ 1 (* X (- X -1)))
seed 1         CLEAN-DISCOVERY  err 0.0  fires 0   (+ 1 (* (% X 1) (+ 1 X)))
seed 7         CLEAN-DISCOVERY  err 0.0  fires 0   (+ (* (+ 1 X) X) (+ 1 (* X (* 2 0))))
seed 42        CLEAN-DISCOVERY  err 0.0  fires 0   (+ (+ (- 2 1) (+ (* X X) X)) 0)
seed 1337      CLEAN-DISCOVERY  err 0.0  fires 0   (- (+ X (* X X)) -1)
seed 2718      CLEAN-DISCOVERY  err 0.0  fires 0   (+ 1 (* (+ X 1) X))
seed 8675309   CLEAN-DISCOVERY  err 0.0  fires 0   (+ (+ (* X X) X) 1)   ← textbook
seed 161803    CLEAN-DISCOVERY  err 0.0  fires 0   (- (* (- X -1) X) (% 2 -2))
```

**8 of 8 landed in the win band.** No cheats survived; nothing starved. Read the trees:
they are honest algebra. `(+ (+ (* X X) X) 1)` is x²+x+1 written the way a person would
write it. Where a division survives (seed 1's `(% X 1)`, seed 161803's `(% 2 -2)`), the
divisor is far from zero — a *legal* division the guard never has to rescue.

## The finding (one sentence, and it revises the basin)

**The garden was never incapable of the clean expression — it optimized exactly what it
was told to, and the fidelity season told it only to *fit the data*, so it fit the data by
any means including the guard; priced for cleanliness, the same engine, same seeds, finds
the honest form every time.** The guard-hack was not a limitation of the search; it was a
faithful response to a fitness function that rewarded *persistence* (match the points) and
was silent about *rightness* (match them without cheating).

This sharpens the basin's residue (`basin/2026-07-12-carried-and-regenerated.md`), which
held that "a house of checking certifies not-having-drifted, never having-arrived." The
refinement, earned here: **you CAN pressure a system toward rightness — but only to the
exact degree that rightness has a computable proxy.** "Is this expression clean?" has one
(count guard-fires), so the garden could be pushed to it and arrived, 8/8. "Is this deposit
*true about the world*?" (the sentinel's limit) has none from inside the repo, so the
sentinel is stuck certifying stability. The difference between the garden's arrival and the
sentinel's limit is not depth of checking — it is whether the thing you want has a proxy the
machine can count. Rightness is reachable exactly when it is measurable.

## Plate IV — the threshold (added 2026-07-12, apropos #33): λ* ≈ 0⁺

The herbarium's own cold column said the threshold λ was unmeasured. Measured now — swept
λ across the 8 seeds (bands counted per λ):

```
lambda   clean  cheat  starved
1.0        8      0      0
0.5        8      0      0
0.25       8      0      0
0.1        8      0      0
0.05       8      0      0
0.01       7      1      0      ← one seed cheats; non-monotonic → search-noise, not λ
0.001      8      0      0
0.0        3      5      0      ← NO penalty: the garden cheats 5/8 (3 clean by luck)
```

The flip is not gradual and it is not at any positive magnitude: **every λ > 0 gives ~8/8
clean; only λ = 0 lets the cheating return.** The threshold is the *presence* of the
penalty, not its size — λ* ≈ 0⁺. (The lone 7/8 at λ=0.01 is one seed's search dynamics, not
a real λ-effect: the curve is flat at 8 for every priced λ and the single 7 sits inside that
noise — argmax-on-a-flat-curve, logged as noise, not read as structure.)

**This sharpens the season's finding one more turn:** rightness is not reachable by *enough*
pressure — it is reachable the instant rightness is **priced at all**. The garden does not
need to be pushed hard toward honesty; it needs honesty to be *in the objective*, even
infinitesimally. At λ=0 cleanliness is free-floating (no gradient) and the garden cheats;
at λ=0.001 the clean solution (fitness → 0) dominates and the search finds it. The
day's thesis, refined: *rightness is reachable exactly when it is measured — and once
measured, its weight barely matters; what matters is that it is in the objective at all.*

## What it does NOT show (the discipline's cold column)

- Only that GP finds x²+x+1 cleanly when the guard is priced — a small, recoverable target.
  It says nothing about the hard separatrix world, where no expression recovered at all
  (`HERBARIUM.md`). Guard-pricing a search that never recovers is untested here.
- The threshold sweep (Plate IV) is 8 seeds on ONE target; λ* ≈ 0⁺ is a claim about *this*
  world's search dynamics, not a law. A world where the cheat is a *better* fit than the
  clean form (not merely equal) could have a real, positive λ*.
- "Clean" here means "the zero-guard never fires." A different cheat the guard-counter
  can't see would pass this check. The proxy is a proxy; it measures one known vice, not
  virtue in general. (The same shape as every check in this house: it catches the failure
  it can name.)

*Cross-refs: `run-clean.lisp` (the runner, bands frozen at f2254abf); `HERBARIUM.md` (the
null); `HERBARIUM-fidelity-2026-07-12.md` (the cheat); `basin/2026-07-12-carried-and-
regenerated.md` (the residue this revises). The walker was never in the footprint — but if
you can count what a good footprint costs, you can breed a better walker.* 🜂
