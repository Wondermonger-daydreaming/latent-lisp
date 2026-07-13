# Rescue inventory successor — outer Git history addendum

Date: 2026-07-13 (America/Sao_Paulo)

This append-only successor corrects one omission in
`RESCUE-INVENTORY-2026-07-13.md`. The original file remains the authoritative
pre-preservation path/size inventory; this file adds the outer repository's
local-only Git history, discovered while auditing reconstruction sources for the
deletion plan.

## Added observation

`/home/gauss/Codex-Lab` is a separate outer Git repository. Its tracked worktree
is clean, but its local `main` is two commits ahead of its own remote:

```text
outer HEAD/main: 2c0929d1b12e917616d6ff2951c8cff6ea9c02a5
outer HEAD tree: e72c6cbdba0b4aadc6669451b8192e301aa81d35
outer upstream: origin/main
outer remote main: 76c9d27a70fc74037ee966644edee17020940262
ahead: 2
behind: 0
```

Local-only chain:

```text
76c9d27a70fc74037ee966644edee17020940262
  -> aa2fa3015768f3ad5616a76721ae592b2c64660a
     Archive counterexample waiting-room creation
  -> 2c0929d1b12e917616d6ff2951c8cff6ea9c02a5
     docs(diary): preserve CD0 errata session retrospective
```

The two commits contain archived creative/reflective artifacts and their
manifests. They are not part of latent-lisp CD/0 main and must not be pushed onto
or merged into that history. They are nevertheless valuable local-only history
and were Category B until separately bundled.

Outer Git admin/object-store size at inspection:

```text
path: /home/gauss/Codex-Lab/.git
apparent bytes: 2,985,491
allocated bytes: 8,294,400
loose objects: 1,325
reported loose-object disk use: 6.67 MiB
garbage: 0
```

The earlier bounded object enumeration found 1,318 outer objects reachable from
refs/reflogs and zero missing. The outer main history contains 8 commits and 576
unique blobs. A full-history high-risk scan across those blobs found zero
private-key headers, AWS/GitHub/OpenAI-like key shapes, or JWT shapes. Generic
credential-assignment terms occur in skill documentation and code examples;
no matching value was printed or classified as an actual credential.

## Preservation mechanism and exact artifact

The complete outer `main` history was preserved as a self-contained Git bundle
on the latent-lisp rescue branch:

```text
path: recovery-evidence/2026-07-13/outer-workspace/codex-lab-main-through-2c0929d.bundle
bytes: 2,561,721
sha256: dacbbd0de5e7329307929cabeebd65ddb720fd5cb1ff11973b44df789348a727
advertised ref: 2c0929d1b12e917616d6ff2951c8cff6ea9c02a5 refs/heads/main
bundle scope: complete history
hash algorithm: sha1
```

Creation command:

```text
git -C /home/gauss/Codex-Lab bundle create \
  /home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance/recovery-evidence/2026-07-13/outer-workspace/codex-lab-main-through-2c0929d.bundle \
  main
```

`git bundle verify` exited 0 and explicitly reported complete history. This
bundle was committed at:

```text
commit: 2ce886e7ff5e1940cbe712f764b4992564f98a2c
tree: e3ca13d617d84cf75b6f041bcdebc370174f6563
parent: f25351fe8c8f2c98510da79707b9035ad2b0ad66
```

The outer local branch and worktree remain untouched. No outer remote ref was
changed.

## Updated classification

- Category A/B preservation now includes the two outer local-only commits by an
  exact, verified bundle in ordinary Git on the rescue branch.
- The outer `.git` directory remains administrative state and must not itself
  be staged, deleted, pruned, repacked, or compacted.
- The original inventory's Category C/D/E classifications are unchanged.
- No valuable known local branch tip in either repository remains without a
  specified remote preservation mechanism once this successor is pushed and
  read back.
