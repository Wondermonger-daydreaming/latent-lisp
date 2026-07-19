# INTAKE DOCKET — KW-0 relay, first receipt

**Chair:** Fable (Claude Fable 5) · **Date:** 2026-07-19 (host clock) · **Standing returned:** `INTAKE-BLOCKED-MISSING-EVIDENCE`

**Deliberately uncommitted.** Gate A (complete evidence) fails; the relay forbids committing a report whose named experiment cannot be independently reproduced. This docket lives in `_intake/` (untracked) until the owner rules otherwise.

## 1. Environment (recorded at intake)

| Item | Value |
|---|---|
| Checkout | `/home/gauss/Desktop/latent-lisp` — clone of `github.com/Wondermonger-daydreaming/latent-lisp` (the PUBLIC MIRROR, not the lab canonical tree) |
| Commit / branch | `f8842f8c37ed80c5d0bd89cbec40f2c203058c10` / `main`, clean except untracked `_intake/` |
| Kernel | Linux 7.0.0-28-generic, ext4, bare host (no WSL) |
| Python | 3.12.3 |
| SBCL / any CL | **ABSENT** — no Common Lisp implementation on PATH (independent reproduction blocker even if sources arrive) |

## 2. What was received (hashes = SHA-256, computed independently)

**Relay packet** `/home/gauss/Downloads/FABLE-KW0-RELAY-PACKET.zip` — `7e0e5d14007adb70…53eb` (8 pre-extracted copies "(2)"–"(8)" in Downloads verified byte-identical to canonical):

| File | SHA-256 (prefix) |
|---|---|
| `FABLE-KW0-INITIAL-RELAY.md` | `dd4d7f9636bf38dc…` |
| `interrupted-process-recovery-report-v2-fable-safe.md` | `5593eeeafc4801bd…` |
| `BUNDLE-NOTE.md` | `0ff8daf77011528f…` |

**Review archive** `/home/gauss/Downloads/Kimi_Agent_Repository Review.zip` (60,014 B, 18:28 host clock) — extracted read-only to `_intake/kimi-review-extract/`:

| File | SHA-256 (prefix) | Role |
|---|---|---|
| `latent-lisp-independent-review.md` | `e90ddc4cf0a22c46…` | commentary |
| `lisp-plus-reduction-audit.md` | `25a596a9bb7dd29e…` | advisory (RDP-0 lineage) |
| `latent-lisp-inventory.py` / `.json` | `bb0e1ba0916ab20e…` / `f530082f53202097…` | lexical/static extractor + output |
| `reduction-disposition.py` / `.json` / `-packet.md` | `d6ca441ebd125361…` / `1877ad190d27cefa…` / `104901c0a6ddaddd…` | RDP-0 dispositions |
| `killed-witness-report-1.md` | `c410f5791524af83…` | superseded report v1 |
| `killed-witness-assumptions.md` | `ca8dc63468554…` | prose assumptions (NOT the in-bundle `ASSUMPTIONS.md`) |

## 3. Sweep performed (per intake warning)

Searched: this checkout (all branches — no candidate branch; worktree list clean); the lab canonical tree `~/Desktop/Claude-Code-Lab/experiments/latent-lisp` incl. `_staging/`; lab repo branches; `~/Desktop`, `~/Downloads`, `~/Documents`, `~`, `/tmp` for `kw-*.lisp`, `folder.py`, `harness.py`, `f6v3.py`, `*KW0*`, `*HB-0*`, `*RDP*`, `*kimi*`. `~/Desktop/Kimi` is unrelated Dec-2025 creative work. **No specimen materials found anywhere.**

## 4. Missing-evidence inventory (relay minimum vs. found)

ABSENT, all: `kw-common.lisp` · `kw-oracle.lisp` · `kw-runner.lisp` · `kw-reconstruct.lisp` · `kw-baseline.lisp` · `folder.py` · `harness.py` · `f6v3.py` · README/one-command reproduction · in-bundle `ASSUMPTIONS.md` · `HOSTILE-BASELINE-COMMISSION.md` (HB-0) · `deps/PINNED-COMMIT.txt` · raw journal snapshots S1–S7 · provider-world logs · CL & Python derived-state outputs · `evidence/stale-digest-incident/` · burden-metric output · SHA-256 delivery manifest.

**0 of 17 minimum items present.** Report v2's claim "one command reproduces every figure … ship in this bundle" is not matched by any delivered bundle. No file's existence was inferred from the report (per instruction).

## 5. Observations recorded for the eventual verification (no verification performed)

- Report v2 pins CD0 at commit `f8842f8` — identical to this mirror's current HEAD. Pin *claim* noted; `deps/PINNED-COMMIT.txt` itself absent.
- Report v2 stated MD5s + line counts for 8 sources are on record here for comparison when sources arrive.
- v1→v2 delta on record: S2 reclassification (`no attempt append`), S4 branch renamed `reconciled-executed`, S7 added; original F6 `FAIL 1.69×` retained, F6-v3 `1.192×` separate.
- The RDP-0 / inventory lane (extractor + disposition generators + outputs) IS presence-complete and could be verified as a separable lane — not run, pending owner's word, since the relay orders a full stop at intake.
- Mirror caveat: this checkout is the one-way destructively-synced public mirror. Any eventual commits in this sequence must land in the lab canonical tree and reach here through sync — committing directly here would be pruned.

## 6. Next executable obligation

Obtain from Kimi-k3 the complete KW-0 delivery (all §4 items + SHA-256 manifest). On receipt: preserve read-only, verify manifest, install SBCL, then execute the relay's verification sequence §§1–9 and HB-0 (control authored before reading `kw-baseline.lisp`).

— Fable, Claude Fable 5, at intake. No gates discharged; nothing committed or pushed.
