# MANY ACTS /0 — EXPORT CENSUS /0 — R1 RETURN (CANDIDATE)

**Authorized by:** Owner Ruling 6A, filed at
`experiments/latent-lisp/mneme/portable-judge-0/OWNER-RULING-6A-EXEC-ACCEPTED-CENSUS-R1-ORDERED-2026-08-10.md`
(items 1–9 of the "Census R1 must" list).

**Standing:** CANDIDATE. Nothing in this return is adopted, accepted, frozen,
audited, independently verified, independently validated, stranger-audited, or
independently reproduced. **Evidence earned toward portability, independent
implementation, or conformance: ZERO.**

**Separate return (Ruling 6A item 9).** Census R1 is sealed and returned on its
own. It is not bundled with the Parcel B execution integration, reopens no
B1–B6 item, advances no S-freeze, and opens neither PortJ-F/0, nor the hidden
bank, nor J2. Every artifact it adds or changes lives under
`language-many-acts-0/export-census/`.

**Preservation (Ruling 6A, standing instruction).** The submitted R0 parcel,
commits `9890f9b5` and `1e8e03d8`, the four original transcripts, and
`EXPECTED-EXPORTS.txt` are **byte-unchanged**. The R0 return document
(`MANY-ACTS-0-EXPORT-CENSUS-0-RETURN.md`) was **not edited** — the quantifier
correction ordered by item 8 is made *here*, in §7 of this document. Proof in
§8.

---

## 1. The defect, as ruled

The owner's sentence, verbatim:

> The R1 defect is precise: `ma0-export-census.sh --table P` and the Lisp half's
> arbitrary table argument permit expectation substitution. A live package with
> `ma0-selftest` replaced by the bound internal `ma0-refuse` can be paired with
> a correspondingly substituted table and obtain the success sentinel. The
> submitted default-table teeth and clean observation remain accepted; only the
> instrument requires repair.

The finding is correct and is now **demonstrated rather than conceded**. Tooth
00 leg A (`transcripts-r1/00-tooth-expectation-injection.txt`) runs the
**pre-repair** Lisp half — materialized from commit `1e8e03d8`, blob
`1a596ee9ec37af4069870498cd0cd145c8b58c5e` — against the planted package and a
correspondingly substituted roll, and it prints:

```
SET EQUALITY: HOLDS (38 names)
all 38 present expected export(s) bound in their designated sense
all external symbols homed in LISP-PLUS-MANY-ACTS0
ma0-export-census: exact set equality, 38 exports, 0 missing, 0 unexpected, 0 unbound
```

with **exit 0**. Both sides of the substitution are count-preserving: the live
package still exports 38 names, the substituted roll still carries 38 rows. The
R0 gate's three checks all pass, because a census that accepts the subject's own
roll is checking a set against itself.

The defect is one of **instrument authority**, not of arithmetic. Nothing about
the R0 teeth or the R0 clean observation is retracted here; they were run against
the default table, and what they showed remains what they showed.

---

## 2. The repair, and why the sentinel is now unreachable by substitution

### 2.1 Bound identities (Ruling 6A item 2)

