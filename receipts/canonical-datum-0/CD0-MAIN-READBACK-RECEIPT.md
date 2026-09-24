# Lisp+ Canonical Datum /0 main read-back receipt

Date: 2026-07-13 (America/Sao_Paulo)

Repository: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`

Vantage: fresh isolated complete mirror

Status: **PASS**

## Fresh-mirror construction

The enclosing Codex-Lab repository and all pre-existing local tracking refs
were excluded as identity authorities. The read-back used:

```text
rm -rf /tmp/cd0-latent-lisp-reconciliation-20260713
git clone --mirror --no-local \
  https://github.com/Wondermonger-daydreaming/latent-lisp.git \
  /tmp/cd0-latent-lisp-reconciliation-20260713
```

The mirror completed successfully. `git rev-parse --is-shallow-repository`
returned `false`; `git fsck --full --strict` exited `0`. The clone-time
`packed-refs` file was 720 bytes, had mtime
`2026-07-13 20:15:45.903326161 -0300`, and SHA-256:

```text
458f27708da48a28f9bb5989988ca6a60eb05c682082597cdefb518c9155f925
```

No tags were advertised. Symbolic `HEAD` named `refs/heads/main`.

## Remote main read-back

```text
commit  efe52efe3e0e5a24181ee324e18b23e266129104
tree    13871b0b0ec81e667611163bc78976b3a91ff4b7
parent1 ae767f00975395369f9a91283a954f0963fb6724
parent2 369de53bff4ef5edbd31db3428456fde58d90cf5
subject Merge CD/0 Canonical Datum /0 acceptance
```

The authorized integration commit is an ancestor of remote `main`. Its tree
equals the merge tree. The exact command below returned no output and exit `0`:

```text
git diff --exit-code \
  369de53bff4ef5edbd31db3428456fde58d90cf5 \
  efe52efe3e0e5a24181ee324e18b23e266129104
```

## Exact clone-time remote-ref inventory

| Advertised ref | Commit | Tree |
|---|---|---|
| `refs/heads/cd0-common-lisp` | `45eb60ce5b80485a0b287feab53ed3b58643b1b0` | `774a6673bc44d61f641becbacde20b270bfe393b` |
| `refs/heads/cd0-integration` | `baeecd5e0347435b9e1362000344f46ea441c6ec` | `41d3a71c06692174701bfde8f071e7da1c719651` |
| `refs/heads/cd0-python` | `29d0946ad78347015b9f0c65a2f528f039fdca78` | `b556bb85d47c87b3bc89644cf58534adab0afd1c` |
| `refs/heads/codex/cd0-common-lisp-errata-0.1` | `ddadedf846afb6dff75fb8ffe449a8bbd03231df` | `c6107f2c145d55bbba98b9c432c740088bf2528d` |
| `refs/heads/codex/cd0-integration-errata-0.1` | `369de53bff4ef5edbd31db3428456fde58d90cf5` | `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| `refs/heads/codex/cd0-python-errata-0.1` | `5890235d9456031972b2ee7f40278d653dd1e6ae` | `14478ba84cf9d2ee72d2c9dca3b835087d1ed870` |
| `refs/heads/codex/v1-counterexample-closure` | `1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48` | `69793d6ac432d47a060a215785b536ee7e8fcfd0` |
| `refs/heads/main` | `efe52efe3e0e5a24181ee324e18b23e266129104` | `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| `refs/heads/rescue/cd0-disk-full-2026-07-13` | `e20762c8c441b9b6cac5044b05c7c8faad704637` | `994dfc174ea4a0de880ec8cbd17c95b632ef7cda` |

The rescue ref is a post-merge additive preservation branch. The merge commit
is its ancestor; it is not a replacement for `main`. The local-only
`cd0-post-merge-reconciliation` work branch created after clone is deliberately
excluded from this clone-time remote inventory.

## Reachability and non-rewrite boundary

Fresh ancestry checks established:

- audited integration `baeecd5e...` through first errata successor
  `851cffc2...`, focused two-vector successors, and final `369de53b...`;
- audited Common Lisp `45eb60ce...` through first successor `ee3baa9a...`
  to final `ddadedf8...`;
- audited Python `29d0946a...` through first successor `9f46a323...`
  to final `5890235d...`;
- old main `ae767f00...` as first parent of the merge; and
- authorized integration `369de53b...` as second parent of the merge.

No rewrite is indicated for any named constitutional lineage: every supplied
anchor remains exact and reachable in its required relation. A fresh mirror
does not contain a remote reflog and therefore cannot prove a universal
historical negative beyond the named refs and ancestry. No unrelated ref was
changed by this read-only reconciliation.
