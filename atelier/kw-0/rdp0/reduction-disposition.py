#!/usr/bin/env python3
"""reduction-disposition.json generator.

RDP-0 Patch 3: the machine-readable disposition artifact. Consumes the
inventory JSON and the RDP-0 disposition table (authored below as data) and
emits, for every identity domain, condition subtype, and event type:

  original-status / proposed-disposition / governing-lane / docket-id /
  replacement-identity / proof-obligation / current-executable-status

Also enumerates the exact live condition set and the identity-domain counts
per Patch 1 (no target number may counterfeit a completed migration).

Usage:
    python3 reduction-disposition.py latent-lisp-inventory.json [out.json]
"""
import json
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# RDP-0 disposition table (authored; the inventory supplies original status).
# Dispositions: LIVE / LIVE-REPLACEMENT / MERGED / FUTURE-LANE / DEFERRED /
#               ERRATA-DEFECT / UNTOUCHED
# ---------------------------------------------------------------------------

CONDITIONS = {
    # --- merged away (3 original types; 2 replacements minted) -------------
    "duplicate-attempt-identity": ("MERGED", "kernel-conditions", None,
        "duplicate-identity", "C-1: one generic condition carries offending domain"),
    "duplicate-process-identity": ("MERGED", "kernel-conditions", None,
        "duplicate-identity", "C-1"),
    "bare-validation-scope": ("MERGED", "kernel-conditions", "DKT-4",
        "bare-standing-scope", "C-2: merge only after DKT-4 resolves asymmetry"),
    # --- errata docket (4) --------------------------------------------------
    "attempt-terminal": ("ERRATA-DEFECT", "kernel0-errata", "DKT-1", None,
        "runtime refusal, unwired: fold classifies terminality but does not police it"),
    "fold-nondeterministic": ("ERRATA-DEFECT", "differential-conformance-harness", "DKT-2", None,
        "conformance failure, not runtime condition; no impossible self-observation"),
    "duplicate-seat-identity": ("ERRATA-DEFECT", "kernel0-errata", "DKT-3", None,
        "constructor invariant pending one spec line on re-reservation semantics"),
    "bare-visibility-scope": ("ERRATA-DEFECT", "kernel0-errata", "DKT-4", None,
        "constructor invariant; asymmetric-coverage investigation; blocks C-2 merge"),
    # --- deferred-governing (1; fate bound to I-6/DKT-12) -------------------
    "duplicate-external-request-identity": ("DEFERRED", "adapter-boundary", "DKT-12", None,
        "discharge with external-request demotion proof, or keep with the domain"),
    # --- future lane (16) ---------------------------------------------------
    "capability-budget-exceeded": ("FUTURE-LANE", "arc-2-capability", None, None, "no budget machinery exists"),
    "capability-count-exceeded": ("FUTURE-LANE", "arc-2-capability", None, None, "no count machinery exists"),
    "capability-expired": ("FUTURE-LANE", "arc-2-capability", None, None, "no expiry machinery exists"),
    "capability-restoration-denied": ("FUTURE-LANE", "arc-2-capability", None, None, "arc 2"),
    "capability-restoration-scope-enlarged": ("FUTURE-LANE", "arc-2-capability", None, None, "arc 2"),
    "capability-self-restoration-forbidden": ("FUTURE-LANE", "arc-2-capability", None, None, "arc 2"),
    "minting-authority-invalid": ("FUTURE-LANE", "arc-2-capability", None, None, "arc 2"),
    "channel-policy-missing": ("FUTURE-LANE", "arc-3-channel-policy", None, None, "zero users"),
    "channel-policy-amendment-unauthorized": ("FUTURE-LANE", "arc-3-channel-policy", None, None, "zero users"),
    "publication-authority-missing": ("FUTURE-LANE", "publication", None, None, "publication lane unbuilt"),
    "adapter-version-drift": ("FUTURE-LANE", "adapter", None, None, "adapter lane unbuilt"),
    "machine-configuration-drift": ("FUTURE-LANE", "adapter", None, None, "adapter lane unbuilt"),
    "implicit-fallback-forbidden": ("FUTURE-LANE", "adapter", None, None, "L11 adapter lane"),
    "unsafe-host-escape": ("FUTURE-LANE", "host-boundary", None, None, "host-boundary lane"),
    "journal-merge-receipt-required": ("FUTURE-LANE", "journal-merge", None, None, "no second journal exists"),
    "exposed-principal-missing": ("FUTURE-LANE", "language-a-library", None, None, "demotes with L16"),
}