| Role | Identity |
|---|---|
| Adopted coordinate | `231873c7be8ba275cd5756c929efba2f9c807157` |
| `package.lisp` blob at that coordinate | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` |
| `EXPECTED-EXPORTS.txt` blob | `78592073905450ff9afcd22dea53afbf53764fa1` |

These three are written as **literals in both halves of the gate**. They are the
census's own law, not inputs to it.

### 2.2 The driver: arbitrary-table selection removed (items 1 and 3)

`--table` no longer exists in `ma0-export-census.sh`. It is not deprecated,
not ignored, not conditionally honoured: the flag is matched only to be
**refused with exit 2** and a message saying it was removed, so an operator who
reaches for it gets a stop rather than silence. Every other unrecognized
argument still exits 2. The driver's only invocation is
`./ma0-export-census.sh`, with no arguments.

Before **any** census evaluation — before the subject system is loaded at all —
the driver runs three binding checks, and any failure exits 2:

| | Check | Method |
|---|---|---|
| 3a | the committed table is the bound table | `git hash-object EXPECTED-EXPORTS.txt` = `78592073…` |
| 3b | the coordinate exists and carries the bound package | `git rev-parse 231873c7:…/package.lisp` = `a97d3c3e…` |
| 3c | **byte-regeneration** | `derive-expected-exports.sh 231873c7` piped to a temp file, then `cmp -s` against the committed table |

3c is the strong form the ruling names first: the table is regenerated from the
adopted coordinate and compared **byte for byte**. It proves the file *is* the
table derived from that coordinate, not merely a file whose name has been seen
before. The clean transcript records all three passing, and 3c's regenerated
bytes hashing to `78592073905450ff9afcd22dea53afbf53764fa1`.

The driver also fails closed if `git` is unavailable. A binding that cannot be
checked is not a binding, and proceeding without it would reintroduce the defect
under a different name.

### 2.3 The Lisp half: the sentinel is behind a self-performed re-derivation (item 4)

The ruling requires that **direct** invocation of the Lisp half with an
arbitrary table cannot emit the normative success sentinel. The sentinel is the
line beginning:

    ma0-export-census: exact set equality,

The construction, in one sentence: **the sentinel's text exists at exactly one
site in the file — inside `CENSUS-EMIT-SENTINEL` — whose first act is to re-read
the expected table from disk, recompute its git blob object id with a SHA-1
implemented in that same file, and `exit 2` without printing if the result is
not `78592073905450ff9afcd22dea53afbf53764fa1`.**

Four properties make that construction hold rather than merely sound good:

1. **The check is self-performed.** The Lisp half computes
   `sha1("blob " ‖ length ‖ NUL ‖ contents)` itself. It calls no `git`, trusts
   no wrapper, reads no environment variable, and accepts no flag saying "this
   was already verified." A direct `sbcl --script … <table>` carries its own
   verifier with it. Neither half of the gate trusts the other.
2. **It runs twice, at both ends.** Once before the table is parsed and before
   the subject system is loaded (a refusal at that point means no census was
   conducted at all), and once again inside the emitter. The second is not a
   re-read of a flag set by the first; it is a fresh derivation from the file on
   disk.
3. **The sentinel literal is not reachable except through the emitter.** There
   is one `format` in the file containing that text, and it is downstream of the
   guard within the same function. The failure branch of the census calls
   `sb-ext:exit` on its own path; the success branch's only action is to call
   the emitter.
4. **The verifier is teeth-checked on every run.** The in-file SHA-1 is run
   against three known answers — the empty string, `"abc"`, and a 56-byte input
   (the two-block padding boundary) — at load time, and the census refuses with
   exit 2 if any disagrees. It was additionally checked against `git hash-object`
   on three real files of this lane during development. A verifier that has never
   been shown able to compute is not a verifier, and a silently wrong digest
   would have turned this entire repair into decoration.

**The argument is deliberately still accepted.** Removing it would have made the
attack unexpressible rather than defeated, and would have left the injection
tooth with nothing to attempt. It is retained and rendered **non-load-bearing**:
it can select only the bound bytes. Handing the Lisp half a byte-identical copy
of the bound table at another path is not substitution and is allowed; handing it
anything else is refused before the subject is loaded.

**What this does not claim.** The binding fixes the *expected* side to bytes an
attacker cannot swap at invocation time. It does not defend against an adversary
who edits the gate's own source, and it is not offered as doing so: a gate is
authority over its inputs, not over its own text. Anyone who can rewrite
`ma0-export-census.lisp` can write any sentinel they like, and no self-contained
artifact can authenticate its complete state against an adversary permitted to
rewrite all of it. The defence there is the commit graph and the reviewer, not
this file.

---

## 3. The expectation-injection tooth (item 5)

`transcripts-r1/00-tooth-expectation-injection.txt`. The plant is the owner's
own scenario, made in place in the real subject source and count-preserving on
both sides:

- **package.lisp:** `#:ma0-selftest))` → `#:ma0-refuse))` (planted blob
  `d8cb7e4ac4ffdffb896aaa605519042c9a500e74`; the diff is in the transcript);
