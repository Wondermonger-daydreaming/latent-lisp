;;;; program0.lisp — PROGRAM /0: the programming surface of Lisp+ (CANDIDATE).
;;;;
;;;; STANDING: CANDIDATE (see package.lisp). Running this adopts nothing.
;;;;
;;;; WHAT THIS IS. Until tonight a "Lisp+ program" was one of two things: a
;;;; Common Lisp script that calls the lanes' packages (mneme/readme-specimen.lisp),
;;;; or a Many Acts /0 source — ONE closed-grammar form of bind/act/derive/branch
;;;; steps, read by CL `read` under the reader law and run by ma0-eval.lisp.
;;;; Neither lets a user define a function. This file adds the general layer the
;;;; language lacked: user-defined functions with lexical scope and closure
;;;; capture, functions as values, ordinary computation over numbers and lists,
;;;; recursion under a declared budget, and a runner that reads a source FILE and
;;;; prints a value or a located language error.
;;;;
;;;; WHAT IS REUSED, BY REFERENCE, NOT COPIED
;;;;   • The reader law (MANY-ACTS-0-GRAMMAR.md §1b; ma0-validate.lisp
;;;;     %ma0-read-source): CL `read`, `*read-eval*' NIL, `*package*' bound to a
;;;;     namespace that :USEs nothing, double-float default. One difference,
;;;;     named: an MA0 source is ONE form (V-SHAPE); a PROGRAM /0 source is a
;;;;     SEQUENCE of top-level forms, because a program that can define
;;;;     functions needs somewhere to put them. Each top-level form carries its
;;;;     line:column, which is where an error is reported.
;;;;   • The closed-heads rule (ma0-validate.lisp, +ma0-heads+): a special-form
;;;;     name may not be used as a variable or parameter name (E-SYNTAX).
;;;;   • The no-truthiness rule (ma0-eval.lisp header): `if`, `cond`, `and`,
;;;;     `or` and `not` accept ONLY the two boolean values true/false. A list,
;;;;     a number or () in test position is E-TYPE, not "falsy".
;;;;   • Source-size bounds of the same species as +ma0-max-source-depth+ /
;;;;     +ma0-max-source-nodes+ become EVALUATION bounds here: `*step-budget*'
;;;;     and `*depth-limit*'. Exhausting either is a refusal (E-BUDGET), never a
;;;;     hang. This is the lane's termination policy, and it is NEW at the
;;;;     evaluation level — the existing lanes terminate by shape (V-TERM),
;;;;     because they have no recursion. Said plainly here, and in the README.
;;;;   • Kernel /0 as the "already-supported semantic operation" (the
;;;;     commission's program 3): `kernel0/determinacy` calls
;;;;     lisp-plus-kernel0:make-determinacy through its EXISTING interface and
;;;;     turns the kernel's refusal (a kernel0-condition carrying requirement id
;;;;     and law) into a first-class REFUSAL VALUE the program can inspect. That
;;;;     is a derivation: no effect, no store, no seat. Nothing in this lane
;;;;     performs: `perform`, `act`, `derive`, `continue-from` are not bound and
;;;;     the effect lanes (core0, act0/1, many-acts0) are NOT LOADED by the
;;;;     runner. The boundary is an absence, and an absence is a claim, so the
;;;;     selftest witnesses it (no lisp-plus-core0 package in the image; the
;;;;     names are E-UNBOUND).
;;;;   • The durable-data boundary: a live function value (closure or primitive)
;;;;     is refused at the Kernel /0 bridge (E-BOUNDARY). No closure is ever
;;;;     serialized; none can reach a record.
;;;;
;;;; WHAT IS NOT HERE (named, not hidden): tail-call elimination (deep recursion
;;;; is bounded by *depth-limit*, and map/filter/fold over a list longer than
;;;; that depth refuse with E-BUDGET); mutation of any kind (no set!); strings
;;;; beyond literals, `string?`, `print` and `string-append`; floating-point
;;;; beyond what the CL reader gives; error HANDLING inside a program (a
;;;; language error ends the program; only Kernel /0 refusals are values);
;;;; sub-form source positions (an error names the top-level form's line:column,
;;;; the innermost forms being evaluated, and the user-function frames).
;;;;
;;;; — Claude Fable 5.1, desktop chair, 2026-09-23/24

