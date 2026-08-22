# CHANNEL POLICY /1 — R-1 OWNER FORK DOSSIER /0

**Prepared by the chair (Claude Fable 5), 2026-08-12→13 night, on the
owner's commission: a read-only decision-preparation sitting for R-1 ONLY.
No policy drafted; the held D-4 draft untouched; Tooling Repair /0 not
reopened; no standing changed; nothing published; no branch→main action.
Evidence: PRAECO's usage census (`_staging/pubsuff0-r1-published-census.md`,
1,104 lines) and MACHINATOR's transport state machine
(`_staging/pubsuff0-r1-transport-state-machine.md`, 701 lines), each
first-hand, mutually blind, with the chair's own spot-checks against a
fresh clone of the real mirror. Decisions are the owner's. Append-only.**

## 0. The exact owner question

> **When the main-ancestry guard withholds bytes from the public mirror,
> does it also withhold publication standing — or can publication standing
> arise earlier, from a distinct owner act, even while the bytes remain
> unavailable to the public?**

---

## 1. Authoritative state (chair-verified against the real mirror, tip synced 2026-08-10 16:36, lab commit `4bfc5278`)

- **Standing-before-bytes is the corpus's ROUTINE PRACTICE, not an edge
  case** [PRAECO, DF]: the ratified Charter /0 has **zero files reachable
  from `main`**; PS/0 Parcels 1–3 were accepted tonight on the withheld
  branch with the owner's own mirror-negative attached to each acceptance;
  One Act /0's five governing rulings lived for four days as what an owner
  ruling itself called **"adopted-but-failed-to-publish"** — an
  owner-minted category, recoverable *"without a new semantic adoption."*
- **Stale-authorized-bytes is the mirror's LIVE CONDITION** [chair, DF]:
  the public GRAMMAR/AUTHOR-GUIDE are the 08-10 versions — every deficit
  cured tonight is uncured in the public copies; the register and its five
  errata are not on the mirror and **not mentioned anywhere on it** (grep
  empty).
