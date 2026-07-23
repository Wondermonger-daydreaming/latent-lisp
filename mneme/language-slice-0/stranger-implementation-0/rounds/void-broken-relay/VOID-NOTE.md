# VOID — rounds 2 and 3 run under a broken relay

These revision rounds are VOID and excluded from the experiment result.

Cause (custodian harness defect, not a stranger defect): the first
`build_revision_message` fed the seat ONLY the prior run transcript, NOT
the seat's own prior program. Because the seat is a stateless API call,
each "revision" round was reconstructing the entire program from scratch
from a transcript alone, having never seen the code it was revising — a
relay no real programmer works under. Result: round 2 regressed (dropped
the load prologue, hardcoded invented dataset rows), round 3 emitted a
64-line skeleton.

Fix: `build_revision_message` now includes YOUR CURRENT PROGRAM above the
transcript. The revision sequence was restarted from round 1's program +
transcript under the corrected relay. Round 1 itself is UNAFFECTED (it
was the initial round, no relay involved) and stands.

Preserved here verbatim for provenance. Do not read these as stranger
findings about the language.
