# Surface Account /0 — Architecture Docket

**Seat:** JURIST (architecture and law).
**Author:** Claude Fable 5. Measurement seats: CARTOGRAPHER, FABER, WARDEN
(Claude Opus 5, 1M context). These are same-family cross-checks, not an
independent audit; no claim below is "independently audited," and none may be
promoted to that standing by citation.
**Date:** 2026-08-04.
**Round standing:** R0 opening, **amended in the R1 repair round** per the
owner adjudication (`OWNER-ADJUDICATION-R0-AND-R1-COMMISSION.md`; direction
`NATIVE-COMPOSITE` retained, ownership reading locked; per-change record in
`R1-AMENDMENT-LOG.md`) — design documents only. Nothing in this docket is
implemented, adopted, or merged; no lane is closed by it.

**Claims ceiling for this document.** The strongest claim made anywhere below
is: *opening contract and bounded feasibility return complete; exact current
seven-head union measured; one successor lineage recommended.* Every other
sentence is design reasoning under that ceiling.

---

## 0. The question, and the fork inside it

The governing handoff is one sentence:

> one composite public expansion-account front door over independently closed
> surface modules, so Surface /3 does not clone a third receipt machine

The commission's own archaeology names the fork this sentence hides: a viewer
or router over the two existing account engines unifies today's presentation
but accounts for no new heads; a shared mint over the seven current heads
solves the future boundary but adds a third live account implementation today
unless natives are explicitly superseded or retired. This docket compares the
four commissioned lineages across every commissioned dimension, adjudicates
the fork on the measured evidence, and recommends exactly one verdict.

---

## 1. The evidence this docket stands on

Every load-bearing fact below was measured this round and is cited to its
evidence file. Nothing is re-derived here.

