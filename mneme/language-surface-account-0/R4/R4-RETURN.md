# Surface Account /0 — R4 Production-Candidate Return (integrator's record)

**Round:** R4, governed by the R4 relay. **Integrator (only source-writing
hand):** FABER (Claude Fable 5). **Date:** 2026-08-06.
**Opening base:** `2c1ac711b039528fd6a9d665d37ac2a937bf532d` (accepted
R3.3.3 tip; lane tree `3076aa17…` — both re-verified at Phase 0).
**Branch:** `surface-account-0-r4` (never pushed; no public branch exists).

This is the committed production-admission record. It is written at the
freeze, BEFORE the terminal evidence regeneration, and therefore contains
**no terminal-run outcome**: per the relay's Phase-6 ordering, the final
source tip is frozen first and all terminal evidence is regenerated against
that exact tip, outside the tree. The terminal numbers, the runtime
identity, the rerun comparison, and the integrator's recommendation are
issued in the completion report that accompanies the sealed parcel. Every
number below is a **development-run** observation at the commit where its
gate landed, reproducible by running the named gate.

---

## 1. What R4 built (the changed-path ledger)

All work under `experiments/latent-lisp/`; the complete list, matching the
Phase-0 declared budget (`R4/R4-PHASE-0-INVENTORY.md` §5, incl. its one
disclosed Phase-2 addition):

**New — production lane (`mneme/language-surface-account-0/production/`):**
`package.lisp` · `surface-account.lisp` · `load.lisp` ·
`surface-account-selftest.lisp` · `surface-account-hostile.lisp` ·
`run-hostile-profiles.sh` · `surface-account-graph-gate.sh` ·
`surface-account-disease.sh` · `surface-account-inhabited.lisp` ·
`surface-account-loader-witness.lisp` (R4.3 — the loader-finality
witnesses)

