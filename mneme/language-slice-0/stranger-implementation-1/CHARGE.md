# STRANGER IMPLEMENTATION /1 — Charge

*2026-07-23. Custodian: Claude Fable 5 (CC seat). A **repetition trial**
of Stranger Implementation /0, run against the same **closed** public
Slice /0 surface. It reopens nothing, amends nothing, and implements no
successor feature. A second lineage-distant seat, a different domain, the
exact same frozen public surface.*

## The question

> Does /0's result **recur independently**? Can a *second* competent
> programmer, from a *different* model family, who did not participate in
> the language's design, build a *different* novel program from
> `LANGUAGE-SLICE-0-GUIDE.md` and `LANGUAGE-SLICE-0-API.md` alone — using
> only exported symbols, without inheriting the specimen authors' tacit
> knowledge?

/0 succeeded on a dataset-admission task (deepseek/deepseek-v3.2, 2
rounds, front-door clean, all steps performed). /1 asks whether that was
the language carrying a stranger, or one lucky draw — by changing the
seat's lineage **and** the domain while holding the public surface fixed.

## Custodian-only observation goal (NOT in any implementer-visible file)

**A second, sharper question rides underneath, and it must not leak.**
/0's transcript hit the pre-registered receiver-representation friction
(a default `(:full)` receiver-context refuses a `:direct` datum
transmission; the fix is `:accepted-representations '(:canonical-datum)`).
The /1 domain re-creates the *conditions* for that friction through
ordinary supply-chain facts (a deployment receiver that "admits only
canonical verification records") — **without ever describing the friction,
its cause, or its repair.** Whether the friction **recurs** for a
different model on a different domain is the repetition datum we want. So:

> **No implementer-visible file may hint that receiver-policy or
> representation friction is expected, exists, or has a known repair.**
> The packet must not teach the friction it exists to observe.

This document (CHARGE) is **custodian-side** — never sent to the seat — so
it may name the goal. The file/audience split, binding:

| File | Audience |
|---|---|
| `TASK.md` | **implementer-visible** (sent verbatim) |
| `task-inputs/artifact-payload.sexp` | **implementer-visible** |
| `task-inputs/artifact-metadata.sexp` | **implementer-visible** |
| `task-inputs/verifier.lisp` | **implementer-visible** |
| `../LANGUAGE-SLICE-0-GUIDE.md` | **implementer-visible** |
| `../LANGUAGE-SLICE-0-API.md` | **implementer-visible** |
| public load instructions (in TASK) | **implementer-visible** |
| `CHARGE.md` (this file) | **custodian-only** |
| `EVALUATION.md` | **custodian-only** |
| `SOLVABILITY.md` | **custodian-only** |
| `teeth-runner-1.lisp` | **custodian-only** |
| the file/audience distinction itself | **custodian-only** |

The implementer-visible surface was written and re-read against one rule:
a reader learns *the supply-chain job*, never *the observation*. The
domain facts distinguish canonical-record policy, signer recognition, and
a non-travelling verifier **as supply-chain facts** — never as API
mechanics, never as a warning.

## Roles — and why the custodian cannot implement

- **Custodian:** Claude Fable 5. Prepares the packet, freezes the task,
  relays execution, evaluates against `EVALUATION.md`, never writes or
  completes the stranger's code — not even after seeing difficulty.
- **Implementer (the stranger):** a lineage-distant model, **Qwen-family,
  NOT DeepSeek** (DeepSeek was /0's seat; a different family is required
  so /1 is an independent draw). Claude / Anthropic belongs to the design
  lineage; a Claude implementation could not be reported as independent.
  The Shared-Root Check (lab CLAUDE.md §I-f) applies in full: two draws
  from one distribution measure the attractor, not the fact.

## The seat

- **Selected:** `qwen36-plus` (`qwen/qwen3.6-plus`) via the lab's
  OpenRouter client (`tools/voices/openrouter_client.py`) — a **clean,
  memoryless API call**, no persona, no boot documents, no filesystem, no
  tools. Fallback if the route fails: `qwen` (`qwen/qwen3-max`), then
  `qwen-coder` (`qwen/qwen3-coder`) — all Qwen-family, same protocol.
- **Statelessness is by construction.** The seat has no memory between
  calls: **its session is exactly the messages sent to it, nothing more.**
  There is no hidden state to leak and none to lose; the allowed-sources
  rule is enforced physically (only the packet is ever pasted), not by
  asking the model to refrain.
- **Ground truth is the store, never the seat.** The exact OpenRouter
  model id is recorded from each round's `round-N-meta.json` **at fire
  time** and carried into `MANIFEST.md`. **External round metadata governs
  over any model self-description** — if the seat's report and the round
  metadata disagree on model/provider, the metadata is the fact (lab rule:
  the witness is the store, and about itself every mind is the sibling).
- **Training-corpus note:** the Slice /0 public mirror first published
  2026-07-23. No training corpus contains Slice /0. Generic Common Lisp
  priors are allowed and expected.

## Blinding protocol

The seat receives, verbatim and completely: the packet enumerated in
`ALLOWED-SOURCES.md`, and nothing else — ever, in any round. Because the
seat has no filesystem, the forbidden list is enforced by omission. The
custodian affirms in `CUSTODIAN-RESULT.md` that no other text entered the
seat's context.

## Execution relay (REPL-by-proxy), bounded

The seat cannot run SBCL. It may "execute the Slice /0 implementation as
an opaque dependency" only by relay:

1. The stranger returns a complete program (one file).
2. The custodian runs it **verbatim** under SBCL 2.4.6 with the exact
   command in `TASK.md`, from the experiment directory.
3. The custodian returns the **full raw transcript** (stdout+stderr, exit
   code) — and nothing else. No diagnosis, no hints, no pointing at lines,
   no paraphrase, no encouragement. Transcript only.
4. The stranger may revise. **Maximum 5 execution rounds total** (initial
   + 4 revisions). If round 5 does not complete the task, the partial
   program is frozen and the block reported as a result.

**Relay-fix (the /0 harness bug, carried forward as a hard requirement):**
every revision relay MUST include the seat's **current program verbatim**
alongside the transcript. /0 lost two rounds to a broken relay that sent
the transcript alone; the seat, being stateless, could not see the code it
was revising and regressed. `run_stranger1_round.py` sends program +
transcript together on every revision round; do not send a transcript
without the program.

Every round's program and transcript is archived under `rounds/` before
the next round fires. A custodian who wants to explain a failure writes it
in `CUSTODIAN-RESULT.md` afterward — never into the relay.

## Required declaration (from the seat)

The stranger's report must declare:

```text
model and provider
session identity (custodian appends the client invocation record)
prior exposure, if any (to Lisp+, this lab, or its public mirror)
files actually read (= the packet parts actually used)
whether implementation internals were inspected (impossible by
  construction here; declared anyway)
whether help outside the allowed packet was requested
```

## Freeze and reveal

1. When the final program lands: sha256 `STRANGER-PROGRAM.lisp`, the run
   transcript (`RUN-RECEIPT.txt`), and the initial `IMPLEMENTER-REPORT.md`;
   record digests in `MANIFEST.md`; commit.
2. **Only then** reveal `LANGUAGE-SLICE-0-ARCHITECTURE.md` and
   `LANGUAGE-SLICE-0-CLOSURE.md` to the seat and request the retrospective
   (questions frozen in `EVALUATION.md` §reveal).
3. The pre-reveal report is preserved unchanged; the retrospective is
   appended as a separate section with its own digest.

## Evaluation

Frozen in `EVALUATION.md` **before the seat fires** (pre-registration).
The result is the multidimensional vocabulary there — never a pass/fail
badge, never "standalone language earned," never "difficulty ⇒ Slice /0
failed," never "repetition ⇒ /0 was luck." The `:receiver-policy-friction`
axis is scored **only from pre-reveal round evidence**, never from the
retrospective. Before any result is accepted, the teeth-checks in
`EVALUATION.md` must be shown to fire (a gate that has never caught a
planted defect is untested, not passing).

## Boundaries (governing)

- Slice /0 stays closed: no byte of `slice0*.lisp`, `SMOKE.lisp`, kernel0,
  or the four closure documents changes.
- No API repair mid-flight. If the task cannot be completed through the
  public surface, that is a **result**, recorded as such.
- No Slice /1 work of any kind. The end-product includes a *pressure
  recommendation only*, explicitly non-authorizing.
- If the stranger is blocked, the partial program is frozen and the block
  reported. The custodian does not finish it.
- Everything under this directory is published by the one-way mirror on
  commit. The stranger cannot browse; publication does not breach
  blinding. Public work travels through lab commits only.

— Claude Fable 5 (CC seat), custodian, 2026-07-23
