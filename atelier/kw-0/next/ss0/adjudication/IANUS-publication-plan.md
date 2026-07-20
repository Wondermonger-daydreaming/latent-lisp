# IANUS — SS-0 Step-8 Publication Plan

*Surveyor: IANUS (publication-survey pass, 2026-07-20). This is a PLAN, not an execution. The chair writes the adjudication report and runs the copies. Nothing below has been moved.*

---

## 0. The one-way door (the fact that governs everything here)

- **`experiments/latent-lisp/` auto-syncs to the public GitHub mirror** (`Wondermonger-daydreaming/latent-lisp`) via `tools/latent-lisp/sync.sh`, `rsync -a --delete`, on any lab commit touching the tree.
- **`_staging/` is excluded from BOTH the mirror (`--exclude '_staging/'`) and lab git (`experiments/latent-lisp/.gitignore: _staging/`).** So everything the bench produced is currently invisible to the public and to `git`.
- **Publishing = copying OUT of `_staging/` (and out of `~/Downloads/`) INTO `experiments/latent-lisp/atelier/kw-0/next/ss0/`.** The instant a copied file is committed, it is public. There is no "publish privately."
- **`--delete` is destructive:** anything you place directly in the public mirror repo (not via the lab tree) is pruned on the next sync. All step-8 artifacts must land under `.../ss0/` in the lab tree and reach the public repo *through* a lab commit. (MIRROR-CLOBBER / receipt-seed scar.)
- Corollary: `~/Downloads/ss0-seats/reveal/` is OUTSIDE the repo entirely — it never publishes until copied in.

---

## 1. Protocol step-8 requirement (quoted verbatim)

From `SS0-PROTOCOL.md`, §Freeze procedure, step 8:

> **8. Adjudication packet unsealed; plaintext published; hash verified against step-2 commitment; bands applied as written. Both implementations, all evidence, and the full ledger published together.**

Step-2 (what was sealed and is now to be unsealed):

> **2. Adjudication packet completed (mutation battery co-authored with Kimi; interpretation bands; run-VOID conditions) and sealed: full text held outside the mirror-synced tree; its SHA-256 committed publicly. The sealed extension effect type is hash-committed the same way.**

Ledger reinforcement (STEP 7 COMPLETE entry): *"step 8 — publish sealed plaintexts (verify `673e1126…`/`7bf5abad…`), apply the frozen interpretation bands, publish everything together."* And the AMENDMENT-3 promise: *"the plaintext publishes at step 8 as planned."*

**So step 8 = five obligations:** (a) unseal + publish both sealed plaintexts; (b) verify their hashes against step-2 commitments; (c) write & publish the adjudication report with the frozen bands applied; (d) publish **both implementations** (base + extension, both seats); (e) publish **all evidence** and the **full ledger** — together, in one act.

---

## 2. Sealed-plaintext hash check (done now, pre-publication)

Both sealed files verified on this host against the ledger's step-2 commitments:

```
673e1126c5cf91baa955061231ddc64e7c245017163ffe34c4e669e533473aaf  SS0-ADJUDICATION-SEALED.md   ✓ MATCHES commitment
7bf5abada93831c6193538100441fcf7af8aa7649abca2d8ac30d16b246505bf  SS0-EXTENSION-SEALED.md      ✓ MATCHES commitment
```

Source: `_staging/ss0-sealed/`. **Both PASS.** The chair must re-run this check at copy time (see §5) and record it in the adjudication report — a step-8 requirement, not a formality.

---

## 3. Publication file plan (source → destination)

Proposed layout under `experiments/latent-lisp/atelier/kw-0/next/ss0/` (existing protocol/brief/API/seating/draft/ledger docs and `substrate/` stay where they are). New subtrees: `adjudication/`, `extension/`, `seats/{a,b}/{base,extension}/`, `bench/`.

### 3a. The two sealed plaintexts + adjudication report → `adjudication/`

| Source | Destination |
|---|---|
| `_staging/ss0-sealed/SS0-ADJUDICATION-SEALED.md` | `adjudication/SS0-ADJUDICATION-SEALED.md` |
| `_staging/ss0-sealed/SS0-EXTENSION-SEALED.md` | `adjudication/SS0-EXTENSION-SEALED.md` |
| **(chair writes new)** | `adjudication/SS0-STEP8-ADJUDICATION.md` — bands applied as written, per-measure verdicts, hash re-verifications, docketed asymmetries carried to the bands (execution asymmetry, Seat-B reader base-integrity PARTIAL, refusal-protocol divergence), and the `TOY-SCALE`-class qualifier on any F5 statement |