# Everything else in the inventory's condition set is LIVE (37 original types).
LIVE_NOTE = {
    "present-payload-erasure": "invariant-by-representation candidate: mutant killed by "
                               "read-only surface; classify in errata, do not display as runtime refusal",
    "fold-nondeterministic": None,
}

DOMAINS = {
    "journal": ("ACCEPTED-PENDING-MIGRATION", "store", None,
        "(store-id, journal-name) compound identity", "OE-1"),
    "reconciliation": ("ACCEPTED-PENDING-MIGRATION", "receipt", None,
        "receipt class", "OE-2"),
    "parser": ("ACCEPTED-PENDING-MIGRATION", "procedure", None,
        "procedure identity, class :parser", "OE-3"),
    "channel-policy": ("POSTPONED", "arc-3-channel-policy", None, None,
        "postponed registry entry; reintroduction must not collide with interim registry"),
    "logical-operation": ("DEFERRED", None, "DKT-11", None,
        "prove replacement without collapsing intentional sameness into structural sameness"),
    "external-request": ("DEFERRED", None, "DKT-12", None,
        "prove uniqueness/idempotency/CW-3 reconciliation survive adapter-attribute status"),
    "exposure": ("DEFERRED", None, "DKT-13", None,
        "Language-A lane supplies counterexample set: spendable? exhaustible? policy-bearing?"),
}

EVENTS = {
    "artifact-committed": ("ERRATA-DEFECT", "kernel0-errata", "DKT-5", None,
        "obsolete-declaration candidate unless a lane claims it"),
    "capability-restored": ("FUTURE-LANE", "arc-2-capability", "DKT-6", None, "arc 2"),
    "derived-view-recorded": ("ERRATA-DEFECT", "kernel0-errata", "DKT-7", None,
        "obsolete-declaration candidate unless a lane claims it"),
    "process-authorized": ("ERRATA-DEFECT", "kernel0-errata", "DKT-8", None,
        "redundant with minting receipts (L-5); strike or justify"),
    "process-suspended": ("FUTURE-LANE", "process-suspension", "DKT-9", None,
        "postponed with SUSPENDED vocabulary"),
    "request-acknowledged": ("FUTURE-LANE", "adapter", "DKT-10", None, "adapter lane"),
}


