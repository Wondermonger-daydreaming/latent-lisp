# CD/0 focused A9 two-vector remote read-back receipt

Date: 2026-07-13  
Remote: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`  
Publication method: ordinary non-force fast-forward pushes

## Pre-publication remote state

`git ls-remote` returned:

```text
ee3baa9ab504f65d39015f212050748fd300160a  codex/cd0-common-lisp-errata-0.1
9f46a32351095dc1a52724a31574e0b9e62ed221  codex/cd0-python-errata-0.1
851cffc2f0c4799ac8aff9008ddf218bd32255be  codex/cd0-integration-errata-0.1
ae767f00975395369f9a91283a954f0963fb6724  main
```

Thus each remote successor was still at its first errata successor commit and
`main` was unchanged before publication.

## Push results

Common Lisp fast-forwarded `ee3baa9… -> ddadedf…`. Python fast-forwarded
`9f46a32… -> 5890235…`.

The first integration attempt was rejected before ref update because the
108,223,874-byte archive exceeded GitHub's 100 MiB per-file limit. The
unpublished archive-envelope commit was replaced with a descendant envelope
that preserves the identical archive byte stream as deterministic 90 MiB and
13,852,034-byte parts. The retry fast-forwarded `851cffc… -> 2722213…` without
force. No published commit was rewritten.

## Remote read-back checkpoint

Fresh `git fetch` operations created dedicated `origin-readback/*` refs. For
each branch, the fetched commit equaled local `HEAD`, `git diff --exit-code`
was clean, and both the audited tip and first successor passed
`git merge-base --is-ancestor`.

| Branch | Remote checkpoint | Tree |
|---|---|---|
| Common Lisp | `ddadedf846afb6dff75fb8ffe449a8bbd03231df` | `c6107f2c145d55bbba98b9c432c740088bf2528d` |
| Python | `5890235d9456031972b2ee7f40278d653dd1e6ae` | `14478ba84cf9d2ee72d2c9dca3b835087d1ed870` |
| Integration evidence/archive | `2722213ded71ff2c82494b65b654015a8c267128` | `cb2a21027707f9dbd22f672ea884969238ec1bf7` |

Final `git ls-remote` at this checkpoint returned those exact three hashes and
unchanged `main` `ae767f00975395369f9a91283a954f0963fb6724`.

The later integration receipt/checksum-envelope commit contains this receipt
and the packet copy. Because a Git commit cannot contain a read-back assertion
about its own not-yet-existing hash, final-envelope remote identity is reported
by the completion report's final `ls-remote` result; it changes no source,
vector, test result, archive byte, or protected behavior.

## Preserved historical anchors

```text
Common Lisp audited tip 45eb60ce5b80485a0b287feab53ed3b58643b1b0
Python audited tip      29d0946ad78347015b9f0c65a2f528f039fdca78
Integration audited tip baeecd5e0347435b9e1362000344f46ea441c6ec
First CL successor      ee3baa9ab504f65d39015f212050748fd300160a
First Python successor  9f46a32351095dc1a52724a31574e0b9e62ed221
First integration succ. 851cffc2f0c4799ac8aff9008ddf218bd32255be
```

No merge to `main` occurred or is claimed.
