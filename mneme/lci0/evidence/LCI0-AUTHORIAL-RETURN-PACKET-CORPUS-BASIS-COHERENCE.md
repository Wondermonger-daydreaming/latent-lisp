# LCI/0 Authorial Return — CorpusBasis Cross-Field Coherence Failure

Date: 2026-07-14

Status: PROVISIONAL AUTHORIAL RETURN / EXACT FAILURE TUPLE BLOCKED

## Governing material

Fixture Package §4.2 says mixed corpus revisions are refused. Errata I12/E6
requires named cross-field checks to run last in declared order. Registry
schema `closed-schema.corpus-basis.0` names this exact order:

```text
mode-shape-exact
revision-belongs-to-corpus
slice-boundary-coherent
```

The schema definition is 2,430 canonical bytes with SHA-256
`189fbb4a81de03cd4836a36b826557d547a5bef081a6b550ccefc5c7f24c627a`.
Its validation rule says the listed checks run in order, but neither the
schema, relation tables, nor vectors provide a category/code/stage/path record
for a `slice-boundary-coherent` rejection.

## Smallest retained witness

Start with the valid registered corpus basis
`claim-basis.alpha-r3-all-manifest3` and replace only its
`semantic-boundary` with the valid registered
`semantic-boundary.manifest-alpha-4`:

| Document | Bytes | SHA-256 |
| --- | ---: | --- |
| original alpha-r3 basis | 4,005 | `3df44078a4691f8ad2665cb14e67d45622970c241ac1478e2181cb219dbb4600` |
| replacement alpha-r4 semantic boundary | 1,601 | `97b504d0a20e6fa9e75c9b0b6de0a400d8e9640c0cd729386ed4d7e84f47d285` |
| combined r3/r4 witness | 4,005 | `7c92ea0639c7de40dbed630587b9ecbf1ce36e374bb66db966d6536aa1c1a0be` |

The resulting datum retains the logical alpha corpus, immutable revision 3,
and all-members slice, but names immutable manifest alpha/4 as its semantic
boundary. It changes one already typed field and introduces no malformed
nested datum or unknown field.

The original basis and replacement-boundary identities are machine-pinned.
The combined hash is coordinator-constructed by one field replacement and
frozen CD/0 re-encoding; independent Common Lisp reconstruction remains
PENDING and the mutation is not an implementation-local expected result.

## Observed implementation standing

- The Common Lisp validator snapshot inspected during preliminary review
  recursively validated the seven fields but did not execute any of the three
  named cross-field checks; static inspection showed an acceptance path.
- The Python validator snapshot at that review point was executed against the
  witness and returned it as valid; it likewise lacked the named coherence
  check.

These are non-commit-bound defect observations, not successor results. Both
successor implementations and their final differential result remain PENDING.

Acceptance is an implementation defect because the frozen prose and schema
clearly require rejection of mixed revision material. But choosing a precise
LCIFailure is not an implementation repair: the package does not pin whether
this case is `InvalidBasis`, `BasisMismatch`, another authorized code, what
stage owns it, or whether the structural path ends at `revision`,
`semantic-boundary`, or a nested manifest coordinate.

The same distinction applies to `revision-belongs-to-corpus`: rejection is
required, while its complete failure tuple is not machine-pinned.

## Requested authorial closure

Please provide:

1. executable definitions for all three named CorpusBasis cross-field checks;
2. the exact category, code, stage, structural path, and closed context for the
   r3/r4 witness above;
3. the exact tuple for a logical-corpus/immutable-revision mismatch; and
4. permanent positive and negative vectors for both orientations and each
   semantic-boundary form.

Implementations may add a fail-closed rejection without accepting the witness,
but the exact result-document comparison for this novel path remains BLOCKED
until authorial closure. Valid registered CorpusBasis fixtures remain
unaffected.

## 2026-07-14 successor execution note

The final successor unit census retained the novel CorpusBasis coherence
witness as blocked while passing the independently pinned corpus/revision
coherence tests. The exact 215-vector and 458-relation fixture paths showed no
new implementation-owned mismatch. No local result tuple was promoted to
normative standing.