(in-package #:lisp-plus-program0)

(defparameter +program0-version+ 0)

;;; ===========================================================================
;;; §1 — dynamic state of one evaluation: location, path, frames, budget.
;;; ===========================================================================

(defparameter *step-budget* 1000000
  "Evaluation steps admitted to ONE program run (every `evaluate' call is a
step). Exhaustion is E-BUDGET. The number is a policy, not a measurement of
anything; it is printed in the refusal so the reader knows which ceiling spoke.")

(defparameter *depth-limit* 4000
  "User-function call depth admitted (closure applications nested). Exhaustion
is E-BUDGET. Kept well under the host control stack the runner requests, so
the language refuses before the host does.")

(defvar *steps* 0)
(defvar *depth* 0)
(defvar *source-name* "<source>")
(defvar *current-location* nil "(line . column) of the top-level form under evaluation.")
(defvar *form-path* '() "Forms being evaluated, innermost first.")
(defvar *frames* '() "User-function names being applied, innermost first.")

;;; ===========================================================================
;;; §2 — the language error: one condition, a closed set of codes.
;;; ===========================================================================

(defparameter +error-codes+
  '(("E-READ"     . "the reader refused the source")
    ("E-SYNTAX"   . "a form is not well-shaped for its operator")
    ("E-UNBOUND"  . "a name has no binding")
    ("E-REDEFINE" . "a name is already bound in this frame")
    ("E-ARITY"    . "a function was applied to the wrong number of arguments")
    ("E-TYPE"     . "a value has the wrong kind for the operation")
    ("E-ARITH"    . "an arithmetic operation is undefined for its arguments")
    ("E-BUDGET"   . "the evaluation budget (steps or depth) is exhausted")
    ("E-BOUNDARY" . "a value may not cross into the host or into a Kernel /0 record"))
  "The closed vocabulary. A new code is a change to this table, visible in a diff.")

(define-condition program0-error (error)
  ((code     :initarg :code     :reader program0-error-code)
   (message  :initarg :message  :reader program0-error-message)
   (location :initarg :location :reader program0-error-location :initform nil)
   (path     :initarg :path     :reader program0-error-path     :initform nil)
   (frames   :initarg :frames   :reader program0-error-frames   :initform nil)
   (source   :initarg :source   :reader program0-error-source   :initform nil))
  (:report (lambda (c s) (write-string (render-program0-error c) s))))

(define-condition program0-incomplete-source (program0-error) ()
  (:documentation "An E-READ refusal whose cause is that the reader reached the END OF THE
TEXT inside a form — an unclosed parenthesis, string, `|…|' escape or `#' dispatch. It
IS a program0-error with code E-READ and renders exactly as one; a file runner sees no
difference. The subclass exists so an interactive reader (REPL /0) can tell input that
is merely unfinished from input that is malformed, using the reader's own verdict
rather than a second parser. (REPL /0 candidate, 2026-09-25.)"))

(defun fail-as (class code fmt &rest args)
  (assert (assoc code +error-codes+ :test #'string=) () "unknown error code ~a" code)
  (error class
         :code code
         :message (apply #'format nil fmt args)
         :location *current-location*
         :path (subseq *form-path* 0 (min 3 (length *form-path*)))
         :frames *frames*
         :source *source-name*))

(defun fail (code fmt &rest args)
  (apply #'fail-as 'program0-error code fmt args))

;;; ===========================================================================
;;; §3 — values.
;;; ===========================================================================
;;; A Lisp+ value is one of: an integer or ratio or float (CL numbers, as read);
;;; a string; a keyword (self-evaluating, used to address Kernel /0 schemas); a
;;; symbol of the source namespace (obtained only by `quote`); the empty list ();
;;; a proper list of values; the booleans TRUE and FALSE; a closure; a
;;; primitive; a refusal; a host value.

(defconstant +true+ :true)
(defconstant +false+ :false)

(defun boolean-value-p (v) (or (eq v +true+) (eq v +false+)))
(defun bool (generalized) (if generalized +true+ +false+))

(defstruct (closure (:constructor make-closure (params body env name)) (:copier nil))
  (params nil :read-only t)   ; list of source symbols
  (body   nil :read-only t)   ; list of forms
  (env    nil :read-only t)   ; the defining environment — this IS the capture
  (name   nil :read-only t))  ; a symbol, or nil for an anonymous lambda

(defstruct (primitive (:constructor make-primitive (name arity fn)) (:copier nil))
  (name  nil :read-only t)    ; a string, as the program writes it
  (arity nil :read-only t)    ; integer | (min . max) | (min . nil) = at least min
  (fn    nil :read-only t))

(defstruct (refusal (:copier nil))
  "A Kernel /0 refusal carried as a VALUE: what was refused, under which
requirement, by which law. Not an error of this language — the program asked
the kernel a question and this is the kernel's answer."
  (kind nil :read-only t) (requirement nil :read-only t) (law nil :read-only t)
  (field nil :read-only t) (value nil :read-only t))

(defstruct (host-value (:copier nil))
  "An object made by another lane through its existing constructor, held
opaquely. It can be printed and passed back to that lane's own accessors; it
cannot be taken apart by this language."
  (lane nil :read-only t) (kind nil :read-only t) (object nil :read-only t))

(defun function-value-p (v) (or (closure-p v) (primitive-p v)))

(defun source-symbol-p (v)
  (and (symbolp v) (not (null v)) (not (keywordp v))
       (eq (symbol-package v) (find-package '#:lisp-plus-program0.source))))

;;; ---- rendering, in the language's own syntax --------------------------------

(defun render (v &optional (stream nil))
  "Print a value as a program would write it. Symbols lowercase; booleans as
true/false; lists in parentheses; strings quoted; functions and host objects as
#<...> descriptions that a reader cannot mistake for data."
  (if stream
      (%render v stream)
      (with-output-to-string (s) (%render v s))))

(defun %render (v s)
  (cond ((eq v +true+) (write-string "true" s))
        ((eq v +false+) (write-string "false" s))
        ((null v) (write-string "()" s))
        ((integerp v) (format s "~d" v))
        ((rationalp v) (format s "~a" v))
        ((floatp v) (format s "~f" v))
        ((stringp v) (prin1 v s))
        ((keywordp v) (format s ":~(~a~)" (symbol-name v)))
        ((symbolp v) (format s "~(~a~)" (symbol-name v)))
        ((consp v)
         (write-char #\( s)
         (loop for tail on v
               do (%render (car tail) s)
                  (cond ((null (cdr tail)))
                        ((consp (cdr tail)) (write-char #\Space s))
                        (t (write-string " . " s) (%render (cdr tail) s) (return))))
         (write-char #\) s))
        ((closure-p v) (format s "#<function ~:[lambda~;~(~a~)~]>"
                               (closure-name v) (and (closure-name v) (symbol-name (closure-name v)))))
        ((primitive-p v) (format s "#<primitive ~a>" (primitive-name v)))
        ((refusal-p v) (format s "#<refused ~a requirement ~a>" (refusal-kind v) (refusal-requirement v)))
        ((host-value-p v) (format s "#<~a ~a>" (host-value-lane v) (host-value-kind v)))
        (t (format s "#<host ~a>" (type-of v)))))

(defun render-program0-error (c)
  (with-output-to-string (s)
    (let ((loc (program0-error-location c)))
      (format s "lisp-plus: ~a" (program0-error-code c))
      (when loc (format s " at ~a:~d:~d" (program0-error-source c) (car loc) (cdr loc)))
      (format s "~%  ~a" (program0-error-message c))
      (when (program0-error-path c)
        (format s "~%  in: ~a" (render-abbrev (first (program0-error-path c))))
        (when (rest (program0-error-path c))
          (format s "~%  within: ~{~a~^ · ~}" (mapcar #'render-abbrev (rest (program0-error-path c))))))
      (when (program0-error-frames c)
        (format s "~%  frames: ~{~(~a~)~^ ← ~}" (mapcar #'symbol-name (program0-error-frames c))))
      (format s "~%  (~a)" (cdr (assoc (program0-error-code c) +error-codes+ :test #'string=))))))

(defun render-abbrev (form &optional (limit 60))
  (let ((text (render form)))
    (if (> (length text) limit)
        (concatenate 'string (subseq text 0 (- limit 4)) " ...")
        text)))

;;; ===========================================================================
;;; §4 — environments: a chain of frames. Lexical scope IS this chain.
;;; ===========================================================================

(defstruct (env (:constructor %make-env (parent)) (:copier nil))
  (table (make-hash-table :test #'eq) :read-only t)
  (parent nil :read-only t))

(defun make-frame (parent) (%make-env parent))

(defun env-lookup (env sym)
  "→ (values value found-p). Walks outward; the innermost binding wins — that is
shadowing, and it is the only way a name is ever rebound."
  (loop for e = env then (env-parent e)
        while e
        do (multiple-value-bind (v found) (gethash sym (env-table e))
             (when found (return (values v t))))
        finally (return (values nil nil))))

(defun env-define (env sym value)
  (multiple-value-bind (old found) (gethash sym (env-table env))
    (declare (ignore old))
    (when found
      (fail "E-REDEFINE" "`~(~a~)` is already defined in this frame; a name is bound once per frame (shadow it in an inner frame instead)"
            (symbol-name sym))))
  (setf (gethash sym (env-table env)) value)
  sym)

;;; ===========================================================================
;;; §5 — the reader: CL `read` under the law, one top-level form at a time,
;;;      each with its line:column.
;;; ===========================================================================

(defun %line-and-column (text index)
  "1-based line and 0-based column of INDEX in TEXT."
  (let ((line 1) (col 0))
    (loop for i from 0 below (min index (length text))
          do (if (char= (char text i) #\Newline) (progn (incf line) (setf col 0)) (incf col)))
    (cons line col)))

(defun %skip-blank (text start)
  "Skip whitespace and `;` comments from START. → index of the next form start, or NIL at end."
  (let ((i start) (n (length text)))
    (loop
      (cond ((>= i n) (return nil))
            ((member (char text i) '(#\Space #\Tab #\Newline #\Return #\Page)) (incf i))
            ((char= (char text i) #\;)
             (loop while (and (< i n) (char/= (char text i) #\Newline)) do (incf i)))
            (t (return i))))))

(defvar +eof+ (make-symbol "END-OF-SOURCE")
  "Returned by the reader only at end of text between forms; never a datum a source can write.")

(defun read-source-forms (text &key (source-name "<source>"))
  "→ list of (form line . column). TEXT is the whole source. The bindings are
the law (MANY-ACTS-0-GRAMMAR.md §1b): `*read-eval*' NIL kills `#.' at the
reader; `*package*' is the source namespace so every symbol is homed there."
  (let ((*read-eval* nil)
        (*package* (find-package '#:lisp-plus-program0.source))
        (*read-default-float-format* 'double-float)
        (*source-name* source-name)
        (forms '())
        (index 0))
    (loop
      (let ((start (%skip-blank text index)))
        (unless start (return (nreverse forms)))
        (let* ((loc (%line-and-column text start))
               (*current-location* loc)
               (*form-path* '())
               (*frames* '()))
          (multiple-value-bind (form next)
              ;; EOF-ERROR-P NIL: the reader returns +EOF+ only when the text ends BETWEEN
              ;; forms (after whitespace or a #|…|# comment that %skip-blank does not skip);
              ;; it still signals END-OF-FILE when the text ends INSIDE a form. Until
              ;; 2026-09-25 this was T, so a source ending in a #|…|# comment was refused
              ;; E-READ as if a form were unfinished (REPL /0 candidate; disclosed there).
              (handler-case (read-from-string text nil +eof+ :start start)
                (end-of-file (c)
                  (fail-as 'program0-incomplete-source
                           "E-READ" "the text ends inside the form starting here (an unclosed parenthesis, string, |…| escape or # dispatch) [~a]"
                           (type-of c)))
                (error (c)
                  (fail "E-READ" "the reader refused the form starting here: ~a [~a]"
                        (remove #\Newline (princ-to-string c)) (type-of c))))
            (when (eq form +eof+) (return (nreverse forms)))
            (validate-source-datum form)
            (push (cons form loc) forms)
            (setf index next)))))))

;;; ---- source validation: what the reader may hand the evaluator ------------
;;; The reader can build things this language has no value for: vectors,
;;; characters, dotted pairs, and — through `#1=` labels — circular structure
;;; that no printer or walker terminates on. So every top-level form is walked
;;; ONCE, right after it is read, with a visited set (cycle-safe) and a node
;;; bound of the same species as +ma0-max-source-nodes+. Astra's review of
;;; 2026-09-24 found each of these reaching the evaluator; this is the repair.

(defparameter *max-source-nodes* 100000
  "Conses admitted in one top-level form. Exhaustion is E-READ, never a hang.")

(defun foreign-symbol-p (x)
  "A symbol that is not a name of this language: not the empty list, not a
keyword, not homed in the source namespace, and not the one admitted foreign
symbol, `common-lisp:quote' (what the reader produces for the ' abbreviation)."
  (and (symbolp x) (not (null x)) (not (keywordp x))
       (not (source-symbol-p x))
       (not (eq x 'quote))))

(defun validate-source-datum (form)
  "Walk FORM once. Two marks per cons — OPEN (on the current descent path) and
DONE (fully validated) — so a node reached twice is a CYCLE only if it is still
OPEN: `#1=(1 . #1#)' is refused, `(#1=(1 2) #1#)' (acyclic sharing) is admitted.
The one admitted foreign symbol, `common-lisp:quote', is admitted only as the
HEAD of a form; as a datum (`'cl:quote', `(list 'cl:quote)') it is refused like
any other foreign symbol. (Both from Astra's inspection, 2026-09-24.)
Structure (cycles, node count, the kind of every atom) is context-independent and
cached by DONE; PLACEMENT is not. A shared cell first met as the start of a list
(its car in head position) may later be met as a TAIL, where the same car is a
datum. So the DONE shortcut re-checks the placement of the shared cell's car before
it returns: acyclic sharing never changes which placements of `common-lisp:quote'
are admitted (Astra's r4 review: '(#1=(cl:quote x) (tag . #1#)) was admitted)."
  (let ((mark (make-hash-table :test #'eq)) (nodes 0))
    (labels ((cycle () (fail "E-READ" "the form contains circular structure (a #n= label that refers to itself); the language has no value for it"))
             (count-node ()
               (when (> (incf nodes) *max-source-nodes*)
                 (fail "E-READ" "the form exceeds ~:d conses (*max-source-nodes*); refused as source" *max-source-nodes*)))
             (occurrence-ok (x head-position-p)
               ;; the ONE context-sensitive rule, stated once: `common-lisp:quote' only as a head
               (when (and (eq x 'quote) (not head-position-p))
                 (fail "E-SYNTAX" "common-lisp:quote is admitted only as the head of a form, not as a datum")))
             (atom-ok (x head-position-p)
               (cond ((or (null x) (keywordp x) (realp x) (stringp x)))
                     ((symbolp x)
                      (cond ((eq x 'quote) (occurrence-ok x head-position-p))
                            ((foreign-symbol-p x)
                             (fail "E-SYNTAX" "~a is not a name of this language (a symbol of package ~a)"
                                   (render-foreign x) (package-name (symbol-package x))))))
                     ((complexp x) (fail "E-READ" "complex numbers are not values of this language: ~a" x))
                     (t (fail "E-READ" "unsupported datum ~a (~a): the language has numbers, strings, keywords, symbols and proper lists"
                              (let ((*print-circle* t) (*print-length* 8) (*print-level* 3)) (prin1-to-string x))
                              (type-of x)))))
             (walk-list (x)
               ;; X is a cons. Walk the spine cell by cell: mark the cell OPEN, validate its
               ;; car (descending into a cons that is not yet DONE), then the next cell. A cell
               ;; met again while OPEN is on the current path — a cycle; a cell met again when
               ;; DONE is sharing. All cells of the spine become DONE when the spine ends.
               (let ((spine '()))
                 (loop for tail = x then (cdr tail)
                       for first = t then nil
                       while (consp tail)
                       do (case (gethash tail mark)
                            (:open (cycle))
                            (:done                     ; a shared, already validated tail: its STRUCTURE
                             (occurrence-ok (car tail) first) ; is done, but its car is now in THIS position
                             (return))
                            (t (setf (gethash tail mark) :open) (count-node) (push tail spine)
                               (let ((item (car tail)))
                                 (if (consp item)
                                     (case (gethash item mark)
                                       (:open (cycle))
                                       (:done nil)
                                       (t (walk-list item)))
                                     (atom-ok item first)))))
                       finally (unless (null tail)
                                 (fail "E-READ" "dotted pair ~a: the language has proper lists only" (render-abbrev x))))
                 (dolist (cell spine) (setf (gethash cell mark) :done)))))
      (if (consp form) (walk-list form) (atom-ok form nil)))
    form))

(defun render-foreign (sym)
  (format nil "~(~a:~a~)" (package-name (symbol-package sym)) (symbol-name sym)))

;;; ===========================================================================
;;; §6 — the evaluator.
;;; ===========================================================================

(defparameter +special-forms+
  '("DEFINE" "LAMBDA" "LET" "IF" "COND" "QUOTE" "BEGIN" "AND" "OR")
  "The closed set of heads. A head is recognised by NAME, whatever its package
(`'x` reads as (COMMON-LISP:QUOTE X) even in the source namespace).")

(defun special-form-name (form)
  "The head's NAME if FORM is a special form. A head is recognised only in the
source namespace — except `common-lisp:quote', which the reader produces for
the ' abbreviation and which is the one admitted foreign symbol (§1). So
`(cl:if true 1 2)' is not an `if': its head is a foreign symbol and is refused."
  (let ((head (and (consp form) (car form))))
    (cond ((eq head 'quote) "QUOTE")
          ((and (source-symbol-p head)
                (find (symbol-name head) +special-forms+ :test #'string=)))
          (t nil))))

(defun check-bindable-name (sym what)
  (unless (source-symbol-p sym)
    (fail "E-SYNTAX" "~a must be a name, got ~a" what (render sym)))
  (when (find (symbol-name sym) +special-forms+ :test #'string=)
    (fail "E-SYNTAX" "`~(~a~)` is a special form and may not be used as ~a" (symbol-name sym) what))
  (when (member (symbol-name sym) '("TRUE" "FALSE" "ELSE") :test #'string=)
    (fail "E-SYNTAX" "`~(~a~)` is reserved and may not be used as ~a" (symbol-name sym) what))
  sym)

(defun tick ()
  (when (>= (incf *steps*) *step-budget*)
    (fail "E-BUDGET" "step budget exhausted: ~:d evaluation steps is this run's ceiling (*step-budget*)" *step-budget*)))

(defun proper-list-p (x)
  (and (listp x) (handler-case (list-length x) (type-error () nil))))

(defun evaluate (form env)
  "Evaluate FORM in ENV. Every call is one step against the budget."
  (tick)
  (let ((*form-path* (cons form *form-path*)))
    (typecase form
      (null form)                          ; () is the empty list, a value
      (keyword form)                       ; :mode, :determinate — self-evaluating
      ((or number string) form)
      (symbol
       (if (source-symbol-p form)
           (multiple-value-bind (v found) (env-lookup env form)
             (if found v (fail "E-UNBOUND" "unknown name `~(~a~)`" (symbol-name form))))
           (fail "E-SYNTAX" "~a is not a name of this language" (render form))))
      (cons
       (unless (proper-list-p form)
         (fail "E-SYNTAX" "a form must be a proper list, got ~a" (render-abbrev form)))
       (let ((head (special-form-name form)))
         (if head
             (evaluate-special head form env)
             (evaluate-application form env))))
      (t (fail "E-SYNTAX" "~a cannot appear in a program" (render form))))))

(defun evaluate-body (forms env)
  "A body is one or more forms; the value is the last one's. `define` inside a
body binds in the body's own frame, so a function may define local helpers,
including recursive ones, before using them."
  (when (null forms) (fail "E-SYNTAX" "a body must contain at least one form"))
  (let ((value nil))
    (dolist (f forms value) (setf value (evaluate f env)))))

(defun evaluate-special (head form env)
  (let ((args (cdr form)))
    (flet ((arity (n &optional (max n))
             (let ((k (length args)))
               (unless (and (>= k n) (or (null max) (<= k max)))
                 (fail "E-SYNTAX" "`~(~a~)` takes ~a form~:p, got ~d" head
                       (if (eql n max) n (format nil "~d~@[ to ~d~]" n max)) k)))))
      (cond
        ;; (quote datum)
        ((string= head "QUOTE") (arity 1) (first args))

        ;; (define name expr) | (define (name . params) body...)
        ((string= head "DEFINE")
         (arity 2 nil)
         (let ((target (first args)))
           (cond ((consp target)
                  (let ((name (check-bindable-name (car target) "a function name"))
                        (params (parse-params (cdr target))))
                    (env-define env name (make-closure params (rest args) env name))
                    name))
                 (t (check-bindable-name target "a variable name")
                    (arity 2)
                    (let ((v (evaluate (second args) env)))
                      (env-define env target v)
                      target)))))

        ;; (lambda (params...) body...)
        ((string= head "LAMBDA")
         (arity 2 nil)
         (make-closure (parse-params (first args)) (rest args) env nil))

        ;; (let ((name expr)...) body...) — inits in the OUTER env, then one new frame
        ((string= head "LET")
         (arity 2 nil)
         (let ((bindings (first args)))
           (unless (proper-list-p bindings)
             (fail "E-SYNTAX" "`let` needs a list of (name expr) pairs, got ~a" (render-abbrev bindings)))
           (let ((frame (make-frame env)) (pairs '()))
             (dolist (b bindings)
               (unless (and (proper-list-p b) (= (length b) 2))
                 (fail "E-SYNTAX" "each `let` binding is (name expr), got ~a" (render-abbrev b)))
               (check-bindable-name (first b) "a let-bound name")
               (push (cons (first b) (evaluate (second b) env)) pairs))
             (dolist (p (nreverse pairs)) (env-define frame (car p) (cdr p)))
             (evaluate-body (rest args) frame))))

        ;; (if test then else) — else is REQUIRED; test must be a boolean
        ((string= head "IF")
         (arity 3)
         (let ((test (evaluate (first args) env)))
           (unless (boolean-value-p test)
             (fail "E-TYPE" "`if` needs true or false in test position, got ~a (no value is falsy here)" (render test)))
           (evaluate (if (eq test +true+) (second args) (third args)) env)))

        ;; (cond (test body...)... (else body...)) — a clause must fire
        ((string= head "COND")
         (arity 1 nil)
         (dolist (clause args
                         (fail "E-TYPE" "`cond` fell through: no clause held and there is no `else`"))
           (unless (and (proper-list-p clause) (>= (length clause) 2))
             (fail "E-SYNTAX" "each `cond` clause is (test body...), got ~a" (render-abbrev clause)))
           (let ((test (first clause)))
             (if (and (symbolp test) test (string= (symbol-name test) "ELSE"))
                 (return (evaluate-body (rest clause) env))
                 (let ((v (evaluate test env)))
                   (unless (boolean-value-p v)
                     (fail "E-TYPE" "`cond` needs true or false from a test, got ~a" (render v)))
                   (when (eq v +true+) (return (evaluate-body (rest clause) env))))))))

        ;; (begin form...) — sequence; the last value
        ((string= head "BEGIN") (arity 1 nil) (evaluate-body args env))

        ;; (and form...) / (or form...) — boolean-strict, short-circuit
        ((string= head "AND")
         (dolist (a args +true+)
           (let ((v (evaluate a env)))
             (unless (boolean-value-p v) (fail "E-TYPE" "`and` needs booleans, got ~a" (render v)))
             (when (eq v +false+) (return +false+)))))
        ((string= head "OR")
         (dolist (a args +false+)
           (let ((v (evaluate a env)))
             (unless (boolean-value-p v) (fail "E-TYPE" "`or` needs booleans, got ~a" (render v)))
             (when (eq v +true+) (return +true+)))))
        (t (error "unreachable special form ~a" head))))))

(defun parse-params (params)
  (unless (proper-list-p params)
    (fail "E-SYNTAX" "a parameter list must be a proper list of names, got ~a" (render-abbrev params)))
  (let ((seen '()))
    (dolist (p params (nreverse seen))
      (check-bindable-name p "a parameter")
      (when (member p seen) (fail "E-SYNTAX" "parameter `~(~a~)` appears twice" (symbol-name p)))
      (push p seen))))

(defun evaluate-application (form env)
  (let* ((f (evaluate (car form) env))
         (args (mapcar (lambda (a) (evaluate a env)) (cdr form))))
    (apply-value f args)))

(defun arity-ok-p (arity n)
  (etypecase arity
    (integer (= n arity))
    (cons (and (>= n (car arity)) (or (null (cdr arity)) (<= n (cdr arity)))))))

(defun describe-arity (arity)
  (etypecase arity
    (integer (format nil "~d" arity))
    (cons (if (cdr arity)
              (format nil "~d to ~d" (car arity) (cdr arity))
              (format nil "at least ~d" (car arity))))))

(defun apply-value (f args)
  (cond
    ((closure-p f)
     (let ((params (closure-params f)))
       (unless (= (length args) (length params))
         (fail "E-ARITY" "~:[an anonymous function~;`~(~a~)`~] takes ~d argument~:p, got ~d"
               (closure-name f) (and (closure-name f) (symbol-name (closure-name f)))
               (length params) (length args)))
       (let ((*depth* (1+ *depth*))
             (*frames* (cons (or (closure-name f) (intern "LAMBDA" '#:lisp-plus-program0.source)) *frames*)))
         (when (> *depth* *depth-limit*)
           (fail "E-BUDGET" "call depth ~:d exceeds this run's ceiling (*depth-limit*); this language has no tail-call elimination"
                 *depth-limit*))
         (let ((frame (make-frame (closure-env f))))
           (loop for p in params for a in args do (env-define frame p a))
           (evaluate-body (closure-body f) frame)))))
    ((primitive-p f)
     (unless (arity-ok-p (primitive-arity f) (length args))
       (fail "E-ARITY" "`~a` takes ~a argument~:p, got ~d"
             (primitive-name f) (describe-arity (primitive-arity f)) (length args)))
     (apply (primitive-fn f) args))
    (t (fail "E-TYPE" "~a is not a function and cannot be applied" (render f)))))

;;; ===========================================================================
;;; §7 — primitives. Each checks its own argument kinds and fails with the
;;;      language's own codes; no host condition escapes as a host condition.
;;; ===========================================================================

(defvar *primitives* '() "alist name → primitive, in definition order.")

(defmacro defprimitive (name arity lambda-list &body body)
  `(push (cons ,name (make-primitive ,name ',arity (lambda ,lambda-list ,@body))) *primitives*))

(defmacro with-arithmetic ((who) &body body)
  "Run BODY; translate every host arithmetic condition into a located E-ARITH.
SBCL signals DIVISION-BY-ZERO for (/ 1 0.0) and FLOATING-POINT-OVERFLOW for
(* 1d308 1d308); before this wrapper both reached the runner as host faults
(Astra's review, 2026-09-24)."
  `(handler-case (progn ,@body)
     (division-by-zero () (fail "E-ARITH" "`~a`: division by zero" ,who))
     (floating-point-overflow () (fail "E-ARITH" "`~a`: floating-point overflow" ,who))
     (floating-point-underflow () (fail "E-ARITH" "`~a`: floating-point underflow" ,who))
     (floating-point-invalid-operation () (fail "E-ARITH" "`~a`: invalid floating-point operation" ,who))
     (floating-point-inexact () (fail "E-ARITH" "`~a`: inexact floating-point result trapped" ,who))
     (arithmetic-error (c) (fail "E-ARITH" "`~a`: ~(~a~)" ,who (type-of c)))))

(defun zero-number-p (v) (and (numberp v) (zerop v)))

(defun need-number (v who)
  (unless (realp v) (fail "E-TYPE" "`~a` needs numbers, got ~a" who (render v)))
  v)
(defun need-list (v who)
  (unless (proper-list-p v) (fail "E-TYPE" "`~a` needs a list, got ~a" who (render v)))
  v)
(defun need-pair (v who)
  (unless (consp v) (fail "E-TYPE" "`~a` needs a non-empty list, got ~a" who (render v)))
  v)
(defun need-boolean (v who)
  (unless (boolean-value-p v) (fail "E-TYPE" "`~a` needs true or false, got ~a" who (render v)))
  v)

;; arithmetic
(defprimitive "+" (0 . nil) (&rest xs)
  (with-arithmetic ("+") (reduce #'+ (mapcar (lambda (x) (need-number x "+")) xs) :initial-value 0)))
(defprimitive "*" (0 . nil) (&rest xs)
  (with-arithmetic ("*") (reduce #'* (mapcar (lambda (x) (need-number x "*")) xs) :initial-value 1)))
(defprimitive "-" (1 . nil) (&rest xs)
  (mapc (lambda (x) (need-number x "-")) xs)
  (with-arithmetic ("-") (if (rest xs) (reduce #'- xs) (- (first xs)))))
(defprimitive "/" (1 . nil) (&rest xs)
  (mapc (lambda (x) (need-number x "/")) xs)
  (when (some #'zero-number-p (if (rest xs) (rest xs) xs))
    (fail "E-ARITH" "`/`: division by zero"))
  (with-arithmetic ("/") (if (rest xs) (reduce #'/ xs) (/ (first xs)))))
(defprimitive "quotient" 2 (a b)
  (need-number a "quotient") (need-number b "quotient")
  (unless (and (integerp a) (integerp b)) (fail "E-TYPE" "`quotient` needs integers"))
  (when (zero-number-p b) (fail "E-ARITH" "`quotient`: division by zero"))
  (with-arithmetic ("quotient") (values (truncate a b))))
(defprimitive "mod" 2 (a b)
  (need-number a "mod") (need-number b "mod")
  (unless (and (integerp a) (integerp b)) (fail "E-TYPE" "`mod` needs integers"))
  (when (zero-number-p b) (fail "E-ARITH" "`mod`: division by zero"))
  (with-arithmetic ("mod") (mod a b)))
(defprimitive "abs" 1 (a) (with-arithmetic ("abs") (abs (need-number a "abs"))))
(defprimitive "max" (1 . nil) (&rest xs) (with-arithmetic ("max") (reduce #'max (mapcar (lambda (x) (need-number x "max")) xs))))
(defprimitive "min" (1 . nil) (&rest xs) (with-arithmetic ("min") (reduce #'min (mapcar (lambda (x) (need-number x "min")) xs))))

;; comparison — numbers only; equality on values is `equal?`
(macrolet ((cmp (name op)
             `(defprimitive ,name (2 . nil) (&rest xs)
                (mapc (lambda (x) (need-number x ,name)) xs)
                (with-arithmetic (,name) (bool (apply #',op xs))))))
  (cmp "=" =) (cmp "<" <) (cmp ">" >) (cmp "<=" <=) (cmp ">=" >=))

(defun value-equal-p (a b)
  (cond ((and (consp a) (consp b)) (and (value-equal-p (car a) (car b)) (value-equal-p (cdr a) (cdr b))))
        ((and (numberp a) (numberp b)) (= a b))
        ((and (stringp a) (stringp b)) (string= a b))
        (t (eq a b))))
(defprimitive "equal?" 2 (a b) (bool (value-equal-p a b)))
(defprimitive "eq?" 2 (a b) (bool (or (eq a b) (and (numberp a) (numberp b) (eql a b)))))

;; booleans
(defprimitive "not" 1 (b) (if (eq (need-boolean b "not") +true+) +false+ +true+))

;; lists
(defprimitive "cons" 2 (a d)
  (unless (listp d) (fail "E-TYPE" "`cons` builds proper lists only; the second argument must be a list, got ~a" (render d)))
  (cons a d))
(defprimitive "car" 1 (p) (car (need-pair p "car")))
(defprimitive "cdr" 1 (p) (cdr (need-pair p "cdr")))
(defprimitive "list" (0 . nil) (&rest xs) xs)
(defprimitive "length" 1 (l) (length (need-list l "length")))
(defprimitive "append" (0 . nil) (&rest ls)
  (mapc (lambda (l) (need-list l "append")) ls)
  (reduce #'append ls :from-end t :initial-value '()))
(defprimitive "reverse" 1 (l) (reverse (need-list l "reverse")))
(defprimitive "null?" 1 (v) (bool (null v)))
(defprimitive "pair?" 1 (v) (bool (consp v)))
(defprimitive "list?" 1 (v) (bool (proper-list-p v)))

;; kinds
(defprimitive "number?" 1 (v) (bool (realp v)))
(defprimitive "integer?" 1 (v) (bool (integerp v)))
(defprimitive "boolean?" 1 (v) (bool (boolean-value-p v)))
(defprimitive "symbol?" 1 (v) (bool (source-symbol-p v)))
(defprimitive "string?" 1 (v) (bool (stringp v)))
(defprimitive "function?" 1 (v) (bool (function-value-p v)))
(defprimitive "keyword?" 1 (v) (bool (keywordp v)))

;; strings and output
(defprimitive "string-append" (0 . nil) (&rest ss)
  (mapc (lambda (s) (unless (stringp s) (fail "E-TYPE" "`string-append` needs strings, got ~a" (render s)))) ss)
  (apply #'concatenate 'string ss))
(defprimitive "number->string" 1 (n) (with-arithmetic ("number->string") (render (need-number n "number->string"))))
(defprimitive "print" (1 . nil) (&rest vs)
  "Write the values, space-separated, then a newline. Strings print WITHOUT quotes here."
  (format *standard-output* "~{~a~^ ~}~%"
          (mapcar (lambda (v) (if (stringp v) v (render v))) vs))
  (finish-output *standard-output*)
  (car (last vs)))

;;; ---- the Kernel /0 bridge: a derivation through the kernel's own door -------

(defun host-admissible-datum-p (v)
  "What may be handed to a Kernel /0 constructor: keywords, numbers, strings,
and proper lists of those. NEVER a function value, a refusal, or a host value."
  (or (keywordp v) (realp v) (stringp v)
      (and (proper-list-p v) (every #'host-admissible-datum-p v))))

(defun kernel0-symbol (name)
  (let ((pkg (find-package '#:lisp-plus-kernel0)))
    (unless pkg (fail "E-BOUNDARY" "Kernel /0 is not loaded in this image; `~a` is unavailable" name))
    (or (find-symbol name pkg)
        (fail "E-BOUNDARY" "Kernel /0 does not export ~a" name))))

(defun call-kernel0 (kind fn-name args)
  (dolist (a args)
    (unless (host-admissible-datum-p a)
      (fail "E-BOUNDARY" "~a may not cross into a Kernel /0 record (only keywords, numbers, strings and lists of those may)"
            (render a))))
  (let ((fn (kernel0-symbol fn-name))
        (condition-type (kernel0-symbol "KERNEL0-CONDITION")))
    (handler-case
        (make-host-value :lane "kernel0" :kind kind :object (apply (symbol-function fn) args))
      (error (c)
        (if (typep c condition-type)
            (make-refusal
             :kind (string-downcase (symbol-name (type-of c)))
             :requirement (funcall (kernel0-symbol "KERNEL0-CONDITION-REQUIREMENT-ID") c)
             :law (funcall (kernel0-symbol "KERNEL0-CONDITION-FAILED-INVARIANT") c)
             :field (funcall (kernel0-symbol "KERNEL0-CONDITION-OFFENDING-FIELD") c)
             :value (funcall (kernel0-symbol "KERNEL0-CONDITION-OFFENDING-VALUE") c))
            (fail "E-BOUNDARY" "Kernel /0 signalled a host condition that is not a kernel refusal: ~a" (type-of c)))))))

(defprimitive "kernel0/determinacy" (0 . nil) (&rest args)
  "Ask Kernel /0 for a §7 determinacy record through lisp-plus-kernel0:make-determinacy.
→ a host value on success, a REFUSAL value when the kernel refuses (e.g. a
global confidence scalar, K0E-33). A derivation: nothing is performed."
  (call-kernel0 "determinacy" "MAKE-DETERMINACY" args))

(defprimitive "kernel0/determinacy-mode" 1 (d)
  (unless (and (host-value-p d) (string= (host-value-kind d) "determinacy"))
    (fail "E-TYPE" "`kernel0/determinacy-mode` needs a kernel0 determinacy, got ~a" (render d)))
  (funcall (symbol-function (kernel0-symbol "DETERMINACY-MODE")) (host-value-object d)))

(defprimitive "refused?" 1 (v) (bool (refusal-p v)))
(defprimitive "refusal-requirement" 1 (r)
  (unless (refusal-p r) (fail "E-TYPE" "`refusal-requirement` needs a refusal, got ~a" (render r)))
  (or (refusal-requirement r) ""))
(defprimitive "refusal-law" 1 (r)
  (unless (refusal-p r) (fail "E-TYPE" "`refusal-law` needs a refusal, got ~a" (render r)))
  (or (refusal-law r) ""))
(defprimitive "refusal-kind" 1 (r)
  (unless (refusal-p r) (fail "E-TYPE" "`refusal-kind` needs a refusal, got ~a" (render r)))
  (refusal-kind r))
(defprimitive "host-value?" 1 (v) (bool (host-value-p v)))

;;; ===========================================================================
;;; §8 — the global environment and the prelude.
;;; ===========================================================================

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults (or *load-truename* *default-pathname-defaults*)))

(defparameter *prelude-path* (merge-pathnames "prelude.lp" *lane-directory*))

(defun source-symbol (name)
  (intern (string-upcase name) '#:lisp-plus-program0.source))

(defun make-global-environment (&key (prelude t))
  "The root frame: every primitive under its program name, the two booleans,
then the prelude (map, filter, fold, range, ... written IN Lisp+) evaluated
into the same frame. Programs run in a CHILD frame: a program may shadow any
prelude name (a top-level `define` of `map` is a shadow, not a redefinition)
and may define each of its own names once per frame (E-REDEFINE)."
  (let ((root (make-frame nil)))
    (env-define root (source-symbol "true") +true+)
    (env-define root (source-symbol "false") +false+)
    (dolist (entry (reverse *primitives*))
      (env-define root (source-symbol (car entry)) (cdr entry)))
    (when prelude
      (unless (probe-file *prelude-path*)
        (error "PROGRAM /0 prelude not found at ~a" *prelude-path*))
      (run-source (read-file-text *prelude-path*) root :source-name "prelude.lp"))
    (make-frame root)))

(defun read-file-text (pathname)
  (with-open-file (in pathname :direction :input :external-format :utf-8 :element-type 'character)
    (let ((text (make-string (file-length in))))
      (let ((n (read-sequence text in))) (subseq text 0 n)))))

;;; ===========================================================================
;;; §9 — running a source: read all forms, evaluate in order, return the last.
;;; ===========================================================================

(defun run-source (text env &key (source-name "<source>"))
  "→ (values last-value last-form-was-definition-p form-count). A language error
propagates as PROGRAM0-ERROR with its location. Host storage exhaustion (a
runaway the depth limit did not catch first) is reported as E-BUDGET, never as
a host backtrace."
  (let ((*steps* 0) (*depth* 0) (*source-name* source-name)
        (*current-location* nil) (*form-path* '()) (*frames* '())
        (value nil) (definedp nil) (count 0))
    (handler-case
        (dolist (entry (read-source-forms text :source-name source-name))
          (let ((*current-location* (cdr entry)))
            (incf count)
            (setf definedp (and (consp (car entry)) (equal (special-form-name (car entry)) "DEFINE")))
            (setf value (evaluate (car entry) env))))
      (storage-condition ()
        (fail "E-BUDGET" "the host ran out of stack or heap before the language's own ceiling spoke; the program is refused")))
    (values value definedp count)))

(defun run-file (pathname &key (env (make-global-environment)))
  (run-source (read-file-text pathname) env
              :source-name (file-namestring pathname)))
