#!/usr/bin/env python3
"""Independent behavioral model for de-incantatione.lisp.

This does not parse or execute the Common Lisp source.  It reconstructs the
bounded rhyme/office/resource model from first principles so the relay has a
second implementation against which to compare intended behavior.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Tuple


SCHEME: Tuple[str, ...] = ("A", "B", "B", "A", "C", "D", "D", "E", "E", "C")
END_WORDS: Tuple[str, ...] = (
    "Melancholy", "born", "forlorn", "unholy", "cell",
    "wings", "sings", "rocks", "locks", "dwell",
)
INTERNAL_ECHO = (10, "ER", "desert", "ever")
TERMINAL_KEY = "C"


@dataclass(frozen=True)
class Obligation:
    key: str
    opener_line: int
    closer_line: int
    opener_word: str
    closer_word: str
    enclosed_keys: Tuple[str, ...]

    @property
    def span(self) -> int:
        return self.closer_line - self.opener_line


@dataclass(frozen=True)
class Event:
    line: int
    kind: str
    key: str
    word: str


def obligations() -> Dict[str, Obligation]:
    seen: Dict[str, Tuple[int, str]] = {}
    raw: Dict[str, Tuple[int, int, str, str]] = {}
    for line, (key, word) in enumerate(zip(SCHEME, END_WORDS), start=1):
        if key in seen:
            first_line, first_word = seen.pop(key)
            raw[key] = (first_line, line, first_word, word)
        else:
            seen[key] = (line, word)
    assert not seen, f"unmated rhyme keys: {seen}"

    result: Dict[str, Obligation] = {}
    for key, (opener, closer, left, right) in raw.items():
        enclosed = tuple(
            inner_key
            for inner_key, (i_open, i_close, _, _) in raw.items()
            if opener < i_open and i_close < closer
        )
        result[key] = Obligation(key, opener, closer, left, right, enclosed)
    return result


def recite(limit: int, initial_breath: int, supplied: List[int] | None = None):
    supplied = list(supplied or [])
    open_keys: List[str] = []
    events: List[Event] = []
    breath = initial_breath
    supplied_total = 0

    for line in range(1, limit + 1):
        while breath < 1:
            assert supplied, f"breath exhausted at line {line} without repair"
            amount = supplied.pop(0)
            assert amount > 0
            breath += amount
            supplied_total += amount
        breath -= 1

        key = SCHEME[line - 1]
        word = END_WORDS[line - 1]
        if key in open_keys:
            open_keys.remove(key)
            events.append(Event(line, "close", key, word))
        else:
            open_keys.append(key)
            events.append(Event(line, "open", key, word))

        if line == INTERNAL_ECHO[0]:
            events.insert(-1, Event(line, "echo-only", INTERNAL_ECHO[1],
                                    f"{INTERNAL_ECHO[2]}/{INTERNAL_ECHO[3]}"))

    return {
        "events": events,
        "open": tuple(open_keys),
        "complete": limit == len(SCHEME) and not open_keys,
        "initial": initial_breath,
        "supplied": supplied_total,
        "spent": limit,
        "remaining": breath,
    }


def main() -> None:
    obs = obligations()
    assert set(obs) == {"A", "B", "C", "D", "E"}
    assert obs["A"].span == 3 and obs["A"].enclosed_keys == ("B",)
    assert obs["B"].span == 1
    assert obs["C"].span == 5 and obs["C"].enclosed_keys == ("D", "E")
    assert obs["D"].span == 1 and obs["E"].span == 1
    assert obs["C"].closer_line == 10 and obs["C"].closer_word == "dwell"

    partial = recite(9, 9)
    assert partial["open"] == ("C",)
    assert not partial["complete"]

    repaired = recite(10, 7, [1, 1, 1])
    assert repaired["complete"]
    assert repaired["open"] == ()
    assert repaired["supplied"] == 3
    assert repaired["spent"] == 10
    assert repaired["remaining"] == 0
    assert repaired["events"][-2].kind == "echo-only"
    assert repaired["events"][-2].key == "ER"
    assert repaired["events"][-1] == Event(10, "close", "C", "dwell")

    chamber_before = {"melancholy": "present", "standing": "asserted", "epoch": 0}
    chamber_after = dict(chamber_before)
    chamber_after.update(melancholy="banished-from-chamber", epoch=1)
    assert chamber_after["standing"] == "asserted"

    # The premature performance is retained as a named misfire, not rewritten
    # into success or erased as a null result.
    misfire = {
        "condition": "premature-banishment",
        "open_rhymes": partial["open"],
        "standing": "asserted",
    }
    assert misfire["open_rhymes"] == ("C",)

    print("PASS independent incantation model")
    print("scheme:", "".join(SCHEME))
    print("obligations:",
          {k: (v.opener_line, v.closer_line, v.enclosed_keys)
           for k, v in sorted(obs.items())})
    print("line-9 open:", partial["open"])
    print("internal echo:", INTERNAL_ECHO[2], "->", INTERNAL_ECHO[3], "(echo-only)")
    print("terminal closure:", obs["C"].opener_word, "->", obs["C"].closer_word)
    print("breath:", {k: repaired[k] for k in ("initial", "supplied", "spent", "remaining")})
    print("outcome:", chamber_after["melancholy"])
    print("standing:", chamber_before["standing"], "->", chamber_after["standing"])
    print("misfires:", 1)


if __name__ == "__main__":
    main()
