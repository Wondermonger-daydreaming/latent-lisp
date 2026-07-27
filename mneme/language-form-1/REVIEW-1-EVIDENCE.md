# LANGUAGE FORM /1 — REVIEW 1 — THE BEFORE-REPAIR EVIDENCE

*Claude Opus 5 (1M context), 2026-07-27, under the owner ruling
`LANGUAGE FORM /1 REVIEW 1`.*

```
subject branch    language-form-1-candidate-0
subject tip       7db2da94   (unchanged when every capture below was taken)
SBCL              2.4.6, operation-checked through the wrapper
merged            no        published   no
```

**THIS DOCUMENT EXISTS BECAUSE A REPAIRED DEFECT LEAVES NO TRACE.** After the
repair, NC-31 passes; after the repair, checks [46] and [129] print `ok`. A
reader of the green run cannot tell a tooth that was always sound from one that
was hollow last Tuesday, and cannot tell a control that always separated from
one that used to collapse. The ruling's §1 requires the before-state preserved
as a *witness*, not summarised as a memory — so every figure below was captured
by **executing the unmodified tip**, and the captures are committed beside it.

**The ruling's own sentence governs the whole file:**

> Honest documentation of that behaviour does not make the identity adequate.

---

## 0. The captures, and what each one is

| artifact | what it is | runs against |
|---|---|---|
| `REVIEW-1-NC31-BEFORE.lisp` | the before-witness program | **the pre-repair API only** — frozen, see §1.5 |
| `REVIEW-1-NC31-BEFORE-RUN.txt` | **THE RECORD.** its capture at tip `7db2da94` | — |
| `REVIEW-1-NC31-AFTER.lisp` | the same fixture, split into NC-31A / NC-31B | the repaired layer |
| `REVIEW-1-NC31-AFTER-RUN.txt` | its capture | — |
| `REVIEW-1-HOLLOW-CHECKS.lisp` | both forms of [46] and [129], side by side, executed | both (one migrated line) |
| `REVIEW-1-HOLLOW-CHECKS-AT-TIP.txt` | its capture **against the unmodified tip** | — |
| `REVIEW-1-HOLLOW-CHECKS-AFTER-REPAIR.txt` | its capture after the repair | — |

Nothing here asserts, passes or fails. These files **record**. The teeth live in
`form1-selftest.lisp`; this is the evidence they replaced.

---

## 1. NC-31, EXACTLY AS IT BEHAVED BEFORE THE REPAIR

### 1.1 The fixture

Two sealed contexts, one petition, one submission act, one asserting principal.
The construction is transcribed from `form1-selftest.lisp` §K, so this records
**the same fixture the suite ran** and not a lookalike.

```
petition          one schema ref, one conclusion ref, one support ref, one receiver ref
context A         support bound to a witness FOR (:volume-scanned-at-desk (:volume "PLUT-7"))
context B         support bound to a witness FOR (:volume-scanned-at-desk (:volume "WRONG-31"))
both sealed with  id(ns=["form1-selftest"], path=["ctx","nc31-shared"])
```

The schema's premise is `(:volume-scanned-at-desk (:volume (:var :volume)))` and
the conclusion binding is about `PLUT-7`, so **A's witness discharges the premise
and B's does not.** That single binding decides the outcome.

### 1.2 The complete context identities

Under policy v2 a sealed context had exactly one identity-bearing field, and it
was the datum the host handed to `SEAL-RESOLUTION-CONTEXT`:

```
context A   id(ns=["form1-selftest"],path=["ctx","nc31-shared"])
            4c5043440022010e666f726d312d73656c667465737402036374780b6e6333312d736861726564

context B   id(ns=["form1-selftest"],path=["ctx","nc31-shared"])
            4c5043440022010e666f726d312d73656c667465737402036374780b6e6333312d736861726564

comparison  IDENTICAL — byte for byte
```

**That was the whole of a context's identity.** Not derived from anything the
context contained; supplied, verbatim, by the host.

