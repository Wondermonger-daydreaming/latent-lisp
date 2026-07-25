;;;; slice2-selftest.lisp — teeth for Language Slice /2, Candidate /0.
;;;;
;;;; Governed by LANGUAGE-SLICE-2-WORK-ORDER-0.md §6.  The verification floor is
;;;; FOCUSED by instruction — no fifty-case paper matrix — and covers exactly:
;;;;
;;;;   contract construction · per-premise attachment · missing-contract refusal
;;;;   lawful judged claim · genuine source basis · exact-copy source basis
;;;;   unissued-account refusal · raised fabricated claim refusal
;;;;   indeterminate truth ceiling · refutation precedence
;;;;   contract defensive copy · source-basis defensive copy
;;;;   safe-to-exhibit overreach refusal
;;;;
;;;; (The library and workshop lawful effect paths are covered by the two
;;;; inhabited applications, which run as themselves.)
;;;;
;;;; TEETH ARE MANDATORY.  A gate that has never fired is untested, not passing.
;;;; Every refusal below is shown FIRING against a planted fault and then shown
;;;; PASSING on the lawful path — and the file ends with ONE negative control
;;;; that blinds the source-basis clause to judged claims and shows the
;;;; raised-fabrication tooth FAIL, then restores it and shows it green again.
;;;;
;;;; ALL greens here are SELF-CONSISTENCY CERTIFICATION, never independent
;;;; conformance.  Nothing here claims durability, cross-image standing,
;;;; serialization authenticity, or any cryptographic property.
;;;;
;;;; Run: sbcl --non-interactive --load slice2-selftest.lisp  (exit 0 on all-pass)

(unless (find-package :lisp-plus-slice2)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "slice2.lisp" *load-truename*))))

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-core-0/fake-courier.lisp" *load-truename*))))

(in-package #:lisp-plus-slice2)

(defvar *s2pass* 0)
(defvar *s2fail* 0)

(defun s2ok (name bool &optional detail)
  (if bool
      (progn (incf *s2pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *s2fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defmacro s2fires (name expected-type &body body)
  "Show a gate FIRE.  A refusal that has never been provoked is a docstring."
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (s2ok ,name nil "no condition fired (expected a refusal)"))
       (,expected-type (,c)
         (s2ok ,name t (format nil "bit: caught ~A" (type-of ,c))))
       (error (,c)
         (s2ok ,name nil (format nil "wrong condition: ~A" (type-of ,c)))))))

;;; ------------------------------------------------------------------
;;; Fixtures — a dispatch desk small enough to read in one sitting.

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defparameter +req+ '(:predicate :deliver (:payload "codex-9 -> reader")))
(defparameter +other-req+ '(:predicate :deliver (:payload "codex-9 -> nobody")))

(defun key-for (&rest predicates)
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier
            :predicates (or predicates '(:deliver)))))

(defun genuine-account (&key (request +req+) (script :clean-commit) (label "s2/dispatch"))
  "A REAL Core /0 account from a real governed act.  Returns the evidence.
Both scripts genuinely issue: one commits, one is interrupted with the ledger
withholding, and BOTH are Core /0-issued — which is the point of the
indeterminate arm below."
  (multiple-value-bind (adapter world)
      (lisp-plus-fake-courier:make-fake-courier :script script)
    (declare (ignore world))
    (handler-case
        (nth-value 1 (lisp-plus-core0:perform
                      :adapter adapter :request request :authority (key-for)
                      :process (lisp-plus-core0:process-context :label label)))
      (lisp-plus-core0:core0-interrupted (c)
        (lisp-plus-core0:core0-condition-evidence c)))))

(defun ctx (&rest supports)
  "The receiving position.  A source basis is reached by its SOURCE-BASIS
IDENTITY, a witness by its WITNESS-ID, a judged claim by its CLAIM-ID — one
id-membership rule read against three durable identities.  Nothing is ambiently
reachable."
  (lisp-plus-slice0:receiver-context
   :context-id :s2-desk
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((source-basis-p s) (list (source-basis-identity s)))
                   ((derivation-basis-p s) (list (derivation-basis-identity s)))
                   ((lisp-plus-slice0:witness-p s) (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s) (list (lisp-plus-slice0:claim-id s)))))
           supports)))

;;; The account-report schema: ONE premise, wanting the generic proposition a
;;; source relation produces.  Its conclusion is about the ACCOUNT — never about
;;; the world (D2-0.6).
(defun install-schemas ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :dispatch-account-standing :version 1
    :conclusion (pp '(:predicate :dispatch-account-acknowledged
                      (:volume (:var :volume))))
    :premises (list (pp '(:predicate :core0-account-reports-acknowledgment
                          (:attempt (:var :attempt)) (:request (:var :request))
                          (:acknowledgment :acknowledged))))
    :locals '(:attempt :request)))
  ;; A TWO-premise schema: one premise source-bound, one legitimately accepting a
  ;; direct condition survey.  This is why contracts attach PER PREMISE.
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :release-standing :version 1
    :conclusion (pp '(:predicate :may-release (:volume (:var :volume))))
    :premises (list (pp '(:predicate :core0-account-reports-outcome
                          (:attempt (:var :attempt)) (:request (:var :request))
                          (:outcome :completed)))
                    (pp '(:predicate :condition-surveyed
                          (:volume (:var :volume)) (:assay (:var :assay)))))
    :locals '(:attempt :request :assay))))

(defun source-bound-contract (&key (id :source-bound)
                                   (relations '(:core0-account-reports-acknowledgment)))
  (make-support-admission-contract
   :contract-id id
   :accepted-clauses (list (list :source-basis :relations relations))))

(defun survey-contract ()
  (make-support-admission-contract
   :contract-id :direct-condition-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :condition-survey
                        :truth-ceiling :asserted))))

