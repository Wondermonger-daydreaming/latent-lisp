# NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round

**Not a package, not an API, not loadable as part of any system.**

Every file in this directory carries that banner in its own header, and the
statement is literal:

- nothing here defines the proposed Surface Account /0 package;
- nothing here exports an API or mints an Account /0 object;
- nothing here appears in `lisp-plus.asd`, in the umbrella lane table, in
  `load-order-matrix.sh`, in any release floor, or in any CI gate;
- nothing here edits Surface /0, /1, /2, Integration Baseline /0, or any other
  lane — the predecessors are **read** and **driven through their public APIs**,
  and that is all;
- nothing here evaluates, compiles, loads, replays or executes any expansion.

The probe reads two named provider APIs through **qualified external symbols
only**. There is no `lisp-plus-surface0::`, `lisp-plus-surface1::` or
`lisp-plus-surface2::` anywhere in this directory. Canonical Datum /0's public
constructors appear for exactly one reason, stated rather than hidden: both
providers' Door 1 *requires* a CD/0 identifier datum as its occurrence tag, so
there is no way to call the public API without it.

## How to run

```sh
bash run-probe.sh <output-directory>                  # the clean run
bash run-probe.sh <output-directory> --plant-failure  # the runner-failure proof

# the verifier, ALWAYS with an explicit expected profile, the exact tip, and the
# repository that tip must resolve in
bash verify-transcript.sh <output-directory>/probe-transcript.txt \
     --profile matrix    --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/controls-transcript.txt \
     --profile controls  --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/freshness-transcript.txt \
     --profile freshness --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/schema-witness-transcript.txt \
     --profile schema    --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/allocator-transcript.txt \
     --profile allocator --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/init-stale-transcript.txt \
     --profile init-stale     --tip <parcel-tip> --repo <subject-root>
bash verify-transcript.sh <output-directory>/init-recursive-transcript.txt \
     --profile init-recursive --tip <parcel-tip> --repo <subject-root>

# the verifier's own teeth: thirty-four crafted defects, each of which must be refused
# (--r31-verifier is optional and names an EXTRACTED R3.1-era verify-transcript.sh;
#  it is what measures specimen 34's pre-fix acceptance, and its md5 is recorded)
bash run-verifier-specimens.sh <output-directory>/specimens \
     --from <output-directory>/controls-transcript.txt --tip <parcel-tip> \
     [--prefix-verifier <r3-era-verifier.sh>] [--r31-verifier <r31-era-verifier.sh>]
```

`--tip` must be **exactly 40 lowercase hexadecimal digits** and must **resolve to
a commit** in the repository named by `--repo`. There is exactly one exception
and it is an explicit mode: `--fixture-tip` accepts the **all-zero string**, which
is **not a Git object and not a real tested tip of anything** — it exists so that
`run-verifier-specimens.sh` can run its synthetic suite with no probe run at all.
Presenting the all-zero tip *without* that mode is refused, and the specimen
runner keeps the refusal as evidence.

`<output-directory>` is required, and it **may not be inside the worktree** —
that is **enforced**, identically, by **both** `run-probe.sh` and
`run-verifier-specimens.sh`. The intended physical path is resolved *before
anything is created*, with nonexistent components and `..` resolved **logically**
(the deepest existing prefix physically, so a symlink pointing back in is caught;
everything past it by popping `..`, which is what a `mkdir -p` would actually
create), and again after the directory is realized. **A rejected path leaves
nothing behind** — teeth 13 and 14 below prove that, including the leftovers
check. The worktree holds sources only, so a packer can re-run this at a frozen
parcel tip and compare against an earlier run.

The worktree root those two teeth defend is itself resolved with Git, so
**R3.1-D's environment clause binds the harness as well as the verifier**:
every Git invocation in `run-verifier-specimens.sh` now runs from a cleared
ambient set (`GIT_CLEAN_ENV` / `git_clean`, matching `verify-transcript.sh`'s
`git_clean`), and the demonstration arms that need one hostile variable set it
on top of that cleared base so each arm measures the variable it names rather
than whatever the caller's shell exported. Measured, not asserted: with all
seven variables exported at a donor repository, the harness's own behaviour is
unchanged — same `…-VERIFIER-SPECIMENS-PASS`, same refusals (that measurement was
taken at R3.1, when the suite was thirty-three); with
the unhardened form, the ambient `GIT_DIR` relocated the worktree root to the
donor and teeth 13 and 14 then wrote into the source directory they exist to
protect.

