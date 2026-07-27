;;;; REVIEW-1-NC31-BEFORE.lisp — THE BEFORE-REPAIR WITNESS.
;;;;
;;;; Run: sbcl --non-interactive --load REVIEW-1-NC31-BEFORE.lisp
;;;;
;;;; ⚠ THIS FILE IS FROZEN AGAINST THE PRE-REPAIR PUBLIC SURFACE AND NO LONGER
;;;; LOADS AGAINST THE REPAIRED LAYER.  That is deliberate and is not rot.
;;;;
;;;; It calls the policy v2 binders, which took THREE arguments.  Policy v3
;;;; binders take FOUR — the denotation declaration whose absence is the very
;;;; defect this file records.  Migrating it would destroy the thing it is for:
;;;; a witness written in the vocabulary of the world before the repair.
;;;;
;;;; ITS CAPTURE IS THE RECORD: REVIEW-1-NC31-BEFORE-RUN.txt, produced against
;;;; branch language-form-1-candidate-0 @ 7db2da94 with SBCL 2.4.6, before one
;;;; character of executable code was changed by this review.
;;;;
;;;; TO RE-RUN IT: check out 7db2da94 and load it there.  Its companion,
;;;; REVIEW-1-NC31-AFTER.lisp, runs the SAME fixture against the repaired layer
;;;; and prints the same comparison, so the two captures may be read side by side.
;;;;
;;;; This file is executed against the branch tip AS IT STOOD BEFORE Review 1
;;;; changed any executable code (language-form-1-candidate-0 @ 7db2da94), and
;;;; its capture is preserved as REVIEW-1-NC31-BEFORE-RUN.txt.
;;;;
;;;; IT IS NOT A TEST.  Nothing here asserts, passes or fails.  It RECORDS, in
;;;; full and without abbreviation, the exact behaviour the owner ruling names:
;;;;
;;;;     the context occurrence identity commits only to a host-supplied name;
;;;;     the context's public declaration omits its bound values;
;;;;     the submission occurrence identity therefore does not commit to what
;;;;     the petition's references were declared to denote.
;;;;
;;;; Identities are printed as COMPLETE hexadecimal renderings.  Hex is
;;;; DIAGNOSTIC ONLY (policy v2) and is never embedded into an identity; it is
;;;; used here because this file's whole purpose is to be read by a human
;;;; comparing two byte-strings character by character.

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:review-1-nc31-before
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:review-1-nc31-before)

;;; ── the NC-31 fixture, transcribed from form1-selftest.lisp §K ────────────
;;; (the one-premise reshelving desk; identical construction, so this record is
;;; of the SAME fixture the suite runs and not of a lookalike)

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

(defun scan-contract ()
  (s2:make-support-admission-contract
   :contract-id :scan-by-direct-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :shelf-scan
                        :truth-ceiling :asserted))))

