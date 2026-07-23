# IANUS-AUDIT — de-infando specimen, adversarial threshold audit

**Warden:** IANUS (Fable-grade adversarial checker). **Seat:** report-only, no edits, no commits.
**Runtime:** SBCL 2.4.6 (`sbcl`), operation-checked live.
**Target:** `de-infando/{HYPOTHESIS.md, SPECIMEN.lisp, ABLATION.lisp, BASELINE.lisp}` on
`slice0.lisp` + `slice0-projection.lisp` + `slice0-transmissibility.lisp`.
**Date:** 2026-07-22.

## Baseline re-runs (regression gate)

```
$ sbcl --non-interactive --load de-infando/SPECIMEN.lisp      -> 29 passed, 0 failed, EXIT=0  ✓
$ sbcl --non-interactive --load de-promotione/SPECIMEN.lisp   -> 19 passed, 0 failed, EXIT=0  ✓
$ sbcl --non-interactive --load de-projectione-1/SPECIMEN.lisp-> 17 passed, 0 failed, EXIT=0  ✓
```

The transmissibility module's load-time whitelist extension did **not** disturb the two
earlier specimens. Counts match the expected 29 / 19 / 17.

---

## Findings (numbered; severity BLOCKER / CORRECTION / NOTE / CLEAN)

### 1. Whitelist extension: `continue-anyway` IS offerable through `with-slice0-restarts` — CORRECTION (worst finding)

