;;;; probe-C.lisp — exhibit :EXPANDED-NODES-EXCEEDED from the PUBLIC API, gate by gate.
(defparameter *s1dir*
  (pathname "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/"))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *s1dir*)))
(defpackage #:tabc (:use #:common-lisp)) (in-package #:tabc)
(defmacro s1 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-surface1) ,@a))
(defmacro cd0 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-cd0) ,@a))
(defun L (c &rest a) (format t "~&~A~%" (apply #'format nil c a)))
(defun nodes (f) (funcall (find-symbol "%HOST-NODES" '#:lisp-plus-surface1) f))
(defun depth (f) (funcall (find-symbol "%HOST-DEPTH" '#:lisp-plus-surface1) f))
(defun octs (f) (cd0 octets-length (cd0 canonical-octets (s1 encode-term f))))
(defun sch (n)
  `(lisp-plus-surface0:define-judgment-schema cl-user::*tabc*
     :name :z :version 0 :conclusion (:predicate :z (:v (:var :v)))
     :premises ,(make-list n :initial-element :a) :locals () :unique-locals ()))
(defun code-at (n)
  (multiple-value-bind (req rf)
      (s1 try-request-expansion (sch n) :macroexpand-1
          (cd0 make-identifier-datum '("tabularius") '("c")))
    (if (null req) (list :door1 (s1 expansion-refusal-code rf))
        (multiple-value-bind (rc ex rf2) (s1 try-perform-expansion req)
          (declare (ignore ex))
          (if rc (list :accounted nil) (list :door2 (s1 expansion-refusal-code rf2)))))))

(L "=== MINIMAL N REACHING :EXPANDED-NODES-EXCEEDED (bisection) ===")
(let ((lo 2000) (hi 3000) (best nil))
  (loop while (<= lo hi)
        do (let ((mid (floor (+ lo hi) 2)))
             (if (eq :expanded-nodes-exceeded (second (code-at mid)))
                 (progn (setf best mid) (setf hi (1- mid)))
                 (setf lo (1+ mid)))))
  (L "minimal N .......... ~D" best)
  (dolist (n (list (1- best) best))
    (let* ((src (sch n)) (exp (macroexpand-1 src nil)))
      (L "")
      (L "N=~D" n)
      (L "  SOURCE   depth ~D (ceiling 48) · nodes ~D (ceiling 20000) · octets ~D (ceiling 262144)"
         (depth src) (nodes src) (octs src))
      (L "  Door 1 .......... ~A"
         (if (s1 expansion-request-p
                 (nth-value 0 (s1 try-request-expansion src :macroexpand-1
                                  (cd0 make-identifier-datum '("tabularius") '("c")))))
             "ACCEPTED" "refused"))
      (L "  EXPANDED depth ~D · nodes ~D · octets ~D"
         (depth exp) (nodes exp) (octs exp))
      (L "  verdict ......... ~S" (code-at n))))
  (L "")
  (L "gensyms in the expansion? ~A"
     (let* ((f (macroexpand-1 (sch best) nil))
            (atoms (labels ((a (x) (if (consp x) (append (a (car x)) (a (cdr x))) (list x)))) (a f))))
       (length (remove-if #'symbol-package (remove-if-not #'symbolp atoms)))))
  (L "catalogue says this code is: ~S"
     (funcall (find-symbol "REFUSAL-CATALOG-ENTRY-REACHABILITY" '#:lisp-plus-surface1)
              (assoc :expanded-nodes-exceeded (s1 expansion-refusal-code-catalog)))))
