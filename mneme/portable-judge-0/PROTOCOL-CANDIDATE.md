# PORTABLE JUDGE /0 — PROTOCOL (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted.**
Every claim, gate, and instruction below is therefore *prepared against a candidate base*:
nothing here can raise the standing of what it is built on, and a green campaign over a
candidate base yields a claim about a candidate, never about an adopted language.

**NAMING COLLISION (first use, per campaign law).** The token "PJ0" already denotes the
**ADOPTED Process Journal /0** (`mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`).
This campaign is **Portable Judge /0**, directory `portable-judge-0/`. Bare "PJ0" is never
used in this campaign as if unambiguous; where a short form is needed, write **PortJ/0**.
The final designation is **pending owner ratification** and may be changed wholesale.

**Inherited vocabulary rider (AP0 adoption Rider 2, observed here as inherited from the
base lane).** The phrases *"independently verified"* and *"independently validated"* may
not appear in any artifact of the base lane, and this campaign adopts the same
prohibition for itself — which matters more here than anywhere, because this campaign is
*about* independence and would otherwise be the easiest place in the lab to launder the
word. The licensed vocabulary is: **clean-room-constructed**, **cross-implementation
conformance under declared provenance**, **first-run conformance**, **repaired
conformance**. Nothing in this campaign, at any outcome, licenses "independently
verified."

---

## 1. The candidate center claim

Stated verbatim, and framed as a **candidate hypothesis under test**, never as a finding:

> "Given only the frozen public normative packet, and without access to the canonical
> implementation, private vectors, disease corpus, or construction transcripts, an
> independent implementer can construct a Lisp+ judge on a non-Common-Lisp substrate
> whose externally observable judgments conform to the canonical specification across
> previously unseen normative cases."

The claim's three load-bearing words, and what each will be made to mean mechanically:

| Word | Made mechanical by |
|---|---|
| *only* | §7 sealed packet + §8 clean-room provenance + the implementer's non-consultation attestation |
| *externally observable* | §5 observable boundary, with its exclusions binding on the harness |
| *previously unseen* | §9 ordering: J2 freeze declaration lands **before** the hidden bank is opened |

**What a green campaign would earn — the exact ceiling, drafted now so no one may inflate
it later.** *A clean-room implementer, working from the sealed packet alone on a
non-Common-Lisp substrate, produced a judge whose observations agreed with the canonical
judge's on every normative case in the frozen public and hidden banks, at the observable
boundary of §5, under the scoping of §3.* It would **not** earn: that Lisp+ is portable in
general; that the specification is complete (a green run over cases we thought to write is
silent about cases we did not); that the base lane is adopted or adoptable; that either
implementation is correct against anything except the other and the written law.

**The null is publishable and pre-committed as such.** A campaign that ends in
SPECIFICATION UNDERDETERMINATION (FAILURE-TAXONOMY class 2) — J1 and J2 disagreeing with
both readings lawful — is a **success of the instrument and a refutation of the claim as
stated**, to be reported at full strength. So is a REFERENCE DEFECT. Neither may be
reported as a near-miss, and neither may be repaired into a green by tutoring J2.

---

## 2. Governing principle

> **The substrate executes the judge; it is not itself the law.**

Agreement with Common Lisp's incidental object representations, control flow, condition
system, printer, or implementation quirks **is not conformance**. Conformance is agreement
with the *specification-owned meaning* of Lisp+ forms.

Four operational consequences, each of which the harness enforces rather than requests:

1. **A test that can only be passed by a Common Lisp is not a conformance test.** It is an
   ORACLE CONTAMINATION finding against the test (taxonomy class 3), rewritten or voided,
   and never counted against J2.
2. **J1's behavior is evidence about the law only where the law says so.** Where J1 does a
   thing the written packet does not determine, J1 is *a* reading, not *the* reading. The
   older implementation does not win by seniority (taxonomy class 5).
3. **The comparator compares observation envelopes, never implementations.** It never
   reads J2's source to decide a verdict. Source is read only in classification (§ADJUDICATION),
   and only to distinguish a port defect from an underdetermination.
4. **The specification's silences are findings, not defaults.** Where the packet does not
   determine a required behavior, the correct output is a recorded **spec deficit**, never a
   quiet patch and never an oral answer. NOTARIUS keeps the deficit register; §13 seeds it.

---

