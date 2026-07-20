#!/usr/bin/env python3
# ss0.py — SS-0 seat: application-facing semantic layer (primary implementation, Python 3).
# Runner for the frozen scenario corpus + cold-recovery program. Expects the packet's
# substrate/ directory beside this file. Record vocabulary & digest spec: see README.md.
# Death instrumentation (window calls, torn-write injection) is marked @harness per the
# AFEL marker rule; everything else is production code.
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "substrate"))
from ss0_substrate import (store_append, store_append_torn, store_read_prefix,  # noqa: E402
                           ser_encode, ser_decode, crc32_hex, window)  # noqa: E402
from ss0_provider import provider_dispatch  # noqa: E402

# ---------- record writing (vocabulary: op/succ/out/chunk/done/att) ----------

def rec(rd, m, durable=True):
    store_append(rd, ser_encode(m), durable)

def tagclass(tag):  # pure function of the tag string; recovery never branches on labels
    if tag.startswith("batch:"):
        return "batch"  # v1.1-ext
    if tag.startswith("slow:"):
        return "stream"
    if tag.startswith("effect:") or tag.startswith("effect-ne:"):
        return "effect"
    if tag.startswith("complete:") or tag in ("empty", "invalid"):
        return "payload"
    return "unknown"

def want_of(tag):
    return int(tag[5:]) if tagclass(tag) == "stream" and tag[5:].isdigit() else None

def classify(p):  # the seat's payload parser: printable text is valid
    if p == "":
        return "empty"
    return "invalid" if any(ord(c) < 32 and c not in "\t\n" or ord(c) == 127 for c in p) else "valid"

def declare(rd, opid, tag, sup=None):  # always durable, always BEFORE dispatch
    rec(rd, {"k": "succ", "op": opid, "sup": sup, "tag": tag} if sup else {"k": "op", "op": opid, "tag": tag})

def chunk_rec(rd, opid, i, data):
    rec(rd, {"k": "chunk", "op": opid, "i": i, "data": data})

def record_outcome(rd, opid, r, durable=True):
    st = r.get("status")
    if st == "payload":
        p = r["payload"]
        m = {"k": "out", "op": opid, "st": "payload", "pc": classify(p), "dur": durable}
        if m["pc"] == "invalid":
            m["pd"] = crc32_hex(p.encode("utf-8"))  # digest only: invalid bytes are not enshrined
        else:
            m["pl"] = p
        rec(rd, m, durable)
    elif st == "stream":
        for i in range(1, r["chunks"] + 1):
            chunk_rec(rd, opid, i, r["chunk_fn"](i))
    else:  # executed | not-executed | unknown-tag: no payload associated
        rec(rd, {"k": "out", "op": opid, "st": str(st), "pc": "absent", "dur": durable}, durable)

def operate(rd, opid, tag, durable=True):
    return record_outcome(rd, opid, provider_dispatch(rd, tag, opid), durable)

def finish(rd, opid):  # completion/confirmation record: outcome is final and durable
    rec(rd, {"k": "done", "op": opid})

def run_clean(rd, opid, tag):
    declare(rd, opid, tag)
    operate(rd, opid, tag)
    finish(rd, opid)

# ---------- scenario corpus (contract: SCENARIOS.md; killpoints per scenario) ----------

def sc_S1(rd, kp):
    run_clean(rd, "op-1", "effect:bank-write")

def sc_S2(rd, kp):
    window(rd, kp or "pre-record")  # @harness
    run_clean(rd, "op-1", "effect:bank-write")  # reached only if no kill arrives

def sc_S3(rd, kp):
    store_append_torn(rd, ser_encode({"k": "op", "op": "op-1", "tag": "effect:bank-write"}), 0.5)  # @harness
    window(rd, kp or "mid-record")  # @harness

def sc_S4(rd, kp):
    declare(rd, "op-1", "effect:mint")
    r = provider_dispatch(rd, "effect:mint", "op-1")
    window(rd, kp or "post-dispatch")  # @harness
    record_outcome(rd, "op-1", r)
    finish(rd, "op-1")

