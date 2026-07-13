# CD/0 demonstrated-primary release minimum correction

Date: 2026-07-13 (America/Sao_Paulo)

## Scope

This focused correction began from clean generator-v2 commit
`83517a70df097dea9fad95879ef118986737c7f0`, tree
`2fc56a346cee08d51fe6fab0d9d606ef9b91b94f`.  The pinned normative
specification remained SHA-256
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.

Generator v2 correctly made its padding family
`byte-deletion-primary-minimal`, but its release threshold still counted the
308 authored/host coverage rows toward the Section 28.3 minimum.  Thus a
20,000-total run would contain only 19,692 rows with a demonstrated scoped
primary-minimal proof.  This correction changes qualification, not CD/0 datum
semantics:

- at least 10,000 positives;
- at least 20,000 total classified adversarial rows; and independently
- at least 20,000 `byte-deletion-primary-minimal` rows.

The 308 coverage rows remain in the corpus in addition to that minimum.  The
preferred/default release `--negative-count` is therefore 20,308.  A
20,000-total release is refused before in-memory generation or publication.

## Evidence receipt

| ID | Obligation | Evidence | Status | Boundary |
|---|---|---|---|---|
| M1 | Give the demonstrated-primary requirement a stable named threshold | `RELEASE_PRIMARY_MINIMIZED_MINIMUM = 20000`; manifest records threshold and observed count | satisfied | proof remains scoped to removal of the declared primary input-length defect |
| M2 | Keep coverage rows without letting them satisfy the minimum | seed count is pinned to 308; manifest reports coverage and demonstrated counts separately | satisfied | changing seeded coverage requires explicit evidence/count review |
| M3 | Qualify only when positive, total-adversarial, and demonstrated-primary minima all pass | shared `release_qualifies` predicate drives manifest and release refusal | satisfied | finite generator checks are not cross-codec conformance evidence |
| M4 | Refuse a 20,000-total release before publication | focused CLI test supplies 10,000/20,000 and observes typed generator refusal with no output path | satisfied | no full corpus is constructed by the test because argument preflight refuses first |
| M5 | Make the reproducible release command exact | README/default/manifest prefer 10,000 positives and 20,308 adversarial rows | satisfied | release execution remains owned by integration |
| I1 | Preserve A1--A9 and protected source boundaries | only generator source/tests/README and this note change | satisfied | no codec, integration, spec, divergence-ledger, or v1 edit |

## Verification

```text
python3 -m py_compile canonical-datum/generator/generate_corpus.py
python3 canonical-datum/tools/verify_phase0.py
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

The final source verification passed: Phase 0 remained pinned and all 27
generator tests passed.  The suite still performs two byte-identical small
generations under `PYTHONHASHSEED=1` and `777`; new assertions independently
exercise all three qualification boundaries, the 20,000-total refusal, the
20,308 default, and separate coverage/demonstrated manifest counts.

No 10,000/20,308 bulk corpus was generated in this worktree.
