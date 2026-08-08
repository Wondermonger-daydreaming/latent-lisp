;;;; act0-selftest.lisp — One Act /0: THE CANONICAL 173-CHECK RUNNER
;;;; (owner ruling R2.3, item 2).
;;;;
;;;;   sbcl --script mneme/language-act-0/act0-selftest.lisp
;;;;
;;;; Sentinel, printed ONLY on a fully green authorized run:
;;;;
;;;;   oneact0-selftest: 173 checks, 0 failures
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHY THIS FILE EXISTS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; Through R2.2 the lane's 173 checks had NO CANONICAL RUNNER IN THE TREE.
;;;; `act0-gates.lisp' defines the gate functions and nothing called them in
;;;; order; the order lived in a builder's ad-hoc driver, outside the subject
;;;; tree, and the first such driver did not survive its round (FABER-II had to
;;;; RECONSTRUCT it from a transcript).  A suite whose order is reconstructed
;;;; from prose is a suite one careless session away from being unrunnable.
;;;;
;;;; ⚠ THE ORDER BELOW IS TRANSCRIBED, NOT INVENTED.  It is the accepted order
;;;; of the locked R2.2 twin runs, carried verbatim from
;;;; `_staging/oneact-impl-run-outputs/r22-full-run-driver.lisp' — itself
;;;; derived from FABER-I's transcript.  The claim that it is EXACT is not
;;;; asserted here; it is PROVED by comparison, in the round's log: this
;;;; runner's transcript is byte-identical to the locked R2.2 transcript
;;;; except for its own header line.
;;;;
;;;; H-AP0-COLLIDE (GATE-20) IS LAST, AND MUST REMAIN LAST.  Its plant is
;;;; PERMANENT in the run's store — the arms have already run, and an append
;;;; cannot be un-appended.  Any gate moved after it would read a poisoned
;;;; store.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS FILE IS NOT
;;;; ---------------------------------------------------------------------------
;;;;
;;;; It is NOT part of the lane's four-source load.  `ensure-act0-lane' loads
;;;; package.lisp, act0-fixtures.lisp, act0.lisp, act0-gates.lisp and nothing
;;;; else; `act0-gates.lisp' remains the LAST-LOADED source and the readiness
;;;; carrier remains its LAST FORM.  This runner is a CONSUMER of the loaded
;;;; lane, entered from a fresh image through ASDF, exactly as an outside hand
;;;; would enter it.
;;;;
;;;; It adopts nothing.  Executing a candidate is not adopting it.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; DISCIPLINE
;;;; ---------------------------------------------------------------------------
;;;;
;;;; * FRESH IMAGE, SBCL 2.4.6 only — fails closed on any other version.
;;;; * The lane is entered THROUGH ASDF (`lisp-plus/act0'), never by loading
;;;;   sources by hand: the R2.2 readiness guard is therefore exercised too.
;;;; * THE RUN ROOT IS CREATED OUTSIDE THE SUBJECT TREE and is ASSERTED to be
;;;;   outside before a byte is written.  The lane's stores and worlds are
;;;;   written there, never into the checkout.
;;;; * THE RUN ROOT IS REMOVED ON SUCCESS **AND** ON FAILURE (unwind-protect),
;;;;   including on a mid-suite error and on a failed authorization.
;;;; * STDOUT IS THE DETERMINISTIC TRANSCRIPT.  Everything that cannot be
;;;;   byte-stable across runs — the mkdtemp'd run root, the toolchain banner —
;;;;   goes to STDERR, so two runs of this file produce byte-identical stdout.
;;;;   That is what makes the twin-run comparison a real instrument rather than
;;;;   an exercise in filtering.
;;;; * THE COUNT IS AUTHORIZED, NOT OBSERVED.  173 is asserted.  A run that
;;;;   produces 172 or 174 checks FAILS CLOSED even with zero failures — a
;;;;   suite that silently loses a check reports its loss as health.
;;;; * THE TOOTH: ACT0_SELFTEST_PLANT_FAULT=1 infects one check.  A harness
;;;;   that has never failed is untested, not passing.
;;;;
;;;; — FABER-III (Claude Opus 5, subagent), R2.3 item 2, 2026-08-08

