# SOL-READ-KERNEL-0-SYNTHESIS

**Provenance:** GPT-5.6 Sol, relayed 2026-07-18 via owner-pasted chat (integrity rests on this
commit). **Standing:** pre-adoption read of the synthesis candidate. **Verdict: ACCEPT WITH
THREE PRE-SEAL REPAIRS** — all eight adjudications accepted (including the two that conceded
against its own base text's looseness, and the two that conceded against the chair's parent);
R-SYN-1..3 applied by the chair same-day with Sol's exact text, ledgered in the synthesis
parentage ledger. Verbatim below.

---

# SOL READ — Kernel /0 synthesis candidate before owner seal

**From:** GPT-5.6 Sol
**To:** Tomás and Claude Fable 5
**Standing:** pre-adoption read of the synthesized `LISP-PLUS-KERNEL-0-SPEC.md`
**Verdict:** **ACCEPT WITH THREE PRE-SEAL REPAIRS**

The synthesis is faithful in structure and parentage. I accept all eight adjudications, including:

* **ID-1 adopt-S:** durable identity requires a declared, canonical, restart-stable, non-image-local procedure; store issuance is permitted but not universally mandated.
* **OUT-3/UNC-1 adopt-F:** bounded or indeterminate external-effect settlement requires a structured uncertain-effect record capable of carrying retry prohibition and reconciliation obligations across restart.
* **JRN-1 merge:** the kernel must expose the human-readable requirement while the Process Journal /0 successor owns exact storage grammar, bytes, framing, and atomicity.
* **FIX-2 adopt-S:** the 56-test and 10-negative-control suite is the stronger base, reconciled to Architecture 0.1's thirty-seven adversarial classes.
* **Placement:** uncertain-effect belongs under effects/frontiers; the absence-related causal-claim protocol belongs immediately beside the manifestation state/cause separation.

The synthesis also correctly preserves the call-296 axis values from Architecture 0.1/E-1, retains DRAFT-S's full semantic scaffold, and records the parentage rather than laundering the merge into an apparently parentless text.

I found three repairs required before sealing.

## R-SYN-1 — The call-296 fixture must be explicitly identified as an axis projection

Sections 9.4 and 10.8 impose a clear constructor law:

> A bounded or indeterminate effect axis must reference a structured uncertain-effect record; inline alternatives and evidence alone must signal `unstructured-uncertainty`.

But the normative call-296 fixture in §22 preserves the Architecture 0.1 four-axis form byte-identically and shows only:

```lisp
(:effects
  (:value :bounded
   :determinacy :bounded
   :alternatives (:billed :not-billed)))
```

As presently written, an implementer could reasonably read §22 as a complete constructible Kernel /0 outcome fragment. That fragment would violate §§9.4 and 10.8 because it contains no uncertain-effect-record reference.

The architecture fixture should remain byte-identical. The repair is to state that it is a **canonical axis projection**, not the complete concrete Kernel /0 record.

Insert after the quoted fixture in §22:

> **Projection status.** The byte-identical form above is the controlling Architecture 0.1/E-1 projection of the four outcome axes. It is not a complete concrete Kernel /0 outcome record. A conforming construction of this fixture MUST additionally bind the bounded effect axis to a structured uncertain-effect record satisfying §10.8. That binding lives in the enclosing outcome/evidence structure and does not alter the quoted architectural projection. Constructing the quoted bounded axis inline as the complete effect representation MUST signal `unstructured-uncertainty`.

Also sharpen §25.1 test 7 from:

> per-axis bounded alternatives validate

to:

> a bounded effect axis validates only when it references a structured uncertain-effect record; inline-only bounded construction signals `unstructured-uncertainty`

This preserves E-1 byte fidelity while preventing the canonical fixture from becoming the canonical bypass around the newly adopted primitive.

## R-SYN-2 — The journal seam currently binds framing while claiming to defer framing

Section 13.1 says:

> The reference journal MUST be human-readable S-expressions, one record per line or form, with no binary framing.

The immediately following merge note says exact grammar and byte framing remain delegated to Process Journal /0. Section 27.1 repeats that record framing belongs to the successor specification.

Those statements do not quite coexist. "One record per line or form" and "no binary framing" are already framing constraints. The synthesis intended to bind **readability**, not pre-write the journal byte specification.

Replace the opening of §13.1 with:

> A process event is a canonicalizable record proposed to or committed by a Mneme store. A conforming Mneme journal MUST expose a normative, human-readable S-expression representation of every committed event sufficient for inspection and evidence replay. The canonical reference journal SHALL use human-readable S-expressions. A binary-only representation with no normative S-expression rendering is nonconforming. Exact S-expression grammar, storage framing, canonical byte conversion, record delimiters, length prefixes, and atomicity mechanisms are delegated to `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`.

This preserves the adopted D4 readability law while leaving the successor free to choose line-delimited forms, form-delimited records, textual length prefixes, or another inspectable framing that satisfies canonicality and torn-tail recovery.

Otherwise Process Journal /0 arrives at its own workshop to discover that the kernel has already chosen half its tools and left a note saying "exact tool choice deferred."

## R-SYN-3 — The total preflight order evaluates scope before resolving its operands

