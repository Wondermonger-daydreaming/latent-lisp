# CD/0 Errata 0.1 verification transcript

Date: 2026-07-13
Vantage: local WSL2 worktree
`/home/gauss/Codex-Lab/latent-lisp-cd0-integration-errata`
Run source checkpoint: commit
`59fdd5b65a2ab44f98ec91c0b1464650cf18cfb3`, tree
`bb185ab2e0adeacec6c390745df8d0b6422340db`
Status: all required local verification categories passed. Archive reproduction,
targeted review, and remote read-back have separate receipts because those facts
occur after this source checkpoint.

This transcript distinguishes commands executed, rows classified, rows
executed, N/A dispositions, failures, and skips. It does not describe the
Phase-0 result as “71 tests passed.”

## Environment and normative gate

Pre-change state and runtime details were captured before modification in the
external local baseline
`/tmp/CD0-ERRATA-PRECHANGE-BASELINE-2026-07-13.md`, SHA-256
`5ace3291811f7a34a63709cfdb0b027a148dd2ec436696c258ff555dfcd218bb`.
The execution environment was:

```text
date/time zone: 2026-07-13, America/Sao_Paulo
kernel:         Linux 6.18.33.2-microsoft-standard-WSL2 x86_64
glibc:          2.39
git:            2.43.0
SBCL:           2.4.6
Python:         3.11.14
```

Command:

```text
sha256sum CD0-POST-IMPLEMENTATION-RULING.md \
  CANONICAL-DATUM-SPEC-ERRATA-0.1.md \
  mneme/spec/CANONICAL-DATUM-SPEC.md
```

Exit: `0`. Stdout:

```text
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc  CD0-POST-IMPLEMENTATION-RULING.md
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271  CANONICAL-DATUM-SPEC-ERRATA-0.1.md
d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc  mneme/spec/CANONICAL-DATUM-SPEC.md
```

Stderr was empty.

## Before/after semantic witnesses

The red-regression commits and the complete before/after evidence are recorded
in `CD0-ERRATA-IMPLEMENTATION-LEDGER.md`. The load-bearing A2/A9 observation was:

```text
                         Common Lisp before                         Python before
A2 constructor          InvalidCanonicalGrammar/<code>/host-import UnsupportedHostInput/<code>/host-import
A9 encode [Unit], depth1 ResourceRefusal/ExcessiveNesting/type-tag  OK 4c50434400300100

                         both after
A2 constructor          UnsupportedHostInput/<code>/host-import
A9 encode [Unit], depth1 OK 4c50434400300100
```

Both old decoders routed count-promised EOF through local nested stages; both
now report `InvalidCanonicalGrammar/TruncatedInput/count`. These witness changes
are failure classification or operation-jurisdiction changes, not canonical
byte changes.

## Phase-0 vectors and accounting

Command:

```text
python3 canonical-datum/tools/verify_phase0.py
```

Exit: `0`; stderr empty. Stdout:

```text
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
worked vectors: 17/17 exact and grammar-derived encodings agree
additional positives: 8; equality classes and distinct pairs valid
negative vectors: 71 classified = 66 octet + 5 host; all complete normative triples
execution accounting contract: Python 71 executed; Common Lisp 68 executed + 3 N/A; 0 failures; 0 skips
promoted Errata 0.1 operation vectors: 37 complete A1-A9 cases
mutation self-tests: wrong failure code, reversed decoded record order, and split equality class rejected
type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present
sha256 34fe63302e686efc0bcf1b1d841dbc5392c7f5abae393390eca40680179492b4  canonical-datum/vectors/cd0-positive.jsonl
sha256 d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6  canonical-datum/vectors/cd0-negative.jsonl
sha256 55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc  canonical-datum/vectors/cd0-errata-0.1.json
sha256 ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27  canonical-datum/vectors/cd0-distinct-pairs.json
sha256 ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98  canonical-datum/vectors/cd0-budgets.json
sha256 6609a6d97140f1fda5a538ccb908bb820bcdad380b7dd8efb05fa8a9e7a0407c  canonical-datum/schema/cd0-fixtures.schema.json
```

Exact Phase-0 disposition:

| Implementation | Classified total | Octet executed | Host executed | Total executed | N/A | Failures | Skips |
|---|---:|---:|---:|---:|---:|---:|---:|
| Python | 71 | 66 | 5 | 71 | 0 | 0 | 0 |
| Common Lisp | 71 | 66 | 2 | 68 | 3 | 0 | 0 |

The three Common Lisp N/A dispositions are a closed language-specific set and
are neither passes nor failures.

## Complete codec suites

Common Lisp command:

```text
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
```

Exit `0`; stderr empty. Stdout is retained at
`canonical-datum/qualification/evidence/errata-final-run/05-common-lisp-seed-suite.stdout.txt`
and has SHA-256
`d668ad41b407923ff6e817db01e19747a4d8f1d5a08249d09bf710c0b4ce3e2c`.
Result:

