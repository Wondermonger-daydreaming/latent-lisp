#!/usr/bin/env python3
"""
sat_search.py — exact search for a two-terminal contact network with <= K contacts realizing a
Boolean function of w,x,y,z, as a CNF instance per vertex count V.  (SHANNON SYNTHESIS /0, 2026-09-07.)

MODEL (Shannon 1938, ts. p. 37 rule): an undirected multigraph on V vertices, terminals a=0 and b=1,
every edge one contact labelled by a literal in {w,w',x,x',y,y',z,z'}.  Under an assignment of the
relay bits (1 = operated), a make contact `w` is closed iff w=1, a break contact `w'` iff w=0; the
network is closed (transmission 1) iff some a-b path has every contact closed.  Cost = number of
contacts.  No auxiliary relays, no wires, no multi-terminal, no time.

WITHOUT LOSS OF GENERALITY (each reduction preserves the function and never adds a contact, so
"exists a network with <= K contacts" is unchanged):
  R1 no wires                     — a wire is contracted (merge its two vertices).
  R2 no isolated / pendant        — a non-terminal vertex adjacent to <= 1 other vertex lies on no
                                    simple a-b path; delete it and its edges.
  R3 no duplicate parallel edge   — same pair, same literal: delete one.
  R4 no complementary parallel    — same pair, X and X': always closed = a wire; R1.
  R5 connected, and non-terminal vertices numbered in an order where each vertex 2..V-1 is adjacent
     to a lower-numbered vertex (a BFS order from a exists for any connected graph; vertices are
     interchangeable, so WLOG).
  After R2 every non-terminal vertex has degree >= 2, so 2K >= 2(V-2) + 2, i.e. V <= K+1.  Running
  every V in 2..K+1 is therefore exhaustive over the model.

ENCODING
  e[p][l]      edge on unordered pair p with literal l
  c[t][p]      <-> OR_{l closed under assignment t} e[p][l]          (both directions)
  f(t)=1:      reach levels r[t][k][v], k=0..V-1; r[t][0][a]=T, r[t][0][v!=a]=F;
               r[t][k][v] -> r[t][k-1][v]  OR  OR_u ( r[t][k-1][u] AND c[t][{u,v}] )  ; require r[t][V-1][b]
  f(t)=0:      cut sides s[t][v]; s[t][a]=T, s[t][b]=F; c[t][p] -> (s[t][u] <-> s[t][v])
  |e| <= K     sequential counter (Sinz 2005)
  degrees      terminals >= 1 edge; non-terminals >= 2 edges and >= 2 distinct neighbours (R2)
Only the "if r then justified" direction is needed for reach (the requirement r[V-1][b] forces a
genuine path); the cut encoding is exact (a closed path exists iff no such 2-colouring exists).

USAGE
  sat_search.py encode --target A --V 9 --K 13 --out inst.cnf [--meta inst.json]
  sat_search.py decode --meta inst.json --model model.txt --out net.json   # model.txt = cadical 'v' lines
  sat_search.py truth --target A                                           # print the 16 rows
Targets: A  = popcount(w,x,y,z) in {1,3,4}   (Shannon's selective circuit, S4(1,3,4))
         Aprime = popcount in {0,2}          parity4 = odd popcount     and4 = popcount 4
"""
import argparse, itertools, json, sys

VARS = ["w", "x", "y", "z"]
LITS = ["w", "w'", "x", "x'", "y", "y'", "z", "z'"]      # index 2i = make, 2i+1 = break

TARGETS = {
    "A":      lambda p: sum(p) in (1, 3, 4),
    "Aprime": lambda p: sum(p) in (0, 2),
    "parity4": lambda p: sum(p) % 2 == 1,
    "and4":   lambda p: sum(p) == 4,
}

def target_fn(name):
    """named target, or 'table:<16 bits in assignments() order>' for an arbitrary function."""
    if name.startswith("table:"):
        bits = name[6:]; assert len(bits) == 16
        tbl = {t: int(bits[i]) for i, t in enumerate(assignments())}
        return lambda p: tbl[tuple(p)] == 1
    return TARGETS[name]

def assignments():
    return list(itertools.product((0, 1), repeat=4))

