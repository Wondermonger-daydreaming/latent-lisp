;;;; run-specimen.lisp — de-effectu-incerto, the inhabited
;;;; uncertain-effect restart specimen.
;;;;
;;;; "A recognized, current capability may justify attempting one exact
;;;;  protected effect — but neither the capability nor its presentation
;;;;  receipt proves that the effect occurred."
;;;;
;;;; This runner is the ORCHESTRATOR and artifact preserver.  It:
;;;;   1. launches the PRIMA VITA (stage-first-life.lisp) as a SEPARATE
;;;;      process with CAP2_WORLD_DIE_IN_WINDOW=1: grant → mint →
;;;;      authorize (receipt preserved) → invoke → the adapter durably
;;;;      applies the cell write and ledgers it → THE PROCESS DIES IN THE
;;;;      ACKNOWLEDGMENT WINDOW (exit 7, no RESULT sentinel — the parent
;;;;      demands exactly that pair);
;;;;   2. digests the survivors and exhibits THE ASYMMETRY: the world
;;;;      knows (cell VII, one ledger entry) and the journal does not
;;;;      (three frames ending at frontier-crossed; nothing after);
;;;;   3. runs the truncated-restart negative control FIRST (a restart
;;;;      aborted mid-run by the planted fault exits 3 with no sentinel —
;;;;      an unfinished reconstruction never reads as a clean one; it
;;;;      writes nothing, so the state is untouched for the real restart);
;;;;   4. launches the REDIVIVA (stage-restart.lisp) — a GENUINELY NEW
;;;;      process over durable bytes + declared configuration — whose
;;;;      verdicts are relayed and renumbered here: blind retry refused
;;;;      from bytes alone (unsafe-retry; duplicate-attempt-identity for
;;;;      the dead identity itself), inline reconciliation refused, the
;;;;      §10.8 record structured and journaled, the seat still closed,
;;;;      then reconciliation :applied with evidence and the double-apply
;;;;      counterfactual, the seat lawfully freed, the second
;;;;      reconciliation a disposition, the dead life's authorization
;;;;      receipt byte-unchanged and still truthful;
;;;;   5. proves the WORLD's bytes are sha-identical across the entire
;;;;      restart (reconciliation reads; it never writes the world), that
;;;;      the journal grew by exactly the uncertain + reconciled frames,
;;;;      and that the preserved receipt is byte-identical throughout;
;;;;   6. preserves the raw bytes as tracked ARTIFACT-* files — including
;;;;      BOTH journal states (as the death left it; as reconciliation
;;;;      closed it) — with a SHA256SUMS manifest.
;;;;
;;;; The orchestrator never authorizes, dispatches, or reconciles: every
;;;; effect verdict in this capture was rendered by a stage child through
;;;; the public surface.
;;;;
;;;; Run:  sbcl --script mneme/capability2/de-effectu-incerto/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; the store nonce is fixed (declared PJ-META-1 deviation,
;;;; specimen-common.lisp), all identities are declared charge, so every
;;;; digest below is byte-stable across runs.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery — the count is DERIVED from the verdicts rendered.

(defvar *checks* 0)
(defvar *failures* 0)

(defun scheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun snote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defun store-octets (name)
  (sp-read-octets (merge-pathnames name *scratch-store*)))

(defun world-octets (name)
  (sp-read-octets (merge-pathnames name *scratch-world*)))

;;; ---------------------------------------------------------------------------
;;; Stage-child relay (the de-clave-mortua protocol).

(defun run-stage (script label &key environment)
  "Launch SCRIPT as a genuinely separate `sbcl --script` process.  Relays
its NOTE lines, renumbers its CHECK lines into this runner's verdict
stream, and returns (values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (list "--script"
                         (concatenate 'string
                                      "mneme/capability2/de-effectu-incerto/"
                                      script)
                         (namestring *scratch-store*)
                         (namestring *scratch-world*)
                         (namestring *scratch-run*))
                   :search t
                   :output output :error output
                   :environment (append environment
                                        (sb-ext:posix-environ))))
         (text (get-output-stream-string output))
         (saw-result nil))
    (with-input-from-string (stream text)
      (loop for line = (read-line stream nil nil)
            while line
            do (cond
                 ((and (>= (length line) 9)
                       (string= "CHECK ok " (subseq line 0 9)))
                  (incf *checks*)
                  (format t "[~3,'0d] ok   (~a) ~a~%" *checks* label
                          (subseq line 9)))
                 ((and (>= (length line) 11)
                       (string= "CHECK FAIL " (subseq line 0 11)))
                  (incf *checks*) (incf *failures*)
                  (format t "[~3,'0d] FAIL (~a) ~a~%" *checks* label
                          (subseq line 11)))
                 ((and (>= (length line) 5)
                       (string= "NOTE " (subseq line 0 5)))
                  (format t "      | ~a~%" (subseq line 5)))
                 ((and (>= (length line) 7)
                       (string= "RESULT:" (subseq line 0 7)))
                  (setf saw-result t)
                  (format t "      | ~a~%" line))
                 ((zerop (length line)) nil)
                 (t (format t "      | ~a~%" line)))))
    (values (sb-ext:process-exit-code process) saw-result text)))

