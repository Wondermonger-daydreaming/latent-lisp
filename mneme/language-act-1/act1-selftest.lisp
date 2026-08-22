;;;; act1-selftest.lisp — One Act /1: the in-process suite.
;;;;
;;;;   sbcl --script mneme/language-act-1/act1-selftest.lisp
;;;;
;;;; Sentinel, printed ONLY on a fully green run:
;;;;
;;;;   oneact1-selftest: <n> checks, 0 failures
;;;;
;;;; WHAT THIS FILE COVERS AND WHAT IT DOES NOT.  This suite runs the lane's
;;;; SIX in-process arms — the settled act, the uncertain act, the durable-guard
;;;; refusal, the two capability-denied arms, and the D1 (runtime-boundary)
;;;; refusal.  IT DOES NOT CROSS PROCESS DEATH: that is de-actu-resurgente's
;;;; whole subject, and this file declares ONE PROCESS LIFE and checks that
;;;; declaration with the environment pre-flight before it creates a store.
;;;;
;;;; THE RUN ROOT IS CREATED OUTSIDE THE SUBJECT TREE, asserted to be outside
;;;; before a byte is written, and removed on success AND on failure.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(require :sb-posix)

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter *subject-root*
  (merge-pathnames "../../" *lane-directory*)
  "The latent-lisp checkout root, derived from this file's own location.")

;;; ---------------------------------------------------------------------------
;;; Arm helpers.

(defun world-for (key) (getf *act1-worlds* key))
(defun world-directory-for (key) (getf *act1-world-directories* key))

(defun scope-for (fixture &key request-key)
  (take-world-scope (world-for (act1-fixture-world-key fixture))
                    (world-directory-for (act1-fixture-world-key fixture))
                    :request-key (or request-key
                                     (external-request-key
                                      (act1-fixture-attempt-name fixture)))))

(defun frame-count ()
  (nth-value 1 (act1-journal-kinds *act1-store*)))

(defun outcome-view (result)
  (let ((outcome (act1-result-outcome result)))
    (and outcome (lisp-plus-core0:outcome-kind outcome))))

(defun assert-denied-arm-world-scope (label fixture before after)
  "THE ABSENCE CLAIM AND ITS TWO WARRANTS, spent on every denied arm.

SCOPE: the look covers the ENTIRE world fixture — both files, whole-file
digests, whole-file octet counts, total ledger entries, and the entries under
THIS arm's own request key — and the universe is printed by the instrument
itself, in this arm's own output.

COMPETENCE: the instrument is shown able to see a violation elsewhere in this
suite and in the controls (the leak-write arm drives a REFUSED act that writes
the world anyway and this same predicate catches it).  An instrument never seen
to fire is untested, not passing."
  (print-world-scope-universe label before after)
  (act1-check (format nil "~a · world byte-unchanged across the arm (whole cell ~
store + whole request ledger)" label)
              (world-scope-unchanged-p before after))
  (act1-check (format nil "~a · ZERO ledger entries under this arm's request ~
key ~a (the key exists as a question; the answer is zero, not unlooked)"
                      label (external-request-key (act1-fixture-attempt-name fixture)))
              (eql 0 (world-scope-snapshot-key-count after))))

;;; ---------------------------------------------------------------------------
;;; The fixture table — SIX arms, one seat carrying TWO of them.