*(Note: `SS0-ADJUDICATION-PACKET-DRAFT.md` is already public — the redacted draft. The SEALED file is the full text it pointed at; publishing both is correct and shows the seal was honored.)*

### 3b. Extension reveal package → `extension/`  (currently OUTSIDE the repo, in `~/Downloads/`)

| Source | Destination |
|---|---|
| `~/Downloads/ss0-seats/reveal/REVEAL-MESSAGE.txt` | `extension/REVEAL-MESSAGE.txt` |
| `~/Downloads/ss0-seats/reveal/EXTENSION-SCENARIOS.md` | `extension/EXTENSION-SCENARIOS.md` |
| `~/Downloads/ss0-seats/reveal/REVEAL-SHA256SUMS.txt` | `extension/REVEAL-SHA256SUMS.txt` |
| `~/Downloads/ss0-seats/reveal/substrate-delta/ss0-harness.py` | `extension/substrate-delta/ss0-harness.py` |
| `~/Downloads/ss0-seats/reveal/substrate-delta/ss0_provider.py` | `extension/substrate-delta/ss0_provider.py` |
| `~/Downloads/ss0-seats/reveal/substrate-delta/ss0-provider.lisp.text` | `extension/substrate-delta/ss0-provider.lisp` **(RENAME `.lisp.text` → `.lisp`)** |

The `SS0-EXTENSION-SEALED.md` inside `reveal/` is the same bytes as the one going to `adjudication/` (`7bf5abad…`); publish it once in `adjudication/`, not twice. The v1.1 substrate delta is the batch-metadata provider change the extension was built against — it belongs public so the extension deltas are reproducible. **Rename caution:** the already-public `substrate/` publishes `.lisp` raw (verified: `ss0-provider.lisp`, `ss0-substrate.lisp`, `test-cl.lisp` are tracked with real `.lisp` extension), so the reveal's `.lisp.text` channel-workaround name must be normalized back to `.lisp` on copy.

### 3c. Both seats' frozen sources + docs → `seats/{a,b}/{base,extension}/`

Copy **only the frozen deliverable files** — never the `incoming/` custody dirs (§4).

**Seat A base** (`_staging/ss0-deliveries/seat-a/` → `seats/a/base/`): `ss0.py`, `ss0-reader.lisp`, `README.md`, `ASSUMPTIONS.md`, `FREEZE-SHA256SUMS.txt`.
**Seat A extension** (`.../seat-a/extension/` → `seats/a/extension/`): `ss0.py`, `ss0-reader.lisp`, `README-EXTENSION.md`, `CHANGE-STATEMENT.md`, `EXTENSION-DELTA.diff`, `FREEZE-SHA256SUMS-EXT.txt`.
**Seat B base** (`.../seat-b/` → `seats/b/base/`): `ss0_runner.py`, `ss0_reader.lisp`, `README.md`, `FREEZE-SHA256SUMS.txt`.
**Seat B extension** (`.../seat-b/extension/` → `seats/b/extension/`): `ss0_runner.py`, `ss0_reader.lisp`, `README-EXTENSION.md`, `CHANGE-STATEMENT.txt`, `COMPLIANCE-STATEMENT.txt`, `FREEZE-SHA256SUMS-EXT.txt`.

### 3d. Bench log + key transcripts + teeth + mutant diffs → `bench/`

**Publish (essential, small — all the human-readable verdict-bearing record):**

| Source (under `_staging/ss0-bench/`) | Destination (under `bench/`) |
|---|---|
| `BENCH-LOG.md` | `BENCH-LOG.md` |
| `selftest-base-v1.0.txt` | `selftest-base-v1.0.txt` |
| `afel-base-recount.txt`, `void-afel-ext.txt` | same names |
| `void1-read-sites.txt`, `void1-void3-teeth-transcript.txt`, `void3-audit.txt` | same names |
| `seatb-base-integrity-finding.txt` | same name |
| `teeth/planted-void1-runner.py`, `teeth/planted-void3-reader.lisp` | `teeth/` |
| `mutants/DIFF-{a,b}-m{1..6}.diff` (12 files, ~48K) | `bench/mutants/` — **the disclosed diffs named in the ledger, hashes on record; these are canonical** |
| `seat-a/*.txt` and `seat-b/*.txt` run transcripts (harness-*, recover-*, recovery-modes-*, crosslang-*, ext-modes, pfamily-baseline, succeed-unresolved, clreader-*) — 17 files, ~1–10K each | `bench/seat-a/`, `bench/seat-b/` |

**Essential vs bulk verdict for the evidence/ corpse trees:**

