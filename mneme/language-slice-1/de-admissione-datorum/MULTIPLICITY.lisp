;;;; MULTIPLICITY.lisp — de-admissione-datorum: the plurality experiment.
;;;;
;;;; A separate program from SPECIMEN, with its own run and its own section in
;;;; EXPECTED-FAILURES.  It interrogates the CURRENT semantics rather than
;;;; confirming a design: when a single premise is discharged by MORE THAN ONE
;;;; sufficient support, what does the frozen substrate do?
;;;;
;;;; The calibration-valid premise carries a schema-local :certificate.  Two
;;;; calibration supports for the SAME instrument, differing only in :certificate,
;;;; bind ?certificate two ways — two distinct coherent binding environments over
;;;; one premise.
;;;;
;;;;   CASE A — two INDEPENDENTLY SUFFICIENT certificates (cert-1, cert-2): each
;;;;            alone would discharge calibration; together they are redundant
;;;;            strength.  PRE-REGISTERED PREDICTION (errata 3): :ambiguous refusal
;;;;            — plurality read as doubt.
;;;;   CASE B — two MATERIALLY INCOMPATIBLE certificates (cert-vendor,
;;;;            cert-self-signed): coherent bindings implying different
;;;;            authority/provenance, with NO schema discriminator between them.
;;;;            This SHOULD be :ambiguous.
;;;;
;;;; The verdict: does the substrate DISTINGUISH A (redundant sufficiency) from B
;;;; (genuine under-specification)?  Prediction: NO — both :ambiguous identically.
;;;; No repair is implemented; the finding is the success.  Exit 0.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surfaces only.
;;;;
;;;; Run: sbcl --non-interactive --load MULTIPLICITY.lisp   (exits 0)

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../slice1.lisp" *load-truename*))))

(defpackage #:de-admissione-datorum-multiplicity (:use #:cl))
(in-package #:de-admissione-datorum-multiplicity)

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

(defun attempt (&key conclusion supports receiver)
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive
           :schema-name :dataset-admissibility :schema-version 1
           :conclusion conclusion :supports supports :receiver receiver)
        (values receipt claim :granted))
    (lisp-plus-slice1:derivation-refused (c)
      (values (lisp-plus-slice1:slice1-condition-receipt c) nil :refused))))

