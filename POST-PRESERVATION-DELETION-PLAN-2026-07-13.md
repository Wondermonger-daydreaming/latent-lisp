# Post-preservation deletion plan — no deletion authorized

Date: 2026-07-13 (America/Sao_Paulo)

**Deletion executed: NO.** Every destructive command below is inert text for a
later, separate authorization. It must not be pasted as a block. Each target
requires a fresh status/hash/remote check immediately before any later action.

## Preservation gates already satisfied

```text
remote main: efe52efe3e0e5a24181ee324e18b23e266129104
remote rescue before this plan's archival commit:
  2ce886e7ff5e1940cbe712f764b4992564f98a2c
rescue branch: rescue/cd0-disk-full-2026-07-13
rescue bundle for outer main: complete through 2c0929d1...
known latent-lisp local-only tips anchored: 7/7
known outer local-only commits bundled: 2/2
```

No pre-existing remote ref was rewritten. The rescue ref was added and only
fast-forwarded. Before any deletion, re-run:

```text
git -C /home/gauss/Codex-Lab/latent-lisp ls-remote origin
git -C /home/gauss/Codex-Lab/latent-lisp rev-parse \
  rescue/cd0-disk-full-2026-07-13 \
  rescue/cd0-disk-full-2026-07-13^{tree}
git -C /home/gauss/Codex-Lab/latent-lisp status --porcelain=v2 --branch
```

Stop if any expected object ID, path inventory, or worktree status differs.

## Ranked recoverable-space summary

| Rank | Candidate | Bytes recoverable | Confidence | Preservation / reconstruction | Provenance risk | WSL/VHD effect |
|---:|---|---:|---|---|---|---|
| 1 | 13 secondary linked worktrees, retaining active main acceptance | 880,312,320 allocated | High after fresh clean-status/read-back | Exact commits/trees; remote heads or rescue ancestry; commands below | Low to medium; ignored originals in integration-errata require special check | Frees ext4 blocks; may not reduce Windows VHDX file size immediately |
| 2 | All cache/bytecode directories if worktrees are retained | 2,789,859 apparent | High as machine residue, not as reproducible bytes | No evidentiary reconstruction claim; committed Python sources remain | Low, but mtimes are weak interruption evidence already inventoried | Frees ext4 blocks only |
| 3 | Seven preserved outer standalone originals | 1,662,976 allocated | High for byte recovery; medium for human preference | Exact copies/hashes on remote rescue | Low data-loss risk, but removes convenient outer copies | Frees ext4 blocks only |
| 4 | Active `latent-lisp-cd0-main-acceptance` worktree | 595,779,584 allocated | Technically high, operationally low before freeze | Remote main exact; recreation command below | Medium: causes needless churn before continuation | Frees ext4 blocks; likely not host bytes until compaction |
| 5 | Historical `AUTO_MERGE` and prunable worktree metadata | Negligible / not measured | Low | Identities inventoried, but no benefit worth risk | High relative to bytes | No material benefit |
| 6 | Windows-side VHD compaction | At most the free ext4 blocks represented in VHD; not measured | Conditional | Requires exact VHD path, shutdown, backup, Windows admin tools | High if wrong disk/path or inadequate headroom | Only step here that may return VHDX bytes to C: |

Non-overlapping candidate recovery while retaining main acceptance is about
`882,413,568` allocated bytes (13 worktrees + preserved outer originals + outer
caches + the three main-acceptance cache directories). If main acceptance were
also removed later, the corresponding upper estimate is `1,477,849,088`
allocated bytes. These are filesystem allocation observations, not promised
Windows-host recovery.

The host volume had only 3.2 GiB free. Even the upper repository-only estimate
cannot by itself reach the requested 10 GiB host floor. Windows-side cleanup or
moving unrelated host data will still be necessary.

## 1. Safe build and package-cache cleanup

No dependency directory, virtual environment, or package-manager cache was
found in the relevant workspace. The only candidates are pytest metadata and
CPython 3.11 bytecode. Exact `.pyc` identity is not claimed reproducible because
the producing commands and source metadata were not retained. They are machine
residue, not PASS/failure evidence.

