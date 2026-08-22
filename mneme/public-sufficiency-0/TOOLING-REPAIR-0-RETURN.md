# TOOLING REPAIR /0 — RETURN (TD-1..TD-4 repaired; TD-5 found and exhibited)

**Constructed by the chair (Claude Fable 5), 2026-08-12, on the owner-relayed
commission to open the tooling-defect repair (relay archived:
`corpus/voices/received/2026-08-12-sol-tooling-repair-commission.md`).
Subject: `mneme/language-many-acts-0/ma0-campaign-gates.sh` (CANDIDATE
tooling — running it adopts nothing). Status: READY FOR OWNER ACCEPTANCE,
with one new finding (TD-5) put as a separate fork.**

---

## 1. The repairs (each tied to its docket row)

- **TD-1 (vacuous pass):** every history diff is now **seal-existence-guarded**
  (`git cat-file -e "$SEAL^{commit}"` first) and **rc-checked** (stderr
  captured; `rc≠0` → FAIL "an errored diff is NOT an empty diff"). A missing
  seal yields **UNAVAILABLE**, a third gate state that is never folded into
  PASS. New permanent tooth: `MA0_GATES_PLANT=seal` plants a nonexistent
  seal; the run must go UNAVAILABLE + exit nonzero.
- **TD-2 (ungoverned lab-side path):** the V-F freeze-table absence is now
  **UNAVAILABLE with its reason stated** ("lab-side evidence, not in the
  published tree") — no longer a wrong-flavored FAIL; still never a pass;
  digest mismatch still FAILs (tooth re-proven tonight).
- **TD-3 (REL strip no-op):** mirror-shaped checkouts (`ROOT == REPO`)
  normalize `REL="."`; all guarded pathspecs build through one helper. On
  the real mirror the existence gates now PASS instead of failing on
  absolute-path garbage.
- **TD-4 (net):** three states, three exits — `0` all-passed · `2` PARTIAL
  (no failures, ≥1 unavailable, sentinel says so) · `1` any failure.

## 2. Teeth transcript (every repair shown able to fire BEFORE any green was trusted)

| Run | Expectation | Result |
|---|---|---|
| `PLANT=seal` (new TD-1 tooth) | never green; UNAVAILABLE ×2; exit ≠ 0 | **UNAVAILABLE ×2, PARTIAL, exit 2** ✓ |
| `PLANT=vf` (existing tooth through new code) | FAIL, exit 1 | **FAIL (digest mismatch shown), exit 1** ✓ |
| honest lab run | exhibit TD-5 | **exit 1; sole FAIL = the six owner-accepted rulings/ files, enumerated** ✓ |
| floor plant | *not re-run tonight* (floor takes minutes; its tooth logic is untouched since its R1-era proof) — stated, not hidden | — |

## 3. The mirror rehearsal (the commission's real question)

Fresh anonymous clone of the actual public mirror (tip `3101fce`), repaired
gate overlaid, `SKIP_FLOOR=1`:

**PARTIAL — 5 passed / 3 unavailable of 8 gates, exit 2.** The passes:
guarded-path existence ×3 (TD-3 cured), working-tree-clean, and
**W-ONEACT-GREEN: 173 checks / 0 failures from public bytes alone** — the
campaign's thesis sentence, now witnessed by an instrument that can no
longer lie about the rest. The unavailables: V-F table (TD-2, reason
stated) and both history gates (TD-1, no lab seal in mirror history).
**Zero vacuous passes; zero wrong-reason failures.** Full log preserved in
this return's parcel.

## 4. TD-5 — NEW FINDING (exhibited, not repaired; the fork is the owner's)

The floor gate asserts `language-act-0/` carries **"NO diff at all"** since
seal `9e52b7e1`. **Owner-accepted law now violates the gate's letter:**
PS/0 Parcel 1 (D-5, accepted) added six documentary files under
`language-act-0/rulings/` (1,146 insertions, additions only). The honest
lab run therefore fails, and the failure enumerates exactly those six
files. This is a **law-vs-tooling conflict**: the gate's invariant predates
the campaign that lawfully changed the directory. Deliberately NOT patched
— a gate carve-out chosen by the chair would be tooling deciding law.

Options for the owner (put by interview with this return):
- **(a) Enumerate the citizens** *(chair recommendation)*: the gate guards
  the **ten pre-Parcel-1 files by name** (implementation, gates, fixtures,
  witnesses, records) instead of the directory — additions elsewhere in
  `language-act-0/` are lawful; any diff to the ten stays RED. Permission
  by enumeration, never by description — the charter's own lesson.
- **(b) Re-seal**: declare a new seal epoch post-Parcel-1; the "no diff"
  letter survives but its baseline moves (an owner act about evidence
  epochs, more than a tooling fix).
- **(c) Leave it red**: honest, but every lab run fails forever on accepted
  law — red noise that will train eyes to ignore the gate.

## 5. Changed-file inventory / earned

One file: `ma0-campaign-gates.sh` (candidate successor, discharged on
acceptance per D-3). No law text, no implementation, no frozen artifact, no
PortJ/0 document touched. **Earned: nothing** — a trustworthy gate proves
nothing by existing; it merely stops lying. The stranger audit remains
OWED; nothing mirror-published (the rehearsal overlay was a throwaway
clone; the mirror itself is untouched).

## 6. Acceptance proposition (one act)

> **ACCEPT TOOLING REPAIR /0**: the repaired `ma0-campaign-gates.sh` as
> filed — three-state verdicts, seal-existence + rc-checked diffs, the
> seal tooth, availability semantics for lab-side evidence, mirror-root
> path normalization. Acceptance discharges the candidate successor per
> D-3, closes TD-1..TD-4 in the tooling docket, and creates no evidence.
> TD-5 is disposed separately by its own fork.

*— Claude Fable 5, chair, 2026-08-12.*
