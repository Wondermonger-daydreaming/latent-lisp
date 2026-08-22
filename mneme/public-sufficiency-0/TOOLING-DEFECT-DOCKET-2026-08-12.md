# PS/0 — TOOLING / PUBLIC-CONFORMANCE DEFECT DOCKET (opened 2026-08-12)

**Opened by owner instruction (D-4 disposition, beside this file): the
clean-checkout gate findings are docketed here as a tooling/public-conformance
defect — explicitly NOT as D-4 repair items and NOT as spec-deficit register
entries. Evidence source: the FRIGUS microscope's re-run diagnostic
(`_staging/pubsuff0-d4-microscope.md` §5; anonymous clone of the real mirror,
tip `3101fcee`), which confirmed the prior sitting's four-way finding exactly.
No repair is authorized by this docket; it records what exists.**

## TD-1 — Vacuous-pass class: `git diff` rc=128 read as "no diff"

The published gate compares against a commit absent from the mirror clone;
`git diff` dies rc=128 (fatal to stderr) and its **empty stdout is captured
as "no differences"** — a green light wired to nothing. Two of the eight
checks pass this way on a clean mirror checkout. Defect class: a check whose
failure mode is indistinguishable from its success output. (The lab's own
teeth-check law applies: a gate that has never been shown able to fail is
untested, not passing.)

## TD-2 — Published gate reads an unpublished path — and the path is ungoverned

The gate reads the **repo-root** `_staging/` (unpublished; absent from any
mirror checkout), producing a noisy fail (W-VF) on clean checkouts. Sharpened
by FRIGUS: repo-root `_staging/` is a **different directory** from
`experiments/latent-lisp/_staging/` (the one the channel-policy draft
excludes) — so the path the gate depends on is not merely unpublished, it is
**outside the draft policy's jurisdiction entirely**.

## TD-3 — Fail-for-the-wrong-reason class: the `REL` strip is a no-op

Three checks fail on the mirror for a path-shape reason, not a content
reason: the gate's `REL` prefix-strip does nothing because `sync.sh` already
strips the path prefix at the destination; the files are in fact present.
A conformance signal that is wrong in BOTH directions on a clean checkout
(false green via TD-1, false red via TD-3) measures the checkout's shape,
not its conformance.

## TD-4 — Net effect

On a clean mirror-style checkout the gate exits 1 at 4/8 — while the one
genuinely meaningful check (the 173-check selftest, green from the mirror
alone) demonstrates the campaign's thesis: **the mirror can RUN the law it
cannot CITE.** The gate as shipped can neither confirm nor deny public
conformance.

## Standing and boundaries

- **Status: OPEN, UNREPAIRED, UNASSIGNED.** Repair requires its own bounded
  commission (tooling lane, not D-4, not the spec-deficit register — these
  are defects of a *check*, not of the *law*).
- The defect rows above are DOCUMENTARY FACTS from an exhibited re-run;
  the classifications are the chair's, and the microscope's §5 transcript is
  the evidence of record.
- Any future repair must include planted-failure teeth for TD-1 (prove the
  gate can distinguish rc=128 from a genuinely empty diff) before a green
  run is trusted.

*— opened 2026-08-12 by the chair under owner instruction.*

---

## STANDING (appended same night; history above unrewritten)

- **TD-1..TD-4: CLOSED** by the owner's acceptance of Tooling Repair /0
  (`TOOLING-REPAIR-0-ACCEPTANCE-AND-TD5-2026-08-12.md`, Act 1). The TD-1
  planted-failure requirement was satisfied before closure (seal tooth,
  proven RED-capable).
- **TD-5** (found during the repair; owner ruled "enumerate the citizens"):
  **repair EXECUTED, acceptance PENDING.** After owner acceptance of the
  TD-5 successor it may be marked CLOSED — not before.
- **TD-5: CLOSED** (same night) by the owner's acceptance of the TD-5
  tooling successor (verbatim act:
  `TOOLING-REPAIR-0-ACCEPTANCE-AND-TD5-2026-08-12.md`, Act 3).
  **DOCKET TD-1…TD-5: CLOSED WHOLE.** The mirror rehearsal's PARTIAL is not
  a conformance PASS and is not converted into one by any closure here.

---

## SECOND SERIES — TD-6..TD-9 (opened 2026-08-13 during R-1 evidence work; OPEN, UNASSIGNED, no repair authorized; TD-1..TD-5 CLOSED history untouched)

