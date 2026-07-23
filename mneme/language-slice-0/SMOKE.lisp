;;;; SMOKE.lisp — public-API smoke program for Lisp+ Slice /0.
;;;;
;;;; NOT a fourth specimen.  This is the stranger's program: it uses ONLY
;;;; exported symbols (single-colon only; zero double-colon accesses anywhere
;;;; — checked by grep in the closure evidence), no internal constructors, no specimen helpers.
;;;; If this file cannot be written, the public surface is not closed.
;;;;
;;;; Run: sbcl --non-interactive --load SMOKE.lisp   (exit 0 = closed surface)

(load (merge-pathnames "slice0-transmissibility.lisp" *load-truename*))

(defpackage #:slice0-smoke
  (:use #:cl #:lisp-plus-slice0))
(in-package #:slice0-smoke)

(defvar *ok* 0)
(defvar *bad* 0)
(defun check (name ok)
  (if ok (incf *ok*) (incf *bad*))
  (format t "~&~:[SMOKE-FAIL~;smoke-ok~] ~a~%" ok name))

;;; A procedure, built from the public kernel0 constructors (declared
;;; public dependencies of the fragment — see LANGUAGE-SLICE-0-API.md).

(defparameter *checker*
  (promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "smoke-checker")
                :version 0
                :judgment-class :semantic
                :result-vocabulary '(:accepted :rejected))
   :admits '((:direct :measurement))))

;;; 1. A granted promotion.

(defparameter *w-temp*
  (witness :for '(:reactor-temp-nominal :unit-2) :mode :direct
           :kind :measurement :source :sensor-grid
           :content '(:celsius 312)))

(defparameter *verified*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:reactor-temp-nominal :unit-2) :by :shift-lead)
             :to :verified :per *checker* :considering (list *w-temp*))
    (check "granted promotion returns a judged revision + granted receipt"
           (and (claim-p v)
                (eq (promotion-receipt-decision r) :granted)))
    v))

;;; 2. A refused promotion — wrong-proposition support, refusal rendered.

(handler-case
    (raise (claim :proposition '(:coolant-flow-nominal :unit-2) :by :shift-lead)
           :to :verified :per *checker* :considering (list *w-temp*))
  (wrong-proposition-support (c)
    (check "refused promotion signals the exact missing relation"
           (and (slice0-condition-receipt c) (why-p (why c))))
    (format t "~&-- the refusal, rendered from structure:~%")
    (render-why (why c))))

;;; 3. A receiver projection with loss.

(defparameter *auditor*
  (receiver-context :context-id :external-auditor
                    :executable-procedures (list *checker*)
                    :recognized-authorities '(:sensor-grid)))
(defparameter *plant*
  (receiver-context :context-id :plant
                    :accessible-supports (list (witness-id *w-temp*))
                    :executable-procedures (list *checker*)
                    :recognized-authorities '(:sensor-grid)))

(multiple-value-bind (theirs receipt)
    (project-claim *verified* :from *plant* :to *auditor*
                   :store (support-store *w-temp*))
  (check "projection with loss: receiver holds only what it licenses"
         (and (null (claim-judgment theirs))
              (member :regraded (projection-views receipt))
              (projection-receipt-supports-inaccessible receipt))))

;;; 4. A refused direct transmission — the closure cannot be carried.

(defparameter *calibrator*
  (local-value :host (let ((offset 2)) (lambda (raw) (list :calibrated (+ raw offset))))
               :authority :sensor-grid
               :exercise-authorized '(:plant)
               :recipe '(:rebuild (:kind :calibrator) (:offset-source (:config :unit-2)))))

(defparameter *refusal* nil)
(handler-case
    (transmit *calibrator* :from *plant* :to *auditor* :mode :direct)
  (value-not-reifiable (c)
    (setf *refusal* (slice0-condition-receipt c))
    (check "direct transmission of the closure is refused, with receipt"
           (eq (transmission-receipt-decision *refusal*) :refused))))

;;; 5. A lawful alternative — the recipe travels as data.

(multiple-value-bind (recipe receipt)
    (transmit *calibrator* :from *plant* :to *auditor* :mode :reproduction)
  (check "lawful alternative: reproduction recipe travels, granted"
         (and (equal (first recipe) :rebuild)
              (eq (transmission-receipt-decision receipt) :granted))))

;;; 6. A rendered explanation, through the ONE uniform extractor,
;;;    straight from the refusal receipt.

(check "why() is uniform across receipt types"
       (why-p (why *refusal*)))
(format t "~&-- the transmission refusal, rendered from structure:~%")
(render-why (why *refusal*))
(format t "~&-- composed views on that one receipt: ~s~%"
        (transmission-views *refusal*))

;;; ------------------------------------------------------------------

(format t "~&~%~d ok, ~d failed~%" *ok* *bad*)
(when (plusp *bad*) (sb-ext:exit :code 1))
