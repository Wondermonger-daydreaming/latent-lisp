# SPECIMEN-RETURN — de-effectu-incerto

Specimen of the **Capability /2** candidate lane. Builder: CLAVIGER-III
(Claude Fable 5 subagent), 2026-07-30. Status: candidate; same-family
greens only. Substrate statuses: capability1 / capability0 / journal0
are themselves candidates (journal0's PJ0 §32.5 FULL not claimed);
Kernel /0 is an adopted **specification** whose partner implementation
here is smoke-checked only — consuming it imports no conformance;
details in the lane README. Check numbers below are `RUN-SPECIMEN.txt`'s
(29/0; two runs byte-identical — `RUN-EXITCODES.txt`).

> A recognized, current capability may justify attempting one exact
> protected effect — but neither the capability nor its presentation
> receipt proves that the effect occurred.

## What this specimen demonstrates

**1. The one exact protected effect, lawfully reached** [001]–[004]:
the prima vita derives its store identity from declared configuration,
commits the grant, mints the opaque key (zero effects — law 1), and is
authorized to attempt `cella:septima := "VII"` under attempt `a-001` —
the receipt preserved to disk while nothing anywhere is acknowledged
(law 2).

**2. Death in the acknowledgment window, seen to fire** [005]: exit 7,
no RESULT sentinel, the adapter's dying note in the relayed transcript.
Board interruption point 2; the AP0 W1 situation. Planted deterministic
env-var exit — no SIGKILL claim (README).

**3. The asymmetry, in bytes** [006]–[008]: the journal ends at
`attempt:frontier-crossed` (3 frames, :valid, no tail — the process
died before it could account for its own effect); the world holds
`cella:septima = VII` and exactly one applied ledger entry under the
journaled external-request identity; the authorization receipt survives
as canonical testimony.

**4. An unfinished restart never reads as clean** [009]–[012]: the
truncated-control child (planted fault, exit 3, no sentinel) is
detected as exactly that pair, and it wrote nothing — journal and world
byte-identical afterward.

**5. The crown law, from durable bytes alone** [013]–[020]: the
rediviva — a genuinely new process — derives `:crossed-unsettled`
(which is its own state, not refusal, not failure — law 4); a fresh
key MINTS (authority is derivable; the grant stands) [015]; yet
authorization of a new attempt into the seat refuses `unsafe-retry`
with the world not yet consulted [016]; the dead identity refuses
`duplicate-attempt-identity` before any frontier [017]; inline
reconciliation refuses `unstructured-uncertainty` [018]; the §10.8
record is structured from journaled facts through kernel /0's own
constructor and journaled in the fixture grammar [019]; and the seat
stays closed — now carried by the record itself, rehydrated into
kernel /0's own fold, refusing even a key re-minted at the
post-declaration prefix (authority is cheap to re-derive; dispatch is
what the record forbids) [020].

**6. Resolution only by evidence** [021]–[023]: reconciliation carries
the journaled external-request identity to the surviving world's
ledger; the entry is there; resolution `:applied`, with the
counterfactual standing in bytes — the cell already holds VII and the
ledger exactly ONE entry: a blind retry would have appended a second
application. Only then is the seat free (kernel /0's own resolution
predicate over the rehydrated §14.2 receipt), and a fresh authorization
succeeds without touching the world. A second reconciliation returns
`:already-reconciled`, journaling nothing.

**7. Testimony outlives failure** [024], [028]: the dead life's
authorization receipt is byte-identical across everything and still
truthfully names the licensed effect and the exact prefix it was
derived at — stale for reuse, true forever (law 6).

**8. The restart wrote exactly what it learned and nothing else**
[026]–[027], [029]: the world is sha-identical across the entire
restart (reconciliation reads; it never writes the outside — the cell
was set exactly once, by the dead process); the journal grew by exactly
`effect:uncertain` + `attempt:reconciled`, the death-state bytes a
verbatim prefix of the final journal (nothing rewritten — §14.2); the
four principal artifacts are re-read and byte-compared by [029], and
the digests of all seven are carried by `ARTIFACT-SHA256SUMS.txt`
(re-checkable: `sha256sum -c`); the plain-language manifest accounts
for six — the journal-metadata pair is in the sums file only.

## What this specimen does NOT claim

No real crash-window truncation (planted early exit only; the surviving
state — not the death mechanics — carries the claims). No SIGKILL. Only
board interruption point 2; points 1/3/4 untouched. Branch (b) of
reconciliation (request never landed) is exercised in the lane's
controls, not here — this specimen's death deterministically lands the
dispatch. Not Vertical Specimen /0. No AP0 conformance. Durability
declared, not proven. Same-family checks throughout; no stranger audit.

## Files

`specimen-common.lisp` (declared configuration and charge — all three
processes' only shared ground) · `stage-first-life.lisp` ·
`stage-restart.lisp` · `run-specimen.lisp` · `RUN-SPECIMEN.txt` +
`-SECOND` · `RUN-EXITCODES.txt` · `ARTIFACT-EVENTS-POST-DEATH.pj0` ·
`ARTIFACT-EVENTS-FINAL.pj0` · `ARTIFACT-JOURNAL-META.pjs` (+ sidecar) ·
`ARTIFACT-WORLD-CELLS.txt` · `ARTIFACT-WORLD-LEDGER.txt` ·
`ARTIFACT-AUTH-ATTEMPT-RECEIPT.pjs` · `ARTIFACT-SHA256SUMS.txt` ·
`ARTIFACT-MANIFEST.txt`.

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
