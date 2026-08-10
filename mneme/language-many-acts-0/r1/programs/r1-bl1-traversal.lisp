;; r1-bl1-traversal — a lawful MA0 program carrying arm B-L1 through the
;; evaluator end to end (R1 §7 coverage closure).
;;
;; WHY IT EXISTS.  Before this round, B-L1 had never crossed the MA0
;; composition: P1 uses A, P2 uses A · C-i · B-R, the probes use C-ii, and P3
;; adds B-L2.  The arm was covered by the CONCORDANCE only after R1 widened it
;; to seven, and concordance is not traversal — it compares a composition, it
;; does not run a program through one.
;;
;; WHAT IT SAYS.  B-L1 is the wrong-predicate authority arm ("vetita-scope"):
;; the presented capability does not carry the predicate the act needs, so the
;; act is refused at the authority seam and the frontier is NOT crossed.  The
;; program observes that shape, names it, and stops.  It does not retry it —
;; there is no construct that could.
;;
;; The second clause is not decoration: it fires if the class is right and the
;; disposition is not, so a shape change downstream is REPORTED rather than
;; folded into the `otherwise'.

(ma0-program
 (:name "r1-bl1-traversal")
 (:input (subject))
 (:authority-slots (warrant))
 (:steps
  (act scope-leg (:arm "B-L1") (:authority-slot warrant))
  (branch scope-leg
    ((:and (:class :b) (:disposition :refused))
     (refuse (:code :authority-seam-held) (ref subject)))
    ((:class :b)
     (refuse (:code :b-class-other-disposition) (ref subject)))
    (otherwise
     (result (list "B-L1" (ref subject) "shape-not-anticipated"))))))
