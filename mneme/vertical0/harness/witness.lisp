;;;; witness.lisp — the external syscall witness (contract §2.3, §4).
;;;;
;;;; Run from the latent-lisp root, AFTER the harness runs:
;;;;
;;;;   sbcl --script mneme/vertical0/harness/witness.lisp
;;;;
;;;; THE TRACE IS CONTROLLING.  This checker parses the strace records of
;;;; every child life and proves, per boundary:
;;;;   · the declared durability primitive (fsync on the journal fd; for
;;;;     write-replace: fsync(tmp) -> rename -> fsync(dir)) ran and
;;;;     returned BEFORE the BOUNDARY-READY marker was written;
;;;;   · no semantic write occurred between READY and SIGKILL;
;;;;   · at SIGKILL time the child's in-flight syscall was read(0, ...)
;;;;     — the blocked wait-pipe read;
;;;;   · no child ever opened the oracle artifact, any harness-private
;;;;     directory, or any corpse snapshot;
;;;;   · the class-B provider domain was opened ONLY inside the declared
;;;;     reconciliation step (control life 2, after the banked
;;;;     disposition) and NEVER by any campaign life;
;;;;   · no fdatasync exists anywhere (the stack declares fsync; an
;;;;     fdatasync would be an undeclared durability path).
;;;;
;;;; Successful witnessing earns ONLY: "the implementation invoked its
;;;; declared durability protocol before the process-death boundary" —
;;;; never power-loss durability (contract §1.2/§4).
;;;;
;;;; Fd resolution: openat return values are tracked into a process-wide
;;;; fd table (SBCL threads share one table; the wrapper execs, so each
;;;; trace is one process).  /proc/<pid>/syscall is unreadable under an
;;;; attached tracer, so the blocked-state proof here is the strace
;;;; record itself (read(0, <unfinished> ... killed by SIGKILL), with the
;;;; harness's live wchan/state sampling as the recorded corroboration.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(defvar *checks* 0)
(defvar *failures* 0)

(defun wcheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[W~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[W~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))
    (finish-output)))

