# Score-key custody receipt — unresolved

No score key exists in this construction packet. `scoring/private-score-key.json` is a forbidden runner path and is intentionally absent.

The owner-controlled key author must later create one immutable byte copy outside the runner tree, record its length and SHA-256, and append every delivery/read. It may be mounted into a separate scoring worktree only after raw-response and scoring-code digests are locked. Target subjects, the primary runner, P2a, and unauthorized graders may never receive it.

This is procedural custody and hash-based change detection, not cryptographic proof of secrecy, authorship, or absence of side channels.
