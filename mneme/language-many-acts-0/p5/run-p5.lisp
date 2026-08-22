;; P5 driver — mechanical translation of SOL'S environment declaration into the
;; documented constructor call (frozen protocol: the chair may not adjust the
;; declaration; an unbuildable declaration is a finding). Checks assert SOL'S OWN
;; PREDICTION, verbatim from its return, not the chair's expectations.
;; Sentinel: "ma0-p5-nonauthor: N checks, M failures".

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-p5-driver (:use #:cl))
(in-package #:ma0-p5-driver)

(defvar *passed* 0)
(defvar *failed* 0)
(defun check (label ok &optional (detail ""))
  (if ok (incf *passed*) (incf *failed*))
  (format t "  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") label
          (if (string= detail "") nil detail)))

(let* ((root (uiop:ensure-directory-pathname
              (format nil "~a/ma0-p5-~d/"
                      (or (uiop:getenv "TMPDIR") "/tmp") (random 1000000 (make-random-state t))))))
  (ensure-directories-exist root)
  (unwind-protect
       (let* ((program (lisp-plus-many-acts0:ma0-validate
                        (merge-pathnames
                         "mneme/language-many-acts-0/p5/p5-xenobiological-quarantine.lisp"
                         (uiop:getcwd))))
              (environment
                (lisp-plus-many-acts0:make-ma0-environment
                 :root root
                 ;; --- Sol's declaration, transcribed value-for-value ---
                 :arms '("A" "B-L1" "C-i" "D")
                 :grants '((:slot "accession-grant"     :arm "A")
                           (:slot "containment-grant"   :arm "B-L1")
                           (:slot "assay-grant"         :arm "C-i")
                           (:slot "sterilization-grant" :arm "D"))
                 :revocations '()
                 :seat-map '(("assay-seat" . "ambigua"))
                 :inputs '(("probe-name" . "pelagia-7"))))
              (result (lisp-plus-many-acts0:ma0-run-program program environment)))
         (check "validated through the public door"
                (lisp-plus-many-acts0:ma0-validated-program-p program))
         ;; --- Sol's prediction, asserted verbatim ---
         (check "PREDICTED disposition :refused"
                (eq :refused (lisp-plus-many-acts0:ma0-result-disposition result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-disposition result)))
         (check "PREDICTED refusal code :earth-entry-quarantined"
                (eq :earth-entry-quarantined
                    (lisp-plus-many-acts0:ma0-result-refusal-code result))
                (format nil "got ~s" (lisp-plus-many-acts0:ma0-result-refusal-code result)))
         (let ((detail (lisp-plus-many-acts0:ma0-result-refusal-detail result)))
           (check "PREDICTED detail: ((\"pelagia-7\" \"subglacial-ocean-sample\" :PENDING-CLEARANCE) :RECONCILED :RECONCILED)"
                  (equal detail '(("pelagia-7" "subglacial-ocean-sample" :pending-clearance)
                                  :reconciled :reconciled))
                  (format nil "got ~s" detail)))
         (let ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result)))
           (check "PREDICTED act-summary-count 3"
                  (= 3 (length summaries))
                  (format nil "got ~d" (length summaries)))
           (check "PREDICTED: no summary names arm D (sterilization warranted, unexecuted)"
                  (notany (lambda (s) (string= "D" (lisp-plus-many-acts0:ma0-act-summary-arm s)))
                          summaries))
           (when (= 3 (length summaries))
             (loop for s in summaries
                   for (earm edisp) in '(("A" :returned) ("B-L1" :refused) ("C-i" :interrupted))
                   do (check (format nil "PREDICTED summary ~a/~s" earm edisp)
                             (and (string= earm (lisp-plus-many-acts0:ma0-act-summary-arm s))
                                  (eq edisp (lisp-plus-many-acts0:ma0-act-summary-disposition s)))
                             (format nil "got ~a/~s"
                                     (lisp-plus-many-acts0:ma0-act-summary-arm s)
                                     (lisp-plus-many-acts0:ma0-act-summary-disposition s))))))
         (check "a store-id exists"
                (stringp (lisp-plus-many-acts0:ma0-result-store-id result))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))
  (format t "~%ma0-p5-nonauthor: ~d checks, ~d failures~%" (+ *passed* *failed*) *failed*)
  (uiop:quit (if (zerop *failed*) 0 1)))
