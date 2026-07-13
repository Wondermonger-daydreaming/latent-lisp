# Rescue inventory — 2026-07-13

Inventory vantage: read-only snapshot completed at
`2026-07-13T18:56:29-03:00`, before creation of any rescue reference.

Subject object store: `/home/gauss/Codex-Lab/latent-lisp/.git`

Acceptance worktree:
`/home/gauss/Codex-Lab/latent-lisp-cd0-main-acceptance`

Outer forensic container: `/home/gauss/Codex-Lab`

No inventory command returned an I/O, no-space, bus, read-only-filesystem,
corruption, or truncation error. No file was deleted, normalized, regenerated,
or replaced.

## Additive category totals

These apparent-byte totals do not double-count paths and sum to all outer
untracked containers/files plus outer ignored files at the snapshot:

| Category | Paths/scope | Apparent bytes | Disposition |
|---|---:|---:|---|
| A — exact evidence | 10 path instances; 8 distinct blobs | 1,671,571 | Preserve on rescue branch. |
| B — valuable shared Git state | one shared admin/object store; seven local-only tips | 466,473,706 | Preserve by a non-force rescue reachability anchor; do not copy the object store as a working-tree directory. |
| C — clean reconstructible checkouts | tracked checkout/admin-file bytes outside shared `.git` | 1,447,185,836 | Deletable only after verified rescue and remote preservation, and only with later explicit authorization. |
| D — machine/cache residue | 50 bytecode/cache files | 2,789,859 | Do not preserve in Git; do not delete in this session. |
| E — sensitive/unknown | no filename candidate | 0 | Archive internals received a bounded high-risk secret-pattern scan; human review remains the final boundary. |
| **Total** |  | **1,918,120,972** |  |

Gross allocated bytes for all nested containers were `1,953,284,096`; the
seven standalone outer evidence files allocated `1,662,976` bytes. Apparent
and allocated size differ because of filesystem block allocation.

## Category A — must preserve in ordinary Git

All entries below were nonzero and readable. `??` means untracked and not
ignored by the outer repository. `!!` means ignored in the named latent-lisp
worktree. The ZIP, tar archive, and bundle passed their structural verification
commands. The diary manifest hashes match its source and archive, and its tar
contains only the diary. The two Fable path pairs are byte-identical duplicates;
both original path instances remain untouched, while one exact copy of each
distinct blob is sufficient in the rescue payload when the omitted duplicate
paths are documented.

