# READBACK — FIRST DETERMINISTIC GENERATION OF THE CROSS-LANE STATUS LEGEND

**Instrument gate:** clause **C.3.6** of
`RULING-R0.19-OWNER-DISPOSITION-INSTRUMENT-0-ADOPTED-2026-08-12.md` —
*"cross-lane constitutional reliance on the legend begins **only after** the
generator exists and its **first deterministic generation and readback succeed
against the authoritative sources**."*

**Built by:** FABER-LEGENDI (Claude Opus 5, 1M context), instrument-smith, for
the chair, 2026-08-12. **Nothing was committed.** No pre-existing file anywhere
in the repository was modified. All artifacts are new files inside
`…/languagehood-and-succession-charter-0/legend/`.

**This report is the builder's run record, not an owner finding.** It does not
declare the C.3.6 gate passed; the chair re-runs and the owner rules. What it
records is that, on this machine at this tree state, the generator exists and
its first generation plus readback succeeded.

---

## 0. Artifacts

| bytes | file |
|---|---|
| 13599 | `legend/legend-sources.json` (registry — 19 entries, 10 distinct conferring instruments) |
| 11756 | `legend/generate_legend.py` (python3, stdlib only) |
| 13974 | `legend/STATUS-LEGEND-GENERATED.md` (derived output — re-derived, never hand-edited) |
| — | `legend/READBACK-FIRST-GENERATION.md` (this file; its own size is self-referentially unstable and is left unstated) |

Sizes as measured after the final green run. The chair should re-`stat` rather
than trust the numbers.

The generator resolves the repository root from its **own file location**, not
from the shell's working directory: the final green run above was invoked from
the repository root and produced the identical hash as the runs invoked from
inside `legend/`. `--registry`, `--output`, and `--repo-root` may be overridden
(they exist so the teeth check can run against temp copies without touching the
real registry); the defaults are the committed paths.

---

## 1. First generation run — output and exit code

```
$ python3 generate_legend.py
GENERATED /home/gauss/Claude-Code-Lab/experiments/latent-lisp/mneme/languagehood-and-succession-charter-0/legend/STATUS-LEGEND-GENERATED.md — 19 rows, 10 distinct conferring instruments.
EXIT=0
```

Every one of the 19 entries had its `verbatim_anchor` confirmed as a **literal
substring** of its `conferring_instrument` before a single byte was written.

An earlier green run (same registry, exit 0, hash
`4fbc5e5ebf5436a3c89fb0061381736e8a9659496884bc092037c3f65aeb06e5`) was
superseded by a **rendering-only** fix: anchors containing backticks — the
`SURFACE0` row — broke their markdown code span. The fix emits a CommonMark
code fence longer than any backtick run inside the cell. No registry content,
status, anchor, or verification logic changed. The superseded hash is recorded
here so the chair sees that the file was regenerated, not hand-patched.

---

## 2. Determinism proof

Two consecutive runs of the unchanged generator against the unchanged registry:

```
$ python3 generate_legend.py ; sha256sum STATUS-LEGEND-GENERATED.md
GENERATED … — 19 rows, 10 distinct conferring instruments.
EXIT_A=0
edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464  STATUS-LEGEND-GENERATED.md

$ python3 generate_legend.py ; sha256sum STATUS-LEGEND-GENERATED.md
GENERATED … — 19 rows, 10 distinct conferring instruments.
EXIT_B=0
edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464  STATUS-LEGEND-GENERATED.md
```

**Both hashes: `edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464` — byte-identical.**
A third green run after the teeth check reproduced the same hash again (§3).

Determinism is structural, not lucky: rows are sorted by `id`, hashed
instruments are sorted by path, and the generator reads no clock, no random
source, and no environment variable. Its only inputs are the registry file and
the conferring instruments named inside it.

---

## 3. Teeth check — the gate is tested, not merely passing

A gate that has never fired is untested. Seven faults were planted, each in a
**temporary copy** of the registry under the session scratchpad; the real
registry was never modified.

### 3.1 The prescribed fault: a corrupted anchor

`W-02`'s anchor was mutated by a single word's case
(`the host executes the judge` → `the host executes the JUDGE`) in
`registry-corrupt-anchor.json`. The generator was then aimed **at the real
legend file** to prove it cannot clobber a good output with a bad run:

```
$ sha256sum STATUS-LEGEND-GENERATED.md          # before
edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464

$ python3 generate_legend.py --registry …/registry-corrupt-anchor.json \
                             --output …/legend/STATUS-LEGEND-GENERATED.md
LEGEND GENERATION FAILED — fail-closed, nothing written.
  failing id : W-02
  reason     : verbatim_anchor is NOT a literal substring of experiments/latent-lisp/mneme/languagehood-and-succession-charter-0/RULING-R0.19-OWNER-DISPOSITION-INSTRUMENT-0-ADOPTED-2026-08-12.md (first 60 chars of anchor: 'the host executes the JUDGE but does not supply the normativ')
  effect     : reliance on the derived legend is BLOCKED; underlying standing is UNCHANGED.
EXIT=2

$ sha256sum STATUS-LEGEND-GENERATED.md          # after — unchanged
edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464
```

**The planted failure FIRED**, on stderr, with the failing id and the reason,
exit 2, and the pre-existing good output **byte-unchanged**.

Re-run with `--output` pointed at a fresh path: same exit 2, and
`ls: cannot access …/should-never-exist.md: No such file or directory` — the
generator does not create a partial file and then abandon it.

### 3.2 Six further fault classes, all fired (exit 2 each, no file created)

