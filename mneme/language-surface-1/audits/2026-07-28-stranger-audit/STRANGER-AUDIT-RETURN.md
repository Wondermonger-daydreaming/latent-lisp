# LANGUAGE SURFACE /1 — CANDIDATE /0 THROUGH ERRATA 0.2 — STRANGER AUDIT RETURN

```
subject             Language Surface /1, Candidate /0 through Errata 0.2
frozen at           lab commit 65782d5c4ac9c5ffecff4cf86bdb0501a7480639
subject subtree     9b3436182c0e40c56987c77385608aef9d1f04f5
                    experiments/latent-lisp/mneme/language-surface-1
packet              surface1-frozen-target-65782d5c.tar.gz · affce17d… · 303972 bytes
runtime             SBCL 2.4.6 (operation-checked before any CL ran)
audit date          2026-07-28
recommendation      AUDIT-CLOSED — DEFECTS FOUND, REPAIR REQUIRED
```

**Auditor tier, labelled before any verdict, as the freeze record requires:**
this audit was performed by **Claude-family models** — Claude Fable 5 in the
chair, with one Fable and two Opus 5 subagents (PERSCRUTATOR, TABULARIUS,
FOSSOR), each in a fresh context with independent jurisdictions. It is a
**fresh-context / fresh-instance audit, NOT a fresh-weights audit.** It cannot
catch a Claude-wide blind spot. The fresh-weights tier remains open.

**The preregistration was not read.** Its identity was recomputed before work
began (SHA-256 `8fe0ee39e39a90a2dab654f655154f853f9a9ea3e68d1e77396f5f5a4f5091c7`,
11350 bytes — matches the committed hash) and the plaintext stayed unread until
after this return was fixed. The comparison against its bands is filed
separately, after this document, and could not have shaped it.

**Verification discipline.** Every headline finding below was verified **by the
chair's own execution**, not banked from a subagent's summary: the chair re-ran
or independently re-derived D1, D2, D3, D7, and the tautology exhibits of D8,
and confirmed D4/D5/D6 mechanisms against the runner and implementation source.
All probes and raw transcripts are published beside this file
(`probes/`, `findings/` — the three subagent reports are filed byte-exact).

---

## 1. CUSTODY REPORT

All identities verified by execution in this session, in this order —
verification always **preceding** any run that could write:

| item | declared | verified |
|---|---|---|
| prereg SHA-256 / bytes | `8fe0ee39…091c7` / 11350 | **match** (plaintext unread) |
| lab repo at audit start | clean, HEAD `cd89b550` | **0 tracked modifications** |
| candidate commit | `65782d5c…` | **exists**; see transcription note |
| subject subtree | `9b3436182c0e40c56987c77385608aef9d1f04f5` | **match** (`git rev-parse 65782d5c:…/language-surface-1`) |
| archive digest / bytes | `affce17d…950c` / 303972 | **match** |
| manifest digest / entries | `63945091…b096` / 48 | **match**; `sha256sum -c` **48/48 OK** — in the freezer copy AND in a fresh extraction, both **before** any run |
| freeze declaration digest | `363a54ba…eeed11` | **match** |
| archive path safety | 0 symlinks, 0 absolute/traversal | **confirmed** |
| packet subtree vs repo at commit | byte-identical | **confirmed** (`diff -r`, clean) |
| five `package.lisp`, duplicated `RUN-*` basenames | exact-path manifest | **confirmed** — see count note |

**Custody observations (against the commission and freeze prose, not the
artifacts — none voids the run):**

1. **The commissioning brief carries two transcription errors.** It gives the
   candidate commit as `65782d5c4ac9c5ff`**`a`**`cff4cf86bdb0501a7480639` — no such
   object exists; the true hash (in both the committed freeze record and the
   freeze declaration) is `…ff`**`e`**`cff…`. It also gives the declaration digest
   with 65 hex characters (`…b6eee`**`e`**`d11`); the true 64-character digest is
   `…b6eeed11`. Both are prose retellings decaying within hours of the exact
   committed record — the defect class this lane already owns.
2. **The freeze declaration's basename count is off by one.** It says the packet
   carries "three pairs of identically named `RUN-*.txt`"; the manifest carries
   **four** pairs (`RUN-STUB-IMAGE`, `RUN-SELFTEST`, `RUN-EXITCODES`,
   `RUN-APPLICATION`, ×2 each).
