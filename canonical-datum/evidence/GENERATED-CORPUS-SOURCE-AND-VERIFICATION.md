# CD/0 generated-corpus source access and verification

Date: 2026-07-13 (America/Sao_Paulo)

## Scope and provenance

This note covers only the Phase 3 deterministic corpus generator source, tests,
and documentation.  It does not claim that the 10,000/20,000 release corpus has
already been generated, differentially checked, or committed.  The generator
must be committed first so a later release manifest can name the source revision
that actually contains it.

The worktree branch began at integration seed commit
`9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad`.  Before implementation, the
normative file was located at `mneme/spec/CANONICAL-DATUM-SPEC.md` and verified
as SHA-256
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.

Source files inspected for this generator:

- the complete pinned `CANONICAL-DATUM-SPEC.md`, especially Sections 15,
  20--21, and 27--29;
- `CANONICAL-DATUM-DIVERGENCES.md` (A1--A9);
- shared fixture schema, positive/negative hand vectors, distinct-pair and
  budget manifests;
- the Phase 0 fixture verifier;
- the already-committed post-seed Python codec, README, and tests.

The Common Lisp codec source was not inspected for generator implementation.
No codec, integration-runner, normative-specification, legacy-v1, or divergence
ledger file was edited.  Reusing the Python codec is a post-seed representation
choice: it supplies the agreed fixture adapter and a consistency check, not an
independent oracle and not an amendment to the specification.

## Proof-carrying-change receipt

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| G1 | Refuse before output unless the normative spec digest is exact | `generate_corpus.py` | digest pin test plus release-floor/no-output test | satisfied | finite test cannot model filesystem failure after writes begin |
| G2 | Record generator/runtime version, deterministic seed, exact command, source revision, counts, artifact hashes, and corpus hash | generator and README | manifest assertions and independent test-side hash recomputation | satisfied | manifest self-hash must be supplied by the later external ledger |
| G3 | Default release floor is at least 10,000 unique positives and 20,000 unique classified negative input/budget pairs | generator and tests | lower-count refusal; small-corpus uniqueness and schema tests | satisfied for enforcement; release execution pending | final bulk counts and hashes do not exist until the source commit is imported and run |
| G4 | Cover every Section 28.3 family, wire-tag class, boundary family, record/Unicode/resource/inertness case | generator coverage ledger and host scenarios | 33 nonempty coverage entries; all 256 wire tags checked in small run | satisfied within generated matrix | cross-codec conformance of the final bulk rows remains pending |
| G5 | Generate Section 28.4 mutations; keep multi-defect candidates unlabelled; include all hand and configured-size truncations | mutation artifact builder and tests | exact set comparison for hand/configured truncations; required operations; absence of `expected_failure` | satisfied | candidates still require differential minimization before promotion |
| G6 | Make host cycles, improper lists, sharing, mutable aliases, symbols/bool, namespaces, and inert privileged-looking records explicit | host/property scenario artifact | scenario-ID and shape assertions | satisfied as metadata | runtime probes are a Phase 4 obligation, not evidence supplied here |
| G7 | Deterministic output independent of Python hash seed | canonical JSON writers and ordered generation | every emitted byte compared under hash seeds 1 and 777 | satisfied for tested CPython/runtime | other Python versions remain unexecuted |
| G8 | Preserve A1--A9 and do not make the Python seed normative | separate mutation artifact, provisional A2 row, manifest/docs boundary | tests assert no mutation triples and explicit oracle/divergence text | satisfied | specification adjudication remains external |
| I1 | Do not edit codecs, integration code, the spec, v1, or the divergence ledger | worktree diff | path audit before commit | satisfied | later cherry-picks must retain this boundary |

## Commands and observed results

Environment used for this source verification:

- CPython 3.11.14;
- base/source revision `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` before this commit;
- specification digest as recorded above.

Commands:

```text
python3 -m py_compile canonical-datum/generator/generate_corpus.py
```

Exit 0.

```text
python3 -m unittest discover -s canonical-datum/generator/tests -v
```

Exit 0: 15 tests ran; all passed.  The suite performed two complete 384-positive,
640-negative small generations under `PYTHONHASHSEED=1` and `777`, byte-compared
all six outputs, schema-validated all 1,024 shared fixture rows, independently
recomputed artifact/corpus hashes, and checked all hand/configured truncations.

No 10,000/20,000 release corpus was generated in this source-first commit.  No
additional Common Lisp implementation or final cross-process differential run
is evidenced by this note.
