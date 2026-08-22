# CHANNEL POLICY /1 — the latent-lisp public mirror — CANDIDATE (NOT ADOPTED)

**Standing: CANDIDATE — not adopted; not self-ratifying; operative only upon
an owner adoption act naming this policy-identity. Transport of this text to
any mirror confers nothing (anti-bootstrap, §4). On adoption it SUPERSEDES
the held draft `CHANNEL-POLICY-latent-lisp-mirror-DRAFT.md` as the
prospective policy; the held draft remains untouched historical evidence.
Drafted under the R-1 owner disposition
(`mneme/public-sufficiency-0/CHANNEL-POLICY-1-R1-DISPOSITION-2026-08-13.md`),
whose exact wording controls wherever this text could be read two ways.
Author: Claude Fable 5, 2026-08-13. Drafting report:
`mneme/public-sufficiency-0/CHANNEL-POLICY-1-DRAFTING-PARCEL-0-RETURN.md`.**

*Succession: this text is the cold-read blocker-repair successor (2026-08-13)
of candidate blob `587fe4f1` (itself successor of `27f51c57`); predecessors
remain in Git custody, unrewritten.*

---

## §0 The channel (normative domain — carried from the held draft's authoritative scope; its rejected publication model is NOT revived)

- **Channel identity:** `latent-lisp-public-mirror`.
- **Source scope:** `experiments/latent-lisp/**` in the lab repository.
- **Excluded from the channel:** `experiments/latent-lisp/_staging/**` and
  `.git/**`.
- **Destination:** `github.com/Wondermonger-daydreaming/latent-lisp`,
  branch `main`, visibility world-readable (public).

