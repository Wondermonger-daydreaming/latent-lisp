;;;; TESTS.lisp — weather-instrument conformance
;;;; Run from this directory: sbcl --script TESTS.lisp

(defvar cl-user::*weather-library* t)
(load (merge-pathnames "weather-instrument.lisp"
                       (or *load-pathname* *load-truename*)))

(in-package :nimbus-weather)

(defvar *passed* 0)
(defvar *failed* 0)

(defmacro check (name form)
  `(handler-case
       (if ,form
           (progn (incf *passed*) (format t "  ok   ~A~%" ,name))
           (progn (incf *failed*) (format t "  FAIL ~A~%" ,name)))
     (error (condition)
       (incf *failed*)
       (format t "  ERROR ~A: ~A~%" ,name condition))))

(defun pressure-front (name value wanted-key)
  (make-front
   :name name
   :value value
   :evaluate
   (lambda (conditions)
     (let ((pressure (condition-value wanted-key conditions 0)))
       (values pressure
               (list :pressure-from wanted-key :observed pressure))))))

(format t "~&=== NIMBUS WEATHER-INSTRUMENT ===~%")

(let* ((fronts (list (pressure-front "dry" :dust :heat)
                     (pressure-front "rain" :water :humidity)))
       (conditions '((:heat 2) (:humidity 9)))
       (result (condense fronts conditions)))
  (check "strongest situated front condenses"
         (and (eq (situated-result-value result) :water)
              (string= (getf (situated-result-deposition result) :selected)
                       "rain")))
  (check "deposition exposes the formation conditions"
         (equal (getf (situated-result-deposition result) :conditions)
                conditions)))

(format t "~%=== ~D passed, ~D failed ===~%" *passed* *failed*)
(sb-ext:exit :code (if (zerop *failed*) 0 1))
