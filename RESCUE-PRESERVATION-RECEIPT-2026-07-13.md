# Rescue preservation receipt — 2026-07-13

Status before this receipt's own archival commit: rescue payload and historical
reachability are present on a new, non-force remote branch and have passed an
initial live ref read-back.

This is a preservation receipt, not a CD/0 merge verification or freeze
declaration.

## Identity

```text
pre-rescue HEAD: efe52efe3e0e5a24181ee324e18b23e266129104
pre-rescue tree: 13871b0b0ec81e667611163bc78976b3a91ff4b7
rescue branch: rescue/cd0-disk-full-2026-07-13
initial remote rescue HEAD: b7ff420ae3f7eb0e36251dbff97e7ff8bdc892a9
initial remote rescue tree: c9f74e1b386564f0030a5409728a096362031200
remote ref: refs/heads/rescue/cd0-disk-full-2026-07-13
```

The exact base branch name was absent locally and from the complete live remote
ref listing before creation; no suffix was required.

## Rescue commits before this receipt

| Commit | Tree | First parent | Purpose |
|---|---|---|---|
| `68ab68f68d3a9ce100e1c7de1c8f4aac4b8d27ad` | `70f365099dbe926cfd8cec6a0ef819f8c50ceae9` | `efe52efe3e0e5a24181ee324e18b23e266129104` | Preserve the unique ignored changed-files manifest and exact Fable return/PASS receipts. |
| `3c4325763b9636f5da0feef9b7d042f865cd8877` | `bc5c0d3e17d82e8385d1fa972e90221bceab1b93` | `68ab68f68d3a9ce100e1c7de1c8f4aac4b8d27ad` | Preserve five exact outer-workspace archives/artifacts. |
| `aa1bfc1d903e36e8cecfdbf53d05b9a3721dc373` | `c9f74e1b386564f0030a5409728a096362031200` | `3c4325763b9636f5da0feef9b7d042f865cd8877` | Record the pre-preservation interruption receipt and complete A–E inventory. |
| `b7ff420ae3f7eb0e36251dbff97e7ff8bdc892a9` | `c9f74e1b386564f0030a5409728a096362031200` | `aa1bfc1d903e36e8cecfdbf53d05b9a3721dc373` | Tree-neutral reachability anchor for seven local-only historical tips. |

The anchor's tree exactly equals its first parent's tree. Its complete ordered
parent list is:

```text
aa1bfc1d903e36e8cecfdbf53d05b9a3721dc373
3647ec9a011b9b8a422041411dba13efaf5ea250  cd0-final-evidence-draft
7e4c255acceca346b023a34bc4b7794eeee61fb0  cd0-generator-stage
776385ef13865b78a803004d67f9d3661045fc61  cd0-integration-common-lisp-fixes
db964524ded723f0841188a322b13ac9896c67d6  cd0-integration-python-fixes
12e113be87a17654da60eb08f16b47106a25b794  cd0-phase0-fix
2496cddee7a1aa52a365ff219b22fa7522e51199  cd0-qualification-stage
e515355f55593ff810e9cfe9f6c0529e3994f62a  cd0-release-runner-stage
```

Each local-only tip was checked with `git merge-base --is-ancestor <tip>
b7ff420...` and returned exit 0. The additional-parent relationship is purely a
recovery/reachability device. It does not assert that those parent trees were
semantically merged, reviewed, accepted, or added to main.

## Staging controls

Before each ordinary rescue commit, the following were inspected:

- staged name/status and aggregate staged blob size;
- staged diff and `git diff --cached --check`;
- likely high-risk secret shapes and credential assignments, with path-only
  reporting;
- file types and binary/large-file identity;
- remaining untracked/ignored paths against the inventory.

Results:

```text
Fable evidence commit: 3 files, 23,486 staged bytes, all text
outer archive commit: 5 files, 1,631,875 staged bytes
  binaries: 46,328-byte ZIP; 6,202-byte tar.gz; 1,564,475-byte Git bundle
  text: 1,856-byte manifest; 13,014-byte diary
inventory/docs commit: 2 files, 30,961 staged bytes, all text
secret-pattern hits: 0
diff-check errors: 0
```

The ZIP and tar members were read without extraction and scanned for private-key
headers, AWS/GitHub/OpenAI-like credential shapes, and credential assignments.
The Git bundle was structurally verified and its exact tip tree was scanned with
`git grep`; no high-risk match was found. No value was printed. This is bounded
screening, not a universal absence-of-secrets proof.

Before the tree-neutral anchor, the staged path set and staged aggregate size
were both zero. The proposed commit object was inspected before the rescue ref
was advanced with an old-value guard. `git diff --quiet aa1bfc1... b7ff420...`
exited 0.

## Preserved manifest

Exact-byte copied payload:

