;;;; kw-runner.lisp — the process that dies.
;;;; Usage: sbcl --script kw-runner.lisp <run-dir> <scenario> [killpoint]
;;;; Scenarios: clean | effect
;;;; Killpoints (the harness owns death; the runner only marks readiness):
;;;;   cw0        — die after seat-reserved fsync, before attempt-begun
;;;;   cw1        — die mid-frame inside attempt-begun (torn tail)
;;;;   uncertain  — die after frontier-crossed fsync + provider dispatch,
;;;;                before ANY settlement frame (effect settlement unknown)
;;;;   cw2cw3     — die after settlement frame flushed but BEFORE fsync and
;;;;                before the completion receipt frame
;;;;   midstream  — die inside the second manifestation chunk frame
;;;; The READY-<killpoint> marker file is harness instrumentation (a control
;;;; channel), NOT journal content. Recorded as such in ASSUMPTIONS.md.

(defvar *kw-repo-root* (pathname (or (sb-ext:posix-getenv "KW_REPO") "/tmp/latent-lisp/")))
(load "/tmp/kw/kw-common.lisp")
(load "/tmp/kw/kw-oracle.lisp")

(in-package #:kw)

(defun argv () (cdr sb-ext:*posix-argv*))

;; @harness-begin
(defun mark-ready (run-dir name)
  (with-open-file (s (merge-pathnames (format nil "READY-~A" name) run-dir)
                     :direction :output :if-exists :supersede
                     :if-does-not-exist :create)
    (format s "~A~%" (get-universal-time))))

(defun die-wait () (sleep 30))   ; the harness delivers SIGKILL here
;; @harness-end

(let* ((args (argv))
       (run-dir (first args))
       (scenario (second args))
       (killpoint (third args))
       (journal-path (merge-pathnames "witness.journal" run-dir)))
  (format t "runner: scenario=~A killpoint=~A~%" scenario killpoint)
  (finish-output)
  (let ((j (open-journal journal-path)))
    ;; --- pre-frontier: all durable before any effect is possible ----------
    (append-event j `(("event-type" . "process-created")
                      ("process-id" . "kw-process-1")
                      ("origin" . "observed")))
    (append-event j `(("event-type" . "seat-reserved")
                      ("seat-id" . "seat-alpha")
                      ("operation" . ,scenario)))

  -begin
(when (string= killpoint "cw0")
      (mark-ready run-dir "cw0") (die-wait))
  -end

    ;; --- attempt begins ---------------------------------------------------
    ;; @harness-begin
    (if (string= killpoint "cw1")
        (progn
          ;; torn tail: write most of the attempt-begun frame, then die
          (append-event j `(("event-type" . "attempt-begun")
                            ("attempt-id" . "a1")
                            ("seat-id" . "seat-alpha")
                            ("pad" . "0123456789abcdef0123456789abcdef"))
                        :sync nil :truncate-at 24)
          (finish-output (journal-stream j))
          (mark-ready run-dir "cw1") (die-wait))
    ;; @harness-end
        (append-event j `(("event-type" . "attempt-begun")
                          ("attempt-id" . "a1")
                          ("seat-id" . "seat-alpha"))))

    (append-event j `(("event-type" . "frontier-crossed")
                      ("attempt-id" . "a1")
                      ("budget" . "frozen")))

    ;; --- dispatch: the provider's world changes here ----------------------
    (cond
      ((string= scenario "effect")
       (oracle-dispatch run-dir "effect:bank-write" "a1")
    ;; @harness-begin
       (when (string= killpoint "uncertain")
         ;; THE MONEY WINDOW: effect may be executed in the provider's world;
         ;; this process died before recording any settlement.
         (mark-ready run-dir "uncertain") (die-wait))
    ;; @harness-end
    ;; @harness-begin
       (if (string= killpoint "cw2cw3")
           (progn
             ;; settlement frame written to the OS but NOT fsynced, and no
             ;; completion receipt follows. SIGKILL preserves page cache on
             ;; this host — so the cold reader will see a complete frame
             ;; whose receipt is absent. It cannot learn WHICH barrier died.
             (append-event j `(("event-type" . "effect-settled")
                               ("attempt-id" . "a1")
                               ("settlement" . "executed"))
                           :sync nil)
             (finish-output (journal-stream j))
             (mark-ready run-dir "cw2cw3") (die-wait))
    ;; @harness-end
           (progn
             (append-event j `(("event-type" . "effect-settled")
                               ("attempt-id" . "a1")
                               ("settlement" . "executed")))
             (append-event j `(("event-type" . "attempt-completed")
                               ("attempt-id" . "a1")
                               ("outcome" . "completed"))))))
      ((string= scenario "nonexec")
       ;; F3a-nonexecution (owner's D1): the provider DEFINITIVELY does not
       ;; execute; this process dies before recording that answer. The
       ;; journal is left uncertain; the provider's world holds the evidence.
       (oracle-dispatch run-dir "effect-ne:bank-write" "a1")
    ;; @harness-begin
       (when (string= killpoint "nonexec")
         (mark-ready run-dir "nonexec") (die-wait))
    ;; @harness-end
       ;; (unreached under the kill window: settlement recording would follow)
       (append-event j `(("event-type" . "effect-settled")
                         ("attempt-id" . "a1")
                         ("settlement" . "not-executed")))
       (append-event j `(("event-type" . "attempt-completed")
                         ("attempt-id" . "a1")
                         ("outcome" . "completed"))))
      ((string= scenario "stream")
       (append-event j `(("event-type" . "manifestation-recorded")
                         ("attempt-id" . "a1")
                         ("chunk" . "1")
                         ("status" . "present")))
    ;; @harness-begin
       (when (string= killpoint "midstream")
         (sleep 1)
         ;; torn tail inside chunk 2's frame
         (append-event j `(("event-type" . "manifestation-recorded")
                           ("attempt-id" . "a1")
                           ("chunk" . "2")
                           ("status" . "present")
                           ("pad" . "fedcba9876543210fedcba9876543210"))
                       :sync nil :truncate-at 30)
         (finish-output (journal-stream j))
         (mark-ready run-dir "midstream") (die-wait))
    ;; @harness-end
       (append-event j `(("event-type" . "manifestation-recorded")
                         ("attempt-id" . "a1")
                         ("chunk" . "2")
                         ("status" . "present")))
       (append-event j `(("event-type" . "attempt-completed")
                         ("attempt-id" . "a1")
                         ("outcome" . "completed")))))
    (close-journal j)
    (format t "runner: completed lawfully~%")))
(sb-ext:exit :code 0)
