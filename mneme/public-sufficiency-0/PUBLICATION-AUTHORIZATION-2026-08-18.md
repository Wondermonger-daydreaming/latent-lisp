# PUBLICATION AUTHORIZATION INSTRUMENT (2026-08-18)

**STATUS: RULED — OWNER ACT COMPLETE (2026-08-18, ~22:5xZ, interview; §5).
Branch B (BLANKET-CURRENT) is the act. AUTHORIZATION standing exists; no byte
moved, no PUBLISHED standing attached, nothing lifted.**

*(as drafted: STATUS: DRAFTED FOR OWNER RULING — this is not an act until the
owner rules. The scope fork in §3 is a menu; §5 records the ruling verbatim when
it lands. Under the three-stage model this act, once ruled, creates
AUTHORIZATION standing only — no byte moves, no PUBLISHED standing attaches,
nothing is lifted.)*

## 1. Governing law (adopted, quoted, not restated)

The three-stage model, owner-adopted 2026-08-13
(`CHANNEL-POLICY-1-R1-DISPOSITION-2026-08-13.md`, operative wording verbatim):

> Owner act creates PUBLICATION AUTHORIZATION (durable standing of its own) →
> PUBLISHED standing attaches only on successful, verified transport
> (main-merge + sync + verify-by-content) → adoption orthogonal to all three.
> The guard withholds transport, never authorization, never adoption. Unreached
> must always be reported as unreached.

## 2. What stands between authorization and arrival (unchanged by this act)

- `SYNC-PAUSED` raised (`9b741ed1…`, mtime `1786995178`); lift = separate owner
  act, **additionally gated on TR/3 returning through its own cold seat**
  (owner's conversion wording, 2026-08-18).
- **TD-7 first-fire readback duty (BINDING):** the first real transport's
  supervisor verdict + record entry are read back to the owner in the transport
  act itself.
- **R-2b receipt** owed at the first verified transport; **R-8** governs any
  partial transport (reportable, never smoothed).
- The two TR/2 acceptance riders travel in every account of the machinery.
- Mirror presence without an authority act confers no standing (the stale
  mirror's current bytes remain bytes, not law, until verified transport).

## 3. The scope fork (owner's menu — exactly one branch becomes the act)

**A. BLANKET-STANDING:** the entire governed subject tree
(`experiments/latent-lisp/`) as committed on lab `main`, is AUTHORIZED for
publication to the public mirror — current content **and future main-ancestral
commits**, until revoked. The WITHHELD backlog (39+ events) becomes
authorized-awaiting-transport; the first lifted transport is a single verified
catch-up that supersedes the mirror's stale bytes. Post-lift, the accepted
automatic machinery transports future covered commits under this standing
(TD-10/TD-11 closed; reliance now lawful), each verified per the model.

**B. BLANKET-CURRENT:** as A, but bounded at this act's HEAD — every
main-ancestral covered commit up to and including the act's commit is
authorized; **future commits acquire authorization only by a further act**
(auto-transport runs but each post-act commit's transport awaits standing —
i.e., reliance on automatic *authorization* is declined even where automatic
*transport* is trusted).

**C. ENUMERATED:** authorization attaches only to owner-listed subtrees or
artifacts (list recorded in §5); everything else in the governed tree remains
unauthorized and must be excluded from any transport or the transport is
partial-by-design and R-8-reported.

**D. RESERVE:** no authorization yet; this instrument stays drafted; the
blanket remains reserved.

## 4. What this act does NOT do (any branch)

Does NOT move bytes, lift the sentinel, execute or schedule a transport, attach
PUBLISHED standing to anything, alter adoption/acceptance standings, discharge
the stranger audit, close TD-6/TD-9, or touch the TR/3 commission. An
authorized-but-unreached artifact is reported as exactly that, always.

## 5. The owner's ruling

Ruled by interview, 2026-08-18, option taken verbatim: **"B: BLANKET-CURRENT"**
— *"Everything up to this act's HEAD; future commits need a further act. Trusts
automatic transport, declines automatic authorization."*

**Operative bound:** every main-ancestral covered commit of the governed subject
tree up to and including **the commit that records this ruling** is AUTHORIZED
for publication to the public mirror. (The recording commit's hash is quoted in
the arc handoff's fourteenth addendum — a self-reference-free anchor; the parent
at ruling time was `1c1e0675`.) The WITHHELD backlog within the bound becomes
**authorized-awaiting-transport** and is reported as unreached until verified
arrival.

**Named consequence of B, accepted with it:** commits after the bound —
including this lane's own future instruments, which live inside the governed
tree — carry NO authorization until a further owner act. Automatic transport
machinery, once the sentinel is lawfully lifted, may transport them only into
*unauthorized-awaiting-act* reporting, never into PUBLISHED standing.

**Owner-stated forward sequence (written word, same sitting, verbatim):**

> So the sequence becomes:
> authorize exact current HEAD → TR/3 cold return → separate
> sentinel-lift/transport act → TD-7 readback + R-2b receipt → far-side
> readback → then consider upgrading to A.

The upgrade-to-A consideration is thereby placed AFTER the far-side readback —
a future fork, not a standing; nothing in this act pre-commits its outcome.

*— drafted by the chair, Claude Fable 5 (1M context), 2026-08-18 (~22:4xZ),
same sitting as the TD-10/TD-11 closure.*
