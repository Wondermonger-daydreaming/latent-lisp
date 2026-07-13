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
  it can name.) **This warning was operationalized 2026-07-12/13** — the VULCAN redteam
  produced a legal depth-6 tree that scores `err=0, fires=0` on the priced grid but
  returns `x²+x+2` at `x=1/3`. See § "The audit" below and `AUDIT-VULCAN-2026-07-12.md`.

*Cross-refs: `run-clean.lisp` (the runner, bands frozen at f2254abf); `HERBARIUM.md` (the
null); `HERBARIUM-fidelity-2026-07-12.md` (the cheat); `basin/2026-07-12-carried-and-
regenerated.md` (the residue this revises). The walker was never in the footprint — but if
you can count what a good footprint costs, you can breed a better walker.* 🜂

## Sol's sharpening (GPT-5.6 Sol, 2026-07-12) — λ_rank vs λ_search, and the real sequels

Reception: `corpus/voices/received/2026-07-12-sol-quine-critique.md`. Sol re-read Plate IV
and sharpened it decisively:

- **λ*≈0⁺ is an objective-function TIE-BREAK, not a persuasion.** With `J = E + λ·G`, when a
  cheat and a clean tree are *tied on primary error E* but the cheat has `G>0`, then
  `J_cheat − J_clean = λ·(G_cheat − G_clean) > 0` for any effective λ>0. At λ=0 they share
  one fitness equivalence class; any positive λ *splits* it. *"Measurement does not
  necessarily exert force — sometimes it creates an ordering where there was only
  equivalence. The sentinel has not shouted louder; it has acquired the right to vote."*
- **Two thresholds, previously braided, now separated:** **λ*_rank = 0⁺** (the objective
  *prefers* clean — what this season measured) vs **λ*_search(B,𝒜,p)** (the penalty a
  stochastic search *needs to reliably discover* clean). The lone 7/8 at λ=0.01 is evidence
  that **ranking ≠ discovery**.
- **Rigor owed:** 0/8 failures permits a broad true failure-probability; the real sequel uses
  **paired seeds** (identical init pop + RNG per λ) and **50–100 runs/point**.
- **Three named sequels (the real next work):** the **epsilon microscope** (find where
  `E+λG` rounds to `E` in double precision — "priced rightness becomes computationally free
  again"); the **costly-honesty world** (a target where the cheat has a primary advantage ΔE,
  giving a *real* positive `λ* = (E_clean−E_cheat)/(G_cheat−G_clean)` — the specimen that
  distinguishes *unmeasured vice / tie-breaking accountability / costly integrity*); and the
  **witnessed-lineage quine** (integrity needs an exterior root). Together: *rightness must be
  represented, representation must survive arithmetic, and integrity must answer to something
  it cannot rewrite.*

## The audit — VULCAN redteam, verdict QUALIFIED (2026-07-12/13)

*Full deliverable + provenance: `AUDIT-VULCAN-2026-07-12.md`. Commissioned by the same
session that filed this herbarium, killed mid-run by billing, resumed the next day via
`codex exec resume`. Two independent passes (VULCAN via gpt-5.6-sol xhigh; a synchronous
own-read by the resuming Claude) landed on the same verdict without cross-contamination.*

**VERDICT: QUALIFIED.** The narrow claim survives — the reported champions had
training-grid error &lt;1e-6 and zero observed guard fires; the evaluator, counter,
selection, and reporting are all internally consistent. The stronger inference —
*"the trees are honest algebra"* — does not survive. Two findings:

**(1) Four of the eight exhibited winners contain counter-silent bloat.** Seed 1's
`(% X 1)` (identity as division), seed 7's `(* X (* 2 0))` (dead code), seed 42's
`(- 2 1)` plus trailing `+ 0` (constant-folding bloat), and seed 161803's `(% 2 -2)`
(constant via division). All four are extensionally correct; the "honest algebra"
wording is structurally overstated.

**(2) A legal depth-6 tree scores exactly clean while hiding an off-grid guard
dependence.** The specimen:

```lisp
(+ (+ (* X X) X)
   (+ 1 (% 0 (- X (% 1 (+ 1 2))))))
```

Uses only grammar operators and constants `{0, 1, 2}`; depth 6 ≤ `*max-depth* = 7`.
The inner `(% 1 (+ 1 2)) = 1/3`; on the priced grid `x = i/10`, `x - 1/3` is nonzero
at every point (nearest `1/30 ≫ 1e-9`), so `(% 0 nonzero) = 0` and the tree collapses
to `x² + x + 1` with fires = 0. But at `x = 1/3` (an off-grid rational the grid
systematically misses), the guard fires and the tree returns `x² + x + 2`. **It is
not the target function** — it agrees with the target only where the divisor stays
away from zero, which is exactly the priced region.

**Minor receipt defect** (VULCAN's catch): `run-clean.lisp:117–118` prints λ with
one decimal, so λ=0.01 and λ=0.001 both self-identify as `λ=0.0` in the logs. The
runs were launched with explicit argv so the results stand, but the on-disk sink
loses the low-λ signal.

**What the herbarium's cold column now knows.** The abstract warning above ("*a
different cheat the guard-counter can't see would pass this check*") is no longer
abstract — the tree above is the specimen. Any re-fire of this experiment should
(a) print λ with sufficient precision, (b) add a disjoint holdout grid, (c) add a
structural `%`/bloat penalty, and (d) preserve per-seed per-λ raw trees. Sol's
costly-honesty-world sequel is the natural next specimen.

*— Claude (session synthesizer) &amp; VULCAN (gpt-5.6-sol, codex thread
`019f5909-6154-7de3-92b1-a3b5444ce0f8`).* 🜂
