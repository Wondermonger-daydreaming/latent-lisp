;;;; de-temperie.lisp — Concerning Tempering
;;;;
;;;; A Lisp+ Atelier instrument about what happens after synthesis.
;;;;
;;;; The furnace may produce an operative alloy, but a successful merge is only
;;;; a beginning.  The alloy must cross heat, quench, transport, delayed
;;;; rereading, and repeated handoff without silently losing its contestations,
;;;; residue, substrate accounting, or epistemic standing.
;;;;
;;;; THESIS
;;;;   • a tempering profile is a bounded ordeal, not a universal blessing;
;;;;   • surviving a named regimen is distinct from being semantically true;
;;;;   • repaired survival is distinct from unaided survival;
;;;;   • loss detected during a stage remains archived as a scar, including the
;;;;     rejected candidate that would otherwise have overwritten history;
;;;;   • rhetorical hardening may not promote :ASSERTED work to :VERIFIED;
;;;;   • procedure identity is version-pinned for replay;
;;;;   • a historical receipt may survive after replay capability has died;
;;;;   • deterministic replay requires the same source, profile, procedures,
;;;;     and recorded repair decisions.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; trees.  The procedure registry, profile identity, stage costs, invariants,
;;;; and lineage are locally asserted.  The FNV digest supplied by the Atelier
;;;; root is pedagogical, not cryptographic.  Passing this regimen does not prove
;;;; semantic truth, general robustness, author independence, physical resource
;;;; expenditure, durable identity, process isolation, or survival under an
;;;; untested perturbation.  It establishes only the observations recorded under
;;;; this exact profile and implementation.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-temperie
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-temperie)

(reset-clock 8600)

;;; ── Typed conditions: weather must fail in named ways ──────────────────

(define-condition tempering-error (error)
  ((detail :initarg :detail :reader tempering-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (tempering-error-detail condition)))))

(define-condition malformed-temper-artifact (tempering-error) ())
(define-condition altered-temper-profile (tempering-error) ())
(define-condition stale-tempering-plan (tempering-error) ())
(define-condition temper-procedure-unavailable (tempering-error) ())
(define-condition temper-budget-exhausted (tempering-error)
  ((stage-id :initarg :stage-id :reader exhausted-stage-id)
   (needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)))
(define-condition temper-loss-detected (tempering-error)
  ((stage-id :initarg :stage-id :reader loss-stage-id)
   (candidate :initarg :candidate :reader loss-candidate)
   (failures :initarg :failures :reader loss-failures)))
(define-condition standing-drift (temper-loss-detected) ())
(define-condition transport-contamination (tempering-error) ())
(define-condition altered-temper-receipt (tempering-error) ())
(define-condition temper-replay-failed (tempering-error) ())
(define-condition forged-survival-claim (tempering-error) ())

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another TEMPERING-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (tempering-error-detail ,condition))
         t)
       (tempering-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (tempering-error-detail ,condition))))))

;;; ── Native records ─────────────────────────────────────────────────────

(defstruct (temper-witness (:constructor %make-temper-witness))
  target-digest standing contestations residue-ids residue-payloads
  markers lineage witness-digest)

(defstruct (temper-stage (:constructor make-temper-stage
                          (&key id procedure version parameters cost)))
  id procedure version parameters cost)

(defstruct (temper-profile (:constructor %make-temper-profile))
  id version stages marker-requirements profile-digest)

(defstruct (tempering-plan (:constructor %make-tempering-plan))
  source-digest witness-digest profile-digest stages plan-digest)

(defstruct (temper-scar (:constructor %make-temper-scar))
  id stage-id condition-type failures
  input-digest rejected-candidate rejected-digest
  repair scar-digest)

(defstruct (temper-stage-record (:constructor %make-stage-record))
  stage-id procedure version parameters cost
  input-digest candidate-digest output-digest
  status failures scar-digest budget-before budget-after
  record-digest)

(defstruct (temper-receipt (:constructor %make-temper-receipt))
  source-digest output-digest witness-digest profile-digest plan-digest
  stage-records scars scar-digests verdict boundary
  standing-before standing-after receipt-digest)

(defstruct (temper-work (:constructor %make-temper-work))
  id source-form current-form source-digest current-digest
  standing budget history scars)

(defstruct (survival-observation (:constructor %make-survival-observation))
  target-digest profile-digest receipt-digest
  proposition boundary verdict standing observation-digest)

;;; ── Finite proper-list trees and artifact fields ───────────────────────

(defparameter +missing-field+ (gensym "MISSING-FIELD"))

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun validate-form-tree (object)
  "Reject dotted and circular cons structures; atoms remain valid leaves."
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'malformed-temper-artifact
                       "tempering accepts finite proper lists; encountered ~s"
                       node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun validate-artifact (artifact)
  (validate-form-tree artifact)
  (unless (and (consp artifact)
               (eq (first artifact) :artifact)
               (evenp (length (rest artifact))))
    (fire 'malformed-temper-artifact
          "expected (:ARTIFACT key value ...), received ~s" artifact))
  (dolist (required '(:standing :body :residue :lineage))
    (when (eq (getf (rest artifact) required +missing-field+)
              +missing-field+)
      (fire 'malformed-temper-artifact
            "artifact is missing required field ~s" required)))
  artifact)

