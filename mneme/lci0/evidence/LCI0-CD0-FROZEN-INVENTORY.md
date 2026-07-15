# Frozen CD/0 Source and Vector Inventory

Inventory basis: accepted CD/0 commit
`efe52efe3e0e5a24181ee324e18b23e266129104`, tree
`13871b0b0ec81e667611163bc78976b3a91ff4b7`. Every file below was read in full
before LCI/0 implementation code was created. These exact hashes are protected
nonregression identities.

| Frozen file | SHA-256 |
| --- | --- |
| `canonical-datum/common-lisp/README.md` | `c90b9368b7ce963e40a010d388cc1efd5a6d01c80efb6c632f616c0ee6f5d3cb` |
| `canonical-datum/common-lisp/cd0.lisp` | `ab9ec04db911222192ed99c413b580179f2cd0539c240f96f3ded933bfb921b7` |
| `canonical-datum/common-lisp/lisp-plus-cd0.asd` | `b067d1b025d3116e833a48632ee7d1f4eb2cc753f16e03e606a387884fe50148` |
| `canonical-datum/common-lisp/package.lisp` | `b52b60bd3f065e7f6dc21e8f33cafeb61a3c075ac99ecb6ad69a8b8d32a815cf` |
| `canonical-datum/common-lisp/run-tests.lisp` | `1e11cd5066ba0fa11050aa53c920005051ea83eba348bbba4081bdccf674c910` |
| `canonical-datum/common-lisp/tests.lisp` | `dfc6496edf8c1239bfbe46d540a038d5bae5b261fbebd7ade70cb338c7cea39e` |
| `canonical-datum/python/README.md` | `8ddf3539eb374f4ef811920521ded80449647e179ac2b4bcf689f608da3c0eda` |
| `canonical-datum/python/cd0/__init__.py` | `4d251590e4957187552ee0a2c6dc4131348fec54be2bb424839ef8e61f880dbe` |
| `canonical-datum/python/tests/test_cd0.py` | `32b4ba2e8e6581850531f5d3869d5df2107efd53ed3bbcce9c398c03a572ea91` |
| `canonical-datum/integration/README.md` | `7094cbdd4e1402a44a063e7fa895d694ce594dba1042f879c66ce58342e148f8` |
| `canonical-datum/integration/common_lisp_adapter.lisp` | `35a89dd77734bb5a2f6e3142a2cbdd5c3552ab040493b83795a308a6a066f351` |
| `canonical-datum/integration/python_adapter.py` | `8478bc1687d2df233e95455c8bfa9f4d6a4e74443e3aec62c30b2dd4ddc5a872` |
| `canonical-datum/integration/run_differential.py` | `5b223b8914285e3359698fe7327c3bfced000656375a341b4346ef99789c252e` |
| `canonical-datum/integration/cases/cd0-integration-regressions.json` | `293fcd6cc0df40ce95446bfdcac5be008a2bf96364fd3ba1da38c6508ed95cbc` |
| `canonical-datum/schema/cd0-fixtures.schema.json` | `6609a6d97140f1fda5a538ccb908bb820bcdad380b7dd8efb05fa8a9e7a0407c` |
| `canonical-datum/vectors/cd0-budgets.json` | `ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98` |
| `canonical-datum/vectors/cd0-distinct-pairs.json` | `ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27` |
| `canonical-datum/vectors/cd0-errata-0.1.json` | `731a74ed61352200d378771f43b747d64bfcc0dea793b116d25b0b888ee11bc3` |
| `canonical-datum/vectors/cd0-negative.jsonl` | `d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6` |
| `canonical-datum/vectors/cd0-positive.jsonl` | `34fe63302e686efc0bcf1b1d841dbc5392c7f5abae393390eca40680179492b4` |

The frozen reference packet SHA-256 is
`bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81`.
Its sealed checksum file verifies all fourteen listed packet payloads; the
repository inventory above additionally covers the executable codecs, their
tests, integration adapters, schema, and vectors used by LCI/0.
