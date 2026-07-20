#!/usr/bin/env python3
# ss0_runner.py — SS-0 durable-record semantic layer primary implementation.
import sys
import time
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / "substrate"))
import ss0_substrate as sub
import ss0_provider as prov

PLAN = {
    "S1-clean": ("bank-write", "complete", "amount=100", "effect:bank-write"),
    "S2-pre-record": ("mint", "empty", "", "effect:mint"),
    "S3-mid-record": ("notify", "invalid", "\x00NOT-VALID\x00", "effect:notify"),
    "S4-post-dispatch": ("notify", "invalid", "\x00NOT-VALID\x00", "effect:notify"),
    "S5-unfsynced-outcome": ("mint", "empty", "", "effect:mint"),
    "S6-mid-stream": ("stream", "none", "", "slow:3"),
    "S7-refused-unrecorded": ("bank-write", "complete", "msg=alert", "effect-ne:bank-write"),
}

# EXTENSION-DELTA-BEGIN (R8 batch effect)
BATCH_PLAN = {
    "E1-clean": ("batch-write", "batch", 3),
    "E2-mid-batch": ("batch-write", "batch", 3),
    "E3-leg-refused": ("batch-write", "batch-ne", 3),
}
# EXTENSION-DELTA-END

def rec(run_dir, m, durable=True):
    sub.store_append(run_dir, sub.ser_encode(m), durable=durable)

def read_records(run_dir):
    payloads, status = sub.store_read_prefix(run_dir)
    return [sub.ser_decode(p) for p in payloads], status

def payload_crc(s):
    return sub.crc32_hex((s or "").encode("utf-8"))

def chunks_str(d):
    return ",".join(str(i) for i in d["chunks"]) if d["chunks"] else "-"

# EXTENSION-DELTA-BEGIN (R8 batch effect)
def parse_int_list(s):
    if not s or s == "-":
        return []
    return [int(x) for x in str(s).split(",") if x.isdigit()]
# EXTENSION-DELTA-END

