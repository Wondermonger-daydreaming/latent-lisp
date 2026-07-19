#!/usr/bin/env python3
"""latent-lisp reduction inventory extractor.

Reduction Disposition Packet, item 1: a machine-generated inventory, so future
counts cannot drift back into prose. Stdlib only; read-only against the repo.

Usage:
    python3 latent-lisp-inventory.py /path/to/latent-lisp [output.json]

EPISTEMIC LEVEL (Patch 2, RDP-0): this is a deterministic LEXICAL STATIC
INVENTORY. It is not a reachability proof and not call-graph analysis.

  * `signal-kernel0 'condition` search may miss indirect, macro-generated,
    dynamically selected, or differently expressed signaling.
  * Event usage counts may include comments, fixtures, or non-consuming
    references.
  * Six zero-occurrence events are therefore STRONG declared-only findings;
    NONZERO occurrence counts do NOT by themselves prove executable
    consumption.

Statuses therefore say `textually-signaled` / `textually-referenced`, never
`reachable` or `live`.

Extracts from the sealed text and the shipped pure core:
  - identity domains        (mneme/kernel0/identity.lisp, %identity-domain-p)
  - condition definitions   (mneme/kernel0/conditions.lisp, with §-family labels)
  - signal sites            (signal-kernel0 'name across kernel0/*.lisp, multiline-aware)
  - test references         (kernel0-selftest.lisp occurrence counts)
  - event types             (folds.lisp +kernel0-event-types+, with usage counts)
  - roles                   (Kernel /0 spec §5.2)
  - numbered laws           (Architecture 0.1 §19, L0-L18)
  - requirement identifiers ([F: ...] tags in Kernel /0 spec; K0E base ids and
                            K0E qualified clause ids, e.g. K0E-23/global-descriptor-resolution)

Determinism: output contains no timestamps; the repo commit is the version.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

NAME_RE = re.compile(r"^\s+([a-z][a-z0-9-]+)\)?\s*$")
SECTION_RE = re.compile(r"^;;\s*(Section\s+\S+.*?)\s*$")

# Extraction patterns, published in the JSON (Patch 2: the machine must show
# its own method alongside its counts).
PATTERNS = {
    "identity-domains": {
        "file": "mneme/kernel0/identity.lisp",
        "pattern": "\\(defun %identity-domain-p ... (member domain '(:keyword*) :test ...)",
    },
    "conditions": {
        "file": "mneme/kernel0/conditions.lisp",
        "pattern": "bare-name lines inside (%define-kernel0-condition-family ...) blocks, "
                   "family = preceding ';; Section ...' comment",
    },
    "signal-sites": {
        "pattern": "signal-kernel0\\s+'<name> (multiline-aware), all mneme/kernel0/*.lisp",
        "excluded-files": ["mneme/kernel0/conditions.lisp (definitions, not sites)"],
        "test-reference-file": "mneme/kernel0/kernel0-selftest.lisp (raw \\b<name>\\b counts)",
    },
    "event-types": {
        "declaration-file": "mneme/kernel0/folds.lisp",
        "declaration-pattern": "+kernel0-event-types+ '(:keyword*)",
        "usage-pattern": "raw ':<name>' occurrences across mneme/kernel0/*.lisp minus 1 "
                         "for the declaration occurrence",
    },
    "roles": {
        "file": "mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md",
        "pattern": "§5.2 'Initial role vocabulary' ```lisp block keywords",
    },
    "laws": {
        "file": "mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md",
        "pattern": "'### L<n> — <title>' headings",
    },
    "requirement-ids": {
        "F-tags": {"file": "mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md",
                   "pattern": "[F: <TAG>-<n>]"},
        "K0E": {"files": ["mneme/architecture/kernel-0-errata/**/*.md",
                          "mneme/kernel0/README.md"],
                "base-pattern": "K0E-<n>[letter]?",
                "qualified-pattern": "K0E-<n>[letter]?/<alpha-suffix> (clause identity; "
                                     "numeric slash ranges recorded separately)"},
    },
}

LIMITATIONS = [
    "Lexical static inventory: no reachability proof, no call-graph analysis.",
    "signal-kernel0 search may miss indirect, macro-generated, dynamically "
    "selected, or differently expressed signaling (e.g. (error 'name), "
    "make-condition, handler-established types).",
    "Event usage counts may include comments, fixtures, or non-consuming "
    "references; zero occurrences is a strong declared-only finding, but a "
    "nonzero count does not prove executable consumption.",
    "Test-reference counts are raw textual occurrences in the selftest, "
    "including comments and expected-condition lists.",
    "Selftest-only mutants killed by representation (read-only surfaces) are "
    "not distinguishable here from unwired conditions; see the disposition "
    "artifact for per-item classification.",
]


def read(p):
    return Path(p).read_text(encoding="utf-8")


def extract_identity_domains(repo):
    src = read(repo / "mneme/kernel0/identity.lisp")
    m = re.search(r"\(defun %identity-domain-p\s*\(domain\)\s*\(member\s+domain\s*'\((.*?)\)\s*:test",
                  src, re.S)
    return re.findall(r":([a-z][a-z-]+)", m.group(1))


def extract_conditions(repo):
    """[(name, family_section)] in definition order, from the family macro blocks."""
    conds = []
    in_fam = False
    depth = 0
    section = "unfiled"
    for ln in read(repo / "mneme/kernel0/conditions.lisp").splitlines():
        sm = SECTION_RE.match(ln)
        if sm and not in_fam:
            section = sm.group(1)
        if re.match(r"^\(%define-kernel0-condition-family\s*$", ln):
            in_fam, depth = True, 1
            continue
        if in_fam:
            depth += ln.count("(") - ln.count(")")
            nm = NAME_RE.match(ln)
            if nm:
                conds.append((nm.group(1), section))
            if depth <= 0:
                in_fam = False
    return conds


def extract_signal_sites(repo, names):
    """Multiline-aware: (signal-kernel0\\n  'name ...). Excludes conditions.lisp."""
    sites = {n: [] for n in names}
    selftest_refs = {n: 0 for n in names}
    for f in sorted((repo / "mneme/kernel0").glob("*.lisp")):
        if f.name == "conditions.lisp":
            continue
        text = f.read_text(encoding="utf-8")
        if f.name == "kernel0-selftest.lisp":
            for n in names:
                selftest_refs[n] += len(re.findall(r"\b%s\b" % re.escape(n), text))
            continue
        for n in names:
            for m in re.finditer(r"signal-kernel0\s+'%s\b" % re.escape(n), text):
                line = text.count("\n", 0, m.start()) + 1
                sites[n].append({"file": f"mneme/kernel0/{f.name}", "line": line})
    return sites, selftest_refs


def extract_event_types(repo):
    src = read(repo / "mneme/kernel0/folds.lisp")
    m = re.search(r"\+kernel0-event-types\+\s*'\((.*?)\)", src, re.S)
    declared = sorted(set(re.findall(r":([a-z][a-z0-9-]+)", m.group(1))))
    usage = {}
    files = list((repo / "mneme/kernel0").glob("*.lisp"))
    for e in declared:
        total = 0
        for f in files:
            total += len(re.findall(":%s" % re.escape(e), f.read_text(encoding="utf-8")))
        usage[e] = total - 1  # subtract the declaration occurrence
    return declared, usage


def extract_roles(repo):
    src = read(repo / "mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md")
    m = re.search(r"### 5\.2 Initial role vocabulary.*?```lisp(.*?)```", src, re.S)
    return re.findall(r":([a-z][a-z0-9-]+)", m.group(1))


def extract_laws(repo):
    src = read(repo / "mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md")
    return [{"id": "L%s" % n, "title": t.strip()}
            for n, t in re.findall(r"### L(\d+) — (.+)", src)]


def extract_requirement_ids(repo):
    spec = read(repo / "mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md")
    f_tags = sorted(set(re.findall(r"\[F: ([A-Z]+-[0-9]+)\]", spec)))
    k0e_base, k0e_qualified, k0e_ranges = set(), set(), set()
    texts = [read(repo / "mneme/kernel0/README.md")]
    errata = repo / "mneme/architecture/kernel-0-errata"
    if errata.is_dir():
        texts += [p.read_text(encoding="utf-8") for p in errata.rglob("*.md")]
    for text in texts:
        for m in re.finditer(r"K0E-\d+[a-z]?(?:/[A-Za-z0-9-]+)*", text):
            tok = m.group(0)
            base = re.match(r"K0E-\d+[a-z]?", tok).group(0)
            k0e_base.add(base)
            rest = tok[len(base):]
            if rest:
                # alpha suffix => qualified clause identity; numeric => range notation
                if re.fullmatch(r"(?:/[a-z][a-z0-9-]*)+", rest):
                    k0e_qualified.add(tok)
                else:
                    k0e_ranges.add(tok)

    def key(x):
        mm = re.match(r"K0E-(\d+)([a-z]?)", x)
        return (int(mm.group(1)), mm.group(2), x)
    return {
        "F-tags": f_tags,
        "K0E-base": sorted(k0e_base, key=key),
        "K0E-qualified": sorted(k0e_qualified, key=key),
        "K0E-range-notations": sorted(k0e_ranges, key=key),
    }


def main():
    repo = Path(sys.argv[1]).resolve()
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else None

    commit = subprocess.run(["git", "-C", str(repo), "rev-parse", "HEAD"],
                            capture_output=True, text=True).stdout.strip() or "unknown"

    domains = extract_identity_domains(repo)
    cond_pairs = extract_conditions(repo)
    names = [n for n, _ in cond_pairs]
    fam = dict(cond_pairs)
    sites, selftest_refs = extract_signal_sites(repo, names)
    declared_events, event_usage = extract_event_types(repo)
    roles = extract_roles(repo)
    laws = extract_laws(repo)
    req = extract_requirement_ids(repo)

    conditions = []
    for n in names:
        if sites[n]:
            status = "textually-signaled"
        elif selftest_refs[n]:
            status = "textually-test-only"
        else:
            status = "textually-dormant"
        conditions.append({
            "name": n, "family": fam[n], "status": status,
            "signal-sites": sites[n], "selftest-refs": selftest_refs[n],
        })

    inventory = {
        "inventory-version": 1,
        "analysis-kind": "lexical-static-inventory",
        "limitations": LIMITATIONS,
        "patterns": PATTERNS,
        "source": {"repo": "Wondermonger-daydreaming/latent-lisp", "commit": commit},
        "identity-domains": {"count": len(domains), "domains": domains},
        "conditions": {
            "count": len(conditions),
            "base": "kernel0-condition",
            "textually-signaled": sum(1 for c in conditions if c["status"] == "textually-signaled"),
            "textually-test-only": sum(1 for c in conditions if c["status"] == "textually-test-only"),
            "textually-dormant": sum(1 for c in conditions if c["status"] == "textually-dormant"),
            "types": conditions,
        },
        "event-types": {
            "count": len(declared_events),
            "declared-only": sorted(e for e, c in event_usage.items() if c == 0),
            "types": [{"name": e, "usage-count": event_usage[e],
                       "status": "textually-referenced" if event_usage[e] else "declared-only"}
                      for e in declared_events],
        },
        "roles": {"count": len(roles), "roles": roles},
        "laws": {"count": len(laws), "laws": laws},
        "requirement-ids": req,
    }

    text = json.dumps(inventory, indent=2, ensure_ascii=False) + "\n"
    if out:
        out.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)

    c = inventory["conditions"]
    print(f"commit: {commit}", file=sys.stderr)
    print(f"identity domains: {len(domains)}", file=sys.stderr)
    print(f"conditions: {c['count']} ({c['textually-signaled']} textually-signaled, "
          f"{c['textually-test-only']} textually-test-only, "
          f"{c['textually-dormant']} textually-dormant)", file=sys.stderr)
    print(f"event types: {len(declared_events)} "
          f"(declared-only: {len(inventory['event-types']['declared-only'])})", file=sys.stderr)
    print(f"roles: {len(roles)}  laws: {len(laws)}", file=sys.stderr)
    print(f"requirement ids: {len(req['F-tags'])} F-tags, {len(req['K0E-base'])} K0E-base, "
          f"{len(req['K0E-qualified'])} K0E-qualified, "
          f"{len(req['K0E-range-notations'])} range notations", file=sys.stderr)


if __name__ == "__main__":
    main()
