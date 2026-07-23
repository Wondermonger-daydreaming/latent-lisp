# ALLOWED-SOURCES — the stranger's frozen knowledge

*What the implementation seat may know during the implementation phase.
The seat is a text-only API call: this list is enforced by construction
— nothing outside it is ever pasted into the seat's context.*

## Allowed (transmitted verbatim, completely)

1. `../LANGUAGE-SLICE-0-GUIDE.md` — the programmer guide.
2. `../LANGUAGE-SLICE-0-API.md` — the API brief (161 exported symbols;
   includes the public load instructions and the public kernel0
   dependencies, which are part of the documented surface).
3. `TASK.md` — the frozen novel-task description, including the
   verbatim content of both task input files and the exact run command.
4. `task-inputs/readings-batch-a.sexp` and `task-inputs/validator.lisp`
   — verbatim (embedded in TASK.md §inputs; identical bytes on disk).
5. **Its own execution transcripts** — full raw SBCL output of its own
   program, relayed unedited under the bounded REPL-by-proxy protocol
   (CHARGE.md). Nothing in a relay message but the transcript.
6. Ordinary Common Lisp knowledge from its own training. (ANSI CL, SBCL
   behavior, generic style — all fair. Slice /0 itself cannot be in any
   training corpus: first published 2026-07-23.)

## Forbidden during implementation (enforced by omission)

- `de-promotione/`, `de-projectione-1/`, `de-infando/` — all specimen
  dirs, suites, dispositions, expected-failures, audits;
- old projection probes; `de-projectione.lisp`;
- `LANGUAGE-SLICE-0-ARCHITECTURE.md` (until post-freeze reveal);
- `LANGUAGE-SLICE-0-CLOSURE.md` (until post-freeze reveal);
- `LANGUAGE-SLICE-0-CHARTER.md`, `WORK-ORDER-0.md`, `INVENTORY-0.md`,
  `kernel0-api-brief.md`, defect receipts, interim dispositions;
- work orders, inventories, diaries, epistles, guild entries, audits,
  handoffs, and the conversation that commissioned this experiment;
- implementation source (`slice0.lisp`, `slice0-projection.lisp`,
  `slice0-transmissibility.lisp`, kernel0 source) — the seat never sees
  it; the custodian's SBCL loads it as the opaque dependency the public
  load mechanism requires;
- `SMOKE.lisp` — it is a worked *solution-shaped* program by a lineage
  author; giving it would hand over exactly the tacit knowledge under
  test (the API brief references it; the reference travels, the bytes
  do not);
- any prior solution or specimen helper;
- `EVALUATION.md` and its teeth-check plants — evaluation-side only.

## After the freeze (post-reveal, retrospective phase only)

`LANGUAGE-SLICE-0-ARCHITECTURE.md` and `LANGUAGE-SLICE-0-CLOSURE.md`
are revealed for the retrospective. The pre-reveal report is preserved
unchanged.

## Cross-check

The stranger's required declaration lists the files it actually used;
the custodian cross-checks that list against this manifest and records
any discrepancy in `CUSTODIAN-RESULT.md`.

— Claude Fable 5 (CC seat), custodian, 2026-07-23
