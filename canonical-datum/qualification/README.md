# CD/0 Phase-4 bounded qualification

This directory qualifies the already-integrated Common Lisp and Python CD/0
codecs without defining datum semantics or changing either codec.  The harness
uses the public codec APIs and existing process adapters, checks the pinned
specification digest before launching a codec, and records the boundary of every
claim it makes.

It deliberately does **not** read, generate, or claim the Phase-3 release
corpus.  Its deterministic pseudo-random values are ephemeral property probes,
not normative vectors and not a substitute for the required 10,000 positive and
20,000 negative/adversarial release corpus.

## Commands

From the repository root, the fast bounded run is:

```text
python3 canonical-datum/qualification/run_qualification.py --mode small
```

The default qualification additionally runs both complete seed suites and uses
the larger deterministic property sample:

```text
python3 canonical-datum/qualification/run_qualification.py --mode default
```

Retain machine-readable evidence with:

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir canonical-datum/qualification/evidence/default-run
```

`--json` prints the bounded summary.  All modes run the specification digest
gate, the Phase-0 verifier, the 353-request Phase-2 golden differential, harness
self-tests, separate-process property probes, and language-specific runtime
probes.  Small mode uses 48 values; default uses 512.

## Evidence obligations

| ID | Obligation | Harness evidence | Boundary |
|---|---|---|---|
| Q1 | Pin the normative revision and rerun deterministic goldens | exact SHA-256 gate, Phase-0 verifier, 22 positive / 71 negative / 253 equality / seven regression differential | finite reviewed hand corpus only |
| Q2 | Round trip, equality/encoding equivalence, and canonical-byte identity | 48 or 512 deterministic generated values through both adapters; an equal-source variant per value | ephemeral bounded sample, not the release corpus |
| Q3 | Refuse noncanonical and forbidden encodings with classified failures | eight single-defect mutation cases per codec | precise triples only where normative |
| Q4 | Resist mutable source, accessor, and decoder-input aliases | seven Python and eleven Common Lisp runtime mutation probes, plus full seed suites in default mode | ordinary supported API mutation, not reflection/unsafe memory writes |
| Q5 | Ignore ambient host state | Python processes under multiple hash seeds, 640-digit guard, and dictionary-order variants; Common Lisp package/printer/readtable perturbation | qualified CPython/SBCL versions only |
| Q6 | Enforce resource thresholds and allow sufficient-budget retry | six tight/sufficient request pairs per codec, including a depth-96 semantic threshold | A1-provisional depth/node stages are not asserted as normative |
| Q7 | Keep privileged-looking records inert | Python guards `eval`, `open`, pickle, and socket; Common Lisp guards eight reader/evaluator/interning/file entry points plus a hostile readtable | observable selected hooks; not a proof over unexposed FFI/syscalls |
| Q8 | Distinguish host cycles from sharing and preserve identifier namespaces | direct host probes in both runtimes plus cross-codec namespace inequality | finite shapes and explicit importers |
| Q9 | Compare in isolated processes and classify disagreements | both adapters receive identical JSONL; every hostile case has a primary classification and warranted-field set | host exception text is never compared |
| Q10 | Preserve immutable observations under concurrency | Common Lisp threads perform 1,024 read/encode pairs in default mode; Python full seed suite performs its existing concurrent read/encode test | thread schedules are sampled, not exhaustively explored |
| Q11 | Keep unresolved specification fields visible | A1-provisional rows compare category/code only; A1--A9 remain open; three Common Lisp-specific host rows remain explicit N/A | N/A and provisional are never counted as normative passes |

## Warranted versus provisional failures

The qualification manifest contains eight mutation-derived and three
unambiguous resource failures for which category, code, and stage are compared.
Depth, node, and deep-depth resource probes are affected by divergence A1, so
only their normative category and code are compared.  Their observed stages are
retained in the summary as provisional observations and are not promoted by
agreement.

The harness does not add expected constructor triples (A2), choose an integer
bit-count rule (A3), decide aggregate/per-side identifier limits (A4), settle
multi-defect precedence (A5), choose record-key tag precedence (A6), add a
rational-construction AST (A7), settle key-work accounting (A8), or unify encoder
budget surfaces (A9).  The root divergence ledger remains authoritative.

## Host descriptor dispositions

The Common Lisp adapter has no declared implementation of three
language-specific optional importers:

- `cd0-neg-host-ambiguous-identifier`;
- `cd0-neg-host-bool-as-integer`;
- `cd0-neg-host-privileged-value`.

The golden runner and this harness report those as **not applicable**, not as
passes.  The two generic sequence host rows are executed in Common Lisp; all
five host rows are executed in Python.

## Artifacts and non-results

An artifact run writes a stable summary plus exact stdout/stderr for every child
process under the selected destination.  The summary includes command exit
status and content hashes, but elapsed time and temporary paths are excluded
from the conformance claim.

Only SBCL and CPython are driven here.  A passing run does not adjudicate A1--A9,
does not establish truth or authority for record contents, does not prove the
absence of every possible host side effect, does not qualify another runtime
version, and does not replace the Phase-3 release corpus.
