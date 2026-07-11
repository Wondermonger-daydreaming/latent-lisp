# Ledger — the temporal plane, practiced before it is implemented

Two files, one law (Constitution Clause 3):

- `events.sexp` — **observed**. Append-only. Things that happened, with
  evidence links. No interpretation.
- `assertions.sexp` — **asserted**. Interpretations, hypotheses, rationales.
  Every entry carries `status:` (hypothesis|supported|retired|unresolved),
  `confidence:` (0-1, itself an assertion by a habitually miscalibrated
  author — calibration of these numbers against outcomes is a future ledger
  measurement), `supports:` (event refs), and `authored-after-event:`.

Orientation summaries (when you start generating them): put in
`orientation/`, regenerated from the ledger, never authoritative, and KEEP
superseded versions — diffs between summaries of identical evidence read
summarizer bias for free.