`PARCEL_TIP` (the worktree's `git rev-parse HEAD` at run time) is stamped at the
**top and the bottom of every child block**. A run that cannot read a tip
**fails closed**: a transcript stamped `UNAVAILABLE` cannot be tied to any
source state, so it is never produced.

Output:

| file | contents |
|---|---|
| `probe-transcript.txt` | one child block: `POSITIVE-MATRIX`, the fourteen positive-matrix cases |
| `controls-transcript.txt` | two child blocks: `CONTROLS-A` (controls 1–5, 7) then `CONTROLS-B` (control 6) |
| `freshness-transcript.txt` | one child block: `FRESHNESS`, the contract §II.3 occurrence-freshness mechanism demonstration |
| `freshness-peer-image.txt` | **not a transcript** — the output of the second, separately started image whose only job is to mint an epoch for T3 |
| `schema-witness-transcript.txt` | one child block: `SCHEMA-WITNESS`, the CD/0 inspection-record schema witness (R2 adjudication §A) |
| `allocator-transcript.txt` | one child block: `ALLOCATOR`, the concurrent allocator tooth (R2 adjudication §D) |
| `init-stale-transcript.txt` | **R3.3.** one child block: `INIT-STALE-SCHEDULE`, the stale-definition overwrite tooth — one *pinned* schedule run against the exact candidate source (clean) and against a captive copy of the R3.2 `DEFGLOBAL`-then-CAS law (planted) |
| `init-recursive-transcript.txt` | **R3.3.** one child block: `INIT-RECURSIVE-LOAD`, the genuine recursive-load tooth — a same-thread recursive `LOAD` fired from inside an unfinished initialization, under a hard time bound |
| `init-post-election-transcript.txt` | **R3.3.1.** one child block: `INIT-POST-ELECTION-FAILURE`, the unprotected post-election interval — a condition planted at the first instant after a won election, with a second loader *provably* parked on the cell's wait queue, plus a labelled **replica** arm exhibiting the returned shape leaving that sleeper unwoken |
| `init-plist-foreign-transcript.txt` | **R3.3.1.** one child block: `INIT-PLIST-FOREIGN-PROPERTY`, a carrier symbol already carrying two unrelated properties before the first load — the election must still be total and must preserve them verbatim; the planted arm exhibits the returned whole-plist-versus-`NIL` compare failing 1000/1000 and its loop never terminating |
| `init-plist-contention-transcript.txt` | **R3.3.1.** one child block: `INIT-PLIST-CONTENTION`, the plist changed **between the read and the compare** — the retry loop must re-read and converge; the planted arm shows a single-shot election losing the same race outright |
| `init-publication-finality-transcript.txt` | **R3.3.2.** one child block: `INIT-PUBLICATION-FINALITY`, the instant **after** the state CAS succeeded — a condition planted there, with a second loader *provably* parked on the cell's wait queue, must leave the state present, **no** failure marker, and that sleeper woken *with the state*; the labelled **replica** arm exhibits the returned shape — publish, then a separate local flag — producing a cell that carries a state **and** a failure at once, on which two honest readers return opposite answers |
| `init-carrier-slot-transcript.txt` | **R3.3.2.** one child block: `INIT-CARRIER-SLOT`, presence versus value in the reserved slot — a reserved indicator carrying `NIL`, two reserved entries, a value that is not a cell, and a property list that is not one, each refused immediately and inside a bound, and then one lawful cell still observed; the **replica** arm runs the returned `GETF`-then-CAS law against the ruling's own precondition and exhibits the silently prepended **second** indicator |
| `init-carrier-total-transcript.txt` | **R3.3.3.** one child block: `INIT-CARRIER-TOTALITY`, the malformed-carrier totality closure — an **improper (dotted)** property list, an improper list **carrying one otherwise-lawful reserved cell**, and a **circular** property list, each refused definitively inside a bound with no election, no gathering, no readiness and the plant left `EQ`-identical; the two labelled **replica** arms run the returned `while (consp tail)` walk on the same two shapes and exhibit it *accepting* the dotted revenant as an empty lawful carrier and *expiring* on the circular one |

Exit is `0` only if every clean arm passed **and** all thirteen transcripts are
**accepted by `verify-transcript.sh` under their explicit expected profile**.
The two R3.3 transcripts, the three R3.3.1 transcripts, the two R3.3.2
transcripts and the one R3.3.3 transcript are verified by the **already accepted
R3.2 verifier, byte-unchanged**, under new external profiles and sequences;
`verify-grammar.txt` is byte-unchanged too, because the new sections' only
anchors are `CHECK-ID` lines and their arm headings are ordinary prose.

## The verifier law (R2 — the R1 law plus a closed grammar)

The R0 verifier read its expectations **out of the transcript**: it counted the
sentinels the file happened to carry and compared them with the counts the file
happened to claim. A transcript that lost a whole child block lost its sentinel
and its claim together — and they still agreed. Its one "truncation test"
therefore deleted nothing the verifier could see. **A gate that cannot fail is
not a gate.**

**R1 fixed half of that and left five holes, all of them named here because they
are the reason the R2 files exist:**

1. **`CHECKS` was still read out of the artifact.** R1 bound `CASES` externally
   and then compared the transcript's claimed `CHECKS` with the transcript's own
   `[PASS]` count — two numbers a hollowed-out section moves **together**. An
   intact `CONTROLS-B` shell with its body deleted and its header forged to
   `CHECKS=0` was **accepted**. (Specimen 8.)
2. **Unrecognized body lines fell through a bare `next`** — anything could be
   inserted into a block and be stepped over in silence.
3. **`END-OF-TRANSCRIPT` changed nothing**: arbitrary material could follow it
   inside the same block. (Specimen 10.)
4. **`[FAIL]` and `PROBE-SECTION-FAIL` were matched only at their usual
   indentation**, so a re-indented verdict line was invisible. (Specimen 11.)
5. **`--tip` was any nonempty string that was not the word `UNAVAILABLE`** — a
   tip that was not a hex object name, or was one belonging to no repository at
   all, sailed through. (Specimen 12.)

Under the R2 law the caller states the **expected profile** (ordered sections,
exact `CASES`, exact `CHECKS`), the **expected tip**, the **repository that tip
must resolve in**, and — through `verify-sequences.txt` — the **exact ordered
check-ID sequence** of every section. Nothing whatever is inferred from the
artifact under test. Profiles live in `verify-profiles.txt`:

| profile | expected ordered sections, `CASES` : `CHECKS` |
|---|---|
| `matrix` | `POSITIVE-MATRIX:14:27` |
| `controls` | `CONTROLS-A:0:43` then `CONTROLS-B:0:27` |
| `freshness` | `FRESHNESS:0:31` |
| `schema` | `SCHEMA-WITNESS:0:135` |
| `allocator` | `ALLOCATOR:0:31` (**R3.3**: 27 + the four R3.3-C ASCII-alphabet checks; recomputed from the final source, not carried for continuity) |
| `init-stale` | `INIT-STALE-SCHEDULE:0:12` (**R3.3**) |
| `init-recursive` | `INIT-RECURSIVE-LOAD:0:11` (**R3.3**) |
| `init-post-election` | `INIT-POST-ELECTION-FAILURE:0:11` (**R3.3.1**) |
| `init-plist-foreign` | `INIT-PLIST-FOREIGN-PROPERTY:0:7` (**R3.3.1**) |
| `init-plist-contention` | `INIT-PLIST-CONTENTION:0:6` (**R3.3.1**) |
| `init-publication-finality` | `INIT-PUBLICATION-FINALITY:0:11` (**R3.3.2**) |
| `init-carrier-slot` | `INIT-CARRIER-SLOT:0:8` (**R3.3.2**) |
| `init-carrier-total` | `INIT-CARRIER-TOTALITY:0:7` (**R3.3.3**) |
| `synthetic` | `SYN-CONTROLS-A:0:3` then `SYN-CONTROLS-B:0:4` — **not a probe transcript**; the specimen runner's self-contained base, at the all-zero fixture tip |

For every expected child block the verifier requires **all** of: an opening
`PARCEL_TIP` equal to the tested tip; a `PROBE-SECTION-PASS` name and an
`END-OF-TRANSCRIPT` name that agree with each other and with the profile's
section for that position; strictly numeric `CHECKS` and `CASES`; `CASES` and
**`CHECKS` exactly as the PROFILE declares — not as the transcript claims**; a
`[PASS]`-line count equal to the profile's `CHECKS`; **one `CHECK-ID` line
immediately after every `[PASS]` line and nowhere else**; **the section's ID
stream exactly equal, in order, to its declared sequence**; **no `[FAIL]`, no
`PROBE-SECTION-FAIL` and no other bracketed verdict form at ANY indentation**;
**every body line consumed by a declared grammar production**; **nothing after
`END-OF-TRANSCRIPT` but the declared separator, the closing `PARCEL_TIP` and
`CHILD-EXIT 0`**; every in-body `PARCEL_TIP` stamp equal to the tested tip; an
identical closing `PARCEL_TIP`; a mandatory `CHILD-EXIT`, and it must be `0`;
and no missing, duplicate, extra, reordered or trailing block material.

### The closed grammar, and what it does *not* claim

`verify-grammar.txt` declares every production **as data**: `PRODUCTION` (a
consumed line), `ANCHOR` (a consumed line that contributes one ID, by a declared
id-ERE and a declared normalization), `RESERVED` (a structural token that may
**only** be consumed by a production or an anchor, never by a fallback), and two
`FALLBACK`s — the indented measurement line and prose.

It guarantees that **no line carrying a reserved structural token can enter a
block unless it is exactly well formed**, that every counted assertion carries an
externally declared ID in an externally declared order, and that nothing at all
may follow `END-OF-TRANSCRIPT`. It does **not** claim that free prose inside a
block is constrained in content: prose is consumed by the `narrative` fallback,
which is a **declared production named as such** — not a silent skip. That is the
honest size of the claim.

### The check IDs

`probe-check` emits its verdict line in its exact R0/R1 shape — `  [PASS]
<label>`, byte for byte, so **every citation written against a label still
resolves** — and then one line more:

```
  [PASS] C6/S1 step 5 TOOTH BITES: all THREE live version declarations moved
  CHECK-ID C6-S1-STEP-5-LIVE-VERSIONS-MOVED
```

The IDs are written at each assertion's call site in the probe sources, and the
**ordered sequence** each section must produce is frozen in
`verify-sequences.txt`. Counts collapse — two checks that swap places, a check
that fires twice while another never fires, a provider half replaced by a
repetition of the other, all preserve the count. **The ID stream does not
collapse: it names which assertion ran, and where.** The sequences were authored
from one clean run at the R2 tip and read back against the sources; what makes
them external is that they are **frozen in the sources, where the artifact under
test cannot reach them**.

### The verifier's teeth — thirty-four

**The four R3 additions (15–18)** close the last transcript-grammar defects:
a **one-character bracketed verdict** `[X]`, beneath the R2 pattern's
three-character floor; **`CHILD-EXIT 000`**, a terminator that is zero only
after numeric coercion; a **footer announcing `FAILURES 999`** while every
externally bound count still agrees; and a **tip resolved through
`refs/replace`** — a name that names no object at all, lent a real commit's
body by a mapping in a purpose-built scratch repository. All four were
**ACCEPTED by the R2 verifier**; the suite proves each one refused now, and
prints the raw-git comparison that shows exactly which lens was answering.

`run-verifier-specimens.sh` crafts **thirty-four defective artifacts** and requires
each one to be **refused with a nonzero exit**:

| # | specimen | the defect | since |
|---|---|---|---|
| 1 | `loss-of-last-block` | the whole last section is gone | R1 |
| 2 | `missing-final-child-exit` | the final `CHILD-EXIT` line is gone | R1 |
| 3 | `missing-closing-tip` | the final closing `PARCEL_TIP` is gone | R1 |
| 4 | `pass-flipped-to-fail` | one `[PASS]` becomes `[FAIL]`, footer still says PASS | R1 |
| 5 | `pass-end-name-disagreement` | `PROBE-SECTION-PASS` and `END-OF-TRANSCRIPT` name different sections | R1 |
| 6 | `incorrect-cases` | the declared `CASES` count is wrong | R1 |
| 7 | `malformed-checks` | `CHECKS` is nonnumeric | R1 |
| 8 | `hollow-last-block-checks-zero` | **the intact shell**: body removed, `CHECKS` forged to `0` — self-consistent, and R1 accepted it | **R2** |
| 9 | `s2-half-removed-checks-forged` | the whole **S2 half of control 6** removed, `CHECKS` forged to the remainder (13) | **R2** |
| 10 | `material-after-end-of-transcript` | one arbitrary line inserted after `END-OF-TRANSCRIPT` | **R2** |
| 11 | `reindented-fail-verdict` | a `[FAIL]` line **inserted** at an indentation R1 did not look at — no count and no ID moves, so only an indentation-independent verdict test can catch it | **R2** |
| 12 | `nonexistent-git-tip` | 40 lowercase hex digits that resolve to no commit | **R2** |
| 13 | `outdir-inside-the-worktree` | the specimen runner's own output directory named inside the worktree | **R2** |
| 14 | `nonexistent-prefix-dotdot-inside` | a spelling — `probes/nonexistent-prefix/../evidence` — whose `..` resolves back inside the worktree | **R2** |
| 15 | `short-bracketed-verdict` | a **one-character** bracketed verdict `[X]`, beneath the R2 pattern's three-character floor | **R3** |
| 16 | `child-exit-000` | a terminator that is zero only after **numeric coercion** | **R3** |
| 17 | `footer-failures-999` | a section announcing **999 failures in its own footer** while every externally bound count still agrees | **R3** |
| 18 | `tip-through-refs-replace` | a tip naming **no object at all**, lent a real commit's body by a `refs/replace` mapping in a purpose-built scratch repository | **R3** |
| 19 | `footer-missing` | the block carries **no section footer** — R3 never required one | **R3.1** |
| 20 | `footer-duplicate` | **two** footers, both lexically perfect and in agreement | **R3.1** |
| 21 | `footer-forged-checks` | a footer whose `CHECKS` contradicts **both** the profile and the block's own `END-OF-TRANSCRIPT` | **R3.1** |
| 22 | `footer-forged-cases` | the same, on `CASES` | **R3.1** |
| 23 | `tip-header-stamp-missing` | the **header** stamp of the in-body `PARCEL_TIP` pair is gone | **R3.1** |
| 24 | `tip-footer-stamp-missing` | the **footer** stamp of the pair is gone | **R3.1** |
| 25 | `tip-header-stamp-duplicate` | the header stamp is **doubled** — both copies carrying the correct tip | **R3.1** |
| 26 | `tip-footer-stamp-duplicate` | the footer stamp is **doubled** | **R3.1** |
| 27 | `tab-prefixed-checks` | a **tab-prefixed** `CHECKS` footer, which every reserved ERE's literal-space prefix class missed and the NARRATIVE fallback then ate as prose | **R3.1** |
| 28 | `tab-prefixed-end-of-transcript` | the same, on `END-OF-TRANSCRIPT` | **R3.1** |
| 29 | `tab-prefixed-child-exit` | the same, on `CHILD-EXIT` | **R3.1** |
| 30 | `ambient-git-dir` | an honest transcript at a **donor** repository's tip, verified against an innocent **victim** repository while `GIT_DIR` quietly answers for the donor — `git -C <path>` does **not** override it | **R3.1** |
| 31 | `ambient-git-object-directory` | the same substitution one level down, at the **object store** | **R3.1** |
| 32 | `ambient-git-alternate-object-dirs` | the same, through `GIT_ALTERNATE_OBJECT_DIRECTORIES` | **R3.1** |
| 33 | `configured-object-alternates` | **no environment at all**: the victim's own `objects/info/alternates` lends it the donor's objects | **R3.1** |
| 34 | `promisor-lazy-fetch` | **nothing lies**: the artifact is honest, the environment is clean and the repository's config is accurate — it is a **partial clone** that does not hold the tip and is willing to fetch it. Asked whether the object exists, the R3.1 verifier made Git **import it from a (wholly local) promisor remote** and then called it "physically present" | **R3.2** |

Specimen 34 is neither text surgery nor a hostile environment: the **repository**
is the one that answers differently, and the fix is `GIT_NO_LAZY_FETCH=1` on
every Git invocation in `verify-transcript.sh`'s `git_clean`. Its pre-fix
acceptance is measured against the **extracted R3.1 verifier** (`--r31-verifier`,
with the extracted file's **md5 recorded** beside the result), and the import is
counted rather than described — the pre-fix repository's object files go **0 → 4**
while the repaired run leaves **0 → 0**. Its control is a partial clone that
**holds its own commit**: that one must still be **ACCEPTED**, so the clause
refuses imported existence and not partial clones. A raw-git evidence block runs
both policies on two fresh repositories, beneath any verifier.

Specimens 1–12 and 15–29 are produced by **text surgery on an accepted base**,
so each differs from a passing transcript in exactly one way. Specimens 30–33
are not text surgery at all: the artifact is honest and **the environment lies**,
so they are run with two controls first — the donor tip against the victim in a
**clean** environment must be **refused** (otherwise the arms would measure a bad
tip, not the environment), and the victim's **own** tip under all six hostile
variables at once must still be **accepted** (otherwise the clearing would merely
be breaking every honest call). **Every one of specimens 19–33 was ACCEPTED by
the R3 verifier**, which `--prefix-verifier` records rather than asserts: the
earlier verifier is run over each of them and its exit code is written beside the
current one, and a "reproduction" the earlier verifier already refused is counted
as a failure of the demonstration. Teeth 13 and 14 are
**output-path** teeth: they hand this script a path it must refuse and then check
that **nothing was created** — the leftovers list is written beside the exit code
as evidence. **The control arm runs first and is mandatory:** the untouched base
must be ACCEPTED, or a column of refusals would prove only that the verifier
refuses everything. A further evidence arm shows the **all-zero fixture tip being
refused the moment `--fixture-tip` is absent**.

The script runs a self-contained **synthetic** suite (runnable with no probe run
at all — its base carries the closed grammar's shapes under section names of its
own, with its own declared profile and sequences) and, given `--from`, the same
defects against an **actual** clean `controls-transcript.txt` at a real Git tip.
The live base must have **at least two child blocks**, because specimen 1 deletes
the last one; `controls-transcript.txt` is the intended live base.

## The freshness mechanism (contract §II.3)

The adjudication's section D refused a merely asserted "fresh fact minted by
Door 2": *that is not a mechanism.* The contract answered by specifying one — a
**performance datum** of **image-epoch + per-image monotonic counter** — and a
specified mechanism that is never run is still only a sentence. So
`probe-freshness.lisp` **demonstrates the primitive**, in its own child image,
under a hard boundary: it defines no package, mints no Account object, and
**touches neither provider** — CD/0's public constructors and plain host
facilities, and nothing else. The datums it builds are probe-local stand-ins
carrying the roles the contract names; they are not the contract's objects.

| property | what is shown | its planted arm |
|---|---|---|
| **T1** same-image freshness | two performances of one request yield different performance datums, different occurrence identities and different account identities — and each identity is *reproduced exactly* from the same request datum plus its own performance datum, so the difference is attributable to the performance datum alone | a **reused counter**: the performance datum, the occurrence identity and the account identity all **collide**, so the clean verdict is a measurement of the counter's contribution rather than a restatement of it |
| **T2** request stability | the request identity is byte-identical across both performances, the request datum is unmutated, and the request identity does not contain the performance datum at all | a **perturbed request** moves the identity, so the stability check is not vacuous |
| **T3** epoch behaviour | the epoch is constant within one image (three samples) and differs from a **second, separately started** child image's epoch — that peer image's output is kept as `freshness-peer-image.txt` | the comparator is handed **two equal epochs** and reports *not distinct*, so its clean verdict discriminates |
| **T4** reload (**R3**) | the identity source is **re-loaded into the same running image**: no new epoch is gathered, the epoch is byte-identical, the counter is not reset and the next allocation continues the progression | the same two comparisons are handed a counter that **did** restart at zero beside a structurally different epoch and report *not preserved* |
| **T4 concurrent** (**R3.2**) | the same source is re-loaded by **N threads at once** in that image: all N observe **one** epoch, **no** new gathering, and the allocations they take across the reload are exactly the next N×K counters with **no gap and no repeat** — so the once-only law survives **concurrent sequential reloads** (**R3.3 relabel**: neither T4 arm is *re-entrant* — no load is in progress beneath either — and true re-entry is closed by the recursive-load tooth instead) | the FIRST-load race, which cannot be staged here, is exercised as a **broad contention control** in the allocator section's `ALLOCATOR-INIT-RACE` arm, and the *dangerous* schedule is pinned in `probe-init-schedule.lisp` |

**The ceiling is printed beside the numbers, not implied.** T1 is deterministic
within one image. T3 is an **observation about a seed**, on this host, in this
pair of children — **no cross-image temporal uniqueness is claimed**: two
images' counters coincide by construction (performance 1 is performance 1 in
both), and only the epoch segment separates their performance datums.

## The CD/0 inspection-record schema witness (R2 adjudication §A)

`probe-schema-witness.lisp` builds **one instance of every one of the five
branches** — `s1-receipt`, `s2-receipt`, `s1-refusal`, `s2-refusal`,
`composite-refusal` — to the exact tables of
`../CD0-INSPECTION-RECORD-SCHEMA.md`, through the **accepted public CD/0 API**
and nothing else, and proves per branch:

| proof | how |
|---|---|
| `datum-p` | the whole record is a CD/0 record datum |
| round trip | `encode-exact` → `decode-exact` is `equal-datum` to the original |
| canonical re-encoding | the decoded record's `canonical-octets` are byte-identical to the original's |
| exact key set | envelope exactly the four declared keys; body exactly 18 / 18 / 9 / 6 / 6, **no more and no fewer**, read back through `record-datum-size` and `record-datum-key-at` |
| exact value-datum species | every key's value is of its declared family |
| **not re-admitted** | the record — and its decoded twin — is refused by **all four native admission predicates**, which are shown in the same image **accepting their own genuine objects** |

An inspection record is an **inert CD/0 record datum**, which is exactly why it
can be built with public constructors and no Account package. The providers are
touched only for the **native datum samples** §§4 and §6 require: a pass-through
law tested against invented values would test nothing.

**Three predicates that have never refused anything are three untested
predicates**, so each is shown refusing a record that differs from a good one in
exactly one way: a **fifth envelope key**, a **missing body key**, and a body
whose key set is exact but **one value datum is of the wrong species**. §2's
**1024-octet detail ceiling** is exercised at the ceiling (accepted) and one
octet above it (**refused, code `:detail-string-exceeds-ceiling`**) with the
assertion that **no datum at all** is produced above it — a truncated detail
would be a lossy datum, and none is manufactured.

**R3.2: the detail union is now shown at RECORD level, not only at datum
level.** The R3.1 return was exact about the gap — the `NIL` and 1024 arms
validated *a datum*, not *a complete recognized record*. So each member of the
two-member union is now carried in a **complete fixed-schema record on a
native-refusal branch** (`s2-refusal`, §5.2, whose detail cell inherits §5.1's
union; branch 5 is string-only by §5.3 and its standing member is planted and
refused): the record with `("standing" "measured-nil")` and the record with a
**1024-octet** string are each **recognized by `ACCOUNT-INSPECTION-RECORD-P`**,
each round-trips to an `equal-datum` record that is **itself recognized**, and
each **re-encodes to byte-identical canonical octets**. Both are built by
`body-replacing` from a body this image already proved lawful, so exactly one
value moves. The boundary is measured on **both** sides: at 1025 the validator
yields **no datum and the code `:detail-string-exceeds-ceiling`**, so no record
can be built *through* it — and a record forged **around** it at 1025 is
**REFUSED by the recognizer** while the 1024 record one line above is
recognized.

**The doc/measurement tooth, and why it now reads zero.** The witness first
measured **twelve keys** whose native value is a CD/0 **bytes** datum where
§§4–5 said *identifier* datum — the five identity keys of each receipt branch
and the `refusal-identity` of each refusal branch. **The schema file's erratum
has recorded all twelve as bytes datums**, so the two columns now agree and the
witness asserts a deviation count of **exactly zero**. (`occurrence-tag` and
`construct-identity` were never in that set: they are measured as identifier
datums and the file always said so.)

**The detector is kept, and it is a standing tooth, not a historical note.** It
compares, key by key, what the probe **measures** against what the schema file
**declares**, so the day either column moves without the other the gate fires.
A zero from a detector that has never fired would be worth nothing, so a
**planted arm feeds the same function one deliberately mis-declared row in the
same image** and shows it reporting the disagreement — and passing the agreeing
row beside it. §6's substantive law is independent of all this and is what the
pass-through checks test: whatever family the native datum has, the record
carries **that very datum**, `equal-datum` and byte-identical under
`canonical-octets`.

**One obligation is VOID, not passed, and says so in the transcript.** §8.6's
*"presenting it for inspection draws the typed Account refusal
`:not-an-admitted-account-object`"* requires an **Account package**, and defining
one is exactly what this round forbids. What is discharged is the half that can
be: refusal by all four native admission predicates, with those predicates shown
discriminating.

## The concurrent allocator tooth (R2 adjudication §D)

The adjudication's sentence — *"ordinary unsynchronized INCF is not an
unconditional freshness mechanism"* — is a claim about a mechanism, so
`probe-allocator.lisp` exercises the mechanism. Host threads and CD/0's public
constructors only; **neither provider is touched**; the datums are probe-local
stand-ins carrying the role the contract names.

| arm | what is shown |
|---|---|
| **INIT-RACE** (**R3.2**, *reclassified* **R3.3**) | a **broad contention control**, not a proof of the universal law — it samples one schedule and cannot pin the dangerous one; the ruled schedule is closed in `probe-init-schedule.lisp`. What it exercises: the once-per-image law raced at the **only moment it can be raced**: this image has never loaded the identity source, so 8 threads are held at a barrier and then all call `(load "probe-identity.lisp")` — a genuine concurrent **first** load. All 8 observe **exactly one** epoch; the gathering count is **1**; no loader ever sees a partially initialized image (each that saw the epoch text also saw the epoch datum **and** the allocator mutex); and the 8 × 5 allocations they then take are exactly **1..40**, so one counter and one allocator mutex existed from the image's first allocation |
| **INIT-PLANTED** (**R3.2**) | the two unsafe initialization laws, on state of their own, under the same load, both **structural not probabilistic**: **P1** the R3 test-then-act held at a barrier *between* its test and its act — all 8 read `NIL`, all 8 gather, **8 distinct epochs**, 7 silently overwritten; **P2** the flag published *before* the state it announces, with two barriers pinning the order so an observer reads `INITIALIZED=T` beside an **absent** state. The same distinct-epoch counter reports **1** for the ruled law and **8** for the unsafe one, so the clean verdict is a measurement |
| **CLEAN** | 8 threads × 200 allocations through a **mutex-guarded** allocator yield exactly 1600 datums, **all distinct** by canonical octets, whose counters are exactly the **contiguous run of 1600 that starts at the printed baseline** (R3.2: the image's first 40 allocations now belong to the `ALLOCATOR-INIT-RACE` arm, so this arm's run begins where that one left off; R3.1 read it as 1..1600, when the clean arm was the image's first allocator) — **no gap and no repeat** — every allocation took a distinct position in one total order, which is the linearizability claim itself — every one carrying the contract's exact encoded path `("performance" <epoch-hex> <counter-decimal>)`, with one epoch across the image |
| **PLANTED** | the same load through an **unsynchronized read-modify-write**. Its first round holds every thread at a **barrier between the read and the write**, so all 8 demonstrably read the same value and all 8 mint the same counter: **structural, not probabilistic**. The duplicate detector that reported **zero** on the clean set fires here, and the counters are **not** contiguous |
| **ENTROPY** (**R3.2**) | R3.1 also printed `16` in the SHAPE arm, and its epoch was sixteen octets **wide** and eight octets **deep** — the high half was `(universal-time XOR pid<<24)`, bookkeeping rather than entropy — so that line could not tell an R3.1 epoch from an R3.2 one. The discriminating measurement is run here against **both** laws in one image: the named source (`/dev/urandom`) is **printed**, four draws are taken, and all four **high halves** differ; then the R3.1 term is **recomputed four times from this image's own clock and pid** and is **byte-identical every time**. The planted side is arithmetic, not luck: within one second in one process that term cannot vary. The ceiling is unchanged — sixteen OS-random octets buy **improbable collision**, never a uniqueness guarantee |
| **SHAPE** (**R3.1**, replacing the deleted `OBSERVATION` arm) | the R3.1-B performance representation, **measured**: the image epoch is exactly **16 octets** and its text exactly **32 lowercase hex digits**; the epoch was gathered exactly **once** in this image, under the synchronized once-per-image initialization that replaced R3's unsynchronized test-then-act; the stored counter initializes at **0** and the **first allocation is 1**. Then the shape predicate is shown **rejecting all seven** unlawful spellings the ruling enumerates — short epoch text, long epoch text, uppercase hex, counter zero, negative counter text, leading-zero decimal, nondecimal text — of which **four passed under R3**, whose epoch clause asked only for a nonempty lowercase-hex string and whose counter clause only for a nonempty digit string. R3's **bare-`INCF` observation arm is deleted**: the barrier tooth already proves the defect deterministically, and unsynchronized `INCF` may occur only inside that one labelled negative tooth. **R3.3-C adds four checks here**: `DIGIT-CHAR-P` is shown, *on this runtime*, accepting all four ruled non-ASCII decimal code points (U+0661, U+06F1, U+0967, U+FF11) **and** two mixed spellings whose first character is a lawful ASCII digit — that is the defect exhibited rather than quoted; the new ASCII-membership predicate refuses all six, and the mixed pair is what proves **every** character is restricted and not merely the first; `"1"` and `"10"` are accepted as positive controls; and the **shared constructor's own emitted counter segment** is shown satisfying the same predicate, which is the check that would catch a predicate tightened past what the implementation can emit |

**The widened window makes the demonstration deterministic; it does not make the
defect real.** The defect is that the operation has no atomicity to begin with.

**The ceiling, restated where the numbers are:** the epoch is an
image-epoch / entropy datum with **no cross-image uniqueness guarantee**, and
none is claimed. Two images' counters coincide by construction — allocation 1 is
allocation 1 in both — and only the epoch segment separates them. What is
demonstrated is **same-image linearizability under real thread contention**, on
this host, in this image, at this parcel tip.

## The R3.3 identity closure (owner adjudication, 2026-08-05)

The governing ruling is filed verbatim beside this directory as
`OWNER-ADJUDICATION-R3.2-AND-R3.3-COMMISSION.md`. It accepted R3.2 whole except
for **two returned defects**, and everything in this section exists to close
exactly those two and nothing else.

### Returned defect 1 — the bootstrap election was not closed

R3.2 declared each piece of once-only state with `SB-EXT:DEFGLOBAL` and a
*constant* value form, elected the one constructed object (a bootstrap mutex) by
a CAS on that `DEFGLOBAL`'s value cell, and argued the constant-valued race was
benign. **It is not.** On SBCL 2.4.6 the macro expands so that the unbound
**test** is evaluated while computing `%DEFGLOBAL`'s argument and the **write**
happens later, inside `%DEFGLOBAL`:

```lisp
(sb-impl::%defglobal '*m*
                     (if (sb-int:%boundp '*m*)
                         (sb-kernel:make-unbound-marker)
                         nil)
                     (sb-c:source-location) '"doc")
```

So two concurrent first loaders can both decide "unbound", and the slower one's
already-authorized `NIL` write can land **after** the faster one has CAS-installed
a live object — erasing it — after which the slow loader's own CAS succeeds
against the `NIL` it just wrote. *CAS serializes CAS against CAS; it does not
serialize an earlier defining form's delayed write against a later CAS
publication.* The expansion is **printed into the planted transcript** and the
interleaving is **exhibited on the real macro**, not on a re-implementation.

**The repair.** No cell carrying live once-only state is declared by a defining
form in `probe-identity.lisp` at all. The single carrier is

```lisp
(symbol-plist 'sa0-identity-carrier)
```

and the ordering argument is a property of the source rather than a hope about
scheduling:

1. the place is established by **interning**, before any form is evaluated;
2. it is **always bound**, so it has no unbound-to-bound transition and
   therefore no test that could be separated from a write;
3. `(sb-ext:cas (symbol-plist s) old new)` is a documented SBCL
   compare-and-swappable place (verified live on 2.4.6 before the design was
   chosen);
4. **this source contains no form that writes that place except one CAS** —
   mechanically checkable by grepping the file for `SYMBOL-PLIST`.

Every carrier CAS specifies `old = NIL`, so at most one can ever succeed. The
winner then gathers the epoch, builds the **complete state privately**, and
installs it with a **second CAS from `NIL`** on the cell's publication slot.
Non-owners wait on the cell's own waitqueue under a hard bound and return only
after observing that complete state; a **same-thread owner re-entry** is
detected by `EQ` on the owning thread and takes a documented deferred path that
does **not** claim ready. Initialization failure marks the cell and publishes
nothing. The former globals (`*image-epoch-hex*` and the rest) are now **symbol
macros with no value cell**, reading the one published record.

### Returned defect 2 — `DIGIT-CHAR-P` was too broad

`LAWFUL-COUNTER-TEXT-P` used `DIGIT-CHAR-P`, which on this runtime accepts
non-ASCII decimal characters, admitting several textual spellings where the
contract requires one. The predicate is now **explicit ASCII membership** — one
or more characters from `0123456789`, the first from `123456789` — tested with
`FIND`, which compares by `EQL`. No `DIGIT-CHAR-P`, no Unicode numeric property,
no locale classification, no `PARSE-INTEGER` as an admission predicate. The
epoch hexadecimal alphabet is the already accepted lowercase ASCII set and is
**not** reopened.

### The two schedule-pinned teeth

| tooth | what is pinned | what it closes |
|---|---|---|
| `INIT-STALE-SCHEDULE` | a two-party barrier puts **both** loaders past the pre-initial observation and before either election; a semaphore then holds the delayed one across the **entire** winning initialization and releases it afterwards | **clean arm loads the exact candidate source** and shows the winning cell and state unchanged by `EQ`, the delayed loader observing that same state, one epoch, one election, one allocator, no partial state, and subsequent allocations exactly `1..20`. **Planted arm** applies the same pin to a captive copy of the R3.2 law and prints the ruling's five observation lines, with the clobber and two distinct mutexes |
| `INIT-RECURSIVE-LOAD` | a test-only hook fires at `:ELECTED-BEFORE-PUBLICATION` — inside the winner's initialization, after the state exists privately and before it is reachable — and from it the **same thread** recursively `LOAD`s the same file once | hook really fired before publication, depth **2** reached, no deadlock and no host error **within a hard bound**, the inner invocation returning `:DEFERRED-OWNER-REENTRY` without claiming ready, one epoch, one election, one ready state and one allocator, the outermost load owning the sole transition to ready, first allocation `1`, and a later ordinary reload preserving the epoch and continuing the counter to `2` |

**A timeout is a failure, never a pass.** Every wait, every join and the outer
recursive load carry hard bounds; an expiry is printed and asserted against.

**Both teeth were shown biting before they were trusted.** With the carrier's
election CAS replaced by an unconditional overwrite, the stale tooth fails four
checks and exits nonzero; with owner re-entry no longer detected, the recursive
tooth fails three, reporting a bounded wait rather than hanging.

### Reclassifications and mislabels corrected

- the eight-thread `ALLOCATOR-INIT-RACE` arm is a **broad contention control**,
  retained and no longer offered as proof of the universal once-only law;
- the allocator's own top-level `(load *sa0-identity-path*)` and both freshness
  T4 reload arms were called **re-entrant**. They are **sequential reloads** —
  no load is in progress beneath them. Every such statement is corrected, and
  the word now names only what the recursive tooth does.

### An SBCL 2.4.6 constraint found by running, and recorded so nobody tidies it

`probe-identity.lisp` is **loaded concurrently by design**. A `DEFSTRUCT`
re-evaluated by one thread while another is inside the same redefinition makes
SBCL 2.4.6 signal `shouldn't happen: weird state of OLD-LAYOUT?` and kills the
loader that draws it — reproduced here with eight concurrent loaders. The state
record and the election cell are therefore **simple vectors** with accessor
functions: no class, no layout, nothing for a concurrent re-load to redefine,
and `(svref v i)` is still a documented CAS-able place, which the publication
point requires.

### What R3.3 does *not* claim

It closes **one named schedule** and **one named re-entry**, on this host, on
SBCL 2.4.6, at this parcel tip. It is not a proof of correctness under every
possible interleaving and no such proof is offered; the argument that
generalizes is the structural one above — the carrier has no defining form in
the candidate source, so there is no delayed initializer of *any* schedule that
could reach it. It grants no production standing, no adoption and no closure.

## The R3.3.1 exceptional-initialization closure (owner ruling, 2026-08-05)

`OWNER-RULING-R3.3-RETURN-AND-R3.3.1.md` is the governing law of this round. It
**locked** the canonical ASCII counter syntax, the delayed-`DEFGLOBAL` hostile
schedule and the genuine recursive `LOAD`, **returned** two defects in the
margins of the new carrier election, and ordered a **bounded repair** of two
unstable evidence lines. Everything R3.3 closed stays frozen; nothing here
reopens it.

### Returned defect 1 — the unprotected post-election interval

R3.3 ran `SA0-NOTE-ELECTION` **after** the election CAS and **before** entering
the protective `UNWIND-PROTECT`. A condition in that interval left *carrier
present, state absent, failure marker absent, observers waiting forever* — which
is R3.3-A clause 6 violated from the one direction clause 6 did not anticipate:
the image published neither a ready state nor a failure.

**The repair is not a smaller window.** The `UNWIND-PROTECT` is now established
**before the election is attempted**, so the election happens *inside* the
protected span and there is no post-election, pre-protection instruction at all
— the interval is empty as a property of the source's **shape**, checkable by
reading it. The cleanup flag is **armed before the compare and disarmed only by
proof of loss**: every schedule in which the election succeeded has cleanup
armed, no matter where a condition lands, and the only spurious cleanup writes a
marker onto a cell that was never installed and broadcasts on a queue nobody can
reach. The conservative direction is the safe one, which is why the flag starts
`T`.

### Returned defect 2 — the whole-plist-versus-`NIL` election

R3.3's election compared the carrier symbol's **entire property list** against
`NIL` while checking only **one** property. Any unrelated pre-existing property
made the compare unsatisfiable and initialization **spun for the life of the
image**.

The ruling admits two arms; this round takes the **total** one, and says why.
Failing immediately on a "invalid reserved carrier" would turn a benign
coexistence into a denial of service, and it would be a refusal derived from an
accident: nothing about an unrelated property makes the symbol unfit, because
the election only ever reads and writes **one indicator** on it. So the election
now reads one exact plist object, returns as a non-winner if the reserved
indicator is on it, and otherwise CASes **from that exact object** to the same
object with the indicator **consed on the front** — so unrelated properties
survive **by identity**, not by copy. Termination is argued, not hoped: a failed
compare means another agent completed a write, and the only such write this
source knows about installs the indicator, after which the next read exits as an
observer. The ceiling is stated where the loop is written: against a foreign
agent that rewrites the carrier's plist without end, no bound is claimed.

### The three deterministic teeth

| tooth | what is pinned | what it closes |
|---|---|---|
| `INIT-POST-ELECTION-FAILURE` | a two-party barrier puts both loaders past the pre-initial observation; the observer is held while the winner takes the election; at `:ELECTED-BEFORE-NOTE` — nothing noted, nothing gathered, nothing built — the winner releases the observer and then **waits until the observer has provably parked** on the cell's wait queue (the source's own `:BEFORE-WAIT` phase, under the cell mutex) before signalling the planted condition | the condition fired **in the named interval** (carrier already the winner's own cell; zero gatherings, zero elections noted, no state, no marker); the **failure marker is published**; **nothing else is** — no state, no readiness, and a reader is refused; the sleeper is **woken and told**, returning the definitive failure inside the bound; the image is **terminal** — a fresh attempt on the failing thread and on a brand-new thread both signal the same failure, neither hangs, neither elects. A labelled **replica** arm applies the identical condition at the identical point to a replica of the returned shape and leaves the sleeper **never woken**, with neither state nor marker |
| `INIT-PLIST-FOREIGN-PROPERTY` | two unrelated properties installed on the carrier symbol **before** the first load, and the load itself run under a hard bound because under the returned law it never returns | the election is **total**: the load completes, one election, one epoch, ready, and twenty allocations by four threads are exactly `1..20`; both unrelated properties survive **verbatim by `EQ`**, and the winning plist's **tail is the old plist object itself**. **Planted arm**: 1000 whole-plist-versus-`NIL` compares under the same precondition, **0 successes**, plist `EQ`-unchanged; then the returned loop executed under a small bound, still spinning at expiry, no cell installed |
| `INIT-PLIST-CONTENTION` | a hook fires in the exact window **between the read and the compare** and changes the plist there, on an otherwise **empty** carrier so the retry is caused by the injection and nothing else | the pre-compare phase fired **exactly twice** — two attempts, so exactly one compare was defeated and the loop re-read; the loop **converged** (one election, one epoch, ready, `1..20`); the mid-election property survived **verbatim**, the winning plist's tail being the exact object the injection produced. **Planted arm**: a single-shot election meeting the same change installs **nothing at all** |

**A timeout is a failure, never a pass — except where expiry *is* the finding.**
Arms that must succeed carry the 60-second hard bound. The two arms whose
expected outcome is a hang carry a deliberately small bound, and the bound is
the length of the exhibition rather than a threshold a correct run must beat;
each is labelled, and each asserts the expiry rather than tolerating it.

**Every tooth was shown biting.** The planted comparators are not descriptions:
the replica really left a sleeper unwoken, the returned compare really failed
1000/1000, the returned loop really ran 10⁸-order iterations without an exit,
and the single-shot election really installed nothing. Each section also carries
its own `--plant-failure` arm, and all three were shown failing the runner and
being refused by the verifier.

### The bounded evidence repair

Two unstable lines were disclosed against R3.3 and are repaired here, at the
point of emission rather than in a comparer's flags:

- **the gate-log order.** In a multi-loader arm the two pre-initial gate entries
  are recorded in whatever order the scheduler chose, so two runs at one tip can
  swap them. They are **not sorted** — printing an order that was not observed
  would be a fabricated determinism, and the log's whole job is to say what
  happened. The observed order is printed as observed and each per-entry line is
  marked `VOLATILE` **exactly when the log records more than one thread**, which
  is the condition under which inter-entry order is a scheduling artifact. A
  single-threaded log stays inside the comparison, and the count line is never
  volatile. (The two runs taken for this round exhibited the swap.)
- **the peer image's PID and epoch.** The two most obviously unstable values the
  lane produces — a new process id and sixteen fresh octets — carried no marker,
  because the marking discipline had been applied only where a *verifier* looks.
  A comparer excluding `VOLATILE` runs over the whole evidence directory. Both
  lines are now marked; `run-probe.sh`'s parser for the epoch moved to the new
  spelling in the same change, and the two must never drift.

### What R3.3.1 does *not* claim

It closes **one named interval**, **one named precondition** and **one re-read**,
on this host, on SBCL 2.4.6, at this parcel tip. The replica arm proves a
consequence of a **shape**, not a fact about the returned file — what the
returned file contained is checkable in the parcel's own history and is not
claimed here. No arm tests an unbounded stream of foreign writes to the carrier,
and the source does not claim one. It grants no production standing, no adoption
and no closure.

## Anchors — how the documents cite this transcript

The governed documents cite these transcripts by **stable grep-able anchor,
never by line number**. Every anchor below is guaranteed by the sources in this
directory. Anchors that existed at R0 are unchanged, so R0 citations survive;
the rest are additions.

| anchor | where | since |
|---|---|---|
| `PARCEL_TIP <tip>` | first and last-but-one line of every child block | R0 |
| `CHILD-EXIT <n>` | last line of every child block | R0 |
| `PROBE-SECTION-PASS <SECTION>` / `PROBE-SECTION-FAIL <SECTION>` | block footer | R0 |
| `END-OF-TRANSCRIPT <SECTION> CHECKS=<n> CASES=<m>` | block footer | R0 |
| `CASE NN  PROVIDER …  HEAD …  OPERATION …` | opens each matrix case | R0 |
| `FIXTURE-TEXT-BEGIN` / `FIXTURE-TEXT-END` | the quoted fixture, `\| `-prefixed | R0 |
| `END-CASE NN` | **closes** each matrix case | **R1** |
| `SOURCE probe-side depth` / `SOURCE probe-side nodes` / `SOURCE canonical octets` | per case | R0 |
| `EXPANSION probe-side depth` / `… nodes` / `EXPANSION canonical octets` | per minting case | R0 |
| `SOURCE-EXACTLY-REPRESENTABLE` / `EXPANSION-EXACTLY-REPRESENTABLE` | per case | R0 |
| `PROBE-SIDE-HOST-MEASUREMENT (DEPTH … NODES … UNINTERNED … SHARED-CONSES …)` | per refused case | R0 |
| `MACRO-CONDITION vs ACCOUNT-REFUSAL` | per case | R0 |
| `STOP case NN …` | the representability-stop summary | R0 |
| `CONTROL 1` … `CONTROL 7` headings | `CONTROLS-A` | R0 |
| `C6-PROVIDER S1` / `S2` … `END-C6-PROVIDER S1` / `S2` | opens/closes each control-6 provider block | **R1** |
| `C6-S1-STEP-1` … `C6-S1-STEP-9`, `C6-S2-STEP-1` … `C6-S2-STEP-9` | the nine-step matrix, in order | **R1** |
| `S1-STORED-*-BEFORE` / `-AFTER`, `S1-LIVE-*-BEFORE` / `-AFTER`, `S1-RECEIPT-IDENTITY-*`, `S1-SOURCE-IDENTITY-*`, `S1-OCCURRENCE-IDENTITY-*`, `S1-NEW-*` (and the `S2-` twins) | the measured values of control 6 | **R1** |
| `S2-VERIFY-RECEIPT-BEFORE` / `-AFTER [provider-recomputation]` | control 6 | **R1** |
| `C7-S2-EXACT-SHAPE` … `END-C7-S2-EXACT-SHAPE` | the tightened control-7 S2 block | **R1** |
| `C7-S2-MEASURED …` / `C7-S2-PLANTED-WRONG …` | the five shape fields and the jurisdiction of each arm | **R1** |
| `C7-S2-JURISDICTION-TABLE`, `C7-S2-CATALOGUE-ROWS`, `C7-S2-INTEGRITY-ALARM-ROWS`, `C7-S2-ACCOUNT-DOMAIN-ROWS`, `C7-S2-RE-SIGNAL-ROWS` | the category-first partition over S2's public catalogue | **R1** |
| `FRESHNESS-T1` / `-T2` / `-T3` … `END-FRESHNESS-T1` / `-T2` / `-T3` | opens/closes each freshness property block | **R1** |
| `FRESHNESS-T1-PLANTED`, `FRESHNESS-T2-PLANTED`, `FRESHNESS-T3-PLANTED` | the planted arm of each property | **R1** |
| `FRESHNESS-WITNESS-PID`, `FRESHNESS-WITNESS-EPOCH` | in `freshness-peer-image.txt`: the second image's identity and epoch | **R1** |
| `  [PASS] <label>` / `  [FAIL] <label>` | every recorded assertion, by its label — **unchanged, byte for byte** | R0 |
| `  CHECK-ID <ID>` | **immediately after every verdict line**: that assertion's stable external ID | **R2** |
| `SCHEMA-BRANCH <species>` … `END-SCHEMA-BRANCH <species>` | opens/closes each of the five schema-witness branches | **R2** |
| `  SCHEMA-DOC-DEVIATION <branch> <key> doc=… measured=…` | one line per key whose measured datum species disagrees with the schema file — **none in a clean run**; the line exists so a future disagreement is visible, not only counted | **R2** |
| `SCHEMA-DETAIL-CEILING` | the 1024-octet detail ceiling block | **R2** |
| `ALLOCATOR-CLEAN` / `ALLOCATOR-PLANTED` / `ALLOCATOR-SHAPE` … `END-ALLOCATOR-…` | opens/closes each allocator arm (**R3.1** replaced the deleted `OBSERVATION` arm with `SHAPE`) | **R2** |

Every check ID is itself an anchor, and the complete ordered list of them —
**490 IDs across the fourteen real sections (thirteen transcripts)** — is
`verify-sequences.txt`. **This census is recomputed from `verify-sequences.txt`
at every round that moves it, and stale figures are corrected rather than
carried**: at R3.3.1 the line read "413 IDs across the six real sections (five
transcripts)", which was the R3.2 count left standing when R3.3 added two
sections and four allocator checks, and the `ALLOCATOR` row below read 37 for
the same reason; at R3.3.2 it read "464 IDs across the eleven real sections (ten
transcripts)", which was the R3.3.1 count left standing when R3.3.2 added the
two sections above (11 + 8 = 19 new IDs); at R3.3.3 it read "483 IDs across the
thirteen real sections (twelve transcripts)", which was the R3.3.2 count, and
R3.3.3 adds one section of 7. The ID families a
citing document can rely on:

