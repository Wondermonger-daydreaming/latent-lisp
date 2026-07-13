# The S-Expression Garden

**Botanical jurisprudence for executable forms.**

The Garden treats a Common Lisp form as a symbolic organism. A graft does not
silently splice two lists and hope for the best. It convenes a small court.
The donor branch is identified, the recipient site is examined, a candidate is
constructed without mutation, several jurisdictions issue findings, and only
then may the recipient change. Every petition—lawful, foolish, malformed, or
catastrophic—leaves a readable S-expression receipt.

This experiment is designed as a companion in spirit to the
[`quine-orchard`](https://github.com/Wondermonger-daydreaming/latent-lisp/tree/main/atelier/quine-orchard): text is durable state, evidence is append-only,
and claims are strongest when they can be regenerated and compared.

The implementation depends only on ANSI Common Lisp. This delivery was
compiled and run under Armed Bear Common Lisp 1.9.2. The direct runners use only
ordinary script-loading conventions and are intended for SBCL and other
conventional implementations as well, though SBCL was not available in the
build container used for this validation.

## Run it

From this directory:

```sh
sbcl --script run-demo.lisp
sbcl --script run-tests.lisp
```

Or through ASDF:

```lisp
(asdf:load-asd (truename "s-expression-garden.asd"))
(asdf:load-system :s-expression-garden)
(asdf:test-system :s-expression-garden)
```

`TRANSCRIPT.txt` is a captured execution of the demonstration followed by the
full deterministic and randomized test assize.

## The organisms

A live specimen is a structure with an identity, a form, a contract, a
revision, and provenance/history slots:

```lisp
(specimen
  :id :incrementer
  :form (lambda (x) (garden-add x 1))
  :contract (:kind :executable
             :parameters ((x :number))
             :result :number
             :behavior-mode :contract
             :probes ((:args (0) :expect (:type :number))))
  :revision 0)
```

A garden owns the specimen registry, the chronological receipt archive, the
operator/domain ecology, the policy, and a provenance graph.

Paths are zero-based child-index lists. `nil` denotes the whole tree. In

```lisp
(lambda (x) (garden-add x 1))
```

path `(2)` is the body, `(2 0)` is `GARDEN-ADD`, and `(2 2)` is the literal
`1`. The cut is *documentary rather than destructive*: the donor remains
unchanged, while the exact selected subtree is copied into the petition. That
choice makes the donor snapshot stable, permits repeatable replay, and turns
provenance into ancestry rather than amputation bookkeeping.

## The graft protocol

`ATTEMPT-GRAFT` is the only public mutation gate:

```lisp
(attempt-graft garden
               :stone-six '(2)
               :incrementer '(2 2))
```

The protocol proceeds in a fixed precedence order. That precedence is itself
ordinary data: `(graft-rulebook)` returns a fresh S-expression, and the same
lawbook is archived in every receipt and in `RULEBOOK.sexp`.

1. **Identity jurisdiction.** Both named specimens must exist.
2. **Cut jurisdiction.** Both paths must be proper lists of nonnegative child
   indexes and must resolve in their respective trees.
3. **Provenance jurisdiction.** Adding the edge `recipient -> donor` must not
   create a cycle. Self-grafts are therefore refused under the default policy.
4. **Pure candidate construction.** `REPLACE-SUBTREE` creates a fresh candidate;
   neither source form is mutated.
5. **Structural quarantine.** Executable organisms must be proper, acyclic,
   readable trees. Dotted lists, circular lists, shared cons cells, and
   uninterned/unreadable atoms are rejected.
6. **Contract shape.** Executable recipients remain lambda-rooted and keep the
   declared parameter count.
7. **Lexical jurisdiction.** A free value symbol in the donated subtree may not
   become bound merely because it crossed into the recipient. New unbound
   symbols are also refused. Data specimens are exempt: a receipt should not be
   prosecuted for looking like code while serving as evidence.
8. **Arity and operator jurisdiction.** Calls must satisfy known fixed/rest
   arities, and unknown or non-callable operators are refused.
9. **Domain jurisdiction.** A conservative abstract interpreter checks argument
   and result domains such as `:number`, `:string`, `:list`, and `:sequence`.
10. **Behavioral quarantine.** Contract probes execute the candidate in a
    small allowlisted evaluator with a deterministic step budget. Errors,
    contract failures, behavioral non-preservation (when requested), and
    nontermination-by-budget-exhaustion are findings, not accidents.
11. **Commit.** Only unanimous consent changes the recipient, increments its
    revision, adds provenance, and records the receipt in its history.

Unexpected protocol conditions are caught at the outer gate, the recipient,
provenance graph, and archive are rolled back to their pre-hearing state, and an
`:INTERNAL-PROTOCOL-ERROR` refusal receipt is issued. The ordinary rejection
path never signals just because a petition is bad; bad petitions are precisely
what the archive is for.

## Receipts are law, evidence, and ordinary lists

Receipts are deliberately not CLOS instances. They are tagged property-list
S-expressions:

```lisp
(:graft-receipt
 :schema 1
 :id (:receipt :public-hearing 1)
 :protocol :s-expression-garden/1
 :attempt 1
 :garden-id :public-hearing
 :request (:operation :graft
           :donor-id :stone-six
           :donor-cut-path (2)
           :recipient-id :incrementer
           :recipient-cut-path (2 2))
 :donor (:identity :stone-six
         :revision 0
         :cut-path (2)
         :pre-hash "C77BB0C625C1B12A")
 :recipient (:identity :incrementer
             :revision-before 0
             :revision-after 1
             :cut-path (2 2)
             :pre-hash "3DFE6F5135D61AD9")
 :transplant (garden-mul 2 3)
 :excised-target 1
 :candidate-form (lambda (x) (garden-add x (garden-mul 2 3)))
 :post-form (lambda (x) (garden-add x (garden-mul 2 3)))
 :hashes (...)
 :decision (:status :accepted
            :rule :all-rules-satisfied
            :stage :commit
            :details (:finding :graft-lawful))
 :consequences (...)
 :snapshots (...)
 :provenance (...))
```

The actual receipt is more exhaustive. It carries the exact donor and recipient
pre-forms/contracts/revisions, the engine release and protocol, the full ordered
rulebook, all operator specifications and policies used for adjudication, the
provenance graph before and after, static findings, probe observations, and a
replay declaration. Hashes are stable 64-bit FNV-1a-derived hashes of a canonical
readable representation; they do not depend on an implementation's `SXHASH`.
`READ-RECEIPT` also binds `*READ-EVAL*` to `NIL`, so archived evidence cannot
smuggle a `#.` read-time execution into the clerk's office.

Because a receipt is an ordinary tree, it can be printed, read, diffed,
transformed, archived, searched, or planted:

```lisp
(let* ((receipt (attempt-graft garden :stone-six '(2)
                               :incrementer '(2 2)))
       (warrant (plant-receipt garden receipt :identity :warrant-1)))
  (attempt-graft garden warrant nil :ledger '(1)))
```

The second operation grafts the *entire first receipt* into a data ledger. Its
own receipt then records that metagraft. Bureaucracy has become self-propagating
flora; naturally, it still has to pass provenance review.

## Replay

`REPLAY-RECEIPT` needs no live garden. It reconstructs a temporary court from
the receipt's snapshots, policy, operator ecology, and pre-graft provenance;
reruns the original petition; and compares:

- protocol, engine release, ordered rulebook, policy, and operator ecology;
- decision status and responsible rule;
- exact transplanted subtree;
- candidate hash and recipient post-hash;
- final post-form.

It returns another S-expression:

```lisp
(:replay-report
 :receipt-id (:receipt :public-hearing 1)
 :matched t
 :checks ((:status t)
          (:rule t)
          (:transplant t)
          (:candidate-hash t)
          (:recipient-post-hash t)
          (:post-form t))
 :replayed-receipt ...)
```

Replay is adjudication, not blind patch application. A refusal is replayed as a
refusal for the same rule; an acceptance must earn acceptance again.

## Standing invariants

`CHECK-RECEIPT-INVARIANTS` and `CHECK-GARDEN-INVARIANTS` return violation
S-expressions rather than booleans. `ASSERT-GARDEN-INVARIANTS` signals when a
clean bill of health is required.

The main laws are:

- every attempted graft receives exactly one chronological receipt identifier;
- the donor is immutable;
- refusal preserves recipient form, hash, and revision;
- acceptance makes `post-form = candidate-form` and increments the revision by
  exactly one;
- donor, recipient, candidate, and post hashes agree with their recorded forms;
- the recorded transplant is exactly the donor subtree at the recorded cut;
- the candidate is exactly the recorded replacement in the recipient snapshot;
- accepted receipts have corresponding provenance edges;
- the live provenance graph is acyclic under the default policy;
- normal live specimens and plantable receipts are proper, acyclic trees;
- every responsible rule is present in the archived rulebook with the matching
  acceptance/refusal disposition.

The test assize separately requires replay to reproduce the disposition and
resulting state; it also tampers with a copied lawbook to prove that replay
reports protocol drift rather than politely overlooking it.

A malformed *request path* may itself be dotted or circular. The copier and
printer preserve that malformed object as evidence (using readable `#1=` circle
notation when necessary), even though it could never be planted as a healthy
specimen. The archive does not prettify perjury.

## Refusal rules exercised by the specimen garden

The bundled population includes:

- `:BAD-ARITY-BRIAR`, whose donated call has three arguments for a binary
  operator;
- `:STRING-VINE`, which produces a string where a numeric bed is expected;
- `:ZERO-DIVISOR`, statically lawful but dynamically explosive;
- `:SLEEPING-LOOP`, statically lawful but behaviorally endless;
- `:COUNTER-A` and `:COUNTER-B`, used to demonstrate a legal first ancestry edge
  and a refused reverse edge;
- `:LEDGER`, a data organism able to receive whole receipts.

The tests additionally cover unknown operator domains, readable receipt
round-tripping, immutable donors, receipt metagrafts, and replay detection of a
mutated rulebook.

## Randomized and property tests

No external test library is required. `RUN-TESTS` combines fifteen deterministic
cases with three reproducible randomized properties. The default runner uses
200 trials per property:

1. Pure subtree replacement preserves the original tree, places the exact
   replacement at the chosen path, and obeys the node-count equation.
2. Random closed arithmetic donors graft into random numeric recipient leaves;
   every accepted operation must satisfy receipt invariants and replay.
3. Random malformed donor paths always produce atomic refusals: recipient hash
   and revision remain unchanged.

The PRNG is a small explicit 32-bit linear congruential generator, so a failing
seed is portable evidence rather than an implementation-specific shrug.

## Behavioral scope and security

The quarantine evaluator is intentionally small. It recognizes the garden's
allowlisted operators and a conservative subset of Lisp (`quote`, `if`,
`progn`, `and`, `or`, `let`, and `let*`). It does **not** call `EVAL` on donor
code. This makes behavioral probes deterministic and inspectable, but it is not
a claim that arbitrary hostile Common Lisp can be safely sandboxed in-process.
The domain analysis is similarly conservative: `:unknown` can flow where
certainty is unavailable, while explicit incompatibilities are refused.

This is an experimental court for symbolic organisms, not a production code
loader. Its virtue is that uncertainty becomes evidence instead of being
smuggled past the gate in a boolean named `VALID-P`.

## Files

- `package.lisp` — public package and API.
- `garden.lisp` — tree surgery, analysis, evaluator, receipts, replay, and
  invariants.
- `RULEBOOK.sexp` — the ordered refusal/acceptance law as graftable data.
- `specimens.lisp` — the small demonstration population and contracts.
- `demo.lisp` — the public hearing.
- `tests.lisp` — deterministic and randomized test assize.
- `s-expression-garden.asd` — ASDF systems.
- `run-demo.lisp`, `run-tests.lisp`, `run-transcript.lisp` — dependency-free
  entry points.
- `TRANSCRIPT.txt` — captured runnable evidence.
- `MANIFEST.sexp` — release metadata and SHA-256 hashes for the other files.
