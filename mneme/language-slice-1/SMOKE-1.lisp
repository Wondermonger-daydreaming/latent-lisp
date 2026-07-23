;;;; SMOKE-1.lisp — Slice /1 PUBLIC smoke program (the near-stranger's read).
;;;;
;;;; Mini-domain: LAB-NOTEBOOK ENTRY SIGN-OFF.  A notebook entry is "signed off"
;;;; for a reviewer and a purpose only when its declared anatomy is discharged:
;;;; the entry is complete, its results were reproduced, the reviewer is
;;;; qualified, and the purpose is permitted for that reviewer.  Because the
;;;; anatomy is DECLARED in a judgment schema, an omitted / mismatched / plural /
;;;; conflicting premise becomes mechanically visible in a derivation receipt
;;;; before the sign-off can be granted.
;;;;
;;;; This program lives ENTIRELY on single-colon exported surfaces of
;;;; lisp-plus-slice1 / lisp-plus-slice0 / lisp-plus-kernel0.  It defines its OWN
;;;; tiny fixtures (below) — it copies no specimen helper.  Nine numbered
;;;; demonstrations, each under a pass/fail check.
;;;;
;;;; Run: sbcl --non-interactive --load SMOKE-1.lisp   (exit 0 on 9/9)

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "slice1.lisp" *load-truename*))))

(defpackage #:slice1-public-smoke (:use #:cl))
(in-package #:slice1-public-smoke)

;;; ------------------------------------------------------------------
;;; Own fixtures — thin adapters over the public surface, for THIS domain.

(defun np (form)  (lisp-plus-slice1:proposition form))            ; ground proposition
(defun pp (form)  (lisp-plus-slice1:proposition-pattern form))    ; pattern

(defun direct-witness (form &key (kind :observation) (source :signer-desk))
  "A GROUND direct support witness for structured proposition FORM."
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

(defun context-over (id &rest supports)
  "A receiver-context whose accessible supports are the witness ids in SUPPORTS."
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p supports))))

(defun assess (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a)
               (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))

(defun disposition (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition (assess receipt predicate)))

(defun run-derive (schema-name conclusion supports receiver)
  "DERIVE, recovering the receipt either way.  Returns (values RECEIPT CLAIM DECISION)."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive :schema-name schema-name :schema-version 1
                                   :conclusion conclusion :supports supports
                                   :receiver receiver)
        (values receipt claim :granted))
    (lisp-plus-slice1:derivation-refused (c)
      (values (lisp-plus-slice1:slice1-condition-receipt c) nil :refused))))

;;; ------------------------------------------------------------------
;;; The two schemas.  Conclusion vars :entry :reviewer :purpose.

(defun install-schemas ()
  (lisp-plus-slice1:clear-schema-registry)
  ;; Schema 1 — the founding sign-off anatomy; :replicate is a NON-unique local.
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :notebook-signoff :version 1
    :conclusion (pp '(:predicate :entry-signed-off
                      (:entry (:var :entry)) (:reviewer (:var :reviewer))
                      (:purpose (:var :purpose))))
    :premises
    (list (pp '(:predicate :entry-complete
                (:entry (:var :entry)) (:checklist (:var :checklist))))
          (pp '(:predicate :results-reproduced
                (:entry (:var :entry)) (:replicate (:var :replicate))))
          (pp '(:predicate :reviewer-qualified
                (:reviewer (:var :reviewer)) (:competency (:var :competency))))
          (pp '(:predicate :purpose-permitted
                (:entry (:var :entry)) (:reviewer (:var :reviewer))
                (:purpose (:var :purpose)))))
    :locals '(:checklist :replicate :competency)))
  ;; Schema 2 — the reproduction premise additionally carries an :authority role,
  ;; DECLARED uniqueness-bearing.  The material distinction is declared anatomy.
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :notebook-signoff-authority :version 1
    :conclusion (pp '(:predicate :entry-signed-off
                      (:entry (:var :entry)) (:reviewer (:var :reviewer))
                      (:purpose (:var :purpose))))
    :premises
    (list (pp '(:predicate :entry-complete
                (:entry (:var :entry)) (:checklist (:var :checklist))))
          (pp '(:predicate :results-reproduced
                (:entry (:var :entry)) (:replicate (:var :replicate))
                (:authority (:var :authority))))
          (pp '(:predicate :reviewer-qualified
                (:reviewer (:var :reviewer)) (:competency (:var :competency))))
          (pp '(:predicate :purpose-permitted
                (:entry (:var :entry)) (:reviewer (:var :reviewer))
                (:purpose (:var :purpose)))))
    :locals '(:checklist :replicate :competency :authority)
    :unique-locals '(:authority))))