3. **Running the packet invalidates two of its own manifest entries.** The gate
   rewrites all six `RUN-*.txt`; the two reproduction transcripts embed an
   absolute directory path and therefore cannot reproduce their frozen bytes
   outside the directory they were frozen from. The chair verified the manifest
   **before** running, so custody is intact — but a stranger who runs first and
   verifies second meets a 2-of-48 checksum failure with no note telling them
   whether it matters. The declaration should name the expected-to-change set.

**Stranger execution gate — PASSED, run NOT VOID.** Fresh extraction outside the
laboratory checkout, `SURFACE1_SUBJECT_LABEL="frozen 65782d5c"`:

```
surface1-selftest       115 / 0        stub-image fixture   8 / 0
de-expansione-testata    24 / 0        runner exit          0
REPRODUCTION-RESULT verdicts=6 expected=6 confirmed=0
REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0
```

All five custody baselines reproduce exactly.

---

## 2. CONFIRMED DEFECTS

Ordered by weight. For each: the smallest executable witness, preconditions,
observed result, the claim it defeats, the owning layer, disclosure status, and
what it invalidates. **None of these produces a false receipt.** Every route
found fails closed or crashes before minting; no route was found on which a
receipt's account diverges from the expansion performed.

### D1 · `:EXPANDED-NODES-EXCEEDED` is reachable from the public API — the exported "MEASURED UNREACHABLE" classification is false, and two green checks certify it

- **Witness:** `probes/TABULARIUS/probe-C.lisp` (chair re-run:
  `probes/CHAIR/probe-C-chair-rerun.txt`); independently
  `probes/FOSSOR/P2c…/P2d…` — two different premise types, same result.
- **Preconditions:** an image with Surface /1 and Surface /0 loaded. Nothing
  else — no internal symbol, no fault hook, no hand-built datum.
- **Observed (chair's own run):** `DEFINE-JUDGMENT-SCHEMA` with 2491 one-atom
  premises — source depth 4/48, nodes 5020/20000, octets 153334/262144, Door 1
  accepts — expands to 20002 nodes and Door 2 refuses
  **`:EXPANDED-NODES-EXCEEDED`**. At 2490 premises the octet ceiling fires
  instead; one premise later the "unreachable" code fires first. FOSSOR's
  independent construction (integer premises) fires it at N=2493 and everywhere
  up to at least N=5000.
- **Defeats (verbatim):** `surface1.lisp:204-213` — *"MEASURED UNREACHABLE UNDER
  THIS POLICY: the checks run depth -> nodes -> encode -> octets, and each term
  costs roughly 120 octets, so an expansion meets the 262144-octet ceiling at
  about 2000 nodes and can never approach 20000"*; `surface1.lisp:150-152`
  (*"another ceiling always fires first. Measured, not assumed"*); selftest
  **M4** and **M6** (green checks asserting the same); `RETURN:288-299`.
- **Why it failed, twice over:** (a) the order argument is backwards — the node
  check runs **before** encoding, so on the expanded side octets *cannot* fire
  first; the note's own source-side sentence ("the node check runs BEFORE
  encoding") applies verbatim to the expanded side and was not noticed;
  (b) the arithmetic is wrong — a term costs ~38–70 octets, not "roughly 120"
  (the tree's own `RUN-APPLICATION.txt` prints `One term costs 70 octets` in the
  same run the runner blesses), and `DEFINE-JUDGMENT-SCHEMA`'s **3.98–4.00×
  node amplification** was never measured — the application bisects only the
  1.00× construct. The reachable window is wide: everything from ~N=2491 to
  ~N=5120.
- **Owning layer:** the refusal catalogue — exported, machine-readable,
  explicitly contractual (*"A reader may branch on these; they are not prose"*).
- **Disclosure:** **NOVEL.** No document questions this classification; five
  restate it.
- **Invalidates:** the catalogue's reachability entry and note for this code;
  checks M4/M6 as evidence; `RETURN` §7's paragraph defending the
  classification. Not the guard itself (it works), not any receipt.

This is the mirror image of the false-affordance rule the layer itself declares
(`surface1.lisp:132-140`, codes no caller can reach were deleted): a code every
caller can reach, advertised as unreachable, certified green by the suite.

### D2 · The public API crashes with an uncaught host `TYPE-ERROR` on `complex`, vectors, and arrays — types the boundary law names as cleanly refused

- **Witness:** `probes/PERSCRUTATOR/CRASH.lisp` + `TOTAL.lisp`; chair
  verification `probes/CHAIR/probe-crash-verify.lisp` (transcript beside it).
- **Preconditions:** none beyond loading Surface /1. Public API only.
- **Observed (chair's own run):** `(try-request-expansion (list 'f (vector 1 2 3)) …)`
  → **uncaught `TYPE-ERROR`** escaping the *non-signalling twin*; same for
  `#C(1 2)` and a 2-D array; `#\a` control refuses cleanly with
  `:SOURCE-TERM-UNREPRESENTABLE / NO-TERM-KIND`.
