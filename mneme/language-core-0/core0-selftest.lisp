;;;; core0-selftest.lisp — substrate teeth for Lisp+ Language Core /0.
;;;;
;;;; The nine work-order §1.4 teeth, each BITING BEFORE CURE: plant the fault,
;;;; show the typed refusal FIRE, then show the lawful path pass.  Output mirrors
;;;; slice1-selftest / kernel0-selftest: a final "N passed / 0 failed" tally and
;;;; a nonzero exit on any failure.
;;;;
;;;; ALL greens here are SELF-CONSISTENCY CERTIFICATION, never independent
;;;; conformance (AP0 §24.1).  Nothing relies on PJ0 or claims durability across
;;;; process death; the fake courier is a labeled scripted subset.
;;;;
;;;; Run: sbcl --non-interactive --load core0-selftest.lisp   (exit 0 on all-pass)

(handler-bind ((style-warning (lambda (w) (muffle-warning w))))
  (load (merge-pathnames "fake-courier.lisp" *load-truename*)))

(in-package #:lisp-plus-core0)

;;; A package alias so the courier calls stay legible (registered BEFORE the
;;; reader meets any `fc:` symbol below).
(rename-package (find-package :lisp-plus-fake-courier)
                :lisp-plus-fake-courier '(:lisp-plus-fake-courier :fc))

(defvar *pass* 0)
(defvar *fail* 0)

(defun ok (name bool &optional detail)
  (if bool
      (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defmacro fires (name expected-type &body body)
  "Assert BODY signals EXPECTED-TYPE; PRINT the fired type (the tooth biting)."
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (ok ,name nil "no condition fired (expected a refusal)"))
       (,expected-type (,c)
         (ok ,name t (format nil "bit: caught ~A" (type-of ,c))))
       (error (,c)
         (ok ,name nil (format nil "wrong condition: ~A" (type-of ,c)))))))

;;; ------------------------------------------------------------------
;;; Fixtures — thin scenario builders over the public surface.

(defun a-process (label) (process-context :label label))

(defun a-capability (&key (predicates '(:deliver)) (adapter :fake-courier))
  (mint-capability :ruling (fixture-sealed-ruling :adapter-name adapter
                                                  :predicates predicates)))

(defparameter +deliver-request+
  '(:predicate :deliver (:payload "The orchard remembers.")))

(defun clean-commit-run ()
  "Run a clean commit; return (values OUTCOME EVIDENCE WORLD ADAPTER)."
  (multiple-value-bind (adapter world) (fc:make-fake-courier :script :clean-commit)
    (multiple-value-bind (outcome evidence)
        (perform :adapter adapter :request +deliver-request+
                 :authority (a-capability) :process (a-process "clean"))
      (values outcome evidence world adapter))))

(defun kill-run (&key (script :kill-after-commit) (label "kill"))
  "Run a W1-shaped kill; PERFORM signals core0-interrupted.  Return
(values CONDITION EVIDENCE OUTCOME WORLD ADAPTER)."
  (multiple-value-bind (adapter world) (fc:make-fake-courier :script script)
    (handler-case
        (progn (perform :adapter adapter :request +deliver-request+
                        :authority (a-capability) :process (a-process label))
               (values nil nil nil world adapter))
      (core0-interrupted (c)
        (values c (core0-condition-evidence c) (core0-condition-outcome c)
                world adapter)))))

(format t "~%== Language Core /0 substrate teeth (self-consistency certification) ==~%")

;;; ==================================================================
;;; TOOTH 1 — bare-value return attempt.  perform NEVER returns a bare
;;; manifestation value; a bare value has amputated the execution context.

(format t "~%-- Tooth 1: bare-value return attempt --~%")
(fires "T1 bite: a bare string where an outcome is required refuses" core0-refused
  (%require-outcome "fake:courier:0001" :perform-result))
(multiple-value-bind (outcome evidence) (clean-commit-run)
  (declare (ignore evidence))
  (ok "T1 cure: perform returns a structured 4-axis outcome, never a bare value"
      (and (lisp-plus-kernel0:outcome-p outcome)
           (eq outcome (%require-outcome outcome :perform-result))))
  ;; the manifestation carried is a RECORD, never the bare payload string
  (let ((m (lisp-plus-kernel0:axis-value
            (lisp-plus-kernel0:outcome-axis outcome :manifestation))))
    (ok "T1 cure: the manifestation is a record, not the bare payload string"
        (and (lisp-plus-kernel0:manifestation-p m)
             (not (stringp m))))))

;;; ==================================================================
;;; TOOTH 2 — boolean summary attempt.  No boolean success anywhere;
;;; outcome-kind is a keyword VIEW, never success/failure truth.

(format t "~%-- Tooth 2: boolean summary attempt --~%")
(fires "T2 bite: a boolean summary (t) refuses" core0-refused
  (%forbid-boolean-summary t :success))
(fires "T2 bite: a boolean summary (nil) refuses" core0-refused
  (%forbid-boolean-summary nil :success))
(multiple-value-bind (outcome evidence) (clean-commit-run)
  (declare (ignore evidence))
  (let ((view (outcome-kind outcome)))
    (ok "T2 cure: outcome-kind is a keyword view, not a boolean"
        (and (keywordp view) (not (member view '(t nil) :test #'eq))
             (eq view :committed))
        (format nil "view=~S" view))))

;;; ==================================================================
;;; TOOTH 3 — ambient-authority attempt.  Authority is explicit, never ambient;
;;; perform refuses when no live capability is passed EVEN with a tempting
;;; ambient one in scope (proving it never reads the ambient).

(format t "~%-- Tooth 3: ambient-authority attempt --~%")
(defvar *tempting-ambient-capability* nil)
(let ((*tempting-ambient-capability* (a-capability)))
  (multiple-value-bind (adapter world) (fc:make-fake-courier :script :clean-commit)
    (declare (ignore world))
    (fires "T3 bite: perform with :authority nil refuses (never reads ambient)"
        ambient-authority-forbidden
      (perform :adapter adapter :request +deliver-request+
               :authority nil :process (a-process "ambient")))
    ;; also: a durable mint-receipt (a record authority existed) is not live authority
    (fires "T3 bite: a durable mint-receipt is refused as authority"
        ambient-authority-forbidden
      (perform :adapter adapter :request +deliver-request+
               :authority (capability-mint-receipt-of *tempting-ambient-capability*)
               :process (a-process "ambient2")))))
(multiple-value-bind (outcome evidence) (clean-commit-run)
  (declare (ignore evidence))
  (ok "T3 cure: perform with an explicit live capability commits"
      (eq (outcome-kind outcome) :committed)))

;;; ==================================================================
;;; TOOTH 4 — blind-retry attempt.  A blind re-invocation into a seat with an
;;; unresolved effect is refused by LIVE check-retry-safety (kernel §14.1).

(format t "~%-- Tooth 4: blind-retry attempt --~%")
(multiple-value-bind (c evidence outcome world adapter) (kill-run)
  (declare (ignore outcome world adapter))
  (ok "T4 setup: the kill produced an interrupted condition + evidence"
      (and (typep c 'core0-interrupted) (core0-evidence-p evidence)))
  (let* ((events (core0-evidence-events evidence))
         (seat (core0-evidence-seat-id evidence))
         (retry (lisp-plus-kernel0:make-kernel0-event
                 :event-type :attempt-begun :seat-id seat
                 :attempt-id (lisp-plus-kernel0:make-identity
                              :attempt "core0-selftest/blind-retry")
                 :payload nil)))
    (fires "T4 bite: a blind retry into the seat fires live check-retry-safety"
        lisp-plus-kernel0:unsafe-retry
      (lisp-plus-kernel0:check-retry-safety (append events (list retry)) seat)))
  ;; cure: continue-from reconciles WITHOUT a blind retry
  (let ((result (continue-from evidence :authority (a-capability))))
    (ok "T4 cure: continue-from reconciles without retrying"
        (eq (continuation-result-disposition result) :reconciled))))

;;; ==================================================================
;;; TOOTH 5 — ack-settles attempt.  An acknowledgment has NO settling force by
;;; itself (AP-ACK-4); the kernel fold settles.  An acked-but-bounded attempt is
;;; NOT :committed; only reconciliation (fold) resolves it.

(format t "~%-- Tooth 5: ack-settles attempt --~%")
(multiple-value-bind (c evidence outcome world adapter) (kill-run)
  (declare (ignore c world adapter))
  (let* ((events (core0-evidence-events evidence))
         (acked (some (lambda (e) (eq (lisp-plus-kernel0:kernel0-event-event-type e)
                                      :request-acknowledged))
                      events))
         (standing (lisp-plus-kernel0:fold-attempt-outcome
                    events (core0-evidence-attempt-id evidence))))
    (ok "T5 bite: the attempt WAS acknowledged" acked)
    (ok "T5 bite: despite the ack, the fold leaves the effect UNRESOLVED (ack≠settle)"
        (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing))
    (ok "T5 bite: an acked-but-bounded outcome-kind is :indeterminate, NOT :committed"
        (eq (outcome-kind outcome) :indeterminate)))
  ;; cure: reconciliation (the kernel fold, NOT the ack) settles the effect
  (let* ((result (continue-from evidence :authority (a-capability)))
         (standing (continuation-result-standing result)))
    (ok "T5 cure: after reconciliation the fold settles (unresolved-effect-p nil)"
        (not (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing)))))

;;; ==================================================================
;;; TOOTH 6 — duplicate-invocation-after-continuation.  Exactly ONE ledger row
;;; after continuation, never two: absence of local testimony is not testimony
;;; of absence, so the continuation reconciles rather than re-striking.

(format t "~%-- Tooth 6: duplicate-invocation-after-continuation --~%")
(multiple-value-bind (c evidence outcome world adapter) (kill-run)
  (declare (ignore c outcome adapter))
  (ok "T6 setup: the ledger holds exactly one row after the kill"
      (= 1 (fc:fake-courier-ledger-row-count world)))
  (let ((result (continue-from evidence :authority (a-capability))))
    (ok "T6 bite→cure: after continuation the ledger STILL holds exactly one row"
        (and (eq (continuation-result-disposition result) :reconciled)
             (= 1 (fc:fake-courier-ledger-row-count world)))
        (format nil "rows=~D" (fc:fake-courier-ledger-row-count world)))
    ;; the duplicate-strike protection is that continue-from never re-invoked the
    ;; adapter in the first place — the row count is the witness.
    (ok "T6 cure: the continuation never re-invoked the adapter (row count is the witness)"
        (= 1 (fc:fake-courier-ledger-row-count world)))))

;;; ==================================================================
;;; TOOTH 7 — event-order violation.  validate-event-sequence enforces the
;;; §13.5 transition legality: a frontier cannot be crossed before its effect
;;; is prepared.

(format t "~%-- Tooth 7: event-order violation --~%")
(let* ((process (a-process "order"))
       (seat (process-context-seat-id process))
       (operation (process-context-logical-operation-id process))
       (attempt (lisp-plus-kernel0:make-identity :attempt "core0-selftest/order"))
       (effect (lisp-plus-kernel0:make-identity :effect "core0-selftest/order-effect"))
       (ev (lambda (type &rest kw)
             (apply #'lisp-plus-kernel0:make-kernel0-event :event-type type
                    :process-id (process-context-process-id process) kw)))
       (bad (list (funcall ev :process-created)
                  (funcall ev :seat-reserved :seat-id seat)
                  (funcall ev :attempt-begun :seat-id seat :attempt-id attempt
                           :logical-operation-id operation)
                  ;; frontier crossed BEFORE effect prepared — illegal
                  (funcall ev :frontier-crossed :seat-id seat :attempt-id attempt
                           :effect-id effect)))
       (good (list (funcall ev :process-created)
                   (funcall ev :seat-reserved :seat-id seat)
                   (funcall ev :attempt-begun :seat-id seat :attempt-id attempt
                            :logical-operation-id operation)
                   (funcall ev :effect-prepared :seat-id seat :attempt-id attempt
                            :effect-id effect)
                   (funcall ev :frontier-crossed :seat-id seat :attempt-id attempt
                            :effect-id effect))))
  (fires "T7 bite: frontier-before-prepared fires journal-illegal-transition"
      lisp-plus-kernel0:journal-illegal-transition
    (lisp-plus-kernel0:validate-event-sequence bad))
  (ok "T7 cure: the lawful order validates"
      (eq t (lisp-plus-kernel0:validate-event-sequence good))))

;;; ==================================================================
;;; TOOTH 8 — capability scope violation.  A capability scoped to :deliver does
;;; not authorise :shred; the refusal is pre-frontier, with NO ledger row.

(format t "~%-- Tooth 8: capability scope violation --~%")
(multiple-value-bind (adapter world) (fc:make-fake-courier :script :clean-commit)
  (fires "T8 bite: a :deliver capability refuses a :shred request (pre-frontier)"
      capability-scope-violation
    (perform :adapter adapter
             :request '(:predicate :shred (:payload "x"))
             :authority (a-capability :predicates '(:deliver))
             :process (a-process "scope")))
  (ok "T8 bite: the refused attempt left NO ledger row"
      (= 0 (fc:fake-courier-ledger-row-count world)))
  ;; cure: an in-scope request commits, and now a row lands
  (multiple-value-bind (outcome evidence)
      (perform :adapter adapter :request +deliver-request+
               :authority (a-capability :predicates '(:deliver))
               :process (a-process "scope2"))
    (declare (ignore evidence))
    (ok "T8 cure: an authorised request commits, and a row lands"
        (and (eq (outcome-kind outcome) :committed)
             (= 1 (fc:fake-courier-ledger-row-count world))))))

;;; ==================================================================
;;; TOOTH 9 — quiet-zone leak.  An ordinary (abacus) program references ZERO
;;; governed-package symbols; a program that touches a governed package is
;;; flagged by machine check.

(format t "~%-- Tooth 9: quiet-zone leak --~%")
(defun %governed-package-p (pkg)
  (and pkg (member (package-name pkg)
                   '("LISP-PLUS-CORE0" "LISP-PLUS-SLICE0" "LISP-PLUS-SLICE1"
                     "LISP-PLUS-KERNEL0" "LISP-PLUS-FAKE-COURIER")
                   :test #'string=)))

(defun %governed-external-symbol-p (s)
  "True when S is an EXTERNAL (public) symbol of a governed package — i.e. a real
reference into a governed surface, not an unqualified local that merely happened
to intern into the current package while the form was read."
  (let ((pkg (symbol-package s)))
    (and (%governed-package-p pkg)
         (eq (nth-value 1 (find-symbol (symbol-name s) pkg)) :external))))

(defun %scan-governed-references (form)
  "Every symbol in FORM that is a public symbol of a governed package (the
machine check the quiet-zone control asserts is EMPTY for an ordinary program)."
  (let ((hits '()))
    (labels ((walk (x)
               (cond ((symbolp x)
                      (when (%governed-external-symbol-p x) (pushnew x hits)))
                     ((consp x) (walk (car x)) (walk (cdr x))))))
      (walk form))
    (nreverse hits)))

(let ((leaky '(let ((r (lisp-plus-core0:perform :adapter :x)))
                (declare (ignore r)) 0))
      (abacus '(let ((tally 0))
                (dolist (ch (list #\a #\e #\i #\o #\u)) (declare (ignore ch)) (incf tally))
                tally)))
  (ok "T9 bite: a program touching a governed package is flagged"
      (not (null (%scan-governed-references leaky)))
      (format nil "leaked: ~S" (%scan-governed-references leaky)))
  (ok "T9 cure: the ordinary abacus program references ZERO governed symbols"
      (null (%scan-governed-references abacus))))

;;; ==================================================================
;;; Extra: the pre-frontier REFUSED view + the adapter-side refuse-before-frontier
;;; (rounding out the three-way projection the two-door ruling requires).

(format t "~%-- Extra: the three-way view (refused / committed / indeterminate) --~%")
(multiple-value-bind (adapter world) (fc:make-fake-courier :script :refuse-before-frontier)
  (declare (ignore world))
  (handler-case
      (progn (perform :adapter adapter :request +deliver-request+
                      :authority (a-capability) :process (a-process "refuse"))
             (ok "X refused: adapter refuse-before-frontier signals a refusal" nil))
    (core0-refused (c)
      (ok "X refused: adapter refuse-before-frontier signals core0-refused"
          (eq (outcome-kind (core0-condition-outcome c)) :refused)
          (format nil "view=~S" (outcome-kind (core0-condition-outcome c)))))))
(multiple-value-bind (c evidence outcome world adapter)
    (kill-run :script :kill-after-commit-withhold :label "withhold")
  (declare (ignore c evidence world adapter))
  (ok "X indeterminate: a W1 kill's outcome-kind is :indeterminate"
      (eq (outcome-kind outcome) :indeterminate)))
(multiple-value-bind (c evidence outcome world adapter)
    (kill-run :script :kill-after-commit-withhold :label "withhold2")
  (declare (ignore c outcome world adapter))
  (let ((result (continue-from evidence :authority (a-capability))))
    (ok "X indeterminate: a withholding ledger yields an indeterminate continuation"
        (and (eq (continuation-result-disposition result) :indeterminate)
             (continuation-result-required-action result)))))

;;; ==================================================================
;;; Tally + exit.

(format t "~%== Core /0 substrate teeth: ~D passed / ~D failed ==~%" *pass* *fail*)
(format t "(self-consistency certification — no PJ0 reliance, no durability claim, ~
no AP0-conformance claim)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