;;; Domain support builders (own; keyed on the roles a behavior needs to vary).
(defun s-complete (&key (entry "entry-88") (checklist "CL-full"))
  (direct-witness `(:predicate :entry-complete (:entry ,entry) (:checklist ,checklist))))
(defun s-reproduced (&key (entry "entry-88") (replicate "rep-1"))
  (direct-witness `(:predicate :results-reproduced (:entry ,entry) (:replicate ,replicate))))
(defun s-reproduced-auth (&key (entry "entry-88") (replicate "rep-1") (authority :internal-lab))
  (direct-witness `(:predicate :results-reproduced (:entry ,entry) (:replicate ,replicate)
                    (:authority ,authority))))
(defun s-qualified (&key (reviewer :reviewer-alice) (competency :radiochem))
  (direct-witness `(:predicate :reviewer-qualified (:reviewer ,reviewer) (:competency ,competency))))
(defun s-permitted (&key (entry "entry-88") (reviewer :reviewer-alice) (purpose :archival))
  (direct-witness `(:predicate :purpose-permitted (:entry ,entry) (:reviewer ,reviewer)
                    (:purpose ,purpose))))
(defun signoff-conclusion (&key (entry "entry-88") (reviewer :reviewer-alice) (purpose :archival))
  (np `(:predicate :entry-signed-off (:entry ,entry) (:reviewer ,reviewer) (:purpose ,purpose))))

;;; ------------------------------------------------------------------
;;; Harness.
(defvar *passed* 0)
(defvar *failed* 0)
(defun check (n label bool)
  (if bool
      (progn (incf *passed*) (format t "  [~D] PASS  ~A~%" n label))
      (progn (incf *failed*) (format t "  [~D] FAIL  ~A~%" n label))))

(install-schemas)
(format t "== SMOKE-1 — Slice /1 public smoke: lab-notebook entry sign-off ==~%")

