;;;; slice0.lisp — Lisp+ Slice /0 substrate: checked evidential promotion.
;;;;
;;;; Governed by LANGUAGE-SLICE-0-CHARTER.md (this directory).  Public forms:
;;;;   (claim ...)  (witness ...)  (raise ...)  (why ...)
;;;; plus promotion-procedure, promotion-receipt, the Slice /0 condition
;;;; families, and WITH-SLICE0-RESTARTS.
;;;;
;;;; Builds ON kernel0 (never edits it): durable identities, the canonical
;;;; proposition boundary, and the procedure-descriptor judgment-class law are
;;;; kernel0's; the condition layer is PARALLEL, not a subtype, because
;;;; kernel0-condition's initializer enforces the frozen 7-name restart
;;;; whitelist on the PERMITTED-RESTARTS slot (conditions.lisp:211-216) and
;;;; none of the seven fits claim promotion (charter §9, inventory Q4/M5).
;;;;
;;;; Ordering discipline (charter §4, Q8): constitutive order is a
;;;; deterministic per-image ordinal.  Wall-clock fields on witnesses
;;;; (:produced-at etc.) are testified evidence, never trusted ordering.

(unless (find-package :lisp-plus-kernel0)
  (load (merge-pathnames "../kernel0/load.lisp" *load-truename*)))