| planted fault | failing id | reason reported |
|---|---|---|
| conferring instrument path does not exist | `ONEACT` | `conferring instrument not found: …/NO-SUCH-FILE.md` |
| status outside the adopted vocabulary (`MOSTLY OPEN`) | `LM0` | status outside the adopted vocabulary (six tokens listed) |
| anchor shortened below the 40-character floor | `SUCC` | `verbatim_anchor is 13 characters; at least 40 are required` |
| duplicate `id` appended | `RP4` | `duplicate id in registry` |
| required field blanked (whitespace only) | `W-13` | `missing or empty required field 'proposition'` |
| registry is malformed JSON | `<registry>` | `registry is not valid JSON: Expecting property name…` |

`ls …/never-*.md` → no such file: **none of the six failing runs wrote anything.**

### 3.3 The real registry still generates green

```
$ python3 generate_legend.py
GENERATED … — 19 rows, 10 distinct conferring instruments.
EXIT=0
edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464  STATUS-LEGEND-GENERATED.md   # same hash as §2

$ python3 generate_legend.py --check-only
CHECK-ONLY: 19 rows verified; nothing written.
EXIT=0
```

---

## 4. Readback against the authoritative sources — by a second instrument

The generator grading its own output would be a mirror. The readback was
therefore run with **different tools and different code**:

1. **Anchors re-checked with `grep -F`** (fixed-string, external binary), one
   anchor file per row, against the same conferring instruments:
   **19 verified, 0 missed.**
   *Honest limit:* `grep -f` matches line-wise, so the one multi-line anchor
   (`ROUNDP`) is confirmed by `grep` only line-by-line; its contiguity as a
   single span is established by the generator's exact `in` test, not by `grep`.
2. **Every sha256 printed in the generated legend re-checked against disk** by
   `sha256sum -c`, parsing the hashes out of the generated markdown itself:
   **10/10 OK.**
3. **Registry sha256 in the header vs. disk:**
   `1fc3fc6b24298be82e6cd0d76472bc9e00ef355bb87c9c6de961aeb574d4391a` — match.

---

## 5. Anchor selection — the two judgment calls worth flagging

Every anchor was found by reading the cited file; none was invented, and no
cited file lacked a usable anchor. Two choices were deliberate and the chair
should either bless or overrule them:

- **`W-04`.** The adopted W-04 text is two sentences that may never be quoted
  apart (quoting the classification without the exclusion is a CC-2 violation).
  Any ≥40-character single-line anchor drawn from the ratified blockquote would
  necessarily be a **fragment of the first sentence**. The anchor therefore
  quotes the **ratifying act** —
  `moves from **PROPOSED HOLDING** to **ADOPTED LAW** by owner ratification.` —
  which evidences the conferral without reproducing a severable half of the law.
  The full two-sentence form lives in the conferring instrument, where a reader
  is sent.
- **`ROUNDP`.** `* Portability is not established.` is 32 characters, under the
  40-character floor, and the surrounding lines are separate list items. The
  anchor is the exact three-line span
  (`Portability is not established` / eighteen residual items / `Evidence
  earned: **zero**`), which is both ≥40 characters and a stronger record of the
  round's caps than the single line alone.

Two anchors intentionally overlap (`PORTJ-L0` and `CI0` both draw on Ruling 6B's
single stop clause, which names both jurisdictions in one sentence); they are
distinct substrings of that sentence, and the shared origin is a fact about the
ruling, not a defect in the registry.

---

## 6. Limits — what this readback does NOT prove

**The anchor verification proves textual presence and file identity. Nothing more.**

- It proves the quoted string **exists** in the cited file, and records that
  file's sha256 at generation time. It does **not** prove the quote **means what
  the row's `proposition` says**, that the proposition is complete, or that the
  chosen status token is the right reading of the instrument.
  **Meaning-fidelity remains the chair's and the owner's reading duty** and is
  not mechanizable by this generator.
- A row can be **green and wrong**: a correctly-located anchor attached to a
  mischaracterizing proposition passes every check here. The mechanism catches
  drift, deletion, and fabrication — not misreading.
- The `sub_annotation` and `note` fields are **not anchored at all**. They are
  chair-authored gloss, verified by nobody but the chair. Where they and an
  originating instrument disagree, the instrument wins.
- The hashes are **generation-time snapshots**. They do not detect a later edit
  to a conferring instrument; only a re-run does. This is the intended
  behaviour: the legend is re-derived after every owner ruling affecting it.
- The **row set** is not self-verifying. Nothing in the generator knows whether
  a nineteenth, twentieth, or thirtieth proposition *ought* to be in the
  registry. **Completeness is an editorial claim, not a checked one** — a
  standing conferred somewhere the registry does not name is simply absent, and
  the legend's silence is not evidence of its absence.
- Determinism was demonstrated on **one machine, one Python, one tree state**.
  It is designed to be platform-independent (no clock, no randomness, sorted
  everything, explicit UTF-8), but cross-machine reproduction is asserted from
  the code's construction, not measured here.
- No claim of independent verification is made or implied. **This is the
  builder's own record of its own instrument**, run by the same hands that wrote
  it. The chair's re-run is the first outside reading, and it is owed.

---

## 7. Incidental observation for the chair (not part of this build)

While checking that nothing outside `legend/` was touched, `git status` showed a
second untracked file in the lane —
`LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-R1.md`, mtime 2026-08-12 15:03:09, i.e.
written ~27 seconds before that check. **It was not created, modified, or read
by this build.** On the final `git status` a few minutes later it was **no
longer listed as untracked** — so it was moved, removed, or committed by
whatever hand made it while this build was running. Recorded only so the chair
does not mistake either its appearance or its disappearance for an artifact of
this commission. Cause unverified; I did not investigate, because doing so would
have meant reading another agent's in-flight work.

*— FABER-LEGENDI (Claude Opus 5, 1M context), instrument-smith, 2026-08-12.
Nothing committed; nothing published; nothing outside `legend/` written.*