| Original path relative to `/home/gauss/Codex-Lab` | Bytes | Mtime (-03:00) | Status | Type / completeness | SHA-256 | Role |
|---|---:|---|---|---|---|---|
| `GPT-PRO-V1-COUNTEREXAMPLE-CLOSURE-PACKET-2026-07-13.zip` | 46,328 | 2026-07-13 00:08:44.737303707 | `??`, not ignored | binary ZIP; `unzip -t` passed; 5 benign members | `cee06bd06f35f6a26cc5bcd8e9c8fa270805b75424d916a4fadecf757dfe9bce` | Exact prior v1 closure packet; separate constitutional arc, retained without reopening it. |
| `_staging/cd0-audit/FABLE-CD0-A9-CLOSURE-VERIFICATION.md` | 6,199 | 2026-07-13 18:21:05.178799991 | `??`, not ignored | text; full-read, complete | `96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e` | Authoritative focused PASS receipt. |
| `_staging/cd0-audit/FABLE-CD0-TARGETED-VERIFICATION-REPORT.md` | 10,011 | 2026-07-13 16:51:19.634793910 | `??`, not ignored | text; nonzero, complete on inspection | `67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b` | Earlier targeted-return report and evidentiary context. |
| `codex-lab-diary-2026-07-13-02.manifest.md` | 1,856 | 2026-07-13 04:23:07.074758271 | `??`, not ignored | text; manifest hashes verified | `fea4d3f8d4e422d7b9fa2a377997ff64ebc2553ed130e895bcf091925473d4f4` | Provenance manifest for the archived diary. |
| `codex-lab-diary-2026-07-13-02.md` | 13,014 | 2026-07-13 04:22:38.078835233 | `??`, not ignored | text; complete | `51820c1b7d9010022d34beedd081be45f874736d30dda0750e7e758bf53c0a6d` | Substantial archived reflective artifact, outside CD/0 truth claims. |
| `codex-lab-diary-2026-07-13-02.tar.gz` | 6,202 | 2026-07-13 04:22:45.874817201 | `??`, not ignored | binary gzip/tar; gzip and listing passed | `0133208ff7dd6510489caa54fcd96218f9e9ddcd8bb7595aa115155307b5e69f` | Reproducible exact diary archive. |
| `latent-lisp-audit-9e9c031.bundle` | 1,564,475 | 2026-07-12 23:36:51.361592494 | `??`, not ignored | binary Git bundle; `git bundle verify` passed | `9439d8f3509a8e6c43bab946f9401aa1cbdb971add078fe596178c5bde58b35b` | Complete history for `backup/audit-9e9c031`. |
| `latent-lisp-cd0-integration-errata/_staging/cd0-audit/CD0-A9-TWO-VECTOR-FINAL-CHANGED-FILES.txt` | 7,276 | 2026-07-13 17:21:20.449291558 | `!!`, ignored | text; complete path manifest | `128eac42b4b930f57b703a5f10a684dbc27e6908b781ff514eab4928df124970` | Unique final reviewed-delta path list. |
| `latent-lisp-cd0-integration-errata/_staging/cd0-audit/FABLE-CD0-A9-CLOSURE-VERIFICATION.md` | 6,199 | 2026-07-13 18:21:05.184680510 | `!!`, ignored | text; exact duplicate of outer receipt | `96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e` | Ignored original path instance. |
| `latent-lisp-cd0-integration-errata/_staging/cd0-audit/FABLE-CD0-TARGETED-VERIFICATION-REPORT.md` | 10,011 | 2026-07-13 16:51:19.673393884 | `!!`, ignored | text; exact duplicate of outer report | `67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b` | Ignored original path instance. |

Distinct Category-A payload size is `1,655,361` bytes. Exact source bytes,
not regenerated substitutes, are recommended for rescue. None of these files
is a PASS merely by being archived: the Fable receipt is an external audit
verdict; the changed-file list is a manifest; the archives are byte containers;
and the diary is reflective prose.

Bounded secret screening before preservation found no private-key header,
AWS-key shape, GitHub-token shape, OpenAI-like key shape, or credential
assignment in the ZIP/tar members or the audit-bundle tip tree. Only member or
path names would have been reported; no secret value was printed. This is a
pattern scan, not a guarantee that arbitrary prose contains no sensitive fact.

## Category B — valuable state requiring a Git reachability mechanism

The shared object/admin store is:

```text
/home/gauss/Codex-Lab/latent-lisp/.git
apparent bytes: 466,473,706
allocated bytes: 471,470,080
loose objects: 1,045 / 377.14 MiB
packed objects: 1,563 in 2 packs / 68.89 MiB
```

It is the single admin/object store for all linked worktrees and must never be
staged as a directory. Seven clean historical tips are not contained in any
current local remote-tracking ref and are not covered by the existing audit
bundle:

| Local branch | Commit | Tree | Purpose | Reproducible? | Proposed mechanism |
|---|---|---|---|---|---|
| `cd0-final-evidence-draft` | `3647ec9a011b9b8a422041411dba13efaf5ea250` | `9de45b0c...` | Final-evidence drafting history | No equivalent remote history observed | Additional parent of rescue reachability anchor |
| `cd0-generator-stage` | `7e4c255acceca346b023a34bc4b7794eeee61fb0` | `fb57f65c...` | Generator-stage history | No | Additional parent of rescue reachability anchor |
| `cd0-integration-common-lisp-fixes` | `776385ef13865b78a803004d67f9d3661045fc61` | `4c1c7c52...` | Common Lisp integration-fix history | No | Additional parent of rescue reachability anchor |
| `cd0-integration-python-fixes` | `db964524ded723f0841188a322b13ac9896c67d6` | `4584b4d7...` | Python integration-fix history | No | Additional parent of rescue reachability anchor |
| `cd0-phase0-fix` | `12e113be87a17654da60eb08f16b47106a25b794` | `46f4ba4d...` | Phase-0 fix history | No | Additional parent of rescue reachability anchor |
| `cd0-qualification-stage` | `2496cddee7a1aa52a365ff219b22fa7522e51199` | `0b2f631b...` | Qualification-stage history | No | Additional parent of rescue reachability anchor |
| `cd0-release-runner-stage` | `e515355f55593ff810e9cfe9f6c0529e3994f62a` | `7f8d2a2d...` | Release-runner-stage history | No | Additional parent of rescue reachability anchor |

