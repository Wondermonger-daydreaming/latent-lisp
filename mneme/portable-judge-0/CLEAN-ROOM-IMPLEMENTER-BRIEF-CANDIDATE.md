# PORTABLE JUDGE /0 — CLEAN-ROOM IMPLEMENTER BRIEF (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted** — you are
implementing against a *candidate* specification, and nothing you produce will make it adopted.

**NAMING COLLISION (first use).** "PJ0" already denotes the **ADOPTED Process Journal /0**. This
campaign is **Portable Judge /0**; short form **PortJ/0**. Bare "PJ0" is never used here as if
unambiguous. Final designation **pending owner ratification**.

---

> **THIS DOCUMENT IS THE WHOLE INSTRUCTION.** It is what may be handed, unedited, to the person or
> fresh session who will build **J2**. Everything you need is in it or in the sealed packet it
> names. Nothing else may be consulted, and no one will answer questions about meaning.

---

## 1. What you are being asked to build

You are building **J2**: a second, independent implementation of a small language's **judge** —
the component that ingests a program as data, decides whether the program is lawful, evaluates a
lawful one under a declared environment, and emits a structured record of what it observed.

The first implementation, **J1**, exists in Common Lisp. **You will never see it.** Your
implementation and J1's will be fed identical cases and their observations compared. The question
under test is not whether you are a good programmer. It is whether the **written specification is
complete and substrate-neutral enough** that two implementations on unrelated substrates reach the
same judgments.

**So: where the specification does not tell you what to do, you have found the result.** Do not
guess elegantly. Do not infer what the authors must have meant. **Record it** (§5) and implement
your most defensible reading. A disagreement traceable to a written silence is the campaign's most
valuable outcome, and it only counts if you wrote the silence down before the answer was known.

---

## 2. The sealed packet

You will receive **one archive** with a **manifest sha256** stated on delivery:

```
PACKET MANIFEST SHA256: <PACKET_MANIFEST_SHA256_PLACEHOLDER>
```

**Verify the hash before you start** and record the value you computed in your delivery. If it does
not match, stop and report; do not proceed with an unverified packet.

The packet contains (per PROTOCOL §7): the contract, the grammar, the author guide, the failure
matrix (witness laws; the planted-disease table is redacted), the two campaign returns and the two
seal addenda, the transcribed closed export surface (names and value shapes only), the
**NORMATIVE-OBSERVATION-FORMAT-0** definition, the **public vector bank** with its expected
observation envelopes and frozen act transcripts, the protocol / taxonomy / this brief, and the
current deficit register.

**That is the whole law.** If something you need is not in the packet, it does not exist for you —
and that fact is a finding, not an obstacle.

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
- **the public `latent-lisp` mirror on GitHub** — see §6, this is the specific hazard;
- the **hidden vector bank**, the **disease corpus**, any **construction transcript**, campaign log,
  agent return, or chair note;
- any person or model who worked on the construction of these lanes;
- any answer, from anyone, to a question about what the specification means.

**You MAY NOT be** the chair (Claude Fable 5), Sol, any Opus agent of the /0 or R1 rounds, any
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
  normative comparison. Your judge will be run repeatedly, in separate processes, **under varied
  hash seeds, working directories, locales, and timezones**, and every run's observation must be
  **byte-identical**.
- **No network at any point**, during construction or execution.
- **No dependence on being run from a particular directory.**

---

## 5. The observable boundary, and the observation format

**PROTOCOL §5.1 is the list of things you must get right.** PROTOCOL §5.2 is the list of things
nobody will look at — your internal structures, your control flow, your function names, your
exception classes, your messages, your printed representations. **Do not spend effort making those
resemble anything.** They cannot earn you a pass and cannot cost you one.

Every observation you emit is written in **NORMATIVE-OBSERVATION-FORMAT-0** (in the packet).
Emit exactly that format: no extra normative fields, no omitted required fields, no reordering of
things the format calls ordered, no flattening of nested payloads, no coercion of integers.