- **Root cause:** `%describe-host-object` (`surface1.lisp:323-329`) does
  `(string (type-of object))`; `TYPE-OF` lawfully returns a **compound (cons)
  specifier** for these types — `(SIMPLE-VECTOR 3)`, `(COMPLEX (INTEGER 1 2))`
  — and `STRING` of a cons signals. The crash originates **inside the refusal
  machinery that was to describe the rejected object**; the designed refusal is
  never minted, and `try-request-expansion` (which catches only
  `expansion-refused`) leaks a raw host error.
- **Defeats (verbatim):** `package.lisp:129,157-162` — *"AND NOTHING ELSE IS
  REPRESENTABLE. Refused, each with its own code … ANY OTHER HOST TYPE —
  character, float, ratio, **complex, array**, pathname, structure, function…"*;
  `RETURN` §4(4) (*"every other host type"* refused); the non-signalling twin's
  contract (`surface1.lisp:742-747`); and the layer's own standard —
  *"a measurement that crashes … turns a designed refusal into a host
  accident"* (`surface1.lisp:508-512`).
- **Owning layer:** term grammar / refusal machinery.
- **Disclosure:** **NOVEL** instance of a disclosed *class* (Errata 0.1
  finding 2 closed the CAR-cycle host accident and declared the lesson learned).
  The documents assert the opposite for these exact named types.
- **Invalidates:** the boundary law's refusal guarantee for compound-`TYPE-OF`
  types; the twin's no-signal contract. Likely also reachable on the expanded
  side (a macro expanding to a vector literal); not exhibitable through the five
  closed constructs, so recorded as reasoned extension, not witness.

### D3 · `ROUND-TRIP-MISMATCH` is reachable through public inputs — by two mechanisms, one requiring no mutation at all

- **Witnesses:** `probes/CHAIR/probe-door-semantics.lisp` (B1, B2),
  `probes/CHAIR/probe-pln.lisp` (D1–D3); independently
  `probes/PERSCRUTATOR/H2.lisp`.
- **Preconditions:** standard Common Lisp package operations only.
- **Observed:**
  - **B1 (rename):** Door 1 on `(AUDIT-RHO::X)`; then `rename-package` keeping
    the old name as a **nickname**. Door 2 →
    `:SOURCE-NOT-RECONSTRUCTIBLE / upstream "ROUND-TRIP-MISMATCH"`. The
    home-package guard **passed** (same package object; only the canonical name
    moved). Without the nickname the earlier guard fires instead
    (`PACKAGE-ABSENT-IN-IMAGE`) — the boundary is exact.
  - **D1 (zero mutation):** the caller's ambient `*package*` at Door-2 time
    carries a **package-local nickname** shadowing the stored namespace. The
    identical request refuses under that ambient binding and crosses cleanly
    from a neutral package. No global state was touched.
