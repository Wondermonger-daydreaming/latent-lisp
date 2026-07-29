;;;; run-specimen.lisp — de-teste-occiso, the inhabited restart specimen.
;;;;
;;;; "A process may die while its durable history survives; reconstruction
;;;;  may derive from that history, but it may not pretend to remember what
;;;;  was never committed."
;;;;
;;;; This runner is the ESTABLISHER and the kill supervisor.  It:
;;;;   1. builds a :synced journal and durably commits three events;
;;;;   2. launches a SEPARATE writer process (stage-writer-child.lisp)
;;;;      charged with one further append and SIGKILLs it at ONE governed
;;;;      progress point — §1 CW-3, after the declared durability barrier
;;;;      and before the append receipt reaches the caller;
;;;;   3. preserves the post-kill store bytes as raw CRASH-ARTIFACT-* files;
;;;;   4. hands the surviving bytes to a GENUINELY NEW process
;;;;      (stage-recover.lisp), whose verdicts are relayed and renumbered
;;;;      here;
;;;;   5. exhibits a DERIVED CW-1 byte state (a truncation of the crash
;;;;      artifact — labelled derived, NOT a second kill) and runs the
;;;;      recovery over it;
;;;;   6. runs negative controls in which the specimen itself is shown to
;;;;      notice, each naming the exact check that reddens.
;;;;
;;;; Run:  sbcl --script mneme/journal0/de-teste-occiso/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: the capture prints no pid, no timestamp, no absolute path,
;;;; and no random store identity.  The store nonce is fixed (declared
;;;; deviation from PJ-META-1 unpredictability, specimen-common.lisp), so
;;;; every digest below is byte-stable across runs.
;;;;
;;;; — SUPERSTES (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

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

(defmacro expects (condition-type &body body)
  `(handler-case (progn ,@body nil)
     (,condition-type () t)
     (error () nil)))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defun store-octets (directory &optional (name "EVENTS.pj0"))
  (or (so-read-octets (merge-pathnames name directory))
      (make-array 0 :element-type '(unsigned-byte 8))))

;;; ---------------------------------------------------------------------------
;;; Phase 0 — a clean world.

(fresh-directory *scratch-store*)
(fresh-directory *scratch-run*)
(fresh-directory *scratch-torn*)
(fresh-directory *scratch-mutated*)
(fresh-directory *scratch-controls*)

(snote "de-teste-occiso — the inhabited restart specimen")
(snote "governing sentence: a process may die while its durable history ~
        survives; reconstruction may derive from that history, but it may ~
        not pretend to remember what was never committed.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the life before the death: a valid, durably committed chain.

(snote "== phase 1 — the established chain (:synced, three events) ==")

(defvar *store* (create-journal *scratch-store*
                                :declared-durability *specimen-durability*
                                :nonce-octets *specimen-nonce*))

(defvar *established-receipts*
  (mapcar (lambda (event) (append-event *store* event)) (established-events)))

(scheck "the journal is created with declared durability :synced and a ~
         store identity derived from its own metadata basis (§6.1)"
  (lambda () (eq (journal-store-durability *store*) :synced)))

(scheck "three events commit through the public §9 append path at ordinals ~
         1, 2, 3, each :newly-committed (PJ-APP-1)"
  (lambda ()
    (and (= 3 (length *established-receipts*))
         (equal '(1 2 3) (mapcar #'append-receipt-ordinal *established-receipts*))
         (every (lambda (receipt)
                  (eq (append-receipt-disposition receipt) :newly-committed))
                *established-receipts*))))

(defvar *pre-kill-octets* (store-octets *scratch-store*))
(defvar *pre-kill-length* (length *pre-kill-octets*))
(defvar *pre-kill-sha* (sha256-hex *pre-kill-octets*))

(scheck "the established chain validates: :valid, 3 frames, every byte of ~
         EVENTS.pj0 inside the valid prefix, no tail"
  (lambda ()
    (let ((report (validate-journal *store*)))
      (and (eq (prefix-report-status report) :valid)
           (= 3 (prefix-report-frame-count report))
           (= *pre-kill-length* (prefix-report-valid-byte-count report))
           (null (prefix-report-tail-octets report))))))

(snote "pre-kill EVENTS.pj0: ~a octets · sha256 ~a" *pre-kill-length*
       *pre-kill-sha*)
(snote "pre-kill ~a~%" (explain-journal *store*))

;;; ---------------------------------------------------------------------------
;;; Phase 2 — the killed witness.

(snote "== phase 2 — the killed writer (separate process, SIGKILL at one ~
        governed progress point) ==")

(defun launch-charged-writer (mode store-directory marker receipt stdout-name)
  "Launch stage-writer-child.lisp as a SEPARATE OS process, charged with one
append, and return its process object.  It never exits of its own accord."
  (sb-ext:run-program
   "sbcl"
   (list "--script" "mneme/journal0/de-teste-occiso/stage-writer-child.lisp"
         (namestring store-directory) (namestring marker) (namestring receipt)
         mode)
   :search t
   :output (merge-pathnames stdout-name *scratch-run*)
   :if-output-exists :supersede
   :error (merge-pathnames (concatenate 'string stdout-name ".err")
                           *scratch-run*)
   :if-error-exists :supersede
   :wait nil))

(defun await-marker (marker)
  "Wait for the child to reach its governed progress point.  Bounded."
  (loop repeat 2400
        when (probe-file marker) return t
        do (sleep 0.05)))

(defvar *child*
  (launch-charged-writer "cw3" *scratch-store* *barrier-sentinel*
                         *receipt-channel* "child-stdout.txt"))

;;; Wait for the governed progress point.  The child writes the barrier
;;; marker only after APPEND-EVENT has returned — i.e. after the §10.1
;;; fsync(2) barrier and the §9.2 step-9 reopen validation.  The marker
;;; carries no ordinal, no digest and no event identity: it says "the call
;;; returned", never what it returned.
(defvar *barrier-observed* (await-marker *barrier-sentinel*))

(scheck "the charged writer reached the governed progress point: the barrier ~
         marker appeared, and its bytes are the fixed constant ~
         \"BARRIER-PASSED\" — zero coordinate information crosses to the ~
         supervisor"
  (lambda ()
    (and *barrier-observed*
         (equalp (so-read-octets *barrier-sentinel*)
                 (so-ascii +barrier-sentinel-bytes+)))))

(sb-posix:kill (sb-ext:process-pid *child*) 9)
(sb-ext:process-wait *child*)

(scheck "the writer died by SIGKILL — no unwinding, no cleanup, no ~
         opportunity to deliver anything (process status :signaled, signal 9)"
  (lambda ()
    (and (eq (sb-ext:process-status *child*) :signaled)
         (eql 9 (sb-ext:process-exit-code *child*)))))

(scheck "NO RECEIPT REACHED THE CALLER: the delivery channel the child would ~
         have written after its wait loop does not exist, and the child's ~
         stdout carries no ordinal or disposition (PJ-CW-3, PJ-APP-5 — the ~
         frame, not the receipt object, is the primary fact)"
  (lambda ()
    (let ((stdout (so-read-octets (merge-pathnames "child-stdout.txt"
                                                   *scratch-run*))))
      (and (null (probe-file *receipt-channel*))
           (or (null stdout)
               (let ((text (so-octets-string stdout)))
                 (and (null (search "ordinal" text))
                      (null (search "disposition" text)))))))))

;;; ---------------------------------------------------------------------------
;;; Phase 3 — raw crash artifacts (the recovery's input, made inspectable).

(snote "~%== phase 3 — raw crash artifacts ==")

(defvar *post-kill-octets* (store-octets *scratch-store*))
(defvar *post-kill-length* (length *post-kill-octets*))
(defvar *post-kill-sha* (sha256-hex *post-kill-octets*))
(defvar *final-frame-length* (- *post-kill-length* *pre-kill-length*))
(defvar *post-kill-metadata* (store-octets *scratch-store* "JOURNAL-META.pjs"))
(defvar *post-kill-sidecar*
  (store-octets *scratch-store* "JOURNAL-META.pjs.sha256"))

(so-write-octets (merge-pathnames "CRASH-ARTIFACT-EVENTS.pj0" *specimen-root*)
                 *post-kill-octets*)
(so-write-octets (merge-pathnames "CRASH-ARTIFACT-JOURNAL-META.pjs"
                                  *specimen-root*)
                 *post-kill-metadata*)
(so-write-octets (merge-pathnames "CRASH-ARTIFACT-JOURNAL-META.pjs.sha256"
                                  *specimen-root*)
                 *post-kill-sidecar*)
(so-write-octets
 (merge-pathnames "CRASH-ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (so-ascii (format nil "~a  CRASH-ARTIFACT-EVENTS.pj0~%~
                        ~a  CRASH-ARTIFACT-JOURNAL-META.pjs~%~
                        ~a  CRASH-ARTIFACT-JOURNAL-META.pjs.sha256~%"
                   *post-kill-sha*
                   (sha256-hex *post-kill-metadata*)
                   (sha256-hex *post-kill-sidecar*))))

(scheck "the preserved crash artifact is byte-identical to the surviving ~
         store: CRASH-ARTIFACT-EVENTS.pj0 sha256 equals the live ~
         EVENTS.pj0 sha256 (the recovery's input is inspectable evidence, ~
         not a summary)"
  (lambda ()
    (string= *post-kill-sha*
             (sha256-hex (so-read-octets
                          (merge-pathnames "CRASH-ARTIFACT-EVENTS.pj0"
                                           *specimen-root*))))))

(snote "post-kill EVENTS.pj0: ~a octets · sha256 ~a" *post-kill-length*
       *post-kill-sha*)
(snote "final frame: ~a octets, starting at byte ~a (derived: post-kill ~
        length minus pre-kill length)" *final-frame-length* *pre-kill-length*)

;;; --- the byte proof of the cell -------------------------------------------

(snote "~%-- which §1 cell was hit, and how the bytes prove it --")

(defvar *post-kill-report*
  (validate-event-octets *post-kill-octets* (journal-store-store-id *store*)))

(scheck "(a) rules out CW-0 and CW-1: the surviving bytes validate :valid ~
         with 4 frames — a COMPLETE fourth frame is present and chains to ~
         the third (CW-0 would show 3 frames and CW-1 a torn tail)"
  (lambda ()
    (and (eq (prefix-report-status *post-kill-report*) :valid)
         (= 4 (prefix-report-frame-count *post-kill-report*)))))

(scheck (format nil "(b) rules out CW-2a/CW-2b: zero excluded octets — the ~
                     valid prefix consumes all ~a bytes, so no bytes are ~
                     absent and none are torn" *post-kill-length*)
  (lambda ()
    (and (= *post-kill-length*
            (prefix-report-valid-byte-count *post-kill-report*))
         (null (prefix-report-tail-octets *post-kill-report*)))))

(scheck "(c) the fourth frame carries exactly the charged event: its payload ~
         is byte-identical to the canonical encoding of the declared charge, ~
         at ordinal 4"
  (lambda ()
    (let* ((events (prefix-report-events *post-kill-report*))
           (last-event (aref events 3)))
      (equalp (encode-pjs0 last-event) (encode-pjs0 (fatal-event))))))

(scheck "(d) the death was AFTER the critical section, not inside it: no ~
         LOCK file survives, because the child's append had returned and its ~
         unwind-protect had released the lock before the kill (a kill inside ~
         §9.2 would have left the lock held — PJ-LOCK-2: the lock is ~
         coordination machinery, never committed evidence)"
  (lambda () (null (probe-file (merge-pathnames "LOCK" *scratch-store*)))))

(scheck "(e) the caller holds NO receipt for a frame that IS durably ~
         committed — the CW-3 condition itself, and the append-side analogue ~
         of an uncertain external write (PJ-CW-3)"
  (lambda ()
    (and (null (probe-file *receipt-channel*))
         (= 4 (prefix-report-frame-count *post-kill-report*)))))

(snote "CELL HIT: CW-3 (synced) — barrier satisfied, receipt undelivered.")
(snote "HONEST LIMIT, stated because the bytes cannot say it: CW-2c and CW-3 ~
        are BYTE-IDENTICAL by design (§29; ALLOWED-SOURCES standing note 2). ~
        The bytes prove a complete durable frame; what distinguishes CW-3 ~
        from CW-2c here is the harness's ORDERING RECORD — the barrier ~
        marker was written only after APPEND-EVENT returned, i.e. after the ~
        §10.1 fsync and the step-9 reopen validation — together with the ~
        store's declared :synced durability. That ordering is scaffolding ~
        evidence, not byte evidence, and it is named as such.")
(snote "PJ-DUR-3 bound: :synced here means fsync(2) returned and the reopen ~
        validated on this host. It is never power-loss proof.~%")

;;; ---------------------------------------------------------------------------
;;; Relay machinery for the recovery process.

(defun run-recovery (mode directory &key salvage-destination environment
                                         (label mode))
  "Launch stage-recover.lisp as a GENUINELY NEW process.  Relays its NOTE
lines, renumbers its CHECK lines into this runner's verdict stream, and
returns (values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (append (list "--script"
                                 "mneme/journal0/de-teste-occiso/stage-recover.lisp"
                                 (namestring directory) mode)
                           (when salvage-destination
                             (list (namestring salvage-destination))))
                   :search t
                   :output output
                   :error output
                   :environment (append environment (sb-ext:posix-environ))))
         (text (get-output-stream-string output))
         (saw-result nil))
    (with-input-from-string (stream text)
      (loop for line = (read-line stream nil nil)
            while line
            do (cond
                 ((and (>= (length line) 9) (string= "CHECK ok " (subseq line 0 9)))
                  (let ((body (subseq line 9)))
                    (incf *checks*)
                    (format t "[~3,'0d] ok   (~a) ~a~%" *checks* label body)))
                 ((and (>= (length line) 11)
                       (string= "CHECK FAIL " (subseq line 0 11)))
                  (let ((body (subseq line 11)))
                    (incf *checks*) (incf *failures*)
                    (format t "[~3,'0d] FAIL (~a) ~a~%" *checks* label body)))
                 ((and (>= (length line) 5) (string= "NOTE " (subseq line 0 5)))
                  (format t "      | ~a~%" (subseq line 5)))
                 ((and (>= (length line) 7) (string= "RESULT:" (subseq line 0 7)))
                  (setf saw-result t)
                  (format t "      | ~a~%" line))
                 ((zerop (length line)) nil)
                 (t (format t "      | ~a~%" line)))))
    (values (sb-ext:process-exit-code process) saw-result text)))

;;; ---------------------------------------------------------------------------
;;; Phase 4 — the restart: a genuinely new process over the surviving bytes.

(snote "== phase 4 — the restart (new process; durable bytes + declared ~
        configuration only) ==")

(multiple-value-bind (code sentinel) (run-recovery "primary" *scratch-store*
                                                   :label "restart")
  (scheck "the restart process completed and rendered its own final sentinel ~
           (exit 0 AND a RESULT: line — an incomplete transcript licenses ~
           nothing)"
    (lambda () (and (eql 0 code) sentinel))))

(scheck "the restart wrote no new frame: EVENTS.pj0 is byte-identical to the ~
         preserved crash artifact after the whole recovery, reconciliation ~
         included (zero new bytes)"
  (lambda () (string= *post-kill-sha* (sha256-hex (store-octets *scratch-store*)))))

;;; ---------------------------------------------------------------------------
;;; Phase 5 — a DERIVED CW-1 byte state (labelled derived; not a second kill).

(snote "~%== phase 5 — derived CW-1 exhibit (a TRUNCATION of the crash ~
        artifact, not a second kill) ==")

(dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
  (so-write-octets (merge-pathnames name *scratch-torn*)
                   (store-octets *scratch-store* name)))
(defvar *torn-cut* 7)
(so-write-octets (merge-pathnames "EVENTS.pj0" *scratch-torn*)
                 (subseq *post-kill-octets* 0 (- *post-kill-length* *torn-cut*)))

(snote "derived state: the final frame's last ~a octets removed — the CW-1 ~
        cell of Annex B (proper terminal prefix; prior prefix valid; torn ~
        tail visible; source untouched)." *torn-cut*)

(defvar *torn-salvage-destination*
  (merge-pathnames "salvage/" *scratch-controls*))

(multiple-value-bind (code sentinel)
    (run-recovery "torn" *scratch-torn*
                  :salvage-destination *torn-salvage-destination*
                  :label "torn")
  (scheck "the restart over the derived CW-1 state completed with its own ~
           final sentinel (exit 0 AND RESULT:)"
    (lambda () (and (eql 0 code) sentinel))))

;;; ---------------------------------------------------------------------------
;;; Phase 6 — negative controls.  Each names the exact check that reddens.

(snote "~%== phase 6 — negative controls (the specimen shown noticing) ==")

;;; NC-1: a mutated payload byte.
(dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
  (so-write-octets (merge-pathnames name *scratch-mutated*)
                   (store-octets *scratch-store* name)))
(defvar *mutation-offset*
  (search (so-ascii "died over") *post-kill-octets* :start2 *pre-kill-length*))
(defvar *mutated-octets* (copy-seq *post-kill-octets*))
(setf (aref *mutated-octets* *mutation-offset*) (char-code #\D))
(so-write-octets (merge-pathnames "EVENTS.pj0" *scratch-mutated*)
                 *mutated-octets*)

(scheck "control 1 setup: exactly ONE payload byte differs from the crash ~
         artifact, inside the fourth frame's payload, preserving length and ~
         canonicality (so the check that reddens is the digest, not the ~
         grammar)"
  (lambda ()
    (and (integerp *mutation-offset*)
         (> *mutation-offset* *pre-kill-length*)
         (= (length *mutated-octets*) *post-kill-length*)
         (= 1 (loop for index below *post-kill-length*
                    count (/= (aref *mutated-octets* index)
                              (aref *post-kill-octets* index)))))))

(multiple-value-bind (code sentinel)
    (run-recovery "mutated" *scratch-mutated* :label "mutated")
  (scheck "control 1 — recovery over mutated journal bytes: the restart ~
           REFUSES the damaged frame and completes its own verdict stream ~
           (exit 0 AND RESULT:; the reddening check is the §8.2 payload ~
           digest recomputation, rendered above)"
    (lambda () (and (eql 0 code) sentinel))))

;;; NC-2: recovery beyond the validated prefix (runner-side twin of the
;;; restart's own K0E-11 check, over the corrupted store).
(scheck "control 2 — reconstruction beyond the validated prefix over the ~
         CORRUPTED store is refused: requesting ordinal 4 signals ~
         unsupported-reconstruction; the reddening check is K0E-11's ~
         prefix-bound comparison (recovery never reaches past damage)"
  (lambda ()
    (let ((store (open-store *scratch-mutated*)))
      (expects unsupported-reconstruction
        (reconstruct store '("de-teste-occiso" "restart-fold" "0")
                     :requested-terminal-ordinal 4)))))

;;; NC-3: a derivation that would need non-journal state.
(scheck "control 3 — a derivation that would need NON-JOURNAL state refuses ~
         rather than guesses: two non-superseded attempts on one seat make ~
         occupancy underdetermined, and the fold signals ~
         unsupported-reconstruction instead of selecting the newest or ~
         highest-ordinal attempt (PJ-FOLD-4; the reddening check is the ~
         open-attempt count in derive-seat-resolution)"
  (lambda ()
    (let ((store (create-journal (merge-pathnames "seat/" *scratch-controls*)
                                 :nonce-octets *specimen-nonce*)))
      (flet ((attempt-event (id attempt)
               (lisp-plus-cd0:make-record-datum
                (list (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "event-id"))
                       (identifier-from-segments (list "event" id)))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "kind"))
                       (identifier-from-segments '("attempt" "begun")))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "attempt"))
                       (identifier-from-segments (list "attempt" attempt)))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "seat-id"))
                       (identifier-from-segments '("seat" "occisus")))))))
        (append-event store (attempt-event "s-001" "a1"))
        (and (eq :occupied (derive-seat-resolution store '("seat" "occisus")))
             (progn (append-event store (attempt-event "s-002" "a2"))
                    (expects unsupported-reconstruction
                      (derive-seat-resolution store '("seat" "occisus")))))))))

;;; NC-4: the runner's own truncation sentinel.
(scheck "control 4 — a restart process TRUNCATED mid-run is detected by this ~
         runner: the child exits 3 with no RESULT: sentinel, and the ~
         detection is exactly that pair (an unfinished recovery must never ~
         read as a clean one)"
  (lambda ()
    (multiple-value-bind (code sentinel text)
        (run-recovery "primary" *scratch-store*
                      :environment (list "DE_TESTE_OCCISO_DIE=1")
                      :label "truncated-control")
      (and (eql 3 code)
           (not sentinel)
           (search "dying mid-recovery" text)))))

;;; NC-5: coordination machinery is not evidence.
(scheck "control 5 — an unsafe retry under a HELD writer lock is refused ~
         with pj0-lock-failure and writes zero bytes; with the lock released ~
         the same retry reconciles as :already-committed-identical (§11; ~
         PJ-LOCK-2 — the lock coordinates, it never testifies)"
  (lambda ()
    (let ((lock (merge-pathnames "LOCK" *scratch-store*))
          (store (open-store *scratch-store*))
          (before (sha256-hex (store-octets *scratch-store*))))
      (so-write-octets lock (so-ascii "held by nobody"))
      (unwind-protect
           (and (expects pj0-lock-failure
                  (append-event store (fatal-event) :origin :reconstructed))
                (string= before (sha256-hex (store-octets *scratch-store*))))
        (delete-file lock))
      (let ((receipt (append-event store (fatal-event) :origin :reconstructed)))
        (and (eq (append-receipt-disposition receipt)
                 :already-committed-identical)
             (string= before (sha256-hex (store-octets *scratch-store*))))))))

;;; NC-6: teeth for the specimen's own cell proof.
(scheck "control 6 — the CW-3 byte proof has TEETH: the same predicate ~
         (\":valid with 4 frames\") applied to the PRE-KILL bytes returns ~
         false (3 frames), so a green (a) is a finding and not a tautology"
  (lambda ()
    (let ((report (validate-event-octets *pre-kill-octets*
                                         (journal-store-store-id *store*))))
      (and (eq (prefix-report-status report) :valid)
           (not (= 4 (prefix-report-frame-count report)))))))

;;; NC-7: teeth for the undelivered-receipt proof.
(scheck "control 7 — the undelivered-receipt proof has TEETH: with a receipt ~
         planted on the delivery channel the same predicate returns false, ~
         and it returns true again once the plant is removed"
  (lambda ()
    (let ((planted (probe-file *receipt-channel*)))
      (declare (ignore planted))
      (so-write-octets *receipt-channel* (so-ascii "ordinal 4"))
      (let ((while-planted (null (probe-file *receipt-channel*))))
        (delete-file *receipt-channel*)
        (and (not while-planted) (null (probe-file *receipt-channel*)))))))

;;; NC-8: the cell is a FINDING, not a harness constant.  Same charge, same
;;; child program, same supervisor — only the governed progress point moves,
;;; from CW-3 (after the barrier) to CW-0 (before the first frame byte).

(snote "~%-- control 8: the same harness aimed at a DIFFERENT §1 cell --")

(defvar *cw0-store-directory* (merge-pathnames "cw0/" *scratch-controls*))
(defvar *cw0-store*
  (create-journal *cw0-store-directory*
                  :declared-durability *specimen-durability*
                  :nonce-octets *control-nonce*))
(dolist (event (established-events)) (append-event *cw0-store* event))
(defvar *cw0-before-sha* (sha256-hex (store-octets *cw0-store-directory*)))

(scheck "control 8 setup: a second :synced store with a DISTINCT derived ~
         identity carries the same three established events"
  (lambda ()
    (let ((report (validate-journal *cw0-store*)))
      (and (eq (prefix-report-status report) :valid)
           (= 3 (prefix-report-frame-count report))
           (not (string= (journal-store-store-id *cw0-store*)
                         (journal-store-store-id *store*)))))))

(defvar *cw0-marker* (merge-pathnames "CW0-MARKER" *scratch-run*))
(defvar *cw0-receipt* (merge-pathnames "CW0-RECEIPT.txt" *scratch-run*))
(defvar *cw0-child*
  (launch-charged-writer "cw0" *cw0-store-directory* *cw0-marker*
                         *cw0-receipt* "cw0-child-stdout.txt"))
(defvar *cw0-observed* (await-marker *cw0-marker*))
(sb-posix:kill (sb-ext:process-pid *cw0-child*) 9)
(sb-ext:process-wait *cw0-child*)

(scheck "control 8 — moving ONLY the kill point lands the SAME charge in ~
         CW-0 instead of CW-3: the writer is killed before the first frame ~
         byte, the bytes are unchanged (sha identical to pre-kill), the ~
         store is :valid at 3 frames with no tail and no LOCK, and the ~
         charged event is ABSENT by identity lookup (Annex B, synced/CW-0: ~
         prior bytes only · no prefix contribution · event absent)"
  (lambda ()
    (and *cw0-observed*
         (eq (sb-ext:process-status *cw0-child*) :signaled)
         (eql 9 (sb-ext:process-exit-code *cw0-child*))
         (string= *cw0-before-sha* (sha256-hex (store-octets
                                                *cw0-store-directory*)))
         (null (probe-file (merge-pathnames "LOCK" *cw0-store-directory*)))
         (null (probe-file *cw0-receipt*))
         (let ((report (validate-journal (open-store *cw0-store-directory*))))
           (and (eq (prefix-report-status report) :valid)
                (= 3 (prefix-report-frame-count report))
                (null (prefix-report-tail-octets report))))
         (null (find-event (open-store *cw0-store-directory*)
                           (record-field (fatal-event) "event" "event-id"))))))

(scheck "control 8, the contrast that carries the whole specimen: at CW-0 ~
         the ordinary retry COMMITS a new frame (:newly-committed at ordinal ~
         4, bytes grow), where at CW-3 the byte-identical retry RECONCILED ~
         (:already-committed-identical, zero new bytes). Same charge, same ~
         code, different cell, different lawful recovery — so the cell ~
         reported in phase 2 is a finding, not a constant of this harness"
  (lambda ()
    (let* ((store (open-store *cw0-store-directory*))
           (before (sha256-hex (store-octets *cw0-store-directory*)))
           (receipt (append-event store (fatal-event) :origin :delivered))
           (after (sha256-hex (store-octets *cw0-store-directory*))))
      (and (eq (append-receipt-disposition receipt) :newly-committed)
           (= 4 (append-receipt-ordinal receipt))
           (not (string= before after))))))

;;; ---------------------------------------------------------------------------
;;; Manifest for the preserved artifacts (deterministic; written last).

(so-write-octets
 (merge-pathnames "CRASH-ARTIFACT-MANIFEST.txt" *specimen-root*)
 (so-ascii
  (format nil
          "de-teste-occiso - raw crash artifacts (post-SIGKILL store bytes)~%~
           cell hit: CW-3 (synced) - durability barrier satisfied, append ~
           receipt undelivered~%~
           store identity: ~a~%~
           pre-kill  EVENTS.pj0: ~a octets  sha256 ~a  (3 frames)~%~
           post-kill EVENTS.pj0: ~a octets  sha256 ~a  (4 frames, valid, ~
           zero excluded octets)~%~
           final frame: ~a octets beginning at byte ~a~%~
           LOCK after the kill: absent (the critical section had completed)~%~
           receipt delivered to the caller: none~%~
           byte-stability: every file listed here is byte-identical across ~
           runs (fixed store nonce; see specimen-common.lisp)~%"
          (journal-store-store-id *store*)
          *pre-kill-length* *pre-kill-sha*
          *post-kill-length* *post-kill-sha*
          *final-frame-length* *pre-kill-length*)))

(scheck "the artifact manifest is written and its own digest lines match the ~
         artifacts on disk"
  (lambda ()
    (let ((sums (so-octets-string
                 (so-read-octets (merge-pathnames "CRASH-ARTIFACT-SHA256SUMS.txt"
                                                  *specimen-root*)))))
      (and (search *post-kill-sha* sums)
           (probe-file (merge-pathnames "CRASH-ARTIFACT-MANIFEST.txt"
                                        *specimen-root*))))))

;;; ---------------------------------------------------------------------------
;;; Scratch teardown.  Everything evidential has already been preserved as a
;;; CRASH-ARTIFACT-* file or printed into this capture; the scratch stores are
;;; rebuilt from scratch on every run and are never the record.  (A run that
;;; dies before this point leaves them on disk for inspection.)

(dolist (directory (list *scratch-store* *scratch-run* *scratch-torn*
                         *scratch-mutated* *scratch-controls*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%de-teste-occiso: ~a check~:p, ~a failure~:p~%" *checks* *failures*)
(format t "cells hit by live SIGKILL: CW-3 (:synced, phase 2, the specimen) ~
           and CW-0 (:synced, control 8, the teeth) · crash artifacts ~
           preserved: CRASH-ARTIFACT-EVENTS.pj0 (+ metadata, sidecar, ~
           sha256sums, manifest) · derived byte states exhibited: CW-1 ~
           (truncation) and a one-byte payload mutation · killed writer ~
           processes: 2 · restart processes launched: 4 (primary, torn, ~
           mutated, truncated-control) · negative controls: 8~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
