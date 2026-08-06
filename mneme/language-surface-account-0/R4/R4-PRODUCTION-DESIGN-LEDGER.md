# Surface Account /0 — R4 Production Design / Correspondence Ledger

**Round:** R4. **Integrator:** FABER (Claude Fable 5). **Date:** 2026-08-06.
**Governing text:** the R4 relay (its "Governing acceptance" list is the
frozen executable contract; the accepted probe `probes/probe-identity.lisp`
at tip `2c1ac711…` is the executable oracle). The normative shape text for
epoch/counter/allocator laws is contract §II.3 as normalized through
R3-B/R3.1-B/R3.2-B/R3.3-A/R3.3-C. See `R4-PHASE-0-INVENTORY.md` §4 for the
governing reading (identity mechanism, not the Part-I composite).

This ledger answers the relay's Phase-1 questions in order, then gives the
complete probe→production correspondence table.

---

## 1. The authoritative production package

`LISP-PLUS-SURFACE-ACCOUNT` — defined in `production/package.lisp`, loaded
before the implementation by `production/load.lisp` and by the ASDF system.
No nicknames. `(:use #:common-lisp)` only; every CD/0 reference is a
qualified external symbol (`lisp-plus-cd0:` — never `::`, never `:use` of a
provider), the discipline this lane has enforced since R0.

## 2. Symbol kinds — the complete public surface (9 exports)

| Export | Kind | Signature / value |
|---|---|---|
| `initialize-image-identity` | function | `() => :gathered \| :observed \| :deferred-owner-reentry` (or signals) |
| `identity-ready-p` | function (predicate) | `() => boolean`; **signals on a malformed or foreign carrier** — it routes through the one adjudicating reader, so a rejected carrier refuses every reader identically (the hostile carrier role asserts exactly this) |
| `image-epoch-hex` | function | `() => string` (exactly 32 lowercase ASCII hex); signals if no published state |
| `image-epoch-datum` | function | `() => CD/0 bytes datum`; signals if no published state |
| `epoch-gatherings` | function | `() => integer` (0 before initialization, 1 after, forever) |
| `election-count` | function | `() => integer` (image-wide election log; 1 for the life of a lawful image) |
| `mint-performance-identifier` | function | `() => (values identifier-datum counter)` |
| `performance-identifier-shape-p` | function (predicate) | `(datum) => boolean` |
| `lawful-counter-text-p` | function (predicate) | `(object) => boolean` |

No exported variable, macro, constant, structure, or condition type. Every
refusal is a plain `CL:ERROR` with an exact greppable text — **deliberately
not `DEFINE-CONDITION`**, preserving the accepted decision (relay structural
conclusion 4: the concurrent layout/redefinition scar; this source is loaded
concurrently by design). Internal symbols keep the probe's `sa0-` names so
the correspondence below is line-auditable.

`lawful-epoch-text-p` remains **internal** (used by
`performance-identifier-shape-p`; no accepted clause makes epoch-text
admission a caller-facing operation — callers receive epochs only from
`image-epoch-hex`, which is lawful by construction).

## 3. Which contract clause authorizes each export

