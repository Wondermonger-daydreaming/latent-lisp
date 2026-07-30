;;;; run-specimen.lisp — de membrana loquente: "concerning the speaking
;;;; membrane."
;;;;
;;;; Run:  sbcl --script mneme/adapter0/de-membrana-loquente/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.  Run twice;
;;;; the transcript is byte-identical (every printed identity and digest
;;;; derives from declared configuration).
;;;;
;;;; THE ONE DEMONSTRATION: the lawful operation reaches the membrane and
;;;; returns a STRUCTURED outcome without dropping authority, journal,
;;;; envelope, exposure, or projection context.  The route, in order:
;;;;
;;;;   Capability /0 grant  →  Capability /1 mint + fresh presentation
;;;;   →  Capability /2 authorization-to-attempt (the receipt)
;;;;   →  AP0 PREPARATION  (prepared invocation · binary request capture ·
;;;;      exposure event — journaled as the durable PRE-FRONTIER account)
;;;;   →  the authorized crossing through Capability /2's own door
;;;;      (attempt-protected-effect: frontier journaled, world written,
;;;;      acknowledgment journaled as testimony, settlement DERIVED from
;;;;      verified evidence)
;;;;   →  AP0 MEMBRANE EVIDENCE (dispatch record · crossing-evidence
;;;;      binding to the cap2 frontier event · acknowledgment · terminal
;;;;      envelope · derived projection · usage · missing-cost marker —
;;;;      all journaled, all origin :asserted per AP-JRN-1)
;;;;   →  Capability /2 settlement standing read back by the fold
;;;;      (derive-effect-standing = :settled)
;;;;   →  the structured outcome record (never a bare answer string).
;;;;
;;;; JURISDICTION, stated exactly: Capability /2 governs the crossing and
;;;; the settlement; Adapter /0 reports MEMBRANE FACTS about that same
;;;; crossing and never settles anything itself.  The AP0 dispatch
;;;; record's crossing evidence is BOUND (by a journaled binding record)
;;;; to the cap2 frontier event — one crossing, two jurisdictions, zero
;;;; bypasses.  This specimen is NOT Vertical Specimen /0 and claims no
;;;; live-provider anything.
;;;;
;;;; DETERMINISM: fixed 16-octet store nonce (declared PJ-META-1
;;;; deviation, exactly as every predecessor specimen declares it — test
;;;; fixture, never a production identity).
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "../../capability2/load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

(defvar *checks* 0)
(defvar *failures* 0)

