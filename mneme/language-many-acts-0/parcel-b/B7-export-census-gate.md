# PARCEL B — ITEM B7: NO EXPORT-CENSUS GATE EXISTS

STANDING: CANDIDATE PROPOSAL. Nothing here is adopted, accepted, or in force; nothing here
is independent verification (AP0 adoption Rider 2, binding). **This item proposes law and
implements nothing.** No gate was built; building one is new code, and fixing a count as a
floor would hand this lane an authorized number it has never had.

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 7 of 8.

---

## 1. THE GAP

`MANY-ACTS-0-CONTRACT-CANDIDATE.md:114–120`:

> ```
> ⚠ **There is no export-census gate.** The pre-code draft of this section said "the census
> gate asserts count and boundness"; no such gate was built, and no gate in this lane asserts
> the export count or the boundness of every exported symbol. The 38 above is a *reading of
> `package.lisp`*, not a mechanically enforced floor. (The one mechanical sweep over the
> package's external symbols is `r1/D5-generation-seam.lisp`'s exposure check, which asserts
> that no exported reader exposes the generation — a different obligation.) No census gate is
> proposed here; naming its absence is.
> ```

The handoff entry, `MANY-ACTS-0-PARCEL-A-RETURN.md:738–740`:

> **B7 — No export-census gate exists.** Contract §6's pre-code draft asserted one asserting
> "count and boundness". Parcel A recorded the absence. **Gap:** building one is new code, and
> fixing the export count as a floor would give the lane an authorized number it has never had.

### 1.1 The standing facts, mechanically checked on this branch

- `MANY-ACTS-0-CONTRACT-CANDIDATE.md:112` declares `4 + 3 + 2 + 8 + 6 + 11 + 3 + 1 = **38**`.
- The `(:export …)` clause of `#:lisp-plus-many-acts0` in `package.lisp` contains **38**
  symbol designators (mechanical count of `#:` designators inside the export clause).
- The declared reading and the package therefore **agree today**. The gap is not a discrepancy;
  it is that **nothing checks** that they continue to agree, and nothing checks that every
  exported symbol is actually bound.
- The one existing mechanical sweep over external symbols,
  `r1/D5-generation-seam.lisp`'s exposure check, asserts a *different* obligation
  (no exported reader exposes the generation) and would not notice an export that was added,
  removed, or left unbound.

**The real hazard the absence leaves open** is not the count drifting in isolation — it is an
export that names nothing. A `(:export #:ma0-result-verdict)` for a symbol never `defun`'d
compiles clean, ships in the package, and fails only in the hands of whoever first calls it.
That is the class the pre-code draft's word "boundness" was reaching for.

---

## 2. THE PROPOSED RULING — three options, none chosen

### OPTION 1 — CENSUS WITH A FIXED COUNT (count **and** boundness, count as a floor)

Candidate text:

> **EXPORT CENSUS (owner ruling, 2026-08-__).** An export-census gate is authorized. It
> asserts, mechanically, over the external symbols of `#:lisp-plus-many-acts0`:
>
> 1. **Count.** The number of external symbols equals **38**, the number adopted by this
>    ruling as the /0 export cardinality. A change in either direction is RED.
> 2. **Boundness.** Every external symbol is bound in at least one of the senses the surface
>    uses — `fboundp`, `boundp`, a defined condition class, or a defined structure type — and
>    the sense is printed per symbol, never assumed.
> 3. **Tooth.** The gate carries a planted-fault mode (an injected phantom export and an
>    injected unbound export), and both must be shown firing before a clean run is quoted.
> 4. **Sentinel.** `ma0-export-census: 38 exports, 0 unbound, 0 divergences`.
>
> **Adopting this ruling adopts 38 as the /0 export cardinality.** Any later addition or
> removal of an export becomes a versioned surface change requiring an owner ruling, exactly
> as a grammar change does.

**Consequence.** The strongest guarantee, and the one that matches the pre-code draft's
promise. Its cost is precisely the thing the handoff flagged: **the lane acquires an
authorized number it has never had.** 38 stops being a reading and becomes law, and the next
round that wants a new export must go to the owner for it. That may be exactly right for a
lane whose whole claim is a *closed* authoring surface — or it may freeze an accident of
implementation history into a constitutional quantity. The owner should decide which, on the
merits, and not because a gate was convenient.

### OPTION 2 — BOUNDNESS ONLY (no authorized cardinality)

Candidate text:

