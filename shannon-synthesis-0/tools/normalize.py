#!/usr/bin/env python3
"""
normalize.py — the joint normal-form cover, as a terminating procedure (Astra's interim-3 crowbar, 2026-09-07).

THEOREM (cover).  If N realizes a NON-CONSTANT f with <= K contacts, then normalize(N) realizes f, has <= K contacts, and satisfies every
structural restriction the encoder imposes:  no wires (R1) · no loops · every non-terminal vertex has >= 2 DISTINCT neighbours
(R2) · no duplicate parallel literal (R3) · no complementary parallel pair (R4) · no component without a terminal ·
V <= contacts + 1.  Vertex naming (R5/R5') and the variable-count order (R6) are then pure relabellings applied afterwards
(symmetry_tooth.py); they change no structural property.

PROCEDURE.  Iterate to a fixed point:
    1. delete every component containing neither terminal
    2. delete a non-terminal vertex with <= 1 distinct neighbour, with all its contacts   (R2; the pendant lemma)
    3. delete loops
    4. delete a duplicate parallel literal                                                 (R3)
    5. contract a wire                                                                     (R1)
    6. contract a complementary parallel pair x||x' on {u,v}, u!=v; the pair is deleted; other {u,v} edges become loops (step 3)
       — if {u,v} = {a,b} the network computes constant 1 (exclusion branch: no realizer of a non-constant f contains it)  (R4)
    0'. exclusion: if a terminal has no incident edge the network computes constant 0 (a != b).  This is ONE structural
       constant-0 branch, not a characterization: `a --x-- v --x'-- b` is constant 0 and is a fixed point with both terminals
       incident (Astra, interim-4 crowbar; the earlier docstring claimed "the empty network is the fixed point of every
       constant-0 network" — FALSE, withdrawn).  Likewise CONSTANT-1 is one structural branch, not all of constant 1
       (parallel x-x and x'-x' branches are constant 1 without a wire or complementary pair on {a,b}).  Neither
       characterization is needed: the theorem is about realizers of a NON-CONSTANT f, and row-checked rewrites cannot enter
       either constant class from one.
MEASURE  mu(N) = (#contacts, #vertices, #wires), lexicographic (the third component pays for deleting a wire LOOP or a
duplicate wire — found by the tooth on its first run; the two-component measure did not decrease there).  Steps 2,3,4,6 strictly decrease #contacts or (step 2 with an isolated
vertex) keep contacts and decrease vertices; step 1 decreases vertices (and contacts if any); step 5 keeps contacts and decreases
vertices.  Every step STRICTLY decreases mu (asserted in code on every rewrite: `assert mu(nxt) < mu(cur)`), so the loop
terminates; non-increase would not suffice (equal-measure cycling).  A step CAN reintroduce an earlier pattern (a contraction
creates loops/duplicates/complements; a deletion creates pendants) — hence iteration to fixed point, never one pass.
EACH STEP IS CHECKED AT RUNTIME on all 16 rows (a witnessed rewrite): the procedure refuses to continue if any step changes the
function.  `--tooth N` runs N random networks through the procedure and checks the theorem's every clause.
"""
import argparse, itertools, json, random, sys
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from eval_network import truth_table   # SECOND HAND's blind evaluator, JSON net -> {assignment: 0/1}

VARS = "wxyz"
LITS = ["w", "w'", "x", "x'", "y", "y'", "z", "z'"]

def comp(lit): return lit[0] if lit.endswith("'") else lit[0] + "'"
def contacts(net): return sum(1 for _, _, l in net["edges"] if l != "wire")
def verts(net): return {x for u, v, _ in net["edges"] for x in (u, v)} | {net["a"], net["b"]}
def wires(net): return sum(1 for _, _, l in net["edges"] if l == "wire")
def mu(net): return (contacts(net), len(verts(net)), wires(net))   # lexicographic; wires last (a wire-loop deletion)
def same_fn(n1, n2): return truth_table(n1) == truth_table(n2)

def neighbours(net, v):
    return {w for u, x, _ in net["edges"] for w in ((x,) if u == v else (u,) if x == v else ()) if w != v}

def components(net):
    vs = verts(net); adj = {v: set() for v in vs}
    for u, v, _ in net["edges"]:
        adj[u].add(v); adj[v].add(u)
    seen, comps = set(), []
    for s in vs:
        if s in seen: continue
        stack, comp_ = [s], set()
        while stack:
            x = stack.pop()
            if x in comp_: continue
            comp_.add(x); stack.extend(adj[x] - comp_)
        seen |= comp_; comps.append(comp_)
    return comps

def contract(net, keep, drop):
    """identify drop into keep; loops produced are kept for the loop step (so the measure argument stays visible)."""
    a, b = net["a"], net["b"]
    if drop in (a, b) and keep not in (a, b): keep, drop = drop, keep
    ren = lambda x: keep if x == drop else x
    return {**net, "edges": [[ren(u), ren(v), l] for u, v, l in net["edges"]]}

