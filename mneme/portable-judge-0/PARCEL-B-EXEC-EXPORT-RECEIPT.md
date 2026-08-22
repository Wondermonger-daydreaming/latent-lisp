# PARCEL B EXECUTION RETURN — EXPORT RECEIPT (2026-08-10)

*Chair: Claude Fable 5. Filed on `many-acts-0-candidate`. This receipt records
custody and chair audit of the sealed parcel; it adopts nothing and earns no
evidence. The return awaits owner disposition.*

## Provenance — crash and reconstruction

The first execution attempt died with the chair's process (host volume
exhaustion → WSL EROFS → stop-hook save failure → Bun bus error) and left
**zero bytes on disk**: branch `ma0-parcel-b-exec` had no commits, its worktree
was git-clean, and no dangling object contained execution content (recovery
inventory in the campaign log, commit `4ea6288b`). This return is a **full
reconstruction from Owner Ruling 6 alone**, by a fresh hand (agent LICTOR,
Claude Opus), not a salvage.

## Parcel identity

| Field | Value |
|---|---|
| File | `~/Downloads/ma0-parcel-b-exec-2026-08-10.tar.gz` |
| Outer SHA-256 | `26f8ba23778e3e38e7e26f1ad47323eabad3cef35a76c5e8dddb67e45cfc3c7c` |
| Size | `114,975` bytes |
| Manifest | 23/23 payload hashes green on extraction round-trip; manifest excludes itself (0 self-references) |
| Branch / tip | `ma0-parcel-b-exec` @ `3af17e51093a8ca4b83be2386c9b96dce52103ff` |
| Base | `48e59db311888b7b1b123289477a923a54689963` (the Ruling-6 integration merge) |
| Diff shape | 12 modified + 10 added, all inside `language-many-acts-0/` |

## Chair audit (performed this session, commands run by the chair)

- **Diff confinement:** exhaustive `--name-status` over `48e59db3..3af17e51`
  shows only the 22 intended paths; no filed ruling, no `parcel-b/` filing, no
  frozen capture appears — the byte-untouched proof at diff level (traced via
  exhaustive name-status; per-file hash tables in the return's §8).
- **B3:** live `r1/capture.sh` prints `TESTS WHETHER:` with the divergence
  disclosed in its header; the ten frozen captures
  (`r1/pre-repair/D1–D5-red.txt`, `r1/post-repair/D1–D5-green.txt`) all retain
  `PROVES` and sit outside the diff.
- **B4:** `MANY-ACTS-0-SUPERSESSIONS.md` exists, append-only by declaration,
  exactly S-1…S-5 covering the ruling's ordered minimum (159→200, 9→15,
  72→126, 5→6 controls clean, B3 label divergence), each entry naming artifact,
  locus, statement as written, governing instrument, current statement.
- **B1:** the guide's scoped replacement clause present **verbatim** (match
  found flattened — soft-wrap; the A-R1.1 grep scar honored);
  `MANY-ACTS-0-STANDING.md` carries the identity-and-disposition standing rule.
- **B5:** grammar distinguishes OBSERVABLE (12 codes, 65 emission sites) from
  UMBRELLA (`V-ATOMS` sole umbrella, never emitted); V-RES-AUTH counts split
  mechanically (1 emission site / 3 code occurrences / prose references
  counted at quote time).
- **B6:** the pressure-report matcher sentence amended to "informed by similar
  principles… claiming no equivalence"; remaining `mirrors Surface /2` strings
  live only in the frozen B6 proposal filing, which is correctly byte-untouched.
- **Gates (serial readback, §4/§5.1):** selftest `200/0` · teeth `15/15` ·
  P3 `11/0` · P4 `11/0` **as a rerun only** (transcript exit line carries the
  disclaimer) · One Act `173/0`. A first teeth run REFUSED honestly
  (checkout-quiescence guard tripped by the return doc appearing mid-flight);
  the red transcript is preserved as
  `parcel-b-exec/gates/03-teeth-RED-checkout-changed.txt` and disclosed in
  return §9.1. No expectation weakened.

## Flagged for owner attention (disclosed choices, not defects)

1. **B1 scope call** (return §3.4(2), `MANY-ACTS-0-STANDING.md` §5): banners
   repaired on the 11 artifacts carrying a false standing claim; 23 live-tool
   headers reading "CANDIDATE. Running a candidate is not adopting it" left
   byte-untouched as true and standing-free.
2. **Five adopted-base sources became candidate successors by comment-only
   change** (return §3.4(1), ★ in §8.2) — the exact phenomenon Ruling 6 §3 B1
   named.
3. **Two B6-adjacent residues deliberately left** (return §7): the grammar's
   value-vocabulary sentence about Surface /2's published sets, and
   `ma0-eval.lisp:101` ("mirrored over PUBLIC readers" — grammar-into-code,
   not cross-lane). Neither is the matcher claim.

## Standing

CANDIDATE. Same-author evidence. **Evidence earned: ZERO.** Nothing
independently verified or validated; no portability, independence, or
conformance claim; stranger audit remains OWED. B7 untouched — the MA0 Export
Census /0 is a separate return under its own receipt, never bundled with this
one. S-freeze not reached.

— Claude Fable 5, chair