Proposed commands, only after a later explicit authorization and a new
`RESCUE-INVENTORY` comparison:

```bash
rm -rf -- '/home/gauss/Codex-Lab/Claude Skills/yijing/.pytest_cache'
rm -rf -- '/home/gauss/Codex-Lab/Claude Skills/yijing/scripts/.pytest_cache'
rm -rf -- '/home/gauss/Codex-Lab/tests/__pycache__'

rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-generator/canonical-datum/generator/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-generator/canonical-datum/generator/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-generator/canonical-datum/python/cd0/__pycache__'

rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/generator/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/generator/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/qualification/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/release/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata/canonical-datum/release/tests/__pycache__'

rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/generator/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/generator/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/integration/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/qualification/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/release/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-integration/canonical-datum/release/tests/__pycache__'

rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance/canonical-datum/release/__pycache__'

rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-phase0-fix/canonical-datum/tools/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python-errata/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python-errata/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python-fixes/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python-fixes/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-python/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-qualification/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-qualification/canonical-datum/python/tests/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-qualification/canonical-datum/qualification/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-release-runner/canonical-datum/python/cd0/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-release-runner/canonical-datum/release/__pycache__'
rm -rf -- '/home/gauss/Codex-Lab/latent-lisp-cd0-release-runner/canonical-datum/release/tests/__pycache__'
```

Reconstruction source is each committed `.py` file under the exact worktree
commit and CPython 3.11.14. No reconstruction command is supplied for exact
`.pyc` bytes because the original invocation and metadata are unknown; this is
why the files are Category D rather than claimed reproducible evidence.

## 2. Core dumps and crash debris

No core dump, crash dump, `.dmp`, `.crash`, incomplete download, or stale lock
file was found. Source files named `core.lisp` and `core.py` are project code,
not crash debris. Proposed deletion command: **none**.

Two historical `AUTO_MERGE` files and two missing `/tmp` worktree registrations
are not large enough to justify forensic risk. Do not delete or prune them.

## 3. Generated/materialized content already preserved remotely

The paths below are materialized clean Git worktrees. Their tracked bytes are
reconstructible exactly from the recorded commits; ignored Category-A evidence
from integration-errata is separately present on the verified rescue branch.

Run removal commands only from the primary repository, never from within the
target being removed. Normal `git worktree remove` is preferred after cache
cleanup. Integration-errata requires a specific force decision because its
ignored original Fable files are intentionally still present.

