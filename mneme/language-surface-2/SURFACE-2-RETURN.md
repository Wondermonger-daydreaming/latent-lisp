# SURFACE-2-RETURN — Language Surface /2: Outcomes Keep Their Axes

**Built by GLOSSATOR (Claude Fable 5 subagent); chair-checked from disk
and finalized by Claude Fable 5 (chair), 2026-07-30.** Survey: LEXICON
(Opus). Chair checks: transcripts, twins, and path-diff re-run from
disk; one unsupported cross-reference struck at finalization (§5 chair
note).

**Standing: candidate. Not audited. Not adopted. Not frozen. On no
governing floor.** Every green below is self-consistency inside this
lane's own gates, run in this lane's own process, over the preserved
campaign-1 fixtures.

Governed by `SURFACE-2-CONTRACT.md` (committed before any code of this
lane existed) under
`mneme/RULING-vertical0-closure-language-surface-2-2026-07-30.md` §5.
The governing sentence: *Lisp+ may make the honest path shorter, but
never by shortening the evidence carried home.*

---

## 1. What was built

```
mneme/language-surface-2/
  SURFACE-2-CONTRACT.md            committed pre-code (the ordering proof)
  surface2.lisp                    package + outcome object + discipline + forms
  surface2-selftest.lisp        →  RUN-SELFTEST.txt  (+ -SECOND, byte-identical)
  surface2-controls.lisp        →  RUN-CONTROLS.txt  (+ -SECOND, byte-identical)
  surface2-inhabited.lisp       →  RUN-INHABITED.txt (+ -SECOND, byte-identical)
  SURFACE-2-RETURN.md              this file
```

Gate results, from the committed transcripts:

| gate | checks | failures | exit | sentinel | twin |
|---|---|---|---|---|---|
| `surface2-selftest` | 29 | 0 | 0 | `RESULT: PASS` | byte-identical |
| `surface2-controls` | 38 | 0 | 0 | `RESULT: PASS` | byte-identical |
| `surface2-inhabited` | 18 | 0 | 0 | `RESULT: PASS` | byte-identical |

Each gate carries live plant-fault teeth (`*_PLANT_FAULT=1` → exit 1
with `FAIL PLANTED FAULT`) and truncation teeth (`*_DIE=1` → exit 3, no
`RESULT` sentinel), both fired in child processes inside the transcripts.

## 2. The outcome object

`seat-outcome` — reified, complete, read-only; constructed only by
`derive-seat-outcome (store events seat-id &key namespace)` over the
public predecessor APIs the census uses
(`lisp-plus-capability2:derive-effect-standing` for the execution axis;
`lisp-plus-journal0` validation and record readers for events). All
contract-§2 slots are present; absence is typed, never NIL-punned —
**every facet reader returns `(values VALUE STANDING)`**, standing one of
`:present` / `:absent-from-evidence` / `:malformed-in-evidence`.