## 3. Scoping: the two layers, and the Act Oracle Interface

**This section narrows the center claim, deliberately and visibly, and the narrowing is
owner-ratifiable business — it is not a detail.**

The Many Acts /0 judge sits on top of an adopted Common Lisp substrate it does not own.
Its `act` step executes an adopted **One Act /0** arm through `run-act` plus the lane's
public re-composition `ma0-complete-act`, which in turn drives Journal /0 appends,
Capability /0 + /1 authority, Capability /2 uncertain-effect arms, and Surface /2
derivation (base contract §4). Its `derive` step folds a **Surface /2** seat-outcome over
the store's validated prefix.

Therefore the lane decomposes into:

| Layer | Contents | Portable at /0? |
|---|---|---|
| **L — the language layer** | datum ingestion · the closed validator · binding classes and scope · the matching law and branch selection · terminal discipline · result and summary assembly · ownership/copy semantics · the error/refusal boundary · determinism and ordering | **YES — this is what the campaign tests** |
| **S — the substrate layer** | One Act /0 arm execution · the journal store · Capability /0//1//2 · Surface /2 derivation · the act-identity digest · agreement and correspondence verdicts | **NO — not at /0, and this campaign does not claim it** |

**The Act Oracle Interface (AOI) is the declared seam between them.** For every canonical
case, the harness supplies J2 (and, in replay mode, J1) with a **canonical act transcript**:
a data-only record giving, for each act invocation in textual order, the arm, the resulting
disposition, class, act-id-hex, and verdict; and for each derive request, the seat resolution
result and the three closed facets with their standings; and, for each step boundary, the
store's validated-prefix length (so `derive`-appends-nothing is checkable without a store).
The AOI is **data**, produced by J1 in an instrumented native run, frozen with the case.

**What the AOI costs the claim, said plainly.** Under this scoping the campaign tests
whether the *judge* — validation, binding, selection, terminals, observation, ownership,
determinism — is portable. It does **not** test whether the *act substrate* is portable,
and a green campaign says nothing about that. A reader who takes "a Lisp+ judge on a
non-Common-Lisp substrate" to include re-implementing One Act /0 will read the claim larger
than the campaign supports. **The center claim in §1 must therefore be quoted only together
with this section**, and the owner may prefer to amend the claim's wording rather than carry
the scoping in a footnote. That is an open fork, not a decision taken here.

**What the AOI costs the *design*, and the guard.** An oracle interface is a confound
factory: if J1 behaves differently in replay mode than natively, the AOI is measuring
itself. Guard, and it is a **prerequisite gate, not a post-hoc check** (see ADJUDICATION §3):
the replay adapter is added to J1 as a **mode, not a fork** — optional parameters defaulting
to the existing behavior — and the unmodified native path is proven **byte-identical** on the
whole existing floor before any comparison run is admitted. If the identity proof fails, the
campaign VOIDs at the adapter; it does not proceed with a caveat.

---

## 4. Substrate recommendation

**J2: Python.** Chosen for two reasons and no third: (a) **sufficient substrate distance** —
a different reader, different symbol/interning model, different equality lattice, different
condition/exception discipline, different copy semantics, different numeric tower behavior;
these are precisely the axes on which a Common-Lisp-shaped specification leaks; and (b) **low
implementation cost**, which keeps the campaign's cost inside one implementer's sitting and
keeps the finding about *the specification* rather than about the implementer's stamina.

Explicitly **not** chosen: Rust. Rust is **reserved for a possible J3** on a later campaign.
This campaign tests **semantic portability**, not the endurance of an implementer wrestling
an ownership type system in ceremonial combat; a red run in Rust would be ambiguous between
"the spec is Common-Lisp-shaped" and "the borrow checker ate the afternoon," and an
ambiguous red is the one outcome this design exists to prevent.

Substrate constraints on J2, minimal and normative:

- **Standard library only.** No parsing framework, no s-expression package, no Lisp
  interoperation library, no reader ported from Common Lisp. A J2 that imports someone
  else's Lisp reader has moved the question, not answered it.
- **Deterministic by construction.** No hash-order-dependent output, no clock, no PID, no
  filesystem enumeration order, no locale-dependent case operations reaching normative
  comparison, no randomness. `PYTHONHASHSEED` independence is a checked property
  (ADJUDICATION §6), not a habit.
