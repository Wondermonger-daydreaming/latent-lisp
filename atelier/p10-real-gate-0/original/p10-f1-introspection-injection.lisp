(require :sb-introspect)

(defparameter *frigus-original-function-lambda-list*
  (symbol-function 'sb-introspect:function-lambda-list))
(defparameter *frigus-introspection-calls* 0)
(defparameter *frigus-target-injections* 0)

(setf (symbol-function 'sb-introspect:function-lambda-list)
      (lambda (thing)
        (incf *frigus-introspection-calls*)
        (if (and (symbolp thing)
                 (string= "ML0-WRITE" (symbol-name thing))
                 (symbol-package thing)
                 (string= "LISP-PLUS-MEMORY-LAYER0"
                          (package-name (symbol-package thing))))
            (progn
              (incf *frigus-target-injections*)
              (format t "~&FRIGUS-INJECTED-INTROSPECTION-ERROR: ~s~%" thing)
              (error "FRIGUS targeted introspection failure"))
            (funcall *frigus-original-function-lambda-list* thing))))

(push (lambda ()
        (format t "~&FRIGUS-INTROSPECTION-CALLS: ~d~%"
                *frigus-introspection-calls*)
        (format t "FRIGUS-TARGET-INJECTIONS: ~d~%"
                *frigus-target-injections*)
        (finish-output))
      sb-ext:*exit-hooks*)

(load "mneme/memory-layer-0/ml0-block-proof.lisp")

