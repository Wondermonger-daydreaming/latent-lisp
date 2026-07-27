;;;; form1-selftest.lisp — Language Form /1, Candidate /0, POLICY v2.
;;;;
;;;; Run: sbcl --non-interactive --load form1-selftest.lisp
;;;; Exits non-zero on any failure.  Check numbering is contiguous by
;;;; construction (one counter, incremented inside CHECK).
;;;;
;;;; ── WHICH DOCUMENT GOVERNS ─────────────────────────────────────────────
;;;;
;;;; FORM1.LISP GOVERNS.  This suite follows the IMPLEMENTATION wherever it and
;;;; LANGUAGE-FORM-1-WORK-ORDER.md disagree.
;;;;
;;;; STATE OF THAT DISAGREEMENT, VERIFIED BY SET COMPARISON RATHER THAN ASSUMED
;;;; (2026-07-27): the work order now carries AMENDMENT 2 (§0-A, POLICY v2), and
;;;; its amended §11 catalogue and §13 ceilings AGREE with form1.lisp.  Compared
;;;; code-set against code-set, form1.lisp declares nothing §11 omits, and the
;;;; only §11 entries with no implementation counterpart are the three the table
;;;; itself strikes or removes:
;;;;
;;;;   :identity-length-exceeded    struck through in place, → :identity-octets-exceeded
;;;;   :petition-field-duplicate    "Removed as unreachable (§1.1c)"
;;;;   :unknown-petition-operation  "Removed with the head"
;;;;
;;;; A PROVENANCE NOTE, BECAUSE IT IS THE ARGUMENT FOR HOW T-CODESET IS BUILT.
;;;; An earlier read of that same file, during the writing of this suite, showed
;;;; the PRE-amendment table — the v1 `:identity-length-exceeded` row live and
;;;; unstruck, with no `:submission-envelope-exceeded` row at all.  The document
;;;; was amended underneath this file (mtime moved to 02:54:33 while this suite
;;;; was being written), and a header transcribed from the earlier read was
;;;; wrong within twenty minutes.
;;;;
;;;; Hence: THE AUTHORITY FOR THE CODE SET IS (PETITION-REFUSAL-CODES), READ FROM
;;;; THE RUNNING IMAGE AT THE MOMENT THE TOOTH FIRES — never a table anybody
;;;; transcribed into this file, and never a count anybody remembered.  T-CODESET
;;;; (§N, the last tooth here) compares that live declared set against the codes
;;;; THIS RUN ACTUALLY PRODUCED, set-difference in BOTH directions.  A menu of
;;;; acceptable reasons may not stand in for the reason a fixture produces — and
;;;; a transcribed catalogue is exactly such a menu, one document-edit from a lie.
;;;;
;;;; ── WHAT THIS SUITE REFUSES TO DO ──────────────────────────────────────
;;;;
;;;;   · No check asserts membership where it claims exactness.  Every refusal
;;;;     tooth asserts (EQ code :EXACT-CODE), never (MEMBER code '(...)).
;;;;   · No gate is trusted until it has been shown able to FAIL.  The source
;;;;     scanner is teeth-checked against planted faults before it is believed
;;;;     (T-SCAN-01..06), and the five §15 planted faults are run against the
;;;;     live teeth that are supposed to catch them.
;;;;   · Identities are CD/0 BYTES DATA.  Nothing here compares one with STRING=.
;;;;     Comparison is LISP-PLUS-CD0:EQUAL-DATUM; hex is diagnostic only.
;;;;   · Aliasing teeth mutate WHAT THE READER HANDED BACK, never merely the
;;;;     caller's own input.  (de-pignore Review 2: a read-only SLOT is not an
;;;;     immutable VALUE, and a test that mutates its own argument tests nothing.)

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:form1-selftest
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:form1-selftest)

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(defparameter *form1-source* (merge-pathnames "form1.lisp" *here*))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 0.  THE HARNESS
;;; ══════════════════════════════════════════════════════════════════════════

