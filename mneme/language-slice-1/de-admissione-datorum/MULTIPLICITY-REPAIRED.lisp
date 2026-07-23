;;;; MULTIPLICITY-REPAIRED.lisp — de-admissione-datorum: the plurality experiment,
;;;; re-run under CHARTER-DELTA-2 (the multiplicity ruling).
;;;;
;;;; The historical MULTIPLICITY.lisp found that the founding /1 model CONFLATED
;;;; redundant sufficiency with unresolved semantic choice: two independently
;;;; sufficient certificates and two incompatible authorities both landed the
;;;; SAME :ambiguous refusal.  CHARTER-DELTA-2 adopts the ruling that repairs it:
;;;;
;;;;   (:complete-environment-semantics :existential
;;;;    :default-multiple-complete-environments :grant-and-preserve-all
;;;;    :ambiguity :only-from-declared-uniqueness-constraint
;;;;    :implicit-domain-discriminator :forbidden
;;;;    :environment-selection-by-order :forbidden)
;;;;
;;;;   > Plurality is evidence.  Ambiguity begins only where the schema has
;;;;   > declared that a choice matters.
;;;;
;;;; Three cases, each printed AND expect-asserted:
;;;;
;;;;   CASE A (redundant sufficiency, non-unique :certificate): two independently
;;;;     sufficient calibration certificates ⇒ GRANT; BOTH environments preserved
;;;;     in the receipt; no canonical environment selected by order.
;;;;   CASE B (anatomy-declared conflict): the material distinction is DECLARED —
;;;;     an :authority role (:recognized-vendor vs :self-signed) with
;;;;     :unique-locals (:authority) ⇒ REFUSE :ambiguous; the receipt names
;;;;     :authority (NOT the certificate plurality) as the uniqueness-bearing
;;;;     conflict, with both surviving values; both environments preserved.
;;;;   CASE C (hidden incompatibility stays hidden): the ORIGINAL schema — no
;;;;     authority role, no uniqueness — over the SAME two prose-differing certs
;;;;     ('cert-vendor' vs 'cert-self-signed') ⇒ GRANT with both environments
;;;;     preserved.  The claim ceiling made executable: declared anatomy can be
;;;;     enforced; undeclared domain distinctions cannot be divined.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surfaces only.
;;;;
;;;; Run: sbcl --non-interactive --load MULTIPLICITY-REPAIRED.lisp   (exits 0)

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../slice1.lisp" *load-truename*))))

(defpackage #:de-admissione-datorum-multiplicity-repaired (:use #:cl))
(in-package #:de-admissione-datorum-multiplicity-repaired)

(defun p (form) (lisp-plus-slice1:proposition form))
(defun pat (form) (lisp-plus-slice1:proposition-pattern form))
(defun sw (form &key (kind :observation) (source :data-steward))
  (lisp-plus-slice0:witness :for (p form) :mode :direct :kind kind :source source))
(defun mk-ctx (id &rest supports)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p supports))))
(defun assessment-for (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a)
               (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))
(defun disp (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition (assessment-for receipt predicate)))

(defvar *checks* 0)
(defun expect (bool label)
  (if bool
      (progn (incf *checks*) (format t "   [ok] ~A~%" label))
      (error "MULTIPLICITY-REPAIRED INVARIANT VIOLATED — ~A" label)))

(defun attempt (schema-name &key conclusion supports receiver)
  "Run DERIVE; return (values RECEIPT GRANTED-CLAIM DECISION).  On refusal the
receipt rides in the typed condition, so callers get the receipt either way."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive
           :schema-name schema-name :schema-version 1
           :conclusion conclusion :supports supports :receiver receiver)
        (values receipt claim :granted))
    (lisp-plus-slice1:derivation-refused (c)
      (values (lisp-plus-slice1:slice1-condition-receipt c) nil :refused))))

