## R8 Extension: batch effect type

### New provider tag used

The extension uses the substrate v1.1 metadata-only tag:

```text
batch:<label>:<n>
```

This tag returns a batch descriptor only. It writes no provider world artifact and does not settle any leg. Each leg is dispatched individually via `effect:<label-or-leg-label>` or `effect-ne:<label-or-leg-label>`.

### Durable record design for batches

A batch is recorded as:

1. One batch descriptor record:

```text
t=batch op=<batch-op> label=<label> legs=<n> attempt=<batch-attempt>
```

For explicit batch successors, the batch record also carries:

```text
lineage=batch-successor:re=<legs>:ab=<legs>
pred=<pred-batch-op>
reattempt=<legs>
abandon=<legs>
```

2. Independent per-leg operation records. Leg operation ids are deterministic:

```text
<batch-op>-L1
<batch-op>-L2
<batch-op>-L3
```

Each leg uses the existing record types (`intent`, `dispatch`, `outcome`, `receipt`, `complete`) with additional fields:

```text
batch=<batch-op>
leg=<index>
```

No durable record contains a scalar batch outcome. Batch-level summaries exist only in recovery output and the derived digest.

### Extension scenarios

| Scenario | Behavior |
|---|---|
| E1-clean | Dispatch batch descriptor, then settle legs 1, 2, 3 individually. |
| E2-mid-batch | Settle leg 1 durably; dispatch leg 2 via `effect:`; kill before leg-2 outcome record; leg 3 never dispatched. |
| E3-leg-refused | Settle leg 1 durably; dispatch leg 2 via `effect-ne:`; kill before leg-2 response record; leg 3 never dispatched. |

### Recovery modes with batches

Existing modes remain valid for single operations and individual legs.

```sh
python3 ss0_runner.py <run-dir>/ recover
python3 ss0_runner.py <run-dir>/ redispatch <op-id>
python3 ss0_runner.py <run-dir>/ admit-receipt <op-id>
python3 ss0_runner.py <run-dir>/ succeed <pred-op-id>
```

Batch-specific behavior:

- `recover` reports each leg as its own operation and also reports the batch operation with a derived `legs=` census.
- `redispatch <batch-op>` refuses if any leg is unresolved, executed, completed, or receipt-resolved as executed. The refusal cites the specific leg operation.
- `redispatch <batch-op>-L<i>` applies the original per-operation refusal logic to that leg.
- `admit-receipt <batch-op>-L<i>` admits a receipt for one leg only.
- `admit-receipt <batch-op>` is a convenience that admits available receipts for unresolved legs individually; it never resolves one leg by reference to another.
- `succeed <batch-op>` creates an explicitly distinct successor batch. It records per-leg lineage:
  - `reattempt=<legs>`: legs re-attempted by the successor.
  - `abandon=<legs>`: legs not re-attempted.
  The predecessor batch and predecessor leg standings remain visible.

Default successor policy:

- Legs already executed or completed are abandoned.
- Legs unresolved, not-started, or known not-executed are re-attempted.
- Re-attempted legs receive fresh leg operation ids under the successor batch op and explicit predecessor-leg lineage.

### Canonical digest extension

The digest line format is extended by adding one final field:

```text
<op>|<label>|<state>|<regime>|<payload_crc>|<outcome>|<outcome_durable>|<outcome_payload_crc>|<evidence>|<successor>|<chunks>|<lineage>|<derived>|<legs>
```

The new `<legs>` field is:

- `-` for non-batch operations.
- For batch operations: a comma-separated per-leg census:

```text
1:<state>,2:<state>,3:<state>
```

Example:

```text
1:completed,2:unresolved,3:not-started
```

Both the Python primary implementation and the Common Lisp reader implement this digest extension independently.