(defparameter *checks* 0)
(defparameter *failed* 0)
(defparameter *failed-labels* '())

(defun check (condition label)
  (incf *checks*)
  (if condition
      (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (push (format nil "[~2,'0D] ~A" *checks* label) *failed-labels*)
             (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(defun section (title)
  (format t "~%── ~A~%" title))

(defun desk-note (control &rest arguments)
  (format t "       ~A~%" (apply #'format nil control arguments)))

;;; The produced-code ledger.  Every refusal this suite reads goes through
;;; CODE-OF, so the set T-CODESET compares against is a RECORD OF PRODUCTION,
;;; not a list anybody typed.
;;; TWO LEDGERS, NOT ONE.  Policy v3 publishes the refusal codes split by
;;; evidentiary class, so the suite records production the same way.  A single
;;; ledger printed `36/36' and flattened the distinction between a code a public
;;; caller provoked and a code produced by shimming an internal function — a
;;; COUNT STANDING IN FOR A DEMONSTRATION, which is the very defect the tooth
;;; exists to prevent.
(defparameter *produced-by-public-api* '()
  "Codes produced by exercising the DOCUMENTED PUBLIC SURFACE.")
(defparameter *produced-under-induction* '()
  "Codes produced only while an INTERNAL FUNCTION IS SHIMMED.  A code that
appears only here has not been shown reachable by any caller.")
(defparameter *recording* t
  "Bound to NIL while a planted fault is live: a MUTANT's refusal is not
evidence that the HONEST layer can produce that code.")
(defparameter *inducing* nil
  "Bound to T while an internal function is shimmed to INDUCE an integrity
alarm.  Production under induction goes to the second ledger, never the first.")

(defun code-of (refusal)
  "The EXACT code REFUSAL carries, recorded as produced — INTO THE LEDGER THAT
MATCHES HOW IT WAS PRODUCED.  Returns the sentinel :NO-REFUSAL-PRODUCED — which
is in neither declared code set and can therefore never satisfy an exactness
assertion — when there is no refusal."
  (if (f1:petition-refusal-p refusal)
      (let ((code (f1:petition-refusal-code refusal)))
        (when *recording*
          (if *inducing*
              (pushnew code *produced-under-induction*)
              (pushnew code *produced-by-public-api*)))
        code)
      :no-refusal-produced))

(defun loud-refusal (thunk)
  "The refusal object carried by the PETITION-REFUSED a signalling operation
raises.  Only PETITION-REFUSED is caught: anything else escapes, exactly as the
layer requires."
  (handler-case (progn (funcall thunk) nil)
    (f1:petition-refused (condition) (f1:petition-refused-refusal condition))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 1.  THE FIXTURE CORPUS — a one-premise reshelving desk
;;;     (the EG-4 fixture, which is known to reach all three classified
;;;     outcomes; reused rather than reinvented)
;;; ══════════════════════════════════════════════════════════════════════════

(defun idd (namespace path) (cd0:make-identifier-datum namespace path))
(defun np (form) (s1:proposition form))
(defun pp (form) (s1:proposition-pattern form))

(defun install-schema (&optional (premise-predicate :volume-scanned-at-desk))
  (s1:clear-schema-registry)
  (s1:register-schema
   (s1:judgment-schema
    :name :volume-reshelved :version 1
    :conclusion (pp '(:predicate :volume-reshelved (:volume (:var :volume))))
    :premises (list (pp `(:predicate ,premise-predicate (:volume (:var :volume))))))))

(defun scan-contract ()
  (s2:make-support-admission-contract
   :contract-id :scan-by-direct-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :shelf-scan
                        :truth-ceiling :asserted))))

(defun wrapper ()
  "Built over what RESOLVE-SCHEMA returns right now: DERIVE/2 compares the base
schema with EQ, so a wrapper built before a re-registration is STALE."
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

(defun petition-tree (&key (supports '("w1")))
  (f1:petition-datum :schema (f1:schema-reference "s")
                     :conclusion (f1:conclusion-reference "c")
                     :supports (mapcar #'f1:support-reference supports)
                     :receiver (f1:receiver-reference "r")))

(defun build (&key (supports '("w1")) (tag "occ-1"))
  "(values DATUM PROPOSED VALIDATED PETITION MATERIALIZATION-RECEIPT)."
  (let* ((datum (petition-tree :supports supports))
         (proposed (f1:propose-petition datum))
         (validated (f1:validate-petition proposed)))
    (multiple-value-bind (petition receipt)
        (f1:materialize-petition validated (idd '("form1-selftest") (list "occ" tag)))
      (values datum proposed validated petition receipt))))

;;; Context construction, one binder per call so a fixture can omit exactly one
;;; binding and nothing else.
;;;
;;; POLICY v3 — EVERY BINDER TAKES A DENOTATION DECLARATION, and these helpers
;;; give each role a DEFAULT declaration so that ordinary fixtures read as
;;; before.  The default is a fixture convenience, never a layer default: the
;;; layer requires the argument explicitly and refuses without it, and
;;; NC-BIND-DECL-01 proves that by calling a binder with a non-datum.
;;;
;;; THE DECLARATION IS THE FIXTURE'S ASSERTION ABOUT ITS OWN ANCHOR.  Where a
;;; fixture changes the live value it must change the declaration too, or it is
;;; making a FALSE declaration — which is exactly NC-31B's subject, and is
;;; therefore something the fixtures must be able to do ON PURPOSE and never by
;;; accident.  Hence :DECLARATION is always explicit at the call sites that care.
(defun den (&rest path)
  "A fixture denotation declaration.  An ordinary immutable CD/0 identifier —
the layer requires a datum, not a particular shape."
  (idd '("form1-selftest" "denotation") path))

(defun ctx () (f1:make-derivation-resolution-context))
(defun +schema (context value &optional (key "s") (declaration (den "schema" key)))
  (f1:bind-schema-reference context (f1:schema-reference key) value declaration))
(defun +conclusion (context value &optional (key "c") (declaration (den "conclusion" key)))
  (f1:bind-conclusion-reference context (f1:conclusion-reference key) value declaration))
(defun +support (context value key &optional (declaration (den "support" key)))
  (f1:bind-support-reference context (f1:support-reference key) value declaration))
(defun +receiver (context value &optional (key "r")
                                  (declaration (if (null value)
                                                   (f1:receiver-absence-declaration)
                                                   (den "receiver" key))))
  (f1:bind-receiver-reference context (f1:receiver-reference key) value declaration))
(defun seal (context tag)
  (f1:seal-resolution-context context (idd '("form1-selftest") (list "ctx" tag))))

(defparameter +no-receiver+ '#:no-receiver
  "A sentinel meaning `build the desk'.  NIL is a REAL receiver value here —
explicit receiver absence — and must never be confused with `not supplied'.")

(defun full-context (support-keys witnesses schema tag
                     &key (receiver +no-receiver+) (volume "PLUT-7")
                          (conclusion nil conclusion-supplied)
                          support-declarations
                          receiver-declaration)
  "SUPPORT-DECLARATIONS, when supplied, is a list parallel to SUPPORT-KEYS of
denotation declarations.  It exists so NC-31A can change what a context DECLARES
and NC-31B can hold the declaration fixed while the live anchor moves — the two
halves the ruling splits the old single control into."
  (let ((context (+conclusion (+schema (ctx) schema)
                              (if conclusion-supplied conclusion
                                  (np `(:predicate :volume-reshelved (:volume ,volume)))))))
    (loop for key in support-keys
          for witness in witnesses
          for index from 0
          do (setf context
                   (if support-declarations
                       (+support context witness key (nth index support-declarations))
                       (+support context witness key))))
    (let ((receiver-value (if (eq receiver +no-receiver+) (desk witnesses) receiver)))
      (seal (if receiver-declaration
                (+receiver context receiver-value "r" receiver-declaration)
                (+receiver context receiver-value))
            tag))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 2.  INSTRUMENTS
;;; ══════════════════════════════════════════════════════════════════════════

;;; ---- the DERIVE/2 invocation counter (NC-28's instrument) ----------------
;;;
;;; It counts AND CAPTURES THE ARGUMENTS.  The argument capture is what turns
;;; NC-10 into a tooth PF-2 can die on: "DERIVE/2 was invoked" is satisfied by a
;;; pre-filtered call too; "DERIVE/2 received the exact resolved supports, in
;;; order, unfiltered" is not.

(defparameter *derive-calls* 0)
(defparameter *derive-args* nil)
(defparameter *real-derive* nil)

(defun install-derive-counter ()
  (unless *real-derive*
    (setf *real-derive* (fdefinition 's2:derive/2)))
  (setf *derive-calls* 0 *derive-args* nil)
  (setf (fdefinition 's2:derive/2)
        (lambda (&rest arguments)
          (incf *derive-calls*)
          (setf *derive-args* (copy-list arguments))
          (apply *real-derive* arguments))))

(defun restore-derive ()
  (when *real-derive*
    (setf (fdefinition 's2:derive/2) *real-derive*)))

;;; ---- the submission log (the POLICY v2 gravestone's evidence) ------------
(defparameter *submission-log* '())

(defun counted-submit (label petition context
                       &key (by :desk-clerk)
                            (by-id (idd '("form1-selftest") '("by" "clerk")))
                            (act-id (idd '("form1-selftest") '("act" "1"))))
  "Every submission in this suite goes through here, so the gravestone tooth
quantifies over the whole run and not over a hand-picked three.
Returns (values OUTCOME REFUSAL COUNT ARGS)."
  (install-derive-counter)
  (unwind-protect
       (multiple-value-bind (outcome refusal)
           (f1:try-submit-petition petition context :by by :by-id by-id :act-id act-id)
         (push (list :label label :count *derive-calls*
                     :outcome outcome :refusal refusal)
               *submission-log*)
         (values outcome refusal *derive-calls* *derive-args*))
    (restore-derive)))

;;; ---- induced identity drift ---------------------------------------------
;;;
;;; THE THREE DRIFT CODES ARE NOT REACHABLE THROUGH THE PUBLIC SURFACE, and
;;; that is a property of CD/0, verified rather than assumed: every CD/0
;;; accessor copies (BYTES-DATUM-VALUE -> %COPY-OCTET-VECTOR,
;;; SEQUENCE-DATUM-ELEMENTS -> COPY-SEQ, IDENTIFIER-DATUM-PATH -> a fresh
;;; vector), so a caller holding a phase object cannot mutate the datum it
;;; recomputes from.  The drift guards are therefore DEFENSIVE — they defend
;;; against a host or a future representation that does not hold that line.
;;; Their fixtures INDUCE the condition by shimming the internal recompute,
;;; and this comment is here so nobody later reads them as ordinary reachability.
(defun call-with-induced-drift (thunk)
  (let ((real (fdefinition 'lisp-plus-form1::%identity)))
    (unwind-protect
         (let ((*inducing* t))
           (setf (fdefinition 'lisp-plus-form1::%identity)
                 (lambda (payload)
                   (declare (ignore payload))
                   (cd0:make-bytes-datum
                    (cd0:canonical-octets (cd0:make-string-datum "INDUCED-DRIFT")))))
           (funcall thunk))
      (setf (fdefinition 'lisp-plus-form1::%identity) real))))

;;; ---- fingerprints --------------------------------------------------------
(defun petition-fingerprint (petition)
  "A BYTE-LEVEL fingerprint of everything the petition publicly holds.  Hex,
because this is a diagnostic comparison of a whole object and not an identity."
  (cd0:octets-to-hex
   (cd0:canonical-octets
    (cd0:make-sequence-datum
     (list (f1:derivation-petition-validated-identity petition)
           (f1:derivation-petition-subject-identity petition)
           (f1:derivation-petition-content-identity petition)
           (f1:derivation-petition-occurrence-identity petition)
           (f1:derivation-petition-occurrence-tag petition)
           (f1:derivation-petition-schema-reference petition)
           (f1:derivation-petition-conclusion-reference petition)
           (cd0:make-sequence-datum (f1:derivation-petition-support-references petition))
           (f1:derivation-petition-receiver-reference petition))))))

(defun pairwise-distinct-p (identities)
  (loop for (left . rest) on identities
        always (loop for right in rest never (cd0:equal-datum left right))))

(defun genealogy (proposed validated petition receipt)
  "The seven identities of one submitted genealogy, in phase order."
  (list (f1:proposed-petition-form-subject-identity proposed)
        (f1:proposed-petition-form-identity proposed)
        (f1:validated-petition-form-identity validated)
        (f1:derivation-petition-content-identity petition)
        (f1:derivation-petition-occurrence-identity petition)
        (f1:petition-submission-receipt-occurrence-identity receipt)
        (f1:petition-submission-receipt-identity receipt)))

;;; ---- the source scanner (§9 of the mission; NC-2) ------------------------
;;;
;;; IT SCANS CODE, NOT PROSE, AND THAT IS NOT A CONVENIENCE.  form1.lisp's own
;;; lines 38-40 sit BELOW the marker and read "No EVAL, COMPILE, LOAD, PERFORM,
;;; INTERN, FIND-SYMBOL, READ or blanket (ERROR () ...) handler may appear below
;;; it", and its docstrings say "never INTERN, never FIND-SYMBOL" and "not
;;; PRIN1-TO-STRING ... and not SXHASH".  A raw text grep fails on the file's own
;;; statement of the rule it obeys — a gate that cries wolf at the sign that says
;;; `no wolves'.  So comments and string literals are stripped first, and the
;;; stripper itself is teeth-checked (T-SCAN-01..06) before it is believed.

(defun read-file-text (path)
  (with-open-file (in path :element-type 'character)
    (let ((buffer (make-string (file-length in))))
      (subseq buffer 0 (read-sequence buffer in)))))

(defun strip-comments-and-strings (source)
  "SOURCE with ;-comments and \"string literals\" replaced by blanks.  Handles
\\ escapes inside strings and #\\c character literals; positions are preserved
so an offset in the result is an offset in the original."
  (let ((out (make-string (length source) :initial-element #\Space))
        (index 0)
        (length (length source)))
    (loop while (< index length)
          for ch = (char source index)
          do (cond
               ;; character literal: #\x — copy verbatim, never enters a state
               ((and (char= ch #\#) (< (1+ index) length)
                     (char= (char source (1+ index)) #\\))
                (setf (char out index) ch)
                (when (< (1+ index) length) (setf (char out (1+ index)) #\\))
                (when (< (+ 2 index) length)
                  (setf (char out (+ 2 index)) (char source (+ 2 index))))
                (incf index 3))
               ;; line comment
               ((char= ch #\;)
                (loop while (and (< index length) (char/= (char source index) #\Newline))
                      do (incf index))
                (when (< index length)
                  (setf (char out index) #\Newline)
                  (incf index)))
               ;; string literal
               ((char= ch #\")
                (incf index)
                (loop while (< index length)
                      do (let ((c (char source index)))
                           (cond ((char= c #\\) (incf index 2))
                                 ((char= c #\") (incf index) (return))
                                 (t (when (char= c #\Newline)
                                      (setf (char out index) #\Newline))
                                    (incf index))))))
               (t (setf (char out index) ch)
                  (incf index))))
    out))

(defun token-char-p (ch)
  (or (alphanumericp ch) (find ch "-%*+/<>=.!?&_~$^")))

(defun code-tokens (code)
  "Maximal runs of symbol-constituent characters, downcased.  `:' is NOT a
token character, so LISP-PLUS-CD0:CANONICAL-OCTETS yields two tokens and a
package-qualified escape cannot hide inside a prefix."
  (let ((tokens '()) (start nil) (length (length code)))
    (dotimes (index length)
      (let ((ch (char code index)))
        (cond ((token-char-p ch) (unless start (setf start index)))
              (start (push (string-downcase (subseq code start index)) tokens)
                     (setf start nil)))))
    (when start (push (string-downcase (subseq code start length)) tokens))
    (nreverse tokens)))

(defun collapse-whitespace (text)
  (with-output-to-string (out)
    (let ((pending nil))
      (loop for ch across text
            do (if (member ch '(#\Space #\Tab #\Newline #\Return #\Page))
                   (setf pending t)
                   (progn (when pending (write-char #\Space out) (setf pending nil))
                          (write-char ch out)))))))

(defun code-below-marker (source)
  (let ((position (search "==== BOOTSTRAP ENDS HERE ====" source)))
    (unless position (error "the bootstrap marker is gone from form1.lisp"))
    (strip-comments-and-strings (subseq source position))))

(defun token-present-p (code token)
  (member token (code-tokens code) :test #'string=))

(defun substring-present-p (code needle)
  (and (search needle (collapse-whitespace code) :test #'char-equal) t))

;;; ---- tree search (for `did this object reach that structure?') -----------
(defun tree-member-eq (tree target)
  (cond ((eq tree target) t)
        ((consp tree) (or (tree-member-eq (car tree) target)
                          (tree-member-eq (cdr tree) target)))
        (t nil)))

;;; ---- long identifier padding (for the two envelope teeth) ---------------
(defun padded-id (prefix pad-chars)
  "An identifier datum whose path carries PAD-CHARS characters, split across
segments of at most 50000 so CD/0's own MAX-SEGMENT-OCTETS (65536) is never the
thing that refuses.  A CD/0 budget failure is not a Form /1 refusal and must not
be allowed to counterfeit one."
  (idd '("form1-selftest")
       (cons prefix
             (or (loop for left = pad-chars then (- left 50000)
                       while (plusp left)
                       collect (make-string (min left 50000) :initial-element #\p))
                 (list "0")))))

;;; ══════════════════════════════════════════════════════════════════════════

(format t "~&== Language Form /1, Candidate /0 — SELFTEST (POLICY v~D) ==~%"
        (f1:petition-policy-version))
(format t "   grammar v~D · policy v~D · procedure v~D~%"
        (f1:petition-grammar-version) (f1:petition-policy-version)
        (f1:petition-submission-procedure-version))
(format t "   ceilings: ~D supports · ~D petition octets · ~D identity octets · ~D tail reserve~%"
        (f1:petition-policy-max-support-references)
        (f1:petition-policy-max-canonical-octets)
        (f1:petition-policy-max-identity-octets)
        (f1:petition-policy-outcome-tail-reserve-octets))
(format t "   declared refusal codes: ~D protocol + ~D integrity alarm = ~D catalogued~%"
        (length (f1:petition-protocol-refusal-codes))
        (length (f1:petition-integrity-alarm-codes))
        (length (f1:petition-refusal-code-catalog)))

(install-schema)

;;; ══════════════════════════════════════════════════════════════════════════
;;; A.  ONE FIXTURE PER REFUSAL CODE — EXACT CODE, NEVER MEMBERSHIP
;;; ══════════════════════════════════════════════════════════════════════════

(section "A. PROPOSE — boundary and grammar")

;; A/boundary
(check (eq (code-of (nth-value 1 (f1:try-propose-petition 42))) :not-a-datum)
       "PROPOSE of a host integer → code is EXACTLY :NOT-A-DATUM")

(check (string= (f1:petition-refusal-phase (nth-value 1 (f1:try-propose-petition 42)))
                "PROPOSE")
       "…and its phase reader returns :PROPOSE (SYMBOL-NAME compared, phase is a keyword)")

;; A/grammar — the shape ladder, in the order PROPOSE-PETITION walks it
(check (eq (code-of (nth-value 1 (f1:try-propose-petition (cd0:make-string-datum "not a node"))))
           :petition-node-not-a-sequence)
       "PROPOSE of a string datum → code is EXACTLY :PETITION-NODE-NOT-A-SEQUENCE")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (f1:petition-head-identifier))))))
           :petition-node-arity)
       "PROPOSE of a 1-element sequence → code is EXACTLY :PETITION-NODE-ARITY")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (cd0:make-integer-datum 1)
                                         (cd0:make-integer-datum 2))))))
           :head-not-identifier)
       "PROPOSE of [integer, integer] → code is EXACTLY :HEAD-NOT-IDENTIFIER")

;; NC-1 / NC-3: an ordinary DERIVE/2-shaped datum, and an unsupported governed
;; operation, are THE SAME REFUSAL — there is no operation table for a second
;; one to enter.
(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (idd '("lisp-plus-slice2") '("derive" "2"))
                                         (cd0:make-record-datum '()))))))
           :not-a-derivation-petition)
       "NC-1: an ordinary DERIVE/2-shaped head → code is EXACTLY :NOT-A-DERIVATION-PETITION")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (idd '("lisp-plus-form1")
                                              '("petition" "unsupported" "9"))
                                         (cd0:make-record-datum '()))))))
           :not-a-derivation-petition)
       "NC-3: an unsupported governed operation is an unsupported HEAD → EXACTLY :NOT-A-DERIVATION-PETITION")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (f1:petition-head-identifier)
                                         (cd0:make-string-datum "not a record"))))))
           :petition-body-not-a-record)
       "PROPOSE of [petition-head, string] → code is EXACTLY :PETITION-BODY-NOT-A-RECORD")

;; The four field keys, rebuilt from the PUBLIC CD/0 constructor rather than
;; reached through an internal.  The next check proves the reconstruction is the
;; real key, so a namespace change cannot silently turn the MISSING fixture into
;; an UNKNOWN one.
(defun field-key (name) (idd '("lisp-plus-form1") (list "field" name)))

(check (let* ((body (cd0:sequence-datum-ref (petition-tree) 1)))
         (and (= 4 (cd0:record-datum-size body))
              (every (lambda (name)
                       (loop for index from 0 below (cd0:record-datum-size body)
                             thereis (cd0:equal-datum (field-key name)
                                                      (cd0:record-datum-key-at body index))))
                     '("schema" "conclusion" "supports" "receiver"))))
       "ANTI-ROT: the four keys PETITION-DATUM writes EQUAL-DATUM the four this suite reconstructs")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (f1:petition-head-identifier)
                                         (cd0:make-record-datum
                                          (list (cd0:make-record-entry
                                                 (field-key "schema") (f1:schema-reference "s"))
                                                (cd0:make-record-entry
                                                 (field-key "conclusion") (f1:conclusion-reference "c"))
                                                (cd0:make-record-entry
                                                 (field-key "supports") (cd0:make-sequence-datum '())))))))))
           :petition-field-missing)
       "PROPOSE of a body missing `receiver' → code is EXACTLY :PETITION-FIELD-MISSING")

;; NC-27: a `by`-shaped field lands in the SAME unknown-field refusal — there is
;; no separate forbidden-name list to drift from the field list.
(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (f1:petition-head-identifier)
                                         (cd0:make-record-datum
                                          (list (cd0:make-record-entry
                                                 (field-key "schema") (f1:schema-reference "s"))
                                                (cd0:make-record-entry
                                                 (field-key "conclusion") (f1:conclusion-reference "c"))
                                                (cd0:make-record-entry
                                                 (field-key "supports") (cd0:make-sequence-datum '()))
                                                (cd0:make-record-entry
                                                 (field-key "receiver") (f1:receiver-reference "r"))
                                                (cd0:make-record-entry
                                                 (field-key "by") (cd0:make-string-datum "clerk")))))))))
           :petition-field-unknown)
       "NC-27: a petition carrying a `by' field → code is EXACTLY :PETITION-FIELD-UNKNOWN")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (cd0:make-sequence-datum
                                   (list (f1:petition-head-identifier)
                                         (cd0:make-record-datum
                                          (list (cd0:make-record-entry
                                                 (field-key "schema") (f1:schema-reference "s"))
                                                (cd0:make-record-entry
                                                 (field-key "conclusion") (f1:conclusion-reference "c"))
                                                (cd0:make-record-entry
                                                 (field-key "supports") (cd0:make-string-datum "nope"))
                                                (cd0:make-record-entry
                                                 (field-key "receiver") (f1:receiver-reference "r")))))))))
           :supports-not-a-sequence)
       "PROPOSE with a string in `supports' → code is EXACTLY :SUPPORTS-NOT-A-SEQUENCE")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (f1:petition-datum
                                   :schema (cd0:make-string-datum "s")
                                   :conclusion (f1:conclusion-reference "c")
                                   :supports '() :receiver (f1:receiver-reference "r")))))
           :malformed-reference)
       "PROPOSE with a string where the schema reference goes → code is EXACTLY :MALFORMED-REFERENCE")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (f1:petition-datum
                                   :schema (f1:conclusion-reference "c")
                                   :conclusion (f1:conclusion-reference "c")
                                   :supports '() :receiver (f1:receiver-reference "r")))))
           :reference-role-mismatch)
       "PROPOSE with a CONCLUSION reference in the schema slot → code is EXACTLY :REFERENCE-ROLE-MISMATCH")

(check (let ((refusal (nth-value 1 (f1:try-propose-petition
                                    (f1:petition-datum
                                     :schema (f1:conclusion-reference "c")
                                     :conclusion (f1:conclusion-reference "c")
                                     :supports '() :receiver (f1:receiver-reference "r"))))))
         (and (eq (f1:petition-refusal-expected-role refusal) :schema)
              (equal (f1:petition-refusal-path refusal) '(1 :schema))))
       "…and it names EXPECTED-ROLE :SCHEMA at path (1 :SCHEMA)")

(section "B. PROPOSE / MATERIALIZE / SUBMIT — the four resource ceilings")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (petition-tree
                                   :supports (loop for i from 1 to 17
                                                   collect (format nil "w~D" i))))))
           :support-count-exceeded)
       "PROPOSE with 17 support references (ceiling 16) → code is EXACTLY :SUPPORT-COUNT-EXCEEDED")

(check (eq (code-of (nth-value 1 (f1:try-propose-petition
                                  (petition-tree
                                   :supports (loop for i from 1 to 16
                                                   collect (concatenate
                                                            'string
                                                            (make-string 2000 :initial-element #\k)
                                                            (format nil "~D" i)))))))
           :petition-octets-exceeded)
       "PROPOSE of a ~32KB petition (ceiling 16384 octets) → code is EXACTLY :PETITION-OCTETS-EXCEEDED")

;; :IDENTITY-OCTETS-EXCEEDED — reached with a lawful petition and an oversized
;; host-supplied occurrence tag.  It is a %GATED-IDENTITY refusal and every call
;; site of that gate is BEFORE invocation.
(multiple-value-bind (datum proposed validated) (build)
  (declare (ignore datum proposed))
  (multiple-value-bind (petition receipt refusal)
      (f1:try-materialize-petition validated (padded-id "huge-tag" 80000))
    (declare (ignore petition receipt))
    (check (eq (code-of refusal) :identity-octets-exceeded)
           "MATERIALIZE with an 80000-character occurrence tag → code is EXACTLY :IDENTITY-OCTETS-EXCEEDED")
    (desk-note "~A" (f1:petition-refusal-detail refusal))))

;; :SUBMISSION-ENVELOPE-EXCEEDED — the pre-invocation BUILD gate.  Its band is
;; (envelope - reserve, envelope] = (61440, 65536] octets of submission
;; occurrence identity, so the fixture BISECTS for it rather than hard-coding a
;; padding constant that would rot the day any ceiling moved.
(multiple-value-bind (datum proposed validated petition) (build)
  (declare (ignore datum proposed validated))
  (let ((empty (seal (ctx) "empty-for-envelope")))
    (labels ((probe (pad)
               (multiple-value-bind (outcome refusal)
                   (f1:try-submit-petition
                    petition empty :by :desk-clerk
                    :by-id (idd '("form1-selftest") '("by" "clerk"))
                    :act-id (padded-id "act" pad))
                 (declare (ignore outcome))
                 (if refusal (f1:petition-refusal-code refusal) :invoked))))
      (let ((low 0) (high 200000) (found nil) (steps 0))
        ;; invariant: LOW is under the band, HIGH is over the envelope.
        (loop while (and (null found) (< steps 40) (< (1+ low) high))
              do (incf steps)
                 (let* ((mid (floor (+ low high) 2))
                        (code (probe mid)))
                   (case code
                     (:submission-envelope-exceeded (setf found mid))
                     (:identity-octets-exceeded (setf high mid))
                     (t (setf low mid)))))
        (check (and found
                    (eq (code-of (nth-value 1 (f1:try-submit-petition
                                               petition empty :by :desk-clerk
                                               :by-id (idd '("form1-selftest") '("by" "clerk"))
                                               :act-id (padded-id "act" found))))
                        :submission-envelope-exceeded))
               "SUBMIT whose occurrence identity + reserved tail overflows the envelope → code is EXACTLY :SUBMISSION-ENVELOPE-EXCEEDED")
        (desk-note "band located by bisection at ~D padding characters in ~D probes" (or found -1) steps)
        (when found
          (desk-note "~A"
                     (f1:petition-refusal-detail
                      (nth-value 1 (f1:try-submit-petition
                                    petition empty :by :desk-clerk
                                    :by-id (idd '("form1-selftest") '("by" "clerk"))
                                    :act-id (padded-id "act" found))))))
        ;; The gate refuses BEFORE invocation — the whole point of moving it.
        (when found
          (multiple-value-bind (outcome refusal count)
              (counted-submit "envelope-exceeded" petition empty
                              :act-id (padded-id "act" found))
            (declare (ignore outcome))
            (check (and (= 0 count) (eq (f1:petition-refusal-code refusal)
                                        :submission-envelope-exceeded))
                   "…and DERIVE/2 was invoked 0 times: the envelope gate is a BUILD gate, not a post-act refusal")))))))

(section "C. SPECIES, ARGUMENT AND CONTEXT-PROTOCOL REFUSALS")

(check (eq (code-of (nth-value 1 (f1:try-validate-petition :not-a-form)))
           :not-a-proposed-petition-form)
       "VALIDATE of a keyword → code is EXACTLY :NOT-A-PROPOSED-PETITION-FORM")

(check (eq (code-of (nth-value 2 (f1:try-materialize-petition
                                  :not-a-form (idd '("form1-selftest") '("occ" "x")))))
           :not-a-validated-petition-form)
       "MATERIALIZE of a keyword → code is EXACTLY :NOT-A-VALIDATED-PETITION-FORM (THIRD value)")

(multiple-value-bind (datum proposed validated) (build)
  (declare (ignore datum proposed))
  (check (eq (code-of (nth-value 2 (f1:try-materialize-petition validated :not-a-datum)))
             :occurrence-tag-required)
         "MATERIALIZE with a keyword occurrence tag → code is EXACTLY :OCCURRENCE-TAG-REQUIRED"))

(multiple-value-bind (datum proposed validated petition) (build)
  (declare (ignore datum proposed validated))
  (let ((sealed (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "species")))
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      :not-a-petition sealed :by :clerk
                                      :by-id (idd '("form1-selftest") '("by" "1"))
                                      :act-id (idd '("form1-selftest") '("act" "1")))))
               :not-a-derivation-petition)
           "SUBMIT of a keyword petition → code is EXACTLY :NOT-A-DERIVATION-PETITION (:SUBMIT/:SPECIES)")
    (check (let ((refusal (nth-value 1 (f1:try-submit-petition
                                        :not-a-petition sealed :by :clerk
                                        :by-id (idd '("form1-selftest") '("by" "1"))
                                        :act-id (idd '("form1-selftest") '("act" "1"))))))
             (and (eq (f1:petition-refusal-phase refusal) :submit)
                  (eq (f1:petition-refusal-category refusal) :species)))
           "…and it is phase :SUBMIT category :SPECIES — one code, two phases, distinguished by the phase field")
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      petition :not-a-context :by :clerk
                                      :by-id (idd '("form1-selftest") '("by" "1"))
                                      :act-id (idd '("form1-selftest") '("act" "1")))))
               :not-a-resolution-context)
           "SUBMIT with a keyword context → code is EXACTLY :NOT-A-RESOLUTION-CONTEXT")
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      petition sealed :by nil
                                      :by-id (idd '("form1-selftest") '("by" "1"))
                                      :act-id (idd '("form1-selftest") '("act" "1")))))
               :by-required)
           "SUBMIT with :BY NIL → code is EXACTLY :BY-REQUIRED (DERIVE/2's NIL->:DERIVER default is NOT inherited)")
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      petition sealed :by :clerk :by-id 42
                                      :act-id (idd '("form1-selftest") '("act" "1")))))
               :by-id-required)
           "SUBMIT with a non-datum :BY-ID → code is EXACTLY :BY-ID-REQUIRED")
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      petition sealed :by :clerk
                                      :by-id (idd '("form1-selftest") '("by" "1"))
                                      :act-id 42)))
               :act-id-required)
           "SUBMIT with a non-datum :ACT-ID → code is EXACTLY :ACT-ID-REQUIRED")
    (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                      petition (ctx) :by :clerk
                                      :by-id (idd '("form1-selftest") '("by" "1"))
                                      :act-id (idd '("form1-selftest") '("act" "1")))))
               :context-not-sealed)
           "SUBMIT with an UNSEALED context → code is EXACTLY :CONTEXT-NOT-SEALED")))

;; The binders signal; they have no TRY- twins, so these read the condition.
(check (eq (code-of (loud-refusal (lambda () (+schema :not-a-context (wrapper)))))
           :not-a-resolution-context)
       "BIND-SCHEMA-REFERENCE on a keyword → code is EXACTLY :NOT-A-RESOLUTION-CONTEXT")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-schema-reference
                                 (ctx) (cd0:make-string-datum "s") (wrapper)
                                 (den "schema" "s")))))
           :malformed-reference)
       "BIND-SCHEMA-REFERENCE with a string key → code is EXACTLY :MALFORMED-REFERENCE (:CONTEXT phase)")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-schema-reference
                                 (ctx) (f1:support-reference "s") (wrapper)
                                 (den "schema" "s")))))
           :binding-role-mismatch)
       "BIND-SCHEMA-REFERENCE with a SUPPORT-role reference → code is EXACTLY :BINDING-ROLE-MISMATCH")