- **Defeats (verbatim):** `LANGUAGE-SURFACE-1-ERRATA-0.2.md §2` — *"decode is
  injective for every admissible datum, so NO PUBLIC INPUT CAN REACH the
  round-trip mismatch — the earlier, more precise guard always fires first"*;
  the same claim at `surface1.lisp:196-201` (catalogue note: *"NO PUBLIC INPUT
  REACHES THIS … Proved live by planted fault only"*) and `:806-812`.
- **Mechanism of the error:** the proof proved the wrong property. Injectivity
  of decode is not what the gate tests; the gate tests whether decode is a
  **section of encode** (`encode∘decode = id`), and that fails whenever the
  namespace string's package-designation is non-canonical *at decode time*.
  Common Lisp makes name→package designation time-varying (`rename-package`)
  and context-varying (package-local nicknames). TABULARIUS additionally showed
  the injectivity premise itself is false on public `DECODE-TERM`'s accepted
  inputs (nickname-named and multi-segment namespace data decode without the
  symbol guard firing; `%SEG` silently discards extra segments —
  `probes/TABULARIUS/probe-E.lisp`).
- **Owning layer:** the declared grammar's decode relation (Errata 0.2 §5 rules
  decode part of the grammar).
- **Disclosure:** **the claim was disclosed as suspect** — the freeze
  declaration §5 named it most likely to be wrong. **Both mechanisms are
  novel**, and the second (ambient-`*package*` sensitivity of Door 2's outcome)
  is stated in no document.
- **Invalidates:** the reachability classification and the injectivity argument.
  Not the gate — the gate is *vindicated*: it caught, fail-closed, every route,
  and is now field-proven by public input rather than planted fault only.

### D4 · The evidence harness is still fail-open for three of its five instruments

- **Witness:** `probes/FOSSOR/teeth/` (T5–T11 transcripts, `SUMMARY.txt`);
  mechanism chair-confirmed against `run-surface1-candidate.sh:120-122`.
- **Observed:** in a working copy, the selftest truncated at a clean form
  boundary runs **35 of 115 checks** (or zero, with **no summary line at all**)
  and the runner **exits 0**; likewise the stub fixture and the application.
  Only the two reproduction instruments have a required canonical line; the
  other three are guarded by exit code alone, and a check that never ran never
  fails. Contrast: every mutation of the *reproduction* instruments — mid-form
  truncation, clean-boundary truncation, planted crash, renamed label, trailing
  space, nonzero-exit-with-line-present, and a genuine subject regression —
  **fails closed** (T1–T12).
- **Defeats:** the unscoped headline in the runner itself —
  `run-surface1-candidate.sh:50` *"THE GATE WAS FAIL-OPEN AND IS NOW
  FAIL-CLOSED"* — and, on the wide reading of "each instrument,"
  `ERRATA-0.2 §3` (*"Each instrument now emits one canonical machine-readable
  line … A truncated run, a renamed label, an early exit and a crash now all
  fail closed"*). On the narrow reading (the two reproductions), the §3 claim
  is true; the repair's **scope** was three instruments short either way, and
  the instrument left unguarded carries 115 of the 147 checks.
- **Disclosure:** **NOVEL** — Errata 0.2's own defect ("counting zero of a
  string is not evidence the string was ever going to be printed"), surviving
  in the three instruments the repair did not reach.
- **Invalidates:** the harness's fail-closed claim at tree scope. The cheap
  cure is the pattern already in the tree (canonical
  `SELFTEST-RESULT checks=115 …` lines, `grep -qxF`).

### D5 · The public term-grammar functions still turn hostile input into host accidents — by depth instead of by cycle; `DECODE-TERM`'s is a fatal image abort

- **Witness:** `probes/FOSSOR/P3e…/P3f…` (bisected: `ENCODE-TERM` ok at depth
  25222, control stack exhausted at 25375; `DECODE-TERM` on a hand-built
  40000-deep datum → *"fatal error … Control stack exhausted while
  pseudo-atomic"* — process death, `HANDLER-CASE` powerless).
- **Defeats (verbatim):** `surface1.lisp:365-373` — *"Doing it here rather than
  in the caller is what makes this PUBLIC function safe"* — and Errata 0.1 §2's
  closure of *"a public function turning hostile input into a host accident."*
  The repair moved the accident from cyclic to deep-acyclic input; it did not
  remove it. (`%shared-cons-count` — the repair itself — is the blowing frame:
  guarded against revisiting, not against depth.)
- **Size, stated honestly:** no door-minted object can reach either failure
  (the ceiling refuses at 48); this is a public-surface robustness defect
  against arbitrary input to the deliberately-public checking functions — the
  reader invited to "perform the reconstruction independently" can be handed a
  datum that kills the image. **Disclosure: NOVEL** instance of the disclosed
  class.

### D6 · Captured evidence cannot identify the subject it measured — the label binds to `git` HEAD, not to content

- **Witness:** `probes/FOSSOR/teeth/EV-*` — two materially different subjects
  (a one-line behavioural change touching no version integer) produce
  **byte-identical transcripts, both labelled `ff80b8f`**; convergently,
  TABULARIUS §E-2 (the `subject` line is `argv[2]` — an outside assertion) and
  §E-1/E-3 (the version triple identifies a *generation*, not a *tree*; no
  digest of the subject appears in any capture).
- **Defeats:** `run-surface1-candidate.sh:33-37` — *"Derived from the tree under
  test, never hard-coded to a past subject"* (`git rev-parse HEAD` answers
  "what was last committed," not "what is in these files" — and the runner's
  own packaging note *requires* running in a scratch copy, i.e. exactly where
  the label detaches from content); and it narrows `ERRATA-0.2 §4`'s *"derive
  their header and assert nothing"* (the versions are derived; the subject line
  is asserted).
- **Disclosure:** adjacent to disclosed (§4 fixed the hard-coded banner); the
  HEAD-vs-content gap and the dirty-tree witness are **novel**. The layer mints
  content-addressed identities all day and spends none of them on the one
  artifact that must say what it measured.

### D7 · The `:PROCEDURE-VERSION-MISMATCH` alarm is structurally vacuous, and version binding is by reference, not by value

- **Witness:** `probes/FOSSOR/P5-temporal.lisp`; chair's independent exhibit
  `probes/CHAIR/probe-receipt-composition.lisp` (E5); chair code-read of
  `%mint-receipt`.
- **Observed:** with the fault hook nil — i.e. always, in production — the mint
  gate compares `(expansion-procedure-version)` with itself; the receipt
  **stores no version**, so no second operand exists. After one redefinition
  (what loading a bumped `surface1.lisp` does to a live image), an old
  receipt's `EXPANSION-RECEIPT-PROCEDURE-VERSION` answer **moved 3→4** while
  its identity octets stayed frozen. No post-mint detector exists.
- **Adjudication:** identity-level binding **holds** (versions are baked into
  request/receipt identity octets at mint; chair-verified 10/10, reader-side,
  public CD/0 API only). Accessor-level binding **does not exist**, and
  `surface1.lisp:792-793` — *"a receipt cannot disagree with the package that
  minted it"* — is true only vacuously: the receipt has nothing to disagree
  with. The catalogue note for the alarm describes *"the receipt's procedure
  version"* — a value that does not exist in the receipt. **Disclosure: NOVEL.**
  Invalidates: the alarm's implied gate (the hook simulates a gate rather than
  exercising one); the comment's implied guarantee. The old version survives
  only as opaque, comparable-but-unreadable identity bytes.

