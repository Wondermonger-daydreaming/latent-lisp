;;;; p1-editio.lisp — P1, "editio": a gated publication.
;;;;
;;;; ⚠ THIS FILE IS DATA, NOT CODE.  It is never `load'ed.  It is READ by
;;;; `ma0-validate' with *read-eval* NIL and *package* bound to the program
;;;; namespace, and the single form below is the whole program.  Nothing in it
;;;; is evaluated by the host, and nothing in it can be: there is no eval, no
;;;; closure, no host call, and no construct that could reach one.
;;;;
;;;; THE CAUSAL SKELETON (P1-EDITIO-BRIEF.md): inspect-before-and-after, with
;;;; an announcement gated on the SECOND inspection.  The `entry' act runs only
;;;; inside the `:absent' arm of a PRIOR derivation, and the announcement runs
;;;; only off a SECOND derivation over the store.  The act's own return is never
;;;; consulted for the announcement — the program re-reads the journal.  A
;;;; successful effect becomes announcement-worthy only through derived
;;;; evidence, never through having returned.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; TWO DIVERGENCES FROM THE BRIEF'S PRE-CODE SKETCH, BOTH DECLARED
;;;; ---------------------------------------------------------------------------
;;;;
;;;; (1) SYNTAX.  The brief's sketch writes a clause pattern as a bare LIST of
;;;;     atoms — `((:execution :settled) (:evidence-class :closure))`.  The
;;;;     grammar the brief defers to (MANY-ACTS-0-GRAMMAR.md §1: "final syntax
;;;;     fixed by") admits PATTERN := ATOMP | (:and ATOMP ATOMP+) and no third
;;;;     shape.  The conjunction below is therefore written `(:and …)`, and the
;;;;     single-atom patterns are written bare.
;;;;
;;;; (2) THE SECOND CONJUNCT'S VALUE.  The sketch gates the announcement on
;;;;     `(:evidence-class :closure)`.  RUN AGAINST THE ADOPTED SUBSTRATE, arm
;;;;     A's seat derives evidence-class :NONE, not :closure — which is also
;;;;     what One Act /0's own agreement table declares for row "A"
;;;;     (act0.lisp:1089: `("A" "COMMITTED" "SETTLED" :settled :none)`).
;;;;     `:closure` was a pre-code placeholder and no run had yet contradicted
;;;;     it.  Gating on it would make P1's announcement arm DEAD CODE — the
;;;;     program would refuse `:entry-not-closed` on its own happy path — so the
;;;;     conjunct names the value the record actually carries.  ⚠ THE DIVERGENCE
;;;;     IS REPORTED, NOT ABSORBED: the selftest prints the derived
;;;;     evidence-class rather than asserting it silently, so a reader sees the
;;;;     substrate's answer and not only this program's agreement with it.
;;;;     The PRESSURE is untouched: the announcement is still gated on a second
;;;;     derivation showing a settled record.
;;;;
;;;; The seat name "s-entry" is a DECLARED NAME, resolved through the
;;;; environment's seat map to a canonical runtime seat.  The program text does
;;;; not know, and must not know, which fixture seat that is.

(ma0-program
 (:name "editio")
 (:input (manuscript-label))
 (:authority-slots (editor-grant))
 (:steps
  ;; ---- the FIRST inspection: the record must show the seat untouched.
  (derive pre (:seat "s-entry"))
  (branch pre
    ((:execution :absent)
     ;; ---- the only consequential step in this program.
     (act entry (:arm "A") (:authority-slot editor-grant))
     ;; ---- the SECOND inspection.  Not the act's return: the RECORD.
     (derive post (:seat "s-entry"))
     (branch post
       ((:and (:execution :settled) (:evidence-class :none))
        ;; ---- the derived standing becomes an ORDINARY DATUM here, and only
        ;; ---- here.  It is carried into the result payload; it is not
        ;; ---- authority (V-RES-AUTH refuses that statically) and it is not
        ;; ---- evidence (evidence stays in the store).
        (bind entry-standing (field post :execution))
        (result (list :announced (ref manuscript-label) (ref entry-standing))))
       (otherwise
        (refuse (:code :entry-not-closed)))))
    (otherwise
     (refuse (:code :seat-already-occupied))))))
