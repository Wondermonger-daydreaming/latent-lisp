# KERNEL0 DEFECT RECEIPT /0 — condition-initializer inert under SBCL

**Bounded defect receipt. Not a hardening project.** Discovered during the
Slice /0 de-promotione sitting (PROBE brief, `kernel0-api-brief.md` item 6;
independently re-reproduced by the CC seat below). Kernel0 bytes remain
frozen; no repair is undertaken in this lane.

```lisp
(:finding
 :id :kernel0-condition-initializer-inert-under-sbcl
 :status :confirmed-by-execution
 :reproduction-command "see below (verbatim, re-run 2026-07-23)"
 :effect :initializer-not-a-live-enforcement-boundary
 :slice0-disposition :wrapped-not-relied-upon
 :live-enforcement-points (:signal-slice0 :macroexpansion)
 :kernel0-repair :deferred)
```

## What was found

`kernel0/conditions.lisp` defines an `initialize-instance :after` method on
`kernel0-condition` written to enforce: non-empty `failed-invariant`,
proper-list `evidence-ids`, §20.9-whitelisted `permitted-restarts`, and
defensive snapshot of `offending-value`. **None of these checks runs when a
condition is built via `make-condition` under SBCL 2.4.6** — the CL standard
does not require `make-condition` to call `initialize-instance`, and SBCL's
does not.

## Reproduction (exact command, observed output)

From `experiments/latent-lisp/mneme/kernel0/`:

```
sbcl --non-interactive --load load.lisp --eval \
 '(let ((c (make-condition (quote lisp-plus-kernel0:unresolved-identity)
                           :failed-invariant ""
                           :permitted-restarts (list (quote bogus-restart)))))
    (format t "REPRO: constructed ~a; failed-invariant=~s; permitted-restarts=~s~%"
            (type-of c)
            (lisp-plus-kernel0:kernel0-condition-failed-invariant c)
            (lisp-plus-kernel0:kernel0-condition-permitted-restarts c)))'
```

Observed (2026-07-23, SBCL 2.4.6 operation-checked):

```
REPRO: constructed UNRESOLVED-IDENTITY; failed-invariant=""; permitted-restarts=(BOGUS-RESTART)
```

Both contract violations (empty failed-invariant; non-§20.9 restart name)
were accepted at construction. Additional probes in `kernel0-api-brief.md`
item 6: improper `evidence-ids` accepted; `offending-value` NOT snapshotted
(`eq` to the caller's structure).

## What still holds (the live boundaries)

- `with-kernel0-restarts` refuses non-whitelisted restart clauses at
  macroexpansion (verified) — restart *establishment* remains confined to
  the 7 names.
- `signal-kernel0` refuses non-`kernel0-condition` types in its body
  (verified).
- All `%strict-constructor-arguments` record constructors enforce live
  (selftest: 33/0, 59 mutants killed).

## Scope and disposition

- **Effect:** the condition initializer is not a live enforcement boundary;
  any caller minting kernel0 conditions directly via `make-condition`
  bypasses the §20.1 condition contract silently.
- **Slice /0 disposition:** wrapped, not relied upon — `slice0.lisp`
  enforces its own condition contract in `signal-slice0` and at
  macroexpansion (live paths), never in a condition initializer (charter §9,
  corrected wording, commit `c714bc60`).
- **Kernel0 repair:** **deferred.** A candidate fix (move checks into
  `signal-kernel0`'s body, or add an explicit `%validate-condition` call on
  every construction path) belongs to a future Kernel0 errata cycle with its
  own conformance run — not to the language lane. This receipt exists so
  that cycle starts from an executed reproduction instead of a memory.

— Claude Fable 5 (CC seat), 2026-07-23
