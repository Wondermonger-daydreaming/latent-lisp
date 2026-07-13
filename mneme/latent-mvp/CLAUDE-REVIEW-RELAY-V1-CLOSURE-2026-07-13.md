# Relay to Claude — cold review the Mneme v1 counterexample-closure sprint

**Date assembled:** 2026-07-13
**From:** Codex, after implementation and three independent read-only review passes
**To:** Claude, when you later receive this work
**Repository:** `Wondermonger-daydreaming/latent-lisp`
**Working branch:** `codex/v1-counterexample-closure`
**Audited base:** `9e9c031a720cd40559297c9d8bb07bf8137adb54`
**Review target:** `9ad804f4e640e2901e9405a64af4444ee7fa9eb5`
**Target tree:** `ca62f47f2ace3ccdef0194f65056be6373732bb2`

Claude: treat this as a review packet, not a request for ceremonial approval. The
implementation is green under its recorded tests. Your useful role is to find the
counterexample that those tests or their author did not imagine, to identify any
place the prose outruns the mechanism, and to keep façade closure distinct from
language closure.

This relay is deliberately self-contained, but the primary receipt remains
`../../../V1-COUNTEREXAMPLE-CLOSURE.md`.

---

## 1. Review contract

Please review the sprint against this bounded claim:

> At revision `9ad804f`, the ten preserved fixtures close the seven requested
> counterexample classes for clients restricted to the documented
> `mneme.client` exports, on SBCL 2.4.6. This does not establish confinement
> against unrestricted same-image Common Lisp, complete located-claim identity,
> cryptographic lineage, concurrency semantics, or implementation-independent
> Lisp+ language closure.

Do not accept any stronger reading merely because `verify-all.sh` exits zero.
Conversely, do not erase the real P3 mechanisms merely because P4/P5 remain open.
The useful judgment is which exact boundary holds, which does not, and which new
observation would move that boundary.

### In scope for your review

- the ten permanent counterexample fixtures;
- the private canonical datum representation;
- proposition/fingerprint consistency under admitted client mutation;
- scope ingress, egress, and structural comparison;
- guarded receipt transitions and structured error endpoints;
- the split between raw decoding and receipt-backed revival;
- preservation of predecessor testimony through a second handoff;
- integration with existing adversarial, process-boundary, atelier, and
  Language-A verification floors;
- accuracy of the new report and updated verification metadata.

### Not silently claimed by this sprint

- closure of every defect listed in `LANGUAGE-BOUNDARY.md`;
- a normative canonical codec or canonical bytes;
- module/operator confinement;
- stable code identity or enforced effect declarations;
- complete `as-of`/corpus/policy/scope claim identity;
- cryptographic authentication;
- revocation-aware standing for claims already raised;
- a second implementation.

If you find one of these deferred gaps, record it; do not mislabel it as a
regression unless the patch made it worse or its documentation claims it closed.

---

## 2. Provenance and reversible anchors

The external audit named this exact base:

```text
9e9c031a720cd40559297c9d8bb07bf8137adb54
```

The audit file `LANGUAGE-BOUNDARY.md` was observed with SHA-256:

```text
c1876eba2010b5ab2fc23afb15b7982b4a2ee4550a11238e81a592965111a242
```

Before implementation, the base was preserved twice:

- local ref `backup/audit-9e9c031`;
- standalone bundle `../latent-lisp-audit-9e9c031.bundle`.

The bundle was verified as complete history and currently hashes to:

```text
9439d8f3509a8e6c43bab946f9401aa1cbdb971add078fe596178c5bde58b35b
```

The work was deliberately split into reviewable commits:

```text
7b50deb441189e9cb3a48174038c4495347e9b0e
  test: reproduce v1 exported-client counterexamples

76ac3fd2405c23957fcb3a6789cd111e3f6a8c6f
  fix: close v1 exported-client counterexamples

9ad804f4e640e2901e9405a64af4444ee7fa9eb5
  docs: align verification manifest with closure floor
```

This sequencing is load-bearing. Commit `7b50deb` contains the permanent fixtures
over the unchanged audited kernel. It is the preserved red boundary, not a test
suite reconstructed after the implementation was already known.

Key file hashes at the review target:

```text
31ee6f452b6426f5889439b78871cbc83193a1f2b382fb66fa4436ab24ee976a
  V1-COUNTEREXAMPLE-CLOSURE.md

fe3f496d626c2401962f00ecfb56faa6b2a969c54d2deabbe9465a9a80f1632c
  mneme/latent-mvp/kernel-hardened.lisp

05a5d39c8044ce8c6ec9697bf8c799803d54e7893e1a3d025a3105fb515e2761
  mneme/latent-mvp/counterexample-closure.lisp

2f8e5706e9daa0c449534e4c8536231099be4093b1cc7d0ef82cd8eac3a97051
  mneme/verify-all.sh
```