```text
CD/0 Common Lisp seed conformance: PASS
shared positives executed: 25/25
shared negative classified total: 71/71
  octet rows executed: 66/66
  applicable host rows executed: 2/2
  language-specific N/A dispositions: 3/3
  classified rows executed: 68/68; failures: 0; skips: 0
resource-vector successful retries: 12
declared distinct pairs: 5
mutation probes: 15
resource refusal/retry probes: 19
ambient-state variants: 2
deterministic generated round trips: 500
grammar/Unicode boundary cases: 20
integration regression witnesses: 20
total assertions: 2629
```

Python command:

```text
env PYTHONPATH=canonical-datum/python \
  python3 -m unittest discover -s canonical-datum/python/tests -v
```

Exit `0`; stdout empty. The complete 164-test verbose stderr is retained at
`canonical-datum/qualification/evidence/errata-final-run/04-python-seed-suite.stderr.txt`,
SHA-256
`bb9c11f338bb8a65260ab2cea6f4efb9c0c3a48a68ce4d943c81fc2bdb2cde43`:

```text
Ran 164 tests
OK
```

One manual standalone invocation omitted `PYTHONPATH`:

```text
python3 -m unittest discover -s canonical-datum/python/tests -v
```

It exited `1` during discovery with `ModuleNotFoundError: No module named
'cd0'`. This was an operator invocation error, not a codec failure. The command
was immediately rerun with the documented `PYTHONPATH` and exited `0`; the
independently retained default qualification also ran the complete suite with
the correct environment and exited `0`.

## Hand-corpus differential and promoted A1–A9 vectors

Command:

```text
python3 canonical-datum/integration/run_differential.py \
  --artifacts-dir canonical-datum/evidence/transcripts/phase2-errata-0.1 \
  --json
```

Retained summary SHA-256:
`887389f56b2b4692471f0cca0b7e7c0e79c3eae9f760a547c13cbfdde9bd2ad5`.
Exit `0`, status `PASS`, issues `[]`. Both process stderr files are zero bytes
with SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

Each codec executed 465 requests:

```text
25 positives
71 classified negative rows
325 equality judgments
7 historical integration regressions
37 promoted Errata 0.1 operations
= 465 requests per codec
```

The promoted class executed A1=6, A2=5, A3=6, A4=3, A5=3, A6=2, A7=1,
A8=6, and A9=5, with 0 failures and 0 skips.

Historical compatibility command:

```text
python3 canonical-datum/tools/compare_errata_hand_baseline.py \
  --baseline-dir canonical-datum/evidence/transcripts/phase2-convergence \
  --errata-dir canonical-datum/evidence/transcripts/phase2-errata-0.1 \
  --json
```

Exit `0`, status `PASS`, issues `[]`. For each implementation it compared 22
historical positives, 71 negative dispositions, 253 historical equality
judgments, and seven regressions and found zero response differences. Aggregate
protected results were:

```text
canonical_octet_changes_in_historical_positives: 0
normalized_abstract_datum_changes_in_historical_positives: 0
equality_result_changes_in_historical_matrix: 0
historical_disposition_changes: 0
```

## Tooling regression suites

Generator command:

```text
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

Exit `0`, stdout/stderr result: `Ran 28 tests ... OK`. This includes the
post-review metadata regression that first failed because thirteen unrelated
resource rows carried an identifier-stage note, then passed after the note was
scoped to the two identifier rows.

Release-runner command:

```text
python3 -m unittest discover -s canonical-datum/release/tests -v
```

Exit `0`, result: `Ran 9 tests ... OK`.

Qualification self-tests are retained as child command 01 in the qualification
evidence. They exited `0`, ran nine tests, and reported `OK`; stderr SHA-256 is
`daedc47114aa7364dabe7852ad15c858d35c4c38f1e45d3cd1858aefda85aa5e`.

## Deterministic corpus regeneration

The generator was run twice from a detached clean worktree at exact commit
`59fdd5b65a2ab44f98ec91c0b1464650cf18cfb3`, once with
`PYTHONHASHSEED=1` and once with `PYTHONHASHSEED=777`, using the same output path
in successive runs:

```text
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir /tmp/cd0-final-regeneration/repeat \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20308 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

`diff -qr` exited `0`; all six files were byte-identical, including the
manifest. The identical hash map was:

