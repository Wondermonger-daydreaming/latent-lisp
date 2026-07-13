# CD/0 Common Lisp seed artifact manifest

Created `2026-07-13` in response to the request for an independent Common Lisp
implementation of Lisp+ Canonical Datum /0.  The code is authored by Codex from
the pinned normative specification and shared hand-authored fixtures under the
clean-room boundary recorded in `COMMON-LISP-SEED-SOURCE-ACCESS.md`.

This is implementation and verification evidence, not a specification amendment,
authority claim, differential-convergence receipt, or release certification.
The observed test results and their untested boundaries are recorded separately
in `COMMON-LISP-SEED-VERIFICATION.md`.

## Reproducible collection

`canonical-datum/evidence/artifacts/cd0-common-lisp-seed-2026-07-13.tar.gz`

SHA-256:

`f127278c9ec25c0d88eecde0bab614f5a8905976bf93734c1effbf73c8de0be1`

The archive was produced twice with GNU tar using sorted names, fixed
`UTC 2026-07-13` mtimes, numeric owner/group zero, and gzip compression.  `cmp`
reported the two products byte-identical.  Its inspected listing is:

```text
canonical-datum/common-lisp/
canonical-datum/common-lisp/README.md
canonical-datum/common-lisp/cd0.lisp
canonical-datum/common-lisp/lisp-plus-cd0.asd
canonical-datum/common-lisp/package.lisp
canonical-datum/common-lisp/run-tests.lisp
canonical-datum/common-lisp/tests.lisp
canonical-datum/evidence/COMMON-LISP-SEED-SOURCE-ACCESS.md
canonical-datum/evidence/COMMON-LISP-SEED-VERIFICATION.md
```

## Member source hashes

| File | SHA-256 |
|---|---|
| `package.lisp` | `45df264f7946f041a409f124da333719f6b20ffef22078725acfefc5ad4a4576` |
| `cd0.lisp` | `ae180cf4addf4d66cd70e198c5e48641b72f9c63542a5c39e7ba7fea411210a4` |
| `tests.lisp` | `6424bbc5b75a2afa43de589f40adcdea035b7c85c52ce41ac0cc6dbc7fb0d060` |
| `run-tests.lisp` | `1e11cd5066ba0fa11050aa53c920005051ea83eba348bbba4081bdccf674c910` |
| `lisp-plus-cd0.asd` | `b067d1b025d3116e833a48632ee7d1f4eb2cc753f16e03e606a387884fe50148` |
| `README.md` | `91b840f09c76ab69041f18b1ce9f052c8545d52339277d4b16080f4305909124` |
| `COMMON-LISP-SEED-SOURCE-ACCESS.md` | `04a7d894c8f813958145068e85eb04b394d570c1066a302982cb2ccc293e6734` |
| `COMMON-LISP-SEED-VERIFICATION.md` | `3b91a46e5f291ff373e695404f854ae32ed760888cadf89e8fb43d91e8abf15a` |
