;;;; guide-walk-the-recipe.lisp
;;;;
;;;; WALK THE RECIPE (CLAUDE.md §I-f, fourth corollary: a procedure is audited by
;;;; SIMULATION, not by inspection).  This file is what a reader GETS if they do
;;;; exactly what LANGUAGE-SLICE-1-GUIDE.md tells them to do: load slice1.lisp,
;;;; paste the Setup fixtures once, then run the documented examples.
;;;;
;;;; The Setup block below is copied VERBATIM from the guide AS CORRECTED
;;;; 2026-07-25.  Every asserted value is the value the guide PRINTS as its
;;;; expected output, so a mismatch here means the guide lies to its reader.
;;;;
;;;; Run:  sbcl --noinform --non-interactive --load _staging/guide-walk-the-recipe.lisp
;;;; Chair: Claude Opus 5 (1M context), 2026-07-25.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "slice1.lisp" *load-truename*)))

(defparameter *failures* 0)
(defun ok (label got want)
  (let ((pass (equal got want)))
    (unless pass (incf *failures*))
    (format t "~&  ~:[FAIL~;ok  ~] ~A~%        got=~S want=~S~%" pass label got want)))

;;; ========================= GUIDE "Setup" BLOCK, VERBATIM =========================
(defun np (form) (lisp-plus-slice1:proposition form))          ; GROUND proposition
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))  ; PATTERN (may carry vars)

(defun dw (form &key (kind :observation) (source :desk))       ; a direct ground witness
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

(defun ctx (id &rest supports)                                 ; a receiver position
  ;; A witness is reached by its WITNESS-ID; a judged claim by its CLAIM-ID —
  ;; ONE id-membership rule, read against two durable identities. Collect BOTH.
  ;; A desk that names only witness ids refuses the lawful path (a genuinely
  ;; granted claim arrives :INACCESSIBLE) while still accepting a hand-built
  ;; witness asserting the same proposition. Refutations are matched by
  ;; proposition and carry no accessibility check, so they need no id here.
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice0:witness-p s) (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)   (list (lisp-plus-slice0:claim-id s)))))
           supports)))

(defun assess (receipt predicate)                              ; the assessment for one premise
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))
(defun disposition (receipt predicate)                         ; its one-of-six disposition
  (lisp-plus-slice1:premise-assessment-disposition (assess receipt predicate)))
;;; ======================= END GUIDE "Setup" BLOCK, VERBATIM =======================