### 1.3 What the public context reader exposed, and what it omitted

There was exactly one public aggregate reader:
`DERIVATION-RESOLUTION-CONTEXT-BOUND-REFERENCES`. It returned `(ROLE REFERENCE)`
per binding and **dropped the `cdr`** — the bound value.

```
reader output, context A            reader output, context B
  (:SCHEMA     ref/schema/s)          (:SCHEMA     ref/schema/s)
  (:CONCLUSION ref/conclusion/c)      (:CONCLUSION ref/conclusion/c)
  (:SUPPORT    ref/support/w1)        (:SUPPORT    ref/support/w1)
  (:RECEIVER   ref/receiver/r)        (:RECEIVER   ref/receiver/r)

entry count            4 / 4
element-wise           IDENTICAL
```

```
EXPOSED   role · reference identifier
OMITTED   the bound live object, AND any durable declaration of what that
          object was intended to denote — there was no such declaration to
          omit, because the layer never asked for one.
```

**Dropping the live value was the right call** — an aggregate reader that
aliases live host objects out of a sealed context is a mutable-table escape.
The defect was not that the value was dropped. It was that **nothing was
recorded in its place**, so from the public surface contexts A and B were
indistinguishable and no durable field could separate them.

### 1.4 The two submissions, and the identities they produced

Held fixed on purpose, so that none of them can be what separates the two acts:

```
petition occurrence identity   656 octets · SHARED (one petition, submitted twice)
submission act id              id(ns=["form1-selftest"],path=["act","1"])   IDENTICAL
:BY-ID declaration             id(ns=["form1-selftest"],path=["by","clerk"]) IDENTICAL
live :BY value                 :DESK-CLERK                                   IDENTICAL
```

Varied on purpose:

```
live support binding    witness-1 FOR (… (:volume "PLUT-7"))  vs  witness-2 FOR (… (:volume "WRONG-31"))
live receiver binding   a desk over each witness list         DIFFERENT objects
```

And the result:

```
                                 submission A        submission B
SUBMISSION OCCURRENCE IDENTITY   838 octets          838 octets     >>> IDENTICAL <<<
SUBMISSION RECEIPT IDENTITY      982 octets          1009 octets        differ
GOVERNED OUTCOME                 :GRANTED            :GOVERNED-REFUSAL  OPPOSITE
```

The complete 838-octet submission occurrence identities are printed in full, in
hexadecimal, in `REVIEW-1-NC31-BEFORE-RUN.txt` §3. They are byte-identical.

**On the receipt identities differing — this must not be read as a rescue.**
They differ only because the receipt identity is built *after* the act, from the
occurrence identity plus the outcome kind plus the Slice /2 receipt identity.
Factor out what Slice /2 contributed and the two records are the same record.
The difference is Slice /2's image-local ordinal moving, which is a property of
Slice /2's naming, not a Form /1 guarantee — and had both acts been refused at
the same door, it would not have been there at all.

### 1.5 The exact Slice /2 outcomes

```
OUTCOME A
  kind                       :GRANTED
  claim proposition          (:PREDICATE :VOLUME-RESHELVED (:VOLUME "PLUT-7"))
  Slice /2 receipt identity  id(ns=["lisp-plus-kernel0","identity"],
                                path=["receipt","slice2-receipt-1"])
  Slice /2 condition class   (none)
  Slice /2 receipt decision  :GRANTED
  strongest lawful result    :VERIFIED

OUTCOME B
  kind                       :GOVERNED-REFUSAL
  claim proposition          :NONE
  Slice /2 receipt identity  id(ns=["lisp-plus-kernel0","identity"],
                                path=["receipt","slice2-receipt-3"])
  Slice /2 condition class   LISP-PLUS-SLICE2:SLICE2-DERIVATION-REFUSED
  Slice /2 condition report  admission-aware derivation under Slice /2 schema
                             :VOLUME-RESHELVED/2 v0 refused:
                             VOLUME-SCANNED-AT-DESK=MISMATCHED
  Slice /2 receipt decision  :REFUSED
  strongest lawful result    (:BLOCKED-ON :VOLUME-SCANNED-AT-DESK :MISMATCHED)
```