;;; ---------------------------------------------------------------------------
;;; Phase 0 — a clean world.

(fresh-directory *scratch-store*)
(fresh-directory *scratch-world*)
(fresh-directory *scratch-run*)

(snote "de-effectu-incerto — the inhabited uncertain-effect restart specimen")
(snote "governing sentence: a recognized, current capability may justify ~
        attempting one exact protected effect — but neither the ~
        capability nor its presentation receipt proves that the effect ~
        occurred.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the first life dies in the acknowledgment window.

(snote "== phase 1 — the first life (separate process; dies in the ~
        acknowledgment window after the dispatch durably lands) ==")

(multiple-value-bind (code sentinel text)
    (run-stage "stage-first-life.lisp" "prima-vita"
               :environment (list "CAP2_WORLD_DIE_IN_WINDOW=1"))
  (scheck "the first life DIED IN THE WINDOW as planted: exit code 7, NO ~
           RESULT sentinel, and the adapter's dying note in the ~
           transcript — the dispatch was applied and ledgered; the ~
           acknowledgment never came home"
    (lambda () (and (eql 7 code)
                    (not sentinel)
                    (search "dying in the acknowledgment window" text)))))

;;; ---------------------------------------------------------------------------
;;; Phase 2 — the survivors, digested: the asymmetry.

(snote "~%== phase 2 — the surviving durable bytes: the world knows; the ~
        journal does not ==")

(defvar *events-post-death* (store-octets "EVENTS.pj0"))
(defvar *events-post-death-sha* (sha256-hex *events-post-death*))
(defvar *metadata-octets* (store-octets "JOURNAL-META.pjs"))
(defvar *sidecar-octets* (store-octets "JOURNAL-META.pjs.sha256"))
(defvar *cells-octets* (world-octets "CELLS.txt"))
(defvar *cells-sha* (sha256-hex *cells-octets*))
(defvar *ledger-octets* (world-octets "REQUEST-LEDGER.txt"))
(defvar *ledger-sha* (sha256-hex *ledger-octets*))
(defvar *auth-octets* (sp-read-octets
                       (auth-attempt-receipt-path *scratch-run*)))
(defvar *auth-sha* (sha256-hex *auth-octets*))

(scheck "the surviving journal validates :valid with exactly 3 frames — ~
         grant · attempt:prepared · attempt:frontier-crossed — and ~
         NOTHING after the frontier: no acknowledgment, no settlement, no ~
         uncertainty record; the process died before it could account for ~
         its own effect"
  (lambda ()
    (let* ((report (validate-journal (open-store *scratch-store*)))
           (events (prefix-report-events report))
           (kinds (loop for index below (fill-pointer events)
                        collect (%event-kind-string (aref events index)))))
      (and (eq :valid (prefix-report-status report))
           (= 3 (prefix-report-frame-count report))
           (null (prefix-report-tail-sha256 report))
           (equal kinds '("capability0:granted"
                          "attempt:prepared"
                          "attempt:frontier-crossed"))))))

(scheck "THE ASYMMETRY, exhibited in bytes: the surviving WORLD holds ~
         cella:septima = VII and exactly ONE applied ledger entry under ~
         the journaled external-request identity — the effect HAPPENED; ~
         only the record of its happening died with the process"
  (lambda ()
    (let ((world (open-world *scratch-world*)))
      (and (equal "VII" (world-cell-value world "cella:septima"))
           (= 1 (world-ledger-count world))
           (= 1 (world-ledger-count world
                                     "external-request:cap2:a-001"))))))

(scheck "the dead life's authorization-to-attempt receipt survives as ~
         canonical bytes: decision-bearing testimony that LICENSED the ~
         attempt (cella:septima := VII, attempt a-001, prefix ordinal 1) ~
         and proves nothing about the effect"
  (lambda ()
    (multiple-value-bind (decoded status) (decode-pjs0 *auth-octets*)
      (and decoded (eq :canonical status)
           (%authorization-receipt-p decoded)
           (string= "VII" (lisp-plus-cd0:string-datum-value
                           (record-field decoded "receipt" "value")))))))

(snote "EVENTS.pj0 (as the death left it): ~a octets · sha256 ~a"
       (length *events-post-death*) *events-post-death-sha*)
(snote "WORLD CELLS.txt: ~a octets · sha256 ~a" (length *cells-octets*)
       *cells-sha*)
(snote "WORLD REQUEST-LEDGER.txt: ~a octets · sha256 ~a"
       (length *ledger-octets*) *ledger-sha*)
(snote "AUTH-ATTEMPT-RECEIPT.pjs: ~a octets · sha256 ~a"
       (length *auth-octets*) *auth-sha*)

;;; ---------------------------------------------------------------------------
;;; Phase 3 — negative control FIRST (it writes nothing): the truncated
;;; restart is detected.

(snote "~%== phase 3 — negative control: the truncated restart ==")

(multiple-value-bind (code sentinel text)
    (run-stage "stage-restart.lisp" "truncated-control"
               :environment (list "DE_EFFECTU_DIE=1"))
  (scheck "a restart process TRUNCATED mid-run is detected by this ~
           runner: the child exits 3 with no RESULT: sentinel, and the ~
           detection is exactly that pair (an unfinished reconstruction ~
           must never read as a clean one); it wrote nothing — journal ~
           and world bytes unchanged"
    (lambda ()
      (and (eql 3 code)
           (not sentinel)
           (search "dying mid-restart" text)
           (string= *events-post-death-sha*
                    (sha256-hex (store-octets "EVENTS.pj0")))
           (string= *cells-sha* (sha256-hex (world-octets "CELLS.txt")))
           (string= *ledger-sha*
                    (sha256-hex (world-octets "REQUEST-LEDGER.txt")))))))

;;; ---------------------------------------------------------------------------
;;; Phase 4 — the restart: a genuinely new process over durable bytes +
;;; declared configuration.

(snote "~%== phase 4 — the restart (genuinely new process; durable bytes ~
        + declared configuration only) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-restart.lisp" "rediviva")
  (scheck "the restart process completed and rendered its own final ~
           sentinel (exit 0 AND RESULT: — an incomplete transcript ~
           licenses nothing)"
    (lambda () (and (eql 0 code) sentinel))))

