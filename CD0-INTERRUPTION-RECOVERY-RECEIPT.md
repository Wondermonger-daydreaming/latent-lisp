# CD/0 interruption recovery receipt

Date: 2026-07-13 (America/Sao_Paulo)

Status at this receipt: **STATE D — authorized merge already pushed**. This
receipt records the pre-rescue state. It is not a post-merge test receipt or a
freeze declaration.

## Identity boundary and correction ledger

The initial current directory, `/home/gauss/Codex-Lab`, is an outer archive
repository. Its Git history does not contain the authoritative CD/0 objects.
An initial read-only `git ls-remote --heads origin` therefore queried the outer
`Codex-Lab.git` remote and returned its unrelated `main` at `76c9d27a...`.
Inspection of linked repositories and the Fable receipt then identified the
actual subject repository as:

```text
/home/gauss/Codex-Lab/latent-lisp
acceptance worktree: /home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance
remote: https://github.com/Wondermonger-daydreaming/latent-lisp.git
```

The outer-remote observation is retained here because it affected the
investigation, but it is **superseded for every CD/0 identity claim** by the
subject-repository evidence below.

| Trace | Kind | Statement | Evidence | Status/consequence |
|---|---|---|---|---|
| T001 | user-stated | The interrupted host ran out of Windows disk and the prior Codex process ended after WSL I/O/bus failures. | Recovery prompt, 2026-07-13 | Active as incident context; no surviving crash transcript was found. |
| T002 | observed | The outer Codex-Lab Git repository is not the CD/0 subject repository. | Missing authoritative objects in outer object database; linked-worktree discovery | Active; prevents a false remote-main classification. |
| T003 | observed | The actual latent-lisp remote `main` is the exact valid authorized merge. | Live `git ls-remote`, commit/tree/parent inspection, empty second-parent diff | Active; classifies State D. |
| T004 | observed | The interrupted run pushed the merge, then began Python activity, but produced no authoritative post-merge receipt. | `origin/main` push reflog at 18:29:03; three `.pyc` mtimes at 18:30; requested receipt names absent | Active; bytecode is not a test verdict. |
| T005 | observed | Host-volume free space is below the continuation threshold. | `df -hT /mnt/c`: 3.2 GiB available, 98% used | Active; blocks the post-merge suite and freeze in this run. |

## Phase 0 filesystem health gate

Observed at `2026-07-13T18:47:18-03:00`:

```text
current directory: /home/gauss/Codex-Lab
outer repository root: /home/gauss/Codex-Lab
WSL root: /dev/sdd ext4, 1007 GiB total, 929 GiB available, 3% used
Windows host mount: C:\ via 9p, 112 GiB total, 3.2 GiB available, 98% used
WSL inodes: 67,108,864 total; 66,633,893 free; 1% used
/mnt/c inode report: synthetic 9p values; not a meaningful finite inode count
```

Two independent 17-byte probes, one in `/tmp` and one under the outer
repository root, were created, fsynced, read through `cat`, hashed through both
Python SHA-256 and `sha256sum`, inspected with `stat`, and automatically removed.
Both hashes were:

```text
131054cb420f4770484e56022485e4f826cae8bdf0cef0304f0f89f163be9f31
```

`git 2.43.0`, GNU `sha256sum`/`cat`/`stat` 9.4, and GNU `find` 4.9.0
executed normally. No Input/output error, no-space error, bus error,
read-only-filesystem error, unexpected truncation, or Git corruption was
observed in this recovery session.

The WSL filesystem passed the requested 5 GiB floor. The Windows host did not
pass the requested 10 GiB floor, so this run is restricted to lightweight
inventory and rescue preservation. No post-merge test suite may be started
under this receipt.

## Authoritative Fable receipt

The receipt was hashed and read in full before any repository reference was
changed:

```text
path: /home/gauss/Codex-Lab/_staging/cd0-audit/FABLE-CD0-A9-CLOSURE-VERIFICATION.md
size: 6,199 bytes
sha256: 96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e
protocol: 49b3cf88
verdict: PASS
authorization: 369de53bff4ef5edbd31db3428456fde58d90cf5 is eligible for merge into main
```

The user-stated Fable lab abbreviation `1898cd9b` is not present in either the
outer or subject local object database. No nearby object was substituted. The
exact receipt, protocol, authorized commit, and reviewed tree provide the local
authority used here.

## Pre-rescue Git state

```text
current branch: main
HEAD: efe52efe3e0e5a24181ee324e18b23e266129104
HEAD tree: 13871b0b0ec81e667611163bc78976b3a91ff4b7
local main: efe52efe3e0e5a24181ee324e18b23e266129104
local main tree: 13871b0b0ec81e667611163bc78976b3a91ff4b7
upstream: origin/main, ahead 0, behind 0
live remote main: efe52efe3e0e5a24181ee324e18b23e266129104
```

Merge identity:

```text
merge: efe52efe3e0e5a24181ee324e18b23e266129104
tree: 13871b0b0ec81e667611163bc78976b3a91ff4b7
parent 1: ae767f00975395369f9a91283a954f0963fb6724
parent 2: 369de53bff4ef5edbd31db3428456fde58d90cf5
authorized integration tree: 13871b0b0ec81e667611163bc78976b3a91ff4b7
```

