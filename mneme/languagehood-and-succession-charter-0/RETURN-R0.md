# RETURN — LANGUAGEHOOD & SUCCESSION CHARTER /0, DRAFT R0

**Disposition sought: CANDIDATE R0 RETURNED — NOT ADOPTED.**
Chair: Claude Fable 5. Date: 2026-08-11. Commission:
`LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0` (owner, 2026-08-11), documentary
constitutional work only.

---

## 1. Identities

- **Repository:** `/home/gauss/Claude-Code-Lab` (lab repo, origin
  `github.com/Wondermonger-daydreaming/Claude-Code-Lab`).
- **Branch:** `many-acts-0-candidate`, tracking `origin/many-acts-0-candidate`.
- **Starting HEAD (commission received):**
  `3ea0e7d544f661e6399c597ddad90b9bd196af14`.
- **Pre-commit HEAD (this file written):** `b0e4e93c…` — the two commits
  between are **benign Stop-hook checkpoints** containing only
  `tools/ledger/agents.jsonl` auto-log rows (`1ac0b827`, `b0e4e93c`; 3+2
  lines; outside the subject tree; neutral messages; the expected 2026-07-24
  checkpoint behavior).
- **Candidate commit:** necessarily recorded **outside this file** — a file
  cannot contain the hash of the commit that includes it (the house law that a
  manifest may never include its own hash). It is recorded in: the commit
  itself (message marked *candidate R0*), the campaign log entry filed with
  it, and the chair's final return message.
- **Lane state:** held at receipt `a963761a` (Ruling 6B closure).
  Chair-verified and registrar-re-verified:
  `git diff --stat a963761a..HEAD -- experiments/latent-lisp/` is **empty**
  pre-commit — zero subject-tree changes since the receipt. Between the
  receipt and the commission sit seven lab-side commits (clauding artifacts,
  ledger tooling, checkpoints), none touching `experiments/latent-lisp/`.
- **Mirror:** unreachable from this work **by construction** — `sync.sh`
  publishes lab **main**'s committed subject tree only (read at source this
  session); this parcel exists only on the candidate branch and is never
  merged by this work.
- **Controlling instruments (chair-read verbatim this session):** Owner
  Ruling 6B (`eaf82ddc` filing; acceptance, no-R2, B7 closed, stop clause,
  quiescent-tree rider) and the Many Acts /0 R1 Adoption Owner Ruling
  (adoption commit `2b69c18c` — cite this, not `7f417d49`, which is the
  sync-incident revert; Rider 1 exact sentence; Riders 2–6; audit caps).

## 2. The candidate parcel (changed files — complete list)

All eight files are **new**, all confined to
`experiments/latent-lisp/mneme/languagehood-and-succession-charter-0/`:

1. `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.md` — principal charter
   (chair-drafted).
2. `EVIDENCE-LEDGER-R0.md` — 46 rows EV-01…EV-46 (agent-drafted, TABULARIUS;
   chair-reviewed; chair-corrected EV-15 and chair-appended EV-45/EV-46).
3. `CLAIM-CEILING-R0.md` — operational table (chair-drafted).
4. `OWNER-DOCKET-R0.md` — forks F-1…F-10, full form (chair-drafted).
5. `SUCCESSION-DOCKET-R0.md` — campaigns + admission gates, nothing commenced
   (agent-drafted, VIATOR; chair-reviewed; two chair fixes noted below).
6. `SOURCE-MANIFEST-R0.txt` — sources with read-extent and `[via digest]`
   markers (agent-drafted, VIATOR; chair-patched three times: P5 protocol
   path resolved to `notes/`, §-sign typo, Slice /0 additions).
7. `RETURN-R0.md` — this file (chair-drafted).
8. `SHA256SUMS.txt` — computed after this file was finalized; deterministic
   lexical path order; excludes itself.

**No file beyond the commissioned eight was created in the parcel.** Three
working digests (TABELLIO / EXEGETA / CONCORDATOR, same-model agents) exist
**uncommitted** at `_staging/charter0-r0/` per the lab's staging convention;
they are working notes, not sources, are cited only as such (EV-15's row says
so on its face), are not part of the parcel, and every load-bearing quotation
in the parcel was re-read at its source except where a sign-off states
otherwise.

## 3. Location deviation (commission §4)

The commission preferred `mneme/languagehood-and-succession-charter-0/`.
Repository convention homes the mneme project at
`experiments/latent-lisp/mneme/` (there is no repo-root `mneme/`), so the
parcel lives at `experiments/latent-lisp/mneme/languagehood-and-succession-charter-0/`
— the commission's name, the repository's home. Archive naming (§7 below)
likewise follows the established house convention (`.tar.gz` + `.sha256`
sidecar in `~/Downloads/`) over the commission's fallback zip name, which the
commission licenses when a convention governs.

