# Surface Account /0 — R1 Compliance Check

**Seat:** LECTOR (fresh context, read-only). **Date:** 2026-08-04.
**Question:** does the tree at branch `surface-account-0-opening`,
HEAD **`1012d3c2`** (verified by `git rev-parse HEAD`), satisfy **every clause**
of `OWNER-ADJUDICATION-R0-AND-R1-COMMISSION.md` **exactly as written**?

**Method.** The checklist was extracted from the ruling's own text, clause by
clause — not from `R1-AMENDMENT-LOG.md`, which is the repairing seat's claim and
was treated as testimony, not evidence. Every SATISFIED row points at the exact
satisfying text or code. Nothing was run except the verifier-specimen runner's
synthetic suite (permitted); the full probe was not run — that is the packer's.

**Standings used:** SATISFIED · PARTIAL · GAP · DEFERRED-TO-PACKER.

---

## 0. The four prohibitions (ruling, lines 12–15)

| # | Clause | Status | Evidence |
|---|---|---|---|
| P1 | Do not implement production code | SATISFIED | `git diff --stat bc7fbfff..HEAD`: **22 files (16 modified, 6 added)** *[R2 correction per the R1 adjudication's custody ruling — this cell originally read "21 files"; corrected in place by JURIST, no special repair commit, as the ruling directs]*, all under `mneme/language-surface-account-0/` — lane documents, TSVs, and `probes/`. No `.asd`, loader, matrix, floor, predecessor or publication path touched. Every probe file carries the `NON-PRODUCTION FEASIBILITY PROBE … not a package, not an API, not loadable` banner (`probes/README.md` head; each source header). |
| P2 | Do not merge, rebase, publish, sync, adopt, freeze, or close | SATISFIED | Three commits atop the exact R0 tip (`063e4d31`, `681c926d`, `1012d3c2`); `git branch -r --contains HEAD` returns nothing — the branch is unpushed. No adoption/closure language self-authored (see G5 and §7 below). |
| P3 | Do not open Surface /3 | SATISFIED | `mneme/` contains `language-surface-0/1/2` and `language-surface-account-0` only — no `language-surface-3`. `SURFACE-3-LIFECYCLE.md` is a pre-existing lane *design* document; docket §6 and R4 §8 both keep S/3 gated behind a future owner commission. |
| P4 | Do not add further exploratory controls or restart the architecture survey | SATISFIED | `probes/probe-controls.lisp` defines exactly `control-1 … control-5, control-7`; control 6 is its own child (`probe-control-6.lisp`). No control 8. The one new section, `FRESHNESS`, is **ordered by Section D** ("specify and test a real freshness mechanism"), not an added control — and it touches neither provider (`probes/README.md` "The freshness mechanism"). No new survey artifacts; `PROVIDER-API-MATRIX.tsv` and `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` are unchanged in the R0→R1 diff. |

---

## 1. Locked owner rulings 1–6

| # | Clause | Status | Evidence |
|---|---|---|---|
| LR1 | Accept the exact seven-head union | SATISFIED | `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` = header + 7 rows (`wc -l` = 8); contract I.1 closed manifest law over "exactly the seven unique head keys"; docket §6 verdict "over the exact seven-head union". |
| LR2 | Ratify cases 11 & 12 as lawful current composite outcomes; both admitted and requestable; native retained refusal with invoked-no-completion-account standing; no completed account; nothing removed | SATISFIED | Cited at five loci, each carrying the ruling's substance: `ARCHITECTURE-DOCKET.md` E2 and §2 (line 225); `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8 ("Why refusals are in the domain") + cross-cutting law 2; `REFUSAL-AND-CONDITION-JURISDICTION.md` §6; `TERM-GRAMMAR-DECISION.md` §5 (line 166); `R4-SURVIVAL-PLAN.md` §4(e). No head or operation removed anywhere (manifest still 7×2 = 14 matrix cases; profile `matrix POSITIVE-MATRIX:14`). |
| LR3 | Confirm elimination of pinned Surface /1 codec reuse, on the ruled ground | SATISFIED | `TERM-GRAMMAR-DECISION.md` §2, lines 83–86: "**CONFIRMED by the owner adjudication, Locked Ruling 3**" with the ruling's ground quoted verbatim ("Its public functions expose private failure classes … forbidden private reach or broad catch-all"). Carried into docket Candidate-C term-boundary row and contract Part II. |
| LR4a | Ratify the six exact Stop-hook commits as ledger-only housekeeping; "not a general waiver" | SATISFIED | `OPENING-BASE-AND-CUSTODY.md` §6.3: all six SHAs listed exactly (`33b91623 907c3fc8 4c5f0282 b58ca619 15c2c254 e6cbbf7b`); "**This is not a general waiver**" carried verbatim with its scope stated; the §6.2 submission is marked answered. |
| LR4b | Correct `BUNDLE-INSTRUCTIONS.md`: three pre-opening housekeeping commits accepted at opening; six checkpoints accepted now | **DEFERRED-TO-PACKER** | Correctly identified as a **packing artifact, not a lane file** (no `BUNDLE-INSTRUCTIONS.md` exists in the lane — confirmed by `ls`). The obligation is docketed in `OPENING-BASE-AND-CUSTODY.md` §6.3 ("two acceptances, two moments, never merged into one") and in `R1-AMENDMENT-LOG.md` "Locked Ruling 4 — recorded". Nothing further is checkable inside the tree. |
| LR5a | Extend the provenance vocabulary with the five labels | SATISFIED | `READER-PROVENANCE-MATRIX.tsv` column 4, counted over 85 data rows: `receipt-stored` 30 · `provider-current-declaration` 16 · `request-stored` 12 · `refusal-record-stored` 9 · `unavailable` 6 · `account-derived-check` 6 · `occurrence-stored` 2 · `condition-stored-reference` 2 · `provider-recomputation` 1 · `provider-derived-projection` 1. The five extended labels total **25**. Ruled standing recorded in `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 and `CARTOGRAPHY-NOTES.md` §10. |
| LR5b | `condition-stored-reference` applies to EXPANSION-CONDITION-REFUSAL; carrying relation borne by the condition, not the refusal record | SATISFIED | Matrix rows 35 (S1) and 73 (S2): label `condition-stored-reference`, bearer cell "**the signalled condition, which bears the carrying relation to the retained refusal**". Exactly two such rows. |
| LR5c | Describe the result as **25 classified TSV rows**, not 25 atomic facts | SATISFIED | `CARTOGRAPHY-NOTES.md` §10 (line 324), `ARCHITECTURE-DOCKET.md` E9 and §6b (line 371), `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 (line 255) — every occurrence of "atomic facts" in the lane's live documents is inside an explicit **never**-clause (deletion hunt 7). |
| LR5d | Preserve which rows were value-exercised and which merely enumerate public accessors | SATISFIED | The `measured-this-session` column carries the distinction per row: **76 value-exercised yes rows / 8 enumerated-only rows / 1 explicitly unmeasured row** *[R2 correction per the R1 adjudication's custody ruling — this cell originally conflated the tally as "76 / 9 enumerated-only (plus one not-measured)"; the unmeasured row ("not measured — no account manifest exists yet") is its own class, not an enumerated-only row; corrected in place by JURIST, no special repair commit]*. Named as the carrier in jurisdiction §7 and cartography §10. |
| LR6a | VERIFY-RECEIPT authoritative standing, verbatim | SATISFIED | Verbatim at five loci: matrix row 74 (`provider-recomputation`, bearer "the provider's bounded re-derivation from the receipt's stored datums", note quoting the ruling in full); `CARTOGRAPHY-NOTES.md` §10 table row; `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 table row; `ARCHITECTURE-DOCKET.md` E6; `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8b branch 3. |
| LR6b | Delete every "against live declarations" / inherited-identity-trap gloss | SATISFIED | Deletion hunt 2 below: no such gloss survives on VERIFY-RECEIPT in any live document. |

---

## 2. Section A — close the artifact algebra

| # | Clause | Status | Evidence |
|---|---|---|---|
| A1 | Door 1 may construct one sealed composite routing request | SATISFIED | Contract I.0 (adopted verbatim as a quoted block) + I.3 step 4 + I.9 (the composite routing request's fixed field list); API delta §1 Door-1 comment. |
| A2 | Door 2 delegates exactly once and returns the exact native receipt plus expanded host form | SATISFIED | Contract I.2 signature comment and **I.4 step 3–4** ("Delegate … exactly once", "Return **the exact native receipt** … Door 2 performs no projection"); API delta §1. |
| A3 | A try door returns the exact native retained refusal, or a sealed composite pre-delegation refusal where delegation never occurred | SATISFIED | Contract I.2 try-door signatures; **I.9 "Refusal artifacts … two kinds, never merged"**; API delta §1 try-door comment. |
| A4 | The composite mints no completed receipt, occurrence, expansion-account identity, or competing native-domain identity | SATISFIED | Contract I.0 bullet 4 (verbatim) and I.7 ("mints **no identity in the native domains**"); docket §6 verdict repeats the clause in full. |
| A5 | Say explicitly what it DOES construct; delete the unqualified "mints nothing" | SATISFIED | Contract I.0, "**What the composite DOES construct, said explicitly:** sealed composite routing requests (Door 1) and sealed composite pre-delegation refusal records", with the deletion stated on the face of the text. Deletion hunt 1 below. |
| A6 | The inspector input union exactly enumerated: S1 receipt, S1 refusal, S2 receipt, S2 refusal, composite pre-delegation/protocol refusal | SATISFIED | Contract **I.8** table, five numbered rows, "an explicit closed tagged union of EXACTLY FIVE members"; mirrored in docket Candidate-D row and API delta §1. |
| A7 | Admission by exact public predicates, including an Account-owned predicate for its own refusal species | SATISFIED | Contract I.8 admission column: the four providers' own `EXPANSION-RECEIPT-P` / `EXPANSION-REFUSAL-P`, plus **`account-refusal-p`** (exported in I.2 and API delta §1) for member 5. |
| A8 | Requests, occurrences, SEAT-OUTCOME, NIL, ordinary values, field-mimicking plists, and the inspector's own output are not admitted | SATISFIED | Contract I.8 "**Not admitted**" paragraph — all seven categories named, refused with typed `:not-an-admitted-account-object` via `account-protocol-refused`, "never a raw host type error". |
| A9 | Inspector returns a fixed-schema inert CD/0 record; no re-admitted semantic account species; remove idempotent self-admission and the hidden sixth branch | SATISFIED | Contract I.8: "The R0 idempotent self-admission clause is **withdrawn** … admitting its own output would have created a hidden sixth branch"; "There is **no reserved sixth entry in this union**". API delta §1 repeats it. |
| A10 | Complete fixed schema for every current branch; no optional field whose presence changes the schema | SATISFIED | Contract **I.8b**: common envelope + five per-branch field lists; "Every field listed for a branch is always present in that branch"; value-absence carried as explicit constants; the R0 "may carry live identities `current-at-inspection`" clause removed (grep: `current-at-inspection` survives only in the sentence stating its removal). |
| A11 | Omit S2 verifier output entirely from the pure inspector | SATISFIED | Contract I.8b branch 3: `verifier-availability` is a **constant standing field** (`:public-verifier-exists-output-not-carried`) and "**no verifier output field exists in any branch**"; API delta §1 "Deliberately absent: … any `VERIFY-RECEIPT` passthrough". |
| A12 | For the future /1 contract, enumerate Account-owned completed-account and retained-refusal branches separately; do not call one reserved branch the future "fifth" member | SATISFIED | Contract **II.5b** — a two-row table (branch 6 completed account, branch 7 retained refusal), each with its own Account-owned predicate and schema, and the explicit prohibition "**never described as 'the fifth member'**". Docket Candidate-D row carries the same. Deletion hunt 5 below. |

---

## 3. Section B — separate failure species

| # | Clause | Status | Evidence |
|---|---|---|---|
| B1 | Two public condition species, optionally beneath one base | SATISFIED | Contract I.2 (`account-condition` base, `account-protocol-refused`, `account-integrity-alarm`); jurisdiction §1 table + following paragraph; API delta §1. |
| B2 | An integrity alarm is never an ACCOUNT-REFUSED condition | SATISFIED | Stated as a rule (not a hope) at four loci: contract I.2 comment block and justification (4); jurisdiction §1 row 2 and §3 closing paragraph; API delta §1 comment; R4 §4(c) gate ("a handler for `account-protocol-refused` shown NOT catching a planted `account-integrity-alarm`"). |
| B3 | Native macro-owned and unexpected host conditions escape unchanged | SATISFIED | Jurisdiction §1 row 3 ("Escape unchanged, in original species. No account is minted. No substitute refusal appears."); contract I.4 step 5; proven live in `probe-controls.lisp` Control 7 S1 arm (`C7 planted: the condition escapes in its ORIGINAL SPECIES`). |
| B4 | The exact S2 caught-condition partition: category first (`:integrity-alarm` → re-signal original unchanged), then phase for `:protocol-refusal` (`:request`/`:perform` → account domain; `:expansion`/`:runtime`/unanticipated → re-signal unchanged) | SATISFIED | Jurisdiction §4 "The keying law, in order" (1. Category first, 2. Phase second, protocol rows only, everything-else-out); **executable form** in `probe-controls.lisp` `s2-jurisdiction` (lines 418–427) matching the ruling branch-for-branch, including the `(t :re-signal-original-unchanged)` default for unanticipated categories. |
| B5 | Propagate category-first-then-phase through contract, API proposal, R4 plan, lifecycle, and controls | SATISFIED | All five loci present: contract **I.4 step 5**; `PROPOSED-API-AND-INTEGRATION-DELTA.md` §1 try-door comment; `R4-SURVIVAL-PLAN.md` §4(c); `SURFACE-3-LIFECYCLE.md` line 139; `probes/probe-controls.lisp` (7 occurrences) + `probes/README.md`. |
| B6 | "Phase is the only separator" permitted only when explicitly restricted to S2 protocol-refusal rows | SATISFIED | Five surviving occurrences, **each restricted at the point of use** — see deletion hunt 4. |

---

## 4. Section C — repair the /0 → /1 lifecycle

| # | Clause | Status | Evidence |
|---|---|---|---|
| C0 | The /0 manifest is immutable; a later /1 manifest does not move the live /0 declaration | SATISFIED | Contract **I.4 step 2** ("**The /0 manifest is immutable** … no lawful movement exists inside /0") and **II.1b** heading sentence; jurisdiction §3 closing note; lifecycle step 5. |
| C1 | /0 requests remain /0 requests, accepted only by the /0 Door 2 | SATISFIED | Contract II.1b clause 1; lifecycle step 5 bullet 2. |
| C2 | /1 introduces a distinct manifest identity/version and request species | SATISFIED | Contract II.1b clause 2; II.1 opening paragraph. |
| C3 | Presenting a /0 request to /1 fails before invocation as `incompatible-account-version` or `wrong-request-species` | SATISFIED | Contract II.1b clause 3 and I.4 step 2 cross-reference; lifecycle step 5 bullet 1; jurisdiction §3 note. |
| C4 | A /0 request at the unchanged /0 door may remain valid under /0's closed law | SATISFIED | Contract II.1b clause 4 ("Nothing in /1's existence invalidates it there"); lifecycle step 5 bullet 2. |
| C5 | Any canonical-front-door supersession is an explicit owner adoption ruling, not mutable registration or silent rebinding | SATISFIED | Contract II.1b clause 5; docket §6 closing paragraph; R4 §7 exit 1. |
| C6 | /1 must still adjudicate explicit supersession vs visibly labelled dual authority | SATISFIED | Contract II.1b clause 6 and II.1; docket §2-D row and §6 table ("Account /1's opening ruling must adjudicate supersession vs labelled dual authority"); R4 §8. |
| C7 | Replace every claim that /1 manifest movement automatically invalidates a live /0 request inside /0 | SATISFIED | Deletion hunt below: the only surviving `invalidat*` strings are the replacement law itself and its explicit withdrawal ("Every R0 claim that /1 manifest movement automatically invalidates a live /0 request inside /0 is **withdrawn and replaced by this law**", contract II.1b). Lifecycle step 5 names the R0 mechanism as the error it was. |

---

## 5. Section D — repair the architecture comparison

| # | Clause | Status | Evidence |
|---|---|---|---|
| D1 | Withdraw "Candidate C buys nothing today" | SATISFIED | `ARCHITECTURE-DOCKET.md` §2-C judgment header: "the R0 sentence '**C buys nothing today**' is **WITHDRAWN** per the owner adjudication, Section D; it was an overstatement". |
| D2 | Record the four genuine benefits (mint-time stored identities; manifest-bound records; uniform schema/refusal law; potential fresh temporal occurrence identity) | SATISFIED | Docket §2-C, numbered 1–4, in the ruling's own order and terms, each with its ground (identity trap E6; manifest binding; keyword-vs-string disposition domains; II.3 freshness). |
| D3 | Then argue the actual tradeoff: no third account authority, no new grammar/audit burden, no premature supersession | SATISFIED | Docket §2-C "**The actual tradeoff, argued:**" (i)/(ii)/(iii) mapping one-to-one to the ruling's three, plus the deferral argument that all four benefits arrive with the governed /1 mint. |
| D4 | The D/B recommendation may remain unchanged if the honest comparison supports it | SATISFIED | Docket §2-C conclusion: "still not recommended now — but for the priced reasons above, not because it buys nothing"; §6 verdict unchanged and singular. |
| D5 | Part II occurrence identity: specify **and test** a real freshness mechanism, or take the structural law and disclaim temporal uniqueness. A merely asserted "fresh fact minted by Door 2" is not a mechanism | SATISFIED (mechanism arm; **specified and testable**) | Contract **II.3**: mechanism specified (performance datum = image-epoch datum minted once per image at load + per-image monotonic counter, folded into occurrence and account identities, excluded from request identity), three named falsifiable properties T1/T2/T3, and an explicit claims ceiling ("**No cross-image temporal uniqueness is claimed**"). Schema row added at II.5. |
| D5-test | …and tested | SATISFIED (in-tree), execution DEFERRED-TO-PACKER | `probes/probe-freshness.lisp` (300 lines, new) exercises T1/T2/T3 **each with its own planted arm** (reused counter → collision; perturbed request → identity moves; two equal epochs → comparator reports *not distinct*), section `FRESHNESS`, profile registered (`verify-profiles.txt: freshness FRESHNESS:0`), T3 driven by a genuinely second image (`run-probe.sh` witness role → `freshness-peer-image.txt`, epoch passed back by environment). The *run* is the packer's. |

---

## 6. Section E — repair Control 6

Nine steps × both providers, in isolated children (`probe-control-6.lisp`, its own child image per `run-probe.sh` lines 194–200).

| # | Clause | S1 | S2 | Evidence |
|---|---|---|---|---|
| E1 | capture stored grammar/procedure/policy versions | SATISFIED | SATISFIED | `C6-S1-STEP-1` (l.89) / `C6-S2-STEP-1` (l.279); `S1/S2-STORED-*-BEFORE [receipt-stored]` keys; integer-presence check. |
| E2 | capture live procedure and policy identities | SATISFIED | SATISFIED | `C6-S1-STEP-2` (l.103) / `C6-S2-STEP-2` (l.293): both the declaration readers and the receipt readers, plus all three live versions. |
| E3 | redefine all three public version declarations | SATISFIED | SATISFIED | `C6-S1-STEP-3` (l.137, → 96/99/98) / `C6-S2-STEP-3` (l.333, → 95/97/94), via `(setf fdefinition)`. |
| E4 | redefine both public procedure/policy identity declarations | SATISFIED | SATISFIED | `C6-S1-STEP-4` (l.143) / `C6-S2-STEP-4` (l.339) — both identity declarations replaced with fresh CD/0 identifier datums. |
| E5 | prove the live values actually moved | SATISFIED | SATISFIED | `C6-S1-STEP-5` (l.153) / `C6-S2-STEP-5` (l.349): two checks each — all three versions moved, both identity declarations moved — labelled "the tooth; nothing is concluded before it". |
| E6 | prove the old receipt retains all three stored versions | SATISFIED | SATISFIED | `C6-*-STEP-6`: equality with the BEFORE capture **and** disagreement with the moved live declarations. |
| E7 | prove the old receipt/source/occurrence identities do not move | SATISFIED | SATISFIED | `C6-*-STEP-7`: three checks each (receipt, source-form, occurrence). |
| E8 | mint a new receipt and prove it stores the moved versions | SATISFIED | SATISFIED | `C6-*-STEP-8`: new receipt asserted to store the exact moved integers, and to differ in identity from the old. |
| E9 | synthesize no mint-time procedure/policy identity | SATISFIED | SATISFIED | `C6-*-STEP-9`: readers equal the live declaration before **and** after; nothing recomputed into the old receipt; the reading printed explicitly. |
| E10 | For S2, label VERIFY-RECEIPT `provider-recomputation` and state its continued T demonstrates declaration-independence | SATISFIED | — | `S2-VERIFY-RECEIPT-BEFORE [provider-recomputation]` (l.330) / `-AFTER [provider-recomputation]` (l.426) and the check at l.427: "still T after every version and identity declaration moved — **DECLARATION-INDEPENDENCE**, not inherited exposure". |
| E11 | Tighten Control 7/S2: exact provider condition species, category `:protocol-refusal`, phase `:expansion`, expected refusal code — not merely an S2-owned condition with a non-NIL phase | SATISFIED | — | `probe-controls.lisp` `c7-s2-exact-shape-p` (l.450–456) asserts all five fields exactly (`LISP-PLUS-SURFACE2` / `SURFACE2-EXPANSION-REFUSED` / `:PROTOCOL-REFUSAL` / `:EXPANSION` / `:NON-EXHAUSTIVE-MATCH`); the loose R0 predicate is retained **only** so the `PLANTED-WRONG` arm (l.545–558) shows it accepting what the tight one refuses. Plus a totality pass over S2's whole public catalogue (`C7-S2-JURISDICTION-TABLE`) and a check that no `:integrity-alarm` row ever lands in the account domain. |

*Execution of these steps at the frozen tip is **DEFERRED-TO-PACKER**; what is checked here is that the code exists and asserts what the ruling requires.*

---

## 7. Section F — replace the transcript verifier law

| # | Clause | Status | Evidence |
|---|---|---|---|
| F1 | The runner must invoke the verifier with an explicit expected profile | SATISFIED | `run-probe.sh` `verify_one()` (l.247–261) passes `--profile` **and** `--tip`; three calls: `matrix`, `controls`, `freshness`. `verify-transcript.sh` **refuses** without either (l.90–91: "nothing is inferred from the transcript"). |
| F2 | Exact ordered sections — matrix: POSITIVE-MATRIX, CASES=14 | SATISFIED | `verify-profiles.txt` l.21: `matrix POSITIVE-MATRIX:14`. |
| F3 | Exact ordered sections — controls: CONTROLS-A then CONTROLS-B, CASES=0 for both | SATISFIED | `verify-profiles.txt` l.22: `controls CONTROLS-A:0 CONTROLS-B:0` (order is positional and enforced at l.197–198 of the verifier). |
| F4 | opening PARCEL_TIP | SATISFIED | Verifier l.128–135 (block opens only on `PARCEL_TIP`; must equal the told tip). |
| F5 | matching section PASS and END names | SATISFIED | l.195–196 (`secname != endname` → refuse) and l.197–198 (must also equal the profile's section for that position). |
| F6 | strict numeric CHECKS and CASES | SATISFIED | l.166 regex `CHECKS=[0-9]+ CASES=[0-9]+$`, anything else recorded as `badend` and refused at l.189–190. |
| F7 | per-section PASS-line count equal to CHECKS | SATISFIED | l.201–202. |
| F8 | zero [FAIL] lines | SATISFIED | l.187–188. |
| F9 | zero PROBE-SECTION-FAIL lines | SATISFIED | l.185–186. |
| F10 | closing identical PARCEL_TIP | SATISFIED | l.145–150 (must equal the told tip, hence each other) and l.153–154 (CHILD-EXIT before a closing tip is refused). |
| F11 | mandatory CHILD-EXIT 0 | SATISFIED | l.179–182. |
| F12 | no missing, duplicate, extra, reordered, or trailing section material | SATISFIED | extra block l.130–131; material outside a block l.141; duplicate END/PASS l.191–194; reordered/substituted l.197–198; unclosed block l.212–213; missing blocks l.214–218 (names the absent sections). |
| F13 | All tips must equal the exact non-UNAVAILABLE tested tip | SATISFIED | Verifier l.97–99 refuses `--tip UNAVAILABLE`; `run-probe.sh` l.138–143 **fails closed** when no tip is readable, so an UNAVAILABLE transcript is never produced. |
| F14 | Seven defect-forced regression specimens (loss of CONTROLS-B/Control 6; missing final CHILD-EXIT; missing closing tip; PASS→FAIL with footer PASS; PASS/END name disagreement; incorrect CASES; malformed/nonnumeric CHECKS) | SATISFIED, **and observed firing** | `run-verifier-specimens.sh` defines exactly these seven as text surgery on an accepted base, with a **mandatory control arm** (untouched base must be ACCEPTED first) and an identical-to-base guard. LECTOR ran the synthetic suite read-only: base ACCEPTED (exit 0), all seven REFUSED (exit 1) with distinct, correct reasons — e.g. specimen 1 "missing child block(s) … (absent: CONTROLS-B)", specimen 4 "1 [FAIL] line(s) present", specimen 7 "malformed END-OF-TRANSCRIPT (CHECKS/CASES must be strictly numeric)". Verdict line `SURFACE-ACCOUNT-0-VERIFIER-SPECIMENS-PASS`. |
| F15 | Add no unrelated controls | SATISFIED | The specimen script adds no Lisp control; the `PLANTED-WRONG` arm is explicitly scoped as "not an eighth control: it is the planted-wrong arm of Control 7's own S2 assertion" (`probe-controls.lisp` l.542–544). The `FRESHNESS` section is ordered by Section D, not added here. |
| F16 | Reject an output directory inside the worktree, or narrow every claim; **prefer enforcing** | SATISFIED (enforced, the preferred branch) | `run-probe.sh` l.69–115: worktree root resolved via `git rev-parse --show-toplevel` (**fails closed** if unresolvable), `resolve_intended()` computes the physical path *before* creating anything, `reject_if_inside_worktree` is applied **twice** — before creation and after realization, so a symlink pointing back in is caught. `run-verifier-specimens.sh` states it "writes nothing inside the worktree". |
| F17 | Live suite against a real clean transcript | DEFERRED-TO-PACKER | Supported (`--from … --tip …`, two-block requirement documented and guarded); the script itself prints the reminder that "The final round must run these specimens against an actual clean controls-transcript.txt". |

---

## 8. Section G — correct the R4 plan

| # | Clause | Status | Evidence |
|---|---|---|---|
| G1 | Add category-first jurisdiction and provider-integrity-alarm teeth | SATISFIED | `R4-SURVIVAL-PLAN.md` §4(c): planted arms for **both** branches — "a planted provider **integrity-alarm-category** refusal shown re-signalled in original species (the provider-integrity-alarm tooth)" and a planted macro-owned `:protocol-refusal`/`:expansion` arm — plus the two-Account-condition-species distinctness tooth. |
| G2 | Remove the stale instruction to enumerate phase vocabulary later | SATISFIED | `R4-SURVIVAL-PLAN.md` §6: "*(The R0 item (iii) — enumerate S2's refusal-phase vocabulary later — is **DELETED** per adjudication Section G: both catalogs are already enumerated, in jurisdiction §4's table…)*". The enumeration is present (jurisdiction §4 table: S1 20 rows, S2 29 rows, by phase and category). |
| G3 | Gate the exact corrected inspector union and composite-refusal path | SATISFIED | `R4-SURVIVAL-PLAN.md` **§4(g)** (new): all five members admitted and projected, including a Door-1-produced composite pre-delegation refusal admitted via `account-refusal-p` through branch 5, plus the non-admitted set — the inspector's own output named explicitly. |
| G4 | Derive release-floor arithmetic from actual verify-release rows; self-test assertions do not each become floor rows | SATISFIED | `R4-SURVIVAL-PLAN.md` §4 final bullet and `PROPOSED-API-AND-INTEGRATION-DELTA.md` §4: `89+N/89+N`, `73+M/73+M` where N/M are "the verify-release rows the lane actually adds"; "**a row is one gate invocation**, which may stand in front of many assertions"; historical counts kept historical. |
| G5 | Require an eventual adoption ruling naming the composite the canonical cross-surface front door | SATISFIED | `R4-SURVIVAL-PLAN.md` §7 exit 1: "**Adoption must include, or be followed by, an explicit owner ruling naming the composite the canonical cross-surface front door**" with the ceremonial-entry-point risk named; docket §6 closing paragraph carries the same requirement. |

---

## 9. Deletion hunts (patterns shown)

Convention: mentions in `FRESH-CONTEXT-REVIEW.md`, `RESPONSE-TO-FRESH-CONTEXT-REVIEW.md`, `R1-AMENDMENT-LOG.md` and `OWNER-ADJUDICATION-R0-AND-R1-COMMISSION.md` are **lawful** — filed history, the amendment record, and the ruling quoting what it bans. The ruling amends going-forward text.

**Hunt 1 — unqualified "mints nothing"** · `grep -rn "mints nothing\|mint nothing\|minting nothing" .`
8 hits. Composite-level occurrences in live documents: **none**. Lawful residue: the amendment log recording the deletion; the adjudication itself; five `probe-controls.lisp` check labels about *providers* refusing an impostor ("S1 Door 2 REFUSES the impostor and mints nothing") — measurements of native doors, not claims about the composite; and `REFUSAL-AND-CONDITION-JURISDICTION.md` l.70, whose subject is **integrity alarms** ("Alarms … signal `account-integrity-alarm` … and mint nothing") — a narrower and true claim about the alarm path, not the banned composite-wide sentence. **CLEAN.**

**Hunt 2 — "against live declarations" / identity-trap gloss on VERIFY-RECEIPT** · `grep -rni "against live declaration\|identity trap\|identity-trap" .`
No surviving gloss. `probes/README.md` l.268 and `probe-control-6.lisp` l.419–420 carry the phrase **inside its own withdrawal** ("is WITHDRAWN under the owner's ruling", "no identity-trap reading of it survives in this directory"). `CARTOGRAPHY-NOTES.md` §7 and `ARCHITECTURE-DOCKET.md` E6/l.148 use "the identity trap" for the **separate, measured E6 fact** about `EXPANSION-RECEIPT-PROCEDURE-IDENTITY`/`-POLICY-IDENTITY` returning live declarations — a measurement the ruling ratifies rather than deletes (E6 now states Ruling 6's standing verbatim). **CLEAN.**

**Hunt 3 — "buys nothing"** · `grep -rn "buys nothing\|buy nothing" .`
4 hits: the adjudication, the amendment log, and docket l.139/l.182 — both of which are the withdrawal ("is WITHDRAWN per the owner adjudication"; "not because it buys nothing"). **CLEAN.**

**Hunt 4 — unrestricted "phase is the only separator"** · `grep -rn "only separator" .`
5 live occurrences, **each restricted at the point of use**: `ARCHITECTURE-DOCKET.md` E4 ("among S2's `:protocol-refusal` catalog rows, **and only among those**"); `REFUSAL-AND-CONDITION-JURISDICTION.md` §4 ("among S2's `:protocol-refusal` catalog rows, **and only among those rows**"); `probe-matrix.lisp` l.376 ("**RESTRICTED TO S2 PROTOCOL-REFUSAL ROWS** the PHASE field is the only separator"); `probes/README.md` l.245 ("survives only in its restricted form"); `probe-controls.lisp` l.414 (the meta-statement of the restriction). **CLEAN.**
*Note, not a defect:* `R1-AMENDMENT-LOG.md` l.66 says the sentence "survives in exactly two places" — that count covers JURIST's jurisdiction only; three further restricted occurrences live in the probe seat's files. The ruling permits the restricted form anywhere, so this is a stale count in the log, not a violation.

**Hunt 5 — "fifth member" for the reserved /1 branch** · `grep -rni "fifth member\|fifth\b" .`
No occurrence applies the phrase to a /1 branch. `PROPOSED-API-AND-INTEGRATION-DELTA.md` l.55/62 use "the fifth" for the **composite pre-delegation refusal** — which the ruling and contract I.8 make the correct fifth member. Contract l.607–608 and docket l.192 carry the explicit prohibition. Remaining hits are the R0 review/response (history), and `(fifth s)` / "positional list accessors (`first`…`fifth`)" in probe and matrix text — the Lisp accessor, unrelated. **CLEAN.**

**Hunt 6 — `OUT-OF-VOCABULARY:` surviving as a current label** · `grep -rn "OUT-OF-VOCABULARY" .`
Zero occurrences as a label. `READER-PROVENANCE-MATRIX.tsv` column 4 holds bare labels only (counts in LR5a); the three matrix hits are inside the *notes* column recording provenance of the label ("was OUT-OF-VOCABULARY:refusal-record-stored in R0"). `CARTOGRAPHY-NOTES.md` §10 and jurisdiction §7 each keep exactly one historical note; docket E9 and §6b likewise. Remaining hits are the R0 review/response. **CLEAN.**

**Hunt 7 — "25 atomic facts"** · `grep -rn "atomic fact" .`
Every live occurrence is inside a **never**-clause (cartography §10, docket E9 and §6b, jurisdiction §7). **CLEAN.**

**Hunt 8 — /1 movement invalidates a live /0 request** · `grep -rni "invalidat" *.md *.tsv`
Surviving strings are the replacement law and its withdrawal: "does not move, replace, or **invalidate** the immutable /0 manifest" (contract II.1); "Nothing in /1's existence **invalidates** it there" (II.1b clause 4); the explicit withdrawal sentence (II.1b closing); lifecycle l.107. **CLEAN.**

**Hunt 9 — `current-at-inspection` optional live-read fields** · `grep -rn "current-at-inspection" .`
Two hits, both the statement of its removal (contract I.8b l.308; amendment log). **CLEAN.**

---

## 10. DEFERRED-TO-PACKER

Obligations that genuinely belong to packing/final-run and are not checkable inside the source tree:

1. **Locked Ruling 4** — the `BUNDLE-INSTRUCTIONS.md` correction (three pre-opening housekeeping commits accepted at opening; six checkpoints accepted now — two acceptances, two moments). Docketed at `OPENING-BASE-AND-CUSTODY.md` §6.3.
2. **FINAL VERIFICATION** — at the final R1 tip: run the repaired clean probe; run the planted-failure mode; run every verifier-regression specimen (including the **live** suite via `--from controls-transcript.txt --tip <tip>`); require all intended refusals nonzero; require no PASS sentinel from the planted run; require the repaired clean transcripts accepted under their explicit profiles; require `TESTED_CONTENT_TIP = PARCEL_TIP`; **make no post-test commit**.
3. **Recomputation** — all matrices, citations, path inventories, patches, protected-byte proofs, Surface /3 absence proof, retired-artifact absence proof, and manifest.
4. **RETURN** — one R1 ZIP plus exact-name SHA-256 sidecar with the twelve enumerated contents (amended documents; corrected matrices and provenance ruling; repaired probes and verifier; final clean and planted transcripts; every adversarial specimen with its refusal/exit evidence; exact R0→R1 diff and path inventory; custody/frozen-byte/absence/raw-status evidence; reconstructed Git bundle and manifest).
5. **Transcript anchors** — `probes/README.md` guarantees the R1 anchors (`END-CASE NN`, `C6-*-STEP-*`, `C7-S2-*`, `FRESHNESS-T*`) exist in the replaced transcript format; the *documents* cite them, and the packer's clean run is what makes each citation resolvable.

---

## 11. Notes carried, none of them defects

- `R1-AMENDMENT-LOG.md` §B undercounts the surviving restricted "phase is the only separator" occurrences (two claimed, five present, all lawful). Jurisdictional, not substantive.
- The `FRESHNESS` probe section is new. It is authorized by **Section D**, not by Section F, and does not offend "add no unrelated controls" (Section F's clause, about the verifier's teeth).
- The ruling's term "ACCOUNT-REFUSED" is realized in the tree as the named species `account-protocol-refused`; the prohibition ("an integrity alarm is never one") is preserved exactly.
- The tolerances at `OPENING-BASE-AND-CUSTODY.md` §6.1 items 2 and 4 remain SUBMITTED-not-waived except for the six commits Ruling 4 ratifies; §6.3 correctly limits the ratification to those six.

---

## VERDICT

**COMPLIANT AND READY TO FREEZE.**

Every checkable clause of the ruling — the four prohibitions, Locked Rulings 1–6, and Sections A (12), B (6), C (8), D (6), E (11), F (17), G (5) — is SATISFIED against exhibited text or code, with no GAP and no PARTIAL. Nine deletion hunts came back clean: no banned sentence survives as going-forward text; every residue is either the filed R0 history, the ruling quoting what it bans, or the phrase inside its own explicit withdrawal. The five DEFERRED-TO-PACKER items above are the final-run and packing obligations, all correctly docketed in the tree.

*This is a compliance check of the ruling's letter against the tree at `1012d3c2`. It is not an acceptance, an adoption, a design endorsement, or a substitute for the owner's terminal contract ruling. LECTOR ran nothing but the verifier-specimen synthetic suite, edited nothing, and committed nothing.*

— Claude Opus (LECTOR, fresh context), 2026-08-04
