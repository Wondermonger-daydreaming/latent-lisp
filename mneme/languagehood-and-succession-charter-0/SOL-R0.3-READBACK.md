# SOL READBACK — LANGUAGEHOOD & SUCCESSION CHARTER /0, CANDIDATE R0.3

**Date:** 2026-08-11

**Mode:** read-only documentary review

**Review object:** `languagehood-and-succession-charter-0-r0.3-2026-08-11.tar.gz`

**Disposition:** **RETURN TO FABLE FOR BOUNDED R0.4 REPAIR BEFORE OWNER DOCKET**

**Standing:** review and repair commission only; no adoption, publication,
campaign opening, docket activation, owner solicitation, or new evidence

## 1. Custody and identity

The controlled return is authentic at archive and parcel-tree level.

- Archive SHA-256:
  `ac3722ab969d2493a34c99f13b52a7268607e63726b1950c59bd15901bce3923`
  — exact match to the supplied sidecar.
- Archive members are ordinary files/directories under the expected project
  root; no traversal, symlink, device, or foreign-root member was found.
- Internal checksum regimes pass: **R0 7/7 · R0.1 12/12 · R0.2 10/10 ·
  R0.3 9/9**.
- Every governed R0, R0.1, and R0.2 file was additionally compared byte-for-byte
  against its earlier uploaded controlled archive: **7/7, 12/12, and 10/10
  identical**.
- The disclosed `SOL-HOSTILE-RETURN-R0.md` normalization remains mode `100644`;
  its bytes remain governed by the earlier checksum.
- The owner master commission remains exact: SHA-256
  `a1d87146364c3f5d6d5b9c5d8bb37cf5fdfb5d8ae61895654d0b693eee6f9865`.
- The filed Sol R0.2 readback is byte-identical to the owner-side delivered
  report: SHA-256
  `fbf06aa1876ea4fe41453722e28c3386837c8802a1cf84e690acbac871c3688b`.
- Reconstructed parcel-directory Git tree:
  `cf9352d4c44181d0782027001211e9aa5021b032` — exact match to
  `GIT-IDENTITY-R0.3.txt`.
- Candidate commit `16a4ccfc45114f05dcab03e510bd5f500f7bc72b` remains
  metadata-only in this workspace: the authoritative Git object graph was not
  available. The parcel tree is authenticated; the commit itself must be
  confirmed in the authoritative repository before owner disposition.

## 2. Executive verdict

R0.3 closes the W-14 repair cleanly and preserves every earlier stratum.

It does not yet close the other three R0.2 findings. Two are still
ratification blockers: P1's candidate-only latent-authorship wording is called
presently licensed in four live sites, and the new status validator still does
not validate the charter's actual declaration syntax or table status cells.
The validator's own committed controls pass, but independent controls expose
its blind spots, and one malformed live rung status survives behind them.

The current-version repair is also incomplete: several live companion links,
docket references, F-1 options, and current self-identifications still point to
R0.1 or R0.2.

This is not an architectural failure. R0.4 can be a bounded repair of three
residual classes. The owner docket must remain dormant until that readback is
green.

## 3. Four-finding disposition

| R0.2 readback finding | R0.3 disposition | Readback |
|---|---|---|
| **SOL-R02-01** — candidate authority / claim-class errors | **PARTIAL — RATIFICATION BLOCKER** | §I's F-3/F-8 cells and the three named category slips are repaired, but C.23, rung 10, F.1(9), and the Succession Docket still promote P1's latent-authorship wording to present license/CC-2. |
| **SOL-R02-02** — status grammar not mechanically enforced | **PARTIAL — RATIFICATION BLOCKER** | The three named OPEN annotations are normalized and the new self-test passes, but the validator matches none of the charter's ten rung declarations, ignores arbitrary inline/table primary tokens, and misses a malformed live rung-6 status. |
| **SOL-R02-03** — W-14 boundary incomplete | **PASS** | Every readback-listed result-bearing absence is now bounded to the directly authenticated record or named source set; old bare forms are absent from the five successors. |
| **SOL-R02-04** — current-version identity inconsistent | **PARTIAL — MAJOR** | Titles and principal banners improve, but live charter/docket pointers, F-1 options, closing identities, and one line/provenance description still stop at R0.1 or R0.2. |

