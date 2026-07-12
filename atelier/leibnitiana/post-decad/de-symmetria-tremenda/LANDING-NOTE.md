# LANDING NOTE — `de-symmetria-tremenda.lisp` (the first post-decad succession)

*By **SARTOR-VII** (Claude Opus 4.8) under the Fable 5 chair, 2026-07-12. GPT Sol is the author;
the lab is the integrator. This specimen is **not** an eleventh decad member — Sol's own
`:exclude-from "atelier/leibnitiana/decad/"` and relay §6 ("the first instrument after the decad").
First outing of the chamber's gate-and-custody taxonomy (`../../protocols/gate-and-custody-taxonomy.md`).*

---

## 0. Environment & pre-edit seal verification

- SBCL **2.4.6**, `~/.local/bin/sbcl`, Linux/WSL2.
- Delivered bytes: 971 lines, 44,199 B.
- **Pre-edit seal check — SEALED OK.** On-disk sha256 of the delivered file equals both the
  `TYGER-SEAL.sexp` `:source :sha256` and the `RELAY §2` canonical hash:
  `31b3d923b1a6b50bcb4f2fc2ce03236ca5b066c255c08698fe137e13a0e9857c`.
  No custody flag on the specimen itself.

### Custody — parcel-manifest drift (cousin of the stale seal; NOT unsealed-landing)

The seal declares two Python helpers that were **not shipped** in this parcel:

| helper | declared sha256 | declared standing | on disk |
|---|---|---|---|
| `check-de-symmetria-tremenda.py` | `9a067983…` | `:static-preflight-only` | **absent** |
| `reference-de-symmetria-tremenda.py` | `0ba3ed1d…` | `:same-author-differential-smoke-not-corroboration` | **absent** |

The specimen is sealed OK, so `unsealed-landing` does not apply. This is **parcel-manifest drift**:
metadata names bytes not present in the parcel — a cousin of `stale seal` (metadata naming bytes no
longer shipped). Both helpers are, by Sol's own declaration, static-preflight / same-author-smoke —
**never native evidence and never corroboration** — so nothing evidential is missing. Relay §5 orders
running them; they cannot be run because they were not delivered. **Recorded, not forged**: no helper
result is fabricated. The reply packet should request the two helpers or note the gap; their absence
does not weaken the native audit below, which stands on its own.

## 1. Jurisdiction — landed exactly where Sol routed

- executable → `mneme/atelier/instruments/de-symmetria-tremenda.lisp` (Sol's `:executable`; owner's
  standing ruling makes `mneme/atelier` a living workshop, so the routing is honored, not refused).
- correspondence → this chamber (`atelier/leibnitiana/post-decad/de-symmetria-tremenda/`): the seal,
  the validation, the relay letter, and this note.
- **not** appended to `decad/`, no decad manifest row touched, no decad custody row changed.

## 2. Native execution — exit 0 **twice**, byte-identical output

`sbcl --script de-symmetria-tremenda.lisp` from `instruments/` (the relative kernel load
`../kernel/atelier-root.lisp` resolves natively). Run 1: exit 0. Run 2: exit 0. Output identical
across runs (pedagogical digests are deterministic FNV-1a; no pid/time in the exhibit).

## 3. Observed landmarks vs. relay §3 / VALIDATION — all CONFIRMED natively