The proposed anchor is a new commit only on the dedicated rescue branch. Its
first parent will be the rescue evidence commit, its additional parents will be
the seven exact tips above, and its tree will equal its first parent's tree.
That structure preserves reachability without pretending to semantically merge
or select the other parent trees. It will not alter or rewrite any existing
branch. A verified remote rescue ref is the preservation mechanism; Git LFS or
an external backup is not required for these Git objects.

Until that remote anchor is verified, Category B is valuable unpreserved data.

## Category C — clean checkouts, deletable only after verified preservation

Every listed worktree had zero staged, modified, deleted, renamed, or unmerged
tracked paths. The outer repository sees each as an untracked directory; the
subject repository sees it as a linked clean worktree. Sizes include tracked
checkout files plus separately identified residue. Reconstruction requires Git
2.43.0, the shared object database or a remote containing the exact commit, and:

```text
git -C /home/gauss/Codex-Lab/latent-lisp worktree add <path> <exact-commit-or-preserved-branch>
git -C <path> rev-parse HEAD HEAD^{tree}
```

Expected output identity is the exact commit/tree pair below. The command
reconstructs tracked content only; it does not reconstruct ignored evidence or
bytecode.

| Worktree suffix (`latent-lisp-cd0-...`) | Branch | HEAD | Tree | Apparent bytes | Residue | Preservation status at snapshot |
|---|---|---|---|---:|---|---|
| `common-lisp-errata` | `codex/cd0-common-lisp-errata-0.1` | `ddadedf8...` | `c6107f2c...` | 4,757,011 | none | Live remote head |
| `common-lisp-fixes` | `cd0-integration-common-lisp-fixes` | `776385ef...` | `4c1c7c52...` | 4,738,510 | none | Category B until rescue anchor |
| `common-lisp` | `cd0-common-lisp` | `45eb60ce...` | `774a6673...` | 4,635,065 | historical `AUTO_MERGE` metadata outside checkout | Live remote head |
| `final-evidence` | `cd0-final-evidence-draft` | `3647ec9a...` | `9de45b0c...` | 6,395,587 | none | Category B until rescue anchor |
| `generator` | `cd0-generator-stage` | `7e4c255a...` | `fb57f65c...` | 5,096,248 | 3 ignored pyc / 250,524 B | Category B until rescue anchor |
| `integration-errata` | `codex/cd0-integration-errata-0.1` | `369de53b...` | `13871b0b...` | 593,032,452 | 3 A files + 8 pyc / 598,356 B | Live remote head; A files still need rescue |
| `integration` | `cd0-integration` | `baeecd5e...` | `41d3a71c...` | 202,351,737 | 10 ignored pyc / 569,749 B | Live remote head |
| `main-acceptance` | `main` | `efe52efe...` | `13871b0b...` | 592,760,291 | 3 ignored pyc / 326,198 B | Live remote main |
| `phase0-fix` | `cd0-phase0-fix` | `12e113be...` | `46f4ba4d...` | 4,466,373 | 1 untracked pyc / 39,491 B | Category B until rescue anchor |
| `python-errata` | `codex/cd0-python-errata-0.1` | `5890235d...` | `14478ba8...` | 4,895,422 | 2 ignored pyc / 204,877 B | Live remote head |
| `python-fixes` | `cd0-integration-python-fixes` | `db964524...` | `4584b4d7...` | 4,923,108 | 2 ignored pyc / 182,042 B | Category B until rescue anchor |
| `python` | `cd0-python` | `29d0946a...` | `b556bb85...` | 4,709,726 | 2 ignored pyc / 152,389 B; historical `AUTO_MERGE` metadata outside checkout | Live remote head |
| `qualification` | `cd0-qualification-stage` | `2496cdde...` | `0b2f631b...` | 6,515,152 | 5 ignored pyc / 251,162 B | Category B until rescue anchor |
| `release-runner` | `cd0-release-runner-stage` | `e515355f...` | `7f8d2a2d...` | 6,723,528 | 3 ignored pyc / 224,211 B | Category B until rescue anchor |
| primary `latent-lisp` | `codex/v1-counterexample-closure` | `1bc9e3ce...` | `69793d6a...` | 470,458,331 including shared `.git` | none | Live remote head |