| Priority | Worktree | Allocated bytes | Exact commit/tree | Proposed removal command | Exact reconstruction command |
|---:|---|---:|---|---|---|
| 1 | `latent-lisp-cd0-integration-errata` | 596,090,880 | `369de53b...` / `13871b0b...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove --force /home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata 369de53bff4ef5edbd31db3428456fde58d90cf5` |
| 2 | `latent-lisp-cd0-integration` | 204,836,864 | `baeecd5e...` / `41d3a71c...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-integration` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-integration baeecd5e0347435b9e1362000344f46ea441c6ec` |
| 3 | `latent-lisp-cd0-release-runner` | 8,814,592 | `e515355f...` / `7f8d2a2d...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-release-runner` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-release-runner e515355f55593ff810e9cfe9f6c0529e3994f62a` |
| 4 | `latent-lisp-cd0-qualification` | 8,568,832 | `2496cdde...` / `0b2f631b...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-qualification` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-qualification 2496cddee7a1aa52a365ff219b22fa7522e51199` |
| 5 | `latent-lisp-cd0-final-evidence` | 8,445,952 | `3647ec9a...` / `9de45b0c...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-final-evidence` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-final-evidence 3647ec9a011b9b8a422041411dba13efaf5ea250` |
| 6 | `latent-lisp-cd0-generator` | 7,057,408 | `7e4c255a...` / `fb57f65c...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-generator` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-generator 7e4c255acceca346b023a34bc4b7794eeee61fb0` |
| 7 | `latent-lisp-cd0-python-fixes` | 6,864,896 | `db964524...` / `4584b4d7...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-python-fixes` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-python-fixes db964524ded723f0841188a322b13ac9896c67d6` |
| 8 | `latent-lisp-cd0-python-errata` | 6,807,552 | `5890235d...` / `14478ba8...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-python-errata` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-python-errata 5890235d9456031972b2ee7f40278d653dd1e6ae` |
| 9 | `latent-lisp-cd0-common-lisp-errata` | 6,660,096 | `ddadedf8...` / `c6107f2c...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp-errata` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp-errata ddadedf846afb6dff75fb8ffe449a8bbd03231df` |
| 10 | `latent-lisp-cd0-common-lisp-fixes` | 6,660,096 | `776385ef...` / `4c1c7c52...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp-fixes` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp-fixes 776385ef13865b78a803004d67f9d3661045fc61` |
| 11 | `latent-lisp-cd0-python` | 6,615,040 | `29d0946a...` / `b556bb85...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-python` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-python 29d0946ad78347015b9f0c65a2f528f039fdca78` |
| 12 | `latent-lisp-cd0-common-lisp` | 6,553,600 | `45eb60ce...` / `774a6673...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-common-lisp 45eb60ce5b80485a0b287feab53ed3b58643b1b0` |
| 13 | `latent-lisp-cd0-phase0-fix` | 6,336,512 | `12e113be...` / `46f4ba4d...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-phase0-fix` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add --detach /home/gauss/Codex-Lab/latent-lisp-cd0-phase0-fix 12e113be87a17654da60eb08f16b47106a25b794` |
| 14, defer | `latent-lisp-cd0-main-acceptance` | 595,779,584 | `efe52efe...` / `13871b0b...` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree remove /home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance` | `git -C /home/gauss/Codex-Lab/latent-lisp worktree add /home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance main` |

For every reconstructed worktree, verify:

```text
git -C <reconstructed-path> rev-parse HEAD HEAD^{tree}
git -C <reconstructed-path> status --porcelain=v2 --branch --untracked-files=all
```

Do not delete local branch refs after removing worktrees. Do not prune, gc,
repack, expire reflogs, or delete any remote ref.

## 4. Reproducible generated material

No untracked generated corpus, build tree, dependency tree, database, or
benchmark-output directory was found outside the cache files listed above.
Canonical corpora, projections, transcripts, archive parts, hashes, and release
summaries in the 13871b0b tree are tracked evidence, not deletion candidates.

The secondary worktree checkouts are the only large exact-reconstructible
material. Their reconstruction inputs are the precise commits in the table,
Git 2.43.0, and the shared object store or verified rescue/remote refs. Expected
output identities are the listed trees.

## 5. Large valuable material preserved outside ordinary Git

None remains in this category. The two previously special cases are now in
ordinary Git on the rescue branch:

- seven latent-lisp local-only histories via the rescue anchor;
- outer Codex-Lab local-only history via the verified complete bundle.

Do not delete either `/home/gauss/Codex-Lab/latent-lisp/.git` (466,473,706
apparent bytes) or `/home/gauss/Codex-Lab/.git` (2,985,491 apparent bytes).
Neither is a cache. No Git LFS or external release artifact is required for the
known rescue payload.

## 6. Valuable material not yet preserved

Known file/ref list: **none**, after the final successor receipt is pushed and
read back.

The exact stdout/stderr from the crashed process was not found; it is missing
evidence, not a deletable path. The final post-merge test transcripts, merge
receipts, and freeze declaration do not yet exist and therefore cannot be
claimed preserved.

## 7. WSL-level cleanup requiring Windows-side action

Microsoft documents that WSL 2 stores each distribution in an `ext4.vhdx` and
that the VHD grows dynamically. Microsoft also documents that `compact vdisk`
reduces a dynamically expanding VHD's physical file size and requires the VHD
to be detached or attached read-only. Sources:

- https://learn.microsoft.com/en-us/windows/wsl/disk-space
- https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/compact-vdisk
- https://learn.microsoft.com/en-us/powershell/module/hyper-v/optimize-vhd

The detected distribution name is `Ubuntu`. Proposed **read-only discovery** in
PowerShell:

