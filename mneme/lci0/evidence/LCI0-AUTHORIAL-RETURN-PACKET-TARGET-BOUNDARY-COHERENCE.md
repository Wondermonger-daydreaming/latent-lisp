# LCI/0 Authorial Return — Kind-Specific Target Boundary Coherence

Date: 2026-07-14

Status: PROVISIONAL AUTHORIAL RETURN / UNVECTORED MISMATCH SEMANTICS BLOCKED

## Governing obligation

Fixture Package §7.1 step 6 requires kind-specific
procedure/model/artifact/corpus/premise/translation/policy coherence before
ClaimId coordinate and scope comparison. Each target-schema record supplies
field order/types, failure vocabulary, and an exact Identifier of the form
`target-boundary-algorithm/<kind>/0`.

Those Identifiers are references only. The registry contains no executable
algorithm definition, comparison table, event input, or path-selection rule
behind them:

| Kind | Schema-definition bytes | SHA-256 |
| --- | ---: | --- |
| observed | 5,519 | `612ceeba0eadece5902ad0f1a13ec105b41c9e73e29153db214e1659f958fb9c` |
| executed | 5,885 | `db6437d2f5567dc67f53a5cf32381d039629796f149ede3a7d632c35baaf934f` |
| tested | 6,341 | `1fe9d0885ad77ca42c4241ce9e3364118a608a88ef9a2bcfbb974f4b5cf12af2` |
| derived | 5,328 | `26183b6182934746bee43c95e372f0465c1a79e016f60caf925072bfc68ade1a` |
| externally-attested | 5,303 | `3a2af4034860fe22c9fdb0153083062e32b1d0f86e62c7f439f3a40d24f6a17c` |
| replayed | 6,072 | `58be784864e1a10e8c11c6cca7d72ad2cdc3da7ffd28f58fd992db4fb2193b28` |
| corpus-completion | 6,384 | `cefb13af591a79a7460ce408b9f3c1dcd4ba7e54f3da7e7b93c92d6fcb492233` |
| reported | 5,298 | `9a8193649a3a379dcfe3bdf19706eb60790f702e9c5b5b74bbdb526c530addf0` |
| inherited | 5,588 | `bbd9f5f4265a8bbe107e0d590e0a16ff4fddc2637fc82808ae0b4b459b173127` |
| translated | 5,825 | `5724ed3c1aed3dd96f8bd874c6a3450131e8a357888fe447a25fea3f10f5bd6a` |
| policy-evaluation | 5,708 | `8f57f604343949c7676f1b13ebdeabe2690847957d56a7c88aff62beb5e45b54` |

For each kind, the package supplies one exact positive and one
first-boundary-field-missing negative. Those 22 vectors establish shape and one
success point; they do not define mismatch semantics for the remaining field
combinations.

## Minimal premise-coherence ambiguity witness

Start with `warrant-target.derived.one-equals-one` (20,236 bytes, SHA-256
`9443e3f38f8ca26f30b9e5afb5f14082a5243793a9d5be7aeeabc599479b07a8`)
and replace only its one validated `premise-claim-ids` member with the distinct
validated `claim-id.file-alpha-neutral`. The resulting target is 20,341 bytes,
SHA-256
`d0baf4a9470db970e014b707509d79e1c25581b320c100fda1ee66a5f6218b0b`.

The source target, replacement ClaimId, and `PremiseMismatch` Identifier are
machine-pinned. The mutated target hash is coordinator-constructed by one field
replacement and frozen CD/0 re-encoding; independent Common Lisp
reconstruction remains PENDING and it is not a package expected result.

The derived schema includes `PremiseMismatch` (the Identifier document is 48
bytes, SHA-256
`56d89f3e06b519cab3df3b11c3e311b506e1de2415ea8fa3e7bff63dfa6a6e90`),
but the operation carries no independent derivation-event premise set and the
opaque algorithm reference supplies no comparison rule. Therefore the package
does not determine whether this particular target is incoherent, much less its
exact failure path. Fixture names or display labels cannot supply that rule.

## Preliminary implementation finding

A preliminary, non-commit-bound Python review snapshot contained no kind-
specific coherence implementation for observed, tested, derived, externally-
attested, replayed, reported, or inherited targets, and no path that produced
`PremiseMismatch`. Its executed, corpus-completion, translated, and policy-
evaluation checks were partial. Both committed successors require exhaustive
verification; no final language result is claimed here.

Missing enforcement of an explicit comparison already pinned by a vector or
an obvious exact type/schema relation is an implementation defect. Inventing
unvectored event semantics, pairings, or failure paths is prohibited. The
official positive and first-field-missing vectors remain unaffected.

## Requested authorial closure

Please publish an executable definition for all eleven algorithm Identifiers,
including:

1. the two operands of every comparison and where each is carried in the pure
   operation input;
2. exact comparison order and equality/relation semantics;
3. the exact failure code selected for every mismatch class;
4. deterministic category/stage/path/context documents; and
5. positive and single-defect negative vectors for every coherence rule.

Until closure, hostile unvectored kind-specific mismatch paths are BLOCKED.
Implementations must continue enforcing all independently pinned shape,
type/version, ClaimId-coordinate, scope, and official-vector obligations.
