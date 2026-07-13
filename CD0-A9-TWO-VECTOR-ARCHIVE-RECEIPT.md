# CD/0 focused A9 two-vector immutable archive receipt

Date: 2026-07-13  
Vantage: local WSL2 integration successor worktree  
Status: two constructions from one immutable Git commit were byte-identical

## Identity

| Field | Value |
|---|---|
| source commit | `3f37c846710916db90e1786bc46b41bf09b089a0` |
| source tree | `db1919cec5ca6873b932fb43c715f598ae0286f8` |
| first successor ancestor | `851cffc2f0c4799ac8aff9008ddf218bd32255be` |
| audited integration ancestor | `baeecd5e0347435b9e1362000344f46ea441c6ec` |
| prefix | `latent-lisp-cd0-a9-two-vector-2026-07-13/` |
| listing entries | 1,468 |
| listing SHA-256 | `11d6ee59dfafe5a8edfbdbfcac6849a56f6507a4a2ae5e099838c0fb4b9c3038` |
| compressed bytes | 108,223,874 |
| archive SHA-256 | `3414dbeb12d8930ee5dd29145254513411989dd9f57104b90144a480688cc3eb` |
| publication part 00 | 94,371,840 bytes; SHA-256 `4250bf49129846dddc06dd3e20959c572ed815d9d3021b3a9c75e1366d48dde3` |
| publication part 01 | 13,852,034 bytes; SHA-256 `2d433e14f142aa7c4a93461125186fa22925a5b5ea8c1089e469e42219120d07` |
| retained paths | `canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-{00,01}` |

The archive source contains the updated 39-row vector file, focused hand and
qualification evidence, complete release summary ledger, corpus manifest,
Fable report copy, exact source diff, and focused receipts. The archive itself
and this receipt are outside the source commit to avoid self-reference.

## Reproduction

```text
git archive --format=tar.gz \
  --prefix=latent-lisp-cd0-a9-two-vector-2026-07-13/ \
  --output=/tmp/cd0-a9-two-vector-2026-07-13.first.tar.gz \
  3f37c846710916db90e1786bc46b41bf09b089a0

git archive --format=tar.gz \
  --prefix=latent-lisp-cd0-a9-two-vector-2026-07-13/ \
  --output=/tmp/cd0-a9-two-vector-2026-07-13.second.tar.gz \
  3f37c846710916db90e1786bc46b41bf09b089a0

cmp -s /tmp/cd0-a9-two-vector-2026-07-13.first.tar.gz \
       /tmp/cd0-a9-two-vector-2026-07-13.second.tar.gz
gzip -t /tmp/cd0-a9-two-vector-2026-07-13.first.tar.gz
```

All commands exited `0`. Both files had SHA-256
`3414dbeb12d8930ee5dd29145254513411989dd9f57104b90144a480688cc3eb`.
The retained publication parts concatenate to a byte stream identical to the
first construction. They are split only because GitHub rejects individual
files above 100 MiB; no archive member or compressed byte changed.

```text
cat canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-00 \
    canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-01 \
  > /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
sha256sum /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
# 3414dbeb12d8930ee5dd29145254513411989dd9f57104b90144a480688cc3eb
```

## Boundary

This is a byte-reproducible container for the recorded source and evidence. It
does not prove universal conformance, confer normative authority on generated
evidence, or claim remote availability. Remote availability is established only
by the later read-back receipt. It does not claim a merge to `main`.
