# Surface Account /0 — Predecessor Identities (remeasured)

**Custody officer:** WARDEN (Claude Opus 5, 1M context).
**Measured:** 2026-08-04, 16:00:01 UTC, on host `gauss-VJFE69F11X-B0221H`.

Every hash below is a **measurement made during this custody session on this
host**, by the command shown beside it. **No hash was copied from the
commission into this document.** The commission's stated expectations are
reproduced in §1.2 *only* for the purpose of comparison, and are labelled as
expectations, never as findings.

Companion document: `OPENING-BASE-AND-CUSTODY.md` (opening base, conditions,
movement inventory, custody law).

Identities in play, kept distinct throughout:

- **Sealed IB/0 tip (lab):** `798d59f24046e942fcddcac82339a7f5f56ecede`
- **`OPENING_BASE` (lab):** `c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff`
- **Published predecessor commit (public mirror):**
  `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`

---

## 1. Public mirror — remeasured tree anchors at `ced1b2ce`

### 1.1 How they were obtained

The published mirror is
`https://github.com/Wondermonger-daydreaming/latent-lisp.git` (URL read out of
`tools/latent-lisp/sync.sh`, which was **read but never run**). A **read-only**
clone was made into this session's staging area:

```
$ git clone --no-checkout https://github.com/Wondermonger-daydreaming/latent-lisp.git \
    <staging>/public-mirror-ro
```

Its tip was verified against the live remote before any anchor was read:

```
$ git -C <clone> rev-parse refs/remotes/origin/main
ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e

$ git ls-remote https://github.com/Wondermonger-daydreaming/latent-lisp.git refs/heads/main
ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e	refs/heads/main
```

Nothing was pushed to the public mirror. No sync was run. The clone is
read-only evidence. (Lab-side push history is scoped in
`OPENING-BASE-AND-CUSTODY.md` §6.4(1).)

### 1.2 The anchors

These paths are **public-root-relative** and were queried at the public root,
not at the monorepo root:

```
$ git -C <clone> rev-parse ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e^{tree}
$ git -C <clone> rev-parse ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e:<path>
```

| Path (public-root-relative) | **Remeasured tree** | Commission's stated expectation | Agreement |
|---|---|---|---|
| `<root tree>` | `d74b7b503418e7d4267d60236d7d7f1be4a7a3b7` | *(none stated)* | — |
| `mneme/language-surface-0` | `7f5aa80a79fe905be01b6c4d2c64314ade95e78d` | `7f5aa80a79fe905be01b6c4d2c64314ade95e78d` | **AGREES** |
| `mneme/language-surface-1` | `58fdb997fc6c7beaf2636f18d86aa3c9c0bad0be` | `58fdb997fc6c7beaf2636f18d86aa3c9c0bad0be` | **AGREES** |
| `mneme/language-surface-2` | `8b1785ac2034585c6138846f41ef7da874f4fe29` | `8b1785ac2034585c6138846f41ef7da874f4fe29` | **AGREES** |
| `mneme/integration-baseline-0` | `b83d9acf8f134143064040e5b71b7ae75fc3066b` | `b83d9acf8f134143064040e5b71b7ae75fc3066b` | **AGREES** |

**Four of four remeasured anchors agree with the commission's expectations.
Zero deviations.** The agreement is reported as an outcome of independent
measurement; the measured column was written from command output before the
expectation column was filled in for comparison.

The four protected *files*, measured on the same public commit for
completeness (the commission tabulated only the four trees):

| Path (public-root-relative) | **Remeasured blob** |
|---|---|
| `lisp-plus.asd` | `4ea69df468d461c1c22937ad981e1a1ece5f0389` |
| `mneme/load-lisp-plus.sh` | `c7c150e7b3cf990f2920814632976f2fdeedf29e` |
| `mneme/load-order-matrix.sh` | `78ab9dc3ce5497bbafb3036354cd43f93f6317ab` |
| `mneme/verify-release.sh` | `43a5d7554b441a12ef2d44c090e0c8f23b2b0db6` |

---

## 2. Lab side — the byte-identity proof

