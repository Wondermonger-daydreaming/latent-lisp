*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source (blob hash in PROVENANCE.md; strip recipe there). This is a working record, written during the work in the lab's own idiom; the public account is `README.md` in this directory. Paths of the form `_staging/…`, `notes/…`, `corpus/voices/…`, `~/freezer/…`, `~/Downloads/…` and `/tmp/…/scratchpad/…` are lab or machine locations that are not published; the outside reviewer's (Astra's) letters are quoted verbatim where they are relied on. Raw DRAT proofs named here were verified, hashed and deleted and are not published; `.cnf` instance files are omitted from the public evidence tree (regenerable with `tools/sat_search.py`; each witness-ref records the CNF's SHA-256).*

---

# MIDDLE ARROW AUDIT /0 — NF → CNF completeness, by clause family

*Commissioned by Astra (GPT-6) through the owner, 2026-09-08 14:13 −03 ("open the first chalk door: kernelize the middle arrow";
verbatim `corpus/voices/received/originals/2026-09-08-141326-astra-commission-middle-arrow-kernelize-nf-to-cnf-VERBATIM.md`).
Chair: Claude Fable 5.1 [bce86e]. The SAT lane closed; the construction untouched; K, target, M₂ unchanged. Tooth:
`tools/middle_arrow_tooth.py`, log `evidence/cover-audit/middle_arrow_tooth.log`. Author's warning at the door, as in the cover
audit: the author of `sat_search.py` and `construct_assignment.py` is the auditor; the outside reading of this bridge so far is
Astra's code inspection in ADDENDUM 5 ("a genuine constructive prose proof mirrored by executable code"); an outside audit of THIS
document is pending and the status expression says so.*

**The object.** For every normal-form M₂ network admitted by the searched universe at its own V and K ≤ 12, if it realizes A,
`construct_assignment.py` produces a satisfying assignment for the exact CNF `sat_search.py` generates for that instance, every family
included. **Three claims that must not blur, and are kept apart throughout:**
- **(SC) semantic completeness** — *some* satisfying assignment exists for every admitted NF realizer;
- **(CC) constructor correctness** — `construct_assignment.py` produces one;
- **(EF) encoder fidelity** — the CNF the constructor targets is byte-for-byte the CNF the UNSAT runs consumed.
(CC) ⇒ (SC) constructively; (EF) is a fact about artifacts, established mechanically (§1) before any argument.

---

## 1. Encoder fidelity (EF) — mechanical, first

Every archived instance carries its `.json` meta (target, V, K, symbreak, varsym, cube) and its `.cnf`. Re-encoding each meta with the
**current** `sat_search.py` and hashing: **129 of 129 byte-identical** — the 53 V=9 cubes, every single-V lex instance (sealed and v2
regenerations), the lex+varsym instances, the sealed bfs instances, the controls, and the K=13 instance that produced the 13. Four
edits were made to the encoder after the runs (aux exposure for the constructor; `table:` targets; the R6 guard by table symmetry;
`--cube`); none changed a single byte of any archived instance. **How the constructor targets the exact encoder:** `build()` calls
`encode()` itself and reads variable ids from `cnf.aux` and `meta["edge_vars"]` — it assumes nothing about allocation order or
numbering; the CNF it checks is the one it just built, which by (EF) equals the archived one.

