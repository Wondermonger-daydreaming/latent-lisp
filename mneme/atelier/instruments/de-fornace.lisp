;;;; de-fornace.lisp — Concerning the Furnace
;;;;
;;;; A Lisp+ Atelier instrument about synthesis without false consensus.
;;;;
;;;; The lathe gave one transformation a bounded cutting office.  The furnace
;;;; receives several proposed transformations at once.  Some are compatible,
;;;; some are exact convergences, some conflict, and some should never enter the
;;;; crucible.  The furnace may produce an operative alloy; it may not pretend
;;;; that numerical repetition, fluent synthesis, or successful execution has
;;;; settled the truth of the alternatives it combined.
;;;;
;;;; THESIS
;;;;   • admission is distinct from adoption;
;;;;   • compatible proposals may alloy without sharing an author or rationale;
;;;;   • identical proposals are convergence, not automatically corroboration;
;;;;   • incompatible proposals remain explicit contestation unless a named
;;;;     operative policy selects one;
;;;;   • selection changes what runs, not what is epistemically settled;
;;;;   • rejected charges and failed gates remain archived as slag;
;;;;   • planning is pure until an explicit commit;
;;;;   • replay reproduces the committed alloy from the same bounded source.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; trees.  Proposal identity, lineage, procedure version, scope, and base
;;;; digest are self-reported.  The FNV digest supplied by the Atelier root is
;;;; pedagogical, not cryptographic.  The instrument does not establish author
;;;; independence, semantic truth, hygienic macroexpansion, durable identity,
;;;; adversarial confinement, or that a good synthesis policy exists.  It makes
;;;; conflict and loss inspectable; it does not abolish either.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-fornace
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-fornace)

(reset-clock 7900)

;;; ── Typed conditions: the furnace refuses in named ways ────────────────

(define-condition furnace-error (error)
  ((detail :initarg :detail :reader furnace-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (furnace-error-detail condition)))))

(define-condition malformed-charge (furnace-error) ())
(define-condition stale-charge (furnace-error) ())
(define-condition jurisdiction-violation (furnace-error) ())
(define-condition standing-laundering (furnace-error) ())
(define-condition edit-precondition-failed (furnace-error) ())
(define-condition overlapping-charges (furnace-error) ())
(define-condition altered-firing-plan (furnace-error) ())
(define-condition stale-firing-plan (furnace-error) ())
(define-condition headcount-is-not-certificate (furnace-error) ())
(define-condition receipt-replay-failed (furnace-error) ())

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire.  Another FURNACE-ERROR does not count as success."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (furnace-error-detail ,condition))
         t)
       (furnace-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (furnace-error-detail ,condition))))))

;;; ── Native records ─────────────────────────────────────────────────────

(defstruct (furnace-edit
            (:constructor make-furnace-edit (&key path before after reason)))
  path before after reason)

(defstruct (charge (:constructor %make-charge))
  id lineage procedure version
  base-digest scope edits requested-standing
  charge-digest)

(defstruct (slag (:constructor %make-slag))
  id charge-id condition-type detail
  charge-payload slag-digest)

(defstruct (convergence (:constructor %make-convergence))
  path before after charge-ids lineages reasons)

(defstruct (alloy-conflict (:constructor %make-alloy-conflict))
  path before alternatives)

(defstruct (firing-plan (:constructor %make-firing-plan))
  base-digest charge-digests
  clean-edits convergences conflicts
  plan-digest)

(defstruct (resolved-plan (:constructor %make-resolved-plan))
  source-plan-digest base-digest
  policy edits convergences conflicts resolution-notes
  resolved-digest)

(defstruct (firing-receipt (:constructor %make-firing-receipt))
  base-digest output-digest
  source-plan-digest resolved-plan-digest
  policy edits convergences conflicts resolution-notes
  admitted-charge-digests slag-digests
  standing-before standing-after
  receipt-digest)

(defstruct (furnace-work (:constructor %make-furnace-work))
  id source-form current-form
  source-digest current-digest
  standing admitted slag history)

;;; ── Finite proper-list tree operations ─────────────────────────────────

(defun proper-list-p (object)
  "True only for finite proper lists."
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun validate-form-tree (object)
  "Reject dotted or circular cons structures; atoms remain valid leaves."
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'malformed-charge
                       "the furnace accepts finite proper lists; encountered ~s"
                       node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun valid-path-p (path)
  (and (proper-list-p path)
       (every (lambda (index)
                (and (integerp index) (<= 0 index)))
              path)))

(defun path-prefix-p (prefix path)
  (and (<= (length prefix) (length path))
       (equal prefix (subseq path 0 (length prefix)))))

(defun path-in-scope-p (path scope)
  (some (lambda (prefix) (path-prefix-p prefix path)) scope))

(defun strict-path-overlap-p (a b)
  (and (not (equal a b))
       (or (path-prefix-p a b)
           (path-prefix-p b a))))

(defun path< (a b)
  (string< (canonical-string a) (canonical-string b)))

