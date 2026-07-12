;;;; de-foeno.lisp — "Concerning Hay"
;;;;
;;;; A homoiconic language can extend itself with forms made from its own data,
;;;; but the extension is local until another interpreter explicitly adopts it.
;;;; And no amount of describing hay creates the substrate required to continue
;;;; interpreting descriptions.
;;;;
;;;; The specimen demonstrates four bounded claims:
;;;;   I.  a syntax definition is ordinary s-expression data;
;;;;   II. evaluating that data changes one interpreter's reachable forms;
;;;;   III. transmission is not adoption: another interpreter changes only after
;;;;        it evaluates the received definition for itself;
;;;;   IV. recursive expansion consumes an external resource and stops through a
;;;;       typed condition when that resource is exhausted.
;;;;
;;;; It does NOT model hygienic macros, lexical scope, hostile serialized input,
;;;; identity, cryptographic provenance, or physical reality entire.  Its macro
;;;; system is a deliberately small, first-order template expander over an
;;;; admitted datum grammar: conses, strings, symbols, numbers, and characters.
;;;;
;;;; Proposed location:
;;;;   atelier/homoiconic-verse/specimens/de-foeno.lisp
;;;;
;;;; Run:
;;;;   sbcl --script de-foeno.lisp
;;;; Expected: all gates pass; exit 0.

(defstruct syntax-rule
  kind                              ; :primitive or :template
  function
  formals
  body
  source)

(defstruct (interpreter (:constructor %make-interpreter))
  name
  grammar
  hay
  utterances
  definitions)

(define-condition unknown-syntax (error)
  ((interpreter :initarg :interpreter :reader unknown-syntax-interpreter)
   (operator :initarg :operator :reader unknown-syntax-operator)
   (form :initarg :form :reader unknown-syntax-form))
  (:report
   (lambda (condition stream)
     (format stream "~a does not know the syntax ~s in ~s"
             (interpreter-name (unknown-syntax-interpreter condition))
             (unknown-syntax-operator condition)
             (unknown-syntax-form condition)))))

(define-condition hay-exhausted (error)
  ((interpreter :initarg :interpreter :reader hay-exhausted-interpreter)
   (form :initarg :form :reader hay-exhausted-form))
  (:report
   (lambda (condition stream)
     (format stream "~a has no hay left while interpreting ~s"
             (interpreter-name (hay-exhausted-interpreter condition))
             (hay-exhausted-form condition)))))

(define-condition malformed-syntax-definition (error)
  ((reason :initarg :reason :reader malformed-syntax-definition-reason)
   (form :initarg :form :reader malformed-syntax-definition-form))
  (:report
   (lambda (condition stream)
     (format stream "Malformed syntax definition ~s: ~a"
             (malformed-syntax-definition-form condition)
             (malformed-syntax-definition-reason condition)))))

(define-condition protected-syntax (error)
  ((name :initarg :name :reader protected-syntax-name))
  (:report
   (lambda (condition stream)
     (format stream "The core form ~s cannot be overwritten by DEFINE-SYNTAX"
             (protected-syntax-name condition)))))

(defun copy-datum (datum)
  "Copy the admitted datum grammar deeply enough for this specimen.
Conses and strings are mutable and therefore copied; immutable atoms are shared."
  (typecase datum
    (cons (cons (copy-datum (car datum))
                (copy-datum (cdr datum))))
    (string (copy-seq datum))
    (t datum)))

