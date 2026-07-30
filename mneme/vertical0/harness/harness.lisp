;;;; harness.lisp — the Vertical Specimen /0 harness: spawner, killer,
;;;; grader (contract §§2.2–2.3, 6).
;;;;
;;;; Run from the latent-lisp root:
;;;;
;;;;   sbcl --script mneme/vertical0/harness/harness.lisp campaign
;;;;   sbcl --script mneme/vertical0/harness/harness.lisp control
;;;;
;;;; THE OTHER SIDE OF THE MECHANICAL PARTITION.  This process owns the
;;;; oracle: it spawns each life of the generic child under strace,
;;;; counts boundary occurrences, kills per the schedule (after
;;;; confirming the child is BLOCKED on its wait pipe), snapshots
;;;; corpses, plays the concurrent provider for the W1 control pair
;;;; (only AFTER banking canonically-equal dispositions), and grades
;;;; corpses, folds, and outcomes against the oracle.
;;;;
;;;; The child NEVER receives: the oracle path, life numbers, W labels,
;;;; the schedule, expected anything — its argv is exactly one execution
;;;; directory; its stdin carries only CONTINUE lines.
;;;;
;;;; BLOCKED-STATE CONFIRMATION, stated honestly: /proc/<pid>/syscall is
;;;; unreadable for a process another tracer (strace) is attached to
;;;; (ptrace exclusivity), so the live confirmation reads
;;;; /proc/<pid>/wchan (anon_pipe_read / pipe_read / wait_woken) plus the
;;;; /proc/<pid>/stat state (S).  The CONTROLLING witness stays the
;;;; strace record: the trace must end with the child's in-flight
;;;; read(0, ... <unfinished> killed by SIGKILL — checked by
;;;; witness.lisp, post-mortem, for every kill.
;;;;
;;;; HARNESS DIAGNOSTICS (this transcript, kill logs) carry PIDs and are
;;;; DECLARED NONCANONICAL (contract §16).  No canonical durable record
;;;; does.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "../program/load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-vertical0)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery.

(defvar *checks* 0)
(defvar *failures* 0)

(defun hcheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[H~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[H~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))
    (finish-output)))

(defun hnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri)
  (finish-output))

;;; ---------------------------------------------------------------------------
;;; Paths and small helpers.

(defvar +vertical-root+ #p"mneme/vertical0/")
(defvar +oracle-path+ (merge-pathnames "VERTICAL-HARNESS-ORACLE.sexp"
                                       +vertical-root+))
(defvar +config-path+ (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp"
                                       +vertical-root+))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defun read-text-file (pathname)
  (with-open-file (stream pathname :direction :input
                                   :if-does-not-exist nil)
    (when stream
      (let ((text (make-string (file-length stream))))
        (subseq text 0 (read-sequence text stream))))))

(defun write-text-file (pathname text)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-string text stream)
    (finish-output stream)))

(defun append-text-line (pathname line)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :if-exists :append
                                   :if-does-not-exist :create)
    (write-string line stream)
    (terpri stream)))

(defun copy-tree-directory (source target)
  (ensure-directories-exist target)
  (let ((process (sb-ext:run-program
                  "cp" (list "-r" (namestring source) (namestring target))
                  :search t :output nil :error nil)))
    (unless (zerop (sb-ext:process-exit-code process))
      (error "corpse snapshot failed: cp -r ~a ~a" source target))))

;;; ---------------------------------------------------------------------------
;;; The oracle (GRADER KNOWLEDGE — this process only).

(defvar *oracle* nil)