(check (eq (code-of (loud-refusal (lambda () (+schema (+schema (ctx) (wrapper)) (wrapper)))))
           :duplicate-binding)
       "BIND-SCHEMA-REFERENCE twice on the same reference → code is EXACTLY :DUPLICATE-BINDING")

;; NC-37
(check (eq (code-of (loud-refusal
                     (lambda () (+schema (seal (ctx) "sealed-then-bound") (wrapper)))))
           :binding-after-seal)
       "NC-37: binding into a SEALED context → code is EXACTLY :BINDING-AFTER-SEAL")

(check (eq (code-of (loud-refusal (lambda () (f1:seal-resolution-context (ctx) 42))))
           :context-occurrence-tag-required)
       "SEAL with a non-datum occurrence tag → code is EXACTLY :CONTEXT-OCCURRENCE-TAG-REQUIRED")

(check (eq (code-of (loud-refusal (lambda () (+schema (ctx) :not-a-schema))))
           :wrong-schema-species)
       "BIND-SCHEMA-REFERENCE to a keyword → code is EXACTLY :WRONG-SCHEMA-SPECIES")

(check (eq (code-of (loud-refusal (lambda () (+receiver (ctx) :not-a-receiver))))
           :wrong-receiver-species)
       "BIND-RECEIVER-REFERENCE to a keyword → code is EXACTLY :WRONG-RECEIVER-SPECIES")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:derivation-resolution-context-declarations :nope))))
           :not-a-resolution-context)
       "CONTEXT-DECLARATIONS of a keyword → code is EXACTLY :NOT-A-RESOLUTION-CONTEXT")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:derivation-resolution-context-live-anchor
                                 :nope :schema (f1:schema-reference "s")))))
           :not-a-resolution-context)
       "LIVE-ANCHOR of a keyword → code is EXACTLY :NOT-A-RESOLUTION-CONTEXT")

;; ---- POLICY v3 — the denotation declaration is REQUIRED, with no default ----

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-schema-reference (ctx) (f1:schema-reference "s")
                                                          (wrapper) :not-a-datum))))
           :denotation-declaration-required)
       "NC-BIND-DECL-01: a binder called with a NON-DATUM denotation → code is EXACTLY :DENOTATION-DECLARATION-REQUIRED (the helpers' defaults are a FIXTURE convenience; the layer has none)")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-support-reference (ctx) (f1:support-reference "w1")
                                                           :any-host-object nil))))
           :denotation-declaration-required)
       "NC-BIND-DECL-02: NIL is not a declaration either — a value-UNTYPED binder still requires the datum")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-receiver-reference (ctx) (f1:receiver-reference "r")
                                                            nil (den "receiver" "improvised")))))
           :receiver-absence-declaration-required)
       "NC-BIND-DECL-03: a receiver bound to NIL described by an ARBITRARY identifier → code is EXACTLY :RECEIVER-ABSENCE-DECLARATION-REQUIRED (absence is not the host's to name)")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:bind-receiver-reference
                                 (ctx) (f1:receiver-reference "r")
                                 (desk (list (scan-witness "PLUT-7")))
                                 (f1:receiver-absence-declaration)))))
           :receiver-absence-declaration-misapplied)
       "NC-BIND-DECL-04: the receiver-absence declaration supplied for a LIVE receiver → code is EXACTLY :RECEIVER-ABSENCE-DECLARATION-MISAPPLIED (the sanctioned marker means one thing or it means nothing)")

(check (f1:derivation-resolution-context-p
        (+receiver (ctx) nil "r" (f1:receiver-absence-declaration)))
       "…and NIL WITH the sanctioned declaration binds cleanly — explicit receiver absence remains a legal, declared fact")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:derivation-resolution-context-live-anchor
                                 (seal (ctx) "anchor-role") :not-a-role
                                 (f1:schema-reference "s")))))
           :unknown-binding-role)
       "NC-ANCHOR-01: LIVE-ANCHOR with a role that is none of the four → code is EXACTLY :UNKNOWN-BINDING-ROLE")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:derivation-resolution-context-live-anchor
                                 (seal (ctx) "anchor-mismatch") :schema
                                 (f1:support-reference "s")))))
           :binding-role-mismatch)
       "NC-ANCHOR-02: LIVE-ANCHOR asking :SCHEMA with a SUPPORT-role reference → code is EXACTLY :BINDING-ROLE-MISMATCH")

(check (eq (code-of (loud-refusal
                     (lambda () (f1:derivation-resolution-context-live-anchor
                                 (seal (ctx) "anchor-malformed") :schema
                                 (cd0:make-string-datum "s")))))
           :malformed-reference)
       "NC-ANCHOR-03: LIVE-ANCHOR with a string key → code is EXACTLY :MALFORMED-REFERENCE")

;; The two VALUE-UNCHECKED binders, verified as deliberate rather than forgotten.
(check (f1:derivation-resolution-context-p (+conclusion (ctx) :any-host-object))
       "BIND-CONCLUSION-REFERENCE accepts an arbitrary host value (value-unchecked BY DESIGN — §6.2)")

(check (f1:derivation-resolution-context-p (+support (ctx) :any-host-object "w1"))
       "BIND-SUPPORT-REFERENCE accepts an arbitrary host value (DERIVE/2 owns support classification)")

(check (f1:derivation-resolution-context-p (+receiver (ctx) nil))
       "BIND-RECEIVER-REFERENCE accepts NIL — explicit receiver ABSENCE is a legal binding")

(section "D. THE THREE IDENTITY-DRIFT GUARDS (induced — see the note in §2)")

(multiple-value-bind (datum proposed validated petition) (build)
  (declare (ignore datum))
  (call-with-induced-drift
   (lambda ()
     (check (eq (code-of (nth-value 1 (f1:try-validate-petition proposed)))
                :proposed-identity-drift)
            "VALIDATE when the proposed form stops recomputing → code is EXACTLY :PROPOSED-IDENTITY-DRIFT")
     (check (eq (code-of (nth-value 2 (f1:try-materialize-petition
                                       validated (idd '("form1-selftest") '("occ" "d")))))
                :validated-identity-drift)
            "MATERIALIZE when the validated form stops recomputing → code is EXACTLY :VALIDATED-IDENTITY-DRIFT")
     (check (eq (code-of (nth-value 1 (f1:try-submit-petition
                                       petition (seal (ctx) "drift") :by :clerk
                                       :by-id (idd '("form1-selftest") '("by" "1"))
                                       :act-id (idd '("form1-selftest") '("act" "1")))))
                :petition-identity-drift)
            "SUBMIT when the petition stops recomputing → code is EXACTLY :PETITION-IDENTITY-DRIFT"))))