`git diff --quiet 369de53b... efe52efe...` exited 0. The merge tree is
therefore exactly the reviewed integration tree; the merge introduced no
merge-only content. Its message identifies Lisp+ Canonical Datum /0, the exact
authorized commit, Fable protocol and receipt hash, the ruling and errata, and
the unchanged canonical bytes, equality, accepted documents, wire grammar,
datum version, and v1 semantics.

Live remote heads before rescue:

```text
45eb60ce5b80485a0b287feab53ed3b58643b1b0  cd0-common-lisp
baeecd5e0347435b9e1362000344f46ea441c6ec  cd0-integration
29d0946ad78347015b9f0c65a2f528f039fdca78  cd0-python
ddadedf846afb6dff75fb8ffe449a8bbd03231df  codex/cd0-common-lisp-errata-0.1
369de53bff4ef5edbd31db3428456fde58d90cf5  codex/cd0-integration-errata-0.1
5890235d9456031972b2ee7f40278d653dd1e6ae  codex/cd0-python-errata-0.1
1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48  codex/v1-counterexample-closure
efe52efe3e0e5a24181ee324e18b23e266129104  main
```

There were no remote tags and no rescue ref. No pre-existing remote reference
was changed by this recovery investigation.

## Interrupted progression

The main-acceptance reflogs record:

```text
2026-07-13T18:28:12-03:00  worktree initialized at 1d16ff8...
2026-07-13T18:28:13-03:00  reset: moving to its existing HEAD
2026-07-13T18:28:18-03:00  main fast-forwarded to ae767f0...
2026-07-13T18:28:31-03:00  conflict-free ort merge of 369de53... created efe52ef...
2026-07-13T18:29:03-03:00  refs/remotes/origin/main: update by push
```

Git metadata preserves the merge target and strategy result, but not every
original command-line flag. The exact original merge and push command strings
are therefore unrecoverable and will not be invented.

Three ignored CPython 3.11 bytecode files in the main-acceptance worktree have
mtimes from 18:30:15 through 18:30:37. They establish that Python code was
loaded after the push, but they do not establish a command, exit code, count,
hash, PASS, or failure. No stdout/stderr transcript from that activity was
found.

The following requested products did not exist anywhere in the workspace at
inventory time: `CD0-MERGE-RECEIPT.md`,
`CD0-MAIN-READBACK-RECEIPT.md`, `CD0-POST-MERGE-VERIFICATION.md`,
`CD0-FREEZE-DECLARATION.md`, `CD0-MERGE-SHA256SUMS.txt`, any rescue
receipt, and the post-preservation deletion plan. The failed run therefore
completed merge and push, but not an evidentiary read-back, final receipts, or
freeze.

## Operation metadata and object readability

No `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REBASE_HEAD`, `REVERT_HEAD`,
`BISECT_LOG`, `MERGE_MSG`, `SQUASH_MSG`, sequencer, rebase-merge, or
rebase-apply state exists in any registered worktree.

Two historical `AUTO_MERGE` tree files remain in the Common Lisp and Python
worktree Git directories. Their mtimes align with 02:45–02:46 historical work,
not the 18:28 acceptance merge:

```text
Common Lisp tree: 774a6673bc44d61f641becbacde20b270bfe393b
AUTO_MERGE file sha256: c23a5fabb7e4b410f68df0a6aa68a956f527c56521e3982d3a2b7e9e63f2a05f
Python tree: b556bb85d47c87b3bc89644cf58534adab0afd1c
AUTO_MERGE file sha256: e95263f3dd5d0032a1e1142c3727844e9c0b8fe30c5b5ac6f58cb88ab0fc7fe7
```

They are retained as evidence and were not removed.

Two detached `/tmp` worktree registrations point to absent directories and are
marked prunable. Their metadata and indexes remain at commits `bdb2214878...`
and `59fdd5b65...`; no pruning was performed.

Lightweight object checks reported 1,045 loose objects (377.14 MiB), 1,563
packed objects in two packs (68.89 MiB), zero garbage, 2,135 objects reachable
from refs or reflogs, and zero missing objects. All branch, remote-tracking, and
tag ref objects were readable. This is a bounded readability check, not a
claim of storage-medium perfection.

## Ancestry evidence

Each arrow below was checked with `git merge-base --is-ancestor` and exited 0:

```text
baeecd5e -> 851cffc2 -> 64988991 -> 3f37c846 -> 2722213d -> 369de53b
baeecd5e -> 369de53b
ae767f00 -> efe52efe
369de53b -> efe52efe
45eb60ce and ee3baa9a -> ddadedf8
29d0946a and 9f46a323 -> 5890235d
```

This covers the audited integration tip, first errata successor, focused
two-vector source/verification/archive successor chain, both codec successor
chains, the expected old main, and the authorized integration parent.

## State classification

**STATE D** applies. Remote `main` no longer equals old main `ae767f00...`, but
it is provably the valid merge created by the interrupted task, with exact
parents, exact reviewed tree, required message identities, and no unauthorized
CD/0 content. The merge must not be repeated or replaced.

## Residual uncertainty and hard boundary

- The exact host crash output was not present in the workspace and was not
  reconstructed from shell history.
- The post-push Python commands and their exit status are unknown.
- A fresh isolated clone and the bounded post-merge suite remain required.
- Because `/mnt/c` has only 3.2 GiB free, those steps and the freeze are outside
  the safe scope of this recovery run.
- Located-claim identity work was not started.
