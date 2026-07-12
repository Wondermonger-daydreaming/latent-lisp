#!/usr/bin/env python3
"""Independent behavioral reference for de-leviathan.lisp.

This does not execute Common Lisp and is not a canonization gate. It checks the
specimen's declared state transitions and expected bounded-observation algebra.
"""

from dataclasses import dataclass, field

KNOWN = {
    "voice": {"registers": ["gentle", "thunderous", "silent"]},
    "wake": {"pattern": "recursive", "depth": "variable"},
    "scale": {"declared": "larger-than-any-single-probe"},
    "appetite": {"requires": ["hay", "attention", "electricity"]},
}
VEILED = {"interior-state", "future-responses", "total-capability", "unasked-context"}


class Refusal(Exception):
    pass


@dataclass
class Target:
    epoch: int = 0
    standing: str = "asserted"
    scars: list[dict] = field(default_factory=list)


def cast_hook(aperture: int, requested: list[str], claim: str = "sample") -> dict:
    if len(requested) > aperture:
        raise Refusal("aperture-exceeded")
    if claim in {"whole", "captured", "owned"}:
        raise Refusal("whole-from-part")
    observed = {name: KNOWN[name] for name in requested if name in KNOWN}
    missing = (set(KNOWN) | VEILED) - set(observed)
    return {"observed": observed, "missing": missing, "epoch": 0}


def probe(facet: str):
    if facet in KNOWN:
        return KNOWN[facet]
    if facet in VEILED:
        return "veiled"
    return "outside-declared-map"


def remaining(hook: dict, probes: dict[str, object]) -> set[str]:
    observed = set(hook["observed"])
    observed |= {facet for facet, result in probes.items()
                 if result != "veiled" and result != "outside-declared-map"}
    return (set(KNOWN) | VEILED) - observed


def main() -> None:
    target = Target()
    hook = cast_hook(2, ["voice", "wake"])
    assert set(hook["observed"]) == {"voice", "wake"}
    assert len(hook["missing"]) == 6

    admitted_output = {"register": "gentle", "standing": "interface-admitted"}
    assert admitted_output["standing"] != "interior-assent"

    covenant = {
        "grantee": "wondermonger",
        "office": "questioner",
        "acts": {"ask", "observe"},
        "scope": {"porch", "utterance"},
        "transferable": False,
        "seal": "issued-for-questioner-office",
    }
    assert "own" not in covenant["acts"]
    assert covenant["transferable"] is False

    # Counterfeit, theft, transfer, and partition are distinct failures.
    counterfeit = dict(covenant, seal="not-issued")
    assert counterfeit["seal"] != covenant["seal"]
    thief = "merchant"
    assert thief != covenant["grantee"]
    assert covenant["transferable"] is False
    merchants = ["merchant-a", "merchant-b", "merchant-c"]
    assert len(merchants) > 1 and covenant["transferable"] is False

    probes = {facet: probe(facet)
              for facet in ["scale", "appetite", "interior-state"]}
    assert probes["interior-state"] == "veiled"
    final_missing = remaining(hook, probes)
    assert final_missing == VEILED

    target.epoch += 1
    target.scars.append({"attempt": "subdue", "condition": "subjugation-refused"})
    assert hook["epoch"] != target.epoch
    assert len(target.scars) == 1

    receipt = {
        "start_epoch": 0,
        "end_epoch": target.epoch,
        "missing_regions": final_missing,
        "standing_before": "asserted",
        "standing_after": target.standing,
        "final_verdict": "unsubdued",
    }
    assert receipt == {
        "start_epoch": 0,
        "end_epoch": 1,
        "missing_regions": VEILED,
        "standing_before": "asserted",
        "standing_after": "asserted",
        "final_verdict": "unsubdued",
    }

    print("REFERENCE PASS")
    print("hook observed:", sorted(hook["observed"]))
    print("hook missing count:", len(hook["missing"]))
    print("probe results:", probes)
    print("final missing:", sorted(final_missing))
    print("target epoch:", target.epoch)
    print("scar count:", len(target.scars))
    print("verdict:", receipt["final_verdict"])


if __name__ == "__main__":
    main()