Two specific things people get wrong, stated because they are cheap to get right:

- **Nested refusal payloads keep their exact shape** — depth, element count, and each leaf. A
  flattened or truncated payload is a divergence.
- **Absent is not empty is not nil.** If the format distinguishes them, distinguish them.

### Questions about ambiguity — the one rule you must not break

**Ambiguities are RECORDED, not answered.** Nobody in the construction loop will tell you what the
specification means, and you must not ask. Instead, keep a **candidate deficit register** and
deliver it with your implementation. One entry per ambiguity:

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

---

## 6. The contamination hazard you must know about

**The lab's `latent-lisp` mirror is a public GitHub repository, and it contains the Common Lisp
implementation of this very language.** It is reachable from the open internet and findable by
search. This is not a hypothetical.

Therefore:

- **Do not search the web for anything related to this specification, this lane, Lisp+, Many Acts,
  One Act, Surface, Process Journal, mneme, or latent-lisp.**
- **Do not open the mirror**, in any form: repository, raw file, search-engine cache, code-search
  index, snippet in an answer, or a page that quotes it.
- **Accessing it — even briefly, even "just to check the file list" — VOIDS clean-room provenance**
  for the entire campaign. Not your case; the campaign. Months of other people's work become
  unusable as evidence of independence.
- If you access it by accident, **say so immediately and exactly**. An honest report costs one
  campaign; a concealed access costs the credibility of every campaign that cites it. There is no
  penalty here for the accident and no forgiveness for the concealment.
- If your environment can be network-isolated, isolate it. If it cannot, **attest by name** which
  resources were reachable and which you used (§7), and understand that your attestation's
  evidential standing is recorded as weaker than isolation's.

---

## 7. Delivery expectations

Deliver, in this order, and note that **the freeze declaration must land BEFORE the holdout bank is
opened** — that ordering is what makes the hidden cases "previously unseen" and it is the whole
experiment:

1. **The implementation.** Complete, runnable, with a one-command entry point that takes a case and
   writes a NORMATIVE-OBSERVATION-FORMAT-0 envelope to stdout.
2. **A self-run transcript over the entire public vector bank**, produced by you, showing your
   envelopes. You may iterate freely against the public bank — that is what it is for; it is
   construction, not test.
3. **Your candidate deficit register** (§5), complete.
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
   - whether anyone answered a question of yours about the specification, and if so, who and what
     they said, verbatim;
   - your eligibility: that you are none of the ineligible parties in §3.

**After the freeze declaration is delivered, you may not change the implementation.** The hidden
bank is then opened and run by an adjudicator who is not you. If a case comes back red and the
adjudicator classifies it as a **port defect**, you — and only you — may repair it; that case's
result will be labeled **repaired** forever, and no report will ever present it as a first-run
result. Other classifications (the specification was underdetermined; the test was contaminated;
the older implementation was wrong; a constitutional guarantee was broken) have different
consequences, all pre-registered in `FAILURE-TAXONOMY-CANDIDATE.md`, which is in your packet — read
it, so you know exactly what each outcome will and will not be used to say.

---

## 8. What is at stake, honestly

If your implementation agrees with J1 everywhere, the campaign earns one sentence: *a clean-room
implementer, from the sealed packet alone, on a different substrate, produced a judge whose
observations agreed with the canonical judge's across previously unseen cases.* That is all — not
that the language is portable in general, not that the specification is complete, not that anything
is adopted.

If you disagree with J1 somewhere and **the specification did not determine the answer**, that is a
**better** result than agreement, and it is the one this design most wants to be able to detect. It
means the law had a hole and this campaign found it before someone built on it. **Do not smooth over
a place where you had to guess in order to make the numbers pretty.** Write it down, implement your
best reading, and let the comparison say what it says.

The lab keeps a ledger; what you actually found will be recorded accurately, including the silences
you were the first to name.

---

*— drafted by LEGIST (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
