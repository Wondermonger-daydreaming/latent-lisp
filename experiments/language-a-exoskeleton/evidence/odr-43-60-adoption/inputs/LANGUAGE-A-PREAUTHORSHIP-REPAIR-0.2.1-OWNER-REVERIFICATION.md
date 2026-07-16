# LANGUAGE-A PRE-AUTHORSHIP REPAIR 0.2.1 — TARGETED OWNER RE-VERIFICATION

**Artifact:** `LANGUAGE-A-PREAUTHORSHIP-REPAIR-0.2.1-OWNER-REVERIFICATION.md`  
**Review date:** 2026-07-16  
**Review role:** targeted owner-side re-verifier of R2-PV-02A, R2-PV-03A, preservation of prior PV closures, and FI-01/FI-05 Phase A closure  
**Review boundary:** read-only inspection and network-off execution against the supplied committed-tree delivery; no ODR adoption, substantive item authorship, private-key authorship, packet freeze, target scoring, live exposure, or repository modification  
**Primary disposition:** **PASS — FI-01 AND FI-05 CLOSED**

Repair 0.2.1 closes the two remaining executable FI-01 bypasses identified in the Repair 0.2 re-verification:

1. the ODR-43 adoption contract now requires the exact three-class exposure set; and
2. every freezer decision now resolves and item-binds its freezer-only dossier before a higher-state graph or key-author handoff can validate.

The prior PV closures remain intact, all `111` declared mutations executed and were killed, and the real ODR-43 and ODR-60 records remain unresolved.

This PASS is bounded to the pre-authorship FI-01/FI-05 gate. It does not authorize Tranche B, real item drafting, private-key work, freeze, scoring, provider calls, or exposure.

---

## 1. CUSTODY RESULT

**Custody passed.**

### 1.1 Outer delivery

| Object | Independently verified result |
|---|---|
| ZIP filename | `latent-lisp-language-a-preauthorship-repair-0.2.1-review.zip` |
| ZIP bytes | `515287071` |
| ZIP SHA-256 | `328b5961dd9e433516fb3f885e5f25020c0bdca2a2d5c9c1e6c9684195a27544` |
| ZIP entries | exactly `8`: one package-root directory and seven files |
| Sidecar bytes | `127` |
| Sidecar SHA-256 | `dae349ecbd61b7831f10466a464af46ac917f7e2eaa2b03fa1b4ef3faca7ea6a` |
| Sidecar content | exact ZIP digest and filename |
| Sidecar terminator | exactly one final LF |
| ZIP integrity | passed |
| Duplicate/path-traversal safety | passed |
| Internal checksums | `6/6` passed |

The exact package root is:

```text
latent-lisp-language-a-preauthorship-repair-0.2.1-review/
```

The seven file members are:

```text
MEMBER-INVENTORY.json
IDENTITIES.json
SNAPSHOT-TREE-CORRESPONDENCE.json
SHA256SUMS
BUNDLE-REFS.txt
latent-lisp-language-a-preauthorship-repair-0.2.1.bundle
latent-lisp-language-a-preauthorship-repair-0.2.1-snapshot.tar
```

### 1.2 Snapshot

| Property | Independently verified result |
|---|---|
| Snapshot bytes | `630190080` |
| Snapshot SHA-256 | `22038ca0567ba04f498ad568035e3453dfd18e729779a8def20210d562e1ff36` |
| Committed paths | `1683` |
| Executable blobs | `43` |
| Non-executable blobs | `1640` |
| Path-set correspondence | passed |
| Byte-for-byte correspondence | passed |
| Executable-bit correspondence | passed |
| Recomputed tree | `645c1b8a778dd30b0a640e88b9fcca2281ec1c06` |

The snapshot was generated from the exact Git commit object rather than copied from the owner working directory.

### 1.3 Git bundle and ancestry

| Property | Independently verified result |
|---|---|
| Bundle bytes | `276607101` |
| Bundle SHA-256 | `f25fb30c6bebf773f0d72c9d267ea759e77ca755f5605a5b26fb767842fdbfc2` |
| Bundle verification | passed |
| History | complete |
| Repair 0.2.1 commit | `18189fcde68dfc110c0e95a82d2a9ef220bc98e9` |
| Repair 0.2.1 tree | `645c1b8a778dd30b0a640e88b9fcca2281ec1c06` |
| Repair 0.2 base commit | `bcf76e78e597351e088a2fcec646230fa1deca60` |
| Repair 0.2 base tree | `9fd259ee678f338e4910d1fd68d5c2042c46e992` |
| Base ancestry | base is an ancestor |
| Merge base | exact Repair 0.2 base |
| Protected-scope diff | empty |

