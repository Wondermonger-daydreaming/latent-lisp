# Lisp+ Canonical Datum /0 post-merge verification

Date: 2026-07-13 (America/Sao_Paulo)

Run commit: `efe52efe3e0e5a24181ee324e18b23e266129104`

Run tree: `13871b0b0ec81e667611163bc78976b3a91ff4b7`

Environment: CPython 3.11.14, SBCL 2.4.6, Git 2.43.0

Status: **PASS within the finite scopes stated below**

## Verification boundary

All commands ran from a fresh working tree created from the fresh remote mirror
at the exact merge commit. Before evidence documents were added, the worktree
was clean and this command exited `0`:

```text
git diff --exit-code \
  efe52efe3e0e5a24181ee324e18b23e266129104 -- \
  canonical-datum mneme/spec \
  CANONICAL-DATUM-SPEC-ERRATA-0.1.md \
  CD0-POST-IMPLEMENTATION-RULING.md
```

The merge itself has an empty diff from its authorized integration parent, so
the full 100,863-request-per-codec release differential was not repeated. The
protected 10,000-row projection was recomputed directly from both committed
corpora. Finite testing supports the recorded conformance scope; it is not a
formal proof over every host, resource condition, or future implementation.

## Obligation ledger

| ID | Obligation | Direct verification | Status | Residual boundary |
|---|---|---|---|---|
| V1 | Pin the three normative documents and Fable receipt | four SHA-256 checks | satisfied | Hashes establish byte identity, not semantic truth |
| V2 | Reproduce all worked vectors and Phase-0 accounting | `verify_phase0.py` | satisfied | Finite committed vectors |
| V3 | Execute the 467-row hand corpus in both codecs | `run_differential.py` with retained artifacts | satisfied | Finite corpus and recorded hosts |
| V4 | Execute all 39 promoted errata operations and both returned A9 rows | hand differential and exact response inspection | satisfied | Finite promoted cases |
| V5 | Preserve the protected 10,000-row projection | repository-owned projection function | satisfied | Four protected fields over the committed corpus |
| V6 | Run complete Common Lisp and Python suites | seed-suite commands | satisfied | SBCL 2.4.6 and CPython 3.11.14 |
| V7 | Preserve existing v1 behavior | `mneme/verify-all.sh` | satisfied | Six repository suites, not all possible v1 clients |
| V8 | Reconstruct and verify the split evidence archive | part hashes, concatenation, gzip and listing checks | satisfied | Container integrity, not independent truth of every member claim |

## 1. Exact document and Fable hashes

Command:

```text
sha256sum \
  mneme/spec/CANONICAL-DATUM-SPEC.md \
  CANONICAL-DATUM-SPEC-ERRATA-0.1.md \
  CD0-POST-IMPLEMENTATION-RULING.md
```

Results:

```text
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271  CANONICAL-DATUM-SPEC-ERRATA-0.1.md
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc  CD0-POST-IMPLEMENTATION-RULING.md
```

The exact remote-preserved Fable receipt was streamed from the rescue ref and
hashed:

```text
git show \
  refs/heads/rescue/cd0-disk-full-2026-07-13:recovery-evidence/2026-07-13/fable/FABLE-CD0-A9-CLOSURE-VERIFICATION.md \
  | sha256sum
```

Result: 6,199 bytes and
`96a1b9678c098493ac6cca0fb1b0b7fa3a03e3fef6e60ee907f34f7454faed1e`.

## 2. Worked vectors and Phase-0 accounting

Command:

```text
python3 canonical-datum/tools/verify_phase0.py
```

Exit `0`. The verifier reported:

```text
worked vectors: 17/17 exact and grammar-derived encodings agree
negative vectors: 71 classified = 66 octet + 5 host
execution accounting contract: Python 71 executed; Common Lisp 68 executed + 3 N/A
0 failures; 0 skips
promoted Errata 0.1 operation vectors: 39 complete A1-A9 cases
```

N/A dispositions are neither passes nor failures.

## 3. Default bounded qualification

Command:

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir /tmp/cd0-postmerge-qualification-20260713-1
```

Exit `0`, status **PASS**. The run included the Phase-0 verifier, the complete
hand differential, both complete seed suites, harness self-tests, 512
deterministic round trips, 513 equality/encoding properties, resource and
runtime probes, and reported:

```text
golden requests per codec: 467
classified hostile/resource failures: 14
resource retries: 6
warranted cross-codec disagreements: 0
Common Lisp language-specific host descriptors: 3 not applicable (not passes)
A1-A9: 39 promoted vectors executed with complete adjudicated expectations
```

The 10,999-byte machine summary SHA-256 was
`44473af684b05c2dcd5166b70a996479dbf3e3f6e9c8b9efcd33216b825f3ae4`.

## 4. Hand differential and exact A9 responses

Command:

```text
python3 canonical-datum/integration/run_differential.py \
  --artifacts-dir /tmp/cd0-postmerge-hand-differential-20260713-1