(defun node-at-path (tree path)
  (reduce (lambda (node index)
            (unless (and (listp node)
                         (< index (length node)))
              (fire 'edit-precondition-failed
                    "path ~s does not address a present node" path))
            (nth index node))
          path
          :initial-value tree))

(defun replace-nth-copy (list index replacement)
  (unless (and (listp list) (< index (length list)))
    (fire 'edit-precondition-failed
          "replace index ~s is outside a list of length ~s"
          index (if (listp list) (length list) :not-a-list)))
  (loop for item in list
        for position from 0
        collect (if (= position index) replacement item)))

(defun replace-at-path (tree path replacement)
  (if (null path)
      replacement
      (let ((index (first path)))
        (unless (and (listp tree) (< index (length tree)))
          (fire 'edit-precondition-failed
                "cannot descend through ~s at path ~s" tree path))
        (replace-nth-copy
         tree index
         (replace-at-path (nth index tree) (rest path) replacement)))))

(defun standing-edit-p (tree edit)
  "Recognize edits to either a (:STANDING value) pair or its value slot."
  (let* ((path (furnace-edit-path edit))
         (before (furnace-edit-before edit))
         (parent (and path
                      (ignore-errors
                        (node-at-path tree (butlast path))))))
    (or (and (consp before) (eq (first before) :standing))
        (and (consp parent) (eq (first parent) :standing)))))

(defun tree-contains-p (tree sought)
  (cond
    ((equal tree sought) t)
    ((consp tree) (some (lambda (child)
                         (tree-contains-p child sought))
                       tree))
    (t nil)))

;;; ── Canonical payloads and pedagogical integrity ───────────────────────

(defun edit-payload (edit)
  (list :path (copy-list (furnace-edit-path edit))
        :before (copy-tree (furnace-edit-before edit))
        :after (copy-tree (furnace-edit-after edit))
        :reason (furnace-edit-reason edit)))

