# PORTABLE JUDGE /0 — CLEAN-ROOM IMPLEMENTER BRIEF (CANDIDATE, Round P revision)

**CANDIDATE (Round P revision) — not adopted; owner disposition pending. Date 2026-08-10.
SUPERSEDES the frozen original `CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE.md` as candidate text per
OWNER-RULINGS-2 Round-P authorization; original preserved unmodified as historical artifact.
Frozen court-construction baseline: commit `71422395`. Prepared against the R1 candidate base
(parcel sha256 `54aa7783…`, patch base `76952ea4…`) — base NOT owner-adopted. Round P claims
NO evidence; zero evidence remains earned. Designation: Portable Judge /0 (PortJ/0); bare PJ0
reserved for the adopted Process Journal /0.**

---

> # ⛔ THIS BRIEF IS NOT ISSUABLE
>
> **NO J2 MAY BE RECRUITED. NO J2 MAY BE IMPLEMENTED. NO PACKET EXISTS.**
>
> Clean-room brief **issuance** is expressly closed by `OWNER-RULINGS-2` ("Rounds still closed":
> Round A, Round B, Round F, hidden-bank authoring, **J2 recruitment or implementation**, **clean-room
> brief issuance"), and the hidden bank on which the whole test depends is **withheld** by
> `OWNER-RULINGS-1` **Ruling 7** until *all eight* S-freeze preconditions hold — R1 disposed · the
> L/0-versus-F/0 scope incorporated · the One Act publication route settled · every S1 deficit cured
> or explicitly excluded from the observable boundary · identifier and reader law adopted · the
> observation format reconciled with that law · the public packet given its **real** manifest hash ·
> the holdout-custody roles named.
>
> **Writing this successor text is authorized (Round P). Sending it to anyone is not.**
>
> **This document exists so that the court can be AUDITED, not so that it can be SENT.** Any reader
> who has received it as an instruction to build has received it in error: stop, and report that it
> reached you.
>
> Also unavailable, as facts and not as pending items: there is **no sealed packet**, **no public
> vector bank**, **no frozen act transcript**, **no holdout**, and **no real seed manifest** — the
> manifest placeholder is explicitly non-frozen and commits to nothing.

---

**Target: PortJ-L/0 — language-layer portable conformance** (PROTOCOL-CANDIDATE-P1 §1.1). The
original brief asked for "a second, independent implementation of a small language's judge." **That
framing is superseded by Ruling 3.** What follows is the retargeted instruction: smaller, exactly
bounded, and honest about the oracle that bounds it.

Full base coordinates: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is NOT owner-adopted** — the specification
is a *candidate*, and nothing produced against it will make it adopted.

---

## 1. What you would be asked to build

You would build **J2**: a non-Common-Lisp implementation of the **language layer** of a small
language's judge — the component that ingests a program as data, decides whether the program is
lawful, evaluates a lawful one under a declared environment, and emits a structured record of what
it observed.

**You would NOT build the act substrate.** Where the language asks for an *act* to be performed, or
a *derivation* to be taken, you do not perform it: you consume a **frozen Act Oracle transcript**
that tells you what happened (§6). That boundary is not a convenience — it is the definition of the
target, and it is the reason the campaign's success sentence is the narrow one in §9.

### 1.1 Your work-list — exactly these eleven items

This list is the ruling's, verbatim in substance, and it is both your assignment and its boundary.
Anything outside it is not yours to implement, and a divergence outside it is not scored against
you.

1. **datum ingestion**
2. **validation**
3. **bindings and scope**
4. **matching**
5. **branch selection**
6. **terminal discipline**
7. **result construction**
8. **summary ordering**
9. **copy/ownership behavior at the observable boundary** — *"at the observable boundary" is the
   whole qualifier: what must hold is that mutating what a reader handed you changes nothing that
   can be re-read, not that you copy in any particular way*
10. **refusal behavior**
11. **determinism**

The first implementation, **J1**, exists in Common Lisp. **You would never see it.** Your
implementation and J1's would be fed identical cases *and identical act transcripts*, and their
observations compared. The question under test is not whether you are a good programmer. It is
whether the **written specification is complete and substrate-neutral enough** that two
implementations on unrelated substrates reach the same judgments **at the language layer**.

**So: where the specification does not tell you what to do, you have found the result.** Do not
guess elegantly. Do not infer what the authors must have meant. **Record it** (§5) and implement
your most defensible reading. A disagreement traceable to a written silence is the campaign's most
valuable outcome, and it only counts if you wrote the silence down before the answer was known.

---

## 2. The sealed packet (would-be; none exists)

You would receive **one archive** with a **manifest sha256** stated on delivery:

```
PACKET MANIFEST SHA256: <NO PACKET EXISTS — NO MANIFEST HASH — NOT A COMMITMENT>
```

**Verify the hash before you start** and record the value you computed in your delivery. If it does
not match, stop and report; do not proceed with an unverified packet.

The packet would contain (per PROTOCOL-P1 §7): the contract, the grammar, the author guide, the
failure matrix (witness laws; the planted-disease table redacted), the two campaign returns and the
two seal addenda, the transcribed closed export surface (names and value shapes only), the
**NORMATIVE-OBSERVATION-FORMAT-0** definition **including its Act Oracle transcript envelope**, the
**public vector bank** with its expected observation envelopes **and its frozen act transcripts**,
the protocol / taxonomy / this brief, and the current deficit register.

**That would be the whole law.** If something you need is not in the packet, it does not exist for
you — and that fact is a finding, not an obstacle.

---

## 3. What you may and may not consult

**You MAY consult:**

- every document in the sealed packet, freely and repeatedly;
- your substrate's own standard-library documentation (Python's, if you take the recommendation);
- general programming knowledge you already have.

