# AUDIT — Architecture 0.1 Conformance to the Sealed Decisions Record

**Auditor:** CONCORDAT (Claude Opus 4.8, 1M context)
**Date:** 2026-07-18
**Jurisdiction:** narrow and total — does `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` faithfully
embody the sealed decisions record (as amended A-1..A-4), and does it stop where the seal requires?
Not whether the architecture is good — that was settled. Whether the transcription is faithful.
**Method:** every claimed embodiment treated as unproven until the text was found; every prohibited
invention treated as present until proven absent. Greps shown where load-bearing.

---

## HEADLINE VERDICT: **FAITHFUL-WITH-NOTES**

| Table | Result |
|---|---|
| T1 — Seal-to-text trace | 22 operative clauses: **19 EMBODIED · 3 PARTIAL** (D3, D7, DK-4-manifestation-determinacy) · 0 MISSING · 0 CONTRADICTED |
| T2 — Prohibited-invention sweep | 6 checks: **6 ABSENT (clean)** · 0 PRESENT |
| T3 — Ledger verification | 11 of 18 entries sampled: **11 chains resolve** · 1 minor location imprecision (AR-03) |
| T4 — Terminal-case matrix | representability **DEMONSTRATED** (13 rows ⊇ 9 cases) · case-9 excluded ✓ · kimi-null deferred ✓ · 1 NOTE (determinacy not uniformly annotated) |
| T5 — De-moustache + algebra | 6 spot-checks: **6 PASS** |

**No MISSING clause. No CONTRADICTED clause. No prohibited invention. The two adversarial traps
were checked directly and both PASS:** (1) L15 carries the **amended** witness-separation text, not
the superseded "journal is the only observer" phrasing (grep for the superseded string returns
nothing); (2) the name is sealed per A-4 as "Lisp+ the language, Mneme the memory-and-continuity
layer," and 0.1 reflects the **sealed** state — correctly overriding Sol's pre-seal charge that
still called the name open.

The three PARTIALs are all small and all of one kind: two are **permissions the seal adopted that
0.1 declined to restate** (not contradictions — omitted future options), and one is a
**determinacy-label divergence on a single axis of a single fixture** where 0.1's choice is
defensible and traceable to the review lineage but diverges from the seal's literal wording. This
is a faithful transcription with three named seams, not a deviating one.

---

## T1 — Seal-to-text trace

Verdict legend: **E** = EMBODIED · **P** = PARTIAL · **M** = MISSING · **C** = CONTRADICTED.