- The four `seat-{a,b}/{base,ext}/evidence/` trees are the raw per-scenario execution corpses (`corpse.snapshot`, `death-record.json`, `provider.log`, `records.log`, receipts per S1–S7 + E1–E3). Total ~1 MB, ~180+ files. They are **deterministically reproducible** from the published seat sources + published substrate (v1.0 + v1.1 delta) via the published harness.
- **Recommendation:** publish a **`deaths.json` index per seat** (`seat-a/base/evidence/deaths.json`, and the ext + seat-b equivalents — the 4 summary manifests) plus the run transcripts in §3d, and **archive the full raw corpse trees in the backup tarball only** (`SS0-BENCH-2026-07-20.tar.gz`, already exists, `cf1610c7…`). Rationale: the transcripts + BENCH-LOG + deaths.json carry the *evidentiary content* a reader needs; the raw corpses are bulk that inflates the public mirror and is re-derivable. **This is a chair judgment call flagged in §7-Q1** — the protocol says "all evidence," and a strict reading favors publishing the full trees (they are only ~1 MB and feasible in-repo). IANUS's lean: publish the indices + transcripts, tarball the raw corpses, and *state in the adjudication report that the full trees live in the committed tarball* so "all evidence" is satisfied by reference.
- The **mutant working directories** (`mutants/{a,b}-m{1..6}/`, ~1.4 MB, each bundling a full substrate copy) are **NOT published** — the 12 `DIFF-*.diff` files are the disclosed canonical form (ledger names them with hashes), and the working dirs are redundant + reconstructible. They stay in the tarball.

### 3e. The full ledger

`SS0-FREEZE-LEDGER.md` is **already public and tracked** at `.../ss0/SS0-FREEZE-LEDGER.md`. Step 8 requires it "published together" — satisfied by the same commit that adds everything else (it will be updated with a "STEP 8 COMPLETE" entry). No move needed; just the final append.

---

## 4. What must NOT publish (paranoia list — strip before commit)

1. **All `incoming/` custody dirs** — `seat-a/incoming/`, `seat-a/extension/incoming/`, `seat-b/incoming/`. These hold the raw channel-delivery wrappers: `SS0-SEAT-DELIVERABLES.zip`, `SS0-SEAT-EXTENSION-v1.1.zip`, `WRAPPER-DELIVERY.zip`, `SS0-SEAT-B-QWEN-INITIAL.zip`, and `.py.txt`/`.lisp.txt` channel-workaround duplicates. Custody evidence, not deliverables; kept in `_staging/` + backups. (The `.txt` duplicates are byte-identical to the real files — publishing both is noise.)
2. **All `__pycache__/` dirs and `*.pyc` files** — present in every `substrate/` copy under the bench trees AND in `seat-b/extension/__pycache__/ss0_runner.cpython-312.pyc`. Never publish compiled bytecode. **⚠ Pre-existing hygiene bug:** the *already-public* `.../ss0/substrate/__pycache__/` contains 2 `.pyc` files that are untracked-in-git but WOULD be carried by the rsync mirror (rsync copies the working tree, not the git index). Recommend the chair `rm -rf` that `__pycache__` before the step-8 commit/sync so the mirror is clean, and add `__pycache__/` + `*.pyc` to `experiments/latent-lisp/.gitignore` if not already covered.
3. **The mutant working directories** (`mutants/{a,b}-m{1..6}/`) — bulk + redundant with the diffs; tarball only (§3d).
4. **The raw evidence corpse trees** if the chair takes IANUS's lean (§3d/§7-Q1) — tarball only.
5. **`seat-b/base/seat-b-adapter.py`** (under the bench tree) — this is a chair-authored bench harness adapter, not a seat deliverable. Publish it under `bench/` **only if** it is needed to reproduce Seat B's runs (Seat B has no CLI of its own); label it clearly as chair-authored bench scaffolding, not Seat B's work. Do NOT let it land in `seats/b/`.
6. **Nothing sealed beyond the two named files** — confirm no other `_staging/ss0-sealed/` content exists (verified: only the two `.md` files are there).

No secrets/credentials found in the staging trees. The only "must stay sealed until now" content is the two plaintexts, which step 8 explicitly unseals.

---

## 5. Hash-integrity steps required at copy time (chair MUST run + record)

