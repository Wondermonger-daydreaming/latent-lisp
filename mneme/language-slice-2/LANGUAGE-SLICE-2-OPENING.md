# LANGUAGE SLICE /2 — OPENING

*Opened 2026-07-25 by owner ruling, relayed through Sol, after the pre–Slice /2 gate
closed its two blockers. This artifact opens a **design investigation**. It specifies
nothing, authorizes no implementation, and freezes no vocabulary.*

*— Claude Opus 5 (1M context), chair · SBCL 2.4.6*

```
status:                   OPEN FOR DESIGN
implementation-authorized: no
public-api-authorized:     no
specification-frozen:      no
```

---

## 1. Why it opened now

Slice /2 was to wait for CATENA, a lawful library refactor, a longer inhabited
chain, a **second non-isomorphic inhabitant**, and **recurring language pressure.**
All five have happened. The gate then held twice more — once on a polarity
inversion, once on a naming collision — and both are now closed
(`CHARTER-DELTA-4.md`, commit `d252bd42`).

---

## 2. Admission evidence — exactly two inhabited witnesses

### `de-bibliotheca-peregrina` — an interlibrary loan desk. **97 checks / 0 failed.**

| | |
|---|---|
| governed effect account exists | yes — a courier crossing with a transported receipt |
| account remains inspectable | yes |
| account supplied downstream | yes |
| account appears as unsupported residue | yes (`CHARTER-DELTA-3`) |
| semantic premise remains missing | yes — `:MISSING`, with `known: (:FRONTIER-CROSSED :EFFECT-UNCERTAIN)` |
| acquisition-unverified direct assertion can grant | yes |
| production application declines that route | yes |
| honest unresolved state follows | yes — the patron stays refused, and the refusal is the language's |

### `de-codice-restaurando` — a manuscript conservation workshop. **89 checks / 0 failed.**

| | |
|---|---|
| governed effect account exists | yes — real attempt identity, real ledger token, nine recorded events |
| account remains inspectable | yes |
| account supplied downstream | yes — unwrapped, unrestated |
| account appears as unsupported residue | yes — `(:INDEX 1 :REASON :UNSUPPORTED-SUPPORT-SPECIES)` |
| semantic premise remains missing | yes — `[VII-c]`, `:TREATMENT-COMPLETED` is `:MISSING` |
| acquisition-unverified direct assertion can grant | yes — `[VII-h]`, and a **fabricated** or **bare** witness grants identically (`[VII-i]`, `[VII-j]`) |
| production application declines that route | yes — `[VII-q]`, and the program states that this refusal is *unenforced policy* |
| honest unresolved state follows | yes — `:TREATED-UNASSESSED`, reassessment opened, no completion date |

**Non-isomorphic, and that is the load-bearing property.** The first is a **line**:
one road, one direction, courier vocabulary present. The second is **two independent
roads that meet** — material standing and institutional mandate, reconvergence
requiring a premise from each — with the courier vocabulary **absent from the domain
entirely.** The frontier appeared in both.

---

## 3. Minimal problem

> Language Slice /2 investigates how a governed effect account, acknowledgment,
> observation, or execution record may become semantic premise support through an
> **explicit admission relation**, without being replaced by an
> acquisition-unverified direct assertion and without collapsing deed, testimony,
> verification, acknowledgment, and settlement.

---

## 4. The lower-bound law already earned

> **Direction is not admission.** Slice /1 now prevents a witness that explicitly
> refutes a proposition from counting as positive support. This does **not**
> determine which support species a premise may accept, nor whether an assertion
> corresponds to a real event.

What that closure cost, and did not buy: `R-POLARITY-1` reads exactly one field
(`witness-polarity`) at exactly one site (`%witness-refutes-p`). It is **not** an
admissibility test. `mode`, `kind`, `source`, `procedure`, `content`,
`transmissible` and `accessible-to` remain unconsulted by premise discharge.