An object is **in the channel's domain** iff its identity — the object or
source path, independent of any authorization — lies within the source
scope and not within an exclusion. **Domain membership never depends on
publication authorization** (an in-scope unauthorized object is in the
domain; its states are §1/§6's, never INAPPLICABLE). Every use of "source
scope," "destination," "enlarging source scope," "altering destination,"
and "outside the channel's domain" in this policy refers to these
declarations. Amendment of any of them is governed by §4. Nothing in this
section makes a commit a publication act.

## §1 The state vocabulary (nothing here collapses; "published" has ONE sense)

| State | Kind | Created by | Proven by | Superseded/lost by |
|---|---|---|---|---|
| **adopted / accepted** | normative standing | the relevant owner act on an object identity | the filed instrument | a later owner act only |
| **publication-authorized** | normative standing (durable) | an explicit owner act authorizing publication of named object identities | the filed authorization | a later owner act only — never by the guard, never by transport failure |
| **main-reachable** | mechanical fact | git merge into `main`'s ancestry | `git merge-base --is-ancestor` | history surgery (out of policy scope) |
| **transported** (mirror-synchronized) | mechanical event | the sync machinery moving committed-subject-tree bytes to the mirror (authorization NOT required for this state to exist) | transport success **and** post-transport content verification (§5) | a later sync; mirror-side interference (a defect, §7) |
| **publicly-retrievable** | observable availability | the mirror host serving the bytes | an actual retrieval (e.g. a fresh clone) | host/mirror failure |
| **PUBLISHED** | normative standing | **nothing but the conjunction: publication-authorized ∧ the authorized identity entered source `main` ancestry (the ruled main-merge component) ∧ verified transport of those authorized bytes** | the §5 minimum evidence — main-ancestry entry included — AND the sufficiency/receipt standard to be supplied by R-2b (open; until R-2b is ruled, §5-minimum alone attaches no new PUBLISHED standing) | supersession by a later published version; never silently |

**Adoption/acceptance is orthogonal to all publication states.** An object
may be adopted and never authorized; authorized and never transported;
transported and never authorized (bytes, not law).

**INAPPLICABLE / not-in-channel** *(a report state, not a standing; added
per the R-4 disposition)*: an object **outside the §0 domain** — outside
the source scope, or within an exclusion such as
`experiments/latent-lisp/_staging/**` — is reported **INAPPLICABLE**,
never as a publication failure. No publication state applies to it; its
other standings are untouched. **Current absence of bytes does not by
itself place an object outside the domain:** an in-domain object whose
bytes are presently absent, stranded, or unreached is reported at the
strongest state the evidence supports (e.g. *authorized, unpublished,
unreached* — or *transport unproved*), never INAPPLICABLE.

## §2 The R-1 law — VERBATIM CARRIAGE

The operative wording of the owner's R-1 disposition, quoted exactly:

> Owner act creates PUBLICATION AUTHORIZATION (durable standing of its
> own) → PUBLISHED standing attaches only on successful, verified
> transport (main-merge + sync + verify-by-content) → adoption orthogonal
> to all three. The guard withholds transport, never authorization, never
> adoption. Unreached must always be reported as unreached (generalizing
> the adopted §10 duty). All four load-bearing facts of the record stay
> lawful as they stand; "adopted-but-failed-to-publish" becomes lawful
> vocabulary; the PS/0 readback takes its honest form.

And the disposition's ruled consequence bearing on transport tooling,
quoted exactly:

> **TD-7 and TD-8** (hook discards sync exit; stale post-merge hook) are
> now defects against a *defined duty* and sit on the exact path of any
> future publication act — repair before any branch→main merge.

### §2b Restatement and consequences (NOT quotation; the quoted law above controls)

1. An owner act creates **publication authorization** — a durable standing
   of its own.
2. **Published standing attaches only after successful, verified
   transport of the authorized bytes** (main-merge + sync +
   verify-by-content).
3. **Adoption is orthogonal** to authorization, transport, and published
   standing.
4. **The main-ancestry guard withholds transport** — and thereby the
   precondition of published standing — but **never revokes or withholds
   adoption, and never revokes or withholds publication authorization.**
5. **Mirror presence without an authority act creates no normative
   standing of any kind.**
6. **An unreached authorized object must always be reported as authorized
   but unpublished / unreached.** *Unreached is always reported as
   unreached.*

## §3 Prohibited substitutions (each a distinct error; none may be silent)

committed ≠ published · branch-local ≠ published · main-reachable ≠
published · authorization ≠ publication · sync-attempted ≠ publication ·
mirror presence without authorization ≠ publication-as-law · adoption ≠
publication. Future/current classification under this policy uses these
terms only as §1 defines them; **historical documents using "published" in
older senses are not rewritten** — current-state reporting of historical
artifacts is governed by the ruled R-4 commencement-and-savings law,
carried at §8.

## §4 Authority over the channel (carried from the held draft where still valid)

- **Authorized principals, and what their authority actually is** (list
  carried; powers stated per R-1): the owner; lab chair sessions (Fable
  line and successors, lab harness); the six sibling profiles (shared
  harness, repo-root cwd); Codex workers **only through adoption into the
  lab tree** (the mirror-clobber law). **Powers: only the OWNER may create
  publication authorization (an explicit owner act on object identity,
  per §2) or amend this policy and the §0 domain. Every other listed
  principal holds OPERATOR authority only** — to prepare in-scope
  material, integrate it, invoke transport, and verify, acting on the
  channel solely within authority actually granted by controlling owner
  acts and this policy. Operating the channel creates no publication
  authorization; the predecessor's implication that crossing the frontier
  is thereby publishing **does not survive**. Where an operational power
  is not fixed by controlling authority, the principal does not hold it.
- **Content prohibitions** (carried, binding every principal): no
  scoring-key content; no Language-A item content; no subject outputs; no
  per-item findings; no live credentials.
- **Amendment** (adapted): enlarging source scope, principals, or
  destination requires a **new policy-identity adopted by the owner** — no
  silent enlargement (A-3).
- **Review trigger** (adapted, with a discharge mechanism the held draft
  lacked): any change to the transport machinery's semantics obliges,
  BEFORE the changed machinery runs, either a successor policy candidate
  or a dated policy-erratum noting the divergence; the obligation is
  discharged by that filing, and an undischarged trigger is a reportable
  defect, not a lapse to be discovered later.
- **Anti-bootstrap** (carried and sharpened): this policy cannot make
  itself operative; no transport, no sync, no mirror state, and no clause
  of this text can substitute for the owner's adoption act.

## §5 Transport evidence (what "verified" minimally requires)

Published standing attaches only when ALL of the following exist together,
for the specific authorized bytes:

1. **Authorized source identity** — the lab commit and subject-subtree
   identity of what the owner authorized;
2. **Main-ancestry entry** — evidence that the authorized identity entered
   the source repository's `main` ancestry (the ruled main-merge
   component of §2's verified transport; a guard's current existence is
   machinery, never this evidence);
3. **Transport success** — the sync completed without error for that
   source *(note: the machinery's current inability to surface this —
   TD-7 — makes this an UNIMPLEMENTED obligation, §7; it does not weaken
   the requirement)*;
4. **Post-transport content verification** — a by-content comparison of
   the mirror's served tree against the authorized subject tree
   (the `verify-sync` discipline: materialize both sides; never trust a
   sync commit message);
5. **A publication receipt** recording 1–4.

**Residual (owner fork R-2b, §9):** whether this five-part form is the
SUFFICIENT standard — and the receipt's exact required content — is not
decided here; R-1 fixes that verification is *necessary*, and this section
states the least that "verified" can mean. A sync process exiting, or a
hook firing, is not publication evidence under any reading.