| ID family | count | section |
|---|---|---|
| `CASE-NN` / `END-CASE-NN`, `MATRIX-CASE-NN-SOURCE-REPRESENTABLE`, `MATRIX-CASE-NN-EXPANSION-OCTET-IDENTICAL`, `STOP-CASE-NN` | 14 cases | `POSITIVE-MATRIX` |
| `CONTROL-1` … `CONTROL-7`, `C1-…`, `C2-…`, `C3-…`, `C4-…`, `C5-…`, `C7-…`, `C7-S2-EXACT-SHAPE` / `END-C7-S2-EXACT-SHAPE`, `C7-S2-JURISDICTION-TABLE` | 70 IDs | `CONTROLS-A` |
| `C6-PROVIDER-S1` / `-S2`, `C6-S1-STEP-1` … `-9`, `C6-S2-STEP-1` … `-9`, `END-C6-PROVIDER-S1` / `-S2`, `C6-S2-VERIFY-RECEIPT-PROVIDER-RECOMPUTATION` | 51 IDs | `CONTROLS-B` |
| `FRESHNESS-T1` / `-T2` / `-T3` / `-T4`, `FRESHNESS-Tn-PLANTED`, `END-FRESHNESS-Tn`, `FRESHNESS-Tn-…` | 43 IDs | `FRESHNESS` |
| `SCHEMA-BRANCH-<species>`, `SCHEMA-<SPECIES>-{DATUM-P,ENVELOPE-KEY-SET,BODY-KEY-SET,VALUE-SPECIES,ROUND-TRIP,CANONICAL-REENCODING,NATIVE-PASSTHROUGH,NOT-RE-ADMITTED}`, `SCHEMA-TOOTH-…`, `SCHEMA-DETAIL-CEILING-…`, `SCHEMA-DOC-DEVIATION-DETECTOR-BITES`, `SCHEMA-DOC-DEVIATIONS-ENUMERATED`, `SCHEMA-S1-STOP-CELLS-…`, `SCHEMA-DOOR-1-CODES-RESTORED`, `SCHEMA-DETAIL-…` | 155 IDs | `SCHEMA-WITNESS` |
| `ALLOCATOR-CLEAN-…`, `ALLOCATOR-PLANTED-…`, `ALLOCATOR-DETECTOR-DISCRIMINATES`, `ALLOCATOR-EPOCH-…`, `ALLOCATOR-SHAPE-PREDICATE-…`, `ALLOCATOR-INIT-…` | 41 IDs | `ALLOCATOR` |
| `INIT-STALE-CLEAN-…`, `INIT-STALE-PLANTED-…`, `INIT-STALE-DISCRIMINATES` | 12 IDs | `INIT-STALE-SCHEDULE` |
| `INIT-RECURSIVE-…` | 11 IDs | `INIT-RECURSIVE-LOAD` |
| `INIT-PE-…` (including `INIT-PE-REPLICA-…` and `INIT-PE-DISCRIMINATES`) | 11 IDs | `INIT-POST-ELECTION-FAILURE` |
| `INIT-FOREIGN-…` (including `INIT-FOREIGN-PLANTED-…` and `INIT-FOREIGN-DISCRIMINATES`) | 7 IDs | `INIT-PLIST-FOREIGN-PROPERTY` |
| `INIT-CONTENTION-…` (including `INIT-CONTENTION-PLANTED-SINGLE-SHOT-LOSES` and `INIT-CONTENTION-DISCRIMINATES`) | 6 IDs | `INIT-PLIST-CONTENTION` |
| `INIT-PF-…` (including `INIT-PF-REPLICA-…` and `INIT-PF-DISCRIMINATES`) | 11 IDs | `INIT-PUBLICATION-FINALITY` |
| `INIT-CS-…` (including `INIT-CS-REPLICA-SILENTLY-PREPENDS-A-SECOND-INDICATOR` and `INIT-CS-DISCRIMINATES`) | 8 IDs | `INIT-CARRIER-SLOT` |
| `INIT-CT-…` (including `INIT-CT-REPLICA-…` and `INIT-CT-DISCRIMINATES`) | 7 IDs | `INIT-CARRIER-TOTALITY` |

