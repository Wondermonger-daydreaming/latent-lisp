# CD/0 Errata 0.1 differential receipt

Date: 2026-07-13

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
| `summary.json` | 2,814 bytes | `887389f56b2b4692471f0cca0b7e7c0e79c3eae9f760a547c13cbfdde9bd2ad5` |

The six retained files total 608,001 bytes. They entered history at commit
`3d0aba8ef31fde03e24b59ca2993260bcd88cda3`, tree
`a14492aec571ca62c214740bb67bbf2087108445`.

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
