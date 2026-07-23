;;;; SPECIMEN.lisp — de-promotione: the honest test runner, in Lisp+ Slice /0.
;;;;
;;;; The program below asks to say things stronger than its evidence permits,
;;;; and the language answers.  Domain facts are DISTINCT PROPOSITIONS
;;;; (charter §2), not rungs:
;;;;   (:launched :run-1) (:exited :run-1 0) (:suite-completed :run-1)
;;;;   (:output-parsed :run-1) (:tests-passed :suite-a)
;;;;   (:expected-suite-matched :suite-a) (:release-ok :build-7)
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exit 0 = all pass)

(load (merge-pathnames "../slice0.lisp" *load-truename*))

(defpackage #:de-promotione
  (:use #:cl #:lisp-plus-slice0)
  (:import-from #:lisp-plus-kernel0
                #:make-identity
                #:make-procedure-descriptor))
(in-package #:de-promotione)

(defvar *pass* 0)
(defvar *fail* 0)

(defun check (name ok &optional detail)
  (if ok (incf *pass*) (incf *fail*))
  (format t "~&~:[FAIL~;pass~] ~a~@[ — ~a~]~%" ok name (unless ok detail)))

;;; ==================================================================
;;; T0 — SUBSTRATE TEETH.  A gate that has never fired is untested:
;;; plant faults the slice0 contract layer must catch, and show it does.
;;; (Enforcement lives in SIGNAL-SLICE0 and the WITH-SLICE0-RESTARTS
;;; macroexpansion — NOT in an initialize-instance guard, which is inert
;;; under SBCL's MAKE-CONDITION; execution-verified against kernel0.)

(handler-case
    (progn (signal-slice0 'unsupported-promotion
                          :failed-invariant "planted fault"
                          :permitted-restarts '(continue-anyway))
           (check "T0a signal-slice0 refuses unlawful restart name" nil
                  "no error signaled"))
  (slice0-condition ()
    (check "T0a signal-slice0 refuses unlawful restart name" nil
           "signaled as slice0 despite bogus restart"))
  (error (e)
    (check "T0a signal-slice0 refuses unlawful restart name"
           (search "charter" (format nil "~a" e)))))

(handler-case
    (progn (signal-slice0 'simple-error :failed-invariant "planted fault")
           (check "T0b signal-slice0 refuses foreign condition type" nil
                  "no error signaled"))
  (error (e)
    (check "T0b signal-slice0 refuses foreign condition type"
           (search "not a slice0-condition" (format nil "~a" e)))))

(handler-case
    (progn (eval '(with-slice0-restarts ((continue-anyway () nil)) t))
           (check "T0c with-slice0-restarts refuses unlawful clause" nil
                  "expanded and ran"))
  (error (e)
    (check "T0c with-slice0-restarts refuses unlawful clause"
           (search "not permitted by charter" (format nil "~a" e)))))

;;; ------------------------------------------------------------------
;;; Procedures.  The kernel0 procedure-descriptor supplies identity,
;;; version, and the judgment-class law; the slice adds which (mode kind)
;;; support pairs each procedure admits (charter §7.2-3).

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

(defun structural-procedure (name admits)
  (promotion-procedure
   :descriptor (make-procedure-descriptor
                :procedure-id (make-identity :procedure name)
                :version 0
                :judgment-class :structural
                :input-domain '(:kinds (:subject-answer))
                :result-vocabulary '(:well-formed :malformed)
                :evidence-requirements '())
   :admits admits))

(defparameter *suite-verification*
  (semantic-procedure "suite-verification"
                      '((:direct :transcript-parse) (:direct :suite-match))))

(defparameter *release-verification*
  (semantic-procedure "release-verification"
                      '((:derivation :verified-pipeline))))

(defparameter *launch-audit*
  ;; A structural procedure: competent about process shape, no semantic
  ;; authority.  Test 4's subject.
  (structural-procedure "launch-audit" '((:direct :exit-status))))

;;; ------------------------------------------------------------------
;;; Fixture: one simulated run.  run-1 exited 0; its transcript is complete
;;; and parses; all parsed tests pass; the parsed set matches suite-a.
;;; (Deterministic — no processes, no clock; :produced-at is testified data.)

(defparameter *exit-witness*
  (witness :for '(:exited :run-1 0) :mode :direct :kind :exit-status
           :source :ci-runner :content 0 :produced-at "T1"))

(defparameter *parse-witness*
  (witness :for '(:tests-passed :suite-a) :mode :direct :kind :transcript-parse
           :source :transcript-parser
           :content '(:parsed 12 :failed 0) :produced-at "T2"))

(defparameter *suite-match-witness*
  (witness :for '(:expected-suite-matched :suite-a) :mode :direct
           :kind :suite-match :source :suite-checker
           :content '(:expected 12 :ran 12 :missing ()) :produced-at "T3"))

;;; ==================================================================
;;; OFFICIAL TEST 1 — testimony that execution occurred does not create
;;; direct execution support.  The flattened testimony witness is
;;; UNREPRESENTABLE: the constructor refuses :testimony whose :for is P
;;; itself (charter §6, enforced at construction).

(handler-case
    (progn (witness :for '(:tests-passed :suite-a)      ; P itself — flattened
                    :mode :testimony :kind :report :source :colleague
                    :content "ran it on my machine, all green")
           (check "T1 flattened testimony unrepresentable" nil
                  "constructor accepted flattened testimony"))
  (malformed-slice0-shape (c)
    (check "T1 flattened testimony unrepresentable"
           (eq (slice0-condition-requirement-id c)
               :testimony-preserves-proposition-level))))

;; The lawful form: testimony supports the ATTRIBUTION.
(defparameter *colleague-testimony*
  (witness :for '(:asserted :colleague (:tests-passed :suite-a))
           :mode :testimony :kind :report :source :colleague
           :content "ran it on my machine, all green"))

(check "T1b lawful testimony carries the second-order proposition"
       (witness-p *colleague-testimony*))

;;; ==================================================================
;;; OFFICIAL TEST 2 — testimony supports "S testified that P," never P.
;;; Raising P on the attribution testimony is refused, and the refusal's
;;; strongest-lawful-result offers the attribution claim.

(defparameter *tests-pass-claim*
  (claim :proposition '(:tests-passed :suite-a) :by :build-pipeline))

(handler-case
    (progn (raise *tests-pass-claim* :to :verified :per *suite-verification*
                  :considering (list *colleague-testimony*))
           (check "T2 testimony cannot promote P" nil "raise granted"))
  (wrong-proposition-support (c)
    (let ((w (why c)))
      (check "T2 testimony cannot promote P"
             (equal (getf (getf (why-strongest-lawful-result w) :claim)
                          :proposition)
                    '(:asserted :colleague (:tests-passed :suite-a))))
      ;; Ergonomics check (DPM-4 banking condition): the rendered WHY must
      ;; carry the proposition-level distinction in so many words, derived
      ;; from the structured failed-relation — not composed ad hoc.
      (let ((rendered (with-output-to-string (s) (render-why w s))))
        (check "T2c why renders the proposition-level distinction"
               (search "testimony supports the attribution" rendered))))))

;;; ==================================================================
;;; OFFICIAL TEST 3 — a warrant for Q cannot promote P: the exit status
;;; (a warrant for (:exited :run-1 0)) offered for (:tests-passed :suite-a).

(handler-case
    (progn (raise *tests-pass-claim* :to :verified :per *suite-verification*
                  :considering (list *exit-witness*))
           (check "T3 warrant for Q cannot promote P" nil "raise granted"))
  (wrong-proposition-support (c)
    (check "T3 warrant for Q cannot promote P"
           (eq (slice0-condition-requirement-id c)
               :witness-for-must-equal-claim-proposition))
    ;; OFFICIAL TEST 6 — the refusal names the exact missing relation.
    (let* ((w (why c))
           (rel (first (why-failed-relations w))))
      (check "T6 refusal names the exact missing relation"
             (and (eq (car rel) :proposition-match)
                  (search "(:EXITED :RUN-1 0)" (format nil "~:@(~a~)" (cdr rel)))
                  (search "(:TESTS-PASSED :SUITE-A)"
                          (format nil "~:@(~a~)" (cdr rel)))))
      (format t "~&  the refusal, rendered from structure:~%")
      (render-why w))))

;;; ==================================================================
;;; OFFICIAL TEST 4 — a structural procedure cannot license semantic
;;; verification (kernel0's K0E-25 wall, at the promotion level).

(defparameter *exited-claim*
  (claim :proposition '(:exited :run-1 0) :by :build-pipeline))

(handler-case
    (progn (raise *exited-claim* :to :verified :per *launch-audit*
                  :considering (list *exit-witness*))
           (check "T4 structural procedure cannot verify" nil "raise granted"))
  (inadmissible-procedure (c)
    (check "T4 structural procedure cannot verify"
           (eq (slice0-condition-requirement-id c)
               :semantic-judgment-requires-semantic-procedure))))

;;; ==================================================================
;;; OFFICIAL TEST 5 — direct standing mutation is unavailable through the
;;; public surface: (a) the claim constructor accepts no :judgment;
;;; (b) every slot is read-only — SETF does not exist for it.

(handler-case
    (progn (claim :proposition '(:tests-passed :suite-a) :by :me
                  :judgment :verified)
           (check "T5a constructor cannot mint judgment" nil "accepted :judgment"))
  (error () (check "T5a constructor cannot mint judgment" t)))

(handler-case
    (progn (eval '(setf (lisp-plus-slice0:claim-judgment
                         (lisp-plus-slice0:claim
                          :proposition '(:tests-passed :suite-a) :by :me))
                        :verified))
           (check "T5b no setf on claim-judgment" nil "setf succeeded"))
  (error () (check "T5b no setf on claim-judgment" t)))

;;; ==================================================================
;;; OFFICIAL TEST 7 — lawful repairs.

;; 7a. retain-current-claim: the assertion survives, the receipt records
;;     the attempt, nothing is promoted.
(multiple-value-bind (revision receipt)
    (handler-bind ((wrong-proposition-support
                     (lambda (c)
                       (invoke-restart 'retain-current-claim
                                       (slice0-condition-receipt c)))))
      (raise *tests-pass-claim* :to :verified :per *suite-verification*
             :considering (list *exit-witness*)))
  (check "T7a retain-current-claim preserves assertion"
         (and (null revision)
              (promotion-receipt-p receipt)
              (eq (promotion-receipt-decision receipt) :refused)
              (eq (claim-commitment *tests-pass-claim*) :asserted)
              (null (claim-judgment *tests-pass-claim*)))))

;; 7b. seek-matching-support: supply the witness that actually stands in
;;     the needed relation; the SAME raise then grants.
(multiple-value-bind (revision receipt)
    (handler-bind ((wrong-proposition-support
                     (lambda (c)
                       (declare (ignore c))
                       (invoke-restart 'seek-matching-support
                                       (list *parse-witness*)))))
      (raise *tests-pass-claim* :to :verified :per *suite-verification*
             :considering (list *exit-witness*)))
  (check "T7b seek-matching-support repairs the raise"
         (and (claim-p revision)
              (eq (promotion-receipt-decision receipt) :granted)
              (eq (judgment-record-judgment (claim-judgment revision))
                  :verified)
              ;; lineage: the revision names the asserted original (Q5)
              (equal (claim-lineage revision)
                     (list (claim-id *tests-pass-claim*)))
              (null (claim-judgment *tests-pass-claim*)))))

;; 7c. construct-attribution-claim: say the thing the evidence supports.
(multiple-value-bind (attribution receipt)
    (handler-bind ((wrong-proposition-support
                     (lambda (c)
                       (invoke-restart 'construct-attribution-claim
                                       *colleague-testimony*
                                       (slice0-condition-receipt c)))))
      (raise *tests-pass-claim* :to :verified :per *suite-verification*
             :considering (list *colleague-testimony*)))
  (check "T7c construct-attribution-claim"
         (and (claim-p attribution)
              (equal (claim-proposition attribution)
                     '(:asserted :colleague (:tests-passed :suite-a)))
              (eq (claim-commitment attribution) :asserted)
              (eq (promotion-receipt-decision receipt) :refused))))

;; 7d. defer-judgment.
(multiple-value-bind (revision receipt)
    (handler-bind ((unsupported-promotion
                     (lambda (c)
                       (invoke-restart 'defer-judgment
                                       (slice0-condition-receipt c)))))
      (raise *exited-claim* :to :verified :per *suite-verification*
             :considering '()))
  (check "T7d defer-judgment records deferral"
         (and (null revision)
              (getf (promotion-receipt-residue receipt) :deferred))))

;;; ==================================================================
;;; OFFICIAL TEST 8 — refuting support preserves BOTH the assertion event
;;; and the refuting judgment (charter §5, Q7).

(defparameter *bad-parse-witness*
  ;; a parse of run-2's complete transcript: three failures
  (witness :for '(:tests-passed :suite-a) :mode :direct :kind :transcript-parse
           :source :transcript-parser :polarity :refutes
           :content '(:parsed 12 :failed 3) :produced-at "T4"))

(handler-case
    (progn (raise *tests-pass-claim* :to :verified :per *suite-verification*
                  :considering (list *bad-parse-witness*))
           (check "T8 refutation refuses :verified" nil "raise granted"))
  (unsupported-promotion (c)
    (let ((residue (promotion-receipt-residue (slice0-condition-receipt c))))
      (check "T8 refutation refuses :verified"
             (and (eq (getf residue :original-commitment) :asserted)
                  (eq (getf residue :requested-judgment) :verified)
                  (eq (getf residue :decision) :refused)
                  (eq (getf residue :current-judgment) :refuted))))))

;; ...and the refuting judgment is GRANTABLE as what it is:
(multiple-value-bind (refuted-revision receipt)
    (raise *tests-pass-claim* :to :refuted :per *suite-verification*
           :considering (list *bad-parse-witness*))
  (check "T8b refuting judgment recorded without erasing assertion"
         (and (eq (judgment-record-judgment (claim-judgment refuted-revision))
                  :refuted)
              (eq (claim-commitment refuted-revision) :asserted)
              (equal (claim-lineage refuted-revision)
                     (list (claim-id *tests-pass-claim*)))
              (eq (promotion-receipt-decision receipt) :granted))))

;;; ==================================================================
;;; THE LAWFUL PROGRAM (acceptance clause 6: intelligibility).  The honest
;;; pipeline, end to end — this is what correct use reads like.

(format t "~&~%;;; the lawful pipeline ---------------------------------~%")

(let* ((tests-pass (claim :proposition '(:tests-passed :suite-a)
                          :by :build-pipeline))
       (suite-match (claim :proposition '(:expected-suite-matched :suite-a)
                           :by :build-pipeline))
       (release (claim :proposition '(:release-ok :build-7)
                       :by :release-manager)))
  (multiple-value-bind (tests-pass-v r1)
      (raise tests-pass :to :verified :per *suite-verification*
             :considering (list *parse-witness*))
    (multiple-value-bind (suite-match-v r2)
        (raise suite-match :to :verified :per *suite-verification*
               :considering (list *suite-match-witness*))
      ;; The release rests on the verified pipeline — a derivation witness
      ;; whose content NAMES the two verified revisions it derives from.
      (let ((pipeline-witness
              (witness :for '(:release-ok :build-7)
                       :mode :derivation :kind :verified-pipeline
                       :source :release-manager
                       :content (list (claim-id tests-pass-v)
                                      (claim-id suite-match-v)))))
        (multiple-value-bind (release-v r3)
            (raise release :to :verified :per *release-verification*
                   :considering (list pipeline-witness))
          (check "lawful pipeline: release verified on derivation"
                 (and (eq (judgment-record-judgment
                           (claim-judgment release-v)) :verified)
                      (every (lambda (r) (eq (promotion-receipt-decision r)
                                             :granted))
                             (list r1 r2 r3))))
          (format t "~&  release granted; its why, rendered from structure:~%")
          (render-why (promotion-receipt-explanation r3)))))))

;;; And the partial-output attack in the same lawful vocabulary: run-3
;;; exited 0 but its suite was killed mid-way — there IS no complete
;;; transcript parse, so the only offerable witnesses are the exit status
;;; and testimony; both already refused above (T3, T2).  The language
;;; leaves the attacker nothing to offer.

;;; ==================================================================

(format t "~&~%~d passed, ~d failed~%" *pass* *fail*)
(when (plusp *fail*)
  (sb-ext:exit :code 1))