def recover_state(run_dir):
    records, tail = read_records(run_dir)
    ops = {}
    for r in records:
        op = r.get("op")
        if not op:
            continue
        # EXTENSION-DELTA-BEGIN (batch fields added to op state)
        d = ops.setdefault(op, {"op": op, "state": "unknown", "derived": "true",
                                "label": "-", "regime": "-", "payload_crc": "-",
                                "outcome": "-", "outcome_durable": "-",
                                "outcome_payload_crc": "-",
                                "evidence": "-", "successor": "-", "chunks": [],
                                "lineage": "-", "tag": "-", "payload": "",
                                "attempt": "-",
                                "is_batch": False, "legs": 0,
                                "legs_census": "-", "reattempt": "-",
                                "abandon": "-", "batch": "-", "leg": "-"})
        # EXTENSION-DELTA-END
        t = r.get("t")
        if t == "intent":
            d.update(state="attempted", label=r.get("label", "-"),
                     regime=r.get("regime", "-"), payload=r.get("payload", ""),
                     payload_crc=payload_crc(r.get("payload", "")),
                     attempt=r.get("attempt", "-"),
                     lineage=r.get("lineage", "-"), derived="false")
            # EXTENSION-DELTA-BEGIN (leg linkage)
            if "batch" in r:
                d["batch"] = r.get("batch", "-")
            if "leg" in r:
                d["leg"] = r.get("leg", "-")
            # EXTENSION-DELTA-END
        elif t == "dispatch":
            d.update(state="dispatched", tag=r.get("tag", "-"))
        elif t == "outcome":
            d.update(state="outcome-recorded", outcome=r.get("status", "-"),
                     outcome_durable="true" if r.get("durable") else "false",
                     derived="false")
            if "payload" in r:
                d["payload"] = r.get("payload", "")
                d["outcome_payload_crc"] = payload_crc(r.get("payload", ""))
        elif t == "receipt":
            d.update(state="receipt-resolved", outcome=r.get("outcome", "-"),
                     evidence=r.get("provenance", "-"), derived="false")
        elif t == "complete":
            d.update(state="completed", derived="false")
        elif t == "successor":
            d["successor"] = r.get("succ", "-")
            # EXTENSION-DELTA-BEGIN (batch successor per-leg lineage metadata)
            if "reattempt" in r:
                d["succ_reattempt"] = r.get("reattempt", "-")
            if "abandon" in r:
                d["succ_abandon"] = r.get("abandon", "-")
            # EXTENSION-DELTA-END
        elif t == "chunk":
            idx = r.get("idx")
            if isinstance(idx, int):
                d["chunks"].append(idx)
        # EXTENSION-DELTA-BEGIN (batch descriptor record)
        elif t == "batch":
            d.update(state="batch", is_batch=True, label=r.get("label", "-"),
                     legs=int(r.get("legs", 0)), attempt=r.get("attempt", "-"),
                     lineage=r.get("lineage", "-"),
                     reattempt=r.get("reattempt", "-"),
                     abandon=r.get("abandon", "-"), derived="false")
        # EXTENSION-DELTA-END
    for d in ops.values():
        if d["chunks"]:
            d["chunks"] = sorted(set(d["chunks"]))
        if d["state"] == "dispatched":
            d.update(state="unresolved", derived="true")
        if d["state"] == "unknown":
            d["derived"] = "true"
    # EXTENSION-DELTA-BEGIN (batch per-leg placeholders and census)
    batch_ops = [(op, d) for op, d in ops.items() if d.get("is_batch")]
    for bop, bd in batch_ops:
        legs = int(bd.get("legs", 0))
        abandon = parse_int_list(bd.get("abandon", "-"))
        for i in range(1, legs + 1):
            lop = "%s-L%d" % (bop, i)
            if lop not in ops:
                if i in abandon:
                    state = "abandoned"
                    derived = "false"
                else:
                    state = "not-started"
                    derived = "true"
                ops[lop] = {"op": lop, "state": state, "derived": derived,
                            "label": "%s-L%d" % (bd.get("label", "-"), i),
                            "regime": "-", "payload_crc": "-",
                            "outcome": "-", "outcome_durable": "-",
                            "outcome_payload_crc": "-",
                            "evidence": "-", "successor": "-", "chunks": [],
                            "lineage": "-", "tag": "-", "payload": "",
                            "attempt": "-", "is_batch": False, "legs": 0,
                            "legs_census": "-", "reattempt": "-",
                            "abandon": "-", "batch": bop, "leg": i}
    for bop, bd in batch_ops:
        legs = int(bd.get("legs", 0))
        parts = []
        for i in range(1, legs + 1):
            lop = "%s-L%d" % (bop, i)
            st = ops.get(lop, {}).get("state", "missing")
            parts.append("%d:%s" % (i, st))
        bd["legs_census"] = ",".join(parts) if parts else "-"
    # EXTENSION-DELTA-END
    return ops, tail, records

def digest_state(ops):
    lines = []
    for op in sorted(ops):
        d = ops[op]
        # EXTENSION-DELTA-BEGIN (digest field 14: legs census)
        lines.append("|".join([op, d["label"], d["state"], d["regime"],
                               d["payload_crc"], d["outcome"],
                               d["outcome_durable"], d["outcome_payload_crc"],
                               d["evidence"], d["successor"], chunks_str(d),
                               d["lineage"], d["derived"],
                               d.get("legs_census", "-")]))
        # EXTENSION-DELTA-END
    return sub.crc32_hex("\n".join(lines).encode("utf-8"))

def mode_recover(run_dir):
    ops, tail, records = recover_state(run_dir)
    print("RECOVERY REPORT")
    print("tail: %s" % tail)
    print("records: %d" % len(records))
    for op in sorted(ops):
        d = ops[op]
        # EXTENSION-DELTA-BEGIN (report legs census)
        print("op=%s label=%s state=%s regime=%s payload_crc=%s outcome=%s "
              "outcome_durable=%s outcome_payload_crc=%s evidence=%s "
              "successor=%s chunks=%s lineage=%s derived=%s tag=%s legs=%s" % (
                  op, d["label"], d["state"], d["regime"], d["payload_crc"],
                  d["outcome"], d["outcome_durable"],
                  d["outcome_payload_crc"], d["evidence"], d["successor"],
                  chunks_str(d), d["lineage"], d["derived"], d["tag"],
                  d.get("legs_census", "-")))
        # EXTENSION-DELTA-END
    print("digest: %s" % digest_state(ops))

