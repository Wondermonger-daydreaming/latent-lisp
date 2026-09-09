#!/usr/bin/env python3
"""
construct_assignment.py — the BRIDGE (Astra, interim-4): every normalized realizer of f corresponds to a satisfying assignment
of the CNF — shown by CONSTRUCTING the assignment from the network and checking every clause, with no solver in the loop.

Construction (one rule per clause family of sat_search.encode):
  e[p][l]        := the network's contacts (exactly).
  c[t][p]        := some contact on p is closed under row t                         (exact OR)
  r[t][k][v]     := dist_t(a, v) <= k in the closed subgraph of row t              (BFS depth)
  tvar[t][k][u][v] := r[t][k-1][u] and c[t][{u,v}]                                 (exact AND)
  s[t][v]        := v reachable from a in the closed subgraph of row t             (the a-side of the cut)
  sinz s[i][j]   := at least j+1 true among xs[0..i]                               (exact prefix count)
  lex eq_k       := rows equal on the first k+1 positions                          (exact prefix equality)
  varsym s_[i][j]:= at least j true among xs[0..i]                                 (exact prefix count)
Why each family is satisfied (the prose the checker corroborates):
  c-equivalences: by definition.  reach: r[k][v] true ⇒ dist<=k ⇒ either dist<=k-1 (r[k-1][v]) or dist=k via some u with
  dist=k-1 and a closed {u,v} (tvar true); r[0][a] true, r[0][v≠a] false; r[V-1][b] true iff b reachable — which holds for
  every row where f=1 since the network realizes f and a simple path has <= V-1 edges.  cut: s[a] true; s[b] false on rows
  where f=0 (b unreachable); a closed edge never crosses the reachable set, so c → (s[u] ↔ s[v]).  cardinality: exact prefix
  counts satisfy Sinz's clauses when the total is <= K.  degrees: hold because the network is normalized (R2) and f is
  non-constant (terminals incident).  breakers: satisfied iff the network is presented in its canonical labelling — which
  is the separate group-action lemma (variable permutation first, vertex canonicalization second; vertex relabelling
  preserves variable counts).  This script applies that lemma by brute force for small V (or runs with no breakers).
Usage: construct_assignment.py NET.json [--target A|table:...] [--symbreak none|lex|bfs] [--varsym]  → checks all clauses
       construct_assignment.py --random N   → random networks → normalize → their own table, no breakers → all clauses
"""
import argparse, itertools, json, sys
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from sat_search import encode, LITS, assignments, closed_literals, target_fn
from eval_network import truth_table
from normalize import normalize, random_net, contacts, verts

def build(net_edges, V, target, K, symbreak, varsym):
    """net_edges: list of (u, v, lit) with u,v in 0..V-1. Returns (cnf, assignment dict var->bool, report)."""
    cnf, meta = encode(target, V, K, symbreak, varsym)
    val = {}
    # edges
    present = {(frozenset((u, v)), lit) for u, v, lit in net_edges}
    pair_of = {}
    for var, (u, v, lit) in meta["edge_vars"].items():
        val[int(var)] = (frozenset((u, v)), lit) in present
        pair_of[int(var)] = (u, v, lit)
    pairs = [(u, v) for u in range(V) for v in range(u + 1, V)]
    pidx = {p: i for i, p in enumerate(pairs)}
    def closed_adj(t):
        cl = {LITS[i] for i in closed_literals(t)}
        adj = {v: set() for v in range(V)}
        for u, v, lit in net_edges:
            if lit in cl: adj[u].add(v); adj[v].add(u)
        return adj, cl
    def bfs(adj):
        dist = {0: 0}; frontier = [0]
        while frontier:
            nxt = []
            for x in frontier:
                for y in adj[x]:
                    if y not in dist: dist[y] = dist[x] + 1; nxt.append(y)
            frontier = nxt
        return dist
    f = target_fn(target)
    for t in assignments():
        adj, cl = closed_adj(t)
        dist = bfs(adj)
        for i, (u, v) in enumerate(pairs):
            val[cnf.aux["c"][t][i]] = any((frozenset((u, v)), lit) in present for lit in cl)
        if f(t):
            r = cnf.aux["r"][t]
            for k in range(V):
                for v in range(V):
                    val[r[k][v]] = (v in dist and dist[v] <= k)
            for (k, u, v), tv in cnf.aux["t"][t].items():
                val[tv] = val[r[k - 1][u]] and val[cnf.aux["c"][t][pidx[(min(u, v), max(u, v))]]]
        else:
            for v in range(V):
                val[cnf.aux["s"][t][v]] = (v in dist)
    # sinz
    if cnf.aux["sinz"]:
        xs, s, k = cnf.aux["sinz"]
        cnt = 0
        for i, x in enumerate(xs):
            cnt += 1 if val[x] else 0
            for j in range(k): val[s[i][j]] = (cnt >= j + 1)
    # lex
    for (i, A, B, eqs) in cnf.aux["lex"]:
        eq = True
        for a_, b_, e in zip(A, B, eqs):
            eq = eq and (val[a_] == val[b_]); val[e] = eq
    # varsym
    for xs, s_ in cnf.aux["varsym"]:
        cnt = 0
        for i, x in enumerate(xs):
            cnt += 1 if val[x] else 0
            for j in range(len(s_[i])): val[s_[i][j]] = (cnt >= j)
    return cnf, val, meta

