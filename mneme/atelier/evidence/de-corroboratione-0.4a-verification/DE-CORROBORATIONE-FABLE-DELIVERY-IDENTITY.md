# FABLE DE-CORROBORATIONE DELIVERY — IDENTITY AND CUSTODY NOTICE

Status: **DELIVERED IMPLEMENTATION CANDIDATE — NOT YET INDEPENDENTLY VERIFIED**

## Frozen authority

The controlling ontology is the ordered pair:

```text
DE-CORROBORATIONE-PROVENANCE-GRAPH-SPEC-DRAFT-0.4.md
bytes: 39307
sha256: f92cd204c3e9b8c981c365162dbf41cd0f731397e5d1d5dbc93cec85ea6fbdf3

AUTHORIAL-ERRATUM-0.4-A.md
bytes: 7182
sha256: 1cf8f10bee8ba7fb5b3610ba57463b7b85c489b9ca83d06836414fc09881b647
```

Erratum 0.4-A has scoped precedence over Draft 0.4.

## Fable-delivered candidate

```text
de-corroboratione.FABLE-DELIVERED.lisp
bytes: 46682
LF lines: 888
sha256: 59786bcc799a4dd5126b21176f0e9db441fb643793a267a33aa4621f8faf9460

de-corroboratione.FABLE-DELIVERED.transcript.txt
bytes: 7240
LF lines: 107
sha256: 6b71939074ae667ea8afaf1c949ed9b5bb6a8e9bfc5a5b7a404abaad8dc716ae
```

These identities exactly match the delivery claims supplied by Fable.

The candidate declares:

```lisp
(:class :interbench-hinge
 :decad-member-p nil
 :placement "mneme/atelier/hinges/"
 :clock-base 41000)
```

The supplied transcript displays all ten exhibits and ends with
`DE CORROBORATIONE complete✓`.

## Evidence standing

The source and transcript identities have been independently recomputed.

This relay environment did **not** contain SBCL, so Fable's claims of exit 0,
real-kernel execution, and byte-identical replay have not been independently
reproduced here. They remain supplied execution evidence that Codex must rerun
under the repository's real kernel.

The Fable-delivered source is preserved byte-for-byte as evidence. Any repaired
successor must retain its exact identity in the implementation ledger and must
not rewrite the delivered input in place.
