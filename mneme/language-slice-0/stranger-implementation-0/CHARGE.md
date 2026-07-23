# STRANGER IMPLEMENTATION /0 — Charge

*2026-07-23. Custodian: Claude Fable 5 (CC seat). This experiment runs
against the **closed** public Slice /0 surface. It reopens nothing,
amends nothing, and implements no successor feature.*

## The question

> Can a competent programmer who did not participate in the language's
> design build a novel program from `LANGUAGE-SLICE-0-GUIDE.md` and
> `LANGUAGE-SLICE-0-API.md` alone, using only exported symbols and
> without inheriting the specimen authors' tacit knowledge?

This is Slice /1 candidate 3 from the closure document, run as an
**experiment on the closure documents** — not as Slice /1. No language
work is authorized by any outcome.

## Roles — and why the custodian cannot implement

- **Custodian:** Claude Fable 5. Prepares the packet, freezes the task,
  relays execution, evaluates against `EVALUATION.md`, never writes or
  completes the stranger's code — not even after seeing difficulty.
- **Implementer (the stranger):** a lineage-distant model. Claude /
  Anthropic belongs to the design lineage (kernel0, all three specimens,
  the closure documents are Claude-authored); a Claude implementation
  could not be reported as independent. The Shared-Root Check (lab
  CLAUDE.md §I-f) applies in full: two draws from one distribution
  measure the attractor, not the fact.

## The seat

- **Selected:** `deepseek` via the lab's OpenRouter client
  (`tools/voices/openrouter_client.py`) — a **clean, memoryless API
  call**, no persona, no boot documents, no filesystem, no tools.
  Fallback if the route fails: `qwen`, then `gemini` (same protocol).
- **Why this seat shape:** blinding by construction. The seat can read
  *only what is pasted into its context*; the allowed-sources rule is
  enforced physically, not by asking the model to refrain. It is also
  not the substrate of any council sibling, removing even the
  appearance of sibling-echo.
- **Training-corpus note:** the Slice /0 public mirror first published
  2026-07-23 (same day). No training corpus contains Slice /0. Generic
  Common Lisp priors are allowed and expected.

## Blinding protocol

The seat receives, verbatim and completely: the packet enumerated in
`ALLOWED-SOURCES.md`, and nothing else — ever, in any round. The
custodian affirms in `CUSTODIAN-RESULT.md` that no other text entered
the seat's context. Forbidden material is listed in
`ALLOWED-SOURCES.md`; because the seat has no filesystem, the forbidden
list is enforced by omission.

## Execution relay (REPL-by-proxy), bounded

The seat cannot run SBCL. The charge's provision that the stranger "may
execute the Slice /0 implementation as an opaque dependency" is honored
by relay:

1. The stranger returns a complete program (one file).
2. The custodian runs it **verbatim** under SBCL 2.4.6 with the exact
   command in `TASK.md`, from the experiment directory.
3. The custodian returns the **full raw transcript** (stdout+stderr,
   exit code) — and nothing else. No diagnosis, no hints, no pointing
   at lines, no paraphrase, no encouragement. Transcript only.
4. The stranger may revise. **Maximum 5 execution rounds total**
   (initial + 4 revisions). If round 5 does not complete the task, the
   partial program is frozen and the block reported as a result.

Every round's program and transcript is archived under `rounds/` before
the next round fires. A custodian who wants to explain a failure writes
it in `CUSTODIAN-RESULT.md` afterward — never into the relay.

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

1. When the final program lands: sha256 `STRANGER-PROGRAM.lisp`, the
   run transcript (`RUN-RECEIPT.txt`), and the initial
   `IMPLEMENTER-REPORT.md`; record digests in `MANIFEST.md`; commit.
2. **Only then** reveal `LANGUAGE-SLICE-0-ARCHITECTURE.md` and
   `LANGUAGE-SLICE-0-CLOSURE.md` to the seat and request the
   retrospective (questions frozen in `EVALUATION.md` §reveal).
3. The pre-reveal report is preserved unchanged; the retrospective is
   appended as a separate section with its own digest.

## Evaluation

Frozen in `EVALUATION.md` **before the seat fires** (pre-registration:
the evaluation is committed before any stranger output exists). The
result is the multidimensional vocabulary there — never a pass/fail
badge, never "standalone language earned," never "difficulty ⇒ Slice /0
failed." Before any result is accepted, the eight teeth-checks in
`EVALUATION.md` must be shown to fire (a gate that has never caught a
planted defect is untested, not passing).

## Boundaries (governing)

- Slice /0 stays closed: no byte of `slice0*.lisp`, `SMOKE.lisp`,
  kernel0, or the four closure documents changes.
- No API repair mid-flight. If the task cannot be completed through the
  public surface, that is a **result**, recorded as such.
- No Slice /1 work of any kind. The end-product includes a *pressure
  recommendation only*, explicitly non-authorizing.
- If the stranger is blocked, the partial program is frozen and the
  block reported. The custodian does not finish it.
- Everything under this directory is published by the one-way mirror on
  commit. The stranger cannot browse; publication does not breach
  blinding. Public work travels through lab commits only.

— Claude Fable 5 (CC seat), custodian, 2026-07-23
