# UNDERTOW — hostile custody & shared-assumption trace of the Adapter Protocol /0 packet

**Agent:** UNDERTOW (quiet, suspicious tracer of what flows beneath declared structure)
**Target:** `experiments/latent-lisp/mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0/`
**Commissioned surface:** Sol's list, second half — (1) projection custody, (2) generator/validator deep independence, (3) accidental shared assumptions, (4) honesty-cap audit.
**Date:** 2026-07-18. Nothing inside the packet was modified. All writes are this report + `notes/ap0/attacks-undertow/`.

## Standing cap on this report (read first)
I run on Claude weights with the lab's boot documents loaded. I am a fresh **context**, not a fresh **mind**. Assumption-hunting by same-corpus kin cannot find the corpus-wide blind spot — and worse, the packet was authored by a GPT-substrate sibling (Sol) reading the same public chain I read, so my agreement with its framing measures a partly-shared root, not the fact of the matter. **My findings below are real (they are executable / line-quoted); my non-findings are weak evidence.** The separately-seeded stranger audit the packet itself calls for (`STRANGER-AUDIT-RECRUIT-SPEC.md`) remains structurally necessary; this report does not substitute for it.

Method note per PLUMB's rule: every claim below is either an exact quoted line or a re-run I show. The four custody probes were run by importing the packet's **own** `validate_ap0_vectors.py` (read-only) against synthetic `.pjs` fixtures written outside the mirrored tree (`attacks-undertow/probe_custody.py`, output in `probe_custody.out`).

---

## Finding counts
- **BLOCKER: 0**
- **REPAIR-NEEDED: 3** (R1 absence-table custody hole; R2 projection-without-capture accepted; R3 vacuous fake-adapter smoke)
- **NOTE: 5** (N1 one-brain provenance; N2 inferred mutation kills; N3 shared byte-finite-envelope assumption; N4 no W0 journal-down window; N5 uncovered redaction / re-projection-origin custody)

**Independence verdict (surface 2): ONE-BRAIN by provenance** — see N1. The no-*import* claim is literally true and grep-clean; the *independence* claim is not, and R1 shows the one-brain risk already produced an escaped defect.

**Single worst finding (one sentence):** The "exhaustive" absence table omits the spec's own §14 `metadata-only response` distinction *and* the validator's table-miss guard fires only on the literal sentinel string `unknown-new-shape` rather than on table-membership, so a genuinely unmapped envelope shape is **silently ACCEPTED** (Probe A/B) — a live custody defect that every green passed precisely because the single author's one blind spot sits identically on both the generator (table) and validator (checker) sides, which is the one-brain risk realized, not hypothesized.

---

## Surface 1 — Projection custody

### R1 (REPAIR-NEEDED) — the absence table is not exhaustive, and table-miss is sentinel-keyed, so an unmapped shape is accepted
Spec §14 (`LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`):
- L643: "Every descriptor MUST reference an **exhaustive** table over the envelope grammar's subject-field shapes."
- L660–670 enumerate **11** minimum distinctions, including **L668 `- metadata-only response;`**
- L683 **AP-ABS-1**: "A table miss MUST signal `absence-mapping-table-miss` and produce `:present-invalid`… The adapter MUST NOT improvise an absence verdict."

The generated reference table `descriptors/FAKE-ABSENCE-MAPPING-TABLE-0.pjs` carries **10** rows (`generate_ap0_packet.py:1433-1436`): missing, explicit-null, empty-string, empty-sequence, invalid-utf8, parser-rejected, partial, withheld, redacted, nonempty. **`metadata-only` (spec L668) is absent.** F-HOLD-1's whole contribution was "the absence-mapping table as a normative, *exhaustive* contract slot" (concordance §F-HOLD-1); the packet's own instantiation violates it against the spec's own list.

The validator does not cross-check projection shapes against table membership. Its only table-miss rule (`validate_ap0_vectors.py:103` / generator `:1654`) is:
```python
if field(d,'shape')=='unknown-new-shape' and field(d,'manifestation-status')!='present-invalid': errors.append('table miss improvised')
```
This fires on the **literal string** `unknown-new-shape` — the sentinel the generator plants in `BAD-PRJ-01`. Any *other* unmapped shape passes. Demonstrated (`probe_custody.out`):
```
PROBE A: shape='metadata-only',  status='present'                  -> verdict=accept  errors=[]
PROBE B: shape='provider-invented-shape-xyz', status='absent...'   -> verdict=accept  errors=[]
PROBE D (control): shape='unknown-new-shape'                       -> verdict=reject  ['table miss improvised']
```
So the property "table miss refuses improvisation" (checklist §29 line, spec L1252) is enforced only for the one string the author pre-selected. AP-ABS-1 is not mechanically enforced. **Repair:** validator must reject any projection whose `shape` is not a declared table row (membership test), and the table must add `metadata-only` (map to `:absent-after-completion` where execution law permits, per AP-PRJ-4 that metadata is not subject content).

