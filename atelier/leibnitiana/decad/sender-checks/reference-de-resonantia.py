#!/usr/bin/env python3
"""Independent behavioral reference for de-resonantia.lisp.

This is intentionally smaller than the Common Lisp specimen. It verifies the
central finite-state claims without reusing Lisp implementation machinery.
"""
from __future__ import annotations

from dataclasses import dataclass


@dataclass
class Node:
    name: str
    identity: str
    phase: int
    mode: tuple
    standing: str = "asserted"


SOURCE_MODE = ("suspended-rhyme", "c", ("cell", "dwell"), "delayed-return")

nodes = {
    "source": Node("source", "incantation-receipt-7", 0, SOURCE_MODE),
    "bell": Node("bell", "bronze-bell-31", 5, SOURCE_MODE),
    "chorus": Node("chorus", "chorus-17", 3, SOURCE_MODE),
    "raven": Node("raven", "raven-independent-4", 0, SOURCE_MODE),
    "heir": Node("heir", "archive-volume-9", 5, ("reliquary", "silent")),
}

coupled = {"bell", "chorus"}
resemblances = {name for name in ("bell", "chorus", "raven")
                if nodes[name].mode == nodes["source"].mode}

energy = 4
supplied = 0
responses: list[tuple[int, str, int, int, str]] = []
for repeat in range(1, 4):
    for target in ("bell", "chorus", "raven"):
        if target not in coupled:
            continue
        if energy < 1:
            energy += 1
            supplied += 1
        energy -= 1
        before = nodes[target].phase
        if before > nodes["source"].phase:
            nodes[target].phase -= 1
        elif before < nodes["source"].phase:
            nodes[target].phase += 1
        after = nodes[target].phase
        kind = "entrained" if after == nodes["source"].phase else "transmitted"
        responses.append((repeat, target, before, after, kind))

transmitted = {target for _, target, *_ in responses}
entrained = {target for target in transmitted
             if nodes[target].phase == nodes["source"].phase}

motif = {"terminal-pair": ("cell", "dwell"), "rhyme-key": "c"}
heir_motifs = [motif]
descendant = {"terminal-pair": tuple(reversed(motif["terminal-pair"])),
              "rhyme-key": motif["rhyme-key"]}

assert resemblances == {"bell", "chorus", "raven"}
assert transmitted == {"bell", "chorus"}
assert entrained == {"chorus"}
assert nodes["bell"].phase == 2
assert nodes["chorus"].phase == 0
assert nodes["raven"].phase == 0
assert nodes["chorus"].identity == "chorus-17"
assert supplied == 2
assert energy == 0
assert len(responses) == 6
assert heir_motifs == [motif]
assert nodes["heir"].standing == "asserted"
assert descendant == {"terminal-pair": ("dwell", "cell"), "rhyme-key": "c"}
assert all(node.standing == "asserted" for node in nodes.values())

print("de-resonantia reference model: PASS")
print("resemblance:", sorted(resemblances))
print("transmitted:", sorted(transmitted))
print("entrained:", sorted(entrained))
print("responses:", len(responses))
print("supplied energy:", supplied)
print("final energy:", energy)
print("descendant motif:", descendant)
print("verdict: resonance-without-identity")
