# ONE ACT /0 — COMMENT-LAW SWEEP (Round OA)

**CANDIDATE parcel — Round OA; not an adoption; frozen court-construction
baseline commit `71422395`; read-only over adopted history; zero evidence toward
any PortJ/0 station.**

Charge: sweep the adopted lane sources' comments for normative sentences absent
from the five candidate documents. **No comment-only law is converted to prose
law here; no missing clause is drafted; nothing is repaired.** Each hit is
recorded verbatim with its location, classified, and left in place.

---

## 1. The search set, shown

Comment-line extraction (Lisp `;`-prefixed lines and shell `#`-prefixed lines),
intersected with a normative-modal set:

```
$ cd experiments/latent-lisp/mneme/language-act-0
$ grep -n -E '^[[:space:]]*(;+|#)' *.lisp *.sh \
  | grep -E '\b(MUST|must|MAY NOT|may not|never|NEVER|forbidden|FORBIDDEN|law|LAW|rule|RULE|governing|GOVERNING|binding|BINDING|required|REQUIRED|shall|SHALL|prohibited|PROHIBITED|mandatory|MANDATORY)\b'
```

**95 hits**, distributed:

```
act0.lisp                  42
act0-gates.lisp            20
act0-load-witnesses.lisp   10
act0-fixtures.lisp          6
package.lisp                8
act0-selftest.lisp          5
act0-load-witnesses.sh      2
act0-loader-disease.sh      2
```

Each hit was then tested against the five documents' adopted bytes with
`grep -i -F` on its distinctive phrase. Representative resolution runs:

```
$ cd _staging/oneact-candidate
$ for p in "NEVER FIRED IS UNTESTED" "ADJUST AN INPUT" "HOPE WITH A FIELD NAME" \
           "H-AP0-COLLIDE" "TEETH DISCIPLINE" ; do
      echo "$p → $(grep -l -i -- "$p" *.md | tr '\n' ' ')" ; done
NEVER FIRED IS UNTESTED → ONE-ACT-0-TEST-PLAN.md ONE-ACT-0-CONTRACT-CANDIDATE.md
ADJUST AN INPUT         → ONE-ACT-0-TEST-PLAN.md
HOPE WITH A FIELD NAME  → ONE-ACT-0-TEST-PLAN.md ONE-ACT-0-CONTRACT-CANDIDATE.md
H-AP0-COLLIDE           → all five
TEETH DISCIPLINE        → ONE-ACT-0-CONTRACT-CANDIDATE.md
```

**Teeth-check on the sweep itself** (a search that has never found anything is
untested, not clean): the same probe run against phrases known to be *absent*
returns empty, and the sweep's positive control — the five phrases above —
returns hits. Both directions fired.

---

## 2. RESTATEMENT (harmless — the law is also in the documents)

The rhetorical laws that read most like invented doctrine turn out to be
**verbatim restatements of document text**. Sample, each verified present:

| Source | Comment (verbatim) | Also in |
|---|---|---|
| `act0-gates.lisp:4-6` | `V-3, THE TEETH DISCIPLINE: every gate must be SHOWN ABLE TO FAIL before its clean pass is reported.  A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.  Planted faults are PERMANENT RESIDENTS of the suite, never …` | contract, test plan |
| `act0-gates.lisp:10` | `⚠ NEVER ADJUST AN INPUT TO MAKE AN OUTPUT COME OUT.` | test plan |
| `act0.lisp:1376-1377` | `⚠ A RECORDING THAT IS NEVER READ BACK IS NOT A BINDING; IT IS A HOPE WITH A FIELD NAME.` | contract, test plan |
| `act0-gates.lisp:603` | `A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.` | contract, test plan |
| `package.lisp:9-11` | `(AP0 adoption Rider 2, binding; contract §0.3): the phrases "independently verified" and "independently validated" may not appear in …` | contract §0.3 body @202-208, verbatim |
| `package.lisp:20-21` | `CRASH MODEL: ONE PROCESS LIFE.  No SIGKILL, no process death, no cross-death continuation (contract §0.4, §7.1).` | contract §0.4, §7.1 |
| `act0-fixtures.lisp:39` | `Contract §2.4 A-4.  SEPARATOR-FREE BY LAW …` | contract §2.4 A-4 |
| `act0.lisp:80-81` | `W-ENV: a run VOID is not a failure of the specimen and is never reported as a pass (contract WE-04).` | **specimen** §2.1b / test plan — cited to the wrong document; see `CITATION-RESOLUTION-TABLE.md` §3 |

