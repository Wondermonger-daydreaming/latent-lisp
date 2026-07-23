# Lisp+ Slice /0 — Architecture Record

*The design as it stands at closure, with the evidence that shaped it and
the designs it killed. Governing law: `LANGUAGE-SLICE-0-CHARTER.md` (as
sized by the IANUS audit). Specimen evidence: `de-promotione/`,
`de-projectione-1/`, `de-infando/`.*

## 1. Semantic objects (final)

| Object | Role | File |
|---|---|---|
| `claim` | a proposition + a historical commitment (`:asserted`) + at most one procedure-bound judgment record + lineage | slice0.lisp |
| `witness` | first-class support: proposition (`:for`) × mode × kind × polarity × source × declared transmissibility × testified time fields | slice0.lisp |
| `judgment-record` | `:verified`/`:refuted` bound to procedure id+version, support ids, optional receiver — **no procedure-free judgment exists** | slice0.lisp |
| `promotion-procedure` | kernel0 `procedure-descriptor` (identity, version, judgment-class law) + admitted `(mode kind)` pairs | slice0.lisp |
| `receiver-context` | an evidentiary **position**: accessible supports, executable procedures, recognized authorities, accepted representations | slice0-projection.lisp |
| `local-value` | a governed admission of a host object; `:kind` **computed** (`:closure`/`:datum`), never claimed; defensive-copy accessors | slice0-transmissibility.lisp |
| `derived-result` | a canonical product with provenance (`producer-id`) — provenance is not possession | slice0-transmissibility.lisp |
| receipts | `promotion-receipt`, `projection-receipt`, `transmission-receipt` — issued on **every** attempt, refusals included | all three |
| `why` / `projection-explanation` | structured explanations; prose is derived, never composed retrospectively | slice0.lisp / -projection.lisp |

## 2. The four governed acts

