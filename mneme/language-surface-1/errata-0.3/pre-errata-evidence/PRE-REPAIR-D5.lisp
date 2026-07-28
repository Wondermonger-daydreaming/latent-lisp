;;;; PRE-REPAIR-D5.lisp — Errata 0.3 pre-repair witness for D5.
;;;;
;;;; The public term functions die on deep ACYCLIC input.  Each half runs as a
;;;; SEPARATE PROCESS because the decode half is a fatal image abort that no
;;;; handler can catch — that is the finding, and an instrument that shared an
;;;; image with it could not report anything afterwards.
;;;;
;;;; Usage:  sbcl --non-interactive --load PRE-REPAIR-D5.lisp encode <depth>
;;;;         sbcl --non-interactive --load PRE-REPAIR-D5.lisp decode <depth>
;;;;
;;;; Audit witness: audits/…/probes/FOSSOR/P3e-encode-term-stack.lisp, P3f.

(handler-bind ((style-warning #'muffle-warning))
  (load "/home/gauss/Desktop/Claude-Code-Lab/experiments/latent-lisp/mneme/language-surface-1/surface1.lisp"))

(defpackage #:e03-d5 (:use #:cl))
(in-package #:e03-d5)

(defmacro s1 (name &rest args)
  (let ((p (find-package '#:lisp-plus-surface1)))
    (multiple-value-bind (sym status) (find-symbol (string name) p)
      (unless (eq status :external)
        (error "instrument reached a non-external symbol ~A (status ~S)" name status))
      `(,sym ,@args))))

(defun nested-car-form (depth)
  "A plain ACYCLIC nested list — no sharing, no cycle: (((…(0)…)))."
  (let ((f 0)) (dotimes (i depth f) (setf f (list f)))))

(defun nested-term-datum (depth)
  "A well-shaped LIST-term datum DEPTH levels deep, built with CD/0
constructors alone — no Surface /1 door is involved."
  (let ((d (lisp-plus-cd0:make-record-datum
            (list (lisp-plus-cd0:make-record-entry
                   (lisp-plus-cd0:make-identifier-datum '("TERM") '("KIND"))
                   (lisp-plus-cd0:make-identifier-datum '("TERMKIND") '("INTEGER")))
                  (lisp-plus-cd0:make-record-entry
                   (lisp-plus-cd0:make-identifier-datum '("TERM") '("VALUE"))
                   (lisp-plus-cd0:make-integer-datum 0))))))
    (dotimes (i depth d)
      (setf d (lisp-plus-cd0:make-record-datum
               (list (lisp-plus-cd0:make-record-entry
                      (lisp-plus-cd0:make-identifier-datum '("TERM") '("KIND"))
                      (lisp-plus-cd0:make-identifier-datum '("TERMKIND") '("LIST")))
                     (lisp-plus-cd0:make-record-entry
                      (lisp-plus-cd0:make-identifier-datum '("TERM") '("VALUE"))
                      (lisp-plus-cd0:make-sequence-datum (list d)))))))))

(let* ((which (second sb-ext:*posix-argv*))
       (depth (parse-integer (or (third sb-ext:*posix-argv*) "40000"))))
  (format t "~&D5 pre-repair · ~A · depth ~D · grammar v~D~%"
          which depth (s1 expansion-grammar-version))
  (finish-output)
  (cond
    ((string= which "encode")
     (let ((form (nested-car-form depth)))
       (format t "  built an acyclic form; calling the PUBLIC ENCODE-TERM…~%")
       (finish-output)
       (handler-case (progn (s1 encode-term form)
                            (format t "  RESULT: encoded (no refusal, no death)~%"))
         (storage-condition (c)
           (format t "  RESULT: CONTROL STACK EXHAUSTED — ~A~%" (type-of c)))
         (error (c)
           (format t "  RESULT: signalled ~A~%" (type-of c))))))
    ((string= which "decode")
     (let ((datum (nested-term-datum depth)))
       (format t "  built a deep well-shaped term datum; calling the PUBLIC DECODE-TERM…~%")
       (format t "  (if this process dies here, the death IS the finding)~%")
       (finish-output)
       (handler-case (progn (s1 decode-term datum)
                            (format t "  RESULT: decoded (no refusal, no death)~%"))
         (storage-condition (c)
           (format t "  RESULT: CONTROL STACK EXHAUSTED — ~A~%" (type-of c)))
         (error (c)
           (format t "  RESULT: signalled ~A~%" (type-of c))))))
    (t (format t "  usage: encode|decode <depth>~%")))
  (finish-output))

(sb-ext:exit :code 0)