def step(net):
    """one rewrite, or None at fixed point. returns (name, new_net)."""
    a, b = net["a"], net["b"]; E = net["edges"]
    # 1 junk components
    for c in components(net):
        if a not in c and b not in c:
            return "junk-component", {**net, "edges": [e for e in E if e[0] not in c]}
    # 2 pendants (distinct-neighbour predicate)
    for v in sorted(verts(net)):
        if v in (a, b): continue
        if len(neighbours(net, v)) <= 1:
            return f"pendant:{v}", {**net, "edges": [e for e in E if v not in e[:2]]}
    # 3 loops
    for i, (u, v, l) in enumerate(E):
        if u == v: return "loop", {**net, "edges": E[:i] + E[i + 1:]}
    # 4 duplicate parallel literal
    seen = {}
    for i, (u, v, l) in enumerate(E):
        key = (frozenset((u, v)), l)
        if key in seen: return "duplicate", {**net, "edges": E[:i] + E[i + 1:]}
        seen[key] = i
    # 5 wires
    for i, (u, v, l) in enumerate(E):
        if l == "wire":
            if {u, v} == {a, b}: return "CONSTANT-1", None
            rest = {**net, "edges": E[:i] + E[i + 1:]}
            return f"wire:{u}={v}", contract(rest, u, v)
    # 0' exclusion: a terminal with no incident edge -> constant 0 (a != b); no realizer of a non-constant f is here
    if not any(a in e[:2] for e in E) or not any(b in e[:2] for e in E):
        return "CONSTANT-0", None
    # 6 complementary parallel pair
    pairs = {}
    for i, (u, v, l) in enumerate(E):
        pairs.setdefault(frozenset((u, v)), {})[l] = i
    for pr, d in pairs.items():
        for l in d:
            if l != "wire" and comp(l) in d:
                if pr == frozenset((a, b)): return "CONSTANT-1", None
                u, v = tuple(pr)
                rest = {**net, "edges": [e for j, e in enumerate(E) if j not in (d[l], d[comp(l)])]}
                return f"complement:{u}={v}", contract(rest, u, v)
    return None

def normalize(net, trace=None):
    cur = net
    while True:
        r = step(cur)
        if r is None: return cur, "FIXED-POINT"
        name, nxt = r
        if nxt is None: return cur, name             # CONSTANT-1 / CONSTANT-0 exclusion branches
        assert mu(nxt) < mu(cur), (name, mu(cur), mu(nxt))
        assert same_fn(cur, nxt), f"rewrite {name} changed the function"   # witnessed rewrite
        if trace is not None: trace.append((name, mu(nxt)))
        cur = nxt

def restrictions_hold(net):
    a, b = net["a"], net["b"]; E = net["edges"]
    ok = all(l != "wire" for _, _, l in E) and all(u != v for u, v, _ in E)
    ok &= all(len(neighbours(net, v)) >= 2 for v in verts(net) if v not in (a, b))
    keys = [(frozenset((u, v)), l) for u, v, l in E]
    ok &= len(keys) == len(set(keys))
    ok &= not any((frozenset((u, v)), comp(l)) in set(keys) for u, v, l in E)
    ok &= all(a in c or b in c for c in components(net))
    ok &= len(verts(net)) <= contacts(net) + 1
    return ok

def random_net(seed, max_contacts=12, max_v=9):
    rng = random.Random(seed)
    V = rng.randint(2, max_v); names = ["a", "b"] + [f"n{i}" for i in range(2, V)]
    E = []
    for _ in range(rng.randint(1, max_contacts)):
        u, v = rng.choice(names), rng.choice(names)
        l = rng.choice(LITS + (["wire"] if rng.random() < 0.15 else []))
        E.append([u, v, l])
    return {"a": "a", "b": "b", "edges": E}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("net", nargs="?"); ap.add_argument("--tooth", type=int, default=0); ap.add_argument("--out")
    a = ap.parse_args()
    if a.tooth:
        bad = 0; branches = {"FIXED-POINT": 0, "CONSTANT-1": 0, "CONSTANT-0": 0}
        for s in range(a.tooth):
            n = random_net(s); tr = []
            n2, how = normalize(n, tr)
            branches[how] += 1
            if how == "CONSTANT-1":
                if any(v == 0 for v in truth_table(n).values()): bad += 1; print("BAD constant-1 branch on non-constant net", s)
                continue
            if how == "CONSTANT-0":
                if any(v == 1 for v in truth_table(n).values()): bad += 1; print("BAD constant-0 branch on non-constant net", s)
                continue
            if not same_fn(n, n2): bad += 1; print("BAD function changed", s)
            if not restrictions_hold(n2): bad += 1; print("BAD restrictions fail at fixed point", s, n2)
            if mu(n2) > mu(n): bad += 1; print("BAD measure rose", s)
        print(f"tooth: {a.tooth} random nets; fixed points {branches['FIXED-POINT']}, constant-1 exclusions {branches['CONSTANT-1']}, constant-0 exclusions {branches['CONSTANT-0']}; failures {bad}")
        # planted red arm: a deliberately wrong rewrite (delete a NON-pendant vertex) must be caught by the 16-row check
        n = {"a": "a", "b": "b", "edges": [["a", "n2", "w"], ["n2", "b", "x"], ["a", "b", "y"]]}
        wrong = {**n, "edges": [e for e in n["edges"] if "n2" not in e[:2]]}
        red = not same_fn(n, wrong)
        print(f"red: deleting a non-pendant vertex is caught by the row check: {red} (must be True)")
        ok = bad == 0 and red
        print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)
    net = json.load(open(a.net)); tr = []
    n2, how = normalize(net, tr)
    for name, m in tr: print(f"  {name:24s} -> mu={m}")
    print(f"{how}: contacts {contacts(net)} -> {contacts(n2)}, vertices {len(verts(net))} -> {len(verts(n2))}, function preserved: {same_fn(net, n2)}, restrictions hold: {restrictions_hold(n2)}")
    if a.out: json.dump(n2, open(a.out, "w"), indent=1)

if __name__ == "__main__":
    main()
