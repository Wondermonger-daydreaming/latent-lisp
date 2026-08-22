#!/usr/bin/env python3
"""Derive the cross-lane status legend from its authoritative sources.

Implements the generator required by clause C.3 of
`RULING-R0.19-OWNER-DISPOSITION-INSTRUMENT-0-ADOPTED-2026-08-12.md`
(Languagehood & Succession Charter /0).

Governing properties, in the ruling's terms:

  * The legend is a DERIVED constitutional index, not a source of standing.
  * It records standing conferred elsewhere and by whom; it confers nothing.
  * Where it conflicts with an originating instrument, the originating
    instrument wins automatically and the legend is defective until re-derived.
  * Re-derived, never hand-edited.
  * Generation source named and inspectable (this file; the registry).
  * A generation or readback failure BLOCKS reliance; it never alters
    underlying standing.

Design: deterministic and fail-closed.

  * No timestamps, no randomness, no environment leakage, no dict-order
    dependence. Rows are sorted by `id`; hashed instruments are sorted by path.
  * Every registry entry's `verbatim_anchor` must be a literal substring of its
    `standing_instrument`; the entry's `instrument_role` states the
    instrument's relationship to the standing. Only `confers` rows identify a
    conferring instrument; other roles (rules-status, constrains,
    refusal-ground, closure-record) name the owner act on which a
    non-conferred status rests. ANY failure -> diagnostics on stderr, exit 2,
    and NOTHING is written (a pre-existing output file is left untouched).
  * `generation_date` must be a real proleptic-Gregorian calendar date
    serialized exactly as YYYY-MM-DD (validated via datetime.date, correct
    leap years, no clock read); invalid dates fail closed.
  * The rendered output is checked against the terminology invariant: no
    non-`confers` row may be described as naming a "conferring instrument".
  * Output is assembled entirely in memory and written once, last.

Usage:
    python3 generate_legend.py [--registry PATH] [--output PATH]
                               [--repo-root PATH] [--check-only]

Exit codes: 0 = generated (or --check-only passed); 2 = verification failed.
"""

from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
# legend/ -> charter-0/ -> mneme/ -> latent-lisp/ -> experiments/ -> repo root
DEFAULT_REPO_ROOT = Path(__file__).resolve().parents[5]
DEFAULT_REGISTRY = HERE / "legend-sources.json"
DEFAULT_OUTPUT = HERE / "STATUS-LEGEND-GENERATED.md"

ALLOWED_STATUSES = (
    "ADOPTED LAW",
    "ACCEPTED EVIDENCE",
    "PROPOSED HOLDING",
    "OPEN",
    "REFUSED CLAIM",
    "HISTORICAL",
)

MIN_ANCHOR_CHARS = 40

ALLOWED_ROLES = (
    "confers",
    "rules-status",
    "constrains",
    "refusal-ground",
    "closure-record",
)

DATE_FORMAT_HELP = "generation_date must be an ISO date 'YYYY-MM-DD' (explicit controlled datum, never a clock read)"

DISCLAIMERS = (
    "This legend is a derived constitutional index. It records where standing "
    "was conferred and by whom; it confers none. Where it conflicts with an "
    "originating instrument, the originating instrument wins automatically and "
    "this legend is defective until re-derived. Re-derived, never hand-edited."
)

REQUIRED_FIELDS = ("id", "proposition", "status", "standing_instrument",
                   "verbatim_anchor", "instrument_role")


def validate_iso_date(value: str) -> bool:
    """Strict 'YYYY-MM-DD' shape + REAL proleptic-Gregorian calendar validity.

    Shape first (exactly 10 chars, zero-padded, digit fields, '-' separators),
    then `datetime.date(y, m, d)` decides calendar validity — correct month
    lengths and leap-year behavior (2028-02-29 valid; 2026-02-29, 2026-02-31,
    2026-04-31 invalid). Deterministic; consults no clock."""
    if not isinstance(value, str) or len(value) != 10:
        return False
    if value[4] != "-" or value[7] != "-":
        return False
    y, m, d = value[:4], value[5:7], value[8:10]
    if not (y.isdigit() and m.isdigit() and d.isdigit()):
        return False
    try:
        datetime.date(int(y), int(m), int(d))
    except ValueError:
        return False
    return True


