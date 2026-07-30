;;;; schema.lisp — explicit bootstrap authority, the two authority events,
;;;; and exact canonical equality.
;;;;
;;;; Core objects, smallest exact canonical forms (owner's charge):
;;;;   bootstrap authority — an EXPLICIT declared configuration value handed
;;;;     to the fold/query procedures by the caller: an issuer identifier +
;;;;     the store's derived identity string.  Never smuggled.
;;;;   grant event / revocation event — CD/0-typed PJ-S/0 records journaled
;;;;     through journal0's public APPEND-EVENT.  A grant names at least:
;;;;     subject, action, resource, scope, issuer, capability identity — and
;;;;     its own event identity IS the grant event identity.
;;;;   equality — EXACT canonical CD/0 equality: byte-equality of the
;;;;     canonical PJ-S/0 encodings (journal0's ENCODE-PJS0).  No wildcards,
;;;;     no semantic implication, no role hierarchies, no pattern languages,
;;;;     no policy evaluation.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

;;; ---------------------------------------------------------------------------
;;; Exact canonical equality.

(defun ensure-identifier (value &key (what "identifier"))
  "VALUE as a CD/0 identifier datum.  Accepts an identifier datum or a
non-empty list of host strings (segments).  Anything else is refused."
  (cond ((lisp-plus-cd0:identifier-datum-p value) value)
        ((and (consp value) (every #'stringp value))
         (identifier-from-segments value))
        (t (error 'cap0-malformed-authority-event
                  :requirement-id "CAP0-SCHEMA-1"
                  :missing-field what
                  :detail (format nil "~a must be a CD/0 identifier or a ~
                                       list of string segments" what)))))

(defun datum= (left right)
  "EXACT canonical CD/0 equality: both non-NIL and their canonical PJ-S/0
encodings are byte-identical.  This is the ONLY equality this lane uses —
(id \"a:b\") and (id \"a\" \"b\") are distinct here, because their canonical
encodings differ."
  (and left right
       (let ((a (encode-pjs0 left))
             (b (encode-pjs0 right)))
         (and (= (length a) (length b))
              (loop for index below (length a)
                    always (= (aref a index) (aref b index)))))))

;;; ---------------------------------------------------------------------------
;;; Bootstrap authority — explicit, declared, never smuggled.

(defstruct bootstrap-authority
  issuer     ; CD/0 identifier datum — the one root issuer this fold grounds
  store-id)  ; string — the derived store identity this declaration binds to

(defun declare-bootstrap-authority (issuer store-id)
  "Construct an explicit bootstrap authority.  ISSUER is an identifier datum
or a list of string segments; STORE-ID is the store's derived identity
string (journal0's JOURNAL-STORE-STORE-ID / STORE-ID-STRING rendering).
This value must be HANDED to every fold/query call — the procedures refuse
to derive anything without it (%CHECK-BOOTSTRAP)."
  (make-bootstrap-authority
   :issuer (ensure-identifier issuer :what "bootstrap issuer")
   :store-id (progn
               (unless (stringp store-id)
                 (error 'cap0-bootstrap-missing
                        :requirement-id "CAP0-BOOT-1"
                        :detail "bootstrap store binding must be the derived ~
                                 store identity string"))
               store-id)))

(defun %check-bootstrap (store bootstrap)
  "The no-smuggling gate.  Refuses NIL / non-bootstrap values
(CAP0-BOOTSTRAP-MISSING) and a bootstrap bound to a different store identity
(CAP0-BOOTSTRAP-STORE-MISMATCH).  Called by every derivation entry point."
  (unless (bootstrap-authority-p bootstrap)
    (error 'cap0-bootstrap-missing
           :requirement-id "CAP0-BOOT-1"
           :detail "no explicit bootstrap authority was supplied; the fold ~
                    derives nothing from ambient identity"))
  (unless (lisp-plus-cd0:identifier-datum-p (bootstrap-authority-issuer
                                             bootstrap))
    (error 'cap0-bootstrap-missing
           :requirement-id "CAP0-BOOT-1"
           :detail "bootstrap issuer is not a CD/0 identifier"))
  (let ((declared (bootstrap-authority-store-id bootstrap))
        (actual (journal-store-store-id store)))
    (unless (and (stringp declared) (string= declared actual))
      (error 'cap0-bootstrap-store-mismatch
             :requirement-id "CAP0-BOOT-2"
             :expected declared
             :actual actual
             :detail "the declared bootstrap binds a different store identity")))
  bootstrap)

;;; ---------------------------------------------------------------------------
;;; Event constructors.  These build CD/0 records; committing them is the
;;; caller's act, through journal0's public APPEND-EVENT and nothing else.

(defun %field (segments value)
  (lisp-plus-cd0:make-record-entry (identifier-from-segments segments) value))

(defvar +grant-kind+ '("capability0" "granted"))
(defvar +revocation-kind+ '("capability0" "revoked"))

(defun make-grant-event (&key event-id capability-id subject action resource
                              scope issuer)
  "A capability grant event (kind (id \"capability0\" \"granted\")).
Every argument is an identifier datum or a list of string segments; all are
required.  The event's own EVENT-ID is the grant event identity."
  (lisp-plus-cd0:make-record-datum
   (list
    (%field '("event" "event-id") (ensure-identifier event-id
                                                     :what "event-id"))
    (%field '("event" "kind") (identifier-from-segments +grant-kind+))
    (%field '("capability" "capability-id")
            (ensure-identifier capability-id :what "capability-id"))
    (%field '("capability" "subject") (ensure-identifier subject
                                                         :what "subject"))
    (%field '("capability" "action") (ensure-identifier action
                                                        :what "action"))
    (%field '("capability" "resource") (ensure-identifier resource
                                                          :what "resource"))
    (%field '("capability" "scope") (ensure-identifier scope :what "scope"))
    (%field '("capability" "issuer") (ensure-identifier issuer
                                                        :what "issuer")))))

(defun make-revocation-event (&key event-id capability-id issuer)
  "A capability revocation event (kind (id \"capability0\" \"revoked\")).
Revocation is by EXACT capability identity only: no wall-clock expiry, no
leases, no patterns, no recursive delegation invalidation."
  (lisp-plus-cd0:make-record-datum
   (list
    (%field '("event" "event-id") (ensure-identifier event-id
                                                     :what "event-id"))
    (%field '("event" "kind") (identifier-from-segments +revocation-kind+))
    (%field '("revocation" "capability-id")
            (ensure-identifier capability-id :what "capability-id"))
    (%field '("revocation" "issuer") (ensure-identifier issuer
                                                        :what "issuer")))))
