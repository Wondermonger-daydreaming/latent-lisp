;;;; garden.lisp --- Botanical jurisprudence for executable S-expressions
;;;;
;;;; The implementation deliberately depends only on ANSI Common Lisp.
;;;; Receipts are ordinary lists, not opaque instances: they can be READ,
;;;; WRITE, diffed, archived, searched, and used as graft donors.

(in-package #:s-expression-garden)

;;; ---------------------------------------------------------------------------
;;; The deliberately small operator ecology

(defun garden-add (left right)
  (+ left right))

(defun garden-sub (left right)
  (- left right))

(defun garden-mul (left right)
  (* left right))

(defun garden-div (left right)
  (/ left right))

(defun garden-concat (left right)
  (concatenate 'string left right))

(defun garden-spin ()
  "A specimen of non-termination.  The budgeted evaluator intercepts this
operator before this definition is called; native invocation is refused."
  (error "GARDEN-SPIN may only be examined by the budgeted garden evaluator."))

(defparameter *default-operator-specs*
  (list
   (list 'garden-add
         :arity '(:min 2 :max 2)
         :arguments '(:number :number)
         :result :number)
   (list 'garden-sub
         :arity '(:min 2 :max 2)
         :arguments '(:number :number)
         :result :number)
   (list 'garden-mul
         :arity '(:min 2 :max 2)
         :arguments '(:number :number)
         :result :number)
   (list 'garden-div
         :arity '(:min 2 :max 2)
         :arguments '(:number :number)
         :result :number)
   (list 'garden-concat
         :arity '(:min 2 :max 2)
         :arguments '(:string :string)
         :result :string)
   (list 'garden-spin
         :arity '(:min 0 :max 0)
         :arguments nil
         :result :number)
   (list 'list
         :arity '(:min 0 :max nil)
         :arguments nil
         :rest-argument :any
         :result :list)
   (list 'cons
         :arity '(:min 2 :max 2)
         :arguments '(:any :any)
         :result :list)
   (list 'car
         :arity '(:min 1 :max 1)
         :arguments '(:list)
         :result :any)
   (list 'cdr
         :arity '(:min 1 :max 1)
         :arguments '(:list)
         :result :list)
   (list 'length
         :arity '(:min 1 :max 1)
         :arguments '(:sequence)
         :result :integer)
   (list 'not
         :arity '(:min 1 :max 1)
         :arguments '(:any)
         :result :boolean)
   (list '=
         :arity '(:min 2 :max nil)
         :arguments nil
         :rest-argument :number
         :result :boolean)
   (list '<
         :arity '(:min 2 :max nil)
         :arguments nil
         :rest-argument :number
         :result :boolean)
   (list '<=
         :arity '(:min 2 :max nil)
         :arguments nil
         :rest-argument :number
         :result :boolean)
   (list '>
         :arity '(:min 2 :max nil)
         :arguments nil
         :rest-argument :number
         :result :boolean)
   (list '>=
         :arity '(:min 2 :max nil)
         :arguments nil
         :rest-argument :number
         :result :boolean)
   (list 'equal
         :arity '(:min 2 :max 2)
         :arguments '(:any :any)
         :result :boolean)))

(defparameter *default-policy*
  '(:capture-policy :forbid
    :new-free-symbol-policy :forbid
    :unknown-operator-policy :forbid
    :provenance-policy :acyclic
    :behavior-policy :contract
    :default-step-budget 500))

(defparameter *graft-rulebook*
  '((:precedence 10
     :jurisdiction :identity
     :rule :unknown-donor
     :when :donor-identity-is-absent
     :disposition :refuse)
    (:precedence 20
     :jurisdiction :identity
     :rule :unknown-recipient
     :when :recipient-identity-is-absent
     :disposition :refuse)
    (:precedence 30
     :jurisdiction :cut
     :rule :malformed-donor-path
     :when :donor-cut-does-not-resolve
     :disposition :refuse)
    (:precedence 40
     :jurisdiction :cut
     :rule :malformed-recipient-path
     :when :recipient-cut-does-not-resolve
     :disposition :refuse)
    (:precedence 50
     :jurisdiction :provenance
     :rule :circular-provenance
     :when :ancestry-edge-would-create-cycle
     :disposition :refuse)
    (:precedence 60
     :jurisdiction :structural-quarantine
     :rule :structural-malformation
     :when :transplant-or-candidate-is-not-a-readable-tree
     :disposition :refuse)
    (:precedence 70
     :jurisdiction :static-audit
     :rule :contract-shape-violation
     :when :candidate-breaks-recipient-shape-contract
     :disposition :refuse)
    (:precedence 80
     :jurisdiction :lexical-audit
     :rule :free-symbol-capture
     :when :transplant-free-symbol-would-become-bound
     :disposition :refuse)
    (:precedence 90
     :jurisdiction :lexical-audit
     :rule :new-unbound-symbol
     :when :candidate-introduces-unlicensed-free-symbol
     :disposition :refuse)
    (:precedence 100
     :jurisdiction :static-audit
     :rule :arity-violation
     :when :known-call-or-binding-has-illegal-arity
     :disposition :refuse)
    (:precedence 110
     :jurisdiction :static-audit
     :rule :unknown-operator-domain
     :when :operator-is-unknown-or-non-callable
     :disposition :refuse)
    (:precedence 120
     :jurisdiction :static-audit
     :rule :operator-domain-mismatch
     :when :abstract-domains-are-incompatible
     :disposition :refuse)
    (:precedence 130
     :jurisdiction :behavioral-quarantine
     :rule :behavioral-catastrophe
     :when :probe-errors-times-out-or-breaks-contract
     :disposition :refuse)
    (:precedence 140
     :jurisdiction :commit
     :rule :all-rules-satisfied
     :when :all-prior-jurisdictions-consent
     :disposition :accept
     :commit-semantics :copy-on-write)))

(defun graft-rulebook ()
  "Return a fresh S-expression describing the protocol's precedence law."
  (deep-copy-sexp *graft-rulebook*))

;;; ---------------------------------------------------------------------------
;;; Data structures.  Specimens are structures; receipts emphatically are not.

(defstruct (specimen
            (:constructor %make-specimen
                (&key id form contract (revision 0) provenance history)))
  id
  form
  contract
  (revision 0 :type integer)
  provenance
  history)

(defstruct (garden
            (:constructor %make-garden
                (&key id specimens receipts counter operator-specs
                      provenance-edges policy)))
  id
  specimens
  receipts
  (counter 0 :type integer)
  operator-specs
  provenance-edges
  policy)