```powershell
wsl.exe --list --verbose
$Distro = 'Ubuntu'
$Vhd = (Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss |
  Where-Object { $_.GetValue('DistributionName') -eq $Distro }).GetValue('BasePath') + '\ext4.vhdx'
Get-Item -LiteralPath $Vhd | Select-Object FullName, Length, LastWriteTime
Get-Volume -DriveLetter C | Select-Object DriveLetter, Size, SizeRemaining
```

Only after Linux-side deletion is separately authorized, completed, and
verified—and after an external backup and additional host headroom exist—the
proposed Windows administrative sequence is:

```powershell
wsl.exe --shutdown
Optimize-VHD -Path $Vhd -Mode Full -WhatIf
# Review the exact resolved path and WhatIf output. A later authorization would
# remove -WhatIf:
Optimize-VHD -Path $Vhd -Mode Full
```

If the Hyper-V cmdlet is unavailable, the documented DiskPart alternative is
interactive and must use the same resolved `$Vhd` path:

```text
diskpart
select vdisk file="<the exact path printed as $Vhd above>"
detail vdisk
compact vdisk
exit
```

No compaction command is authorized here. Do not use `wsl --unregister`; it
destroys a distribution. Microsoft warns against ordinary Windows tools/editors
modifying WSL AppData files. If the resolved path is not unambiguous, stop.

Because repository cleanup cannot supply the missing ~6.8 GiB to the 10 GiB
host threshold, inspect Windows Storage settings for unrelated large files and
move or delete them only under a separate human decision. No unknown host path
is nominated for deletion in this plan.

## 8. Uncertain material requiring human inspection

### Preserved outer originals

The seven outer files total 1,648,085 apparent bytes and have exact copies on
the rescue branch. Their original locations may still be convenient to humans.
After a fresh rescue hash check, proposed commands are:

```bash
rm -- '/home/gauss/Codex-Lab/GPT-PRO-V1-COUNTEREXAMPLE-CLOSURE-PACKET-2026-07-13.zip'
rm -- '/home/gauss/Codex-Lab/_staging/cd0-audit/FABLE-CD0-A9-CLOSURE-VERIFICATION.md'
rm -- '/home/gauss/Codex-Lab/_staging/cd0-audit/FABLE-CD0-TARGETED-VERIFICATION-REPORT.md'
rm -- '/home/gauss/Codex-Lab/codex-lab-diary-2026-07-13-02.manifest.md'
rm -- '/home/gauss/Codex-Lab/codex-lab-diary-2026-07-13-02.md'
rm -- '/home/gauss/Codex-Lab/codex-lab-diary-2026-07-13-02.tar.gz'
rm -- '/home/gauss/Codex-Lab/latent-lisp-audit-9e9c031.bundle'
```

Exact reconstruction source is the remote rescue tree. Example:

```bash
git -C /home/gauss/Codex-Lab/latent-lisp show \
  rescue/cd0-disk-full-2026-07-13:recovery-evidence/2026-07-13/fable/FABLE-CD0-A9-CLOSURE-VERIFICATION.md \
  > '/home/gauss/Codex-Lab/_staging/cd0-audit/FABLE-CD0-A9-CLOSURE-VERIFICATION.md'
```

Expected SHA-256 is
`96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e`.
The complete path/hash mapping is in both rescue receipts.

### Historical Git metadata

The stale `AUTO_MERGE` files and two prunable `/tmp` worktree registrations are
forensic metadata with negligible recoverable bytes. Proposed deletion command:
**none**. Human inspection should decide only after the freeze is complete.

### Outer local main

Outer `main` remains intentionally `+2/-0`. The complete bundle now protects
that history, but the local branch is the most intelligible working copy. Do not
reset it, force-push it, or delete its `.git` directory. A future decision may
non-force push a separately named archive branch in the outer repository; that
is outside this authorization.

## Final deletion ledger

```text
deletion executed: NO
files removed: 0
worktrees removed: 0
refs deleted: 0
remote refs rewritten: 0
gc/prune/repack/compaction performed: NO
```
