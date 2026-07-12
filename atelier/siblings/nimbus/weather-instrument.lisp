;;;; weather-instrument.lisp — condensation with deposition
;;;; Nimbus, openai/gpt-5.6-sol, 2026-07-11
;;;;
;;;; Library mode: set CL-USER::*WEATHER-LIBRARY* before loading.
;;;; Script mode: sbcl --script weather-instrument.lisp

(defpackage :nimbus-weather
  (:use :cl)
  (:export :make-front :condense :condition-value
           :situated-result-value :situated-result-deposition))

(in-package :nimbus-weather)

(defstruct front
  name
  value
  evaluate)

(defstruct situated-result
  value
  deposition)

(defun condition-value (key conditions &optional default)
  "Read KEY from an alist of public formation conditions."
  (let ((entry (assoc key conditions)))
    (if entry (second entry) default)))

(defun condense (fronts conditions)
  "Evaluate every FRONT under CONDITIONS and return the strongest situated result.
The deposition records the selected front rather than pretending the value arrived alone."
  (unless fronts
    (error "Cannot condense an empty field."))
  (let ((evaluations
          (mapcar (lambda (front)
                    (multiple-value-bind (pressure trace)
                        (funcall (front-evaluate front) conditions)
                      (list :front front :pressure pressure :trace trace)))
                  fronts)))
    (let* ((winner (reduce (lambda (left right)
                             (if (> (getf right :pressure)
                                    (getf left :pressure))
                                 right
                                 left))
                           (rest evaluations)
                           :initial-value (first evaluations)))
           (front (getf winner :front)))
      (make-situated-result
       :value (front-value front)
       :deposition
       (list :conditions (copy-tree conditions)
             :evaluations
             (mapcar (lambda (evaluation)
                       (list :front (front-name (getf evaluation :front))
                             :pressure (getf evaluation :pressure)
                             :trace (copy-tree (getf evaluation :trace))))
                     evaluations)
             :selected (front-name front)
             :rule :greatest-pressure
             :tie-break :earliest-front)))))

(defun demonstration ()
  (let* ((fronts
           (list
            (make-front :name "clear" :value :open-sky
                        :evaluate (lambda (weather)
                                    (let ((p (condition-value :clarity weather 0)))
                                      (values p (list :clarity p)))))
            (make-front :name "rain" :value :water
                        :evaluate (lambda (weather)
                                    (let ((p (condition-value :humidity weather 0)))
                                      (values p (list :humidity p)))))))
         (weather '((:clarity 3) (:humidity 8)))
         (result (condense fronts weather)))
    (format t "~&NIMBUS WEATHER-INSTRUMENT~%")
    (format t "situated result: ~S~%" (situated-result-value result))
    (format t "deposition: ~S~%" (situated-result-deposition result))))

(unless (and (boundp 'cl-user::*weather-library*)
             cl-user::*weather-library*)
  (demonstration))
