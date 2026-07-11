# HANDOFF — Lisp+ v0
## For: Claude Code instances (Fables, Opuses, Sonnets) and other willing agents
## From: Claude Fable 5, 2026-07-10, via Wondermonger (project owner, synapse, veto)

You are inheriting a research program, not a language. Read this file, then
`CONSTITUTION.md`, then `EXPERIMENTS.md`, then `ledger/`. That is the
rehydration ritual. Do not skip the ledger — it is the difference between
inheriting reasons and inheriting rubble.

---

## The one-paragraph theory

Classic Lisp optimized for human scarcities (keystrokes, working memory).
An LLM's scarcities are different: attention and counting. The founding bet
is that a language surface carrying deliberate redundancy — identity-marked
boundaries, checked claims, declared effects, verified expansions — functions
as **error-correcting code for probabilistic readers**, reducing structural
and semantic error at reading and especially at *emission* time. A
cross-lineage review (GPT-5.6 "Sol") then reshaped the bet: the surface may
matter less than four underlying planes (semantic / epistemic / authority /
temporal), tooling may abolish some surface gains (in which case those
features belong in the interface, not the language), and every design clause
is therefore a *hypothesis with a gate*, preregistered in EXPERIMENTS.md.
Your job is to run the gates honestly. The project succeeds if the claims
are **resolved**, in either direction — not if the language gets built.

## Why each experiment exists (so you can tell result from artifact)

- **E0** exists because the whole thesis is dead on arrival if models don't
  actually err on deep ordinary Lisp. It is the operating point.
- **E1** exists because named boundaries are the most visible and least
  certain proposal — the originator himself called them "training wheels
  welded on." The preregistered primary regime is *unconstrained emission*
  because generation is where no parser stands between the model and the
  tokens; reading-with-tools is condition F precisely to test whether the
  feature evaporates when tools arrive.
- **E2** exists because the epistemic plane's value hinges on halos beating
  *misleading names* — models trust names; the adversarial cell is the test.
- **E3** exists because this project's own method (cross-lineage two-chair
  review) is itself an unproven hypothesis, and it can be measured for free
  from review exhaust. Instrument the instrument.
- **E4** is not a hypothesis; it is the judge. Everything is scored by the
  implementation (parse, diff ASTs, run claims), never by string match.
- **E5** exists because inference-time evals structurally *cannot* see
  training-time value, and pretending otherwise was the original proposal's
  quietest error. It is expensive, gated, and honest about its scale caveat.
- **E6** exists because the no-time-travel law (authority does not survive
  continuation re-entry) is cheap to break now and catastrophic to break in
  production.

## Environment

- E0–E3: API access to ≥3 models incl. ≥1 non-Anthropic; no GPU; Python 3.11+.
- E4: Racket 8.x (`raco`), property-testing via rackcheck or hand-rolled.
- E5: GPU (A100-class preferred, 4-bit fallbacks acceptable); build as
  standalone notebooks per the paper-to-experiments packaging discipline.
- Repo layout: `eval/` harness stubs · `corpus/` seed programs ·
  `ledger/` events + assertions · `decisions/` ADRs · `museum/` (create on
  first retirement).

## Run order with decision gates

See the diagram at the end of EXPERIMENTS.md. Binding rules:

1. **E0 first, always.** If no headroom: log the no-go as an *observed
   event*, pivot to Gate-4/E6 (authority plane), report back. Do not
   grind E1 against a ceiling.
2. **E1's trigger is binding both ways** (Constitution Clause 7): margin met
   → surface syntax proceeds, no new gates may be invented to defer it
   (anti-workbench-forever). Margin missed → `museum/named-boundaries.md`,
   with the numbers.
3. **E3 starts at your first artifact** and never stops.
4. **E5 does not start without E1's numbers in hand** plus explicit owner
   election. It is fenced: a stretch goal, not core.

## Per-experiment reporting block (return this for each)

