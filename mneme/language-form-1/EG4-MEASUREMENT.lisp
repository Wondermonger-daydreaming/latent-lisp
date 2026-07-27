(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))
(defpackage #:m (:use #:cl)) (in-package #:m)
(defun measure (n label)
  (let* ((d (lisp-plus-form1:petition-datum
             :schema (lisp-plus-form1:schema-reference "s")
             :conclusion (lisp-plus-form1:conclusion-reference "c")
             :supports (loop for i from 1 to n
                             collect (lisp-plus-form1:support-reference (format nil "w~D" i)))
             :receiver (lisp-plus-form1:receiver-reference "r")))
         (p (lisp-plus-form1:propose-petition d))
         (v (lisp-plus-form1:validate-petition p)))
    (multiple-value-bind (pet mr) (lisp-plus-form1:materialize-petition
                                   v (lisp-plus-cd0:make-identifier-datum '("m") '("occ")))
      (declare (ignore mr))
      ;; simulate the submission-occurrence and receipt identity lengths exactly
      (let* ((occ (lisp-plus-form1::%hex
                   (lisp-plus-form1::%group
                    (list (lisp-plus-form1::%phase-tag "submission-occurrence")
                          (lisp-plus-form1::%text (lisp-plus-form1:derivation-petition-occurrence-identity pet))
                          (lisp-plus-cd0:make-identifier-datum '("m") '("ctx"))
                          (lisp-plus-cd0:make-identifier-datum '("m") '("act"))
                          (lisp-plus-cd0:make-identifier-datum '("m") '("by"))
                          (lisp-plus-form1:petition-submission-procedure-identity)
                          (lisp-plus-form1::%count 1)))))
             (rec (lisp-plus-form1::%hex
                   (lisp-plus-form1::%group
                    (list (lisp-plus-form1::%phase-tag "submission-receipt")
                          (lisp-plus-form1::%text occ)
                          (lisp-plus-form1::%text "GRANTED")
                          (lisp-plus-form1::%text "receipt:slice2-receipt-1")
                          (lisp-plus-form1::%absent))))))
        (format t "~&~A (~D supports)~%  subject ~D | proposed ~D | validated ~D | content ~D | pet-occ ~D | sub-occ ~D | RECEIPT ~D~%"
                label n
                (length (lisp-plus-form1:proposed-petition-form-subject-identity p))
                (length (lisp-plus-form1:proposed-petition-form-identity p))
                (length (lisp-plus-form1:validated-petition-form-identity v))
                (length (lisp-plus-form1:derivation-petition-content-identity pet))
                (length (lisp-plus-form1:derivation-petition-occurrence-identity pet))
                (length occ) (length rec))
        (format t "  TERMINAL ~D vs ceiling ~D -> ~A~%"
                (length rec) (lisp-plus-form1:petition-policy-max-identity-characters)
                (if (> (length rec) (lisp-plus-form1:petition-policy-max-identity-characters))
                    "EXCEEDED" "within"))))))
(measure 7 "n=7")(measure 8 "n=8")(measure 9 "n=9")(measure 0 "smallest lawful")
(measure 1 "inhabited candidate D")
(measure 16 "maximum policy")
