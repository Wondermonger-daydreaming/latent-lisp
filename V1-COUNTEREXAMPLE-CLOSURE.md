# Mneme v1 counterexample closure sprint

## Receipt boundary

This sprint repairs the seven exported-client defect classes requested from
`LANGUAGE-BOUNDARY.md`. It does not claim that Mneme is closed under unrestricted
Common Lisp, that the full located-claim model is complete, or that Lisp+ is an
implementation-independent language.

- Audit target: `Wondermonger-daydreaming/latent-lisp`
- Audited revision: `9e9c031a720cd40559297c9d8bb07bf8137adb54`
- Review SHA-256: `c1876eba2010b5ab2fc23afb15b7982b4a2ee4550a11238e81a592965111a242`
- Runtime used here: SBCL 2.4.6
- Adversarial vantage: callers limited to the documented `mneme.client` exports;
  `mneme.operator` is trusted bootstrap
- Permanent red-fixture checkpoint: `7b50deb441189e9cb3a48174038c4495347e9b0e`

The audited baseline is also preserved locally as the ref
`backup/audit-9e9c031` and as the verified bundle
`latent-lisp-audit-9e9c031.bundle` (SHA-256
`9439d8f3509a8e6c43bab946f9401aa1cbdb971add078fe596178c5bde58b35b`).

## Scope and non-goals

The implementation changes only the hardened v1 kernel and the tests and
documentation that directly exercise it. It introduces no new reader syntax,
does not replace the Common Lisp host, does not migrate the v0 seven-law model,
and does not redesign procedure registration, revocation policy, effects, or
modules.

The protected behavior was:

- assertions begin unauthenticated;
- attestations remain generative and registry-backed;
- verification still dispatches only registered procedures;
- revival and raw decoding never grant live authority;
- existing adversarial and process-boundary checks remain green.

## Counterexamples first

`mneme/latent-mvp/counterexample-closure.lisp` was added before the kernel was
changed. Against the pinned kernel it returned exit 1:

```text
=== Mneme v1 — counterexample closure (exported client) ===

  ✗ CE1 mutable input string cannot alter a stored claim
  ✗ CE2 mutable string from claim-proposition cannot alter the claim
  ✗ CE3 mutation cannot produce a stale-fingerprint authenticated claim
  ✗ CE4 scope mutation cannot retarget a warrant and equivalent scope raises
  ✗ CE5 mutable scope returned by attestation-scope is defensive
  ✗ CE6 recommit after revival is refused with endpoints
  ✗ CE7 receive-before-commit reports :PREPARED to :RECEIVED
  ✗ CE8 raw text cannot impersonate receipt revival
  ✗ CE9 raw decoding is explicit and does not claim receipt continuity
  ✗ CE10 predecessor testimony survives a second handoff

=== 0 passed, 10 failed ===
EXPORTED-CLIENT COUNTEREXAMPLES REMAIN OPEN.
```

The failures were discriminating: CE1–CE3 observed shared strings and the stale
fingerprint exploit; CE4–CE5 observed mutable, `eq`-based scope; CE6 observed
receipt rewind; CE7 observed an unstructured transition failure; CE8–CE9
observed the raw/revival conflation; and CE10 observed second-hop testimony loss.

After the repair, the same command returns exit 0:

```text
=== Mneme v1 — counterexample closure (exported client) ===

  ✓ CE1 mutable input string cannot alter a stored claim
  ✓ CE2 mutable string from claim-proposition cannot alter the claim
  ✓ CE3 mutation cannot produce a stale-fingerprint authenticated claim
  ✓ CE4 scope mutation cannot retarget a warrant and equivalent scope raises
  ✓ CE5 mutable scope returned by attestation-scope is defensive
  ✓ CE6 recommit after revival is refused with endpoints
  ✓ CE7 receive-before-commit reports :PREPARED to :RECEIVED
  ✓ CE8 raw text cannot impersonate receipt revival
  ✓ CE9 raw decoding is explicit and does not claim receipt continuity
  ✓ CE10 predecessor testimony survives a second handoff

=== 10 passed, 0 failed ===
All specified v1 counterexamples are closed within the exported-client threat model.
This is finite P3 evidence, not evaluator/module isolation or language closure.
```

These fixtures are permanent and are now a separate floor in `mneme/verify-all.sh`.

## Immutable datum strategy