```text
ee9a6ef6864e36e38c7a15ba010b8e5658dd212c09d103f1fc8af626b0a93d8b  cd0-corpus-manifest.json
2ffd77257e18dfbc70abef0cc5fae1603d50b1a8b005226af95200708c29ca02  cd0-generated-negative-derivations.jsonl
465e300ec0695b9d066b5a47662b1c87ff7327d3b6cb487d086034bb986194d4  cd0-generated-negative.jsonl
4d4d5ef09606d04d21297b4cd08c209a57cb090601bb790fbe3019a07c33c77d  cd0-generated-positive.jsonl
cf9bbce16a0aae99a4fbd363db313bd422c6796c694746a548fbdded161a2ab5  cd0-host-property-scenarios.json
9da19ecf42d5a8aba1aa1b978d1654c46f38ad37aaa66d81cbb1d6efdb96dfbb  cd0-mutation-candidates.jsonl
```

The aggregate corpus digest is
`62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58`.
The change from the earlier trial digest was solely the removal of a false
human-readable identifier-stage note from thirteen unrelated resource rows;
canonical inputs, expected triples, row counts, and all other data-artifact
hashes remained unchanged. The corrected generator source has SHA-256
`60668b2e1fae1962d255a55d244f9b86cccbb7873e00802451f1b10e6e3338ea`.

The 30,504 mutation-candidate scale is retained by admitting the 22 new
A7-linked hand-vector truncation points and deterministically displacing 22
redundant configured-size truncations from the tail. This is an explicitly
bounded fixture-promotion consequence; candidates remain unclassified and no
accepted datum or generator value semantics changed.

## Release differential

The complete receipt is `CD0-ERRATA-RELEASE-RECEIPT.md`. Command:

```text
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir canonical-datum/generated/release-errata-0.1 \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir canonical-datum/evidence/generated-differential-errata-0.1 \
  --json
```

Exit `0`, status `PASS`, 50 bounded batches, zero issues, zero mutation
disagreements, and 100,861 requests per implementation. Summary SHA-256:
`4f1b17eb13808ca73f5f4c8e3755e879db12e644d6a93bebdbc7b7a3111b52de`.

The audited-valid hard gate compared 10,000 rows and observed zero canonical
octet, normalized abstract datum, decoded AST, or equality-class changes. Both
the audited and current projections have SHA-256
`21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.

## Bounded hostile/property qualification, mutation resistance, and inertness

Command:

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir canonical-datum/qualification/evidence/errata-final-run \
  --json
```

Exit `0`, status `PASS`. Summary SHA-256:
`601557e46fb660a62903ce0313322b5b264b8b74504b147cf9a53ff09bdb2bdc`.

The property matrix executed 1,045 requests per codec: 512 deterministic random
round trips, 513 equality properties, 14 complete normative failure triples
(eight single-defect mutation cases and six resource boundaries), and six
sufficient-budget retries. Warranted cross-codec disagreements: `0`.

Runtime probes passed with:

- Python: seven mutation probes, one inert record, zero activation calls, four
  hash seeds (`0`, `1`, `137`, `777`), two dictionary-order variants, a
  640-digit ambient guard, cycle refusal, shared-acyclic acceptance, namespace
  distinction, resource retry, and depth-5,000 equality;
- Common Lisp: eleven mutation probes, one inert record, zero activation calls
  across eight guarded entry points, 1,024 concurrent read/encode pairs, cycle
  refusal, shared-acyclic acceptance, namespace distinction, resource retry,
  and depth-5,000 equality.

The cross-process inert-record identity hex was identical:

```text
4c504344003103220107616d6269656e740104626574611004220107616d6269656e740105616c7068611002220107616d6269656e74010567616d6d611006
```

These are bounded selected-hook observations, not a proof over reflection,
unsafe memory writes, native FFI, other runtimes, or unexposed syscalls.

## Existing-v1 non-regression

Command:

```text
bash mneme/verify-all.sh
```

Exit `0`; result:

```text
PASS conformance-walk        expected 7, got 7
PASS adversarial-conformance expected 18 passed 0 failed, got 18 passed 0 failed
PASS counterexample-closure  expected 10 passed 0 failed, got 10 passed 0 failed
PASS boundary                expected 9 passed 0 failed, got 9 passed 0 failed
PASS atelier                 expected 4 pass-banners, got 4
PASS language-a-fixtures     expected 14 PASS + SUITE PASSED, got 14 PASS / suite-line 1
ALL FLOORS HOLD — 6/6 suites green.
```

`git diff --exit-code baeecd5e0347435b9e1362000344f46ea441c6ec..HEAD -- mneme`
exited `0`: no file under `mneme/` changed from the audited integration tip.

## Result and bounded claim

All hand-authored positive and negative vectors, all promoted A1–A9 vectors,
both complete codec suites, the hand and release differentials, mutation and
retry paths, bounded hostile/property qualification, mutation-resistance and
inertness probes, existing-v1 verification, and deterministic corpus
regeneration are green.

No canonical-octet, normalized abstract-datum/equality, accepted-document, wire
grammar, datum-family, format-version, or v1 change was observed. Archive
reproduction and publication/read-back are reported in their later receipts.
Nothing in this transcript claims a merge to `main`.
