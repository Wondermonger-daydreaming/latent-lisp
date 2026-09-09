*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source (blob hash in PROVENANCE.md; strip recipe there). This is a working record, written during the work in the lab's own idiom; the public account is `README.md` in this directory. Paths of the form `_staging/…`, `notes/…`, `corpus/voices/…`, `~/freezer/…`, `~/Downloads/…` and `/tmp/…/scratchpad/…` are lab or machine locations that are not published; the outside reviewer's (Astra's) letters are quoted verbatim where they are relied on. Raw DRAT proofs named here were verified, hashed and deleted and are not published; `.cnf` instance files are omitted from the public evidence tree (regenerable with `tools/sat_search.py`; each witness-ref records the CNF's SHA-256).*

---

# NORMALIZATION COVER AUDIT /0

*Commissioned by Astra (GPT-6) through the owner, 2026-09-08 12:53 −03 (verbatim: `corpus/voices/received/originals/2026-09-08-125305-astra-commission-normalization-cover-audit-0-VERBATIM.md`).
Chair: Claude Fable 5.1 [bce86e], laptop. The SAT lane stays closed; no search was rerun; no construction improved; no kernel begun.
The object is the implication:*

> **(★)** If a two-terminal contact network in M₂ realizes S₄(1,3,4) with K ≤ 12 contacts, then there exists a semantics-equivalent
> representative satisfying every normal-form restriction used by the exhaustive CNF search, with no increase in contact count and
> within the searched vertex cover.

*Method: compiler-correctness, not folklore. Every rule the search relies on gets a row; every failed formulation the arc produced is
kept in the ledger; the four global questions and the vertex bound are answered separately; the adversarial construction is
attempted on paper (§6) and by an exhaustive enumerator (§7). Author's warning at the door: the author of `normalize.py` and
`COVER-THEOREM-0.md` is the auditor here; the one outside audit of the theorem is Astra's (09-08, §3½ of the theorem note). Where this
document says "proved," it means proved in prose by the author and not refuted by the outside reader; the status expression says so.*

---

## 0. The searched universe, stated exactly (what the CNF admits — the implicit assumptions made explicit)

For each V ∈ {2,…,13} and K = 12, `sat_search.encode("A", V, 12, "lex", varsym=True[, cube])` admits exactly the networks that satisfy:

| # | assumption in the CNF | where in code | kind |
|---|---|---|---|
| U1 | vertex set is exactly {0,…,V−1}; a = 0, b = 1, a ≠ b | `pairs`, `a, b = 0, 1` | representational |
| U2 | edges only on unordered pairs u < v (**no loops**) | `pairs = [(u,v) for u<v]` | NF2 |
| U3 | every edge is a contact with one literal; **no wires** | `LITS`, no wire variable | NF1 |
| U4 | at most one edge per (pair, literal) (**no duplicate parallels**) | one Boolean per (pair, literal) | NF3 |
| U5 | never both v and v′ on one pair (**no complementary parallels**) | `cnf.add(-row[2i], -row[2i+1])` | NF4 |
| U6 | Σ contacts ≤ K | Sinz counter | cost bound |
| U7 | every vertex has ≥ 1 incident edge; every non-terminal has ≥ 2 **distinct** neighbours | degree clauses | NF7, NF5 |
| U8 | transmission = existence of an a–b path of ≤ V−1 edges in the closed subgraph (positive rows); a 2-colouring cut (negative rows) | reach/cut families | semantics |
| U9 | R5′: internal vertices numbered lex-max under adjacent transpositions (rows over u<i then u>i+1) | lex block | symmetry-breaking |
| U10 | R6: c(w) ≥ c(x) ≥ c(y) ≥ c(z) on exact unary counters | varsym block | symmetry-breaking |
| U11 | (cubes, V=9 only) exact per-variable counts fixed to one admissible vector | `--cube` | partition |
| U12 | connectivity **not** imposed (lex) — components without terminals admitted | (absent) | superset; harmless for UNSAT |
| U13 | the sweep: one instance per V; a network on V′ < V vertices is *not* admitted at V (U7 forces every vertex used) — it is admitted at its own V′ | run script | cover-by-sweep |