## 4. Verification performed (commission §9, in order)

1. **Changes confined to the charter directory** — `git status --short`:
   zero tracked modifications; the only additions are the parcel files
   (untracked until the candidate commit) plus pre-existing untracked files
   that predate the commission (enumerated in the commission-time `git
   status`, preserved untouched). **PASS.**
2. **No sealed or prior file changed** —
   `git diff --stat a963761a..HEAD -- experiments/latent-lisp/` empty
   (also re-verified independently by the ledger agent at `b0e4e93c`);
   post-commit, the same diff shows only the new parcel directory. **PASS.**
3. **Every cited path resolves** — extraction script over all parcel files:
   146 distinct cited paths; 130 resolved directly; 14 short-form citations
   resolved at their conventional homes (`mneme/architecture/`,
   `integration-baseline-0/`, `spec/lci0-review/`, `language-act-0/`,
   `_staging/charter0-r0/`); 2 were parser artifacts (manifest header
   words), not citations. Intentionally-historical sources are flagged where
   cited (frozen original charter; `MANIFEST.md`; the untracked
   `PROJECT-STATE-ASSESSMENT`, cited only as a no-standing working document).
   **146/146 PASS.**
4. **Every proposed holding visibly marked** — 10 `[PROPOSED]` markers in
   the charter; sweep for adopted-labeling of the languagehood conclusion
   found none outside lawful phrases (ADOPTED LAW legend definitions,
   "not adopted", stratum references). **PASS.**
5. **Open rungs stay open in every file** — rungs 6–8, 10 are OPEN (with
   their jurisdiction/blocker annotations) in charter §E, ledger rows,
   claim ceiling, and succession docket; rung 9 is REFUSED-as-a-rung
   everywhere; no file upgrades any of them. **PASS** (chair read of all
   five documents).
6. **Fork parity** — F-1…F-10 each appear exactly once in charter §I and
   exactly once as a docket section: 10/10 both sides. **PASS.**
7. **`SHA256SUMS.txt` recomputed and verified** — computed after this file
   was finalized; `sha256sum -c` green; result recorded in the final return
   message and campaign log (it cannot be recorded here without a circular
   hash). **See final message.**
