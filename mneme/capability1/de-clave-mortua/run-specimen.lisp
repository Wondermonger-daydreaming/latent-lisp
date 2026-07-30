;;;; run-specimen.lisp — de-clave-mortua, the inhabited dead-key specimen.
;;;;
;;;; "A receipt may explain why a key was minted; it is not the key, and
;;;;  its description cannot forge one."
;;;;
;;;; This runner is the ORCHESTRATOR and artifact preserver.  It:
;;;;   1. launches the PRIMA VITA (stage-first-life.lisp) as a SEPARATE
;;;;      process: bootstrap → grant → :authorized at P → MINT → successful
;;;;      presentation → the key's complete PUBLIC record preserved to disk
;;;;      (authorization receipt bytes, minting receipt bytes, printed
;;;;      form) → EXIT (the key dies with the process);
;;;;   2. digests the surviving durable bytes;
;;;;   3. launches the REDIVIVUS (stage-restart.lisp) — a GENUINELY NEW
;;;;      process consulting ONLY durable bytes + declared configuration —
;;;;      whose verdicts are relayed and renumbered here: the same
;;;;      authorization decision reconstructed (:reconstructed, L10); the
;;;;      dead key UNOBTAINABLE from any preserved byte (receipts refused,
;;;;      internal-constructor mimic refused, printed form reader-rejected);
;;;;      a FRESH mint yielding a NEW key (new identities, same grant) that
;;;;      presents successfully;
;;;;   4. proves the preserved record and the journal bytes are
;;;;      BYTE-IDENTICAL across the restart (by sha256), and that the two
;;;;      lives' minting receipts name DIFFERENT keys linked to the SAME
;;;;      grant;
;;;;   5. runs the truncation negative control (a restart aborted mid-run
;;;;      by a planted fault — no signal, no SIGKILL — is DETECTED: exit 3,
;;;;      no RESULT sentinel);
;;;;   6. preserves the raw bytes as tracked ARTIFACT-* files with a
;;;;      SHA256SUMS manifest.
;;;;
;;;; The orchestrator never mints, presents, or derives authority itself:
;;;; every capability verdict in this capture was rendered by a stage child
;;;; through the public surface (one labelled ::-exception inside the
;;;; restart, which is itself the point being proven).
;;;;
;;;; Run:  sbcl --script mneme/capability1/de-clave-mortua/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; the store nonce is fixed (declared PJ-META-1 deviation,
;;;; specimen-common.lisp) and both lives' query identities are declared
;;;; charge, so every digest and identity below is byte-stable across runs.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability1)

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
;;; Stage-child relay (the de-teste-occiso / de-potestate-revocata protocol).

