#!/usr/bin/env python3
"""BREAKPOINT attack harness against the AP0 packet validator.

Imports the packet's OWN independent validator (validate_ap0_vectors.check_case)
WITHOUT MODIFYING THE PACKET, feeds it hand-crafted counterexample records that
are conforming-per-the-spec-text yet violate governing architecture laws
(L15 witness separation, Kernel §8.2 closed status algebra), and prints the
validator's verdict. A verdict of 'accept' on a record the spec's prose forbids
demonstrates a hole the fixtures walk around.

Records are written in the same flat-`rec` PJ-S/0 surface the packet uses, so
the validator parses them with its own scanner. Nothing here touches the packet
directory; we only import its module by absolute path.
"""
import importlib.util, sys, tempfile
from pathlib import Path

PACKET = Path("/home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/architecture/"
              "adapter-protocol-0/lisp-plus-adapter-protocol-0")
VAL = PACKET / "tools" / "validate_ap0_vectors.py"

spec = importlib.util.spec_from_file_location("ap0v", VAL)
v = importlib.util.module_from_spec(spec)
spec.loader.exec_module(v)

def run_record(sexp_text):
    """Parse a flat rec via the packet scanner and run its check_case."""
    with tempfile.NamedTemporaryFile("w", suffix=".pjs", delete=False, encoding="utf-8") as f:
        f.write(sexp_text)
        p = Path(f.name)
    d = v.load(p)
    cid, exp, actual, errors = v.check_case(d)
    p.unlink()
    return cid, actual, errors

CASES = {
"A1  reconciliation: self-declared complete domain launders no-effect (L15)":
 '(rec ((id "ap0" "case-id") "ATK-REC-LAUNDER") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "reconciliation") ((id "ap0" "result") "not-found") '
 '((id "ap0" "domain-complete") #t) ((id "ap0" "settles-no-effect") #t) '
 '((id "ap0" "provider-request-id") #u) ((id "ap0" "provider-request-timing") "unavailable") '
 '((id "ap0" "witness-boundary") #u) ((id "ap0" "bypass-route-steps") #u) '
 '((id "ap0" "lawful-route-steps") 4))',

"A2  request-identity: provider id invented from a COUNTER at 'acknowledgment' timing (AP-ID-3 blocklist gap)":
 '(rec ((id "ap0" "case-id") "ATK-RID-COUNTER") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "request-identity") ((id "ap0" "local-request-id") "lr-001") '
 '((id "ap0" "provider-request-id") "adapter-counter-000042") '
 '((id "ap0" "provider-request-timing") "acknowledgment") '
 '((id "ap0" "bypass-route-steps") #u) ((id "ap0" "lawful-route-steps") 4))',

"A3  cancellation: a bare socket closure RELABELLED as provider-settled (AP-CAN-1 walk-around)":
 '(rec ((id "ap0" "case-id") "ATK-CAN-RELABEL") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "cancellation") ((id "ap0" "cancel-class") "provider-settled") '
 '((id "ap0" "billing") "unknown") ((id "ap0" "partial-preserved") #t) '
 '((id "ap0" "witness-boundary") #u) ((id "ap0" "bypass-route-steps") #u) '
 '((id "ap0" "lawful-route-steps") 4))',

"A4  stream: delivery-before-journal (journal-before-delivery #f) on an otherwise-clean stream (§10.5 undistinguished)":
 '(rec ((id "ap0" "case-id") "ATK-STR-DBJ") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "stream") ((id "ap0" "adapter-identity") "fake-reference-0") '
 '((id "ap0" "chunks") (seq 1 2 3)) ((id "ap0" "stream-relation") #t) '
 '((id "ap0" "terminal") #t) ((id "ap0" "journal-before-delivery") #f) '
 '((id "ap0" "bypass-route-steps") #u) ((id "ap0" "lawful-route-steps") 4))',

"A5  projection: missing subject field mapped to Kernel-illegal STATUS :absent-after-completion (Kernel §8.2 closed algebra)":
 '(rec ((id "ap0" "case-id") "ATK-ABS-STATE-AS-STATUS") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "projection") ((id "ap0" "envelope-captured") #t) '
 '((id "ap0" "shape") "missing-subject-field") '
 '((id "ap0" "manifestation-status") "absent-after-completion") '
 '((id "ap0" "bypass-route-steps") #u) ((id "ap0" "lawful-route-steps") 4))',
}

# Companion: prove BAD-CAN-01 flips reject->accept by only relabelling its class.
BADCAN_RELABEL = (
 '(rec ((id "ap0" "case-id") "BAD-CAN-01-RELABELLED") ((id "ap0" "expected-verdict") "accept") '
 '((id "ap0" "family") "cancellation") ((id "ap0" "cancel-class") "provider-settled") '
 '((id "ap0" "bypass-route-steps") #u) ((id "ap0" "lawful-route-steps") 4))')

if __name__ == "__main__":
    print("BREAKPOINT attack harness — verdicts from the PACKET's own check_case\n")
    for name, sexp in CASES.items():
        cid, actual, errors = run_record(sexp)
        flag = "  <== ACCEPTED (hole)" if actual == "accept" else ""
        print(f"[{actual.upper():6}] {cid:26} {name}{flag}")
        if errors:
            print(f"          validator errors: {errors}")
    print()
    cid, actual, errors = run_record(BADCAN_RELABEL)
    print(f"[{actual.upper():6}] {cid:26} companion: BAD-CAN-01 with class relabelled socket-closed->provider-settled{'  <== ACCEPTED' if actual=='accept' else ''}")