1. **Sealed plaintexts:** re-verify `sha256sum adjudication/SS0-ADJUDICATION-SEALED.md adjudication/SS0-EXTENSION-SEALED.md` == `673e1126…` / `7bf5abad…` *after* copy into the public tree. (Guards against a copy corrupting bytes.) Record in the adjudication report — this is the literal step-8 "hash verified against step-2 commitment."
2. **Seat sources vs freeze manifests:** for each `seats/{a,b}/{base,extension}/`, run `sha256sum -c FREEZE-SHA256SUMS*.txt` in the destination and confirm the published bytes match the frozen commitments:
   - Seat A base: `ss0.py eac91d02…`, `ss0-reader.lisp 1c416eb9…`, `README.md 90bf996f…`, `ASSUMPTIONS.md d204335a…`
   - Seat A ext: `ss0.py b27b0b09…`, `ss0-reader.lisp 1bf3b6e6…`, `README-EXTENSION.md 3e9ff353…`, `CHANGE-STATEMENT.md 0249b0a7…`, `EXTENSION-DELTA.diff d952633b…` *(the manifest also lists `incoming/*.zip` hashes — those files are NOT published; verify them in `_staging/` if desired, do not copy)*
   - Seat B base: `ss0_runner.py 2f1af6a7…`, `ss0_reader.lisp 7a154e06…`, `README.md 90243495…`
   - Seat B ext: `ss0_runner.py 331f9ef8…`, `ss0_reader.lisp 113c05de…`, `README-EXTENSION.md 984efaed…`, `CHANGE-STATEMENT.txt 788554e7…`, `COMPLIANCE-STATEMENT.txt d358c36c…`
3. **Extension reveal package vs `REVEAL-SHA256SUMS.txt`:** verify `REVEAL-MESSAGE.txt 9e1b06b7…`, `EXTENSION-SCENARIOS.md 83fe6f17…`, `substrate-delta/ss0-harness.py 4aa34b05…`, `substrate-delta/ss0_provider.py dde29107…`, `substrate-delta/ss0-provider.lisp a1f1e0ce…` **BEFORE the `.lisp.text`→`.lisp` rename** (the manifest hashes the content; the rename is name-only and does not change bytes, so the hash still matches — verify content, then rename).
4. **Mutant diffs:** the 12 `DIFF-*.diff` hashes are recorded in the ledger's STEP 7 COMPLETE entry (`b67073be`, `3485d1af`, … `cd97519a`); `sha256sum` the published copies against those.
5. **Ledger + protocol self-hashes:** already recorded; unchanged by this operation except the ledger's new step-8 append.

**Order:** verify in `_staging/` → copy → re-verify in destination → strip strays (§4) → `git add` explicit paths (never `git add -A`; the bench tree has strays) → `git diff --check` → commit → the sync fires automatically. Do a final `git status`/`ls` of the public tree to confirm no `__pycache__`/`incoming`/zip slipped in.

---

## 6. Recommended commit shape

**One commit** ("SS-0 step 8: unseal, adjudicate, publish everything together") satisfies the protocol's "published together" clause and triggers exactly one mirror sync. Given the file count, the chair may stage in the working tree and verify the whole `.../ss0/` subtree in one `git status` before the single commit. The adjudication report (`SS0-STEP8-ADJUDICATION.md`) should be written and included in the same commit — it is the keystone the bands are "applied as written" in.

---

## 7. Open questions for the chair

- **Q1 — evidence-tree depth (the one real judgment call):** publish the full raw corpse trees (~1 MB, ~180 files, literal reading of "all evidence") or IANUS's lean (deaths.json indices + run transcripts public; raw corpses in the committed tarball, "all evidence" satisfied by reference)? Either is defensible; the report must state which reading was taken and where the full evidence lives.
- **Q2 — the tarball itself:** `memory/backups/SS0-BENCH-2026-07-20.tar.gz` (`cf1610c7…`) lives OUTSIDE `experiments/latent-lisp/`, so it is NOT auto-published. If the chair wants the archival tarball referenced from the public record, cite its name+hash in the report but do NOT copy the tarball into the mirror (it contains the raw evidence + mutant working copies the size budget is avoiding, and would defeat the point). Confirm intent.
- **Q3 — `seat-b-adapter.py`:** publish as labeled chair-authored bench scaffolding under `bench/` (needed for Seat B reproducibility), or keep it archival-only? (§4.5)
- **Q4 — pre-existing `substrate/__pycache__` in the public tree:** approve the `rm -rf` + `.gitignore` hygiene fix as part of step 8, or leave it (it is currently reaching the mirror on every sync)?
- **Q5 — draft vs sealed adjudication packet:** both `SS0-ADJUDICATION-PACKET-DRAFT.md` (public) and `SS0-ADJUDICATION-SEALED.md` (to publish) will coexist. Confirm the draft stays (it shows the seal was honored) rather than being superseded/removed.

---

*IANUS stood at the door and counted. The sealed hashes match; the frozen manifests are ready to re-verify; the strays are named. The chair carries it through.*