Measured at both lab commits with:

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab rev-parse <commit>:<lab path>
```

where `<commit>` is the sealed IB/0 tip `798d59f2…` and then `OPENING_BASE`
`c12e96f4…`, and `<lab path>` is the subject-root-prefixed form
(`experiments/latent-lisp/…`).

| Lab path | At sealed tip `798d59f2…` | At `OPENING_BASE` `c12e96f4…` | Identical |
|---|---|---|---|
| `experiments/latent-lisp/mneme/language-surface-0` | `7f5aa80a79fe905be01b6c4d2c64314ade95e78d` | `7f5aa80a79fe905be01b6c4d2c64314ade95e78d` | **YES** |
| `experiments/latent-lisp/mneme/language-surface-1` | `58fdb997fc6c7beaf2636f18d86aa3c9c0bad0be` | `58fdb997fc6c7beaf2636f18d86aa3c9c0bad0be` | **YES** |
| `experiments/latent-lisp/mneme/language-surface-2` | `8b1785ac2034585c6138846f41ef7da874f4fe29` | `8b1785ac2034585c6138846f41ef7da874f4fe29` | **YES** |
| `experiments/latent-lisp/mneme/integration-baseline-0` | `b83d9acf8f134143064040e5b71b7ae75fc3066b` | `b83d9acf8f134143064040e5b71b7ae75fc3066b` | **YES** |
| `experiments/latent-lisp/lisp-plus.asd` | `4ea69df468d461c1c22937ad981e1a1ece5f0389` | `4ea69df468d461c1c22937ad981e1a1ece5f0389` | **YES** |
| `experiments/latent-lisp/mneme/load-lisp-plus.sh` | `c7c150e7b3cf990f2920814632976f2fdeedf29e` | `c7c150e7b3cf990f2920814632976f2fdeedf29e` | **YES** |
| `experiments/latent-lisp/mneme/load-order-matrix.sh` | `78ab9dc3ce5497bbafb3036354cd43f93f6317ab` | `78ab9dc3ce5497bbafb3036354cd43f93f6317ab` | **YES** |
| `experiments/latent-lisp/mneme/verify-release.sh` | `43a5d7554b441a12ef2d44c090e0c8f23b2b0db6` | `43a5d7554b441a12ef2d44c090e0c8f23b2b0db6` | **YES** |

**Eight of eight protected paths are byte-identical between the sealed IB/0 tip
and `OPENING_BASE`.**

And the containing subject tree itself, which subsumes all eight:

```
$ git -C <lab> rev-parse 798d59f2…:experiments/latent-lisp
6f43791fbf24abd33ea5d012fba07df38e8f52bb
$ git -C <lab> rev-parse c12e96f4…:experiments/latent-lisp
6f43791fbf24abd33ea5d012fba07df38e8f52bb
```

Identical. The subject tree did not move at all across the post-closure
housekeeping — a stronger statement than the eight-path table, and consistent
with it.

---

## 3. Cross-side correspondence

Every path measured on both sides carries the same hash on both sides:

| Path | Public @ `ced1b2ce` | Lab @ `OPENING_BASE` | Same |
|---|---|---|---|
| `mneme/language-surface-0` | `7f5aa80a…95e78d` | `7f5aa80a…95e78d` | **YES** |
| `mneme/language-surface-1` | `58fdb997…bad0be` | `58fdb997…bad0be` | **YES** |
| `mneme/language-surface-2` | `8b1785ac…f4fe29` | `8b1785ac…f4fe29` | **YES** |
| `mneme/integration-baseline-0` | `b83d9acf…3066b` (`b83d9acf8f134143064040e5b71b7ae75fc3066b`) | same | **YES** |
| `lisp-plus.asd` | `4ea69df4…5f0389` | `4ea69df4…5f0389` | **YES** |
| `mneme/load-lisp-plus.sh` | `c7c150e7…edf29e` | `c7c150e7…edf29e` | **YES** |
| `mneme/load-order-matrix.sh` | `78ab9dc3…6317ab` | `78ab9dc3…6317ab` | **YES** |
| `mneme/verify-release.sh` | `43a5d755…2b0db6` | `43a5d755…2b0db6` | **YES** |

**Claims ceiling for this section.** What is shown is *object-hash equality
between the published predecessor commit and the lab opening base for these
eight paths*, measured today on this host. It is not a statement that the
mirror is in sync overall (that is `verify-sync.sh`'s question, not run here),
nor an authentication of the mirror's history, nor a claim about any path not
listed.

---

## 4. Scope of these measurements

- Taken **2026-08-04** on host `gauss-VJFE69F11X-B0221H` by WARDEN, in one
  custody session.
- Lab side measured against the working checkout at
  `/home/gauss/Desktop/Claude-Code-Lab`; public side against a fresh read-only
  `--no-checkout` clone whose tip was verified equal to the live
  `refs/heads/main` before any anchor was read.
- Git object hashes are content identities within a repository's object model.
  They establish **byte-identity of the named trees and blobs**, and nothing
  beyond that — no authorship, no authentication against an adversary, no
  behavioural equivalence, no claim that anything was verified by any party
  other than this custody officer.
- Nothing here is independently verified. It is one officer's measurement,
  reproducible by re-running the commands quoted above.

— WARDEN, custody officer, Surface Account /0 opening round
— Claude Opus 5 (1M context), 2026-08-04
