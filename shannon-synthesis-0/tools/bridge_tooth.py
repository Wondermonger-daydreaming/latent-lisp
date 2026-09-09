#!/usr/bin/env python3
"""
bridge_tooth.py — the middle arrow, audited (Astra, 2026-09-08 after the cover audit):
      NF network  --(construct_assignment)-->  satisfying assignment of the EXACT CNF (lex + varsym + cube).

(1) R5' claim: "the local row comparison IS the global edge-vector comparison under each adjacent internal transposition."
    For random edge-presence vectors on V vertices (8 labels per unordered pair, pairs ordered (u<v) lexicographically, labels
    in LITS order — the encoder's order), and each i in 2..V-2: compute  E >=_lex tau_i(E)  on the GLOBAL vector directly, and
    compare with  row(i) >=_lex row(i+1)  as sat_search.py builds the rows (cols u<i ascending, then u>i+1 ascending).  They must
    agree on every vector.  Red arm: a wrong row order (cols in the other order) must disagree somewhere.
(2) Property test through the actual cube CNFs: random multigraphs (loops, wires, multiplicity) -> normalize (16 rows checked per
    rewrite) -> NF -> apply pi (sort variable counts; the function is the network's own table, so we must permute the TABLE too —
    for the general test we therefore use targets that are the network's own function and only apply pi when the function is
    symmetric under it; for S4 targets pi is free) -> find sigma (brute force, small V) -> build the assignment for the
    lex+varsym+cube CNF of that V, K=contacts, cube=the network's count vector -> every clause must hold.
    Also run on the 13 (K=13) and on Astra's 14 (K=14, after R1) with their real cubes.
Exit non-zero on any failure.
"""
import itertools, random, sys
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from sat_search import encode, LITS, assignments
from construct_assignment import build, check, to_indexed
from normalize import normalize, random_net, contacts, verts
from eval_network import truth_table

def pairs_of(V): return [(u, v) for u in range(V) for v in range(u + 1, V)]

def global_lex_ok(E, V, i):
    """E: dict (u,v,l)->0/1 over pairs u<v, l in 0..7. True iff E >=lex tau_i(E) in the encoder's global variable order."""
    j = i + 1
    def sw(x): return j if x == i else i if x == j else x
    vec, tvec = [], []
    for (u, v) in pairs_of(V):
        for l in range(8):
            vec.append(E[(u, v, l)])
            a_, b_ = sorted((sw(u), sw(v)))
            tvec.append(E[(a_, b_, l)])
    return vec >= tvec

def row_ok(E, V, i, wrong_order=False):
    j = i + 1
    cols = [u for u in range(V) if u < i] + [u for u in range(V) if u > j]
    if wrong_order: cols = cols[::-1]
    def row(x): return [E[(min(x, u), max(x, u), l)] for u in cols for l in range(8)]
    return row(i) >= row(j)

def test_r5prime(n=3000, seed=3):
    rng = random.Random(seed); bad = 0; red_hits = 0; N = 0
    for _ in range(n):
        V = rng.randint(4, 7)
        E = {(u, v, l): (1 if rng.random() < 0.25 else 0) for (u, v) in pairs_of(V) for l in range(8)}
        for i in range(2, V - 1):
            N += 1
            if global_lex_ok(E, V, i) != row_ok(E, V, i): bad += 1
            if global_lex_ok(E, V, i) != row_ok(E, V, i, wrong_order=True): red_hits += 1
    print(f"R5' local-row == global-lex under tau_i: {N} (vector, i) cases, {bad} disagreements (must be 0); red arm (reversed cols) disagrees {red_hits} times (must be >0)")
    return bad == 0 and red_hits > 0

