;;;; adapter0-scripts.lisp — the deterministic fake-adapter script gate.
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-scripts.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; §29's script obligation, executed literally: every frozen script is
;;;; run TWICE; the computed (fold-derived) terminal must equal the
;;;; script's declared terminal, and the two runs' canonical record-trail
;;;; digests must be byte-identical (AP-FAKE-1/AP-FAKE-2).  The digests
;;;; are PRINTED so the transcript itself carries the replay evidence.
;;;;
;;;; DETERMINISM: everything printed derives from frozen fixtures and the
;;;; deterministic machine — the transcript is byte-stable across runs.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-adapter0)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[S~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[S~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "adapter0-scripts — the ten frozen deterministic scripts, each run ~
       twice")
(note "terminal law: fold-derived from surviving records (AP-CRASH-1), ~
       compared against the script's declared expectation.~%")

(defvar *script-count* 0)

(dolist (script (load-canonical-scripts))
  (incf *script-count*)
  (let* ((script-id (script-id-string script))
         (expected (script-expected-terminal script))
         (first-run (run-script script))
         (second-run (run-script script)))
    (check (format nil "~a: computed terminal ~a equals declared ~a ~
                        (records ~a, crashed ~a)"
                   script-id (script-run-terminal first-run) expected
                   (length (script-run-records first-run))
                   (if (script-run-crashed-p first-run) "yes" "no"))
      (lambda () (equal (script-run-terminal first-run) expected)))
    (check (format nil "~a: two-pass replay digests byte-identical ~
                        (sha256 ~a)"
                   script-id (script-run-digest first-run))
      (lambda () (string= (script-run-digest first-run)
                          (script-run-digest second-run))))))

(check (format nil "LIVE COUNTER: ~a scripts executed — the four crash ~
                    windows (W1 unresolved-effect · W2 present-partial · ~
                    W3 captured-unprojected · W4 projected-unconsumed), ~
                    the four terminal shapes, cancellation, and ~
                    reconciliation are all among them (AP-FAKE-3, ~
                    AP-CRASH-2)"
               *script-count*)
  (lambda ()
    (and (= 10 *script-count*)
         (equal '("absent-after-completion" "captured-unprojected"
                  "completed" "present" "present-empty" "present-invalid"
                  "present-partial" "projected-unconsumed"
                  "unresolved-effect")
                (sort (remove-duplicates
                       (mapcar #'script-expected-terminal *scripts*)
                       :test #'equal)
                      #'string<)))))

(format t "~%adapter0-scripts: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
