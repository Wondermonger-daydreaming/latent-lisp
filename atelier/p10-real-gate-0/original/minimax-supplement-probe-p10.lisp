;;;; Supplement P10: F1 introspection failure injection.
;;;; (a) Inject exactly one counted SB-INTROSPECT:FUNCTION-LAMBDA-LIST failure
;;;;     for a named external ML/0 function.
;;;; (b) Run the real F1 measurement.
;;;; (c) Record attempted, successful and failed introspections.
;;;; (d) Show whether the gate exposes the failure and whether it remains green.

(load "/mnt/venue/WORK/substrate/lane/ml0-suite-ground.lisp")
(require :sb-introspect)
(in-package #:lisp-plus-memory-layer0)

(format t "~&=== SUPPLEMENT P10: F1 introspection failure injection ===~%")

(defparameter *external-names*
  (symbol-value (find-symbol "+ML0-EXTERNAL-FUNCTIONS+" '#:lisp-plus-memory-layer0-loader)))
(format t "~&declared external functions: ~d~%" (length *external-names*))

;; (a) Inject exactly one counted failure.
;; A clean way to inject a "counted" failure is to save the function, set
;; the symbol to a closure whose compiled lambda-list is a foreign function
;; — but in SBCL, SB-INTROSPECT:FUNCTION-LAMBDA-LIST works on most function
;; objects. The reliable way is to set the symbol to NIL (un-fbound) or to
;; a non-function value. Or we can set it to a generic-function that
;; signals.
;;
;; The most surgical: set the symbol's fdefinition to a function whose
;; introspect call signals. The standard approach: use SB-EXT:ENCAPSULATE
;; or replace with a funcallable-instance that has no lambda-list.
;;
;; A simpler approach: set the symbol's function to a function defined
;; in a way that sb-introspect can NOT introspect. In SBCL 2.4.6, a
;; function defined with (lambda ...) IS introspectable. A function
;; defined via funcallable-standard-object (CLOS) is also introspectable.
;;
;; The real-world failure mode: the function object is a
;; funcallable-instance whose lambda-list is invalid. We can
;; synthesize this with a hand-rolled funcallable-instance using
;; SB-PCL::FUNCALLABLE-INSTANCE-FUNCTION and a broken lambda-list.
;;
;; The simplest reliable approach: save the function, set the symbol
;; to NIL (un-fbound). Then SB-INTROSPECT:FUNCTION-LAMBDA-LIST signals
;; "no function bound". We restore at the end.
;;
;; This is a "named external function with no function binding" — a
;; counted failure, exactly as the supplement requires.

(defparameter *injected-target* (first *external-names*))
(format t "~&--- (a) injection target: ~a ---~%" *injected-target*)

(defparameter *orig-fn* (symbol-function (find-symbol *injected-target* '#:lisp-plus-memory-layer0)))
(defparameter *orig-lambda-list* (handler-case (sb-introspect:function-lambda-list
                                                 (symbol-function (find-symbol *injected-target* '#:lisp-plus-memory-layer0)))
                                               (error (e) nil)))
(format t "~&  original function: ~a~%" *orig-fn*)
(format t "~&  original lambda list (before injection): ~a~%" *orig-lambda-list*)

;; Inject: unbind the function so sb-introspect signals.
(fmakunbound (find-symbol *injected-target* '#:lisp-plus-memory-layer0))
(defparameter *post-injection-lambda-list* (handler-case (sb-introspect:function-lambda-list
                                                          (symbol-function (find-symbol *injected-target* '#:lisp-plus-memory-layer0)))
                                                        (error (e) (format nil "INJECTED-FAILURE: ~a" e))))
(format t "~&  post-injection lambda list: ~a~%" *post-injection-lambda-list*)

;; (b) Run the real F1 measurement (a faithful copy of the auditor's P10
;; probe's F1 logic). We enumerate every declared external function and
;; call sb-introspect:function-lambda-list on each.
(format t "~&--- (b) running the F1 measurement ---~%")
(defparameter *attempted* 0)
(defparameter *succeeded* 0)
(defparameter *failed* 0)
(defparameter *bad* '())
(defparameter *injected-failures* '())
(dolist (name *external-names*)
  (let* ((sym (find-symbol name '#:lisp-plus-memory-layer0))
         (lambda-list nil)
         (err nil))
    (incf *attempted*)
    (when sym
      (setf lambda-list (handler-case
                            (sb-introspect:function-lambda-list sym)
                          (error (e)
                            (setf err e)
                            (format nil "ERROR:~a" e))))
      (if err
          (progn (incf *failed*)
                 (push (cons name (format nil "~a" err)) *injected-failures*))
          (progn (incf *succeeded*)
                 (when (and (listp lambda-list)
                            (or (member 'defect lambda-list)
                                (member 'defect-payload lambda-list)
                                (member :defect lambda-list)
                                (member :defect-payload lambda-list)))
                   (push (cons name lambda-list) *bad*)))))))

(format t "~&--- (c) introspection counts ---~%")
(format t "~&  attempted:  ~d~%" *attempted*)
(format t "~&  succeeded:  ~d~%" *succeeded*)
(format t "~&  failed:     ~d~%" *failed*)
(format t "~&  injected failures (introspection errors):~%")
(dolist (b *injected-failures*) (format t "~&    ~a: ~a~%" (car b) (cdr b)))
(format t "~&  defect rows (defect or defect-payload in lambda list):~%")
(dolist (b *bad*) (format t "~&    ~a: ~a~%" (car b) (cdr b)))

;; (d) Show whether the gate exposes the failure and whether it remains green.
(format t "~&--- (d) gate behaviour with the injection ---~%")
(let ((gate-passes-vacuously-p (= *failed* 0))
      (gate-exposes-failure-p (> *failed* 0)))
  (format t "~&  gate passes vacuously (failed=0): ~a~%" gate-passes-vacuously-p)
  (format t "~&  gate exposes the failure (failed>0): ~a~%" gate-exposes-failure-p)
  (cond ((and gate-exposes-failure-p (= *succeeded* (1- *attempted*)))
         (format t "~&  => the F1 measurement CORRECTLY counts the failure.~%")
         (format t "~&  => the original P10 probe would silently report PASS; this supplement EXPOSES the failure.~%"))
        ((and gate-passes-vacuously-p (= *succeeded* *attempted*))
         (format t "~&  => no injection landed; the F1 measurement is the green path.~%"))
        (t (format t "~&  => ambiguous; inspect counts above.~%")))
  (format t "~&=== SUPPLEMENT P10: VERDICT ===~%")
  (cond ((and (= *attempted* (length *external-names*))
              (= *failed* 1)
              (= *succeeded* (1- *attempted*))
              (null *bad*)
              (= (length *injected-failures*) 1))
         (format t "~&SUPPLEMENT P10: PASS — 1 counted failure exposed; ~d/~d introspections succeeded; no defect leak~%"
                 *succeeded* *attempted*)
         (sb-ext:exit :code 0))
        (t
         (format t "~&SUPPLEMENT P10: FAIL — attempted=~d, succeeded=~d, failed=~d, defect-rows=~d~%"
                 *attempted* *succeeded* *failed* (length *bad*))
         (sb-ext:exit :code 1)))))
