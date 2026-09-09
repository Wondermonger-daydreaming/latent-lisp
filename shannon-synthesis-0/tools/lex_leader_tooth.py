#!/usr/bin/env python3
"""
lex_leader_tooth.py — brute-force soundness check of sat_search.py's R5' (lex-leader symmetry breaking).

Green arm: for random labelled multigraphs on V vertices (terminals 0,1 fixed), SOME permutation of the internal
vertices satisfies row(i) >=_lex row(i+1) for every adjacent internal pair (rows exclude the two swapped columns).
If that ever fails, R5' is not WLOG and every UNSAT verdict under it is void.
Red arm (planted): the STRICT version (row(i) >_lex row(i+1)) must fail on some graph (two identical internal
vertices), proving the tooth can bite.  Exit non-zero if the green arm fails or the red arm does not bite.
"""
import random, itertools, sys

def make_rows_ok(strict):
    def rows_ok(E, V):
        def row(i, cols):
            out = []
            for u in cols:
                p = (min(i, u), max(i, u))
                out += [1 if (p[0], p[1], l) in E else 0 for l in range(8)]
            return out
        for i in range(2, V - 1):
            j = i + 1
            cols = [u for u in range(V) if u < i] + [u for u in range(V) if u > j]
            ri, rj = row(i, cols), row(j, cols)
            if (ri <= rj) if strict else (ri < rj):
                return False
        return True
    return rows_ok

def permute(E, perm):
    out = set()
    for u, v, l in E:
        a, b = perm.get(u, u), perm.get(v, v)
        out.add((min(a, b), max(a, b), l))
    return out

def sweep(rows_ok, seed=7, per_V=3000, Vs=(4, 5, 6)):
    random.seed(seed); bad = 0; N = 0
    for V in Vs:
        internals = list(range(2, V))
        for _ in range(per_V):
            pairs = [(u, v) for u in range(V) for v in range(u + 1, V)]
            E = {(u, v, random.randrange(8)) for (u, v) in random.sample(pairs, random.randint(1, len(pairs)))
                 for _ in range(random.randint(1, 2))}
            N += 1
            if not any(rows_ok(permute(E, dict(zip(internals, p))), V) for p in itertools.permutations(internals)):
                bad += 1
    return N, bad

if __name__ == "__main__":
    N, bad = sweep(make_rows_ok(strict=False))
    print(f"green: {N} graphs, {bad} without a lex-leader relabelling (must be 0)")
    # planted: a graph with two identical internal vertices cannot satisfy the strict order
    E = {(0, 2, 0), (0, 3, 0), (2, 1, 1), (3, 1, 1)}
    red_bites = not any(make_rows_ok(strict=True)(permute(E, dict(zip([2, 3], p))), 4) for p in itertools.permutations([2, 3]))
    print(f"red (strict order, twin vertices): bites = {red_bites} (must be True)")
    ok = (bad == 0) and red_bites
    print("PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)
