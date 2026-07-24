# SLICE1-CODEX-STRANGER-CHAIR-VERIFICATION

*Chair: Claude Fable 5 (CC seat), 2026-07-24. Static compliance sweep by LYNX
(Opus 5, 1M — subagent, ledgered), with every load-bearing agent claim
re-verified by the chair's own hand before banking: the `::` grep, the
35-symbol set-diff, the host-escape token sweep, the projection mechanism
lines in `slice0-projection.lisp`, the program's printed result form, and the
D-forge doctrine citation were each independently re-read or re-run by the
chair. All identity, checksum, and live-execution work was chair-hand from the
start.*

**Standing of this delivery: Language Slice /1 stranger CONSTRUCTION and
IMPLEMENTATION evidence. It is NOT a Language Core /0 stranger read and must
never be cited as satisfying that successor pressure.**

## 1. Packet identity — PASS

| Check | Expected | Observed (chair hand) | Verdict |
|---|---|---|---|
| Sidecar SHA-256 | `5daad6f1…5370c7` | identical | PASS |
| Sidecar exact bytes | hash + 2 spaces + filename + final LF | `cat -A`: exactly that, no CR | PASS |
| ZIP byte count | 19531 | 19531 | PASS |
| ZIP SHA-256 | `1f017d38…c76ee1` | identical; `sha256sum -c` OK | PASS |
| Member count | 23 | 23 | PASS |
| Top-level dir | `SLICE1-CODEX-STRANGER-DELIVERY-2026-07-24/` | single, exactly that | PASS |
| `unzip -t` | no errors | "No errors detected" | PASS |
| Internal `SHA256SUMS.txt` | all files | 22/22 OK (excludes itself) | PASS |

Extraction into a fresh isolated directory.

## 2. Pre-reveal integrity — PASS

`PRE-REVEAL-SHA256SUMS.txt` verifies for all three governed artifacts:
`STRANGER-PROGRAM.lisp` (`4b94b26b…`), `RUN-RECEIPT.txt` (`8b693f9c…`),
`IMPLEMENTER-REPORT.md` (`00247423…`). The frozen hashes still hold on the
delivered bytes AND on the source-worktree originals (chair-hashed live at
`/home/gauss/latent-lisp-stranger` — byte-identical). The F1 inconsistency
below is therefore an authorship inconsistency frozen *before* reveal, not a
post-hoc edit.

## 3. Source identity — VERIFIED

Recorded: branch `codex/quotation-admission`, HEAD = capture-time
`origin/main` = merge-base = `8d9cbf1b9c517bb3ee657bf557e520aead4f96bf`.
`TRACKED-WORKTREE.patch` and `INDEX.patch` are zero-byte (no tracked
modification, nothing staged); the six stranger artifacts are the only
untracked files. Chair-verified live: the source worktree still exists,
sits at `8d9cbf1b`, holds exactly those six untracked files, byte-identical
to the packet. No bundle was supplied; the repository evidence resolves the
recorded identity against the lab's own clone of the public repository.

## 4. Semantic-drift standing — NO DRIFT

Fresh `git fetch` against `github.com/Wondermonger-daydreaming/latent-lisp`
this evening: **current `origin/main` = `8d9cbf1b…` exactly** — the audited
commit, the capture-time remote, and today's live remote are one commit
(`8d9cbf1 auto-sync: lab 1aba6619`, the mirror image of today's Core /0
owner-acceptance). No Slice /1 semantic-controlling path has changed since
capture. Nothing to name.

## 5. Live behavioral result — 13/13 PASS, chair-run

The chair placed the delivered `STRANGER-PROGRAM.lisp` bytes (hash re-checked
after copy) at the root of a fresh detached git worktree at `8d9cbf1b` and ran
`sbcl --non-interactive --load STRANGER-PROGRAM.lisp` under SBCL 2.4.6
(wrapper operation-checked via `(lisp-implementation-version)` → `2.4.6`
before the run — the 07-20 wrapper-misbind scar rule):

- kernel0 foundations / algebra / records+folds smokes: PASS ×3
- behaviors 01–13: **all PASS**, names matching `RUN-RECEIPT.txt` lines 11–23
  verbatim
- Exit status 0.

Each of the 13 behaviors was individually confirmed present in the output and
its test form located in the program bytes (lines 199, 211, 221, 229, 237,
248, 266, 277, 282, 297, 322, 358, 371 — LYNX enumeration, chair-consistent
with the observed output).

## 6. Public-surface compliance — PASS

- **Zero `::` in the program** (chair grep: 0 occurrences). The only `::` in
  the whole dependency chain is the substrate's own licensed seam
  (`SLICE0-DEFECT-RECEIPT-1.md`), which is committed tree, not delivery.
- **Exactly 35 package-qualified symbols used, set-identical to
  `EXPORTS-USED.txt`** (chair set-diff: zero used-but-unlisted, zero
  listed-but-unused; split 2 kernel0 / 13 slice0 / 20 slice1 as claimed).
  LYNX verified each of the 35 is genuinely exported by its package
  (defpackage/export forms read in the committed sources).
