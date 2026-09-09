#!/usr/bin/env python3
"""Independent evaluator for Shannon-1938-style two-terminal contact networks.

Written from specification only (SECOND HAND, 2026-09-07); no museum source read.

Net JSON: {"a": "a", "b": "b", "edges": [["u","v","w'"], ["v","b","wire"], ...]}
Edge label is one of: wire, or a literal in {w,x,y,z} optionally suffixed with "'".
Make contact  w   is CLOSED iff assignment[w] == 1.
Break contact w'  is CLOSED iff assignment[w] == 0.
Wire is always closed.  Transmission = 1 iff a and b are connected via closed edges.
Cost = number of contact edges (wires cost 0).
"""
import json
import sys
from itertools import product

VARS = ("w", "x", "y", "z")
ASSIGNMENTS = [dict(zip(VARS, bits)) for bits in product((0, 1), repeat=4)]


def edge_closed(label, assignment):
    if label == "wire":
        return True
    if label.endswith("'"):
        var = label[:-1]
        if var not in VARS:
            raise ValueError("unknown variable in label %r" % label)
        return assignment[var] == 0
    if label not in VARS:
        raise ValueError("unknown edge label %r" % label)
    return assignment[label] == 1


def transmission(net, assignment):
    """1 iff a path of closed edges joins terminal a to terminal b."""
    adj = {}
    for u, v, label in net["edges"]:
        if not edge_closed(label, assignment):
            continue
        adj.setdefault(u, set()).add(v)
        adj.setdefault(v, set()).add(u)
    a, b = net["a"], net["b"]
    if a == b:
        return 1
    seen = {a}
    stack = [a]
    while stack:
        node = stack.pop()
        if node == b:
            return 1
        for nxt in adj.get(node, ()):
            if nxt not in seen:
                seen.add(nxt)
                stack.append(nxt)
    return 1 if b in seen else 0


def truth_table(net):
    """dict: (w,x,y,z) tuple -> 0/1, over all 16 assignments."""
    return {tuple(a[v] for v in VARS): transmission(net, a) for a in ASSIGNMENTS}


def cost(net):
    """Number of contact edges; wires are free."""
    return sum(1 for _, _, label in net["edges"] if label != "wire")


def check_against(net, target_set):
    """Assignments where transmission != membership in target_set. target_set: set of 4-tuples."""
    table = truth_table(net)
    return sorted(k for k, v in table.items() if v != (1 if k in target_set else 0))


def _popcount_set(counts):
    return {bits for bits in product((0, 1), repeat=4) if sum(bits) in counts}


TARGETS = {
    "A": _popcount_set({1, 3, 4}),
    "Aprime": _popcount_set({0, 2}),
    "parity4": _popcount_set({0, 2, 4}),
}


def main(argv):
    if len(argv) < 2:
        print("usage: eval_network.py NET.json [--target A|Aprime|parity4]", file=sys.stderr)
        return 2
    with open(argv[1]) as fh:
        net = json.load(fh)
    target_name = None
    if "--target" in argv:
        target_name = argv[argv.index("--target") + 1]
        if target_name not in TARGETS:
            print("unknown target %r" % target_name, file=sys.stderr)
            return 2
    table = truth_table(net)
    print("w x y z | T" + ("  target" if target_name else ""))
    tset = TARGETS[target_name] if target_name else None
    for bits in sorted(table):
        row = " ".join(str(b) for b in bits) + " | %d" % table[bits]
        if tset is not None:
            row += "       %d" % (1 if bits in tset else 0)
        print(row)
    print("COST %d" % cost(net))
    if tset is None:
        return 0
    bad = check_against(net, tset)
    for bits in bad:
        print("MISMATCH %s got=%d want=%d" % (bits, table[bits], 1 if bits in tset else 0))
    print("MISMATCHES %d" % len(bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