**You MAY NOT consult, at any point, for any reason:**

- **the canonical implementation's source** — any Common Lisp file of Many Acts /0, One Act /0, or
  any predecessor lane;
- **the lab repository**, in any form: a checkout, a diff, a commit message, a branch, an issue;
- **the public `latent-lisp` mirror on GitHub** — see §7, this is the specific hazard;
- the **holdout vector bank**, the **disease corpus**, any **construction transcript**, campaign log,
  agent return, or chair note;
- any person or model who worked on the construction of these lanes;
- any answer, from anyone, to a question about what the specification means.

**You MAY NOT be** the chair (Claude Fable 5), Sol, any Opus agent of the /0 or R1 rounds — **which
includes LEGIST, who drafted the frozen originals, and PRAETOR, who wrote this revision** — any
construction-loop participant, or any session whose working directory is the lab repository. If you
are any of these, stop and say so; the campaign needs a different hand.

---

## 4. Substrate and constraints

**Python is recommended**, and unless told otherwise you should take the recommendation. It is far
enough from Common Lisp to make the test meaningful — different reader, different symbol model,
different equality, different exception discipline, different copy semantics — and cheap enough that
the campaign's result is about the specification rather than about your endurance. (Rust is reserved
for a possible later J3; do not use it here.)

Constraints, normative:

- **Standard library only.** No s-expression package, no parsing framework, no Lisp interoperation
  library, no ported Common Lisp reader. Write the reader yourself from the written grammar.
- **Deterministic by construction.** No clock, no PID, no randomness, no filesystem enumeration
  order, no hash-iteration order reaching output, no locale-dependent case operations reaching
  normative comparison. Your judge will be run repeatedly, in separate processes, **under varied hash
  seeds, working directories, locales, and timezones**, and every run's observation must be
  **byte-identical**.
- **No network at any point**, during construction or execution.
- **No dependence on being run from a particular directory.**

---

## 5. The observable boundary, the format, and your deficit register

**PROTOCOL-P1 §5.1 is the list of things you must get right.** PROTOCOL-P1 §5.2 is the list of
things nobody will look at — your internal structures, your control flow, your function names, your
exception classes, your messages, your printed representations. **Do not spend effort making those
resemble anything.** They cannot earn you a pass and cannot cost you one. **PROTOCOL-P1 §5.3 is the
list of things you do not compute at all** — they arrive from the transcript (§6).

Every observation you emit is written in **NORMATIVE-OBSERVATION-FORMAT-0** (in the packet). Emit
exactly that format: no extra normative fields, no omitted required fields, no reordering of things
the format calls ordered, no flattening of nested payloads, no coercion of integers.

