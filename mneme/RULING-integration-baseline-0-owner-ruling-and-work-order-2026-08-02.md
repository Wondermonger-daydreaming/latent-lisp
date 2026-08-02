# Lisp+ Integration Baseline /0
## Owner ruling and implementation work order

**Owner:** Tomás  
**Date:** 2026-08-02  
**Repository:** `Wondermonger-daydreaming/latent-lisp` / lab subject tree `experiments/latent-lisp`  
**Assessment basis:** `state-assessment-return-2026-08-02.zip`  
**Assessment archive SHA-256:** `a8b715d18f9083d8272f82c0b8f602b90e5aaa27c9bc1e7929e80a6c4574501b`  
**Inspected subject-tree identity reported by Fable:** `ef4097a869364d1150905d43f103df689cf04dff`  
**Last substantive subject commit reported by Fable:** `3cd53351`

---

# I. Owner disposition

The Fable/PRAETOR project-state assessment is accepted as a high-confidence advisory record of the inspected tree. Acceptance of the report does not silently adopt any candidate implementation, repair any standing gap, or raise any claim ceiling.

The central diagnosis is accepted: the current project is a successful specification-and-implementation research ladder whose principal lanes are green locally, but it is not yet one installable, jointly gated, honestly documented language distribution. The next critical-path act is consolidation rather than a new semantic layer.

The selected milestone is therefore **Lisp+ Integration Baseline /0**. This is Fable's Option C under a stricter name. It is a packaging, loading, verification, documentation, and release-engineering act. It must not be described as establishing semantic end-to-end integration, because no Stack-B derive/perform operation currently executes against a Stack-A journal-backed process.

The owner makes the following decisions:

1. **Surface /2 standing — YES, prospectively and exactly.** As of this ruling, the currently published Surface /2 state at the inspected closure line (`3cd53351`, including Erratum 0.2) is accepted as a **closed published candidate**. This ruling does not claim that an earlier oral authorization necessarily covered Erratum 0.2, and it must not rewrite that historical uncertainty. It settles standing now. It does not adopt the implementation and does not confer independent-validation language.

2. **Form /2 standing — record candidate status.** Form /2 is acknowledged as a published candidate-by-default in the current tree. The earlier ruling declining to open generic Language Obligation /0 remains fully in force. No new abstraction is opened.

3. **LCI/0 — do not build a duplicate audit harness.** The assessment reports that `mneme/lci0/audit/` already exists in main, landed at `bedb279b`, with a completed evidence archive, 84 passing laws, four preserved failing laws, six minimized witnesses, and the status `AUTHORIAL RULING REQUIRED`. Any earlier instruction to construct that harness from scratch is superseded by this repository evidence. A later bounded adjudication will decide the four laws; it does not block Integration Baseline /0.

4. **Primary milestone — APPROVED.** Build Integration Baseline /0 under the scope below.

5. **Naming — AFFIRMED.** The language is **Lisp+**. **Mneme** is its memory-and-continuity layer. Project documentation and system naming must stop inverting that relation.

6. **`latent-mvp` — FOSSIL-MARK.** Retain it intact as a historical stratum and retain its historical floor, but remove it as the present `START HERE` path. Do not delete it and do not silently refactor its semantics.

7. **Language-A tranche-B — ARCHIVE NOW, ADOPT LATER.** Preserve all `codex/language-a-*` remote branches and PR #1's head in verified Git bundles. Do not merge the 706-file campaign into the current language tree during this milestone.

8. **Published scratch directories — DELETE AFTER OPTIONAL INCIDENT CAPTURE.** The generated `mneme/vertical0/runs/scratch-*` directories are not canonical evidence. After an optional one-time incident archive and manifest, delete them from the lab working tree and public mirror. Prevent recurrence structurally.

9. **Mirror publication — CHANGE NOW.** The mirror must publish a committed tree, not the live working directory. Preserve the deliberate `_staging/` exclusion. Fix `verify-sync.sh` so Git-unrepresentable empty directories do not create a false mismatch. No further large test campaign may run on lab main while automatic checkpointing or working-tree publication can capture in-flight output.

