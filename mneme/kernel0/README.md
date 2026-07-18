# Kernel /0 pure core — first implementation arc

Arc identity: **Kernel /0 pure core, first implementation arc, 2026-07-18**.

This directory implements the pure Common Lisp data algebra, typed refusals,
immutable semantic records, and deterministic in-memory folds governed by
[`LISP-PLUS-KERNEL-0-SPEC.md`](../architecture/LISP-PLUS-KERNEL-0-SPEC.md).
The runtime target is SBCL 2.4.6 under `sbcl --script`.

This is not a claim of complete Kernel /0 conformance. It is the pure-core
subset that can be exercised without inventing the successor journal, adapter,
live-capability, channel-policy, or publication protocols.

## What this arc adds

- `fixtures.lisp` constructs the lawful §22 call-296 fixture and the
  pure-constructible §23 shapes.
- `kernel0-selftest.lisp` loads `load.lisp`, then the fixtures, runs the
  implemented subset of all 56 numbered §25 tests, runs planted negative
  controls, reports every exclusion, and exits nonzero on any implemented-test
  or negative-control failure.
- The call-296 effect axis carries a structured §10.8 `uncertain-effect` with
  kind `:provider-call`, a placeholder attempt identity, external request
  `(:unavailable :reason :request-identity-never-established)`, alternatives
  `(:billed :not-billed)`, non-empty known facts, a reconciliation procedure,
  and retry policy `:forbidden-without-reconciliation`.
- The R-SYN-1 twin plants the illegal inline-only bounded effect axis and proves
  that `unstructured-uncertainty` fires.
- Pure §23 constructors cover 23.1–23.6, the pre-reconstruction partial shape
  of 23.7, the records-only authorized replacement of 23.8, the reconstructed
  claim shape of 23.9, the asserted self-report of 23.11, and the exposure
  record of 23.12.

`load.lisp` is untouched. Fixtures are intentionally test-loaded after the
plain core so the ordinary loader retains its existing three-smoke-check
behavior.

## R-SYN repairs at this boundary

- **R-SYN-1:** §22 is treated as a canonical axis projection, not a complete
  outcome. The concrete bounded effect axis is bound to a structured
  uncertain-effect record, and inline-only construction is refused.
- **R-SYN-2:** folds consume immutable in-memory event lists only. This arc
  makes no journal grammar, byte, framing, durability, or torn-tail claim.
- **R-SYN-3:** dependency-respecting live preflight is governing law, but there
  is no live invocation/capability/adapter surface in this arc; affected tests
  are excluded rather than simulated with invented semantics.

## Deliberately not implemented

The following phrases are the scope boundary, verbatim:

- **journal store bytes/framing awaits Process-Journal-/0**
- **adapters and anything live-provider**
- **capability live-authority machinery (arc 2 — record shapes for
  minting/restoration receipts ARE defined as data)**
- **channel-policy enforcement**
- **publication effects**

The §23 kill/reconstruct/byte-compare obligation is JOURNAL-dependent and out
of scope for this arc. The constructors establish only the outcome, record, or
claim shapes described below. No shape-only PASS is presented as evidence of
journal persistence, host-kill survival, reconstruction, or byte identity.

## Run

From `experiments/latent-lisp`:

```sh
sbcl --script mneme/kernel0/kernel0-selftest.lisp
```

Expected final lines:

```text
implemented test numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 23, 26, 27, 29, 31, 32, 33, 34, 39, 41, 42, 45, 46, 49, 55
excluded test numbers: 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 28, 30, 35, 36, 37, 38, 40, 43, 44, 47, 48, 50, 51, 52, 53, 54, 56
failing test numbers: none
negative controls: 8 fired, 2 excluded, 0 failed
kernel0 selftest: 29 passed, 27 excluded (out-of-scope), 0 failed
```

The plain loader remains independently runnable:

```sh
sbcl --script mneme/kernel0/load.lisp
```

## §23 fixture status

