(load "mneme/lci0/common-lisp/load.lisp")

(defun run-perturbed-vectors ()
  (multiple-value-bind (ok passed total failures)
      (lisp-plus-lci0:run-all-vectors
       (or (sb-ext:posix-getenv "LCI0_FIXTURE_ROOT")
           "/tmp/lci0-seed-fixtures-20260714")
       :verbose nil :verify-documents nil)
    (declare (ignore failures))
    (format t "LCI0 PERTURBATION ~A: ~D/~D exact~%"
            (or (sb-ext:posix-getenv "LCI0_PERTURBATION") "baseline")
            passed total)
    (unless ok (sb-ext:exit :code 1))))

(let ((profile (or (sb-ext:posix-getenv "LCI0_PERTURBATION") "baseline")))
  (cond
    ((string= profile "package")
     (let ((package (make-package
                     (symbol-name (gensym "LCI0-FOREIGN-PACKAGE-")) :use '(#:cl))))
       (unwind-protect
            (let ((*package* package)) (run-perturbed-vectors))
         (delete-package package))))
    ((string= profile "printer")
     (let ((*print-base* 16) (*print-radix* t) (*print-case* :downcase)
           (*print-pretty* t) (*print-level* 2) (*print-length* 3)
           (*print-readably* nil))
       (run-perturbed-vectors)))
    ((string= profile "readtable")
     (let ((*readtable* (copy-readtable nil)))
       (set-macro-character #\! (lambda (stream character)
                                  (declare (ignore stream character)) :poison))
       (run-perturbed-vectors)))
    ((string= profile "hash-insertion")
     (let ((table (make-hash-table :test #'equal)))
       (dolist (key '("z" "a" "m" "b" "y")) (setf (gethash key table) key))
       (run-perturbed-vectors)))
    (t (run-perturbed-vectors))))
