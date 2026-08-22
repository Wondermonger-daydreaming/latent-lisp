# ONE ACT /0 — PUBLICATION-RECOVERY DETERMINATION (Round OA)

**CANDIDATE parcel — Round OA; not an adoption; frozen court-construction
baseline commit `71422395`; read-only over adopted history; zero evidence
toward any PortJ/0 station.**

Determined under OWNER RULINGS 2 (2026-08-10), section *"One Act tree-membership
ruling"*, which splits the question into **OA-I (cryptographic inclusion)** and
**OA-N (normative incorporation)** and requires separate findings per document.
Nothing was promoted, copied, repaired, or committed by this determination. The
sealed stranger packet was located and digest-verified but **not opened**.

---

## 0. The subject and the coordinates, resolved

| Coordinate | Value | How resolved |
|---|---|---|
| Candidate commit | `461f2013d1a6feca2b13819ff6ae3f60617e8e82` | `git rev-parse 461f2013d1a6feca2b13819f` |
| Candidate tree | `1123c3c3326664f54d1d96547ba872a876cbd495` | `git rev-parse 461f2013^{tree}` |
| Freeze ref | `refs/remotes/origin/oneact/candidate-freeze-2026-08-07` → `461f2013…` | `git show-ref \| grep -i oneact` |
| Adoption merge | `8e86fff3b30dd27393f2f98187c7fff56c9f453a` (parents `495ebdc9` + `461f2013`) | `git log -1 --format='%H %p %s' 8e86fff3` |
| Closure bundle | `~/Downloads/oneact-0-candidate-r23-SELFCONTAINED.bundle`, sha256 `598c0cfc…f90635` | see `BUNDLE-REMATERIALIZATION-TRANSCRIPT.txt` |
| Sealed stranger packet | `~/Downloads/oneact-0-stranger-packet-2026-08-08.tar.gz`, sha256 `05731799…6d0d` — **UNOPENED** | `sha256sum` only |
| HEAD at determination | `d0aae0c7` (a `session-checkpoint` hook commit over `53f69972`) | `git rev-parse HEAD` |

⚠ **One coordinate correction to the record.** The **local** branch
`refs/heads/oneact/candidate-freeze-2026-08-07` **no longer exists on this
machine**; only the remote-tracking ref does.

```
$ git rev-parse refs/heads/oneact/candidate-freeze-2026-08-07
refs/heads/oneact/candidate-freeze-2026-08-07
fatal: ambiguous argument 'refs/heads/oneact/candidate-freeze-2026-08-07': unknown revision …
$ git show-ref | grep -i oneact
461f2013d1a6feca2b13819ff6ae3f60617e8e82 refs/remotes/origin/oneact/candidate-freeze-2026-08-07
```

The ref is preserved on the remote and is reachable; nothing is lost. But
"`git log … from the freeze ref`" as written in the chair's proposal does not
execute on this checkout without the `origin/` qualifier. Recorded, not repaired.

---

## PART I — OA-I: CRYPTOGRAPHIC INCLUSION

### I.1 The six legs, and the command that decides each

| Leg | Command | Result |
|---|---|---|
| exact blob identity | `git rev-parse 1123c3c3…:<path>` + `git hash-object <worktree path>` | agree, 5/5 |
| exact path | `git ls-tree -r 1123c3c3… -- _staging/oneact-candidate/` | 5 paths, mode `100644`, exactly the five |
| membership in candidate tree | same `ls-tree` | 5/5 present |
| containment in adoption-time bundle | fresh empty repo + `git bundle verify` + fetch + `ls-tree` + `cat-file blob \| sha256sum` + `cmp` | 5/5 IDENTICAL — full transcript in `BUNDLE-REMATERIALIZATION-TRANSCRIPT.txt` |
| byte identity with present tracked copy | `git rev-parse HEAD:<path>`, `git hash-object`, `sha256sum`, `cmp` | 5/5 identical |
| absence of post-adoption drift | `git diff --stat 461f2013 HEAD -- _staging/oneact-candidate/`; `git log --oneline 461f2013..HEAD -- …`; `git status --porcelain …` | all three EMPTY |

### I.2 The blob table (the deed itself)

