;;;; GUIDE-REPAIR-1-REPRO.lisp — bite-before-cure evidence for the two guide
;;;; defects corrected in LANGUAGE-SLICE-1-GUIDE.md on 2026-07-25.
;;;;
;;;; Run: sbcl --non-interactive --load GUIDE-REPAIR-1-REPRO.lisp   (exit 0 on 9/9)
;;;;
;;;; DEFECT 1 — the paste-once `ctx` fixture (guide "Setup") collected WITNESS IDS
;;;; ONLY.  Part A shows the resulting convenience asymmetry: pasted as instructed,
;;;; the LAWFUL path (a genuinely judged claim offered as premise support) REFUSES
;;;; :INACCESSIBLE, while the UNSAFE path (a hand-built witness asserting the same
;;;; proposition, with no derivation behind it) GRANTS.  Part B shows the corrected
;;;; fixture repairs the lawful path.  Part C states the ceiling: it does NOT close
;;;; the stratum-3 escape — fabrication still grants — so the repair removes an
;;;; asymmetry and must not be read as a gate.
;;;;
;;;; WHY IT WAS NOT AN AUTHORING ERROR.  The fixture was published 2026-07-23
;;;; (05dbcc19), when a claim offered in :SUPPORTS was silently discarded, so naming
;;;; its id would have bought nothing.  It became a trap 25 hours later, when
;;;; judged-claim premise discharge was adopted (21607ec1, Sol Decision 1; erratum
;;;; E3 discharged).  The capability outgrew the teaching material — a pre-heal
;;;; fossil of a CAPABILITY GAP rather than of a bug.
;;;;
;;;; DEFECT 2 — found by WALKING the guide, not reading it (see GUIDE-WALK-1.lisp).
;;;; The refusal example passed `:receiver (ctx :alice)` — the fixture with NO
;;;; supports — so the desk reached nothing and the FIRST premise blocked, and the
;;;; printed result (:BLOCKED-ON :RESULTS-REPRODUCED :MISSING) was unreachable as
;;;; written.  Part D proves this is PRE-EXISTING (both fixtures agree) and that the
;;;; cause is a dropped APPLY, not a wrong expected value.
;;;;
;;;; Chair: Claude Opus 5 (1M context), 2026-07-25. SBCL 2.4.6, wrapper
;;;; operation-checked via (lisp-implementation-version) before the run.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "slice1.lisp" *load-truename*)))

(defparameter *failures* 0)
(defun rep (label got want)
  (let ((pass (equal got want)))
    (unless pass (incf *failures*))
    (format t "~&  ~:[FAIL~;ok  ~] ~A~%        got=~S want=~S~%" pass label got want)))

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))
(defun dw (form &key (kind :observation) (source :desk))
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

;;; The fixture AS FIRST PUBLISHED (2026-07-23, 05dbcc19) — witness ids only.
(defun ctx-original (id &rest witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id
                                (remove-if-not #'lisp-plus-slice0:witness-p witnesses))))

;;; The fixture AS CORRECTED (2026-07-25) — witness ids AND claim ids, mirroring
;;; AT-THE-DESK in language-core-0/de-bibliotheca-peregrina/APPLICATION.lisp.
(defun ctx-corrected (id &rest supports)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice0:witness-p s) (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)   (list (lisp-plus-slice0:claim-id s)))))
           supports)))

(defun assess-of (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))
(defun disposition-of (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition (assess-of receipt predicate)))

;;; ------------------------------------------------------------------ schemas
(lisp-plus-slice1:clear-schema-registry)

;;; The guide's running schema, verbatim.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :notebook-signoff :version 1
  :conclusion (pp '(:predicate :entry-signed-off
                    (:entry (:var :entry)) (:reviewer (:var :reviewer))
                    (:purpose (:var :purpose))))
  :premises
  (list (pp '(:predicate :entry-complete    (:entry (:var :entry)) (:checklist (:var :checklist))))
        (pp '(:predicate :results-reproduced (:entry (:var :entry)) (:replicate (:var :replicate))))
        (pp '(:predicate :reviewer-qualified (:reviewer (:var :reviewer)) (:competency (:var :competency))))
        (pp '(:predicate :purpose-permitted  (:entry (:var :entry)) (:reviewer (:var :reviewer))
                                             (:purpose (:var :purpose)))))
  :locals '(:checklist :replicate :competency)))

;;; An upstream schema, so :results-reproduced can be established by a real
;;; governed judgment rather than asserted by a bare witness.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :reproduction-established :version 1
  :conclusion (pp '(:predicate :results-reproduced
                    (:entry (:var :entry)) (:replicate (:var :replicate))))
  :premises (list (pp '(:predicate :run-logged (:entry (:var :entry))
                        (:replicate (:var :replicate)) (:log (:var :log)))))
  :locals '(:log)))

(defparameter *conclusion*
  (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival))))