(defpackage #:lisp-plus-slice0
  (:use #:cl)
  (:import-from #:lisp-plus-kernel0
                #:make-identity
                #:identity=
                #:durable-identity
                #:durable-identity-p
                #:durable-identity-domain
                #:durable-identity-name
                #:require-canonical
                #:procedure-descriptor
                #:procedure-descriptor-p
                #:make-procedure-descriptor
                #:procedure-descriptor-procedure-id
                #:procedure-descriptor-version
                #:procedure-descriptor-judgment-class)
  (:export
   ;; public forms
   #:claim #:witness #:raise #:why #:render-why
   ;; claim object
   #:claim-p #:claim-id #:claim-proposition #:claim-commitment
   #:claim-asserted-by #:claim-judgment #:claim-lineage #:claim-ordinal
   ;; witness object
   #:witness-p #:witness-id #:witness-for #:witness-mode #:witness-kind
   #:witness-source #:witness-procedure #:witness-content #:witness-polarity
   #:witness-produced-at #:witness-observed-at #:witness-valid-through
   #:witness-transmissible #:witness-accessible-to #:witness-ordinal
   ;; promotion procedure (kernel0 descriptor + slice admissibility)
   #:promotion-procedure #:promotion-procedure-p
   #:promotion-procedure-descriptor #:promotion-procedure-admits
   ;; judgment record
   #:judgment-record-p #:judgment-record-judgment #:judgment-record-procedure-id
   #:judgment-record-procedure-version #:judgment-record-support-ids
   #:judgment-record-receiver #:judgment-record-ordinal
   ;; promotion receipt
   #:promotion-receipt-p #:promotion-receipt-claim-before
   #:promotion-receipt-requested-judgment
   #:promotion-receipt-supports-considered #:promotion-receipt-procedure
   #:promotion-receipt-decision #:promotion-receipt-claim-after
   #:promotion-receipt-residue #:promotion-receipt-explanation
   ;; why object
   #:why-p #:why-decision #:why-condition-ids #:why-requirement-ids
   #:why-failed-relations #:why-offending-fields #:why-supports-considered
   #:why-strongest-lawful-result #:why-available-repairs
   ;; conditions
   #:slice0-condition #:slice0-condition-failed-invariant
   #:slice0-condition-requirement-id #:slice0-condition-offending-field
   #:slice0-condition-offending-value #:slice0-condition-permitted-restarts
   #:slice0-condition-receipt #:slice0-condition-why
   #:malformed-slice0-shape
   #:unsupported-promotion #:wrong-proposition-support
   #:insufficient-support-kind #:inadmissible-procedure
   #:receiver-cannot-access-support #:testimony-impossible
   #:signal-slice0 #:with-slice0-restarts
   ;; lawful restart names
   #:retain-current-claim #:seek-matching-support
   #:construct-attribution-claim #:defer-judgment #:retarget-receiver
   #:mark-testimony-impossible))

(in-package #:lisp-plus-slice0)

;;; ------------------------------------------------------------------
;;; Deterministic ordinal (constitutive order; §13.2-style, no wall clock)

(defvar *slice0-ordinal* 0)

(defun %next-ordinal ()
  (incf *slice0-ordinal*))

;;; ------------------------------------------------------------------
;;; Slice /0 condition layer — PARALLEL to kernel0's (charter §9).

(defparameter *slice0-restart-names*
  '(retain-current-claim
    seek-matching-support
    construct-attribution-claim
    defer-judgment
    retarget-receiver
    mark-testimony-impossible))

(defun %slice0-restart-name-p (name)
  (member name *slice0-restart-names* :test #'eq))

(define-condition slice0-condition (error)
  ((failed-invariant :initarg :failed-invariant
                     :reader slice0-condition-failed-invariant)
   (requirement-id :initarg :requirement-id :initform nil
                   :reader slice0-condition-requirement-id)
   (offending-field :initarg :offending-field :initform nil
                    :reader slice0-condition-offending-field)
   (offending-value :initarg :offending-value :initform nil
                    :reader slice0-condition-offending-value)
   (permitted-restarts :initarg :permitted-restarts :initform nil
                       :reader slice0-condition-permitted-restarts)
   ;; the attempted transition, preserved even in refusal (charter §8)
   (receipt :initarg :receipt :initform nil
            :reader slice0-condition-receipt)
   ;; the structured explanation (charter §10)
   (why :initarg :why :initform nil :reader slice0-condition-why))
  (:report (lambda (c stream)
             (format stream "~A: ~A"
                     (type-of c) (slice0-condition-failed-invariant c)))))

;; NOTE (execution-verified, PROBE brief 2026-07-22): an INITIALIZE-INSTANCE
;; :AFTER guard on a condition class is INERT under SBCL 2.4.6's
;; MAKE-CONDITION — kernel0's own §20.1 guard was proven not to run.  A guard
;; that never runs is a conclusion wearing a check's costume, so this layer
;; defines none: ALL contract enforcement lives in SIGNAL-SLICE0 (the one
;; live signalling path) and in WITH-SLICE0-RESTARTS (macroexpansion-time).

(macrolet ((families (&rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (slice0-condition) ())))))
  (families malformed-slice0-shape
            unsupported-promotion
            wrong-proposition-support
            insufficient-support-kind
            inadmissible-procedure
            receiver-cannot-access-support
            testimony-impossible))

(defun signal-slice0 (condition-type &rest initargs
                      &key failed-invariant permitted-restarts
                      &allow-other-keys)
  (unless (and (stringp failed-invariant) (plusp (length failed-invariant)))
    (error "slice0 condition contract: FAILED-INVARIANT must be a non-empty string"))
  (unless (subtypep condition-type 'slice0-condition)
    (error "slice0 condition contract: ~S is not a slice0-condition" condition-type))
  (unless (and (listp permitted-restarts)
               (every #'%slice0-restart-name-p permitted-restarts))
    (error "slice0 condition contract: PERMITTED-RESTARTS must use only charter §9 names, got ~S"
           permitted-restarts))
  (error (apply #'make-condition condition-type initargs)))

(defmacro with-slice0-restarts (clauses &body body)
  "RESTART-CASE limited to the charter §9 lawful names.  CONTINUE-ANYWAY,
blind RETRY, and arbitrary standing assignment are not expressible through
this vocabulary by well-formed programs.  Sizing (charter §9, IANUS audit):
the whitelist is package state, mutable by any loaded code — this is
surface discipline, not host closure."
  (dolist (clause clauses)
    (unless (and (consp clause) (%slice0-restart-name-p (car clause)))
      (error "restart clause not permitted by charter §9: ~S" clause)))
  `(restart-case (progn ,@body) ,@clauses))

(defun %shape-error (field value invariant &rest more)
  (signal-slice0 'malformed-slice0-shape
                 :failed-invariant (apply #'format nil invariant more)
                 :offending-field field
                 :offending-value value))

;;; ------------------------------------------------------------------
;;; Proposition boundary.
;;; A proposition is an s-expression of KEYWORDS / STRINGS / INTEGERS /
;;; proper lists thereof — exactly the vocabulary kernel0's canonical
;;; boundary admits (REQUIRE-CANONICAL; execution-verified: bare non-keyword
;;; symbols and floats are refused by CD/0, so they are refused here too
;;; rather than laundered through a string conversion — stored-form EQUAL
;;; and canonical EQUAL-DATUM equality then agree).

(defun %require-proposition (value field)
  (labels ((walk (v)
             (cond ((consp v) (mapc #'walk v))
                   ((or (stringp v) (integerp v) (keywordp v))
                    (require-canonical v))
                   (t (%shape-error
                       field v
                       "proposition parts must be keywords, strings, integers, or proper lists (bare symbols do not cross the canonical boundary); got ~S"
                       v)))))
    (walk value)
    value))

(defun proposition= (a b)
  (equal a b))

(defun %attribution-proposition-p (p)
  "True when P has the second-order attribution shape (:asserted SOURCE Q)."
  (and (consp p)
       (eq (first p) :asserted)
       (= (length p) 3)))

;;; ------------------------------------------------------------------
;;; WHY — one structured explanation object for granted AND refused
;;; transitions (charter §10).  Reason-law: refused => >=1 failed relation;
;;; granted => procedure + supports named.

(defstruct (why (:constructor %make-why) (:copier nil))
  (decision nil :read-only t)              ; :granted | :refused
  (condition-ids nil :read-only t)         ; condition type names, if refused
  (requirement-ids nil :read-only t)       ; charter requirement keywords
  (failed-relations nil :read-only t)      ; (relation-name . detail) alist
  (offending-fields nil :read-only t)
  (supports-considered nil :read-only t)   ; witness ids
  (strongest-lawful-result nil :read-only t)
  (available-repairs nil :read-only t))    ; subset of *slice0-restart-names*

(defun %why (&rest args &key decision failed-relations supports-considered
                             procedure &allow-other-keys)
  (ecase decision
    (:refused
     (unless failed-relations
       (%shape-error :failed-relations nil
                     "reason-law: a refused why MUST carry >=1 failed relation")))
    (:granted
     (unless (and procedure supports-considered)
       (%shape-error :procedure procedure
                     "reason-law: a granted why MUST name its procedure and supports"))))
  (let ((clean (copy-list args)))
    (remf clean :procedure)
    (apply #'%make-why clean)))




;;; ------------------------------------------------------------------
;;; WITNESS — first-class support record (charter §4, Q2).
;;; Level discipline enforced AT CONSTRUCTION (charter §6): a :testimony
;;; witness's :for MUST be the second-order attribution (:asserted S P).
;;; Flattened testimony is unrepresentable, not merely refused later.

(defstruct (witness (:constructor %make-witness) (:copier nil))
  (id nil :read-only t)
  (for nil :read-only t)                   ; proposition supported
  (mode nil :read-only t)                  ; :direct | :testimony | :derivation
  (kind nil :read-only t)                  ; :execution :exit-status :transcript
                                           ; :parse :observation :report ...
  (source nil :read-only t)
  (procedure nil :read-only t)             ; producing procedure id, if any
  (content nil :read-only t)
  (polarity :supports :read-only t)        ; :supports | :refutes
  (produced-at nil :read-only t)           ; testified, never trusted order
  (observed-at nil :read-only t)
  (valid-through nil :read-only t)
  (transmissible t :read-only t)           ; declared; de-infando enforces
  (accessible-to :all :read-only t)        ; :all | list of receiver keys
  (ordinal nil :read-only t))

(defun witness (&key for mode kind source procedure content
                     (polarity :supports)
                     produced-at observed-at valid-through
                     (transmissible t) (accessible-to :all))
  (unless for (%shape-error :for nil "a witness MUST name the proposition it is for"))
  (unless (member mode '(:direct :testimony :derivation))
    (%shape-error :mode mode "witness :mode must be :direct, :testimony, or :derivation"))
  (unless (keywordp kind)
    (%shape-error :kind kind "witness :kind must be a keyword"))
  (unless source (%shape-error :source nil "a witness MUST name its source"))
  (unless (member polarity '(:supports :refutes))
    (%shape-error :polarity polarity "witness :polarity must be :supports or :refutes"))
  (%require-proposition for :for)
  (when (and (eq mode :testimony) (not (%attribution-proposition-p for)))
    (signal-slice0 'malformed-slice0-shape
                   :failed-invariant
                   (format nil "testimony level discipline (charter §6): a ~
:testimony witness supports the attribution (:asserted SOURCE P), never P ~
itself; got :for ~S — construct the attribution, or supply :direct evidence"
                           for)
                   :requirement-id :testimony-preserves-proposition-level
                   :offending-field :for
                   :offending-value for))
  (let ((n (%next-ordinal)))
    (%make-witness
     :id (make-identity :receipt (format nil "witness-~D" n))
     :for for :mode mode :kind kind :source source :procedure procedure
     :content content :polarity polarity
     :produced-at produced-at :observed-at observed-at
     :valid-through valid-through
     :transmissible transmissible :accessible-to accessible-to
     :ordinal n)))

(defun %witness-accessible-p (w receiver)
  (or (null receiver)
      (eq (witness-accessible-to w) :all)
      (member receiver (witness-accessible-to w) :test #'eql)))

;;; ------------------------------------------------------------------
;;; JUDGMENT RECORD — a judgment exists only bound to its procedure.

(defstruct (judgment-record (:constructor %make-judgment-record) (:copier nil))
  (judgment nil :read-only t)              ; :verified | :refuted
  (procedure-id nil :read-only t)
  (procedure-version nil :read-only t)
  (support-ids nil :read-only t)
  (receiver nil :read-only t)              ; nil = receiver-unqualified
  (ordinal nil :read-only t))

;;; ------------------------------------------------------------------
;;; CLAIM — commitment is historical; judgment arrives only via RAISE.
;;; The public constructor cannot mint a judgment: there is no :judgment
;;; keyword on CLAIM, and every slot is read-only (no public mutation
;;; surface — official test 5).

(defstruct (claim (:constructor %make-claim) (:copier nil))
  (id nil :read-only t)
  (proposition nil :read-only t)
  (commitment :asserted :read-only t)      ; the historical act, never rewritten
  (asserted-by nil :read-only t)
  (judgment nil :read-only t)              ; judgment-record or nil
  (lineage nil :read-only t)               ; (predecessor-claim-id receipt-id)
  (ordinal nil :read-only t))

(defun claim (&key proposition by)
  (unless proposition
    (%shape-error :proposition nil "a claim MUST carry a proposition"))
  (unless by
    (%shape-error :by nil "a claim MUST name its asserting principal"))
  (%require-proposition proposition :proposition)
  (let ((n (%next-ordinal)))
    (%make-claim
     :id (make-identity :claim (format nil "claim-~D" n))
     :proposition proposition
     :commitment :asserted
     :asserted-by by
     :judgment nil
     :lineage nil
     :ordinal n)))

;;; ------------------------------------------------------------------
;;; PROMOTION PROCEDURE — kernel0 procedure-descriptor (identity, version,
;;; judgment-class law) + the slice's admissibility vocabulary: which
;;; (mode kind) pairs this procedure admits as support.

(defstruct (promotion-procedure (:constructor %make-promotion-procedure)
                                (:copier nil))
  (descriptor nil :read-only t)            ; kernel0 procedure-descriptor
  (admits nil :read-only t))               ; list of (mode kind) pairs

(defun promotion-procedure (&key descriptor admits)
  (unless (procedure-descriptor-p descriptor)
    (%shape-error :descriptor descriptor
                  "promotion-procedure requires a kernel0 procedure-descriptor"))
  (dolist (pair admits)
    (unless (and (consp pair) (= (length pair) 2)
                 (member (first pair) '(:direct :testimony :derivation))
                 (keywordp (second pair)))
      (%shape-error :admits pair "each admitted pair must be (MODE KIND)")))
  (%make-promotion-procedure :descriptor descriptor :admits admits))

(defun %procedure-semantic-p (proc)
  (eq (procedure-descriptor-judgment-class
       (promotion-procedure-descriptor proc))
      :semantic))

(defun %procedure-admits-p (proc w)
  (member (list (witness-mode w) (witness-kind w))
          (promotion-procedure-admits proc)
          :test #'equal))

;;; ------------------------------------------------------------------
;;; PROMOTION RECEIPT — issued on EVERY attempt (charter §8, Q3).

(defstruct (promotion-receipt (:constructor %make-promotion-receipt)
                              (:copier nil))
  (claim-before nil :read-only t)
  (requested-judgment nil :read-only t)
  (supports-considered nil :read-only t)
  (procedure nil :read-only t)
  (decision nil :read-only t)              ; :granted | :refused
  (claim-after nil :read-only t)           ; nil when refused
  (residue nil :read-only t)               ; plist: :current-judgment, :deferred...
  (explanation nil :read-only t)           ; why object
  (ordinal nil :read-only t))

(defun %id-name (id)
  (if (durable-identity-p id) (durable-identity-name id) id))

(defun why (object)
  "Extract the structured explanation from a receipt or a slice0 condition."
  (etypecase object
    (why object)
    (slice0-condition (or (slice0-condition-why object)
                          (%shape-error :why object "condition carries no why")))
    (promotion-receipt (promotion-receipt-explanation object))))

(defun render-why (w &optional (stream t))
  "Prose derived from structure — never invented past the fields."
  (let ((w (why w)))
    (format stream "~&[~A]" (why-decision w))
    (when (why-supports-considered w)
      (format stream " considered ~{~A~^, ~}"
              (mapcar #'%id-name (why-supports-considered w))))
    (dolist (fr (why-failed-relations w))
      (format stream "~%  missing relation: ~A — ~A" (car fr) (cdr fr)))
    (when (why-requirement-ids w)
      (format stream "~%  requirements: ~{~S~^ ~}" (why-requirement-ids w)))
    (when (why-strongest-lawful-result w)
      (format stream "~%  strongest lawful result: ~S"
              (why-strongest-lawful-result w)))
    (when (why-available-repairs w)
      (format stream "~%  lawful repairs: ~{~A~^, ~}" (why-available-repairs w)))
    (terpri stream)
    w))


(defun %receipt-with-residue (receipt extra)
  (%make-promotion-receipt
   :claim-before (promotion-receipt-claim-before receipt)
   :requested-judgment (promotion-receipt-requested-judgment receipt)
   :supports-considered (promotion-receipt-supports-considered receipt)
   :procedure (promotion-receipt-procedure receipt)
   :decision (promotion-receipt-decision receipt)
   :claim-after (promotion-receipt-claim-after receipt)
   :residue (append extra (promotion-receipt-residue receipt))
   :explanation (promotion-receipt-explanation receipt)
   :ordinal (%next-ordinal)))

(defun %repairs-for (condition-type)
  (case condition-type
    (unsupported-promotion
     '(retain-current-claim seek-matching-support defer-judgment))
    (wrong-proposition-support
     '(retain-current-claim seek-matching-support
       construct-attribution-claim defer-judgment))
    (insufficient-support-kind
     '(retain-current-claim seek-matching-support defer-judgment))
    (inadmissible-procedure
     '(retain-current-claim defer-judgment))
    (receiver-cannot-access-support
     '(retain-current-claim retarget-receiver defer-judgment))
    (testimony-impossible
     '(retain-current-claim mark-testimony-impossible defer-judgment))
    (t '(retain-current-claim))))

(defun %refuse (the-claim to per considering condition-type
                failed-relations requirement-ids offending
                &key strongest residue)
  (let* ((repairs (%repairs-for condition-type))
         (w (%why :decision :refused
                  :condition-ids (list condition-type)
                  :requirement-ids requirement-ids
                  :failed-relations failed-relations
                  :offending-fields (mapcar #'car offending)
                  :supports-considered (mapcar #'witness-id considering)
                  :strongest-lawful-result strongest
                  :available-repairs repairs))
         (receipt (%make-promotion-receipt
                   :claim-before the-claim
                   :requested-judgment to
                   :supports-considered (mapcar #'witness-id considering)
                   :procedure per
                   :decision :refused
                   :claim-after nil
                   :residue residue
                   :explanation w
                   :ordinal (%next-ordinal))))
    (signal-slice0 condition-type
                   :failed-invariant
                   (format nil "~{~A: ~A~^; ~}"
                           (loop for (rel . detail) in failed-relations
                                 append (list rel detail)))
                   :requirement-id (first requirement-ids)
                   :offending-field (caar offending)
                   :offending-value (cdar offending)
                   :permitted-restarts repairs
                   :receipt receipt
                   :why w)))

;;; ------------------------------------------------------------------
;;; RAISE — the checked act (charter §7).

(defun %evaluate-promotion (the-claim to per considering receiver)
  (let* ((p (claim-proposition the-claim))
         (matching (remove-if-not
                    (lambda (w) (proposition= (witness-for w) p))
                    considering))
         (mismatched (set-difference considering matching)))
    ;; 0. no support at all
    (when (null considering)
      (%refuse the-claim to per considering 'unsupported-promotion
               `((:supports-present . "no witness was offered for this promotion"))
               '(:supports-present)
               `((:considering . nil))))
    ;; 3. procedure authority: judgments need a :semantic procedure
    ;;    (kernel0 K0E-25 wall, one level up)
    (unless (%procedure-semantic-p per)
      (%refuse the-claim to per considering 'inadmissible-procedure
               `((:procedure-authority .
                  ,(format nil "~S requires a :semantic procedure; ~A is :structural — ~
structural execution evidence cannot license semantic acceptance"
                           to
                           (%id-name (procedure-descriptor-procedure-id
                                      (promotion-procedure-descriptor per))))))
               '(:semantic-judgment-requires-semantic-procedure)
               `((:per . ,(procedure-descriptor-judgment-class
                           (promotion-procedure-descriptor per))))))
    ;; 1. proposition match — a warrant for Q cannot promote P
    (when (null matching)
      (let* ((testimony (find :testimony mismatched :key #'witness-mode))
             (strongest
               (when testimony
                 `(:claim (:proposition ,(witness-for testimony)
                           :commitment :asserted)))))
        (%refuse the-claim to per considering
                 (if testimony 'wrong-proposition-support
                     'wrong-proposition-support)
                 (loop for w in mismatched
                       collect
                       (cons :proposition-match
                             (format nil "~A is for ~S, not for ~S~A"
                                     (%id-name (witness-id w))
                                     (witness-for w) p
                                     (if (eq (witness-mode w) :testimony)
                                         " (testimony supports the attribution, never P itself)"
                                         ""))))
                 '(:witness-for-must-equal-claim-proposition)
                 (loop for w in mismatched
                       collect (cons :for (witness-for w)))
                 :strongest strongest)))
    ;; 2. mode/kind admissibility under the procedure
    (let ((admissible (remove-if-not
                       (lambda (w) (%procedure-admits-p per w))
                       matching)))
      (when (null admissible)
        (%refuse the-claim to per considering 'insufficient-support-kind
                 (loop for w in matching
                       collect
                       (cons :support-kind-admissible
                             (format nil "~A is (~S ~S); procedure admits only ~S"
                                     (%id-name (witness-id w))
                                     (witness-mode w) (witness-kind w)
                                     (promotion-procedure-admits per))))
                 '(:procedure-admits-mode-kind)
                 (loop for w in matching
                       collect (cons :kind (list (witness-mode w)
                                                 (witness-kind w))))))
      ;; 4. receiver admissibility
      (when receiver
        (let ((unreachable (remove-if
                            (lambda (w) (%witness-accessible-p w receiver))
                            admissible)))
          (when (= (length unreachable) (length admissible))
            (%refuse the-claim to per considering
                     'receiver-cannot-access-support
                     (loop for w in unreachable
                           collect
                           (cons :receiver-can-access-support
                                 (format nil "~A is not accessible to receiver ~S"
                                         (%id-name (witness-id w)) receiver)))
                     '(:receiver-accessibility)
                     `((:receiver . ,receiver))))
          (setf admissible
                (remove-if-not
                 (lambda (w) (%witness-accessible-p w receiver))
                 admissible))))
      ;; 5. polarity — refuting support refuses :verified and records the
      ;;    refuting judgment WITHOUT erasing the assertion (charter §5, Q7)
      (let ((refuting (remove-if-not
                       (lambda (w) (eq (witness-polarity w) :refutes))
                       admissible))
            (supporting (remove-if-not
                         (lambda (w) (eq (witness-polarity w) :supports))
                         admissible)))
        (when (and (eq to :verified) refuting (null supporting))
          (%refuse the-claim to per considering 'unsupported-promotion
                   `((:supporting-polarity .
                      ,(format nil "all admissible support REFUTES ~S; the assertion ~
stands, the refutation is recorded, and :verified is not grantable" p)))
                   '(:supports-must-not-all-refute)
                   `((:polarity . :refutes))
                   :strongest `(:raise (:to :refuted))
                   :residue `(:original-commitment :asserted
                              :requested-judgment ,to
                              :decision :refused
                              :current-judgment :refuted)))
        (when (and (eq to :refuted) supporting (null refuting))
          (%refuse the-claim to per considering 'unsupported-promotion
                   `((:refuting-polarity .
                      ,(format nil "all admissible support SUPPORTS ~S; :refuted is not grantable" p)))
                   '(:refutation-needs-refuting-support)
                   `((:polarity . :supports))))
        ;; GRANT
        (let* ((load-bearing (if (eq to :refuted) refuting supporting))
               (n (%next-ordinal))
               (jr (%make-judgment-record
                    :judgment to
                    :procedure-id (procedure-descriptor-procedure-id
                                   (promotion-procedure-descriptor per))
                    :procedure-version (procedure-descriptor-version
                                        (promotion-procedure-descriptor per))
                    :support-ids (mapcar #'witness-id load-bearing)
                    :receiver receiver
                    :ordinal n))
               (w (%why :decision :granted
                        :procedure per
                        :requirement-ids '(:all-charter-s7-relations-held)
                        :supports-considered (mapcar #'witness-id load-bearing)
                        :strongest-lawful-result to))
               (revision (%make-claim
                          :id (make-identity
                               :claim (format nil "claim-~D" n))
                          :proposition p
                          :commitment (claim-commitment the-claim)
                          :asserted-by (claim-asserted-by the-claim)
                          :judgment jr
                          :lineage (list (claim-id the-claim))
                          :ordinal n))
               (receipt (%make-promotion-receipt
                         :claim-before the-claim
                         :requested-judgment to
                         :supports-considered (mapcar #'witness-id load-bearing)
                         :procedure per
                         :decision :granted
                         :claim-after revision
                         :residue (unless receiver
                                    '(:receiver-unqualified t))
                         :explanation w
                         :ordinal (%next-ordinal))))
          (values revision receipt))))))

(defun %raise-1 (the-claim to per considering receiver)
  (with-slice0-restarts
      ((retain-current-claim (receipt)
         (values nil receipt))
       (seek-matching-support (more-witnesses)
         (%raise-1 the-claim to per
                   (append considering more-witnesses) receiver))
       (construct-attribution-claim (testimony-witness receipt)
         (values (claim :proposition (witness-for testimony-witness)
                        :by (witness-source testimony-witness))
                 receipt))
       (defer-judgment (receipt)
         (values nil (%receipt-with-residue receipt '(:deferred t))))
       (retarget-receiver (new-receiver)
         (%raise-1 the-claim to per considering new-receiver))
       (mark-testimony-impossible (receipt)
         (values nil (%receipt-with-residue
                      receipt '(:testimony-impossible t)))))
    (%evaluate-promotion the-claim to per considering receiver)))

(defun raise (the-claim &key to per considering receiver)
  "Request that THE-CLAIM be promoted to judgment TO (:verified or :refuted)
by procedure PER, on the strength of the CONSIDERING witnesses, admissible to
RECEIVER (nil = receiver-unqualified).

Grants: returns (values new-claim-revision promotion-receipt); the original
claim is untouched, the revision's lineage names it.

Refuses: signals a typed slice0-condition carrying the refusal receipt and a
structured why, with the charter §9 lawful restarts established:
  RETAIN-CURRENT-CLAIM        -> (values nil refusal-receipt)
  SEEK-MATCHING-SUPPORT (ws)  -> re-evaluate with additional witnesses
  CONSTRUCT-ATTRIBUTION-CLAIM -> (values attribution-claim refusal-receipt)
  DEFER-JUDGMENT              -> (values nil receipt) with :deferred residue
  RETARGET-RECEIVER (r)       -> re-evaluate for receiver R
  MARK-TESTIMONY-IMPOSSIBLE   -> (values nil receipt) with residue recorded"
  (unless (claim-p the-claim)
    (%shape-error :claim the-claim "RAISE requires a claim"))
  (unless (member to '(:verified :refuted))
    (%shape-error :to to "RAISE :to must be :verified or :refuted"))
  (unless (promotion-procedure-p per)
    (%shape-error :per per "RAISE requires a promotion-procedure as :per"))
  (%raise-1 the-claim to per considering receiver))