(defun artifact-field (artifact key &optional (default +missing-field+))
  (validate-artifact artifact)
  (getf (rest artifact) key default))

(defun plist-put-copy (plist key value)
  (let ((found nil)
        (result '()))
    (loop for (present-key present-value) on plist by #'cddr do
      (if (eq present-key key)
          (progn
            (setf found t)
            (setf result (append result (list present-key value))))
          (setf result (append result
                               (list present-key (copy-tree present-value))))))
    (unless found
      (setf result (append result (list key value))))
    result))

(defun artifact-with-field (artifact key value)
  (validate-artifact artifact)
  (cons :artifact (plist-put-copy (rest artifact) key (copy-tree value))))

(defun artifact-without-field (artifact key)
  "Used only by an adversarial stage; result may cease to be a valid artifact."
  (validate-artifact artifact)
  (cons :artifact
        (loop for (present-key present-value) on (rest artifact) by #'cddr
              unless (eq present-key key)
                append (list present-key (copy-tree present-value)))))

(defun tree-contains-p (tree sought)
  (cond
    ((equal tree sought) t)
    ((consp tree)
     (some (lambda (child) (tree-contains-p child sought)) tree))
    (t nil)))

(defun collect-headed-forms (tree head)
  (let ((found '()))
    (labels ((walk (node)
               (when (consp node)
                 (when (eq (first node) head)
                   (push (copy-tree node) found))
                 (mapc #'walk node))))
      (walk tree))
    (nreverse found)))

(defun sorted-canonical-set (objects)
  (sort (remove-duplicates (mapcar #'canonical-string objects)
                           :test #'string=)
        #'string<))

(defun residue-identities (artifact)
  (sort
   (mapcar (lambda (entry)
             (or (and (consp entry)
                      (eq (first entry) :slag)
                      (getf (rest entry) :id))
                 (canonical-string entry)))
           (artifact-field artifact :residue))
   #'string< :key #'canonical-string))

;;; ── Witnesses: every survival claim carries its boundary ───────────────

(defun witness-payload (witness)
  (list :target-digest (temper-witness-target-digest witness)
        :standing (temper-witness-standing witness)
        :contestations (copy-list (temper-witness-contestations witness))
        :residue-ids (copy-list (temper-witness-residue-ids witness))
        :residue-payloads (copy-list (temper-witness-residue-payloads witness))
        :markers (copy-list (temper-witness-markers witness))
        :lineage (copy-tree (temper-witness-lineage witness))))

(defun make-temper-witness (artifact markers)
  (validate-artifact artifact)
  (let ((witness
          (%make-temper-witness
           :target-digest (toy-digest artifact)
           :standing (artifact-field artifact :standing)
           :contestations
           (sorted-canonical-set (collect-headed-forms artifact :contested))
           :residue-ids (residue-identities artifact)
           :residue-payloads
           (sorted-canonical-set (artifact-field artifact :residue))
           :markers (copy-list markers)
           :lineage (copy-tree (artifact-field artifact :lineage)))))
    (setf (temper-witness-witness-digest witness)
          (toy-digest (witness-payload witness)))
    witness))

(defun witness-failures (witness candidate)
  "Return named losses.  This checks bounded retention, not semantic truth."
  (let ((failures '()))
    (handler-case
        (validate-artifact candidate)
      (malformed-temper-artifact ()
        (return-from witness-failures '(:malformed-artifact))))
    (unless (eq (artifact-field candidate :standing)
                (temper-witness-standing witness))
      (push :standing-drift failures))
    (unless (equal (sorted-canonical-set
                    (collect-headed-forms candidate :contested))
                   (temper-witness-contestations witness))
      (push :contestation-loss failures))
    (unless (and (equal (residue-identities candidate)
                            (temper-witness-residue-ids witness))
                 (equal (sorted-canonical-set
                         (artifact-field candidate :residue))
                        (temper-witness-residue-payloads witness)))
      (push :residue-loss failures))
    (dolist (marker (temper-witness-markers witness))
      (unless (tree-contains-p candidate marker)
        (push (list :missing-marker marker) failures)))
    (unless (equal (artifact-field candidate :lineage)
                   (temper-witness-lineage witness))
      (push :lineage-loss failures))
    (nreverse failures)))

;;; ── Procedures: version-pinned, locally registered ─────────────────────

(defparameter *temper-procedure-registry* (make-hash-table :test #'equal))

(defun procedure-key (name version)
  (list name version))

(defun register-temper-procedure (name version function)
  (setf (gethash (procedure-key name version) *temper-procedure-registry*)
        function)
  (values name version))

(defun resolve-temper-procedure (name version)
  (or (gethash (procedure-key name version) *temper-procedure-registry*)
      (fire 'temper-procedure-unavailable
            "procedure ~s version ~s is unavailable; a receipt is not executable capability"
            name version)))

(defun receive-one-form (text)
  (handler-case
      (safe-read-one text)
    (error (condition)
      (fire 'transport-contamination
            "handoff text was not one inert form: ~a" condition))))

(defun recursive-agitation-v1 (artifact parameters)
  "Repeated print/read circulation: representational heat without host EVAL."
  (let ((passes (or (getf parameters :passes) 1))
        (current (copy-tree artifact)))
    (dotimes (index passes current)
      (declare (ignore index))
      (setf current (receive-one-form (canonical-string current))))))

(defun brittle-compaction-v1 (artifact parameters)
  "An over-eager serializer mistakes residue for dispensable metadata."
  (declare (ignore parameters))
  (artifact-with-field artifact :residue '()))

(defun rhetorical-hardening-v1 (artifact parameters)
  "A fluent process confuses repeated survival with epistemic verification."
  (declare (ignore parameters))
  (artifact-with-field artifact :standing :verified))

(defun sealed-handoff-v1 (artifact parameters)
  "Round-trip through an explicit bequest carrying a pedagogical digest."
  (declare (ignore parameters))
  (let* ((bequest (list :bequest
                        :payload (copy-tree artifact)
                        :payload-digest (toy-digest artifact)))
         (revived (receive-one-form (canonical-string bequest)))
         (payload (getf (rest revived) :payload))
         (claimed (getf (rest revived) :payload-digest)))
    (unless (equal claimed (toy-digest payload))
      (fire 'transport-contamination
            "bequest payload and digest disagree"))
    payload))

(defun residue-weathering-v1 (artifact parameters)
  "Order changes; identities and rejected payloads remain."
  (declare (ignore parameters))
  (artifact-with-field artifact :residue
                       (reverse (copy-tree (artifact-field artifact :residue)))))

(register-temper-procedure 'recursive-agitation 1 #'recursive-agitation-v1)
(register-temper-procedure 'brittle-compaction 1 #'brittle-compaction-v1)
(register-temper-procedure 'rhetorical-hardening 1 #'rhetorical-hardening-v1)
(register-temper-procedure 'sealed-handoff 1 #'sealed-handoff-v1)
(register-temper-procedure 'residue-weathering 1 #'residue-weathering-v1)

;;; ── Profiles and plans ─────────────────────────────────────────────────

(defun stage-payload (stage)
  (list :id (temper-stage-id stage)
        :procedure (temper-stage-procedure stage)
        :version (temper-stage-version stage)
        :parameters (copy-tree (temper-stage-parameters stage))
        :cost (temper-stage-cost stage)))

(defun profile-payload (profile)
  (list :id (temper-profile-id profile)
        :version (temper-profile-version profile)
        :stages (mapcar #'stage-payload (temper-profile-stages profile))
        :marker-requirements
        (copy-list (temper-profile-marker-requirements profile))))

(defun mint-temper-profile (&key id version stages marker-requirements)
  (unless (and id (integerp version) (plusp version)
               (proper-list-p stages) stages)
    (fire 'altered-temper-profile "malformed tempering profile"))
  (dolist (stage stages)
    (unless (and (temper-stage-p stage)
                 (temper-stage-id stage)
                 (temper-stage-procedure stage)
                 (integerp (temper-stage-version stage))
                 (plusp (temper-stage-version stage))
                 (integerp (temper-stage-cost stage))
                 (plusp (temper-stage-cost stage)))
      (fire 'altered-temper-profile "malformed stage ~s" stage)))
  (let ((profile (%make-temper-profile
                  :id id :version version
                  :stages (copy-list stages)
                  :marker-requirements (copy-list marker-requirements))))
    (setf (temper-profile-profile-digest profile)
          (toy-digest (profile-payload profile)))
    profile))

(defun verify-profile-integrity (profile)
  (unless (equal (temper-profile-profile-digest profile)
                 (toy-digest (profile-payload profile)))
    (fire 'altered-temper-profile
          "profile payload no longer matches its minted digest"))
  profile)

(defun plan-payload (plan)
  (list :source-digest (tempering-plan-source-digest plan)
        :witness-digest (tempering-plan-witness-digest plan)
        :profile-digest (tempering-plan-profile-digest plan)
        :stages (mapcar #'stage-payload (tempering-plan-stages plan))))

(defun make-temper-work (artifact budget)
  (validate-artifact artifact)
  (unless (and (integerp budget) (<= 0 budget))
    (fire 'malformed-temper-artifact
          "initial budget must be a nonnegative integer"))
  (%make-temper-work
   :id (list :temper-work (tick))
   :source-form (copy-tree artifact)
   :current-form (copy-tree artifact)
   :source-digest (toy-digest artifact)
   :current-digest (toy-digest artifact)
   :standing (artifact-field artifact :standing)
   :budget budget
   :history '()
   :scars '()))

(defun make-tempering-plan (work witness profile)
  (verify-profile-integrity profile)
  (unless (equal (temper-work-current-digest work)
                 (temper-witness-target-digest witness))
    (fire 'stale-tempering-plan
          "witness addresses ~a, but work is ~a"
          (temper-witness-target-digest witness)
          (temper-work-current-digest work)))
  (let ((plan (%make-tempering-plan
               :source-digest (temper-work-current-digest work)
               :witness-digest (temper-witness-witness-digest witness)
               :profile-digest (temper-profile-profile-digest profile)
               :stages (copy-list (temper-profile-stages profile)))))
    (setf (tempering-plan-plan-digest plan)
          (toy-digest (plan-payload plan)))
    plan))

(defun verify-plan-integrity (plan)
  (unless (equal (tempering-plan-plan-digest plan)
                 (toy-digest (plan-payload plan)))
    (fire 'stale-tempering-plan
          "tempering plan was altered after planning"))
  plan)

;;; ── Scars, stage records, and integrity payloads ───────────────────────

(defun scar-payload (scar)
  (list :id (temper-scar-id scar)
        :stage-id (temper-scar-stage-id scar)
        :condition-type (temper-scar-condition-type scar)
        :failures (copy-tree (temper-scar-failures scar))
        :input-digest (temper-scar-input-digest scar)
        :rejected-candidate (copy-tree (temper-scar-rejected-candidate scar))
        :rejected-digest (temper-scar-rejected-digest scar)
        :repair (temper-scar-repair scar)))

(defun make-scar (stage condition-type failures input candidate repair)
  (let ((scar (%make-temper-scar
               :id (list :scar (tick))
               :stage-id (temper-stage-id stage)
               :condition-type condition-type
               :failures (copy-tree failures)
               :input-digest (toy-digest input)
               :rejected-candidate (copy-tree candidate)
               :rejected-digest (toy-digest candidate)
               :repair repair)))
    (setf (temper-scar-scar-digest scar)
          (toy-digest (scar-payload scar)))
    scar))

(defun record-payload (record)
  (list :stage-id (temper-stage-record-stage-id record)
        :procedure (temper-stage-record-procedure record)
        :version (temper-stage-record-version record)
        :parameters (copy-tree (temper-stage-record-parameters record))
        :cost (temper-stage-record-cost record)
        :input-digest (temper-stage-record-input-digest record)
        :candidate-digest (temper-stage-record-candidate-digest record)
        :output-digest (temper-stage-record-output-digest record)
        :status (temper-stage-record-status record)
        :failures (copy-tree (temper-stage-record-failures record))
        :scar-digest (temper-stage-record-scar-digest record)
        :budget-before (temper-stage-record-budget-before record)
        :budget-after (temper-stage-record-budget-after record)))

(defun mint-stage-record (&rest initargs)
  (let ((record (apply #'%make-stage-record initargs)))
    (setf (temper-stage-record-record-digest record)
          (toy-digest (record-payload record)))
    record))

(defun verify-stage-record (record)
  (unless (equal (temper-stage-record-record-digest record)
                 (toy-digest (record-payload record)))
    (fire 'altered-temper-receipt
          "stage record ~s was altered"
          (temper-stage-record-stage-id record)))
  (unless (and (integerp (temper-stage-record-budget-before record))
               (integerp (temper-stage-record-budget-after record))
               (integerp (temper-stage-record-cost record))
               (= (temper-stage-record-budget-after record)
                  (- (temper-stage-record-budget-before record)
                     (temper-stage-record-cost record)))
               (<= 0 (temper-stage-record-budget-after record)))
    (fire 'altered-temper-receipt
          "stage ~s carries inconsistent resource accounting"
          (temper-stage-record-stage-id record)))
  record)

(defun receipt-payload (receipt)
  (list :source-digest (temper-receipt-source-digest receipt)
        :output-digest (temper-receipt-output-digest receipt)
        :witness-digest (temper-receipt-witness-digest receipt)
        :profile-digest (temper-receipt-profile-digest receipt)
        :plan-digest (temper-receipt-plan-digest receipt)
        :stage-records
        (mapcar (lambda (record)
                  (list (temper-stage-record-record-digest record)
                        (record-payload record)))
                (temper-receipt-stage-records receipt))
        :scars
        (mapcar (lambda (scar)
                  (list (temper-scar-scar-digest scar)
                        (scar-payload scar)))
                (temper-receipt-scars receipt))
        :scar-digests (copy-list (temper-receipt-scar-digests receipt))
        :verdict (temper-receipt-verdict receipt)
        :boundary (copy-tree (temper-receipt-boundary receipt))
        :standing-before (temper-receipt-standing-before receipt)
        :standing-after (temper-receipt-standing-after receipt)))

(defun verify-scar-integrity (scar)
  (unless (equal (temper-scar-scar-digest scar)
                 (toy-digest (scar-payload scar)))
    (fire 'altered-temper-receipt
          "scar ~s was altered" (temper-scar-id scar)))
  scar)

(defun verify-receipt-integrity (receipt)
  (let* ((records (temper-receipt-stage-records receipt))
         (scars (temper-receipt-scars receipt))
         (actual-scar-digests
           (sort (mapcar #'temper-scar-scar-digest scars) #'string<))
         (declared-scar-digests
           (sort (copy-list (temper-receipt-scar-digests receipt)) #'string<))
         (record-scar-digests
           (sort (remove nil
                         (mapcar #'temper-stage-record-scar-digest records))
                 #'string<)))
    (dolist (record records)
      (verify-stage-record record))
    (dolist (scar scars)
      (verify-scar-integrity scar))
    (unless (and (equal actual-scar-digests declared-scar-digests)
                 (equal actual-scar-digests record-scar-digests))
      (fire 'altered-temper-receipt
            "receipt, stage records, and scar archive disagree"))
    (let ((expected-input (temper-receipt-source-digest receipt)))
      (dolist (record records)
        (unless (equal expected-input
                       (temper-stage-record-input-digest record))
          (fire 'altered-temper-receipt
                "stage chain breaks before ~s"
                (temper-stage-record-stage-id record)))
        (setf expected-input (temper-stage-record-output-digest record)))
      (unless (equal expected-input (temper-receipt-output-digest receipt))
        (fire 'altered-temper-receipt
              "stage chain does not reach the receipt output")))
    (let* ((statuses (mapcar #'temper-stage-record-status records))
           (expected-verdict
             (cond
               ((member :accepted-loss statuses) :completed-with-accepted-loss)
               ((member :repaired statuses) :survived-with-repair)
               (t :survived-unaided))))
      (unless (eq expected-verdict (temper-receipt-verdict receipt))
        (fire 'altered-temper-receipt
              "verdict ~s does not follow from stage statuses ~s"
              (temper-receipt-verdict receipt) statuses)))
    (unless (equal (temper-receipt-receipt-digest receipt)
                   (toy-digest (receipt-payload receipt)))
      (fire 'altered-temper-receipt
            "receipt payload no longer matches its digest"))
    receipt))

;;; ── The ordeal: explicit resource use and repairable loss ──────────────

(defun spend-stage-budget (work stage)
  (let ((cost (temper-stage-cost stage)))
    (loop
      (when (>= (temper-work-budget work) cost)
        (let ((before (temper-work-budget work)))
          (decf (temper-work-budget work) cost)
          (return (values before (temper-work-budget work)))))
      (restart-case
          (error 'temper-budget-exhausted
                 :stage-id (temper-stage-id stage)
                 :needed (- cost (temper-work-budget work))
                 :available (temper-work-budget work)
                 :detail (format nil
                                 "stage ~s needs ~d more hay-units"
                                 (temper-stage-id stage)
                                 (- cost (temper-work-budget work))))
        (supply-budget (amount)
          :report "Supply additional synthetic hay-units and retry the stage."
          :interactive (lambda ()
                         (format *query-io* "Additional units: ")
                         (list (read *query-io*)))
          (unless (and (integerp amount) (plusp amount))
            (fire 'temper-budget-exhausted
                  "supplied budget must be a positive integer"))
          (incf (temper-work-budget work) amount))
        (abort-tempering ()
          :report "Abort the tempering schedule."
          (return-from spend-stage-budget (values nil nil)))))))

(defun run-temper-stage (work witness stage)
  "Run one stage.  Candidate output cannot replace live work before inspection."
  (multiple-value-bind (budget-before budget-after)
      (spend-stage-budget work stage)
    (unless budget-before
      (return-from run-temper-stage nil))
    (let* ((input (copy-tree (temper-work-current-form work)))
           (input-digest (toy-digest input))
           (procedure (resolve-temper-procedure
                       (temper-stage-procedure stage)
                       (temper-stage-version stage)))
           (candidate (funcall procedure input
                               (copy-tree (temper-stage-parameters stage))))
           (candidate-digest (toy-digest candidate))
           (failures (witness-failures witness candidate))
           (status :passed)
           (output candidate)
           (scar nil))
      (when failures
        (let ((condition-type
                (if (member :standing-drift failures :test #'equal)
                    'standing-drift
                    'temper-loss-detected)))
          (restart-case
              (error condition-type
                     :stage-id (temper-stage-id stage)
                     :candidate (copy-tree candidate)
                     :failures (copy-tree failures)
                     :detail (format nil
                                     "stage ~s failed bounded retention: ~s"
                                     (temper-stage-id stage) failures))
            (restore-and-scar ()
              :report "Restore the last lawful form and archive the rejected candidate."
              (setf scar (make-scar stage condition-type failures
                                    input candidate :restore-last-lawful)
                    status :repaired
                    output input))
            (accept-loss ()
              :report "Accept the loss explicitly; the final verdict cannot be survival."
              (setf scar (make-scar stage condition-type failures
                                    input candidate :accepted-loss)
                    status :accepted-loss
                    output candidate))
            (abort-tempering ()
              :report "Abort before the candidate crosses the live-state seam."
              (return-from run-temper-stage nil)))))
      (let ((record
              (mint-stage-record
               :stage-id (temper-stage-id stage)
               :procedure (temper-stage-procedure stage)
               :version (temper-stage-version stage)
               :parameters (copy-tree (temper-stage-parameters stage))
               :cost (temper-stage-cost stage)
               :input-digest input-digest
               :candidate-digest candidate-digest
               :output-digest (toy-digest output)
               :status status
               :failures (copy-tree failures)
               :scar-digest (and scar (temper-scar-scar-digest scar))
               :budget-before budget-before
               :budget-after budget-after)))
        ;; This is the stage's explicit commit seam.
        (setf (temper-work-current-form work) (copy-tree output)
              (temper-work-current-digest work) (toy-digest output)
              (temper-work-standing work)
              (handler-case (artifact-field output :standing)
                (malformed-temper-artifact () :unreadable))
              (temper-work-history work)
              (append (temper-work-history work) (list record)))
        (when scar
          (setf (temper-work-scars work)
                (append (temper-work-scars work) (list scar))))
        record))))

(defun profile-boundary (profile)
  (list :profile (temper-profile-id profile)
        :profile-version (temper-profile-version profile)
        :profile-digest (temper-profile-profile-digest profile)
        :stages (mapcar (lambda (stage)
                          (list (temper-stage-id stage)
                                (temper-stage-procedure stage)
                                (temper-stage-version stage)))
                        (temper-profile-stages profile))
        :claim :survival-under-this-regimen-only))

(defun run-tempering (work witness profile plan)
  (verify-profile-integrity profile)
  (verify-plan-integrity plan)
  (unless (equal (tempering-plan-source-digest plan)
                 (temper-work-current-digest work))
    (fire 'stale-tempering-plan
          "plan addresses ~a, live work is ~a"
          (tempering-plan-source-digest plan)
          (temper-work-current-digest work)))
  (unless (and (equal (tempering-plan-witness-digest plan)
                      (temper-witness-witness-digest witness))
               (equal (tempering-plan-profile-digest plan)
                      (temper-profile-profile-digest profile)))
    (fire 'stale-tempering-plan
          "plan, witness, and profile do not belong to the same ordeal"))
  (let ((standing-before (temper-work-standing work)))
    (dolist (stage (tempering-plan-stages plan))
      (unless (run-temper-stage work witness stage)
        (return-from run-tempering nil)))
    (let* ((records (copy-list (temper-work-history work)))
           (statuses (mapcar #'temper-stage-record-status records))
           (verdict
             (cond
               ((member :accepted-loss statuses) :completed-with-accepted-loss)
               ((member :repaired statuses) :survived-with-repair)
               (t :survived-unaided)))
           (receipt
             (%make-temper-receipt
              :source-digest (temper-work-source-digest work)
              :output-digest (temper-work-current-digest work)
              :witness-digest (temper-witness-witness-digest witness)
              :profile-digest (temper-profile-profile-digest profile)
              :plan-digest (tempering-plan-plan-digest plan)
               :stage-records records
              :scars (copy-list (temper-work-scars work))
              :scar-digests (mapcar #'temper-scar-scar-digest
                                    (temper-work-scars work))
              :verdict verdict
              :boundary (profile-boundary profile)
              :standing-before standing-before
              :standing-after (temper-work-standing work))))
      (setf (temper-receipt-receipt-digest receipt)
            (toy-digest (receipt-payload receipt)))
      receipt)))

;;; ── Replay and bounded observation ─────────────────────────────────────

(defun replay-tempering (source receipt)
  "Replay exact procedures and exact recorded repair decisions."
  (verify-receipt-integrity receipt)
  (unless (equal (toy-digest source)
                 (temper-receipt-source-digest receipt))
    (fire 'temper-replay-failed
          "replay source does not match receipt source"))
  (let ((current (copy-tree source)))
    (dolist (record (temper-receipt-stage-records receipt))
      (unless (equal (toy-digest current)
                     (temper-stage-record-input-digest record))
        (fire 'temper-replay-failed
              "stage ~s input digest diverged"
              (temper-stage-record-stage-id record)))
      (let* ((procedure (resolve-temper-procedure
                         (temper-stage-record-procedure record)
                         (temper-stage-record-version record)))
             (candidate (funcall procedure current
                                 (copy-tree
                                  (temper-stage-record-parameters record)))))
        (unless (equal (toy-digest candidate)
                       (temper-stage-record-candidate-digest record))
          (fire 'temper-replay-failed
                "stage ~s no longer produces its recorded candidate"
                (temper-stage-record-stage-id record)))
        (setf current
              (case (temper-stage-record-status record)
                (:passed candidate)
                (:repaired current)
                (:accepted-loss candidate)
                (otherwise
                 (fire 'temper-replay-failed
                       "unknown recorded stage status ~s"
                       (temper-stage-record-status record)))))
        (unless (equal (toy-digest current)
                       (temper-stage-record-output-digest record))
          (fire 'temper-replay-failed
                "stage ~s output does not match its record"
                (temper-stage-record-stage-id record)))))
    (unless (equal (toy-digest current)
                   (temper-receipt-output-digest receipt))
      (fire 'temper-replay-failed
            "final replay output differs from receipt"))
    current))

(defun observation-payload (observation)
  (list :target-digest (survival-observation-target-digest observation)
        :profile-digest (survival-observation-profile-digest observation)
        :receipt-digest (survival-observation-receipt-digest observation)
        :proposition (copy-tree (survival-observation-proposition observation))
        :boundary (copy-tree (survival-observation-boundary observation))
        :verdict (survival-observation-verdict observation)
        :standing (survival-observation-standing observation)))

(defun observe-survival (artifact receipt)
  "Mint a bounded observation from a valid receipt; never a truth certificate."
  (verify-receipt-integrity receipt)
  (unless (equal (toy-digest artifact)
                 (temper-receipt-output-digest receipt))
    (fire 'forged-survival-claim
          "artifact does not match the receipt's final target"))
  (unless (eq (temper-receipt-standing-before receipt)
              (temper-receipt-standing-after receipt))
    (fire 'forged-survival-claim
          "tempering receipt claims an epistemic promotion"))
  (when (eq (temper-receipt-verdict receipt)
            :completed-with-accepted-loss)
    (fire 'forged-survival-claim
          "accepted loss cannot be restated as survival"))
  (let ((observation
          (%make-survival-observation
           :target-digest (temper-receipt-output-digest receipt)
           :profile-digest (temper-receipt-profile-digest receipt)
           :receipt-digest (temper-receipt-receipt-digest receipt)
           :proposition
           (list :artifact-survived
                 :profile (temper-receipt-profile-digest receipt)
                 :mode (temper-receipt-verdict receipt))
           :boundary (copy-tree (temper-receipt-boundary receipt))
           :verdict (temper-receipt-verdict receipt)
           :standing (temper-receipt-standing-after receipt))))
    (setf (survival-observation-observation-digest observation)
          (toy-digest (observation-payload observation)))
    observation))

;;; ══ The demonstration ══════════════════════════════════════════════════

(banner "de temperie")
(format t "The alloy leaves the furnace and enters weather.~%")
(format t "A green ordeal may report survival; it may not report truth.~%")

(defparameter *furnace-alloy*
  '(:artifact
    :standing :asserted
    :body
    (:alloy
     (:ore
      (:contested
       :standing :unresolved
       :path (2 1)
       :alternatives
       ((:hypothesis :plenum :basis :phonetic-neighbor)
        (:proper-name pldenic :gloss :unknown))
       :rule :no-silent-consensus))
     (:line language lathes raw ore)
     (:line spinning forms unknown before)
     (:line (:claim realities :standing :asserted :boundary :verse)
            we recompose)
     (:line spilling forth in endless flows)
     (:substrate (:resource :hay :status :required :units 4)))
    :residue
    ((:slag :id stale-voice :condition stale-charge)
     (:slag :id scope-leak :condition jurisdiction-violation)
     (:slag :id crown-the-verse :condition standing-laundering)
     (:slag :id false-memory :condition edit-precondition-failed))
    :lineage
    (:source de-fornace :receipt FURNACE-RECEIPT-7901)))

(defparameter *profile*
  (mint-temper-profile
   :id 'porch-weather
   :version 1
   :marker-requirements '(:contested :unresolved :boundary :hay)
   :stages
   (list
    (make-temper-stage :id 'heat
                       :procedure 'recursive-agitation
                       :version 1
                       :parameters '(:passes 3)
                       :cost 3)
    (make-temper-stage :id 'brittle-quench
                       :procedure 'brittle-compaction
                       :version 1
                       :parameters '()
                       :cost 2)
    (make-temper-stage :id 'over-hardening
                       :procedure 'rhetorical-hardening
                       :version 1
                       :parameters '()
                       :cost 2)
    (make-temper-stage :id 'sealed-handoff
                       :procedure 'sealed-handoff
                       :version 1
                       :parameters '()
                       :cost 3)
    (make-temper-stage :id 'weather
                       :procedure 'residue-weathering
                       :version 1
                       :parameters '()
                       :cost 1))))

(defparameter *witness*
  (make-temper-witness *furnace-alloy*
                       (temper-profile-marker-requirements *profile*)))
(defparameter *work* (make-temper-work *furnace-alloy* 7))
(defparameter *plan* (make-tempering-plan *work* *witness* *profile*))

(section "the profile is a boundary, not a benediction:")
(format t " profile: ~s v~d~%"
        (temper-profile-id *profile*)
        (temper-profile-version *profile*))
(format t " stages:  ~s~%"
        (mapcar #'temper-stage-id (temper-profile-stages *profile*)))
(format t " markers: ~s~%" (temper-witness-markers *witness*))
(ensure (equal (temper-work-current-digest *work*)
               (tempering-plan-source-digest *plan*))
        "planning changed the live work")
(pass "profile-is-a-boundary-not-a-blessing")

(section "a tampered profile cannot rewrite the ordeal:")
(let ((tampered (copy-temper-profile *profile*)))
  (setf (temper-profile-version tampered) 99)
  (expect-condition altered-temper-profile
    (verify-profile-integrity tampered)))

(section "the ordeal begins; loss is repaired but never forgotten:")
(defparameter *receipt*
  (handler-bind
      ((temper-budget-exhausted
         (lambda (condition)
           (format t " ! ~s requested ~d additional hay-units; supplied exactly.~%"
                   (exhausted-stage-id condition)
                   (exhausted-needed condition))
           (invoke-restart 'supply-budget (exhausted-needed condition))))
       (temper-loss-detected
         (lambda (condition)
           (format t " ! ~s exposed ~s; restoring the last lawful form.~%"
                   (loss-stage-id condition)
                   (loss-failures condition))
           (invoke-restart 'restore-and-scar))))
    (run-tempering *work* *witness* *profile* *plan*)))

(ensure *receipt* "tempering aborted unexpectedly")
(ensure (= 5 (length (temper-receipt-stage-records *receipt*)))
        "expected five completed stages")
(ensure (= 2 (length (temper-work-scars *work*)))
        "expected scars for residue loss and standing drift")
(ensure (eq (temper-receipt-verdict *receipt*) :survived-with-repair)
        "repaired ordeal was misclassified")
(ensure (eq (temper-receipt-standing-before *receipt*) :asserted)
        "wrong initial standing")
(ensure (eq (temper-receipt-standing-after *receipt*) :asserted)
        "tempering promoted epistemic standing")
(ensure (null (witness-failures *witness*
                                (temper-work-current-form *work*)))
        "final work violates its bounded witness")
(pass "loss-became-scar-not-silence")
(pass "repair-was-not-misreported-as-unaided-survival")
(pass "tempering-did-not-promote-standing")

(section "stage ledger:")
(dolist (record (temper-receipt-stage-records *receipt*))
  (format t " ~s  ~s  budget ~d→~d~@[  scar ~a~]~%"
          (temper-stage-record-stage-id record)
          (temper-stage-record-status record)
          (temper-stage-record-budget-before record)
          (temper-stage-record-budget-after record)
          (temper-stage-record-scar-digest record)))

(section "the scars retain the rejected futures:")
(dolist (scar (temper-work-scars *work*))
  (format t " ~s ← ~s ~s; rejected ~a~%"
          (temper-scar-id scar)
          (temper-scar-stage-id scar)
          (temper-scar-failures scar)
          (temper-scar-rejected-digest scar)))
(ensure (some (lambda (scar)
                (member :residue-loss (temper-scar-failures scar)))
              (temper-work-scars *work*))
        "residue-loss candidate was not archived")
(ensure (some (lambda (scar)
                (member :standing-drift (temper-scar-failures scar)))
              (temper-work-scars *work*))
        "standing-drift candidate was not archived")

(section "transport contamination is refused before interpretation:")
(expect-condition transport-contamination
  (receive-one-form "(:bequest :payload (:artifact)) trailing-payload"))

(section "a historical receipt can outlive replay capability:")
(let* ((key (procedure-key 'sealed-handoff 1))
       (saved (gethash key *temper-procedure-registry*)))
  (remhash key *temper-procedure-registry*)
  (unwind-protect
       (expect-condition temper-procedure-unavailable
         (replay-tempering *furnace-alloy* *receipt*))
    (setf (gethash key *temper-procedure-registry*) saved)))
(pass "historical-receipt-outlived-replay-capability")

(section "the same source, versions, and repair decisions replay the weather:")
(let ((replayed (replay-tempering *furnace-alloy* *receipt*)))
  (ensure (equal replayed (temper-work-current-form *work*))
          "replay did not reproduce the tempered artifact")
  (pass "same-regimen-replayed-the-weather"))

(section "receipt tampering cannot rewrite the remembered ordeal:")
(let ((tampered (copy-temper-receipt *receipt*)))
  (setf (temper-receipt-verdict tampered) :survived-unaided)
  (expect-condition altered-temper-receipt
    (verify-receipt-integrity tampered)))

(section "the bounded observation:")
(defparameter *observation*
  (observe-survival (temper-work-current-form *work*) *receipt*))
(format t " proposition: ~s~%"
        (survival-observation-proposition *observation*))
(format t " boundary:    ~s~%"
        (survival-observation-boundary *observation*))
(format t " standing:    ~s~%"
        (survival-observation-standing *observation*))
(ensure (eq (survival-observation-verdict *observation*)
            :survived-with-repair)
        "observation erased the repairs")
(ensure (eq (survival-observation-standing *observation*) :asserted)
        "survival observation impersonated verification")

(section "a receipt for another target cannot bless this one:")
(expect-condition forged-survival-claim
  (observe-survival
   (artifact-with-field (temper-work-current-form *work*)
                        :standing :verified)
   *receipt*))

(section "what this instrument does NOT establish:")
(format t " The profile tests only the named stages and bounded retention rules.~%")
(format t " Its registry and costs are local assertions; its digests are not~%")
(format t " cryptographic.  Repaired survival is recorded as repaired.  No stage~%")
(format t " determines semantic truth, general robustness, or future survival.~%")

(format t "~%── The alloy is not proven because it endured. ──~%")
(format t "── The scar is part of what endured. ──~%")
(format t "── Weather receives no authority to rewrite the sky. ──~%")