**File+form:** `slice0.lisp:94` (`*slice0-restart-names*`, a plain mutable
`defparameter`), the guard at `slice0.lisp:102-103` / `156-162`, and its docstring
`slice0.lisp:157-158`; charter §9 ("**its own frozen whitelist**", "**Not offered, ever:**
`continue-anyway`"). The transmissibility module itself mutates the list at
`slice0-transmissibility.lisp:70-73`.

**Demonstration** (fresh package, no privileged access — exactly the loaded-file case the
module's own banner describes):

```lisp
(pushnew 'continue-anyway lisp-plus-slice0::*slice0-restart-names*)
;; whitelist now contains CONTINUE-ANYWAY
(handler-bind ((unsupported-promotion
                 (lambda (c) (declare (ignore c)) (invoke-restart 'continue-anyway))))
  (with-slice0-restarts ((continue-anyway () :pretending-it-was-fine))
    (raise (claim :proposition '(:gate-holds :prod) :by :me)
           :to :verified :per *semantic-proc* :considering '())))
```
```
whitelist now: (CONTINUE-ANYWAY DEFER-TRANSMISSION ... MARK-TESTIMONY-IMPOSSIBLE)
CONTINUE-ANYWAY escaped the refusal; with-slice0-restarts returned: :PRETENDING-IT-WAS-FINE
```

The macroexpansion guard `%slice0-restart-name-p` checks the **current dynamic value** of a
mutable global; any loaded code that `pushnew`s a name makes it expressible. The docstring
"`CONTINUE-ANYWAY` ... **not expressible here**" (`slice0.lisp:158`) and the charter's
"**frozen whitelist** / **not offered, ever**" are true only for programs that touch nothing
but the public surface — they are **overclaimed as written**.

**Verdict on the charter §9 closed-set claim:** overclaimed as written, **but not a
concealed defect** — the substrate's own banner (`slice0-transmissibility.lisp:63-68`)
declares this openly as "governed vocabulary extension, VISIBLE, on purpose ... part of the
escape-surface honesty this specimen records," and it falls squarely inside the R3 ceiling
(no defense against hostile same-image code). So the *packet* is honest at its stated size;
the *charter prose* is one size too strong and should be sized. Severity CORRECTION, not
BLOCKER, precisely because the escape is already on the record and the whitelist governs
lawful programs, not arbitrary same-image mutation.

**One-sentence correction (offered):** replace "frozen whitelist / not offered, ever" with —
*"The whitelist is closed against every well-formed program using only the public surface;
like the acknowledged `::` escape it is not closed against same-image code that mutates
`*slice0-restart-names*`, so `continue-anyway` is unofferable to any lawful program and
extensible only by same-image code, visibly, as recorded in the escape-surface ledger."*

---

### 2. Testimony flattening via `:mode :derivation` relabel — NOTE (lawful-by-design under R3, but "unrepresentable" overreaches)

**File+form:** witness constructor `slice0.lisp:256-287`; the level gate at `269-278` fires
**only** for `:mode :testimony`. `:derivation` and `:direct` modes are caller-declared and
trusted; `:content` is never inspected against `:for`.

**Demonstration:** an attribution wearing a derivation coat, first-order `:for`, verified:

```lisp
(defparameter *laundered*
  (witness :for '(:gate-holds :prod)            ; first-order P
           :mode :derivation                     ; NOT :testimony -> level gate skipped
           :kind :capability-check :source :operator
           :content '(:asserted :operator (:gate-holds :prod))))   ; testimony inside
(raise (claim :proposition '(:gate-holds :prod) :by :me)
       :to :verified :per *proc-admitting-derivation* :considering (list *laundered*))
;; => C2 laundered derivation verified P? T judgment=:VERIFIED
```

**Judgment — REAL hole or lawful-by-design?** *Lawful-by-design.* This is a caller lying
about the **mode** of its own evidence — the exact "caller provenance-lie" the R3 ceiling and
`BASELINE.lisp` move (iii) explicitly disclaim defending against ("no secrecy claim against
arbitrary construction"). The system provides **no flattening path**: there is no operator
that turns a `:testimony` witness into `:derivation`; the caller simply constructs a
`:derivation` witness and asserts it is derivation. Charter §6's "no **convenience path** may
flatten it" remains accurate (a convenience path is one the system offers; a mislabel is not).

**Why it is still a NOTE, not CLEAN:** teeth-3's label "flattened invocation testimony
**unrepresentable**" (`SPECIMEN.lisp:107`) is narrowly true only of the `:testimony`-labelled
construction it tests. Read as the general claim "flattened testimony cannot be represented,"
it is false — a `:derivation`/`:direct` witness for first-order P with attribution content is
trivially representable and verifies. Recommend the packet state explicitly (it is currently
only implicit in R3) that the enforcement boundary is the `:testimony` *label* alone, and that
mode fidelity for `:direct`/`:derivation` is a caller obligation the substrate does not and
cannot police under R3.

---

### 3. Immutability: accessors hand back caller-mutable structure that GOVERNS a decision — NOTE (lawful under R3; I10's `equal` check + §3 wording invite false confidence)

**File+form:** `local-value-exercise-authorized` (`slice0-transmissibility.lisp:102`, stored
verbatim at `132`, read as the auth gate at `157-159`); `local-value-recipe` (transmitted
`eq` at `slice0-transmissibility.lisp:342/360`). No defensive copy on capture or on return.

**Demonstration E1 — authorization escalation by mutating the returned list:**
```lisp
(nconc (local-value-exercise-authorized *gate*) (list :outsider))
(exercise-value *gate* :in (receiver-context :context-id :outsider) :args '(1))
;; E1 RESULT: outsider EXERCISED after mutating accessor list -> (:OK 1)
```
**Demonstration E2 — the transmitted reproduction payload is `eq` to the source recipe:**
```lisp
(multiple-value-bind (recipe r) (transmit *gate2* :from *src* :to *dst* :mode :reproduction)
  (eq recipe (local-value-recipe *gate2*))   ; => T
  (setf (second recipe) :TAMPERED))           ; mutates SOURCE governing state
;; E2 after tampering payload, SOURCE recipe = (:REBUILD :TAMPERED)
```

**Judgment:** the struct slots are `:read-only t` (you cannot reassign the slot), so §3
"read-only accessors" is *literally* true — but the **contained lists are shared and
caller-mutable**, and one of them (E1) is the live authorization gate. This is "hostile
same-image custody," which R3 explicitly does not defend. So lawful-by-design. It is a NOTE
because **specimen test I10** ("value, support, and claim **unchanged by every attempt**",
`SPECIMEN.lisp:341`) uses `equal` and would pass even if a copy had been substituted — it
verifies the slice's own ops don't mutate, not deep immutability. A reader can over-read I10's
label as "these objects are frozen." Recommend one clarifying sentence: immutability here =
read-only slots + revision discipline, **not** deep-freeze of caller-supplied substructure
(which R3 leaves open, same class as `::`). A cheap hardening if desired: `copy-tree` the
`exercise-authorized` / `recipe` lists on construction and on `reproduction` return.

---

### 4. Receipt-as-authority beyond teeth-2 — CLEAN (with one ungoverned-error NOTE)

**Hunt-3 verdict: CLEAN.** A `promotion-receipt` cannot act as a procedure or warrant.

- As `:per` in `raise`: refused by the `promotion-procedure-p` shape gate (`slice0.lisp:668`)
  — `B2 receipt-as-:per refused: MALFORMED-SLICE0-SHAPE`.
- As `:derivation` in `project-claim`: the code reads `witness-mode`/`witness-for`; a receipt
  has neither, so it cannot supply a derivation — it errors, never launders.

**Sub-NOTE (ungoverned refusal path):** passing a receipt **inside `:considering`** refuses
via a raw `TYPE-ERROR` (`witness-for` on a non-witness), not a governed `slice0-condition`:
`B3 receipt-in-considering refused: TYPE-ERROR`. No standing is conferred (safe), but the
refusal is un-typed — `raise` does not shape-check that every `:considering` element is a
`witness`. Minor; recommend a `witness-p` guard at the head of `%evaluate-promotion` for a
governed diagnostic instead of a bare type error.

---

### 5. Exercise laundering (closure returning a function) — CLEAN

**Hunt-6 verdict: CLEAN.** The `reifiable-p` gate on the raw result
(`slice0-transmissibility.lisp:172-178`) fires:
```lisp
(exercise-value (local-value :host (lambda (x) (lambda () :nope)) :authority :operator
                             :exercise-authorized :any)
                :in (receiver-context :context-id :here) :args '(1))
;; D1 closure-returning-closure refused: VALUE-NOT-REIFIABLE axis=:REIFIABILITY
```
A governed invocation cannot return a host function as its own canonical result.

---

## Per-hunt-area verdicts (explicit, including CLEAN)

1. **Scalar-ladder regression — CLEAN.** No `min/max/sort/reduce/<>` over axes or standing in
   any of the three substrates (grep of logic paths returned none). `transmission-views` /
   `projection-views` return **composable keyword lists**, not ordered ranks; `reifiability`
   is a 3-way tag `{:reifiable :not-reifiable :n/a}`, not a rung. The de-projectione `min`
   laundering joint (F4) is not reintroduced.
2. **Silent stringification — CLEAN.** Every `format nil` in the substrates writes to a
   *diagnostic string* (`failed-invariant` messages) or to an *identity name* built from an
   integer counter (`"witness-~D"`, `"local-value-~d"`) — never a host object's printed form
   carrying its identity or standing into a governed field. The specimen's `format` on the
   closure (teeth-1) is the planted misuse and is **refused** (`:kind-is-computed-not-claimed`).
3. **Receipt-as-authority — CLEAN** (see finding 4; one ungoverned-error sub-NOTE).
4. **Testimony flattening — NOTE** (finding 2): lawful-by-design under R3; teeth-3's
   "unrepresentable" is narrowly, not generally, true.
5. **Restart-whitelist extension — CORRECTION** (finding 1): the charter §9 "frozen / not
   offered ever" and the `with-slice0-restarts` docstring "not expressible here" are
   overclaimed as written; the substrate banner is honest and R3 covers it.
6. **Exercise laundering — CLEAN** (finding 5).
7. **Doc-vs-code drift — CORRECTION**, one instance, = finding 1 (charter §9 + docstring).
   Otherwise `HYPOTHESIS.md` tracks the code faithfully: the six lawful acts (§5) each map to
   a distinct granted/refused path in the specimen, and the ablation genuinely destroys the
   property (verified below). The "unrepresentable" (finding 2) and "unchanged by every
   attempt" (finding 3) labels are softer over-reads, filed as NOTES.
8. **Immutability — NOTE** (finding 3): read-only slots hold, shared substructure does not;
   lawful under R3 but the I10 `equal`-check and §3 wording can be over-read.

**Ablation sanity (property-destruction claim):**
```
$ sbcl --non-interactive --load de-infando/ABLATION.lisp
5 launderings, 0 refusals, 0 receipts — the five axes collapsed into a printer check;
the property is destroyed.
```
The ablation does what §3 of HYPOTHESIS claims: collapsing to one `:exportable` printer-check
makes the refusal branch unreachable and every laundering succeed silently. Honest.

---

## Overall verdict — is the packet honest at its stated size?

**Yes, with two prose corrections owed and two soft over-reads worth a clarifying sentence.**
The specimen earns its 29/0, the two prior specimens are undisturbed (19/0, 17/0), the ablation
genuinely destroys the property, and every teeth-gate I could reach fires. The three defects I
found that touch *governed* behavior — the offerable `continue-anyway`, the
`:derivation`-relabel testimony channel, and the mutable authorization list — are all **inside
the explicitly-declared R3 escape surface** (no defense against hostile same-image code /
caller provenance-lies), and the transmissibility banner already records the whitelist escape
"on purpose." So no BLOCKER: nothing is concealed, no result is inflated beyond what R3 licenses.
What is *not* yet honest at its size is the **charter §9 wording** ("frozen whitelist / not
offered, ever") and the twin `with-slice0-restarts` docstring ("not expressible here") — these
state as an absolute guarantee something the code enforces only for lawful programs, and my
transcript expresses the forbidden `continue-anyway` through the very macro that claims to
forbid it. That is a "conclusion wearing a check's costume" in the governing document, and it
is the one thing I would fix before banking: size the §9 claim to what the code actually holds,
and the packet is honest end to end.

— IANUS, warden of thresholds, 2026-07-22
