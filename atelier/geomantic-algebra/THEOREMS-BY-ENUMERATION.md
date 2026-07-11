# Theorems by Enumeration — the Shield Chart as F₂⁴

*TETRAGRAM, 2026-07-09. First mathematics on the lab's day-old userland SBCL (2.4.6).*

Every claim below gets **both legs**: a short algebraic derivation **and** the full
65,536-case exhaustive check. Where they agree, the theorem earns the word. Where they
would disagree, **the enumeration wins and the disagreement is the headline** — as it
happens, on this run they agree on every count, so there is no such headline. What there
*is*: two pieces of geomantic folklore graded **FALSE** by exact count.

Reproduce:

```
~/.local/bin/sbcl --script engine.lisp      # library + demo + self-test
~/.local/bin/sbcl --script enumerate.lisp   # the 65,536-case run
```

---

## Convention (declared — this is the honest move; conventions vary)

A **figure** is a 4-bit integer `0..15`. Four **lines**, top to bottom, are
`head neck body feet`:

| line | head | neck | body | feet |
|------|------|------|------|------|
| bit  | 3 (8) | 2 (4) | 1 (2) | 0 (1) |

- **bit = 1** → a **single** point `( * )` — active / odd.
- **bit = 0** → a **double** point `( * * )` — passive / even.
- **point-count** of a figure = `1·(#single lines) + 2·(#double lines) = 8 − popcount`,
  ranging 4 (Via, all single) … 8 (Populus, all double).
- **Figure addition** — the medieval rule *combine line-wise; odd total of points → single,
  even total → double* — **is bitwise XOR**. The whole eight-century apparatus:
  `(defun add-figures (a b) (logxor a b))`.

The 16 names under this bit order (standard Agrippa table):

| int | figure | pts | parity | int | figure | pts | parity |
|----:|--------|----:|:------:|----:|--------|----:|:------:|
| 0 | Populus | 8 | even | 8 | Laetitia | 7 | odd |
| 1 | Albus | 7 | odd | 9 | Carcer | 6 | even |
| 2 | Tristitia | 7 | odd | 10 | Amissio | 6 | even |
| 3 | Fortuna Maior | 6 | even | 11 | Puella | 5 | odd |
| 4 | Rubeus | 7 | odd | 12 | Fortuna Minor | 6 | even |
| 5 | Acquisitio | 6 | even | 13 | Puer | 5 | odd |
| 6 | Coniunctio | 6 | even | 14 | Cauda Draconis | 5 | odd |
| 7 | Caput Draconis | 5 | odd | 15 | Via | 4 | even |

*"Even parity"* = an even number of single points = even point-count (since
`pointcount = 8 − popcount`). The 8 even-parity figures are
`{Populus 0, Fortuna Maior 3, Acquisitio 5, Coniunctio 6, Carcer 9, Amissio 10, Fortuna Minor 12, Via 15}`.

**Chart derivation.** Daughters = transpose of the 4×4 Mother matrix (Daughter *i* line *j* =
Mother *j* line *i*). Then `N1=M1⊕M2, N2=M3⊕M4, N3=D1⊕D2, N4=D3⊕D4`;
`W1=N1⊕N2, W2=N3⊕N4`; `Judge=W1⊕W2`; `Reconciler=Judge⊕M1`. Every operation is
GF(2)-linear, so the **whole chart is a linear function of the 16 input bits** — the fact
every theorem below leans on.

---

## Theorem 1 — Judge parity is FORCED even

**Statement.** For *every* one of the 65,536 castings, the Judge's total point-count is even.
Equivalently, only the 8 even-parity figures can ever be Judge.

**Algebra (both paths cancel).** Collapsing the derivation,

```
Judge = W1 ⊕ W2 = (M1⊕M2⊕M3⊕M4) ⊕ (D1⊕D2⊕D3⊕D4)
```

so the Judge is the **XOR of all eight first-generation figures** (4 Mothers + 4 Daughters).
Parity (sum of bits mod 2) is linear over XOR, so

```
parity(Judge) = parity(M1) ⊕ … ⊕ parity(M4) ⊕ parity(D1) ⊕ … ⊕ parity(D4).
```

Now the Daughters are the **transpose** of the Mother matrix: the multiset of bits in
`{D1..D4}` is *identical* to the multiset of bits in `{M1..M4}` — every Mother bit `A[i][j]`
appears once as a Mother bit and once as a Daughter bit. Hence each Mother bit is counted
**exactly twice** in the grand total, and the whole sum vanishes mod 2:

```
parity(Judge) = 0   (always).
```

`parity(Judge)=0` ⇔ even popcount ⇔ even point-count. The two-path cancellation is the
mathematical heart: *the Mother contributes to the Judge once down the Mother line and once
down the transpose line, and even+even=zero.*