---

# II. Builder commission — Integration Baseline /0

## Role

Act as the sole integration builder for this milestone. Work narrowly, mechanically, and from exact repository evidence. Your hardest obligation is to make the current construction load and verify as one distribution **without changing what any lane means**.

Do not conduct a new architecture review. Do not invent a new language layer. Do not repair a semantic defect by stealth. If consolidation exposes a semantic conflict, stop and return the smallest reproducer and exact conflicting authorities.

Use one builder hand in one isolated worktree. No concurrent agent may write to that worktree.

## Preflight identity and safety gate

Before editing:

1. Fetch the relevant lab and mirror refs without changing the checked-out tree.
2. Record current lab HEAD, lab main, public mirror main, and `HEAD:experiments/latent-lisp`.
3. Compare the current subject subtree with Fable's inspected tree `ef4097a869364d1150905d43f103df689cf04dff`.
4. If it differs, produce a path-level and semantic-controlling-path delta. Continue only when every intervening change is already authorized and does not invalidate this work order; otherwise stop.
5. Create a fresh isolated worktree and branch, suggested name:
   `opus/lisp-plus-integration-baseline-0`.
6. Verify the worktree is clean and that no automatic Stop hook, checkpoint hook, or mirror sync can commit or publish its in-flight outputs. Do not work directly on lab main.
7. Preserve all pre-existing `_staging/` material. Do not clean, reset, stash, relocate, or delete unrelated owner material.

## Deliverable 1 — ASDF system family

Create one documented ASDF system family for the current Lisp+ construction.

Required properties:

- A root `lisp-plus.asd` in the mirrorable subject tree.
- One umbrella system that can be loaded from a clean checkout with a single documented command on SBCL 2.4.6/Linux.
- Clear per-lane or per-stack subsystems where needed for load order and isolation.
- A test system or test operation that invokes the canonical release floor.
- Relative, checkout-independent pathname handling.
- No dependence on `/home/gauss`, a deleted worktree, or an undocumented current working directory.
- No modification of existing package exports merely to make the umbrella look tidy.
- No giant re-export package pretending that all 1,463 current exports are a stable public API.
- The ASDF system is a build/load container, not a new semantic authority.

Prefer zero changes to existing semantic `.lisp` files. If a `.lisp` change is unavoidable, it must be exclusively load/path mechanics, isolated in its own commit, and justified form by form in the return.

## Deliverable 2 — one authoritative aggregate release floor

Create one canonical command, such as `mneme/verify-release.sh` or an ASDF `test-op`, that accounts for every principal implementation lane.

The floor must:

- Invoke or faithfully subsume the existing aggregate and per-lane gates.
- Preserve every existing self-limiting banner and exact claim ceiling.
- Record exact command, cwd, exit code, lane, test count, and evidence category.
- Distinguish at least: `PASS`, `KNOWN-UNRESOLVED`, `ARCHIVED-NOT-RERUN`, `BLOCKED-EXTERNAL-INPUT`, and `FAIL`.
- Treat the existing LCI/0 result honestly: 84 laws pass; four named laws remain preserved failures pending authorial adjudication; the external audit packet is absent on the inspected host. Do not turn these findings green, discard them, or rebuild the harness.
- Treat deep or externally bound campaigns honestly when not rerun. Verifying a committed evidence archive is not the same as reproducing it.
- Run transcript-writing or scratch-producing gates inside a disposable worktree/copy or redirect their outputs so the source checkout remains byte-clean.
- Finish with zero modified tracked files and zero untracked litter in the caller's checkout.
- Detect any change in a pre-existing gate's expected count or verdict and fail closed.

A floor that exits zero may mean only: every executable gate passed, every known unresolved finding is unchanged and explicitly reported, and every archived-only item passed its integrity check. It must not mean “all semantic questions are resolved.”

## Deliverable 3 — one composite release demonstration

Create one documented command that runs the strongest demonstration the present tree actually supports:

1. the Vertical Specimen /0 process path — datum, identity, journal, capabilities, effect frontier, fake adapter, forced SIGKILL deaths, reconstruction, and inspection; then
2. Surface /2's read-only re-expression of the completed result.