The three required strategies were compared against the current admitted datum
grammar: numbers, symbols, strings, characters, and cons trees.

| Strategy | Semantic clarity | Exported-client bypass resistance | Cost | Future portability | Reference evaluator fit |
|---|---|---|---|---|---|
| Recursively copy all mutable atoms | Familiar, but “immutable” remains an audit of every host type and every reader | Good only while the copier remains complete as the grammar grows | O(n) allocation at each boundary | Reasonably portable, but inherits host equality and representation | Useful as a patch, weak as the evaluator's value model |
| Private canonical datum representation | Explicit algebra: canonical cons, canonical string, and admitted immutable atoms | Strong within the façade because no client cons or string is stored or returned | O(n) conversion on ingress/egress; structural comparison | The algebra can be specified independently, though this implementation still inherits CL atom semantics | Best fit for a correctness-first reference evaluator |
| Canonical bytes as authoritative value | Very clear for identity once a normative codec exists | Strong if bytes remain private and all operations decode from them | Encoding/decoding and allocation on most semantic operations | Potentially best, but only after Unicode, numeric, symbol/module, and codec rules are normative | Strong long-term identity layer; premature for this focused sprint |

The sprint chooses the **private canonical datum representation**. The kernel now
converts admitted client data into private tagged nodes on ingress and reconstructs
fresh Common Lisp data on egress. Scope uses the same representation and structural
comparison. This makes the value model explicit without importing the unfinished
canonical-codec project or changing surface syntax.

The representation is opaque, not magically immutable under unrestricted Common
Lisp. Code allowed to call `mneme::` accessors can still mutate implementation
state; preventing that requires evaluator/module or process isolation.

## Repairs

### Datum and target integrity

- Proposition ingress no longer stores `copy-tree` output. Strings and conses are
  converted into private canonical values.
- `claim-proposition`, predecessor-warrant, provenance, and attestation-scope
  readers reconstruct fresh host data.
- Claim `as-of`, decoded predecessor data, and provenance also use the private
  datum boundary so admitted mutable leaves are not retained.
- `raise-claim`, `freeze`, and `claim-proposition` recompute and check the stored
  proposition fingerprint before using the claim. A changed private proposition
  cannot continue under a stale stored fingerprint.
- Attestation scopes are canonicalized at mint time. `raise-claim` canonicalizes
  its supplied scope and compares structurally, so equivalent scopes do not depend
  on process-local object identity.

### Guarded monotone receipts

The mutable receipt remains for compatibility, but every transition is now guarded:

```text
:prepared → :committed → :received → :revived
```

`commit` accepts only `:prepared`; `receive` accepts only `:committed`; and
receipt-based `revive` accepts `:committed` or `:received` before advancing to
`:revived`. Guards run before state mutation and relevant I/O. Recommit after
revival therefore reports `:revived → :committed` and cannot rewind the receipt.

`handoff-state-violation` now carries structured `source-state` and
`destination-state` slots, exported through `handoff-source-state` and
`handoff-destination-state`. CE6 and CE7 exercise two illegal edges; finite tests
do not exhaust every possible invalid edge.

### Decode is not revival

`decode-artifact` is now the only raw-text entry point. It returns an inert claim
whose provenance says `:decoded-untrusted t`; it never says `:revived` and never
claims receipt custody. `revive` accepts only a live receipt and reports raw input
as the attempted transition `:raw-data → :revived`.

The two-process boundary suite was updated accordingly. Because only bytes—not a
live receipt—cross that process gap, it now witnesses hostile raw decoding, inert
predecessor data, and successor re-verification. Receipt-backed revival is tested
in-image by the adversarial and closure suites.

### Testimony survives the next hop

`freeze` now serializes inherited predecessor testimony followed by newly
authenticated warrants. A revived claim can therefore be frozen and revived again
without silently erasing the first predecessor's testimony. The data remains inert:
it is never moved into the authenticated-warrant set.