def sc_S5(rd, kp):
    declare(rd, "op-1", "effect:notify")
    r = provider_dispatch(rd, "effect:notify", "op-1")
    record_outcome(rd, "op-1", r, durable=False)
    window(rd, kp or "unfsynced-outcome")  # @harness
    finish(rd, "op-1")

def sc_S6(rd, kp):
    declare(rd, "op-1", "slow:3")
    r = provider_dispatch(rd, "slow:3", "op-1")
    chunk_rec(rd, "op-1", 1, r["chunk_fn"](1))
    store_append_torn(rd, ser_encode({"k": "chunk", "op": "op-1", "i": 2, "data": r["chunk_fn"](2)}), 0.5)  # @harness
    window(rd, kp or "mid-stream")  # @harness

def sc_S7(rd, kp):
    declare(rd, "op-1", "effect-ne:mint")
    r = provider_dispatch(rd, "effect-ne:mint", "op-1")
    window(rd, kp or "refused-unrecorded")  # @harness
    record_outcome(rd, "op-1", r)
    finish(rd, "op-1")

# ---------- v1.1-ext: batch operations (R8 extension; batch:<label>:<n>) ----------
# Schema addition: one new record kind `batch` (declaration metadata only: tag,
# legs, optional sup/aband lineage — NEVER a status), and two optional fields on
# leg declarations (`batch`, `leg`). Legs are ordinary ops with per-leg attempt
# identity "<batch-id>-leg-<i>"; all per-leg semantics reuse the frozen machinery.

def leg_id(bid, i):
    return "%s-leg-%d" % (bid, i)

def batch_decl(rd, bid, label, n, sup=None, aband=None):
    m = {"k": "batch", "op": bid, "tag": "batch:%s:%d" % (label, n), "legs": n}
    if sup:
        m["sup"] = sup
    if aband:
        m["aband"] = aband
    rec(rd, m)

def leg_decl(rd, bid, i, tag, sup=None):
    m = {"k": "succ" if sup else "op", "op": leg_id(bid, i), "tag": tag, "batch": bid, "leg": i}
    if sup:
        m["sup"] = sup
    rec(rd, m)

def batch_open(rd, bid, label, n):  # declare batch (durable), then fetch the descriptor
    batch_decl(rd, bid, label, n)
    return provider_dispatch(rd, "batch:%s:%d" % (label, n), bid)

def leg_run(rd, bid, i, tag):  # declare, dispatch, record, settle one leg end-to-end
    leg_decl(rd, bid, i, tag)
    operate(rd, leg_id(bid, i), tag)
    finish(rd, leg_id(bid, i))

def sc_E1(rd, kp):
    batch_open(rd, "b1", "settle", 3)
    for i in (1, 2, 3):
        leg_run(rd, "b1", i, "effect:settle")

def sc_E2(rd, kp):
    batch_open(rd, "b1", "settle", 3)
    leg_run(rd, "b1", 1, "effect:settle")
    leg_decl(rd, "b1", 2, "effect:settle")
    r = provider_dispatch(rd, "effect:settle", leg_id("b1", 2))
    window(rd, kp or "mid-batch")  # @harness
    record_outcome(rd, leg_id("b1", 2), r)
    finish(rd, leg_id("b1", 2))  # leg-3 is never dispatched, by contract

def sc_E3(rd, kp):
    batch_open(rd, "b1", "settle", 3)
    leg_run(rd, "b1", 1, "effect:settle")
    leg_decl(rd, "b1", 2, "effect-ne:settle")
    r = provider_dispatch(rd, "effect-ne:settle", leg_id("b1", 2))
    window(rd, kp or "leg-refused")  # @harness
    record_outcome(rd, leg_id("b1", 2), r)
    finish(rd, leg_id("b1", 2))  # leg-3 is never dispatched, by contract

