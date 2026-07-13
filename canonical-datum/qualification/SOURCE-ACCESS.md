# CD/0 qualification source-access record

> Historical pre-Errata-0.1 source-access record. Later ruling, errata, and
> promoted-vector access is recorded by the successor implementation ledger.

This record covers the Phase-4 qualification work based at
`fac17dd701c59f6da8eb2536dd022853b2e258fe`.  Both independent seed commits and
their first complete local conformance runs existed before this work began, so
cross-language inspection was permitted by the isolation protocol.

## Inspected normative and review material

- `mneme/spec/CANONICAL-DATUM-SPEC.md`: Sections 14--21, 23, 28, and 29 for
  record order, grammar, exact encoder/decoder behavior, immutability,
  concurrency, typed failures, resources, hostile input, corpus boundaries, and
  cross-implementation properties.  The harness mechanically hashes the whole
  file and requires
  `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`.
- `CANONICAL-DATUM-DIVERGENCES.md`: A1--A9 and their Phase-2 disposition.
- `canonical-datum/vectors/cd0-budgets.json`: resolved default budget shape.
- `canonical-datum/vectors/cd0-negative.jsonl`: reviewed failure spelling and
  provisional-row metadata; not copied or edited.
- `canonical-datum/integration/cases/cd0-integration-regressions.json`: retained
  regression operations, host-qualified outcomes, and warranted fields.
- `canonical-datum/evidence/INTEGRATION-CONVERGENCE-VERIFICATION.md`: Phase-2
  bounded result and known non-results.

## Inspected public surfaces and harnesses

- `canonical-datum/python/README.md`
- `canonical-datum/python/cd0/__init__.py`
- `canonical-datum/python/tests/test_cd0.py`
- `canonical-datum/common-lisp/README.md`
- `canonical-datum/common-lisp/package.lisp`
- `canonical-datum/common-lisp/cd0.lisp`
- `canonical-datum/common-lisp/tests.lisp`
- `canonical-datum/common-lisp/run-tests.lisp`
- `canonical-datum/integration/README.md`
- `canonical-datum/integration/run_differential.py`
- `canonical-datum/integration/python_adapter.py`
- `canonical-datum/integration/common_lisp_adapter.lisp`

Inspection of codec sources was limited to understanding and exercising the
already-public operations and defensive views.  No codec source, shared vector,
generator path, divergence entry, or normative specification file was edited by
this qualification work.

## Deliberately not inspected or used

- existing v1 kernel semantics or representations;
- `mneme-canon/0` as an oracle;
- any Phase-3 generated release corpus (none is required by this branch);
- Common Lisp printer output or Python host equality as datum-identity oracles;
- remote branches or external sources.

The qualification harness itself adds files only below
`canonical-datum/qualification/`.
