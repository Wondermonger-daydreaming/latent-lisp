#!/usr/bin/env python3
"""inventory-check.py — verify the STATIC probe source inventory. Nothing else.

    python3 mneme/integration-baseline-0/inventory-check.py
    python3 mneme/integration-baseline-0/inventory-check.py --forbid-external-fs
    python3 mneme/integration-baseline-0/inventory-check.py --controls

WHY THE EXECUTABLE CENSUS IS GONE
---------------------------------
R1..R4 kept rebuilding a machine that ran twenty-eight historical probes and
reported what they did. Each round the instrument got sharper and the object
stayed wrong. The apparatus was retired by ruling, not repaired again, because
being right would have required three things this lane has no business owning:

  - a Common Lisp MERGE-PATHNAMES evaluator (a `defaults` that is a FILE
    pathname contributes its name and type, and `%as-directory` strips them
    again before any I/O — so the raw pathname value and the effective I/O
    directory are DIFFERENT FACTS, and R4 counted the intermediate as a
    dependency);
  - dynamic dependency analysis (P7-intern-reach.lisp builds five of its
    filenames at run time, so they were invisible to every static extractor
    R1..R4 wrote, and the "exhaustive attempted-subject cardinality" those
    rounds published was never exhaustive);
  - a two-host observation model (R4's "portable" ledger embedded the builder's
    absolute paths, and its HOST-BOUND flag was decided by whether a directory
    happened to exist on the machine doing the REVIEWING).

Those probes are historical, they sit outside the release floor, and they
describe a tree that no longer exists. So this file replaces the census with the
smallest thing that is simply true.

WHAT THIS CHECKER MAY DO — the complete list, and it is short
------------------------------------------------------------
  1. exactly 28 path/hash identities, against the frozen universe AND the disk
  2. exactly one category per path
  3. category totals: CHAIR-MISSING-LOAD 5, HOST-BOUND-SOURCE 23
  4. each locator/snippet still matches the hashed source
  5. CHAIR missing-load targets are absent INSIDE the exact checkout
  6. HOST-BOUND-SOURCE is established SYNTACTICALLY, by an absolute path token
     written in the hashed source text — never by a filesystem query

WHAT IT MUST NOT DO, enforced rather than promised
--------------------------------------------------
It does not emulate MERGE-PATHNAMES, does not reconstruct execution, and does
not inspect historical external trees. Every filesystem access goes through one
guard that refuses any path outside SUBJECT_ROOT and counts the attempt.
`--forbid-external-fs` turns that refusal into an immediate failure, so the
"no external queries" property is demonstrated rather than asserted.

SUBJECT_ROOT is derived from this file's own location, so the checker is
relocatable: it passes identically from any checkout directory, under any name.
"""

import hashlib
import os
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
SUBJECT_ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
INVENTORY = os.path.join(HERE, "PROBE-SOURCE-INVENTORY.tsv")
FROZEN = os.path.join(HERE, "PROBE-CENSUS-PATHS.txt")

UNIVERSE = 28
CATEGORIES = {"CHAIR-MISSING-LOAD": 5, "HOST-BOUND-SOURCE": 23}
COLS = ["path", "file_sha256", "category", "locator", "line_sha256_32",
        "evidence_literal", "chair_target_relpath"]

EXTERNAL_ATTEMPTS = []


# ---------------------------------------------------------------------------
# THE ONE FILESYSTEM GUARD
# ---------------------------------------------------------------------------
def inside(path, forbid):
    """True if `path` is inside SUBJECT_ROOT. Records and optionally refuses."""
    p = os.path.abspath(path)
    ok = p == SUBJECT_ROOT or p.startswith(SUBJECT_ROOT + os.sep)
    if not ok:
        EXTERNAL_ATTEMPTS.append(p)
        if forbid:
            raise SystemExit(f"!! EXTERNAL FILESYSTEM ACCESS REFUSED: {p}")
    return ok


def sread(rel, forbid):
    p = os.path.join(SUBJECT_ROOT, rel)
    if not inside(p, forbid):
        return None
    with open(p, "rb") as fh:
        return fh.read()


def sexists(rel, forbid):
    p = os.path.join(SUBJECT_ROOT, rel)
    if not inside(p, forbid):
        return None                      # never answered from outside the tree
    return os.path.exists(p)