class Failure(Exception):
    """A fail-closed verification failure. Carries (entry_id, reason)."""

    def __init__(self, entry_id: str, reason: str) -> None:
        super().__init__(f"{entry_id}: {reason}")
        self.entry_id = entry_id
        self.reason = reason


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_registry(registry_path: Path) -> tuple[list[dict], dict]:
    try:
        raw = registry_path.read_text(encoding="utf-8")
    except OSError as exc:
        raise Failure("<registry>", f"cannot read registry {registry_path}: {exc}") from exc
    try:
        doc = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise Failure("<registry>", f"registry is not valid JSON: {exc}") from exc
    entries = doc.get("entries")
    if not isinstance(entries, list) or not entries:
        raise Failure("<registry>", "registry has no non-empty 'entries' array")
    # C.3.5 date requirement: explicit controlled datum, validated, fail-closed.
    date = doc.get("generation_date")
    if not validate_iso_date(date):
        raise Failure("<registry>", f"missing or malformed 'generation_date' ({date!r}); {DATE_FORMAT_HELP}")
    denotes = doc.get("generation_date_denotes")
    if not isinstance(denotes, str) or not denotes.strip():
        raise Failure("<registry>", "missing or empty 'generation_date_denotes' (the date's meaning must be recorded)")
    meta = {"generation_date": date, "generation_date_denotes": denotes.strip()}
    return entries, meta


def verify(entries: list[dict], repo_root: Path) -> tuple[list[dict], dict[str, str]]:
    """Verify every entry. Raises Failure on the first defect found.

    Returns (rows sorted by id, {instrument_path: sha256}).
    """
    seen_ids: set[str] = set()
    hashes: dict[str, str] = {}

    for index, entry in enumerate(entries):
        if not isinstance(entry, dict):
            raise Failure(f"<entry #{index}>", "entry is not a JSON object")
        entry_id = entry.get("id") or f"<entry #{index}>"

        for field in REQUIRED_FIELDS:
            value = entry.get(field)
            if not isinstance(value, str) or not value.strip():
                raise Failure(entry_id, f"missing or empty required field '{field}'")

        if entry_id in seen_ids:
            raise Failure(entry_id, "duplicate id in registry")
        seen_ids.add(entry_id)

        status = entry["status"]
        if status not in ALLOWED_STATUSES:
            raise Failure(
                entry_id,
                f"status {status!r} is outside the adopted vocabulary "
                f"({', '.join(ALLOWED_STATUSES)})",
            )

        role = entry["instrument_role"]
        if role not in ALLOWED_ROLES:
            raise Failure(
                entry_id,
                f"instrument_role {role!r} is outside the role vocabulary "
                f"({', '.join(ALLOWED_ROLES)})",
            )

        anchor = entry["verbatim_anchor"]
        if len(anchor) < MIN_ANCHOR_CHARS:
            raise Failure(
                entry_id,
                f"verbatim_anchor is {len(anchor)} characters; "
                f"at least {MIN_ANCHOR_CHARS} are required",
            )

        rel = entry["standing_instrument"]
        if rel.startswith("/"):
            raise Failure(entry_id, f"standing_instrument must be repo-relative, got {rel!r}")
        target = repo_root / rel
        if not target.is_file():
            raise Failure(entry_id, f"standing instrument not found: {target}")

        try:
            text = target.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as exc:
            raise Failure(entry_id, f"cannot read standing instrument {target}: {exc}") from exc

        if anchor not in text:
            raise Failure(
                entry_id,
                "verbatim_anchor is NOT a literal substring of "
                f"{rel} (first 60 chars of anchor: {anchor[:60]!r})",
            )

        hashes[rel] = sha256_file(target)

    rows = sorted(entries, key=lambda e: e["id"])
    return rows, hashes


