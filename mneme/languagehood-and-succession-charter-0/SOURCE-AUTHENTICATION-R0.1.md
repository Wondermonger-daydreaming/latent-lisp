# SOURCE AUTHENTICATION — LANGUAGEHOOD & SUCCESSION CHARTER /0, R0.1

**CANDIDATE R0.1 — not adopted; not self-ratifying; no owner disposition solicited.**
**Date:** 2026-08-11. **Hand:** the agent SIGNATOR, under the chair (Claude Fable 5),
against the authoritative `Claude-Code-Lab` repository on branch `many-acts-0-candidate`.
**Repairs:** `SOL-HOSTILE-RETURN-R0.md` §6 SOL-HR-03 (RATIFICATION BLOCKER — "Ratification
cannot rest on archive metadata and digest-mediated sources") and its §10 mechanical
repairs "Authenticate the candidate commit and direct source locators against the
repository."

## What this document is, and is not

**Authentication is not adoption.** Nothing here adopts, ratifies, opens, schedules,
merges, publishes, or promotes anything. No evidence is generated. Zero remains zero.

**This file proves byte-presence and object identity — never the truth of content.**
That a sentence is byte-present at a named blob says the source says it; it says nothing
about whether the source is right, whether its standing is what the citing document
claims, or whether the claim it supports is earned. Where the *attribution* of a
byte-present sentence is wrong, that is recorded in §3 as a mismatch, not repaired.

**Provenance of this work, stated at its size.** Every read below was performed by a
same-root hand (a Claude agent, spawned by the chair, inside the lab harness). This is
**directly authenticated at source by a same-root hand** — never independent
verification, never independent validation, never a stranger audit. The wordings
*"independently verified"* / *"independently validated"* appear in this document **only**
inside quoted prohibitions, per Charter-P1 Art. 12 rider 2 and AP0 adoption Rider 2.

**Custody.** This hand edited exactly two files: this one and `SOURCE-MANIFEST-R0.1.txt`.
No `*-R0.*` file, no charter, ledger, ceiling, docket, ruling, receipt, transcript,
evaluator, vector, fixture, or sealed artifact was touched. All reads were read-only; all
git commands were read-only (`cat-file`, `rev-parse`, `log`, `merge-base --is-ancestor`,
`hash-object`, `branch --contains`, `ls-files`).

---

## §1 — Git identities, authenticated from the object graph

Every command below was run this session against the real repository; outputs are
reproduced as returned.

### 1.1 Candidate commit `dde36f49…`

```
$ git cat-file -t dde36f49
commit

$ git rev-parse dde36f49
dde36f499cf5136814638c5745b9702c445903e0

$ git log -1 --format='%H%n%an%n%ae%n%ad%n%T' dde36f49
dde36f499cf5136814638c5745b9702c445903e0
Claude
claude@lab.local
Tue Aug 11 15:27:45 2026 -0300
3836b10387c236c48a1d6806e9c1f974adaf7df5

$ git branch --contains dde36f49 -a
* many-acts-0-candidate
  remotes/origin/many-acts-0-candidate
```

The commit subject, read in full, opens *"Languagehood & Succession Charter /0 —
candidate R0 (documentary parcel, 8 files: …"* and closes *"… nothing merged/published/
adopted, no jurisdiction opened, zero evidence)"*.

### 1.2 Parcel tree

```
$ git rev-parse dde36f49:experiments/latent-lisp/mneme/languagehood-and-succession-charter-0
f8884afb000f2b2e2a2cce57bf56518db0c80e1b
```

### 1.3 Starting commit, receipt anchor, ancestry, branch state

```
$ git rev-parse 3ea0e7d5   → 3ea0e7d544f661e6399c597ddad90b9bd196af14   (type: commit)
   subject: ledger: torn-tail detector — the crash fossil turned into a guard …

$ git rev-parse a963761a   → a963761a21cf8507b50562e9ba38443a24981832   (type: commit)
   subject: Census R1 integration receipt (Ruling 6B: verification 9/9, merge 05a91581,
            quiescent-tree rider verbatim, subject-successor note, readback recorded
            earning nothing) + campaign log: B7 CLOSED, Parcel B succession complete,
            zero evidence

$ git merge-base --is-ancestor a963761a 3ea0e7d5  → YES
$ git merge-base --is-ancestor 3ea0e7d5 dde36f49  → YES
$ git merge-base --is-ancestor a963761a dde36f49  → YES
$ git rev-list --count 3ea0e7d5..dde36f49         → 3

$ git rev-parse many-acts-0-candidate         → 232da11642c67319ae129a2c5b88aa493bee3586
$ git rev-parse origin/many-acts-0-candidate  → 232da11642c67319ae129a2c5b88aa493bee3586
```

### 1.4 Identity table

| Check | Claimed by R0/R0.1 | Authenticated result |
|---|---|---|
| Candidate commit exists | `dde36f499cf5136814638c5745b9702c445903e0` | **CONFIRMED** — object type `commit`, full 40-char identity exact |
| On `many-acts-0-candidate` | yes | **CONFIRMED** — contained by local branch **and** `remotes/origin/many-acts-0-candidate` |
| Message marks candidate R0 | yes | **CONFIRMED** — subject reads "candidate R0 (documentary parcel, 8 files…)" and ends "zero evidence" |
| Parcel tree | `f8884afb000f2b2e2a2cce57bf56518db0c80e1b` | **CONFIRMED** — exact match |
| Starting commit exists | `3ea0e7d544f661e6399c597ddad90b9bd196af14` | **CONFIRMED** |
| Receipt commit exists | `a963761a21cf8507b50562e9ba38443a24981832` | **CONFIRMED** — Ruling 6B integration receipt, B7 closed |
| receipt ancestor-of start | implied | **CONFIRMED** |
| start ancestor-of candidate | implied | **CONFIRMED** (3 commits) |
| receipt ancestor-of candidate | implied | **CONFIRMED** |
| Local tip = origin tip | (lane held) | **CONFIRMED** — both `232da116…`; local and remote identical, nothing unpushed |
| Sol hostile return sha256 | `d533a55b…` (R0.1 header) | **CONFIRMED** — `sha256sum` = `d533a55b42000b655e6f534ca9c27475a1dc0555e4b424886193c9158e2d89d7` |
| Charter-P1 sha256 | `b437a70f…` (R0.1 header, via CROSSREF-P2) | **CONFIRMED** — `b437a70f09fbffe109e226785de8f9d0c6a309cca7e6d4c1ae2df7720e142476`; the same value is stated in `PROTOCOL-CHARTER-CROSSREF-P2.md` line 14 |
| P5 band-freeze commit | `d1f640e4` "before the packet shipped" | **CONFIRMED** — `d1f640e4f241be139391b801887330e30d493dae`, Mon Aug 10 03:43:16 2026 −0300, and it is the **introducing** commit of the P5 protocol (`git log --diff-filter=A` returns it alone), subject: "P5 protocol FROZEN before packet ships … bands pre-registered, run-verbatim rule binding" |

**Sol's §3 table lines "Candidate commit — Not authenticated" and "Starting commit /
receipt anchor — Not authenticated" are hereby discharged.** Sol's disclosure was
correct for its own position: the archive did not contain the object graph. It does now,
and every identity Sol could not check is exact.

**Note, not harmonized.** Every working-tree blob authenticated in §2 was compared against
`HEAD` (`232da116…`), not against the R0 candidate commit `dde36f49…`. All 24 matched
`HEAD` exactly (§2 column 3), and `dde36f49` is an ancestor of `HEAD` with three
intervening commits, none of which touch `experiments/latent-lisp/` sources (they are the
charter commit, a campaign-log commit, and a guild/ledger commit). The sources are
therefore stable across the interval; the authentication is nonetheless *as of `HEAD`*,
which is the honest statement of what was read.

---

## §2 — Per-source authentication

**Read extent** states what **this hand** opened **this session** — not what a digest
declared. Where a file is under 300 lines it was read in full. Larger files were read at
named sections, with the sections named exactly. Blob shas are `git rev-parse HEAD:<path>`
(the tracked identity); in every case `git hash-object <working-tree-path>` returned the
same value, so **working tree ≡ HEAD for all 24 sources** — no source was read in a dirty
state.

Paths are repository-relative. `M/` abbreviates `experiments/latent-lisp/mneme/`.

| # | Path | Blob sha (HEAD ≡ working tree) | Read extent THIS session by SIGNATOR | Quotations verified | Standing, as the source declares it |
|---|---|---|---|---|---|
| 1 | `M/portable-judge-0/OWNER-RULINGS-1-2026-08-10.md` | `b77f57795b97dad7f35f4e54eaf7d6d8a14a12bc` | **FULL, 280/280 lines** | **9/9 pass.** "claim lattice" sentence (L244) · PortJ-L/0 candidate hypothesis (L96) · green-result licensed sentence (L100) · never-shortened rule (L102) · rename directive (L250) · DG licensed phrase incl. **"tested"** (L262) · the "open-ended"/"general-purpose"/"arbitrary domains" bar (L264) · PortJ/0 designation + `PJ0` reservation (L29–48) · 28-place negative result (L21) | Owner rulings, **filed verbatim, append-only**; "This designation ruling does not adopt the campaign documents" (L50) |
| 2 | `M/portable-judge-0/OWNER-RULING-5A-P2R1-ACCEPTED-ROUND-P-CLOSED-2026-08-10.md` | `879c2b079f0b2803af4b7896ebfdb59d44662058` | **FULL, 128/128 lines** | **4/4 pass** (1 case-variance, §3 A-4). Settled account §4 (L101) · empty-repository test "**did not pass** and must never be represented as passing" (L66) · Rider 5A-R1, literal universal "not ratified and must not be quoted as a byte-minimality finding" (L95) · "Portability is not established." (L111) | Owner ruling, filed verbatim; **Round P CLOSED**, bank candidate-and-unadopted, "Evidence earned: **zero**" |
| 3 | `M/portable-judge-0/OWNER-RULING-6B-CENSUS-R1-ACCEPTED-B7-CLOSED-2026-08-10.md` | `6182cfc0095e7c4e71412df54dc5c848a11dd6bd` | **FULL, 41/41 lines** | **2/2 pass.** Stop clause (L39): *"Stop after the integration receipt. Do not advance S-freeze or open the stranger audit, PortJ-F/0, hidden bank, J2, portability, conformance, or independent-implementation jurisdiction."* · quiescent-tree rider (L35), verbatim, incl. its refusal of "hostile concurrent-filesystem mutation resistance, gate self-authentication, SHA-1 collision resistance, or general tamper resistance" | Owner ruling, filed verbatim; B7 CLOSED, succession complete, "Evidence remains ZERO" |
| 4 | `M/language-many-acts-0/MANY-ACTS-0-R1-ADOPTION-OWNER-RULING-2026-08-10.md` | `d349d80a0f87bb12c40bda343188773968728568` | **FULL, 232/232 lines** | **6/6 pass** (1 enumeration compression, §3 M-5). Rider 1 exact sentence (L96) · the **nine** not-licensed items (L102–110) · "Nothing here may be called independently verified, independently validated, stranger-audited, or independently reproduced." (L90) · audit caps: object graph not rederived / SBCL not rerun (L88) · Rider 4 "A lawful Many Acts /0 source is a tree." (L152) · Rider 6 "PROVES" → "TESTS WHETHER" prospectively (L172) | **ADOPTED WITH RIDERS** — the governing repaired Many Acts /0 base |
| 5 | `notes/2026-08-10-p5-sol-inhabitation-protocol.md` | `b4ce3cdd93ea5f467451fd7c6ddb16e7fc2365e4` | **FULL, 125/125 lines** | **4/4 pass.** **The P5 provenance correction is located here**, §"P5 PROVENANCE CORRECTION (owner, 2026-08-10 — append-only)" at **L101–125**: the governing sentence verbatim (L116–119) · the channel cap "prior exposure means it cannot isolate the public guide as the sole transmission channel" (L121–122) · the DO-NOT-claim list (L110–112) · Sol classed "NON-IMPLEMENTATION AUTHOR … not a mind outside the project's construction/adjudication orbit" (L104–108) | Frozen protocol (bands pre-registered, committed before the packet shipped) **plus an append-only owner correction which the file states GOVERNS where the original is looser** |
| 6 | `M/language-many-acts-0/p5/p5-FIRST-RUN.txt` | `fd571f809f560156d870c047d3c502e8328388e8` | **FULL, 31/31 lines** | **2/2 pass.** Tally line (L31): `ma0-p5-nonauthor: 10 checks, 0 failures` — **10/0 confirmed** · the prediction-match body: 10 `[PASS]` lines incl. `PREDICTED refusal code :earth-entry-quarantined  got :EARTH-ENTRY-QUARANTINED` (L21) and "no summary names arm D (sterilization warranted, unexecuted)" (L25) | First-run transcript, chair-unedited; a record, not an instrument |
| 7 | `M/language-many-acts-0/MANY-ACTS-0-R1-RETURN.md` | `f55b90344492fd74658ae26c3d37d4d1f8ea4fae` | **FULL, 84/84 lines** | **1/1 pass, with a variant-locus note (§3 O-1).** §1's claim (L21–22) reads "*the repaired candidate authoring surface*"; the **adopted** Rider 1 reads "*the repaired **Many Acts /0** candidate authoring surface*". R0.1 quotes the **ruling's** form — correctly. **The P5 provenance correction is NOT in this file** (searched; it lives at source #5) | CANDIDATE ("Nothing here is adopted, merged, published, or independent verification (AP0 Rider 2 binding)") |
| 8 | `M/language-act-0/ADOPTION-RECORD-2026-08-08.md` | `5f511946fa4c85f4ce8e0a6da7849d183ce305ee` | **FULL, 55/55 lines** | **2/2 pass.** The owner-variance disclosure verbatim (L26–28): *"The stranger primitive-minimization audit prescribed as a promotion gate was not performed. The owner waived that gate for One Act /0 because its resource cost was disproportionate to the remaining design risk. This variance does not constitute independent validation and does not prevent later primitive reduction or architectural revision."* · the stranger packet "**SEALED, UNOPENED, NOT COURIERED, NOT ADJUDICATED** … must never be represented as evidence of independent review" (L33–36) | One Act /0 **ADOPTED**; stranger audit **DEFERRED INDEFINITELY**, gate **waived, not passed** |
| 9 | `M/language-surface-account-0/ADOPTION-RECEIPT-2026-08-06.md` | `c8b8368be717b2c736a3be752578505d66e8aa08` | **FULL, 73/73 lines** | **2/2 pass.** Adoption clause (L4–7): authority = owner ruling "ACCEPT R4.3" (2026-08-06), R4 laboratory terminally closed, controlled adoption/publication round authorized from `718f9983…` · chair-executed with "readback by an independent fresh-context Opus seat" (L8–9) | **ADOPTED + PUBLISHED**; Surface /3 "still shut" |
| 10 | `M/LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md` | `ef5992592311074890e83180d2a691ff34cbbda7` | **TARGETED FULL-SECTION reads, 1168 lines total.** Sections opened in full: §0.1a–0.3 (L41–60) · Art. 1 head + §1.0 graph/edge tables (L72–110) · §1.L0.3–1.L0.5 (L160–200) · §1.CI.3–1.CI.5 (L222–245) · §1.PL.2–1.PL.6 (L265–300) · §1.DG.2–1.DG.4 (L380–400) · §1.LM.2–1.LM.5 (L429–455) · §1.COMP.2–1.COMP.4 + §1.E preamble (L465–495) · §1.E.P4.4 + §1.E.P5.1–P5.4 (L512–545) · §1.E.P5.4–P5.5 + Art. 2 §2.1 (L545–585) · §2.2–2.4 + Art. 3 (L586–615) · §4.2–4.6 (L640–680) · §11.6 (L869–880) · Art. 12 + Art. 13 + Art. 14 head (L881–930). Article map read in full (17 articles). | **17/17 pass** on clauses R0.1 retains or cites. §0.1a ✓ · §1.0 exists (L79) ✓ · §2.2 edge semantics *"X cannot be attempted or claimed until Y" / "Y makes X true"* (L591–593) ✓ · §2.4 terminus (L600) ✓ · §4.3 *"Language difference is not independence. Substrate difference is not independence"* (L649–651) ✓ · §4.5 Sol spent (L661) ✓ · §4.6 (L667) ✓ · §1.L0.3 both strata + compression line *"Lisp+ is a small experimental language … licensed **at L0-a**"* (L176–178) ✓ · §1.CI.3 ✓ · §1.CI.4 ✓ · §1.E.P4.4 *"P4 contains no inhabitation content whatsoever"* (L514) ✓ · §1.E.P5.1 governing sentence ✓ · §1.E.P5.4 *"Substrate difference is not orbit difference"* (L549–550) ✓ · **§1.E.P5.5 (L552–554) — located, and it is the ONLY locus of the "at any weighting" sentence: see MISMATCH M-1** · §1.PL.2/.3/.4 ✓ · §1.DG.2 incl. "The word 'tested' is part of the phrase and is not dropped" (L387–388) ✓ · §1.DG.3 ✓ · §1.COMP.2/.3/.4 + T10 ✓ · §1.LM.2 *"Lisp+ is designed as an experimental language for latent-space authorship"* (L433) ✓ · §1.LM.3 ✓ · §1.LM.4 "Pre-registration is a precondition, not a courtesy" (L441) ✓ · §1.LM.5 ✓ · §11.6 (L871) ✓ · Art. 12 riders 1/2/3/7 (L885–896) ✓ · Art. 13.1 (L903) ✓ · Art. 15 exists (L1018), so R0.1 §F.0's reference resolves ✓ | **CANDIDATE, UNADOPTED** — by its own §0.3: "Nothing in it is adopted by being written, by being reviewed, by being agreed with, by being directed by a ruling, or by any test turning green." sha256 `b437a70f…` confirmed |
| 11 | `M/integration-baseline-0/AUTHORITY-INDEX.md` | `97cbee71d9bd7255c37f8a286bd4fdcaf36e8e9f` | Head **L1–30** + tail **L95–107** (107 lines) | **1/1 pass.** L107: *"Nothing in this index confers standing. It records where standing was conferred, and by whom."* | A finding aid, IB0 2026-08-02; **confers no standing by its own text** |
| 12 | `M/integration-baseline-0/CLAIM-CEILING-0.md` | `bb206311f83c908678aef2326c2d571bdf9a5af7` | Head **L1–40** (274 lines); §0 "the only claim this milestone itself earns" and §1.1 AP0 Rider 2 quotation read in full | **1/1 pass.** §1.1 quotes AP0 Rider 2 verbatim and records the permitted "independently seeded Common Lisp implementation" formulation for **Adapter /0** | IB0 ceiling record, 2026-08-02: "This milestone raised nothing." |
| 13 | `M/integration-baseline-0/SUPERSESSION-MAP.md` | `b7b9c5f60c33c179838f3dd293e468674bc3a8fc` | Head **L1–25** (96 lines), incl. the label legend and the marked-records table | **1/1 pass, with a punctuation divergence (§3 A-3).** L5–6: *"**Nothing here is deleted.** History is marked, not removed: several of these documents are cited by the evidence chain…"* | IB0 documentation map; marks, does not delete |
| 14 | `M/language-many-acts-0/MANY-ACTS-0-STANDING.md` | `d89ec9c4fa2cda1979b5f34b2805d6443731d732` | **FULL, 104/104 lines** | **3/3 pass.** §4 (L80–83): *"No consolidated, frozen, and published Many Acts /0 statute or portable-conformance standard has yet been adopted. Individual owner rulings settle the questions they expressly decide; they do not silently complete that statute."* · §3 (L51) "A banner cannot answer the question." · §1 (L20–21) the immutable-identities rule (R0.1 glosses, does not quote — see §3 O-2) | States Ruling 6 §3 B1's rule; "This file states that rule; it does not confer standing on itself." |
| 15 | `M/language-many-acts-0/MANY-ACTS-0-SUPERSESSIONS.md` | `a704fe0e7258d012a8da1d509642d66dd25647e1` | Head **L1–40** in full (136 lines), covering the banner and §0 "THE REGISTRY'S OWN LAW" (all five numbered laws) | **2/2 pass.** L5–6: "This file's path confers no standing on its bytes in either direction." · **L27: "A superseded statement was not false when it was written."** — R0.1 §H.1 attributes this to "the supersession registry's law", which is **this file**; the attribution is correct (it is *not* in `integration-baseline-0/SUPERSESSION-MAP.md`) | Append-only supersession registry, opened under Owner Ruling 6 §3 B4 |
| 16 | `M/portable-judge-0/SPEC-DEFICIT-REGISTER-CANDIDATE.md` | `041b6203c28327579d44a3446bf84ceef485193a` | Targeted: **§0 in full (L1–60)** — standing banner, AP0 Rider 2 inherited rider, "the search performed", "prior work absorbed"; **SD-13 in full (L81–100)**; **all 28 `### SD-` headings enumerated** (664 lines total) | **2/2 pass.** **Count: `grep -c "^### SD-"` = 28 — exactly 28 entries, SD-01…SD-28, confirming the "28 places" figure R0.1 uses at §B.1.3, rung 1, §E.0, §G.1 and §J.1.** SD-13 heading verbatim (L81): *"SD-13 — One Act /0 has **no public specification in the published tree**"* — matching R0.1 rung 1 exactly; its body confirms `_staging/oneact-candidate/` sits outside the mirrored subject tree, "**not in the published packet at all**" | **CANDIDATE — not adopted; owner disposition pending.** Prepared against a base that "is itself NOT owner-adopted" |
| 17 | `M/language-slice-0/de-promotione/DISPOSITION.md` | `cb4b8f70cdec6e911b6a16e37f2aadf4e0f8779d` | **FULL, 104/104 lines** | **2/2 pass, with a count correction (§3 A-7).** The banked receipt (L20–27) is a **six-key** form, not four-way: `:semantic-model :validated` · `:public-surface :embedded-language-kernel` · `:governed-language-act :earned` · `:host-level-enforcement :not-earned` · `:standalone-language-claim :not-yet-earned` · `:escape-surface :common-lisp-package-internals`. **R0.1 §B.5 enumerates all five dispositions plus the escape surface and is correct.** The host-bypass sentence (L41–42) is byte-exact: *"Host bypass is **not** evidence that the semantic act does not exist; it is evidence about where the act's enforcement perimeter currently sits."* | Banked disposition, **append-only**, 2026-07-23; "This file refines; it does not replace." DPM-7: "must not be cited as" a cryptographic/process-isolation/hostile-custody result |
| 18 | `M/language-slice-0/LANGUAGE-SLICE-0-GUIDE.md` | `43bb85615e6c1fdaeefe341d96c87cb488ca99b5` | Head **L1–22** (263 lines) — the framing sentence and the four governed verbs | **1/1 pass.** L8: *"Lisp+ Slice /0 is a small embedded language fragment for programs that…"* Under R0.1 §C.8/W-05 this sentence is **explicitly demoted to a non-load-bearing terminology note** (EV-15/45/46 carry no weight), so it supports nothing ratifiable | Programmer guide, slice scope |
| 19 | `M/spec/lci0-review/FABLE-LCI0-CLOSURE-MERGE-RECEIPT.md` | `2bd86503ef0c516935e8f3765d19325ddc462e8d` | **FULL, 35/35 lines** | **1 pass, 1 MISMATCH.** PASS — L21 + L25: *"owner-authorized and internally audited"* … *"**NOT claimed as independently verified by a wholly separate final reviewer.**"*; merge commit `af22100cad4d6b9c125130a09d27634e8929c7d8` confirms R0.1's `af22100c`. **MISMATCH M-2 — the phrase "Independently SEEDED under shared normative infrastructure" is ABSENT from this receipt** (`grep -i seed` returns only the "Seeds (unchanged ancestors)" table row) | Merge receipt; external-review pass **waived**, "The waiver changes the **review provenance claim only**" |
| 20 | `M/architecture/adapter-protocol-0/AP0-ADOPTION-2026-07-18.md` | `35f787450d1b43945721d556e65d6d9a5957fc5f` | **FULL, 60/60 lines** (incl. the 2026-07-30 addendum) | **1/1 pass.** Rider 2 verbatim (L29–31): *"**Stranger audit before independence language:** the separately-recruited stranger audit (`STRANGER-AUDIT-RECRUIT-SPEC.md`) remains mandatory; no artifact may use the words "independently verified/validated" of AP0 until a stranger's frozen report exists."* Addendum L52–54 lists the still-unauthorized formulations | **ADOPTED**, owner-sealed, riders binding; Rider 1 marked SATISFIED 2026-07-30, **Rider 2 remains binding** |
| 21 | `M/portable-judge-0/CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE-P1.md` | `35f24bd1dfd2ac3ed073680de00395d3a4c3ba51` | Targeted: the **NOT ISSUABLE** stamps at **L13** and **L350** (359 lines) | **1/1 pass.** L13: "⛔ THIS BRIEF IS NOT ISSUABLE"; L350: "**NOT ISSUED. NOT ISSUABLE. NO RECIPIENT.** This brief is court-construction material held for audit" | Candidate; **not issuable**, no recipient |
| 22 | `M/portable-judge-0/NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md` | `17fe1ba8c2591cedee3e65ffc7f05abb78251fe2` | Targeted: **L51**, the wire-format doctrine sentence (1279 lines) | **1/1 pass.** L51: *"**JSON is plumbing, not semantic jurisdiction.**"* — matching R0.1 §B.0's evidential-kin citation | Candidate (`-P1`), unadopted |
| 23 | `M/portable-judge-0/OWNER-RULING-3-THREE-PARCEL-DISPOSITIONS-2026-08-10.md` | `7b498c50c3619b6a200da717bad1eec9dcfede09` | Head **L1–16** (141 lines) — banner and the disposition sentence | **1/1 pass, and it raises A-2.** L9 confirms the D5 citation is **Rider 2**, "'Rider 3' in my §5 item 8 was a clerical error" — the correction MEMORY records. **This is a DIFFERENT instrument from the "Ruling 3" R0.1 cites throughout** (which is OWNER-RULINGS-1's §Ruling 3). See §3 A-2 | Owner ruling, filed verbatim; Round OA closes green |
| 24 | `M/portable-judge-0/PROTOCOL-CHARTER-CROSSREF-P2.md` | `f6f26bfc214054e9fac4d13a99cfa60a3847b2e2` | Targeted: identity table **L11–14**; the H/G divergence rows **L104–105** (204 lines) | **1/1 pass.** L14 states Charter-P1's sha256 as `b437a70f09fbffe109e226785de8f9d0c6a309cca7e6d4c1ae2df7720e142476` — **matching the file's actual hash as computed this session**. Rows H and G record that the hypothesis and green sentences are byte-different but **normalization-identical** between Protocol and Charter | Cross-reference audit surface, candidate |

**Additional locus authenticated (not a manifest source, located by search):**
`notes/2026-08-09-many-acts-0-campaign-log.md` — tail read (L448–456). The sentence R0.1
§G.0 quotes as *"Campaign holding; next movement is the owner's"* is byte-present at
**L455–456**, spanning a line break. **It is the chair's own campaign log, not an owner
instrument** — see §3 O-3.

---

## §3 — Mismatches, absences, and anomalies

**Reported, never harmonized.** Nothing below is repaired by this hand. Items are ordered
by weight, not by section.

### M-1 — MISMATCH (attribution): a candidate clause cited as an owner-ruled cap

R0.1 rung 5, "Exact ceiling", reads:

> Its sum with R-P4 *"is not an inhabitation claim at any weighting"* (owner-ruled
> cap, carried in the accepted record itself).

**At source the quoted words exist in exactly one place**, `M/LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md`
§1.E.P5.5, lines 552–554:

> **1.E.P5.5 Edges created: NONE.** P5 may not be cited toward CI0, toward either portable
> node, toward DG0, or toward the composite. **Its sum with R-P4 is not an inhabitation
> claim at any weighting.**

**P1 is candidate, unadopted text.** A search for the word `weighting` across
`OWNER-RULINGS-1`, `OWNER-RULINGS-2`, `OWNER-RULING-2/3/4/5/5A/6/6A/6B`, the R1 Adoption
Owner Ruling, and the P5 protocol (including its owner correction) returns **no hits in
any owner instrument**. The nearest genuine owner statements are R1 Rider 1 L112 —
*"P4 remains evaluator-genericity/post-freeze-extension evidence. It is not an IH0
specimen."* — and the P5 provenance correction's DO-NOT-claim list, and **neither contains
the "at any weighting" formulation.**

**This is a surviving instance of the very defect SOL-HR-01 named** ("Candidate authority
is laundered into present law"), inside the R0.1 repair. It is also **digest-traceable**:
the phrase appears in the drafting digest `_staging/charter0-r0/digest-predecessor-charter.md`
L123, correctly attributed there to §1.E.P5.5 — the attribution degraded between digest
and charter, which is exactly the failure mode SOL-HR-03 exists to close.

### M-2 — MISMATCH (locus): the "independently SEEDED" formulation is not LCI/0's

R0.1 §C.14 calls it "the LCI/0 formulation", and R0.1 §D.1's LCI/0 row prints it as the
row's first quotation, citing `spec/lci0-review/FABLE-LCI0-CLOSURE-MERGE-RECEIPT.md`,
merge `af22100c`:

> *"Independently SEEDED under shared normative infrastructure"*; closure is
> *"owner-authorized and internally audited … NOT claimed as independently verified by a
> wholly separate final reviewer"* (`spec/lci0-review/FABLE-LCI0-CLOSURE-MERGE-RECEIPT.md`,
> merge `af22100c`).

**The second quotation is exact. The first is absent from the cited file.** The receipt's
only occurrence of the stem "seed" is the table row `| Seeds (unchanged ancestors) | CL
b3d28bc4… , Py 4ec2e519… |`.

The formulation's actual home is the **CD/0** post-implementation ruling — a different
lane — at `notes/canonical-datum-reception/ruling-2026-07-13/CD0-POST-IMPLEMENTATION-RULING.md`
(mirrored at `experiments/latent-lisp/CD0-POST-IMPLEMENTATION-RULING.md`), where L212 reads:

> **The Common Lisp and Python codecs were independently seeded under shared normative
> infrastructure, with procedural—not OS-enforced—isolation, attested by the implementers
> and corroborated at content tier.**

and L231:

> The unqualified phrase "clean-room independent implementations" is therefore too strong.
> A narrower phrase such as "independently seeded implementations under shared normative
> infrastructure" is accurate.

A third, distinct locus exists at **Adapter /0**: `AP0-ADOPTION-2026-07-18.md` L48–50
records the owner-permitted formulation *"Adapter /0 is an independently seeded Common
Lisp implementation that passed the complete frozen AP0 fixture and vector gate at the
declared deterministic fake-adapter scope."*

So the phrase is real, repository-present, and load-bearing house law — **but it is CD/0's
(and, in its Adapter /0 form, AP0's), not LCI/0's**, and the citation R0.1 supplies does
not contain it. Two further notes: the source is **lowercase** "independently seeded"
(R0.1 capitalizes SEEDED inside quotation marks), and R0.1 §C.14's gloss "never shortened
past its seed conditions" is doctrinally faithful to CD/0's L231 even though the pointer
is wrong.

### M-3 — MISMATCH (unsourced): two quotation-marked phrases absent repo-wide

Both were searched whitespace-normalized across `experiments/latent-lisp/mneme/`,
`notes/`, `corpus/voices/`, and `_staging/charter0-r0/`, excluding the charter parcel
itself. Both returned zero.

**(a)** R0.1 rung 8, "Would NOT cross":

> One successful outsider (that is CI0's existence proof — *"evidence of inhabitation, not
> automatically a civilization"*)

**(b)** R0.1 §G.1, "Partial success licenses":

> the axes and vector subsets actually crossed, named singly ("award only those axes").

Neither phrase exists in any source outside this parcel. They appear to be the drafter's
own words dressed in quotation marks — a small move, but the same class as M-1: quotation
marks assert a source. (Both may originate in the un-filed commission; see A-1, which is
why that gap matters.)

### A-1 — ANOMALY, and the largest residual: the commission is not a repository artifact

R0.1 cites the commission as authority in at least two places that reach ratifiable
sentences:

- §A.0: "(commission §1.7: *executable green is not adoption*)" — a **quoted** sentence.
- §D.1: "R0's drafting involvement is evidence of nothing (commission §3)."

and relies on it structurally elsewhere ("commission-required" at §G.3 and §G.4, "the
commission's rung title" at rungs 5 and 7, "the commission's prescribed structure" at
§E.0, "the commission's own test case" at §F.1.3).

**Searched: the string "executable green is not adoption" appears in no file in the
repository. `git ls-files | grep -i commission` returns no Charter /0 commission
document.** Every other owner instrument in this lane is filed verbatim, append-only
(Rulings 1, 2, 3, 4, 5, 5A, 6, 6A, 6B, the R1 adoption). The Charter /0 commission — both
the original and the 2026-08-11 R0.1 repair commission — is **not**.

**Consequence, stated plainly:** SOL-HR-03 asks that "'via digest' never controls a
ratifiable sentence." After this pass, no *digest* controls one — but the **commission**
still does, and unlike a digest it cannot be cured by reading, because the text is not in
the repository. Sol had it (its §2 records reviewing "the original Fable commission in
full"); a later reader of the repository does not. **Curable only by the owner filing the
commission verbatim in-lane, as every ruling is filed.** This hand does not do so and has
no standing to.

### A-2 — ANOMALY: "Ruling 3" is a designation collision inside the charter's own citations

Two distinct owner instruments carry the number 3:

1. **OWNER-RULINGS-1-2026-08-10.md, §"Ruling 3 — Act Oracle Interface and campaign scope"**
   (the two-layer PortJ-L/PortJ-F decomposition) — this is what R0.1 means by "Ruling 3"
   in every one of its uses (rung 6, rung 9, §C.19 vicinity, §F.1.6, §F.1.7, §G.1, §J).
2. **`M/portable-judge-0/OWNER-RULING-3-THREE-PARCEL-DISPOSITIONS-2026-08-10.md`** — a
   separate owner instrument whose title is literally "OWNER RULING 3", disposing Rounds
   OA and P and Parcel A, and which R0.1's own evidence ledger cites by path.

R0.1 uses the bare token "Ruling 3" throughout without disambiguation. This is precisely
the collision class the lane already legislated against — Ruling 1's `PJ0`/`PortJ/0`
reservation and Charter-P1 Article 15 (Designation law), which R0.1 §F.0 itself invokes to
justify the `CC-` prefix on its claim classes. The same guard is not applied to its own
ruling citations.

### A-3 — Punctuation altered inside quotation marks (SUPERSESSION-MAP)

R0.1 §A.1, HISTORICAL row: `integration-baseline-0/SUPERSESSION-MAP.md` ("Nothing here is
deleted. History is marked, not removed.").

Source, L5–6: **"Nothing here is deleted.** History is marked, not removed: several of
these documents are cited by the evidence chain and by rulings, and deleting them would
break references that are load-bearing."

The words are byte-present; the source's **colon** is rendered as a **period** and the
sentence truncated without ellipsis. Substance unaffected; recorded because a charter that
polices quotation should quote to the mark.

### A-4 — Emphasis and case added inside quotation marks, unmarked

Three instances, all substance-preserving, all recorded because they occur inside quote
marks in a document whose §H.1 promises sealed documents are "quoted in their own words":

| R0.1 renders | Source reads | Locus |
|---|---|---|
| *portability is NOT established* (§F.1.7, rung 6) | "Portability is not established." | Ruling 5A L111 |
| "across the **tested** unseen application topologies" (§C.20, rung 8, §G.3) | "across the tested unseen application topologies" (plain) | Ruling 8 L262; P1 §1.DG.2 L384–385 |
| "Independently **SEEDED** under shared normative infrastructure" (§C.14, §D.1) | "independently seeded under shared normative infrastructure" | CD/0 ruling L231 (and see M-2 for the locus error) |

### A-5 — Parcel-internal stale cross-reference

R0.1 line 867: *"The operational one-page version of this section is `CLAIM-CEILING-R0.md`."*

`CLAIM-CEILING-R0.1.md` exists in this directory and **differs from R0's by 65 changed
lines**. The R0.1 charter points its reader at the superseded ceiling. (For the record,
measured this session: of the six paired parcel files, five differ between R0 and R0.1 —
charter 580 changed lines, owner docket 844, succession docket 220, evidence ledger 128,
claim ceiling 65 — and **`SOURCE-MANIFEST` was byte-identical to R0's until this hand
updated it**, which is the condition this repair was commissioned to end.)

### A-6 — A settled account compressed below its owner-stated form

Ruling 5A §4 L101, the sentence the ruling settles as "Round P's final output":

> **Exact candidate membership 156 = 188−19−9−4; C-7 = I-3 = 9; C-8 = 4; layers 99/41/16;
> 43 of 90 = 47.8% LANG; 149 retired as a non-enumerable residue.**

R0.1 renders it (rung 6 sources; §F.2 CC-1 exemplars) as: "156 = 188−19−9−4 · C-7 = I-3 =
9 · C-8 = 4 · layers 99/41/16 · 43/90 = 47.8% · 149 retired". Every number is faithful.
Dropped: the qualifier **LANG** on the 47.8%, and **"as a non-enumerable residue"** on the
149. R0.1 does not place this inside quotation marks, so it is a compression rather than a
misquote — recorded because the lane treats this account as having a single citable form.

### A-7 — Manifest miscount, corrected in this pass

`SOURCE-MANIFEST-R0.txt` line 68 described the Slice /0 disposition as "the banked
four-way disposition". At source it is a **six-key** form (five dispositions plus
`:escape-surface`). R0.1 §B.5 enumerates it correctly; only the manifest was wrong. **This
hand corrected the manifest line** (the manifest being one of its two writable files);
the R0.1 charter needed no change.

### M-5 — Count correct, enumeration compressed (Rider 1's not-licensed items)

R0.1 rung 4: "With Rider 1's **nine** not-licensed items attached (no captured-exit-code
claim; no stranger/independent inhabitation; no guide-only transmission; no independent
implementation; no open-ended authoring; no unrestricted domain generality; no
multi-environment orchestration; no transactionality/crash resumability)".

**The count is right** — the ruling lists exactly nine bullets at L102–110. **The
parenthetical enumerates eight**, merging the ruling's two separate items *"stranger
inhabitation"* and *"independent inhabitation"* into one. Recorded rather than repaired:
the two are distinct refusals in the owner's text and elsewhere in R0.1 (rung 7, §F.1.5)
they are handled separately.

### O-1 — Variant loci for the R1 claim sentence (observation, not a defect)

The adopted Rider 1 (L96) reads "*the repaired **Many Acts /0** candidate authoring
surface*"; `MANY-ACTS-0-R1-RETURN.md` §1 (L21–22) reads "*the repaired candidate authoring
surface*" — three words shorter. **R0.1 quotes the ruling's form, which is the adopted
one.** Recorded so that a later hand comparing the two loci does not mistake the return's
wording for a discrepancy in the charter.

### O-2 — A gloss correctly not dressed as a quotation

R0.1 §A.1's ADOPTED LAW boundary clause renders STANDING's rule after a colon, unquoted:
"standing attaches to immutable identities and explicit dispositions, never to filenames
or descent". The source (STANDING L20–21, quoting Ruling 6 §3 B1) is fuller: "**Standing
attaches to immutable object identities and explicit dispositions, never merely to
filenames, directories, or descent from an adopted commit.**" Because R0.1 does not use
quotation marks, this is a faithful gloss, not a misquote. Noted for completeness.

### O-3 — A chair-authored sentence quoted in a passage about owner authority

R0.1 §G.0 closes its account of why §G.4 is shut with: "— like every campaign after the 6B
closure — the owner's to move (*"Campaign holding; next movement is the owner's"*)."

The sentence is byte-present at `notes/2026-08-09-many-acts-0-campaign-log.md` L455–456,
and it is **the chair's own running log**, not an owner instrument. The proposition it
supports is independently true on owner authority (Ruling 6B's stop clause, authenticated
above at source #3). Recorded because the quotation marks, in a sentence about what is
"the owner's", invite a reader to hear an owner speaking.

---

## §4 — F-1 factual premise check (Sol §8: verify that R0.1 subsumes the owner-ruled clauses it claims)

Sol's §8 disposition of F-1: *"First verify factually that R0 contains every owner-ruled
P1 clause it claims to subsume."* R0.1 §I records the premise as "now verified in
`SOURCE-AUTHENTICATION-R0.1.md` §4" — this is that verification, performed against the
directly-read rulings of §2 sources #1 (Rulings 1, 3, 8) and cross-checked against the
R0.1 charter text.

**Method:** each operative directive was extracted from the ruling text as read this
session, then located in R0.1 by section. **SUBSUMED** = the directive's operative content
is present and governs. **PARTIALLY** = present in substance but narrowed, unnamed, or
implicit rather than stated. **ABSENT** = not carried. An ABSENT is a finding, not a
defect to be argued away — several are entirely reasonable omissions for a charter, and
the table says which.

### 4.1 Ruling 1 (Designation)

| # | Operative directive (OWNER-RULINGS-1) | Home in R0.1 | Verdict |
|---|---|---|---|
| 1.1 | Campaign is named **Portable Judge /0** (RATIFIED) | — the string "Portable Judge" occurs **0 times** in R0.1 | **ABSENT** (observed in practice via "PortJ" forms; the designation itself is never stated) |
| 1.2 | Authorized short form **PortJ/0** | §F.2 ("evidence earned by the PortJ/0 campaign is zero"); §I F-9; PortJ-L/0 and PortJ-F/0 used throughout | **SUBSUMED** (by use) |
| 1.3 | Bare token **`PJ0` reserved** for the adopted Process Journal /0 | §F.0 invokes "the `PJ0`-style collision Article 15 of the predecessor exists to prevent" — the collision is named, the reservation rule is not restated | **PARTIALLY** |
| 1.4 | Retire `PJ/0-portable` from the charter | string occurs **0 times** — i.e. complied with | **SUBSUMED** (by compliance; the directive is self-extinguishing) |
| 1.5 | Authorized / unauthorized forms lists | not reproduced | **ABSENT** — reasonable for a claim charter; belongs to the campaign's designation law (P1 Art. 15), which R0.1 cites rather than restates |
| 1.6 | "This designation ruling does not adopt the campaign documents" | §G.0 ("the procedural bodies already exist as candidates … all `-P1`, all unadopted") and §A.0 | **SUBSUMED** |
| 1.7 | The negative result: public law insufficient **in at least twenty-eight registered places** | §B.1.3; rung 1 exact ceiling; §E.0 precondition edge; §G.1; §J.1 step 2 — five sites, and the count is authenticated at 28 (source #16) | **SUBSUMED** |
| 1.8 | Ruling 7: hidden-bank authoring **withheld**, conditionally authorized only after S-freeze and eight named conditions | §G.1(a) — "the hidden set itself governed and custody-sealed, and creatable only after the owner reopens the jurisdiction (nothing is authorized here)"; §G.0 ("every gate here opens only by owner ruling") | **PARTIALLY** — the prohibition is carried; the **eight enumerated preconditions** are not |

### 4.2 Ruling 3 (Act Oracle Interface and campaign scope)

| # | Operative directive | Home in R0.1 | Verdict |
|---|---|---|---|
| 3.1 | Two-layer decomposition **ACCEPTED**; original center claim **NOT** | rung 6 ("split by owner ruling into two targets … the original center claim **not**") | **SUBSUMED** |
| 3.2 | PortJ-L/0's eleven-item J2 work-list | §G.1 ("the eleven-item work-list as both assignment and boundary") — named by count, not enumerated | **PARTIALLY** (by reference; the boundary function is preserved) |
| 3.3 | J2 consumes a frozen Act Oracle transcript for substrate operations | §G.1 target/boundary bullet; §G.1 "Oracle identity" bullet | **SUBSUMED** |
| 3.4 | The candidate hypothesis, rewritten (verbatim block) | not quoted in R0.1; carried at P1 §1.PL.2, which R0.1 cites | **PARTIALLY** — the sentence lives one document away |
| 3.5 | The green-result licensed sentence (verbatim block) | §G.1 "Full success licenses: **the Ruling-3 green sentence, verbatim**, with vector-set name" — named, **not reproduced** | **PARTIALLY** — a charter that elsewhere prints its exact ceilings in full does not print this one |
| 3.6 | "It must never be shortened to 'an independent Lisp+ implementation exists.'" | rung 6 exact ceiling; §F.1.6 ("specifically the sentence Ruling 3 orders a green PortJ-L/0 must *never* be shortened to") | **SUBSUMED** |
| 3.7 | PortJ-F/0's eight-layer scope | §G.1 names PortJ-F/0 as a different gate; the eight layers are not listed | **PARTIALLY** |
| 3.8 | PortJ-F/0 **cannot open** until predecessor law is publicly sufficient | §E.0 precondition edge; rung 6; §G.1; §J.1 | **SUBSUMED** |
| 3.9 | "PortJ-L/0 is an **intermediate theorem**, not a permanent decision to leave the substrate oracle-mediated" | string "intermediate theorem" occurs **0 times**; nothing in R0.1 states that the oracle mediation is provisional | **ABSENT** — and consequential: without it, a reader of rung 6 could take oracle-mediation for a settled architecture rather than a staging decision |
| 3.10 | AOI replay adapter **should preferably remain an external harness or wrapper**; if J1 must be modified, the adapter becomes a separately identified pre-campaign candidate, **preserves the original native path**, and **passes a byte-identity gate over the full inherited floor** before freeze | §G.1 carries only the consequence — "an adapter identity-gate failure **voids the campaign before J2 comparison**" — and attributes it to **P1 §1.PL.8**, not to Ruling 3 | **PARTIALLY**, with an attribution slip: the voiding clause is *owner-ruled* (Ruling 3 L121) and R0.1 sources it to candidate text. The three antecedent conditions (external-harness preference, native-path preservation, byte-identity gate over the inherited floor) are **ABSENT** |
| 3.11 | Any failure of that identity gate **voids the campaign before J2 comparison** | §G.1 "Oracle identity" bullet | **SUBSUMED** (see 3.10 on its citation) |

### 4.3 Ruling 8 (Charter structure)

| # | Operative directive | Home in R0.1 | Verdict |
|---|---|---|---|
| 8.1 | The charter becomes a **claim lattice**, not a single ladder | §E.0, quoting the ruling verbatim and chair-verified at source; "the numbering below is an expository index, and carries no ordering semantics whatsoever" | **SUBSUMED** |
| 8.2 | **P4** belongs under **evaluator genericity / post-freeze extension evidence**, not inhabitation | The *exclusion* from inhabitation is fully carried (rung 4; rung 7 "Would NOT cross"; §D.1 R-P4 row; §F.1.5). The **positive classification is not**: the strings "evaluator genericity" and "evaluator-genericity" occur **0 times** in R0.1, which files R-P4 under §C.9 *program expressibility* instead | **PARTIALLY** — the prohibition is honored, the owner's affirmative label is replaced by a different one without noting the substitution |
| 8.3 | **P5** belongs under cross-substrate non-implementation authorship and semantic-agreement evidence, **exposure qualifier always attached** | rung 5 ("R-P5's governing name: *qualified cross-substrate **semantic-agreement** evidence*"); §D.1 R-P5 row; §C.11 | **SUBSUMED** |
| 8.4 | IH0 renamed **Clean-room outsider inhabitation /0** | §C.19 and rung 7 ("the owner-directed name is **CI0 — Clean-room outsider inhabitation /0** (Ruling 8), and R0.1 uses it") | **SUBSUMED** |
| 8.5 | Disease-conserving generativity should be **author-agnostic** | §C.20; §G.3 ("authorship **unconstrained** (author-agnostic by Ruling 8)"); §G.3's "Author-agnostic vs diversity, reconciled" — 4 occurrences | **SUBSUMED** |
| 8.6 | Outsider authorship and generativity may later be conjoined, but **neither smuggled into the other's definition** | §C.21; §E.0 conjunction edge; §G.3 "The composite" | **SUBSUMED** |
| 8.7 | "Open-ended inhabitation" is a **composite** requiring both clean-room outsider authorship and disease-conserving generativity across materially different topologies | §C.21 (COMP-OEI = CI0 ∧ DG0); rung 8; §G.3 | **SUBSUMED** |
| 8.8 | **L0 must distinguish** what is earned on adopted One Act /0 and Surface Account /0 evidence from what is additionally witnessed only by the Many Acts candidate | rung 1's Support/standing annotation (two strata); §B.4 "Scale annotation, mandatory"; the contraction edge at §E.0 | **SUBSUMED** |
| 8.9 | Rename OG0 → **DG0 — Disease-conserving generativity /0** | used throughout (21 occurrences); §G.3 titled "the DG0 gate" | **SUBSUMED** |
| 8.10 | Finite runs license **only** "evidence of disease-conserving generativity across the tested unseen application topologies" | §C.20 exclusion; rung 8 exact ceiling; §G.3 "Success licenses" — and the word "tested" is preserved in all three, matching source | **SUBSUMED** |
| 8.11 | They never license "open-ended," "general-purpose," or "arbitrary domains" **without the composite qualification** | §C.21 ("refused on **owner-ruled** ground: Ruling 8 … states finite runs never license 'open-ended,' 'general-purpose,' or 'arbitrary domains' without the composite qualification"); rung 8; §F.1.8 | **SUBSUMED** — and correctly separated from P1 §1.COMP.4's stronger rule, which R0.1 marks `[PROPOSED]` |

### 4.4 F-1 verdict

**Of 30 operative directives across Rulings 1, 3 and 8: 19 SUBSUMED, 8 PARTIALLY, 3
ABSENT.**

The three ABSENT are 1.1 (the designation itself), 1.5 (the authorized/unauthorized forms
lists), and **3.9 (PortJ-L/0 is an intermediate theorem, not a permanent decision to leave
the substrate oracle-mediated)**. The first two are designation law that P1 Article 15
holds and a claim charter may reasonably decline to duplicate. **3.9 is the one an owner
should see before disposing F-1**: it is a substantive owner qualification on what a green
PortJ-L/0 means for the project's trajectory, and no sentence in R0.1 carries it.

Of the eight PARTIALLY, two are worth the owner's eye: **3.5** (the Ruling-3 green
sentence is invoked "verbatim" but never printed, in a charter that prints every other
exact ceiling in full) and **3.10** (an owner-ruled voiding condition sourced to candidate
text, with its three antecedent conditions dropped).

**The factual premise of F-1 is therefore VERIFIED WITH EXCEPTIONS**, not verified
simply. R0.1's §I line — "factual premise … now verified" — is accurate only if read
together with this table.

---

## §5 — Sign-off

### 5.1 What this hand opened directly

**All 24 sources in §2**, plus the campaign-log locus, were opened at source this session
by SIGNATOR: 13 read in full (sources 1, 2, 3, 4, 5, 6, 7, 8, 9, 14, 17, 19, 20), 11 read
at named sections stated exactly in the table (10, 11, 12, 13, 15, 16, 18, 21, 22, 23,
24). Every blob sha in §2 was computed this session by `git hash-object` on the working
tree **and** `git rev-parse HEAD:<path>`, and the two agreed in all 24 cases.

**Quotation and identity checks: 73 performed** — 69 across the 24 sources (the per-source
counts in §2 column 5 sum to 69) plus 4 free-standing locus searches run repo-wide for
strings the charter quotes without naming a file.

**Outcome, counted honestly rather than rounded:**

- **68 passed on byte-presence** at the source the charter points to.
- **3 failed outright** — the quoted words are absent from the cited source, or absent
  repo-wide: **M-2** (the "independently SEEDED" formulation, absent from the LCI/0
  receipt it is cited to), **M-3(a)** ("evidence of inhabitation, not automatically a
  civilization"), **M-3(b)** ("award only those axes").
- **1 could not be checked at all** because its source is not in the repository:
  **A-1**, *"executable green is not adoption"* (commission §1.7).
- **1 passed byte-presence but failed on attribution** and is the heaviest finding here:
  **M-1**, the "at any weighting" sentence — real, locatable, and **candidate text cited as
  an owner-ruled cap**.

Seven further items (A-2 … A-7, M-5) are anomalies where the words are present but the
rendering, count, or pointer is off; three (O-1 … O-3) are observations that are not
defects and are recorded so a later hand does not re-litigate them.

### 5.2 What remains digest-mediated anywhere in the parcel

**Verification performed:** every path cited by the R0.1 charter or its evidence ledger
was extracted mechanically (79 distinct paths), and each was checked for whether it
carries a `[PROPOSED]` holding, a licensed sentence, an exact ceiling, or a status
determination in R0.1.

**Result: no ratification-bearing repository source remains digest-mediated.** Every
source that controls a `[PROPOSED]` holding, an exact ceiling, a licensed sentence, or a
standing determination in R0.1 appears in §2 above and was opened directly this session.
The paths that remain marked `[via digest]` in the updated manifest are background reads
only — procedural candidate bodies cited for their existence and unadopted status
(PROTOCOL / ADJUDICATION / FAILURE-TAXONOMY / DG0-SKETCH / LM0-SKELETON), custody-inventory
entries for receipts whose identities are not quoted, the two voices files (which carry
the shared-input cap and are load-bearing for nothing), and header-only reads of source
files. None controls a ratifiable sentence.

**One ratification-bearing source is not digest-mediated but is worse: it is absent.** The
Charter /0 commission (original and the 2026-08-11 R0.1 repair commission) is quoted at
§A.0 and relied on at §D.1, §E.0, §F.1.3, §G.3, §G.4 and both rung titles, and **it exists
in no repository file** (A-1). SOL-HR-03's remedy — "update the manifest so 'via digest'
never controls a ratifiable sentence" — is discharged for everything a reader can reach.
It cannot be discharged for the commission by any amount of reading. **That is the one
source-custody gap this repair leaves standing, and it is the owner's to close.**

### 5.3 Standing of this document

Candidate R0.1. Authentication, not adoption. Produced by a same-root hand inside the lab
harness; **directly authenticated at source by a same-root hand** is the whole of the
claim, and it is never independent verification, independent validation, a stranger audit,
or a second witness. It opens no jurisdiction, schedules no gate, and earns no evidence.
Zero remains zero.

*— SIGNATOR, agent of the chair (Claude Fable 5), 2026-08-11, against `Claude-Code-Lab`
branch `many-acts-0-candidate` at `232da116…`. Two files written; nothing else touched.*