No remote push was performed during the implementation session.

---

## 3. What the audit asked to close

The focused prompt required executable reproduction and repair of at least these
seven classes:

1. mutable string leaves shared through `copy-tree`;
2. mutation through the exported `claim-proposition` reader;
3. stale fingerprints after admitted datum mutation;
4. mutable or object-identity-based scope;
5. recommit after revival rewinding receipt state;
6. raw decoding being confused with receipt-based revival;
7. second-hop loss of predecessor testimony.

It also required:

- permanent adversarial fixtures;
- comparison of three immutable-data strategies;
- either guarded monotone receipt transitions or immutable state-indexed receipts;
- source and destination states in illegal-transition failures;
- code, tests, before/after transcript, report, residual isolation threats, and
  exact SBCL results;
- no claim of whole-language closure.

The permanent suite maps the seven classes into ten probes:

| Fixture | Counterexample isolated |
|---|---|
| CE1 | input string mutation reaches stored claim |
| CE2 | string mutation through `claim-proposition` reaches stored claim |
| CE3 | old fingerprint authenticates a proposition changed through a shared string |
| CE4 | input scope mutation and `eq`-only scope matching |
| CE5 | mutation through `attestation-scope` |
| CE6 | recommit rewinds `:revived` to `:committed` |
| CE7 | handoff failure omits structured source/destination states |
| CE8 | raw text can enter receipt-based `revive` |
| CE9 | no explicitly named, explicitly untrusted raw decoder exists |
| CE10 | inherited predecessor testimony disappears at the next freeze/revive hop |

Against the pinned kernel, the suite produced exactly `0 passed, 10 failed` and
exit 1. At the review target it produces `10 passed, 0 failed` and exit 0.

---

## 4. What changed in the kernel

### 4.1 Private canonical datum representation

The sprint compared:

1. recursive copying of every mutable host atom;
2. conversion into a private canonical datum representation;
3. authoritative storage of canonical bytes.

It chose strategy 2. The reference-evaluator reason is not speed: an explicit
private value algebra makes ingress, egress, and equality visible in one place,
whereas copy-only discipline can regress whenever the admitted grammar grows.
Canonical bytes remain the stronger future identity layer, but implementing them
without a normative symbol, numeric, Unicode, and module codec would have exceeded
this sprint.

Review these definitions first:

```text
kernel-hardened.lisp:126  canonical-cons
kernel-hardened.lisp:132  canonical-string
kernel-hardened.lisp:148  %freeze-datum
kernel-hardened.lisp:156  %thaw-datum
kernel-hardened.lisp:165  %datum-equal
kernel-hardened.lisp:177  %canonicalize-datum
```

The representation closes aliases only within the exported-client threat model.
Its Common Lisp structs and their slots remain mutable to code allowed to name
`mneme::` internals. That is documented, not solved.

### 4.2 Proposition and fingerprint consistency

`%canonicalize-proposition` now returns the private datum form rather than a
`copy-tree`. `assert-claim` stores canonical `as-of` data. Client readers thaw fresh
host values.

`%ensure-claim-integrity` recomputes the fingerprint and is called before the
proposition is returned, before `raise-claim`, and before `freeze`.

Points to attack:

- Is every admitted mutable datum species represented? The current grammar admits
  numbers, symbols, strings, characters, and cons trees.
- Are dotted lists and deeply nested strings safe?
- Can a client obtain an alias through a reader not covered by CE1–CE5?
- Does integrity checking happen before every authority-relevant use, or can an
  internal mutation mint an attestation before the stale claim is rejected?

The last question crosses into same-image private access, but it is still useful to
name precisely.

### 4.3 Canonical scope

`verify-proposition` canonicalizes scope at mint time. `attestation-scope` thaws a
fresh value. `raise-claim` canonicalizes the supplied scope and compares it with
`%datum-equal`, so semantically equal safe-data scopes no longer require `eq`
identity.

This is an equality repair, not a scope calculus. No subsumption, corpus version,
policy identity, or located-claim integration is claimed.

### 4.4 Guarded monotone receipts

The implementation retains one private mutable receipt object for compatibility,
but guards all state-changing entry points:

```text
:prepared → :committed → :received → :revived
```

`handoff-state-violation` now carries `source-state` and `destination-state` slots,
exported as `handoff-source-state` and `handoff-destination-state`.

The central guard is `%guard-receipt-transition`. `commit` guards before writing;
`receive` guards before reading and verifies the digest before advancing; `revive`
accepts only a receipt in `:committed` or `:received`, constructs the claim, and
only then marks the receipt `:revived`.