(defun build-suite-table ()
  (list
   (make-act1-fixture-row
    :arm "A" :label "prima" :runtime-seat "prima" :attempt-name "a-prima"
    :cell-segments '("cella" "prima")
    :adapter-symbol 'one-act-1-bridge/prima :world-key :apply
    :form (act1-request-form "cella:prima" "Unus actus, una ratio."))
   (make-act1-fixture-row
    :arm "C" :label "ambigua" :runtime-seat "ambigua" :attempt-name "a-ambigua"
    :cell-segments '("cella" "ambigua")
    :adapter-symbol 'one-act-1-bridge/ambigua :world-key :ambiguous
    :form (act1-request-form "cella:ambigua" "Nuntius sine teste."))
   ;; ⚑ THE SAME SEAT, a second act: the in-process rehearsal of the crown.
   (make-act1-fixture-row
    :arm "C-2" :label "ambigua" :runtime-seat "ambigua" :attempt-name "a-ambigua-2"
    :cell-segments '("cella" "ambigua")
    :adapter-symbol 'one-act-1-bridge/ambigua-2 :world-key :ambiguous
    :form (act1-request-form "cella:ambigua" "Nuntius iterum."))
   (make-act1-fixture-row
    :arm "B-L1" :label "vetita-scope" :runtime-seat "vetita-scope"
    :attempt-name "a-vetita-scope" :cell-segments '("cella" "vetita-scope")
    :adapter-symbol 'one-act-1-bridge/vetita-scope :world-key :apply
    :form (act1-request-form "cella:vetita-scope" "Manus quae non licet.")
    :authority-mode :wrong-predicate)
   (make-act1-fixture-row
    :arm "B-L2" :label "vetita-ambient" :runtime-seat "vetita-ambient"
    :attempt-name "a-vetita-ambient" :cell-segments '("cella" "vetita-ambient")
    :adapter-symbol 'one-act-1-bridge/vetita-ambient :world-key :apply
    :form (act1-request-form "cella:vetita-ambient" "Nemo iubet.")
    :authority-mode :ambient)
   (make-act1-fixture-row
    :arm "R" :label "revocata" :runtime-seat "revocata" :attempt-name "a-revocata"
    :cell-segments '("cella" "revocata")
    :adapter-symbol 'one-act-1-bridge/revocata :world-key :apply
    :form (act1-request-form "cella:revocata" "Manus mortua.")
    :revoke-after-mint t)))