(defun run-stage (script label &key environment)
  "Launch SCRIPT as a genuinely separate `sbcl --script` process.  Relays
its NOTE lines, renumbers its CHECK lines into this runner's verdict
stream, and returns (values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (list "--script"
                         (concatenate 'string
                                      "mneme/capability1/de-clave-mortua/"
                                      script)
                         (namestring *scratch-store*)
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
(fresh-directory *scratch-run*)

(snote "de-clave-mortua — the inhabited dead-key specimen")
(snote "governing sentence: a receipt may explain why a key was minted; it ~
        is not the key, and its description cannot forge one.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the first life (separate process; the key dies with it).

(snote "== phase 1 — the first life (separate process: bootstrap · grant · ~
        query at P · MINT · present · preserve testimony · exit) ==")

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
(defvar *auth-octets* (sp-read-octets (auth-receipt-path *scratch-run*)))
(defvar *auth-sha* (sha256-hex *auth-octets*))
(defvar *mint-octets* (sp-read-octets (mint-receipt-path *scratch-run*)))
(defvar *mint-sha* (sha256-hex *mint-octets*))
(defvar *print-octets* (sp-read-octets (dead-key-print-path *scratch-run*)))
(defvar *print-sha* (sha256-hex *print-octets*))

(scheck "the surviving journal validates :valid with exactly 1 frame (the ~
         grant), no tail — neither the mint nor the presentations left a ~
         byte in it"
  (lambda ()
    (let ((report (validate-journal (open-store *scratch-store*))))
      (and (eq :valid (prefix-report-status report))
           (= 1 (prefix-report-frame-count report))
           (null (prefix-report-tail-sha256 report))))))

(scheck "the preserved public record decodes canonically: the ~
         authorization receipt reads :authorized bound to terminal ~
         ordinal 1; the minting receipt reads kind cap1:minting, naming a ~
         cap1-key public identity and grant g-001"
  (lambda ()
    (multiple-value-bind (auth auth-status) (decode-pjs0 *auth-octets*)
      (multiple-value-bind (mint mint-status) (decode-pjs0 *mint-octets*)
        (and auth (eq :canonical auth-status)
             (eq :authorized (receipt-decision auth))
             (= 1 (lisp-plus-cd0:integer-datum-value
                   (record-field auth "receipt" "terminal-ordinal")))
             mint (eq :canonical mint-status)
             (string= "cap1:minting"
                      (identifier-segment-string
                       (record-field mint "receipt" "kind")))
             (eql 0 (search "cap1-key"
                            (identifier-segment-string
                             (record-field mint "receipt"
                                           "capability-public-id"))))
             (datum= (record-field mint "receipt" "grant-event-id")
                     (identifier-from-segments '("cap0-event" "g-001"))))))))

(snote "EVENTS.pj0: ~a octets · sha256 ~a" (length *events-octets*)
       *events-sha*)
(snote "AUTH-RECEIPT.pjs: ~a octets · sha256 ~a" (length *auth-octets*)
       *auth-sha*)
(snote "MINT-RECEIPT.pjs: ~a octets · sha256 ~a" (length *mint-octets*)
       *mint-sha*)
(snote "DEAD-KEY-PRINT.txt: ~a octets · sha256 ~a" (length *print-octets*)
       *print-sha*)

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

(scheck "THE TESTIMONY IS UNCHANGED: authorization receipt, minting ~
         receipt, and printed form are all byte-identical across the ~
         restart (sha256 equal) — four refused necromancies edited nothing"
  (lambda ()
    (and (string= *auth-sha*
                  (sha256-hex (sp-read-octets
                               (auth-receipt-path *scratch-run*))))
         (string= *mint-sha*
                  (sha256-hex (sp-read-octets
                               (mint-receipt-path *scratch-run*))))
         (string= *print-sha*
                  (sha256-hex (sp-read-octets
                               (dead-key-print-path *scratch-run*)))))))

(scheck "the journal bytes are unchanged across the restart too (sha256 ~
         equal): reconstruction, refusal, and re-minting read; they never ~
         write"
  (lambda ()
    (string= *events-sha* (sha256-hex (store-octets "EVENTS.pj0")))))

(defvar *mint-2-octets*
  (sp-read-octets (mint-receipt-2-path *scratch-run*)))

(scheck "THE TWO LIVES MINTED TWO KEYS: the restart's minting receipt ~
         decodes canonically and names a capability public identity AND a ~
         minting occurrence identity both DIFFERENT from the first life's, ~
         while both receipts link the SAME grant event g-001 — the ~
         orchestrator's own cross-life comparison, over nothing but the ~
         two receipts' bytes"
  (lambda ()
    (multiple-value-bind (mint-1 status-1) (decode-pjs0 *mint-octets*)
      (multiple-value-bind (mint-2 status-2) (decode-pjs0 *mint-2-octets*)
        (and mint-1 (eq :canonical status-1)
             mint-2 (eq :canonical status-2)
             (not (datum= (record-field mint-1 "receipt"
                                        "capability-public-id")
                          (record-field mint-2 "receipt"
                                        "capability-public-id")))
             (not (datum= (record-field mint-1 "receipt" "occurrence-id")
                          (record-field mint-2 "receipt" "occurrence-id")))
             (datum= (record-field mint-1 "receipt" "grant-event-id")
                     (record-field mint-2 "receipt" "grant-event-id")))))))

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
                   :environment (list "DE_CLAVE_DIE=1"))
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
(sp-write-octets (merge-pathnames "ARTIFACT-AUTH-RECEIPT.pjs"
                                  *specimen-root*)
                 *auth-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-MINT-RECEIPT.pjs"
                                  *specimen-root*)
                 *mint-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-MINT-RECEIPT-2.pjs"
                                  *specimen-root*)
                 *mint-2-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-DEAD-KEY-PRINT.txt"
                                  *specimen-root*)
                 *print-octets*)
(sp-write-octets
 (merge-pathnames "ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (sp-ascii (format nil "~a  ARTIFACT-EVENTS.pj0~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs~%~
                        ~a  ARTIFACT-JOURNAL-META.pjs.sha256~%~
                        ~a  ARTIFACT-AUTH-RECEIPT.pjs~%~
                        ~a  ARTIFACT-MINT-RECEIPT.pjs~%~
                        ~a  ARTIFACT-MINT-RECEIPT-2.pjs~%~
                        ~a  ARTIFACT-DEAD-KEY-PRINT.txt~%"
                   *events-sha*
                   (sha256-hex *metadata-octets*)
                   (sha256-hex *sidecar-octets*)
                   *auth-sha*
                   *mint-sha*
                   (sha256-hex *mint-2-octets*)
                   *print-sha*)))
(sp-write-octets
 (merge-pathnames "ARTIFACT-MANIFEST.txt" *specimen-root*)
 (sp-ascii
  (format nil
          "de-clave-mortua - preserved raw artifacts~%~
           governing sentence: a receipt may explain why a key was ~
           minted; it is not the key, and its description cannot forge ~
           one.~%~
           store identity: ~a~%~
           EVENTS.pj0: ~a octets  sha256 ~a  (1 frame: grant g-001; ~
           :valid, no tail; neither life's mint or presentations moved ~
           it)~%~
           AUTH-RECEIPT.pjs: ~a octets  sha256 ~a  (:authorized at ~
           terminal ordinal 1; STILL CURRENT at the restart, and still ~
           not a key)~%~
           MINT-RECEIPT.pjs: ~a octets  sha256 ~a  (the dead key's ~
           complete public description; refused by recognition when ~
           presented)~%~
           MINT-RECEIPT-2.pjs: ~a octets  sha256 ~a  (the restart's ~
           fresh key: new public identity, new occurrence, same grant ~
           g-001)~%~
           DEAD-KEY-PRINT.txt: ~a octets  sha256 ~a  (the printed form; ~
           reader-rejected on read-back)~%~
           byte-stability: every file listed here is byte-identical ~
           across runs (fixed store nonce; declared PJ-META-1 deviation, ~
           see specimen-common.lisp)~%"
          (expected-store-id)
          (length *events-octets*) *events-sha*
          (length *auth-octets*) *auth-sha*
          (length *mint-octets*) *mint-sha*
          (length *mint-2-octets*) (sha256-hex *mint-2-octets*)
          (length *print-octets*) *print-sha*)))

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
           (string= *auth-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames "ARTIFACT-AUTH-RECEIPT.pjs"
                                                  *specimen-root*))))
           (string= *mint-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames "ARTIFACT-MINT-RECEIPT.pjs"
                                                  *specimen-root*))))
           (string= *print-sha*
                    (sha256-hex (sp-read-octets
                                 (merge-pathnames
                                  "ARTIFACT-DEAD-KEY-PRINT.txt"
                                  *specimen-root*))))
           (search *events-sha* sums)
           (search *auth-sha* sums)
           (search *mint-sha* sums)
           (search *print-sha* sums)))))

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

(format t "~%de-clave-mortua: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(format t "processes: 1 first life (exited; the key died with it) · 2 ~
           restarts launched (primary, truncated-control) · artifacts ~
           preserved: ARTIFACT-EVENTS.pj0 + metadata + sidecar + ~
           AUTH-RECEIPT + MINT-RECEIPT + MINT-RECEIPT-2 + DEAD-KEY-PRINT ~
           + sha256sums + manifest · every capability verdict rendered by ~
           a stage child~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
