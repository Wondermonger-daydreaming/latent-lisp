# CD/0 Python seed source-access log

This log covers the independent seed work in
`/home/gauss/Codex-Lab/latent-lisp-cd0-python` on branch `cd0-python`.
Source isolation is procedural and auditable; it is not represented as an
operating-system information-flow proof.

## Normative gate and baseline

Recorded before implementation at `2026-07-13T01:35:54-03:00`:

| Item | Recorded value |
|---|---|
| Specification path | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Pre-change HEAD | `0306d0a1b9af67d843754cbb49c434d9428c041c` |
| Pre-change tree | `a7771f21b58f8dbdf01b2b023900e750be94b62c` |
| Common Lisp runtime | `SBCL 2.4.6` |
| Python runtime | `Python 3.11.14` |

The digest matched before the specification was opened and before any Python
seed file was authored.

## Semantic and fixture inputs read

The Python implementer opened only these pre-existing repository files:

1. `mneme/spec/CANONICAL-DATUM-SPEC.md` — read in full, all 2,276 lines;
2. `canonical-datum/schema/cd0-fixtures.schema.json`;
3. `canonical-datum/vectors/cd0-positive.jsonl`;
4. `canonical-datum/vectors/cd0-negative.jsonl`;
5. `canonical-datum/vectors/cd0-budgets.json`;
6. `canonical-datum/tools/verify_phase0.py`;
7. `canonical-datum/evidence/PHASE0-VERIFICATION.md`;
8. `canonical-datum/evidence/PHASE0-SOURCE-ACCESS.md`;
9. `CANONICAL-DATUM-DIVERGENCES.md`.

After the first complete green run, the shared Phase-0 correction was applied as
worktree commit `80d970afbf74f0c7d9400ff6617097b5c10c7726` (source commit
`e86ecfb`).  The implementer then reread only its corrected shared artifacts:

- the schema, positive/negative vectors, budgets, verifier, and divergence
  ledger already named above;
- `canonical-datum/vectors/cd0-distinct-pairs.json`;
- `canonical-datum/evidence/PHASE0-CORRECTION-SOURCE-ACCESS.md`;
- `canonical-datum/evidence/PHASE0-CORRECTION-VERIFICATION.md`.

The equality-class follow-up was applied as
`7981aac916dff8f3913be621edb437dd0843c796` (source commit `12e113b`).
The implementer inspected its changes to the shared verifier and read
`canonical-datum/evidence/PHASE0-CORRECTION-2-VERIFICATION.md`.  The
pre-Python-seed shared HEAD/tree were therefore:

```text
7981aac916dff8f3913be621edb437dd0843c796
46f4ba4d784cb30dcdad7b1144c2b5950e964524
```

The repository-local `AGENTS.md` instructions were supplied verbatim in the
task message.  `/home/gauss/.codex/skills/proof-carrying-change/SKILL.md` was
also read in full as process guidance; it supplied no datum semantics.

Directory-name discovery, Git metadata/status, runtime version commands, file
hashing, byte counts, and the tests' reading of the listed shared fixtures did
not inspect other implementation source.

## Files authored and then inspected or executed

- `canonical-datum/python/cd0/__init__.py`;
- `canonical-datum/python/tests/test_cd0.py`;
- `canonical-datum/python/README.md`;
- `canonical-datum/python/.gitignore`;
- `canonical-datum/evidence/PYTHON-SEED-SOURCE-ACCESS.md`;
- `canonical-datum/evidence/PYTHON-SEED-VERIFICATION.md`;
- `canonical-datum/evidence/PYTHON-SEED-RECEIPT.md`.

Python standard-library modules imported by the implementation or tests are
runtime dependencies, not repository semantic sources.

## Isolation assertion

Before the first complete green run, and throughout the seed task, the Python
implementer did **not** open or read:

- any Common Lisp CD/0 implementation or test source;
- the existing v1 kernel or any other existing codec implementation;
- `mneme-canon/0` implementation source;
- claim, warrant, receipt, capability, certificate, or authority
  implementation source;
- Language-A implementation source;
- source files in the Common Lisp worktree.

No comparison with another codec implementation occurred in this seed.  The
first complete green Python run was reached using only the pinned specification,
the shared Phase-0 artifacts above, and files authored in this worktree.
