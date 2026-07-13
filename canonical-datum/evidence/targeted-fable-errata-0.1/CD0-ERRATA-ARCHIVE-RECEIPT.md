# CD/0 Errata 0.1 archive receipt

Date: 2026-07-13

## Immutable source boundary

```text
archive source commit: 6c82787f7cff4ccd14e78885af11ff79130b0313
archive source tree:   9b6ef7cfe9bb06b78f152741a384f94febf8cdd8
audited base commit:   baeecd5e0347435b9e1362000344f46ea441c6ec
archive prefix:        latent-lisp-cd0-errata-0.1-2026-07-13/
```

The source commit contains the codec/vector/generator repairs, complete retained
hand/release/qualification evidence, implementation ledger, verification
transcript, differential receipt, release receipt, and targeted relay. It does
not contain this receipt, the archive itself, targeted independent-review
result, or remote read-back because those facts necessarily occur after the
source commit. Later envelope commits do not alter the claimed source tree.

## Explicit build recipe

The command was executed twice with distinct output paths:

```text
git archive \
  --format=tar.gz \
  --prefix=latent-lisp-cd0-errata-0.1-2026-07-13/ \
  --output=/tmp/cd0-errata-0.1-2026-07-13-first.tar.gz \
  6c82787f7cff4ccd14e78885af11ff79130b0313

git archive \
  --format=tar.gz \
  --prefix=latent-lisp-cd0-errata-0.1-2026-07-13/ \
  --output=/tmp/cd0-errata-0.1-2026-07-13-second.tar.gz \
  6c82787f7cff4ccd14e78885af11ff79130b0313
```

Both commands exited `0`. Then:

```text
cmp first.tar.gz second.tar.gz
```

exited `0`.

## Reproduced identity

Both independently named builds had:

```text
bytes:        20,458,474
members:      1,382
SHA-256:      0886d90f17643b2b8e47402d6735c0417a1621b7866dd5ea385c60f813963e0a
```

Retained artifact:

```text
canonical-datum/evidence/artifacts/cd0-errata-0.1-2026-07-13.tar.gz
```

The retained copy also has 20,458,474 bytes and the same SHA-256.

Inspection command:

```text
tar -tzf canonical-datum/evidence/artifacts/cd0-errata-0.1-2026-07-13.tar.gz
```

exited `0`. The listing begins with the declared prefix and includes the ruling,
errata, all five root errata ledgers/receipts present at the source commit,
promoted vectors, corpus, 50-batch differential evidence, and qualification
evidence. It ends normally with the repository's tracked `skills/` members.

## Load-bearing embedded identities

```text
corpus SHA-256:       62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58
corpus manifest:      ee9a6ef6864e36e38c7a15ba010b8e5658dd212c09d103f1fc8af626b0a93d8b
positive vectors:     34fe63302e686efc0bcf1b1d841dbc5392c7f5abae393390eca40680179492b4
negative vectors:     d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6
promoted A1-A9:       55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc
fixture schema:       6609a6d97140f1fda5a538ccb908bb820bcdad380b7dd8efb05fa8a9e7a0407c
hand summary:         887389f56b2b4692471f0cca0b7e7c0e79c3eae9f760a547c13cbfdde9bd2ad5
release summary:      4f1b17eb13808ca73f5f4c8e3755e879db12e644d6a93bebdbc7b7a3111b52de
qualification summary: 601557e46fb660a62903ce0313322b5b264b8b74504b147cf9a53ff09bdb2bdc
```

## Factual standing

This is a mechanically reproduced source archive, not a fictional receipt and
not an aesthetic verdict. Its byte identity proves that the stated Git tree and
archive recipe reproduced this artifact twice on the recorded Git 2.43.0 host.
It does not prove the semantic claims inside without the separately recorded
executions and targeted review, and it does not claim cross-platform gzip byte
identity outside the tested toolchain.