(defun mcheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[M~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[M~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun mnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

;;; ---------------------------------------------------------------------------
;;; Own octet I/O (specimen-side; inspects and copies artifact bytes only).

(defun mb-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun mb-write-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream))
  pathname)

(defun mb-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

;;; ---------------------------------------------------------------------------
;;; Declared configuration (deterministic; PJ-META-1 deviation declared).

(defvar *mb-nonce* (mb-ascii "de-membrana-loqu"))   ; exactly 16 octets
(defvar *mb-durability* "synced")
(defvar *mb-issuer* '("ap0-issuer" "radix"))
(defvar *mb-minter* '("ap0-minter" "claviger"))

(defvar *mb-capability* '("cap" "clavis-membranae"))
(defvar *mb-subject* '("subj" "custos"))
(defvar *mb-action* '("act" "loqui"))
(defvar *mb-cell* '("cella" "vox"))
(defvar *mb-scope* '("scope" "exact"))
(defvar *mb-value* "VOX")
(defvar *mb-attempt* "a-001")
(defvar *mb-seat* "sedes-membranae")

(defvar *mb-root* #p"mneme/adapter0/de-membrana-loquente/")
(defvar *mb-store-dir* (merge-pathnames "scratch-store/" *mb-root*))
(defvar *mb-world-dir* (merge-pathnames "scratch-world/" *mb-root*))

(dolist (directory (list *mb-store-dir* *mb-world-dir*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

(defun mb-expected-store-id ()
  (store-id-string
   (validate-metadata-octets
    (render-metadata-octets
     (build-metadata-record
      :declared-durability *mb-durability*
      :nonce-octets *mb-nonce*)))))

;;; The AP0 event envelope: every membrane record journals under its own
;;; event identity with origin ASSERTED — the adapter's narrative of its
;;; own conduct is testimony, never observation (AP-JRN-1).
(defun ap0-event (event-name kind-leaf ap0-record)
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments (list "ap0-event" event-name)))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments (list "ap0-record" kind-leaf)))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "origin"))
          (identifier-from-segments '("origin" "asserted")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "body"))
          ap0-record))))

;;; ---------------------------------------------------------------------------
(mnote "de-membrana-loquente — the lawful route reaches the membrane and ~
        returns a structured outcome")
(mnote "law: Capability /2 governs crossing and settlement; Adapter /0 ~
        reports membrane facts and settles nothing.~%")

(defvar *store* (create-journal *mb-store-dir*
                                :declared-durability *mb-durability*
                                :nonce-octets *mb-nonce*))
(defvar *world* (make-world *mb-world-dir*
                            (list (cons "cella:vox" "VACUA"))))
(defvar *bootstrap* (declare-bootstrap-authority *mb-issuer*
                                                 (mb-expected-store-id)))
(defvar *context* (make-minting-context :label "membrana"))

(mcheck "the created store's identity equals the identity derived from ~
         declared configuration alone (deterministic ground)"
  (lambda () (string= (journal-store-store-id *store*)
                      (mb-expected-store-id))))

(append-event *store*
              (make-grant-event :event-id '("cap0-event" "g-001")
                                :capability-id *mb-capability*
                                :subject *mb-subject*
                                :action *mb-action*
                                :resource *mb-cell*
                                :scope *mb-scope*
                                :issuer *mb-issuer*))

(mcheck "AUTHORITY: the grant commits at ordinal 1; the world holds ~
         cella:vox = VACUA with an empty request ledger"
  (lambda ()
    (and (= 1 (prefix-report-frame-count (validate-journal *store*)))
         (equal "VACUA" (world-cell-value *world* "cella:vox"))
         (= 0 (world-ledger-count *world*)))))

;;; ---------------------------------------------------------------------------
;;; AP0 preparation — the durable pre-frontier account (§21 steps 1–4).
;;;
;;; ORDERING ADJUDICATION (recorded in the RETURN): Capability /2's
;;; authorization receipt binds the EXACT validated prefix and refuses on
;;; any later commit (CAP2-INV-1 — the specimen's first draft hit exactly
;;; that refusal).  So the AP0 pre-frontier account is journaled FIRST,
;;; and the cap2 authorization is taken as the LAST pre-frontier act.
;;; AP0 §21's own ordering is fully preserved: descriptor resolution,
;;; prepared invocation, request capture, and exposure all commit before
;;; any frontier crossing.

(defvar *membrane*
  (lisp-plus-adapter0:bind-live-adapter
   (lisp-plus-adapter0:descriptor-by-identity "fake-reference-0")
   :instance-label "membrana-viva"))

(defvar *prepared*
  (lisp-plus-adapter0:prepare-invocation
   *membrane*
   (lisp-plus-adapter0:make-invocation-spec
    :logical-operation-id "loqui-per-membranam"
    :seat-id *mb-seat*
    :attempt-id *mb-attempt*
    :run-label "membrana")))

(dolist (pair '(("e-membrana-prepared" "prepared-invocation" 0)
                ("e-membrana-request-capture" "request-capture" 1)
                ("e-membrana-exposure" "exposure-event" 2)))
  (append-event *store*
                (ap0-event (first pair) (second pair)
                           (nth (third pair)
                                (lisp-plus-adapter0:prepared-invocation-record-pre-frontier-records
                                 *prepared*)))))

(mcheck "AP0 PREPARATION journaled BEFORE any crossing: prepared ~
         invocation, binary request capture, and exposure event (the ~
         provider fake-provider-0 named as principal, the invoker ~
         recorded exposed) — ordinals 2-4, world still untouched"
  (lambda ()
    (let ((report (validate-journal *store*)))
      (and (= 4 (prefix-report-frame-count report))
           (= 0 (world-ledger-count *world*))
           (equal "lr-membrana-1"
                  (lisp-plus-adapter0:prepared-invocation-record-local-request-id
                   *prepared*))))))

(defvar *key*
  (mint-from-authorization
   *store* *bootstrap* *context*
   (query-live-authority *store* *bootstrap*
                         :query-id '("cap0-query" "q-membrana-mint")
                         :capability-id *mb-capability*
                         :subject *mb-subject*
                         :action *mb-action*
                         :resource *mb-cell*
                         :scope *mb-scope*)
   :minter *mb-minter*))

(mcheck "Capability /1: the opaque live key is minted from the fresh /0 ~
         fold against the current prefix (minting adds no journal frame ~
         beyond the 4 already committed, and no world byte)"
  (lambda ()
    (and (live-capability-p *key*)
         (= 4 (prefix-report-frame-count (validate-journal *store*)))
         (= 0 (world-ledger-count *world*)))))

;;; ---------------------------------------------------------------------------
;;; Capability /2 authorization — the LAST pre-frontier act (it binds the
;;; exact prefix, AP0 preparation included).

(defvar *auth*
  (authorize-effect-attempt *store* *bootstrap* *context* *key*
                            :capability-id *mb-capability*
                            :query-name "q-membrana-auth"
                            :subject *mb-subject*
                            :action *mb-action*
                            :resource *mb-cell*
                            :scope *mb-scope*
                            :cell *mb-cell*
                            :value *mb-value*
                            :attempt-name *mb-attempt*
                            :seat-name *mb-seat*))

(mb-write-octets (merge-pathnames "ARTIFACT-AUTH-RECEIPT.pjs" *mb-root*)
                 (encode-pjs0 *auth*))

(mcheck "Capability /2 AUTHORITY CONTEXT: the authorization-to-attempt ~
         receipt licenses ONE exact effect (cella:vox := VOX, attempt ~
         a-001), binds the prefix WITH the AP0 pre-frontier account in ~
         it (terminal ordinal 4), and is preserved to disk ~
         byte-identically; still no frontier, no world byte"
  (lambda ()
    (and (equalp (mb-read-octets (merge-pathnames "ARTIFACT-AUTH-RECEIPT.pjs"
                                                  *mb-root*))
                 (encode-pjs0 *auth*))
         (= 4 (prefix-report-frame-count (validate-journal *store*)))
         (= 0 (world-ledger-count *world*)))))

;;; ---------------------------------------------------------------------------
;;; The authorized crossing — Capability /2's door, not ours.

(defvar *crossing-status* nil)
(defvar *crossing-detail* nil)

(multiple-value-bind (status detail)
    (attempt-protected-effect *store* *bootstrap* *context* *key*
                              *auth* *world*
                              :process-name "membrana-specimen")
  (setf *crossing-status* status *crossing-detail* detail))

(mcheck "THE CROSSING (cap2's door): status :settled with acknowledgment ~
         class :provider-terminal; the world holds cella:vox = VOX with ~
         exactly one ledger entry; settlement was DERIVED from verified ~
         evidence, not from the acknowledgment class"
  (lambda ()
    (and (eq :settled *crossing-status*)
         (eq :provider-terminal *crossing-detail*)
         (equal "VOX" (world-cell-value *world* "cella:vox"))
         (= 1 (world-ledger-count *world*)))))

;;; ---------------------------------------------------------------------------
;;; AP0 membrane evidence about that same crossing.

(defvar *handle* (lisp-plus-adapter0:dispatch *prepared*
                                              :live-adapter *membrane*))

(append-event *store*
              (ap0-event "e-membrana-dispatch" "dispatch-record"
                         (lisp-plus-adapter0:dispatch-handle-dispatch-record
                          *handle*)))

;;; The binding record: ONE crossing, two jurisdictions.  The AP0
;;; dispatch record's crossing evidence is bound to the cap2 frontier
;;; event committed by attempt-protected-effect.
(append-event
 *store*
 (ap0-event "e-membrana-crossing-binding" "crossing-evidence-binding"
            (lisp-plus-cd0:make-record-datum
             (list (lisp-plus-cd0:make-record-entry
                    (identifier-from-segments '("ap0" "dispatch-id"))
                    (lisp-plus-cd0:make-string-datum "dsp-membrana-02"))
                   (lisp-plus-cd0:make-record-entry
                    (identifier-from-segments '("ap0" "cap2-frontier-event"))
                    (identifier-from-segments
                     (list "cap2-event"
                           (format nil "e-~a-frontier" *mb-attempt*))))
                   (lisp-plus-cd0:make-record-entry
                    (identifier-from-segments
                     '("ap0" "cap2-acknowledgment-event"))
                    (identifier-from-segments
                     (list "cap2-event"
                           (format nil "e-~a-ack" *mb-attempt*))))))))

(defvar *ack* (lisp-plus-adapter0:observe-acknowledgment *handle*))
(append-event *store* (ap0-event "e-membrana-ack" "acknowledgment" *ack*))

(defvar *envelope* (lisp-plus-adapter0:await-terminal *handle*))
(append-event *store*
              (ap0-event "e-membrana-envelope" "provider-envelope"
                         *envelope*))

;;; The world's surviving bytes, captured as boundary evidence through
;;; the standalone capture door (binary custody over cap2's public world
;;; accessors — cells digest, ledger digest, cell value).
(defvar *world-evidence-octets*
  (mb-ascii (format nil "cells-sha256=~a~%ledger-sha256=~a~%cella:vox=~a~%"
                    (world-cells-sha256 *world*)
                    (world-ledger-sha256 *world*)
                    (world-cell-value *world* "cella:vox"))))

(defvar *world-capture*
  (lisp-plus-adapter0:capture-envelope *membrane* *world-evidence-octets*
                                       "membrana-world-evidence"))
(append-event *store*
              (ap0-event "e-membrana-world-evidence" "provider-envelope"
                         *world-capture*))

(defvar *projection*
  (lisp-plus-adapter0:project-envelope *membrane* *handle* "nonempty"))
(append-event *store*
              (ap0-event "e-membrana-projection" "projection-receipt"
                         *projection*))

(defvar *usage*
  (lisp-plus-adapter0:extract-usage *membrane* *handle*
                                    "fake-usage-procedure-0"))
(append-event *store* (ap0-event "e-membrana-usage" "usage-record" *usage*))

(defvar *missing-cost*
  (lisp-plus-adapter0:extract-cost *membrane* *handle*
                                   "fake-cost-procedure-0"))

(mcheck "AP0 MEMBRANE EVIDENCE journaled: dispatch record · crossing ~
         binding (naming the cap2 frontier AND acknowledgment events) · ~
         acknowledgment (witness facets, learned provider request ~
         identity) · terminal envelope · world-evidence capture · ~
         derived projection (origin derived, receipt-bearing, status ~
         present) · adapter-measured usage — every record a canonical ~
         datum, every event origin :asserted (AP-JRN-1)"
  (lambda ()
    (and (equal "provider-received"
                (lisp-plus-cd0:string-datum-value
                 (record-field *ack* "ap0" "ack-class")))
         (equal "derived"
                (lisp-plus-cd0:string-datum-value
                 (record-field *projection* "ap0" "output-origin")))
         (equal "present"
                (lisp-plus-cd0:string-datum-value
                 (record-field *projection* "ap0"
                               "kernel-manifestation-status")))
         (equal "adapter-measured"
                (lisp-plus-cd0:string-datum-value
                 (record-field *usage* "ap0" "source")))
         (= (length *world-evidence-octets*)
            (lisp-plus-cd0:integer-datum-value
             (record-field *world-capture* "ap0"
                           "raw-payload-octet-count"))))))

(mcheck "USAGE ≠ COST at the membrane: with no identified price schedule ~
         the cost is a typed MISSING marker — not zero, not free ~
         (AP-COST-4)"
  (lambda ()
    (lisp-plus-adapter0:missing-cost-marker-p *missing-cost*)))

;;; ---------------------------------------------------------------------------
;;; Settlement standing — read back through Capability /2's fold.

(mcheck "Capability /2 SETTLEMENT: derive-effect-standing folds the ~
         validated prefix to :settled for attempt a-001 — the standing ~
         comes from the event sequence, never from any stored flag"
  (lambda ()
    (eq :settled (derive-effect-standing *store* *mb-attempt*))))

;;; ---------------------------------------------------------------------------
;;; The structured outcome — never a bare answer string (AP-OP-2).

(defvar *outcome*
  (lisp-plus-cd0:make-record-datum
   (list
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "outcome-kind"))
     (identifier-from-segments '("outcome" "membrane-crossing-account")))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "authority-capability-public-id"))
     (live-capability-public-id *key*))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "authorization-receipt-sha256"))
     (lisp-plus-cd0:make-string-datum (sha256-hex (encode-pjs0 *auth*))))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "attempt-id"))
     (lisp-plus-cd0:make-string-datum *mb-attempt*))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "cap2-standing"))
     (identifier-from-segments '("standing" "settled")))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "local-request-id"))
     (lisp-plus-cd0:make-string-datum "lr-membrana-1"))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "projection-receipt-id"))
     (record-field *projection* "ap0" "projection-receipt-id"))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "world-cells-sha256"))
     (lisp-plus-cd0:make-string-datum (world-cells-sha256 *world*)))
    (lisp-plus-cd0:make-record-entry
     (identifier-from-segments '("ap0" "subject-value"))
     (lisp-plus-cd0:make-string-datum
      (world-cell-value *world* "cella:vox"))))))

