# ONE ACT /0 — OWNER RULING R2.3 (2026-08-08, direct): PROMOTION CLOSURE

*Received in-session 2026-08-08 ~01:4x −03, direct owner instrument, [R] tier.
Verbatim below; chair reception note follows.*

---

## Verbatim ruling

OWNER RULING — ONE ACT /0 R2.3 PROMOTION CLOSURE

R2.2 LOADER-FINALITY IS ACCEPTED AND LOCKED.

Do not reopen derived identity, B-R, D2, the 63 vectors, V-F1…V-F5,
dispatch binding, the D1-refusal disposition, or any predecessor semantics.

Promotion remains withheld for the following confined closure.

1. CLOSE THE PHANTOM SYSTEM EXPORT

LISP-PLUS-SYSTEM exports ACT0-LANE-FILES, but it has no function, variable,
or class binding.

Define it as a function returning a fresh copy of the four ordered lane
source paths:

  package.lisp
  act0-fixtures.lisp
  act0.lisp
  act0-gates.lisp

It must never expose the mutable list held by +ACT0-LANE-SOURCES+.

Add permanent witnesses that:

- ACT0-LANE-FILES is :EXTERNAL and FBOUNDP;
- it returns exactly the declared four paths in order;
- two calls return EQUAL but non-EQ lists;
- every LISP-PLUS-SYSTEM external has at least one appropriate binding
  (FBOUNDP, BOUNDP, or FIND-CLASS).

2. SHIP THE CANONICAL 173-CHECK RUNNER

Add:

  mneme/language-act-0/act0-selftest.lisp

It must:

- run from a fresh SBCL 2.4.6 image;
- load lisp-plus/act0 through ASDF;
- create its run root outside the subject tree;
- execute the exact accepted gate order;
- keep H-AP0-COLLIDE last;
- clean its temporary root on success and failure;
- print a stable terminal sentinel:

  oneact0-selftest: 173 checks, 0 failures

- exit nonzero on any failed check;
- contain a planted-fault harness tooth proving that nonzero exit and
  sentinel refusal occur when one check is deliberately infected.

Do not add the selftest to the four-source loader. ACT0-GATES.LISP remains
the last-loaded source and its readiness carrier remains its last form.

3. PUT ONE ACT INSIDE THE RELEASE FLOOR

Register exactly these candidate gates in mneme/verify-release.sh:

- act0-selftest.lisp;
- act0-load-witnesses.sh;
- act0-loader-disease.sh.

The current full floor is 94 gates. With these three entries, the expected
full count is 97; the current light floor is 76, and with the selftest entry
its expected count is 77. Recompute mechanically and fail if the actual
enumeration differs.

Replace the carried claim that the derive/perform seam is ABSENT. State
accurately that One Act /0 supplies the executable candidate seam and that
execution does not itself confer adoption.

The umbrella need not acquire an automatic One Act row in this round.
The standalone lisp-plus/act0 door remains canonical; umbrella coexistence
must nevertheless remain 173/173.

4. REPRODUCE THE LOCKED RESULTS

Require:

- act0 selftest 173/173 twice, byte-identical;
- umbrella coexistence 173/173;
- all 63 vectors unchanged;
- V-F table sha256 still
  2b51b4df26fe0fa1e4a156f9408a92f5a501aba9fa2401eb08e10a123f1264f0;
- six loader witnesses green at their newly amended count;
- every disease/control pair green;
- full release floor 97/97;
- light release floor 77/77;
- checkout clean after every campaign.

5. RETURN AN OWNER-VERIFIABLE OBJECT CLOSURE

The present thin bundle is internally authentic relative to prerequisite
725f67584b82ca49ae27cad4bf71b592c87137af, but that prerequisite is not
available in the public latent-lisp mirror or the returned parcel.

For the new tip, return either:

- a self-contained Git bundle; or
- the candidate bundle plus an exact prerequisite object closure.

A fresh empty repository using only returned artifacts must be able to run
git bundle verify and materialize the candidate tree. Correct the claim that
Claude-Code-Lab is publicly reachable if it remains private.

6. ASSEMBLE — DO NOT RUN — THE STRANGER PACKET

After R2.3 is green, mechanically assemble the off-mirror packet required by
mneme/architecture/STRANGER-AUDIT-RECRUIT-SPEC.md.

It must contain artifacts, source, fixtures, laws, manifests, and the canonical
runner, but no diaries, builder logs, owner opinions, model correspondence, or
resident interpretation.

Include a prior-exposure declaration that must be answered before the packet
is opened, followed by the charge:

  Remove primitives. For each core entity, argue it can be a library,
  a special case of another, or nothing. The authors expect you to cut
  something; finding nothing to cut is reportable but suspicious.
  Start where the document is most confident.

Do not run the audit through Fable, a sibling, Hermes, this lab harness,
GPT-5.6, or any already-exposed instance. The human courier must deliver it
directly to a fresh qualifying non-Claude, non-GPT-5.6 model. A positive
exposure declaration VOIDs that candidate.

Return the sealed R2.3 repair and the stranger packet. Do not merge, publish,
move staging, or delete anything.

OWNER DISPOSITION:

R2.2 ACCEPTED AND LOCKED.
R2.3 PROMOTION-CLOSURE REPAIR AUTHORIZED.
STRANGER AUDIT COMMISSIONED AFTER GREEN R2.3.
ADOPTION, MERGE, AND PUBLICATION NOT AUTHORIZED.
D1-REFUSAL ARM REMAINS CLOSED FOR /0.
HOUSEKEEPING MOVEMENT AND DELETION UNAUTHORIZED.
SURFACE /3 REMAINS SHUT.

---

## Chair reception note (Claude Fable 5, 2026-08-08)

**Standing:** direct owner instrument. R2.2 LOCKED; six confined items; the
stranger audit is commissioned but ASSEMBLY-ONLY this round (the courier is
human; the auditor must be a fresh non-Claude, non-GPT-5.6 model; a positive
prior-exposure declaration VOIDs the candidate — the harness-is-exposure rule
in its strongest form).

**Chair verifications on receipt:**
- Phantom export CONFIRMED in the live tree: `#:act0-lane-files` exported
  (lisp-plus.asd:129) with no defun/defvar/defclass anywhere;
  `+act0-lane-sources+` is a defparameter (mutable) at :311.
- **Claude-Code-Lab is PRIVATE** (gh: `"visibility":"PRIVATE"`) — the R2.2
  BUNDLE-NOTE's claim that the prerequisite is available "on public main of
  Wondermonger-daydreaming/Claude-Code-Lab" was WRONG and is hereby corrected
  on the record (this note; carried into the R2.3 receipt). Consequence
  adopted: the R2.3 closure will be a SELF-CONTAINED bundle (or bundle +
  exact prerequisite closure) verifiable in a fresh empty repository from
  returned artifacts alone.
- `mneme/architecture/STRANGER-AUDIT-RECRUIT-SPEC.md` exists in the tree and
  governs item 6's packet shape.

**Round name: R2.3 (promotion closure).** Records use `oneact-r23-*`
(NB: distinct from the historical `r43-*` Surface Account files).
