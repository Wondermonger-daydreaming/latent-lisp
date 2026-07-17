# PREREG v0.2 — Erratum 01 (price-table closure and deferral sufficiency)

This erratum is an external annotation. It does not edit `PREREG-v0.2.md`, whose bytes
are owner-frozen by digest under ruling R10 (`operator/owner-decisions/PREREG-R10-FROZEN-v1.json`):

    PREREG-v0.2.md sha256 5bc87c537d137ba5c1c0d4f8caaf8534dfb07cfbf226ebf98785017f2aacfc7f

The frozen bytes remain frozen. Where a frozen status line and a later sealed record
disagree, the owner-decision record chain controls; this note records that ordering, it
does not amend the pre-registration.

## 1. §73 "price tables remain unresolved" was true at freeze, superseded ~20 minutes later

PREREG §73 ("Subjects, cost, and census") reads, in the frozen body:

> Provider settings, returned ID behavior, caching/retention disclosures, token
> accounting, and price tables remain unresolved.

That sentence was **true at the moment of freeze** — PREREG v0.2 was frozen under ruling
R10 at event time `2026-07-17T12:58:39-03:00`, when the price rows were still
owner-supplied-pending. It was **superseded roughly twenty minutes later** by the owner
R6-closure ruling, sealed as
`operator/owner-decisions/SCORING-R6-CLOSED-v2.json`
(`record_digest sha256:eae4cd90a22041bc61ca07bc82bfb9f37d83e85663d396d4062cd397feeec6f5`,
event time `2026-07-17T13:20:30-03:00`), which:

- **pins all three price rows** — claude-haiku-4.5 at 1.00 / 5.00 USD per MTok (OpenRouter
  route), gpt-5.6-luna at 1.00 / 6.00 (OpenRouter route), kimi-k3 at 0.00 / 0.00 (Moonshot
  kimi.com coding-plan subscription route, $0.00 marginal); and
- **banks the offline byte census** — 527,916 scheduled prompt bytes over 312 calls, a
  global worst case of USD 2.246177 against the USD 8.00 spend ceiling (UNDER-CEILING,
  28.1 percent), census evidence
  `sha256:2931c0bdea501facd551c13917d569822c863feb65dbcab0c974f9953196dc4c`.

The machine-readable price-table slot in `operator/owner-slots.json` has been synced to
cite `owner-decision:scoring-r6-closed-v2` and carry the pinned rates. The frozen §73 body
line is left as-is by design; this erratum is the pointer that reconciles it.

## 2. Deferral-sufficiency ruling (owner gate-walk interview D, 2026-07-17)

The same §73 also lists **provider settings** and **token accounting** as unresolved. Per
SCORING-R6-CLOSED-v2 these are recorded as **owner-authorized deferrals to emission
actuals**: the exact per-provider tokenizer census closes at the provider usage fields at
emission time, disclosed as pending, not inferred from bytes; provider settings are
recorded as pending-exact-confirmation.

In the owner gate-walk interview of 2026-07-17 (deciding actor
`actor:tomas-pellissari-pavan-owner`; verbatim Q&A and operative effect in
`evidence/gate-walk/inputs/OWNER-GATE-WALK-RULING-2026-07-17.md`, sealed as
`operator/owner-decisions/GATE-WALK-R12-ADOPTED-v1.json`), the owner ruled that a **sealed,
disclosed deferral record satisfies** the freeze-checklist requirement to "record all …
settings, tokenizers" for the **pre-exposure gate** — consistent with the R6 census ruling.
The settings and per-provider tokenizer census therefore stand as recorded-as-deferred, not
as open owner slots, for the purpose of the pre-gate record requirement. The exact actuals
still close at emission.

## 3. What this erratum does not do

It authorizes no scoring event, no provider call, no key-content exposure, and no merge. It
does not sign the pre-exposure gate, which remains unsigned. It changes no margin, branch
definition, arm semantic, subject, or ceiling in the frozen pre-registration.

— FIXER (Claude Opus 4.8), governance-repair pass, 2026-07-17