## Determinism

Two runs of these sources at one parcel tip differ only in lines prefixed
`VOLATILE`. Compare with:

```sh
diff <(grep -v VOLATILE a/probe-transcript.txt) <(grep -v VOLATILE b/probe-transcript.txt)
```

**What is marked, and why it is not only the clock (R3.3.1).** The marker
covers the wall-clock stamp, the image epoch, the peer image's PID and epoch
(both marked at R3.3.1 — they are the most unstable values the lane produces and
had carried no marker, because the discipline had been applied only where a
*verifier* looks), the elapsed-seconds measurements, the spin-iteration count of
the expiry arms, and the **per-entry gate-log lines of any arm whose log records
more than one thread** — inter-thread recording order is a scheduling artifact
and two runs at one tip really do swap those lines. The gate log is **not
sorted** into stability: printing an unobserved order would be a fabricated
determinism. Everything else — counts, verdicts, IDs, structural lines and every
measured value — is inside the comparison.

**The check is over the whole evidence directory, not only the verified
transcripts:** `freshness-peer-image.txt` is not a transcript and is still
compared.

This is a statement about **repeated runs of this probe on this host**. It is
not a claim of general macroexpansion determinism, and none may be inferred.

## Files

| file | what it is |
|---|---|
| `probe-prelude.lisp` | banner, output helpers, probe-side host measures, fixture reader. Defines nothing in any `lisp-plus` package; lives in `CL-USER`. |
| `probe-matrix.lisp` | the positive matrix: 7 exact head keys × 2 declared operations = 14 cases. |
| `probe-controls.lisp` | fixed controls 1, 2, 3, 4, 5, 7 — section `CONTROLS-A`. |
| `probe-control-6.lisp` | fixed control 6 — section `CONTROLS-B`, alone in its own child image because it redefines provider declarations. |
| `probe-identity.lisp` | **R3.** The ONE shared performance-identifier constructor, the linearizable allocator, and the domain-separated identity bases (contract §II.3 as normalized by R3-B). Loaded by *both* `probe-freshness.lisp` and `probe-allocator.lisp`, which under R2 built two different and disagreeing shapes. **R3.3** replaced its state mechanism entirely: the R3.2 `DEFGLOBAL`-plus-CAS constellation is gone, and the once-only state is now **one immutable record published by a single CAS onto the property list of an interned symbol** — a place established by *interning*, always bound, CAS-able, and written by **no defining form in this source**, so no delayed unbound-to-bound write can reach it. The former globals survive only as **symbol macros that read the published record**. Survives reload; **touches neither provider**. **R3.3.1** repaired the two margins of that election: the protective `UNWIND-PROTECT` is now established **before** the election CAS (so no post-election instruction lies outside it) and the election is **total** — it compares against the exact plist object it just read and preserves every unrelated property by identity, instead of wagering the whole plist against `NIL`. **R3.3.2** closed the two defects the R3.3.1 return names, and changed nothing else: the separate `published` local flag is **deleted**, so the cleanup derives its disposition from **the publication slot itself** — the state and the failure token are both CAS-ed from `NIL` into **one** slot, which makes state-present and failure-present mutually exclusive by construction instead of by the order two branches are read in; and the reserved indicator's **presence is counted by an explicit plist walk** rather than inferred from `GETF`'s `NIL` default, with the value then adjudicated — exactly one lawful cell proceeds, while a `NIL` value, duplicate entries, a foreign value and a malformed property list are each **refused immediately, definitively and inside a bound**. The cell's two former slots are now one `DISPOSITION` slot; `SA0-CELL-STATE` and `SA0-CELL-FAILURE` keep their names and their meanings and are now complementary readings of that one slot. **R3.3.3** closes the one seam the R3.3.2 return names, and changes nothing else: that plist walk ran `while (consp tail)`, so it recognized **one** malformed face (an odd list) and read every other malformation as a lawful end — a non-`NIL` **atomic** tail terminated the scan silently, after which the election prepended its cell over the dotted tail and a later reader accepted the result, and a **circular** carrier never terminated the scan at all. **The walk is now total**: the five ways a property list can fail to be a proper even-length list are enumerated at `SA0-SCAN-RESERVED` (lawful `NIL` end; improper terminal tail; odd list; dotted value position; cycle), cycles are caught by an **`EQ`-identity visited set** whose termination argument is pigeonhole over the finitely many reachable conses and therefore holds for cycles of **any** period, and every face lands in the same bounded definitive refusal that leaves the carrier **exactly as it was found**. The adjudication, the publication mechanism and every other law in this file are unchanged. |
| `probe-freshness.lisp` | section `FRESHNESS` — the contract §II.3 mechanism demonstration, four arms T1–T4 discharging ruled proofs 3, 2, 5 and 4. **T4 is new in R3** and actually re-loads `probe-identity.lisp` in the same image to prove reload persistence. **Touches neither provider**; CD/0 public constructors and host facilities only. Run twice: once as the witness image, once as the section. **R3.3.1** marks the witness image's PID and epoch lines `VOLATILE` at the point of emission; `run-probe.sh`'s epoch parser moved to the new spelling in the same change. |
| `probe-schema-witness.lisp` | section `SCHEMA-WITNESS` — the CD/0 inspection-record schema witness. Constructs one genuinely lawful instance of every one of the five branches through the **public CD/0 API**, plus the two formerly-unencodable S2 classes (`:protocol-refusal`/`:expansion` and `:integrity-alarm`) as further lawful `s2-refusal` records, plus both locked S1 STOP cells (`DERIVE-CASE` and `DERIVE/2-CASE` under `:macroexpand`) as positive `s1-refusal` records with their actual string-valued upstream fields — nine in all. Carries the **R3-A full-exactness comparison law** and its teeth (wrong namespace, wrong path head, surplus path segment, wrong schema identity/version/species, unknown enum, unknown code, wrong code/phase pairing, contradicted derived standing). **R3.1-A**: the transcribed §§5.1-T/5.2-T enumerations are compared against each provider's own public catalogue as complete **(code, category, phase) triples** — every triple printed, both sides, difference empty in both directions — never as code-name sets; and the comparator carries its own two teeth, a category drift and a phase drift planted under an *unchanged* code name, each shown caught by the triple comparison while the code-name sets still agree. Touches the providers for the native datum samples §§4 and §6 require, and for the two refusal objects, which are minted through S2's own public doors. |
| `probe-allocator.lisp` | section `ALLOCATOR` — the concurrent allocator tooth. Host threads and CD/0 public constructors only; **touches neither provider**. |
| `probe-init-schedule.lisp` | **R3.3, the one new harness the commission authorizes.** Sections `INIT-STALE-SCHEDULE` and `INIT-RECURSIVE-LOAD`, one role per fresh image (`SA0_PROBE_SCHEDULE_ROLE`), because each tooth needs an image in which the candidate source has *never* been loaded. Nothing here is a thread count: every arm forces **one exact interleaving** with barriers and semaphores. **R3.3.1 adds three more roles in the same harness** — `post-election-failure`, `plist-foreign`, `plist-contention` (sections `INIT-POST-ELECTION-FAILURE`, `INIT-PLIST-FOREIGN-PROPERTY`, `INIT-PLIST-CONTENTION`) — again one fresh image each, and again for the same reason; the post-election role additionally *cannot* share an image because it leaves that image terminally failed on purpose. **R3.3.2 adds two more roles in the same harness** — `publication-finality` and `carrier-slot` (sections `INIT-PUBLICATION-FINALITY`, `INIT-CARRIER-SLOT`) — one fresh image each. `carrier-slot` is the one role that runs several arms in a single image, and the section prints the reason rather than assuming it: a **rejected** load holds no election, so it spends none of the one moment a first initialization needs; its lawful arm runs last and is the arm that spends it. R3.3.2 also **partitions the gate log by phase**, because the candidate source now declares a phase that fires *after* publication: the two R3.3 checks that asserted "every gate observation reports ready-p `NIL`" now assert that every **pre**-publication observation reports `NIL` **and** every **post**-publication observation reports `T` — identical on every phase class that existed when the old predicates were written, with a real new obligation on the post-publication class that did not exist then; same IDs, same positions, same profiles. **R3.3.3 adds one more role** — `carrier-total` (section `INIT-CARRIER-TOTALITY`) — one fresh image again. It is the **second** role that runs several arms in one image and the only one with **no lawful arm at all**: all three of its plants (an improper list, an improper list carrying one otherwise-lawful reserved cell, a circular list) are refused, so its image never spends the one moment a first initialization needs — which the section demonstrates rather than assumes, by restoring the carrier to empty at the end and reading the image-wide election and gathering counts back through the source's own readers. Host threads, host `LOAD` and the candidate probe source only; **touches neither provider**; writes nothing anywhere. |
| `run-probe.sh` | the one entry point. Enforces the output-directory boundary, operation-checks the toolchain, runs the children, concatenates, and verifies under explicit profiles. |
| `verify-transcript.sh` | the transcript verifier. Told its expectations; infers nothing. |
| `verify-profiles.txt` | the expected profiles: exact ordered sections, exact `CASES` **and exact `CHECKS`**. |
| `verify-grammar.txt` | **the closed grammar, as data**: every production, anchor, reserved token and fallback. Nothing inside a block is silently ignored. |
| `verify-sequences.txt` | **the exact ordered check-ID / anchor sequence of every section**, frozen. |
| `run-verifier-specimens.sh` | the verifier's own teeth: thirty-four crafted defects, each of which must be refused — two of them are output paths that must be refused *without leaving a directory behind*, and one builds a throwaway repository carrying a `refs/replace` mapping so that a tip naming no object at all can be shown being refused. |