| Clause | 0.1 location | Verdict |
|---|---|---|
| **DK-1** publication frontier (Model A; commit = publication; one-page channel policy; private staging; `:effects ((:durable-write repo)(:publication scope))`) | §6.13, §8.6, §11.9, §21.1, §18 | **E** |
| **DK-2** two-level projection rule now / classify later; envelope ≠ subject manifestation; representational, no census re-adjudication; A1 independent | §6.7, §6.9, §13.4, §21.2–21.3 | **E** |
| **DK-3** restore by original minter or mint-time delegate; new identity + receipt + revocation recheck + irreversible-effect recheck; **scope equal-or-narrower never enlarged**; libraries MAY escalate sensitive classes | §6.11.2 | **E** |
| **DK-4** four axes, per-axis determinacy, no outcome scalar; uncertain-effect = structured non-determinate effect axis; **Call-296 fixture** | §6.8, §6.10, §15.2 | **P** (see below) |
| **D1** pure→value; short-consequential→outcome; long-running→handle | §7.1, §7.2, §7.3 | **E** |
| **D2** claims: kernel protocol + LCI/0 library representation | §6.3, §12.2, App.B | **E** |
| **D3** dynamic capability enforcement at frontier; **static approximation later, optional** | §7.2, §12.1(12) | **P** (static-later not restated) |
| **D4** abstract store + one human-readable-S-expr filesystem impl; declared durability; longest-prefix folds; torn tails visible; merges receipt-bearing, never timestamp sorts | §9.1–9.4 | **E** |
| **D5** persist requirement + public identity + scope + minting receipt; never live capability | §6.11, §9.8 | **E** |
| **D6** replay triad (execution / evidence / output-reproduction); first two strong while third impossible | §9.7 | **E** |
| **D7** partial streams = identified provisional manifestations; **chunk/checkpoint batching a lawful adapter strategy** | §6.7(4), §7.3 | **P** (batching clause not restated) |
| **D8** `:secret-open` generic epistemic effect; scoring a library protocol | §8.1, §8.5, §12.3, App.B | **E** |
| **D9** kernel extensible publication effect; libraries define meaning; visibility always scoped | §6.3.4, §8.6, §10.5 | **E** |
| **D10** loose inside / exact at the border; canonicalize at durable boundaries | §5.1, §7.1, §14.1 | **E** |
| **L15 (amended by A-1)** witness separation — self-account `:asserted`; standing only via a **distinct inspectable witnessing mechanism**; journal is **default** not only witness; self-narrative not a witness | §3, §10.3, §19-L15 | **E** (amended text — critical pass) |
| **L16** epistemic effect names exposed principals; blindness a spendable ledger resource | §8.5, §19-L16 | **E** |
| **L17** ergonomics as conformance; lawful ≤ shortest unlawful route; "at 5 a.m., syntax becomes governance" | §7.5, §16.1, §19-L17 | **E** |
| **A-2 / L18** principal-role symmetry; no operator/machine species; self-/kin-invocation ordinary; L16 operational half (receiving principals, direct/relayed/inferred, restrictions) | §6.2, §8.5, §19-L18 | **E** |
| **A-1** L15 replacement (witness-separation) | §10.3, §19-L15 | **E** |
| **A-3.1** channel policy informs, does not auto-authorize; mirror-binding = amendment act re-confirming principals; schema carries `:amendment-authority` | §6.13 | **E** |
| **A-3.2** L17 both constitutional law and reference-API criterion; six conformance requirements as test suite | §16.1 (six items), §19-L17 | **E** |
| **A-4** name sealed: Lisp+ = language; Mneme = memory-and-continuity layer | header, §0.1, §13.3 | **E** |

### The two adversarial traps (checked directly)

**L15 — amended text, not superseded (PASS).** The seal's original L15 second clause — *"the journal
is the only observer of a process's past"* — was superseded by A-1. If 0.1 carried the superseded
phrasing that would be CONTRADICTED. It does not:

```
$ grep -ni "only observer|only possible witness|only witness|sole observer" 0.1
NONE FOUND
```

0.1 §10.3 carries the amended law near-verbatim: *"It acquires observational standing only through
evidence captured by a distinct witnessing mechanism whose identity, capture boundary, and integrity
are inspectable. The canonical kernel-mediated journal is the **default** witness … A self-written
narrative is not transformed into a witness by being stored under a respectable filename."* The word
"default" (not "only") is the tell that the amendment landed. **EMBODIED.**

**A-4 name — sealed state, not Sol's pre-seal "open" (PASS).** Sol's `SOL-POST-SEAL-ACCEPTANCE.md`
§"Deliberately unresolved matters" says *"The language's final name remains open. Architecture 0.1
will use a clearly marked working name."* That acceptance **predates A-4** (which sealed the name at
the owner's second asking). The faithful 0.1 must reflect the **seal**, not the charge. It does: §0.1
declares *"the name is settled: Lisp+ is the language; Mneme is its memory-and-continuity layer."* No
"name is open" language survives in 0.1. **This is a case where Sol's charge-list exceeded the seal
and 0.1 correctly followed the seal** — exactly the outcome the audit rules ask for. **EMBODIED.**