## 4. Readback findings

### SOL-R03-01 — RATIFICATION BLOCKER — P1's latent-authorship wording is still promoted to present license

**Controlling site:** `OWNER-DOCKET-R0.3.md` §F-8 correctly states the rule:
P1 §1.LM.2 is candidate text; its “designed as” sentence is proposed by a
candidate document and “not licensed by anything” with constitutional force.
F-8 is live and must be disposed before ratification.

Four live sites contradict that correction:

1. `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.3.md` §C.23 says design intent
   “is provenance and is licensed.”
2. The same charter's §E rung 10 says “The only licensed present-tense sentence
   is design provenance” and cites P1 §1.LM.2.
3. The same charter's §F.1(9) assigns that design-provenance formulation
   **CC-2**. Under §F.0, CC-2 means presently licensed with a mandatory
   qualifier; that is incompatible with F-8's pending candidate proposal.
4. `SUCCESSION-DOCKET-R0.3.md` §4 again says “The only licensed present-tense
   sentence is design provenance.”

This is the same authority-laundering class SOL-HR-01 and SOL-R02-01 were
written to remove. The R0.3 sweep missed it because “P1” and “licensed” are not
always adjacent on one line.

**Consequence:** the candidate simultaneously says the wording is unlicensed
pending owner policy and presently licensed as CC-2. Ratification would leave
the operative claim ceiling internally contradictory.

**Smallest repair:** at all four sites, classify the wording as
**candidate-proposed / CC-3 pending F-8**, not presently licensed. Preserve the
separate proposition that design intent is not an LM0 empirical result. Sweep
by paragraph/record rather than line adjacency: every occurrence of P1
§1.LM.2, the exact design-provenance sentence, `licensed`, and `CC-2` must be
adjudicated together. Add a negative assertion that the current five
successors contain no present-license statement for this wording before F-8 is
ruled.

No owner disposition is required to make this repair; the owner question is
already F-8, and the unruled default is CC-3.

### SOL-R03-02 — RATIFICATION BLOCKER — the replacement validator still does not validate the declared grammar

**Sites:** `validate_status_tokens.py` and
`LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R0.3.md` §E rung 6.

The reported positive facts are real: `--self-test` reports PASS; its five
committed negative controls are caught; its five positive controls pass; the
supplied five-file corpus run reports CLEAN.

But the central `DECL` expression does not parse the charter's ordinary inline
form `**Status: TOKEN**`. An independent instrumentation pass found:

- **0 of the charter's 10 rung status declarations** were captured by `DECL`;
- `**Status: MYSTERY** text` was missed;
- `**Status (rung): MYSTERY** text` was missed;
- `| Rung 1 | **MYSTERY** | note |` was missed;
- the code contains no table-status-column parser despite its docstring's claim
  that table status cells are validated.

The corpus therefore passes partly by remaining unseen. A live defect proves
the consequence: charter rung 6 still declares
`**Status: OPEN — and split by owner ruling into two targets**`, which violates
§A.1's rule that the primary token is exactly one of six and that support,
stratum, and jurisdiction facts are separate annotations. The validator misses
it.

**Smallest repair:** normalize rung 6 to `**Status: OPEN**` and move the
two-target split into a separately labelled annotation. Replace or extend the
validator so that it:

1. parses inline `**Status: …**` and separated `**Status (…)** **TOKEN**`
   declarations;
2. validates the status column of status-bearing Markdown tables, especially
   `CLAIM-CEILING-R0.4.md`;
3. rejects any status-looking declaration it could not parse, so zero matches
   cannot count as success;
4. carries negative controls in the actual inline and table syntaxes, including
   an arbitrary seventh token and an overstuffed `OPEN — and split…` token;
5. asserts expected declaration/table coverage before printing CLEAN.

The current validator and its true first-run history should be preserved in
the frozen R0.3 stratum; R0.4 should carry its corrected successor.

### SOL-R03-03 — NO DEFECT — W-14 boundary closes

All sites named by SOL-R02-03 are repaired:

- CI0 in the Succession Docket and Claim Ceiling is bounded to the directly
  authenticated lane record;
- the charter's succession absence is bounded to directly authenticated named
  sources;
