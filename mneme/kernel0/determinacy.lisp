(in-package #:lisp-plus-kernel0)

(defun %snapshot-tree (value)
  "Copy the mutable tree and string parts of a constructor argument."
  (cond ((consp value)
         (cons (%snapshot-tree (car value))
               (%snapshot-tree (cdr value))))
        ((stringp value) (copy-seq value))
        (t value)))

(defun %strict-constructor-arguments
    (arguments allowed-keys condition-type failed-invariant)
  "Parse an exact keyword plist, refusing unknown and duplicate fields."
  (unless (and (%proper-list-p arguments) (evenp (length arguments)))
    (signal-kernel0 condition-type :failed-invariant failed-invariant))
  (loop with seen = nil
        for (key value) on arguments by #'cddr
        unless (and (keywordp key)
                    (member key allowed-keys :test #'eq)
                    (not (member key seen :test #'eq)))
          do (signal-kernel0 condition-type
                             :failed-invariant failed-invariant)
        do (push key seen)
        collect (cons key value)))

(defun %constructor-argument (parsed key &optional default)
  (let ((entry (assoc key parsed :test #'eq)))
    (if entry
        (values (cdr entry) t)
        (values default nil))))

(defun %reference-identity (value failed-invariant)
  "Require a durable reference without inventing an :EVIDENCE domain.

The reference retains its existing recognized domain.  Fields whose domain is
specified more narrowly call REQUIRE-IDENTITY directly instead."
  (unless (durable-identity-p value)
    (signal-kernel0 'unresolved-identity
                    :failed-invariant failed-invariant))
  (require-identity value (durable-identity-domain value)))

(defun %reference-list
    (value failed-invariant &key non-empty expected-domain)
  (unless (and (%proper-list-p value)
               (or (not non-empty) value))
    (signal-kernel0 'standing-inflation
                    :failed-invariant failed-invariant))
  (dolist (reference value)
    (if expected-domain
        (require-identity reference expected-domain)
        (%reference-identity reference failed-invariant)))
  (%snapshot-tree value))

(defun %kernel-name= (left right)
  (if (and (durable-identity-p left) (durable-identity-p right))
      (identity= left right)
      (equal left right)))

(defun %duplicate-free-p (values)
  (loop for tail on values
        never (member (car tail) (cdr tail) :test #'%kernel-name=)))

(defstruct (determinacy
            (:constructor %make-determinacy (mode alternatives evidence))
            (:copier nil)
            (:conc-name %determinacy-))
  (mode nil :read-only t)
  (alternatives nil :read-only t)
  (evidence nil :read-only t))

(defun determinacy-mode (determinacy)
  (%determinacy-mode determinacy))

(defun determinacy-alternatives (determinacy)
  (%snapshot-tree (%determinacy-alternatives determinacy)))

(defun determinacy-evidence (determinacy)
  (%snapshot-tree (%determinacy-evidence determinacy)))

(defun make-determinacy (&rest arguments)
  "Construct one immutable section 7 determinacy record.

No outcome-level or determinacy-level probability/confidence scalar is an
accepted field."
  (let* ((parsed
           (%strict-constructor-arguments
            arguments
            '(:mode :alternatives :evidence)
            'standing-inflation
            "§7, §7.3, and §7.5: determinacy MUST use the closed mode algebra, bounded alternatives law, and no global uncertainty scalar")))
    (multiple-value-bind (mode mode-supplied-p)
        (%constructor-argument parsed :mode)
      (multiple-value-bind (alternatives alternatives-supplied-p)
          (%constructor-argument parsed :alternatives)
        (declare (ignore alternatives-supplied-p))
        (multiple-value-bind (evidence evidence-supplied-p)
            (%constructor-argument parsed :evidence nil)
          (declare (ignore evidence-supplied-p))
          (unless (and mode-supplied-p
                       (member mode
                               '(:determinate :bounded :indeterminate)
                               :test #'eq))
            (signal-kernel0
             'standing-inflation
             :failed-invariant
             "§7.1 and Appendix A.1: every determinacy record MUST carry exactly one closed determinacy mode"))
          (let ((evidence-copy
                  (%reference-list
                   evidence
                   "§7.1 and Appendix A.1: determinacy evidence MUST be a list of durable evidence references")))
            (case mode
              (:bounded
               (unless (and (%proper-list-p alternatives)
                            alternatives
                            (%duplicate-free-p alternatives))
                 (signal-kernel0
                  'standing-inflation
                  :failed-invariant
                  "§7.3: :bounded determinacy MUST carry a finite, non-empty, duplicate-free alternatives list")))
              ((:determinate :indeterminate)
               (when alternatives
                 (signal-kernel0
                  'standing-inflation
                  :failed-invariant
                  "§7.3 and Appendix A.1: only :bounded determinacy may carry alternatives"))))
            (%make-determinacy mode
                               (%snapshot-tree alternatives)
                               evidence-copy)))))))