**A nuance fidelity surfaced.** The *sealed* V=2–7 refutations were `bfs`-encoded; the constructor's breaker handling (§3, R5′) is for
`lex`. The chain the minimality claim rests on is therefore the **lex(+varsym+cube)** family: V=2–8, 10–13 by the v2 lex regenerations
(witness-refs retained) and V=9 by the 53 lex+varsym cubes — all archived, all re-encoded identically. The bfs results stand as
corroborating duplicates for V=2–7 (and the two encodings' agreement at V=7/8/10 is itself a datum), but the bridge audited here is
the lex bridge, and the status expression names it.

## 2. The constructed assignment — one rule per family, with what it discharges

Notation: network N in NF on vertices {0..V−1}, a=0, b=1; row t ∈ {0,1}⁴; closed(t) = literals closed under t; E_t = closed edges;
dist_t(v) = BFS distance from a in (V, E_t) (∞ if unreachable); R_t = {v : dist_t(v) < ∞}.

| family (clauses in `encode`) | source semantic fact | constructed fragment | why every clause of the family is discharged | side conditions / invariants | failure mode this guards |
|---|---|---|---|---|---|
| **edge vars** `e[p][l]` (no clauses of their own) | the contact multiset | `e[p][l] := (({u,v}, l) ∈ E)` | — | edges read as unordered pairs (`frozenset`), matching the encoder's (min,max) canonicalization (cover ledger L3) | an ordered reading would miss an edge |
| **R4 pair clauses** `¬e[p][v] ∨ ¬e[p][v′]` | NF4: no complementary parallel | from `e` | at most one of the pair is true | NF4 (cover ρ-comp) | a complementary pair would violate |
| **closure** `c[t][p] ↔ ⋁_{l∈closed(t)} e[p][l]` | the closure rule (make iff bit 1; break iff bit 0) | `c[t][p] := ∃ l ∈ closed(t) with e[p][l]` | exact OR, both directions hold by definition | `closed_literals(t)` is the encoder's own list — the constructor imports it, so the closure rule cannot drift from the encoder's | a polarity convention mismatch |
| **positive rows, reach** `r[t][0][a]`; `¬r[t][0][v≠a]`; `¬r[t][k][v] ∨ r[t][k−1][v] ∨ ⋁_u tvar[t][k][u][v]`; `tvar → r[t][k−1][u]`; `tvar → c[t][uv]`; `r[t][V−1][b]` | N realizes f: f(t)=1 ⇒ an a–b walk in E_t ⇒ (Lemma A) a simple path of ≤ V−1 edges ⇒ dist_t(b) ≤ V−1 | `r[t][k][v] := dist_t(v) ≤ k`; `tvar[t][k][u][v] := r[t][k−1][u] ∧ c[t][uv]` | level 0: only a has dist 0. Step: if dist(v) ≤ k then dist(v) ≤ k−1 (first disjunct) or dist(v) = k, whence some u with dist(u) = k−1 and a closed {u,v} — that tvar is true. tvar's two implications hold by its definition. Requirement: dist_t(b) ≤ V−1 by the source fact | levels k = 0..V−1 as in the encoder; the constructor's BFS uses the same closed set `c` | a witness that is "reachable" but not at the claimed level (red arm r1 catches it) |
| **negative rows, cut** `s[t][a]`; `¬s[t][b]`; `¬c[t][p] ∨ ¬s[t][u] ∨ s[t][v]`; `¬c[t][p] ∨ s[t][u] ∨ ¬s[t][v]` | f(t)=0 ⇒ no a–b walk in E_t ⇒ b ∉ R_t | `s[t][v] := v ∈ R_t` | a ∈ R_t; b ∉ R_t by the source fact; a closed edge never leaves R_t (R_t is closed under closed edges), so c → (s_u ↔ s_v) | among the many separating cuts the constructor picks *a's reachable set* — always a valid one | a cut that a closed edge crosses (red arm r2) |
| **cardinality (Sinz)** `at_most_k(all edges, K)` | c(N) ≤ K | `s[i][j] := (#true among xs[0..i]) ≥ j+1` (exact prefix counts) | Sinz's clauses are satisfied by exact prefix counts whenever the total ≤ K: `¬x_i ∨ s[i][0]`, `¬s[i−1][j] ∨ s[i][j]`, `¬x_i ∨ ¬s[i−1][j−1] ∨ s[i][j]` hold by monotonicity of prefix counts; `¬x_i ∨ ¬s[i−1][k−1]` holds because if x_i were true with k already reached the total would exceed K | `xs` order = the encoder's edge-variable order (read from `cnf.aux["sinz"]`) | a counter fed the total instead of the prefix (red arm r3) |
| **degrees / neighbours (U7)** `⋁ inc[v]`; internal: `⋁(inc[v] ∖ {s})` ∀s; `⋁(edges of v to vertices ≠ u)` ∀u≠v | NF7 (terminals incident); NF5 (internals: ≥2 distinct neighbours ⇒ ≥2 incident contacts, and for every u some contact to a vertex ≠ u) | from `e` | direct | NF (cover theorem) | a pendant or isolated vertex |
| **R5′ lex** `eq_k ↔ eq_{k−1} ∧ (a_k ↔ b_k)`; `¬eq_{k−1} ∨ a_k ∨ ¬b_k` | the network is presented in its lex-max vertex labelling (cover: every orbit has one; Astra's argument) | `eq_k := rows equal on the first k+1 positions` (exact prefix equality) | the equivalences hold by definition; the ordering clause holds at the first differing position because the labelling is lex-max (a_k=1, b_k=0 there) and vacuously before | the rows are the encoder's (`cnf.aux["lex"]`), so the comparison order cannot drift; the labelling is found by brute force for V ≤ 7 in the teeth | eq forced true past a difference (red arm r4) |
| **R6 counters** `exact_unary` (both directions) and `¬u_next[j] ∨ u_this[j]` | c(w) ≥ c(x) ≥ c(y) ≥ c(z) after π (A is S₄-invariant on the table — the encoder now checks this) | `s_[i][j] := (#true among xs[0..i]) ≥ j` (exact) | both directions of the exact counter hold by definition; the ordering clauses hold because the counts are sorted | `xs` per variable = the encoder's list (both polarities) | a counter fed another variable's edges (red arm r5) |
| **cubes (V=9)** unit clauses `u[c]`, `¬u[c+1]` | the network's exact count vector, one of the 53 | from the exact counters | the counters are exact, so `u[c]` true and `u[c+1]` false | the cube equals the network's own counts (`through_breakers` computes them) | a network whose counts fall in no cube — impossible (cover corollary) |
| **exact V** (U1/U13) | the NF network has exactly V vertices, all used (NF5/NF7) | `to_indexed`: a→0, b→1, internals → 2..V−1 in sorted-name order, then σ | the instance is built for that V | the exhaustive teeth filter `len(verts) == V` | a network with fewer vertices presented at a larger V (it is admitted at its own V) |

**Auxiliaries constructed rather than read:** `c` (exact OR), `r` (BFS depth), `tvar` (exact AND), `s` (reachable set), Sinz `s[i][j]`,
lex `eq_k`, unary `s_[i][j]`. Each has a *canonical* value determined by the network — there is no choice the constructor could get
wrong except by computing the wrong function, and each has a red arm that plants exactly that wrong function.

## 3. Teeth (implementation contact — not the general proof)

- **X — exhaustive NF domains** (every NF network, own truth table, non-constant): V=3 E≤4: **6,448/6,448** through the plain CNF and
  **6,448/6,448** through lex+varsym+cube (for symmetric functions) / lex (otherwise), (π, σ) by brute force; V=4 E≤3: **688/688** both
  ways; V=4 E≤4: **44,568/44,568** plain (breakers skipped for time); V=5 E≤3: **0 NF networks exist** — an incidental confirmation of
  Lemma E (c ≥ V−1). Total 51,704 admitted NF realizers, every clause of every instance evaluated, **0 failures**.
- **B — boundary cases aimed at each family:** V=2 with each of the 8 literals alone (shortest path; every polarity) and with all four
  variables in parallel, both polarities; **V=13** with a 12-contact AND₄ chain — the longest simple path, reach level V−1 = 12, 29,624
  clauses; twin internal vertices (lex ties: rows equal, all eq true) plain and under lex; the 13 with its R6 tie (c_w = c_x = 4) and
  cube (4,4,3,2) through lex+varsym+cube, 21,612 clauses; a parity₄ 12-contact network on the cube boundary (Σ = 12), 20,104 clauses;
  two disjoint paths (negative rows with many separating cuts). **All satisfied.**
- **R — red arms** (planted wrong constructors on the canonical 13, lex+varsym+cube): reach ignoring the level; cut = all-but-b; Sinz fed
  the total; lex eq forced true; a counter fed the wrong variable — **5/5 caught** by the clause check, from a **green baseline**.
- **F — fidelity:** 129/129 (§1).

## 4. Ledger — every broken tooth this audit produced, kept

| # | what was written | what killed it | repair |
|---|---|---|---|
| **M-L1** | the red-arm harness built the 13 under the *identity* labelling and reported `base_ok=False` while still "catching" 5/5 | a red arm needs a green baseline; the identity labelling legitimately violates lex/varsym | the harness now uses the canonical (π, σ) = ((0,1,3,2), (3,4,5,6,2)) and the cube (4,4,3,2); baseline green, 5/5 caught |
| **M-L2** | the V=13 "longest path" chain cycled `LITS[(3i) mod 8]`, mixing w and w′ — **constant 0** | with no positive row the reach family is empty; the test was vacuous | positive literals cycling w,x,y,z: AND₄, row 1111 needs the full 12-edge path; 29,624 clauses satisfied |
| **M-L3** | (from the bridge tooth, 09-08 morning) `--varsym` asserted the target *by name* | random non-symmetric functions were refused as intended, but by the wrong mechanism | the guard now checks S₄-invariance on the table |
| **M-L4** | (from `admits_tooth`, 09-07) Astra's 14 fed to the wire-free CNF *with its wires* | R1 not applied; the tooth bit its author | contract the wires first — R1 performed by hand |

## 5. Status expression

```lisp
(nf->cnf-completeness
  :object   "every NF realizer admitted at its own V, K≤12 ⇒ construct_assignment.py yields a satisfying assignment of the exact CNF"
  :chain-audited          :lex+varsym+cube            ; V=2–8,10–13 lex (v2 regenerations); V=9 the 53 cubes — the chain the claim rests on
  :semantic-completeness  :proved-in-prose            ; constructively, from constructor correctness
  :constructor-correctness :proved-in-prose           ; one rule per family (§2), each with its discharge argument and its red arm
  :encoder-fidelity       (:mechanically-verified :instances 129 :byte-identical 129)
  :allocation-assumptions :none                       ; ids read from cnf.aux / meta; the checked CNF is the built CNF
  :bounded-exhaustive-teeth (:nf-networks 51704 :failures 0 :boundary-cases 16 :red-arms (5 5) :domains ((3 4) (4 3) (4 4) (5 3)))
  :independent-audit      (:this-document :pending  :prior "Astra 09-08, ADDENDUM 5: code inspection, ':proved-in-prose'")
  :ledger                 (M-L1 M-L2 M-L3 M-L4)
  :remaining-trust-boundary
     ("the per-family discharge arguments of §2 are prose, not kernel-checked"
      "brute-force (π,σ) only for V ≤ 7 in the teeth; for V > 7 the existence of a lex-max labelling is the cover's lemma, not a computation"
      "the bfs-encoded sealed refutations are not covered by this bridge; the claim rests on the lex chain, which covers every V")
  :status :proved-in-prose)
```

**What this licenses, and what it does not.** With the cover (`:proved-in-prose`, outside-audited) and this bridge (`:proved-in-prose`,
outside audit pending) and the certificates (machine-checked), the three arrows each have a named warrant. Whether the standing A13
inscription of ADDENDUM 6 may now be promoted is **Astra's adjudication, not this chair's** (the commission's step 2); the inscription
stands unchanged in this document. If promoted, the honest form is: *A13 is minimal in M₂ — the ≤12 search exhausted and
machine-checked; the normal-form cover and the NF→CNF bridge each proved in prose with bounded exhaustive contact, the cover
outside-audited, the bridge's outside audit pending; nothing in the chain is kernel-proved except the UNSAT certificates.* And what
would change this expression: any family for which the question *"why must an admitted realizer induce values satisfying this
family?"* cannot be answered from §2 — none was found; or a fidelity mismatch — none among 129; or an outside reader finding a hole in a
discharge argument.
