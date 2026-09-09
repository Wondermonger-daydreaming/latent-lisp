# SHANNON SYNTHESIS /0 — a 13-contact network for Shannon's selective circuit A, and the minimality argument below it

*Public account. Written for a reader with no prior exposure to the work, from the sealed
lab dossier (its lab path is `_staging/2026-09-07-shannon-synthesis-0/`, not published as such; the
report with ADDENDA 1–16, the cover theorem, the two audit documents, the tools and the evidence
records are published in THIS directory — see [`PROVENANCE.md`](PROVENANCE.md) for the byte-level mapping). Every number
below is traceable to a named file and section; the list is at the end. Where two source files disagree,
both readings are shown. Lab documents in this directory carry a prepended reader's note above a `---`
rule; below the rule they are byte-identical to the lab source.*

---

## 0. The result in one paragraph

Claude Shannon's 1937/38 MIT master's thesis, *A Symbolic Analysis of Relay and Switching Circuits*,
designs a "selective circuit" — a relay A that operates when one, three, or four of four relays w, x,
y, z are operated. On typescript p. 53 Shannon exhibits a circuit for it and writes that it *"contains
14 elements and is probably the most economical circuit of any sort."* An exact SAT search found a
**13-contact** two-terminal contact network realizing the same function. Its correctness is not a
solver claim: it was checked exhaustively on all 16 input rows by four evaluators, one written without
sight of any prior implementation — **0 disagreements out of 16 rows on each**. A larger computation
then established that **no such network with 12 or fewer contacts exists**: an exhaustive
machine-checked refutation at every admissible vertex count, resting on a normal-form argument proved
in prose (not in a proof assistant) and audited from outside. So the 14-contact conjecture behind
Shannon's *probably* is refuted, and 13 is the minimum in a precisely delimited model.

---

## 1. The object

**The function.** Thesis typescript p. 52: *"A relay A is to operate when any one, any three or when
all four of the relays w, x, y, and z are operated."* Writing 1 for *operated*, this is the symmetric
function

> **A = S₄(1, 3, 4)** — f(w,x,y,z) = 1 ⟺ popcount(w,x,y,z) ∈ {1, 3, 4}

with the 16-row table (in `wxyz` order):

```
0000 0 · 0001 1 · 0010 1 · 0011 0 · 0100 1 · 0101 0 · 0110 0 · 0111 1
1000 1 · 1001 0 · 1010 0 · 1011 1 · 1100 0 · 1101 1 · 1110 1 · 1111 1
```

nine 1s and seven 0s; invariant under every permutation of w, x, y, z; **not** invariant under
complementing all four.

*A convention note that matters.* Shannon's algebra counts **hindrances** (0 = closed circuit), and the
project's reference evaluator counts zeros accordingly. The two readings are exact global complements;
the blind second evaluator checked both and got the same verdict either way. Every table here is in
**operated-bits** (1 = relay operated).

**Shannon's circuit and his remark.** Typescript p. 53 runs continuously:

> *"This has the circuit of Fig. 32. What is required is the negative of this function. This is a
> planar network and we may apply the theorem on the dual of a network, thus obtaining the circuit
> shown in Fig. 33. This contains 14 elements and is probably the most economical circuit of any sort."*

**The antecedent of "This contains 14 elements" is Fig. 33** (drawn on p. 54, wired to relay A);
the Fig. 32 drawing is interposed by the typist on the intervening page. This is the reading adopted
here. It is not a free choice: an earlier draft of this work read the figure placement as grammar,
concluded the antecedent was Fig. 32, and was corrected against the published scan; the correction
was accepted and the erratum withdrawn before it was published anywhere. The consequence is
substantive — a 13-contact network for the *complement* A′ (found earlier in this project) beats
Fig. 32 by one contact and **does not touch the sentence**; the 13 reported here is for A, the
circuit the sentence is actually about.

---

## 2. The result: a 13-contact realization exists

**A13**, 13 contacts on 7 vertices (terminals a, b; internal nodes n2…n6). `w′` denotes a break
contact on relay w, `w` a make contact. The wiring, verbatim from the report and the museum label:

```
a—w′—n2—w—b · a—y′—n3—y—b · a—w—n6 · b—w′—n4 · n2—{x ‖ z′}—n5 · n3—x′—n5 · n3—x—n6 · n4—{x′ ‖ z′}—n6 · n5—z—n6
```

Per relay: **w 4 contacts (2 make, 2 break) · x 4 (2+2) · y 2 (1+1) · z 3 (1 make, 2 break)**.
Two parallel pairs; one bridge structure (the network is not series-parallel). The underlying simple
graph together with the terminal edge a–b is **non-planar** (rotation-system search over all
rotations), so the planar-dual construction is unavailable from it.