```

Exit `0`, status **PASS**:

```text
requests: 467 in each of 2 isolated codec processes
positives: 25/25
classified negatives: 71/71
Common Lisp: 68 executed, 3 host N/A
Python: 71 executed, 0 host N/A
equality matrix: 325/325
integration regressions: 7/7
promoted Errata 0.1 operations: 39/39
failures: 0; skips: 0; warranted disagreements: 0
```

Arithmetic: `25 + 71 + 325 + 7 + 39 = 467` requests per codec.
The request and response files each contained 467 rows. Their SHA-256 values
were:

```text
8f1ea3b37e4a501eb2c82c5bfc53ad3032fd32b2fc137335fd46d926e669bb36  requests.jsonl
a37ba62f18490e3ca3be55db333efda19f8db898cea36e96b01ca410b8e16424  common-lisp-responses.jsonl
65fa0d7d0a595481b8dc42a690ed08c03d6a1f62b9426db2e07bba880eda812d  python-responses.jsonl
```

Both permanent rows used `seq[Unit]` under the indicated sole structural
override:

```text
cd0-errata-a9-runtime-seq-unit-depth-one  max_depth=1
cd0-errata-a9-runtime-seq-unit-nodes-one  max_nodes=1
```

All four responses—two rows through each codec—returned `status: "ok"` and
exact `canonical_hex: "4c50434400300100"` through protocol
`lisp-plus-cd0-differential/v1`.

## 5. Protected 10,000-row projection

The existing repository function `compare_audited_positive_semantics()` was
invoked directly on the current Errata 0.1 corpus:

```text
python3 -c 'import json, sys; from pathlib import Path; sys.path.insert(0, "canonical-datum/release"); import run_generated_differential as r; print(json.dumps(r.compare_audited_positive_semantics(Path("canonical-datum/generated/release-errata-0.1/cd0-generated-positive.jsonl"), release_qualified=True), indent=2, sort_keys=True))'
```

Exit `0` and result:

```text
compared_rows: 10000
canonical_octet_changes: 0
abstract_datum_changes: 0
decoded_ast_changes: 0
equality_class_changes: 0
baseline_projection_sha256: 21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58
current_projection_sha256:  21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58
```

## 6. Complete codec suites

Common Lisp command:

```text
sbcl --noinform --disable-debugger \
  --script canonical-datum/common-lisp/run-tests.lisp
```

Exit `0`, **PASS**: 25/25 positives; 71/71 classified rows; 66/66 octet
rows; 2/2 applicable host rows; 3/3 explicit N/A; 68/68 executed; zero
failures/skips; 2,633 assertions.

Python command:

```text
PYTHONPATH=canonical-datum/python \
  python3 -m unittest discover -s canonical-datum/python/tests -v
```

Exit `0`: `Ran 167 tests`; `OK`.

## 7. Existing v1 verification

Command:

```text
./mneme/verify-all.sh
```

Exit `0`. All six suites passed:

```text
conformance-walk 7/7
adversarial-conformance 18/18
counterexample-closure 10/10
boundary 9/9
atelier 4 pass banners
language-a-fixtures 14 PASS plus suite banner
ALL FLOORS HOLD — 6/6 suites green
```

## 8. Split archive reconstruction

Commands:

```text
sha256sum \
  canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-00 \
  canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-01
cat \
  canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-00 \
  canonical-datum/evidence/artifacts/cd0-a9-two-vector-2026-07-13.tar.gz.part-01 \
  > /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
stat --printf='%s bytes\n' \
  /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
sha256sum /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
gzip -t /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz
tar -tzf /tmp/cd0-a9-two-vector-2026-07-13.reassembled.tar.gz | wc -l
```

Results:

```text
part 00: 94,371,840 bytes; 4250bf49129846dddc06dd3e20959c572ed815d9d3021b3a9c75e1366d48dde3
part 01: 13,852,034 bytes; 2d433e14f142aa7c4a93461125186fa22925a5b5ea8c1089e469e42219120d07
reconstructed: 108,223,874 bytes
reconstructed SHA-256: 3414dbeb12d8930ee5dd29145254513411989dd9f57104b90144a480688cc3eb
gzip test: exit 0
archive entries: 1,468
```

## Final protected-boundary result

The merged CD/0 tree is the reviewed integration tree. The post-merge checks
found no change to canonical octets, equality laws, accepted documents, wire
grammar, datum families, format version, decoder behavior, immutable runtime
contract, failure classifications, or existing v1 semantics.