```
$ git ls-tree -r 1123c3c3326664f54d1d96547ba872a876cbd495 -- _staging/oneact-candidate/
100644 blob b343ee6767c59ba08a251e5ce05aa8c1bb262c2e	_staging/oneact-candidate/ONE-ACT-0-CONTRACT-CANDIDATE.md
100644 blob 6d8d8dd51c529bce37aa3fe78b0e8696861ff3f9	_staging/oneact-candidate/ONE-ACT-0-FAILURE-MATRIX.md
100644 blob 4738e20805e4df58d6f3db6c59cfca8c6733ccb1	_staging/oneact-candidate/ONE-ACT-0-IDENTITY-TABLE.md
100644 blob 77c8a7053cf47c3ef14b9c1083dfb066727af320	_staging/oneact-candidate/ONE-ACT-0-SPECIMEN.md
100644 blob 6cbdb36b816870bf5e71b4f33765f630d5765252	_staging/oneact-candidate/ONE-ACT-0-TEST-PLAN.md
```

| Document | git blob (sha1) | content sha256 | in tree `1123c3c3` | in bundle `598c0cfc` | = HEAD blob | = worktree bytes | drift `461f2013..HEAD` |
|---|---|---|---|---|---|---|---|
| ONE-ACT-0-CONTRACT-CANDIDATE.md | `b343ee67…62c2e` | `8d8effe7…24e8a` | ✔ | ✔ `cmp: IDENTICAL` | ✔ | ✔ | none |
| ONE-ACT-0-FAILURE-MATRIX.md | `6d8d8dd5…ff3f9` | `862c7561…4c194b` | ✔ | ✔ `cmp: IDENTICAL` | ✔ | ✔ | none |
| ONE-ACT-0-IDENTITY-TABLE.md | `4738e208…3ccb1` | `518c4372…38c2f` | ✔ | ✔ `cmp: IDENTICAL` | ✔ | ✔ | none |
| ONE-ACT-0-SPECIMEN.md | `77c8a705…af320` | `c78eb483…63cd58` | ✔ | ✔ `cmp: IDENTICAL` | ✔ | ✔ | none |
| ONE-ACT-0-TEST-PLAN.md | `6cbdb36b…65252` | `5fe00bca…8e6a4a` | ✔ | ✔ `cmp: IDENTICAL` | ✔ | ✔ | none |

The merge commit carries the same five blobs unchanged
(`git ls-tree -r 8e86fff3 -- _staging/oneact-candidate/` reproduces the table
above), and `git merge-base --is-ancestor 461f2013 HEAD` succeeds — the adopted
candidate is in HEAD's ancestry.

### I.3 OA-I verdicts

| Document | OA-I verdict |
|---|---|
| ONE-ACT-0-CONTRACT-CANDIDATE.md | **PROVEN** (all six legs) |
| ONE-ACT-0-FAILURE-MATRIX.md | **PROVEN** (all six legs) |
| ONE-ACT-0-IDENTITY-TABLE.md | **PROVEN** (all six legs) |
| ONE-ACT-0-SPECIMEN.md | **PROVEN** (all six legs) |
| ONE-ACT-0-TEST-PLAN.md | **PROVEN** (all six legs) |

**Note on what OA-I does and does not say.** OA-I is proven at the *bundle*
level, not merely by tree ancestry: the adoption-time artifact was found,
digest-matched, verified and materialized in isolation, and its blobs compared
byte-for-byte. Per the owner's ruling this settles cryptographic inclusion and
nothing else.

### I.4 A cryptographic fact that belongs to OA-N, recorded here because OA-I found it

**No record anywhere in this repository hashes the ADOPTED bytes of these five
documents individually.** The five *were* individually sha256-hashed at three
earlier freezes; every one of those digests is superseded:

```
$ for h in 8d8effe7… 862c7561… 518c4372… c78eb483… 5fe00bca… ; do git grep -n "$h"; grep -rl "$h" --include='*.md' --include='*.txt' . ; done
(no output for any of the five)
```

