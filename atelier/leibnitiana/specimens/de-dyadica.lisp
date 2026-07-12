;;;; de-dyadica.lisp — Binary is not bivalence
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script de-dyadica.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(print-section "THE ORDINARY CONDITIONAL")

(let ((status :undetermined))
  (format t "Common Lisp sees ~S as ~:[false~;true~].~%"
          status (not (null status)))
  (format t "Naive branch: ~A~%"
          (if status
              "PUBLISH AS FACT"
              "WITHHOLD")))

(print-section "THE CONSTITUTIONAL CONDITIONAL")

(let ((finding
        (make-judgment
         :value '(:matches 0)
         :status :undetermined
         :premises '(:searched-index shard-7)
         :boundary '(:not-searched shard-8 shard-9)
         :authority :local-search
         :procedure :bounded-scan)))
  (format t "Judgment: ~S~%" finding)
  (format t "Licensed branch: ~A~%"
          (jif finding
            (:supported "publish")
            (:refuted "reject")
            (:otherwise "withhold and preserve the unresolved status"))))

(print-section "FAIL CLOSED WHEN NO BRANCH EXISTS")

(handler-case
    (let ((finding (make-judgment :value 0 :status :conflicted)))
      (jif finding
        (:supported "publish")
        (:refuted "reject")))
  (epistemic-status-error (condition)
    (format t "Caught expected condition: ~A~%" condition)))

(format t "~&Thesis: a bit may carry rich structure; it does not license us to flatten testimony into yes/no before standing is earned.~%")
