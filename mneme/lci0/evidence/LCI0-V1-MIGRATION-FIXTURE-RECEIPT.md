# LCI/0 v1 Migration Fixture Receipt

Date: 2026-07-14

Status: unaffected inert fixture-migration paths converged; P024, P029, and the
unpinned classification/content matrix remain BLOCKED pending authorial
closure

## Authorized boundary

Only the frozen, non-evaluating, bounded fixture migration grammar and exact
package mappings were exercised. The implementations produced inert fixture
data only. They did not load or run legacy v1 code, consult a current v1
registry or procedure, restore a live warrant, create authority, or begin
production migration.

This receipt does not authorize live migration.

## Bound implementations

| Artifact | Commit | Tree |
| --- | --- | --- |
| Common Lisp successor | `2513c354721bac6120b8c0a5eef1ed13252cf75b` | `9ce6786ee374f3dafe859c6ea5977b27e6c6f718` |
| Python successor | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` | `74c6a7e5c144d3286b83a933b27cff3d5865921d` |
| Integration tree executed | `e6983952ea726366b69435b29eeb37eb76f8504d` | `daaef9bad97eced6c242fc8052cbedc8920d355a` |

Runtime: SBCL 2.4.6; Python 3.11.14; Linux x86-64 under WSL2.

## Normative fixture obligations

| ID | Obligation | Result | Evidence/boundary |
| --- | --- | --- | --- |
| V1-01 | Parse only the declared non-evaluating bounded grammar | PASS with one tuple blocker | E9 hostile-read-eval exact; 8 generated grammar cases; reference-substitution failure choice remains blocked |
| V1-02 | Use only exact frozen package/symbol mappings | PASS | E9 near-miss and semantically-wrong mapping exact failures |
| V1-03 | Use exact `as-of` source-site-to-role table | PASS | E9 middle-ground exact `UnclassifiedAsOf` refusal |
| V1-04 | Use exact scope, time, corpus, and frame mappings | PASS on unaffected vectors | Migration and collision outputs compared byte-identically |
| V1-05 | Distinguish the seven frozen classifications | PASS for seven pinned E9 mappings; BLOCKED for novel matrix | One exact vector per classification; inverse content-validity matrix unpinned |
| V1-06 | Produce exact closed represented-loss accounts | PASS | 14/14 LOSS vectors in both languages |
| V1-07 | Preserve old fingerprints as inert predecessor metadata only | PASS | Exact migration outputs and source-provenance properties |
| V1-08 | Create zero live warrants | PASS | Eight observed vector result fields per implementation are false; generated inertness case false |
| V1-09 | Refuse attempted live restoration | PASS | E9 exact `PrivilegedRestorationAttempt`; generated restoration witness |
| V1-10 | Reject unknown fields/versions deterministically | PASS with novel tuple boundary | Closed payload and language-unit gates; unpinned full tuples remain blocked |
| V1-11 | Avoid current registry, filesystem, network, procedure, and clock lookup | PASS within stated harness boundary | Poisoned result/registry tests and unavailable-I/O/clock profiles |
| V1-12 | Keep CD/0 and LCI failure jurisdictions distinct | PASS on pinned paths | Exact category/code/stage/path comparisons |

`PASS with ... blocker` means the named positive obligation is directly
observed while one exact result coordinate lacks authorial definition. It does
not promote that blocked coordinate to pass.

## Vector and property census

| Family/result | Scope | Result in each implementation |
| --- | ---: | --- |
| P024–P030 | 7 vectors | 5 exact pass; P024 and P029 exact documents blocked |
| E9 family | 15 vectors | 15/15 exact pass |
| LOSS family | 14 vectors | 14/14 exact pass |
| E9 classification mappings | 7 vectors | 7/7 exact pass, one per frozen classification |
| Generated migration grammar | 8 logical cases × 6 profiles | All unaffected coordinates converge |
| Generated migration inertness | 2 logical cases × 6 profiles | All converge; restoration refuses |
| Generated source provenance | 2 logical cases × 6 profiles | All converge; explicit source preserved |

The seven pinned classification results are exactly:

- `exact`;
- `exact-after-explicit-tagging`;
- `new-identity-required`;
- `lossy-with-represented-loss`;
- `rejected`;
- `deferred-to-named-calculus`; and
- `privileged-runtime-relation-outside-claim-id`.

Their successful execution does not define unvectored classification/content
combinations. Those remain owned by
`LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md`.

## Inert/live observations

The exact vector outputs contain eight `live-warrants-created` fields per
implementation across P027, P028, P029, and E9 inert-predecessor results. Every
one is boolean false. P029's source-artifact result document remains blocked,
but its false inert/live coordinate is not disputed.

The post-convergence `migration-inert` case independently requires
`live-warrants-created=false` in all six profiles. The
`migration-live-restoration` case requires the exact failure code
`PrivilegedRestorationAttempt`, stage `privilege-boundary`, and path
`fixture-field:parsed-inert-value / fixture-field:attempt-live-restoration`;
all profiles converged.

Observed live warrants created: zero. Observed legacy runtime
loads/evaluations: zero. These are bounded execution observations, not claims
about any production migration system.

## Exact blockers

| Packet | Migration impact |
| --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md` | P029 binds corpus-r4 source `.../v1/1`, while its expected right result uses `.../v1/2`; exact result blocked |
| `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md` | Complete classification/content validity matrix and inverse failure tuples are not pinned |
| `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md` | P024 expected output injects an occurrence not bound by its input; exact result blocked |
| `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md` | Novel missing/unknown migration-payload category/stage/path/context coordinates remain blocked |