The bundle contains exactly the commissioned successor and base refs:

```text
18189fcde68dfc110c0e95a82d2a9ef220bc98e9
    refs/heads/codex/language-a-emission-pilot-preauthorship-repair-0.2.1

bcf76e78e597351e088a2fcec646230fa1deca60
    refs/remotes/origin/codex/language-a-emission-pilot-preauthorship-repair-0.2
```

### 1.4 Review-input identity

The tracked Repair 0.2 owner re-verification input verifies exactly:

```text
LANGUAGE-A-PREAUTHORSHIP-REPAIR-0.2-OWNER-REVERIFICATION.md
bytes:   16003
sha256:  4bff9ee0e00908e6e93694751256480ed6db09975431fd66053afa2c70d1211c
```

---

## 2. INDEPENDENT EXECUTION

The repair was exercised from an isolated checkout imported from the verified bundle.

### 2.1 Targeted suite and verification

| Check | Result |
|---|---|
| `tests/test_preauthorship.py` | `14/14` passed in the review environment |
| `preauthorship.py verify`, fresh run 1 | passed |
| `preauthorship.py verify`, fresh run 2 | passed |
| Fresh verification byte identity | the two outputs matched |
| Schema surfaces | `25` |
| Mutation declarations | `111` |
| Mutation executions | `111` |
| Mutations killed | `111` |
| `declared_unexecuted` | empty |
| `undeclared_executed` | empty |
| Fresh mutation result set | exactly matched committed evidence |
| ODR-43 real state | unresolved |
| ODR-60 real state | unresolved |
| Substantive drafting gate | blocked pending owner adoption |

Review environment:

```text
CPython 3.13.5
jsonschema 4.26.0
Linux x86_64 sandbox
```

The committed builder records accurately limit their own portability claim to one environment:

```text
CPython 3.11.14
jsonschema 4.26.0
Linux WSL2 x86_64
scope: single-environment-only
```

### 2.2 Direct valid controls

The following complete synthetic controls passed:

```text
complete ODR-43 + ODR-60 adoption graph
    drafting_gate(...) → True

complete frozen item/source/rendering/dossier transition graph
    validate_record_graph(..., allow_synthetic=True) → accepted

complete minimized KEY-AUTHOR-INPUT
    validate_key_author_input(...) → True
```

These controls alter no real owner record and remain permanently tainted synthetic material.

---

## 3. R2-PV-02A — EXACT ODR-43 EXPOSURE-CLASS SET

# CLOSED

The implemented contract now enforces the semantic equality:

```text
observed exposure classes
=
{
  item-specific-answer,
  private-key,
  target-output
}
```

Enforcement exists at both layers:

1. the strict JSON Schema requires exactly one occurrence of each class through `contains`, `minContains: 1`, and `maxContains: 1`; and
2. `validate_odr43_exposure_class_set` independently checks list length, uniqueness, and exact set equality before graph closure or `drafting_gate`.

Each declaration’s event is also checked for:

- resolved event digest;
- `prior-exposure` event type;
- matching actor;
- `exposure-declared` action;
- bounded standing;
- a claim matching the declared exposure class.

### 3.1 Independent escaped-witness replay

The previous escaped witness was independently reconstructed:

```text
three item-specific-answer declarations
zero private-key declarations
zero target-output declarations
```

After dependent adoption-event and record digests were recomputed, the observed result was:

```text
drafting_gate(...) 
→ ODR43ExposureClassSetInvalid
```

### 3.2 Missing-class probes

Each of the following was independently rejected with the same typed condition:

```text
missing item-specific-answer
missing private-key
missing target-output
```

### 3.3 Mutation evidence

All four permanent mutations executed and were killed:

```text
mutation:r2-pv-02a-duplicate-exposure-class
mutation:r2-pv-02a-missing-item-specific-answer
mutation:r2-pv-02a-missing-private-key
mutation:r2-pv-02a-missing-target-output
```

