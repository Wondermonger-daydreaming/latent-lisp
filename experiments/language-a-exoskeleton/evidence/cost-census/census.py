import hashlib, json, sys
from collections import defaultdict

PKT = "/home/gauss/Codex-Lab/wt-language-a/experiments/language-a-exoskeleton"

def sha256_bytes(b): return hashlib.sha256(b).hexdigest()
def canonical_json_bytes(v): return (json.dumps(v, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n").encode("utf-8")

SOURCE_SEPARATOR = b"\n"

# ---- template component bytes (verified == manifest hashes) ----
TPL = {}
tfiles = {"system":"common-system.txt","wrapper":"wrapper.txt","NL":"NL.txt","PERSONA":"PERSONA.txt",
          "SCAFFOLD":"SCAFFOLD.txt","LANG-A":"LANG-A.txt","SHAM":"SHAM.txt"}
for k,fn in tfiles.items():
    TPL[k] = open(f"{PKT}/tranche-b/templates/{fn}","rb").read()

SYSTEM = TPL["system"]; WRAPPER = TPL["wrapper"]
SYSTEM_SHA = sha256_bytes(SYSTEM); WRAPPER_SHA = sha256_bytes(WRAPPER)
TPL_SHA = {arm: sha256_bytes(TPL[arm]) for arm in ("NL","PERSONA","SCAFFOLD","LANG-A","SHAM")}
assert WRAPPER.count(b"{{TASK}}")==1 and WRAPPER.count(b"{{SOURCE_PACKET}}")==1

# ---- candidate target-visible items: reconstruct component bytes, verify internal hashes ----
items = {}
item_problems = []
for line in open(f"{PKT}/items/candidate/target-visible/items.jsonl"):
    line=line.strip()
    if not line: continue
    r = json.loads(line)
    iid = r["item_id"]
    task_b = r["task"]["utf8"].encode("utf-8")
    # verify task byte object
    if len(task_b)!=r["task"]["bytes"] or sha256_bytes(task_b)!=r["task"]["sha256"]:
        item_problems.append(f"{iid}: task byte-object mismatch")
    src_parts = [s["content"]["utf8"].encode("utf-8") for s in r["sources"]]
    view_parts = [v["content"]["utf8"].encode("utf-8") for v in r["derived_views"]]
    for i,s in enumerate(r["sources"]):
        b=src_parts[i]
        if len(b)!=s["content"]["bytes"] or sha256_bytes(b)!=s["content"]["sha256"]:
            item_problems.append(f"{iid}: source {s['component_id']} mismatch")
    packet = SOURCE_SEPARATOR.join(src_parts+view_parts)
    if sha256_bytes(packet)!=r["source_packet_sha256"]:
        item_problems.append(f"{iid}: source_packet_sha256 mismatch")
    target_surface = task_b + b"\0" + packet
    if sha256_bytes(target_surface)!=r["target_surface_sha256"]:
        item_problems.append(f"{iid}: target_surface_sha256 mismatch")
    tvi_sha = sha256_bytes(canonical_json_bytes(r))  # line_sha256(target)
    items[iid] = {
        "task_bytes": len(task_b), "task_sha": r["task"]["sha256"],
        "source_packet_bytes": len(packet), "source_packet_sha": r["source_packet_sha256"],
        "target_visible_item_sha": tvi_sha,
        "n_parts": len(src_parts)+len(view_parts),
    }

# ---- schedule rows: match every component hash, compute payload bytes ----
rows = [json.loads(l) for l in open(f"{PKT}/tranche-b/schedule.jsonl") if l.strip()]
assert len(rows)==312, f"expected 312 got {len(rows)}"

unmatched = []
percall = []
for r in rows:
    cid = r["call_id"]; iid = r["item_id"]; arm = r["arm"]; slot = r["subject_slot"]
    it = items.get(iid)
    if it is None:
        unmatched.append(f"{cid}: item_id {iid} absent from candidate bank"); continue
    # hash matches
    if r["system_sha256"]!=SYSTEM_SHA: unmatched.append(f"{cid}: system_sha256 no-match")
    if r["wrapper_sha256"]!=WRAPPER_SHA: unmatched.append(f"{cid}: wrapper_sha256 no-match")
    if r["template_sha256"]!=TPL_SHA.get(arm): unmatched.append(f"{cid}: template_sha256 no-match for arm {arm}")
    if r["task_sha256"]!=it["task_sha"]: unmatched.append(f"{cid}: task_sha256 no-match")
    if r["source_packet_sha256"]!=it["source_packet_sha"]: unmatched.append(f"{cid}: source_packet_sha256 no-match")
    if r["target_visible_item_sha256"]!=it["target_visible_item_sha"]: unmatched.append(f"{cid}: target_visible_item_sha256 no-match")
    # payload bytes = system + \n + template + \n + rendered_wrapper
    # rendered_wrapper = len(wrapper) - 8 - 16 + task + source_packet
    tpl_b = len(TPL[arm])
    rendered_wrapper = len(WRAPPER) - 8 - 16 + it["task_bytes"] + it["source_packet_bytes"]
    payload = len(SYSTEM) + 1 + tpl_b + 1 + rendered_wrapper
    percall.append({"call_id":cid,"subject_slot":slot,"arm":arm,"item_id":iid,"prompt_bytes":payload})

# ---- aggregates ----
grand = sum(p["prompt_bytes"] for p in percall)
by_slot = defaultdict(lambda:[0,0])   # [sum,count]
by_arm = defaultdict(lambda:[0,0])
for p in percall:
    by_slot[p["subject_slot"]][0]+=p["prompt_bytes"]; by_slot[p["subject_slot"]][1]+=1
    by_arm[p["arm"]][0]+=p["prompt_bytes"]; by_arm[p["arm"]][1]+=1

out = {
  "item_problems": item_problems,
  "unmatched": unmatched,
  "n_calls": len(percall),
  "grand_total_bytes": grand,
  "by_subject_slot": {k:{"total_bytes":v[0],"count":v[1],"mean_bytes":v[0]/v[1]} for k,v in sorted(by_slot.items())},
  "by_arm": {k:{"total_bytes":v[0],"count":v[1],"mean_bytes":v[0]/v[1]} for k,v in sorted(by_arm.items())},
}
json.dump(percall, open("/tmp/lae-census/per-call-bytes.json","w"), indent=0)
json.dump(out, open("/tmp/lae-census/census-agg.json","w"), indent=2)
print(json.dumps(out, indent=2))
