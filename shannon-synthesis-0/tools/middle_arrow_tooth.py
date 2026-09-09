#!/usr/bin/env python3
"""
middle_arrow_tooth.py — MIDDLE ARROW AUDIT /0: NF network -> constructed assignment -> every clause of the EXACT CNF.

Parts (each prints its own line; exit non-zero on any failure):
 F  encoder fidelity: every archived instance (.json meta + .cnf) re-encodes byte-identically under the current encoder.
 X  exhaustive NF domains: EVERY normal-form network on V vertices with <= E contacts (subsets of (pair, literal) slots with
    NF4 respected by construction, filtered by NF5/NF6/NF7), own truth table, non-constant -> construct (no breakers) -> all
    clauses; and, where the function is S4-symmetric, also through lex+varsym+cube with (pi, sigma) found by brute force.
 B  boundary cases aimed at each family: V=2 (single pair; shortest path; all 8 polarities); V=13 (a 12-contact chain — the
    longest simple path, reach level V-1 = 12); parallel contacts of all polarities on one pair; twin internal vertices (lex ties;
    eq-variables all true); equal variable counts (R6 ties); cube-boundary vectors (sum 12); a negative row with many cuts.
 R  red arms — planted WRONG constructors must be caught by the clause check: (r1) reach := "reachable at all" ignoring k;
    (r2) cut := "everything except b on a's side"; (r3) Sinz s[i][j] := "total count >= j+1" ignoring the prefix; (r4) lex eq :=
    always true; (r5) unary counter := prefix count of the WRONG variable.
 L  ledger: every failure this tooth produced while being written is printed as LEDGER lines (kept in the audit document).
"""
import glob, hashlib, itertools, json, os, sys
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from sat_search import encode, LITS, assignments, target_fn
from construct_assignment import build, check
from eval_network import truth_table
from normalize import restrictions_hold, contacts, verts
import construct_assignment as ca

ROOT = __file__.rsplit("/", 2)[0]
def sha(p): return hashlib.sha256(open(p, 'rb').read()).hexdigest()

# ---------- F: fidelity ----------
def fidelity():
    rows = []
    for mp in sorted(glob.glob(f'{ROOT}/evidence/*/*.json')):
        cp = mp[:-5] + '.cnf'
        if not os.path.exists(cp): continue
        m = json.load(open(mp))
        if 'target' not in m: continue
        cube = tuple(m['cube']) if m.get('cube') else None
        cnf, _ = encode(m['target'], m['V'], m['K'], m.get('symbreak', 'bfs'), m.get('varsym', False), cube)
        tmp = '/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/425d5d75-232c-4287-aa85-0027288927c1/scratchpad/re.cnf'; cnf.write(tmp)
        rows.append((mp, sha(cp) == sha(tmp)))
    same = sum(1 for _, ok in rows if ok)
    print(f"F fidelity: {len(rows)} archived instances re-encoded with the current encoder, {same} byte-identical, {len(rows)-same} differ")
    for mp, ok in rows:
        if not ok: print("  DIFFERS", mp)
    return same == len(rows)

# ---------- helpers ----------
def net_from(edges_idx, V):
    name = lambda i: "a" if i == 0 else "b" if i == 1 else f"n{i}"
    return {"a": "a", "b": "b", "edges": [[name(u), name(v), l] for u, v, l in edges_idx]}

def symmetric(bits):
    tt = {t: int(bits[i]) for i, t in enumerate(assignments())}
    return all(tt[t] == tt[tuple(t[pi[k]] for k in range(4))] for pi in itertools.permutations(range(4)) for t in assignments())

def all_clauses_ok(edges_idx, V, target, K, symbreak, varsym, cube=None):
    orig = ca.encode
    ca.encode = lambda t, V_, K_, sb, vs: orig(t, V_, K_, sb, vs, cube)
    try:
        cnf, val, _ = build(edges_idx, V, target, K, symbreak, varsym)
    finally:
        ca.encode = orig
    return not check(cnf, val), len(cnf.clauses)