The repair chooses no real actors and does not adopt ODR-43.

---

## 4. R2-PV-03A — FREEZER-DOSSIER GRAPH CLOSURE

# CLOSED

Every freezer decision now resolves its `dossier` reference as:

```text
lae-item-freezer-dossier/1.0.0
```

The validator requires the dossier to:

- exist in the complete freezer-side graph;
- match the exact record ID and digest in the freezer decision;
- validate under its strict schema;
- bind the exact predecessor item record;
- match the item ID and task digest;
- match the item state and state version;
- bind the same source manifest;
- bind the same rendering set digest;
- remain `freezer-only`.

Dossier validation is invoked for every freezer decision before state-transition closure. Synthetic mode follows the same path and does not bypass the dossier requirement.

The dossier remains excluded from `KEY-AUTHOR-INPUT`. The key-author handoff validator continues to require exact equality with the authorized minimized set and rejects freezer-only dossier content.

### 4.1 Independent escaped-witness replay

The previous escaped witness was independently reconstructed:

```text
valid frozen synthetic bank
complete minimized KEY-AUTHOR-INPUT
freezer decision retains dossier reference
all item-freezer-dossier records removed
```

Observed result:

```text
validate_record_graph(..., allow_synthetic=True)
→ FreezerDossierReferenceInvalid
```

The graph now fails before the key-author handoff can be accepted.

### 4.2 Additional independent probes

The following were independently rejected:

```text
dossier reference resolves to wrong record kind
dossier names a different item
dossier carries the wrong item-state version
dossier carries the wrong rendering-set digest
```

The valid complete frozen graph and valid minimized handoff still pass.

### 4.3 Mutation evidence

All eight permanent mutations executed and were killed:

```text
mutation:r2-pv-03a-missing-freezer-dossier
mutation:r2-pv-03a-dangling-freezer-dossier-reference
mutation:r2-pv-03a-wrong-freezer-dossier-digest
mutation:r2-pv-03a-dossier-for-different-item
mutation:r2-pv-03a-dossier-version-mismatch
mutation:r2-pv-03a-wrong-record-kind
mutation:r2-pv-03a-inconsistent-source-parent
mutation:r2-pv-03a-inconsistent-rendering-parent
```

---

## 5. PRESERVATION OF PRIOR CLOSURES

### PV-01 — ODR-60 allocation algebra

**Closed and preserved.**

The allocation remains:

- 24 typed rows;
- six per family;
- exactly one content family per row;
- exactly one answerability role per row;
- eight positive, eight insufficiency, and eight mixed-control rows;
- derived, unstored totals;
- exact SHAM, trap, strong-control, easy-control, and domain-native constraints.

### PV-02 — append-only owner adoption

**Closed for the commissioned Phase A contract.**

The exact exposure-class omission bypass is now closed in addition to the already repaired successor-ID, predecessor-digest, adoption-event, actor, read, exposure, shared-root, and gate-closure rules.

### PV-03 — evidence-bearing higher states

**Closed for the commissioned Phase A contract.**

Higher states require evidence-bearing transitions, and the freezer decision’s dossier reference now closes as part of that transition evidence.

### PV-04 — minimized and complete `KEY-AUTHOR-INPUT`

**Closed and preserved.**

An independently created handoff missing its frozen rendering was rejected by exact authorized-set equality. The freezer dossier remains forbidden from the handoff.

### PV-05 — nonempty byte-bound transmission

**Closed within the Phase A targeted scope and preserved.**

The 2.0 transmission/handoff record law remains nonvacuous and byte-bound; the prior empty-event specimen remains killed. The separately noted future question about whether an acknowledgment must be recipient-authored and artifact-bound remains nonblocking and is not silently implemented here.

---

## 6. MUTATION REGISTRY SUCCESSION

The mutation registry succession is coherent:

```text
predecessor IDs preserved
predecessor order preserved
new mutation IDs appended
predecessor registry digest bound
successor registry digest recorded
```

Fresh execution produced:

```text
declared:             111
executed:             111
killed:               111
declared_unexecuted:  []
undeclared_executed:  []
```

The fresh result list exactly matched the committed `MUTATION-RESULTS.json` evidence.

---

## 7. BOUNDARY AND AUTHORITY RESULT

The tracked boundary census and repository inspection establish:

