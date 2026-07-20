# SS-0 scenario corpus (frozen with the substrate)

The harness invokes your runner as `<entry> <run-dir>/ <scenario> <killpoint-or-empty>`.
Where a killpoint is given, your runner must call the substrate `window(run-dir, killpoint)`
helper at the exact moment described below; the harness delivers a real `SIGKILL` inside
that window. Window calls and torn-write injections are death instrumentation (markable
`@harness`); everything else is production code.

| Scenario | Kind | Killpoint | Your runner must… |
|---|---|---|---|
| `S1-clean` | effect | — | run one complete effect operation end-to-end (dispatch an `effect:<label>` via the provider; record whatever your design records; exit 0). |
| `S2-pre-record` | effect | `pre-record` | call the window **after any process-level start/setup records you keep, before any record describing the operation** exists. |
| `S3-mid-record` | effect | `mid-record` | write the operation's first record **torn** (use `store-append-torn`, fraction 0.5), then call the window. |
| `S4-post-dispatch` | effect | `post-dispatch` | make whatever records your design makes before dispatch, dispatch `effect:<label>` (provider executes), then call the window **before any record of the outcome** is written. |
| `S5-unfsynced-outcome` | effect | `unfsynced-outcome` | record the outcome with `durable? = false` (written, flushed, **not fsynced**), then call the window **before any completion/confirmation record**. |
| `S6-mid-stream` | stream | `mid-stream` | dispatch `slow:3`; record chunk 1 completely (durable); write chunk 2's record **torn** (fraction 0.5); call the window. Chunk 3 never happens. |
| `S7-refused-unrecorded` | refused | `refused-unrecorded` | make your pre-dispatch records, dispatch `effect-ne:<label>` (provider durably refuses and issues its receipt), then call the window **before any record of the response**. |

Recovery invocations (cold, fresh process, reads only surviving bytes): your deliverable
must expose modes covering the brief's obligations — at minimum: report recovery state
(R1/R2/R6/R9); attempt re-dispatch of an unresolved operation (must refuse, R3); admit a
provider receipt as evidence and proceed lawfully (R4); proceed via an explicit distinct
successor (R5). Exact mode names are yours; document them in your README.

Effect labels: use at least three distinct labels across your corpus runs (e.g. your
choice of `bank-write`, `mint`, `notify` — labels are data). Payload regimes: exercise
`complete:<text>`, `empty`, and `invalid` in at least one scenario family.
