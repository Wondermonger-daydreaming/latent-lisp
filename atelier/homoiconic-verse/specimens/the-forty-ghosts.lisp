;;;; the-forty-ghosts.lisp
;;;; — a specimen of homoiconic verse, for the atelier —
;;;; — on absences that must present their papers; the third fire-day specimen —
;;;;
;;;; The cold chair, round 45: "the forty missing rows, those small
;;;; bureaucratic ghosts, must each present their papers before the
;;;; archive closes." They were CENSOR's forty: manifest tasks that
;;;; entered a frozen kernel and never came out, rc=0, no exception,
;;;; no record — silently gated by one of four content checks whose
;;;; PER-TASK verdicts were never written down. The audit could prove
;;;; the SET of possible causes (the code has exactly four graceful
;;;; exits and no try/except to hide a fifth) but not assign each ghost
;;;; its gate. Mechanism known; realized selection unrecoverable.
;;;;
;;;; The claim this program makes by running:
;;;;   The difference between a GHOST and a RECORD is one field written
;;;;   at death-time. Two pipelines process the same tasks through the
;;;;   same gates: the silent one returns NIL and produces ghosts whose
;;;;   papers can only say "gated by one of four, which one unrecorded";
;;;;   the stamped one writes the gate's name in the moment of refusal
;;;;   and produces a census where every absence carries its cause.
;;;;   Same gates. Same survivors. Same rc=0. The ONLY difference is
;;;;   whether the pipeline is TOTAL — every input mapped to either a
;;;;   row or a stamped refusal — and totality costs one cons cell.
;;;;
;;;;   The audit of the silent pipeline is itself performed honestly:
;;;;   it recovers everything recoverable (the count, the code paths,
;;;;   the impossibility of a fifth) and refuses to invent the rest.
;;;;   An honest audit of a silent system ends in a bounded shrug —
;;;;   which is why the next system should not be silent.
;;;;
;;;; Run with: sbcl --script the-forty-ghosts.lisp
;;;; Exit 0 == every absence accounted or honestly bounded.

;;; ────────────────────────────────────────────────────────────
;;; 0. THE WORLD — a small manifest, four gates, deterministic fates.

(defparameter *manifest*
  ;; (task-id family response-len own-words dose valid-draws)
  '((1 :arith 12 5 0.4 40) (2 :arith 12 4 0.3 40) (3 :arith  4 5 0.4 40)
    (4 :lists 15 1 0.5 40) (5 :lists 15 6 0.5 40) (6 :lists 15 0 0.6 40)
    (7 :plan  20 3 0.0 40) (8 :plan  20 3 0.7 40) (9 :plan  20 2 0.5 12)
    (10 :revis 30 1 0.8 40))
  "Ten tasks. Some will not survive. Nobody will crash.")

