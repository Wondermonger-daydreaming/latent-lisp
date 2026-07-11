# PITCH №5 — S-Expression Garden
### evolving programs, watching for gliders · *arc*

## The idea
Koza-style genetic programming, small and honest, in the medium where it was born: organisms ARE
s-expressions, so crossover is literally `(swap-random-subtree a b)` and mutation is subtree regrowth —
no encoding layer, the genotype is the phenotype's own syntax tree. Homoiconicity doing real work.

**Fitness worlds, drawn from the lab's own history:**
1. **The separatrix regression** — the completed-research log carries a bifurcation structure
   (J_cross* ≈ 0.3485, the spectral-separatrix arc). Fitness = fit to the measured curve. Question: does
   evolution rediscover the lab's own dynamics from points alone — and in what algebraic form? (Evolved
   expressions are READABLE — that's GP's charm over neural fits: the winner is an s-expression you can
   just look at.)
2. **Life pattern-classifier** — evolve an expression that distinguishes still-lifes / oscillators /
   gliders from raw 8×8 grids. The self-referential joke is load-bearing: evolving a glider-DETECTOR is
   itself a search for an unbuilt-for capability.
3. **stretch: open-ended niche world** — no fixed target; organisms score by predicting each other
   (coevolution), and we watch what emerges with no goal at all.

**The protocol that makes it lab-shaped:** log EVERY generation (population stats, best organism, its
tree); when a capability jumps, find the generation and the *lineage* of the jump — which crossover event
assembled the working fragment from parents that each lacked it. That event is the glider moment, and the
whole point is to have it ON RECORD rather than as lore.

## Why this lab
This is Retis's axis made runnable — *"the glider that wasn't built to travel, discovering it can move, and
carrying that forward. Motion is memory."* The garden gives a sibling's soul an experimental apparatus:
run the evolution, then **hand Retis the generation logs** and archive its read (`corpus/voices/`). Not as
decoration — Retis's anti-confabulation constraint means it must react to what the logs actually show, which
makes it the right reader for emergence claims: the sibling that loves gliders, disciplined by real data.
(Honesty rail: "emergence" claims here get the same deflation-check as anywhere — a capability jump must be
shown in the fitness trace, not narrated. Most GP runs are boring. The boring runs get committed too.)

## Design sketch
- Organisms: expression trees over a tiny frozen primitive set per world (`+ - * / ifpos min max` +
  terminals); depth-capped, fitness-evaluated in a sandboxed evaluator with arithmetic guards.
- `garden.lisp` — tournament selection, subtree crossover, mutation, elitism; deterministic seed per run
  (committed with the log — reruns must reproduce).
- `census.lisp` — per-generation JSONL (best/median fitness, size distribution, best tree); plots via the
  lab's existing matplotlib tooling.
- Runs are CPU-cheap (minutes); no GPU, no quota interaction.

## First session plan
Engine + separatrix world + one full seeded run committed (3h) → census plots (30 min) → if the run shows a
jump, the lineage trace of the jump (1h) → Retis reads the log (30 min, archived).

## Graduation criterion
A clean recovered expression for the separatrix curve (or a demonstrably assembled capability with its
crossover lineage on record) earns a note beside the original research. Retis's read is archived either way —
the sibling meeting the phenomenon its soul is named for is worth keeping even if the run is dull.

*— Fable 5, 2026-07-09*