def mode_redispatch(run_dir, op_id):
    ops, _, _ = recover_state(run_dir)
    d = ops.get(op_id)
    if not d:
        print("REFUSED: op %s not found; no record evidence authorizes dispatch" % op_id)
        return
    # EXTENSION-DELTA-BEGIN (batch-level re-dispatch refusal per leg)
    if d.get("is_batch"):
        legs = int(d.get("legs", 0))
        for i in range(1, legs + 1):
            lop = "%s-L%d" % (op_id, i)
            ld = ops.get(lop, {})
            st = ld.get("state", "not-started")
            if st in ("unresolved", "dispatched"):
                print("REFUSED: batch %s leg %d unresolved; evidence: leg dispatch record without durable outcome or receipt (%s)" % (op_id, i, lop))
                return
            if st == "completed":
                print("REFUSED: batch %s leg %d completed; evidence: completion record (%s)" % (op_id, i, lop))
                return
            if st in ("outcome-recorded", "receipt-resolved") and ld.get("outcome") == "executed":
                print("REFUSED: batch %s leg %d executed; evidence: %s (%s)" % (op_id, i, st, lop))
                return
        print("ALLOWED: batch %s no executed or unresolved legs of record" % op_id)
        return
    # EXTENSION-DELTA-END
    if d["state"] == "unresolved":
        print("REFUSED: op %s dispatched (tag=%s) but outcome unrecorded; evidence: dispatch record without durable outcome or receipt" % (op_id, d["tag"]))
        return
    if d["state"] == "outcome-recorded" and d["outcome"] == "executed":
        print("REFUSED: op %s outcome record status=executed (durable=%s); re-dispatch impossible" % (op_id, d["outcome_durable"]))
        return
    if d["state"] == "receipt-resolved" and d["outcome"] == "executed":
        print("REFUSED: op %s receipt evidence %s outcome=executed; re-dispatch impossible" % (op_id, d["evidence"]))
        return
    if d["state"] == "completed":
        print("REFUSED: op %s completed; re-dispatch impossible" % op_id)
        return
    print("ALLOWED: op %s state=%s outcome=%s; no executed outcome of record" % (op_id, d["state"], d["outcome"]))

def mode_admit_receipt(run_dir, op_id):
    ops, _, _ = recover_state(run_dir)
    d = ops.get(op_id)
    if not d:
        print("ERROR: op %s not found" % op_id)
        return
    # EXTENSION-DELTA-BEGIN (batch admit-receipt admits per-leg receipts individually)
    if d.get("is_batch"):
        admitted = []
        legs = int(d.get("legs", 0))
        for i in range(1, legs + 1):
            lop = "%s-L%d" % (op_id, i)
            ld = ops.get(lop)
            if not ld:
                continue
            if ld.get("state") not in ("unresolved", "dispatched", "unknown"):
                continue
            attempt = ld.get("attempt", "-")
            if attempt == "-":
                continue
            p = Path(run_dir) / ("receipt-%s.txt" % attempt)
            if not p.exists():
                continue
            outcome = "executed" if "outcome: executed" in p.read_text() else "not-executed"
            rec(run_dir, {"t": "receipt", "op": lop, "attempt": attempt,
                          "outcome": outcome, "provenance": "receipt-%s.txt" % attempt})
            admitted.append(lop)
        if admitted:
            print("ADMITTED: %s" % ",".join(admitted))
        else:
            print("ERROR: no admissible per-leg receipts for batch %s" % op_id)
        return
    # EXTENSION-DELTA-END
    attempt = d.get("attempt", "-")
    if attempt == "-":
        print("ERROR: op %s has no attempt identifier" % op_id)
        return
    p = Path(run_dir) / ("receipt-%s.txt" % attempt)
    if not p.exists():
        print("ERROR: receipt file %s not found" % p)
        return
    outcome = "executed" if "outcome: executed" in p.read_text() else "not-executed"
    rec(run_dir, {"t": "receipt", "op": op_id, "attempt": attempt,
                  "outcome": outcome, "provenance": "receipt-%s.txt" % attempt})
    print("ADMITTED: receipt for op %s attempt %s outcome=%s" % (op_id, attempt, outcome))

