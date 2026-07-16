# LANGUAGE-A PRE-AUTHORSHIP REPAIR 0.2 — TARGETED OWNER RE-VERIFICATION

**Artifact:** `LANGUAGE-A-PREAUTHORSHIP-REPAIR-0.2-OWNER-REVERIFICATION.md`  
**Review date:** 2026-07-16  
**Review role:** targeted owner-side re-verifier of PV-01 through PV-05 and FI-01/FI-05 candidate closure  
**Review boundary:** read-only inspection of the supplied committed-tree delivery; no ODR adoption, no item authorship, no private-key authorship, no packet freeze, no target scoring, no live exposure, no repository modification  
**Primary disposition:** **BLOCK — PRE-AUTHORSHIP REPAIR 0.2 NOT CLOSED**

The repair is authentic, materially stronger than its predecessor, and closes the five originally demonstrated counterexamples at their literal specimen surfaces. It does not yet close FI-01 because two adjacent executable bypasses remain:

1. an adopted ODR-43 payload may repeat one exposure class three times and omit the other two required exposure classes while still opening `drafting_gate`; and
2. a frozen item/source/rendering graph may omit the `ITEM-FREEZER-DOSSIER` referenced by its freezer decision, yet both the frozen record graph and the complete `KEY-AUTHOR-INPUT` validation still pass.

These are not Tranche B requirements. They are direct consequences of the commissioned ODR-43 adoption contract and evidence-bearing freezer transition.

FI-05’s originally demonstrated empty-transmission defect is closed within the targeted scope.

---

## 1. CUSTODY RESULT

**Custody passed.**

### 1.1 Outer delivery

| Object | Verified result |
|---|---|
| ZIP | `latent-lisp-language-a-preauthorship-repair-0.2-review.zip` |
| ZIP bytes | `516468524` |
| ZIP SHA-256 | `90e33350b3bc4a036176b3dd5831decd883364bd394a6934038b2184df48ed37` |
| ZIP members | exactly `7` |
| Sidecar bytes | `125` |
| Sidecar SHA-256 | `b4dc9e63bfb78f3c2990a4261d6b9bac6418578bce07fd5391c54918c53fa288` |
| Sidecar content | exact ZIP digest and filename, followed by one LF |
| ZIP integrity | passed |
| Internal checksums | `6/6` passed |
| Path safety | no absolute path or traversal member |

The ZIP contains one package root and exactly these seven files:

```text
BUNDLE-REFS.txt
IDENTITIES.json
MEMBER-INVENTORY.json
SHA256SUMS
SNAPSHOT-TREE-CORRESPONDENCE.json
latent-lisp-language-a-preauthorship-repair-0.2.bundle
latent-lisp-language-a-preauthorship-repair-0.2-snapshot.tar
```

### 1.2 Snapshot and Git identity

| Property | Verified result |
|---|---|
| Snapshot bytes | `630016000` |
| Snapshot SHA-256 | `c18e4f078ec3933f75bc36f09eb43fc7e5272452770252052317f777ef1a57b7` |
| Committed file paths | `1666` |
| Snapshot correspondence | all paths, bytes, and executable bits matched |
| Independently regenerated `git archive` | byte-identical to supplied snapshot |
| Repair commit | `bcf76e78e597351e088a2fcec646230fa1deca60` |
| Repair tree | `9fd259ee678f338e4910d1fd68d5c2042c46e992` |
| Base commit | `3e6fb3ef3125eee607f8bcf589f0e95108170f57` |
| Base tree | `ddff0d4f499cda4904cd8d0624feb3f8a9f9140f` |
| Merge base | exact base commit |
| Bundle history | complete |
| Changed paths | `35`, all under `experiments/language-a-exoskeleton/` |
| Protected-scope check | empty |

The two previously unresolved owner-decision files are byte-identical Git blobs between the base and Repair 0.2:

```text
operator/owner-decisions/ODR-43.json
operator/owner-decisions/ODR-60.json
```

The commission basis also verifies at its adopted identity:

```text
REPAIR-0.2-COMMISSION-BASIS.md
bytes:   24058
sha256:  ef5366139065c741d9ee4d7bcc02fd426a1cdae7abb7d2fd61b4d27abc0981fa
```