## §6 Failure states (each reported in exactly these terms; never as bare "published")

| State | What stands | What does not attach |
|---|---|---|
| authorized + unreached | authorization | published standing; **report: "authorized, unpublished, unreached"** |
| authorized + transport failed | authorization | published standing; the failure is itself reportable |
| authorized + stale predecessor still public | the predecessor's published standing (at its version); the successor's authorization | the successor's published standing; **report the staleness** |
| unauthorized bytes on the mirror | every independently originating standing the object may hold (adoption, acceptance, candidate, historical — each governed by its own instrument) | **publication standing from transport** — presence adds no standing and removes none; the bytes are removable; history retains them (a fact, not a standing) |
| adopted, not publication-authorized | adoption | authorization and everything downstream; lawful state, not a defect |
| candidate/non-normative but publicly retrievable | availability only; its own banners govern | any normative standing from presence |
| outside the channel's §0 domain (outside source scope, or within an exclusion) | every standing its originating instruments confer | no publication state applies — **report: "INAPPLICABLE (not in channel)"**, never a failure. An in-domain object with absent/unreached bytes is NOT this state (§1: report the strongest evidenced state) |

## §7 The machinery (DESCRIPTIVE; the norms above bind it, not vice versa)

Current transport: post-commit hook → `sync.sh` → `git archive` of the
**committed subject tree** (never the working tree) → mirror `main`;
main-ancestry guard (transport refused off `main`'s ancestry);
`SYNC-PAUSED` sentinel halts transport; `_staging/**` and `.git/**`
excluded from the channel (the off-mirror protocol remains a separate,
stricter channel). **This section describes; it does not sanctify.** The
following policy obligations are **presently UNIMPLEMENTED or violated
pending the open tooling docket (TD-6..TD-9), recorded here so the gap
cannot be read as compliance:** exclusive-writer expectation for the
mirror (TD-6: unprotected mirror `main`, historical direct commits);
transport-failure surfacing for §5.3 (TD-7: exit status discarded);
merge-path commit identification (TD-8: stale post-merge hook);
durable, portable withholding records for §2b.6 reporting (TD-9:
host-local log). **Per the R-1 disposition's ruled consequence (quoted at
§2): TD-7 AND TD-8 must BOTH be repaired before ANY branch→`main` merge
covered by that ruling — the prohibition is on the merge itself, not
merely on a publication act.** A clause this machinery cannot yet satisfy
stays law; the machinery carries the defect.

## §8 Commencement and savings (the R-4 disposition, 2026-08-13, carried exactly)

1. Channel Policy /1 becomes normatively operative upon the owner's
   adoption act naming its exact policy identity — regardless of whether
   the policy text has itself been published.
2. Operation is prospective. No historical instrument, act, event, or
   standing is rewritten, created, removed, validated, or invalidated.
3. From the effective date, CURRENT publication-state reports use the
   policy's §1 vocabulary for all artifacts, old and new, **where
   surviving evidence supports the classification**; where it does not,
   the report states the exact uncertainty (*authorization unproved ·
   transport unproved · historical publication state unresolved*) — and
   an object outside the channel's domain is reported **INAPPLICABLE**,
   never as a failure.
4. No classification under (3) may manufacture authorization or
   transport, erase an originating standing, convert a historical defect
   into compliance, or apply a later evidence requirement to an earlier
   event.
5. Historical uses of "published" keep their contemporaneous meaning where
   they stand; they are quoted, never rewritten; current reports may note,
   without correction, that a historical usage predates this policy.
6. Expressly not decided: R-3, R-8, R-2b; and the publication
   authorization of any existing artifact (any such authorization is a
   separate, prospective owner act — including, if the owner wishes, a
   blanket authorization for the presently main-reachable corpus, which
   this ruling neither performs nor presumes).

**Policy consequence (separately authorized by the R-4 act's clause (7)
reform, distinct from the six adopted clauses above): mirror presence
alone confers no standing; no historical standing is altered by this
rule.** The standing of every existing artifact remains determined by its
originating instruments.

## §9 Residual owner forks (deliberately NOT decided by this candidate)

- **R-3 residual:** must a published artifact carry or be accompanied by a
  machine/human-readable standing marker? *(R-1 already settles that
  presence confers nothing.)*
- **R-8:** the policy treatment of a public executable with
  unavailable/private dependencies (tractable as reportable partial
  transport; exact treatment open).
- **R-2b:** the sufficiency standard and receipt form for §5.

*(R-4 was ruled 2026-08-13 — Option B — and its six adopted clauses are
carried verbatim at §8, clause 6 included; none of the remaining residuals
blocks adoption.)*

*— CANDIDATE; not adopted; drafted at the R-1 form and confined to it —*