- **the substituted roll:** the `ma0-selftest` row removed and a
  `ma0-refuse function ma0-structures.lisp:71 defun` row inserted, re-sorted
  `LC_ALL=C`; **38 data rows before, 38 after**; blob
  `2c5cfb5c1c8b57d2329e0d3afe2753be9312794a`, which is not the bound
  `78592073…`.

`ma0-refuse` is a genuinely fbound internal (`defun` at
`ma0-structures.lisp:71`), so every boundness and home-package check passes on
the planted image. That is what makes this an injection rather than a typo.

| Leg | What is run | Expected | Observed exit | Sentinel in that leg's output |
|---|---|---|---|---|
| **A** *(control)* | **pre-repair** Lisp half (`1e8e03d8`, blob `1a596ee9…`) + substituted roll | 0, sentinel PRESENT | **0** | **PRESENT (1)** |
| **B** | repaired driver, `--table <substituted>` | 2, sentinel ABSENT | **2** | ABSENT (0) |
| **C** | **direct** repaired Lisp half + substituted roll | 2, sentinel ABSENT | **2** | ABSENT (0) |
| **D** | repaired normative driver, planted package, bound roll | 1, sentinel ABSENT | **1** | ABSENT (0) |

**Leg A is the load-bearing one.** A tooth that has never been shown to bite
something is untested, not passing; leg A exhibits the cheat *succeeding* under
the pre-repair instrument, so legs B and C are refusals of an attack known to
have worked rather than of a hypothetical. Leg C is the exact requirement of item
4 — direct invocation, arbitrary table, refusal at the pre-census check with the
message *"EXPECTATION SUBSTITUTION"*, printing the offered blob, the bound blob,
and the bound coordinate.

**The grep, shown.** Each leg's report line counts the sentinel over **that
leg's captured output only**, and the report lines deliberately do **not** contain
the sentinel string, so a reader's own whole-file grep is not poisoned by the
transcript's bookkeeping. The invariant, stated in the transcript itself and
re-verified here:

Counts observed from
`grep -cF 'ma0-export-census: exact set equality,' transcripts-r1/*.txt`
(presented as a table, not as a pasted shell session — the numbers are the tool's,
the ordering and the commentary are mine):

| Transcript | count | accounted for as |
|---|---|---|
| `00-tooth-expectation-injection.txt` | **2** | the `SENTINEL-DECLARATION` line + leg A's emission by the pre-repair gate |
| `01-fault-unexpected.txt` | **0** | — |
| `02-fault-missing-substituted.txt` | **0** | — |
| `03-fault-unbound.txt` | **0** | — |
| `04-clean.txt` | **1** | the clean run's emission |

Transcript 00 names the sentinel once, on a line labelled `SENTINEL-DECLARATION`,
so that the string is legible to a reader without being an emission; that is the
only non-emission occurrence in any R1 transcript, and the count of 2 is
therefore fully accounted for.

---

## 4. The original teeth, re-run against the repaired instrument (item 6)

Planted-fault-first, in the ordered sequence, all before the clean run. Faults
are planted **in place** in the real subject source and run against the
**unmodified production invocation** — no test-only parameter and no injection
hook, since an injection hook in the gate would itself be the hole.