(defun other-three ()
  (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
        (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
        (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))

(defun signoff (supports receiver)
  "Return (values decision receipt) for one signoff attempt, refusal or grant."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
            :conclusion *conclusion* :supports supports :receiver receiver)
        (declare (ignore claim))
        (values (lisp-plus-slice1:derivation-receipt-decision receipt) receipt))
    (lisp-plus-slice1:derivation-refused (c)
      (let ((r (lisp-plus-slice1:slice1-condition-receipt c)))
        (values (lisp-plus-slice1:derivation-receipt-decision r) r)))))

(defun a-real-judged-claim ()
  "A :RESULTS-REPRODUCED claim carrying an actual governed :VERIFIED judgment."
  (let ((w (dw '(:predicate :run-logged (:entry "e-88") (:replicate "rep-1") (:log "log-9")))))
    (lisp-plus-slice1:derive
     :schema-name :reproduction-established :schema-version 1
     :conclusion (np '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
     :supports (list w) :receiver (ctx-original :alice w))))

;;; ============================ DEFECT 1, PART A ============================
(format t "~&~%== A. THE ASYMMETRY, under the fixture AS PUBLISHED ==~%")
(let* ((claim (a-real-judged-claim))
       (sup (cons claim (other-three))))
  (multiple-value-bind (decision receipt) (signoff sup (apply #'ctx-original :alice sup))
    (rep "[A1] the LAWFUL path (a judged claim) REFUSES" decision :refused)
    (rep "[A2] the judged claim is :INACCESSIBLE to the desk that was handed it"
         (disposition-of receipt :results-reproduced) :inaccessible)))
(let* ((fabricated (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1"))))
       (sup (cons fabricated (other-three))))
  (multiple-value-bind (decision receipt) (signoff sup (apply #'ctx-original :alice sup))
    (rep "[A3] the UNSAFE path (hand-built witness, no derivation) GRANTS"
         decision :granted)
    (rep "[A4] and reads :SATISFIED" (disposition-of receipt :results-reproduced) :satisfied)))

;;; ============================ DEFECT 1, PART B ============================
(format t "~&~%== B. THE CURE, under the fixture AS CORRECTED ==~%")
(let* ((claim (a-real-judged-claim))
       (sup (cons claim (other-three))))
  (multiple-value-bind (decision receipt) (signoff sup (apply #'ctx-corrected :alice sup))
    (rep "[B1] the lawful path now GRANTS" decision :granted)
    (rep "[B2] the judged claim SATISFIES the premise"
         (disposition-of receipt :results-reproduced) :satisfied)))

;;; ============================ DEFECT 1, PART C ============================
(format t "~&~%== C. THE CEILING — the fixture is NOT a fabrication gate ==~%")
(let* ((fabricated (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1"))))
       (sup (cons fabricated (other-three))))
  (multiple-value-bind (decision receipt) (signoff sup (apply #'ctx-corrected :alice sup))
    (declare (ignore receipt))
    (rep "[C1] fabrication STILL grants — the repair removes the ASYMMETRY only;
        the stratum-3 escape stands, per the third ceiling in the guide"
         decision :granted)))

;;; ============================== DEFECT 2 ==================================
(format t "~&~%== D. THE REFUSAL EXAMPLE — pre-existing, and a dropped APPLY ==~%")
(defun refusal-example (receiver-fn &key apply-supports)
  (let ((sup (other-three)))
    (handler-case
        (progn (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
                 :conclusion *conclusion* :supports sup
                 :receiver (if apply-supports
                               (apply receiver-fn :alice sup)
                               (funcall receiver-fn :alice)))
               :no-refusal)
      (lisp-plus-slice1:derivation-refused (c)
        (lisp-plus-slice1:derivation-receipt-strongest-lawful-result
         (lisp-plus-slice1:slice1-condition-receipt c))))))

(rep "[D1] as written, BOTH fixtures give the same wrong answer — NOT a regression"
     (list (refusal-example #'ctx-original) (refusal-example #'ctx-corrected))
     '((:BLOCKED-ON :ENTRY-COMPLETE :INACCESSIBLE)
       (:BLOCKED-ON :ENTRY-COMPLETE :INACCESSIBLE)))
(rep "[D2] supply the supports and the guide's PRINTED value appears — the expected
        value was right, the receiver argument was wrong"
     (list (refusal-example #'ctx-original :apply-supports t)
           (refusal-example #'ctx-corrected :apply-supports t))
     '((:BLOCKED-ON :RESULTS-REPRODUCED :MISSING)
       (:BLOCKED-ON :RESULTS-REPRODUCED :MISSING)))

(format t "~&~%GUIDE-REPAIR-1 repro: ~D of 9 check(s) FAILED~%" *failures*)
(format t "~&Companion: GUIDE-WALK-1.lisp re-executes the guide's 18 documented~%")
(format t "~&values through the pasted Setup block, and is the standing guard~%")
(format t "~&against this defect class recurring the next time the language grows.~%")
(sb-ext:exit :code (if (zerop *failures*) 0 1))
