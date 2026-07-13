# CD/0 Errata 0.1 differential receipt

Date: 2026-07-13

## Focused A9 two-vector superseding run

Fable protocol `49b3cf88` added exactly two A9 `runtime-encode` operations.
The current retained evidence is
`canonical-datum/evidence/a9-two-vector-2026-07-13/hand/`.

| Artifact | Rows or bytes | SHA-256 |
|---|---:|---|
| `requests.jsonl` | 467 rows | `8f1ea3b37e4a501eb2c82c5bfc53ad3032fd32b2fc137335fd46d926e669bb36` |
| `common-lisp-responses.jsonl` | 467 rows | `a37ba62f18490e3ca3be55db333efda19f8db898cea36e96b01ca410b8e16424` |
| `python-responses.jsonl` | 467 rows | `65fa0d7d0a595481b8dc42a690ed08c03d6a1f62b9426db2e07bba880eda812d` |
| each stderr | 0 bytes | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `summary.json` | 2,814 bytes | `8dd3156abfbf14ca15c90e64d539ca022d3f930a42f0adabaf943458c4641078` |

Current arithmetic per codec is
`25 + 71 + 325 + 7 + 39 = 467`. Promoted decomposition is
`6/5/6/3/3/2/1/6/7`; failures `0`, skips `0`. Both new A9 rows returned
`4c50434400300100` in both response streams. The historical comparator passed
with zero canonical-octet, normalized-datum, equality-result, or disposition
changes.

The 37/465 material below is retained as the factual first-closure receipt and
is superseded only for the promoted-operation-derived arithmetic.

This receipt covers the finite hand corpus, the 37 promoted A1–A9 operation
vectors, and the historical hand-corpus compatibility comparison. The generated
release-scale comparison has its own receipt. Neither codec is used as the
normative oracle; expectations are pinned shared inputs governed by the base
specification, ruling, and Errata 0.1.

## Retained artifacts

Evidence directory:
`canonical-datum/evidence/transcripts/phase2-errata-0.1`

| Artifact | Rows or bytes | SHA-256 |
|---|---:|---|
| `requests.jsonl` | 465 rows | `a9708500d61a65b302989722d98fca0d9b8caaa470bb45be452cf3ca09492e69` |
| `common-lisp-responses.jsonl` | 465 rows | `f9a8d257527c5304bc16ff5356e3c65b8296e90dc74eea6b61335f1db93b0092` |
| `python-responses.jsonl` | 465 rows | `a4eee701b263e21c891ab265a52198b30669b1aade69de34c463dfd9f56a86d4` |
| `common-lisp-stderr.txt` | 0 bytes | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `python-stderr.txt` | 0 bytes | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `summary.json` | 2,813 bytes | `3c62572cb962c5fb4ab8395937901355ea54f0664032ad2a7ccdaa6f937396c4` |

The six retained files total 608,000 bytes.  The post-review rerun used the
repaired integration source after commit `bdb2214878ebb302329a40e895269ff950b8ae97`.
Requests and both response streams remained byte-identical to the earlier local
closure run; only the summary's observed timings changed.  The immutable
archive receipt pins the final evidence-complete commit containing this result.

## Command and result

```text
python3 canonical-datum/integration/run_differential.py \
  --artifacts-dir canonical-datum/evidence/transcripts/phase2-errata-0.1 \
  --json
```

Exit status: `0`. Summary status: `PASS`. Issues: `[]`. Adapter stderr:
empty for both implementations.

Per-codec request arithmetic:

| Class | Count | Standing |
|---|---:|---|
| positive construction/round-trip | 25 | executed |
| classified Phase-0 negative | 71 | dispositioned as below |
| equality | 325 | executed |
| historical integration regression | 7 | executed |
| promoted A1–A9 operation | 37 | executed; 0 failures; 0 skips |
| total | 465 | exact request count per codec |

Promoted-operation decomposition:

```text
A1 6 + A2 5 + A3 6 + A4 3 + A5 3 + A6 2 + A7 1 + A8 6 + A9 5 = 37
```

## Phase-0 dispositions

The 71 classified rows are exactly 66 octet rows plus five host rows.

| Implementation | Executed | N/A | Failures | Skips | Classified total |
|---|---:|---:|---:|---:|---:|
| Python | 71 | 0 | 0 | 0 | 71 |
| Common Lisp | 68 | 3 | 0 | 0 | 71 |

Common Lisp executed all 66 octet rows and two applicable generic host rows.
Its three language-specific optional-importer rows were recorded as N/A. N/A is
neither pass nor failure and never contributes to executed-row counts.

## Compared observables

The runner compared, as applicable to each request:

- canonical octets and decode/re-encode identity;
- normalized abstract fixture datums;
- constructed-versus-decoded and cross-fixture equality results;
- complete failure category/code/stage triples;
- exact fixture dispositions, including the closed N/A set;
- operation-isolated resource behavior for decode, host import, runtime encode,
  and construction descriptors.

The summary reported no warranted disagreement.

## Historical compatibility comparison

Command:

```text
python3 canonical-datum/tools/compare_errata_hand_baseline.py \
  --baseline-dir canonical-datum/evidence/transcripts/phase2-convergence \
  --errata-dir canonical-datum/evidence/transcripts/phase2-errata-0.1 \
  --json
```

Exit status `0`; status `PASS`; issues `[]`. Separately for Common Lisp and
Python, the comparator matched:

| Historical class | Compared per codec | Differences |
|---|---:|---:|
| positive | 22 | 0 |
| negative disposition | 71 | 0 |
| equality | 253 | 0 |
| integration regression | 7 | 0 |

The current additive corpus has 25 positives, 71 negative rows, 325 equality
judgments, seven regressions, and 37 errata operations per codec. Aggregate
protected-observable changes over the historical overlap were:

```text
canonical octets:            0
normalized abstract datums:  0
equality results:             0
historical dispositions:     0
```

The three added positive rows exercise rational source constructions `2/4`,
`2/2`, and `0/7` through a descriptor distinct from the normalized abstract
datum. Their results use already-established canonical identities; they do not
add a datum or accepted wire document.

## Boundary

This receipt is finite evidence at the retained SBCL 2.4.6 and CPython 3.11.14
vantage. It does not execute the three optional Common Lisp importers, infer
semantics from agreement, or establish universal conformance. The release-scale
result and mutation/property probes are recorded in
`CD0-ERRATA-RELEASE-RECEIPT.md` and
`CD0-ERRATA-VERIFICATION-TRANSCRIPT.md`.