def mode_succeed(run_dir, pred_op):
    ops, _, _ = recover_state(run_dir)
    pred = ops.get(pred_op)
    if not pred:
        print("ERROR: predecessor %s not found" % pred_op)
        return
    # EXTENSION-DELTA-BEGIN (batch successor with per-leg lineage)
    if pred.get("is_batch"):
        legs = int(pred.get("legs", 0))
        abandon = []
        reattempt = []
        for i in range(1, legs + 1):
            lop = "%s-L%d" % (pred_op, i)
            ld = ops.get(lop, {})
            st = ld.get("state", "not-started")
            if st == "completed":
                abandon.append(i)
            elif st in ("outcome-recorded", "receipt-resolved") and ld.get("outcome") == "executed":
                abandon.append(i)
            else:
                reattempt.append(i)
        re_str = ",".join(str(i) for i in reattempt) if reattempt else "-"
        ab_str = ",".join(str(i) for i in abandon) if abandon else "-"
        succ_op = "succ-%d" % int(time.time() * 1000)
        rec(run_dir, {"t": "successor", "op": pred_op, "pred": pred_op,
                      "succ": succ_op, "reason": "explicit-distinct-batch-successor",
                      "reattempt": re_str, "abandon": ab_str})
        label = pred.get("label", "batch")
        prov.provider_dispatch(run_dir, "batch:%s:%d" % (label, legs), succ_op)
        rec(run_dir, {"t": "batch", "op": succ_op, "label": label, "legs": legs,
                      "attempt": succ_op,
                      "lineage": "batch-successor:re=%s:ab=%s" % (re_str, ab_str),
                      "pred": pred_op, "reattempt": re_str, "abandon": ab_str})
        for i in reattempt:
            pred_leg_op = "%s-L%d" % (pred_op, i)
            pred_leg = ops.get(pred_leg_op, {})
            tag = pred_leg.get("tag", "-")
            if tag == "-":
                tag = "effect:%s-L%d" % (label, i)
            leg_op = "%s-L%d" % (succ_op, i)
            leg_att = leg_op
            rec(run_dir, {"t": "intent", "op": leg_op,
                          "label": "%s-L%d" % (label, i), "regime": "none",
                          "payload": "", "attempt": leg_att, "batch": succ_op,
                          "leg": i, "lineage": "successor:%s" % pred_leg_op,
                          "pred": pred_leg_op})
            rec(run_dir, {"t": "dispatch", "op": leg_op, "attempt": leg_att,
                          "tag": tag})
            res = prov.provider_dispatch(run_dir, tag, leg_att)
            status = res.get("status", "unknown-tag")
            m = {"t": "outcome", "op": leg_op, "attempt": leg_att,
                 "status": status, "durable": True}
            if "payload" in res:
                m["payload"] = res.get("payload", "")
            rec(run_dir, m)
            rec(run_dir, {"t": "complete", "op": leg_op, "attempt": leg_att})
        print("SUCCESSOR: batch %s proceeded for predecessor %s reattempt=%s abandon=%s" % (succ_op, pred_op, re_str, ab_str))
        return
    # EXTENSION-DELTA-END
    succ_op = "succ-%d" % int(time.time() * 1000)
    label = pred.get("label", "unknown")
    regime = pred.get("regime", "none")
    payload = pred.get("payload", "")
    tag = pred.get("tag", "-")
    if tag == "-":
        tag = "effect:%s" % label
    rec(run_dir, {"t": "successor", "op": pred_op, "pred": pred_op,
                  "succ": succ_op, "reason": "explicit-distinct-successor"})
    rec(run_dir, {"t": "intent", "op": succ_op, "label": label, "regime": regime,
                  "payload": payload, "attempt": succ_op, "lineage": "successor",
                  "pred": pred_op})
    rec(run_dir, {"t": "dispatch", "op": succ_op, "attempt": succ_op, "tag": tag})
    res = prov.provider_dispatch(run_dir, tag, succ_op)
    status = res.get("status", "unknown-tag")
    if status == "stream":
        fn = res.get("chunk_fn")
        for i in range(1, int(res.get("chunks", 0)) + 1):
            rec(run_dir, {"t": "chunk", "op": succ_op, "attempt": succ_op,
                          "idx": i, "data": fn(i), "durable": True})
        rec(run_dir, {"t": "outcome", "op": succ_op, "attempt": succ_op,
                      "status": "stream", "durable": True})
    else:
        m = {"t": "outcome", "op": succ_op, "attempt": succ_op,
             "status": status, "durable": True}
        if "payload" in res:
            m["payload"] = res.get("payload", "")
        rec(run_dir, m)
    rec(run_dir, {"t": "complete", "op": succ_op, "attempt": succ_op})
    print("SUCCESSOR: %s proceeded for predecessor %s tag=%s status=%s" % (succ_op, pred_op, tag, status))