Two specific things people get wrong, stated because they are cheap to get right:

- **Nested refusal payloads keep their exact shape** — depth, element count, and each leaf. A
  flattened or truncated payload is a divergence.
- **Absent is not empty is not nil.** If the format distinguishes them, distinguish them.

### Questions about ambiguity — the one rule you must not break

**Ambiguities are RECORDED, not answered.** Nobody in the construction loop will tell you what the
specification means, and you must not ask. Instead, keep a **candidate deficit register** and deliver
it with your implementation. One entry per ambiguity:

```
ID:            your own sequential id
WHERE:         document + section you were reading
QUESTION:      what the specification does not determine, stated as a question
READINGS:      each reading you considered, stated fairly
CHOSEN:        which you implemented, and the sentence you leaned on (or "none")
CONSEQUENCE:   what observable behavior differs between the readings
```

**A deficit you record before the run is evidence. A deficit you notice afterward is a story.** If
someone volunteers an answer despite this rule, write down that it happened, verbatim — do not
discard the answer silently, and do not act on it.

**You should expect this register to be long.** The campaign has already found the present public law
insufficient for a clean-room second implementation, without invention or oracle mediation or
consultation of implementation source, in at least twenty-eight registered places — and that finding
was made *before* any implementer was asked. Your register is not a report card on your reading. It
is the instrument.

---

## 6. The Act Oracle transcript — your consumption contract

For each case you will receive, alongside the program source and the environment declaration, a
**frozen act transcript**: data, not code, produced by an instrumented run of J1 and frozen with the
case. **It is the same transcript J1 is given in replay.** It is an input you share with the
implementation you are being compared against.

**What the transcript gives you:**

- for **each act invocation, in textual order**: the arm, the resulting disposition, the class, the
  act-id-hex, and the verdict;
- for **each derive request**: the seat resolution result and the three closed facets with their
  standings;
- for **each step boundary**: the store's validated-prefix length (so that "derive appends nothing"
  is checkable without your having a store at all).

**Your contract, five rules:**

1. **Consume it positionally and in order.** You issue act requests in the order the program's
   textual order requires; the transcript's entries answer them in that same order. You do not index
   into it by content, do not search it for a matching arm, and do not skip an entry.
2. **Never compute what the transcript supplies.** Do not derive an act-id, do not classify a
   disposition, do not construct a verdict, do not model the store. If you find yourself
   implementing the act substrate, you have left your work-list.
3. **Carry values through unchanged.** The transcript's values enter your result record and your act
   summaries exactly as given — same type, same case, same characters, no normalization, no
   re-ordering, no defaulting of an absent field into a present one. **Carriage is precisely what is
   being tested at these points; the values are not.**
4. **A transcript that runs out, or that answers a request you did not make, is a case you must not
   silently absorb.** Refuse the case in your own honest way and record it in your deficit register;
   do not improvise a value and do not pad.
5. **If the transcript looks wrong, you record it — you do not fix it.** A transcript defect is
   adjudicated **against the transcript, never against you** (FAILURE-TAXONOMY-P1 §1.3a). Your
   register entry is the evidence that makes that adjudication possible; a silent workaround destroys
   it.

**What the transcript costs the result, said to you plainly:** because the substrate is oracle-
mediated, a perfect run by you earns a narrow sentence (§9) and says nothing whatever about whether
the act substrate is portable. That is by design, it is the owner's ruling, and it is not a
disappointment. It is the difference between a claim that can be defended and one that cannot.

---

## 7. The contamination hazard you must know about

**The lab's `latent-lisp` mirror is a public GitHub repository, and it contains the Common Lisp
implementation of this very language.** It is reachable from the open internet and findable by
search. This is not a hypothetical.

Therefore:

- **Do not search the web for anything related to this specification, this lane, Lisp+, Many Acts,
  One Act, Surface, Process Journal, mneme, or latent-lisp.**
- **Do not open the mirror**, in any form: repository, raw file, search-engine cache, code-search
  index, snippet in an answer, or a page that quotes it.
- **Accessing it — even briefly, even "just to check the file list" — VOIDS clean-room provenance**
  for the entire campaign. Not your case; the campaign. Months of other people's work become unusable
  as evidence of independence.
