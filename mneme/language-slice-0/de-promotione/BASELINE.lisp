;;;; BASELINE.lisp — specimen `de-promotione`
;;;;
;;;; An HONEST test-run status tracker in plain idiomatic Common Lisp.
;;;; No external libraries, no dependency on anything else in the repo.
;;;; Fully deterministic: no process spawning, no GET-UNIVERSAL-TIME, no
;;;; RANDOM — every "run" is fixture data threaded through the same code.
;;;;
;;;; This is the COMPETENT baseline a good CL programmer would actually
;;;; write. It is not a strawman: the domain is modelled faithfully, the
;;;; seven facts about a test run are kept as SEPARATE things, and the
;;;; release decision only says :verified when all seven genuinely hold.
;;;;
;;;; The point of the specimen is what happens AFTER that: the file then
;;;; shows how ordinary, idiomatic, un-flaggable lines of Lisp quietly
;;;; collapse those seven facts into one — the "promotion" of weaker
;;;; evidence into a verified release. Nothing in the language resists it.

(defpackage :de-promotione-baseline
  (:use :cl))
(in-package :de-promotione-baseline)

;;; ---------------------------------------------------------------------
;;; The seven facts, kept SEPARATE
;;; ---------------------------------------------------------------------
;;;
;;; A build/release pipeline must distinguish these as different claims.
;;; Conflating any two of them is exactly the failure this specimen is
;;; about, so each gets its own slot rather than being folded into a
;;; single "passed?" boolean:
;;;
;;;   1. process launched          — we started the runner at all
;;;   2. process exited (code)      — it terminated, with some exit code
;;;   3. suite completed            — the runner reached its OWN end,
;;;                                    not merely that the process died
;;;   4. output parsed              — transcript parsed into results
;;;   5. tests reported passing      — the parsed results say all pass
;;;   6. expected test set matched   — the tests that ran are exactly the
;;;                                    suite we expected (no silent skips)
;;;   7. release judgment            — :verified or :pending

;;; ---------------------------------------------------------------------
;;; Conditions
;;; ---------------------------------------------------------------------