;;; Certificate value carried per complete environment.
(defun cert-values (receipt)
  (sort (loop for e in (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)
              collect (cdr (assoc :certificate e)))
        #'string<))
(defun authority-values (receipt)
  (sort (loop for e in (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)
              collect (cdr (assoc :authority e)))
        #'string<
        :key (lambda (v) (format nil "~S" v))))

;;; ------------------------------------------------------------------
;;; The ORIGINAL schema (Cases A and C): calibration carries a NON-unique
;;; :certificate schema-local; NO authority role; NO uniqueness declared.
(defun install-original ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :dataset-admissibility :version 1
    :conclusion (pat '(:predicate :dataset-admissible
                       (:dataset (:var :dataset)) (:receiver (:var :receiver))
                       (:purpose (:var :purpose))))
    :premises
    (list (pat '(:predicate :schema-conformance
                 (:dataset (:var :dataset)) (:schema (:var :schema))))
          (pat '(:predicate :measured-by
                 (:dataset (:var :dataset)) (:instrument (:var :instrument))))
          (pat '(:predicate :calibration-valid
                 (:dataset (:var :dataset)) (:instrument (:var :instrument))
                 (:certificate (:var :certificate))))
          (pat '(:predicate :missingness-within-bound
                 (:dataset (:var :dataset)) (:bound (:var :bound))))
          (pat '(:predicate :population-suitable
                 (:dataset (:var :dataset)) (:purpose (:var :purpose))))
          (pat '(:predicate :purpose-permitted
                 (:dataset (:var :dataset)) (:receiver (:var :receiver))
                 (:purpose (:var :purpose)))))
    :locals '(:schema :instrument :certificate :bound))))

;;; The ANATOMY-DECLARED schema (Case B): the calibration premise additionally
;;; carries an :authority role, DECLARED uniqueness-bearing.  The material
;;; distinction is now part of the declared anatomy.
(defun install-authority ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :dataset-admissibility-authority :version 1
    :conclusion (pat '(:predicate :dataset-admissible
                       (:dataset (:var :dataset)) (:receiver (:var :receiver))
                       (:purpose (:var :purpose))))
    :premises
    (list (pat '(:predicate :schema-conformance
                 (:dataset (:var :dataset)) (:schema (:var :schema))))
          (pat '(:predicate :measured-by
                 (:dataset (:var :dataset)) (:instrument (:var :instrument))))
          (pat '(:predicate :calibration-valid
                 (:dataset (:var :dataset)) (:instrument (:var :instrument))
                 (:certificate (:var :certificate)) (:authority (:var :authority))))
          (pat '(:predicate :missingness-within-bound
                 (:dataset (:var :dataset)) (:bound (:var :bound))))
          (pat '(:predicate :population-suitable
                 (:dataset (:var :dataset)) (:purpose (:var :purpose))))
          (pat '(:predicate :purpose-permitted
                 (:dataset (:var :dataset)) (:receiver (:var :receiver))
                 (:purpose (:var :purpose)))))
    :locals '(:schema :instrument :certificate :bound :authority)
    :unique-locals '(:authority))))            ; the DECLARED anatomy of choice