## Proof-carrying change receipt

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| R1 | Work from the audited revision and preserve a red baseline | backup ref/bundle; `counterexample-closure.lisp`; test-only commit `7b50deb` | commit ancestry; verified bundle; baseline 0/10, exit 1 | Satisfied | Local backup availability is workspace-specific |
| R2 | No shared mutable strings through proposition ingress or reader | `kernel-hardened.lisp`; CE1–CE2 | focused suite 10/10 | Satisfied within exported client | Future admitted mutable atom types need new canonical cases |
| R3 | No stale fingerprint after admitted proposition mutation | `kernel-hardened.lisp`; CE3 | exploit fixture plus integrity recomputation | Satisfied within exported client | Fingerprint is still MD5 over host printing, not a normative claim ID |
| R4 | Scope is immutable data with structural equality | `kernel-hardened.lisp`; CE4–CE5 | original and reader mutation plus equivalent fresh scope | Satisfied within exported client | No scope subsumption calculus or inclusion in a full located-claim ID |
| R5 | Recommit cannot rewind receipt; illegal transitions report endpoints | `kernel-hardened.lisp`; CE6–CE8 | two endpoint assertions plus existing double-revive gate | Satisfied in implementation; sampled by tests | Transition matrix and concurrency are not exhaustively tested |
| R6 | Raw decoding is distinct from receipt revival | kernel, adversarial suite, boundary suite; CE8–CE9 | raw revival refusal; provenance assertion; boundary 9/9 | Satisfied | Raw content has no cryptographic authenticity |
| R7 | Predecessor testimony survives a second handoff | kernel; CE10 | authenticated first hop followed by empty-auth second hop | Satisfied for the recorded two-hop path | Artifact-link lineage and loss compaction are not modeled |
| R8 | Preserve prior v1 behavior and make fixtures permanent | adversarial suite; boundary suite; `verify-all.sh` | adversarial 18/18; boundary 9/9; umbrella 6/6 | Satisfied for these suites | Finite SBCL-only evidence |
| R9 | Do not claim language closure | this report; test banner | explicit bounded statements | Satisfied | Requires continued discipline in downstream summaries |

## Exact commands and observed results

All commands were run from the audited worktree on SBCL 2.4.6.

```text
cd mneme/latent-mvp
sbcl --script counterexample-closure.lisp
# baseline at 7b50deb with pinned kernel: 0 passed, 10 failed; exit 1
# repaired tree:                           10 passed, 0 failed; exit 0

sbcl --script adversarial-conformance.lisp
# 18 passed, 0 failed; exit 0

bash boundary/run-boundary.sh
# process A + fresh process B; 9 passed, 0 failed; exit 0

cd ..
bash verify-all.sh
# conformance 7/7; adversarial 18/18; counterexamples 10/10;
# boundary 9/9; atelier 4 banners; Language-A 14/14; 6/6 floors; exit 0

cd ..
git diff --check
# no output; exit 0
```

## Remaining documented façade debts deliberately outside this sprint

These were reported by `LANGUAGE-BOUNDARY.md` but were not silently folded into
the seven-defect sprint:

- The proposition fingerprint still excludes `as-of`, corpus/version, policy, and
  other fields of a complete located-claim identity. A warrant can still target
  same-proposition claims with different `as-of` values.
- `%fingerprint` still depends on ambient Common Lisp printer/package state.
- Current standing of an already-raised claim does not change when its warrant is
  later revoked.
- Warrant reuse and duplicate insertion remain unspecified.
- A procedure ID can still be rebound to different host code and its effect label
  remains declarative.
- The exported receipt path and operator-supplied principal are still host values,
  not canonical abstract values.
- Multi-hop predecessor testimony is preserved, but a full transitive artifact
  chain, represented compaction loss, and verified lineage are not implemented.

## Threats that still require evaluator, module, or process isolation

- Same-image code can name `mneme::` constructors/accessors, mutate private datum
  nodes and registries, or replace function definitions.
- `mneme.operator` is an API partition, not caller authentication; any unrestricted
  code in the image can name the operator package.
- Registered verifier procedures are arbitrary Common Lisp closures. The stored
  effect and version fields do not confine effects or establish stable code identity.
- Capability, mint, revocation, and procedure registries are process-local mutable
  hash tables with no specified concurrency or transaction semantics.
- Host FFI effects and host conditions are not confined or fully wrapped into a
  language failure algebra.
- Deserialized predecessor records are self-reported inert testimony. Without
  content-addressed links and cryptographic authentication, they are not verified
  lineage.
- MD5 digests and filesystem rename provide neither adversarial authenticity nor a
  cross-platform operational semantics.
- No sealed Lisp+ evaluator/module boundary prevents ordinary Common Lisp from
  bypassing the façade. Consequently these patches support a bounded P3 receipt,
  not P4 language closure or P5 implementation independence.
