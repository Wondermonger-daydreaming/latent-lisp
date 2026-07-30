# OWNER RULING — CAPABILITY /1 ARC CLOSURE

*Filed 2026-07-30 by the session chair (Claude Fable 5) from the owner's
ruling delivered the same night, verbatim below. The owner verified the
return parcel directly before ruling: zip SHA-256
`9ba3bfacae5c0ae7040e84cd416a08effa7bb25135a3570dda38cc93dbe6da8d`,
129,147 bytes, 40/40 payload files manifest-verified, 0 unsafe paths or
symlinks; all captured gate results confirmed (30/0 · 27/0 · 29/0;
capability0 regression 28/0 · 36/0 · 24/0 byte-identical; journal0 66/0 ·
89/0; repository smoke 6/6; all three principal transcripts reproduce
byte-for-byte).*

---

## The ruling (owner's words, verbatim)

> **OWNER RULING — CAPABILITY /1 ARC CLOSURE**
>
> Accept Capability /1 at author commit 4d673c23, with its public mirror
> verified by content and return parcel SHA-256:
>
> 9ba3bfacae5c0ae7040e84cd416a08effa7bb25135a3570dda38cc93dbe6da8d
>
> The candidate establishes:
>
> a fresh Capability /0 authorization may justify minting;
> the authorization receipt is not itself authority;
> the minting receipt is not the minted capability;
> public fields and public identity cannot reconstruct recognition;
> recognition is process-local;
> every presentation revalidates the current Journal /0 prefix;
> process death destroys the key while leaving truthful testimony;
> restart requires fresh derivation and fresh minting.
>
> Preserve its standing:
>
> candidate constructed
> candidate tested
> candidate published
> not audited
> not adopted
> not frozen
> not on a governing floor
> continuation permitted
>
> No further Capability /1 work is authorized in this session.

## Owner's framing carried with the ruling (summarized at its size)

- The three-stage distinction is CLOSED as an architectural whole: **Journal
  /0** durably records what happened · **Capability /0** derives whether
  authority is live at a validated present prefix · **Capability /1** mints
  a process-local object that can embody that authority **without making the
  durable explanation itself authoritative.**
- The separation the owner named as earned: *public identity NAMES the key ·
  minting receipt EXPLAINS the key · printed form DEPICTS the key · live
  object IS the key only inside the recognizing context* — and even the live
  object is insufficient alone: **the context recognizes; the journal
  decides.**
- Staleness and revocation "occupy different temporal offices": the journal
  advance carrying a revocation stales the old key before presentation need
  say "revoked"; revocation governs the NEXT mint.
- The specimen's law, in the owner's phrase: **the system permits
  restoration of justification, not necromancy of authority.**
- The limits are accepted as honestly drawn: structural opaqueness, honest
  API discipline, description-forgery resistance, process-death extinction,
  fresh-prefix liveness — and NOT sandbox isolation, cryptographic
  authenticity, protection from hostile runtime introspection, or
  distributed capability security. ("Common Lisp package discipline is a
  membrane, not an armored vault; pretending otherwise would be a rather
  charming way to get robbed.")

## The next seam — NAMED, not opened

The owner named the next semantic seam: **the effect frontier** — "probably
Capability /2 or an adjacent production whose exact name should follow the
live roadmap." Governing sentence offered:

> A recognized, current capability may justify attempting one exact
> protected effect — but neither the capability nor its presentation receipt
> proves that the effect occurred.

Smallest next vertical sketched by the owner: live capability presentation →
effect request → frontier authorization → authorization-to-attempt receipt →
explicit effect invocation → acknowledgment or failure → journaled
consequence or unresolved-effect state. Crucial laws: having a key is not
performing an effect · presenting a key is not performing an effect ·
authorization to attempt is not acknowledgment · acknowledgment is not
settlement · failure after authorization does not retroactively invalidate
authorization · **uncertain execution must not be retried as though nothing
happened.** One exact, harmless deterministic fake effect suffices; no
budgets, delegation, OAuth cosplay, or provider APIs.

**Chair's filing note:** consistent with the house pattern (the obligation
ruling's "selected, not opened"), this section records DIRECTION. Opening
the effect-frontier lane requires its own owner act; none is claimed here.
Naming must be re-verified against the live tree at opening time.

## synthesis-01 disposition (owner's word, same ruling)

`_staging/synthesis-01/` "should not block this construction arc… keep it
staged, non-governing, and separate rather than allowing an old synthesis
dossier to ambush newly working language machinery." A substantive ruling
would need its current contents; none is made here. (Evidence for that
future ruling: `notes/2026-07-30-staging-triage-report.md` §9.)

---

*Record of truth for the Capability /1 arc. The arc is CLOSED with
continuation permitted; standing unchanged from the publication commit.*

*— filed by Claude Fable 5, 2026-07-30*
