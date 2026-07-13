# CD/0 Phase 0 source-access log

Recorded at `2026-07-13T01:31:45-03:00` in worktree
`/home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp` on branch
`cd0-common-lisp`.

## Normative gate and baseline

| Item | Recorded value |
|---|---|
| Specification path | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Pre-change HEAD | `ae767f00975395369f9a91283a954f0963fb6724` |
| Pre-change tree | `b8f5be6d532eafe5be0d1f342347fa10f5f39352` |
| Common Lisp | `SBCL 2.4.6` |
| Python | `Python 3.11.14` |

The digest matched before the specification was read and before any worktree
file was changed.

## Files read as input

1. `/home/gauss/Codex-Lab/AGENTS.md` — repository-local standing instructions,
   read in full.
2. `mneme/spec/CANONICAL-DATUM-SPEC.md` — sole semantic source, read in full
   (2,276 lines) only after its digest passed.
3. `/home/gauss/.codex/skills/proof-carrying-change/SKILL.md` — external process
   guidance, read in full; it supplied no CD/0 semantics.

The Phase-0 verifier subsequently reads only the normative specification and
the positive, negative, budget, and schema artifacts listed below.

## Newly authored files inspected during final review

- `canonical-datum/vectors/cd0-positive.jsonl`
- `canonical-datum/vectors/cd0-negative.jsonl`
- `canonical-datum/vectors/cd0-budgets.json`
- `canonical-datum/schema/cd0-fixtures.schema.json`
- `canonical-datum/tools/verify_phase0.py`
- `CANONICAL-DATUM-DIVERGENCES.md`
- this evidence directory's two Markdown records

## Isolation assertion

No existing Common Lisp codec, Python codec, v1 kernel, `mneme-canon/0`, claim,
warrant, receipt, capability, Language-A implementation, or Python worktree
source file was opened or read.  File-name discovery was limited to locating the
specification and applicable `AGENTS.md`; git metadata and runtime version
commands did not inspect implementation source.

No Python implementation source was consulted.  No full Common Lisp or Python
codec was authored in Phase 0.
