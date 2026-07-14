# LCI/0 Python failure-vocabulary audit

Date: 2026-07-14 America/Sao_Paulo

Scope: follow-up hardening of successor commit
`f8d98549b8e3a3364967d5b0ddd24334081d3cec`; the successor commit was not
amended. The independent Python seed identity remains
`4ec2e519d05aeacd2412cb8aedc5f76bde702571` / tree
`9f7915b460f449976a5d7fa856861ad5ce1d36ca`.

Authority: the checksum-bound frozen registry
`dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327`
contains exactly 84 definitions whose `item_class` is
`lci-failure-code-identifier`.

Observed defect: 32 literal failure codes reachable on malformed or hostile
paths were absent from those 84 registry definitions. The 215 official vector
inputs did not exercise those invented codes: their runtime census contained
101 failure outcomes using 53 authorized codes.

Disposition:

- `LCIFailure` construction now rejects every code outside the exact 84-code
  set with a host-side `FixtureIntegrityError`.
- Unpinned malformed/hostile paths now stop with `FixtureAuthorityGap`.
- Frozen registry/table contradictions now stop with `FixtureIntegrityError`.
- `UnstableReference` was replaced only at the stable-reference type boundary
  by the registered `InvalidStableReference`; no other invented code was
  silently remapped.
- Runner/protocol diagnostics use `protocol_failure`, never the normative
  `failure` member. Policy-C has the closed host-side status
  `fixture-authority-gap` and emits no semantic failure or result.

Verification:

```text
PYTHONPATH=canonical-datum/python:mneme/lci0/python \
  python3 -m unittest discover -s mneme/lci0/python/tests -p 'test_*.py' -v

Ran 84 tests in 67.753s
OK
```

The suite mechanically proves the exact 84-code registry equality, statically
censuses literal constructors and helper call sites, checks constructor
fail-closure, executes all 215 runtime and expected documents, preserves all
211 unaffected exact comparison signatures, and exercises the closed Policy-C
and ordinary authority-gap protocol boundaries.

```text
PYTHONPATH=canonical-datum/python python3 -m unittest discover \
  -s canonical-datum/python/tests -v

Ran 167 tests in 0.200s
OK
```

```text
PYTHONPATH=canonical-datum/python:mneme/lci0/python \
  python3 mneme/lci0/python/tests/blocked_scope_authority_conflict.py

Ran 11 tests in 5.024s
FAILED (failures=11)
```

The last command is the intentional-red authorial blocker suite: it retained
exactly 11 declared failures and produced zero errors. It is not counted as a
pass. No frozen CD/0 source, LCI normative artifact, fixture registry, fixture
vector, or production v1 source was modified by this follow-up.