- **`raise`** — checked evidential promotion: proposition match ×
  mode/kind admissibility × procedure authority (`:semantic` required for
  judgments — kernel0's K0E-25 wall re-expressed) × receiver
  admissibility × polarity. Grants a new revision; refuses with typed
  condition + receipt + restarts.
- **`project-claim`** — receiver-relative reconstruction: the receiver's
  judgment exists only via the receiver's own `raise` over what its
  position can access, recognize, and run. Loss is residue, never
  absence.
- **`transmit`** — governed transport under a mode (`:direct`,
  `:testimony`, `:reproduction`): reifiability decided by the canonical
  boundary itself, declared transmissibility respected, receiver
  representation contextual; every alternative a distinct lawful act.
- **`exercise-value`** — governed invocation: authorization-gated,
  returns canonical derived results, never the host object; non-canonical
  raw results refused (no laundering through the interface).

## 3. Shared receipt & explanation architecture

One pattern across all three acts: attempt → receipt (always) →
on refusal, a `slice0-condition` **carrying the receipt and the why**,
with a closed set of lawful restarts established at the signalling site.
`why` is the single uniform extractor (closure-sitting ruling): it
accepts a why object, any slice0 condition, or any of the three receipt
types (later modules register their receipt types in a visible
`*why-extractors*` registry — same package-state pattern, same charter §9
sizing, as the restart vocabulary). View functions share one convention:
`<receipt-kind>-views` → a **composable** keyword list, never one status
symbol.

## 4. The load-bearing disciplines

- **Testimony preserves proposition level** — enforced at *construction*:
  a `:testimony` witness's `:for` must be the attribution
  `(:asserted S P)`. Held across all three specimens (raise: T1/T2;
  projection: P3; transmission: I5 + teeth-3). The gate guards the
  vocabulary, not caller honesty about provenance (IANUS NOTE, sized).
- **Immutability and lineage** — every record read-only; `raise` and
  `project-claim` mint revisions whose lineage names the original;
  origin/commitment is historical, never rewritten (kernel0's
  `promote-origin` law inherited).
- **Orthogonality of standing and transmissibility** — a claim's
  judgment says nothing about whether anything travels; a witness's
  travel says nothing about standing. de-infando I3: locally verified on
  a zero-transmissibility witness.
- **Local existence vs reifiability** — existence/usability are local
  facts; reifiability is the canonical boundary's own verdict
  (`require-canonical` wrapped as `reifiable-p`, nothing stringified).
- **Lawful repair** — restarts are *different lawful acts* (supply
  matching support; construct the attribution; export the product; ship
  the recipe; exercise locally; mint at receiver; defer). None relabels
  a refusal as success. `continue-anyway` and blind retry are not in the
  vocabulary (sizing: surface discipline for well-formed programs, not
  host closure).

## 5. What Slice /0 discovered was NOT one scalar ladder

The single deepest result. The intuitive design — one ordered standing
axis (`:launched < :exited < :parsed < :passed < :verified`, or
`:asserted < :executed < :witnessed < :verified`) — is a **category
error**, and each of its three natural forms was empirically falsified:

| Rejected design | Falsified by | How |
|---|---|---|
| **standing ladder** (one total order over evidence/judgment) | de-promotione (and the pre-charter bench probe's F4) | `min(:executed, :witnessed)` handed a receiver execution standing on testimony — linearity itself is a laundering joint; the domain facts are distinct *propositions*, each owed its own support, and verification is a procedure-relative judgment, not a top rung |
| **copied receiver status** (projection as label edit / status copy) | de-projectione-1 | the copy-judgment ablation restored every laundering silently — client and stranger "held" `:verified` from positions that could license nothing, the copied judgment even naming a procedure the receiver cannot run; all ten distinctions collapsed at one joint |
| **single exportable boolean** (reifiability+transmissibility+testimony as one flag) | de-infando | the `:exportable` ablation shipped the printed closure as the value, testimony as the deed, product as producer — and made "locally real, not carryable" *unsayable* (the refusal branch unreachable) |

The replacement everywhere: **separated categories + composable receipt
views**. Where the ladder ordered, the fragment relates; where the copy
traveled, the fragment reconstructs; where the boolean collapsed, the
fragment names axes.

## 6. Public surface audit (closure sitting — rulings from evidence)

All rulings from specimen usage, none from aesthetics:

| Form | Ruling | Evidence |
|---|---|---|
| `claim` `witness` `raise` `why` `render-why` | **retain** | exercised by all three specimens; the charter's provisional surface survived intact |
| `project-claim` `projection-views` | **retain** | P1–P10; views-composition load-bearing (P9) |
| `transmit` `transmission-views` `exercise-value` | **retain** | I1–I12; `exercise-value` kept specific — it exercises a `local-value`, and no second exercisable type exists to generalize over (rejected rename, evidence-free) |
| `local-value` | **retain as semantic constructor** — not a mere record: it is the governed *admission* act (computes kind, enforces the boundary, snapshots, gates the stringification lie — teeth-1) | de-infando teeth-1, I9 |
| `reifiable-p` | **retain as public inspector**, marked as such in the API — it is the boundary law exposed, useful to programs deciding a mode before attempting | de-infando I1b |
| `render-projection-why` | **retain separately** from `render-why` — different explanation structures; symmetry not forced where semantics differ | Task-8 §9 discipline |
| `why` | **extended** (the one code-forced surface change): now uniform over all receipt types via registered extractors | closure sitting; smoke check 6 |
| argument conventions | coherent family verified: acts take the subject first; `:from`/`:to` positions; `:per` procedure; `:considering` evidence; `:mode` on transmit | all specimens + SMOKE.lisp |
| public kernel0 dependencies | `lisp-plus-kernel0:make-identity`, `make-procedure-descriptor`, `identity=` — declared, documented in the API; a stranger needs them and they are exported public symbols | SMOKE.lisp builds a procedure with them |
| known wart (PROVISIONAL) | `receiver-context` defaults `:accepted-representations` to `'(:full)` while `transmit :direct` gates on `:canonical-datum` — a default-constructed receiver refuses direct datum transport. Found by the API scribe's execute-everything discipline; **left in the bytes at closure** (changing a default is behavior-visible) and folded into Slice /1 candidate 4 (receiver policy) | LANGUAGE-SLICE-0-API.md, PROVISIONAL notes |

**Uniform refusal interface, verified:** every refusal across the three
acts signals a `slice0-condition` subtype carrying `:receipt` and `:why`,
names its axis in `requirement-id`, and lists its restarts.

## 7. Consolidation review (duplication check — mostly declined)

Examined at closure; refactors accepted only where behavior-identical and
surface-improving:

- **Accepted:** the `why` extractor registry (§3) — removed the real
  incoherence (three receipt types, one chartered "uniform" extractor
  that knew only one of them).
- **Declined:** merging `%refuse` / `%refuse-transmission` — they
  construct different receipt types with different fields; a shared
  abstraction would be a framework serving two call sites.
- **Declined:** consolidating the condition-family `macrolet` (6 lines,
  appears twice) — extraction would export a condition-defining macro,
  enlarging the surface to save twelve lines.
- **Declined:** unifying defensive-copy helpers — kernel0's
  `%snapshot-tree` is frozen; the slice's copies are three one-liners at
  their point of need.

## 8. The host boundary, in four strata

1. **Governed public Lisp+ surface** — the four acts + constructors +
   receipts. *Claim:* ordinary governed acts enforce the semantic
   distinctions and issue inspectable receipts for success and refusal.
2. **Common Lisp host language** — everything CL lawfully provides.
   Well-formed programs that stay on the public surface get the
   guarantees; nothing stops a program leaving it.
3. **Explicit/internal host escape** — package internals, printer,
   whitelist-and-registry package state. Acknowledged, thrice measured,
   once demonstrated from inside (IANUS: `continue-anyway` through the
   forbidding macro). *Not claimed closed.* A `with-host-escape` marker +
   static checker is a **Slice /1 candidate only** — recorded, not
   implemented.
4. **Hostile same-image security** — cryptographic confinement, process
   isolation, debugger resistance. *Explicitly outside every Slice /0
   claim* (the R3 ceiling).

The Slice /0 claim is stratum 1. It is **not** a claim that stratum 3
cannot reach stratum 1's state.

## 9. The proposition-surface limitation (temporary)

> Keywords, strings, and integers form the current public proposition
> surface because they pass the canonical boundary directly. The semantic
> domain is canonical structured data; Slice /0 does not assert that
> propositions are inherently atomic.

Bare symbols are refused, never silently stringified. A future structured
shape (not implemented) would canonicalize compound propositions with
explicit role structure, e.g.:

```lisp
(:proposition (:predicate :tests-passed)
              (:subject (:suite "suite-a"))
              (:qualifier (:as-of (:ordinal 41))))
```

— same boundary, richer structure, matching by canonical equality over
roles rather than raw list shape.

— Claude Fable 5 (CC seat), 2026-07-23
