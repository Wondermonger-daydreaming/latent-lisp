# Surface Account /0 — R2 Compliance Check

**Seat:** LECTOR-2 (compliance examiner), R2 round.
**Governing law:** `OWNER-ADJUDICATION-R1-AND-R2-COMMISSION.md`, read in full;
every row below is built from **its** text, clause by clause.
**Tree examined:** branch `surface-account-0-opening` at
**`ee4dc745ee79f6db758527d973ee3c4ccadd9059`** (verified by `git rev-parse`),
worktree raw-clean at examination (`git status --porcelain` empty).
**Date:** 2026-08-04.

## Standing declaration

**Fresh context, same family, not an independent audit.** This examiner booted
without the R2 sitting's context and read the ruling and the tree cold, but it
is another Claude instance under the same boot documents as the seats it
checks. That is a *fresh-context* tier, never a fresh-weights or stranger tier;
nothing below may be cited as "independently verified" or "independently
audited," and no reading of this file may promote it to that standing.

**What was executed, and what was not.** The verifier and its specimen suite
were run read-only, at this exact tree, with output outside the worktree
(`run-verifier-specimens.sh … --from <final-a controls-transcript> --tip
c6a2738f… `): **all fourteen specimens refused, both bases accepted, both
output-path teeth refused with nothing created, exit 0**, and the worktree
stayed raw-clean. The **full probe was NOT run** — that is the packer's job at
the frozen tip. Dev-run evidence at `…/scratchpad/sa0-parcel-staging/probe-r2/`
(`final-a`, `final-b`, `final-planted`, `final-spec`) was read, not re-made.
Nothing was committed; one file was written — this one.

---

## 1. Top prohibitions and R2 scope