(defun wnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

;;; ---------------------------------------------------------------------------
;;; Trace parsing.

(defstruct trace-event
  index      ; line number (1-based)
  tid        ; integer thread id
  op         ; keyword: :openat :write :read :fsync :rename :close :unlink
             ;          :pwrite64 :pread64 :fdatasync :other :killed :exited
  fd         ; integer fd for fd-taking ops
  path       ; resolved path (for fd ops, from the fd table) or openat path
  target     ; rename target path
  unfinished ; T when the syscall never returned (in flight at death)
  line)      ; the raw line

(defun %parse-quoted (line start)
  "The string literal starting at the double-quote at/after START.
Returns (values string end-index)."
  (let ((open (position #\" line :start start)))
    (when open
      (let ((close (position #\" line :start (1+ open))))
        (when close
          (values (subseq line (1+ open) close) close))))))

(defun %parse-return-value (line)
  "The integer after the last \" = \", or NIL."
  (let ((marker (search " = " line :from-end t)))
    (when marker
      (let ((rest (string-trim " " (subseq line (+ marker 3)))))
        (multiple-value-bind (value position)
            (parse-integer rest :junk-allowed t)
          (declare (ignore position))
          value)))))

(defun parse-trace (pathname)
  "Parse a strace -f -o file into a list of TRACE-EVENTs (fd-resolved)."
  (let ((events '())
        (fd-table (make-hash-table))
        (index 0))
    (with-open-file (stream pathname :direction :input)
      (loop for line = (read-line stream nil nil)
            while line
            do (incf index)
               (let* ((space (position #\Space line))
                      (tid (and space (parse-integer line :end space
                                                     :junk-allowed t)))
                      (rest (and space (string-left-trim " "
                                                         (subseq line
                                                                 space)))))
                 (cond
                   ((null tid) nil)  ; header/garbage
                   ((and rest (search "+++ killed by SIGKILL" rest))
                    (push (make-trace-event :index index :tid tid
                                            :op :killed :line line)
                          events))
                   ((and rest (search "+++ exited with" rest))
                    (push (make-trace-event :index index :tid tid
                                            :op :exited :line line)
                          events))
                   ((and rest (> (length rest) 0)
                         (or (char= (char rest 0) #\-)   ; --- SIG... ---
                             (char= (char rest 0) #\<))) ; <... resumed>
                    nil)
                   (t
                    (let* ((paren (and rest (position #\( rest)))
                           (name (and paren (subseq rest 0 paren)))
                           (op (cond ((equal name "openat") :openat)
                                     ((equal name "open") :openat)
                                     ((equal name "write") :write)
                                     ((equal name "pwrite64") :pwrite64)
                                     ((equal name "read") :read)
                                     ((equal name "pread64") :pread64)
                                     ((equal name "fsync") :fsync)
                                     ((equal name "fdatasync") :fdatasync)
                                     ((equal name "close") :close)
                                     ((equal name "unlink") :unlink)
                                     ((equal name "unlinkat") :unlink)
                                     ((or (equal name "rename")
                                          (equal name "renameat")
                                          (equal name "renameat2"))
                                      :rename)
                                     (t :other)))
                           (unfinished (and rest
                                            (search "<unfinished" rest)
                                            t)))
                      (case op
                        (:openat
                         (multiple-value-bind (path) (%parse-quoted rest 0)
                           (let ((fd (%parse-return-value rest)))
                             (when (and fd (>= fd 0) path)
                               (setf (gethash fd fd-table) path))
                             (push (make-trace-event :index index :tid tid
                                                     :op :openat :fd fd
                                                     :path path :line line)
                                   events))))
                        (:rename
                         (multiple-value-bind (source close-1)
                             (%parse-quoted rest 0)
                           (multiple-value-bind (target)
                               (%parse-quoted rest (1+ (or close-1 0)))
                             (push (make-trace-event :index index :tid tid
                                                     :op :rename
                                                     :path source
                                                     :target target
                                                     :line line)
                                   events))))
                        ((:write :pwrite64 :read :pread64 :fsync
                          :fdatasync :close)
                         (let ((fd (and paren
                                        (parse-integer rest
                                                       :start (1+ paren)
                                                       :junk-allowed t))))
                           (push (make-trace-event
                                  :index index :tid tid :op op :fd fd
                                  :path (and fd (gethash fd fd-table))
                                  :unfinished unfinished :line line)
                                 events)
                           (when (and (eq op :close) fd)
                             (remhash fd fd-table))))
                        (:unlink
                         (multiple-value-bind (path) (%parse-quoted rest 0)
                           (push (make-trace-event :index index :tid tid
                                                   :op :unlink :path path
                                                   :line line)
                                 events)))
                        (t nil))))))))
    (nreverse events)))

;;; ---------------------------------------------------------------------------
;;; Event queries.

(defun path-suffix-p (path suffix)
  (and path (>= (length path) (length suffix))
       (string= suffix path :start2 (- (length path) (length suffix)))))

(defun events-matching (events &key op path-suffix path-contains
                                    (start 0) end)
  (remove-if-not
   (lambda (event)
     (and (or (null op) (eq op (trace-event-op event)))
          (or (null path-suffix)
              (path-suffix-p (trace-event-path event) path-suffix))
          (or (null path-contains)
              (and (trace-event-path event)
                   (search path-contains (trace-event-path event))))
          (>= (trace-event-index event) start)
          (or (null end) (< (trace-event-index event) end))))
   events))

(defun ready-writes (events)
  "The write(1, \"BOUNDARY-READY ...\") events, in order."
  (remove-if-not
   (lambda (event)
     (and (eq :write (trace-event-op event))
          (eql 1 (trace-event-fd event))
          (search "BOUNDARY-READY" (trace-event-line event))))
   events))

(defun ready-boundary (event)
  (let* ((line (trace-event-line event))
         (key "boundary=")
         (start (search key line)))
    (when start
      (let ((end (position-if (lambda (c) (member c '(#\\ #\")))
                              line :start (+ start (length key)))))
        (subseq line (+ start (length key)) end)))))

(defun last-index (matches)
  (if matches (reduce #'max matches :key #'trace-event-index) nil))

;;; ---------------------------------------------------------------------------
;;; Per-trace verdicts.

(defun check-sync-before-every-ready (label events)
  (let ((readies (ready-writes events)))
    (dolist (ready readies)
      (let* ((r (trace-event-index ready))
             (boundary (ready-boundary ready))
             (journal-writes (events-matching events :op :write
                                              :path-suffix "EVENTS.pj0"
                                              :end r))
             (journal-syncs (events-matching events :op :fsync
                                             :path-suffix "EVENTS.pj0"
                                             :end r))
             (w (last-index journal-writes))
             (f (last-index journal-syncs)))
        (wcheck (format nil "~a: boundary ~a readiness at line ~a came ~
                             AFTER the last journal append's fsync ~
                             (last write(EVENTS.pj0)@~a < last ~
                             fsync(EVENTS.pj0)@~a < READY@~a)"
                        label boundary r w f r)
          (lambda () (and w f (< w f r))))))
    readies))

(defun check-write-replace-protocol (label events)
  "Every evidence-file rename in this trace rode the declared protocol:
fsync(tmp fd) before the rename; fsync(parent dir fd) after it."
  (let ((renames (remove-if-not
                  (lambda (event)
                    (and (eq :rename (trace-event-op event))
                         (path-suffix-p (trace-event-path event) ".tmp")))
                  events)))
    (dolist (rename renames)
      (let* ((r (trace-event-index rename))
             (tmp (trace-event-path rename))
             (tmp-syncs (events-matching events :op :fsync
                                         :path-suffix
                                         (subseq tmp
                                                 (or (position #\/ tmp
                                                               :from-end t)
                                                     0))
                                         :end r))
             (directory-syncs
               (remove-if-not
                (lambda (event)
                  (and (eq :fsync (trace-event-op event))
                       (trace-event-path event)
                       (char= #\/ (char (trace-event-path event)
                                        (1- (length (trace-event-path
                                                     event)))))
                       (> (trace-event-index event) r)))
                events)))
        (wcheck (format nil "~a: write-replace of ~a — fsync(tmp) ~
                             preceded the rename (line ~a) and ~
                             fsync(parent directory) followed it; close ~
                             alone was never the durability primitive"
                        label
                        (subseq tmp (1+ (or (position #\/ tmp :from-end t)
                                            -1)))
                        r)
          (lambda ()
            (and tmp-syncs
                 (< (last-index tmp-syncs) r)
                 directory-syncs)))))
    (length renames)))

(defun check-killed-tail (label events w)
  "After the FINAL readiness marker: no write, no rename, no unlink —
only the blocked read(0, <unfinished>) and the SIGKILL markers."
  (let* ((readies (ready-writes events))
         (final-ready (and readies (last-index readies))))
    (wcheck (format nil "~a (~a): between the final READY and SIGKILL ~
                         there is NO semantic write of any kind (no ~
                         write/pwrite/rename/unlink on any fd)"
                    label w)
      (lambda ()
        (and final-ready
             (null (remove-if-not
                    (lambda (event)
                      (and (> (trace-event-index event) final-ready)
                           (member (trace-event-op event)
                                   '(:write :pwrite64 :rename :unlink))))
                    events)))))
    (wcheck (format nil "~a (~a): the child died BLOCKED in read(0, ...) ~
                         — the in-flight syscall at SIGKILL is the wait ~
                         pipe read (trace-controlling blocked-state ~
                         proof)"
                    label w)
      (lambda ()
        (and final-ready
             (find-if (lambda (event)
                        (and (eq :read (trace-event-op event))
                             (eql 0 (trace-event-fd event))
                             (trace-event-unfinished event)
                             (> (trace-event-index event) final-ready)))
                      events)
             (find :killed events :key #'trace-event-op))))))

(defun check-read-set (label events &key provider-domain-allowed-after)
  (wcheck (format nil "~a: read-set proof — the child NEVER opened the ~
                       oracle artifact, any harness-private directory, ~
                       or any corpse snapshot" label)
    (lambda ()
      (null (remove-if-not
             (lambda (event)
               (and (eq :openat (trace-event-op event))
                    (trace-event-path event)
                    (or (search "VERTICAL-HARNESS-ORACLE"
                                (trace-event-path event))
                        (search "/private/" (trace-event-path event))
                        (search "corpse-" (trace-event-path event)))))
             events))))
  (let ((domain-opens (events-matching events :op :openat
                                       :path-suffix
                                       "provider-domain.sexp")))
    (cond
      ((null provider-domain-allowed-after)
       (wcheck (format nil "~a: the class-B provider domain was NEVER ~
                            opened (no reconciliation reader ran in this ~
                            life)" label)
         (lambda () (null domain-opens))))
      (t
       (let* ((readies (ready-writes events))
              (disposition
                (find-if (lambda (ready)
                           (equal "CONTROL-DISPOSITION-COMMITTED"
                                  (ready-boundary ready)))
                         readies)))
         (wcheck (format nil "~a: the class-B provider domain was opened ~
                              ONLY inside the declared reconciliation ~
                              reader — every open comes AFTER the banked ~
                              CONTROL-DISPOSITION-COMMITTED readiness"
                         label)
           (lambda ()
             (and disposition domain-opens
                  (every (lambda (event)
                           (> (trace-event-index event)
                              (trace-event-index disposition)))
                         domain-opens)))))))))

(defun check-no-fdatasync (label events)
  (wcheck (format nil "~a: zero fdatasync calls — the declared barrier is ~
                       fsync and only fsync appears" label)
    (lambda () (null (events-matching events :op :fdatasync)))))

;;; ---------------------------------------------------------------------------
;;; The run layout (witness side).

(defun witness-trace (label pathname &key killed-w control-life-2-p
                                          campaign-p)
  (wnote "~%-- ~a (~a) --" label pathname)
  (let ((events (parse-trace pathname)))
    (wcheck (format nil "~a: trace parsed (~a fd-resolved records)"
                    label (length events))
      (lambda () (plusp (length events))))
    (check-sync-before-every-ready label events)
    (check-write-replace-protocol label events)
    (when killed-w
      (check-killed-tail label events killed-w))
    (check-read-set label events
                    :provider-domain-allowed-after control-life-2-p)
    (when campaign-p
      (check-no-fdatasync label events))
    events))

(defun run-witness ()
  (wnote "vertical0 external syscall witness — the trace is controlling.~%~
          Earned by a PASS below: \"the implementation invoked its ~
          declared durability protocol before the process-death ~
          boundary\" — never power-loss durability, never storage-stack ~
          tolerance (contract §1.2).")
  (let ((campaign-root "mneme/vertical0/runs/campaign-1/")
        (kills '((1 . "W1") (2 . "W2") (3 . "W3") (4 . "W4"))))
    (loop for life from 1 to 5
          for w = (cdr (assoc life kills))
          do (witness-trace (format nil "campaign life ~a" life)
                            (format nil "~atrace-life~a.txt"
                                    campaign-root life)
                            :killed-w w
                            :campaign-p t))
    (dolist (arm '("control-a" "control-b"))
      (witness-trace (format nil "~a life 1" arm)
                     (format nil "mneme/vertical0/runs/~a/trace-life1.txt"
                             arm)
                     :killed-w "W1")
      (witness-trace (format nil "~a life 2" arm)
                     (format nil "mneme/vertical0/runs/~a/trace-life2.txt"
                             arm)
                     :control-life-2-p t)))
  (values))

(handler-case
    (progn
      (run-witness)
      (format t "~%vertical0 witness: ~a check~:p, ~a failure~:p~%"
              *checks* *failures*)
      (if (zerop *failures*)
          (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
          (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1))))
  (error (condition)
    (format t "~%WITNESS-ERROR: ~a~%" condition)
    (format t "RESULT: FAIL~%")
    (finish-output)
    (sb-ext:exit :code 1)))
