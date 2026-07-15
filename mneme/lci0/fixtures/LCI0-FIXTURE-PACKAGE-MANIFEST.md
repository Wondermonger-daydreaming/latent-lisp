# LCI/0 FIXTURE PACKAGE MANIFEST

**Package root:** `lci0-errata-0.1-fixture-package-2026-07-14/`  
**Build date:** `2026-07-14`  
**Candidate SHA-256:** `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`  
**Frozen CD/0 packet SHA-256:** `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81`  
**Consultation packet SHA-256:** `e2740dc037837a539e3b1b7d6e07675c139263e2b6f41ee579d85e5efcdbaaf2`  
**Repository commit:** `56f0ce55253ef8dd4caaf80b03e49835c4087406`  
**Registry definitions:** `675`  
**Vectors:** `215`  
**CD/0 documents independently checked:** `1105`

## Status

This manifest inventories the exact logical member set of the ZIP and TAR.GZ packets. The two archives contain the same paths under the package root. All authored text uses UTF-8 with LF line endings. The JSON registry is sorted/indented UTF-8 JSON; the vector artifact is one compact JSON object per LF-terminated line.

The package remains **NOT AUTHORIZED UNTIL FABLE VERIFIES ERRATA AND FIXTURE PACKAGE**.

## Payload integrity table

| Logical member path | Bytes | SHA-256 | Role |
| --- | --- | --- | --- |
| LCI0-POST-REVIEW-RULING.md | 19714 | c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7 | Primary authored artifact |
| LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md | 113990 | f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea | Primary authored artifact |
| LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md | 274969 | ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f | Primary authored artifact |
| LCI0-FIXTURE-REGISTRY.json | 158009634 | dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327 | Primary authored artifact |
| LCI0-FIXTURE-VECTORS.jsonl | 26665609 | 387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4 | Primary authored artifact |
| reviewed-inputs/consultation/PACKET-MANIFEST.md | 2689 | bf2c645595a42eceace32eb707269cbf8edbafc8dcb9bcdf1fd8f8643d6bc5cf | Outer consultation-packet manifest |
| reviewed-inputs/consultation/SHA256SUMS.txt | 1450 | d1242f09b9ec2d6f5b12c948cc7e282f0f05d870dcb55574c4b1f40b9103fcd0 | Outer consultation-packet checksums |
| reviewed-inputs/normative-candidate/LOCATED-CLAIM-IDENTITY-SPEC.md | 206741 | 6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba | Reviewed LCI/0 candidate specification |
| reviewed-inputs/review/FABLE-LCI0-CONSTITUTIONAL-REVIEW.md | 28151 | 65a989381fce365ba7057f07f6511e7a606ab4d2f2b4b052acda07dd11d1a50e | Fable constitutional review |
| reviewed-inputs/review/FABLE-LCI0-ISSUE-REGISTER.md | 18738 | a22e9f430c32f96472c4fcbe327309fb343a498094e47f486c00359a92221806 | Fable issue register |
| reviewed-inputs/review/FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY.md | 8738 | 9502d24b03675db1d8b5fd7788ebfb50ea31ab9e452d8a440f3e935fd5b9ef03 | Fable readiness relay |
| reviewed-inputs/annexes/CUSTODIAN.md | 32301 | 38d8b8bdee91178bcaa38f2efb673201f9c03e1a14236ea40729461b17544b96 | Fable annex CUSTODIAN |
| reviewed-inputs/annexes/FERRYMAN.md | 36655 | 4aee7d1c13322a51c74547762b05ad847e2d431c564e0e6f82b95c5ba2d21f8e | Fable annex FERRYMAN |
| reviewed-inputs/annexes/GEOMETER.md | 37027 | 0159b18cd96158ae209cb8abd54d1a102ae0236ce9877c7f52378957865fc86a | Fable annex GEOMETER |
| reviewed-inputs/annexes/KNIFE.md | 36086 | cf03312a21824db32fd79e86e445e77cafe2e5f2173c298241fb434145f4c7cf | Fable annex KNIFE |
| reviewed-inputs/annexes/SECOND-KNIFE.md | 38155 | 8f8d0c9f7aad8e7da721b40c0cdf5458b0f4b536f0a354f29a86b0787be28ef4 | Fable annex SECOND-KNIFE |
| reviewed-inputs/annexes/SURVEYOR.md | 92476 | b619b9997597ba4c2102b6e1770767afab81a6995a5363370d6dd122619f461a | Fable annex SURVEYOR |
| reviewed-inputs/annexes/WARDEN.md | 42267 | 43aefb186bfc5438e047d73f6c88b243be3f85e3ba34987bce4db82e5a7e95bf | Fable annex WARDEN |
| reviewed-inputs/frozen-dependency/lisp-plus-lci0-cd0-frozen-reference-packet-2026-07-13-56f0ce55253e.zip | 139321 | bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81 | Frozen CD/0 reference packet |
| reviewed-inputs/frozen-dependency/lisp-plus-lci0-cd0-frozen-reference-packet-2026-07-13-56f0ce55253e.zip.sha256 | 137 | d60ea6e286547b3c0877bba38fa26492c0a8d61bd3e088e63399ef38bce38ddb | Frozen CD/0 packet checksum sidecar |

`LCI0-FIXTURE-PACKAGE-MANIFEST.md` and `LCI0-FIXTURE-SHA256SUMS.txt` are bookkeeping members. To avoid self-referential hash recursion, this manifest’s table covers every immutable payload member but not the two bookkeeping files. The checksum file covers every payload member plus this manifest and omits only itself. The checksum file’s own receipt and both archive receipts are reported externally with the deliverables.

## Exact-byte verification record

| Instrument | Identity/version | Command | Documents | Result | Limitation |
| --- | --- | --- | --- | --- | --- |
| Authoring encoder/decoder | clean-room Python authoring pass | generate.py + finalize.py | 1105 | PASS | Authoring instrument, not normative oracle |
| Independent clean-room verifier | Node v22.16.0 | node --max-old-space-size=4096 verify_cd0.js <registry> <vectors> | 1105 | PASS | Independent grammar implementation |
| Frozen repository Python CD/0 | commit 56f0ce55253ef8dd4caaf80b03e49835c4087406; CPython 3.13.5 | python3 verify_frozen_python.py | 1105 | PASS | Fetched exact implementation source and used explicit fixture adapter |
| Frozen repository Common Lisp CD/0 | commit 56f0ce55253ef8dd4caaf80b03e49835c4087406; SBCL seed command recorded | sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp + corpus adapter | 1105 | FABLE GATE | No Common Lisp runtime in authoring environment; Fable must rerun |

## Completeness assertions

- All `LCI0-P001`–`LCI0-P030` and `LCI0-N001`–`LCI0-N032` are present.
- Every vector ID is unique.
- Every registry definition and vector aggregate input/expected result has complete lowercase canonical hex, byte count, checksum, and expected decoded abstract value.
- All fourteen StableRef fixture domains have one and only one structural scheme definition.
- All eleven target kinds have a closed schema, a positive vector, and a negative vector.
- Both policies hard-reject every F-valued relation result.
- Migration is non-evaluating and creates zero live warrants.
- ZIP and TAR.GZ are produced from one staging tree and verified for identical logical member paths.