| # | Fact | Evidence |
|---|---|---|
| E1 | Fourteen cases ran (7 heads × 2 operations); **12 minted receipts** with source exactly representable and expansion decode/re-encode octet-identical; **2 lawful STOPs** | `probe-transcript.txt`, the `CASE 01`–`CASE 14` blocks and the `REPRESENTABILITY STOPS` block |
| E2 | The two STOP cells are `DERIVE-CASE` and `DERIVE/2-CASE` under `:macroexpand`, refused by **Surface /1's own grammar**: `EXPANDED-TERM-SHARED-STRUCTURE`, 3 shared conses (from `CL:HANDLER-CASE` in the full expansion), 13 uninterned symbols also present. **Ratified as lawful current composite outcomes by owner adjudication Locked Ruling 2** — both heads remain admitted and requestable; no completed account exists for either | `probe-transcript.txt`, the `CASE 11` and `CASE 12` blocks and their `PROBE-SIDE-HOST-MEASUREMENT` lines (`DEPTH 10 NODES 221/225 UNINTERNED 13 SHARED-CONSES 3`) |
| E3 | Fixture maxima — observations, never "needed" ceilings: sources depth 4 / nodes 47 / octets 1511 (all 14); expansions depth 8 / nodes 109 / octets 3451 (the 12 that produced a datum) | `probe-transcript.txt`, the `OBSERVED MAXIMA OVER THE FOURTEEN FIXTURES` block, with the scope statement printed beside the numbers |
| E4 | S2 conflates refusal species **by class**: macro-owned refusal and account refusal are both `LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED`; **among S2's `:protocol-refusal` catalog rows, and only among those, the `phase` field is the only separator** (the `:integrity-alarm` rows separate by `category` — the category-first law, jurisdiction §4), and S2's TRY door returns the macro-owned one in the refusal position. S1 separates by class (`LISP-PLUS-SURFACE0:SURFACE-SYNTAX-REFUSED` vs `LISP-PLUS-SURFACE1:EXPANSION-REFUSED`) | `controls-transcript.txt`, the `CONTROL 7` block, its `MEASURED ASYMMETRY, REPORTED NOT SMOOTHED` lines; `surface2.lisp:941–953` (`try-perform-expansion`) |
| E5 | Both providers' **public** term functions signal **non-exported** condition classes: S1 `%TERM-UNREPRESENTABLE` (`surface1.lisp:390`), `%TERM-IRRECONSTRUCTIBLE` (`surface1.lisp:637`), signalled by public `ENCODE-TERM`/`DECODE-TERM` (public docstring at `surface1.lisp:554–557` names the private class); S2 `%TERM2-TROUBLE` (`surface2.lisp:541`, named in `ENCODE-TERM2`'s public docstring at `surface2.lisp:594`) | source lines cited; corroborated by the 1 (S1) and 2 (S2) exported condition-types in `PROVIDER-API-MATRIX.tsv` |
| E6 | The identity trap: `EXPANSION-RECEIPT-PROCEDURE-IDENTITY` / `-POLICY-IDENTITY` in both providers ignore the receipt and return **live** declarations (answered on `NIL`, `42`, a string); only version **values** are receipt-stored; Control 6 proved stored versions retain historical standing after redefinition while live identities move. S2's `VERIFY-RECEIPT` is a **separate fact with the authoritative standing of owner adjudication Locked Ruling 6** — `provider-recomputation`: bounded re-derivation of stored source-form and expanded-form identity projections **from stored datums; independent of live grammar/procedure/policy declarations**; its continued `T` after redefinition (Control 6) demonstrates that declaration-independence | `CARTOGRAPHY-NOTES.md` §7, §10; `READER-PROVENANCE-MATRIX.tsv` accessor + verifier rows; `controls-transcript.txt`, the `CONTROL 6` blocks (both providers) |
| E7 | Cross-application hazard: of 108 cross-provider misapplications, 72 raised `TYPE-ERROR`, 8 were predicates correctly answering `NIL`, **18 silently returned substantive wrong values** across 9 print-names; 54 shared print-names, 0 `EQ`; `EXPANSION-RECEIPT-DISPOSITION` value **types** differ (S1 keyword, S2 string) | `CARTOGRAPHY-NOTES.md` §§4, 8, 9; `READER-PROVENANCE-MATRIX.tsv` cross-provider rows |
| E8 | S2's `VERIFY-RECEIPT` returns `T` natively but **signals** on a foreign receipt rather than returning a verdict | `CARTOGRAPHY-NOTES.md` §8; `READER-PROVENANCE-MATRIX.tsv` verifier rows |
| E9 | **Twenty-five classified TSV rows** (never "25 atomic facts" — a row classifies what an accessor family reads) fall outside the commission's original five provenance labels; the vocabulary is now **extended by owner adjudication Locked Ruling 5**: `request-stored` (12), `refusal-record-stored` (9), `condition-stored-reference` (2 — the `EXPANSION-CONDITION-REFUSAL` rows: the carrying relation is borne by the condition, not the refusal record), `provider-recomputation` (1), `provider-derived-projection` (1), all first-class. *(History: 13 flagged at first survey as `OUT-OF-VOCABULARY:`; request-borne rows added post-review F3; the ruling settles the vocabulary.)* | `CARTOGRAPHY-NOTES.md` §10; `READER-PROVENANCE-MATRIX.tsv`; `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 |
| E10 | Custody: `OPENING_BASE` = `c12e96f4…` (distinct from sealed tip `798d59f2…`); subject tree byte-identical at both (`6f43791f…`); public `main` = `ced1b2ce…` | `OPENING-BASE-AND-CUSTODY.md`; `PREDECESSOR-IDENTITIES.md` |
| E11 | Both providers export provider-specific public predicates (`EXPANSION-RECEIPT-P`, `EXPANSION-REFUSAL-P`, `EXPANSION-REQUEST-P`, `EXPANSION-OCCURRENCE-P`) and the four doors (`REQUEST-EXPANSION`, `PERFORM-EXPANSION`, `TRY-*`) | `PROVIDER-API-MATRIX.tsv` |
| E12 | S1's native refusal catalog already contains `:construct-not-a-macro` at phase `:perform` ("the resolved symbol has no macro function in this image") and `:source-not-reconstructible` with FIND-SYMBOL-never-INTERN reconstruction | `surface1.lisp:185–230` (`+refusal-catalog+`) |
| E13 | The two native grammars do not agree octet-for-octet on one host form; each decoder refuses the other's datum; neither has a printed-representation fallback; decode never INTERNs | `controls-transcript.txt` Control 5 |

---

## 2. The four lineages, each across every commissioned dimension

### Candidate A — Read-only sum inspector

Projects existing S1/S2 receipts. No action doors of its own.

