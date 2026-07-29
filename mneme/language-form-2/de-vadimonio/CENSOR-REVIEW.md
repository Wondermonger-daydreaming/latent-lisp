# de-vadimonio — CENSOR REVIEW

*CENSOR (Claude Fable 5), 2026-07-29. Adversarial review of
`experiments/latent-lisp/mneme/language-form-2/de-vadimonio/` under the six
charges. Every finding below is labeled **EXECUTED** (probe run in this
session, output quoted or summarized from a run I performed) or **REASONED**
(not executed — a hypothesis). Nothing in the repo was modified: every probe
ran on copies under the session scratchpad
(`…/scratchpad/censor/{base,r1-tamper,r2-slot,r3-content,r4-conjunct,r5-alias,r5b-alias3,recon}/`),
each copy differing from the shipped file only by absolute load paths plus the
one stated inversion (diffs verified before each run).*

**Baseline (EXECUTED):** fresh run of the shipped `APPLICATION.lisp` →
100 checks / 0 failed, exit 0, transcript **byte-identical** to the committed
`SPECIMEN-RUN.txt` (`diff` clean); `SPECIMEN-RUN-EXITCODE.txt` agrees with the
observed exit; `check-transcript.sh` → exit 0, `RECONCILIATION CLEAN`. The
builder's numbers reproduce exactly.

---

## Findings, ranked by severity

### F-1 · The four ALIASING teeth are furniture — their green does not depend on the snapshot behavior they certify — **EXECUTED**

Checks **[073]–[076]** (`APPLICATION.lisp:1454–1467`, the `no-alias` macrolet)
cannot fail for *any consistent reader implementation*:

```lisp
(let* ((before (,reader ,object))
       (view   (,reader ,object)))
  (when (consp view) (setf (car view) :tampered))
  (and (consp before) (equal before (,reader ,object))))
```

If the reader snapshots, `before` is an untouched copy → equal → pass. If the
reader **aliases** (returns the stored cons), `before`, `view`, and the third
read are the *same object*; the mutation moves all three together → the
comparison is a self-comparison → **pass**. The only implementation the tooth
could catch is one that nondeterministically alternates aliasing and copying.

**Probe (r5b):** removed `%snapshot` from three of the four aggregate readers
(`appearance-receipt-witness-facts`, `desertion-record-refusal-facts`,
`vadimonium-refusal-offending`) — the exact de-pignore D1 defect reintroduced.
Result: **100 checks / 0 failed, exit 0**, all four ALIASING checks rendered
`ok`, ALIASING 5 `ok`. **Probe (r5):** all four readers aliased, including
`vadimonium-retained-expectations`. Checks [073]–[078] all rendered `ok`; the
run then **crashed** far downstream (section P, `equal-datum` on NIL), not
because any aliasing check fired but because ALIASING 1's tamper had corrupted
the stored expectations plist that `try-present-appearance` later `getf`s —
i.e. with an aliasing reader a caller can genuinely **move the retained rule**
(a should-close-but-refused, or a crash), and the teeth still say `ok`.

The shipped defense itself is real — **EXECUTED** (probe2): the shipped readers
return fresh copies per call (`not (eq view1 view2)` → T), and a *correct*
tooth (`copy-tree` the before-value, then mutate a view, then compare the
stored state) passes against the shipped file. So: **defense present, teeth
hollow.** The correct tooth shape is exactly that `copy-tree` variant.

**Inheritance note (REASONED, from reading, not executed against de-pignore):**
`de-pignore/APPLICATION.lisp:955–988` uses the identical
`before`/`view`/`equal` shape for its reader teeth 1–7 — the teeth that
certified de-pignore's D1 repair share this defect, and there the exposure is
worse: de-pignore's identities are host lists compared with `EQUAL` in its
fold, so aliasing there reaches the fold's own comparanda. That is de-pignore's
review's business; recorded here because the specimen imported the tooth shape
as precedent ("de-pignore D1", `APPLICATION.lisp:293`, `:326–328`).

### F-2 · Charge 1, part 1: the fold never reads the receipt's own procedure slots — or its previous-commitment — and check 072 tests the implementation's decision back to itself — **EXECUTED**

`%receipt-closes-p` (`APPLICATION.lisp:524–530`) has exactly four conjuncts:
occurrence identity, content identity, `:appeared`, residue NIL. The
`appearance-receipt` struct carries `procedure-identity`, `procedure-version`,
and `previous-commitment` slots (`:298–299`, `:295`) that **no closing path
ever consults**. Compare de-pignore's fold (`de-pignore/APPLICATION.lisp:549–557`):
**eight** conjuncts, including `procedure-id`, `procedure-version`, and
`previous :owed` checked **on the receipt itself**.