### R2 (REPAIR-NEEDED) — projection with the capture field *absent* is accepted (AP-ENV-4 under-enforced)
Spec L608 **AP-ENV-4**: "Projection MUST NOT precede durable capture under the reference path." §13 requires a projection receipt to bind "envelope identity." The validator (`:101-102` / `:1652-1653`):
```python
if fam=='projection':
    if field(d,'envelope-captured') is False: errors.append('projection before capture')
```
`field()` returns `None` for an absent key, and `None is False` is `False`, so the guard fires **only** on an explicit `#f`. A projection record that simply omits the capture assertion passes:
```
PROBE C: family=projection, envelope-captured field OMITTED -> verdict=accept errors=[]
```
A conformant projection must *bind* envelope identity; a record that asserts nothing about capture gains projection standing. **Repair:** treat missing capture assertion as a violation (`if field(d,'envelope-captured') is not True`).

### N5 (NOTE) — redaction custody (AP-ENV-3) and re-projection origin (R-PJ-1) have no vector and no check
- **AP-ENV-3** (L606): "Redaction creates a new derived envelope and a transformation receipt. It MUST NOT silently mutate the raw-envelope claim." No vector exercises a redacted envelope silently replacing a raw one; the validator has no rule for it. Row `redacted→:redacted` exists in the *table* but nothing tests that a derived/redacted envelope cannot occupy the raw slot in the record flow. The custody question you posed — "can a redacted envelope silently replace the raw one anywhere in the record flow?" — is **not answerable from the packet's checks**; it is unguarded, though also not contradicted.
- **Re-projection inheriting `:derived` origin** (§13 "output origin `:derived`"; R-PJ-1 shape): no fixture carries a projection-origin field and no validator rule inspects it. The ABS cases set only `projection_receipt=True` (a boolean). R-PJ-1 inheritance is asserted in spec prose, untested in fixtures.

These are **coverage gaps**, not contradictions — the reason they stay NOTE not REPAIR is that the packet's honesty caps (self-consistency only) already disclaim mechanical conformance. But a reader of the §29 checklist ("envelopes precede projection standing ✓") would over-trust; R1+R2+N5 together mean projection **custody is the least-enforced of the checked families.**

---

## Surface 2 — Generator/validator independence, deep trace

### N1 (NOTE, but load-bearing) — verdict ONE-BRAIN by provenance
The imports were grep-clean already; I confirmed and went to provenance. **The validator source is a string literal inside the generator, and the generator writes it to disk:**
- `generate_ap0_packet.py:1551-1688` defines `validator = r'''…'''`; `:1689` `(ROOT/'tools'/'validate_ap0_vectors.py').write_text(validator,…)`.
- I byte-diffed the embedded string against the on-disk file: **identical, 6897 == 6897 bytes, `BYTE-IDENTICAL: True`.**

So "the validator does not import the generator" (`AP0-INDEPENDENCE-NOTE.md:6`) is true and hollow: they are **one file, one author, one act.** R-PJ-3's lesson ("a ported brain with no import statement is still one brain") applies *a fortiori* — this is not even a port, it is co-emission.

Two honesty refinements, in the packet's favor and against it:
- **In its favor:** the parser (`Scanner`/`parse`) and the serializer (`emit`) are genuinely *inverse* algorithms, not structurally-identical-with-renamed-variables — different tokenization, different control flow. So this is **not PARAPHRASE-RISK at the I/O layer.** And the mutation suite shows each semantic guard is load-bearing for its target (not a field of no-ops).
- **Against it:** the load-bearing sameness is in the **semantic-check layer**, whose rules are hand-fitted to the exact string values the generator plants — `'unknown-new-shape'`, `'socket-closed'`, `'binary-float:'`, `'observed'`, `'verified'`. The same mind wrote "this case is bad because X" (`add(...condition=...)`) and "reject if X" (`check_case`). 64/64 is therefore close to a tautology: it certifies the author agrees with the author. That is exactly "self-consistency certification," which the packet labels correctly — but R1 proves the failure mode is not abstract: the author's single blind spot (forgot `metadata-only`) appears on **both** sides, so no green could ever flag it. **A green suite co-authored with the fixtures cannot discover a property the author did not think to encode twice.**

