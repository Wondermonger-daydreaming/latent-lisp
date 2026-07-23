;;;; slice0-transmissibility.lisp — Slice /0: what can exist, act, and
;;;; warrant locally without becoming an object that may be carried away.
;;;;
;;;; de-infando substrate (WORK-ORDER-0 slate item 3), under the R3 ceiling:
;;;; NO hostile same-image custody, NO debugger resistance, NO cryptographic
;;;; confinement.  The lawful claim: values and capabilities can be
;;;; unavailable through the governed transmission surfaces and exercisable
;;;; only through designated operations.  Arbitrary host `::` access remains
;;;; an acknowledged, twice-measured escape surface — recorded, not solved.
;;;;
;;;; SEMANTIC AXES (orthogonal to evidential standing — NOT a ladder):
;;;;   local existence          — the local-value record exists
;;;;   local usability          — EXERCISE-VALUE succeeds here
;;;;   reifiability             — the canonical boundary itself decides
;;;;                              (REQUIRE-CANONICAL accepts or refuses;
;;;;                              a closure is refused — verified live)
;;;;   direct transmissibility  — reifiable AND declared AND receiver-accepted
;;;;   testimony possibility    — the second-order attribution can travel
;;;;   derived transmissibility — a canonical product travels sans producer
;;;;   receiver reproducibility — a canonical recipe can rebuild equivalents
;;;;   exercisability           — governed invocation, authorization-gated
;;;;
;;;; A support object may be locally strong and directly non-transmissible.
;;;; A mute producer's product may be exportable.  A receiver may mint
;;;; equivalent support without ever holding the original object.

(unless (find-package :lisp-plus-slice0)
  (load (merge-pathnames "slice0-projection.lisp" *load-truename*)))
(unless (fboundp 'lisp-plus-slice0::project-claim)
  (load (merge-pathnames "slice0-projection.lisp" *load-truename*)))

(in-package #:lisp-plus-slice0)

(export '(local-value local-value-p local-value-id local-value-kind
          local-value-authority local-value-exercise-authorized
          local-value-recipe local-value-purpose
          reifiable-p
          derived-result derived-result-p derived-result-id
          derived-result-producer-id derived-result-value
          exercise-value
          transmit transmission-views
          transmission-receipt-p transmission-receipt-subject
          transmission-receipt-subject-kind
          transmission-receipt-source-context
          transmission-receipt-receiver-context
          transmission-receipt-requested-mode
          transmission-receipt-reifiability
          transmission-receipt-testimony-status
          transmission-receipt-derived-results
          transmission-receipt-reproduction-options
          transmission-receipt-exercise-options
          transmission-receipt-blockers transmission-receipt-obligations
          transmission-receipt-decision transmission-receipt-explanation
          ;; conditions (testimony-impossible already exported by slice0)
          value-not-reifiable direct-transmission-impossible
          receiver-representation-unsupported exercise-not-authorized
          reproduction-procedure-unavailable
          ;; lawful repairs
          export-derived-result construct-testimony-claim
          provide-reproduction-recipe exercise-locally
          mint-equivalent-support-at-receiver defer-transmission))

;;; ------------------------------------------------------------------
;;; Governed vocabulary extension — VISIBLE, on purpose.  The restart
;;; whitelist is package state extended by this module at load time.  That
;;; this is possible for any loaded code is part of the escape-surface
;;; honesty this specimen records (EXPECTED-FAILURES §escape): the
;;; whitelist governs well-formed programs, not arbitrary same-image code.

(dolist (name '(export-derived-result construct-testimony-claim
                provide-reproduction-recipe exercise-locally
                mint-equivalent-support-at-receiver defer-transmission))
  (pushnew name *slice0-restart-names*))

(macrolet ((families (&rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (slice0-condition) ())))))
  (families value-not-reifiable
            direct-transmission-impossible
            receiver-representation-unsupported
            exercise-not-authorized
            reproduction-procedure-unavailable))

;;; ------------------------------------------------------------------
;;; Reifiability — the boundary law decides; nothing is stringified.

(defun reifiable-p (host-object)
  "True iff HOST-OBJECT crosses kernel0's canonical boundary as data.
The test IS the boundary: REQUIRE-CANONICAL either accepts or refuses.
A closure is refused (noncanonical-durable-value) — verified live."
  (handler-case (progn (lisp-plus-kernel0:require-canonical host-object) t)
    (lisp-plus-kernel0:kernel0-condition () nil)))

