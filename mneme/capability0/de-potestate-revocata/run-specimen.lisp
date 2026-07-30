;;;; run-specimen.lisp — de-potestate-revocata, the inhabited live-authority
;;;; specimen.
;;;;
;;;; "History may prove that authority once existed; only the validated
;;;;  present prefix can say whether it remains live."
;;;;
;;;; This runner is the ORCHESTRATOR and artifact preserver.  It:
;;;;   1. launches the PRIMA VITA (stage-first-life.lisp) as a SEPARATE
;;;;      process: explicit bootstrap → grant → authorized receipt at P
;;;;      (preserved to disk) → unrelated event (still authorized) →
;;;;      revocation (governed refusal) → EXIT (its memory dies);
;;;;   2. digests the surviving durable bytes;
;;;;   3. launches the REDIVIVUS (stage-restart.lisp) — a GENUINELY NEW
;;;;      process consulting ONLY durable bytes + declared configuration —
;;;;      whose verdicts are relayed and renumbered here: identical refusal
;;;;      reconstructed, old receipt still truthful about P, old receipt as
;;;;      present authority refused by type;
;;;;   4. proves the preserved receipt file and the journal bytes are
;;;;      BYTE-IDENTICAL across the restart (by sha256);
;;;;   5. runs the truncation negative control (a restart aborted mid-run by a
;;;;      planted fault — no signal, no SIGKILL — is
;;;;      DETECTED: exit 3, no RESULT sentinel);
;;;;   6. preserves the raw journal + receipt bytes as tracked ARTIFACT-*
;;;;      files with a SHA256SUMS manifest.
;;;;
;;;; The orchestrator never derives authority itself: every authority
;;;; verdict in this capture was rendered by a stage child through the
;;;; public surface.
;;;;
;;;; Run:  sbcl --script mneme/capability0/de-potestate-revocata/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; the store nonce is fixed (declared PJ-META-1 deviation,
;;;; specimen-common.lisp), so every digest below is byte-stable across runs.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability0)

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

;;; ---------------------------------------------------------------------------
;;; Stage-child relay (the de-teste-occiso protocol).

(defun run-stage (script label &key environment)
  "Launch SCRIPT as a genuinely separate `sbcl --script` process.  Relays
its NOTE lines, renumbers its CHECK lines into this runner's verdict
stream, and returns (values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (list "--script"
                         (concatenate 'string
                                      "mneme/capability0/de-potestate-revocata/"
                                      script)
                         (namestring *scratch-store*)
                         (namestring *receipt-channel*))
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
(fresh-directory *scratch-run*)

(snote "de-potestate-revocata — the inhabited live-authority specimen")
(snote "governing sentence: history may prove that authority once existed; ~
        only the validated present prefix can say whether it remains live.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the first life (separate process; it exits and its memory dies).

(snote "== phase 1 — the first life (separate process: bootstrap · grant · ~
        receipt at P · unrelated · revocation · exit) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-first-life.lisp" "prima-vita")
  (scheck "the first life completed and rendered its own final sentinel ~
           (exit 0 AND a RESULT: line — an incomplete transcript licenses ~
           nothing)"
    (lambda () (and (eql 0 code) sentinel))))

;;; ---------------------------------------------------------------------------
;;; Phase 2 — the surviving durable bytes, digested before the restart.

(snote "~%== phase 2 — the surviving durable bytes ==")

(defvar *events-octets* (store-octets "EVENTS.pj0"))
(defvar *events-sha* (sha256-hex *events-octets*))
(defvar *metadata-octets* (store-octets "JOURNAL-META.pjs"))
(defvar *sidecar-octets* (store-octets "JOURNAL-META.pjs.sha256"))
(defvar *receipt-octets* (sp-read-octets *receipt-channel*))
(defvar *receipt-sha* (sha256-hex *receipt-octets*))

(scheck "the preserved receipt file exists and its bytes decode canonically ~
         to an :authorized receipt bound to terminal ordinal 1 (prefix P)"
  (lambda ()
    (multiple-value-bind (datum status) (decode-pjs0 *receipt-octets*)
      (and datum (eq :canonical status)
           (eq :authorized (receipt-decision datum))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field datum "receipt" "terminal-ordinal")))))))

(scheck "the surviving journal validates :valid with exactly 3 frames ~
         (grant · unrelated · revocation), no tail — the whole first life ~
         is durable history now"
  (lambda ()
    (let ((report (validate-journal (open-store *scratch-store*))))
      (and (eq :valid (prefix-report-status report))
           (= 3 (prefix-report-frame-count report))
           (null (prefix-report-tail-sha256 report))))))

(snote "EVENTS.pj0: ~a octets · sha256 ~a" (length *events-octets*)
       *events-sha*)
(snote "RECEIPT-AT-P.pjs: ~a octets · sha256 ~a" (length *receipt-octets*)
       *receipt-sha*)

;;; ---------------------------------------------------------------------------
;;; Phase 3 — the restart: a genuinely new process over durable bytes +
;;; declared configuration.