The remaining six packets do not presently reopen the bounded grammar or the
zero-live-warrant result, but remain part of the overall authorial closure
request.

The independent audit's six Python corrections concerned ClaimId projection
closure, the exact empty profile-location schema, target coordinate/order
checks, narrowing-order precedence, mutable-alias coverage, and validation of
ClaimId-equality operands. None changed the frozen migration grammar, mapping,
classification, loss-account, predecessor, or inert/live result. The r4 exact
run and final6 generated run reproduce the migration counts above. No new
authorial-return packet was created; the ten existing packets remain the full
authorial set.

## Raw evidence

Exact vector transcript:
`mneme/lci0/differential/artifacts/successor-final-2026-07-14/`

- `requests.jsonl`: 24,458,265 bytes, SHA-256
  `b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c`.
- Common Lisp responses: 25,763,401 bytes, SHA-256
  `46695fbdcc3d7b449297c7d591473fb842ea1db93a151bb8e65e9c9492a693a7`.
- Python responses: 25,753,084 bytes, SHA-256
  `5b185919ab0599d43e845f9624faa17940c03bc6efb3c4988a4604505cff3542`.
- Summary: 1,541,123 bytes, SHA-256
  `7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e`.
- Manifest: 804 bytes, SHA-256
  `d81d084cac92b10bdc8bbde66f3f5a6e89dcf55f4b6b718762653ae4d1c6b994`.

Generated migration/host transcript:
`mneme/lci0/differential/artifacts/post-convergence-final-2026-07-14/`

- `cases.json`: 243,600 bytes, SHA-256
  `5a573656458f41a8418e9d2fc8a8f5d97aea5cd3c373dd30cc5999b1f281f6d1`.
- `summary.json`: 357,939 bytes, SHA-256
  `0a318264436c6b6dd018fa31188315610d4bea8486bd0c61463d9e6a9fdcce6c`.
- manifest: 6,897 bytes, SHA-256
  `8ef26d59732db292ad307ae0bfc3b5db5d512a2291b771e208965afdbe449ead`.

The raw members were committed in
`7ff074fdc234d826a113b0beb5e36b490d94b579` before archive reconstruction and
loose-file cleanup. Archive verification and publication are recorded in
their own receipts and are not inferred here.

## Reproduction commands

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-exact-final-head-r4-20260714
```

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/post_convergence.py --successor-artifacts /tmp/lci0-exact-final-head-r4-20260714 --output /tmp/lci0-post-convergence-final6-20260714 --seed 1279478064 --allocation-cases 64
```

## Disposition

The unaffected inert migration, represented-loss, mapping, parser-refusal, and
zero-live-warrant surfaces converge across both implementations. P024, P029,
and unpinned novel migration coordinates remain BLOCKED pending authorial
closure. No live v1 migration, production standing, authority, or warrant
system was implemented or authorized.