8. **`git diff --check`** — clean. **PASS.**
9. **Documentary lint** — no repository-local documentary lint exists for
   parcels (the repo's lints target skills and the mirror); none was run,
   none was installed (commission bars new dependencies). **N/A, recorded.**
10. **Rider-2 wording sweep** — 12 occurrences of the forbidden wordings in
    the parcel, every one inside a quoted prohibition or rider declaration;
    zero assertive uses. **PASS.**

## 5. Unresolved conflicts and source cautions (nothing harmonized)

1. **Predecessor charter relationship** — two unadopted candidate charter
   texts precede R0 (original; P1 with owner-directed lattice). R0 neither
   supersedes nor defers to them by its own force: **fork F-1.**
2. **Ladder vs lattice** — the commission's prescribed 10-rung ladder is the
   structure Owner Ruling 8 struck. R0 drafted under the standing ruling
   (numbering declared expository, §E.0) and docketed the divergence:
   **fork F-5.**
3. **Three NOT-FOUND receipts** (registrar): no Census /0 (R0) integration
   receipt; no standalone Parcel-B integration receipt (the Ruling-6 merge
   `48e59db3` is recorded in the campaign log only); no receipts under
   `language-many-acts-0/export-census/`. Recorded, not repaired.
4. **Three self-disclosed conflicts in the ruling chain** (all already
   disclosed by the record itself, preserved as-is): the Rider 3 / "Rider 2"
   clerical error settled at Ruling 3; two same-day filings titled
   "Ruling 2" (both filenames preserved — always disambiguate by full
   filename); Ruling 5A's deliberate numbering to avoid a homonym with
   Parcel-B Ruling 6.
5. **Registrar-derived commit identities** — the manifest's introducing
   commits (`eaf82ddc`, `ba2ffe8b`, `12388ff9`, …) and the Charter-P1 sha
   `b437a70f…` are registrar-derived from one `git log` pass and one
   crossref file; the chair verified the two controlling instruments'
   contents directly but did not re-derive every introducing commit.
6. **EV-15 chair correction, on the record** — the ledger's absence claim
   for "hosted/embedded" was **narrowed by the chair's own re-search**,
   which found two Slice /0 lab-side uses the digest search missed
   (EV-45/EV-46; charter §B.5, §C.8, rung 3 amended accordingly). The row
   remains an absence-found-by-searching as to the whole-language
   classification — twice-searched, still only a search.
7. **Recommendation divergence from the commission's expectation** — stated
   in full at charter rung 3: crossed at the adopted stratum only; "hosted"
   ratifiable as jurisdictional description, not as evidenced
   classification; the stratum annotation belongs inside the ratified
   sentence.

## 6. Owner forks

F-1 (governing candidate text) · F-2 (cross-lane legend) · F-3 (ratify
stratified languagehood + B.0) · F-4 ("successor" as marked trajectory) ·
F-5 (ladder/lattice semantics) · F-6 (same-substrate seeded evaluator
standing) · F-7 (T9: DG0's J2) · F-8 (latent-machine intent language) ·
F-9 (full corpus vs bounded profiles) · F-10 (CI0/DG0 minima). Full form,
with options, evidence, consequences, recommendations, and deferral
defaults: `OWNER-DOCKET-R0.md`.

## 7. Return archive

Created **after** the candidate commit, outside the subject tree, per house
convention:
`~/Downloads/languagehood-and-succession-charter-0-r0-2026-08-11.tar.gz`
(+ `.sha256` sidecar). Contents: the candidate directory and the Git identity
information needed to inspect the exact candidate (branch, starting HEAD,
candidate commit, lane-receipt anchor). Checksum verified after creation;
identity recorded in the final return message and the campaign log.

## 8. Custody statement (explicit)

**Nothing was merged. Nothing was published** (no push to the public mirror;
the mirror cannot be reached from this branch by the sync's own construction).
**Nothing was adopted, and nothing herein adopts itself. No evaluator, runner,
surface form, ASDF system, package export, test, vector, fixture, specimen,
or implementation lane was modified. The accepted Export Census R1 was not
rebuilt, not resealed; no Census R2 was created; no sealed transcript,
manifest, receipt, or prior owner ruling was rewritten; no historical
experiment was rerun; no new empirical evidence was generated. No jurisdiction
closed by Ruling 6B was opened or advanced: no S-freeze, no stranger audit,
no PortJ-F/0, no hidden bank, no J2, no portability, conformance, or
independent-implementation work. No Independent Implementation /0,
Independent Inhabitation /0, or comparative authorship campaign was begun.**
The chair's and its agents' involvement is evidence of nothing (charter D.1,
last row). Evidence earned by this parcel: **zero. Zero remains zero.**

## 9. Review brief for Sol (hostile jurisdictional reading — not simulated here)

Sol — the chair asks you to attack, not to admire. Nothing in this parcel is
adopted; your reading cannot adopt it; and your agreement, where you agree,
is one strong outside reading under shared input, never a second witness —
**including your agreement with the parts R0 built in answer to your own
tier table, which you must treat as your own text echoed back.** Attack:

1. **The languagehood definition (C.6, rungs 1–3):** too permissive (does a
   spec + refusals floor admit trivial notations?) or too restrictive (does
   the stratification understate what adopted evidence already carries)?
2. **Semantic jurisdiction (B.0–B.5):** established, or merely asserted?
   In particular whether §B.5's perimeter clause *rescues* the thesis or
   *concedes* it — is a jurisdiction whose enforcement leaks through one
   `::` a jurisdiction, or a convention?
3. **Construction-entangled double counting:** find any place the parcel
   counts one witness twice — especially places where your own prior
   assessment, the chair's essay, or P1's text re-enter as corroboration.
4. **The independence topology (§D):** hidden equivalences between axes;
   missing axes; whether the substrate axis's non-contributing declaration
   actually prevents its laundering.
5. **Licensed sentences exceeding evidence:** every CC-1 and CC-2 wording in
   §F and the claim ceiling — find one that outruns its source.
6. **Gameability of the gates (§G):** for each gate, construct the cheapest
   dishonest pass you can imagine and check whether the gate's stated voids
   catch it; the memorization control in §G.4 deserves your hardest attempt.
7. **Failure semantics and falsifiability:** does any gate's failure clause
   let a red result be retold as progress? Does any "does NOT erase" clause
   over-protect a lower rung that a specific failure *should* impeach?
8. **The docket:** is any of F-1…F-10 actually a factual question the chair
   should have answered from the record? Is any genuine fork missing?
9. **The weakest row, named for you:** EV-15/EV-45/EV-46 — the
   hosted/embedded absence-and-precedent complex; and rung 3's divergence
   from the commission's expected recommendation. If the divergence is
   wrong, say exactly which stratum sentence you would license instead.

Intended sequence thereafter: **Sol hostile return → finite owner docket →
owner ruling → only then ratification/finalization.** This return stops
here and awaits review.

---

*Prepared by the chair (Claude Fable 5), 2026-08-11. CANDIDATE R0 —
NOT ADOPTED. Zero evidence. The parcel earns nothing by existing, including
this sentence.*