CE6 samples `:revived → :committed`; CE7 samples `:prepared → :received`. The code
is general, but the test suite does not enumerate the full illegal-transition
matrix. A worthwhile cold-review extension is to generate that matrix and verify
that failure never advances state.

### 4.5 Raw decode is not receipt revival

`decode-artifact` accepts hostile raw text and marks provenance
`:decoded-untrusted t`. It cannot claim `:revived` receipt continuity.

`revive` now accepts a receipt only. Passing raw text signals a structured
`:raw-data → :revived` handoff violation.

The process-boundary suite was corrected to use `decode-artifact`. This correction
matters semantically: only bytes cross between process A and process B, so that
suite witnesses hostile raw decoding, inert predecessor data, absence of live
standing, and successor re-verification. It does not witness receipt custody across
the process gap. Receipt-backed revival remains an in-image test.

### 4.6 Second-hop predecessor testimony

`freeze` now serializes inherited predecessor records followed by newly
authenticated warrants. This preserves the recorded testimony across the tested
second hop while keeping it out of the authenticated-warrant set.

This is not verified transitive lineage. A raw artifact can still self-report
predecessor records; no signature or registry proof follows those records across
processes. Ordering, duplicate policy, hop identity, compaction, and loss reports
remain open.

---

## 5. Corrections made during implementation

Do not let the final clean diff erase the work's wrong turns; they reveal where
the abstraction is fragile.

### Correction A — replay initially regressed

After introducing private canonical propositions, `replay-and-attest` still passed
`%claim-canonical` directly into `verify-proposition`. The verifier correctly
rejected the private `canonical-cons` as unsafe client input. The existing
adversarial suite fell to 15/3 and the boundary suite to 0/9 in an independent
review run.

The repair was to thaw the proposition before re-verification. Existing suites
then returned to 18/18 and 9/9. Review this seam carefully: it is the point where a
private evaluator value deliberately re-enters the client datum grammar.

### Correction B — the process boundary was overnamed

The pre-patch API called both raw-text reconstruction and receipt custody
`revive`. Once the operations were split, the boundary suite could no longer
honestly describe raw process-B bytes as receipt-backed revival. Its code and
language were changed to `decode-artifact` and `:decoded-untrusted`.

### Correction C — verification metadata lagged behind the code

The first green implementation commit updated `verify-all.sh`, but root README and
`mneme/MANIFEST.md` still reported five floors and stale adversarial/atelier counts.
An independent final audit found this contradiction. Commit `9ad804f` corrected
the metadata to six floors, adversarial 18/18, counterexamples 10/10, and four
atelier banners.

These corrections are evidence that existing suites and independent readers did
disagree with the implementation during the work. They are not evidence that the
remaining surface is complete.

---

## 6. Verification receipt

Observed on 2026-07-13 under SBCL 2.4.6:

```text
PASS  conformance-walk              7/7
PASS  adversarial-conformance       18/18
PASS  counterexample-closure        10/10
PASS  boundary                      9/9
PASS  atelier                       4 pass-banners
PASS  language-a-fixtures           14/14
ALL FLOORS HOLD — 6/6 suites green.
```

Exact top-level command:

```sh
cd /home/gauss/Codex-Lab/latent-lisp
bash mneme/verify-all.sh
```

The zero exit establishes only what these six floors inspect. The boundary suite
uses two separate SBCL images; the rest remain SBCL-specific, and none is an
independent Lisp+ implementation.

---

## 7. Suggested cold-review procedure

Start read-only and preserve the branch:

```sh
cd /home/gauss/Codex-Lab/latent-lisp
git status --short --branch
git rev-parse HEAD HEAD^{tree}
git log --reverse --oneline 9e9c031a720cd40559297c9d8bb07bf8137adb54..HEAD
git diff --check 9e9c031a720cd40559297c9d8bb07bf8137adb54..HEAD
```

Read the red fixtures before the fix:

```sh
git show 7b50deb:mneme/latent-mvp/counterexample-closure.lisp
git diff 7b50deb^..7b50deb
```

Read implementation by obligation, not just as one large diff:

```sh
git diff 7b50deb..76ac3fd -- mneme/latent-mvp/kernel-hardened.lisp
git diff 7b50deb..76ac3fd -- mneme/latent-mvp/counterexample-closure.lisp
git diff 7b50deb..76ac3fd -- mneme/latent-mvp/adversarial-conformance.lisp
git diff 7b50deb..76ac3fd -- mneme/latent-mvp/boundary
git diff 7b50deb..76ac3fd -- mneme/verify-all.sh
```

Run the focused and umbrella checks:

```sh
cd mneme/latent-mvp
sbcl --script counterexample-closure.lisp
sbcl --script adversarial-conformance.lisp
bash boundary/run-boundary.sh

cd ..
bash verify-all.sh
```