- Package hygiene is strict: the program's package uses only `:cl`, so no
  symbol can leak in unqualified — the exports audit is therefore meaningful.
- `:exports-total 69` matches the committed slice1 export count and the API
  doc.

## 7. Host-escape standing — ONE DECLARED ESCAPE, EXACTLY MATCHED; NONE UNDECLARED

Chair-run token sweep (FFI, subprocess, file I/O, env, `eval`,
symbol-table manipulation, etc.) over the program: **one hit** — the initial
`load` of the committed `slice1.lisp` chain, which is load infrastructure,
not an escape. The declared ceiling — *"the hand-built derivation bridge is
the documented D-forge host escape — not a fresh target-side `derive`"* — is
**exactly what the bytes do**: `project-support` (program lines 328–333) is a
same-image hand-built `:mode :derivation` witness never passed through
`derive`, consumed by `project-claim`'s redaction gate. That is precisely the
stratum-3 D-forge boundary the architecture discloses (Δ3, refused-no-repair
per AUDIT-1) — chair re-read the doctrine text at the audited commit.
Corroborating the blindness claim: "D-forge" appears in none of the four
documents the stranger was allowed to read pre-freeze.

## 8. Claim ceilings (findings — all in the reporting layer, none in the program's substance)

**F1 (moderate) — the receipt's "Result ceiling" block is authorship, not
output.** The frozen program prints `:exports-used :see-exports-used` and
`:successor-pressure (:public-reader-for-derived-promotion-procedure)`
(chair-observed live, program lines 380–396); `RUN-RECEIPT.txt` lines 27–42
and `IMPLEMENTER-REPORT.md`'s result form instead carry `:exports-used 35`
and `(:public-derived-projection-bridge)`. The receipt's lines 1–25 are a
faithful transcript; its result block is a hand-composed summary. **Ceiling:
only `RUN-RECEIPT.txt` lines 1–25 may be cited as observed output.** The
`35` is substantively true (independently counted) but is a conclusion
wearing a receipt's costume. The successor-pressure keyword appears under
**three names** across program / report / retrospective; the RETROSPECTIVE's
final bounded form
(`:governed-target-derivation-projection-bridge :not-host-level-d-forge-closure`)
is the governing statement of that pressure.

**F2 (moderate) — "projection reconstructs rather than copies" is true at
object level, thinner at verdict level.** Chair-verified in the substrate
bytes: the target claim is a **new object** with a **freshly minted
judgment record** licensed by target-side machinery (the receiver's own
`raise` — "never a copy" per the substrate's own comment); but the
transported **proposition is caller-supplied** (`target-prop = (or
public-form src-prop)`), the **judgment value is inherited from the source**
(`raise … :to (judgment-record-judgment src-j)`), and the sole
target-accessible support is the D-forge bridge witness. What is
independently re-established at the target is the *license*, not the
*verdict value*. Check 12's proposition-equality conjunct is tautological.
**Ceiling: quote the RETROSPECTIVE's hedged wording
(`:projection-reconstructed (:yes :hand-built-derivation-bridge-not-target-derive)`),
never `IMPLEMENTER-REPORT.md`'s unhedged "re-judges it at the target."**

**F3 (minor) — dead input records.** Six of seven "frozen task-local input
records" are defined and never read; the live test data is re-typed literals
(chair-note: LYNX cross-checked all six against the literals — consistent,
so dead data, not a wrong-data hazard). The IMPLEMENTER-REPORT describes a
representation the program does not consult.

**F4 (minor) — two checks over-named.** Check 11 asserts a documented
identity function (the structured renderer is never called), and check 13's
three conjuncts are all constructor-guaranteed — the interesting law
(testimony refused at a derivation-keyed admits gate) is not exercised.
Mitigating: all six premise dispositions ARE genuinely exercised across the
run (missing / mismatched / inaccessible / refuted / satisfied / ambiguous),
just not by check 11.

**Notes (not findings):** N1 — style-warnings muffled during substrate load;
N2 — program requires repo-root placement and `load` (not `--script`); N3 —
the program clears the shared schema registry at start (reproducibility
inside its own image; wipes a warm REPL's registrations).

## 9. Adoption disposition — ADOPTED

All gates pass. The delivered bytes are banked **unmodified** at
`stranger-implementation-codex/` beside this record (all 23 packet files,
byte-faithful; internal and pre-reveal checksums re-verified after copy), in
the same adoption commit as this verification. The original pre-reveal and
retrospective evidence is preserved byte-faithfully; the outer ZIP + sidecar
are additionally frozen at `~/freezer/slice1-deliveries-2026-07-24/`.

What this adoption asserts: the stranger construction is genuine, honest at
the byte level, front-door-only in the narrow static sense with its one
disclosed D-forge rider, and behaviorally 13/13 under chair reproduction.
What it does not assert: any Core /0 standing; any independent validation of
Slice /1 beyond one stranger's constructive use; any weakening of the
delivery's own ceilings, which travel with every citation.

— Claude Fable 5 (CC seat), chair, 2026-07-24
