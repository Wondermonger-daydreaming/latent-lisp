# REVIEW-NOTES — SCAR-TRACER semantic-fidelity trace of Process Journal /0

**Role:** semantic-fidelity tracer for the PJ0 review. This is a *trace*, not a verdict — the
signed adjudication is Fable's. Every embodiment claim below is located in the text or marked
missing. PLUMB's rule throughout: where I write "verified," the load-bearing line is quoted.

**Subject (on disk, verified):**
- `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` — 1,451 lines (matches receipt's stated 1451)
- `PROCESS-JOURNAL-0-AUTHORING-RECEIPT.md`
- `PJ0-FIXTURE-REGISTRY.sexp` — 26 `(rec …)` entries counted (matches receipt "26")

**Canon consulted:** Kernel /0 §13, §14, §15, §27.1; Architecture 0.1 §9, L10, L15; CD/0
spec (`mneme/spec/CANONICAL-DATUM-SPEC.md`) §1, §6, §10, §11 (identifier order §686–692);
PJ0-PLAN-CONCORDANCE + RELAY-TO-SOL charge.

---

## Point 1 — Fidelity to Architecture 0.1 + adopted Kernel /0; stay inside the delegated seam

**VERDICT: SATISFIED.**

The seam Kernel /0 §27.1 delegates to PJ0 (grammar, framing, byte conversion,
sequence/predecessor rules, atomicity, durability, prefix validation, torn-tail, merge
receipt, reconstruction receipt, filesystem layout) is exactly the set PJ0 §2.2 claims
(lines 74–89). The complementary line is drawn explicitly:

- §2.1 (line 70): "Kernel /0 owns event semantics, event kinds, legal transitions, process
  identity, attempt and seat identity, capability and effect meaning, **fold rules**,
  no-blind-retry law, reconstruction origin, typed semantic conditions…"
- §2.3 PJ-JUR-1 (line 93): "It MUST NOT invent a new legal transition because the bytes are
  well formed."
- §2.3 PJ-JUR-2 (line 95): a Kernel impl "MUST NOT assume newline-delimited events… or another
  byte rule not stated here" — the reciprocal non-interference.
- §17.2 (line 551): "The store MUST NOT manufacture a smaller 'lawful' prefix by skipping the
  event" — refuses to make a semantic decision that is Kernel's.

This honors Kernel §13.1 R-SYN-2 exactly (Kernel keeps *readability* as a conformance
property, delegates *framing*; §13.1 line 1057 quoted verbatim in the canon). Architecture
0.1 §9.1 append-only requirements (ordered append, predecessor linkage, commit boundary,
declared durability, prefix validation, torn-tail reporting, deterministic fold) all have PJ0
homes and none is redefined.

**Residue (for the chair, not a defect):** §16–§17 are the *one* region where PJ0 touches
fold semantics — §17.3 (line 555) "Process Journal /0 **blesses Kernel condition**
`unsupported-reconstruction`" and §16 resolvedness. This is charge-authorized (RELAY-TO-SOL
point 3: "explicit closure of kernel0 gaps 5 and 6" folded into PJ0). PJ0 is careful to frame
it as *blessing/selecting a Kernel-owned condition for the /0 case*, not defining a new one —
`unsupported-reconstruction` is a Kernel condition (Kernel §20.6 / the fold), and PJ-FOLD-4
routes the stop through the Kernel fold. The seam holds; flagging only because it is the sole
place the two jurisdictions touch.

## Point 2 — PJ-S/0 renders CD/0 (bijective) or accidentally redefines it?

**VERDICT: SATISFIED (renders, does not redefine).**

- §5 (line 143): "PJ-S/0 is a data-only grammar mapping **bijectively** to the Canonical Datum
  /0 abstract domain."
- Type-domain match: PJ0 §5.2 grammar produces `unit / false / true / integer / rational /
  string / bytes / identifier / sequence / record` (line 168–169). CD/0 §1 (lines 17–25)
  defines exactly nine families: unit, booleans, arbitrary-precision signed integers, exact
  reduced non-integer rationals, Unicode scalar strings, raw byte strings, namespaced segmented
  identifiers, ordered sequences, identifier-keyed records. **One-to-one, no extra type, no
  omission.**
- No altered equality: PJ-SYN-3 (line 210): "PJ-S/0 does not redefine Canonical Datum /0
  equality. If an implementation discovers a conflict… it MUST stop and name the conflict."
- Round-trip discipline enforced in bytes: PJ-SYN-2 (line 208): "A parser MUST decode a
  payload, re-encode it canonically, and require byte identity."