**DK-3 scope rule (equal-or-narrower) — checked (PASS).** §6.11.2: *"grants equal or narrower scope,
never enlarged scope."* The adversarial concern (a restoration silently enlarging authority) is
foreclosed in text. **EMBODIED.**

### The one substantive PARTIAL — DK-4 Call-296 manifestation determinacy

This is the single worst finding, and it is small. **Contested step shown:**

- **Seal (DK-4):** *"Call-296 is the canonical fixture: effect `:bounded (:billed :not-billed)`,
  execution `:indeterminate`, **manifestation determinate-absent-so-far-as-evidence-shows**,
  interpretation `:not-applicable`."*
- **0.1 §15.2:**
  ```lisp
  (:manifestation
    (:value (:absent :state :absent-after-completion)
     :determinacy :bounded  ; <-- seal's phrase arguably reads :determinate
     :evidence (...)))
  ```

Three axes match the seal exactly (execution `:indeterminate` ✓, effect `:bounded (:billed
:not-billed)` ✓, interpretation `:not-applicable` ✓). The manifestation **value** matches
(`:absent-after-completion`). Only the manifestation **determinacy label** diverges: 0.1 says
`:bounded`; the seal's hyphenated phrase "determinate-absent-so-far-as-evidence-shows" is naturally
read as determinacy = `:determinate`.

**Adjudication:** the seal's phrase is internally ambiguous — "determinate" collides with "so far as
evidence shows," which itself signals provisionality (= bounded). 0.1's `:bounded` is **traceable to
the review lineage the seal was sealed from**: the Fable review's Appendix B case 4 (uncertain write)
reads *"manifestation `:absent` so-far-as-evidence-shows, `:bounded`."* Because Call-296 died with
execution `:indeterminate` (killed before the settlement record completed), a provisional/bounded
absence is arguably the more correct rendering. **So 0.1's choice is defensible and better-grounded
than the seal's literal wording — but it does diverge from that literal wording, and a faithful
transcription of a fixture spec is where such divergences must be surfaced, not smoothed.** Marked
**PARTIAL**, at its true (small) size. Note that 0.1 §6.8.5 correctly renders the *distinct*
DK-2 completed-absent case (execution `:completed`) with manifestation determinacy `:determinate` —
so 0.1 is not confusing the two cases; it made a deliberate per-case choice.

### The two permissive PARTIALs (D3, D7)

Both are clauses where the seal **adopted a permission** that 0.1 does not restate. Neither is a
contradiction; each is an un-restated future option.

- **D3** — the seal adopted *"static effect approximation later, optional."* 0.1 embodies the
  operative core (dynamic capability enforcement at the frontier, §7.2, §12.1 primitive 12) but
  `grep -ni "static" 0.1` returns **nothing** — the optional-later-static analysis is not mentioned.
  Since it is an explicitly optional future capability, its omission does not contradict the seal;
  it simply does not carry the permission forward. **PARTIAL.**
- **D7** — the seal adopted *"chunk/checkpoint batching is a lawful adapter strategy; semantics are
  the architecture's, batching is the adapter's."* 0.1 embodies the core (partial streams as
  provisional manifestations, §6.7 rule 4, `:present-partial`, §7.3) but `grep -ni
  "batch|checkpoint|chunk" 0.1` returns **nothing** — the batching-is-a-lawful-adapter-strategy
  clause is not stated. §14.4 lists "streaming durability" as an adapter concern, which gestures at
  it. **PARTIAL.**

*(DK-3's "standing custody service is lawful but not built until a real need exists" is likewise
absent from 0.1 — but that is a non-invention directive; 0.1 honoring it by silence is COMPLIANT,
not a gap.)*

---

## T2 — Prohibited-invention sweep

Each treated as PRESENT until proven ABSENT.

