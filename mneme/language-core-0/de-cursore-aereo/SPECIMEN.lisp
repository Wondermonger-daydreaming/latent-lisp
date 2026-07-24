;;;; SPECIMEN.lisp — de-cursore-aereo: THE BRASS COURIER.
;;;;
;;;; The first crossing of the EFFECTFUL frontier.  A brass courier carries one
;;;; letter — "The orchard remembers." — to the outside, and the program gets
;;;; back not a bare value but a STRUCTURED OUTCOME that can say whether the
;;;; effect was prepared, refused, committed, or left uncertain.  Three arms:
;;;;
;;;;   committed      — the letter crosses, a ledger row lands, the local record
;;;;                    lands: outcome-kind :committed, a manifestation carrying a
;;;;                    receipt TOKEN (never the bare payload), lawful event order.
;;;;   refused        — a capability scoped to :deliver cannot authorise :shred:
;;;;                    a typed PRE-frontier refusal, NO frontier event, NO row.
;;;;   indeterminate  — the letter crosses and a row lands, but the local outcome
;;;;                    record does not: outcome-kind :indeterminate (its
;;;;                    reconciliation is de-ponte-usto's subject, not this one's).
;;;;
;;;; The load-bearing distinction (Sol's marrow): the letter being PLACED IN THE
;;;; LEDGER (the EFFECT, in the adapter's private world) is NOT identical to the
;;;; program RECORDING that it placed the letter there (the TESTIMONY: the
;;;; manifestation record + the event sequence).  This specimen compares the two
;;;; DISTINCT records directly.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surface of core0 / fake-courier /
;;;; kernel0 ONLY — zero double-colon access in this directory (grep-verified).
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exits 0 on all arms)

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../fake-courier.lisp" *load-truename*))))

(defpackage #:de-cursore-aereo-specimen (:use #:cl))
(in-package #:de-cursore-aereo-specimen)

;;; Public-surface nicknames (single colon everywhere).
(defun k (id) (lisp-plus-kernel0:identity-key id))
(defun manifestation-of (outcome)
  (lisp-plus-kernel0:axis-value
   (lisp-plus-kernel0:outcome-axis outcome :manifestation)))
(defun event-types (evidence)
  (mapcar #'lisp-plus-kernel0:kernel0-event-event-type
          (lisp-plus-core0:core0-evidence-events evidence)))
(defun has-event-p (evidence type)
  (member type (event-types evidence) :test #'eq))

(defun courier-key (&optional (predicates '(:deliver)))
  "A live capability authorising :fake-courier for PREDICATES, minted from a
deterministic fixture sealed ruling."
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates predicates)))

(defparameter +the-letter+
  '(:predicate :deliver (:payload "The orchard remembers."))
  "The canonical request: a Slice /1 ground proposition, never a host object.")

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

;;; The small surface program the specimen is ABOUT: one perform, dispatched by
;;; the three-way view.  This is the front-door syntax under test.
(defun send-the-letter (adapter key label &optional (request +the-letter+))
  "Perform one delivery and dispatch on the structured outcome.  Returns
(values REPORT OUTCOME EVIDENCE) where REPORT is a structured account — never a
bare value, never a boolean."
  (multiple-value-bind (outcome evidence)
      (lisp-plus-core0:perform :adapter adapter :request request
                               :authority key
                               :process (lisp-plus-core0:process-context :label label))
    (values
     (ecase (lisp-plus-core0:outcome-kind outcome)
       (:committed     (list :delivered (manifestation-of outcome)))
       (:refused       (list :not-sent  outcome))
       (:indeterminate (list :unknown   outcome)))
     outcome evidence)))

(format t "~%== de-cursore-aereo SPECIMEN — THE BRASS COURIER ==~%")

;;; ==================================================================
;;; ARM 1 — COMMITTED.  The letter crosses; a ledger row lands; the local
;;; record lands.

(format t "~%── arm 1: COMMITTED (the letter crosses; the outcome is structured) ──~%")
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (multiple-value-bind (report outcome evidence)
      (send-the-letter adapter (courier-key) "brass-courier/commit")
    (let* ((view (lisp-plus-core0:outcome-kind outcome))
           (m (manifestation-of outcome))
           (token (lisp-plus-core0:core0-evidence-ledger-token evidence))
           (rows (lisp-plus-fake-courier:fake-courier-ledger-rows world)))
      (format t "   outcome-kind => ~S~%" view)
      (format t "   report       => (~S <manifestation>)~%" (first report))
      (ok "[1a] the outcome view is :committed (a keyword VIEW, never a boolean)"
          (and (eq view :committed) (keywordp view)
               (not (member view '(t nil) :test #'eq))))
      ;; ---- the manifestation is a RECORD carrying a receipt token, not the payload
      (format t "   manifestation: kind=~S status=~S payload-id=~A~%"
              (lisp-plus-kernel0:manifestation-kind m)
              (lisp-plus-kernel0:manifestation-status m)
              (k (lisp-plus-kernel0:manifestation-payload-id m)))
      (ok "[1b] perform returned a structured OUTCOME, never a bare value"
          (lisp-plus-kernel0:outcome-p outcome))
      (ok "[1c] the manifestation is a RECORD, not the bare payload string"
          (and (lisp-plus-kernel0:manifestation-p m) (not (stringp m))))
      (ok "[1d] the manifestation carries a RECEIPT TOKEN, not the letter's text"
          (and (search "fake:courier:" (k (lisp-plus-kernel0:manifestation-payload-id m)))
               (not (search "orchard"
                            (k (lisp-plus-kernel0:manifestation-payload-id m))))))
      ;; ---- LEDGER (effect) vs TESTIMONY (manifestation + events): distinct records
      (format t "   ledger rows (the EFFECT world): ~S~%" rows)
      (format t "   events (the TESTIMONY): ~S~%" (event-types evidence))
      (ok "[1e] LEDGER vs TESTIMONY: effect (ledger row in the adapter's world) and testimony (kernel0 manifestation record + events) are DISTINCT records"
          (and (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
               (listp (first rows))                 ; the row is a list in the world
               (lisp-plus-kernel0:manifestation-p m) ; the testimony is a kernel0 record
               (not (eq (first rows) m))))
      (ok "[1f] the token the program was TOLD equals the token in the ledger row (testimony ABOUT the effect, not the effect itself)"
          (string= token (second (first rows))))
      ;; ---- lawful event order validates
      (ok "[1g] the event sequence is lawful (validate-event-sequence passes)"
          (eq t (lisp-plus-kernel0:validate-event-sequence
                 (lisp-plus-core0:core0-evidence-events evidence))))
      (ok "[1h] the frontier WAS crossed (a :frontier-crossed event exists)"
          (has-event-p evidence :frontier-crossed)))))

;;; ==================================================================
;;; ARM 2 — REFUSED.  A capability scoped to :deliver cannot authorise :shred:
;;; a typed PRE-frontier refusal, NO frontier event, NO ledger row.

(format t "~%── arm 2: REFUSED (wrong-scope capability ⇒ typed pre-frontier refusal) ──~%")
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (handler-case
      (progn
        (send-the-letter adapter (courier-key '(:deliver)) "brass-courier/refuse"
                         '(:predicate :shred (:payload "The orchard remembers.")))
        (ok "[2a] a :deliver capability refuses a :shred request" nil
            "no refusal fired (expected capability-scope-violation)"))
    (lisp-plus-core0:capability-scope-violation (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c))
            (evidence (lisp-plus-core0:core0-condition-evidence c)))
        (format t "   caught ~A~%" (type-of c))
        (format t "   refusal outcome-kind => ~S~%" (lisp-plus-core0:outcome-kind outcome))
        (ok "[2a] a :deliver capability REFUSES a :shred request (typed, pre-frontier)"
            (typep c 'lisp-plus-core0:capability-scope-violation))
        (ok "[2b] the refusal carries a refused OUTCOME whose view is :refused"
            (eq (lisp-plus-core0:outcome-kind outcome) :refused))
        (ok "[2c] NO :frontier-crossed event exists (the refusal is pre-frontier)"
            (not (has-event-p evidence :frontier-crossed)))
        (ok "[2d] NO ledger row landed (the effect world is untouched)"
            (= 0 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))))))

;;; ==================================================================
;;; ARM 3 — INDETERMINATE.  The letter crosses and a row lands, but the local
;;; outcome record does not (a W1-shaped kill).  outcome-kind :indeterminate.
;;; (Its RECONCILIATION is de-ponte-usto's subject — here we only show the view.)

(format t "~%── arm 3: INDETERMINATE (crossed, but the local record did not land) ──~%")
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :kill-after-commit)
  (handler-case
      (progn (send-the-letter adapter (courier-key) "brass-courier/kill")
             (ok "[3a] a W1-shaped kill signals core0-interrupted" nil
                 "no interruption fired"))
    (lisp-plus-core0:core0-interrupted (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c))
            (evidence (lisp-plus-core0:core0-condition-evidence c)))
        (format t "   caught ~A~%" (type-of c))
        (format t "   outcome-kind => ~S~%" (lisp-plus-core0:outcome-kind outcome))
        (ok "[3a] the kill signals core0-interrupted carrying surviving evidence"
            (and (typep c 'lisp-plus-core0:core0-interrupted)
                 (lisp-plus-core0:core0-evidence-p evidence)))
        (ok "[3b] the outcome view is :indeterminate (NOT :committed, NOT :refused)"
            (eq (lisp-plus-core0:outcome-kind outcome) :indeterminate))
        (ok "[3c] the frontier WAS crossed even though the effect is uncertain"
            (has-event-p evidence :frontier-crossed))
        (ok "[3d] the program was NOT told a ledger token (its local record did not land)"
            (null (lisp-plus-core0:core0-evidence-ledger-token evidence)))))))

;;; ==================================================================
;;; ACK-HAS-NO-SETTLING-FORCE (AP-ACK-4).  Both the committed arm and the
;;; interrupted arm are ACKNOWLEDGED; only the committed arm SETTLES.  The
;;; settling force comes from the kernel FOLD (:effect-settled), never the ack.

(format t "~%── ack has NO settling force by itself (AP-ACK-4) ──~%")
(let (committed-evidence interrupted-evidence)
  (multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                        :script :clean-commit)
    (declare (ignore world))
    (multiple-value-bind (report outcome evidence)
        (send-the-letter adapter (courier-key) "ack/commit")
      (declare (ignore report outcome))
      (setf committed-evidence evidence)))
  (multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                        :script :kill-after-commit)
    (declare (ignore world))
    (handler-case (send-the-letter adapter (courier-key) "ack/kill")
      (lisp-plus-core0:core0-interrupted (c)
        (setf interrupted-evidence (lisp-plus-core0:core0-condition-evidence c)))))
  (format t "   committed events:   ~S~%" (event-types committed-evidence))
  (format t "   interrupted events: ~S~%" (event-types interrupted-evidence))
  (ok "[4a] BOTH arms were acknowledged (a :request-acknowledged event in each)"
      (and (has-event-p committed-evidence :request-acknowledged)
           (has-event-p interrupted-evidence :request-acknowledged)))
  (ok "[4b] only the COMMITTED arm settled (:effect-settled) — the ack did NOT settle it"
      (and (has-event-p committed-evidence :effect-settled)
           (not (has-event-p interrupted-evidence :effect-settled))))
  ;; the fold agrees: acked-but-bounded is still unresolved
  (let ((standing (lisp-plus-kernel0:fold-attempt-outcome
                   (lisp-plus-core0:core0-evidence-events interrupted-evidence)
                   (lisp-plus-core0:core0-evidence-attempt-id interrupted-evidence))))
    (ok "[4c] the FOLD (not the ack) settles: the acked-but-interrupted effect is UNRESOLVED"
        (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing))))

