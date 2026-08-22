# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.2

**Date:** 2026-08-11

**Mode:** read-only documentary review

**Review object:** `languagehood-and-succession-charter-0-r0.2-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR BOUNDED R0.3 REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, or new evidence

## 1. Custody and identity

The controlled return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `8e7e8332e3bffcf7ef0d064d3909efac71482ddbd915d857371c564e308e4714`
  — exact match to the supplied sidecar.
- Archive members are ordinary files/directories under the expected return
  root; no traversal, symlink, device, or foreign-root member was found.
- R0 preservation checksum: **7/7 OK**.
- R0.1 preservation checksum: **12/12 OK**.
- R0.2 checksum: **10/10 OK**.
- Every R0 and R0.1 governed file was additionally compared byte-for-byte
  against the earlier uploaded controlled archives: all match.
- `SOL-HOSTILE-RETURN-R0.md` is byte-identical to the R0.1 copy; its mode alone
  changed from `100755` to `100644`, exactly as disclosed.
- The owner master commission is byte-identical to the owner-supplied file:
  SHA-256 `a1d87146364c3f5d6d5b9c5d8bb37cf5fdfb5d8ae61895654d0b693eee6f9865`,
  489 lines / 4,157 words / 29,781 bytes.
- The filed Sol R0.1 readback is byte-identical to the owner-side file:
  SHA-256 `54b16ec2692cb71fa34bb553f0af2fc71e5cf860fc1c6a9e4ad22f4e2906ff75`.
- Reconstructed parcel-directory Git tree:
  `fb277f683431ac39c51f43c191671d7a139ecfb4` — exact match to
  `GIT-IDENTITY-R0.2.txt`.
- Candidate commit `a66b44aba08b8fd305f8f80bb5d89c5629a08b7a` remains
  metadata-only in this workspace: the archive contains identity metadata, not
  the authoritative Git object graph. Direct retrieval of the public commit was
  unavailable during this readback. The parcel tree is authenticated; the
  commit itself must be confirmed in the authoritative repository before any
  owner disposition is filed against it.

## 2. Executive verdict

R0.2 is another real repair, but its claim that all eight readback findings are
closed is not yet accurate. Four findings close cleanly; four remain partial.

The remaining defects are bounded and documentary. No languagehood holding,
independence coordinate, lattice edge, or future gate design needs reopening.
The blockers are instead reflexive: the status-enforcement script does not
enforce the grammar it advertises, and the charter's late owner-docket summary
reintroduces authority classifications repaired in the main body.

The owner docket should remain dormant. One narrow R0.3 pass can close the
status grammar, bound the remaining negative universals, align current-version
identity and pointers, and correct the R0.2 concordance of record.

## 3. Eight-finding disposition

| R0.1 readback finding | R0.2 disposition | Readback |
|---|---|---|
| **SOL-R01-01** — authority / claim-class conflict | **PARTIAL — BLOCKER** | Main §F.1 and the compact ceiling are repaired; Charter §I restores `CC-2` for deferred F-3 and says P1's F-8 sentence is licensed. |
| **SOL-R01-02** — status grammar not mechanically closed | **PARTIAL — BLOCKER** | Main tokens improved, but three live Succession Docket sub-annotations remain malformed and the lint misses them by construction. |
| **SOL-R01-03** — terminus / universal spentness residue | **PASS** | Live matrix and fence-eligibility prose use W-06/W-07; remaining old vocabulary is historical or corrective. |
| **SOL-R01-04** — F-5 revival; LM0 / Ruling-6B overreach | **PASS** | F-5 is governed by Ruling 8; LM0 is correctly unopened but named in no 6B stop clause; the ordering is proposed procedural advice. |
| **SOL-R01-05** — incomplete W-14 substitutions | **PARTIAL — MAJOR** | Main charter sites were mostly bounded, but result-bearing bare absences survive in the Succession Docket, compact ceiling, charter claim grammar, owner docket, and ledger gap summary. |
| **SOL-R01-06** — source custody closure | **PASS WITH EXTERNAL COMMIT CHECK** | Master commission and filed Sol readback are exact; A-1 is closed at file identity. Candidate-commit authentication remains outside the archive's proof surface. |
| **SOL-R01-07** — same-root rechecks called independent | **PASS** | RETURN-R0.2 corrects the frozen sentence of record to “three separate same-root rechecks.” |
| **SOL-R01-08** — mechanical residue | **PARTIAL — MAJOR** | Mode, EV-22, several labels, and the return hand count are repaired; current-version banners/pointers and the concordance hand count remain inconsistent. |

## 4. Readback findings

### SOL-R02-01 — RATIFICATION BLOCKER — §I reintroduces candidate authority and claim-class errors

**Sites:** `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.2.md` §I, especially
the F-3 and F-8 rows.

The main charter correctly reclassifies both languagehood and semantic
jurisdiction as **CC-3** pending owner ratification. The late owner-docket
summary nevertheless gives F-3's deferred default as:

> “Both remain PROPOSED; compression stays CC-2.”

That is the exact contradiction SOL-R01-01 ordered removed: a proposed
constitutional compression is unlicensed, therefore CC-3, not CC-2.

The same summary gives F-8's default as:

> “Only P1's ‘designed as’ sentence licensed.”

The full R0.2 Owner Docket correctly says the candidate P1 sentence is
**proposed**, not licensed by anything. The summary launders the candidate's
authority back in.

**Smallest repair:** change F-3's deferred default to CC-3; restate F-8's
default as a candidate-proposed wording observed conservatively by R0.3, with
no present constitutional license. Sweep the current R0.3 files for the exact
pairings `PROPOSED` + `CC-2` and `P1` + `licensed`, adjudicating every hit.

### SOL-R02-02 — RATIFICATION BLOCKER — the status lint reports CLEAN without enforcing the legend

**Sites:** `lint_status_tokens.py`; `SUCCESSION-DOCKET-R0.2.md` status lines
for rungs 6, 7, and 8.

The script defines `LEGEND` and `BAD_REFUSED` but never uses either. It checks
only two narrow cases: a bare sub-annotation immediately following the literal
text `sub-annotation:` and the literal word `SPLIT` on lines matching two
specific status markers. It does not parse primary statuses, table status
cells, or general refusal labels.

The supplied five-file run returns `CLEAN`, yet controlled negative fixtures
show:

| Fixture | Required result | Actual result |
|---|---:|---:|
| `**Status:** **MYSTERY**` | fail | **CLEAN, exit 0** |
| `**Status (...)** **OPEN — JURISDICTION-CLOSED.**` | fail | **CLEAN, exit 0** |
| `**REFUSED:** example` | fail | **CLEAN, exit 0** |
| `**Status: SPLIT**` | fail | fail, exit 1 |

The real Succession Docket contains exactly the missed malformed forms:

- rung 6: `OPEN — JURISDICTION-CLOSED`;
- rung 7: `OPEN — JURISDICTION-CLOSED`;
- rung 8: `OPEN — UNOPENED`.

These contradict §A.1's requirement that the exact sub-annotations
`OPEN-JURISDICTION-CLOSED` and `OPEN-UNOPENED` are never dropped.

**Smallest repair:** normalize those three status declarations; replace the
lint with a check that actually extracts and validates every declared primary
status and every OPEN sub-annotation across the five current successor texts.
Add committed positive and negative self-tests, or a `--self-test` mode, proving
that an arbitrary seventh token, bare `REFUSED`, and both truncated OPEN forms
fail. A historical report that the earlier script once caught `SPLIT` is not a
substitute for those controls.

### SOL-R02-03 — MAJOR — W-14's authenticated-record boundary remains incomplete

**Sites:** at minimum:

- `SUCCESSION-DOCKET-R0.2.md` CI0 status: “No instance exists”;
- `CLAIM-CEILING-R0.2.md` CI0 row: “zero instances”;
- Charter §F.1(8): “successor is licensed by no present source”;
- `OWNER-DOCKET-R0.2.md` F-4: “no present source licenses any succession
  sentence”;
- `EVIDENCE-LEDGER-R0.2.md` gap heading “because no source exists” and its
  unbounded `None located` / `None` entries for LM0, CI0, and DG0.

R0.2 correctly installed W-14 language in several main-charter sites, but the
bounded absence did not propagate through the satellites. The problem is not
that these absences are implausible; it is that the charter adopted a grammar
precisely to distinguish authenticated absence from repository-universal
nonexistence.

**Smallest repair:** bound every result-bearing absence to the directly
authenticated record, named source set, or an exact owner refusal. Do not alter
negative statements that are genuinely normative consequences rather than
search-derived absence claims.

### SOL-R02-04 — MAJOR — current-version identity and repair provenance are internally inconsistent

**Sites:** all five R0.2 successors plus the R0.2 concordance.

Examples:

- `SUCCESSION-DOCKET-R0.2.md` is titled `R0.2.1`, banners itself
  **CANDIDATE R0.1**, and names the R0.1 charter as its current companion.
- `OWNER-DOCKET-R0.2.md` banners itself **CANDIDATE R0.1**, says R0.1 is the
  current repair, and stages activation after review of the R0.1 return.
- `CLAIM-CEILING-R0.2.md` says it compresses the R0.1 charter.
- The R0.2 charter points readers to `CLAIM-CEILING-R0.1.md` and
  `OWNER-DOCKET-R0.1.md` as its operational/current satellites; §I's F-1 row
  still offers R0.1 as the working candidate.
- `EVIDENCE-LEDGER-R0.2.md` says it serves the R0.1 charter and later gives its
  own standing as Candidate R0.1.
- The R0.2 concordance says RETURN-R0.2 records “three more” agent hands at
  R0.2; RETURN-R0.2 correctly records **zero** and says the round was
  chair-only.

Historical statements that W-02…W-14 were installed at R0.1 are correct and
must remain. The defect is only current-self identity, governing companion
pointers, activation language, and the hand-count claim.

**Smallest repair:** perform a context-aware current-version sweep across the
five R0.3 successors. Update only live self-identification, live companion
pointers, F-1's working-candidate option, and activation language; preserve
historical R0.1 attributions. Correct the R0.2 hand count of record in the R0.3
return/concordance without rewriting the frozen R0.2 file.

## 5. Structures that survive and must not be reopened

- W-02 through W-05 and the exact proposed languagehood classification.
- W-06/W-07 non-aggregation and claim-relative exposure.
- W-08/D.0a and the R-P5 independence rescore.
- R-P4 and R-P5 accepted sentences and their ceilings.
- F-5's removal under Ruling 8 and the corrected LM0/Ruling-6B relation.
- PortJ-L/0, CI0, DG0, and LM0 gate designs, including W-12.
- The owner docket's substantive triage: only its current-version identity and
  two stale summary cells require correction.
- Master-commission identity, quote/custody correction of record, same-root
  terminology, mode normalization, and EV-22's 31/31 correction.
- R0/R0.1 preservation, R0.2 freezing, zero-evidence standing, and every
  non-commencement clause.

## 6. Minimal R0.3 commission

> **Return Candidate R0.3 as a strictly bounded documentary repair of Candidate
> R0.2. Preserve R0, R0.1, and R0.2 byte-identical; retain the disclosed
> `SOL-HOSTILE-RETURN-R0.md` mode normalization; generate no evidence; solicit
> no owner dispositions; activate no docket; open no campaign or jurisdiction.
> Repair only SOL-R02-01…04 in
> `SOL-R0.2-READBACK-LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0.md`. Do not reopen
> W-02…W-13, any independence coordinate, any gate design, or the substantive
> fork triage. Replace the status lint with genuine legend/sub-annotation
> validation and committed negative controls; bound the remaining W-14
> absences; align current-version identity and companion pointers while
> preserving historical R0.1 attributions; correct the R0.2 hand-count claim of
> record. Return a four-finding concordance, clean positive and negative lint
> results, exact candidate commit/tree identity, all four strata checksums, and
> stop.**

## 7. Custody statement

This readback modified no R0, R0.1, or R0.2 file and no repository artifact. It
opened no owner docket, gate, campaign, hidden bank, J2, census, evaluator,
transcript, receipt, ruling, publication, merge, or adoption. It generated no
empirical evidence. The only new object is this review report. R0.2 remains a
candidate and remains untouched.

*— Sol readback, 2026-08-11.*
