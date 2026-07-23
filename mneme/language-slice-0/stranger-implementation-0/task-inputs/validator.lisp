;;;; validator.lisp — a local, schema-dependent dataset validator.
;;;;
;;;; This file is ORDINARY Common Lisp. It is NOT part of Lisp+. It gives
;;;; your program a real local capability: a validator built over a
;;;; schema held in local state (a lexical closure). The schema lives
;;;; only in this image; there is no serialized form of it.
;;;;
;;;; Load it with (load "task-inputs/validator.lisp") after you have
;;;; loaded the Lisp+ Slice /0 surface. It defines package :DATASET-LAB
;;;; and exports three ordinary functions. Use them as plain CL.
;;;;
;;;; The three functions:
;;;;
;;;;   (dataset-lab:read-dataset PATH) => the dataset plist (uses `read`)
;;;;
;;;;   (dataset-lab:make-row-validator) => a CLOSURE of one argument.
;;;;       Call it on one row plist; it returns either
;;;;         (:ok   ROW)                         if the row satisfies the schema
;;;;         (:bad  ROW (:field F :reason R) ..) otherwise.
;;;;       The schema (field names, types, bounds) is captured in the
;;;;       closure's lexical environment — it is NOT reachable as data.
;;;;
;;;;   (dataset-lab:summarize ROWS) => a canonical summary plist, e.g.
;;;;       (:n 8 :specimens 4 :mass-mg (:min .. :max .. :mean-x100 ..)
;;;;        :temp-c (:min .. :max ..)).
;;;;       Pure data in, pure data out; safe to treat as a canonical datum.

(defpackage :dataset-lab
  (:use :cl)
  (:export #:read-dataset #:make-row-validator #:summarize))

(in-package :dataset-lab)

(defun read-dataset (path)
  "Read the whole dataset file as one s-expression."
  (with-open-file (s path :direction :input)
    (read s)))

(defun make-row-validator ()
  "Return a one-argument closure that validates a row against a schema
held in local lexical state. The schema is not extractable as data."
  (let* ((required '(:specimen-id :mass-mg :temp-c :replicate))
         (mass-bounds '(50 . 1000))     ; inclusive mg bounds
         (temp-bounds '(-40 . 125))     ; inclusive C bounds
         (replicate-max 3))
    (lambda (row)
      (let ((problems '()))
        (dolist (f required)
          (unless (member f row)
            (push (list :field f :reason :missing) problems)))
        (let ((mass (getf row :mass-mg)))
          (when (integerp mass)
            (unless (<= (car mass-bounds) mass (cdr mass-bounds))
              (push (list :field :mass-mg :reason :out-of-bounds) problems))))
        (let ((temp (getf row :temp-c)))
          (when (integerp temp)
            (unless (<= (car temp-bounds) temp (cdr temp-bounds))
              (push (list :field :temp-c :reason :out-of-bounds) problems))))
        (let ((rep (getf row :replicate)))
          (when (integerp rep)
            (unless (<= 1 rep replicate-max)
              (push (list :field :replicate :reason :out-of-bounds) problems))))
        (dolist (f '(:mass-mg :temp-c :replicate))
          (let ((val (getf row f)))
            (when (and (member f row) (not (integerp val)))
              (push (list :field f :reason :not-integer) problems))))
        (if problems
            (list* :bad row (nreverse problems))
            (list :ok row))))))

(defun summarize (rows)
  "Canonical summary of a list of row plists. Pure data."
  (let* ((n (length rows))
         (ids (remove-duplicates (mapcar (lambda (r) (getf r :specimen-id)) rows)
                                 :test #'equal))
         (masses (mapcar (lambda (r) (getf r :mass-mg)) rows))
         (temps (mapcar (lambda (r) (getf r :temp-c)) rows)))
    (list :n n
          :specimens (length ids)
          :mass-mg (list :min (reduce #'min masses)
                         :max (reduce #'max masses)
                         :mean-x100 (round (* 100 (/ (reduce #'+ masses) n))))
          :temp-c (list :min (reduce #'min temps)
                        :max (reduce #'max temps)))))