---

## 2. INDEPENDENT EXECUTION

The review independently ran the Repair 0.2 pre-authorship machinery from the isolated bundle checkout.

| Check | Result |
|---|---|
| `tests/test_preauthorship.py` | `11/11` passed |
| `preauthorship.py verify`, fresh run 1 | passed |
| `preauthorship.py verify`, fresh run 2 | passed; output matched run 1 |
| Declared schemas | `25` |
| Declared mutations | `99` |
| Executed mutations | `99` |
| Killed mutations | `99` |
| `declared_unexecuted` | empty |
| `undeclared_executed` | empty |
| Fresh mutation results | exactly matched committed `MUTATION-RESULTS.json` |
| Construction manifest | passed |
| Claim ceiling lint | passed |
| Key-open denial | passed |
| Exposure readiness | correctly refused because owner fields remain unresolved |

The expanded registry preserves all original `45` mutation IDs in order and binds the predecessor registry digest.

### 2.1 Runtime limitations not used as the basis for block

The complete historical `verify-pilot.sh` could not be independently reproduced in this sandbox because:

- SBCL is unavailable, producing the already familiar exit `127` for the protected Mneme/Language-A floors; and
- the predecessor synthetic precision report diverges under Python `3.13.5`, the already named FI-17 runtime/float-serialization defect.

Repair 0.2 correctly records its two builder runs as **single-environment** evidence under Python `3.11.14`, `jsonschema 4.26.0`, rather than claiming portability. Neither limitation is the basis for this disposition.

---

## 3. DIRECT PV DISPOSITIONS

### PV-01 — stale ODR-60 allocation algebra

**Direct specimen: closed.**

Repair 0.2 supplies:

- exactly 24 typed item rows;
- exactly one content family per row;
- exactly one answerability role per row;
- the three answerability roles, including `MIXED-BOUNDED-CONTROL`;
- exact family, role, SHAM, trap, strong-control, easy-control, and domain-native checks;
- derived totals rather than stored totals;
- the owner-supplied candidate witness bound to the adopted commission digest.

The stale aggregate/multi-role witness is rejected.

### PV-02 — in-place owner-adoption bypass

**Original witness closed; the commissioned adoption payload remains incomplete.**

Repair 0.2 now rejects:

- reuse of the unresolved record ID;
- stale predecessor digest;
- missing unresolved predecessor;
- missing owner-adoption event;
- dangling actor, apparatus-read, and exposure-event references.

However, the ODR-43 schema requires three exposure declaration rows but does not require the rows to instantiate the exact three required exposure classes.

The remaining counterexample is recorded in section 4.1.

### PV-03 — self-assertable frozen state

**Original null-decision/status-only witness closed; freezer-decision graph closure remains incomplete.**

Repair 0.2 now requires state-transition records, freezer decisions, authority identities, state versions, exact item/source/rendering digests, transition receipts, and preserved predecessors. Synthetic mode uses the same transition gates.

However, the freezer decision’s required `dossier` reference is never resolved by `validate_record_graph`.

The remaining counterexample is recorded in section 4.2.

### PV-04 — incomplete `KEY-AUTHOR-INPUT`

**Direct specimen: closed.**

The validator now requires exact set equality between the referenced frozen-bank authorized set and the delivered entries. Missing items, renderings, source manifests, source bytes, doctrine, authority identities, custody receipt, wrong cardinality, stale versions, duplicates, and extras are rejected.

The direct partial-handoff witness is killed.

### PV-05 — empty transmission event

**Closed within targeted scope.**

Strict v2 transmission/handoff events require nonempty artifact, basis, input, parent, and claim collections; sender, recipient, authorization basis, byte identity, prior read/creation basis, and acknowledged or typed-pending receipt state. Legacy empty transmission evidence is preserved and explicitly superseded rather than overwritten.

The direct empty-transmission witness is killed.

---

## 4. BLOCKING FINDINGS

### R2-PV-02A — ODR-43 can omit two required exposure classes and still open drafting

**Classification:** blocking before ODR-43 adoption and substantive item authorship  
**Affected surface:** `odr-43-exact-decision`, `validate_odr43_graph`, `drafting_gate`  
**Affected standing:** PV-02 and FI-01 remain open

