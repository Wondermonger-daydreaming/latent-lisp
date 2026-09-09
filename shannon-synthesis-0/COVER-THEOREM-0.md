*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source (blob hash in PROVENANCE.md; strip recipe there). This is a working record, written during the work in the lab's own idiom; the public account is `README.md` in this directory. Paths of the form `_staging/…`, `notes/…`, `corpus/voices/…`, `~/freezer/…`, `~/Downloads/…` and `/tmp/…/scratchpad/…` are lab or machine locations that are not published; the outside reviewer's (Astra's) letters are quoted verbatim where they are relied on. Raw DRAT proofs named here were verified, hashed and deleted and are not published; `.cnf` instance files are omitted from the public evidence tree (regenerable with `tools/sat_search.py`; each witness-ref records the CNF's SHA-256).*

---

# COVER THEOREM /0 — the normal-form cover, stated reduction by reduction, for attack

*2026-09-08, Claude Fable 5.1, after Astra's receipt for ADDENDUM 2 ("the only material open axis: generality of the cover"; "attack the
normalization-cover theorem reduction by reduction"). This is the prose the code `tools/normalize.py` executes, written as a theorem
with its invariants exposed, so that it can be refuted as mathematics. Nothing here changes any datum's status: the cover stays
`:procedure-witnessed` until a reader other than its author fails to break this text, and `:proved` only if a kernel says so.*

## 0. Objects

**Network.** N = (V, E, a, b): a finite vertex set V with two distinguished distinct terminals a ≠ b; E a finite *multiset* of
**undirected** labelled edges e = ({u, v}, λ) — the endpoint set is unordered, {u, u} allowed (a loop) — with label
λ ∈ L ∪ {wire}, L = {w, w′, x, x′, y, y′, z, z′}. Vertices may be isolated. *(Revised 2026-09-08T12:41:12-03:00 after Astra's audit: the first text wrote
(u, v, λ) and quantified NF3/NF4 over "unordered endpoints" while writing ρ-dup/ρ-comp on ordered pairs — a typing splinter that
broke Lemma D as written, not the theorem; the encoder already canonicalizes every pair as (min, max). Every "(u, v, λ)" below is
read as ({u, v}, λ), and every reduction precondition is modulo endpoint interchange.)*

**Closure.** For an assignment α ∈ {0,1}⁴ (operated bits), an edge is *closed* iff λ = wire, or λ = v (make) and α_v = 1, or
λ = v′ (break) and α_v = 0. E_α ⊆ E is the closed sub-multiset.

**Transmission.** T_N(α) = 1 iff there is a walk from a to b in (V, E_α); else 0. **Realizes f:** T_N = f pointwise on {0,1}⁴.

**Cost.** c(N) = number of edges with λ ∈ L (contacts). Wires are free.

