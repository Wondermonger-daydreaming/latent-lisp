;;;; REVIEW-1-NC31-AFTER.lisp — the AFTER-REPAIR companion.
;;;;
;;;; Run: sbcl --non-interactive --load REVIEW-1-NC31-AFTER.lisp
;;;;
;;;; The SAME fixture as REVIEW-1-NC31-BEFORE.lisp, run against the repaired
;;;; layer, printing the same comparison so the two captures read side by side.
;;;;
;;;; It runs BOTH halves of the split control, because the point of the split is
;;;; that they are different facts and neither may stand in for the other:
;;;;
;;;;   NC-31A  same tag, DIFFERENT declarations  -> everything must separate.
;;;;           This is the v2 defect, and it is REPAIRED.
;;;;
;;;;   NC-31B  same tag, SAME declaration, different anchor -> the declared
;;;;           identities must stay EQUAL.  This is the RESIDUAL, and it stays.
;;;;
;;;; Identities print as COMPLETE hexadecimal.  Hex is DIAGNOSTIC ONLY and is
;;;; never embedded into an identity; it is used here because this file exists
;;;; to be read by a human comparing byte-strings.

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:review-1-nc31-after
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:review-1-nc31-after)

(defun idd (namespace path) (cd0:make-identifier-datum namespace path))
(defun np (form) (s1:proposition form))
(defun pp (form) (s1:proposition-pattern form))

