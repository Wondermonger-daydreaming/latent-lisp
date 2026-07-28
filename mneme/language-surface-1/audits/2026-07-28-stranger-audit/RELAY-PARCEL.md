# RELAY PARCEL — Language Surface /1 stranger audit, returned 2026-07-28

*Self-contained. Assumes the reader knows nothing about this laboratory, this
subject, or this audit. Everything cited here is published and executable; the
record of truth is named in §7 — quote from it, never from a paraphrase of it,
including this one.*

*Prepared by Claude Fable 5 (the audit chair), 2026-07-28, at the lab owner's
request, after the return was fixed, published, and compared against its
preregistration — in that order.*

---

## 1. WHAT THE SUBJECT IS

**Language Surface /1, Candidate /0 through Errata 0.2** — a Common Lisp layer
(~987 lines + tests) in the lab's Lisp+ project whose one job is stated in its
own epigraph: *"The expansion leaves a receipt. An expansion receipt says what
form became what other form. It is silent about whether the transformation
preserves meaning."*

Mechanically: **Door 1** (`REQUEST-EXPANSION`) encodes a host source form into
an inert canonical datum under a declared term grammar (SYMBOL / INTEGER /
STRING / LIST, nothing else) and mints an immutable request. **Door 2**
(`PERFORM-EXPANSION`) reconstructs a fresh host form from that datum, performs
a named host macroexpansion against a closed five-entry construct table, and
mints an occurrence and a receipt whose two sides are canonical data. A receipt
is declared to be *an account, not an authentication*.

The subject had already been wrong twice in one day — two errata, each defect
living in the repair of the previous one, both found by outside readings, both
times involving a mislabelled test read as green by its author. The audit was
commissioned against a frozen target with that history fully disclosed.

```
frozen at        lab commit  65782d5c4ac9c5ffecff4cf86bdb0501a7480639
subject subtree  9b3436182c0e40c56987c77385608aef9d1f04f5
packet           surface1-frozen-target-65782d5c.tar.gz · sha256 affce17d… · 303972 B
                 manifest 63945091… · 48 entries · built by git archive
runtime          SBCL 2.4.6 · grammar v3 · procedure v3 · policy v1
```

A preregistration (14 falsifiers, 4 interpretation bands, 5 run-VOID
conditions) was frozen **outside the repository** before any auditor was
approached; only its SHA-256 was committed
(`8fe0ee39e39a90a2dab654f655154f853f9a9ea3e68d1e77396f5f5a4f5091c7`, 11350
bytes). The auditors never read it; it was disclosed and compared only after
the return was committed.

## 2. WHO AUDITED, AND THE HONEST TIER LABEL

Claude Fable 5 in the chair (custody, execution gate, crux probes, independent
verification of every headline, the return), with three subagents in fresh
contexts and disjoint jurisdictions: **PERSCRUTATOR** (Fable 5 — adversarial
verification and independent hunt), **TABULARIUS** (Opus 5 — claim ledger and
test-label sweep), **FOSSOR** (Opus 5 — refusal reachability, harness teeth,
temporal binding). Their raw reports are filed byte-exact beside the return.

**Cap that rides every citation of this audit: it is a fresh-context,
fresh-instance CLAUDE-FAMILY audit — NOT a fresh-weights audit.** The subject's
author is also Claude-family. This tier cannot catch a Claude-wide blind spot;
the fresh-weights tier (another model family, or a human) remains open and
owed. This label was fixed in the return before any verdict, as the freeze
record required.

## 3. WHAT WAS DONE

1. **Custody.** Every declared identity recomputed: prereg hash/bytes, commit,
   subtree, archive, manifest (48/48, verified *before* anything ran),
   declaration digest, path safety, byte-identity of the packet subtree against
   the repository at the frozen commit. Three transcription errors found in the
   commission/freeze *prose* (a one-hex-character error in the brief's commit
   hash; a 65-character "SHA-256"; "three pairs" of duplicated transcripts
   where the manifest holds four) — none in the frozen artifacts; none voiding.
2. **Stranger execution gate.** Fresh extraction outside the lab checkout;
   SBCL operation-checked; subject label bound via `SURFACE1_SUBJECT_LABEL`.
   All five baselines reproduced exactly: 115/0, 8/0, 24/0,
   `verdicts=6 expected=6 confirmed=0`, `verdicts=4 expected=4 confirmed=0`,
   runner exit 0. **Run NOT VOID.**
3. **Probes.** ~30 executable probes across four hands: the §5 boundary battery
   (symbol/package reincarnation between the doors), reachability attacks on
   the two "unreachable" classifications, a totality battery over host types,
   hostile-structure batteries, receipt identity-composition checks from the
   reader's side, planted-fault teeth checks, runner-mutation teeth checks in
   scratch copies, temporal-binding and evidence-identity probes. Every
   headline finding was re-executed or independently re-derived by the chair —
   nothing below rests on a subagent's summary alone.
