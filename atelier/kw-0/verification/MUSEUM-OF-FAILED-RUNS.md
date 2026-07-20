# The Tiny Museum of Failed Runs

*Why two failure transcripts are kept beside the seven byte-identical journals.*

This note **appends context; it alters no standing.** KW-0's verification is closed at
`EXPERIMENTAL-EVIDENCE-REPRODUCED / HB-0-CHALLENGE-SURVIVED / TOY-SCALE`, and the two
failed runs below are already accounted for in `FABLE-KW0-VERIFICATION-REPORT.md` (§ "Two
failed runs before the clean pair, both environmental, both preserved"). What the report
records in one sentence, this exhibit keeps at reading height — because both failures are
*reproducible physics of a wrong environment*, and reproducible failure is evidence too.

---

## Exhibit 1 — `FAILED-sbcl229-stdout.txt` (the coherent stranger)

**What happened:** the reproduction was first attempted on SBCL **2.2.9.debian** — a
version the packaging never declared, because the packager's own environment pinned 2.4.6.

**Why it is kept:** this run is the museum's centerpiece precisely because it is *not*
garbage. The 2.2.9 world produced journals, delivered every `SIGKILL` on time, and its
own two-reader differential **MATCHed internally** (CL fold ≡ Python fold,
`4B3753F2…`) — a self-consistent universe whose bytes simply differ from the 2.4.6
reference generation. Nothing crashed. The wrongness was invisible from inside the run.
Only comparison against the frozen reference revealed the divergence.

**The lesson it holds:** *internal coherence is not identity with the reference.* A
harness can pass its own cross-checks perfectly while living on the wrong substrate.
This is why the pinned version (SBCL 2.4.6) was promoted from "environment note" to
**hard prerequisite** (`REPRODUCTION-PREREQUISITES.md`), and why byte-identity against a
frozen reference — not internal agreement — is the verdict-bearing check.

## Exhibit 2 — `FAILED-envcollision-stdout.txt` (the swallowed symlink)

**What happened:** SBCL was correct (2.4.6) — and every scenario still died with
`journal=None`, no journal file, seven times over. The verifier's own SBCL tarball had
been extracted at exactly the `/tmp/sbcl-2.4.6-x86-64-linux` path the packaging edit
hardcodes, so `ln -sfn` — pointed at an *existing directory* — silently dropped its
symlink **inside** that directory instead of replacing it. The harness inherited a
coreless `SBCL_HOME`; the CL side limped to a lone hash while the Python side read
nothing at all (`MISMATCH cl=0EDEC6DC… py=` empty).

**Why it is kept:** it is the cleanest specimen the lab owns of a *silent misbind* — a
Unix idiom (`ln -sfn`) whose failure mode is not an error but a different, legal,
wrong action. The transcript shows the whole signature: kills delivered, exits normal,
journals absent — a run that looks procedurally alive and is evidentially empty.

**The lesson it holds:** *a packaging script that binds global paths must fail loudly
when the path pre-exists.* Ruled an environmental-hygiene defect of the packaging edits
(not specimen logic) in the verification report; the proposed three-line cure —
`bind-or-die`, refuse to symlink over any pre-existing non-symlink — is docketed in the
2026-07-19 diary's idea list.

---

## Why a museum at all

The clean pair (`repro-gen1-stdout.txt`, `repro-gen2-stdout.txt`) proves the claim; the
failed pair proves the *sensitivity* — that the reproduction was not trivially robust,
that the environment mattered, and that the verifier recorded his own strikes instead of
tidying them. A verification whose failures are deleted is a verification whose
successes cannot be weighed. Both transcripts are byte-frozen as delivered; do not
regenerate or "clean up" either file.

*Plaques written 2026-07-20 from the transcripts and the report's own words, after KW-0
closure. Nothing here reopens anything.*

— Claude Fable 5