**Probe A1 (EXECUTED):** a receipt built with
`:procedure-identity (%text "NOT-THIS-PROCEDURE-AT-ALL") :procedure-version 99`
but carrying the copied correct occurrence+content identities **closes**
vadimonium-2 (`owed-p → NIL`). **Probe A2 (EXECUTED):** a receipt with
`:previous-commitment :never-owed` also closes.

So D-1's guarantee — "a differently-procedured receipt cannot close" — holds
only for a receipt whose content identity was *computed under* a different
procedure. A receipt that *declares* a foreign procedure in its own slots while
copying the right bytes closes fine. Check **[072]** plants only the former
(content recomputed with `policy-version 99`, `:1427–1444`), i.e. it certifies
that `%identity` over two different input lists yields different bytes — a
CD/0 injectivity property — and never exercises the receipt-slot direction that
de-pignore's conjuncts 3–5 covered. **Check 072 tests the implementation's own
decision (what it put in the list), not the law (what may close).** Whether
receipt-level provenance *should* gate closure is arguable under the tree's own
"a receipt is an account, not an authentication" doctrine — but then the dead
slots and D-1's fold-strength claim ("strictly stronger", `:236`,
BUILD-REPORT §4 D-1) overstate: it is strictly stronger *about vadimonium
identity*, strictly **weaker than de-pignore about receipt anatomy**.

### F-3 · Charge 1, part 2: the content-identity composition is pinned by nothing — components can silently leave (or enter) with the whole suite green — **EXECUTED**

`%content-identity` (`APPLICATION.lisp:238–250`) is the only place the list
lives; nothing outside the file constrains it (the builder's own §8 concern,
confirmed).

**Probe (r3-content):** removed **both `intent` and `scope`** from the
`%content-identity` list (the two §6-enumerated components that exist nowhere
else in any identity). Result: **100 checks / 0 failed, exit 0** — including
both IDENTITY SPLIT checks ([018]/[019]) and check [072]. No check in the suite
is sensitive to which semantic components the content identity carries, because
no fixture ever varies intent or scope while holding the rest fixed.

**Consequence (REASONED):** with scope (or intent) absent, two undertakings
over the same receipt/successor differing *only* in scope, under the same
act-id, would collide in both occurrence and content identity — one's
appearance receipt would close the other. Exactly the "should be refused but
closes" class the charge asked for; the suite as shipped would not notice the
edit that enables it. The composition is correct **today** (probe A3, EXECUTED:
intent/scope swap yields distinct identities; A4: occurrence ≠ content for both
vadimonia) — but the suite certifies none of it. Minimal repair: one check per
§6 component asserting that varying it alone changes the content identity.

### F-4 · The HISTORY TRUTH checks compare post-discharge to post-discharge — the "before" is captured after the kindred discharge — **EXECUTED**

DESIGN-NOTE §7 promises: "checked by byte-comparing the desertion record's
identity and every reader **before and after** the kindred discharge." In the
file, the discharge (the appearance mint) happens at `APPLICATION.lisp:1309`;
the "before" snapshots are taken at `:1357–1359` — **after** it. Checks
**[057]–[060]** therefore compare two reads both taken after the event they
claim to bracket, milliseconds apart with nothing between.

**Probe (r1-tamper):** inserted
`(setf (car (%desertion-refusal-facts *desertion*)) :censor-tampered)` after
the discharge and before the capture — simulating exactly the
mutation-during-discharge the checks exist to catch. Result: **100 / 0, exit
0**; all four HISTORY TRUTH checks `ok` while the desertion record's stored
facts sat corrupted (its first key destroyed). A discharge that rewrote the
desertion record would be invisible to this suite. (The identity check [057]
does carry some weight — the identity bytes were minted at desertion time and
re-derived — but the reader-comparison checks [058]–[059] are pure
read-twice-in-a-row.) Repair: capture the before-values in section D, at
desertion time, before section I runs.

### F-5 · RECORD-DESERTION binds the refusal to nothing — cross-desertion is accepted and undeclared — **EXECUTED**

`try-record-desertion` (`APPLICATION.lisp:655–710`) checks: vadimonium-p,
act-id datum-p, `petition-refusal-p`, still-owed. It never relates the refusal
to the vadimonium's awaited successor — no analogue of the binding UNDERTAKE
checks (`:successor-identity-mismatch`) or PRESENT checks
(`:subject-identity-mismatch`).

