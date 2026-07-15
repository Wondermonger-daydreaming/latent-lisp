# LCI/0 Authorial Return Packet — N012 universal/symbolic conflict

Date: 2026-07-14

Status: affected path blocked; authorial disposition required

## Scope

This packet concerns only the direct `match-target` path exercised by
`LCI0-N012` when `scope.universal` and `scope.symbolic-unknown` are compared.
It does not reopen ClaimId design, CD/0, target schemas, policy, standing,
warrants, or migration.

## Authority order applied

1. Frozen CD/0 specification and errata for datum behavior.
2. `LOCATED-CLAIM-IDENTITY-SPEC.md`.
3. `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md`.
4. `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md`.
5. Machine registry and vectors.
6. `LCI0-POST-REVIEW-RULING.md`.
7. Fable PASS receipt for implementation authorization and disclosed notes.

The conflict is internal to incorporated LCI/0 machine/prose obligations; no
implementation result is treated as authority.

## Exact witnesses

| Witness | Normative result | Bytes | SHA-256 |
|---|---:|---:|---|
| `scope_relation_table_0`: `scope.universal` → `scope.symbolic-unknown` | `wider` | 2,202 | `0f78c2183b564c8d70b594f3d0cdea2aacd1ea6aa87661b977b47814e919a712` |
| `scope_relation_table_0`: `scope.symbolic-unknown` → `scope.universal` | `narrower` | 2,205 | `1835d1e18a0b620047ba9e684ebb45b4db4494117b7d990da44fc28c4eb2d49b` |
| `LCI0-N012` input | `match-target` witness | 22,369 | `050fb0d6637406dff7c9bfe9070005bb3d25ad6df15ac1b6124b29c4ea2a91a6` |
| `LCI0-N012` expected | `ScopeRelationUnknown` | 502 | `4c69d1ef399987736d84acd4fd159da884ff0260ee1a9fb13b73770588eba746` |

`LOCATED-CLAIM-IDENTITY-SPEC.md` §10.6 dispatches the matcher from the scope
relation. Errata E2 explicitly retains `LCI0-N012` as the direct unknown
relation witness. No incorporated rule states how a direct `wider` result from
the frozen table becomes `ScopeRelationUnknown` at this matcher boundary.

## Implementation observations

- Common Lisp reproduces the N012 expected failure. Its current direct relation
  result for the forward table witness is `unknown`, separately recorded as
  `LCI0-DIV-004`.
- Python reproduces the N012 expected failure and the table's direct `wider`
  relation. Its matcher applies an implementation-local symbolic guard before
  the table result can govern matching.

These observations demonstrate the conflict; neither resolves it.

## Two possible authorial dispositions

1. Preserve both table rows and N012 by normatively adding a narrowly scoped
   matcher-level symbolic guard, with exact ordering and failure semantics.
   This makes direct scope calculus and target matching intentionally distinct
   at this boundary.
2. Preserve relation-driven matcher composition and the existing table rows;
   revise the N012/Errata E2 obligation in a successor normative package to the
   exact result implied by the matcher algorithm, with a replacement direct
   unknown-relation witness.

These are possible dispositions, not recommendations and not implementation
authority. An author may issue a different coherent closure if it updates all
affected normative artifacts explicitly.

## Requested closure

The authorial response should identify:

- which disposition governs;
- exact matcher ordering;
- the resulting category/code/stage/path and context, if F-valued;
- whether either table row or N012 changes in a successor artifact;
- replacement hashes and version consequences;
- permanent regression witnesses.

Until that response is received, report this exact path as blocked. Do not
count it as pass, failure, skip, or N/A. Relative to this packet alone, the
remaining 214 vectors retain their independent standing; across all ten
current packets the unaffected exact-vector ceiling is 211/215. Unaffected
relation-table entries likewise retain their independent standing.

## 2026-07-14 successor execution note

The final exact sweep (`summary.json` SHA-256 `9f870fe9094cab469e2a0876fe04227a1cf720891bfca59cc3a2bc3156340d37`)
again executed N012 in both implementations and retained it as one of exactly
four blocked vector results. It was not counted as pass, failure, skip, or
N/A. The other 211 vector results converged on the machine fixtures. No
authorial response had been received when this note was recorded.
