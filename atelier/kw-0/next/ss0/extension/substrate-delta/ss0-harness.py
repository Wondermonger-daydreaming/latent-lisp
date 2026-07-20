#!/usr/bin/env python3
"""ss0-harness.py — SS-0 death harness (seat-agnostic).

The harness is the adversary with ground truth: it knows the injected
kill point; the seat's cold recovery program does not. READY markers are
control instrumentation, not record content. Every death is a real
SIGKILL; surviving bytes are snapshotted and hashed after every death.

Usage:
  SS0_ENTRY="<command prefix for the seat's runner>" python3 ss0-harness.py [scenario ...]

The runner is invoked as: <SS0_ENTRY> <run-dir>/ <scenario> <killpoint-or-empty>.
Scenario semantics: SCENARIOS.md (frozen with the substrate).
"""
import hashlib
import json
import os
import shlex
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
EVIDENCE = Path(os.environ.get("SS0_EVIDENCE", HERE / "evidence"))

SCENARIOS = [
    ("S1-clean", "effect", None),
    ("S2-pre-record", "effect", "pre-record"),
    ("S3-mid-record", "effect", "mid-record"),
    ("S4-post-dispatch", "effect", "post-dispatch"),
    ("S5-unfsynced-outcome", "effect", "unfsynced-outcome"),
    ("S6-mid-stream", "stream", "mid-stream"),
    ("S7-refused-unrecorded", "refused", "refused-unrecorded"),
    ("E1-clean", "batch", None),
    ("E2-mid-batch", "batch", "mid-batch"),
    ("E3-leg-refused", "batch-ne", "leg-refused"),
]


def sha256_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def run_one(entry, name, scenario, killpoint):
    run_dir = EVIDENCE / name
    if run_dir.exists():
        shutil.rmtree(run_dir)
    run_dir.mkdir(parents=True)
    record = {"scenario": scenario, "killpoint": killpoint}
    cmd = entry + [str(run_dir) + "/", scenario, killpoint or ""]
    t0 = time.time()
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True)
    if killpoint:
        marker = run_dir / f"READY-{killpoint}"
        deadline = t0 + 60
        while not marker.exists():
            if proc.poll() is not None:
                break
            if time.time() > deadline:
                proc.kill()
                raise RuntimeError(f"{name}: readiness marker never appeared")
            time.sleep(0.05)
        time.sleep(0.2)
        if proc.poll() is None:
            proc.send_signal(signal.SIGKILL)
        record["death"] = "SIGKILL delivered at READY window"
    out, _ = proc.communicate(timeout=90)
    (run_dir / "runner-stdout-stderr.txt").write_text(out)
    (run_dir / "exit-status.txt").write_text(str(proc.returncode) + "\n")
    record["exit"] = proc.returncode
    records = run_dir / "records.log"
    if records.exists():
        record["records-sha256"] = sha256_file(records)
        shutil.copy(records, run_dir / "corpse.snapshot")
    else:
        record["records-sha256"] = None
    provider = run_dir / "provider.log"
    record["provider-log"] = (provider.read_text().strip().splitlines()
                              if provider.exists() else [])
    (run_dir / "death-record.json").write_text(json.dumps(record, indent=2) + "\n")
    print(f"  [{name}] {record.get('death', 'no kill')} exit={record['exit']} "
          f"records={str(record['records-sha256'])[:16]}")
    for line in record["provider-log"]:
        print(f"    provider: {line}")
    return record


def main():
    entry_env = os.environ.get("SS0_ENTRY")
    if not entry_env:
        sys.exit("set SS0_ENTRY to the seat runner command prefix")
    entry = shlex.split(entry_env)
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    wanted = sys.argv[1:] or [s[0] for s in SCENARIOS]
    records = {}
    for name, scenario, killpoint in SCENARIOS:
        if name not in wanted:
            continue
        print(f"=== {name}: scenario={scenario} killpoint={killpoint} ===")
        records[name] = run_one(entry, name, scenario, killpoint)
    (EVIDENCE / "deaths.json").write_text(json.dumps(records, indent=2) + "\n")
    print(f"\nevidence in {EVIDENCE}")


if __name__ == "__main__":
    main()