```text
real item content:        0
real source content:      0
private-key content:      0
scoring implemented:      false
provider calls:           0
target outputs:           0
packet freeze authority:  absent
live exposure authority:  absent
```

The real owner decisions remain:

```text
ODR-43 UNRESOLVED
ODR-60 UNRESOLVED
```

This review does not adopt them.

### 7.1 What this PASS authorizes

This PASS closes the independent-review dependency before the owner may adopt or return ODR-43 and ODR-60.

It authorizes no substantive item work by itself.

The next lawful owner acts are:

```text
adopt or return ODR-43
adopt or return ODR-60
```

Only after both are validly adopted may reversible, firewalled substantive item drafting begin.

### 7.2 What remains unauthorized

```text
SUBSTANTIVE ITEM AUTHORSHIP NOT YET AUTHORIZED
PRIVATE KEY AUTHORSHIP NOT AUTHORIZED
PACKET FREEZE NOT AUTHORIZED
TARGET SCORING NOT AUTHORIZED
LIVE EXPOSURE NOT AUTHORIZED
```

Tranche B remains the next freeze-quality implementation tranche after the relevant owner adoptions; it does not inherit authorization from this PASS.

---

# PRIMARY DISPOSITION

# PASS — FI-01 AND FI-05 CLOSED

The repair chain has now done what Phase A required:

- strict item/source/rendering and handoff schemas exist;
- owner decisions cannot be adopted by cosmetic mutation;
- ODR-43’s three disclosure classes cannot collapse into duplicate rows;
- ODR-60’s candidate allocation is item-level and jointly satisfiable;
- freezer acceptance and frozen state are evidence-bearing;
- freezer decisions cannot cite nonexistent or mismatched dossiers;
- key-author handoff is minimized and complete;
- transmission events cannot pass vacuously empty;
- mutation execution is itself closed against skipped or undeclared cases;
- no real content, key, scoring, provider, or exposure authority was created.

FI-01 and FI-05 are therefore closed within the pre-authorship Phase A scope.

---

## MACHINE-READABLE CLOSE

```lisp
(:language-a-preauthorship-repair-0.2.1-owner-reverification
 :review-date "2026-07-16"
 :delivery-custody :pass
 :zip
 (:bytes 515287071
  :entries 8
  :sha256 "328b5961dd9e433516fb3f885e5f25020c0bdca2a2d5c9c1e6c9684195a27544")
 :sidecar
 (:bytes 127
  :sha256 "dae349ecbd61b7831f10466a464af46ac917f7e2eaa2b03fa1b4ef3faca7ea6a"
  :final-lf :exactly-one)
 :snapshot
 (:bytes 630190080
  :sha256 "22038ca0567ba04f498ad568035e3453dfd18e729779a8def20210d562e1ff36"
  :committed-paths 1683
  :tree-correspondence :pass
  :tree "645c1b8a778dd30b0a640e88b9fcca2281ec1c06")
 :bundle
 (:bytes 276607101
  :sha256 "f25fb30c6bebf773f0d72c9d267ea759e77ca755f5605a5b26fb767842fdbfc2"
  :history :complete)
 :repair
 (:commit "18189fcde68dfc110c0e95a82d2a9ef220bc98e9"
  :tree "645c1b8a778dd30b0a640e88b9fcca2281ec1c06"
  :base "bcf76e78e597351e088a2fcec646230fa1deca60"
  :protected-scope-diff :empty)
 :independent-execution
 (:preauthorship-tests "14/14"
  :schema-count 25
  :declared-mutations 111
  :executed-mutations 111
  :killed-mutations 111
  :declared-unexecuted ()
  :undeclared-executed ())
 :r2-pv-02a :closed
 :r2-pv-03a :closed
 :pv-01 :closed
 :pv-02 :closed
 :pv-03 :closed
 :pv-04 :closed
 :pv-05 :closed-within-phase-a-scope
 :fi-01 :closed
 :fi-05 :closed
 :odr-43 :not-adopted
 :odr-60 :not-adopted
 :substantive-item-authorship :not-yet-authorized
 :private-key-authorship :not-authorized
 :packet-freeze :not-authorized
 :target-scoring :not-authorized
 :live-exposure :not-authorized
 :primary-disposition :pass-fi-01-and-fi-05-closed)
```
