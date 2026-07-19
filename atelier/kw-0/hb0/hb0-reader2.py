#!/usr/bin/env python3
"""hb0-reader2.py — the INDEPENDENT second reader of the HB-0 control's log
(commission clause 3). Author: Fable, 2026-07-19. Shares no code with
hb0-control.lisp; parses the restricted plist-per-line grammar directly.

Usage: python3 hb0-reader2.py <run-dir>
Prints the derived recovery state and the canonical digest
(spec: attempts=..;uncertain=..;settled=..;receipts=N;chunks=N; sorted, comma-joined, MD5 upper).
"""
import hashlib
import re
import sys
from pathlib import Path

TOKEN = re.compile(r'"(?:[^"\\]|\\.)*"|[()]|[^\s()"]+')


def parse_line(line):
    """Parse one flat plist line into a dict of keyword->value. Raise on malformed."""
    toks = TOKEN.findall(line)
    if not toks or toks[0] != "(" or toks[-1] != ")":
        raise ValueError("not a plist line")
    inner = toks[1:-1]
    if len(inner) % 2:
        raise ValueError("odd plist")
    d = {}
    for k, v in zip(inner[::2], inner[1::2]):
        if not k.startswith(":"):
            raise ValueError("key is not a keyword")
        if v.startswith('"') and v.endswith('"'):
            v = v[1:-1]
        d[k.upper()] = v.upper() if v.startswith(":") else v
    return d


def read_events(path):
    raw = Path(path).read_bytes().decode("utf-8", errors="replace")
    events, torn = [], False
    nl_terminated = raw.endswith("\n")
    lines = raw.split("\n")
    body = lines[:-1] if nl_terminated else lines[:-1]
    tail = "" if nl_terminated else lines[-1]
    for line in body:
        if not line:
            continue
        try:
            events.append(parse_line(line))
        except ValueError:
            torn = True
            break
    if tail:
        torn = True
    return events, torn


def fold(events):
    attempts, dispatched, settled, evidenced, receipts, chunks, superseded = [], [], [], [], 0, 0, []
    for e in events:
        ev = e.get(":EV")
        if ev == ":ATTEMPT":
            attempts.append(e[":ID"])
        elif ev == ":DISPATCH":
            dispatched.append(e[":ID"])
        elif ev == ":RESULT":
            settled.append(e[":ID"])
        elif ev == ":EVIDENCE":
            evidenced.append(e[":ID"])
        elif ev == ":RECONCILE":
            settled.append(e[":ID"])
        elif ev == ":RECEIPT":
            receipts += 1
        elif ev == ":CHUNK":
            chunks += 1
        elif ev == ":SUPERSEDE":
            superseded.append(e[":OVER"])
    resolved = set(settled) | set(evidenced)
    uncertain = [a for a in dispatched if a not in resolved and a not in superseded]
    return {"attempts": attempts, "uncertain": uncertain,
            "settled": sorted(resolved), "receipts": receipts, "chunks": chunks}


def digest(state):
    s = ("attempts=%s;uncertain=%s;settled=%s;receipts=%d;chunks=%d;" % (
        ",".join(sorted(state["attempts"])), ",".join(sorted(state["uncertain"])),
        ",".join(state["settled"]), state["receipts"], state["chunks"]))
    return hashlib.md5(s.encode()).hexdigest().upper()


def main():
    run_dir = Path(sys.argv[1])
    events, torn = read_events(run_dir / "witness.journal")
    state = fold(events)
    print(f"events: {len(events)} torn: {torn}")
    print(f"state: {state}")
    print(f"origin: reconstructed")
    print(f"state-digest: {digest(state)}")


if __name__ == "__main__":
    main()