| Export | Authorizing clause (relay "Governing acceptance" unless noted) |
|---|---|
| `initialize-image-identity` | "one process-wide identity state"; "bounded owner re-entry"; "contention among initializers and observers"; "post-election failure closure"; "genuine recursive LOAD" — the mechanism's one entry, the probe's `sa0-initialize-image-identity` made addressable |
| `identity-ready-p` | "one process-wide identity state" + "mutually exclusive state/failure publication through one disposition slot" — the state's existence is the contract's central observable |
| `image-epoch-hex` / `image-epoch-datum` | "exactly one epoch gathering" + §II.3.3 (the one textual projection; the epoch datum); readers of the published state, failing closed when none exists |
| `epoch-gatherings` | "exactly one epoch gathering" — the invariant made observable (the probe's tally, verbatim semantics incl. its stated cell-scoped caveat) |
| `election-count` | "no election … after invalid-carrier refusal"; the once-only law (R3.3-A clause 5) — the replaced-carrier-surviving tally the probe keeps deliberately off the carrier |
| `mint-performance-identifier` | "monotonic account allocation" + §II.3.3 (counter starts 0, first allocation 1; the one shared constructor; the exact encoded path `("performance" <epoch-hex> <counter-decimal>)`) |
| `performance-identifier-shape-p` | "canonical ASCII decimal counter syntax" + "rejection of non-ASCII and mixed-script decimal impostors" + the locked epoch-hex predicate — the shape law as an admission instrument |
| `lawful-counter-text-p` | R3.3-C verbatim: one or more ASCII characters from `0123456789`, first from `123456789`; explicit `FIND`/`EQL` membership; `DIGIT-CHAR-P`, Unicode properties, locale classification, and `PARSE-INTEGER`-as-admission rejected by name |

**The Part-II tension, presented rather than silently crossed (R4.1, per
LECTOR Finding 1 and the chair's ruling).** The §II.3.3 citations above sit
textually under contract Part II's header — *"for the governed /1
successor; returned now, implemented never in this round"* — and the
no-dormant-mint rule says none of Part II is implemented in /0. Three of
the exports (`image-epoch-hex`, `image-epoch-datum`,
`mint-performance-identifier`) therefore rest on clauses whose surrounding
header, read alone, forbids them at /0. **The chair has ruled the exports
AUTHORIZED**, on two grounds this ledger now states instead of assuming:
(1) the R4 relay is the later governing text and freezes *"monotonic
account allocation"* and the counter/epoch laws as an executable contract
for THIS round's production package — the same supersession already
disclosed for Part I in the Phase-0 inventory §4, owed equally here; and
(2) §II.3.3's own normative shape stamps the performance identifier with
**/0's namespace** (`("lisp-plus-surface-account")`) while §II.2 gives /1
a distinct package — a pre-existing contract inconsistency this round
inherited, cutting toward /0 ownership of the minted datum. The mint is
not dormant (the inhabited specimen consumes it). The contract candidate
is superseded on this point by the relay; nothing else of Part II is
implemented.

**No phantom exports:** every export above is exercised by the production
self-test and/or the inhabited specimen through the public package. Nothing
from contract Part I (doors/inspector/condition species) is exported — none
of it is in the frozen executable contract, none of it exists in the oracle,
and improvising it is exactly what Phase 1 forbids. Nothing from Part II
beyond the accepted mechanism is exported (no occurrence/account identity
basis constructors: they served the probe's freshness witness as
probe-local stand-ins; no accepted clause makes them production API, and a
dormant public mint surface is the no-dormant-mint rule's own target).

## 4. Probe → production correspondence (complete)

Extraction rule: **verbatim mechanism, minimal delta.** Internal names are
unchanged (`sa0-…`), now interned in `LISP-PLUS-SURFACE-ACCOUNT` instead of
`CL-USER`. The deltas, exhaustively:

| # | Delta class | Exact difference | Why nonsemantic |
|---|---|---|---|
| D1 | packaging | `(in-package #:cl-user)` → `(in-package #:lisp-plus-surface-account)`; file banner rewritten from "NON-PRODUCTION FEASIBILITY PROBE" to the production header | comments + home package of the same mechanism; all carrier/hook/log symbols now live in the production package, so the probe and the product can coexist in one image without either touching the other's carrier |
| D2 | refusal text prefix | `"SA0 PROBE: …"` → `"SURFACE-ACCOUNT/0: …"` in error formats | refusal *boundaries* and sentence bodies preserved; only the prefix names the product instead of the probe; production teeth assert the new prefix |
| D3 | mutex/waitqueue names | `"sa0-probe-…"` → `"sa0-production-…"` name strings | diagnostic labels only |
| D4 | export wrappers | `initialize-image-identity`, `identity-ready-p`, `image-epoch-hex`, `image-epoch-datum`, `epoch-gatherings`, `election-count` are the probe functions under their export names (renames or one-line wrappers); `mint-performance-identifier`, `performance-identifier-shape-p`, `lawful-counter-text-p` keep their probe names and are exported | addressability, not behavior |
| D5 | omissions | probe-local stand-in constructors omitted: `ident-key`, `ident-domain`, `occurrence-identity-basis`, `account-identity-basis`, `identity-projection`, `identity-datum`, `identity-hex`, `datum-hex`, `performance-identifier-from-texts`, `performance-counter-of`, `performance-epoch-of`; also the three witness-only state readers `sa0-epoch-octets-value`, `sa0-performance-mutex`, `sa0-performance-counter` and the five `define-symbol-macro` historical spellings | the identity-basis constructors are the probe file's own stand-ins ("probe-local stand-ins carrying the roles the contract names" — its boundary note); the symbol macros are labelled by the oracle as existing solely so the two witness files kept their pre-R3.3 spellings; **the three state readers carry no such label in the oracle — their witness-only status was established by call-site census** (R4.1 correction, per LECTOR Finding 7: they are called only from `probe-allocator.lisp` and `probe-init-schedule.lisp`, never from the mechanism); none of these is in the acceptance list; the frozen battery still exercises them through the untouched probe file |
| D6 | kept verbatim | everything else — the carrier (`symbol-plist` of an interned symbol, established by interning, always bound, written by exactly ONE CAS in the source), `sa0-scan-reserved` (the five-face total walk, EQ visited set), `sa0-adjudicate-reserved`, `sa0-install-carrier` (total election, tail-identity preservation), `sa0-stand-for-election` (UNWIND-PROTECT before election; claimed-flag armed before the CAS; failure token CAS-from-NIL into the SAME disposition slot; broadcast in cleanup), `sa0-initialize-image-identity` (outcome table incl. terminal failure and EQ-owner re-entry), the state/cell simple vectors (NO DEFSTRUCT — the OLD-LAYOUT scar), the test gate (`sa0-identity-test-gate`, hook on a second interned symbol's plist, one GET + NIL test on the lawful path), the election log (`sa0-note-election`/count on a third interned symbol), `sa0-gather-epoch-octets` (16 octets from `/dev/urandom`, short read = error), `sa0-octets-to-lower-hex`, `allocate-performance-counter` (mutex; increment precedes read), `performance-identifier` (the one constructor), the ASCII alphabet parameters and predicates, the load-time `(sa0-initialize-image-identity)` call, and the `*sa0-identity-source*` DEFPARAMETER (now the production source path) | the accepted mechanism itself |

Function-level map (probe name = production internal name; ✱ = exported, under the §2 name):

`sa0-gather-epoch-octets` · `sa0-octets-to-lower-hex` ·
`make-sa0-identity-state` · `sa0-identity-state-p` · `sa0-state-*` accessors ·
`make-sa0-identity-cell` · `sa0-make-init-failure` · `sa0-init-failure-p` ·
`sa0-cell-*` accessors · `sa0-cell-state` · `sa0-cell-failure` ·
`sa0-lawful-cell-p` · `sa0-identity-test-gate` · `sa0-reject-carrier` ·
`sa0-scan-reserved` · `sa0-adjudicate-reserved` · `sa0-carrier-cell` ·
`sa0-published-state` · `sa0-identity-ready-p`✱ · `sa0-require-state` ·
`sa0-epoch-gatherings`✱ · `sa0-note-election` · `sa0-election-count`✱ ·
`sa0-install-carrier` · `sa0-stand-for-election` ·
`sa0-initialize-image-identity`✱ · `sa0-epoch-hex`✱ · `sa0-epoch-datum`✱ ·
`allocate-performance-counter` · `performance-identifier` ·
`mint-performance-identifier`✱ · `lawful-epoch-text-p` ·
`ascii-decimal-char-p` · `ascii-decimal-nonzero-char-p` ·
`lawful-counter-text-p`✱ · `performance-identifier-shape-p`✱
(the probe's symbol macros `*image-epoch-hex*` etc. are NOT carried —
they existed so the two witness files kept their historical spellings, a
need production does not have).

## 5. Where the stable carrier symbol lives

`lisp-plus-surface-account::sa0-identity-carrier` — interned in the
production package by the reader at load of the implementation file;
distinct from the probe's `cl-user::sa0-identity-carrier`, so the frozen
battery and the product never share a carrier. Same for the test-gate
symbol (`…::sa0-identity-test-gate`) and the election log
(`…::sa0-identity-election-log`). The production source contains exactly
ONE form writing `(symbol-plist 'sa0-identity-carrier)` — the election CAS —
mechanically checkable by grep, exactly as the oracle's clause 4 requires.

## 6. Compile time / load time / execution time

- **Compile time:** nothing. The umbrella loads source in place (no FASL,
  per lisp-plus.asd's design); `asdf:compile-op` on the lane performs no
  file compilation (load-entrypoint system).
- **Load time:** `package.lisp` defines the package; `surface-account.lisp`
  defines functions and calls `(initialize-image-identity)` **mid-file**
  (line 1059 of 1217, column-0 top-level form 43 of 57 at the R4.3
  freeze — the oracle-faithful placement, carried verbatim under D6; the
  R4.0 text here falsely said "as its final form", corrected in R4.1 after
  STRANGER's finding; the R4.1 replacement then hand-wrote a coordinate
  that itself went stale, so since R4.2 the coordinate is
  **machine-derived**: `R4/extract-production.py` computes it from the
  assembled output and emits it into the source header, which is the
  authoritative site). Consequence: five public exports are
  defined AFTER the initialization form, so a load that fails at
  initialization leaves the package present with those five unbound —
  which is why **no loader of this lane may guard on package existence**,
  and (R4.3, the owner's counterexample
  `R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API`) **no loader may guard on
  FBOUNDP alone either**: the R4.1/R4.2 predicate discarded
  `FIND-SYMBOL`'s second value, so nine INTERNAL fbound dummies in a
  pre-created namesake package satisfied "completeness" and the umbrella
  certified a lane with zero public exports, no identity carrier, and the
  implementation never loaded. `production/load.lisp` and the umbrella row
  therefore guard on **external-API completeness**: every declared name
  present with `FIND-SYMBOL` status `:EXTERNAL` **and** `FBOUNDP` (all
  nine exports are functions; none is a variable, so no `BOUNDP` clause
  exists to need), plus presence of the identity carrier symbol.  On
  incompleteness the loader **repairs** rather than skips (§ below), and
  **asserts the same predicate after the load, failing closed** — exiting
  the load path normally with an incomplete API or an absent carrier is
  impossible (the accepted load-time behavior is otherwise unchanged:
  first load gathers; reload observes; recursive load inside an
  unfinished initialization defers; a failed image is terminal).

  **The repair path and its CL semantics (R4.3, documented as the owner's
  commission requires).** When the predicate finds the package
  *present-but-incomplete* (a half-load; a pre-created namesake with
  internal, partial, or dummy symbols; an empty namesake package), the
  loader applies `package.lisp` **before** the implementation — the R4.2
  absent-only skip is exactly what made an incomplete package
  unrepairable.  The chosen lawful path is **re-application of the
  DEFPACKAGE, i.e. explicit export of the existing symbols**, not refusal
  on sight: per CLHS `DEFPACKAGE`/`EXPORT` semantics, `:export` on an
  existing package finds (or creates) symbols with the declared names —
  **preserving the identity of existing namesake symbols** — and exports
  them; loading the implementation then rebinds **every** export to the
  real mechanism through its top-level DEFUNs, so pre-created dummies
  cannot mask real definitions (a name a dummy holds is a name the
  implementation unconditionally redefines; verified empirically on SBCL
  2.4.6: identity preserved, dummies rebound, no variance warning).  The
  two genuinely conflicting situations both **fail closed**: a name
  conflict from a package USING the namesake package signals from
  `EXPORT`/`USE-PACKAGE` and propagates out of the loader; and any load
  that completes with the API still incomplete (e.g. a damaged
  implementation) is refused by the post-load assertion.  Silent
  acceptance of wrong definitions has no path: FBOUNDP-level dummy
  *content* is not detectable by any loader guard, but a **completed**
  repair has provably rebound all nine names, and an **uncompleted**
  repair signals.  Witnesses: the four loader-finality cases in
  `production/surface-account-loader-witness.lisp` (internal-dummies —
  the owner's counterexample verbatim, through the real ASDF row;
  partial-external; empty-package; repeat-after-repair), teeth-checked by
  disease comparators D7 (status-blind predicate + absent-only skip
  restored → the witness fails by named check) and D8 (an export's defun
  removed → the post-load assertion fires).

  **One predicate in substance, two forced textual homes (R4.3).**
  `production/load.lisp` must stay loadable with no ASDF present, and the
  umbrella row needs the predicate *before* `load.lisp` runs, so the
  predicate body is forced to exist in both files.  The two copies are
  kept token-identical between `SA0-COMPLETENESS-PREDICATE-CORE` markers,
  enforced statically by graph-gate checks GG-5 (agreement, with tooth
  GG-5T) and GG-6 (the core requires `:EXTERNAL`, `FBOUNDP`, and the
  carrier clause, with tooth GG-6T).
- **Execution time:** everything else — allocation, minting, predicates,
  observers.

## 7. Recursive load

Preserved exactly: a same-thread recursive `LOAD` of the implementation
source during an unfinished initialization is detected by `EQ` on the cell's
owner thread and returns `:deferred-owner-reentry` without gathering,
publishing, or claiming ready; the outermost load owns the sole transition
to ready. A sequential reload observes the established state (same epoch,
counter continues). Witnessed in the production hostile gates.

## 8. How the umbrella reaches the component

- New ASDF system `lisp-plus/surface-account` in `lisp-plus.asd`:
  load-entrypoint style, **no `:depends-on`** (the lane is CD/0-only;
  declaring a cd0 edge is the exact false-edge defect R1 of IB0 removed) —
  `production/load.lisp` guard-loads CD/0 itself, then the package, then
  the implementation — **guarded on EXTERNAL-API completeness: every
  declared export `:EXTERNAL` and `FBOUNDP`, identity carrier present —
  never on package existence and never on FBOUNDP alone** (R4.1 closed the
  package-existence half, STRANGER's finding; R4.3 closed the status-blind
  half, the owner's counterexample — a status-blind guard certifies nine
  internal dummies as the public API), so a repeated lawful load is a
  no-op, an incomplete lane is REPAIRED (package.lisp re-applied before
  the implementation; post-load assertion fails closed), and a half-load
  in a terminal image is re-driven into the mechanism's own definitive
  refusal.
- One new row appended to `lisp-plus-system::*lane-order*` (last; no
  existing row moves): the umbrella loads the lane after Stack A has already
  loaded CD/0, so cd0 still loads exactly once under the umbrella. The
  row's guard is the same completeness predicate
  (`lisp-plus-system:surface-account-api-complete-p`, dispatched by the
  walker's `(:predicate …)` marker; every package-guarded row is untouched;
  its body is token-identical to `load.lisp`'s between the
  `SA0-COMPLETENESS-PREDICATE-CORE` markers — graph-gate GG-5/GG-6).

## 9. Which system owns production tests

`mneme/verify-release.sh` remains the one release authority; the lane adds
its own rows there (see §11). The lane's test entry points live in
`production/` beside the source. `asdf:test-system "lisp-plus"` continues to
run the floor; no lane-private test system is added (house shape: gates are
floor rows, not ASDF test systems).

## 10. How test/probe code is excluded from production dependencies

- `production/load.lisp` loads exactly three files: CD/0 (guarded),
  `package.lisp`, `surface-account.lisp`. No probe, transcript, mutation, or
  adjudication file is reachable from it — enforced by the static graph gate
  (`production/surface-account-graph-gate.sh`), which (a) asserts the
  production sources reference no `probes/` path, and (b) loads the lane in
  a fresh image and proves no probe artifact arrived (the probe's CL-USER
  symbols absent; only the three declared files loaded).
- The frozen probe battery keeps running against the untouched
  `probes/` tree; production never calls into it, and its staying green is
  not counted as evidence about the product (the production-only disease
  comparator proves the separation the other way round).

## 11. Release-floor delta (stated as law; exact integers at freeze)

New rows in `verify-release.sh` (all additive; no existing row moves):

| Profile | Row | What it runs |
|---|---|---|
| both | lane self-test | `production/surface-account-selftest.lisp` (public-entry behavior, API-ledger kinds, repeated-load continuity, counter/epoch shape laws incl. hostile Unicode arms, planted teeth) |
| both | inhabited specimen | `production/surface-account-inhabited.lisp` (/0 value consumed by /2, dependence proven, fresh + reload arms) |
| both | static graph gate | `production/surface-account-graph-gate.sh` |
| full | hostile profiles | `production/run-hostile-profiles.sh` (schedule-pinned production teeth, one fresh image per role; since R4.3 also the four loader-finality witness cases of `production/surface-account-loader-witness.lisp`, one fresh image per case, plus the witness's planted-fault tooth) |
| full | disease comparators | `production/surface-account-disease.sh` (disposable-replica mutations; diseased source never committed; eight since R4.3 — D7 restores the owner's status-blind-predicate counterexample, D8 fires the post-load assertion) |

Floors therefore move `89+N/89+N` full and `73+M/73+M` CI with **N = 5,
M = 3** by this table; the exact integers are restated at freeze after the
rows exist and have been counted mechanically (adjudication Section G's law:
a row is one gate invocation; self-test assertion counts do not inflate
floors). Historical `89/89`, `73/73` remain historical.

## 12. How the inhabited specimen proves real dependence (and its negative control)

The specimen (fresh image, umbrella path): mint a performance identifier
through the public /0 API; pass it as the `occurrence-tag` of a lawful
`lisp-plus-surface2:request-expansion` / `perform-expansion`; read it back
at the /2 boundary through /2's public readers. Dependence, proven not
asserted: (a) the receipt-stored tag is `equal-datum`/octet-identical to the
/0-minted datum, and its epoch path segment equals THIS image's
`image-epoch-hex` — a 32-hex value that did not exist before this image's
/0 state was published and that no fixture can carry; (b) two /0 mints
differing only in counter produce two /2 requests whose request identities
differ — the /2 result varies with the /0 value; (c) the negative control
(disposable replica of the specimen with the /0 contribution replaced by a
fixed literal tag) fails the named epoch-linkage check. No parallel
literal, no fixture-only identity, no duplicate allocator.

If any of this had required new /2 semantics the round would have halted
with `SURFACE-0-TO-2-INHABITANCE-CONTRACT-GAP`; it does not — the
occurrence-tag door is public, documented /2 API accepting exactly this
species (Phase-0 inventory §3).

— FABER, R4 integrator (Claude Fable 5), 2026-08-06
