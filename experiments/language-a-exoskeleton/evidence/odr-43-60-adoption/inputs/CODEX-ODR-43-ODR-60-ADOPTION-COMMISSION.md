# CODEX COMMISSION — INSTANTIATE ADOPTED ODR-43 AND ODR-60

Repository:

    https://github.com/Wondermonger-daydreaming/latent-lisp

## AUTHORITATIVE INPUTS

Verify and read in full:

```text
LANGUAGE-A-ODR-43-ODR-60-OWNER-ADOPTION-RULING.md
bytes:   7944
sha256:  c9b29194c7ccf8ea80ffc1c1a8d08e1fa3839ca2bc05395500960d8a5c94ec16

FABLE-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md
bytes:   7357
sha256:  17d6e04dee9eb3abfbb4321293d5779d4927d40968810c567cbe7c77d7254d18

SOL-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md
bytes:   6323
sha256:  9e2c8fe099fdbd3fdc434cd8e26e678e8128057288c8409c9925920e27199d13

LANGUAGE-A-PREAUTHORSHIP-REPAIR-0.2.1-OWNER-REVERIFICATION.md
sha256:  4218c1d64aa6ddee6d1e090011917d0da9f573e5d541471fe7fd01f815fb0b6c
```

Stop on any identity mismatch.

Do not use a loose owner task-list file, conversation reconstruction, Fable
draft commission, Sol draft commission, or summary as a substitute for the
exact inputs above.

## BASE IDENTITY

Base exactly on:

```text
branch:
    origin/codex/language-a-emission-pilot-preauthorship-repair-0.2.1

commit:
    18189fcde68dfc110c0e95a82d2a9ef220bc98e9

tree:
    645c1b8a778dd30b0a640e88b9fcca2281ec1c06
```

Create and push only:

```text
codex/language-a-emission-pilot-odr-43-60-adoption
```

Use a fresh clean worktree.

Before modification:

1. fetch remote;
2. verify base commit/tree;
3. verify direct remote ref;
4. verify ancestry and protected-scope diff;
5. record unique current unresolved heads for ODR-43 and ODR-60, including
   record IDs, exact canonical byte lengths, and record digests.

Do not modify main, any repair branch, reviewed predecessor, or protected
scope. Do not merge to main.

## REQUIRED IMPLEMENTATION

### Preserve history

Preserve byte-for-byte:

- every historical ODR-43 and ODR-60 record;
- every schema version cited by historical records;
- every prior lineage event;
- the unique current unresolved heads.

No in-place status edit, payload replacement, schema reinterpretation, or stale
branch from an earlier unresolved head is permitted.

### ODR-43 adopted successor

Create one new adopted successor of the unique current unresolved ODR-43 head.

It must:

- use a new record ID;
- bind the exact current unresolved-head record digest;
- preserve the unresolved predecessor;
- bind the exact owner ruling and both disclosure identities;
- instantiate Tomás as owner, freezer, and substantive overlap/taint auditor;
- instantiate Codex as mechanical validation assistant without substantive
  freezer authority;
- instantiate Fable and Sol with the exact family assignments;
- instantiate reciprocal public/frozen-surface cross-review;
- forbid author exchange of sealed dossiers;
- represent apparatus reads and bounded unknowns exactly from each disclosure;
- create graph-resolved actor, read, prior-exposure, shared-root, authority, and
  restriction records;
- instantiate exactly one exposure declaration for each class per author:
  `item-specific-answer`, `private-key`, `target-output`;
- record the standing `none at adoption` without claiming absence outside the
  bounded disclosure;
- set blindness and independence claims false;
- include all claims explicitly not made;
- include all role-specific restrictions;
- bind the exact gate closed;
- create a dedicated owner-adoption lineage event.

Do not invent exact reads, sessions, item exposure, or private-key exposure
beyond the disclosures. Encode bounded unknowns as bounded unknowns.

### ODR-60 adopted successor

Create one new adopted successor of the unique current unresolved ODR-60 head.

It must:

- use a new record ID;
- bind the exact current unresolved-head record digest;
- preserve the unresolved predecessor and its candidate payload;
- copy the exact candidate payload into the adopted payload only after proving
  it exactly matches the owner ruling;
- retain all 24 item rows, exact roles, tags, and derived totals;
- create a dedicated owner-adoption lineage event;
- bind the exact gate closed.

