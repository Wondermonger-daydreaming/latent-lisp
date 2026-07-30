;;;; script-machine.lisp — the deterministic fake-adapter script
;;;; interpreter (§19).
;;;;
;;;; AP-FAKE-1: cursor-driven, deterministic.  Every emitted record is a
;;;; canonical CD/0 record whose every field derives from the script
;;;; identity, the declared seed, the step ordinal, the bound descriptor,
;;;; and the frozen absence table — no clock, no randomness, no host
;;;; state.  AP-FAKE-2 is therefore checkable: the same script, seed, and
;;;; initial state re-produce byte-identical records, proven by digesting
;;;; the canonical encodings of the whole record trail.
;;;;
;;;; The kill point (§19 :kill-point) marks the crash boundary: steps
;;;; after a kill are RECOVERY operations over the surviving records
;;;; (SCRIPT-RECONCILE's post-crash reconciliation).  The terminal is
;;;; FOLD-DERIVED from the surviving records (AP-CRASH-1: no stored
;;;; resolved flag) — never read off the script's own expectation.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

;;; ---------------------------------------------------------------------------
;;; Record construction helpers (canonical CD/0).

(defun %rec (&rest field-specs)
  "FIELD-SPECS: alternating (SEGMENTS...) VALUE-DATUM pairs where SEGMENTS
is a list of key segments under no implicit namespace."
  (make-record-datum
   (loop for (segments value) on field-specs by #'cddr
         collect (make-record-entry (identifier-from-segments segments)
                                    value))))

(defun %str (string) (make-string-datum string))
(defun %int (value) (make-integer-datum value))
(defun %bool (value) (make-boolean-datum value))
(defun %unit () (make-unit-datum))
(defun %id (&rest segments) (identifier-from-segments segments))

;;; ---------------------------------------------------------------------------
;;; Script access.

(defvar *scripts* nil "Loaded canonical scripts (list of records).")

(defun load-script (pathname)
  (read-pjs-fixture pathname))

(defun load-canonical-scripts ()
  (setf *scripts*
        (mapcar #'read-pjs-fixture
                (sort (directory (merge-pathnames "scripts/*.pjs"
                                                  +reissue-root+))
                      #'string< :key #'namestring)))
  *scripts*)

(defun script-id-string (script) (%id-leaf script "script-id"))
(defun script-name (script) (case-string script "name"))
(defun script-expected-terminal (script) (%id-leaf script "expected-terminal"))

(defun script-by-name (name)
  (unless *scripts* (load-canonical-scripts))
  (find name *scripts* :key #'script-name :test #'equal))

(defun %script-steps (script)
  (let ((steps (case-field script "steps")))
    (loop for index below (sequence-datum-length steps)
          collect (sequence-datum-ref steps index))))

;;; ---------------------------------------------------------------------------
;;; The interpreter.

(defstruct (script-run (:constructor %make-script-run
                           (terminal records digest crashed-p)))
  terminal      ; leaf string — the FOLD-DERIVED terminal
  records       ; list of canonical CD/0 records, emission order
  digest        ; sha256 hex over the canonical record trail
  crashed-p)

(defstruct %machine
  script-leaf seed descriptor adapter-identity adapter-version
  (ordinal 0)
  (records '())
  prepared dispatched acknowledged envelope projection-row
  cancelled reconciled crashed
  (chunks '())
  mutation)

(defun %emit (machine record)
  (push record (%machine-records machine))
  record)

(defun %mid (machine kind)
  "Deterministic identity string for the current step."
  (format nil "~a-~a-~2,'0d" kind (%machine-script-leaf machine)
          (%machine-ordinal machine)))

(defun %op-prepare (machine)
  ;; §21 steps 1–4: descriptor resolution is the machine's construction;
  ;; here the prepared invocation, the outbound request capture, and the
  ;; exposure event are emitted IN THAT ORDER, all pre-frontier.
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "prepared-invocation")
                 '("ap0" "prepared-id") (%str (%mid machine "prep"))
                 '("ap0" "adapter-identity")
                 (%str (%machine-adapter-identity machine))
                 '("ap0" "adapter-version")
                 (%str (%machine-adapter-version machine))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 '("ap0" "provider-idempotency-id") (%unit)
                 '("ap0" "declared-machine-configuration-id")
                 (%str "fake-model-configuration-0")
                 '("ap0" "resolved-machine-configuration-id")
                 (%str "fake-model-configuration-0")
                 '("ap0" "route-id") (%str "fake-route-0")
                 '("ap0" "seed") (%int (%machine-seed machine))
                 '("ap0" "bounded-unknowns") (make-sequence-datum '())))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "request-capture")
                 '("ap0" "request-envelope-id") (%str (%mid machine "req"))
                 '("ap0" "capture-mode") (%str "binary")
                 '("ap0" "payload-octet-count")
                 (%int (+ 32 (%machine-seed machine)))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "exposure-event")
                 '("ap0" "exposure-id") (%str (%mid machine "exp"))
                 '("ap0" "provider-principal") (%str "fake-provider-0")
                 '("ap0" "invoker-exposed") (%bool t)
                 '("ap0" "mode") (%str "direct")
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))))
    (setf (%machine-prepared machine) t)))

