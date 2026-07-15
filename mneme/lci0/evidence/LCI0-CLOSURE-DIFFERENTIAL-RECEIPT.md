# LCI/0 Closure Differential Receipt

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)
Branch: `codex/lci0-integration-closure`

## Run identity

- Command (from repo root):
  `PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-integrator-exact-1784087974`
- Environment: `LCI0_FIXTURE_ROOT` = `LCI0_FIXTURE_DIR` =
  `/tmp/lci0-integration-fixtures-1784084025` (base 0.1 materialized by
  `fixture_package.py materialize`; overlay 0.2 materialized by
  `materialize-overlay`; 0.1 members verified: registry SHA-256
  `dd19c6d6…f826327`, vectors `387e7696…bffe3a4`).
- Exit code: 0.
- Curated artifacts committed at
  `mneme/lci0/differential/artifacts/closure-converged-2026-07-15/`
  (`summary.json` SHA-256
  `1d7c58d076fb9c74534e18385ecab4b5d281c88b8be9da044cde000791e3b4cc`).
- Raw run artifacts (referenced by digest; kept at
  `/tmp/lci0-integrator-exact-1784087974/`, too large to commit):
  `requests.jsonl` 24 458 265 B SHA-256
  `b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c`;
  `common-lisp-responses.jsonl` 25 704 560 B
  `d8010accdce9e33d865b19157bdb0defba495371a7708294995060d47db48b25`;
  `python-responses.jsonl` 25 693 085 B
  `4f6299c2e8107702e12024425f07bbd90efce0b35a2345de0d6816fb0b134237`;
  both stderr streams empty (SHA-256 of empty input).

## Result — full convergence

| Field | Value |
|---|---|
| status | `converged-authorial-closures-complete` |
| authorial_return_required | `false` |
| common-lisp mismatches | **0** |
| python mismatches | **0** |
| cross_implementation_mismatches | **0** |
| requests per implementation | 2295 (2266 baseline + 29 hostile); 2295 responses; adapter exits 0/0 |
| per-implementation counts (both identical) | `document 1593/1593 · vector 215/215 · relation 458/458 · hostile 29/29` (all passed; census sum 4590) |
| authorial_blocked_vectors / hostile / relation lists | `[]` / `[]` / `[]` |

Baseline comparison (2026-07-14, pre-closure, same harness family —
`_staging/lci0-closure-reverify/phase2/baseline/`): 50 authorial-blocked
mismatches per implementation (4 vector + 38 relation + 8 hostile), 41
cross-implementation mismatches, status
`converged-unaffected-with-authorial-blockers`. Every one of those 50
surfaces now classifies as `passed`; zero new mismatches appeared anywhere
else (the 1593 documents, 211 previously-exact vectors, 420 determinate
relation rows, and 21 previously-exact hostile requests all still pass).

## Oracle independence

The harness oracle for the 50 closure surfaces derives its expectations from
the fixture overlay 0.2 INDEX (`supersessions` canonical hexes;
`relation_failures` ruled coordinates; `hostile` ruled tuples/values) — never
from executing either implementation. The two overlay entries pinned as
*semantic* documents (P024's inert revival; at-limit-64's within-budget
value) are re-encoded into expected canonical octets by harness-local
document construction; both implementations' independently produced octets
equal that expectation (P024 1 169 octets; at-limit-64 581 octets;
CL == Python == oracle).

## Census flip

`mneme/lci0/differential/authorial_blockers.py`: all blocker sets empty; the
per-implementation count census is all-passed
(215/458/29/1593; the three `*_blocked` keys removed because the harness
Counter omits zero-valued keys; total 4590 unchanged); import-time
assertions updated to the closed state and passing. Convergence gate
(`_fully_converged`) requires 0 mismatches per implementation, the closed
counts, and an empty cross-mismatch list.