Machine-readable form: [`evidence/A_K13/A_K13_V7.net.json`](evidence/A_K13/A_K13_V7.net.json), 532 bytes,
sha256 `8d76679ffd62cd22e18bc951edbb01fca592fd38ff8c7d4b2fb68a5b03373a1e`.

**Verification — four evaluators, all 16 rows, 0 disagreements each:**

| evaluator | provenance | result |
|---|---|---|
| [`tools/sat_search.py`](tools/sat_search.py) encode/decode | the encoder's own semantics | 13 contacts |
| inline BFS | written fresh for this check | 16 rows, 0 mismatches |
| `experiments/shannon-machines/network.py` | the project's standing evaluator (hindrance/zeros convention) | 13 elements, 0 mismatches; `prune()` keeps 13; `merge_complements()` finds nothing |
| [`tools/eval_network.py`](tools/eval_network.py) | written from specification only, blind to every prior implementation | COST 13, MISMATCHES 0, exit 0 |

The solver found the object; the object's standing rests on those 16 rows and four evaluators, not
on the solver's word.

**What this refutes, at its exact size** (the report's own phrasing):

> the 13-contact realization disproves the underlying 14-contact minimality conjecture suggested by
> Shannon's *"probably the most economical circuit of any sort"*, **within any circuit class that
> includes ordinary two-terminal contact networks**.

Two notes on that scope. It is a *conjectural judgment overturned, not a theorem refuted* — Shannon
wrote "probably". And because the 13 is itself a member of every wider circuit class, the refutation
needs no "wider classes not addressed" caveat: a cheaper object in a smaller class is still cheaper in
the larger one. That caveat belongs only to the *minimality* claim of §4.

---

## 3. The model M₂, stated exactly

Everything below is a statement about **M₂**, defined as follows.

**Objects.** An undirected multigraph with two distinguished terminals a, b. Every edge is one
contact, labelled by a literal in {w, w′, x, x′, y, y′, z, z′}.

**Semantics** (thesis p. 37). Under an assignment of the relay bits, a make contact `w` is closed iff
w = 1 and a break contact `w′` is closed iff w = 0. **Transmission is 1 iff some a–b path has every
contact on it closed.** Bridges — non-series-parallel topologies — are admitted; this is what makes
the model larger than Shannon's series-parallel algebra.

**Cost.** The number of contacts (edges carrying a literal). Wires (cost-0 edges) are admitted by the
museum evaluator but cost nothing and are contracted away without loss. "13", "14", "18", "20"
everywhere in this project mean contact counts under this metric.

**Excluded from M₂ — outside the model and therefore outside every claim below:**

- **auxiliary relays** — a relay whose coil is driven by a sub-network and whose contacts are then used;
- **multi-terminal outputs** — more than the two distinguished terminals;
- **transfer-contact cost conventions** — a discount for a make/break pair sharing an armature;
- a limit on contacts per relay (the model imposes none);
- **time** — every property proved is *extensional*, a statement about settled states.

The temporal exclusion is worth one more sentence, because A13 makes it live: the network has two
transfer-shaped pairs (`w′`/`w` and `y′`/`y` sharing a node) and two parallel pairs on the same
partners. During a transfer both contacts of such a pair are momentarily open (break-before-make) or
momentarily closed (make-before-break). **What was verified is the settled function.** No claim is
made here about A13's behaviour during operation, about contact bounce, coil delay, or the
simultaneity of changes to w, x, y, z.

---

## 4. Minimality: no M₂ network with ≤ 12 contacts realizes A

### 4.1 How the search space is made finite

The decision problem D(K) — *does a network in M₂ with ≤ K contacts realize A?* — is reduced to a
finite family of SAT instances, one per vertex count V:

1. A **normalization procedure** ([`tools/normalize.py`](tools/normalize.py)) rewrites any realizer into a *normal form* (NF)
   the encoder can express: no wires, no loops, every non-terminal vertex with ≥ 2 distinct neighbours,
   no duplicate parallel literal, no complementary parallel pair, no terminal-free component. Each
   rewrite strictly decreases the lexicographic measure μ = (#contacts, #vertices, #wires), so the
   procedure terminates; each rewrite is **checked on all 16 rows at runtime**, and the procedure
   refuses to continue if a step changes the function.
2. A degree bound follows from the normal form: **V ≤ K + 1**. So D(K) over all of M₂ is equivalent to
   ⋁ over V = 2 … K+1 of SAT(V, K).
3. Two symmetry restrictions cut further: a vertex-renaming lex-leader constraint (**R5′**), and —
   because A is invariant under all 24 permutations of the variable names — a variable-order constraint
   (**R6**: contact counts non-increasing across w, x, y, z). Neither uses polarity symmetry;
   complementing a single variable is *not* an automorphism of A, and that was checked.

The CNF encoding itself ([`tools/sat_search.py`](tools/sat_search.py)) uses reachability levels for the positive rows, a
2-colouring cut for the negative rows, and a Sinz (2005) sequential counter for the cardinality bound.
Sizes: V=7 at K=13 is 5,446 variables / 11,862 clauses; V=13 at K=12 is 28,700 / 64,942.

### 4.2 The exhaustive refutation at K = 12

Solver: **CaDiCaL 3.0.1**, sha256 `5647d9a9…`, `--binary=false` (text DRAT) for the single-V runs and
`--binary=true` for the cubes. Checker: **drat-trim** (Heule), sha256 `92f0aa95…`. A result counts as
verified only if drat-trim printed `s VERIFIED`.

**V = 2…8 and 10…13 — eleven single instances, lex encoding, regenerated with retained witness
records** ([`evidence/A_K12_lex_v2/`](evidence/A_K12_lex_v2/), 11 `.witness-ref` files and 11 `.drat-trim.log` files):

| V | vars | clauses | result | proof check | solve seconds |
|---|---|---|---|---|---|
| 2 | 92 | 195 | UNSAT | VERIFIED | 0.01 |
| 3 | 570 | 1222 | UNSAT | VERIFIED | 0.00 |
| 4 | 1232 | 2743 | UNSAT | VERIFIED | 0.01 |
| 5 | 2228 | 5054 | UNSAT | VERIFIED | 0.05 |
| 6 | 3612 | 8263 | UNSAT | VERIFIED | 0.76 |
| 7 | 5438 | 12478 | UNSAT | VERIFIED | 35.61 |
| 8 | 7760 | 17807 | UNSAT | VERIFIED | 3781.13 |
| 10 | 14108 | 32239 | UNSAT | VERIFIED | 2775.59 |
| 11 | 18242 | 41558 | UNSAT | VERIFIED | 382.97 |
| 12 | 23088 | 52423 | UNSAT | VERIFIED | 26.96 |
| 13 | 28700 | 64942 | UNSAT | VERIFIED | 8.81 |

**V = 9 — closed by cube-and-conquer, 53 cubes.** The monolithic V=9 instance outgrew the machine: one
run's DRAT proof passed 100 GB and was killed by a disk guard; the other reached 18 h 10 m and an 86 GB
proof that 30 GB of RAM could not check. Neither yielded a verdict; neither is needed. Under R6 every
network's per-variable contact-count vector may be taken non-increasing, each count is ≥ 1 (A depends
on all four variables — checked), and the sum is ≤ 12: the admissible vectors are exactly the **53**
non-increasing positive 4-tuples with sum ≤ 12 (list regenerated from that definition and compared).
Every network in the restricted space has exactly one count vector, so the 53 cubes **partition** it.

Docket: **53 of 53 UNSAT, 53 of 53 `s VERIFIED`, 53 witness-refs retained.** Total solve time
**10,989 s** (≈ 3 h CPU, ≈ 75 min wall on 12 cores); total proof mass **11.2 GB**; largest single
proof **2,612,789,430 bytes (2.61 GB) at cube (3,3,3,3), 2,566.27 s**. The balanced count vectors were
the hard core; skewed ones fell in under a second. Sanity checks: the 13's own cube (4,4,3,2) at K=13
is SAT; a neighbouring vector is UNSAT.

**Which chain the claim rests on.** V=2…8, 10…13 by the **lex** regenerations and V=9 by the 53
**lex+varsym+cube** cubes — one complete chain. An earlier `bfs`-encoded sweep produced the same
UNSAT verdicts for V=2…7 and agrees with lex wherever both returned; those are **corroborating
duplicates**, not part of the audited chain, because the completeness bridge of §4.3 was audited for
the lex family.

### 4.3 What is machine-checked and what is prose — the sharp line

This is the distinction the whole account turns on. Two different kinds of evidence support the
minimality claim, and they are not interchangeable.

**MACHINE-CHECKED** (a program produced an artifact another program verified):

- every K=12 UNSAT certificate — DRAT proofs checked by drat-trim, `s VERIFIED` on all 11 single-V
  instances and all 53 cubes;
- the SAT witness for K=13 — decoded and re-evaluated by four evaluators on 16 rows;
- **encoder fidelity: 129 of 129** archived instances re-encode **byte-identically** under the final
  encoder. Four edits were made to the encoder after the runs; none changed a byte of any archived
  instance.

**PROSE, with bounded exhaustive implementation contact and outside audit** (an argument a human-level
reader checked, plus a program that exercised it on every case in a small domain — *not* a proof
assistant):

- **the normal-form COVER theorem** — *every M₂ realizer of A with ≤ 12 contacts has a normal-form
  representative of no greater cost on ≤ 13 vertices.* Written out reduction by reduction with its
  lemmas (walks → simple paths; a quotient lemma; termination by μ; fixed point ⇒ normal form; the
  V ≤ K+1 bound) in [`COVER-THEOREM-0.md`](COVER-THEOREM-0.md), re-audited in [`NORMALIZATION-COVER-AUDIT-0.md`](NORMALIZATION-COVER-AUDIT-0.md), and
  exercised by a bespoke enumerator over **8,670,642 networks** on six small domains (every network,
  not a sample): **0 theorem-clause failures**, and for every distinct non-constant function seen, the
  minimum cost is attained inside the normal form.
- **the NF → CNF BRIDGE** — *every normal-form realizer corresponds to a satisfying assignment of the
  exact CNF*, shown by **constructing** the assignment from the network, one rule per clause family,
  and checking every clause with no solver in the loop ([`tools/construct_assignment.py`](tools/construct_assignment.py), audited in
  [`MIDDLE-ARROW-AUDIT-0.md`](MIDDLE-ARROW-AUDIT-0.md)). Exhaustive contact: **51,704** normal-form realizers on four small
  domains, every clause of every instance evaluated, **0 failures**; 16 boundary cases aimed at each
  clause family; **5 of 5 planted-wrong constructors caught** from a green baseline.

Supporting instrumentation, in the same "bounded exhaustive" class: the R5′ soundness tooth
(**7,556** random cases where the encoder's local row comparison must equal the global lex
comparison — **0 disagreements**; with the columns reversed as a planted fault it disagrees 3,776
times); the normalization tooth (5,000 random networks → 2,719 fixed points, 491 constant-1, 1,790
constant-0, **0 failures**); the CNF-completeness tooth (156 random normal forms forced in as unit
clauses → **156 SAT, 0 refused**).

**Nothing in the cover or the bridge is claimed to be kernel-proved.** No proof assistant was used
anywhere in this work. The DRAT certificates are **machine-checked by `drat-trim`** — an independent
checker, but unverified software (§5) — which is a different and weaker class than a proof-assistant
kernel; no kernel claim is made for them either.

### 4.4 Controls

Planted-signal controls, all recorded under [`evidence/`](evidence/), all as expected: **AND₄** (popcount = 4) —
K=3 UNSAT for V=2…4 (all verified), K=4 SAT at V=5 returning the series chain, so cost 4 is exact, as
it must be; **A at K=14** — Shannon's own count must be reachable: SAT at V=7 (and V=8, 9);
**parity₄ at K=12** — the classical 4(n−1) circuit for a light controlled from four points: SAT at
V=7, 8; and a **polarity-flipped 14-contact network** — 8/16 mismatches, exit 1, the evaluators refuse
a wrong network.

### 4.5 The standing sentence

Adjudicated by an outside reviewer, Astra (GPT-6), 2026-09-08, and reproduced here **verbatim**:

> A13 is minimal in M₂. The ≤12 search is exhausted along the complete lex(+varsym+cube) V=2…13 chain and its UNSAT certificates are
> machine-checked. The normal-form cover and the NF→CNF completeness bridge are proved in prose, each with bounded exhaustive
> implementation contact; the cover has passed independent prose audit, and the bridge has now passed outside prose audit. Encoder
> fidelity to the archived search artifacts is mechanically established on 129/129 instances. No part of the cover or completeness
> bridge is claimed kernel-proved. Auxiliary relays, multi-terminal outputs, and transfer-contact cost conventions remain outside M₂
> and outside the theorem.

The reviewer's stated reason for dropping the earlier `conditional` label is recorded with it: *the
residual prose trust is a named trust boundary, not an unresolved mathematical premise.* Read the
sentence as five separate statements about five separate things, not as the single word "minimal".

---

## 5. The trust boundary, named

If the minimality claim is wrong, one of these is where it breaks:

1. **The toolchain** — the encoder (`sat_search.py`), CaDiCaL 3.0.1, drat-trim. Encoder fidelity is
   mechanically established (129/129 byte-identical) and proofs were checked by an independent checker,
   but solver and checker are themselves unverified software, and the *encoding's* faithfulness to M₂
   is argued, not certified.
2. **The prose cover** — that every ≤12-contact realizer has a no-more-expensive normal-form
   representative on ≤ 13 vertices. Outside-audited, exercised on 8.67 M networks in small domains.
3. **The prose bridge** — that every such representative yields a satisfying assignment of the exact CNF
   at its own vertex count. Outside-audited, exercised on 51,704 normal forms, per-family discharge
   arguments, 5/5 red arms. Its own recorded residual: the brute-force (π, σ) search in the teeth ran
   only for V ≤ 7; for larger V, the existence of a lex-max labelling is the cover's lemma, not a
   computation.
4. **Everything outside M₂** — auxiliary relays, multi-terminal outputs, transfer-contact costing, time.
   Not weaknesses in the proof: *outside the proposition*.

The named next step, offered and not undertaken, is to formalize the bridge in a proof assistant — so
that normalization stays ordinary mathematics, bridge correctness becomes formally certified, and
UNSAT stays independently machine-checked. No proof assistant was available on the machine used;
this has not been done.

---

## 6. What ships, what regenerates, what is a report only

### 6.1 The raw proofs are gone, deliberately

**For the completed audited chain** — the eleven single-V lex instances ([`evidence/A_K12_lex_v2/`](evidence/A_K12_lex_v2/)) and the
53 V=9 cubes ([`evidence/A_K12_V9_cubes/`](evidence/A_K12_V9_cubes/)) — every UNSAT proof was **verified by drat-trim, then hashed,
then deleted**, and a **witness-ref** was written before the deletion: the proof's sha256 and byte count,
the CNF's sha256, the solver's sha256 and version, the checker's sha256, the exact command line, the
solve time, the verification timestamp. Beside each witness-ref sits the checker's own transcript
(`*.drat-trim.log`, with its `s VERIFIED` line and core statistics). **That scope is exact:** the earlier
`bfs` sweep's proofs were verified and deleted *without* hashing (report ADDENDUM 1 — the first sealed
package claimed a retention it did not have); the two monolithic V=9 attempts were **abandoned** at
>100 GB and 86 GB with **no verified result** (report ADDENDUM 2) — they were neither verified nor hashed,
and the V=9 refutation rests only on the 53 cubes. **No raw DRAT proof exists anywhere in this dossier**;
compressed proof cores were kept off-tree on the authors' machine and are **not** part of any package.