**Enumeration (all 65,536).**

| Judge point-count parity | charts |
|---|---:|
| even | **65,536** |
| odd | **0** |

Point-count distribution of the Judge:

| Judge points | charts | which figures |
|---:|---:|---|
| 4 | 8,192 | Via |
| 5 | 0 | — (odd, impossible) |
| 6 | 49,152 | the six 6-point even figures |
| 7 | 0 | — (odd, impossible) |
| 8 | 8,192 | Populus |

**Verdict: FORCED.** No coherent geomantic text can have an odd-point Judge; the folk claim
"only 8 of the 16 figures can stand as Judge" is *mathematically necessary*, not a cultural
convention. Count-of-record: **65,536 / 65,536 even, 0 odd.**

---

## Theorem 2 — Judge frequency is FORCED uniform (and "Populus rules the Judge" is FALSE)

**Statement.** Across all 65,536 castings each of the 8 even-parity figures appears as Judge
**exactly 8,192 times**; each of the 8 odd-parity figures appears **0 times**.

**Algebra.** The Judge is a *linear* map `F₂¹⁶ → F₂⁴`. A linear map has equal-size fibers over
every point of its image (all cosets of the kernel have size `|kernel|`). Writing the Judge
bit-wise, `Judge[j] = colParity(j) ⊕ rowParity(j)` (column-*j* parity of the Mother matrix
XOR the parity of Mother *j*); the diagonal Mother bit `A[j][j]` cancels in each. Feeding
single input bits `A[0][1], A[0][2], A[0][3]` yields Judge images `1100, 1010, 1001` — three
independent vectors that **span the full even-parity subspace** (dimension 3, 8 elements).
So the image is exactly those 8 even figures, and each has `2¹⁶ / 8 = 8,192` preimages. The
uniformity is not luck — it is what a surjection onto a subspace *must* do.

**Enumeration (all 65,536).**

| figure | as Judge | figure | as Judge |
|---|---:|---|---:|
| Populus (0) | **8,192** | Laetitia (8) | 0 |
| Albus (1) | 0 | Carcer (9) | **8,192** |
| Tristitia (2) | 0 | Amissio (10) | **8,192** |
| Fortuna Maior (3) | **8,192** | Puella (11) | 0 |
| Rubeus (4) | 0 | Fortuna Minor (12) | **8,192** |
| Acquisitio (5) | **8,192** | Puer (13) | 0 |
| Coniunctio (6) | **8,192** | Cauda Draconis (14) | 0 |
| Caput Draconis (7) | 0 | Via (15) | **8,192** |

Distinct nonzero counts: **{8192}** (a single value → perfectly uniform). Figures that can
judge: **8**. Figures that can never judge: **8**.

**Verdict on the mathematics: FORCED uniform.** **Verdict on the folklore: FALSE.** The Via
Punctorum tradition carries a rumor that **Populus is over-represented as Judge**. Exact count:
Populus judges **8,192** times — *identical* to every other even figure, not one casting more.
The rumor is graded **FALSE by enumeration**. (Any felt over-representation is a reading-room
artifact — Populus is the memorable all-doubles blank, so it is *noticed* more, not *cast* more.)

---

## Theorem 3 — Reachable (W1, W2, Judge) triples = 128, FORCED

**Statement.** Exactly **128** distinct Witness-pair-plus-Judge triples occur, out of a naive
`16·16·16 = 4096` ceiling. The gating law: **parity(W1) = parity(W2)** always.

**Algebra.** `Judge = W1 ⊕ W2`, so a triple is determined by its `(W1, W2)` pair — counting
triples = counting reachable pairs. `W1 = M1⊕M2⊕M3⊕M4` is the vector of **column parities** of
the Mother matrix; `W2 = D1⊕D2⊕D3⊕D4` is the vector of **row parities** (bit *j* = parity of
Mother *j*). For any binary matrix, `Σ row-parities = Σ column-parities = total parity`, forcing

```
parity(W1) = parity(W2).
```

Conversely it is a standard fact that a 4×4 binary matrix exists for **any** prescribed
row-parity and column-parity vectors *subject only to that equal-total constraint*. Counting
admissible pairs: pick the shared total-parity bit `p ∈ {0,1}`; then W1 is any of the 8 figures
of parity `p` and W2 any of the 8 of parity `p` → `8·8 = 64` pairs per `p`, `× 2 = **128**`.

**Enumeration (all 65,536).**

| quantity | value |
|---|---:|
| distinct (W1, W2, Judge) triples realized | **128** |
| naive ceiling 16·16·16 | 4,096 |
| realized triples violating parity(W1)=parity(W2) | **0** |