;; And the honest ceiling on those three, stated as a check rather than a comment.
;; REPAIRED 2026-07-27 by the chair, on FANG's own report.  The shipped form
;; was a TAUTOLOGY: it filled the FIRST read, then compared the store against a
;; datum rebuilt from a SECOND read.  Under an aliasing accessor BOTH sides are
;; zeroed, so equality held either way — it demonstrated that
;; MAKE-BYTES-DATUM . BYTES-DATUM-VALUE round-trips, while wearing a label that
;; claimed to demonstrate defensive copying.  Run against a simulated aliasing
;; accessor it returned T, exactly as it did against the real one.
;;
;; The discriminating question is not "does a rebuild still match" but "did the
;; STORE SURVIVE the caller's fill".  T under the real accessor, NIL under an
;; aliasing one.
(check (let ((identity (f1:proposed-petition-form-subject-identity
                        (f1:propose-petition (petition-tree)))))
         (let ((first-read (cd0:bytes-datum-value identity)))
           (fill first-read 0)
           (notevery #'zerop (cd0:bytes-datum-value identity))))
       "CEILING ON THE DRIFT GUARDS: filling BYTES-DATUM-VALUE's return leaves the STORE intact — no public caller can force real drift (tripwire on a CD/0 guarantee, not a Form /1 one)")

(section "E. RESOLUTION — the four unresolved references refuse BEFORE invocation")

(multiple-value-bind (datum proposed validated petition) (build)
  (declare (ignore datum proposed validated))
  (let ((witnesses (list (scan-witness "PLUT-7"))))
    ;; NC-6
    (let ((context (seal (+receiver (+support (+conclusion (ctx)
                                                           (np '(:predicate :volume-reshelved
                                                                 (:volume "PLUT-7"))))
                                              (first witnesses) "w1")
                                    (desk witnesses))
                         "no-schema")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit "unresolved-schema" petition context)
        (declare (ignore outcome))
        (check (eq (code-of refusal) :unresolved-schema-reference)
               "NC-6: unresolved SCHEMA reference → code is EXACTLY :UNRESOLVED-SCHEMA-REFERENCE")
        (check (= 0 count)
               "NC-6: …and the DERIVE/2 invocation counter reads EXACTLY 0")))
    ;; conclusion
    (let ((context (seal (+receiver (+support (+schema (ctx) (wrapper))
                                              (first witnesses) "w1")
                                    (desk witnesses))
                         "no-conclusion")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit "unresolved-conclusion" petition context)
        (declare (ignore outcome))
        (check (eq (code-of refusal) :unresolved-conclusion-reference)
               "unresolved CONCLUSION reference → code is EXACTLY :UNRESOLVED-CONCLUSION-REFERENCE")
        (check (= 0 count)
               "…and the DERIVE/2 invocation counter reads EXACTLY 0")))
    ;; NC-7
    (let ((context (seal (+receiver (+conclusion (+schema (ctx) (wrapper))
                                                 (np '(:predicate :volume-reshelved
                                                       (:volume "PLUT-7"))))
                                    (desk witnesses))
                         "no-support")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit "unresolved-support" petition context)
        (declare (ignore outcome))
        (check (eq (code-of refusal) :unresolved-support-reference)
               "NC-7: unresolved SUPPORT reference → code is EXACTLY :UNRESOLVED-SUPPORT-REFERENCE")
        (check (= 0 count)
               "NC-7: …and the DERIVE/2 invocation counter reads EXACTLY 0")))
    ;; NC-8
    (let ((context (seal (+support (+conclusion (+schema (ctx) (wrapper))
                                                (np '(:predicate :volume-reshelved
                                                      (:volume "PLUT-7"))))
                                   (first witnesses) "w1")
                         "no-receiver")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit "unresolved-receiver" petition context)
        (declare (ignore outcome))
        (check (eq (code-of refusal) :unresolved-receiver-reference)
               "NC-8: unresolved RECEIVER reference → code is EXACTLY :UNRESOLVED-RECEIVER-REFERENCE")
        (check (= 0 count)
               "NC-8: …and the DERIVE/2 invocation counter reads EXACTLY 0")))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; F.  NC-28 — THE COUNTER TOOTH, WITH ITS POSITIVE CONTROL
;;; ══════════════════════════════════════════════════════════════════════════

(section "F. NC-28 — Door 1 under an invocation counter (with the positive control)")

(defun nc28-door-1-count ()
  "Steps 1-3: propose, validate, materialize under the counting shim.
Returns the DERIVE/2 invocation count.  The honest answer is 0."
  (install-derive-counter)
  (unwind-protect
       (progn (multiple-value-bind (datum proposed validated petition receipt)
                  (build :tag "nc28")
                (declare (ignore datum proposed validated petition receipt)))
              *derive-calls*)
    (restore-derive)))

(defparameter *nc28-door-1* (nc28-door-1-count))

(check (= 0 *nc28-door-1*)
       "NC-28 step 3: Door 1 (PROPOSE → VALIDATE → MATERIALIZE) leaves the DERIVE/2 counter at EXACTLY 0")

;; STEP 5 — the positive control.  Without it, step 3 measures a counter that
;; may simply be incapable of incrementing.
(multiple-value-bind (datum proposed validated petition) (build :tag "nc28-positive")
  (declare (ignore datum proposed validated))
  (let ((context (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "nc28")))
    (multiple-value-bind (outcome refusal count)
        (counted-submit "nc28-positive-control" petition context)
      (check (and (= 1 count) outcome (null refusal))
             "NC-28 step 5 POSITIVE CONTROL: Door 2 on the SAME instrument drives the counter to EXACTLY 1")
      (desk-note "counter readings — Door 1: ~D · Door 2: ~D · outcome ~S"
                 *nc28-door-1* count (and outcome (f1:petition-submission-outcome-kind outcome))))))

(check (and (= 0 *nc28-door-1*)
            (fboundp 's2:derive/2)
            (eq (fdefinition 's2:derive/2) *real-derive*))
       "NC-28 hygiene: the real DERIVE/2 fdefinition is restored after every shimmed run")

;;; ══════════════════════════════════════════════════════════════════════════
;;; G.  THE THREE CLASSIFIED OUTCOMES, AND THE POLICY v2 REGRESSION
;;; ══════════════════════════════════════════════════════════════════════════

(section "G. The three classified outcomes")

(defparameter *granted* nil)
(defparameter *governed* nil)
(defparameter *door* nil)

;; :GRANTED
(multiple-value-bind (datum proposed validated petition receipt) (build :tag "granted")
  (declare (ignore datum receipt))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "granted")))
    (multiple-value-bind (outcome refusal count arguments)
        (counted-submit ":granted" petition context)
      (setf *granted* (list :outcome outcome :petition petition :context context
                           :proposed proposed :validated validated :witnesses witnesses))
      (check (and (null refusal) (eq :granted (f1:petition-submission-outcome-kind outcome)))
             ":GRANTED fixture: outcome kind is EXACTLY :GRANTED and no Form /1 refusal was returned")
      (check (= 1 count)
             ":GRANTED fixture: DERIVE/2 invoked EXACTLY once")
      (check (and (f1:petition-submission-outcome-claim outcome)
                  (f1:petition-submission-outcome-slice2-receipt outcome))
             ":GRANTED fixture: the outcome carries the Slice /2 claim AND the Slice /2 receipt")
      ;; NC-10's instrument, proved live on the granting arm first.
      (check (equal (getf arguments :supports) witnesses)
             ":GRANTED fixture: DERIVE/2 received the resolved supports EQ-identical and in order (nothing filtered)"))))

;; :GOVERNED-REFUSAL — NC-10: right species, right mode, right kind, WRONG SUBJECT
(defun nc10-holds-p ()
  "The honest NC-10 behaviour, as ONE predicate, so the live tooth and the PF-2
run execute the identical claim.  A pre-filter would still produce
:GOVERNED-REFUSAL — so `derive/2 was invoked' is not enough, and the argument
capture is what makes this tooth able to kill PF-2."
  (multiple-value-bind (datum proposed validated petition) (build :tag "governed")
    (declare (ignore datum proposed validated))
    (let* ((wrong (list (scan-witness "WRONG-SUBJECT")))
           (context (full-context '("w1") wrong (wrapper) "governed")))
      (multiple-value-bind (outcome refusal count arguments)
          (counted-submit ":governed-refusal" petition context)
        (and (null refusal)
             (= 1 count)
             (eq :governed-refusal (f1:petition-submission-outcome-kind outcome))
             (null (f1:petition-submission-outcome-claim outcome))
             (null (f1:petition-submission-outcome-derivation-basis outcome))
             (f1:petition-submission-outcome-slice2-receipt outcome)
             (f1:petition-submission-receipt-p (f1:petition-submission-outcome-receipt outcome))
             ;; the load-bearing half: the supports reached DERIVE/2 UNFILTERED
             (equal (getf arguments :supports) wrong)
             (progn (setf *governed* outcome) t))))))

(check (nc10-holds-p)
       "NC-10: wrong-subject support resolves, reaches DERIVE/2 exactly once UNFILTERED, and yields :GOVERNED-REFUSAL with claim NIL, basis NIL, a Slice /2 receipt and a Form /1 submission receipt")

;; NC-19, read off the same outcome
(check (and *governed*
            (null (f1:petition-submission-outcome-claim *governed*))
            (null (f1:petition-submission-outcome-derivation-basis *governed*)))
       "NC-19: before a grant, NO claim and NO derivation basis exist anywhere in the outcome")

;; :DOOR-REFUSAL — NC-9: same key, different anatomy; DERIVE/2's own EQ gate
(multiple-value-bind (datum proposed validated petition) (build :tag "door")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (stale (wrapper)))
    (install-schema :volume-scanned-elsewhere)      ; same key, different premise
    (let ((context (full-context '("w1") witnesses stale "door")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit ":door-refusal" petition context)
        (setf *door* outcome)
        (check (and (null refusal) (eq :door-refusal (f1:petition-submission-outcome-kind outcome)))
               "NC-9: a STALE Slice /2 schema wrapper → outcome kind is EXACTLY :DOOR-REFUSAL")
        (check (= 1 count)
               "NC-9: …DERIVE/2 was invoked EXACTLY once — the refusal is ITS door, not a Form /1 copy of its rule")
        (check (null (f1:petition-submission-receipt-slice2-receipt-identity-datum
                      (f1:petition-submission-outcome-receipt outcome)))
               "NC-9: …and the receipt's Slice /2 identity datum is NIL — no Slice /2 receipt exists on this path")))
    (install-schema)))

;; NC-36 — receiver bound to NIL is a DIFFERENT FACT from unresolved
(multiple-value-bind (datum proposed validated petition) (build :tag "nil-receiver")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "nil-receiver" :receiver nil)))
    (multiple-value-bind (outcome refusal count)
        (counted-submit "nc36-nil-receiver" petition context)
      (check (and (null refusal) (= 1 count) (f1:petition-submission-outcome-p outcome))
             "NC-36: a receiver bound to NIL is FOUND — DERIVE/2 IS invoked (count EXACTLY 1) and a classified outcome exists")
      (check (eq :governed-refusal (f1:petition-submission-outcome-kind outcome))
             "NC-36: …and the outcome is whatever the CONTRACT makes it — here :GOVERNED-REFUSAL (accessibility :REQUIRED)")
      (desk-note "unresolved receiver → refusal before invocation; NIL receiver → invocation and a governed outcome"))))

;; NC-35 — ROLE CONFUSION
(defun nc35-holds-p ()
  "A value bound through the SUPPORT binder under host key `r' must not satisfy
the RECEIVER reference with the same host key."
  (multiple-value-bind (datum proposed validated petition) (build :tag "role-confusion")
    (declare (ignore datum proposed validated))
    (let* ((witnesses (list (scan-witness "PLUT-7")))
           (context (seal (+support (+support (+conclusion (+schema (ctx) (wrapper))
                                                           (np '(:predicate :volume-reshelved
                                                                 (:volume "PLUT-7"))))
                                              (first witnesses) "w1")
                                    (desk witnesses) "r")   ; the receiver, in the SUPPORT table
                          "role-confusion")))
      (multiple-value-bind (outcome refusal count)
          (counted-submit "nc35-role-confusion" petition context)
        (declare (ignore outcome))
        (and refusal
             (eq (code-of refusal) :unresolved-receiver-reference)
             (= 0 count))))))

(check (nc35-holds-p)
       "NC-35: a receiver object bound through the SUPPORT binder under key `r' does NOT satisfy (RECEIVER-REFERENCE \"r\") → EXACTLY :UNRESOLVED-RECEIVER-REFERENCE, counter EXACTLY 0")

(check (not (cd0:equal-datum (f1:support-reference "r") (f1:receiver-reference "r")))
       "NC-35 structural half: (SUPPORT-REFERENCE \"r\") and (RECEIVER-REFERENCE \"r\") are NOT EQUAL-DATUM — the role is in the identifier")

(check (and (eq :support (f1:reference-role (f1:support-reference "r")))
            (eq :receiver (f1:reference-role (f1:receiver-reference "r")))
            (eq :schema (f1:reference-role (f1:schema-reference "r")))
            (eq :conclusion (f1:reference-role (f1:conclusion-reference "r")))
            (null (f1:reference-role (cd0:make-string-datum "r")))
            (null (f1:reference-role 42)))
       "REFERENCE-ROLE returns the exact role for each of the four constructors and NIL for a non-reference")

;;; ---- THE POLICY v2 REGRESSION -------------------------------------------

(section "G'. THE POLICY v2 REGRESSION — the permanent gravestone of policy v1")

(defun log-entry-honours-v2-p (entry)
  "invocations = 1  ⇒  a PETITION-SUBMISSION-OUTCOME and a PETITION-SUBMISSION-
RECEIPT both exist, and NO Form /1 policy refusal was returned.  Policy v1 could
reach a state where the governed act had happened and a terminal ceiling then
erased it; that state must not exist."
  (or (/= 1 (getf entry :count))
      (let ((outcome (getf entry :outcome)))
        (and (null (getf entry :refusal))
             (f1:petition-submission-outcome-p outcome)
             (f1:petition-submission-receipt-p
              (f1:petition-submission-outcome-receipt outcome))))))

(defparameter *invoked-entries*
  (remove-if-not (lambda (entry) (= 1 (getf entry :count))) *submission-log*))

(check (>= (length *invoked-entries*) 5)
       (format nil "GRAVESTONE PRECONDITION: at least 5 logged submissions actually reached DERIVE/2 (~D of ~D did) — an implication over an empty set proves nothing"
               (length *invoked-entries*) (length *submission-log*)))

(check (every #'log-entry-honours-v2-p *submission-log*)
       (format nil "POLICY v2 GRAVESTONE: across ALL ~D logged submissions, invocations=1 ⇒ an OUTCOME and a RECEIPT both exist; there is NO state with invocations=1 and a Form /1 policy refusal"
               (length *submission-log*)))

(check (notany (lambda (entry) (and (= 1 (getf entry :count)) (getf entry :refusal)))
               *submission-log*)
       "…stated the other way round: NO logged submission has invocations=1 AND a returned refusal")

(check (every (lambda (entry) (or (/= 0 (getf entry :count)) (null (getf entry :outcome))))
              *submission-log*)
       "…and its mirror: every submission with invocations=0 produced NO outcome object at all")

(desk-note "submission log: ~D entries · ~D reached DERIVE/2 · ~D refused before invocation"
           (length *submission-log*) (length *invoked-entries*)
           (- (length *submission-log*) (length *invoked-entries*)))

;;; ══════════════════════════════════════════════════════════════════════════
;;; H.  IDENTITY TEETH
;;; ══════════════════════════════════════════════════════════════════════════

(section "H. Identities are CD/0 BYTES DATA — compared with EQUAL-DATUM, never STRING=")

(multiple-value-bind (datum proposed validated petition materialization) (build :tag "identity")
  (declare (ignore datum))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "identity")))
    (multiple-value-bind (outcome refusal) (counted-submit "identity-genealogy" petition context)
      (declare (ignore refusal))
      (let* ((receipt (f1:petition-submission-outcome-receipt outcome))
             (chain (genealogy proposed validated petition receipt))
             (all (append chain
                          (list (f1:validated-petition-form-predecessor-identity validated)
                                (f1:petition-validation-receipt-identity
                                 (f1:validated-petition-form-receipt validated))
                                (f1:petition-materialization-receipt-identity materialization)
                                (f1:petition-refusal-identity
                                 (nth-value 1 (f1:try-propose-petition 42)))))))
        (check (every #'cd0:bytes-datum-p all)
               (format nil "all ~D identities in reach (7 phase + predecessor + validation receipt + materialization receipt + refusal) are CD0:BYTES-DATUM-P" (length all)))
        (check (notany #'stringp all)
               "NO identity is a Common Lisp string — hex is produced only by RENDER-IDENTITY-HEX and never stored")
        (check (= 7 (length chain))
               "the genealogy of one submitted petition has EXACTLY 7 identities: subject, proposed, validated, content, petition-occurrence, submission-occurrence, submission-receipt")
        (check (pairwise-distinct-p chain)
               "…and those 7 are PAIRWISE DISTINCT under EQUAL-DATUM (21 comparisons)")
        (check (every (lambda (identity)
                        (= (length (f1:render-identity-hex identity))
                           (* 2 (f1:identity-octets identity))))
                      chain)
               "RENDER-IDENTITY-HEX is DIAGNOSTIC: its length is EXACTLY 2 × (IDENTITY-OCTETS identity) for all 7")
        (check (let ((rendered (mapcar #'f1:render-identity-hex chain)))
                 (= 7 (length (remove-duplicates rendered :test #'string=))))
               "NC-22: the 7 hex renderings are pairwise distinct as whole strings (no abbreviation is compared)")
        (check (cd0:equal-datum (f1:petition-submission-receipt-petition-occurrence-identity receipt)
                                (f1:derivation-petition-occurrence-identity petition))
               "the submission receipt's PETITION-OCCURRENCE-IDENTITY EQUAL-DATUMs the petition's own")
        (check (not (cd0:equal-datum (f1:petition-submission-receipt-occurrence-identity receipt)
                                     (f1:petition-submission-receipt-identity receipt)))
               "§9.3: the SUBMISSION OCCURRENCE identity and the SUBMISSION RECEIPT identity are DIFFERENT — the act and its later account are different facts")))))

;; consequential ancestry — one changed support key must move every descendant
(multiple-value-bind (d1 p1 v1 pet1) (build :supports '("w1") :tag "ancestry")
  (declare (ignore d1))
  (multiple-value-bind (d2 p2 v2 pet2) (build :supports '("w2") :tag "ancestry")
    (declare (ignore d2))
    (check (and (not (cd0:equal-datum (f1:proposed-petition-form-subject-identity p1)
                                      (f1:proposed-petition-form-subject-identity p2)))
                (not (cd0:equal-datum (f1:proposed-petition-form-identity p1)
                                      (f1:proposed-petition-form-identity p2)))
                (not (cd0:equal-datum (f1:validated-petition-form-identity v1)
                                      (f1:validated-petition-form-identity v2)))
                (not (cd0:equal-datum (f1:derivation-petition-content-identity pet1)
                                      (f1:derivation-petition-content-identity pet2)))
                (not (cd0:equal-datum (f1:derivation-petition-occurrence-identity pet1)
                                      (f1:derivation-petition-occurrence-identity pet2))))
           "CONSEQUENTIAL ANCESTRY: one changed support key (\"w1\"→\"w2\") changes ALL FIVE descendant identities — subject, proposed, validated, content, occurrence")
    ;; and the submission occurrence too, under an otherwise identical submission
    (let ((c1 (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "anc"))
          (c2 (full-context '("w2") (list (scan-witness "PLUT-7")) (wrapper) "anc")))
      (multiple-value-bind (o1) (counted-submit "ancestry-1" pet1 c1)
        (multiple-value-bind (o2) (counted-submit "ancestry-2" pet2 c2)
          (check (not (cd0:equal-datum
                       (f1:petition-submission-receipt-occurrence-identity
                        (f1:petition-submission-outcome-receipt o1))
                       (f1:petition-submission-receipt-occurrence-identity
                        (f1:petition-submission-outcome-receipt o2))))
                 "…and the SUBMISSION OCCURRENCE identity moves with them, under an otherwise identical submission"))))))

;; NC-25 / NC-26 — the occurrence tag, and the limitation Form /1 does NOT hide
(multiple-value-bind (datum proposed validated) (build :tag "tags")
  (declare (ignore datum proposed))
  (let ((a (f1:materialize-petition validated (idd '("form1-selftest") '("occ" "alpha"))))
        (b (f1:materialize-petition validated (idd '("form1-selftest") '("occ" "beta"))))
        (c (f1:materialize-petition validated (idd '("form1-selftest") '("occ" "alpha")))))
    (check (not (cd0:equal-datum (f1:derivation-petition-occurrence-identity a)
                                 (f1:derivation-petition-occurrence-identity b)))
           "NC-25: same content, DIFFERENT occurrence tag → DIFFERENT occurrence identities")
    (check (cd0:equal-datum (f1:derivation-petition-content-identity a)
                            (f1:derivation-petition-content-identity b))
           "NC-25: …while the CONTENT identity is unchanged — the tag enters at exactly one link")
    (check (cd0:equal-datum (f1:derivation-petition-occurrence-identity a)
                            (f1:derivation-petition-occurrence-identity c))
           "NC-26: same content, SAME occurrence tag → IDENTICAL identities. DOCUMENTED UNDETECTED HOST ERROR — Form /1 makes no global exactly-once claim")))

(section "H'. The identity envelope, measured on the largest lawful petition")

;; The three classified outcomes again, on a 16-long-key petition near the
;; petition octet ceiling — the measurement the envelope reserve must survive.
(let* ((long-keys (loop for i from 1 to 16
                        collect (concatenate 'string
                                             (make-string 900 :initial-element #\k)
                                             (format nil "~D" i))))
       (tails '())
       (terminals '()))
  (multiple-value-bind (datum proposed validated petition) (build :supports long-keys :tag "max")
    (declare (ignore datum proposed))
    (check (<= (f1:identity-octets (f1:validated-petition-form-identity validated))
               (f1:petition-policy-max-identity-octets))
           "the max-policy petition's VALIDATED identity fits the envelope")
    (let ((witnesses (cons (scan-witness "PLUT-7")
                           (loop for i from 2 to 16
                                 collect (scan-witness (format nil "OTHER-~D" i))))))
      (flet ((measure (label context)
               (multiple-value-bind (outcome refusal) (counted-submit label petition context)
                 (when refusal (return-from measure nil))
                 (let* ((receipt (f1:petition-submission-outcome-receipt outcome))
                        (occurrence (f1:identity-octets
                                     (f1:petition-submission-receipt-occurrence-identity receipt)))
                        (terminal (f1:identity-octets
                                   (f1:petition-submission-receipt-identity receipt))))
                   (push (cons label (- terminal occurrence)) tails)
                   (push (cons label terminal) terminals)
                   (list (f1:petition-submission-outcome-kind outcome) (- terminal occurrence) terminal)))))
        (let ((granted (measure "max:granted" (full-context long-keys witnesses (wrapper) "max-granted")))
              (governed (measure "max:governed"
                                 (full-context long-keys
                                               (loop for i from 1 to 16
                                                     collect (scan-witness (format nil "WRONG-~D" i)))
                                               (wrapper) "max-governed")))
              (door (let ((stale (wrapper)))
                      (install-schema :volume-scanned-elsewhere)
                      (prog1 (measure "max:door" (full-context long-keys witnesses stale "max-door"))
                        (install-schema)))))
          (check (and granted governed door
                      (eq :granted (first granted))
                      (eq :governed-refusal (first governed))
                      (eq :door-refusal (first door)))
                 "ENVELOPE FIXTURE: all THREE classified outcome kinds reached on the 16-long-key petition")
          (dolist (row (reverse tails))
            (desk-note "outcome tail ~14A ~6D octets (reserve ~D)"
                       (car row) (cdr row) (f1:petition-policy-outcome-tail-reserve-octets)))
          (check (every (lambda (row) (<= (cdr row) (f1:petition-policy-outcome-tail-reserve-octets)))
                        tails)
                 (format nil "the measured outcome tail (receipt octets − submission-occurrence octets) is ≤ ~D for ALL THREE classified outcome kinds"
                         (f1:petition-policy-outcome-tail-reserve-octets)))
          (check (every (lambda (row) (<= (cdr row) (f1:petition-policy-max-identity-octets)))
                        terminals)
                 (format nil "the maximum terminal identity (~D octets) fits (PETITION-POLICY-MAX-IDENTITY-OCTETS) = ~D"
                         (reduce #'max (mapcar #'cdr terminals) :initial-value 0)
                         (f1:petition-policy-max-identity-octets))))))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; I.  READER ALIASING — mutate WHAT THE READER HANDED BACK
;;; ══════════════════════════════════════════════════════════════════════════

(section "I. Reader aliasing (§7 of the ruling; the de-pignore Review 2 lesson)")

;; (1) DERIVATION-PETITION-SUPPORT-REFERENCES — a list
(defun nc20-support-references-safe-p ()
  "Mutate the list the READER returned; the stored value, the identities and the
subsequent protocol behaviour must all be unchanged.

A CONDITION HERE IS A FAILURE, NOT AN ERROR TO PROPAGATE.  When the reader
aliases (PF-4), the caller's mutation lands in the stored slot and the very next
attempt to recompute the petition's canonical fingerprint drives CD/0 to refuse
a keyword where a datum belongs.  That is the aliasing being caught — so it must
be REPORTED as `not safe' rather than thrown, or the tooth kills the run instead
of failing it.  The honest path signals nothing, so this handler hides nothing."
  (handler-case
      (multiple-value-bind (datum proposed validated petition)
          (build :supports '("w1") :tag "alias")
        (declare (ignore datum proposed validated))
        (let* ((before (petition-fingerprint petition))
               (handed-back (f1:derivation-petition-support-references petition)))
          (setf (car handed-back) :mutated-by-the-caller)
          (setf (cdr handed-back) (list :and-extended))
          (let ((after (f1:derivation-petition-support-references petition)))
            (and (string= before (petition-fingerprint petition))
                 (= 1 (length after))
                 (cd0:datum-p (first after))
                 (cd0:equal-datum (first after) (f1:support-reference "w1"))
                 ;; protocol behaviour: it still resolves and still reaches DERIVE/2
                 (let* ((witnesses (list (scan-witness "PLUT-7")))
                        (context (full-context '("w1") witnesses (wrapper) "alias")))
                   (multiple-value-bind (outcome refusal count)
                       (counted-submit "alias-support-refs" petition context)
                     (and (null refusal) (= 1 count)
                          (eq :granted (f1:petition-submission-outcome-kind outcome)))))))))
    (condition () nil)))

(check (nc20-support-references-safe-p)
       "NC-20 (a): mutating the LIST returned by DERIVATION-PETITION-SUPPORT-REFERENCES leaves the stored refs, the petition fingerprint and a later GRANTED submission unchanged")

;; (2) DERIVATION-RESOLUTION-CONTEXT-DECLARATIONS — a list of immutable records
(let* ((context (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "alias-ctx"))
       (handed-back (f1:derivation-resolution-context-declarations context))
       (count-before (length handed-back))
       (declaration-identity-before
         (f1:derivation-resolution-context-declaration-identity context)))
  (setf (car handed-back) :mutated-outer)
  (setf (cdr (last handed-back)) (list :fabricated-declaration))
  (let ((after (f1:derivation-resolution-context-declarations context)))
    (check (and (= count-before (length after))
                (every (lambda (entry)
                         (and (f1:context-binding-declaration-p entry)
                              (member (f1:context-binding-declaration-role entry)
                                      '(:schema :conclusion :support :receiver))
                              (cd0:datum-p (f1:context-binding-declaration-reference entry))
                              (cd0:datum-p (f1:context-binding-declaration-denotation entry))))
                       after)
                (cd0:equal-datum declaration-identity-before
                                 (f1:derivation-resolution-context-declaration-identity context)))
           "NC-20 (b): mutating BOTH the outer list AND splicing a fabricated entry onto the tail of CONTEXT-DECLARATIONS leaves the mapping, the record species and the DECLARATION IDENTITY intact")))

;; (2b) DERIVATION-RESOLUTION-CONTEXT-LIVE-ANCHOR — the one reader that DOES
;;      hand out an image-local object, by design and one at a time.
(let* ((witness (scan-witness "PLUT-7"))
       (context (full-context '("w1") (list witness) (wrapper) "anchor-ctx")))
  (multiple-value-bind (anchor found)
      (f1:derivation-resolution-context-live-anchor context :support (f1:support-reference "w1"))
    (check (and found (eq anchor witness))
           "LIVE-ANCHOR returns the EXACT image-local object (EQ), which is what an anchor is — and it is reachable ONLY by an exact role/reference lookup, never as an aggregate"))
  (multiple-value-bind (anchor found)
      (f1:derivation-resolution-context-live-anchor context :support (f1:support-reference "absent"))
    (check (and (null found) (null anchor))
           "LIVE-ANCHOR of an unbound reference returns (values NIL NIL) — not-found is a value, not a refusal"))
  ;; A BOUND NIL IS FOUND.  This is the distinction the receiver-absence
  ;; declaration exists to make durable, checked on the anchor side too.
  (let ((absent-receiver (seal (+receiver (ctx) nil "r" (f1:receiver-absence-declaration))
                               "anchor-nil")))
    (multiple-value-bind (anchor found)
        (f1:derivation-resolution-context-live-anchor absent-receiver :receiver
                                                      (f1:receiver-reference "r"))
      (check (and found (null anchor))
             "LIVE-ANCHOR of a receiver BOUND TO NIL returns (values NIL T) — a bound NIL is FOUND, and is a different fact from unbound"))))

;; (3) PETITION-REFUSAL-PATH — a list
(let* ((refusal (nth-value 1 (f1:try-propose-petition
                              (f1:petition-datum :schema (f1:conclusion-reference "c")
                                                 :conclusion (f1:conclusion-reference "c")
                                                 :supports '()
                                                 :receiver (f1:receiver-reference "r")))))
       (handed-back (f1:petition-refusal-path refusal)))
  (check (equal handed-back '(1 :schema)) "PETITION-REFUSAL-PATH returns the exact path (1 :SCHEMA)")
  (setf (car handed-back) :mutated)
  (setf (cdr handed-back) nil)
  (check (equal (f1:petition-refusal-path refusal) '(1 :schema))
         "NC-20 (c): mutating the LIST returned by PETITION-REFUSAL-PATH leaves the stored path (1 :SCHEMA) unchanged"))

;; (4) PETITION-REFUSAL-DETAIL and (5) PETITION-REFUSAL-HOST-TYPE — STRINGS,
;;     which Common Lisp makes mutable.
(let* ((refusal (nth-value 1 (f1:try-validate-petition :not-a-form)))
       (detail (f1:petition-refusal-detail refusal))
       (host-type (f1:petition-refusal-host-type refusal))
       (detail-before (copy-seq detail))
       (host-before (copy-seq host-type)))
  (check (and (plusp (length detail)) (plusp (length host-type)))
         "the :NOT-A-PROPOSED-PETITION-FORM refusal carries a non-empty DETAIL and HOST-TYPE")
  (fill detail #\Z)
  (fill host-type #\Z)
  (check (string= (f1:petition-refusal-detail refusal) detail-before)
         "NC-20 (d): FILLing the STRING returned by PETITION-REFUSAL-DETAIL with #\\Z leaves the stored detail unchanged")
  (check (string= (f1:petition-refusal-host-type refusal) host-before)
         "NC-20 (e): FILLing the STRING returned by PETITION-REFUSAL-HOST-TYPE with #\\Z leaves the stored host type unchanged")
  (check (string= host-before "COMMON-LISP:KEYWORD")
         "…and that host type is the BOUNDED descriptor \"COMMON-LISP:KEYWORD\", not PRIN1-TO-STRING output"))

;; (6) PETITION-SUBMISSION-RECEIPT-SLICE2-CONDITION-CLASS — a string
(let* ((receipt (f1:petition-submission-outcome-receipt *governed*))
       (handed-back (f1:petition-submission-receipt-slice2-condition-class receipt))
       (before (copy-seq handed-back)))
  (check (string= before "LISP-PLUS-SLICE2:SLICE2-DERIVATION-REFUSED")
         "the governed-refusal receipt's SLICE2-CONDITION-CLASS is EXACTLY \"LISP-PLUS-SLICE2:SLICE2-DERIVATION-REFUSED\"")
  (fill handed-back #\Z)
  (check (string= (f1:petition-submission-receipt-slice2-condition-class receipt) before)
         "NC-20 (f): FILLing the STRING returned by SLICE2-CONDITION-CLASS leaves the stored class unchanged"))

;; (7) THE THREE CODE-CATALOGUE READERS — two lists and a list of records
(let* ((handed-back (f1:petition-protocol-refusal-codes))
       (before (copy-list handed-back)))
  (setf (car handed-back) :mutated)
  (setf (cdr (last handed-back)) (list :fabricated-code))
  (check (equal (f1:petition-protocol-refusal-codes) before)
         "NC-20 (g): mutating the LIST returned by PETITION-PROTOCOL-REFUSAL-CODES (car AND a spliced tail) leaves the declared set unchanged"))

(let* ((handed-back (f1:petition-integrity-alarm-codes))
       (before (copy-list handed-back)))
  (setf (car handed-back) :mutated)
  (check (equal (f1:petition-integrity-alarm-codes) before)
         "NC-20 (g2): the same for PETITION-INTEGRITY-ALARM-CODES"))

(let* ((handed-back (f1:petition-refusal-code-catalog))
       (first-entry (first handed-back))
       (note (f1:petition-refusal-code-entry-note first-entry))
       (note-before (copy-seq note)))
  (setf (car handed-back) :mutated)
  (fill note #\Z)
  (let ((after (f1:petition-refusal-code-catalog)))
    (check (and (every #'f1:petition-refusal-code-entry-p after)
                (string= (f1:petition-refusal-code-entry-note (first after)) note-before))
           "NC-20 (g3): mutating the catalogue list AND filling an entry's NOTE string leaves the catalogue intact — every entry is a fresh record over a fresh string")))

;; (8) the budget-id readers — strings
(multiple-value-bind (datum proposed validated) (build :tag "budget")
  (declare (ignore datum proposed))
  (let* ((from-form (f1:validated-petition-form-budget-id validated))
         (from-receipt (f1:petition-validation-receipt-budget-id
                        (f1:validated-petition-form-receipt validated)))
         (before (copy-seq from-form)))
    (check (and (string= from-form from-receipt) (string= before "cd0-conformance-default"))
           "both budget-id readers return EXACTLY \"cd0-conformance-default\"")
    (fill from-form #\Z)
    (fill from-receipt #\Z)
    (check (and (string= (f1:validated-petition-form-budget-id validated) before)
                (string= (f1:petition-validation-receipt-budget-id
                          (f1:validated-petition-form-receipt validated))
                         before))
           "NC-20 (h): FILLing the STRINGS returned by VALIDATED-PETITION-FORM-BUDGET-ID and PETITION-VALIDATION-RECEIPT-BUDGET-ID leaves both stored ids unchanged")))

;; The two readers that DELIBERATELY hand out the exact object — pinned so a
;; later "fix" cannot quietly change a documented contract into a copy.
(let* ((witnesses (list (scan-witness "PLUT-7")))
       (principal (list :the-exact-live-by-value)))
  (multiple-value-bind (datum proposed validated petition) (build :tag "anchors")
    (declare (ignore datum proposed validated))
    (let ((context (full-context '("w1") witnesses (wrapper) "anchors")))
      (multiple-value-bind (outcome refusal) (counted-submit "anchors" petition context :by principal)
        (declare (ignore refusal))
        (let ((receipt (f1:petition-submission-outcome-receipt outcome)))
          (check (and (eq (f1:petition-submission-receipt-by receipt) principal)
                      (eq (f1:petition-submission-receipt-context receipt) context))
                 "DOCUMENTED IMAGE-LOCAL ANCHORS: RECEIPT-BY and RECEIPT-CONTEXT return the EXACT objects (EQ) — a contract, not an aliasing defect (no public writer exists)"))))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; J.  TRY-* ARITY
;;; ══════════════════════════════════════════════════════════════════════════

(section "J. The TRY- twins — arity, and the receipt the twin hands back")

(check (let ((values (multiple-value-list (f1:try-propose-petition (petition-tree)))))
         (and (= 2 (length values))
              (f1:proposed-petition-form-p (first values))
              (null (second values))))
       "TRY-PROPOSE-PETITION success returns EXACTLY 2 values: (PROPOSED, NIL)")

(check (let ((values (multiple-value-list (f1:try-propose-petition 42))))
         (and (= 2 (length values))
              (null (first values))
              (f1:petition-refusal-p (second values))))
       "TRY-PROPOSE-PETITION refusal returns EXACTLY 2 values: (NIL, REFUSAL)")

(check (let ((values (multiple-value-list
                      (f1:try-validate-petition (f1:propose-petition (petition-tree))))))
         (and (= 2 (length values))
              (f1:validated-petition-form-p (first values))
              (null (second values))))
       "TRY-VALIDATE-PETITION success returns EXACTLY 2 values: (VALIDATED, NIL)")

(check (let ((values (multiple-value-list (f1:try-validate-petition :nope))))
         (and (= 2 (length values)) (null (first values)) (f1:petition-refusal-p (second values))))
       "TRY-VALIDATE-PETITION refusal returns EXACTLY 2 values: (NIL, REFUSAL)")

(multiple-value-bind (datum proposed validated) (build :tag "arity")
  (declare (ignore datum proposed))
  (check (let ((values (multiple-value-list
                        (f1:try-materialize-petition
                         validated (idd '("form1-selftest") '("occ" "arity"))))))
           (and (= 3 (length values))
                (f1:derivation-petition-p (first values))
                (f1:petition-materialization-receipt-p (second values))
                (null (third values))))
         "TRY-MATERIALIZE-PETITION success returns EXACTLY 3 values: (PETITION, MATERIALIZATION-RECEIPT, NIL)")
  (check (let ((values (multiple-value-list (f1:try-materialize-petition validated :nope))))
           (and (= 3 (length values)) (null (first values)) (null (second values))
                (f1:petition-refusal-p (third values))))
         "TRY-MATERIALIZE-PETITION refusal returns EXACTLY 3 values: (NIL, NIL, REFUSAL)")

  ;; THE DELEGATION TOOTH.
  ;;
  ;; The claim worth testing is "the twin hands back the very object the loud
  ;; operation produced" — not "two separate calls return EQ objects", which is
  ;; FALSE and unachievable: MATERIALIZE-PETITION freshly allocates a receipt
  ;; struct on every call, so two calls yield two distinct objects with
  ;; EQUAL-DATUM identities (asserted below, so the distinction is on the
  ;; record).  The delegation is proved by shimming the loud operation to return
  ;; sentinels and reading what the twin returns.
  (let ((real (fdefinition 'f1:materialize-petition))
        (sentinel-petition (list :sentinel-petition))
        (sentinel-receipt (list :sentinel-receipt)))
    (unwind-protect
         (progn
           (setf (fdefinition 'f1:materialize-petition)
                 (lambda (validated tag)
                   (declare (ignore validated tag))
                   (values sentinel-petition sentinel-receipt)))
           (multiple-value-bind (petition receipt refusal)
               (f1:try-materialize-petition validated (idd '("form1-selftest") '("occ" "eq")))
             (check (and (eq petition sentinel-petition)
                         (eq receipt sentinel-receipt)
                         (null refusal))
                    "TRY-MATERIALIZE-PETITION returns the EXACT (EQ) petition and receipt objects MATERIALIZE-PETITION produced — it delegates, it does not rebuild")))
      (setf (fdefinition 'f1:materialize-petition) real)))

  (let ((tag (idd '("form1-selftest") '("occ" "twice"))))
    (multiple-value-bind (loud-petition loud-receipt) (f1:materialize-petition validated tag)
      (multiple-value-bind (try-petition try-receipt) (f1:try-materialize-petition validated tag)
        (check (and (not (eq loud-receipt try-receipt))
                    (not (eq loud-petition try-petition))
                    (cd0:equal-datum (f1:petition-materialization-receipt-identity loud-receipt)
                                     (f1:petition-materialization-receipt-identity try-receipt))
                    (cd0:equal-datum (f1:derivation-petition-occurrence-identity loud-petition)
                                     (f1:derivation-petition-occurrence-identity try-petition)))
               "…and across TWO SEPARATE calls the objects are NOT EQ (each call allocates) while their identities ARE EQUAL-DATUM — content identity, not object identity")))))

(multiple-value-bind (datum proposed validated petition) (build :tag "arity-submit")
  (declare (ignore datum proposed validated))
  (let ((context (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "arity-submit")))
    (check (let ((values (multiple-value-list
                          (f1:try-submit-petition petition context :by :clerk
                                                  :by-id (idd '("form1-selftest") '("by" "1"))
                                                  :act-id (idd '("form1-selftest") '("act" "1"))))))
             (and (= 2 (length values))
                  (f1:petition-submission-outcome-p (first values))
                  (null (second values))))
           "TRY-SUBMIT-PETITION success returns EXACTLY 2 values: (OUTCOME, NIL)")
    (check (let ((values (multiple-value-list
                          (f1:try-submit-petition petition context :by nil
                                                  :by-id (idd '("form1-selftest") '("by" "1"))
                                                  :act-id (idd '("form1-selftest") '("act" "1"))))))
             (and (= 2 (length values)) (null (first values)) (f1:petition-refusal-p (second values))))
           "TRY-SUBMIT-PETITION refusal returns EXACTLY 2 values: (NIL, REFUSAL)")))

;;; ══════════════════════════════════════════════════════════════════════════
;;; K.  THE REMAINING NEGATIVE CONTROLS
;;; ══════════════════════════════════════════════════════════════════════════

(section "K. Negative controls — occurrence, substitution, escape, residue")

;; NC-16 — substitute the context
(multiple-value-bind (datum proposed validated petition) (build :tag "nc16")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context-a (full-context '("w1") witnesses (wrapper) "nc16-a"))
         (context-b (full-context '("w1") witnesses (wrapper) "nc16-b")))
    (multiple-value-bind (a) (counted-submit "nc16-a" petition context-a)
      (multiple-value-bind (b) (counted-submit "nc16-b" petition context-b)
        (check (not (cd0:equal-datum
                     (f1:petition-submission-receipt-occurrence-identity
                      (f1:petition-submission-outcome-receipt a))
                     (f1:petition-submission-receipt-occurrence-identity
                      (f1:petition-submission-outcome-receipt b))))
               "NC-16: substituting the CONTEXT (same petition, same act id) changes the SUBMISSION OCCURRENCE identity")))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; NC-31A and NC-31B — THE SPLIT CONTROL (owner ruling, Review 1 §5)
;;;
;;; UNDER POLICY v2 THERE WAS ONE CONTROL, AND IT WAS TOO COARSE.  It showed two
;;; contexts with the same supplied occurrence id, different live bindings,
;;; identical submission occurrence identities and opposite outcomes — and it
;;; called the whole thing "an undetected host error", which flattened TWO
;;; DIFFERENT FAILURES into one shrug:
;;;
;;;   (A) the context's declared CONTENT was never recorded at all, so two
;;;       contexts declaring DIFFERENT things were indistinguishable.  That is a
;;;       DEFECT OF THIS LAYER.  It is repaired.
;;;
;;;   (B) a host that declares the SAME thing and binds a DIFFERENT live anchor
;;;       is lying, and no in-image record can catch it.  That is a RESIDUAL, and
;;;       it stays.
;;;
;;; The repair of (A) is not licensed by the existence of (B), and the honesty of
;;; documenting (B) never licensed (A).  Two controls, so neither can hide in the
;;; other.

;; ---- NC-31A — DIFFERENT DECLARATIONS -------------------------------------
;; same host occurrence tag · same references · DIFFERENT denotation
;; declarations · DIFFERENT live values.  Everything downstream must separate.
(multiple-value-bind (datum proposed validated petition) (build :tag "nc31a")
  (declare (ignore datum proposed validated))
  (let* ((good (list (scan-witness "PLUT-7")))
         (wrong (list (scan-witness "WRONG-31")))
         (context-a (full-context '("w1") good (wrapper) "nc31-shared"
                                  :support-declarations (list (den "support" "w1" "PLUT-7"))))
         (context-b (full-context '("w1") wrong (wrapper) "nc31-shared"
                                  :support-declarations (list (den "support" "w1" "WRONG-31")))))
    (multiple-value-bind (a) (counted-submit "nc31a-a" petition context-a)
      (multiple-value-bind (b) (counted-submit "nc31a-b" petition context-b)
        (let ((receipt-a (f1:petition-submission-outcome-receipt a))
              (receipt-b (f1:petition-submission-outcome-receipt b)))
          (check (cd0:equal-datum
                  (f1:derivation-resolution-context-occurrence-tag context-a)
                  (f1:derivation-resolution-context-occurrence-tag context-b))
                 "NC-31A setup: the two contexts carry the IDENTICAL host-supplied occurrence TAG — the tag is held fixed on purpose, so the tag cannot be what separates them")
          (check (not (cd0:equal-datum
                       (f1:derivation-resolution-context-declaration-identity context-a)
                       (f1:derivation-resolution-context-declaration-identity context-b)))
                 "NC-31A (1): DIFFERENT context DECLARATION identities — the declaration identity commits to every binding's role, exact reference and exact denotation declaration")
          (check (not (cd0:equal-datum
                       (f1:derivation-resolution-context-occurrence-identity context-a)
                       (f1:derivation-resolution-context-occurrence-identity context-b)))
                 "NC-31A (2): DIFFERENT context OCCURRENCE identities — despite the identical host tag, because the occurrence identity commits to the declaration identity")
          (check (not (cd0:equal-datum
                       (f1:petition-submission-receipt-occurrence-identity receipt-a)
                       (f1:petition-submission-receipt-occurrence-identity receipt-b)))
                 "NC-31A (3): DIFFERENT SUBMISSION OCCURRENCE identities — the v2 defect is gone: two governed acts declaring different things no longer share a durable identity")
          (check (not (eq (f1:petition-submission-outcome-kind a)
                          (f1:petition-submission-outcome-kind b)))
                 "NC-31A: …and the outcomes still differ (:GRANTED vs :GOVERNED-REFUSAL) — the same fixture that used to demonstrate the defect now demonstrates the repair")
          (check (and (cd0:equal-datum
                       (f1:petition-submission-receipt-context-occurrence-identity receipt-a)
                       (f1:derivation-resolution-context-occurrence-identity context-a))
                      (cd0:equal-datum
                       (f1:petition-submission-receipt-context-declaration-identity receipt-a)
                       (f1:derivation-resolution-context-declaration-identity context-a)))
                 "NC-31A (4): the submission receipt binds the EXACT context occurrence identity and the EXACT declaration identity — a reader of the receipt alone can tell A from B"))))))

;; ---- NC-31B — FALSE HOST DECLARATION -------------------------------------
;; same host occurrence tag · same references · SAME denotation declarations ·
;; DIFFERENT live values.  The declared identities MUST stay equal — that is
;; what "the declaration is not certification" means — and the divergence must
;; remain observable through the exact anchors and the exact Slice /2 receipts.
(multiple-value-bind (datum proposed validated petition) (build :tag "nc31b")
  (declare (ignore datum proposed validated))
  (let* ((good (list (scan-witness "PLUT-7")))
         (wrong (list (scan-witness "WRONG-31")))
         ;; ONE declaration, used for BOTH.  The host asserts the same thing
         ;; about two different objects.  Exactly one of those assertions is
         ;; true, and Form /1 cannot tell which.
         (shared-declaration (list (den "support" "w1" "the-scan-of-PLUT-7")))
         (context-a (full-context '("w1") good (wrapper) "nc31-shared"
                                  :support-declarations shared-declaration))
         (context-b (full-context '("w1") wrong (wrapper) "nc31-shared"
                                  :support-declarations shared-declaration)))
    (multiple-value-bind (a) (counted-submit "nc31b-a" petition context-a)
      (multiple-value-bind (b) (counted-submit "nc31b-b" petition context-b)
        (let ((receipt-a (f1:petition-submission-outcome-receipt a))
              (receipt-b (f1:petition-submission-outcome-receipt b)))
          (check (cd0:equal-datum
                  (f1:derivation-resolution-context-declaration-identity context-a)
                  (f1:derivation-resolution-context-declaration-identity context-b))
                 "NC-31B (1): declaration identities remain EQUAL — the two contexts declare the same thing, and the layer records declarations, not truths")
          (check (cd0:equal-datum
                  (f1:derivation-resolution-context-occurrence-identity context-a)
                  (f1:derivation-resolution-context-occurrence-identity context-b))
                 "NC-31B (2): context occurrence identities remain EQUAL")
          (check (cd0:equal-datum
                  (f1:petition-submission-receipt-occurrence-identity receipt-a)
                  (f1:petition-submission-receipt-occurrence-identity receipt-b))
                 "NC-31B (3): submission occurrence identities remain EQUAL — this is NOT the v2 defect, it is the DECLARED RESIDUAL, and it is not repairable in-image")
          (check (not (eq (f1:petition-submission-outcome-kind a)
                          (f1:petition-submission-outcome-kind b)))
                 "NC-31B (4): opposite governed outcomes remain possible under equal declared identities — a false host declaration is not detected by Form /1 and is not claimed to be")
          ;; …AND THE DIVERGENCE IS STILL OBSERVABLE IN-IMAGE.  Not durably, not
          ;; across a crossing — but a reader holding both receipts in the same
          ;; image can see it, through the exact anchors and the exact Slice /2
          ;; receipt identities.  That is the whole of what survives, and it is
          ;; worth stating exactly because it is so much less than certification.
          (let ((anchor-a (f1:derivation-resolution-context-live-anchor
                           (f1:petition-submission-receipt-context receipt-a)
                           :support (f1:support-reference "w1")))
                (anchor-b (f1:derivation-resolution-context-live-anchor
                           (f1:petition-submission-receipt-context receipt-b)
                           :support (f1:support-reference "w1"))))
            (check (not (eq anchor-a anchor-b))
                   "NC-31B (5): the exact CONTEXT ANCHORS reached through the two receipts are DIFFERENT objects — the in-image divergence is observable even though no durable field records it"))
          (check (not (cd0:equal-datum
                       (f1:petition-submission-receipt-slice2-receipt-identity-datum receipt-a)
                       (f1:petition-submission-receipt-slice2-receipt-identity-datum receipt-b)))
                 "NC-31B (6): the exact SLICE /2 RECEIPT identities differ — the governed layer minted two different receipts, and Form /1 recorded both exactly")
          (desk-note "NC-31B CLASSIFICATION — trusted-host false declaration or identifier reuse;")
          (desk-note "  not detected by Form /1; not claimed to be detected;")
          (desk-note "  no cross-image certification earned.")
          (desk-note "  This is the honest residual AFTER the repair.  Its existence does")
          (desk-note "  NOT excuse NC-31A, which was a defect of this layer and is fixed."))))))

;; ---- NC-31C — DECLARATION ORDER IS NOT SEMANTICALLY CONSEQUENTIAL --------
;; Two contexts holding the same declarations inserted in DIFFERENT orders
;; declare the same thing, and must carry the same declaration identity.
(let* ((witnesses (list (scan-witness "PLUT-7") (scan-witness "PLUT-8")))
       (schema (wrapper))
       (conclusion (np '(:predicate :volume-reshelved (:volume "PLUT-7"))))
       ;; forward: conclusion, then w1, then w2, receiver last
       (forward (seal (+receiver (+support (+support (+conclusion (+schema (ctx) schema)
                                                                  conclusion)
                                                     (first witnesses) "w1")
                                           (second witnesses) "w2")
                                 (desk witnesses))
                      "order-same"))
       ;; reverse: w2 then w1, and the receiver bound BEFORE the supports
       (reverse-order
         (let ((context (+schema (ctx) schema)))
           (setf context (+receiver context (desk witnesses)))
           (setf context (+support context (second witnesses) "w2"))
           (setf context (+support context (first witnesses) "w1"))
           (setf context (+conclusion context conclusion))
           (seal context "order-same"))))
  (check (cd0:equal-datum (f1:derivation-resolution-context-declaration-identity forward)
                          (f1:derivation-resolution-context-declaration-identity reverse-order))
         "NC-31C: the SAME declarations inserted in DIFFERENT orders (across roles and within the support role) yield the IDENTICAL declaration identity — insertion order is canonicalized away before identity construction")
  (check (cd0:equal-datum (f1:derivation-resolution-context-occurrence-identity forward)
                          (f1:derivation-resolution-context-occurrence-identity reverse-order))
         "NC-31C: …and therefore the identical context OCCURRENCE identity")
  (check (equal (mapcar #'f1:context-binding-declaration-role
                        (f1:derivation-resolution-context-declarations forward))
                (mapcar #'f1:context-binding-declaration-role
                        (f1:derivation-resolution-context-declarations reverse-order)))
         "NC-31C: …and the DECLARATIONS reader reports them in the same canonical order from both"))

;;; ══════════════════════════════════════════════════════════════════════════
;;; NC-BY — :BY AND :BY-ID UNDER THE SAME DOCTRINE (owner ruling, Review 1 §6)
;;;
;;; :BY-ID IS THE HOST'S DURABLE DECLARATION NAMING THE EXACT LIVE :BY ANCHOR.
;;; FORM /1 DOES NOT CERTIFY THAT RELATION.  It is the denotation/anchor split
;;; applied to the asserting principal, and it has exactly the same two halves:
;;; the declaration is what identity commits to, and a host that declares
;;; truly-shaped and binds otherwise is not caught.
;;;
;;; Neither argument is removed and DERIVE/2's NIL -> :DERIVER default is still
;;; not inherited: a form that could leave the asserting principal unstated would
;;; let a question quietly answer in nobody's name.
;;;
;;; NO ARBITRARY-HOST-OBJECT CANONICALIZER IS INVENTED HERE.  :BY may be any
;;; host value; there is no canonical content to encode, and manufacturing one
;;; from its accidents is the substitution defect with a printer attached.

;; ---- NC-BY-A — same live :BY, DIFFERENT :BY-ID ---------------------------
(multiple-value-bind (datum proposed validated petition) (build :tag "nc-by-a")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "nc-by-a"))
         (principal :desk-clerk)
         (act (idd '("form1-selftest") '("act" "by-a"))))
    (multiple-value-bind (a) (counted-submit "nc-by-a-1" petition context
                                             :by principal :act-id act
                                             :by-id (idd '("form1-selftest") '("by" "clerk-alpha")))
      (multiple-value-bind (b) (counted-submit "nc-by-a-2" petition context
                                               :by principal :act-id act
                                               :by-id (idd '("form1-selftest") '("by" "clerk-beta")))
        (let ((receipt-a (f1:petition-submission-outcome-receipt a))
              (receipt-b (f1:petition-submission-outcome-receipt b)))
          (check (eq (f1:petition-submission-receipt-by receipt-a)
                     (f1:petition-submission-receipt-by receipt-b))
                 "NC-BY-A setup: the EXACT SAME live :BY object was submitted twice (EQ), so the live anchor cannot be what separates them")
          (check (not (cd0:equal-datum (f1:petition-submission-receipt-by-id receipt-a)
                                       (f1:petition-submission-receipt-by-id receipt-b)))
                 "NC-BY-A setup: …under two DIFFERENT :BY-ID declarations")
          (check (not (cd0:equal-datum
                       (f1:petition-submission-receipt-occurrence-identity receipt-a)
                       (f1:petition-submission-receipt-occurrence-identity receipt-b)))
                 "NC-BY-A: DIFFERENT :BY-ID under an identical live :BY yields DIFFERENT SUBMISSION OCCURRENCE IDENTITIES — the durable record commits to the declaration"))))))

;; ---- NC-BY-B — DIFFERENT live :BY, same :BY-ID ---------------------------
;; The mirror of NC-31B, and the same honest residual.
(multiple-value-bind (datum proposed validated petition) (build :tag "nc-by-b")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "nc-by-b"))
         (shared-by-id (idd '("form1-selftest") '("by" "the-desk-clerk")))
         (act (idd '("form1-selftest") '("act" "by-b"))))
    (multiple-value-bind (a) (counted-submit "nc-by-b-1" petition context
                                             :by :desk-clerk :by-id shared-by-id :act-id act)
      (multiple-value-bind (b) (counted-submit "nc-by-b-2" petition context
                                               :by :night-porter :by-id shared-by-id :act-id act)
        (let ((receipt-a (f1:petition-submission-outcome-receipt a))
              (receipt-b (f1:petition-submission-outcome-receipt b)))
          (check (not (eq (f1:petition-submission-receipt-by receipt-a)
                          (f1:petition-submission-receipt-by receipt-b)))
                 "NC-BY-B setup: TWO DIFFERENT live :BY values were submitted")
          (check (cd0:equal-datum (f1:petition-submission-receipt-by-id receipt-a)
                                  (f1:petition-submission-receipt-by-id receipt-b))
                 "NC-BY-B setup: …under the SAME :BY-ID declaration")
          (check (cd0:equal-datum
                  (f1:petition-submission-receipt-occurrence-identity receipt-a)
                  (f1:petition-submission-receipt-occurrence-identity receipt-b))
                 "NC-BY-B: an IDENTICAL DECLARED SUBMISSION IDENTITY results from two different live principals — recorded as a TRUSTED-HOST FALSE DECLARATION, not detected by Form /1 and not claimed to be")
          (check (not (eq (lisp-plus-slice0:claim-asserted-by
                           (f1:petition-submission-outcome-claim a))
                          (lisp-plus-slice0:claim-asserted-by
                           (f1:petition-submission-outcome-claim b))))
                 "NC-BY-B: …and the divergence IS in-image observable — the two granted claims are asserted by different principals, so a reader holding both can see what no durable field records")
          ;; ---- NC-BY-C — the receipt exposes BOTH ----
          (check (and (eq (f1:petition-submission-receipt-by receipt-a) :desk-clerk)
                      (cd0:datum-p (f1:petition-submission-receipt-by-id receipt-a))
                      (cd0:identifier-datum-p (f1:petition-submission-receipt-by-id receipt-a)))
                 "NC-BY-C: the submission receipt exposes BOTH the EXACT live :BY anchor and the IMMUTABLE :BY-ID declaration — two readers, two kinds of fact, neither standing in for the other"))))))

;; NC-33 — same act id reused
(multiple-value-bind (datum proposed validated petition) (build :tag "nc33")
  (declare (ignore datum proposed validated))
  (let ((context (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "nc33"))
        (act (idd '("form1-selftest") '("act" "reused"))))
    (multiple-value-bind (a) (counted-submit "nc33-a" petition context :act-id act)
      (multiple-value-bind (b) (counted-submit "nc33-b" petition context :act-id act)
        (check (cd0:equal-datum
                (f1:petition-submission-receipt-occurrence-identity
                 (f1:petition-submission-outcome-receipt a))
                (f1:petition-submission-receipt-occurrence-identity
                 (f1:petition-submission-outcome-receipt b)))
               "NC-33: the SAME submission act id reused yields an IDENTICAL submission occurrence identity — the same documented honesty rule")))))

;; NC-18 — re-submission with a fresh act id, and NC-17 in the same fixture
(multiple-value-bind (datum proposed validated petition) (build :tag "nc17-18")
  (declare (ignore datum proposed validated))
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (full-context '("w1") witnesses (wrapper) "nc17-18"))
         (fingerprint-before (petition-fingerprint petition)))
    ;; NC-17: a REFUSED submission must leave the petition byte-identical
    (multiple-value-bind (outcome refusal count)
        (counted-submit "nc17-refused" petition (seal (ctx) "nc17-empty"))
      (declare (ignore outcome))
      (check (and (eq (code-of refusal) :unresolved-schema-reference) (= 0 count))
             "NC-17 setup: a submission against an empty sealed context refuses EXACTLY :UNRESOLVED-SCHEMA-REFERENCE without invocation")
      (check (string= fingerprint-before (petition-fingerprint petition))
             "NC-17: after a REFUSED submission the petition is BYTE-IDENTICAL (full canonical fingerprint over all nine public readers)"))
    ;; and it still submits successfully afterwards — the refusal left nothing behind
    (multiple-value-bind (first-outcome first-refusal)
        (counted-submit "nc18-first" petition context
                        :act-id (idd '("form1-selftest") '("act" "first")))
      (multiple-value-bind (second-outcome second-refusal)
          (counted-submit "nc18-second" petition context
                          :act-id (idd '("form1-selftest") '("act" "second")))
        (check (and (null first-refusal) (null second-refusal))
               "NC-18: the petition submits again after a refused submission — the refusal left no residue")
        (check (not (cd0:equal-datum
                     (f1:petition-submission-receipt-occurrence-identity
                      (f1:petition-submission-outcome-receipt first-outcome))
                     (f1:petition-submission-receipt-occurrence-identity
                      (f1:petition-submission-outcome-receipt second-outcome))))
               "NC-18: re-submission under a fresh act id produces a SECOND DISTINCT submission occurrence")
        (check (string= fingerprint-before (petition-fingerprint petition))
               "NC-18: …and the petition is STILL byte-identical after two successful submissions — no chaining, no accumulation")
        ;; NC-15
        (multiple-value-bind (d2 p2 v2 other) (build :supports '("other") :tag "nc15")
          (declare (ignore d2 p2 v2))
          (check (not (cd0:equal-datum
                       (f1:petition-submission-receipt-petition-occurrence-identity
                        (f1:petition-submission-outcome-receipt first-outcome))
                       (f1:derivation-petition-occurrence-identity other)))
                 "NC-15: petition A's receipt does NOT match petition B — the occurrence identities differ"))))))

;; NC-21 / NC-30 / NC-34 — an unexpected condition ESCAPES and leaves nothing
(defun nc21-escapes-p ()
  "A conclusion bound to a raw host list drives Slice /1 to signal a condition
that is NOT one of the two Form /1 catches.  It must ESCAPE — reaching the caller
as the Slice /1 condition it is, never converted into a petition refusal.
Returns the escaping condition, or NIL if nothing escaped."
  (multiple-value-bind (datum proposed validated petition) (build :tag "escape")
    (declare (ignore datum proposed validated))
    (let ((context (full-context '("w1") (list (scan-witness "PLUT-7")) (wrapper) "escape"
                                 :conclusion '(:predicate :not-a-proposition-object))))
      (handler-case
          (progn (f1:try-submit-petition
                  petition context :by :clerk
                  :by-id (idd '("form1-selftest") '("by" "1"))
                  :act-id (idd '("form1-selftest") '("act" "1")))
                 nil)
        (f1:petition-refused () :converted-to-a-petition-refusal)
        (condition (c) c)))))

(defparameter *escaped* (nc21-escapes-p))

(check (and *escaped*
            (not (eq *escaped* :converted-to-a-petition-refusal))
            (typep *escaped* 's1:slice1-condition)
            (not (typep *escaped* 'f1:petition-refused))
            (not (typep *escaped* 's2:slice2-derivation-refused))
            (not (typep *escaped* 's2:slice2-schema-error)))
       "NC-21/NC-30: a malformed conclusion binding drives a SLICE1-CONDITION out through TRY-SUBMIT-PETITION — it ESCAPES, and is neither a PETITION-REFUSED nor either caught Slice /2 class")

(desk-note "escaped condition class: ~S" (type-of *escaped*))

;; REPAIRED 2026-07-27 by the chair, on FANG's own report.  The shipped form was
;; VACUOUS TWICE OVER: it compared a KEYWORD against labels that are always
;; STRINGS (so EQ was NIL for every entry), and no entry ever carried that label
;; in any representation.  It could not fail, and it read as coverage of the
;; claim in its own label while covering nothing.
;;
;; The claim is "the escaping path returned NO VALUES AT ALL".  So test that:
;; run the escaping submission and record whether control ever reached a point
;; where values existed.  If TRY-SUBMIT-PETITION ever returned — with an outcome,
;; a refusal, or NIL/NIL — the sentinel is overwritten and this check fails.
(check (let ((reached :no-values-ever-returned))
         (multiple-value-bind (datum proposed validated petition) (build :tag "nc34")
           (declare (ignore datum proposed validated))
           (let ((context (full-context '("w1") (list (scan-witness "PLUT-7"))
                                        (wrapper) "nc34"
                                        :conclusion '(:predicate :not-a-proposition-object))))
             (handler-case
                 (multiple-value-bind (outcome refusal)
                     (f1:try-submit-petition
                      petition context :by :clerk
                      :by-id (idd '("form1-selftest") '("by" "1"))
                      :act-id (idd '("form1-selftest") '("act" "1")))
                   (setf reached (list :returned outcome refusal)))
               (f1:petition-refused () (setf reached :converted-to-a-petition-refusal))
               (condition () nil))))
         (eq reached :no-values-ever-returned))
       "NC-34: the escaping path returned NO VALUES AT ALL — control never reached a point where an outcome or a submission receipt existed to be read")

;; NC-11..14 — Form /1 objects offered as evidence are INERT RESIDUE
(defun residue-index (object label)
  "Bind OBJECT as the second support of a two-support petition whose FIRST
support discharges the premise.  The premise is satisfied by the witness, so the
outcome is :GRANTED and OBJECT can only appear as recorded residue."
  (multiple-value-bind (datum proposed validated petition) (build :supports '("w1" "w2") :tag label)
    (declare (ignore datum proposed validated))
    (let* ((witness (scan-witness "PLUT-7"))
           (context (seal (+receiver (+support (+support (+conclusion (+schema (ctx) (wrapper))
                                                                      (np '(:predicate :volume-reshelved
                                                                            (:volume "PLUT-7"))))
                                                         witness "w1")
                                               object "w2")
                                     (desk (list witness)))
                          label)))
      (multiple-value-bind (outcome refusal) (counted-submit label petition context)
        (and (null refusal)
             (eq :granted (f1:petition-submission-outcome-kind outcome))
             (let ((unsupported (s2:slice2-receipt-unsupported-supports
                                 (f1:petition-submission-outcome-slice2-receipt outcome))))
               (and (= 1 (length unsupported))
                    (equal (first unsupported) '(:index 1 :reason :unsupported-support-species))
                    ;; the object itself is NOT retained as evidence anywhere
                    (not (tree-member-eq unsupported object)))))))))

(multiple-value-bind (datum proposed validated petition materialization) (build :tag "residue-source")
  (declare (ignore datum))
  (check (residue-index petition "nc11-petition")
         "NC-11/12: a DERIVATION-PETITION offered as a support is INERT RESIDUE — recorded as (:INDEX 1 :REASON :UNSUPPORTED-SUPPORT-SPECIES) and the object itself is not retained")
  (check (residue-index materialization "nc13-materialization-receipt")
         "NC-13: a MATERIALIZATION RECEIPT offered as standing is INERT RESIDUE, recorded identically")
  (check (residue-index (f1:validated-petition-form-receipt validated) "nc14-validation-receipt")
         "NC-14: a VALIDATION RECEIPT offered as evidence is INERT RESIDUE, recorded identically")
  (check (residue-index proposed "nc14b-proposed-form")
         "NC-14: a PROPOSED-PETITION-FORM offered as evidence is INERT RESIDUE, recorded identically"))

(let ((receipt (f1:petition-submission-outcome-receipt *governed*)))
  (check (residue-index receipt "nc14c-submission-receipt")
         "NC-14: a SUBMISSION RECEIPT offered as truth evidence is INERT RESIDUE, recorded identically"))

;; NC-4 — a caller-supplied handler function is unrepresentable
(check (and (not (cd0:datum-p #'identity))
            (eq (code-of (nth-value 1 (f1:try-propose-petition #'identity))) :not-a-datum))
       "NC-4: a host FUNCTION is not a CD/0 datum and cannot enter — PROPOSE refuses it EXACTLY :NOT-A-DATUM; no CD/0 family carries a closure")

;;; ══════════════════════════════════════════════════════════════════════════
;;; L.  SOURCE TEETH — and the scanner's own teeth-check first
;;; ══════════════════════════════════════════════════════════════════════════

(section "L. Source discipline — the scanner is teeth-checked BEFORE it is believed")

(check (token-present-p (strip-comments-and-strings "(defun f () (eval x))") "eval")
       "T-SCAN-01 planted fault: the scanner FINDS `eval' in live code")

(check (not (token-present-p
             (strip-comments-and-strings "; a comment naming eval, intern and perform")
             "eval"))
       "T-SCAN-02: the scanner IGNORES a banned name inside a ;-comment")

(check (not (token-present-p
             (strip-comments-and-strings "(defun f () \"docstring naming eval and find-symbol\" 1)")
             "eval"))
       "T-SCAN-03: the scanner IGNORES a banned name inside a string literal")

(check (not (token-present-p (strip-comments-and-strings "(defun g (payload) payload)") "load"))
       "T-SCAN-04: the scanner does NOT read `load' out of `payload' — token matching, not substring")

(check (substring-present-p (strip-comments-and-strings "(handler-case (f) (error () nil))")
                            "(error (")
       "T-SCAN-05 planted fault: the scanner FINDS a blanket (ERROR () …) handler in live code")

(check (not (substring-present-p
             (strip-comments-and-strings "(error 'petition-refused :refusal r)") "(error ("))
       "T-SCAN-06: the scanner does NOT flag (ERROR 'PETITION-REFUSED …) — signalling a typed condition is not a blanket handler")

(defparameter *form1-code* (code-below-marker (read-file-text *form1-source*)))

(desk-note "scanned ~D characters of CODE below the marker (comments and string literals blanked)"
           (length (remove #\Space *form1-code*)))

(dolist (token '("eval" "compile" "load" "intern" "find-symbol" "read-from-string" "perform"))
  (check (not (token-present-p *form1-code* token))
         (format nil "T-NO-HOST-ESCAPE: the code below the marker contains NO `~A' token" token)))

(check (not (substring-present-p *form1-code* "(error ()"))
       "T-NO-BROAD-HANDLER: the code below the marker contains no `(ERROR () …)' clause")

(check (not (substring-present-p *form1-code* "(error ("))
       "T-NO-BROAD-HANDLER (stronger): it contains no `(ERROR (…) …)' handler clause AT ALL, however the variable is named")

(check (not (search "lisp-plus-form0" (string-downcase *form1-code*)))
       "T-NO-FORM0: the code below the marker names LISP-PLUS-FORM0 not once, single- or double-colon")

(dolist (token '("prin1-to-string" "sxhash" "print-object" "eval-when" "compile-file"
                 "load-time-value" "macroexpand"))
  (check (not (token-present-p *form1-code* token))
         (format nil "§12 forbidden snapshot / compile-time escape: no `~A' token below the marker" token)))

;; NC-2 in its own right
(check (not (token-present-p *form1-code* "perform"))
       "NC-2: PERFORM is unavailable — no Form /1 path below the marker reaches it")

;;; ══════════════════════════════════════════════════════════════════════════
;;; M.  THE FIVE PLANTED FAULTS (§15)
;;; ══════════════════════════════════════════════════════════════════════════
;;;
;;; form1.lisp cannot be edited, so each fault is installed by REBINDING an
;;; FDEFINITION, the live tooth that is supposed to catch it is re-run, and the
;;; assertion is that the tooth now FAILS.  Recording is suppressed throughout:
;;; a MUTANT's refusal is not evidence about the honest layer.
;;;
;;; Every result is recorded as (fault, tooth that fired, INTENDED or NOT), and
;;; nothing is collapsed into "killed".

(section "M. Planted faults — each dies at a named tooth")

(defparameter *fault-log* '())

(defun record-fault (id description tooth intended-p note)
  (push (list id description tooth intended-p note) *fault-log*))

(defmacro with-fault ((name new) &body body)
  (let ((real (gensym)) (fname (gensym)))
    `(let* ((,fname ,name) (,real (fdefinition ,fname)))
       (unwind-protect
            (let ((*recording* nil))
              (setf (fdefinition ,fname) ,new)
              ,@body)
         (setf (fdefinition ,fname) ,real)))))

;; ---- PF-1: make MATERIALIZE-PETITION able to invoke DERIVE/2 -------------
(let ((real (fdefinition 'f1:materialize-petition)))
  (let ((count-under-fault
          (with-fault ('f1:materialize-petition
                       (lambda (validated tag)
                         ;; the fault: Door 1 reaches the governed operation
                         (handler-case (s2:derive/2 :schema nil :conclusion nil
                                                    :supports nil :receiver nil :by :fault)
                           (condition () nil))
                         (funcall real validated tag)))
            (nc28-door-1-count))))
    (check (/= 0 count-under-fault)
           (format nil "PF-1 (MATERIALIZE-PETITION can invoke DERIVE/2) DIES at NC-28 step 3: the Door 1 counter reads ~D, not 0" count-under-fault))
    (record-fault "PF-1" "MATERIALIZE-PETITION able to invoke DERIVE/2"
                  "NC-28 step 3 (Door 1 counter = 0)" t
                  (format nil "counter went 0 → ~D" count-under-fault))))

;; ---- PF-2: pre-filter resolved supports before DERIVE/2 -----------------
(let ((real (fdefinition 'lisp-plus-form1::%resolve)))
  (let ((holds (with-fault ('lisp-plus-form1::%resolve
                            (lambda (context role reference)
                              (multiple-value-bind (value found)
                                  (funcall real context role reference)
                                ;; the fault: Form /1 decides a support is not
                                ;; worth passing and drops it before invocation
                                (if (and found (eq role :support))
                                    (values nil t)
                                    (values value found)))))
                 (nc10-holds-p))))
    (check (not holds)
           "PF-2 (Form /1 pre-filters resolved supports) DIES at NC-10: the captured DERIVE/2 :SUPPORTS argument no longer EQUALs the resolved witness list")
    (record-fault "PF-2" "Form /1 pre-filters resolved supports before DERIVE/2"
                  "NC-10 (DERIVE/2 argument capture)" t
                  "caught by the argument-capture half of NC-10, NOT by the outcome kind — a pre-filtered call still yields :GOVERNED-REFUSAL")))

;; ---- PF-3: let the support table satisfy a receiver reference ------------
(let ((real (fdefinition 'lisp-plus-form1::%resolve)))
  (let ((holds (with-fault ('lisp-plus-form1::%resolve
                            (lambda (context role reference)
                              (multiple-value-bind (value found)
                                  (funcall real context role reference)
                                (cond (found (values value found))
                                      ;; the fault: role separation leaks
                                      ((and (eq role :receiver)
                                            (eq :receiver (f1:reference-role reference)))
                                       (funcall real context :support
                                                (f1:support-reference
                                                 (cd0:identifier-datum-path-segment reference 2))))
                                      (t (values nil nil))))))
                 (nc35-holds-p))))
    (check (not holds)
           "PF-3 (the support table satisfies a receiver reference of the same host key) DIES at NC-35: the receiver reference now resolves and DERIVE/2 is invoked")
    (record-fault "PF-3" "role-separated resolution satisfies a receiver reference from the support table"
                  "NC-35 (role confusion)" t
                  "the :UNRESOLVED-RECEIVER-REFERENCE refusal disappears and the counter leaves 0")))

;; ---- PF-4: make an aggregate reader alias the stored value ---------------
(let ((holds (with-fault ('f1:derivation-petition-support-references
                          (lambda (petition)
                            ;; the fault: hand out the stored list itself
                            (lisp-plus-form1::%petition-support-refs petition)))
               (nc20-support-references-safe-p))))
  (check (not holds)
         "PF-4 (DERIVATION-PETITION-SUPPORT-REFERENCES aliases the stored list) DIES at NC-20 (a): the caller's mutation reaches the stored refs and the petition fingerprint moves")
  (record-fault "PF-4" "aggregate reader aliases the stored value"
                "NC-20 (a) (mutate what the reader handed back)" t
                "the fingerprint comparison moved; the mutation reached the stored list"))

;; ---- PF-5: convert an implementation condition into a petition refusal ---
(let ((real (fdefinition 'f1:submit-petition))
      (borrowed-refusal (nth-value 1 (f1:try-propose-petition 42))))
  (let ((escaped (with-fault ('f1:try-submit-petition
                              (lambda (petition context &key by by-id act-id)
                                ;; the fault: a blanket handler swallows every
                                ;; condition and reports it as a Form /1 refusal
                                (handler-case
                                    (values (funcall real petition context
                                                     :by by :by-id by-id :act-id act-id)
                                            nil)
                                  (f1:petition-refused (condition)
                                    (values nil (f1:petition-refused-refusal condition)))
                                  (condition () (values nil borrowed-refusal)))))
                   (nc21-escapes-p))))
    (check (null escaped)
           "PF-5 (the submission path wrapped in a blanket handler) DIES at NC-21: nothing escapes any more — the Slice /1 condition comes back as a returned refusal")
    (record-fault "PF-5" "submission path wrapped in (ERROR () …) so an implementation condition becomes a petition refusal"
                  "NC-21 (the escape tooth)" t
                  "NC-21 fired first; NC-34 could not fire because there was no escape left to leave nothing behind")))

(format t "~%       ── planted-fault ledger (nothing collapsed into \"killed\") ──~%")
(dolist (row (reverse *fault-log*))
  (destructuring-bind (id description tooth intended note) row
    (format t "       ~A  ~A~%             died at: ~A  [~A]~%             ~A~%"
            id description tooth (if intended "INTENDED TOOTH" "DIFFERENT TOOTH") note)))

;; The faults are gone.  Prove it, rather than trusting UNWIND-PROTECT.
(check (and (= 0 (nc28-door-1-count)) (nc10-holds-p) (nc35-holds-p)
            (nc20-support-references-safe-p) (nc21-escapes-p))
       "POST-FAULT RESTORATION: all five teeth pass again with the honest fdefinitions restored")

;;; ══════════════════════════════════════════════════════════════════════════
;;; N.  T-CODESET — THE MOST IMPORTANT TOOTH IN THE FILE
;;; ══════════════════════════════════════════════════════════════════════════

(section "N. NC-32 — THE SPLIT CODE LEDGER, both classes, both directions")

;;; UNDER POLICY v2 THIS PRINTED `declared 36 · produced 36' AND FLATTENED TWO
;;; DIFFERENT EVIDENTIARY CLASSES.  Three of those codes cannot be provoked
;;; through the intended public surface at all — CD/0 copies on every access —
;;; and their fixtures produce them by shimming an internal function.  A single
;;; count that includes them is a count standing in for a demonstration, and it
;;; travels: a reader of green output sees `36/36' and has no way to learn that
;;; three of the thirty-six are unreachable dead handlers for any host.
;;;
;;; Five executable requirements, each its own tooth:
;;;   1. every PROTOCOL refusal was produced THROUGH THE PUBLIC API
;;;   2. every INTEGRITY ALARM was produced UNDER AN INTERNAL PLANTED FAULT
;;;   3. the two DECLARED sets are DISJOINT
;;;   4. their UNION equals the COMPLETE implementation code set
;;;   5. NO ADVERTISED CODE LACKS A FIXTURE (both directions, both classes)

(defparameter *declared-protocol* (f1:petition-protocol-refusal-codes))
(defparameter *declared-alarm* (f1:petition-integrity-alarm-codes))
(defparameter *catalog* (f1:petition-refusal-code-catalog))
(defparameter *catalog-codes* (mapcar #'f1:petition-refusal-code-entry-code *catalog*))

(defparameter *public* (copy-list *produced-by-public-api*))
(defparameter *induced* (copy-list *produced-under-induction*))

(defparameter *protocol-declared-not-produced* (set-difference *declared-protocol* *public*))
(defparameter *protocol-produced-not-declared* (set-difference *public* *declared-protocol*))
(defparameter *alarm-declared-not-produced* (set-difference *declared-alarm* *induced*))
(defparameter *alarm-produced-not-declared* (set-difference *induced* *declared-alarm*))

(format t "~%       ── THE LEDGER, SPLIT ──────────────────────────────────────~%")
(format t "       PUBLIC PROTOCOL REFUSALS     declared ~D · produced through the public API ~D~%"
        (length *declared-protocol*) (length *public*))
(format t "       INDUCED INTEGRITY ALARMS     declared ~D · produced under internal fault ~D~%"
        (length *declared-alarm*) (length *induced*))
(format t "       CATALOGUE                    ~D entries~%" (length *catalog-codes*))
(format t "~%       The three induced alarms, and their reachability as the catalogue states it:~%")
(dolist (entry *catalog*)
  (when (eq :integrity-alarm (f1:petition-refusal-code-entry-class entry))
    (format t "         ~S  ~S~%"
            (f1:petition-refusal-code-entry-code entry)
            (f1:petition-refusal-code-entry-reachability entry))))
(format t "~%       CD/0's copy-on-access makes these unreachable through the intended~%")
(format t "       public surface.  That is a GENUINE GOVERNED GUARANTEE, pinned by CD/0's~%")
(format t "       own suite and by the Python seed — not a current accident.  They remain~%")
(format t "       useful as package-internal integrity guards and planted-fault alarms,~%")
(format t "       and a public caller cannot naturally provoke them.~%~%")

(when *protocol-declared-not-produced*
  (format t "       PROTOCOL DECLARED BUT NEVER PRODUCED: ~{~S ~}~%" *protocol-declared-not-produced*))
(when *protocol-produced-not-declared*
  (format t "       PRODUCED PUBLICLY BUT NOT DECLARED AS PROTOCOL: ~{~S ~}~%" *protocol-produced-not-declared*))
(when *alarm-declared-not-produced*
  (format t "       ALARM DECLARED BUT NEVER INDUCED: ~{~S ~}~%" *alarm-declared-not-produced*))
(when *alarm-produced-not-declared*
  (format t "       INDUCED BUT NOT DECLARED AS AN ALARM: ~{~S ~}~%" *alarm-produced-not-declared*))

;; ---- requirement 1 + 5 (→) ----
(check (null *protocol-declared-not-produced*)
       (format nil "NC-32A (→): every one of the ~D DECLARED PROTOCOL codes was produced BY A PUBLIC-API FIXTURE in this run — no advertised protocol code lacks a fixture, and a gate that has never fired is untested, not passing"
               (length *declared-protocol*)))

;; ---- requirement 5 (←), protocol ----
(check (null *protocol-produced-not-declared*)
       (format nil "NC-32A (←): every one of the ~D codes produced through the public API is DECLARED AS A PROTOCOL REFUSAL — no public path signals a code the protocol catalogue omits, and none of the three integrity alarms leaked out through a public call"
               (length *public*)))

;; ---- requirement 2 ----
(check (null *alarm-declared-not-produced*)
       (format nil "NC-32B (→): every one of the ~D DECLARED INTEGRITY ALARMS was produced UNDER AN INTERNAL PLANTED FAULT — the guards are real and they fire"
               (length *declared-alarm*)))

(check (null *alarm-produced-not-declared*)
       "NC-32B (←): everything produced under induction is declared as an integrity alarm — the shim provoked nothing the catalogue does not classify")

;; ---- requirement 3 — the DECLARED sets are disjoint ----
(check (and (null (intersection *declared-protocol* *declared-alarm*))
            (null (intersection *declared-alarm* *declared-protocol*)))
       "NC-32C: the two DECLARED sets are DISJOINT — no code is published as both publicly reachable and internally unreachable")

;; ---- requirement 3, on the PRODUCED side too ----
(check (null (intersection *public* *induced*))
       "NC-32C (produced): the two PRODUCED sets are DISJOINT — no code was reached both by a caller and only by a shim, so the classification is not merely asserted but observed")

;; ---- requirement 4 — the union IS the complete set ----
(check (and (null (set-difference (append *declared-protocol* *declared-alarm*) *catalog-codes*))
            (null (set-difference *catalog-codes* (append *declared-protocol* *declared-alarm*)))
            (= (length *catalog-codes*)
               (+ (length *declared-protocol*) (length *declared-alarm*))))
       (format nil "NC-32D: the UNION of the two published lists EQUALS the complete catalogue (~D = ~D + ~D), set-difference empty in both directions — the split cannot drift from the whole, because both lists are DERIVED from the one catalogue"
               (length *catalog-codes*) (length *declared-protocol*) (length *declared-alarm*)))

;; ---- the catalogue states reachability for EVERY code ----
(check (every (lambda (entry)
                (and (member (f1:petition-refusal-code-entry-class entry)
                             '(:protocol-refusal :integrity-alarm))
                     (member (f1:petition-refusal-code-entry-reachability entry)
                             '(:public-api :internal-planted-fault-only))
                     (plusp (length (f1:petition-refusal-code-entry-note entry)))))
              *catalog*)
       "NC-32E: EVERY catalogue entry states a class, a REACHABILITY and a non-empty note — a host author can tell, from the catalogue alone, whether a handler it writes is dead code")

(check (every (lambda (entry)
                (if (eq :integrity-alarm (f1:petition-refusal-code-entry-class entry))
                    (eq :internal-planted-fault-only
                        (f1:petition-refusal-code-entry-reachability entry))
                    (eq :public-api (f1:petition-refusal-code-entry-reachability entry))))
              *catalog*)
       "NC-32E: …and class and reachability agree entry by entry — the two columns are not independently maintainable and cannot disagree")

;; ---- hygiene ----
(check (and (= (length *declared-protocol*) (length (remove-duplicates *declared-protocol*)))
            (= (length *declared-alarm*) (length (remove-duplicates *declared-alarm*)))
            (= (length *catalog-codes*) (length (remove-duplicates *catalog-codes*)))
            (= (length *public*) (length (remove-duplicates *public*)))
            (= (length *induced*) (length (remove-duplicates *induced*))))
       "NC-32 hygiene: no set contains a duplicate, so every set-difference above is over true sets")

;; ---- AND THE FLAT READER IS GONE, checked rather than remembered ----
(check (null (find-symbol "PETITION-REFUSAL-CODES" :lisp-plus-form1))
       "NC-32F: there is NO PETITION-REFUSAL-CODES symbol in the package at all — the flat list whose count could travel without the distinction was removed, not deprecated")

;;; ══════════════════════════════════════════════════════════════════════════

(format t "~%── A petition is a well-formed question, never a granted answer. ──~%")
(format t "── The envelope is a BUILD gate: no ceiling may erase a governed act. ──~%")
(format t "── The witness is the counter, never the receipt. ──~%")

(when (plusp *failed*)
  (format t "~%   FAILED CHECKS:~%")
  (dolist (label (reverse *failed-labels*))
    (format t "     ~A~%" label)))

(format t "~%== form1-selftest: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

(when (plusp *failed*)
  (sb-ext:exit :code 1))
