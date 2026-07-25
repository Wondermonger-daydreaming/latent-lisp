# FIELD-REPORT — de-bibliotheca-peregrina

*An inhabitant's account of writing a small application in Lisp+ Language Core /0
plus Slice /1. Not a test report. I was asked whether this language is expressive,
compositional, and pleasant enough to live in, and this is what living in it for one
afternoon was actually like.*

— Claude Opus 5 (1M context), INCOLA · SBCL 2.4.6 · 2026-07-24

> **SECOND HAND ON THIS DOCUMENT — read before §3.** The gap this report was written
> to measure was repaired the same day (Sol's design ruling, DECISION 1: judged-claim
> discharge by judgment-identity chaining). The application was brought onto the lawful
> road and its Movement III rewritten. **§3.1 below is INCOLA's original finding,
> preserved unedited** — it is the evidence that motivated the repair and it must not
> be read as a description of the language as it now stands. **§3.2 is what changed,
> what the lawful road cost, and whether it is pleasant.** §1, §4(c), §6 and §7 carry
> dated amendments where the repair made a sentence of mine false; every amended
> sentence is kept and marked, never overwritten.
> — Claude Opus 5 (1M context), REDIVIVA · SBCL 2.4.6 · 2026-07-24, later the same day

---

## 1. What I built

An interlibrary-loan desk. Patrons ask for rare volumes; the desk decides whether
they may borrow, whether the volume may be dispatched, and hands it to a brass
courier who carries it out of the desk's sight. Sometimes the courier's ledger
answers. Sometimes it withholds.

`APPLICATION.lisp` — 729 lines, 498 of them code, **87 of which touch a `lisp-plus-`
symbol at all (17.5%)**. Runs clean: **34 checks passed / 0 failed, exit 0.**

Five movements: the quiet zone (ordinary CL) · standing (`derive`) · the wall
(judged-claim discharge) · the crossing (`perform`) · the divergence (two structurally
different refusals driving two different desk actions).

> **AMENDED 2026-07-24 (REDIVIVA), post-repair.** The paragraph above is INCOLA's
> and stays as written; here are the figures for the program as it now stands.
> `APPLICATION.lisp` — **862 lines, 600 of them code, 106 of which touch a
> `lisp-plus-` symbol (17.7%)**. Runs clean: **42 checks passed / 0 failed, exit 0.**
> The Lisp+ proportion moved by one tenth of a point across the whole surgery, which
> is the only reason it is worth printing: the lawful road did not make the program
> more Lisp+-shaped, it made four lines of it different. The third movement is no
> longer *the wall* but **the lawful road**; the other four are untouched, and I
> diffed their output rather than assuming it: Movements I, II and IV are
> byte-identical to the pre-repair run, and Movement V differs by exactly one printed
> identity name (`refutation-26` where it read `refutation-20`), because the program
> now mints a different number of Slice /0 objects before reaching it.

The whole program was written against the public surface. **Zero double-colon package
access anywhere in this directory** — `grep -n ':\{2\}' *` returns nothing, which is
why both files spell the digraph out in words. I never once wanted it. That is a real
result: the front door was wide enough for an entire application.

---

## 2. What was genuinely pleasant

**(a) The six premise dispositions handed me a distinction my domain actually has,
and my plain-CL version would have destroyed.**

This is the single best thing about the language and I did not expect it. In ordinary
Common Lisp I would have written:

```lisp
(defun volume-available-p (id) ...)   ; → T or NIL
```

and the state *"in transit, unconfirmed"* would have become `NIL`. `NIL` means
"unavailable", so Dambroise goes on a hold queue — behind a loan that may not exist,
for a volume that may be in a cart or may be lost. The boolean does not have a shape
for *"I do not know where that book is."*

What I wrote instead is three lines, and shorter than the boolean plus its special
cases would have been:

```lisp
(ecase (gethash volume-id *shelf-state*)
  (:free    (attest `(:predicate :volume-unreserved ...)))   ; a witness
  (:on-loan (deny   `(:predicate :volume-unreserved ...)))   ; a refutation
  (:unknown nil))                                            ; nothing at all
```

Three domain states, three evidential shapes — and `NIL` is a *legitimate* thing to
put on the table, because "the desk says nothing" is exactly what `:missing` looks
like in a receipt. Movement V is the payoff: the same code path, asked about two
volumes, refuses `:refuted` for one and `:missing` for the other, and the desk takes
two different actions (`:hold` vs `:await-tracer`). The language did not decorate that
distinction; it is where the distinction came from.

**(b) `perform` made me write a branch I would have skipped, and that branch was a
real bug I would have shipped.**

In the plain-CL version of this desk, `(dispatch! volume patron)` returns a receipt or
throws, and I set `due-day` at dispatch time. Always. Here the outcome came back
`:indeterminate` and I had nowhere to put a due date, because *the loan clock cannot
start on a dispatch nobody has confirmed*. So `loan-due` became nullable, `fee-for`
learned to return 0 on a null due date, and check `[IV-k]` records the consequence:
ninety days on, the confirmed loan owes a fee and the unconfirmed one owes nothing.

Without `:indeterminate` I would have quietly billed a patron for a book that may
never have reached him. **That is a structural change to my data model forced by the
outcome type, not a decoration on it.**

**(c) The no-blind-retry rule is enforced, not requested.**

Check `[IV-g]`: the naive re-send fires `unsafe-retry` from live kernel code. I did not
have to remember. This is the lab's own "prompts guide, code enforces" doctrine
showing up inside a programming language, and it is the difference between a rule and
a guarantee. `continue-from` then reconciled without touching the adapter — row count
1 before, 1 after.

**(d) The `continue-from` required-action plist wrote my tracer for me.**

I did not compose the tracer's contents. I copied three fields:

```
known:           (:FRONTIER-CROSSED :EFFECT-UNCERTAIN)
unknown:         (:WHETHER-THE-EFFECT-SETTLED)
required-action: (:OBTAIN-A-JURISDICTION-BEARING-WITNESS-OF-THE-LEDGER)
```

A tracer is exactly a note about what is known, what is not, and what must be done.
The language already had that shape, exactly, and check `[IV-j]` asserts my tracer's
text *is* the plist and not prose I invented. For a system whose characteristic
failure is confident narration over a gap, having the gap come pre-described in three
fields is worth a lot.

**(e) Refusal receipts let the desk speak without inventing anything.**

`say-the-verdict` is keyed on `(premise . disposition)` from the receipt's own
`strongest-lawful-result`, and prints the repair option verbatim underneath. The
patron-facing sentence cannot drift from the actual reason for refusal, because the
receipt selects it. In plain CL that sentence would be a string literal at the refusal
site, and it would go stale the first time the policy changed.

**(f) The schemas are the only place the policy is written.** I can read the desk's
entire lending policy in twelve lines, and a premise the schema names cannot be
skipped. (Its ceiling is loudly documented and I believe it: a premise the schema
*omits* is silently unenforceable. That is fine — it is honest about being a
declaration language.)

---

## 3. The judged-claim wall, and the road that replaced it

*The program's Movement III. §3.1 is the pre-repair finding; §3.2 is the repair.*

---

### 3.1 — THE STATE BEFORE THE REPAIR

> **Everything in §3.1 describes the language as it stood on the morning of
> 2026-07-24, before Sol's DECISION 1 was implemented. It is preserved because it is
> the evidence that motivated the repair — a program that hit the gap and reported
> the cost. It is NOT a description of the current language, and every claim in it
> about what `derive` does with a claim is now false of the running system.** Nothing
> in it has been reworded, softened, or deleted; the four sub-headings below were
> demoted one level so §3.2 could sit beside them, and that is the only edit.
>
> *The one sentence worth carrying forward out of it, because it is what the repair
> was aimed at:* **"the only thing separating a granted standing from an invented one,
> in my application, is `*desk-grants*` — my hash table, my discipline, unreceipted."**
> §3.2 reports whether that sentence is still true. (It is not. The hash table is
> gone from the program, and `[III-k]` checks its absence mechanically.)

*The original section, from here to the §3.2 rule, unedited:*

*This section is the evidence for a pending owner decision, so it is deliberately
unsentimental.*

#### What happened

The desk holds a granted `:may-borrow` claim for Ferrand. The dispatch schema declares
`:may-borrow` as its first premise. The obvious program is to pass the granted claim
as a support. I wrote that program, because it is what anyone would write.

It refuses. `derive` filters `supports` into witnesses and refutations
(`slice1.lisp:1045-1046`, read this session) and discards everything else. The premise
lands `:missing`.

The precise character of the failure matters more than the failure. Check `[III-b]`
asserts it: **the claim was not rejected — it was not seen.** Every evidential field of
the assessment is empty: no matching support, no inaccessible support, no mismatched
candidate, no refutation. The receipt's repair option says *"supply an accessible
support matching `(:predicate :may-borrow (:patron :ferrand) (:volume "ms-Aleph-7"))`"*
— which is precisely the thing I did supply, in the only form the language has for it.

I then tried the one in-language transport route, `transported-testimony`. It also
lands `:missing`, and correctly so: a transported receipt is testimony that a
*derivation happened*, whose proposition is an attribution, not the conclusion. That
door is closed for a good reason and I do not think it should be opened. But it means
**there is no in-language route from a granted claim to a premise today.**

#### What it cost, exactly

Eleven lines of machinery and four call sites:

- `*desk-grants*` — a hash table of proposition → receipt id (2 code lines)
- `remember-grant` — record a grant in it (5 code lines)
- `restate-standing` — mint a fresh `:direct` witness for a granted claim's
  proposition, with a `:content` breadcrumb naming the receipt (4 code lines)
- four call sites where I pass `(restate-standing (claim-proposition c) ...)` instead
  of passing `c`

**In lines, it is nothing.** If the cost were only lines I would tell you it was fine.

#### What it actually cost

The workaround is not a detour around the wall. It is a hole in the floor.

`restate-standing` mints a witness with `:mode :direct` — the mode reserved for what
the desk *observed with its own eyes* — for a proposition the desk did not observe but
*derived*. There is no honest mode available: `:derivation` exists but is reserved by
the frozen Slice /0 gate for derivation-keyed procedures, and `:testimony` requires an
attribution proposition. So the only way through requires the desk to misdescribe its
own evidence.

And the language cannot tell a restatement from a fabrication. Checks `[III-f]` and
`[III-g]` demonstrate it in the program's own bytes: I minted a "restated standing"
for `(:may-borrow (:patron :quillon) ...)` — a standing that was **refused** in
Movement II, because Quillon owes fourteen crowns — with a `:content` breadcrumb
naming a receipt id that does not exist. **It granted `:may-dispatch` identically.**
The breadcrumb is decoration; nothing reads it.

So the only thing separating a granted standing from an invented one, in my
application, is `*desk-grants*` — my hash table, my discipline, unreceipted. That is
the S3 species this slice exists to make refusable, reintroduced by hand, **at the one
joint where an application composes.**

#### My opinion, since I was asked for it

**It matters, and it matters more the larger the program gets.**

For a one-stage application it is nearly free: derive one standing, restate it once,
perform. This program is barely inconvenienced. But a desk is small. The shape of a
serious governed application is a *pipeline* of standings — eligibility feeds
authorization feeds dispatch feeds settlement — and today every joint in that pipeline
is a hand-minted `:direct` witness for something nobody directly observed, guarded by
an ordinary hash table. A three-stage pipeline is three holes and a promise. **The
language's guarantee degrades exactly in proportion to how much you compose in it,
which is the opposite of what a compositional language should do.**

I want to be fair about the scope of the complaint. Nothing is broken; nothing lies;
the refusal is honest and well-receipted, and E3 already records the obligation dead
and docketed. My finding is narrower and, I think, more useful than "it should work":
**the workaround's cost is not friction, it is a silent downgrade from mechanical
enforcement to programmer discipline, and it is invisible in the receipts.** A reader
of my `:may-dispatch` receipt sees `:satisfied` on `:may-borrow` and cannot tell
whether it stands on a derivation or on my good intentions.

If it helps the decision: the two questions E3 raises — *which judgment states
discharge?* and *does receiver-accessibility apply to a claim?* — both had obvious
answers from inside my application. `:verified` should discharge; nothing weaker.
And yes, accessibility should apply, because the whole point of Movement II's
receiver-relativity is that a standing derived at one desk is not automatically
reachable at another. The third question — *what disposition does a refuted claim
produce?* — is the only one I found genuinely hard, and I would be content with
`:mismatched` naming the judgment field.

A cheaper partial repair, if the full thing is not wanted: even without discharge,
`derive` could **notice** a claim in its supports and record it in the receipt as an
undischargeable candidate rather than dropping it silently. That alone would have
saved me the hour, because the receipt would have said *"you handed me a claim; claims
do not discharge premises"* instead of `:missing` with four empty fields, which reads
exactly like *"you forgot to bring evidence."* The current failure mode does not just
block me — **it misdirects me**, and I spent real time checking my schema, my
bindings, and my receiver context before I found the erratum.

---

### 3.2 — THE REPAIR, AND WHAT THE LAWFUL ROAD COSTS

*— REDIVIVA, the same day, after Sol's DECISION 1 landed in `slice1.lisp`. Everything
below is read off runs of `APPLICATION.lisp` in this directory, not off the ruling.*

#### What the road is

A judged claim is now a support kind, and it discharges a premise by
**judgment-identity chaining**: *this exact accessible claim, under this exact
`:verified` judgment, whose normalized judged proposition matches the ground premise,
with the claim's identity and its judgment basis written into the receiving receipt,
and the original judgment never converted into a witness.* Not schema-matching, not
`procedure-id` matching, not mode or kind: identity, judgment, proposition.

Both of §3.1's "obvious answers from inside my application" were taken, and I record
that without pride, because a proposer agreeing with the ruling that adopted its
proposal is not evidence of anything: `:verified` discharges and nothing weaker, and
receiver-accessibility does apply to a claim. The third question — *what disposition
does a refuted claim produce?* — was answered differently from my guess: a claim that
matches but is unjudged, refuted, or basis-less leaves the premise **`:missing`**, and
is **named in the roster and in the repair advice**. No seventh disposition was minted.
That is better than my `:mismatched` suggestion, and for a reason I had not seen: it
keeps the six dispositions a closed set about *the premise*, and puts the news about
*the claim* where news about claims belongs.

#### What I changed in the application

- **`at-the-desk` collects claim ids as well as witness ids.** Four code lines. That
  is the entire plumbing change on the granting path; `consider-dispatch`'s optional
  `:receiver` and the three receipt-reading helpers (`roster-for`, `assessment-for`,
  `repair-for`) exist for the demonstration arms and the checks, not for the road.
- **Movement III was rewritten** from *the wall* to *the lawful road*: five arms and
  fifteen checks (`III-a` … `III-o`) instead of three arms and seven.
- **`*desk-grants*` and `remember-grant` are DELETED** — not disabled, not commented
  out; the symbols are gone from the program. Check `[III-k]` asserts it mechanically
  (`(find-symbol "*DESK-GRANTS*")` ⇒ `NIL`), and I planted the fault to prove the
  check has teeth: a single `(defparameter *desk-grants* …)` anywhere in the file
  makes it fail.
- **`restate-standing` is gone from every lawful path.** The minting helper survives,
  renamed `fabricate-standing`, used at exactly one place: arm 3e, the counterexample.
  The rename is the point — `restate` was a euphemism for `mint a direct witness for
  something nobody observed`, and it read as bookkeeping.
- **Movement IV's `*beth-standing*` is now the granted claim itself** — one line
  where six stood, and the six included a call to each of the two deleted helpers.
  Movements I, II, IV and V are otherwise untouched, and their output was diffed
  against the pre-repair run rather than assumed unchanged (see the §1 amendment:
  three byte-identical, one printed identity name shifted).

#### What the lawful road cost, in the program's own bytes

| | before | after |
|---|---|---|
| machinery for standing-reuse | `*desk-grants*` + `remember-grant` + `restate-standing` ≈ **11 lines**, 4 call sites | **4 lines** inside `at-the-desk`, 0 extra call sites |
| what a call site looks like | `(restate-standing (claim-proposition c) (gethash (claim-proposition c) *desk-grants*))` | `c` |
| what guards a refused patron | my hash table, my discipline, unreceipted | the absence of a claim object, and the language |

**The application got smaller where it composes and larger only where it explains
itself.** The +227/−94 diff is eight new checks, one rendered receipt, and their prose; the
plumbing went the other way. I did not expect that and I would not have predicted it: I assumed the
lawful road would cost *more* ceremony than the forgery, because lawful roads usually
do.

#### The one real cost, and it is a cost: you must hand the receiver the claim

Granting receiver access to a judged claim is **not** free ceremony — it is the same
id-membership rule that already governs witnesses, and I do not think it should be
dropped. But it has a sharp edge, and I hit it before I wrote a line: the desk built
its receiver contexts from **witness ids only**, so a perfectly good granted claim
arrived `:INACCESSIBLE`. Arm 3b keeps that failure in the program on purpose.

**And the edge is not mine alone. `LANGUAGE-SLICE-1-GUIDE.md`'s paste-once fixture
block (lines 52–54, read this session) builds `accessible-supports` with
`(mapcar #'witness-id (remove-if-not #'witness-p witnesses))` — witnesses only.** A
programmer who pastes the guide's own convenience block, as instructed, gets a working
fabrication path and a refusing lawful path. That is a **convenience asymmetry
favouring the unsafe route**, and it is a fixture defect rather than a language defect:
the guide's `ctx` should collect claim ids too. I cannot fix it from inside this
directory, so I am reporting it. It cost me nothing because the receipt told me the
answer; it will cost the next reader an hour if they do not read the receipt.

Two things make the edge survivable, and both are the language behaving well:
the disposition is **`:INACCESSIBLE`, not `:MISSING`** — "you have a standing you may
not read", not "you brought nothing" — and the repair option names the fix and the
claim's durable identity. From the run, rewrapped and with the `lisp-plus-kernel0:`
package prefix elided:  `(:GRANT-RECEIVER-ACCESS-TO NIL
:GRANT-RECEIVER-ACCESS-TO-JUDGED-CLAIMS (#S(DURABLE-IDENTITY :DOMAIN :CLAIM :NAME
"claim-6")))`. §3.1's central complaint was that
the failure **misdirected** me. This one does the opposite: it hands you the patch.

#### Is the judged-claim record actually legible to a programmer?

**Through the renderer, yes — and it is the best line in the receipt.** Arm 3a now
prints `render-derivation-why` unaided (one long line wrapped here for the page; the
run prints it whole):

```
[derivation GRANTED] schema :DISPATCH-STANDING v1
  premise :MAY-BORROW: SATISFIED
    discharged by judged claim claim:claim-6: judgment :VERIFIED under procedure
    procedure:derive/BORROWING-STANDING/1 v1 (basis preserved, not restated)
  premise :COURIER-INSURED: SATISFIED
    judged claim claim:claim-6 did NOT discharge: :PROPOSITION-DOES-NOT-MATCH
```

That first line is exactly the sentence §3.1 said a reader could not get: *this
standing rests on a derivation, and here is which one.* A reader of my `:may-dispatch`
receipt can now tell a derivation from my good intentions without leaving the receipt.

Three honest qualifications:

1. **Raw, the roster is a wall of struct syntax.** `premise-assessment-judged-claims`
   returns plists whose values are `#S(DURABLE-IDENTITY :DOMAIN :CLAIM :NAME "claim-6")`
   structs; every field I printed went through `identity-key` first. The renderer does
   this for you and nothing else does. The keyword-plist shape itself is fine — `getf`
   with `:claim-id`, `:outcome`, `:judgment`, `:procedure-id` reads well in application
   code, which is how every roster-reading check in Movement III is written.
2. **The roster is per-premise × per-claim, so it grows as a product.** Look at the
   second premise above: the same claim is recorded against `:courier-insured` as
   `:PROPOSITION-DOES-NOT-MATCH`. That is honest completeness — *"a claim offered in
   supports is never invisible again"* is the whole point — but a four-premise schema
   with three offered claims prints twelve roster lines to say two things. In a real
   pipeline the reading cost of a receipt is now the product, and I would want a
   renderer flag for *discharging entries only* before I read many of these by eye.
3. **`:PROPOSITION-DOES-NOT-MATCH` is doing two jobs** in that output: "this claim is
   about something else entirely" (true here) and "this claim is about the right thing
   but the bindings disagree" (not exercised in this program). Both print identically.
   Not a defect I hit; a thing I would want distinguished before I trusted the roster
   as a debugging surface.

#### Pleasant, or merely correct?

**Correct, and — narrowly, at this joint — pleasant. But I will not generalize the
second word, and here is exactly where the pleasure stops.**

Pleasant, and I mean it: the obvious program is now the correct program. You hand the
claim. That sentence is the whole repair from the application's side, and *the thing I
deleted was larger than the thing I added.* The old Movement III had me writing a
comment begging the reader to notice that `:direct` was a lie; the new one has nothing
to apologize for. Deleting `*desk-grants*` felt like removing a splint.

Not pleasant, precisely:

- **The receiver-access step is a step you must know about in advance.** It is
  discoverable in one run — but only if you read the receipt rather than your
  assumptions, and the guide's own fixture leads you away from it (above).
- **The unsafe path is still writable, and still shorter to think of.** `[III-n]`:
  a fabricated `:direct` witness restating a standing that was refused still grants
  `:may-dispatch`. That door was never Movement III's to close — it is the price of
  `:direct` existing at all, and a language that let a program *assert nothing* would
  not be a language. What changed is real but bounded: **the desk no longer has any
  reason to walk through it**, and `[III-o]` shows the two grants are now
  distinguishable *from the receipts alone* — the lawful one carries a judged-claim
  record with a procedure and a judgment; the fabricated one carries a witness and an
  empty roster. Before, both produced identical receipts and only my hash table knew.
  **That is a downgrade removed, not a hole closed.** I want to be exact about the size
  of it, because §3.1's sharpest sentence is the kind that invites a victory lap: the
  guarantee did not become absolute; it became *visible*.
- **Ceremony I still pay per call site:** `consider` (the signal-to-value wrapper,
  §4(a)) is untouched by this repair, and it remains the first thing I wrote in this
  language and the thing I would most like not to need.

If someone asks me the one-line version: **the language stopped requiring me to lie,
and started letting a receipt say where a standing came from. It did not stop me from
lying, and it did not make the receiver ceremony disappear.** For a multi-stage
pipeline — the case §3.1 said it would not commit to — I would now commit. The joint
that degraded per stage no longer degrades: standing *N+1* inherits standing *N* by
identity, and each receipt names its parent. That is the property I was missing, and
it is the one that compounds.

#### What I did not fix, and what I still cannot see

- `RUN-RECEIPT.txt` in this directory still records the pre-repair run (34/0 under the
  old language). I was scoped to two files and did not touch it; it should be
  regenerated or marked.
- The guide's `ctx` fixture (above) — outside my scope, reported.
- **n = 1.** One application, one afternoon, one desk-sized program, written by the
  same hand that hit the original gap and proposed two of the answers the ruling
  adopted. A second application by someone else, and a pipeline deeper than two
  stages, are what would actually test the sentence I just wrote about compounding.
  I have not tested it; I have stopped being blocked by its absence.

---

## 4. What was awkward

**(a) Two different conventions for "the governed act declined," in one system.**

`derive` **signals** on refusal. `perform` returns a structured outcome — except it
doesn't, quite (see (b)). For a lending desk, refusal is not exceptional; it is
Tuesday. Most patrons, most days, cannot borrow something. So the first thing I wrote
in this language was a nine-line wrapper turning a condition back into a value:

```lisp
(defun consider (&key schema version conclusion supports receiver) ...)
```

Every one of my four derivation call sites goes through it. **Writing a wrapper whose
sole job is to undo a design decision, before writing any application logic, is a
signal.** The receipt-on-every-attempt design is right; the delivery mechanism assumes
refusal is the exception, and in a decision application it is the median case. I would
much rather `derive` returned `(values claim receipt)` with `claim` nil, and reserved
conditions for malformed input — the receipt already carries everything.

**(b) `outcome-kind` promises a three-way view of something you must first catch.**

`perform` has exactly **one** value-returning exit — the committed path
(`core0.lisp:723`, read this session). Every refusal and every interruption arrives as
a *condition* carrying the outcome. I discovered this by writing an `ecase` on
`outcome-kind` with three live-looking branches, two of which are unreachable by
return; the program now says so in a comment and arm 4c demonstrates a refusal
arriving the only way it can. This isn't wrong, but the docs and the specimen shape
led me to expect `(ecase (outcome-kind …))` to be the dispatch idiom, and in practice
the dispatch idiom is `handler-case` with an `ecase` inside it. The three-way view is
real; it is just not a *return* view.

**(c) The receiver context is ceremony that never earned its keep here.**

Every single call site of mine reads `(apply #'at-the-desk sup)` — I build the
receiver's accessible-supports *from the supports I am about to pass*, because of
course the desk can reach the evidence the desk just assembled. 100% of my uses. I
believe the mechanism earns itself the moment two receivers genuinely differ (Mistake
3 in the guide is convincing), but for the common case the default should be "the
receiver can reach what was offered," with narrowing as the explicit act. As written,
the first thing a new user learns is a piece of ceremony that in their program is
always the identity function — which teaches them it is noise.

> **AMENDED 2026-07-24 (REDIVIVA): this one is now WRONG, and it is the most useful
> thing the repair taught me about my own report.** The receiver context stopped being
> the identity function the moment a judged claim became a support: `at-the-desk` must
> now name the *claim ids* it means to rely on, and forgetting to do so produces a
> real, distinct, correctly-named refusal (`:INACCESSIBLE`, arm 3b) rather than a
> silent success. The mechanism earned its keep exactly where I said it would — "the
> moment two receivers genuinely differ" — I simply had not yet written the program in
> which they do. **My complaint was measured against a one-stage application and
> generalized to the language.** I still hold the second half of it: the *default*
> should be "the receiver can reach what was offered," with narrowing as the explicit
> act, because as it stands the guide's own fixture (see §3.2) hands you a receiver
> that reaches your witnesses and silently not your claims. The ceremony is not noise;
> the default is backwards.

**(d) Things I had to read source or the erratum to learn.**

- **That `derive` filters its supports at all.** The guide shows `supports` as a list
  and never says what may be in it. The restriction lives in two descriptive sentences
  in the API brief and in E3. A programmer following the guide alone hits the wall with
  no signpost.
- `transported-testimony` takes `:context-a` as a *keyword*; the guide's prose reads
  positionally.
- `refutation :refutes` takes a raw form, while `derive :conclusion` needs a
  `proposition` — an asymmetry I got wrong once. (Small, but it is exactly the sort of
  thing that costs a load-and-read cycle.)
- The `:kind` field of a witness is unenforced (E4). I gave mine meaningful kinds
  (`:certificate`, `:standing-restated`) and then discovered nothing reads them, which
  is worth knowing before you build a taxonomy on top of it.

**(e) The repair option prints unbound locals as `(:VAR :AS-OF)`.** Fine and honest,
but it means a receipt repair is not directly showable to a human without a rendering
pass. I printed it verbatim anyway, on the principle that a slightly ugly true thing
beats a pretty invented one.

**(f) One small thing I liked less each time I typed it:** the fully-qualified
`lisp-plus-slice1:derivation-receipt-strongest-lawful-result`. The names are precise
and I would not shorten them in the library, but an application ends up defining
`verdict`, `disposition-of`, `attest`, `deny`, `at-the-desk` on day one. That is
probably correct — every domain wants its own vocabulary — but it means the first
forty lines of any Lisp+ application are adapters, and it would be kind to ship those
five as a `slice1-user` convenience package. (The guide's own "paste this once" block
is evidence that everyone writes the same five.)

---

## 5. Where the discipline changed the design rather than decorating it

Three places, all checkable in the program:

1. **`loan-due` became nullable** because `:indeterminate` gave me a dispatch I could
   not date. `fee-for` then had to handle it. `[IV-k]` measures the consequence.
2. **`*shelf-state*` became three-valued** (`:free` / `:on-loan` / `:unknown`), because
   there was a state I could not collapse without lying. In plain CL it would have been
   a boolean, and Movement V would not exist.
3. **Two queues instead of one.** `*hold-queue*` and `*tracer-followups*` are different
   because `:refuted` and `:missing` are different. A hold is a promise about a queue
   position; you cannot promise a queue position behind a loan you are not sure exists.
   `[V-c]` asserts they diverge in state, not only in printout.

None of these are things I did to show off the language. They are things I did because
the language would not let me write the flatter version without noticing I was lying.

---

## 6. Would I write the next one in it?

**For this shape of program: yes.** A desk that makes governed decisions, crosses a
frontier it does not control, and must survive an ambiguous answer — that is exactly
what Core /0 and Slice /1 are for, and the program came out better than my plain-CL
version would have. Not longer: *better*, and with two real bugs (the phantom due date,
the phantom hold) prevented at the type level rather than by my attention. The 82.5%
of the program that is ordinary Common Lisp stayed ordinary, which is the other half of
what made it pleasant. I never once fought the host language.

**With one condition, and it is not a small one: the judged-claim gap.** Today it costs
eleven lines and one unreceipted invariant. In a program with a real pipeline of
standings it costs the guarantee itself, quietly, at every joint. I would take a
second desk-sized application in this language happily. I would think hard before
committing a multi-stage one, and what would change my mind is exactly the docketed
decision — or, failing that, the cheap version: **make `derive` see the claim and say
so in the receipt, even if it refuses to discharge it.** Silence at that joint is the
one place this language, whose entire virtue is that it will not let you be silently
wrong, is silently unhelpful.

The sharpest single friction, stated once: **`derive`'s treatment of a granted claim
is indistinguishable, from inside the receipt, from the programmer having forgotten to
bring evidence — and the workaround requires the programmer to call a derived
conclusion a direct observation.**

The best single thing, stated once: **the six dispositions gave my desk a way to say
"I do not know" that a boolean could not, and the program is structurally different
for it.**

> **AMENDED 2026-07-24 (REDIVIVA), post-repair.** The condition in this section — "the
> judged-claim gap" — **is discharged**, and the answer taken was the full one, not the
> cheap one I offered as a fallback. `derive` does not merely *see* the claim and say
> so; it discharges the premise on the claim's own governed judgment and records the
> inherited basis. So: **I would now commit a multi-stage one**, with the caveats in
> §3.2 (the receiver-access edge, the guide fixture that leads away from it, and the
> fact that a program can still assert a `:direct` witness for something it derived).
>
> The sharpest single friction is retired and I will not replace it with a slogan.
> Its successor, stated at its true size and no larger: **the language now lets a
> receipt say where a standing came from; it does not stop a program from saying
> something false, and it never claimed to.** The best single thing is unchanged —
> it was never Movement III's.

---

## 7. Mechanical checks recorded

| check | command | result |
|---|---|---|
| runs clean, all arms | `sbcl --non-interactive --load APPLICATION.lisp` | **34 passed / 0 failed, exit 0** |
| front door only | `grep -n ':\{2\}' APPLICATION.lisp FIELD-REPORT.md` | **no matches** (the digraph is spelled out in words in both files) |
| quiet-zone proportion | `grep -v '^\s*\(;\|$\)' \| grep -c "lisp-plus-"` | 87 of 498 code lines (17.5%) touch Lisp+ |
| nothing outside this directory modified | `git status` on the chair's side | no edits to `core0.lisp`, `slice1.lisp`, any specimen, or any document |

**RE-RUN 2026-07-24 (REDIVIVA), post-repair.** The table above is INCOLA's, taken
against the pre-repair language; these are the same four checks re-run against the
program and language as they now stand.

| check | command | result |
|---|---|---|
| runs clean, all arms | `sbcl --non-interactive --load APPLICATION.lisp` | **42 passed / 0 failed, exit 0** |
| front door only | `grep -c ':\{2\}' APPLICATION.lisp FIELD-REPORT.md` | **0 and 0** (the digraph occurs nowhere in either file; both spell it out) |
| quiet-zone proportion | `grep -v '^\s*\(;\|$\)' \| grep -c "lisp-plus-"` | 106 of 600 code lines (17.7%) touch Lisp+ |
| nothing outside this directory modified | `git diff --stat` | only `APPLICATION.lisp` and `FIELD-REPORT.md` in this directory |
| the deletion is real, and the check has teeth | plant `(defparameter *desk-grants* …)`, re-run | `[III-k]` **FAILS** (41/1) with the fault planted, passes with it removed |
| the receiver fix is load-bearing | disable the `claim-p` branch of `at-the-desk`, re-run | `[III-a]`, `[III-b]`, `[III-c]` **FAIL** — the lawful road closes without it |

**Not re-run, and it matters:** `RUN-RECEIPT.txt` in this directory is INCOLA's and
still records the pre-repair session. I was scoped to two files and left it alone.

**Load note.** Another agent was editing `../../language-slice-1/slice1.lisp`
concurrently. I hit no transient load error at any point; every run loaded the chain
first try.

**What this application does not show.** No crash survival: the interrupted dispatch's
evidence survived because the image did. The courier is the labelled scripted fake and
is never AP0-conformant; nothing here licenses conformance language. The forgery in
`[III-f]` is a demonstration of the workaround's ceiling, not an exploit of the
governed path — the governed path refused correctly every time it was asked.

> **AMENDED 2026-07-24 (REDIVIVA): the check letters moved.** Movement III was
> rewritten and now runs `[III-a]` … `[III-o]`; INCOLA's `[III-f]` (the forgery) is
> today's **`[III-n]`**, and today's `[III-f]` is the receiver-inaccessibility arm.
> Any citation of a Movement III letter written before 2026-07-24 refers to the old
> numbering. The substance of the sentence stands and is now checked twice over:
> `[III-n]` is a demonstration of what a program can still assert, not an exploit —
> and `[III-o]` shows the governed path leaves a different receipt when it is used.
> The claim that "the governed path refused correctly every time it was asked" also
> still holds: in this run it refused Quillon twice (nothing to offer at all,
> `:MISSING`; a self-minted claim, `:UNJUDGED`) and refused Ferrand's perfectly good
> claim once (`:INACCESSIBLE`, when the desk withheld its own reach) — granting only
> where a `:verified` judgment stood behind the premise and the receiver could read it.
