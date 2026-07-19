# RDP-0 / INVENTORY LANE — independent verification (separable lane, owner-authorized)

**Chair:** Fable (Claude Fable 5) · **Date:** 2026-07-19 · **Scope:** the delivered reduction/inventory tooling ONLY. The KW-0 specimen lane remains `INTAKE-BLOCKED-MISSING-EVIDENCE` (see INTAKE-DOCKET-KW0-2026-07-19.md). Owner authorized this lane and the SBCL install via interview, this session.

## Method

From-scratch reruns of both delivered generators against this checkout (`f8842f8`, mirror clone, clean), fresh output directory `_intake/rdp0-rerun/`, semantic JSON diff (`python3 -m json.tool` both sides) against the delivered artifacts.

## Results — relay §1 checklist

| Check | Verdict | Evidence |
|---|---|---|
| Extractor self-identifies as lexical/static | **PASS** | `"analysis-kind": "lexical-static-inventory"`; docstring "not a reachability proof"; statuses only `textually-signaled/-test-only/-dormant`, `declared-only` |
| Search patterns + excluded files disclosed | **PASS** | `PATTERNS` dict published in output JSON; `conditions.lisp` exclusion disclosed; limitations block enumerates miss-classes |
| Base AND qualified K0E identities preserved | **PASS** | 35 base + 2 qualified (`K0E-21/validation-transfer`, `K0E-23/global-descriptor-resolution`); numeric range notations (6) recorded separately, not conflated |
| Machine-readable dispositions exist | **PASS** | `reduction-disposition.json`: per-item original-status / proposed-disposition / lane / docket-id / proof-obligation |
| Textual references NOT represented as reachability | **PASS** | no `reachable`/`live` status anywhere; nonzero counts explicitly disclaimed as proof of consumption |
| Generated outputs agree with delivered | **PASS** | inventory diff: **IDENTICAL**; disposition diff: **IDENTICAL** (semantic JSON diff, zero hunks) |

## Five RDP-0 patches — spot-verified in delivered artifacts

1. **Identity-domain arithmetic** — PASS: "19 original; active-now 19; after accepted migrations 15; target 12" — target not counterfeited as current.
2. **Lexical/static marking** — PASS (above).
3. **Qualified K0E + machine dispositions** — PASS (above).
4. **Resolved retry ≠ authorized supersession** — PASS: packet §F3 split into F3a/F3b with explicit anti-laundering clause ("must not be represented as a retry"; distinct tests).
5. **Inventory counts ≠ normative-coverage measurement** — PASS: M-5 amended — inventory is "the beginning of the coverage budget, not yet its measuring instrument"; traceability table named as the missing instrument.

## Reproduction numbers (mine, from scratch)

commit `f8842f8c37ed80c5d0bd89cbec40f2c203058c10` · identity domains 19 · conditions 61 (33 textually-signaled / 1 test-only / 27 textually-dormant) · event types 22 (6 declared-only) · roles 14 · laws 19 · F-tags 46 · dispositions: 61 = 37 live + 1 deferred + 16 future-lane + 4 docket + 3 merged.

## Environment note

SBCL 2.2.9 now installed user-locally (`~/.local/bin/sbcl` wrapper → `~/.local/sbcl-root`, `dpkg -x`, no root). The earlier apt/sudo attempt FAILED silently behind a pipeline exit code — caught by running `sbcl --version`, not by trusting exit status. Python 3.12.3.

## Standing

RDP-0 tooling lane: **REPRODUCED-IDENTICAL at `f8842f8`.** This strengthens the *advisory* packet's reliability; it confers nothing on KW-0, which remains blocked at intake for missing evidence. Nothing committed; artifacts in `_intake/` (untracked).