(defun make-garden (&key (id :s-expression-garden)
                         (operator-specs *default-operator-specs*)
                         (policy *default-policy*))
  (%make-garden
   :id id
   :specimens (make-hash-table :test #'equal)
   :receipts nil
   :counter 0
   :operator-specs (copy-tree operator-specs)
   :provenance-edges (make-hash-table :test #'equal)
   :policy (copy-tree policy)))

(defun garden-specimen-ids (garden)
  (let (ids)
    (maphash (lambda (id specimen)
               (declare (ignore specimen))
               (push id ids))
             (garden-specimens garden))
    (sort ids #'string< :key #'canonical-sexp-string)))

(defun find-specimen (garden identity)
  (gethash identity (garden-specimens garden)))

(defun remove-specimen (garden identity)
  (remhash identity (garden-specimens garden)))

;;; ---------------------------------------------------------------------------
;;; Stable representation and hashes

(defun canonical-sexp-string (object)
  "Return a deterministic, readable representation suitable for hashing.
The KEYWORD package is used as the print context so non-keyword symbols are
package-qualified instead of depending on the caller's current package."
  (with-standard-io-syntax
    (let ((*package* (find-package :keyword))
          (*print-array* t)
          (*print-base* 10)
          (*print-case* :upcase)
          (*print-circle* t)
          (*print-escape* t)
          (*print-gensym* t)
          (*print-length* nil)
          (*print-level* nil)
          (*print-pretty* nil)
          (*print-radix* nil)
          (*print-readably* t))
      (write-to-string object))))

(defun stable-sexp-hash (object)
  "A stable 64-bit FNV-1a-derived hash over the canonical printed form.
Each character code is fed as four octets, avoiding implementation-specific
SXHASH behavior and keeping replay comparisons stable across processes."
  (let ((hash #xcbf29ce484222325)
        (prime #x100000001b3)
        (mask #xffffffffffffffff))
    (loop for character across (canonical-sexp-string object)
          for code = (char-code character)
          do (dotimes (octet 4)
               (setf hash (logxor hash (ldb (byte 8 (* octet 8)) code)))
               (setf hash (logand mask (* hash prime)))))
    (format nil "~16,'0X" hash)))

(defun specimen-hash (specimen)
  (stable-sexp-hash (specimen-form specimen)))

(defun deep-copy-sexp (object)
  "Copy an S-expression, de-sharing ordinary DAGs while preserving genuine
cycles.  Garden organisms are trees, so repeated acyclic cons cells become
independent branches.  A circular malformed request is nevertheless copied as
evidence instead of detonating the receipt machinery."
  (let ((active (make-hash-table :test #'eq)))
    (labels ((copy-one (value)
               (typecase value
                 (cons
                  (multiple-value-bind (existing active-p)
                      (gethash value active)
                    (if active-p
                        existing
                        (let ((copy (cons nil nil)))
                          (setf (gethash value active) copy)
                          (setf (car copy) (copy-one (car value))
                                (cdr copy) (copy-one (cdr value)))
                          (remhash value active)
                          copy))))
                 (string (copy-seq value))
                 (t value))))
      (copy-one object))))

;;; ---------------------------------------------------------------------------
;;; List shape, tree shape, and path surgery

(defun list-shape (object)
  "Classify OBJECT as :PROPER, :DOTTED, or :CIRCULAR."
  (cond
    ((null object) :proper)
    ((atom object) :dotted)
    (t
     (let ((slow object)
           (fast object))
       (loop
         (cond
           ((null fast) (return :proper))
           ((atom fast) (return :dotted))
           ((null (cdr fast)) (return :proper))
           ((atom (cdr fast)) (return :dotted)))
         (setf slow (cdr slow)
               fast (cddr fast))
         (when (eq slow fast)
           (return :circular)))))))

(defun path-valid-p (path)
  "Return two values: validity and, on failure, an inspectable reason."
  (let ((shape (list-shape path)))
    (cond
      ((not (eq shape :proper))
       (values nil (list :kind :path-is-not-a-proper-list :shape shape)))
      (t
       (loop for component in path
             for position from 0
             unless (and (integerp component) (not (minusp component)))
               do (return-from path-valid-p
                    (values nil
                            (list :kind :path-component-is-not-a-nonnegative-integer
                                  :position position
                                  :component component))))
       (values t nil)))))

(defun inspect-path (tree path)
  "Return subtree, success flag, and reason.  This function never signals for
an ordinary bad path.  Child index zero is the CAR/operator of a list."
  (multiple-value-bind (valid reason) (path-valid-p path)
    (unless valid
      (return-from inspect-path (values nil nil reason))))
  (let ((current tree)
        (prefix nil))
    (dolist (index path (values current t nil))
      (unless (and (consp current) (eq (list-shape current) :proper))
        (return-from inspect-path
          (values nil nil
                  (list :kind :path-descends-through-non-list
                        :at-prefix (reverse prefix)
                        :encountered current))))
      (let ((size (length current)))
        (when (>= index size)
          (return-from inspect-path
            (values nil nil
                    (list :kind :path-index-out-of-range
                          :at-prefix (reverse prefix)
                          :index index
                          :list-length size))))
        (push index prefix)
        (setf current (nth index current))))))

(define-condition garden-path-error (error)
  ((path :initarg :path :reader garden-path-error-path)
   (reason :initarg :reason :reader garden-path-error-reason))
  (:report (lambda (condition stream)
             (format stream "Invalid garden path ~S: ~S"
                     (garden-path-error-path condition)
                     (garden-path-error-reason condition)))))

(defun subtree-at (tree path)
  (multiple-value-bind (subtree success reason) (inspect-path tree path)
    (if success
        subtree
        (error 'garden-path-error :path path :reason reason))))

(defun %replace-subtree (tree path replacement)
  (if (null path)
      (deep-copy-sexp replacement)
      (let ((index (first path)))
        (loop for child in tree
              for child-index from 0
              collect (if (= child-index index)
                          (%replace-subtree child (rest path) replacement)
                          (deep-copy-sexp child))))))

(defun replace-subtree (tree path replacement)
  "Purely replace PATH in TREE.  TREE is never destructively modified."
  (multiple-value-bind (ignored success reason) (inspect-path tree path)
    (declare (ignore ignored))
    (unless success
      (error 'garden-path-error :path path :reason reason)))
  (%replace-subtree tree path replacement))

(defun structural-issues (tree)
  "Return structural violations.  Garden forms are proper, acyclic trees made
of readable atoms; shared cons cells are rejected because provenance speaks of
trees, not graphs wearing foliage."
  (let ((seen (make-hash-table :test #'eq))
        (issues nil))
    (labels ((walk (node path)
               (cond
                 ((consp node)
                  (let ((state (gethash node seen)))
                    (cond
                      ((eq state :visiting)
                       (push (list :kind :circular-tree :path path) issues))
                      ((eq state :done)
                       (push (list :kind :shared-cons-cell :path path) issues))
                      (t
                       (setf (gethash node seen) :visiting)
                       (let ((shape (list-shape node)))
                         (cond
                           ((eq shape :circular)
                            (push (list :kind :circular-list :path path) issues))
                           ((eq shape :dotted)
                            (push (list :kind :dotted-list :path path) issues))
                           (t
                            (loop for child in node
                                  for index from 0
                                  do (walk child (append path (list index)))))))
                       (setf (gethash node seen) :done)))))
                 ((and (symbolp node) (null (symbol-package node)))
                  (push (list :kind :uninterned-symbol
                              :path path
                              :symbol-name (symbol-name node))
                        issues))
                 (t
                  (handler-case
                      (progn (canonical-sexp-string node) nil)
                    (error (condition)
                      (push (list :kind :unreadable-atom
                                  :path path
                                  :printed (princ-to-string node)
                                  :condition (princ-to-string condition))
                            issues)))))))
      (walk tree nil))
    (nreverse issues)))

(defun tree-node-count (tree)
  (if (consp tree)
      (1+ (loop for child in tree sum (tree-node-count child)))
      1))

(defun tree-depth (tree)
  (if (consp tree)
      (1+ (if tree
              (loop for child in tree maximize (tree-depth child))
              0))
      1))

(defun all-paths (tree)
  "Return every valid node path in preorder, including NIL for the root."
  (when (structural-issues tree)
    (error "ALL-PATHS requires a proper acyclic tree."))
  (labels ((walk (node path)
             (cons path
                   (when (consp node)
                     (loop for child in node
                           for index from 0
                           append (walk child (append path (list index))))))))
    (walk tree nil)))

(defun operators-in (tree)
  (let ((operators nil))
    (labels ((walk (node)
               (when (consp node)
                 (when (symbolp (car node))
                   (pushnew (car node) operators :test #'eq))
                 (unless (eq (car node) 'quote)
                   (dolist (child (cdr node))
                     (walk child))))))
      (walk tree))
    (sort operators #'string< :key #'canonical-sexp-string)))

;;; ---------------------------------------------------------------------------
;;; Lexical analysis: free value symbols and binders at a graft site

(defparameter *lambda-list-keywords*
  '(&allow-other-keys &aux &body &environment &key &optional &rest &whole))

(defun lambda-list-keyword-p (symbol)
  (and (symbolp symbol)
       (member symbol *lambda-list-keywords* :test #'eq)))

(defun lambda-entry-variables (entry)
  (cond
    ((symbolp entry)
     (if (lambda-list-keyword-p entry) nil (list entry)))
    ((consp entry)
     (let ((head (first entry))
           (supplied (third entry)))
       (remove nil
               (list (cond
                       ((symbolp head) head)
                       ((and (consp head) (symbolp (second head)))
                        (second head))
                       (t nil))
                     (and (symbolp supplied) supplied)))))
    (t nil)))

(defun lambda-list-variables (lambda-list)
  (let (variables)
    (when (eq (list-shape lambda-list) :proper)
      (dolist (entry lambda-list)
        (dolist (variable (lambda-entry-variables entry))
          (unless (lambda-list-keyword-p variable)
            (pushnew variable variables :test #'eq)))))
    (nreverse variables)))

(defun binding-name (binding)
  (cond
    ((symbolp binding) binding)
    ((and (consp binding) (symbolp (first binding))) (first binding))
    (t nil)))

(defun constant-value-symbol-p (symbol)
  (or (null symbol)
      (eq symbol t)
      (keywordp symbol)
      (and (eq (symbol-package symbol) (find-package :common-lisp))
           (ignore-errors (constantp symbol)))))

(defun sorted-symbol-set (symbols)
  (sort (remove-duplicates symbols :test #'eq)
        #'string< :key #'canonical-sexp-string))

(defun free-value-symbols (form &optional initial-bound)
  "Conservative lexical free-variable analysis for the garden's executable
subset.  Function-position symbols are operators, not value references."
  (let ((free nil))
    (labels
        ((note (symbol bound)
           (unless (or (member symbol bound :test #'eq)
                       (constant-value-symbol-p symbol))
             (pushnew symbol free :test #'eq)))
         (walk-body (body bound)
           (dolist (form body)
             (unless (and (consp form) (eq (car form) 'declare))
               (walk form bound))))
         (walk-let (form bound sequential-p)
           (let ((bindings (second form))
                 (body (cddr form))
                 (current-bound bound)
                 (names nil))
             (when (eq (list-shape bindings) :proper)
               (dolist (binding bindings)
                 (let ((name (binding-name binding))
                       (initializer (and (consp binding) (second binding))))
                   (when initializer
                     (walk initializer current-bound))
                   (when name
                     (push name names)
                     (when sequential-p
                       (pushnew name current-bound :test #'eq))))))
             (walk-body body
                        (if sequential-p
                            current-bound
                            (append names bound)))))
         (walk (expression bound)
           (cond
             ((symbolp expression)
              (note expression bound))
             ((atom expression) nil)
             (t
              (let ((operator (car expression)))
                (cond
                  ((eq operator 'quote) nil)
                  ((eq operator 'function)
                   (let ((argument (second expression)))
                     (when (and (consp argument) (eq (car argument) 'lambda))
                       (walk argument bound))))
                  ((eq operator 'lambda)
                   (let ((parameters (lambda-list-variables (second expression))))
                     (walk-body (cddr expression) (append parameters bound))))
                  ((eq operator 'let)
                   (walk-let expression bound nil))
                  ((eq operator 'let*)
                   (walk-let expression bound t))
                  ((eq operator 'setq)
                   (loop for (variable value) on (cdr expression) by #'cddr
                         do (when variable
                              (when (symbolp variable) (note variable bound))
                              (when value (walk value bound)))))
                  ((member operator '(multiple-value-bind destructuring-bind)
                           :test #'eq)
                   (walk (third expression) bound)
                   (let ((variables
                           (if (eq operator 'multiple-value-bind)
                               (remove-if #'lambda-list-keyword-p
                                          (second expression))
                               (lambda-list-variables (second expression)))))
                     (walk-body (cdddr expression) (append variables bound))))
                  (t
                   ;; The CAR is a function namespace occurrence.  Arguments
                   ;; are value expressions and may contain free variables.
                   (dolist (argument (cdr expression))
                     (walk argument bound)))))))))
      (walk form initial-bound))
    (sorted-symbol-set free)))

(defun lexical-context-for-child (form child-index bound)
  (if (not (consp form))
      bound
      (case (car form)
        (lambda
         (if (>= child-index 2)
             (append (lambda-list-variables (second form)) bound)
             bound))
        ((let let*)
         (if (>= child-index 2)
             (append (remove nil (mapcar #'binding-name (second form))) bound)
             bound))
        (multiple-value-bind
         (if (>= child-index 3)
             (append (second form) bound)
             bound))
        (destructuring-bind
         (if (>= child-index 3)
             (append (lambda-list-variables (second form)) bound)
             bound))
        (otherwise bound))))

(defun bindings-at-path (form path)
  "Return lexical value bindings active at PATH."
  (multiple-value-bind (ignored success reason) (inspect-path form path)
    (declare (ignore ignored))
    (unless success
      (error 'garden-path-error :path path :reason reason)))
  (let ((current form)
        (bound nil))
    (dolist (index path (sorted-symbol-set bound))
      (setf bound (lexical-context-for-child current index bound))
      (setf current (nth index current)))))

;;; ---------------------------------------------------------------------------
;;; Operator, arity, and domain audits

(defun operator-spec (operator specs)
  (assoc operator specs :test #'eq))

(defun special-form-arity-issue (operator argument-count path)
  (flet ((outside (minimum maximum)
           (or (< argument-count minimum)
               (and maximum (> argument-count maximum))))
         (issue (minimum maximum)
           (list :kind :arity-violation
                 :path path
                 :operator operator
                 :observed argument-count
                 :expected (list :min minimum :max maximum))))
    (case operator
      (quote (when (outside 1 1) (issue 1 1)))
      (function (when (outside 1 1) (issue 1 1)))
      (lambda (when (outside 1 nil) (issue 1 nil)))
      (if (when (outside 2 3) (issue 2 3)))
      ((let let*) (when (outside 1 nil) (issue 1 nil)))
      ((progn and or) nil)
      (setq (when (or (< argument-count 2) (oddp argument-count))
              (issue 2 nil)))
      (otherwise nil))))

(defun known-special-form-p (symbol)
  (member symbol
          '(quote function lambda if let let* progn and or setq declare
            multiple-value-bind destructuring-bind)
          :test #'eq))

(defun arity-and-operator-issues (form specs)
  (let ((issues nil))
    (labels
        ((walk-body (body base-index path)
           (loop for child in body
                 for index from base-index
                 do (walk child (append path (list index)))))
         (walk (node path)
           (when (consp node)
             (let* ((operator (car node))
                    (arguments (cdr node))
                    (count (length arguments)))
               (cond
                 ((and (symbolp operator) (known-special-form-p operator))
                  (let ((issue (special-form-arity-issue operator count path)))
                    (when issue (push issue issues)))
                  (case operator
                    (quote nil)
                    (function
                     (let ((argument (second node)))
                       (when (and (consp argument) (eq (car argument) 'lambda))
                         (walk argument (append path '(1))))))
                    (lambda
                     (unless (eq (list-shape (second node)) :proper)
                       (push (list :kind :malformed-lambda-list
                                   :path (append path '(1)))
                             issues))
                     (walk-body (cddr node) 2 path))
                    ((let let*)
                     (let ((bindings (second node)))
                       (if (eq (list-shape bindings) :proper)
                           (loop for binding in bindings
                                 for binding-index from 0
                                 do (when (and (consp binding)
                                               (second binding))
                                      (walk (second binding)
                                            (append path
                                                    (list 1 binding-index 1)))))
                           (push (list :kind :malformed-binding-list
                                       :path (append path '(1)))
                                 issues)))
                     (walk-body (cddr node) 2 path))
                    (declare nil)
                    (otherwise
                     (walk-body arguments 1 path))))
                 ((consp operator)
                  (walk operator (append path '(0)))
                  (walk-body arguments 1 path))
                 ((symbolp operator)
                  (let ((spec (operator-spec operator specs)))
                    (if spec
                        (let* ((arity (getf (cdr spec) :arity))
                               (minimum (getf arity :min))
                               (maximum (getf arity :max)))
                          (when (or (< count minimum)
                                    (and maximum (> count maximum)))
                            (push (list :kind :arity-violation
                                        :path path
                                        :operator operator
                                        :observed count
                                        :expected (deep-copy-sexp arity))
                                  issues)))
                        (push (list :kind :unknown-operator
                                    :path path
                                    :operator operator)
                              issues)))
                  (walk-body arguments 1 path))
                 (t
                  (push (list :kind :non-callable-operator
                              :path path
                              :operator operator)
                        issues)
                  (walk-body arguments 1 path)))))))
      (walk form nil))
    (nreverse issues)))

(defun literal-domain (value)
  (cond
    ((null value) :null)
    ((eq value t) :boolean)
    ((integerp value) :integer)
    ((numberp value) :number)
    ((stringp value) :string)
    ((characterp value) :character)
    ((consp value) :list)
    ((symbolp value) :symbol)
    (t :unknown)))

(defun domain-compatible-p (actual expected)
  (or (eq expected :any)
      (eq actual :unknown)
      (eq actual expected)
      (and (eq actual :integer) (eq expected :number))
      (and (eq actual :null)
           (member expected '(:list :sequence :boolean) :test #'eq))
      (and (eq actual :string) (eq expected :sequence))
      (and (eq actual :list) (eq expected :sequence))))

(defun join-domains (left right)
  (cond
    ((eq left right) left)
    ((and (member left '(:integer :number) :test #'eq)
          (member right '(:integer :number) :test #'eq))
     :number)
    ((eq left :unknown) right)
    ((eq right :unknown) left)
    (t :any)))

(defun expected-argument-domain (spec index)
  (let ((fixed (getf (cdr spec) :arguments))
        (rest-domain (getf (cdr spec) :rest-argument)))
    (or (nth index fixed) rest-domain :any)))

(defun infer-domain (expression environment specs path)
  "Return inferred domain and a list of inspectable domain issues."
  (cond
    ((symbolp expression)
     (values (or (cdr (assoc expression environment :test #'eq))
                 (and (constant-value-symbol-p expression)
                      (literal-domain expression))
                 :unknown)
             nil))
    ((atom expression)
     (values (literal-domain expression) nil))
    (t
     (let ((operator (car expression)))
       (case operator
         (quote
          (values (literal-domain (second expression)) nil))
         (function
          (values :function nil))
         (lambda
          (let* ((variables (lambda-list-variables (second expression)))
                 (new-environment
                   (append (mapcar (lambda (variable)
                                     (cons variable :any))
                                   variables)
                           environment))
                 (issues nil))
            (dolist (body-form (cddr expression))
              (unless (and (consp body-form) (eq (car body-form) 'declare))
                (multiple-value-bind (ignored body-issues)
                    (infer-domain body-form new-environment specs path)
                  (declare (ignore ignored))
                  (setf issues (nconc issues body-issues)))))
            (values :function issues)))
         (if
          (multiple-value-bind (test-domain test-issues)
              (infer-domain (second expression) environment specs
                            (append path '(1)))
            (declare (ignore test-domain))
            (multiple-value-bind (then-domain then-issues)
                (infer-domain (third expression) environment specs
                              (append path '(2)))
              (multiple-value-bind (else-domain else-issues)
                  (if (fourth expression)
                      (infer-domain (fourth expression) environment specs
                                    (append path '(3)))
                      (values :null nil))
                (values (join-domains then-domain else-domain)
                        (nconc test-issues then-issues else-issues))))))
         ((progn and or)
          (let ((domain :null)
                (issues nil))
            (loop for child in (cdr expression)
                  for index from 1
                  do (multiple-value-bind (child-domain child-issues)
                         (infer-domain child environment specs
                                       (append path (list index)))
                       (setf domain child-domain
                             issues (nconc issues child-issues))))
            (values (if (member operator '(and or) :test #'eq)
                        (join-domains domain :boolean)
                        domain)
                    issues)))
         ((let let*)
          (let ((new-environment environment)
                (issues nil)
                (sequential-p (eq operator 'let*)))
            (dolist (binding (second expression))
              (let ((name (binding-name binding))
                    (initializer (and (consp binding) (second binding))))
                (multiple-value-bind (initializer-domain initializer-issues)
                    (if initializer
                        (infer-domain initializer new-environment specs path)
                        (values :null nil))
                  (setf issues (nconc issues initializer-issues))
                  (when (and name sequential-p)
                    (push (cons name initializer-domain) new-environment)))))
            (unless sequential-p
              (dolist (binding (second expression))
                (let ((name (binding-name binding))
                      (initializer (and (consp binding) (second binding))))
                  (when name
                    (multiple-value-bind (initializer-domain ignored)
                        (if initializer
                            (infer-domain initializer environment specs path)
                            (values :null nil))
                      (declare (ignore ignored))
                      (push (cons name initializer-domain) new-environment))))))
            (let ((domain :null))
              (dolist (body-form (cddr expression))
                (unless (and (consp body-form) (eq (car body-form) 'declare))
                  (multiple-value-bind (body-domain body-issues)
                      (infer-domain body-form new-environment specs path)
                    (setf domain body-domain
                          issues (nconc issues body-issues)))))
              (values domain issues))))
         (otherwise
          (if (symbolp operator)
              (let ((spec (operator-spec operator specs)))
                (if spec
                    (let ((issues nil))
                      (loop for argument in (cdr expression)
                            for argument-index from 0
                            for path-index from 1
                            do (multiple-value-bind (actual argument-issues)
                                   (infer-domain argument environment specs
                                                 (append path (list path-index)))
                                 (setf issues (nconc issues argument-issues))
                                 (let ((expected
                                         (expected-argument-domain
                                          spec argument-index)))
                                   (unless (domain-compatible-p actual expected)
                                     (push (list :kind :argument-domain-mismatch
                                                 :path (append path
                                                               (list path-index))
                                                 :operator operator
                                                 :argument-index argument-index
                                                 :actual actual
                                                 :expected expected)
                                           issues)))))
                      (values (getf (cdr spec) :result)
                              (nreverse issues)))
                    (values :unknown
                            (list (list :kind :unknown-operator-domain
                                        :path path
                                        :operator operator)))))
              (values :unknown
                      (list (list :kind :non-symbolic-operator-domain
                                  :path path
                                  :operator operator))))))))))

(defun contract-parameter-environment (form contract)
  (let ((declared (getf contract :parameters)))
    (cond
      (declared
       (mapcar (lambda (entry)
                 (cons (first entry) (second entry)))
               declared))
      ((and (consp form) (eq (car form) 'lambda))
       (mapcar (lambda (variable) (cons variable :any))
               (lambda-list-variables (second form))))
      (t nil))))

(defun domain-audit (form contract specs)
  (let ((environment (contract-parameter-environment form contract))
        (expected-result (getf contract :result))
        (issues nil)
        (domain :unknown))
    (if (and (consp form) (eq (car form) 'lambda))
        (dolist (body-form (cddr form))
          (unless (and (consp body-form) (eq (car body-form) 'declare))
            (multiple-value-bind (body-domain body-issues)
                (infer-domain body-form environment specs nil)
              (setf domain body-domain
                    issues (nconc issues body-issues)))))
        (multiple-value-setq (domain issues)
          (infer-domain form environment specs nil)))
    (when (and expected-result
               (not (domain-compatible-p domain expected-result)))
      (setf issues
            (nconc issues
                   (list (list :kind :result-domain-mismatch
                               :actual domain
                               :expected expected-result)))))
    (list :inferred-result domain :issues issues)))

(defun contract-shape-issues (form contract)
  (let ((kind (or (getf contract :kind) :executable))
        (issues nil))
    (when (eq kind :executable)
      (unless (and (consp form) (eq (car form) 'lambda))
        (push (list :kind :expected-lambda-root :encountered form) issues))
      (when (and (consp form) (eq (car form) 'lambda))
        (let ((declared (getf contract :parameters))
              (actual (lambda-list-variables (second form))))
          (when (and declared (/= (length declared) (length actual)))
            (push (list :kind :lambda-parameter-count-mismatch
                        :expected (length declared)
                        :actual (length actual))
                  issues)))))
    (nreverse issues)))

;;; ---------------------------------------------------------------------------
;;; A budgeted evaluator for behavioral quarantine

(define-condition evaluation-budget-exhausted (error)
  ((budget :initarg :budget :reader exhausted-budget)
   (used :initarg :used :reader exhausted-used))
  (:report (lambda (condition stream)
             (format stream "Garden evaluation exhausted its budget of ~D steps."
                     (exhausted-budget condition)))))

(defun runtime-operator-function (operator)
  (case operator
    (garden-add #'garden-add)
    (garden-sub #'garden-sub)
    (garden-mul #'garden-mul)
    (garden-div #'garden-div)
    (garden-concat #'garden-concat)
    (list #'list)
    (cons #'cons)
    (car #'car)
    (cdr #'cdr)
    (length #'length)
    (not #'not)
    (= #'=)
    (< #'<)
    (<= #'<=)
    (> #'>)
    (>= #'>=)
    (equal #'equal)
    (otherwise nil)))

(defun evaluate-garden-form (form arguments &key (budget 500))
  "Evaluate the garden's safe executable subset with a deterministic step
budget.  Return two values: result and steps used."
  (let ((remaining budget)
        (used 0))
    (labels
        ((consume ()
           (when (<= remaining 0)
             (error 'evaluation-budget-exhausted
                    :budget budget :used used))
           (decf remaining)
           (incf used))
         (lookup (symbol environment)
           (let ((entry (assoc symbol environment :test #'eq)))
             (cond
               (entry (cdr entry))
               ((constant-value-symbol-p symbol)
                (symbol-value symbol))
               (t (error "Unbound garden value symbol ~S." symbol)))))
         (eval-sequence (body environment)
           (let ((value nil))
             (dolist (form body value)
               (unless (and (consp form) (eq (car form) 'declare))
                 (setf value (ev form environment))))))
         (eval-let (expression environment sequential-p)
           (let ((new-environment environment)
                 (pending nil))
             (dolist (binding (second expression))
               (let* ((name (binding-name binding))
                      (initializer (and (consp binding) (second binding)))
                      (value (if initializer
                                 (ev initializer new-environment)
                                 nil)))
                 (if sequential-p
                     (push (cons name value) new-environment)
                     (push (cons name value) pending))))
             (unless sequential-p
               (setf new-environment (append pending environment)))
             (eval-sequence (cddr expression) new-environment)))
         (ev (expression environment)
           (consume)
           (cond
             ((symbolp expression) (lookup expression environment))
             ((atom expression) expression)
             (t
              (let ((operator (car expression)))
                (case operator
                  (quote (second expression))
                  (if (if (ev (second expression) environment)
                          (ev (third expression) environment)
                          (if (fourth expression)
                              (ev (fourth expression) environment)
                              nil)))
                  (progn (eval-sequence (cdr expression) environment))
                  (and
                   (let ((value t))
                     (dolist (form (cdr expression) value)
                       (setf value (ev form environment))
                       (unless value (return nil)))))
                  (or
                   (dolist (form (cdr expression) nil)
                     (let ((value (ev form environment)))
                       (when value (return value)))))
                  (let (eval-let expression environment nil))
                  (let* (eval-let expression environment t))
                  (garden-spin
                   ;; The weed is perfectly typed and perfectly aritied.  It
                   ;; simply consumes the court's patience forever—or until
                   ;; the budget bailiff arrives.
                   (loop (consume)))
                  (otherwise
                   (let ((function (runtime-operator-function operator)))
                     (unless function
                       (error "Operator ~S is not executable in the garden sandbox."
                              operator))
                     (apply function
                            (mapcar (lambda (argument)
                                      (ev argument environment))
                                    (cdr expression)))))))))))
      (unless (and (consp form) (eq (car form) 'lambda))
        (error "Behavioral probes require a LAMBDA-rooted executable specimen."))
      (let ((parameters (lambda-list-variables (second form))))
        (unless (= (length parameters) (length arguments))
          (error "Probe supplied ~D arguments to a ~D-argument specimen."
                 (length arguments) (length parameters)))
        (let ((value (eval-sequence
                      (cddr form)
                      (pairlis parameters arguments))))
          (values value used))))))

(defun value-domain (value)
  (literal-domain value))

(defun expectation-satisfied-p (value expectation)
  (cond
    ((null expectation) t)
    ((not (consp expectation)) nil)
    (t
     (case (first expectation)
       (:equals (equal value (second expectation)))
       (:type (domain-compatible-p (value-domain value)
                                   (second expectation)))
       (:range (and (numberp value)
                    (<= (second expectation) value)
                    (<= value (third expectation))))
       (:one-of (member value (rest expectation) :test #'equal))
       (:predicate
        (case (second expectation)
          (:nonnegative (and (numberp value) (not (minusp value))))
          (:positive (and (numberp value) (plusp value)))
          (:truthy (not (null value)))
          (:proper-list (eq (list-shape value) :proper))
          (otherwise nil)))
       (otherwise nil)))))

(defun condition-symbol (condition)
  (let ((type (type-of condition)))
    (if (symbolp type) type (class-name (class-of condition)))))

(defun run-probe (form probe budget)
  (let ((arguments (deep-copy-sexp (getf probe :args)))
        (expectation (deep-copy-sexp (getf probe :expect))))
    (handler-case
        (multiple-value-bind (value steps)
            (evaluate-garden-form form arguments :budget budget)
          (list :args arguments
                :outcome :returned
                :value (deep-copy-sexp value)
                :steps steps
                :expectation expectation
                :satisfied (expectation-satisfied-p value expectation)))
      (evaluation-budget-exhausted (condition)
        (list :args arguments
              :outcome :budget-exhausted
              :condition (condition-symbol condition)
              :message (princ-to-string condition)
              :steps (exhausted-used condition)
              :expectation expectation
              :satisfied nil))
      (error (condition)
        (list :args arguments
              :outcome :error
              :condition (condition-symbol condition)
              :message (princ-to-string condition)
              :expectation expectation
              :satisfied nil)))))

(defun run-probes (form contract policy)
  (let ((probes (getf contract :probes))
        (budget (or (getf contract :step-budget)
                    (getf policy :default-step-budget)
                    500)))
    (mapcar (lambda (probe) (run-probe form probe budget)) probes)))

(defun probe-observation (report)
  (list :args (getf report :args)
        :outcome (getf report :outcome)
        :value (getf report :value)
        :condition (getf report :condition)))

(defun behavioral-audit (before-form after-form contract policy)
  (let* ((mode (or (getf contract :behavior-mode)
                   (getf policy :behavior-policy)
                   :contract))
         (before (run-probes before-form contract policy))
         (after (run-probes after-form contract policy))
         (issues nil)
         (changes nil))
    (loop for before-report in before
          for after-report in after
          for index from 0
          do (unless (equal (probe-observation before-report)
                            (probe-observation after-report))
               (push (list :probe index
                           :before (probe-observation before-report)
                           :after (probe-observation after-report))
                     changes))
             (case mode
               (:observe nil)
               (:preserve
                (unless (and (eq (getf after-report :outcome) :returned)
                             (eq (getf before-report :outcome) :returned)
                             (equal (getf before-report :value)
                                    (getf after-report :value))
                             (getf after-report :satisfied))
                  (push (list :kind :behavior-not-preserved
                              :probe index
                              :before before-report
                              :after after-report)
                        issues)))
               (otherwise
                (unless (and (eq (getf after-report :outcome) :returned)
                             (getf after-report :satisfied))
                  (push (list :kind :behavioral-catastrophe
                              :probe index
                              :report after-report)
                        issues)))))
    (list :mode mode
          :before before
          :after after
          :changes (nreverse changes)
          :issues (nreverse issues))))

;;; ---------------------------------------------------------------------------
;;; Provenance graph

(defun provenance-neighbors (garden identity)
  (copy-list (gethash identity (garden-provenance-edges garden))))

(defun provenance-reachable-p (garden start target)
  (let ((seen (make-hash-table :test #'equal)))
    (labels ((visit (node)
               (cond
                 ((equal node target) t)
                 ((gethash node seen) nil)
                 (t
                  (setf (gethash node seen) t)
                  (some #'visit (gethash node
                                        (garden-provenance-edges garden)))))))
      (visit start))))

(defun provenance-cycle-would-form-p (garden donor recipient)
  (or (equal donor recipient)
      (provenance-reachable-p garden donor recipient)))

(defun add-provenance-edge (garden recipient donor)
  (pushnew donor (gethash recipient (garden-provenance-edges garden))
           :test #'equal)
  garden)

(defun provenance-edges-as-sexp (garden)
  (let (edges)
    (maphash (lambda (recipient donors)
               (push (cons (deep-copy-sexp recipient)
                           (sort (mapcar #'deep-copy-sexp donors)
                                 #'string< :key #'canonical-sexp-string))
                     edges))
             (garden-provenance-edges garden))
    (sort edges #'string< :key (lambda (entry)
                                (canonical-sexp-string (car entry))))))

(defun restore-provenance-edges (garden edges)
  (clrhash (garden-provenance-edges garden))
  (dolist (entry edges garden)
    (setf (gethash (deep-copy-sexp (car entry))
                   (garden-provenance-edges garden))
          (mapcar #'deep-copy-sexp (cdr entry)))))

(defun provenance-edges-with-edge (edges recipient donor)
  "Return the canonical edge alist that would result from RECIPIENT taking
DONOR as a provenance parent.  The input is not mutated."
  (let* ((copy (deep-copy-sexp edges))
         (entry (assoc recipient copy :test #'equal)))
    (if entry
        (pushnew (deep-copy-sexp donor) (cdr entry) :test #'equal)
        (push (cons (deep-copy-sexp recipient)
                    (list (deep-copy-sexp donor)))
              copy))
    (dolist (edge copy)
      (setf (cdr edge)
            (sort (cdr edge) #'string< :key #'canonical-sexp-string)))
    (sort copy #'string<
          :key (lambda (edge)
                 (canonical-sexp-string (car edge))))))

(defun provenance-graph-cycles (garden)
  (let ((state (make-hash-table :test #'equal))
        (cycles nil))
    (labels ((visit (node trail)
               (case (gethash node state)
                 (:visiting
                  (push (list :kind :provenance-cycle
                              :trail (reverse (cons node trail)))
                        cycles))
                 (:done nil)
                 (otherwise
                  (setf (gethash node state) :visiting)
                  (dolist (neighbor
                           (gethash node (garden-provenance-edges garden)))
                    (visit neighbor (cons node trail)))
                  (setf (gethash node state) :done)))))
      (dolist (id (garden-specimen-ids garden))
        (visit id nil)))
    (nreverse cycles)))

;;; ---------------------------------------------------------------------------
;;; Specimen registration

(defun register-specimen (garden identity form contract
                          &key (revision 0) provenance history replace)
  (when (and (find-specimen garden identity) (not replace))
    (error "A specimen named ~S is already planted." identity))
  (let ((issues (structural-issues form)))
    (when issues
      (error "Cannot plant structurally malformed specimen ~S: ~S"
             identity issues)))
  (let ((specimen (%make-specimen
                   :id (deep-copy-sexp identity)
                   :form (deep-copy-sexp form)
                   :contract (deep-copy-sexp contract)
                   :revision revision
                   :provenance (deep-copy-sexp provenance)
                   :history (deep-copy-sexp history))))
    (setf (gethash identity (garden-specimens garden)) specimen)
    specimen))

;;; ---------------------------------------------------------------------------
;;; Receipts and graft protocol

(defun receipt-field (receipt key &optional default)
  (if (and (consp receipt) (eq (car receipt) :graft-receipt))
      (getf (cdr receipt) key default)
      default))

(defun receipt-id (receipt)
  (receipt-field receipt :id))

(defun receipt-status (receipt)
  (getf (receipt-field receipt :decision) :status))

(defun receipt-rule (receipt)
  (getf (receipt-field receipt :decision) :rule))

(defun receipt->string (receipt)
  (canonical-sexp-string receipt))

(defun write-receipt (receipt destination)
  "Write one readable receipt.  DESTINATION may be a stream or pathname."
  (labels ((emit (stream)
             (with-standard-io-syntax
               (let ((*package* (find-package :keyword))
                     (*print-circle* t)
                     (*print-pretty* nil)
                     (*print-readably* t))
                 (write receipt :stream stream :escape t :readably t)
                 (terpri stream)))))
    (if (streamp destination)
        (emit destination)
        (with-open-file (stream destination
                                :direction :output
                                :if-exists :append
                                :if-does-not-exist :create)
          (emit stream))))
  receipt)

(defun read-receipt (source)
  "Read one receipt without permitting #. read-time evaluation."
  (labels ((read-one (stream)
             (with-standard-io-syntax
               (let ((*read-eval* nil))
                 (read stream nil nil)))))
    (if (streamp source)
        (read-one source)
        (with-open-file (stream source :direction :input)
          (read-one stream)))))

(defun make-receipt-id (garden attempt-number)
  (list :receipt (deep-copy-sexp (garden-id garden)) attempt-number))

(defun make-decision (status rule stage &optional details)
  (list :status status
        :rule rule
        :stage stage
        :details (deep-copy-sexp details)))

(defun form-or-unavailable (specimen)
  (if specimen (deep-copy-sexp (specimen-form specimen)) :unavailable))

(defun contract-or-unavailable (specimen)
  (if specimen (deep-copy-sexp (specimen-contract specimen)) :unavailable))

(defun revision-or-unavailable (specimen)
  (if specimen (specimen-revision specimen) :unavailable))

(defun hash-or-unavailable (specimen)
  (if specimen (specimen-hash specimen) :unavailable))

(defun set-difference-eq (left right)
  (remove-if (lambda (item) (member item right :test #'eq)) left))

(defun intersection-eq (left right)
  (remove-if-not (lambda (item) (member item right :test #'eq)) left))

(defun structural-consequences (before candidate target transplant)
  (let ((before-operators (operators-in before))
        (after-operators (operators-in candidate)))
    (list :target (deep-copy-sexp target)
          :transplant (deep-copy-sexp transplant)
          :nodes-before (tree-node-count before)
          :nodes-after (tree-node-count candidate)
          :node-delta (- (tree-node-count candidate)
                         (tree-node-count before))
          :depth-before (tree-depth before)
          :depth-after (tree-depth candidate)
          :operators-added (set-difference after-operators before-operators
                                           :test #'eq)
          :operators-removed (set-difference before-operators after-operators
                                             :test #'eq))))

(defun receipt-record (garden attempt-number donor-id donor-path recipient-id
                       recipient-path donor recipient transplant target candidate
                       decision consequences post-form post-revision edges-before
                       edges-after)
  (let* ((donor-pre-hash (hash-or-unavailable donor))
         (recipient-pre-hash (hash-or-unavailable recipient))
         (candidate-hash (if (eq candidate :unavailable)
                             :unavailable
                             (stable-sexp-hash candidate)))
         (post-hash (if (eq post-form :unavailable)
                        :unavailable
                        (stable-sexp-hash post-form))))
    (deep-copy-sexp
     (list
      :graft-receipt
      :schema 1
      :id (make-receipt-id garden attempt-number)
      :protocol :s-expression-garden/1
      :attempt attempt-number
      :garden-id (deep-copy-sexp (garden-id garden))
      :request
      (list :operation :graft
            :donor-id (deep-copy-sexp donor-id)
            :donor-cut-path (deep-copy-sexp donor-path)
            :recipient-id (deep-copy-sexp recipient-id)
            :recipient-cut-path (deep-copy-sexp recipient-path))
      :donor
      (list :identity (deep-copy-sexp donor-id)
            :revision (revision-or-unavailable donor)
            :cut-path (deep-copy-sexp donor-path)
            :pre-hash donor-pre-hash)
      :recipient
      (list :identity (deep-copy-sexp recipient-id)
            :revision-before (revision-or-unavailable recipient)
            :revision-after post-revision
            :cut-path (deep-copy-sexp recipient-path)
            :pre-hash recipient-pre-hash)
      :transplant (deep-copy-sexp transplant)
      :excised-target (deep-copy-sexp target)
      :candidate-form (deep-copy-sexp candidate)
      :post-form (deep-copy-sexp post-form)
      :hashes
      (list :donor-pre donor-pre-hash
            :recipient-pre recipient-pre-hash
            :candidate candidate-hash
            :recipient-post post-hash)
      :decision (deep-copy-sexp decision)
      :consequences (deep-copy-sexp consequences)
      :snapshots
      (list :donor-form (form-or-unavailable donor)
            :donor-contract (contract-or-unavailable donor)
            :donor-revision (revision-or-unavailable donor)
            :recipient-form (form-or-unavailable recipient)
            :recipient-contract (contract-or-unavailable recipient)
            :recipient-revision (revision-or-unavailable recipient))
      :provenance
      (list
       :engine '(:system :s-expression-garden
                 :release "0.1.0"
                 :protocol :s-expression-garden/1)
       :rulebook (graft-rulebook)
       :policy (deep-copy-sexp (garden-policy garden))
       :operator-specs (deep-copy-sexp (garden-operator-specs garden))
       :edges-before (deep-copy-sexp edges-before)
       :edges-after (deep-copy-sexp edges-after)
       :parents
       (remove nil
               (list
                (and donor
                     (list :identity (deep-copy-sexp donor-id)
                           :revision (specimen-revision donor)
                           :hash donor-pre-hash))
                (and recipient
                     (list :identity (deep-copy-sexp recipient-id)
                           :revision (specimen-revision recipient)
                           :hash recipient-pre-hash))))
       :replay (list :function 'replay-receipt
                     :schema 1))))))

(defun archive-receipt (garden receipt)
  (setf (garden-receipts garden)
        (append (garden-receipts garden) (list receipt)))
  receipt)

(defun %attempt-graft-core (garden donor-id donor-path recipient-id recipient-path
                            attempt-number record-p)
  (let* ((donor (find-specimen garden donor-id))
         (recipient (find-specimen garden recipient-id))
         (edges-before (provenance-edges-as-sexp garden))
         (transplant :unavailable)
         (target :unavailable)
         (candidate :unavailable)
         (post-form (if recipient
                        (deep-copy-sexp (specimen-form recipient))
                        :unavailable))
         (post-revision (revision-or-unavailable recipient))
         (consequences nil)
         (decision nil))
    (labels
        ((finish-refusal (rule stage details)
           (setf decision (make-decision :refused rule stage details))
           (let ((receipt
                   (receipt-record
                    garden attempt-number donor-id donor-path recipient-id
                    recipient-path donor recipient transplant target candidate
                    decision consequences post-form post-revision edges-before
                    edges-before)))
             (when record-p (archive-receipt garden receipt))
             (return-from %attempt-graft-core receipt)))
         (finish-acceptance ()
           (setf decision
                 (make-decision :accepted :all-rules-satisfied :commit
                                '(:finding :graft-lawful))
                 post-form (deep-copy-sexp candidate)
                 post-revision (1+ (specimen-revision recipient)))
           ;; The receipt is minted while both organisms still stand in their
           ;; pre-graft state.  This matters: replay evidence must not be a
           ;; photograph taken after the gardener has already moved the branch.
           (let* ((edges-after
                    (provenance-edges-with-edge
                     edges-before recipient-id donor-id))
                  (receipt
                    (receipt-record
                     garden attempt-number donor-id donor-path recipient-id
                     recipient-path donor recipient transplant target candidate
                     decision consequences post-form post-revision edges-before
                     edges-after)))
             ;; Commit only after every court has consented and the complete
             ;; pre-state receipt exists in memory.
             (setf (specimen-form recipient) (deep-copy-sexp candidate)
                   (specimen-revision recipient) post-revision)
             (add-provenance-edge garden recipient-id donor-id)
             (push (list :receipt (receipt-id receipt)
                         :donor (deep-copy-sexp donor-id)
                         :donor-revision (specimen-revision donor)
                         :donor-hash (specimen-hash donor))
                   (specimen-provenance recipient))
             (setf (specimen-history recipient)
                   (append (specimen-history recipient)
                           (list (receipt-id receipt))))
             (when record-p (archive-receipt garden receipt))
             (return-from %attempt-graft-core receipt))))
      ;; Jurisdiction and identity
      (unless donor
        (finish-refusal :unknown-donor :identity
                        (list :identity donor-id)))
      (unless recipient
        ;; The recipient has no legal identity, but the donor offer may still
        ;; be perfectly knowable.  Preserve that exact proposed branch in the
        ;; refusal receipt whenever its cut resolves.
        (multiple-value-bind (subtree success reason)
            (inspect-path (specimen-form donor) donor-path)
          (declare (ignore reason))
          (when success
            (setf transplant (deep-copy-sexp subtree))))
        (finish-refusal :unknown-recipient :identity
                        (list :identity recipient-id)))

      ;; The cuts themselves
      (multiple-value-bind (subtree success reason)
          (inspect-path (specimen-form donor) donor-path)
        (unless success
          (finish-refusal :malformed-donor-path :cut reason))
        (setf transplant (deep-copy-sexp subtree)))
      (multiple-value-bind (old-target success reason)
          (inspect-path (specimen-form recipient) recipient-path)
        (unless success
          (finish-refusal :malformed-recipient-path :cut reason))
        (setf target (deep-copy-sexp old-target)))

      ;; Provenance cannot eat its own tail.
      (when (and (eq (getf (garden-policy garden) :provenance-policy) :acyclic)
                 (provenance-cycle-would-form-p garden donor-id recipient-id))
        (finish-refusal :circular-provenance :provenance
                        (list :would-add-edge
                              (list recipient-id donor-id)
                              :edges-before edges-before)))

      ;; Candidate construction is purely functional.
      (setf candidate
            (replace-subtree (specimen-form recipient)
                             recipient-path transplant))

      ;; Structural quarantine
      (let ((transplant-issues (structural-issues transplant))
            (candidate-issues (structural-issues candidate)))
        (when (or transplant-issues candidate-issues)
          (setf consequences
                (list :structural
                      (list :transplant-issues transplant-issues
                            :candidate-issues candidate-issues)))
          (finish-refusal :structural-malformation :structural-quarantine
                          (list :transplant-issues transplant-issues
                                :candidate-issues candidate-issues))))

      (let* ((contract (specimen-contract recipient))
             (kind (or (getf contract :kind) :executable))
             (shape-issues (contract-shape-issues candidate contract))
             ;; Data specimens are not accidentally put on trial as programs.
             ;; This exemption is what lets a receipt be planted and later
             ;; grafted whole into an archival ledger.
             (subtree-free
               (if (eq kind :data) nil (free-value-symbols transplant)))
             (recipient-bindings
               (if (eq kind :data)
                   nil
                   (bindings-at-path (specimen-form recipient) recipient-path)))
             (captured (intersection-eq subtree-free recipient-bindings))
             (before-free
               (if (eq kind :data)
                   nil
                   (free-value-symbols (specimen-form recipient))))
             (after-free
               (if (eq kind :data) nil (free-value-symbols candidate)))
             (allowed-globals (getf contract :globals))
             (new-free (set-difference-eq
                        after-free (append before-free allowed-globals)))
             (arity-issues
               (if (eq kind :data)
                   nil
                   (arity-and-operator-issues
                    candidate (garden-operator-specs garden))))
             (unknown-operator-issues
               (remove-if-not
                (lambda (issue)
                  (member (getf issue :kind)
                          '(:unknown-operator :non-callable-operator)
                          :test #'eq))
                arity-issues))
             (proper-arity-issues
               (remove-if-not
                (lambda (issue)
                  (member (getf issue :kind)
                          '(:arity-violation :malformed-lambda-list
                            :malformed-binding-list)
                          :test #'eq))
                arity-issues))
             (domain-report
               (if (eq kind :data)
                   '(:inferred-result :list :issues nil)
                   (domain-audit candidate contract
                                 (garden-operator-specs garden))))
             (domain-issues (getf domain-report :issues))
             (behavior-report
               (if (or (eq kind :data) (null (getf contract :probes)))
                   '(:mode :observe :before nil :after nil
                     :changes nil :issues nil)
                   (behavioral-audit (specimen-form recipient)
                                     candidate contract
                                     (garden-policy garden))))
             (behavior-issues (getf behavior-report :issues)))
        (setf consequences
              (list
               :structural
               (structural-consequences (specimen-form recipient)
                                        candidate target transplant)
               :lexical
               (list :transplant-free-symbols subtree-free
                     :recipient-bindings-at-site recipient-bindings
                     :captured-symbols captured
                     :free-symbols-before before-free
                     :free-symbols-after after-free
                     :new-free-symbols new-free)
               :contract
               (list :shape-issues shape-issues)
               :arity
               (list :issues proper-arity-issues
                     :operator-issues unknown-operator-issues)
               :domain domain-report
               :behavior behavior-report))

        (when shape-issues
          (finish-refusal :contract-shape-violation :static-audit
                          shape-issues))
        (when (and captured
                   (eq (getf (garden-policy garden) :capture-policy) :forbid))
          (finish-refusal :free-symbol-capture :lexical-audit
                          (list :captured captured
                                :subtree-free subtree-free
                                :recipient-bindings recipient-bindings)))
        (when (and new-free
                   (eq (getf (garden-policy garden)
                             :new-free-symbol-policy)
                       :forbid))
          (finish-refusal :new-unbound-symbol :lexical-audit
                          (list :new-free-symbols new-free)))
        (when proper-arity-issues
          (finish-refusal :arity-violation :static-audit
                          proper-arity-issues))
        (when (and unknown-operator-issues
                   (eq (getf (garden-policy garden)
                             :unknown-operator-policy)
                       :forbid))
          (finish-refusal :unknown-operator-domain :static-audit
                          unknown-operator-issues))
        (when domain-issues
          (finish-refusal :operator-domain-mismatch :static-audit
                          domain-issues))
        (when behavior-issues
          (finish-refusal :behavioral-catastrophe :behavioral-quarantine
                          behavior-issues)))
      (finish-acceptance))))

(defun make-emergency-receipt (garden attempt-number donor-id donor-path
                               recipient-id recipient-path condition)
  (let* ((donor (find-specimen garden donor-id))
         (recipient (find-specimen garden recipient-id))
         (edges (provenance-edges-as-sexp garden))
         (post-form (if recipient
                        (deep-copy-sexp (specimen-form recipient))
                        :unavailable)))
    (receipt-record
     garden attempt-number donor-id donor-path recipient-id recipient-path
     donor recipient :unavailable :unavailable :unavailable
     (make-decision :refused :internal-protocol-error :protocol
                    (list :condition (condition-symbol condition)
                          :message (princ-to-string condition)))
     (list :protocol-error (princ-to-string condition))
     post-form (revision-or-unavailable recipient) edges edges)))

(defun %attempt-graft (garden donor-id donor-path recipient-id recipient-path
                       &key (record-p t) forced-attempt-number)
  (let* ((attempt-number
           (or forced-attempt-number (1+ (garden-counter garden))))
         ;; The ordinary protocol is written so that no condition should escape,
         ;; but the outer court keeps a rollback snapshot anyway.  An unexpected
         ;; failure during commit must become a refusal, not a half-grafted ghost.
         (recipient-before (find-specimen garden recipient-id))
         (recipient-form-before
           (and recipient-before
                (deep-copy-sexp (specimen-form recipient-before))))
         (recipient-revision-before
           (and recipient-before (specimen-revision recipient-before)))
         (recipient-provenance-before
           (and recipient-before
                (deep-copy-sexp (specimen-provenance recipient-before))))
         (recipient-history-before
           (and recipient-before
                (deep-copy-sexp (specimen-history recipient-before))))
         (edges-before (provenance-edges-as-sexp garden))
         (archive-before (garden-receipts garden)))
    (unless forced-attempt-number
      (setf (garden-counter garden) attempt-number))
    (handler-case
        (%attempt-graft-core garden donor-id donor-path recipient-id
                             recipient-path attempt-number record-p)
      (error (condition)
        ;; Restore every cell the commit phase is permitted to change.  The
        ;; attempt counter deliberately stays advanced: the failed hearing did
        ;; happen and receives the next chronological receipt number.
        (when recipient-before
          (setf (specimen-form recipient-before)
                (deep-copy-sexp recipient-form-before)
                (specimen-revision recipient-before)
                recipient-revision-before
                (specimen-provenance recipient-before)
                (deep-copy-sexp recipient-provenance-before)
                (specimen-history recipient-before)
                (deep-copy-sexp recipient-history-before)))
        (restore-provenance-edges garden edges-before)
        (setf (garden-receipts garden) archive-before)
        (let ((receipt
                (make-emergency-receipt
                 garden attempt-number donor-id donor-path recipient-id
                 recipient-path condition)))
          (when record-p (archive-receipt garden receipt))
          receipt)))))

(defun attempt-graft (garden donor-id donor-cut-path recipient-id
                       recipient-cut-path)
  "Attempt one transplant and always return a receipt S-expression.
The recipient mutates only after every static and behavioral rule consents."
  (%attempt-graft garden donor-id donor-cut-path recipient-id
                  recipient-cut-path :record-p t))

(defun plant-receipt (garden receipt &key identity)
  "Plant RECEIPT itself as a data specimen, making its subtrees available to
future grafts."
  (let ((name (or identity
                  (list :receipt-specimen (deep-copy-sexp (receipt-id receipt))))))
    (register-specimen
     garden name receipt
     '(:kind :data :result :list :behavior-mode :observe))
    name))

;;; ---------------------------------------------------------------------------
;;; Replay

(defun snapshot-value (receipt key)
  (getf (receipt-field receipt :snapshots) key))

(defun replay-receipt (receipt)
  "Replay RECEIPT from its self-contained snapshots and return a replay report.
The report includes a newly adjudicated receipt and explicit comparison checks."
  (let* ((request (receipt-field receipt :request))
         (provenance (receipt-field receipt :provenance))
         (garden
           (make-garden
            :id (receipt-field receipt :garden-id)
            :operator-specs (getf provenance :operator-specs)
            :policy (getf provenance :policy)))
         (donor-id (getf request :donor-id))
         (recipient-id (getf request :recipient-id))
         (donor-form (snapshot-value receipt :donor-form))
         (recipient-form (snapshot-value receipt :recipient-form)))
    (restore-provenance-edges garden (getf provenance :edges-before))
    (unless (eq donor-form :unavailable)
      (register-specimen
       garden donor-id donor-form
       (snapshot-value receipt :donor-contract)
       :revision (snapshot-value receipt :donor-revision)))
    (unless (eq recipient-form :unavailable)
      (if (equal donor-id recipient-id)
          (let ((same (find-specimen garden donor-id)))
            (setf (specimen-form same) (deep-copy-sexp recipient-form)
                  (specimen-contract same)
                  (deep-copy-sexp
                   (snapshot-value receipt :recipient-contract))
                  (specimen-revision same)
                  (snapshot-value receipt :recipient-revision)))
          (register-specimen
           garden recipient-id recipient-form
           (snapshot-value receipt :recipient-contract)
           :revision (snapshot-value receipt :recipient-revision))))
    (let* ((replayed
             (%attempt-graft
              garden
              donor-id (getf request :donor-cut-path)
              recipient-id (getf request :recipient-cut-path)
              :record-p nil
              :forced-attempt-number (receipt-field receipt :attempt)))
           (original-hashes (receipt-field receipt :hashes))
           (replayed-hashes (receipt-field replayed :hashes))
           (replayed-provenance (receipt-field replayed :provenance))
           (checks
             (list
              (list :protocol
                    (equal (receipt-field receipt :protocol)
                           (receipt-field replayed :protocol)))
              (list :engine
                    (equal (getf provenance :engine)
                           (getf replayed-provenance :engine)))
              (list :rulebook
                    (equal (getf provenance :rulebook)
                           (getf replayed-provenance :rulebook)))
              (list :policy
                    (equal (getf provenance :policy)
                           (getf replayed-provenance :policy)))
              (list :operator-specs
                    (equal (getf provenance :operator-specs)
                           (getf replayed-provenance :operator-specs)))
              (list :status
                    (eq (receipt-status receipt)
                        (receipt-status replayed)))
              (list :rule
                    (eq (receipt-rule receipt)
                        (receipt-rule replayed)))
              (list :transplant
                    (equal (receipt-field receipt :transplant)
                           (receipt-field replayed :transplant)))
              (list :candidate-hash
                    (equal (getf original-hashes :candidate)
                           (getf replayed-hashes :candidate)))
              (list :recipient-post-hash
                    (equal (getf original-hashes :recipient-post)
                           (getf replayed-hashes :recipient-post)))
              (list :post-form
                    (equal (receipt-field receipt :post-form)
                           (receipt-field replayed :post-form))))))
      (list :replay-report
            :receipt-id (deep-copy-sexp (receipt-id receipt))
            :matched (every #'second checks)
            :checks checks
            :replayed-receipt replayed))))

;;; ---------------------------------------------------------------------------
;;; Receipt and garden invariants

(defun plist-key-present-p (plist key)
  (loop for tail on plist by #'cddr
        thereis (eq (car tail) key)))

(defun check-receipt-invariants (receipt)
  "Return NIL when RECEIPT is internally coherent, otherwise violations."
  (let ((violations nil))
    (labels ((violate (kind &rest details)
               (push (list* :kind kind details) violations)))
      (unless (and (consp receipt) (eq (car receipt) :graft-receipt))
        (violate :not-a-graft-receipt))
      (let ((payload (and (consp receipt) (cdr receipt))))
        (dolist (key '(:schema :id :protocol :attempt :garden-id :request
                       :donor :recipient :transplant :excised-target
                       :candidate-form :post-form :hashes :decision
                       :consequences :snapshots :provenance))
          (unless (plist-key-present-p payload key)
            (violate :missing-receipt-field :field key))))
      (unless (= (or (receipt-field receipt :schema) -1) 1)
        (violate :unsupported-schema
                 :schema (receipt-field receipt :schema)))
      (unless (and (integerp (receipt-field receipt :attempt))
                   (plusp (receipt-field receipt :attempt)))
        (violate :invalid-attempt-number
                 :attempt (receipt-field receipt :attempt)))
      (unless (member (receipt-status receipt) '(:accepted :refused)
                      :test #'eq)
        (violate :invalid-decision-status
                 :status (receipt-status receipt)))
      (unless (receipt-rule receipt)
        (violate :missing-rule))
      (let* ((snapshots (receipt-field receipt :snapshots))
             (donor-form (getf snapshots :donor-form))
             (recipient-form (getf snapshots :recipient-form))
             (request (receipt-field receipt :request))
             (hashes (receipt-field receipt :hashes))
             (transplant (receipt-field receipt :transplant))
             (candidate (receipt-field receipt :candidate-form))
             (post-form (receipt-field receipt :post-form))
             (donor-record (receipt-field receipt :donor))
             (recipient-record (receipt-field receipt :recipient))
             (provenance (receipt-field receipt :provenance))
             (edges-before (getf provenance :edges-before))
             (edges-after (getf provenance :edges-after)))
        (unless (eq donor-form :unavailable)
          (unless (equal (stable-sexp-hash donor-form)
                         (getf hashes :donor-pre))
            (violate :donor-pre-hash-mismatch))
          (unless (equal (getf snapshots :donor-revision)
                         (getf donor-record :revision))
            (violate :donor-revision-snapshot-mismatch))
          (multiple-value-bind (actual success reason)
              (inspect-path donor-form (getf request :donor-cut-path))
            (declare (ignore reason))
            (when (and success
                       (not (eq transplant :unavailable))
                       (not (equal actual transplant)))
              (violate :transplant-does-not-match-donor-snapshot))))
        (unless (eq recipient-form :unavailable)
          (unless (equal (stable-sexp-hash recipient-form)
                         (getf hashes :recipient-pre))
            (violate :recipient-pre-hash-mismatch))
          (unless (equal (getf snapshots :recipient-revision)
                         (getf recipient-record :revision-before))
            (violate :recipient-revision-snapshot-mismatch)))
        (unless (eq candidate :unavailable)
          (unless (equal (stable-sexp-hash candidate)
                         (getf hashes :candidate))
            (violate :candidate-hash-mismatch))
          (when (and (not (eq recipient-form :unavailable))
                     (not (eq transplant :unavailable)))
            (multiple-value-bind (ignored success reason)
                (inspect-path recipient-form
                              (getf request :recipient-cut-path))
              (declare (ignore ignored reason))
              (when success
                (unless (equal candidate
                               (replace-subtree
                                recipient-form
                                (getf request :recipient-cut-path)
                                transplant))
                  (violate :candidate-is-not-the-recorded-replacement))))))
        (unless (eq post-form :unavailable)
          (unless (equal (stable-sexp-hash post-form)
                         (getf hashes :recipient-post))
            (violate :recipient-post-hash-mismatch)))
        (unless (and (plist-key-present-p provenance :engine)
                     (plist-key-present-p provenance :rulebook)
                     (plist-key-present-p provenance :policy)
                     (plist-key-present-p provenance :operator-specs)
                     (plist-key-present-p provenance :edges-before)
                     (plist-key-present-p provenance :edges-after)
                     (plist-key-present-p provenance :replay))
          (violate :incomplete-replay-provenance))
        (let* ((rulebook (getf provenance :rulebook))
               (rule-entry
                 (find (receipt-rule receipt) rulebook
                       :key (lambda (entry) (getf entry :rule))
                       :test #'eq))
               (expected-disposition
                 (case (receipt-status receipt)
                   (:accepted :accept)
                   (:refused :refuse))))
          (unless rule-entry
            (violate :responsible-rule-absent-from-rulebook
                     :rule (receipt-rule receipt)))
          (when (and rule-entry expected-disposition
                     (not (eq expected-disposition
                              (getf rule-entry :disposition))))
            (violate :rulebook-disposition-disagrees-with-decision
                     :rule (receipt-rule receipt)
                     :expected expected-disposition
                     :recorded (getf rule-entry :disposition))))
        (case (receipt-status receipt)
          (:accepted
           (unless (equal post-form candidate)
             (violate :accepted-post-form-differs-from-candidate))
           (let ((before (getf recipient-record :revision-before))
                 (after (getf recipient-record :revision-after)))
             (when (and (integerp before) (integerp after)
                        (/= after (1+ before)))
               (violate :accepted-revision-did-not-increment
                        :before before :after after)))
           (let* ((recipient-id (getf request :recipient-id))
                  (donor-id (getf request :donor-id))
                  (entry (assoc recipient-id edges-after :test #'equal)))
             (unless (and entry (member donor-id (cdr entry) :test #'equal))
               (violate :accepted-provenance-edge-absent
                        :edge (list recipient-id donor-id)))))
          (:refused
           (unless (or (eq recipient-form :unavailable)
                       (equal post-form recipient-form))
             (violate :refusal-mutated-recipient))
           (let ((before (getf recipient-record :revision-before))
                 (after (getf recipient-record :revision-after)))
             (when (and (integerp before) (integerp after)
                        (/= before after))
               (violate :refused-revision-changed
                        :before before :after after)))
           (unless (equal edges-before edges-after)
             (violate :refusal-mutated-provenance))))))
    (nreverse violations)))

(defun check-garden-invariants (garden)
  "Return all violations of the garden's standing invariants."
  (let ((violations nil)
        (receipt-ids (make-hash-table :test #'equal))
        (expected-attempt 1))
    ;; The archive is chronological and gapless.  This is the observable
    ;; residue of the 'one attempt, one receipt' law.
    (dolist (receipt (garden-receipts garden))
      (let ((id (receipt-id receipt))
            (attempt (receipt-field receipt :attempt)))
        (unless (eql attempt expected-attempt)
          (push (list :kind :noncontiguous-receipt-attempt
                      :expected expected-attempt :observed attempt
                      :receipt-id id)
                violations))
        (unless (equal id
                       (make-receipt-id garden attempt))
          (push (list :kind :receipt-id-does-not-match-attempt
                      :id id :attempt attempt)
                violations))
        (if (gethash id receipt-ids)
            (push (list :kind :duplicate-receipt-id :id id) violations)
            (setf (gethash id receipt-ids) t))
        (incf expected-attempt))
      (let ((receipt-violations (check-receipt-invariants receipt)))
        (when receipt-violations
          (push (list :kind :invalid-receipt
                      :receipt-id (receipt-id receipt)
                      :violations receipt-violations)
                violations)))
      (when (eq (receipt-status receipt) :accepted)
        (let* ((request (receipt-field receipt :request))
               (recipient (getf request :recipient-id))
               (donor (getf request :donor-id)))
          (unless (member donor
                          (gethash recipient
                                   (garden-provenance-edges garden))
                          :test #'equal)
            (push (list :kind :accepted-receipt-missing-provenance-edge
                        :receipt-id (receipt-id receipt)
                        :edge (list recipient donor))
                  violations)))))
    (unless (= (garden-counter garden) (length (garden-receipts garden)))
      (push (list :kind :receipt-counter-disagrees-with-archive
                  :counter (garden-counter garden)
                  :archive-length (length (garden-receipts garden)))
            violations))
    (maphash
     (lambda (identity specimen)
       (let ((issues (structural-issues (specimen-form specimen))))
         (when issues
           (push (list :kind :malformed-live-specimen
                       :identity identity
                       :issues issues)
                 violations)))
       (unless (equal identity (specimen-id specimen))
         (push (list :kind :specimen-index-identity-mismatch
                     :index identity
                     :specimen-id (specimen-id specimen))
               violations))
       (unless (and (integerp (specimen-revision specimen))
                    (not (minusp (specimen-revision specimen))))
         (push (list :kind :invalid-specimen-revision
                     :identity identity
                     :revision (specimen-revision specimen))
               violations))
       (dolist (receipt-id (specimen-history specimen))
         (unless (gethash receipt-id receipt-ids)
           (push (list :kind :specimen-history-refers-to-unknown-receipt
                       :identity identity :receipt-id receipt-id)
                 violations))))
     (garden-specimens garden))
    (setf violations
          (nconc (provenance-graph-cycles garden) violations))
    (nreverse violations)))

(defun assert-garden-invariants (garden)
  (let ((violations (check-garden-invariants garden)))
    (when violations
      (error "Garden invariants failed:~%~S" violations))
    t))