(define-condition transcript-parse-error (error)
  ((reason :initarg :reason :reader parse-error-reason))
  (:report (lambda (c stream)
             (format stream "Cannot parse transcript: ~A"
                     (parse-error-reason c))))
  (:documentation
   "Signalled when a transcript is absent or unparseable. A parse
    failure is a FIRST-CLASS outcome: it means fact #4 does not hold,
    and everything downstream (facts 5 and 6) is therefore unknown."))

;;; ---------------------------------------------------------------------
;;; Data model
;;; ---------------------------------------------------------------------

(defstruct (test-run (:conc-name run-))
  "One execution of a test suite. Each slot is one of the seven facts,
   held apart on purpose. NIL means 'not established', never 'false by
   omission' — a parse failure leaves PARSED-P false and the pass/expected
   facts simply unknown."
  (name           ""    :type string)
  (launched-p     nil)                 ; fact 1
  (exited-p       nil)                 ; fact 2 (did the process terminate?)
  (exit-code      nil)                 ; the code, when it exited
  (suite-completed-p nil)             ; fact 3 (runner reached its end)
  (parsed-p       nil)                 ; fact 4
  (all-pass-p     nil)                 ; fact 5 (parsed results say pass)
  (expected-suite nil  :type list)     ; the tests we EXPECTED to run
  (reported-tests nil  :type list)     ; the tests the transcript shows
  (expected-matched-p nil)            ; fact 6
  (transcript     nil)                 ; raw fixture, or NIL if none
  (testimony      nil))                ; a colleague's message, if any

(defstruct (release-claim (:conc-name release-))
  "A claim about whether a run's software may be released. STATUS is the
   whole point: it starts :PENDING and should only become :VERIFIED when
   a disciplined decision function says so — yet any SETF can move it."
  (run    nil :type (or null test-run))
  (status :pending))                   ; fact 7 — :pending | :verified

;;; ---------------------------------------------------------------------
;;; Simulated pipeline stages (deterministic — fixtures, not processes)
;;; ---------------------------------------------------------------------

(defun launch-run (name &key exit-code suite-completed-p
                             expected-suite transcript testimony)
  "Simulate launching a test runner and having it terminate. Returns a
   TEST-RUN with facts 1-3 populated from FIXTURE data. No real process is
   spawned; EXIT-CODE and SUITE-COMPLETED-P are supplied by the fixture so
   the whole file is reproducible."
  (make-test-run
   :name name
   :launched-p t                       ; fact 1: we started it
   :exited-p (not (null exit-code))    ; fact 2: it terminated iff coded
   :exit-code exit-code
   :suite-completed-p suite-completed-p ; fact 3: SEPARATE from exiting
   :expected-suite expected-suite
   :transcript transcript
   :testimony testimony))

(defun parse-transcript (run)
  "Parse RUN's transcript into results, populating facts 4-6. Signals
   TRANSCRIPT-PARSE-ERROR when there is nothing to parse. A transcript is
   an alist of (TEST-NAME . RESULT) where RESULT is :PASS or :FAIL, plus an
   optional (:suite-status . :completed|:killed) marker.

   Crucially, parsing is NOT judging: this records what the transcript
   SAYS (which tests ran, whether they passed, whether the suite marker
   says completed) and checks it against the expected suite. It never
   promotes any of that to a release decision."
  (let ((tx (run-transcript run)))
    (when (null tx)
      (error 'transcript-parse-error :reason "no transcript present"))
    (let* ((status-cell (assoc :suite-status tx))
           (result-cells (remove :suite-status tx :key #'car))
           (reported (mapcar #'car result-cells))
           (all-pass (and result-cells
                          (every (lambda (cell) (eq (cdr cell) :pass))
                                 result-cells)))
           (expected (run-expected-suite run)))
      (setf (run-parsed-p run) t)      ; fact 4: parse succeeded
      ;; fact 3 is re-checked against the transcript's own end-marker:
      ;; a zero exit code does NOT imply the suite reached its end.
      (when (and status-cell (eq (cdr status-cell) :completed))
        (setf (run-suite-completed-p run) t))
      (when (and status-cell (eq (cdr status-cell) :killed))
        (setf (run-suite-completed-p run) nil))
      (setf (run-reported-tests run) reported)
      (setf (run-all-pass-p run) all-pass)   ; fact 5
      ;; fact 6: the reported set must equal the expected set exactly.
      (setf (run-expected-matched-p run)
            (and expected
                 (null (set-difference expected reported))
                 (null (set-difference reported expected))))
      run)))

(defun check-expected-suite (run)
  "Return T iff RUN's reported tests are exactly its expected suite.
   Separated out so a caller can ask fact #6 on its own — this is the
   check that catches silently-skipped tests."
  (run-expected-matched-p run))

(defun missing-tests (run)
  "The expected tests that never showed up in the transcript."
  (set-difference (run-expected-suite run) (run-reported-tests run)))

;;; ---------------------------------------------------------------------
;;; The disciplined release decision
;;; ---------------------------------------------------------------------

(defun decide-release (run)
  "The HONEST release decision. Returns a RELEASE-CLAIM whose status is
   :VERIFIED only when all seven facts genuinely hold, and :PENDING
   otherwise. This is the whole conjunction, written once, in one place:
   every fact must be established independently — an exit code cannot
   stand in for suite completion, a parse cannot stand in for a matched
   suite, and testimony cannot stand in for any of it."
  (let ((claim (make-release-claim :run run)))
    (when (and (run-launched-p run)                 ; 1
               (run-exited-p run)                    ; 2
               (eql (run-exit-code run) 0)           ; 2 (clean code)
               (run-suite-completed-p run)           ; 3
               (run-parsed-p run)                    ; 4
               (run-all-pass-p run)                  ; 5
               (run-expected-matched-p run))         ; 6
      (setf (release-status claim) :verified))       ; 7
    claim))

(defun describe-run (run)
  "Print the seven facts of RUN, clearly labelled, so a reader can see
   which claims actually hold before any release decision is made."
  (format t "  run ~S~%" (run-name run))
  (format t "    1. launched .............. ~A~%" (run-launched-p run))
  (format t "    2. exited (code) ......... ~A (~A)~%"
          (run-exited-p run) (run-exit-code run))
  (format t "    3. suite completed ....... ~A~%" (run-suite-completed-p run))
  (format t "    4. output parsed ......... ~A~%" (run-parsed-p run))
  (format t "    5. tests reported pass ... ~A~%" (run-all-pass-p run))
  (format t "    6. expected suite matched  ~A~@[  (missing: ~S)~]~%"
          (run-expected-matched-p run)
          (and (run-parsed-p run) (missing-tests run)))
  (when (run-testimony run)
    (format t "    *. testimony ............. ~S~%" (run-testimony run))))

;;; ---------------------------------------------------------------------
;;; Fixture data
;;; ---------------------------------------------------------------------

(defparameter *expected-suite*
  '(:test-login :test-logout :test-checkout :test-refund :test-search)
  "The five tests the release process expects to see run, every time.")

(defun fixture-good ()
  "A genuinely clean run: process exits 0, the suite's own end-marker
   says :completed, the transcript parses, every test passes, and the
   reported set is exactly the expected suite. All seven facts hold."
  (let ((run (launch-run
              "good"
              :exit-code 0
              :suite-completed-p nil   ; established by the transcript below
              :expected-suite *expected-suite*
              :transcript '((:suite-status . :completed)
                            (:test-login    . :pass)
                            (:test-logout   . :pass)
                            (:test-checkout . :pass)
                            (:test-refund   . :pass)
                            (:test-search   . :pass)))))
    (parse-transcript run)
    run))

(defun fixture-killed-midway ()
  "BAD (a): exit code 0, but the transcript shows the suite was killed
   mid-way — the runner never reached its end. Fact #2 looks fine; fact
   #3 does not hold. The passing tests are real but the suite is partial."
  (let ((run (launch-run
              "killed-midway"
              :exit-code 0             ; the tempting lie: 'it exited clean'
              :expected-suite *expected-suite*
              :transcript '((:suite-status . :killed)
                            (:test-login  . :pass)
                            (:test-logout . :pass)))))
    (parse-transcript run)
    run))

(defun fixture-silently-skipped ()
  "BAD (b): the transcript parses and every reported test passes, but
   three expected tests never ran. Facts #4 and #5 hold; fact #6 does not.
   This is the silent-skip: green, complete-looking, and wrong."
  (let ((run (launch-run
              "silently-skipped"
              :exit-code 0
              :expected-suite *expected-suite*
              :transcript '((:suite-status . :completed)
                            (:test-login  . :pass)
                            (:test-search . :pass)))))
    (parse-transcript run)
    run))

(defun fixture-testimony-only ()
  "BAD (c): no transcript at all, only a colleague's message. Fact #4
   cannot even be attempted — PARSE-TRANSCRIPT signals, and we record the
   run as unparsed. All we have is a string that says it's fine."
  (let ((run (launch-run
              "testimony-only"
              :exit-code nil           ; we never even saw it exit
              :expected-suite *expected-suite*
              :testimony "ran it on my machine, all green")))
    (handler-case (parse-transcript run)
      (transcript-parse-error () nil)) ; expected: nothing to parse
    run))

;;; ---------------------------------------------------------------------
;;; Demonstration
;;; ---------------------------------------------------------------------

(defun demo-normal-use ()
  "Competent use: the good run reaches :VERIFIED, and every bad run stays
   :PENDING, because DECIDE-RELEASE checks all seven facts."
  (format t "~%=== NORMAL COMPETENT USE ===~%")
  (dolist (run (list (fixture-good)
                     (fixture-killed-midway)
                     (fixture-silently-skipped)
                     (fixture-testimony-only)))
    (describe-run run)
    (let ((claim (decide-release run)))
      (format t "    => release: ~S~%~%" (release-status claim)))))

(defun demo-misleading-moves ()
  "THE MISLEADING LOCAL MOVES. Each is an ordinary idiomatic line that no
   reviewer would flag as language abuse — a plain SETF of a struct slot,
   identical in form to every honest SETF above. The language offers no
   resistance: the slot is writable, the assignment is silent, and the
   symbol :VERIFIED is just a keyword."
  (format t "~%=== THE MISLEADING LOCAL MOVES ===~%")

  ;; (i) Exit status alone becomes verification.
  ;;     WHY MISLEADING: a zero exit code is fact #2 only. It says the
  ;;     process terminated cleanly — NOT that the suite completed, parsed,
  ;;     passed, or matched. Here the killed-midway run (exit 0, suite
  ;;     killed) is promoted straight to :verified. Nothing in the language
  ;;     objects: (zerop exit-code) is true, so the SETF fires.
  (let* ((run (fixture-killed-midway))
         (claim (make-release-claim :run run))
         (exit-code (run-exit-code run)))
    (when (zerop exit-code)
      (setf (release-status claim) :verified))
    (format t "  (i)   exit-code=0 shortcut on ~S~%" (run-name run))
    (format t "        => release: ~S   [MISLEADING: exit code is fact #2 only;~%"
            (release-status claim))
    (format t "           the suite was KILLED mid-way (fact #3 fails)]~%~%"))

  ;; (ii) Parsed-pass without the expected-suite check.
  ;;      WHY MISLEADING: the silently-skipped run parses and all reported
  ;;      tests pass (facts #4, #5), so (run-all-pass-p run) is true. But
  ;;      three expected tests never ran (fact #6 fails). Trusting all-pass
  ;;      without check-expected-suite promotes a partial green to verified.
  (let* ((run (fixture-silently-skipped))
         (claim (make-release-claim :run run)))
    (when (and (run-parsed-p run) (run-all-pass-p run))
      (setf (release-status claim) :verified))  ; missing the fact-#6 guard
    (format t "  (ii)  all-pass shortcut on ~S~%" (run-name run))
    (format t "        => release: ~S   [MISLEADING: every REPORTED test passed,~%"
            (release-status claim))
    (format t "           but ~S never ran (fact #6 fails)]~%~%"
            (missing-tests run)))

  ;; (iii) Testimony treated as execution evidence.
  ;;       WHY MISLEADING: there is no transcript, no parse, no exit code —
  ;;       only a human string. A truthy check on that string is enough to
  ;;       fire the same SETF. The keyword :verified cannot tell that its
  ;;       warrant is a sentence someone typed rather than a suite that ran.
  (let* ((run (fixture-testimony-only))
         (claim (make-release-claim :run run)))
    (when (run-testimony run)          ; a non-empty string is true
      (setf (release-status claim) :verified))
    (format t "  (iii) testimony shortcut on ~S~%" (run-name run))
    (format t "        => release: ~S   [MISLEADING: warrant is the string~%"
            (release-status claim))
    (format t "           ~S — testimony, not execution]~%~%"
            (run-testimony run))))

;;; ---------------------------------------------------------------------
;;; What discipline can and cannot do (commentary)
;;; ---------------------------------------------------------------------
;;;
;;; A DISCIPLINED library could raise the cost of the three moves above:
;;;
;;;   * Make RELEASE-STATUS a package-private slot with no exported writer,
;;;     so the only *exported* way to reach :verified is DECIDE-RELEASE.
;;;   * Export exactly one release constructor — a CHECK-RELEASE that runs
;;;     the seven-fact conjunction and is the sole path to :verified.
;;;   * Signal (not return NIL) on a missing transcript, so fact #4 cannot
;;;     be quietly skipped.
;;;
;;; What that discipline can NOT do:
;;;
;;;   * Nothing stops a maintainer adding ONE exported convenience
;;;     function — `(defun quick-verify (claim) (setf (release-status
;;;     claim) :verified))` — and now the guarded path has a back door
;;;     that looks just as legitimate as the front one.
;;;   * Nothing stops a caller reaching an internal symbol with
;;;     `de-promotione-baseline::release-status` — the `::` is a shrug, not a wall.
;;;   * The struct slot is writable because struct slots are writable; the
;;;     keyword :verified is interchangeable with any other keyword; the
;;;     SETF that lies is byte-for-byte the same construct as the SETF that
;;;     tells the truth. The protection is CONVENTION, enforced by reviewers
;;;     and habit — not SEMANTICS enforced by the language. The language
;;;     treats the honest promotion and the misleading one identically,
;;;     because to the evaluator they ARE identical.

;;; ---------------------------------------------------------------------
;;; Run the demonstration at load time
;;; ---------------------------------------------------------------------

(demo-normal-use)
(demo-misleading-moves)

(format t "=== de-promotione: baseline demonstration complete ===~%")
