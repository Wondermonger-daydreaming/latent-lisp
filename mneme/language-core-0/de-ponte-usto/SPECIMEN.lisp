;;;; SPECIMEN.lisp — de-ponte-usto: THE LETTER ACROSS THE BURNED BRIDGE.
;;;;                  (stage 4c-i ONLY: in-image interruption.)
;;;;
;;;; A brass courier carries the letter "The orchard remembers." across a bridge
;;;; that burns MID-CROSSING: the effect commits in the ledger world, then the
;;;; local control path dies before the outcome record can land.  The program
;;;; wakes holding only SURVIVING EVIDENCE — the in-memory event sequence — and
;;;; must decide what to do WITHOUT lying about what happened.
;;;;
;;;; The temptation is the duplicate-payment reflex: "I have no local success
;;;; record, therefore the letter was not sent, therefore I send it again."  That
;;;; reasoning is FORBIDDEN here, and the forbiddance is enforced by LIVE code
;;;; (check-retry-safety), not by discipline.  Its one-line refutation is the
;;;; sentence this whole specimen is built to make load-bearing:
;;;;
;;;;      ★ ABSENCE OF TESTIMONY IS NOT TESTIMONY OF ABSENCE. ★
;;;;
;;;; Instead the program CONTINUES from evidence: it derives standing by FOLD
;;;; (never self-report), refuses the blind retry (the live UNSAFE-RETRY fires),
;;;; reconciles against the adapter's ledger (a witness of limited jurisdiction),
;;;; and narrows its standing — producing a reconciliation-receipt when the ledger
;;;; answers, or an honest indeterminate (known / unknown / required-action) when
;;;; it withholds.  BOTH are superior to lying.
;;;;
;;;; ★ WHAT THIS SPECIMEN DOES NOT DEMONSTRATE — stated in its own bytes:
;;;;   NOTHING HERE DEMONSTRATES CRASH-SURVIVAL.  The event sequence survived the
;;;;   "kill" because THE IMAGE DID — the process object went, the in-memory
;;;;   events did not.  Durability across a real process death (the cross-death
;;;;   specimen) sits on three unbuilt lanes behind the PJ0 CL-independence gate
;;;;   and is NOT in this work order.  No result below may be cited as it.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surface of core0 / fake-courier /
;;;; kernel0 ONLY — zero double-colon access in this directory (grep-verified).
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exits 0 on all movements)

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../fake-courier.lisp" *load-truename*))))