- **No network at any point**, during construction or execution (§8).

---

## 5. The observable boundary

Everything in §5.1 is **normative and compared**. Everything in §5.2 is **excluded** and the
harness may not consult it. The enumeration is grounded in the base lane's public law —
GRAMMAR §§1–6, AUTHOR-GUIDE §§0–10, CONTRACT §§2–8, FAILURE-MATRIX §§1–6. Where an item is
determinable only from the canonical implementation's source, it is marked **[DEFICIT]** and
carried into §13 rather than silently promoted to law.

### 5.1 Observable (normative)

**OB-1 — Datum ingestion.** A program file holds **exactly one** form; an empty file and a
file with a second form are both refused. Reader-evaluation is disabled at the reader
boundary, so a `#.` form dies below the validator. Observable: accept/refuse, and the refusal
code. **[DEFICIT — the canonical ingestion rule is Common Lisp's `read`.** The written law
says "one form," "`*read-eval*` NIL," "read into the program namespace"; it does not specify,
for a non-CL substrate, the token grammar, case conversion of symbols, keyword syntax,
integer syntax, string escapes, comment syntax, or dotted-pair rejection. This is the single
largest deficit in the packet and the most likely site of a class-2 verdict — see §13 SD-8.]

**OB-2 — Validation disposition.** Accepted, or refused. On refusal the observation carries
the **condition family** (one of the exported condition types: `ma0-source-refused`,
`ma0-binding-refused`, `ma0-pattern-refused`, `ma0-environment-refused`,
`ma0-authority-slot-unfilled`, `ma0-environment-stale`, `ma0-composition-divergence`) and the
**refusal code** (`V-SHAPE`, `V-READ`, `V-DATA`, `V-PKG`, `V-BIND`, `V-FIELD`, `V-AUTH`,
`V-RES-AUTH`, `V-ARM`, `V-PATTERN`, `V-TERM`, `V-RETRY`, and the environment/runtime family).
**Refusal *message text* is NOT observable** — the base lane states in its own sources that
condition report text is not a stable interface, and the harness honors that. **[DEFICIT —
no complete code table is published, the codes' datatype is unstated, and the
law→family→code mapping exists only in source; see §13 SD-1.]**