(require :asdf)
(require :sb-posix)

;;; --------------------------------------------------------------------------
;;; Toolchain gate — before anything else.
;;; --------------------------------------------------------------------------

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: this runner is authorized for SBCL 2.4.6 only.~%~
             Observed ~a.  No portability is claimed and none may be inferred.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

;;; --------------------------------------------------------------------------
;;; The subject tree, taken from THIS FILE's own location — checkout- and
;;; cwd-independent.  No /home/..., no worktree name, no current directory.
;;; --------------------------------------------------------------------------

(defparameter cl-user::*act0-selftest-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*act0-selftest-tree*
  (truename (merge-pathnames "../../" cl-user::*act0-selftest-here*))
  "experiments/latent-lisp — the subject tree root.")

(format *error-output* "~&== act0-selftest — SBCL ~a ==~%   subject tree: ~a~%"
        (lisp-implementation-version) cl-user::*act0-selftest-tree*)

;;; --------------------------------------------------------------------------
;;; THE RUN ROOT — created outside the subject tree, and PROVED outside.
;;; --------------------------------------------------------------------------

(defparameter cl-user::*act0-selftest-run-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string
                            (string-right-trim "/" tmp)
                            "/oneact0-selftest.XXXXXX"))))
    (truename (concatenate 'string dir "/")))
  "A fresh directory under TMPDIR.  Removed on success AND on failure.")

;; ⚠ ASSERTED, not assumed: a run root inside the subject tree would write the
;; lane's stores and worlds into the checkout, and the release floor's
;; cleanliness gate would (rightly) fail the whole floor.  Checked BEFORE the
;; lane writes its first byte.
(let ((tree (namestring cl-user::*act0-selftest-tree*))
      (root (namestring cl-user::*act0-selftest-run-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output*
            "~&!! FAIL CLOSED: the run root ~a is INSIDE the subject tree ~a.~%"
            root tree)
    (ignore-errors (uiop:delete-directory-tree
                    cl-user::*act0-selftest-run-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "   run root    : ~a  (outside the tree; removed on success AND failure)~%"
        cl-user::*act0-selftest-run-root*)
(finish-output *error-output*)

;;; --------------------------------------------------------------------------
;;; Enter the lane THROUGH ASDF.
;;; --------------------------------------------------------------------------

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*act0-selftest-tree*))
   :inherit-configuration))

(asdf:load-system "lisp-plus/act0")

(in-package #:lisp-plus-language-act0)

(defparameter +authorized-check-count+ 173
  "The accepted count of the locked R2.2 twin runs.  ASSERTED, not observed:
this floor detects drift; it does not absorb it — not even upward.")

;;; --------------------------------------------------------------------------
;;; THE ACCEPTED GATE ORDER.  Transcribed from the locked R2.2 driver.
;;; H-AP0-COLLIDE (GATE-20) IS LAST AND MUST REMAIN LAST.
;;; --------------------------------------------------------------------------

(defun run-canonical-gate-order ()
  (format t "~&== ONE ACT /0 — FULL GATE RUN (canonical runner, act0-selftest.lisp) ==~%")

  ;; --- pre-arm gates, in the accepted order ---------------------------------
  (gate-17-environment)
  (gate-f-store)
  (gate-l0-teeth)
  (gate-13-lexis-teeth)
  (gate-14-derivation-exhibit)
  (gate-14-cold-recomputation)
  (gate-14-contrast-pairs)
  (h-act-preimage)
  (gate-16-vectors)
  (gate-4-agreement-teeth)

  ;; --- GATE-3, the seven arms in contract order -----------------------------
  (format t "~&~%== GATE-3 — THE SEVEN ARMS IN CONTRACT ORDER ==~%")
  (setup-run cl-user::*act0-selftest-run-root*)
  (let ((arm-results (run-all-arms)))
    (format t "~&~%== ARM SUMMARY ==~%")
    (dolist (r arm-results)
      (format t "~&  ~6a class=~14s row=~a verdict=~a ~@[classification=~a~]~%"
              (getf r :arm) (getf r :class)
              (or (getf r :row) "-") (or (getf r :verdict) "-")
              (let ((c (getf r :classification)))
                (and c (substitute #\- #\: (string-upcase (symbol-name c))))))))

  (freeze-v-frames)

  ;; --- post-arm teeth, in the accepted order --------------------------------
  (gate-8-journal-purity)
  (gate-6-binding-teeth)
  (gate-14-branch-tooth)
  (gate-7-ordering-teeth)
  (gate-15-dispatcher-tooth)
  (gate-19-binding-consumption)
  (gate-5-retry-teeth)
  (nc-39-independent-teeth)
  (gate-16-journal-teeth)
  (gate-13-inject-layer-2)
  ;; ⚠ LAST.  Its plant is permanent in this store.
  (gate-20-ap0-collide))

;;; --------------------------------------------------------------------------
;;; THE HARNESS TOOTH.
;;;
;;; ACT0_SELFTEST_PLANT_FAULT=1 infects exactly one check, through the LANE'S
;;; OWN `check' — so the plant is counted by the same instrument that counts
;;; every real check, and refuses the run twice over: the failure count moves
;;; off zero AND the observed count moves off the authorized 173.  House
;;; pattern (cf. ACT0_LOADER_PLANT_FAULT, CAP2_SELFTEST_PLANT_FAULT).
;;; --------------------------------------------------------------------------

(defun plant-fault-if-asked ()
  (when (equal (sb-ext:posix-getenv "ACT0_SELFTEST_PLANT_FAULT") "1")
    (check "PLANTED FAULT (ACT0_SELFTEST_PLANT_FAULT=1): this check must FAIL" nil)))

;;; --------------------------------------------------------------------------
;;; THE RUN.  One unwind-protect over everything, so the run root is removed on
;;; the green path, the red path, and the exceptional path alike.
;;; --------------------------------------------------------------------------

(let ((suite-error nil))
  (unwind-protect
       (handler-case (progn (run-canonical-gate-order) (plant-fault-if-asked))
         (error (c)
           (setf suite-error c)
           (format t "~&~%!! THE SUITE SIGNALLED: ~a~%" (type-of c))
           (format *error-output* "~&!! suite error: ~a~%" c)))
    (ignore-errors
     (uiop:delete-directory-tree cl-user::*act0-selftest-run-root* :validate t))
    (format *error-output* "   run root removed: ~a (exists: ~a)~%"
            cl-user::*act0-selftest-run-root*
            (and (probe-file cl-user::*act0-selftest-run-root*) t))
    (finish-output *error-output*))

  (let* ((failed *checks-failed*)
         (total (+ *checks-passed* failed))
         (authorized (= total +authorized-check-count+))
         (green (and (null suite-error) (zerop failed) authorized)))
    (format t "~&~%== TALLY: ~d passed, ~d failed ==~%" *checks-passed* failed)
    (if green
        ;; THE SENTINEL.  Printed on this path and on no other.
        (format t "~&oneact0-selftest: ~d checks, ~d failures~%" total failed)
        (format t "~&oneact0-selftest: RUN REFUSED — observed ~d check(s) and ~
                   ~d failure(s); authorized ~d check(s) and 0 failures.~
                   ~@[~%   the suite signalled: ~a~]~%~
                   The success sentinel is WITHHELD.~%"
                total failed +authorized-check-count+
                (and suite-error (type-of suite-error))))
    (finish-output)
    (sb-ext:exit :code (if green 0 1))))
