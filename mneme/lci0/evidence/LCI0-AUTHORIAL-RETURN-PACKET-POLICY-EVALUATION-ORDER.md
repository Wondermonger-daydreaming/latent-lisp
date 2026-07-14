# LCI/0 Authorial Return — Policy Evaluation Order and Decision Vocabulary

Date: 2026-07-14

Status: PROVISIONAL AUTHORIAL RETURN / AFFECTED COMBINED POLICY PATH BLOCKED

This packet reports three closure conflicts between Fixture Package Specification §8.1
and the sealed Policy-A/Policy-B registry records. It does not select one source
as an oracle and does not authorize production admissibility semantics.

## Frozen identities

| Artifact | Bytes | SHA-256 |
| --- | ---: | --- |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | sealed artifact | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| `LCI0-FIXTURE-REGISTRY.json` | 158,009,634 | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `admissibility-policy.a.0` | 8,128 | `467561cb0c91e644761006dac047dac7efde77840d49ec12bf113704256f6373` |
| `admissibility-policy.b.0` | 8,782 | `0e04628c6bf3f8361ca1f8f61b7ffe9288e17e056f4fada097f8f8f2f39ecc6f` |

## Conflict 1: evaluation order

After the mandatory E2 target-relation floor, package-spec §8.1 states this
R-valued order:

```text
target-kind
boundary-coherence
represented-loss
inherited/external trust
freshness
final outcome
```

Both canonical policy records instead carry this exact sequence:

```text
target-relation-floor
target-kind
freshness
represented-loss
inherited-or-external-treatment
scope-narrowing
final-disposition
```

The canonical sequence moves freshness ahead of loss and trust, omits the
named boundary-coherence step, and adds scope narrowing as a policy step. The
prose and machine records therefore select different first outcomes when more
than one post-floor predicate fails.

### Smallest retained combined stale/loss/trust witness

Within this six-coordinate diagnostic construction, the retained carrier
contains exactly the facts needed to expose the order. No claim is made that it
is globally minimal across every possible future policy input schema, and it is
not proposed as a new normative schema:

| Coordinate | Exact value | Component SHA-256 |
| --- | --- | --- |
| policy | `stable-ref.policy.b` | `c3668765ebd3d7cc772fc3163771e19a038adcd83b2f8e756824dce1997dbce4` |
| target relation | `relation.exact-target` | `df1d4ff074f48a9f861f2535f12ec572f6b26b3142a60bad070f55e8f871708b` |
| target kind | `target-kind.externally-attested` | `dbc252c771dd51e9a5eff249f6f8a66d0c8e70979c5c71b3e0748a3636514914` |
| age | 169 fixture ticks, one above Policy-B's 168-tick limit | exact integer |
| represented-loss consequence | `relation.identity-bearing-loss` | `c90c3a0a6d6ac9d01b67eeb6a59bb4a4d784029a823b677bf6e4ec9c1906d89f` |
| principal | `stable-ref.principal.external-untrusted` | `efb2a4dff0cbda2e0da5463d599f739ffb319090d08398652159a70ce0e4c830` |

The six-field canonical diagnostic document is 1,686 bytes with SHA-256
`a061ba268a0bf6960410f0e467fb2b548fe7aded8f29411909434171defa809c`.
It is a successful target relation with simultaneous stale, identity-bearing
loss, and untrusted-principal predicates. No ClaimId, target wrapper, or
unrelated metadata is included.

The component identities above are machine-pinned registry documents. The
six-field carrier and its hash are coordinator-constructed diagnostic evidence,
not a package expected result; independent Common Lisp reconstruction remains
PENDING.

Under the prose sequence, represented loss precedes both trust and freshness.
Under the registry sequence, freshness precedes represented loss and the
separate trust step. The registry's target-kind disposition
`direct-if-trusted-principal` introduces a third uncertainty: the machine
record does not say whether that condition is evaluated during `target-kind`
or during `inherited-or-external-treatment`.

A preliminary, non-commit-bound Python review snapshot returned `reject-stale`
for the corresponding argument tuple because it evaluated freshness first.
The Common Lisp snapshot inspected at the same review point had no combined-
case fixture surface. Successor verification is PENDING; neither preliminary
observation resolves the normative conflict.

## Conflict 2: external-principal decision Identifier

Package-spec §8.1 lists:

```text
reject-untrusted-external-principal
```

The canonical Policy-A and Policy-B decision vocabularies instead list the
registered Identifier:

```text
reject-external-principal
```

| Candidate Identifier document | Bytes | SHA-256 | Standing |
| --- | ---: | --- | --- |
| prose spelling `reject-untrusted-external-principal` | 91 | `0200287fd1dcccc9ddec7ee798afdd0d092cb94f38ebc11d7e007dc5eec4bc7d` | named by prose; absent from registry definitions |
| registry `admissibility-decision-code.reject-external-principal` | 81 | `84da031f081df165220acdbc1805377689c092a08cddc75c70e9a8336116d0d0` | canonical registry definition |

No shared vector selects between these Identifiers for an untrusted external
principal.

## Conflict 3: closed-set refusal tuple

The package authorizes only Policy-A and Policy-B. A retained Policy-C carrier
therefore must not be evaluated as either policy, but neither the registry nor
the vectors pins an exact `LCIFailure/0` document for that refusal. The baseline
Common Lisp seed returned the unregistered code `UnsupportedFixturePolicy`;
the Python seed incorrectly fell through to Policy-B. The former is not a
normative oracle and the latter is a dispatch defect.

Successors therefore report this one hostile request as a non-LCI
`fixture-authority-gap`, with no category/code/stage/path claim, until authorial
closure supplies an exact tuple. It is executed and counted as blocked—not
passed, skipped, or N/A.

## Requested authorial closure

Please publish, with replacement artifact hashes:

1. one exact total Policy-A/Policy-B evaluation sequence, including where
   boundary coherence, trust-conditioned target-kind disposition, scope
   narrowing, loss, and freshness are evaluated;
2. an exact decision result for the six-coordinate witness above;
3. the one authorized external-principal rejection Identifier;
4. exact decision records for at least every pairwise and one all-at-once
   combination of stale, represented-loss, and trust failure; and
5. a statement of whether the policy registry records or §8.1 prose are being
   corrected; and
6. the exact unknown-policy refusal document, or an explicit statement that
   closed-set rejection is intentionally outside `LCIFailure/0`.

Until closure, the combined path and untrusted-principal decision spelling are
BLOCKED. Existing vectors whose inputs activate only one pinned branch remain
executable; this packet does not add an implementation-local expected result.