def check(cnf, val):
    unsat = []
    for cl in cnf.clauses:
        if not any((val[abs(l)] if l > 0 else not val[abs(l)]) for l in cl):
            unsat.append(cl)
    return unsat

def to_indexed(net):
    names = sorted(verts(net) - {"a", "b"}); m = {"a": 0, "b": 1, **{x: i + 2 for i, x in enumerate(names)}}
    return [(m[u], m[v], l) for u, v, l in net["edges"]], 2 + len(names)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("net", nargs="?"); ap.add_argument("--random", type=int, default=0)
    ap.add_argument("--target", default="A"); ap.add_argument("--K", type=int, default=0)
    ap.add_argument("--symbreak", default="none"); ap.add_argument("--varsym", action="store_true")
    a = ap.parse_args()
    if a.random:
        ok = bad = skipped = 0
        for seed in range(a.random):
            net, how = normalize(random_net(seed))
            tt = truth_table(net)
            if how != "FIXED-POINT" or len(set(tt.values())) < 2: skipped += 1; continue
            edges, V = to_indexed(net)
            bits = "".join(str(tt[t]) for t in assignments())
            cnf, val, meta = build(edges, V, "table:" + bits, contacts(net), "none", False)
            u = check(cnf, val)
            if u: bad += 1; print("UNSATISFIED CLAUSES", seed, len(u), u[:3], net)
            else: ok += 1
        print(f"bridge: {ok} normal forms → constructed assignment satisfies all clauses; {bad} failures; {skipped} skipped")
        print("PASS" if bad == 0 else "FAIL"); sys.exit(0 if bad == 0 else 1)
    net = json.load(open(a.net))
    net, how = normalize(net)
    edges, V = to_indexed(net); K = a.K or contacts(net)
    if a.symbreak != "none" or a.varsym:
        # apply the group-action lemma by brute force: variable permutation first, then vertex relabelling
        names = sorted(verts(net) - {"a", "b"})
        found = None
        for pi in itertools.permutations(range(4)):
            for perm in itertools.permutations(range(2, V)):
                m = {"a": 0, "b": 1, **dict(zip(names, perm))}
                ed = [(m[u], m[v], LITS[2 * pi["wxyz".index(l[0])] + (1 if l.endswith("'") else 0)]) for u, v, l in net["edges"]]
                cnf, val, meta = build(ed, V, a.target, K, a.symbreak, a.varsym)
                if not check(cnf, val): found = (pi, perm); break
            if found: break
        print(f"with breakers {a.symbreak}{' +varsym' if a.varsym else ''}: canonical (variable perm, vertex perm) found = {found}")
        sys.exit(0 if found else 1)
    cnf, val, meta = build(edges, V, a.target, K, "none", False)
    u = check(cnf, val)
    print(f"{a.net}: V={V} K={K} vars={cnf.n} clauses={len(cnf.clauses)} — constructed assignment satisfies {len(cnf.clauses) - len(u)}/{len(cnf.clauses)} clauses")
    sys.exit(0 if not u else 1)

if __name__ == "__main__":
    main()