def escape_cell(text: str) -> str:
    """Make a string safe inside a markdown table cell, without losing content."""
    return (
        text.replace("\\", "\\\\")
        .replace("|", "\\|")
        .replace("\r\n", "\\n")
        .replace("\n", "\\n")
        .replace("\r", "\\n")
    )


def status_cell(entry: dict) -> str:
    status = entry["status"]
    sub = entry.get("sub_annotation")
    if isinstance(sub, str) and sub.strip():
        return f"**{status}** _(sub: {sub.strip()})_"
    return f"**{status}**"


def code_span(text: str) -> str:
    """Wrap text in a CommonMark code span whose fence is longer than any
    backtick run inside it, padding when the content touches a backtick."""
    longest = 0
    run = 0
    for ch in text:
        run = run + 1 if ch == "`" else 0
        longest = max(longest, run)
    fence = "`" * (longest + 1)
    pad = " " if text.startswith("`") or text.endswith("`") else ""
    return f"{fence}{pad}{text}{pad}{fence}"


def anchor_cell(anchor: str) -> str:
    head = anchor[:60]
    suffix = "…" if len(anchor) > 60 else ""
    return code_span(escape_cell(head) + suffix)


def render(rows: list[dict], hashes: dict[str, str], registry_rel: str,
           registry_sha: str, generator_rel: str, meta: dict) -> str:
    out: list[str] = []
    a = out.append

    a("# CROSS-LANE STATUS LEGEND — GENERATED, DERIVED, NOT HAND-EDITED")
    a("")
    a("## Generation source and date (header per C.3.5: source and date, named and inspectable)")
    a("")
    a(f"- **Generator:** `{generator_rel}`")
    a(f"- **Registry:** `{registry_rel}`")
    a(f"- **Registry sha256:** `{registry_sha}`")
    a(f"- **Date:** {meta['generation_date']} — denotes: {meta['generation_date_denotes']}")
    a(f"- **Rows:** {len(rows)}")
    a("- **Determinism:** rows sorted by `id`; hashed instruments sorted by path; "
      "no timestamp, no randomness, no environment input.")
    a("- **Authority:** clause C.3 of "
      "`RULING-R0.19-OWNER-DISPOSITION-INSTRUMENT-0-ADOPTED-2026-08-12.md`.")
    a("")
    a("### sha256 of every standing instrument at generation time")
    a("")
    a("| sha256 | standing instrument |")
    a("|---|---|")
    for rel in sorted(hashes):
        a(f"| `{hashes[rel]}` | `{rel}` |")
    a("")
    a("## Standing disclaimers (verbatim, integral to the adoption)")
    a("")
    a(f"> {DISCLAIMERS}")
    a("")
    a("A generation or readback failure blocks updated reliance on this derived "
      "legend; it never alters underlying standing.")
    a("")
    a("## Instrument roles (how each row's instrument relates to its standing)")
    a("")
    a("**`confers`** — the act that created/ratified the standing. **`rules-status`** — "
      "an owner act that determined the current status without conferring content "
      "standing. **`constrains`** — an owner act holding a jurisdiction closed "
      "(OPEN standing itself is an absence of conferral; nothing confers it). "
      "**`refusal-ground`** — the owner act grounding a refusal of a formulation. "
      "**`closure-record`** — the owner act closing a historical record at its ceiling. "
      "Only a `confers` row names a conferring instrument in the strict sense; every "
      "other role names the owner act on which the row's non-conferred status rests.")
    a("")
    a("## Legend")
    a("")
    a("| id | proposition | status | standing instrument (role) | anchor (first 60 chars) |")
    a("|---|---|---|---|---|")
    for entry in rows:
        a(
            "| `{id}` | {prop} | {status} | `{inst}` _({role})_ | {anchor} |".format(
                id=escape_cell(entry["id"]),
                prop=escape_cell(entry["proposition"]),
                status=status_cell(entry),
                inst=escape_cell(entry["standing_instrument"]),
                role=escape_cell(entry["instrument_role"]),
                anchor=anchor_cell(entry["verbatim_anchor"]),
            )
        )
    a("")
    a("## Notes (documentary; the originating instruments govern)")
    a("")
    for entry in rows:
        note = entry.get("note")
        if isinstance(note, str) and note.strip():
            a(f"- **{entry['id']}** — {note.strip()}")
    a("")
    a("## What the anchor verification proves, and what it does not")
    a("")
    a("Each row's anchor was confirmed to be a **literal substring** of the named "
      "standing instrument at generation time, and that instrument's sha256 is "
      "recorded above; the row's role states that instrument's relationship to the "
      "standing, and only `confers` rows identify a conferring instrument. "
      "That establishes **textual presence and file identity only**. "
      "It does **not** establish that the quoted text means what the row's "
      "proposition says, that the proposition is complete, or that the status token "
      "is the right reading of the instrument. Meaning-fidelity remains a reading "
      "duty of the chair and the owner. Where this legend and an originating "
      "instrument disagree, the originating instrument wins automatically.")
    a("")
    return "\n".join(out) + "\n"