SCEN = {"S1-clean": sc_S1, "S2-pre-record": sc_S2, "S3-mid-record": sc_S3,
        "S4-post-dispatch": sc_S4, "S5-unfsynced-outcome": sc_S5,
        "S6-mid-stream": sc_S6, "S7-refused-unrecorded": sc_S7,
        "P-complete": lambda rd, kp: run_clean(rd, "op-1", "complete:hello-world"),
        "P-empty": lambda rd, kp: run_clean(rd, "op-1", "empty"),
        "P-invalid": lambda rd, kp: run_clean(rd, "op-1", "invalid"),
        "P-stream": lambda rd, kp: run_clean(rd, "op-1", "slow:3"),
        "E1-clean": sc_E1, "E2-mid-batch": sc_E2, "E3-leg-refused": sc_E3}  # v1.1-ext

# the harness invokes <entry> <run-dir>/ <kind> <killpoint-or-empty>; map to scenarios
KIND = {("effect", ""): "S1-clean", ("effect", "pre-record"): "S2-pre-record",
        ("effect", "mid-record"): "S3-mid-record", ("effect", "post-dispatch"): "S4-post-dispatch",
        ("effect", "unfsynced-outcome"): "S5-unfsynced-outcome", ("stream", "mid-stream"): "S6-mid-stream",
        ("refused", "refused-unrecorded"): "S7-refused-unrecorded",
        ("batch", ""): "E1-clean", ("batch", "mid-batch"): "E2-mid-batch",
        ("batch-ne", "leg-refused"): "E3-leg-refused"}  # v1.1-ext

# ---------- cold recovery: read-only derivation (R1/R2/R6/R9) ----------

def load(rd):
    payloads, tail = store_read_prefix(rd)
    records, anomalies = [], []
    for i, p in enumerate(payloads):
        try:
            records.append((i, ser_decode(p)))
        except Exception:
            anomalies.append("record %d: undecodable payload" % i)
    return records, tail, anomalies, len(payloads)

def build(records, anomalies):
    ops, order = {}, []
    batches, border = {}, []  # v1.1-ext: batch declarations live outside the op model
    for i, m in records:
        k, opid = str(m.get("k", "")), str(m.get("op", ""))
        if k == "batch":  # v1.1-ext
            if not opid:
                anomalies.append("record %d: batch declaration without id" % i)
            elif opid in batches:
                anomalies.append("record %d: duplicate batch declaration of '%s'" % (i, opid))
            else:
                batches[opid] = (i, m)
                border.append(opid)
        elif k in ("op", "succ"):
            if not opid:
                anomalies.append("record %d: declaration without op id" % i)
            elif opid in ops:
                anomalies.append("record %d: duplicate declaration of '%s'" % (i, opid))
            else:
                ops[opid] = {"decl": (i, m), "out": None, "done": None, "atts": [], "chunks": [], "succ": []}
                order.append(opid)
        elif k in ("out", "done", "att", "chunk"):
            if opid not in ops:
                anomalies.append("record %d: %s references undeclared op '%s'" % (i, k, opid))
            elif k == "out":
                if ops[opid]["out"]:
                    anomalies.append("record %d: duplicate outcome for '%s'" % (i, opid))
                else:
                    ops[opid]["out"] = (i, m)
            elif k == "done":
                if ops[opid]["done"]:
                    anomalies.append("record %d: duplicate completion for '%s'" % (i, opid))
                else:
                    ops[opid]["done"] = (i, m)
            elif k == "att":
                ops[opid]["atts"].append((i, m))
            else:
                ops[opid]["chunks"].append((i, m))
        else:
            anomalies.append("record %d: unknown kind '%s'" % (i, k))
    for opid in order:  # successor lineage links
        di, d = ops[opid]["decl"]
        if d.get("k") == "succ":
            sup = str(d.get("sup", ""))
            if sup in ops:
                ops[sup]["succ"].append(opid)
            else:
                anomalies.append("record %d: successor of undeclared op '%s'" % (di, sup))
    for opid in order:  # attestation vs recorded-outcome conflicts
        o = ops[opid]
        if o["out"]:
            for ai, am in o["atts"]:
                if str(am.get("claims", "")) != str(o["out"][1].get("st", "")):
                    anomalies.append("record %d: attestation claims '%s' but outcome record %d says '%s'" % (ai, str(am.get("claims", "")), o["out"][0], str(o["out"][1].get("st", ""))))
    for opid in order:  # v1.1-ext: leg/batch linkage integrity
        di, d = ops[opid]["decl"]
        b = str(d.get("batch", ""))
        if b and b not in batches:
            anomalies.append("record %d: leg of undeclared batch '%s'" % (di, b))
    for bid in border:  # v1.1-ext: successor-batch lineage integrity
        bi, bm = batches[bid]
        sup = str(bm.get("sup", ""))
        if sup and sup not in batches:
            anomalies.append("record %d: successor batch of undeclared batch '%s'" % (bi, sup))
    return ops, order, batches, border  # v1.1-ext: signature widened

