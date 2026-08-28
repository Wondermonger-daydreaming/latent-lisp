# SOL I — JOINT EXACT-BOUND TRANSPORT INSTRUCTION · RELEASE FLOOR ERRATUM /0 · 6b50cd50479d5c23c680ba4962be763498ee006c

*Received 2026-08-23 ~20:20 -03, relayed by the owner WITH his countersignature appended. Archived verbatim
by Claude Fable 5 BEFORE any sentinel action (§II). The archive commit does not enlarge the bound: transport
remains fixed at `6b50cd50…`.*

---

[SOL I'S INSTRUCTION — VERBATIM]

**SUCCESSOR ACCEPTED. SOL'S TRANSPORT KEY IS TURNED. OWNER COUNTERSIGNATURE REQUIRED BEFORE EXECUTION.**

## I. Exact bound

This instruction binds exactly:

* measured commit: `ad6c95e94d95deb408754e379d2ccf8cd625f497`
* transport commit: `6b50cd50479d5c23c680ba4962be763498ee006c`
* transport commit tree: `fbe703c50b7297c8939f8249686ff70ecb33cdbf`
* transport subject OID: `ee3ff1cc9b436f82a2fcb27627b133de09fa1027`
* floor blob: `fb99a6b64c77640b1dd81a8bf39f5673c22856a4`
* preserved Tooth 10 blob: `92e6e4305b42aa649e4a11c74d77164cdc4028c5`

The measured commit is an ancestor of the transport commit. Their floor blobs are identical. Their delta contains only receipt paths under `mneme/release-floor-erratum-0/`.

Previous published lab bound:

* lab commit: `afc532b3222fc34d2e1bae9c2c8752d9b609f72c`
* public mirror tip: `4d90d7f12ce6789961844b4585d6fdb89abf3e85`

No later HEAD, successor, equivalent tree, or "commit carrying this file" is authorized.

## II. Archive before action

Archive this instruction verbatim and commit that archive before touching the sentinel.

Record the owner's countersignature verbatim beside it. The archive commit does not enlarge the transport bound: transport remains fixed at `6b50cd50…`.

## III. Whole-ferry scope check

Before lifting the sentinel, inspect the entire subject delta:

    git diff --name-status afc532b3222fc34d2e1bae9c2c8752d9b609f72c 6b50cd50479d5c23c680ba4962be763498ee006c -- experiments/latent-lisp

Every changed subject path must be one of:

* `experiments/latent-lisp/mneme/verify-release.sh`
* anything beneath `experiments/latent-lisp/mneme/release-floor-erratum-0/`
* `experiments/latent-lisp/mneme/architecture/ARCHITECTURE-0-STATUS.md`, only if its movement is the authorized append-only Erratum /0 stone record

No frozen-lane path, Sol II experiment, preregistration, unrelated README, semantic implementation, or other subject path may ride.

Any unexpected path or any deletion: **STOP before sentinel lift and return the complete delta.**

This is the anti-coat check. The commit is exact; its cargo must also match the authorization.

## IV. Resolve before transport

Before lifting the sentinel, reproduce and record:

1. transport commit, commit tree, and subject OID exactly as §I;
2. `6b50cd50…` is on main ancestry;
3. source repository and subject porcelain probes both succeed and are empty;
4. `SYNC-PAUSED` is RAISED;
5. public mirror tip is still exactly `4d90d7f12ce6789961844b4585d6fdb89abf3e85`;
6. transport-record chain verifies GREEN; capture its exact pre-act tip;
7. materialize the expected public object from `6b50cd50…:experiments/latent-lisp`, remove only `_staging`, and record: expected far-side Git tree OID, path count, sorted-path digest, symlink count.

Any mismatch: **STOP.**

## V. Dry run

Run the governed dry path at the exact commit:

    sync.sh --commit 6b50cd50479d5c23c680ba4962be763498ee006c --dry-run

Require: exit 0; zero unexpected paths; zero deletions; only the authorized Erratum /0 cargo from §III; mirror still unmoved afterward; sentinel still RAISED. Preserve the complete dry-run output.

## VI. Execute once

After every preceding condition holds and the owner has countersigned:

1. lift `SYNC-PAUSED` **on disk only**, immediately before the act;
2. invoke the adopted governed mechanism: `transport-supervisor.sh --commit 6b50cd50479d5c23c680ba4962be763498ee006c --via manual`
3. allow the supervisor to invoke `sync.sh --commit`, materialize from the exact subject object, remove `_staging`, verify content identity, push the public `main`, and write its transport event;
4. re-raise the sentinel immediately after the mechanism returns, on success or failure.

If Claude Code's action classifier refuses the invocation, that refusal does not authorize an alternate ferry. The owner may execute this exact governed command from his terminal, as in the prior publication act. Preserve the refusal and the owner-terminal output together.

No direct/manual Git push outside the governed mechanism.

## VII. Fail closed

Stop and re-raise the sentinel if any of these occurs: bound identity changes or fails to resolve; whole-ferry scope check finds an unauthorized path; source cleanliness is unknown or nonempty; sentinel state is not as expected; mirror pre-tip differs; dry run is nonzero, reports deletion, or reports unexpected cargo; supervisor or sync exits nonzero; content-identity verification fails; transport event is absent, non-GREEN, or names the wrong source/OID/target; mirror moves again after the governed push; far-side reconstructed tree differs from the precomputed expected tree.

Do not repair within the act. Return the stop condition and raw evidence.

## VIII. Readback and receipt

On success: capture the new public target commit; verify the transport-record event names source `6b50cd50…`, subject OID `ee3ff1cc…`, the actual new target commit, `TRANSPORT-OK`, exit 0; verify the chain remains linear and GREEN; make a genuinely fresh public clone; without running the release floor inside it, establish: HEAD equals the recorded target; HEAD tree equals the precomputed expected public tree; porcelain including untracked and ignored census is empty; tracked-path count and sorted-path digest match; recursive byte comparison against a fresh archive of the bound subject minus `_staging` exits 0.

Do **not** use a far-side floor run as the transport witness. The public mirror lacks lab commit `431fee16`; under the accepted Erratum /0 semantics, rows `[071]` and `[072]` must therefore make that venue's aggregate floor FAIL rather than be laundered as blocked. That is accepted W-2, not a transport defect.

Seal an R-2b receipt candidate containing the instruction, countersignature, preflight, whole-ferry delta, dry run, supervisor output, sentinel states, event, chain verification, and far-side identity reconstruction.

## IX. Standing after a successful receipt

Provisional until Sol and owner receive the return: RELEASE FLOOR ERRATUM /0 — TRANSPORT EXECUTED · RECEIPT PENDING
After joint reception: RELEASE FLOOR ERRATUM /0 — ACCEPTED AND PROPAGATED
No semantic lane standing changes. Memory Layer /0 remains: ADOPTED AND PUBLISHED · stranger audit owed · no independent verification. W-3 remains a separate evidence-root commission. W-4 remains housekeeping debt. W-5 remains the rule that future reduced-table variants must be committed inside their disposable clones.

The crab does not board the ferry.

— Sol I

### Owner countersignature

> I countersign Sol I's exact-bound Release Floor Erratum /0 transport instruction for commit `6b50cd50479d5c23c680ba4962be763498ee006c`, under every stop condition and standing ceiling stated above.

**Owner (verbatim, 2026-08-23): "I accept"**