**Probe E1/E2 (EXECUTED):** `*s1-refusal*` — Form /1's refusal of **S1** —
records cleanly as a desertion of **vadimonium-2**, whose successor S2
validates fine; the minted record carries vad-2's occurrence/content identities
plus S1's refusal facts (`:malformed-reference`) as if that were vad-2's own
journey. Yet the refusal detail text claims "a desertion records **the exact
Form /1 refusal the successor met**" (`:672`), and the section header calls it
"the truthful record of a failed appearance" (`:643`). The record is an
account, not an authentication — but unlike the other two unenforceables in
this file (replayed act-ids, `:1082–1084`; global exactly-once, section P),
this ceiling is **stated nowhere**: not in the header's does-not-show list, not
in §10 of the design note. Possibly unenforceable in principle (a `:propose`
refusal may not carry the subject's identity through public readers — REASONED,
not verified against Form /1's reader surface), in which case the repair is a
declaration, not code.

### F-6 · Check [095] counts read-only declarations; it does not bind "all slots" — **EXECUTED**

Label: "all 33 record slots in this file are declared read-only". Predicate
(`:1631–1636`): count occurrences of `":READ-ONLY T"` == 33, plus no
`(SETF (%`. **Probe (r2-slot):** added a 34th, **mutable** slot
(`censor-mutable-slot`) to `vadimonium-refusal` → **100 / 0, exit 0**, check
[095] still `ok`. The hard-coded 33 makes the check a fossil-count: it pins
"exactly 33 read-only declarations exist," not "every slot is read-only." A
binding version would enumerate slots per defstruct or use introspection.
(Same class, lower stakes: check [098] — the external-symbol census — can never
fail in a completed run, since a non-external name is a load error; its label
admits this. Furniture, honestly labeled.)

### F-7 · Charge 6: the reconciler — walked, teeth confirmed, boundary mapped — **EXECUTED**

- Ran `check-transcript.sh` against the shipped artifacts: exit 0, output
  matches the committed `RUN-TRANSCRIPT-CHECK.txt`.
- Re-ran the specimen: transcript **byte-identical** to `SPECIMEN-RUN.txt`,
  exit 0 == the recorded exit. `SPECIMEN-RUN-EXITCODE.txt` has not drifted; and
  because the run is fully deterministic, drift *would* be detectable by
  exactly this re-run — but note nothing mechanical performs it; the
  reconciler deliberately re-executes nothing, so the exit-record's tie to
  reality rests on the runner's honesty plus anyone repeating my diff.
- **Novel planted faults** (on copies, baseline restored and re-verified clean
  after each):
  | fault (mine, not among the builder's eight) | reconciler |
  |---|---|
  | X1 — a verdict **label rewritten** wholesale, number+`ok` kept | **exit 0 (passes)** |
  | X2 — transcript truncated at the footer (all 100 `ok` lines still present, footer gone) | exit 1 (caught) |
  | X3 — one verdict line duplicated verbatim | exit 1 (caught, out-of-sequence) |
  | X4 — forged verdict lines appended **after** the footer | **exit 0 (passes)** |
  | X5 — consistent forgery: check 50 deleted, remainder renumbered 1..99, footer adjusted to 99/0 | **exit 0 (passes)** |

  What it certifies: internal consistency of one capture (count, numbering,
  verdict-word discipline, footer agreement, exit agreement, banner presence).
  What it cannot certify — by its own honest disclaimer, now demonstrated:
  label content, post-footer content, and **any self-consistent forgery**. The
  actual anti-forgery guarantees are git tracking plus deterministic
  re-runnability, both of which held under my hands. The builder's eight faults
  all reproduce as claimed (I re-ran the class representatives; X2/X3 extend
  them; X1/X4/X5 mark the boundary).

### F-8 · Charge 4: the fold under adversarial histories — behaves as documented — **EXECUTED**

All probes passed as the docstrings predict:
- Garbage tolerance: history of `NIL`, keywords, deeply nested lists, foreign
  records (Form /2 receipt, bare datum, desertion, refusal, a *list containing*
  the receipt) → still owed (C1). Closing receipt found at any position;
  duplicates harmless; result order-independent over the same multiset (C2,
  C3) — the docstring's "ordered history" is accurate but the order is never
  *used* by this fold (no contradiction; noted).
- Duplicated receipts handed to `try-present` → `:already-appeared` (C8).
- vad-2's real receipt in vad-1's history → vad-1 stays owed (C9); cross-plants
  in both directions already in-suite ([070]).
- Non-list and dotted histories **escape** as host type errors (C4, C5) —
  consistent with the escape doctrine, though unstated.
- Asymmetric guard on `vadimonium-owed-p` itself: a garbage subject **escapes**
  when the history contains a receipt (C6) but silently returns OWED against an
  empty history (C7). The `try-` surfaces are guarded; the fold is not. Minor;
  worth one line in the header.
- Shared structure (the de-pignore D1 vector): the receipt's target identities
  are **EQ** — the same objects — as the vadimonium's (D1), so the fold's
  central comparison is object-to-itself; but mutation through every public
  avenue fails (D2 — octets reader yields copies; fold unmoved). Safe **because
  CD/0 is immutable-by-copy-on-access** — a guarantee this file leans on and
  correctly attributes (`:330–334`, check [078]).
- Refusal-order semantics: closed history + garbage witness →
  `:already-appeared`, not `:not-a-validated-form` (F1) — owedness is checked
  before witness type; benign, undocumented.
- Fold-conjunct teeth genuinely bite: dropping the residue conjunct turned
  exactly check [068] red, exit 1 (r4-conjunct, EXECUTED). Escape checks
  [084]–[086] bind their behavior directly (REASONED — laundering would set
  `laundered` non-nil and redden them; not separately executed).

### F-9 · Charge 3: office-stealing — substantially clean; two vocabulary notes — **EXECUTED (grep) + REASONED (judgment)**

No receipt, reader, print line, or check label promotes the vadimonium toward
validity, entitlement, or standing; the denials are executable controls, not
prose ([002] substrate-independence; [048]–[051] the submission receipt names
Form /1's procedure and the O-control reaches the same outcome kind with no
vadimonium; [063] in r3's numbering). "Recognized" appears twice
(`:552`, `:1312`), both times bound to "under the rule they retained" — no
promotion. Notes:
1. **"discharge"** is declared avoided as Slice /1 premise vocabulary
   (DESIGN-NOTE §11; `APPLICATION.lisp:269–271` refuses it in the *type name*)
   — yet it appears in two rendered **check labels** ([057] "after the kindred
   discharge", [059]) and ~10 comments, and 11 times in the design note itself.
   The discipline as practiced is names-only; §11 does not say so. Cheap fix:
   either say "names-only" in §11 or sweep the labels.
2. **"lawful"** (`:971`, `:1142–1163`) describes replacement *values* as
   "lawful CD/0 datum / lawful reference" — CD/0 well-formedness, not Form /1
   validity; borderline vocabulary reach, no standing claim.
3. DESIGN-NOTE §4's defense "the successor is complete and **well-formed**;
   what it lacks is standing" is **false of S1**, which Form /1 refuses at
   `:propose` with `:malformed-reference`, category `:grammar` (transcript
   [021]–[022]). It is true of S2 only. This overclaim lives in the
   second-tenant argument — see F-10.

### F-10 · Charge 5: the second-inhabitant question — **the second tenant stands**, with one cap — EXECUTED distinctions, REASONED judgment

**Steelman (a) — "de-pignore's elected-evidentiary-requirement with the
evidence relation swapped for identity equality."** The shared skeleton is
conceded *by design* (election + retained expectation + fold; DESIGN-NOTE §3:
"the honest size is the same as de-pignore's"). The claim under test is a
different *tenant*, not a different mechanism. And the swap is not a parameter
change; it is a change in kind, visible in executed behavior:
- **Recognition consults different worlds.** de-pignore's reconciliation runs
  the live substrate *inside the transition* (`%probe-admission` through the
  real `derive/2`, plus a liveness anchor and contract-drift check —
  `de-pignore/APPLICATION.lisp:426–503`): its truth is indexed to
  reconciliation time and can be defeated by registry mutation between election
  and reconcile. de-vadimonio's recognition executes **no substrate call**:
  it compares a pre-produced witness's recorded facts against retained
  expectations by byte equality (`:583–606`). One is an admissibility *event*;
  the other is an identity *fact*. A test separates them: mutate the world
  between election and closing — de-pignore's answer changes, de-vadimonio's
  cannot (its drift conjuncts compare the witness's own recorded rule, [044]–[045]).
- **Opening evidence has opposite valence from a different layer.** Pledge
  requires the exact *refused* Slice /2 receipt (`:missing` premise);
  undertake requires a *successful* Form /2 receipt plus the successor datum
  with a checked identity binding ([015], NC [018]). One tenant is born of the
  world refusing; the other is born of the world succeeding — *because* the
  success is what destroyed standing.
- **The span crosses the amnesia.** The retained expectations are Form /1's;
  the opening subject is Form /2's; nothing but the vadimonium joins them —
  executed at undertake (`:465–482`). de-pignore never leaves Slice /2's world.
- **A record species with no analogue.** The desertion record — a persistent,
  identity-bearing history entry minted from the substrate's own refusal, that
  never closes — has no de-pignore counterpart (its refusals are transition
  returns, not history records). Weakened by F-5 (unbound), but real.

**Steelman (b) — "ordinary program-form incompleteness wearing a toga."** Its
best case is the specimen's own vadimonium-1: S1 *is* a broken program (F-9.3
— grammatically malformed, not merely standing-less), and vadimonium-1 is
precisely "an obligation over a program awaiting repair." But the collapse
requires that *repair discharges the obligation* — that is what
awaiting-repair means. Executed evidence kills it: S2, the repair of S1,
validated by real Form /1, is **refused** for vadimonium-1
(`:subject-identity-mismatch`, check [040]; probes C9, cross-1) — descent is
not identity; the vadimonium attaches to exact bytes, not to a project, and a
deserted vadimonium over an unvalidatable successor is *permanently
undischargeable* — the opposite of incompleteness-awaiting-repair, which is
completable by construction. "Poetic closure" fails for the same reason from
the other side: nothing similar, kindred, or narratively satisfying closes
anything ([037]–[041], the far-match by the same test as the near ones).

**Judgment:** neither collapse holds. The tenant is genuinely second: opens
from success, spans two layers, recognizes by identity rather than by
admissibility-event, and carries a record species de-pignore lacks. **Cap:**
DESIGN-NOTE §4's "the successor is complete and well-formed" must be repaired
to claim it only of the discharging branch — as written it hands steelman (b)
its opening; and the second tenant's *distinctness* is a difference in
relation and span, not in mechanism — the return should say so in those words,
since a stranger reading "structurally different tenant" could take more.

---

## What the apparatus can and cannot certify (charge 6 summary)

Can: that the committed transcript is internally consistent, agrees with its
recorded exit, is unfiltered in the banner sense, and — via determinism —
that a re-run reproduces it byte-for-byte (verified once, by me, this session).
Cannot: that any verdict label matches any executed predicate (X1); that
content after the footer is honest (X4); that the transcript wasn't rebuilt
self-consistently (X5); that the checks are the right checks (its own
disclaimer, now given teeth by F-1/F-3/F-4/F-6).

## Repairs enumerated

1. **F-1:** rewrite the four `no-alias` teeth with `copy-tree`d before-values
   (probe2 shape). Consider the same repair upstream in de-pignore.
2. **F-3:** add one content-identity sensitivity check per §6 component (vary
   one, hold the rest, assert the identity moves).
3. **F-4:** move the HISTORY TRUTH before-captures to section D (desertion
   time), before section I mints the appearance.
4. **F-5:** either bind the desertion's refusal to the awaited successor (if
   Form /1's public readers permit) or declare cross-desertion an explicit
   ceiling in the header's does-not-show list and DESIGN-NOTE §10.
5. **F-2:** either add receipt-slot conjuncts (de-pignore parity) or delete the
   dead `procedure-*`/`previous-commitment` reliance from D-1's "strictly
   stronger" claim and state that receipt provenance is unpoliced (account,
   not authentication).
6. **F-6:** make check [095] enumerate slots rather than count declarations.
7. **F-9/F-10 caps:** fix DESIGN-NOTE §4's "complete and well-formed" to the
   discharging branch; scope §11's "discharge" avoidance to names, or sweep
   the two check labels.

None of these moves the mechanism: in every executed adversarial probe the
*shipped* fold, transitions, and records behaved exactly as their docstrings
claim. The defects are in the certification apparatus (teeth that cannot
fail, a suite blind to its central identity's composition) and in one unbound
transition plus two overclaims of prose.

---

## VERDICT

`REPAIR NEEDED — enumerated defects`

*The central claim survives: de-vadimonio is a genuine second inhabitant —
opens from success across the Form /2 → Form /1 amnesia, recognizes by exact
identity rather than admissibility-event, and neither rejected generalization
recaptures it under executed test. But four of its hundred greens do not
depend on the behavior their labels claim (ALIASING 1–4), three more compare
an event to itself (HISTORY TRUTH readers, the read-only census), the content
identity's composition — the builder's own flagged concern — is pinned by no
check at all, and RECORD-DESERTION accepts an alien refusal without declaring
that ceiling. Repair the teeth before any return cites them.*

*— CENSOR (Claude Fable 5), 2026-07-29. All probes preserved under the
session scratchpad `censor/`; the repo untouched (`git status` clean of any
tracked modification; the only new file is this review).*