| Fixture | Pure artifact in this arc | Deferred obligation |
|---|---|---|
| §22 call-296 | Complete four-axis outcome plus structured uncertain effect | Journal, kill/reconstruct, and byte comparison |
| 23.1 untouched seat | Complete outcome | Journal, kill/reconstruct, and byte comparison |
| 23.2 pre-frontier refusal | Complete outcome | Journal, kill/reconstruct, and byte comparison |
| 23.3 completed present | Complete outcome with manifestation and interpretation procedure | Journal, kill/reconstruct, and byte comparison |
| 23.4 present-empty | Complete outcome preserving payload and emptiness-rule identities | Journal, kill/reconstruct, and byte comparison |
| 23.5 completed absent | Complete outcome plus a separate causal claim | Journal, kill/reconstruct, and byte comparison |
| 23.6 present-invalid | Complete outcome preserving payload, parser, and interpretation procedure identities | Journal, kill/reconstruct, and byte comparison |
| 23.7 partial then host death | Pure post-interruption outcome shape with `:present-partial` payload and post-frontier failure | Actual kill, prefix derivation, reconstruction, and byte comparison |
| 23.8 authorized replacement | Predecessor attempt, new attempt, and explicit supersession record | Journal/reconstruction obligations |
| 23.9 reconstructed derived view | Claim shape with origin `:reconstructed` | Actual reconstruction and byte comparison |
| 23.10 mirror-bound publication | None | Channel-policy enforcement and publication effects |
| 23.11 self-report | Claim with origin `:asserted` | Journal/reconstruction obligations |
| 23.12 secret opened to invoker | Exposure record naming the invoker and induced restriction data | Live policy enforcement of later role eligibility and journal/reconstruction obligations |

## Excluded §25 tests

Every omitted number is excluded for one concrete missing protocol or surface.

| Test | Reason |
|---:|---|
| 15 | Provider-alias drift is a machine-configuration/live preflight check. |
| 16 | Missing capability requires live capability machinery (arc 2). |
| 17 | Revocation requires a live capability and revocation registry (arc 2). |
| 18 | Expiry requires live capability validation (arc 2). |
| 19 | Scope mismatch requires live authority/preflight machinery (arc 2). |
| 20 | Defensive live capability-scope copying belongs to arc 2. |
| 21 | Self-restoration is a live-authority operation (arc 2). |
| 22 | Restorer authorization requires live-authority machinery (arc 2). |
| 24 | Restoration-scope enforcement requires live-authority machinery (arc 2). |
| 25 | Blocking live restoration past a frontier requires arc-2/preflight state. |
| 28 | Implicit fallback is an adapter/configuration preflight behavior. |
| 30 | Provider-enforced idempotency requires the adapter protocol. |
| 35 | Torn-tail representation awaits Process-Journal-/0 bytes/framing. |
| 36 | Settled-prefix recovery from a torn tail awaits Process-Journal-/0. |
| 37 | Durability standing requires a journal store and durability protocol. |
| 38 | Cache-versus-prefix precedence requires the journal store/prefix model. |
| 40 | Finalizer loss and reconstruction require the journal store. |
| 43 | The core has no seal/verification standing constructor or enforcement surface. |
| 44 | The core has no publication/truth standing constructor or enforcement surface. |
| 47 | Claim visibility records are opaque data; no published-scope validator exists. |
| 48 | Claim validation records are opaque data; no verified-scope validator exists. |
| 50 | Adapter-version drift requires an adapter/configuration preflight. |
| 51 | Mirror-bound channel-policy enforcement is out of scope. |
| 52 | Channel-policy amendment authority is out of scope. |
| 53 | Publication capability enforcement requires live authority and publication. |
| 54 | Private-staging publication-effect behavior requires channel policy/publication. |
| 56 | No adapter/raw-host escape API exists in this pure-core arc. |

Test 23 is explicitly the **pure-data half** only: the restoration-receipt
constructor enforces a new identity distinct from its predecessor. It does not
restore or grant authority.

## Negative controls

Each executable control plants the violation rather than merely inspecting a
lawful example.

| Control | Result expected from the selftest |
|---|---|
| a blind retry | `unsafe-retry` fires on a second attempt begun over an unresolved bounded effect |
| b payload erasure | `manifestation-payload-missing` fires; the exported/core function surface also has no payload writer |
| c forged observed origin | `standing-inflation` fires through `promote-origin` |
| h mutable capability scope alias | Excluded: live capability machinery is arc 2 |
| d missing exposed principal | `exposed-principal-missing` fires |
| e timestamp-only journal merge | `journal-merge-receipt-required` fires before any merge transformation |
| f global uncertainty collapse | typed `standing-inflation` fires on the unknown `:confidence` outcome field |
| g seat/attempt conflation | `identity-drift` fires |
| i finalizer-only primary fact | Excluded: journal/finalizer machinery awaits Process-Journal-/0 |
| j shorter unsafe convenience accessor | A planted local bare-value shortcut measurably fails the Test-55 axis/context detector; exported outcome accessors are scanned |

