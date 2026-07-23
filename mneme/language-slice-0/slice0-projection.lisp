;;;; slice0-projection.lisp — Slice /0 receiver-relative claim projection.
;;;;
;;;; de-projectione Session 1 substrate (WORK-ORDER-0 slate item 2), built on
;;;; the settled de-promotione support/promotion algebra in slice0.lisp — NOT
;;;; on the bench probe's scalar standing model (that probe stands as
;;;; inventory evidence only; see de-projectione.lisp banner).
;;;;
;;;; The semantic law under test: a claim projected into another receiver
;;;; context must be RECONSTRUCTED from the support, procedures, authorities,
;;;; and representations available to that receiver.  Changing the receiver
;;;; cannot be implemented as editing a label or copying source standing.
;;;;
;;;; Receiver context is a POSITION, not merely a person.

(unless (find-package :lisp-plus-slice0)
  (load (merge-pathnames "slice0.lisp" *load-truename*)))

(in-package #:lisp-plus-slice0)

(export '(receiver-context receiver-context-p
          receiver-context-context-id receiver-context-accessible-supports
          receiver-context-executable-procedures
          receiver-context-recognized-authorities
          receiver-context-accepted-representations
          support-store
          project-claim projection-views
          projection-receipt-p projection-receipt-source-claim
          projection-receipt-source-context projection-receipt-receiver-context
          projection-receipt-supports-considered
          projection-receipt-supports-accessible
          projection-receipt-supports-inaccessible
          projection-receipt-procedures-available
          projection-receipt-authorities-recognized
          projection-receipt-derived-claims projection-receipt-redactions
          projection-receipt-obligations projection-receipt-blockers
          projection-receipt-ceilings projection-receipt-resulting-claim
          projection-receipt-explanation
          projection-explanation-p render-projection-why
          projection-explanation-source-judgment
          projection-explanation-supports-considered
          projection-explanation-supports-lost
          projection-explanation-supports-retained
          projection-explanation-proposition-transformations
          projection-explanation-procedure-availability
          projection-explanation-authority-recognition
          projection-explanation-representation-blockers
          projection-explanation-resulting-judgment
          projection-explanation-repair-obligations))

;;; ------------------------------------------------------------------
;;; Receiver context — the minimum position model (Task 6 scope).