(defun require-arity (operator arguments expected)
  (unless (= (length arguments) expected)
    (error "~s expected ~d argument~:p, received ~d in ~s"
           operator expected (length arguments) (cons operator arguments))))

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun proper-symbol-list-p (object)
  (and (proper-list-p object)
       (every #'symbolp object)
       (= (length object)
          (length (remove-duplicates object :test #'eq)))))

(defun install-primitive (interpreter name function)
  (setf (gethash name (interpreter-grammar interpreter))
        (make-syntax-rule :kind :primitive :function function))
  name)

(defun core-syntax-p (interpreter name)
  (let ((rule (gethash name (interpreter-grammar interpreter))))
    (and rule (eq (syntax-rule-kind rule) :primitive))))

(defun knows-syntax-p (interpreter name)
  (not (null (gethash name (interpreter-grammar interpreter)))))

(defun consume-hay (interpreter form)
  "Charge one unit for one operator-dispatch or expansion step.
The restart is deliberately named from the interpreter's point of view: any
repair must be supplied by a handler outside the depleted computation."
  (if (plusp (interpreter-hay interpreter))
      (decf (interpreter-hay interpreter))
      (restart-case
          (error 'hay-exhausted
                 :interpreter interpreter
                 :form (copy-datum form))
        (supply-from-outside (amount)
          :report "Supply positive hay from outside the exhausted interpreter."
          :interactive
          (lambda ()
            (format *query-io* "Hay to supply: ")
            (list (parse-integer (read-line *query-io*))))
          (unless (and (integerp amount) (plusp amount))
            (error "Hay supplied from outside must be a positive integer, not ~s"
                   amount))
          (incf (interpreter-hay interpreter) amount)
          (consume-hay interpreter form)))))

(defun template-substitute (body formals actuals)
  "Capture-blind first-order substitution, intentionally smaller than CL macros."
  (unless (= (length formals) (length actuals))
    (error "Template expected ~d argument~:p, received ~d"
           (length formals) (length actuals)))
  (let ((bindings (pairlis formals actuals)))
    (labels ((walk (datum)
               (cond
                 ((symbolp datum)
                  (let ((binding (assoc datum bindings :test #'eq)))
                    (if binding
                        (copy-datum (cdr binding))
                        datum)))
                 ((consp datum)
                  (cons (walk (car datum))
                        (walk (cdr datum))))
                 ((stringp datum)
                  (copy-seq datum))
                 (t datum))))
      (walk body))))

(defun install-template (interpreter name formals body source)
  (when (core-syntax-p interpreter name)
    (error 'protected-syntax :name name))
  (setf (gethash name (interpreter-grammar interpreter))
        (make-syntax-rule
         :kind :template
         :formals (copy-list formals)
         :body (copy-datum body)
         :source (copy-datum source)))
  (push (copy-datum source) (interpreter-definitions interpreter))
  (copy-datum source))

(defun interpret (interpreter form)
  (cond
    ((atom form) form)
    ((not (symbolp (car form)))
     (error 'unknown-syntax
            :interpreter interpreter
            :operator (car form)
            :form (copy-datum form)))
    (t
     (consume-hay interpreter form)
     (let* ((operator (car form))
            (arguments (cdr form))
            (rule (gethash operator (interpreter-grammar interpreter))))
       (unless rule
         (error 'unknown-syntax
                :interpreter interpreter
                :operator operator
                :form (copy-datum form)))
       (ecase (syntax-rule-kind rule)
         (:primitive
          (funcall (syntax-rule-function rule) interpreter arguments))
         (:template
          (interpret interpreter
                     (template-substitute
                      (syntax-rule-body rule)
                      (syntax-rule-formals rule)
                      arguments))))))))

(defun primitive-quote (interpreter arguments)
  (declare (ignore interpreter))
  (require-arity 'quote arguments 1)
  (copy-datum (first arguments)))

(defun primitive-begin (interpreter arguments)
  (let ((result nil))
    (dolist (form arguments result)
      (setf result (interpret interpreter form)))))

(defun primitive-utter (interpreter arguments)
  (require-arity 'utter arguments 1)
  (let ((value (interpret interpreter (first arguments))))
    (push (copy-datum value) (interpreter-utterances interpreter))
    value))

(defun primitive-define-syntax (interpreter arguments)
  (require-arity 'define-syntax arguments 3)
  (destructuring-bind (name formals body) arguments
    (let ((source (list 'define-syntax
                        name
                        (copy-datum formals)
                        (copy-datum body))))
      (unless (symbolp name)
        (error 'malformed-syntax-definition
               :reason "the operator name is not a symbol"
               :form source))
      (unless (proper-symbol-list-p formals)
        (error 'malformed-syntax-definition
               :reason "formals must be a proper list of distinct symbols"
               :form source))
      (install-template interpreter name formals body source))))

(defun primitive-definition-of (interpreter arguments)
  (require-arity 'definition-of arguments 1)
  (let* ((name (first arguments))
         (rule (and (symbolp name)
                    (gethash name (interpreter-grammar interpreter)))))
    (unless (and rule (eq (syntax-rule-kind rule) :template))
      (error 'unknown-syntax
             :interpreter interpreter
             :operator name
             :form (list 'definition-of name)))
    (copy-datum (syntax-rule-source rule))))

(defun primitive-hay-left (interpreter arguments)
  (require-arity 'hay-left arguments 0)
  (interpreter-hay interpreter))

(defun make-interpreter (name &key (hay 0))
  (let ((interpreter
          (%make-interpreter
           :name name
           :grammar (make-hash-table :test #'eq)
           :hay hay
           :utterances nil
           :definitions nil)))
    (install-primitive interpreter 'quote #'primitive-quote)
    (install-primitive interpreter 'begin #'primitive-begin)
    (install-primitive interpreter 'utter #'primitive-utter)
    (install-primitive interpreter 'define-syntax #'primitive-define-syntax)
    (install-primitive interpreter 'definition-of #'primitive-definition-of)
    (install-primitive interpreter 'hay-left #'primitive-hay-left)
    interpreter))

(defun syntax-standing (name interpreters)
  "Return a bounded social standing and the interpreters that currently know NAME."
  (let* ((holders (remove-if-not
                   (lambda (interpreter)
                     (knows-syntax-p interpreter name))
                   interpreters))
         (count (length holders))
         (total (length interpreters)))
    (values
     (cond
       ((zerop count) :absent)
       ((= count 1) :local-invention)
       ((= count total) :ecosystem-syntax)
       (t :shared-protocol))
     (mapcar #'interpreter-name holders))))

(defun show-standing (name interpreters)
  (multiple-value-bind (standing holders)
      (syntax-standing name interpreters)
    (format t "~s has standing ~s; holders: ~s~%"
            name standing holders)
    standing))

(defun attempt (thunk)
  "Run THUNK and classify the first typed refusal relevant to this specimen."
  (handler-case
      (progn (funcall thunk) :admitted)
    (unknown-syntax () :unknown-syntax)
    (hay-exhausted () :hay-exhausted)
    (protected-syntax () :protected-syntax)
    (malformed-syntax-definition () :malformed-syntax-definition)))

(defun ensure (test control &rest arguments)
  (unless test
    (apply #'error control arguments))
  t)

(format t "~&— de foeno — concerning hay —~%~%")

(let* ((rabbit (make-interpreter :rabbit :hay 24))
       (cat (make-interpreter :cat :hay 24))
       (raven (make-interpreter :raven :hay 24))
       (community (list rabbit cat raven))
       (twice-definition
         '(define-syntax twice (x)
            (begin x x))))

  (format t "I. INVENTION — one interpreter evaluates a definition made of its own data.~%")
  (let ((installed (interpret rabbit twice-definition)))
    (ensure (equal installed twice-definition)
            "Installed definition changed shape: ~s" installed)
    (ensure (and (consp installed)
                 (eq (car installed) 'define-syntax))
            "The definition ceased to be an ordinary s-expression: ~s" installed))
  (ensure (eq (show-standing 'twice community) :local-invention)
          "TWICE should initially be local to RABBIT")
  (interpret rabbit '(twice (utter :clover)))
  (ensure (equal (reverse (interpreter-utterances rabbit))
                 '(:clover :clover))
          "RABBIT did not execute the new syntax twice")
  (format t "RABBIT's utterances: ~s~%~%"
          (reverse (interpreter-utterances rabbit)))

  (format t "II. TRANSMISSION IS NOT ADOPTION — a foreign interpreter still refuses it.~%")
  (ensure (eq (attempt (lambda ()
                         (interpret cat '(twice (utter :mint)))))
              :unknown-syntax)
          "CAT accepted TWICE before adopting its definition")
  (format t "CAT before adoption: :UNKNOWN-SYNTAX~%~%")

  (format t "III. UPTAKE — the source is exported as data, then evaluated by each receiver.~%")
  (let ((portable-definition (interpret rabbit '(definition-of twice))))
    (ensure (equal portable-definition twice-definition)
            "Exported syntax source drifted: ~s" portable-definition)
    (interpret cat portable-definition)
    (ensure (eq (show-standing 'twice community) :shared-protocol)
            "TWICE should be shared by exactly two interpreters")
    (interpret cat '(twice (utter :mint)))
    (ensure (equal (reverse (interpreter-utterances cat))
                   '(:mint :mint))
            "CAT did not execute TWICE after adoption")
    (ensure (eq (attempt (lambda ()
                           (interpret raven '(twice (utter :berry)))))
                :unknown-syntax)
            "RAVEN acquired TWICE merely because CAT adopted it")
    (interpret raven portable-definition)
    (ensure (eq (show-standing 'twice community) :ecosystem-syntax)
            "TWICE should have ecosystem standing only after RAVEN adopts it"))
  (format t "No broadcast ontology: every grammar changed through an explicit local act.~%~%"))

(format t "IV. THE HAY PRINCIPLE — descriptions of substrate are not substrate.~%")
(let* ((ouroboros (make-interpreter :ouroboros :hay 7))
       (conjure-definition
         '(define-syntax conjure-hay (n)
            (quote (:hay n)))))
  (interpret ouroboros conjure-definition)
  (let* ((before (interpreter-hay ouroboros))
         (described-hay (interpret ouroboros '(conjure-hay 1000)))
         (after (interpreter-hay ouroboros)))
    (format t "The language produced the description ~s.~%" described-hay)
    (format t "Actual hay moved from ~d to ~d.~%" before after)
    (ensure (equal described-hay '(:hay 1000))
            "CONJURE-HAY failed even to describe hay")
    (ensure (< after before)
            "A representation of hay improperly increased the resource counter"))

  (interpret ouroboros
             '(define-syntax again (x)
                (again x)))
  (let ((result
          (attempt (lambda ()
                     (interpret ouroboros '(again :still-again))))))
    (format t "Recursive self-expansion ended as ~s with ~d hay remaining.~%"
            result (interpreter-hay ouroboros))
    (ensure (eq result :hay-exhausted)
            "The recursive syntax was not stopped by HAY-EXHAUSTED")
    (ensure (zerop (interpreter-hay ouroboros))
            "Resource exhaustion should leave zero hay, not ~d"
            (interpreter-hay ouroboros))))

(format t "~%V. REPAIR REMAINS LIVE — but the repair must arrive from outside.~%")
(let ((hungry (make-interpreter :hungry-rabbit :hay 0))
      (supplied nil))
  (handler-bind
      ((hay-exhausted
         (lambda (condition)
           (declare (ignore condition))
           (setf supplied t)
           (invoke-restart 'supply-from-outside 2))))
    (ensure (eq (interpret hungry '(utter :fed)) :fed)
            "The supplied restart did not resume the interrupted evaluation"))
  (ensure supplied "No external supply was requested")
  (ensure (equal (interpreter-utterances hungry) '(:fed))
          "The repaired interpreter did not preserve and resume live state")
  (format t "An outer handler supplied 2; the interrupted form resumed; ~d remains.~%"
          (interpreter-hay hungry)))

(format t "~%A form can rewrite the grammar that reads forms.~%")
(format t "It cannot, by redescribing nourishment, nourish the reader.~%")
(format t "The spell needs an interpreter. The interpreter needs hay.~%")
(format t "~%ALL GATES PASS — 5 movements, 0 metaphysical overdrafts.~%")