def closed_literals(t):
    """indices into LITS closed under assignment t (1 = operated)."""
    out = []
    for i, bit in enumerate(t):
        out.append(2 * i if bit == 1 else 2 * i + 1)
    return out


class CNF:
    def __init__(self):
        self.n = 0
        self.clauses = []
        self.names = {}
        self.aux = {"c": {}, "r": {}, "t": {}, "s": {}, "lex": [], "varsym": [], "sinz": None}   # exposed for construct_assignment.py
    def new(self, name=None):
        self.n += 1
        if name: self.names[name] = self.n
        return self.n
    def add(self, *lits):
        self.clauses.append(list(lits))
    def at_most_k(self, xs, k):
        """Sinz sequential counter: sum(xs) <= k."""
        n = len(xs)
        if k >= n: return
        if k == 0:
            for x in xs: self.add(-x)
            return
        s = [[self.new() for _ in range(k)] for _ in range(n)]
        self.aux["sinz"] = (list(xs), s, k)
        self.add(-xs[0], s[0][0])
        for j in range(1, k): self.add(-s[0][j])
        for i in range(1, n):
            self.add(-xs[i], s[i][0])
            self.add(-s[i - 1][0], s[i][0])
            for j in range(1, k):
                self.add(-xs[i], -s[i - 1][j - 1], s[i][j])
                self.add(-s[i - 1][j], s[i][j])
            self.add(-xs[i], -s[i - 1][k - 1])
    def write(self, path):
        with open(path, "w") as fh:
            fh.write(f"p cnf {self.n} {len(self.clauses)}\n")
            for cl in self.clauses:
                fh.write(" ".join(map(str, cl)) + " 0\n")