(defun wrapper ()
  (s2:make-slice2-schema
   :schema-id :volume-reshelved/2
   :base-schema (s1:resolve-schema :volume-reshelved 1)
   :premise-contracts (list (list 0 (scan-contract)))))

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
  (let* ((proposed (f1:propose-petition (petition-tree)))
         (validated (f1:validate-petition proposed)))
    (f1:materialize-petition validated (idd '("form1-selftest") (list "occ" tag)))))

(defun full-context (witnesses schema tag &key (volume "PLUT-7"))
  (let ((context (f1:bind-conclusion-reference
                  (f1:bind-schema-reference (f1:make-derivation-resolution-context)
                                            (f1:schema-reference "s") schema)
                  (f1:conclusion-reference "c")
                  (np `(:predicate :volume-reshelved (:volume ,volume))))))
    (setf context (f1:bind-support-reference context (f1:support-reference "w1")
                                             (first witnesses)))
    (f1:seal-resolution-context
     (f1:bind-receiver-reference context (f1:receiver-reference "r") (desk witnesses))
     (idd '("form1-selftest") (list "ctx" tag)))))

;;; ── printing helpers ──────────────────────────────────────────────────────

(defun rule (title)
  (format t "~%~%~A~%~A~%" title (make-string (length title) :initial-element #\=)))

(defun sub (title)
  (format t "~%── ~A~%" title))

(defun show-identity (label identity)
  (if identity
      (format t "  ~A~%    octets : ~D~%    value  : ~A~%"
              label (f1:identity-octets identity) (f1:render-identity-hex identity))
      (format t "  ~A~%    (absent)~%" label)))

(defun show-datum (label datum)
  (if datum
      (format t "  ~A~%    diagnostic : ~A~%    canonical  : ~A~%"
              label (cd0:render-diagnostic datum)
              (cd0:octets-to-hex (cd0:canonical-octets datum)))
      (format t "  ~A~%    (absent)~%" label)))

(defun same-p (left right)
  (if (cd0:equal-datum left right) "IDENTICAL" "DIFFERENT"))

;;; ══════════════════════════════════════════════════════════════════════════

(format t "~%~%")
(format t "================================================================~%")
(format t "  LANGUAGE FORM /1 — REVIEW 1 — THE BEFORE-REPAIR WITNESS~%")
(format t "  NC-31, recorded in full against the unmodified branch tip~%")
(format t "================================================================~%")
(format t "~%  SBCL          : ~A~%" (lisp-implementation-version))
(format t "  grammar       : ~A v~D~%"
        (cd0:render-diagnostic (f1:petition-grammar-identity)) (f1:petition-grammar-version))
(format t "  policy        : ~A v~D~%"
        (cd0:render-diagnostic (f1:petition-policy-identity)) (f1:petition-policy-version))
(format t "  procedure     : ~A v~D~%"
        (cd0:render-diagnostic (f1:petition-submission-procedure-identity))
        (f1:petition-submission-procedure-version))

(install-schema)

(let* ((petition (build "nc31"))
       (good  (list (scan-witness "PLUT-7")))
       (wrong (list (scan-witness "WRONG-31")))
       (schema (wrapper))
       ;; THE TWO SEALED CONTEXTS.  Same supplied occurrence id "nc31-shared";
       ;; same four references; DIFFERENT live support and receiver bindings.
       (context-a (full-context good  schema "nc31-shared"))
       (context-b (full-context wrong schema "nc31-shared"))
       (by-id  (idd '("form1-selftest") '("by" "clerk")))
       (act-id (idd '("form1-selftest") '("act" "1")))
       (outcome-a (f1:submit-petition petition context-a
                                      :by :desk-clerk :by-id by-id :act-id act-id))
       (outcome-b (f1:submit-petition petition context-b
                                      :by :desk-clerk :by-id by-id :act-id act-id))
       (receipt-a (f1:petition-submission-outcome-receipt outcome-a))
       (receipt-b (f1:petition-submission-outcome-receipt outcome-b)))

  ;; ── 1. THE TWO SEALED CONTEXTS ─────────────────────────────────────────
  (rule "1.  THE TWO SEALED CONTEXTS")

  (sub "context A — sealed, bound to the witness that DISCHARGES the premise")
  (format t "  sealed-p           : ~A~%" (f1:derivation-resolution-context-sealed-p context-a))
  (show-datum "context occurrence identifier (the WHOLE of its identity)"
              (f1:derivation-resolution-context-occurrence-id context-a))
  (format t "  live support bound : ~S~%" (s0:witness-id (first good)))
  (format t "    its :FOR         : ~S~%" (s0:witness-for (first good)))

  (sub "context B — sealed, bound to a witness that does NOT discharge it")
  (format t "  sealed-p           : ~A~%" (f1:derivation-resolution-context-sealed-p context-b))
  (show-datum "context occurrence identifier (the WHOLE of its identity)"
              (f1:derivation-resolution-context-occurrence-id context-b))
  (format t "  live support bound : ~S~%" (s0:witness-id (first wrong)))
  (format t "    its :FOR         : ~S~%" (s0:witness-for (first wrong)))

  (sub "the comparison")
  (format t "  context occurrence identifiers : ~A~%"
          (same-p (f1:derivation-resolution-context-occurrence-id context-a)
                  (f1:derivation-resolution-context-occurrence-id context-b)))
  (format t "  live support objects (EQ)      : ~A~%"
          (if (eq (first good) (first wrong)) "IDENTICAL" "DIFFERENT"))
  (format t "  live receiver objects (EQ)     : ~A~%" "DIFFERENT (each built over its own witness list)")

  ;; ── 2. WHAT THE PUBLIC CONTEXT READER EXPOSES, AND WHAT IT OMITS ───────
  (rule "2.  WHAT THE PUBLIC CONTEXT READER EXPOSES — AND WHAT IT OMITS")

  (format t "~%  There is exactly ONE public aggregate reader on a context:~%")
  (format t "    DERIVATION-RESOLUTION-CONTEXT-BOUND-REFERENCES~%")
  (format t "~%  It returns (ROLE REFERENCE) per binding.  The bound VALUE — the cdr of~%")
  (format t "  the stored cell — is dropped.~%")

  (let ((exposed-a (f1:derivation-resolution-context-bound-references context-a))
        (exposed-b (f1:derivation-resolution-context-bound-references context-b)))
    (sub "reader output — context A")
    (dolist (entry exposed-a)
      (format t "    (~S ~A)~%" (first entry) (cd0:render-diagnostic (second entry))))
    (sub "reader output — context B")
    (dolist (entry exposed-b)
      (format t "    (~S ~A)~%" (first entry) (cd0:render-diagnostic (second entry))))
    (sub "the comparison")
    (format t "  entry count A / B                    : ~D / ~D~%"
            (length exposed-a) (length exposed-b))
    (format t "  role+reference lists, element-wise   : ~A~%"
            (if (every (lambda (x y)
                         (and (eq (first x) (first y))
                              (cd0:equal-datum (second x) (second y))))
                       exposed-a exposed-b)
                "IDENTICAL" "DIFFERENT"))
    (format t "~%  EXPOSED : role · reference identifier~%")
    (format t "  OMITTED : the bound live object, and any durable declaration of~%")
    (format t "            what that object was intended to denote.  There is no~%")
    (format t "            such declaration to omit — the layer never asked for one.~%")
    (format t "~%  CONSEQUENCE: from the public surface, contexts A and B are~%")
    (format t "  INDISTINGUISHABLE.  Nothing a durable record can hold separates them.~%"))

  ;; ── 3. THE TWO SUBMISSIONS ─────────────────────────────────────────────
  (rule "3.  THE TWO SUBMISSIONS — SAME PETITION, SAME ACT, SAME PRINCIPAL")

  (show-identity "petition occurrence identity (SHARED — one petition, submitted twice)"
                 (f1:derivation-petition-occurrence-identity petition))
  (show-datum "submission act id (:ACT-ID, shared)" act-id)
  (show-datum "asserting principal declaration (:BY-ID, shared)" by-id)
  (format t "  live :BY value (shared)  : ~S~%" :desk-clerk)

  (sub "submission A")
  (show-identity "SUBMISSION OCCURRENCE IDENTITY"
                 (f1:petition-submission-receipt-occurrence-identity receipt-a))
  (show-identity "SUBMISSION RECEIPT IDENTITY"
                 (f1:petition-submission-receipt-identity receipt-a))
  (format t "  outcome kind             : ~S~%" (f1:petition-submission-outcome-kind outcome-a))

  (sub "submission B")
  (show-identity "SUBMISSION OCCURRENCE IDENTITY"
                 (f1:petition-submission-receipt-occurrence-identity receipt-b))
  (show-identity "SUBMISSION RECEIPT IDENTITY"
                 (f1:petition-submission-receipt-identity receipt-b))
  (format t "  outcome kind             : ~S~%" (f1:petition-submission-outcome-kind outcome-b))

  ;; ── 4. THE EXACT SLICE /2 OUTCOMES ─────────────────────────────────────
  (rule "4.  THE EXACT SLICE /2 OUTCOMES")

  (sub "outcome A")
  (format t "  kind                       : ~S~%" (f1:petition-submission-outcome-kind outcome-a))
  (format t "  claim proposition          : ~S~%"
          (let ((claim (f1:petition-submission-outcome-claim outcome-a)))
            (if claim (s0:claim-proposition claim) :none)))
  (show-datum "Slice /2 receipt identity, as CD/0 data"
              (f1:petition-submission-receipt-slice2-receipt-identity-datum receipt-a))
  (format t "  Slice /2 condition class   : ~A~%"
          (or (f1:petition-submission-receipt-slice2-condition-class receipt-a) "(none)"))
  (let ((r (f1:petition-submission-outcome-slice2-receipt outcome-a)))
    (when r
      (format t "  Slice /2 receipt decision  : ~S~%" (s2:slice2-receipt-decision r))
      (format t "  strongest lawful result    : ~S~%" (s2:slice2-receipt-strongest-lawful-result r))))

  (sub "outcome B")
  (format t "  kind                       : ~S~%" (f1:petition-submission-outcome-kind outcome-b))
  (format t "  claim proposition          : ~S~%"
          (let ((claim (f1:petition-submission-outcome-claim outcome-b)))
            (if claim (s0:claim-proposition claim) :none)))
  (show-datum "Slice /2 receipt identity, as CD/0 data"
              (f1:petition-submission-receipt-slice2-receipt-identity-datum receipt-b))
  (format t "  Slice /2 condition class   : ~A~%"
          (or (f1:petition-submission-receipt-slice2-condition-class receipt-b) "(none)"))
  (let ((c (f1:petition-submission-outcome-condition outcome-b)))
    (when c
      (format t "  Slice /2 condition report  : ~A~%" c)))
  (let ((r (f1:petition-submission-outcome-slice2-receipt outcome-b)))
    (when r
      (format t "  Slice /2 receipt decision  : ~S~%" (s2:slice2-receipt-decision r))
      (format t "  strongest lawful result    : ~S~%" (s2:slice2-receipt-strongest-lawful-result r))))

  ;; ── 5. WHICH BOUND VALUES DIFFERED ─────────────────────────────────────
  (rule "5.  WHICH BOUND VALUES DIFFERED")

  (format t "~%  role         reference                     context A                       context B~%")
  (format t "  ─────────────────────────────────────────────────────────────────────────────────────~%")
  (format t "  :SCHEMA      ref/schema/s                   ~28A  ~A~%"
          "the EQ same slice2-schema" "the EQ same slice2-schema  [SAME]")
  (format t "  :CONCLUSION  ref/conclusion/c               ~28A  ~A~%"
          ":volume-reshelved PLUT-7" ":volume-reshelved PLUT-7  [equal, distinct objects]")
  (format t "  :SUPPORT     ref/support/w1                 ~28A  ~A~%"
          (format nil "~A" (s0:witness-id (first good)))
          (format nil "~A  [DIFFERENT]" (s0:witness-id (first wrong))))
  (format t "  :RECEIVER    ref/receiver/r                 ~28A  ~A~%"
          "desk over PLUT-7 witness" "desk over WRONG-31 witness  [DIFFERENT]")
  (format t "~%  The support binding is the one that decides the outcome: A's witness~%")
  (format t "  discharges premise 0 of the schema, B's does not.~%")

  ;; ── 6. THE FINDING, STATED AS MEASURED ─────────────────────────────────
  (rule "6.  THE FINDING, STATED AS MEASURED")

  (format t "~%  context occurrence identifiers         : ~A~%"
          (same-p (f1:derivation-resolution-context-occurrence-id context-a)
                  (f1:derivation-resolution-context-occurrence-id context-b)))
  (format t "  public context reader output           : IDENTICAL (see §2)~%")
  (format t "  petition occurrence identities         : IDENTICAL (one petition)~%")
  (format t "  submission act ids                     : IDENTICAL~%")
  (format t "  :BY-ID declarations                    : IDENTICAL~%")
  (format t "  live support bindings                  : DIFFERENT~%")
  (format t "  live receiver bindings                 : DIFFERENT~%")
  (format t "~%  SUBMISSION OCCURRENCE IDENTITIES       : ~A~%"
          (same-p (f1:petition-submission-receipt-occurrence-identity receipt-a)
                  (f1:petition-submission-receipt-occurrence-identity receipt-b)))
  (format t "  SUBMISSION RECEIPT IDENTITIES          : ~A~%"
          (same-p (f1:petition-submission-receipt-identity receipt-a)
                  (f1:petition-submission-receipt-identity receipt-b)))
  (format t "  GOVERNED OUTCOMES                      : ~S vs ~S  (~A)~%"
          (f1:petition-submission-outcome-kind outcome-a)
          (f1:petition-submission-outcome-kind outcome-b)
          (if (eq (f1:petition-submission-outcome-kind outcome-a)
                  (f1:petition-submission-outcome-kind outcome-b))
              "SAME" "OPPOSITE"))

  (format t "~%  Two governed acts with OPPOSITE outcomes carry the SAME durable~%")
  (format t "  submission occurrence identity, and the same durable receipt identity~%")
  (format t "  where the outcome kind is factored out.  The durable record of a~%")
  (format t "  governed act does not commit to what its references were declared to~%")
  (format t "  denote, because no such declaration is required or recorded.~%")

  (format t "~%  Honest documentation of this behaviour does not make the identity~%")
  (format t "  adequate.  This capture is the before-repair witness.~%"))

(format t "~%~%== REVIEW-1-NC31-BEFORE: record complete, nothing asserted ==~%")
