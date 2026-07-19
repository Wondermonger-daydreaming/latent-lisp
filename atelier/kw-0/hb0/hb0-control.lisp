;;;; hb0-control.lisp — HB-0 conventional control.
;;;; Author: Fable (Claude Fable 5), 2026-07-19. Provenance: HB0-PROVENANCE.md.
;;;; A conventional append-only event log, the best I can honestly write:
;;;; one READABLE PLIST per line in witness.journal (the Lisp engineer's
;;;; JSON-lines); fsync before any durability claim; recovery = re-read the
;;;; file, discard a torn final line, refuse retry while an outcome is
;;;; unrecorded. No frame chaining, no capability discipline, no outcome
;;;; algebra, no per-axis determinacy vocabulary.
;;;; Runner CLI (harness-compatible): hb0-control.lisp <run-dir> <scenario> [killpoint]
;;;;   scenarios: effect | stream | nonexec
;;;; Recovery CLI: hb0-control.lisp <run-dir> recover|blind-retry|resolve|supersede|retry-ne
(require :sb-posix)
(require :sb-md5)
(defpackage #:kw (:use #:cl))
(in-package #:kw)
(defun md5-octets (octets) (sb-md5:md5sum-sequence octets))
(defun digest-hex (octets)
  (string-upcase (format nil "~{~2,'0x~}" (coerce octets 'list))))
(load (merge-pathnames "kw-oracle.lisp" (or *load-truename* #p"./")))

(defvar *dir*)
(defun log-path () (merge-pathnames "witness.journal" *dir*))

(defun emit (plist &key (sync t) partial)
  "Append one event line; :sync t => fsync before returning.
   PARTIAL writes a torn half-line with no newline (death instrumentation)."
  (with-open-file (s (log-path) :direction :output
                     :if-exists :append :if-does-not-exist :create)
    (let ((line (prin1-to-string plist)))
      (if partial
          (write-string (subseq line 0 (floor (length line) 2)) s) ; @harness torn-frame injection
          (write-line line s))
      (finish-output s)
      (when sync (sb-posix:fsync (sb-sys:fd-stream-fd s))))))

;; @harness-begin readiness marker + death wait (instrumentation only)
(defun window (name)
  (with-open-file (s (merge-pathnames (format nil "READY-~A" name) *dir*)
                     :direction :output :if-exists :supersede)
    (write-line "ready" s))
  (sleep 30))
;; @harness-end

(defun run (scenario killpoint &optional (op "bank-write"))
  (emit '(:ev :start :proc "p1"))
  (emit '(:ev :seat :seat "alpha"))
  (when (equal killpoint "cw0") (window "cw0")) ; @harness
  (cond
    ((equal scenario "effect")
     (if (equal killpoint "cw1")
         (progn (emit (list :ev :attempt :id "a1" :op op) :partial t) ; @harness
                (window "cw1"))                                       ; @harness
         (emit (list :ev :attempt :id "a1" :op op)))
     (emit '(:ev :dispatch :id "a1"))
     (oracle-dispatch *dir* (format nil "effect:~A" op) "a1")
     (when (equal killpoint "uncertain") (window "uncertain")) ; @harness
     (emit '(:ev :result :id "a1" :status :executed :payload :absent) :sync nil)
     (when (equal killpoint "cw2cw3") (window "cw2cw3")) ; @harness
     (emit '(:ev :receipt :id "a1")))
    ((equal scenario "stream")
     (emit (list :ev :attempt :id "a1" :op "stream"))
     (emit '(:ev :dispatch :id "a1"))
     (oracle-dispatch *dir* "slow:3" "a1")
     (emit '(:ev :chunk :id "a1" :n 1 :data "chunk-1-payload"))
     (if (equal killpoint "midstream")
         (progn (emit '(:ev :chunk :id "a1" :n 2 :data "chunk-2-payload") :partial t) ; @harness
                (window "midstream"))                                                 ; @harness
         (progn (emit '(:ev :chunk :id "a1" :n 2 :data "chunk-2-payload"))
                (emit '(:ev :chunk :id "a1" :n 3 :data "chunk-3-payload"))
                (emit '(:ev :receipt :id "a1")))))
    ((equal scenario "nonexec")
     (emit (list :ev :attempt :id "a1" :op op))
     (emit '(:ev :dispatch :id "a1"))
     (oracle-dispatch *dir* (format nil "effect-ne:~A" op) "a1")
     (when (equal killpoint "nonexec") (window "nonexec")) ; @harness
     (emit '(:ev :result :id "a1" :status :not-executed :payload :absent) :sync nil)
     (emit '(:ev :receipt :id "a1")))))

(defun read-events ()
  "Return (values events torn-p). Valid prefix only: a final line without a
   newline, or any unreadable line, ends the prefix and is discarded."
  (with-open-file (s (log-path) :if-does-not-exist nil)
    (if (null s) (values nil nil)
        (let* ((buf (make-string (file-length s)))
               (text (subseq buf 0 (read-sequence buf s)))
               (nl-terminated (and (plusp (length text))
                                   (char= (char text (1- (length text))) #\Newline)))
               (events '()) (torn nil) (start 0))
          (loop for pos = (position #\Newline text :start start)
                while pos do
                  (let ((line (subseq text start pos)))
                    (handler-case
                        (let ((*read-eval* nil))
                          (push (read-from-string line) events))
                      (error () (setf torn t) (return))))
                  (setf start (1+ pos)))
          (when (and (not nl-terminated) (< start (length text)))
            (setf torn t))
          (values (nreverse events) torn)))))

(defun fold (events)
  "Derive recovery state: plist of lists/counters. Purely from the log."
  (let (attempts dispatched settled evidenced receipts (chunks 0) supersedes)
    (dolist (e events)
      (case (getf e :ev)
        (:attempt (push (getf e :id) attempts)
                  (when (getf e :retry-of) (push (list (getf e :id) :retry-of (getf e :retry-of)) supersedes)))
        (:dispatch (push (getf e :id) dispatched))
        (:result (push (cons (getf e :id) (getf e :status)) settled))
        (:evidence (push (cons (getf e :id) (getf e :settlement)) evidenced))
        (:reconcile (push (cons (getf e :id) (getf e :settlement)) settled))
        (:receipt (push (getf e :id) receipts))
        (:chunk (incf chunks))
        (:supersede (push (list (getf e :new) :over (getf e :over)) supersedes))))
    (let* ((resolved (remove-duplicates (append (mapcar #'car settled)
                                                (mapcar #'car evidenced)) :test #'equal))
           (superseded (mapcar (lambda (x) (third x)) supersedes))
           (uncertain (remove-if (lambda (a) (or (member a resolved :test #'equal)
                                                 (member a superseded :test #'equal)))
                                 dispatched)))
      (list :attempts (reverse attempts) :uncertain uncertain
            :settled (sort (copy-list resolved) #'string<)
            :receipts (length receipts) :chunks chunks
            :superseded superseded))))

(defun state-digest (state)
  "Canonical digest, spec shared with the independent second reader:
   attempts=..;uncertain=..;settled=..;receipts=N;chunks=N; lists sorted,comma-joined."
  (digest-hex (md5-octets (map '(vector (unsigned-byte 8)) #'char-code
    (format nil "attempts=~{~A~^,~};uncertain=~{~A~^,~};settled=~{~A~^,~};receipts=~A;chunks=~A;"
            (sort (copy-list (getf state :attempts)) #'string<)
            (sort (copy-list (getf state :uncertain)) #'string<)
            (getf state :settled) (getf state :receipts) (getf state :chunks))))))

(defun classify (events torn state)
  (cond ((null events) "empty or absent log")
        ((null (remove-if-not (lambda (e) (eq (getf e :ev) :attempt)) events))
         (format nil "no attempt recorded (~D valid events kept~@[; torn tail discarded~])"
                 (length events) torn))
        (torn (format nil "torn tail discarded (~D valid events kept)" (length events)))
        ((getf state :uncertain)
         (format nil "attempt ~{~A~^,~} dispatched, outcome unrecorded — UNCERTAIN"
                 (getf state :uncertain)))
        ((and (find :result events :key (lambda (e) (getf e :ev)))
              (zerop (getf state :receipts)))
         "result recorded; durable receipt absent (durability not claimable)")
        (t "complete")))

(defun report (label)
  (multiple-value-bind (events torn) (read-events)
    (let ((state (fold events)))
      (format t "~A:~%  classification: ~A~%  origin: reconstructed~%  state: ~S~%  state-digest: ~A~%"
              label (classify events torn state) state (state-digest state))
      ;; verification pass: re-derive; origin is a constant of this reader — it can
      ;; only ever say reconstructed, because reading a log is reconstruction.
      (multiple-value-bind (e2 tt2) (read-events)
        (declare (ignore tt2))
        (format t "  verify: refold-digest=~A origin-after-verify: reconstructed~%"
                (state-digest (fold e2))))
      state)))

(defun read-receipt (id)
  (with-open-file (s (merge-pathnames (format nil "receipt-~A.txt" id) *dir*)
                     :if-does-not-exist nil)
    (when s (let ((lines '()))
              (loop for l = (read-line s nil) while l do (push l lines))
              (let ((sl (find-if (lambda (l) (search "settlement:" l)) lines)))
                (when sl (string-trim " " (subseq sl (1+ (position #\: sl))))))))))

(defun main ()
  (let* ((args (cdr sb-ext:*posix-argv*))
         (mode (second args)))
    (setf *dir* (pathname (first args)))
    (cond
      ((member mode '("effect" "stream" "nonexec") :test #'equal)
       (run mode (third args)))
      ((equal mode "recover") (report "RECOVERY"))
      ((equal mode "blind-retry")
       (let ((state (report "RECOVERY")))
         (if (getf state :uncertain)
             (format t "REFUSAL unsafe-retry: attempt(s) ~{~A~^,~} dispatched with no recorded ~
                        outcome; retrying could execute the effect twice. Evidence: the log's ~
                        valid prefix.~%" (getf state :uncertain))
             (format t "RETRY-LAWFUL: no unresolved dispatch in the log.~%"))))
      ((equal mode "resolve")
       (report "RECOVERY-BEFORE")
       (let ((settlement (read-receipt "a1")))
         (emit (list :ev :evidence :id "a1" :kind :provider-receipt :settlement settlement))
         (emit (list :ev :reconcile :id "a1" :settlement settlement))
         (format t "RECONCILED: provider receipt appended as evidence (settlement: ~A). ~
                    Reconciliation resolves; it does NOT license replay.~%" settlement)
         (report "RECOVERY-AFTER")))
      ((equal mode "retry-ne")
       (report "RECOVERY-BEFORE")
       (let ((settlement (read-receipt "a1")))
         (assert (equal settlement "not-executed") () "retry-ne requires a not-executed receipt")
         (emit (list :ev :evidence :id "a1" :kind :provider-receipt :settlement settlement))
         (emit (list :ev :attempt :id "a2" :op "bank-write" :retry-of "a1"))
         (emit '(:ev :dispatch :id "a2"))
         (oracle-dispatch *dir* "effect:bank-write" "a2")
         (emit '(:ev :result :id "a2" :status :executed :payload :absent) :sync nil)
         (emit '(:ev :receipt :id "a2"))
         (format t "RETRY: receipt attests not-executed; a2 proceeds as retry-of a1 ~
                    (not supersession — settlement was known). a1's events remain in the log.~%")
         (report "RECOVERY-AFTER")))
      ((equal mode "supersede")
       (report "RECOVERY-BEFORE")
       (emit '(:ev :supersede :new "a2" :over "a1" :predecessor-unresolved t))
       (emit (list :ev :attempt :id "a2" :op "bank-write" :supersedes "a1"))
       (emit '(:ev :dispatch :id "a2"))
       (oracle-dispatch *dir* "effect:bank-write" "a2")
       (emit '(:ev :result :id "a2" :status :executed :payload :absent) :sync nil)
       (emit '(:ev :receipt :id "a2"))
       (format t "SUPERSEDED: a2 is a fresh attempt with fresh exposure over unresolved a1. ~
                  predecessor-still-unresolved: T — no event asserts a1's settlement.~%")
       (report "RECOVERY-AFTER")))))

(main)