### D8 · The self-certification battery contains tautologies, stale literals, and a false coverage claim — the disclosed mislabelled-check class, several new instances

Full inventory: `findings/TABULARIUS.md` §1 (F-1…F-17). Chair-verified by
direct read: **F-1** (the application's census check binds `n` to
`(hash-table-count *census*)` and compares it to `(hash-table-count *census*)`
— cannot fail — while the "abbreviation did not lie" discrimination check its
section advertises **exists nowhere in the file**); **F-3** (C3 compares
`(encode-term 'nil)` with `(encode-term '())` — one object, twice); **F-6**
(M2's *"Nothing else is left uncovered"* is false — `:source-term-shared-structure`
appears in the hand-written `*exercised*` list and in **no** producing check
anywhere in the tree; chair-verified by grep). Also: I4's hand-written slot
literal omits two receipt fields including the one Errata 0.1 added; M4/M6
certify D1's false claim; A5 label-says-equality/code-checks-plausible-shape;
G1/G4 one assertion counted twice; the Errata 0.1 `INTERN` repair reached one
instrument of five (latent, not live — every name resolves `:EXTERNAL` today).
**Disclosure: disclosed CLASS (both errata), new INSTANCES.** The freeze
declaration said the third mislabelled test was the thing to hunt; there is
not a third — there is a population.

### D9 · The RETURN's self-inventory is false in the current tree