## The discipline this probe holds itself to

**A gate that has never fired is untested, not passing.** Every control **shows
its planted arm firing** — the fault actually being detected — beside its clean
arm. For most controls the planted arm runs first; for the route-mutation
detector (Control 4) the quiescent clean arm necessarily runs first, because a
detector must be shown silent before the mutation is planted. Control 7's S2
assertion carries a **planted-wrong** arm: a genuinely different S2 refusal,
shown being *accepted* by the loose R0 predicate and *refused* by the tightened
R1 one. Control 6's step 5 asserts the redefinition **actually moved the live
values** before any later step is allowed to conclude anything. A green with
nothing behind it would be worth nothing.

**Operation-check first.** Before any long run, a trivial child prints
`(lisp-implementation-version)` through the exact invocation the probe uses. The
runner fails closed on anything but SBCL 2.4.6.

**The canary must be printed.** Route text and victim measurements land in
special variables that are printed before they are compared, because a discarded
read can be optimized away and the tooth would then silently never fire.

**Fixtures are read from strings at run time**, never written as quoted literals,
so that no literal coalescing can introduce the shared structure both providers
refuse — and so that the exact text presented is quotable in the transcript.

**Every fixture comes from a predecessor's own fixture or test file**, cited in
the comment above it. This probe invents no admitted form.

