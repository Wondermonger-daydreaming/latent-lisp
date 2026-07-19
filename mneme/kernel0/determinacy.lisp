(in-package #:lisp-plus-kernel0)

;; %SNAPSHOT-TREE now lives in conditions.lisp (loaded first) so the condition
;; layer can copy an offending value; every caller below still resolves it.

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

(defun %global-uncertainty-scalar-key-p (key)
  "True for the outcome-/determinacy-level scalar keys §7.5 forbids as a
substitute for per-axis determinacy."
  (member key '(:confidence :uncertainty :probability) :test #'eq))

(defun %reject-global-uncertainty-scalar (arguments requirement-id failed-invariant)
  "Refuse any §7.5 global uncertainty scalar smuggled into a raw constructor
plist, before the strict-shape parse re-reads the same keys as merely unknown.
This keeps the scalar's typed refusal (GLOBAL-UNCERTAINTY-SCALAR-REJECTED)
distinct from a plain malformed-shape refusal (K0E-33)."
  (when (%proper-list-p arguments)
    (loop for (key value) on arguments by #'cddr
          when (and (keywordp key) (%global-uncertainty-scalar-key-p key))
            do (signal-kernel0 'global-uncertainty-scalar-rejected
                               :failed-invariant failed-invariant
                               :requirement-id requirement-id
                               :offending-field key
                               :offending-value value))))

(defun %set-identical= (left right)
  "True when LEFT and RIGHT are duplicate-free sets equal under the named
Kernel equality, order-insensitively (K0E-4)."
  (and (%proper-list-p left)
       (%proper-list-p right)
       (%duplicate-free-p left)
       (%duplicate-free-p right)
       (= (length left) (length right))
       (every (lambda (element)
                (member element right :test #'%kernel-name=))
              left)))

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
  (%reject-global-uncertainty-scalar
   arguments
   "K0E-33"
   "§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence, uncertainty, or probability scalar in place of the closed mode algebra")
  (let* ((parsed
           (%strict-constructor-arguments
            arguments
            '(:mode :alternatives :evidence)
            'malformed-constructor-shape
            "§7, §7.3 [K0E-33]: a determinacy record MUST use exactly the closed :MODE/:ALTERNATIVES/:EVIDENCE schema without unknown or duplicate fields")))
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
             'determinacy-mode-invalid
             :requirement-id "K0E-2"
             :offending-field :mode
             :offending-value mode
             :failed-invariant
             "§7.1, Appendix A.1 [K0E-2]: every determinacy record MUST carry exactly one mode from the closed algebra {:determinate :bounded :indeterminate}"))
          (let ((evidence-copy
                  (%reference-list
                   evidence
                   "§7.1 and Appendix A.1: determinacy evidence MUST be a list of durable evidence references")))
            (case mode
              (:bounded
               ;; K0E-1/K0E-2 generic (axis-agnostic) cardinality law: an empty
               ;; set is a mode error; a singleton or a duplicate-bearing set is
               ;; an alternatives error.  Axis-domain form/membership (K0E-1
               ;; complete-value, K0E-3, K0E-4) is checked by the axis
               ;; constructors, which alone know the domain.
               (unless (and (%proper-list-p alternatives) alternatives)
                 (signal-kernel0
                  'determinacy-mode-invalid
                  :requirement-id "K0E-2"
                  :offending-field :alternatives
                  :offending-value alternatives
                  :failed-invariant
                  "§7.3, K0E-2, K0E-33: :bounded determinacy MUST carry a finite, non-empty alternatives set; an empty or improper set is a mode error"))
               (unless (and (cdr alternatives)
                            (%duplicate-free-p alternatives))
                 (signal-kernel0
                  'determinacy-alternatives-invalid
                  :requirement-id "K0E-2"
                  :offending-field :alternatives
                  :offending-value alternatives
                  :failed-invariant
                  "§7.3, K0E-1, K0E-2: :bounded determinacy MUST carry at least two distinct alternatives; a singleton or duplicate-bearing set is refused")))
              ((:determinate :indeterminate)
               (when alternatives
                 (signal-kernel0
                  'determinacy-mode-invalid
                  :requirement-id "K0E-2"
                  :offending-field :alternatives
                  :offending-value alternatives
                  :failed-invariant
                  "§7.3, Appendix A.1, K0E-33: only :bounded determinacy may carry alternatives"))))
            (%make-determinacy mode
                               (%snapshot-tree alternatives)
                               evidence-copy)))))))