| Freeze point | commit | per-file digests recorded in | equal to adopted bytes? |
|---|---|---|---|
| pre-R1 candidate freeze | `6c05a9e0` | `_staging/oneact-freeze-receipt.md` (5 rows) | **NO** |
| R1 repair freeze | `0f59cb8b` | `_staging/oneact-r1-freeze-receipt.md` (5 rows) | **NO** |
| R2 pre-code seal | `3c4e704d` | `_staging/oneact-r2-seal-receipt.md` (5 rows, e.g. contract `a27d3806…`) | **NO** |
| implementation round (last doc amendment) | `5ea01c9d` | *(no per-file digest table)* | = adopted |

```
$ git diff --stat 3c4e704d 461f2013 -- _staging/oneact-candidate/
 ONE-ACT-0-CONTRACT-CANDIDATE.md | 113 ++++++++--
 ONE-ACT-0-FAILURE-MATRIX.md     |  58 +++++-
 ONE-ACT-0-IDENTITY-TABLE.md     |  14 +-
 ONE-ACT-0-SPECIMEN.md           | 218 ++++++++++++++++-----
 ONE-ACT-0-TEST-PLAN.md          |  16 +-
 5 files changed, 342 insertions(+), 77 deletions(-)
```

So **all five documents changed after the last freeze that hashed them one by
one.** The adopted bytes are covered by exactly one collective object —
tree `1123c3c3` inside bundle `598c0cfc…` — which is precisely the "hash by tree
membership" the owner's ruling declines to treat as normative incorporation.

**And the post-seal amendments were CHAIR rulings, not owner rulings.** The
`3c4e704d → 461f2013` diffs are the R2.1 erratum:

```
$ git diff 3c4e704d 461f2013 -- …/ONE-ACT-0-CONTRACT-CANDIDATE.md | grep '^+' | grep -i 'R2.1'
+BIND-3  ⚑ SPLIT INTO TWO CONJUNCTS BY CHAIR RULING 2 OF THE R2.1 ERRATUM
+**⚑ THE COVERAGE ENUMERATION IS AMENDED BY CHAIR RULING 2 OF THE R2.1 ERRATUM …
+**⚑ THE ANTECEDENT IS LOAD-BEARING, AND ARM B-R DOES NOT SATISFY IT (R2.1
+erratum, chair ruling 1, 2026-08-07).**
```

The contract's own §0.2 precedence list ranks "**This contract, once sealed**" at
tier 3. The seal was taken at `3c4e704d`; the adopted bytes are the *post-seal*
text. Whether tier 3 attaches to the sealed bytes or to the adopted bytes is an
owner question this determination poses and does not answer.

---

## PART II — OA-N: NORMATIVE INCORPORATION

The owner's ruling enumerates seven evidence heads. Each is worked below with
the load-bearing text quoted exactly.

### II.1 The adoption record's exact scope language

`experiments/latent-lisp/mneme/language-act-0/ADOPTION-RECORD-2026-08-08.md`,
heading and body verbatim:

> ## The adopted object, exactly
>
> - **Candidate commit:** `461f2013d1a6feca2b13819ff6ae3f60617e8e82`
> - **Candidate tree:** `1123c3c3326664f54d1d96547ba872a876cbd495`
> - **Ref:** `refs/heads/oneact/candidate-freeze-2026-08-07`
> - Merged into `main` **unmodified** — no rewrite, rebuild, cherry-pick,
>   squash, or semantic change; this record and the live release-floor status
>   row are the only administrative additions.

**Finding.** The adoption record's scope language is **entirely object-level**.
It adopts *a commit, a tree, a ref, and a bundle*. It **never names a lane, a
packet, a document, a document set, or a clause.** Measured:

```
$ A=…/language-act-0/ADOPTION-RECORD-2026-08-08.md
$ for t in ONE-ACT-0-CONTRACT-CANDIDATE ONE-ACT-0-SPECIMEN ONE-ACT-0-TEST-PLAN \
           ONE-ACT-0-FAILURE-MATRIX ONE-ACT-0-IDENTITY-TABLE _staging \
           contract specimen "test plan" document ; do
      printf '%-32s %s\n' "$t" "$(grep -c -i -F -- "$t" $A)" ; done
ONE-ACT-0-CONTRACT-CANDIDATE     0
ONE-ACT-0-SPECIMEN               0
ONE-ACT-0-TEST-PLAN              0
ONE-ACT-0-FAILURE-MATRIX         0
ONE-ACT-0-IDENTITY-TABLE         0
_staging                         0
contract                         0
specimen                         0
test plan                        0
document                         0
```

