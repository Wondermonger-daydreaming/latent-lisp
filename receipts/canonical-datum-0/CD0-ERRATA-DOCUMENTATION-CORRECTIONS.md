# CD/0 Errata 0.1 documentation corrections

Date: 2026-07-13

This receipt isolates the four LOW documentation repairs required by the
post-implementation ruling. They are documentation-integrity corrections, not
codec semantics.

## 1. Concrete A2 split

`CANONICAL-DATUM-DIVERGENCES.md` now records the historical split explicitly:
Common Lisp returned
`InvalidCanonicalGrammar/<specific-code>/host-import`; Python returned
`UnsupportedHostInput/<specific-code>/host-import`. The closure states why the
errata selects the latter category without treating Python as specification
authority. The same addendum names the historical A9 split.

## 2. Seed commits versus corrected tips

The Common Lisp, Python, and integration READMEs identify these independence
anchors:

```text
Common Lisp e6f3b579742f5fcff0d82477d07f8c0c9ee34df3
Python      58ecca4083275ebfe16605765e575bfb9f6eb755
```

They explicitly explain that audited tips contain bounded corrections authored
after cross-reading was authorized and then backported. Those tips remain
provenance, not independence anchors.

Every current independence claim uses exactly:

“Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.”

The unqualified phrase “clean-room independent implementations” is not used as
an affirmative claim.

## 3. Depth/node stages and row accounting

The two Phase-0 resource fixtures now use `type-tag`:

```text
cd0-neg-resource-depth  ResourceRefusal/ExcessiveNesting/type-tag
cd0-neg-resource-nodes  ResourceRefusal/NodeBudgetExceeded/type-tag
```

Current READMEs, the closure addendum, verifier, hand summary, qualification,
and new receipts distinguish the result as:

```text
71 classified = 66 octet + 5 host
Python:      71 executed, 0 N/A, 0 failures, 0 skips
Common Lisp: 68 executed, 3 N/A, 0 failures, 0 skips
```

N/A rows are neither passes nor failures. No current receipt calls this “71
tests passed.”

## 4. Superseded Phase-0 forward pointer

`canonical-datum/evidence/PHASE0-VERIFICATION.md` begins with a conspicuous
historical banner. It preserves old hashes but directs readers to the prior
correction and current `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md`.

Additional defensive banners were added to the old root implementation ledger,
the prior implementation receipt, the historical release verification, and the
historical qualification verification so pre-errata “open/provisional” language
cannot silently masquerade as current closure status.

## Verification boundary

These edits improve provenance and accounting legibility. They do not upgrade
tracked evidence to independently executed evidence, turn N/A into pass, or
change a datum, byte, failure, or v1 behavior.