The 14 removable linked worktrees other than primary `latent-lisp` occupy a
gross allocated `1,476,091,904` bytes. This is a size observation, **not** a
deletion authorization or present safe-deletion claim.

Dominant directory aggregates:

```text
latent-lisp-cd0-integration/canonical-datum          197,985,619 B
latent-lisp-cd0-integration-errata/canonical-datum   588,408,055 B
latent-lisp-cd0-main-acceptance/canonical-datum      588,159,383 B
```

The integration-errata and main-acceptance tracked trees are both
`13871b0b...`; their filesystem-size difference is ignored residue/staging,
not a Git-tree difference.

## Category D — machine/cache residue; retain for now

These files are nonzero CPython 3.11 bytecode or pytest cache metadata. They are
not test transcripts. Exact producing commands were not reconstructed, so they
are not claimed as reproducible evidence. Their sources are committed Python
files, but exact `.pyc` byte identity can depend on interpreter and source
metadata. Proposed deletion commands appear only in the separate deletion plan
and require later authorization.

Outer ignored cache paths (11 files, 14,346 bytes):

```text
37   Claude Skills/yijing/.pytest_cache/.gitignore                         2026-06-20 00:54:32
191  Claude Skills/yijing/.pytest_cache/CACHEDIR.TAG                       2026-06-20 00:54:32
302  Claude Skills/yijing/.pytest_cache/README.md                          2026-06-20 00:54:32
2    Claude Skills/yijing/.pytest_cache/v/cache/lastfailed                 2026-06-20 01:09:51
7403 Claude Skills/yijing/.pytest_cache/v/cache/nodeids                    2026-06-20 17:30:48
37   Claude Skills/yijing/scripts/.pytest_cache/.gitignore                 2026-06-20 00:59:33
191  Claude Skills/yijing/scripts/.pytest_cache/CACHEDIR.TAG               2026-06-20 00:59:33
302  Claude Skills/yijing/scripts/.pytest_cache/README.md                  2026-06-20 00:59:33
328  Claude Skills/yijing/scripts/.pytest_cache/v/cache/lastfailed         2026-06-20 00:59:33
304  Claude Skills/yijing/scripts/.pytest_cache/v/cache/nodeids            2026-06-20 00:59:33
5249 tests/__pycache__/test_specimen_0002.cpython-311.pyc                  2026-07-12 20:22:36
```

Nested residue (path prefixes are `/home/gauss/Codex-Lab/latent-lisp-cd0-`;
`!!` is ignored, `??` is untracked):