**Class verdict:** the four sources built in the implementation round
(`act0.lisp`, `act0-gates.lisp`, `act0-fixtures.lisp`, `package.lisp`) carry
comment law that is overwhelmingly **restatement of, or citation to, the five
documents**. The builder disciplined itself to the documents. That is real
evidence for the documents' operative authority during construction — and it is
recorded as such in `RECOVERY-DETERMINATION.md` §II.5.

---

## 3. COMMENT-ONLY LAW (category-4 candidates) — recorded verbatim, not converted

There is a **structural** reason this class is non-empty, and it is the sweep's
principal finding.

### 3.1 The structural fact

```
$ for f in act0.lisp act0-gates.lisp act0-fixtures.lisp package.lisp \
           act0-load-witnesses.lisp act0-load-witnesses.sh act0-loader-disease.sh \
           act0-selftest.lisp ; do
      printf '%-26s %s\n' "$f" "$(git log --format='%h %ad %s' --date=short --diff-filter=A -- …/$f | tail -1)" ; done
act0.lisp                  5ea01c9d 2026-08-08 One Act /0 implementation round …
act0-gates.lisp            5ea01c9d 2026-08-08 One Act /0 implementation round …
act0-fixtures.lisp         5ea01c9d 2026-08-08 One Act /0 implementation round …
package.lisp               5ea01c9d 2026-08-08 One Act /0 implementation round …
act0-load-witnesses.lisp   1cef2680 2026-08-08 One Act /0 R2.2: loader-finality repair …
act0-load-witnesses.sh     1cef2680 2026-08-08 One Act /0 R2.2: loader-finality repair …
act0-loader-disease.sh     1cef2680 2026-08-08 One Act /0 R2.2: loader-finality repair …
act0-selftest.lisp         aa8770bd 2026-08-08 One Act /0 R2.3: promotion closure …

$ git log --format='%h %s' --reverse -- _staging/oneact-candidate/ | tail -1
5ea01c9d One Act /0 implementation round …          ← LAST amendment of the five documents
```

**`5ea01c9d` is the last commit that ever touched the five documents.**
`1cef2680` (R2.2) and `aa8770bd` (R2.3) came after it and added four sources
carrying new owner-ruled law. **Therefore no law introduced by R2.2 or R2.3 can
be in the five documents — by construction.** Confirmed by search:

```
$ cd _staging/oneact-candidate
$ for p in "act0-selftest" "load-witnesses" "loader-disease" "fail closed" "fail-closed" \
           "api-complete" "act0-api" "LANE-FILES" "non-EQ" "fresh copy" "remain last" \
           "last form" "last-loaded" "sentinel" "release floor" "verify-release" \
           "through ASDF" "outside the subject tree" ; do
      printf '%-26s files=[%s]\n' "$p" "$(grep -l -i -- "$p" *.md | tr '\n' ' ')" ; done
```
→ **every one of those eighteen probes returns an empty file list.** (Controls
`ASDF`, `run root`, `planted-fault` do return hits, so the probe is not
silently broken.)

### 3.2 The hits, verbatim

**C4-01 — the fail-closed loader completion law**
`act0-load-witnesses.lisp:24-25`
> `old guard SKIPPED here.  The repaired loader must`
> `complete the lane or fail closed — never return`

**C4-02 — the API-completeness predicate must be able to be false**
`act0-load-witnesses.lisp:35`
> `70 exports satisfied.  THE PREDICATE MUST BE FALSE,`

**C4-03 — guard/witness non-divergence**
`act0-load-witnesses.lisp:55`
> `LISP-PLUS-SYSTEM, so the guard and its witness can never drift apart.`

**C4-04 — `ACT0-LANE-FILES` EQUAL-but-never-EQ, and total export binding**
`act0-load-witnesses.lisp:60`
> `but never EQ across calls, and EVERY LISP-PLUS-SYSTEM external bound as`

**C4-05 — export/binding bidirectional fail-closure**
`act0-load-witnesses.lisp:225-226`
> `count is asserted besides, so an export added without a binding, or a`
> `binding added without its export, fails closed either way.`

**C4-06 — a clean tree must produce the lawful outcome**
`act0-load-witnesses.lisp:395`
> `lawful outcome because their preconditions are hostile; a CLEAN tree must`

**C4-07 — the witness battery must be able to fail; reads only; never commits**
`act0-load-witnesses.sh:21,24`
> `check, which must make the witness exit 1.  A BATTERY THAT HAS NEVER FAILED`
> `Reads only; creates no file in the tree; never commits.`

**C4-08 — disease mutation runs on a REPLICA, never the checkout; the control must pass**
`act0-loader-disease.sh:5,7`
> `REPLICA of the subject tree (NEVER to the checkout), each required to make a`
> `same witness on an UNMUTATED replica, which must PASS — because a column of`

