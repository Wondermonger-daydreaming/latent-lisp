;;; interposer.lisp -- FRIGUS's mechanism reproduced (PREREG-P10-RG-0 §2).
;;;
;;; Whole-function REDEFINITION of the instrument via (setf symbol-function)
;;; -- not sb-int:encapsulate, not a wrapper around the gate -- exactly as
;;; original/p10-f1-introspection-injection.lisp:3-20 did, then a plain `load`
;;; of the REAL gate file, cwd-relative, in the SAME process
;;; (original:30).  The gate's bytes, load chain and exit call are untouched;
;;; sb-ext:exit inside the loaded file ends the process and the exit hook
;;; prints the counts.
;;;
;;; Target selection: env P10_TARGET names a symbol by SYMBOL-NAME; the wrapper
;;; injects only for a symbol of that name whose home package is
;;; LISP-PLUS-MEMORY-LAYER0 (same two-part test as FRIGUS).  With P10_TARGET
;;; unset this is the pure counting control (B0-I, M1-U-I): every call is
;;; counted and passed through.
;;;
;;; Prints on the injected call:   INJECTED-INTROSPECTION-ERROR: <NAME>
;;; Prints from the exit hook:     INTERPOSER-CALLS: <n>
;;;                                INTERPOSER-TARGET-INJECTIONS: <n>

(require :sb-introspect)

(defparameter *p10-original-function-lambda-list*
  (symbol-function 'sb-introspect:function-lambda-list))
(defparameter *p10-introspection-calls* 0)
(defparameter *p10-target-injections* 0)
(defparameter *p10-target* (sb-ext:posix-getenv "P10_TARGET"))
(defparameter *p10-target-package* "LISP-PLUS-MEMORY-LAYER0")

(format t "~&INTERPOSER-TARGET: ~a~%"
        (if (and *p10-target* (plusp (length *p10-target*)))
            *p10-target*
            "(none -- counting control)"))
(finish-output)

(setf (symbol-function 'sb-introspect:function-lambda-list)
      (lambda (thing)
        (incf *p10-introspection-calls*)
        (if (and *p10-target*
                 (plusp (length *p10-target*))
                 (symbolp thing)
                 (string= *p10-target* (symbol-name thing))
                 (symbol-package thing)
                 (string= *p10-target-package*
                          (package-name (symbol-package thing))))
            (progn
              (incf *p10-target-injections*)
              (format t "~&INJECTED-INTROSPECTION-ERROR: ~a~%" thing)
              (finish-output)
              (error "P10 targeted introspection failure"))
            (funcall *p10-original-function-lambda-list* thing))))

(push (lambda ()
        (format t "~&INTERPOSER-CALLS: ~d~%" *p10-introspection-calls*)
        (format t "INTERPOSER-TARGET-INJECTIONS: ~d~%" *p10-target-injections*)
        (finish-output))
      sb-ext:*exit-hooks*)

(load "mneme/memory-layer-0/ml0-block-proof.lisp")
