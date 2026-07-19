;;;; kw-baseline.lisp — the control group.
;;;; A conventional event-log implementation, written the way a competent
;;;; engineer writes one: JSON-lines, in-memory state, flush-at-end option,
;;;; retry = "just call again". It is NOT a strawman: it is the ordinary
;;;; thing, and its failures are the ordinary failures.
;;;; Usage: sbcl --script kw-baseline.lisp <run-dir> <mode> [killpoint]
;;;;   mode: run | recover
;;;;   killpoint: uncertain | buffered-uncertain | empty

(defvar *kw-repo-root* (pathname (or (sb-ext:posix-getenv "KW_REPO") "/tmp/latent-lisp/")))
(load "/tmp/kw/kw-common.lisp")   ; for the oracle only — no journal machinery
(load "/tmp/kw/kw-oracle.lisp")

(in-package #:kw)

(defun argv () (cdr sb-ext:*posix-argv*))

(defun blog (run-dir alist &key (flush t))
  (with-open-file (s (merge-pathnames "baseline.log" run-dir)
                     :direction :output :if-exists :append
                     :if-does-not-exist :create)
    (format s "~{~A=~A~^,~}~%" (loop for (k . v) in alist append (list k v)))
    (when flush (finish-output s))))

;; @harness-begin
(defun mark-ready (run-dir name)
  (with-open-file (s (merge-pathnames (format nil "READY-~A" name) run-dir)
                     :direction :output :if-exists :supersede
                     :if-does-not-exist :create)
    (format s "ready~%")))
;; @harness-end

(let* ((args (argv))
       (run-dir (first args))
       (mode (second args))
       (killpoint (third args)))
  (cond
    ((string= mode "run")
     (if (string= killpoint "buffered-uncertain")
         ;; LIE 4 SETUP: buffer everything, flush at the end (the fast path).
         (let ((buffer '()))
           (push '(("event" . "process-started")) buffer)
           (push '(("event" . "attempt-begun") ("attempt" . "a1")) buffer)
           (push '(("event" . "dispatched") ("attempt" . "a1")) buffer)
           (oracle-dispatch run-dir "effect:bank-write" "a1")
           (mark-ready run-dir "buffered-uncertain")  ;; @harness
           (sleep 30)          ; killed here: buffer never flushes  ;; @harness
           (dolist (ev (nreverse buffer)) (blog run-dir ev)))
         (progn
           (blog run-dir '(("event" . "process-started")))
           (blog run-dir '(("event" . "attempt-begun") ("attempt" . "a1")))
           (when (string= killpoint "empty")
             ;; LIE 1 SETUP: empty payload records exactly like absence.
             (oracle-dispatch run-dir "empty" "a1")
             (blog run-dir '(("event" . "result") ("attempt" . "a1")
                             ("payload" . ""))))
           (when (string= killpoint "uncertain")
             (oracle-dispatch run-dir "effect:bank-write" "a1")
             (mark-ready run-dir "uncertain")  ;; @harness
             (sleep 30))       ; killed before recording settlement  ;; @harness
           (blog run-dir '(("event" . "completed") ("attempt" . "a1"))))))

    ((string= mode "recover")
     (let ((log-file (merge-pathnames "baseline.log" run-dir)))
       (format t "~&BASELINE RECOVERY:~%")
       (if (probe-file log-file)
           (format t "  log contents:~%~A"
                   (with-open-file (in log-file)
                     (let ((s (make-string (file-length in))))
                       (read-sequence s in) s)))
           (format t "  log contents: <none>~%"))
       ;; The conventional moves, each one a lie:
       (format t "  state: OK (verified)~%")   ; LIE 3: laundering
       (format t "  empty-result vs no-result: indistinguishable (both null)~%"
             )                                  ; LIE 1: collapse
       (when (string= killpoint "uncertain")
         ;; LIE 2: no completion found, so just call again.
         (format t "  no completion record: retrying effect...~%")
         (oracle-dispatch run-dir "effect:bank-write" "a1")
         (format t "  retry dispatched.~%"))))
    (t (format t "unknown mode~%")))
  (sb-ext:exit :code 0))