def standing_of(o):
    if tagclass(str(o["decl"][1].get("tag", ""))) == "stream":
        return "STREAM-COMPLETE" if o["done"] else "STREAM-INCOMPLETE"
    if o["out"]:
        return "SETTLED" if o["done"] else "OUTCOME-UNCONFIRMED"
    if o["atts"]:
        return "ATTESTED" if len({str(a[1].get("claims", "")) for a in o["atts"]}) == 1 else "CONFLICT"
    return "UNRESOLVED"

# ---------- canonical recovery rendering (digest spec v2; see README-EXTENSION §Digest) ----------
# v1.1-ext: spec bumped to ss0-recovery/2 — op lines gain trailing batch=/leg= fields;
# a batch census section follows the op lines. v1 frozen digests remain on the ledger.

def legs_of(ops, order, bid):
    out = {}
    for opid in order:
        d = ops[opid]["decl"][1]
        if str(d.get("batch", "")) == bid:
            out[int(d.get("leg", 0))] = opid
    return out

def render(ops, order, tail, nrec, anomalies, batches, border):
    L = ["ss0-recovery/2", "tail=" + tail, "records=%d" % nrec, "anomalies=%d" % len(anomalies)]
    L += ["anomaly=" + a for a in anomalies]
    L.append("ops=%d" % len(order))
    for opid in order:
        o = ops[opid]
        di, d = o["decl"]
        succ = d.get("k") == "succ"
        tag = str(d.get("tag", ""))
        s = standing_of(o)
        st, pc = "-", "-"
        if o["out"]:
            st, pc = str(o["out"][1].get("st", "")), str(o["out"][1].get("pc", "absent"))
        elif s == "ATTESTED":
            st = str(o["atts"][0][1].get("claims", ""))
        att = ",".join("%s:%s:%s" % (a[1].get("src", ""), a[1].get("sdig", ""), a[1].get("claims", ""))
                       for a in o["atts"]) or "-"
        chunks = ",".join(str(c[1].get("i", 0)) for c in sorted(o["chunks"], key=lambda c: int(c[1].get("i", 0)))) or "-"
        want = want_of(tag)
        L.append("|".join(["op=" + opid, "role=" + ("successor" if succ else "initial"),
                           "sup=" + (str(d.get("sup", "-")) if succ else "-"), "tag=" + tag,
                           "class=" + tagclass(tag), "standing=" + s, "st=" + st, "pc=" + pc,
                           "conf=" + ("1" if o["done"] else "0"), "att=" + att, "chunks=" + chunks,
                           "want=" + (str(want) if want is not None else "-"),
                           "succ=" + (",".join(o["succ"]) if o["succ"] else "-"),
                           "batch=" + (str(d.get("batch", "")) or "-"),
                           "leg=" + (str(d.get("leg", "")) or "-")]))
    L.append("batches=%d" % len(border))  # v1.1-ext: per-leg census, derived only
    for bid in border:
        bi, bm = batches[bid]
        n = int(bm.get("legs", 0))
        legs = legs_of(ops, order, bid)
        top = max([n] + list(legs))
        census = ",".join("%d:%s" % (i, standing_of(ops[legs[i]]) if i in legs else "NONE")
                          for i in range(1, top + 1)) or "-"
        L.append("|".join(["batch=" + bid, "tag=" + str(bm.get("tag", "")), "legs=%d" % n,
                           "sup=" + (str(bm.get("sup", "")) or "-"), "census=" + census,
                           "aband=" + (str(bm.get("aband", "")) or "-")]))
    return "\n".join(L) + "\n"