def main():
    inv = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else None

    cond_status = {t["name"]: t["status"] for t in inv["conditions"]["types"]}
    event_status = {t["name"]: t["status"] for t in inv["event-types"]["types"]}
    domains_all = inv["identity-domains"]["domains"]

    conditions = []
    live_set = []
    for name in inv["identity-domains"]["domains"]:
        pass  # domains handled below
    for t in inv["conditions"]["types"]:
        name = t["name"]
        if name in CONDITIONS:
            disp, lane, docket, repl, obligation = CONDITIONS[name]
        else:
            disp, lane, docket, repl, obligation = ("LIVE", "kernel0 / killed-witness", None, None,
                                                    LIVE_NOTE.get(name))
            live_set.append(name)
        conditions.append({
            "name": name,
            "register": "condition",
            "original-status": t["status"],
            "proposed-disposition": disp,
            "governing-lane": lane,
            "docket-id": docket,
            "replacement-identity": repl,
            "proof-obligation": obligation,
            "current-executable-status": t["status"],
        })

    domain_items = []
    for d in domains_all:
        if d in DOMAINS:
            disp, lane, docket, repl, obligation = DOMAINS[d]
        else:
            disp, lane, docket, repl, obligation = ("UNTOUCHED-ACTIVE", "kernel0", None, None, None)
        domain_items.append({
            "name": d, "register": "identity-domain",
            "proposed-disposition": disp, "governing-lane": lane,
            "docket-id": docket, "replacement-identity": repl,
            "proof-obligation": obligation,
            "current-executable-status": "active",
        })

    event_items = []
    for t in inv["event-types"]["types"]:
        name = t["name"]
        if name in EVENTS:
            disp, lane, docket, repl, obligation = EVENTS[name]
        else:
            disp, lane, docket, repl, obligation = ("LIVE", "kernel0 / killed-witness", None, None, None)
        event_items.append({
            "name": name, "register": "event-type",
            "original-status": t["status"],
            "proposed-disposition": disp, "governing-lane": lane,
            "docket-id": docket, "replacement-identity": repl,
            "proof-obligation": obligation,
            "current-executable-status": t["status"],
        })

    # Patch-1 arithmetic, stated so no target counterfeits a migration.
    n_dom = len(domains_all)
    n_accepted = sum(1 for d in domain_items if d["proposed-disposition"] == "ACCEPTED-PENDING-MIGRATION")
    n_postponed = sum(1 for d in domain_items if d["proposed-disposition"] == "POSTPONED")
    n_deferred = sum(1 for d in domain_items if d["proposed-disposition"] == "DEFERRED")
    summary = {
        "identity-domains": {
            "original": n_dom,
            "active-now": n_dom,
            "merges-accepted-pending-migration": n_accepted,
            "postponed-registry-entries": n_postponed,
            "deferred-still-governing": n_deferred,
            "active-after-accepted-migrations": n_dom - n_accepted - n_postponed,
            "target-if-deferred-discharge": n_dom - n_accepted - n_postponed - n_deferred,
            "note": "no target number counterfeits a completed migration; "
                    "accepted merges become real only when code and vectors move",
        },
        "conditions": {
            "original": len(conditions),
            "live-enumerated": len(live_set),
            "merged-away": sum(1 for c in conditions if c["proposed-disposition"] == "MERGED"),
            "errata-docket": sum(1 for c in conditions if c["proposed-disposition"] == "ERRATA-DEFECT"),
            "future-lane": sum(1 for c in conditions if c["proposed-disposition"] == "FUTURE-LANE"),
            "deferred-governing": sum(1 for c in conditions if c["proposed-disposition"] == "DEFERRED"),
            "live-set": sorted(live_set),
            "arithmetic-correction": "RDP-0 prose said '37 live, 17 postponed, 7 merged'. "
                "Enumeration gives: 37 live + 1 deferred-governing + 16 future-lane "
                "(= 17 postponed) + 4 errata-docket + 3 merged-away = 61. The '7 merged' "
                "double-counted the full merge program; only 3 original types are removed "
                "now, replaced by 2 consolidated types (duplicate-identity, bare-standing-scope).",
        },
        "event-types": {
            "original": len(event_items),
            "live": sum(1 for e in event_items if e["proposed-disposition"] == "LIVE"),
            "errata-docket": sum(1 for e in event_items if e["proposed-disposition"] == "ERRATA-DEFECT"),
            "future-lane": sum(1 for e in event_items if e["proposed-disposition"] == "FUTURE-LANE"),
        },
    }

    artifact = {
        "disposition-version": 1,
        "packet": "RDP-0 (patched 2026-07-20)",
        "source-inventory-commit": inv["source"]["commit"],
        "analysis-kind": "lexical-static-inventory + authored disposition table",
        "summary": summary,
        "identity-domains": domain_items,
        "conditions": conditions,
        "event-types": event_items,
    }
    text = json.dumps(artifact, indent=2, ensure_ascii=False) + "\n"
    if out:
        out.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    s = summary["conditions"]
    print(f"conditions: {s['original']} = {s['live-enumerated']} live + "
          f"{s['deferred-governing']} deferred + {s['future-lane']} future-lane + "
          f"{s['errata-docket']} docket + {s['merged-away']} merged", file=sys.stderr)
    d = summary["identity-domains"]
    print(f"domains: {d['original']} original; {d['merges-accepted-pending-migration']} accepted "
          f"(pending migration); {d['postponed-registry-entries']} postponed; "
          f"{d['deferred-still-governing']} deferred; active-now {d['active-now']}; "
          f"after accepted migrations {d['active-after-accepted-migrations']}; "
          f"target {d['target-if-deferred-discharge']}", file=sys.stderr)


if __name__ == "__main__":
    main()
