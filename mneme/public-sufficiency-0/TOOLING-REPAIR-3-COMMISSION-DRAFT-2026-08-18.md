# CHANNEL TOOLING REPAIR /3 — COMMISSION **DRAFT** (2026-08-18)

> ## CONVERSION AMENDMENT (owner act, 2026-08-18 ~22:0xZ — visible amendment per
> ## this document's own firing clause; the original status block below is
> ## PRESERVED for the record and SUPERSEDED by this amendment)
>
> **STATUS NOW: COMMISSIONED — EXECUTION DEFERRED TO THE NEXT FRESH SESSION.**
>
> The owner converted this draft by explicit written act (interview answer,
> recorded verbatim):
>
> > I convert the filed TR/3 draft into a commissioned lane now, per its own
> > terms. **Commission only; execution begins in the next fresh session.**
> > No implementation, repair acceptance, TD closure, sentinel change,
> > publication authorization, transport, credential use, or mirror contact
> > follows from this act. TR/3 does not delay TR/2 owner acceptance or the
> > separate TD-10/TD-11 closure acts, but it must return through its own cold
> > seat before `SYNC-PAUSED` is lifted or the first real transport relies on
> > `transport-record.sh`.
>
> Consequences, exactly as the act states — nothing more:
> - **This sitting spawns NO hands under TR/3.** The executing chair is the next
>   fresh session, which boots from this document (the caps and shape below are
>   now binding commission terms, not proposal).
> - **New sequencing gate, owner-worded:** TR/3 must return through its own cold
>   seat **before** `SYNC-PAUSED` is lifted or the first real transport relies on
>   `transport-record.sh`. This gate joins — it does not replace — the TD-10/
>   TD-11 blocks and the owner-gated lift itself.
> - TD-10/TD-11 closure acts proceed independently of TR/3's execution.
>
> *Conversion recorded by the chair, Claude Fable 5 (1M context), same day as
> drafting, later sitting.*

**STATUS: DRAFT ONLY — NOT COMMISSIONED. No agent has fired under this document and
none may until the owner converts it by an explicit act. Drafted at the owner's
ruling this sitting ("Commission draft only") so a future sitting can review and
fire it without reconstruction. Everything below is proposal, not authorization.**
*(↑ superseded by the Conversion Amendment above — preserved unedited.)*

## Subject

`tools/latent-lisp/transport-record.sh` — 117 KB (`753b9a0f…` at draft time), the
**sole writer of the channel's durable custody evidence**. Seven TR/2 rounds and
three cold seats taught every *caller* to speak truthfully (hooks refuse to classify
what they did not observe; `sync.sh` verifies the equality it used to infer) — and
every one of those cures terminates in `record_event` → `transport-record.sh append`.
**No hand, internal or cold, has ever read this file adversarially.** If the scribe
mis-records, every truthful caller above it writes into sand.

## The opening brief (QUAESTOR round 5 §12, the four filed questions, verbatim basis)

1. Does `append` fail loudly when the ref update loses a race, or can two concurrent
   transports drop an event?
2. Is the append genuinely append-only under a forced ref rewrite, and does anything
   detect a rewritten history?
3. Does `scrub_value`'s 400-char bound ever truncate a *tree id* or an exit code
   rather than prose?
4. **The one that rhymes with everything found so far: when a query inside
   `transport-record.sh` itself fails, does the record say so — or does it say
   something determinate it never observed?** (The SOL-TR2-01 class, asked of the
   scribe: the question this lane answered four times in four files and never in the
   file that writes the answers down.)

Suggested additions from the TR/2 arc's lessons (the drafting chair's, for the
owner's review — strike freely): (5) a WITHHELD record's integrity under a mid-write
crash (torn-write behavior of the ref chain); (6) whether the record's schema field
is verified by readers or trusted by convention; (7) the record ref's behavior if the
lab repository is repacked/gc'd while an append is in flight.

## Proposed shape (the TR/2 pattern, which three cold seats have now exercised)

- Builder (FERRARIUS pattern) and adversary (QUAESTOR pattern), alternating rounds;
  RED-proven teeth for every cure (a gate never seen to fail is untested, not
  passing); append-only report discipline; named voids each round.
- **Caps (carried from TR/2 verbatim where applicable):** no live merge · no
  sentinel change (fingerprint start/end, sha AND mtime) · no mirror contact · no
  TD-6/TD-9 action · builders commit nothing · accepted `teeth-td6-td9.sh`
  byte-untouched, re-run 680/0 · hooks + `sync.sh` byte-untouched (they are the
  ACCEPTED repair now — TR/3 may not modify TR/2's accepted subject without a
  scope extension) · candidate standing only · cold seat before any acceptance ·
  TD-10/TD-11 standing unaffected.
- **Binding language caps inherited:** the TR/2 acceptance riders travel (no
  unconditioned "deterministic"; the tooth-inference distinction) — and any TR/3
  teeth that reproduce timing behavior inherit the host-condition discipline
  (preflight diagnosis, loud FAIL, no SKIP conversion of a timing miss).
- Teeth live in a new `teeth-record.sh` (never grafted into `teeth-td10.sh`, whose
  count series is a TR/2 artifact under the acceptance's language cap).

## What firing this draft requires

An explicit owner act naming this document and converting DRAFT → COMMISSION
(interview or written word), at which point the chair updates the status line above
by visible amendment — never by silent rewrite — and only then spawns hands.

*— drafted by the chair, Claude Fable 5 (1M context), 2026-08-18, same sitting as
the TR/2 acceptance; unfired by design.*