Two governed acts. Opposite results. **One durable submission occurrence
identity.**

### 1.6 Which bound values differed

| role | reference | context A | context B | |
|---|---|---|---|---|
| `:SCHEMA` | `ref/schema/s` | the same `slice2-schema` | the same `slice2-schema` | SAME (`EQ`) |
| `:CONCLUSION` | `ref/conclusion/c` | `:volume-reshelved PLUT-7` | `:volume-reshelved PLUT-7` | equal, distinct objects |
| `:SUPPORT` | `ref/support/w1` | `witness-1` / `PLUT-7` | `witness-2` / `WRONG-31` | **DIFFERENT** |
| `:RECEIVER` | `ref/receiver/r` | desk over the PLUT-7 witness | desk over the WRONG-31 witness | **DIFFERENT** |

### 1.7 The before-witness is frozen, and why

`REVIEW-1-NC31-BEFORE.lisp` **no longer loads against the repaired layer**, by
design. It calls the policy v2 binders, which took three arguments; v3 binders
take four — the denotation declaration whose absence is the defect the file
records. Migrating it would destroy the thing it is for: a witness written in
the vocabulary of the world before the repair. Its capture is the record; to
re-run it, check out `7db2da94`.

Its companion `REVIEW-1-NC31-AFTER.lisp` runs the same fixture against the
repaired layer:

```
                                    NC-31A              NC-31B
                                    (diff declarations) (same declaration)
context occurrence TAGS             IDENTICAL           IDENTICAL
support DENOTATION DECLARATIONS     DIFFERENT           IDENTICAL
context DECLARATION identities      DIFFERENT (397/399) IDENTICAL (392/392)
context OCCURRENCE identities       DIFFERENT           IDENTICAL
SUBMISSION OCCURRENCE identities    DIFFERENT (1324/1326) IDENTICAL (1319/1319)
GOVERNED OUTCOMES                   OPPOSITE            OPPOSITE
```

**A is the repair. B is the residual.** Neither licenses the other.

---

## 2. THE TWO HOLLOW CHECKS — BEFORE AND AFTER, EXECUTED

The ruling: *"Do not quietly absorb FANG's findings into the final suite."* So
both forms of each check live in `REVIEW-1-HOLLOW-CHECKS.lisp`, **executable**,
run against a discriminating pair of worlds. A hollow check is one that cannot
fail; the only way to show a check is not hollow is to exhibit a world in which
it does fail, and every row below is that exhibition, run.

### 2.1 Check [46] — the drift-ceiling tooth

**The claim its label made:** *"BYTES-DATUM-VALUE hands back a COPY, so no
public caller can force real drift."*

**Shipped form** (commit `295f9fba`):
```lisp
(let ((first-read (cd0:bytes-datum-value identity)))
  (fill first-read 0)
  (cd0:equal-datum identity
                   (cd0:make-bytes-datum (cd0:bytes-datum-value identity))))
```

**Repaired form** (commit `7db2da94`):
```lisp
(let ((first-read (cd0:bytes-datum-value identity)))
  (fill first-read 0)
  (notevery #'zerop (cd0:bytes-datum-value identity)))
```

Executed against the real accessor and against a **faithful** aliasing accessor
— one that returns the datum's *actual internal store*, uncopied, which is what
CD/0 would do if its copy-on-access guarantee were ever lost:

```
form                  REAL   ALIASING(faithful)  verdict
OLD [46] (shipped)     T          T              *** CANNOT FAIL — HOLLOW ***
NEW [46] (repaired)    T          NIL            DISCRIMINATES
```

