;;;; smoke.lisp — dependency-free checks for the first tranche

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(print-section "JUDGMENT STANDING")
(check (judgment-standing-p (make-judgment :status :supported))
       "supported judgments have standing")
(check (not (judgment-standing-p (make-judgment :status :undetermined)))
       "undetermined judgments do not have standing")

(print-section "JIF")
(check-equal :yes
             (jif (make-judgment :status :supported)
               (:supported :yes)
               (:refuted :no))
             "JIF dispatches supported")
(check-equal :withhold
             (jif (make-judgment :status :conflicted)
               (:supported :yes)
               (:otherwise :withhold))
             "JIF preserves unlicensed statuses")

(print-section "MONAD INTERFACE")
(let ((m (make-monad :counter 0
                     (lambda (state tick)
                       (declare (ignore tick))
                       (values (1+ state) (1+ state))))))
  (advance-monad m 0)
  (check-equal :counter (monad-id m) "monad exposes its identifier")
  (check-equal 1 (getf (depose-monad m) :testimony)
               "monad exposes deposition rather than private state"))


(print-section "COMPOSSIBILITY")
(let ((a (make-claim :id :a :constraints '((:world . 1) (:time . :now))))
      (b (make-claim :id :b :constraints '((:world . 1) (:time . :now))))
      (c (make-claim :id :c :constraints '((:world . 2) (:time . :now)))))
  (check (compossible-p a b) "aligned constraints are compossible")
  (check (not (compossible-p a c)) "conflicting world constraints are not compossible"))

(print-section "WINDOWLESS CONTRACT")
(defwindowless-evaluator smoke-evaluator (state tick)
  (list state tick))
(check-equal :interface-relative-only
             (getf (evaluator-contract 'smoke-evaluator) :standing)
             "macro registers bounded standing")

(format t "~&All smoke checks passed.~%")