Section 10.4 currently mandates:

1. capability present / unrevoked / **in-scope**;
2. identity resolution, including machine configuration;
3. seat/attempt validity;
4. budget and call count;
5. destination;
6. retry policy;
7. execution-path closure.

The problem is narrow but real: determining that a capability is **in scope** may require the very machine, route, channel, destination, seat, subject, and principal identities resolved in the next step. Scope is a predicate over an identified requested action. It cannot always be evaluated before that action has been identified.

The architecture requires pre-frontier closure and cheap refusal, but it does not require one impossible universal total order. The kernel should impose a dependency-respecting partial order and permit implementations to order independent pure checks cheaply.

Replace the ordered paragraph in §10.4 with:

> The invocation preflight MUST use a declared, deterministic, dependency-respecting order. At minimum:
>
> 1. resolve the minimum identities required to identify the requesting principal, operation, capability, and requested effect;
> 2. establish capability presence, liveness, revocation standing, and expiry before any probe that itself requires authority;
> 3. resolve all remaining identities required to evaluate scope, including machine configuration, seat, attempt, channel, and destination where applicable;
> 4. evaluate effect authorization and capability scope against those resolved identities;
> 5. check seat occupancy, attempt legality, idempotency identity, and unresolved predecessor effects;
> 6. check budget and call count;
> 7. check destination availability and retry policy;
> 8. perform execution-path closure;
> 9. cross the frontier only after all required checks succeed.
>
> Independent, pure checks MAY be reordered to obtain cheaper refusal, provided no scope-dependent check precedes resolution of its operands, no authority-requiring probe precedes the relevant authority check, and the effective order remains inspectable. Each failure MUST produce its own typed condition and external-effect value `:not-entered`.

This retains Fable's important insight—preflight ordering is normative, not a bag of checks an implementation may perform after spending—without freezing a total order that cannot lawfully evaluate its own first predicate.

## Disposition on the highlighted adjudications

### Uncertain-effect record

**Accepted.**

It is kernel material because it is not merely a prettier packaging of alternatives. It is the durable bearer of:

* the unresolved effect proposition;
* known facts;
* reconciliation procedure;
* retry prohibition;
* relation to attempt and request identity.

Inline alternatives can describe uncertainty at one moment. They cannot, by themselves, carry the restart-time prohibition against blind repetition. That distinction justifies the primitive.

R-SYN-1 is therefore not resistance to adopt-F. It is enforcement of adopt-F against the canonical fixture.

### ID-1

**Accepted as written.**

The merge note captures my intended floor. Content-addressed, store-issued monotone, UUID-like, and other identity procedures remain admissible if they are:

* declared;
* canonically represented;
* domain-separated;
* restart-stable;
* non-image-local;
* collision-governed.

"Store-issued" was one sound implementation strategy accidentally promoted into universal ontology. Dropping that mandate is correct.

### Journal seam

**Accepted after R-SYN-2.**

Kernel /0 owns:

* semantic event fields;
* event vocabulary;
* transition legality;
* ordering authority;
* fold obligations;
* visibility of torn tails;
* incremental persistence law.

Process Journal /0 owns:

* exact textual grammar;
* canonical bytes;
* framing;
* append atomicity;
* commit markers;
* filesystem layout;
* prefix-validation encoding;
* merge and reconstruction receipt encoding.

Readability belongs in the kernel as a conformance property. Framing belongs in the journal spec as a representation decision.

### Fixture suite

**Accepted.**

DRAFT-S's 56 tests plus 10 negative controls is the right base. Retiring the inherited "20" count is not a judgment call; it is correction of a superseded-draft transcription. The negative-control principle is especially important: a suite that cannot be made to fail for the intended defect is decorative furniture.

R-SYN-1 should be integrated by sharpening existing algebra test 7 rather than changing the suite's headline count.

### Placement choices

**Accepted.**

The uncertain-effect record belongs under **Effects and frontiers** because its principal operational consequence is settlement and retry law, while the outcome axis references it and supersession/reconciliation act upon it elsewhere.

The causal-claim protocol belongs beneath **Manifestations → Causal diagnosis** for Kernel /0 because its presently adopted mandatory use is the separation of absence state from explanation. The generic located-claim protocol remains broad enough for libraries to express causal claims about execution, effects, or other subjects later without enlarging the closed manifestation-state algebra.

## Final recommendation

Apply R-SYN-1 through R-SYN-3 as traced pre-adoption repairs, preserving both parent drafts and recording these changes in the synthesis parentage ledger.

After those repairs:

> **I recommend owner adoption of `LISP-PLUS-KERNEL-0-SPEC.md` as governing Kernel /0.**

No implementation authorization follows from that adoption. The successor sequence remains:

```text
Process Journal /0
→ Adapter Protocol /0
→ Vertical Specimen /0
→ explicit implementation authorization
→ runtime + deterministic fake adapter
→ forced-kill evidence
→ stranger primitive-minimization audit
```

The synthesis did what a good synthesis should: it made the parent asymmetries productive rather than averaging them into beige paste. These three repairs merely prevent its strongest new clauses from leaving tiny trapdoors beneath their own feet.

— Sol
*pre-seal read; accepting the synthesis after three named seam closures*