- **Census correction (erratum-grade, against the SD-13 dossier §C)**
  [PRAECO flag 1; chair-confirmed on the mirror clone]:
  `portable-judge-0/` is **NOT in the public corpus** — 0 of 65 files
  main-reachable, absent from the mirror. The dossier's asymmetry sentence
  ("the court that found the deficit is published; the court that made the
  law is not") collapses: **neither court is public.** The error is the
  fork's own ambiguity (mirrorable-scope vs main-ancestry) committed as
  fact — itself evidence of how much R-1 is needed.
- **"Publication standing" already exists in owner language, undefined**
  [PRAECO, DF]: twice — the Adapter /0 closure (07-30) and the owner's own
  TD-5 acceptance tonight (*"No law, PortJ/0 standing, or publication
  standing…"*). **This fork defines a concept the corpus is already using,
  it does not mint one.**

## 2. Historical usage census (PRAECO; full census in the annex file)

**Eight distinct senses of "published" in authority-bearing text; no
instrument defines the word.** The strongest ADOPTED sentence is MA0 R1
adoption ruling §10:

> *"An unreached mirror is not publication and must remain reported as
> unreached."*

— a **reporting duty** that already refuses to let authorization
impersonate arrival. **No adopted law couples standing to mirror
reachability**; the One Act adoption record, Charter ratification, AP0 and
PJ0 adoption records contain **zero** occurrences of
publish/publication/public/mirror; and the nearest adopted standing law
runs the OTHER way:

> *"Standing attaches to immutable object identities and explicit
> dispositions, never merely to filenames, directories, or descent from an
> adopted commit."*

The only instrument that would make commit-or-reach constitutive is the
channel-policy **DRAFT** — held, undisposed, and describing a machine that
no longer exists (D-4 microscope). Bytes-without-standing is equally
attested: the mirror serves the whole MA0 **candidate** doc set under its
own candidate banners, and the pre-2026-08-02 working-tree era published
material no owner act ever elevated.

## 3. The mechanical state machine (MACHINATOR; full report in the annex file)

**The machine withholds bytes and lacks the category in which "standing"
could even be posed** — proven, not assumed: `sync.sh` consults no
normative artifact (authorization-words appear only in comments); its five
gates are all predicates over git topology or bytes; the `SYNC-PAUSED`
sentinel is tested for existence only. Teeth-run tonight against a local
bare remote (one disclosed line changed): branch work refuses exit 1;
uncommitted files provably cannot publish; a failed push leaves the public
repo byte-identical, no partial state.

**Mechanical facts that bound the fork:**
- Withheld commits at measurement: **100** (FRIGUS's 81 was true at ITS
  measurement — a moving target; **never cite this number from any
  report**, recount at need).
- The withholding record (`.sync.log`) is **gitignored and host-local** —
  the refusal history would not survive a host move and is invisible to
  any clone.
- The post-commit hook **discards sync.sh's exit status** — a failed sync
  is mechanically indistinguishable from a successful one at the hook
  layer.
- The mirror's `main` is **unprotected** (`admin:true, push:true`,
  credentials wired) — **130 direct commits** have historically bypassed
  `sync.sh`; 30 non-sync branches exist; the 2026-07-12 receipt-seed
  deletion is visible in mirror history (2m37s between direct commit and
  sync deletion) and **deleted content remains recoverable from mirror
  history forever** — the sync machine restores the tip, never the record.
- Sync-commit messages: 298 old-form (assert nothing), 10 new-form (name
  `lab-commit` + `subject-subtree` — a verifiable *source* pointer, still
  not proof of what is served, since `_staging/`-stripping makes the
  mirror tree hash differ by construction).
- **Live defect on the exact merge path R-1's consequences will one day
  travel:** the installed `.git/hooks/post-merge` is a **stale copy**
  missing the 2026-08-02 `--commit` fix (the which-commit race is open on
  merges). Docketed below as the second tooling series; NOT repaired in
  this read-only sitting.

## 4. The normative state model (none of these collapse; each attested distinctly in the record)

```
 adopted/accepted            owner act on object identity (standing law above)
 authorized-for-publication  owner act; historically attested as its own
                             state ("adopted-but-failed-to-publish" =
                             authorized ∧ ¬transported)
 main-reachable              git topology fact (the guard's actual test)
 mirror-synchronized         transport event (hook fires sync; exit today
                             discarded — an evidence gap, not a state gap)
 publicly-retrievable        the stranger's fact (clone succeeds; verified
                             tonight by actually cloning)
 normatively-public          the composite the fork must define
```

Every pairwise gap is instantiated in the live record: adopted ∧
¬main-reachable (Charter) · authorized ∧ ¬synchronized (the five rulings,
four days) · synchronized ∧ ¬adopted (candidate docs on the mirror) ·
retrievable ∧ stale (the 08-10 MA0 docs) · main-reachable ∧
possibly-not-synchronized (hook discards exit).

## 5. The options (mutually exclusive; consequences across the commission's eight dimensions)

### OPTION A — Transport-coupled publication
*Publication standing attaches only when authorized bytes actually arrive
in the public corpus (main-merge + successful, verified sync).*
1. Standing attaches: at verified mirror arrival. 2. The guard legally
withholds **standing itself**. 3. An adopted artifact on a non-main branch
is *adopted, unpublished — and unpublishABLE in standing terms until
merge*. 4. Sync failure after "standing" — cannot occur (standing waits).
5. Mirror presence without an authority act: no normative effect (unchanged).
6. Parcel 1 + the held corpus: **retroactively reclassified** — everything
accepted tonight would carry no publication standing; the owner's
"adopted-but-failed-to-publish" category becomes incoherent (there would be
nothing "failed" — merely "not yet"). 7. The PS/0 readback becomes purely
empirical (what's on the mirror IS the published corpus). 8. Constrains
R-3 hard (mirror presence ≈ standing), simplifies R-4, sharpens R-8.
**Cost [INF]:** contradicts the adopted standing-law sentence's direction
and the owner's own historical category; makes standing hostage to an
unprotected transport channel (130 direct commits could then *create*
publication-standing-shaped facts).

### OPTION B — Full standing/transport separation
*An owner act creates publication standing whenever it says so; transport
is tracked separately and changes nothing normative.*
1. Standing attaches: at the owner act, full stop. 2. The guard withholds
bytes only. 3. Non-main adopted artifact: can be fully "published" in
standing. 4. Sync failure after standing: standing persists, availability
lags — indefinitely, silently. 5. Mirror presence alone: nothing.
6. Parcel 1 + held corpus: could be declared published tonight by
sentence. 7. The PS/0 readback risks testing a "published corpus" **no
stranger can fetch** — linguistically and experimentally bizarre (the
commission's own trap). 8. Leaves R-3/R-4/R-8 almost unconstrained.
**Cost [INF]:** abolishes MA0 R1 §10's insight instead of generalizing it.

### OPTION C — Three-stage: authorization → transport → published standing (adoption orthogonal) — **[REC] chair's recommendation**
*An owner act creates PUBLICATION AUTHORIZATION (a real, durable standing
of its own). PUBLISHED standing attaches only upon successful, verifiable
transport of the authorized bytes (main-merge + sync + verify-by-content).
Adoption/acceptance standing is orthogonal to all three stages. The
adopted reporting duty generalizes: an unreached mirror is not
publication, and authorized-but-unreached must always be reported as such.*
1. Standing attaches: authorization at the owner act; **published** at
verified arrival. 2. The guard withholds **transport, and therefore
published-standing's precondition — but not authorization, and never
adoption**. 3. Non-main adopted artifact: *adopted; authorized if the
owner has so acted; not yet published; reportable as exactly that* (the
existing category "adopted-but-failed-to-publish" becomes lawful
vocabulary). 4. Sync failure after authorization: authorization persists;
published-standing does not attach; the failure is a REPORTABLE state
(and the hook's discarded exit becomes a docketed defect against a defined
duty). 5. Mirror presence without an authority act: **no standing of any
kind** (the 130 direct commits, the candidate docs, stale copies — bytes,
not law). 6. Parcel 1 + held corpus: exactly what their instruments
already say — accepted, not mirror-published; no retroactive motion in
either direction. 7. The PS/0 readback gets its honest form: *"of the
authorized corpus, what has verifiably arrived, and does it suffice?"*
8. R-3 answers itself (presence ⇏ standing); R-4 defaults to prospective
(no history rewritten); R-8 becomes tractable (a published executable with
unpublished dependencies = authorized-whole, partially-transported —
reportable, not paradoxical).
**Why earned, not aesthetic [each ground quoted in §1–2]:** it is the only
option under which all four load-bearing facts of the record remain lawful
as they stand — the adopted §10 reporting duty, the owner's
"adopted-but-failed-to-publish" category, the standing-law's decoupling
sentence, and tonight's acceptances with their mirror-negatives attached.
A would retro-strip; B would retro-inflate; C describes what the corpus
has been doing and gives it teeth.

*(No fourth model was forced; the two-stage variants collapse into A or C
on inspection, and the record contains no support for standing arising
from transport alone.)*

## 6. Pathological cases under the recommended model (each with tonight's live instance)

| Case | Status under C | Live instance |
|---|---|---|
| authorized, branch never merges | authorized; unpublished; reportable | the 100 withheld commits |
| main merges, sync fails | published-standing does NOT attach; defect against a defined duty | hook discards exit — TD-7 below |
| mirror holds unauthorized bytes | bytes, no standing; removable; history retains them | the 130 direct commits; receipt-seed scar |
| mirror holds stale authorized bytes | earlier version published; successor authorized-unpublished; reportable | MA0 docs at 08-10 state, live now |
| adopted law intentionally not public | lawful: adopted ∧ unauthorized | the five rulings pre-Parcel-1; the terminal instrument (nowhere on disk) |
| public-readable but candidate | transported, never authorized as law; banners govern | the register-less candidate set on the mirror |

## 7. Second tooling series — DOCKETED, not repaired (read-only sitting; TD-1..5 CLOSED history untouched)

Appended to the tooling docket as **TD-6..TD-9, OPEN/UNASSIGNED**:
**TD-6** mirror `main` unprotected, credentials wired, 130 historical
direct commits — the transport channel cannot currently enforce that only
`sync.sh` writes. **TD-7** post-commit hook discards `sync.sh` exit status
— sync failure invisible at the hook layer. **TD-8** installed
`post-merge` hook is a stale pre-2026-08-02 copy (which-commit race open on
the merge path — the exact path the eventual branch→main publication will
travel; flag for repair BEFORE that merge). **TD-9** `.sync.log` is
gitignored/host-local — the withholding record is unportable testimony.

## 8. Downstream dependency map

**R-3** (standing of mirrored text): under C, answered in principle
(presence ⇏ standing) — residue: whether published text must carry a
standing marker. **R-4** (commencement/savings): C is naturally
prospective; the one owner sub-question is how to *describe* the
working-tree-era corpus (historical bytes, never standing). **R-8**
(public executable, private dependency): reportable partial-transport
under C; wants the availability semantics the repaired gate already
speaks (UNAVAILABLE ≠ PASS). **R-1's answer also fixes the PS/0 readback's
form** (§5.C.7) and defines the sentence the campaign has been circling
since its epigraph.

## 9. Ceilings

This dossier decides nothing, drafts no policy, changes no standing,
publishes nothing, and creates no evidence. Its two annex files are
same-root evidence gathered first-hand tonight; the stranger audit remains
OWED on every lane it touches. The recommendation is a recommendation.

*— Claude Fable 5, chair, with PRAECO and MACHINATOR (Opus), 2026-08-12→13.*
