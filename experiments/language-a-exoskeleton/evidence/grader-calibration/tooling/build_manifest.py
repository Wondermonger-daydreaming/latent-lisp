#!/usr/bin/env python3
"""build_manifest.py -- derive/verify the Language-A grader-calibration packet freeze manifest.

LAPIDARY (Claude Opus 4.x subagent), coordinator Claude Fable 5.

Manifest schema id: `lae-grader-calibration-packet/1.0.0`.
Records, for every packet file (rater-visible examples AND author-only ground truth), the repo-
relative path, byte count, and SHA-256. Also carries: the permanent-taint statement; the explicit
statement that no real item/packet/key/trap/opportunity content was read or included; the
authorization reference (GATE-WALK-R12 record id + digest); and the authored-by attribution.

Usage:
  python3 build_manifest.py            # (re)write PACKET-FREEZE-MANIFEST.json + .sha256
  python3 build_manifest.py --verify   # recompute and diff against the on-disk manifest
"""
import argparse
import hashlib
import json
import sys
import time
from pathlib import Path

TOOLING_DIR = Path(__file__).resolve().parent
CALIB_ROOT = TOOLING_DIR.parent                     # evidence/grader-calibration
PACKET_DIR = CALIB_ROOT / "packet"
EXP_ROOT = CALIB_ROOT.parents[1]                    # experiments/language-a-exoskeleton
MANIFEST_PATH = CALIB_ROOT / "PACKET-FREEZE-MANIFEST.json"
SIDECAR_PATH = CALIB_ROOT / "PACKET-FREEZE-MANIFEST.sha256"

SCHEMA_ID = "lae-grader-calibration-packet/1.0.0"

AUTHORIZATION = {
    "decision_id": "GATE-WALK-R12",
    "record_id": "owner-decision:gate-walk-r12-adopted-v1",
    "record_digest": "sha256:fe03e898144ddc57721edc51ac074413dec27131840ec6af0ad0bc1c62035f3f",
    "controlling_authority": "sha256:55f0c6d93cfab0a026861f266aa258fa0a7c27f6df2dd4afeb4817f062032379",
    "scope": "synthetic-only grader calibration; OpenRouter route; zero real-item bytes egress; "
             "cost well under USD 1; evidence landing evidence/grader-calibration/; "
             "pre-exposure gate remains UNSIGNED; no merge; no live target scoring; "
             "no key-content exposure.",
}

AUTHORED_BY = {
    "packet_author": "Claude Opus 4.x subagent (LAPIDARY)",
    "coordinator": "Claude Fable 5",
    "note": "Authors may author; authors may not rate. The author performed no rating or "
            "adjudication. Barred from rating: actor:fable-item-author, actor:sol-item-author.",
}


def sha256_file(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def canonical_bytes(value):
    return (json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n").encode("utf-8")


def collect_packet_files():
    files = sorted(PACKET_DIR.rglob("*.json"))
    entries = []
    for p in files:
        rel = p.relative_to(EXP_ROOT).as_posix()
        author_only = "ground-truth" in p.relative_to(PACKET_DIR).parts
        entries.append({
            "path": rel,
            "bytes": p.stat().st_size,
            "sha256": sha256_file(p),
            "visibility": "author-only-ground-truth" if author_only else "rater-visible",
        })
    return entries


def collect_tooling_and_docs():
    inv = []
    for rel in ("tooling/author_packet.py", "tooling/run_calibration.py",
                "tooling/build_manifest.py", "RUN-DESIGN.md"):
        p = CALIB_ROOT / rel
        if p.exists():
            inv.append({
                "path": p.relative_to(EXP_ROOT).as_posix(),
                "bytes": p.stat().st_size,
                "sha256": sha256_file(p),
            })
    return inv


def build_manifest():
    packet_files = collect_packet_files()
    rater_visible = [e for e in packet_files if e["visibility"] == "rater-visible"]
    ground_truth = [e for e in packet_files if e["visibility"] != "rater-visible"]
    manifest = {
        "schema": SCHEMA_ID,
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "authored_by": AUTHORED_BY,
        "authorization": AUTHORIZATION,
        "permanent_taint_statement": (
            "Every calibration example in this packet is authored, synthetic, "
            "synthetic_only=true, permanently_tainted=true, and is PERMANENTLY EXCLUDED from the "
            "target item bank. No example, paraphrase, or derivative may enter the live pilot."
        ),
        "no_real_content_statement": (
            "No real pilot item, source packet, score key, trap class, keyed disposition, or "
            "scorable-opportunity content was read or included in authoring this packet. The "
            "sources are invented fictional documents that cannot collide with the live bank. "
            "controls/synthetic-items.jsonl (a prompts-only plumbing corpus) was neither used as "
            "a source nor read for content."
        ),
        "counts": {
            "total_packet_files": len(packet_files),
            "rater_visible_examples": len(rater_visible),
            "author_only_ground_truth": len(ground_truth),
        },
        "packet_files": packet_files,
        "tooling_and_docs_inventory": collect_tooling_and_docs(),
    }
    return manifest


def write_manifest():
    manifest = build_manifest()
    data = canonical_bytes(manifest)
    MANIFEST_PATH.write_bytes(data)
    digest = hashlib.sha256(data).hexdigest()
    SIDECAR_PATH.write_text(f"{digest}  PACKET-FREEZE-MANIFEST.json\n", encoding="utf-8")
    print(f"wrote {MANIFEST_PATH.name} ({len(data)} bytes)")
    print(f"manifest sha256: {digest}")
    return digest


def verify():
    if not MANIFEST_PATH.exists():
        print("VERIFY FAIL: manifest missing")
        return False
    on_disk = json.loads(MANIFEST_PATH.read_bytes())
    fresh_files = collect_packet_files()
    ok = True
    # Compare packet-file digests (ignore volatile generated_at).
    disk_by_path = {e["path"]: e for e in on_disk["packet_files"]}
    fresh_by_path = {e["path"]: e for e in fresh_files}
    if set(disk_by_path) != set(fresh_by_path):
        print("VERIFY FAIL: packet file set changed")
        print("  only on disk-manifest:", sorted(set(disk_by_path) - set(fresh_by_path)))
        print("  only on filesystem:  ", sorted(set(fresh_by_path) - set(disk_by_path)))
        ok = False
    for path, fresh in fresh_by_path.items():
        d = disk_by_path.get(path)
        if not d:
            continue
        if (d["sha256"], d["bytes"]) != (fresh["sha256"], fresh["bytes"]):
            print(f"VERIFY FAIL: {path} changed (bytes/sha256)")
            ok = False
    # Sidecar digest check.
    if SIDECAR_PATH.exists():
        recorded = SIDECAR_PATH.read_text(encoding="utf-8").split()[0]
        actual = hashlib.sha256(MANIFEST_PATH.read_bytes()).hexdigest()
        if recorded != actual:
            print("VERIFY FAIL: sidecar digest does not match manifest bytes")
            ok = False
    print("VERIFY PASS" if ok else "VERIFY FAIL")
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--verify", action="store_true")
    args = ap.parse_args()
    if args.verify:
        sys.exit(0 if verify() else 1)
    write_manifest()


if __name__ == "__main__":
    main()