(defun judged-claim-contract ()
  (make-support-admission-contract
   :contract-id :legacy-judged-claim
   :accepted-clauses '((:verified-judged-claim))))

(defun account-schema (contract)
  (make-slice2-schema
   :schema-id :dispatch-account-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :dispatch-account-standing 1)
   :premise-contracts (list (list 0 contract))))

(defun run/2 (schema conclusion supports &key (receiver :auto))
  "DERIVE/2, recovering the receipt either way.  Returns (values RECEIPT CLAIM
DECISION) — the shape SMOKE-1 established for Slice /1."
  (let ((rcv (if (eq receiver :auto) (apply #'ctx supports) receiver)))
    (handler-case
        (multiple-value-bind (claim receipt)
            (derive/2 :schema schema :conclusion conclusion
                      :supports supports :receiver rcv)
          (values receipt claim :granted))
      (slice2-derivation-refused (c)
        (values (slice2-condition-receipt c) nil :refused)))))

(defun admission-0 (receipt) (first (slice2-receipt-admissions receipt)))

(defun account-conclusion (&optional (volume "codex-9"))
  (np `(:predicate :dispatch-account-acknowledged (:volume ,volume))))

(install-schemas)
(format t "~%== Language Slice /2 teeth (self-consistency certification) ==~%")

;;; ==================================================================
;;; S1 — CONTRACT CONSTRUCTION.  A contract is DATA and an unevaluable one
;;; cannot exist: every refusal below fires AT CONSTRUCTION (D2-0.1).

(format t "~%-- S1: contract construction --~%")

(let ((c (source-bound-contract)))
  (s2ok "S1a a well-formed contract constructs, and carries its clauses as DATA"
        (and (support-admission-contract-p c)
             (equal (support-admission-contract-accepted-clauses c)
                    '((:source-basis :relations (:core0-account-reports-acknowledgment))))
             (eq :exact-normalized-equality
                 (support-admission-contract-proposition-relation c))
             (eq :required (support-admission-contract-receiver-accessibility c))))
  (s2ok "S1b the truth ceiling of each accepted species is RECORDED, not inferred"
        (equal (support-admission-contract-truth-ceilings c)
               (list (cons :source-basis :current-image-issued-account-report)))))

(s2ok "S1c an asserted-witness clause records :ASSERTED and names its mode and kind"
      (equal (support-admission-contract-truth-ceilings (survey-contract))
             '((:asserted-witness . :asserted))))

(s2ok "S1d a judged-claim clause records the PRIOR-GOVERNED-JUDGMENT ceiling"
      (equal (support-admission-contract-truth-ceilings (judged-claim-contract))
             '((:verified-judged-claim . :prior-governed-judgment))))

;; --- the construction gates, each shown FIRING -----------------------
(s2fires "S1e an UNKNOWN clause species refuses at construction" unknown-admission-clause
  (make-support-admission-contract :contract-id :x
                                   :accepted-clauses '((:trusted-source :name :me))))

(s2fires "S1f an unknown OPTION on a known clause refuses at construction" unknown-admission-clause
  (make-support-admission-contract :contract-id :x
                                   :accepted-clauses '((:verified-judged-claim :from :anywhere))))

(s2fires "S1g a source-basis clause naming a relation that does not exist refuses" unknown-admission-clause
  (make-support-admission-contract :contract-id :x
                                   :accepted-clauses '((:source-basis :relations (:establishes)))))

(s2fires "S1h a source-basis clause with NO relations refuses (there is no wildcard)"
    unknown-admission-clause
  (make-support-admission-contract :contract-id :x
                                   :accepted-clauses '((:source-basis :relations ()))))

(s2fires "S1i an asserted-witness clause claiming a ceiling it has not earned refuses"
    unknown-admission-clause
  (make-support-admission-contract
   :contract-id :x
   :accepted-clauses '((:asserted-witness :mode :direct :kind :condition-survey
                        :truth-ceiling :source-bound))))

(s2fires "S1j an asserted-witness clause naming :MODE :DERIVATION refuses — that is the carrier's mode"
    unknown-admission-clause
  (make-support-admission-contract
   :contract-id :x
   :accepted-clauses '((:asserted-witness :mode :derivation
                        :kind :core0-account-reports-acknowledgment
                        :truth-ceiling :asserted))))

(s2fires "S1k a contract accepting NOTHING refuses" admission-contract-error
  (make-support-admission-contract :contract-id :x :accepted-clauses '()))

(s2fires "S1l a contract with no :CONTRACT-ID refuses — a receipt must be able to name it"
    admission-contract-error
  (make-support-admission-contract
   :accepted-clauses '((:verified-judged-claim))))

(s2fires "S1m an invented proposition relation refuses" admission-contract-error
  (make-support-admission-contract :contract-id :x
                                   :accepted-clauses '((:verified-judged-claim))
                                   :proposition-relation :approximate-match))

(s2ok "S1n there are EXACTLY three relations and no wildcard among them"
      (and (equal (core0-source-relations)
                  '(:core0-account-issued-for-request
                    :core0-account-reports-acknowledgment
                    :core0-account-reports-outcome))
           (notany #'core0-source-relation-p
                   '(:establishes :core0-account-establishes :treatment-completed
                     :safe-to-exhibit :dispatch-delivered :loan-settled))))

;;; ==================================================================
;;; S2 — PER-PREMISE ATTACHMENT, and the refusals that make it exact.

(format t "~%-- S2: per-premise attachment --~%")

(let* ((c (source-bound-contract))
       (s (account-schema c)))
  (s2ok "S2a a schema attaches one contract to each premise position"
        (and (slice2-schema-p s)
             (= 1 (length (slice2-schema-premise-contracts s)))
             (eq :source-bound
                 (support-admission-contract-contract-id
                  (slice2-schema-contract-for-premise s 0))))))

(let ((base (lisp-plus-slice1:resolve-schema :release-standing 1)))
  (s2fires "S2b a MISSING premise contract refuses — there is no implicit default"
      premise-contract-missing
    (make-slice2-schema :schema-id :x :base-schema base
                        :premise-contracts (list (list 0 (source-bound-contract)))))
  (s2fires "S2c a DUPLICATE premise index refuses" premise-contract-duplicate
    (make-slice2-schema :schema-id :x :base-schema base
                        :premise-contracts (list (list 0 (source-bound-contract))
                                                 (list 0 (survey-contract))
                                                 (list 1 (survey-contract)))))
  (s2fires "S2d an index the base schema does not have refuses"
      premise-contract-unknown-premise
    (make-slice2-schema :schema-id :x :base-schema base
                        :premise-contracts (list (list 0 (source-bound-contract))
                                                 (list 1 (survey-contract))
                                                 (list 2 (survey-contract)))))
  (s2fires "S2e a contract position holding something that is not a contract refuses"
      slice2-schema-error
    (make-slice2-schema :schema-id :x :base-schema base
                        :premise-contracts (list (list 0 (lambda (s) s))
                                                 (list 1 (survey-contract)))))
  (s2ok "S2f the SAME schema takes a source-bound premise and a direct-survey premise TOGETHER"
        (let ((s (make-slice2-schema
                  :schema-id :release-standing/2 :base-schema base
                  :premise-contracts
                  (list (list 0 (source-bound-contract
                                 :id :outcome-source-bound
                                 :relations '(:core0-account-reports-outcome)))
                        (list 1 (survey-contract))))))
          (and (support-admission-contract-admits-species-p
                (slice2-schema-contract-for-premise s 0) :source-basis)
               (not (support-admission-contract-admits-species-p
                     (slice2-schema-contract-for-premise s 0) :asserted-witness))
               (support-admission-contract-admits-species-p
                (slice2-schema-contract-for-premise s 1) :asserted-witness)
               (not (support-admission-contract-admits-species-p
                     (slice2-schema-contract-for-premise s 1) :source-basis))))
        "de-codice-restaurando is why: one premise demands source-bound evidence, its sibling legitimately accepts a survey"))

;;; ==================================================================
;;; S3 — DEFENSIVE COPY, on both the contract and the source basis.

(format t "~%-- S3: defensive copies --~%")

(let* ((clauses (list (list :source-basis :relations
                            (list :core0-account-reports-acknowledgment))))
       (retain (list :contract-snapshot))
       (c (make-support-admission-contract :contract-id :copy-probe
                                           :accepted-clauses clauses
                                           :retain retain)))
  ;; INGRESS: mutate what the caller passed.
  (setf (second (first clauses)) :relations-tampered)
  (setf (first retain) :tampered)
  (s2ok "S3a caller mutation of the lists PASSED IN cannot revise the contract"
        (and (equal (support-admission-contract-accepted-clauses c)
                    '((:source-basis :relations (:core0-account-reports-acknowledgment))))
             (equal (support-admission-contract-retain c) '(:contract-snapshot))))
  ;; EGRESS: mutate what a reader got back.
  (let ((out (support-admission-contract-accepted-clauses c)))
    (setf (second (first out)) :relations-tampered)
    (s2ok "S3b caller mutation of the list HANDED BACK cannot revise the contract"
          (equal (support-admission-contract-accepted-clauses c)
                 '((:source-basis :relations (:core0-account-reports-acknowledgment))))))
  ;; SNAPSHOT AT REGISTRATION: mutate the alist after the schema was built.
  (let* ((alist (list (list 0 c)))
         (s (make-slice2-schema
             :schema-id :snapshot-probe
             :base-schema (lisp-plus-slice1:resolve-schema :dispatch-account-standing 1)
             :premise-contracts alist)))
    (setf (second (first alist)) (judged-claim-contract))
    (s2ok "S3c caller mutation of the attachment alist AFTER registration cannot revise the schema"
          (eq :copy-probe (support-admission-contract-contract-id
                           (slice2-schema-contract-for-premise s 0))))
    (s2ok "S3d and the registered contract remains fully INSPECTABLE"
          (equal (support-admission-contract-accepted-clauses
                  (slice2-schema-contract-for-premise s 0))
                 '((:source-basis :relations (:core0-account-reports-acknowledgment)))))))

(let* ((ev (genuine-account :label "s2/copy"))
       (b (establish-core0-source-basis
           :evidence ev :request +req+
           :relation :core0-account-reports-acknowledgment)))
  (let ((snap (source-basis-account-snapshot b))
        (req (source-basis-request b))
        (prop (source-basis-proposition b)))
    (setf (getf snap :acknowledgment) :tampered)
    (setf (second req) :tampered)
    (setf (second prop) :tampered)
    (s2ok "S3e mutating a source basis's snapshot, request or proposition cannot revise it"
          (and (eq :acknowledged (getf (source-basis-account-snapshot b) :acknowledgment))
               (eq :deliver (second (source-basis-request b)))
               (eq :core0-account-reports-acknowledgment
                   (second (source-basis-proposition b)))))))

;;; ==================================================================
;;; S4 — THE GENUINE SOURCE BASIS, and the exact-copy account.

(format t "~%-- S4: a genuine source basis --~%")

(defparameter *ev* (genuine-account :label "s2/genuine"))
(defparameter *basis*
  (establish-core0-source-basis
   :evidence *ev* :request +req+
   :relation :core0-account-reports-acknowledgment
   :expected-outcome :acknowledged))

(s2ok "S4a a source basis is NOT a witness, NOT a claim, NOT a refutation"
      (and (source-basis-p *basis*)
           (not (lisp-plus-slice0:witness-p *basis*))
           (not (lisp-plus-slice0:claim-p *basis*))
           (not (lisp-plus-slice1:refutation-p *basis*))))

(s2ok "S4b it binds the ACCOUNT, the EXACT REQUEST, ONE relation, ONE proposition, ONE ceiling"
      (and (lisp-plus-kernel0:identity=
            (source-basis-attempt-id *basis*)
            (lisp-plus-core0:core0-evidence-attempt-id *ev*))
           (equal (source-basis-request *basis*) (np +req+))
           (eq :core0-account-reports-acknowledgment (source-basis-relation-kind *basis*))
           (lisp-plus-slice1:normal-form-p (source-basis-proposition *basis*))
           (eq :current-image-issued-account-report
               (source-basis-truth-ceiling *basis*))))

(s2ok "S4c the produced proposition is ABOUT THE ACCOUNT — never a domain conclusion"
      (let ((p (source-basis-proposition *basis*)))
        (and (eq :core0-account-reports-acknowledgment (second p))
             (notany (lambda (bad) (eq bad (second p)))
                     '(:treatment-completed :safe-to-exhibit :dispatch-delivered
                       :loan-settled :establishes))))
      "D2-0.6: applications derive domain conclusions separately, through explicit schemas")

(s2ok "S4d it is established in this image, and says so through a predicate with a ceiling"
      (source-basis-established-in-current-image-p *basis*))

(multiple-value-bind (r claim decision)
    (run/2 (account-schema (source-bound-contract)) (account-conclusion) (list *basis*))
  (s2ok "S4e a genuine source basis DISCHARGES a source-bound premise — granted"
        (and (eq decision :granted) claim
             (eq :granted (slice2-receipt-decision r))
             (eq :satisfied (premise-admission-disposition (admission-0 r)))
             (equal (list *basis*) (premise-admission-source-bases (admission-0 r)))))
  (s2ok "S4f the receipt retains the APPLIED CONTRACT BY VALUE, not by name"
        (let ((c (premise-admission-contract (admission-0 r))))
          (and (support-admission-contract-p c)
               (eq :source-bound (support-admission-contract-contract-id c))
               (equal (support-admission-contract-accepted-clauses c)
                      '((:source-basis
                         :relations (:core0-account-reports-acknowledgment)))))))
  (s2ok "S4g the premise records the ceiling that ACTUALLY discharged it"
        (equal (premise-admission-truth-ceilings (admission-0 r))
               '((:source-basis . :current-image-issued-account-report))))
  (s2ok "S4h the base Slice /1 receipt rides in the Slice /2 receipt, whole"
        (lisp-plus-slice1:derivation-receipt-p (slice2-receipt-base-receipt r)))
  (s2ok "S4i no global resolver is needed: the basis is reachable FROM THE RECEIPT"
        (let ((b (first (slice2-receipt-source-bases-used r))))
          (and b (equal (source-basis-request b) (np +req+))
               (eq :acknowledged (source-basis-account-status b))))))

;; EXACT COPY of a genuine issued account: Core /0 authenticity belongs to
;; CONTENT (R-ISSUANCE-0.2), so a copy establishes a basis exactly as the
;; original does.
(let* ((copy (lisp-plus-core0::%make-core0-evidence
              :process (lisp-plus-core0::%core0-evidence-process *ev*)
              :attempt-id (lisp-plus-core0::%core0-evidence-attempt-id *ev*)
              :seat-id (lisp-plus-core0::%core0-evidence-seat-id *ev*)
              :adapter-identity (lisp-plus-core0::%core0-evidence-adapter-identity *ev*)
              :adapter (lisp-plus-core0::%core0-evidence-adapter *ev*)
              :request (lisp-plus-core0::%core0-evidence-request *ev*)
              :events (lisp-plus-core0::%core0-evidence-events *ev*)
              :manifestation (lisp-plus-core0::%core0-evidence-manifestation *ev*)
              :ledger-token (lisp-plus-core0::%core0-evidence-ledger-token *ev*)
              :reconciliation-receipts
              (lisp-plus-core0::%core0-evidence-reconciliation-receipts *ev*)
              :refusal-reason (lisp-plus-core0::%core0-evidence-refusal-reason *ev*)))
       (b (establish-core0-source-basis
           :evidence copy :request +req+
           :relation :core0-account-reports-acknowledgment)))
  (multiple-value-bind (r claim decision)
      (run/2 (account-schema (source-bound-contract)) (account-conclusion) (list b))
    (declare (ignore claim))
    (s2ok "S4j an EXACT CONTENT COPY of a genuine issued account establishes a basis and grants"
          (and (not (eq copy *ev*)) (eq decision :granted)
               (eq :granted (slice2-receipt-decision r)))
          "authenticity belongs to content, not to the host object's pointer identity")))

;;; ==================================================================
;;; S5 — THE UNISSUED ACCOUNT.  The construction route the whole lane is about.

(format t "~%-- S5: unissued-account refusal --~%")

(defun built-account (&key attempt (request +req+) (label "s2/built"))
  "A caller-built account: coherent content from PUBLIC constructors, installed
through the host object model.  Lawful for a client to do; it does not confer
issuance (R-ISSUANCE-0.1)."
  (let* ((process (lisp-plus-core0:process-context :label label))
         (obj (make-instance 'lisp-plus-core0:core0-evidence)))
    (setf (slot-value obj 'lisp-plus-core0::process) process
          (slot-value obj 'lisp-plus-core0::attempt-id) attempt
          (slot-value obj 'lisp-plus-core0::seat-id)
          (lisp-plus-core0:process-context-seat-id process)
          (slot-value obj 'lisp-plus-core0::adapter-identity)
          (lisp-plus-kernel0:make-identity :principal "fake-courier/FAKE-COURIER/v0")
          (slot-value obj 'lisp-plus-core0::request) (np request)
          (slot-value obj 'lisp-plus-core0::events)
          (lisp-plus-core0:core0-evidence-events *ev*))
    obj))

(s2fires "S5a a COHERENT caller-built account is refused a source basis"
    unissued-core0-account
  (establish-core0-source-basis
   :evidence (built-account :attempt (lisp-plus-kernel0:make-identity
                                      :attempt "s2/attempt-that-never-ran"))
   :request +req+ :relation :core0-account-reports-acknowledgment))

(s2fires "S5b a caller-built account REUSING A GENUINE ATTEMPT IDENTITY is refused"
    unissued-core0-account
  (establish-core0-source-basis
   :evidence (built-account
              :attempt (lisp-plus-core0:core0-evidence-attempt-id *ev*))
   :request +req+ :relation :core0-account-reports-acknowledgment))

(s2fires "S5c a GENUINE issued account is refused for the WRONG request"
    unissued-core0-account
  (establish-core0-source-basis
   :evidence *ev* :request +other-req+
   :relation :core0-account-reports-acknowledgment))

(s2fires "S5d a blank account of the right TYPE is refused (type membership is not authenticity)"
    unissued-core0-account
  (establish-core0-source-basis
   :evidence (make-instance 'lisp-plus-core0:core0-evidence)
   :request +req+ :relation :core0-account-reports-acknowledgment))

(s2fires "S5e a relation the vocabulary does not define is refused" source-basis-refused
  (establish-core0-source-basis :evidence *ev* :request +req+ :relation :establishes))

(s2ok "S5f and the LAWFUL path through the same gate still passes"
      (source-basis-p (establish-core0-source-basis
                       :evidence *ev* :request +req+
                       :relation :core0-account-issued-for-request)))

;; A source basis this image did NOT establish, offered anyway.
(let* ((caller-built (make-instance 'source-basis)))
  (setf (slot-value caller-built 'carrier) (%source-basis-carrier *basis*)
        (slot-value caller-built 'identity) (source-basis-identity *basis*)
        (slot-value caller-built 'relation-kind) :core0-account-reports-acknowledgment
        (slot-value caller-built 'proposition) (source-basis-proposition *basis*)
        (slot-value caller-built 'request) (np +req+)
        (slot-value caller-built 'truth-ceiling) :current-image-issued-account-report)
  (s2ok "S5g a source-basis-SHAPED value this image did not establish answers FALSE"
        (and (source-basis-p caller-built)
             (not (source-basis-established-in-current-image-p caller-built))))
  (multiple-value-bind (r claim decision)
      (run/2 (account-schema (source-bound-contract)) (account-conclusion)
             (list caller-built) :receiver (ctx *basis*))
    (declare (ignore claim))
    (s2ok "S5h and offering it is REFUSED — recognized, not admitted, and visible"
          (and (eq decision :refused)
               (eq :not-admitted (premise-admission-disposition (admission-0 r)))
               (equal (list caller-built)
                      (premise-admission-recognized-not-admitted (admission-0 r)))
               (null (premise-admission-source-bases (admission-0 r))))
          "R-SOURCE-1.6 one layer up: the structure class is not the authority")))

;; The carrier, offered BARE — without its basis.
(multiple-value-bind (r claim decision)
    (run/2 (account-schema (source-bound-contract)) (account-conclusion)
           (list (%source-basis-carrier *basis*)))
  (declare (ignore claim))
  (s2ok "S5i the carrier witness offered BARE is an ordinary witness, and is NOT admitted"
        (and (eq decision :refused)
             (eq :not-admitted (premise-admission-disposition (admission-0 r)))
             (null (premise-admission-source-bases (admission-0 r))))
        "the carrier is a transport; admission is decided by the registry, never by the carrier's attributes"))

;;; ==================================================================
;;; S6 — STATUS LAUNDERING.  Every route D2-0.8 names, at a source-bound premise.

(format t "~%-- S6: status laundering is refused --~%")

(defparameter *ack-proposition* (source-basis-proposition *basis*))

(defun raw-witness (&key (mode :direct) (kind :courier-ledger) (source :desk)
                         procedure content)
  (lisp-plus-slice0:witness :for *ack-proposition* :mode mode :kind kind
                            :source source :procedure procedure :content content))

(defparameter *ledger-reading*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "s2/read-the-courier-ledger")
                :version 1 :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits '((:direct :courier-ledger))))

(defun raise-it (w)
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim :proposition *ack-proposition* :by :desk)
   :to :verified :per *ledger-reading* :considering (list w) :receiver :s2-desk))

(defparameter *laundering-routes*
  (list
   (cons "a RAW fabricated witness"
         (raw-witness :procedure (lisp-plus-kernel0:make-identity
                                  :attempt "s2/crossing-that-never-was")
                      :content '(:ledger-token "fake:0000")))
   (cons "the SAME fabrication RAISED into a :VERIFIED claim"
         (raise-it (raw-witness :procedure (lisp-plus-kernel0:make-identity
                                            :attempt "s2/crossing-that-never-was")
                                :content '(:ledger-token "fake:0000"))))
   (cons "a witness carrying the REAL account's attempt id and token, raised"
         (raise-it (raw-witness
                    :procedure (lisp-plus-core0:core0-evidence-attempt-id *ev*)
                    :content (list :ledger-token
                                   (lisp-plus-core0:core0-evidence-ledger-token *ev*)))))
   (cons "a BARE witness carrying nothing at all, raised"
         (raise-it (raw-witness)))
   (cons "a claim carrying an ATTEMPT-SHAPED identity, raised"
         (raise-it (raw-witness :procedure (lisp-plus-kernel0:make-identity
                                            :attempt "core0/attempt/1"))))))

(let ((all-refused t) (all-visible t))
  (dolist (route *laundering-routes*)
    (multiple-value-bind (r claim decision)
        (run/2 (account-schema (source-bound-contract)) (account-conclusion)
               (list (cdr route)))
      (declare (ignore claim))
      (let ((a (admission-0 r)))
        (format t "     ~44A base=~S slice/2=~S~%" (car route)
                (premise-admission-base-disposition a)
                (premise-admission-disposition a))
        (unless (and (eq decision :refused)
                     (eq :not-admitted (premise-admission-disposition a)))
          (setf all-refused nil))
        ;; VISIBILITY: the refusal must be distinguishable from never having
        ;; been offered anything — the CHARTER-DELTA-3 lesson, one layer up.
        (unless (premise-admission-recognized-not-admitted a)
          (setf all-visible nil)))))
  (s2ok "S6a ALL FIVE laundering routes are refused at a source-bound premise"
        all-refused
        "a generic :VERIFIED claim is not a source basis (D2-0.8)")
  (s2ok "S6b and each refusal is VISIBLE — recognized-but-not-admitted, never silently absent"
        all-visible)
  (s2ok "S6c the base Slice /1 derivation GRANTED on the same evidence — the narrowing is the whole difference"
        (multiple-value-bind (r claim decision)
            (run/2 (account-schema (source-bound-contract)) (account-conclusion)
                   (list (cdr (second *laundering-routes*))))
          (declare (ignore claim))
          (and (eq decision :refused)
               (eq :granted (lisp-plus-slice1:derivation-receipt-decision
                             (slice2-receipt-base-receipt r)))))
        "Slice /1 is unchanged and still says :GRANTED; Slice /2 refuses, and the receipt shows both"))

;;; ==================================================================
;;; S7 — LEGACY JUDGED CLAIMS.  CATENA preserved where a contract accepts it.

(format t "~%-- S7: the lawful judged claim --~%")

(defparameter *lawful-claim* (raise-it (raw-witness)))

(multiple-value-bind (r claim decision)
    (run/2 (account-schema (judged-claim-contract)) (account-conclusion)
           (list *lawful-claim*))
  (let* ((a (admission-0 r))
         (entry (find-if (lambda (e)
                           (lisp-plus-kernel0:identity=
                            (getf e :claim-id)
                            (lisp-plus-slice0:claim-id *lawful-claim*)))
                         (premise-admission-judged-claims a))))
    (s2ok "S7a a contract accepting :VERIFIED-JUDGED-CLAIM admits one, and grants"
          (and (eq decision :granted) claim
               (eq :satisfied (premise-admission-disposition a))))
    (s2ok "S7b exact claim identity, positive :VERIFIED judgment, and the judgment BASIS are retained"
          (and entry
               (eq :discharged (getf entry :outcome))
               (eq :verified (getf entry :judgment))
               (lisp-plus-kernel0:durable-identity-p (getf entry :procedure-id))
               (getf entry :support-ids)))
    (s2ok "S7c the ceiling recorded for it is PRIOR-GOVERNED-JUDGMENT, never source-bound"
          (equal (premise-admission-truth-ceilings a)
                 '((:verified-judged-claim . :prior-governed-judgment))))))

(multiple-value-bind (r claim decision)
    (run/2 (account-schema (judged-claim-contract)) (account-conclusion)
           (list *basis*))
  (declare (ignore claim))
  (s2ok "S7d and the converse holds: a SOURCE BASIS is not admitted by a judged-claim-only contract"
        (and (eq decision :refused)
             (eq :not-admitted (premise-admission-disposition (admission-0 r)))
             (equal (list *basis*)
                    (premise-admission-recognized-not-admitted (admission-0 r))))
        "narrowing runs in both directions; a contract admits what it names and nothing else"))

;;; ==================================================================
;;; S8 — THE INDETERMINATE ACCOUNT.  It may produce ONLY what it truthfully
;;; reports.

(format t "~%-- S8: the indeterminate account --~%")

(defparameter *withheld-req* '(:predicate :deliver (:payload "codex-9 -> withheld")))
(defparameter *withheld*
  (genuine-account :request *withheld-req* :script :kill-after-commit-withhold
                   :label "s2/withheld"))

(s2ok "S8a the interrupted account IS Core /0-issued — it is uncertain, not unissued"
      (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
       *withheld* *withheld-req*))

(let ((b (establish-core0-source-basis
          :evidence *withheld* :request *withheld-req*
          :relation :core0-account-reports-outcome)))
  (s2ok "S8b a basis on the interrupted account reports the outcome it ACTUALLY has"
        (and (eq :failed (source-basis-account-outcome b))
             (equal (source-basis-proposition b)
                    (np `(:predicate :core0-account-reports-outcome
                          (:attempt ,(lisp-plus-kernel0:identity-key
                                      (lisp-plus-core0:core0-evidence-attempt-id *withheld*)))
                          (:request (:quoted-datum ,(np *withheld-req*)))
                          (:outcome :failed)))))
        "not :COMPLETED, not settlement, not acknowledgment-of-delivery — :FAILED, which is what it says")
  (s2ok "S8c and it carries the SAME ceiling as any other basis — uncertainty does not lower it, and does not raise it"
        (eq :current-image-issued-account-report (source-basis-truth-ceiling b))))

(s2fires "S8d asking the interrupted account to report :COMPLETED is REFUSED"
    source-basis-refused
  (establish-core0-source-basis
   :evidence *withheld* :request *withheld-req*
   :relation :core0-account-reports-outcome :expected-outcome :completed))

(s2ok "S8e the interrupted account DID report acknowledgment — which is not delivery, and the two are separate relations"
      (let ((b (establish-core0-source-basis
                :evidence *withheld* :request *withheld-req*
                :relation :core0-account-reports-acknowledgment)))
        (and (eq :acknowledged (source-basis-account-status b))
             (eq :failed (source-basis-account-outcome b))))
      "the provider took the request AND the effect did not settle; one account, two true reports")

;; A premise wanting :COMPLETED cannot be discharged by a basis reporting :FAILED
;; — Slice /1's matcher refuses it, and Slice /2 does not readmit a mismatch.
(let* ((base (lisp-plus-slice1:resolve-schema :release-standing 1))
       (s (make-slice2-schema
           :schema-id :release-standing/2 :base-schema base
           :premise-contracts
           (list (list 0 (source-bound-contract
                          :id :outcome-source-bound
                          :relations '(:core0-account-reports-outcome)))
                 (list 1 (survey-contract)))))
       (b (establish-core0-source-basis
           :evidence *withheld* :request *withheld-req*
           :relation :core0-account-reports-outcome))
       (survey (lisp-plus-slice0:witness
                :for (np '(:predicate :condition-surveyed (:volume "codex-9")
                           (:assay "ASY-1")))
                :mode :direct :kind :condition-survey :source :conservator)))
  (multiple-value-bind (r claim decision)
      (run/2 s (np '(:predicate :may-release (:volume "codex-9"))) (list b survey))
    (declare (ignore claim))
    ;; The disposition is :MISMATCHED, not :MISSING — the predicate matched and
    ;; the :OUTCOME role conflicted, which is a more informative answer than
    ;; "nothing was offered" and is Slice /1's own, passed through untouched.
    ;; A mismatched candidate is not a participant, so it reaches neither
    ;; admission roster: admission may not readmit a mismatch, and here it is
    ;; not even asked to.
    (s2ok "S8f a premise wanting :COMPLETED is NOT discharged by a basis reporting :FAILED"
          (and (eq decision :refused)
               (eq :mismatched
                   (premise-admission-disposition (first (slice2-receipt-admissions r))))
               (null (premise-admission-source-bases
                      (first (slice2-receipt-admissions r))))
               (null (premise-admission-recognized-not-admitted
                      (first (slice2-receipt-admissions r))))
               ;; and the sibling premise WAS satisfied, by the survey its own
               ;; contract explicitly accepts
               (eq :satisfied (premise-admission-disposition
                               (second (slice2-receipt-admissions r))))
               (equal '((:asserted-witness . :asserted))
                      (premise-admission-truth-ceilings
                       (second (slice2-receipt-admissions r)))))
          "admission may refuse positive support; it may NOT readmit a mismatch")))

;;; ==================================================================
;;; S9 — REFUTATION PRECEDENCE.  A contract can refuse to let something HELP.
;;; It can never let something stop HURTING.

(format t "~%-- S9: refutation precedence --~%")

(let* ((refutation (lisp-plus-slice1:refutation :refutes *ack-proposition*
                                                :source :loan-book)))
  (multiple-value-bind (r claim decision)
      (run/2 (account-schema (source-bound-contract)) (account-conclusion)
             (list *basis* refutation) :receiver (ctx *basis*))
    (declare (ignore claim))
    (s2ok "S9a a refutation blocks a premise a GENUINE SOURCE BASIS would otherwise satisfy"
          (and (eq decision :refused)
               (eq :refuted (premise-admission-disposition (admission-0 r)))
               (= 1 (length (premise-admission-refuting-supports (admission-0 r))))))))

(let* ((refuting-witness
         (lisp-plus-slice0:witness :for *ack-proposition* :mode :direct
                                   :kind :courier-ledger :source :desk
                                   :polarity :refutes)))
  (multiple-value-bind (r claim decision)
      (run/2 (account-schema (source-bound-contract)) (account-conclusion)
             (list *basis* refuting-witness)
             :receiver (ctx *basis* refuting-witness))
    (declare (ignore claim))
    (s2ok "S9b a witness DECLARING :REFUTES blocks it too — and a contract that does not admit that witness as SUPPORT still cannot disarm it as REFUTATION"
          (and (eq decision :refused)
               (eq :refuted (premise-admission-disposition (admission-0 r)))
               (= 1 (length (premise-admission-refuting-witnesses (admission-0 r)))))
          "R-POLARITY-1 survives admission: narrowing removes positive support, never counter-evidence")))

;;; ==================================================================
;;; S10 — SEMANTIC OVERREACH.  The account-report proposition is not the domain
;;; proposition, and no relation will bridge them.

(format t "~%-- S10: semantic overreach is refused --~%")

(s2ok "S10a none of the three relations produces a DOMAIN conclusion"
      (let ((produced
              (loop for rel in (core0-source-relations)
                    collect (second (source-basis-proposition
                                     (establish-core0-source-basis
                                      :evidence *ev* :request +req+ :relation rel))))))
        (and (= 3 (length produced))
             (every (lambda (p) (eq :core0 (intern (subseq (symbol-name p) 0 5) :keyword)))
                    produced)
             (null (intersection produced
                                 '(:treatment-completed :safe-to-exhibit
                                   :dispatch-delivered :loan-settled)))))
      "R-ADMISSION-0.8: binding is not implication")

;; A treatment account cannot directly establish "safe to exhibit": the schema
;; that wants :SAFE-TO-EXHIBIT has no premise a source relation can produce.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :exhibition-standing :version 1
  :conclusion (pp '(:predicate :safe-to-exhibit (:manuscript (:var :manuscript))
                    (:exhibition (:var :exhibition))))
  :premises (list (pp '(:predicate :post-treatment-condition-established
                        (:manuscript (:var :manuscript)) (:method (:var :method)))))
  :locals '(:method)))

(let* ((treatment-req '(:predicate :deliver (:payload "codex-9 / humidification")))
       (treatment-account (genuine-account :request treatment-req
                                           :label "s2/treatment"))
       (b (establish-core0-source-basis
           :evidence treatment-account :request treatment-req
           :relation :core0-account-reports-outcome :expected-outcome :completed))
       (s (make-slice2-schema
           :schema-id :exhibition-standing/2
           :base-schema (lisp-plus-slice1:resolve-schema :exhibition-standing 1)
           :premise-contracts
           (list (list 0 (source-bound-contract
                          :id :exhibition-source-bound
                          :relations (core0-source-relations)))))))
  (s2ok "S10b the treatment account genuinely reports :COMPLETED — the arm is not rigged by a weak account"
        (eq :completed (source-basis-account-outcome b)))
  (multiple-value-bind (r claim decision)
      (run/2 s (np '(:predicate :safe-to-exhibit (:manuscript "codex-9")
                     (:exhibition "EXH-1")))
             (list b))
    (declare (ignore claim))
    (s2ok "S10c a COMPLETED treatment account cannot establish :SAFE-TO-EXHIBIT"
          (and (eq decision :refused)
               (eq :missing (premise-admission-disposition (admission-0 r))))
          "the account reports an account fact; post-treatment condition is a different proposition with a different basis")))

;;; ==================================================================
;;; S11 — DERIVE/2 STRUCTURE.  Residue, missing contracts, Slice /1 untouched.

(format t "~%-- S11: derive/2 structure --~%")

(multiple-value-bind (r claim decision)
    (run/2 (account-schema (source-bound-contract)) (account-conclusion)
           (list *basis* *ev* 17) :receiver (ctx *basis*))
  (declare (ignore claim decision))
  (s2ok "S11a a Core /0 account handed straight across is RESIDUE at the CALLER's own index"
        (equal (slice2-receipt-unsupported-supports r)
               '((:index 1 :reason :unsupported-support-species)
                 (:index 2 :reason :unsupported-support-species)))
        "visibility is not admissibility — the account is recorded and has no semantic effect")
  (s2ok "S11b and the residue changed nothing: the derivation still granted on the basis alone"
        (eq :granted (slice2-receipt-decision r))))

