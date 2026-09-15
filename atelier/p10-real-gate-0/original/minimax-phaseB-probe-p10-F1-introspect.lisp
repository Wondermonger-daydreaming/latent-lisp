;;;; Probe P10: F1 — no external function of this lane carries a `defect`
;;;; or `defect-payload` parameter, read out of the COMPILED lambda lists
;;;; by sb-introspect, not out of source text by grep.

(load "/mnt/venue/WORK/substrate/lane/ml0-suite-ground.lisp")

(require :sb-introspect)
(in-package #:lisp-plus-memory-layer0)

(format t "~&=== Probe P10 / F1: sb-introspect scan ===~%")

(defparameter *bad* '())
(defparameter *total* 0)
(defparameter *total-external* 0)
(defparameter *external-names*
  (symbol-value (find-symbol "+ML0-EXTERNAL-FUNCTIONS+" '#:lisp-plus-memory-layer0-loader)))
(dolist (name *external-names*)
  (incf *total-external*)
  (let* ((sym (find-symbol name '#:lisp-plus-memory-layer0))
         (lambda-list nil))
    (when (and sym (fboundp sym))
      (incf *total*)
      (setf lambda-list (handler-case (sb-introspect:function-lambda-list sym)
                          (error (e) (format nil "ERROR:~a" e))))
      (when (and (listp lambda-list)
                 (or (member 'defect lambda-list)
                     (member 'defect-payload lambda-list)
                     (member :defect lambda-list)
                     (member :defect-payload lambda-list)))
        (push (cons name lambda-list) *bad*)))))

(format t "~&external functions declared: ~d~%" *total-external*)
(format t "~&external functions fbound: ~d~%" *total*)
(format t "~&external functions with defect or defect-payload: ~d~%" (length *bad*))
(dolist (b *bad*) (format t "~&  bad: ~s -> ~s~%" (car b) (cdr b)))

;; Now also load the overlay and re-check (F1c)
(format t "~&=== F1c: load overlay, re-check ===~%")
(load "/mnt/venue/WORK/substrate/lane/ml0-mutant-overlay.lisp")
(defparameter *bad-overlay* '())
(defparameter *total-overlay* 0)
(dolist (name *external-names*)
  (let* ((sym (find-symbol name '#:lisp-plus-memory-layer0))
         (lambda-list nil))
    (when (and sym (fboundp sym))
      (incf *total-overlay*)
      (setf lambda-list (handler-case (sb-introspect:function-lambda-list sym)
                          (error (e) (format nil "ERROR:~a" e))))
      (when (and (listp lambda-list)
                 (or (member 'defect lambda-list)
                     (member 'defect-payload lambda-list)
                     (member :defect lambda-list)
                     (member :defect-payload lambda-list)))
        (push (cons name lambda-list) *bad-overlay*)))))

(format t "~&with overlay loaded, external functions fbound: ~d~%" *total-overlay*)
(format t "~&with overlay loaded, external functions with defect or defect-payload: ~d~%" (length *bad-overlay*))
(dolist (b *bad-overlay*) (format t "~&  bad (with overlay): ~s -> ~s~%" (car b) (cdr b)))

(format t "~&=== VERDICT ===~%")
(format t "~&P10: ~a~%"
        (cond ((and (zerop (length *bad*)) (zerop (length *bad-overlay*)))
               "PASS — no external function carries defect or defect-payload, with or without the overlay")
              (t (format nil "FAIL — ~d bad before overlay, ~d bad after overlay" (length *bad*) (length *bad-overlay*)))))

(sb-ext:exit :code (if (and (zerop (length *bad*)) (zerop (length *bad-overlay*))) 0 1))
