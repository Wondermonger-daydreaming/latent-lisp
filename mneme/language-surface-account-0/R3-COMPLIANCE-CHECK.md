# Surface Account /0 — R3 COMPLIANCE CHECK

> **R3.1 SUPERSESSION AUDIT (R3.1-E — rewrite entered by JURIST, Claude
> Fable 5, per the R3.1 owner adjudication; LECTOR-3's original text is
> preserved beneath the relabelled cells).** The R3.1 adjudication proved
> several clauses this check labelled SATISFIED to have been defective in
> law or bypassable in fact. Per the ruling — no failed or partial clause
> may be labelled SATISFIED — the affected Status cells below are
> relabelled in place with bracketed R3.1 notes: **A1** (the totality law
> was one stage too strong — detail totality), **A9** (the Door-1
> consolidation the cell banked was uncommissioned and is REJECTED;
> Door-1 ownership restored), **A2/A3** (content held; the phrase
> "independently verified" violated the standing claims ceiling and is
> withdrawn — same-family recount, not independent), **B1** (allocator
> retained, but the cited linearizability phrasing carried the false
> completion-return-order claim, now deleted), **B7** (the
> `ALLOCATOR-OBSERVATION` bare-`INCF` arm was a second, unlabelled
> occurrence — the clause did not hold; the arm is deleted by R3.1-B),
> **D2/D4** (bypasses reproduced by the R3.1-D tab-impostor and
> ambient-git-environment families). LECTOR-3's own scope declaration
> ("SATISFIED means I read the named text… never *this is correct in the
> world*") anticipated exactly this failure mode; the relabelling makes
> the outcomes explicit rather than leaving them behind a scope note.

**Examiner:** LECTOR-3, compliance examiner of the R3 delta round.
**Tree examined:** branch HEAD `b294d712a4c21888cd917d8e57e400eeb2f816ed`,
worktree `/home/gauss/Desktop/worktrees/surface-account-0`, `git status --porcelain`
empty at examination, `git branch -r --contains HEAD` empty (unpushed).
**Governing law:** `OWNER-ADJUDICATION-R2-AND-R3-COMMISSION.md` (filed `d3566d6f`),
read in full; every checklist row below is taken from **its** text, not from the
chair's amendment log.
**Date:** 2026-08-04.

---

## Standing declaration

**This is a fresh-context reading by a member of the same family. It is not an
independent audit.** I boot from the same CLAUDE.md and MEMORY.md as the seats
whose work I examine, I read the same repository, and I share their weights and
their corpus. What I can offer is a reader who did not write these documents and
did not decide these questions; what I cannot offer is an outside. Wherever I
write SATISFIED it means *I read the named text or ran the named command and it
says what the ruling requires*, never *this is correct in the world*.

**What I ran, and what I did not.** I ran, read-only, with every output written
outside the worktree: (1) the complete verifier specimen suite at this exact tip
(`run-verifier-specimens.sh`, synthetic suite, exit 0, `SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-PASS`);
(2) an independent reproduction of the R2-clean-transcript arm — the five
unchanged R2 clean transcripts through the **current** `verify-transcript.sh`
with the R2-era declarations, at physical tip `42475355…`, all five ACCEPTED;
(3) direct counts of both providers' public refusal catalogues out of
`surface1.lisp` and `surface2.lisp`. **I did not run the full probe.** For the
witnesses I read the sources and the dev-run transcripts in the probe seat's
evidence directory. Nothing in the worktree was modified except this file, and
nothing was committed.

**Compressed steps are marked as such.** Where I state a count I computed, the
command is given.

---

## 1. Top prohibitions and delta-scope confinement

| # | Clause (ruling's text) | Status | Evidence |
|---|---|---|---|
| P1 | Continue from exact R2 tip `42475355a4a436f6a0e7262896c241dfef4880e2` | SATISFIED | `git log --oneline 42475355..b294d712` = exactly three commits (`d3566d6f`, `94145b99`, `b294d712`), linear, R2 tip unrebased |
| P2 | Do not implement production code | SATISFIED | `git diff --stat 42475355 b294d712` = 19 paths, all under `mneme/language-surface-account-0/`; the one added Lisp file `probes/probe-identity.lisp` opens with the `NON-PRODUCTION FEASIBILITY PROBE … not a package, not an API, not loadable as part of any system` banner and declares `(in-package #:cl-user)` at line 42 — no `defpackage` in any of the four touched Lisp files |
| P3 | Do not merge, rebase, publish, sync, adopt, close, or open Surface /3 | SATISFIED | branch unpushed (`git branch -r --contains HEAD` empty); no tag; no sync artifact; `SURFACE-3-LIFECYCLE.md` byte-untouched since R2 (absent from the diff) |
| P4 | Do not edit predecessors, ASDF systems, loaders, matrices, release floors, the public mirror, or any Surface /3 path | SATISFIED | the diff touches no path outside the lane directory; `PROVIDER-API-MATRIX.tsv`, `READER-PROVENANCE-MATRIX.tsv`, `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` all absent from the diff |
| P5 | Do not restart the architecture survey or provider measurements | SATISFIED | `git hash-object` on the working tree vs `git rev-parse <rev>:<path>` at both R2 and HEAD for `probe-matrix.lisp` (`18694f60…`), `probe-controls.lisp` (`2a7b5bc7…`), `probe-control-6.lisp` (`a74eb1cf…`), `probe-prelude.lisp` (`adc53513…`), `run-probe.sh` (`fac73cfd…`) — **all five identical across R2 tip, HEAD, and disk**; no measurement source moved |
| P5b | Controls 1–7 profiles frozen | SATISFIED | `git diff 42475355 b294d712 -- probes/verify-profiles.txt` changes exactly two lines: `FRESHNESS:0:18`→`:28` and `SCHEMA-WITNESS:0:49`→`:86`. `POSITIVE-MATRIX:14:27`, `CONTROLS-A:0:43`, `CONTROLS-B:0:27`, `ALLOCATOR:0:12` **untouched** |
| P5c | Sequence/grammar edits confined to affected sections | SATISFIED | `verify-sequences.txt` diff adds only `freshness:` (13) and `schema:` (41) lines — no `matrix:`/`controls:` line added or removed. `verify-grammar.txt` diff = a footer note + widening `FRESHNESS-T[123]`→`T[1234]` in three anchors (widened to a closed set, so `T5` still refuses) |

---

## 2. CUSTODY

| # | Clause | Status | Evidence |
|---|---|---|---|
| C1 | Ratify exactly the six named post-R1 housekeeping commits, with no design/contract/production/publication/precedent standing and no waiver | SATISFIED | `OPENING-BASE-AND-CUSTODY.md` §6.4 (new this round, lines 331–359): all six short SHAs listed (`4b66c013`, `0e303440`, `ae10527a`, `f5989500`, `186ec1e9`, `0f5013c1`), the no-standing and no-waiver limits quoted in the ruling's own words, attributed to JURIST |
| C2 | Push nuance recorded | SATISFIED | §6.4(1): "no Surface Account design commit was ever pushed; **one** disclosed private-lab ledger commit, `4b66c013`, was pushed to lab `main`; the five later checkpoints remained local" — **but see PARTIAL-1** |
| C3 | Same eight untracked **NAMES**, not byte-identical contents | SATISFIED | §6.4(2): "proves the same eight status/path **NAMES** — not byte-identical untracked contents … no content-identity claim about untracked files exists or may be inferred" |
| C4 | One raw-clean status captured; per-run raw statuses absent | SATISFIED | §6.4(3), verbatim in the ruling's terms, with the packer named as the forward fix |
| C5 | R1→R2 = 25 paths, 18 modified + 7 added, not 24 | SATISFIED | corrected **where the old figure lived**: `R2-COMPLIANCE-CHECK.md` T2 now reads "**25 paths — 18 modified and 7 added**" with a bracketed in-place attribution; §6.4(4) records it; `grep -rn "24 paths"` across the lane returns nothing |
| C6 | Per-run raw statuses = DEFERRED-TO-PACKER | SATISFIED (as deferral) | §6.4(3) states the absence and assigns the forward fix; listed below in §8 |

---

## 3. OWNER DISPOSITION OF THE R2 VOID

| # | Clause | Status | Evidence |
|---|---|---|---|
| V1 | Accept the four native-predicate non-admission measurements for this contract round | SATISFIED | `CD0-INSPECTION-RECORD-SCHEMA.md` §8 point 6; witness transcript: every branch carries a `…-NOT-RE-ADMITTED` check ("refused by ALL FOUR native admission predicates") with a control arm showing those predicates accepting their own genuine objects |
| V2 | Move the actual Account-predicate and typed-condition tooth into the mandatory production gate | SATISFIED | `R4-SURVIVAL-PLAN.md` §4 **(h5)**, added this round: "MANDATORY at this gate … the production gate must show the inspector's own output failing `account-refusal-p` and drawing the typed condition, with a planted arm" |
| V3 | State the deferral honestly | SATISFIED | schema §8 point 6 names it *"cannot be executed before the prohibited production package exists"*; the witness transcript prints "DEFERRED TO THE PRODUCTION GATE — NOT PASSED, AND NOT VOID EITHER" |
| V4 | **No claim anywhere that the Account-side tooth passed** | SATISFIED | Sweep: `grep -rni "account-refusal-p\|not-an-admitted-account-object"` across the lane. Every occurrence is (a) an API declaration, (b) the deferral text, or (c) the R2 record's own "**PARTIAL … printed as VOID, NOT PASSED**" (A14). Schema §8 point 6 and h5 each carry an explicit negative clause ("No claim … is made here or anywhere in this lane"; "no artifact of this lane claims the Account-side tooth passed") |

---

## 4. R3-A — the /0 schema made total and exact

| # | Clause | Status | Evidence |
|---|---|---|---|
| A1 | For every object admitted by each of the five exact predicates, one complete encoding branch | **SUPERSEDED-DEFECTIVE [R3.1]** — the totality law as written ("unconditionally yields a record") was one stage too strong: the predicates admit objects with detail values the Account cannot encode; replaced by the two-stage total decision law (record OR typed field-validation refusal). Not SATISFIED as originally read. | `CD0-INSPECTION-RECORD-SCHEMA.md` head: the **Totality law** paragraph, stating the predicates admit whole native species and that jurisdiction governs routing while the schema encodes artifacts |
| A2 | Enumerate every admitted native refusal category/phase/code — **S1** | SATISFIED — **[R3.1: relabelled] verified by my own recount (same-family, NOT independent — the original "independently verified" violated the standing claims ceiling and is withdrawn)** | §5.1-T: 9 `PROTOCOL-REFUSAL`/`REQUEST` + 3 + 5 `PROTOCOL-REFUSAL`/`PERFORM` + 3 `INTEGRITY-ALARM`/`RECEIPT` = **20**. My own count of `+refusal-catalog+` in `language-surface-1/surface1.lisp` lines 185–300 = **20 entries** with exactly that class/phase partition. The witness measures the same: `S1 codes: doc / provider 20 / 20`, both difference sets empty (`CHECK-ID SCHEMA-S1-ENUMERATION-TOTAL`) |
| A3 | Enumerate every admitted native refusal category/phase/code — **S2** | SATISFIED — **[R3.1: relabelled] verified by my own recount (same-family, NOT independent — same withdrawal as A2)** | §5.2-T: 9 + 2 + 5 + 7 `/EXPANSION` + 1 `/RUNTIME` + 3 `INTEGRITY-ALARM/RECEIPT` + 2 `INTEGRITY-ALARM/MATCH` = **29**. My own count of `+refusal-catalog+` in `language-surface-2/surface2.lisp` lines 361–451 = **29 entries**, partition identical row for row. Witness: `S2 codes: doc / provider 29 / 29`, both difference sets empty |
| A4 | Make derived-standing total | SATISFIED | §5.1 `"derived-standing"` row: "**total, per code (R3-A)**"; §5.2 inherits "including the total derived-standing law"; every row of §§5.1-T/5.2-T carries a standing |
| A5 | `not-applicable` for admitted provider-owned artifacts outside the Account pre/invoked partition | SATISFIED | S1's three `INTEGRITY-ALARM/RECEIPT` rows; S2's `/EXPANSION` (7), `/RUNTIME` (1), `INTEGRITY-ALARM/RECEIPT` (3) and `/MATCH` (2) rows — all `"not-applicable"`, each with the ruled justification in the cell |
| A6 | Retain pre-invocation and invoked-no-completion-account **where each is actually derived** | SATISFIED | S1: `pre-invocation` on the 9 request codes + the 3 pre-invocation performs; `invoked-no-completion-account` on the 5 expanded-* codes. S2: same shape (9 + 2 / 5). "Never inferred from phase alone" stated in the §5.1 cell and in jurisdiction §2's two governing laws |
| A7 | Add production teeth for an S2 `protocol-refusal`/`:expansion` object and an S2 `integrity-alarm` object — **present and fired** | SATISFIED | Both minted **through S2's own public doors** (witness source and transcript). Nine checks each (`SCHEMA-S2-REFUSAL-PROTOCOL-EXPANSION-*`, `SCHEMA-S2-REFUSAL-INTEGRITY-ALARM-*`: DATUM-P, ENVELOPE-KEY-SET, BODY-KEY-SET, VALUE-SPECIES, ROUND-TRIP, CANONICAL-REENCODING, NATIVE-PASSTHROUGH, NOT-RE-ADMITTED, FULL-EXACTNESS) plus the summary `CHECK-ID SCHEMA-FORMERLY-UNENCODABLE-CLASSES-ENCODE`, all `[PASS]` |
| A8 | `ACCOUNT-INSPECTION-RECORD-P` and the schema witness compare **all seven ruled exactness dimensions** | SATISFIED | Document side: schema §7, five numbered clauses covering (i) complete key identifier datum, (ii) exact namespace, (iii) exact path head + length + segments, (iv) exact schema identity **and** version, (v) exact branch species, (vi) exact enum/standing/category/phase/disposition/code against closed sets, with "an **unknown enum or code fails conformance** — closed sets, no pass-anything cell". Witness side: one `…-FULL-EXACTNESS` check per record, whose label recites the same dimensions; the R2 name-fragment comparison is named as the defect it replaces (witness header item 1) |
| A9 | Composite refusal code exactly `head-not-in-manifest` | **PARTIAL [R3.1]** — the spelling correction held, but this cell banked the whole Door-1 consolidation (one code, contract I.3 clause 1, the witness two-code set), which the R3.1 owner adjudication REJECTS as uncommissioned: Door-1 ownership is RESTORED (four Door-1 codes + wrong-request-species). Not SATISFIED as originally read. | schema §5.3 (`("code" "head-not-in-manifest")`, R2 spelling `not-a-manifest-head` marked superseded); jurisdiction table 1 row; contract I.3 clause 1; witness `*composite-code-phases*` = `(("head-not-in-manifest" . "request") ("wrong-request-species" . "perform"))`. The withdrawn R2 spelling survives only (a) as an explicitly-superseded note and (b) **planted as a tooth and shown failing** (witness line 1062) — never as a live code |
| A10 | Teeth: wrong namespace, wrong path head, extra path segment, wrong schema identity/version/species, unknown enum/code, and the two formerly unencodable classes | SATISFIED | Transcript check IDs 69–78: `SCHEMA-TOOTH-WRONG-NAMESPACE-REFUSED`, `-WRONG-PATH-HEAD-REFUSED`, `-EXTRA-PATH-SEGMENT-REFUSED`, `-WRONG-SCHEMA-IDENTITY-REFUSED`, `-WRONG-SCHEMA-VERSION-REFUSED`, `-WRONG-SPECIES-REFUSED`, `-UNKNOWN-ENUM-REFUSED`, `-UNKNOWN-CODE-REFUSED`, plus two beyond the ruling (`-WRONG-CODE-PHASE-PAIRING-REFUSED`, `-WRONG-DERIVED-STANDING-REFUSED`); the two positive class teeth at A7. R2's three teeth retained (65–67) with a baseline-recognized control (68) |
| A11 | Construct and validate one genuinely lawful instance of **every current branch** | SATISFIED — **seven records** | `SCHEMA-BRANCH` blocks for `s1-receipt`, `s2-receipt`, `s1-refusal`, `s2-refusal`, `composite-refusal`, `s2-refusal-protocol-expansion`, `s2-refusal-integrity-alarm`; closing check `SCHEMA-WITNESS-ALL-FIVE-BRANCHES` states "five current branches … plus the two formerly-unencodable S2 classes … **seven records in all**". Section total `CHECKS 86   FAILURES 0   CASES 0`, matching the profile binding `SCHEMA-WITNESS:0:86` |

---

## 5. R3-B — the /1 identity law normalized

| # | Clause | Status | Evidence |
|---|---|---|---|
| B1 | Retain the linearizable Account-owned allocator | SATISFIED **as retention** — **[R3.1 note: the cited law 2 phrasing ("returns an integer strictly greater… under arbitrary thread interleaving") was the false completion-return-order claim, deleted by R3.1-B; linearizability is now stated conventionally]** | contract II.3, "The chosen exact law … a LINEARIZABLE Account-owned allocator", law 2 with the primitive-documentation requirement |
| B2 | Define "one image" as one running Lisp image/process | SATISFIED | contract II.3 law 0: "**\"One image\" is defined** (R3-B, verbatim scope): **one running Lisp image/process.** All allocator scope-words below mean exactly this" |
| B3 | State, epoch and counter initialize once and **survive** package/source reload; reload must not reset the counter or gather a new epoch; new image = new state; no cross-image guarantee | SATISFIED — reversal executed | contract II.3 law 1, with the reversal disclosed in place ("*This REVERSES the R2 reload paragraph … the R2 text is withdrawn*"), and the epoch paragraph restated ("the epoch is NOT re-gathered on package/source reload"). Code side: `probe-identity.lisp` header names the mechanism — guarded `DEFVAR`s, not `DEFPARAMETER`, "which is exactly the R2 behaviour this ruling REVERSES" |
| B4 | No "fresh epoch on reload" text survives in live law | SATISFIED (see OBS-1) | Sweep `grep -rni "fresh epoch\|new epoch\|re-gather\|resets the counter\|re-initializ"`: survivors are the ruling itself, the *negated* forms in contract II.3 and `probe-identity.lisp`, the T4 check names, the planted-arm labels, and two **historical** records (`R1-AMENDMENT-LOG.md` R2 section; `R2-COMPLIANCE-CHECK.md` D6). No live law states reload re-initialization |
| B5 | One exact shared representation: epoch datum, canonical epoch-hex projection, namespace `("lisp-plus-surface-account")`, path `("performance" <epoch-hex> <counter-decimal>)` | SATISFIED | contract II.3 law 3, all four items, with the request identity explicitly excluded; `probe-identity.lisp` `performance-identifier` builds exactly that shape |
| B6 | **Both** witnesses use the same constructor | SATISFIED | `probe-identity.lisp` is the single source; `probe-freshness.lisp:85` and `probe-allocator.lisp:62` each `(load (merge-pathnames "probe-identity.lisp" …))`; neither defines its own builder. The R2 disagreement (two different shapes) is disclosed verbatim in `probe-identity.lisp`'s header as the reason the file exists |
| B7 | Unsynchronized `INCF` only in the labelled negative tooth | **NOT SATISFIED [R3.1]** — this cell's own evidence lists a bare `(incf *bare-counter*)` in the `ALLOCATOR-OBSERVATION` arm, which was not the labelled negative tooth; R3.1-B deletes that redundant arm (the barrier tooth suffices) and confines unsynchronized `INCF` to the explicitly labelled negative tooth alone. | `probe-identity.lisp`: the only counter `INCF` is inside `sb-thread:with-mutex` (`allocate-performance-counter`), and the file states "UNSYNCHRONIZED INCF APPEARS NOWHERE IN THIS FILE". In `probe-allocator.lisp` the only bare `(incf *bare-counter*)` is line 292, inside the labelled `ALLOCATOR-OBSERVATION` arm; the other two `incf`s are a mutex-held barrier counter and a local duplicate tally |
| B8 | Injective, domain-separated construction; the complete performance datum an injective **component**, never "folded into" | SATISFIED | contract II.3: two identity basis records with exact three-key sets and `("identity" "occurrence")` / `("identity" "account")` separators, plus a structural injectivity argument from CD/0 canonical-encoding exactness. Sweep for "folded into": every survivor is either the ruling, a **disavowal** ("never 'folded into' an unspecified projection", II.5 row), a probe comment recording the strike, or a **historical** R1 record |
| B9 | The five proofs, each discharged — incl. reload persistence (T4) and new-image observation without a uniqueness claim | SATISFIED | Proof 1 → `ALLOCATOR-CLEAN-ALL-DISTINCT` / `-COUNTERS-CONTIGUOUS` with a planted unsynchronized arm shown losing allocations and a detector-discriminates check. Proof 2 → `FRESHNESS-T2-REQUEST-IDENTITY-STABLE` + `-IDENTITY-EXCLUDES-PERFORMANCE` + a perturbed-request planted arm. Proof 3 → `FRESHNESS-T1-OCCURRENCE-IDENTITIES-DIFFER` / `-ACCOUNT-IDENTITIES-DIFFER` / `-PERFORMANCE-INJECTIVE-COMPONENT` / `-DOMAIN-SEPARATION` + three planted collision checks. **Proof 4 (new)** → `FRESHNESS-T4-RELOAD-HAPPENED`, `-EPOCH-NOT-REGATHERED`, `-EPOCH-UNCHANGED`, `-COUNTER-NOT-RESET`, `-COUNTER-CONTINUES`, `-POST-RELOAD-DATUM-SHAPE`, `-PLANTED-RESET-DETECTED`. Proof 5 → `FRESHNESS-T3-PEER-EPOCH-SUPPLIED` / `-EPOCH-DIFFERS-FROM-PEER` with contract II.3's claims ceiling ("an observation about entropy, never a uniqueness guarantee"). Section total `CHECKS 28   FAILURES 0`, matching `FRESHNESS:0:28` |

---

## 6. R3-C — refusal ownership and lifecycle residues

| # | Clause | Status | Evidence |
|---|---|---|---|
| C-1 | Replace grouped future-/1 phrases with exact named codes, categories, phases, owners, standings | SATISFIED-AT-R3, SUPERSEDED **[R3.1 supersession audit, chair]**: the cited evidence itself still contained "/1 integrity-alarm *families*", which R3.1-C ordered replaced with exact rows — table 3 now enumerates them as exact rows; the R3-time SATISFIED rested on a construction the next ruling deleted | `REFUSAL-AND-CONDITION-JURISDICTION.md` table 3 as of R3.1: every /1 condition an exact named row (four integrity-alarm rows verbatim, no "families"). Sweep for grouped constructions over the /1 tables returns nothing |
| C-2 | Every fixed future refusal-schema key **always present**; absent occurrence tags, request identities, native antecedents via mandatory standing datums, never conditional keys | SATISFIED | contract II.5 "Complete /1 retained-refusal schema (R3-C: every key ALWAYS present; absence via mandatory standing datums, never conditional key presence)" — occurrence-tag and request-identity each spelled out with `("standing" "not-applicable")`; the native-antecedent row above carries `("standing" "absent-no-public-antecedent")` as a mandatory field |
| C-3 | Lock: /0 Door 1 does not prevalidate the occurrence tag | SATISFIED (verbatim) | jurisdiction table 1's lock block, item 1; contract I.3 clause 2 |
| C-4 | Lock: the delegate validates it and returns the exact provider-owned refusal | SATISFIED (verbatim) | lock item 2 (`:occurrence-tag-not-identifier`, table 2); contract I.3 clause 2 |
| C-5 | Lock: native passthrough refusals are Account-domain but provider-owned | SATISFIED (verbatim) | lock item 3; restated as a governing law at jurisdiction §2 |
| C-6 | Lock: a request rejected by Door 2 is phase `:perform`, incl. the /1 `wrong-request-species` and `incompatible-account-version` cases | SATISFIED (verbatim) | lock item 4; table 1 row 2; table 3 rows 1–2; schema §5.3 phase pairing; contract II.1b clause 3 rewritten from "pre-invocation protocol refusal" to "**phase `:perform`** … derived standing `pre-invocation`" |
| C-7 | Delete every remaining claim that /0 declarations "move" | SATISFIED | contract I.1: "**they never move** (R3-C): a governed successor **introduces its own distinct declarations**". Sweep: no surviving "declarations move" claim about /0; every remaining "moved" is Control-6's *provider* redefinition subject (frozen sources) |
| C-8 | Delete the Candidate-B claim that inspection reports live declarations as current | SATISFIED — and Candidate A too | `ARCHITECTURE-DOCKET.md` diff shows both cells rewritten: "the pure inspector reads no live declaration and reports nothing \"as current\" (R3-C; the R0 clause deleted)". Sweep for "live declarations as current" returns nothing |

---

## 7. R3-D — the transcript grammar closed

| # | Clause | Status | Evidence |
|---|---|---|---|
| D1 | Every bracketed uppercase verdict token of **one or more** characters declared or refused, incl. `[X]` and `[OK]` | SATISFIED | `verify-transcript.sh` awk clause (1): pattern `\[[A-Z0-9_-]+\]` (length floor removed; written with `+` for mawk/gawk/busybox parity), refusing anything but the exact `  [PASS] <label>` line at any indentation |
| D2 | Child terminator lexically exactly `CHILD-EXIT 0` | **PARTIAL [R3.1]** — the state-2 comparison was exact once dispatched, but the R3.1-D whitespace-impostor family reproduces a tab-prefixed `CHILD-EXIT` evading dispatch into narrative; tab/CR rejection before grammar dispatch is ordered (probe seat). | state-2 clause replaced: string comparison `line != "CHILD-EXIT 0"`, with a distinct message for a genuinely nonzero exit; the arithmetic `$2 + 0 != 0` test is gone |
| D3 | An accepted section footer lexically **and semantically** `FAILURES 0` | SATISFIED | new clause (1b) in the verifier (not the grammar file, deliberately, so `--grammar` cannot lift it): refuses any line matching `^ *CHECKS ` that is not `^CHECKS [0-9]+   FAILURES 0   CASES [0-9]+$`. `verify-grammar.txt` carries a note saying exactly that the production is not where the law lives |
| D4 | Git tip resolution with replacement objects disabled, and the named object physically exists and is a commit | **PARTIAL [R3.1]** — `--no-replace-objects` held, but the R3.1-D repository-substitution family reproduces resolution redirected through ambient `GIT_DIR`/`GIT_OBJECT_DIRECTORY`/`GIT_ALTERNATE_OBJECT_DIRECTORIES`/configured alternates; environment clearing and alternate rejection are ordered (probe seat). | tip clause replaced by `GIT_NO_REPLACE_OBJECTS=1 git --no-replace-objects -C "$REPO" cat-file -e "$TIP"` for existence and `cat-file -t` for type, refusing anything that is not `commit`; both the switch and the environment variable, and the refusal message names the replace lens |
| D5 | **Exactly four** new specimens, defect-derived | SATISFIED | `run-verifier-specimens.sh` header "R3 SPECIMENS 15-18": 15 `short-bracketed-verdict` ([X]), 16 `child-exit-000`, 17 `footer-failures-999`, 18 `tip-through-refs-replace`. No fifth; the `[OK]` two-character case is explicitly filed as *evidence for specimen 15's clause*, "Not a nineteenth specimen" (line 471) |
| D6 | Pre-fix-verifier acceptance evidence (the holes were real) | SATISFIED | `evidence/prefix-acceptance-of-r3-specimens.txt`: the **R2** verifier on spec15, spec15ok (`[OK]`), spec16, spec17, spec18 → `exit=0` on all five, with the reading "exit 0 = the R2 verifier ACCEPTED the defect: the hole was real". Per-specimen stderr captures in `evidence/prefix-spec1{5,5ok,6,7,8}.err` |
| D7 | All 18 specimens refuse; zero regressions | SATISFIED — **re-run by me at this tip** | My own read-only run of `run-verifier-specimens.sh` at HEAD `b294d712`: 18 specimens refused (1–12, 15–18), both output-path teeth refused **without leaving a directory**, the `[OK]` and all-zero-fixture-tip evidence arms refused, the fixture repository's own real commit ACCEPTED as the control, base ACCEPTED, terminal line `SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-PASS`, **exit 0** |
| D8 | R2 clean transcripts still accepted under the repaired grammar at the **physical R2 commit** (two-arm evidence) | SATISFIED — **independently reproduced by me** | `evidence/r2-clean-under-r3-verifier.txt` (ARM A: five ACCEPTED under R2-era declarations; ARM B: the two rewritten sections refused by the **external CHECKS binding**, correctly read as the binding working, not a grammar finding). I reproduced ARM A myself: current `verify-transcript.sh`, R2-era `verify-profiles/grammar/sequences`, `--tip 42475355a4a436f6a0e7262896c241dfef4880e2 --repo …/experiments/latent-lisp` → matrix, controls, freshness, schema, allocator **all exit 0 ACCEPTED**. The four R3-D repairs cost no prior acceptance |

---

## 8. Deletion hunts

Patterns run over the whole lane directory (`grep -rni`), with the ruling's own
allowance that **historical and filed contexts are lawful**.

| Pattern | Live survivors | Verdict |
|---|---|---|
| `folded into` | none as a live claim. Survivors: the ruling; contract II.3 §II.5 **disavowals**; `probe-identity.lisp` / `probe-freshness.lisp` comments recording the strike; `R1-COMPLIANCE-CHECK.md:102` and `R1-AMENDMENT-LOG.md:98` (historical R1 records) | CLEAN |
| `fresh epoch` / reload-reset claims | none as a live law. Survivors: the ruling; negated forms; T4 check names and planted-arm labels; `R1-AMENDMENT-LOG.md:288` and `R2-COMPLIANCE-CHECK.md:135` (historical) | CLEAN (see OBS-1) |
| `declarations move` (about /0) | none. Contract I.1 now states "they never move". Every other "moved" is Control-6's *provider* redefinition, a different subject in frozen sources | CLEAN |
| live-declarations-as-current | none. Both docket cells (Candidate A **and** B) rewritten; `grep` for the phrase returns nothing | CLEAN |
| withdrawn composite codes as **live Door-1** codes | none. `not-a-manifest-head` appears only as an explicitly superseded spelling and as a planted tooth shown failing. `source-form-not-a-call` / `source-form-head-not-a-symbol` / `operation-not-declared` appear only as **native** codes (table 2, §5.1-T/§5.2-T) or in the withdrawal note itself | CLEAN (see OBS-2) |
| grouped future-/1 phrases | none in table 3 or contract II.5 | CLEAN |

---

## 9. The `head-not-in-manifest` consolidation — flagged reading, and its internal consistency

The chair flagged, in `R1-AMENDMENT-LOG.md` §R3-A, that it read the ruling's
singular *"the composite refusal code"* as ordering **consolidation of Door 1 to
one code**, not merely a spelling fix, and that the R2 multi-code table is
restorable if the owner meant only the spelling. **I record that as a flagged
reading, not a gap** — the ruling's text supports it and does not compel it.

**Internal consistency of the reading, checked across all four places it must
hold:**

| Locus | What it says | Consistent? |
|---|---|---|
| Jurisdiction table 1 | Door 1's only refusal `head-not-in-manifest` (`:request`, `pre-invocation`, retainable); Door 2's `wrong-request-species` (`:perform`); the two inspector codes marked condition-signal-only, never branch-5 | yes |
| Contract I.3 | clause 1: head resolution is "Door 1's only own jurisdiction"; the five failure shapes all draw the **one** code, the `detail` string distinguishing them; clause 2: no other prevalidation | yes |
| Schema §5.3 | closed **two-code** set with per-code phase pairing (`request` / `perform`), inspector codes excluded from the key | yes |
| Witness | `*composite-code-phases*` is exactly that two-element alist; teeth for an unknown code, for the withdrawn spelling, **and for a correct code with the wrong phase** | yes |

**One collateral over-reach inside the consolidated reading (OBS-2).** Table 1's
withdrawal sentence says the three withdrawn codes' *"exact same-named codes
reach the caller as provider-owned passthrough, table 2."* Under contract I.3
clause 1 as now written, a form that is not a cons, or whose head is not a
symbol, is refused **at Door 1 before any delegation** — so S1/S2's
`:source-form-not-a-call` and `:source-form-head-not-a-symbol` cannot be reached
through the composite at all. Only `:operation-not-declared` is genuinely
reachable (a cons with a manifest head and a bad operation does reach a
delegate). Table 2 itself is safe — its header declares it an enumeration of the
providers' catalogues, not a reachability claim — so the defect is confined to
the one sentence in table 1. It is small, it is internal to the flagged reading,
and it does not violate any clause of the ruling; I record it so the owner's
terminal ruling can dispose of the sentence along with the reading.

---

## 10. LOCKED ACCEPTANCES — verification that none was reopened

The test applied to each: does the R2→R3 diff touch the text that carries it, and
does the current text still state it?

| # | Locked acceptance | Status | Evidence |
|---|---|---|---|
| 1 | the exact seven-head union | NOT REOPENED | `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` absent from the diff; contract I.1 head table unchanged |
| 2 | the five-member /0 inspector domain and its exclusions | NOT REOPENED | contract I.8 / I.8b outside every diff hunk (hunks touch only lines 62, 157, 429, 496, 566, 602, 623) |
| 3 | exact native receipt/refusal identity preservation | NOT REOPENED | schema §6 pass-through law unchanged in substance; the witness proves `canonical-octets` + `equal-datum` equality per branch (`…-NATIVE-PASSTHROUGH`, all `[PASS]`) |
| 4 | the two lawful full-expansion STOP cells | NOT REOPENED | `probe-matrix.lisp` byte-identical; the STOP-cell references in §5.1 and jurisdiction table 2 unchanged |
| 5 | the five provenance labels and 25 classified rows | NOT REOPENED | `READER-PROVENANCE-MATRIX.tsv` absent from the diff |
| 6 | S2 provider-recomputation standing | NOT REOPENED | `probe-control-6.lisp` byte-identical; docket E6 cell and jurisdiction Locked-Ruling-6 text untouched |
| 7 | category-first-then-phase jurisdiction | NOT REOPENED | jurisdiction §4 outside the diff; contract I.4 clause 5 unchanged |
| 8 | immutable, separately addressed /0 and /1 inspectors | NOT REOPENED | contract II.5b unchanged (the diff's last hunk ends at II.5's refusal schema) |
| 9 | Candidate C's benefits and present non-adoption | NOT REOPENED | docket diff touches exactly two Identity/version-bindings cells (Candidates A and B); Candidate C's section untouched |
| 10 | the linearizable allocator choice | NOT REOPENED — retained as ruled | contract II.3, R3-B clause 1 of the ruling |
| 11 | the clean/planted R2 provider measurements | NOT REOPENED | `probe-matrix.lisp`, `probe-controls.lisp`, `probe-control-6.lisp`, `probe-prelude.lisp`, `run-probe.sh` byte-identical at R2 tip, HEAD and on disk; `POSITIVE-MATRIX` / `CONTROLS-A` / `CONTROLS-B` profile bindings unchanged |
| 12 | NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED | NOT REOPENED | docket §6 outside the diff |

---

## 11. GAPS AND PARTIALS

### GAP-1 — `probes/README.md` carries a stale ID census (a post-heal fossil introduced by this round)

`probes/README.md:374` states: *"the complete ordered list of them — **283** IDs
across the five real sections — is `verify-sequences.txt`."* That figure was true
at R2 and is false at this tip. Counted at both revisions:

```
git show 42475355:…/probes/verify-sequences.txt | grep -E "^[a-z]+:" | grep -vc "^synthetic:"   → 283
git show b294d712:…/probes/verify-sequences.txt | grep -E "^[a-z]+:" | grep -vc "^synthetic:"   → 337
```

The ID-family table immediately below it is stale in the same way:

| README row | README says | Actual at this tip (`awk '{print $1}' verify-sequences.txt \| grep -E "^[a-z]+:" \| cut -d: -f1 \| sort \| uniq -c`) |
|---|---|---|
| `FRESHNESS` | 27 IDs, families `FRESHNESS-T1 / -T2 / -T3` | **40**, and the arms are **T1–T4** |
| `SCHEMA-WITNESS` | 60 IDs | **101** |
| `ALLOCATOR` | 18 IDs | 18 — correct |
| `CONTROLS-A` + `CONTROLS-B` | 70 + 51 | 121 — correct |

The same README is internally contradictory: line 408 correctly describes
`probe-freshness.lisp` as "four arms T1–T4", and line 409 correctly describes the
schema witness's seven records, while line 381's family row still names three
freshness arms. Nothing else depends on the numbers — the verifier is told the
sequence as data and never reads the README — so this is a documentation-accuracy
defect, not a verification defect. It is nonetheless exactly the class the lane's
own discipline names (prose copies of a changed output surviving a reading
audit), and it is in a file the R3 round edited. **Fix: update the three figures
and the freshness family row; no other change.**

### PARTIAL-1 — a surviving "nothing pushed anywhere" phrasing in the custody document

`OPENING-BASE-AND-CUSTODY.md` §6.4(1), written **this round**, records the
owner's correction and closes with: *"no lane claim of 'nothing pushed anywhere'
survives."* Forty lines later, in §7 Evidence, line 383 still reads:

> The public mirror was reached **read-only** — one `git ls-remote` and one
> `git clone --no-checkout`. **Nothing was pushed anywhere**, and
> `tools/latent-lisp/sync.sh` was read but never run.

Read in its paragraph the sentence is about the public mirror and about this
round's own actions, and in that scope it is true. Read literally it is the exact
phrase the correction three sections earlier declares must not survive, and it is
false of lab `main` (where `4b66c013` was pushed). `PREDECESSOR-IDENTITIES.md:48`
carries the shorter cousin ("Nothing was pushed."), same scope, same ambiguity.
**Fix: scope the sentence ("nothing was pushed to the public mirror") in both
places.** I record this as PARTIAL rather than GAP because the custody clause the
ruling actually ordered (C2) *is* satisfied — the nuance is recorded in full —
and what remains is an unscoped restatement in an evidence section.

### Observations (not gaps, recorded for the terminal ruling)

- **OBS-1.** `R2-COMPLIANCE-CHECK.md` D6 still quotes the now-withdrawn R2 reload
  law ("a fresh epoch and a counter restarted at zero") as SATISFIED, with no
  supersession marker. It is a historical record of the R2 tree and the ruling
  ordered no sweep of it — but the same file **was** edited in place this round
  for the T2 custody figure, so it is not being treated as immutable, and a
  reader arriving at D6 inherits a reversed law with no pointer. A one-clause
  bracketed note, in the T2 style, would close it.
- **OBS-2.** The consolidation's collateral over-reach in jurisdiction table 1's
  withdrawal sentence — §9 above.
- **OBS-3.** The witness evidence I read (`probe-r3/dev-{a,b,c,d,planted}/`) was
  produced at `PARCEL_TIP d3566d6f…`, the R3 commission-filing commit, **not** at
  the final tip `b294d712`. That is expected — the R3 FINAL VERIFICATION runs at
  the final tip and makes no post-test commit, so it cannot precede the final
  commit — and it is why the final witness runs head the deferred list below. Of
  the four final-verification arms I could discharge read-only, **two are already
  discharged at the final tip by my own runs**: the complete old+new specimen
  suite (PASS, exit 0) and the unchanged R2 clean transcripts against the
  physical R2 commit (five ACCEPTED).

---

## 12. DEFERRED-TO-PACKER

Nine items, in the order the ruling states them. None is a defect in this tree;
each is work the ruling assigns to the return, not to the delta.

1. **The R3 FINAL VERIFICATION at the final tip `b294d712`** — the corrected
   schema witness with its planted/adversarial arms, and the unified
   freshness/allocator witnesses including reload persistence, re-run **at this
   tip**, every malformed arm exiting nonzero, every clean affected witness
   passing, and **no post-test commit**. (The specimen suite and the R2-clean
   arm are already discharged at this tip — §11 OBS-3.)
2. **Per-run raw statuses after every individual run** — absent for past runs by
   the owner's own correction; supplied by the packer going forward
   (`OPENING-BASE-AND-CUSTODY.md` §6.4(3)).
3. **One small R3 delta ZIP plus exact-name SHA-256 sidecar.**
4. **The R3 Git bundle with exact R2 tip `42475355a4a436f6a0e7262896c241dfef4880e2`
   as its SOLE prerequisite.**
5. **No repack of the accepted 254-file R2 corpus.**
6. **Reference to the accepted R2 parcel by exact SHA-256 and tip.** Verified
   live by me: `sha256sum ~/Downloads/SURFACE-ACCOUNT-0-R2-RETURN-2026-08-04.zip`
   = `b7ca95c60a29ede44789ad5a8a76ab4f7bc4da29695af5b7d781108503c468f0`, matching
   both the sidecar on disk and the commission's stated value; tip `42475355…`.
7. **Parcel contents exactly as enumerated** — amended schema/contract/identity/
   refusal/lifecycle/docket files; affected non-production witnesses and verifier
   files; new clean/planted/adversarial transcripts and exit evidence; exact
   R2→R3 patch and path inventory; protected-byte and absence confirmations;
   tested-tip/no-post-test evidence; delta bundle and manifest.
8. **The `BUNDLE-INSTRUCTIONS.md` custody wording** — the six R3-ratified
   checkpoints recorded as a *second* acceptance at a *second* moment, never
   merged with the three pre-opening housekeeping commits accepted at opening
   (`OPENING-BASE-AND-CUSTODY.md` §6.3, carried forward).
9. **No self-authored acceptance** — no contract acceptance, production
   authorization, adoption, closure, or Surface /3 opening in the return; stop
   for the owner's terminal contract ruling.

---

## 13. Verdict

Every clause of the R3 adjudication is discharged in the tree at
`b294d712`, on the evidence cited above, with two exceptions, both documentary
and both outside the ruled repairs: a stale ID census in `probes/README.md`
introduced by this round's own witness growth (GAP-1), and an unscoped "nothing
was pushed anywhere" sentence surviving in the custody document's evidence
section against that document's own R3 correction (PARTIAL-1). Neither touches a
law, a witness, a tooth, or a locked acceptance; both are two-line fixes; and
both are stated here with the exact commands that found them so the chair need
not re-derive anything.

**GAPS FOUND (2): GAP-1 — `probes/README.md` states 283 sequence IDs, 27
FRESHNESS IDs (arms T1–T3) and 60 SCHEMA-WITNESS IDs where the file at this tip
holds 337, 40 (arms T1–T4) and 101; PARTIAL-1 — `OPENING-BASE-AND-CUSTODY.md`
line 383 (and `PREDECESSOR-IDENTITIES.md` line 48) retain the unscoped phrase
"Nothing was pushed anywhere", which §6.4(1) of the same document rules must not
survive.**

— Claude Opus (LECTOR-3, fresh context), 2026-08-04