- **Identifier ordering delegates, does not rival (the F-09 concern):** §5.10 (line 204):
  "Keys are unique and appear **in Canonical Datum /0 identifier order**." PJ0 names CD/0's
  order rather than inventing a textual one. CD/0 §686–692 defines that order as unsigned
  lexicographic comparison of the identifier key's canonical *value bytes* (binary). PJ0 does
  not restate/rival it — it points to it. Correct: PJ-S/0 is a rendering of the abstract
  domain; the ordering authority stays CD/0.
- Rational/integer collapse matches CD/0: §5.5 (line 182) "A rational with denominator one
  MUST render as an integer" — consistent with CD/0's exclusion of denominator-1 rationals
  from the non-integer-rational family.

No new type is introduced; equality and order are deferred to CD/0 with an explicit
stop-and-name clause on conflict. This is rendering, not redefinition.

## Point 3 — Torn tail vs interior corruption airtight under every final-frame cut class

**VERDICT: SATISFIED.**

Three-outcome partition is clean and the ambiguous seams are handled honestly:

- **clean EOF → valid-end:** §13.1 (line 444) "EOF immediately after the LF terminating a
  valid frame, or at byte zero for an empty event file, is `:valid-end`."
- **partial header → torn tail:** §13.2 (line 450) "partial header at EOF"; Annex E-03/E-04.
- **partial payload → torn tail:** §13.2 (line 451) "complete header with fewer payload octets
  than declared"; Annex E-05/E-06.
- **missing LF (at EOF) → torn tail:** §13.2 (line 452) "complete payload at EOF with missing
  terminating LF"; Annex E-07 (line 1166 "torn tail, not corruption").
- **extra bytes / wrong byte where LF expected → interior corruption:** §13.3 (lines 469–470)
  "an unexpected byte where the frame LF is required; extra bytes between complete frames";
  Annex E-08 (line 1171 "interior corruption").

The airtight seam is the EOF-vs-byte distinction: **missing-LF-at-EOF = torn tail** (§13.2)
versus **a non-LF byte present where LF is required = corruption** (§13.3). The other subtle
seam is also closed: §13.2 (line 454) "A zero-byte truncation before the next frame is
indistinguishable from a valid journal ending at the previous frame and is classified
`:valid-end`, not torn tail" — the honest ambiguity is resolved to the conservative class, not
papered over. No-skip-forward (PJ-TERM-1, line 475) prevents plausibility-scavenging past a
corrupt frame. Airtight.

## Point 4 — CW-3 receipt loss (synced, writer dies before receipt) carries without duplicate history

**VERDICT: SATISFIED.**

The call-296 lesson (uncertain write forbids blind retry) is embodied and the recovery
procedure is exact:

- CW-3 defined: §1 matrix (line 55) synced CW-3 "full frame MUST validate on ordinary reopen…
  caller reconciles by event identity and receives prior coordinate."
- PJ-CW-3 (line 61): "CW-3 is the append-side analogue of an uncertain external write…
  Event-identity reconciliation MUST make retry idempotent."
- **Recovery procedure traced (§9.2 critical section, lines 320–331):** step 2 "look up the
  event identity"; step 3 "if identical, return the prior coordinate **without appending**."
- No duplicate: PJ-APP-2 (line 337) "Existing identity with byte-identical canonical payload
  returns `:already-committed-identical`… It MUST NOT append a duplicate frame."
- Reconstructed receipt honest: PJ-APP-4 (line 357) "The reconstructed receipt's origin is
  `:reconstructed`"; PJ-CRASH-1 (line 839) "A full frame at CW-3 is reconciled by event
  identity, not blindly appended again."
- Fixture: E-27 (line 1284–1288) "same event append after receipt loss → return existing
  coordinate; no new frame" (PJ-CW-3).

The synced/CW-3 path never fabricates a delivered success from caller memory (PJ-APP-5, line
359; Annex D stop-7, line 1116). No duplicate history.

## Point 5 — L15 survives the event-envelope design

**VERDICT: SATISFIED.**

