# AP0 Plan Concordance — DRAFT-F × DRAFT-S

*Chair: Claude Fable 5, 2026-07-18 (reveal night, same day as the freeze). Discount rule as
always: **convergences measure the shared root; divergences and concessions carry the
information.** Ordering proof: F frozen 2026-07-18T23:30:12Z (commitment `f66d3deb…4e617847`,
re-verified byte-exact at reveal); S delivered with matching self-declared sha256
`f1f40a72…f86c9854`, verified on receipt. The two plans are mutually blind, provably — the
PJ0 machinery, reused.*

---

## 1. Convergent (expected; adopted without ceremony, discounted as shared root)

Both parents, blind, arrived at: the **membrane framing** (F "epistemic membrane," S "final
semantic membrane / a skin that records") · **envelope custody precedes projection standing**
(F CAP-then-PRJ; S §9, AP-D5) · **projection as versioned, identified, deterministic
procedure that cannot mint semantic truth** (F PRJ; S §10, AP-D6) · **provider self-report is
testimony, never observation** (F F5; S §0/§11) · **gap 4: §8.1 controls, A.2 gains the
fields by named erratum, adapter-identity + stream relation mandatory** (F F1; S AP-G4 —
identical disposition, independently) · **chunks are real manifestations; `:present-partial`
survives; nothing erases captured partials** (F §6/W2; S §8.3) · **journal-before-delivery as
the reference path** (F §6; S §8.4/AP-D4) · **no blind retry through the conforming surface**
(F F6; S §13/§20.7) · **alias ≠ resolved identity; implicit fallback forbidden** (F F7; S §5)
· **deterministic scripted fake adapter with kill points, full citizen of the same contract**
(F F3/§9; S §17/AP-D8) · **negative controls — a suite that cannot fail is not evidence**
(F §10; S §18) · **single lawful route; raw call outside conformance** (F §7; S §15) ·
**minted condition vocabulary** (F §8; S §16) · **no live-provider authorization** (F §11;
S §20.14) · **the factual kimi/null classification stays outside AP0** (both, explicitly).

That this much arrived twice is pleasant and worth nothing evidentially. Discounted.

## 2. Divergences — the chair's dispositions

**DIV-1 — Acknowledgment taxonomy (S §7, AP-D3). F treated the frontier as one uncertain
window (W1); S decomposes it into a closed ladder** (`:transport-accepted` ≠
`:provider-received` ≠ `:provider-queued` ≠ `:provider-started` ≠ `:provider-terminal`, with
`:acknowledgment-ambiguous`/`:no-acknowledgment`) each with non-promotion laws.
**Disposition: CONCEDE TO S.** The ladder is strictly finer than W1 and every rung is a real
provider behavior; F's W1 becomes the *region* the ladder partitions. S parent-of-record.

**DIV-2 — Request-identity triple with timing classes (S §6, AP-D2).** F journaled config
resolution and attempt identity but had no local-id / provider-idempotency-id /
provider-request-id separation, and no timing-class declaration for when the provider's id
becomes known. **Disposition: CONCEDE TO S.** This is the house uncertain-write doctrine given
a type system; "no provider id may be invented from timestamps or hashes" goes in verbatim.

**DIV-3 — Cancellation (S §12). F omitted cancellation entirely** — not scoped in, not
scoped out. A genuine hole in F, found by the divergence round working as designed.
**Disposition: CONCEDE TO S, whole section** (cancellation as process; local socket closure
is not provider cancellation; cancellation cannot counterfeit no-effect).

**DIV-4 — Reconciliation as first-class operation (S §13).** F had resolution-by-evidence as
a principle (W1 "resolution only by evidence or adjudication"); S gives it an operation, a
closed result vocabulary, and the completeness law (`:not-found` settles no-effect only in a
complete, authoritative domain). **Disposition: CONCEDE TO S.** The completeness law is the
δ-discipline's cousin: an absence verdict needs a domain adequate to assert it.

**DIV-5 — Usage/cost split with standing ladder (S §11, AP-D7).** F dual-recorded
provider-asserted vs locally-measured (that survives as S's `:source`); S additionally splits
usage from cost, gives cost a standing ladder (`:estimated`/`:bounded`/`:provider-reported`/
`:dashboard-confirmed`), bans durable binary-float money, and states missing≠zero.
**Disposition: ADOPT S's fuller form; F's dual-record folds into it.**

**DIV-6 — Capability algebra (S §4, AP-D1).** F declared per-operation idempotency classes
only; S generalizes all capability claims to
`:supported|:unsupported|:unknown|:conditional` with evidence and drift consequences.
**Disposition: ADOPT S** — noting it is F's own absence-table philosophy applied to
capabilities ("unknown support is not unsupported"), which is why the chair concedes with
enthusiasm rather than reluctance.

## 3. F-only holdings (absent or weaker in S; the chair holds them for the spec)

**F-HOLD-1 — The absence-mapping table as a normative contract slot.** S has per-projection
empty/null/missing rules (§10); F requires an **exhaustive** table in the adapter contract
mapping *every* envelope absence-shape to exactly one kernel status, with declared collapses
and a table-miss condition (uncovered shape ⇒ `:present-invalid` + parser identity, never an
improvised call). The Language-A lesson as statute. **Slots into S's descriptor (§3.1) and
projection receipt (§10).**

**F-HOLD-2 — Crash windows W1–W4 as normative spec objects.** S scatters kill points through
fixtures (§17–18); F names the windows (post-send/pre-response · mid-stream ·
captured-unprojected · projected-unconsumed) with required post-crash fold verdicts, as the
structure the four-death specimen targets. S's kill fixtures instantiate F's frame —
complementary, both adopted.

**F-HOLD-3 — Provider-as-principal in the epistemic ledger (F F2, L16/L18).** S declares
which principals *may inspect* what (§14, strong on drift); F goes further: the provider IS a
principal, every consequential send is a `:secret-open`-shaped exposure event *in the
ledger* — blindness spent at the membrane is spent on the record, and the fake adapter's
boundary class occupies the same role-slots. S's §14 is the inspection-side; F supplies the
event-side. Both in.

**F-HOLD-4 — Validator/generator independence at birth.** S requires planted mutants and a
separately-seeded hostile review (§18/§22); F additionally forbids the packet's validation
path from importing/porting the fake adapter's envelope-generation code — R-PJ-3's
two-executables-one-brain lesson applied at authoring time, not discovered by review.

**F-HOLD-5 — The D7 batching statute.** The CONCORDAT found "chunk/checkpoint batching is a
lawful adapter strategy; semantics are the architecture's, batching is the adapter's"
adopted-but-unstated. AP0 states it (F §6); S's stream-policy machinery is where it lands.

**F-HOLD-6 — The L17 route audit as a mechanical conformance item.** S declares the raw call
outside conformance; F adds the checkable form: lawful route ≤ any supported bypass, audited,
in the conformance checklist. Minor, kept.

**Terminology concession:** F's loose `:absent` in the absence discussion → S's precise
kernel vocabulary (`:absent-after-completion` where execution law permits). S was more
careful with the kernel's own words; conceded.

## 4. Proposed authoring charge (for the owner's seal)

Per the PJ0 precedent: **Sol authors the AP0 packet**, DRAFT-S as the working skeleton
(it is the more complete structural document), amended by: DIV-1..6 as adjudicated above
(all to S — no forced merges), **F-HOLD-1..6 incorporated as normative content**, AP-G4
closed per the convergent disposition with the erratum routed to the kernel gaps-1–4
two-chair sitting (F F1's split: kernel carries the fields, AP0 owns the value spaces).
Deliverables per S §21 + F's to-do where not subsumed; the blind-round checklist S §22
continues from its "Produce concordance" line, which this document checks. Fable serves as
adversarial reader at packet time (SCAR-TRACER/MALLET pattern), plus the separately-seeded
hostile review S names.

**Parentage ledger:** DIV-1..6 → S · F-HOLD-1..6 → F · convergences → shared root,
credited to neither.

*— the chair, both plans on the table, parentage visible. The round did what it exists to do:
two blind parents, one real hole found in each direction (F lacked cancellation; S lacks the
exhaustive absence table), and a spec that will be stronger than either draft because the
divergences were genuine.*
