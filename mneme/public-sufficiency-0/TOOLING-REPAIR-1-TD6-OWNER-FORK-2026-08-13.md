# TOOLING REPAIR /1 — TD-6 OWNER FORK (2026-08-13)

**Per the issued commission §3: no change to live rulesets, branch
protection, credentials, deploy keys, apps, or mirror `main` may occur
without this explicit owner fork being returned and decided. This document
returns the fork. It performs NO live change.**

## 1. Exact present configuration — MEASURED this sitting (read-only `gh api`, 2026-08-13 afternoon; supersedes the 2026-08-13 `_staging` testimony as current fact)

| Surface | Measured value |
|---|---|
| Repo | `Wondermonger-daydreaming/latent-lisp`, **public**, personal account, default branch `main` |
| Branch protection on `main` | **NONE** — API returns 404 `"Branch not protected"` |
| Rulesets | **NONE** — `GET /rulesets` returns `[]` |
| Deploy keys | **0** |
| Collaborators | exactly one: `Wondermonger-daydreaming` (admin) |
| This host's authenticated principal | `Wondermonger-daydreaming` itself — `admin:true, push:true, maintain:true` |
| Last push to mirror | `2026-08-10T19:36:16Z` (consistent with "mirror stale at 08-10") |
| Branches | 29 total (docket's "30 non-sync" was the 08-13 早 count; live count today is 29 — counts drift, the class stands) |
| Transport path | `tools/latent-lisp/sync.sh:66` pushes `https://…/latent-lisp.git`, `:179` `push origin HEAD:main` |

**The architectural crux the measurement exposes:** there is no distinct
sync principal. The host pushes as the repository owner; the owner
credential and the transport credential are ONE credential. Server-side
protection that blocks unauthorized writers while "preserving the
authorized sync principal" therefore requires *creating* a distinct sync
principal first — protection cannot distinguish two writers that are the
same account.

## 2. Proposed configuration (Option A — recommended minimum)

1. **Create a dedicated SSH deploy key** (write-enabled) for this repo,
   held only on the lab host, used ONLY by `sync.sh` (git `core.sshCommand`
   pinned to that key for the mirror remote; remote URL switches
   `https://…` → `git@github.com:Wondermonger-daydreaming/latent-lisp.git`).
2. **Create a repository ruleset** targeting `main`: restrict updates,
   creations, deletions (i.e. block pushes); **bypass actors: Deploy keys
   ONLY** — explicitly NOT the repository-admin role.
3. Result: the owner's ordinary token/web pushes to `main` are REFUSED;
   only the deploy-key-bearing sync path may update `main`. Other branches
   remain unrestricted (the sync only writes `main`).

- **Authorized writer of `main`:** the sync deploy key (i.e. `sync.sh` on
  the lab host), nothing else.
- **Prohibited writers of `main`:** everything else, including the owner's
  own interactive credential (this is the point: TD-6's 130 historical
  direct commits were all this credential).
- **Effect on `sync.sh`:** remote URL + key config change (one small
  patch, prepared but NOT applied); the push-target assertion updates to
  the SSH URL. No behavioral change otherwise.
- **Failure / lockout risks:** (i) if GitHub's personal-repo rulesets do
  not offer "Deploy keys" as a bypass actor at execution time, Option A is
  infeasible as stated → fall back to the fork's Option B below —
  **verify the bypass-actor list in the UI/API before creating anything**;
  (ii) deploy-key loss does NOT lock the owner out: the ruleset is a
  settings object the admin can edit/delete at any time (settings access
  is not gated by rulesets); (iii) while active, emergency hand-pushes to
  `main` require deliberately deleting/suspending the ruleset — friction
  by design, recorded as such.
- **Rollback:** delete the ruleset · remove the deploy key · revert the
  remote URL patch. Three reversible acts, each independent.
- **Non-mutating verification:** `GET /repos/{r}/rulesets` +
  `GET /repos/{r}/branches/main/protection` before/after; enforcement
  semantics exercised on a disposable bare remote with a pre-receive
  model (TOOTH-TD-6, builder report in parcel) — **no test push touches
  the live mirror.**

## 3. Option B (fallback if deploy-key bypass unavailable)

Ruleset with NO bypass actors (blocks everyone including owner);
`sync.sh` gains a narrowly-scoped pre/post step that suspends and
restores the ruleset via API around its single push. Weaker (the admin
token can always do this; protection becomes procedural rather than
principal-based), but still converts "unprotected by default" into
"protected by default, writable by ceremony." Not recommended while
Option A is untested.

## 4. The fork (owner decision required; nothing proceeds without it)

☐ **A** — adopt Option A: chair creates deploy key + ruleset exactly as
§2, applies the prepared `sync.sh` remote patch, verifies non-mutatingly,
reports before/after. ·
☐ **B** — adopt Option B. ·
☐ **DEFER** — TD-6 remains DEFINED-UNREPAIRED with its live fact now
measured; cure waits (note: TD-6 does not block the merge gate — only
TD-7+TD-8 do — but an unprotected `main` at transport time weakens every
downstream custody claim). ·
☐ other wording the owner prefers.

*— prepared 2026-08-13 by the chair; no live GitHub surface was modified
in the preparation of this document (reads only).*

---

## ADDENDUM (2026-08-13, per the Sol cold-review disposition)

**Standing: Option A is APPROVED IN PRINCIPLE ONLY. No live execution is
authorized in this repair round — no ruleset change, no deploy-key
creation, no credential mutation.**

**Sharpened invariant (the exclusivity claim, made checkable):**

1. **Exactly one deploy key exists** on the mirror repo (census count = 1;
   today's measured count is 0, so creation is the transition to exactly 1).
2. That key is **write-enabled and dedicated solely to `sync.sh`** — held
   only on the lab host, referenced only by the mirror remote's pinned
   `core.sshCommand`, never reused for any other repo or tool.
3. The ruleset bypass actor is the **DeployKey CLASS**, not a specific
   key — therefore **any additional deploy key is a review trigger**: its
   creation reopens the exclusivity claim and voids invariant 1 until
   censused and ruled. The non-mutating verification (below) must alarm
   on key-count > 1, not merely on ruleset drift.
4. **Owner/admin ordinary credentials have no `main`-update bypass** —
   the repository-admin role is explicitly NOT a bypass actor; the
   owner's interactive pushes to `main` are REFUSED while the ruleset
   stands.
5. **Before/after API census and rollback remain mandatory:** census
   (`GET /rulesets`, `GET /branches/main/protection`, `GET /keys` with
   count assertion) immediately before and after any future authorized
   execution; rollback = delete ruleset · remove key · revert remote
   patch, each independently reversible.

*— appended by the chair from the owner-relayed cold-review disposition.*