**C4-09 — H-AP0-COLLIDE ordering law** *(owner-ruled in R2.3 §2: "keep H-AP0-COLLIDE last"; the label `H-AP0-COLLIDE` IS in all five documents, the ordering law is not)*
`act0-selftest.lisp:29`, `act0-selftest.lisp:153`
> `H-AP0-COLLIDE (GATE-20) IS LAST, AND MUST REMAIN LAST.  Its plant is`
> `H-AP0-COLLIDE (GATE-20) IS LAST AND MUST REMAIN LAST.`

**C4-10 — the lane is entered through ASDF, never by loading; run root outside the checkout**
`act0-selftest.lisp:52,56`
> `* The lane is entered THROUGH ASDF (`lisp-plus/act0'), never by loading`
> `written there, never into the checkout.`

**C4-11 — the gates file must remain last-loaded and its readiness carrier last**
`act0-gates.lisp:1065`
> `⚠ THIS MUST REMAIN THE LAST FORM OF THIS FILE, AND THIS FILE MUST REMAIN`

**C4-12 — every declared export must have a binding of its kind**
`act0-gates.lisp:1070`
> `declared exports and checks each for the binding its kind requires.  That`

**C4-13 — successor obligation: EXTEND the declared-out-of-stack list, do not replace it**
`act0-fixtures.lisp:150`
> `A successor that DOES load one of those trees must EXTEND this list rather`

**C4-14 — the environment claim must be CHECKED at run time**
`act0-fixtures.lisp:111`
> `claim about the run, and the run must CHECK it: an environment variable that`
*(Adjacent to contract §14.2 / V-8..V-11, which specify W-ENV; the imperative
"the run must CHECK it" as an obligation on the runner is not in the documents'
wording. Borderline — recorded at the low end.)*

### 3.3 What C4-01..C4-13 have in common

They are the **R2.2 loader-finality** and **R2.3 promotion-closure** law. Their
authority is real and owner-given — it is in
`_staging/oneact-owner-ruling-r2.2-2026-08-08.md` and
`_staging/oneact-owner-ruling-r2.3-2026-08-08.md`. R2.2 verbatim (items 1-2):

> 1. Replace the package-existence guard with an explicit `act0-api-complete-p`
>    predicate covering the declared external functions, variables/constants,
>    types, and a final-source readiness carrier.
>
> 2. If the namesake package is incomplete, reapply `package.lisp`, load the
>    remaining three files in order, and assert completeness afterward. **Fail
>    closed if the predicate remains false.**

R2.3 verbatim:

> Do not add the selftest to the four-source loader. ACT0-GATES.LISP remains
> the last-loaded source and its readiness carrier remains its last form.

> - two calls return EQUAL but non-EQ lists;
> - every LISP-PLUS-SYSTEM external has at least one appropriate binding
>   (FBOUNDP, BOUNDP, or FIND-CLASS).

> - print a stable terminal sentinel:
>   `oneact0-selftest: 173 checks, 0 failures`

**But those rulings are themselves in repo-root `_staging/`**, i.e. outside the
mirrored subtree, exactly like the five documents. So this body of adopted law
currently exists publicly **only as source comments and executable behaviour.**

### 3.4 The consequence the owner should see

The recovery's stated purpose (SD-13) is that a public reader — including a
future clean-room implementer — cannot see the adopted lane's prose law.

**Publishing the five documents would not fix that.** The following adopted law
would still be invisible: fail-closed loader completion, `act0-api-complete-p`,
`ACT0-LANE-FILES` fresh-copy/non-EQ semantics, total export-binding coverage,
the gates-file-last ordering law, the ASDF-only entry rule, the run-root-outside
-the-checkout rule, the replica-only disease protocol, the H-AP0-COLLIDE
terminal-position rule, the 173-check sentinel, and release-floor registration
(97 full / 77 light).

That is roughly **one and a half rounds of adopted law** with no documentary
home. It is category-4 territory by the chair's own taxonomy — *new proposed
law, never publication recovery* — and it is **not drafted here.**

---

## 4. Non-empty result declared, and the empty searches shown anyway

| Class | Count |
|---|---|
| RESTATEMENT (in the documents) | the large majority of the 95 hits; 8 exhibited in §2 |
| **COMMENT-ONLY LAW (category-4 candidate)** | **14 recorded (C4-01 … C4-14)** |
| Converted to prose law by this sweep | **0 — prohibited and not done** |
| Missing clauses drafted by this sweep | **0 — prohibited and not done** |

The eighteen absence-probes of §3.1 are the *"show the search that returned
empty"* requirement, discharged in the direction that mattered: they are what
proves C4-01..C4-13 are absent from the documents rather than merely unnoticed.

— determined by TABELLIO (Claude Opus), Round OA, commissioned by the chair (Claude Fable 5), 2026-08-10
