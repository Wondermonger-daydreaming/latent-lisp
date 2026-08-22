# ONE ACT /0 — CITATION RESOLUTION TABLE (Round OA)

**CANDIDATE parcel — Round OA; not an adoption; frozen court-construction
baseline commit `71422395`; read-only over adopted history; zero evidence toward
any PortJ/0 station.**

Every citation from the **adopted lane sources** (`experiments/latent-lisp/mneme/language-act-0/*.lisp`,
`*.sh`) to any of the five candidate documents, resolved against those
documents' actual structure. **Nothing is repaired here, including the dangling
and mis-attributed citations. Recording only.**

---

## 1. The searches, shown

```
$ cd experiments/latent-lisp/mneme/language-act-0
$ grep -c -i 'contract' *.lisp *.sh
act0-loader-disease.sh:0    act0-load-witnesses.lisp:0   act0-selftest.lisp:2
package.lisp:9              act0.lisp:36                 act0-fixtures.lisp:13
act0-gates.lisp:6           act0-load-witnesses.sh:0

$ grep -oh -E 'contract[^A-Za-z0-9]{0,3}§[0-9A-Za-z.()-]+' *.lisp *.sh | sort | uniq -c | sort -k2
      1 contract §0.3        1 contract §0.3)      1 contract §0.4       1 contract §1)
      1 contract §10         1 contract §14.1      2 contract §14.2      1 contract §2.3).
      2 contract §2.4).      2 contract §2A        1 contract §2A.0).    3 contract §4
      1 contract §5.1a).     1 contract §6.3

$ grep -n -i -E 'contract|failure[- ]matrix|identity[- ]table|test[- ]plan|specimen' *.lisp *.sh
   → 82 lines (per-file counts in Appendix A)

$ grep -n -E 'MX-[0-9]' *.lisp *.sh          → (no output)
$ grep -n -E '\bI-[0-2][0-9]\b' *.lisp *.sh  → (no output)
$ grep -n -i -E 'matrix|identity tab|id-table' *.lisp *.sh
act0-fixtures.lisp:141:… ⚠ THIRTEEN, counted: the bundle's own matrix   ← prose, not a citation
```

**Headline count.** 82 citation-bearing lines; **71 distinct citation tokens**;
targets: **contract** (majority), **specimen** (11 sites), **test plan**
(5 sites), **failure matrix** (0), **identity table** (0).

Resolution method: each token `grep -n -F`'d against the named document's
adopted bytes (proven byte-identical to the adopted tree in
`RECOVERY-DETERMINATION.md` Part I). A token resolves when the document contains
the section heading or the labelled clause it names.

---

## 2. CONTRACT — `§`-form citations

