;;;; p2-custodia.lisp — P2, "custodia": a revocation-aware duty handoff.
;;;;
;;;; ⚠ THIS FILE IS DATA, NOT CODE.  It is never `load'ed; it is READ.
;;;;
;;;; ⚠ ONE PROGRAM TEXT, TWO DECLARED ENVIRONMENTS.  Runs α and β evaluate THIS
;;;; FILE, byte for byte.  Only the environment differs (its seat map, and
;;;; whether a Capability /0 revocation stands against duty-3's authority).
;;;; That is the whole design of the brief and the reason the derive step's
;;;; seat is an INPUT rather than a literal.
;;;;
;;;; THE CAUSAL SKELETON (P2-CUSTODIA-BRIEF.md): sequential duties with TWO
;;;; DISTINCT LAWFUL STOPPING MODES.
;;;;
;;;;   Run α — the uncertainty path.  duty-2's record shows the duty passed
;;;;   through an unresolved uncertainty; the chain HALTS with a structured
;;;;   refusal naming the stopping duty, and duty-3 NEVER RUNS.  Blind replay is
;;;;   INEXPRESSIBLE (this language has no retry construct) and would ALSO be
;;;;   refused by the adopted lane (seat consumption + act identity) — two
;;;;   independent facts, neither of them MA0's invention.
;;;;
;;;;   Run β — the revocation path.  The branch's continue-arm is selected, so
;;;;   duty-3's B-R attempt runs and is REFUSED by the adopted lane at L3b: its
;;;;   Capability /0 grant is revoked, `query-live-authority' returns a refusal
;;;;   receipt, and "a refusal cannot authorize minting" (CAP1-MINT-2).  F1
;;;;   stands alone by law.  The program converts that act-level refusal into a
;;;;   structured PROGRAM refusal — it does not repair it, retry it, or
;;;;   reinterpret it.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; THREE DIVERGENCES FROM THE BRIEF'S PRE-CODE SKETCH, ALL DECLARED
;;;; ---------------------------------------------------------------------------
;;;;
;;;; (1) SYNTAX.  Patterns follow MANY-ACTS-0-GRAMMAR.md §1 (ATOMP | (:and …)),
;;;;     and value expressions follow §1's VEXPR (`(list …)`, `(ref …)`), which
;;;;     the sketch abbreviated.
;;;;
;;;; (2) THE UNCERTAINTY CLAUSE NAMES `:reconciled`, NOT `:uncertain-unresolved`
;;;;     — AND THIS IS THE ROUND'S SHARPEST SUBSTRATE FINDING.  The sketch
;;;;     assumed the program's derive step would see duty-2's seat standing at
;;;;     `:uncertain-unresolved`.  It does not, and cannot: the ADOPTED act's
;;;;     own law-chain contains the Class-C reconciliation pair (L19/L20 —
;;;;     declare, freeze F3, reconcile, F4), so by the time the ACT has
;;;;     completed the seat derives `:reconciled` / `:reconciled`.  Verified by
;;;;     running it: mid-act the seat reads UNCERTAIN-UNRESOLVED / UNCERTAIN,
;;;;     and after completion RECONCILED / RECONCILED.
;;;;
;;;;     THE PRESSURE SURVIVES INTACT, and is arguably sharper.  `:reconciled`
;;;;     is reachable at /0 ONLY through a C-arm — arm A settles directly, and
;;;;     One Act /0's agreement table gives `C-reconciled` to no other class
;;;;     (act0.lisp:1094).  So "this seat's record reads reconciled" IS the
;;;;     record's way of saying "an uncertainty stood here and had to be
;;;;     adjudicated", and refusing the chain on it is exactly the brief's
;;;;     "refuse the dependent action".  The lawful continuation still lives
;;;;     OUTSIDE the program: no `reconcile' step exists in this grammar, and
;;;;     the program neither invokes nor could invoke one.
;;;;
;;;;     ⚠ WHAT IS NOT CLAIMED: that this program observes an uncertainty
;;;;     UNRESOLVED.  At /0 no program can, because act completion resolves it.
;;;;     A lane that wants a program to hold an unresolved uncertainty across a
;;;;     step boundary needs an act door that stops before L19 — MA0 has no
;;;;     such door and does not claim one.
;;;;
;;;; (3) A BRANCH OVER duty-3's ACT-RESULT.  The sketch's continue-arm ends
;;;;     `(result (:chain-complete …))` immediately after the duty-3 act, which
;;;;     would report a completed chain whatever duty-3 did.  The brief's own
;;;;     Pressure 3 says "the program converts the act-level refusal into a
;;;;     structured program refusal", and GRAMMAR §5.2 introduces the
;;;;     act-result axes as "the two axes P2 forces" — which only P2's duty-3
;;;;     can be forcing.  The branch below is that conversion.

(ma0-program
 (:name "custodia")
 (:input (custodian evidence-seat))
 (:authority-slots (custody-grant))
 (:steps
  (act duty-1 (:arm "A") (:authority-slot custody-grant))
  (act duty-2 (:arm "C-i") (:authority-slot custody-grant))
  ;; ---- the branch reads the DERIVED EVIDENCE, never duty-2's return.
  (derive duty-2-evidence (:seat (ref evidence-seat)))
  (branch duty-2-evidence
    ((:and (:execution :reconciled) (:evidence-class :reconciled))
     (refuse (:code :uncertainty-halts-chain) (ref custodian)))
    ((:execution :settled)
     (act duty-3 (:arm "B-R") (:authority-slot custody-grant))
     (branch duty-3
       ((:and (:disposition :mint-refused) (:class :unpaired-f1))
        (refuse (:code :authority-revoked-before-duty-3) (ref custodian)))
       (otherwise
        (result (list :chain-complete (ref custodian))))))
    (otherwise
     (refuse (:code :unexpected-evidence) (ref custodian))))))
