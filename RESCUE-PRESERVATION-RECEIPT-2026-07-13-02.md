# Rescue preservation receipt successor — outer-history closure

Date: 2026-07-13 (America/Sao_Paulo)

This is an append-only successor to
`RESCUE-PRESERVATION-RECEIPT-2026-07-13.md`. The first receipt correctly
preserved every inventoried path and every latent-lisp local-only tip. A later
deletion-plan audit exposed one additional preservation obligation: the outer
Codex-Lab repository itself was two commits ahead of its separate remote.

No prior receipt or artifact was overwritten. No CD/0 or outer `main` reference
was modified.

## Added preservation obligation

```text
outer repository: /home/gauss/Codex-Lab
outer local main: 2c0929d1b12e917616d6ff2951c8cff6ea9c02a5
outer local tree: e72c6cbdba0b4aadc6669451b8192e301aa81d35
outer remote main: 76c9d27a70fc74037ee966644edee17020940262
ahead/behind: +2/-0
local-only commits: aa2fa3015768f3ad5616a76721ae592b2c64660a,
                    2c0929d1b12e917616d6ff2951c8cff6ea9c02a5
```

The commits preserve the counterexample waiting-room creation and a CD/0 errata
session retrospective. Their factual/theatrical boundaries are already recorded
in their committed manifests. They belong to the outer archive repository, not
the latent-lisp constitutional mainline.

## Exact preservation artifact

```text
rescue path: recovery-evidence/2026-07-13/outer-workspace/codex-lab-main-through-2c0929d.bundle
bytes: 2,561,721
sha256: dacbbd0de5e7329307929cabeebd65ddb720fd5cb1ff11973b44df789348a727
advertised ref: 2c0929d1b12e917616d6ff2951c8cff6ea9c02a5 refs/heads/main
bundle verification: complete history, sha1 object format, exit 0
```

The bundle's staged diff contained one binary file and 2,561,721 staged bytes;
`git diff --cached --check` passed. Before creation, 576 unique blobs across all
8 outer-history commits were screened for high-risk key/token/JWT shapes with
zero hits. Generic credential terminology in skill references was not treated as
a secret value. No value was printed.

Bundle commit:

```text
commit: 2ce886e7ff5e1940cbe712f764b4992564f98a2c
tree: e3ca13d617d84cf75b6f041bcdebc370174f6563
parent: f25351fe8c8f2c98510da79707b9035ad2b0ad66
subject: rescue: preserve outer Codex-Lab local history
```

## Exact push and read-back

Push command:

```text
git push origin refs/heads/rescue/cd0-disk-full-2026-07-13:refs/heads/rescue/cd0-disk-full-2026-07-13
```

Observed non-force result:

```text
f25351f..2ce886e  rescue/cd0-disk-full-2026-07-13 -> rescue/cd0-disk-full-2026-07-13
exit 0
```

Live read-back command and result:

```text
git ls-remote --heads origin rescue/cd0-disk-full-2026-07-13
2ce886e7ff5e1940cbe712f764b4992564f98a2c  refs/heads/rescue/cd0-disk-full-2026-07-13
exit 0
```

The remote object ID binds the verified bundle blob and the full prior rescue
history. Existing remote `main` and all historical CD/0 heads were unchanged by
this push.

## Updated preservation totals

Before this successor receipt itself:

```text
preserved working-tree files: 12
preserved working-tree bytes: 4,257,485
latent-lisp local-only tips anchored: 7
outer local-only commits bundled: 2
valuable known local branch tips without remote preservation mechanism: 0
```

The 12 files comprise the 11 files counted by the first receipt plus the
2,561,721-byte complete outer-history bundle. This successor inventory and
receipt are archived by their subsequent commit; their own final commit/tree
and remote read-back are recorded externally to avoid recursive self-reference.

## Reconstruction

After obtaining this bundle from the verified rescue ref, a separate destination
can be reconstructed without changing the current outer repository:

```text
git bundle verify codex-lab-main-through-2c0929d.bundle
git clone codex-lab-main-through-2c0929d.bundle codex-lab-rescued
git -C codex-lab-rescued rev-parse HEAD HEAD^{tree}
```

Expected identities are `2c0929d1...` and `e72c6cbd...`. These commands were
not run in this low-space session because verification of the complete bundle
was sufficient for preservation and a clone would create redundant data.

## Boundary

- The outer local `main` remains ahead of its remote and was not pushed.
- No unrelated remote ref was added; the existing rescue ref alone was
  fast-forwarded.
- No Category C/D material was deleted.
- No post-merge suite, freeze, tag, courtesy correction, or located-claim
  identity work was started.
