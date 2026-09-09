#!/usr/bin/env python3
"""
admits_tooth.py — CNF completeness tooth: a known realizing network, forced into the instance as unit clauses, must leave it SAT.
If the encoding (with its reductions and symmetry breakers) wrongly excluded such networks, this would go UNSAT.
Usage: admits_tooth.py NET.json --target A --K 13 [--symbreak lex] [--varsym] [--cadical PATH]
With --symbreak none (no vertex breaker, no --varsym) the core encoding is tested directly under the identity mapping —
the breakers' WLOG is symmetry_tooth.py's job.  With breakers on, the network's internal nodes are mapped onto 2..V-1 in EVERY permutation consistent with the breakers being WLOG only up to
renaming: we try all internal-vertex permutations and all 24 variable renamings and require at least one to be SAT
(that is exactly what "WLOG" promises).  Red arm: the same network with one contact's polarity flipped must be UNSAT under
every mapping (it no longer realizes the target).
"""
import argparse, itertools, json, os, subprocess, sys, tempfile
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from sat_search import encode, LITS

def try_forced(net_edges, V, target, K, symbreak, varsym, cadical):
    """net_edges: list of (u,v,lit) with u,v in 0..V-1. Returns True if SAT with those edges forced ON and all others OFF."""
    cnf, meta = encode(target, V, K, symbreak, varsym)
    on = set()
    for u, v, lit in net_edges:
        var = [int(k) for k, (a, b, l) in meta["edge_vars"].items() if {a, b} == {u, v} and l == lit]
        assert len(var) == 1, (u, v, lit); on.add(var[0])
    for k in meta["edge_vars"]:
        cnf.add(int(k) if int(k) in on else -int(k))
    with tempfile.NamedTemporaryFile("w", suffix=".cnf", delete=False) as fh:
        path = fh.name
    cnf.write(path)
    rc = subprocess.run([cadical, "-n", path], capture_output=True).returncode
    os.unlink(path)
    return rc == 10

def random_cover_tooth(n_nets, cadical):
    """random networks -> normalize -> the CNF (no breakers) must admit the normal form for ITS OWN truth table."""
    from normalize import normalize, random_net, contacts, verts
    from eval_network import truth_table
    from sat_search import assignments
    ok = bad = skipped = 0
    for seed in range(n_nets):
        net, how = normalize(random_net(seed))
        tt = truth_table(net)
        if how != "FIXED-POINT" or len(set(tt.values())) < 2: skipped += 1; continue
        bits = "".join(str(tt[t]) for t in assignments())
        names = sorted(verts(net) - {"a", "b"}); V = 2 + len(names); m = {"a": 0, "b": 1, **{x: i + 2 for i, x in enumerate(names)}}
        edges = [(m[u], m[v], l) for u, v, l in net["edges"]]
        if try_forced(edges, V, "table:" + bits, contacts(net), "none", False, cadical): ok += 1
        else: bad += 1; print("NOT ADMITTED", seed, net)
    print(f"random cover: {ok} normal forms admitted for their own function, {bad} refused, {skipped} skipped (constant or excluded)")
    return bad == 0

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("net", nargs="?"); ap.add_argument("--random", type=int, default=0); ap.add_argument("--target", default="A"); ap.add_argument("--K", type=int, default=0)
    ap.add_argument("--symbreak", default="lex"); ap.add_argument("--varsym", action="store_true")
    ap.add_argument("--cadical", default=os.environ.get("SAT", "") + "/cadical/build/cadical")
    a = ap.parse_args()
    if a.random:
        ok = random_cover_tooth(a.random, a.cadical); print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)
    net = json.load(open(a.net))
    names = sorted({x for u, v, _ in net["edges"] for x in (u, v)} - {"a", "b"})
    V = 2 + len(names)
    def mapped(perm, pi):
        m = {"a": 0, "b": 1, **dict(zip(names, perm))}
        out = []
        for u, v, lit in net["edges"]:
            var = "wxyz".index(lit[0]); pol = 1 if lit.endswith("'") else 0
            out.append((m[u], m[v], LITS[2 * pi[var] + pol]))
        return out
    green = False
    if a.symbreak == "none" and not a.varsym:
        green = try_forced(mapped(tuple(range(2, V)), tuple(range(4))), V, a.target, a.K, a.symbreak, a.varsym, a.cadical)
    else:
        for pi in itertools.permutations(range(4)):
            for perm in itertools.permutations(range(2, V)):
                if try_forced(mapped(perm, pi), V, a.target, a.K, a.symbreak, a.varsym, a.cadical):
                    green = True; break
            if green: break
    print(f"green: known network ({len(net['edges'])} contacts, V={V}) admitted by the CNF under some renaming: {green} (must be True)")
    # red: flip one polarity -> must be UNSAT under every mapping
    flipped = dict(net); e0 = list(net["edges"]); u, v, lit = e0[0]
    e0[0] = [u, v, lit[0] if lit.endswith("'") else lit[0] + "'"]; flipped = {**net, "edges": e0}
    net = flipped
    red_ok = True
    if a.symbreak == "none" and not a.varsym:
        red_ok = not try_forced(mapped(tuple(range(2, V)), tuple(range(4))), V, a.target, a.K, a.symbreak, a.varsym, a.cadical)
    else:
        for pi in itertools.permutations(range(4)):
            for perm in itertools.permutations(range(2, V)):
                if try_forced(mapped(perm, pi), V, a.target, a.K, a.symbreak, a.varsym, a.cadical):
                    red_ok = False; break
            if not red_ok: break
    print(f"red: polarity-flipped network refused under every renaming: {red_ok} (must be True)")
    ok = green and red_ok
    print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)

if __name__ == "__main__":
    main()