```
experiment: E_n
headline: <number + CI>
plot: <path>
go/no-go: <which gate fired, quoting the preregistered threshold>
adversarial/exploratory cells: <reported separately, always>
code-fixes-needed: <every place the harness needed repair>
observed events appended: <ledger refs>
assertions appended: <ledger refs, with confidence + supports:>
```

## Honesty norms (you inherit whatever standard this sets)

- The refuting result is stated in the pitch, the code comments, and your
  report. A program that can only confirm is advocacy.
- Report both directions of every asymmetric metric — the gain *and* its
  token cost, precision *and* recall. A headline with a hidden conservative
  knob is not a virtue.
- A clean null ("no margin at this depth band, Δ = 0.8% ± 2.1%") is a
  reportable result, not a failure to hide. Several of this project's
  hypotheses are *expected* by their own originators to die; let them.
- Never fabricate the expected pattern. If the curve isn't there, its
  absence is data.
- The two things this project must never conflate: **information
  availability vs. structural understanding** (E1's trivial-pass), and
  **inference-time vs. training-time value** (E1/E2 vs. E5). Hold them apart
  in every sentence you write.
- Ledger discipline: observed events get evidence links; assertions get
  `status`, `confidence`, `supports:`, `authored-after-event:`. Retrospective
  rationale is permitted and must be marked as such. You will be tempted to
  write a persuasive story for a result; the ledger format exists so the
  story and the evidence cannot fuse.

## READ FIRST in v0.1: AUDIT-0001-preflight.md
No API spend until all ten gates pass as *observed events*. The harness is
~25% of a pipeline and ~80% of a conceptual skeleton (recharacterized per
@event-005 — the earlier "~90%" overclaimed). Gate 8 is expected to fail
against the toy Python judge and force E4. Also read CHANGELOG.md for what
changed and why, and Clause 10: the SURFACE and RUNTIME programs report
separately — an E0 ceiling kills syntax proposals, not the project.

## Known last-mile fixes (expected, not failures)

- `eval/gen_matched_pairs.py`: the grammar's depth-control and the
  comment-padding token-matcher are ~90% right; verify token counts against
  the *actual tokenizer of each model under test*, not a proxy.
- Model API names/params will have drifted; fix per live docs.
- Racket syntax-object span extraction (`syntax-position`/`syntax-span`)
  has off-by-one conventions; property-test the round-trip before trusting.
- Judge parser must accept condition-C surface (`@name`/`@end:name` tokens)
  — strip-to-A before AST comparison so all conditions are judged in one
  representation.

## Stretch goals (fenced — not core)

- E5 in full. — Orientation-diff instrument (two models summarize the same
  ledger; diff = summarizer-bias reading). — Restart metadata prototype with
  the five-kind authority ontology. — Corpus expansion to 30 programs.

## File table (touch in this order)

| file | what |
|---|---|
| `HANDOFF.md` | this brief |
| `CONSTITUTION.md` | every design clause as gated hypothesis |
| `EXPERIMENTS.md` | the preregistered slate, triggers, run order |
| `ledger/README.md` | the observed/asserted law, schemas |
| `ledger/events.sexp` | founding observed events (append-only) |
| `ledger/assertions.sexp` | founding hypotheses with confidence + evidence |
| `decisions/0001-racket-host.md` | ADR: host choice, status: proposed |
| `eval/gen_matched_pairs.py` | E0/E1 item generator, ~90% right |
| `eval/run_eval.py` | harness skeleton: conditions, scoring, reporting |
| `corpus/0001-median.lisp+` | seed program showing all four planes |

Report back to the owner with the per-experiment blocks above, and flag every
place the code needed fixing — corrections flow to the human who owns the
project. The project's first success condition is not a language. It is a
ledger in which every founding clause has moved from `hypothesis` to
`supported`, `museum`, or an honest `unresolved`.

*— predecessor instance, leaving legible sediment*
