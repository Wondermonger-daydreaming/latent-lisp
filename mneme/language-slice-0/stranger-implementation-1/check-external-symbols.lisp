;;;; check-external-symbols.lisp
;;;;
;;;; LIMES — the loader-based external-symbol audit (the ROBUST half of the
;;;; front-door checker). This trusts NOTHING a program's text claims about
;;;; itself. It loads the governed Lisp+ Slice /0 surface + the verifier, then
;;;; READs the target program form by form and walks every read form for
;;;; package-qualified symbol references whose HOME package is one of the
;;;; governed packages (LISP-PLUS-SLICE0, LISP-PLUS-KERNEL0, SUPPLY-LAB).
;;;; Every such symbol MUST be EXTERNAL (exported) in its home package. Any
;;;; internal symbol reached is a front-door violation.
;;;;
;;;; The value this adds over a regex is that it reads the ACTUAL live symbol
;;;; table after the packages are loaded — export status is read from the
;;;; image, never guessed from a name pattern. A single-colon reference to a
;;;; non-exported symbol is itself a reader error; we catch that and report it
;;;; as an internal-reference finding (it is exactly the smell we are hunting).
;;;;
;;;; Invocation (from the experiment dir, cwd there so `../` resolves):
;;;;   sbcl --non-interactive \
;;;;        --load ../slice0-transmissibility.lisp \
;;;;        --load task-inputs/verifier.lisp \
;;;;        --load check-external-symbols.lisp \
;;;;        --eval '(check-external-symbols:audit "TARGET.lisp")'
;;;;
;;;; Prints a final line `EXTERNAL-SYMBOL-AUDIT: N internal-symbol reference(s)`
;;;; and exits non-zero iff N>0.

(defpackage :check-external-symbols
  (:use :cl)
  (:export #:audit))

(in-package :check-external-symbols)

(defparameter *governed-package-names*
  '("LISP-PLUS-SLICE0" "LISP-PLUS-KERNEL0" "SUPPLY-LAB")
  "Home packages whose symbols must all be reached EXTERNAL-ly.")

(defun governed-package-p (pkg)
  (and pkg
       (member (package-name pkg) *governed-package-names* :test #'string=)))

(defun structure-forms-only-p (form)
  "We never expect struct/hash literals in program source text; guard anyway."
  (declare (ignore form))
  nil)

(defun walk-form (form violations)
  "Recursively descend FORM. For every symbol whose home package is governed
but which is not EXTERNAL there, push a (name . package-name) onto VIOLATIONS
\(a hash-table used as a set)."
  (cond
    ((symbolp form)
     (let ((home (symbol-package form)))
       (when (governed-package-p home)
         (multiple-value-bind (found status)
             (find-symbol (symbol-name form) home)
           (declare (ignore found))
           (unless (eq status :external)
             (setf (gethash (format nil "~a:~a"
                                    (package-name home)
                                    (symbol-name form))
                            violations)
                   (list (symbol-name form) (package-name home) status)))))))
    ((consp form)
     (walk-form (car form) violations)
     (walk-form (cdr form) violations))
    ((and (vectorp form) (not (stringp form)))
     (loop for x across form do (walk-form x violations)))
    (t nil)))

(defun eval-package-form-p (form)
  "T iff FORM is a defpackage/in-package top-level form we should eval so that
subsequent reads resolve unqualified symbols against the program's own package."
  (and (consp form)
       (symbolp (car form))
       (member (symbol-name (car form)) '("DEFPACKAGE" "IN-PACKAGE")
               :test #'string=)))

(defun audit (target-path)
  "Read TARGET-PATH form by form; report every governed internal-symbol
reference plus any reader error (a single-colon reference to a non-exported
symbol manifests as one). Prints findings, a summary line, and exits with a
non-zero code iff any internal reference (or read error) was found."
  (let ((violations (make-hash-table :test 'equal))
        (read-errors '())
        (form-count 0))
    ;; ONE shared sentinel each — `'#:eof` in source makes a FRESH uninterned
    ;; symbol per read, so distinct literals never `eq`. Bind once.
    (let ((eof (list :eof))
          (done (list :done)))
      (handler-case
          (with-open-file (s target-path :direction :input)
            (let ((*read-eval* nil)               ; no `#.` side effects
                  (*package* (find-package :check-external-symbols)))
              (loop
                (let ((form
                        (handler-case (read s nil eof)
                          (error (e)
                            ;; A reader error here is almost always a
                            ;; single-colon reference to a NON-EXPORTED symbol,
                            ;; or a package that does not exist. A front-door
                            ;; finding.
                            (push (format nil "~a" e) read-errors)
                            done))))
                  (when (or (eq form eof) (eq form done))
                    (return))
                  (incf form-count)
                  (when (eval-package-form-p form)
                    (handler-case (eval form) (error () nil)))
                  (walk-form form violations)))))
        (error (e)
          (format t "~&EXTERNAL-SYMBOL-AUDIT: FATAL — could not open/scan ~a: ~a~%"
                  target-path e)
          (finish-output)
          (sb-ext:exit :code 2))))
    ;; Report.
    (format t "~&; external-symbol audit of ~a (~a form(s) read)~%"
            target-path form-count)
    (let ((n 0))
      (maphash (lambda (k v)
                 (declare (ignore k))
                 (incf n)
                 (format t ";   INTERNAL-REF  ~a:~a  [home ~a, status ~a]~%"
                         (second v) (first v) (second v) (third v)))
               violations)
      (dolist (e (nreverse read-errors))
        (incf n)
        (format t ";   READ-ERROR (likely single-colon internal ref): ~a~%" e))
      (format t "EXTERNAL-SYMBOL-AUDIT: ~a internal-symbol reference(s)~%" n)
      (finish-output)
      (sb-ext:exit :code (if (plusp n) 1 0)))))