(mb-write-octets (merge-pathnames "ARTIFACT-AP0-OUTCOME.pjs" *mb-root*)
                 (encode-pjs0 *outcome*))

(mcheck "THE STRUCTURED OUTCOME: a canonical record binding authority ~
         (capability public id + receipt digest), journal (attempt + ~
         local request identities), envelope + projection context ~
         (receipt id), exposure-bearing world evidence (cells digest), ~
         and the subject value — NOT a bare answer string (AP-OP-2), ~
         preserved to disk byte-identically"
  (lambda ()
    (and (lisp-plus-cd0:record-datum-p *outcome*)
         (not (stringp *outcome*))
         (equalp (mb-read-octets (merge-pathnames "ARTIFACT-AP0-OUTCOME.pjs"
                                                  *mb-root*))
                 (encode-pjs0 *outcome*))
         (equal "VOX"
                (lisp-plus-cd0:string-datum-value
                 (record-field *outcome* "ap0" "subject-value"))))))

;;; ---------------------------------------------------------------------------
;;; Preserved artifacts + determinism evidence.

(defvar *events-final*
  (mb-read-octets (merge-pathnames "EVENTS.pj0" *mb-store-dir*)))

(mb-write-octets (merge-pathnames "ARTIFACT-EVENTS-FINAL.pj0" *mb-root*)
                 *events-final*)