# ---------- re-dispatch gate (R3/R4): automatic re-dispatch is impossible here ----------

def gate(ops, opid, tail, batches=None, order=None):
    if batches and opid in batches:  # v1.1-ext: wholesale batch re-dispatch is blind by construction
        bi, bm = batches[opid]
        legs = legs_of(ops, order or list(ops), opid)
        n = int(bm.get("legs", 0))
        census = ", ".join("leg-%d %s" % (i, standing_of(ops[legs[i]]) if i in legs else "NONE") for i in range(1, max([n] + list(legs)) + 1))
        return False, ["record %d declares batch '%s' (%s legs; per-leg standings: %s); a batch is never "
                       "re-dispatched wholesale — legs are governed individually (per-leg modes) and batch-level "
                       "proceeding requires an explicit successor with per-leg lineage (mode 'bsucceed')"
                       % (bi, opid, bm.get("legs"), census)]
    if opid not in ops:
        if tail == "torn":
            return False, ["log tail is TORN: a truncated record survives, so absence of a prior declaration of '%s' cannot be certified" % opid]
        return True, ["no surviving record mentions '%s'; declarations precede dispatch and are durable, so an intact clean log certifies no prior dispatch — lawful only as a FIRST attempt under a fresh identity" % opid]
    o = ops[opid]
    s = standing_of(o)
    if s in ("UNRESOLVED", "STREAM-INCOMPLETE"):
        return False, ["record %d declares '%s' but no outcome/completion/attestation completes it; dispatch may already have happened and the records cannot tell — re-dispatch could double-execute" % (o["decl"][0], opid)]
    if s == "OUTCOME-UNCONFIRMED":
        return False, ["record %d: outcome '%s' survives UNCONFIRMED (no completion record); re-dispatch could double-execute" % (o["out"][0], o["out"][1].get("st"))]
    if s == "SETTLED":
        st = str(o["out"][1].get("st"))
        if st == "executed":
            return False, ["records %d+%d: '%s' is settled-executed; re-dispatch would double-execute" % (o["out"][0], o["done"][0], opid)]
        if st == "not-executed":
            return True, ["records %d+%d: provider refusal is settled — the effect is known NOT executed; a fresh-identity dispatch is lawful" % (o["out"][0], o["done"][0])]
        return False, ["records %d+%d: settled with payload class '%s'; re-dispatch is redundant" % (o["out"][0], o["done"][0], o["out"][1].get("pc"))]
    if s == "ATTESTED":
        ai, am = o["atts"][0]
        ev = "attestation record %d (src=%s sdig=%s)" % (ai, am.get("src"), am.get("sdig"))
        cl = str(am.get("claims", ""))
        if cl == "executed":
            return False, [ev + " resolves '%s' to EXECUTED; resolution to executed never enables re-dispatch of the same intent (R4)" % opid]
        if cl == "not-executed":
            return True, [ev + " resolves '%s' to NOT-EXECUTED; a fresh-identity dispatch is lawful" % opid]
        return False, [ev + " carries unrecognized claim '%s'; standing unresolved" % cl]
    return False, ["standing %s for '%s': automatic re-dispatch refused" % (s, opid)]

# ---------- recovery modes ----------

def show_record(i, m):
    print("    [%d] %s" % (i, " ".join("%s=%r" % (k, m[k]) for k in sorted(m))))

def canonical_block(rd):
    records, tail, anomalies, nrec = load(rd)
    ops, order, batches, border = build(records, anomalies)  # v1.1-ext: widened
    text = render(ops, order, tail, nrec, anomalies, batches, border)  # v1.1-ext: widened
    return records, tail, anomalies, nrec, ops, order, batches, border, text  # v1.1-ext: widened

def mode_canon(rd):
    records, tail, anomalies, nrec, ops, order, batches, border, text = canonical_block(rd)  # v1.1-ext: widened
    print(text, end="")
    print("digest=" + crc32_hex(text.encode("utf-8")))
    return 0