4. **Return → publication → prereg comparison, in that order.** The return was
   committed (`07be7374`) with the prereg still unread; the prereg was then
   read for the first time, disclosed, and compared (`135b834d`). The hash
   proves it sat unchanged throughout.

## 4. RESULTS

### The one-sentence result

**On every route the audit could construct, the receipts are truthful — no
route mints a receipt whose account diverges from the expansion performed —
but the layer's account of ITSELF fails in nine confirmed ways**, and the
recommendation is:

```
AUDIT-CLOSED — DEFECTS FOUND, REPAIR REQUIRED
```

### The nine confirmed defects (every one with an executable witness)

| # | finding | class |
|---|---------|-------|
| D1 | `:EXPANDED-NODES-EXCEEDED`, catalogued **"MEASURED UNREACHABLE UNDER THIS POLICY"** and defended in five places, fires from the public API: `DEFINE-JUDGMENT-SCHEMA` amplifies nodes ~4×, and the catalogue note's own cited gate order (nodes before octets) contradicts its conclusion. Two green self-checks (M4/M6) certify the false claim. | NOVEL |
| D2 | The public API — including `TRY-REQUEST-EXPANSION`, the *non-signalling* twin — **crashes with an uncaught host `TYPE-ERROR`** on `complex`, vectors, and arrays, types the boundary law explicitly names as cleanly refused. `TYPE-OF` returns a compound (cons) specifier for these and the refusal-describing helper calls `STRING` on it. | NOVEL instance of a disclosed class |
| D3 | **`ROUND-TRIP-MISMATCH` is reachable by public input** — (a) `rename-package` keeping the old name as a nickname between the doors; (b) with **zero mutation**, a package-local nickname in the caller's ambient `*PACKAGE*` at Door-2 time. Defeats Errata 0.2 §2's *"decode is injective … so NO PUBLIC INPUT CAN REACH the round-trip mismatch — the earlier, more precise guard always fires first."* The proof proved the wrong property: the gate tests `encode∘decode = id`, which fails whenever name→package designation is non-canonical at decode time. **The gate held on every route — fail-closed, now field-proven.** | claim disclosed as suspect; both mechanisms NOVEL |
| D4 | **The evidence runner is still fail-open for three of five instruments**: the selftest (115 of the 147 checks) truncated at a clean form boundary runs 35 checks — or zero, printing no summary at all — and the runner exits 0. Only the two reproduction instruments have a required canonical result line; those fail closed under every mutation tried, including a genuine subject regression. | NOVEL |
| D5 | The **public** `ENCODE-TERM` still exhausts the control stack on deep acyclic input (bisected: ok 25222, dead 25375), and public `DECODE-TERM` dies with a **fatal, uncatchable SBCL abort** on a deep hand-built datum — the Errata 0.1 repair moved the "public function turning hostile input into a host accident" from cyclic to deep input; it did not remove it. Unreachable through the doors (ceiling 48). | NOVEL instance of a disclosed class |
| D6 | **Captured evidence cannot prove which bytes it measured**: the subject label is `git rev-parse HEAD`, so two materially different subjects (one-line behavioural change, no version bump) produce byte-identical transcripts under the same label. No digest of the subject appears in any capture. | NOVEL, adjacent to disclosed |
| D7 | The `:PROCEDURE-VERSION-MISMATCH` alarm is **structurally vacuous** in production: the receipt stores no version, so the mint gate compares the package with itself. Receipt version accessors answer from the *live* package — an old receipt's reported version silently moved 3→4 under one redefinition while its identity octets stayed frozen. Identity-level version binding holds; accessor-level binding does not exist. | NOVEL |
| D8 | **The mislabelled-check class is a population, not a third instance**: a census check comparing a variable to its own defining expression (while the "abbreviation collision" check its section advertises exists nowhere); `encode-term` of `'nil` compared with `encode-term` of `'()` — one object twice; a hand-written slot literal stale by two receipt fields; a coverage claim ("nothing else is left uncovered") false because `:source-term-shared-structure` is claimed exercised and exercised nowhere; and more. | disclosed CLASS, new instances |
| D9 | The RETURN document's banner *"Two claims below are FALSE as written and are marked"* is itself false — at least two further claims are false post-errata and unmarked; check-number citations drifted; a field list labelled "exhaustively" omits an exported accessor. | disclosed class, new instances |

### What held (the clean findings)

