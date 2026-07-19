# AP0 L17 Route Audit

| Operation | Lawful supported route actions | Supported bypass actions | Verdict |
|---|---:|---:|---|
| invoke fake adapter | 1 composite public action | none | PASS |
| stream fake adapter | 1 composite public action | none | PASS |
| cancel fake request | 1 public action | none | PASS |
| reconcile fake request | 1 public action | none | PASS |

Raw host calls are explicitly unsafe and outside AP0 conformance; they are not supported bypasses.
