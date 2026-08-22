# PARCEL B EXECUTION RETURN — INTEGRATION RECEIPT (Owner Ruling 6A, 2026-08-10)

*Chair: Claude Fable 5. Filed on `many-acts-0-candidate`. Records the
authentication and integration of the crash-recovered Parcel B execution
return, ACCEPTED WITH DOCUMENTARY RIDERS by Owner Ruling 6A. The return was
neither rebuilt nor resealed; the sealed archive is unchanged.*

## Authentication — 6/6, chair-run from the full lab repository

| # | Ruling 6A condition | Result |
|---|---|---|
| 1 | base `48e59db311888b7b1b123289477a923a54689963` | ✅ exists; tip's sole parent; merge-base identical |
| 2 | tip `3af17e51093a8ca4b83be2386c9b96dce52103ff` + ancestry | ✅ single commit atop base; local = remote branch |
| 3 | exactly the advertised 22 changed/added paths | ✅ counted 22; sealed-archive payload path-set == changed-path set (diff of sorted lists empty) |
| 4 | every resulting blob vs sealed archive | ✅ all 22 `git show tip:path \| cmp` clean against the extraction of `26f8ba23…` (114,975 B; manifest 23/23; zero self-references) |
| 5 | all 86 protected historical paths byte-identical | ✅ chair verified a **94-path superset** (10 frozen captures + all 53 `portable-judge-0/` files at base + 17 `parcel-b/` filings + 3 `r1/*.md` notes + 11 lane historical documents): **SAME=94, DIFFERS=0**, base-blob vs tip-blob per path; additionally the exhaustive diff shows *no* path outside the 22 changed anywhere in the repository, which subsumes any enumeration of the 86 |
| 6 | serial reruns of the five existing gates, expectations unchanged | ✅ chair-run, one at a time, SBCL 2.4.6 operation-checked first: selftest **200/0** · teeth **15 attempted / 0 red / 0 omitted** · P3 **11/0** · P4 **11/0 — A RERUN; the missing first-run exit is not repaired by it** · One Act **173/0**; all exit 0 |

## Integration

* Merge commit: `97a92a84a4c03a1ec6bff98aea9f269cb77c82db` (`--no-ff`,
  second parent `3af17e51`, provenance preserved).
* Post-integration readback: merged lane vs tip lane **zero-line diff**;
  protected 94-path superset re-verified at the merge: SAME=94, DIFFERS=0.

## Governing riders (Owner Ruling 6A, recorded verbatim in substance)

1. **Banner-loci count:** "banner replacements in 9 artifacts" means **eleven
   pre-existing banner loci, plus the two new rule-bearing documents**
   (`MANY-ACTS-0-STANDING.md`, `MANY-ACTS-0-SUPERSESSIONS.md`).
2. **"Identical banner"** means **semantically equivalent standing rule**, not
   byte-identical text.
3. **The exact-blob classification is in execution-return §8.2, not §5.**
4. **The Rider-2 phrase prohibition bars affirmative independent-verification
   characterizations; it is not a ban on quoting or negating those words.**

## What this integration accepts

The B1/B3/B4/B5/B6 implementations as disposed by Ruling 6; the execution
return, standing document, supersession registry, and gate transcripts as
same-author provenance; the crash-recovery reconstruction as the accepted
execution return. It does **not** adopt any unchosen proposal language, and
Owner Rulings 6/6A govern wherever any document differs from their
dispositions.

## Standing

CANDIDATE lane on a candidate branch. **Evidence earned: ZERO.** No
portability, independence, conformance, or affirmative
independent-verification characterization (per Rider 4, this sentence may
negate those words; it may not affirm them). Stranger audit remains OWED.
S-freeze NOT reached; PortJ-F/0, hidden bank, J2 remain closed. The MA0
Export Census /0 R1 is a separate return under its own receipt — never
bundled with this integration.

— Claude Fable 5, chair