;;; ------------------------------------------------------------------
;;; LOCAL VALUE — existence and usability are local facts.

(defstruct (local-value (:constructor %make-local-value) (:copier nil)
                        (:conc-name %local-value-))
  (id nil :read-only t)
  (host-object nil :read-only t)     ; PRIVATE: accessor not exported.
  (kind nil :read-only t)            ; computed: :closure | :datum
  (authority nil :read-only t)
  (exercise-authorized nil :read-only t)  ; context-ids, or :any
  (recipe nil :read-only t)          ; canonical data, or nil
  (purpose nil :read-only t)
  (ordinal nil :read-only t))

(defun local-value (&key host (kind nil kind-supplied-p) authority
                         exercise-authorized recipe purpose)
  "Admit a host object as a governed local value.  :KIND is COMPUTED from
the object; a caller-supplied :KIND that contradicts the object is refused —
a printed representation of a closure is a string and stays one (the
anti-stringification gate)."
  (unless authority
    (%shape-error :authority nil "a local value MUST name its authority"))
  (let ((computed (cond ((functionp host) :closure)
                        ((reifiable-p host) :datum)
                        (t (%shape-error :host host
                                         "host object is neither a function nor canonical data")))))
    (when (and kind-supplied-p (not (eq kind computed)))
      (signal-slice0 'malformed-slice0-shape
                     :failed-invariant
                     (format nil "declared :kind ~s contradicts the host object ~
(computed ~s) — a stringified closure is a string, not the closure; kind is ~
not a caller claim" kind computed)
                     :requirement-id :kind-is-computed-not-claimed
                     :offending-field :kind
                     :offending-value kind))
    (when recipe (%require-proposition recipe :recipe))
    (%make-local-value
     :id (make-identity :capability (format nil "local-value-~d" (%next-ordinal)))
     :host-object host :kind computed :authority authority
     :exercise-authorized (if (listp exercise-authorized)
                              (copy-list exercise-authorized)
                              exercise-authorized)
     :recipe (when recipe (copy-tree recipe))
     :purpose (if (consp purpose) (copy-tree purpose) purpose)
     :ordinal (%next-ordinal))))

;;; Public accessors — defensive copies (IANUS audit finding 3: returning
;;; the internal lists let an ordinary NCONC on the returned value mutate
;;; authorization state; the public surface now returns copies).

(defun local-value-id (lv) (%local-value-id lv))
(defun local-value-kind (lv) (%local-value-kind lv))
(defun local-value-authority (lv) (%local-value-authority lv))
(defun local-value-purpose (lv)
  (let ((p (%local-value-purpose lv))) (if (consp p) (copy-tree p) p)))
(defun local-value-exercise-authorized (lv)
  (let ((a (%local-value-exercise-authorized lv)))
    (if (listp a) (copy-list a) a)))
(defun local-value-recipe (lv)
  (let ((r (%local-value-recipe lv))) (if (consp r) (copy-tree r) r)))

;;; ------------------------------------------------------------------
;;; DERIVED RESULT — the product travels; the producer does not.

(defstruct (derived-result (:constructor %make-derived-result) (:copier nil))
  (id nil :read-only t)
  (producer-id nil :read-only t)     ; provenance, NOT possession
  (value nil :read-only t)           ; canonical, enforced
  (ordinal nil :read-only t))

;;; ------------------------------------------------------------------
;;; EXERCISE — the governed invocation.  Grants use, never possession:
;;; the caller receives a canonical derived result (and optionally a
;;; freshly minted witness), never the host object.

(defun exercise-value (lv &key in args mint-for (mint-kind :capability-check))
  "Exercise LV in position IN with ARGS.  Authorization-gated.  Returns
(values derived-result witness-or-nil).  The result must itself be
canonical — a closure returning a closure does not launder one out."
  (unless (local-value-p lv)
    (%shape-error :value lv "EXERCISE-VALUE requires a local-value"))
  (unless (receiver-context-p in)
    (%shape-error :in in "EXERCISE-VALUE requires a receiver-context position"))
  (let ((auth (local-value-exercise-authorized lv))
        (ctx (receiver-context-context-id in)))
    (unless (or (eq auth :any) (member ctx auth))
      (signal-slice0 'exercise-not-authorized
                     :failed-invariant
                     (format nil "position ~s is not authorized to exercise ~a ~
(authorized: ~s) — authorization is contextual, not a property of the value"
                             ctx (%id-name (local-value-id lv)) auth)
                     :requirement-id :exercise
                     :offending-field :in
                     :offending-value ctx
                     :permitted-restarts '(defer-transmission)))
    (let ((raw (if (eq (local-value-kind lv) :closure)
                   (apply (%local-value-host-object lv) args)
                   (%local-value-host-object lv))))
      (unless (reifiable-p raw)
        (signal-slice0 'value-not-reifiable
                       :failed-invariant
                       "exercise produced a non-canonical result — a governed invocation may not launder a host object out as its own return value"
                       :requirement-id :reifiability
                       :offending-field :result
                       :offending-value :non-canonical-host-object))
      (let ((dr (%make-derived-result
                 :id (make-identity :receipt
                                    (format nil "derived-~d" (%next-ordinal)))
                 :producer-id (local-value-id lv)
                 :value raw
                 :ordinal (%next-ordinal))))
        (values dr
                (when mint-for
                  (witness :for mint-for :mode :direct :kind mint-kind
                           :source (local-value-authority lv)
                           :content raw)))))))

;;; ------------------------------------------------------------------
;;; TRANSMISSION RECEIPT — structured, issued on every governed attempt.

(defstruct (transmission-receipt (:constructor %make-transmission-receipt)
                                 (:copier nil))
  (subject nil :read-only t)
  (subject-kind nil :read-only t)    ; :closure :datum :derived-result :witness :claim
  (source-context nil :read-only t)
  (receiver-context nil :read-only t)
  (requested-mode nil :read-only t)  ; :direct :testimony :reproduction
  (reifiability nil :read-only t)    ; :reifiable | :not-reifiable | :n/a
  (testimony-status nil :read-only t); :available | :constructed | :impossible | nil
  (derived-results nil :read-only t) ; exportable products on offer
  (reproduction-options nil :read-only t)
  (exercise-options nil :read-only t)
  (blockers nil :read-only t)
  (obligations nil :read-only t)
  (decision nil :read-only t)        ; :granted | :refused
  (explanation nil :read-only t)     ; why object
  (ordinal nil :read-only t))

(defun transmission-views (receipt)
  "Composable descriptions of receipt features — never one status symbol."
  (let ((views '()))
    (when (and (eq (transmission-receipt-decision receipt) :refused)
               (eq (transmission-receipt-requested-mode receipt) :direct))
      (push :direct-export-refused views))
    (when (member (transmission-receipt-testimony-status receipt)
                  '(:available :constructed))
      (push :testimony-available views))
    (when (transmission-receipt-derived-results receipt)
      (push :derived-result-exportable views))
    (when (transmission-receipt-reproduction-options receipt)
      (push :receiver-reproduction-available views))
    (when (and (eq (transmission-receipt-decision receipt) :refused)
               (transmission-receipt-exercise-options receipt))
      (push :local-exercise-only views))
    (nreverse views)))

(defun %subject-kind (subject)
  (etypecase subject
    (local-value (local-value-kind subject))
    (derived-result :derived-result)
    (witness :witness)
    (claim :claim)))

(defun %subject-id (subject)
  (etypecase subject
    (local-value (local-value-id subject))
    (derived-result (derived-result-id subject))
    (witness (witness-id subject))
    (claim (claim-id subject))))

(defun %receiver-accepts-p (to representation)
  (member representation (receiver-context-accepted-representations to)))

;;; ------------------------------------------------------------------
;;; TRANSMIT — the governed act.

(defun %attribution-claim-for (subject)
  "The lawful second-order act: a claim that the authority exercised the
subject — an attribution proposition, never support for any first-order P."
  (etypecase subject
    (local-value
     (claim :proposition (list :asserted (local-value-authority subject)
                               (list :exercised
                                     (%id-name (local-value-id subject))))
            :by (local-value-authority subject)))))

(defun %transmission-repairs (condition-type &key derived reproduction exercise)
  (append (when derived '(export-derived-result))
          '(construct-testimony-claim)
          (when reproduction '(provide-reproduction-recipe))
          (when exercise '(exercise-locally))
          '(mint-equivalent-support-at-receiver defer-transmission)
          (when (eq condition-type 'receiver-representation-unsupported)
            '())))

(defun %refuse-transmission (subject from to mode condition-type
                             axis failed-relations
                             &key reifiability testimony-status derived
                                  reproduction exercise obligations blockers
                                  strongest)
  (let* ((repairs (%transmission-repairs condition-type
                                         :derived derived
                                         :reproduction reproduction
                                         :exercise exercise))
         (w (%why :decision :refused
                  :condition-ids (list condition-type)
                  :requirement-ids (list axis)
                  :failed-relations failed-relations
                  :offending-fields (list axis)
                  :supports-considered (list (%subject-id subject))
                  :strongest-lawful-result strongest
                  :available-repairs repairs))
         (receipt (%make-transmission-receipt
                   :subject subject
                   :subject-kind (%subject-kind subject)
                   :source-context from :receiver-context to
                   :requested-mode mode
                   :reifiability reifiability
                   :testimony-status testimony-status
                   :derived-results (mapcar #'derived-result-id derived)
                   :reproduction-options reproduction
                   :exercise-options exercise
                   :blockers blockers
                   :obligations obligations
                   :decision :refused
                   :explanation w
                   :ordinal (%next-ordinal))))
    (signal-slice0 condition-type
                   :failed-invariant
                   (format nil "~{~A: ~A~^; ~}"
                           (loop for (rel . detail) in failed-relations
                                 append (list rel detail)))
                   :requirement-id axis
                   :offending-field axis
                   :permitted-restarts repairs
                   :receipt receipt
                   :why w)))


(defun %grant-transmission (subject from to mode
                            &key reifiability testimony-status derived
                                 reproduction exercise obligations note)
  (let* ((w (%why :decision :granted
                  :procedure :governed-transmission
                  :requirement-ids (list (or note :all-transmission-relations-held))
                  :supports-considered (list (%subject-id subject))
                  :strongest-lawful-result mode))
         (receipt (%make-transmission-receipt
                   :subject subject :subject-kind (%subject-kind subject)
                   :source-context from :receiver-context to
                   :requested-mode mode
                   :reifiability reifiability
                   :testimony-status testimony-status
                   :derived-results (mapcar #'derived-result-id derived)
                   :reproduction-options reproduction
                   :exercise-options exercise
                   :blockers '() :obligations obligations
                   :decision :granted :explanation w
                   :ordinal (%next-ordinal))))
    receipt))

(defun %evaluate-transmission (subject from to mode derived)
  (let* ((kind (%subject-kind subject))
         (lv-p (local-value-p subject))
         (reify (case kind
                  (:closure :not-reifiable)
                  ((:datum :derived-result) :reifiable)
                  (t :n/a)))
         (reproduction (and lv-p (local-value-recipe subject)
                            (list (local-value-recipe subject))))
         (exercise (and lv-p (local-value-exercise-authorized subject)))
         (testimony (if lv-p :available nil)))
    (ecase mode
      (:testimony
       (let ((attribution (%attribution-claim-for subject)))
         (values attribution
                 (%grant-transmission subject from to :testimony
                  :reifiability reify :testimony-status :constructed
                  :derived derived :reproduction reproduction
                  :exercise exercise
                  :obligations '((:second-order-only
                                  "supports the attribution, never the inner proposition"))
                  :note :testimony-is-second-order))))
      (:reproduction
       (if reproduction
           (values (first reproduction)
                   (%grant-transmission subject from to :reproduction
                    :reifiability reify :testimony-status testimony
                    :derived derived :reproduction reproduction
                    :exercise exercise
                    :obligations '((:equivalence-not-identity
                                    "a rebuilt checker is equivalent support, not the original object"))
                    :note :recipe-travels-as-data))
           (%refuse-transmission subject from to mode
            'reproduction-procedure-unavailable :reproduction
            `((:reproduction-recipe .
               ,(format nil "~a carries no reproduction recipe"
                        (%id-name (%subject-id subject)))))
            :reifiability reify :testimony-status testimony
            :derived derived :exercise exercise
            :blockers `((:reproduction :unavailable))
            :strongest '(:transmit (:mode :testimony)))))
      (:direct
       (cond
         ;; a closure: the boundary law itself refuses — axis :reifiability
         ((eq kind :closure)
          (%refuse-transmission subject from to mode
           'value-not-reifiable :reifiability
           `((:reifiability .
              ,(format nil "~a is a closure over local state; the canonical ~
boundary refuses it (noncanonical-durable-value) — this blocks THIS OBJECT'S ~
export in THIS mode; it does not erase its local existence, forbid its ~
exercise, or foreclose equivalent support at ~s"
                       (%id-name (local-value-id subject))
                       (receiver-context-context-id to))))
           :reifiability :not-reifiable
           :testimony-status :available
           :derived derived :reproduction reproduction :exercise exercise
           :blockers `((:reifiability :not-reifiable
                        :scope (:mode :direct :object-local t)))
           :strongest '(:transmit (:mode :derived-result-or-testimony-or-reproduction))))
         ;; a declared-mute witness: axis is GOVERNANCE, not structure
         ((and (witness-p subject) (not (witness-transmissible subject)))
          (%refuse-transmission subject from to mode
           'direct-transmission-impossible :transmissibility
           `((:declared-transmissibility .
              ,(format nil "~a is declared non-transmissible by its governance; ~
distinct from structural non-reifiability"
                       (%id-name (witness-id subject)))))
           :reifiability :n/a
           :blockers `((:transmissibility :declared-nil
                        :scope (:mode :direct)))
           :strongest '(:transmit (:mode :testimony))))
         ;; receiver representation gate — contextual
         ((not (%receiver-accepts-p to :canonical-datum))
          (%refuse-transmission subject from to mode
           'receiver-representation-unsupported :representation
           `((:accepted-representation .
              ,(format nil "position ~s does not accept :canonical-datum ~
(accepts ~s) — contextual to this receiver, not a property of the subject"
                       (receiver-context-context-id to)
                       (receiver-context-accepted-representations to))))
           :reifiability reify
           :blockers `((:representation :canonical-datum
                        :in-context ,(receiver-context-context-id to)))
           :strongest '(:retarget-receiver)))
         ;; grant — with the honest riders
         (t
          (values subject
                  (%grant-transmission subject from to :direct
                   :reifiability reify :testimony-status testimony
                   :derived derived :reproduction reproduction
                   :exercise exercise
                   :obligations
                   (append
                    (when (eq kind :derived-result)
                      '((:producer-not-included
                         "holding the product is not holding the producer")))
                    (when (eq kind :claim)
                      '((:standing-not-conferred
                         "a claim travels as data; standing at the receiver requires projection/raise")))))))))))
  )

(defun %transmit-1 (subject from to mode derived)
  (with-slice0-restarts
      ((export-derived-result (dr)
         (%transmit-1 dr from to :direct derived))
       (construct-testimony-claim (receipt)
         (values (%attribution-claim-for subject) receipt))
       (provide-reproduction-recipe (receipt)
         (declare (ignore receipt))
         (%transmit-1 subject from to :reproduction derived))
       (exercise-locally (in args receipt)
         (values (exercise-value subject :in in :args args) receipt))
       (mint-equivalent-support-at-receiver (w receipt)
         (values w receipt))
       (defer-transmission (receipt)
         (values nil receipt)))
    (%evaluate-transmission subject from to mode derived)))

(defun transmit (subject &key from to (mode :direct) derived)
  "Attempt to carry SUBJECT from position FROM to position TO under MODE.
Returns (values payload-or-nil transmission-receipt); a refusal SIGNALS a
typed condition carrying the receipt, with lawful repairs established:
  EXPORT-DERIVED-RESULT (dr)          -> transmit the canonical product
  CONSTRUCT-TESTIMONY-CLAIM           -> the second-order attribution claim
  PROVIDE-REPRODUCTION-RECIPE         -> transmit the recipe as data
  EXERCISE-LOCALLY (in args)          -> a governed local invocation
  MINT-EQUIVALENT-SUPPORT-AT-RECEIVER (w) -> receiver-minted support
  DEFER-TRANSMISSION (receipt)        -> record deferral
Each repair is a DIFFERENT lawful act; none relabels a failed direct
export as success."
  (unless (and (receiver-context-p from) (receiver-context-p to))
    (%shape-error :contexts (list from to)
                  "TRANSMIT requires receiver-contexts as :from and :to"))
  (unless (member mode '(:direct :testimony :reproduction))
    (%shape-error :mode mode
                  "TRANSMIT mode must be :direct, :testimony, or :reproduction"))
  (%transmit-1 subject from to mode derived))


;;; Closure-sitting surface ruling: WHY is the one uniform explanation
;;; extractor — this module registers its receipt type.
(push (cons #'transmission-receipt-p #'transmission-receipt-explanation)
      *why-extractors*)