> **EXPORT CENSUS (owner ruling, 2026-08-__).** An export-boundness gate is authorized. It
> asserts that every external symbol of `#:lisp-plus-many-acts0` is bound in at least one
> declared sense, printing the count it observed and the sense per symbol. **It does not fix
> the count.** The observed count is reported, never asserted; the contract's `38` remains a
> reading of `package.lisp` and is corrected in the same commit as any export change.
> The gate carries a planted-unbound tooth that must be shown firing.
> Sentinel: `ma0-export-census: <N> exports, 0 unbound` (N printed, never round-numbered).

**Consequence.** Catches the real hazard — an export that names nothing — without minting a
constitutional number. The count still drifts silently against the contract's prose, which is
a documentary risk rather than a runtime one, and one a reader can check by arithmetic.
This is the smaller move; it is not the safer one in every respect, because a silently
growing export list widens the "closed surface" claim without anything noticing.

### OPTION 3 — RULE THAT NO CENSUS GATE EXISTS AT /0

Candidate text:

> **EXPORT CENSUS (owner ruling, 2026-08-__).** No export-census gate is built at /0. The
> pre-code draft's promise of a gate "asserting count and boundness" is **withdrawn** rather
> than deferred: the /0 export surface is governed by `package.lisp` itself, read by whoever
> is authoring against it, and the contract's `38` is and remains a stated reading. The
> contract text is amended to record the withdrawal rather than the absence.

**Consequence.** Honest, cheapest, and consistent with the lane's habit of naming holes
instead of quietly filling them. Cost: the phantom-export hazard stays live and unwatched,
and a later stranger-implementation round would have to discover it the hard way.

---

## 3. THE REDLINE (exact, per option — none applied)

### 3.1 OPTION 1

BEFORE (`MANY-ACTS-0-CONTRACT-CANDIDATE.md:114–120`) — the whole ⚠ paragraph, as quoted in §1.

AFTER:

```
⚠ **The export census is a gate.** `ma0-export-census` (Parcel B item B7, owner ruling
2026-08-__) asserts mechanically that `#:lisp-plus-many-acts0` has exactly **38** external
symbols and that every one of them is bound in a declared sense, printing the sense per
symbol; it carries planted phantom-export and unbound-export teeth, and both are shown firing
before any clean run is quoted. The 38 above is therefore an ENFORCED FLOOR, not a reading:
adding or removing an export is a versioned surface change requiring an owner ruling.
Sentinel: `ma0-export-census: 38 exports, 0 unbound, 0 divergences`.
```

Plus, in `ma0-teeth.sh`, a new section (illustrative form; the script does not exist):

```
section "6b EXPORT CENSUS" \
  "sbcl --script $LANE/ma0-export-census.lisp" \
  '^ma0-export-census: 38 exports, 0 unbound, 0 divergences$'
```

*(The teeth section count moves from 15 upward — a number quoted in the adopted R1 record —
so this option cannot be executed as a quiet addition.)*

### 3.2 OPTION 2

BEFORE (`MANY-ACTS-0-CONTRACT-CANDIDATE.md:114–120`) — the whole ⚠ paragraph.

AFTER:

```
⚠ **Boundness is gated; the count is not.** `ma0-export-census` (Parcel B item B7, owner
ruling 2026-08-__) asserts that every external symbol of `#:lisp-plus-many-acts0` is bound in
a declared sense, printing the observed count and the sense per symbol, with a planted-unbound
tooth shown firing before any clean run is quoted. **It does not fix the count.** The 38 above
remains a *reading of `package.lisp`*, corrected in the same commit as any export change;
`package.lisp` is the surface and this is the error where they disagree.
Sentinel: `ma0-export-census: <N> exports, 0 unbound`.
```

### 3.3 OPTION 3

BEFORE (`MANY-ACTS-0-CONTRACT-CANDIDATE.md:119–120`):

```
that no exported reader exposes the generation — a different obligation.) No census gate is
proposed here; naming its absence is.
```

AFTER:

```
that no exported reader exposes the generation — a different obligation.) Parcel B item B7
(owner ruling, 2026-08-__) WITHDREW the pre-code draft's promise of a census gate rather than
deferring it: at /0 the export surface is governed by `package.lisp` as read, and no gate
asserts the count or the boundness of any export. The absence is settled, not pending.
```

---

## 4. IMPLEMENTATION STATUS

**PROPOSAL — AWAITING OWNER RULING. NOTHING IMPLEMENTED.**

No census script was written. `ma0-teeth.sh` is byte-unchanged and the teeth remain 15
sections. `MANY-ACTS-0-CONTRACT-CANDIDATE.md` and `package.lisp` are byte-unchanged.
**No number in this lane was authorized by Parcel B**, and in particular `38` remains exactly
what the contract says it is: a reading of `package.lisp`.

The count agreement reported in §1.1 was checked read-only, by counting export designators in
`package.lisp`. It is stated as an observation of the branch tip, not as a gate result, and
it earns nothing.

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
