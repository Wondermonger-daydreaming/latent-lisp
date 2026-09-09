#!/usr/bin/env python3
"""
symmetry_tooth.py — teeth for the two symmetry breakers in sat_search.py, stated as the proof obligations Astra asked for.

R5' (vertex lex-leader).  Obligation: for EVERY labelled multigraph there is a renaming of the internal vertices (terminals
   fixed) satisfying row(i) >=_lex row(i+1) for all adjacent internal i.  (Renaming vertices changes no transmission.)
R6  (variable contact-count ordering).  Obligation, two parts:
   (a) the TARGET is invariant under every permutation pi of the variable NAMES (w,x,y,z): checked on the 16-row table for
       each of the 24 permutations — a FUNCTION-automorphism fact, not a graph fact.  No polarity flip is ever used: the map
       w <-> w' is not an automorphism of A and no breaker assumes it (checked: single-variable complementation changes A).
   (b) given (a), renaming variables globally in a realizing network yields a realizing network, so among the 24 renamings
       there is one with c(w) >= c(x) >= c(y) >= c(z).
JOINT.  Obligation: some element of the orbit under (vertex renamings) x (variable renamings) satisfies R5' AND R6 at once.
   Argument: the count vector is unchanged by vertex renaming, so maximise (count vector, then edge vector) — brute-forced here.
Red arms: the strict lex order fails on twin vertices; a NON-symmetric target (popcount(w,x,y,z) with w weighted) fails (a).
Exit non-zero if any green fails or any red does not bite.
"""
import itertools, random, sys
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from sat_search import TARGETS, assignments
from lex_leader_tooth import make_rows_ok, permute, sweep

def var_invariant(f):
    bad = []
    for pi in itertools.permutations(range(4)):
        for t in assignments():
            if f(t) != f(tuple(t[pi[i]] for i in range(4))):
                bad.append(pi); break
    return bad

def complement_invariant(f, i):
    return all(f(t) == f(tuple((1 - b) if k == i else b for k, b in enumerate(t))) for t in assignments())

def counts(E):
    c = [0, 0, 0, 0]
    for u, v, l in E: c[l // 2] += 1
    return c

def rename_vars(E, pi):   # literal l = 2*var + polarity ; pi permutes vars
    return {(u, v, 2 * pi[l // 2] + (l % 2)) for u, v, l in E}

def joint_sweep(seed=11, per_V=800, Vs=(4, 5, 6)):
    rows_ok = make_rows_ok(strict=False)
    random.seed(seed); N = bad = 0
    for V in Vs:
        internals = list(range(2, V))
        for _ in range(per_V):
            pairs = [(u, v) for u in range(V) for v in range(u + 1, V)]
            E = {(u, v, random.randrange(8)) for (u, v) in random.sample(pairs, random.randint(1, len(pairs)))
                 for _ in range(random.randint(1, 2))}
            N += 1
            ok = False
            for pi in itertools.permutations(range(4)):
                E2 = rename_vars(E, pi)
                c = counts(E2)
                if not (c[0] >= c[1] >= c[2] >= c[3]): continue
                if any(rows_ok(permute(E2, dict(zip(internals, p))), V) for p in itertools.permutations(internals)):
                    ok = True; break
            if not ok: bad += 1
    return N, bad

if __name__ == "__main__":
    ok = True
    # R6(a): A is invariant under all 24 variable permutations; not under single complementation
    badA = var_invariant(TARGETS["A"])
    print(f"R6(a) A invariant under all 24 variable permutations: {not badA}")
    ok &= not badA
    comp = [complement_invariant(TARGETS["A"], i) for i in range(4)]
    print(f"R6   single-variable complementation is an automorphism of A? {comp}  (must all be False; no breaker uses it)")
    ok &= not any(comp)
    weighted = lambda p: (2 * p[0] + p[1] + p[2] + p[3]) in (1, 3, 4)          # planted non-symmetric target
    print(f"red: non-symmetric target refused by R6(a): {bool(var_invariant(weighted))}  (must be True)")
    ok &= bool(var_invariant(weighted))
    # R5' green + red
    N, bad = sweep(make_rows_ok(strict=False))
    print(f"R5'  {N} graphs, {bad} without a lex-leader relabelling (must be 0)"); ok &= bad == 0
    # JOINT
    N, bad = joint_sweep()
    print(f"JOINT {N} graphs, {bad} without a (vertex, variable) renaming satisfying R5' and R6 together (must be 0)"); ok &= bad == 0
    print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)