## The caught-condition partition (category first, then phase)

Wherever this probe partitions a caught S2 condition it reads the **category
first** and the phase only afterwards, per the owner adjudication:

```
:integrity-alarm                          -> re-signal the original unchanged
:protocol-refusal + :request / :perform   -> account domain
:protocol-refusal + :expansion / :runtime / anything unanticipated
                                          -> re-signal the original unchanged
```

An integrity alarm is **never** an account refusal, whatever its phase. The
sentence *"phase is the only separator"* survives only in its restricted form —
**restricted to S2 protocol-refusal rows** — and the transcript prints the
partition applied to every row of S2's own public catalogue, so the reader can
check its totality rather than trusting two sampled rows.

## What the probe refuses to say

- It never compares native receipt identities **across** providers.
- It infers no general macroexpansion determinism from repeated current-host
  results. Every measurement is one occurrence, in one image, on one host.
- Its recorded depth / node / octet maxima are **observations of fourteen
  fixtures**. They are not needed ceilings and not a proposed grammar bound.
- A lawful admitted source whose expansion the native provider cannot represent
  is recorded as a **STOP-AND-REPORT**, never as a reason to weaken anybody's
  grammar.
- The schema witness proves the schema is **constructible and exact**. It is not
  a claim that any inspector exists, and it cannot discharge the Account-side
  half of §8.6 because no Account package exists.
- The allocator tooth demonstrates **same-image** linearizability under real
  contention. It claims no cross-image uniqueness, and its bare-`INCF`
  observation arm asserts **no** collision count.
- Control 6's nine steps are asserted **for these two providers at this parcel
  tip**, through the `(setf fdefinition)` seam in a throwaway child. They do not
  simulate a source-level version bump, a reload, or a different build, and no
  claim about those is licensed here.
- `VERIFY-RECEIPT`'s continued `T` after redefinition is recorded as
  **`provider-recomputation` — declaration-independence**: it re-derives the
  stored source-form and expanded-form identity projections from the stored
  datums and consults no live declaration. The R0 gloss that it "recomputes
  against live declarations" is **withdrawn**, and no identity-trap reading of
  it survives in this directory.

## Host

Recorded in every transcript: `sbcl --version`, `lisp-implementation-type`,
`uname -a`. Supported and tested: SBCL 2.4.6 on Linux, and nothing else.
