;;; expectations.lisp — WARRANT WALK /0, machine-readable expected outcomes, PRE-IMPLEMENTATION.
;;; Mirrors EXPECTATIONS-0.md §5. Each entry: (label store-name call expected-result expected-fields...)
;;; Field expectations are compared as sets of premise/obligation forms; missing keys mean "not checked here".
;;; Written 2026-09-08 before warrant-walk.lisp existed. Never edited above the RESULTS line of the .md.

(defparameter *expectations*
  '((:e1   :s0 (assess c :via dc)           :established
     :followed ((p :via d2) (s :via e-s)) :evidence (e-s) :unresolved () :missing () :not-entered ())
    (:e2   :s1 (assess c :via dc)           :established
     :followed ((p :via d2) (s :via e-s)) :unresolved () :not-entered ((d1 :for p)))
    (:e2-d :s1 (assess-defective c :via dc) :conditional
     :unresolved ((q :on d1)))
    (:e3   :s2 (assess c :via dc)           :conditional
     :followed ((p :via d1)) :unresolved ((q :on d1)) :not-entered ((d2 :for p)))
    (:e4   :s3 (assess c :via dc)           :established
     :followed ((p :via d1) (q :via e-q)) :evidence (e-q) :unresolved ())
    (:e5   :s4 (assess c :via dc)           :blocked
     :missing ((e-s :for s :on d2)) :followed ((p :via d2)) :not-entered ((d1 :for p)) :unresolved ())
    (:e6   :s5 (assess c :via dc)           :blocked
     :missing ((e-s :for s :on d2)) :carried-status-testimony ((c :established)))
    (:e7   :s6 (reassess c :via dc :at 0)   :cannot-reconstruct
     :at 0)
    (:e7-c :s7 (reassess c :via dc :at 1)   :established
     :at 1 :policy ww-r-0 :followed ((p :via d2) (s :via e-s)))))