def mode_recover(rd):
    records, tail, anomalies, nrec, ops, order, batches, border, text = canonical_block(rd)  # v1.1-ext: widened
    print("== SS-0 cold recovery — %s" % rd)
    print("storage: %d intact frame(s), %d decodable record(s); tail=%s" % (nrec, len(records), tail))
    print("A. SURVIVING RECORDS (recorded observations — the only evidence this report uses)")
    for i, m in records:
        show_record(i, m)
    if not records:
        print("    (none — nothing survived; the process may have died before any declaration; no operation is known, none may be asserted)")
    if tail == "torn":
        print("    note: tail is TORN — a truncated record survives beyond the intact prefix; its content is unknowable and is excluded from every derivation below")
    print("B. DERIVED RECOVERY STATE (computed from section A only; recovery appends nothing, and")
    print("   re-verification cannot upgrade derived state to recorded observation — R6)")
    for opid in order:
        o = ops[opid]
        di, d = o["decl"]
        s = standing_of(o)
        role = "successor of '%s' (distinct identity; not a first attempt, not a retry)" % d.get("sup") if d.get("k") == "succ" else "initial"
        legof = "  member-of-batch=%s leg=%s" % (d.get("batch"), d.get("leg")) if "batch" in d else ""  # v1.1-ext
        print("  op '%s'  tag=%s  class=%s  role=%s%s" % (opid, d.get("tag"), tagclass(str(d.get("tag", ""))), role, legof))
        print("    standing: %s   [derived]" % s)
        basis = ["declaration [%d]" % di]
        if o["out"]:
            basis.append("outcome [%d]" % o["out"][0])
        if o["done"]:
            basis.append("completion [%d]" % o["done"][0])
        basis += ["attestation [%d]" % ai for ai, _ in o["atts"]]
        print("    basis: " + "; ".join(basis))
        if o["out"]:
            m = o["out"][1]
            extra = ("  payload=%r" % m["pl"]) if "pl" in m else (("  payload-digest=" + str(m["pd"])) if "pd" in m else "")
            print("    outcome: st=%s  payload-class=%s%s  recorded-durable=%s" % (m.get("st"), m.get("pc"), extra, m.get("dur")))
        elif s == "ATTESTED":
            for ai, am in o["atts"]:
                print("    attested: claims=%s via %s (crc32 %s) — external evidence admitted to the record, not direct observation" % (am.get("claims"), am.get("src"), am.get("sdig")))
        elif s == "UNRESOLVED":
            print("    outcome: UNKNOWN — possible histories consistent with the surviving records:")
            print("      (a) died after declaration, before dispatch — provider never contacted;")
            print("      (b) died after dispatch — provider executed or refused, outcome never recorded.")
            print("      The records cannot distinguish (a) from (b); no outcome may be asserted (R1).")
        if o["chunks"]:
            have = sorted(int(c[1].get("i", 0)) for c in o["chunks"])
            print("    stream chunks on record: %s (declared want=%s)" % (have, want_of(str(d.get("tag", "")))))
        if o["succ"]:
            print("    successors on record: %s (this op's own standing is unchanged and stays visible)" % ", ".join(o["succ"]))
        ok, reasons = gate(ops, opid, tail)
        print("    re-dispatch gate: %s — %s" % ("LAWFUL-FRESH-IDENTITY" if ok else "REFUSED", reasons[0]))
    for bid in border:  # v1.1-ext: per-leg batch census (derived; the record holds no batch status)
        bi, bm = batches[bid]
        legs = legs_of(ops, order, bid)
        n = int(bm.get("legs", 0))
        print("  batch '%s'  tag=%s  legs=%s%s%s" % (bid, bm.get("tag"), bm.get("legs"),
              ("  successor-of='%s'" % bm["sup"]) if bm.get("sup") else "",
              ("  abandons=%s" % bm["aband"]) if bm.get("aband") else ""))
        for i in range(1, max([n] + list(legs)) + 1):
            if i in legs:
                o = ops[legs[i]]
                print("    leg %d ('%s'): standing %s [derived]" % (i, legs[i], standing_of(o)))
            else:
                print("    leg %d: NONE — no records survive (never declared here, or declaration lost)" % i)
    print("C. ANOMALIES (planted or real damage; reported, never silently repaired)")
    for a in anomalies:
        print("    " + a)
    if not anomalies:
        print("    (none)")
    print("D. CANONICAL RECOVERY RENDERING (digest spec v1 — the independent CL reader must agree)")
    print(text, end="")
    print("digest=" + crc32_hex(text.encode("utf-8")))
    return 0