Control letters follow the task docket. The docket places capability aliasing
at `h` and finalizer-only facts at `i`; output therefore does not alphabetize
their presentation around `d`–`g`.

## Implementation decisions visible in typed conditions

These are existing core choices that the suite asserts; the test arc did not
change them.

- Inline-only bounded/indeterminate effect axes signal
  `unstructured-uncertainty`; a non-record uncertainty reference does too.
- `:refused` with `:post-frontier` signals `frontier-already-crossed`.
  A complete refused outcome whose effects are not `:not-entered` signals
  `frontier-precondition-failed`.
- A present manifestation without payload signals
  `manifestation-payload-missing`; present-invalid without parser signals
  `invalidity-parser-missing`; present-empty without an emptiness procedure
  signals `interpretation-procedure-missing`.
- Duplicate process, attempt, and external-request identities signal their
  corresponding typed duplicate conditions. A completed occupant followed by
  another attempt in the same seat signals `seat-occupied`.
- Reusing the predecessor attempt identity in a supersession signals
  `duplicate-attempt-identity`. Reusing the predecessor capability identity in
  a restoration receipt signals `capability-restoration-denied`.
- Beginning a new attempt over unresolved bounded/indeterminate predecessor
  effects signals `unsafe-retry`. Supersession authorizes a named successor but
  does not erase predecessor uncertainty.
- Cross-sequence merge without an explicit receipt signals
  `journal-merge-receipt-required`; supplying a receipt still reaches
  `unsupported-reconstruction` because the merge format belongs to
  Process-Journal-/0.
- `promote-origin` always signals `standing-inflation`; `revalidate-claim`
  appends validation while preserving historical origin.
- Unknown outcome keys, including `:confidence`, signal the typed generic
  `standing-inflation` condition because the version-zero constructor accepts
  only its closed schema.
- A noncanonical float at the durable boundary signals
  `noncanonical-durable-value`; a seat used as an attempt signals
  `identity-drift`.

## Specification gaps and bounded claims

1. **§22 omits manifestation alternatives.** The call-296 projection says the
   manifestation determinacy is `:bounded`, while §7.3 requires a finite,
   non-empty, duplicate-free alternatives list. Neither §22 nor Architecture
   0.1 §15.2 names that list. The fixture uses the one named projected state,
   `(:absent-after-completion)`, as the minimal non-inventive singleton. This
   satisfies the constructor but does not claim that a singleton is the
   intended live evidentiary interpretation. The factual classification stays
   outside this arc.
2. **§23 reconstruction exactness has no protocol here.** Journal bytes,
   framing, kill points, durability, prefix selection, and byte comparison are
   delegated. Shape construction is strictly weaker evidence.
3. **Tests 43, 44, 47, and 48 lack pure enforcement surfaces.** Claim
   validation and visibility entries are opaque lists. The core cannot infer
   sealed/verified or published/true standing, nor validate scope/procedure
   substructure, without semantics the governing spec does not make concrete
   in this arc.
4. **Test 45 is bounded to enforceable structure.** The core preserves a
   present-invalid payload and parser identity, requires an interpretation
   procedure, and refuses `:accepted`/`:rejected` over present-invalid or absent
   manifestations. It has no separate parser-valid fact or relation declaring
   that one procedure is semantic rather than syntactic.
5. **Test 55 cannot police arbitrary future local functions.** It proves that
   `outcome-axis` returns a complete axis and scans the exported Kernel /0
   `OUTCOME-*` function surface against the context-preserving allowlist. The
   negative-control shortcut is test-local and is rejected by the same
   structural detector; this is not a general Common Lisp definition guard.
6. **Capability receipts are historical data only.** The pure restoration
   receipt checks new identity inequality, but liveness, revocation, delegate
   authority, and scope non-enlargement require arc 2.
7. **§23.12 policy consequences are data, not enforcement.** The invoker and
   induced restrictions are recorded; later-role eligibility enforcement
   awaits live policy machinery.

No core defect was observed by the implemented pure subset. That statement is
bounded to the exact SBCL command above and does not cover the 27 excluded
tests or the two excluded negative controls.

— built by Codex workers under the conductor's verification, Claude Fable 5 chair
