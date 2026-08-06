# Surface Account /0 — Response to the Fresh-Context Review

**Responding seat:** JURIST (Claude Fable 5), for the return.
**Review:** `FRESH-CONTEXT-REVIEW.md` (ADVERSARY, Claude Opus, fresh
context) — a same-family cross-check, not an independent audit, on both
sides. **Date:** 2026-08-04.

**Overall disposition.** The review's verdict — RETURN FIT TO PACK AFTER
RESPONSES — is accepted. Of the eleven findings: **F1 answered
procedurally** (packing-step re-run); **F2, F3, F4, F5, F6, F7, F8, F9,
F10 conceded and fixed** in this commit, each at the size the review
charged it; **F11 docketed to the packing step**. One additional label
defect the review did not catch was found and fixed during the F2 sweep
and is disclosed under F2. **No finding changed the verdict**
(`NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED`) or any elimination
argument; F6 changed the *sizing* of one claim about the lifecycle, which
the verdict text now carries. Amendment authorship is recorded per
finding: several fixes land in CARTOGRAPHER's, FABER's, and WARDEN's
artifacts; all were entered by JURIST at the chair's direction, with
attribution notes in the amended files themselves.

---

## F1 — BLOCKING: transcripts stamped at a stale PARCEL_TIP

**Conceded on the facts; answered procedurally, per the chair's
disposition.** The review's sequencing analysis is correct: the
`final/` transcripts carry `PARCEL_TIP 21d9756f…`, the first commit on
the branch, and every later commit — including all seven governing
documents — carries no tested identity. The runner is honest
(`run-probe.sh` stamps `git rev-parse HEAD` at run time); the defect is
sequencing, and the directory name `final/` overstated it.

**Cure (no transcript is edited by hand — edited transcripts would be a
worse defect than stale ones):** the packing step will re-run
`run-probe.sh` at the final design-branch `HEAD`, after *all* commits
including this one, so that `TESTED_CONTENT_TIP = PARCEL_TIP` **by
construction**, and those transcripts — not the current ones — enter the
parcel. Consequences accepted with it: (a) the re-run will carry the
corrected probe labels (F2/F3), so the new transcripts and the matrices
will agree; (b) the docket's E1/E2/E3 line-number citations
(`probe-transcript.txt` 524–530, 383–411, 413–441, 509–523) must be
re-verified against the re-run transcript at pack time, not assumed —
the review verified they land today, and label-line changes in the
request-field and disposition lines will shift some line numbers, so
this re-check is mandatory, and the packer must adjust the cited ranges
if they moved.

## F2 — MUST-ANSWER: probe labels S2 `VERIFY-RECEIPT` `account-derived-check`

**Conceded and fixed.** `probes/probe-matrix.lisp` (S2 block) now prints
`public verify-receipt [OUT-OF-VOCABULARY:provider-recomputation]`,
matching `READER-PROVENANCE-MATRIX.tsv` row for the verifier and the
adjudication in `REFUSAL-AND-CONDITION-JURISDICTION.md` §7. The S1 arm
(`[unavailable]`) was already correct and is untouched. Labeling-only
change; no probe behavior moved. *(Original label authored by FABER;
correction entered by JURIST.)*

**The required sweep — "does any other transcript label disagree with
the matrices?" — was run, and it found one more defect the review did
not name:** the probe's disposition line printed
`occurrence disposition [occurrence-stored]` while the accessor actually
called is `expansion-receipt-disposition` — the **receipt** accessor, in
both provider blocks. The matrix labels that accessor's fact
`receipt-stored` (and the value *is* also occurrence-borne via
`EXPANSION-OCCURRENCE-DISPOSITION`, but that is not the accessor the
probe called — the label must name the bearer actually read). Fixed to
`receipt disposition [receipt-stored]` in both blocks. After these
fixes and F3's, every bracketed label the probe prints agrees with the
matrices: `receipt-stored` lines call receipt accessors,
`provider-current-declaration` lines call the trap/declaration readers,
`[unavailable]` lines name measured absences, and the one remaining
`[account-derived-check]` line (S2 stored-vs-live comparison) is
genuinely account-computed.

## F3 — MUST-ANSWER: request facts labelled `receipt-stored`; `EXPANSION-REQUEST-*` absent from the matrix

**Conceded in full — this is the return's own bearer argument turned
against it, and the review is right that "the receipt stores the same
values" would be no answer.** The request is a fourth native artifact;
the provenance label names the bearer; the bearer of
`EXPANSION-REQUEST-{GRAMMAR,PROCEDURE,POLICY}-VERSION` is the request
record. Fixes, all landed:

1. **Probe:** the six request-field lines (both provider blocks) now
   print `[OUT-OF-VOCABULARY:request-stored]`. *(FABER's lines; JURIST's
   correction.)*
2. **Matrix:** twelve `OUT-OF-VOCABULARY:request-stored` rows added to
   `READER-PROVENANCE-MATRIX.tsv` — six per provider, covering all ten
   `EXPANSION-REQUEST-*` externals per provider (the version trio and
   the datum/identity pair grouped, consistent with existing grouped
   rows; `EXPANSION-REQUEST-P` excluded as an admission instrument, not
   a fact — the matrix rows no provider's predicates). Each row carries
   the bearer ("the native request record — a FOURTH native artifact"),
   an honest measured-this-session cell (the version trio and
   construct-identity were printed in all fourteen probe cases; the
   others are enumerated externals whose values the final transcripts
   did not print), and a dated amendment note. Matrix is now 85 rows,
   verified 7 columns throughout, distribution
   30/16/12/11/6/6/2/1/1 = 85. *(CARTOGRAPHER's artifact; JURIST's
   rows, at chair direction.)*
3. **Census:** every citation of the 13-fact OUT-OF-VOCABULARY census
   updated to **25** — `CARTOGRAPHY-NOTES.md` §1 and §10 (with a full
   amendment note preserving the original count and stating the defect
   was structural, not observational), `ARCHITECTURE-DOCKET.md` E9 and
   §6b, `REFUSAL-AND-CONDITION-JURISDICTION.md` §7.
4. **Vocabulary extension:** `request-stored` added as the **fourth**
   proposed label in §7's commission-vocabulary finding, same bearer
   argument, marked as post-review.

## F4 — MUST-ANSWER: phase-only keying misfiles integrity alarms

**Conceded and the law amended — this was the most consequential catch
in the review, because it was specification a production round would
have built.** Before amending I re-counted the class/phase pairs from
the catalog source myself rather than banking the review's table
(store-not-testimony): S2 `+refusal-catalog+` measures 9 `:request` +
7 `:perform` + 7 `:expansion` + 1 `:runtime` protocol-refusal rows and
3 `:receipt` + 2 `:match` integrity-alarm rows (29); S1 shows the 3
`:integrity-alarm :receipt` rows in source and the survey's own read
(`cartography/raw-probe.txt:35–62`) records catalog size 20 with the
three integrity codes. **The review's table is confirmed.**

Amended `REFUSAL-AND-CONDITION-JURISDICTION.md` §4, per the chair's
disposition: **category first** (the public `EXPANSION-REFUSAL-CATEGORY`
reader — which was indeed already in the return's own matrix — splits
species 2 out directly: provider-owned integrity alarms are conserved,
re-signalled as the original condition object, never returned in the
refusal position, never absorbed into the composite's own alarms),
**then phase** (protocol rows only: `:request`/`:perform` account-owned;
`:expansion`, `:runtime`, and anything unanticipated macro/host-owned,
re-signalled). The catalog enumeration is now **in the document**, cited
to the survey's raw read and to this response's source re-count — the
deferral the review flagged as aggravating is withdrawn. The review's
own true-size charge is recorded verbatim in the amended section:
unsound specification, not a demonstrated live misroute (the reachable
`:match`/`:runtime` codes fire from evaluated output the composite never
evaluates; the `:receipt` codes are internal-planted-fault-only). The
docket's Candidate-B failure-jurisdiction cell and the lifecycle's
step-7 reference were updated to match.

## F5 — MUST-ANSWER: custody tolerances read as self-granted waivers

**Conceded on jurisdiction, exactly as charged: the facts were honest,
the mechanism pre-disclosed, and it was still a waiver written by the
party judged under it.** `OPENING-BASE-AND-CUSTODY.md` gains §6.2
(WARDEN's document; amendment entered by JURIST at chair direction,
attributed in the file, with the original §6.1 text left standing so the
owner sees what was written before the correction): items 2 and 4 are
relabelled **chair-authored deviations from the commission's strict
text, SUBMITTED FOR OWNER RULING in this return — not waivers in
force**; until ruled, the custody condition is stated as *technically
unmet under the strict text, with the deviation mechanism exhibited,
measured, and confined*. The review's own read-only remeasurement
(tolerances honoured in fact) is cited in the amendment as the current
evidence the owner rules on.

## F6 — MUST-ANSWER: lifecycle steps 3/6 true only by future commission text

**Conceded — "made true as design" was one notch above the evidence for
exactly those two steps, which is this lab's named framing-scale
defect.** `SURFACE-3-LIFECYCLE.md` now labels every step by mechanism
class — STRUCTURAL (1, 5, 7), PROCEDURAL (2, 4), GOVERNANCE-DEPENDENT
(3-positive, 6) — with a class table up front, per-step class headers,
the two governance-dependent steps rewritten to say the design *enables*
them and *cannot sign* them, and the honest-residue paragraph replaced
(the replaced sentence is quoted in place so the correction is visible).
`ARCHITECTURE-DOCKET.md` §6 carries the same sizing where it previously
said "all seven literal steps shown achievable." One rebuttal-shaped
observation added to the lifecycle's close, on the merits: the two
governance-dependent steps are not compellable by **any** candidate —
Candidate C's mint has exactly the same dependence on future
S3-commission text for what S3's gates *use* — so this is an inherent
limit of the charge, not a defect the recommended lineage carries and
another escapes. The verdict stands with the corrected sizing.

## F7 — MUST-ANSWER: the reserved fifth species branch

**Answered with the one sentence the review asked for: (a) — the
reserved branch is contract text only, and the /0 package's union has
exactly four members in code.** On the merits, the no-dormant-mint
principle and this lane's own gate law both favor (a): an admission
branch no object in existence can reach would ship untested and
untestable — the dead-code analogue of an unfired gate — and deferring
it whole to /1 is exactly how the mint itself is handled. Amended
accordingly: `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8 (the
reserved row now states it, and binds the /1 successor to exercise the
branch in its own gates or delete the reservation),
`PROPOSED-API-AND-INTEGRATION-DELTA.md` §1 (comment corrected),
`ARCHITECTURE-DOCKET.md` §2-D (dynamic-extension cell corrected).

## F8 — NOTE: universal built on one measured instance + dangling citation

**Conceded and fixed, both halves.** "Refuses anything else" narrowed to
the measured fact in both places (`ARCHITECTURE-DOCKET.md` Candidate-B
domain cell; `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.3 step 1): both
natives refused a **string** tag with `:OCCURRENCE-TAG-NOT-IDENTIFIER` —
one host type, not the complement of a type — with the review's own
sharpening adopted (the code is catalogued at phase `:request` in both
providers: stronger evidence, narrower claim). The dangling `§3.2`
citation is corrected to `CARTOGRAPHY-NOTES.md §3 item 2`.

## F9 — NOTE: "planted arm first" false for Control 4

**Conceded and fixed** in `probes/README.md` and the
`probes/probe-controls.lisp` header comment (comment-only; no behavior
change): every control *shows its planted arm firing*; for the
route-mutation detector the quiescent clean arm necessarily runs first,
because a detector must be shown silent before the mutation is planted.
The review's reading is adopted verbatim in substance: the probe's order
was correct; the wording was wrong. *(FABER's wording; JURIST's fix.)*

## F10 — NOTE: circular half-justification in the vocabulary extension

**Conceded and fixed.** The second sentence of the
`refusal-record-stored` cell argued from this return's design back onto
the commission's vocabulary. It is now explicitly marked *motivation,
not argument*, struck from evidential standing, with the bearer argument
— which the review confirms is sufficient alone — left as the whole of
the case. The review's verification that the extension smuggles no
standing (gate real, flagged spelling intact) is noted with thanks.

## F11 — NOTE: truncation-refusal and runner-failure evidence not captured

**Docketed to the packing step, where it belongs with F1's re-run.** The
review is right that the parcel currently holds the truncated *inputs*
but not the checker's *refusals* or the runner's nonzero exit codes —
and the review's own exercise of the checker (five refusal modes,
including a self-made mid-part-A cut) is the reviewer's evidence, not
the parcel's. The packing step must capture, at the final PARCEL_TIP:
`verify-transcript.sh` stderr and exit code for both truncated inputs;
the planted-failure run's runner exit code and its refusal line; filed
beside the transcripts under parcel item 14. No file amended for this
finding — it is a packing obligation, now recorded here and in the
chair's packing checklist by this response.

---

## What did not move

The verdict (`NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED`), all four
candidate comparisons and both elimination arguments, the STOP-cell
adjudication (the review's §3(c) cleared it), the term-grammar
elimination (§3's positive note accepted with thanks), the
repeated-performance laws, the custody *measurements*, and the claims
ceiling all stand unamended in substance. The changes this response
lands are: two labels and one bearer corrected in the probe; twelve
matrix rows and a census correction; one keying law repaired
(category-first); one jurisdictional relabeling of custody tolerances;
one claim resized (lifecycle); one dormant branch struck to contract
text; and four wording/citation repairs.

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
