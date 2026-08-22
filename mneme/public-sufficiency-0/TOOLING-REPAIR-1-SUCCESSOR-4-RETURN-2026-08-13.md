# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-4 RETURN (2026-08-13)

**Terminal status:**

> **TR/1 SUCCESSOR-4 RETURNED — NOT OWNER-ACCEPTED ·
> NO TD CLOSED · MERGE GATE CLOSED · NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: successor-3 (`c0e14959`), BLOCKED by Sol's fourth cold seat
(SOL-TR1-07/08/09, verbatim:
`corpus/voices/received/2026-08-13-sol-tr1-fourth-block-filename-namespace.md`).
This successor answers the fourth BLOCK, plus the adversarial hand's own
first BLOCK (migration suffix-inference), plus two defects the builders'
new controls caught in-house before any seat saw them.

## The cures

**SOL-TR1-07 (identities disappearing from enumeration):** custody moved
to separate namespaces (`markers/` · `sidecars/` · `claims/`) with
**content-addressed basenames** (digest of the exact run-id; identity
stored INSIDE the file, never derived from the name). Dotfile
invisibility, suffix misclassification, and glob-over-user-data all die
by construction. Lookup compares parsed fields byte-exactly — user data
is never a regex pattern (`a.b` returns exactly one row; five grep sites
fixed, six audited clean, tabulated).

**SOL-TR1-08 (boundary-length collision unreconcilable):** two bounds
(200 admitted / 320 handled); the max-length collision identity (235
chars measured) reconciles on both base and derived identity.

**SOL-TR1-09 (partial cleanup false green):** discovery reaches a gap
from EITHER remnant; removal order documented as load-bearing (marker
first, so the interrupted state is the byte-verifiable one); both
partial states stay RED and recover idempotently with no duplicate.

**QUAESTOR's BLOCK (migration suffix-inference — SOL-TR1-07's class
reintroduced inside its own cure):** `migrate_legacy_custody()` now
classifies flat legacy files by CONTENT (schema fields), never by
basename; nothing `continue`s in silence — every file found is migrated
or refused loudly, counted, and named, with `found = migrated + refused`
printed and self-checked (a broken sum is exactly the signature a silent
skip leaves); marker↔sidecar pairing by inside-identity, refusing when a
legacy collision family makes the match non-unique. The plant
(`weird.record`) and its control (`weirdX`) are permanent teeth.

**Caught in-house by the builders' own controls (named because tonight's
rule is that residuals get shipped as repairs):** (1) a refused legacy
file was promised to "keep verification RED" and did not — `verify`
enumerated gaps only inside the new namespaces; flat remnants at the
evidence root are now gaps in both verify paths, making the sentence
true; (2) round-7's stale-claim and installer repairs (pid-carrying
claims — live pid blocks, dead pid named as abandonment and taken over;
"installed" earned by write-check + `cmp` read-back + exec-bit).

## Teeth

**411 / 0 — chair's own hand on the final tree**; progression
103 → 126 → 199 → 247 → 273 → 328 → 348 → 395 → 411 across nine builder
rounds, six adversarial rounds, four Sol cold seats. Every count above
was also run fresh twice by the builder and (through round 6's tree)
cold by the verifier.

## The ladder (all rungs now doctrine in code)

transport ≠ persistence · source ≠ run · name ≠ identity ·
admission ≠ observability · say ≠ did (cross-cutting; four instances
found and killed) — and the chair's pre-registered wager on the fifth
rung is committed BEFORE this parcel seals
(`TR1-FIFTH-RUNG-WAGER-2026-08-13.md`; git timestamp is the proof).

## Standings (unchanged — no premature closure)

TD-6 OPEN (Option A approved in principle only; sharpened invariant; no
live action; mirror re-confirmed unmoved) · TD-7 OPEN (repair candidate;
first real transport UNREACHED) · TD-8 OPEN (repair candidate;
delegators byte-unchanged since round 1, `--verify` GREEN, TR/0 gate
9/0) · TD-9 OPEN (**IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY
UNREACHED**; owner fork returned, unexecuted). Policy blob
`180734f6…c7054` untouched. Live custody exposure was and remains zero
(`.git/latent-lisp/` did not exist at any repair moment). All prior
voids stand, plus: legacy migration is proven on planted flat layouts
only — no real legacy custody has ever existed to migrate.

## The night's methodological residue, carried at full strength

Two builders' suites certified, at different rounds, defects their own
reports described; the verifier logged four near-convictions of correct
code by its own oracles; four of five oracle errors were caught only by
serial cold strangers — and the fifth (round 9's) by a control-beside-
the-plant run by a different hand than the code's author. The
oracle-problem is now the campaign's named open instrument-gap; the
fifth-rung wager and the true-stranger-seat proposal (apropos #36) are
the two live responses.

*— chair, 2026-08-13, the lamps low. Nine rounds of iron, six of doubt,
four cold seats, one wager on the table. The Book of the Guild carries
LICTOR, FERRARIUS, and QUAESTOR as of this ceremony.*