def read_tsv(path):
    with open(path, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    if not lines:
        return None, ["E-SCHEMA inventory is empty"]
    if lines[0].split("\t") != COLS:
        return None, [f"E-SCHEMA header {lines[0].split(chr(9))} != {COLS}"]
    rows, v = [], []
    for i, ln in enumerate(lines[1:], start=2):
        if not ln.strip():
            continue
        f = ln.split("\t")
        if len(f) != len(COLS):
            v.append(f"E-SCHEMA line {i}: {len(f)} fields, expected {len(COLS)}")
            continue
        rows.append(dict(zip(COLS, f)))
    return rows, v


# ---------------------------------------------------------------------------
# THE SIX CHECKS
# ---------------------------------------------------------------------------
def check(inventory=INVENTORY, frozen=FROZEN, forbid=False, quiet=False):
    say = (lambda *a: None) if quiet else print
    v = []
    del EXTERNAL_ATTEMPTS[:]

    say("=" * 75)
    say(" PROBE SOURCE INVENTORY — STATIC CHECK")
    say("=" * 75)
    say(f"\n  SUBJECT_ROOT : {SUBJECT_ROOT}")
    say(f"  external filesystem queries : {'FORBIDDEN' if forbid else 'guarded'}")

    rows, errs = read_tsv(inventory)
    v += errs
    if rows is None:
        return v

    frozen_map = {}
    with open(frozen, encoding="utf-8") as fh:
        for ln in fh:
            if ln.startswith("#") or not ln.strip():
                continue
            sha, p = ln.split(None, 1)
            frozen_map[p.strip()] = sha

    # --- 1  path / hash identity -------------------------------------------
    if len(rows) != UNIVERSE:
        v.append(f"E-COUNT inventory has {len(rows)} rows, expected {UNIVERSE}")
    if len(frozen_map) != UNIVERSE:
        v.append(f"E-COUNT frozen universe has {len(frozen_map)}, expected {UNIVERSE}")
    inv_paths = [r["path"] for r in rows]
    if sorted(inv_paths) != sorted(frozen_map):
        only_i = sorted(set(inv_paths) - set(frozen_map))
        only_f = sorted(set(frozen_map) - set(inv_paths))
        v.append(f"E-PATHSET inventory != frozen universe "
                 f"(only-inventory={only_i[:2]}, only-frozen={only_f[:2]})")
    bad = 0
    for r in rows:
        if frozen_map.get(r["path"]) and frozen_map[r["path"]] != r["file_sha256"]:
            v.append(f"E-HASH {r['path']}: inventory hash != frozen universe")
            bad += 1
        blob = sread(r["path"], forbid)
        if blob is None:
            v.append(f"E-HASH {r['path']}: unreadable inside SUBJECT_ROOT")
            bad += 1
            continue
        if hashlib.sha256(blob).hexdigest() != r["file_sha256"]:
            v.append(f"E-HASH {r['path']}: inventory hash != file on disk")
            bad += 1
    say(f"\n  [1] path/hash identities     : {len(rows)-bad}/{len(rows)} "
        f"agree with the frozen universe AND the disk")

    # --- 2  exactly one category per path -----------------------------------
    seen = {}
    for r in rows:
        seen.setdefault(r["path"], set()).add(r["category"])
    for p, c in seen.items():
        if len(c) != 1:
            v.append(f"E-CATEGORY {p}: {len(c)} categories {sorted(c)}")
    for r in rows:
        if r["category"] not in CATEGORIES:
            v.append(f"E-CATEGORY {r['path']}: unknown category {r['category']!r}")
    if len(seen) != len(rows):
        v.append(f"E-CATEGORY {len(rows)} rows over {len(seen)} distinct paths — "
                 f"a path may appear exactly once")
    say(f"  [2] one category per path    : {len(seen)} distinct paths, "
        f"{len(rows)} rows")

    # --- 3  category totals -------------------------------------------------
    tally = {}
    for r in rows:
        tally[r["category"]] = tally.get(r["category"], 0) + 1
    say("  [3] category totals          :")
    for k in sorted(CATEGORIES):
        got = tally.get(k, 0)
        say(f"        {k:<22} {got}   (expected {CATEGORIES[k]})")
        if got != CATEGORIES[k]:
            v.append(f"E-TOTAL {k} is {got}, expected {CATEGORIES[k]}")

    # --- 4  locator / snippet still matches the hashed source ---------------
    bad4 = 0
    for r in rows:
        blob = sread(r["path"], forbid)
        if blob is None:
            continue
        lines = blob.decode("utf-8", errors="replace").splitlines()
        if not r["locator"].startswith("line") or not r["locator"][4:].isdigit():
            v.append(f"E-LOCATOR {r['path']}: malformed locator {r['locator']!r}")
            bad4 += 1
            continue
        n = int(r["locator"][4:])
        if n < 1 or n > len(lines):
            v.append(f"E-LOCATOR {r['path']}: {r['locator']} out of range "
                     f"(file has {len(lines)} lines)")
            bad4 += 1
            continue
        ln = lines[n - 1]
        if hashlib.sha256(ln.encode("utf-8")).hexdigest()[:32] != r["line_sha256_32"]:
            v.append(f"E-SNIPPET {r['path']} {r['locator']}: line hash != recorded")
            bad4 += 1
            continue
        if r["evidence_literal"] not in ln:
            v.append(f"E-SNIPPET {r['path']} {r['locator']}: evidence literal "
                     f"not present in the recorded line")
            bad4 += 1
    say(f"  [4] locator/snippet vs source: {len(rows)-bad4}/{len(rows)} still match")

    # --- 5  CHAIR targets absent inside the exact checkout ------------------
    # A pure NON-EXISTENCE test on a path recorded as static evidence. No
    # pathname algebra is performed here; the relpath was read off the source
    # once, is frozen in the inventory, and is re-checked only for absence.
    chair = [r for r in rows if r["category"] == "CHAIR-MISSING-LOAD"]
    present = 0
    for r in chair:
        t = r["chair_target_relpath"]
        if t in ("", "n/a"):
            v.append(f"E-CHAIR {r['path']}: no recorded target relpath")
            continue
        if os.path.isabs(t) or t.startswith(".."):
            v.append(f"E-CHAIR {r['path']}: recorded target escapes SUBJECT_ROOT: {t}")
            continue
        ex = sexists(t, forbid)
        if ex:
            present += 1
            v.append(f"E-CHAIR {r['path']}: target EXISTS inside this checkout "
                     f"({t}) — the missing-load category no longer holds")
    # the stronger, semantics-free form of the same fact
    extract_dirs = []
    for dirpath, dirnames, _ in os.walk(SUBJECT_ROOT):
        if "extract" in dirnames:
            extract_dirs.append(os.path.join(dirpath, "extract"))
    if extract_dirs:
        v.append(f"E-CHAIR an 'extract' directory exists inside this checkout: "
                 f"{extract_dirs[0]}")
    say(f"  [5] CHAIR targets absent     : {len(chair)-present}/{len(chair)} absent; "
        f"'extract' directories in tree: {len(extract_dirs)}")

    # --- 6  HOST-BOUND established SYNTACTICALLY ----------------------------
    # The evidence is a token WRITTEN IN THE SOURCE. It is never resolved,
    # stat-ed, or opened. That is the whole point: R4 decided this flag by
    # asking the reviewing host whether a directory happened to exist.
    hb = [r for r in rows if r["category"] == "HOST-BOUND-SOURCE"]
    bad6 = 0
    for r in hb:
        lit = r["evidence_literal"]
        if not (lit.startswith("/home/") or lit.startswith("/tmp/")):
            v.append(f"E-HOSTBOUND {r['path']}: evidence literal is not an "
                     f"absolute source reference: {lit!r}")
            bad6 += 1
        if r["chair_target_relpath"] != "n/a":
            v.append(f"E-HOSTBOUND {r['path']}: must not carry a CHAIR target")
            bad6 += 1
    say(f"  [6] HOST-BOUND syntactic     : {len(hb)-bad6}/{len(hb)} carry an "
        f"absolute path token written in the hashed source")

    say(f"\n  external filesystem accesses attempted : {len(EXTERNAL_ATTEMPTS)}")
    if EXTERNAL_ATTEMPTS:
        v.append(f"E-EXTERNAL {len(EXTERNAL_ATTEMPTS)} access(es) outside "
                 f"SUBJECT_ROOT, first {EXTERNAL_ATTEMPTS[0]}")
    return v


# ---------------------------------------------------------------------------
# EXACTLY FOUR BOUNDED CONTROLS. No further census teeth.
# ---------------------------------------------------------------------------
def relocate(dest):
    """Copy the checked surface into a differently named root."""
    os.makedirs(os.path.join(dest, "mneme/integration-baseline-0"), exist_ok=True)
    shutil.copytree(os.path.join(SUBJECT_ROOT, "mneme/language-surface-1"),
                    os.path.join(dest, "mneme/language-surface-1"),
                    symlinks=True)
    for f in ("PROBE-CENSUS-PATHS.txt", "PROBE-SOURCE-INVENTORY.tsv",
              "inventory-check.py"):
        shutil.copyfile(os.path.join(HERE, f),
                        os.path.join(dest, "mneme/integration-baseline-0", f))
    return os.path.join(dest, "mneme/integration-baseline-0/inventory-check.py")


def run_at(script, *args):
    r = subprocess.run([sys.executable, script, *args],
                       capture_output=True, text=True)
    return r.returncode, r.stdout + r.stderr


def controls():
    print("=" * 75)
    print(" INVENTORY CHECKER — FOUR BOUNDED CONTROLS")
    print("=" * 75)

    base = check(quiet=True)
    print(f"\n  BASELINE: untouched inventory -> {len(base)} violation(s)")
    if base:
        print("  !! GATE REFUSED: controls may not run over a failing baseline.")
        for x in base[:8]:
            print(f"       {x}")
        return 1
    print("  gate open.\n")

    results = []
    tmp = tempfile.mkdtemp(prefix="inv-controls.")
    try:
        # K1 — two DIFFERENTLY NAMED fresh checkouts must both pass.
        outs = []
        for name in ("alpha-checkout", "zzz_second_root"):
            dest = os.path.join(tmp, name)
            script = relocate(dest)
            rc, out = run_at(script)
            outs.append((name, rc))
        ok1 = all(rc == 0 for _, rc in outs)
        results.append(("K1 pass from two differently named checkouts", ok1,
                        "; ".join(f"{n} exit {rc}" for n, rc in outs)))

        # K2 — must pass while external filesystem queries are FORBIDDEN.
        rc, out = run_at(os.path.abspath(__file__), "--forbid-external-fs")
        ok2 = rc == 0 and "attempted : 0" in out
        results.append(("K2 pass with external filesystem forbidden", ok2,
                        f"exit {rc}, "
                        f"{'0 external attempts' if 'attempted : 0' in out else 'external attempts NOT zero'}"))

        # K3 — one path/hash mutation must be REJECTED.
        mut = os.path.join(tmp, "K3.tsv")
        lines = open(INVENTORY, encoding="utf-8").read().splitlines()
        f = lines[1].split("\t"); f[1] = "0" * 64
        open(mut, "w", encoding="utf-8").write(
            "\n".join([lines[0], "\t".join(f)] + lines[2:]) + "\n")
        vi = check(inventory=mut, quiet=True)
        ok3 = any(x.startswith("E-HASH") for x in vi)
        results.append(("K3 reject a path/hash mutation", ok3,
                        next((x for x in vi if x.startswith("E-HASH")), "(no E-HASH)")))

        # K4 — one category / evidence-locator mutation must be REJECTED.
        mut = os.path.join(tmp, "K4.tsv")
        # Pick the locator victim DYNAMICALLY: a row whose locator is not
        # already line1, so the mutation genuinely moves it off its snippet.
        # (Chosen after a hardcoded index silently mutated nothing — a control
        # that changes nothing cannot bite, and would have read as a pass.)
        victim = next(i for i, ln in enumerate(lines[1:])
                      if i != 0 and ln.split("\t")[3] != "line1")
        out_lines = [lines[0]]
        for i, ln in enumerate(lines[1:]):
            f = ln.split("\t")
            if i == 0:                       # a CHAIR row -> claim HOST-BOUND
                f[2] = "HOST-BOUND-SOURCE"
            if i == victim:                  # move a locator off its snippet
                f[3] = "line1"
            out_lines.append("\t".join(f))
        open(mut, "w", encoding="utf-8").write("\n".join(out_lines) + "\n")
        vi = check(inventory=mut, quiet=True)
        ok4 = (any(x.startswith("E-TOTAL") for x in vi)
               and any(x.startswith("E-SNIPPET") for x in vi))
        results.append(("K4 reject a category/locator mutation", ok4,
                        "; ".join([next((x for x in vi if x.startswith("E-TOTAL")), "(no E-TOTAL)"),
                                   next((x for x in vi if x.startswith("E-SNIPPET")), "(no E-SNIPPET)")])))
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    bad = 0
    for name, ok, detail in results:
        if ok:
            print(f"  {name:<50} OK")
        else:
            bad += 1
            print(f"  {name:<50} !! FAILED")
        print(f"      -> {detail}")
    print()
    if bad:
        print(f" CONTROLS FAILED: {bad} of {len(results)}.")
        return 1
    print(f" All {len(results)} controls behaved over a clean baseline.")
    return 0


def main():
    if "--controls" in sys.argv:
        return controls()
    forbid = "--forbid-external-fs" in sys.argv
    v = check(forbid=forbid)
    print()
    print("=" * 75)
    if v:
        print(f" INVENTORY CHECK: FAIL — {len(v)} violation(s)")
        for x in v:
            print(f"   {x}")
        return 1
    print(" INVENTORY CHECK: PASS")
    print(" Twenty-eight static rows, two categories, every locator still on its")
    print(" hashed line. No execution was reconstructed and no path outside this")
    print(" checkout was consulted.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
