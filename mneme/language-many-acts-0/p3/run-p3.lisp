;; P3 holdout driver — fresh image, public exports only, authored post-freeze by the chair.
;; Runs p3-peregrinatio.lisp through the documented authoring surface (AUTHOR-GUIDE §8)
;; and witnesses the holdout's claims. Sentinel: "ma0-p3-holdout: N checks, M failures".
;; A red here is PRESERVED, never repaired by touching grammar or evaluator (freeze law).

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-p3-driver (:use #:cl))
(in-package #:ma0-p3-driver)

(defvar *passed* 0)
(defvar *failed* 0)
(defun check (label ok &optional (detail ""))
  (if ok (incf *passed*) (incf *failed*))
  (format t "  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") label
          (if (string= detail "") nil detail)))

;; Discover runtime seats through the EXPORTED fixture readers (the guide's seat-map
;; needs runtime seat names; the guide documents only arm A's — holdout finding F-GUIDE-1).
(defun seat-for-arm (arm)
  (lisp-plus-language-act0:act-fixture-runtime-seat
   (find arm lisp-plus-language-act0:*act-fixture-table*
         :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=)))

(let* ((root (uiop:ensure-directory-pathname
              (format nil "~a/ma0-p3-~d/"
                      (or (uiop:getenv "TMPDIR") "/tmp") (random 1000000 (make-random-state t))))))
  (ensure-directories-exist root)
  (unwind-protect
       (let* ((program (lisp-plus-many-acts0:ma0-validate
                        (merge-pathnames "mneme/language-many-acts-0/p3/p3-peregrinatio.lisp"
                                         (uiop:getcwd))))
              (environment
                (lisp-plus-many-acts0:make-ma0-environment
                 :root root
                 :arms '("A" "B-L2" "C-ii" "D")
                 :grants '((:slot "viaticum-road" :arm "A")
                           (:slot "viaticum-shortcut" :arm "B-L2")
                           (:slot "viaticum-cart" :arm "C-ii")
                           (:slot "viaticum-feast" :arm "D"))
                 :revocations '()
                 :seat-map (list (cons "s-luggage" (seat-for-arm "C-ii")))
                 :inputs '(("traveler" . "peregrinus-tertius"))))
              (result (lisp-plus-many-acts0:ma0-run-program program environment)))
         (check "validated through the public door"
                (lisp-plus-many-acts0:ma0-validated-program-p program))
         (check "disposition is :refused (no arrival declared)"
                (eq :refused (lisp-plus-many-acts0:ma0-result-disposition result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-disposition result)))
         (check "refusal code is :luggage-unsettled-no-arrival"
                (eq :luggage-unsettled-no-arrival
                    (lisp-plus-many-acts0:ma0-result-refusal-code result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-refusal-code result)))
         (check "the traveler's name crossed the whole program as ordinary data"
                (equal "peregrinus-tertius"
                       (lisp-plus-many-acts0:ma0-result-refusal-detail result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-refusal-detail result)))
         (let ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result)))
           (check "exactly THREE acts ran — the feast (arm D) did not"
                  (= 3 (length summaries))
                  (format nil "got ~d" (length summaries)))
           (check "no summary names arm D (the untaken downstream effect)"
                  (notany (lambda (s) (string= "D" (lisp-plus-many-acts0:ma0-act-summary-arm s)))
                          summaries))
           (when (= 3 (length summaries))
             (destructuring-bind (s1 s2 s3) summaries
               (check "leg 1: arm A returned"
                      (and (string= "A" (lisp-plus-many-acts0:ma0-act-summary-arm s1))
                           (eq :returned (lisp-plus-many-acts0:ma0-act-summary-disposition s1)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s1)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s1)))
               (check "leg 2: arm B-L2 refused — and the program CONTINUED past it"
                      (and (string= "B-L2" (lisp-plus-many-acts0:ma0-act-summary-arm s2))
                           (eq :refused (lisp-plus-many-acts0:ma0-act-summary-disposition s2)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s2)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s2)))
               (check "leg 3: arm C-ii interrupted (the uncertainty that stood)"
                      (and (string= "C-ii" (lisp-plus-many-acts0:ma0-act-summary-arm s3))
                           (eq :interrupted (lisp-plus-many-acts0:ma0-act-summary-disposition s3)))
                      (format nil "~a/~s" (lisp-plus-many-acts0:ma0-act-summary-arm s3)
                              (lisp-plus-many-acts0:ma0-act-summary-disposition s3)))
               (check "act-id-hex present on every leg (64 chars each)"
                      (every (lambda (s) (= 64 (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s))))
                             summaries)))))
         (check "a store-id exists (durable per-act history under One Act)"
                (stringp (lisp-plus-many-acts0:ma0-result-store-id result))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))
  (format t "~%ma0-p3-holdout: ~d checks, ~d failures~%" (+ *passed* *failed*) *failed*)
  (uiop:quit (if (zerop *failed*) 0 1)))
