# FABLE-DELTA-TO-GPT-SYNTHESIS

**Status:** the exact M/N delta to `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-SYNTHESIS-CANDIDATE.md`
(frozen; internal sums verified in the GPT relay), authorized by the owner's fork
disposition record of 2026-07-19. The GPT synthesis bytes stay frozen; this delta rides
beside it and folds in at the 0.2 issuance. **Awaiting GPT's byte-exact verification** —
each edit is old-text → new-text against the frozen file, so verification is mechanical.
**Author:** Claude Fable 5, 2026-07-19. Rationale for every edit: reconciliation §3
(`FABLE-KERNEL-0-ERRATA-RECONCILIATION.md`, sha256 `678eb02b…bc1ad3ba`).
**Matching convention (verified against the frozen file before relay):** OLD blocks quote
logical sentences; the frozen source hard-wraps lines mid-sentence, so matching is on
**whitespace-normalized text** (collapse runs of whitespace/newlines to one space), then
the NEW text is re-wrapped to the file's prevailing style. Site anchors, chair-verified
by grep against the frozen bytes: K0E-5 tail at source line 104; K0E-2 at 69–72; K0E-7 at
113–116; K0E-20 tail at 291; K0E-9 field at 150; K0E-28 at 444.

---

## M-1 — §23 stay for the call-296 row (new clause K0E-5a)

**Insert after K0E-5's final paragraph** ("The existing pure-core singleton fixture …
quarantined from post-erratum conformance counts."):

> **K0E-5a.** Kernel /0 §23 is amended accordingly: the §22 call-296 row's obligation to
> be *"constructed, journaled, killed-and-reconstructed, and re-derived byte-identically"*
> is **STAYED** pending the K0E-5 sealed act. The stay is a **named exclusion** that MUST
> appear, with this requirement ID, in every conformance report; a report that counts the
> row as passed, or omits the exclusion, is nonconforming evidence. The synthetic K0E-6
> fixture discharges the algebra-coverage intent of the row during the stay. All twelve
> remaining §23 rows keep their full obligation unchanged.

## M-2 — explicit §7.4 replacement (amend K0E-2)

**Replace K0E-2's second and third sentences:**

OLD:
> If one current value is positively licensed under the named procedure, the mode is
> `:determinate`. If no lawful finite set of at least two complete alternatives can be
> named, the mode is `:indeterminate` or the enclosing specification projection remains
> non-constructible.

NEW:
> If one current value is positively licensed under the named procedure, the mode is
> `:determinate`. If no lawful finite set of at least two complete alternatives can be
> named, the mode is `:indeterminate` or the enclosing specification projection remains
> non-constructible. **Kernel /0 §7.4 is amended to match: its sentence "`:indeterminate`
> means the kernel cannot currently provide a lawful finite alternative set under the
> available evidence and procedure" is REPLACED by "`:indeterminate` means the kernel
> cannot currently provide a lawful finite alternative set of at least two complete
> alternatives under the available evidence and procedure."** The three determinacy
> definitions (§7.2, §7.3 as amended by K0E-1/K0E-2, §7.4 as amended here) are thereby
> boundary-consistent: exactly-one-licensed ⇒ determinate; two-or-more-bounded ⇒
> bounded; otherwise indeterminate.

## M-3 — widen K0E-7 to the row class

**Replace K0E-7 in full:**

OLD:
> **K0E-7.** Record `:absence-state-name-presupposes-completion` as an unresolved
> architecture-level unknown: execution is indeterminate while the only named projected
> absence state presupposes completion. This erratum does not invent a new absence state.

NEW:
> **K0E-7.** Record `:absence-state-name-presupposes-completion` as an unresolved
> **architecture-level** unknown, at its true scale: the limit is a **row-class**
> problem, not a call-296 quirk. Architecture 0.1 §17's "uncertain write" row itself
> classifies the manifestation as *"bounded or absent-so-far,"* and §13.8's
> tail-could-contain-settlement cases raise the same need on the manifestation axis —
> in every such case the second complete alternative is unnameable under the closed
> vocabulary without a payload identity (§9.6). Until an Architecture 0.1 act amends the
> absence-state vocabulary (or otherwise supplies the missing law), every
> uncertain-write-shaped manifestation axis carries this bounded unknown and falls under
> the K0E-2 non-constructibility/indeterminate branch rather than a derived singleton.
> This erratum does not invent a new absence state (§28 stops 1 and 3).

## N-1 — authorizing basis grants nothing (append to K0E-20)

**Append to K0E-20, after "Bare publication signals `bare-visibility-scope`.":**

> The `:authorizing-basis` field is a **reference, granting nothing**: it names the
> capability fingerprint or claim identity under which the visibility act was authorized,
> and confers no authority itself. Capability-authority law is unchanged by this erratum.

## N-2 — inspection traversal of stream references (new clause K0E-28a)

**Insert after K0E-28:**

> **K0E-28a.** The §21 inspection surface MUST traverse the stream relation: a conforming
> inspector reaches the referenced chunk records' sequence, predecessor, finality, and
> adapter-identity evidence starting from the manifestation record, without requiring the
> caller to negotiate a separate store contract. Reference-based lineage is lawful
> because it remains inspectable; a reference a conforming inspector cannot resolve is a
> missing relation, not a lean one.

## N-3 — receipts by reference in the evidence bundle (amend K0E-9's field comment)

**In the K0E-9 bundle sketch, replace the line:**

OLD:
```lisp
  :append-receipt-ids (...)
```

NEW:
```lisp
  :append-receipt-ids (...)        ; PJ0 append receipts BY REFERENCE (PJ0 §9.4);
                                   ; never restated frame bytes — no second grammar
```

---

## Delta ledger

| Edit | Kind | Authorized by | Rationale |
|---|---|---|---|
| M-1 / K0E-5a | ADDITION (amends Kernel §23 reach) | fork 2 seal | an adopted MUST cannot be left standing unsatisfiable (Kernel §0) |
| M-2 / K0E-2 | REPLACEMENT (explicit §7.4 amendment) | fork 1 seal | the trichotomy's definitions must agree at the boundary |
| M-3 / K0E-7 | REPLACEMENT (scope widening) | fork 2 seal | A0.1 §17 row class + §13.8 hit the same vocabulary limit |
| N-1 / K0E-20 | ADDITION (clarification) | fork 6 seal | no accidental authority implication |
| N-2 / K0E-28a | ADDITION | fork 5 seal | reference-lineage lawful iff inspectable (§21) |
| N-3 / K0E-9 | EDITORIAL (comment) | — | keeps the no-second-grammar guarantee visible at the definition |

Nothing else in the GPT synthesis text is modified. After GPT's verification, the 0.2
issuance = frozen GPT synthesis + this delta folded, new sums, owner's final seal.

*— Claude Fable 5, delta for verification, 2026-07-19*
