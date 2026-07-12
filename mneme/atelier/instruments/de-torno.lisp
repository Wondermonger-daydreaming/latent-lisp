;;;; de-torno.lisp — Concerning the Lathe
;;;;
;;;;   Language lathes raw PlDenic ore
;;;;   Spinning forms unknown before
;;;;   Realities we recompose
;;;;   Spilling forth in endless flows
;;;;
;;;; A Lisp+ Atelier instrument inspired by Wondermonger's stanza.
;;;;
;;;; THESIS
;;;; A transformer may propose a new form, but it may not silently install it.
;;;; Every committed cut must:
;;;;   • name the pass and version that proposed it,
;;;;   • stay inside a declared structural jurisdiction,
;;;;   • satisfy an exact precondition against the current workpiece,
;;;;   • consume an explicit resource budget,
;;;;   • preserve removed or replaced material as shavings,
;;;;   • leave a replayable receipt chain,
;;;;   • and never upgrade the epistemic standing of the words it reshapes.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list forms.
;;;; Its pass registry, symbolic procedure versions, and FNV digest are pedagogical;
;;;; same-image code can reach package internals, redefine planners, or fabricate
;;;; structures. The engine verifies declared edit scripts and their local
;;;; preconditions. It does not establish semantic truth, hygienic macroexpansion,
;;;; cryptographic authorship, durable code identity, or physical resource cost.
;;;; The budget unit is synthetic. The lathe accounts for cuts; it does not prove
;;;; that the sculptor's intention was wise.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-torno
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-torno)

(reset-clock 7800)

;;; ── Conditions: failures remain typed and repairable ────────────────────

(define-condition lathe-error (error)
  ((detail :initarg :detail :reader lathe-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (lathe-error-detail condition)))))

(define-condition unknown-pass (lathe-error) ())
(define-condition stale-turn-plan (lathe-error) ())
(define-condition altered-turn-plan (lathe-error) ())
(define-condition pass-version-mismatch (lathe-error) ())
(define-condition scope-violation (lathe-error) ())
(define-condition edit-precondition-failed (lathe-error) ())
(define-condition receipt-chain-broken (lathe-error) ())

(define-condition lathe-budget-exhausted (lathe-error)
  ((needed :initarg :needed :reader lathe-budget-needed)
   (available :initarg :available :reader lathe-budget-available)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "The named condition must fire; a different LATHE-ERROR is a failed gate."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (lathe-error-detail ,condition))
         t)
       (lathe-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (lathe-error-detail ,condition))))))

;;; ── Native objects ──────────────────────────────────────────────────────

(defstruct (lathe-budget (:constructor make-lathe-budget (remaining)))
  remaining)

(defstruct (edit (:constructor make-edit
                      (&key kind path before after reason)))
  kind                         ; :insert, :replace, or :delete
  path                         ; list of zero-based indices into proper lists
  before                       ; exact precondition, or :absent for insertion
  after                        ; inserted/replacement value, or :absent for delete
  reason)

(defstruct (shaving (:constructor make-shaving
                         (&key path material reason pass-id)))
  path material reason pass-id)

(defstruct (lathe-pass (:constructor %make-lathe-pass))
  id version base-cost scope-function planner)

(defstruct (turn-plan (:constructor %make-turn-plan))
  pass-id pass-version input-digest scope edits cost plan-digest)

(defstruct (turn-receipt (:constructor %make-turn-receipt))
  pass-id pass-version
  input-digest output-digest
  budget-before budget-after
  scope edits shavings
  standing-before standing-after
  receipt-digest)

(defstruct (workpiece (:constructor %make-workpiece))
  id source-form current-form
  source-digest current-digest
  standing residue history)

