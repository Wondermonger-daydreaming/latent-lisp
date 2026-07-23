;;;; SPECIMEN.lisp — de-admissione-datorum: the Slice /1 cross-domain transfer
;;;; specimen.  Scientific-data admissibility.
;;;;
;;;; An executable argument.  ONE judgment schema — :dataset-admissibility v1 —
;;;; declares the anatomy of "dataset D is admissible for analysis purpose P under
;;;; receiver R": six required premises (schema-conformance, measured-by,
;;;; calibration-valid, missingness-within-bound, population-suitable,
;;;; purpose-permitted).  Because the anatomy is DECLARED, an omitted, mismatched,
;;;; refuted, inaccessible, wrong-instrument, wrong-purpose, or wrong-receiver
;;;; premise becomes mechanically visible in a derivation receipt BEFORE the
;;;; conclusion can be granted — and the grant, when it comes, is a real Slice /0
;;;; promotion keyed to the derivation, not to opaque content.  The five layers
;;;;   schema-valid ≠ measurement-valid ≠ population-suitable ≠ permitted ≠ admissible
;;;; stay distinct, exactly as the supply-chain founding specimen kept
;;;;   digest ≠ signature ≠ recognition ≠ provenance ≠ admissibility distinct.
;;;;
;;;; INSTRUMENT-BINDING (honest construction, behavior 3): the conclusion carries
;;;; no instrument.  :instrument is a schema-local, bound by the :measured-by
;;;; premise (ordered BEFORE :calibration-valid).  The errata-3 premise-by-premise
;;;; threading carries the bound ?instrument into the calibration premise, so a
;;;; calibration certificate for a DIFFERENT instrument lands :mismatched on the
;;;; :instrument role.  Nothing is smuggled: the binding is a declared premise.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surfaces of Slice /0, Slice /1,
;;;; and kernel0 only.  No internal-symbol access anywhere (grep-verified zero).
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exits 0 on 14/14)

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../slice1.lisp" *load-truename*))))

(defpackage #:de-admissione-datorum-specimen (:use #:cl))
(in-package #:de-admissione-datorum-specimen)

;;; Public-surface nicknames (single colon everywhere).
(defun p (form) (lisp-plus-slice1:proposition form))
(defun pat (form) (lisp-plus-slice1:proposition-pattern form))

(defun sw (form &key (kind :observation) (source :data-steward))
  "A GROUND direct support witness for structured proposition FORM."
  (lisp-plus-slice0:witness :for (p form) :mode :direct :kind kind :source source))

(defun mk-ctx (id &rest supports)
  "A receiver-context whose accessible-supports are the witness ids among
SUPPORTS (refutations, which carry no witness id, are ignored)."
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p supports))))

(defun split-lines (string)
  (loop with start = 0
        for nl = (position #\Newline string :start start)
        collect (subseq string start (or nl (length string)))
        while nl do (setf start (1+ nl))))

(defun assessment-for (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a)
               (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))

(defun disp (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition
   (assessment-for receipt predicate)))

(defun roles-of-mismatch (receipt predicate)
  "The conflicting roles named on the first mismatched candidate of PREDICATE."
  (let ((mc (lisp-plus-slice1:premise-assessment-mismatched-candidates
             (assessment-for receipt predicate))))
    (and mc (cdr (first mc)))))

(defun attempt (&key conclusion supports receiver)
  "Run DERIVE; return (values RECEIPT GRANTED-CLAIM).  On refusal the receipt is
recovered from the typed condition, so callers get the receipt either way."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive
           :schema-name :dataset-admissibility :schema-version 1
           :conclusion conclusion :supports supports :receiver receiver)
        (values receipt claim))
    (lisp-plus-slice1:derivation-refused (c)
      (values (lisp-plus-slice1:slice1-condition-receipt c) nil))))

;;; ------------------------------------------------------------------
;;; The schema: dataset admissibility for a receiver + purpose.
;;; Conclusion vars: :dataset :receiver :purpose.
;;; Schema-locals: :schema :instrument :certificate :bound.
;;; Premise ORDER is load-bearing: :measured-by (binds :instrument) precedes
;;; :calibration-valid (consumes the bound :instrument) — errata-3 threading.

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