Any semantic mismatch between the current candidate payload and the ruling is:

```text
BLOCK — ODR-60 ADOPTION PAYLOAD MISMATCH
```

Do not repair the payload by convenient reinterpretation.

### Drafting and commission standing

After valid typed adoption:

```text
ODR-43 ADOPTED
ODR-60 ADOPTED
ELIGIBLE FOR OWNER ISSUANCE OF ITEM-AUTHOR COMMISSIONS
```

Do not create or issue the item-author commissions in this task.
Do not begin substantive drafting or target-specific source reconnaissance.

## TESTS AND MUTATIONS

Preserve all 111 existing mutation IDs and results.

Add and execute targeted mutations for at least:

- adoption from a stale unresolved head;
- reused unresolved record ID;
- wrong predecessor digest;
- absent unresolved predecessor;
- missing owner-adoption event;
- wrong owner jurisdiction;
- wrong Fable family assignment;
- wrong Sol family assignment;
- absent reciprocal cross-review;
- sealed dossier shared with the other author;
- missing freezer/overlap auditor;
- Codex given substantive freezer authority;
- one missing ODR-43 exposure class;
- duplicated ODR-43 exposure class;
- dangling disclosure/read/exposure/shared-root reference;
- blindness or independence claim set true;
- missing claims-not-made entry;
- missing role-specific restriction;
- ODR-60 candidate/adopted payload mismatch;
- changed ODR-60 row;
- stored total inconsistent with derived rows;
- unresolved record still closing the drafting gate;
- duplicate current head after adoption;
- mutation declared but unexecuted;
- mutation executed but undeclared.

Every declared mutation must execute and be killed by its expected typed
condition. `declared_unexecuted` and `undeclared_executed` must be empty.

Run two fresh targeted verification passes.

## BOUNDARIES

Do not:

- create real item text;
- perform target-specific source reconnaissance;
- create real source packets, dossiers, or renderings;
- issue Fable or Sol commissions;
- create private-key content;
- implement Tranche B;
- implement scoring;
- choose thresholds;
- create provider routes;
- make provider calls;
- authorize freeze, scoring, or exposure;
- modify protected scope;
- inspect or package loose owner files.

## EVIDENCE

Track:

- all four exact authoritative inputs;
- input custody and precedence;
- base and successor identities;
- changed-file inventory;
- protected-scope diff;
- current unresolved-head identities;
- adopted-successor identities;
- exact predecessor closure;
- owner-adoption lineage events;
- actor/read/exposure/shared-root graph closure;
- ODR-43 payload adjudication;
- ODR-60 payload equality adjudication;
- mutation registry succession and complete results;
- two fresh verification runs with runtime identity and exact commands;
- no real content, key, scorer, provider, target output, freeze, or exposure;
- final Git and cleanup receipts.

## COMMIT, PUSH, VERIFY, CLEAN

Create one bounded commit, push only the successor branch, fetch, and verify
local, remote-tracking, and direct remote-ref commit/tree equality. Confirm base
is exact merge base, protected diff empty, main/repair branches unchanged, and
worktree clean.

Remove only task-generated detritus after remote verification. Preserve
tracked evidence, failed append-only evidence, unrelated files/worktrees,
pre-existing sidecars, and loose owner inputs. Remove the temporary worktree.

Do not create a review ZIP unless separately commissioned.

## SUCCESS STATUS

Report only after successful commit, push, remote verification, and cleanup:

```text
ODR-43 ADOPTION RECORD INSTANTIATED
ODR-60 ADOPTION RECORD INSTANTIATED
ODR-43 ADOPTED
ODR-60 ADOPTED
ELIGIBLE FOR OWNER ISSUANCE OF FABLE AND SOL ITEM-AUTHOR COMMISSIONS
SUBSTANTIVE ITEM DRAFTING NOT YET COMMISSIONED
PRIVATE KEY AUTHORSHIP NOT AUTHORIZED
PACKET FREEZE NOT AUTHORIZED
TARGET SCORING NOT AUTHORIZED
LIVE EXPOSURE NOT AUTHORIZED
```

Also report actual mutation count, final commit/tree, remote identity,
protected-scope result, and cleanup result.

On ambiguity, stop:

```text
BLOCK — ODR-43/ODR-60 ADOPTION AUTHORITY GAP NAMED
```
