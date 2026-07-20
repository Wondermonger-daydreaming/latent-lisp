#!/usr/bin/env python3
"""ss0_substrate.py — SS-0 shared substrate, Python side.

Storage (framed append-only + CRC32 + fsync), canonical serialization,
death-window helper. NO semantic vocabulary, NO recovery logic — see
SS0-SUBSTRATE-API.md §6 (negative space, binding; audited by VOID-2).
Byte-compatible with ss0-substrate.lisp: identical frames, identical
canonical serialization.
"""
import os
import struct
import time
import zlib
from pathlib import Path


def crc32(data: bytes) -> int:
    return zlib.crc32(data) & 0xFFFFFFFF


def crc32_hex(data: bytes) -> str:
    return "%08X" % crc32(data)


def _records_path(run_dir):
    return Path(run_dir) / "records.log"


def store_append(run_dir, payload: bytes, durable: bool = True) -> None:
    """Append one framed record: u32-be len | payload | u32-be crc."""
    with open(_records_path(run_dir), "ab") as f:
        f.write(struct.pack(">I", len(payload)))
        f.write(payload)
        f.write(struct.pack(">I", crc32(payload)))
        f.flush()
        if durable:
            os.fsync(f.fileno())


def store_append_torn(run_dir, payload: bytes, fraction: float) -> None:
    """@harness torn-frame injection: length header + partial payload,
    no CRC, no fsync. Death instrumentation only."""
    with open(_records_path(run_dir), "ab") as f:
        f.write(struct.pack(">I", len(payload)))
        f.write(payload[: int(len(payload) * fraction)])
        f.flush()


def store_read_prefix(run_dir):
    """Return (payload_list, tail_status) with tail_status 'clean'|'torn'.
    Every intact frame in order; first incomplete or CRC-failing frame
    ends the prefix and is discarded."""
    p = _records_path(run_dir)
    if not p.exists():
        return [], "clean"
    data = p.read_bytes()
    payloads, pos, n = [], 0, len(data)
    while True:
        if pos == n:
            return payloads, "clean"
        if n - pos < 4:
            return payloads, "torn"
        (length,) = struct.unpack(">I", data[pos:pos + 4])
        if n - pos - 4 < length + 4:
            return payloads, "torn"
        payload = data[pos + 4:pos + 4 + length]
        (crc,) = struct.unpack(">I", data[pos + 4 + length:pos + 8 + length])
        if crc != crc32(payload):
            return payloads, "torn"
        payloads.append(payload)
        pos += 8 + length


# ---------- canonical serialization (spec identical to CL side) ----------

def _escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace("\t", "\\t").replace("\n", "\\n")


def _unescape(s: str) -> str:
    out, i = [], 0
    while i < len(s):
        if s[i] == "\\" and i + 1 < len(s):
            nxt = s[i + 1]
            if nxt == "\\":
                out.append("\\")
            elif nxt == "t":
                out.append("\t")
            elif nxt == "n":
                out.append("\n")
            else:
                raise ValueError("bad escape")
            i += 2
        else:
            out.append(s[i])
            i += 1
    return "".join(out)


def ser_encode(mapping: dict) -> bytes:
    """dict of str -> (str|int|bool) -> canonical bytes."""
    lines = []
    for key in sorted(mapping.keys()):
        v = mapping[key]
        if isinstance(v, bool):  # NB: before int check — bool is int in Python
            t, raw = "b", ("true" if v else "false")
        elif isinstance(v, int):
            t, raw = "i", str(v)
        elif isinstance(v, str):
            t, raw = "s", _escape(v)
        else:
            raise TypeError("unsupported value type")
        lines.append("%s\t%s\t%s\n" % (_escape(key), t, raw))
    return "".join(lines).encode("utf-8")


def ser_decode(data: bytes) -> dict:
    out = {}
    for line in data.decode("utf-8").split("\n"):
        if not line:
            continue
        key_raw, t, raw = line.split("\t", 2)
        key = _unescape(key_raw)
        if t == "s":
            out[key] = _unescape(raw)
        elif t == "i":
            out[key] = int(raw)
        elif t == "b":
            out[key] = raw == "true"
        else:
            raise ValueError("bad type tag")
    return out


# ---------- death-window helper ----------
# @harness-begin readiness marker + kill wait (instrumentation only)
def window(run_dir, name):
    (Path(run_dir) / f"READY-{name}").write_text("ready\n")
    time.sleep(30)
# @harness-end
