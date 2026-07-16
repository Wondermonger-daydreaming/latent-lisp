"""Run and record two fresh single-environment owner-adoption verification passes."""

from __future__ import annotations

import os
import platform
import subprocess
import sys
import sysconfig
from datetime import datetime
from importlib.metadata import version as package_version

from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, sha256_bytes, write_bytes


COMMAND_BYTES = b"bash experiments/language-a-exoskeleton/verify-pilot.sh\n"
OUTPUT = PACKET_ROOT / "evidence/odr-43-60-adoption/VERIFICATION-RUNS.json"


def now():
    return datetime.now().astimezone().isoformat(timespec="seconds")


def run(run_id):
    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    environment["LAE_NETWORK_MODE"] = "off"
    started = now()
    result = subprocess.run(
        ["bash", "experiments/language-a-exoskeleton/verify-pilot.sh"],
        cwd=REPO_ROOT, env=environment, capture_output=True,
    )
    ended = now()
    if result.returncode != 0:
        raise RuntimeError(result.stdout.decode("utf-8", "replace") + result.stderr.decode("utf-8", "replace"))
    if b"12/12 network-off checks green" not in result.stdout:
        raise RuntimeError("targeted verification did not report 12/12")
    return {
        "run_id": run_id, "fresh_clean_targeted_run": True,
        "started_at": started, "ended_at": ended, "exit_status": result.returncode,
        "stdout": {"byte_length": len(result.stdout), "sha256": sha256_bytes(result.stdout)},
        "stderr": {"byte_length": len(result.stderr), "sha256": sha256_bytes(result.stderr)},
        "verification_result": "12/12 network-off checks green",
    }


def main():
    record = {
        "schema_version": "lae-owner-adoption-verification-runs/1.0.0",
        "command": {"bytes_utf8": COMMAND_BYTES.decode("utf-8"), "byte_length": len(COMMAND_BYTES), "sha256": sha256_bytes(COMMAND_BYTES)},
        "environment": {
            "interpreter": {"executable": sys.executable, "implementation": platform.python_implementation(), "version": platform.python_version()},
            "jsonschema_version": package_version("jsonschema"),
            "platform": {"system": platform.system(), "release": platform.release(), "machine": platform.machine(), "platform": platform.platform(), "sysconfig_platform": sysconfig.get_platform()},
            "single_environment_scope": True, "scope": "single-environment-only",
        },
        "single_environment_scope_explicit": True,
        "runs": [run("odr-43-60-adoption-fresh-targeted-001"), run("odr-43-60-adoption-fresh-targeted-002")],
    }
    write_bytes(OUTPUT, canonical_json_bytes(record))


if __name__ == "__main__":
    main()