(format t "~&~%== guide: role-order insensitivity (lines 88-94) ==~%")
(ok "[G1] structured-proposition= is role-order-insensitive"
    (lisp-plus-slice1:structured-proposition=
     (np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
     (np '(:predicate :entry-complete (:checklist "CL-full") (:entry "e-88")))) t)
(ok "[G2] normal-form-p"
    (lisp-plus-slice1:normal-form-p
     (np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))) t)
(ok "[G3] roles are sorted at construction (:checklist before :entry)"
    (np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
    '(:PREDICATE :ENTRY-COMPLETE (:CHECKLIST "CL-full") (:ENTRY "e-88")))

;;; ---- guide: the schema, verbatim (lines 99-113) ----
(lisp-plus-slice1:clear-schema-registry)
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

(format t "~&~%== guide Mistake 1: the grant (lines 119-132) ==~%")
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (position (apply #'ctx :alice sup)))
  (multiple-value-bind (claim receipt)
      (lisp-plus-slice1:derive
        :schema-name :notebook-signoff :schema-version 1
        :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
        :supports sup :receiver position)
    (ok "[G4] decision (guide says :GRANTED)"
        (lisp-plus-slice1:derivation-receipt-decision receipt) :granted)
    (ok "[G5] judgment (guide says :VERIFIED)"
        (lisp-plus-slice0:judgment-record-judgment (lisp-plus-slice0:claim-judgment claim)) :verified)))

(format t "~&~%== guide Mistake 1: the refusal (AS CORRECTED 2026-07-25) ==~%")
(let ((sup (list (dw '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
                 (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                 (dw '(:predicate :purpose-permitted (:entry "e-88") (:reviewer :alice) (:purpose :archival))))))
  (handler-case
      (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
        :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
        :supports sup
        :receiver (apply #'ctx :alice sup))
    (lisp-plus-slice1:derivation-refused (c)
      (let ((r (lisp-plus-slice1:slice1-condition-receipt c)))
        (ok "[G6] decision (guide says :REFUSED)"
            (lisp-plus-slice1:derivation-receipt-decision r) :refused)
        (ok "[G7] strongest-lawful-result, verbatim from the guide"
            (lisp-plus-slice1:derivation-receipt-strongest-lawful-result r)
            '(:BLOCKED-ON :RESULTS-REPRODUCED :MISSING))))))

(format t "~&~%== guide Mistake 2: plurality is evidence (lines 178-191) ==~%")
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-2")))
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (receipt (nth-value 1 (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
                  :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
                  :supports sup :receiver (apply #'ctx :alice sup)))))
  (ok "[G8] decision" (lisp-plus-slice1:derivation-receipt-decision receipt) :granted)
  (ok "[G9] complete environments (guide says 2)"
      (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)) 2)
  (ok "[G10] multiply-supported-p (guide says T)"
      (lisp-plus-slice1:derivation-receipt-multiply-supported-p receipt) t)
  (ok "[G11] uniqueness-conflicts (guide says NIL)"
      (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt) nil))

(format t "~&~%== guide Mistake 1: :MISMATCHED names the conflicting role (lines 158-163) ==~%")
(handler-case
    (let ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                     (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                     (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                     (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :teaching))))))
      (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
        :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
        :supports sup :receiver (apply #'ctx :alice sup)))
  (lisp-plus-slice1:derivation-refused (c)
    (let ((r (lisp-plus-slice1:slice1-condition-receipt c)))
      (ok "[G12] disposition (guide says :MISMATCHED)"
          (disposition r :purpose-permitted) :mismatched)
      (ok "[G13] conflicting role (guide says (:PURPOSE))"
          (cdr (first (lisp-plus-slice1:premise-assessment-mismatched-candidates
                       (assess r :purpose-permitted))))
          '(:PURPOSE)))))

(format t "~&~%== guide Mistake 4: transported receipt comes out at TESTIMONY level (lines 243-247) ==~%")
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (receipt-a (nth-value 1 (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
                    :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
                    :supports sup :receiver (apply #'ctx :alice sup))))
       (t-support (lisp-plus-slice1:transported-testimony receipt-a :context-a :alice)))
  (ok "[G14] witness-mode (guide says :TESTIMONY)"
      (lisp-plus-slice0:witness-mode t-support) :testimony)
  (ok "[G15] witness-kind (guide says :DERIVATION-REPORT)"
      (lisp-plus-slice0:witness-kind t-support) :derivation-report))

;;; ---------------- THE NEW CAPABILITY, through the PASTED fixture ----------------
(format t "~&~%== the lawful judged-claim path, through the pasted fixture ==~%")
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :reproduction-established :version 1
  :conclusion (pp '(:predicate :results-reproduced
                    (:entry (:var :entry)) (:replicate (:var :replicate))))
  :premises (list (pp '(:predicate :run-logged (:entry (:var :entry))
                        (:replicate (:var :replicate)) (:log (:var :log)))))
  :locals '(:log)))

(let* ((w (dw '(:predicate :run-logged (:entry "e-88") (:replicate "rep-1") (:log "log-9"))))
       (repro (lisp-plus-slice1:derive
               :schema-name :reproduction-established :schema-version 1
               :conclusion (np '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
               :supports (list w) :receiver (ctx :alice w)))
       (sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  repro
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival))))))
  ;; A regression here must report a FAIL, not abort the run: if the pasted `ctx`
  ;; ever stops collecting claim ids, DERIVE signals DERIVATION-REFUSED and an
  ;; unguarded call would kill the guard mid-file, losing the diagnosis. Catch it
  ;; and read the receipt, which names the exact repair.
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
            :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
            :supports sup :receiver (apply #'ctx :alice sup))
        (ok "[G16] a judged claim reaches the desk the reader pasted"
            (lisp-plus-slice1:derivation-receipt-decision receipt) :granted)
        (ok "[G17] its premise reads :SATISFIED, not :INACCESSIBLE"
            (disposition receipt :results-reproduced) :satisfied)
        (ok "[G18] the grant is a real Slice /0 promotion"
            (lisp-plus-slice0:judgment-record-judgment (lisp-plus-slice0:claim-judgment claim)) :verified))
    (lisp-plus-slice1:derivation-refused (c)
      (let ((r (lisp-plus-slice1:slice1-condition-receipt c)))
        (ok "[G16] a judged claim reaches the desk the reader pasted"
            (lisp-plus-slice1:derivation-receipt-decision r) :granted)
        (ok "[G17] its premise reads :SATISFIED, not :INACCESSIBLE"
            (disposition r :results-reproduced) :satisfied)
        (ok "[G18] the grant is a real Slice /0 promotion" :refused-so-no-claim :verified)
        (format t "~&        THE GUIDE'S PASTED FIXTURE HAS REGRESSED. The receipt's~%")
        (format t "~&        own repair advice: ~S~%"
                (lisp-plus-slice1:derivation-receipt-repair-options r))))))

(format t "~&~%walk-the-recipe: ~D of 18 check(s) FAILED~%" *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