```text
generator/ !! canonical-datum/generator/__pycache__/generate_corpus.cpython-311.pyc               103757  03:37:27
generator/ !! canonical-datum/generator/tests/__pycache__/test_generate_corpus.cpython-311.pyc       56866  03:36:15
generator/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                         89901  02:51:43
integration-errata/ !! canonical-datum/generator/__pycache__/generate_corpus.cpython-311.pyc         108901  17:03:06
integration-errata/ !! canonical-datum/generator/tests/__pycache__/test_generate_corpus.cpython-311.pyc 60940 17:02:21
integration-errata/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc               103331  15:17:55
integration-errata/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc             101556  15:17:55
integration-errata/ !! canonical-datum/qualification/__pycache__/run_qualification.cpython-311.pyc    46403  17:03:47
integration-errata/ !! canonical-datum/qualification/__pycache__/test_qualification.cpython-311.pyc   10397  17:03:47
integration-errata/ !! canonical-datum/release/__pycache__/run_generated_differential.cpython-311.pyc 121320 17:03:09
integration-errata/ !! canonical-datum/release/tests/__pycache__/test_generated_differential.cpython-311.pyc 22022 17:03:09
integration/ !! canonical-datum/generator/__pycache__/generate_corpus.cpython-311.pyc                103757  03:42:52
integration/ !! canonical-datum/generator/tests/__pycache__/test_generate_corpus.cpython-311.pyc      56868  03:42:52
integration/ !! canonical-datum/integration/__pycache__/python_adapter.cpython-311.pyc                 8587  02:47:18
integration/ !! canonical-datum/integration/__pycache__/run_differential.cpython-311.pyc              38632  02:47:18
integration/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                        99343  02:46:11
integration/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                      82697  02:51:18
integration/ !! canonical-datum/qualification/__pycache__/run_qualification.cpython-311.pyc           44723  04:00:01
integration/ !! canonical-datum/qualification/__pycache__/test_qualification.cpython-311.pyc          10227  04:00:01
integration/ !! canonical-datum/release/__pycache__/run_generated_differential.cpython-311.pyc       105985  03:54:37
integration/ !! canonical-datum/release/tests/__pycache__/test_generated_differential.cpython-311.pyc 18930  03:54:37
main-acceptance/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                   103328  18:30:15
main-acceptance/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                 101553  18:30:15
main-acceptance/ !! canonical-datum/release/__pycache__/run_generated_differential.cpython-311.pyc   121317  18:30:37
phase0-fix/ ?? canonical-datum/tools/__pycache__/verify_phase0.cpython-311.pyc                         39491  02:05:33
python-errata/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                     103326  15:13:25
python-errata/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                   101551  15:12:43
python-fixes/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                       99344  02:39:47
python-fixes/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                     82698  02:40:33
python/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                             89898  02:09:33
python/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                           62491  02:09:33
qualification/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                     99345  03:01:08
qualification/ !! canonical-datum/python/tests/__pycache__/test_cd0.cpython-311.pyc                   82699  03:03:50
qualification/ !! canonical-datum/qualification/__pycache__/python_runtime_probe.cpython-311.pyc     14216  03:01:08
qualification/ !! canonical-datum/qualification/__pycache__/run_qualification.cpython-311.pyc        44725  03:06:08
qualification/ !! canonical-datum/qualification/__pycache__/test_qualification.cpython-311.pyc       10177  03:01:08
release-runner/ !! canonical-datum/python/cd0/__pycache__/__init__.cpython-311.pyc                    99346  03:15:16
release-runner/ !! canonical-datum/release/__pycache__/run_generated_differential.cpython-311.pyc    105985  03:47:16
release-runner/ !! canonical-datum/release/tests/__pycache__/test_generated_differential.cpython-311.pyc 18880 03:47:16
```

No core dump, crash dump, incomplete download, zero-byte untracked/ignored file,
or stale lock file was found. Two stale historical `AUTO_MERGE` files and two
prunable missing-worktree registrations are metadata debris candidates, but
they remain part of the forensic record and are not included in the byte total
above.

## Zero-byte and truncation review

There are 689 zero-byte files across clean committed worktrees: 676 expected
stdout/stderr `.txt` files, 8 `.stderr` files, and 5
`mutation-disagreements.jsonl` files. Their tracked-clean status, names, and
role indicate intentional empty evidence outputs, not newly interrupted writes.
No untracked or ignored item is zero bytes.

Seven dominant files in main acceptance match their exact HEAD blob sizes:
the 94,371,840-byte and 13,852,034-byte split archive parts; 20,463,020-byte
and 6,861,174-byte tarballs; a 70,427,108-byte bundle; and 17,210,584-byte and
17,210,317-byte corpus files. They were deliberately not rehashed during this
low-space inventory. The later archive and checksum verification remains
required before freeze.

## Category E — sensitive or unknown

A filename-only scan found no `.env`, key, PEM, token, credential, password,
SSH, cookie, browser, history, or database candidate among untracked/ignored
paths. No value was printed. The bounded archive scan described under Category
A produced zero high-risk token/key matches. Machine credentials and `.git`
administrative content are explicitly excluded from staging.

## Pre-preservation conclusion

- Category A: 8 distinct blobs are ready for exact-byte rescue after staged
  diff, size, binary, and secret checks.
- Category B: seven local-only tips must be made reachable from the single
  rescue ref before any cleanup can be considered.
- Category C: potentially large space recovery exists, but it is conditional
  and no deletion is authorized.
- Category D: retain; it proves only machine activity, not test outcomes.
- Category E: no candidate found by bounded scans; do not generalize that to a
  universal absence-of-secrets claim.