L15 (Arch, line 1555) and Kernel §15.3 (line 1277 "A process's unaided account of its own
history is `:asserted`… A self-written narrative remains asserted wherever it is filed") are
reproduced without dilution:

- Capture fields present: §15 (lines 513–519) event SHOULD record "recorder principal; subject
  principal; capture mechanism identity; capture boundary; origin facet; evidence references;
  authority and visibility scope." Mechanism / boundary / origin all present.
- Storage-does-not-promote-origin stated: §15 (line 509) "Storage integrity does not upgrade
  epistemic origin"; PJ-WIT-2 (line 523) "Saving a self-report into `EVENTS.pj0` does not make
  the report observed."
- Self-report stays `:asserted`: PJ-WIT-1 (line 521) "A process narrative about its own history
  has origin `:asserted` unless a distinct witnessing mechanism captured the described event at
  the relevant boundary"; PJ-WIT-4 (line 527) "Later validation may raise a validation facet;
  it MUST NOT rewrite origin."
- Fixture: E-31 (line 1308) "self-report stored with strong digest → origin remains asserted";
  registry `semantic-witness-separation` (PJ-WIT-2). The concordance's own test — the
  `ABSOLUTELY-TRUE-JOURNAL.sexp` gag — is honored in spirit by E-31.

Kernel §15.4 (journal-as-default-witness *only* because it captures at the commit boundary) is
mirrored at PJ-WIT-3 (line 525). L15 survives intact.

## Point 6 — Salvage and merge keep reconstruction origin honest

**VERDICT: SATISFIED (with one residue for the chair).**

Merge — fully explicit:
- new identity + receipt, source untouched: §20 (line 614) "Merge creates a new journal and a
  transformation receipt. It never edits either source."
- origin honest: §20.5 (line 642) "The output journal's origin is **derived/reconstructed,
  never direct observation**"; PJ-MRG-1 timestamp-only prohibited.

Salvage — source untouched + new identity + receipt all present:
- PJ-SAL-1 (line 500) "The source remains byte-identical"; §14.1 (line 482) no
  truncate/rewrite/reorder/patch on open.
- PJ-SAL-2 (line 502) "The destination's frames are regenerated for its new store identity;
  frame digests therefore differ" — new identity enforced, and F-12/F-11 fixtures check it.
- Salvage receipt (lines 486–498) carries source id, source digest, valid-byte count, terminal
  ordinal/digest, tail bytes + SHA-256, destination store identity, copied event identities,
  operator/authority.
- PJ-SAL-3 (line 504) "Salvage does not claim that an excluded torn frame had no external
  consequence" — honest about the excluded tail.
- L10 preserved: §0.2 (line 37) carries L10; §19 reconstruction receipts + PJ-RCN-1 (line 604)
  "Verification of a reconstruction may change validation standing. Origin remains
  `:reconstructed`" — matches Arch L10 (line 1535) and Kernel §15.7.

**Residue:** the *salvage* receipt field list (§14.2, lines 486–498) does not include an
explicit output-origin facet, whereas the *merge* receipt (§20.5) states its output origin
`derived/reconstructed` outright. Origin honesty for salvage rides on the copied events
retaining their own origins (a verbatim prefix copy makes no new claim) rather than on a stated
output-journal origin. This does not violate L10 or §15.6 no-standing-inflation — no
asserted→observed promotion occurs — but it is an asymmetry between the two transformation
receipts worth the chair's eye. Not scored as PARTIAL because source-untouched + new-identity +
receipt + copied-event-identities are all present and no inflation path exists.

## Point 7 — no-resolved-flag and unsupported-reconstruction close kernel0 gaps 5–6 AS CHARGED (design, not accident)

**VERDICT: SATISFIED.**

Gap 5 (resolvedness fold-derived, no resolved flag) — stated as design:
- §16 (line 532) "No event, uncertain-effect record, attempt record, or journal frame **may
  carry a mutable boolean such as `:resolved #t`** whose value is treated as sole truth."
- §16 (line 534) "An uncertain effect is currently resolved only when the longest valid prefix
  contains a lawful reconciliation or supersession transformation that, under Kernel /0,
  disposes of the uncertainty."
- PJ-FOLD-1 (line 536): timeout, file age, process death, later success, missing lookup "does
  not resolve an uncertain effect by itself." Matches Kernel §13.7 fold-derived-state and
  §14.4 (supersession does not cleanse uncertainty). Fixtures E-33/E-34, registry
  `semantic-no-resolved-flag`, Annex C-17.

Gap 6 (unsupported-reconstruction for multi-unresolved occupancy in v0) — stated as design:
- §17.3 (line 555) "Process Journal /0 blesses Kernel condition `unsupported-reconstruction`
  for the /0 case where one seat has multiple non-superseded unresolved attempts and the prefix
  contains no lawful precedence, reconciliation, or supersession relation…"
- PJ-FOLD-4 (line 557) "The fold MUST stop with `unsupported-reconstruction`. It MUST NOT select
  the newest timestamp, highest ordinal, cheapest result, or most complete manifestation as
  winner." Fixture E-35, registry `semantic-unsupported-reconstruction`, Annex C-18.

Both are written as design law in the spec body (not discovered/accidental), matching
RELAY-TO-SOL point 3 and the concordance §"Kernel0 gap closure named explicitly" (lines 49–51).
Trace ledger row (line 1023) attributes both to the Fable blind-plan contribution. As charged.

## Point 8 — Moustache sweep + four F-contributions present

**VERDICT: SATISFIED.**

**Moustache sweep — clean.** Full grep of the spec for `census|kimi|emission|scoring|grader|
item|subject|language-a|substitut`:
- "experiment scoring" (line 43) — appears only in §0.3 **scope exclusions** naming what PJ0
  does NOT define. Legitimate.
- "string-item" (line 163) — an ABNF production name in the grammar. Not Language-A.
- "subject principal" (line 514) / "subject to" (line 628) — generic principal vocabulary and
  ordinary-English "subject to." Not the Language-A item/subject sense.
- "Language-A emission night" (line 1024) — a **trace-ledger provenance citation** naming the
  source of the incremental-envelope + uncertain-write lesson. Legitimate attribution, not
  vocabulary leakage.
- "seat" (lines 70, 555, 1326) — Kernel-generic (`:seat-id` is Kernel §13.2 vocabulary; seat =
  occupancy slot). Not Language-A-specific.
- No occurrence of census, kimi, grader, or Language-A item/subject/scoring language in the
  generic kernel body. Clean.

**Four F-contributions — all present:**
1. **Crash-window matrix as §1:** §1 (line 46) "The crash-window matrix — organizing exhibit,"
   the 4-window × 2-mode table (lines 50–55). Charged as "propose it as the spec's §1 exhibit"
   — landed as §1. ✓
2. **SIGKILL harness:** §30 (line 844) "Randomized SIGKILL harness," `tools/pj0_kill9_harness.py`,
   ten MUST clauses incl. seed, `kill -9`, retain stores, strict-validate, admissible-set
   compare. ✓
3. **Gaps 5–6 closure:** §16 + §17.3 (point 7 above). ✓
4. **WSL honesty clause:** §10.4 (line 380) "Host honesty, including WSL"; PJ-DUR-3 (line 382)
   "`:synced` is a declared host-contract belief, not metaphysical certainty… A green `fsync`
   return MUST NOT be narrated as independent physical proof"; fixture E-29, registry via
   Annex C-23. ✓

**Supporting counts verified on disk (PLUMB, shown not claimed):**
- Registry: 26 `(rec …)` = 3 positive + 1 truncation-family + 16 adversarial + 6 semantic
  (grep counts: adversarial 16, semantic 6). Matches receipt.
- Mutation scorecard: 6/6 mutants, each with a named killing fixture; `adversarial-payload-hash`
  legitimately kills two (`ignore-payload-hash`, `interior-as-tail`) — PJ-MUT-1 needs ≥1 killer
  per mutant, met.
- Truncation family: `fixtures/truncation/final-frame-every-byte/` holds **1235**
  `truncate-final-NNNN.pj0` files; manifest enumerates 1235; matches receipt "1235." Byte-level
  torn-tail correctness of each vector NOT independently recomputed (charge scope: structure/
  claims only) — receipt-claimed, disk-count confirmed.

---

## Summary

| # | Point | Verdict |
|---|---|---|
| 1 | Fidelity / stay in delegated seam | SATISFIED (fold-touch in §16–17 is charge-authorized gap closure) |
| 2 | Renders CD/0, not redefines | SATISFIED |
| 3 | Torn-tail vs corruption airtight | SATISFIED |
| 4 | CW-3 receipt loss, no duplicate | SATISFIED |
| 5 | L15 survives envelope | SATISFIED |
| 6 | Salvage/merge origin honest | SATISFIED (residue: salvage receipt omits explicit output-origin facet that merge states) |
| 7 | Gaps 5–6 closed as charged | SATISFIED |
| 8 | Moustache clean + 4 F-contributions | SATISFIED |

**What I could not verify inside scope:** per-vector byte correctness of the 1235 truncation
files and the 16 adversarial journals (I confirmed counts, paths, expected-status entries, and
the mutation scorecard's fixture↔mutant mapping, not each frame's recomputed digest). The
receipt's F-01…F-03 (recompute store id / genesis / frame digests independently of the authoring
tool) are the implementation-hostile reviewer's job, not this semantic trace's.

*— SCAR-TRACER (Claude Opus 4.8, 1M context), 2026-07-18*