| # | Transcript | Fault planted | Caught by | Exit |
|---|---|---|---|---|
| 00 | `00-tooth-expectation-injection.txt` | substituted export **and** substituted roll | table binding (legs B, C); set equality (leg D) | **2 / 2 / 1** *(A = 0, control)* |
| 01 | `01-fault-unexpected.txt` | `#:ma0-refuse` added to the export list | set equality → `UNEXPECTED` | **1** |
| 02 | `02-fault-missing-substituted.txt` | `#:ma0-selftest` removed, `#:ma0-refuse` substituted — **count still 38** | set equality → `MISSING` **and** `UNEXPECTED` | **1** |
| 03 | `03-fault-unbound.txt` | `defun ma0-act-summary-verdict` commented out; export list byte-untouched | boundness → not bound as `function` | **1** |
| 04 | `04-clean.txt` | none (both subject files at baseline, proven by blob) | — | **0** |

Numbering scheme, stated because the ruling asked for one that makes the order
obvious: the three accepted teeth **keep their R0 numbers** (01, 02, 03) so a
reader can set the two transcript sets side by side, and the new injection tooth
takes **00** because it ran *first*, before any of them. The clean run stays 04
and is last in both file order and wall-clock order. Every planted-fault
transcript precedes the clean one on both axes.

Tooth 03 leaves `package.lisp` byte-identical at `a97d3c3e`, so **set equality
still HOLDS** on that run and only the boundness check refuses — the two checks
remain independently load-bearing under the repair.

All five transcripts were produced by one committed harness,
`export-census/run-r1-teeth.sh`, which plants, runs, restores, and prints blob
identities at each stage. Exit codes are captured **directly** from the gate
process (`$?` on the line immediately after the call), never via `PIPESTATUS`
after an intervening command — the defect that produced a false `OBSERVED EXIT: 0`
in the R0 capture attempt and was recorded rather than buried there.

---

## 5. Restoration, proven after every plant (item 7)

Baselines: `package.lisp` = `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c`;
`ma0-structures.lisp` = `7a2c093e62e260136bbd6c9dde04dd2df29b2848`.

The harness asserts the baseline **before** each plant and refuses to plant if
either file is off-baseline, and prints `git hash-object` for both files before
the plant, after the plant, and after restoration, into each transcript.

| Tooth | Planted state — `package.lisp` | Planted state — `ma0-structures.lisp` | After restoration — `package.lisp` | After restoration — `ma0-structures.lisp` |
|---|---|---|---|---|
| 00 | `d8cb7e4ac4ffdffb896aaa605519042c9a500e74` | *(baseline — not planted)* | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` | `7a2c093e62e260136bbd6c9dde04dd2df29b2848` |
| 01 | `2f968f4d812672a1ab8264f7f6e2dfa318a587bf` | *(baseline — not planted)* | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` | `7a2c093e62e260136bbd6c9dde04dd2df29b2848` |
| 02 | `d8cb7e4ac4ffdffb896aaa605519042c9a500e74` | *(baseline — not planted)* | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` | `7a2c093e62e260136bbd6c9dde04dd2df29b2848` |
| 03 | *(baseline — byte-untouched, by design)* | `408b1694fde9f68fa819feba8732639b7ffebe03` | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` | `7a2c093e62e260136bbd6c9dde04dd2df29b2848` |

*Every hash in this table was read out of the transcript the run itself wrote —
none was reconstructed from memory or from a rerun. Note that teeth 00 and 02
plant the same package edit and so land on the same blob, and that tooth 03
leaves `package.lisp` at baseline on purpose: that is what lets set equality
still hold on its run while only boundness refuses.*

Final state after the whole suite, printed by the harness and re-checked
afterwards:

```
$ git hash-object package.lisp ma0-structures.lisp
a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c
7a2c093e62e260136bbd6c9dde04dd2df29b2848
$ git status --porcelain -- package.lisp ma0-structures.lisp
(no output)
```

Neither subject file appears in any commit of this R1 return.

---

## 6. Files added or changed by this return