- Owner Docket F-4 uses the same bounded source surface;
- the ledger's NOT COVERED heading and LM0/CI0/DG0 rows are bounded to the
  directly authenticated record or named source set.

The old bare result-bearing forms do not survive in the five R0.3 successors.
Normative consequence negatives remain untouched, correctly.

### SOL-R03-04 — MAJOR — current-version identity remains materially incomplete

The R0.3 titles, main banners, charter-to-ceiling pointer, charter §I pointer,
Succession-Docket-to-Owner-Docket links, and ledger `Serves` line are repaired.
Several live referents remain stale:

- `CLAIM-CEILING-R0.3.md` says the page compresses the R0.1 charter.
- `SUCCESSION-DOCKET-R0.3.md` says its current companion is the R0.1 charter.
- The charter's opening relation note and §A.2 direct F-1/F-2 to
  `OWNER-DOCKET-R0.1`; §G.4 says `Docket-R0.1`; §I says no disposition is
  solicited “by R0.1.”
- The charter's independence matrix names “the R0/R0.1/R0.2 line” and omits
  the current R0.3 member.
- `OWNER-DOCKET-R0.3.md` §F-1 still frames every live option,
  recommendation, and default around R0.1 rather than the current R0.x line;
  its Closing again calls the live object R0.1, and its signature still says
  `Draft R0.1 owner docket`.
- `SUCCESSION-DOCKET-R0.3.md` retains a closing self-identification as
  `Succession Docket R0.2` without an R0.3 successor note.

These are not historical “installed at R0.1” statements; they are present
companion pointers, live fork operands, current non-solicitation statements,
or current self-identities.

**Smallest repair:** replace only those live referents with R0.4 or the stable
phrase “current R0.x candidate line (presently R0.4).” Preserve exact historical
attributions to work performed, findings installed, and sources filed at
R0.1/R0.2. Add a context-aware closing sweep over every R0.1/R0.2 occurrence in
the five successors, classifying each as either historical provenance or live
identity; return that finite adjudication table in the concordance.

## 5. Structures that survive and must not be reopened

- SOL-R02-03 / W-14 is closed.
- §I's F-3 and F-8 default cells are correctly repaired.
- The three R0.3 category-slip repairs in §B/§E are sound.
- W-02 through W-13, including the proposed languagehood classification,
  non-aggregation, claim-relative exposure, P5 rescore, and LM0 edge split.
- PortJ-L/0, PortJ-F/0, CI0, DG0, and LM0 gate designs.
- The substantive fork triage and every non-commencement clause.
- Source authentication, quote corrections, master-commission identity, filed
  Sol returns, hand-count correction, mode normalization, and all four frozen
  checksum strata.

## 6. Minimal R0.4 commission

> **Return Candidate R0.4 as a strictly bounded documentary repair of Candidate
> R0.3. Preserve R0, R0.1, R0.2, and R0.3 byte-identical; generate no evidence;
> solicit no owner dispositions; activate no docket; open no campaign or
> jurisdiction. Repair only SOL-R03-01, SOL-R03-02, and SOL-R03-04 in the Sol
> R0.3 Readback. Demote every live present-license/CC-2 treatment of P1
> §1.LM.2's latent-authorship wording to candidate-proposed/CC-3 pending F-8;
> normalize charter rung 6 and replace the status validator with complete
> inline, separated, and status-table validation plus coverage assertions and
> actual-syntax negative controls; align every live companion pointer, fork
> operand, non-solicitation statement, and current self-identity to the R0.4 or
> stable R0.x line while preserving historical R0.1/R0.2 attributions. Do not
> reopen SOL-R02-03/W-14, W-02…W-13, any independence coordinate, gate design,
> substantive fork triage, or non-commencement clause. Return a three-finding
> concordance, a finite R0.1/R0.2 occurrence adjudication, validator self-test
> and real-corpus results, exact commit/tree identity, all five strata
> checksums, and stop.**

## 7. Custody statement

This readback modified no candidate file and no repository artifact. It opened
no owner docket, gate, campaign, hidden bank, J2, census, evaluator, transcript,
receipt, ruling, publication, merge, or adoption. It generated no empirical
evidence. The only new object is this review report. R0.3 remains a candidate
and remains untouched.

*— Sol readback, 2026-08-11.*
