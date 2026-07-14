# LCI/0 Authorial Return Packet — P029 source artifact

Date: 2026-07-14

Status: affected exact migration-result path blocked; authorial disposition
required

## Scope

This packet concerns only the source-artifact identity of the corpus-revision
right-hand result in `LCI0-P029`. The legacy grammar, proposition, scope, time,
corpus-revision mapping, interpretation frame, ClaimId projection, inertness,
and absence of live warrants remain independently testable. This packet does
not authorize live migration, source lookup, registry lookup, warrant
restoration, or a production identity scheme.

## Exact witnesses

| Witness | Bytes | SHA-256 | Bound source object-id |
|---|---:|---|---|
| Registry `legacy-source.corpus-r4` | 2,836 | `fae0d97d77f291a6cf5fb54be0d48422d656c976e30dcd87d05e903939669632` | `object/artifact/legacy-source/v1/1` |
| Registry `migration-result.corpus-r4` | 26,660 | `001de18804d4826f10106efd9ba0979d372dada832cda854466c2b3681062e19` | `object/artifact/legacy-source/v1/2` in `source` and lineage `source` |
| `LCI0-P029` input | 6,166 | `3dd8e067335f659062ba4d9df3945351be693f4016f27c8366c56c61561e017c` | both `left-source` and `right-source` bind `object/artifact/legacy-source/v1/1` |
| `LCI0-P029` expected result | 54,022 | `de95395165f2e7e170989246caedfe0e278027bc9d90a44a785e18059cf235a7` | left result uses `.../v1/1`; right result and its lineage use `.../v1/2` |

The canonical byte counts and checksums above reproduce the values embedded in
the frozen registry/vector package. The P029 input and expected documents both
round-trip byte-identically through frozen CD/0; this is a semantic
cross-document conflict, not corrupt octets.

## Normative tension

LCI/0 §23.3 requires the migration adapter, in order, to snapshot the exact
source bytes and bind a source artifact reference (step 1), then produce a
migration receipt linking the source artifact and new occurrence (step 13).
It also prohibits current registry lookup or ambient inference to fill identity
fields.

The P029 right input already supplies a closed StableRef source artifact. No
specification, Errata E9, or fixture-package rule found in the reviewed packet
states that corpus revision 4, fixture name `corpus-r4`, or right-hand position
changes that source from fixture revision `v1/1` to `v1/2`. Yet the exact
expected result performs that replacement twice.

## Independent implementation observations

The Common Lisp and Python successors each removed their earlier whole-result
fixture lookup and reconstructed migration results from declared component
mappings. Without reading one another's successor source, both then exposed the
same conflict: preserving the explicit input source produces `.../v1/1` and
first disagrees at
`outputs/right-result/source/material/object-id`. Synthesizing `.../v1/2`
would reproduce the expected bytes only by adding a package-local inference
rule absent from the normative inputs.

Neither implementation is an oracle. The shared observation establishes the
witness; it does not decide the intended revision.

## Requested closure

The authorial response should publish one coherent successor package:

1. correct `legacy-source.corpus-r4` and the P029 right input so that their
   explicit source artifact is `.../v1/2`;
2. revise `migration-result.corpus-r4` and the P029 expected right result so
   that source and lineage preserve the supplied `.../v1/1`; or
3. specify an exact source-rebinding operation, including why it is not an
   ambient/package lookup, which input field selects it, what StableRef
   identifies it, and whether it creates represented loss or an additional
   lineage edge.

The response should include replacement artifact hashes, version consequences,
and a permanent regression vector. Until then, both successors preserve the
explicit source binding, construct zero live warrants, and report the P029
right-result expected-document comparison as blocked rather than passed,
failed, skipped, or N/A.