The adoption record does not contain the word **"contract"**, the word
**"specimen"**, the phrase **"test plan"**, or even the word **"document"**.

The record's substantive paragraphs concern the stranger-audit variance, the
standing table (Surface /3 shut, D1 closed, R2.4 not commissioned) and the
claims ceiling. **No sentence of it addresses which bytes in the adopted tree
are law.**

### II.2 Whether the record adopts the whole tree, a named lane, a named packet, or an enumerated set

It adopts **the whole tree**, by hash, with no enumeration. The consequence,
measured rather than argued:

```
$ git -C <fresh bundle repo> ls-tree -r --name-only 1123c3c3… -- _staging/ | wc -l
375
```

The same adopted tree carries, under `_staging/`, e.g.
`_staging/alien-descartes-H1.md`, `_staging/alien-hume-H2.md`,
`_staging/2026-07-03-geomancy-review-and-opus-instructions.md`,
`_staging/bench_perm_null.py`, `_staging/HERALD-gemini-first-meeting.md`.

**Finding.** If tree membership alone incorporated law, the owner's terminal
adoption of One Act /0 would have enacted 375 staging files including geomancy
reviews, alien-philosopher probes and a Python permutation-null benchmark as
One Act /0 law. The owner's ruling anticipates exactly this: *"Git is a superb
notary of luggage; it is less gifted at determining which suitcase contained the
constitution."* This measurement is the suitcase count.

### II.3 Whether the closure transcript identifies the five-document normative set

`CLOSURE-TRANSCRIPT-2026-08-08.txt`, complete content classes: bundle digest;
fresh empty repo; `git bundle verify`; materialize; commit/tree equality; PASS.

**Finding. It does not.** The transcript names **no file inside the tree**. It is
an object-closure instrument only. (The untracked working copy
`_staging/oneact-terminal-closure-transcript.txt` is byte-equivalent in content
to the tracked one; it adds nothing.)

### II.4 Whether owner rulings during R1 / R2 / R2.1 explicitly adjudicate clauses IN these documents

**They do, extensively — this is the strongest OA-N evidence in the record.**

**R1** (`_staging/oneact-owner-ruling-r1-2026-08-07.md`, transcribed verbatim by
the chair; commit `0f59cb8b`) quotes the test plan against itself and rules on
its content:

> More decisively, the candidate's own test plan says:
> > MUST RESOLVE FOR /0 — the seal may not be taken with these open
> and then records eleven unresolved blockers, MR-1 through MR-11. The failure
> matrix records fourteen open rows.

and closes with a scope disposition:

> This ruling authorizes a bounded **One Act /0 R1 documentary repair round**.
> It does not open the lane and does not authorize implementation.

**R0.1** (`_staging/oneact-owner-ruling-r0.1-en-2026-08-07.md`, direct owner
instrument; executed in `3c4e704d`) directly commands edits to the documents'
clause text:

> Correct the frozen vector count from **52 to 63** everywhere it appears.

> Delete the token branch from the normative plan. An `act-token` may survive
> only as a fixture label with no semantic, identity, or uniqueness role.

> The ACT-4 `[a-z0-9-]` rule is **not adopted as a public act-token grammar** …
> It may remain only as a rendering law for fixed lane-owned textual segments.

**R2.3** (`_staging/oneact-owner-ruling-r2.3-2026-08-08.md`) is the last ruling
before adoption, and its disposition block reads:

> ADOPTION, MERGE, AND PUBLICATION NOT AUTHORIZED.

**Finding.** The owner unquestionably **read, quoted, and amended clauses in
these documents** through three rounds. That establishes that the documents were
*operative during construction* and that their content passed under the owner's
eye. It does **not**, on its own, establish that the terminal adoption act
*incorporated* them: every ruling that adjudicates their clauses also states, in
terms, that it does not adopt. The instrument that *did* adopt is the one whose
scope language never names them (§II.1).