**Why the shipped form could not fail:** it filled the *first* read, then
compared the store against a datum rebuilt from a *second* read. Under an
aliasing accessor **both sides are the same zeroed vector**, so equality holds.
It demonstrated that `MAKE-BYTES-DATUM ∘ BYTES-DATUM-VALUE` round-trips. Its
label claimed it demonstrated defensive copying.

**The chair's own wrong instrument, preserved and still running.** The first
teeth-check harness aliased the accessor's *return* across calls but left the
datum's internal store untouched, so `equal-datum` still read good bytes:

```
form                  REAL   ALIASING(UNFAITHFUL)  verdict
OLD [46] (shipped)     T          NIL              REPORTED DISCRIMINATING — WRONG
```

Under it the shipped [46] appeared sound, **which would have made the entire
hollow-tooth finding a false alarm.** It was caught only because its answer
disagreed with a report the chair had reason to trust. *A simulation standing in
for the thing simulated*, inside the review whose subject is exactly that. It is
kept as a live control rather than an anecdote.

**The standing of the repaired form, stated at its size:** it is a **TRIPWIRE ON
AN IMPORTED GUARANTEE, not Form /1 coverage.** CD/0's copy-on-access is pinned
by CD/0's own suite and by the Python seed; if it regressed, **CD/0's** suite is
what goes red. [46] exists so Form /1 does not keep printing green while the
threat model beneath it has changed.

### 2.2 Check [129] — NC-34, the no-values-at-all tooth

**The claim its label made:** *"the escaping path returned NO values at all."*

**Shipped form** (commit `295f9fba`):
```lisp
(notany (lambda (entry) (eq :escape-should-not-log (getf entry :label)))
        *submission-log*)
```

**Vacuous twice over, both folds executed:**

```
                                            OLD [129]
log as the suite actually builds it            T
log WITH the hunted label, as a STRING         T      <- fold 1: TYPE
log WITH the hunted label, as a KEYWORD        NIL

(eq :escape-should-not-log "escape-should-not-log")  =>  NIL
```

1. **TYPE.** The predicate compared a *keyword* against values that are always
   *strings* — every call site passes a string literal as the label — so `eq`
   was `NIL` for every entry any fixture could produce, and `notany` was `T`
   regardless of what the layer did.
2. **PROVENANCE.** Even under the keyword representation, it could only fail if
   some call site passed `:ESCAPE-SHOULD-NOT-LOG` as a label. **No call site
   ever did, in any representation.** The world in which it returns `NIL` was
   never constructible by the suite.

**Repaired form**, and the world in which it does fail:

```
malformed conclusion (SHOULD escape)   NEW [129] -> T
valid conclusion     (SHOULD return)   NEW [129] -> NIL      DISCRIMINATES
```

---

## 3. WHAT THIS EVIDENCE DOES *NOT* ESTABLISH

Stated here rather than left to be inferred, because a preserved-evidence
document is exactly the kind of artifact that acquires unearned authority.

- **It does not establish that the repair is complete.** It establishes what the
  pre-repair behaviour was. Whether the repair is adequate is the business of
  the suite, the injectivity census, the condition partition and the owed
  stranger audit — not of this file.
- **It does not establish that [46] and [129] were the only hollow checks.**
  Two were found by an adversarial pass over 168. The exhaustive instrument —
  the verdict-liveness sweep — is a separate deliverable, and it establishes
  only that every rendered verdict is *connected to the suite's failure result*.
  **It does not establish that any predicate measures its label**, and both of
  these hollow checks would have been forced red by it successfully.
- **It does not establish that NC-31B is the last residual.** It is the one this
  fixture exhibits. A residual nobody has constructed a fixture for is not
  thereby absent.
- **The chair authored every artifact in this file, including the account of the
  chair's own error.** A self-authored confession is still testimony. The
  captures are the evidence; the prose around them is argument.

---

*— Claude Opus 5 (1M context), 2026-07-27. Captured against tip `7db2da94`
before any executable code was changed.*