`findings/TABULARIUS.md` §2, C-3/C-4/C-5: the banner *"Two claims below are
FALSE as written … marked ⚠ CORRECTED"* is itself false — at least two further
claims are false post-errata and unmarked (§4(8) still cites E11 for the
property Errata 0.1 ruled E11 never tested; §11 still says the grammar
*"unfolds shared structure"* — the pre-errata behaviour); application-check
citations are off by one and two; *"the receipt's fields, exhaustively"* omits
the exported `EXPANSION-RECEIPT-OCCURRENCE` in a live evidence artifact.
Because the banner states a **count**, each unmarked falsehood falsifies the
banner too. **Disclosure: disclosed class (documentation drift), new
instances, in the document whose job is inventorying the claims.**

---

## 3. FALSIFIED ALLEGATIONS — raised by this audit and defeated by it

Each shown with the reason it fails, not merely marked false:

1. **"Symbol reincarnation between the doors is a false edge"** — REFUTED.
   Same-name/same-package-name reincarnation (even of a whole package) crosses
   as the **same term**; an EQ-identical symbol whose package was merely
   renamed is **refused**. Acceptance and refusal both track the *term*, never
   the host object — exactly what the declared grammar (`SYMBOL value =
   identifier <package-name>/<symbol-name>`) and the documented
   fresh-reconstruction law promise. No document commits the layer to
   host-object identity (grep-audited by two hands independently). Witnesses:
   `probes/CHAIR/probe-door-semantics.lisp` A0–A2/C0–C2,
   `probes/PERSCRUTATOR/H1.lisp`/`H3.lisp`.
2. **"The two deleted codes (`:CONSTRUCT-PACKAGE-ABSENT` / `:CONSTRUCT-SYMBOL-ABSENT`)
   might be reachable after all"** — REFUTED. `%lookup-construct` keys on the
   head's home package; a matched head proves the package exists and holds the
   symbol; names are globally unique; no user code runs between reconstruction
   and resolution. The reasoned unreachability claim is sound
   (`findings/TABULARIUS.md` C-7) — in pointed contrast to the
   asserted-as-measured one (D1).
3. **"The reproduction gates might be fail-open under mutation"** — REFUTED
   eight ways (T1a–T12): truncation both kinds, planted crash, renamed label,
   trailing space, nonzero-exit-with-line, and a genuine regression (guard
   neutered → `confirmed=2` → exit 1). The fail-open is real only where the
   canonical-line pattern was never installed (D4).
4. **"A package-local nickname might route a WRONG symbol through to a minted
   receipt"** — REFUTED. Re-encoding writes the resolved symbol's home
   package's canonical name; for it to collide with the stored namespace the
   resolved package would have to *be* the named one. Every found route
   refuses; none mints.
5. **"The layer might wrap or convert a macro function's own refusal"** —
   REFUTED. Surface /0's `SURFACE-SYNTAX-REFUSED` escapes `perform-expansion`
   unwrapped, in the neighbour's condition class, with nothing minted
   (`probes/CHAIR/probe-escape-unwrapped.lisp`); a host `ARG-COUNT-ERROR`
   likewise (`probes/PERSCRUTATOR/EDGE.lisp`).

---

## 4. CLEAN FINDINGS — claims tested and held

- **The central account mechanism holds on every route tested.** Receipt
  identities recompute from stored datums (reader-side, public CD/0 API only);
  the request/occurrence/receipt identity chain threads; the expanded host form
  handed back re-encodes to the stored expanded datum; the context record says
  what the code does (null env supplied, none captured). Chair: 10/10
  (`probes/CHAIR/probe-receipt-composition.lisp`). PERSCRUTATOR: receipt-expanded
  equals an independent `macroexpand` of receipt-source on a live construct.
