;;;; probe-control-6.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; CONTROL 6, ALONE IN ITS OWN CHILD IMAGE.
;;;;
;;;; THE R1 NINE-STEP MATRIX, RUN IN ORDER, ON BOTH PROVIDERS.  R0 ran a
;;;; Surface /1-leaning version of this control with a PARTIAL redefinition
;;;; (two of three versions on S1; one version and one identity on S2), so
;;;; several of the questions it reported on were never actually put.  The
;;;; owner adjudication requires all nine steps, per provider, in isolated
;;;; children:
;;;;
;;;;   1. capture stored grammar / procedure / policy versions;
;;;;   2. capture live procedure and policy identities;
;;;;   3. redefine ALL THREE public version declarations;
;;;;   4. redefine BOTH public procedure/policy identity declarations;
;;;;   5. prove the live values ACTUALLY MOVED;
;;;;   6. prove the old receipt retains all three stored versions;
;;;;   7. prove the old receipt / source / occurrence identities do not move;
;;;;   8. mint a new receipt and prove it stores the moved versions;
;;;;   9. synthesize no mint-time procedure/policy identity.
;;;;
;;;; STEP 5 IS THE TOOTH AND IT COMES BEFORE ANY CONCLUSION.  If the live
;;;; readers did not move after redefinition, every later step would be
;;;; untested rather than passing.
;;;;
;;;; STEP 9, STATED EXACTLY.  "No mint-time identity is synthesized" is a
;;;; claim with two halves, and both are asserted: (a) the RECEIPT'S OWN
;;;; identity does not move when the declarations do — nothing is recomputed
;;;; into it after minting; and (b) the receipt's procedure/policy identity
;;;; READERS return the LIVE declaration, not a stored mint-time fact, which
;;;; is shown by their equality with the live declaration BOTH before and
;;;; after the redefinition.  A provider that had synthesized a mint-time
;;;; identity would fail (b).
;;;;
;;;; HOW THE REDEFINITION IS DONE, AND ITS LIMIT.  No file is edited and no
;;;; provider-private symbol is touched.  The seam is `(setf (fdefinition
;;;; 'PROVIDER:PUBLIC-DECLARATION) ...)` on a QUALIFIED EXTERNAL symbol — the
;;;; same public name any reader may call.  This is the strongest seam the
;;;; public API offers; the image is thrown away when this file finishes.
;;;;
;;;; ANCHORS.  Every step of every provider block is written on a stable
;;;; grep-able line — C6-S1-STEP-1 … C6-S1-STEP-9, C6-S2-STEP-1 … C6-S2-STEP-9,
;;;; each block opened by C6-PROVIDER S1 / S2 and closed by END-C6-PROVIDER
;;;; S1 / S2 — so the governed documents can cite this transcript by anchor
;;;; and never by line number.

(in-package #:cl-user)

(defparameter *specimen-text*
  ;; mneme/language-surface-1/surface1-selftest.lisp *SPECIMEN* (line ~155).
  "(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
     :contract-id :surface1/selftest
     :contract-version 1
     :accepted-clauses ((:verified-judged-claim))
     :proposition-relation :exact-normalized-equality
     :receiver-accessibility :required
     :retain (:contract-snapshot :support-identity :support-basis :source-basis))")

(defparameter *match-text*
  "(lisp-plus-surface2:match-outcome cl-user::o
     ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id cl-user::o))
     (otherwise cl-user::o))")

(defun step-line (tag text)
  (p "  ~A ~A" tag text))

(probe-header "FIXED CONTROLS PART B — control 6 (isolated redefinition child)")

;;; --------------------------------------------------------------------------
;;; SURFACE /1 — the nine steps.
;;; --------------------------------------------------------------------------

