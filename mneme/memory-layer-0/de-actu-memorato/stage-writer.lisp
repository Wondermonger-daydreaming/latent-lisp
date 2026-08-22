;;;; stage-writer.lisp — THE SCRIPTOR: the process that acts, and then writes
;;;; down what it is entitled to say about having acted.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation.  It:
;;;; creates the declared act store, world, and account store · commits the
;;;; seats' grants · performs THREE acts through One Act /1's public seam (one
;;;; that settles, one that is lawfully refused with GENUINELY ISSUED evidence,
;;;; and one unrelated act whose provenance the cross-identity refusal will try to
;;;; smuggle) · writes the memory accounts · and exits.
;;;;
;;;; WHAT DIES WITH IT, said plainly: the Core /0 evidence accounts this process
;;;; holds — the in-image record of what it did — are gone the moment it exits.
;;;; They were never durable and this lane does not pretend otherwise.  What
;;;; survives is exactly what was written into the ACCOUNT STORE, and the whole
;;;; question of this specimen is whether that is worth anything and whether it
;;;; claims more than it is worth.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *account-directory* (pathname (third *arguments*)))
(defvar *run-directory* (pathname (fourth *arguments*)))

(vnote "scriptor: act store · world · ACCOUNT STORE · three acts · the accounts ~
this process is entitled to write")

(memorato-act-ground *store-directory* *world-directory*)
(memorato-account-ground *account-directory*)

(vcheck "both stores' derived identities EQUAL the identities derived from the ~
declared configuration alone — the act journal and the account store are ~
DIFFERENT stores, in different directories, with different nonces"
        (lambda ()
          (and (string= (journal-store-store-id *ml0-act-store*)
                        (expected-store-id *act-nonce-16*))
               (string= (journal-store-store-id *ml0-account-store*)
                        (expected-store-id *account-nonce*))
               (not (string= (journal-store-store-id *ml0-act-store*)
                             (journal-store-store-id *ml0-account-store*))))))

(defvar *memorable* (the-memorable-row))
(defvar *refused* (the-refused-row))
(defvar *other* (the-other-row))
(setf lisp-plus-language-act1:*act1-fixture-table*
      (list *memorable* *refused* *other*))
(ml0-open-authority (list *memorable* *refused* *other*))

;;; ---------------------------------------------------------------------------
;;; ACT 1 — the memorable act.  It settles.

(defvar *memorable-result*
  (lisp-plus-language-act1:run-act1 *memorable* :verbose nil))
(defvar *memorable-id* (nth-value 0 (ml0-rederive-act-identity *memorable*)))

(vcheck "the memorable act SETTLED through One Act /1's public seam, and the ~
world durably holds a ledger row under its derived external-request identity"
        (lambda ()
          (and (eq :settled (lisp-plus-language-act1:act1-result-class
                             *memorable-result*))
               (= 1 (world-ledger-count
                     (ml0-world)
                     (lisp-plus-language-act1:external-request-key
                      *memorable-attempt*))))))

(vnote "memorable act identity ~a"
       (lisp-plus-journal0:identifier-segment-string *memorable-id*))

;;; ---------------------------------------------------------------------------
;;; ACT 2 — the lawfully refused act, with GENUINELY ISSUED evidence.

(defvar *frames-before-refusal* (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
(defvar *world-before-refusal*
  (lisp-plus-language-act1:take-world-scope
   (ml0-world) (ml0-world-directory)
   :request-key (lisp-plus-language-act1:external-request-key *refused-attempt*)))
(defvar *refused-result* (lisp-plus-language-act1:run-act1 *refused* :verbose nil))
(defvar *world-after-refusal*
  (lisp-plus-language-act1:take-world-scope
   (ml0-world) (ml0-world-directory)
   :request-key (lisp-plus-language-act1:external-request-key *refused-attempt*)))
(defvar *refused-id* (nth-value 0 (ml0-rederive-act-identity *refused*)))
(defvar *refused-evidence*
  (lisp-plus-language-act1:act1-result-evidence *refused-result*))

(vcheck "THE DANGEROUS ARTIFACT, MADE LAWFULLY: a pre-frontier refusal issued a ~
GENUINE Core /0 evidence account bound to this act's canonical request — AND the ~
act did not happen, by three independent instruments (journal frame count ~
unmoved, derived standing :ABSENT, world byte-unchanged across the whole ~
declared universe)"
        (lambda ()
          (and (lisp-plus-core0:core0-evidence-current-image-issued-p *refused-evidence*)
               (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
                *refused-evidence*
                (lisp-plus-language-act1:act1-record-normal-form
                 (lisp-plus-language-act1:act1-result-record *refused-result*)))
               (eql *frames-before-refusal*
                    (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
               (eq :absent (derive-effect-standing *ml0-act-store* *refused-attempt*))
               (lisp-plus-language-act1:world-scope-unchanged-p
                *world-before-refusal* *world-after-refusal*))))

;;; ---------------------------------------------------------------------------
;;; ACT 3 — a genuinely different act, for the cross-identity refusal.

(defvar *other-result* (lisp-plus-language-act1:run-act1 *other* :verbose nil))
(defvar *other-id* (nth-value 0 (ml0-rederive-act-identity *other*)))

;;; ---------------------------------------------------------------------------
;;; THE ACCOUNTS.

(defvar *memorable-account*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *memorable*
              :claimed-act-id *memorable-id*
              :subject-principal *scriptor-process*
              ;; ⚑ R3: THE WARRANT-BEARING ROWS TRAVEL THROUGH `:OBSERVATIONS`,
              ;; which after the second repair round is the ONLY channel that
              ;; carries a warrant into a bundle.  `:sources` is normalized to
              ;; testimony whatever arrives there — so the self-report goes on
              ;; carrying exactly what it always could, which is nothing.
              :observations
              (list (ml0-world-observation *memorable-id* *memorable-attempt*)
                    (ml0-journal-observation *memorable-id* *memorable-attempt*))
              :sources (list (ml0-self-report-source
                              *memorable-id*
                              "the writing process read both instruments itself"))
              ;; ⚠ THE ISSUANCE STANDING IS A READING, NOT A CHOICE — repaired
              ;; 2026-08-20.  The DOOR asks Core /0's live conjoined predicate and
              ;; the standing is derived from its answer; this process no longer
              ;; gets to name it.  The ceiling is unchanged and still travels:
              ;; the predicate answers about THIS image only, and in any other
              ;; process it answers false for every input — which is why no reader
              ;; may ever quote the result flat as `issued`.
              :issuance-observation (ml0-issuance-observation-for *memorable-id*
                                                                  *memorable-result*)
              :effect-observation (ml0-effect-observation-of *memorable-attempt*))
             :recording-process *scriptor-process*))

(vcheck "D1 (write half) — the memorable act's account reads :OCCURRED, warranted ~
by the INDEPENDENT basis, with issuance reported on its own separate axis as ~
:ISSUED-IN-WRITING-IMAGE"
        (lambda ()
          (and (ml0-account-occurred-p *memorable-account*)
               (eq :issued-in-writing-image
                   (ml0-account-issuance-standing *memorable-account*))
               (some (lambda (s) (and (ml0-species-may-warrant-occurrence-p
                                       (ml0-source-species s))
                                      (eq :frontier-crossed-for-this-identity
                                          (ml0-source-attests s))))
                     (ml0-account-sources *memorable-account*)))))

;;; The crown negative's account: the genuinely-issued evidence, PRESENTED AS
;;; THOUGH IT WARRANTED OCCURRENCE, with every non-species conjunct over-claimed.
(defvar *crown-source*
  (nth-value 1 (ml0-single-delta-pair *refused-id* *refused-attempt*
                                      *refused-evidence*)))
(defvar *crown-account*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *refused*
              :claimed-act-id *refused-id*
              :subject-principal *scriptor-process*
              :sources (list *crown-source*)
              :issuance-observation (ml0-issuance-observation-for *refused-id* *refused-result*)
              :effect-observation (ml0-effect-observation-of *refused-attempt*))
             :recording-process *scriptor-process*))

(vcheck "D2 arm (a), write half — the over-claiming issuance bundle is stored as ~
ISSUANCE-ONLY with occurrence :UNRESOLVED, and the rule's refusal names leg ~
SPECIES [ML0-PROMOTE-1] with all seven other legs satisfied"
        (lambda ()
          (multiple-value-bind (ok source reason conjuncts)
              (ml0-occurrence-warranted-p *refused-id* (list *crown-source*))
            (declare (ignore source))
            (multiple-value-bind (leg requirement) (ml0-failing-leg conjuncts)
              (and (not ok)
                   ;; ⚑ THE ROW IS DOOR-VALIDATED — leg 0 HOLDS — and it is still
                   ;; refused, on SPECIES.  That is the sharper statement after the
                   ;; repair: the issuance reading is a genuine observation by a
                   ;; genuine door, and a genuine observation of an issuance still
                   ;; cannot warrant an occurrence.
                   (ml0-source-warranting-validation-p *crown-source*)
                   (cdr (assoc :validation conjuncts))
                   (eq :species leg)
                   (equal "ML0-PROMOTE-1" requirement)
                   (= 7 (count-if #'cdr conjuncts))
                   (search "SPECIES" reason)
                   (not (ml0-account-occurred-p *crown-account*))
                   (ml0-account-issuance-only-p *crown-account*)
                   (eq :unresolved
                       (ml0-account-occurrence-standing *crown-account*)))))))

(vnote "D2 conjunct table, written into this capture so the answer is a fact and ~
not an inference:")
(ml0-print-conjuncts "the crown negative's over-claiming issuance bundle"
                     *refused-id* *crown-source*)

;;; D5 / D2 arm (b) — the cross-identity refusal, PRE-MUTATION.
(defvar *store-before-crossing* (ml0-take-store-scope *ml0-account-root*))
(defvar *accounts-before-crossing*
  (length (ml0-list-account-ids *ml0-account-store*)))
(defvar *crossing-refused*
  (handler-case
      (progn (ml0-write *ml0-account-store*
                        (make-ml0-bundle
                         :fixture-row *memorable*
                         :claimed-act-id *memorable-id*
                         :subject-principal *scriptor-process*
                         :sources (list (ml0-world-source *other-id* *other-attempt*)))
                        :recording-process *scriptor-process*)
             nil)
    (ml0-subject-identity-mismatch (c)
      (equal "ML0-WR-4" (ml0-condition-requirement-id c)))))

(vcheck "D5 — an occurrence basis genuinely belonging to a DIFFERENT act, ~
presented in this act's bundle, is refused BEFORE any durable mutation: the ~
whole account store is byte-unchanged and no account was appended"
        (lambda ()
          (and *crossing-refused*
               (ml0-store-scope-unchanged-p
                *store-before-crossing*
                (ml0-take-store-scope *ml0-account-root*))
               (= *accounts-before-crossing*
                  (length (ml0-list-account-ids *ml0-account-store*))))))

;;; the same-shape MATCHING control, which must SUCCEED.
(defvar *other-account*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *other*
              :claimed-act-id *other-id*
              :subject-principal *scriptor-process*
              :observations (list (ml0-world-observation *other-id* *other-attempt*)))
             :recording-process *scriptor-process*))

(vcheck "D5 control — the SAME SHAPE with all identities matching SUCCEEDS and ~
reads :OCCURRED, so a blanket refusal cannot pass for the row above"
        (lambda () (ml0-account-occurred-p *other-account*)))

;;; ---------------------------------------------------------------------------
;;; The index the reader will use to ASK for accounts.  It carries identities,
;;; never standings: everything the reader concludes, it concludes from bytes.

(memorato-record-accounts
 *run-directory*
 (list (cons "memorable" (ml0-account-id-hex *memorable-account*))
       (cons "crown" (ml0-account-id-hex *crown-account*))
       (cons "other" (ml0-account-id-hex *other-account*))))

(vnote "accounts written: memorable ~a · crown ~a · other ~a"
       (subseq (ml0-account-id-hex *memorable-account*) 0 16)
       (subseq (ml0-account-id-hex *crown-account*) 0 16)
       (subseq (ml0-account-id-hex *other-account*) 0 16))
(vnote "this process now exits.  Its Core /0 evidence accounts — the in-image ~
record of what it did — die with it, by design.  Everything the next process can ~
know is in the three durable stores and in the declared configuration.")

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
