;;;; SPECIMEN.lisp — de-projectione Session 1: does the refusal survive travel?
;;;;
;;;; Official specimen (Session 1) on the settled de-promotione algebra.
;;;; The pre-ratification bench probe (../de-projectione.lisp) is inventory
;;;; evidence only and is neither loaded nor promoted here.
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exit 0 = all pass)

(load (merge-pathnames "../slice0-projection.lisp" *load-truename*))

(defpackage #:de-projectione-1
  (:use #:cl #:lisp-plus-slice0)
  (:import-from #:lisp-plus-kernel0
                #:make-identity #:make-procedure-descriptor #:identity=))
(in-package #:de-projectione-1)

(defvar *pass* 0)
(defvar *fail* 0)
(defun check (name ok &optional detail)
  (if ok (incf *pass*) (incf *fail*))
  (format t "~&~:[FAIL~;pass~] ~a~@[ — ~a~]~%" ok name (unless ok detail)))

;;; ------------------------------------------------------------------
;;; Procedures (kernel0 descriptor + slice admissibility, as settled).

(defun semantic-procedure (name admits)
  (promotion-procedure
   :descriptor (make-procedure-descriptor
                :procedure-id (make-identity :procedure name)
                :version 0
                :judgment-class :semantic
                :input-domain '(:kinds (:subject-answer))
                :result-vocabulary '(:accepted :rejected)
                :evidence-requirements '())
   :admits admits))

(defparameter *suite-verification*
  (semantic-procedure "suite-verification"
                      '((:direct :transcript-parse) (:direct :suite-match))))
(defparameter *attribution-verification*
  (semantic-procedure "attribution-verification" '((:testimony :report))))
(defparameter *incident-verification*
  (semantic-procedure "incident-verification" '((:direct :transcript-parse))))
(defparameter *redaction-verification*
  (semantic-procedure "redaction-verification" '((:derivation :redaction))))
(defparameter *gate-verification*
  (semantic-procedure "gate-verification" '((:direct :capability-check))))

;;; ------------------------------------------------------------------
;;; Witnesses (deterministic fixtures; :produced-at is testified data).

(defparameter *w-parse*
  (witness :for '(:tests-passed :suite-a) :mode :direct :kind :transcript-parse
           :source :transcript-parser :content '(:parsed 12 :failed 0)))
(defparameter *w-q*
  (witness :for '(:other-thing :x) :mode :direct :kind :transcript-parse
           :source :transcript-parser :content '(:parsed 3 :failed 0)))
(defparameter *w-testimony*
  (witness :for '(:asserted :operator (:tests-passed :suite-a))
           :mode :testimony :kind :report :source :operator
           :content "all green on my machine"))
(defparameter *w-secret*
  (witness :for '(:incident-root-cause :cve-1234) :mode :direct
           :kind :transcript-parse :source :sec-team
           :content '(:trace :redacted-here) :transmissible nil))
(defparameter *w-derive-pub*
  (witness :for '(:incident-resolved :today) :mode :derivation
           :kind :redaction :source :sec-team
           :content '(:derived-from :incident-root-cause)))
(defparameter *w-mute*
  (witness :for '(:gate-holds :prod) :mode :direct :kind :capability-check
           :source :operator :content '(:closure) :transmissible nil))
(defparameter *w-local-mint*
  (witness :for '(:gate-holds :prod) :mode :direct :kind :capability-check
           :source :prod-auditor :content '(:fresh-local-check)))

(defparameter *store*
  (support-store *w-parse* *w-q* *w-testimony* *w-secret*
                 *w-derive-pub* *w-mute* *w-local-mint*))

;;; ------------------------------------------------------------------
;;; Positions.  A receiver context is a position, not a person.

(defparameter *source-lab*
  (receiver-context
   :context-id :source-lab
   :accessible-supports (mapcar #'witness-id
                                (list *w-parse* *w-q* *w-testimony*
                                      *w-secret* *w-derive-pub* *w-mute*))
   :executable-procedures (list *suite-verification* *attribution-verification*
                                *incident-verification* *gate-verification*)
   :recognized-authorities '(:transcript-parser :suite-checker :operator
                             :sec-team)))

(defparameter *auditor*        ; reaches the parse; recognizes the parser
  (receiver-context
   :context-id :auditor
   :accessible-supports (list (witness-id *w-parse*) (witness-id *w-q*))
   :executable-procedures (list *suite-verification*)
   :recognized-authorities '(:transcript-parser)))

(defparameter *client*         ; reaches nothing; would recognize the parser
  (receiver-context
   :context-id :client
   :accessible-supports '()
   :executable-procedures (list *suite-verification*)
   :recognized-authorities '(:transcript-parser)))

(defparameter *stranger*       ; reaches the parse; recognizes NO authority
  (receiver-context
   :context-id :stranger
   :accessible-supports (list (witness-id *w-parse*))
   :executable-procedures (list *suite-verification*)
   :recognized-authorities '()))

(defparameter *partner*        ; testimony receiver
  (receiver-context
   :context-id :partner
   :accessible-supports (list (witness-id *w-testimony*))
   :executable-procedures (list *attribution-verification*)
   :recognized-authorities '(:operator)))

(defparameter *pub-receiver*   ; sees only the public derivation
  (receiver-context
   :context-id :pub-receiver
   :accessible-supports (list (witness-id *w-derive-pub*))
   :executable-procedures (list *redaction-verification*)
   :recognized-authorities '(:sec-team)))

(defparameter *isolated*       ; reaches nothing at all
  (receiver-context
   :context-id :isolated
   :accessible-supports '()
   :executable-procedures (list *redaction-verification*)
   :recognized-authorities '(:sec-team)))

(defparameter *gate-receiver*  ; has its own locally minted equivalent check
  (receiver-context
   :context-id :gate-receiver
   :accessible-supports (list (witness-id *w-local-mint*))
   :executable-procedures (list *gate-verification*)
   :recognized-authorities '(:prod-auditor)))

;;; ------------------------------------------------------------------
;;; Source claims, verified AT THE SOURCE by the source's own raises.

(defparameter *c-tests*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:tests-passed :suite-a) :by :build-pipeline)
             :to :verified :per *suite-verification*
             :considering (list *w-parse*))
    (declare (ignore r)) v))

(defparameter *c-attr*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:asserted :operator (:tests-passed :suite-a))
                    :by :relay)
             :to :verified :per *attribution-verification*
             :considering (list *w-testimony*))
    (declare (ignore r)) v))

(defparameter *c-secret*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:incident-root-cause :cve-1234) :by :sec-team)
             :to :verified :per *incident-verification*
             :considering (list *w-secret*))
    (declare (ignore r)) v))

(defparameter *c-gate*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:gate-holds :prod) :by :operator)
             :to :verified :per *gate-verification*
             :considering (list *w-mute*))
    (declare (ignore r)) v))

;;; ==================================================================
;;; P1 — SOURCE JUDGMENT IS NOT COPIED: the client reaches nothing, so it
;;; receives an asserted claim with NO judgment, however verified the
;;; source was.

(multiple-value-bind (res receipt)
    (project-claim *c-tests* :from *source-lab* :to *client* :store *store*)
  (check "P1 source judgment is not copied"
         (and (null (claim-judgment res))
              (eq (claim-commitment res) :asserted)
              (member :regraded (projection-views receipt))
              (not (member :preserved (projection-views receipt)))))
  ;; P6 — INACCESSIBLE IS NOT ABSENT: the lost support is represented.
  (check "P6 inaccessible is not absent"
         (and (= 1 (length (projection-receipt-supports-inaccessible receipt)))
              (identity= (first (projection-receipt-supports-inaccessible receipt))
                         (witness-id *w-parse*))
              (assoc (witness-id *w-parse*)
                     (projection-explanation-supports-lost
                      (projection-receipt-explanation receipt))
                     :test #'identity=)))
  ;; ...and exportable evidence surfaces as a repairable OBLIGATION.
  (check "P6b exportable inaccessible support becomes an obligation"
         (equal (mapcar #'second (projection-receipt-obligations receipt))
                (list (witness-id *w-parse*))))
  ;; P2 — SOURCE CONTEXT REMAINS SEMANTICALLY REAL.
  (check "P2 source context and licensing recorded"
         (and (eq (projection-receipt-source-context receipt) *source-lab*)
              (equal (projection-explanation-source-judgment
                      (projection-receipt-explanation receipt))
                     '(:verified "suite-verification"))
              (identity= (first (projection-receipt-supports-considered receipt))
                         (witness-id *w-parse*)))))

;;; ==================================================================
;;; P7 — AUTHORITY RECOGNITION IS CONTEXTUAL: blocked for the stranger,
;;; granted for the auditor — same claim, same evidence, different position.

(multiple-value-bind (res receipt)
    (project-claim *c-tests* :from *source-lab* :to *stranger* :store *store*)
  (check "P7a unrecognized authority blocks UNDER THIS CONTEXT"
         (and (null (claim-judgment res))
              (let ((b (find :authority-unrecognized
                             (projection-receipt-blockers receipt)
                             :key #'first)))
                (and b (equal (getf (cddr b) :in-context) :stranger))))))

(multiple-value-bind (res receipt)
    (project-claim *c-tests* :from *source-lab* :to *auditor* :store *store*)
  (check "P7b same claim, recognizing position: receiver's own raise grants"
         (and (claim-judgment res)
              (eq (judgment-record-judgment (claim-judgment res)) :verified)
              (eq (judgment-record-receiver (claim-judgment res)) :auditor)))
  ;; TEETH (negative control): a clean projection fires NO gates.
  (check "teeth-0 clean projection: no blockers, obligations, or ceilings"
         (and (null (projection-receipt-blockers receipt))
              (null (projection-receipt-obligations receipt))
              (null (projection-receipt-ceilings receipt))
              (equal (projection-views receipt) '(:preserved))))
  ;; P10 groundwork: the receiver judgment is a NEW record, not the source's.
  (check "P1b receiver judgment is a fresh licensing, not the source record"
         (not (eq (claim-judgment res) (claim-judgment *c-tests*)))))

;;; ==================================================================
;;; P4 — WARRANT/PROPOSITION MATCHING SURVIVES TRAVEL: an accessible,
;;; recognized warrant for Q is excluded by name; the matching warrant
;;; still licenses.

(multiple-value-bind (res receipt)
    (project-claim *c-tests* :from *source-lab* :to *auditor* :store *store*
                   :offering (list *w-q*))
  (check "P4 warrant for Q cannot support P across contexts"
         (and (claim-judgment res)   ; matching support still grants
              (let ((b (find :proposition-mismatch
                             (projection-receipt-blockers receipt)
                             :key #'first)))
                (and b (identity= (second b) (witness-id *w-q*)))))))

;;; ==================================================================
;;; P3 — TESTIMONY PRESERVES PROPOSITION LEVEL ACROSS TRAVEL: the partner
;;; verifies the ATTRIBUTION; P itself acquires nothing.

(multiple-value-bind (res receipt)
    (project-claim *c-attr* :from *source-lab* :to *partner* :store *store*)
  (declare (ignore receipt))
  (check "P3a attribution claim travels and verifies AS attribution"
         (and (claim-judgment res)
              (equal (claim-proposition res)
                     '(:asserted :operator (:tests-passed :suite-a))))))

(multiple-value-bind (res receipt)
    (project-claim *c-tests* :from *source-lab* :to *partner* :store *store*
                   :offering (list *w-testimony*))
  (check "P3b testimony gives P itself nothing at the receiver"
         (and (null (claim-judgment res))
              (find :proposition-mismatch
                    (projection-receipt-blockers receipt) :key #'first))))

;;; ==================================================================
;;; P5 — REDACTION REQUIRES DERIVATION.

(multiple-value-bind (res receipt)
    (project-claim *c-secret* :from *source-lab* :to *pub-receiver*
                   :store *store* :public-form '(:incident-resolved :today))
  (check "P5a (TEETH) underived public form is blocked by name"
         (and (null (claim-judgment res))
              (find :underived-redaction
                    (projection-receipt-blockers receipt) :key #'first)
              (equal (projection-explanation-proposition-transformations
                      (projection-receipt-explanation receipt))
                     '(((:incident-root-cause :cve-1234)
                        (:incident-resolved :today) :underived))))))

(multiple-value-bind (res receipt)
    (project-claim *c-secret* :from *source-lab* :to *pub-receiver*
                   :store *store* :public-form '(:incident-resolved :today)
                   :derivation *w-derive-pub*)
  (check "P5b derived public form verifies as the DERIVATIVE"
         (and (claim-judgment res)
              (equal (claim-proposition res) '(:incident-resolved :today))
              (= 1 (length (projection-receipt-redactions receipt)))
              (member :redacted (projection-views receipt))))
  ;; the private warrant's non-reifiability is a LOCAL ceiling, recorded
  (check "P5c private warrant crosses as a ceiling, not silently"
         (find :mute (projection-receipt-ceilings receipt) :key #'first)))

;;; ==================================================================
;;; P8 — EVIDENCE MUTENESS IS LOCAL: the closure cannot cross, and the
;;; receiver's own locally minted check verifies the proposition anyway.

(multiple-value-bind (res receipt)
    (project-claim *c-gate* :from *source-lab* :to *gate-receiver*
                   :store *store* :offering (list *w-local-mint*))
  (check "P8 mute object blocks ITS OWN export, not the proposition"
         (and (find :mute (projection-receipt-ceilings receipt) :key #'first)
              (claim-judgment res)
              (eq (judgment-record-judgment (claim-judgment res)) :verified)
              (identity= (first (judgment-record-support-ids
                                 (claim-judgment res)))
                         (witness-id *w-local-mint*)))))

;;; ==================================================================
;;; P9 — PROJECTION CONSEQUENCES COMPOSE: one projection simultaneously
;;; regraded, redacted, and obligation-producing (plus a ceiling).

(multiple-value-bind (res receipt)
    (project-claim *c-secret* :from *source-lab* :to *isolated*
                   :store *store* :public-form '(:incident-resolved :today)
                   :derivation *w-derive-pub*)
  (check "P9 consequences compose (no single-symbol collapse)"
         (and (null (claim-judgment res))
              (subsetp '(:regraded :redacted :obligation-producing)
                       (projection-views receipt))))
  (format t "~&  P9 views: ~s~%  P9 why, rendered from structure:~%"
          (projection-views receipt))
  (render-projection-why receipt))

;;; ==================================================================
;;; P10 — THE ORIGINAL CLAIM REMAINS IMMUTABLE.

(check "P10 source claims untouched by all projections"
       (and (claim-judgment *c-tests*)
            (eq (judgment-record-judgment (claim-judgment *c-tests*)) :verified)
            ;; still exactly the source-side raise revision: one lineage
            ;; entry (its own pre-raise original), nothing appended by travel
            (= 1 (length (claim-lineage *c-tests*)))
            (eq (claim-commitment *c-secret*) :asserted)
            (claim-judgment *c-gate*)))

;;; ==================================================================

(format t "~&~%~d passed, ~d failed~%" *pass* *fail*)
(when (plusp *fail*)
  (sb-ext:exit :code 1))