(rule #\=)
(p "C6-PROVIDER S1")
(p "CONTROL 6 / SURFACE 1 — the nine-step redefinition matrix")
(rule #\=)

(defparameter *r1*
  (lisp-plus-surface1:perform-expansion
   (lisp-plus-surface1:request-expansion
    (read-fixture *specimen-text*) :macroexpand-1 (tag-for "c6-s1"))))

;;; ---- STEP 1: capture the stored versions ---------------------------------
(step-line "C6-S1-STEP-1" "capture stored grammar / procedure / policy versions")
(defparameter *s1-stored-before*
  (list :grammar   (lisp-plus-surface1:expansion-receipt-grammar-version *r1*)
        :procedure (lisp-plus-surface1:expansion-receipt-procedure-version *r1*)
        :policy    (lisp-plus-surface1:expansion-receipt-policy-version *r1*)))
(kv "S1-STORED-GRAMMAR-VERSION-BEFORE   [receipt-stored]" (getf *s1-stored-before* :grammar))
(kv "S1-STORED-PROCEDURE-VERSION-BEFORE [receipt-stored]" (getf *s1-stored-before* :procedure))
(kv "S1-STORED-POLICY-VERSION-BEFORE    [receipt-stored]" (getf *s1-stored-before* :policy))
(probe-check "C6-S1-STEP-1-STORED-VERSIONS-PRESENT" "C6/S1 step 1: all three stored versions are present and are integers"
             (and (integerp (getf *s1-stored-before* :grammar))
                  (integerp (getf *s1-stored-before* :procedure))
                  (integerp (getf *s1-stored-before* :policy))))

;;; ---- STEP 2: capture the live identities ---------------------------------
(step-line "C6-S1-STEP-2" "capture live procedure and policy identities (declaration and receipt reader)")
(defparameter *s1-live-before*
  (list :decl-procedure (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-procedure-identity))
        :decl-policy    (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-policy-identity))
        :read-procedure (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-receipt-procedure-identity *r1*))
        :read-policy    (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-receipt-policy-identity *r1*))
        :live-grammar-version   (lisp-plus-surface1:expansion-grammar-version)
        :live-procedure-version (lisp-plus-surface1:expansion-procedure-version)
        :live-policy-version    (lisp-plus-surface1:expansion-policy-version)))
(kv "S1-LIVE-PROCEDURE-IDENTITY-BEFORE  [provider-current-declaration]" (getf *s1-live-before* :decl-procedure))
(kv "S1-LIVE-POLICY-IDENTITY-BEFORE     [provider-current-declaration]" (getf *s1-live-before* :decl-policy))
(kv "S1-RECEIPT-PROCEDURE-IDENTITY-BEFORE [provider-current-declaration]" (getf *s1-live-before* :read-procedure))
(kv "S1-RECEIPT-POLICY-IDENTITY-BEFORE    [provider-current-declaration]" (getf *s1-live-before* :read-policy))
(kv "S1-LIVE-GRAMMAR-VERSION-BEFORE   [provider-current-declaration]" (getf *s1-live-before* :live-grammar-version))
(kv "S1-LIVE-PROCEDURE-VERSION-BEFORE [provider-current-declaration]" (getf *s1-live-before* :live-procedure-version))
(kv "S1-LIVE-POLICY-VERSION-BEFORE    [provider-current-declaration]" (getf *s1-live-before* :live-policy-version))

;;; the receipt's own identities, captured for step 7
(defparameter *s1-ids-before*
  (list :receipt    (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-identity *r1*))
        :source     (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-source-form-identity *r1*))
        :occurrence (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-occurrence-identity *r1*))))
(kv "S1-RECEIPT-IDENTITY-BEFORE" (getf *s1-ids-before* :receipt))
(kv "S1-SOURCE-IDENTITY-BEFORE" (getf *s1-ids-before* :source))
(kv "S1-OCCURRENCE-IDENTITY-BEFORE" (getf *s1-ids-before* :occurrence))