(s2fires "S11c DERIVE/2 refuses a value that is not a Slice /2 schema" slice2-schema-error
  (derive/2 :schema (lisp-plus-slice1:resolve-schema :dispatch-account-standing 1)
            :conclusion (account-conclusion) :supports (list *basis*)))

(let ((s (account-schema (source-bound-contract))))
  ;; Re-register a DIFFERENT schema under the same key, then derive.
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :dispatch-account-standing :version 1
    :conclusion (pp '(:predicate :dispatch-account-acknowledged (:volume (:var :volume))))
    :premises (list (pp '(:predicate :something-else (:x (:var :x)))))
    :locals '(:x)))
  (s2fires "S11d DERIVE/2 refuses when the registered base schema is not the one the contracts were attached to"
      slice2-schema-error
    (derive/2 :schema s :conclusion (account-conclusion) :supports (list *basis*)))
  (install-schemas))

(s2ok "S11e :RECEIVER-ACCESSIBILITY :REQUIRED is not satisfied by a NULL receiver context"
      (multiple-value-bind (r claim decision)
          (run/2 (account-schema (source-bound-contract)) (account-conclusion)
                 (list *basis*) :receiver nil)
        (declare (ignore claim))
        (and (eq decision :refused)
             (eq :not-admitted (premise-admission-disposition (admission-0 r)))
             (find :receiver-context-required
                   (premise-admission-reasons (admission-0 r)) :key #'first)))
      "Slice /1 reads a null receiver as universal reach; a source-bound premise does not inherit that by omission")

(s2ok "S11f :RECEIVER-ACCESSIBILITY :OPTIONAL is honoured, and the same call then grants"
      (let ((c (make-support-admission-contract
                :contract-id :source-bound-open
                :accepted-clauses
                '((:source-basis :relations (:core0-account-reports-acknowledgment)))
                :receiver-accessibility :optional)))
        (multiple-value-bind (r claim decision)
            (run/2 (account-schema c) (account-conclusion) (list *basis*) :receiver nil)
          (declare (ignore claim))
          (and (eq decision :granted) (eq :granted (slice2-receipt-decision r))))))

(s2ok "S11g `derive` is untouched: Slice /1 exports no Slice /2 name and DERIVE/2 is not DERIVE"
      (and (not (eq (find-symbol "DERIVE/2" :lisp-plus-slice1)
                    (find-symbol "DERIVE/2" :lisp-plus-slice2)))
           (null (find-symbol "DERIVE/2" :lisp-plus-slice1))
           (eq :external (nth-value 1 (find-symbol "DERIVE" :lisp-plus-slice1)))))

(s2ok "S11h Slice /2 keeps NO schema registry — there is no global table to consult"
      (let ((leaked '()))
        (do-external-symbols (s :lisp-plus-slice2)
          (let ((n (symbol-name s)))
            (when (or (search "REGISTRY" n) (search "RESOLVE" n)
                      (search "REGISTER" n))
              (push n leaked))))
        (null leaked)))

(s2ok "S11i the strongest lawful result is computed over SLICE /2's dispositions"
      (multiple-value-bind (r claim decision)
          (run/2 (account-schema (source-bound-contract)) (account-conclusion)
                 (list (cdr (second *laundering-routes*))))
        (declare (ignore claim decision))
        (equal (slice2-receipt-strongest-lawful-result r)
               '(:blocked-on :core0-account-reports-acknowledgment :not-admitted))))

;;; ==================================================================
;;; S12 — RENDERING.  The one sentence RENDER-SLICE2-WHY must never print.

(format t "~%-- S12: rendering --~%")

(let* ((text (with-output-to-string (out)
               (multiple-value-bind (r claim decision)
                   (run/2 (account-schema (source-bound-contract))
                          (account-conclusion) (list *basis*))
                 (declare (ignore claim decision))
                 (render-slice2-why r out)))))
  (s2ok "S12a the rendering names the relation, the request, the attempt and the ceiling"
        (and (search "CORE0-ACCOUNT-REPORTS-ACKNOWLEDGMENT" text)
             (search "attempt:core0/attempt/" text)
             (search "CURRENT-IMAGE-ISSUED-ACCOUNT-REPORT" text)
             (search ":DELIVER" text)))
  (s2ok "S12b it NEVER prints 'effect occurred' — it prints what the account REPORTS"
        (and (not (search "effect occurred" text))
             (not (search "delivered" text))
             (search "REPORTS" text))))

;;; ==================================================================
;;; THE NEGATIVE CONTROL.  ONE mutation, run to failure, then restored.
;;;
;;; Blind %ADMITS-CLAIM-P so a verified judged claim satisfies the SOURCE-BASIS
;;; clause.  The raised-fabrication tooth (S6a) must FAIL.  A tooth that cannot
;;; be made to fail is not measuring anything.

(format t "~%-- NEGATIVE CONTROL: the source-basis clause blinded to judged claims --~%")

(let ((cured (symbol-function '%admits-claim-p))
      (blinded-refused nil) (restored-refused nil))
  (unwind-protect
       (progn
         (setf (symbol-function '%admits-claim-p)
               (lambda (contract claim)
                 (declare (ignore claim))
                 (and (or (%contract-clause contract :verified-judged-claim)
                          (%contract-clause contract :source-basis))
                      t)))
         (multiple-value-bind (r claim decision)
             (run/2 (account-schema (source-bound-contract)) (account-conclusion)
                    (list (cdr (second *laundering-routes*))))
           (declare (ignore claim))
           (setf blinded-refused
                 (and (eq decision :refused)
                      (eq :not-admitted (premise-admission-disposition (admission-0 r)))))
           (format t "     blinded: decision=~S premise=~S~%" decision
                   (premise-admission-disposition (admission-0 r)))))
    (setf (symbol-function '%admits-claim-p) cured))
  (multiple-value-bind (r claim decision)
      (run/2 (account-schema (source-bound-contract)) (account-conclusion)
             (list (cdr (second *laundering-routes*))))
    (declare (ignore claim))
    (setf restored-refused
          (and (eq decision :refused)
               (eq :not-admitted (premise-admission-disposition (admission-0 r)))))
    (format t "     restored: decision=~S premise=~S~%" decision
            (premise-admission-disposition (admission-0 r))))
  (s2ok "NC1 with the clause BLINDED, the raised-fabrication tooth FAILS (the laundered claim is admitted and the derivation grants)"
        (not blinded-refused)
        "the tooth is measuring the contract, not the weather")
  (s2ok "NC2 with the cure RESTORED, the same tooth is green again"
        restored-refused))


;;; ==================================================================
;;; C1 — CANDIDATE /1: COMPOSITIONAL ADMISSION.
;;;
;;; Governed by LANGUAGE-SLICE-2-WORK-ORDER-1.md.  Closes [IX-10] one layer up:
;;; a claim granted by DERIVE/2 can now travel WITH the admission record that
;;; governed its grant, as a species a later premise may explicitly accept.
;;;
;;; Every negative control below asserts the TYPED CONDITION, the DISPOSITION,
;;; the RECEIPT FIELD or the RENDERED REASON — never merely "did it fail?".
;;; The work order says so in as many words, and the reason is on the record:
;;; a probe earlier in this lane observed three failures and would have
;;; reported a gate fired, when the failures came from somewhere else entirely.

(format t "~%-- C1: compositional admission (Candidate /1) --~%")

;;; A downstream schema whose ONE premise wants the conclusion the FIRST
;;; derivation produced.  This is the composition joint, and it is deliberately
;;; the dullest possible one.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :composed-standing :version 1
  :conclusion (pp '(:predicate :composed-standing (:volume (:var :volume))))
  :premises (list (pp '(:predicate :dispatch-account-acknowledged
                        (:volume (:var :volume)))))))

(defun dbasis-contract (&key (id :derivation-bound) (version 1))
  (make-support-admission-contract
   :contract-id id :contract-version version
   :accepted-clauses '((:derivation-basis))))

(defun composed-schema (contract &key (id :composed-standing/2))
  (make-slice2-schema
   :schema-id id
   :base-schema (lisp-plus-slice1:resolve-schema :composed-standing 1)
   :premise-contracts (list (list 0 contract))))

(defun composed-conclusion (&optional (volume "codex-9"))
  (np `(:predicate :composed-standing (:volume ,volume))))

(defun run/2* (schema conclusion supports &key (receiver :auto))
  "DERIVE/2 keeping ALL THREE values.  (RUN/2 above keeps two and is left
exactly as it was — it is the standing proof that a Candidate /0 caller taking
two values is unaffected by the additive third.)"
  (let ((rcv (if (eq receiver :auto) (apply #'ctx supports) receiver)))
    (handler-case
        (multiple-value-bind (claim receipt dbasis)
            (derive/2 :schema schema :conclusion conclusion
                      :supports supports :receiver rcv)
          (values receipt claim :granted dbasis))
      (slice2-derivation-refused (c)
        (values (slice2-condition-receipt c) nil :refused nil)))))

;;; --- C1.1  contract versioning ------------------------------------

(s2fires "C1a a VERSION-0 contract REFUSES (:derivation-basis) at construction"
         unknown-admission-clause
  (make-support-admission-contract
   :contract-id :v0-cannot :contract-version 0
   :accepted-clauses '((:derivation-basis))))

(let ((c (dbasis-contract)))
  (s2ok "C1b a VERSION-1 contract accepts it, with NO caller-selectable options"
        (and (support-admission-contract-p c)
             (eql 1 (support-admission-contract-contract-version c))
             (equal '((:derivation-basis))
                    (support-admission-contract-accepted-clauses c))
             (support-admission-contract-admits-species-p c :derivation-basis))))

(s2fires "C1c an UNKNOWN contract version refuses at construction"
         admission-contract-error
  (make-support-admission-contract
   :contract-id :from-the-future :contract-version 2
   :accepted-clauses '((:verified-judged-claim))))

(let ((c (dbasis-contract)))
  (s2ok "C1d the derivation-basis ceiling is FIXED and is NOT the source-basis ceiling"
        (and (eq :prior-explicit-admission-judgment
                 (cdr (assoc :derivation-basis
                             (support-admission-contract-truth-ceilings c))))
             (not (eq :prior-explicit-admission-judgment
                      +source-basis-truth-ceiling+)))
        "two distinct keywords, so no reader can confuse a prior judgment with an account report"))

;;; --- C1.2  DERIVE/2 mints on grant, and only on grant ---------------

(defparameter *c1-ev* (genuine-account :label "s2/c1"))
(defparameter *c1-basis*
  (establish-core0-source-basis
   :evidence *c1-ev* :request +req+
   :relation :core0-account-reports-acknowledgment
   :expected-outcome :acknowledged))

(defparameter *c1-claim* nil)
(defparameter *c1-receipt* nil)
(defparameter *c1-dbasis* nil)

(multiple-value-bind (r claim decision dbasis)
    (run/2* (account-schema (source-bound-contract)) (account-conclusion)
            (list *c1-basis*))
  (setf *c1-claim* claim *c1-receipt* r *c1-dbasis* dbasis)
  (s2ok "C1e a GRANT returns a THIRD value, and it is a derivation basis"
        (and (eq decision :granted) (derivation-basis-p dbasis)))
  (s2ok "C1f it binds the EXACT claim and the EXACT receipt — by object, not by name"
        (and (eq (derivation-basis-claim dbasis) claim)
             (eq (derivation-basis-receipt dbasis) r)))
  (s2ok "C1g it is established in this image, and carries the fixed ceiling"
        (and (derivation-basis-established-in-current-image-p dbasis)
             (eq :prior-explicit-admission-judgment
                 (derivation-basis-truth-ceiling dbasis))
             (eq :slice2-derivation (derivation-basis-species dbasis))))
  (s2ok "C1h ONE durable identity, not two: the basis identity IS the claim's"
        (lisp-plus-kernel0:identity= (derivation-basis-identity dbasis)
                                     (lisp-plus-slice0:claim-id claim)))
  (s2ok "C1i a derivation basis is NOT a claim, witness, refutation or source basis"
        (and (not (lisp-plus-slice0:claim-p dbasis))
             (not (lisp-plus-slice0:witness-p dbasis))
             (not (lisp-plus-slice1:refutation-p dbasis))
             (not (source-basis-p dbasis)))))

(let ((before (hash-table-count *established-derivation-bases*)))
  (multiple-value-bind (r claim decision dbasis)
      ;; A source-bound premise offered a bare raised claim: refused.
      (run/2* (account-schema (source-bound-contract)) (account-conclusion)
              (list *lawful-claim*))
    (declare (ignore claim))
    (s2ok "C1j a REFUSED derive/2 mints NO basis and registers NOTHING"
          (and (eq decision :refused)
               (null dbasis)
               (= before (hash-table-count *established-derivation-bases*))
               (eq :not-admitted (premise-admission-disposition (admission-0 r))))
          (format nil "registry ~D before, ~D after; premise ~S"
                  before (hash-table-count *established-derivation-bases*)
                  (premise-admission-disposition (admission-0 r))))))

;;; --- C1.3  the closure of [IX-10] -----------------------------------

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-dbasis*))
  (declare (ignore claim))
  (s2ok "C1k an ESTABLISHED derivation basis DISCHARGES a derivation-bound premise"
        (and (eq decision :granted)
             (eq :satisfied (premise-admission-disposition (admission-0 r)))
             (= 1 (length (premise-admission-derivation-bases (admission-0 r))))))
  (s2ok "C1l the downstream receipt reaches the EXACT prior receipt — NO resolver"
        (let ((used (slice2-receipt-derivation-bases-used r)))
          (and (= 1 (length used))
               (eq *c1-receipt* (derivation-basis-receipt (first used)))
               ;; and through it, the prior admission record itself
               (eq :granted (slice2-receipt-decision
                             (derivation-basis-receipt (first used))))
               (source-basis-p (first (slice2-receipt-source-bases-used
                                       (derivation-basis-receipt (first used)))))))
        "the prior claim, prior receipt, applied contracts and prior source bases are all in hand")
  (s2ok "C1m the premise's recorded ceiling is the PRIOR-JUDGMENT one, not the account one"
        (equal '((:derivation-basis . :prior-explicit-admission-judgment))
               (premise-admission-truth-ceilings (admission-0 r))))
  (let ((text (with-output-to-string (out) (render-slice2-why r out))))
    (s2ok "C1n the rendering says PRIOR EXPLICIT ADMISSION JUDGMENT"
          (search "PRIOR EXPLICIT ADMISSION" text))
    ;; BLUNT SUBSTRING SEARCH, deliberately.  It cannot tell an assertion from
    ;; a denial — so the renderer's own disclaimer is worded to avoid these
    ;; exact phrases rather than the check being taught to parse around them.
    ;; This check FIRED during construction, on the renderer's disclaimer, and
    ;; the renderer was reworded rather than the check softened.
    (s2ok "C1o and NEVER says proved / effect occurred / externally verified / settled"
          (notany (lambda (w) (search w text))
                  '("proved" "effect occurred" "externally verified" "settled"))
          "the ceiling survives the trip to the printer")))

;;; --- C1.4  what must NOT discharge it -------------------------------

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-claim*))
  (declare (ignore claim))
  (s2ok "C1p the NAKED granted claim is recognized and NOT ADMITTED"
        (and (eq decision :refused)
             (eq :not-admitted (premise-admission-disposition (admission-0 r)))
             (eq :satisfied (premise-admission-base-disposition (admission-0 r)))
             (member *c1-claim* (premise-admission-recognized-not-admitted
                                 (admission-0 r))))
        "slice /1 satisfied it; slice /2 refused the ROUTE — visible, not vanished")
  (s2ok "C1q and the reason names the NAKED route explicitly"
        (find-if (lambda (rn) (and (eq (first rn) :judged-claim-not-admitted)
                                   (eq (getf (rest rn) :route) :naked)))
                 (premise-admission-reasons (admission-0 r)))))

(defparameter *c1-impostor*
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim :proposition (account-conclusion) :by :desk)
   :to :verified :per *ledger-reading*
   :considering (list (lisp-plus-slice0:witness
                       :for (account-conclusion) :mode :direct :kind :courier-ledger
                       :source :desk))
   :receiver :s2-desk))

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-impostor*))
  (declare (ignore claim))
  (s2ok "C1r an ORDINARILY RAISED claim with the SAME proposition is NOT ADMITTED"
        (and (eq decision :refused)
             (eq :not-admitted (premise-admission-disposition (admission-0 r))))
        "a :VERIFIED standing is not an admission record (R-ADMISSION-0.2, one layer up)"))

(let ((fabricated (%make-derivation-basis
                   :identity (lisp-plus-slice0:claim-id *c1-claim*)
                   :version 0 :species :slice2-derivation
                   :claim *c1-claim* :receipt *c1-receipt*
                   :proposition (lisp-plus-slice0:claim-proposition *c1-claim*)
                   :schema-id (slice2-receipt-schema-id *c1-receipt*)
                   :schema-version (slice2-receipt-schema-version *c1-receipt*)
                   :origin-context (slice2-receipt-origin-context *c1-receipt*)
                   :truth-ceiling +derivation-basis-truth-ceiling+)))
  ;; Every field agrees with a real grant.  It is COHERENT — and it was not
  ;; minted by DERIVE/2, which is the only thing that matters.
  (s2ok "C1s a fully COHERENT basis this image did not mint answers FALSE"
        (and (derivation-basis-p fabricated)
             (%derivation-basis-coherent-p fabricated)
             (not (derivation-basis-established-in-current-image-p fabricated)))
        "coherence is a property of the object; establishment is a property of its history")
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
             (list fabricated))
    (declare (ignore claim))
    (s2ok "C1t and offering it is REFUSED — recognized, not admitted, and VISIBLE"
          (and (eq decision :refused)
               (eq :not-admitted (premise-admission-disposition (admission-0 r)))
               (member fabricated (premise-admission-recognized-not-admitted
                                   (admission-0 r))))))
  (let ((copy (copy-structure *c1-dbasis*)))
    (s2ok "C1u a STRUCTURAL COPY of a real basis fails establishment"
          (and (derivation-basis-p copy)
               (not (eq copy *c1-dbasis*))
               (not (derivation-basis-established-in-current-image-p copy)))
          "EQ registry, stated plainly: Slice /2 does not pretend copies are safe")))

;;; A basis whose internal conjunction is inconsistent — REGISTERED, and still
;;; false.  This is the one case registry membership alone could not catch.
(let ((inconsistent (%register-derivation-basis
                     (%make-derivation-basis
                      :identity (lisp-plus-slice0:claim-id *c1-claim*)
                      :version 0 :species :slice2-derivation
                      :claim *c1-claim*
                      :receipt *c1-receipt*
                      :proposition (lisp-plus-slice0:claim-proposition *c1-claim*)
                      :schema-id :a-schema-this-receipt-is-not-about
                      :schema-version 99
                      :origin-context nil
                      :truth-ceiling +derivation-basis-truth-ceiling+))))
  (s2ok "C1v a REGISTERED basis whose claim/receipt conjunction is inconsistent answers FALSE"
        (and (gethash inconsistent *established-derivation-bases*)
             (not (%derivation-basis-coherent-p inconsistent))
             (not (derivation-basis-established-in-current-image-p inconsistent)))
        "the object answers for itself as well; the registry is not the only authority")
  (remhash inconsistent *established-derivation-bases*))

(let ((shaped (%make-derivation-basis
               :identity (lisp-plus-slice0:claim-id *c1-claim*)
               :version 0 :species :slice2-derivation
               :claim :not-a-claim :receipt *c1-receipt*
               :proposition (lisp-plus-slice0:claim-proposition *c1-claim*)
               :schema-id nil :schema-version nil :origin-context nil
               :truth-ceiling +derivation-basis-truth-ceiling+)))
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion) (list shaped))
    (declare (ignore claim decision))
    (s2ok "C1w a basis-SHAPED value with no usable carrier is RESIDUE at the caller's index"
          (equal '((:index 0 :reason :derivation-basis-without-carrier))
                 (slice2-receipt-unsupported-supports r))
          "visible, never admissible — the shape is not the thing")))

;;; --- C1.5  the two roads stay distinct ------------------------------

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-claim* *c1-dbasis*))
  (declare (ignore claim))
  (let ((a (admission-0 r)))
    (s2ok "C1x the SAME claim offered NAKED and THROUGH a basis stays ROUTE-DISTINCT"
          (and (eq decision :granted)
               (eq :satisfied (premise-admission-disposition a))
               ;; the basis road was admitted...
               (= 1 (length (premise-admission-derivation-bases a)))
               (eq *c1-dbasis* (first (premise-admission-derivation-bases a)))
               ;; ...and the naked road was refused, in the same derivation
               (member *c1-claim* (premise-admission-recognized-not-admitted a))
               (find-if (lambda (rn)
                          (and (eq (first rn) :judged-claim-not-admitted)
                               (eq (getf (rest rn) :route) :naked)))
                        (premise-admission-reasons a)))
          "one derivation, one claim, two roads, two verdicts — not deduplicated")))

;;; --- C1.6  Slice /1 still owns what Slice /1 owns --------------------

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract))
           (np '(:predicate :composed-standing (:volume "a-different-volume")))
           (list *c1-dbasis*))
  (declare (ignore claim))
  (s2ok "C1y a MISMATCHED proposition fails through SLICE /1, not through admission"
        (and (eq decision :refused)
             (member (premise-admission-base-disposition (admission-0 r))
                     '(:missing :mismatched)))
        (format nil "slice /1 said ~S" (premise-admission-base-disposition (admission-0 r)))))

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-dbasis*)
           :receiver (lisp-plus-slice0:receiver-context
                      :context-id :s2-desk :accessible-supports '()))
  (declare (ignore claim))
  (s2ok "C1z an INACCESSIBLE derivation basis stays inaccessible — admission cannot reach past it"
        (and (eq decision :refused)
             (not (eq :satisfied (premise-admission-disposition (admission-0 r)))))
        (format nil "slice /1 ~S ; slice /2 ~S"
                (premise-admission-base-disposition (admission-0 r))
                (premise-admission-disposition (admission-0 r)))))

(multiple-value-bind (r claim decision)
    (run/2 (composed-schema (dbasis-contract)) (composed-conclusion)
           (list *c1-dbasis*
                 (lisp-plus-slice0:witness
                  :for (account-conclusion) :mode :direct :kind :courier-ledger
                  :source :desk :polarity :refutes)))
  (declare (ignore claim))
  (s2ok "C1aa REFUTATION retains precedence over an admitted derivation basis"
        (and (eq decision :refused)
             (eq :refuted (premise-admission-disposition (admission-0 r))))
        "a contract can refuse to let something HELP, never let something stop HURTING"))

;;; --- C1.7  finite composition: three stages -------------------------

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :twice-composed :version 1
  :conclusion (pp '(:predicate :twice-composed (:volume (:var :volume))))
  :premises (list (pp '(:predicate :composed-standing (:volume (:var :volume)))))))

(multiple-value-bind (r2 claim2 decision2 dbasis-b)
    (run/2* (composed-schema (dbasis-contract)) (composed-conclusion)
            (list *c1-dbasis*))
  (declare (ignore r2 claim2))
  (multiple-value-bind (r3 claim3 decision3)
      (run/2 (make-slice2-schema
              :schema-id :twice-composed/2
              :base-schema (lisp-plus-slice1:resolve-schema :twice-composed 1)
              :premise-contracts (list (list 0 (dbasis-contract :id :hop-3))))
             (np '(:predicate :twice-composed (:volume "codex-9")))
             (list dbasis-b))
    (declare (ignore claim3))
    (s2ok "C1ab THREE STAGES COMPOSE — source basis -> claim+A -> claim+B -> a premise taking B"
          (and (eq decision2 :granted) (derivation-basis-p dbasis-b)
               (eq decision3 :granted)
               (eq :satisfied (premise-admission-disposition (admission-0 r3))))
          "finite composition, demonstrated — not a generic proof-graph framework")
    (s2ok "C1ac and the chain is walkable to the ORIGINAL source basis without a resolver"
          (let* ((b3 (first (slice2-receipt-derivation-bases-used r3)))
                 (r2* (derivation-basis-receipt b3))
                 (b2 (first (slice2-receipt-derivation-bases-used r2*)))
                 (r1* (derivation-basis-receipt b2))
                 (sb (first (slice2-receipt-source-bases-used r1*))))
            (and (source-basis-p sb) (eq sb *c1-basis*)))
          "hop 3 -> hop 2 -> hop 1 -> the Core /0 account report, by object")))

;;; --- C1.8  TWO PLANTED FAULTS.  A tooth that has never bitten is a docstring.

(format t "~%-- C1 negative controls: two planted faults --~%")

(let ((real-fn #'derivation-basis-established-in-current-image-p)
      (fabricated (%make-derivation-basis
                   :identity (lisp-plus-slice0:claim-id *c1-claim*)
                   :version 0 :species :slice2-derivation
                   :claim *c1-claim* :receipt *c1-receipt*
                   :proposition (lisp-plus-slice0:claim-proposition *c1-claim*)
                   :schema-id (slice2-receipt-schema-id *c1-receipt*)
                   :schema-version (slice2-receipt-schema-version *c1-receipt*)
                   :origin-context (slice2-receipt-origin-context *c1-receipt*)
                   :truth-ceiling +derivation-basis-truth-ceiling+))
      (blinded nil) (restored nil))
  ;; FAULT 1 — remove the current-image establishment conjunct.
  (setf (fdefinition 'derivation-basis-established-in-current-image-p)
        (lambda (b) (and (derivation-basis-p b) t)))
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion) (list fabricated))
    (declare (ignore claim r))
    (setf blinded (eq decision :granted)))
  (setf (fdefinition 'derivation-basis-established-in-current-image-p) real-fn)
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion) (list fabricated))
    (declare (ignore claim))
    (setf restored (and (eq decision :refused)
                        (eq :not-admitted
                            (premise-admission-disposition (admission-0 r))))))
  (s2ok "NC3 with the ESTABLISHMENT conjunct removed, a coherent unminted basis is ADMITTED"
        blinded
        "the tooth is measuring provenance, not coherence")
  (s2ok "NC4 with the conjunct restored, the same basis is REFUSED :NOT-ADMITTED"
        restored))

(let ((real-fn #'%admits-claim-p) (blinded nil) (restored nil))
  ;; FAULT 2 — let the carrier be accepted as a naked judged claim.
  (setf (fdefinition '%admits-claim-p) (lambda (contract claim)
                                         (declare (ignore contract claim)) t))
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion) (list *c1-claim*))
    (declare (ignore claim r))
    (setf blinded (eq decision :granted)))
  (setf (fdefinition '%admits-claim-p) real-fn)
  (multiple-value-bind (r claim decision)
      (run/2 (composed-schema (dbasis-contract)) (composed-conclusion) (list *c1-claim*))
    (declare (ignore claim))
    (setf restored (and (eq decision :refused)
                        (eq :not-admitted
                            (premise-admission-disposition (admission-0 r))))))
  (s2ok "NC5 with the NAKED-CLAIM road opened, the bare granted claim discharges a derivation-bound premise"
        blinded
        "which is exactly the impersonation [IX-10] left possible")
  (s2ok "NC6 with the road closed again, the bare claim is REFUSED :NOT-ADMITTED"
        restored))

;;; ==================================================================
;;; Tally + exit.

(format t "~%== Language Slice /2 teeth: ~D passed / ~D failed ==~%" *s2pass* *s2fail*)
(format t "(self-consistency certification — image-local only; no durability, ~
cross-image, serialization, or cryptographic claim, and no evidence that any ~
external deed occurred)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *s2fail*) 0 1))