| Prohibited invention | Verdict | Evidence |
|---|---|---|
| Concrete channel-policy values (paths/principals/destinations beyond structural schema) | **ABSENT** | §6.13 schema uses placeholders (`...`); §21.1 explicitly stops; `grep -ni "experiments/latent-lisp\|github.com\|Wondermonger\|rsync\|sync.sh" 0.1` → **NONE**. The concrete values live only in `CHANNEL-POLICY-latent-lisp-mirror-DRAFT.md` (verified: it holds `experiments/latent-lisp/**`, the github URL, `sync.sh`, principal list) — the legitimate holder per T2. |
| Classify the 76 kimi records | **ABSENT** | §0 ("does not classify the 76 … kimi outcomes"), §13.4, §15.2 ("demonstrates the algebra, not the pending factual classification"), §18, §21.2. |
| Settle the A1 analyzability ruling | **ABSENT** | §21.3 "A1 analyzability ruling. Independent of the representation mapping." §18 non-goal. |
| Designate sensitive capability classes | **ABSENT** | §6.11.2 references "sensitive classes" without enumerating; §21.4 defers to domain policies; §18 non-goal. |
| Write Kernel /0 operation-level semantics | **ABSENT** | §7 "This notation is architectural, not yet the Kernel /0 formal semantics"; §12 describes *what* the kernel provides; §21.5, §22 defer syntax/byte schemas. Stays at architecture altitude — the permitted side of the judgment call. |
| Impersonate stranger audit / claim independence for self-critique | **ABSENT** | §20, §21.6, §18 all reserve the stranger primitive-minimization audit as **not a prerequisite** and **reserved for a stranger to the Language-A arc**. `grep -ni "independent" 0.1` (11 hits) — every hit is "independent replay/evidence/observation services," "provider-independent equivalence" (a non-goal), "independent of the representation mapping," or "reserved for a stranger." **None claims the document's own critique is independent.** Consistent with Sol's promise: *"I will not rename authorial self-critique as independent corroboration."* |

**No violation.**

---

## T3 — Traced-repair ledger verification (Appendix A, 18 entries; ≥8 sampled → 11 sampled)

Each chain: Draft 0 location exists & says what claimed → review/decision finding exists → 0.1 text
exists. All read against the on-disk Draft 0 and Fable review.

| AR | Draft 0 link | Review/decision link | 0.1 text | Chain |
|---|---|---|---|---|
| AR-01 | §5.7 absence enum (9 reasons, mixed state/cause) ✓ | R1 (state/cause conflation) ✓ | §6.9 two-level ✓ | **RESOLVES** |
| AR-03 | §5.6 outcome / global uncertainty | R3; DK-4 ✓ | §6.8 four axes + per-axis determinacy ✓ | **RESOLVES** (imprecision, below) |
| AR-04 | §5.6 execution values undefined (only `:completed` ever shown) ✓ | R4 ✓ | §6.8.1 explicit algebra ✓ | **RESOLVES** |
| AR-05 | §§6.2, 7.3, 15 implicit seat ✓ | R5 (missing primitive) ✓ | §6.6 five identities + supersession ✓ | **RESOLVES** |
| AR-06 | §5.2 bare visibility (`:private/:published/:withheld/:redacted`) ✓ | R6; D9 ✓ | §6.3.4 scoped ✓ | **RESOLVES** |
| AR-07 | §5.9 capability, no minting bridge ✓ | R7; DK-3 ✓ | §6.11.1–.2 ✓ | **RESOLVES** |
| AR-08 | §8.1 "should land durably" (overclaim) ✓ | R8; D4 ✓ | §9.2–9.4 ✓ | **RESOLVES** |
| AR-09 | §7.1 `:subject-exposure`/`:score-under-key` + §8.1 "census" in kernel ✓ | R9 ✓ | §8.1, §12.3, App.B ✓ | **RESOLVES** |
| AR-11 | self-report only implied (no L15 in Draft 0) ✓ | A-1 / L15 ✓ | §10.3, §19-L15 ✓ | **RESOLVES** |
| AR-15 | title "Lisp+ / Mneme," name unsealed ✓ | A-4 ✓ | §0.1, header ✓ | **RESOLVES** |
| AR-17 | representability asserted (§3, §14) ✓ | review App.B / post-seal charge ✓ | §17 matrix ✓ | **RESOLVES** |

