# de-teste-occiso — the inhabited restart specimen

*"Concerning the killed witness."*

> **A process may die while its durable history survives; reconstruction may
> derive from that history, but it may not pretend to remember what was never
> committed.**

A three-process specimen built against the public §22 surface of
`mneme/journal0/` (the independently-seeded Common Lisp Process Journal /0
store). A writer is charged with one append and **killed by SIGKILL at one
governed progress point**; a genuinely new process then restarts over nothing
but the surviving durable bytes.

**Run** (from the latent-lisp root):

```sh
sbcl --script mneme/journal0/de-teste-occiso/run-specimen.lisp
```

Exit 0 iff every check passes. **63 checks, 0 failures**; the two captures are
byte-identical (`RUN-EXITCODES.txt`).

---

## The three lives

| file | who | what it does |
|---|---|---|
| `specimen-common.lisp` | shared ground | the **declared charge** (which events the store is supposed to contain) and the declared store configuration — and nothing derived from the killed process |
| `run-specimen.lisp` | **ESTABLISHER** + kill supervisor | commits three events durably, launches and SIGKILLs the writer, preserves the crash artifacts, drives four restart processes, runs seven negative controls, renders every verdict |
| `stage-writer-child.lisp` | **OCCISUS** | a separate OS process charged with one append; killed at a governed progress point — mode `cw3` (after the durability barrier, before the receipt reaches the caller) or mode `cw0` (before the first frame byte) |
| `stage-recover.lisp` | **SUPERSTES** | a genuinely new `sbcl --script` invocation whose entire admissible input is the store directory's durable bytes plus declared configuration |

## The cell that was hit: **CW-3, `:synced`**

§1's third window: *declared durability barrier satisfied, before the append
receipt reaches the caller.* The child completes `append-event` (canonicalize
→ lock → frame → append → `fsync(2)` → §9.2 step-9 reopen validation →
receipt), announces only that the call returned, and is killed with the
receipt still in its memory. The delivery channel it would have written after
its wait loop is never written; the loop never ends.

**How the bytes prove it** (checks 008–012 in the capture):

| | evidence | rules out |
|---|---|---|
| (a) | surviving bytes validate `:valid` with **4 frames** | CW-0 (3 frames), CW-1 (torn tail) |
| (b) | valid prefix consumes all **1507** octets, zero excluded | CW-2a (absent), CW-2b (torn) |
| (c) | frame 4's payload is byte-identical to the canonical encoding of the declared charge, at ordinal 4 | that some other frame landed |
| (d) | **no `LOCK` survives** — the critical section had completed and its `unwind-protect` released the lock before the kill | a kill *inside* §9.2 |
| (e) | the caller holds **no receipt** for a frame that **is** durably committed | ordinary success |

**The honest limit, printed in the capture, not buried here:** CW-2c and CW-3
are **byte-identical by design** (§29). The bytes prove a complete durable
frame; what distinguishes CW-3 from CW-2c is the harness's **ordering record**
(the marker was written only after `append-event` returned) plus the store's
declared `:synced` durability. That ordering is *scaffolding* evidence, not
byte evidence, and it is named as such wherever the claim is made.

## What is preserved

`CRASH-ARTIFACT-EVENTS.pj0` is the **post-kill store bytes, raw** — the
recovery's actual input, inspectable rather than summarized — with the
metadata, the sidecar, `CRASH-ARTIFACT-SHA256SUMS.txt`, and
`CRASH-ARTIFACT-MANIFEST.txt`. All are byte-stable across runs.

## Phases

- **1** — three events committed durably through the public §9 path.
- **2** — the killed writer (separate process; SIGKILL at the governed point).
- **3** — raw crash artifacts + the byte proof of the cell.
- **4** — the restart: a new process validates, exposes (here: an absence of)
  a torn tail, reconstructs with origin `:reconstructed`, refuses a blind
  unsafe retry, and reconciles CW-3 by event identity at ordinal 4 with zero
  new bytes.
- **5** — a **derived** CW-1 exhibit: the crash artifact truncated by 7
  octets, *labelled derived, not a second kill*, run through the same restart
  process — torn tail visible, prefix intact, source never truncated, salvage
  to a new identity with the source byte-identical afterwards.
- **6** — eight negative controls, each naming the exact check that reddens.
  The last is the specimen's own teeth: **a second live SIGKILL, same charge,
  same child program, kill point moved to CW-0.** The bytes come back
  unchanged, the charged event is absent — and the ordinary retry then
  **commits** at ordinal 4 where the CW-3 retry **reconciled** with zero new
  bytes. Same code, different cell, different lawful recovery: the cell
  reported in phase 2 is a finding, not a constant of the harness.

## Scratch

`scratch-store/`, `scratch-run/`, `scratch-torn/`, `scratch-mutated/`,
`scratch-controls/` are rebuilt from nothing on every run and deleted at the
end of a successful one. They are never the record; the captures and the
`CRASH-ARTIFACT-*` files are.

## Standing

See `SPECIMEN-RETURN.md` for what this proves, what it does not, which §30
MUSTs it discharges and which remain, and the standing block. Read
`PROVENANCE.md` for the exposure record (Class B reads: zero).

*— SUPERSTES (Claude Fable 5 subagent), 2026-07-29*
