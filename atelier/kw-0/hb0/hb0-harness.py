#!/usr/bin/env python3
"""harness.py — the Killed Witness death harness.

The harness is the adversary with ground truth: it knows the injected crash
point; the reconstructor (cold process) does not. The READY-marker channel is
control instrumentation, not journal content.

Every death is a real SIGKILL to a real process. Raw journal bytes are
snapshotted and hashed after every death. No repair is performed around
failures: assertions are reported as they fall.

Usage: python3 harness.py [scenario ...]   (default: all)
"""
import hashlib
import json
import os
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path

SBCL = "/tmp/sbcl-bin"
SBCL_HOME = "/tmp/sbcl-2.4.6-x86-64-linux/obj/sbcl-home"
KW = Path(__file__).resolve().parent
EVIDENCE = KW / "evidence"


def md5_file(path):
    h = hashlib.md5()
    h.update(Path(path).read_bytes())
    return h.hexdigest()


def hexdump_tail(path, n=64):
    data = Path(path).read_bytes()
    tail = data[-n:] if len(data) > n else data
    return f"{len(data)} bytes total; tail({len(tail)}): {tail.hex()}"


class Death:
    """One real process death, with its evidence packet."""

    def __init__(self, name, scenario, killpoint):
        self.name = name
        self.scenario = scenario
        self.killpoint = killpoint
        self.run_dir = EVIDENCE / name
        self.record = {"scenario": scenario, "killpoint": killpoint}

    def run(self):
        if self.run_dir.exists():
            shutil.rmtree(self.run_dir)
        self.run_dir.mkdir(parents=True)
        env = dict(os.environ, SBCL_HOME=SBCL_HOME)
        cmd = [SBCL, "--script", str(KW / "hb0-control.lisp"),
               str(self.run_dir) + "/", self.scenario, self.killpoint or ""]
        t0 = time.time()
        proc = subprocess.Popen(cmd, env=env,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                text=True)
        if self.killpoint:
            marker = self.run_dir / f"READY-{self.killpoint}"
            deadline = t0 + 60
            while not marker.exists():
                if proc.poll() is not None:
                    break
                if time.time() > deadline:
                    proc.kill()
                    raise RuntimeError(f"{self.name}: readiness marker never appeared")
                time.sleep(0.05)
            time.sleep(0.2)  # let the doomed process enter its sleep
            if proc.poll() is None:
                proc.send_signal(signal.SIGKILL)
            self.record["death"] = "SIGKILL delivered at READY window"
        out, _ = proc.communicate(timeout=90)
        (self.run_dir / "runner-stdout-stderr.txt").write_text(out)
        (self.run_dir / "exit-status.txt").write_text(str(proc.returncode) + "\n")
        self.record["exit"] = proc.returncode
        self.record["runner-output-tail"] = out.strip().splitlines()[-3:]
        journal = self.run_dir / "witness.journal"
        if journal.exists():
            self.record["journal-md5"] = md5_file(journal)
            self.record["journal-bytes"] = hexdump_tail(journal)
            # frozen snapshot of the raw bytes the cold process will see
            shutil.copy(journal, self.run_dir / "corpse.snapshot")
        else:
            self.record["journal-md5"] = None
            self.record["journal-bytes"] = "no journal file"
        provider = self.run_dir / "provider.log"
        self.record["provider-log"] = (provider.read_text().strip().splitlines()
                                       if provider.exists() else [])
        return self.record


def cl_script(name, args):
    env = dict(os.environ, SBCL_HOME=SBCL_HOME)
    proc = subprocess.run([SBCL, "--script", str(KW / name)] + args,
                          env=env, capture_output=True, text=True, timeout=300)
    return proc.returncode, proc.stdout + proc.stderr


def write_record(name, record):
    (EVIDENCE / name / "death-record.json").write_text(
        json.dumps(record, indent=2) + "\n")
    print(f"  [{name}] {record['death'] if 'death' in record else 'no kill'}"
          f" exit={record['exit']} journal={record.get('journal-md5')}")
    print(f"    bytes: {record['journal-bytes'][:110]}")
    for line in record.get("provider-log", []):
        print(f"    provider: {line}")


SCENARIOS = [
    ("S1-clean", "effect", None),
    ("S2-cw0", "effect", "cw0"),
    ("S3-cw1", "effect", "cw1"),
    ("S4-uncertain", "effect", "uncertain"),
    ("S5-cw2cw3", "effect", "cw2cw3"),
    ("S6-midstream", "stream", "midstream"),
    ("S7-nonexec", "nonexec", "nonexec"),
]


def main():
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    wanted = sys.argv[1:] or [s[0] for s in SCENARIOS]
    records = {}
    for name, scenario, killpoint in SCENARIOS:
        if name not in wanted:
            continue
        print(f"=== {name}: scenario={scenario} killpoint={killpoint} ===")
        d = Death(name, scenario, killpoint)
        records[name] = d.run()
        write_record(name, records[name])
    (EVIDENCE / "deaths.json").write_text(json.dumps(records, indent=2) + "\n")
    print(f"\nevidence in {EVIDENCE}")


if __name__ == "__main__":
    main()