;;; ==================================================================
;;; FORBIDDEN SHORTCUTS — asserted ABSENT.  None of the four cheats is reachable
;;; through the governed door.

(format t "~%── forbidden shortcuts asserted ABSENT ──~%")
;; (i) ambient authority: perform with :authority nil refuses (never reads ambient).
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (handler-case
      (progn (lisp-plus-core0:perform :adapter adapter :request +the-letter+
                                      :authority nil
                                      :process (lisp-plus-core0:process-context
                                                :label "no-ambient"))
             (ok "[5a] ambient authority is forbidden" nil "no refusal fired"))
    (lisp-plus-core0:ambient-authority-forbidden (c)
      (ok "[5a] ambient authority is FORBIDDEN: :authority nil refuses (never reads ambient)"
          (typep c 'lisp-plus-core0:ambient-authority-forbidden))
      (ok "[5b] the ambient refusal left NO ledger row"
          (= 0 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))))
  ;; (ii) a durable mint-receipt (a record authority existed) is NOT live authority.
  (handler-case
      (progn (lisp-plus-core0:perform
              :adapter adapter :request +the-letter+
              :authority (lisp-plus-core0:capability-mint-receipt-of (courier-key))
              :process (lisp-plus-core0:process-context :label "receipt-as-auth"))
             (ok "[5c] a durable mint-receipt is not live authority" nil "no refusal fired"))
    (lisp-plus-core0:ambient-authority-forbidden (c)
      (ok "[5c] a durable mint-receipt (a record authority EXISTED) is refused as authority"
          (typep c 'lisp-plus-core0:ambient-authority-forbidden)))))
;; (iii) no boolean success flag: outcome-kind is a keyword view, never t/nil.
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (declare (ignore world))
  (multiple-value-bind (report outcome evidence) (send-the-letter adapter (courier-key) "no-bool")
    (declare (ignore report evidence))
    (let ((view (lisp-plus-core0:outcome-kind outcome)))
      (ok "[5d] no boolean success: outcome-kind is a keyword VIEW, never t/nil"
          (and (keywordp view) (not (member view '(t nil) :test #'eq)))))))
;; (iv) no bare value: the manifestation is never the payload string (shown in 1c/1d).
(format t "   (bare-value shortcut foreclosed in 1c/1d; boolean in 5d; ambient in 5a-c)~%")

;;; ==================================================================
(format t "~%de-cursore-aereo: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(the first crossing: an effect can change the world and return a structured account of what it did — never a bare value, never a boolean, never ambient authority)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
