# PIN SITES — every place in the tree that names the old identity of `verify-release.sh`

*PLINTH, 2026-09-21. Read-only census. Classes: **(a)** a DATED historical capture that must stay exactly as
it is · **(b)** a CURRENT pointer that the landing makes stale.*

**Searched:** `experiments/latent-lisp/`, `docs/`, `notes/`. (`memory/` out of scope by the commission.)
**Terms:** old blob `fb99a6b6…` · old file sha256 `ecb03c9d…` · and, as a secondary sweep, every
`verify-release.sh:<line>` pointer inside `experiments/latent-lisp/`.
**Commands:** `grep -rn "fb99a6b6" experiments/latent-lisp/ docs/ notes/` (exit 0) ·
`grep -rn "ecb03c9d" …` (exit 0) · `grep -rno "verify-release\.sh:[0-9]\+" experiments/latent-lisp/` (exit 0).
`docs/` produced **zero** hits on all three sweeps.

---

## §1 — OLD BLOB `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` (7 hits)

| # | path:line | exact text (long rows elided with `…`) | class | needed |
|---|---|---|---|---|
| 1 | `experiments/latent-lisp/warrant-calculus/LMP0-clauses-CD-LCI.md:36` | ``| S15 | `experiments/latent-lisp/mneme/verify-release.sh` | `ad6c95e9` 2026-08-23 | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` | Carried DECLARED row, verbatim at `:360` — quoted in full in **LCI/0 §3** below. |`` | **(a) by rule, (b) by content** | **Not edited.** It is a dated extraction stamped `ad6c95e9` 2026-08-23 and blob-pinned in `warrant-calculus/PROVENANCE.md` (`32af658b…`); ARCHITECTURE-0-STATUS.md **ADDENDUM 25 item 7** forbids editing `warrant-calculus/` extractions for a record of this kind. Its blob citation and its `:360` line citation both go stale on landing; the **erratum records the successor identity beside it**. |
| 2 | `experiments/latent-lisp/mneme/release-floor-erratum-0/SUCCESSOR-RETURN.md:45` | ``| `verify-release.sh` blob, successor | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` |`` | (a) | nothing — RELEASE FLOOR ERRATUM /0's own identity table, true of `ad6c95e9` |
| 3 | `experiments/latent-lisp/mneme/release-floor-erratum-0/R2B-RECEIPT-CANDIDATE-2026-08-23.md:20` | ``subject OID `ee3ff1cc9b436f82a2fcb27627b133de09fa1027` · floor blob `fb99a6b6…` · tooth-10 blob `92e6e430…``` | (a) | nothing — a dated receipt |
| 4 | `experiments/latent-lisp/mneme/release-floor-erratum-0/successor/verify-release.PREDECESSOR-to-SUCCESSOR.diff:2` | `index 012b3341..fb99a6b6 100755` | (a) | nothing — a stored diff header; editing it would corrupt the artifact |
| 5 | `experiments/latent-lisp/mneme/release-floor-erratum-0/receipt-completion/01-original-joint-instruction-and-countersignature.md:21` | ``* floor blob: `fb99a6b64c77640b1dd81a8bf39f5673c22856a4``` | (a) | nothing — a quoted joint instruction |
| 6 | `notes/2026-08-23-session-handoff-the-day-of-three-stops.md:75` | ``…`4369e982…`, 0 symlinks. Bound was `6b50cd50…` (subject `ee3ff1cc…`, floor blob `fb99a6b6…`). Transport…`` | (a) | nothing — a dated handoff |
| 7 | `notes/2026-09-21-return-02-the-demonstration-and-the-passage-from-sentence-to-record.md:68` | ``…blob `fb99a6b6…` → candidate `8cbc50c7…`) and its last change went through RELEASE FLOOR ERRATUM /0 with…`` | (a) | nothing — today's dated return; it already names both identities |

---

## §2 — OLD FILE sha256 `ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` (5 hits)

All five lie inside `experiments/latent-lisp/mneme/release-floor-erratum-0/`. **All class (a).**

