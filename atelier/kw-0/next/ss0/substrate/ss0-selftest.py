#!/usr/bin/env python3
"""ss0-selftest.py — SS-0 substrate cross-language selftest.

Proves before freeze: (1) canonical serialization byte-identical CL<->Py,
round-trips both directions; (2) framed storage written by either side
reads identically from the other, torn tails discarded with status torn;
(3) provider fixture produces byte-identical world artifacts from both
languages; (4) CRC32 agreement. Any failure exits 1.

Usage: SBCL=/path/to/sbcl SBCL_HOME=... python3 ss0-selftest.py
"""
import filecmp
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import ss0_substrate as sub  # noqa: E402
import ss0_provider as prov  # noqa: E402

SBCL = os.environ.get("SBCL", "sbcl")
FIXED = {"name": "SS-0", "n": 42, "ok": True, "empty": "",
         "note": "tab\there\nline", "weird\\key": "v"}
FAILURES = []


def check(name, ok, detail=""):
    print(f"  {'PASS' if ok else 'FAIL'}: {name}" + (f" ({detail})" if detail else ""))
    if not ok:
        FAILURES.append(name)


def cl(*args):
    r = subprocess.run([SBCL, "--script", str(HERE / "test-cl.lisp"), *args],
                       capture_output=True, text=True, timeout=120)
    if r.returncode != 0:
        raise RuntimeError(f"CL driver failed: {r.stdout}{r.stderr}")
    return r.stdout


def main():
    tmp = Path(tempfile.mkdtemp(prefix="ss0-selftest-"))
    try:
        print("== 1. canonical serialization ==")
        cl_bytes_f = tmp / "cl.ser"
        cl("ser-encode", str(cl_bytes_f))
        py_bytes = sub.ser_encode(FIXED)
        check("CL and Py encode byte-identical", cl_bytes_f.read_bytes() == py_bytes)
        check("Py decodes CL bytes to fixed map", sub.ser_decode(cl_bytes_f.read_bytes()) == FIXED)
        rt = tmp / "cl-roundtrip.ser"
        py_f = tmp / "py.ser"
        py_f.write_bytes(py_bytes)
        cl("ser-roundtrip", str(py_f), str(rt))
        check("CL round-trips Py bytes byte-identical", rt.read_bytes() == py_bytes)

        print("== 2. framed storage, both directions ==")
        d1 = tmp / "cl-writes"; d1.mkdir()
        cl("frames-write", str(d1) + "/")
        payloads, status = sub.store_read_prefix(d1)
        check("Py reads CL frames", [p.decode() for p in payloads] == ["alpha", "beta"],
              f"got {payloads}, {status}")
        check("Py reports torn tail on CL torn frame", status == "torn")
        d2 = tmp / "py-writes"; d2.mkdir()
        sub.store_append(d2, b"alpha")
        sub.store_append(d2, b"beta", durable=False)
        sub.store_append_torn(d2, b"gamma-payload", 0.5)
        out = cl("frames-read", str(d2) + "/").strip()
        check("CL reads Py frames + torn status", out == "alpha,beta|torn", out)
        d3 = tmp / "clean"; d3.mkdir()
        sub.store_append(d3, b"only")
        _, st = sub.store_read_prefix(d3)
        check("clean tail reported clean", st == "clean")

        print("== 3. provider determinism across languages ==")
        da = tmp / "prov-cl"; da.mkdir()
        db = tmp / "prov-py"; db.mkdir()
        cl("provider", str(da) + "/")
        prov.provider_dispatch(db, "effect:mint", "a1")
        prov.provider_dispatch(db, "effect-ne:mint", "a2")
        prov.provider_dispatch(db, "complete:hello", "a3")
        for f in ["provider.log", "receipt-a1.txt", "receipt-a2.txt"]:
            check(f"provider artifact byte-identical: {f}",
                  filecmp.cmp(da / f, db / f, shallow=False))

        print("== 4. CRC32 agreement ==")
        check("crc32('hello') matches", cl("crc", "hello").strip() == sub.crc32_hex(b"hello"))

        print()
        if FAILURES:
            print(f"SELFTEST: FAIL ({len(FAILURES)}): {FAILURES}")
            sys.exit(1)
        print("SELFTEST: ALL PASS")
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