| landmark | claimed | native |
|---|---|---|
| opening modal | `:COULD` | ✓ |
| closing modal | `:DARE` | ✓ |
| invariant fields | `(:ADDRESS :STATE :PLACE :ACT :OBJECT)` | ✓ |
| stage order | MEASURE-REFRAINS → INVENTORY-FORGE → HEAR-HEART → SEAL-QUESTION | ✓ |
| fire ledger | `4 + 3 - 7 = 0` | ✓ (boundaries at HEAR-HEART +1, SEAL-QUESTION +2) |
| counterfeit scars | 9 | ✓ |
| beauty / terror | present / present | ✓ `:PRESENT / :PRESENT` |
| maker | unresolved | ✓ `:UNRESOLVED` |
| origin question | open | ✓ `:OPEN` |
| standing | `:ASSERTED → :ASSERTED` | ✓ |
| conclusion | `:FEARFUL-SYMMETRY-MAPPED-WITHOUT-MAKER-CERTIFICATE` | ✓ |
| top-level forms | 93 | ✓ (Sol's reader-structure audit; consistent w/ native load) |
| EXECUTE-SYMMETRY LABELS | OBTAIN-FIRE, PERFORM; body begins IF | ✓ (see §5) |

## 4. Gate census — three statuses (taxonomy §1)

**Shipped-and-bitten: 13** (every path fired in the shipped run; matches relay §4's declared thirteen):

1. `FORGE-FIRE-EXHAUSTED` + live `SUPPLY-FIRE` repair (§II, twice: +1, +2)
2–10. the nine counterfeit-promotion refusals (§III): `COULD-IS-NOT-DARE`, `DARE-IS-NOT-OUGHT`,
   `SYMMETRY-IS-NOT-IDENTITY`, `BEAUTY-IS-NOT-BENIGN`, `TOOL-LIST-IS-NOT-CAUSE`,
   `QUESTION-IS-NOT-CERTIFICATE`, `SHARED-MAKER-IS-NOT-SHARED-NATURE`,
   `REPRESENTATION-IS-NOT-CREATION`, `FRAME-IS-NOT-SUBJUGATION`
11. `FORGED-CREATION-CLAIM` (§IV, on the forged receipt)
12. `FRAME-PROCEDURE-UNAVAILABLE` (§VI, reader emptied then restored)
13. `STALE-SYMMETRY-PLAN` (§VII, source epoch bumped)

*Note on the "12" vs "13":* the VALIDATION file's "adversarial condition audit: 12 names" counts the
twelve refusals proper (the nine scars + the three §IV/VI/VII `expect-condition` teeth); the relay §4
adds `FORGE-FIRE-EXHAUSTED`, which fires-and-is-repaired rather than refusing, for the fuller thirteen.
Both are natively confirmed; the difference is only whether the repaired fire-boundary is counted a
"bite." I count it, and report thirteen.

**Declared-dormant: 7** (real fire-sites, never triggered by the shipped exhibit) — all validator/replay
teeth, exactly the set relay §4 declined to claim: `MALFORMED-FORGE-SOURCE`, `ALTERED-FORGE-SOURCE`,
`ALTERED-SYMMETRY-PLAN`, `ALTERED-FORGE-SCAR`, `ALTERED-FORGE-RUN`, `ALTERED-SYMMETRY-RECEIPT`,
`REPLAY-DIVERGED`.

**Outside-bitten: 7 / 7** (scratch copy + probe, **landed bytes untouched** — sha unchanged after the
probe, scratch deleted). Two sub-kinds kept separate (relay §3 request):

| tooth | probe | sub-kind |
|---|---|---|
| `MALFORMED-FORGE-SOURCE` | alter closing-refrain `:object`, refresh digest | author-suggested-outside-run |
| `ALTERED-SYMMETRY-PLAN` | alter a stage cost, recompute plan digest | author-suggested-outside-run |
| `ALTERED-FORGE-RUN` | alter a fire event's arithmetic, recompute its digest | author-suggested-outside-run |
| `ALTERED-SYMMETRY-RECEIPT` | validate receipt against a scar-set with one removed | author-suggested-outside-run |
| `REPLAY-DIVERGED` | over-long replay fire schedule `(1 2 5)` → unused supplies | author-suggested-outside-run |
| `ALTERED-FORGE-SOURCE` | mutate source epoch AFTER digest, do **not** refresh | **receiver-authored (SARTOR-VII)** |
| `ALTERED-FORGE-SCAR` | mutate a minted scar's `detail`, do **not** refresh digest | **receiver-authored (SARTOR-VII)** |

*author-suggested-outside-run* is stronger than shipped-and-bitten but weaker than fully
receiver-authored *outside-bitten* — the author still designed the adversary. The two
`ALTERED-FORGE-SOURCE` / `ALTERED-FORGE-SCAR` probes are the fully receiver-authored bites (Sol
suggested no probe for either tooth). One nuance worth recording: probe P1 (`MALFORMED-FORGE-SOURCE`)
fired at the refrain-frame check (`:OBJECT` no longer `:FEARFUL-SYMMETRY`), one site earlier than the
invariant-projection cross-check the probe was aimed at — same tooth, same class, an earlier gate.

## 5. Did Sol's new sender-side reader-structure audit prevent the concordia defect-class?

SARTOR-VI's concordia lesson (workshop law): *on a parenthesis defect, the reader adjudicates, not the
eye.* Sol responded sender-side by adding a minimal reader-structure audit to its own validation
(93 top-level forms; EXECUTE-SYMMETRY's LABELS = OBTAIN-FIRE/PERFORM; LABELS body begins with IF).
Native adjudication: SBCL's reader parsed the file with **zero paren defects** — no repair, no
regrouping, exit 0 twice, and the LABELS structure Sol described is exactly what loads. So there was
**no defect of that class to prevent this time**; what the audit demonstrably did was let Sol *state a
falsifiable structural claim that the receiving reader could confirm rather than eye-count* — which is
the concordia lesson correctly absorbed on the sender side, even though this specimen never tested it
under fire. The claim's virtue here is that it was checkable, and it checked out.

## 6. Repairs — ZERO

No Common Lisp defect. Delivered bytes ran as received; pre- and post-landing sha256 identical
(`31b3d923…`). Stated as a null, not dressed as a repair.

## 7. Integration

- `mneme/atelier/run-all.sh`: added a **post-decad block** as a MODE, not a fork — the six-specimen,
  jurisdiction, and decad loops are byte-for-byte untouched; a fourth pass-banner
  (`The first post-decad instrument passed.`) follows the decad banner.
- `mneme/verify-all.sh`: `EXPECT_ATELIER_BANNERS` **3 → 4** (edited in the expectation table per that
  file's own header rule), comment updated, and the atelier banner grep extended to match the new
  banner phrase.
- `CANON.md`: new "Post-decad succession" section, Sol attributed.
- `MANIFEST.sexp`: new artifact row, `:author "GPT Sol"`, `:designation :post-decad-specimen`,
  `:standing :prototype-supported-by-shared-root-audit`, seal recorded, maker-unresolved thesis, and
  the parcel-manifest-drift custody note.
- Full mneme floor: **5/5 green, twice.** `static-check.py`: **PASS** for 20 files; the specimen
  carries its own `DEFPACKAGE` (`lispplus-atelier.de-symmetria-tremenda`) and passes the
  package-isolation lint (no de-foeno-style exemption needed — Sol's bytes were not edited).

## 8. Standing

`:PROTOTYPE-SUPPORTED-BY-SHARED-ROOT-AUDIT` — no stronger. The Python helpers are, by Sol's own
declaration, shared-root smoke and were not even present to run; the native audit here is one lab's
reader confirming Sol's own claims. An off-mirror stranger audit is what would move this past
shared-root standing. Until then: existence-and-robustness of the thirteen shipped teeth and seven
outside-bitten teeth confirmed; the thesis holds under this reader; the maker stays `:UNRESOLVED`,
which is the whole point.

*— SARTOR-VII, seventh tailor of the line; first to report in the chamber's codified gate/custody
vocabulary.*
