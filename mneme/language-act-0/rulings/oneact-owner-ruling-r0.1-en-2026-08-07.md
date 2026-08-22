# ONE ACT /0 — OWNER RULING R0.1 (English, terminal, 2026-08-07 ~21:0x −03)

*Received directly from the owner in-session (a direct owner instrument, [R] tier —
this is the expected "revised English R0.1", now carrying full owner authority: it
adopts, with modifications, what the Spanish Sol relay proposed, and settles every
open fork. Chair reception note follows the verbatim text.*

---

## Verbatim ruling

# OWNER RULING — ONE ACT `/0` R0.1

ADVOCATUS-III's blocking finding is sustained. The implementation plan may not silently execute an owner-reserved fork.

The owner decisions are now complete.

## 1. Act identity: DERIVED

Choose **derived**, not token.

`act-id` shall be minted exactly once, before F1, as a deterministic CD/0 identifier derived from:

* a domain-separation string for One Act `/0`, version 0;
* the exact CD/0 `seat-id`;
* the canonical request octets already used by the request-digest machinery.

Construct a CD/0 ordered preimage containing those three values, hash its canonical octets with SHA-256, and render the result as a segmented CD/0 identifier using the fixed lane stem plus the complete lowercase hexadecimal digest.

Do not concatenate ambiguous strings. Do not use a caller-provided token, private ordinal, random nonce, mutable counter, host identity, or adapter identity.

Required laws:

* identical seat and canonical request produce byte-identical `act-id`;
* changing either input changes the derived identifier;
* the identifier is recomputable by a cold reader;
* the same `act-id` is carried unchanged through F1–F5;
* an `act-id` already present in the validated prefix is refused before F1;
* every frame constructor receives the identity from one immutable act record;
* branching and collapse mutants must turn named checks red.

Delete the token branch from the normative plan. An `act-token` may survive only as a fixture label with no semantic, identity, or uniqueness role.

ADVOCATUS-III's tripwire finding is therefore resolved by owner decision, not merely by adding a permanent "fork still open" warning.

Correct the frozen vector count from **52 to 63** everywhere it appears.

## 2. Core `/0` D2: GRANTED, LANE-LOCAL

The operative ruling is:

> The Core `/0` fixture capability model is re-adjudicated, per Core `/0` owner-disposition D2, as test infrastructure retained for One Act `/0` under a lane-local dual-office binding, Office L, minted only by this lane's `bind-offices` step. This ruling does not name a canonical authority and does not accept labelled dual authority in the `R4-SURVIVAL-PLAN` §8 sense; it re-adjudicates a closed lane's test fixture for one lane. It does not open, advance, partially discharge, or supply evidence toward Surface `/3`.

This is re-adjudication of test infrastructure, not adoption as production authority.

## 3. M-13a and ACT-4

Adopt M-13a and M-13b.

For the closed character sets:

* `:cell` must be nonempty, contain only printable ASCII U+0021–U+007E, contain no space, and remain exactly `STRING=` to the rendered Capability `/0` resource term.
* `:text` may contain printable ASCII U+0021–U+007E and internal U+0020 SPACE.
* U+0020 is forbidden at the beginning or end of `:text`.
* Empty strings, newline, carriage return, tab, DEL, other control characters, and non-ASCII code points are refused pre-frontier.
* Repeated internal spaces need not be prohibited.

The ACT-4 `[a-z0-9-]` rule is **not adopted as a public act-token grammar**, because no act token now exists. It may remain only as a rendering law for fixed lane-owned textual segments. The digest segment itself must be exactly 64 lowercase hexadecimal characters.

Keep H-INJECT and the world-ledger-count invariant as permanent teeth.

## 4. Production name and conditional opening

The production name is minted as:

```text
One Act /0
```

The technical namespace is:

```text
directory:  mneme/language-act-0/
ASDF:       lisp-plus/act0
package:    LISP-PLUS-LANGUAGE-ACT0
stem:       oneact0
```

`de uno actu` may remain the specimen subtitle; it is not a second production name.

Re-run the full N-4/N-6 name-freeness census against the live tree, including spaced, hyphenated, package, system, adapter, event-kind, seat, attempt, cell, and `ap0-event` families. Classify every hit. A material collision halts with a named defect.

This ruling conditionally opens implementation, but its effect is delayed until the pre-code seal closes. Before any production Lisp is written:

1. Repair all five candidate documents and the implementation plan.
2. Verify each ADVOCATUS-III finding against the actual draft; apply every sustained repair and record rejected findings with evidence.
3. Replace all open forks and `MUST RESOLVE` entries with explicit laws or explicit owner dispositions.
4. Preserve a closure ledger for MR-1…MR-11 rather than erasing their history.
5. Freeze V-F1…V-F5 and all **63** canonical vectors.
6. Commit and SHA-256 seal the repaired pre-code corpus.
7. Emit a mechanically checked pre-code closure verdict with zero unresolved blocking or material items.

Only after those conditions are green may implementation begin without another owner round-trip. If any condition fails, stop before code.

## 5. Remaining owner docket

The remaining candidate choices are ruled as follows:

* OR-2: jurisdictional divergence is accepted as a candidate result. Neither layer's standing is promoted into the other.
* OR-3: F2's post-frontier position is accepted; Core `/0` makes pre-frontier language-attempt identity unavailable.
* OR-4: the Class D arm remains mandatory.
* OR-6: cite no Surface Account parcel digest in this lane's provenance block. Correct the historical mislabel only where it is discussed.
* OR-7: the Office L refusal-durability asymmetry is accepted strictly as a one-process-life `/0` ceiling and must be published as such.
* OR-8: Surface `/2`'s attempt-name coupling is accepted for this lane only and creates no general precedent.

An Office L refusal reached during `perform` leaves the lawful F1/F2/F5 account but no Capability `/2` frame or world effect. Only a refusal before the act opens leaves the journal untouched.

Use one immutable per-act dispatch context and bind the exact adapter object by `EQ`. No global current-act registry and no name-only adapter substitution are permitted.

## 6. Staging housekeeping

Housekeeping is not part of One Act `/0`.

Do not execute the 17-file promotion list, the `surface11/` label operation, or the eleven deletion candidates in this round. Preserve them in staging. Deletion is specifically unauthorized.

Return the exact proposed paths, hashes, destinations, collision analysis, and recoverability status in a separate housekeeping disposition after the One Act pre-code seal. No staging movement may contaminate the lane's changed-path ledger.

## Terminal authority

```text
OWNER DISPOSITION:
R0.1 DOCUMENTARY REPAIR AUTHORIZED.
ONE ACT /0 NAME MINTED.
D2 RE-ADJUDICATION GRANTED.
IMPLEMENTATION CONDITIONALLY OPENED AFTER A GREEN PRE-CODE SEAL.
SURFACE /3 REMAINS SHUT.
```

Proceed autonomously through documentary repair, seal verification, and—only after that seal is green—the confined implementation round. Do not return with another menu of choices already decided above.

---

## Chair reception note (Claude Fable 5, 2026-08-07 21:0x −03)

**Standing:** direct owner instrument, [R] tier — supersedes both 08-07 parallel
rulings wherever they conflict. Every open fork is now closed by owner word:

1. **act-id fork → DERIVED** (reverses English R1 Repair A's token basis; adopts
   the Spanish/Sol branch with a full derivation spec). §2A must be rewritten;
   `act-token` demoted to fixture label with no semantic/identity/uniqueness role.
   Note: the ruling's duplicate-refusal law ("already present in the validated
   prefix is refused before F1") preserves the anti-collision guard that
   motivated the token branch — retries over an unchanged seat+request are now
   *structurally* refused rather than distinguished.
2. **D2 → GRANTED by owner** (no longer PROPOSED-BY-SOL; operative text verbatim
   above; lane-local; Surface /3 shut).
3. **M-13a-3a (U+0020) → settled** (internal spaces lawful in :text, forbidden
   leading/trailing; :cell space-free; controls/non-ASCII refused pre-frontier).
4. **ACT-4 alphabet → demoted** to rendering law for fixed lane-owned segments;
   digest segment exactly 64 lowercase hex.
5. **Name → MINTED**: production "One Act /0"; namespace mneme/language-act-0/ ·
   lisp-plus/act0 · LISP-PLUS-LANGUAGE-ACT0 · stem oneact0. Census N-4/N-6
   re-run required against the live tree before the seal.
6. **Implementation → CONDITIONALLY OPEN** behind the seven-condition pre-code
   seal (§4). No further owner round-trip needed if the seal is green.
7. **Staging housekeeping → severed from this lane**; deletion specifically
   unauthorized; disposition report owed after the seal.

**Interpretation notes (chair):**
- "§8 / `surface11/`" in the housekeeping section read as the survey's §8 chair-
  decisions block and the `surface1-*`/`synthesis-01` label operations —
  all held, nothing executed.
- ADVOCATUS-III's BLOCKING finding is sustained *and resolved by decision*: the
  repaired plan implements DERIVED and deletes the token branch, rather than
  carrying a fork warning.
- The vector corpus must be re-derived where act-id enters any preimage/frame:
  the 52→63 correction is textual, but DERIVED act-ids change frame octets —
  V-F1..V-F5 and the 63 vectors are re-frozen from the repaired laws, not
  carried forward.

**Round name: R2 (documentary repair under R0.1).** Crew and ledgers use the
`oneact-r2-*` staging prefix.
