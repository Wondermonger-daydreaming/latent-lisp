;;;; FOSSOR's OWN minimal stub-image variant.  Not their fixture: a different
;;;; construct (DERIVE-CASE, not DEFINE-ADMISSION-CONTRACT), the package built
;;;; with (:use) and no :export at all, and the symbol reached by INTERN so that
;;;; the construct name is merely PRESENT, never exported.  surface0.lisp is
;;;; never loaded in this process.
(defparameter *s1dir* (pathname (or (second sb-ext:*posix-argv*)
  "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/")))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*)))
(defpackage #:lisp-plus-surface0 (:use))            ; NO exports at all
(intern "DERIVE-CASE" '#:lisp-plus-surface0)
(defpackage #:fossor-stub (:use #:common-lisp))
(in-package #:fossor-stub)
(defmacro s1 (name &rest args)
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-surface1)
    (unless (eq status :external) (error "S1: ~A is ~S, not :EXTERNAL" name status))
    `(,sym ,@args)))
(defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))
(format t "~&FOSSOR STUB-IMAGE VARIANT · SBCL ~A~%" (lisp-implementation-version))
(format t "surface0 file loaded in this image? ~A~%"
        (if (find-symbol "%PARSE-ARMS" '#:lisp-plus-surface0) "YES (bad)" "NO"))
(defparameter *head* (find-symbol "DERIVE-CASE" '#:lisp-plus-surface0))
(format t "head symbol ~S · status in its package ~S · macro-function ~S~%"
        *head* (nth-value 1 (find-symbol "DERIVE-CASE" '#:lisp-plus-surface0))
        (macro-function *head*))
(defparameter *req* (s1 request-expansion (list *head* '(cl-user::c cl-user::r))
                        :macroexpand-1 (cd0 make-identifier-datum '("fossor") '("stub"))))
(multiple-value-bind (rc ex rf) (s1 try-perform-expansion *req*)
  (declare (ignore ex))
  (format t "DOOR 1 minted a request with construct identity? ~A~%"
          (and (s1 expansion-request-construct-identity *req*) t))
  (format t "receipt minted? ~A~%" (and rc t))
  (format t "refusal code ~S · phase ~S · category ~S~%"
          (s1 expansion-refusal-code rf) (s1 expansion-refusal-phase rf)
          (s1 expansion-refusal-category rf))
  (format t "catalogue says phase ~S class ~S reachability ~S~%"
          (s1 refusal-catalog-entry-phase
              (assoc :construct-not-a-macro (s1 expansion-refusal-code-catalog)))
          (s1 refusal-catalog-entry-class
              (assoc :construct-not-a-macro (s1 expansion-refusal-code-catalog)))
          (s1 refusal-catalog-entry-reachability
              (assoc :construct-not-a-macro (s1 expansion-refusal-code-catalog))))
  (format t "MATCH? ~A~%" (and (null rc) (eq :construct-not-a-macro (s1 expansion-refusal-code rf))
                               (eq :perform (s1 expansion-refusal-phase rf))
                               (eq :protocol-refusal (s1 expansion-refusal-category rf)))))
