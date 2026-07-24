# EXPECTED-FAILURES — de-abaco (PRE-REGISTRATION)

*Written 2026-07-24 by EXEMPLAR (CC seat, Opus 4.8 · 1M) **BEFORE the captured
run of SPECIMEN.lisp.** The specimen was authored; these predictions were frozen
from the design and from the read substrate behavior; only then was the official
RUN-RECEIPT.txt captured. These are predictions, not transcriptions. Any
divergence at run time is reported as a chair-finding, not silently reconciled
here.*

Program under audit: package `de-abaco-abacus` (`tally-vowels`,
`parse-lantern-counts`), using only `#:cl`. Battery: package `de-abaco-battery`.

## Pre-registered per-check dispositions

| # | Check | Expected result |
|---|-------|-----------------|
| 1 | `tally-vowels "The orchard remembers."` | an alist of 5 `(char . int)` cells; a plain value, not a claim. (Predicted counts: a=1, e=4, i=0, o=1, u=0.) |
| 2 | `parse-lantern-counts` over `("east:3" "west:5" "broken" "north:2")`, a `handler-bind` invoking CL restart `use-count 0` on the malformed `"broken"` | 4 rows; `"broken"` repaired to 0; `"east"`→3. The repair is a pure CL restart. |
| 3a | `package-use-list` of `de-abaco-abacus` | `("COMMON-LISP")` — no governed package. |
| 3b | live `do-symbols` audit of the abacus package for governed-home symbols | empty (NIL) — zero governed symbols interned. |
| 3c | static `scan-governed-references` over the verbatim abacus source | empty (NIL) — zero governed external references. |
| 3c-control | scan over a planted `(lisp-plus-core0:perform …)` form | **non-empty**, containing `lisp-plus-core0:perform` — the scanner CAN see a governed symbol (so 3c's emptiness is evidence). |
| 4a | schema-registry probe (`resolve-schema :de-abaco-probe-schema 1`) before AND after the run | both refuse `schema-not-found` ⇒ both T ⇒ registry untouched. |
| 4b | adapter-registry probe (`resolve-adapter :de-abaco-probe-adapter`) before AND after | both refuse `unknown-adapter` ⇒ both T ⇒ registry untouched. |
| 5 | no governed object produced by the repair | T — the abacus references zero governed constructors (3a–c), so it structurally cannot mint a `core0-evidence`, `outcome`, or receipt; and `PERFORM` is not even interned in the abacus package. |

**Expected tally:** `9 checks passed / 0 failed`, exit 0.

## Falsifier (what makes this run a FAILURE, nonzero exit)

- ANY of 3a / 3b / 3c returning a non-empty governed set (the quiet zone leaks).
- 3c-control returning empty (the scanner is broken; the clean scans prove
  nothing — this is the instrument's own teeth-check, and it must bite).
- 4a or 4b showing the probe present after the run when it was absent before (the
  abacus registered something).
- Check 2 failing to repair (the CL restart grammar not functioning), or check 5
  finding a governed object (consequence attached to ordinary computation).

## Note on the two grammars (the distinction this specimen draws)

The CL restart repair and a governed core0 repair are **disjoint grammars**:

- `parse-lantern-counts` uses `restart-case` with names `skip-entry` / `use-count`
  — ordinary CL, no receipt, no evidence, no event, on no core0 whitelist.
- A governed core0 repair lives behind `with-core0-restarts` (whitelist
  `begin-reconciliation` / `authorize-supersession` / `abandon-uncertain-effect` /
  `stop-and-export-evidence`) and emits receipts.

The specimen proves they coexist without leaking: the abacus repairs a malformed
entry entirely within the CL grammar, and the machine checks confirm not one
governed symbol was reachable from the program that did it.
