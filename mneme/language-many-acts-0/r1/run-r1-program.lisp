;;;; run-r1-program.lisp — ONE R1 traversal program, ONE image, ONE store.
;;;;
;;;;   sbcl --script r1/run-r1-program.lisp <program-basename> <arm>
;;;;
;;;; The runner law is ONE PROGRAM PER IMAGE (contract §5), and after the R1/D4
;;;; repair it is enforced rather than merely written down: a second
;;;; environment in this image would take the run-state specials and the first
;;;; would be refused as stale.  So this script builds exactly one.
;;;;
;;;; PUBLIC EXPORTS ONLY.  It emits, for each act the program actually ran:
;;;;
;;;;   MA0 summary <n> arm="<ARM>" class=<K> disposition=<K> hexlen=<N>
;;;;   MA0 COVER <ARM>
;;;;
;;;; and closes with `r1-traversal <name>: <n> checks, <m> failures'.  The COVER
;;;; lines are what `ma0-coverage.sh' unions — an arm is covered because a
;;;; summary for it came back from a real run, never because a table says so.
;;;;
;;;; CANDIDATE.  Running a candidate is not adopting it, and nothing printed
;;;; here is independent verification (AP0 Rider 2).

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (defparameter cl-user::*r1-here* here)
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-r1-run (:use #:cl))
(in-package #:ma0-r1-run)

(defparameter *name*
  (or (second sb-ext:*posix-argv*)
      (progn (format *error-output* "~&!! no program basename given~%")
             (sb-ext:exit :code 2))))

(defparameter *arm*
  (or (third sb-ext:*posix-argv*)
      (progn (format *error-output* "~&!! no arm given~%")
             (sb-ext:exit :code 2))))

(defvar *passed* 0)
(defvar *failed* 0)

(defun check (label ok &optional (detail ""))
  (if ok (incf *passed*) (incf *failed*))
  (format t "  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") label
          (if (string= detail "") nil detail))
  (force-output))

(defun say (fmt &rest args)
  (format t "MA0 ~a~%" (apply #'format nil fmt args))
  (force-output))

(let ((root (uiop:ensure-directory-pathname
             (format nil "~a/ma0-r1-~a-~d/" (or (uiop:getenv "TMPDIR") "/tmp")
                     *arm* (random 1000000 (make-random-state t))))))
  (ensure-directories-exist root)
  (unwind-protect
       (let* ((source (merge-pathnames (format nil "programs/~a.lisp" *name*)
                                       cl-user::*r1-here*))
              (program (lisp-plus-many-acts0:ma0-validate source))
              (environment
                (lisp-plus-many-acts0:make-ma0-environment
                 :root root
                 :arms (list *arm*)
                 :grants (list (list :slot "warrant" :arm *arm*))
                 :revocations '()
                 :seat-map '()
                 :inputs '(("subject" . "r1-coverage"))))
              (result (lisp-plus-many-acts0:ma0-run-program program environment)))

         (check "validated through the public door"
                (lisp-plus-many-acts0:ma0-validated-program-p program))
         (check "the program named itself"
                (equal *name* (lisp-plus-many-acts0:ma0-program-name program))
                (format nil "~s" (lisp-plus-many-acts0:ma0-program-name program)))

         (say "program-name=~s" (lisp-plus-many-acts0:ma0-result-program-name result))
         (say "disposition=~s" (lisp-plus-many-acts0:ma0-result-disposition result))
         (say "refusal-code=~s" (lisp-plus-many-acts0:ma0-result-refusal-code result))
         (say "refusal-detail=~s"
              (lisp-plus-many-acts0:ma0-result-refusal-detail result))

         (let ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result)))
           (say "summary-count=~d" (length summaries))
           (loop for s in summaries
                 for i from 0
                 do (say "summary ~d arm=~s class=~s disposition=~s hexlen=~d"
                         i
                         (lisp-plus-many-acts0:ma0-act-summary-arm s)
                         (lisp-plus-many-acts0:ma0-act-summary-class s)
                         (lisp-plus-many-acts0:ma0-act-summary-disposition s)
                         (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s)))
                    (say "COVER ~a" (lisp-plus-many-acts0:ma0-act-summary-arm s)))

           (check "exactly ONE act ran" (= 1 (length summaries))
                  (format nil "got ~d" (length summaries)))
           (when (= 1 (length summaries))
             (let ((s (first summaries)))
               (check "the act that ran is the arm this traversal exists for"
                      (equal *arm* (lisp-plus-many-acts0:ma0-act-summary-arm s))
                      (format nil "wanted ~s, got ~s" *arm*
                              (lisp-plus-many-acts0:ma0-act-summary-arm s)))
               (check "a One Act identity came back (64-char digest segment)"
                      (= 64 (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s)))
                      (format nil "hexlen=~d"
                              (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s))))))

           ;; The shape the program itself declared it anticipated.  A run that
           ;; lands in a fall-through clause is REPORTED as such rather than
           ;; counted green: `shape-not-anticipated' means the fixture's belief
           ;; about the arm was wrong, and that is a finding, not a pass.
           (check "the program did not fall through to its unanticipated-shape clause"
                  (not (eq :completed
                           (lisp-plus-many-acts0:ma0-result-disposition result)))
                  (format nil "disposition=~s value=~s"
                          (lisp-plus-many-acts0:ma0-result-disposition result)
                          (lisp-plus-many-acts0:ma0-result-value result)))
           (check "the subject crossed the program as ordinary data"
                  (equal "r1-coverage"
                         (lisp-plus-many-acts0:ma0-result-refusal-detail result))
                  (format nil "~s"
                          (lisp-plus-many-acts0:ma0-result-refusal-detail result)))
           (check "a store-id came back"
                  (stringp (lisp-plus-many-acts0:ma0-result-store-id result)))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))

  (format t "~%r1-traversal ~a: ~d checks, ~d failures~%"
          *name* (+ *passed* *failed*) *failed*)
  (uiop:quit (if (zerop *failed*) 0 1)))