**And the gap Slice /2 inherits is docketed, not new.**
`LANGUAGE-SLICE-1-ARCHITECTURE.md` names *"the undefined term `admissible` (E4)"* —
while Slice /1 charter §5 defines `:satisfied` as *"a matching, **admissible**,
accessible support."* **The charter's key status definition rests on a word its own
architecture flags as undefined.** `INVENTORY-1.md` records the intended shape of
the missing piece: *"`:admits` governs support-shape admissibility, not premise
discharge. Reuse the `(mode kind)` admissibility idea; **add premise schemas
alongside**."* Those premise schemas were never built. **Slice /2 is the place they
would go.**

---

## 5. First design fork — opened, not decided

```
  premise-declared support contract
      vs
  derivation-procedure-declared support contract
      vs
  first-class support-admission object
```

**No choice is made here.**

Every candidate must **explicitly represent**, never infer:

```
accepted support species
direction / polarity
binding to effect or observation identity
required judgment or testimony status
receiver-relative accessibility
basis retained downstream
```

And **may not** infer compatibility from:

```
procedure-id · schema identity · mode alone · kind alone
predicate spelling · package identity · implementation convention
```

That prohibition is not stylistic. It is the shape of a defect this project has
already refused twice — a hidden selector standing in for a stated contract.

---

## 6. Grounding vocabulary — three axes, none a proxy for another

```
environment plurality        number of complete surviving binding environments
projected-premise            number of distinct conclusion-projected premise
  multiplicity                 instances
ambiguity                    violation of a declared uniqueness relation
```

Bare *"plurality"* is retired where the axis is not stated. The
conclusion-projected premise instance is **not** to be called fully ground while
schema locals remain variables.

**The demonstration, from one receipt on a two-premise schema:**

```
PREMISE 1    environment plurality 3    projected multiplicity 1
PREMISE 2    environment plurality 1    projected multiplicity 3
```

The two quantities **trade places inside a single document.** No census of one can
stand in for the other.

**A recorded chair error, kept because Slice /2 should not inherit it:** an earlier
adjudication claimed the projection was *"structurally pinned at 1"* and that
Decision 2's above-cardinality-one refusal *"can never fire."* **Both false.** The
claim was generalized from a one-premise test; the repository's own passing tooth
`T30e` — *"the singular projection REFUSES above cardinality one (never selects)"* —
already contradicted it. The **G-2 classification and every directive of
`R-GROUNDING-NAME-1` survive**; only the unreachability argument dies.

---

## 7. Non-goals — no authorization here for any of these

```
automatic effect-to-witness coercion
automatic truth from successful execution
global identity lookup / resolution
persistence or crash survival
generic codata
Ramanujan Radical /0
implementation, exports, or public API
mode/kind heuristic admission
premature charter or specification
```

---

## 8. Standing caps on everything Slice /2 will produce

**Self-consistency, not corroboration.** One model family wrote this language, its
tests, its applications, and every adjudication that opened this door. Nothing here
is independent verification.

**The stranger audit remains OWED.** GLM, Gemini and MiniMax are unspent. Sol,
Fable, Codex, Qwen and every Claude-lineage seat are **ineligible** — Sol designed
the second inhabitant's topology and participates in this lane.

**No conformance language is licensed** by anything in either application. Both
chambers are labelled scripted fake adapters, never AP0-conformant.

**The frontier is a statement about Slice /0 + Slice /1 + Core /0 as they stand**, on
the day this opened, and about nothing else.

---

## 9. Immediate next act

**A design fork, not implementation.** Choose among the three candidates in §5, in
the open, with the representation requirements as the criteria. Nothing in this
document prefers one.

**Do not** queue a Slice /2 designer or implementer in the session that opened this.

---

*Opened against: lab commit `d252bd42` · Slice /1 selftest 123/0 · de-bibliotheca
97/0 · de-codice 89/0 · both applications byte-identical across two clean runs ·
exports 74 by live enumeration · effect frontier blocked and reproduced in both.*

*One known pre-existing failure outside the verification floor, reported and
deliberately unfixed: `CHAIR-REPRO-B1-B2.lisp` exits 1 on the untouched baseline —
a pre-repair reproduction outliving its repair.*

— **Claude Opus 5 (1M context)**, 2026-07-25
