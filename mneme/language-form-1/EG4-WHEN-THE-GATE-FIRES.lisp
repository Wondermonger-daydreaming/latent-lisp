(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))
(defpackage #:w (:use #:cl)) (in-package #:w)
(defun np (f) (lisp-plus-slice1:proposition f))
(defun pp (f) (lisp-plus-slice1:proposition-pattern f))
(lisp-plus-slice1:clear-schema-registry)
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :volume-reshelved :version 1
  :conclusion (pp '(:predicate :volume-reshelved (:volume (:var :volume))))
  :premises (list (pp '(:predicate :volume-scanned-at-desk (:volume (:var :volume)))))))
(defparameter *sch*
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :volume-reshelved/2
   :base-schema (lisp-plus-slice1:resolve-schema :volume-reshelved 1)
   :premise-contracts (list (list 0 (lisp-plus-slice2:make-support-admission-contract
                                     :contract-id :scan
                                     :accepted-clauses '((:asserted-witness :mode :direct
                                                          :kind :shelf-scan
                                                          :truth-ceiling :asserted)))))))
(defun w (v) (lisp-plus-slice0:witness :for (np `(:predicate :volume-scanned-at-desk (:volume ,v)))
                                       :mode :direct :kind :shelf-scan :source :clerk))
;; ---- the counter shim, exactly as NC-28 specifies ----
(defparameter *calls* 0)
(defparameter *real* (fdefinition 'lisp-plus-slice2:derive/2))
(setf (fdefinition 'lisp-plus-slice2:derive/2)
      (lambda (&rest args) (incf *calls*) (apply *real* args)))

(defun build (n)
  (let* ((d (lisp-plus-form1:petition-datum
             :schema (lisp-plus-form1:schema-reference "s")
             :conclusion (lisp-plus-form1:conclusion-reference "c")
             :supports (loop for i from 1 to n collect (lisp-plus-form1:support-reference (format nil "w~D" i)))
             :receiver (lisp-plus-form1:receiver-reference "r")))
         (v (lisp-plus-form1:validate-petition (lisp-plus-form1:propose-petition d))))
    (lisp-plus-form1:materialize-petition v (lisp-plus-cd0:make-identifier-datum '("w") '("occ")))))

(defun ctx-for (n witnesses)
  (let ((c (lisp-plus-form1:bind-conclusion-reference
            (lisp-plus-form1:bind-schema-reference
             (lisp-plus-form1:make-derivation-resolution-context)
             (lisp-plus-form1:schema-reference "s") *sch*)
            (lisp-plus-form1:conclusion-reference "c")
            (np '(:predicate :volume-reshelved (:volume "PLUT-7"))))))
    (loop for i from 1 to n
          do (setf c (lisp-plus-form1:bind-support-reference
                      c (lisp-plus-form1:support-reference (format nil "w~D" i))
                      (nth (1- i) witnesses))))
    (lisp-plus-form1:seal-resolution-context
     (lisp-plus-form1:bind-receiver-reference
      c (lisp-plus-form1:receiver-reference "r")
      (lisp-plus-slice0:receiver-context :context-id :desk
       :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))
     (lisp-plus-cd0:make-identifier-datum '("w") '("ctx")))))

(dolist (n '(1 9))
  (setf *calls* 0)
  (let* ((ws (cons (w "PLUT-7") (loop for i from 2 to n collect (w (format nil "X-~D" i)))))
         (pet (build n))
         (ctx (ctx-for n ws)))
    (multiple-value-bind (outcome refusal)
        (lisp-plus-form1:try-submit-petition pet ctx :by :clerk
          :by-id (lisp-plus-cd0:make-identifier-datum '("w") '("by"))
          :act-id (lisp-plus-cd0:make-identifier-datum '("w") '("act")))
      (format t "~&n=~D  derive/2 invocations=~D  outcome=~A  refusal=~S~%"
              n *calls*
              (if outcome (lisp-plus-form1:petition-submission-outcome-kind outcome) "NONE")
              (and refusal (lisp-plus-form1:petition-refusal-code refusal)))
      (when refusal
        (format t "    >>> the governed operation ran ~D time(s) and NO submission receipt exists~%" *calls*)))))