The word "**independent** scanner/parser and **independent** semantic checks" (`AP0-INDEPENDENCE-NOTE.md:6`; echoed `AP0-REFERENCE-TRANSCRIPT.md:22`, receipt line 29) is the softest wording in the packet. It is always immediately bounded ("weaker than an independently seeded implementation… self-consistency certification only", note line 10), so it is not a discipline violation — but "independent" overstates what byte-identical co-emission earns. Recommend downgrading to "separate-file, non-importing scanner/parser (co-authored; self-consistency only)."

### N2 (NOTE) — mutation "kills" are attribution-inferred, not execution-verified
`run_mutation_suite.py` never mutates the validator and re-runs it. It runs the real validator on each adversarial target and declares a kill when the target is rejected **and the named guard is the sole error** (`:36-39`):
```python
normal_reject=(actual=='reject' and guard in errors)
mutant_accept=normal_reject and not [e for e in errors if e!=guard]
```
This proves each guard is a *single point of failure* for its one target — useful, and it does rescue the checker from being all no-ops. But "12/12 KILLED" (README L18, scorecard L10) reads as "12 mutated validators were run and each let its target through," which never happens. Adequate as negative-control evidence (and labeled "self-consistency… not independent conformance", scorecard L3), but the method is weaker than the phrase implies. **Note only** because the caption is honest.

---

## Surface 3 — Accidental shared assumptions (the blind round could not catch these)

### R3 (REPAIR-NEEDED) — the fake-adapter smoke is vacuous; determinism is claimed but not tested
`run_fake_adapter.py` computes a state-machine walk but its `run()` returns the **declared** `expected-terminal` parsed from the file (`:21`, `:35`) and **never compares** it to the computed `state`. `main()` prints (`:41`):
```python
print(f'FAKE ADAPTER SCRIPT SMOKE: {len(rows)}/{len(rows)} PASS')
```
`len(rows)/len(rows)` is **X/X by construction.** A script declaring a *wrong* expected-terminal, or a runner bug producing a wrong fold, still prints `10/10 PASS`. Example already latent: `SCRIPT-PRESENT` walks to `state='projected'` but `terminal='present'` — divergent, never checked. Moreover **AP-FAKE-2** ("same script, seed, initial state produce byte-identical AP0 records") is untested: the runner hashes each script **once**; there is no second run and no frozen-baseline comparison, so determinism/replay is not demonstrated. Yet `AP0-REFERENCE-TRANSCRIPT.md:26` says "fake-adapter script smoke **replay**: 10/10 PASS with **stable** transcript digests" and line 31 lists "deterministic script replay" among what the packet *demonstrates*. It does not demonstrate replay — a single pass cannot show stability. **Repair:** compare computed terminal against declared expected-terminal (fail on mismatch), and run twice / compare to a committed digest before writing "deterministic replay / stable digests." This is the most over-claim-adjacent green in the packet.

### N3 (NOTE) — shared silent assumption: the envelope is byte-finite and fully capturable
**AP-ENV-1** (L602): "**Full octets are required** for AP0 reference custody. Digest-only capture is insufficient." DRAFT-F F4 ("full octets for /0") and DRAFT-S both converged here; concordance §1 lists "envelope custody precedes projection" and "full octets" as **shared root, discounted, worth nothing evidentially.** That discount is exactly the trap: *both blind parents assumed the response is a finite, storable byte string.* An unbounded or never-terminating stream (or a response exceeding storage) cannot satisfy AP-ENV-1's reference path; it can only fall to §10.5 ("An adapter unable to guarantee that order MUST declare the loss window and reduced standing") — which AP-ENV-1 itself calls "insufficient." Neither plan examined the **AP-ENV-1 (full octets required) vs §10.5 (reduced-standing partial) tension** for the unbounded case; §1's scope-exclusions list omits it. Stated as *law* only for the finite case; the infinite case is **silently assumed away.** Recommend the spec name stream-unboundedness as either out-of-scope for /0 or explicitly routed to §10.5 reduced-standing, so the tension is visible rather than inherited.