Evidence source: MACHINATOR's transport state machine
(`_staging/pubsuff0-r1-transport-state-machine.md`), first-hand, teeth-run
against a local bare remote.

- **TD-6 — the mirror's `main` is unprotected** (`admin:true, push:true`,
  credentials wired into the host config): **130 historical direct commits**
  bypassed `sync.sh`; 30 non-sync branches exist; the transport channel
  cannot currently enforce that only the sync writes. Deleted content
  (e.g. the 2026-07-12 receipt-seed) remains recoverable from mirror
  history forever — the sync restores tips, never records.
- **TD-7 — the post-commit hook discards `sync.sh`'s exit status**: a
  failed sync is indistinguishable from a successful one at the hook
  layer. (Under a three-stage publication model this becomes a defect
  against a defined reporting duty.)
- **TD-8 — the installed `.git/hooks/post-merge` is a STALE copy** missing
  the 2026-08-02 `--commit` fix: the which-commit race is open on the
  merge path — **the exact path an eventual branch→main publication would
  travel. Repair should precede any such merge.**
- **TD-9 — `.sync.log` is gitignored and host-local**: the withholding
  record (100 refusals at tonight's count) is unportable testimony that no
  clone carries and a host move would erase.

## STANDING — SECOND SERIES (appended 2026-08-17; history above unrewritten)

- The header's "OPEN, UNASSIGNED, no repair authorized" clause was superseded
  the same day it was written: the owner issued CHANNEL TOOLING REPAIR /1
  (`TOOLING-REPAIR-1-COMMISSION-2026-08-13.md`), which ran nine successor
  returns, ten Sol dispositions, and eleven QUAESTOR verification rounds,
  ending in owner acceptance with rider
  (`TOOLING-REPAIR-1-SUCCESSOR-9-OWNER-ACCEPTANCE-2026-08-17.md`). The header
  stands unrewritten above; this entry is the record of its supersession.
- **TD-7: CLOSED** by the owner's closure act
  (`TOOLING-REPAIR-1-TD7-TD8-CLOSURE-AND-MERGE-GATE-OPENING-2026-08-17.md`),
  **with a binding first-fire readback duty**: the first real transport's
  supervisor verdict and record entry must be read back to the owner as part
  of the eventual post-merge transport act. TOOTH-TD-7 was proven RED-capable
  (planted exit 42) before closure. First real transport UNREACHED at
  closure; harness evidence is not converted into channel evidence.
- **TD-8: CLOSED** by the same owner closure act. The defect as defined is
  dead in the tree (installed hooks = byte-verified thin delegators, sha256s
  in the instrument; stale hook preserved as evidence at
  `.git/hooks/post-merge.pre-td8-backup-20260813T181941Z`). TOOTH-TD-8 was
  proven RED-capable (drift caught, cured, caught again) before closure; the
  verifier absorbed SOL-TR1-16..22 across nine cold seats. The TD-8
  definition text above is now HISTORICAL — it describes a hook that no
  longer exists. The post-merge path has never been exercised through a real
  merge; this closure does not convert byte-verification into channel
  evidence. Q11-O1, the clock-order false RED, and all successor-9
  environment limits are carried, not erased.
- **The merge gate is OPENED** by the same act (owner ruling: the
  "(and their first real-transport evidence exists)" parenthetical of
  `TOOLING-REPAIR-1-RETURN-2026-08-13.md:98–99` describes what the merge will
  produce, not a precondition). No merge is performed or authorized by the
  opening; the merge remains a separate owner-gated act in the CP/1
  acceptance ordering, with SYNC-PAUSED to be held throughout the eventual
  integration.
- **TD-6: OPEN.** No live credential/ruleset action has ever occurred; Option
  A remains approved in principle only.
- **TD-9: OPEN — IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY UNREACHED.**
  The four-step closure criterion of the TD-9 durability fork stands
  untouched; the record ref has zero events and has never crossed to any
  remote.
  *(Superseded fact, appended 2026-08-17 evening: the record ref now exists
  locally with WITHHELD events from covered commits on `main`; it has still
  never crossed to any remote — the off-host criterion remains fully unmet;
  TD-9 remains OPEN.)*

## THIRD SERIES — TD-10 (opened 2026-08-17 during the executed lab-main integration; docketed by owner adjudication the same night)

- **TD-10 — INTEGRATION RANGE ≠ TIP COMMIT** (owner's adjudicated name):
  the post-merge launch gate (`tools/latent-lisp/post-merge.sh:23–24`)
  tests only whether the **tip commit** touches a governed path
  (`git diff-tree … -r HEAD`). After a fast-forward whose tip happens not
  to touch the governed tree, the entire merged range becomes
  main-ancestral **silently** — no launch, no log line, no record event.
  Discovered live: the 2026-08-17 integration made **128 governed commits**
  main-ancestral with zero machinery events, because the tip was a ledger
  commit (mechanism exhibited with the gate's own test in
  `LAB-MAIN-INTEGRATION-2026-08-17.md` §5a). Owner adjudication, verbatim
  ruling of scope and validity:
  > The completed integration, successor-9 acceptance, TD-7/TD-8 closures,
  > CP/1 adoption, and opened merge gate remain valid. TD-10 is a newly
  > distinguished defect in the pre-launch path gate; it does not
  > retroactively falsify those acts. The first live WITHHELD records also
  > remain valid, but they arose from later covered commits and are not
  > evidence that the merge range was observed.
  **TD-10 BLOCKS: `SYNC-PAUSED` removal · public-mirror transport
  execution · reliance on further post-merge automatic transport.** The
  sentinel stays raised while TD-10 is open. Structural invariant the
  repair must satisfy (owner's wording, verbatim):
  > After a successful merge, transport eligibility is determined from the
  > net governed-tree change between the pre-merge and post-merge
  > endpoints — not from whether the final commit alone touches a governed
  > path.
  Repair commission: `TOOLING-REPAIR-2-COMMISSION-2026-08-17.md`
  (CHANNEL TOOLING REPAIR /2 — deliberately NOT the reserved
  "successor-10" lab_state scope, which remains un-commissioned under the
  successor-9 rider). **TD-10: OPEN — repair commissioned.**
  *(Closure appendix, 2026-08-18: **TD-10 CLOSED** by owner act
  `TD-10-TD-11-CLOSURE-2026-08-18.md` — grounds: TR/2 accepted repair
  (`TOOLING-REPAIR-2-OWNER-ACCEPTANCE-2026-08-18.md`, subject `2e700901`,
  range gate `ORIG_HEAD..HEAD` satisfying the structural invariant above),
  hash-verified live on disk at closure. Riders travel; residuals carried
  named — `ORIG_HEAD` freshness unproven, first among them. Closure lifts
  NOTHING: sentinel raised, transport/publication/mirror all separately
  gated, TR/3 cold-seat gate stands.)*

- **TD-11 — MERGE-BY-COMMIT IS INVISIBLE (the second door)** *(name
  chair-drafted; owner may rename at acceptance)*: a merge on `main`
  **completed by `git commit`** — any conflicted merge, or
  `--no-commit` — produces ZERO machinery events: git does not fire
  `post-merge` for merges concluded by `git-commit`, and
  `post-commit.sh`'s `git diff-tree` invocation lacks `-m`, making it
  structurally blind to merge commits. Governed content can therefore
  become main-ancestral unobserved — TD-10's defect-class surviving
  through a second door. Found by QUAESTOR's adversarial round 1 on the
  TR/2 candidate (`_staging/tr2-quaestor-round1.md`, CONFIRMED HIGH);
  the code is PRE-EXISTING and byte-identical across the TR/2 candidate,
  so the finding is not a builder omission. Owner disposition
  (2026-08-17, interview fork): **docket as TD-11 AND extend the TR/2
  commission to cure it in the same candidate** — one cold seat reviews
  one coherent gate repair
  (`TOOLING-REPAIR-2-SCOPE-EXTENSION-1-2026-08-17.md`). **TD-11 joins
  TD-10 in blocking `SYNC-PAUSED` removal, public-mirror transport
  execution, and reliance on post-merge automatic transport.**
  **TD-11: OPEN — repair commissioned under the extended TR/2.**
  *(Closure appendix, 2026-08-18: **TD-11 CLOSED** by owner act
  `TD-10-TD-11-CLOSURE-2026-08-18.md` — grounds: TR/2 accepted repair,
  `post-commit.sh` parent-census/first-parent gate, cold-seat-verified.
  Name FROZEN at closure by owner ruling: the chair-drafted
  "MERGE-BY-COMMIT IS INVISIBLE (the second door)" stands. Riders travel;
  residuals carried named. Closure lifts NOTHING — same gates as TD-10's
  appendix.)*
