# The path seam — two facts a static reader must not conflate

**Integration Baseline /0 R5 · 2026-08-03**

Two properties of these probe sources defeated four rounds of static extraction. Neither is a defect
in the probes. Both are recorded here so the next reader does not rediscover them as bugs, and so
that no future inventory quietly claims more than a static reading can support.

---

## 1. `merge-pathnames "../"` against a **file** defaults pathname

Four sites:

| file | lines |
|---|---|
| `mneme/language-surface-1/errata-0.1/REPRODUCTION.lisp` | 91, 387 |
| `mneme/language-surface-1/errata-0.2/REPRODUCTION-II.lisp` | 70, 270 |

each written as

```lisp
(merge-pathnames "../" cl-user::*repro-here*)
```

where `*repro-here*` is `(or *load-truename* *default-pathname-defaults*)` — **a file pathname.**

In Common Lisp, merging against a *file* defaults **inherits that file's name and type.** So the
value of the expression is not a bare directory: it is a pathname that still carries a name and a
type component. That is the raw pathname value.

It is never used that way. The value is handed to `%as-directory` in
`mneme/language-surface-1/errata-0.3/EVIDENCE.lisp:47`, which is exactly

```lisp
(truename (make-pathname :name nil :type nil :version nil :defaults (pathname p)))
```

— it **strips name, type and version before any filesystem access.** EVIDENCE.lisp's own docstring
says so plainly: callers pass `*load-truename*` (a file) and `(merge-pathnames "../" …)` (a file
name under a parent) as freely as they pass a real directory, and the function exists because a
digest tool handed a FILE where a DIRECTORY was meant *must not silently produce something.*

**Therefore the raw pathname value and the effective I/O directory are DIFFERENT FACTS.**

Consequence, and it is the operative one: **the intermediate value must not be counted as a missing
runtime dependency.** R4 did exactly that. A static extractor that reads the literal, merges it
against the source file, and then asks the filesystem whether the result exists is asking about a
pathname the program never opens. No inventory in this lane may make that inference again.

---

## 2. `P7-intern-reach.lisp` expands five filenames dynamically

`mneme/language-surface-1/audits/2026-07-28-stranger-audit/probes/FOSSOR/P7-intern-reach.lisp`,
lines 4–8:

```lisp
(dolist (f '("STUB-IMAGE-FIXTURE.lisp" "de-expansione-testata/APPLICATION.lisp"
             "errata-0.1/REPRODUCTION.lisp" "errata-0.2/REPRODUCTION-II.lisp"
             "surface1-selftest.lisp"))
  (let ((path (merge-pathnames f cl-user::*s1dir*)) …)
    (with-open-file (in path) …
```

The five targets are recorded here, as the commission requires:

```
STUB-IMAGE-FIXTURE.lisp
de-expansione-testata/APPLICATION.lisp
errata-0.1/REPRODUCTION.lisp
errata-0.2/REPRODUCTION-II.lisp
surface1-selftest.lisp
```

The `with-open-file` target is built inside the loop, from a list element. **No `merge-pathnames`
literal appears at the open site**, so every static extractor R1–R4 wrote saw *one* attempted
subject for this file where the program opens *five*.

**Consequence: no exhaustive global attempted-subject cardinality is claimed, here or anywhere.**
The inventory is bounded and static by design — one row per frozen path, a category, a locator and
a hashed snippet. It counts **files**, which it can see; it does not count **attempted subjects**,
which in general it cannot. R1–R4's published cardinalities were not exhaustive, and the property
that made them non-exhaustive is written above so the claim cannot be revived by accident.

---

## What both facts have in common

A static reader can see **what a source says**. It cannot see **what the program does** without
becoming an interpreter of the language and of the host it ran on. The retired census straddled that
line and reported the wrong side of it as measurement. This note marks the line; the inventory stays
on the side of it that a hash can defend.

---

*Recorded because the next reader would otherwise find these twice: once as a puzzle, once as a bug
that was never there.*