def canonical_with_breakers(net, target_bits, K, cube_needed=True):
    """find (pi, sigma) such that the lex(+varsym+cube, when the target is fully symmetric) CNF is satisfied by the constructed
    assignment; returns (found, clauses).  For a non-symmetric target only lex is used (R6 would be unsound there)."""
    names = sorted(verts(net) - {"a", "b"}); V = 2 + len(names)
    tt = {t: int(target_bits[i]) for i, t in enumerate(assignments())}
    symmetric = all(tt[t] == tt[tuple(t[pi[k]] for k in range(4))] for pi in itertools.permutations(range(4)) for t in assignments())
    for pi in (itertools.permutations(range(4)) if symmetric else [tuple(range(4))]):
        for perm in itertools.permutations(range(2, V)):
            m = {"a": 0, "b": 1, **dict(zip(names, perm))}
            ed = [(m[u], m[v], LITS[2 * pi["wxyz".index(l[0])] + (1 if l.endswith("'") else 0)]) for u, v, l in net["edges"]]
            c = [0, 0, 0, 0]
            for _, _, l in ed: c[LITS.index(l) // 2] += 1
            if symmetric and not (c[0] >= c[1] >= c[2] >= c[3]): continue
            cube = tuple(c) if (symmetric and cube_needed) else None
            cnf, meta = encode("table:" + target_bits, V, K, "lex", symmetric, cube)
            _, val, _ = build_with(cnf, meta, ed, V, "table:" + target_bits, K)
            u = check(cnf, val)
            if not u: return (pi, perm, cube), len(cnf.clauses)
    return None, 0

def build_with(cnf, meta, edges, V, target, K):
    """re-use construct_assignment.build but on a given encode() — build() calls encode itself, so call build directly."""
    return build(edges, V, target, K, meta["symbreak"], meta["varsym"]) if meta.get("cube") is None else build_cube(edges, V, target, K, meta["cube"])
    # (build() re-encodes with the same arguments, so the assignment is checked against a CNF identical to `cnf`)

def build_cube(edges, V, target, K, cube):
    # construct_assignment.build encodes without a cube; replicate with cube by monkeypatching encode's cube arg
    import construct_assignment as ca
    orig = ca.encode
    ca.encode = lambda t, V_, K_, sb, vs: orig(t, V_, K_, sb, vs, cube)
    try:
        return ca.build(edges, V, target, K, "lex", True)
    finally:
        ca.encode = orig

def test_bridge(n_nets=300, seed=5):
    ok = bad = skipped = 0
    for s in range(n_nets):
        net, how = normalize(random_net(s))
        tt = truth_table(net)
        if how != "FIXED-POINT" or len(set(tt.values())) < 2: skipped += 1; continue
        if len(verts(net)) > 7: skipped += 1; continue          # brute-force sigma only for small V
        bits = "".join(str(tt[t]) for t in assignments())
        found, ncl = canonical_with_breakers(net, bits, contacts(net))
        if found: ok += 1
        else: bad += 1; print("NO (pi,sigma) SATISFIES THE lex+varsym+cube CNF", s, net)
    print(f"bridge through lex(+varsym+cube where symmetric) CNFs: {ok} random NF networks admitted with a canonical (pi, sigma[, cube]); {bad} failures; {skipped} skipped")
    return bad == 0

if __name__ == "__main__":
    import json
    r1 = test_r5prime()
    r2 = test_bridge()
    A = "".join(str(int(sum(t) in (1, 3, 4))) for t in assignments())
    n13 = json.load(open(__file__.rsplit("/", 2)[0] + "/evidence/A_K13/A_K13_V7.net.json"))
    f13, c13 = canonical_with_breakers(normalize(n13)[0], A, 13)
    print(f"the 13 through lex+varsym+cube (K=13): canonical found = {f13}, clauses {c13}")
    n14 = json.load(open(__file__.rsplit("/", 2)[0] + "/evidence/astra_A_14.net.json"))
    f14, c14 = canonical_with_breakers(normalize(n14)[0], A, 14)
    print(f"Astra's 14 (after R1) through lex+varsym+cube (K=14): canonical found = {f14}, clauses {c14}")
    ok = r1 and r2 and bool(f13) and bool(f14)
    print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)