;;; (1) structured primitive propositions via the public constructor
(format t "~%(1) structured primitive propositions~%")
(let* ((a (np '(:predicate :entry-complete (:entry "entry-88") (:checklist "CL-full"))))
       (b (np '(:predicate :entry-complete (:checklist "CL-full") (:entry "entry-88")))) ; roles reordered
       (c (np '(:predicate :reviewer-qualified (:reviewer :reviewer-alice) (:competency :radiochem)))))
  (format t "    a normal-form-p=~S ; a=b (role-order-insensitive)=~S~%"
          (lisp-plus-slice1:normal-form-p a) (lisp-plus-slice1:structured-proposition= a b))
  (check 1 "ground primitives are normal-form; equality is role-order-insensitive; distinct props differ"
         (and (lisp-plus-slice1:normal-form-p a)
              (lisp-plus-slice1:normal-form-p c)
              (lisp-plus-slice1:structured-proposition= a b)
              (not (lisp-plus-slice1:structured-proposition= a c)))))

;;; (2) one derived conclusion granted via registered schema + derive
(format t "~%(2) derived conclusion granted (real Slice /0 promotion)~%")
(let* ((sup (list (s-complete) (s-reproduced) (s-qualified) (s-permitted)))
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff (signoff-conclusion) sup ctx)
    (let ((jr (and claim (lisp-plus-slice0:claim-judgment claim))))
      (format t "    decision=~S ; claim-prop=~S~%" decision
              (and claim (lisp-plus-slice0:claim-proposition claim)))
      (check 2 "full discharge ⇒ :granted, a real :verified Slice /0 promotion keyed to the derivation"
             (and (eq decision :granted)
                  (eq (lisp-plus-slice1:derivation-receipt-decision r) :granted)
                  (lisp-plus-slice0:claim-p claim)
                  (eq (lisp-plus-slice0:judgment-record-judgment jr) :verified))))))

;;; (3) a named missing premise (refusal receipt names it)
(format t "~%(3) a named missing premise~%")
(let* ((sup (list (s-complete) (s-qualified) (s-permitted)))   ; no results-reproduced
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff (signoff-conclusion) sup ctx)
    (declare (ignore claim))
    (let ((a (assess r :results-reproduced)))
      (format t "    decision=~S ; results-reproduced=~S~%" decision (disposition r :results-reproduced))
      (check 3 "omitting a premise refuses; the receipt names :results-reproduced as :missing"
             (and (eq decision :refused)
                  (eq (disposition r :results-reproduced) :missing)
                  (eq (second (lisp-plus-slice1:premise-assessment-premise-pattern a))
                      :results-reproduced))))))

;;; (4) a purpose mismatch ⇒ :mismatched with the role named
(format t "~%(4) purpose mismatch ⇒ :mismatched (role named)~%")
(let* ((sup (list (s-complete) (s-reproduced) (s-qualified)
                  (s-permitted :purpose :teaching)))            ; permitted for :teaching, not :archival
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff
                                                      (signoff-conclusion :purpose :archival) sup ctx)
    (declare (ignore claim decision))
    (let* ((a (assess r :purpose-permitted))
           (mc (lisp-plus-slice1:premise-assessment-mismatched-candidates a)))
      (format t "    purpose-permitted=~S ; conflicting roles=~S~%"
              (disposition r :purpose-permitted) (and mc (cdr (first mc))))
      (check 4 "a :teaching permission lands :mismatched on role :purpose against an :archival conclusion"
             (and (eq (disposition r :purpose-permitted) :mismatched)
                  (equal (cdr (first mc)) '(:purpose)))))))

;;; (5) multiple sufficient derivations GRANT, all complete environments preserved
(format t "~%(5) plural sufficiency ⇒ GRANT, all environments preserved~%")
(let* ((sup (list (s-complete)
                  (s-reproduced :replicate "rep-1")             ; two independent reproductions
                  (s-reproduced :replicate "rep-2")
                  (s-qualified) (s-permitted)))
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff (signoff-conclusion) sup ctx)
    (declare (ignore claim))
    (let ((envs (lisp-plus-slice1:derivation-receipt-complete-binding-environments r)))
      (format t "    decision=~S ; complete-environments=~D ; multiply-supported=~S ; conflicts=~S~%"
              decision (length envs)
              (lisp-plus-slice1:derivation-receipt-multiply-supported-p r)
              (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
      (check 5 "two sufficient non-unique environments GRANT; both preserved; multiply-supported; no conflict"
             (and (eq decision :granted)
                  (= 2 (length envs))
                  (lisp-plus-slice1:derivation-receipt-multiply-supported-p r)
                  (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r)))))))

;;; (6) declared uniqueness conflict ⇒ REFUSE :ambiguous; receipt names the conflicted local
(format t "~%(6) declared :unique-locals conflict ⇒ REFUSE :ambiguous~%")
(let* ((sup (list (s-complete)
                  (s-reproduced-auth :authority :internal-lab)  ; incompatible authorities
                  (s-reproduced-auth :authority :external-audit)
                  (s-qualified) (s-permitted)))
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff-authority
                                                      (signoff-conclusion) sup ctx)
    (declare (ignore claim))
    (let* ((ucs (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
           (conflict-locals (mapcar #'first ucs)))
      (format t "    decision=~S ; results-reproduced=~S ; named conflict=~S~%"
              decision (disposition r :results-reproduced) conflict-locals)
      (check 6 "a declared uniqueness conflict on :authority REFUSES :ambiguous; receipt names :authority"
             (and (eq decision :refused)
                  (eq (disposition r :results-reproduced) :ambiguous)
                  (= 1 (length ucs))
                  (equal conflict-locals '(:authority)))))))

;;; (7) structured why — render the derivation explanation from the receipt
(format t "~%(7) structured why (rendered from receipt fields only)~%")
(let* ((sup (list (s-complete) (s-qualified)))                  ; 2 satisfied, 2 unsatisfied
       (ctx (apply #'context-over :ctx-alice sup)))
  (multiple-value-bind (r claim decision) (run-derive :notebook-signoff (signoff-conclusion) sup ctx)
    (declare (ignore claim decision))
    (let ((text (with-output-to-string (s) (lisp-plus-slice1:render-derivation-why r s)))
          (facade (lisp-plus-slice1:why r)))
      (format t "    ---- render-derivation-why ----~%")
      (dolist (line (remove "" (loop with start = 0
                                     for nl = (position #\Newline text :start start)
                                     collect (subseq text start (or nl (length text)))
                                     while nl do (setf start (1+ nl)))
                            :test #'string=))
        (format t "    ~A~%" line))
      (check 7 "why façade returns the receipt; render names every premise + its disposition"
             (and (eq facade r)
                  (search "ENTRY-COMPLETE" (string-upcase text))
                  (search "RESULTS-REPRODUCED" (string-upcase text))
                  (search "REVIEWER-QUALIFIED" (string-upcase text))
                  (search "PURPOSE-PERMITTED" (string-upcase text))
                  (search "SATISFIED" (string-upcase text))
                  (search "MISSING" (string-upcase text)))))))

;;; (8) reconstruction under projection — a second receiver re-derives; distinct receipt identities
(format t "~%(8) reconstruction under projection (distinct receipt identities)~%")
(let* ((sup-a (list (s-complete) (s-reproduced)
                    (s-qualified :reviewer :reviewer-alice) (s-permitted :reviewer :reviewer-alice)))
       (ctx-a (apply #'context-over :ctx-alice sup-a))
       (sup-b (list (s-complete) (s-reproduced)
                    (s-qualified :reviewer :reviewer-bob) (s-permitted :reviewer :reviewer-bob)))
       (ctx-b (apply #'context-over :ctx-bob sup-b)))
  (multiple-value-bind (r-a claim-a da)
      (run-derive :notebook-signoff (signoff-conclusion :reviewer :reviewer-alice) sup-a ctx-a)
    (multiple-value-bind (r-b claim-b db)
        (run-derive :notebook-signoff (signoff-conclusion :reviewer :reviewer-bob) sup-b ctx-b)
      (let ((id-a (lisp-plus-kernel0:identity-key (lisp-plus-slice1:derivation-receipt-identity r-a)))
            (id-b (lisp-plus-kernel0:identity-key (lisp-plus-slice1:derivation-receipt-identity r-b))))
        (format t "    receiver-alice receipt id=~A~%    receiver-bob   receipt id=~A~%    distinct=~S~%"
                id-a id-b (not (equal id-a id-b)))
        (check 8 "a second receiver re-derives over its own lawful premises; receipt identities distinct — no copy"
               (and (eq da :granted) (eq db :granted)
                    (lisp-plus-slice0:claim-p claim-a) (lisp-plus-slice0:claim-p claim-b)
                    (not (equal id-a id-b))))))))

;;; (9) transported derivation testimony cannot masquerade as a target-local derivation
(format t "~%(9) transported testimony refused at the frozen gate (no masquerade)~%")
(let* ((sup-a (list (s-complete) (s-reproduced) (s-qualified) (s-permitted)))
       (ctx-a (apply #'context-over :ctx-alice sup-a)))
  (multiple-value-bind (r-a claim-a da) (run-derive :notebook-signoff (signoff-conclusion) sup-a ctx-a)
    (declare (ignore claim-a))
    (let* ((testimony (lisp-plus-slice1:transported-testimony r-a :context-a :ctx-alice))
           (schema (lisp-plus-slice1:resolve-schema :notebook-signoff 1))
           (admit-kind (lisp-plus-slice1:judgment-schema-admit-kind schema))
           (proc (lisp-plus-slice0:promotion-procedure
                  :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                               :procedure-id (lisp-plus-kernel0:make-identity
                                              :procedure "smoke-transport-probe")
                               :version 1 :judgment-class :semantic
                               :result-vocabulary '(:verified))
                  :admits (list (list :derivation admit-kind))))
           (attack-claim (lisp-plus-slice0:claim
                          :proposition (signoff-conclusion :reviewer :reviewer-bob)
                          :by :impostor))
           (refused-p
            (handler-case
                (progn (lisp-plus-slice0:raise attack-claim :to :verified :per proc
                                               :considering (list testimony) :receiver :ctx-bob)
                       nil)                                      ; success ⇒ masquerade ⇒ FAIL
              (lisp-plus-slice0:wrong-proposition-support (c) (declare (ignore c)) t))))
      (format t "    transported support is (~S ~S) ; frozen gate refused it=~S~%"
              (lisp-plus-slice0:witness-mode testimony)
              (lisp-plus-slice0:witness-kind testimony) refused-p)
      (check 9 "a transported (:testimony :derivation-report) support is refused (WRONG-PROPOSITION-SUPPORT) for a derivation-keyed procedure"
             (and (eq da :granted)
                  (eq (lisp-plus-slice0:witness-mode testimony) :testimony)
                  (eq (lisp-plus-slice0:witness-kind testimony) :derivation-report)
                  refused-p)))))

;;; ------------------------------------------------------------------
(format t "~%slice1 public smoke: ~D/~D, ~D failed~%" *passed* (+ *passed* *failed*) *failed*)
(finish-output)
(sb-ext:exit :code (if (zerop *failed*) 0 1))
