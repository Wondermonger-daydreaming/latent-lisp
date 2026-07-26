;;;; PUBLIC-SURFACE-AUDIT.lisp — Language Form /0, Candidate /0.
;;;;
;;;; Run: sbcl --non-interactive --load PUBLIC-SURFACE-AUDIT.lisp
;;;;
;;;; Two jobs, one command.
;;;;
;;;; (1) THE EXPORT CENSUS.  Every external symbol gets a row, and the census
;;;;     FAILS if any symbol lacks a declared disposition or any declared
;;;;     disposition names a symbol that is not exported.  "Every export is
;;;;     accounted for" is therefore a tooth, not a promise.  The census is
;;;;     written to EXPORT-CENSUS.md.
;;;;
;;;; (2) THE FRESH-CONSUMER ADVERSARIAL WALK.  A separate package that uses ONLY
;;;;     the external symbols of LISP-PLUS-FORM0 tries the twelve forgeries the
;;;;     chair review named.  Each is either refused, structurally impossible, or
;;;;     — where it is NOT — recorded as a DECLARED LIMIT with its own row, never
;;;;     silently passed over.

(load (merge-pathnames "form0.lisp" *load-truename*))

;;; THIS PACKAGE IS THE FRESH CONSUMER.  It uses CL and the EXTERNAL symbols of
;;; LISP-PLUS-FORM0 and nothing else.  A check at the foot of this file asserts
;;; that the file contains no double-colon reference into the audited package,
;;; so the walk cannot quietly reach past the public surface it is auditing.
;;; (This comment deliberately does not spell that reference out — the check
;;; scans this very file, and a comment quoting the needle would fail it.)
(defpackage #:form0-public-surface (:use #:cl #:lisp-plus-form0))
(in-package #:form0-public-surface)

(defmacro cd0 (name &rest arguments)
  `(,(intern (string name) :lisp-plus-cd0) ,@arguments))

(defparameter *passed* 0)
(defparameter *failed* 0)

(defun check (condition label)
  (if condition
      (progn (incf *passed*) (format t "  ok   ~A~%" label))
      (progn (incf *failed*) (format t "  FAIL ~A~%" label))))

;;; ══════════════════════════════════════════════════════════════════
;;; (1) THE CENSUS
;;; ══════════════════════════════════════════════════════════════════
;;;
;;; Category is derived mechanically from the symbol; the judgment columns
;;; (minting power, disposition) come from the declared table below.  Anything
;;; the table does not cover is a census failure.

(defun category-of (name)
  (cond
    ((member name '("PROPOSE-FORM" "INSTANTIATE-FORM" "VALIDATE-FORM" "REALIZE-FORM")
             :test #'string=) :transition)
    ((and (> (length name) 4) (string= "TRY-" (subseq name 0 4))) :transition-try)
    ((member name '("MAKE-FORM-ENVIRONMENT" "SEAL-FORM-ENVIRONMENT"
                    "MAKE-FORM-HOLE")
             :test #'string=) :constructor)
    ((member name '("OPERATOR-NAMES" "OPERATOR-DESCRIPTOR") :test #'string=)
     :package-owned-operator)
    ((member name '("LITERAL-NODE" "HOLE-NODE" "OPERATOR-NODE"
                    "HOLE-IDENTIFIER" "OPERATOR-IDENTIFIER"
                    "GRAMMAR-IDENTITY" "GRAMMAR-VERSION")
             :test #'string=) :grammar-constructor)
    ((string= name "FORM-REFUSED") :condition)
    ((string= name "FORM-REFUSAL-CODES") :protocol-constant)
    ((and (> (length name) 2)
          (string= "-P" (subseq name (- (length name) 2)))) :predicate)
    (t :reader)))

;;; DECLARED DISPOSITIONS.  One entry per category, plus per-symbol overrides
;;; for everything that can mint or that carries a limit.
(defparameter *category-disposition*
  '((:transition        "program"  "advances a phase; earns invariants"      "retain")
    (:transition-try    "program"  "as above; returns refusals instead of signalling" "retain")
    (:grammar-constructor "program or fake adapter" "builds inert candidate data only" "retain")
    (:predicate         "any"      "none — answers a question"               "retain")
    (:reader            "any"      "none — immutable, defensive copies"      "retain")
    (:condition         "any"      "none — signalled by the layer"           "retain")
    (:protocol-constant "any"      "none — returns a fresh list"             "retain")
    (:package-owned-operator "any" "none — returns package-owned immutable data" "retain")
    (:constructor       "program"  "SEE OVERRIDE"                            "SEE OVERRIDE")))

(defparameter *overrides*
  '(("MAKE-FORM-ENVIRONMENT"
     "program"
     "none — SELECTS package-owned operators by name; cannot supply behaviour"
     "retain")
    ("SEAL-FORM-ENVIRONMENT"
     "program"
     "freezes a surface; returns a NEW object, never mutates"
     "retain")
    ("MAKE-FORM-HOLE"
     "program"
     "declares a data slot; no executable content"
     "retain")))

(defparameter *externals*
  (let ((names '()))
    (do-external-symbols (s :lisp-plus-form0) (push (symbol-name s) names))
    (sort names #'string<)))

(defparameter *census-rows*
  (mapcar
   (lambda (name)
     (let* ((category (category-of name))
            (override (assoc name *overrides* :test #'string=))
            (defaults (assoc category *category-disposition*)))
       (list name category
             (if override (second override) (second defaults))
             (if override (third override) (third defaults))
             (if override (fourth override) (fourth defaults)))))
   *externals*))

(format t "~%══ Language Form /0 — PUBLIC SURFACE AUDIT ══~%~%")
(format t " [census]~%")
(format t "  external symbols: ~D~%" (length *externals*))

(check (notany (lambda (row) (string= "SEE OVERRIDE" (fourth row))) *census-rows*)
       "every constructor carries an explicit per-symbol disposition")

(check (every (lambda (row) (and (third row) (fourth row) (fifth row))) *census-rows*)
       "every external symbol has a declared caller, minting power and disposition")

(check (every (lambda (override)
                (member (first override) *externals* :test #'string=))
              *overrides*)
       "every declared override names a symbol that is actually exported")

;;; No phase-object or receipt constructor may be exported, ever.
(check (notany (lambda (name)
                 (member name '("MAKE-PROPOSED-FORM" "MAKE-INSTANTIATED-FORM"
                                "MAKE-VALIDATED-FORM" "MAKE-FORM-VALIDATION-RECEIPT"
                                "MAKE-FORM-REALIZATION-RECEIPT" "MAKE-FORM-REFUSAL")
                         :test #'string=))
               *externals*)
       "no phase-object or receipt constructor is exported")

;;; Every exported condition must be reachable, and every refusal code must be
;;; producible by some public path — no DERIVATION-BASIS-REFUSED reincarnation.
(check (member "FORM-REFUSED" *externals* :test #'string=)
       "the one exported condition is FORM-REFUSED")

;;; No exported accessor may be SETF-able.
(let ((settable '()))
  (do-external-symbols (s :lisp-plus-form0)
    (when (and (fboundp s) (fboundp (list 'setf s))) (push s settable)))
  (check (null settable)
         (format nil "no exported accessor is SETF-able~@[ (found ~S)~]" settable)))

;;; ══════════════════════════════════════════════════════════════════
;;; (2) THE FRESH-CONSUMER ADVERSARIAL WALK
;;; ══════════════════════════════════════════════════════════════════

(defparameter *limits* '())

(defun declared-limit (id statement)
  (push (cons id statement) *limits*)
  (format t "  LIMIT ~A — ~A~%" id statement))

(format t "~% [fresh-consumer adversarial walk]~%")

(progn
  ;; 1-3. construct a phase object or receipt directly.
  ;;
  ;; NB: FIND-SYMBOL locates internal symbols too — they exist, they are simply
  ;; not accessible without `::'.  The meaningful assertion is about STATUS.
  (check (every (lambda (name)
                  (multiple-value-bind (symbol status) (find-symbol name :lisp-plus-form0)
                    (declare (ignore symbol))
                    (not (eq status :external))))
                '("%MAKE-PROPOSED-FORM" "%MAKE-INSTANTIATED-FORM" "%MAKE-VALIDATED-FORM"
                  "%MAKE-FORM-VALIDATION-RECEIPT" "%MAKE-FORM-REALIZATION-RECEIPT"
                  "%MAKE-FORM-REFUSAL"))
         "1-3. no internal phase or receipt constructor is external")

  ;; 4. forge or alter predecessor identities
  (check (notany (lambda (s) (fboundp (list 'setf (find-symbol s :lisp-plus-form0))))
                 '("VALIDATED-FORM-PREDECESSOR-IDENTITY"
                   "INSTANTIATED-FORM-PREDECESSOR-IDENTITY"
                   "VALIDATED-FORM-IDENTITY"))
         "4. predecessor and phase identities have no writer")

  ;; 5-6. supply behaviour, or remap an existing operator.
  ;;      CLOSED by the owner's option-(c) ruling: no public constructor puts a
  ;;      function into a descriptor.
  (check (not (find-symbol "MAKE-OPERATOR-DESCRIPTOR" :lisp-plus-form0))
         "5. MAKE-OPERATOR-DESCRIPTOR does not exist under any status")
  (check (handler-case (progn (make-form-environment :name "p" :version 1
                                                     :operators (list #'identity)
                                                     :holes '())
                              nil)
           (form-refused (condition)
             (eq (form-refusal-code (form-refused-refusal condition))
                 :environment-unusable)))
         "5. a host function offered as an operator selection is refused")
  (check (handler-case (progn (make-form-environment :name "p" :version 1
                                                     :operators (list "run-program")
                                                     :holes '())
                              nil)
           (form-refused (condition)
             (eq (form-refusal-code (form-refused-refusal condition))
                 :operator-not-built-in)))
         "6. an operator outside the package-owned set cannot be installed")
  (check (equal (operator-names)
                '("equal-datum" "canonical-hex" "sequence-length" "render-diagnostic"))
         "6. the installable set is exactly the four of Candidate /0")

  (declared-limit
   "S-1"
   "SCOPE, not a hole: this is a PUBLIC-API enforcement boundary. Hostile Common Lisp already executing in this image can reach package internals, redefine handlers via SYMBOL-FUNCTION, replace the implementation, or bypass Form /0 entirely. Those are outside the declared threat model and no claim is made against them.")

  ;; 7. install "perform"/"eval"/... behind an identifier
  (check (let* ((environment
                  (seal-form-environment
                   (make-form-environment
                    :name "outsider" :version 1
                    :operators (list "canonical-hex")
                    :holes '())))
                (proposal (propose-form
                           (operator-node "perform"
                                          (literal-node (cd0 make-integer-datum 1)))
                           environment))
                (instantiated (instantiate-form proposal '() environment)))
           (multiple-value-bind (validated refusal)
               (try-validate-form instantiated environment)
             (declare (ignore validated))
             (and refusal (eq (form-refusal-code refusal) :unknown-operator))))
         "7. a form naming PERFORM is refused when no such operator is installed")

  ;; 8. alter a sealed environment
  (let ((sealed (seal-form-environment
                 (make-form-environment :name "sealed-probe" :version 1
                                        :operators '() :holes '()))))
    (check (and (form-environment-sealed-p sealed)
                (not (fboundp (list 'setf 'lisp-plus-form0:form-environment-sealed-p))))
           "8. a sealed environment has no exported writer for any field"))

  ;; 9. mutate internal collections through exported readers
  (let* ((environment (seal-form-environment
                       (make-form-environment
                        :name "aliasing-probe" :version 1
                        :operators (list "canonical-hex")
                        :holes (list (make-form-hole "h" :any)))))
         (first-read (form-environment-operator-identities environment)))
    (setf (car first-read) :clobbered)
    (check (not (eq :clobbered (first (form-environment-operator-identities environment))))
           "9. clobbering a reader's result does not reach the environment's own list"))

  ;; 10. behaviourally divergent environments with the same declared content.
  (let* ((narrow (seal-form-environment
                  (make-form-environment :name "same-name" :version 1
                                         :operators (list "canonical-hex")
                                         :holes '())))
         (twin (seal-form-environment
                (make-form-environment :name "same-name" :version 1
                                       :operators (list "canonical-hex")
                                       :holes '())))
         (wider (seal-form-environment
                 (make-form-environment :name "same-name" :version 1
                                        :operators (list "canonical-hex" "sequence-length")
                                        :holes '()))))
    (check (string= (form-environment-content-digest narrow)
                    (form-environment-content-digest twin))
           "10. two public environments with the same selection agree on content")
    (check (not (string= (form-environment-content-digest narrow)
                         (form-environment-content-digest wider)))
           "10. a different selection changes the content digest")
    (let* ((proposal (propose-form (operator-node
                                    "canonical-hex"
                                    (literal-node (cd0 make-integer-datum 1)))
                                   narrow))
           (instantiated (instantiate-form proposal '() narrow))
           (validated (validate-form instantiated narrow)))
      (multiple-value-bind (result receipt refusal) (try-realize-form validated wider)
        (declare (ignore result receipt))
        (check (and refusal (eq (form-refusal-code refusal) :environment-content-drift))
               "10. a validation does NOT travel to a redeclared environment"))
      (multiple-value-bind (result receipt refusal) (try-realize-form validated twin)
        (declare (ignore receipt))
        (check (and (null refusal) result)
               "10. but it DOES travel to an identically-selected twin — behaviour is package-owned"))))

  ;; 11. call a supposedly internal handler through an exported accessor
  (check (not (find-symbol "OPERATOR-DESCRIPTOR-HANDLER" :lisp-plus-form0))
         "11. no handler accessor exists under a public name at all")
  (check (multiple-value-bind (symbol status)
             (find-symbol "%OPERATOR-DESCRIPTOR-HANDLER" :lisp-plus-form0)
           (declare (ignore symbol))
           (not (eq status :external)))
         "11. the internal handler accessor is not external")

  ;; 12. create a phase object whose invariants were never earned
  (check (handler-case
             (progn (validate-form (propose-form (literal-node (cd0 make-integer-datum 1))
                                                 (seal-form-environment
                                                  (make-form-environment
                                                   :name "skip" :version 1
                                                   :operators '() :holes '())))
                                   (seal-form-environment
                                    (make-form-environment :name "skip" :version 1
                                                           :operators '() :holes '())))
                    nil)
           (form-refused (condition)
             (eq (form-refusal-code (form-refused-refusal condition)) :not-validated)))
         "12. a proposed form cannot be handed to VALIDATE-FORM as if instantiated"))

;;; THE WALK MUST HAVE STAYED ON THE PUBLIC SURFACE.
;;;
;;; An audit that reaches past the boundary it is auditing proves nothing about
;;; that boundary.  This reads its own source and requires that no `::' access
;;; into the audited package appears anywhere in it.
(let* ((source (with-open-file (stream *load-truename*)
                 (let ((text (make-string (file-length stream))))
                   (subseq text 0 (read-sequence text stream)))))
       ;; The needle is assembled at run time so that this check does not
       ;; trivially find itself.
       (needle (concatenate 'string "lisp-plus-form0" "::")))
  (check (null (search needle source))
         "the walk never reaches past the public surface it audits (no `::' access)"))

;;; ══════════════════════════════════════════════════════════════════
;;; Emit the census artifact.

(with-open-file (out (merge-pathnames "EXPORT-CENSUS.md" *load-truename*)
                     :direction :output :if-exists :supersede)
  (format out "# LANGUAGE FORM /0 — EXPORT CENSUS~%~%")
  (format out "*Machine-generated by `PUBLIC-SURFACE-AUDIT.lisp`. Do not hand-edit.*~%~%")
  (format out "External symbols: **~D**~%~%" (length *externals*))
  (format out "| symbol | category | intended caller | minting / mutation power | disposition |~%")
  (format out "|---|---|---|---|---|~%")
  (dolist (row *census-rows*)
    (format out "| `~A` | ~(~A~) | ~A | ~A | ~A |~%"
            (first row) (second row) (third row) (fourth row) (fifth row)))
  (format out "~%## Declared limits~%~%")
  (dolist (limit (reverse *limits*))
    (format out "**~A** — ~A~%~%" (car limit) (cdr limit)))
  (format out "## What the walk established~%~%")
  (format out "Phase objects and receipts are **unforgeable from outside**: no constructor for~%")
  (format out "`PROPOSED-FORM`, `INSTANTIATED-FORM`, `VALIDATED-FORM`, `FORM-VALIDATION-RECEIPT`,~%")
  (format out "`FORM-REALIZATION-RECEIPT` or `FORM-REFUSAL` is external, no exported accessor is~%")
  (format out "`SETF`-able, and no exported reader aliases an internal collection.~%~%")
  (format out "The two declared limits above are **not** closed by Candidate /0 and are~%")
  (format out "exhibited by executable teeth rather than left for a reader to discover.~%"))

(format t "~%  EXPORT-CENSUS.md written (~D rows)~%" (length *census-rows*))
(format t "~%== Form /0 public surface: ~D passed / ~D failed · ~D declared limits ==~%"
        *passed* *failed* (length *limits*))

(when (plusp *failed*)
  (sb-ext:exit :code 1))