def check_terminology(content: str, rows: list[dict]) -> None:
    """Enforce the role-aware provenance-terminology invariant on RENDERED output.

    Invariant: every row names a standing instrument and its role; ONLY rows
    whose role is `confers` may be described as naming a "conferring
    instrument". Mechanically: (1) no rendered legend-table line for a
    non-`confers` row may contain the word "conferring"; (2) any prose line
    containing the phrase "conferring instrument" must be one of the
    allowlisted truthful sentences, recognizable by the explicit scoping
    marker "`confers`" appearing on the same line. Raises Failure (fail-closed)
    on violation."""
    role_by_id = {e["id"]: e["instrument_role"] for e in rows}
    for line in content.splitlines():
        if line.startswith("| `") and line.count("|") >= 5:
            row_id = line.split("`", 2)[1]
            role = role_by_id.get(row_id)
            if role is not None and role != "confers" and "conferring" in line.lower():
                raise Failure(
                    row_id,
                    f"terminology invariant violated: non-'confers' row (role={role!r}) "
                    "is described with 'conferring' in the rendered legend",
                )
        elif "conferring instrument" in line.lower() and "`confers`" not in line:
            raise Failure(
                "<output>",
                "terminology invariant violated: the phrase 'conferring instrument' "
                "appears in rendered prose outside a `confers`-scoped sentence",
            )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--registry", type=Path, default=DEFAULT_REGISTRY)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--repo-root", type=Path, default=DEFAULT_REPO_ROOT)
    parser.add_argument("--check-only", action="store_true",
                        help="verify anchors and write nothing")
    args = parser.parse_args(argv)

    registry_path = args.registry.resolve()
    repo_root = args.repo_root.resolve()

    try:
        entries, meta = load_registry(registry_path)
        rows, hashes = verify(entries, repo_root)
        registry_sha_early = sha256_file(registry_path)
        try:
            registry_rel_early = registry_path.relative_to(repo_root).as_posix()
        except ValueError:
            registry_rel_early = str(registry_path)
        generator_rel_early = Path(__file__).resolve().relative_to(repo_root).as_posix()
        content = render(rows, hashes, registry_rel_early, registry_sha_early,
                         generator_rel_early, meta)
        check_terminology(content, rows)
    except Failure as failure:
        print("LEGEND GENERATION FAILED — fail-closed, nothing written.", file=sys.stderr)
        print(f"  failing id : {failure.entry_id}", file=sys.stderr)
        print(f"  reason     : {failure.reason}", file=sys.stderr)
        print("  effect     : reliance on the derived legend is BLOCKED; "
              "underlying standing is UNCHANGED.", file=sys.stderr)
        return 2

    if args.check_only:
        print(f"CHECK-ONLY: {len(rows)} rows verified; nothing written.")
        return 0

    args.output.write_text(content, encoding="utf-8")
    print(f"GENERATED {args.output} — {len(rows)} rows, "
          f"{len(hashes)} distinct standing instruments.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
