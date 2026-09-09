;;; expectations-1.lisp — dated additions (E8..E13) on Astra's review, written BEFORE the repair. Same shape as expectations.lisp.
(defparameter *expectations-1*
  '((:e8  :s8  (assess c :via dc)           :established
     :unresolved () :missing () :shared ((d2 :reached-again-via dr)))
    (:e9  :s9  (assess c :via dc)           :cycle
     :cycle ((dc :on-path (dc d2 dx))))
    (:e10 :s10 (assess q :via dc)           :mistargeted
     :mistargeted ((:requested q :via dc :target c :on :call)))
    (:e11 :s11 (assess c :via dc)           :mistargeted
     :mistargeted ((:requested s :via e-s :target q :on d2)))
    (:e12 :s12 (assess c :via dc)           :mistargeted
     :mistargeted ((:requested p :via d2 :target q :on dc)))
    (:e13 :s13 (reassess c :via dc :at 2)   :unsupported-policy
     :policy ww-r-99)))