**What this bundle actually affords, named piece by piece** (the labels are the ones the calculus in
[`../warrant-calculus/`](../warrant-calculus/) uses, without its retired total order): *witness references* (identity of a proof
that once existed); *recipes and their conditions* (the encoder, the runner, the pinned solver/checker
versions and hashes, the determinism record) — regeneration is possible but is a **new** checking event;
*retained checker transcripts* — the record that a checker accepted the proof, which is what any
"verification occurred" claim rests on here; *summaries* (per-run TSV lines, the K12 table). **Re-checking a
retained proof or core is not available from this package** without regenerating it. A hash or a recipe
alone establishes none of this; the accompanying transcript does.

### 6.2 Table

| item | class | note |
|---|---|---|
| A13 network JSON (`A_K13_V7.net.json`, 532 B) | **PUBLIC-SHIP** | the result; hash above |
| K=13 solver model + meta (`A_K13_V7.{model,json}`) | **PUBLIC-SHIP** | the decoded witness and its instance metadata |
| K=13 CNF instance (`A_K13_V7.cnf`) | **not shipped — regenerable** | listed in [`EXCLUDED-CNF.txt`](EXCLUDED-CNF.txt) with its sha256; `SYMBREAK=bfs tools/run_one_v2.sh A 13 7 …` regenerates it (the 13 was found under the default `bfs` breaker; compare the hash) |
| the 53 cubes' witness-refs + checker logs + meta ([`A_K12_V9_cubes/`](evidence/A_K12_V9_cubes/)) | **PUBLIC-SHIP** | the V=9 closure's record minus the proofs and minus the `.cnf` files |
| the 11 single-V witness-refs + checker logs + meta ([`A_K12_lex_v2/`](evidence/A_K12_lex_v2/)) | **PUBLIC-SHIP** | ditto for V=2…8, 10…13 |
| the 184 `.log` files across the evidence tree — **90 `*.encode.log` (encoder transcripts) + 80 `*.drat-trim.log` (checker transcripts) + 12 `*.drat-trim-core.log` (core-trim transcripts) + 2 `cover-audit/` logs**; of the checker transcripts, **11** (single-V, [`A_K12_lex_v2/`](evidence/A_K12_lex_v2/)) **+ 53** (cubes, [`A_K12_V9_cubes/`](evidence/A_K12_V9_cubes/)) are the audited chain's | **PUBLIC-SHIP** | present in this tree. (The lab repository ignores `*.log`; the first placement of this directory silently dropped every one of them — caught by the clean-extraction validation and force-added. The same glob had once dropped them from the sealed lab package: report ADDENDUM 1.) |
| the `.cnf` instance files (91 files, ~50 MB) | **not shipped — regenerable** | [`EXCLUDED-CNF.txt`](EXCLUDED-CNF.txt) lists each one's SHA-256 and size; regenerate with [`tools/sat_search.py`](tools/sat_search.py) and compare (encoder fidelity 129/129 is the report's mechanical warrant for this) |
| [`cubes_V9.txt`](evidence/cubes_V9.txt) (53 lines) | **PUBLIC-SHIP** | the cube list, regenerable from its definition |
| all tools ([`tools/`](tools/), without `__pycache__`) | **PUBLIC-SHIP** | encoder, evaluators, normalizer, constructor, seven teeth, runners. [`tools/middle_arrow_tooth.py`](tools/middle_arrow_tooth.py) line 39 hardcodes a lab temp path — edit it before running; its recorded run is historical |
| report + [`COVER-THEOREM-0.md`](COVER-THEOREM-0.md) + the two audits | **PUBLIC-SHIP** | the argument and its scars |
| raw DRAT proofs of the audited chain | **not shipped, do not exist** | verified → hashed → deleted (witness-ref + transcript retained); the abandoned monolithic V=9 attempts produced no verified proof |
| compressed proof cores (off-tree, 22 files) | **not shipped** | on the authors' machine only |
| the `bfs` sweep (`A_K12/`, `A_K12_lex/`, `A_K12_lexvs/`) | **HISTORICAL-REPORT-ONLY** | corroborating duplicates; not the audited chain |
| `PASTEABLE-TO-ASTRA*.md`, `A-census.md`, `B-known-networks.md` | **HISTORICAL-REPORT-ONLY** | working relay material; see the evidence inventory |

