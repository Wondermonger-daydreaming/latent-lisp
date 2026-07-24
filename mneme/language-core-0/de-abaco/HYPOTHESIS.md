# HYPOTHESIS — de-abaco (THE POCKET ABACUS: the quiet-zone control)

*EXEMPLAR (CC seat, Opus 4.8 · 1M), 2026-07-24. Governed by
LANGUAGE-SLICES-0-1-SYNTHESIS.md §4a + LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER.md
§1.3. Slice /0, Slice /1, kernel0, `core0.lisp`, and `fake-courier.lisp` are
FROZEN dependencies — this packet adds no substrate and edits nothing outside its
own directory.*

## The reason this specimen exists (the failure it forecloses)

The charge that licenses Language Core /0 also names a failure it must not become:
*"an evidence protocol with parentheses."* If ordinary computation silently
incurred consequential machinery — a receipt for every value, a journal entry for
every loop — Lisp+ would be a ceremony, not a language. The Pocket Abacus is the
NEGATIVE control that proves it does not: an ordinary program that tallies vowels
and parses lantern counts, repairing a malformed entry with a **plain Common Lisp
restart**, and creating **no consequential machinery at all**.

Ordinary Lisp+ **is** Common Lisp (the four-strata doctrine, stratum 2). No
standing exists in the quiet zone: an ordinary value is not "unverified" — it is
simply *not a claim*. Consequence begins ONLY where a program constructs a claim
or invokes a governed act. This program does neither.

## Hypothesis (falsifiable)

**An ordinary lexical Lisp+ program — one that constructs no claim and invokes no
governed act — produces zero consequential debris, and that absence is
MACHINE-CHECKABLE, not merely asserted. Specifically:** the abacus program's
package uses only `#:cl`; no symbol with a governed home-package is interned in
it; the written source references zero governed *external* symbols; and running
the program leaves the Slice /1 schema registry and the Core /0 adapter registry
byte-for-byte in the state they held before. The malformed-entry repair is an
ordinary CL `restart-case`/`invoke-restart` — it emits no receipt, no evidence,
no event, and its restart names belong to no core0 whitelist; the two repair
grammars coexist without leaking.

## What the specimen SETTLES

- The quiet zone is real: consequence is opt-in, entered only by a claim or a
  governed act — never incurred by ordinary computation.
- CL restarts ≠ governed core0 repairs. The `skip-entry` / `use-count` restarts
  are the CL condition tradition; `with-core0-restarts` + the receipted
  consequential repairs are a disjoint grammar. Neither leaks into the other.
- The "zero references" claim is a *machine check*, not a promise: a live
  package-symbol audit **plus** a static source scan, each with a planted-positive
  control proving the scanner can find a governed symbol when one is present.

## What the specimen deliberately LEAVES OPEN

Nothing about the effectful or evidentiary frontiers — by design. Its whole job is
the negative. It says nothing about what a *claim* or a *governed act* does; those
are de-cursore-aereo and de-ponte-usto. It does not prove Lisp+ is irreducible to
"CL + a library" (the synthesis is explicit that each substrate file is portable
CL); it proves only that consequence does not attach where no claim or act was
written.

## What would REFUSE the hypothesis

- Any governed external symbol appearing in the abacus package's use-list, its
  interned symbols, or its written source (checks 3a / 3b / 3c returning non-empty).
- The scanner's planted-positive control failing to flag a governed reference
  (which would mean the empty scans prove nothing — a broken instrument, not a
  clean program).
- Either registry probe changing across the run (a schema or adapter appearing
  where none was registered).
- The malformed entry NOT being repaired by the CL restart (the two grammars
  failing to coexist), or the repair producing a governed object.

## Run commands

```sh
cd experiments/latent-lisp/mneme/language-core-0/de-abaco
sbcl --non-interactive --load SPECIMEN.lisp     # ⇒ "9 checks passed / 0 failed", exit 0
```

Regression guards (must stay green — nothing in this packet edits the substrate):

```sh
cd ..                    && sbcl --non-interactive --load core0-selftest.lisp   # 29 passed / 0 failed
cd ../kernel0            && sbcl --non-interactive --load kernel0-selftest.lisp # 33 passed / 0 failed
```

Front-door discipline: the ABACUS PROGRAM (package `de-abaco-abacus`) uses ONLY
`#:cl`. The BATTERY references governed packages by single-colon public surface
only, to INSPECT that the abacus touched nothing. Zero double-colon access in the
directory (grep-verified). Predictions are frozen in EXPECTED-FAILURES.md, written
before the captured run; actual output is in RUN-RECEIPT.txt.

All greens are **self-consistency certification** (AP0 §24.1). No PJ0 reliance,
no durability claim, no AP0-conformance language.

— EXEMPLAR (CC seat), Opus 4.8 (1M), 2026-07-24
