;;;; probe-B.lisp — is :EXPANDED-NODES-EXCEEDED really unreachable under this policy?
(defparameter *s1dir*
  (pathname "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/"))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *s1dir*)))

(defpackage #:tabb (:use #:common-lisp))
(in-package #:tabb)
(defmacro s1 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-surface1) ,@a))
(defmacro cd0 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-cd0) ,@a))
(defun tag (&rest p) (cd0 make-identifier-datum '("tabularius") p))
(defun L (c &rest a) (format t "~&~A~%" (apply #'format nil c a)))
(defun nodes (f) (funcall (find-symbol "%HOST-NODES" '#:lisp-plus-surface1) f))
(defun octs (f)
  (handler-case (cd0 octets-length (cd0 canonical-octets (s1 encode-term f)))
    (error () -1)))

(defun outcome (form)
  "-> (values ACCOUNTED-P CODE)"
  (handler-case
      (multiple-value-bind (req rf) (s1 try-request-expansion form :macroexpand-1 (tag "b"))
        (if (null req)
            (values nil (s1 expansion-refusal-code rf))
            (multiple-value-bind (rc ex rf2) (s1 try-perform-expansion req)
              (declare (ignore ex))
              (if rc (values t nil) (values nil (s1 expansion-refusal-code rf2))))))
    (error (e) (values nil (type-of e)))))

;;; ---- the highest-blowup construct in the closed table -------------
;;; DEFINE-JUDGMENT-SCHEMA wraps EVERY premise p as
;;;   (lisp-plus-slice1:proposition-pattern 'p)
;;; so a one-atom premise costs little in the source and much in the expansion.
(defun schema-with-premises (n &optional (p :a))
  `(lisp-plus-surface0:define-judgment-schema cl-user::*tabb*
     :name :z :version 0
     :conclusion (:predicate :z (:v (:var :v)))
     :premises ,(make-list n :initial-element p)
     :locals () :unique-locals ()))

(L "=== BLOWUP MEASUREMENT: define-judgment-schema, N atom premises ===")
(dolist (n '(1 10 100 500 1000 2000))
  (let* ((src (schema-with-premises n))
         (exp (macroexpand-1 src nil)))
    (L "N=~5D  src-nodes ~6D  src-octets ~8D | exp-nodes ~6D  exp-octets ~9D  ratio ~,2F"
       n (nodes src) (octs src) (nodes exp) (octs exp)
       (/ (float (nodes exp)) (nodes src)))))

(L "~%=== WHAT THE PIPELINE SAYS AT EACH N ===")
(dolist (n '(100 300 500 700 900 1200 1500 2000 3000 5000))
  (multiple-value-bind (ok code) (outcome (schema-with-premises n))
    (L "N=~5D  accounted ~A  code ~S   (exp-nodes ~D)"
       n ok code (nodes (macroexpand-1 (schema-with-premises n) nil)))))

(L "~%=== N REQUIRED FOR expanded-nodes > 20000, AND WHAT FIRES THERE ===")
(let* ((per (- (nodes (macroexpand-1 (schema-with-premises 101) nil))
               (nodes (macroexpand-1 (schema-with-premises 100) nil))))
       (need (ceiling (- 20001 (nodes (macroexpand-1 (schema-with-premises 0) nil))) per)))
  (L "expansion nodes per premise ...... ~D" per)
  (L "N needed for >20000 expanded nodes ~D" need)
  (let ((src (schema-with-premises need)))
    (L "at that N: src-nodes ~D  src-octets ~D  exp-nodes ~D"
       (nodes src) (octs src) (nodes (macroexpand-1 src nil)))
    (multiple-value-bind (ok code) (outcome src)
      (L "pipeline verdict ................. accounted ~A  code ~S" ok code))))

;;; ---- also: the other constructs, for the record ------------------
(L "~%=== BLOWUP OF THE OTHER SCALABLE CONSTRUCTS ===")
(defun contract-with-clauses (n)
  `(lisp-plus-surface0:define-admission-contract cl-user::*tabb2*
     :contract-id :x :contract-version 0
     :accepted-clauses ,(loop repeat n collect (list :verified-judged-claim))
     :proposition-relation :exact-normalized-equality
     :receiver-accessibility :required
     :retain (:contract-snapshot)))
(defun slice2-with-attachments (n)
  `(lisp-plus-surface0:define-slice2-schema cl-user::*tabb3*
     :schema-id :x :schema-version 0 :base-schema cl-user::*base*
     :premise-contracts ,(loop for i from 1 to n collect (list i 'cl-user::*ctr*))))
(dolist (pair (list (cons "define-admission-contract" #'contract-with-clauses)
                    (cons "define-slice2-schema"      #'slice2-with-attachments)))
  (let* ((s1000 (funcall (cdr pair) 1000)) (s1001 (funcall (cdr pair) 1001)))
    (L "~28A  marginal src-nodes ~D  marginal exp-nodes ~D  ratio ~,2F"
       (car pair)
       (- (nodes s1001) (nodes s1000))
       (- (nodes (macroexpand-1 s1001 nil)) (nodes (macroexpand-1 s1000 nil)))
       (/ (float (- (nodes (macroexpand-1 s1001 nil)) (nodes (macroexpand-1 s1000 nil))))
          (- (nodes s1001) (nodes s1000))))))