def encode(target, V, K, symbreak="bfs", varsym=False, cube=None):
    f = target_fn(target)
    cnf = CNF()
    a, b = 0, 1
    pairs = [(u, v) for u in range(V) for v in range(u + 1, V)]
    pidx = {p: i for i, p in enumerate(pairs)}
    def pair(u, v): return pidx[(u, v) if u < v else (v, u)]
    # edge variables
    e = [[cnf.new(f"e_{u}_{v}_{LITS[l]}") for l in range(8)] for (u, v) in pairs]
    all_edges = [x for row in e for x in row]
    # R4: no complementary parallel pair on one vertex pair
    for row in e:
        for i in range(4):
            cnf.add(-row[2 * i], -row[2 * i + 1])
    # cost
    cnf.at_most_k(all_edges, K)
    # degrees (R2) — incident edge literals per vertex
    inc = {v: [] for v in range(V)}
    nbr_edges = {v: {} for v in range(V)}
    for (u, v), row in zip(pairs, e):
        inc[u] += row; inc[v] += row
        nbr_edges[u][v] = row; nbr_edges[v][u] = row
    for v in range(V):
        S = inc[v]
        cnf.add(*S)                                   # degree >= 1
        if v not in (a, b):
            for s in S:                               # degree >= 2
                cnf.add(*[x for x in S if x != s])
            for u in range(V):                        # >= 2 distinct neighbours
                if u == v: continue
                cnf.add(*[x for w_, row in nbr_edges[v].items() if w_ != u for x in row])
    if symbreak == "bfs":
        # R5: connected-in-order
        for v in range(2, V):
            cnf.add(*[x for u in range(v) for x in nbr_edges[v][u]])
    elif symbreak == "lex":
        # R5': lex-leader for each adjacent transposition (i i+1) of internal vertices: with the edge vector
        # ordered pair-lexicographically, x >=_lex sigma(x) reduces to row(i) >=_lex row(i+1) where a row lists, for
        # u < i ascending then u > i+1 ascending, the 8 edge variables of {v,u}.  The lex-max labelling of any
        # network's orbit satisfies every generator's constraint, so this is WLOG.  (Connectivity not imposed: a
        # superset space; UNSAT over it is UNSAT over the connected space.)
        for i in range(2, V - 1):
            j = i + 1
            cols = [u for u in range(V) if u < i] + [u for u in range(V) if u > j]
            A = [x for u in cols for x in nbr_edges[i][u]]
            B = [x for u in cols for x in nbr_edges[j][u]]
            eq_prev = None
            eqs = []
            for a_, b_ in zip(A, B):
                # while equal so far: not (a=0 and b=1)
                if eq_prev is None: cnf.add(a_, -b_)
                else: cnf.add(-eq_prev, a_, -b_)
                eq = cnf.new()
                # eq <-> eq_prev and (a <-> b)
                if eq_prev is None:
                    cnf.add(-eq, -a_, b_); cnf.add(-eq, a_, -b_)
                    cnf.add(eq, a_, b_); cnf.add(eq, -a_, -b_)
                else:
                    cnf.add(-eq, eq_prev); cnf.add(-eq, -a_, b_); cnf.add(-eq, a_, -b_)
                    cnf.add(eq, -eq_prev, a_, b_); cnf.add(eq, -eq_prev, -a_, -b_)
                eq_prev = eq; eqs.append(eq)
            cnf.aux["lex"].append((i, A, B, eqs))
    elif symbreak == "none":
        pass                                          # no vertex symmetry breaking (used by admits_tooth.py)
    else:
        raise ValueError(symbreak)
    if varsym:
        # R6 (only for targets symmetric under every permutation of w,x,y,z): contact counts per variable may be
        # taken non-increasing, c(w) >= c(x) >= c(y) >= c(z).  Sound jointly with R5': the count vector is invariant
        # under vertex permutations, so the orbit element maximising (count vector, then edge vector) satisfies both.
        _f = target_fn(target)   # R6 is sound only for targets invariant under EVERY permutation of the variable names
        assert all(_f(t) == _f(tuple(t[pi[i]] for i in range(4))) for pi in itertools.permutations(range(4)) for t in assignments()), \
            "--varsym requires a target symmetric under all 24 variable permutations"
        def exact_unary(xs):
            """u[j] (j=1..K) <-> at least j of xs are true; sequential counter with BOTH directions."""
            n = len(xs); Kc = K
            s_ = [[cnf.new() for _ in range(Kc + 1)] for _ in range(n)]   # s_[i][j] = at least j among xs[0..i], j=0..K
            for i in range(n):
                cnf.add(s_[i][0])                                            # at least 0: true
                for j in range(1, Kc + 1):
                    prev_j = s_[i - 1][j] if i > 0 else None
                    prev_j1 = s_[i - 1][j - 1] if i > 0 else (None if j > 1 else "T")
                    # s[i][j] <-> prev_j OR (x_i AND prev_j1)
                    if i == 0:
                        if j == 1:
                            cnf.add(-s_[i][j], xs[i]); cnf.add(-xs[i], s_[i][j])
                        else:
                            cnf.add(-s_[i][j])
                    else:
                        cnf.add(-s_[i][j], prev_j, xs[i])
                        cnf.add(-s_[i][j], prev_j, prev_j1)
                        cnf.add(-prev_j, s_[i][j])
                        cnf.add(-xs[i], -prev_j1, s_[i][j])
            cnf.aux["varsym"].append((list(xs), s_))
            return [None] + [s_[n - 1][j] for j in range(1, Kc + 1)]
        per_var = []
        for vi in range(4):
            xs = [row[2 * vi] for row in e] + [row[2 * vi + 1] for row in e]
            per_var.append(exact_unary(xs))
        for vi in range(3):
            hi, lo = per_var[vi], per_var[vi + 1]
            for j in range(1, K + 1):
                cnf.add(-lo[j], hi[j])                                       # c(next) >= j  ->  c(this) >= j
        if cube is not None:
            # CUBE: fix the exact per-variable contact counts (c_w, c_x, c_y, c_z).  The cubes over all admissible count
            # vectors partition the search space (every network has exactly one count vector), so UNSAT on every cube
            # is UNSAT on the instance.  u[j] <-> count >= j is exact (both directions), so "count == c" is u[c] and not u[c+1].
            for vi, cval in enumerate(cube):
                u = per_var[vi]
                if cval >= 1: cnf.add(u[cval])
                if cval + 1 <= K: cnf.add(-u[cval + 1])
                if cval == 0: cnf.add(-u[1])
    # semantics per assignment
    for t in assignments():
        cl = closed_literals(t)
        c = []
        for i, row in enumerate(e):
            ci = cnf.new()
            c.append(ci)
            lits = [row[l] for l in cl]
            cnf.add(-ci, *lits)                       # c -> OR e
            for x in lits: cnf.add(-x, ci)            # e -> c
        cnf.aux["c"][t] = c
        if f(t):
            r = [[cnf.new() for _ in range(V)] for _ in range(V)]   # r[k][v]
            cnf.aux["r"][t] = r; cnf.aux["t"][t] = {}
            cnf.add(r[0][a])
            for v in range(V):
                if v != a: cnf.add(-r[0][v])
            for k in range(1, V):
                for v in range(V):
                    just = [r[k - 1][v]]
                    for u in range(V):
                        if u == v: continue
                        tvar = cnf.new()
                        cnf.aux["t"][t][(k, u, v)] = tvar
                        cnf.add(-tvar, r[k - 1][u])
                        cnf.add(-tvar, c[pair(u, v)])
                        just.append(tvar)
                    cnf.add(-r[k][v], *just)
            cnf.add(r[V - 1][b])
        else:
            s = [cnf.new() for _ in range(V)]
            cnf.aux["s"][t] = s
            cnf.add(s[a]); cnf.add(-s[b])
            for (u, v), ci in zip(pairs, c):
                cnf.add(-ci, -s[u], s[v])
                cnf.add(-ci, s[u], -s[v])
    meta = {"target": target, "V": V, "K": K, "symbreak": symbreak, "varsym": varsym, "cube": cube, "vars": cnf.n, "clauses": len(cnf.clauses),
            "edge_vars": {str(var): [u, v, LITS[l]] for (u, v), row in zip(pairs, e) for l, var in enumerate(row)}}
    return cnf, meta


