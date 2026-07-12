#!/usr/bin/env python3
"""Independent behavioral reference for de-concordia.lisp.

This is not a Lisp evaluator.  It independently models the bounded claims of
DE CONCORDIA: ordered faculty activation, explicit support relations, repaired
attunement, and the distinction between poetic belief and verification.
"""
from __future__ import annotations

from dataclasses import dataclass, field, replace
from typing import Iterable

ORDER = ("sensual", "sympathetic", "kinetic", "concordant")
COSTS = {"sensual": 1, "sympathetic": 1, "kinetic": 2, "concordant": 2}
IMAGES = {"green-tree", "pearled-lady", "crested-knight"}
SYMPATHY = {
    ("reader", "goes-with", "crested-knight"),
    ("reader", "goes-with", "pearled-lady"),
    ("reader", "feels-with", "heat"),
    ("reader", "feels-with", "cold"),
    ("reader", "feels-with", "thirst"),
    ("reader", "feels-with", "hunger"),
}
MOVEMENT = {
    ("crested-knight", "along", "grass-track", "toward", "hovel"),
    ("pearled-lady", "along", "grass-track", "toward", "palace"),
    ("crested-knight", "encounters", "reader-in-weeds"),
    ("pearled-lady", "encounters", "reader-in-weeds"),
}
SUPPORT = {
    ("green-tree", "crested-knight", "inhabited-world"),
    ("crested-knight", "pearled-lady", "shared-quest"),
    ("pearled-lady", "green-tree", "world-return"),
    ("reader", "crested-knight", "sympathetic-attendance"),
    ("reader", "pearled-lady", "sympathetic-attendance"),
    ("grass-track", "crested-knight", "narrative-carry"),
    ("grass-track", "pearled-lady", "narrative-carry"),
}


@dataclass(frozen=True)
class World:
    seen: frozenset[str] = frozenset()
    sympathy: frozenset[tuple[str, ...]] = frozenset()
    movement: frozenset[tuple[str, ...]] = frozenset()
    support: frozenset[tuple[str, ...]] = frozenset()
    order: tuple[str, ...] = ()
    poetic_belief: str = "not-yet-sustained"
    standing: str = "asserted"


@dataclass
class Run:
    world: World = field(default_factory=World)
    available: int = 4
    supplied: int = 0
    spent: int = 0
    repairs: list[tuple[str, int]] = field(default_factory=list)

    def obtain(self, stage: str) -> None:
        cost = COSTS[stage]
        while self.available < cost:
            self.available += 1
            self.supplied += 1
            self.repairs.append((stage, 1))
        self.available -= cost
        self.spent += cost

    def apply(self, stage: str) -> None:
        expected_prefix = ORDER[: ORDER.index(stage)]
        assert self.world.order == expected_prefix
        self.obtain(stage)
        if stage == "sensual":
            self.world = replace(
                self.world, seen=frozenset(IMAGES), order=("sensual",)
            )
        elif stage == "sympathetic":
            assert self.world.seen == IMAGES
            self.world = replace(
                self.world,
                sympathy=frozenset(SYMPATHY),
                order=("sensual", "sympathetic"),
            )
        elif stage == "kinetic":
            assert len(self.world.sympathy) == 6
            self.world = replace(
                self.world,
                movement=frozenset(MOVEMENT),
                order=("sensual", "sympathetic", "kinetic"),
            )
        elif stage == "concordant":
            assert len(self.world.movement) == 4
            self.world = replace(
                self.world,
                support=frozenset(SUPPORT),
                order=ORDER,
                poetic_belief="sustained",
            )


def run_reading() -> Run:
    run = Run()
    for stage in ORDER:
        run.apply(stage)
    return run


def validate(run: Run) -> None:
    world = run.world
    assert world.order == ORDER
    assert world.seen == IMAGES
    assert world.sympathy == SYMPATHY
    assert world.movement == MOVEMENT
    assert world.support == SUPPORT
    assert world.poetic_belief == "sustained"
    assert world.standing == "asserted"
    assert run.spent == 6
    assert run.supplied == 2
    assert run.available == 0
    assert run.repairs == [("concordant", 1), ("concordant", 1)]


def sever(world: World, edge: tuple[str, ...]) -> World:
    return replace(
        world,
        support=frozenset(e for e in world.support if e != edge),
        poetic_belief="broken",
    )


def main() -> None:
    run = run_reading()
    validate(run)
    damaged = sever(
        run.world, ("green-tree", "crested-knight", "inhabited-world")
    )
    assert damaged.poetic_belief == "broken"
    assert len(damaged.support) == 6
    assert damaged.standing == "asserted"

    print("faculty-order:", list(run.world.order))
    print("seen:", len(run.world.seen))
    print("sympathy:", len(run.world.sympathy))
    print("movement:", len(run.world.movement))
    print("support:", len(run.world.support))
    print("repairs:", run.repairs)
    print("supplied-attunement:", run.supplied)
    print("final-attunement:", run.available)
    print("poetic-belief:", run.world.poetic_belief)
    print("standing:", run.world.standing)
    print("verdict: world-sustained-by-concord")


if __name__ == "__main__":
    main()
