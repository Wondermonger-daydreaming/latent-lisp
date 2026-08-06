# Surface Account /0 — R4 Phase 0: Authentication, Inventory, Changed-Path Budget

**Round:** R4 (production candidate), governed by the R4 relay.
**Integrator:** FABER (Claude Fable 5), the round's only source-writing hand.
**Date:** 2026-08-06 (`date` run before writing: `Thu Aug  6 12:53:09 PM -03 2026`).
**Worktree:** dedicated R4 worktree on branch `surface-account-0-r4`.

Every value below was measured in this session, in this worktree, by the
command shown or named. Nothing is copied from the relay except where the
comparison against the relay is itself the point.

---

## 1. Opening authentication (measured except where a row is explicitly marked otherwise; all PASS)

| Condition | Command | Observed |
|---|---|---|
| HEAD is the exact accepted R3.3.3 tip | `git rev-parse HEAD` | `2c1ac711b039528fd6a9d665d37ac2a937bf532d` — exact match |
| Branch | `git branch --show-current` | `surface-account-0-r4` |
| Worktree raw-clean at opening | `git status --porcelain` | empty |
| `/0` lane subtree identity | `git ls-tree HEAD experiments/latent-lisp/mneme/` | `language-surface-account-0` = `3076aa17e922f0589e75827f560c038699f0854e` — exact match |
| Local `main` recorded | `git rev-parse main` | `0b734049753d9bbc4bda79418312ff3e76d22bdf` (lab main; distinct from public main — see below) |
| All local refs recorded | `git for-each-ref` | recorded in session evidence; includes `surface-account-0-r33` = `2c1ac711`, `surface-account-0-opening` = `7b032616`; **no ref other than this round's own branch points at R4 work** |
| Public `main` still `ced1b2ce…` | chair-verified this session via `git ls-remote` (R4-CHAIR-BRIEF); FABER did not re-contact the network — **traced, compressed** (the chair's live ls-remote output is quoted in the brief; a second network read from the sealed round was judged not worth the exposure) | `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e` |
| No public `surface-account-0*` branch | same chair verification, same standing | none exists |
| SBCL exact | `/home/gauss/.local/bin/sbcl --version` AND the operation-check `(lisp-implementation-version)` **through the wrapper** | `SBCL 2.4.6` / `2.4.6` |

The commit object was present locally (branch `surface-account-0-r33`); the
sealed-bundle reconstruction path was not needed. `HALT —
R4-OPENING-BASE-UNAVAILABLE` did not fire.

Unrelated user changes: the R4 worktree contains none (raw-clean). The main
checkout's untracked files (`_staging/*`, one mneme assessment file) are not
touched by this round.

## 2. Opening counts, derived from the tree (not pasted)

Derived by command from the lane at `3076aa17…`:

- **Real sections: 14** across **13 transcripts** (the `controls` transcript
  carries two sections) — from `probes/verify-profiles.txt`, non-comment rows,
  excluding the `synthetic` profile.
- **Transcript profiles: 13 real + 1 synthetic = 14 profiles in the file.**
- **Census IDs: 490** — `verify-sequences.txt` holds 501 non-comment sequence
  rows; 11 belong to the two synthetic sections (3 + 8); 501 − 11 = **490 IDs
  across the fourteen real sections**, exactly the census the probes README
  defines and the accepted return reported.
- **Discrepancy explanation (owed by the relay's Phase 0):** the relay's
  phrase "490 checks" names the *census-ID* count. The per-profile `CHECKS`
  (i.e. `[PASS]`-line) sum over the 14 real sections is **367**
  (27+43+27+31+135+31+12+11+11+7+6+11+8+7). The 490 census counts every
  sequence ID — `[PASS]` check IDs *plus* structural anchors (`CASE-NN`,
  `END-CASE-NN`, branch open/close anchors) — which is how the README's own
  census paragraph has counted since R2. Both numbers are true; they answer
  different questions; this round reports both and conflates neither.
- **Release floor rows: 89 total = 73 `both` + 16 `full`** — counted from
  `mneme/verify-release.sh`'s gate table. Matches the Integration Baseline /0
  closure facts `89/89` full and `73/73` CI (CI runs the 73 `both` rows).
- **Load-order matrix: 15 real rows** (13 supported + 2 refusal), from
  `mneme/load-order-matrix.sh`.

## 3. Production-architecture inventory (read this session)

- **Umbrella:** `experiments/latent-lisp/lisp-plus.asd` — systems are
  load-entrypoints (source loads in place, no FASL); the umbrella walks
  `lisp-plus-system::*lane-order*` (currently 14 rows, Stack A first); the
  false-edge law: CD/0-only lanes declare **no** `:depends-on` and guard-load
  CD/0 themselves.
- **Loaders:** `mneme/load-lisp-plus.sh` (clean-transcript gate; the package
  count in its banner is **computed** from `LIST-ALL-PACKAGES`, not
  hard-coded — the opening-round API delta's "19 → 20 banner edit" is
  therefore unnecessary, a disclosed deviation from that proposal);
  `mneme/load-order-matrix.sh` (per-row complete contracts, teeth first).
- **Release floor:** `mneme/verify-release.sh` — gate table quoted above;
  runs writing gates in a disposable tree copy that is **not a git
  checkout** (consequence: the frozen probe battery, which fails closed
  without a resolvable `git rev-parse HEAD`, cannot be a `writes=yes` floor
  row; if added it must run in place).
- **CD/0:** `canonical-datum/common-lisp/` — the production mechanism's one
  dependency (public constructors: `make-identifier-datum`,
  `make-bytes-datum`, `hex-to-octets`, readers, `canonical-octets`).
- **Surface /2 production home:** `mneme/language-surface-2/surface2.lisp`
  (package `LISP-PLUS-SURFACE2`). **The lawful /0→/2 consumption point
  exists:** `request-expansion source-form operation occurrence-tag` requires
  `occurrence-tag` to be a CD/0 **identifier datum** (surface2.lisp:690–696,
  refusal `:occurrence-tag-not-identifier`), and the tag is carried into the
  request, occurrence, and receipt with public readers
  (`expansion-request-occurrence-tag`,
  `expansion-occurrence-occurrence-tag`). The /0-minted performance
  identifier is exactly that species. **No semantic broadening of /2 is
  needed; the Phase-5 HALT condition does not fire.**
- **Frozen probe lane:** `mneme/language-surface-account-0/probes/` — the
  executable oracle; untouched by this round.

## 4. The governing reading of the R4 commission (load-bearing; stated once, here)

The R4 relay's "Governing acceptance" list, its four structural conclusions,
its Phase-4 invariant classes, and its Phase-5 direction of dependence
(*Surface /2 consumes a value produced by Surface /0*) all name the
**identity mechanism** of the accepted R3.3.3 probe (`probes/probe-identity.lisp`):
once-only carrier election, single disposition slot, epoch, linearizable
allocator, canonical ASCII counter grammar, total carrier scanner. They do
not name the Part-I composite front door (doors/inspector/conditions), which
the accepted probe does not implement and which would have Surface /2 as a
*provider*, not a consumer. **R4 therefore productionizes the identity
mechanism.** The opening-round documents that proposed the composite as the
production content (`R4-SURVIVAL-PLAN.md` §§1–3,
`PROPOSED-API-AND-INTEGRATION-DELTA.md` §1) are superseded on that point by
the owner's later R4 relay, which is this round's governing commission; the
composite remains an unimplemented contract candidate for a future governed
round. This reading is restated with its API consequences in
`R4-PRODUCTION-DESIGN-LEDGER.md` and flagged for the reviewers.

## 5. Declared changed-path budget (nothing outside this list is edited)

**New files (all under `experiments/latent-lisp/mneme/language-surface-account-0/`):**

| Path | Relay category |
|---|---|
| `production/package.lisp` | production package file |
| `production/surface-account.lisp` | production implementation source |
| `production/load.lisp` | production loader |
| `production/surface-account-selftest.lisp` | production self-test |
| `production/surface-account-hostile.lisp` | production gate (hostile schedules) |
| `production/run-hostile-profiles.sh` | production gate runner |
| `production/surface-account-graph-gate.sh` | static ASDF-graph gate |
| `production/surface-account-disease.sh` | mutation/negative-control runner (replicas live outside the tree) |
| `production/surface-account-inhabited.lisp` | smallest lawful Surface `/2` inhabited specimen |
| `R4/R4-PHASE-0-INVENTORY.md` | documentary record (this file) |
| `R4/R4-PRODUCTION-DESIGN-LEDGER.md` | production design/correspondence ledger |
| `R4/R4-RETURN.md` | production-admission record / return report |
| `R4/extract-production.py` | *(added at Phase 2, disclosed here)* the mechanical probe→production extraction script — committed so the correspondence claim is re-derivable, under the relay's "documentary custody and production-admission records" category |
| `production/surface-account-loader-witness.lisp` | *(added at R4.3, disclosed here)* the four loader-finality witness cases of the owner's R4.3 commission (production gate — witnesses category of the commission's scope) |
| `OWNER-RULING-R4-RETURN-AND-R4.3-COMMISSION.md` | *(added at R4.3, disclosed here)* the owner's R4 ruling, committed byte-exact per the lane's OWNER-RULING-* convention (documentary record) |

**Modified files (each additive and disclosed):**

| Path | Authorization |
|---|---|
| `mneme/language-surface-account-0/OPENING-BASE-AND-CUSTODY.md` | explicitly authorized documentary debt (R3.3.x custody spine) |
| `lisp-plus.asd` | necessary ASDF/umbrella integration (one new system + one new `*lane-order*` row; no existing row moves) |
| `mneme/verify-release.sh` | production gates enter the release organism (additive rows only; no existing row moves; floors restated additively) |
| `mneme/load-order-matrix.sh` | one additive supported row for the new lane + the row-count comment |

**Deliberately not modified:** `mneme/load-lisp-plus.sh` (banner computed —
see §3); every frozen probe lane file; every predecessor lane; Surface `/3`
(shut); Surface `/1` (closed by its own law); Surface `/2` sources (the
specimen is a new file; zero `/2` edits).

Any need beyond this list is a stop condition per the relay, to be disclosed
before any edit.

## 6. Custody parcels measured (read-only, `/home/gauss/Downloads/`)

The parallel measurement agent's staging file did not exist when this phase
needed the numbers, so FABER measured the parcels directly (read-only:
`stat`, `sha256sum`, `unzip -l`):

| Parcel | Bytes | SHA-256 | Members | vs relay spine |
|---|---|---|---|---|
| `SURFACE-ACCOUNT-0-R3.3-RETURN-2026-08-05.zip` | 516489 | `2fbb921cdfb511e6ea03c636024748e0f090bd8a932eadf6ead7290e6288a3ec` | 118 | exact match (canonical) |
| `SURFACE-ACCOUNT-0-R3.3.1-RETURN-2026-08-05.zip` | 434619 | `fa8ab9273dd56d26ac86218d75758dc5d07c37d2e074b674c34c58344505ec7e` | 133 | exact match |
| `SURFACE-ACCOUNT-0-R3.3.2-RETURN-2026-08-05.zip` | 491461 | `9aa53abde372426792e83ab9938a701ea2bffab3693cf65c6500922c43099675` | 145 | exact match (canonical) |
| `SURFACE-ACCOUNT-0-R3.3.2-RETURN-2026-08-05a.zip` | 515828 | `b66b6ae161e7f62babfbaf581e921b89e14854b4cd46606d6ff51e01bb741fd2` | 146 | the duplicate-upload wrapper — NOT canonical, recorded to disambiguate |
| `SURFACE-ACCOUNT-0-R3.3.3-RETURN-2026-08-06.zip` | 497184 | `ffeeedb2b4e666d3f72698f64917e91f523e11d83e10157d048e5e5bf7211edf` | 162 | exact match |

The R3.3 duplicate-upload wrapper the relay warns against was located and
measured: `SURFACE-ACCOUNT-0-R3 (3).3-RETURN-2026-08-05.zip`, SHA-256
`9577c9a2477ebed10241b5b99b40ae7e7e0ff9cb02a1c9c63b7c54775b36f439`
(536740 bytes, 119 members) — exactly the `9577c9…` outer hash the relay
names. The exact-name parcel in the table above is the canonical one, per
the relay. A second non-canonical variant also exists for R3.3.2
(`…05a.zip`, `b66b6ae1…`, 146 members); it is likewise recorded only to
disambiguate.

— FABER, R4 integrator, 2026-08-06
