# SURFACE ACCOUNT /0 — OWNER RULING: RETURN R3.3.1, TWO NARROWLY BOUNDED SEAMS (R3.3.2)

*Received 2026-08-05 from the lab owner (Tomás P. Pavan), filed verbatim by the chair
(Claude Fable 5) — sandbox artifact path and external link preserved as received. This
document is the governing law of the R3.3.2 round.*

---

The electronic hall monitor ate the judgment again—but not the investigation.
The parcel, reconstructed candidate, exact SBCL runtime, and all review
evidence survived. OpenAI documents that GPT‑5.6's real-time classifiers can
occasionally block legitimate dual-use work during generation; this screenshot
fits that behavior exactly. [Official safeguards documentation](https://developers.openai.com/api/docs/guides/latest-model#safeguards)

## Owner ruling — RETURN R3.3.1, two narrowly bounded seams

| Seam | Ruling |
|---|---|
| Archive, manifest, bundle, confinement | **PASS** |
| R3.3 delayed-writer and recursive-load repairs | **PASS — LOCKED** |
| Post-election/pre-note failure closure | **PASS — LOCKED** |
| Unrelated plist preservation and contention | **PASS — LOCKED** |
| Status and `VOLATILE` evidence hygiene | **PASS — LOCKED** |
| State-publication finalization | **RETURN** |
| Reserved-indicator validity | **RETURN** |
| Production, adoption, Surface `/3` | **NOT AUTHORIZED** |

Custody remains excellent:

* SHA-256 `fa8ab9273dd56d26ac86218d75758dc5d07c37d2e074b674c34c58344505ec7e`
* 434,619 bytes
* 122 regular files + 11 directories = 133 members
* 121/121 non-self manifest rows matched
* sole prerequisite `4ef6c232fd2d89d7cbd3779944775b8b024afc2c`
* three-commit, ten-path confined delta
* parcel tip `fd27d5a3eefc4624bbb099face9ce1e91c92ca18`
* all ten profiles independently pass under exact SBCL 2.4.6
* all eleven raw porcelain captures are genuinely zero bytes
* public `main` remains `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`; no public `surface-account-0*` branch exists

### Finding 1 — publication succeeds before the bookkeeping flag knows it

In the candidate identity source
(`probes/probe-identity.lisp`), the complete state is published by CAS,
followed by a separate:

```lisp
(setf published t)
```

Cleanup decides whether initialization failed using that local `published`
flag, not the actual state slot. A condition pinned between those two
operations deterministically yields:

```text
load-outcome ERRORED
state-present YES
failure-present YES
ready-p T
retry-outcome OBSERVED
reader-outcome STATE-RETURNED
epoch-gatherings 1
election-count 1
```

Thus the cell simultaneously says:

* a complete identity state was published;
* initialization failed before publication.

The later readers choose success only because the state branch precedes the
failure branch. The repair moved protection before election correctly, but
left publication and knowledge-of-publication as two separate events. The
state machine has grown a forked tongue.

### Finding 2 — `GETF` confuses a NIL value with key absence

`SA0-INSTALL-CARRIER` claims to test whether the reserved indicator is
present, but uses:

```lisp
(getf observed 'sa0-identity-cell)
```

With the default `NIL`, that cannot distinguish:

```lisp
;; indicator absent
()

;; indicator present with invalid NIL value
(sa0-identity-cell nil)
```

Against the unmodified candidate, a pre-existing reserved NIL entry produces:

```text
load-outcome COMPLETED
reserved-count 2
first-reserved-value-is-cell YES
old-plist-is-tail YES
ready-p T
```

A second reserved indicator is silently prepended. This directly falsifies the
source's written claim that the reserved indicator makes exactly one
absent-to-present transition. The unrelated-property repair itself is sound;
this defect concerns collision in the mechanism's own reserved slot.

## Proper successor

Commission a tiny **R3.3.2 publication-finality and carrier-slot closure**
from exact tip:

```text
fd27d5a3eefc4624bbb099face9ce1e91c92ca18
```

It should:

* Derive cleanup disposition from the actual state publication slot, not
  merely the lagging local flag.
* Pin a condition immediately after successful state CAS and require: state
  present, failure absent, parked observer awakened successfully, retry
  observed, one election, one gathering.
* Detect reserved-indicator presence independently of its value.
* Accept exactly one lawful installed cell; reject NIL, duplicate, and
  malformed reserved entries immediately.
* Continue preserving genuinely unrelated properties by identity.
* Freeze every existing accepted profile and repair; R4 remains reserved for
  production/adoption.

So yes: another return, maddeningly. But R3.3.1's commissioned repairs are
real and locked. What remains is no longer "concurrency in general"; it is
exactly one stale local flag and one presence/value ambiguity—the sort of
pair that can be removed without summoning another architectural dynasty.
