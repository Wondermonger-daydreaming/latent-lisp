;;;; specimen-common.lisp — shared ground for de-teste-occiso.
;;;;
;;;; "Concerning the killed witness."  Three processes participate: the
;;;; ESTABLISHER (run-specimen.lisp, which also supervises the kill), the
;;;; OCCISUS (stage-writer-child.lisp — charged with one append, then killed
;;;; by SIGKILL at a governed progress point), and the SUPERSTES
;;;; (stage-recover.lisp — a genuinely new process that may consult ONLY
;;;; durable store bytes plus declared configuration).
;;;;
;;;; This file carries exactly what all three are ENTITLED to share: the
;;;; declared charge (which events the store is supposed to contain) and the
;;;; declared store configuration.  It carries no state derived from the
;;;; killed process.  A recovery that reads this file learns what the
;;;; operation was SUPPOSED to be — never what it managed to do.
;;;;
;;;; All journal operations in this specimen go through the exported §22
;;;; surface of #:lisp-plus-journal0 (create-journal, open-store,
;;;; validate-journal, append-event, find-event, salvage-valid-prefix,
;;;; reconstruct, derive-seat-resolution, explain-journal).  Raw octet I/O
;;;; below is the specimen's own; it is used only to inspect and copy
;;;; artifact BYTES, never to write a frame.
;;;;
;;;; — SUPERSTES (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; Own octet I/O (specimen-side; deliberately not the store's internals).

(defun so-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun so-write-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream))
  pathname)

(defun so-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun so-octets-string (octets)
  (map 'string #'code-char octets))

;;; ---------------------------------------------------------------------------
;;; Declared configuration (the same for every process in the specimen).

;;; PJ-META-1 DEVIATION, declared: a real store MUST carry >= 128
;;; UNPREDICTABLE nonce bits.  This specimen fixes the nonce so that the
;;; store identity — and therefore every byte of every artifact and every
;;; digest printed in the capture — is deterministic across runs.  The store
;;; is a test fixture and is never a production identity.
(defvar *specimen-nonce* (so-ascii "de-teste-occiso!"))   ; exactly 16 octets

;;; A distinct fixed nonce for the CW-0 control store, so that its derived
;;; store identity differs from the primary store's and no reader can confuse
;;; the two exhibits.
(defvar *control-nonce* (so-ascii "de-teste-occiso-cw0!"))

(defvar *specimen-durability* "synced")

;;; ---------------------------------------------------------------------------
;;; The declared charge.
;;;
;;; Events 1..3 are established durably by the ESTABLISHER before any kill.
;;; Event 4 is the one the OCCISUS is charged to append and dies over.  The
;;; SUPERSTES rebuilds the candidate for event 4 FROM THIS DECLARATION, the
;;; way an idempotent client rebuilds a retry from its own charge — it does
;;; not inherit it from the dead process, which left no such record.

(defun specimen-event (id-string body-string)
  "A canonicalizable §9.1 event record.  Deterministic: no timestamps, no
pids, no host state."
  (flet ((field (key value)
           (lisp-plus-cd0:make-record-entry (identifier-from-segments key)
                                            value)))
    (lisp-plus-cd0:make-record-datum
     (list (field '("event" "event-id")
                  (identifier-from-segments (list "event" id-string)))
           (field '("event" "kind")
                  (identifier-from-segments '("de-teste-occiso" "noted")))
           (field '("event" "body")
                  (lisp-plus-cd0:make-string-datum body-string))))))

(defvar *established-charge*
  '(("e-001" . "the first thing the writer lived through")
    ("e-002" . "the second thing the writer lived through")
    ("e-003" . "the third thing the writer lived through")))

(defvar *fatal-charge* '("e-004" . "the thing the writer died over"))

(defun established-events ()
  (loop for (id . body) in *established-charge* collect (specimen-event id body)))

(defun fatal-event ()
  (specimen-event (car *fatal-charge*) (cdr *fatal-charge*)))

(defun conflicting-fatal-event ()
  "Same event identity, DIFFERENT payload — the unsafe blind retry."
  (specimen-event (car *fatal-charge*) "a DIFFERENT story about the same event"))

(defun uncharged-event-id ()
  "An identity the journal never committed and never proposed durably."
  (identifier-from-segments '("event" "e-005")))

;;; ---------------------------------------------------------------------------
;;; Paths (root-relative; every process is executed from the latent-lisp root).

(defvar *specimen-root* #p"mneme/journal0/de-teste-occiso/")
(defvar *scratch-store* (merge-pathnames "scratch-store/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))
(defvar *scratch-torn* (merge-pathnames "scratch-torn/" *specimen-root*))
(defvar *scratch-mutated* (merge-pathnames "scratch-mutated/" *specimen-root*))
(defvar *scratch-controls* (merge-pathnames "scratch-controls/" *specimen-root*))

;;; The kill-supervision channel.  BARRIER-PASSED is a bare progress marker
;;; with ZERO coordinate content (no ordinal, no digest, no event id): it
;;; tells the supervisor only "the append call has returned", never what it
;;; returned.  RECEIPT.txt is where the OCCISUS would have DELIVERED its
;;; receipt; the child is killed before it can ever be written, and its
;;; absence is the specimen's proof that no receipt reached the caller.
(defvar *barrier-sentinel* (merge-pathnames "BARRIER-PASSED" *scratch-run*))
(defvar *receipt-channel* (merge-pathnames "RECEIPT.txt" *scratch-run*))
(defvar +barrier-sentinel-bytes+ "BARRIER-PASSED
")
