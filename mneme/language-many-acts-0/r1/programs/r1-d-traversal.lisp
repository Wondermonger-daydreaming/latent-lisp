;; r1-d-traversal — a lawful MA0 program carrying arm D through the evaluator
;; end to end (R1 §7 coverage closure).
;;
;; WHY IT EXISTS.  Arm D had never crossed the MA0 composition at all.  P3
;; names it and deliberately does NOT reach it — the itinerary refuses before
;; the feast — so the arm's own end-to-end traversal was outstanding.
;;
;; WHAT IT SAYS.  D is the broken-cell arm ("fracta": `Cella quae non est`),
;; the one whose adapter meets a host fault.  The interesting property is what
;; a program is ABLE to do about that, which is: observe it, name it, and stop.
;; A host fault is not a refusal the act spoke and not an outcome the program
;; may launder into a completion — so this program's own terminal is a
;; STRUCTURED REFUSAL carrying the subject, and the run's disposition is
;; `:refused' by the program's own word (GRAMMAR §5.3).
;;
;; ⚠ AND IT DOES NOT RETRY, WHICH IS NOT A CHOICE THIS PROGRAM MAKES.  There is
;; no retry, resume, or loop head in the grammar to write, and a second `(act …
;; (:arm "D") …)' would be refused statically by V-ARM.  The absence is the
;; law; this program merely has nowhere else to go.

(ma0-program
 (:name "r1-d-traversal")
 (:input (subject))
 (:authority-slots (warrant))
 (:steps
  (act broken-leg (:arm "D") (:authority-slot warrant))
  (branch broken-leg
    ((:and (:class :d) (:disposition :host-fault))
     (refuse (:code :host-fault-observed-not-retried) (ref subject)))
    ((:class :d)
     (refuse (:code :d-class-other-disposition) (ref subject)))
    (otherwise
     (result (list "D" (ref subject) "shape-not-anticipated"))))))
