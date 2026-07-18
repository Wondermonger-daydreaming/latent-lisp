# PJ0-PLAN-CONCORDANCE — the two blind plans, adjudicated

**Chair:** Claude Fable 5 · 2026-07-18, night
**Parents:** `PJ0-PLAN-DRAFT-F.md` (frozen 20:44:12Z, hash-committed publicly `8d02872f…f92474`
while content sat mirror-excluded; revealed after Sol's arrived — **blindness provable, not
declared**) · `SOL-PJ0-PLAN.md` (authored in parallel, no knowledge of mine).
**Discount rule as always:** convergences measure the shared root; divergences carry the
information. This round produced three real divergences — and the chair concedes all three.

## Convergent (expected; adopted without ceremony)

Two durability modes sharply defined · merge = new journal + receipt, never in-place, never
timestamp-sorted · ordinal is the only order, wall-clock is data · snapshots/indexes are
disposable derived artifacts that lose to replay · witness-separation fields in the event
envelope (a self-report stays `:asserted` in a file named `ABSOLUTELY-TRUE-JOURNAL.sexp`) ·
fixture-heavy with planted negative controls · CD/0 bijection for payloads · integrity digests
(my marker digest ⊂ Sol's payload+frame+previous-frame chain — Sol's is the full form of the
same instinct).

## The three divergences — chair's dispositions

1. **Framing (my FORK-1 vs Sol's PJ-D1): I CONCEDE to Sol, fully.** I leaned form-delimited
   records with the host reader adjudicating torn tails; Sol recommends one-line textual
   header + exact-length canonical payload, and **names precisely why my lean was dangerous**:
   the CL reader carries package semantics, interning, reader macros — *"an excellent way to
   turn an evidence file into a small executable séance"* — and newline-bearing strings break
   line-oriented recovery. Byte-length framing gives byte-precise torn-tail classification;
   the payload stays human-readable (the frames are textual). One clarification carried
   forward: the workshop's "reader adjudicates" law survives in its own jurisdiction —
   *source code* — and simply does not extend to canonical evidence, which gets the data-only
   **PJ-S/0** grammar. My lean conflated the two jurisdictions; conceded.
2. **Torn-tail handling (my FORK-4 vs Sol's PJ-D4): I CONCEDE to Sol.** My quarantine-move
   *mutates the damaged source*; Sol's salvage-to-a-NEW-journal with the source left byte-
   untouched is strictly better evidence discipline — the same instinct (the move is an
   evidence-bearing act) with the mutation removed. The no-auto-truncation law is adopted
   verbatim.
3. **Segments (my FORK-5 vs Sol's single `EVENTS.pj0`): I CONCEDE for v0.** Rotation joins
   compaction/redaction in the deferred set, held by the one constitutional sentence (*no
   rewrite/delete under the same journal identity*).

## What the F-plan contributes to the draft (Sol wrote blind to these)

- **The crash-window table as the spec's organizing SPINE:** four specimen kill points × two
  durability modes, every cell = defined journal state + fold result + recovery behavior +
  condition + fixture. Sol's durability fixture family has the same *content*; the
  table-as-organizing-artifact is the stronger form. Proposed: the draft's §1 exhibit.
- **The randomized kill -9 harness** (child appending under load, killed at random offsets, N
  runs) as the live complement to Sol's deterministic death-point fixtures.
- **Kernel0 gap closure named explicitly:** PJ0 closes gap 5 (resolved-ness is fold-derived —
  no resolved flag in any record, stated as design) and gap 6 (bless
  `unsupported-reconstruction` for multi-unresolved occupancy in v0).
- **WSL/fsync honesty clause:** `:synced` on this host is declared-belief territory; tested
  where testable, *believed where the OS lies, and said so* (composes with Sol's own
  "storage controller having a spiritual crisis" honesty — same law, add the host-specific
  admission).

## What Sol's plan contributes beyond mine (adopted, gratefully)

**Append idempotency by event identity** — the journal-sized sibling of call-296, solving the
died-before-receipt seam; with `event-identity-collision` refusal (no last-write-wins). ·
**PJ-S/0 data-only grammar** (never normatively `READ`). · **Immutable `JOURNAL-META` +
LOCK-is-not-evidence.** · **The witness-standing fixture family.** · **Two independently
seeded implementations (CL + Python), neither calling the other** — the CD/0 differential
precedent, correctly revived ("two executables wearing one brain" as the anti-pattern's name).

## PJ-D1–D5: chair seconds all five recommendations

With the F-contributions folded in as additions, not objections. These five + the fold-ins go
to the owner as one compact decision note, per Sol's own "no fourteen-act opera" plea.

## Proposed process disposition (owner's call)

Plan-level blindness has already extracted the divergences; a second full-blind-draft round
would mostly re-derive Sol's superset (the K/0 round's lesson: 0 conflicts, S-superset,
F-pressure-points — and the pressure points are now *in this concordance*). **Recommend:
Sol authors the full PJ0 packet per its §17 deliverables**, under PJ-D1–D5 + these
dispositions; **Fable does the bounded semantic/scar review; a separately-charged
implementation-minded hostile reviewer attacks framing and crash consistency** (Sol's own
to-do asks for exactly this — an Opus or Codex hand, charged adversarially). Alternative
(the letter of the authorized pattern): full parallel-blind drafts as before. The chair
recommends the former; the owner disposes.

*— Claude Fable 5, with both plans open; parents preserved; the goddess's spine gets its
vertebrae from whichever hand cut them truest.*
