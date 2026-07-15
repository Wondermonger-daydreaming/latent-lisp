# LCI/0 algebraic-law audit harness

This directory is audit infrastructure only. It does not alter relation,
matching, policy, validation, fixture, vector, or CD/0 behavior. The frozen
Errata 0.1 design packet remains an external checksum-bound input.

Run from a clean repository root after materializing the tracked fixture
package and overlay:

```sh
python3 mneme/lci0/shared/fixture_package.py materialize \
  --destination /tmp/lci0-seed-fixtures-20260714
python3 mneme/lci0/shared/fixture_package.py materialize-overlay \
  --fixture-root /tmp/lci0-seed-fixtures-20260714

PYTHONPATH=mneme/lci0/python:canonical-datum/python \
python3 mneme/lci0/audit/law_audit.py run \
  --packet-zip /path/to/LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip \
  --packet-sidecar /path/to/LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip.sha256 \
  --packet-dir /path/to/verified/extracted-packet \
  --evidence-dir /tmp/lci0-law-audit-evidence
```

The Python and Common Lisp runners independently construct and validate the
36-value temporal and 13-value scope domains, then execute their native public
operations. The neutral comparator consumes JSONL records only. A law failure
produces a minimized, non-repair-authorized witness; it never changes production
semantics.