def decode(meta, model_path):
    true = set()
    with open(model_path) as fh:
        for line in fh:
            if line.startswith("v"):
                for tok in line.split()[1:]:
                    n = int(tok)
                    if n > 0: true.add(n)
    edges = [[f"n{u}" if u > 1 else ("a" if u == 0 else "b"),
              f"n{v}" if v > 1 else ("a" if v == 0 else "b"), lit]
             for var, (u, v, lit) in meta["edge_vars"].items() if int(var) in true]
    return {"a": "a", "b": "b", "edges": edges, "source": f"sat_search decode target={meta['target']} V={meta['V']} K={meta['K']}"}


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("encode"); p.add_argument("--target", required=True); p.add_argument("--V", type=int, required=True)
    p.add_argument("--K", type=int, required=True); p.add_argument("--out", required=True); p.add_argument("--meta")
    p.add_argument("--symbreak", default="bfs", choices=["bfs", "lex", "none"]); p.add_argument("--varsym", action="store_true")
    p.add_argument("--cube", help="c_w,c_x,c_y,c_z exact per-variable contact counts (requires --varsym)")
    p = sub.add_parser("decode"); p.add_argument("--meta", required=True); p.add_argument("--model", required=True); p.add_argument("--out", required=True)
    p = sub.add_parser("truth"); p.add_argument("--target", required=True)
    args = ap.parse_args()
    if args.cmd == "encode":
        cube = tuple(int(x) for x in args.cube.split(",")) if args.cube else None
        if cube is not None: assert args.varsym, "--cube requires --varsym"
        cnf, meta = encode(args.target, args.V, args.K, args.symbreak, args.varsym, cube)
        cnf.write(args.out)
        if args.meta:
            with open(args.meta, "w") as fh: json.dump(meta, fh)
        print(f"encoded target={args.target} V={args.V} K={args.K} symbreak={args.symbreak} varsym={args.varsym} cube={args.cube} vars={cnf.n} clauses={len(cnf.clauses)} -> {args.out}")
    elif args.cmd == "decode":
        meta = json.load(open(args.meta))
        net = decode(meta, args.model)
        json.dump(net, open(args.out, "w"), indent=1)
        print(f"decoded {len(net['edges'])} contacts -> {args.out}")
    elif args.cmd == "truth":
        f = target_fn(args.target)
        for t in assignments():
            print("".join(map(str, t)), int(f(t)))

if __name__ == "__main__":
    main()
