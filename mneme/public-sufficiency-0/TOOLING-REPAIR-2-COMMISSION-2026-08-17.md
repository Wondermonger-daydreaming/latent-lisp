# CHANNEL TOOLING REPAIR /2 — TD-10 COMMISSION (2026-08-17)

**Owner-commissioned, narrowly bounded repair of TD-10 (INTEGRATION RANGE ≠ TIP
COMMIT). Deliverable: a SEALED CANDIDATE for a new cold seat — no owner acceptance is
presumed, no TD is closed by the repair, and the repair performs NO live merge, NO
sentinel lift, NO mirror contact, NO publication, NO TD-6/TD-9 action, NO standing
change. This commission is NOT the reserved "successor-10" lab_state read-only scope,
which remains un-commissioned; Q11-O1 stays filed under its existing rider; this
blocking repair may not be silently enlarged — any scope growth requires a separate
owner scope decision.**

## Adjudication (owner, 2026-08-17, verbatim)

> Adjudication: docket the reported finding as **TD-10 — INTEGRATION RANGE ≠ TIP
> COMMIT**.
>
> The completed integration, successor-9 acceptance, TD-7/TD-8 closures, CP/1
> adoption, and opened merge gate remain valid. TD-10 is a newly distinguished defect
> in the pre-launch path gate; it does not retroactively falsify those acts. The first
> live WITHHELD records also remain valid, but they arose from later covered commits
> and are not evidence that the merge range was observed.
>
> TD-10 now blocks `SYNC-PAUSED` removal, public-mirror transport execution, and
> reliance on further post-merge automatic transport. Keep the sentinel raised. TD-6
> and TD-9 remain OPEN; TD-7's first-real-transport readback remains future.

## Structural invariant (owner's wording, verbatim — the repair's law)

> After a successful merge, transport eligibility is determined from the net
> governed-tree change between the pre-merge and post-merge endpoints—not from whether
> the final commit alone touches a governed path.

## Required repair evidence (owner's ten items, verbatim)

> 1. Replace the tip-only gate with a range/tree comparison using independently
>    established pre-merge and post-merge endpoints, ordinarily `ORIG_HEAD` and
>    `HEAD`.
> 2. If those endpoints cannot be established, do not silently classify the merge as
>    irrelevant; emit an explicit conservative diagnostic/state.
> 3. Plant a real fast-forward containing a governed change followed by an unrelated
>    ledger tip. The post-merge hook must launch exactly once and identify the
>    post-merge HEAD.
> 4. Plant an entirely irrelevant fast-forward range; it must not launch.
> 5. Plant a range whose intermediate governed changes cancel so the final governed
>    tree is unchanged; specify and test whether net-tree equality correctly means no
>    transport is due.
> 6. Exercise non-fast-forward and ordinary tip-covered controls.
> 7. With `SYNC-PAUSED` raised, the qualifying merge must produce a truthful WITHHELD
>    record.
> 8. In disposable local-remote harness mode with the sentinel absent, the qualifying
>    merge must produce verified transport.
> 9. Preserve hook byte verification, SOL-TR1-20 through SOL-TR1-23 regressions, and
>    all accepted successor-9 behavior.
> 10. Perform no live merge, sentinel lift, mirror contact, publication, TD-6/TD-9
>     action, or standing change during repair.

## Commission terms (chair's carriage of the above)

- **Subject:** `tools/latent-lisp/post-merge.sh` launch gate (and only what items 1–9
  require to touch). Governed tree = the channel's source scope,
  `experiments/latent-lisp/**` minus exclusions (CP/1 §0).
- **All planted-merge evidence runs in disposable harness repositories** (fresh init
  under `/tmp` or equivalent), never in the lab repository — item 10 forbids any live
  merge. Item 7's sentinel case and item 8's transport case both run in harness mode
  (item 8's "verified transport" targets a disposable local bare remote only).
- **Teeth discipline:** every planted case must be shown RED-capable before its GREEN
  counts (a gate that has never fired is untested, not passing). The full existing
  teeth suite (`teeth-td6-td9.sh`, `install-hook.sh` self-verification) must pass
  unregressed — item 9.
- **Item 5 requires a specification, not just a test:** the candidate must state in
  writing whether net-tree equality means no-transport-due, and test the stated
  answer.
- **Return form:** a sealed candidate parcel docked at `~/Downloads` (tar.gz +
  `.sha256` sidecar, self-contained per lane convention), plus a return instrument in
  this directory, awaiting a NEW cold seat. No conformance claim, no closure claim, no
  "independently verified" — candidate standing only.
- **Q11-O1 and its rider carried unchanged.** If the repair's verification would
  require lab_state writes into legacy-custody state or legacy-migration reorder, the
  work STOPS at that boundary and reports — that ground is rider-guarded successor-10
  scope, not this commission's.

## Provenance

Tip-only-gate finding reported (not docketed) in `LAB-MAIN-INTEGRATION-2026-08-17.md`
§5a → owner adjudication docketing TD-10 (verbatim above; docket THIRD SERIES entry
appended same night) → this commission. No predecessor document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17, at the owner's word.*