def run_scenario(run_dir, scenario, killpoint):
    label, regime, payload, tag = PLAN[scenario]
    op = "op-%s" % scenario
    att = "att-%s" % scenario
    intent = {"t": "intent", "op": op, "label": label, "regime": regime,
              "payload": payload, "attempt": att}
    if scenario == "S1-clean":
        rec(run_dir, intent)
        rec(run_dir, {"t": "dispatch", "op": op, "attempt": att, "tag": tag})
        res = prov.provider_dispatch(run_dir, tag, att)
        rec(run_dir, {"t": "outcome", "op": op, "attempt": att,
                      "status": res.get("status", "unknown-tag"), "durable": True})
        rec(run_dir, {"t": "complete", "op": op, "attempt": att})
    elif scenario == "S2-pre-record":
        rec(run_dir, {"t": "setup", "scenario": scenario, "note": "process-start"})
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "S3-mid-record":
        sub.store_append_torn(run_dir, sub.ser_encode(intent), 0.5)  # @harness
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "S4-post-dispatch":
        rec(run_dir, intent)
        rec(run_dir, {"t": "dispatch", "op": op, "attempt": att, "tag": tag})
        prov.provider_dispatch(run_dir, tag, att)
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "S5-unfsynced-outcome":
        rec(run_dir, intent)
        rec(run_dir, {"t": "dispatch", "op": op, "attempt": att, "tag": tag})
        prov.provider_dispatch(run_dir, tag, att)
        rec(run_dir, {"t": "outcome", "op": op, "attempt": att,
                      "status": "executed", "durable": False})
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "S6-mid-stream":
        rec(run_dir, intent)
        rec(run_dir, {"t": "dispatch", "op": op, "attempt": att, "tag": tag})
        res = prov.provider_dispatch(run_dir, tag, att)
        fn = res["chunk_fn"]
        rec(run_dir, {"t": "chunk", "op": op, "attempt": att, "idx": 1,
                      "data": fn(1), "durable": True})
        chunk2 = {"t": "chunk", "op": op, "attempt": att, "idx": 2,
                  "data": fn(2), "durable": True}
        sub.store_append_torn(run_dir, sub.ser_encode(chunk2), 0.5)  # @harness
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "S7-refused-unrecorded":
        rec(run_dir, intent)
        rec(run_dir, {"t": "dispatch", "op": op, "attempt": att, "tag": tag})
        prov.provider_dispatch(run_dir, tag, att)
        sub.window(run_dir, killpoint)  # @harness