- If you access it by accident, **say so immediately and exactly**. An honest report costs one
  campaign; a concealed access costs the credibility of every campaign that cites it. There is no
  penalty here for the accident and no forgiveness for the concealment.
- If your environment can be network-isolated, isolate it. If it cannot, **attest by name** which
  resources were reachable and which you used (§8), and understand that your attestation's evidential
  standing is recorded as weaker than isolation's.

---

## 8. Delivery expectations

Deliver, in this order, and note that **the freeze declaration must land BEFORE the holdout is
opened** — that ordering is what makes the held-back cases the *frozen normative cases* of the
hypothesis, and it is the whole experiment:

1. **The implementation.** Complete, runnable, with a one-command entry point that takes a case —
   source, environment declaration, and act transcript — and writes a NORMATIVE-OBSERVATION-FORMAT-0
   envelope to stdout.
2. **A self-run transcript over the entire public vector bank**, produced by you, showing your
   envelopes. You may iterate freely against the public bank — that is what it is for; it is
   construction, not test.
3. **Your candidate deficit register** (§5), complete, **including every transcript oddity you met**
   (§6.5).
4. **The FREEZE DECLARATION**, stating:
   - the sha256 of your implementation tree (state exactly how you computed it, so it can be
     recomputed);
   - that the implementation is final and will not change;
   - the packet manifest hash you verified;
   - the date and time.
5. **Your attestation** (signed, in your own words), stating:
   - what you consulted (the packet, by hash; your substrate's docs; anything else, named);
   - that you did not consult any item in §3's prohibited list — **enumerated by name**, not
     summarized;
   - whether the network was reachable during construction, and whether you used it;
   - whether anyone answered a question of yours about the specification, and if so, who and what they
     said, verbatim;
   - your eligibility: that you are none of the ineligible parties in §3.

**After the freeze declaration is delivered, you may not change the implementation.** The holdout is
then opened and run by an adjudicator who is not you. If a case comes back red and the adjudicator
classifies it as a **port defect**, you — and only you — may repair it; that case's result will be
labeled **repaired** forever, and no report will ever present it as a first-run result. Other
classifications (the specification was underdetermined; the test or the transcript was contaminated;
the older implementation was wrong; a constitutional guarantee was broken) have different
consequences, all pre-registered in `FAILURE-TAXONOMY-CANDIDATE-P1.md`, which would be in your packet
— read it, so you know exactly what each outcome will and will not be used to say.

---

## 9. What is at stake, honestly

If your implementation agrees with J1 everywhere, the campaign earns **one sentence, and only this
one**:

> A clean-room non-Common-Lisp implementation of the Many Acts /0 language layer, consuming the
> frozen Act Oracle Interface, conformed to the canonical language-layer evaluator on the named
> frozen vector set.

**It will never be shortened to "an independent Lisp+ implementation exists."** Not in an abstract,
not in a table header, not in a commit message, not in conversation. That is not modesty; it is the
difference between what the experiment measured and what a reader would assume it measured. The act
substrate was handed to you on a transcript — a claim that ignores that is a claim about work nobody
did.

Nor would a green earn: that the language is portable in general; that the specification is complete;
that the full-stack target (PortJ-F/0) has been approached; that anything is adopted.

If you disagree with J1 somewhere and **the specification did not determine the answer**, that is a
**better** result than agreement, and it is the one this design most wants to be able to detect. It
means the law had a hole and this campaign found it before someone built on it. **Do not smooth over
a place where you had to guess in order to make the numbers pretty.** Write it down, implement your
best reading, and let the comparison say what it says.

The lab keeps a ledger; what you actually found will be recorded accurately, including the silences
you were the first to name.

---

## 10. Standing status of this document

**NOT ISSUED. NOT ISSUABLE. NO RECIPIENT.** This brief is court-construction material held for audit,
under the closures of `OWNER-RULINGS-1` Ruling 7 and `OWNER-RULINGS-2` "Rounds still closed." It
becomes issuable only at Round J, which requires Round H, which requires Round F, which requires all
eight S-freeze preconditions and the owner's disposition of R1 before any of them. **Zero evidence
remains earned.**

---

*— revised by PRAETOR (Claude Opus), Round P, commissioned by the chair (Claude Fable 5),
2026-08-10*