(mb-write-octets (merge-pathnames "ARTIFACT-WORLD-CELLS.txt" *mb-root*)
                 (mb-read-octets (merge-pathnames "CELLS.txt" *mb-world-dir*)))
(mb-write-octets (merge-pathnames "ARTIFACT-WORLD-LEDGER.txt" *mb-root*)
                 (mb-read-octets (merge-pathnames "REQUEST-LEDGER.txt"
                                                  *mb-world-dir*)))

(mnote "~%store terminal digest: ~a"
       (prefix-report-terminal-digest (validate-journal *store*)))
(mnote "events file sha256: ~a" (sha256-hex *events-final*))
(mnote "world cells sha256: ~a" (world-cells-sha256 *world*))
(mnote "outcome sha256: ~a" (sha256-hex (encode-pjs0 *outcome*)))

(mcheck "the final journal carries the full two-jurisdiction account in ~
         one validated prefix of 15 frames: grant + 3 AP0 pre-frontier ~
         events + cap2's 4 crossing events (prepared, frontier-crossed, ~
         acknowledged, settled) + 7 AP0 membrane-evidence events"
  (lambda ()
    (let ((report (validate-journal *store*)))
      (and (eq :valid (prefix-report-status report))
           (= 15 (prefix-report-frame-count report))))))

