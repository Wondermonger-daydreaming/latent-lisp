# S15 ERRATUM /0 — the pinned release-floor script acquires a successor identity

*Drafted by PLINTH, 2026-09-21 (`date` on the desktop: `Mon Sep 21 -03 2026`). **This is a PROPOSAL until
adopted.** It is not a ruling, not an adoption, not a transport, and it changes nothing by existing. It
records, in one place and in advance, the exact old and new identities of a blob-pinned file so that the
owner's landing act and the ruling office's record can both cite a single document.*

---

## 0. SCOPE — one sentence, and its limits

This erratum records a **prose-only repair of two ML/0 standing sentences** carried inside
`experiments/latent-lisp/mneme/verify-release.sh` — the comment block at the head of the ML/0 registration
paragraph, and the carried `ml0|ADOPTED|…` DECLARED row — replacing the superseded August sentence
*"ADOPTED AND PUBLISHED · stranger audit owed · no independent verification"* with the status stone's
current standing quoted verbatim, and keeping the superseded sentence as dated, quoted history.

**The instrument is unchanged.** Measured, not asserted (see §5):

| property | old blob | candidate blob | verdict |
|---|---|---|---|
| gate table (`GATES`) rows | 112 both+full / 82 both+ci | 112 both+full / 82 both+ci | **unchanged** |
| DECLARED rows | 9 | 9 | **unchanged** |
| `--list` output lines | 124 | 124 | **unchanged** |
| `--list` differing lines | — | — | **exactly one** (the `ml0` headline) |
| commands executed | — | — | **unchanged** (no `GATES` line differs) |
| `bash -n` | — | exit 0 | **syntactically valid** |

No gate was added, removed, re-profiled, renamed, or re-expected. No count moved.

---

## 1. OLD IDENTITY (the currently pinned object)

| field | value |
|---|---|
| path | `experiments/latent-lisp/mneme/verify-release.sh` |
| git blob | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` |
| file sha256 | `ecb03c9d122cdf083b7bc72f5dd0eabd0527c8b2ae74ec47ad004851cab9b8d3` |
| commit that carried it | `ad6c95e94d95deb408754e379d2ccf8cd625f497` (2026-08-23, RELEASE FLOOR ERRATUM /0 SUCCESSOR) |
| still current on `main`? | **yes** — `git rev-parse main:<path>` = `fb99a6b6…` at `main` = `b2eb14e691e16146769c7f06b208edcb084738a2`; the file has not been touched since `ad6c95e9` |
| line count | 944 |

**The S15 row, verbatim**, `experiments/latent-lisp/warrant-calculus/LMP0-clauses-CD-LCI.md:36`:

> `| S15 | `experiments/latent-lisp/mneme/verify-release.sh` | `ad6c95e9` 2026-08-23 | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` | Carried DECLARED row, verbatim at `:360` — quoted in full in **LCI/0 §3** below. |`

---

## 2. NEW IDENTITY (the reviewed candidate)

| field | value |
|---|---|
| path | `experiments/latent-lisp/mneme/verify-release.sh` (unchanged) |
| git blob | `8cbc50c772b5225d02caac6df38883bf7dcb437e` |
| file sha256 | `5df120b1723655bcf333dc181d43fa31289c53b378a6aba559c35251588a4b69` |
| candidate commit | `2e0b8d1df67f0443306c41bd62b36c717c9ae53e` on branch `candidate/floor-status-sentences-0` |
| candidate parent | `9f1cac5793117114bdb2cd02f71a3580c63979c8` — verified an ancestor of `main` (`git merge-base --is-ancestor`, exit 0) |
| paths changed by the candidate | exactly one: `experiments/latent-lisp/mneme/verify-release.sh` |
| reviewed archive sha256 | `ec98ff8df6fb8dd821e87c16551d642017010a1aad06606fdef912dd99340e7f` (as given in the commission; **not re-derived here** — see §7) |
| line count | 969 (+25) |

**Line-number consequence, stated because pins cite lines:** the insertion sits at old line 222; every line
of the file at old number ≥ 233 moves **+25**. The carried `lci0` DECLARED row moves `:360 → :385`; the
section header *"DECLARED, NOT EXECUTED — carried honestly, never turned green"* moves `:355 → :380`; the
`ml0` row moves `:366 → :391`. **The quoted TEXT of the `lci0` row and of that header is byte-identical in
both blobs** — only their line numbers move. See `PIN-SITES.md`.

---

## 3. AUTHORITY CHAIN (verbatim, with paths)

**(a) The substance of the new sentence** — `experiments/latent-lisp/mneme/architecture/ARCHITECTURE-0-STATUS.md`,
ADDENDUM 25 item 6 ("STANDING AS DISPOSED", at `:1451`, entered 2026-09-17), verbatim:

