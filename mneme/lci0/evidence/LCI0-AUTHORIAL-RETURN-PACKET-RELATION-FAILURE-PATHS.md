# LCI/0 Authorial Return Packet — unpinned relation failure paths

Date: 2026-07-14

Status: relation values determinate; 38 companion failure paths blocked

## Scope

This packet concerns only the structural `path` component of typed failures
returned while exhaustively executing the supplementary scope and temporal
relation tables. The 458 machine-pinned relation values are not disputed. It
does not reopen CD/0, ClaimId, WarrantTarget, policy, migration, standing, or
warrant semantics.

## Smallest witnesses

| Witness | Pinned relation | Bytes | SHA-256 |
|---|---:|---:|---|
| `scope_relation_table_0:012`, `scope.universal` → `scope.second.alpha` | `incompatible` | 2,150 | `231df2f95d453fea0e78d2895be3f20eea838721b650f31337b4859afe5faa81` |
| `temporal_relation_table_0:032`, `subject-time.instant-0` → `subject-time.symbolic-unknown` | `unknown` | 2,239 | `da2c702bbb80eccd7b7b0f39d9627dee71be815536be5b1e10a72bafb9f49205` |

For the first witness, both implementations return
`relation-undetermined/ScopeIncompatible/target-relation`; Common Lisp reports
`right`, while Python reports `right/calculus`. For the second, both return
`relation-undetermined/AdmissibilityUndetermined/subject-time`; Common Lisp
reports `left`, while Python reports `right`.

The same disagreement covers 24 cross-calculus orientations and 14 temporal
symbolic-right orientations, for 38 observations in total. Neither
implementation is an oracle.

## Why authorial closure is required

The relation-table entries pin the normalized relation value but do not carry
companion failure documents. Errata E6 pins deterministic validation order,
and selected vectors pin paths for selected orientations, but the package does
not state whether the failure path must identify the comparison operand, the
nested unsupported coordinate, or a fixed semantic side for every unvectored
orientation.

The implementations therefore agree on every affected machine-pinned relation
value while differing on an unpinned observable required by differential
failure comparison. Silently copying either path would make an implementation
the authority.

## Requested closure

The authorial response should provide exact category, code, stage, and path
documents for both orientations of each F-valued relation family, including:

- whether cross-calculus incompatibility points to the operand or its
  `calculus` coordinate;
- whether a symbolic temporal comparison points to the symbolic operand or a
  fixed algorithm argument;
- the governing depth-first/cross-field ordering rule; and
- replacement or additional machine-fixture hashes and permanent regression
  IDs.

Until then, the 458 relation values remain testable and determinate, while
these 38 companion paths are blocked rather than passed, failed, skipped, or
N/A.
