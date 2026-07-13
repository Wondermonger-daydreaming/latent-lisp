# CD/0 Errata 0.1 remote publication and read-back receipt

Date: 2026-07-13
Remote: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`
Publication method: atomic, non-force branch creation
Status: initial publication payload read back successfully from an isolated
bare repository.

This receipt covers publication payload commit
`e1c5751d638e60a35ab34e13e3fc391ddbb102b9`. The later commit that contains
this receipt and the final checksum manifest cannot attest to itself; its exact
live read-back is reported after that final push in the completion report.

## Live preflight

Before publication:

```text
git ls-remote --refs origin \
  refs/heads/main \
  refs/heads/cd0-common-lisp \
  refs/heads/cd0-python \
  refs/heads/cd0-integration \
  refs/heads/codex/cd0-common-lisp-errata-0.1 \
  refs/heads/codex/cd0-python-errata-0.1 \
  refs/heads/codex/cd0-integration-errata-0.1
```

Exit `0`. Only the four established refs existed:

```text
ae767f00975395369f9a91283a954f0963fb6724  refs/heads/main
45eb60ce5b80485a0b287feab53ed3b58643b1b0  refs/heads/cd0-common-lisp
29d0946ad78347015b9f0c65a2f528f039fdca78  refs/heads/cd0-python
baeecd5e0347435b9e1362000344f46ea441c6ec  refs/heads/cd0-integration
```

The audited refs matched the pre-change baseline and all three successor names
were unoccupied.

## Atomic publication

Command:

```text
git push --atomic origin \
  refs/heads/codex/cd0-common-lisp-errata-0.1:refs/heads/codex/cd0-common-lisp-errata-0.1 \
  refs/heads/codex/cd0-python-errata-0.1:refs/heads/codex/cd0-python-errata-0.1 \
  refs/heads/codex/cd0-integration-errata-0.1:refs/heads/codex/cd0-integration-errata-0.1
```

Exit `0`. GitHub reported all three as `[new branch]`. No force option was used.
GitHub emitted its non-blocking advisory that the packet's 67.16 MB
`exact-diff.bundle` exceeds the recommended 50 MB size; the object and branch
were accepted.

## Live ref read-back

The same seven-ref `git ls-remote` command then returned:

```text
ae767f00975395369f9a91283a954f0963fb6724  refs/heads/main
45eb60ce5b80485a0b287feab53ed3b58643b1b0  refs/heads/cd0-common-lisp
29d0946ad78347015b9f0c65a2f528f039fdca78  refs/heads/cd0-python
baeecd5e0347435b9e1362000344f46ea441c6ec  refs/heads/cd0-integration
ee3baa9ab504f65d39015f212050748fd300160a  refs/heads/codex/cd0-common-lisp-errata-0.1
9f46a32351095dc1a52724a31574e0b9e62ed221  refs/heads/codex/cd0-python-errata-0.1
e1c5751d638e60a35ab34e13e3fc391ddbb102b9  refs/heads/codex/cd0-integration-errata-0.1
```

Thus `main` and all three audited branch tips remained unchanged.

## Isolated fetch and content read-back

An empty bare repository was created at
`/tmp/cd0-errata-remote-readback-e1c5751.git`, and all seven live GitHub refs
were fetched by HTTPS without consulting the local successor refs. The fetched
commit/tree pairs were:

```text
main
ae767f00975395369f9a91283a954f0963fb6724
b8f5be6d532eafe5be0d1f342347fa10f5f39352

cd0-common-lisp
45eb60ce5b80485a0b287feab53ed3b58643b1b0
774a6673bc44d61f641becbacde20b270bfe393b

cd0-python
29d0946ad78347015b9f0c65a2f528f039fdca78
b556bb85d47c87b3bc89644cf58534adab0afd1c

cd0-integration
baeecd5e0347435b9e1362000344f46ea441c6ec
41d3a71c06692174701bfde8f071e7da1c719651

codex/cd0-common-lisp-errata-0.1
ee3baa9ab504f65d39015f212050748fd300160a
ecf5261c41ad24199325ab56cbf6c39e83cddbc6

codex/cd0-python-errata-0.1
9f46a32351095dc1a52724a31574e0b9e62ed221
f065acfe6bb56365946a20e131edcfbf351b06f4

codex/cd0-integration-errata-0.1
e1c5751d638e60a35ab34e13e3fc391ddbb102b9
b1e79d2c53081a9137bf589483fba7644da209d5
```

All three audited-to-successor `git merge-base --is-ancestor` commands exited
`0` inside the fetched repository.

The archive blob streamed from the fetched integration ref, rather than the
workspace, produced:

```text
SHA-256  f6c8cf9fa62b36521703a1c1f1f10b288edbdf555cc3fd0c87105f0529c528f2
bytes    20,463,020
```

The remote packet bundle streamed from the same ref hashed to
`a71415c365dd1f247fa0bb27b6ba77ba141b6c162a1c154e70782d629f097330`.
The remote targeted-review receipt hashed to
`949a1ee8cba7d0ba76f8e41d8d335a2d95131cf81098ad848b7d4b717c29d1e2`.

## Remote navigation

- Common Lisp successor:
  `https://github.com/Wondermonger-daydreaming/latent-lisp/tree/codex/cd0-common-lisp-errata-0.1`
- Python successor:
  `https://github.com/Wondermonger-daydreaming/latent-lisp/tree/codex/cd0-python-errata-0.1`
- Integration successor:
  `https://github.com/Wondermonger-daydreaming/latent-lisp/tree/codex/cd0-integration-errata-0.1`
- Publication payload commit:
  `https://github.com/Wondermonger-daydreaming/latent-lisp/commit/e1c5751d638e60a35ab34e13e3fc391ddbb102b9`

## Boundary

The receipt demonstrates branch creation and byte/content read-back at the
recorded GitHub HTTPS vantage. It does not claim a merge, protected-branch
status, review by Fable, indefinite future availability, or any semantic fact
beyond the separately reviewed source/evidence. The final receipt/checksum
envelope must still be pushed non-force and read back exactly.