**OB-3 — Refusal footprint.** A validation refusal has **zero footprint**: no store, no
journal append, no mint, no act. Observable as the store-prefix length and the act-summary
list being untouched (via the AOI's prefix accounting). This is FAILURE-MATRIX W-V-FOOTPRINT.

**OB-4 — The program result record.** `program-name` (string) · `disposition` ∈
{`:completed`, `:refused`} · `value` (the terminal payload datum, **nesting preserved
exactly**) · `refusal-code` (the program-authored KEYWORD from a `refuse` terminal) ·
`refusal-detail` (the optional payload datum, **nesting preserved exactly** — a `(list …)`
payload is a nested structure and is compared as such) · `act-summaries` (ordered, **oldest
act first**) · `store-id` (a **label only**; R1-F5 records that it is content-derived and
cannot discriminate two stores, so the harness compares it as a field and never uses it as an
identity).

**OB-5 — The act summary.** `arm` (string) · `act-id-hex` (the 64-character act-identity
digest segment, or absent) · `disposition` ∈ {`:returned`, `:refused`, `:interrupted`,
`:host-fault`, `:mint-refused`} · `class` ∈ {`:a`, `:b`, `:c-i`, `:c-ii`, `:d`,
`:unclassifiable`, `:unpaired-f1`} · `verdict` (agreement-verdict string, or absent on a
mint-refused act). Under the AOI these values are supplied per case; what is under test is
**which summaries exist, in what order, with which fields carried through** — not the
digest arithmetic, which is substrate-layer.

**OB-6 — Branch selection and single-arm execution.** Clauses tested in **textual order**;
the **first holding** clause selected; `otherwise` iff none holds; **exactly one arm's steps
evaluated**. Observable through the arm's consequences: the act summaries produced, the
terminal reached, and the untaken arm's **absence of any act summary and any store
footprint**. (This is the base lane's W-BRANCH-ONE. The mission's phrase "prohibited-branch
nonexecution" maps **here**, and to nothing else — see §6.)

**OB-7 — The matching law.** A value atom holds **iff** the facet's standing is `:present`
**and** the facet value is exactly the pattern value. An absence-keyword atom
(`:absent-from-evidence`, `:malformed-in-evidence`) holds iff the standing is exactly that
keyword. `:and` holds iff every atom holds. Over an act-result, the two axes are
`:disposition` and `:class`, and an absence-keyword atom **never holds**. **No truthiness
participates anywhere**: a non-nil facet holds nothing. Observable as selection outcome
across the hidden bank's discrimination cases.

**OB-8 — Derive ≠ perform.** A `derive` step **appends nothing**: the store's validated-prefix
length is invariant across every derive (AOI-accounted). `(field X AXIS)` over a derived
outcome yields the facet **value** when the standing is `:present`, and the **standing
keyword** otherwise (the typed absence is carried, never filled in with nil).

**OB-9 — Authority decisions.** At **each** act step the slot's occupancy is retrieved from
the environment **by name, explicitly**. An unfilled slot refuses (`ma0-authority-slot-unfilled`)
and **no act begins**. An arm the environment does not admit refuses
(`ma0-environment-refused`). Slot and input names match **case-insensitively** between source
identifiers and environment plans. There is no ambient fallback: no dynamic variable, no
default, no inference. **[DEFICIT — the exact case-normalization rule (upcase of the string
designator) is source-only, and its behavior on non-ASCII is unstated; §13 SD-7.]**

**OB-10 — Static arm-once discipline.** Each of the seven arms may appear **at most once** in
a program text, refused **statically** (`V-ARM`) so the failure has no footprint.

**OB-11 — Terminal discipline and the error/refusal boundary.** Every complete evaluation ends
in exactly one terminal; the last step of `:steps` and of every branch arm is a terminal (or a
branch all of whose arms are); steps after a terminal are refused as unreachable. A `refuse`
terminal is a **lawful outcome**: disposition `:refused`, orderly exit, runner exit code 0. An
**error is not an outcome**: a validator refusal, an environment refusal, an unbranched
lane condition, or a host fault **propagates** and is **never** converted into `:completed`;
the runner's exit code is nonzero. Observable: `(disposition | propagated-condition-family +
code)` and the **process exit code**.

**OB-12 — Ownership and immutability.** Every public reader that hands back a string, a list,
or a payload hands back a **fresh deep copy including mutable leaves**. Mutating what a reader
returned changes **nothing** in the validated program, the environment, or the result.
Observable by a mutate-then-reread probe at every public reader; on a substrate whose strings
are immutable (Python), the observable is the *reread invariance*, which such a substrate
satisfies structurally — and the harness records that it was satisfied structurally rather than
by a copy, because *how* it is satisfied is not observable and must not be scored.

**OB-13 — Determinism and replay.** The same source + the same declared environment + the same
frozen act transcript ⇒ a **byte-identical observation envelope** across repeated runs (≥2, in
separate processes, with hash-seed variation on J2). Output ordering is stable.

**OB-14 — Ordering.** Steps evaluate in strict textual order, exactly once; `act` is the only
consequential step; act summaries are reported **oldest first**.

**OB-15 — Declared bounds and termination.** Source depth and node count are **finite and
declared**; exceeding them produces a **deterministic typed refusal**, never a crash, a hang,
or a stack exhaustion. A **circular source refuses inside the bound** (R1/D3), and so does an
oversize datum met during ownership. **[DEFICIT — the bound *values* (depth 32, nodes 4096,
ownership budget 65536) live only in the implementation's constants; public law says
"declared constants" without declaring them, so no clean-room implementer can conform on a
boundary case; §13 SD-2.]**

### 5.2 Excluded (non-normative; the harness may not consult these)

Internal evaluation traces and intermediate data structures · host exception types, messages,
tracebacks, and the CL condition system's own machinery · condition **report text** · symbol
identity, interning, package objects, and `eq`-ness · object memory layout, struct printing,
and printed representations (including the environment's `print-unreadable-object` form —
R1/D5 hid an interior; it did not publish one) · function, method, module, class, and file
names · control structures, recursion vs iteration, dispatch style · the private environment
**generation counter** (package-internal, never exported: J2 need not have one — only the
observable staleness *refusal* is normative) · `store-id` used as an identity discriminator
(R1-F5) · timing, memory, allocation counts, process ids, temp-directory paths · the on-disk
layout of J2's own implementation.

**Unless the specification explicitly makes one of these observable.** It presently does not.
If a future erratum does, it moves to §5.1 by amendment, never by a harness author's judgment
mid-campaign.

---

## 6. Where the commissioned minimum list exceeds the lane's actual law

The commission's minimum observable list names some things this lane's law does **not**
declare. They are recorded here as **mapped, or absent** — never invented into existence.

| Commissioned item | Status in the base lane's law |
|---|---|
| parsing / canonical datum ingestion | **Present** (OB-1) — but the canonical rule *is CL `read`*; see SD-8 |
| validation · disposition · refusal code · nested refusal detail | **Present** (OB-2, OB-4); "nested refusal detail" is real — a `refuse` payload may be a `(list …)` VEXPR and nests |
| summary order and contents | **Present** (OB-4, OB-5, OB-14) |
| authority decisions | **Present** (OB-9) |
| evidence decisions | **Present in a narrower sense** (OB-7, OB-8): the program's evidence decisions are `derive` + branch over closed facets. The act-internal **agreement** and **correspondence** verdicts are One Act /0's own and reach the language layer only as the `verdict` **string** — they are not the judge's decisions and are AOI-supplied |
| provenance retention | **NOT DECLARED as such.** Two nearby real things exist and neither is a retention obligation: (a) `:provenance` is an **axis** of derived outcomes with values `:live` / `:derived-recovery` / `:none`, and the only published observations show `:none` for every published row — so the axis is nearly untested by the public law itself; (b) act summaries carry ordering and identity fields (OB-4, OB-5, OB-14). The campaign compares (a) and (b) under their real names and does **not** create a "provenance retention" obligation |
| stale / inaccessible support handling | **Half-present.** *Stale* maps exactly to `ma0-environment-stale` (R1/D4): an environment superseded by a later `make-ma0-environment` is refused before the first consequential act, zero footprint in either store. ***Inaccessible* support has no referent in this lane's law** — it is not defined, not exported, not witnessed. It is **not** made up here; if the owner intends a real concept from a neighboring lane, that is a packet amendment, not a harness assumption |
| prohibited-branch nonexecution | **Mapped** to W-BRANCH-ONE (OB-6): the *untaken branch arm* leaves no act summary and no footprint. There is no separate "prohibited branch" construct in this lane |
| deterministic replay | **Present** (OB-13), with the base's own cap: *evaluator determinism under declared fixtures*, never determinism of external reality |
| "any other field the candidate surface declares normative" | Enumerated as OB-1…OB-15; the export list in `package.lisp` is the closed surface, and the CONTRACT's §6 list **disagrees with it** — see SD-6 |

---

## 7. The sealed packet

The packet is a **frozen extract**, delivered as a single archive with a **manifest sha256**.
It is not a repository checkout, not a branch, and not a link. The implementer never browses
the lab tree, the public mirror, or any git history.

**Included (the whole law the implementer may consult):**

1. `MANY-ACTS-0-CONTRACT-CANDIDATE.md`
2. `MANY-ACTS-0-GRAMMAR.md`
3. `AUTHOR-GUIDE.md`
4. `MANY-ACTS-0-FAILURE-MATRIX.md` — **witness laws only**; the planted-disease table (§5)
   is **redacted** (it is construction material and names the mutations)
5. `MANY-ACTS-0-R1-RETURN.md` and `MANY-ACTS-0-RETURN.md` — for the **caps, exclusions, and
   findings registries** (SF-*, F-*, R1-F*), which are part of the law's honest surface
6. `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md`, `SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md`
7. The **closed export surface**, transcribed as a list of names with their arities and
   value shapes (from `package.lisp`'s export list) — names and shapes only, no bodies
8. `NORMATIVE-OBSERVATION-FORMAT-0` (drafted in parallel by NOTARIUS) — the wire format
   every observation is written in, by both judges
9. The **public vector bank**: canonical cases with expected observation envelopes, each with
   its frozen **act transcript** (AOI data), which the implementer may run against freely
10. This PROTOCOL, the CLEAN-ROOM IMPLEMENTER BRIEF, and the FAILURE TAXONOMY
11. The **deficit register** as it stands at packet freeze (so the implementer knows which
    silences are already known, and can add to it rather than guess)

**Withheld (access to any of these voids clean-room provenance):**

- the canonical implementation's source — `ma0-*.lisp`, `package.lisp`, `load.lisp`, the
  drivers, and every predecessor lane's source
- the **hidden vector bank** and its transcripts
- the **disease corpus** and the planted-mutation designs
- construction transcripts, campaign logs, agent returns, chair notes, commit history
- the lab repository and **the public `latent-lisp` mirror**, which contains the Common Lisp
  implementation and is reachable from the open internet (see BRIEF §6)

**A withheld item that the implementer needs is a spec deficit, not a request.** There is no
channel by which the construction loop answers a question about meaning (§8).

---

## 8. Clean-room provenance requirements

Provenance is a **claim**, and like every claim in this lab it is carried by evidence or it is
not carried. The evidence is an attestation plus a structurally constrained environment.

**P-1 — Eligibility.** The J2 implementer is a **fresh human or a fresh model session** with
no participation in the construction of Many Acts /0, One Act /0, or any predecessor lane.
**Ineligible, by name and by class:** the chair (Claude Fable 5); Sol; every Opus agent of the
/0 and R1 rounds; every construction-loop participant; every reviewer who has read the
canonical implementation; **and any session with read access to this repository or its public
mirror.**

**P-2 — The tree is a boot document.** A sibling or agent whose working directory is the lab
repo has already read the implementation, whether or not it opened the file — the lab's own
standing rule (`CLAUDE.md` §I-f: *"you cannot blind-test a sibling that shares your
filesystem"*). J2 is therefore constructed **outside** the repository, from the archive alone,
in a directory containing nothing else.

**P-3 — No network during construction or execution.** The public mirror is on the open
internet and contains the CL implementation; a search away is not clean-room. If network
isolation cannot be enforced, the implementer attests non-consultation **by name of the
resource** and the adjudicator records the weaker evidential standing explicitly, in the
return, at every citation.

**P-4 — No oral tradition.** No question about the meaning of the specification is answered by
anyone. Ambiguities are **recorded as candidate deficits** in the implementer's own register
and delivered with the implementation. A construction-loop participant who answers such a
question converts the campaign's verdict from *conformance* to *tutoring*, and the taxonomy
treats it as class 2 with the answer preserved verbatim as the evidence.

**P-5 — Attestation, signed at delivery.** The implementer states: what was consulted (the
packet, by manifest hash); what was not (the enumerated withheld set, by name); whether the
network was reachable and whether it was used; who, if anyone, was consulted and about what;
and their own eligibility under P-1. An attestation is testimony and is recorded as such —
**never as verification**.

**P-6 — Same-root honesty, if J2 is a model.** A Claude session constructing J2 is same-root
with the chair; a green campaign then measures the *corpus attractor* as well as the
specification. This does not disqualify the run, and it **does** cap the claim: a same-root J2
earns *"conformance under same-root provenance"*, and only a different family or a human earns
the unqualified word. The choice is the owner's; the caveat travels with the result either
way.

---

## 9. Campaign order (the ordering IS the instrument)

| Phase | Event | Gate |
|---|---|---|
| **0** | Draft protocol, adjudication, taxonomy, brief (this set) | Owner disposition on scoping (§3) and naming |
| **1** | NOTARIUS freezes `NORMATIVE-OBSERVATION-FORMAT-0`; the observable boundary is closed | No boundary edits after this point except by recorded erratum |
| **2** | J1 replay adapter added **as a mode**; native path proven byte-identical on the full existing floor | Identity proof **fails ⇒ campaign VOID at the adapter** |
| **3** | Public bank + hidden bank authored; **hidden bank sealed by hash**, plaintext held off-tree | A prereg committed to a tree the subject can read is not a prereg (`CLAUDE.md` §I-f) |
| **4** | Packet sealed; manifest hash published; delivered to the implementer | Packet contents frozen; later additions are recorded amendments with their own hash |
| **5** | J2 constructed clean-room; implementer self-runs the **public** bank | Free iteration here; this is construction, not test |
| **6** | **J2 FREEZE DECLARATION** — implementation hash + self-run transcript + attestation + deficit register, delivered | **Nothing after this may change J2 except under §11 repair, and every repair is labeled** |
| **7** | Hidden bank opened; adjudicator runs the harness | **No evaluator or test may be altered after opening** — J1's, J2's, or the harness's |
| **8** | Classification by a non-implementer adjudicator; verdicts recorded | Per FAILURE-TAXONOMY |
| **9** | Return drafted; first-run and repaired status reported **separately** | §11 |

**The freeze-before-open rule is the whole prereg.** Phase 6's declaration is what makes the
hidden cases *"previously unseen"* in the center claim's sense; without it, the claim is
unearnable no matter how green the run.

---

## 10. Pass conditions

All of the following must hold. Any one failing means the campaign does not pass; which one
failed, and in which taxonomy class, is the finding.

1. **Every normative case in the public bank conforms** — J1 and J2 observation envelopes
   agree at the §5.1 boundary.
2. **Every normative case in the hidden bank conforms**, on the run that follows the freeze
   declaration.
3. **Every inherited disease witness remains red.** Operationally, in two parts, because the
   disease corpus is withheld from J2: **(a)** for each inherited disease, the hidden bank
   contains at least one **discriminating case** whose correct observation differs from the
   observation a judge exhibiting that disease would produce, and J2 answers the healthy way;
   and **(b)** the adjudicator **teeth-checks the discriminator against J2 itself** — a minimal
   adjudicator-authored mutation of J2, applied after freeze and discarded, must turn that case
   red. A discriminator that cannot bite J2's actual code path is not a witness; it is a
   coincidence, and (a) alone would be an untested gate (`CLAUDE.md` §I-f: *a gate that has
   never fired is untested, not passing*).
4. **Prohibited branches remain unexecuted** — the untaken branch arm produces no act summary
   and no store footprint, in both judges, on every branching case (OB-6).
5. **Required provenance survives** — every field enumerated in OB-4, OB-5, and OB-14 is
   present, in order, and carried through terminals and refusals in both judges. (Read under
   §6: this is the retention obligation the lane actually has, not a "provenance retention"
   field it does not declare.)
6. **Replay is deterministic** — OB-13, checked **independently on each judge before any
   comparison** (ADJUDICATION §6).
7. **No evaluator or test was altered after the holdout opening** — evidenced by hashes taken
   at Phase 6 and re-taken at Phase 8, both recorded.
8. **Clean-room provenance is satisfied** — §8, with the attestation on file and its evidential
   standing stated (P-3, P-6).

**Reporting rule, binding on every artifact of this campaign: first-run status is reported
separately from repaired status, always.** A case that was red at hidden-bank opening and green
after a permitted repair is reported as ***repaired***, in its own column, with the original
red transcript preserved. **No repaired green is ever reported as a first-run green**, and no
summary count may merge the two. A campaign whose headline number silently includes repairs has
failed at the thing this protocol was written to prevent.

---

## 11. Repair, and what a repair costs

A red run **may** be repaired, under the taxonomy's class-specific rules (PORT DEFECT: yes;
ORACLE CONTAMINATION: the *test* is repaired, never J2; SPECIFICATION UNDERDETERMINATION,
CONSTITUTIONAL REGRESSION, REFERENCE DEFECT: **no repair earns the campaign** — each opens its
own consequence). When repair is permitted:

- the **original implementation** (by hash), the **freeze declaration**, and the **failure
  transcript** are preserved unaltered, in-tree, before any edit;
- the repair is made by the implementer, not the adjudicator, and not the chair;
- the re-run is labeled **repaired** at every citation;
- **first-run conformance is not earned for that case, ever** — it cannot be recovered by a
  later clean run, and no aggregate may launder it.

---

## 12. Non-claims

This campaign does **not** claim, at any outcome: adoption or adoptability of Many Acts /0 ·
that the base lane is anything but a candidate · independent verification or validation (Rider
2, inherited) · portability of the One Act /0 substrate layer (§3) · completeness of the
specification · that Lisp+ is portable in general · that either judge is *correct* (only that
two judges agree, or do not, at a declared boundary) · that a green campaign licenses a
stranger audit's conclusions, or substitutes for one · that a same-root J2's agreement is a
second witness (§8 P-6) · any change to the meaning, exports, or standing of One Act /0,
Surface /2, Process Journal /0, or any predecessor.

---

## 13. Spec deficits found in drafting (seed for NOTARIUS's register)

Each was found by asking *"could a clean-room implementer conform on this from the packet
alone?"* and answering honestly. **SD-8 is the campaign's central risk.**

| ID | Deficit |
|---|---|
| **SD-1** | **No published refusal-code table.** Public law names some law-codes (`V-SHAPE`, `V-BIND`, `V-RETRY`…) but never publishes the complete set, never states that codes are **strings**, never maps law → condition family → code, and omits the whole environment/runtime family (`MA0-ENV-ARM`, `MA0-ENV-ARMS`, `MA0-ENV-DATA`, `MA0-ENV-GRANT`, `MA0-ENV-REVOKE`, `MA0-ENV-SEAT`, `MA0-ENV-INPUT`, `MA0-ENV-ROOT`, `MA0-ENV-VOID`, `MA0-AUTH-1`, `MA0-RUN-1`, `MA0-RUN-2`, `MA0-OWN-BOUND`). A J2 cannot emit a conforming refusal code from the packet. |
| **SD-2** | **Declared bounds are declared but not published.** GRAMMAR §2 says depth and length are "finite and bounded (declared constants)"; the *values* (32 / 4096 / 65536) live only in the implementation. No boundary-case conformance is possible from the packet. |
| **SD-3** | **No arm → runtime-seat table** (already recorded as F-GUIDE-1). The mapping is obtained by calling an adopted fixture reader, which a non-CL J2 cannot call. Under the AOI the seat resolution is supplied per case; the deficit stands for anyone reading the guide as a spec. |
| **SD-4** | **The derived-facet table is published for three situations only** — untouched seat, completed arm A, completed arm C-i (AUTHOR-GUIDE §6). B-L1, B-L2, B-R, C-ii, and D are unpublished. Any hidden case touching them is unanswerable from public law, and would be a class-2, not a J2 defect. |
| **SD-5** | **Public law contradicts itself on concordance.** AUTHOR-GUIDE §10 cap 9 states the concordance teeth "**have not been built**"; the R1 return reports 7 arms / 126 facets / 0 divergences. The packet must declare which text governs, and the base lane should carry an erratum. |
| **SD-6** | **The contract's export list disagrees with `package.lisp`.** CONTRACT §6 enumerates the "closed" export surface and omits `ma0-environment-stale` and `ma0-environment-stale-store-id`, which R1 added and the package exports. A "closed surface" that two normative documents describe differently is not closed. |
| **SD-7** | **Case-normalization rule is source-only.** AUTHOR-GUIDE §8 says names match case-insensitively; the actual rule (upcase of the string designator) and its non-ASCII behavior are unpublished — and upcase-vs-casefold is exactly the kind of substrate difference this campaign exists to surface. |
| **SD-8** | **The canonical datum-ingestion rule is Common Lisp's `read`, and it is nowhere written down.** The packet specifies "one form," "`*read-eval*` NIL," "read into the program namespace," "UTF-8" — and then leans on `read` for the token grammar, **symbol upcasing**, keyword syntax, integer syntax, string escaping, comment syntax, and dotted-pair detection. This is Common Lisp sitting in the judicial robes: a J2 that ingests differently will diverge on inputs the law never described. **Prediction, recorded before the run: if this campaign returns a class-2 verdict, SD-8 is the most likely site.** |
| **SD-9** | **`+ma0-axes+` is exported without a published shape.** Its structure (a list keyed by branch-head binding class) is documented only in source; the per-axis value constants and the absence keywords are not exported at all, though the axis *values* are published in GRAMMAR §4 and AUTHOR-GUIDE §6. |
| **SD-10** | **`store-id`'s true semantics are published in the wrong document.** R1-F5 (content-derived; cannot discriminate two stores) appears in the R1 return; the AUTHOR-GUIDE presents `-store-id` without the caveat. A reader of the guide alone will treat it as an identity. |
| **SD-11** | **Printed representations are unlegislated.** R1/D5 hid an environment's interior behind `print-unreadable-object`; whether *any* printed form is observable is unstated. This campaign excludes them (§5.2), which is a *decision by the harness*, not a reading of the law — and it is exactly the kind of decision that should be a written erratum. |
| **SD-12** | **The "already-read form" door to `ma0-validate` is unspecified.** AUTHOR-GUIDE §8 says the entry accepts a pathname *or an already-read form*; the V-READ and V-PKG guarantees are properties of the lane's **own reader**, so a form read elsewhere is refused by V-PKG unless the caller replicated the reader's bindings. The guide names a door whose conditions it does not state. |

---

*— drafted by LEGIST (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