| # | Clause (ruling text) | Status | Evidence |
|---|---|---|---|
| T1 | Continue the unpushed design branch from exact R1 tip `98abd8cc…` | SATISFIED | `git log --oneline 98abd8cc..HEAD` = exactly three commits (`c6a2738f`, `11270deb`, `ee4dc745`), linear, no rebase of the R1 tip |
| T2 | Do not implement production code | SATISFIED | `git diff --name-status 98abd8cc..HEAD`: **25 paths — 18 modified and 7 added** *[R3 correction per the R2 adjudication's custody ruling — this cell originally read "24 paths"; corrected in place by JURIST, no special repair commit]*, all under `mneme/language-surface-account-0/`; the two added Lisp files (`probes/probe-schema-witness.lisp`, `probes/probe-allocator.lisp`) each open with the `NON-PRODUCTION FEASIBILITY PROBE … not a package, not an API, not loadable as part of any system` banner and define no package (`in-package #:cl-user`) |
| T3 | Do not merge, rebase, publish, sync, adopt, freeze, or close | SATISFIED | branch is unpushed and unmerged; no tag; no sync artifact; no closure text — every document still carries "candidate / proposed / not implemented" (contract head; docket §7) |
| T4 | Do not edit a predecessor, ASDF system, loader, matrix, release floor, public mirror, or Surface /3 path | SATISFIED | the R1→R2 name-status list contains **no** path outside the lane dir; `lisp-plus.asd`, `mneme/load-*.sh`, `mneme/verify-release.sh`, `language-surface-0/1/2` all absent from the diff |
| T5 | Do not restart the architecture survey | SATISFIED | no new measurement artifact; `CARTOGRAPHY-NOTES.md`, `PROVIDER-API-MATRIX.tsv`, `READER-PROVENANCE-MATRIX.tsv`, `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv`, `PREDECESSOR-IDENTITIES.md` are byte-unchanged in the R1→R2 diff |
| T6 | Surface /3 remains unopened | SATISFIED | `ls mneme/` shows `language-surface-0/1/2` and `language-surface-account-0` only — no Surface /3 path, package, system, or contract anywhere; lifecycle step 2 leaves it owner-owned |
| T7 | R2 scope: documentation and unmistakably non-production witnesses only beneath `mneme/language-surface-account-0/` | SATISFIED | same diff as T4; every added artifact is a document, a `.txt` grammar/profile/sequence declaration, a banner-carrying probe, or a shell witness |

---

## 2. Custody rulings

| # | Clause | Status | Evidence |
|---|---|---|---|
| C1 | Ratify the five exact post-R0 ledger-only commits | NOTED (owner act) | All five resolve and are ledger-only: `8c49e1ff` (`tools/ledger/agents.jsonl`, `tools/ledger/the-book-of-the-guild.md`), `bb6892ae`, `16a3d770`, `a54531ae`, `f1a6dbe1` (each `tools/ledger/agents.jsonl` alone). Nothing under `experiments/latent-lisp/` in any of them. No lane text is required by the clause and none was written; see D-6 |
| C2 | Ratify the freeze-time uncommitted LECTOR row in `tools/ledger/agents.jsonl` as a fully disclosed hook artifact; not a general waiver | NOTED (owner act) | Owner ratification; the lane asserts no waiver derived from it. `R1-AMENDMENT-LOG.md` R2 §"Not amended, deliberately" states the R2 custody ratifications concern commits and a ledger row **outside** the lane and are the chair's packing record — an accurate scoping, not a claim of relief |
| C3 | Correct without a special repair commit: R0→R1 changed **22 files, not 21: 16 modified and 6 added** | SATISFIED | `R1-COMPLIANCE-CHECK.md:22` now reads **"22 files (16 modified, 6 added)"** with a visible bracketed attribution naming the R2 correction and "no special repair commit, as the ruling directs". Corrected **in place** inside commit `11270deb` (a document-repair commit, not a dedicated repair commit). Lane-wide grep for `21 file` returns no live occurrence |
| C4 | Correct without a special repair commit: **76 value-exercised yes rows, 8 enumerated-only rows, 1 explicitly unmeasured row** | SATISFIED (with a naming judgment, §5 below) | `R1-COMPLIANCE-CHECK.md:41` now reads **"76 value-exercised yes rows / 8 enumerated-only rows / 1 explicitly unmeasured row"** with bracketed attribution. Grep confirms no other live occurrence of the stale "76 / 9 …" tally |

---

## 3. LOCKED ACCEPTANCES — not reopened

Each of the eleven was checked against the R2 amendments for reopening,
contradiction, or silent re-litigation.

| # | Locked item | Status | Evidence |
|---|---|---|---|
| L1 | the exact seven-head union | INTACT | `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` unchanged in the R1→R2 diff; contract I.1 still "exactly the seven unique head keys" |
| L2 | the five-member current /0 inspector input union | INTACT | contract I.8 table, five rows, unchanged; R2 Section B touches **/1's** side only (II.2 / II.5b) and states "nothing enters /0's union, ever" (docket §2-D) |
| L3 | exclusion of requests, occurrences, ordinary values, `SEAT-OUTCOME`, `NIL`, field-mimicking plists, and inspector output | INTACT | contract I.8 "Not admitted" paragraph carries all seven exclusions verbatim, including the inspector's own output |
| L4 | pure delegation returning the exact native receipt or refusal | INTACT | contract I.0 four bullets; I.4.4 "Return **the exact native receipt**"; API delta §1 comments |
| L5 | the two lawful full-expansion STOP cells | INTACT | docket E2 and §3; jurisdiction §6; contract cross-cutting law 2 — all still cite Locked Ruling 2 and claim nothing more |
| L6 | the five provenance labels and 25 classified TSV rows | INTACT | jurisdiction §7 table (12/9/2/1/1); docket E9/§6b; phrasing is still "25 classified TSV rows", never "25 atomic facts" |
| L7 | S2 `VERIFY-RECEIPT` as provider-recomputation and declaration-independence | INTACT | jurisdiction §7 verifier row and docket E6 carry the ruled standing verbatim; the schema keeps verifier output **out** of the record (`CD0-…-SCHEMA.md` §4.2 standing constant) |
| L8 | category-first-then-phase as the governing S2 jurisdiction law | INTACT | jurisdiction §4 keying law, order preserved; contract I.4.5; probes/README "the caught-condition partition" |
| L9 | the current /0 manifest/request coexistence clauses | INTACT | contract II.1b, all six clauses, unchanged; lifecycle step 5 |
| L10 | Candidate C's four genuine benefits and present non-adoption | INTACT | docket §2-C: the four benefits stand; benefit 2 is **sharpened** by R2 Section D (manifest binding lives in the routing request only) and the sharpening *strengthens* C's advantage — no benefit removed, non-adoption conclusion unchanged ("still not recommended now — but for the priced reasons above") |
| L11 | `NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED` | INTACT | docket §6 verdict text unchanged |

**No locked acceptance was reopened or contradicted by an R2 amendment.**

---

## 4. Sections A–F, clause by clause

### A — CD/0 inspection schema made implementation-determinate

| # | Clause | Status | Evidence |
|---|---|---|---|
| A1 | output is a direct inert CD/0 record datum, not a private Account wrapper or newly admitted semantic account object | SATISFIED | `CD0-INSPECTION-RECORD-SCHEMA.md` head ("**direct inert CD/0 record datum** — never a private Account wrapper, never a newly admitted semantic account object"); contract I.6 and I.8b repeat it |
| A2 | every identifier-datum record key, including namespace/path | SATISFIED | schema §1 — namespace `("lisp-plus-surface-account")`, seven path families, ownership stated structurally |
| A3 | the common envelope and exact nested branch-body record | SATISFIED | schema §3 — one record datum, exactly four keys (`schema-identity`, `schema-version`, `species`, `body`), body = the branch record |
| A4 | the exact key set for each of the five current branches | SATISFIED | schema §§4–5: 18 / 18 / 9 / 6 / 6, each tabulated key by key; witness asserts the counts back through `record-datum-size` / `record-datum-key-at` (`probe-schema-witness.lisp` `body-key-set-ok-p`) |
| A5 | schema identity and schema version datums | SATISFIED | schema §3 rows: identifier `("schema" "account-inspection-record")`, integer datum `1` |
| A6 | datum encoding for every enum, keyword, integer, string, code, category, phase, disposition and standing value | SATISFIED | schema §2 encoding table, six source-kind rows plus the pass-through row; closed standing set (9 names) and closed species set (5 names) enumerated |
| A7 | the mandatory encoding of not-applicable/absent standing | SATISFIED | schema §2 row: "standing / absence / not-applicable (**mandatory encoding — never a missing field, never CL `NIL`**)"; §3 "value-absence is carried by a mandatory `("standing" …)` identifier"; `"not-applicable"` is in the closed set |
| A8 | maximum detail-string size and refusal behavior above it | SATISFIED | schema §2: **1024 canonical payload octets**; above it an Account-owned constructor-validation refusal `:detail-string-exceeds-ceiling` (jurisdiction table 1 row), "**never truncation**". Exercised at 1024 and at 1025 by the witness (`SCHEMA-DETAIL-CEILING-*`, three checks incl. "no datum at all is produced") |
| A9 | which already-CD/0 native datums pass through unchanged | SATISFIED | schema §6 pass-through law (identities, occurrence tag, source/expanded datums, expansion context), proved by `canonical-octets` **and** `equal-datum` equality (`native-pass-through-ok-p`) |
| A10 | no optional field may change a branch schema | SATISFIED | schema §3 ("every listed key always present, every unlisted key never present"); contract I.8b bullet 2; witness teeth `SCHEMA-TOOTH-EXTRA-ENVELOPE-KEY-REFUSED` and `SCHEMA-TOOTH-MISSING-BODY-KEY-REFUSED` |
| A11 | CD/0 canonical key sorting is authoritative; remove prose claiming a semantic field is physically "first" | SATISFIED | schema "Key-order law" (grounded in the read `%normalize-record-entries`); contract I.8b "the R1 '(first field)' prose is deleted". Deletion hunt H5 below: no live "first field" claim survives |
| A12 | remove the contradictory private-constructor/read-only-slot ontology | SATISFIED | contract **I.6**: "**The account-inspection-record is NOT a sealed semantic object.** The R1 text that sealed it is **withdrawn**… There is no private constructor to hide and no slot to make read-only." The ontology is retained only where it lawfully applies (routing request, composite refusal record, /1 objects) |
| A13 | if `ACCOUNT-INSPECTION-RECORD-P` remains proposed it recognizes the exact CD/0 schema, not a wrapper species | SATISFIED | schema §7; contract I.2 export comment; API delta §1 comment ("a schema-conformance check over record datums, never a wrapper species recognizer") |
| A14 | one non-production schema witness constructing one instance of every branch through the accepted CD/0 API, proving the six things | **PARTIAL (declared VOID on one half; not repairable inside R2's own prohibitions)** | `probes/probe-schema-witness.lisp` builds all five branches through the public CD/0 API and proves `datum-p`, round trip, canonical re-encoding equality, exact key set, exact value species, and — for "inspector output is not re-admitted" — refusal by **all four native admission predicates** with a control arm showing those predicates accepting their own genuine objects. The **Account-side half** (presenting the record draws `:not-an-admitted-account-object`) is **printed as VOID, NOT PASSED** in the transcript, because it requires an Account package and T2 forbids one. Honest, disclosed at the point of measurement, and echoed in `probes/README.md` "What the probe refuses to say" |

### B — /0 → /1 inspector lifecycle closed

| # | Clause | Status | Evidence |
|---|---|---|---|
| B1 | the /0 inspector, function identity, schema, and five-member domain remain immutable | SATISFIED | contract I.8 ("**immutable**… no reserved sixth entry… and there never will be"); II.5b ("immutable, forever"); docket §2-D |
| B2 | a future /1 must introduce five distinct things (manifest/version identity, request species + Door 2, inspector schema, public package/function address, separately enumerated completed-account and retained-refusal branches) | SATISFIED | all five present: II.1 (distinct manifest identity/version) · II.1b clause 2 + II.2 Door 2 (distinct request species) · II.5b (own schema identity/version) · II.2 (`LISP-PLUS-SURFACE-ACCOUNT-1`, own address) · II.5b table (two separately enumerated branches, each with its own Account-owned predicate) |
| B3 | delete every claim that /1 extends the "same" /0 inspector or moves /0's union by schema-version movement | SATISFIED | deletion hunt H2: the only two surviving occurrences are the **disavowals themselves** (contract II.5b "is DELETED and disavowed"; docket §2-D "is deleted — nothing enters /0's union, ever") — lawful contexts |
| B4 | under labelled dual authority both inspector addresses remain explicit | SATISFIED | contract II.5b and docket §2-D "one-inspector coherence" paragraph: "under **labelled dual authority both addresses remain explicit**" |
| B5 | any canonical alias, supersession or rebinding requires a later owner adoption ruling; it cannot occur through registration or implication | SATISFIED | carried verbatim in contract II.5b and docket §2-D; coexistence clause 5; R4 §7 exit 1 |
| B6 | resolve INSPECT-ACCOUNT vs INSPECT-EXPANSION by giving each version one exact address | SATISFIED | contract II.2 table: /0 = `LISP-PLUS-SURFACE-ACCOUNT:INSPECT-ACCOUNT`; /1 = `LISP-PLUS-SURFACE-ACCOUNT-1:INSPECT-EXPANSION`. Mirrored in API delta §1 comment and docket §2-D |

### C — failure and refusal ownership closed

| # | Clause | Status | Evidence |
|---|---|---|---|
| C-1 | remove the impossible-route exception | SATISFIED | jurisdiction §3 identity-mismatch bullet: "*The R1 second arm … is **REMOVED** per the R2 adjudication, Section C: the impossible-route exception is dead*"; §2 table 2 S2 row states the same. Deletion hunt H1: no live exception survives |
| C-2 | the exact category/phase disposition table for every caught S2 condition | SATISFIED | jurisdiction §4 keying law, in the ruling's own order and wording; contract I.4.5; API delta §1 try-door comment |
| C-3 | `NOT-A-KNOWN-SURFACE2-CONSTRUCT` is `:protocol-refusal`/`:perform` and therefore account-domain; may not become a composite integrity alarm | SATISFIED | jurisdiction §2 table 2, S2 `:perform` row, with the reason stated in the ruling's terms |
| C-4 | split the refusal enumeration into three exact tables | SATISFIED | jurisdiction §2 Table 1 (7 Account-constructed /0 codes, all `pre-invocation`), Table 2 (native passthrough, S1 9+8 and S2 9+7), Table 3 (conditional /1 codes) |
| C-5 | enumerate every measured native code, incl. `construct-not-a-macro` and all source/expanded depth, node and octet ceilings; include future `incompatible-account-version` / `wrong-request-species` standing | SATISFIED | Table 2 lists `:construct-not-a-macro` explicitly with its ground (`surface1.lisp:209–211`) and every `:source-*`/`:expanded-*` depth/nodes/octets code on both providers, plus the never-passthrough set for totality; Table 3 carries `:incompatible-account-version` and `:wrong-request-species` at `:request` / `pre-invocation` |
| C-6 | per native code, the exact derived-standing result; no pre/post inference from phase alone where `:perform` is shared | SATISFIED | Table 2's per-code standing column, with the `:perform` split spelled out (`not-a-known-*`, `construct-not-a-macro`, `source-not-reconstructible` = `pre-invocation`; every `:expanded-*` = `invoked-no-completion-account`); jurisdiction §6 repointed; schema §5 `derived-standing` rows say "never inferred from phase alone" |
| C-7 | native passthrough refusals are account-domain but provider-owned | SATISFIED | jurisdiction §2 preamble, verbatim |
| C-8 | unexpected host and provider conditions escape unchanged | SATISFIED | jurisdiction §1 species 3 and §4 step 2; contract I.4.5 |
| C-9 | qualify "no raw host type error leaks" to Account-owned argument and constructor validation only | SATISFIED | contract I.2 inline qualification ("never conditions owned by the delegates, the head macros, or the host, which escape unchanged"), repeated at I.8; API delta §1 |

### D — architecture and identity text corrected

| # | Clause | Status | Evidence |
|---|---|---|---|
| D1 | under B/D the manifest binding lives in the composite routing request only; a successful projection cannot expose it; preserve as a genuine Candidate-C advantage | SATISFIED | docket §2-C benefit 2 (rewritten, "sharpened in R2 … added precision to a locked benefit, not a reopening"; "**B/D's completed path structurally cannot**") and §2-B canonical-representation cell; consistent with schema §§4–5 where only branch 5 carries `manifest-identity` / `manifest-version` |
| D2 | choose ONE exact occurrence-identity law for /1 | SATISFIED | contract II.3: "**a LINEARIZABLE Account-owned allocator**" — one of the three permitted arms, chosen explicitly, alternatives argued and declined |
| D3 | the allocator arm carries synchronization, one initialization per image, and a concurrent non-production tooth | SATISFIED | contract II.3 law 1 (one initialization per image, with reload behaviour) and law 2 (linearizability under arbitrary interleaving, via lock or CAS, primitive to be documented). The tooth exists and ran: `probes/probe-allocator.lisp` — mutex-guarded clean arm (8×200 = 1600 datums, all distinct, counters exactly 1..1600), a **structural** planted arm (barrier between read and write; all 8 threads mint one counter), the *same* detector shown discriminating (`ALLOCATOR-DETECTOR-DISCRIMINATES`), plus a bare-`INCF` **observation** arm that asserts no collision count. Profile `ALLOCATOR:0:12` verified `checks=12` in `final-a.log` / `final-b.log` |
| D4 | ordinary unsynchronized INCF is not an unconditional freshness mechanism — no such claim survives | SATISFIED | contract II.3 concedes the R1 defect in its own text ("the adjudication is right that an ordinary unsynchronized `INCF` is **not** an unconditional freshness mechanism… the R1 T1 claim held only under single-threaded execution, which it did not say"). Deletion hunt H4: no surviving unconditional-INCF claim |
| D5 | replace "load-time unique seed" with the weaker image-epoch/entropy claim, with no cross-image uniqueness guarantee | **GAP-1 (one residue) / otherwise SATISFIED** | Contract II.3 does the repair exactly ("the R1 phrase 'load-time unique seed' is **replaced** … **no cross-image uniqueness guarantee** … improbable is not a guarantee"). **But the exact replaced phrase survives at `probes/probe-freshness.lisp:68`** — "*Minted ONCE, at load time, from a load-time unique seed*" — in a file this seat **edited this round** (R1→R2 diff touches it), i.e. a live comment, not a filed historical record. The substance around it is compliant (the same file prints "the epoch is a seeded observation, never a guarantee" and "NO CROSS-IMAGE TEMPORAL UNIQUENESS IS CLAIMED"), so this is a phrase-level residue of an ordered replacement, not a live overclaim — and it is a one-line fix |
| D6 | state the epoch's exact encoded path component and its behavior across reload | SATISFIED **at R2** — **[SUPERSEDED (R3, marked per R3.1-E): the reload law quoted in this cell — "a fresh epoch and a counter restarted at zero" — was REVERSED by the R3 adjudication and remains reversed: allocator state, epoch, and counter initialize once and SURVIVE package/source reload. This cell is a historical record of the R2 tree, kept with this marker; note entered by JURIST]** | contract II.3 law 3: exact encoded path `("performance" <epoch-hex> <counter-decimal>)`, `<epoch-hex>` defined; reload behaviour stated twice ("a fresh epoch and a counter restarted at zero; no ordering or continuity claim spans a reload boundary"). The probe mints the same three-segment path and asserts its shape (`ALLOCATOR-CLEAN-PATH-SHAPE`) |

### E — transcript grammar closed

| # | Clause | Status | Evidence |
|---|---|---|---|
| E1 | external binding of section name, CASES and CHECKS: `POSITIVE-MATRIX:14:27`, `CONTROLS-A:0:43`, `CONTROLS-B:0:27`, `FRESHNESS:0:18` | SATISFIED | `verify-profiles.txt` lines 33–35 carry the four bindings **exactly as ruled**; the R2 additions (`SCHEMA-WITNESS:0:49`, `ALLOCATOR:0:12`) are declared beneath a comment stating the ruled four "are not touched" |
| E2 | every expected PASS assertion carries a stable external check ID; the exact ordered ID sequence is required per section | SATISFIED | `verify-grammar.txt` `ANCHOR ::: check-id`; `verify-sequences.txt` declares the full ordered stream (matrix 57, CONTROLS-A 70, CONTROLS-B 51, FRESHNESS 27, SCHEMA-WITNESS 60, ALLOCATOR 18 IDs incl. anchors); `verify-transcript.sh` compares `IDS[i]` against `SEQ[key,i]` in order and refuses on the first difference |
| E3 | the minimum bindings: matrix cases 01–14; C6-PROVIDER S1 and S2; C6-S1-STEP-1..9; C6-S2-STEP-1..9; matching END-C6-PROVIDER anchors; the exact C7/S2 species/category/phase/code assertion; freshness T1/T2/T3 anchors | SATISFIED | all present by name in `verify-sequences.txt`: `CASE-01`…`CASE-14` with matching `END-CASE-NN`; `C6-PROVIDER-S1`/`-S2` with `END-C6-PROVIDER-S1`/`-S2`; `C6-S1-STEP-1`…`-9` and `C6-S2-STEP-1`…`-9`; `C7-S2-EXACT-SHAPE-SPECIES-CATEGORY-PHASE-CODE`; `FRESHNESS-T1`/`-T2`/`-T3` with their `END-` anchors |
| E4 | do not silently ignore transcript lines — every line inside a block consumed by a declared production or refused | SATISFIED | `verify-grammar.txt` (PRODUCTION / ANCHOR / RESERVED / FALLBACK, with the RESERVED tier keeping the two fallbacks from becoming a second catch-all); `verify-transcript.sh` step (5): "line … is consumed by NO declared grammar production (nothing is silently ignored)" → refuse |
| E5 | END-OF-TRANSCRIPT must change parser state; after it, only the declared separator, closing PARCEL_TIP and CHILD-EXIT 0; reject all other trailing material | SATISFIED | `verify-transcript.sh` state 3 with the explicit "trailing material after END-OF-TRANSCRIPT" refusal; specimen 10 fires it (my run: refused exit=1) |
| E6 | reject `[FAIL]`, `PROBE-SECTION-FAIL` and unknown bracketed verdict forms independent of indentation | SATISFIED | `verify-transcript.sh` block (1), applied **before** any production, on shape not position; specimen 11 (an *inserted* re-indented `[FAIL]`, no count or ID moved) refused in my run and in `final-spec.log` |
| E7 | a live `--tip` must be exactly 40 lowercase hex digits, resolve to a commit in the explicitly supplied repository, and equal every opening and closing stamp | SATISFIED | `verify-transcript.sh` three separate validations with three separate messages; `--repo` required unless fixture mode; opening, in-body and closing stamps each compared to the tested tip; specimen 12 refused exit=2 with the resolution message |
| E8 | the synthetic all-zero tip exists only behind an explicit fixture mode and is never described as a real tested Git tip | SATISFIED | `--fixture-tip` accepts only the all-zero literal and is mutually exclusive with `--repo`; presenting it without the mode is refused (evidence arm, exit=2 in my run). Every description in `verify-transcript.sh`, `run-verifier-specimens.sh`, `verify-profiles.txt`, `verify-sequences.txt` and `probes/README.md` names it synthetic and "not a Git object / not a real tested tip" — hunt H7 found no contrary description |
| E9 | apply the same pre-creation physical output-directory boundary to `run-verifier-specimens.sh` as to `run-probe.sh`; canonicalize nonexistent components and `..` before mkdir; a rejected path leaves no directory behind | SATISFIED | the two scripts now carry byte-equivalent `resolve_intended` / `reject_if_inside_worktree` pairs, called **before** `mkdir -p` and again on the realized path; teeth 13 and 14 hand the script the two rejected spellings and assert the leftover list is empty — my run: "REFUSED exit=2, and nothing was created" for both, with `.leftovers` written as evidence |
| E10 | keep the existing seven specimens and add only the seven ruled defect-derived teeth | SATISFIED | `run-verifier-specimens.sh` `SPECIMENS` + the two path teeth = **14**, exactly 7 old (1–7) + 7 ruled new: 8 hollow CONTROLS-B with CHECKS forged to 0 · 9 S2 half of Control 6 removed with CHECKS forged to **13** (`run_suite … 13` on the live base) · 10 material after END-OF-TRANSCRIPT · 11 re-indented `[FAIL]` · 12 nonexistent Git tip · 13 outdir inside the worktree · 14 `nonexistent-prefix/..` resolving inside |
| E11 | every defective transcript exits nonzero and every rejected output path creates nothing | SATISFIED | executed at this tree: 14/14 refused, both bases accepted, both path teeth left nothing, `SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-PASS`, exit 0, worktree still raw-clean |
| E12 | nothing beyond the ruled teeth added | SATISFIED | the only extra arm is the all-zero-tip-outside-fixture-mode check, and the script labels it in place: "*Evidence for the same clause, not a fifteenth specimen*". It is evidence for E8, not a new tooth |

### F — R4 / adoption strengthened

| # | Clause | Status | Evidence |
|---|---|---|---|
| F1 | four eventual production teeth (identical native receipt object; identical native refusal object; byte-identical CD/0 output across live declaration movement; no inspector branch reads live declarations) | SATISFIED | `R4-SURVIVAL-PLAN.md` §4 family **(h)**, h1–h4, each in the ruling's own terms, h1/h2 as object identity (`EQ`) not same-species copies, h3 as `canonical-octets` equality across the Control-6 redefinition shape in an isolated child, h4 with a planted arm ("a gate that has never fired is untested") |
| F2 | the canonical cross-surface front-door ruling is part of the Adopt exit | SATISFIED | R4 §7 exit 1: "**The canonical cross-surface front-door ruling is part of the Adopt exit**" (R2 sharpening of R1's weaker "include or be followed by") |
| F3 | Surface /3 may not open merely because an implementation exists and passes; blocked until the owner explicitly names the canonical authority or explicitly accepts labelled dual authority | SATISFIED | carried **verbatim** in two places: R4 §7 exit 1 and R4 §8; lifecycle step 2 / step 7 remain consistent with it |
| F4 | remove "where publicly available" and "if adopted" from any supposedly fixed future schema; represent absence through mandatory standing datums | SATISFIED | contract II.5 native-antecedent row is now "**a mandatory field, always present**" with the standing datum `("standing" "absent-no-public-antecedent")`; the anchor row is "**adopted for the /1 mint, unconditionally**". Hunt H3: the only surviving "if adopted" is jurisdiction §5's sentence about the **/0 composite's optional anchor** — not a schema field and not a fixed future schema, so lawful |

---

## 5. The 76 / 8 / 1 naming question — this examiner's judgment

**The ruling names "the API matrix." The seat applied the correction to
`R1-COMPLIANCE-CHECK.md`'s LR5d cell, which is about
`READER-PROVENANCE-MATRIX.tsv` (85 rows), not `PROVIDER-API-MATRIX.tsv`
(178 rows). The applied reading is the honest one, and the measurement says so.**

Measured at this tree:

```
awk -F'\t' over READER-PROVENANCE-MATRIX.tsv, column 6 (measured-this-session):
  yes = 76   enumerated-only = 8   not-measured = 1   total = 85
PROVIDER-API-MATRIX.tsv: 178 data rows; header has NO measured-this-session column (grep -c = 0)
```

Three grounds, in order of weight. **(1) The figures fit exactly one artifact:**
76 + 8 + 1 = 85, which is the reader-provenance matrix's row count to the row;
the provider API matrix has 178 rows and no column that could carry a
value-exercised/enumerated-only/unmeasured tally at all. **(2) The vocabulary is
that artifact's:** "value-exercised", "enumerated-only" and "explicitly
unmeasured" are the `measured-this-session` column's own three classes, and
Locked Ruling 5d — the cell being corrected — is precisely the
preserve-which-rows-were-value-exercised ruling about that matrix. **(3) The
correction is a *correction*, and the stale text it replaces ("76 / 9
enumerated-only (plus one not-measured)") lived in that same LR5d cell** — so the
ruling was correcting a sentence whose subject was already the reader matrix.

Reading "the API matrix" literally as `PROVIDER-API-MATRIX.tsv` would make the
ruling's own numbers unverifiable against any column that exists. The lane's
reading preserves the ruling's arithmetic exactly; I record it as **correct, and
the naming as the ruling's own shorthand for the matrix whose rows those numbers
count.** One residual honesty note for the chair: the correction cell does not
*say* which matrix it means — it says "The `measured-this-session` column carries
the distinction per row" and names jurisdiction §7 and cartography §10 as the
carriers, which is unambiguous in context but never spells the filename. Naming
it would cost one word and remove the ambiguity from the record; that is a
suggestion, not a gap.

---

## 6. Deletion hunts — ordered removals that could have survived

Run at this tree over the whole lane dir including `probes/`. **Lawful
contexts** — the filed R0/R1 review and response documents, the amendment logs,
and the adjudications quoting what they ban — are named where they account for a
hit.

| # | Ordered deletion | Hits | Verdict |
|---|---|---|---|
| H1 | the impossible-route exception (`grep -rni impossible`) | jurisdiction ×3 (all inside the "is REMOVED" sentence), R1-AMENDMENT-LOG ×1 (the removal record), the ruling ×2, docket §2-B ×1 (unrelated: "public failure classification impossible without `::`") | **CLEAN** — no live exception |
| H2 | "same inspector" extension / union-by-schema-version-movement | contract II.5b ×1 (the disavowal: "is DELETED and disavowed"), docket §2-D ×1 ("is deleted — nothing enters /0's union, ever"), the ruling ×1 | **CLEAN** — disavowals only |
| H3 | "where publicly available" / "if adopted" in fixed schemas | contract II.5 ×2 (both inside the deletion attributions), R1-AMENDMENT-LOG ×1, the ruling ×1, jurisdiction §5 ×1 (the /0 composite's *optional* anchor — not a schema) | **CLEAN** |
| H4 | unconditional-INCF freshness claim | contract II.3 ×1 (the concession that it is **not** one), probes/README + `probe-allocator.lisp` (the arm that demonstrates it failing, with "no check asserts a nonzero collision count"), the ruling ×1 | **CLEAN** — no artifact claims INCF suffices |
| H5 | "first field" physical-position prose | schema head ×1 ("any earlier prose claiming a physical first field is deleted"), contract I.8b ×1 ("the R1 '(first field)' prose is deleted"), R1-AMENDMENT-LOG ×1 | **CLEAN** |
| H6 | wrapper-species recognition | every live hit states the negative ("never a wrapper species", "no wrapper species — there is none to recognize", "the composite wraps nothing"); the R0 wrapper record is recorded as **withdrawn** at contract I.9 | **CLEAN** |
| H7 | all-zero tip described as a real tested tip | every hit in `verify-transcript.sh`, `run-verifier-specimens.sh`, `verify-profiles.txt`, `verify-sequences.txt`, `probes/README.md` names it synthetic / fixture-only / not a Git object | **CLEAN** |
| H8 | "load-time unique seed" | contract II.3 ×1 (the replacement sentence), R1-AMENDMENT-LOG ×1, the ruling ×1 — **and `probes/probe-freshness.lisp:68` ×1, a live comment in a file edited this round** | **GAP-1** (see D5) |
| H9 | stale custody numbers ("21 files"; "76 / 9 …") | only inside the correction attributions and the amendment log's record of them | **CLEAN** |
| H10 | `current-at-inspection` optional live-read field | contract I.8b ×1 (the sentence stating no such field exists), plus the two R1 records of its removal | **CLEAN** |

---

## 7. The R2-specific coherence point — schema doc vs. measurement

**SATISFIED, and the detector is proven to bite.**

- `CD0-INSPECTION-RECORD-SCHEMA.md` §§2, 4.1, 4.2, 5.1, 5.2 now carry the
  **twelve identity keys as CD/0 bytes datums**, each with a visible erratum
  mark — five identity keys × two receipt branches (§4.2 inheriting via "As
  §4.1") plus `refusal-identity` × two refusal branches (§5.2 inheriting via
  "encodings exactly as §5.1"). `occurrence-tag` and `construct-identity` are
  recorded as identifier datums and are explicitly excluded from the erratum set.
- `probe-schema-witness.lisp`'s branch specs assert the same twelve as `:bytes`,
  so the doc column and the measured column agree and
  `SCHEMA-DOC-DEVIATIONS-ENUMERATED` asserts the deviation count is **zero**.
- The zero is a measurement, not a habit: the **planted arm**
  (`SCHEMA-DOC-DEVIATION-DETECTOR-BITES`) hands the same pure `deviations-in`
  function one deliberately mis-declared row (`refusal-identity` doc=`:identifier`
  measured=`:bytes` — exactly the disagreement the erratum closed) and asserts it
  reports precisely that one, while passing the agreeing row beside it. The
  detector writes to no global, so the real count is uncontaminated.
- The count is printed before it is compared (`kv "doc-deviation count"`), per
  the standing SBCL canary scar.
- Provenance is stated rather than implied: the amendment log credits the
  **probe seat's measurement** as the correction's authority and names JURIST's
  original species assignment as an unmeasured inference.

---

## 8. DEFERRED-TO-PACKER

These are the ruling's own FINAL VERIFICATION and RETURN obligations. They are
**not gaps** — they are work this examiner is forbidden to perform (the full
probe belongs to the packer at the frozen tip) or that cannot exist before the
freeze. Nine items:

1. **Run the clean bounded probe at the frozen tip** — and note that the last dev
   evidence (`final-a`, `final-b`) was taken at `c6a2738f`, before the schema
   witness gained its detector tooth: those logs read `checks=48` for the schema
   profile while `verify-profiles.txt` now declares **`SCHEMA-WITNESS:0:49`**.
   I checked the arithmetic statically — 49 check call-sites resolve in the clean
   path (39 branch proofs + 1 control + 3 predicate teeth + 3 ceiling + detector
   bite + deviations-enumerated + all-five-branches), and `verify-sequences.txt`
   declares 60 schema IDs = 49 check-IDs + 11 anchors, and `probes/README.md`
   documents 49 — so the numbers are internally coherent. **They have not been
   run together.** The frozen-tip run must produce 49, or the profile and the
   probe have parted company.
2. **Run the planted-failure mode** and require nonzero exits and **no PASS
   sentinel** (dev evidence at `final-planted.log` shows all six children exit 1,
   all five profiles refused, `SURFACE-ACCOUNT-0-PROBE-FAILED` — re-take at the
   frozen tip).
3. **Run the CD/0 schema witness** at the frozen tip.
4. **Run every old and new verifier specimen against synthetic and live bases**
   at the frozen tip (I ran all fourteen at this tree against the `final-a` live
   base; the frozen-tip run must be re-taken with the frozen tip and its own
   clean transcript).
5. **Run every output-directory refusal tooth** and keep the `.leftovers`
   evidence.
6. **Require the clean 27 / 43+27 / 18 profiles**, plus the two R2 additions
   (49 schema, 12 allocator), and **`TESTED_CONTENT_TIP = PARCEL_TIP`**, and
   **make no post-test commit**.
7. **Recompute** the R1→R2 patch, exact path inventory, citations, protected-byte
   proofs, Surface /3 absence, retired-artifact absence, bundle, manifest, and
   raw statuses.
8. **Custody record for R2.** No lane text records the five ratified post-R0
   ledger commits or the LECTOR row — a defensible scoping (they are outside the
   lane) but *asymmetric with R1*, whose Locked Ruling 4 got
   `OPENING-BASE-AND-CUSTODY.md` §6.3. The parcel's custody evidence and
   `BUNDLE-INSTRUCTIONS.md` must carry the R2 ratification as its own moment —
   and, per the R1 ruling's still-standing direction, keep the acceptances
   separate: three pre-opening housekeeping commits accepted at opening, six
   checkpoints accepted by the R1 ruling, five post-R0 ledger commits plus the
   LECTOR row accepted by the R2 ruling. **Three moments, never merged into one.**
9. **The RETURN package** — one ZIP plus exact-name SHA-256 sidecar with all
   twelve enumerated contents, and **no self-authored** contract acceptance,
   production authorization, adoption, closure, or Surface /3 opening.

---

## 9. Findings

**GAP-1 — `probes/probe-freshness.lisp:68` retains the exact phrase Section D
ordered replaced.** The line reads: *"THE IMAGE EPOCH. Minted ONCE, at load
time, from a load-time unique seed: the process id, the wall clock, and a draw
from an OS-seeded random state."* The ruling says: *"Replace 'load-time unique
seed' with the actual weaker claim: an image-epoch/entropy datum with no
cross-image uniqueness guarantee."* The contract did exactly that; the probe
comment did not, in a file the R2 seat otherwise edited this round. The claim
"unique seed" is the overclaim the ruling named, and it sits three lines above
code that gathers pid + clock + random — none of which is unique. The rest of the
file is compliant and prints the honest ceiling twice. **Repair: one comment
line, inside R2 scope, no re-run of the probe required for the text itself** —
but any edit moves the tip, so it must land before the freeze, not after.

**PARTIAL-1 (not repairable inside R2) — schema witness §8.6, Account half.**
The witness discharges "the inspector's output is not re-admitted" against all
four native admission predicates with a discriminating control arm, and prints
the Account-side half as **VOID, NOT PASSED**, because drawing the typed
`:not-an-admitted-account-object` refusal requires an Account package that
prohibition T2 forbids. This is the honest maximum under the ruling's own
constraints, disclosed at the point of measurement and in `probes/README.md`. It
is recorded as a partial so the owner sees the residue, **not** as work the seat
failed to do.

Everything else in the ruling — the six top prohibitions, the R2 scope
confinement, both custody corrections, all eleven locked acceptances, and every
enumerated clause of Sections A, B, C, D, E and F — is satisfied at
`ee4dc745`, with the satisfying text or code cited above.

---

**GAPS FOUND (1): GAP-1 — the ordered replacement of "load-time unique seed"
survives at `probes/probe-freshness.lisp:68`. One additional non-repairable
PARTIAL (schema witness §8.6 Account half, declared VOID in the transcript) is
recorded for the owner's eye, not for repair. Fix GAP-1 and the tree is ready to
freeze.**

— Claude Opus (LECTOR-2, fresh context), 2026-08-04