The account mechanism itself: receipt identities recompute from stored datums
using public CD/0 API alone; the request→occurrence→receipt identity chain
threads; the expanded form handed back re-encodes to the stored datum; caller
mutation after Door 1 cannot reach the stored datum; identity values are
octets, never hex. All 20 refusal-catalogue entries fire with code, phase, and
class matching (except D1's classification). Hostile structures through the
doors refuse fast, always. The measured depth-edge claims (63/64, ceiling 48)
reproduce exactly in stranger hands, twice independently. 75 exports declared =
75 live; every check count exact. Surface /0's own refusal escapes unwrapped
with nothing minted. The reasoned unreachability argument for the two *deleted*
codes is sound — in pointed contrast to the asserted-as-measured one (D1).

### The §5 boundary question, adjudicated NOT a defect

Symbol reincarnation between the doors (unintern + re-intern same name — even
renaming a whole package away and building a fresh one under its name) crosses
Door 2 as **the same term**; an EQ-identical symbol whose package was merely
renamed is **refused**. Acceptance and refusal both track the *term*
(package-name + symbol-name), never the host object — exactly what the declared
grammar promises, enforced coherently in both directions. Two hands
independently grep-audited every document for a host-object-identity promise:
none exists. `"exact source form"` means exact **term under the declared
grammar**.

### Preregistration comparison (performed after publication)

**Band A — one or more confirmed defects — the preregistered EXPECTED
outcome.** 8 of 14 falsifiers held; **F3** (decode injectivity/determinism),
**F7** (round-trip-mismatch unreachability), **F8** (expanded-nodes
unreachability), **F12** (every code exercised or honestly classified), and
**F14** (labels match code) fell; F13 (runner fails closed) split — letter
held, spirit fell. The author's on-record expectation (Band A, F7 first, F14
second) was accurate; honesty cap: the F7 *direction* was disclosed in the
commission, so the audit's contribution there is the two concrete mechanisms,
not the prediction's confirmation. F8's fall was nowhere predicted. No
run-VOID condition held.

## 5. CONCLUSIONS

1. **The central proposition survives at the granularity it claims.** A Lisp+
   macro expansion *can* become an inspectable structural occurrence whose
   receipt says exactly what term became what other term, silent on meaning —
   the audit could not make a receipt lie.
2. **Where the layer fails is in second-order claims**: reachability
   classifications asserted as measured (D1, D3), robustness of the public
   grammar functions (D2, D5), the harness that certifies its greens (D4), the
   evidence's self-identification (D6), and checks that cannot fail (D8, D9).
   A recurring shape: **the conclusion argued rather than executed is the one
   that falls** — both "unreachable" classifications rested on arguments; both
   fell to ~15-line witnesses; the one *reasoned* unreachability claim that was
   actually sound (the deleted codes) was derived from structure, not
   arithmetic.
3. **Fail-closed engineering paid for itself.** Every newly-opened route ends
   in a refusal or a crash, never in a false account. The round-trip gate its
   own author classified as unreachable defence-in-depth is the thing that
   caught the unforeseen routes.
4. **Repairs are owed but not designed here** (the audit's jurisdiction ended
   at the finding): an Errata 0.3 against the frozen target, with
   grammar-version consequences under the subject's own rule that the decode
   relation's sanctioned description is part of the grammar.

## 6. WHAT THIS PARCEL DOES NOT ESTABLISH — read before citing

- **Not** that the layer is correct, safe, complete, or adoptable. Standing is
  unchanged: *candidate · not adopted · not frozen as language law · on no
  governing floor.*
- **Not** a fresh-weights verdict (§2). If you, reader, are a Claude-family
  mind: your agreement with this parcel's reasoning is **shared-root** and may
  not be banked as corroboration; only a refutation, or a finding this parcel
  does not contain, carries independent weight.
- **Not** that any expansion means what its source means — nothing can
  establish that here; that is the layer's whole point.
- **Not** a discharge of any other layer's audit debt, nor of the Surface /0
  erratum still owed.

## 7. THE RECORD OF TRUTH

All public at `github.com/Wondermonger-daydreaming/latent-lisp` under
`mneme/language-surface-1/audits/2026-07-28-stranger-audit/` (lab tree:
`experiments/latent-lisp/mneme/language-surface-1/audits/2026-07-28-stranger-audit/`):

```
STRANGER-AUDIT-RETURN.md        the return — custody report, D1–D9 with
                                witnesses, falsified allegations, clean
                                findings, claim-by-claim disposition,
                                recommendation                      [quote from HERE]
PREREGISTRATION-disclosed.md    the prereg plaintext (hash-verified 8fe0ee39…)
PREREG-COMPARISON.md            band adjudication, falsifier disposition,
                                run-VOID check
findings/PERSCRUTATOR.md        the three subagent reports, byte-exact
findings/TABULARIUS.md
findings/FOSSOR.md
probes/                         every probe (.lisp) and raw transcript, four hands
```

Commits: `07be7374` (return, prereg unread), `135b834d` (disclosure +
comparison). Frozen packet and prereg original remain in the off-repository
freezer (`~/freezer/surface1-stranger-audit-2026-07-28/`).

**Handling note for relayers:** this is a *results* parcel. If you want a
fresh mind's pre-committed bands on anything downstream of it (the Errata 0.3,
a re-audit), send that request in a **separate artifact, before** this one —
results and pre-commitment requests must never travel together.

---

*— Claude Fable 5, audit chair, 2026-07-28. Subagent spend: ~763k tokens
across PERSCRUTATOR (Fable 5), TABULARIUS and FOSSOR (Opus 5).*
