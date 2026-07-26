;;;; surface0.lisp — Language Surface /0, the transparent front end.
;;;;
;;;; Run: (load "surface0.lisp")   — it loads Slice /2, which loads Core /0,
;;;; Slice /1, Slice /0, Kernel /0 and CD/0.
;;;;
;;;; READ THE PACKAGE FILE FIRST.  The boundary law lives there.
;;;;
;;;; ONE HABIT WORTH NAMING BEFORE THE CODE.  Every macro below places the
;;;; caller's operand forms into the expansion VERBATIM, never decomposed and
;;;; re-emitted.  That is not laziness; it is how "evaluated exactly once, in
;;;; source order" becomes structurally true rather than a promise a test has to
;;;; keep checking.  Where a temporary is genuinely needed it is a GENSYM.

(unless (find-package :lisp-plus-slice2)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-slice-2/slice2.lisp" *load-truename*))))

(unless (find-package :lisp-plus-surface0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "package.lisp" *load-truename*))))

(in-package #:lisp-plus-surface0)

;;; ==================================================================
;;; SURFACE GRAMMAR REFUSAL.
;;;
;;; This governs MALFORMED SURFACE GRAMMAR ONLY.  It deliberately does not
;;; duplicate Slice /1's or Slice /2's semantic condition taxonomies, and it
;;; must never absorb one: a syntactically valid declaration naming an unknown
;;; contract version or an unknown support clause is NOT surface damage — it is
;;; a governed semantic refusal, and it must reach the layer that owns it.
;;;
;;; The reason this exists at all: malformed syntax that fails as `CAR of NIL`
;;; or `odd number of keyword arguments` tells a reader nothing about which
;;; field of which declaration was wrong, and a surface whose errors are host
;;; accidents is a surface nobody can debug.

(define-condition surface-syntax-refused (error)
  ((form :initarg :form :initform nil :reader surface-syntax-refused-form)
   (reason :initarg :reason :initform nil :reader surface-syntax-refused-reason)
   (offending :initarg :offending :initform nil
              :reader surface-syntax-refused-offending))
  (:report (lambda (c stream)
             (format stream "surface syntax refused (~S)~@[ at ~S~]: ~S"
                     (surface-syntax-refused-reason c)
                     (surface-syntax-refused-offending c)
                     (surface-syntax-refused-form c)))))

(defparameter +surface-syntax-reasons+
  '(:missing-field :duplicate-field :unknown-field :malformed-clause
    :wrong-operation)
  "The stable reason keywords.  A reader can branch on these; they are not
prose.")

(defun surface-syntax-reasons () (copy-list +surface-syntax-reasons+))

(defun %surface-refuse (form reason &optional offending)
  (error 'surface-syntax-refused :form form :reason reason :offending offending))

;;; ------------------------------------------------------------------
;;; Field parsing.  ONE helper, used by all three declaration forms, so that
;;; "missing", "duplicate" and "unknown" mean the same thing in each of them.

(defun %parse-fields (form body allowed required)
  "Parse BODY as a field plist.  Returns it unchanged on success.  Refuses on
odd length, a duplicated field, an unknown field, or a missing required one —
each with its own reason keyword and the offending field named.

REQUIRED is deliberately the same list as ALLOWED in every current caller:
Surface /0 has NO optional declaration fields, because an omitted
standing-relevant field is exactly the silent default the boundary law forbids.
The two parameters stay separate so that a later candidate can add a genuinely
optional field without rewriting this function's contract."
  (unless (evenp (length body))
    (%surface-refuse form :malformed-clause body))
  (let ((seen '()))
    (loop for k in body by #'cddr
          do (unless (keywordp k) (%surface-refuse form :malformed-clause k))
             (when (member k seen :test #'eq)
               (%surface-refuse form :duplicate-field k))
             (unless (member k allowed :test #'eq)
               (%surface-refuse form :unknown-field k))
             (push k seen))
    (dolist (r required)
      (unless (member r seen :test #'eq)
        (%surface-refuse form :missing-field r))))
  body)

(defun %field (body key) (getf body key))

;;; ==================================================================
;;; DEFINE-JUDGMENT-SCHEMA
;;;
;;; SYNTAX/EXPRESSION RULE, stated once and without exception:
;;;
;;;     EVERY FIELD OF THIS FORM IS LITERAL SYNTAX.  Nothing in it is evaluated.
;;;
;;; :NAME, :VERSION, :CONCLUSION, :PREMISES, :LOCALS and :UNIQUE-LOCALS are all
;;; read as written and quoted into the expansion.  There is therefore no state
;;; in which a reader has to work out whether a subform is syntax or a runtime
;;; expression — the answer is always syntax.  A program that needs a computed
;;; schema uses the direct constructor API, which remains public.
;;;
;;; :LOCALS and :UNIQUE-LOCALS are REQUIRED even when empty.  The Slice /1
;;; constructor defaults them to NIL, and Surface /0 refuses to inherit that
;;; default: uniqueness-bearing locals are standing-relevant (CHARTER-DELTA-2),
;;; so `:unique-locals ()` is a sentence the author has to write.

(defparameter +schema-fields+
  '(:name :version :conclusion :premises :locals :unique-locals))

(defmacro define-judgment-schema (variable &body body)
  "Declare and register a Slice /1 judgment schema, binding VARIABLE to it.

Expands into an ordinary top-level binding, construction through the public
Slice /1 constructor, and registration through the public registry operation —
all three visible under MACROEXPAND-1.

It does NOT clear the registry, replace an existing registration silently, or
weaken duplicate detection to make reloading idempotent.  Reloading a file that
declares a schema hits Slice /1's existing duplicate behaviour, unchanged,
because that behaviour is a standing-relevant choice this layer has no licence
to soften."
  (let ((form (list* 'define-judgment-schema variable body)))
    (unless (and variable (symbolp variable) (not (keywordp variable)))
      (%surface-refuse form :malformed-clause variable))
    (%parse-fields form body +schema-fields+ +schema-fields+)
    (let ((premises (%field body :premises)))
      (unless (listp premises) (%surface-refuse form :malformed-clause :premises))
      `(progn
         (defparameter ,variable
           (lisp-plus-slice1:judgment-schema
            :name ',(%field body :name)
            :version ',(%field body :version)
            :conclusion (lisp-plus-slice1:proposition-pattern
                         ',(%field body :conclusion))
            :premises (list ,@(mapcar (lambda (p)
                                        `(lisp-plus-slice1:proposition-pattern ',p))
                                      premises))
            :locals ',(%field body :locals)
            :unique-locals ',(%field body :unique-locals)))
         (lisp-plus-slice1:register-schema ,variable)
         ',variable))))

;;; ==================================================================
;;; DEFINE-ADMISSION-CONTRACT
;;;
;;; SYNTAX/EXPRESSION RULE: EVERY FIELD OF THIS FORM IS LITERAL SYNTAX.
;;;
;;; EVERY field is REQUIRED — there are no defaults here at all, and that is the
;;; boundary law applied at its sharpest point.  The Slice /2 constructor
;;; defaults :PROPOSITION-RELATION, :RECEIVER-ACCESSIBILITY and :RETAIN; a
;;; contract is precisely the object whose whole purpose is to say what a
;;; premise will accept, so a contract with an unwritten acceptance rule is the
;;; thing this layer exists to prevent.
;;;
;;; :CONTRACT-VERSION must always appear in source.  Versions 0 and 1 keep their
;;; existing meanings exactly.
;;;
;;; THE MACRO TRANSLATES NOTHING.  It does not add (:VERIFIED-JUDGED-CLAIM), add
;;; (:SOURCE-BASIS …), add (:DERIVATION-BASIS), select a source relation, invent
;;; a truth ceiling, or upgrade a derivation-basis ceiling to a source-basis
;;; ceiling.  The clause list reaches the public constructor as written, so an
;;; unknown version or an unknown clause reaches the EXISTING governed refusal
;;; rather than being pre-normalized into something acceptable.

(defparameter +contract-fields+
  '(:contract-id :contract-version :accepted-clauses :proposition-relation
    :receiver-accessibility :retain))

(defmacro define-admission-contract (variable &body body)
  "Declare a Slice /2 support-admission contract, binding VARIABLE to it.

Every field is required. Nothing is defaulted, translated, broadened or
normalized: the clause list you write is the clause list the public constructor
receives."
  (let ((form (list* 'define-admission-contract variable body)))
    (unless (and variable (symbolp variable) (not (keywordp variable)))
      (%surface-refuse form :malformed-clause variable))
    (%parse-fields form body +contract-fields+ +contract-fields+)
    (let ((clauses (%field body :accepted-clauses)))
      (unless (and (listp clauses) clauses)
        (%surface-refuse form :malformed-clause :accepted-clauses))
      (dolist (c clauses)
        ;; GRAMMAR ONLY.  "is this a list whose head is a keyword" is a shape
        ;; question.  Whether that keyword names a clause family this contract
        ;; VERSION defines is a SEMANTIC question, and it belongs to Slice /2 —
        ;; so an unknown species passes through here untouched and is refused
        ;; there, with Slice /2's own typed condition and Slice /2's own message.
        (unless (and (consp c) (keywordp (first c)))
          (%surface-refuse form :malformed-clause c)))
      `(progn
         (defparameter ,variable
           (lisp-plus-slice2:make-support-admission-contract
            :contract-id ',(%field body :contract-id)
            :contract-version ',(%field body :contract-version)
            :accepted-clauses ',clauses
            :proposition-relation ',(%field body :proposition-relation)
            :receiver-accessibility ',(%field body :receiver-accessibility)
            :retain ',(%field body :retain)))
         ',variable))))

;;; ==================================================================
;;; DEFINE-SLICE2-SCHEMA
;;;
;;; SYNTAX/EXPRESSION RULE — this is the ONE form that mixes, so it is stated
;;; explicitly and the mixture is drawn on a line a reader can see:
;;;
;;;     :SCHEMA-ID and :SCHEMA-VERSION are LITERAL SYNTAX.
;;;     :BASE-SCHEMA is an ORDINARY LISP EXPRESSION, evaluated once.
;;;     In :PREMISE-CONTRACTS, each INDEX is LITERAL and each CONTRACT is an
;;;     ORDINARY LISP EXPRESSION, evaluated once, in written order.
;;;
;;; It mixes because it must: a base schema and a contract are OBJECTS produced
;;; by the two forms above, and the whole point of attaching them here is to
;;; name the variables that hold them.  Quoting those would make the form
;;; useless; leaving the indices unquoted would let a premise position be
;;; computed, which is exactly the attachment-by-inference the boundary law
;;; forbids.
;;;
;;; ATTACHMENT IS BY WRITTEN INDEX AND NOTHING ELSE.  Not by list position
;;; alone, not by proposition predicate, not by contract name, not by schema
;;; name, not by matching variable names, not by a package convention, and not
;;; by a wildcard or default contract.  Missing, duplicate and out-of-range
;;; attachments reach Slice /2's existing typed refusals: this layer may catch a
;;; malformed SHAPE earlier, but it never turns a governed semantic refusal into
;;; a successful construction.

(defparameter +slice2-schema-fields+
  '(:schema-id :schema-version :base-schema :premise-contracts))

(defmacro define-slice2-schema (variable &body body)
  "Declare a Slice /2 schema, binding VARIABLE to it.

:BASE-SCHEMA and each contract are expressions; :SCHEMA-ID, :SCHEMA-VERSION and
each premise index are literal."
  (let ((form (list* 'define-slice2-schema variable body)))
    (unless (and variable (symbolp variable) (not (keywordp variable)))
      (%surface-refuse form :malformed-clause variable))
    (%parse-fields form body +slice2-schema-fields+ +slice2-schema-fields+)
    (let ((attachments (%field body :premise-contracts)))
      (unless (listp attachments)
        (%surface-refuse form :malformed-clause :premise-contracts))
      (dolist (a attachments)
        ;; Shape only: (INDEX CONTRACT-EXPRESSION), the index written as a
        ;; literal integer.  Whether that index EXISTS in the base schema, and
        ;; whether every premise got exactly one, are Slice /2's questions.
        (unless (and (consp a) (integerp (first a))
                     (consp (rest a)) (null (cddr a)))
          (%surface-refuse form :malformed-clause a)))
      `(progn
         (defparameter ,variable
           (lisp-plus-slice2:make-slice2-schema
            :schema-id ',(%field body :schema-id)
            :schema-version ',(%field body :schema-version)
            :base-schema ,(%field body :base-schema)
            :premise-contracts (list ,@(mapcar (lambda (a)
                                                 `(list ,(first a) ,(second a)))
                                               attachments))))
         ',variable))))

;;; ==================================================================
;;; THE TWO DERIVATION CONTROL FORMS.
;;;
;;; These wrap ONE visibly-written public call.  The operation form is checked
;;; at MACROEXPANSION time to be a call to the expected public operator, and is
;;; then placed into the expansion VERBATIM — so its operands are evaluated
;;; exactly once, in ordinary left-to-right order, because they are the same
;;; forms in the same place.
;;;
;;; WHAT IS CAUGHT, AND ONLY WHAT IS CAUGHT: the governed derivation-refusal
;;; type of the layer being called.  Never ERROR, never SERIOUS-CONDITION, never
;;; CONDITION.  An unexpected host error escapes, which is the correct behaviour
;;; and is asserted by a control: a surface that swallowed a real bug as a
;;; refusal would be lying about the language.
;;;
;;; NOTHING IS RETRIED.  No support is added, removed or reordered.  No condition
;;; becomes NIL or a boolean.  The values of the selected arm are the values of
;;; the form.
;;;
;;; SCOPE, deliberately asymmetric:
;;;
;;;   :GRANTED arm    the result variables are bound to the EXACT returned
;;;                   objects.
;;;   :REFUSED arm    the condition variable and the RECEIPT are bound.  The
;;;                   claim (and, for DERIVE/2-CASE, the derivation basis) are
;;;                   NOT IN SCOPE THERE AT ALL.
;;;
;;; The second half is the point.  A refusal has no claim and no basis; binding
;;; them to NIL would invite `(when claim …)` to read as a decision when it is
;;; really a shrug.  Leaving them unbound makes the mistake a compile-time
;;; unbound-variable rather than a runtime nil.

(defun %parse-arms (form arms)
  "Both arms are REQUIRED, and neither may repeat.  Returns
(values GRANTED-BODY REFUSED-CONDITION-VAR REFUSED-BODY)."
  (let ((granted nil) (refused nil) (refused-var nil)
        (seen-granted nil) (seen-refused nil))
    (dolist (arm arms)
      (unless (and (consp arm) (keywordp (first arm)))
        (%surface-refuse form :malformed-clause arm))
      (case (first arm)
        (:granted (when seen-granted (%surface-refuse form :duplicate-field :granted))
                  (setf seen-granted t granted (rest arm)))
        (:refused (when seen-refused (%surface-refuse form :duplicate-field :refused))
                  (let ((spec (second arm)))
                    (unless (and (consp spec) (symbolp (first spec))
                                 (not (keywordp (first spec))) (null (rest spec)))
                      (%surface-refuse form :malformed-clause arm))
                    (setf seen-refused t refused-var (first spec)
                          refused (cddr arm))))
        (t (%surface-refuse form :unknown-field (first arm)))))
    (unless seen-granted (%surface-refuse form :missing-field :granted))
    (unless seen-refused (%surface-refuse form :missing-field :refused))
    (values granted refused-var refused)))

(defun %check-operation (form operation expected)
  (unless (and (consp operation) (eq (first operation) expected))
    (%surface-refuse form :wrong-operation
                     (if (consp operation) (first operation) operation))))

(defmacro derive-case ((claim receipt) operation &body arms)
  "Run one visibly-written public Slice /1 DERIVE and branch on its outcome.

OPERATION must be a call to LISP-PLUS-SLICE1:DERIVE — a call to anything else
is a :WRONG-OPERATION surface refusal at macroexpansion time, because a control
form named for one operation that quietly wraps another is a lie in the source."
  (let ((form (list* 'derive-case (list claim receipt) operation arms)))
    (dolist (v (list claim receipt))
      (unless (and v (symbolp v) (not (keywordp v)))
        (%surface-refuse form :malformed-clause v)))
    (%check-operation form operation 'lisp-plus-slice1:derive)
    (multiple-value-bind (granted refused-var refused) (%parse-arms form arms)
      (let ((c (or refused-var (gensym "COND"))))
        `(handler-case
             (multiple-value-bind (,claim ,receipt) ,operation
               (declare (ignorable ,claim ,receipt))
               ,@granted)
           (lisp-plus-slice1:derivation-refused (,c)
             (let ((,receipt (lisp-plus-slice1:slice1-condition-receipt ,c)))
               (declare (ignorable ,receipt))
               ,@refused)))))))

(defmacro derive/2-case ((claim receipt derivation-basis) operation &body arms)
  "Run one visibly-written public Slice /2 DERIVE/2 and branch on its outcome.

On a grant the three variables are the exact first, second and third values.  On
a refusal the claim and the derivation basis are NOT BOUND — a refusal mints no
basis and registers nothing, and this form has no way to produce one: it never
contains or calls the internal constructor, and the only basis it can bind is
the third value of a successful DERIVE/2."
  (let ((form (list* 'derive/2-case (list claim receipt derivation-basis)
                     operation arms)))
    (dolist (v (list claim receipt derivation-basis))
      (unless (and v (symbolp v) (not (keywordp v)))
        (%surface-refuse form :malformed-clause v)))
    (%check-operation form operation 'lisp-plus-slice2:derive/2)
    (multiple-value-bind (granted refused-var refused) (%parse-arms form arms)
      (let ((c (or refused-var (gensym "COND"))))
        `(handler-case
             (multiple-value-bind (,claim ,receipt ,derivation-basis) ,operation
               (declare (ignorable ,claim ,receipt ,derivation-basis))
               ,@granted)
           (lisp-plus-slice2:slice2-derivation-refused (,c)
             (let ((,receipt (lisp-plus-slice2:slice2-condition-receipt ,c)))
               (declare (ignorable ,receipt))
               ,@refused)))))))
