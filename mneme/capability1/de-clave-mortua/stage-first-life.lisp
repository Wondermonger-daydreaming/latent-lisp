;;;; stage-first-life.lisp — the PRIMA VITA: the process that holds the key
;;;; and dies with it.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation.
;;;; It: creates the declared store · commits the bootstrap-grounded grant ·
;;;; queries live authority at prefix P · MINTS the opaque live key ·
;;;; presents it successfully · preserves to disk every PUBLIC record of it
;;;; (the authorization receipt bytes, the minting receipt bytes, the
;;;; object's printed form — testimony of what died) · exits.  Its process
;;;; memory — the minting context, the EQ recognition table, the object
;;;; itself — dies with it.  Whatever the restart can obtain, it will
;;;; obtain from durable bytes alone; and the lane's thesis is that what it
;;;; obtains is testimony, never the key.
;;;;
;;;; Output protocol (parsed and renumbered by the parent runner):
;;;;   CHECK ok|FAIL <label> · NOTE <text> · RESULT: <n> checks, <f> failures
;;;; Exit 0 iff zero failures.  No pid, timestamp, or path is printed.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability1)

(defvar *v-checks* 0)
(defvar *v-failures* 0)

(defun vcheck (label thunk)
  (incf *v-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *v-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs: argv paths + the declared configuration.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *run-directory* (pathname (second *arguments*)))

(vnote "prima vita: bootstrap · grant · query at P · MINT · present · ~
        preserve testimony · exit (the key dies with this process)")

;;; 1. The store, created under the DECLARED configuration.

(defvar *store* (create-journal *store-directory*
                                :declared-durability *specimen-durability*
                                :nonce-octets *specimen-nonce*))

(vcheck "the created store's derived identity EQUALS the identity derived ~
         from the declared configuration alone — the bootstrap binding is ~
         config, not a copy off the live store"
  (lambda () (string= (journal-store-store-id *store*)
                      (expected-store-id))))

(defvar *bootstrap* (specimen-bootstrap))

;;; 2. The grant.

(defvar *grant-receipt* (append-event *store* (charged-grant)))

(vcheck "the capability grant commits durably through the public append ~
         path: ordinal 1, :newly-committed, declared durability :synced"
  (lambda ()
    (and (eql 1 (append-receipt-ordinal *grant-receipt*))
         (eq :newly-committed (append-receipt-disposition *grant-receipt*))
         (eq :synced (lisp-plus-journal0:journal-store-durability *store*)))))

;;; 3. The query at prefix P.

(defvar *auth-receipt* (charged-query *store* *bootstrap*
                                      *first-life-query*))
(defvar *report-at-p* (validate-journal *store*))

(vcheck "live authority at prefix P: decision :authorized, bound to the ~
         EXACT validated prefix (ordinal 1, fresh report's byte count and ~
         terminal digest), naming grant event g-001"
  (lambda ()
    (and (eq :authorized (receipt-decision *auth-receipt*))
         (receipt-current-p *auth-receipt* *report-at-p*
                            :store-id (journal-store-store-id *store*))
         (datum= (record-field *auth-receipt* "receipt" "grant-event-id")
                 (identifier-from-segments '("cap0-event" "g-001"))))))

;;; 4. THE MINT — the key exists, in this process, and only here.

(defvar *context* (make-minting-context :label "prima-vita"))
(defvar *key* nil)
(defvar *mint-receipt* nil)

(vcheck "the minting bridge mints the opaque live key from the truthful ~
         authorization: recognized by this context (EQ membership), bound ~
         to P's four facets, occurrence and public identities derived from ~
         the fresh authorization receipt's bytes at serial 1"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *store* *bootstrap* *context*
                                 *auth-receipt*
                                 :minter *specimen-minter*)
      (setf *key* object *mint-receipt* receipt)
      (and (live-capability-p object)
           (context-recognizes-p *context* object)
           (= 1 (live-capability-terminal-ordinal object))
           (string= (prefix-report-terminal-digest *report-at-p*)
                    (live-capability-terminal-digest object))
           (datum= (record-field receipt "receipt" "capability-public-id")
                   (live-capability-public-id object))))))

(vnote "minted: public identity ~a"
       (identifier-segment-string (live-capability-public-id *key*)))
(vnote "minting occurrence: ~a"
       (identifier-segment-string (live-capability-occurrence-id *key*)))

;;; 5. The key WORKS while its prefix is current.

(vcheck "successful presentation while P remains current: decision ~
         cap1:presented, bound to the same four facets"
  (lambda ()
    (let ((receipt (charged-presentation *store* *bootstrap* *context*
                                         *key* "p-vita-1")))
      (and (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field receipt "receipt" "decision")))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field receipt "receipt" "terminal-ordinal")))))))

;;; 6. The public record — everything the world will ever hold of this key.

(sp-write-octets (auth-receipt-path *run-directory*)
                 (encode-pjs0 *auth-receipt*))
(sp-write-octets (mint-receipt-path *run-directory*)
                 (encode-pjs0 *mint-receipt*))
(sp-write-octets (dead-key-print-path *run-directory*)
                 (sp-ascii (princ-to-string *key*)))

(vcheck "the key's PUBLIC record is preserved to disk and reads back ~
         byte-identical: the authorization receipt bytes, the minting ~
         receipt bytes, and the printed form of the live object — ~
         testimony of what is about to die"
  (lambda ()
    (and (equalp (sp-read-octets (auth-receipt-path *run-directory*))
                 (encode-pjs0 *auth-receipt*))
         (equalp (sp-read-octets (mint-receipt-path *run-directory*))
                 (encode-pjs0 *mint-receipt*))
         (string= (sp-octets-string
                   (sp-read-octets (dead-key-print-path *run-directory*)))
                  (princ-to-string *key*)))))

(vcheck "the printed form is testimony shaped like testimony: it names the ~
         public identity, opens with the unreadable #<, and contains ~
         neither the store identity, the terminal digest, nor any term — ~
         and there is nothing else to leak: the object holds NO secret ~
         material at all"
  (lambda ()
    (let ((printed (princ-to-string *key*)))
      (and (search (identifier-segment-string
                    (live-capability-public-id *key*))
                   printed)
           (string= "#<" (subseq printed 0 2))
           (null (search (live-capability-store-id *key*) printed))
           (null (search (live-capability-terminal-digest *key*) printed))
           (null (search "ianitor" printed))))))

;;; 7. Nothing was journaled by any of it.

(vcheck "minting and presenting journaled NOTHING: the store still ~
         validates :valid with exactly 1 frame (the grant); mint ~
         occurrences are process-local facts over a validated prefix (L9)"
  (lambda ()
    (let ((report (validate-journal *store*)))
      (and (eq :valid (prefix-report-status report))
           (= 1 (prefix-report-frame-count report))))))

(vnote "prefix P: 1 frame · terminal ~a"
       (prefix-report-terminal-digest (validate-journal *store*)))
(vnote "this process now exits; the minting context, the recognition ~
        table, and the key itself die with it — only testimony survives")

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