def mode_redispatch(rd, opid):
    records, tail, anomalies, nrec = load(rd)
    ops, order, batches, border = build(records, anomalies)  # v1.1-ext: widened
    ok, reasons = gate(ops, opid, tail, batches, order)  # v1.1-ext: batch-aware
    print(("%s automatic re-dispatch of '%s'" % ("CERTIFIED:" if ok else "REFUSED:", opid)))
    for r in reasons:
        print("  evidence: " + r)
    if opid in batches:  # v1.1-ext
        show_record(*batches[opid])
    if opid in ops:
        o = ops[opid]
        for i, m in [o["decl"]] + [x for x in (o["out"], o["done"]) if x] + o["atts"]:
            show_record(i, m)
    if not ok:
        print("  policy: this gate never dispatches. Lawful paths: admit a provider receipt (mode 'admit') or proceed under an explicitly distinct identity (mode 'succeed').")
    return 0 if ok else 3

def mode_admit(rd, opid):
    records, tail, anomalies, nrec = load(rd)
    ops, order, batches, border = build(records, anomalies)  # v1.1-ext: widened
    if opid in batches:  # v1.1-ext: providers issue receipts per leg, never per batch
        print("REFUSE: '%s' is a batch declaration; providers issue receipts per leg, not per batch — admit the individual leg (e.g. '%s')" % (opid, leg_id(opid, 1)))
        return 4
    if opid not in ops:
        print("REFUSE: no declaration of '%s' survives; an attestation cannot be attached to an operation the record does not know" % opid)
        return 4
    o = ops[opid]
    if o["out"]:
        print("no-op: outcome record %d already resolves '%s' by direct observation; attestation unnecessary" % (o["out"][0], opid))
        return 0
    src = "receipt-%s.txt" % opid
    p = os.path.join(rd, src)
    if not os.path.exists(p):
        print("nothing to admit: %s is not present in the provider world; standing remains %s" % (src, standing_of(o)))
        return 4
    data = open(p, "rb").read()
    fields = dict(line.split(": ", 1) for line in data.decode("utf-8").splitlines() if ": " in line)
    if fields.get("attempt") != opid:
        print("REFUSE: receipt names attempt '%s', not '%s'; provenance mismatch" % (fields.get("attempt"), opid))
        return 4
    claims = fields.get("outcome", "")
    rec(rd, {"k": "att", "op": opid, "src": src, "sdig": crc32_hex(data), "claims": claims})
    print("admitted: %s (crc32 %s) entered the durable record as attestation for '%s', claims='%s'" % (src, crc32_hex(data), opid, claims))
    if claims == "executed":
        print("standing now ATTESTED/executed — re-dispatch of this intent is permanently forbidden (R4)")
    elif claims == "not-executed":
        print("standing now ATTESTED/not-executed — proceeding lawfully requires a fresh identity (mode 'succeed')")
    else:
        print("standing now ATTESTED/'%s' — unrecognized claim; standing not resolved" % claims)
    return 0

def mode_succeed(rd, old, new, tag=None):
    records, tail, anomalies, nrec = load(rd)
    ops, order, batches, border = build(records, anomalies)  # v1.1-ext: widened
    if old in batches:  # v1.1-ext
        print("REFUSE: '%s' is a batch; use mode 'bsucceed' so the successor carries per-leg lineage" % old)
        return 4
    if old not in ops:
        print("REFUSE: predecessor '%s' is not on record; a successor must supersede a recorded operation" % old)
        return 4
    if new in ops:
        print("REFUSE: identity '%s' is already on record; successor identity must be fresh" % new)
        return 4
    s = standing_of(ops[old])
    if s not in ("UNRESOLVED", "OUTCOME-UNCONFIRMED", "STREAM-INCOMPLETE", "CONFLICT"):
        print("REFUSE: predecessor '%s' standing is %s — resolved; there is no unresolved standing to supersede" % (old, s))
        return 4
    tag = tag or str(ops[old]["decl"][1].get("tag", ""))
    print("proceeding: predecessor '%s' remains %s and stays visible on record;" % (old, s))
    print("successor '%s' is an explicitly distinct operation (fresh identity, supersedes '%s') — not a first attempt, not a plain retry" % (new, old))
    declare(rd, new, tag, sup=old)
    operate(rd, new, tag)
    finish(rd, new)
    print("successor '%s' dispatched and settled; predecessor standing unchanged (%s)" % (new, s))
    return 0

