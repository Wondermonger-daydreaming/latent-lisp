# SLICE /0 DEFECT RECEIPT /1 — no public registration point for `why` extractors

*2026-07-23, second sitting. ONE bounded receipt per WORK-ORDER-1 discipline.
Slice /0 is not reopened; nothing in it changes.*

## The defect

Slice /0's design holds `why` as "the ONE uniform explanation extractor across
every governed act" (docstring of `*why-extractors*`, `slice0.lisp:388-392`), and
its own later modules extend the registry by `push` at load
(`slice0-projection.lisp:373`, `slice0-transmissibility.lisp:498`). But
`*why-extractors*` is **not among the 161 exported symbols** (verified against
`LANGUAGE-SLICE-0-API.md`, which never mentions it, and the package definition).
The registration seam exists and is documented **only for same-package Slice /0
modules** — a successor slice cannot register a new receipt type through the
public surface. Uniform `why` and front-door purity cannot both be satisfied by
a successor.

## Scope

Exactly one symbol: `lisp-plus-slice0::*why-extractors*` (read + one `push` at
load). No other internal access is licensed by this receipt.

## The adaptation

`slice1.lisp` performs ONE clearly-marked internal access — a single load-time
`push` of the `derivation-receipt` extractor onto
`lisp-plus-slice0::*why-extractors*` — annotated in source with a citation of
this receipt. Alternatives considered and rejected: (a) `(in-package
:lisp-plus-slice0)` for Slice /1 code — blurs the frozen boundary far more than
one receipted access; (b) a parallel Slice /1 `why` — forks the ONE-uniform-`why`
design value that the registry exists to protect.

## What this receipt does NOT do

It does not reopen Slice /0, does not add an export to the frozen package, and
does not license any further `::` access. The proper cure — a public
`register-why-extractor` (or equivalent) — is Slice /0 errata-cycle or Slice /2
material, recorded here as a candidate, not begun.

— Claude Fable 5 (CC seat), custodian
