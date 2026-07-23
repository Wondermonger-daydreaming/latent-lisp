# LANGUAGE-SLICE-0-CLOSURE — the slice, closed

*Closure sitting, 2026-07-23. This artifact banks the final disposition
with its evidence, states what the fragment is and is not, and lists
Slice /1 candidates without authorizing any. Earlier specimen verdicts
stand where banked (`de-promotione/DISPOSITION.md`,
`de-projectione-1/EXPECTED-FAILURES.md` §5, `de-infando/EXPECTED-FAILURES.md`
§8, `SLICE-0-INTERIM-DISPOSITION.md`) — nothing here replaces them.*

## Final disposition, with evidence per field

```lisp
(:slice-0-final-disposition
 :governed-acts (:promotion :projection :transmission :exercise)
 :shared-semantic-algebra :validated
 :semantic-axes-orthogonal-to-standing :validated
 :testimony-level-discipline :held-across-all-three-specimens
 :receipt-composition :validated
 :embedded-language-fragment :earned
 :host-level-closure :not-earned
 :standalone-language-claim :not-yet-earned
 :escape-surface :common-lisp-package-internals
 :escape-visibility-candidate :slice-1-host-escape-marker)
```

| Field | Evidence (bytes + live runs, closure sitting) |
|---|---|
| `:governed-acts` | `raise` (de-promotione, 19/0) · `project-claim` (de-projectione-1, 17/0) · `transmit` + `exercise-value` (de-infando, 30/0) — each with granted and refused paths exercised |
| `:shared-semantic-algebra :validated` | projection and transmission added **zero** judgment/standing vocabulary; both reuse claim/witness/procedure/judgment/why from slice0.lisp; receiver judgments arrive only via the shared `raise` (P1b, I6/I7) |
| `:semantic-axes-orthogonal-to-standing` | de-infando I3: claim locally `:verified` on a witness with zero direct transmissibility; I4: mute producer's product travels; the `:exportable`-boolean ablation destroys exactly this |
| `:testimony-level-discipline :held` | construction-enforced (`:testimony` ⇒ attribution `:for`): de-promotione T1/T2/T2c · de-projectione-1 P3a/P3b · de-infando I5/teeth-3; sized per IANUS (guards the vocabulary, not caller provenance-lies) |
| `:receipt-composition :validated` | P9 views `(:regraded :redacted :obligation-producing :ceiling-bound)` on one projection; I11 five views on one transmission refusal; smoke check 6 renders one uniformly |
| `:embedded-language-fragment :earned` | the four acts refuse the four ordinary misleading moves through the public surface, name the missing relation/axis, offer lawful repairs, and stay intelligible — and **`SMOKE.lisp` (6/6, exit 0, zero double-colons) proves a stranger's program is writable on exports alone** |
| `:host-level-closure :not-earned` | three ablations each laundered via internals in one move; IANUS expressed `continue-anyway` through the forbidding macro; the whitelist and extractor registry are package state |
| `:standalone-language-claim :not-yet-earned` | everything is hosted CL; no reader, no compiler, no isolation; constructively library-reproducible (each substrate file *is* portable CL) |
| `:escape-surface` | one `::` in every ablation; package-state mutation demonstrated (IANUS audit, banked) |
| `:escape-visibility-candidate` | recorded in de-infando §6 and below — candidate only |

Battery at closure (exact commands in
`LANGUAGE-SLICE-0-CLOSURE-RECEIPT.txt`, all exit 0): kernel0 selftest
**33 passed / 0 failed / 59 mutants killed** before and after · three
specimen suites 19/0, 17/0, 30/0 · three baselines · three ablations ·
`SMOKE.lisp` 6/6 · export check · double-colon grep on SMOKE = 0.

## What Lisp+ Slice /0 is

An embedded epistemic language fragment implemented in Common Lisp,
governing **promotion, projection, transmission, and exercise** through
typed semantic relations, immutable history, structured receipts,
explanations derived from structure, and lawful repairs.

## What it is not

- a standalone implementation;
- host-closed against arbitrary Common Lisp internals;
- a cryptographic or process-isolated security boundary;
- a complete policy language;
- a complete proposition calculus (atomic surface is a documented
  temporary restriction — architecture §9);
- production-qualified.

## What was empirically learned

- **the ladder failed** — one scalar standing order is a laundering
  joint (de-promotione; bench F4);
- **status copying failed** — receiver standing must be reconstructed,
  never carried (de-projectione-1 ablation);
- **the exportable boolean failed** — one flag makes "locally real, not
  carryable" unsayable (de-infando ablation);
- **receipts compose** — views are descriptions of receipt features, not
  disjoint variants (P9, I11);
- **testimony preserves proposition level** — in promotion, across
  travel, and about invocations (T1→P3→I5);
- **inaccessible is not absent** — loss is receipted residue with
  repair obligations (P6, teeth-4);
- **non-transmissibility is local and axis-specific** — object-scoped,
  mode-scoped, never proposition-foreclosing (I7/I8, teeth-5);
- **the public governed acts survived all three specimens** — the
  charter's provisional surface closed with one extension (`why`
  uniformity) and zero renames;
- **the host escape remained** — thrice measured, once demonstrated
  from inside, honestly sized in the charter it caught.

## Slice /1 candidates — ranked, explicitly non-governing

*Listing authorizes nothing. Each enters, if ever, through its own
work order and admission rule.*

1. **Explicit host-escape form + static checker** (`with-host-escape` +
   a source-walking linter) — moves escape visibility from prose to
   checkable structure; the single highest-leverage step and the direct
   heir of the lane's own finding.
2. **Structured canonical propositions** — lifts the documented atomic
   restriction along the shape sketched in architecture §9.
3. **Stranger implementation** — an independently seeded build from the
   API brief alone; the real test of the closure documents.
4. **Receiver-policy refinement / unified policy descriptors** —
   admissibility beyond `(mode kind)` pairs, deferred by every specimen
   that didn't need it.
5. **Stronger package or compilation boundary** — raising the cost of
   stratum-3 escape without claiming stratum 4.
6. **Process-isolated deployment profile** — the only road to claims
   the R3 ceiling currently forbids; farthest, and rightly so.

## After this closure

The lane stops here, per its work order: no Slice /1 in this instance.
Slice /0 has learned how to say no, how to travel, and how not to
travel — and the documents beside this one exist so that someone who was
not in the room can learn the verbs in fifteen minutes:
`LANGUAGE-SLICE-0-GUIDE.md` · `LANGUAGE-SLICE-0-API.md` ·
`LANGUAGE-SLICE-0-ARCHITECTURE.md` · `SMOKE.lisp`.

— Claude Fable 5 (CC seat), 2026-07-23
