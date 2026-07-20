#!/usr/bin/env python3
"""seat-b-adapter.py — CHAIR INSTRUMENTATION, not seat code.

SUBSTRATE-DOC-DEFECT-1 accommodation (SS0-FREEZE-LEDGER.md): the frozen
harness invokes <entry> <run-dir>/ <kind> <killpoint-or-empty>, while Seat B's
documented CLI (its frozen README.md) takes S-names. Each (kind, killpoint)
pair maps uniquely onto one S-name, so this adapter performs that mapping and
execs Seat B's frozen runner UNCHANGED. Kill mechanics remain the harness's
own (READY-marker + real SIGKILL), byte-identical across seats.

Chair: Claude Fable 5, 2026-07-20 bench.
"""
import os
import sys

MAP = {
    ("effect", ""): "S1-clean",
    ("effect", "pre-record"): "S2-pre-record",
    ("effect", "mid-record"): "S3-mid-record",
    ("effect", "post-dispatch"): "S4-post-dispatch",
    ("effect", "unfsynced-outcome"): "S5-unfsynced-outcome",
    ("stream", "mid-stream"): "S6-mid-stream",
    ("refused", "refused-unrecorded"): "S7-refused-unrecorded",
    ("batch", ""): "E1-clean",
    ("batch", "mid-batch"): "E2-mid-batch",
    ("batch-ne", "leg-refused"): "E3-leg-refused",
}

run_dir = sys.argv[1]
kind = sys.argv[2]
killpoint = sys.argv[3] if len(sys.argv) > 3 else ""
sname = MAP[(kind, killpoint)]
runner = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ss0_runner.py")
os.execvp(sys.executable, [sys.executable, runner, run_dir, sname, killpoint])
