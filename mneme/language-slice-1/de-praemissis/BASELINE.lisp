;;;; BASELINE.lisp — de-praemissis baseline: disciplined idiomatic Common Lisp
;;;; with NO Slice /0 and NO Slice /1.  A good-faith attempt to encode artifact
;;;; admissibility (for a receiver and deployment purpose) using nothing but
;;;; plain data and hand-written predicate checks.
;;;;
;;;; The point of the baseline is NOT to fail.  Disciplined CL genuinely CAN
;;;; encode the four premise checks, name the missing one, and refuse honestly —
;;;; and the first section proves it does.  The point is what the LAST section
;;;; proves: that this discipline is CONVENTION.  A second author, writing a
;;;; straight-line variant that simply never calls the recognition check, gets a
;;;; ":granted" result whose return value is byte-indistinguishable from a grant
;;;; that DID check recognition.  Nothing in the data, the types, or the return
;;;; value carries a machine-visible trace that a required premise was omitted.
;;;; That gap — enforced-by-nobody — is the S3 species waiting to happen, and it
;;;; is exactly what Slice /1's declared anatomy closes (see SPECIMEN.lisp).
;;;;
;;;; Run: sbcl --non-interactive --load BASELINE.lisp   (exits 0)

(defpackage #:de-praemissis-baseline (:use #:cl))
(in-package #:de-praemissis-baseline)

;;; ==================================================================
;;; Evidence as plain data.  Each item of evidence is a plist naming a
;;; predicate and its arguments — "explicit predicates as plain data", the
;;; honest CL way, with no schema machinery behind it.

(defun ev (predicate &rest args)
  "Construct one piece of evidence as a plist: (:predicate P <role val> …)."
  (list* :predicate predicate args))

(defun ev-predicate (e) (getf e :predicate))
(defun ev-arg (e role) (getf e role))

;;; ------------------------------------------------------------------
;;; Hand-written premise checks.  Each looks through the supplied evidence
;;; list for a matching item and confirms the arguments agree with the
;;; conclusion's artifact / receiver / purpose.  Honest and explicit.

(defun digest-matches-p (evidence artifact)
  (some (lambda (e)
          (and (eq (ev-predicate e) :digest-matches)
               (equal (ev-arg e :artifact) artifact)))
        evidence))

(defun signature-valid-p (evidence artifact)
  (some (lambda (e)
          (and (eq (ev-predicate e) :signature-valid)
               (equal (ev-arg e :artifact) artifact)))
        evidence))

(defun receiver-recognizes-signer-p (evidence receiver)
  (some (lambda (e)
          (and (eq (ev-predicate e) :receiver-recognizes-signer)
               (eq (ev-arg e :receiver) receiver)))
        evidence))

(defun provenance-admissible-p (evidence artifact receiver purpose)
  (some (lambda (e)
          (and (eq (ev-predicate e) :provenance-admissible)
               (equal (ev-arg e :artifact) artifact)
               (eq (ev-arg e :receiver) receiver)
               (eq (ev-arg e :purpose) purpose)))
        evidence))

;;; ------------------------------------------------------------------
;;; The DISCIPLINED admission function.  It checks all four premises, collects
;;; the names of any that are missing, and refuses with an honest message that
;;; names them.  This is competent, good-faith code.

(defparameter *required-premises*
  '(:digest-matches :signature-valid :receiver-recognizes-signer
    :provenance-admissible)
  "The convention: these four must hold.  Nothing enforces that a checker
consults this list — it is documentation a careful author reads.")

(defun admit-artifact (artifact receiver purpose evidence)
  "Disciplined admission: check every required premise, name the missing ones.
Returns (values DECISION MISSING-LIST); DECISION is :granted or :refused."
  (let ((missing '()))
    (unless (digest-matches-p evidence artifact)
      (push :digest-matches missing))
    (unless (signature-valid-p evidence artifact)
      (push :signature-valid missing))
    (unless (receiver-recognizes-signer-p evidence receiver)
      (push :receiver-recognizes-signer missing))
    (unless (provenance-admissible-p evidence artifact receiver purpose)
      (push :provenance-admissible missing))
    (setf missing (nreverse missing))
    (if missing
        (values :refused missing)
        (values :granted '()))))

;;; ------------------------------------------------------------------
;;; The CONVENTION-BREAKING variant.  Written by a second author in a hurry.
;;; It is a perfectly ordinary straight-line function.  It checks digest,
;;; signature, and provenance — and simply never mentions recognition.  There
;;; is no bug, no exception, no warning.  It returns :granted, and its return
;;; value is identical in shape to a disciplined grant.

(defun admit-artifact-fast (artifact receiver purpose evidence)
  "A straight-line admission that OMITS the recognition check.  Returns
:granted with no trace that a required premise was never consulted."
  (when (and (digest-matches-p evidence artifact)
             (signature-valid-p evidence artifact)
             ;; recognition check absent — nothing here, nothing records it
             (provenance-admissible-p evidence artifact receiver purpose))
    :granted))

;;; ==================================================================
;;; Demonstration.

(defun line (fmt &rest args) (apply #'format t fmt args) (terpri))

(defun main ()
  (line "== de-praemissis BASELINE (disciplined idiomatic CL, no Slice /0 or /1) ==")
  (let* ((art "artifact-1")
         (rcv :receiver-a)
         (pur :production)
         ;; evidence WITHOUT recognition — a signer whose recognition is unknown
         (evidence-no-recog
           (list (ev :digest-matches :artifact art)
                 (ev :signature-valid :artifact art :signature "S1" :key "K1")
                 (ev :provenance-admissible :artifact art :receiver rcv :purpose pur)))
         ;; the same, plus a recognition fact
         (evidence-full
           (cons (ev :receiver-recognizes-signer :receiver rcv :signer "signer-acme")
                 evidence-no-recog)))

    (line "~%-- Section 1: the discipline WORKS --")
    (multiple-value-bind (d missing) (admit-artifact art rcv pur evidence-full)
      (line "  disciplined, full evidence         => ~S~@[ (missing ~S)~]" d missing))
    (multiple-value-bind (d missing) (admit-artifact art rcv pur evidence-no-recog)
      (line "  disciplined, recognition absent    => ~S; NAMED missing: ~S" d missing)
      (assert (eq d :refused))
      (assert (equal missing '(:receiver-recognizes-signer))))
    (line "  ^ disciplined CL genuinely refuses and names the omitted premise.")

    (line "~%-- Section 2: the discipline is only CONVENTION --")
    (let ((fast (admit-artifact-fast art rcv pur evidence-no-recog)))
      (line "  straight-line variant, SAME evidence => ~S" fast)
      (assert (eq fast :granted))
      (line "  ^ recognition was never represented, never checked, never missed."))

    (line "~%-- Section 3: the gap, shown side by side --")
    (let ((disciplined (multiple-value-list
                        (admit-artifact art rcv pur evidence-no-recog)))
          (fast (admit-artifact-fast art rcv pur evidence-no-recog)))
      (line "  disciplined return : ~S" disciplined)
      (line "  fast return        : ~S" (list fast))
      (line "  A grant that CHECKED recognition and a grant that SKIPPED it are")
      (line "  indistinguishable from the return value alone — the ':granted' keyword")
      (line "  carries no anatomy.  Which premises were consulted is invisible to")
      (line "  the caller, the type system, and any downstream auditor.  The")
      (line "  guarantee lives in a programmer's habit, enforced by nobody.")
      (line "  THIS is the convention-vs-enforcement gap Slice /1 closes by making")
      (line "  the premise set a declared, receipt-bearing part of the judgment."))

    (line "~%baseline: convention demonstrated (discipline works AND is unenforced)")))

(main)
(finish-output)
(sb-ext:exit :code 0)
