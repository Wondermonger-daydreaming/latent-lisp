#!/usr/bin/env python3
"""folder.py — the independent Python fold (F2 differential conformance).

Reads a KWJ0 journal written by the Common Lisp side, validates the frame
chain with an INDEPENDENT implementation (hashlib, struct — no shared code),
decodes payloads with the project's own Python CD0 codec, and folds the same
derived state. Prints a canonical state digest for byte-comparison against
the CL reconstructor's digest.

Usage: python3 folder.py <journal-path>
"""
import hashlib
import json
import struct
import sys
from pathlib import Path

import os
REPO = os.environ.get("KW_REPO", "/tmp/latent-lisp/")
sys.path.insert(0, REPO + "canonical-datum/python")
import cd0  # the project's own codec

MAGIC = b"KWJ0"
_BUDGET_DOC = json.loads(
    Path(REPO + "canonical-datum/vectors/cd0-budgets.json").read_text())
BUDGET = cd0.ResourceBudget.from_mapping(
    _BUDGET_DOC["budgets"]["cd0-conformance-default"],
    identifier="cd0-conformance-default")


def validate_prefix(path):
    """Independent re-implementation of the KWJ0 prefix validator."""
    data = Path(path).read_bytes()
    frames = []
    pos = 0
    prev = bytes(16)
    while pos < len(data):
        remaining = len(data) - pos
        if remaining < 8:
            return frames, "torn-tail", f"partial header at offset {pos}"
        if data[pos:pos + 4] != MAGIC:
            return frames, "prefix-invalid", f"bad magic at offset {pos}"
        plen = struct.unpack(">I", data[pos + 4:pos + 8])[0]
        end = pos + 8 + plen + 48
        if end > len(data):
            return frames, "torn-tail", f"partial frame at offset {pos}"
        payload = data[pos + 8:pos + 8 + plen]
        pd_stored = data[pos + 8 + plen:pos + 8 + plen + 16]
        prev_stored = data[pos + 8 + plen + 16:pos + 8 + plen + 32]
        fd_stored = data[pos + 8 + plen + 32:end]
        pd = hashlib.md5(payload).digest()
        fd = hashlib.md5(data[pos:pos + 8] + payload + pd + prev).digest()
        if pd != pd_stored:
            return frames, "prefix-invalid", f"payload digest mismatch at {pos}"
        if prev_stored != prev:
            return frames, "prefix-invalid", f"chain break at {pos}"
        if fd != fd_stored:
            return frames, "prefix-invalid", f"frame digest mismatch at {pos}"
        frames.append(payload)
        prev = fd
        pos = end
    return frames, ("clean" if frames else "clean-empty"), "complete prefix"


def decode_event(payload):
    datum = cd0.decode_exact(bytes(payload), BUDGET)
    ev = {}
    for key, value in datum.fields:
        name = key.path[-1]
        if isinstance(value, cd0.String):
            ev[name] = value.value
        elif isinstance(value, cd0.Integer):
            ev[name] = value.value
    return ev


def fold_state(payloads):
    """Same derivation as the CL fold: uncertainty from the event pattern."""
    begun, crossed, settled, terminal = [], set(), set(), set()
    superseded, supersessions, receipts, manifestations = set(), 0, 0, 0
    seats = []
    for p in payloads:
        try:
            ev = decode_event(p)
        except Exception:
            continue
        et, aid = ev.get("event-type"), ev.get("attempt-id")
        if et == "seat-reserved":
            seats.append(ev.get("seat-id"))
        elif et == "attempt-begun":
            begun.append(aid)
        elif et == "frontier-crossed":
            crossed.add(aid)
        elif et == "effect-settled":
            settled.add(aid)
        elif et in ("attempt-completed", "attempt-failed", "attempt-reconciled"):
            terminal.add(aid)
            if et == "attempt-completed":
                receipts += 1
        elif et == "attempt-superseded":
            superseded.add(ev.get("predecessor-attempt-id"))
            supersessions += 1
        elif et == "manifestation-recorded":
            manifestations += 1
    uncertain = [a for a in begun
                 if a in crossed and a not in settled
                 and a not in terminal and a not in superseded]
    return {
        "seats": seats,
        "attempts": begun,
        "frontier-crossed": sorted(crossed),
        "uncertain-effects": uncertain,
        "settled-effects": sorted(settled),
        "terminal": sorted(terminal),
        "superseded": sorted(superseded),
        "supersessions": supersessions,
        "receipt-frames": receipts,
        "manifestation-frames": manifestations,
    }


def state_digest(state):
    """Canonical digest: lists sorted, keys in fixed order — matches the CL
    canonical form exactly (sorted-set semantics; order is incidental)."""
    parts = []
    for key in ["seats", "attempts", "frontier-crossed", "uncertain-effects",
                "settled-effects", "terminal", "superseded", "supersessions",
                "receipt-frames", "manifestation-frames"]:
        v = state[key]
        if isinstance(v, list):
            v = ",".join(sorted(x for x in v if x is not None))
        parts.append(f"{key}={v};")
    return hashlib.md5("".join(parts).encode()).hexdigest().upper()


def main():
    frames, status, detail = validate_prefix(sys.argv[1])
    state = fold_state(frames)
    print(f"python-folder: status={status} detail={detail}")
    print(f"python-folder: valid-frames={len(frames)}")
    print(f"python-folder: uncertain={state['uncertain-effects']}")
    print(f"python-folder: state-digest={state_digest(state)}")


if __name__ == "__main__":
    main()