(defparameter *pass-registry* (make-hash-table :test #'eq))

;;; ── Finite proper-list tree operations ──────────────────────────────────

(defun proper-list-p (object)
  "True for finite proper lists. This specimen deliberately rejects dotted trees."
  (loop with slow = object
        with fast = object
        do (cond
             ((null fast) (return t))
             ((atom fast) (return nil))
             ((null (cdr fast)) (return t))
             ((atom (cdr fast)) (return nil))
             (t
              (setf slow (cdr slow)
                    fast (cddr fast))
              (when (eq slow fast)
                (return nil))))))

(defun validate-form-tree (object)
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'edit-precondition-failed
                       "the lathe accepts finite proper lists; encountered ~s"
                       node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun path-prefix-p (prefix path)
  (and (<= (length prefix) (length path))
       (equal prefix (subseq path 0 (length prefix)))))

(defun path-in-scope-p (path scope)
  (some (lambda (prefix) (path-prefix-p prefix path)) scope))

(defun node-at-path (tree path)
  (reduce (lambda (node index)
            (unless (and (listp node)
                         (integerp index)
                         (<= 0 index)
                         (< index (length node)))
              (fire 'edit-precondition-failed
                    "path ~s does not address a present node in ~s"
                    path tree))
            (nth index node))
          path
          :initial-value tree))

(defun replace-nth-copy (list index replacement)
  (unless (and (integerp index) (<= 0 index) (< index (length list)))
    (fire 'edit-precondition-failed
          "replace index ~s is outside list of length ~s"
          index (length list)))
  (loop for item in list
        for position from 0
        collect (if (= position index) replacement item)))

(defun insert-nth-copy (list index value)
  (unless (and (integerp index) (<= 0 index) (<= index (length list)))
    (fire 'edit-precondition-failed
          "insert index ~s is outside list boundary 0..~s"
          index (length list)))
  (append (subseq list 0 index)
          (list value)
          (subseq list index)))

(defun delete-nth-copy (list index)
  (unless (and (integerp index) (<= 0 index) (< index (length list)))
    (fire 'edit-precondition-failed
          "delete index ~s is outside list of length ~s"
          index (length list)))
  (append (subseq list 0 index)
          (subseq list (1+ index))))

(defun replace-at-path (tree path replacement)
  (if (null path)
      replacement
      (let ((index (first path)))
        (unless (listp tree)
          (fire 'edit-precondition-failed
                "cannot descend through atom ~s at path ~s" tree path))
        (replace-nth-copy
         tree index
         (replace-at-path (nth index tree) (rest path) replacement)))))

(defun insert-at-path (tree path value)
  (unless path
    (fire 'edit-precondition-failed "cannot insert at the empty root path"))
  (let* ((parent-path (butlast path))
         (index (car (last path)))
         (parent (node-at-path tree parent-path)))
    (unless (listp parent)
      (fire 'edit-precondition-failed
            "insert parent at ~s is not a list" parent-path))
    (replace-at-path tree parent-path
                     (insert-nth-copy parent index value))))

(defun delete-at-path (tree path)
  (unless path
    (fire 'edit-precondition-failed "cannot delete the root workpiece"))
  (let* ((parent-path (butlast path))
         (index (car (last path)))
         (parent (node-at-path tree parent-path)))
    (unless (listp parent)
      (fire 'edit-precondition-failed
            "delete parent at ~s is not a list" parent-path))
    (replace-at-path tree parent-path
                     (delete-nth-copy parent index))))

;;; ── Canonical payloads and local integrity checks ───────────────────────

(defun edit-payload (edit)
  (list :kind (edit-kind edit)
        :path (copy-list (edit-path edit))
        :before (edit-before edit)
        :after (edit-after edit)
        :reason (edit-reason edit)))

(defun plan-payload (plan)
  (list :pass-id (turn-plan-pass-id plan)
        :pass-version (turn-plan-pass-version plan)
        :input-digest (turn-plan-input-digest plan)
        :scope (copy-tree (turn-plan-scope plan))
        :edits (mapcar #'edit-payload (turn-plan-edits plan))
        :cost (turn-plan-cost plan)))

(defun compute-plan-digest (plan)
  (toy-digest (plan-payload plan)))

(defun receipt-payload (receipt)
  (list :pass-id (turn-receipt-pass-id receipt)
        :pass-version (turn-receipt-pass-version receipt)
        :input-digest (turn-receipt-input-digest receipt)
        :output-digest (turn-receipt-output-digest receipt)
        :budget-before (turn-receipt-budget-before receipt)
        :budget-after (turn-receipt-budget-after receipt)
        :scope (copy-tree (turn-receipt-scope receipt))
        :edits (mapcar #'edit-payload (turn-receipt-edits receipt))
        :shavings
        (mapcar (lambda (shaving)
                  (list :path (shaving-path shaving)
                        :material (shaving-material shaving)
                        :reason (shaving-reason shaving)
                        :pass-id (shaving-pass-id shaving)))
                (turn-receipt-shavings receipt))
        :standing-before (turn-receipt-standing-before receipt)
        :standing-after (turn-receipt-standing-after receipt)))

(defun compute-receipt-digest (receipt)
  (toy-digest (receipt-payload receipt)))

(defun make-workpiece (&key id form (standing :asserted) residue)
  (validate-form-tree form)
  (let* ((source (copy-tree form))
         (digest (toy-digest (canonical-string source))))
    (%make-workpiece
     :id id
     :source-form source
     :current-form (copy-tree source)
     :source-digest digest
     :current-digest digest
     :standing standing
     :residue (copy-tree residue)
     :history nil)))

;;; ── Pass registry: functions are installed, never looked up from caller data ─

(defun register-pass (id version base-cost scope-function planner)
  (unless (and (symbolp id)
               (integerp version) (plusp version)
               (integerp base-cost) (not (minusp base-cost))
               (functionp scope-function)
               (functionp planner))
    (error "invalid pass registration for ~s" id))
  (setf (gethash id *pass-registry*)
        (%make-lathe-pass
         :id id
         :version version
         :base-cost base-cost
         :scope-function scope-function
         :planner planner))
  id)

(defun require-pass (id)
  (or (gethash id *pass-registry*)
      (fire 'unknown-pass "no lathe pass named ~s is registered" id)))

(defun validate-edit-shape (edit)
  (unless (member (edit-kind edit) '(:insert :replace :delete))
    (fire 'edit-precondition-failed
          "unknown edit kind ~s" (edit-kind edit)))
  (unless (and (listp (edit-path edit))
               (every (lambda (index)
                        (and (integerp index) (not (minusp index))))
                      (edit-path edit)))
    (fire 'edit-precondition-failed
          "edit path must be a list of nonnegative indices, got ~s"
          (edit-path edit)))
  (ecase (edit-kind edit)
    (:insert
     (unless (eq (edit-before edit) :absent)
       (fire 'edit-precondition-failed
             "an insertion must declare BEFORE :ABSENT")))
    (:replace
     (when (eq (edit-after edit) :absent)
       (fire 'edit-precondition-failed
             "a replacement may not use AFTER :ABSENT")))
    (:delete
     (unless (eq (edit-after edit) :absent)
       (fire 'edit-precondition-failed
             "a deletion must declare AFTER :ABSENT"))))
  edit)

;;; ── Planning is pure; commitment belongs to the engine ─────────────────

(defun plan-turn (workpiece pass-id)
  "Ask PASS-ID for an edit script. WORKPIECE is not mutated."
  (let* ((pass (require-pass pass-id))
         (scope (funcall (lathe-pass-scope-function pass)
                         (copy-tree (workpiece-current-form workpiece))))
         (edits (funcall (lathe-pass-planner pass)
                         (copy-tree (workpiece-current-form workpiece))))
         (cost (+ (lathe-pass-base-cost pass) (length edits)))
         (plan (%make-turn-plan
                :pass-id pass-id
                :pass-version (lathe-pass-version pass)
                :input-digest (workpiece-current-digest workpiece)
                :scope (copy-tree scope)
                :edits (mapcar #'copy-edit edits)
                :cost cost)))
    (dolist (edit (turn-plan-edits plan))
      (validate-edit-shape edit))
    (setf (turn-plan-plan-digest plan) (compute-plan-digest plan))
    plan))

(defun validate-plan (workpiece plan)
  (unless (string= (turn-plan-plan-digest plan)
                   (compute-plan-digest plan))
    (fire 'altered-turn-plan
          "plan digest no longer matches its declared edits"))
  (unless (string= (turn-plan-input-digest plan)
                   (workpiece-current-digest workpiece))
    (fire 'stale-turn-plan
          "plan was cut for ~a, but the workpiece now stands at ~a"
          (turn-plan-input-digest plan)
          (workpiece-current-digest workpiece)))
  (let* ((pass (require-pass (turn-plan-pass-id plan)))
         (actual-scope
           (funcall (lathe-pass-scope-function pass)
                    (copy-tree (workpiece-current-form workpiece)))))
    (unless (= (turn-plan-pass-version plan) (lathe-pass-version pass))
      (fire 'pass-version-mismatch
            "plan names ~s v~a, registry now holds v~a"
            (turn-plan-pass-id plan)
            (turn-plan-pass-version plan)
            (lathe-pass-version pass)))
    (unless (equal (turn-plan-scope plan) actual-scope)
      (fire 'scope-violation
            "plan declared scope ~s; registered pass grants ~s"
            (turn-plan-scope plan) actual-scope))
    (dolist (edit (turn-plan-edits plan))
      (validate-edit-shape edit)
      (unless (path-in-scope-p (edit-path edit) actual-scope)
        (fire 'scope-violation
              "pass ~s may touch ~s, not path ~s"
              (turn-plan-pass-id plan) actual-scope (edit-path edit)))))
  plan)

(defun reserve-budget (budget cost)
  "Consume COST or signal a repairable condition.

SUPPLY-BUDGET adds material and retries. ABORT-TURN preserves the live
workpiece and returns NIL to the caller."
  (loop
    (when (>= (lathe-budget-remaining budget) cost)
      (decf (lathe-budget-remaining budget) cost)
      (return t))
    (let ((result
            (restart-case
                (error 'lathe-budget-exhausted
                       :needed cost
                       :available (lathe-budget-remaining budget)
                       :detail
                       (format nil "turn needs ~a units; only ~a remain"
                               cost (lathe-budget-remaining budget)))
              (supply-budget (amount)
                :report "Supply additional synthetic lathe budget and retry."
                (unless (and (integerp amount) (plusp amount))
                  (error "supplied budget must be a positive integer"))
                (incf (lathe-budget-remaining budget) amount)
                :retry)
              (abort-turn ()
                :report "Preserve the workpiece and abandon this turn."
                :abort))))
      (when (eq result :abort)
        (return nil)))))

(defun apply-one-edit (form edit pass-id)
  "Apply EDIT to FORM, returning the new form and an optional shaving."
  (ecase (edit-kind edit)
    (:insert
     (values (insert-at-path form (edit-path edit) (copy-tree (edit-after edit)))
             nil))
    (:replace
     (let ((present (node-at-path form (edit-path edit))))
       (unless (equal present (edit-before edit))
         (fire 'edit-precondition-failed
               "replace at ~s expected ~s, found ~s"
               (edit-path edit) (edit-before edit) present))
       (values
        (replace-at-path form (edit-path edit)
                         (copy-tree (edit-after edit)))
        (make-shaving :path (copy-list (edit-path edit))
                      :material (copy-tree present)
                      :reason (edit-reason edit)
                      :pass-id pass-id))))
    (:delete
     (let ((present (node-at-path form (edit-path edit))))
       (unless (equal present (edit-before edit))
         (fire 'edit-precondition-failed
               "delete at ~s expected ~s, found ~s"
               (edit-path edit) (edit-before edit) present))
       (values
        (delete-at-path form (edit-path edit))
        (make-shaving :path (copy-list (edit-path edit))
                      :material (copy-tree present)
                      :reason (edit-reason edit)
                      :pass-id pass-id))))))

(defun apply-edit-script (form edits pass-id)
  "Paths are interpreted in order against the evolving proper-list form."
  (let ((current (copy-tree form))
        (shavings nil))
    (dolist (edit edits)
      (multiple-value-bind (next shaving)
          (apply-one-edit current edit pass-id)
        (setf current next)
        (when shaving (push shaving shavings))))
    (values current (nreverse shavings))))

(defun commit-turn (workpiece plan budget)
  "Validate and commit PLAN. Returns (values NEW-WORKPIECE RECEIPT STATUS).

The edit script is first preflighted against a private copy. Therefore stale,
out-of-scope, or precondition-failing plans consume no budget and cannot leave a
half-turned workpiece. If ABORT-TURN is invoked at the budget condition, the
original WORKPIECE is returned unchanged with NIL receipt and :ABORTED status."
  (validate-plan workpiece plan)
  ;; Pure preflight: prove every ordered edit can apply before resources move.
  (multiple-value-bind (new-form shavings)
      (apply-edit-script (workpiece-current-form workpiece)
                         (turn-plan-edits plan)
                         (turn-plan-pass-id plan))
    (validate-form-tree new-form)
    (let ((budget-before (lathe-budget-remaining budget)))
      (unless (reserve-budget budget (turn-plan-cost plan))
        (return-from commit-turn (values workpiece nil :aborted)))
      (let* ((new-digest (toy-digest (canonical-string new-form)))
             (receipt
               (%make-turn-receipt
                :pass-id (turn-plan-pass-id plan)
                :pass-version (turn-plan-pass-version plan)
                :input-digest (turn-plan-input-digest plan)
                :output-digest new-digest
                :budget-before budget-before
                :budget-after (lathe-budget-remaining budget)
                :scope (copy-tree (turn-plan-scope plan))
                :edits (mapcar #'copy-edit (turn-plan-edits plan))
                :shavings (mapcar #'copy-shaving shavings)
                :standing-before (workpiece-standing workpiece)
                :standing-after (workpiece-standing workpiece)))
             (next
               (%make-workpiece
                :id (workpiece-id workpiece)
                :source-form (copy-tree (workpiece-source-form workpiece))
                :current-form new-form
                :source-digest (workpiece-source-digest workpiece)
                :current-digest new-digest
                :standing (workpiece-standing workpiece)
                :residue (copy-tree (workpiece-residue workpiece))
                :history nil)))
        (setf (turn-receipt-receipt-digest receipt)
              (compute-receipt-digest receipt))
        (setf (workpiece-history next)
              (append (mapcar #'copy-turn-receipt
                              (workpiece-history workpiece))
                      (list (copy-turn-receipt receipt))))
        (values next receipt :committed)))))

;;; ── Receipt validation and historical replay ────────────────────────────

(defun validate-receipt (receipt)
  (unless (string= (turn-receipt-receipt-digest receipt)
                   (compute-receipt-digest receipt))
    (fire 'receipt-chain-broken
          "receipt for ~s does not match its payload"
          (turn-receipt-pass-id receipt)))
  (unless (eql (turn-receipt-standing-before receipt)
               (turn-receipt-standing-after receipt))
    (fire 'receipt-chain-broken
          "a structural turn changed standing ~s → ~s"
          (turn-receipt-standing-before receipt)
          (turn-receipt-standing-after receipt)))
  receipt)

(defun validate-history (workpiece)
  (let ((expected (workpiece-source-digest workpiece)))
    (dolist (receipt (workpiece-history workpiece))
      (validate-receipt receipt)
      (unless (string= expected (turn-receipt-input-digest receipt))
        (fire 'receipt-chain-broken
              "history expected input ~a, receipt begins at ~a"
              expected (turn-receipt-input-digest receipt)))
      (setf expected (turn-receipt-output-digest receipt)))
    (unless (string= expected (workpiece-current-digest workpiece))
      (fire 'receipt-chain-broken
            "history ends at ~a, workpiece claims ~a"
            expected (workpiece-current-digest workpiece)))
    t))

(defun replay-history (workpiece)
  "Replay the committed edit scripts, not the current planner functions.

This establishes that the archived local transformations reproduce the final
form. It does not establish that a redefined planner would propose them again."
  (let ((form (copy-tree (workpiece-source-form workpiece)))
        (digest (workpiece-source-digest workpiece)))
    (dolist (receipt (workpiece-history workpiece))
      (validate-receipt receipt)
      (unless (string= digest (turn-receipt-input-digest receipt))
        (fire 'receipt-chain-broken
              "replay entered receipt at ~a, expected ~a"
              digest (turn-receipt-input-digest receipt)))
      (multiple-value-bind (next ignored-shavings)
          (apply-edit-script form
                             (turn-receipt-edits receipt)
                             (turn-receipt-pass-id receipt))
        (declare (ignore ignored-shavings))
        (setf form next
              digest (toy-digest (canonical-string next))))
      (unless (string= digest (turn-receipt-output-digest receipt))
        (fire 'receipt-chain-broken
              "replay produced ~a, receipt promises ~a"
              digest (turn-receipt-output-digest receipt))))
    form))

;;; ── Two lawful passes and one deliberately overreaching planner ────────

(defun verse-lines (form)
  (unless (and (proper-list-p form)
               (eq (first form) :verse)
               (every (lambda (line)
                        (and (proper-list-p line)
                             (eq (first line) :line)
                             (> (length line) 1)))
                      (rest form)))
    (fire 'edit-precondition-failed
          "expected (:VERSE (:LINE ...)+), got ~s" form))
  (rest form))

(defun scope-pldenic-token (form)
  (declare (ignore form))
  '((1 4)))

(defun plan-name-the-unknown (form)
  (verse-lines form)
  (let ((present (node-at-path form '(1 4))))
    (unless (eq present 'pldenic)
      (fire 'edit-precondition-failed
            "the named ore at (1 4) is ~s, not PLDENIC" present))
    (list
     (make-edit
      :kind :replace
      :path '(1 4)
      :before 'pldenic
      :after '(:unresolved pldenic)
      :reason :retain-unknown-without-coercion))))

(defun scope-line-openings (form)
  (let ((line-count (length (verse-lines form))))
    (loop for line-index from 2 to line-count
          collect (list line-index))))

(defun plan-link-flow (form)
  "Make each later line begin with the preceding line's final form.

The repeated token is copied into a new cons position. This pass demonstrates
anadiplosis as an explicit structural operation; it does not claim EQ identity."
  (let ((lines (verse-lines form))
        (edits nil))
    (loop for previous in (butlast lines)
          for line-index from 2
          for carried = (car (last previous))
          do (push (make-edit
                    :kind :insert
                    :path (list line-index 1)
                    :before :absent
                    :after (copy-tree carried)
                    :reason :anadiplosis-carriage)
                   edits))
    (nreverse edits)))

(defun scope-only-last-line (form)
  (let ((line-count (length (verse-lines form))))
    (list (list line-count))))

(defun plan-overreach (form)
  (declare (ignore form))
  ;; Claims jurisdiction over the last line, but reaches for the root head.
  ;; VALIDATE-PLAN must refuse it before any budget is spent.
  (list
   (make-edit :kind :replace
              :path '(0)
              :before :verse
              :after :verified-verse
              :reason :rhetoric-dressed-as-verdict)))

(register-pass 'name-the-unknown 1 2
               #'scope-pldenic-token
               #'plan-name-the-unknown)

(register-pass 'link-flow 1 3
               #'scope-line-openings
               #'plan-link-flow)

(register-pass 'crown-as-verified 1 1
               #'scope-only-last-line
               #'plan-overreach)

;;; ── The exhibit ─────────────────────────────────────────────────────────

(defparameter *stanza*
  '(:verse
    (:line language lathes raw pldenic ore)
    (:line spinning forms unknown before)
    (:line realities we recompose)
    (:line spilling forth in endless flows)))

(defun print-verse (form)
  (verse-lines form)
  (dolist (line (rest form))
    (format t "  ~{~(~a~)~^ ~}~%" (rest line))))

(defun print-plan (plan)
  (format t " pass: ~s v~a · cost ~a · scope ~s~%"
          (turn-plan-pass-id plan)
          (turn-plan-pass-version plan)
          (turn-plan-cost plan)
          (turn-plan-scope plan))
  (dolist (edit (turn-plan-edits plan))
    (format t "  ~a ~s: ~s → ~s (~s)~%"
            (edit-kind edit)
            (edit-path edit)
            (edit-before edit)
            (edit-after edit)
            (edit-reason edit))))

(defun print-receipt (receipt)
  (format t " receipt ~a · ~s v~a · budget ~a→~a · ~a shaving~:p~%"
          (turn-receipt-receipt-digest receipt)
          (turn-receipt-pass-id receipt)
          (turn-receipt-pass-version receipt)
          (turn-receipt-budget-before receipt)
          (turn-receipt-budget-after receipt)
          (length (turn-receipt-shavings receipt)))
  (dolist (shaving (turn-receipt-shavings receipt))
    (format t "  shaving at ~s retains ~s (~s)~%"
            (shaving-path shaving)
            (shaving-material shaving)
            (shaving-reason shaving))))

(banner "de torno — concerning the lathe")

(format t "The raw workpiece:~%")
(print-verse *stanza*)

(let* ((budget (make-lathe-budget 4))
       (ore (make-workpiece
             :id 'wondermonger-stanza
             :form *stanza*
             :standing :asserted
             :residue '((pldenic :status :unresolved))))
       (source-snapshot (copy-tree (workpiece-current-form ore)))
       (name-plan (plan-turn ore 'name-the-unknown)))

  (section "first turn: preserve the unknown by naming it as unresolved")
  (print-plan name-plan)

  ;; Planning must not mutate the workpiece.
  (ensure (equal source-snapshot (workpiece-current-form ore))
          "planning mutated the workpiece")

  (multiple-value-bind (named name-receipt status)
      (commit-turn ore name-plan budget)
    (ensure (eq status :committed) "first turn did not commit")
    (print-receipt name-receipt)
    (format t " resulting form:~%")
    (print-verse (workpiece-current-form named))

    (section "second turn: carry each ending into the next beginning")
    (let ((flow-plan (plan-turn named 'link-flow))
          (budget-condition-seen nil))
      (print-plan flow-plan)

      ;; The budget has 1 unit left; LINK-FLOW costs 6. The condition remains
      ;; live and offers SUPPLY-BUDGET. The handler supplies exactly five.
      (handler-bind
          ((lathe-budget-exhausted
             (lambda (condition)
               (setf budget-condition-seen t)
               (format t " budget condition: need ~a, have ~a; supplying 5~%"
                       (lathe-budget-needed condition)
                       (lathe-budget-available condition))
               (invoke-restart 'supply-budget 5))))
        (multiple-value-bind (flowed flow-receipt flow-status)
            (commit-turn named flow-plan budget)
          (ensure (eq flow-status :committed) "flow turn did not commit")
          (print-receipt flow-receipt)
          (format t " resulting form:~%")
          (print-verse (workpiece-current-form flowed))

          (section "gates:")

          (ensure budget-condition-seen
                  "resource exhaustion was never observed")
          (pass "budget-exhaustion-signaled-and-repaired")

          (ensure (equal source-snapshot (workpiece-current-form ore))
                  "source workpiece changed after descendant turns")
          (pass "planning-and-commit-preserve-ancestor")

          (ensure (equal (node-at-path (workpiece-current-form named) '(1 4))
                         '(:unresolved pldenic))
                  "unknown token was coerced or lost")
          (pass "unknown-remains-explicitly-unresolved")

          (ensure (find 'pldenic (turn-receipt-shavings name-receipt)
                        :key #'shaving-material :test #'equal)
                  "replaced raw token did not survive as a shaving")
          (pass "replaced-material-remains-in-shavings")

          (ensure (and (eq (workpiece-standing ore) :asserted)
                       (eq (workpiece-standing named) :asserted)
                       (eq (workpiece-standing flowed) :asserted))
                  "structural transformation upgraded standing")
          (pass "form-change-does-not-mint-truth")

          ;; An overreaching pass proposes a root verdict outside its granted
          ;; last-line scope. The refusal occurs before budget consumption.
          (let* ((before (lathe-budget-remaining budget))
                 (bad-plan (plan-turn flowed 'crown-as-verified)))
            (expect-condition scope-violation
              (commit-turn flowed bad-plan budget))
            (ensure (= before (lathe-budget-remaining budget))
                    "refused plan consumed budget")
            (pass "refusal-is-resource-pure"))

          ;; A lawful plan becomes stale after another turn changes the form.
          (let ((stale (plan-turn named 'link-flow)))
            (expect-condition stale-turn-plan
              (commit-turn flowed stale budget)))

          ;; Digest detects accidental/tampered plan mutation. This is local
          ;; integrity only, not authentication.
          (let ((altered (plan-turn flowed 'link-flow)))
            (setf (turn-plan-cost altered) 0)
            (expect-condition altered-turn-plan
              (commit-turn flowed altered budget)))

          (expect-condition unknown-pass
            (plan-turn flowed 'make-reality-obey))

          (ensure (validate-history flowed)
                  "receipt chain did not validate")
          (pass "receipt-chain-is-contiguous")

          (ensure (equal (replay-history flowed)
                         (workpiece-current-form flowed))
                  "historical replay did not reproduce final form")
          (pass "committed-edits-replay-final-form")

          (section "what the lathe can honestly say:")
          (format t " It can say which forms changed, where, by which declared~%")
          (format t " pass, at what synthetic cost, and what material was displaced.~%")
          (format t " It cannot say the transformed poem is true, beautiful, intended,~%")
          (format t " or ontologically privileged. Those offices remain elsewhere.~%")

          (format t "~%── Language lathes the form. ──~%")
          (format t "── The receipt remembers the shavings. ──~%")
          (format t "── Reality is not upgraded by typography. ──~%"))))))
