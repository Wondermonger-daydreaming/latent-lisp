;;;; run.lisp — PROGRAM /0's direct execution command.
;;;;
;;;;   sbcl --script mneme/language-program-0/run.lisp <program.lp>
;;;;   (or, the one command with the host stack it wants:  bash mneme/language-program-0/lisp-plus-run.sh <program.lp>)
;;;;
;;;; Reads ONE Lisp+ source file, evaluates it under PROGRAM /0 semantics, prints
;;;; the value of its last top-level form to stdout, and exits:
;;;;   0  a value was produced (definitions print as `; defined <name>`)
;;;;   2  a LANGUAGE error — printed to stderr with code, file:line:column, the
;;;;      forms under evaluation and the user-function frames
;;;;   3  usage: no file, or the file does not exist
;;;;   1  a HOST fault: a condition that is not one of the language's own — a
;;;;      defect of this implementation, not of the program; the host type is named
;;;;
;;;; STDOUT IS THE PROGRAM'S. Everything else — the Kernel /0 load smoke line,
;;;; the toolchain gate, errors — goes to stderr, so a program's output is only
;;;; what it printed and its final value.
;;;;
;;;; WHAT IS LOADED: Kernel /0 (for `kernel0/determinacy`, a derivation) and this
;;;; lane. NOT loaded: core0, act0, act1, many-acts0 — the lanes that perform.
;;;; A program cannot reach an effect from here because nothing that performs
;;;; is in the image; the selftest witnesses that absence.
;;;;
;;;; USER EXPRESSIONS ARE NEVER HANDED TO `cl:eval`. The only `read` is the
;;;; language's own reader under the reader law; the only evaluation is
;;;; lisp-plus-program0:evaluate.
;;;;
;;;; CANDIDATE. Running this adopts nothing.

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output* "~&lisp-plus: this runner is declared for SBCL 2.4.6 only; observed ~a. No portability is claimed.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*program0-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

;;; Load Kernel /0 and this lane with stdout diverted: their load chatter is not
;;; the program's output.
(let ((*standard-output* *error-output*))
  (load (merge-pathnames "../kernel0/load.lisp" cl-user::*program0-here*))
  (load (merge-pathnames "package.lisp" cl-user::*program0-here*))
  (load (merge-pathnames "program0.lisp" cl-user::*program0-here*)))

(defun cl-user::program0-main ()
  (let ((arg (second sb-ext:*posix-argv*)))
    (unless arg
      (format *error-output* "usage: sbcl --script run.lisp <program.lp>~%")
      (finish-output *error-output*)
      (sb-ext:exit :code 3))
    (let ((path (probe-file arg)))
      (unless path
        (format *error-output* "lisp-plus: no such file: ~a~%" arg)
        (finish-output *error-output*)
        (sb-ext:exit :code 3))
      (handler-case
          (multiple-value-bind (value definedp)
              (lisp-plus-program0:run-file path)
            (if definedp
                (format t "; defined ~a~%" (lisp-plus-program0:render value))
                (format t "~a~%" (lisp-plus-program0:render value)))
            (finish-output)
            (sb-ext:exit :code 0))
        (lisp-plus-program0:program0-error (c)
          (finish-output)
          (format *error-output* "~a~%" (lisp-plus-program0:render-program0-error c))
          (finish-output *error-output*)
          (sb-ext:exit :code 2))
        (error (c)
          (finish-output)
          (format *error-output* "lisp-plus: HOST FAULT (a defect of the implementation, not of your program): ~a: ~a~%"
                  (type-of c) c)
          (finish-output *error-output*)
          (sb-ext:exit :code 1))))))

(cl-user::program0-main)