(scheck "THE WORLD IS BYTE-IDENTICAL ACROSS THE ENTIRE RESTART (cells and ~
         ledger sha256 unchanged): reconciliation carried the journaled ~
         request identity TO the world and read; it never wrote — and the ~
         cell was therefore set EXACTLY ONCE, by the dead process"
  (lambda ()
    (and (string= *cells-sha* (sha256-hex (world-octets "CELLS.txt")))
         (string= *ledger-sha*
                  (sha256-hex (world-octets "REQUEST-LEDGER.txt"))))))

(scheck "the journal grew by EXACTLY the two accounting frames: 5 frames ~
         ending effect:uncertain · attempt:reconciled — the §10.8 record ~
         and its evidence-carrying resolution; nothing else was appended ~
         and nothing was rewritten (the first three frames' bytes are a ~
         prefix of the final journal)"
  (lambda ()
    (let* ((report (validate-journal (open-store *scratch-store*)))
           (events (prefix-report-events report))
           (kinds (loop for index below (fill-pointer events)
                        collect (%event-kind-string (aref events index))))
           (final-octets (store-octets "EVENTS.pj0")))
      (and (= 5 (prefix-report-frame-count report))
           (equal kinds '("capability0:granted"
                          "attempt:prepared"
                          "attempt:frontier-crossed"
                          "effect:uncertain"
                          "attempt:reconciled"))
           (> (length final-octets) (length *events-post-death*))
           (equalp *events-post-death*
                   (subseq final-octets 0
                           (length *events-post-death*)))))))

(scheck "the preserved authorization receipt is byte-identical across the ~
         restart (sha256 equal): four refusals, a declaration, and a ~
         reconciliation edited nothing"
  (lambda ()
    (string= *auth-sha*
             (sha256-hex (sp-read-octets
                          (auth-attempt-receipt-path *scratch-run*))))))

;;; ---------------------------------------------------------------------------
;;; Phase 5 — preserved artifacts (raw bytes, tracked, with a manifest).

(snote "~%== phase 5 — preserved artifacts ==")

(defvar *events-final* (store-octets "EVENTS.pj0"))

(sp-write-octets (merge-pathnames "ARTIFACT-EVENTS-POST-DEATH.pj0"
                                  *specimen-root*)
                 *events-post-death*)
(sp-write-octets (merge-pathnames "ARTIFACT-EVENTS-FINAL.pj0"
                                  *specimen-root*)
                 *events-final*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs"
                                  *specimen-root*)
                 *metadata-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs.sha256"
                                  *specimen-root*)
                 *sidecar-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-CELLS.txt"
                                  *specimen-root*)
                 *cells-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-LEDGER.txt"
                                  *specimen-root*)
                 *ledger-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-AUTH-ATTEMPT-RECEIPT.pjs"
                                  *specimen-root*)
                 *auth-octets*)
