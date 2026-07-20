#!/usr/bin/env python3
"""ss0_provider.py — SS-0 deterministic provider fixture, Python side.

Byte-identical world artifacts to ss0-provider.lisp for the same
(tag, attempt_id, seed): same provider.log lines, same receipt files.
The provider does NOT deduplicate and interprets none of your records.
"""
from pathlib import Path

from ss0_substrate import crc32_hex


def _world_append(run_dir, line):
    with open(Path(run_dir) / "provider.log", "a") as f:
        f.write(line + "\n")


def _receipt(run_dir, attempt_id, label, outcome):
    (Path(run_dir) / f"receipt-{attempt_id}.txt").write_text(
        f"PROVIDER RECEIPT\neffect: {label}\nattempt: {attempt_id}\noutcome: {outcome}\n")


def _digest(label, attempt_id, seed):
    return crc32_hex(f"{seed}|{label}|{attempt_id}".encode("utf-8"))


def provider_dispatch(run_dir, tag, attempt_id, seed="ss0"):
    """Same contract as the CL side; see its docstring."""
    if tag.startswith("effect:"):
        label = tag[7:]
        _world_append(run_dir, "EXECUTED effect=%s attempt=%s digest=%s"
                      % (label, attempt_id, _digest(label, attempt_id, seed)))
        _receipt(run_dir, attempt_id, label, "executed")
        return {"status": "executed", "label": label}
    if tag.startswith("effect-ne:"):
        label = tag[10:]
        _world_append(run_dir, "RECEIVED-NOT-EXECUTED effect=%s attempt=%s"
                      % (label, attempt_id))
        _receipt(run_dir, attempt_id, label, "not-executed")
        return {"status": "not-executed", "label": label}
    if tag.startswith("complete:"):
        return {"status": "payload", "payload": tag[9:]}
    if tag == "empty":
        return {"status": "payload", "payload": ""}
    if tag == "invalid":
        return {"status": "payload", "payload": "\x00NOT-VALID\x00"}
    if tag.startswith("slow:"):
        n = int(tag[5:])
        return {"status": "stream", "chunks": n,
                "chunk_fn": lambda i: f"chunk-{i}-of-{attempt_id}"}
    return {"status": "unknown-tag"}