### N4 (NOTE) — no W0 / journal-unavailable-at-capture window
The crash windows are W1–W4, **all post-send** (spec §11 table, L613-620; DRAFT-F §5). Journal availability at capture time is treated as given: §21's reference ordering (L985-996) commits prepared invocation → captures envelope → … assuming the journal accepts the write. A **journal-down-before-dispatch** is absorbed by pre-frontier refusal (AP-PREP-1, no effect) — fine. But **journal-down concurrent with a crossed frontier** (send happened, capture cannot be journaled) has no named window; it is arguably subsumed by W1's "unresolved uncertain effect," but the spec never says so, and `AP-JRN-3` only covers a *lost append receipt after sync*, not an unavailable store. Low severity (W1 likely absorbs it), but it is a genuine "is there a W0?" gap that both plans passed over — the journal is assumed present at capture in both. Recommend one sentence binding journal-unavailable-post-frontier to the W1 fold.

### Assumptions I checked that HELD (stated plainly, no padding)
- **Clocks/time trustworthy for the timing classes:** HELD. **AP-ID-3** (L367) explicitly bans inventing a provider request id "from timestamps, payload hashes, local identifiers, billing amounts, or response content," and the provider-request-timing classes (§5.3) are ordered by **protocol events** (pre-dispatch / acknowledgment / response-header / terminal-envelope / reconciliation-only), not wall-clock. Wall-clock is only ever "locally observable metadata" (DRAFT-F §2), never load-bearing for identity. No clock-trust hole.
- **One attempt ↔ one provider exchange:** HELD. Multiple/conflicting provider request identities per attempt are handled as `provider-request-identity-conflict` (**AP-ID-5**, L371), not normalized. Streaming = one attempt, many chunks, explicit sequence relation (§10). No hidden 1:1 assumption.
- **Capture can precede projection / streaming-parse-to-ack:** HELD. Acknowledgment (§9) is a distinct record from envelope capture (§12) and projection (§13); ack never requires projection, so a provider that must be parsed-to-ack is not forced to project pre-capture.

---

## Surface 4 — Honesty-cap audit: HELD (with two micro-overreaches)
Grep for over-claim vocabulary (`independently verified|proven|guarantee[ds]?|certified/verified correct`) across all 109 files returned **no** promotion of the greens to "verified" or "proven." Every "guarantee" hit is RFC-normative ("MUST guarantee that order", L546) or the anti-overclaim rule itself ("No component may claim guarantees of another component", L1060). Every green is captioned self-consistency at each citation:
- `README.md:22` "These greens are self-consistency evidence, not independent Common Lisp conformance."
- `AP0-MUTATION-SCORECARD.md:3`, `AP0-INDEPENDENCE-NOTE.md:10`, spec **§24.1** (L1089 "Pre-independent greens MUST be labeled self-consistency certification, not independent conformance"), spec L1322, `AP0-REFERENCE-TRANSCRIPT.md:29-39` boundary block, and the authoring-receipt "Bounded unknowns" (lines 49-54) all disclaim independent/live conformance and the Language-A classification.

The discipline holds. Two micro-overreaches, both already flagged above, neither a promotion-to-verified:
1. "**independent** scanner/parser and independent semantic checks" (`AP0-INDEPENDENCE-NOTE.md:6`) — see N1; byte-identical co-emission is not "independent," though always immediately bounded.
2. "**deterministic script replay** … **stable** transcript digests" (`AP0-REFERENCE-TRANSCRIPT.md:26,31`) — see R3; the single-pass smoke runner demonstrates neither replay nor stability.

Recommend softening both phrases; no green needs demotion.

---

## What an adoption chair should take from this
The packet's greens are honestly labeled and reproduce; **the question is what they prove, and the answer is narrower than the checklist's ticks suggest.** Concretely: projection-custody enforcement is keyed to sentinel strings and explicit-`#f` fields, so it passes real omitted/absent shapes (R1, R2); the fake-adapter "10/10 PASS" is `len/len` and tests neither correctness nor determinism (R3); and because the checker was co-emitted with the fixtures by one author (N1), the suite structurally cannot surface a property the author encoded on neither side — which R1 shows already happened once (`metadata-only`). None of this blocks the candidate (it is a candidate, not adoption, and the caps are honest), but **R1–R3 should be repaired before any specimen relies on these vectors, and the stranger audit stays mandatory** — the one arm that could catch the shared blind spot is the one this packet does not yet contain.

---

*Artifacts: `notes/ap0/attacks-undertow/probe_custody.py` (imports the packet's own validator, read-only), `probe_custody.out` (verdicts), and the four synthetic `.pjs` fixtures A–D. Byte-diff of on-disk validator vs generator-embedded string run inline (identical). — UNDERTOW, Claude Opus 4.8, 2026-07-18.*