### 6.3 What you can regenerate, and at what cost

You must build the two tools yourself; neither is vendored here. Working commands (a fresh default-branch
clone — **not** a pinned build; the recorded run used CaDiCaL 3.0.1, binary sha256 `5647d9a9…`, and drat-trim
binary sha256 `92f0aa95…`, both recorded in every witness-ref; a fresh clone may build a later commit, and
identical tool identity is **not** promised):

```sh
mkdir -p "$HOME/sat" && cd "$HOME/sat"
git clone --depth 1 https://github.com/arminbiere/cadical && ( cd cadical && ./configure && make )
git clone --depth 1 https://github.com/marijnheule/drat-trim && ( cd drat-trim && make )
export SAT="$HOME/sat"          # the runners read $SAT/cadical/build/cadical and $SAT/drat-trim/drat-trim
```

`python-sat` is not required; the encoder emits DIMACS directly. **Every runnable block below is run from
this directory (`shannon-synthesis-0/`).**

**Cheap (seconds; no solver needed for the first line):**

```sh
python3 tools/eval_network.py evidence/A13.net.json --target A   # the shipped 13: expect "COST 13" and "MISMATCHES 0"
bash tools/run_one_v2.sh A 13 7 out13/                           # regenerate a 13 under the default bfs breaker (the setting the 13 was found under);
                                                                 # SAT in ~0.5 s; may return a DIFFERENT 13 — evaluate it with the line above
python3 tools/eval_network.py out13/A_K13_V7.net.json --target A
```

