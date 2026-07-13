# CD/0 Common Lisp seed source-access log

Recorded from `2026-07-13T01:38:15-03:00` onward in worktree
`/home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp` on branch
`cd0-common-lisp`.

## Normative gate and seed baseline

| Item | Recorded value |
|---|---|
| Specification path | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Seed pre-change HEAD | `520034e9dd60dc1ea92cbd5d2e9d7a4f289d2a26` |
| Seed pre-change tree | `a7771f21b58f8dbdf01b2b023900e750be94b62c` |
| Common Lisp | `SBCL 2.4.6` |
| Python | `Python 3.11.14` |

The digest matched before the specification was opened for the seed and before
any seed implementation file was authored.

## Repository files read as implementation input

1. `mneme/spec/CANONICAL-DATUM-SPEC.md` — read in full (2,276 lines); the sole
   semantic source for the codec.
2. `CANONICAL-DATUM-DIVERGENCES.md` — the Phase-0 A1--A9 ambiguity ledger.
3. `canonical-datum/schema/cd0-fixtures.schema.json` — shared fixture shape.
4. `canonical-datum/vectors/cd0-positive.jsonl` — 22 hand-authored positives,
   including all 17 Section-15 worked vectors.
5. `canonical-datum/vectors/cd0-negative.jsonl` — 71 hand-authored negative
   rows: 66 octet inputs and five host-input descriptors.
6. `canonical-datum/vectors/cd0-budgets.json` — named shared budgets.
7. `canonical-datum/vectors/cd0-distinct-pairs.json` — explicit disjoint-value
   pairs used to guard against equality collapse.
8. `canonical-datum/tools/verify_phase0.py` — allowed Phase-0 fixture verifier,
   read as fixture-verification infrastructure, not as a Python codec.
9. `canonical-datum/evidence/PHASE0-SOURCE-ACCESS.md` and
   `canonical-datum/evidence/PHASE0-VERIFICATION.md` — Phase-0 provenance and
   evidence boundaries.

The shared artifacts were first read at Phase-0 commit `520034e`, then reread
after fixture-only corrections `9e2b74b` and `7e7d8ae`.  Those corrections did
not add or expose either codec implementation.

The implementation agent also read the repository-local instructions supplied
in the task and `/home/gauss/.codex/skills/proof-carrying-change/SKILL.md`, which
is external process guidance and supplies no CD/0 semantics.

## Isolation assertion

No Python codec source, existing Common Lisp kernel or codec, `mneme-canon/0`,
claim/warrant/receipt/capability implementation, Language-A implementation, or
other v1 runtime source was opened or read. File-name discovery was limited to
the mandated specification, shared Phase-0 artifacts, git metadata, and files
authored for this seed. No source from another implementation worktree was
consulted.

## Authored files inspected during self-review

- `canonical-datum/common-lisp/package.lisp`
- `canonical-datum/common-lisp/cd0.lisp`
- `canonical-datum/common-lisp/tests.lisp`
- `canonical-datum/common-lisp/run-tests.lisp`
- `canonical-datum/common-lisp/lisp-plus-cd0.asd`
- `canonical-datum/common-lisp/README.md`
- this source-access log and the seed verification evidence

## First complete conformance gate

The first complete pre-differential suite passed before any Python codec source
was inspected.  After the corrected shared fixture commits, a fresh process and
the ASDF system both passed at `2026-07-13T02:12:14-03:00`: 22/22 positive
vectors, all 71 negative rows dispositioned, 66/66 octet negatives executed,
2/2 applicable host negatives executed, 12 resource retries, five declared
distinct pairs, and 2,453 assertions.  Three optional host importers are not
part of this API and are recorded as not applicable, rather than as passes.
