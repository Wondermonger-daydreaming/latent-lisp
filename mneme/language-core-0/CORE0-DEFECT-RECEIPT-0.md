# CORE /0 DEFECT RECEIPT /0 — no public registration point for `why` extractors

*2026-07-24, Language Core /0 build. ONE bounded receipt per the work-order's
"one receipt per seam, no silent internals" discipline (§1.1). Slice /0 is not
reopened; nothing in it changes. This receipt re-instances the exact seam Slice
/1 already receipted (`SLICE0-DEFECT-RECEIPT-1.md`), now for the effectful door.*

## The defect

Slice /0 holds `why` as "the ONE uniform explanation extractor across every
governed act" (docstring of `*why-extractors*`, `slice0.lisp:388-393`), and its
own later modules extend the registry by `push` at load
(`slice0-projection.lisp:373`, `slice0-transmissibility.lisp:498`). Slice /1
added its `derivation-receipt` extractor the same way (its receipt, cited). But
`*why-extractors*` is **not among the 161 exported Slice /0 symbols** — the
registration seam is documented and reachable **only for same-package code**. A
successor layer cannot register a new receipt type through the public surface.

The owner's two-door ruling makes this seam load-bearing for Core /0 specifically:
*"Inspection (`why`): SHARED NOW — the one uniform door; extractor registry takes
both"* (OWNER-RULING-TWO-DOORS-EVIDENCE-TEST.md). For the effectful door's
evidence to be explicable through the **same** `why` the evidentiary door uses,
Core /0 must register a `core0-evidence` extractor — and the only registration
point is the unexported `*why-extractors*`.

## Scope

Exactly one symbol: `lisp-plus-slice0::*why-extractors*` (read + one `push` at
load). No other internal access is licensed by this receipt. The `push` is a
runtime extension of a `defvar` list — **not** an edit to any frozen source byte;
the closed-evidence trees (`language-slice-0/`, `language-slice-1/`, `kernel0/`)
are unmodified.

## The adaptation

`core0.lisp` performs ONE clearly-marked internal access — a single load-time,
find-guarded `push` of the `core0-evidence` extractor (predicate SYMBOL
`'core0-evidence-p`, `#'identity` extractor) onto
`lisp-plus-slice0::*why-extractors*` — annotated in source with a citation of
this receipt. The find-guard makes reloading `core0.lisp` install no duplicate:
the registry grows by exactly one entry total across any number of loads (the
same idempotent-registration discipline Slice /1 proved).

Alternatives considered and rejected, identically to Slice /1's receipt:
(a) `(in-package :lisp-plus-slice0)` for Core /0 code — blurs the frozen boundary
far more than one receipted access; (b) a parallel Core /0-only `why` with no
registration — forks the ONE-uniform-`why` design value the owner ruling names as
shared substrate. (Core /0 *does* also ship a thin `why` façade over the uniform
door, exactly as Slice /1 does — but the façade delegates to the shared registry,
it does not replace it.)

## What this receipt does NOT do

It does not reopen Slice /0, does not add an export to the frozen package, does
not modify any frozen byte, and does not license any further `::` access. The
proper cure — a public `register-why-extractor` (or equivalent) — remains Slice
/0 errata-cycle or Slice /2 material, recorded here (as in Slice /1's receipt) as
a candidate, not begun.

— Claude Code (FABER-EFFECTUS-II), Language Core /0 substrate build