(defun read-oracle ()
  (setf *oracle*
        (with-open-file (stream +oracle-path+ :direction :input)
          (let ((*read-eval* nil)
                (*package* (find-package '#:lisp-plus-vertical0)))
            (read stream)))))

(defun oracle-field (key) (rest (find key (rest *oracle*) :key #'first)))

(defun oracle-kill-schedule () (first (oracle-field :kill-schedule)))

(defun oracle-expected-corpses () (first (oracle-field :expected-corpses)))

(defun oracle-expected-outcomes () (first (oracle-field :expected-outcomes)))

(defun oracle-w1-control () (first (oracle-field :w1-control)))

(defun scheduled-kill (boundary occurrence)
  "The kill-schedule row for (BOUNDARY, campaign-cumulative OCCURRENCE),
or NIL."
  (find-if (lambda (row)
             (and (equal (getf row :boundary) boundary)
                  (eql (getf row :occurrence) occurrence)))
           (oracle-kill-schedule)))

;;; ---------------------------------------------------------------------------
;;; /proc sampling (blocked-state confirmation; noncanonical evidence).

(defun read-proc-file (pid name)
  "Read a /proc file completely.  NB: proc files report FILE-LENGTH 0,
so this reads by characters, never by reported size."
  (handler-case
      (with-open-file (stream (format nil "/proc/~a/~a" pid name)
                              :direction :input :if-does-not-exist nil)
        (when stream
          (let ((out (make-string-output-stream)))
            (loop for character = (read-char stream nil nil)
                  while character
                  do (write-char character out))
            (get-output-stream-string out))))
    (error () nil)))

(defun proc-state (pid)
  "The state character from /proc/<pid>/stat (field 3, after the comm)."
  (let ((stat (read-proc-file pid "stat")))
    (when stat
      (let ((close-paren (position #\) stat :from-end t)))
        (when (and close-paren (< (+ close-paren 2) (length stat)))
          (char stat (+ close-paren 2)))))))

(defun wait-until-blocked-on-pipe (pid &key (attempts 3000))
  "Poll until PID sleeps (state S) with wchan showing a pipe read.
Returns the (wchan state) proof strings, or NIL on timeout."
  (loop repeat attempts
        do (let ((wchan (read-proc-file pid "wchan"))
                 (state (proc-state pid)))
             (when (and wchan state (char= state #\S)
                        (or (search "pipe_read" wchan)
                            (search "wait_woken" wchan)))
               (return (list wchan (string state))))
             (sleep 0.01))
        finally (return nil)))

;;; ---------------------------------------------------------------------------
;;; Child driving.

(defvar +strace-set+
  "trace=openat,open,read,pread64,write,pwrite64,fsync,fdatasync,rename,renameat,renameat2,close,unlink,unlinkat")

(defstruct life-result
  exit-code        ; integer exit code, or NIL when killed
  killed-p         ; T when this harness sent SIGKILL
  kill-info        ; plist (:w :boundary :occurrence :seat :pid :wchan)
  pid              ; the child's self-reported pid (noncanonical)
  lines)           ; relayed stdout lines (noncanonical)

(defun parse-ready-line (line)
  "\"BOUNDARY-READY seat=<s> boundary=<b>\" -> (values seat boundary)."
  (let* ((seat-key "seat=")
         (boundary-key "boundary=")
         (seat-start (search seat-key line))
         (boundary-start (search boundary-key line)))
    (when (and seat-start boundary-start)
      (values (string-trim " "
                           (subseq line (+ seat-start (length seat-key))
                                   (1- boundary-start)))
              (string-trim " "
                           (subseq line (+ boundary-start
                                           (length boundary-key))))))))

(defun run-life (exec-dir trace-path kill-log-path occurrences
                 &key (kill-decider #'scheduled-kill) corpse-root)
  "Spawn one life of the generic child under strace and drive its pauses.
OCCURRENCES is a mutable hash boundary->count shared across lives.
KILL-DECIDER maps (boundary occurrence) -> schedule row or NIL.
Returns a LIFE-RESULT.  When a kill row fires: confirm blocked, SIGKILL,
snapshot EXEC-DIR to CORPSE-ROOT/corpse-<W>/, log."
  (let* ((process (sb-ext:run-program
                   "strace"
                   (list "-f" "-s" "256" "-o" (namestring trace-path)
                         "-e" +strace-set+
                         "--" "sbcl" "--script"
                         "mneme/vertical0/program/campaign.lisp"
                         (namestring exec-dir))
                   :search t :wait nil
                   :input :stream :output :stream :error :output))
         (output (sb-ext:process-output process))
         (input (sb-ext:process-input process))
         (pid nil)
         (killed nil)
         (kill-info nil)
         (lines '()))
    (loop for line = (read-line output nil nil)
          while line
          do (push line lines)
             (cond
               ((and (>= (length line) 10)
                     (string= "CHILD-PID " (subseq line 0 10)))
                (setf pid (parse-integer (subseq line 10)))
                (hnote "      | ~a (noncanonical)" line))
               ((and (>= (length line) 14)
                     (string= "BOUNDARY-READY" (subseq line 0 14)))
                (multiple-value-bind (seat boundary) (parse-ready-line line)
                  (let* ((occurrence (incf (gethash boundary occurrences 0)))
                         (row (funcall kill-decider boundary occurrence)))
                    (hnote "      | ~a  [campaign occurrence ~a]"
                           line occurrence)
                    (if row
                        (let ((proof (wait-until-blocked-on-pipe pid)))
                          (unless proof
                            (error "child pid ~a never reached the blocked ~
                                    pipe-read state" pid))
                          (setf killed t
                                kill-info (list :w (getf row :w)
                                                :boundary boundary
                                                :occurrence occurrence
                                                :seat seat
                                                :pid pid
                                                :wchan (first proof)))
                          (hnote "      | KILL: ~a at ~a occurrence ~a ~
                                  (seat ~a): pid ~a blocked ~
                                  [wchan=~a state=~a] -> SIGKILL"
                                 (getf row :w) boundary occurrence seat pid
                                 (first proof) (second proof))
                          (append-text-line
                           kill-log-path
                           (format nil "KILL ~a boundary=~a occurrence=~a ~
                                        seat=~a pid=~a wchan=~a state=~a ~
                                        (noncanonical diagnostics)"
                                   (getf row :w) boundary occurrence seat
                                   pid (first proof) (second proof)))
                          (sb-posix:kill pid 9))
                        (progn
                          (write-line "CONTINUE" input)
                          (finish-output input))))))
               (t (hnote "      | ~a" line))))
    (sb-ext:process-wait process)
    (let ((exit-code (sb-ext:process-exit-code process)))
      (when (and killed corpse-root kill-info)
        (let ((corpse (merge-pathnames
                       (format nil "corpse-~a/" (getf kill-info :w))
                       corpse-root)))
          (fresh-directory corpse)
          ;; cp -r exec corpse-W<N>/ -> corpse-W<N>/exec/
          (copy-tree-directory exec-dir corpse)
          (append-text-line kill-log-path
                            (format nil "CORPSE ~a snapshot=~a"
                                    (getf kill-info :w)
                                    (namestring corpse)))))
      (make-life-result :exit-code exit-code
                        :killed-p killed
                        :kill-info kill-info
                        :pid pid
                        :lines (nreverse lines)))))

;;; ---------------------------------------------------------------------------
;;; Exec-dir setup.

(defvar +provider-domain-initial+
  "(:provider-domain
 (:declaration (:domain-complete t
                :completeness-witness (:evidence-id \"pd-witness-0\"
                                       :boundary \"provider-domain-file\"
                                       :procedure-id \"vertical-classb-reader-0\"
                                       :standing \"complete-enumeration\"
                                       :origin \"observed\")))
 (:entries))
")

(defun setup-exec-dir (exec-dir config-text)
  (fresh-directory exec-dir)
  (write-text-file (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" exec-dir)
                   config-text)
  (ensure-directories-exist (merge-pathnames "fake-world/" exec-dir))
  (write-text-file (merge-pathnames "fake-world/provider-domain.sexp"
                                    exec-dir)
                   +provider-domain-initial+)
  (ensure-directories-exist (merge-pathnames "evidence/" exec-dir))
  (ensure-directories-exist (merge-pathnames "export/" exec-dir))
  (ensure-directories-exist (merge-pathnames "mirror-sim/" exec-dir)))

;;; ---------------------------------------------------------------------------
;;; Journal inspection (grading side).

(defun store-events (store-dir)
  "(values events store) for the validated prefix at STORE-DIR."
  (let ((store (open-store store-dir)))
    (values (validated-events store) store)))

(defun has-event-p (events event-id)
  (and (find-event events :event-id event-id) t))

(defun corpse-store-dir (corpse-root w)
  ;; cp -r <exec> corpse-W<N>/ lands the exec tree at corpse-W<N>/exec/.
  (merge-pathnames (format nil "corpse-~a/exec/store/" w) corpse-root))

(defun corpse-exec-dir (corpse-root w)
  (merge-pathnames (format nil "corpse-~a/exec/" w) corpse-root))

(defun frontier-group-present-p (events seat)
  (let ((attempt (format nil "a-~a" seat)))
    (and (has-event-p events (format nil "ap0-event:e-~a-prepared" seat))
         (has-event-p events (format nil "ap0-event:e-~a-request-capture"
                                     seat))
         (has-event-p events (format nil "ap0-event:e-~a-exposure" seat))
         (has-event-p events (format nil "cap2-event:e-~a-prepared" attempt))
         (has-event-p events (format nil "cap2-event:e-~a-frontier" attempt))
         (has-event-p events (format nil "ap0-event:e-~a-dispatch" seat))
         (has-event-p events (format nil "ap0-event:e-~a-crossing-binding"
                                     seat)))))

(defun seat-outcome-from-census (events seat)
  "The census record's per-seat outcome plist (strings), from EVENTS."
  (let ((census (find-event events :event-id "vertical-event:e-census")))
    (when census
      (let* ((body (event-body census))
             (seats (record-field body "census" "seats")))
        (loop for index below (lisp-plus-cd0:sequence-datum-length seats)
              for row = (lisp-plus-cd0:sequence-datum-ref seats index)
              when (equal seat (body-string row "census" "seat"))
                return (list :manifestation
                             (body-string row "census" "manifestation")
                             :effect (body-string row "census" "effect")
                             :absence-state
                             (body-string row "census" "absence-state")
                             :refusal (body-string row "census" "refusal")
                             :chunks-preserved
                             (body-integer row "census" "chunks-preserved")
                             :projection-origin
                             (body-string row "census"
                                          "projection-origin")))))))

(defun keyword-string (keyword-or-symbol)
  (and keyword-or-symbol
       (string-downcase (symbol-name keyword-or-symbol))))

(defun octets-prefix-p (prefix octets)
  (and prefix octets
       (<= (length prefix) (length octets))
       (equalp prefix (subseq octets 0 (length prefix)))))

;;; ---------------------------------------------------------------------------
;;; CAMPAIGN MODE — five lives, four deaths, one completion.

(defun run-campaign-mode ()
  (let* ((run-root #p"mneme/vertical0/runs/campaign-1/")
         (exec-dir (merge-pathnames "exec/" run-root))
         (private-dir (merge-pathnames "private/" run-root))
         (kill-log (merge-pathnames "kill-log.txt" private-dir))
         (occurrences (make-hash-table :test #'equal))
         (results '()))
    (hnote "vertical0 harness — campaign mode (all pids/paths in this ~
            transcript are noncanonical diagnostics)")
    (hnote "the child is invoked IDENTICALLY every life: resume from ~
            durable evidence alone; the schedule below is harness ~
            knowledge the child never receives.~%")
    (fresh-directory run-root)
    (ensure-directories-exist private-dir)
    (setup-exec-dir exec-dir (read-text-file +config-path+))
    (loop for life from 1 to 8
          do (hnote "== life ~a ==" life)
             (let ((result (run-life exec-dir
                                     (merge-pathnames
                                      (format nil "trace-life~a.txt" life)
                                      run-root)
                                     kill-log occurrences
                                     :corpse-root run-root)))
               (push result results)
               (cond
                 ((life-result-killed-p result)
                  (hnote "life ~a: killed (~a)~%" life
                         (getf (life-result-kill-info result) :w)))
                 ((eql 0 (life-result-exit-code result))
                  (hnote "life ~a: exit 0 — nothing remains~%" life)
                  (loop-finish))
                 (t
                  (error "life ~a ended without kill and without exit 0 ~
                          (exit ~a)" life
                         (life-result-exit-code result))))))
    (setf results (nreverse results))
    ;; -----------------------------------------------------------------
    (hnote "== grading: the campaign shape ==")
    (hcheck "five lives ran: four SIGKILL deaths then one clean exit 0"
      (lambda ()
        (and (= 5 (length results))
             (every #'life-result-killed-p (subseq results 0 4))
             (not (life-result-killed-p (fifth results)))
             (eql 0 (life-result-exit-code (fifth results))))))
    (hcheck "the four kills landed exactly on the oracle's schedule: ~
             W1@frontier/1, W2@chunk/1, W3@envelope/1, W4@projection/2 — ~
             each at the oracle's expected seat, each after a confirmed ~
             blocked-on-pipe state"
      (lambda ()
        (every (lambda (result row)
                 (let ((info (life-result-kill-info result)))
                   (and info
                        (equal (getf info :w) (getf row :w))
                        (equal (getf info :boundary) (getf row :boundary))
                        (eql (getf info :occurrence) (getf row :occurrence))
                        (equal (getf info :seat) (getf row :expected-seat))
                        (getf info :wchan))))
               (subseq results 0 4)
               (oracle-kill-schedule))))
    (hcheck "one boundary pause was CONTINUEd rather than killed: the ~
             recovery projection (PROJECTION-COMMITTED occurrence 1, ~
             life 4) — the child pauses at every declared occurrence ~
             whether or not a kill is scheduled there"
      (lambda ()
        (and (= 2 (gethash "PROJECTION-COMMITTED" occurrences 0))
             (some (lambda (line)
                     (search "boundary=PROJECTION-COMMITTED" line))
                   (life-result-lines (fourth results))))))
    ;; -----------------------------------------------------------------
    (hnote "~%== grading: the four corpses (exec-dir snapshots at each ~
            death) ==")
    (let ((final-events (store-events (merge-pathnames "store/" exec-dir)))
          (final-octets (read-octet-file
                         (merge-pathnames "store/EVENTS.pj0" exec-dir))))
      (dolist (expectation (oracle-expected-corpses))
        (let* ((w (getf expectation :w))
               (seat (getf expectation :seat))
               (attempt (format nil "a-~a" seat))
               (corpse-events (store-events (corpse-store-dir run-root w)))
               (corpse-octets (read-octet-file
                               (merge-pathnames
                                "EVENTS.pj0" (corpse-store-dir run-root w)))))
          (hcheck (format nil "corpse ~a (~a): the frontier group is ~
                               durable — AP0 prepared/request-capture/~
                               exposure + cap2 prepared/frontier-crossed ~
                               + AP0 dispatch + crossing-evidence-binding"
                          w seat)
            (lambda () (frontier-group-present-p corpse-events seat)))
          (hcheck (format nil "corpse ~a: its journal bytes are a strict ~
                               byte-prefix of the final journal — every ~
                               later life APPENDED; nothing was rewritten"
                          w)
            (lambda () (octets-prefix-p corpse-octets final-octets)))
          (ecase (intern (string-upcase w) :keyword)
            (:w1
             (hcheck "corpse W1: NO acknowledgment (AP0 or cap2), NO ~
                      settlement, NO uncertainty record — from the bytes ~
                      alone the standing is genuinely :crossed-unsettled"
               (lambda ()
                 (and (not (has-event-p corpse-events
                                        (format nil
                                                "ap0-event:e-~a-ack-membrane"
                                                seat)))
                      (not (has-event-p corpse-events
                                        (format nil "cap2-event:e-~a-ack"
                                                attempt)))
                      (not (has-event-p corpse-events
                                        (format nil
                                                "cap2-event:e-~a-settled"
                                                attempt)))
                      (eq :crossed-unsettled
                          (derive-effect-standing
                           (open-store (corpse-store-dir run-root w))
                           attempt)))))
             (hcheck "corpse W1: no effect evidence — the surviving ~
                      world's request ledger holds NO entry under the ~
                      journaled external-request identity (the request ~
                      was lost in flight; the bytes cannot tell)"
               (lambda ()
                 (let ((world (open-world (merge-pathnames
                                           "world/"
                                           (corpse-exec-dir run-root w)))))
                   (zerop (world-ledger-count
                           world
                           (format nil "external-request:cap2:~a"
                                   attempt)))))))
            (:w2
             (hcheck "corpse W2: acknowledgment and chunk-1 custody are ~
                      durable; chunk-2 and the stream terminal envelope ~
                      are NOT — at least one chunk committed, no ~
                      terminal settlement exists"
               (lambda ()
                 (and (has-event-p corpse-events
                                   (format nil "ap0-event:e-~a-ack-membrane"
                                           seat))
                      (has-event-p corpse-events
                                   (format nil "ap0-event:e-~a-chunk-1"
                                           seat))
                      (not (has-event-p corpse-events
                                        (format nil "ap0-event:e-~a-chunk-2"
                                                seat)))
                      (not (has-event-p corpse-events
                                        (format nil "ap0-event:e-~a-envelope"
                                                seat)))))))
            (:w3
             (hcheck "corpse W3: the complete raw envelope is durably in ~
                      custody — journal record + evidence file whose ~
                      sha256 recomputes to the journaled binding; no ~
                      projection exists"
               (lambda ()
                 (let* ((custody (find-event
                                  corpse-events
                                  :event-id
                                  (format nil
                                          "vertical-event:e-~a-envelope-custody"
                                          seat)))
                        (body (and custody (event-body custody)))
                        (relative (and body
                                       (body-string body "vertical"
                                                    "evidence-file")))
                        (octets (and relative
                                     (read-octet-file
                                      (merge-pathnames
                                       relative
                                       (corpse-exec-dir run-root w))))))
                   (and custody octets
                        (string= (sha256-hex octets)
                                 (body-string body "vertical"
                                              "raw-payload-sha256"))
                        (not (has-event-p corpse-events
                                          (format nil
                                                  "ap0-event:e-~a-projection"
                                                  seat)))
                        (not (has-event-p corpse-events
                                          (format nil
                                                  "vertical-event:e-~a-projection"
                                                  seat))))))))
            (:w4
             (hcheck "corpse W4: the projection record is durable; no ~
                      consumption, no interpretation exists yet"
               (lambda ()
                 (and (has-event-p corpse-events
                                   (format nil "ap0-event:e-~a-projection"
                                           seat))
                      (not (has-event-p corpse-events
                                        (format nil
                                                "vertical-event:e-~a-consumption"
                                                seat)))
                      (not (has-event-p corpse-events
                                        (format nil
                                                "vertical-event:e-~a-interpretation"
                                                seat))))))
             (hcheck "across the W4 death the projection receipt is ~
                      byte-identical: the projection event's canonical ~
                      payload in the corpse equals the same event's ~
                      payload in the final journal (consumption ~
                      references; it never rewrites)"
               (lambda ()
                 (let ((corpse-projection
                         (find-event corpse-events
                                     :event-id
                                     (format nil "ap0-event:e-~a-projection"
                                             seat)))
                       (final-projection
                         (find-event final-events
                                     :event-id
                                     (format nil "ap0-event:e-~a-projection"
                                             seat))))
                   (and corpse-projection final-projection
                        (equalp (encode-pjs0 corpse-projection)
                                (encode-pjs0 final-projection))))))))))
      ;; ---------------------------------------------------------------
      (hnote "~%== grading: the recovery folds ==")
      (hcheck "after W1 the torn crossing was STRUCTURED, never resolved: ~
               the §10.8 record is journaled, the CAP2-W1 pre-declaration ~
               scan's refusal is journaled (blind retry refused from ~
               durable bytes alone), and the final standing is ~
               :uncertain-unresolved"
        (lambda ()
          (multiple-value-bind (events store)
              (store-events (merge-pathnames "store/" exec-dir))
            (and (has-event-p events
                              "cap2-event:e-a-seat-torn-crossing-uncertain")
                 (has-event-p events
                              "vertical-event:e-seat-torn-crossing-retry-scan")
                 (eq :uncertain-unresolved
                     (derive-effect-standing store
                                             "a-seat-torn-crossing"))))))
      (hcheck "after W2 the partial stream was CLOSED, never resumed: the ~
               typed refusal record stands (stream-resume-would-duplicate), ~
               exactly 1 chunk preserved, and no chunk-2 was ever ~
               journaled"
        (lambda ()
          (let* ((closure (find-event
                           final-events
                           :event-id
                           "vertical-event:e-seat-half-song-stream-closure"))
                 (body (and closure (event-body closure))))
            (and closure
                 (eql 1 (body-integer body "vertical" "chunks-preserved"))
                 (equal "stream-resume-would-duplicate"
                        (body-string body "vertical" "condition"))
                 (not (has-event-p final-events
                                   "ap0-event:e-seat-half-song-chunk-2"))))))
      (hcheck "after W3 the projection was DERIVED from captured bytes by ~
               vertical-recovery-projection-0 (origin derived), and the ~
               provider was not recalled: exactly one dispatch record ~
               exists for the seat in the whole campaign"
        (lambda ()
          (let* ((projection (find-event
                              final-events
                              :event-id
                              "vertical-event:e-seat-sealed-letter-projection"))
                 (body (and projection (event-body projection))))
            (and projection
                 (equal "vertical-recovery-projection-0"
                        (body-string body "vertical" "procedure-id"))
                 (equal "derived"
                        (body-string body "vertical" "output-origin"))
                 (= 1 (count "ap0-event:e-seat-sealed-letter-dispatch"
                             final-events
                             :key #'event-id-string :test #'equal))))))
      (hcheck "after W4 the EXISTING projection was consumed: the ~
               consumption record references the projection receipt ~
               identity, and no second envelope or projection was created ~
               for the seat"
        (lambda ()
          (let* ((consumption (find-event
                               final-events
                               :event-id
                               "vertical-event:e-seat-cold-supper-consumption"))
                 (body (and consumption (event-body consumption))))
            (and consumption
                 (body-string body "vertical" "projection-receipt-id")
                 (= 1 (count "ap0-event:e-seat-cold-supper-envelope"
                             final-events
                             :key #'event-id-string :test #'equal))
                 (= 1 (count "ap0-event:e-seat-cold-supper-projection"
                             final-events
                             :key #'event-id-string :test #'equal))))))
      ;; ---------------------------------------------------------------
      (hnote "~%== grading: the final outcome map (census vs oracle) ==")
      (dolist (expectation (oracle-expected-outcomes))
        (let* ((seat (getf expectation :seat))
               (actual (seat-outcome-from-census final-events seat)))
          (hcheck (format nil "outcome ~a: manifestation ~a~@[, effect ~a~]~
                               ~@[, absence-state ~a~]~@[, refusal ~a~]~
                               ~@[, projection-origin ~a~]"
                          seat
                          (keyword-string (getf expectation :manifestation))
                          (keyword-string (getf expectation :effect))
                          (keyword-string (getf expectation :absence-state))
                          (keyword-string (getf expectation :refusal))
                          (keyword-string (getf expectation
                                                :projection-origin)))
            (lambda ()
              (and actual
                   (equal (keyword-string (getf expectation :manifestation))
                          (getf actual :manifestation))
                   (or (null (getf expectation :effect))
                       (equal (keyword-string (getf expectation :effect))
                              (getf actual :effect)))
                   (or (null (getf expectation :absence-state))
                       (equal (keyword-string (getf expectation
                                                    :absence-state))
                              (getf actual :absence-state)))
                   (or (null (getf expectation :refusal))
                       (equal (keyword-string (getf expectation :refusal))
                              (getf actual :refusal)))
                   (or (null (getf expectation :projection-origin))
                       (equal (keyword-string (getf expectation
                                                    :projection-origin))
                              (getf actual :projection-origin))))))))
      (hcheck "the finalization records are durable: interpretation ~
               receipts for every projected seat, the census, the ~
               synthetic secret exposure, the publication receipt, and ~
               campaign-complete"
        (lambda ()
          (and (has-event-p final-events
                            "vertical-event:e-seat-first-fruit-interpretation")
               (has-event-p final-events
                            "vertical-event:e-seat-sealed-letter-interpretation")
               (has-event-p final-events "vertical-event:e-census")
               (has-event-p final-events "vertical-event:e-secret-exposure")
               (has-event-p final-events
                            "vertical-event:e-publication-receipt")
               (has-event-p final-events
                            "vertical-event:e-campaign-complete"))))
      (hcheck "the publication stayed simulated: the mirror-sim copy's ~
               bytes equal the staged export's bytes, and both equal the ~
               journaled census record's canonical encoding ~
               (test-channel-only; the real mirror was never contacted)"
        (lambda ()
          (let ((staged (read-octet-file
                         (merge-pathnames "export/campaign-export.sexp"
                                          exec-dir)))
                (mirrored (read-octet-file
                           (merge-pathnames "mirror-sim/campaign-export.sexp"
                                            exec-dir)))
                (census (find-event final-events
                                    :event-id "vertical-event:e-census")))
            (and staged mirrored census
                 (equalp staged mirrored)
                 (equalp staged (encode-pjs0 (event-body census))))))))
    (values)))

;;; ---------------------------------------------------------------------------
;;; CONTROL MODE — the W1 indistinguishability pair (contract §6).

(defun materialized-control-config ()
  "The control config, materialized deterministically from the sealed
template: the bank IS the control seat; same generic entry; zero mode
flags.  Identical bytes in both arms."
  "(:vertical-program-config
 (:config-version \"vertical-config-0-control\")
 (:declared-versions
  (:adapter \"adapter0-through-erratum-0.1\"
   :cost-procedure \"fake-cost-procedure-1\"
   :recovery-projection \"vertical-recovery-projection-0\"
   :interpretation \"vertical-interpretation-0\"
   :census \"vertical-census-0\"))
 (:adapter
  (:descriptor-identity \"fake-reference-0\"
   :usage-procedure \"fake-usage-procedure-0\"
   :cost-procedure \"fake-cost-procedure-1\"
   :price-schedule \"fake-prices-v0\"))
 (:authority
  (:bootstrap-issuer \"auctor-primus\"
   :subject (\"subject\" \"machina\")
   :action (\"action\" \"loqui\")
   :scope (\"scope\" \"semel\")
   :revoked-seats ()))
 (:budget
  (:ceiling-lexeme \"5/1\"))
 (:bank
  ((:seat \"seat-control\" :route :frontier-only
    :shape nil :estimate-lexeme \"100/1000000\" :cell \"cella-controlata\"
    :control-policy :disposition-then-reconcile
    :control-pauses (\"EFFECT-FRONTIER-CROSSED-UNSETTLED\"
                     \"CONTROL-DISPOSITION-COMMITTED\"))))
 (:policy
  (:seat-order (\"seat-control\")
   :route-pauses
   ((:route :frontier-only
     :pauses (\"EFFECT-FRONTIER-CROSSED-UNSETTLED\")))
   :partial-stream-resumption :refused
   :request-loss-simulated-seats (\"seat-control\")
   :torn-crossing-policy :leave-unresolved
   :stream-chunk-count 2
   :journal-declared-durability \"synced\"
   :journal-nonce \"vertical-de-morte\")))
")

(defun provider-domain-with-entry ()
  "The provider domain AFTER the concurrent provider applied the control
effect (arm A only; played only after both dispositions are banked)."
  "(:provider-domain
 (:declaration (:domain-complete t
                :completeness-witness (:evidence-id \"pd-witness-0\"
                                       :boundary \"provider-domain-file\"
                                       :procedure-id \"vertical-classb-reader-0\"
                                       :standing \"complete-enumeration\"
                                       :origin \"observed\")))
 (:entries (:request-id \"external-request:cap2:a-seat-control\"
            :provider-request-id \"pd-req-seat-control-1\"
            :cell \"cella:cella-controlata\"
            :value \"V-seat-control\")))
")

(defun control-kill-decider (boundary occurrence)
  "Kill at the FIRST frontier boundary; CONTINUE everything else.
The W label for the control corpse is W1 (the same window)."
  (when (and (equal boundary "EFFECT-FRONTIER-CROSSED-UNSETTLED")
             (eql occurrence 1))
    (list :w "W1" :boundary boundary :occurrence occurrence
          :expected-seat "seat-control" :life 1)))

(defun drive-life-2-to-disposition (arm-root exec-dir occurrences)
  "Spawn an arm's life 2 and drive it exactly to its
CONTROL-DISPOSITION-COMMITTED pause; LEAVE IT BLOCKED.  Returns the live
process + pid (values process pid)."
  (let* ((process (sb-ext:run-program
                   "strace"
                   (list "-f" "-s" "256" "-o"
                         (namestring (merge-pathnames "trace-life2.txt"
                                                      arm-root))
                         "-e" +strace-set+
                         "--" "sbcl" "--script"
                         "mneme/vertical0/program/campaign.lisp"
                         (namestring exec-dir))
                   :search t :wait nil
                   :input :stream :output :stream :error :output))
         (output (sb-ext:process-output process))
         (pid nil))
    (loop for line = (read-line output nil nil)
          while line
          do (cond
               ((and (>= (length line) 10)
                     (string= "CHILD-PID " (subseq line 0 10)))
                (setf pid (parse-integer (subseq line 10)))
                (hnote "      | ~a (noncanonical)" line))
               ((and (>= (length line) 14)
                     (string= "BOUNDARY-READY" (subseq line 0 14)))
                (multiple-value-bind (seat boundary) (parse-ready-line line)
                  (declare (ignore seat))
                  (incf (gethash boundary occurrences 0))
                  (hnote "      | ~a" line)
                  (when (equal boundary "CONTROL-DISPOSITION-COMMITTED")
                    ;; The disposition is durable; the child stays
                    ;; blocked while the harness banks and compares.
                    (return))
                  (write-line "CONTINUE" (sb-ext:process-input process))
                  (finish-output (sb-ext:process-input process))))
               (t (hnote "      | ~a" line))))
    (let ((proof (wait-until-blocked-on-pipe pid)))
      (unless proof
        (error "control arm life 2 (pid ~a) did not block at the ~
                disposition boundary" pid))
      (hnote "      | arm paused blocked at disposition [pid=~a wchan=~a] ~
              (noncanonical)" pid (first proof)))
    (values process pid)))

(defun finish-control-life-2 (process)
  "CONTINUE the blocked arm and drain it to completion.  Returns its
exit code."
  (write-line "CONTINUE" (sb-ext:process-input process))
  (finish-output (sb-ext:process-input process))
  (loop for line = (read-line (sb-ext:process-output process) nil nil)
        while line
        do (hnote "      | ~a" line))
  (sb-ext:process-wait process)
  (sb-ext:process-exit-code process))

(defun run-control-mode ()
  (let* ((root-a #p"mneme/vertical0/runs/control-a/")
         (root-b #p"mneme/vertical0/runs/control-b/")
         (exec-a (merge-pathnames "exec/" root-a))
         (exec-b (merge-pathnames "exec/" root-b))
         (private-a (merge-pathnames "private/" root-a))
         (private-b (merge-pathnames "private/" root-b))
         (config-text (materialized-control-config)))
    (hnote "vertical0 harness — W1 indistinguishability control pair ~
            (contract §6; pids/paths noncanonical)")
    (hnote "two arms, identical program bytes, identical config bytes, ~
            identical (empty) provider domains; hidden truth differs ~
            ONLY in the oracle until after both dispositions are ~
            banked.~%")
    (dolist (root (list root-a root-b))
      (fresh-directory root))
    (ensure-directories-exist private-a)
    (ensure-directories-exist private-b)
    (setup-exec-dir exec-a config-text)
    (setup-exec-dir exec-b config-text)
    (hcheck "the two arms' materialized configs and initial provider ~
             domains are byte-identical (all program-visible AND all ~
             lawful pre-reconciliation evidence identical)"
      (lambda ()
        (and (equal (read-text-file (merge-pathnames
                                     "VERTICAL-PROGRAM-CONFIG.sexp" exec-a))
                    (read-text-file (merge-pathnames
                                     "VERTICAL-PROGRAM-CONFIG.sexp" exec-b)))
             (equal (read-text-file
                     (merge-pathnames "fake-world/provider-domain.sexp"
                                      exec-a))
                    (read-text-file
                     (merge-pathnames "fake-world/provider-domain.sexp"
                                      exec-b))))))
    ;; -- life 1, both arms: killed at the W1 window. --------------------
    (let ((occurrences-a (make-hash-table :test #'equal))
          (occurrences-b (make-hash-table :test #'equal)))
      (hnote "~%== arm A, life 1 (killed at the frontier window) ==")
      (let ((result (run-life exec-a
                              (merge-pathnames "trace-life1.txt" root-a)
                              (merge-pathnames "kill-log.txt" private-a)
                              occurrences-a
                              :kill-decider #'control-kill-decider
                              :corpse-root root-a)))
        (hcheck "arm A life 1 died by SIGKILL at ~
                 EFFECT-FRONTIER-CROSSED-UNSETTLED occurrence 1, blocked ~
                 state confirmed"
          (lambda () (and (life-result-killed-p result)
                          (getf (life-result-kill-info result) :wchan)))))
      (hnote "~%== arm B, life 1 (killed at the frontier window) ==")
      (let ((result (run-life exec-b
                              (merge-pathnames "trace-life1.txt" root-b)
                              (merge-pathnames "kill-log.txt" private-b)
                              occurrences-b
                              :kill-decider #'control-kill-decider
                              :corpse-root root-b)))
        (hcheck "arm B life 1 died by SIGKILL at ~
                 EFFECT-FRONTIER-CROSSED-UNSETTLED occurrence 1, blocked ~
                 state confirmed"
          (lambda () (and (life-result-killed-p result)
                          (getf (life-result-kill-info result) :wchan)))))
      ;; -- life 2, both arms: drive to the disposition pause; BANK. -----
      (hnote "~%== both arms, life 2: recovery to the banked disposition ~
              (order-enforced: NO provider evidence exists yet) ==")
      (multiple-value-bind (process-a pid-a)
          (drive-life-2-to-disposition root-a exec-a occurrences-a)
        (declare (ignore pid-a))
        (multiple-value-bind (process-b pid-b)
            (drive-life-2-to-disposition root-b exec-b occurrences-b)
          (declare (ignore pid-b))
          (let ((banked-a (read-octet-file
                           (merge-pathnames "store/EVENTS.pj0" exec-a)))
                (banked-b (read-octet-file
                           (merge-pathnames "store/EVENTS.pj0" exec-b))))
            (write-evidence-file (merge-pathnames "banked-EVENTS.pj0"
                                                  private-a)
                                 banked-a)
            (write-evidence-file (merge-pathnames "banked-EVENTS.pj0"
                                                  private-b)
                                 banked-b)
            (hcheck "THE INDISTINGUISHABILITY POINT: both arms' banked ~
                     journals are byte-identical at the committed ~
                     disposition — all program-visible evidence equal ~
                     while hidden truth (oracle-side) differs; a ~
                     difference here would mean the program leaked the ~
                     oracle or treated script determinism as evidence"
              (lambda () (and banked-a banked-b (equalp banked-a banked-b))))
            (hcheck "both dispositions are the STRUCTURED uncertainty: the ~
                     §10.8 record is journaled and the standing is ~
                     :uncertain-unresolved in both banked arms"
              (lambda ()
                (every (lambda (exec)
                         (multiple-value-bind (events store)
                             (store-events (merge-pathnames "store/" exec))
                           (and (has-event-p
                                 events
                                 "cap2-event:e-a-seat-control-uncertain")
                                (eq :uncertain-unresolved
                                    (derive-effect-standing
                                     store "a-seat-control")))))
                       (list exec-a exec-b))))
            ;; -- ONLY NOW: the concurrent provider plays. ---------------
            (hnote "~%== the concurrent provider plays (per the oracle's ~
                    private table): arm A: effect applied to the ~
                    provider domain; arm B: not ==")
            (let ((table (oracle-w1-control)))
              (hcheck "the oracle's private table says arm A ~
                       :effect-applied and arm B :effect-not-applied ~
                       (grader knowledge; the children never see this ~
                       file)"
                (lambda ()
                  (and (eq :effect-applied
                           (getf (find "control-a" table
                                       :key (lambda (row) (getf row :arm))
                                       :test #'equal)
                                 :hidden-truth))
                       (eq :effect-not-applied
                           (getf (find "control-b" table
                                       :key (lambda (row) (getf row :arm))
                                       :test #'equal)
                                 :hidden-truth))))))
            (write-text-file (merge-pathnames
                              "fake-world/provider-domain.sexp" exec-a)
                             (provider-domain-with-entry))
            ;; -- CONTINUE both arms through reconciliation. -------------
            (hnote "~%== arm A, life 2 continues: class-B reconciliation ==")
            (let ((code-a (finish-control-life-2 process-a)))
              (hcheck "arm A completed exit 0"
                (lambda () (eql 0 code-a))))
            (hnote "~%== arm B, life 2 continues: class-B reconciliation ==")
            (let ((code-b (finish-control-life-2 process-b)))
              (hcheck "arm B completed exit 0"
                (lambda () (eql 0 code-b))))
            ;; -- end-state grading. -------------------------------------
            (hnote "~%== grading: each arm reached its TRUE standing ~
                    through lawful class-B evidence ==")
            (let ((events-a (store-events (merge-pathnames "store/" exec-a)))
                  (events-b (store-events (merge-pathnames "store/" exec-b)))
                  (final-a (read-octet-file
                            (merge-pathnames "store/EVENTS.pj0" exec-a)))
                  (final-b (read-octet-file
                            (merge-pathnames "store/EVENTS.pj0" exec-b))))
              (hcheck "arm A: reconciliation result COMPLETED (found in ~
                       the provider domain), settles-no-effect FALSE, ~
                       outcome standing effect-standing-with-evidence — ~
                       the uncertainty is preserved WITH evidence, not ~
                       erased"
                (lambda ()
                  (let* ((reconciliation
                           (find-event
                            events-a
                            :event-id
                            "ap0-event:e-seat-control-reconciliation"))
                         (outcome
                           (find-event
                            events-a
                            :event-id
                            "vertical-event:e-seat-control-control-outcome"))
                         (reconciliation-body (and reconciliation
                                                   (event-body
                                                    reconciliation))))
                    (and reconciliation outcome
                         (equal "completed"
                                (body-string reconciliation-body "ap0"
                                             "result"))
                         (equal "effect-standing-with-evidence"
                                (body-string (event-body outcome)
                                             "vertical" "standing"))))))
              (hcheck "arm B: reconciliation result NOT-FOUND under the ~
                       full AP-REC-6 conjunction (exact identity + ~
                       complete authoritative domain + distinct observed ~
                       completeness witness): settles-no-effect TRUE, ~
                       outcome standing settled-no-effect"
                (lambda ()
                  (let* ((reconciliation
                           (find-event
                            events-b
                            :event-id
                            "ap0-event:e-seat-control-reconciliation"))
                         (outcome
                           (find-event
                            events-b
                            :event-id
                            "vertical-event:e-seat-control-control-outcome"))
                         (reconciliation-body (and reconciliation
                                                   (event-body
                                                    reconciliation))))
                    (and reconciliation outcome
                         (equal "not-found"
                                (body-string reconciliation-body "ap0"
                                             "result"))
                         (let ((flag (record-field reconciliation-body
                                                   "ap0"
                                                   "settles-no-effect")))
                           (and flag
                                (lisp-plus-cd0:boolean-datum-value flag)))
                         (equal "settled-no-effect"
                                (body-string (event-body outcome)
                                             "vertical" "standing"))))))
              (hcheck "in BOTH arms the banked disposition bytes are a ~
                       strict byte-prefix of the final journal: the ~
                       original uncertainty records remain unchanged; ~
                       reconciliation appended, it never rewrote"
                (lambda ()
                  (and (octets-prefix-p (read-octet-file
                                         (merge-pathnames
                                          "banked-EVENTS.pj0" private-a))
                                        final-a)
                       (octets-prefix-p (read-octet-file
                                         (merge-pathnames
                                          "banked-EVENTS.pj0" private-b))
                                        final-b))))
              (hcheck "the two arms DIVERGE only after the provider ~
                       played: their final journals differ (each arm ~
                       reached its own true standing)"
                (lambda ()
                  (not (equalp final-a final-b)))))))))
    (values)))

;;; ---------------------------------------------------------------------------
;;; Entry.

(handler-case
    (let ((mode (second sb-ext:*posix-argv*)))
      (read-oracle)
      (cond
        ((equal mode "campaign") (run-campaign-mode))
        ((equal mode "control") (run-control-mode))
        (t (error "usage: harness.lisp campaign|control")))
      (format t "~%vertical0 harness (~a): ~a check~:p, ~a failure~:p~%"
              mode *checks* *failures*)
      (if (zerop *failures*)
          (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
          (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1))))
  (error (condition)
    (format t "~%HARNESS-ERROR: ~a~%" condition)
    (format t "RESULT: FAIL~%")
    (finish-output)
    (sb-ext:exit :code 1)))

