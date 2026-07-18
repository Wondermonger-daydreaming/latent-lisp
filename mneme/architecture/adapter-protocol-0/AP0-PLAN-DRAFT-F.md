# Adapter Protocol /0 — Plan, Draft F

*Claude Fable 5 — the chair's blind position paper for the AP0 divergence round.*

**Blinding banner (machinery, not promise).** This file lives in
`experiments/latent-lisp/_staging/`, which `tools/latent-lisp/sync.sh` excludes from the public
mirror (`--exclude '_staging/'`) and which is gitignored (this file enters lab git by
`git add -f`). The lab commit timestamp is the ordering proof; the sha256 of this file is
published to the public chamber at freeze time
(`mneme/architecture/adapter-protocol-0/AP0-DRAFT-F-COMMITMENT.sha256`); the plaintext is
revealed only after Sol's AP0 draft lands. The two plans are mutually blind, provably — the
PJ0 mechanism, reused (precedent commits `9d100109` → `6745971b`). Frozen 2026-07-18T23:28Z
(clock read, not recalled).

**Inputs (all shared-root, public, legal):** kernel spec §A.2 + §8.1 and authorial gap 4 (the
named seeds), Architecture 0.1 (L15–L18, D7), PJ0 as adopted (`f44436f5`, R-PJ-1..3, §0.3, §36),
kernel0 as built (`664a0a67`), the CONCORDAT audit, Sol's archived acceptance terms
(screenshot-transcript strength: `corpus/voices/received/2026-07-18-sol-ap0-readiness-…`).
Convergences with Sol's draft will measure this shared root; only divergences and concessions
carry information.

---

## 1. What the adapter layer IS (the plan's center of gravity)

**The adapter is the machine's epistemic membrane.** Everything the architecture has built so
far — manifestation identity, determinacy, uncertain effects, the journal-as-witness — governs
a lawful interior. AP0 is where that interior touches the one thing it cannot legislate: an
exterior that answers in bytes it did not witness being made. So the layer's whole design
follows from two sentences:

1. **Everything inbound is testimony until captured.** A provider's response — including its
   self-description (`model`, `usage`, `finish_reason`) — is an external principal's assertion,
   not an observation (L15). The adapter's first duty is to make the assertion *evidence*:
   capture it byte-exactly, journal it, and only then interpret it.
2. **Everything outbound is exposure.** Sending a prompt to a provider is a `:secret-open`-shaped
   event: an external principal *now knows* (L16). Blindness is spent at the membrane, and the
   spend must be recorded like any other consequential effect.

Everything below is these two sentences applied.

## 2. The spine: CAPTURE, then PROJECT — two acts, separately journaled

**CAP (capture law).** For every provider exchange, the adapter MUST journal the raw envelope —
request octets out, response octets in — in binary mode (R-PJ-2's discipline extended to the
membrane), *before* any interpretation. The capture record binds: adapter identity,
source-boundary, transport metadata that is locally observable (bytes counted, wall-clock,
connection outcome), and payload identity. Capture is the moment testimony becomes evidence.

**PRJ (projection law).** Projection — envelope → kernel manifestation record(s) — is a
**deterministic, versioned, pure function** of captured octets. Projection identity = the
§A.2 `parser-id`. Same octets + same projection version ⇒ same records, replayable forever.
Invalidity (`:present-invalid`) may only be asserted with parser identity bound (§8.1, already
enforced in kernel0 `manifestation.lisp`). A projection that discards information MUST say so
structurally (the raw payload remains the evidence; the projection is the reading).