- **No third false edge found.** Encode-side injectivity in the representable
  domain holds; caller mutation after Door 1 cannot reach the stored datum
  (Errata 0.1's repair re-verified); identity values are octets, never hex.
- **All 20 catalogue entries fire with code, phase, and class matching** —
  including the three planted-fault alarms via their hooks and the stub-image
  code under a weaker stub than the disclosed fixture (FOSSOR §1). The
  reachability catalogue is sound everywhere except D1's entry.
- **Hostile structure through the doors: refused, fast, always** — spine
  cycles, CAR cycles, self-referential conses, dotted tails, shared subtrees,
  100k-element lists; sub-20ms, no hangs, no receipts, no non-refusal errors.
- **The measured depth claims reproduce exactly in stranger hands** — encode
  edge 63/64, ceiling 48 with 15 levels of real headroom, receipt minted at
  exactly 48 (FOSSOR §3, independent bisection).
- **75 declared exports = 75 live; 20/17/3 catalogue split; check counts
  115/24/8 all execute** (TABULARIUS §3, recounted).
- **The pre-errata evidence captures identify their subjects correctly by
  content** (version triples discriminate all four generations), and the
  before/after instrument pairing is genuinely API-agnostic — a careful piece
  of work that survives adversarial reading (TABULARIUS E-3/E-4).

---

## 5. JURISDICTIONAL OBSERVATIONS

1. **The §5 boundary, adjudicated: "exact source form" means exact TERM under
   the declared grammar, never exact host object** — and the layer enforces
   that meaning coherently in both directions (the reincarnated stranger is
   accepted; the renamed original is refused). The one blemish: the
   round-trip refusal's detail string says *"the FORM that would have been
   expanded is NOT the form the account names"* — in the rename witness the
   form is EQ-identical to the original and only the *term* drifted. The prose
   conflates, one register down, the two things this audit was asked to keep
   distinct.
2. **Door 2's outcome depends on the caller's ambient `*package*`** (via
   package-local nicknames in `FIND-PACKAGE`) — reconstruction is a function of
   (datum, image, **dynamic context**), which no document states. Fail-closed
   today; worth stating as a property.
3. **Public `DECODE-TERM` accepts data outside `ENCODE-TERM`'s image**
   (nickname namespaces; multi-segment namespaces silently truncated by
   `%SEG`) — the published checking function is more permissive than the
   grammar it checks, non-injectively.
4. **A CAR-position cycle lands under `:SOURCE-DEPTH-EXCEEDED`** with detail
   *"host depth 51 exceeds ceiling 48"* — a budget-saturation constant reported
   as a measurement of a form with no finite depth, and the cycle is invisible
   in the refusal (no upstream reason). Imprecision, not falsehood.
5. **Temporal binding is identity-level only.** A receipt's minting versions
   survive as unreadable identity octets; nothing can *report* them
   post-mint, and nothing detects drift. If the lane wants receipts that can
   testify to their minting versions, the value must be stored, not referenced.
6. **Dependency-layer observations** (out of scope, recorded as welcome):
   none found rising to a defect; CD/0's decode-side max-depth behaviour is
   what the subject's own depth-ceiling section says it is.
7. **Unverifiable-from-packet claims** (TABULARIUS C-12) — floor counts,
   `verify-all`, cross-layer `git diff` — were checked by the chair against
   the laboratory repository where possible: the subtree byte-identity and
   commit identities hold; the floors were not re-run (out of audit scope).

---

## 6. CLAIM-BY-CLAIM DISPOSITION (governing claims)

The full ledger is `findings/TABULARIUS.md` §2; this table is the
chair-adjudicated roll-up.

| claim (location) | disposition |
|---|---|
| Receipt = truthful account of source-term → expanded-term, silent on meaning (package.lisp §1, thesis) | **HOLDS** on every route tested (term granularity; see §5.1) |
| "This exact source form … produced this exact expanded form" (package.lisp:19) | **HOLDS at term/datum granularity**; host-object reading never promised |
| The ten NOT-established disclaimers (package.lisp:30-42) | **HOLD** (nothing observed contradicts any) |
| Loads CD/0 only; no foreign package named (package.lisp §2) | **HOLDS** (verified by read; construct table is strings) |
| Catches nothing from the macro function (package.lisp §3) | **HOLDS** (two independent witnesses) |
| Caller's tree read exactly once; no path from caller object to Door 2 (Errata 0.1) | **HOLDS** on routes tested |
| Round-trip gate enforced before expansion (Errata 0.2 §2, mechanism) | **HOLDS** — and is now field-proven by public input |
| "No public input can reach ROUND-TRIP-MISMATCH; decode injective; earlier guard always first" (Errata 0.2 §2; catalogue) | **FALSE** — D3 |
| `:expanded-nodes-exceeded` "MEASURED UNREACHABLE" (catalogue; M4/M6; RETURN §7) | **FALSE** — D1 |
| "Every other host type refused, each with its own code" (package.lisp; RETURN §4) | **FALSE** for compound-`TYPE-OF` types — D2 |
| "What makes this PUBLIC function safe" (encode-term docstring) | **FALSE** unqualified — D5 |
| Runner fail-open fixed; "truncated/renamed/early-exit/crash all fail" (Errata 0.2 §3) | **TRUE for the two reproductions; the other three instruments remain fail-open** — D4 |
| Instruments "derive their header and assert nothing" (Errata 0.2 §4) | **OVERSTATED by one field** — the subject label is asserted or HEAD-stale — D6 |
| "A receipt cannot disagree with the package that minted it" (surface1.lisp:792) | **VACUOUSLY TRUE**; the implied guarantee does not exist — D7 |
| "Two claims below are FALSE and are marked" (RETURN banner) | **FALSE** — D9 |
| Deleted codes unreachable (surface1.lisp:132-140) | **TRUE** (reasoned claim verified) |
| Depth edge 63/64, ceiling 48 measured (package.lisp §depth) | **TRUE** (reproduced independently twice) |
| 75 exports; 20/17/3; 147 checks (Errata 0.2 §7) | **TRUE** (recounted) |
| Evidence captures distinguish generations by content (Errata 0.2 §4) | **TRUE at generation grain; no content binding at tree grain** — D6 |

---

## 7. THE GOVERNING QUESTION, ANSWERED

> *Does Surface /1 truthfully account for the exact grammar-term presented at
> Door 1 becoming the exact grammar-term emitted by macroexpansion at Door 2,
> under the versions and declared context recorded in the occurrence, without
> claiming semantic equivalence or concealing host-state substitutions?*

**On every route this audit could construct: yes — at the term granularity the
grammar declares, which is the only granularity it ever promises.** The stored
source datum is the single authority; the reconstruction is re-encoded and
gated before anything reaches the macroexpander; host-state substitutions that
preserve the term are *identified as the same term* (correctly, per the
declared equivalence), and host-state substitutions that break the term are
**refused, not concealed** — including by a gate its own documents believed no
public input could reach. No route minted a receipt whose account diverged
from the expansion performed.

**Where the layer fails is in its account of itself:** two reachability
classifications asserted as measured are false (D1, D3); the refusal machinery
crashes on host types the boundary law names as refused (D2, D5); the harness
that certifies the greens is fail-open for three of five instruments (D4); the
evidence cannot prove which bytes it measured (D6); one alarm guards a value
that does not exist (D7); and the self-certification battery contains checks
that cannot fail (D8, D9). In a layer whose thesis is *the expansion leaves a
truthful receipt*, the expansions are accounted for truthfully — it is the
layer's receipts about **its own reachability, robustness, and evidence** that
required this correction.

---

## 8. RECOMMENDATION

```
AUDIT-CLOSED — DEFECTS FOUND, REPAIR REQUIRED
```

Repairs indicated (for the family to weigh, not designed here): the D2/D5
robustness holes in the public term functions; the D1 and D3 catalogue
reclassifications (with grammar-version consequences under the layer's own
Errata 0.2 §5 rule — the decode relation's *sanctioned description* changes);
canonical result lines for the three unguarded instruments (D4); a
content-derived subject binding in the evidence header (D6); either a stored
version slot or an honest narrowing of the version-binding comment (D7); and
the D8/D9 check and document repairs.

## 9. STANDING — PRESERVED

```
candidate · frozen only as an audit target · audit returned with defects
· not adopted · not frozen as language law · on no governing floor
```

This return adopts nothing, repairs nothing, and opens nothing. Form /3,
Surface /2, and all repairs remain owner decisions. No file of the frozen
subject was modified by this audit; the subject subtree remains byte-identical
to `9b3436182c0e40c56987c77385608aef9d1f04f5`.

---

*Auditors: Claude Fable 5 (chair — custody, gate, crux probes, verification of
every headline, this return) with subagents PERSCRUTATOR (Fable 5 — adversarial
verification, novel crash), TABULARIUS (Opus 5 — claim ledger, mislabelled
checks, D1), FOSSOR (Opus 5 — reachability battery, harness teeth, temporal
binding, D4/D5/D6). Raw subagent reports filed byte-exact in `findings/`.
Preregistration unread at the fixing of this return; comparison filed
separately afterward. 2026-07-28.*
