# LCI/0 post-convergence evidence harness

`post_convergence.py` is a fixture-only phase that runs after the exhaustive
1,593-document, 215-vector, and 458-relation differential. It does not define
new LCI semantics and neither implementation supplies its oracle.

## Gate

Before creating its output directory, the program verifies the exact six-file
successor artifact census and checksum manifest, mechanically rebuilds all
2,287 requests, strictly reparses both 2,287-line response streams, recomputes
the differential comparison, and requires the summary to equal that replay.
It refuses to run unless:

- both implementations have exactly the four disclosed vector-result blockers,
  eight disclosed hostile-result blockers, and 38 disclosed relation-path
  blockers (420 complete relation rows and 38 blocked rows, never 458 passed
  rows):
  `vector:LCI0-N012`, `vector:LCI0-E5-COVERAGE-INSUFFICIENT`, and
  `vector:LCI0-P024` and `vector:LCI0-P029`, with no other fixture mismatch;
- every cross-implementation mismatch is either one of the 38 enumerated
  `LCI0-DIV-014` companion failure paths differing only in `failure.path`, or
  one of the closed hostile blocker fields whose complete tuple/result document
  is absent from the frozen package;
- the summary declares all 38 paths in the closed top-level
  `authorial_blocked_relation_paths` census, even when the implementations
  independently choose the same unpinned path and therefore have no cross
  mismatch; and
- the official and supplementary corpus/request counts, the mechanically
  derived 52-operation census, and both immutable seed identities are exact.

The 50 exact-run gate observations remain authorially blocked. The property
phase separately records 104 missing/unknown payload cases whose unpinned
failure coordinates remain blocked. The harness never counts either census as
pass, skipped, or N/A. The eight hostile blockers retain the frozen part of
their outcome: required rejection or acceptance, pinned tuple coordinates, and
canonical well-formedness. They comprise six incomplete failure-tuple requests,
one unpinned within-budget success envelope, and Policy-C's non-LCI fixture
authority gap.

## Deterministic phase

Default seed: `1279478064` (`0x4c434930`).

Default allocation/mutation iterations: `64`.

The default generator emits 329 cases covering independent record allocation
and insertion order, fresh four-field ClaimId projection, identity-coordinate
changes, occurrence metadata neutrality, NFC/NFD distinctions, rational and
segmented-Identifier boundaries, all eleven target schemas, E6 failure order,
bounded legacy grammar and inertness, explicit migration-source provenance
propagation at the top-level result plus ClaimId neutrality (with lineage-source
semantics still authorial-return-bound), closed missing/unknown payloads for all 52 operation families,
semantic-dispatch validation, Policy-B limited meta-testimony, two reversed
anti-shortcut witnesses, and the inclusive/over limit boundary for all
thirteen resources. Both adapters
receive the same canonical requests and are compared symmetrically.
Metamorphic expectations come from the frozen fixtures and specification
rules. Novel operation-payload failure tuple coverage remains explicitly
authorial-return-bound even though fail-closed behavior is tested.

## Host phase

Six adapter processes cover two Common Lisp ambient profiles and four Python
hash-seed/locale profiles. Native probes additionally cover:

- Python: independently allocated values, mutated source buffers, four hash
  seed/locale processes, patched wall clocks, and post-setup denial of file,
  pathlib, socket, connection, and name-resolution entry points;
- Common Lisp: separate baseline, package, printer, readtable, hash insertion,
  and unavailable-I/O/clock processes; the final profile replaces `OPEN`,
  `PROBE-FILE`, `TRUENAME`, and `GET-UNIVERSAL-TIME` with signalling functions
  during fresh projection under `unwind-protect`; and
- the existing language-native perturbation/surface and Common Lisp unit
  suites.

Common Lisp has no standard network API and this implementation loads no socket
system. Its network boundary is therefore procedural, not OS-enforced; that
limitation is recorded in `summary.json`. Python denial is executable and has
eight self-checking calls that must raise before projection is attempted.

## Invocation

From the integration worktree root:

```sh
PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python \
python3 mneme/lci0/differential/post_convergence.py \
  --successor-artifacts /absolute/path/to/successor-artifact-directory \
  --output /absolute/path/to/new/evidence-directory
```

The independently seeded Common Lisp registry freezes the extracted fixture
path `/tmp/lci0-seed-fixtures-20260714`. Prepare that path from the tracked
archive before invocation. The harness sets both language environment markers
to the same path, checks the registry and vector hashes before creating its
output directory, and records their bytes/hashes in the final summary.

The output directory must not already exist.

## Evidence products

The output contains:

- `cases.json` with the closed case census, expectations, byte counts, and
  input SHA-256 values;
- `requests.jsonl`;
- one raw `*.responses.jsonl` and stderr file per adapter process;
- raw stdout/stderr for every native probe, suite, and runtime query;
- `command-transcript.jsonl` with exact argv, cwd, selected environment,
  exit code, and stdin/stdout/stderr byte counts and hashes;
- `summary.json` with the gate receipt, exact seeds/counts, comparison result,
  runtime versions, host profiles, and limitations; and
- a recursive `sha256-manifest.json` that excludes only itself.

`test_post_convergence.py` checks gate fail-closure, the exact blocker census,
deterministic generation, fresh projection shape, Identifier distinction, both
native denial probes, and recursive manifest construction.