;;; Support constructors keyed on the roles a behavior needs to vary.
(defun s-schema (&key (dataset "dataset-1") (schema "schema-v3"))
  (sw `(:predicate :schema-conformance (:dataset ,dataset) (:schema ,schema))))
(defun s-measured (&key (dataset "dataset-1") (instrument "instrument-a"))
  (sw `(:predicate :measured-by (:dataset ,dataset) (:instrument ,instrument))))
(defun s-calibration (&key (dataset "dataset-1") (instrument "instrument-a")
                        (certificate "cert-1"))
  (sw `(:predicate :calibration-valid (:dataset ,dataset) (:instrument ,instrument)
        (:certificate ,certificate))))
(defun s-missingness (&key (dataset "dataset-1") (bound 5))
  (sw `(:predicate :missingness-within-bound (:dataset ,dataset) (:bound ,bound))))
(defun s-population (&key (dataset "dataset-1") (purpose :causal))
  (sw `(:predicate :population-suitable (:dataset ,dataset) (:purpose ,purpose))))
(defun s-permitted (&key (dataset "dataset-1") (receiver :receiver-a) (purpose :causal))
  (sw `(:predicate :purpose-permitted (:dataset ,dataset) (:receiver ,receiver)
        (:purpose ,purpose))))

(defun full-supports (&key (dataset "dataset-1") (receiver :receiver-a)
                        (purpose :causal) (instrument "instrument-a"))
  (list (s-schema :dataset dataset)
        (s-measured :dataset dataset :instrument instrument)
        (s-calibration :dataset dataset :instrument instrument)
        (s-missingness :dataset dataset)
        (s-population :dataset dataset :purpose purpose)
        (s-permitted :dataset dataset :receiver receiver :purpose purpose)))

