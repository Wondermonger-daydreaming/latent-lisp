#!/usr/bin/env python3
"""Networks transcribed by hand from Astra's netlists, for the independent evaluator.

SOURCE (single source for both):
  /home/gauss/Desktop/Claude-Code-Lab/_staging/2026-09-05-astra-shannon-future-equivalence/astra-run.txt

  ASTRA_A_14   <- astra-run.txt lines 4-20   (line 4 "net = Network()", lines 5-6 wires,
                  lines 7-20 the fourteen net.contact(...) calls)
  ASTRA_APRIME_13 <- astra-run.txt lines 25-40 (line 25 "net = Network()", lines 26-27 wires,
                  lines 28-40 the thirteen net.contact(...) calls)

TRANSCRIPTION RULES USED (stated so they can be disputed):
  - net.wire(u, v)                        -> [u, v, "wire"]
  - net.contact(u, v, "Xk", primed=False) -> [u, v, <literal k>]        (make contact)
  - net.contact(u, v, "Xk", primed=True)  -> [u, v, <literal k> + "'"]  (break contact)
  - variable map X1->w, X2->x, X3->y, X4->z.  Both target functions are symmetric in the
    four variables (popcount only), so this map cannot change any verdict.
  - node ids kept as strings; terminals "a" and "b" as written.

CONVENTION WARNING (not resolved here; resolved by evaluation, see B-known-networks.md):
  The museum's reception tables label the column "function (a-numbers count zeros)"
  (_staging/2026-09-05-astra-shannon-future-equivalence/RECEPTION.md line 12) and Astra
  writes "A-numbers count zeros"
  (corpus/voices/received/2026-09-05-031019-astra-...-window.md line 34).
  The task specification instead states the "w=1 means operated" reading, A = popcount of
  ONES in {1,3,4}.  Both readings are checked; the results table reports which gives 0/16.

FIG. 32 (Shannon's lattice-derived 14 for A'):
  not transcribed - no explicit edge list in the allowed sources.  Grep over
  RECEPTION*.md, PASTEABLE-RETURN-*.md, PASTEABLE-TO-*.md, astra-run.txt,
  astra-parity-run.txt, m_lock_orders-run.txt, sweep-bdd-vs-lattice.txt, the four
  shannon-museum-return-to-astra-*/ *.md files, and the two corpus/voices/received/
  2026-09-05-03* Astra letters returned only prose references to "Fig. 32" / "our lattice"
  (counts 14, 15) and no netlist.  The only netlists present anywhere in the allowed
  sources are the two above.
"""

VARMAP = {"X1": "w", "X2": "x", "X3": "y", "X4": "z"}


def _c(u, v, xk, primed):
    return [str(u), str(v), VARMAP[xk] + ("'" if primed else "")]


# astra-run.txt lines 4-20
ASTRA_A_14 = {
    "a": "a",
    "b": "b",
    "edges": [
        ["a", "9", "wire"],              # line 5:  net.wire("a", 9)
        ["1", "b", "wire"],              # line 6:  net.wire(1, "b")
        _c(2, 1, "X4", False),           # line 7
        _c(3, 1, "X3", False),           # line 8
        _c(3, 2, "X3", True),            # line 9
        _c(4, 1, "X4", True),            # line 10
        _c(5, 2, "X3", False),           # line 11
        _c(5, 4, "X3", True),            # line 12
        _c(6, 3, "X2", False),           # line 13
        _c(6, 5, "X2", True),            # line 14
        _c(7, 4, "X3", False),           # line 15
        _c(7, 2, "X3", True),            # line 16
        _c(8, 5, "X2", False),           # line 17
        _c(8, 7, "X2", True),            # line 18
        _c(9, 6, "X1", False),           # line 19
        _c(9, 8, "X1", True),            # line 20
    ],
}

# astra-run.txt lines 25-40
ASTRA_APRIME_13 = {
    "a": "a",
    "b": "b",
    "edges": [
        ["a", "9", "wire"],              # line 26: net.wire("a", 9)
        ["1", "b", "wire"],              # line 27: net.wire(1, "b")
        _c(2, 1, "X4", True),            # line 28
        _c(3, 2, "X3", True),            # line 29
        _c(4, 1, "X4", False),           # line 30
        _c(5, 2, "X3", False),           # line 31
        _c(5, 4, "X3", True),            # line 32
        _c(6, 3, "X2", False),           # line 33
        _c(6, 5, "X2", True),            # line 34
        _c(7, 4, "X3", False),           # line 35
        _c(7, 2, "X3", True),            # line 36
        _c(8, 5, "X2", False),           # line 37
        _c(8, 7, "X2", True),            # line 38
        _c(9, 6, "X1", False),           # line 39
        _c(9, 8, "X1", True),            # line 40
    ],
}

# Planted fault: ASTRA_A_14 with the polarity of exactly one literal flipped
# (edge index 2, astra-run.txt line 7: z -> z').  Used as a negative control.
def _flip(net, idx):
    import copy
    out = copy.deepcopy(net)
    u, v, lab = out["edges"][idx]
    out["edges"][idx] = [u, v, lab[:-1] if lab.endswith("'") else lab + "'"]
    return out


ASTRA_A_14_MUTANT = _flip(ASTRA_A_14, 2)

NETWORKS = {
    "astra_A_14": ASTRA_A_14,
    "astra_Aprime_13": ASTRA_APRIME_13,
    "astra_A_14_mutant": ASTRA_A_14_MUTANT,
}

if __name__ == "__main__":
    import json
    import sys
    if len(sys.argv) > 1:
        print(json.dumps(NETWORKS[sys.argv[1]], indent=1))
    else:
        for name, net in NETWORKS.items():
            n = sum(1 for e in net["edges"] if e[2] != "wire")
            print("%-20s contacts=%d edges=%d" % (name, n, len(net["edges"])))
