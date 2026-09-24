# Lisp+ Canonical Datum /0 merge receipt

Date: 2026-07-13 (America/Sao_Paulo)

Repository: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`

Status: **MERGE VERIFIED — retrospective reconciliation receipt**

## Receipt boundary

The authorized merge was completed and pushed before this receipt was written.
The interrupted run retained the merge commit, reflogs, and a rescue receipt,
but not the original shell transcript. Git preserves the merge target, result,
strategy, time, parents, tree, and the subsequent remote-tracking update; it
does not preserve every original command-line flag. The exact historical merge
and push command strings are therefore unavailable and are not invented here.

This limitation does not affect the merge identity: a fresh complete mirror
independently verifies the exact commit, ordered parents, reviewed tree, message,
and empty content diff recorded below. Exact commands executed during this
reconciliation are recorded verbatim.

The earlier stop against
`https://github.com/Wondermonger-daydreaming/Codex-Lab.git` is classified as a
**repository-binding failure / wrong-remote audit**. It is not evidence about
the history of `latent-lisp`.

## Constitutional identities

| Field | Exact identity |
|---|---|
| old `main` commit | `ae767f00975395369f9a91283a954f0963fb6724` |
| old `main` tree | `b8f5be6d532eafe5be0d1f342347fa10f5f39352` |
| authorized integration commit | `369de53bff4ef5edbd31db3428456fde58d90cf5` |
| authorized integration tree | `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| merge commit | `efe52efe3e0e5a24181ee324e18b23e266129104` |
| merge tree | `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| first parent | `ae767f00975395369f9a91283a954f0963fb6724` |
| second parent | `369de53bff4ef5edbd31db3428456fde58d90cf5` |
| Fable protocol | `49b3cf88` |
| Fable verdict | `PASS` |
| Fable receipt SHA-256 | `96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e` |

The merge commit was authored and committed at
`2026-07-13T18:28:31-03:00`. Its subject is
`Merge CD/0 Canonical Datum /0 acceptance`.

## Authorization and merge-message verification

The exact Fable receipt bytes are retained on the advertised rescue branch at:

```text
recovery-evidence/2026-07-13/fable/FABLE-CD0-A9-CLOSURE-VERIFICATION.md
```

Fresh hashing from the remote-derived object returned the required SHA-256.
The receipt names protocol `49b3cf88`, verdict **PASS**, and the authorized
integration commit.

The merge message records:

- Lisp+ Canonical Datum /0 acceptance;
- authorized integration commit `369de53bff4ef5edbd31db3428456fde58d90cf5`;
- Fable protocol `49b3cf88`;
- the exact Fable PASS receipt SHA-256;
- `CD0-POST-IMPLEMENTATION-RULING.md` and
  `CANONICAL-DATUM-SPEC-ERRATA-0.1.md` as the normative basis; and
- that canonical bytes, equality, accepted documents, wire grammar, datum
  version, and v1 semantics remain unchanged.

## Historical operation evidence

The retained acceptance-worktree reflogs record these actions:

```text
2026-07-13T18:28:18-03:00  merge refs/remotes/origin/main: Fast-forward
2026-07-13T18:28:31-03:00  merge 369de53bff4ef5edbd31db3428456fde58d90cf5: Merge made by the 'ort' strategy.
2026-07-13T18:29:03-03:00  origin/main: update by push
```

The merge was conflict-free and ancestry-preserving. It was not a squash,
rebase, cherry-pick, or synthetic-history replacement. The exact original
shell command strings cannot be recovered from Git metadata; this receipt
therefore reports the preserved actions instead of fabricating commands.

## Exact reconciliation commands and results

Incident context, read only:

```text
pwd
git rev-parse --show-toplevel 2>/dev/null || true
git remote -v 2>/dev/null || true
```

This showed `/home/gauss/Codex-Lab` and its unrelated `Codex-Lab.git` remote.
No mutation was made there.

Fresh subject-repository mirror:

```text
rm -rf /tmp/cd0-latent-lisp-reconciliation-20260713
git clone --mirror --no-local \
  https://github.com/Wondermonger-daydreaming/latent-lisp.git \
  /tmp/cd0-latent-lisp-reconciliation-20260713
```

Identity and content checks:

```text
git rev-parse --is-bare-repository
git rev-parse --is-shallow-repository
git show --no-patch --format='%H %T %P %B' \
  efe52efe3e0e5a24181ee324e18b23e266129104
git show --no-patch --format='%H %T %P %s' \
  369de53bff4ef5edbd31db3428456fde58d90cf5
git diff --exit-code \
  369de53bff4ef5edbd31db3428456fde58d90cf5 \
  efe52efe3e0e5a24181ee324e18b23e266129104
git for-each-ref --sort=refname \
  --format='%(refname) %(objectname) %(objecttype)'
git fsck --full --strict
```

Results:

- bare repository: `true`;
- shallow repository: `false`;
- merge parents: exact and in the authorized order;
- integration tree and merge tree: both
  `13871b0b0ec81e667611163bc78976b3a91ff4b7`;
- authorized-integration-to-merge diff: empty, exit `0`;
- strict object check: exit `0`, no missing or corrupt objects; and
- all named audited and successor tips remain advertised at their exact
  identities, as detailed in `CD0-MAIN-READBACK-RECEIPT.md`.

## Ancestry and protected-content conclusion

Fresh `git merge-base --is-ancestor` checks exited `0` for:

```text
baeecd5e0347435b9e1362000344f46ea441c6ec
  -> 851cffc2f0c4799ac8aff9008ddf218bd32255be
  -> 64988991215939d84517801d049348a3393d04a6
  -> 3f37c846710916db90e1786bc46b41bf09b089a0
  -> 2722213ded71ff2c82494b65b654015a8c267128
  -> 369de53bff4ef5edbd31db3428456fde58d90cf5
  -> efe52efe3e0e5a24181ee324e18b23e266129104
```

The Common Lisp and Python audited/successor tips are likewise retained by
their exact remote refs. Because the merge tree equals the reviewed integration
tree and the diff is empty, the acceptance event introduced no merge-only
content. No canonical octets, equality laws, accepted documents, wire grammar,
datum families, format version, decoder behavior, or existing v1 semantics
changed at merge.

Post-merge commands and results are recorded in
`CD0-POST-MERGE-VERIFICATION.md`.