> **ADOPTED AND PUBLISHED · STRICT STRANGER AUDIT PERFORMED AND RECEIVED · STRANGER-AUDIT OBLIGATION
> DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED · P9 CLAIM-CEILING DEFECT CORRECTED IN THE PROOF
> COMMENT IN CANDIDATE 015c9d17d AND CARRIED ON LAB `main` AND THE PUBLIC MIRROR — ENTRY DISPOSED AT THAT
> SCOPE AND NO WIDER · P9 FAIL STANDS IN THE REGISTER · `ml0.lisp:3002` COMPANION COMMENT UNCORRECTED · NO
> SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED.**

The same item adds, verbatim: *"This does not confer blanket 'independently verified' status."*
Its predecessor, ADDENDUM 24 item 6 ("TERMINAL STANDING (Sol II §V, quote exactly)", at `:1396`,
2026-09-01), which ADDENDUM 25 item 6 supersedes *for current navigation only*, remains in force as the
record of the pre-disposition standing.

**Checked, not assumed:** the 458-character standing sentence quoted inside the candidate blob is
byte-identical (whitespace-normalised, comment marks and bold markers stripped) to the sentence in
ARCHITECTURE-0-STATUS.md. Programmatic check, exit 0.

**(b) The review-acceptance** — the ruling office (Astra, GPT-6; general succession over Sol per
`corpus/voices/received/2026-09-17-150021-owner-word-GENERAL-succession-astra-over-sol-VERBATIM.md`),
in the reply file `C:\Users\Tomás Pavam\Downloads\Fable-Reply-02-Candidate-Review-and-Terminal-Steps.md`
(WSL path `/mnt/c/Users/Tomás Pavam/Downloads/…`, sha256 `943767ba917c4347ec54123dd509b0676bc40bd7b8f1062734c70e8cc37f4eeb`,
10,938 bytes, verified present 2026-09-21), verbatim:

> "This accepts the wording repair for integration through the existing owner and pin procedure. It does
> not itself change an adopted pin, adopt additional semantics, discharge the remaining ML/0 programme, or
> authorize publication. Prepare the exact erratum with old and new identities and its scope, then the
> minimal landing operation for Tomás's authorization. Preserve the old pin as historical evidence. Do not
> bundle the demonstration or `ml0.lisp:3002` into that decision."

**DISCLOSURE — the reply is NOT YET DOCKED.** `corpus/voices/received/` contains no 2026-09-21 file
(`ls … | grep 2026-09-21`, exit 1). Until it is docked verbatim, this erratum's authority citation rests on
a file outside the repository. **Docking it is a precondition of adopting this erratum**, not a follow-up.

**(c) The landing procedure** — the owner's authorization. This document proposes no act of its own.

---

## 4. WHAT THIS ERRATUM DOES NOT DO

Verbatim, the ruling office's four exclusions. This erratum:

> - does not "change an adopted pin";
> - does not "adopt additional semantics";
> - does not "discharge the remaining ML/0 programme";
> - does not "authorize publication".

Added by the drafter, from the status stone's own list (ADDENDUM 25 item 8): it authorizes no ML/0 source
repair, no application of `ml0-3002.patch`, no test-instrument repair, no adoption change, no registration,
no ML/1 reopening, no integration of any other candidate branch, no sentinel lowering, no public transport.
`ml0.lisp:3002` is untouched and its companion comment stands UNCORRECTED. **P9 FAIL STANDS IN THE
REGISTER.** The demonstration is not bundled here and is not referenced as evidence for this repair.

---

## 5. EVIDENCE (each item measured 2026-09-21, command and exit recorded)

| # | evidence | result |
|---|---|---|
| E1 | `git diff 2e0b8d1df^ 2e0b8d1df` | two hunks, +31/−6, one file |
| E2 | `git diff --name-only 2e0b8d1df^ 2e0b8d1df` | `experiments/latent-lisp/mneme/verify-release.sh` — exactly one path, exit 0 |
| E3 | blob identities | `2e0b8d1df:<path>` = `8cbc50c7…` · `main:<path>` = `fb99a6b6…` · `2e0b8d1df^:<path>` = `fb99a6b6…` (the candidate's base equals `main`'s copy) — all exit 0 |
| E4 | file sha256, both blobs | old `ecb03c9d…`, new `5df120b1…` (via `git cat-file blob … \| sha256sum`), matching the commission's values |
| E5 | `--list` diff | simulated from both blobs' `GATES`/`DECLARED` tables with the script's own `printf` formats (the script itself was NOT run): **124 lines each, exactly one differing line**, the `ml0` headline |
| E6 | enumeration | `both+full` = **112**, `both+ci` = **82**, identical in both blobs |
| E7 | verbatim check | the ADDENDUM 25 item 6 standing sentence (458 chars) present byte-identical in both the status stone and the candidate blob |
| E8 | syntax | `bash -n` on the extracted candidate blob → **exit 0** |
| E9 | **candidate floor** | **PASS 112/112, 0 blocked, 9 carried rows, profile full, exit 0** at commit `2e0b8d1df`, in a disposable detached clone (`/tmp/candidate-floor.svuyXq`), 2026-09-21. Transcript `_staging/2026-09-21-commission-02/floor-candidate-2e0b8d1d.transcript.txt`, sha256 **`6bbb893a0fc39942a5ce86068d4fbd08cad9f9e5e27897b9c6ae92c7c564d387`**; meta file beside it |

