#!/usr/bin/env python3
"""Independent behavioral reference for de-abysso.lisp.

It models only the promised public outcomes. It is not a Lisp interpreter and
is intentionally implemented through different data structures.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Literal

Kind = Literal["answer", "bounded-absence", "refused", "timeout", "occluded", "in-transit"]

LAYERS = {
    0: {"cost": 1, "channels": {"line", "sonar"},
        "entries": {"surface-ripple": ("answer", {"pattern": "wind-written"}, 0)}},
    1: {"cost": 1, "channels": {"line", "sonar"},
        "entries": {"near-voice": ("answer", "The first echo is not the floor.", 0)}},
    2: {"cost": 2, "channels": {"line"},
        "entries": {"sealed-name": ("refused", "office-does-not-authorize-disclosure", None)}},
    3: {"cost": 1, "channels": {"line"},
        "entries": {"ascending-word": ("answer", {"word": "pldenic", "status": "still-rising"}, 4)}},
    4: {"cost": 2, "channels": {"line"}, "entries": {}},
    5: {"cost": 2, "channels": {"line"},
        "entries": {"deep-bell": ("answer", {"tone": "below-hearing", "count": 1}, 0)}},
}


@dataclass(frozen=True)
class Result:
    kind: Kind
    surveyed: tuple[int, ...]
    spent: int
    supplied: int
    remaining: int
    payload: Any = None
    pending_delay: int | None = None


def descend(term: str, maximum: int, channel: str, budget: int,
            repair: bool = False) -> Result:
    surveyed: list[int] = []
    spent = supplied = 0
    remaining = budget
    for depth in range(maximum + 1):
        layer = LAYERS[depth]
        cost = layer["cost"]
        if remaining < cost:
            if not repair:
                return Result("timeout", tuple(surveyed), spent, supplied, remaining)
            deficit = cost - remaining
            supplied += deficit
            remaining += deficit
        remaining -= cost
        spent += cost
        surveyed.append(depth)
        if channel not in layer["channels"]:
            return Result("occluded", tuple(surveyed), spent, supplied, remaining)
        entry = layer["entries"].get(term)
        if entry is None:
            continue
        kind, payload, delay = entry
        if kind == "refused":
            return Result("refused", tuple(surveyed), spent, supplied, remaining)
        assert kind == "answer"
        assert delay is not None
        if delay <= remaining:
            return Result("answer", tuple(surveyed), spent + delay,
                          supplied, remaining - delay, payload)
        return Result("in-transit", tuple(surveyed), spent, supplied,
                      remaining, pending_delay=delay)
    return Result("bounded-absence", tuple(surveyed), spent, supplied, remaining)


near = descend("near-voice", 1, "line", 2)
refused = descend("sealed-name", 2, "line", 4)
absent = descend("white-whale", 2, "line", 4)
timeout = descend("deep-bell", 5, "line", 4)
repaired = descend("deep-bell", 5, "line", 4, repair=True)
occluded = descend("deep-bell", 5, "sonar", 20)
transit = descend("ascending-word", 3, "line", 5)

assert near.kind == "answer" and near.surveyed == (0, 1)
assert refused.kind == "refused" and refused.surveyed == (0, 1, 2)
assert absent.kind == "bounded-absence" and absent.surveyed == (0, 1, 2)
assert timeout.kind == "timeout" and timeout.surveyed == (0, 1, 2)
assert repaired.kind == "answer" and repaired.supplied == 5
assert repaired.surveyed == (0, 1, 2, 3, 4, 5)
assert occluded.kind == "occluded" and occluded.surveyed == (0, 1, 2)
assert transit.kind == "in-transit" and transit.pending_delay == 4

print("PASS independent depth model")
print("kinds:", [near.kind, refused.kind, absent.kind, timeout.kind,
                 repaired.kind, occluded.kind, transit.kind])
print("repaired supplied:", repaired.supplied)
print("timeout surveyed:", timeout.surveyed)
print("transit delay:", transit.pending_delay)