| Cite | Source sites | Resolves to (contract line) | Status |
|---|---|---|---|
| `contract §0.3` | `package.lisp:9`, `act0.lisp:9` | `### 0.3 Same-family review caveat` @178; body @202-208 carries the Rider-2 phrase prohibition verbatim | **RESOLVES-CLEAN** |
| `contract §0.4` | `package.lisp:21` | `### 0.4 Crash model` @215 | **RESOLVES-CLEAN** (heading is written `0.4`, no `§` glyph — cosmetic) |
| `contract §1` | `package.lisp:3` (*"Governing sentence"*) | `## §1 — Governing sentence and the boundary law` @257 | **RESOLVES-CLEAN** |
| `contract §2.3` | `package.lisp:13` (*"LABELLED DUAL AUTHORITY"*) | `### 2.3 Labelled dual authority — the label is normative` @363 | **RESOLVES-CLEAN** |
| `contract §2.4` | `act0-fixtures.lisp:39` (A-4), `act0.lisp:494`, `act0.lisp:1280` | `### 2.4 The MANDATORY binding` @389 | **RESOLVES-WITH-TENSION** — see §5.1 (the §2.4 text at the adopted bytes is the R2.1-erratum-amended BIND-3n/3i version, not the sealed version) |
| `contract §2A` | `act0.lisp:3`, `act0.lisp:108` (ACT-9), `act0.lisp:435` (ACT-5) | `## §2A — THE ACT IDENTITY` @733 | **RESOLVES-CLEAN** |
| `contract §2A.0` | `act0.lisp:116` | `### 2A.0 ⚑ SUPERSESSION — THE TOKEN BASIS IS DEAD` @740 | **RESOLVES-CLEAN** |
| `contract §3.2` | `act0.lisp:4` | `### 3.2 The journal projection is LANE-LOCAL AND CLOSED-VOCABULARY` @1536 | **RESOLVES-CLEAN** |
| `contract §3.4a` | `act0.lisp:304`, `act0.lisp:1280`(implied) | `### 3.4a ⚑ M-13a — THE LEXICAL GRAMMARS` @2224 | **RESOLVES-CLEAN** |
| `contract §4` | `act0.lisp:3` (L0..L22), `act0.lisp:230` (L0), `act0.lisp:304` (L1b) | `## §4 — The normative law: the canonical act, as a numbered trace` @2584 | **RESOLVES-CLEAN** |
| `contract §5.1a` | `act0.lisp:403` (V-REQ) | `### ⚑ 5.1a — V-REQ: THE REQUEST'S RECORD RENDERING` @2983 | **RESOLVES-CLEAN** |
| `contract §6.3` | `act0.lisp:4`, `act0.lisp:1072`, `act0.lisp:1084` | `### 6.3 THE AGREEMENT GATE` @3269 | **RESOLVES-CLEAN** |
| `contract §2.6a` | `act0.lisp:5` (*"the refusal law of §2.6a"*) | `### ⚑ 2.6a — THE PUBLISHED CEILING` @686 | **RESOLVES-WITH-TENSION** — §2.6a is headed *"THE PUBLISHED CEILING … PUBLICATION IS THE OBLIGATION"*; the source calls it *"the refusal law"*. Both readings are in the section; the label the source uses is not the section's own title. |
| `contract §7.1` | `package.lisp:21` | `### 7.1 Scope: ONE LIFE` @3344 | **RESOLVES-CLEAN** |
| `contract §10` | `package.lisp:26` (with `N-1..N-6`) | `## §10 — Reserved-name discipline (R7)` @3877; `N-1` @3879 | **RESOLVES-CLEAN** |
| `contract §13` | `package.lisp:23` (*"is headed 'Examples (NON-NORMATIVE ILLUSTRATION)'"*) | `## §13 — Examples (NON-NORMATIVE ILLUSTRATION)` @4158 | **RESOLVES-CLEAN** — quotation of the heading is exact |
| `contract §14.1` | `act0-fixtures.lisp:53` (F-STORE) | `### 14.1 ⚑ F-STORE — THE FIXED STORE NONCE` @4359 | **RESOLVES-CLEAN** |
| `contract §14.2` | `act0-fixtures.lisp:107`, `act0.lisp:1175` (W-ENV) | `### 14.2 ⚑ W-ENV — THE ENVIRONMENT PRE-FLIGHT` @4397 | **RESOLVES-CLEAN** |
| `§19.5 / §19.3 / §19.2 / §19.4` | `package.lisp:27` | **Not contract sections** — Kernel /0 spec sections, reached through `contract §10 / N-1`, which itself lists them at contract @3880-3883 | **RESOLVES-CLEAN** (external target, correctly framed by the source as *"reserved Kernel verbs (N-1)"*) |

## 3. CONTRACT — labelled-clause citations

All of the following were resolved by `grep -c -F <label> ONE-ACT-0-CONTRACT-CANDIDATE.md`
with a nonzero count and a located first line:

`ACT-3` (9) · `ACT-5` (24) · `ACT-9` (27) · `ACT-9a` (11) · `ACT-12` (8) ·
`ACT-14` (3) · `ACT-L2` (8) · `ACT-L6` (8) · `A-4` (3) · `A-5a` (7) ·
`I-2` (6) · `J-2c` (6) · `J-4` (37) · `J-7` (25) · `J-7c` (8) · `J-9-1` (2) ·
`J-9-6` (2) · `K-7a-1` (2) · `K-7d` (2) · `L-3` (7) · `M-3c` (8) ·
`M-13a-3` (5) · `M-13b-3` (3) · `N-1` (2) · `N-6` (14) · `O-4` (4) · `O-5` (6) ·
`O-8` (1) · `R-6` (6) · `S-1` (6) · `S-4` (3) · `V-4` (2) · `V-5` (2) ·
`V-6` (1) · `V-7` (2) · `V-8` (1) · `V-10` (2) · `V-11` (2) · `V-REQ-2` (7)

**Status: RESOLVES-CLEAN, 39 of 40 labels.** The exception:

| Cite | Source site | What the record shows | Status |
|---|---|---|---|
| **`contract WE-04`** | `act0.lisp:80-81` — `(:documentation "W-ENV: a run VOID is not a failure of the specimen and is never reported as a pass (contract WE-04).")` | `grep -c -F 'WE-04' ONE-ACT-0-CONTRACT-CANDIDATE.md` → **0**. `WE-04` occurs at `ONE-ACT-0-SPECIMEN.md:405` (§2.1b W-ENV) and `ONE-ACT-0-TEST-PLAN.md:1521`. | **MIS-ATTRIBUTED — resolves to a DIFFERENT document than the one named.** The clause exists and is normatively coherent; the *citation names the wrong instrument*. **Not repaired.** |

Search shown:

```
$ grep -n -o -E 'WE-[0-9]+' _staging/oneact-candidate/*.md | sort | uniq -c
   1 ONE-ACT-0-SPECIMEN.md:392:WE-01      1 ONE-ACT-0-SPECIMEN.md:396:WE-02
   1 ONE-ACT-0-SPECIMEN.md:402:WE-03      1 ONE-ACT-0-SPECIMEN.md:405:WE-04
   1 ONE-ACT-0-SPECIMEN.md:408:WE-05      1 ONE-ACT-0-TEST-PLAN.md:1521:WE-04
   1 ONE-ACT-0-TEST-PLAN.md:1725:WE-01    1 ONE-ACT-0-TEST-PLAN.md:1725:WE-05
   1 ONE-ACT-0-FAILURE-MATRIX.md:1416:WE-01  1 …:1416:WE-05
$ grep -c -F 'WE-04' _staging/oneact-candidate/ONE-ACT-0-CONTRACT-CANDIDATE.md
0
```

## 4. SPECIMEN and TEST PLAN citations

| Cite | Source sites | Resolves to | Status |
|---|---|---|---|
| `specimen §2.1` | `act0-fixtures.lisp:80` (F-WORLD) | `### 2.1 The world` @289 | **RESOLVES-CLEAN** |
| `specimen §2.1a` | `act0-fixtures.lisp:53` | `### 2.1a ⚑ F-STORE — the journal store fixture` @353 | **RESOLVES-CLEAN** |
| `specimen §2.4 F-FORM-BL1/BL2` | `act0.lisp:1248` | `### 2.4 The originating forms` @481; `F-FORM-BL1`/`BL2` present | **RESOLVES-CLEAN** |
| `specimen FS-02` | `act0-fixtures.lisp:56-57` (the printed rider) | present (2 hits) | **RESOLVES-CLEAN** |
| `specimen BR-11` | `act0-gates.lisp:504`, `:510` | present (2 hits); §6.1 ARM B-R | **RESOLVES-WITH-TENSION** — §6.1 is the R2.1-erratum rewrite (*"REWRITTEN BY THE R2.1 ERRATUM (chair ruling 1)"*), i.e. the cited law is post-seal chair text |
| `specimen BR-03/BR-04/BR-08` | `act0-gates.lisp:530` | present (2 hits each) | **RESOLVES-CLEAN** |
| `specimen NC-27` | via test plan §5.3 | present (2 hits) | **RESOLVES-CLEAN** |
| `test plan §5.2 · §5.3 · §5.4 · §5.5 · §5.6 · §5.6a · §5.6b` | `act0-gates.lisp:19-21` | headings `### ⚑ 5.2` @664, `5.3` @907, `5.4` @928, `5.5` @1017, `5.6` @1037, `5.6a` @1086, `5.6b` @1107 | **RESOLVES-CLEAN** |
| `test plan §5.2a` | `act0-gates.lisp:256` (FX-13) | present @— (1 hit) | **RESOLVES-CLEAN** |
| `test plan §5.2b` | `act0-gates.lisp:292` (H-ACT-PREIMAGE) | present (3 hits) | **RESOLVES-CLEAN** |
| `test plan §5.7` | `act0-gates.lisp:560-562` | `### ⚑ 5.7 — V-F1..V-F5: SPECIFIED; OCTETS PENDING FIRST IMPLEMENTATION ACT` @1163 | **RESOLVES-WITH-TENSION** — the source says the octets are *"RUN OUTPUT for the chair's return; the sealed test plan is …"*; the document still reads `PENDING`. The resolved octets live in `_staging/oneact-impl-evidence/v-f-freeze-table.txt` (sha256 `2b51b4df…1264f0`), **not in any of the five documents.** |
| `CONTRACT ORDER` (GATE-3 seven arms) | `act0-selftest.lisp:171-172`, `act0-gates.lisp:500` | An *ordering* named by the contract's arm sequence; no §/label given | **RESOLVES-WITH-TENSION** — the phrase is treated as normative by the runner but points at no citable clause |

## 5. Where two sides of the record disagree — both quoted

### 5.1 Governing-law citations vs. the cited document's self-standing

```
package.lisp:3   ;;;; Governing sentence (contract §1): one Lisp+ form gives rise to one …
```
against, in the same adopted tree:
```
ONE-ACT-0-CONTRACT-CANDIDATE.md:43  **Status: CANDIDATE PRE-CODE CONTRACT. Nothing here is adopted, accepted,
                                :44  frozen, audited, or on a governing floor.** …
                                :48  **Authority claimed: none.**
```
**Both are adopted bytes.** Recorded; not resolved.

### 5.2 The cited text is post-seal chair text

Sources citing `contract §2.4` / `A-5a` / `specimen BR-11` are citing clauses
whose adopted wording was produced by the **R2.1 erratum, chair rulings 1 and 2**
(`git diff 3c4e704d 461f2013`), after the owner-blessed pre-code seal and with no
subsequent per-file hash. The contract's own precedence list (§0.2, tier 3) says
*"This contract, **once sealed**"* — which does not say whether it means the
sealed bytes or the adopted bytes.