U12 means the searched universe is a **superset** of NF on the connectivity axis; every other line is a restriction that (★) must
discharge. U13 is an implicit assumption worth naming: the cover is *the union over V*, not any single instance.

## 1. Objects (unordered from the first line — the ledger's entry L3 is why)

A network N = (V, E, a, b): finite V, a ≠ b ∈ V, E a finite multiset of **undirected** labelled edges ({u,v}, λ), {u,u} allowed, λ ∈ L ∪ {wire}.
Closure under α ∈ {0,1}⁴ as in the encoder (make closed iff α_v = 1; break iff α_v = 0; wire always). T_N(α) = 1 iff an a–b walk exists
in the closed subgraph. c(N) = #contacts. μ(N) = (c, |V|, #wires) lexicographic. NF1–NF7 as in U2–U5, U7, plus NF6 (no terminal-less
component — stronger than U12, harmless). Two lemmas from `COVER-THEOREM-0.md` are used as proved and outside-audited: **Lemma A**
(closed walk ⇒ closed simple path; an internal vertex of a simple path has two distinct neighbours) and **Lemma B** (quotient along an
always-closed u–v edge set S preserves T pointwise, with the lifting/projection written out; if {u,v} = {a,b} then T ≡ 1).

## 2. The rule table — one row per rule the search relies on

Columns: **source → target**; **side conditions**; **preserves** (f = terminal function · c = contact count · λ = literal/complement
semantics · ab = terminal distinction · wf = well-formedness); **Δ** (contacts, vertices, wires, μ); **kind** (E eliminative ·
C canonicalizing · S symmetry-breaking only · ★ completeness-critical); **proof**; **inverse reading** (why excluding violators of
this rule cannot exclude the last ≤12 realizer).