(defun %op-dispatch (machine)
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "dispatch-record")
                 '("ap0" "dispatch-id") (%str (%mid machine "dsp"))
                 '("ap0" "prepared-id") (%str (format nil "prep-~a-01" leaf))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 '("ap0" "adapter-identity")
                 (%str (%machine-adapter-identity machine))
                 '("ap0" "frontier-id") (%str "fake-frontier-0")
                 '("ap0" "crossing-evidence") (%str (%mid machine "crossing"))
                 ;; AP-ID-3: the provider request identity is NOT minted at
                 ;; dispatch; under the acknowledgment timing class it is
                 ;; unavailable here and recorded as such.
                 '("ap0" "provider-request-id") (%unit)
                 '("ap0" "provider-request-id-standing")
                 (%str "pending-acknowledgment")))
    (setf (%machine-dispatched machine) t)))

(defun %op-ack (machine)
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "acknowledgment")
                 '("ap0" "acknowledgment-id") (%str (%mid machine "ack"))
                 '("ap0" "ack-class") (%str "provider-received")
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 ;; Learned from provider testimony at the acknowledgment
                 ;; site — a LATER FACT, never inserted retroactively into
                 ;; the prepared record (AP-ID-10 discipline).
                 '("ap0" "provider-request-id")
                 (%str (format nil "pr-~a-1" leaf))
                 '("ap0" "provider-request-source") (%str "acknowledgment-field")
                 '("ap0" "raw-evidence-id") (%str (%mid machine "ackev"))
                 '("ap0" "witness-boundary") (%str "fake-provider-boundary")
                 '("ap0" "witness-procedure-id") (%str "fake-ack-procedure-0")
                 '("ap0" "validation-standing") (%str "validated")
                 '("ap0" "frontier-crossing-established") (%bool t)))
    (setf (%machine-acknowledged machine) t)))