E9's transcript and meta live in `_staging/` and are **not committed**; if this erratum is adopted they must
be carried into its directory, since `_staging` is excluded from the published subject tree.

---

## 6. TREATMENT OF EACH PIN SITE

Full table with `path:line`, exact text and class: **`PIN-SITES.md`** (same directory).

**(a) Dated historical captures — PRESERVED UNEDITED.** Every site under
`experiments/latent-lisp/mneme/release-floor-erratum-0/` (the SUCCESSOR-RETURN identity table, the R2B
receipt, the joint-instruction receipt, the predecessor→successor diff header, the two identity captures
and the dirty-entry transcript) and the two dated handoff notes record what was true on their date. They
are **evidence**, not navigation, and are not edited. This is the ruling office's instruction — *"Preserve
the old pin as historical evidence."*

**(b) The S15 row — NOT EDITED; the successor identity is RECORDED BESIDE IT.**
`experiments/latent-lisp/warrant-calculus/LMP0-clauses-CD-LCI.md:36` (with its dependent line citations at
`:1155` and `:1158`) is a **dated extraction**, stamped `ad6c95e9` 2026-08-23 and blob-pinned in
`experiments/latent-lisp/warrant-calculus/PROVENANCE.md` (`32af658b…`). Per **ARCHITECTURE-0-STATUS.md
ADDENDUM 25 item 7**, verbatim:

> "**Sites that become dated on application, deliberately not edited.** … and `warrant-calculus/` — its
> extractions quote the 2026-09-01 sentence, and `LMP0-clauses-SA-ML0.md` pins this file as blob
> `504be220…`, which this addendum makes historical. Those files are blob-pinned in
> `warrant-calculus/PROVENANCE.md` and published; they are dated extractions and are not to be edited for
> this record."

The same rule governs here. **This erratum is therefore the record of the successor identity**: S15's
extraction remains true of `ad6c95e9`, and a reader who needs the current object reads this document.
The row's substantive quotation — the `lci0` DECLARED row and its section header — is **unchanged in text**;
only its line numbers move (`:360 → :385`, `:355 → :380`).

---

## 7. LIMITS OF THIS DRAFT

- The **reviewed archive sha256** `ec98ff8d…` was taken from the commission and **not re-derived**; the
  archive it names was not located in the tree by this drafter. Re-derive it before adoption, or record it
  as a received value.
- The ruling office's reply is **not docked** in `corpus/voices/received/` (§3b).
- The candidate floor (E9) was run by the lab's own hand on the lab's own toolchain: it is
  **self-consistency certification, never independent conformance** — the script says so at every run, and
  the stranger primitive-minimization audit named in its header **remains OWED and uncommissioned**.
- This erratum was drafted by a Claude instance in the lab's own harness. It is testimony about the tree
  supported by commands and exits; it is not an outside witness.

---

## 8. WHERE THIS SHOULD LIVE IF ADOPTED (proposal only — nothing created)

Following the `release-floor-erratum-0/` precedent (a self-contained directory under `mneme/` holding the
return, the receipts, the identity captures and the teeth):

```
experiments/latent-lisp/mneme/floor-status-sentences-erratum-0/
├── S15-ERRATUM-0.md                      ← this document, as adopted
├── LANDING-RECORD.md                     ← the executed landing, with measured outputs
├── PIN-SITES.md                          ← the pin census
└── evidence/
    ├── candidate.diff                    ← git diff 2e0b8d1df^ 2e0b8d1df
    ├── list-diff.txt                     ← the one-line --list difference
    ├── floor-candidate-2e0b8d1d.transcript.txt      (+ .meta)
    └── IDENTITY-CAPTURE.txt              ← blob + sha256, before and after
```

**Nothing under that path has been created.** Creating it is part of the landing act, not of this draft.

*— PLINTH, drafter, 2026-09-21. Records only. Nothing here is authorization.*