(defun conclusion (&key (dataset "dataset-1") (receiver :receiver-a) (purpose :causal))
  (p `(:predicate :dataset-admissible (:dataset ,dataset) (:receiver ,receiver)
       (:purpose ,purpose))))

;;; ==================================================================
;;; Harness.

(defvar *demonstrated* 0)
(defvar *behaviors* 14)

(defun hd (n title) (format t "~%── behavior ~D: ~A~%" n title))
(defun ln (fmt &rest args) (format t "   ") (apply #'format t fmt args) (terpri))
(defun pass (n msg)
  (incf *demonstrated*)
  (format t "   [ok ~D] ~A~%" n msg))
(defun expect (bool)
  (unless bool (error "SPECIMEN INVARIANT VIOLATED — a behavior did not hold")))

(install-schema)
(format t "== de-admissione-datorum SPECIMEN — Slice /1, schema :dataset-admissibility v1 ==~%")

;;; ---- behavior 1 : schema-conformance alone ⇒ refused ----
(hd 1 "schema-conformance support alone ⇒ refusal; receipt shows the other five unmet")
(let* ((sup (list (s-schema)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "decision: ~S" (lisp-plus-slice1:derivation-receipt-decision r))
  (ln "schema-conformance=~S  measured-by=~S  calibration=~S"
      (disp r :schema-conformance) (disp r :measured-by) (disp r :calibration-valid))
  (ln "missingness=~S  population=~S  purpose-permitted=~S"
      (disp r :missingness-within-bound) (disp r :population-suitable)
      (disp r :purpose-permitted))
  (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :refused))
  (expect (eq (disp r :schema-conformance) :satisfied))
  (expect (eq (disp r :measured-by) :missing))
  (expect (eq (disp r :calibration-valid) :missing))
  (expect (eq (disp r :missingness-within-bound) :missing))
  (expect (eq (disp r :population-suitable) :missing))
  (expect (eq (disp r :purpose-permitted) :missing))
  (pass 1 "schema-valid alone is refused; the other five layers are :missing, not assumed"))

;;; ---- behavior 2 : schema + low missingness, calibration absent ⇒ refused, calibration NAMED :missing ----
(hd 2 "schema-conformance + low missingness, calibration absent ⇒ refused; calibration :missing NAMED")
(let* ((sup (list (s-schema) (s-missingness)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup)))
       (a (assessment-for r :calibration-valid)))
  (ln "decision: ~S ; schema=~S missingness=~S calibration=~S"
      (lisp-plus-slice1:derivation-receipt-decision r)
      (disp r :schema-conformance) (disp r :missingness-within-bound)
      (disp r :calibration-valid))
  (ln "named unmet premise: ~S"
      (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))
  (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :refused))
  (expect (eq (disp r :schema-conformance) :satisfied))
  (expect (eq (disp r :missingness-within-bound) :satisfied))
  (expect (eq (disp r :calibration-valid) :missing))
  (pass 2 "conforming + low-missingness data is refused; calibration is NAMED :missing (measurement-validity absent)"))

;;; ---- behavior 3 : calibration for instrument-a cannot discharge premise bound to instrument-b ----
(hd 3 "calibration cert for instrument-a cannot discharge a premise bound to instrument-b (⇒ :mismatched :instrument)")
(let* ((sup (list (s-schema)
                  (s-measured :instrument "instrument-b")     ; dataset MEASURED-BY instrument-b
                  (s-calibration :instrument "instrument-a")  ; calibration cert is for instrument-a
                  (s-missingness) (s-population) (s-permitted)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "measured-by disposition   : ~S (binds ?instrument = instrument-b)"
      (disp r :measured-by))
  (ln "calibration disposition   : ~S ; conflicting roles : ~S"
      (disp r :calibration-valid) (roles-of-mismatch r :calibration-valid))
  (expect (eq (disp r :measured-by) :satisfied))
  (expect (eq (disp r :calibration-valid) :mismatched))
  (expect (equal (roles-of-mismatch r :calibration-valid) '(:instrument)))
  (pass 3 "instrument-a's certificate lands :mismatched on role :instrument against an instrument-b-bound premise"))

;;; ---- behavior 4 : population-suitable for :descriptive cannot discharge :causal ----
(hd 4 "population-suitable for :descriptive cannot discharge a :causal conclusion (⇒ :mismatched :purpose)")
(let* ((sup (list (s-schema) (s-measured) (s-calibration) (s-missingness)
                  (s-population :purpose :descriptive)          ; suitable only for description
                  (s-permitted :purpose :causal)))
       (r (attempt :conclusion (conclusion :purpose :causal) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "population disposition : ~S ; conflicting roles : ~S"
      (disp r :population-suitable) (roles-of-mismatch r :population-suitable))
  (expect (eq (disp r :population-suitable) :mismatched))
  (expect (equal (roles-of-mismatch r :population-suitable) '(:purpose)))
  (pass 4 "descriptive-fitness lands :mismatched on role :purpose against a causal conclusion — a real layer boundary"))

;;; ---- behavior 5 : purpose-permitted for :descriptive does not silently permit :causal ----
(hd 5 "purpose-permission for :descriptive does not silently permit :causal (⇒ :mismatched :purpose)")
(let* ((sup (list (s-schema) (s-measured) (s-calibration) (s-missingness)
                  (s-population :purpose :causal)
                  (s-permitted :purpose :descriptive)))         ; consent covers description only
       (r (attempt :conclusion (conclusion :purpose :causal) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "purpose-permitted disposition : ~S ; conflicting roles : ~S"
      (disp r :purpose-permitted) (roles-of-mismatch r :purpose-permitted))
  (expect (eq (disp r :purpose-permitted) :mismatched))
  (expect (equal (roles-of-mismatch r :purpose-permitted) '(:purpose)))
  (pass 5 "descriptive-purpose permission lands :mismatched on role :purpose; consent does not spill to causal use"))

;;; ---- behavior 6 : dataset-1 premise cannot discharge dataset-2 conclusion ----
(hd 6 "a dataset-1 premise cannot discharge a dataset-2 conclusion (⇒ :mismatched :dataset)")
(let* ((sup (list (s-schema :dataset "dataset-1")               ; wrong dataset
                  (s-measured :dataset "dataset-2") (s-calibration :dataset "dataset-2")
                  (s-missingness :dataset "dataset-2") (s-population :dataset "dataset-2")
                  (s-permitted :dataset "dataset-2")))
       (r (attempt :conclusion (conclusion :dataset "dataset-2") :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "schema-conformance disposition : ~S ; conflicting roles : ~S"
      (disp r :schema-conformance) (roles-of-mismatch r :schema-conformance))
  (expect (eq (disp r :schema-conformance) :mismatched))
  (expect (equal (roles-of-mismatch r :schema-conformance) '(:dataset)))
  (pass 6 "dataset-1's conformance record lands :mismatched on role :dataset against a dataset-2 conclusion"))

;;; ---- behavior 7 : receiver-r1 purpose-permission cannot discharge r2 conclusion ----
(hd 7 "receiver-r1's purpose-permission cannot discharge a receiver-r2 conclusion (⇒ :mismatched :receiver)")
(let* ((sup (list (s-schema) (s-measured) (s-calibration) (s-missingness)
                  (s-population)
                  (s-permitted :receiver :receiver-r1)))        ; permission granted to r1
       (r (attempt :conclusion (conclusion :receiver :receiver-r2) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "purpose-permitted disposition : ~S ; conflicting roles : ~S"
      (disp r :purpose-permitted) (roles-of-mismatch r :purpose-permitted))
  (expect (eq (disp r :purpose-permitted) :mismatched))
  (expect (equal (roles-of-mismatch r :purpose-permitted) '(:receiver)))
  (pass 7 "r1's permission lands :mismatched on role :receiver against an r2 conclusion — permission is receiver-relative"))

;;; ---- behavior 8 : exact but inaccessible support ⇒ :inaccessible, NOT :missing (print both counts) ----
(hd 8 "an exact but inaccessible calibration support is :inaccessible residue, NOT :missing")
(let* ((cal (s-calibration))
       (sup (list (s-schema) (s-measured) cal (s-missingness) (s-population) (s-permitted)))
       ;; ctx accessible to everything EXCEPT the calibration witness
       (ctx (apply #'mk-ctx :ctx (remove cal sup)))
       (r (attempt :conclusion (conclusion) :supports sup :receiver ctx))
       (a (assessment-for r :calibration-valid)))
  (ln "disposition                       : ~S" (disp r :calibration-valid))
  (ln "matching-accessible-supports (n)  : ~D"
      (length (lisp-plus-slice1:premise-assessment-matching-accessible-supports a)))
  (ln "matching-inaccessible-supports (n): ~D"
      (length (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a)))
  (expect (eq (disp r :calibration-valid) :inaccessible))
  (expect (= 0 (length (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))))
  (expect (= 1 (length (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))))
  (pass 8 "a present-but-unreachable calibration is residue (:inaccessible), distinct from :missing (accessible=0, inaccessible=1)"))

;;; ---- behavior 9 : refuted calibration blocks with positive+refuting both preserved ----
(hd 9 "a refuted calibration blocks even with positive support present — BOTH preserved")
(let* ((sup (append (full-supports)
                    (list (lisp-plus-slice1:refutation
                           :refutes '(:predicate :calibration-valid
                                      (:dataset "dataset-1") (:instrument "instrument-a")
                                      (:certificate "cert-1"))
                           :source :metrology-lab))))
       (ctx (apply #'mk-ctx :ctx sup))
       (r (attempt :conclusion (conclusion) :supports sup :receiver ctx))
       (a (assessment-for r :calibration-valid)))
  (ln "disposition                  : ~S" (disp r :calibration-valid))
  (ln "positive support present     : ~S"
      (and (lisp-plus-slice1:premise-assessment-matching-accessible-supports a) t))
  (ln "refuting support present     : ~S"
      (and (lisp-plus-slice1:premise-assessment-refuting-supports a) t))
  (expect (eq (disp r :calibration-valid) :refuted))
  (expect (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
  (expect (lisp-plus-slice1:premise-assessment-refuting-supports a))
  (pass 9 "positive AND refuting evidence both preserved; premise :refuted, never revisionistically erased"))

;;; ---- behavior 10 : full coherent discharge ⇒ :granted, a real Slice /0 promotion ----
(hd 10 "full coherent discharge ⇒ :granted, a real frozen Slice /0 :verified promotion")
(let* ((sup (full-supports))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim) (attempt :conclusion (conclusion) :supports sup :receiver ctx)
    (let ((jr (lisp-plus-slice0:claim-judgment claim)))
      (ln "receipt decision  : ~S" (lisp-plus-slice1:derivation-receipt-decision r))
      (ln "granted claim prop: ~S" (lisp-plus-slice0:claim-proposition claim))
      (ln "judgment-record   : ~S (procedure v~S)"
          (lisp-plus-slice0:judgment-record-judgment jr)
          (lisp-plus-slice0:judgment-record-procedure-version jr))
      (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :granted))
      (expect (lisp-plus-slice0:claim-p claim))
      (expect (eq (lisp-plus-slice0:judgment-record-judgment jr) :verified))
      (pass 10 "all six layers discharged ⇒ a real Slice /0 :verified promotion, keyed to the derivation"))))

;;; ---- behavior 11 : why / render-derivation-why names every premise assessment precisely ----
(hd 11 "render-derivation-why names every premise assessment precisely (satisfied AND unmet)")
(let* ((sup (list (s-schema) (s-measured)))   ; 2 satisfied, 4 unmet
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "why façade returns the receipt itself: ~S" (eq (lisp-plus-slice1:why r) r))
  (format t "   ---- render-derivation-why ----~%")
  (let ((text (with-output-to-string (s)
                (lisp-plus-slice1:render-derivation-why r s))))
    (dolist (l (remove "" (split-lines text) :test #'string=))
      (format t "   ~A~%" l))
    (expect (search "SCHEMA-CONFORMANCE" (string-upcase text)))
    (expect (search "MEASURED-BY" (string-upcase text)))
    (expect (search "CALIBRATION-VALID" (string-upcase text)))
    (expect (search "MISSINGNESS-WITHIN-BOUND" (string-upcase text)))
    (expect (search "POPULATION-SUITABLE" (string-upcase text)))
    (expect (search "PURPOSE-PERMITTED" (string-upcase text)))
    (expect (search "SATISFIED" (string-upcase text)))
    (expect (search "MISSING" (string-upcase text))))
  (pass 11 "all six premises named, satisfied and missing alike; prose derived only from the receipt's fields"))

;;; ---- behavior 12 : projection re-derives at the target; it never copies ----
(hd 12 "projection: the conclusion does NOT survive to a second receiver by copy — the target must re-derive")
(let* ((sup-a (full-supports :receiver :receiver-a))
       (ctx-a (apply #'mk-ctx :ctx-a sup-a)))
  (multiple-value-bind (r-a claim-a)
      (attempt :conclusion (conclusion :receiver :receiver-a) :supports sup-a :receiver ctx-a)
    (declare (ignore claim-a))
    (let ((id-a (lisp-plus-kernel0:identity-key
                 (lisp-plus-slice1:derivation-receipt-identity r-a))))
      (ln "source grant at receiver-a, receipt id : ~A" id-a)
      (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-a) :granted))

      ;; (a) target receiver-b lacking its OWN purpose-permission ⇒ refused at target
      (let* ((sup-b0 (list (s-schema) (s-measured) (s-calibration) (s-missingness)
                           (s-population)))   ; NO purpose-permitted for receiver-b
             (ctx-b (apply #'mk-ctx :ctx-b sup-b0))
             (r-b0 (attempt :conclusion (conclusion :receiver :receiver-b)
                            :supports sup-b0 :receiver ctx-b)))
        (ln "target receiver-b, no local permission ⇒ decision ~S (purpose-permitted ~S)"
            (lisp-plus-slice1:derivation-receipt-decision r-b0)
            (disp r-b0 :purpose-permitted))
        (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-b0) :refused))
        (expect (eq (disp r-b0 :purpose-permitted) :missing)))

      ;; (b) give the target ITS OWN permission ⇒ granted at target, DISTINCT receipt id
      (let* ((sup-b (full-supports :receiver :receiver-b))
             (ctx-b (apply #'mk-ctx :ctx-b sup-b)))
        (multiple-value-bind (r-b claim-b)
            (attempt :conclusion (conclusion :receiver :receiver-b) :supports sup-b :receiver ctx-b)
          (let ((id-b (lisp-plus-kernel0:identity-key
                       (lisp-plus-slice1:derivation-receipt-identity r-b))))
            (ln "target grant at receiver-b, receipt id : ~A" id-b)
            (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-b) :granted))
            (expect (lisp-plus-slice0:claim-p claim-b))
            (ln "receipt identities distinct (a =/= b)  : ~S" (not (equal id-a id-b)))
            (expect (not (equal id-a id-b)))
            (pass 12 "target re-derived over its OWN lawful premises; distinct receipt identity — reconstruction, not copy")))))))

;;; ---- behavior 13 : transported derivation testimony cannot masquerade as target-local derivation ----
(hd 13 "a transported derivation receipt is testimony and cannot masquerade as a target-local derivation")
(let* ((sup (full-supports))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim) (attempt :conclusion (conclusion) :supports sup :receiver ctx)
    (declare (ignore claim))
    (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :granted))
    (let* ((testimony (lisp-plus-slice1:transported-testimony r :context-a :ctx))
           (schema (lisp-plus-slice1:resolve-schema :dataset-admissibility 1))
           (admit-kind (lisp-plus-slice1:judgment-schema-admit-kind schema))
           ;; a derivation-keyed conclusion procedure (built with public surfaces only)
           (proc (lisp-plus-slice0:promotion-procedure
                  :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                               :procedure-id (lisp-plus-kernel0:make-identity
                                              :procedure "masquerade-probe")
                               :version 1 :judgment-class :semantic
                               :result-vocabulary '(:verified))
                  :admits (list (list :derivation admit-kind))))
           (attacker-claim (lisp-plus-slice0:claim :proposition (conclusion) :by :attacker)))
      (ln "transported receipt is (~S ~S) — a product, not a local derivation"
          (lisp-plus-slice0:witness-mode testimony)
          (lisp-plus-slice0:witness-kind testimony))
      (expect (eq (lisp-plus-slice0:witness-mode testimony) :testimony))
      (expect (eq (lisp-plus-slice0:witness-kind testimony) :derivation-report))
      (handler-case
          (progn
            (lisp-plus-slice0:raise attacker-claim :to :verified :per proc
                                    :considering (list testimony) :receiver :ctx)
            (error "MASQUERADE SUCCEEDED — a transported receipt discharged a local derivation"))
        (lisp-plus-slice0:slice0-condition (c)
          (ln "refused at frozen gate by name : ~A" (type-of c))
          (expect (typep c 'lisp-plus-slice0:slice0-condition))
          (pass 13 (format nil "transported testimony refused at the frozen gate (~A); it is evidence-that-a-derivation-occurred, never a local derivation"
                           (type-of c))))))))

;;; ---- behavior 14 : a v1 derivation cannot satisfy a v2 schema ----
(hd 14 "a v1-keyed derivation cannot satisfy a v2 schema (different premise set; frozen version gate)")
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :dataset-admissibility :version 2
  :conclusion (pat '(:predicate :dataset-admissible
                     (:dataset (:var :dataset)) (:receiver (:var :receiver))
                     (:purpose (:var :purpose))))
  ;; a DIFFERENT premise set — v2 additionally requires a retention policy
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
               (:purpose (:var :purpose))))
        (pat '(:predicate :retention-policy-satisfied (:dataset (:var :dataset)))))
  :locals '(:schema :instrument :certificate :bound)))
(let* ((v1 (lisp-plus-slice1:resolve-schema :dataset-admissibility 1))
       (v2 (lisp-plus-slice1:resolve-schema :dataset-admissibility 2))
       (k1 (lisp-plus-slice1:judgment-schema-admit-kind v1))
       (k2 (lisp-plus-slice1:judgment-schema-admit-kind v2))
       (concl (conclusion))
       ;; a v2-keyed conclusion procedure
       (v2-proc (lisp-plus-slice0:promotion-procedure
                 :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                              :procedure-id (lisp-plus-kernel0:make-identity
                                             :procedure "v2-gate-probe")
                              :version 2 :judgment-class :semantic
                              :result-vocabulary '(:verified))
                 :admits (list (list :derivation k2))))
       ;; a v1-keyed derivation witness whose :for IS the conclusion (isolates the version gate)
       (v1-witness (lisp-plus-slice0:witness :for concl :mode :derivation :kind k1
                                             :source :deriver))
       (the-claim (lisp-plus-slice0:claim :proposition concl :by :deriver)))
  (ln "v1 admit-key : ~S" k1)
  (ln "v2 admit-key : ~S" k2)
  (ln "keys differ  : ~S" (not (eq k1 k2)))
  (expect (not (eq k1 k2)))
  (handler-case
      (progn
        (lisp-plus-slice0:raise the-claim :to :verified :per v2-proc
                                :considering (list v1-witness) :receiver :ctx)
        (error "VERSION GATE FAILED — a v1 derivation satisfied a v2 procedure"))
    (lisp-plus-slice0:slice0-condition (c)
      (ln "v1 derivation refused by v2-keyed procedure at frozen gate : ~A" (type-of c))
      (expect (typep c 'lisp-plus-slice0:slice0-condition))
      (pass 14 (format nil "v1's derivation key /= v2's; the frozen admits gate refuses it (~A); no auto-latest, exact versioning"
                       (type-of c))))))

;;; ==================================================================
(format t "~%de-admissione-datorum specimen: ~D/~D behaviors demonstrated~%"
        *demonstrated* *behaviors*)
(finish-output)
(sb-ext:exit :code (if (= *demonstrated* *behaviors*) 0 1))
