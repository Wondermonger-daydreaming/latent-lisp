# FIELD-REPORT — de-bibliotheca-peregrina

*An inhabitant's account of writing a small application in Lisp+ Language Core /0
plus Slice /1. Not a test report. I was asked whether this language is expressive,
compositional, and pleasant enough to live in, and this is what living in it for one
afternoon was actually like.*

— Claude Opus 5 (1M context), INCOLA · SBCL 2.4.6 · 2026-07-24

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

## 3. The judged-claim wall

*The program's Movement III. This section is the evidence for a pending owner
decision, so it is deliberately unsentimental.*

### What happened

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

### What it cost, exactly

Eleven lines of machinery and four call sites:

- `*desk-grants*` — a hash table of proposition → receipt id (2 code lines)
- `remember-grant` — record a grant in it (5 code lines)
- `restate-standing` — mint a fresh `:direct` witness for a granted claim's
  proposition, with a `:content` breadcrumb naming the receipt (4 code lines)
- four call sites where I pass `(restate-standing (claim-proposition c) ...)` instead
  of passing `c`

**In lines, it is nothing.** If the cost were only lines I would tell you it was fine.

### What it actually cost

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

### My opinion, since I was asked for it

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

---

## 7. Mechanical checks recorded

| check | command | result |
|---|---|---|
| runs clean, all arms | `sbcl --non-interactive --load APPLICATION.lisp` | **34 passed / 0 failed, exit 0** |
| front door only | `grep -n ':\{2\}' APPLICATION.lisp FIELD-REPORT.md` | **no matches** (the digraph is spelled out in words in both files) |
| quiet-zone proportion | `grep -v '^\s*\(;\|$\)' \| grep -c "lisp-plus-"` | 87 of 498 code lines (17.5%) touch Lisp+ |
| nothing outside this directory modified | `git status` on the chair's side | no edits to `core0.lisp`, `slice1.lisp`, any specimen, or any document |

**Load note.** Another agent was editing `../../language-slice-1/slice1.lisp`
concurrently. I hit no transient load error at any point; every run loaded the chain
first try.

**What this application does not show.** No crash survival: the interrupted dispatch's
evidence survived because the image did. The courier is the labelled scripted fake and
is never AP0-conformant; nothing here licenses conformance language. The forgery in
`[III-f]` is a demonstration of the workaround's ceiling, not an exploit of the
governed path — the governed path refused correctly every time it was asked.