The commission requires ODR-43 to contain all three distinct disclosure classes:

```text
item-specific-answer exposure
private-key exposure
target-output exposure
```

The schema currently enforces only:

```text
minItems = 3
maxItems = 3
```

It does not enforce the exact set of `exposure_class` values. `validate_odr43_graph` verifies that each supplied event resolves, but it does not verify that the three required classes occur exactly once.

#### Executed counterexample

Starting from the valid synthetic adopted ODR-43/ODR-60 graph, the review replaced the three exposure declarations with three copies of the same valid declaration:

```json
[
  {"exposure_class": "item-specific-answer", "...": "..."},
  {"exposure_class": "item-specific-answer", "...": "..."},
  {"exposure_class": "item-specific-answer", "...": "..."}
]
```

The adoption payload digest and dependent lineage/record digests were recomputed.

Observed result:

```text
drafting_gate(modified_owner_records, valid_lineage) → True
```

The adopted payload therefore omits both `private-key` and `target-output` exposure declarations while unlocking substantive drafting.

#### Smallest repair

In `validate_odr43_graph`, require:

```text
set(exposure_class) ==
{
  item-specific-answer,
  private-key,
  target-output
}
```

and require each class exactly once. Add declared mutations for:

- duplicated exposure class;
- missing private-key class;
- missing target-output class;
- missing item-specific-answer class.

The owner record remains unresolved; this repair chooses no actor and adopts nothing.

---

### R2-PV-03A — a frozen graph and key handoff pass with the freezer dossier absent

**Classification:** blocking FI-01 closure  
**Affected surfaces:** `freezer-decision-record`, `validate_state_transition_graph`, `validate_record_graph`, `validate_key_author_input`  
**Affected standing:** PV-03’s evidence-bearing transition and FI-01 reference closure remain incomplete

Every freezer decision contains a required reference:

```text
dossier → lae-item-freezer-dossier/1.0.0
```

The state-transition validator resolves the decision’s:

- item;
- reviewer authority;
- item/source/rendering predecessors;
- freezer actor and authority.

It does **not** resolve `decision["dossier"]`. No other record-graph pass resolves that field.

#### Executed counterexample

The review constructed the supplied valid synthetic frozen-bank graph, then removed its only `lae-item-freezer-dossier/1.0.0` record without changing the freezer decision that references it.

Observed results:

```text
validate_record_graph(records_without_dossier, allow_synthetic=True)
→ accepted

validate_key_author_input(
    complete_synthetic_key_manifest,
    records_without_dossier,
    allow_synthetic=True
)
→ True
```

Thus the item, source packet, rendering, frozen-bank manifest, and complete minimized key-author handoff all pass while the freezer decision’s evidentiary dossier is dangling.

This does not mean the dossier should be delivered to the key author. It must remain freezer-only. It does mean the freezer-side graph that certifies the transition must prove that the referenced dossier exists at the exact digest.

#### Smallest repair

During freezer-decision/state-transition validation:

```text
resolve_ref(
    decision["dossier"],
    index,
    "lae-item-freezer-dossier/1.0.0"
)
```

and verify that the dossier binds the same item/version under review.

Add declared mutations for:

- missing freezer dossier;
- wrong dossier digest;
- dossier for a different item;
- dossier version inconsistent with the freezer decision.

The key-author delivery set must continue to exclude freezer-only dossier content.

---

## 5. NONBLOCKING REVIEW NOTE

The strict v2 transmission validator accepts an acknowledgment event without checking that its actor is the declared transmission recipient or that the acknowledgment itself binds the transmitted artifacts. The commissioned minimum said “receipt resolves,” which the current implementation satisfies at the event-type/reference level, so this review does not use that narrower semantic question as a blocker.

Before real handoff custody is commissioned, the receipt contract should state whether acknowledgment must be recipient-authored and artifact-bound. That can be settled without reopening the empty-transmission repair.

---

## 6. SMALLEST LAWFUL SUCCESSOR

A bounded Repair 0.2.1 need only:

1. enforce the exact three-class ODR-43 exposure declaration set;
2. resolve and item-bind every freezer decision’s dossier reference;
3. add and execute the corresponding mutations;
4. preserve all 99 existing mutation IDs and results;
5. run two fresh targeted verification passes;
6. commit, push, verify remote commit/tree, clean, and prepare a read-only successor delivery.

It does not require:

- Tranche B;
- real item drafting;
- target-specific source reconnaissance;
- real source packets or renderings;
- private-key content;
- scoring;
- numerical thresholds;
- ODR-43 or ODR-60 adoption;
- provider routes or calls;
- packet freeze;
- target scoring;
- live exposure;
- protected-scope modification.

---

## 7. AUTHORITY STANDING

```text
PV-01 CLOSED
PV-02 OPEN — exact ODR-43 exposure-class set not enforced
PV-03 OPEN — freezer-decision dossier reference not closed
PV-04 CLOSED
PV-05 CLOSED WITHIN TARGETED SCOPE

FI-01 OPEN
FI-05 CLOSED WITHIN TARGETED SCOPE

ODR-43 NOT ADOPTED
ODR-60 NOT ADOPTED
SUBSTANTIVE ITEM AUTHORSHIP NOT AUTHORIZED
PRIVATE KEY AUTHORSHIP NOT AUTHORIZED
PACKET FREEZE NOT AUTHORIZED
TARGET SCORING NOT AUTHORIZED
LIVE EXPOSURE NOT AUTHORIZED
```

---

# PRIMARY DISPOSITION

# BLOCK — PRE-AUTHORSHIP REPAIR 0.2 NOT CLOSED

Repair 0.2 closes the five original specimen failures far more substantially than a label patch: the ODR-60 algebra is item-level, adoption is append-only, state transitions are evidence-bearing, key handoff uses exact-set equality, transmission is nonvacuous, commission custody is pinned, canonicalization is documented, and all 99 declared mutants genuinely execute.

The remaining block is narrow. One owner payload can still omit two mandatory exposure classes, and one freezer transition can still cite a nonexistent dossier. Those two doors must close before FI-01 can authorize owner adoption followed by reversible item drafting.

---

## MACHINE-READABLE CLOSE

```lisp
(:language-a-preauthorship-repair-0.2-owner-reverification
 :review-date "2026-07-16"
 :delivery-custody :pass
 :zip
 (:bytes 516468524
  :members 7
  :sha256 "90e33350b3bc4a036176b3dd5831decd883364bd394a6934038b2184df48ed37")
 :sidecar
 (:bytes 125
  :sha256 "b4dc9e63bfb78f3c2990a4261d6b9bac6418578bce07fd5391c54918c53fa288")
 :snapshot
 (:bytes 630016000
  :sha256 "c18e4f078ec3933f75bc36f09eb43fc7e5272452770252052317f777ef1a57b7"
  :committed-paths 1666
  :independent-git-archive-byte-identity :pass)
 :bundle
 (:sha256 "61d5bc88a900934bfd4c783c27a653ae18e793029795e47fa6982024fc088a3c"
  :history :complete)
 :repair
 (:commit "bcf76e78e597351e088a2fcec646230fa1deca60"
  :tree "9fd259ee678f338e4910d1fd68d5c2042c46e992"
  :base "3e6fb3ef3125eee607f8bcf589f0e95108170f57"
  :protected-scope-diff :empty)
 :independent-targeted-execution
 (:preauthorship-tests "11/11"
  :schema-count 25
  :declared-mutations 99
  :executed-mutations 99
  :killed-mutations 99
  :declared-unexecuted ()
  :undeclared-executed ())
 :pv-01 :closed
 :pv-02 :open-exposure-class-set
 :pv-03 :open-freezer-dossier-reference
 :pv-04 :closed
 :pv-05 :closed-within-targeted-scope
 :fi-01 :open
 :fi-05 :closed-within-targeted-scope
 :odr-43 :not-adopted
 :odr-60 :not-adopted
 :substantive-item-authorship :not-authorized
 :private-key-authorship :not-authorized
 :packet-freeze :not-authorized
 :target-scoring :not-authorized
 :live-exposure :not-authorized
 :primary-disposition :block-preauthorship-repair-0.2-not-closed)
```