(sp-write-octets
 (merge-pathnames "ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (sp-ascii (format nil "~a  ARTIFACT-EVENTS-POST-DEATH.pj0~%~
                        ~a  ARTIFACT-EVENTS-FINAL.pj0~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs.sha256~%~
                        ~a  ARTIFACT-WORLD-CELLS.txt~%~
                        ~a  ARTIFACT-WORLD-LEDGER.txt~%~
                        ~a  ARTIFACT-AUTH-ATTEMPT-RECEIPT.pjs~%"
                   *events-post-death-sha*
                   (sha256-hex *events-final*)
                   (sha256-hex *metadata-octets*)
                   (sha256-hex *sidecar-octets*)
                   *cells-sha*
                   *ledger-sha*
                   *auth-sha*)))
(sp-write-octets
 (merge-pathnames "ARTIFACT-MANIFEST.txt" *specimen-root*)
 (sp-ascii
  (format nil
          "de-effectu-incerto - preserved raw artifacts~%~
           governing sentence: a recognized, current capability may ~
           justify attempting one exact protected effect - but neither ~
           the capability nor its presentation receipt proves that the ~
           effect occurred.~%~
           store identity: ~a~%~
           EVENTS-POST-DEATH.pj0: ~a octets  sha256 ~a  (3 frames: grant, ~
           attempt:prepared, attempt:frontier-crossed; the journal as the ~
           death in the acknowledgment window left it - the frontier ~
           crossed, the effect unaccounted)~%~
           EVENTS-FINAL.pj0: ~a octets  sha256 ~a  (5 frames: the same ~
           prefix byte-identically, plus effect:uncertain and ~
           attempt:reconciled - the restart's accounting; nothing ~
           rewritten)~%~
           WORLD-CELLS.txt: ~a octets  sha256 ~a  (cella:septima = VII - ~
           written EXACTLY ONCE, by the dead process; byte-identical ~
           across the restart)~%~
           WORLD-LEDGER.txt: ~a octets  sha256 ~a  (ONE applied entry ~
           under external-request:cap2:a-001 - the evidence the ~
           reconciliation carried home; a blind retry would have ~
           appended a second)~%~
           AUTH-ATTEMPT-RECEIPT.pjs: ~a octets  sha256 ~a  (the dead ~
           life's authorization-to-attempt receipt: licensed the attempt, ~
           proves nothing about the effect, byte-identical throughout)~%~
           byte-stability: every file listed here is byte-identical ~
           across runs (fixed store nonce; declared PJ-META-1 deviation, ~
           see specimen-common.lisp)~%"
          (expected-store-id)
          (length *events-post-death*) *events-post-death-sha*
          (length *events-final*) (sha256-hex *events-final*)
          (length *cells-octets*) *cells-sha*
          (length *ledger-octets*) *ledger-sha*
          (length *auth-octets*) *auth-sha*)))

(scheck "the preserved artifacts are byte-identical to the live bytes ~
         they copy and the SHA256SUMS manifest carries those digests"
  (lambda ()
    (let ((sums (sp-octets-string
                 (sp-read-octets
                  (merge-pathnames "ARTIFACT-SHA256SUMS.txt"
                                   *specimen-root*)))))
      (and (string= *events-post-death-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames
                                  "ARTIFACT-EVENTS-POST-DEATH.pj0"
                                  *specimen-root*))))
           (string= (sha256-hex *events-final*)
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames
                                  "ARTIFACT-EVENTS-FINAL.pj0"
                                  *specimen-root*))))
           (string= *cells-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames "ARTIFACT-WORLD-CELLS.txt"
                                                  *specimen-root*))))
           (string= *auth-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames
                                  "ARTIFACT-AUTH-ATTEMPT-RECEIPT.pjs"
                                  *specimen-root*))))
           (search *events-post-death-sha* sums)
           (search *cells-sha* sums)
           (search *ledger-sha* sums)
           (search *auth-sha* sums)))))

;;; ---------------------------------------------------------------------------
;;; Scratch teardown.  Everything evidential has been preserved as an
;;; ARTIFACT-* file or printed into this capture; the scratch stores are
;;; rebuilt from scratch on every run and are never the record.  (A run
;;; that dies before this point leaves them on disk for inspection.)

(dolist (directory (list *scratch-store* *scratch-world* *scratch-run*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%de-effectu-incerto: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(format t "processes: 1 first life (died in the acknowledgment window; ~
           its memory died with it) · 2 restarts launched ~
           (truncated-control, rediviva) · artifacts preserved: both ~
           journal states + metadata + sidecar + world cells + world ~
           ledger + authorization receipt + sha256sums + manifest · ~
           every effect verdict rendered by a stage child~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