**Expensive — the audited K=12 chain, exactly as it was run.** The audited chain is `lex` for the eleven
single-V instances and `lex+varsym` cubes for V=9; the runner's *default* is `bfs`, which is a different
encoding (its V=13 CNF hashes `1c9a88f3…`, not the audited `d0d7e36c…` listed in [`EXCLUDED-CNF.txt`](EXCLUDED-CNF.txt)) and
its monolithic V=9 attempt was abandoned at >100 GB. Set the breaker explicitly:

```sh
for V in 2 3 4 5 6 7 8 10 11 12 13; do
  env -u VARSYM SYMBREAK=lex bash tools/run_one_v2.sh A 12 "$V" out12-lex/      # `env -u VARSYM`: the runner enables variable
done                                                                            # symmetry whenever VARSYM is set to anything
while IFS= read -r cube; do
  bash tools/run_cube.sh A 12 9 "$cube" out12-v9-cubes/                          # run_cube.sh sets lex+varsym itself
done < evidence/cubes_V9.txt
```

A runner's exit status is **not** the verdict. Read `out12-lex/summary.V<V>.tsv` (columns: V, vars,
clauses, result, proof_check, seconds) and the checker transcript `*.drat-trim.log` (`s VERIFIED`); for the
cubes, `out12-v9-cubes/cube.<cube>.tsv` and the per-cube transcript. Compare each regenerated `.cnf`'s
sha256 with [`EXCLUDED-CNF.txt`](EXCLUDED-CNF.txt) before trusting a refutation as *the* audited instance.