(defun %op-chunk (machine sequence-number)
  (let* ((leaf (%machine-script-leaf machine))
         (order (if (eq (%machine-mutation machine) :delivery-before-journal)
                    "delivery-before-journal"
                    "journal-before-delivery"))
         (record
           (%rec '("ap0" "record-kind") (%id "record" "stream-chunk")
                 '("ap0" "stream-id") (%str (format nil "st-~a-1" leaf))
                 '("ap0" "chunk-id") (%str (%mid machine "chk"))
                 '("ap0" "sequence-number") (%int sequence-number)
                 '("ap0" "payload-id")
                 (%str (format nil "chunk-payload-~a-~a" leaf sequence-number))
                 '("ap0" "payload-octet-count")
                 (%int (+ (%machine-seed machine) sequence-number))
                 '("ap0" "adapter-identity")
                 (%str (%machine-adapter-identity machine))
                 '("ap0" "persistence-order") (%str order))))
    ;; §10.5 guard, the machine's own: an undeclared delivery-before-
    ;; journal path is refused, not recorded.  This is the seam the
    ;; planted :DELIVERY-BEFORE-JOURNAL defect must be killed by.
    (when (string= order "delivery-before-journal")
      (signal-ap0 'stream-persistence-order-invalid
                  :requirement-id "AP0-§10.5"
                  :frontier-crossed t
                  :identities (list (format nil "st-~a-1" leaf))
                  :detail "chunk custody claims delivery before journal ~
                           with no declared loss window; the reference ~
                           lawful path journals before delivery"))
    (%emit machine record)
    (push sequence-number (%machine-chunks machine))))

(defun %op-cancel (machine)
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "cancellation")
                 '("ap0" "cancellation-id") (%str (%mid machine "can"))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 '("ap0" "requested-scope") (%str "whole-request")
                 '("ap0" "acknowledgment-class") (%str "no-acknowledgment")
                 ;; AP-CAN-1/AP-CAN-4: requested, not settled; residual
                 ;; effects remain possible; partials are preserved.
                 '("ap0" "settlement") (%str "unsettled")
                 '("ap0" "residual-effects-possible") (%bool t)
                 '("ap0" "partials-preserved") (%bool t)))
    (setf (%machine-cancelled machine) t)))

(defun %op-capture-envelope (machine)
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "provider-envelope")
                 '("ap0" "envelope-id") (%str (%mid machine "env"))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 '("ap0" "adapter-identity")
                 (%str (%machine-adapter-identity machine))
                 '("ap0" "adapter-version")
                 (%str (%machine-adapter-version machine))
                 '("ap0" "boundary-class") (%id "boundary" "fake")
                 '("ap0" "raw-payload-id")
                 (%str (format nil "raw-payload-~a" leaf))
                 '("ap0" "raw-payload-octet-count")
                 (%int (+ 64 (%machine-seed machine)))
                 '("ap0" "capture-mode") (%str "binary")
                 '("ap0" "content-type") (%str "application/x-fake-envelope")
                 '("ap0" "provider-status") (%int 200)
                 '("ap0" "integrity-evidence") (%str (%mid machine "envint"))))
    (setf (%machine-envelope machine) t)))

(defun %op-project (machine shape-leaf)
  ;; The projection references the captured envelope and names the
  ;; absence-table row applied (AP-ABS-1: the table, never improvisation).
  (unless (%machine-envelope machine)
    (signal-ap0 'provider-envelope-missing
                :requirement-id "AP-ENV-4"
                :frontier-crossed t
                :detail "projection ordered before any envelope capture"))
  (let* ((leaf (%machine-script-leaf machine))
         (row (absence-row-for-shape shape-leaf)))
    (unless row
      (signal-ap0 'absence-mapping-table-miss
                  :requirement-id "AP-ABS-1"
                  :frontier-crossed t
                  :identities (list shape-leaf)
                  :detail "scripted shape is outside the identified table"))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "projection-receipt")
                 '("ap0" "projection-receipt-id") (%str (%mid machine "prj"))
                 '("ap0" "envelope-id")
                 (%str (format nil "env-~a-~2,'0d" leaf
                               ;; the envelope step is the only prior
                               ;; capture; its ordinal is recoverable from
                               ;; the emitted record, but the receipt binds
                               ;; the envelope by its payload identity too.
                               (- (%machine-ordinal machine) 1)))
                 '("ap0" "raw-payload-id")
                 (%str (format nil "raw-payload-~a" leaf))
                 '("ap0" "procedure-id") (%str "fake-projector-0")
                 '("ap0" "procedure-version") (%int 0)
                 '("ap0" "parser-id") (%str "fake-projector-0")
                 '("ap0" "absence-mapping-table-id")
                 (%str "fake-absence-map-0")
                 '("ap0" "absence-row") (%str (%id-leaf row "row-id"))
                 '("ap0" "shape") (%str shape-leaf)
                 '("ap0" "kernel-manifestation-status")
                 (%str (absence-row-status row))
                 '("ap0" "no-payload-state")
                 (let ((state (absence-row-state row)))
                   (if state (%str state) (%unit)))
                 '("ap0" "output-origin") (%str "derived")))
    (setf (%machine-projection-row machine) row)))

