;; P4 holdout driver — fresh image, public exports only, authored post-R1-freeze by the
;; chair. Runs p4-vindemia.lisp through the documented authoring surface (AUTHOR-GUIDE
;; §8). Sentinel: "ma0-p4-holdout: N checks, M failures". A red here is PRESERVED —
;; the frozen language implementation may not be altered (R1 ruling §8).

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-p4-driver (:use #:cl))
(in-package #:ma0-p4-driver)

(defvar *passed* 0)
(defvar *failed* 0)
(defun check (label ok &optional (detail ""))
  (if ok (incf *passed*) (incf *failed*))
  (format t "  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") label
          (if (string= detail "") nil detail)))

(defun seat-for-arm (arm)
  (lisp-plus-language-act0:act-fixture-runtime-seat
   (find arm lisp-plus-language-act0:*act-fixture-table*
         :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=)))

(let* ((root (uiop:ensure-directory-pathname
              (format nil "~a/ma0-p4-~d/"
                      (or (uiop:getenv "TMPDIR") "/tmp") (random 1000000 (make-random-state t))))))
  (ensure-directories-exist root)
  (unwind-protect
       (let* ((program (lisp-plus-many-acts0:ma0-validate
                        (merge-pathnames "mneme/language-many-acts-0/p4/p4-vindemia.lisp"
                                         (uiop:getcwd))))
              (environment
                (lisp-plus-many-acts0:make-ma0-environment
                 :root root
                 :arms '("A" "B-L1" "C-ii" "D")
                 :grants '((:slot "north-warrant" :arm "A")
                           (:slot "east-warrant" :arm "B-L1")
                           (:slot "south-warrant" :arm "C-ii")
                           (:slot "press-warrant" :arm "D"))
                 :revocations '()
                 :seat-map (list (cons "s-north" (seat-for-arm "A"))
                                 (cons "s-south" (seat-for-arm "C-ii")))
                 :inputs '(("vintner" . "vindemiator-quartus"))))
              (result (lisp-plus-many-acts0:ma0-run-program program environment)))
         (check "validated through the public door"
                (lisp-plus-many-acts0:ma0-validated-program-p program))
         (check "disposition is :refused (the vintage is withheld)"
                (eq :refused (lisp-plus-many-acts0:ma0-result-disposition result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-disposition result)))
         (check "refusal code is :vintage-withheld"
                (eq :vintage-withheld
                    (lisp-plus-many-acts0:ma0-result-refusal-code result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-refusal-code result)))
         (let ((detail (lisp-plus-many-acts0:ma0-result-refusal-detail result)))
           (check "the withholding notice carries the vintner AND the north plot's standing (ordinary value from an earlier act, composed as data)"
                  (and (listp detail)
                       (= 2 (length detail))
                       (equal "vindemiator-quartus" (first detail))
                       (eq :settled (second detail)))
                  (format nil "got ~s" detail)))
         (let ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result)))
           (check "exactly THREE plots were worked — the press (arm D) did not run"
                  (= 3 (length summaries))
                  (format nil "got ~d" (length summaries)))
           (check "no summary names arm D (the warranted, unexecuted continuation)"
                  (notany (lambda (s) (string= "D" (lisp-plus-many-acts0:ma0-act-summary-arm s)))
                          summaries))
           (when (= 3 (length summaries))
             (destructuring-bind (s1 s2 s3) summaries
               (check "plot-north: arm A returned"
                      (and (string= "A" (lisp-plus-many-acts0:ma0-act-summary-arm s1))
                           (eq :returned (lisp-plus-many-acts0:ma0-act-summary-disposition s1)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s1)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s1)))
               (check "plot-east: arm B-L1 refused — the frost is a fact, not a branch; the harvest continued"
                      (and (string= "B-L1" (lisp-plus-many-acts0:ma0-act-summary-arm s2))
                           (eq :refused (lisp-plus-many-acts0:ma0-act-summary-disposition s2)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s2)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s2)))
               (check "plot-south: arm C-ii interrupted (the receipt lost, the uncertainty adjudicated)"
                      (and (string= "C-ii" (lisp-plus-many-acts0:ma0-act-summary-arm s3))
                           (eq :interrupted (lisp-plus-many-acts0:ma0-act-summary-disposition s3)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s3)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s3)))
               (check "act-id-hex present on every plot (64 chars each)"
                      (every (lambda (s) (= 64 (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s))))
                             summaries)))))
         (check "a store-id exists (durable per-act history under One Act)"
                (stringp (lisp-plus-many-acts0:ma0-result-store-id result))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))
  (format t "~%ma0-p4-holdout: ~d checks, ~d failures~%" (+ *passed* *failed*) *failed*)
  (uiop:quit (if (zerop *failed*) 0 1)))