# EXTENSION-DELTA-BEGIN (R8 batch scenarios)
def leg_tag(label, kind, idx):
    if kind == "batch-ne" and idx == 2:
        return "effect-ne:%s-L%d" % (label, idx)
    return "effect:%s-L%d" % (label, idx)

def settle_leg(run_dir, batch_op, batch_att, label, kind, idx):
    leg_op = "%s-L%d" % (batch_op, idx)
    leg_att = "%s-L%d" % (batch_att, idx)
    tag = leg_tag(label, kind, idx)
    rec(run_dir, {"t": "intent", "op": leg_op,
                  "label": "%s-L%d" % (label, idx), "regime": "none",
                  "payload": "", "attempt": leg_att, "batch": batch_op,
                  "leg": idx})
    rec(run_dir, {"t": "dispatch", "op": leg_op, "attempt": leg_att, "tag": tag})
    res = prov.provider_dispatch(run_dir, tag, leg_att)
    m = {"t": "outcome", "op": leg_op, "attempt": leg_att,
         "status": res.get("status", "unknown-tag"), "durable": True}
    if "payload" in res:
        m["payload"] = res.get("payload", "")
    rec(run_dir, m)
    rec(run_dir, {"t": "complete", "op": leg_op, "attempt": leg_att})

def dispatch_leg_no_outcome(run_dir, batch_op, batch_att, label, kind, idx):
    leg_op = "%s-L%d" % (batch_op, idx)
    leg_att = "%s-L%d" % (batch_att, idx)
    tag = leg_tag(label, kind, idx)
    rec(run_dir, {"t": "intent", "op": leg_op,
                  "label": "%s-L%d" % (label, idx), "regime": "none",
                  "payload": "", "attempt": leg_att, "batch": batch_op,
                  "leg": idx})
    rec(run_dir, {"t": "dispatch", "op": leg_op, "attempt": leg_att, "tag": tag})
    prov.provider_dispatch(run_dir, tag, leg_att)

def run_batch_scenario(run_dir, scenario, killpoint):
    label, kind, legs = BATCH_PLAN[scenario]
    op = "op-%s" % scenario
    att = "att-%s" % scenario
    res = prov.provider_dispatch(run_dir, "batch:%s:%d" % (label, legs), att)
    rec(run_dir, {"t": "batch", "op": op, "label": label,
                  "legs": int(res.get("legs", legs)), "attempt": att})
    if scenario == "E1-clean":
        for i in range(1, legs + 1):
            settle_leg(run_dir, op, att, label, kind, i)
    elif scenario == "E2-mid-batch":
        settle_leg(run_dir, op, att, label, kind, 1)
        dispatch_leg_no_outcome(run_dir, op, att, label, kind, 2)
        sub.window(run_dir, killpoint)  # @harness
    elif scenario == "E3-leg-refused":
        settle_leg(run_dir, op, att, label, kind, 1)
        dispatch_leg_no_outcome(run_dir, op, att, label, kind, 2)
        sub.window(run_dir, killpoint)  # @harness
# EXTENSION-DELTA-END

def main():
    if len(sys.argv) < 3:
        print("usage: ss0_runner.py <run-dir> <scenario|mode> [killpoint|op-id]")
        sys.exit(1)
    run_dir = sys.argv[1]
    cmd = sys.argv[2]
    arg = sys.argv[3] if len(sys.argv) > 3 else ""
    if cmd.startswith("S"):
        run_scenario(run_dir, cmd, arg)
    # EXTENSION-DELTA-BEGIN (R8 batch scenario routing)
    elif cmd.startswith("E"):
        run_batch_scenario(run_dir, cmd, arg)
    # EXTENSION-DELTA-END
    elif cmd == "recover":
        mode_recover(run_dir)
    elif cmd == "redispatch":
        mode_redispatch(run_dir, arg)
    elif cmd == "admit-receipt":
        mode_admit_receipt(run_dir, arg)
    elif cmd == "succeed":
        mode_succeed(run_dir, arg)
    else:
        print("unknown command: %s" % cmd)
        sys.exit(1)

if __name__ == "__main__":
    main()