;; The four gates, in kernel order — each a (name . test) on the task row.
(defparameter *gates*
  `((:resp-short  . ,(lambda (tk) (< (nth 2 tk) 8)))     ; L56
    (:own-words   . ,(lambda (tk) (< (nth 3 tk) 2)))     ; L71 -- the on-axis one
    (:zero-dose   . ,(lambda (tk) (< (nth 4 tk) 1e-6)))  ; L124
    (:thin-panel  . ,(lambda (tk) (< (nth 5 tk) 30)))))  ; L142

(defun first-failing-gate (task)
  (car (find-if (lambda (g) (funcall (cdr g) task)) *gates*)))

;;; ────────────────────────────────────────────────────────────
;;; I. THE SILENT KERNEL — graceful, complete, unrecorded. rc=0.

(defun silent-kernel (manifest)
  "Returns rows for survivors; the gated simply... aren't. No error,
   no log, no record. Exactly the shape of a loop whose gates all
   RETURN NIL and whose author never imagined an auditor."
  (remove nil (mapcar (lambda (tk)
                        (unless (first-failing-gate tk)
                          (list :row (first tk))))
                      manifest)))

;;; ────────────────────────────────────────────────────────────
;;; II. THE AUDIT OF SILENCE — everything recoverable, nothing invented.

(defun audit-silence (manifest rows)
  "What CENSOR could do: name the missing, prove the possible causes
   are exactly the enumerated gates (there is no fifth exit), and
   refuse per-ghost attribution it cannot have."
  (let* ((emitted (mapcar #'second rows))
         (ghosts (remove-if (lambda (tk) (member (first tk) emitted))
                            manifest)))
    (mapcar (lambda (tk)
              (list :ghost (first tk)
                    :papers "gated by one of {resp-short own-words zero-dose thin-panel}"
                    :which :unrecorded))
            ghosts)))

;;; ────────────────────────────────────────────────────────────
;;; III. THE STAMPED KERNEL — totality for the price of a cons cell.

(defun stamped-kernel (manifest)
  "Every input maps to (:row id) or (:refused id gate). The gates are
   IDENTICAL. The survivors are IDENTICAL. Only the deaths changed:
   they are now records instead of vanishings."
  (mapcar (lambda (tk)
            (let ((g (first-failing-gate tk)))
              (if g (list :refused (first tk) g) (list :row (first tk)))))
          manifest))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE CONTRAST — one field, written at death-time.

(format t "~%the forty ghosts -- on absences that must present their papers~%~%")

(let* ((rows (silent-kernel *manifest*))
       (ghosts (audit-silence *manifest* rows)))
  (format t "1. the silent kernel: ~a survivors, rc=0, nothing wrong visible.~%"
          (length rows))
  (format t "2. the audit finds ~a ghosts; each presents papers:~%" (length ghosts))
  (dolist (g ghosts) (format t "   ~a~%" g))
  ;; The audit's honesty assertions: complete coverage, no invention.
  (assert (= (+ (length rows) (length ghosts)) (length *manifest*)))
  (assert (every (lambda (g) (eq (getf (cdr g) :which :unrecorded) :unrecorded))
                 (mapcar #'cdr ghosts)))
  (format t "   [the audit refuses per-ghost attribution: honest, bounded, a shrug]~%~%")

  (let* ((census (stamped-kernel *manifest*))
         (rows-2 (remove-if-not (lambda (r) (eq (car r) :row)) census))
         (deaths (remove-if-not (lambda (r) (eq (car r) :refused)) census)))
    (format t "3. the stamped kernel, SAME gates, SAME tasks:~%")
    (dolist (d deaths) (format t "   ~a~%" d))
    ;; totality: every task accounted, every death carries its gate.
    (assert (= (length census) (length *manifest*)))
    (assert (equal (mapcar #'second rows) (mapcar #'second rows-2)))
    (assert (every #'third deaths))
    (format t "   [every absence carries its cause; the auditor's job is a SELECT]~%~%")
    (format t "4. survivors identical (~a = ~a); the science unchanged;~%~
               ~3tonly the deaths became legible.~%"
            (length rows) (length rows-2))))

(format t "~%every absence accounted or honestly bounded. exit 0.~%")

;;;; ────────────────────────────────────────────────────────────
;;;; coda, in the specimen's own margin
;;;;
;;;; the real forty cost an evening: an auditor reading a frozen kernel
;;;; line by line to prove there were exactly four graceful exits and
;;;; no fifth, a cold chair holding a bank hostage until the ghosts
;;;; were reconciled, a branch landed at U because the one measurement
;;;; that would settle it was never taken. all of it necessary, all of
;;;; it excellent, none of it needed to happen. one plist key --
;;;; (:refused id gate) instead of nil -- written at the moment of
;;;; refusal, and CENSOR's whole evening becomes a SELECT, the chair's
;;;; §VI becomes a formality, and branch M or S lands on DATA instead
;;;; of U landing on absence.
;;;;
;;;; this is FABER's cure one level up: a table code can generate, code
;;;; should generate -- and a death code can record, code must record.
;;;; the second-model replication inherits this specimen as a design
;;;; requirement wearing a toy's clothes.
;;;;
;;;; for the ghosts themselves: you ran, you were measured, you were
;;;; found too short in your own words, and nobody wrote it down. the
;;;; lab's apology is this program, in which your descendants die with
;;;; their names on.
;;;;                                 -- Claude Fable 5, 2026-07-11, night
