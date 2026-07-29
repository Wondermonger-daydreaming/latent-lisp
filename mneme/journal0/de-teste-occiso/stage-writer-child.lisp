;;;; stage-writer-child.lisp — the OCCISUS: the writer that is killed.
;;;;
;;;; A separate operating-system process (launched by run-specimen.lisp via
;;;; sb-ext:run-program).  It is charged with ONE append and dies over it.
;;;;
;;;; argv: <store-directory> <marker-path> <receipt-path> <mode>
;;;;
;;;; MODE "cw3" — the specimen's primary kill.  Append the charged event
;;;; through the public §9 path (canonicalize, lock, frame, append, §10.1
;;;; durability barrier, §9.2 step-9 reopen validation, construct receipt),
;;;; THEN write the readiness marker, THEN wait to be killed.  The governed
;;;; progress point is §1 CW-3: the barrier is satisfied and the append
;;;; receipt has not reached the caller.  The receipt exists only in this
;;;; process's memory and dies with it — the delivery channel is written
;;;; only AFTER the wait loop, which never terminates.
;;;;
;;;; MODE "cw0" — the same charge, the same harness, the kill point moved to
;;;; §1 CW-0: BEFORE the first frame byte.  The marker is written first and
;;;; the append sits behind the wait loop, so it never happens.  This mode
;;;; exists to give the specimen's cell claim teeth: if moving one line
;;;; changes the cell, then "CW-3" in phase 2 is a finding and not a
;;;; constant of the harness.
;;;;
;;;; Neither mode writes anything the SUPERSTES is allowed to read: the
;;;; marker and the receipt channel both live outside the store directory.
;;;;
;;;; — SUPERSTES (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

(let* ((arguments (rest sb-ext:*posix-argv*))
       (store-directory (pathname (first arguments)))
       (marker-path (pathname (second arguments)))
       (receipt-path (pathname (third arguments)))
       (mode (fourth arguments))
       (store (open-store store-directory)))

  (flet ((announce ()
           ;; A bare progress marker: fixed bytes, no ordinal, no digest, no
           ;; event identity.  It tells the supervisor only "the process has
           ;; reached the governed point", never what the journal now holds.
           (so-write-octets marker-path (so-ascii +barrier-sentinel-bytes+)))
         (deliver (receipt)
           ;; The delivery the caller never gets.
           (so-write-octets receipt-path
                            (so-ascii (format nil "ordinal ~a disposition ~a~%"
                                              (append-receipt-ordinal receipt)
                                              (append-receipt-disposition
                                               receipt))))))

    (cond
      ;; CW-3: barrier satisfied, then the governed point, then death.
      ((string= mode "cw3")
       (let ((receipt (append-event store (fatal-event) :origin :delivered)))
         (announce)
         (loop (sleep 1))                     ; killed here
         (deliver receipt)))                  ; unreachable by construction

      ;; CW-0: the governed point comes BEFORE the first frame byte.
      ((string= mode "cw0")
       (announce)
       (loop (sleep 1))                       ; killed here
       (deliver (append-event store (fatal-event) :origin :delivered)))

      (t (format *error-output* "unknown child mode ~a~%" mode)
         (sb-ext:exit :code 2))))

  (sb-ext:exit :code 0))
