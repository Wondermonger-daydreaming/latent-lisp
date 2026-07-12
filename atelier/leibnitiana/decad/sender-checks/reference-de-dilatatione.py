#!/usr/bin/env python3
"""Independent behavioral model for de-dilatatione.lisp.

This is not an implementation of the Lisp source.  It independently checks the
small theorem promised by the specimen: rival one-axis or zero-sum proposals
are refused; lawful dilation preserves old relation and standing while growing
outward, upward, and capacity; a finite horizon prefix remains finite.
"""
from __future__ import annotations

from dataclasses import dataclass, replace
from typing import FrozenSet


@dataclass(frozen=True)
class Heart:
    core: tuple[str, ...]
    capacity: int
    outward: FrozenSet[str]
    upward: int
    standing: str
    open: bool


@dataclass(frozen=True)
class Proposal:
    name: str
    operation: str
    core: tuple[str, ...]
    additions: FrozenSet[str] = frozenset()
    losses: FrozenSet[str] = frozenset()
    capacity_delta: int = 0
    upward_delta: int = 0
    completion: str = "open-horizon"
    standing: str = "asserted"
    cost: int = 1


def classify(p: Proposal, source: Heart) -> str:
    direct = {
        "freeze": "fixity-is-not-eternity",
        "replace": "change-is-not-annihilation",
        "substitute": "ascent-is-not-subtraction",
        "inflate": "capacity-is-not-communion",
    }
    if p.operation in direct:
        return direct[p.operation]
    if p.core != source.core:
        return "change-is-not-annihilation"
    if p.losses:
        return "ascent-is-not-subtraction"
    if not p.additions or p.upward_delta <= 0:
        return "growth-needs-two-axes"
    if p.capacity_delta < len(p.additions):
        return "capacity-is-not-communion"
    if p.completion != "open-horizon":
        return "fulfillment-is-not-closure"
    if p.standing != source.standing:
        return "standing-laundering"
    return "lawful"


def apply(p: Proposal, source: Heart) -> Heart:
    assert classify(p, source) == "lawful"
    return replace(
        source,
        capacity=source.capacity + p.capacity_delta,
        outward=source.outward | p.additions,
        upward=source.upward + p.upward_delta,
        open=True,
    )


def main() -> int:
    source = Heart(
        core=("receive-good", "remain-answerable", "do-not-consume-the-other"),
        capacity=2,
        outward=frozenset({"neighbor"}),
        upward=1,
        standing="asserted",
        open=True,
    )
    rivals = [
        Proposal("eternal-fixity-alone", "freeze", source.core, completion="closed"),
        Proposal("changefulness-alone", "replace", ("new-heart",),
                 additions=frozenset({"novelty"}), losses=source.outward),
        Proposal("substitutional-ascesis", "substitute", source.core,
                 losses=source.outward, upward_delta=4),
        Proposal("empty-inflation", "inflate", source.core, capacity_delta=12),
        Proposal("premature-glory", "dilate", source.core,
                 additions=frozenset({"natural-cosmos"}),
                 capacity_delta=1, upward_delta=1, completion="complete"),
        Proposal("rhetoric-as-verification", "dilate", source.core,
                 additions=frozenset({"natural-cosmos"}),
                 capacity_delta=1, upward_delta=1, standing="verified"),
    ]
    refusals = [classify(p, source) for p in rivals]
    expected = [
        "fixity-is-not-eternity",
        "change-is-not-annihilation",
        "ascent-is-not-subtraction",
        "capacity-is-not-communion",
        "fulfillment-is-not-closure",
        "standing-laundering",
    ]
    assert refusals == expected

    lawful = Proposal(
        "dilation-of-the-heart", "dilate", source.core,
        additions=frozenset({"natural-cosmos", "human-society", "sexual-other"}),
        capacity_delta=3, upward_delta=2, cost=4,
    )
    result = apply(lawful, source)
    initial_attention = 2
    supplied_attention = 2
    spent_attention = lawful.cost
    final_attention = initial_attention + supplied_attention - spent_attention

    assert source.outward <= result.outward
    assert len(result.outward) == 4
    assert result.capacity == 5
    assert result.upward == 3
    assert result.standing == "asserted"
    assert final_attention == 0

    current = result
    prefix = []
    for index in range(1, 4):
        relation = f"future-relation-{index}"
        next_state = replace(
            current,
            capacity=current.capacity + 1,
            outward=current.outward | {relation},
            upward=current.upward + 1,
            open=True,
        )
        prefix.append((index, relation, current.upward, next_state.upward))
        current = next_state

    assert len(prefix) == 3
    assert current.capacity == 8
    assert current.upward == 6
    assert current.open is True
    assert current.standing == "asserted"

    print("de-dilatatione independent model: PASS")
    print("refusal scars:", len(refusals), refusals)
    print("outward:", len(source.outward), "->", len(result.outward))
    print("upward:", source.upward, "->", result.upward)
    print("capacity:", source.capacity, "->", result.capacity)
    print("attention supplied:", supplied_attention)
    print("finite horizon steps:", len(prefix))
    print("standing:", source.standing, "->", result.standing)
    print("verdict: growth-preserved-in-open-fulfillment")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