**And that instrument's verbatim text is not in the repository.** The
adoption record calls it *"owner superseding ruling 'ONE ACT /0 R2.3 TERMINAL
ADOPTION' (2026-08-08, direct)"*; the handoff addendum says the ruling text was
*"filed as the ruling text within this addendum's receipt trail"* and that the
*"[f]ull terminal receipt [was] delivered in-chat."*

```
$ grep -rl -iE 'adoption (is )?authorized' --include='*.md' --include='*.txt' .
notes/2026-08-07-session-handoff-oneact-r2-seal.md          ← chair prose, not the ruling
$ git grep -l -i 'superseding ruling'
experiments/latent-lisp/mneme/language-act-0/ADOPTION-RECORD-2026-08-08.md
notes/2026-08-07-session-handoff-oneact-r2-seal.md
notes/2026-08-08-session-handoff.md
```

**⚠ EVIDENCE GAP, load-bearing: the adoption instrument survives only in
chair-authored summary.** Every OA-N judgment about "the owner's adoption act"
is therefore a judgment about the chair's *record of* that act. The owner is the
only party who can supply the missing scope language.

### II.5 Whether adopted source and gates cite those clauses as governing law

They do — for **three** of the five documents, and **not at all** for the other
two.

```
$ cd experiments/latent-lisp/mneme/language-act-0
$ grep -oh -E 'contract[^A-Za-z0-9]{0,3}§[0-9A-Za-z.()-]+' *.lisp *.sh | sort | uniq -c
      1 contract §0.3        1 contract §0.4       1 contract §1)
      1 contract §10         1 contract §14.1      2 contract §14.2
      1 contract §2.3).      2 contract §2.4).     2 contract §2A
      1 contract §2A.0).     3 contract §4         1 contract §5.1a).
      1 contract §6.3
$ grep -n -i 'test plan' *.lisp *.sh          → 5 sites (act0-gates.lisp:19,256,292,560,562)
$ grep -n -E 'specimen' *.lisp *.sh           → 11 sites
$ grep -n -E 'MX-[0-9]' *.lisp *.sh           → (no output)
$ grep -n -E '\bI-[0-2][0-9]\b' *.lisp *.sh   → (no output)
$ grep -n -i -E 'matrix|identity tab' *.lisp *.sh
act0-fixtures.lisp:141:… ⚠ THIRTEEN, counted: the bundle's own matrix   ← not a citation
```

Representative governing-law citations (verbatim):

- `package.lisp:3` — `;;;; Governing sentence (contract §1): one Lisp+ form gives rise to one …`
- `act0.lisp:3-6` — `;;;; The numbered trace of contract §4 (L0..L22), the act identity of §2A, the journal projection of §3.2, the agreement gate of §6.3, and the refusal law of §2.6a.`
- `act0-gates.lisp:19` — `;;; The frozen corpus — test plan §5.2 · §5.3 · §5.4 · §5.5 · §5.6 · §5.6a · §5.6b.`
- `act0-gates.lisp:530` — `"Specimen BR-03/BR-04/BR-08 — the frames that must NOT exist, asserted BY …"`

**Finding.** The **contract**, **specimen** and **test plan** are cited by the
adopted sources as the law those sources implement. The **failure matrix** and
**identity table** are cited **zero times** by any adopted source or gate — their
row identifiers (`MX-nn`, `I-nn`) appear nowhere in the lane.

Downstream corroboration for the specimen, from a live successor lane:
`language-many-acts-0/AUTHOR-GUIDE.md:304` — *"the seven **adopted** One Act /0
arms of the *scriba / inscribere* specimen"*; `MANY-ACTS-0-GRAMMAR.md:63` —
*"`:arm` must be one of the seven adopted arms"*. Many Acts treats the
specimen's arms as adopted law. It cites One Act by **commit and tree**
(`MANY-ACTS-0-CONTRACT-CANDIDATE.md:13`), never by document.

### II.6 Whether any record excludes `_staging`, candidate documents, or non-lane paths from normative adoption

**No record excludes them from normative adoption.** What the records do say:

- The mirror channel excludes `experiments/latent-lisp/_staging/**` — *and that
  is a different directory.* The subject documents live at **repo-root**
  `_staging/oneact-candidate/`, which is outside the mirror's
  `:source-scope "experiments/latent-lisp/**"` entirely
  (`architecture/CHANNEL-POLICY-latent-lisp-mirror-DRAFT.md:21,33`). Their
  non-publication is a **location** fact, not an exclusion ruling.
- The channel policy's own note: *"`_staging/` is excluded from the MIRROR only;
  it still lives in the lab repository."* — publication-scope, not norm-scope.
- The housekeeping/triage records classify `_staging/oneact-candidate/` as
  **`LIVE-ARC — DO NOT TOUCH`** (`notes/2026-08-07-staging-triage-survey.md:340`,
  `notes/2026-08-07-housekeeping-disposition.md:593`) — i.e. protected working
  material of a running round. Neutral as to normativity, and written *before*
  adoption.

### II.7 Whether the documents were merely carried in the tree as construction material

**The documents say so themselves, in the adopted bytes.** Verbatim, from the
blobs proven identical in Part I:

- `ONE-ACT-0-CONTRACT-CANDIDATE.md:43-49` —
  > **Status: CANDIDATE PRE-CODE CONTRACT. Nothing here is adopted, accepted,
  > frozen, audited, or on a governing floor.** This is a draft of a contract, not
  > a contract in force: it has not been commissioned, ruled on, or sealed. It is a
  > proposal for what the round's binding pre-code artifact should say.
  >
  > **Authority claimed: none.**
- `ONE-ACT-0-FAILURE-MATRIX.md:3` and `ONE-ACT-0-IDENTITY-TABLE.md:3` and
  `ONE-ACT-0-TEST-PLAN.md:3` —
  > **Standing: CANDIDATE STAGING. Adopts nothing, opens nothing, seals nothing.**
- `ONE-ACT-0-SPECIMEN.md:20` —
  > **Standing: CANDIDATE PRE-CODE. No implementation exists.**

Every filename ends in `-CANDIDATE.md` or carries `(CANDIDATE, PRE-CODE)` in its
title line.

**Counterweight, stated at its true size.** These self-descriptions are
*stale fossils*: the specimen's "No implementation exists" is false of the
adopted tree (the implementation is in it), and the adopted lane source
`act0.lisp:8` likewise still reads *"CANDIDATE. Nothing here is adopted"* while
sitting in a lane the owner adopted. A document's self-description is therefore
**weak evidence in both directions** — it did not stop the lane being adopted,
and it is not a disclaimer the owner authored. It is recorded because the owner's
evidence list asks for it, and because *no instrument ever struck it*.

### II.8 OA-N verdicts

| Document | OA-N verdict | Governing evidence |
|---|---|---|
| ONE-ACT-0-CONTRACT-CANDIDATE.md | **NOT ESTABLISHED** (strongest case of the five) | FOR: cited as governing law at 15+ adopted source sites (`contract §1`, `§4`, `§2A`, `§6.3`, `§2.4`, `§14.1/2`, `§5.1a`, `§10`, `S-1..S-4`, …); owner rulings R0.1/R1 command edits to its clauses. AGAINST: adoption scope language never names it; adopted bytes are post-seal chair-erratum text; document declares *"Authority claimed: none."* |
| ONE-ACT-0-SPECIMEN.md | **NOT ESTABLISHED** | FOR: cited by adopted gates (`specimen BR-11`, `BR-03/04/08`, `FS-02`, `§2.1`, `§2.4`); a live successor lane calls its arms *"the seven adopted … arms"*. AGAINST: same three as the contract; also amended post-seal by chair ruling 1. |
| ONE-ACT-0-TEST-PLAN.md | **NOT ESTABLISHED** | FOR: cited at `act0-gates.lisp:19,256,292,560`; owner R1 quotes its MUST-RESOLVE register as binding on the seal. AGAINST: same three; and its §5.7 was overtaken by run output (`act0-gates.lisp:562`: *"the sealed test plan is …"*). |
| ONE-ACT-0-FAILURE-MATRIX.md | **NOT ESTABLISHED — and materially weaker** | FOR: owner R1 reasons from it (*"The failure matrix records fourteen open rows"*). AGAINST: **zero citations from any adopted source or gate**; its own header says it is *"governed by"* the contract and specimen, i.e. it is downstream analysis, not upstream law. |
| ONE-ACT-0-IDENTITY-TABLE.md | **NOT ESTABLISHED — and materially weaker** | FOR: repaired under owner-ruled rounds R1/R2. AGAINST: **zero citations from any adopted source or gate**; its own header: *"Where this table and the contract differ, **the contract controls**"* — self-declared subordinate. |