| Rescue path | Bytes | SHA-256 |
|---|---:|---|
| `recovery-evidence/2026-07-13/fable/CD0-A9-TWO-VECTOR-FINAL-CHANGED-FILES.txt` | 7,276 | `128eac42b4b930f57b703a5f10a684dbc27e6908b781ff514eab4928df124970` |
| `recovery-evidence/2026-07-13/fable/FABLE-CD0-A9-CLOSURE-VERIFICATION.md` | 6,199 | `96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e` |
| `recovery-evidence/2026-07-13/fable/FABLE-CD0-TARGETED-VERIFICATION-REPORT.md` | 10,011 | `67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b` |
| `recovery-evidence/2026-07-13/outer-workspace/GPT-PRO-V1-COUNTEREXAMPLE-CLOSURE-PACKET-2026-07-13.zip` | 46,328 | `cee06bd06f35f6a26cc5bcd8e9c8fa270805b75424d916a4fadecf757dfe9bce` |
| `recovery-evidence/2026-07-13/outer-workspace/codex-lab-diary-2026-07-13-02.manifest.md` | 1,856 | `fea4d3f8d4e422d7b9fa2a377997ff64ebc2553ed130e895bcf091925473d4f4` |
| `recovery-evidence/2026-07-13/outer-workspace/codex-lab-diary-2026-07-13-02.md` | 13,014 | `51820c1b7d9010022d34beedd081be45f874736d30dda0750e7e758bf53c0a6d` |
| `recovery-evidence/2026-07-13/outer-workspace/codex-lab-diary-2026-07-13-02.tar.gz` | 6,202 | `0133208ff7dd6510489caa54fcd96218f9e9ddcd8bb7595aa115155307b5e69f` |
| `recovery-evidence/2026-07-13/outer-workspace/latent-lisp-audit-9e9c031.bundle` | 1,564,475 | `9439d8f3509a8e6c43bab946f9401aa1cbdb971add078fe596178c5bde58b35b` |

The copied sources and rescue payload were compared with `cmp`; all eight
comparisons exited 0. Distinct copied evidence totals 8 files and 1,655,361
bytes.

Rescue documentation present before this receipt:

```text
CD0-INTERRUPTION-RECOVERY-RECEIPT.md  10,035 bytes
  sha256 8f6e8baf4d529aa289d3bd120460081c51a9e5eb2f559249bea8fde27a6629a3
RESCUE-INVENTORY-2026-07-13.md          20,926 bytes
  sha256 afc837aca090a43f606d76320adea59cb1d96a412c858e6b04d53cb448988bc3
```

Initial preserved working-tree manifest: 10 files, 1,686,322 bytes. The seven
local-only histories are additionally preserved by reachability, not counted as
working-tree bytes. This receipt's own size/commit/tree are necessarily recorded
by the subsequent commit/read-back rather than self-referentially embedded.

## Omitted manifest

- The integration-errata Fable receipt and targeted report path instances were
  not copied a second time because they are byte-identical to the preserved
  outer instances. Their original ignored files remain untouched and both paths,
  sizes, mtimes, and hashes are in `RESCUE-INVENTORY-2026-07-13.md`.
- Fifty cache/bytecode files (2,789,859 bytes) are Category D. They were neither
  staged nor deleted and are not test evidence.
- Fourteen linked checkout copies are Category C and were not copied into the
  branch. Exact commits/trees and reconstruction commands are in the inventory.
- The shared `.git` directory was not staged. Its seven previously remote-absent
  tips are reachable through the anchor; existing live remote tips already
  preserve the other histories.
- Large canonical corpora, archives, bundles, vectors, and transcripts already
  present in the reviewed integration tree were not duplicated. The authorized
  commit and merge remain live remote refs.
- Historical `AUTO_MERGE` files and missing-worktree registration metadata were
  not staged, rewritten, pruned, or deleted; their identities are in the
  interruption receipt.
- No Category E filename candidate was found. Machine credentials and Git admin
  files were excluded categorically.

No valuable Category B artifact remains intentionally omitted from a remote
preservation mechanism after the successful anchor push.

## Exact initial push and live read-back

Push command (non-force, one new remote ref):

```text
git push origin refs/heads/rescue/cd0-disk-full-2026-07-13:refs/heads/rescue/cd0-disk-full-2026-07-13
```

Observed result:

```text
* [new branch] rescue/cd0-disk-full-2026-07-13 -> rescue/cd0-disk-full-2026-07-13
exit 0
```

Read-back command:

```text
git ls-remote origin
```

The live result contained:

```text
b7ff420ae3f7eb0e36251dbff97e7ff8bdc892a9  refs/heads/rescue/cd0-disk-full-2026-07-13
```

The complete before/after remote comparison showed the same eight pre-existing
heads at the same object IDs, with only the rescue head added. In particular:

```text
main remained efe52efe3e0e5a24181ee324e18b23e266129104
codex/cd0-integration-errata-0.1 remained 369de53bff4ef5edbd31db3428456fde58d90cf5
```

Because a Git commit ID covers its tree and ordered parents, the live remote
commit identity also binds the initial remote rescue tree to
`c9f74e1b386564f0030a5409728a096362031200` and all eight ordered parents.

## Anomalies and boundary

- GNU `cp --no-clobber` emitted portability warnings recommending
  `--update=none`; it returned exit 0, no destination existed beforehand, and
  every destination passed exact `cmp` and SHA-256 checks.
- The initial sandboxed remote query failed only with DNS unavailable. The
  authorized network retry succeeded; no repository or filesystem error was
  involved.
- No fresh isolated clone was created because the Windows host volume is below
  the 10 GiB safety floor. A final lightweight fetch/read-back of this receipt's
  archival commit will complete rescue verification.
- No cleanup or deletion occurred.
- No CD/0 post-merge suite or located-claim identity work began.