**Measure.** μ(N) = (c(N), |V|, #wires(N)) ∈ ℕ³, ordered lexicographically — a well-order, so any strictly μ-decreasing sequence is finite.

**Normal form NF.** N is in NF iff: (NF1) no wire; (NF2) no loop; (NF3) no two edges with the same unordered endpoints and the same
label; (NF4) no two edges with the same unordered endpoints and complementary labels v, v′; (NF5) every vertex other than a, b has at
least two *distinct* neighbours; (NF6) every connected component of the underlying graph contains a or b; (NF7) a and b each have at
least one incident edge. (NF1–NF7 are exactly the restrictions `sat_search.py` imposes: R1–R4, the degree/neighbour clauses, and
connectivity-or-superset per breaker; NF7 is the terminal-degree clause.)

**The two relabellings** (not part of NF; applied after): R5′ chooses vertex names for V \ {a,b}; R6 chooses variable names. Both are
bijective renamings and change no property NF1–NF7, no cost, and — for R6 — no function, because f = S₄(1,3,4) is invariant under
every permutation of {w,x,y,z} (checked on all 16 rows for all 24 permutations, `symmetry_tooth.py`).

## 1. Two lemmas everything rests on

**Lemma A (walks → simple paths).** If (V, E_α) has an a–b walk, it has an a–b *simple path* (no repeated vertex). *Proof.* Take a
shortest a–b walk; a repeated vertex would allow a shortcut. ∎

**Lemma B (quotient).** Let u ≠ v and suppose for *every* α, u and v are in the same component of (V, E_α) *via an edge set S ⊆ E
incident only to u,v* that is closed under every α — concretely S = {a wire (u,v)} or S = {(u,v,x), (u,v,x′)}. Let N/uv be N with u
and v identified into one vertex and S deleted (other edges keep their endpoints, renamed; edges between u and v not in S become loops).
Then T_{N/uv} = T_N pointwise. *Proof.* Fix α. (⊆) An a–b walk in N/uv lifts to N: each edge of N/uv is an edge of N; where two consecutive
lifted edges meet at the merged vertex but in N one ends at u and the next starts at v (or vice versa), insert the closed edge of S
between them — S contains a closed edge under α by hypothesis. The result is an a–b walk in (V, E_α). (⊇) An a–b walk in N maps
edge-by-edge to N/uv; edges of S — and any other u–v edge — map to loops at the merged vertex, and every loop or zero-length repetition
so produced is deleted from the image walk, which remains an a–b walk in N/uv (loops never affect endpoint connectivity). (If u or v is a
terminal, the merged vertex inherits the terminal's name; if {u,v} = {a,b} the hypothesis makes T_N ≡ 1 — see §2, exclusions.) ∎

## 2. The reductions, each as an existence-preserving step with its μ-descent

Each step ρ takes N with T_N = f and c(N) ≤ K and returns N′ with **T_{N′} = f, c(N′) ≤ c(N), μ(N′) < μ(N)**, or halts in an
*exclusion branch* that shows T_N is constant (hence N was not a realizer of the non-constant f — a contradiction with the premise,
so the branch is never taken from a realizer).

| step | precondition | action | T preserved because | μ descent |
|---|---|---|---|---|
| **ρ-junk** | a component C of the underlying graph with a, b ∉ C | delete C and its edges | every a–b walk stays inside a's component; C is disjoint from it | \|V\| drops by \|C\| ≥ 1 (contacts drop or stay) |
| **ρ-pendant** (R2) | v ∉ {a,b} with at most one distinct neighbour (loops and multiplicity ignored) | delete v and all edges at v | by Lemma A a closed a–b walk yields a closed simple path; an internal vertex of a simple path has two distinct neighbours on it; so no simple a–b path uses v; the simple paths of N − v are those of N | \|V\| drops by 1; contacts drop by deg_L(v) ≥ 0 |
| **ρ-loop** | an edge (v, v, λ) | delete it | a loop is on no simple path (Lemma A) | contacts −1, or wires −1 if λ = wire |
| **ρ-dup** (R3) | two edges (u, v, λ), (u, v, λ) with the same λ | delete one | any walk using the deleted copy uses the kept one instead | contacts −1, or wires −1 |
| **ρ-wire** (R1) | an edge (u, v, wire), u ≠ v, {u,v} ≠ {a,b} | N/uv with S = {that wire} | Lemma B | \|V\| −1 (contacts equal; wires −1) |
| **ρ-comp** (R4) | edges (u, v, x), (u, v, x′), u ≠ v, {u,v} ≠ {a,b} | N/uv with S = the pair | Lemma B (exactly one of the pair is closed under each α) | contacts −2, \|V\| −1 |
| **exclusion-1** | a wire or complementary pair on {a,b} | halt | T_N ≡ 1 by Lemma B's hypothesis applied to a,b | — |
| **exclusion-0** | a or b has no incident edge | halt | no a–b walk under any α: T_N ≡ 0 | — |

Every non-exclusion step strictly decreases μ (third column: the first component that changes, decreases). Hence:

**Lemma C (termination).** From any N, iterating "apply the first applicable step (in the table's order)" reaches, in finitely many
steps, either an exclusion branch or a network N* to which no step applies. ∎

**Lemma D (fixed point ⇒ NF).** If no step applies to N* and no exclusion fired, then N* satisfies NF1–NF7. *Proof.* NF6 ⇐ ρ-junk
inapplicable. NF5 ⇐ ρ-pendant inapplicable. NF2 ⇐ ρ-loop. NF3 ⇐ ρ-dup. NF1 ⇐ ρ-wire inapplicable and exclusion-1 not fired (a wire on
{a,b} would have fired it). NF4 ⇐ ρ-comp and exclusion-1 likewise. NF7 ⇐ exclusion-0 not fired. ∎

**Lemma E (the bound).** In NF, c(N*) ≥ |V| − 1. *Proof.* Sum of contact-degrees = 2c(N*). Each non-terminal vertex has ≥ 2 distinct
neighbours, hence ≥ 2 incident contacts (NF1: no wires, so every edge is a contact); each terminal ≥ 1 (NF7). So 2c ≥ 2(|V| − 2) + 2. ∎

## 3. The theorem

**Theorem (normal-form cover).** Let f : {0,1}⁴ → {0,1} be non-constant and K ≥ 1. If some network N realizes f with c(N) ≤ K, then
some network N* in NF realizes f with c(N*) ≤ K and |V(N*)| ≤ K + 1.

*Proof.* Run the procedure of §2 from N. Since T_N = f is not constant, neither exclusion branch can fire (each would prove T_N
constant, and every step preserves T, so T stays f throughout). By Lemma C the procedure halts at a fixed point N*; by Lemma D, N* ∈ NF;
T_{N*} = f by the table's fourth column applied at every step; c(N*) ≤ c(N) ≤ K by the fifth; |V(N*)| ≤ c(N*) + 1 ≤ K + 1 by Lemma E. ∎

**Corollary (with the relabellings).** For f = S₄(1,3,4): N* may further be taken with c(w) ≥ c(x) ≥ c(y) ≥ c(z) (R6: rename
variables by the permutation sorting the counts; f is S₄-invariant) and, after that, with internal vertices numbered so that the
lex-leader constraint R5′ holds (R5′: choose the lex-max edge vector in the vertex-renaming orbit; renaming vertices preserves the
per-variable counts, so R6 survives — Astra's π-then-σ). Neither renaming changes NF1–NF7, c, or T.

**Corollary (cubes).** Every N* as above has a count vector (c_w, c_x, c_y, c_z) that is non-increasing, with each c_v ≥ 1 (f depends
on every variable: for each v there is an α with f(α) ≠ f(α with v flipped) — checked; a network with no contact on v computes a
function independent of v) and Σ c_v = c(N*) ≤ K. For K = 12 these are exactly the 53 vectors of `cubes_V9.txt`.

**Corollary (what UNSAT licenses).** Suppose for every V ∈ {2, …, K+1} the CNF `encode(f, V, K, lex, varsym)` — or, for one V, every
cube-CNF over the admissible count vectors — is unsatisfiable. If some N realized f with c(N) ≤ K, the Theorem and Corollaries give
an N* in NF with the relabellings, on some V ≤ K+1 vertices, with some admissible count vector; **CNF completeness** (the explicit
assignment construction, `construct_assignment.py`, §H of the report: edge variables from E(N*), c as the exact closed-OR, reach
levels as BFS depth ≤ k, cut sides as a's reachable set, counters as exact prefix counts, lex/varsym auxiliaries as exact prefix
equalities/counts) yields a satisfying assignment of that instance — contradiction. Hence no such N exists.

## 3½. Audit record
*2026-09-08T12:41:12-03:00 — Astra (GPT-6) attacked this note reduction by reduction and across the theorem→CNF seam (archived
`corpus/voices/received/originals/*astra-audit-of-cover-theorem-0-VERBATIM.md`): NORMALIZATION REDUCTIONS PASS UNDER PROSE AUDIT ·
TERMINATION PASS · FIXED POINT ⇒ NF PASS (after the undirected-edge patch above) · V ≤ K+1 PASS · R6/CUBE COVER PASS · NO NORMALIZATION
COUNTEREXAMPLE FOUND. Not promoted to kernel-proved. The live axis moved to the middle arrow — NF representative → exact SAT assignment
(`construct_assignment.py` × R5′ × the generated cube CNFs) — audited next in `tools/bridge_tooth.py`.*

## 4. Where to strike (the author's own list, so the reader need not find the doors)

1. **Lemma B's lifting step** is the only place the argument touches multi-edges and terminals at once. Cases to test: u or v a terminal
   (merged vertex keeps the terminal name — is `contract()` in `normalize.py` doing exactly that? it swaps to keep the terminal: line
   `if drop in (a, b) and keep not in (a, b): keep, drop = drop, keep`); *both* terminals (excluded to exclusion-1 — is the
   exclusion checked *before* the contraction in every path of `step()`? yes for ρ-wire and ρ-comp; **check ρ-dup and ρ-loop cannot
   create a terminal-pair wire that then escapes** — they only delete).
2. **ρ-pendant and multiplicity.** The predicate is "≤ 1 *distinct* neighbour", computed ignoring loops and multiplicity
   (`neighbours()` discards v itself). A pendant carrying a parallel pair x‖x′ to its one neighbour is still deleted — legitimately,
   by Lemma A. Does any *realizer* need such a vertex? No: it lies on no simple a–b path.
3. **Order of steps and re-entrancy.** The procedure applies "the first applicable step"; a contraction may create loops, duplicates,
   complements, or pendants — all handled on later iterations; the μ-argument is per step, independent of order. But **μ must strictly
   decrease on every step**: the only delicate rows are ρ-loop/ρ-dup on a *wire* (contacts unchanged, |V| unchanged, wires −1 — the
   third component, added after the tooth found the gap) and ρ-junk on an isolated vertex (|V| −1, contacts 0).
4. **The NF ↔ CNF correspondence.** NF6 (no junk component) is *not* imposed by the `lex` CNF (superset space — harmless for UNSAT);
   NF7 is imposed (terminal degree ≥ 1); NF5 is imposed as "≥ 2 distinct neighbours" — **matches ρ-pendant's predicate exactly**, which
   is the point Astra pressed. Check the CNF's NF5 clause set encodes *distinct neighbours* and not multigraph degree: it does
   (`for u: clause = OR of edges of v to vertices ≠ u`).
5. **R6's premise c_v ≥ 1** uses "f depends on v"; a network could have contacts on v that are all *dead* (never on a closed simple
   path) — then c_v ≥ 1 still holds, so the cube list is not narrowed by that; and a network with *no* contact on v cannot realize a
   v-dependent f. Fine. But the cubes assume the counts are *exact* on the unary counters — `exact_unary` is two-directional (checked).
6. **Cost model.** Wires free, contacts 1 each, no transfer-contact discount. If a reader's model counts a make+break pair on one relay
   sharing a node as *one* element, the theorem's cost function differs from theirs and the 13/12 numbers do not transfer. Named as a
   scope condition, not a defect.

*What a refutation would look like:* a concrete network N realizing S₄(1,3,4) with ≤ 12 contacts on which some step changes T
(run `normalize.py` on it — the row check would raise), or a fixed point violating an NF clause, or a satisfying assignment the
construction fails to produce. Any of these voids ADDENDUM 2's derived datum and leaves the 13 standing.