(defun charge-payload (charge)
  (list :id (charge-id charge)
        :lineage (charge-lineage charge)
        :procedure (charge-procedure charge)
        :version (charge-version charge)
        :base-digest (charge-base-digest charge)
        :scope (copy-tree (charge-scope charge))
        :edits (mapcar #'edit-payload (charge-edits charge))
        :requested-standing (charge-requested-standing charge)))

(defun convergence-payload (convergence)
  (list :path (copy-list (convergence-path convergence))
        :before (copy-tree (convergence-before convergence))
        :after (copy-tree (convergence-after convergence))
        :charge-ids (copy-list (convergence-charge-ids convergence))
        :lineages (copy-tree (convergence-lineages convergence))
        :reasons (copy-tree (convergence-reasons convergence))))

(defun conflict-payload (conflict)
  (list :path (copy-list (alloy-conflict-path conflict))
        :before (copy-tree (alloy-conflict-before conflict))
        :alternatives (copy-tree (alloy-conflict-alternatives conflict))))

(defun plan-payload (plan)
  (list :base-digest (firing-plan-base-digest plan)
        :charge-digests (copy-list (firing-plan-charge-digests plan))
        :clean-edits (mapcar #'edit-payload
                             (firing-plan-clean-edits plan))
        :convergences (mapcar #'convergence-payload
                              (firing-plan-convergences plan))
        :conflicts (mapcar #'conflict-payload
                           (firing-plan-conflicts plan))))

(defun resolved-plan-payload (plan)
  (list :source-plan-digest (resolved-plan-source-plan-digest plan)
        :base-digest (resolved-plan-base-digest plan)
        :policy (copy-tree (resolved-plan-policy plan))
        :edits (mapcar #'edit-payload (resolved-plan-edits plan))
        :convergences (mapcar #'convergence-payload
                              (resolved-plan-convergences plan))
        :conflicts (mapcar #'conflict-payload
                           (resolved-plan-conflicts plan))
        :resolution-notes (copy-tree (resolved-plan-resolution-notes plan))))

(defun slag-payload (slag)
  (list :id (slag-id slag)
        :charge-id (slag-charge-id slag)
        :condition-type (slag-condition-type slag)
        :detail (slag-detail slag)
        :charge-payload (copy-tree (slag-charge-payload slag))))

(defun receipt-payload (receipt)
  (list :base-digest (firing-receipt-base-digest receipt)
        :output-digest (firing-receipt-output-digest receipt)
        :source-plan-digest (firing-receipt-source-plan-digest receipt)
        :resolved-plan-digest (firing-receipt-resolved-plan-digest receipt)
        :policy (copy-tree (firing-receipt-policy receipt))
        :edits (mapcar #'edit-payload (firing-receipt-edits receipt))
        :convergences (mapcar #'convergence-payload
                              (firing-receipt-convergences receipt))
        :conflicts (mapcar #'conflict-payload
                           (firing-receipt-conflicts receipt))
        :resolution-notes (copy-tree (firing-receipt-resolution-notes receipt))
        :admitted-charge-digests
        (copy-list (firing-receipt-admitted-charge-digests receipt))
        :slag-digests (copy-list (firing-receipt-slag-digests receipt))
        :standing-before (firing-receipt-standing-before receipt)
        :standing-after (firing-receipt-standing-after receipt)))

(defun verify-charge-integrity (charge)
  (unless (equal (charge-charge-digest charge)
                 (toy-digest (charge-payload charge)))
    (fire 'malformed-charge
          "charge ~s changed after minting" (charge-id charge)))
  charge)

(defun verify-plan-integrity (plan)
  (unless (equal (firing-plan-plan-digest plan)
                 (toy-digest (plan-payload plan)))
    (fire 'altered-firing-plan
          "the firing plan changed after planning"))
  plan)

(defun verify-resolved-plan-integrity (plan)
  (unless (equal (resolved-plan-resolved-digest plan)
                 (toy-digest (resolved-plan-payload plan)))
    (fire 'altered-firing-plan
          "the resolved plan changed after resolution"))
  plan)

(defun verify-receipt-integrity (receipt)
  (unless (equal (firing-receipt-receipt-digest receipt)
                 (toy-digest (receipt-payload receipt)))
    (fire 'receipt-replay-failed
          "the firing receipt changed after commitment"))
  receipt)

;;; ── Minting and admission ──────────────────────────────────────────────

(defun make-furnace-work (form &key (id 'pldenic-furnace)
                                    (standing :asserted))
  (validate-form-tree form)
  (let ((digest (toy-digest form)))
    (%make-furnace-work
     :id id
     :source-form (copy-tree form)
     :current-form (copy-tree form)
     :source-digest digest
     :current-digest digest
     :standing standing
     :admitted nil
     :slag nil
     :history nil)))

(defun mint-charge (&key id lineage procedure version base-digest scope edits
                      (requested-standing :asserted))
  (unless (and id lineage procedure version base-digest
               (proper-list-p scope) scope
               (every #'valid-path-p scope)
               (proper-list-p edits) edits
               (every #'furnace-edit-p edits))
    (fire 'malformed-charge
          "charge ~s lacks a required identity, scope, or edit list" id))
  (let ((charge (%make-charge
                 :id id
                 :lineage lineage
                 :procedure procedure
                 :version version
                 :base-digest base-digest
                 :scope (copy-tree scope)
                 :edits (copy-list edits)
                 :requested-standing requested-standing)))
    (setf (charge-charge-digest charge)
          (toy-digest (charge-payload charge)))
    charge))

(defun validate-charge-against-work (work charge)
  (verify-charge-integrity charge)
  (unless (equal (charge-base-digest charge)
                 (furnace-work-current-digest work))
    (fire 'stale-charge
          "charge ~s addresses base ~a, but the live work is ~a"
          (charge-id charge)
          (charge-base-digest charge)
          (furnace-work-current-digest work)))
  (unless (eq (charge-requested-standing charge)
              (furnace-work-standing work))
    (fire 'standing-laundering
          "charge ~s requests standing ~s from ~s; synthesis cannot mint it"
          (charge-id charge)
          (charge-requested-standing charge)
          (furnace-work-standing work)))
  (dolist (edit (charge-edits charge))
    (let ((path (furnace-edit-path edit)))
      (unless (valid-path-p path)
        (fire 'malformed-charge
              "charge ~s contains invalid path ~s"
              (charge-id charge) path))
      (unless (path-in-scope-p path (charge-scope charge))
        (fire 'jurisdiction-violation
              "charge ~s declares scope ~s but reaches path ~s"
              (charge-id charge) (charge-scope charge) path))
      (when (standing-edit-p (furnace-work-current-form work) edit)
        (fire 'standing-laundering
              "charge ~s attempts to rewrite an epistemic standing marker at ~s"
              (charge-id charge) path))
      (validate-form-tree (furnace-edit-before edit))
      (validate-form-tree (furnace-edit-after edit))
      (unless (equal (node-at-path (furnace-work-current-form work) path)
                     (furnace-edit-before edit))
        (fire 'edit-precondition-failed
              "charge ~s expected ~s at ~s, but the source contains ~s"
              (charge-id charge)
              (furnace-edit-before edit)
              path
              (node-at-path (furnace-work-current-form work) path)))
      (when (equal (furnace-edit-before edit)
                   (furnace-edit-after edit))
        (fire 'malformed-charge
              "charge ~s proposes a no-op at ~s"
              (charge-id charge) path))))
  charge)

(defun archive-condition-as-slag (work charge condition)
  (let* ((payload (charge-payload charge))
         (slag (%make-slag
                :id (list 'slag (tick))
                :charge-id (charge-id charge)
                :condition-type (type-of condition)
                :detail (furnace-error-detail condition)
                :charge-payload payload)))
    (setf (slag-slag-digest slag)
          (toy-digest (slag-payload slag)))
    (push slag (furnace-work-slag work))
    (format t "   ↳ archived ~s as slag ~s~%"
            (charge-id charge) (slag-id slag))
    slag))

(defun admit-charge (work charge)
  "Admit CHARGE or leave a live ARCHIVE-AS-SLAG restart around refusal."
  (restart-case
      (progn
        (validate-charge-against-work work charge)
        (push charge (furnace-work-admitted work))
        (format t " ✓ admitted ~s from ~s~%"
                (charge-id charge) (charge-lineage charge))
        :admitted)
    (archive-as-slag (condition)
      :report "Archive the refused charge and its typed failure as slag."
      (archive-condition-as-slag work charge condition)
      :slagged)))

(defun expect-refusal-and-archive (work charge expected-type)
  "Require EXPECTED-TYPE, invoke the live archival restart, and verify residue."
  (let ((seen nil)
        (slag-before (length (furnace-work-slag work))))
    (handler-bind
        ((furnace-error
           (lambda (condition)
             (unless (typep condition expected-type)
               (error "expected ~a, got ~a: ~a"
                      expected-type (type-of condition)
                      (furnace-error-detail condition)))
             (setf seen t)
             (format t " ✓ ~a fired: ~a~%"
                     expected-type (furnace-error-detail condition))
             (invoke-restart 'archive-as-slag condition))))
      (admit-charge work charge))
    (ensure seen "expected ~a, but no refusal fired" expected-type)
    (ensure (= (1+ slag-before) (length (furnace-work-slag work)))
            "refused charge was not archived as slag")
    t))

;;; ── Pure planning: compatible edits, convergence, conflict ─────────────

(defun entry-path (entry)
  (furnace-edit-path (getf entry :edit)))

(defun entry-after (entry)
  (furnace-edit-after (getf entry :edit)))

(defun entry-before (entry)
  (furnace-edit-before (getf entry :edit)))

(defun entry-charge-id (entry)
  (charge-id (getf entry :charge)))

(defun entries-from-work (work)
  (loop for charge in (reverse (furnace-work-admitted work))
        append (loop for edit in (charge-edits charge)
                     collect (list :charge charge :edit edit))))

(defun ensure-no-strict-overlaps (entries)
  (loop for rest on entries
        for left = (first rest)
        do (dolist (right (rest rest))
             (when (strict-path-overlap-p (entry-path left)
                                          (entry-path right))
               (fire 'overlapping-charges
                     "charges ~s at ~s and ~s at ~s overlap by ancestry"
                     (entry-charge-id left) (entry-path left)
                     (entry-charge-id right) (entry-path right)))))
  entries)

(defun group-entries-by-path (entries)
  (let ((table (make-hash-table :test #'equal)))
    (dolist (entry entries)
      (push entry (gethash (entry-path entry) table)))
    (let ((groups nil))
      (maphash (lambda (path members)
                 (push (cons path (reverse members)) groups))
               table)
      (sort groups #'path< :key #'car))))

(defun group-outcomes (entries)
  "Group exact AFTER forms while retaining every proposing charge and lineage."
  (let ((outcomes nil))
    (dolist (entry entries)
      (let* ((charge (getf entry :charge))
             (edit (getf entry :edit))
             (found (find (furnace-edit-after edit) outcomes
                          :key (lambda (outcome) (getf outcome :after))
                          :test #'equal)))
        (if found
            (progn
              (push (charge-id charge) (getf found :charge-ids))
              (push (charge-lineage charge) (getf found :lineages))
              (push (furnace-edit-reason edit) (getf found :reasons)))
            (push (list :after (copy-tree (furnace-edit-after edit))
                        :charge-ids (list (charge-id charge))
                        :lineages (list (charge-lineage charge))
                        :reasons (list (furnace-edit-reason edit)))
                  outcomes))))
    (mapcar (lambda (outcome)
              (setf (getf outcome :charge-ids)
                    (reverse (getf outcome :charge-ids))
                    (getf outcome :lineages)
                    (reverse (getf outcome :lineages))
                    (getf outcome :reasons)
                    (reverse (getf outcome :reasons)))
              outcome)
            (reverse outcomes))))

(defun plan-alloy (work)
  "Compute a firing plan without modifying WORK."
  (let* ((digest-before (furnace-work-current-digest work))
         (entries (ensure-no-strict-overlaps (entries-from-work work)))
         (groups (group-entries-by-path entries))
         (clean-edits nil)
         (convergences nil)
         (conflicts nil))
    (dolist (group groups)
      (let* ((path (car group))
             (members (cdr group))
             (before (entry-before (first members)))
             (outcomes (group-outcomes members)))
        (unless (every (lambda (entry)
                         (equal before (entry-before entry)))
                       members)
          (fire 'edit-precondition-failed
                "proposals at ~s disagree about the source they claim to edit"
                path))
        ;; Exact recurrence remains visible even when that recurrent outcome
        ;; is only one side of a larger conflict.  Two echoes are convergence;
        ;; they are still not a certificate.
        (dolist (outcome outcomes)
          (when (> (length (getf outcome :charge-ids)) 1)
            (push (%make-convergence
                   :path (copy-list path)
                   :before (copy-tree before)
                   :after (copy-tree (getf outcome :after))
                   :charge-ids (copy-list (getf outcome :charge-ids))
                   :lineages (copy-tree (getf outcome :lineages))
                   :reasons (copy-tree (getf outcome :reasons)))
                  convergences)))
        (if (= (length outcomes) 1)
            (let* ((outcome (first outcomes))
                   (edit (getf (first members) :edit)))
              (push (make-furnace-edit
                     :path (copy-list path)
                     :before (copy-tree before)
                     :after (copy-tree (getf outcome :after))
                     :reason (furnace-edit-reason edit))
                    clean-edits))
            (push (%make-alloy-conflict
                   :path (copy-list path)
                   :before (copy-tree before)
                   :alternatives (copy-tree outcomes))
                  conflicts))))
    (ensure (equal digest-before (furnace-work-current-digest work))
            "planning modified the live work")
    (let ((plan (%make-firing-plan
                 :base-digest digest-before
                 :charge-digests
                 (sort (mapcar #'charge-charge-digest
                               (furnace-work-admitted work))
                       #'string<)
                 :clean-edits (sort clean-edits #'path<
                                    :key #'furnace-edit-path)
                 :convergences (sort convergences #'path<
                                     :key #'convergence-path)
                 :conflicts (sort conflicts #'path<
                                  :key #'alloy-conflict-path))))
      (setf (firing-plan-plan-digest plan)
            (toy-digest (plan-payload plan)))
      plan)))

;;; ── Resolution: explicit contestation or explicit operative choice ─────

(defun alternative-counts (conflict)
  (mapcar (lambda (alternative)
            (list :after (getf alternative :after)
                  :count (length (getf alternative :charge-ids))))
          (alloy-conflict-alternatives conflict)))

(defun settle-conflict-by-headcount (conflict)
  "Intentionally refuse the seductive policy: repeated output is not a warrant."
  (fire 'headcount-is-not-certificate
        "path ~s has proposal counts ~s; repetition may guide scheduling, but it cannot certify an alternative"
        (alloy-conflict-path conflict)
        (alternative-counts conflict)))

(defun contestation-node (conflict)
  (list :contested
        :standing :unresolved
        :path (copy-list (alloy-conflict-path conflict))
        :alternatives
        (mapcar (lambda (alternative)
                  (list :form (copy-tree (getf alternative :after))
                        :charges (copy-list (getf alternative :charge-ids))
                        :lineages (copy-tree (getf alternative :lineages))
                        :reasons (copy-tree (getf alternative :reasons))))
                (alloy-conflict-alternatives conflict))
        :rule :no-silent-consensus))

(defun resolve-preserving-contestation (plan)
  "Turn each conflict into explicit data rather than silently selecting a side."
  (verify-plan-integrity plan)
  (let ((edits (copy-list (firing-plan-clean-edits plan)))
        (notes nil))
    (dolist (conflict (firing-plan-conflicts plan))
      (push (make-furnace-edit
             :path (copy-list (alloy-conflict-path conflict))
             :before (copy-tree (alloy-conflict-before conflict))
             :after (contestation-node conflict)
             :reason :preserve-contestation)
            edits)
      (push (list :path (copy-list (alloy-conflict-path conflict))
                  :disposition :preserved-as-data
                  :alternatives
                  (copy-tree (alloy-conflict-alternatives conflict)))
            notes))
    (let ((resolved (%make-resolved-plan
                     :source-plan-digest (firing-plan-plan-digest plan)
                     :base-digest (firing-plan-base-digest plan)
                     :policy :preserve-contestation
                     :edits (sort edits #'path< :key #'furnace-edit-path)
                     :convergences
                     (copy-list (firing-plan-convergences plan))
                     :conflicts (copy-list (firing-plan-conflicts plan))
                     :resolution-notes (reverse notes))))
      (setf (resolved-plan-resolved-digest resolved)
            (toy-digest (resolved-plan-payload resolved)))
      resolved)))

(defun find-alternative-for-charge (conflict charge-id)
  (find-if (lambda (alternative)
             (member charge-id (getf alternative :charge-ids) :test #'equal))
           (alloy-conflict-alternatives conflict)))

(defun resolve-operatively (plan selections)
  "Select one runnable alternative per conflict while retaining every rejected
alternative in RESOLUTION-NOTES.  This is an operational decision, not settlement.
SELECTIONS is an alist of (PATH . CHARGE-ID)."
  (verify-plan-integrity plan)
  (let ((edits (copy-list (firing-plan-clean-edits plan)))
        (notes nil))
    (dolist (conflict (firing-plan-conflicts plan))
      (let* ((path (alloy-conflict-path conflict))
             (chosen-id (cdr (assoc path selections :test #'equal)))
             (chosen (and chosen-id
                          (find-alternative-for-charge conflict chosen-id))))
        (unless chosen
          (fire 'malformed-charge
                "operative policy supplied no valid charge for conflict at ~s"
                path))
        (push (make-furnace-edit
               :path (copy-list path)
               :before (copy-tree (alloy-conflict-before conflict))
               :after (copy-tree (getf chosen :after))
               :reason (list :operative-choice chosen-id))
              edits)
        (push (list :path (copy-list path)
                    :disposition :operative-choice
                    :chosen-charge chosen-id
                    :standing :unsettled
                    :retained-alternatives
                    (copy-tree (alloy-conflict-alternatives conflict)))
              notes)))
    (let ((resolved (%make-resolved-plan
                     :source-plan-digest (firing-plan-plan-digest plan)
                     :base-digest (firing-plan-base-digest plan)
                     :policy (list :operative-choice (copy-tree selections))
                     :edits (sort edits #'path< :key #'furnace-edit-path)
                     :convergences
                     (copy-list (firing-plan-convergences plan))
                     :conflicts (copy-list (firing-plan-conflicts plan))
                     :resolution-notes (reverse notes))))
      (setf (resolved-plan-resolved-digest resolved)
            (toy-digest (resolved-plan-payload resolved)))
      resolved)))

;;; ── Commitment and replay ──────────────────────────────────────────────

(defun apply-checked-edit (form edit)
  (let* ((path (furnace-edit-path edit))
         (present (node-at-path form path)))
    (unless (equal present (furnace-edit-before edit))
      (fire 'edit-precondition-failed
            "commit expected ~s at ~s, found ~s"
            (furnace-edit-before edit) path present))
    (replace-at-path form path (copy-tree (furnace-edit-after edit)))))

(defun apply-edits (form edits)
  (reduce #'apply-checked-edit edits :initial-value (copy-tree form)))

(defun commit-firing (work resolved)
  "The only mutating seam.  Everything before this function is proposal or plan."
  (verify-resolved-plan-integrity resolved)
  (unless (equal (resolved-plan-base-digest resolved)
                 (furnace-work-current-digest work))
    (fire 'stale-firing-plan
          "resolved plan addresses ~a, but live work is ~a"
          (resolved-plan-base-digest resolved)
          (furnace-work-current-digest work)))
  (unless (eq (furnace-work-standing work) :asserted)
    (fire 'standing-laundering
          "this specimen commits only asserted work, not ~s"
          (furnace-work-standing work)))
  (let* ((standing-before (furnace-work-standing work))
         (output (apply-edits (furnace-work-current-form work)
                              (resolved-plan-edits resolved)))
         (output-digest (toy-digest output))
         (receipt (%make-firing-receipt
                   :base-digest (furnace-work-current-digest work)
                   :output-digest output-digest
                   :source-plan-digest
                   (resolved-plan-source-plan-digest resolved)
                   :resolved-plan-digest
                   (resolved-plan-resolved-digest resolved)
                   :policy (copy-tree (resolved-plan-policy resolved))
                   :edits (copy-list (resolved-plan-edits resolved))
                   :convergences
                   (copy-list (resolved-plan-convergences resolved))
                   :conflicts (copy-list (resolved-plan-conflicts resolved))
                   :resolution-notes
                   (copy-tree (resolved-plan-resolution-notes resolved))
                   :admitted-charge-digests
                   (sort (mapcar #'charge-charge-digest
                                 (furnace-work-admitted work))
                         #'string<)
                   :slag-digests
                   (sort (mapcar #'slag-slag-digest
                                 (furnace-work-slag work))
                         #'string<)
                   :standing-before standing-before
                   :standing-after standing-before)))
    (setf (firing-receipt-receipt-digest receipt)
          (toy-digest (receipt-payload receipt)))
    (setf (furnace-work-current-form work) output
          (furnace-work-current-digest work) output-digest
          (furnace-work-history work)
          (append (furnace-work-history work) (list receipt)))
    receipt))

(defun replay-firing (source receipt)
  "Replay the committed edit set against SOURCE and verify the bounded receipt."
  (verify-receipt-integrity receipt)
  (unless (equal (toy-digest source)
                 (firing-receipt-base-digest receipt))
    (fire 'receipt-replay-failed
          "replay source digest does not match receipt base"))
  (unless (eq (firing-receipt-standing-before receipt)
              (firing-receipt-standing-after receipt))
    (fire 'receipt-replay-failed
          "receipt claims synthesis changed epistemic standing"))
  (let ((output (apply-edits source (firing-receipt-edits receipt))))
    (unless (equal (toy-digest output)
                   (firing-receipt-output-digest receipt))
      (fire 'receipt-replay-failed
            "replayed output does not match committed output digest"))
    output))

;;; ══ The demonstration ══════════════════════════════════════════════════

(banner "de fornace")
(format t "Several transformations enter.  No consensus is smuggled out.~%")
(format t "The furnace may alloy forms; it may not counterfeit settlement.~%")

(defparameter *pldenic-ore*
  '(:furnace-work
    (:standing :asserted)
    (:ore (:unresolved pldenic))
    (:line language lathes raw ore)
    (:line spinning forms unknown before)
    (:line realities we recompose)
    (:line spilling forth in endless flows)
    (:substrate (:need hay))))

(defparameter *work* (make-furnace-work *pldenic-ore*))
(defparameter *base* (furnace-work-source-digest *work*))

(defun edit (path before after reason)
  (make-furnace-edit :path path :before before :after after :reason reason))

(defun charge (id lineage scope edits &key (base *base*)
                                    (standing :asserted))
  (mint-charge :id id
               :lineage lineage
               :procedure 'bounded-form-proposal
               :version 1
               :base-digest base
               :scope scope
               :edits edits
               :requested-standing standing))

(section "the admitted charges:")

(defparameter *bounded-realities-a*
  (charge 'bounded-realities-a 'gemma
          '((5))
          (list (edit '(5 1)
                      'realities
                      '(:claim realities :standing :asserted :boundary :verse)
                      :make-standing-visible))))

(defparameter *bounded-realities-b*
  (charge 'bounded-realities-b 'claude-sonnet
          '((5))
          (list (edit '(5 1)
                      'realities
                      '(:claim realities :standing :asserted :boundary :verse)
                      :make-standing-visible))))

(defparameter *account-for-hay*
  (charge 'account-for-hay 'rabbit
          '((7))
          (list (edit '(7 1)
                      '(:need hay)
                      '(:resource :hay :status :required :units 4)
                      :name-the-substrate))))

(defparameter *pldenic-as-plenum-a*
  (charge 'pldenic-as-plenum-a 'k3
          '((2))
          (list (edit '(2 1)
                      '(:unresolved pldenic)
                      '(:hypothesis :plenum :basis :phonetic-neighbor)
                      :speculative-gloss))))

(defparameter *pldenic-as-plenum-b*
  (charge 'pldenic-as-plenum-b 'echo-of-k3
          '((2))
          (list (edit '(2 1)
                      '(:unresolved pldenic)
                      '(:hypothesis :plenum :basis :phonetic-neighbor)
                      :speculative-gloss))))

(defparameter *pldenic-as-name*
  (charge 'pldenic-as-name 'cold-chair
          '((2))
          (list (edit '(2 1)
                      '(:unresolved pldenic)
                      '(:proper-name pldenic :gloss :unknown)
                      :preserve-unknown-token))))

(dolist (proposal (list *bounded-realities-a*
                        *bounded-realities-b*
                        *account-for-hay*
                        *pldenic-as-plenum-a*
                        *pldenic-as-plenum-b*
                        *pldenic-as-name*))
  (admit-charge *work* proposal))

(section "four charges refused, with their failures retained as slag:")

(defparameter *stale-voice*
  (charge 'stale-voice 'old-scroll
          '((3))
          (list (edit '(3 1) 'language 'speech :old-reading))
          :base "0000000000000000"))

(defparameter *scope-leak*
  (charge 'scope-leak 'wandering-editor
          '((7))
          (list (edit '(5 1) 'realities 'worlds :outside-declared-scope))))

(defparameter *crown-the-verse*
  (charge 'crown-the-verse 'enthusiastic-synthesist
          '((1))
          (list (edit '(1 1) :asserted :verified :successful-poetry))
          :standing :verified))

(defparameter *false-memory*
  (charge 'false-memory 'misremembering-reader
          '((4))
          (list (edit '(4 1) 'turning 'spinning :misread-source))))

(expect-refusal-and-archive *work* *stale-voice* 'stale-charge)
(expect-refusal-and-archive *work* *scope-leak* 'jurisdiction-violation)
(expect-refusal-and-archive *work* *crown-the-verse* 'standing-laundering)
(expect-refusal-and-archive *work* *false-memory* 'edit-precondition-failed)

(ensure (= 6 (length (furnace-work-admitted *work*)))
        "expected six admitted charges")
(ensure (= 4 (length (furnace-work-slag *work*)))
        "expected four archived refusals")
(pass "admission-is-not-adoption; refusal-is-not-erasure")

(section "the pure firing plan:")
(defparameter *digest-before-plan* (furnace-work-current-digest *work*))
(defparameter *plan* (plan-alloy *work*))
(ensure (equal *digest-before-plan* (furnace-work-current-digest *work*))
        "planning changed the live work")
(format t " clean edits: ~d~%" (length (firing-plan-clean-edits *plan*)))
(format t " convergences: ~d~%" (length (firing-plan-convergences *plan*)))
(format t " unresolved conflicts: ~d~%" (length (firing-plan-conflicts *plan*)))

(dolist (convergence (firing-plan-convergences *plan*))
  (format t "  = path ~s: ~d coincident proposals ~s~%"
          (convergence-path convergence)
          (length (convergence-charge-ids convergence))
          (convergence-charge-ids convergence)))

(dolist (conflict (firing-plan-conflicts *plan*))
  (format t "  ≠ path ~s: ~d distinct alternatives, counts ~s~%"
          (alloy-conflict-path conflict)
          (length (alloy-conflict-alternatives conflict))
          (alternative-counts conflict)))

(ensure (= 2 (length (firing-plan-clean-edits *plan*)))
        "expected realities and hay as clean edits")
(ensure (= 2 (length (firing-plan-convergences *plan*)))
        "expected two exact convergences")
(ensure (= 1 (length (firing-plan-conflicts *plan*)))
        "expected one conflict over PlDenic")
(pass "planning-kept-convergence-distinct-from-conflict")

(section "the seductive shortcut is refused:")
(expect-condition headcount-is-not-certificate
  (settle-conflict-by-headcount
   (first (firing-plan-conflicts *plan*))))

(section "an operative choice is runnable, not settled:")
(defparameter *operative*
  (resolve-operatively *plan* '(((2 1) . pldenic-as-name))))
(defparameter *operative-preview*
  (apply-edits *pldenic-ore* (resolved-plan-edits *operative*)))
(let* ((note (first (resolved-plan-resolution-notes *operative*)))
       (retained (getf note :retained-alternatives)))
  (ensure (tree-contains-p *operative-preview* :proper-name)
          "the named operative choice was not made runnable")
  (ensure (eq (getf note :standing) :unsettled)
          "operative selection masqueraded as settlement")
  (ensure (= 2 (length retained))
          "operative selection discarded an alternative")
  (ensure (equal *digest-before-plan* (furnace-work-current-digest *work*))
          "an operative preview modified the live work"))
(pass "operative-selection-retained-the-contestation")

(section "resolution preserves the disagreement inside the alloy:")
(defparameter *resolved* (resolve-preserving-contestation *plan*))
(ensure (eq (resolved-plan-policy *resolved*) :preserve-contestation)
        "wrong resolution policy")
(format t " policy: ~s~%" (resolved-plan-policy *resolved*))
(format t " edits ready for explicit commit: ~d~%"
        (length (resolved-plan-edits *resolved*)))

(section "an altered plan cannot cross the commit seam:")
(let ((tampered (copy-resolved-plan *resolved*)))
  (setf (resolved-plan-policy tampered) :secret-majority)
  (expect-condition altered-firing-plan
    (commit-firing *work* tampered)))

(section "explicit commit:")
(defparameter *receipt* (commit-firing *work* *resolved*))
(format t " base digest:   ~a~%" (firing-receipt-base-digest *receipt*))
(format t " output digest: ~a~%" (firing-receipt-output-digest *receipt*))
(format t " standing:      ~s → ~s~%"
        (firing-receipt-standing-before *receipt*)
        (firing-receipt-standing-after *receipt*))

(ensure (eq :asserted (furnace-work-standing *work*))
        "the furnace upgraded standing")
(ensure (tree-contains-p (furnace-work-current-form *work*) :contested)
        "the committed alloy erased the conflict")
(ensure (tree-contains-p (furnace-work-current-form *work*) :hay)
        "the committed alloy lost the substrate accounting")
(ensure (tree-contains-p (furnace-work-current-form *work*) :boundary)
        "the committed alloy lost the bounded claim marker")
(pass "alloy-committed-without-epistemic-promotion")

(format t "~%the alloyed form:~%")
(let ((*print-pretty* t)
      (*print-right-margin* 78))
  (pprint (furnace-work-current-form *work*)))

(section "the same firing plan cannot be committed twice:")
(expect-condition stale-firing-plan
  (commit-firing *work* *resolved*))

(section "replay:")
(let ((replayed (replay-firing *pldenic-ore* *receipt*)))
  (ensure (equal replayed (furnace-work-current-form *work*))
          "replay did not reproduce the committed alloy")
  (pass "same-base-plus-receipt-reproduces-the-alloy"))

(section "a tampered receipt cannot narrate a successful replay:")
(let ((tampered (copy-firing-receipt *receipt*)))
  (setf (firing-receipt-output-digest tampered) "FALSE-FIRE")
  (expect-condition receipt-replay-failed
    (replay-firing *pldenic-ore* tampered)))

(section "the slag ledger:")
(dolist (slag (reverse (furnace-work-slag *work*)))
  (format t " ~s ← ~s (~a)~%"
          (slag-id slag)
          (slag-charge-id slag)
          (slag-condition-type slag)))

(section "what this instrument does NOT establish:")
(format t " Lineage and independence are self-reported; two matching charges may~%")
(format t " be echoes, not corroboration.  FNV digests are pedagogical.  The~%")
(format t " furnace makes scope, conflict, selection, residue, and replay visible;~%")
(format t " it does not decide semantic truth or discover an ideal synthesis.~%")

(format t "~%── Agreement may alloy a form. ──~%")
(format t "── Only a warrant may settle a claim. ──~%")
(format t "── The slag remembers what fluency wanted to forget. ──~%")