**No document reaches INCORPORATED. No document reaches EXCLUDED.** Nothing in
the record excludes them; nothing in the adopting instrument includes them by
name. The honest verdict for all five is the middle one, and the owner's ruling
already prescribes what follows from it: *"If cryptographic inclusion is proven
but normative incorporation remains unproven, classify the material as category
2 — reviewed candidate material — not category 1."*

---

## PART III — CLASSIFICATION

Per the owner's rule: **category 1 requires OA-I proven AND OA-N incorporated.**

| Document | OA-I | OA-N | **Category** |
|---|---|---|---|
| ONE-ACT-0-CONTRACT-CANDIDATE.md | PROVEN | NOT ESTABLISHED | **2 — reviewed candidate material** |
| ONE-ACT-0-SPECIMEN.md | PROVEN | NOT ESTABLISHED | **2** |
| ONE-ACT-0-TEST-PLAN.md | PROVEN | NOT ESTABLISHED | **2** |
| ONE-ACT-0-FAILURE-MATRIX.md | PROVEN | NOT ESTABLISHED | **2** |
| ONE-ACT-0-IDENTITY-TABLE.md | PROVEN | NOT ESTABLISHED | **2** |

**Category 1 is empty on the present record.** It is not empty *on the merits* —
it is empty because the one instrument that could fill it (the terminal adoption
ruling's scope sentence) is not on disk. A single owner sentence could move
three or five of these to category 1 without any new evidence.

### III.1 Clause-level splits within the five (recorded, not resolved)

Mixed classification is permitted, and three clause-classes inside otherwise
uniform documents behave differently:

| Clause-class | Location | Why it splits | Category if the owner elevates the parent document |
|---|---|---|---|
| **The R2.1 erratum amendments** (BIND-3n/BIND-3i split; A-5a coverage enumeration; arm B-R rewritten as the UNPAIRED F1; "six arms" corrected from "seven") | contract §2.4 / A-5a / A-6, specimen §6.1 and its trace | Authored by **chair ruling**, after the owner-blessed pre-code seal, never individually owner-ruled or hashed | **still 1 if the owner's adoption reaches the adopted bytes; 2 if it reaches only the sealed bytes** — the fork is real and the owner must pick |
| **The self-disclaimers** (*"Nothing here is adopted"*, *"Authority claimed: none"*, *"Standing: CANDIDATE STAGING"*, *"No implementation exists"*) | contract §0 head, other four at line 3/20 | False of the adopted state; no instrument struck them | **cannot be published as-is under a category-1 "no semantic adoption" label without publishing a falsehood** — see PROPOSED-PUBLICATION-ROUTE §4 |
| **`§5.7 V-F1..V-F5: SPECIFIED; OCTETS PENDING`** | test plan §5.7 | Superseded by run output during the implementation round (`act0-gates.lisp:560-562`); the frozen V-F table lives in `_staging/oneact-impl-evidence/v-f-freeze-table.txt`, sha256 `2b51b4df…1264f0`, **not in the test plan** | **3 — post-adoption/post-seal reconstruction territory**; the resolved octets are not in any of the five documents |

### III.2 Category 4 — law that exists only outside the five documents

Established in `COMMENT-LAW-SWEEP.md`: the entire **R2.2 loader-finality** and
**R2.3 promotion-closure** body of law (fail-closed loader, `act0-api-complete-p`,
`ACT0-LANE-FILES` fresh-copy/non-EQ semantics, "`act0-gates.lisp` remains the
last-loaded source and its readiness carrier remains its last form",
the 173-check sentinel runner, `H-AP0-COLLIDE` last, release-floor registration
97/77) **appears nowhere in the five documents** and lives only in (a) the two
owner rulings in `_staging/` and (b) source comments/docstrings.

**Consequence for the recovery's purpose (SD-13):** publishing all five
documents would **not** make the adopted lane's law publicly sufficient. Roughly
one round-and-a-half of adopted law is not in them.

---

## PART IV — THE CHAIR'S PRELIMINARY FACTS, RE-ESTABLISHED

| Chair's fact | Reproduces? | Note |
|---|---|---|
| **P-1** all five in the adopted candidate tree | **YES** | reproduced, and strengthened to bundle-level containment |
| **P-2** zero post-adoption drift | **YES** | `git diff --stat`, `git log`, `git status` all empty |
| **P-3** real construction history through R1/R2/impl rounds | **YES** | `6c05a9e0 → 0f59cb8b → 3c4e704d → 5ea01c9d`; owner rulings quoted in §II.4 |
| **Prima facie reading:** category 1, publication gap is a *location* accident | **DOES NOT REPRODUCE AS STATED** | The location accident is real. But the chair's reading assumed *"[t]he adoption bundled and merged the whole candidate tree; these paths were in it"* is sufficient — the owner's ruling of 2026-08-10 holds it is not. On the owner's own test the five land in **category 2**, and the chair's proposal said itself the parcel exists "to prove or break this reading". It broke, in the direction the owner predicted. |
| Chair's note: *"the record hashes the bundle and the candidate tree … never cited per-file"* | **YES, and sharper** | The five *were* hashed per-file at three earlier freezes; **every such digest is stale**, and no record hashes the adopted bytes individually (§I.4) |

---

## PART V — TENSIONS, EXPOSED AND UNRESOLVED

Per the ruling — *"Record both forms of evidence and let the recovery return
expose any tension"* — these are stated, not resolved:

1. **The sources cite what the adoption never named.** `package.lisp:3` calls
   contract §1 *"Governing sentence"*; the adoption record's scope language
   names no document at all. Operative use vs. owner scope, head-on.
2. **The adopted contract disclaims its own authority.** The bytes the owner
   merged say *"Authority claimed: none"* and *"not a contract in force"*, while
   the bytes of the adopted implementation call the same file governing.
3. **The sealed corpus is not the adopted corpus.** The last per-file seal is
   `3c4e704d`; all five changed afterwards, by chair ruling, and §0.2's
   *"this contract, once sealed"* does not say which text it means.
4. **Tree membership proves too much.** 375 `_staging/` paths ride the same
   adopted tree, including material with no relation to this lane.
5. **The adopting instrument is missing from the record.** Its scope language —
   the single most decisive item on the owner's own evidence list — exists only
   as chair summary and an in-chat receipt.
6. **Two of the five are cited by nobody.** Failure matrix and identity table
   have zero citations from adopted source, gates, or the successor lane; both
   declare themselves subordinate to the contract in their own headers.
7. **Publishing the five would not close SD-13.** The R2.2/R2.3 law is not in
   them (Part III.2).
8. **A successor lane already treats specimen arms as adopted law**
   (`AUTHOR-GUIDE.md:304`, `MANY-ACTS-0-GRAMMAR.md:63`) — a live downstream
   reliance that would be retroactively unsettled by a narrow OA-N ruling.

---

## PART VI — WHAT THIS DETERMINATION DID NOT DO

- Did not open, list, extract or decompress
  `~/Downloads/oneact-0-stranger-packet-2026-08-08.tar.gz` (digest verified
  `05731799…6d0d`, seal intact).
- Did not promote, copy, move, or publish any document.
- Did not repair any citation, including the one mis-attributed citation found
  (`act0.lisp:81` cites *"contract WE-04"*; `WE-04` is in the **specimen** and
  test plan, not the contract — see `CITATION-RESOLUTION-TABLE.md`).
- Did not convert comment-only law into prose law, or draft any missing clause.
- Did not modify any file in any lane or in `_staging/`; did not commit.
- Wrote only the six Round-OA deliverables in this directory.

— determined by TABELLIO (Claude Opus), Round OA, commissioned by the chair (Claude Fable 5), 2026-08-10