| Dimension | Candidate A |
|---|---|
| Accepted object domain | Closed tagged union of the two exact native receipt species (and, if refusal outcomes are to be inspectable, the two native retained-refusal species), admitted by provider-specific public predicates (E11). No requests, occurrences, `SEAT-OUTCOME`s, `NIL`, or plists. |
| Expansion vs read | **Read only.** Never expands, never delegates action. |
| Account / refusal owner | Native providers, unchanged. A projects; it owns nothing. |
| Term boundary | None of its own: native datums carried unchanged with species and provenance explicit. E13 forbids any guessed common codec. |
| Canonical representation | One fixed-schema record with per-species typed branches (E7 forbids flattening; disposition types differ). |
| Identity/version bindings | Reports receipt-stored versions as stored — **and stored artifact facts only: the pure inspector reads no live declaration and reports nothing "as current"** (R3-C; the R0 "live declarations as current" clause is deleted). Binds nothing itself — it has no manifest and no version of its own to bind, which is itself a gap: an inspector with no versioned schema identity cannot support the fail-closed lifecycle step 5. Repairable by giving A a schema version, at which point A needs Account-owned authority anyway. |
| Image-local vs durable | Its record is inert data; native opaque identities carried unchanged and labelled image-scoped where they are. |
| Failure jurisdiction | Typed refusal of non-admitted objects. Cannot adjudicate expansion-time conditions — it never expands. |
| Dynamic-extension risk | Lowest of the four: no doors, no mint, closed admission ECASE. |
| Predecessor closure impact | Zero. Reads public APIs only. |
| Supersession / compatibility / retirement standing | None required: nothing is superseded; both native doors remain callable with all gates. |
| Load/integration impact | One small package, one loader row, additive floors. |
| Exact future Surface /3 lifecycle | **Cannot supply it.** A accounts for no new heads and has no action authority to extend; S3's heads would have no front door, so pressure to clone a machine in S3 is not removed — it is left standing. |
| R4 accretion survival | Survives trivially as code, fails as an answer: adopting A alone leaves the one-front-door promise unmet (callers still call both providers' doors directly), so the lane risks becoming exactly the ceremonial candidate the assessment fears. |

**Judgment:** A is a **component**, not an answer. Its inspector contract is
correct and is retained inside the recommended lineage; alone it satisfies
neither half of the governing promise.

### Candidate B — Native composite front door

Routes current forms to S1/S2 through a closed seven-head manifest and
projects the results. Native providers keep all mint authority.

| Dimension | Candidate B |
|---|---|
| Accepted object domain | Action doors: source forms whose head keys the closed seven-row manifest (`SEVEN-HEAD-MANIFEST-CANDIDATE.tsv`), one of two declared operations, a CD/0 identifier occurrence tag (both natives refused a **string** tag with `:OCCURRENCE-TAG-NOT-IDENTIFIER` — measured, `CARTOGRAPHY-NOTES.md` §3 item 2; the code is catalogued at phase `:request` in both. One host type measured, not the complement of one type — wording narrowed post-review, F8). Inspector: the five-member union of contract I.8 (B's doors construct pre-delegation refusals, so the fifth member is reachable). |
| Expansion vs read | **Both, separately named.** Action doors delegate expansion; the inspector only reads. Action is never called "inspection." |
| Account / refusal owner | **Native providers.** Under the pure-projection law (contract I.0): the composite **constructs** sealed routing requests and sealed pre-delegation refusal records, and **mints no** completed receipt, occurrence, expansion-account identity, or competing native-domain identity — the native receipt or retained native refusal *is* the account-domain artifact. The composite owns only its manifest, its routing law, its two constructed artifact kinds, and its projection schema. |
| Term boundary | Native, per delegate. No new grammar; no pinned-codec adoption (E5 makes public failure classification impossible without `::` or broad capture — see `TERM-GRAMMAR-DECISION.md`). Native datums carried with species tags. |
| Canonical representation | The Candidate-A record over native artifacts (which — R2 Section D — carries **no** composite manifest binding: the binding lives in the routing request only, and the successful-path projection cannot expose it), plus the branch-5 record for composite pre-delegation refusals, which alone carries manifest identity/version. |
| Identity/version bindings | Composite manifest identity + version (proposed; none exists today) bound into every composite request; native stored versions reported as stored — **stored artifact facts only: the pure inspector reads no live declaration and reports nothing "as current"** (R3-C; the R0 clause deleted); the Surface /0 no-macro-language-version absence preserved explicitly. |
| Image-local vs durable | Composite requests are image-local objects; the canonical record is a direct inert CD/0 record datum (durable-grade data); the request's `macro-function-anchor` field is fixed and always present (value may be the constant `:anchor-not-captured` — contract I.9) and is image-local only, never projected into any durable record. |
| Failure jurisdiction | Three species kept distinct (see `REFUSAL-AND-CONDITION-JURISDICTION.md`): native protocol refusals surface as the account-domain outcome; macro-owned and unexpected host conditions escape unchanged in original species (Control 7); the S2 class-conflation is keyed on the public `category` reader first, then the `phase` field — never the class (E4; law amended post-review, F4: phase alone misfiled both providers' `:receipt`/`:match` integrity-alarm rows). |
| Dynamic-extension risk | Low: ECASE manifest, collision check (Control 3 shape), no registry, no fallback, no both-providers retry. Residual risk is the E7 hazard set, closed off by predicate-gated admission and by never applying one provider's readers to the other's objects. |
| Predecessor closure impact | Zero byte impact; zero standing impact. S1 and S2 remain closed under their own laws; the composite adds an additional front, not a replacement. |
| Supersession / compatibility / retirement standing | **None required today.** Per native door: still callable — yes, unchanged; gates retained — yes, byte-untouched; new work directed where — new *callers* are directed to the composite front door as convention (not law; nothing retires); new *heads* directed to the governed Account successor; owner ruling required — none for B itself. |
| Load/integration impact | One package, `lisp-plus.asd` row, umbrella + load-order rows, additive floors (see `R4-SURVIVAL-PLAN.md`). |
| Exact future Surface /3 lifecycle | B **alone** does not supply it — the commission's own table says a later Account successor, not S3, must own new-head machinery. B is silent on the mechanism, and objective item 6 requires the mechanism to be returned. |
| R4 accretion survival | The implemented core survives (package, loader, floors, specimen, differential gates); but B-without-a-successor-law re-creates the fork at Account /1 time with no governing law in place. |

**Judgment:** B is the correct **implemented core** and the wrong complete
answer: it satisfies the one-front-door half and leaves the
no-S3-machine half to an unspecified future. The commission requires the
future lifecycle to be returned now, as law.

### Candidate C — Shared replacement mint now

One Account-owned seven-head request/occurrence/account law, implemented in
the production round.

| Dimension | Candidate C |
|---|---|
| Accepted object domain | Same admission surface as B's action doors, plus its own request species; inspector domain gains the Account-owned species immediately. |
| Expansion vs read | Both, separately named; Door 2 invokes `MACROEXPAND-1`/`MACROEXPAND` itself in the null lexical environment. |
| Account / refusal owner | **Surface Account** — a third live minting authority, in an image where both native engines remain loaded, public, and callable. |
| Term boundary | **Must be Account-owned.** The pinned-S1-codec candidate is eliminated by E5 under the commission's own elimination rule (`TERM-GRAMMAR-DECISION.md` §3 shows the contested step). So C requires a new grammar implementation with the full predecessor repair burden (cycles, sharing, depth, nodes, package identity, aliases, decode-by-lookup, printed-representation refusal) — repairs S1 bought through Errata 0.1–0.3 and a stranger audit, which the new grammar would re-purchase from zero. |
| Canonical representation | Account-owned CD/0-style records; native species still exist in the world and still need the inspector's native branches for every artifact minted before C (and for any caller still using native doors — which remain public). |
| Identity/version bindings | Account manifest/grammar/procedure/policy identities + versions, all new. |
| Image-local vs durable | As in the conditional contract (`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` Part II). |
| Failure jurisdiction | Account-owned three-species law — buildable, but note: for the current seven heads it reproduces adjudications the natives already perform, creating two parallel refusal vocabularies for one head today. |
| Dynamic-extension risk | Same closed-manifest discipline; larger surface (a mint has more moving parts than a router), and a **third receipt species** enlarges the E7 hazard field unless admission stays airtight. |
| Predecessor closure impact | Byte impact zero, standing impact **not zero**: C is "the account front door" only if the native engines' account role is explicitly superseded — and Surface /2 is permanently closed at Erratum 0.2, Surface /1 closed under its accepted law, so the supersession law cannot live in their lanes; it must be an owner ruling in the Account lane governing *direction of use* of closed, still-callable doors. |
| Supersession / compatibility / retirement standing | **Required, today.** Per native door: still callable — yes (closed bytes untouched); gates retained — yes; new work directed where — *all* account-minting for the seven heads directed to Account doors; owner ruling required — an explicit supersession ruling naming both native engines' account role as historical. Without that ruling C "must not call itself the prevention of the third machine" (commission's own words) — it *is* the third machine. |
| Load/integration impact | Largest: grammar + mint + inspector + floors; the differential-gate burden doubles (Account outcomes vs native outcomes on the same fixtures). |
| Exact future Surface /3 lifecycle | Clean on paper: S3 heads land as new rows of a successor manifest that C's own governance introduces (distinct declarations under the coexistence law — no "manifest movement": /0-style declarations never move, R3.1-C). This is C's one real advantage. |
| R4 accretion survival | Survivable but heaviest; and the no-dormant-mint rule is satisfied only because C would serve all seven current heads — at the cost of re-implementing, unaudited, what two audited closed engines already lawfully do. |

**Judgment on C — the honest comparison (rewritten in R1: the R0 sentence
"C buys nothing today" is WITHDRAWN per the owner adjudication, Section D;
it was an overstatement, and the benefits below are real).**

**What C genuinely buys today — four benefits, recorded as the adjudication
directs:**

1. **Mint-time stored identities.** An Account mint stores its
   grammar/procedure/policy *identities* at mint time (Part II.5), where
   the native receipts store only version *values* — the exact gap the
   identity trap (E6) exposes. A native-composite record cannot close that
   gap; a C-record would never have it.
2. **Manifest-bound records.** Every C-account carries the Account manifest
   identity/version as a stored fact. Under B/D — sharpened in R2 (Section
   D, added precision to a locked benefit, not a reopening) — **the
   manifest binding lives in the composite routing request only**: a
   successful projection from an exact native receipt **cannot expose that
   binding at all**, because the inspector receives neither the request
   nor any composite completion record (Door 2 returns the exact native
   receipt, I.0; only branch 5, the composite refusal, carries manifest
   identity/version). C's completed accounts would carry the binding
   durably; B/D's completed path structurally cannot.
3. **Uniform schema and refusal law.** One record schema and one typed,
   exported refusal vocabulary across all seven heads — where the composite
   must carry two native value domains (keyword vs string dispositions,
   present vs absent upstream fields) in typed branches and key S2's
   conflated condition class by category-then-phase.
4. **Potential fresh temporal occurrence identity.** A mint can implement
   the II.3 freshness mechanism for the current seven heads now; the
   delegating composite cannot claim temporal uniqueness at all
   (`temporal-uniqueness-standing: not-claimed`, I.5/I.8b).

**The actual tradeoff, argued:** those benefits do not presently justify
(i) **a third live account authority** in an image where both native
engines remain loaded, public, and callable; (ii) **a new grammar and its
audit burden** — the pinned-codec route is eliminated (E5, Locked
Ruling 3), so C's grammar is new code re-purchasing, from zero, repairs the
native codecs bought through Errata 0.1–0.3 and a stranger audit (E12,
E13); or (iii) **premature supersession of two functioning native
engines** — C is "the account front door" only under an explicit
supersession ruling over the direction-of-use of closed lanes, made now, on
no present evidence of need, when deferring that ruling to Account /1 (the
round whose new heads actually require a mint) loses none of benefits 1–4:
all four arrive with the /1 mint for the heads that need them, under a
commission that can weigh them against a then-real workload. What C would
add *today* is those benefits for seven heads whose accounts the audited
native engines already lawfully produce — a real but modest gain, priced at
a third machine, an unaudited grammar, and a premature ruling.

**Conclusion on C, under the honest comparison:** still not recommended
now — but for the priced reasons above, not because it buys nothing.

### Candidate D — Deferred hybrid successor

Keeps current native authorities (Candidate B as the implemented core) and
**specifies — but does not implement —** the governed Account-owned path for
later heads.

| Dimension | Candidate D |
|---|---|
| Accepted object domain | B's action-door domain; inspector union of **exactly five members, immutable** (contract I.8: S1 receipt, S1 refusal, S2 receipt, S2 refusal, composite pre-delegation/protocol refusal — every member reachable in /0). The /1 successor introduces **its own distinct inspector** at its own public address, with its own schema and separately enumerated Account-owned completed-account and retained-refusal branches (contract II.2/II.5b; R2 Section B) — the /0 inspector, its function identity, schema, and domain are never extended. |
| Expansion vs read | As B. |
| Account / refusal owner | Native providers today, by law; Account-owned authority for future heads, specified in the conditional contract and activated only by the governed Account /1 commission. |
| Term boundary | As B today; the Account-owned grammar contract for /1 is returned now (`TERM-GRAMMAR-DECISION.md`), with the pinned-codec candidate already eliminated on today's evidence so /1 does not re-litigate it. |
| Canonical representation | As B; the /1 successor's own record schemas are declared in contract II.5/II.5b, under /1's own schema identity — never inside /0's. |
| Identity/version bindings | As B; plus the **versioned coexistence law** (contract II.1b, adjudication Section C): the /0 manifest is immutable; /1 introduces a distinct manifest identity/version and request species; a /0 request presented to a /1 door fails **before invocation** as `incompatible-account-version` or `wrong-request-species`, while a /0 request at the unchanged /0 door may remain valid under /0's closed law. No /1 movement reaches into /0. |
| Image-local vs durable | As B. |
| Failure jurisdiction | As B; the /1 mint's jurisdiction is part of the conditional contract. |
| Dynamic-extension risk | As B. Nothing about /1 is a /0 code branch (F7; R1 Section A; R2 Section B): the /0 package's union has exactly the five reachable members of contract I.8 and is immutable; the /1 successor ships its own inspector with its own separately enumerated branches (II.2/II.5b) under owner governance — not a registry, not an extension of /0, and not an unfireable branch shipping untested. |
| Predecessor closure impact | Zero today; /1's supersession-or-dual-authority decision is **explicitly docketed** for the /1 opening ruling rather than silently deferred. |
| Supersession / compatibility / retirement standing | None today (B's table). The /0 contract **binds Account /1** to adjudicate, in its opening ruling, exactly one of: (i) explicit supersession of native account-minting for all heads, or (ii) explicitly-labelled dual authority (native engines account for the seven, Account mint accounts for the new), with the split carried on every record's species tag. Silent split-brain is forbidden by the contract; *labelled* split authority is a legal /1 outcome. |
| Load/integration impact | As B. |
| Exact future Surface /3 lifecycle | Complete — the seven literal steps are made true in `SURFACE-3-LIFECYCLE.md` under this lineage. |
| R4 accretion survival | As B's implemented core, plus the successor law that prevents the /1-time fork from arriving lawless. |

**On the commission's warning that D "must not hide a permanently mixed
authority model behind one pretty printer":** D as specified here does not
hide it — it *dockets* it. The mixed model, if /1 chooses it, is carried on
the face of every canonical record (exact provider/species tag, mandatory),
adjudicated by an owner ruling, and reversible by a later supersession
ruling. The failure the commission names is *concealment*; the cure is the
tag and the docketed decision, not the pretence that one mint must exist
before its first head does.

**On one-inspector coherence (rewritten in R2, Section B):** "one
inspector" is a **per-version** law: each version has exactly one
authoritative pure projection at exactly one public address — /0's
`INSPECT-ACCOUNT` over its immutable five-member union; /1's
`INSPECT-EXPANSION` over its own separately enumerated domain. Under
labelled dual authority **both addresses remain explicit**; any canonical
alias, supersession, or rebinding of one over the other requires a later
owner adoption ruling and cannot occur through registration or
implication. The R1 sentence that had /1's species "enter that union by
schema version movement" is deleted — nothing enters /0's union, ever.

---

## 3. The two STOP cells — a named claim limitation, adjudicated

**The fact (E2), now RATIFIED by owner adjudication Locked Ruling 2.**
`DERIVE-CASE` and `DERIVE/2-CASE` under `:macroexpand` expand (via
`CL:HANDLER-CASE`) into host trees with 3 shared conses and 13 uninterned
symbols. Surface /1's own grammar refuses the expanded term:
`EXPANDED-TERM-SHARED-STRUCTURE`, phase `PERFORM`, upstream
`TermGrammar / SHARED-OR-CIRCULAR-STRUCTURE / term-encode`, retained as a
native refusal record. No receipt exists for those two cells. The native
machine itself refuses; this is not a composite defect and not a probe
artifact. The ruling's words: *both remain admitted and requestable; their
native retained refusal, carrying `invoked-no-completion-account` standing,
is the truthful outcome; no completed account exists for either; no
operation or head is removed.*

**What the composite lawfully claims for those two cells.** The commission
forbids silently dropping a head or weakening one operation. The composite
does neither:

- Both heads remain in the manifest; both operations remain requestable for
  them. Nothing is dropped and nothing is weakened.
- The lawful account-domain outcome for those two cells is the **retained
  native protocol refusal**, a first-class artifact of the composite's
  inspection domain (its fields are the `refusal-record-stored` rows of
  `READER-PROVENANCE-MATRIX.tsv`). The refusal's own phase (`PERFORM`) and
  upstream stage (`term-encode`) carry the fact that **invocation occurred
  and representation failed** — the `invoked-no-completion-account` standing,
  derived from stored refusal fields and labelled as derived.
- The composite's claim table therefore reads, per cell: *an account where
  the native machine completes; a retained, inspectable refusal where the
  native machine refuses.* It never claims "expansion accounts for all seven
  heads under both operations." That sentence is false on this evidence and
  is **forbidden** in every document of this lane.

**Why no lineage repairs the cells.** Under any grammar of the commissioned
shape — interned symbols, integers, strings, proper lists, `NIL`, no sharing,
no cycles — the same expansions refuse for the same two reasons. Representing
them would require gensym-identity and DAG/sharing laws: a materially larger
grammar with its own aliasing and equality jurisprudence, which this
commission has not commissioned and this docket does not recommend
smuggling in as a "repair." The cells are the truth-telling boundary of the
account domain, and the composite reports them as such.

---

## 4. The governing promise — the one point of genuine interpretive pressure

Read strictly as a count — *no third receipt machine may ever exist* — the
promise is unsatisfiable by every candidate: the native manifests are closed
by their own laws (measured: S1's `KNOWN-SURFACE-CONSTRUCTS` and S2's
`KNOWN-SURFACE2-CONSTRUCTS` are closed enumerations; both lanes are closed
and unamendable), so the first new head ever to need accounting requires a
machine that is not S1 and not S2 — a third machine — no matter who owns it.
Candidate C *is* that third machine today; Candidate D schedules it; A and B
refuse it and thereby leave new heads unaccounted, which only re-creates the
cloning pressure inside Surface /3.

Read as an **ownership** claim — *the machine that accounts for new heads
must be Account-owned and owner-governed, never Surface /3's own* — the
promise is satisfiable, and the commission's own lifecycle section already
adopts this reading in so many words: step 3, "Surface /3 … owns no request,
occurrence, receipt, term-codec, or expansion-account engine"; step 4, "a
separately commissioned Surface Account /1 successor adds the exact new
heads." This docket therefore does **not** resolve a contradiction by
grammatical compression; it follows the adjudication the commission's own
lifecycle text has already made, and says so out loud.

**Conditional statement, for the owner's eyes:** if the owner intended the
strict-count reading, then no candidate satisfies the promise and the honest
verdict would be `GOVERNING PROMISE REQUIRES REVISION`. The recommendation
below is made under the ownership reading, on the stated ground that the
commission's own lifecycle adopts it.

---

## 5. Elimination and recommendation

- **A alone** — eliminated: no front door; no future lifecycle; leaves the
  cloning pressure standing (§2-A).
- **C now** — not recommended, on the honest comparison (§2-C, as rewritten
  in R1): its four genuine benefits (mint-time stored identities,
  manifest-bound records, uniform schema/refusal law, potential fresh
  temporal occurrence identity) are real and recorded — and they do not
  presently justify a third live account authority, a new grammar with its
  audit burden re-purchased from zero, or a premature supersession ruling
  over two functioning closed engines. Every one of the four benefits
  arrives with the governed /1 mint for the heads that will actually need
  them; C's distinctive offer is those benefits *today*, for seven heads
  whose accounts the audited natives already produce, at that triple price.
- **B alone** — eliminated as incomplete: correct core, but objective item 6
  (the future-version lifecycle) cannot be returned by a lineage that is
  silent about the successor mechanism.
- **D** — recommended: B as the implemented core, plus the returned successor
  law (conditional mint contract, the versioned coexistence law — /0
  declarations never move; /1 introduces distinct declarations — fail-closed
  /0 requests at the /1 door, the /1
  supersession-or-labelled-dual-authority docket).

## 6. Verdict

**`NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED`**

One composite public front door — two action doors and one inspector — over
the exact seven-head union, delegating every action to exactly one native
engine chosen by a closed manifest, **constructing only sealed routing
requests and sealed pre-delegation refusal records while minting no
completed receipt, occurrence, expansion-account identity, or competing
native-domain identity** (the pure-projection law, contract I.0), with the
native receipt or retained native refusal as the account-domain artifact;
**plus** the complete, returned-not-implemented successor law by which a
governed Surface Account /1 adds new heads under Account-owned authority,
so that Surface /3 never owns an engine.

**The future lifecycle this verdict requires** is returned in full in
`SURFACE-3-LIFECYCLE.md` and in `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`
Part II (the conditional Account-owned mint contract for /1). Honest sizing,
amended post-review (F6): of the seven literal steps, **five are made true
by the design or by already-owner-owned procedure** (steps 1, 5, 7
structural; 2, 4 procedural), and **two — step 3's positive half and
step 6 — are governance-dependent**: the design enables them and removes
every mechanical alternative, but their truth requires future commission
text no design can compel. `SURFACE-3-LIFECYCLE.md` labels each step by
mechanism class.

**The supersession/retirement proof this verdict requires:** nothing is
superseded or retired by this lineage today. Per native door, stated
explicitly as the commission demands:

| Native door | Still callable? | Gates retained? | New work directed where? | Owner ruling required? |
|---|---|---|---|---|
| `LISP-PLUS-SURFACE1` doors (`REQUEST-EXPANSION`, `PERFORM-EXPANSION`, `TRY-*`) | Yes — closed bytes untouched, public API unchanged | Yes — all existing gates, floors, and errata standing retained | New callers: the composite front door (convention, not retirement). New heads: the governed Account /1 successor | None for /0. Account /1's opening ruling must adjudicate supersession vs labelled dual authority |
| `LISP-PLUS-SURFACE2` doors (same four, plus `VERIFY-RECEIPT`) | Yes — same | Yes — same; Erratum 0.2 closure standing unchanged | Same | Same |

"Superseded" and "retired" appear nowhere in the /0 contract as live
standings; they are reserved words the /1 ruling may or may not mint. **Any
eventual canonical-front-door supersession is an explicit owner adoption
ruling — never mutable registration or silent rebinding** (coexistence law,
contract II.1b clause 5), and the R4 plan now requires that adoption ruling
be sought rather than left implicit (`R4-SURVIVAL-PLAN.md` §7, per
adjudication Section G).

## 6b. The provenance-vocabulary finding — RULED (Locked Ruling 5)

The R0 `OUT-OF-VOCABULARY` finding has been **adjudicated by the owner**:
the provenance vocabulary is extended with five first-class labels —
`request-stored`, `refusal-record-stored`, `condition-stored-reference`
(the `EXPANSION-CONDITION-REFUSAL` rows: the carrying relation is borne by
the condition, not the refusal record), `provider-recomputation`,
`provider-derived-projection`. The matrices now carry them bare, with one
historical note that they originated as flags. The census is described as
**25 classified TSV rows, never "25 atomic facts"**, and the matrix
preserves which rows were value-exercised versus merely enumerated. Full
application: `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 and
`CARTOGRAPHY-NOTES.md` §10. None of the 25 rows is `receipt-stored`, under
this or any ruling.

## 7. What this verdict does not claim

Not implemented, not adopted, not frozen, not governing, not merged, not
published, not closed; Surface /3 not opened. No claim of authenticity,
semantic preservation, correctness, hygiene, portability, replayability,
complete lineage, or general determinism — an account records that one exact
source term was presented to one named operation and yielded one exact
expansion on one occurrence, and the two STOP cells show the domain telling
the truth about its own boundary. The measurements cited are one session's,
one host's, same-family-checked only.

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
