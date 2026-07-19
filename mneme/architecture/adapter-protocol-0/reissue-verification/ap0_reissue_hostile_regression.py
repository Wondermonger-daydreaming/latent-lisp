#!/usr/bin/env python3
"""Chair rerun: the ORIGINAL filed hostile attacks vs the REISSUED validator.
Records are taken verbatim from the filed attack harness / probe fixtures."""
import importlib.util, tempfile
from pathlib import Path

REISSUE = Path("/home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/architecture/"
               "adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue")
sp = importlib.util.spec_from_file_location("apv2", REISSUE/"tools"/"validate_ap0_vectors.py")
v = importlib.util.module_from_spec(sp); sp.loader.exec_module(v)
contract = v.Contract(REISSUE)

# load the ORIGINAL filed BREAKPOINT harness as a module namespace to steal CASES verbatim
old_src = Path("/home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/architecture/"
               "adapter-protocol-0/hostile-pass/attacks-breakpoint/attack_breakpoint.py").read_text()
ns = {}
# execute only up to the CASES definition end: exec whole file but neutralize __main__ run
old_src = old_src.replace('if __name__ == "__main__"', 'if False')
old_src = old_src.replace("if __name__ == '__main__'", 'if False')
exec(compile(old_src, "attack_breakpoint.py", "exec"), ns)
CASES = ns["CASES"]

def run_text(text):
    with tempfile.NamedTemporaryFile("w", suffix=".pjs", delete=False, encoding="utf-8") as f:
        f.write(text); p = Path(f.name)
    try:
        d = v.load(p)
        out = v.check_case(d, contract)
        cid, exp, actual, errors = out
        return actual, errors
    except Exception as e:
        return "parse-error", [repr(e)[:90]]
    finally:
        p.unlink()

print("== BREAKPOINT filed attacks vs REISSUED validator ==")
for label, text in CASES.items():
    actual, errors = run_text(text)
    tag = "STILL-ACCEPTED  <== UNREPAIRED" if actual == "accept" else actual.upper()
    print(f"[{tag}] {label.split(chr(10))[0][:70]}  errors={errors}")

print()
print("== UNDERTOW filed probe fixtures vs REISSUED validator ==")
UD = Path("/home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/architecture/"
          "adapter-protocol-0/hostile-pass/attacks-undertow")
for p in sorted(UD.glob("*.pjs")):
    d = v.load(p)
    try:
        cid, exp, actual, errors = v.check_case(d, contract)
    except Exception as e:
        actual, errors = "error", [repr(e)[:90]]
    tag = "STILL-ACCEPTED  <== UNREPAIRED" if actual == "accept" else actual.upper()
    print(f"[{tag}] {p.name}  errors={errors}")

print()
print("== BAD-CAN-01-RELABELLED (filed companion) vs REISSUED validator ==")
BADCAN = ns["BADCAN_RELABEL"]
actual, errors = run_text(BADCAN)
tag = "STILL-ACCEPTED  <== UNREPAIRED" if actual == "accept" else actual.upper()
print(f"[{tag}] BAD-CAN-01-RELABELLED  errors={errors}")