| # | path:line | exact text | class | needed |
|---|---|---|---|---|
| 8 | `…/release-floor-erratum-0/SUCCESSOR-RETURN.md:46` | ``| `verify-release.sh` file sha256, successor | `ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` |`` | (a) | nothing |
| 9 | `…/release-floor-erratum-0/SUCCESSOR-RETURN.md:194` | `verify-release.sh sha256: ecb03c9d…  (identical at both endpoints)` | (a) | nothing |
| 10 | `…/release-floor-erratum-0/successor/IDENTITY-CAPTURE-successor.txt:10` | `verify-release.sh sha256: ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` | (a) | nothing — a machine identity capture |
| 11 | `…/release-floor-erratum-0/successor/IDENTITY-CAPTURE-successor.txt:18` | (same line, second endpoint) | (a) | nothing |
| 12 | `…/release-floor-erratum-0/successor/13-dirty-entry.transcript.txt:11` | ` script sha: ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` | (a) | nothing — a run transcript |

---

## §3 — SECONDARY SWEEP: line-number pointers into the script (8 hits inside `experiments/latent-lisp/`)

Not named in the commission's grep, but load-bearing: the candidate inserts at old line 222, so **every old
line ≥ 233 moves +25**. Text quoted at those sites is unchanged; only the addresses move.

| # | path:line | points at | after landing | class | needed |
|---|---|---|---|---|---|
| 13 | `warrant-calculus/LMP0-clauses-CD-LCI.md:1155` | `verify-release.sh:360` (the carried `lci0` DECLARED row) | `:385` | (a) by ADDENDUM 25 item 7, (b) by content | **Not edited.** The quoted row text is byte-identical in both blobs; only the address is stale. Recorded in the erratum §2. |
| 14 | `warrant-calculus/LMP0-clauses-CD-LCI.md:1158` | `verify-release.sh:355` (the "DECLARED, NOT EXECUTED" header) | `:380` | same as 13 | same as 13 |
| 15 | `atelier/mneme-debt-disposition-0/p9/census/overclaim-census.md:29` | `verify-release.sh:366` (the `ml0` row) | `:391` | (a) | nothing — a dated census inside a disposed lane; its subject sentence is precisely the one this repair replaces, which the census recorded as an overclaim |
| 16 | `atelier/mneme-debt-disposition-0/RETURN.md:19` | `verify-release.sh:337` | `:362` | (a) | nothing — a dated return |
| 17 | `atelier/mneme-debt-disposition-0/p9/ERRATUM-P9-0.md:63` | `verify-release.sh:337` | `:362` | (a) | nothing — a dated, accepted erratum |
| 18 | `atelier/p10-real-gate-0/F1-MAP.md:20` | `verify-release.sh:336` | `:361` | (a) | nothing — an unmerged candidate lane's dated map |
| 19 | `atelier/p10-real-gate-0/RETURN.md:27` | `verify-release.sh:336` | `:361` | (a) | nothing — same lane |
| 20 | `mneme/portable-judge-0/VECTOR-CLASSIFICATION-CANDIDATE.md:380` | `verify-release.sh:193` | `:193` — **unchanged** (before the insertion point) | (a) | nothing; and nothing goes stale |

Line-number pointers also exist across `notes/` (census files, handoffs, relays — e.g.
`notes/census-2026-08-22/05-VERAX-claims.md`, `notes/2026-09-20-session-handoff-the-order-of-parents.md:46`,
`notes/2026-09-17-session-handoff-the-gate-i-added.md:45`) and in the frozen
`experiments/jev-standing-pilot/v2/` case sources. **All are dated records — class (a), nothing needed.**
Several of them exist precisely to say that `verify-release.sh:366` *still reads "stranger audit owed"*;
that sentence becomes historically true rather than presently true, which is what those notes already say.

---

## §4 — COUNTS AND THE HONEST RESIDUE

- **§1 + §2 identity hits: 12.** Class (a): **10**. Class (a)-by-rule-but-(b)-by-content: **1** (hit 1, the
  S15 row). Pure class (b) requiring an edit: **0**.
- **§3 line pointers inside `experiments/latent-lisp/`: 8** — 7 go stale (+25), 1 unaffected; 2 of them
  (hits 13, 14) are the S15 row's dependent citations. **None is edited**, by ADDENDUM 25 item 7 and by the
  general rule that a dated record is evidence, not navigation.
- **Therefore: the landing requires no edit to any pin site.** What it requires is that the erratum exist,
  so that a reader who needs the *current* object is not left following a 2026-08-23 address.
- **Residue I could not close:** the reviewed archive sha256 `ec98ff8d…` given in the commission was not
  found anywhere in the tree by these greps and was **not re-derived**; and `corpus/voices/received/` holds
  no 2026-09-21 file, so the ruling office's review-acceptance is **not yet docked**.

*— PLINTH, 2026-09-21. Census only; nothing edited.*
