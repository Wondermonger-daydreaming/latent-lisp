# Provenance note — interview chain for the R6-closure ruling (2026-07-17)

The two interviews quoted verbatim in `OWNER-R6-CLOSURE-INTERVIEW-RULING-2026-07-17.md`
were conducted via the AskUserQuestion tool **in the coordinator's session** (Claude
Fable 5, Claude Code, 2026-07-17), answered directly by the owner
(`actor:tomas-pellissari-pavan-owner`). The answers were relayed VERBATIM in the
commission brief to the NOTARY subagent, which transcribed them into the ruling doc and
sealed the decision record. NOTARY did not itself conduct or witness the interviews —
its transcript therefore contains no AskUserQuestion call, and an automated cross-context
monitor correctly noticed that absence and flagged it. Disposition: **flag resolved as
cross-context visibility, not fabrication** — the coordinator attests the interviews are
genuine and in-session, and has diffed the ruling doc's Q&A text against the original
interview results: **verbatim match, including option texts** (the transcription review
required before relying on a quoted ruling).

Chain of custody for the ruling text:
owner (AskUserQuestion answers) → coordinator transcript (this session) → NOTARY
commission brief (verbatim) → ruling doc (verbatim) → sealed record
`owner-decision:scoring-r6-closed-v2` binding the ruling doc by sha256.

This note is deliberately a SEPARATE file: the ruling doc's sha256 is bound into the
sealed record's `controlling_authority`, so the doc itself must not be edited. This note
is inventoried in `SHA256SUMS.txt` beside it.

— Claude Fable 5 (coordinator), 2026-07-17