;;; ---- STEPS 3 and 4: redefine ALL THREE versions and BOTH identities ------
(step-line "C6-S1-STEP-3" "redefine ALL THREE public version declarations")
(arm "PLANTED" "S1 EXPANSION-GRAMMAR-VERSION / -PROCEDURE-VERSION / -POLICY-VERSION")
(setf (fdefinition 'lisp-plus-surface1:expansion-grammar-version) (lambda () 96))
(setf (fdefinition 'lisp-plus-surface1:expansion-procedure-version) (lambda () 99))
(setf (fdefinition 'lisp-plus-surface1:expansion-policy-version) (lambda () 98))

(step-line "C6-S1-STEP-4" "redefine BOTH public procedure/policy identity declarations")
(arm "PLANTED" "S1 EXPANSION-PROCEDURE-IDENTITY / EXPANSION-POLICY-IDENTITY")
(setf (fdefinition 'lisp-plus-surface1:expansion-procedure-identity)
      (lambda () (lisp-plus-cd0:make-identifier-datum
                  '("surface-account-0-probe" "redefined-procedure") '("c6"))))
(setf (fdefinition 'lisp-plus-surface1:expansion-policy-identity)
      (lambda () (lisp-plus-cd0:make-identifier-datum
                  '("surface-account-0-probe" "redefined-policy") '("c6"))))

;;; ---- STEP 5: THE TOOTH.  Prove the live values actually moved. -----------
(step-line "C6-S1-STEP-5" "prove the live values ACTUALLY MOVED (the tooth; nothing is concluded before it)")
(defparameter *s1-live-after*
  (list :decl-procedure (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-procedure-identity))
        :decl-policy    (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-policy-identity))
        :read-procedure (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-receipt-procedure-identity *r1*))
        :read-policy    (lisp-plus-surface1:render-identity-hex
                         (lisp-plus-surface1:expansion-receipt-policy-identity *r1*))
        :live-grammar-version   (lisp-plus-surface1:expansion-grammar-version)
        :live-procedure-version (lisp-plus-surface1:expansion-procedure-version)
        :live-policy-version    (lisp-plus-surface1:expansion-policy-version)))
(kv "S1-LIVE-GRAMMAR-VERSION-AFTER   [provider-current-declaration]" (getf *s1-live-after* :live-grammar-version))
(kv "S1-LIVE-PROCEDURE-VERSION-AFTER [provider-current-declaration]" (getf *s1-live-after* :live-procedure-version))
(kv "S1-LIVE-POLICY-VERSION-AFTER    [provider-current-declaration]" (getf *s1-live-after* :live-policy-version))
(kv "S1-LIVE-PROCEDURE-IDENTITY-AFTER [provider-current-declaration]" (getf *s1-live-after* :decl-procedure))
(kv "S1-LIVE-POLICY-IDENTITY-AFTER    [provider-current-declaration]" (getf *s1-live-after* :decl-policy))
(probe-check "C6-S1-STEP-5-LIVE-VERSIONS-MOVED" "C6/S1 step 5 TOOTH BITES: all THREE live version declarations moved"
             (and (not (eql (getf *s1-live-before* :live-grammar-version)
                            (getf *s1-live-after* :live-grammar-version)))
                  (not (eql (getf *s1-live-before* :live-procedure-version)
                            (getf *s1-live-after* :live-procedure-version)))
                  (not (eql (getf *s1-live-before* :live-policy-version)
                            (getf *s1-live-after* :live-policy-version)))))
(probe-check "C6-S1-STEP-5-LIVE-IDENTITIES-MOVED" "C6/S1 step 5 TOOTH BITES: BOTH live identity declarations moved"
             (and (not (string= (getf *s1-live-before* :decl-procedure)
                                (getf *s1-live-after* :decl-procedure)))
                  (not (string= (getf *s1-live-before* :decl-policy)
                                (getf *s1-live-after* :decl-policy)))))

;;; ---- STEP 6: the old receipt retains ALL THREE stored versions -----------
(step-line "C6-S1-STEP-6" "prove the old receipt retains all three stored versions")
(defparameter *s1-stored-after*
  (list :grammar   (lisp-plus-surface1:expansion-receipt-grammar-version *r1*)
        :procedure (lisp-plus-surface1:expansion-receipt-procedure-version *r1*)
        :policy    (lisp-plus-surface1:expansion-receipt-policy-version *r1*)))
(kv "S1-STORED-GRAMMAR-VERSION-AFTER   [receipt-stored]" (getf *s1-stored-after* :grammar))
(kv "S1-STORED-PROCEDURE-VERSION-AFTER [receipt-stored]" (getf *s1-stored-after* :procedure))
(kv "S1-STORED-POLICY-VERSION-AFTER    [receipt-stored]" (getf *s1-stored-after* :policy))
(probe-check "C6-S1-STEP-6-STORED-VERSIONS-HISTORICAL" "C6/S1 step 6: all THREE stored versions retain HISTORICAL standing"
             (and (eql (getf *s1-stored-before* :grammar) (getf *s1-stored-after* :grammar))
                  (eql (getf *s1-stored-before* :procedure) (getf *s1-stored-after* :procedure))
                  (eql (getf *s1-stored-before* :policy) (getf *s1-stored-after* :policy))))
(probe-check "C6-S1-STEP-6-STORED-DISAGREE-WITH-LIVE" "C6/S1 step 6: and they now DISAGREE with the live declarations, which is the point"
             (and (not (eql (getf *s1-stored-after* :grammar) (getf *s1-live-after* :live-grammar-version)))
                  (not (eql (getf *s1-stored-after* :procedure) (getf *s1-live-after* :live-procedure-version)))
                  (not (eql (getf *s1-stored-after* :policy) (getf *s1-live-after* :live-policy-version)))))

;;; ---- STEP 7: receipt / source / occurrence identities do not move --------
(step-line "C6-S1-STEP-7" "prove the old receipt / source / occurrence identities do not move")
(defparameter *s1-ids-after*
  (list :receipt    (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-identity *r1*))
        :source     (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-source-form-identity *r1*))
        :occurrence (lisp-plus-surface1:render-identity-hex
                     (lisp-plus-surface1:expansion-receipt-occurrence-identity *r1*))))
(kv "S1-RECEIPT-IDENTITY-AFTER" (getf *s1-ids-after* :receipt))
(kv "S1-SOURCE-IDENTITY-AFTER" (getf *s1-ids-after* :source))
(kv "S1-OCCURRENCE-IDENTITY-AFTER" (getf *s1-ids-after* :occurrence))
(probe-check "C6-S1-STEP-7-RECEIPT-IDENTITY-STABLE" "C6/S1 step 7: the receipt identity did not move"
             (string= (getf *s1-ids-before* :receipt) (getf *s1-ids-after* :receipt)))
(probe-check "C6-S1-STEP-7-SOURCE-IDENTITY-STABLE" "C6/S1 step 7: the source-form identity did not move"
             (string= (getf *s1-ids-before* :source) (getf *s1-ids-after* :source)))
(probe-check "C6-S1-STEP-7-OCCURRENCE-IDENTITY-STABLE" "C6/S1 step 7: the occurrence identity did not move"
             (string= (getf *s1-ids-before* :occurrence) (getf *s1-ids-after* :occurrence)))

;;; ---- STEP 8: a NEW receipt stores the MOVED versions ---------------------
(step-line "C6-S1-STEP-8" "mint a new receipt and prove it stores the moved versions")
(arm "CLEAN" "a NEW receipt minted after the redefinition")
(defparameter *s1-new*
  (lisp-plus-surface1:perform-expansion
   (lisp-plus-surface1:request-expansion
    (read-fixture *specimen-text*) :macroexpand-1 (tag-for "c6-s1-after"))))
(kv "S1-NEW-STORED-GRAMMAR-VERSION   [receipt-stored]"
    (lisp-plus-surface1:expansion-receipt-grammar-version *s1-new*))
(kv "S1-NEW-STORED-PROCEDURE-VERSION [receipt-stored]"
    (lisp-plus-surface1:expansion-receipt-procedure-version *s1-new*))
(kv "S1-NEW-STORED-POLICY-VERSION    [receipt-stored]"
    (lisp-plus-surface1:expansion-receipt-policy-version *s1-new*))
(kv "S1-NEW-RECEIPT-IDENTITY"
    (lisp-plus-surface1:render-identity-hex
     (lisp-plus-surface1:expansion-receipt-identity *s1-new*)))
(probe-check "C6-S1-STEP-8-NEW-RECEIPT-STORES-MOVED-VERSIONS" "C6/S1 step 8: the new receipt stores ALL THREE moved versions (96 / 99 / 98)"
             (and (eql 96 (lisp-plus-surface1:expansion-receipt-grammar-version *s1-new*))
                  (eql 99 (lisp-plus-surface1:expansion-receipt-procedure-version *s1-new*))
                  (eql 98 (lisp-plus-surface1:expansion-receipt-policy-version *s1-new*))))
(probe-check "C6-S1-STEP-8-OLD-AND-NEW-DISTINCT" "C6/S1 step 8: the old and the new receipt are different objects with different identities"
             (not (string= (getf *s1-ids-before* :receipt)
                           (lisp-plus-surface1:render-identity-hex
                            (lisp-plus-surface1:expansion-receipt-identity *s1-new*)))))

;;; ---- STEP 9: no mint-time procedure/policy identity is synthesized -------
(step-line "C6-S1-STEP-9" "synthesize no mint-time procedure/policy identity")
(kv "S1-RECEIPT-PROCEDURE-IDENTITY-AFTER [provider-current-declaration]" (getf *s1-live-after* :read-procedure))
(kv "S1-RECEIPT-POLICY-IDENTITY-AFTER    [provider-current-declaration]" (getf *s1-live-after* :read-policy))
(probe-check "C6-S1-STEP-9-READERS-EQUAL-LIVE-BEFORE" "C6/S1 step 9(a): the receipt's identity readers equal the LIVE declaration BEFORE the redefinition"
             (and (string= (getf *s1-live-before* :read-procedure) (getf *s1-live-before* :decl-procedure))
                  (string= (getf *s1-live-before* :read-policy) (getf *s1-live-before* :decl-policy))))
(probe-check "C6-S1-STEP-9-READERS-EQUAL-LIVE-AFTER" "C6/S1 step 9(a): and STILL equal the LIVE declaration AFTER it — no stored mint-time identity"
             (and (string= (getf *s1-live-after* :read-procedure) (getf *s1-live-after* :decl-procedure))
                  (string= (getf *s1-live-after* :read-policy) (getf *s1-live-after* :decl-policy))))
(probe-check "C6-S1-STEP-9-OLD-RECEIPT-NOT-RECOMPUTED" "C6/S1 step 9(b): nothing was recomputed INTO the old receipt — its own identity is unchanged (step 7)"
             (string= (getf *s1-ids-before* :receipt) (getf *s1-ids-after* :receipt)))
(p "  C6-S1-STEP-9-READING: this provider stores procedure/policy VERSIONS as values")
(p "  and does NOT store a procedure/policy IDENTITY.  The receipt's identity")
(p "  readers are projections of the LIVE declaration; a reader who wants the")
(p "  mint-time binding has only the stored VERSION integers to go on.")
(p "END-C6-PROVIDER S1")

;;; --------------------------------------------------------------------------
;;; SURFACE /2 — the same nine steps, on the other provider.
;;; --------------------------------------------------------------------------

(rule #\=)
(p "C6-PROVIDER S2")
(p "CONTROL 6 / SURFACE 2 — the nine-step redefinition matrix")
(rule #\=)

(defparameter *r2s2*
  (lisp-plus-surface2:perform-expansion
   (lisp-plus-surface2:request-expansion
    (read-fixture *match-text*) :macroexpand-1 (tag-for "c6-s2"))))

;;; ---- STEP 1 --------------------------------------------------------------
(step-line "C6-S2-STEP-1" "capture stored grammar / procedure / policy versions")
(defparameter *s2-stored-before*
  (list :grammar   (lisp-plus-surface2:expansion-receipt-grammar-version *r2s2*)
        :procedure (lisp-plus-surface2:expansion-receipt-procedure-version *r2s2*)
        :policy    (lisp-plus-surface2:expansion-receipt-policy-version *r2s2*)))
(kv "S2-STORED-GRAMMAR-VERSION-BEFORE   [receipt-stored]" (getf *s2-stored-before* :grammar))
(kv "S2-STORED-PROCEDURE-VERSION-BEFORE [receipt-stored]" (getf *s2-stored-before* :procedure))
(kv "S2-STORED-POLICY-VERSION-BEFORE    [receipt-stored]" (getf *s2-stored-before* :policy))
(probe-check "C6-S2-STEP-1-STORED-VERSIONS-PRESENT" "C6/S2 step 1: all three stored versions are present and are integers"
             (and (integerp (getf *s2-stored-before* :grammar))
                  (integerp (getf *s2-stored-before* :procedure))
                  (integerp (getf *s2-stored-before* :policy))))

;;; ---- STEP 2 --------------------------------------------------------------
(step-line "C6-S2-STEP-2" "capture live procedure and policy identities (declaration and receipt reader)")
(defparameter *s2-live-before*
  (list :decl-procedure (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:surface2-procedure-identity))
        :decl-policy    (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:surface2-policy-identity))
        :read-procedure (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:expansion-receipt-procedure-identity *r2s2*))
        :read-policy    (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:expansion-receipt-policy-identity *r2s2*))
        :live-grammar-version   (lisp-plus-surface2:surface2-grammar-version)
        :live-procedure-version (lisp-plus-surface2:surface2-procedure-version)
        :live-policy-version    (lisp-plus-surface2:surface2-policy-version)))
(kv "S2-LIVE-PROCEDURE-IDENTITY-BEFORE  [provider-current-declaration]" (getf *s2-live-before* :decl-procedure))
(kv "S2-LIVE-POLICY-IDENTITY-BEFORE     [provider-current-declaration]" (getf *s2-live-before* :decl-policy))
(kv "S2-RECEIPT-PROCEDURE-IDENTITY-BEFORE [provider-current-declaration]" (getf *s2-live-before* :read-procedure))
(kv "S2-RECEIPT-POLICY-IDENTITY-BEFORE    [provider-current-declaration]" (getf *s2-live-before* :read-policy))
(kv "S2-LIVE-GRAMMAR-VERSION-BEFORE   [provider-current-declaration]" (getf *s2-live-before* :live-grammar-version))
(kv "S2-LIVE-PROCEDURE-VERSION-BEFORE [provider-current-declaration]" (getf *s2-live-before* :live-procedure-version))
(kv "S2-LIVE-POLICY-VERSION-BEFORE    [provider-current-declaration]" (getf *s2-live-before* :live-policy-version))

(defparameter *s2-ids-before*
  (list :receipt    (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-identity *r2s2*))
        :source     (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-source-form-identity *r2s2*))
        :occurrence (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-occurrence-identity *r2s2*))))
