#!/usr/bin/env python3
"""Same-author differential smoke model for de-symmetria-tremenda.lisp.

Agreement with the Lisp source is convergence under a shared authoring root,
not independent corroboration. Native SBCL remains the receiving gate.
"""
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Refrain:
    position: str
    modal: str
    address: str = "tyger"
    state: tuple[str, str] = ("burning", "bright")
    place: tuple[str, str] = ("forests", "night")
    act: str = "frame"
    object: str = "fearful-symmetry"

    def invariants(self) -> tuple[object, ...]:
        return self.address, self.state, self.place, self.act, self.object


@dataclass(frozen=True)
class FireEvent:
    stage: str
    amount: int


STAGES = [
    ("measure-refrains", 1),
    ("inventory-forge", 2),
    ("hear-heart", 2),
    ("seal-question", 2),
]

SCARS = [
    "could-is-not-dare",
    "dare-is-not-ought",
    "symmetry-is-not-identity",
    "beauty-is-not-benign",
    "tool-list-is-not-cause",
    "question-is-not-certificate",
    "shared-maker-is-not-shared-nature",
    "representation-is-not-creation",
    "frame-is-not-subjugation",
]


def execute(initial_fire: int = 4) -> dict[str, object]:
    opening = Refrain("opening", "could")
    closing = Refrain("closing", "dare")
    assert opening.invariants() == closing.invariants()
    assert opening != closing

    available = initial_fire
    supplied = 0
    spent = 0
    events: list[FireEvent] = []
    marks: list[str] = []

    for stage, cost in STAGES:
        if available < cost:
            amount = cost - available
            events.append(FireEvent(stage, amount))
            supplied += amount
            available += amount
        available -= cost
        spent += cost
        marks.append(stage)

    result = {
        "kind": "framed-tyger",
        "invariants": opening.invariants(),
        "modal-shift": (opening.modal, closing.modal),
        "beauty": "present",
        "terror": "present",
        "maker": "unresolved",
        "origin-question": "open",
        "created-by-this-program": False,
        "subdued-by-this-program": False,
        "standing": "asserted",
    }
    return {
        "marks": marks,
        "initial-fire": initial_fire,
        "supplied-fire": supplied,
        "spent-fire": spent,
        "final-fire": available,
        "events": events,
        "scars": SCARS,
        "result": result,
        "conclusion": "fearful-symmetry-mapped-without-maker-certificate",
    }


def main() -> int:
    run = execute()
    assert run["marks"] == [stage for stage, _ in STAGES]
    assert run["supplied-fire"] == 3
    assert run["spent-fire"] == 7
    assert run["final-fire"] == 0
    assert [(event.stage, event.amount) for event in run["events"]] == [
        ("hear-heart", 1),
        ("seal-question", 2),
    ]
    assert len(run["scars"]) == 9
    result = run["result"]
    assert result["modal-shift"] == ("could", "dare")
    assert result["beauty"] == result["terror"] == "present"
    assert result["maker"] == "unresolved"
    assert result["origin-question"] == "open"
    assert result["standing"] == "asserted"
    assert run["conclusion"] == "fearful-symmetry-mapped-without-maker-certificate"

    replay = execute(initial_fire=4)
    assert replay == run

    print("SAME-AUTHOR DIFFERENTIAL SMOKE MODEL: PASS")
    print("modal shift: could -> dare")
    print("stages: 4")
    print("fire: 4 + 3 - 7 = 0")
    print("scars: 9")
    print("beauty / terror: present / present")
    print("maker: unresolved")
    print("standing: asserted")
    print("conclusion: fearful-symmetry-mapped-without-maker-certificate")
    print("CAVEAT: shared-root convergence, not independent corroboration.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