The runner and its output must call this a **composite release demonstration**, not a complete semantic end-to-end language path.

It must print an explicit boundary statement equivalent to:

> The durable process/reconstruction path passes. The Surface /2 re-expression passes. A derive/perform language operation executing against the journal-backed process substrate is not present in Integration Baseline /0.

Required exit evidence includes reproduction of the known Vertical /0 reconstruction digest:

`706f7e1e582e06cce14ba44428b7c0705bd6480a8dcbd5ebf5a9a85874cdd05a`

All execution scratch must go to `/tmp` or a deliberately gitignored release-run directory, and must be removed on both success and failure where safely possible.

## Deliverable 4 — current front door and authority map

Replace project-level drift with one honest current route through the tree.

Required documentation work:

- Rewrite the root README's current-state and quickstart sections around Lisp+, not the fossil MVP.
- State unambiguously that Lisp+ is the language and Mneme is its memory/continuity layer.
- Provide one clean-checkout load command, one release-floor command, and one composite-demonstration command.
- Create a compact authority index covering all ruling-class documents, regardless of filename convention.
- Mark the old roadmap, manifest, phase board, and fossil MVP front-door records as `SUPERSEDED` or `HISTORICAL`, with forward links. Do not delete history.
- Carry the exact standing of Surface /2 and Form /2 from this owner ruling.
- State that no implementation is adopted unless an exact ruling says otherwise.
- Name the first missing semantic seam: derive/perform over a journal-backed process.

Do not use “complete,” “coherent language,” “independently validated,” or similar promotion language beyond the earned ceiling.

## Deliverable 5 — release claim ceiling and debt ledger

Create one current claim-ceiling document. It must preserve, not paraphrase away:

- AP0 Rider 2's forbidden promotion language and permitted formulation.
- PJ0 §32.5's limit.
- Vertical /0's SIGKILL-only crash-model ceiling.
- Verdict-liveness as connectedness, not predicate soundness.
- The current stranger-audit debt count.
- LCI/0's four unresolved law failures and absence of authorial disposition.
- The absence of portability evidence beyond SBCL 2.4.6/Linux.
- The absence of the semantic Stack-A↔Stack-B derive/perform integration path.
- The absence of an implemented Mneme memory layer.

The milestone may claim only that one clean command loads the current construction and one canonical floor accounts for its declared gates and known unresolved findings.

## Deliverable 6 — mechanical evidence refresh

Perform only the evidence-maintenance work justified by the assessment:

- Re-capture Surface /1 teeth evidence under the current stricter Addendum 0.1 runner.
- Fix `semantic-path-diff.sh` so it does not mistake ordinary later repository movement for an addendum-scope violation.
- Mark the 15 clean-checkout-unrunnable probe files as historical evidence or quarantine them behind an explicit non-runnable label; do not delete them.
- Remove hardcoded transient worktree and host paths from new front-door recipes.
- Preserve before/after hashes and exact gate counts.

If any refresh changes a semantic verdict rather than merely bringing evidence into agreement with current authorized code, stop.

## Deliverable 7 — minimal CI entry

Add one minimal CI workflow in the mirrorable repository that, on the supported SBCL/Linux environment, at least:

- loads the ASDF umbrella system from a clean checkout;
- runs the canonical non-destructive release floor or an explicitly named CI profile of it;
- verifies that the checkout remains clean;
- publishes no generated evidence back into the repository.

The full authoritative release floor remains the local closure gate. A reduced CI profile must enumerate exactly what it omits and must not call itself the full floor.

If exact SBCL 2.4.6 provisioning cannot be made deterministic without expanding scope, stop and name the release-engineering obstacle rather than silently testing a different implementation/version.

## Explicit exclusions

Do not:

