# Lisp+ Canonical Datum /0 implementation ledger

Status date: 2026-07-13

This ledger distinguishes normative CD/0 requirements, implementation-local
representation choices, open specification questions, executed evidence, and
unexecuted work. It is not a specification amendment. Until every
`{{CD0_*}}` placeholder in the release section is replaced from retained
evidence, it is also not a completion claim.

Evidence provenance for this draft: the specification, five hand-artifact,
Phase-2-summary, and Phase-4-summary SHA-256 values were directly recomputed in
the documentation worktree at `7a0994f`. Git commit/tree objects were directly
resolved. JSONL line counts (22, 71, and 353/353/353), negative status counts
(59/11/1), input-kind counts (66/5), summary fields, the retained Python
`Ran 152 tests ... OK` line, and the retained Common Lisp `total assertions:
2510` line were directly inspected. Runtime and semantic outcomes such as
17/17 worked-vector reproduction, mutation behavior, inertness hooks, and
concurrency observations were transcribed from committed execution receipts
and transcripts; this documentation-only task did not re-execute those tests.
No result below was inferred from reading one codec and assuming the other.

## Normative and repository boundary

| Item | Recorded value | Standing |
|---|---|---|
| Normative artifact | `mneme/spec/CANONICAL-DATUM-SPEC.md` | sole source of CD/0 semantics |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` | matched before implementation |
| Nested checkout when the task arrived | HEAD `1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48`; tree `69793d6ac432d47a060a215785b536ee7e8fcfd0` | existing `codex/v1-counterexample-closure` checkout; not the CD/0 branch base |
| Fetched CD/0 branch base | `origin/main` HEAD `ae767f00975395369f9a91283a954f0963fb6724`; tree `b8f5be6d532eafe5be0d1f342347fa10f5f39352` | intentional base of all three isolated CD/0 branches |
| Common Lisp host | SBCL 2.4.6 | executed host |
| Python host | CPython 3.11.14 | executed host |

The initial nested checkout and fetched branch base are different facts. The
Phase-0 receipt's “pre-change HEAD” is the fetched `origin/main` base used in
the isolated worktrees; it does not rewrite the state of the nested checkout
that existed when the request arrived.

The normative specification was not edited. Datum semantics were not taken
from the v1 kernel, `mneme-canon/0`, Common Lisp packages or symbols, SBCL
printing, Python equality, or claim-, warrant-, receipt-, certificate-, or
capability-shaped runtime representations.

## Isolation and checkpoint history

| Checkpoint | Original or integrated commit | Tree or disposition |
|---|---|---|
| Phase-0 fixtures | `520034e9dd60dc1ea92cbd5d2e9d7a4f289d2a26` | tree `a7771f21b58f8dbdf01b2b023900e750be94b62c` |
| Phase-0 correction | integrated `9e2b74b9eb2a9609be47f298418a7a9858aad019` | reviewed 22-positive/71-negative fixture state |
| Equality-class correction | integrated `7e7d8aec83c3bf85e801f0b6842d90b9185d1949` | inverse canonical-bytes/equality-class check added |
| Common Lisp independent seed | `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3` | original clean-room seed; tree `ee168b0ec3f5fb0b6501e773e318974d014cd9df` |
| Python independent seed | original `58ecca4083275ebfe16605765e575bfb9f6eb755` | original tree `331e8c83d683523381301a51de680f71b758026b`; integrated as `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` |
| Python hardening | original `db964524ded723f0841188a322b13ac9896c67d6` | integrated as `f0cc62272ed076513d7f533fca25548d73f0d342` |
| Common Lisp hardening | original `776385ef13865b78a803004d67f9d3661045fc61` | integrated as `bad5293e2accf337868e6b4df96bea6b65569b43` |
| First differential convergence | `fac17dd701c59f6da8eb2536dd022853b2e258fe` | tree `51ced24e2a3f1387ec9d110aa65f54c5bad65edd` |
| Initial generator source | `e5f89edb59f6be34fde4b7dd6165cb5167dc0453` | source-only checkpoint; no release corpus claimed by its receipt |
| Bounded Phase-4 qualification | `7a0994f1ea176db1bffa61564dd23957a8c6216a` | tree `fb526ef66570d0dc4f70324076bbeb23d41b6c3f` |
| Corrected generator source | `{{CD0_GENERATOR_CORRECTION_COMMIT}}` | release gate; fill only from committed history |
| Release differential runner source | `{{CD0_RELEASE_RUNNER_SOURCE_COMMIT}}` | fill only from committed history |
| Verified release checkpoint | `{{CD0_VERIFIED_CHECKPOINT_COMMIT}}` | tree `{{CD0_VERIFIED_CHECKPOINT_TREE}}` |

The Common Lisp implementer did not inspect Python codec source before its
first complete conformance run and commit. The Python implementer did not
inspect Common Lisp codec source before its first complete conformance run and
commit. Exact inspected-file lists are retained in the two seed source-access
logs. Cross-reading began only in integration, after both seed commits existed.
This is procedural isolation with enumerated evidence, not an OS-level
information-flow proof.

## Normative requirements implemented

| Requirement | Common Lisp surface | Python surface | Executed evidence | Status and residual boundary |
|---|---|---|---|---|
| Construct all nine disjoint datum families | private datum classes and explicit `make-*` constructors | frozen family classes and explicit constructors | positive vectors, equality classes, distinct pairs, generated seed properties | implemented; finite testing is not a proof of all host inputs |
| Preserve type disjointness | family-dispatched nodes; no implicit universal meaning for `NIL`; no implicit symbol-to-identifier conversion | explicit Boolean versus Integer classes; `bool` rejected as integer host input | shared host rows and seed-local disjointness tests | implemented for supported APIs |
| Abstract `equal-datum` | iterative structural worklist | iterative structural worklist | complete 253-pair hand relation; deep equal/unequal probes; equality iff bytes properties | implemented; real heap exhaustion remains possible |
| Exact canonical encoding | `encode-exact` | `encode_exact` | all 17 worked vectors, 22 shared positives, round trips, record order, Unicode, large integer/rational cases | implemented for the pinned grammar |
| Exact full-input decoding | `decode-exact` | `decode_exact` | worked and hostile vectors, trailing-byte refusal, strict UTF-8, noncanonical refusal | implemented for the pinned grammar |
| Immutable observations and mutation resistance | private copied storage, defensive accessors, read-only octet wrapper | immutable leaves/tuples/frozen nodes, copied mutable inputs | 15 CL seed mutation probes plus 11 Phase-4 CL probes; 11 Python seed mutation/inertness tests plus seven Phase-4 probes | supported-API immutability satisfied; unsafe reflection/native memory is outside the claim |
| Explicit immutable resource budgets | immutable fourteen-field `resource-budget` | frozen `ResourceBudget` | shared tight/sufficient cases, local boundary tests, hostile preflight and retry probes | implemented; A3, A4, A5, A8, and A9 retain local choices |
| Typed failures | `cd0-failure` category/code/stage | `CD0Failure` category/code/stage | all warranted fields in 71 hand dispositions and qualification failures | implemented; provisional fields are not promoted to normative law |
| Fixture AST conversion | `datum-from-fixture-ast`, `datum-to-fixture-ast` | `from_fixture_ast`, `to_fixture_ast` | all positives, canonical export, mutation and host-preflight tests | implemented; unreduced rational construction AST remains blocked by A7 |
| Optional diagnostic rendering separated from identity | diagnostic renderer outside encoder/equality | diagnostic renderer outside encoder/equality | ambient-state and large-number probes | implemented; diagnostic text is never compared as identity |
| Strict identifier and record rules | explicit strings and identifier nodes; bytewise canonical key order and duplicate checks | explicit strings and identifier nodes; bytewise canonical key order and duplicate checks | namespace distinctions, record permutations, duplicate/order hostile rows | implemented; A4/A6/A8 local choices remain visible |
| Inert privileged-looking records | parser constructs only datum nodes; no evaluator, reader, package, registry, or I/O transition | parser constructs only datum nodes; no evaluator, pickle, socket, or I/O transition | guarded selected entry points with zero observed calls | strongly instrumented finite evidence; not proof against every FFI/syscall |
| Ambient-host-state invariance | package/printer/readtable perturbations; 1,024 concurrent read/encode pairs | hash seeds 0/1/137/777, decimal guard 640, dictionary order; 128 concurrent encodes in seed tests | retained Phase-4 transcripts | satisfied on SBCL 2.4.6 and CPython 3.11.14 only |
| Existing v1 behavior untouched | CD/0 code is under `canonical-datum/**` | same | changed-path audit from fetched base; final behavioral gate retained separately | no v1 source changed; final post-release v1 rerun is `{{CD0_FINAL_V1_RESULT}}` |

## Implementation-local representation choices

These choices are engineering representations or explicitly non-normative
answers at an open boundary. They do not change abstract CD/0 identity.

- Common Lisp stores immutable datum internals in private classes and vectors;
  accessors return scalars, datum references, or defensive copies. `NIL` has
  meaning only where an explicit API parameter says Boolean false or an empty
  host collection; it is not a universal datum coercion.
- Python uses frozen family values, `str`, `bytes`, and tuples. Mutable buffers
  and collections are copied. Python `bool` is explicitly refused where an
  Integer is required despite its host-language subclass relation to `int`.
- Neither implementation turns a host symbol into an Identifier without an
  explicit fixture/host mapping.
- Both adapters use JSON Lines as an integration transport. The transport and
  its data-only parsers are test infrastructure, not part of canonical identity.
- Runtime encoding budget policy differs at A9: Common Lisp applies structural
  non-input limits to already-valid datums; Python applies output and record-key
  work limits there and applies structural limits during decode/import. This
  difference is recorded, not reconciled by imitation.
- Constructor/import failure triples at A2, integer-bit counting at A3,
  identifier-segment aggregation at A4, simultaneous-refusal precedence at A5,
  record-key tag precedence at A6, rational fixture construction at A7, and
  record-key work accounting at A8 remain the documented local policies in the
  language READMEs.

## Specification ambiguities and provisional failures

`CANONICAL-DATUM-DIVERGENCES.md` is append-only and authoritative for the
minimal witnesses and proposed non-normative adjudications. No entry is closed
by cross-implementation agreement.

| Entry | Open question | Current testing treatment |
|---|---|---|
| A1 | complete mapping of normative failure stages | eleven hand rows and three Phase-4 rows compare only category/code where stage is unwarranted |
| A2 | constructor/import failures lack complete normative triples | `cd0-neg-host-bool-as-integer` compares category/stage; its proposed code remains provisional |
| A3 | exact meaning of `max_integer_bits` | implementation-local bit-count rules are recorded; no normative threshold is inferred |
| A4 | identifier segment budget aggregate versus per side | local aggregate choice only |
| A5 | precedence for simultaneous resource breaches | corpus avoids permanently labelling unresolved multi-defect precedence |
| A6 | record-key-not-Identifier versus nested tag failure precedence | local gate order only |
| A7 | no fixture AST form for unreduced rational construction | fixture `rat` is normalized abstract value only; constructor normalization tested directly |
| A8 | exact record-key work-octet accounting | local complete-`ValueBytes`-once policy only |
| A9 | encoder use of non-output budgets | different CL/Python policies are retained and excluded from false convergence claims |

The compact hand corpus has 71 negative rows: 59 with a normative complete
triple, 11 `provisional-blocked-stage` rows, and one
`provisional-blocked-code` row. The Common Lisp API does not expose three
language-specific optional host importers, so these rows are N/A—not passes:

- `cd0-neg-host-ambiguous-identifier`;
- `cd0-neg-host-bool-as-integer`;
- `cd0-neg-host-privileged-value`.

Common Lisp executes 66 octet rows and two applicable generic-sequence host
rows, for 68 executed dispositions. Python executes all 71 rows.

## Executed evidence through the pre-release checkpoint

| Evidence set | Observed result | Retained boundary |
|---|---|---|
| Phase-0 mechanical review | 17/17 worked vectors; five additional positives; 71 negatives; 256/256 tag octets classified; five distinct pairs | finite hand-authored corpus; A1–A9 preserved |
| Hand artifacts | positive SHA-256 `f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce`; negative `6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5`; schema `4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13` | exact reviewed bytes |
| Common Lisp seed/hardening | 22 positives; 71 dispositions; 12 resource retries; 15 seed mutation probes; 11 local resource probes; 500 deterministic round trips; 2,510 assertions after hardening | SBCL 2.4.6 only |
| Python seed/hardening | 22 positives; 71 negatives; 59 local tests; 152 tests after hardening | CPython 3.11.14 only |
| Phase-2 process differential | 353 requests per codec: 22 positives, 71 dispositions, complete 253-pair equality matrix, seven retained regressions; zero warranted disagreement; empty stderr | three CL host N/A; 11 A1 stages and one A2 code remain provisional |
| Phase-2 summary | SHA-256 `69b0b9025db187074ebcca4252bd2b02c5072211ff3a8fe0d63b39c65914f6b0` | retained JSON plus exact request/response JSONL |
| Phase-4 default qualification | PASS; 353 golden requests, 512 randomized round trips, 513 equality/encoding properties, 14 classified hostile/resource failures, six retries, zero warranted disagreement | deliberately did not consume Phase-3 release corpus |
| Phase-4 runtime probes | Python hash/digit/dictionary perturbations; seven Python and eleven CL mutation probes; selected inertness guards; 1,024 CL concurrent observations | finite host/runtime instrumentation |
| Phase-4 summary | SHA-256 `88ed013ef71690b174627730c0c85ea51d5a28b61181bdeef08bfdd2d09a0a57` | retained `default-run` evidence |

The seven Phase-2 regressions are permanently classified. Their original or
compact generated witnesses are retained. “Minimized” does not mean every
stress threshold is a global byte minimum: the 5,000-digit bounded-preflight
case is deliberately a resource stressor, while the 641-digit ambient guard
case is minimized to CPython's smallest nonzero guard boundary.

## Release corpus and final verification — pending evidence fields

This section must be completed from retained artifacts, never from memory or a
green terminal line alone.

| Field | Required retained value |
|---|---|
| Generator correction commit | `{{CD0_GENERATOR_CORRECTION_COMMIT}}` |
| Release runner source commit | `{{CD0_RELEASE_RUNNER_SOURCE_COMMIT}}` |
| Generator source revision named by manifest | `{{CD0_RELEASE_SOURCE_REVISION}}` |
| Deterministic generator seed | `{{CD0_RELEASE_SEED}}` |
| Exact generator command | `{{CD0_RELEASE_COMMAND}}` |
| Positive count | `{{CD0_RELEASE_POSITIVE_COUNT}}` (must be at least 10,000) |
| Classified negative/adversarial count | `{{CD0_RELEASE_NEGATIVE_COUNT}}` (must be at least 20,000) |
| Unlabelled mutation-candidate count | `{{CD0_RELEASE_MUTATION_COUNT}}` |
| Corpus digest | `{{CD0_RELEASE_CORPUS_SHA256}}` |
| Manifest SHA-256 | `{{CD0_RELEASE_MANIFEST_SHA256}}` |
| Corpus commit/tree | `{{CD0_RELEASE_CORPUS_COMMIT}}` / `{{CD0_RELEASE_CORPUS_TREE}}` |
| Determinism rerun result | `{{CD0_RELEASE_DETERMINISM_RESULT}}` |
| Release differential commit | `{{CD0_RELEASE_DIFFERENTIAL_COMMIT}}` |
| Requests handled per codec | CL `{{CD0_RELEASE_REQUESTS_CL}}`; Python `{{CD0_RELEASE_REQUESTS_PY}}` |
| Warranted cross-codec disagreements | `{{CD0_RELEASE_WARRANTED_DISAGREEMENTS}}` |
| Provisional/N/A observations | `{{CD0_RELEASE_PROVISIONAL_OBSERVATIONS}}` |
| Release differential result/summary SHA-256 | `{{CD0_RELEASE_DIFFERENTIAL_RESULT}}` / `{{CD0_RELEASE_DIFFERENTIAL_SUMMARY_SHA256}}` |
| Final qualification result/summary SHA-256 | `{{CD0_FINAL_QUALIFICATION_RESULT}}` / `{{CD0_FINAL_QUALIFICATION_SUMMARY_SHA256}}` |
| Final v1 gate/result transcript SHA-256 | `{{CD0_FINAL_V1_RESULT}}` / `{{CD0_FINAL_V1_TRANSCRIPT_SHA256}}` |
| Final changed-path audit | `{{CD0_FINAL_CHANGED_PATH_AUDIT}}` |
| Verified checkpoint commit/tree | `{{CD0_VERIFIED_CHECKPOINT_COMMIT}}` / `{{CD0_VERIFIED_CHECKPOINT_TREE}}` |
| Reproducible archive path/SHA-256 | `{{CD0_ARCHIVE_PATH}}` / `{{CD0_ARCHIVE_SHA256}}` |

Random multi-defect mutation bytes must remain unlabelled until minimized to a
primary defect. Input-budget-derived rows may carry their precise resource
triple only when the retained derivation proves that primary defect and the
sufficient-budget retry reproduces the canonical bytes. Provisional A1/A2 fields
remain provisional even if both codecs happen to emit the same value.

## Deviations or blocked requirements

- A1–A9 require specification adjudication; proposed resolutions in the
  divergence ledger are explicitly non-normative.
- The three Common Lisp language-specific host rows are N/A because the optional
  generic importers are outside that seed's exposed API. This is visible missing
  surface, not a pass.
- Release-scale completion is blocked until every placeholder above is replaced
  by committed corpus, runner, transcript, and hash evidence.
- No known normative disagreement is being hidden at this checkpoint. That
  statement is bounded to the hand corpus and default qualification already run.

## Tests not executed or claims not made

- No Common Lisp implementation other than SBCL 2.4.6 was available or run.
- No Python implementation/version other than CPython 3.11.14 was run.
- Portability to CCL, ECL, CLISP, ABCL, Roswell, PyPy, other operating systems,
  or other Unicode/runtime libraries is unexecuted.
- No exhaustive proof over all byte strings, host graphs, allocator failures,
  thread schedules, FFI/syscalls, or hostile same-process reflection is claimed.
- Actual forced heap exhaustion and concurrent mutation of a caller-owned host
  source during import were not injected.
- Canonicalization is not truth, authority, authenticity, custody, verified
  lineage, cryptographic integrity, or semantic validity of record contents.
- v1 migration, claim identity, as-of targeting, warrant/capability semantics,
  receipt transitions, Language A, cryptographic hash/signature choices, and
  module/procedure identity remain outside this task.

## Host and runtime limitations

Common Lisp qualification is SBCL-specific. The ASDF suite needed its generated
cache redirected to `/tmp` because the sandboxed default cache was read-only;
this occurred before tests and changed no source semantics. Python hardening
turns host recursion pressure into a typed allocation refusal, but a semantically
permitted deeply nested value can still be refused by finite host resources.
Both implementations can encounter genuine allocation failure despite bounded
preflight. Diagnostic and host exception text are not part of conformance.

## Remote and enclosing-commit record

The authorized remote is `origin`, URL
`https://github.com/Wondermonger-daydreaming/latent-lisp.git`. Final remote refs
and push result are evidence fields, not assumptions:

- Common Lisp branch: `{{CD0_COMMON_LISP_FINAL_COMMIT}}` at
  `{{CD0_COMMON_LISP_REMOTE_REF}}`;
- Python branch: `{{CD0_PYTHON_FINAL_COMMIT}}` at
  `{{CD0_PYTHON_REMOTE_REF}}`;
- integration verified checkpoint: `{{CD0_VERIFIED_CHECKPOINT_COMMIT}}`;
- integration remote ref: `{{CD0_INTEGRATION_REMOTE_REF}}`;
- push result: `{{CD0_PUSH_RESULT}}`.

The hash of a commit that contains this ledger cannot be embedded in the same
ledger without changing that commit. Report the enclosing documentation commit
and the final archive-envelope branch tip in the external handoff or a later,
non-self-referential envelope.