(defstruct (receiver-context (:constructor %make-receiver-context)
                             (:copier nil))
  (context-id nil :read-only t)
  (accessible-supports nil :read-only t)     ; witness ids (durable)
  (executable-procedures nil :read-only t)   ; promotion-procedures
  (recognized-authorities nil :read-only t)  ; source keys
  (accepted-representations '(:full) :read-only t))

(defun receiver-context (&key context-id accessible-supports
                              executable-procedures recognized-authorities
                              (accepted-representations '(:full)))
  (unless (keywordp context-id)
    (%shape-error :context-id context-id
                  "a receiver context MUST have a keyword :context-id"))
  (dolist (p executable-procedures)
    (unless (promotion-procedure-p p)
      (%shape-error :executable-procedures p
                    "each executable procedure must be a promotion-procedure")))
  (%make-receiver-context
   :context-id context-id
   :accessible-supports accessible-supports
   :executable-procedures executable-procedures
   :recognized-authorities recognized-authorities
   :accepted-representations accepted-representations))

(defun support-store (&rest witnesses)
  "Build an evidence store: identity-key -> witness."
  (let ((h (make-hash-table :test #'equal)))
    (dolist (w witnesses h)
      (setf (gethash (lisp-plus-kernel0:identity-key (witness-id w)) h) w))))

(defun %store-ref (store id)
  (gethash (lisp-plus-kernel0:identity-key id) store))

(defun %context-can-access-p (ctx id)
  (member id (receiver-context-accessible-supports ctx) :test #'identity=))

;;; ------------------------------------------------------------------
;;; Projection explanation — the WHY system extended across projection
;;; (Task 9): a typed extension deriving prose from structure, not a
;;; parallel prose-only explainer.

(defstruct (projection-explanation (:constructor %make-projection-explanation)
                                   (:copier nil))
  (source-judgment nil :read-only t)          ; (:judgment j :procedure id) | nil
  (supports-considered nil :read-only t)      ; ids
  (supports-lost nil :read-only t)            ; (id . reason) alist
  (supports-retained nil :read-only t)        ; ids
  (proposition-transformations nil :read-only t) ; (from to :derived|:underived)
  (procedure-availability nil :read-only t)   ; (:available ids :selected id|nil)
  (authority-recognition nil :read-only t)    ; (source . :recognized|:unrecognized)
  (representation-blockers nil :read-only t)
  (resulting-judgment nil :read-only t)       ; (:judgment j :procedure id) | nil
  (repair-obligations nil :read-only t))


;;; ------------------------------------------------------------------
;;; Projection receipt — structured, never one scalar (Task 7).

(defstruct (projection-receipt (:constructor %make-projection-receipt)
                               (:copier nil))
  (source-claim nil :read-only t)
  (source-context nil :read-only t)
  (receiver-context nil :read-only t)
  (supports-considered nil :read-only t)
  (supports-accessible nil :read-only t)
  (supports-inaccessible nil :read-only t)   ; INACCESSIBLE IS NOT ABSENT
  (procedures-available nil :read-only t)
  (authorities-recognized nil :read-only t)  ; (source . status) alist
  (derived-claims nil :read-only t)
  (redactions nil :read-only t)              ; (public private derivation-id)
  (obligations nil :read-only t)             ; (:export id) — repairable
  (blockers nil :read-only t)                ; contextual, not metaphysical
  (ceilings nil :read-only t)                ; (:mute id note) — local to object
  (resulting-claim nil :read-only t)
  (explanation nil :read-only t)
  (ordinal nil :read-only t))

(defun render-projection-why (x &optional (stream t))
  "Prose derived from the structured fields — never invented past them."
  (let ((e (etypecase x
             (projection-explanation x)
             (projection-receipt (projection-receipt-explanation x)))))
    (format stream "~&[projection] source judgment: ~:[none~;~:*~{~a ~a~}~]~%"
            (projection-explanation-source-judgment e))
    (format stream "  considered: ~{~a~^, ~}~%"
            (mapcar #'%id-name (projection-explanation-supports-considered e)))
    (loop for (id . reason) in (projection-explanation-supports-lost e)
          do (format stream "  lost ~a — ~a~%" (%id-name id) reason))
    (when (projection-explanation-supports-retained e)
      (format stream "  retained: ~{~a~^, ~}~%"
              (mapcar #'%id-name
                      (projection-explanation-supports-retained e))))
    (loop for (from to status) in
          (projection-explanation-proposition-transformations e)
          do (format stream "  proposition ~s -> ~s (~a)~%" from to status))
    (let ((pa (projection-explanation-procedure-availability e)))
      (format stream "  procedures: available ~{~a~^, ~}; selected ~:[NONE~;~:*~a~]~%"
              (mapcar #'%id-name (getf pa :available))
              (let ((s (getf pa :selected))) (and s (%id-name s)))))
    (loop for (src . rec) in (projection-explanation-authority-recognition e)
          do (format stream "  authority ~s: ~a in this context~%" src rec))
    (loop for b in (projection-explanation-representation-blockers e)
          do (format stream "  representation blocker: ~s~%" b))
    (format stream "  resulting judgment: ~:[none — receiver context licenses ~
no stronger act~;~:*~{~a ~a~}~]~%"
            (projection-explanation-resulting-judgment e))
    (loop for o in (projection-explanation-repair-obligations e)
          do (format stream "  repair: ~s~%" o))
    e))

(defun projection-views (receipt)
  "Composable descriptions of receipt features — NOT disjoint variants.
One projection may be simultaneously regraded, redacted, and
obligation-producing."
  (let* ((src-j (claim-judgment (projection-receipt-source-claim receipt)))
         (res (projection-receipt-resulting-claim receipt))
         (res-j (and res (claim-judgment res)))
         (views '()))
    (when (and src-j res-j
               (eq (judgment-record-judgment src-j)
                   (judgment-record-judgment res-j)))
      (push :preserved views))
    (when (and src-j (not res-j))
      (push :regraded views))
    (when (projection-receipt-redactions receipt) (push :redacted views))
    (when (projection-receipt-obligations receipt)
      (push :obligation-producing views))
    (when (projection-receipt-blockers receipt) (push :blocked views))
    (when (projection-receipt-ceilings receipt) (push :ceiling-bound views))
    (nreverse views)))

;;; ------------------------------------------------------------------
;;; PROJECT-CLAIM — reconstruction, never copy (Task 5 hypothesis).

(defun project-claim (source-claim &key from to store offering
                                        public-form derivation)
  "Project SOURCE-CLAIM from position FROM into position TO, against the
evidence STORE (identity-key -> witness), optionally OFFERING additional
witnesses, optionally as the redacted PUBLIC-FORM proposition backed by a
DERIVATION witness.

Returns (values resulting-claim projection-receipt).  The source claim is
never mutated; the resulting claim is a NEW located claim whose judgment —
if any — was licensed by TO's own accessible supports, recognized
authorities, and executable procedures.  Source judgment is never copied."
  (unless (claim-p source-claim)
    (%shape-error :source-claim source-claim "PROJECT-CLAIM requires a claim"))
  (unless (and (receiver-context-p from) (receiver-context-p to))
    (%shape-error :contexts (list from to)
                  "PROJECT-CLAIM requires receiver-contexts as :from and :to"))
  (unless (hash-table-p store)
    (%shape-error :store store "PROJECT-CLAIM requires a support store"))
  (let* ((src-j (claim-judgment source-claim))
         (src-prop (claim-proposition source-claim))
         (target-prop (or public-form src-prop))
         (transformations '())
         (redactions '())
         (blockers '())
         (obligations '())
         (ceilings '())
         (lost '())
         (auth-seen '())
         ;; 1. what the source's judgment actually rested on, plus offerings
         (considered-ids (append (and src-j (judgment-record-support-ids src-j))
                                 (mapcar #'witness-id offering)
                                 (and derivation
                                      (list (witness-id derivation)))))
         (considered
           (loop for id in considered-ids
                 for w = (or (%store-ref store id)
                             (find id (append offering
                                              (and derivation
                                                   (list derivation)))
                                   :key #'witness-id :test #'identity=))
                 when w collect w)))
    ;; 2. redaction requires derivation (never warrant inheritance)
    (when public-form
      (%require-proposition public-form :public-form)
      (cond ((and derivation
                  (eq (witness-mode derivation) :derivation)
                  (proposition= (witness-for derivation) public-form))
             (push (list public-form src-prop (witness-id derivation))
                   redactions)
             (push (list src-prop public-form :derived) transformations))
            (t
             (push (list :underived-redaction public-form
                         "a public derivative cannot silently inherit the private proposition's warrant; supply a :derivation witness for the public form")
                   blockers)
             (push (list src-prop public-form :underived) transformations))))
    ;; 3. partition by the RECEIVER POSITION: accessible / inaccessible
    (let ((accessible '()) (inaccessible '()))
      (dolist (w considered)
        (if (%context-can-access-p to (witness-id w))
            (push w accessible)
            (progn
              (push w inaccessible)
              (if (witness-transmissible w)
                  ;; repairable: export would put it in reach
                  (progn (push (list :export (witness-id w)) obligations)
                         (push (cons (witness-id w) "inaccessible (exportable — obligation)") lost))
                  ;; local ceiling: THIS object cannot cross; says nothing
                  ;; about equivalent support minted at the target
                  (progn (push (list :mute (witness-id w)
                                     "non-reifiable object blocks its own export; equivalent support may still be produced at the target")
                               ceilings)
                         (push (cons (witness-id w) "inaccessible (non-reifiable — local ceiling)") lost))))))
      (setf accessible (nreverse accessible)
            inaccessible (nreverse inaccessible))
      ;; 4. authority recognition — contextual, never metaphysical
      (let ((usable '()))
        (dolist (w accessible)
          (let* ((src (witness-source w))
                 (recognized (member src (receiver-context-recognized-authorities to))))
            (pushnew (cons src (if recognized :recognized :unrecognized))
                     auth-seen :key #'car)
            (cond ((not recognized)
                   (push (list :authority-unrecognized src
                               :in-context (receiver-context-context-id to))
                         blockers)
                   (push (cons (witness-id w)
                               (format nil "authority ~s unrecognized in context ~s (contextual block, not impossibility)"
                                       src (receiver-context-context-id to)))
                         lost))
                  ((not (proposition= (witness-for w) target-prop))
                   (push (list :proposition-mismatch (witness-id w)
                               (witness-for w))
                         blockers)
                   (push (cons (witness-id w)
                               (format nil "is for ~s, not ~s — a warrant for Q cannot support P"
                                       (witness-for w) target-prop))
                         lost))
                  (t (push w usable)))))
        (setf usable (nreverse usable))
        ;; 5. procedure availability at the RECEIVER
        (let* ((procs (receiver-context-executable-procedures to))
               (selected (find-if (lambda (p)
                                    (and (%procedure-semantic-p p)
                                         (some (lambda (w)
                                                 (%procedure-admits-p p w))
                                               usable)))
                                  procs))
               (located (%make-claim
                         :id (make-identity
                              :claim (format nil "claim-~D" (%next-ordinal)))
                         :proposition target-prop
                         :commitment :asserted
                         :asserted-by (claim-asserted-by source-claim)
                         :judgment nil
                         :lineage (list (claim-id source-claim))
                         :ordinal (%next-ordinal)))
               (resulting located))
          (when (and usable (null selected))
            (push (list :no-executable-procedure
                        :in-context (receiver-context-context-id to))
                  blockers))
          ;; 6. RECONSTRUCTION: the receiver's own raise, never a copy
          (when (and usable selected src-j)
            (handler-case
                (multiple-value-bind (revision receipt)
                    (raise located :to (judgment-record-judgment src-j)
                                   :per selected :considering usable
                                   :receiver (receiver-context-context-id to))
                  (declare (ignore receipt))
                  (setf resulting revision))
              (slice0-condition (c)
                (push (list :receiver-raise-refused (type-of c)) blockers))))
          ;; 7. receipt + explanation, derived from what actually happened
          (let* ((expl (%make-projection-explanation
                        :source-judgment
                        (and src-j (list (judgment-record-judgment src-j)
                                         (%id-name (judgment-record-procedure-id src-j))))
                        :supports-considered (mapcar #'witness-id considered)
                        :supports-lost (nreverse lost)
                        :supports-retained (mapcar #'witness-id usable)
                        :proposition-transformations (nreverse transformations)
                        :procedure-availability
                        (list :available (mapcar (lambda (p)
                                                   (procedure-descriptor-procedure-id
                                                    (promotion-procedure-descriptor p)))
                                                 procs)
                              :selected (and selected
                                             (procedure-descriptor-procedure-id
                                              (promotion-procedure-descriptor selected))))
                        :authority-recognition (nreverse auth-seen)
                        :representation-blockers
                        (remove-if-not (lambda (b)
                                         (eq (first b) :underived-redaction))
                                       blockers)
                        :resulting-judgment
                        (let ((j (claim-judgment resulting)))
                          (and j (list (judgment-record-judgment j)
                                       (%id-name (judgment-record-procedure-id j)))))
                        :repair-obligations obligations))
                 (receipt (%make-projection-receipt
                           :source-claim source-claim
                           :source-context from
                           :receiver-context to
                           :supports-considered (mapcar #'witness-id considered)
                           :supports-accessible (mapcar #'witness-id accessible)
                           :supports-inaccessible (mapcar #'witness-id inaccessible)
                           :procedures-available
                           (mapcar (lambda (p)
                                     (procedure-descriptor-procedure-id
                                      (promotion-procedure-descriptor p)))
                                   procs)
                           :authorities-recognized auth-seen
                           :derived-claims (and public-form (list target-prop))
                           :redactions redactions
                           :obligations obligations
                           :blockers (nreverse blockers)
                           :ceilings ceilings
                           :resulting-claim resulting
                           :explanation expl
                           :ordinal (%next-ordinal))))
            (values resulting receipt)))))))