(defun base-supports ()
  "Everything but calibration, single valid support each (?instrument = instrument-a)."
  (list (sw '(:predicate :schema-conformance (:dataset "dataset-1") (:schema "schema-v3")))
        (sw '(:predicate :measured-by (:dataset "dataset-1") (:instrument "instrument-a")))
        (sw '(:predicate :missingness-within-bound (:dataset "dataset-1") (:bound 5)))
        (sw '(:predicate :population-suitable (:dataset "dataset-1") (:purpose :causal)))
        (sw '(:predicate :purpose-permitted (:dataset "dataset-1")
              (:receiver :receiver-a) (:purpose :causal)))))

(defun conclusion ()
  (p '(:predicate :dataset-admissible (:dataset "dataset-1") (:receiver :receiver-a)
       (:purpose :causal))))

;;; ==================================================================
(format t "== de-admissione-datorum MULTIPLICITY-REPAIRED — under CHARTER-DELTA-2 ==~%")
(format t "Plurality is evidence; ambiguity begins only at a declared uniqueness constraint.~%")

;;; ---- CASE A : redundant sufficiency, non-unique :certificate ⇒ GRANT + plural ----
(format t "~%── CASE A : two independently-sufficient certificates {cert-1, cert-2}, :certificate NON-unique~%")
(install-original)
(let* ((cal-1 (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                    (:instrument "instrument-a") (:certificate "cert-1"))))
       (cal-2 (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                    (:instrument "instrument-a") (:certificate "cert-2"))))
       (sup (append (base-supports) (list cal-1 cal-2)))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim decision) (attempt :dataset-admissibility
                                                   :conclusion (conclusion)
                                                   :supports sup :receiver ctx)
    (declare (ignore claim))
    (let ((envs (lisp-plus-slice1:derivation-receipt-complete-binding-environments r)))
      (format t "   decision                       : ~S~%" decision)
      (format t "   calibration disposition        : ~S~%" (disp r :calibration-valid))
      (format t "   complete binding environments  : ~D~%" (length envs))
      (format t "   multiply-supported (derived)   : ~S~%"
              (lisp-plus-slice1:derivation-receipt-multiply-supported-p r))
      (format t "   preserved :certificate values  : ~S~%" (cert-values r))
      (format t "   uniqueness conflicts           : ~S~%"
              (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
      (expect (eq decision :granted) "CASE A grants")
      (expect (eq (disp r :calibration-valid) :satisfied) "CASE A calibration :satisfied")
      (expect (= 2 (length envs)) "CASE A both environments preserved (no canonical selection)")
      (expect (equal (cert-values r) '("cert-1" "cert-2")) "CASE A both certificate bindings present")
      (expect (lisp-plus-slice1:derivation-receipt-multiply-supported-p r) "CASE A multiply-supported")
      (expect (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
              "CASE A no uniqueness conflict (redundant sufficiency is strength, not doubt)"))))

;;; ---- CASE B : declared :authority conflict ⇒ REFUSE :ambiguous, :authority named ----
(format t "~%── CASE B : incompatible authorities {:recognized-vendor, :self-signed}, :authority DECLARED unique~%")
(install-authority)
(let* ((cal-vendor (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                         (:instrument "instrument-a") (:certificate "cert-1")
                         (:authority :recognized-vendor))))
       (cal-self (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                       (:instrument "instrument-a") (:certificate "cert-2")
                       (:authority :self-signed))))
       (sup (append (base-supports) (list cal-vendor cal-self)))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim decision) (attempt :dataset-admissibility-authority
                                                   :conclusion (conclusion)
                                                   :supports sup :receiver ctx)
    (declare (ignore claim))
    (let* ((ucs (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
           (envs (lisp-plus-slice1:derivation-receipt-complete-binding-environments r))
           (conflict-locals (mapcar #'first ucs)))
      (format t "   decision                       : ~S~%" decision)
      (format t "   calibration disposition        : ~S~%" (disp r :calibration-valid))
      (format t "   complete binding environments  : ~D~%" (length envs))
      (format t "   uniqueness conflicts           : ~S~%" ucs)
      (format t "   named conflict local           : ~S~%" conflict-locals)
      (format t "   surviving :authority values    : ~S~%" (authority-values r))
      (format t "   preserved :certificate values  : ~S (plurality, but NOT the named conflict)~%"
              (cert-values r))
      (expect (eq decision :refused) "CASE B refuses")
      (expect (eq (disp r :calibration-valid) :ambiguous) "CASE B calibration :ambiguous")
      (expect (= 1 (length ucs)) "CASE B exactly one named uniqueness conflict")
      (expect (equal conflict-locals '(:authority)) "CASE B the named conflict is :authority")
      (expect (not (member :certificate conflict-locals))
              "CASE B certificate plurality is NOT the named conflict")
      (expect (equal (authority-values r) '(:recognized-vendor :self-signed))
              "CASE B both surviving :authority values named")
      (expect (= 2 (length envs)) "CASE B both environments preserved"))))

;;; ---- CASE C : hidden incompatibility stays hidden ⇒ GRANT (ceiling held) ----
(format t "~%── CASE C : ORIGINAL schema (no authority anatomy) over prose-differing certs {cert-vendor, cert-self-signed}~%")
(install-original)
(let* ((cal-vendor (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                         (:instrument "instrument-a") (:certificate "cert-vendor"))))
       (cal-self (sw '(:predicate :calibration-valid (:dataset "dataset-1")
                       (:instrument "instrument-a") (:certificate "cert-self-signed"))))
       (sup (append (base-supports) (list cal-vendor cal-self)))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim decision) (attempt :dataset-admissibility
                                                   :conclusion (conclusion)
                                                   :supports sup :receiver ctx)
    (declare (ignore claim))
    (let ((envs (lisp-plus-slice1:derivation-receipt-complete-binding-environments r)))
      (format t "   decision                       : ~S~%" decision)
      (format t "   calibration disposition        : ~S~%" (disp r :calibration-valid))
      (format t "   complete binding environments  : ~D~%" (length envs))
      (format t "   preserved :certificate values  : ~S~%" (cert-values r))
      (format t "   uniqueness conflicts           : ~S~%"
              (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
      (expect (eq decision :granted) "CASE C grants")
      (expect (= 2 (length envs)) "CASE C both environments preserved")
      (expect (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))
              "CASE C no conflict inferred from suggestive certificate names")
      (format t "~%   THE CEILING (verbatim):~%")
      (format t "   the language cannot enforce an incompatibility absent from the declared anatomy — declared anatomy can be enforced; undeclared domain distinctions cannot be divined.~%"))))

;;; ==================================================================
(format t "~%==================================================================~%")
(format t "~D expect-checks held.~%" *checks*)
(format t "multiplicity repaired: A granted+plural, B ambiguous-by-declaration, C granted (ceiling held)~%")
(finish-output)
(sb-ext:exit :code 0)