Measured against the real campaign-1 evidence, one field shape beyond
the contract's enumeration surfaced: projection bodies journal
`no-payload-state` as a CD/0 **unit datum** on seats whose payload
manifested (the writer's explicit *none*). The old `body-string` folds
that into the same NIL as a missing field and a wrong-typed field. This
surface answers `(values :declared-none :present)` for it — the standing
set is unchanged; the *value* is typed. Demonstrated live in
`RUN-SELFTEST.txt` [S007] (burned-draft: string; first-fruit: declared
none; locked-purse: absent from evidence) and in `RUN-CONTROLS.txt`
[C029–C030], where the predecessor reader answers one NIL for two
different facts on the same bytes.

Retained beyond the census plist (the surplus, listed per seat in
`RUN-INHABITED.txt`): the execution standing and its whole cap2 evidence
plist; manifestation provenance as a slot (`:live` /
`:derived-recovery` / `:none` — the `(or …)` erasure is structurally
gone); the journaled interpretation class; the refusal's journaled
explanation beside its condition name, distinct; the per-facet standing
table; the list of journal events the derivation consulted.

## 3. The two forms

**`with-outcome`** — binds the complete outcome or refuses typed:

```lisp
(with-outcome (o (derive-seat-outcome store events "seat-half-song"))
  (list (seat-outcome-seat-id o)
        (nth-value 0 (seat-outcome-chunks-preserved o))))
;; non-outcome value => SURFACE2-NOT-AN-OUTCOME, code :NOT-A-SEAT-OUTCOME,
;; refusal object retained
```

**`match-outcome`** — dispatch over a closed pattern grammar; the parent
outcome stays bound in every clause body, including `otherwise`:

```lisp
(match-outcome o
  ((:refusal budget-ceiling-exceeded) …)                    ; refusal by name
  ((:and (:evidence-class :projection) (:execution :settled))
   :facets ((m :manifestation) (state :no-payload-state))   ; clause-local facets
   …)
  ((:evidence-class :projection)                            ; cross-axis guard,
   (signal-match-guard :projection-without-settled-execution …)) ; as a clause
  (otherwise …))                                            ; REQUIRED
```

Structural refusals at expansion, each a retained catalogued code, each
fired live in the transcripts: `:non-exhaustive-match` (no `otherwise`),
`:duplicate-pattern` (including spelling variants: conjunct order,
symbol vs string refusal names), `:unreachable-pattern` (earlier
equal-or-wider conjunct set, or any clause after `otherwise`),
`:pattern-not-in-grammar`, `:match-var-not-a-symbol`,
`:with-outcome-binding-malformed`, `:facet-binding-malformed`.

**Forbidden inferences are not expressible:** the pattern grammar has no
`:success`, `:truth`, `:retry-safe`, or `:cost` axis; attempts refuse
`:pattern-not-in-grammar` ([C008]). The surface exposes
`:uncertain-unresolved` / `:crossed-unsettled` as themselves, exports no
retry/resume/dispatch affordance ([C027–C028, C031]), and the CAP2-W1
scan still refuses a fresh dispatch over the uncertain seat.

## 4. The S1-shaped discipline (owner's adjudication)

This lane's OWN expansion-receipt discipline, mirroring Surface /1's
shape with **zero Surface /1 edits**: a closed two-row construct table
(`with-outcome`, `match-outcome`, namespace
`("lisp-plus-surface2" "construct")`); `request-expansion` /
`perform-expansion` doors (+ non-signalling twins); retained receipt
structs carrying source datum + identity, expanded datum + identity,
construct identity, operation, disposition, and the three versions (all
1) as stored values; a refusal catalogue split protocol-refusal vs
integrity-alarm; the inherited forbidden vocabulary enforced lexically at
load over every declared string, with the guard itself fired on planted
dirty strings ([C032]). A receipt claims WHICH BYTES expanded to WHICH
BYTES under WHICH procedure — nothing else. `verify-receipt` re-derives
both digest identities; the receipt-skipping mutant is caught
(`:receipt-not-minted`, [C020]), and the identity-projection alarms are
fired through planted-fault hooks ([C018–C019]).

**Negative control against the real Surface /1** ([C033–C035]): the real
`lisp-plus-surface1:request-expansion` mints a lawful request for a
`match-outcome` form (unknown head, no construct identity recorded), and
the real `perform-expansion` / `try-perform-expansion` refuse it
`:not-a-known-surface-construct`, phase `:perform` — no receipt, no
expansion, no occurrence minted. Surface /1's closure law holds against
this lane's heads exactly as its RETURN declares.

## 5. The inhabited vertical (contract §5)

`census-seat-plist` re-expresses the `%derive-seat-outcome` passage
(`vertical0/program/census.lisp:49-108`) as one `match-outcome` whose
clause order IS the census's evidence-class precedence and whose two
refusing clauses ARE the census's two hand-written guards. The old path
(`derive-census`, loaded through the official census-only chain, never
reimplemented) and the new path were run over the same preserved
campaign-1 store and configuration:

- **Canonical byte equality:** both census CD/0 records encode to
  **2118 octets, sha256
  `e0da6227b71095ac6b1732f99310faa6328abf5860bba0c679d1ebf5f04a36a6`**
  ([V005]). *(Chair note: this digest is the old-vs-new equality inside
  this gate; it is recorded nowhere in the official Vertical /0
  reconstruction artifacts — the official state artifact is a larger
  record with its own digest — and no identity between the two is
  claimed.)*
- **Per-seat agreement:** all twelve plists `EQUAL`, facet for facet
  ([V003–V004]).
- **Guards fire identically on mutated fixtures** ([V011–V015]): on an
  octet-exact scratch copy of the store appended with a projection for a
  seat whose attempt has no cap2 events, the old census refuses with its
  cross-axis error and the new passage refuses through its clause,
  code `:projection-without-settled-execution`; on a bank naming a seat
  with no evidence at all, the old census refuses its totality error and
  the new `otherwise` refuses `:no-evidence-class`. Neither path refuses
  the lawful fixtures.
- **Journal effects not involved:** the passage is pure — the preserved
  journal's digest is compared before/after in every gate ([S029],
  [C036], [V016]); every append happened in scratch stores that are
  deleted by the run.

## 6. Path-diff

`git status --porcelain` over `mneme/language-surface-1/`,
`mneme/language-surface-0/`, `mneme/vertical0/`, `mneme/capability2/`,
`mneme/adapter0/`, `mneme/journal0/`, `mneme/kernel0/`, and
`canonical-datum/` reports **no entry** — every predecessor byte-unchanged
by this lane. The only additions in the tree are the files of
`mneme/language-surface-2/` listed in §1.

## 7. Claims ceiling (contract §7, verbatim)

> Language Surface /2 candidate constructed · outcome-pattern surface
> tested · Surface /1 expansion receipts preserved *(this lane's receipts
> are S1-SHAPED under the owner's adjudication; Surface /1 itself is
> byte-unchanged and its own receipts undisturbed)* · one Vertical /0
> passage re-expressed equivalently *(equivalence = the
> canonical-equality demonstrations of §5, never a semantic-preservation
> claim — the forbidden vocabulary binds this document too)* · not
> audited · not adopted · not frozen · not on a governing floor.

## 8. Recorded deviations and survey notes

1. **The build brief called the vertical0 event readers "exports";
   they are not.** `program/package.lisp` exports config readers,
   conditions, evidence, budget and census only; `body-string`,
   `find-event`, `validated-events` and kin are package-internal. This
   lane therefore carries its own event readers over public
   `lisp-plus-journal0` / `lisp-plus-cd0` APIs — which the three-state
   facet law requires anyway. The controls reach one internal predecessor
   symbol (`lisp-plus-vertical0::body-integer`), read-only, solely to
   demonstrate the one-NIL on the same bytes.
2. **The unit-datum field shape** (§2 above): a fourth *evidence shape*
   placed inside the contract's three standings as the typed value
   `:declared-none`, not a fourth standing.
3. `seat-outcome` additionally retains an `evidence-class` facet (which
   census evidence class the precedence selects) — derived from presence
   facts already on the object, recorded here as surplus beyond the §2
   slot list.
