;;;; Thin experiment subprocess over the frozen Language-A validator.
;;;; It reports the first condition exactly as signaled and never reorders checks.

(defparameter *driver-directory* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *validator-path* (merge-pathnames "../../../mneme/language-a/validator.lisp" *driver-directory*))
(defparameter *fixtures-path* (merge-pathnames "../../../mneme/language-a/fixtures.lisp" *driver-directory*))
(load *validator-path*)
(in-package #:mneme.language-a)

(defun load-fixture-definitions ()
  (with-open-file (in cl-user::*fixtures-path* :direction :input)
    (loop for form = (read in nil :eof)
          until (eq form :eof)
          do (when (and (consp form)
                        (or (eq (first form) 'defstruct)
                            (and (eq (first form) 'defparameter)
                                 (member (second form) '(*lawful* *malformed*)))))
               (eval form)))))

(defun emit-result (name kind expected record)
  (handler-case
      (let ((result (validate-judgment record)))
        (format t "DRIVER|~a|~a|~a|~a|~a|~a~%"
                name kind expected result "-" "-"))
    (validation-error (condition)
      (format t "DRIVER|~a|~a|~a|~a|~a|~s~%"
              name kind expected (type-of condition)
              (violated-check condition) (offending condition)))))

(defun run-fixtures ()
  (load-fixture-definitions)
  (dolist (fixture (append *lawful* *malformed*))
    (emit-result (fixture-name fixture) (fixture-kind fixture)
                 (fixture-expect fixture) (fixture-record fixture))))

(defun run-record-file (path)
  (with-open-file (in path :direction :input)
    (loop for form = (read in nil :eof)
          until (eq form :eof)
          do (destructuring-bind (name expected record) form
               (emit-result name :synthetic-mutant expected record)))))

(let* ((argv sb-ext:*posix-argv*)
       (records-position (position "--records" argv :test #'string=)))
  (if records-position
      (run-record-file (nth (1+ records-position) argv))
      (run-fixtures)))