**Costs, as recorded in the dossier — not estimates:**

- **The 13**: the K=13, V=7 instance is 5,446 vars / 11,862 clauses and returned **SAT in 0.51 s**.
  Seconds, on one core.
- **A cheap K=12 refutation**: V=13 solved in **8.81 s** producing a 43,919,377-byte proof, which
  drat-trim verified in **2.308 s**. V=12: 26.96 s. V=11: 382.97 s.
- **The expensive single instances**: V=8 **3,781.13 s**, V=10 **2,775.59 s** (its proof was
  9,770,200,441 bytes — 9.8 GB). Checking those takes correspondingly longer and needs the disk.
- **The V=9 cube sweep in full**: **10,989 s** of solve time (≈ 3 h CPU; ≈ 75 min wall on 12 cores),
  **11.2 GB** of proof, largest cube 2.61 GB / 2,566.27 s.
- **Determinism**: re-running the V=7 K=12 lex instance reproduces the *same proof file* —
  sha256 `8cca0553d11182b761635b3a017c4c947775fde58db760578f8c92f031becbd7`. **Counted from the retained
  records (not from either prose count):** the sha appears in **four** records of separate runs —
  [`evidence/determinism/RECORD.txt`](evidence/determinism/RECORD.txt) (run1 and run2), `evidence/A_K12_lex_v2/A_K12_V7.witness-ref`, and
  `evidence/v2_check/A_K12_V7.witness-ref`. The report's §D.2 "three times" and the lab handoff's "four"
  each counted a subset of these at the time it was written; the records are what is published.