(snote "~%== phase 3 — the restart (genuinely new process; durable bytes + ~
        declared configuration only) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-restart.lisp" "redivivus")
  (scheck "the restart process completed and rendered its own final ~
           sentinel (exit 0 AND RESULT:)"
    (lambda () (and (eql 0 code) sentinel))))

(scheck "THE ORIGINAL RECEIPT IS UNCHANGED: the preserved receipt file is ~
         byte-identical across the restart (sha256 equal) — nothing about ~
         the refusal edited, revoked, or 'expired' the historical receipt; ~
         it remains a true statement about prefix P that is no longer a ~
         key to the present"
  (lambda ()
    (string= *receipt-sha* (sha256-hex (sp-read-octets *receipt-channel*)))))

(scheck "the journal bytes are unchanged across the restart too (sha256 ~
         equal): reconstruction reads; it never writes"
  (lambda ()
    (string= *events-sha* (sha256-hex (store-octets "EVENTS.pj0")))))

;;; ---------------------------------------------------------------------------
;;; Phase 4 — negative control: a truncated restart is DETECTED.

(snote "~%== phase 4 — negative control: the truncated restart ==")

(scheck "a restart process TRUNCATED mid-run is detected by this runner: ~
         the child exits 3 with no RESULT: sentinel, and the detection is ~
         exactly that pair (an unfinished reconstruction must never read ~
         as a clean one)"
  (lambda ()
    (multiple-value-bind (code sentinel text)
        (run-stage "stage-restart.lisp" "truncated-control"
                   :environment (list "DE_POTESTATE_DIE=1"))
      (and (eql 3 code)
           (not sentinel)
           (search "dying mid-restart" text)))))

;;; ---------------------------------------------------------------------------
;;; Phase 5 — preserved artifacts (raw bytes, tracked, with a manifest).

(snote "~%== phase 5 — preserved artifacts ==")

(sp-write-octets (merge-pathnames "ARTIFACT-EVENTS.pj0" *specimen-root*)
                 *events-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs"
                                  *specimen-root*)
                 *metadata-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs.sha256"
                                  *specimen-root*)
                 *sidecar-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-RECEIPT-AT-P.pjs"
                                  *specimen-root*)
                 *receipt-octets*)
(sp-write-octets
 (merge-pathnames "ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (sp-ascii (format nil "~a  ARTIFACT-EVENTS.pj0~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs.sha256~%~
                        ~a  ARTIFACT-RECEIPT-AT-P.pjs~%"
                   *events-sha*
                   (sha256-hex *metadata-octets*)
                   (sha256-hex *sidecar-octets*)
                   *receipt-sha*)))
(sp-write-octets
 (merge-pathnames "ARTIFACT-MANIFEST.txt" *specimen-root*)
 (sp-ascii
  (format nil
          "de-potestate-revocata - preserved raw artifacts~%~
           governing sentence: history may prove that authority once ~
           existed; only the validated present prefix can say whether it ~
           remains live.~%~
           store identity: ~a~%~
           EVENTS.pj0: ~a octets  sha256 ~a  (3 frames: grant g-001 - ~
           unrelated u-001 - revocation r-001; :valid, no tail)~%~
           RECEIPT-AT-P.pjs: ~a octets  sha256 ~a  (:authorized at ~
           terminal ordinal 1, preserved by the first life, byte-identical ~
           across the restart)~%~
           byte-stability: every file listed here is byte-identical across ~
           runs (fixed store nonce; declared PJ-META-1 deviation, see ~
           specimen-common.lisp)~%"
          (expected-store-id)
          (length *events-octets*) *events-sha*
          (length *receipt-octets*) *receipt-sha*)))

(scheck "the preserved artifacts are byte-identical to the live files they ~
         copy (sha256 of each artifact equals the digest recorded from the ~
         live bytes) and the SHA256SUMS manifest carries those digests"
  (lambda ()
    (let ((sums (sp-octets-string
                 (sp-read-octets
                  (merge-pathnames "ARTIFACT-SHA256SUMS.txt"
                                   *specimen-root*)))))
      (and (string= *events-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames "ARTIFACT-EVENTS.pj0"
                                                  *specimen-root*))))
           (string= *receipt-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames "ARTIFACT-RECEIPT-AT-P.pjs"
                                                  *specimen-root*))))
           (search *events-sha* sums)
           (search *receipt-sha* sums)))))

;;; ---------------------------------------------------------------------------
;;; Scratch teardown.  Everything evidential has been preserved as an
;;; ARTIFACT-* file or printed into this capture; the scratch stores are
;;; rebuilt from scratch on every run and are never the record.  (A run
;;; that dies before this point leaves them on disk for inspection.)

(dolist (directory (list *scratch-store* *scratch-run*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%de-potestate-revocata: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(format t "processes: 1 first life (exited; memory gone) · 2 restarts ~
           launched (primary, truncated-control) · artifacts preserved: ~
           ARTIFACT-EVENTS.pj0 + metadata + sidecar + RECEIPT-AT-P + ~
           sha256sums + manifest · every authority verdict rendered by a ~
           stage child through the public surface~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
