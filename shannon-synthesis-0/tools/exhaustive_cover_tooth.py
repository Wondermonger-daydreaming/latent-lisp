#!/usr/bin/env python3
"""
exhaustive_cover_tooth.py — NORMALIZATION COVER AUDIT /0, the bespoke enumerator.

EVERY network (not a sample) on V vertices with at most E labelled edges, edges drawn from (unordered pair INCLUDING loops) x
(8 literals + wire), as a multiset (so duplicates and complementary parallels occur), terminals a=0, b=1.  For each network G:
  (i)   f(G) on all 16 rows (SECOND HAND's evaluator);
  (ii)  N(G) := normalize(G) — every rewrite row-checked inside normalize();
  (iii) if f(G) is non-constant: N(G) reached FIXED-POINT (never an exclusion), f(N(G)) = f(G), contacts(N(G)) <= contacts(G),
        N(G) satisfies NF1..NF7, |V(N(G))| <= contacts(N(G)) + 1;
  (iv)  if f(G) is constant: any exclusion branch taken is the RIGHT one (constant-1 branch only on constant-1 networks, etc.).
Then the adversarial question the commission asks, answered exhaustively on the domain:
  (v)   for every non-constant function f seen, min cost over ALL networks realizing f  ==  min cost over NF networks realizing f.
        A violation would be a realizer whose normal-form restriction cannot be repaired without increasing cost.
Also: (vi) how many networks in the domain violate at least one NF clause (the size of the universe the search does NOT walk directly).
Usage: exhaustive_cover_tooth.py V Emax   (e.g. 3 4  |  4 3)
"""
import itertools, sys, time
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from normalize import normalize, contacts, verts, restrictions_hold
from eval_network import truth_table
from sat_search import assignments, LITS

def main(V, Emax):
    names = ["a", "b"] + [f"n{i}" for i in range(2, V)]
    pairs = [(names[i], names[j]) for i in range(V) for j in range(i, V)]           # includes loops (i == j)
    alphabet = [(u, v, l) for (u, v) in pairs for l in LITS + ["wire"]]
    t0 = time.time(); total = 0; nonconst = 0; bad = 0; violators = 0
    mincost_all, mincost_nf = {}, {}
    for E in range(1, Emax + 1):
        for combo in itertools.combinations_with_replacement(alphabet, E):
            total += 1
            G = {"a": "a", "b": "b", "edges": [list(e) for e in combo]}
            tt = truth_table(G); bits = "".join(str(tt[t]) for t in assignments())
            const = len(set(tt.values())) < 2
            NG, how = normalize(G)
            if const:
                if how == "CONSTANT-1" and "0" in bits: bad += 1; print("BAD constant-1 branch on", bits, combo)
                if how == "CONSTANT-0" and "1" in bits: bad += 1; print("BAD constant-0 branch on", bits, combo)
                continue
            nonconst += 1
            if not restrictions_hold(G): violators += 1
            ok = (how == "FIXED-POINT" and truth_table(NG) == tt and contacts(NG) <= contacts(G)
                  and restrictions_hold(NG) and len(verts(NG)) <= contacts(NG) + 1)
            if not ok:
                bad += 1; print("BAD", how, bits, combo, "->", NG); continue
            c = contacts(G)
            mincost_all[bits] = min(mincost_all.get(bits, 99), c)
            if restrictions_hold(G): mincost_nf[bits] = min(mincost_nf.get(bits, 99), c)
    # (v): every function's optimum is attained inside NF — by (iii) the normal form of an optimal realizer is an NF realizer of
    # cost <= optimum, so the check is a consistency check on the enumeration plus the theorem's promise
    gap = [(b, mincost_all[b], mincost_nf.get(b)) for b in mincost_all if mincost_nf.get(b, 99) > mincost_all[b]]
    print(f"V={V} E<={Emax}: {total} networks enumerated in {time.time()-t0:.0f}s; {nonconst} non-constant; {violators} of those violate >=1 NF clause")
    print(f"functions seen (non-constant): {len(mincost_all)}; functions whose min cost is NOT attained by an NF network: {len(gap)} (must be 0)")
    if gap: print("GAP", gap[:5])
    print(f"failures of the theorem's clauses: {bad} (must be 0)")
    ok = bad == 0 and not gap
    print("PASS" if ok else "FAIL"); return ok

if __name__ == "__main__":
    V, Emax = int(sys.argv[1]), int(sys.argv[2])
    sys.exit(0 if main(V, Emax) else 1)