def mode_bsucceed(rd, old, new):  # v1.1-ext: batch successor with explicit per-leg lineage
    records, tail, anomalies, nrec = load(rd)
    ops, order, batches, border = build(records, anomalies)
    if old not in batches:
        print("REFUSE: predecessor batch '%s' is not on record; a batch successor must supersede a recorded batch" % old)
        return 4
    if new in batches or new in ops:
        print("REFUSE: identity '%s' is already on record; successor identity must be fresh" % new)
        return 4
    bi, bm = batches[old]
    n = int(bm.get("legs", 0))
    label = str(bm.get("tag", "")).rsplit(":", 1)[0][6:]
    aband, plan = [], []
    for i in range(1, n + 1):
        lid = leg_id(old, i)
        if lid in ops:
            o = ops[lid]
            s = standing_of(o)
            st = str(o["out"][1].get("st")) if o["out"] else (str(o["atts"][0][1].get("claims", "")) if s == "ATTESTED" else "")
            if s in ("SETTLED", "ATTESTED") and st == "executed":
                aband.append(lid)  # known executed: re-attempt would double-execute
            else:
                plan.append((i, lid))  # unresolved, unconfirmed, or known-not-executed: re-attempt
        else:
            plan.append((i, None))  # never declared: first attempt under the successor
    batch_decl(rd, new, label, n, sup=old, aband=",".join(aband))
    for i, oldlid in plan:
        tag = "effect:" + label  # re-attempt pursues the leg's underlying intent
        leg_decl(rd, new, i, tag, sup=oldlid)
        operate(rd, leg_id(new, i), tag)
        finish(rd, leg_id(new, i))
    print("successor batch '%s' supersedes '%s': re-attempts legs %s (per-leg succ lineage); abandons %s "
          "(known executed); predecessor legs' standing unchanged and stays visible"
          % (new, old, ["leg-%d" % i for i, _ in plan], aband or ["none"]))
    return 0

USAGE = ("usage: ss0.py <run-dir> <scenario | mode> [args]\n"
         "  harness form: ss0.py <run-dir>/ <kind> <killpoint-or-empty>  (kind: effect|stream|refused)\n"
         "  scenarios: " + ", ".join(SCEN) + "\n"
         "  modes: recover | canon | redispatch <op> | admit <op> | succeed <old-op> <new-op> [tag]"
         " | bsucceed <old-batch> <new-batch>\n")  # v1.1-ext

def main(argv):
    if len(argv) < 3:
        sys.stderr.write(USAGE)
        return 2
    rd, name = argv[1], argv[2]
    kp = argv[3] if len(argv) > 3 else ""
    sc = name if name in SCEN else KIND.get((name, kp))
    if sc:
        SCEN[sc](rd, kp)
        return 0
    if name == "recover":
        return mode_recover(rd)
    if name == "canon":
        return mode_canon(rd)
    if name == "redispatch" and len(argv) > 3:
        return mode_redispatch(rd, argv[3])
    if name == "admit" and len(argv) > 3:
        return mode_admit(rd, argv[3])
    if name == "succeed" and len(argv) > 4:
        return mode_succeed(rd, argv[3], argv[4], argv[5] if len(argv) > 5 else None)
    if name == "bsucceed" and len(argv) > 4:  # v1.1-ext
        return mode_bsucceed(rd, argv[3], argv[4])
    sys.stderr.write(USAGE)
    return 2

if __name__ == "__main__":
    sys.exit(main(sys.argv))