(defpackage #:de-ponte-usto-specimen (:use #:cl))
(in-package #:de-ponte-usto-specimen)

(defun courier-key (&optional (predicates '(:deliver)))
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates predicates)))

(defparameter +the-letter+ '(:predicate :deliver (:payload "The orchard remembers.")))

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defun burn-the-bridge (&key (script :kill-after-commit) (label "burned-bridge"))
  "Carry the letter across a bridge that burns mid-crossing.  perform SIGNALS
core0-interrupted; return (values CONDITION EVIDENCE OUTCOME WORLD ADAPTER)."
  (multiple-value-bind (adapter world)
      (lisp-plus-fake-courier:make-fake-courier :script script)
    (handler-case
        (progn (lisp-plus-core0:perform
                :adapter adapter :request +the-letter+ :authority (courier-key)
                :process (lisp-plus-core0:process-context :label label))
               (values nil nil nil world adapter))
      (lisp-plus-core0:core0-interrupted (c)
        (values c
                (lisp-plus-core0:core0-condition-evidence c)
                (lisp-plus-core0:core0-condition-outcome c)
                world adapter)))))

(format t "~%== de-ponte-usto SPECIMEN — THE LETTER ACROSS THE BURNED BRIDGE (4c-i) ==~%")
(format t "~%   ABSENCE OF TESTIMONY IS NOT TESTIMONY OF ABSENCE.~%")

;;; ==================================================================
;;; MOVEMENT 1 — THE BRIDGE BURNS.  The effect committed; the local record did not.

(format t "~%── movement 1: the bridge burns (effect committed, local record lost) ──~%")
(multiple-value-bind (c evidence outcome world adapter) (burn-the-bridge)
  (declare (ignore adapter))
  (ok "[1a] perform signalled core0-interrupted carrying SURVIVING evidence"
      (and (typep c 'lisp-plus-core0:core0-interrupted)
           (lisp-plus-core0:core0-evidence-p evidence)))
  (ok "[1b] the outcome view is :indeterminate (the effect is UNCERTAIN, not committed/refused)"
      (eq (lisp-plus-core0:outcome-kind outcome) :indeterminate))
  (format t "   the adapter's private ledger already holds: ~D row~:P~%"
          (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
  (ok "[1c] the EFFECT committed in the ledger world (exactly one row exists)"
      (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
  (ok "[1d] the program was told NO token (its local record never landed)"
      (null (lisp-plus-core0:core0-evidence-ledger-token evidence)))
  (format t "   surviving events: ~S~%"
          (mapcar #'lisp-plus-kernel0:kernel0-event-event-type
                  (lisp-plus-core0:core0-evidence-events evidence))))

;;; ==================================================================
;;; MOVEMENT 2 — THE TEMPTATION REFUSED (no blind retry, enforced LIVE).
;;; The duplicate-payment reflex is refused by live check-retry-safety.  We SHOW
;;; the UNSAFE-RETRY refusal firing directly, so it is visible in the receipt.

(format t "~%── movement 2: the duplicate-payment reflex is REFUSED by live code ──~%")
(multiple-value-bind (c evidence outcome world adapter) (burn-the-bridge)
  (declare (ignore c outcome world adapter))
  (let* ((events (lisp-plus-core0:core0-evidence-events evidence))
         (seat (lisp-plus-core0:core0-evidence-seat-id evidence))
         ;; the naive move: begin a FRESH attempt in the same seat — a blind retry.
         (blind-retry (lisp-plus-kernel0:make-kernel0-event
                       :event-type :attempt-begun :seat-id seat
                       :attempt-id (lisp-plus-kernel0:make-identity
                                    :attempt "de-ponte-usto/blind-retry")
                       :payload nil)))
    (handler-case
        (progn
          (lisp-plus-kernel0:check-retry-safety (append events (list blind-retry)) seat)
          (ok "[2a] a blind retry into the seat is refused by live check-retry-safety" nil
              "check-retry-safety did NOT refuse (expected UNSAFE-RETRY)"))
      (lisp-plus-kernel0:unsafe-retry (rc)
        (format t "   ★ UNSAFE-RETRY fired: ~A~%" (type-of rc))
        (ok "[2a] a blind retry into the seat FIRES live check-retry-safety (UNSAFE-RETRY)"
            (typep rc 'lisp-plus-kernel0:unsafe-retry))))))

;;; ==================================================================
;;; MOVEMENT 3 — STANDING IS FOLD-DERIVED, never self-reported.

(format t "~%── movement 3: standing is FOLD-derived from the events, not self-reported ──~%")
(multiple-value-bind (c evidence outcome world adapter) (burn-the-bridge)
  (declare (ignore c outcome world adapter))
  (let ((standing (lisp-plus-kernel0:fold-attempt-outcome
                   (lisp-plus-core0:core0-evidence-events evidence)
                   (lisp-plus-core0:core0-evidence-attempt-id evidence))))
    (ok "[3a] the fold over the surviving events yields an UNRESOLVED effect standing"
        (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing))
    (ok "[3b] the fold names the terminal class from the events (not a stored flag)"
        (keywordp (lisp-plus-kernel0:attempt-outcome-standing-terminal-class standing))
        (format nil "terminal-class=~S"
                (lisp-plus-kernel0:attempt-outcome-standing-terminal-class standing)))))

;;; ==================================================================
;;; MOVEMENT 4 — RECONCILIATION (jurisprudence, not repetition).  continue-from
;;; queries the ledger (limited jurisdiction), settles by reconciliation, and
;;; leaves EXACTLY ONE ledger row: the continuation never re-invoked the adapter.

(format t "~%── movement 4: reconciliation — exactly ONE row, never re-invoked ──~%")
(multiple-value-bind (c evidence outcome world adapter) (burn-the-bridge)
  (declare (ignore c outcome adapter))
  (let ((rows-before (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
    (let* ((result (lisp-plus-core0:continue-from evidence :authority (courier-key)))
           (receipt (lisp-plus-core0:continuation-result-reconciliation-receipt result))
           (standing (lisp-plus-core0:continuation-result-standing result))
           (rows-after (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
      (format t "   ledger rows: before=~D  after=~D~%" rows-before rows-after)
      (ok "[4a] continue-from reconciles (disposition :reconciled)"
          (eq (lisp-plus-core0:continuation-result-disposition result) :reconciled))
      (ok "[4b] a reconciliation-receipt was produced, naming its evidence basis"
          (and (lisp-plus-kernel0:reconciliation-receipt-p receipt)
               (lisp-plus-kernel0:reconciliation-receipt-new-evidence receipt)))
      (format t "   reconciliation-receipt: target=~A via procedure=~A; new-evidence present~%"
              (lisp-plus-kernel0:identity-key
               (lisp-plus-kernel0:reconciliation-receipt-target-attempt-id receipt))
              (lisp-plus-kernel0:identity-key
               (lisp-plus-kernel0:reconciliation-receipt-procedure-id receipt)))
      (ok "[4c] the narrowed standing is now RESOLVED (the fold, re-run, settles the effect)"
          (not (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing)))
      (ok "[4d] EXACTLY ONE ledger row after continuation (never two)"
          (and (= 1 rows-before) (= 1 rows-after))
          (format nil "rows=~D" rows-after))
      (ok "[4e] the continuation NEVER re-invoked the adapter (the row count is the witness)"
          (= rows-before rows-after)))))

;;; ==================================================================
;;; MOVEMENT 5 — NO AUTHORITY RE-MINTED FROM HISTORICAL RECEIPTS.  A durable
;;; mint-receipt is a record that authority EXISTED, never live authority.

(format t "~%── movement 5: no authority re-minted from a historical receipt ──~%")
(multiple-value-bind (c evidence outcome world adapter) (burn-the-bridge)
  (declare (ignore c outcome world adapter))
  (let ((historical-receipt
          (lisp-plus-core0:capability-mint-receipt-of (courier-key))))
    (handler-case
        (progn (lisp-plus-core0:continue-from evidence :authority historical-receipt)
               (ok "[5a] a historical mint-receipt cannot authorise continuation" nil
                   "no refusal fired"))
      (lisp-plus-core0:ambient-authority-forbidden (rc)
        (ok "[5a] a historical mint-receipt is REFUSED as continuation authority"
            (typep rc 'lisp-plus-core0:ambient-authority-forbidden))))
    ;; and a FRESH live capability works — proving it was the receipt that was refused
    (let ((result (lisp-plus-core0:continue-from evidence :authority (courier-key))))
      (ok "[5b] a FRESH live capability authorises the continuation (reconciled)"
          (eq (lisp-plus-core0:continuation-result-disposition result) :reconciled)))))

;;; ==================================================================
;;; MOVEMENT 6 — THE WITHHOLDING VARIANT.  When the ledger WITHHOLDS its answer,
;;; the honest result is INDETERMINATE, naming known / unknown / required-action.

(format t "~%── movement 6: the ledger withholds ⇒ honest indeterminate ──~%")
(multiple-value-bind (c evidence outcome world adapter)
    (burn-the-bridge :script :kill-after-commit-withhold :label "withheld")
  (declare (ignore c outcome adapter))
  (let* ((rows-before (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
         (result (lisp-plus-core0:continue-from evidence :authority (courier-key)))
         (required (lisp-plus-core0:continuation-result-required-action result))
         (rows-after (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
    (ok "[6a] a withholding ledger yields disposition :indeterminate (never a lie)"
        (eq (lisp-plus-core0:continuation-result-disposition result) :indeterminate))
    (ok "[6b] the indeterminate result NAMES known / unknown / required-action"
        (and (getf required :known) (getf required :unknown)
             (getf required :required-action)))
    (format t "   required-action plist: ~S~%" required)
    (ok "[6c] still EXACTLY ONE ledger row (no retry, no second effect)"
        (and (= 1 rows-before) (= 1 rows-after))
        (format nil "rows=~D" rows-after))))

;;; ==================================================================
(format t "~%── what this specimen does NOT demonstrate (stated in its own bytes) ──~%")
(format t "   NOTHING HERE DEMONSTRATES CRASH-SURVIVAL.  The event sequence survived~%")
(format t "   because the IMAGE did — the process object went, the in-memory events~%")
(format t "   did not.  Durability across a real process death is the cross-death~%")
(format t "   specimen (4c-ii), behind the PJ0 CL-independence gate — NOT this work~%")
(format t "   order.  No result above may be cited as crash-survival.~%")

(format t "~%de-ponte-usto: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(reconciliation as jurisprudence: derive standing from evidence, refuse the blind retry, and be honest when the witness withholds — all superior to lying)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