| Path (under `language-many-acts-0/export-census/`) | Status | Blob |
|---|---|---|
| `ma0-export-census.sh` | **replaced** (was `440cf5fe…`) | `e968da17991d1ce38bbad9a5c9191cfcc0388051` |
| `ma0-export-census.lisp` | **replaced** (was `1a596ee9…`) | `fccb2df0aa7f2ed7c7bba9b9180cc9f572e67528` |
| `run-r1-teeth.sh` | new | `dfb412a3e35d34b14d6facab67632ea2351d72bd` |
| `transcripts-r1/00-tooth-expectation-injection.txt` | new | `8984b6666f879f076e3ff87f3efb40eb62b7db45` |
| `transcripts-r1/01-fault-unexpected.txt` | new | `af212e37ec7aa20f7ae03fe09c8d5eb19886a6d1` |
| `transcripts-r1/02-fault-missing-substituted.txt` | new | `1a4ba0a7da3e4c121b43107a89dfc1c3cc910766` |
| `transcripts-r1/03-fault-unbound.txt` | new | `539deed3e309b797cedf9016c45560d679b5bdf7` |
| `transcripts-r1/04-clean.txt` | new | `4075010d88e7991bdc63942f181a99f6cf6e60a4` |
| `MANY-ACTS-0-EXPORT-CENSUS-0-R1-RETURN.md` | new (this file) | — |

`EXPECTED-EXPORTS.txt`, `derive-expected-exports.sh`, `capture-tooth.sh`, the
four `transcripts/` files, and the R0 return document are **untouched**. The old
gate blobs `440cf5fe…` and `1a596ee9…` remain retrievable at `9890f9b5` and
`1e8e03d8`; the repair replaces the working files and destroys no history.

---

## 7. The quantifier correction ordered by item 8

The R0 return's §6 parenthetical reads:

> *(`9890f9b5` is the commit that introduced every artifact of this return; this
> sentence is filed by the immediately following commit, since a file cannot
> carry its own commit hash.)*

**"every artifact of this return" over-reaches.** `9890f9b5` introduced the
*operational* artifacts — the gate, the derivation script, the capture harness,
the roll, and the four transcripts — but the return **document** in its filed
form was produced by `1e8e03d8`, which is itself an artifact of the return. The
correct statement, as the owner put it:

> artifact commit `9890f9b5…` introduced the operational artifacts; tip
> `1e8e03d8…` filed the return document.

That is the wording that governs. Per the preservation instruction the R0
document was **not edited**; this section is the correction of record, and any
future reader of the R0 §6 parenthetical should read it through this paragraph.

The same distinction is honoured here rather than repeated: the R1 **operational
artifacts** (repaired gate, harness, five transcripts) are introduced by the
commit named in §9 below, and **this document** is filed by the commit that adds
it — which it cannot name, for the same reason. The sealed parcel's
`IDENTITIES.txt` records the final tip.

---

## 8. Preservation, proven

```
$ git diff --stat 1e8e03d8 -- \
    export-census/EXPECTED-EXPORTS.txt \
    export-census/transcripts \
    export-census/MANY-ACTS-0-EXPORT-CENSUS-0-RETURN.md \
    export-census/capture-tooth.sh \
    export-census/derive-expected-exports.sh \
    package.lisp ma0-structures.lisp
(no output — every one of these paths is byte-identical to 1e8e03d8)

$ git hash-object export-census/EXPECTED-EXPORTS.txt
78592073905450ff9afcd22dea53afbf53764fa1
```

The roll's blob was verified as `78592073…` **before** the repair began and
again after the whole tooth suite had run. Commits `9890f9b5` and `1e8e03d8` are
untouched; R1 commits sit **on top of** `1e8e03d8`. The sealed R0 archive
`~/Downloads/ma0-export-census-0-2026-08-10.tar.gz` was not opened, rebuilt, or
replaced; its SHA-256 reads
`acedd92a366173377eb436b323113820b1705db2f2d7087c0a2e3aaf76f9325d`, recorded
here as an observation of the file on disk, not as a re-seal.

---

## 9. Claim ceiling

The only claim this return makes:

> **On branch `ma0-export-census`, with the repaired instrument introduced by
> commit `1e27f67e`, the census gate refuses a count-preserving
> substituted expectation — at the driver, at a direct invocation of the Lisp
> half, and at the census itself — and, run against the bound roll on a clean
> subject, found exact set equality between the live `LISP-PLUS-MANY-ACTS0`
> external-symbol set and the table derived from `package.lisp` at the adopted
> R1 coordinate `231873c7`, with all 38 expected exports bound in their
> designated categories.**

Nothing stronger. Specifically **NOT** claimed, and not inferable from anything
above:

- **no claim that this gate is un-cheatable in general** — only that the ruled
  substitution path is closed, shown by a tooth that first demonstrates the path
  worked. An adversary permitted to edit the gate's own source is outside what
  any self-contained artifact can answer, and no defence against that is claimed;
- no portability claim of any kind — the gate fails closed on any SBCL other
  than 2.4.6, and one implementation on one version is not portability;
- no independent-implementation claim;
- no conformance claim, and no claim that a Many Acts /0 statute or
  portable-conformance standard exists or has been met;
- no independent verification, independent validation, independent
  reproduction, or stranger audit — this is **same-author evidence**, written and
  run by one agent in one worktree, on top of a return written by a predecessor
  agent of the same author-line, and the stranger audit remains **OWED**;
- no claim that the export surface is *correct*, *complete*, *well-designed*, or
  *stable* — only that it is **exactly what the adopted coordinate says it is**,
  and bound;
- no claim discharging any B1–B6 item, any part of the 28-deficit register or the
  S-freeze agenda, and no claim touching PortJ-F/0, the hidden bank, or J2;
- no retraction of the accepted R0 default-table teeth or the R0 clean
  observation; Ruling 6A left those standing and this return does not disturb
  them.

**Evidence earned: ZERO.** A census gate that now binds its own expectation still
only tells you the roll matches the citizens on one branch at one moment on one
implementation. It does not tell you the roll is right — it tells you the roll
was not swapped.

---

## 10. Red flags and honest limits

1. **The repair was written and tested by the same hand.** The construction
   argument in §2.3 is mine, and the tooth that tests it is mine. A gate whose
   only adversary is its own author has been checked, not audited. The control
   leg exists precisely because "I designed it so it can't happen" is not
   evidence; the closest thing to an outside in this return is the *pre-repair
   binary fact* that the attack used to succeed.
2. **The binding is to bytes, and bytes are only as good as the coordinate.**
   If `231873c7` were ever wrong about what MA0 exports, this gate would enforce
   the wrong roll flawlessly. The census tests *identity against the adopted
   coordinate*, never *correctness of the adopted coordinate*.
3. **Check 3c re-runs `derive-expected-exports.sh` on every census run.** That
   script is an R0 artifact this return did not rewrite; the byte-regeneration
   check therefore inherits whatever is true of it. Its two independent
   extractions and its fail-closed branches were re-exercised on every R1 run
   (the regenerated bytes hash to `78592073…` in the clean transcript), but it
   was not re-audited line by line here.
4. **The in-file SHA-1 is a fresh implementation.** It is known-answer checked on
   every run and was compared against `git hash-object` on three real files, and
   the design deliberately fails closed rather than open — but it is new code
   written today, and new code written today is the least-tested code in this
   lane.
5. **Tooth 00 leg D and tooth 02 plant the same fault.** That is deliberate (D
   shows the planted package still caught by set equality under R1; 02 is the
   ordered re-run of the accepted R0 tooth), but it should not be read as two
   independent confirmations. It is one fault, run twice, reported twice.
6. **`--table` is refused rather than silently unknown.** That message tells an
   attacker exactly what the binding is. This was judged the right trade — an
   operator deserves a reason for a stop, and the binding is published in this
   document anyway — but it is a choice, not a neutrality.

---

*Filed under Owner Ruling 6A. Candidate, branch-local, same-author, zero
evidence. No portability, independent implementation, conformance, or
independence of any kind is claimed or implied.*

— Claude Opus (agent CENSOR-II), 2026-08-10
