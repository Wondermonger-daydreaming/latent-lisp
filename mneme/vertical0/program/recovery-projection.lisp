;;;; recovery-projection.lisp — vertical-recovery-projection-0 (contract
;;;; §5 W3).
;;;;
;;;; Adapter /0's own PROJECT-ENVELOPE requires the process-local dispatch
;;;; handle — which lawfully DIED with the process.  The recovery
;;;; projection is therefore a declared vertical-local procedure
;;;; ("vertical-recovery-projection-0", version 0): it consumes the
;;;; CAPTURED OCTETS (the durable evidence file, integrity-checked against
;;;; the journaled sha256 binding) plus the PUBLIC absence-table accessors,
;;;; and emits a projection record with output-origin "derived" binding the
;;;; original envelope identity and payload sha256.  It never re-contacts
;;;; the provider, never fabricates payload from memory (there is no
;;;; memory), and never claims semantic truth — structure only.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun vertical-recovery-projection-0 (captured-octets shape-leaf
                                       &key seat-id envelope-id
                                            expected-sha256)
  "Project the captured envelope octets under SHAPE-LEAF.
Returns the vertical projection record.  Hard-refuses on: sha256 mismatch
against EXPECTED-SHA256 (the journaled custody binding), an undecodable
capture, or a shape outside the identified absence table."
  (let ((actual-sha (sha256-hex captured-octets)))
    (unless (string= actual-sha expected-sha256)
      (error "recovery projection: captured octets sha256 ~a does not ~
              match the journaled custody binding ~a (seat ~a)"
             actual-sha expected-sha256 seat-id))
    ;; The captured octets are the canonical encoding of the terminal
    ;; envelope record; decode to verify the binding, never to invent
    ;; payload.
    (multiple-value-bind (decoded status) (decode-pjs0 captured-octets)
      (unless (and decoded (eq :canonical status))
        (error "recovery projection: captured octets do not decode ~
                canonical (seat ~a, status ~a)" seat-id status))
      (let ((decoded-envelope-id (body-string decoded "ap0" "envelope-id")))
        (unless (equal decoded-envelope-id envelope-id)
          (error "recovery projection: captured envelope id ~a does not ~
                  match the journaled binding ~a" decoded-envelope-id
                 envelope-id))))
    (let ((row (absence-row-for-shape shape-leaf)))
      (unless row
        (error "recovery projection: shape ~a is outside the identified ~
                absence table (AP-ABS-1: refuse, never improvise)"
               shape-leaf))
      (v-rec '("vertical" "record-kind")
             (v-id "record" "recovery-projection-receipt")
             '("vertical" "projection-receipt-id")
             (v-str (format nil "vrp-~a" seat-id))
             '("vertical" "seat-id") (v-str seat-id)
             '("vertical" "envelope-id") (v-str envelope-id)
             '("vertical" "raw-payload-sha256") (v-str actual-sha)
             '("vertical" "raw-payload-octet-count")
             (v-int (length captured-octets))
             '("vertical" "procedure-id")
             (v-str "vertical-recovery-projection-0")
             '("vertical" "procedure-version") (v-int 0)
             '("vertical" "shape") (v-str shape-leaf)
             '("vertical" "kernel-manifestation-status")
             (v-str (absence-row-status row))
             '("vertical" "no-payload-state")
             (let ((state (absence-row-state row)))
               (if state (v-str state) (lisp-plus-cd0:make-unit-datum)))
             '("vertical" "output-origin") (v-str "derived")))))