- change Canonical Datum, Kernel, PJ0, AP0, capability, adapter, slice, form, surface, or specimen semantics;
- repair or adjudicate the four LCI/0 law failures;
- create a new public abstraction or generic obligation layer;
- build the missing derive/perform-over-durability seam;
- implement Mneme memory operations;
- implement a live provider adapter;
- add a new Slice, Form, Surface, codata layer, or specimen;
- merge Language-A tranche-B;
- delete historical strata or evidence;
- raise any lane's standing;
- call same-family or shared-normative agreement independent validation;
- publish or merge before fresh review.

## Executable exit gate

Integration Baseline /0 is complete only when, from a fresh clean clone of the public mirror on the supported host:

1. The documented ASDF load command exits 0.
2. The canonical release floor accounts for every principal lane and exits under the explicit status policy above.
3. Every pre-existing executable gate retains its authorized count and verdict.
4. The composite demonstration exits 0 and reproduces the Vertical /0 reconstruction digest.
5. The README's three front-door commands work verbatim.
6. The run leaves zero tracked modifications and zero untracked litter.
7. Existing package exports are unchanged except for any separately justified new release-only package.
8. Every `.lisp` diff is certified as load/path mechanics only by a fresh reviewer.
9. The current claim-ceiling document matches the actual output and standing matrix.
10. The CI entry loads and verifies the supported profile from a clean checkout, or the builder returns `BLOCKED — EXACT CI TOOLCHAIN NOT REPRODUCIBLE` with no substitute claim.

## Return package

Return an identity-bound parcel containing at least:

- `INTEGRATION-BASELINE-0-RETURN.md`;
- exact base and result commit/tree/subtree hashes;
- `MANIFEST.sha256` and outer sidecar;
- complete changed-file inventory;
- `.lisp` diff classification, form by form;
- ASDF system graph;
- aggregate-floor lane table and exit codes;
- clean-checkout transcript;
- composite-demonstration transcript and reconstruction digest;
- before/after package-export census;
- claim-ceiling document;
- documentation supersession map;
- CI transcript or exact blocked ruling;
- `git status --short` before and after;
- explicit statement that no semantic standing changed.

Build on the branch only. Do not merge, push to public main, tag, or declare adoption. Stop after the return parcel and branch identity are produced.

---

# III. Nonblocking lane — Repository Custody and Publication Safety

Run this in a separate worktree/seat with no semantic source edits. It may proceed alongside Integration Baseline /0 but must finish before the new branch is publicly released.

1. Pause automatic mirror publication during the operation.
2. Create verified Git bundles for all ten `codex/language-a-*` remote branches and PR #1's exact head. Store them in a durable freezer directory with SHA-256 sidecars and a ref inventory.
3. Freeze verified copies of the current Vertical /0 and Surface /2 return parcels and sidecars.
4. Locate and freeze the external LCI/0 algebraic-law audit packet and relay, if present; do not use them to rebuild a duplicate harness.
5. Optionally capture the 61 published scratch directories once as an incident archive with manifest; then delete them from the lab working tree and public mirror.
6. Change mirror publication to materialize the committed subject tree, never the live working directory. Preserve the deliberate subject `_staging/` exclusion.
7. Fix mirror verification to compare Git-representable content and treat empty-directory differences as benign.
8. Verify a deliberately dirty working tree cannot contaminate a mirror publication.
9. Resume publication only after the mirror matches the intended committed tree byte-for-byte and no scratch directories remain.
10. Return hashes, bundle verification transcripts, mirror before/after tips, and an exact tooling diff. Do not touch language semantics.

---

# IV. LCI/0 intercept

Before any agent continues an earlier LCI/0 “harness construction” instruction, send this correction:

> Current-main inspection supersedes the earlier assumption that the LCI/0 algebraic-law harness is absent. `mneme/lci0/audit/` is already landed and published, with a complete archived result: 84 PASS, four preserved FAIL (`LCI0-CROSS-004`, `LCI0-SCOPE-015`, `LCI0-TEMP-022`, `LCI0-TEMP-028`), six minimized witnesses, and `AUTHORIAL RULING REQUIRED`. Do not build a duplicate harness. First compare any unmerged work against the existing 30-file audit tree. Preserve only genuinely missing, authorized refinements as a delta proposal; otherwise stop. Do not repair the failures without a separate authorial adjudication.