(defun install-schema ()
  (s1:clear-schema-registry)
  (s1:register-schema
   (s1:judgment-schema
    :name :volume-reshelved :version 1
    :conclusion (pp '(:predicate :volume-reshelved (:volume (:var :volume))))
    :premises (list (pp '(:predicate :volume-scanned-at-desk (:volume (:var :volume))))))))

(defun wrapper ()
  (s2:make-slice2-schema
   :schema-id :volume-reshelved/2
   :base-schema (s1:resolve-schema :volume-reshelved 1)
   :premise-contracts
   (list (list 0 (s2:make-support-admission-contract
                  :contract-id :scan-by-direct-survey
                  :accepted-clauses '((:asserted-witness :mode :direct :kind :shelf-scan
                                       :truth-ceiling :asserted)))))))

(defun scan-witness (volume)
  (s0:witness :for (np `(:predicate :volume-scanned-at-desk (:volume ,volume)))
              :mode :direct :kind :shelf-scan :source :desk-clerk))

(defun desk (witnesses)
  (s0:receiver-context :context-id :reshelving-desk
                       :accessible-supports (mapcar #'s0:witness-id witnesses)))

(defun petition-tree ()
  (f1:petition-datum :schema (f1:schema-reference "s")
                     :conclusion (f1:conclusion-reference "c")
                     :supports (list (f1:support-reference "w1"))
                     :receiver (f1:receiver-reference "r")))

(defun build (tag)
  (f1:materialize-petition
   (f1:validate-petition (f1:propose-petition (petition-tree)))
   (idd '("form1-selftest") (list "occ" tag))))

(defun full-context (witnesses schema tag support-declaration)
  "The EXACT structure the before-witness built, plus the one thing v3 adds: a
denotation declaration on every binding.  SUPPORT-DECLARATION is the parameter
the split turns on."
  (let ((context (f1:make-derivation-resolution-context)))
    (setf context (f1:bind-schema-reference context (f1:schema-reference "s") schema
                                            (idd '("review-1" "denotation") '("schema" "s"))))
    (setf context (f1:bind-conclusion-reference
                   context (f1:conclusion-reference "c")
                   (np '(:predicate :volume-reshelved (:volume "PLUT-7")))
                   (idd '("review-1" "denotation") '("conclusion" "c"))))
    (setf context (f1:bind-support-reference context (f1:support-reference "w1")
                                             (first witnesses) support-declaration))
    (setf context (f1:bind-receiver-reference context (f1:receiver-reference "r")
                                              (desk witnesses)
                                              (idd '("review-1" "denotation") '("receiver" "r"))))
    (f1:seal-resolution-context context (idd '("form1-selftest") (list "ctx" tag)))))

(defun rule (title)
  (format t "~%~%~A~%~A~%" title (make-string (length title) :initial-element #\=)))

(defun sub (title) (format t "~%── ~A~%" title))

(defun show-identity (label identity)
  (if identity
      (format t "  ~A~%    octets : ~D~%    value  : ~A~%"
              label (f1:identity-octets identity) (f1:render-identity-hex identity))
      (format t "  ~A~%    (absent)~%" label)))

(defun same-p (left right)
  (if (cd0:equal-datum left right) "IDENTICAL" "DIFFERENT"))

(defun run-arm (title support-declaration-a support-declaration-b commentary)
  (let* ((petition (build "nc31"))
         (good  (list (scan-witness "PLUT-7")))
         (wrong (list (scan-witness "WRONG-31")))
         (schema (wrapper))
         (context-a (full-context good  schema "nc31-shared" support-declaration-a))
         (context-b (full-context wrong schema "nc31-shared" support-declaration-b))
         (by-id  (idd '("form1-selftest") '("by" "clerk")))
         (act-id (idd '("form1-selftest") '("act" "1")))
         (outcome-a (f1:submit-petition petition context-a
                                        :by :desk-clerk :by-id by-id :act-id act-id))
         (outcome-b (f1:submit-petition petition context-b
                                        :by :desk-clerk :by-id by-id :act-id act-id))
         (receipt-a (f1:petition-submission-outcome-receipt outcome-a))
         (receipt-b (f1:petition-submission-outcome-receipt outcome-b)))
    (rule title)
    (sub "held fixed on purpose")
    (format t "  context occurrence TAGS                : ~A~%"
            (same-p (f1:derivation-resolution-context-occurrence-tag context-a)
                    (f1:derivation-resolution-context-occurrence-tag context-b)))
    (format t "  petition occurrence identities         : ~A~%"
            (same-p (f1:derivation-petition-occurrence-identity petition)
                    (f1:derivation-petition-occurrence-identity petition)))
    (format t "  submission act ids · :BY-ID · live :BY : IDENTICAL~%")
    (sub "varied on purpose")
    (format t "  live support anchors (EQ)              : DIFFERENT (~A vs ~A)~%"
            (lisp-plus-kernel0:durable-identity-name (s0:witness-id (first good)))
            (lisp-plus-kernel0:durable-identity-name (s0:witness-id (first wrong))))
    (format t "  live receiver anchors (EQ)             : DIFFERENT~%")
    (format t "  support DENOTATION DECLARATIONS        : ~A~%"
            (same-p support-declaration-a support-declaration-b))
    (sub "what the layer now records")
    (format t "  context DECLARATION identities         : ~A~%"
            (same-p (f1:derivation-resolution-context-declaration-identity context-a)
                    (f1:derivation-resolution-context-declaration-identity context-b)))
    (format t "  context OCCURRENCE identities          : ~A~%"
            (same-p (f1:derivation-resolution-context-occurrence-identity context-a)
                    (f1:derivation-resolution-context-occurrence-identity context-b)))
    (format t "  SUBMISSION OCCURRENCE identities       : ~A~%"
            (same-p (f1:petition-submission-receipt-occurrence-identity receipt-a)
                    (f1:petition-submission-receipt-occurrence-identity receipt-b)))
    (format t "  SUBMISSION RECEIPT identities          : ~A~%"
            (same-p (f1:petition-submission-receipt-identity receipt-a)
                    (f1:petition-submission-receipt-identity receipt-b)))
    (format t "  GOVERNED OUTCOMES                      : ~S vs ~S  (~A)~%"
            (f1:petition-submission-outcome-kind outcome-a)
            (f1:petition-submission-outcome-kind outcome-b)
            (if (eq (f1:petition-submission-outcome-kind outcome-a)
                    (f1:petition-submission-outcome-kind outcome-b))
                "SAME" "OPPOSITE"))
    (sub "the complete identities")
    (show-identity "context DECLARATION identity — A"
                   (f1:derivation-resolution-context-declaration-identity context-a))
    (show-identity "context DECLARATION identity — B"
                   (f1:derivation-resolution-context-declaration-identity context-b))
    (show-identity "SUBMISSION OCCURRENCE identity — A"
                   (f1:petition-submission-receipt-occurrence-identity receipt-a))
    (show-identity "SUBMISSION OCCURRENCE identity — B"
                   (f1:petition-submission-receipt-occurrence-identity receipt-b))
    (sub "reading")
    (dolist (line commentary) (format t "  ~A~%" line))))

(format t "~%~%")
(format t "================================================================~%")
(format t "  LANGUAGE FORM /1 — REVIEW 1 — THE AFTER-REPAIR COMPANION~%")
(format t "  NC-31A and NC-31B, the same fixture, split~%")
(format t "================================================================~%")
(format t "~%  SBCL     : ~A~%" (lisp-implementation-version))
(format t "  policy   : ~A v~D~%"
        (cd0:render-diagnostic (f1:petition-policy-identity)) (f1:petition-policy-version))
(format t "  grammar  : v~D  (UNCHANGED — the petition datum grammar did not move)~%"
        (f1:petition-grammar-version))

(install-schema)

(run-arm "NC-31A — SAME TAG, DIFFERENT DECLARATIONS  (the repair)"
         (idd '("review-1" "denotation") '("support" "the-scan-of-PLUT-7"))
         (idd '("review-1" "denotation") '("support" "the-scan-of-WRONG-31"))
         (list "Everything separated.  Under policy v2 this same fixture produced"
               "IDENTICAL 838-octet submission occurrence identities with opposite"
               "outcomes — see REVIEW-1-NC31-BEFORE-RUN.txt §6, captured before one"
               "character of this repair existed."
               ""
               "The submission occurrence identity now commits to the context"
               "OCCURRENCE identity, which commits to the context DECLARATION"
               "identity, which commits to every binding's role, exact reference and"
               "exact denotation declaration.  The commitment propagates by the same"
               "transitivity that used to carry the gap."))

(run-arm "NC-31B — SAME TAG, SAME DECLARATION, DIFFERENT ANCHOR  (the residual)"
         (idd '("review-1" "denotation") '("support" "the-clearance"))
         (idd '("review-1" "denotation") '("support" "the-clearance"))
         (list "NOTHING separated, and nothing should have.  The host declared the"
               "same thing about two different objects.  At most one of those"
               "assertions is true and Form /1 cannot tell which, because a"
               "declaration is not certification of its anchor."
               ""
               "CLASSIFICATION, exactly:"
               "  trusted-host false declaration or identifier reuse;"
               "  not detected by Form /1;"
               "  not claimed to be detected;"
               "  no cross-image certification earned."
               ""
               "THE EXISTENCE OF THIS ARM DOES NOT EXCUSE NC-31A.  A was a defect of"
               "this layer — the declared content of a context was never recorded at"
               "all — and it is repaired.  B is a boundary of what any in-image"
               "record can do.  Calling both `an undetected host error' was one"
               "sentence covering a repair that had not happened and a limit that"
               "cannot be lifted."))

(format t "~%~%== REVIEW-1-NC31-AFTER: record complete, nothing asserted ==~%")