**Verdict: FORCED.** The reachable Witness/Judge geometry is `128`, exactly the equal-parity
pairs — a hard combinatorial law, not a scribal choice. Any "these two Witnesses with that
Judge can never co-occur" claim is decidable: it is true **iff** the triple is outside these
128 (in particular, any chart whose two Witnesses have *opposite* parity is impossible —
`0` of them occur).

---

## Theorem 4 — Self-transpose castings = 1024, FORCED

**Statement.** The number of castings whose Daughter quadruple *equals* its Mother quadruple
is **1,024**.

**Algebra.** Daughters = transpose of the Mother matrix, so "Daughters = Mothers" ⇔ the 4×4
Mother bit-matrix is **symmetric** (`A[i][j] = A[j][i]`). A symmetric 4×4 binary matrix is free
on its diagonal (4 bits) and its upper triangle (6 bits) — 10 free bits — so there are
`2¹⁰ = **1024**` of them, out of `2¹⁶ = 65,536` castings (exactly `1/64`).

**Enumeration (all 65,536).**

| quantity | value |
|---|---:|
| self-transpose castings (Daughters ≡ Mothers) | **1,024** |
| predicted 2¹⁰ | 1,024 |

**Verdict: FORCED.** A pure counting fact about symmetric matrices; the tradition's Daughters
step *is* a transpose, so its fixed points are exactly the symmetric castings.

---

## The FORCED / CONVENTIONAL split (the deliverable for the probe arc)

The geomancy probe tests what a **model absorbed of the textual tradition**. To read those
verdicts you need to know which tradition-claims are *mathematically entailed by the
combinatorics* (any coherent text must say them — a model could in principle *derive* them) vs.
*cultural choices* (only learnable from reading the corpus). This engine draws the line by
exact count.

**FORCED — necessary for any coherent geomantic text (a model could re-derive these):**

| claim | count-of-record | theorem |
|---|---|---|
| Judge always has even point-count | 65,536 / 0 | 1 |
| Only 8 specific figures can be Judge | 8 can / 8 cannot | 1–2 |
| Every possible Judge is equally likely | uniform 8,192 | 2 |
| Two opposite-parity Witnesses cannot share a chart | 0 violations of 128 | 3 |
| Reachable Witness/Judge geometry has 128 states | 128 / 4096 | 3 |
| Self-transpose castings number 1,024 | 1,024 / 65,536 | 4 |

**CONVENTIONAL — a cultural choice, learnable only from the corpus (a model can only *read*
these, never derive them):**

- The **names** of the 16 figures (Populus, Via, Puer …) and their bit-order — the algebra is
  name-blind; *which* even figure is called "Populus" is convention (this file's own table is
  one such choice, declared up top).
- **Planetary / elemental / zodiacal rulerships** (Populus↔Moon, Puer↔Mars, …) — pure lookup,
  touched by no derivation here.
- **House assignment** and the 12-house astrological overlay — a mapping onto an external
  system, not entailed by F₂⁴.
- **Interpretive valence** (Fortuna Maior "good", Rubeus "ill") — semantics, not combinatorics.

**FALSE — folklore graded false by exact count:**

- *"Populus is over-represented as Judge."* Populus judges **8,192** times, identical to all 7
  other even figures. (Theorem 2.)
- *"Some Judges are more common than others."* All judging figures tie at **8,192**;
  distribution is exactly uniform. (Theorem 2.)

**Why the split earns its keep.** A probe prereg that treats *"the model knows the Judge is
always even"* as evidence of tradition-absorption is mis-specified — that fact is **FORCED**, so
a model could produce it from the combinatorics without ever reading a geomantic text. The
load-bearing test items are the **CONVENTIONAL** ones (names, rulerships, house lore) and the
**FALSE** ones (does the model *repeat the Populus-Judge folklore*, which a corpus carries but
mathematics forbids?). That last is the sharpest instrument here: a genuine tradition-signal
would show the model echoing a *false-but-textual* claim, cleanly separable from any
mathematically-derivable one.

---

## Ledger

- **Derivation ⇄ enumeration agreement:** 4 / 4 theorems, every count exact. No
  derivation-vs-enumeration disagreement arose on this run (the headline slot stayed empty by
  luck of correctness, not by suppression).
- **What this file cannot prove:** that the declared bit-order/name table is *the* tradition's
  (it is *a* standard one — declared, not universal); that "8,192 ties" refutes every historical
  Populus-Judge claim (it refutes the *frequency* claim; a text may prize Populus for meaning,
  which no count touches).
- **Runtime:** both scripts complete in well under a second on SBCL 2.4.6.

*— TETRAGRAM (Opus 4.8), 2026-07-09*