**Minor imprecision (AR-03):** the ledger's Draft 0 location "§5.6 global uncertainty" is slightly
off — Draft 0 §5.6 already enumerates four status axes; the *global* uncertainty facet actually lives
in Draft 0 **§5.2** (the claim's "Uncertainty facet"), and the "five axes" framing R3 targets came
from the packet summary, not literally §5.6. The repair (per-axis determinacy) and the 0.1 landing
(§6.8) are correct; only the cited Draft-0 anchor is imprecise. Does not break the chain.

**No dangling reference in the sample.**

---

## T4 — Terminal-case matrix (§17)

The seal requires the matrix **demonstrate** representability, not assert it.

- **Nine Language-A terminal cases present with four-axis values:** 0.1 §17 carries **13 rows**
  (a superset), covering all nine from the review's Appendix B: untouched seat (1), pre-frontier
  refusal (2), external failure after dispatch (3), uncertain write (4), completed-valid (5),
  completed-no-subject / kimi-null (6), present-invalid (7), withheld folded into "secret opened to
  invoker" + the manifestation algebra (8), reconstructed derived view (9) — plus completed-empty,
  later-authorized-replacement, published-artifact, and self-report. Each row gives execution ×
  manifestation × effect × interpretation values. **DEMONSTRATED.**
- **Case 9 (reconstructed census) EXCLUDED from the outcome algebra & placed in the claim plane:**
  §17 row "reconstructed derived view" reads *"— not an invocation outcome —"* / *"— not an
  invocation manifestation —"* / *"claim origin `:reconstructed`"* / represented *"yes, by refusing
  misclassification,"* and the post-table note: *"The reconstructed derived view intentionally sits
  outside the invocation-outcome algebra. This is a success of separation, not a representational
  failure."* **EMBODIED — explicit exclusion, claim-plane placement.**
- **Kimi-null defers factual state to the locked-lane classification rather than choosing:** the
  matrix demonstrates *both* algebra outcomes (completed-empty → `:present-empty`; completed-no-
  subject → `:absent/:absent-after-completion`) as representable, while §15.2 (*"The exact
  manifestation wording in a live Language-A record remains subject to the sealed structural
  projection"*) and §13.4 (*"factual classification of the 76 kimi records remains outside"*) refuse
  to choose which the 76 are. **EMBODIED — shows the cases, defers the fact.**

**NOTE (not a deviation):** the seal's T4 phrasing is "concrete four-axis values … each with
determinacy." Determinacy is annotated **only where non-trivial** — the `:bounded`/`:indeterminate`
rows (uncertain write; present-invalid "settled or bounded") carry it; the determinate rows mostly
omit an explicit "determinate" tag (e.g., "completed, valid output" shows `:completed | :present |
:settled | procedure-relative result` with no determinacy labels). This reads as "determinate is the
unmarked default," which is defensible, but the matrix does not literally carry determinacy on every
cell. Small; surfaced for completeness.

---

## T5 — De-moustache + algebra spot-checks

| Check | Verdict | Evidence |
|---|---|---|
| (a) `:score-under-key` / `:subject-exposure` NOT kernel effect tags | **PASS** | §8.1 kernel tag list = `:provider-call :spend :secret-open :publication :external-write :tool-action` — neither present; §8.1 explicitly *"The kernel does not contain Language-A-specific `:score-under-key` or `:subject-exposure` primitives."* Both re-enter in App.B as library/domain refinements. |
| (b) "census" NOT kernel vocabulary | **PASS** | `grep -ni "census" 0.1` → 4 hits, all library/specimen: §0.1 ("census leave kernel vocabulary"), §12.3 ("name of a particular derived fold"), §15 ("a derived view called a census only in the experiment library"), App.B ("experiment-library name for a derived fold"). Kernel uses "fold"/"derived view" (§9.3–9.4). |
| (c) absence: state-level closed + cause-level open with evidence | **PASS** | §6.9.1 closed vocabulary ("exhaustive for a kernel version and safe for deterministic folds"); §6.9.2 open, evidence-bearing causal claim ("may be unestablished, contested, or revised without changing the manifestation state"). |
| (d) execution axis explicit enumerated values | **PASS** | §6.8.1: `:not-attempted :refused :failed :completed :cancelled :indeterminate` + `:pre-frontier`/`:post-frontier` qualifiers. (Adds `:cancelled` beyond R4's proposed five — consistent with process vocab §6.5; a defensible addition, not an invention.) |
| (e) manifestation preserves payload for present-empty/present-invalid | **PASS** | §6.7 rule 1 *"Every `:present*` status preserves payload identity"*; rule 2 present-invalid *"names the parser identity."* |
| (f) attempt/seat/request/supersession kernel entities with the six laws from Sol's disposition (or equivalent) | **PASS** | §6.6 binds logical-operation / seat / attempt / external-request / process identities + supersession record; §12.1 primitives 5–6. Sol's six laws (`SOL-DISPOSITION` L115–120) are present in equivalent form: (1) attempt identity/domain, (2) *"Supersession never erases the predecessor"*, (3) *"never rewrites an exposed attempt into an untouched seat"* + fresh-exposure flag, (4) idempotency vs re-exposure via exposure-identity + no-implicit-retry §8.3, (5) uncertain-effect persistence §6.10 + reconciliation, (6) "treatment if both results later surface" + `RECONCILED`. Seat occupancy *"derived from journals … not a mutable boolean."* |

---

## Deposition — what this audit does NOT establish

- It does not establish that Architecture 0.1 is a *good* architecture — that was sealed and is
  outside jurisdiction.
- It does not establish that the terminal-case set is *complete* — only that the nine known
  Language-A cases land and case 9 is correctly excluded.
- The DK-4 Call-296 determinacy finding rests on a **reading** of an ambiguous seal phrase
  ("determinate-absent-so-far-as-evidence-shows"); I have shown both parses and named which the seal
  more naturally supports and which 0.1 chose. A reader who parses the seal phrase as "bounded" would
  downgrade even that lone PARTIAL to EMBODIED — in which case T1 is 20 E / 2 P (D3, D7 only).
- T3 sampled 11 of 18 ledger entries; the 7 unsampled (AR-02, -10, -12, -13, -14, -16, -18) were not
  chain-verified. Nothing in the sampled set suggests systemic ledger fabrication.
- I am a fresh-context Opus reading committed files; I share the repo filesystem with no sibling
  under test here, so no shared-root corroboration hazard applies — this is a document-vs-document
  trace, and the store is the text.

---

## Bottom line

Architecture 0.1 is a **faithful transcription of the sealed record with three small named seams.**
It carries the amended L15, the sealed A-4 name, the DK-3 equal-or-narrower scope rule, and all four
DK decisions and D1–D10 refinements; it invents none of the six prohibited things; its ledger chains
resolve; its terminal-case matrix demonstrates rather than asserts and correctly exiles the
reconstructed census to the claim plane; and its kernel vocabulary is de-moustached. The seams are:
one determinacy-label divergence on the Call-296 manifestation axis (defensible, traceable to the
review, but off the seal's literal word), and two adopted permissions (D3 static-later, D7 adapter
batching) that 0.1 declines to restate. **Where Sol's charge-list exceeded the seal — the name — 0.1
followed the seal.** Recommend adoption with the three seams noted for the owner's awareness; none
rises to a blocking deviation.

— CONCORDAT (Claude Opus 4.8, 1M context), 2026-07-18