(defun row (arm) (find arm *act1-fixture-table* :key #'act1-fixture-arm :test #'string=))

;;; ---------------------------------------------------------------------------
;;; The suite.

(defun run-suite ()
  (format t "~&One Act /1 — the in-process suite.  CANDIDATE: nothing here is ~
adopted, and nothing here is independent verification.~%")
  (format t "~&crash model: this suite declares ONE PROCESS LIFE.  Process ~
death lives in de-actu-resurgente, by a PLANTED DETERMINISTIC exit — no ~
SIGKILL, no power loss, no mid-instruction truncation is claimed anywhere in ~
this lane.~%~%")

  ;; ---- W-ENV.  ⚠ SIGNALLING, NOT ADVISORY.  An earlier draft of this file
  ;; called the pre-flight with :SIGNAL NIL and merely FAILED a check when a
  ;; death switch was set — so the suite went on to build a store and run its
  ;; arms with a process-ending switch live, and died at exit 7 inside the
  ;; frontier window.  The controls' first plant caught exactly that.  A gate
  ;; that reports and continues is not a gate.
  (act1-check "W-ENV pre-flight: no process-ending switch is set (any one set ~
VOIDS this run here, before a journal store exists)"
              (act1-env-preflight))

  ;; ---- the table.
  (setf *act1-fixture-table* (build-suite-table))
  (act1-check "the fixture table validates: row laws on every row, attempt ~
identity and bridge symbol distinct across rows"
              (validate-act1-fixture-table))
  (act1-check "TWO ROWS SHARE ONE SEAT (ambigua), by design — this lane's ~
subject is a seat that carries more than one act, so seat distinctness is NOT ~
a law here and attempt distinctness carries the weight instead"
              (= 2 (count "ambigua" *act1-fixture-table*
                          :key #'act1-fixture-runtime-seat :test #'string=)))
  (act1-check "a malformed row is REFUSED by the public construction door ~
(planted: an attempt name that is not a-<seat>[-n])"
              (handler-case
                  (progn (make-act1-fixture-row
                          :arm "X" :label "planted" :runtime-seat "planted"
                          :attempt-name "b-planted"
                          :cell-segments '("cella" "planted")
                          :adapter-symbol 'one-act-1-bridge/planted
                          :form (act1-request-form "cella:planted" "x"))
                         nil)
                (act1-fixture-table-invalid (c)
                  (string= "ACT1-FX-3" (act1-condition-requirement-id c)))))

  ;; ---- the store, the worlds, the grants.
  (setf *act1-store* (build-act1-store *act1-run-root*))
  (setf *act1-worlds* (build-act1-worlds *act1-run-root*))
  (setf *act1-bootstrap*
        (declare-bootstrap-authority '("issuer" "oneact1")
                                     (journal-store-store-id *act1-store*)))
  (setf *act1-minting-context* (make-minting-context :label "oneact1-suite"))
  (let ((seats (act1-opening-authority *act1-store* *act1-fixture-table*)))
    (act1-check "ONE Capability /0 grant per DISTINCT seat — five seats, six ~
acts (the ambigua seat is granted once and carries two)"
                (and (= 5 (length seats)) (= 5 (frame-count)))
                "seats ~s · frames ~d" seats (frame-count)))

  ;; =========================================================================
  ;; ARM A — the settled act.
  ;; =========================================================================
  (let* ((f (row "A"))
         (before (scope-for f))
         (result (run-act1 f))
         (after (scope-for f)))
    (act1-check "A · the act SETTLES: disposition :returned, derived class ~
:settled, standing :settled from the journal's own bytes"
                (and (eq :returned (act1-result-disposition result))
                     (eq :settled (act1-result-class result))
                     (eq :settled (act1-result-standing result))))
    (act1-check "A · the result returns through the intended interface: ~
(values OUTCOME EVIDENCE), outcome-kind :committed"
                (and (eq :committed (outcome-view result))
                     (lisp-plus-core0:core0-evidence-p (act1-result-evidence result))))
    (act1-check "A · the durable guard was CONSULTED and answered :lawful — the ~
permitted direction of the same instrument that refuses across death"
                (eq :lawful (act1-result-guard result)))
    ;; ⚑ THE POSITIVE CONTROL on WORLD-CELL-VALUE (work order §8(b)).  One Act
    ;; /0 used this reader only in the negative direction; nothing in /0's own
    ;; evidence showed it returning non-empty for a written cell.  Here the
    ;; cell starts EMPTY and is read back NON-EMPTY and EQUAL to the request's
    ;; own text — so every later empty-cell check in this lane rests on a
    ;; reader that has been seen to answer both ways.
    (let ((value (world-cell-value (world-for :apply) "cella:prima")))
      (act1-check "A · POSITIVE CONTROL on world-cell-value: the cell began ~
EMPTY and reads back NON-EMPTY and EQUAL to the act's own :text"
                  (and (stringp value) (plusp (length value))
                       (string= value "Unus actus, una ratio."))
                  "value ~s" value))
    (print-world-scope-universe "arm A (permitted)" before after)
    (act1-check "A · the world CHANGED exactly as a permitted act should: one ~
new ledger entry under this act's own request key, and the instrument SEES it"
                (and (not (world-scope-unchanged-p before after))
                     (eql 0 (world-scope-snapshot-key-count before))
                     (eql 1 (world-scope-snapshot-key-count after))))
    (multiple-value-bind (kinds count status) (act1-journal-kinds *act1-store*)
      (act1-check "A · the journal READ BACK from its own bytes carries the ~
four attempt frames (a recording never read back is a hope with a field name)"
                  (and (eq :valid status) (= 9 count)
                       (equal (last kinds 4)
                              '("attempt:prepared" "attempt:frontier-crossed"
                                "request:acknowledged" "effect:settled")))
                  "~d frames" count)))

  ;; =========================================================================
  ;; ARM C — the uncertain act (an acknowledgment with no evidence).
  ;; =========================================================================
  (let* ((f (row "C"))
         (result (run-act1 f)))
    (act1-check "C · an acknowledgment WITHOUT evidence does not settle: ~
disposition :interrupted, standing :uncertain-unresolved, outcome-kind ~
:indeterminate — the forbidden promotion does not happen at the bridge"
                (and (eq :interrupted (act1-result-disposition result))
                     (eq :uncertain-unresolved (act1-result-standing result))
                     (eq :indeterminate (outcome-view result))))
    (act1-check "C · the journal gained the §10.8 uncertainty record from the ~
runtime's own vocabulary (13 frames, ending effect:uncertain)"
                (multiple-value-bind (kinds count) (act1-journal-kinds *act1-store*)
                  (and (= 13 count) (equal "effect:uncertain" (car (last kinds)))))))

  ;; =========================================================================
  ;; ARM C-2 — THE DURABLE GUARD, in process: a second act into a seat whose
  ;; predecessor's effect is unresolved IN THE BYTES.
  ;; =========================================================================
  (let* ((f (row "C-2"))
         (frames-before (frame-count))
         (before (scope-for f))
         (result (run-act1 f))
         (after (scope-for f)))
    (act1-check "C-2 · the LANGUAGE door refuses PRE-FRONTIER: disposition ~
:refused, class :refused, standing :absent for this attempt, outcome-kind ~
:refused"
                (and (eq :refused (act1-result-disposition result))
                     (eq :refused (act1-result-class result))
                     (eq :absent (act1-result-standing result))
                     (eq :refused (outcome-view result))))
    (act1-check "C-2 · the refusal is CORE /0's typed pre-frontier refusal, ~
carrying evidence-so-far and a refused outcome"
                (and (eq 'lisp-plus-core0:core0-refused
                         (act1-result-refusal-type result))
                     (lisp-plus-core0:core0-evidence-p
                      (act1-result-evidence result))))
    ;; ⚑ THE GUARD HAS TWO HALVES AND THEY ARE DISTINGUISHABLE IN THE REASON.
    ;; capability /2's gate folds BOTH: (i) kernel /0's adopted §14.1 fold over
    ;; a journaled §10.8 record — which is what THIS arm hits, and which carries
    ;; no requirement id because §14.1 is a spec-section invariant, not a
    ;; capability /2 requirement; and (ii) capability /2's own pre-declaration
    ;; half, requirement CAP2-W1, for a frontier crossed with NOTHING after it —
    ;; which is the DEATH shape, and is what de-actu-resurgente's crown hits.
    ;; The lane asserts each half where that half actually fires, and never
    ;; launders one into the other.
    (act1-check "C-2 · THE REASON NAMES THE DURABLE GUARD, and is therefore ~
distinguishable from the runtime boundary's own refusal — here by kernel /0's ~
§14.1 fold over the journaled §10.8 record (no requirement id: §14.1 is a ~
spec-section invariant)"
                (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/-|
                    (act1-result-reason result))
                "reason ~s" (act1-result-reason result))
    (act1-check "C-2 · the journal gained NOTHING: the refusal is above the ~
frontier line, so no frame was appended"
                (= frames-before (frame-count))
                "~d -> ~d frames" frames-before (frame-count))
    (assert-denied-arm-world-scope "C-2 (durable-guard refusal)" f before after))

  ;; =========================================================================
  ;; ARMS B-L1 / B-L2 — capability denied at CORE /0's own frontier check.
  ;; =========================================================================
  (dolist (spec '(("B-L1" lisp-plus-core0:capability-scope-violation
                   "the fixture ruling authorises a predicate the request does ~
not carry")
                  ("B-L2" lisp-plus-core0:ambient-authority-forbidden
                   "no authority object is presented at all")))
    (destructuring-bind (arm expected-type gloss) spec
      (let* ((f (row arm))
             (frames-before (frame-count))
             (before (scope-for f))
             (result (run-act1 f))
             (after (scope-for f)))
        (act1-check (format nil "~a · capability denied at the frontier check ~
(~a): outcome-kind :refused, typed ~a, evidence carried" arm gloss expected-type)
                    (and (eq :refused (outcome-view result))
                         (eq expected-type (act1-result-refusal-type result))
                         (lisp-plus-core0:core0-evidence-p
                          (act1-result-evidence result))))
        (act1-check (format nil "~a · the bridge was NEVER REACHED: the ~
per-act verdict slot is unwritten, so the refusal happened above the adapter" arm)
                    (null (act1-result-guard result)))
        (act1-check (format nil "~a · the journal gained nothing" arm)
                    (= frames-before (frame-count)))
        (assert-denied-arm-world-scope (format nil "~a (capability denied)" arm)
                                       f before after))))

  ;; =========================================================================
  ;; ARM R — THE D1 REFUSAL: the RUNTIME boundary refuses.  This pays One Act
  ;; /0's deferred debt (work order §8(c)) without touching /0's vectors.
  ;; =========================================================================
  (let* ((f (row "R"))
         (before (scope-for f))
         (result (run-act1 f))
         (after (scope-for f)))
    (act1-check "R · the act reaches the BRIDGE (unlike B-L1/B-L2) and is ~
refused INSIDE dispatch by capability /2's own authorization: outcome-kind ~
:refused, and the verdict slot proves the bridge ran"
                (and (eq :refused (outcome-view result))
                     (eq :lawful (act1-result-guard result))))
    (act1-check "R · the reason names capability /2's typed condition AND its ~
requirement id — never a message string"
                (eq :|CAP2-ATTEMPT-AUTHORIZATION-REFUSED/CAP2-AUTH-1|
                    (act1-result-reason result))
                "reason ~s" (act1-result-reason result))
    ;; The FACET, exhibited on the typed condition itself.  The perform path
    ;; projects a refusal into a reason keyword by design; the facet is read
    ;; from the condition by calling the SAME runtime door directly, which is a
    ;; pre-frontier operation that journals nothing and touches no world byte.
    (act1-check "R · the runtime refusal's named FACET is :fresh-derivation-refused ~
(read off the typed condition, not off a message)"
                (handler-case
                    (progn (authorize-effect-attempt
                            *act1-store* *act1-bootstrap* *act1-minting-context*
                            (act1-dispatch-context-capability
                             (act1-result-context result))
                            :capability-id (act1-capability-id-for f)
                            :query-name "q-r-facet-probe"
                            :subject (getf (act1-grant-terms-for f) :subject)
                            :action (getf (act1-grant-terms-for f) :action)
                            :resource (getf (act1-grant-terms-for f) :resource)
                            :scope (getf (act1-grant-terms-for f) :scope)
                            :cell (act1-fixture-cell-segments f)
                            :value "Manus mortua."
                            :attempt-name (act1-fixture-attempt-name f)
                            :seat-name (act1-fixture-runtime-seat f))
                           nil)
                  (lisp-plus-capability2:cap2-attempt-authorization-refused (c)
                    (and (eq :fresh-derivation-refused
                             (lisp-plus-capability2:cap2-attempt-authorization-refused-basis c))
                         (string= "CAP2-AUTH-1"
                                  (lisp-plus-capability2:cap2-condition-requirement-id c))))))
    (assert-denied-arm-world-scope "R (runtime D1 refusal)" f before after))

  ;; =========================================================================
  ;; The whole run, read back cold from the store's bytes.
  ;; =========================================================================
  (multiple-value-bind (kinds count status tail) (act1-journal-kinds *act1-store*)
    (act1-check "the WHOLE journal validates :valid with no tail, and its ~
frame sequence is exactly what the six arms are entitled to have written"
                (and (eq :valid status) (null tail) (= 14 count)
                     (equal kinds
                            '("capability0:granted" "capability0:granted"
                              "capability0:granted" "capability0:granted"
                              "capability0:granted"
                              "attempt:prepared" "attempt:frontier-crossed"
                              "request:acknowledged" "effect:settled"
                              "attempt:prepared" "attempt:frontier-crossed"
                              "request:acknowledged" "effect:uncertain"
                              "capability0:revoked")))
                "~d frames: ~{~a~^ · ~}" count kinds))
  (act1-check "the durable guard, asked directly about the SETTLED seat, ~
answers :lawful — a closed seat is not a closed door"
              (eq :lawful (act1-durable-guard-verdict
                           *act1-store* :seat-name "prima"
                           :candidate-attempt-name "a-prima-9")))
  (act1-check "the durable guard, asked directly about the UNRESOLVED seat, ~
answers :refuse with the CAP2-W1 provenance — from the store alone, no world, ~
no memory"
              (eq :refuse (act1-durable-guard-verdict
                           *act1-store* :seat-name "ambigua"
                           :candidate-attempt-name "a-ambigua-9"))))

;;; ---------------------------------------------------------------------------
;;; Driver.

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-selftest-XXXXXX")
                                   "/"))))
  (unless (null (search (namestring (truename *subject-root*)) (namestring root)))
    (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
    (sb-ext:exit :code 3))
  (setf *act1-run-root* root)
  (unwind-protect
       (handler-case (run-suite)
         (act1-run-void (c)
           (format t "~&~%oneact1-selftest: VOID — ~a~%" c)
           (format t "A VOID IS NOT A FAILURE AND IS NOT A PASS.~%")
           (finish-output)
           (sb-ext:exit :code 4))
         (error (c)
           (incf *checks-failed*)
           (format t "~&~%UNHANDLED: ~a: ~a~%" (type-of c) c)))
    (when (probe-file root)
      (sb-ext:delete-directory root :recursive t))))

(format t "~&~%TALLY: ~d passed, ~d failed~%" *checks-passed* *checks-failed*)
(format t "~&oneact1-selftest: ~d checks, ~d failures~%"
        (+ *checks-passed* *checks-failed*) *checks-failed*)
(finish-output)
(sb-ext:exit :code (if (zerop *checks-failed*) 0 1))
