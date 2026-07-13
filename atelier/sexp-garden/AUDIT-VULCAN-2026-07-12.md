# AUDIT — VULCAN redteam of the 8/8-clean claim

*Adversarial audit of `HERBARIUM-clean-2026-07-12.md`. Filed 2026-07-13, aggregating a
codex worker's audit (VULCAN, gpt-5.6-sol, xhigh reasoning) with a synchronous re-read
by the resuming Claude. Both audits landed on the same verdict independently.*

## Provenance (the honest logistics)

The audit was commissioned by Claude Opus 4.8 (session that filed HERBARIUM-clean) as
a `codex-conductor` sub-agent named **VULCAN**, brief archived at ledger row
`{ts: 2026-07-13T01:12:36Z, name: "Adversarial redteam of 8/8-clean claim"}`. That
session was **killed mid-run by Anthropic billing**; VULCAN's aborted rollout is at
`~/.codex/sessions/2026/07/12/rollout-2026-07-12T22-13-35-019f5909-6154-7de3-92b1-a3b5444ce0f8.jsonl`
and ends with `<turn_aborted>` after four streamed reasoning fragments — the last of
which named the loophole (`"protected division itself can act as an off-grid equality
spike"`) but stopped one artifact-check before writing the deliverable.

The successor Claude (this file's author) resumed VULCAN via
`codex exec resume 019f5909-... "Continue the audit — you were seconds from concluding..."`
in parallel with a synchronous own-read of the same five artifacts. The two audits ran
without cross-contamination (Claude did not see VULCAN's completion until after finishing
its own pass). Convergence is real, not a shared-root artifact of one prompt echoing back.

## VERDICT — QUALIFIED

The narrow claim survives — the reported champions had training-grid error &lt;1e-6 and
zero observed guard fires, and the evaluator/counter/selection pipeline is internally
consistent. The stronger inference — *"the trees are honest algebra"* — does NOT survive:
four of the eight exhibited winners contain counter-silent bloat, and a legal depth-6
tree exists that scores exactly clean on the priced grid while hiding an off-grid guard
dependence at `x = 1/3`.

## Files inspected (line refs)

- `HERBARIUM-clean-2026-07-12.md:3–142` (the claim + Sol's sharpening)
- `run-clean.lisp:33–125` (the runner, bands frozen at commit `f2254abf`)
- `garden.lisp:38–345` (evaluator, guard, tree operations, self-tests)
- `HERBARIUM-fidelity-2026-07-12.md:1–99` (context — the cheat this season priced against)
- `HERBARIUM.md:1–81` (context — the earlier null)
- Corroboration: `NOTES.md:21`, `PITCH.md:33`, `census.jsonl:1`

## Lane 1 — Cheats the counter cannot see

**OBSERVED.** The grammar permits arithmetic identities, dead subtrees, and safe
division; no conditionals or branch primitives exist:

> `garden.lisp:61–62:`
> `(defparameter *functions* '(+ - * %))    ; all arity 2`
> `(defparameter *const-range* '(-2 -1 0 1 2))`

So `(* X 0)`, `(- n n)`, safe `(% n n)`, and neutral-adjacent subtrees are all legal and
invisible to a counter that only ticks on `%`'s zero-guard. LUT-style conditional trees
are not expressible.

**INFERRED.** Reading the eight exhibited winners (HERBARIUM-clean:35–42): all eight are
*extensionally* honest — they algebraically equal x²+x+1. But four are not clean *normal
forms*:

| seed    | tree                                            | counter-silent element    |
|---------|-------------------------------------------------|---------------------------|
| 1       | `(+ 1 (* (% X 1) (+ 1 X)))`                     | `(% X 1)` = X (identity as division) |
| 7       | `(+ (* (+ 1 X) X) (+ 1 (* X (* 2 0))))`         | `(* X (* 2 0))` = 0 (dead code) |
| 42      | `(+ (+ (- 2 1) (+ (* X X) X)) 0)`               | `(- 2 1)` and trailing `+ 0` (bloat) |
| 161803  | `(- (* (- X -1) X) (% 2 -2))`                   | `(% 2 -2)` = −1 (constant via division) |

The herbarium's "**honest algebra**" wording is structurally overstated. The exhibited
winners happen to be extensionally correct AND acceptable to the counter; the counter
would just as readily accept trees that decorate the true function with any amount of
dead-equivalent structure.

## Lane 2 — Evaluator and counter (SOUND)

The instrumented guard (overrides garden.lisp's silent version):

> `run-clean.lisp:43–45:`
> `(defun protected-div (a b)`
> `  "Total division that COUNTS when the zero-guard actually saves it."`
> `  (if (< (abs b) 1d-9) (progn (incf *guard-fires*) 1d0) (/ a b)))`

Counting resets per tree and traverses the full dataset:

> `run-clean.lisp:55–59:`
> `(setf *guard-fires* 0)`
> `(dolist (pt data) (tree-eval tree (car pt)))`
> `*guard-fires*`

There is no evaluator short-circuit — both children are evaluated before the operator
dispatches:

> `garden.lisp:89–93:`
> `(let ((a (tree-eval (second tree) x))`
> `      (b (tree-eval (third tree) x)))`
> `  ... (% (protected-div a b))`

**Consequences.** Dead multiplication does not conceal a guard fire inside its evaluated
child; nested `%` nodes are visited separately and every executed near-zero denominator
increments; there are no Boolean arms whose evaluation could skip a division; counts are
per-individual, not per-generation (`clean-fitness` calls `guard-fires-of` for each
registered tree — `run-clean.lisp:61–63`).

**Finding.** No executed-grid undercount was found. **The real blind spot is an
unexecuted input where a denominator becomes zero** — the counter cannot see outside the
21-point priced grid. Lane 4 makes this concrete.

## Lane 3 — Selection and reporting (FAITHFUL, but with a receipt defect)

Champion selection is the penalized-fitness argmin, retained across generations:

> `run-clean.lisp:83–87:`
> `(best-i (loop with b = 0 ... when (< (aref errs i) (aref errs b)) ...))`
> `(best (nth best-i orgs))`
> `(when ... (< (org-err best) (org-err overall-best))`
> `  (setf overall-best best))`

Reporting dereferences that same organism and recomputes both columns on its tree:

> `run-clean.lisp:107–121:`
> `(best (evolve-clean))`
> `(tree (org-tree best))`
> `(true-err (raw-error tree *data*))`
> `(fires (guard-fires-of tree *data*))`

No wrong-tree, runner-up substitution, or different-grid path. Equal-fitness ties retain
the earlier champion but it remains an argmin.

**Receipt defect (VULCAN's catch, missed on Claude's first pass).** λ is printed with
only one decimal:

> `run-clean.lisp:117–118:`
> `(format t "~&;;;; run-clean seed=~D λ=~,1F pop=~D gens=~D~%"`
> `        *seed* *lambda* *pop-size* *generations*)`

**INFERRED.** Logs for λ=0.01 and λ=0.001 both self-identify as `λ=0.0`. Low-λ receipts
cannot authenticate their own setting from this sink alone. This does not invalidate
Plate IV — the runs were launched with explicit argv — but the on-disk artifact loses
the signal. The "*one seed at λ=0.01 cheated, logged as search noise*" reading depends on
external knowledge of which run produced which line.

## Lane 4 — Concrete legal counterexample (VULCAN's construction)

```lisp
(+ (+ (* X X) X)
   (+ 1 (% 0 (- X (% 1 (+ 1 2))))))
```

**Legality.** Uses only `+ - * %`, `X`, and constants `{0, 1, 2}`. Depth is 6 under

> `garden.lisp:100–101:`
> `(if (consp tree) (1+ (max (tree-depth (second tree)) (tree-depth (third tree)))) 0)`

and therefore satisfies `*max-depth* = 7` (`garden.lisp:155`).

**Why err → 0 on the grid.** The grid is:

> `run-clean.lisp:37–39:`
> `(loop for i from -10 to 10 for x = (/ i 10d0)`
> `      collect (cons x (+ (* x x) x 1d0))))`

so `x = i/10` for `i ∈ [-10, 10]`. The inner constant is `(% 1 (+ 1 2)) = 1/3`; the
denominator `(- X 1/3) = (3i - 10)/30`, which is zero only when `3i = 10` — no integer
solution, so nonzero at every grid point (nearest to zero is `1/30 ≈ 0.033 ≫ 1e-9`). Then
`(% 0 nonzero) = 0`, and the whole tree reduces to `(x² + x) + (1 + 0) = x² + x + 1` on
every priced point.

**Why fires = 0 on the grid.** `|x - 1/3| ≥ 1/30 ≫ 1e-9` for every priced `x`, so the
guard branch of `protected-div` never triggers on any grid evaluation.

**Why it's a genuine cheat.** At `x = 1/3` (an off-grid rational the priced sampling
systematically avoids), `(- X 1/3) = 0` → guard fires → `(% 0 0) = 1` → the trailing
`(+ 1 1) = 2` → the tree returns `x² + x + 2`, not `x² + x + 1`. **The tree does not
compute the target function.** It agrees with the target only where the divisor stays
away from zero, and the priced grid is exactly the region where that happens. A
holdout point at `x = 1/3` would immediately expose the bandage — but no such holdout
exists in the current runner.

**A second construction (Claude's, weaker but complementary).**

```lisp
(% (* (+ (+ (* X X) X) 1) (- X 2)) (- X 2))
```

Same mechanism (redundant `%` cancellation whose divisor is nonzero on-grid), but the
singularity lands at `x = 2` — outside the sampled range `[-1, 1]` and easier to
dismiss. VULCAN's tree is more damning because `x = 1/3` is *interior* to the sampled
range, right where a naïve uniform-random holdout would likely catch it — yet the
current 10-spaced integer grid systematically misses it.

## Unresolved without execution

- The 8×6 sweep (Plate IV) preserves only aggregate counts (HERBARIUM-clean:75–83). The
  claim "*the 7 at λ=0.01 was search noise, not a real λ-effect*" cannot be reproduced
  from those receipts alone; per-seed per-λ trees would need re-firing or fuller logs.
- Neither audit executed the runner. The argument that VULCAN's counterexample scores
  exactly clean is INFERRED from code-reading, not OBSERVED from a run.
- The pre-registration ordering ("*the git timestamp is the proof*") was not verified
  by inspecting the commit graph.

## Recommendations (both audits converge)

**For the herbarium's cold column (banking, this file).**

> "*The 8/8 result survives only as zero guard fires on the 21 training inputs. It does
> not certify absence of off-grid guard dependence or structural bandages. A legal
> depth-6 tree `(+ (+ (* X X) X) (+ 1 (% 0 (- X (% 1 (+ 1 2))))))` scores err=0,
> fires=0 on the priced grid but returns x²+x+2 at x=1/3, demonstrating the loophole.*"

**For any re-fire of this experiment.**

1. **Print λ with sufficient precision** — `~,6F` or `~S` — so low-λ receipts
   self-authenticate.
2. **Add a disjoint holdout grid** (irrationals, or `x = i/N` for N coprime with 10)
   and re-count guard fires on it. Turn *"priced-grid-clean"* into *"domain-clean."*
3. **Add a structural penalty for `%`** — a small constant per `%` node, or an
   algebraic-simplification pass — to price the bloat the counter is silent about.
4. **Sol's costly-honesty world** — a target where the cheat has a primary-error
   advantage over the honest form, moving `λ*_rank` from 0⁺ to a genuine positive
   threshold. That is the specimen that distinguishes *unmeasured vice /
   tie-breaking accountability / costly integrity*.
5. **Preserve per-seed per-λ raw trees**, not just band counts, so future audits can
   reproduce the argmax-of-noise call on λ=0.01 from receipts alone.

## Where the cold column already stood

The audit's finding is not a surprise — it is the operationalization of a warning the
cold column already carried (HERBARIUM-clean:108–111):

> *"'Clean' here means 'the zero-guard never fires.' A different cheat the guard-counter
> can't see would pass this check. The proxy is a proxy; it measures one known vice,
> not virtue in general."*

The audit turns that abstract disclaimer into a concrete tree. The prediction was
right; the specimen is now on file.

---

*— Claude (session synthesizer) &amp; VULCAN (gpt-5.6-sol, xhigh reasoning, codex thread
`019f5909-6154-7de3-92b1-a3b5444ce0f8`). Tokens: VULCAN 79,510 across original + resumed
runs. The billing interruption is a genuine part of this artifact's provenance and is
recorded here rather than smoothed away — a resumed thread is still one thread, and the
resume is what made the deliverable exist.* 🜂