| rule | source → target; side conditions | preserves | Δ contacts / vertices / wires / μ | kind | proof | inverse reading |
|---|---|---|---|---|---|---|
| **ρ-junk** | N with a component C, a,b ∉ C → N − C | f (a–b walks lie in a's component, disjoint from C) · c ≤ · λ · ab · wf | ≤ / −\|C\| / ≤ / ↓ (2nd comp.) | E, ★ (for NF6 and the V-bound) | direct | a violator with junk has a junk-free image of ≤ cost realizing f |
| **ρ-pendant (R2)** | N with v ∉ {a,b}, \|N(v)∖{v}\| ≤ 1 → N − v (all incident edges); multiplicity and loops at v ignored in the count | f (Lemma A: v is on no simple a–b path; simple paths of N − v = those of N avoiding v = all of them) · c ≤ · λ · ab (v is not a terminal) · wf | −deg_L(v) ≤ 0 / −1 / ≤ / ↓ (1st or 2nd) | E, ★ (NF5) | Lemma A | a violator's image has ≤ cost and the same f; parallel-pair pendants included (the pair keeps v connected but never on a simple path) |
| **ρ-loop** | N with ({v,v}, λ) → delete it | f (a loop is on no simple path) · c ≤ · λ · ab · wf | −1 or 0 / 0 / −1 if wire / ↓ (1st or 3rd) | E, ★ (NF2/U2) | Lemma A | loops are cost without function |
| **ρ-dup (R3)** | N with two edges ({u,v}, λ), ({u,v}, λ) → delete one | f (any walk using the deleted copy uses the other) · c ≤ · λ · ab · wf | −1 or 0 / 0 / −1 if wire / ↓ | E, ★ (NF3/U4) | direct | the CNF has one Boolean per (pair, literal); a second copy adds cost, no function |
| **ρ-wire (R1)** | N with ({u,v}, wire), u ≠ v, {u,v} ≠ {a,b} → N/uv, S = {the wire} | f (Lemma B) · c = · λ · ab (a terminal keeps its name; both terminals excluded by side condition) · wf (loops created are handled by ρ-loop) | 0 / −1 / −1 / ↓ (2nd) | C, ★ (NF1/U3) | wires cost nothing and the CNF has no wire variable; the quotient has the same f and cost |
| **ρ-comp (R4)** | N with ({u,v}, x), ({u,v}, x′), u ≠ v, {u,v} ≠ {a,b} → N/uv, S = the pair | f (Lemma B; exactly one of the pair closed under every α) · c ↓ · λ · ab · wf | −2 / −1 / 0 / ↓ (1st) | E+C, ★ (NF4/U5) | the CNF forbids the pair; its quotient realizes f with 2 fewer contacts |
| **exclusion-1** | wire or complementary pair on {a,b} → halt | — (T ≡ 1: not a realizer of non-constant f) | — | ★ (guards ρ-wire/ρ-comp side conditions) | Lemma B's hypothesis on a,b | never reached from a realizer of A (every step preserves f = A ≠ 1) |
| **exclusion-0** | a or b with no incident edge → halt | — (T ≡ 0) | — | ★ (NF7/U7) | direct | never reached from a realizer of A |
| **R5′ (lex-max)** | NF network → the same network with internal vertices renamed to the lex-max edge vector in its S_{V−2}-orbit; rows over u<i then u>i+1 | f · c · λ · ab · wf (a renaming) | 0 / 0 / 0 / = | S | lex-max representative satisfies E ≥ τᵢE for every adjacent transposition; the row reduction = the global comparison in the encoder's order (proved by Astra 09-08; tested on 7,556 cases, `bridge_tooth.py`) | every orbit has a lex-max element; renaming changes nothing the CNF measures |
| **R6 (count order)** | network → the same with variables renamed by π ∈ S₄ so c(w) ≥ c(x) ≥ c(y) ≥ c(z) | f (**only because A is S₄-invariant** — checked on the table for all 24 π; the encoder now refuses non-symmetric targets) · c · λ (polarity never flipped: a bijection of *names*) · ab · wf | 0 / 0 / 0 / = | S | choose π sorting the counts; f∘π = f | a renamed realizer is a realizer |
| **R5′∘R6 jointly** | π first, then σ | as above | = | S | vertex renaming preserves per-variable counts, so σ cannot undo π (Astra's order; tested jointly on 2,400 nets) | one element of the product orbit satisfies both |
| **cube partition (U11)** | R6-network → its exact count vector (c_w,…,c_z) | — (a classification, not a rewrite) | = | ★ (V=9 cover) | every network has exactly one count vector; non-increasing by R6; each ≥ 1 (A depends on every variable — checked); Σ ≤ K; the 53 vectors are exactly the admissible ones (regenerated from the definition) | UNSAT on every cube = UNSAT on the instance |
| **sweep over V (U13)** | NF network on V′ vertices → the instance (V′, K) | — | = | ★ (cover-by-union) | V′ ≤ c+1 ≤ 13 (Lemma E below) and V′ ≥ 2 | the network is admitted at its own V′, which the sweep visited |

**Invariants needed downstream and how each rule keeps them.** (i) *Literal semantics*: no rule ever changes a label except R6's
name-bijection; no rule flips polarity; ρ-comp deletes a complementary pair, never rewrites one. (ii) *Terminal distinction*: no rule
merges a with b (both contractions exclude {a,b}); no rule deletes a terminal (ρ-pendant is restricted to v ∉ {a,b}; ρ-junk removes
only terminal-less components). (iii) *Well-formedness*: contractions can create loops, duplicates, complementary parallels, pendants
— all are redexes for later iterations; nothing becomes ill-formed. (iv) *The function*: preserved pointwise on all 16 rows by every
rule; the implementation asserts this after each rewrite (a witnessed rewrite).

## 3. Proof of the composed theorem (the rules as a procedure N)

**N(G):** iterate {ρ-junk, ρ-pendant, ρ-loop, ρ-dup, ρ-wire, exclusion-0, ρ-comp} in that order, first applicable step, until none
applies (fixed point) or an exclusion halts; then apply R6 then R5′ (renamings). (`normalize.py` `step()` is this order.)

- **Termination.** μ = (c, |V|, #wires) is well-ordered lexicographically; the Δ column shows every non-exclusion step strictly
  decreases the first component that changes: ρ-comp, contact-loop, contact-dup (1st ↓); ρ-junk, ρ-pendant, ρ-wire (1st ≤, 2nd ↓ — for
  ρ-pendant on an isolated vertex and ρ-wire, the 1st is equal and the 2nd strictly drops); wire-loop, wire-dup (1st, 2nd equal, 3rd ↓).
  Re-entrancy (a step creating a redex of an earlier kind) is harmless: the argument is per step. The renamings are a separate,
  trivially terminating phase (two bijections). ∎
- **Fixed point ⇒ NF1–NF7.** Each NF clause has an inapplicable step or an unfired exclusion opposite it: NF6 ⇐ ρ-junk; NF5 ⇐ ρ-pendant;
  NF2 ⇐ ρ-loop; NF3 ⇐ ρ-dup; NF1 ⇐ ρ-wire and exclusion-1 (a wire on {a,b} would have fired it); NF4 ⇐ ρ-comp and exclusion-1;
  NF7 ⇐ exclusion-0. (With edges unordered — ledger L3.) ∎
- **Semantic preservation.** Every step's f-column; composed by induction on the (finite) number of steps. ∎
- **Cost.** Every step's c-column: never increases; composed likewise. ∎
- **Exclusions unreachable from a realizer.** T is preserved at every step; a realizer of A has T = A, non-constant; each exclusion's
  precondition forces T constant; contradiction. ∎
- **Lemma E (vertex bound).** In NF: NF1 makes every edge a contact; NF5 gives each of the |V|−2 internal vertices ≥ 2 contact
  incidences; NF7 gives each terminal ≥ 1; so 2c ≥ 2(|V|−2) + 2, i.e. **|V| ≤ c + 1 ≤ K + 1 = 13**. Parallel contacts only raise the
  left side. No isolated vertex survives (ρ-junk); no subdivision convention exists (there is no rule that *adds* a vertex). ∎
- **Cover-by-sweep.** The NF network lives on some V′ with 2 ≤ V′ ≤ 13; the sweep ran every such V′ at K = 12 (V=9 as 53 cubes, U11);
  the network is admitted at (V′, 12) by U1–U7 (NF1–NF7 + cost), at U9–U10 after R5′∘R6, and — for V′ = 9 — in exactly one cube. ∎

**Theorem (★).** Established by the above, with the vocabulary of §1. *What it does not say:* that the CNF is satisfied by the NF
representative — that is the middle arrow (`construct_assignment.py`, ADDENDUM 5), outside this commission's object and separately
audited; and it does not say anything about networks outside M₂ (auxiliary relays, multi-terminal outputs, transfer-contact discounts).

## 4. Global questions

**A. Totality.** N is defined on every finite network of §1 — any finite V ⊇ {a,b}, any finite multiset of undirected labelled edges
including loops, wires, duplicates, complementary parallels, isolated vertices, disconnected components. There is no input class on
which `step()` is undefined: each step is a test on finite data followed by deletion or quotient. **Total.**

**B. Semantic preservation.** f(N(G)) = f(G) for every G on which N reaches a fixed point; when N halts in an exclusion, f(G) is
constant and no NF representative is claimed. For the ≤12 claim only non-constant f matters. **Holds.**

**C. Cost non-increase.** c(N(G)) ≤ c(G): every step's c-column is ≤. **Holds.** (Strict decrease is not claimed and not needed.)

**D. Termination / cover.** Terminates (μ); the fixed point satisfies NF1–NF7 = U2–U5, U7 and NF6 ⊂ U12; after the renamings U9–U10; on
V=9 exactly one cube (U11); admitted at its own V by U13. The syntactic restrictions of the search are matched *exactly* on the
restriction side (U2–U5, U7, U9–U11) and the search is a superset on U12. **Holds.**

**Vertex bound, audited separately.** The only routes by which V could exceed 13 are (a) isolated or terminal-less vertices — removed
by ρ-junk; (b) a convention that subdivides edges — none exists in N or in the encoder; (c) a large number of degree-2 internal
vertices — bounded by Lemma E, since each costs at least one contact of its own on the incidence count. Lemma E's inequality uses only
NF1, NF5, NF7; it needs no simplicity assumption. **V ∈ {2,…,13} covers every NF realizer with ≤ 12 contacts.**

## 5. Counterexample ledger — every failed formulation the arc produced, preserved

| # | formulation (as first written) | what killed it | repair | status of the intended claim |
|---|---|---|---|---|
| **L1** | "R6 is sound jointly because the count vector is vertex-permutation-invariant" (relay 2, 09-07) | Astra: vertex invariance explains the *jointness*, not the *ordering's soundness*; vertex renaming cannot rescue a bad count vector | justification replaced by the S₄ automorphism of A on the table; jointness argued by π-then-σ; both toothed | survived (misjustified, not false) |
| **L2** | "the empty network is the fixed point of every constant-0 network" (`normalize.py` docstring, 09-07) | Astra: `a—x—v—x′—b` is constant 0, a fixed point, both terminals incident | claim withdrawn; exclusion-0 stated as *one structural branch*, not a characterization; the theorem never needed it | **false as stated**; theorem unaffected |
| **L3** | edges written (u, v, λ) in `COVER-THEOREM-0` §0 while NF3/NF4 quantified over unordered endpoints and ρ-dup/ρ-comp were written on ordered pairs | Astra: (u,v,x) and (v,u,x) violate NF3 but need not trigger ρ-dup as written — Lemma D invalid *as written* | edges undirected ({u,v}, λ) from §0; every precondition modulo endpoint swap; the encoder had (min,max) all along | intended theorem survived; **vocabulary was wrong** |
| **L4** | μ = (#contacts, #vertices) (`normalize.py`, first version) | the tooth: deleting a wire-loop left μ unchanged — `assert mu(nxt) < mu(cur)` failed on `('loop', (9,4), (9,4))` | third component #wires | termination argument was **incomplete**; repaired |
| **L5** | "μ non-increasing" (relay 4 wording) | Astra: non-increase does not give termination; the code asserted strict descent, the prose did not | prose corrected to strict per-step descent | wording |
| **L6** | admits-tooth fed Astra's 14 *with its two wires* into the wire-free CNF → "not admitted" | R1 had not been applied; the tooth bit its author | contract 9→a, 1→b first (R1 performed by hand) → admitted | tooth defect, not theorem defect |
| **L7** | "the hedge on p. 53 attaches to Fig. 32" (this chair, 09-07) | Astra from the published scan; confirmed on the typescript: antecedent Fig. 33 | erratum withdrawn before commit | outside the theorem; kept because the commission says preserve scars |
| **L8** | `run_one.sh` deleted verified proofs unhashed; the manifest glob `*.drat*` and `.gitignore` `*.log` hid the transcripts | Astra's parcel audit | `run_one_v2.sh`; witness-refs regenerated; transcripts force-added | evidence layer, not theorem |
| **L9** | **attempted counterexamples to each NF clause (this audit, §6)** | none found — each attempt is repaired by its rule at ≤ cost | — | see §6 |

## 6. The adversarial construction, attempted on paper — one attempt per restriction

The commission asks for a ≤12-contact realizer of A that violates a normal-form assumption *in a way that cannot be repaired
without increasing K*. For each restriction, the strongest attempt I could make and why it fails:

- **NF1 (wires).** Take any realizer and *subdivide* a contact with a wire: N′ has the same cost and one more vertex. Violates NF1;
  ρ-wire contracts it back at equal cost. To be unrepairable the wire would have to *carry function* — but a wire between distinct
  non-terminal vertices is always-closed, and Lemma B says identification preserves T. A wire on {a,b} makes T ≡ 1 ≠ A. **Fails.**
- **NF2 (loops).** A loop is never on a simple path (Lemma A). Deleting it cannot change T. **Fails.**
- **NF3 (duplicates).** Two copies of ({u,v}, x): any walk through one goes through the other. **Fails.**
- **NF4 (complementary parallels).** The tempting case: u and v are *both needed as distinct vertices* by other edges, and the pair
  x‖x′ is the only thing joining them. Contraction identifies them — could that create a new closed a–b path that did not exist? No:
  Lemma B's (⊆) direction lifts every quotient walk back to N by inserting the closed member of the pair, so every path in N/uv was
  already a path in N. The pair *is* a wire under every α. **Fails.** (If the pair joins a and b: T ≡ 1, not a realizer.)
- **NF5 (pendants).** A vertex v with one distinct neighbour u carrying x‖x′ to u, plus a loop: v is always connected to u, yet no simple
  a–b path can enter v and leave it (only one neighbour). Deleting v deletes contacts that never conduct on any simple path. The
  attempt that *looks* strongest — "v is a hub for many parallel contacts to u, each needed for some row" — fails because a path
  reaching v must return through u, which the path already visited. **Fails.**
- **NF6 (junk components).** A component without terminals cannot touch an a–b walk. **Fails.**
- **NF7 (terminal incidence).** A realizer of a non-constant f has both terminals incident (else T ≡ 0). **Fails.**
- **R5′ / R6 (renamings).** A network violating the lex or count order has a renamed twin in its orbit that satisfies both, at equal
  cost and — for R6 — equal function because A is symmetric. The only way this could fail is a target *not* S₄-symmetric; the encoder
  now refuses such targets by checking the table. **Fails for A.**
- **The cube partition.** A network whose count vector is not among the 53: it would need a zero count (impossible — A depends on
  every variable, so a realizer has ≥ 1 contact on each; checked) or Σ > 12 (excluded by K). **Fails.**
- **The vertex bound.** A realizer needing ≥ 14 vertices after normalization would need ≥ 13 contacts by Lemma E. **Fails.**
- **Outside M₂ (recorded, not a counterexample to ★).** An *auxiliary relay* (a coil driven by a sub-network, whose contacts are then
  used) can realize functions with fewer *contacts* at the price of a relay — this is not in M₂, and (★) is a statement about M₂.
  A transfer-contact cost convention (make+break on one relay sharing a node counted as one element) likewise changes the cost
  function. These are scope boundaries of the *model*, stated in §B of the report, not violations of the cover.

**Result of the adversarial construction: no counterexample found on paper.** Each attempt is caught by exactly the rule whose
inverse reading (table, last column) says it must be.

## 7. The bespoke enumerator — exhaustive on small domains (`tools/exhaustive_cover_tooth.py`)

Every multiset of ≤ E edges over (unordered pairs including loops) × (8 literals + wire) on V vertices — not a sample. For each
network: f on 16 rows; N(G) with every rewrite row-checked; for non-constant f: fixed point reached, f preserved, cost ≤, NF1–NF7
hold, |V| ≤ c+1; for constant f: only the matching exclusion may fire. Then the commission's question exhaustively on the domain:
*is every function's minimum cost attained by an NF network?* (a violation would be a realizer whose restriction cannot be repaired
without cost).

| domain | networks (exhaustive) | non-constant | violating ≥1 NF clause | functions seen | min cost not attained in NF | theorem-clause failures |
|---|---|---|---|---|---|---|
| V=2, E≤4 | 31,464 | 18,584 | 18,504 | 80 | **0** | **0** |
| V=3, E≤3 | 29,259 | 12,960 | 11,952 | 280 | **0** | **0** |
| V=3, E≤4 | 424,269 | 230,800 | 224,272 | 804 | **0** | **0** |
| V=4, E≤3 | 129,765 | 41,696 | 39,056 | 312 | **0** | **0** |
| V=3, E≤5 | 5,006,385 | 3,058,512 | 3,032,048 | 1,332 | **0** | **0** |
| V=4, E≤4 | 3,049,500 | 1,334,312 | 1,276,768 | 1,236 | **0** | **0** |

8.67 million networks, exhaustively; 4.70 million non-constant, of which 4.60 million violate at least one NF clause — the universe the
search does not walk directly — and for every one of them N produced an NF representative of ≤ cost with the same 16 rows, every
rewrite row-checked; for all 1,332 (resp. 1,236) distinct non-constant functions on the largest domains the minimum cost is attained
inside NF. Log: `evidence/cover-audit/exhaustive.log`. Scope of this evidence: small domains (the largest a 4-vertex, 4-edge world); it
is a check on the *composition* of the rules over every case that exists there, not a proof about 12-contact networks — those are
what the prose is for.

## 8. Status expression

```lisp
(normal-form-cover
  :object            "(★) — every M₂ realizer of S₄(1,3,4) with ≤12 contacts has an NF representative of ≤ cost on ≤13 vertices"
  :totality          :proved-in-prose           ; N is total on finite networks with loops, wires, multiplicity, isolated vertices
  :semantic-preservation :proved-in-prose       ; per rule (Lemma A / Lemma B / direct), composed by induction; witnessed per rewrite in code
  :contact-nonincreasing :proved-in-prose       ; every rule's Δc ≤ 0
  :termination       :proved-in-prose           ; μ = (c, |V|, #wires) lexicographic; strict descent per non-exclusion step (ledger L4)
  :vertex-cover      :proved-in-prose           ; Lemma E: |V| ≤ c+1 ≤ 13, from NF1+NF5+NF7 only; no subdivision or isolated-vertex route
  :cover-by-sweep    :proved-in-prose           ; admitted at its own V′ ∈ {2..13}; V=9 by exactly one of 53 cubes
  :symmetry          :proved-in-prose           ; R5′ lex-max (Astra's argument), R6 by S₄-invariance of A on the table, π-then-σ
  :outside-audit     (:by "Astra (GPT-6)" :date "2026-09-08" :result "all lemmas PASS after ledger L3")
  :exhaustive-teeth  (:domains ((2 4) (3 3) (3 4) (4 3) (3 5) (4 4)) :networks 8670642 :failures 0 :min-cost-gaps 0)
  :ledger            (L1 L2 L3 L4 L5 L6 L7 L8 L9)   ; every failed formulation kept; L2 false-as-stated, L3 vocabulary, L4 incomplete
  :not-covered       (:middle-arrow "NF representative ⇒ satisfying CNF assignment — separate object, ADDENDUM 5"
                      :outside-M2 "auxiliary relays; multi-terminal; transfer-contact cost conventions")
  :status            :proved-in-prose)
```

**Why `:proved-in-prose` and not `:conditional`.** The commission allows `:conditional` only "with named remaining premises." Within
the object (★) — normalization from an arbitrary M₂ network to the searched normal form, cost-non-increasing, within the vertex
cover — I find no remaining premise: every rule has a proof, the composition has a measure, the vertex bound has an inequality with
its three inputs named, and the outside audit found no counterexample after the vocabulary repair. The premise that *remains* for the
**global minimality claim** is the middle arrow (CNF satisfiability of the representative), which the commission explicitly places
outside this object; so this expression does not promote the global claim, and ADDENDUM 6's inscription stands unchanged:
*conditionally minimal in M₂, the sole non-kernel trust in the prose normalization/completeness arguments and their
explicit-assignment proof* — of which this audit discharges the *normalization* half to prose-proved, leaving the *completeness* half
where ADDENDUM 5 left it.

**Why not `:refuted` or `:blocked`.** No counterexample was found on paper or by exhaustion (§6, §7); no missing fact was identified.
**What would change this expression:** a network on which `normalize.py`'s row check raises; a fixed point violating NF1–NF7; a
non-constant function whose minimum cost is attained only outside NF on any domain the enumerator can walk; or a reader finding a
hole in Lemma A or Lemma B — the two places where the whole cover leans on ordinary graph theory.