**New — documentary (`mneme/language-surface-account-0/R4/`):**
`R4-PHASE-0-INVENTORY.md` · `R4-PRODUCTION-DESIGN-LEDGER.md` ·
`extract-production.py` · `R4-RETURN.md` (this file); and, at the lane
root, `OWNER-RULING-R4-RETURN-AND-R4.3-COMMISSION.md` (R4.3 — the owner's
R4 ruling, committed byte-exact per the lane's OWNER-RULING-* convention)

**Modified (additive only; no existing row moved):**
`lisp-plus.asd` (one system + one lane-order row, appended last) ·
`mneme/verify-release.sh` (five lane rows + lane-list entry) ·
`mneme/load-order-matrix.sh` (one supported row + row-count comment) ·
`mneme/language-surface-account-0/OPENING-BASE-AND-CUSTODY.md` (the
authorized R3.3.x custody-spine section §8)

**Untouched:** every frozen probe lane file, every predecessor lane,
Surface /1 (closed by its own law), Surface /2 sources (the specimen is a
new file; zero /2 edits), Surface /3 (shut).

## 2. The production package (design ledger, condensed)

`LISP-PLUS-SURFACE-ACCOUNT` — the accepted R3.3.3 identity mechanism
extracted mechanically from the oracle (`probes/probe-identity.lisp`) by
the committed script `R4/extract-production.py`; deltas D1–D6 enumerated in
`R4-PRODUCTION-DESIGN-LEDGER.md`. Nine exports, each traced to an accepted
clause; no condition type (the accepted DEFINE-CONDITION decision
preserved); no DEFSTRUCT; one CAS writes the carrier; the disposition slot,
the total carrier walk, the total election, the ASCII counter law — all
carried verbatim. The Part-I composite front door is **not** built: the
governing reading (Phase-0 inventory §4) is stated once there and flagged
for the reviewers.

## 3. Gate inventory at the freeze (all counts derived mechanically)

| Gate | Profile | Authorized count (sentinel) |
|---|---|---|
| `surface-account-selftest.lisp` | both | `surface-account-selftest: 38 checks, 0 failures` |
| `surface-account-inhabited.lisp` | both | `surface-account-inhabited: 12 checks, 0 failures` |
| `surface-account-graph-gate.sh` | both | `surface-account-graph-gate: 9 checks passed, 0 failed` *(R4.3: GG-5/GG-5T/GG-6/GG-6T added — the one-predicate-in-substance agreement gate and its teeth)* |
| `run-hostile-profiles.sh` | full | `surface-account-hostile-profiles: 7 roles + 4 loader cases, 110 checks, 0 failures` *(R4.1: 61 role checks — post-election grew from 7 to 8 — plus ST-1/ST-2 and their two teeth ST-1T/ST-2T; every role's full named `[Hnnn]` transcript reaches evidence through the runner's output. R4.3: the four loader-finality witness cases — 44 `[Lnnn]` checks: internal-dummies 14, partial-external 10, empty-package 8, repeat-after-repair 12 — plus the witness's planted-fault tooth LW-T)* |
| `surface-account-disease.sh` | full | `surface-account-disease: 8 diseases detected, 8 controls clean` *(R4.1: D6 added — the package-existence guard reversion. R4.3: D7 — the owner's status-blind-predicate + absent-only-skip counterexample restored, caught by the loader witness; D8 — an export's defun removed, the post-load assertion fires)* |

Floors: **94/94 full (89+5), 76/76 CI (73+3)** — counted from the edited
gate table (76 `both` + 18 `full` rows), never hand-carried. The historical
`89/89` and `73/73` remain historical closure facts of Integration
Baseline /0. Umbrella: 20 principal packages, clean transcript. Load-order
matrix: 16/16 rows.

**Opening cross-check (Phase 0):** 14 real sections / 13 transcripts /
490 census IDs (the `[PASS]`-line sum is 367; the two figures are
different censuses, both reported — inventory §2).

## 4. Accepted-invariant witness map (production side)

| Accepted invariant class | Production witness |
|---|---|
| fresh initialization | selftest B; every hostile role's fresh image |
| observer behavior | contention role; stale role |
| contention | contention role (8-way genuine first-load race; allocations exactly 1..40) |
| recursive load | recursive role (`:ELECTED-BEFORE-PUBLICATION` hook; `:DEFERRED-OWNER-REENTRY`) |
| delayed global definition (the DEFGLOBAL scar) | static checks ST-1/ST-2 (exactly one carrier CAS, no once-only defining form) + stale role's pinned schedule |
| failure before publication | post-election role (provably parked observer woken-and-told; terminal image; **R4.1: the reader clause is now witnessed by the MECHANISM — the completeness-guarded loader (since R4.3: `:EXTERNAL` + `FBOUNDP` + carrier) re-signals the definitive `SURFACE-ACCOUNT/0:` refusal, with an explicit half-load-visibility check — the R4.0 form of this check was satisfied by an UNDEFINED-FUNCTION accident, STRANGER's finding**) |
| loader finality over hostile package preconditions (R4.3) | the four loader-witness cases: the owner's nine-internal-dummies counterexample repaired through the real ASDF row (end state: nine `:EXTERNAL` exports, symbol identity preserved, dummies rebound to the real implementation, carrier present); a partial external API repaired; an existing empty namesake package repaired; lawful repeated loading after repair (no regather, no allocation reset, epoch byte-identical) |
| condition immediately after successful publication | post-publication role (state final; no marker; the one-slot law) |
| unrelated lawful plist content | carrier role lawful arm (verbatim-by-EQ, tail identity) + plist-contention role |
| NIL / duplicate / foreign reserved values | carrier role arms a–c |
| odd / dotted / dotted-with-lawful-carrier / circular plists | carrier role arms d–h (each refused inside a bound, carrier EQ-unchanged, readers refused) |
| canonical ASCII counter + hostile Unicode digits | selftest E–F (DIGIT-CHAR-P defect exhibited; four ruled code points + mixed spellings refused, on real datums) |
| monotonic allocation and one gathering | selftest B/D; contention role; every role's counts |

**Depth, stated where the map is (R4.1, per LECTOR Finding 4):** the
production hostile suite pins the accepted schedules with the oracle's own
hook phases but is **floor-gate depth, not frozen-battery depth** — it has
no per-section closed grammar and no externally frozen ID sequences; its
currency is exact counts, named checks, and planted arms. The frozen
R3.3.3 battery remains the lane's deep instrument, and this map claims
correspondence of *witnessed invariants*, never parity of harness rigor.

**Every gate was shown able to fire:** the selftest's planted-fault tooth,
the graph gate's planted probes/ reference, the two static-check teeth
ST-1T/ST-2T (R4.1), and the six disease comparators (each with a green
control arm and a named failing check; `probes/` byte-verified untouched
in every replica; replicas disposable, diseased source never committed).
The disease runner's checkout-cleanliness comparison — which R4.0 shipped
in a form that could never execute on a clean checkout (LECTOR's DEFECT) —
now runs unconditionally wherever a repository exists and has its own
planted-dirt tooth, shown firing in a scratch checkout (R4.1).

## 5. The inhabited /0 + /2 specimen (Phase 5)

`production/surface-account-inhabited.lisp` — the smallest lawful specimen:
the /0-minted performance identifier is consumed as Surface /2's
occurrence-tag through the real ASDF umbrella and the real /2 public doors.
Dependence is proven, not asserted: octet-identical carry at request and
receipt; epoch linkage to the live image epoch (no literal can carry it);
two mints → two distinct /2 request identities; the species door shown
refusing a non-identifier; a lawful-reload arm. The negative control is
disease D5 (literal tag → `SA0-S2-EPOCH-LINKAGE` fails by name).
**`HALT — SURFACE-0-TO-2-INHABITANCE-CONTRACT-GAP` did not fire:** the /2
consumption point is public, documented /2 API (surface2.lisp:690–696);
no /2 semantics were added or broadened.

## 6. Frozen-oracle standing

The frozen R3.3.3 battery (13 transcripts, explicit profiles, the R3.2
verifier byte-unchanged) ran green on the R4 tree during development
(`SURFACE-ACCOUNT-0-PROBE-PASS`) and is rerun as terminal evidence at the
frozen tip, together with the verifier-teeth suite — **32 transcript
specimens plus 2 output-path teeth in one shared numbering 1–34, all
refused** (R4.1 census precision, per QUARTERMASTER F2; when quoting its
PASS sentinel, always quote the `== SUITE …` headers with it — invoked
without `--from/--tip` the runner exercises the synthetic suite only and
prints the same sentinel, EXECUTOR F3). The probe
lane's continued green is **not** counted as evidence about the product
(the disease comparators establish that separation in the failing
direction); it is counted as proof the oracle is intact.

## 7. Deviations and disclosures (complete list)

1. `load-lisp-plus.sh` was NOT edited: its package-count banner is
   computed, so the opening-round proposal's "19 → 20 banner edit" was
   unnecessary (inventory §3).
2. `R4/extract-production.py` was added to the budget at Phase 2,
   disclosed in the amended inventory §5.
3. Two harness defects were found by the gates during development and
   fixed in the harness (never in the mechanism), each documented at the
   fix site in `surface-account-hostile.lisp`: the indicator-vs-carrier
   symbol confusion in the first carrier plants, and the guarded
   completing-reload in the post-publication role.
4. The public-main and no-public-branch conditions were chair-verified
   live at opening (R4-CHAIR-BRIEF); FABER did not independently
   re-contact the network at Phase 0 (**traced, compressed**) and takes a
   read-only freeze proof at terminal-evidence time.
5. The R3.3 duplicate-upload wrapper (`9577c9a2…`) and a second R3.3.2
   wrapper (`b66b6ae1…`) were located, measured, and recorded as
   non-canonical (custody §8).

## 8. The decision path (relay's three exits)

The lawful exits are `ADOPT`, `RETIRE`, `HALT — <named defect>`; no fourth
exit exists. The integrator's recommendation is issued with the terminal
evidence in the completion report — this committed record deliberately
carries no outcome written before the evidence it would rest on.
Adoption remains an owner act; nothing here merges, pushes, or publishes.

— FABER, R4 integrator (Claude Fable 5), 2026-08-06

---

# R4.1 — the confined fix pass (after the four read-only reviews)

*Entered by FABER, 2026-08-06, on the chair's re-entry commission. The R4.0
text above is corrected in place where it described the candidate (the git
history preserves every prior wording); this section records the defect and
the pass so the historical path stays visible. No mechanism byte changed:
the extraction stays byte-reproducible from the frozen oracle by
`R4/extract-production.py` (whose only R4.1 delta is the D1 header text —
the false "final form" sentence replaced by the mid-file truth and the
guard law).*

## The convicted defect

**`R4-PRODUCTION-HALF-LOAD-CERTIFIED-BY-THE-PACKAGE-GUARD`** (STRANGER):
the initialization form is mid-file (line 1053 of 1211, column-0 top-level
form 43 of 57 at the R4.2 freeze — machine-derived by
`R4/extract-production.py` into the source header, the authoritative site,
after the R4.1 hand-written coordinate itself went stale:
`R4.1-STALE-INIT-FORM-COORDINATE`), five of the nine exports
are defined after it, and both `production/load.lisp` and the umbrella's
`lane-once` row guarded on **package existence** — so a first-load failure
left a half-loaded lane that every guard, up to
`asdf:load-system "lisp-plus"`, then certified as loaded; the committed
"final form" sentences were false; and the post-election role's reader
check was witnessed by an `UNDEFINED-FUNCTION` accident.

## What R4.1 changed (all loader/gate/document; the fix list, closed)

1. **Full-API readiness guards** — `production/load.lisp` and the umbrella
   (`lisp-plus-system:surface-account-api-complete-p`, a `(:predicate …)`
   lane-order row; `lane-once-complete` added as a mode, every
   package-guarded row untouched) now require all nine exports FBOUNDP.
   Lawful loads behave exactly as before; a half-load is re-driven into
   the mechanism's definitive refusal.  *[R4.3 correction: this R4.1
   predicate was itself defective — it discarded FIND-SYMBOL's second
   value, so nine INTERNAL fbound dummies satisfied it (the owner's
   R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API counterexample), and its
   package.lisp load was absent-only, so an existing incomplete package
   could never be repaired.  The guard since R4.3 requires `:EXTERNAL`
   status + FBOUNDP + carrier presence, repairs incomplete packages, and
   asserts completeness post-load.  See the R4.3 section below.]*
2. **Post-election role** — the accidental reader check replaced by two:
   half-load visibility (exactly the five post-init exports unbound, the
   four pre-init exports bound, the completeness predicate false) and the
   loader re-signalling `SURFACE-ACCOUNT/0:`'s terminal refusal with
   `UNDEFINED-FUNCTION` explicitly refused as a witness. Role count 7→8.
3. **Documentary truth** — the source header (via the extraction script)
   and ledger §6 now state the mid-file placement, its half-load
   consequence, and the guard law; the misleading bare-grep hint replaced
   by ST-1's exact grep.
4. **Disease runner** — the checkout-cleanliness comparison fixed
   (LECTOR's DEFECT: `-n "$GIT_BEFORE"` conflated "no git" with "clean")
   and given a planted-dirt tooth; **D6 added** (guard reverted to package
   existence → the fixed role fails by named check); a failed mutation is
   now its own comparator failure (lived: the D1 anchor went stale during
   this very pass and failed silently until guarded).
5. **Static checks** — ST-2 rebuilt as an exact defining-form-census
   whitelist (the old regex could not see a new `defvar`); ST-1/ST-2 now
   carry planted teeth (ST-1T/ST-2T). Hostile totals 62→65.
6. **Evidence completeness** — the hostile runner preserves every role's
   full named-check transcript; the selftest emits section letters in its
   IDs (`[E022]`), mapping transcript to the sections cited here;
   `lisp-plus.asd`'s `:long-description` corrected nineteen→twenty; the
   umbrella loader banner is captured into terminal evidence.
7. **Wording sweep** — the export-authorization tension presented with the
   chair's ruling (ledger §3); `identity-ready-p`'s signal case in its
   signature; D5's sourcing sentence; the invariant map's depth caveat;
   the inventory heading; the custody Members-census note; the
   32-specimens-plus-2-teeth census.

**Verified during the pass:** QUARTERMASTER F1's sharper sub-claim ("7
literal check forms vs 4 reported" in `role-post-publication`) is
factually incorrect — the role contains exactly 4 `(check …)` forms and
reports 4 (`awk` over the defun; the 7-form role is post-election, which
reports all of its checks). The remedy (full transcripts in evidence)
stands anyway, and makes the question mechanically answerable forever.

The terminal recommendation remains issued in the completion report beside
the regenerated terminal evidence at the new frozen tip.

— FABER, R4.1 fix pass (Claude Fable 5), 2026-08-06

---

## R4.2 — the coordinate made machine-derived (VERDICT's DO-NOT-SEAL, closed)

The R4.1 sentences that replaced the false "final form" claim hand-wrote
the init form's position and were stale on arrival (`R4.1-STALE-INIT-FORM-
COORDINATE`: they carried the R4.0 file's line number, mislabeled as a
form index, past a header that had grown). R4.2's fix is the lane's own
cure — *a number code can generate, code must generate*:
`R4/extract-production.py` now computes the coordinate (line of
total-lines AND column-0 top-level form of total-forms, both labeled) from
the assembled output and emits it into the source header, asserting the
placeholder count and the form's uniqueness; the hand-written sites
(load.lisp, ledger §6, this file) carry the derived truth with the header
named as the authoritative site. Byte-identical regeneration against the
frozen oracle re-confirmed after the change. Nothing else moved.

— FABER, R4.2 (Claude Fable 5), 2026-08-06

---

# R4.3 — the loader-finality repair (owner's RETURN on the readiness guard, closed)

*Entered by FABER-II (Claude Fable 5), 2026-08-06, on the owner's R4.3
commission (`OWNER-RULING-R4-RETURN-AND-R4.3-COMMISSION.md`, committed
byte-exact at the lane root).  Narrow scope held: the loader-finality
seam, its witnesses, its comparators, and the documentary records —
nothing else.  Zero mechanism bytes changed: `surface-account.lisp`'s
only delta is header-comment text emitted by `R4/extract-production.py`
(byte-reproducible from the frozen oracle; the machine-derived coordinate
moved to line 1059 of 1217 with the header growth, form 43 of 57
unchanged).  The accepted identity mechanism (owner: PASS — LOCKED), the
frozen probe lane, and Surfaces /1 /2 /3 are untouched.*

## The convicted defect

**`R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API`** (the owner's live
counterexample): the R4.1/R4.2 completeness predicate — in BOTH
`production/load.lisp` and `lisp-plus.asd` — was essentially
`(and (find-symbol name package) (fboundp symbol))`, discarding
`FIND-SYMBOL`'s second value (accessibility status).  Nine **internal**
fbound dummies in a pre-created `LISP-PLUS-SURFACE-ACCOUNT` therefore
satisfied "full nine-export completeness": the umbrella reported success
with zero public exports, no identity carrier, and the implementation
never loaded; a subsequent explicit lane load was also a no-op.  Second
half of the same defect: on detecting incompleteness, `load.lisp` loaded
`package.lisp` only if the package was ABSENT, so an existing incomplete
package could never be repaired.

## What R4.3 changed (all loader/gate/document; the owner's bullets, closed)

1. **The predicate** (both homes) now requires, for every declared name,
   `FIND-SYMBOL` status **`:EXTERNAL`** and `FBOUNDP`, plus presence of
   the identity carrier symbol (the owner's backstop clause; all nine
   exports are functions — no export is a variable, so no BOUNDP clause
   exists to need).  The two homes are ONE predicate in substance: their
   bodies are token-identical between `SA0-COMPLETENESS-PREDICATE-CORE`
   markers, enforced by new graph-gate checks GG-5 (agreement) and GG-6
   (the core requires `:EXTERNAL`/`FBOUNDP`/carrier), each with a planted
   tooth (GG-5T/GG-6T); graph gate 5 → 9 checks.
2. **The repair path**: an incomplete EXISTING package is repaired —
   `package.lisp` is applied BEFORE the implementation whether the
   package is absent or present.  The deliberate CL-semantics choice
   (DEFPACKAGE re-application = explicit export of existing symbols,
   identity preserved, dummies rebound by the implementation's DEFUNs;
   genuine name conflicts propagate = fail closed) is documented with its
   rationale in the design ledger §6.
3. **The post-load assertion**: after the repair loads, the same
   predicate is asserted and the loader signals
   `SURFACE-ACCOUNT/0: … post-load completeness assertion FAILED` if it
   does not hold — exiting the load path normally with an incomplete API
   or an absent carrier is impossible.
4. **The witnesses** (`production/surface-account-loader-witness.lisp`,
   one fresh image per case, driven by `run-hostile-profiles.sh`, full
   `[Lnnn]` transcripts in evidence): **internal-dummies** — the owner's
   counterexample verbatim, loaded through the real ASDF row; end state
   verified as the nine CORRECT `:EXTERNAL` exports bound to the REAL
   implementation (symbol identity preserved, no dummy binding survives,
   carrier present, ready, one gathering, mint from 1), with the
   subsequent explicit lane load a lawful no-op over the real lane
   (14 checks); **partial-external** — four external dummies, five names
   absent, repaired to the full real nine (10 checks); **empty-package** —
   an existing empty namesake package, the case the absent-only skip
   could never repair (8 checks); **repeat-after-repair** — idempotence
   preserved: repeated direct AND ASDF loads after repair regather
   nothing, reset nothing, epoch byte-identical, election log unchanged
   (12 checks).  Plus the witness harness's own planted-fault tooth
   (LW-T).  Hostile sentinel: `7 roles + 4 loader cases, 110 checks,
   0 failures`.
5. **Disease comparators**: **D7** restores the status-blind predicate
   (both homes) AND the package-existence skip together — the
   internal-dummies witness fails by the named export-census check,
   control clean.  **D8** removes an export's defun in a replica — the
   post-load assertion fires by its named refusal text, control clean.
   D6's mutation anchor updated to the new loader text (a stale anchor is
   its own comparator failure, the R4.1 rule).  Disease sentinel:
   `8 diseases detected, 8 controls clean`.
6. **Documentary**: every "full nine-export completeness" /
   FBOUNDP-only claim corrected to state the `:EXTERNAL` requirement
   (load.lisp and asd headers, implementation header via the extraction
   script, ledger §6/§8/§11, this file's gate table and invariant map;
   the R4.1 historical fix-list entry carries an R4.3 correction note
   rather than a silent rewrite); the owner's ruling committed byte-exact;
   `verify-release.sh`'s three affected sentinels updated (floors remain
   94/94 full, 76/76 CI — the lane still contributes exactly 5 rows).
   The post-election role's half-load-visibility check now reproduces the
   R4.3 predicate exactly (all nine `:EXTERNAL`, carrier present, five
   post-init exports unbound — the FBOUNDP clause convicts, not the
   status clause).

**Verified during the pass:** DEFPACKAGE-against-existing-package
semantics probed empirically on SBCL 2.4.6 before the design was chosen
(internal namesakes exported with identity preserved; dummy fbindings
rebound by DEFUN; no variance warning; empty-package repair clean).  The
owner's caution carried verbatim: the floor's two historical gates depend
on an obsolete private Surface /1 commit outside reconstructions lack —
NOT fixed this round; the floor is builder-ground evidence.

The terminal recommendation is issued in the completion report beside the
regenerated terminal evidence at the new frozen tip.

— FABER-II, R4.3 (Claude Fable 5), 2026-08-06
