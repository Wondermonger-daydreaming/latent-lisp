# Python CD/0 Errata 0.1 verification

Date: 2026-07-13 (America/Sao_Paulo)

This is a bounded branch-specific verification record for the successor Python
codec. It does not claim a merge, remote publication, or universal proof of
conformance. Cross-language and release-corpus evidence belongs to the
successor integration packet.

## Provenance

- audited Python tip: `29d0946ad78347015b9f0c65a2f528f039fdca78`
- immutable independence anchor (seed commit):
  `58ecca4083275ebfe16605765e575bfb9f6eb755`
- test-first checkpoint: `c04d856499f1d7fed4cc67c56067d77e3122f566`
- Python implementation commit:
  `679ef811c1cbb5b573f5517f43bd4a5e0a52a129`
- implementation tree: `90d1b0079fc38ee39003b36bae0ac9cda3ae1146`
- runtime: CPython 3.11.14, Git 2.43.0, Linux
  6.18.33.2-microsoft-standard-WSL2 x86_64

Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.

The corrected branch tip is not substituted for the seed commit as the
independence anchor.

## Normative input pins

| Artifact | SHA-256 |
|---|---|
| `CD0-POST-IMPLEMENTATION-RULING.md` | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |
| `CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| `mneme/spec/CANONICAL-DATUM-SPEC.md` | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |

The ruling and errata copies in this successor branch were compared
byte-for-byte with the pinned integration copies.

## Test-first evidence

Before the semantic patch, the promoted fixture verifier was green and the
complete Python run executed 156 tests with 5 assertion failures and 3 errors.
The failures were the five A1 count-promised EOF stages; the three errors were
the intentionally missing A7 construction adapter. Observed A1 stages were:

| Witness | Before | After |
|---|---|---|
| sequence promised item | `InvalidCanonicalGrammar/TruncatedInput/type-tag` | `InvalidCanonicalGrammar/TruncatedInput/count` |
| record promised key | `InvalidCanonicalGrammar/TruncatedInput/record-key` | `InvalidCanonicalGrammar/TruncatedInput/count` |
| record promised value | `InvalidCanonicalGrammar/TruncatedInput/type-tag` | `InvalidCanonicalGrammar/TruncatedInput/count` |
| identifier promised segment | `InvalidCanonicalGrammar/TruncatedInput/length` | `InvalidCanonicalGrammar/TruncatedInput/count` |
| rational construction descriptor | adapter absent | normalized datum or typed host-import refusal |

## A1–A9 disposition

| Item | Python codec change | Test/vector result |
|---|---|---|
| A1 | yes: contextual absent-first-octet stage only | all promised item/key/value/segment witnesses report `count`; root and present-tag behavior preserved |
| A2 | no semantic change | four constructor witnesses already and still report `UnsupportedHostInput` plus specific code at `host-import` |
| A3 | no decoder change; A7 adapter checks supplied components pre-reduction | bounded exact-bit property cases and `1024/1024` under one bit behave as ruled |
| A4 | no semantic change | namespace-plus-path aggregate boundary is green |
| A5 | no semantic change | depth over nodes and local over aggregate complete triples are green |
| A6 | no semantic change | `f0` retains `ForbiddenPrivilegedTag`; `03` is `RecordKeyNotIdentifier` |
| A7 | yes: closed construction-descriptor adapter | `2/4`, `2/2`, and `0/7` normalize to the separate abstract fixtures; `1/0` is typed host input failure |
| A8 | no semantic change | two five-octet Identifier ValueBytes occurrences accept at 10 and refuse at 9 |
| A9 | no semantic change | runtime encoding ignores structural admission limits while output and key-work limits remain active |

No encoder grammar, canonical byte rule, datum type, abstract equality rule, or
format version was changed. No file under `mneme/` was changed.

## A2 and A9 before/after witnesses

The audited Python tip and successor produced the same outcomes:

```text
A2-zero-denominator FAILURE UnsupportedHostInput/ZeroDenominator/host-import
A2-empty-segment FAILURE UnsupportedHostInput/EmptyIdentifierSegment/host-import
A2-missing-path FAILURE UnsupportedHostInput/MissingIdentifierPath/host-import
A2-duplicate-field FAILURE UnsupportedHostInput/DuplicateRecordField/host-import
A9-depth-one-runtime-encode OK 4c50434400300100
```

This unchanged observation is evidence that Python was not modified merely to
create a symmetric A2/A9 diff.

## Commands and observed results

```text
python3 canonical-datum/tools/verify_phase0.py
  exit 0
  25 positives (17 worked + 8 additional)
  71 classified negatives = 66 octet + 5 host
  all negative rows have complete normative triples

PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=canonical-datum/python \
  python3 -m unittest discover -s canonical-datum/python/tests -v
  exit 0; Ran 164 tests; OK

PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=canonical-datum/python:canonical-datum/python/tests \
  python3 -m unittest -v test_cd0.ErrataClosureTests \
  test_cd0.ResourceTests test_cd0.GrammarBoundaryTests
  exit 0; Ran 28 tests; OK

PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=canonical-datum/python:canonical-datum/python/tests \
  python3 -m unittest -v test_cd0.HostImportAndInertnessTests \
  test_cd0.HostStackSafetyTests test_cd0.HostImportPreallocationTests \
  test_cd0.ImmutabilityTests
  exit 0; Ran 21 tests; OK

git diff --check
  exit 0; no output
```

Phase-0 accounting is a classification/execution statement, not the phrase
“71 tests passed”: Python executed 71 classified rows, with 0 N/A dispositions,
0 failures, and 0 skips in the recorded run. Common Lisp separately executes
68 and records 3 language-specific N/A dispositions; N/A is neither success nor
failure.

## Residual boundary

This receipt verifies the Python successor at one recorded runtime and the
finite listed tests. Differential, generated-corpus, mutation-candidate,
qualification, v1, archive-reproduction, remote-read-back, and targeted Fable
review evidence are integration-level obligations and are not asserted here.