;;; Same schema as SPECIMEN — :measured-by (binds ?instrument) BEFORE
;;; :calibration-valid (:certificate schema-local, the multiplicity carrier).
(defun install-schema ()
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

(defun base-supports ()
  "Everything but calibration, single valid support each — measured-by binds
?instrument = instrument-a."
  (list (sw '(:predicate :schema-conformance (:dataset "dataset-1") (:schema "schema-v3")))
        (sw '(:predicate :measured-by (:dataset "dataset-1") (:instrument "instrument-a")))
        (sw '(:predicate :missingness-within-bound (:dataset "dataset-1") (:bound 5)))
        (sw '(:predicate :population-suitable (:dataset "dataset-1") (:purpose :causal)))
        (sw '(:predicate :purpose-permitted (:dataset "dataset-1")
              (:receiver :receiver-a) (:purpose :causal)))))

(defun conclusion ()
  (p '(:predicate :dataset-admissible (:dataset "dataset-1") (:receiver :receiver-a)
       (:purpose :causal))))

(defun run-case (label cert-1 cert-2)
  "Two calibration certs for instrument-a differing only in :certificate.  Returns
(values DISPOSITION AMBIGUITIES DECISION)."
  (let* ((cal-1 (sw `(:predicate :calibration-valid (:dataset "dataset-1")
                      (:instrument "instrument-a") (:certificate ,cert-1))))
         (cal-2 (sw `(:predicate :calibration-valid (:dataset "dataset-1")
                      (:instrument "instrument-a") (:certificate ,cert-2))))
         (sup (append (base-supports) (list cal-1 cal-2)))
         (ctx (apply #'mk-ctx :ctx sup)))
    (multiple-value-bind (r claim decision) (attempt :conclusion (conclusion)
                                                     :supports sup :receiver ctx)
      (declare (ignore claim))
      (let ((a (assessment-for r :calibration-valid)))
        (format t "~%── CASE ~A : calibration certs {~S, ~S} for instrument-a~%"
                label cert-1 cert-2)
        (format t "   overall decision            : ~S~%" decision)
        (format t "   calibration disposition     : ~S~%" (disp r :calibration-valid))
        (format t "   distinct binding environments: ~D~%"
                (length (lisp-plus-slice1:premise-assessment-binding-environments a)))
        (format t "   ambiguity list (verbatim)   : ~S~%"
                (lisp-plus-slice1:premise-assessment-ambiguities a))
        (format t "   matching accessible supports: ~D~%"
                (length (lisp-plus-slice1:premise-assessment-matching-accessible-supports a)))
        (values (disp r :calibration-valid)
                (lisp-plus-slice1:premise-assessment-ambiguities a)
                decision)))))

;;; ==================================================================
(install-schema)
(format t "== de-admissione-datorum MULTIPLICITY — the plurality experiment ==~%")
(format t "Pre-registered prediction (EXPECTED-FAILURES, errata 3): CASE A ⇒ :ambiguous~%")

(multiple-value-bind (disp-a amb-a dec-a)
    (run-case "A (redundant sufficiency)" "cert-1" "cert-2")
  (declare (ignore amb-a))
  (multiple-value-bind (disp-b amb-b dec-b)
      (run-case "B (incompatible authority)" "cert-vendor" "cert-self-signed")
    (declare (ignore amb-b))

    (format t "~%==================================================================~%")
    (format t "OBSERVED — recording what the CURRENT semantics DID:~%")
    (format t "  CASE A calibration disposition : ~S  (overall ~S)~%" disp-a dec-a)
    (format t "  CASE B calibration disposition : ~S  (overall ~S)~%" disp-b dec-b)

    ;; The question the mission requires answered in the output:
    (format t "~%QUESTION (CASE A): should two independently-sufficient proofs be~%")
    (format t "  refused as ambiguous, or GRANTED with multiple derivation paths preserved?~%")
    (if (eq disp-a :ambiguous)
        (progn
          (format t "  ANSWER (what the substrate DID): REFUSED as :ambiguous. The two~%")
          (format t "  certificates each sufficient, together read as DOUBT, not as~%")
          (format t "  redundant strength. The errata-3 prediction HELD (Outcome R).~%"))
        (progn
          (format t "  ANSWER (what the substrate DID): NOT refused as :ambiguous —~%")
          (format t "  the errata-3 prediction was FALSIFIED (Outcome G, publishable).~%")))

    (format t "~%LINGUISTIC-DEFENSIBILITY ASSESSMENT (CASE A):~%")
    (format t "  Refusing two sufficient proofs is defensible ONLY as a conservative~%")
    (format t "  floor, not as a truth about the conclusion. In logic, redundant~%")
    (format t "  sufficiency STRENGTHENS a conclusion; a proof does not weaken because a~%")
    (format t "  second proof exists. What the substrate loses by refusing is precisely~%")
    (format t "  that: it cannot say 'admissible, and doubly so.' The founding /1 model~%")
    (format t "  has no seat for 'more than one lawful anatomy' — its ambiguity gate was~%")
    (format t "  built to catch UNRESOLVED CHOICE (which of two bindings is meant?), and~%")
    (format t "  it fires identically on UNNEEDED CHOICE (either binding is fine). The~%")
    (format t "  refusal is safe (it never wrongly grants) but linguistically it flattens~%")
    (format t "  'over-determined' into 'under-determined' — two opposite conditions.~%")

    ;; The verdict the mission requires:
    (format t "~%==================================================================~%")
    (format t "VERDICT — does the implementation DISTINGUISH Case A from Case B?~%")
    (let ((conflated (and (eq disp-a :ambiguous) (eq disp-b :ambiguous))))
      (format t "  CASE A (redundant sufficiency)     : ~S~%" disp-a)
      (format t "  CASE B (incompatible authority)    : ~S~%" disp-b)
      (if conflated
          (progn
            (format t "  Both land the SAME disposition with no discriminating field.~%")
            (format t "~%MULTIPLICITY FINDING: multiple-sufficient-proofs and ~
unresolved-semantic-choice are CONFLATED under current :ambiguous law~%")
            (format t "~%The three permitted minimal repair shapes (from the sitting order),~%")
            (format t "enumerated, NONE implemented here:~%")
            (format t "  (1) grant-preserving-all-environments — grant the conclusion and~%")
            (format t "      carry every discharging environment in the receipt (redundant~%")
            (format t "      sufficiency becomes strength, not doubt).~%")
            (format t "  (2) refuse-only-semantic-incompatibility — grant when the competing~%")
            (format t "      environments are interchangeable for the conclusion; refuse only~%")
            (format t "      when they imply materially different downstream commitments.~%")
            (format t "  (3) schema-level uniqueness-discriminator flag — let a schema declare~%")
            (format t "      whether a given premise's schema-local is uniqueness-bearing;~%")
            (format t "      absent the flag, plurality is tolerated, not refused.~%"))
          (format t "  The dispositions DIFFER — the substrate already distinguishes them~%")
          ;; (this branch would falsify the conflation prediction; itself publishable)
          ))

    (format t "~%The finding IS the success. Exit 0.~%")
    (finish-output)
    (sb-ext:exit :code 0)))