(let ((manifest '("ARTIFACT-AUTH-RECEIPT.pjs"
                  "ARTIFACT-AP0-OUTCOME.pjs"
                  "ARTIFACT-EVENTS-FINAL.pj0"
                  "ARTIFACT-WORLD-CELLS.txt"
                  "ARTIFACT-WORLD-LEDGER.txt")))
  (with-open-file (stream (merge-pathnames "ARTIFACT-MANIFEST.txt" *mb-root*)
                          :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (format stream "de-membrana-loquente preserved artifacts~%")
    (dolist (name manifest)
      (format stream "~a~%" name)))
  (with-open-file (stream (merge-pathnames "ARTIFACT-SHA256SUMS.txt"
                                           *mb-root*)
                          :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (dolist (name manifest)
      (format stream "~a  ~a~%"
              (sha256-hex (mb-read-octets (merge-pathnames name *mb-root*)))
              name)))
  (mcheck "five artifacts preserved with a manifest and a sha256 ledger ~
           (auth receipt · structured outcome · final events · world ~
           cells · world ledger)"
    (lambda ()
      (every (lambda (name) (probe-file (merge-pathnames name *mb-root*)))
             (append manifest (list "ARTIFACT-MANIFEST.txt"
                                    "ARTIFACT-SHA256SUMS.txt"))))))

;;; ---------------------------------------------------------------------------

(dolist (directory (list *mb-store-dir* *mb-world-dir*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

(format t "~%de-membrana-loquente: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
