;;;; specimen-common.lisp — shared ground for de-potestate-revocata.
;;;;
;;;; "Concerning the revoked power."  Three processes participate: the
;;;; ORCHESTRATOR (run-specimen.lisp — supervises, preserves artifacts,
;;;; relays verdicts; it never derives authority itself), the PRIMA VITA
;;;; (stage-first-life.lisp — grants, queries, preserves the receipt,
;;;; revokes, then EXITS: its process memory is gone), and the REDIVIVUS
;;;; (stage-restart.lisp — a genuinely new process that may consult ONLY
;;;; durable bytes plus the declared configuration in this file).
;;;;
;;;; This file carries exactly what all three are ENTITLED to share: the
;;;; DECLARED configuration (store nonce, durability, the bootstrap issuer,
;;;; the expected store identity DERIVED from that configuration and not
;;;; from any live store) and the DECLARED charge (which events the store
;;;; is supposed to contain).  It carries no state derived from the dead
;;;; process.  A restart that reads this file learns what the operation was
;;;; SUPPOSED to be — never what it managed to do.
;;;;
;;;; All journal operations go through the exported public surface of
;;;; #:lisp-plus-capability0 and (through it) #:lisp-plus-journal0.  Raw
;;;; octet I/O below is the specimen's own; it is used only to inspect and
;;;; copy artifact BYTES, never to write a frame.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability0)

;;; ---------------------------------------------------------------------------
;;; Own octet I/O (specimen-side; deliberately not the store's internals).

(defun sp-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun sp-write-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream))
  pathname)

(defun sp-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun sp-octets-string (octets)
  (map 'string #'code-char octets))

;;; ---------------------------------------------------------------------------
;;; Declared configuration (the same for every process in the specimen).

;;; PJ-META-1 DEVIATION, declared exactly as journal0's de-teste-occiso
;;; declared it: a real store MUST carry >= 128 UNPREDICTABLE nonce bits.
;;; This specimen fixes the nonce so that the store identity — and
;;; therefore every digest printed in the capture — is deterministic across
;;; runs.  The store is a test fixture and is never a production identity.
(defvar *specimen-nonce* (sp-ascii "de-potestate-rev"))   ; exactly 16 octets

(defvar *specimen-durability* "synced")

;;; The declared bootstrap issuer — the one root authority of this world.
(defvar *specimen-issuer* '("cap0-issuer" "radix"))

;;; The EXPECTED store identity, derived from the DECLARED configuration
;;; alone (metadata rebuilt from the fixed nonce + durability, through
;;; journal0's public metadata surface) — NOT read from any live store.
;;; This is what makes the restart's bootstrap a declared-configuration
;;; binding rather than a tautology copied off the store it is checking.
(defun expected-store-id ()
  (lisp-plus-journal0:store-id-string
   (lisp-plus-journal0:validate-metadata-octets
    (lisp-plus-journal0:render-metadata-octets
     (lisp-plus-journal0:build-metadata-record
      :declared-durability *specimen-durability*
      :nonce-octets *specimen-nonce*)))))

(defun specimen-bootstrap ()
  "The explicit bootstrap authority every derivation in this specimen is
handed: declared issuer + declared (derived-from-config) store binding."
  (declare-bootstrap-authority *specimen-issuer* (expected-store-id)))

;;; ---------------------------------------------------------------------------
;;; The declared charge.

(defvar *capability-segments* '("cap" "clavis-arcae"))
(defvar *subject-segments* '("subj" "tardigrada"))
(defvar *action-segments* '("act" "aperire"))
(defvar *resource-segments* '("res" "arca-prima"))
(defvar *scope-segments* '("scope" "exact"))

(defun charged-grant ()
  (make-grant-event :event-id '("cap0-event" "g-001")
                    :capability-id *capability-segments*
                    :subject *subject-segments*
                    :action *action-segments*
                    :resource *resource-segments*
                    :scope *scope-segments*
                    :issuer *specimen-issuer*))

(defun charged-unrelated ()
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments '("cap0-event" "u-001")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments '("de-potestate" "noted")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "body"))
          (lisp-plus-cd0:make-string-datum
           "the world turned; authority did not")))))

(defun charged-revocation ()
  (make-revocation-event :event-id '("cap0-event" "r-001")
                         :capability-id *capability-segments*
                         :issuer *specimen-issuer*))

(defun charged-query (store bootstrap query-name &rest overrides)
  (apply #'query-live-authority store bootstrap
         :query-id (list "cap0-query" query-name)
         (append overrides
                 (list :capability-id *capability-segments*
                       :subject *subject-segments*
                       :action *action-segments*
                       :resource *resource-segments*
                       :scope *scope-segments*))))

;;; ---------------------------------------------------------------------------
;;; Paths (root-relative; every process is executed from the latent-lisp
;;; root).  Stage children receive their paths in argv and never print them.

(defvar *specimen-root* #p"mneme/capability0/de-potestate-revocata/")
(defvar *scratch-store* (merge-pathnames "scratch-store/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))

;;; The preserved receipt: the PRIMA VITA writes the canonical bytes of its
;;; prefix-P authorization receipt here; the ORCHESTRATOR digests it before
;;; and after the restart; the REDIVIVUS reads it back as durable bytes.
(defvar *receipt-channel* (merge-pathnames "RECEIPT-AT-P.pjs" *scratch-run*))