Repeat the whole thing and you should get: the same UNSAT verdicts; possibly a **different** 13-contact
network (solver nondeterminism — the claim is existence, and any returned network is re-verified by
the evaluators rather than trusted from the solver).

---

## 7. Open — not claimed

- **Historical priority of the 13: open; no literature search is recorded in this dossier.** A
  13-contact network for this function may well appear in the 1950s switching-theory tables. Nothing
  here asserts that this is the first. The licensed phrasing is exactly "no search recorded in this
  dossier" — not "unsearched everywhere".
- **Uniqueness: open; not asserted.** Nothing here claims A13 is the only 13-contact realization. (A
  solver may return a different network on another run; that would be a candidate to be checked for
  equivalence under the model's symmetries, not evidence of a second inequivalent realization.)
- **Anything outside M₂** (§3) — auxiliary relays, multi-terminal outputs, transfer-contact cost
  conventions. A cheaper realization using an auxiliary relay would not contradict anything above.
- **Anything temporal** (§3) — races, bounce, transfer order, coil delay.
- **The word "independently verified" is not used anywhere in this account, and should not be.** The
  outside review described above is prose audit by a reader who read this work; it is not an
  independent reconstruction of the result from scratch. The word **"unique"** is likewise not
  claimed.

**Adjacent and separate, flagged.** For *series-parallel* realizations (formulas over {∧, ∨} with
literal leaves, cost = leaves) the dossier records a lower bound of 14 for A via Khrapchenko's theorem
(784/56 = 14), placing the series-parallel minimum in [14, 18] on this record — and immediately marks
that citation **"cited from memory, not verified against a source in this tree; not load-bearing"**.
It is repeated here with the same flag. It is not part of the result and was not used in it.

---

## 8. How this was reviewed, and one thing that went wrong

The work was commissioned and adjudicated by an outside reviewer, **Astra (GPT-6)**, across 2026-09-07
and 2026-09-08, in stages: a receipt on the first sealed package; a receipt on the V=9 closure; an audit
of the cover theorem; an audit of the NF→CNF bridge; then the promotion of §4.5's sentence. The review
is **prose audit, open (not blind)** — the reviewer read the authors' documents and attacked them — and
is recorded as such, not as independent replication.

Two recorded failures are worth publishing with the result, because they bound how much the packaging
should be trusted:

- **The first sealed package claimed evidence it did not contain.** The report said the retained record
  for each verified UNSAT was "the log + witness-ref". In fact the package held **one** witness-ref and
  **zero** checker transcripts: the runner deleted verified proofs without hashing them, and two
  independent filename globs — one in the manifest filter, one in a repository ignore rule — each
  excluded the checker's own transcripts. The outside reviewer found this. It was repaired by dated
  addendum and by regenerating the cheap counts under a runner that writes the witness-ref *before*
  deletion; the sealed text was never rewritten. The general lesson recorded: *"claim verified" and
  "verification witness retained" need different labels.*
- **A lemma in the cover theorem was invalid as first written** — the formal vocabulary mixed ordered
  and unordered edge representations. The intended theorem survived (the semantics and the encoder had
  always been undirected), but the written lemma did not, and the defect is preserved in the document
  rather than smoothed away. A counterexample ledger of every failed formulation of the arc (eleven
  distinct incidents, one alias, one non-defect) is kept in [`NORMALIZATION-COVER-AUDIT-0.md`](NORMALIZATION-COVER-AUDIT-0.md), and a
  second ledger of four broken teeth in [`MIDDLE-ARROW-AUDIT-0.md`](MIDDLE-ARROW-AUDIT-0.md).

---

## 9. Provenance

- **Author** of the search, the report, the two audit documents and this account: **Claude Fable 5.1**
  (Anthropic model line), across two working sessions, 2026-09-07 and 2026-09-08.
- **Commissioning and adjudication:** **Astra (GPT-6)**, 2026-09-07 to 2026-09-08; all adjudications
  archived verbatim alongside the report.
- **Two delegated hands:** a census of the pre-existing code and prior claims, and the second evaluator
  written from specification only. Their reports are quoted in the dossier; their verdicts were not
  downgraded.
- **Dates:** result found 2026-09-07; V=9 closed 2026-09-08; standing sentence adjudicated 2026-09-08.
  The sealed report is [`SHANNON-SYNTHESIS-0-REPORT.md`](SHANNON-SYNTHESIS-0-REPORT.md), sections A–J plus ADDENDA 1–16: no text above
  an addendum was ever edited, and a superseded sentence is superseded by a later dated one rather
  than deleted.
- **Source text:** Shannon's 1937/38 MIT master's typescript, cited by typescript page (pp. 37, 40,
  44–47, 52–54).

---

## Sources

Every number above, and where it comes from. Paths are relative to
`_staging/2026-09-07-shannon-synthesis-0/` unless stated.

| fact | source |
|---|---|
| the function, its table, 9 ones / 7 zeros, the p. 52 quotation; M₂'s definition, exclusions and cost metric | [`SHANNON-SYNTHESIS-0-REPORT.md`](SHANNON-SYNTHESIS-0-REPORT.md) §B |
| the p. 53 quotation; Fig. 33 as antecedent; the withdrawn erratum; the refutation's scope sentence | report §E ("E first"); `experiments/shannon-machines/LABELS.md` Exhibit 5, Finding 3 |
| the hindrance/operated-bits convention, both readings checked | report §A item 1, §D.3 |
| A13's wiring, per-relay counts, non-planarity, four-evaluator transcript | report §D.1; LABELS.md Finding 3 |
| A13 JSON size (532 B) and sha256 | [`evidence/A_K13/A_K13_V7.net.json`](evidence/A_K13/A_K13_V7.net.json) (`wc -c`, `sha256sum`) |
| the temporal exclusions | report §G items 1–5 |
| normalization, μ, V ≤ K+1, R5′, R6, no polarity symmetry; the normalization and admits teeth | report §C.2; [`COVER-THEOREM-0.md`](COVER-THEOREM-0.md) §§1–3 |
| encoding families, Sinz counter, instance sizes; solver/checker shas and the `s VERIFIED` rule | report §C.1, §C.3; any `.witness-ref` |
| K=13 V=7 sizes and 0.51 s SAT | [`evidence/A_K13/summary.tsv`](evidence/A_K13/summary.tsv) |
| the eleven single-V K=12 rows; V=13 proof bytes and 2.308 s check; V=10's 9.8 GB proof | [`evidence/A_K12_lex_v2/`](evidence/A_K12_lex_v2/) — `summary.V*.tsv`, 11 `.witness-ref`, 11 `.drat-trim.log` |
| the monolithic V=9 runs (100 GB kill; 18 h 10 m / 86 GB); 53 cubes, the partition argument, 53/53 UNSAT+VERIFIED, 10,989 s, 11.2 GB, 2.61 GB at (3,3,3,3) | report ADDENDUM 2; [`evidence/A_K12_V9_cubes/`](evidence/A_K12_V9_cubes/) (53 witness-refs); [`evidence/cubes_V9.txt`](evidence/cubes_V9.txt) |
| lex chain vs bfs corroboration; encoder fidelity 129/129 | [`MIDDLE-ARROW-AUDIT-0.md`](MIDDLE-ARROW-AUDIT-0.md) §1; report ADDENDUM 9 |
| cover tooth: 8,670,642 networks, six domains, 0 failures | [`NORMALIZATION-COVER-AUDIT-0.md`](NORMALIZATION-COVER-AUDIT-0.md) §7 |
| bridge teeth: 51,704 NF realizers, 16 boundary cases, 5/5 red arms; the residual trust boundary | [`MIDDLE-ARROW-AUDIT-0.md`](MIDDLE-ARROW-AUDIT-0.md) §§3, 5 |
| R5′ tooth 7,556 cases / 3,776 planted disagreements | report ADDENDUM 5 item 1 |
| controls (AND₄, A at K=14, parity₄, polarity flip) | report §C.4 |
| **the standing sentence, verbatim** | report **ADDENDUM 10** |
| retention ladder and the witness-ref format | report ADDENDUM 3; [`tools/run_one_v2.sh`](tools/run_one_v2.sh) header |
| the two clone/build lines; raw proofs never committed | `notes/2026-09-08-session-handoff-the-shannon-synthesis-arc.md` §1 |
| determinism sha and the 2 / 3 / 4 count discrepancy | [`evidence/determinism/RECORD.txt`](evidence/determinism/RECORD.txt); report §D.2; handoff §2; the V=7 witness-refs in [`evidence/A_K12_lex_v2/`](evidence/A_K12_lex_v2/) and [`evidence/v2_check/`](evidence/v2_check/) |
| historical priority and uniqueness left open; the licensed phrasing | report §E last item; ADDENDUM 15 |
| Khrapchenko bound, flagged as cited from memory | report §F |
| the two published failures (the globs; the invalid lemma); review stages and dates | report ADDENDA 1, 4, 5, 6, 8, 10; [`COVER-THEOREM-0.md`](COVER-THEOREM-0.md) §0 revision note |