(defun %op-reconcile-completed (machine)
  (let ((leaf (%machine-script-leaf machine)))
    (%emit machine
           (%rec '("ap0" "record-kind") (%id "record" "reconciliation")
                 '("ap0" "reconciliation-id") (%str (%mid machine "rec"))
                 '("ap0" "local-request-id") (%str (format nil "lr-~a-1" leaf))
                 ;; Provider request identity learned at the reconciliation
                 ;; site (timing class reconciliation-only).
                 '("ap0" "provider-request-id")
                 (%str (format nil "pr-~a-rec" leaf))
                 '("ap0" "provider-request-source")
                 (%str "reconciliation-response-field")
                 '("ap0" "result") (%str "completed")
                 '("ap0" "settles-no-effect") (%bool nil)
                 '("ap0" "procedure-id") (%str "fake-reconcile-procedure-0")))
    (setf (%machine-reconciled machine) :completed)))

(defun %fold-terminal (machine)
  "AP-CRASH-1: the terminal is derived from surviving records only."
  (let ((row (%machine-projection-row machine)))
    (cond
      ((eq (%machine-reconciled machine) :completed) "completed")
      (row
       (if (%machine-crashed machine)
           "projected-unconsumed"
           (let ((status (absence-row-status row))
                 (state (absence-row-state row)))
             (if (and state (string= status "absent")) state status))))
      ((and (%machine-envelope machine) (%machine-crashed machine))
       "captured-unprojected")
      ((and (%machine-chunks machine)
            (or (%machine-crashed machine) (%machine-cancelled machine)))
       ;; AP-STR-6/7: captured chunks with no lawful terminal settlement.
       "present-partial")
      ((and (%machine-dispatched machine) (%machine-crashed machine))
       "unresolved-effect")
      (t "no-terminal"))))

(defun run-script (script &key mutation)
  "Execute SCRIPT (a canonical script record) deterministically.
Returns a SCRIPT-RUN.  MUTATION is the planted-defect seam
(:DELIVERY-BEFORE-JOURNAL) — the machine's own custody guard must refuse
it (the mutant is killed by a typed signal, not by a wrong record)."
  (let* ((descriptor-leaf (%id-leaf script "adapter-descriptor-id"))
         (descriptor (descriptor-by-identity descriptor-leaf))
         (machine (make-%machine
                   :script-leaf (script-id-string script)
                   :seed (case-integer script "seed")
                   :descriptor descriptor
                   :adapter-identity descriptor-leaf
                   :adapter-version (and descriptor
                                         (descriptor-adapter-version
                                          descriptor))
                   :mutation mutation)))
    (unless descriptor
      (signal-ap0 'adapter-descriptor-invalid
                  :requirement-id "AP-DESC-2"
                  :frontier-crossed nil
                  :identities (list descriptor-leaf)
                  :detail "script names an unknown adapter descriptor"))
    (dolist (step (%script-steps script))
      (setf (%machine-ordinal machine) (case-integer step "ordinal"))
      (let ((operation (%id-leaf step "on-operation")))
        (cond
          ((equal operation "prepare") (%op-prepare machine))
          ((equal operation "dispatch") (%op-dispatch machine))
          ((equal operation "ack") (%op-ack machine))
          ((equal operation "capture-envelope") (%op-capture-envelope machine))
          ((equal operation "project") (%op-project machine "nonempty"))
          ((equal operation "project-empty")
           (%op-project machine "empty-string"))
          ((equal operation "project-invalid")
           (%op-project machine "invalid-utf8"))
          ((equal operation "project-absent") (%op-project machine "missing"))
          ((equal operation "cancel") (%op-cancel machine))
          ((equal operation "reconcile-completed")
           (%op-reconcile-completed machine))
          ((equal operation "kill") (setf (%machine-crashed machine) t))
          ((and (> (length operation) 6)
                (string= "chunk-" (subseq operation 0 6)))
           (%op-chunk machine (parse-integer (subseq operation 6))))
          (t (signal-ap0 'adapter-descriptor-invalid
                         :requirement-id "AP0-§19"
                         :identities (list operation)
                         :detail "unknown scripted operation")))))
    (let* ((records (reverse (%machine-records machine)))
           (trail (apply #'concatenate '(vector (unsigned-byte 8))
                         (loop for record in records
                               collect (encode-pjs0 record)
                               collect (vector 10)))))
      (%make-script-run (%fold-terminal machine)
                        records
                        (sha256-hex trail)
                        (and (%machine-crashed machine) t)))))