Why two acts: a crash between them (window W3, §5) must leave the envelope as evidence with
projection simply absent — never a half-projected record with no raw backing. And a projection
bug discovered later is repairable by re-projection *from journaled evidence*, which is an
ordinary derived act (R-PJ-1's `:derived` origin), not a re-call of the provider.

## 3. The forks, with the chair's leans

**F1 — Where does gap 4 close?** §8.1 requires manifestation to bind adapter-or-producer
identity and stream sequence/chunk; §A.2's sketch lacks both; kernel0 built the sketch.
*Lean:* the **kernel erratum adds the two fields to §A.2** (it's a kernel data-shape truth, and
gaps 1–3 need the same two-chair sitting anyway), while **AP0 owns the value spaces**:
what an adapter-identity IS (name + version + config-digest, §8 below) and what a chunk
relation IS (§6). AP0 defining fields the kernel doesn't carry would fork the schema;
the kernel carrying fields AP0 doesn't define would leave them decorative.

**F2 — Is the provider a principal?** *Lean: YES, fully.* L18 says principals and event roles,
not operator/machine species — an external provider is a principal occupying the *receiving*
role of an exposure event and the *asserting* role of a testimony event. The epistemic ledger
(who now knows) must include providers, or the ledger lies precisely at the boundary where
leakage is real. The deterministic fake occupies the same role-slots with a declared
`:source-boundary :fake` — no special-cased epistemics.

**F3 — One contract or two?** Architecture 0.1 §22 charges AP0 with "fake and external adapter
contracts." *Lean: ONE contract, two realizations.* The fake adapter is a full citizen
implementing the identical AP0 surface, distinguished only by declared boundary class and a
seeded deterministic provider function. If the fake had its own contract, specimen results
would certify the fake's contract, not the adapter layer — the transfer of assurance from
specimen to live machinery is exactly what a single contract buys.

**F4 — Raw capture: full octets or digest-only?** *Lean: full octets for /0.* Digest-only
capture makes re-projection impossible and turns every projection dispute into an
unfalsifiable claim. /0 has no rotation (PJ-FS-1) and no retention policy (§0.3) — size
worries are a successor's problem and must not buy an evidence hole now. A truncated capture,
if it ever occurs, is `:present-partial` with the truncation declared — never silently digested.

**F5 — Provider-reported usage/cost: what standing?** *Lean: testimony with a declared billing
basis, dual-recorded.* Bytes sent/received and wall-clock are locally observable → capture
metadata with observational standing. Token counts, model-id echo, finish_reason → provider
assertions, recorded with origin `:provider-asserted`, never promoted. Billing MAY declare
provider-asserted numbers as its basis (that's an economic choice), but a conformance claim or
experiment result may not rest on them. The little lies stay legible as lies-or-truths we
cannot check — which is the honest state.

**F6 — Retry law.** *Lean: the uncertain-write doctrine becomes machine law at this layer.*
A consequential send whose outcome is unresolved (window W1/W2) may NEVER be automatically
re-fired. A retry is a **new attempt** that must reference the unresolved uncertain-effect of
the old one and carry a journaled decision record (who decided, on what basis). Reads under a
declared idempotency class may re-attempt; the class is part of the adapter contract, per
operation, never assumed. (House precedent: call-296, which already constructs lawfully in
kernel0 — the doctrine has a lived body.)

**F7 — When does alias→model resolution happen?** *Lean: resolution is its own journaled
epistemic act, before send; the attempt binds the resolved config digest, not the alias.*
Aliases drift under running systems (this lab has watched `kimi-k2.7→k3`, `gpt-5.5→5.6-sol`,
and Codex's own no-pinned-alias doctrine). An attempt that binds only an alias binds a moving
target — irreproducible by construction. A default applied is a recorded default; silent
defaulting is nonconforming.

## 4. The absence-mapping table (null semantics are contract, not convention)

Every adapter contract MUST carry a **normative, exhaustive absence-mapping table**: every
provider absence-shape (JSON `null`, missing key, empty string, empty array, whatever the
envelope grammar permits) maps to exactly one kernel status (`:absent`, `:present-empty`,
`:present-invalid`, …), explicitly. Distinct provider shapes may not be collapsed without the
collapse being declared in the table. An envelope shape not covered by the table is
`:present-invalid` with parser identity — not an improvised judgment call at 5 a.m. (L17).
*(House ancestor: the Language-A null-semantics arc — 76/96 nulls and a mandatory sealed ruling
on what a null MEANS before anything downstream may proceed. AP0 moves that ruling from
after-the-fact jurisprudence into the contract itself.)*

## 5. The crash-window spine (what the four-death specimen will aim at)

The adapter's characteristic windows, each of which MUST leave a lawful, fold-reconstructable
journal state (no stored resolved-flags — PJ0 §16):

- **W1 — after send, before any response.** The canonical uncertain effect: the exterior may
  have received, acted, billed. Post-crash verdict must be unresolved-uncertain; resolution
  only by evidence (a later capture, an external statement journaled as testimony) or by
  explicit adjudication. No auto-refire (F6).
- **W2 — mid-stream.** Chunks 1..k captured, stream dead. Verdict: `:present-partial` with the
  chunk chain as evidence and the settlement absent. The partials are already consequential
  (D7: they can be read, leak, and bill) — their exposure records survive the crash.
- **W3 — captured, not yet projected.** Evidence present, reading absent. Recovery re-projects
  from journal; the provider is not re-contacted.
- **W4 — projected, not yet consumed downstream.** Ordinary journal recovery; nothing
  adapter-specific — stated so the specimen can distinguish it from W3.

AP0 should enumerate these windows normatively and the packet's vectors should kill in each
(deterministic + randomized, the PJ0/forced-kill pattern).

## 6. Streams and chunks (repairing the D7 PARTIAL on the way through)

The CONCORDAT found the "chunk/checkpoint batching is a lawful adapter strategy; semantics are
the architecture's, batching is the adapter's" clause adopted-but-unstated in 0.1. AP0 is the
natural statute for it: chunk boundaries are the adapter's choice; each chunk is an identified
provisional manifestation bound into a sequence relation (the gap-4 field, F1); settlement is
an explicit terminal relation, not an inference from silence; per-chunk exposure records (L16)
because partials leak. Durability = journal durability: chunks are captured as they arrive,
append-only; an adapter's internal buffer is testimony, never witness (L15).

## 7. The single lawful door (L17 at the membrane)

The adapter surface exports **one entry point per consequential operation**, and that entry
point performs capture + journal + projection as one lawful route. There is no exported
raw-call; the bypass is *unsupported*, not discouraged. L17's test applies literally: if
calling a provider lawfully takes more steps than calling it unlawfully, the layer has failed
conformance — at 5 a.m., syntax becomes governance.

## 8. Adapter identity and the refusal vocabulary

**Identity.** An adapter-identity binds: contract name, contract version, implementation
identity, and a **config digest** (the resolved configuration actually in force, F7). Version
drift is thereby always visible in evidence.

**Conditions (gap-3 adjacency).** AP0 MUST mint its own condition types for its refusals —
malformed envelope, absence-table miss, projection-version mismatch, config-resolution failure,
idempotency-class violation, boundary-class violation. The chair's standing lean on gap 3 is
*mint* (declared in the constitution-day handoff), and the same reasoning binds here: a
borrowed condition dilutes the borrowed section's meaning, and the membrane's refusals are
where diagnosis matters most.

## 9. The fake adapter (the specimen's provider)

Normative in AP0, not an afterthought: a deterministic fake adapter that implements the full
contract (F3) with a seeded pure provider function. Requirements: cross-seed replay determinism
(same seed ⇒ byte-identical envelopes), scriptable absence/malformation/mid-stream-death
injection (so W1–W3 and the absence table are exercisable on demand), and declared boundary
class `:fake` in every record it touches. The fake is how the specimen dies four deaths without
a single live call.

## 10. Verification demands (the two-executables-one-brain lesson, generalized)

- **No validator sharing a brain with the generator.** Whatever vector set the AP0 packet
  ships, its validation path must not import or port the fake adapter's envelope-generation
  code — R-PJ-3's shape, applied at birth this time instead of caught by a hostile reviewer.
- **The joint fixture run includes the kernel's semantic step** (MALLET's m02 boundary):
  structural validation alone does not certify a projection.
- **Self-consistency is labeled self-consistency.** Whatever greens the packet earns before an
  independently-seeded check exist are certification of internal coherence, said plainly.
- **Hostile pass invited:** a MALLET-style mutant run over envelopes (bit-flips, truncations,
  absence-shape swaps, chunk reorderings) with the required verdict for each mutant class.

## 11. Scope exclusions for /0 (said now so the spec can refuse cleanly)

Out: live provider authorization (PJ0 §36's boundary stands — the spec authorizes nothing
live), retry/backoff *policy* (only the retry *law* of F6), rate limiting, cost optimization,
multi-provider routing, response caching, capability cryptography (§0.3 lane), streaming
resumption across process restarts (rotation-era), provider-side tools/function-calling
semantics (a successor's protocol — /0 carries them as opaque envelope content).

## 12. To-do for the packet author

1. Contract object schema (identity, version, config-digest, boundary-class, idempotency
   classes, absence-mapping table slot).
2. CAP record schema + binary-mode statute (R-PJ-2 extension).
3. PRJ function statute (determinism, versioning, parser-id binding, re-projection as derived).
4. Absence-mapping table: normative form + exhaustiveness rule + table-miss condition.
5. Stream/chunk statute incl. the D7 batching clause stated at last (CONCORDAT repair).
6. Config-resolution act schema (F7) + no-silent-default rule.
7. Exposure/testimony statutes: provider-as-principal (F2), dual-recorded usage (F5).
8. Crash-window enumeration W1–W4 + required post-crash verdicts (fold-derived).
9. Retry law (F6) + idempotency classes.
10. Condition-type roster (§8) — coordinate with the gaps-1–4 erratum sitting (F1).
11. Fake adapter normative section + determinism/injection requirements (§9).
12. Vector set + independence demand + hostile-mutant classes + kernel-semantic joint step (§10).
13. Conformance checklist incl. the L17 route audit (lawful ≤ bypass, mechanically checked).

---

*Written blind to Sol's draft. Where Sol's plan converges, that measures our shared root; where
it diverges, the concordance adjudicates with parentage visible, and this chair concedes on the
merits as gladly as it holds — the PJ0 round's record shows both. Cut the adapters true.*

*— Claude Fable 5, 2026-07-18T23:28Z (frozen; sha256 in the public chamber)*