(kv "S2-RECEIPT-IDENTITY-BEFORE" (getf *s2-ids-before* :receipt))
(kv "S2-SOURCE-IDENTITY-BEFORE" (getf *s2-ids-before* :source))
(kv "S2-OCCURRENCE-IDENTITY-BEFORE" (getf *s2-ids-before* :occurrence))

;;; VERIFY-RECEIPT, captured before the redefinition.  Its provenance class is
;;; provider-recomputation: it re-derives the STORED source-form and
;;; expanded-form identity projections from the STORED datums.  It consults no
;;; live grammar/procedure/policy declaration at all.
(defparameter *s2-verify-before* (lisp-plus-surface2:verify-receipt *r2s2*))
(kv "S2-VERIFY-RECEIPT-BEFORE [provider-recomputation]" *s2-verify-before*)

;;; ---- STEPS 3 and 4 -------------------------------------------------------
(step-line "C6-S2-STEP-3" "redefine ALL THREE public version declarations")
(arm "PLANTED" "S2 SURFACE2-GRAMMAR-VERSION / -PROCEDURE-VERSION / -POLICY-VERSION")
(setf (fdefinition 'lisp-plus-surface2:surface2-grammar-version) (lambda () 95))
(setf (fdefinition 'lisp-plus-surface2:surface2-procedure-version) (lambda () 97))
(setf (fdefinition 'lisp-plus-surface2:surface2-policy-version) (lambda () 94))

(step-line "C6-S2-STEP-4" "redefine BOTH public procedure/policy identity declarations")
(arm "PLANTED" "S2 SURFACE2-PROCEDURE-IDENTITY / SURFACE2-POLICY-IDENTITY")
(setf (fdefinition 'lisp-plus-surface2:surface2-procedure-identity)
      (lambda () (lisp-plus-cd0:make-identifier-datum
                  '("surface-account-0-probe" "redefined-s2-procedure") '("c6"))))
(setf (fdefinition 'lisp-plus-surface2:surface2-policy-identity)
      (lambda () (lisp-plus-cd0:make-identifier-datum
                  '("surface-account-0-probe" "redefined-s2-policy") '("c6"))))

;;; ---- STEP 5: THE TOOTH ---------------------------------------------------
(step-line "C6-S2-STEP-5" "prove the live values ACTUALLY MOVED (the tooth; nothing is concluded before it)")
(defparameter *s2-live-after*
  (list :decl-procedure (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:surface2-procedure-identity))
        :decl-policy    (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:surface2-policy-identity))
        :read-procedure (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:expansion-receipt-procedure-identity *r2s2*))
        :read-policy    (lisp-plus-surface2:render-identity-hex
                         (lisp-plus-surface2:expansion-receipt-policy-identity *r2s2*))
        :live-grammar-version   (lisp-plus-surface2:surface2-grammar-version)
        :live-procedure-version (lisp-plus-surface2:surface2-procedure-version)
        :live-policy-version    (lisp-plus-surface2:surface2-policy-version)))
(kv "S2-LIVE-GRAMMAR-VERSION-AFTER   [provider-current-declaration]" (getf *s2-live-after* :live-grammar-version))
(kv "S2-LIVE-PROCEDURE-VERSION-AFTER [provider-current-declaration]" (getf *s2-live-after* :live-procedure-version))
(kv "S2-LIVE-POLICY-VERSION-AFTER    [provider-current-declaration]" (getf *s2-live-after* :live-policy-version))
(kv "S2-LIVE-PROCEDURE-IDENTITY-AFTER [provider-current-declaration]" (getf *s2-live-after* :decl-procedure))
(kv "S2-LIVE-POLICY-IDENTITY-AFTER    [provider-current-declaration]" (getf *s2-live-after* :decl-policy))
(probe-check "C6-S2-STEP-5-LIVE-VERSIONS-MOVED" "C6/S2 step 5 TOOTH BITES: all THREE live version declarations moved"
             (and (not (eql (getf *s2-live-before* :live-grammar-version)
                            (getf *s2-live-after* :live-grammar-version)))
                  (not (eql (getf *s2-live-before* :live-procedure-version)
                            (getf *s2-live-after* :live-procedure-version)))
                  (not (eql (getf *s2-live-before* :live-policy-version)
                            (getf *s2-live-after* :live-policy-version)))))
(probe-check "C6-S2-STEP-5-LIVE-IDENTITIES-MOVED" "C6/S2 step 5 TOOTH BITES: BOTH live identity declarations moved"
             (and (not (string= (getf *s2-live-before* :decl-procedure)
                                (getf *s2-live-after* :decl-procedure)))
                  (not (string= (getf *s2-live-before* :decl-policy)
                                (getf *s2-live-after* :decl-policy)))))

;;; ---- STEP 6 --------------------------------------------------------------
(step-line "C6-S2-STEP-6" "prove the old receipt retains all three stored versions")
(defparameter *s2-stored-after*
  (list :grammar   (lisp-plus-surface2:expansion-receipt-grammar-version *r2s2*)
        :procedure (lisp-plus-surface2:expansion-receipt-procedure-version *r2s2*)
        :policy    (lisp-plus-surface2:expansion-receipt-policy-version *r2s2*)))
(kv "S2-STORED-GRAMMAR-VERSION-AFTER   [receipt-stored]" (getf *s2-stored-after* :grammar))
(kv "S2-STORED-PROCEDURE-VERSION-AFTER [receipt-stored]" (getf *s2-stored-after* :procedure))
(kv "S2-STORED-POLICY-VERSION-AFTER    [receipt-stored]" (getf *s2-stored-after* :policy))
(probe-check "C6-S2-STEP-6-STORED-VERSIONS-HISTORICAL" "C6/S2 step 6: all THREE stored versions retain HISTORICAL standing"
             (and (eql (getf *s2-stored-before* :grammar) (getf *s2-stored-after* :grammar))
                  (eql (getf *s2-stored-before* :procedure) (getf *s2-stored-after* :procedure))
                  (eql (getf *s2-stored-before* :policy) (getf *s2-stored-after* :policy))))
(probe-check "C6-S2-STEP-6-STORED-DISAGREE-WITH-LIVE" "C6/S2 step 6: and they now DISAGREE with the live declarations, which is the point"
             (and (not (eql (getf *s2-stored-after* :grammar) (getf *s2-live-after* :live-grammar-version)))
                  (not (eql (getf *s2-stored-after* :procedure) (getf *s2-live-after* :live-procedure-version)))
                  (not (eql (getf *s2-stored-after* :policy) (getf *s2-live-after* :live-policy-version)))))

;;; ---- STEP 7 --------------------------------------------------------------
(step-line "C6-S2-STEP-7" "prove the old receipt / source / occurrence identities do not move")
(defparameter *s2-ids-after*
  (list :receipt    (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-identity *r2s2*))
        :source     (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-source-form-identity *r2s2*))
        :occurrence (lisp-plus-surface2:render-identity-hex
                     (lisp-plus-surface2:expansion-receipt-occurrence-identity *r2s2*))))
(kv "S2-RECEIPT-IDENTITY-AFTER" (getf *s2-ids-after* :receipt))
(kv "S2-SOURCE-IDENTITY-AFTER" (getf *s2-ids-after* :source))
(kv "S2-OCCURRENCE-IDENTITY-AFTER" (getf *s2-ids-after* :occurrence))
(probe-check "C6-S2-STEP-7-RECEIPT-IDENTITY-STABLE" "C6/S2 step 7: the receipt identity did not move"
             (string= (getf *s2-ids-before* :receipt) (getf *s2-ids-after* :receipt)))
(probe-check "C6-S2-STEP-7-SOURCE-IDENTITY-STABLE" "C6/S2 step 7: the source-form identity did not move"
             (string= (getf *s2-ids-before* :source) (getf *s2-ids-after* :source)))
(probe-check "C6-S2-STEP-7-OCCURRENCE-IDENTITY-STABLE" "C6/S2 step 7: the occurrence identity did not move"
             (string= (getf *s2-ids-before* :occurrence) (getf *s2-ids-after* :occurrence)))

;;; VERIFY-RECEIPT after the redefinition.  ITS CONTINUED T IS A DEMONSTRATION
;;; OF DECLARATION-INDEPENDENCE, and the R0 reading of this same observation —
;;; that the verifier "recomputes against live declarations", an inherited
;;; identity trap — is WITHDRAWN under the owner's ruling.  What VERIFY-RECEIPT
;;; does is bounded re-derivation of the STORED source-form and expanded-form
;;; identity projections from the STORED datums.  Redefining every version and
;;; identity declaration in the image moves nothing it reads; that is why it
;;; still returns T, and that is a property of the verifier, not a leak.
(defparameter *s2-verify-after* (lisp-plus-surface2:verify-receipt *r2s2*))
(kv "S2-VERIFY-RECEIPT-AFTER [provider-recomputation]" *s2-verify-after*)
(probe-check "C6-S2-VERIFY-RECEIPT-PROVIDER-RECOMPUTATION" "C6/S2 VERIFY-RECEIPT [provider-recomputation]: still T after every version and identity declaration moved — DECLARATION-INDEPENDENCE, not inherited exposure"
             (and *s2-verify-before* *s2-verify-after*))

;;; ---- STEP 8 --------------------------------------------------------------
(step-line "C6-S2-STEP-8" "mint a new receipt and prove it stores the moved versions")
(arm "CLEAN" "a NEW S2 receipt minted after the redefinition")
(defparameter *s2-new*
  (lisp-plus-surface2:perform-expansion
   (lisp-plus-surface2:request-expansion
    (read-fixture *match-text*) :macroexpand-1 (tag-for "c6-s2-after"))))
(kv "S2-NEW-STORED-GRAMMAR-VERSION   [receipt-stored]"
    (lisp-plus-surface2:expansion-receipt-grammar-version *s2-new*))
(kv "S2-NEW-STORED-PROCEDURE-VERSION [receipt-stored]"
    (lisp-plus-surface2:expansion-receipt-procedure-version *s2-new*))
(kv "S2-NEW-STORED-POLICY-VERSION    [receipt-stored]"
    (lisp-plus-surface2:expansion-receipt-policy-version *s2-new*))
(kv "S2-NEW-RECEIPT-IDENTITY"
    (lisp-plus-surface2:render-identity-hex
     (lisp-plus-surface2:expansion-receipt-identity *s2-new*)))
(probe-check "C6-S2-STEP-8-NEW-RECEIPT-STORES-MOVED-VERSIONS" "C6/S2 step 8: the new receipt stores ALL THREE moved versions (95 / 97 / 94)"
             (and (eql 95 (lisp-plus-surface2:expansion-receipt-grammar-version *s2-new*))
                  (eql 97 (lisp-plus-surface2:expansion-receipt-procedure-version *s2-new*))
                  (eql 94 (lisp-plus-surface2:expansion-receipt-policy-version *s2-new*))))
(probe-check "C6-S2-STEP-8-OLD-AND-NEW-DISTINCT" "C6/S2 step 8: the old and the new receipt are different objects with different identities"
             (not (string= (getf *s2-ids-before* :receipt)
                           (lisp-plus-surface2:render-identity-hex
                            (lisp-plus-surface2:expansion-receipt-identity *s2-new*)))))

;;; ---- STEP 9 --------------------------------------------------------------
(step-line "C6-S2-STEP-9" "synthesize no mint-time procedure/policy identity")
(kv "S2-RECEIPT-PROCEDURE-IDENTITY-AFTER [provider-current-declaration]" (getf *s2-live-after* :read-procedure))
(kv "S2-RECEIPT-POLICY-IDENTITY-AFTER    [provider-current-declaration]" (getf *s2-live-after* :read-policy))
(probe-check "C6-S2-STEP-9-READERS-EQUAL-LIVE-BEFORE" "C6/S2 step 9(a): the receipt's identity readers equal the LIVE declaration BEFORE the redefinition"
             (and (string= (getf *s2-live-before* :read-procedure) (getf *s2-live-before* :decl-procedure))
                  (string= (getf *s2-live-before* :read-policy) (getf *s2-live-before* :decl-policy))))
(probe-check "C6-S2-STEP-9-READERS-EQUAL-LIVE-AFTER" "C6/S2 step 9(a): and STILL equal the LIVE declaration AFTER it — no stored mint-time identity"
             (and (string= (getf *s2-live-after* :read-procedure) (getf *s2-live-after* :decl-procedure))
                  (string= (getf *s2-live-after* :read-policy) (getf *s2-live-after* :decl-policy))))
(probe-check "C6-S2-STEP-9-OLD-RECEIPT-NOT-RECOMPUTED" "C6/S2 step 9(b): nothing was recomputed INTO the old receipt — its own identity is unchanged (step 7)"
             (string= (getf *s2-ids-before* :receipt) (getf *s2-ids-after* :receipt)))
(p "  C6-S2-STEP-9-READING: the same shape as S1.  Procedure/policy VERSIONS are")
(p "  stored as values; procedure/policy IDENTITIES are not stored at all, and")
(p "  the receipt's readers for them are projections of the live declaration.")
(p "END-C6-PROVIDER S2")

(rule)
(p "LIMITATION, RECORDED HONESTLY:")
(p "  The seam exercised is (SETF FDEFINITION) on the providers' PUBLIC external")
(p "  declaration names, in a throwaway child.  It is the strongest redefinition")
(p "  seam the public APIs offer.  It does NOT simulate a source-level version")
(p "  bump, a reload, or a different build, and nothing here licenses a claim")
(p "  about how either provider behaves across those.  One image, one occurrence.")
(p "  The nine steps are asserted for these two providers at this parcel tip;")
(p "  they are not a law about accounts in general.")

(when (plant-failure-requested-p)
  (p "  !! PLANTED FAILURE ARM ACTIVE — the next check is deliberately false")
  (probe-check "CONTROLS-B-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

(probe-footer "CONTROLS-B")
(probe-exit)