Then design at least one counterexample not already named. Strong candidates:

1. generate nested/dotted admitted data and mutate every returned string;
2. enumerate every illegal receipt transition and assert endpoints plus unchanged
   source state after failure;
3. freeze/revive for three or more hops, with reauthentication in an intermediate
   generation;
4. mutate predecessor/provenance values returned by their readers;
5. exercise scope under structurally equal but separately allocated dotted data;
6. test failure during receipt decode and confirm the receipt remains retryable but
   never rewinds;
7. test whether any authority-relevant field still exposes a mutable host alias.

Do not quietly fold the known `as-of` or printer defects into this sprint and then
announce broader closure. If you choose to repair them, plant new red fixtures and
make their expansion of scope explicit.

---

## 8. Known residuals to verify, not rediscover as surprises

These are documented and currently reproducible or structurally evident:

### Remaining exported-façade debts

- A warrant for one proposition can still raise a same-proposition claim with a
  different `as-of`, because `as-of` is stored canonically but not part of the
  warrant target.
- `%fingerprint` still depends on ambient Common Lisp printer/package state.
- `receipt-path` returns a mutable host string.
- `attestation-principal` may expose an arbitrary mutable operator-supplied host
  object.
- Existing claim standing does not dynamically follow later warrant revocation.
- Warrant reuse and duplication policy remains unspecified.
- Procedure IDs may be rebound to different host closures; effect labels are not
  enforced.

### Isolation/evaluator debts

- same-image `mneme::` access can mutate private values and registries;
- `mneme.operator` names an API surface but does not authenticate its caller;
- registered procedures are unrestricted Common Lisp closures;
- mint, authority, procedure, and revocation stores are process-local mutable hash
  tables without specified concurrency semantics;
- host effects and conditions are not confined at an evaluator/FFI boundary;
- MD5 and raw predecessor plists do not establish authenticity;
- no normative reader/codec/module/evaluator spec or independent implementation
  exists.

Finding these again confirms the report's honesty. The higher-value review result
is a new path by which one of the ten claimed closures fails inside
`mneme.client`, or evidence that a repair changed an unrelated protected behavior.

---

## 9. Relay from the three independent reviewers

Three parallel read-only reviewers were used after the user explicitly authorized
subagents.

### Tesla — datum review

Tesla initially preferred complete recursive copying as the narrowest patch, then
accepted the private datum representation as the clearer reference-evaluator model
once the implementation remained small and its same-image ceiling was explicit.
Tesla independently reproduced two deferred defects: `as-of` target reuse and
ambient-printer fingerprint mismatch. Tesla also identified the mutable
`receipt-path` and `attestation-principal` aliases.

### Hubble — handoff review

Hubble recommended guarded monotone transitions, structured endpoints, explicit
raw decode, and cumulative predecessor testimony. The most important correction
was semantic: process B receives raw bytes, not a live receipt, so the process
suite must not claim receipt-backed continuity.

### Jason — verification review

Jason confirmed the red baseline was exactly 0/10 and caught the temporary
`replay-and-attest` regression after private canonicalization. In the final audit,
Jason found no code blocker but found stale README/MANIFEST counts contradicting
the new sixth CI floor; those became the documentation-only commit `9ad804f`.

Their agreement is not independent implementation evidence: all three inspected
the same Common Lisp source and SBCL tests. It is independent reading of shared
artifacts, useful for catching narrative and integration drift.

---

## 10. Requested shape of your review return

Please return findings first, ordered by severity, with file and line references.
For each finding, distinguish:

- **observed regression** — current behavior violates an explicit sprint
  obligation or protected invariant;
- **test weakness** — the mechanism may be sound, but evidence does not warrant the
  prose;
- **documented deferred debt** — real, but outside the sprint's bounded claim;
- **architecture/isolation debt** — not repairable by another façade check alone;
- **specification ambiguity** — two implementations could reasonably disagree.

Include exact commands and results for anything you execute. If no blocker is
found, say what you inspected and name the strongest remaining counterexample you
would test next. “Looks good” without a stated vantage is not a review this relay
can use.

---

## 11. The live question

The sprint closes a particularly embarrassing family of façade counterexamples:
the runtime said “private immutable copy” while sharing mutable strings, said
“receipt chronology” while allowing rewind, said “revival” for raw decoding, and
said testimony survived while dropping it on hop two.

The live question is narrower and harder now:

> Is the private canonical datum plus guarded-transition boundary internally
> coherent for every value and transition admitted by `mneme.client`, or is there
> another ordinary exported operation that still changes what an authenticated
> object means without changing the identity by which it is accepted?

That is the question worth bringing cold weights to.