### 5.3 Two documents nobody cites

```
$ grep -n -E 'MX-[0-9]' *.lisp *.sh          → (no output)
$ grep -n -E '\bI-[0-2][0-9]\b' *.lisp *.sh  → (no output)
```
**No adopted source or gate cites the failure matrix or the identity table**, by
row id or by name. Their own headers place them downstream:

- `ONE-ACT-0-FAILURE-MATRIX.md:4-5` — *"Companion to `ONE-ACT-0-IDENTITY-TABLE.md`; **governed by** `ONE-ACT-0-CONTRACT-CANDIDATE.md` and `ONE-ACT-0-SPECIMEN.md`"*
- `ONE-ACT-0-IDENTITY-TABLE.md:5-7` — *"Where this table and the contract differ, **the contract controls**"*

## 6. Citations in R1-era Many Acts /0 documents to One Act law (flagged as operative use)

Found while resolving; recorded as **evidence of operative use**, not adjudicated:

| Site | Text | Note |
|---|---|---|
| `language-many-acts-0/MANY-ACTS-0-CONTRACT-CANDIDATE.md:13` | *"One Act /0 adopted candidate \| commit `461f2013…`, tree `1123c3c3…` — CLOSED, UNCHANGED"* | cites One Act **by object**, never by document |
| `…/AUTHOR-GUIDE.md:304` | *"the seven **adopted** One Act /0 arms of the *scriba / inscribere* specimen"* | treats the **specimen's** arms as adopted law |
| `…/MANY-ACTS-0-GRAMMAR.md:63` | *"**V-ARM**: `:arm` must be one of the seven adopted arms"* | a live grammar rule resting on specimen arms |
| `…/AUTHOR-GUIDE.md:124-125` | *"executes one adopted One Act /0 arm. The act's identity, authority decision, journal frames, and agreement verdict are **One Act /0's own**."* | behavioural deference to the adopted lane |
| `…/ma0-compose.lisp:9,30,56` | *"One Act /0's five kinds in the VALIDATED PREFIX"*, *"ONE DELIBERATE DIVERGENCE, DECLARED: … One Act /0's [ordering guard]"* | source-level reliance |
| `…/SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md:25-26` | *"One Act /0 will not be modified to expose such a state (One Act /0: CLOSED AND BYTE-UNCHANGED)."* | treats One Act as fixed law |

**Live-reliance note.** A narrow OA-N ruling that leaves the specimen at category
2 would place Many Acts /0's *"seven adopted arms"* language on ground the record
does not support. Recorded for the owner; not resolved here.

## 7. Summary

| Class | Count |
|---|---|
| RESOLVES-CLEAN | 65 (17 contract `§`-form · 39 contract labels · 9 specimen/test-plan) |
| RESOLVES-WITH-TENSION | 5 (`contract §2.4`, `contract §2.6a`, `specimen BR-11`, `test plan §5.7`, `CONTRACT ORDER`) — plus the class-wide post-seal issue in §5.2, which touches every §2.4/A-5a/BR-11 citation at once |
| DANGLING (no such clause anywhere) | **0** |
| MIS-ATTRIBUTED (clause exists, wrong document named) | **1** — `contract WE-04` @ `act0.lisp:81` |
| Citations to the failure matrix | **0** |
| Citations to the identity table | **0** |

**No citation was repaired. The mis-attribution and every tension above is left
exactly as found, for owner disposition.**

## Appendix A — the raw citation listing (82 lines)

Produced by:

```
$ cd experiments/latent-lisp/mneme/language-act-0
$ grep -n -i -E 'contract|failure[- ]matrix|identity[- ]table|test[- ]plan|specimen' *.lisp *.sh
```

Per-file counts of that listing, measured:

```
act0.lisp                  42
act0-fixtures.lisp         16
act0-gates.lisp            13
package.lisp                9
act0-selftest.lisp          2
act0-load-witnesses.lisp    0
act0-load-witnesses.sh      0
act0-loader-disease.sh      0
TOTAL                      82
```

⚠ The three R2.2/R2.3-era sources (`act0-load-witnesses.lisp`,
`act0-load-witnesses.sh`, `act0-loader-disease.sh`) cite the five documents
**zero times** — the structural fact developed in `COMMENT-LAW-SWEEP.md`.

The listing is reproducible verbatim from the adopted tree with the command
above; it is not duplicated here to keep this parcel free of copied lane text.
Every line of it that constitutes a citation is resolved in §§2–4.

— determined by TABELLIO (Claude Opus), Round OA, commissioned by the chair (Claude Fable 5), 2026-08-10