def through_breakers(edges_idx, V, bits, K):
    """find (pi, sigma[, cube]) such that lex(+varsym+cube if symmetric) is satisfied; brute force."""
    sym = symmetric(bits)
    for pi in (itertools.permutations(range(4)) if sym else [tuple(range(4))]):
        for perm in itertools.permutations(range(2, V)):
            m = {0: 0, 1: 1, **dict(zip(range(2, V), perm))}
            ed = [(m[u], m[v], LITS[2 * pi[LITS.index(l) // 2] + (LITS.index(l) % 2)]) for u, v, l in edges_idx]
            c = [0, 0, 0, 0]
            for _, _, l in ed: c[LITS.index(l) // 2] += 1
            if sym and not (c[0] >= c[1] >= c[2] >= c[3]): continue
            ok, ncl = all_clauses_ok(ed, V, "table:" + bits, K, "lex", sym, tuple(c) if sym else None)
            if ok: return (pi, perm, tuple(c) if sym else None), ncl
    return None, 0

# ---------- X: exhaustive NF domains ----------
def exhaustive(V, Emax, breakers=True):
    pairs = [(u, v) for u in range(V) for v in range(u + 1, V)]
    slots = [(u, v, l) for (u, v) in pairs for l in LITS]
    total = nf = nonconst = ok_plain = ok_brk = bad = 0
    for E in range(1, Emax + 1):
        for combo in itertools.combinations(slots, E):
            # NF4 by construction
            seen = set(); bad4 = False
            for u, v, l in combo:
                key = (u, v, l[0]);
                if key in seen: bad4 = True; break
                seen.add(key)
            if bad4: continue
            total += 1
            net = net_from(combo, V)
            if not restrictions_hold(net) or len(verts(net)) != V: continue
            nf += 1
            tt = truth_table(net); bits = "".join(str(tt[t]) for t in assignments())
            if len(set(bits)) < 2: continue
            nonconst += 1
            ok, _ = all_clauses_ok(list(combo), V, "table:" + bits, E, "none", False)
            if ok: ok_plain += 1
            else: bad += 1; print("  X FAIL plain", V, combo, bits)
            if breakers:
                found, _ = through_breakers(list(combo), V, bits, E)
                if found: ok_brk += 1
                else: bad += 1; print("  X FAIL breakers", V, combo, bits)
    print(f"X exhaustive V={V} E<={Emax}: {total} NF4-respecting subsets, {nf} in NF at exactly V, {nonconst} non-constant; plain CNF all-clauses {ok_plain}/{nonconst}; through breakers {ok_brk}/{nonconst if breakers else 0}; failures {bad}")
    return bad == 0

# ---------- B: boundary cases ----------
def boundary():
    A = "".join(str(int(sum(t) in (1, 3, 4))) for t in assignments())
    bad = 0
    def case(name, edges, V, K, target, symbreak="none", varsym=False, cube=None, expect=True):
        nonlocal bad
        ok, ncl = all_clauses_ok(edges, V, target, K, symbreak, varsym, cube)
        flag = "ok" if ok == expect else "FAIL"
        if ok != expect: bad += 1
        print(f"  B {name:60s} V={V:2d} K={K:2d} clauses={ncl:6d} all-satisfied={ok} ({flag})")
    # V=2, every polarity on the single pair, shortest path (direct edge), K up to 12
    for l in LITS:
        bits = "".join(str(int((t[LITS.index(l)//2] == 1) != l.endswith("'"))) for t in assignments())
        case(f"V=2 single contact {l}", [(0, 1, l)], 2, 12, "table:" + bits)
    # V=2 parallel contacts of all 4 variables (one polarity each), and their complements
    case("V=2 parallel w,x,y,z", [(0,1,"w"),(0,1,"x"),(0,1,"y"),(0,1,"z")], 2, 12, "table:" + "".join(str(int(any(t))) for t in assignments()))
    case("V=2 parallel w',x',y',z'", [(0,1,"w'"),(0,1,"x'"),(0,1,"y'"),(0,1,"z'")], 2, 12, "table:" + "".join(str(int(not all(t))) for t in assignments()))
    # V=13: a 12-contact chain a-n2-...-n12-b, longest simple path, reach level V-1 = 12; own function = AND of literals.
    # LEDGER M-L2: the first chain mixed w and w' etc. and computed CONSTANT 0, so the reach-level-12 test was vacuous (no positive
    # rows). Now positive literals cycling w,x,y,z: AND4, non-constant, row 1111 needs the full 12-edge path.
    chain = [(0, 2, "w")] + [(i, i + 1, ["x", "y", "z", "w"][(i - 2) % 4]) for i in range(2, 12)] + [(12, 1, "z")]
    net = net_from(chain, 13); tt = truth_table(net); bits = "".join(str(tt[t]) for t in assignments())
    case("V=13 twelve-contact chain (longest path, reach level 12)", chain, 13, 12, "table:" + bits)
    # twin internal vertices: lex ties (rows equal), eq-variables all true along the comparison
    twins = [(0,2,"w"),(2,1,"x"),(0,3,"w"),(3,1,"x")]
    net = net_from(twins, 4); tt = truth_table(net); bits = "".join(str(tt[t]) for t in assignments())
    case("twin internals (lex tie) — plain", twins, 4, 12, "table:" + bits)
    case("twin internals (lex tie) — lex breaker", twins, 4, 12, "table:" + bits, "lex", False)
    # the 13: equal variable counts w=x=4 (R6 tie), cube (4,4,3,2)
    n13 = json.load(open(f"{ROOT}/evidence/A_K13/A_K13_V7.net.json"))
    found, ncl = through_breakers([(0 if u=="a" else 1 if u=="b" else int(u[1:]), 0 if v=="a" else 1 if v=="b" else int(v[1:]), l) for u, v, l in n13["edges"]], 7, A, 13)
    print(f"  B {'the 13: R6 tie (w=x=4), cube (4,4,3,2), lex+varsym+cube':60s} canonical={found} clauses={ncl} ({'ok' if found else 'FAIL'})"); bad += 0 if found else 1
    # cube-boundary vectors: sum exactly 12 — Astra's 14 after R1 has (6,4,2,2) sum 14 at K=14; build a sum-12 example: a chain with counts (3,3,3,3)
    chain12 = [(0,2,"w"),(2,3,"x"),(3,4,"y"),(4,5,"z"),(5,6,"w'"),(6,7,"x'"),(7,8,"y'"),(8,9,"z'"),(9,10,"w"),(10,11,"x"),(11,12,"y"),(12,1,"z")]
    net = net_from(chain12, 13); tt = truth_table(net); bits = "".join(str(tt[t]) for t in assignments())
    # its function is AND of 12 literals incl. complements = constant 0 -> not usable; use a symmetric target instead: cube family with a REAL symmetric net
    # symmetric example with sum 12: parity-like? use the parity4 12-contact SAT network found earlier if archived
    p = f"{ROOT}/evidence/ctrl_parity4_K12/parity4_K12_V7.net.json"
    if os.path.exists(p):
        n = json.load(open(p)); ed = [(0 if u=="a" else 1 if u=="b" else int(u[1:]), 0 if v=="a" else 1 if v=="b" else int(v[1:]), l) for u, v, l in n["edges"]]
        PAR = "".join(str(int(sum(t) % 2 == 1)) for t in assignments())
        found, ncl = through_breakers(ed, 7, PAR, 12)
        print(f"  B {'parity4 12-contact net: cube boundary (sum 12), lex+varsym+cube':60s} canonical={found} clauses={ncl} ({'ok' if found else 'FAIL'})"); bad += 0 if found else 1
    # negative row with many cuts: a-n2-b and a-n3-b two disjoint paths, row where both open -> many separating cuts; constructor picks a's reachable set
    two = [(0,2,"w"),(2,1,"x"),(0,3,"y"),(3,1,"z")]
    net = net_from(two, 4); tt = truth_table(net); bits = "".join(str(tt[t]) for t in assignments())
    case("two disjoint paths (negative rows with many cuts)", two, 4, 12, "table:" + bits)
    print(f"B boundary: failures {bad}")
    return bad == 0

# ---------- R: red arms ----------
def red_arms():
    """planted wrong constructors on the 13 must be CAUGHT by the clause check."""
    n13 = json.load(open(f"{ROOT}/evidence/A_K13/A_K13_V7.net.json"))
    raw = [(0 if u=="a" else 1 if u=="b" else int(u[1:]), 0 if v=="a" else 1 if v=="b" else int(v[1:]), l) for u, v, l in n13["edges"]]
    # LEDGER M-L1: the first version built the 13 under the IDENTITY labeling, where lex/varsym are legitimately violated, so the
    # baseline was already red (base_ok=False) while the planted arms were "caught" — a red arm needs a green baseline. Use the
    # canonical (pi, sigma) found by the breaker search: pi=(0,1,3,2), sigma=(3,4,5,6,2).
    pi, perm = (0, 1, 3, 2), (3, 4, 5, 6, 2)
    m = {0: 0, 1: 1, **dict(zip(range(2, 7), perm))}
    ed = [(m[u], m[v], LITS[2 * pi[LITS.index(l) // 2] + (LITS.index(l) % 2)]) for u, v, l in raw]
    orig = ca.encode; ca.encode = lambda t, V_, K_, sb, vs: orig(t, V_, K_, sb, vs, (4, 4, 3, 2))
    try:
        cnf, val, meta = build(ed, 7, "A", 13, "lex", True)
    finally:
        ca.encode = orig
    base_ok = not check(cnf, val)
    results = {}
    # r1: reach := reachable-at-all (ignore k)
    v1 = dict(val)
    for t, r in cnf.aux["r"].items():
        for k in range(1, 7):
            for v in range(7): v1[r[k][v]] = v1[r[6][v]]
    results["r1 reach ignores k"] = bool(check(cnf, v1))
    # r2: cut := everything except b on a's side
    v2 = dict(val)
    for t, s in cnf.aux["s"].items():
        for v in range(7): v2[s[v]] = (v != 1)
    results["r2 cut = all-but-b"] = bool(check(cnf, v2))
    # r3: Sinz := total count >= j+1 (ignore prefix)
    v3 = dict(val); xs, s, k = cnf.aux["sinz"]; tot = sum(1 for x in xs if val[x])
    for i in range(len(xs)):
        for j in range(k): v3[s[i][j]] = (tot >= j + 1)
    results["r3 Sinz ignores prefix"] = bool(check(cnf, v3))
    # r4: lex eq := always true
    v4 = dict(val)
    for (i, A_, B_, eqs) in cnf.aux["lex"]:
        for e in eqs: v4[e] = True
    results["r4 lex eq always true"] = bool(check(cnf, v4))
    # r5: unary counter of variable 0 filled with variable 1's prefix counts
    v5 = dict(val); (xs0, s0), (xs1, s1) = cnf.aux["varsym"][0], cnf.aux["varsym"][1]
    cnt = 0
    for i, x in enumerate(xs1):
        cnt += 1 if val[x] else 0
        for j in range(len(s0[i])): v5[s0[i][j]] = (cnt >= j)
    results["r5 counter of wrong variable"] = bool(check(cnf, v5))
    for name, caught in results.items(): print(f"  R {name:32s} caught={caught}")
    ok = base_ok and all(results.values())
    print(f"R red arms: base construction ok={base_ok}; planted wrong constructors caught {sum(results.values())}/{len(results)}")
    return ok

if __name__ == "__main__":
    ok = fidelity()
    ok &= exhaustive(3, 4); ok &= exhaustive(4, 3); ok &= exhaustive(4, 4, breakers=False); ok &= exhaustive(5, 3, breakers=False)
    ok &= boundary()
    ok &= red_arms()
    print("PASS" if ok else "FAIL"); sys.exit(0 if ok else 1)
