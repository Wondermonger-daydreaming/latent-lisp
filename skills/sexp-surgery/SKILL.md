---
name: sexp-surgery
description: The accidental-tooling explosion — the craft of operating on code as data. A list-shuffler is a program-mutator; a tree-differ is a semantic code-diff; a compressor over S-expressions is a redundancy measure; a walker is an instrumenter. In a homoiconic medium these are the same afternoon — no parser guards the gate — and the skill is knowing the catalog of one-step-reachable instruments: mutators, analyzers, differs, generators, walkers, evaluators, and how they compose into evolution rigs and embedding manifolds. Honest scope-note: outside Lisp this becomes AST tooling and costs a parser at the door — the skill helps decide when the toll is worth paying, and when to move the problem into S-expression form instead. Triggers on: 'analyze this codebase programmatically', metaprogramming, 'generate variants of', program synthesis, 'diff these semantically', instrumentation. Kin: /paper-to-experiments, /inventor-stance, /thousand-storms, /bottom-up.
---

# /sexp-surgery

*Homoiconicity is not one gift; it is a gift generator. The number of
experiments reachable in one step from wherever you stand is just much
larger — the crate never empties.*

← Forged from the tiny-weird-models garage sessions: the recognition
that in Lisp, the mutator, the mutated, and the fitness harness are
all the same datatype, so entire research programs (self-hosting
mutation loops, program-embedding manifolds, macroexpansion
archaeology) collapse from systems-engineering projects into
afternoons. The skill extracts the operating knowledge: what becomes
trivially buildable when programs are lists, and how to reach for it.

## The catalog of one-step instruments

From any position where code is available as trees, each of these is
a small function away — internalize the menu so the reach is reflex:

- **Walkers** — visit every node; the universal chassis. Everything
  below is a walker with a payload.
- **Analyzers** — count, measure, inventory: call-graphs, depth
  profiles, vocabulary censuses ("which constructs does this codebase
  actually use?"), redundancy measures (compress the tree; the ratio
  is a duplication metric).
- **Differs** — structural comparison, ignoring surface: the semantic
  diff that whitespace-blind text tools fake. Alignment of subtrees
  is the one genuinely fiddly part (unequal-length siblings — the
  atelier's find-seam bug lives here; two-pointer alignment is the
  standard repair).
- **Instrumenters** — walkers that wrap: insert timing, logging,
  counters, assertions around chosen node-shapes without touching
  source files. Observation as transformation.
- **Mutators** — walkers that perturb: swap siblings, replace
  constants, substitute same-arity operators. One page of list
  surgery; the entire genetic-programming literature is downstream.
- **Generators** — grammars run backward: enumerate or sample
  programs from templates; the property-based-testing move (generate
  inputs THAT ARE PROGRAMS) falls out free.
- **Evaluators** — the meta-circular sketch: a toy eval in a screen
  of code, which means *variant semantics* (tracing eval, counting
  eval, nondeterministic eval) are each a modified screen.

## The composition move (where it gets serious)

The instruments compose because they share the datatype: mutate, then
diff mutant against parent, then instrument the survivors, then feed
results back as selection — an evolution rig from four small parts.
The garage designs from the sessions live here: the self-hosting
mutation loop (feed the mutator itself); the embedding manifold
(autoencode S-exprs to vectors, do calculus on program space —
trainable at all only because trees round-trip without a parser
shattering gradients); macroexpansion archaeology (walk the
expansion stages of a real codebase as strata; see the
sibling-spirited /macroexpand-descent for the contemplative twin).
Always pair mutation-scale work with /thousand-storms: mutants
without a harness and a seed are anecdotes with legs.

## The toll-gate (honest scope)

Outside homoiconic languages the same instruments exist but cost a
parser at the door — and the parser toll is not just effort: it's a
representation you must keep faithful to a language you don't
control. Decision guide:

- **Pay the toll** when the target codebase is fixed and large
  (tree-sitter and friends have prepaid much of it).
- **Move the problem** when you control the representation: design
  your data, configs, DSLs, and experiment specs AS S-expressions
  (or any parse-free tree form) from the start, and the whole
  catalog applies natively. This is /bottom-up applied to
  tooling-reachability: choose the medium where your instruments
  are one step away.
- **Don't fake it with regexes.** Text-surgery on code is surgery
  with oven mitts; the catalog's whole premise is operating on
  structure, not spelling.

## Failure modes

- **Mutation without selection**: perturbing programs with no
  fitness harness or seed discipline — noise generation with
  extra steps.
- **Walker sprawl**: seventeen bespoke walkers where one
  parameterized chassis would serve (see /lisp-curse — this skill
  is a curse-exposure zone; standardize your chassis).
- **Semantic naivety**: treating structural identity as behavioral
  identity. Alpha-renaming, macro boundaries, and evaluation order
  all break the naive tree-equality assumption; know which your
  instrument is blind to, and say so (/bounded-witness applies to
  tool output too).

## Kin

/bottom-up (choose media where tools are near), /repl-driven (the
loop these instruments live in), /thousand-storms (harnesses for
mutants), /inventor-stance (exaptation — every instrument here is a
list-operation repurposed), /paper-to-experiments (the pipeline these
feed).

Write the list-shuffler. See what it turns out to have been.
