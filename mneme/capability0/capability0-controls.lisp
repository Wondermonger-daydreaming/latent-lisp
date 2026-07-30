;;;; capability0-controls.lisp — the twelve laws EXECUTED, plus the negative
;;;; controls.  Every law's check would FAIL if the law were broken; every
;;;; negative control proves the INTENDED predicate fired — the typed
;;;; condition or decision with its identifying fields, never "some error
;;;; occurred".
;;;;
;;;; Run:  sbcl --script mneme/capability0/capability0-controls.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: fixed store nonces (declared PJ-META-1 deviation; test
;;;; fixtures, never production identities); no timestamps, pids, or
;;;; absolute paths printed.  Two runs produce byte-identical transcripts.
;;;;
;;;; GATE TEETH: CAP0_CONTROLS_PLANT_FAULT=1 plants one false check;
;;;; CAP0_CONTROLS_DIE=1 kills the run before any verdict and before the
;;;; RESULT sentinel.  This runner spawns itself once under each variable
;;;; and asserts the fault fires / the truncation is detectable.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability0)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery — counts derived from verdicts rendered.

(defvar *checks* 0)
(defvar *failures* 0)

(defun ccheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun cnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defmacro expects (condition-type &body body)
  `(handler-case (progn ,@body nil)
     (,condition-type () t)
     (error () nil)))

(defun c-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun c-write-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream))
  pathname)

(defun c-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun c-octets-string (octets)
  (map 'string #'code-char octets))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defun events-sha (directory)
  (sha256-hex (c-read-octets (merge-pathnames "EVENTS.pj0" directory))))

;;; ---------------------------------------------------------------------------
;;; GATE TEETH hook: a child dies HERE, before any verdict and before the
;;; RESULT sentinel (the runner-truncation negative control's subject).

(when (sb-posix:getenv "CAP0_CONTROLS_DIE")
  (cnote "child control: dying mid-run before any verdict (planted)")
  (sb-ext:exit :code 3))

;;; ---------------------------------------------------------------------------
;;; Shared declared vocabulary.

(defvar *issuer* '("cap0-issuer" "radix"))
(defvar *scratch* #p"mneme/capability0/scratch-controls/")
(fresh-directory *scratch*)

(defun grant (event-name capability-name &key (subject "tardigrada"))
  (make-grant-event :event-id (list "cap0-event" event-name)
                    :capability-id (list "cap" capability-name)
                    :subject (list "subj" subject)
                    :action '("act" "aperire")
                    :resource '("res" "arca-prima")
                    :scope '("scope" "exact")
                    :issuer *issuer*))

(defun revocation (event-name capability-name)
  (make-revocation-event :event-id (list "cap0-event" event-name)
                         :capability-id (list "cap" capability-name)
                         :issuer *issuer*))

(defun unrelated (event-name body)
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments (list "cap0-event" event-name)))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments '("de-potestate" "noted")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "body"))
          (lisp-plus-cd0:make-string-datum body)))))

(defun ask (store bootstrap capability-name query-name &rest overrides)
  (apply #'query-live-authority store bootstrap
         :query-id (list "cap0-query" query-name)
         (append overrides
                 (list :capability-id (list "cap" capability-name)
                       :subject '("subj" "tardigrada")
                       :action '("act" "aperire")
                       :resource '("res" "arca-prima")
                       :scope '("scope" "exact")))))

(cnote "capability0-controls — the laws executed, the controls fired")
(cnote "governing sentence: history may prove that authority once existed; ~
        only the validated present prefix can say whether it remains live.~%")

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE A — the inhabited vertical, laws 1–8 and the term controls.

(cnote "== store A: grant · query · unrelated · sibling · revocation ==")

(defvar *a-directory* (merge-pathnames "store-a/" *scratch*))
(defvar *a* (create-journal *a-directory*
                            :nonce-octets (c-ascii "cap0-controls-aa")))
(defvar *boot-a* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *a*)))

;;; --- bootstrap controls (the no-smuggling proofs) --------------------------

(ccheck "NC-13a — query with NO bootstrap authority refuses with ~
         cap0-bootstrap-missing: the fold derives nothing from ambient ~
         identity, package internals, or the fact that a constructor ran"
  (lambda ()
    (expects cap0-bootstrap-missing
      (ask *a* nil "clavis" "q-noboot"))))

(ccheck "NC-13b — a bootstrap bound to a DIFFERENT store identity refuses ~
         with cap0-bootstrap-store-mismatch naming expected and actual"
  (lambda ()
    (handler-case
        (progn (ask *a* (declare-bootstrap-authority
                         *issuer*
                         "pj0-store:0000000000000000")
                    "clavis" "q-wrongstore")
               nil)
      (cap0-bootstrap-store-mismatch (condition)
        (and (string= "pj0-store:0000000000000000"
                      (cap0-bootstrap-store-mismatch-expected condition))
             (string= (journal-store-store-id *a*)
                      (cap0-bootstrap-store-mismatch-actual condition)))))))

;;; --- the grant and the receipt at P ----------------------------------------

(defvar *grant-a* (grant "g-a01" "clavis"))
(defvar *grant-a-receipt* (append-event *a* *grant-a*))

(ccheck "the grant commits through journal0's public append path at ~
         ordinal 1, :newly-committed"
  (lambda ()
    (and (eql 1 (append-receipt-ordinal *grant-a-receipt*))
         (eq :newly-committed
             (append-receipt-disposition *grant-a-receipt*)))))

(ccheck "NC-13c — a bootstrap naming a DIFFERENT root issuer makes the fold ~
         refuse with kernel0's MINTING-AUTHORITY-INVALID: the committed ~
         grant names an issuer that bootstrap does not ground"
  (lambda ()
    (expects lisp-plus-kernel0:minting-authority-invalid
      (ask *a* (declare-bootstrap-authority '("cap0-issuer" "usurpator")
                                            (journal-store-store-id *a*))
           "clavis" "q-usurper"))))

(defvar *receipt-at-p* (ask *a* *boot-a* "clavis" "q-at-p"))
(defvar *prefix-p-report* (validate-journal *a*))

(ccheck "LAW 4 — the authorization receipt at prefix P binds to the EXACT ~
         validated prefix: store-id, terminal ordinal (1), valid byte ~
         count, and terminal digest all equal the fresh prefix-report; the ~
         binding is content-derived, never a label, commit, pathname, or ~
         process-local object"
  (lambda ()
    (and (eq :authorized (receipt-decision *receipt-at-p*))
         (receipt-current-p *receipt-at-p* *prefix-p-report*
                            :store-id (journal-store-store-id *a*))
         (= 1 (lisp-plus-cd0:integer-datum-value
               (record-field *receipt-at-p* "receipt" "terminal-ordinal")))
         (string= (prefix-report-terminal-digest *prefix-p-report*)
                  (lisp-plus-cd0:string-datum-value
                   (record-field *receipt-at-p* "receipt"
                                 "terminal-digest"))))))

(cnote "receipt at P: ordinal 1 · terminal ~a"
       (prefix-report-terminal-digest *prefix-p-report*))

;;; --- term controls (each names the mismatch) --------------------------------

(ccheck "NC-1 — wrong SUBJECT refuses: decision :refused, reason ~
         capability-scope-mismatch, mismatched-terms exactly (\"subject\"), ~
         and the escalated kernel0 condition carries offending-field ~
         \"subject\""
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-nc1"
                        :subject '("subj" "alienus"))))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-scope-mismatch" (receipt-reason receipt))
           (equal '("subject") (receipt-mismatched-terms receipt))
           (handler-case
               (progn (require-live-authority
                       *a* *boot-a*
                       :capability-id '("cap" "clavis")
                       :subject '("subj" "alienus")
                       :action '("act" "aperire")
                       :resource '("res" "arca-prima")
                       :scope '("scope" "exact")
                       :query-id '("cap0-query" "q-nc1e"))
                      nil)
             (lisp-plus-kernel0:capability-scope-mismatch (condition)
               (string= "subject"
                        (lisp-plus-kernel0:kernel0-condition-offending-field
                         condition))))))))

(ccheck "NC-2 — wrong ACTION refuses with mismatched-terms exactly ~
         (\"action\")"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-nc2"
                        :action '("act" "claudere"))))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-scope-mismatch" (receipt-reason receipt))
           (equal '("action") (receipt-mismatched-terms receipt))))))

(ccheck "NC-3 — wrong RESOURCE refuses with mismatched-terms exactly ~
         (\"resource\")"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-nc3"
                        :resource '("res" "arca-secunda"))))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-scope-mismatch" (receipt-reason receipt))
           (equal '("resource") (receipt-mismatched-terms receipt))))))

(ccheck "NC-4 — wrong CAPABILITY IDENTITY refuses: reason ~
         capability-missing (no matching grant), and the escalation is ~
         kernel0's CAPABILITY-MISSING exactly"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "ignotum" "q-nc4")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-missing" (receipt-reason receipt))
           (expects lisp-plus-kernel0:capability-missing
             (require-live-authority *a* *boot-a*
                                     :capability-id '("cap" "ignotum")
                                     :subject '("subj" "tardigrada")
                                     :action '("act" "aperire")
                                     :resource '("res" "arca-prima")
                                     :scope '("scope" "exact")
                                     :query-id '("cap0-query" "q-nc4e")))))))

;;; --- unrelated event at P+1 --------------------------------------------------

(append-event *a* (unrelated "u-a01" "the world turned, authority did not"))

(ccheck "LAW 6 — an UNRELATED committed event does not revoke: at prefix ~
         P+1 the same query is still :authorized"
  (lambda ()
    (eq :authorized (receipt-decision (ask *a* *boot-a* "clavis" "q-p1")))))

(ccheck "LAW 5 (detection half) — the receipt issued at P is NOT current at ~
         P+1: receipt-current-p is false and names the changed facets ~
         (terminal-ordinal, valid-byte-count, terminal-digest)"
  (lambda ()
    (multiple-value-bind (currentp mismatches)
        (receipt-current-p *receipt-at-p* (validate-journal *a*)
                           :store-id (journal-store-store-id *a*))
      (and (not currentp)
           (equal mismatches '("terminal-ordinal" "valid-byte-count"
                               "terminal-digest"))))))

(ccheck "LAW 12 — the query is NOT an effect executor: EVENTS.pj0 is ~
         byte-identical (sha256) across an authorized query and an ~
         escalated refusal; recognizing authority executes nothing"
  (lambda ()
    (let ((before (events-sha *a-directory*)))
      (ask *a* *boot-a* "clavis" "q-ro")
      (expects lisp-plus-kernel0:capability-missing
        (require-live-authority *a* *boot-a*
                                :capability-id '("cap" "ignotum")
                                :subject '("subj" "tardigrada")
                                :action '("act" "aperire")
                                :resource '("res" "arca-prima")
                                :scope '("scope" "exact")
                                :query-id '("cap0-query" "q-ro2")))
      (string= before (events-sha *a-directory*)))))

;;; --- sibling capability + its revocation -------------------------------------

(append-event *a* (grant "g-a02" "sigillum"))
(append-event *a* (revocation "r-b01" "sigillum"))

(ccheck "LAW 7 / NC-6 — revoking the SIBLING capability (cap:sigillum) ~
         leaves cap:clavis :authorized and cap:sigillum :refused ~
         capability-revoked — revocation is by exact capability identity, ~
         nothing else"
  (lambda ()
    (let ((clavis (ask *a* *boot-a* "clavis" "q-sib1"))
          (sigillum (ask *a* *boot-a* "sigillum" "q-sib2")))
      (and (eq :authorized (receipt-decision clavis))
           (eq :refused (receipt-decision sigillum))
           (string= "capability-revoked" (receipt-reason sigillum))))))

;;; --- the matching revocation --------------------------------------------------

(append-event *a* (revocation "r-a01" "clavis"))

(ccheck "the matching revocation commits and the query becomes a governed ~
         refusal: decision :refused, reason capability-revoked, naming BOTH ~
         the historical grant event (g-a01) and the revoking event (r-a01)"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-revoked")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-a01")))
           (datum= (record-field receipt "receipt" "revoking-event-id")
                   (identifier-from-segments '("cap0-event" "r-a01")))))))

(ccheck "LAW 1 — the grant event did NOT mutate into a revocation: after ~
         the revocation commits, find-event locates g-a01 at ordinal 1 with ~
         payload BYTE-IDENTICAL to the canonical grant encoding"
  (lambda ()
    (multiple-value-bind (ordinal frame-digest payload)
        (find-event *a* (identifier-from-segments '("cap0-event" "g-a01")))
      (and (eql 1 ordinal)
           (stringp frame-digest)
           (equalp payload (encode-pjs0 *grant-a*))))))

(ccheck "LAW 2 — the revocation did NOT erase the historical grant: the ~
         fold-derived history of cap:clavis shows grant ordinal 1 (g-a01) ~
         AND revocation ordinal 5 (r-a01), both visible at once"
  (lambda ()
    (let ((record (capability-history *a* *boot-a* '("cap" "clavis"))))
      (and record
           (eql 1 (capability-record-grant-ordinal record))
           (datum= (capability-record-grant-event-id record)
                   (identifier-from-segments '("cap0-event" "g-a01")))
           (eql 5 (capability-record-revocation-ordinal record))
           (datum= (capability-record-revocation-event-id record)
                   (identifier-from-segments '("cap0-event" "r-a01")))))))

;;; --- law 8: the two second-revocation cases, explicitly distinguished --------

(ccheck "LAW 8a — a SECOND revocation (DIFFERENT event identity r-a02, same ~
         target) commits as history (frame count grows by 1) but receives ~
         the precise disposition :already-revoked naming the ORIGINAL ~
         revoking event r-a01 — never a fresh state transition; the ~
         refusal's revoking-event-id remains r-a01"
  (lambda ()
    (let ((frames-before (prefix-report-frame-count (validate-journal *a*))))
      (append-event *a* (revocation "r-a02" "clavis"))
      (let ((record (capability-history *a* *boot-a* '("cap" "clavis")))
            (receipt (ask *a* *boot-a* "clavis" "q-second-rev"))
            (frames-after (prefix-report-frame-count
                           (validate-journal *a*))))
        (and (= frames-after (1+ frames-before))
             ;; the ORIGINAL transition is untouched...
             (eql 5 (capability-record-revocation-ordinal record))
             (datum= (capability-record-revocation-event-id record)
                     (identifier-from-segments '("cap0-event" "r-a01")))
             ;; ...and the second event's disposition names it.
             (let ((disposition
                     (find :already-revoked
                           (capability-record-dispositions record)
                           :key (lambda (plist)
                                  (getf plist :disposition)))))
               (and disposition
                    (datum= (getf disposition :event-id)
                            (identifier-from-segments
                             '("cap0-event" "r-a02")))
                    (datum= (getf disposition :original-revocation-event-id)
                            (identifier-from-segments
                             '("cap0-event" "r-a01")))))
             (datum= (record-field receipt "receipt" "revoking-event-id")
                     (identifier-from-segments '("cap0-event" "r-a01"))))))))

(ccheck "LAW 8b — a repeated IDENTICAL revocation event (r-a01, same bytes) ~
         is JOURNAL-IDEMPOTENT: append reconciles ~
         :already-committed-identical at the prior ordinal and the frame ~
         count does not grow (this is journal0's event identity doing the ~
         work; distinguished from 8a's different-event case)"
  (lambda ()
    (let ((frames-before (prefix-report-frame-count (validate-journal *a*)))
          (receipt (append-event *a* (revocation "r-a01" "clavis"))))
      (and (eq :already-committed-identical
               (append-receipt-disposition receipt))
           (eql 5 (append-receipt-ordinal receipt))
           (= frames-before
              (prefix-report-frame-count (validate-journal *a*)))))))

(ccheck "NC-7 — a duplicate GRANT event identity with ALTERED content is ~
         refused by journal0's PJ0-EVENT-IDENTITY-COLLISION (the exact ~
         condition type), zero new bytes"
  (lambda ()
    (let ((before (events-sha *a-directory*)))
      (and (expects lisp-plus-journal0:pj0-event-identity-collision
             (append-event *a* (grant "g-a01" "clavis"
                                      :subject "alienus")))
           (string= before (events-sha *a-directory*))))))

(ccheck "NC-8 — a duplicate REVOCATION event identity with ALTERED content ~
         is refused the same way: PJ0-EVENT-IDENTITY-COLLISION, zero new ~
         bytes"
  (lambda ()
    (let ((before (events-sha *a-directory*)))
      (and (expects lisp-plus-journal0:pj0-event-identity-collision
             (append-event *a* (make-revocation-event
                                :event-id '("cap0-event" "r-a01")
                                :capability-id '("cap" "sigillum")
                                :issuer *issuer*)))
           (string= before (events-sha *a-directory*))))))

(ccheck "re-granting a REVOKED identity does not restore it: a new grant ~
         event g-a03 for cap:clavis receives disposition ~
         :grant-of-revoked-identity naming r-a01, the query stays :refused ~
         capability-revoked, and restoration remains reserved to §11.7's ~
         new-identity path (out of this slice, documented)"
  (lambda ()
    (append-event *a* (grant "g-a03" "clavis"))
    (let ((record (capability-history *a* *boot-a* '("cap" "clavis")))
          (receipt (ask *a* *boot-a* "clavis" "q-regrant")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))
           (let ((disposition
                   (find :grant-of-revoked-identity
                         (capability-record-dispositions record)
                         :key (lambda (plist) (getf plist :disposition)))))
             (and disposition
                  (datum= (getf disposition :event-id)
                          (identifier-from-segments '("cap0-event" "g-a03")))
                  (datum= (getf disposition :original-revocation-event-id)
                          (identifier-from-segments
                           '("cap0-event" "r-a01")))))))))

;;; --- law 3: the mutable-status mutants, killed over store A -------------------

(ccheck "LAW 3 (teeth) — the :ignore-revocation mutant is KILLED over ~
         store A: strict refuses (revoked), mutant authorizes"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :ignore-revocation *a* *boot-a*
                         :capability-id '("cap" "clavis")
                         :subject '("subj" "tardigrada")
                         :action '("act" "aperire")
                         :resource '("res" "arca-prima")
                         :scope '("scope" "exact"))
      (and killed (eq :refused (getf strict :decision))
           (eq :authorized (getf mutant :decision))))))

(ccheck "LAW 3 (teeth) — the :cached-status mutant is KILLED: a ledger ~
         cached before a revocation answers :authorized after it; the ~
         strict fold-per-query answers :refused.  Live authority is ~
         fold-derived; there is no status slot to be stale"
  (lambda ()
    (let* ((directory (merge-pathnames "store-f/" *scratch*))
           (store (create-journal directory
                                  :nonce-octets (c-ascii "cap0-controls-ff")))
           (bootstrap (declare-bootstrap-authority
                       *issuer* (journal-store-store-id store))))
      (append-event store (grant "g-f01" "fenestra"))
      (multiple-value-bind (killed strict mutant)
          (run-mutant-kill :cached-status store bootstrap
                           :capability-id '("cap" "fenestra")
                           :subject '("subj" "tardigrada")
                           :action '("act" "aperire")
                           :resource '("res" "arca-prima")
                           :scope '("scope" "exact")
                           :warm-cache-thunk
                           (lambda ()
                             (append-event store
                                           (revocation "r-f01" "fenestra"))))
        (and killed (eq :refused (getf strict :decision))
             (eq :authorized (getf mutant :decision)))))))

(ccheck "LAW 4 (teeth) — the :receipt-unbound-to-prefix mutant is KILLED: ~
         the strict receipt's binding matches the fresh report; the ~
         mutant's genesis-bound receipt fails receipt-current-p"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :receipt-unbound-to-prefix *a* *boot-a*
                         :capability-id '("cap" "clavis")
                         :subject '("subj" "tardigrada")
                         :action '("act" "aperire")
                         :resource '("res" "arca-prima")
                         :scope '("scope" "exact"))
      (and killed (getf strict :binding-current)
           (not (getf mutant :binding-current))))))

;;; --- law 5 / NC-11: the stale receipt, refused by type ------------------------

(ccheck "LAW 5 / NC-11 — the ORIGINAL receipt from prefix P, presented as ~
         PRESENT authority at the later prefix, is refused with ~
         CAP0-STALE-RECEIPT naming BOTH prefixes: the receipt's binding ~
         (ordinal 1) and the present binding (ordinal 7), digests distinct ~
         and both rendered"
  (lambda ()
    (handler-case
        (progn (present-receipt-as-present-authority *a* *boot-a*
                                                     *receipt-at-p*)
               nil)
      (cap0-stale-receipt (condition)
        (let ((receipt-digest (cap0-stale-receipt-receipt-terminal-digest
                               condition))
              (present-digest (cap0-stale-receipt-present-terminal-digest
                               condition)))
          (and (eql 1 (cap0-stale-receipt-receipt-terminal-ordinal
                       condition))
               (eql 7 (cap0-stale-receipt-present-terminal-ordinal
                       condition))
               (stringp receipt-digest) (stringp present-digest)
               (not (string= receipt-digest present-digest))
               (string= (prefix-report-terminal-digest
                         (validate-journal *a*))
                        present-digest)))))))

(ccheck "LAW 5 (still truthful about P) — the stale receipt remains a TRUE ~
         statement about prefix P: its bound terminal digest IS the ~
         store's frame-1 digest; what expired is its claim to the present, ~
         not its truth about the past"
  (lambda ()
    (let ((report (validate-journal *a*)))
      (string= (lisp-plus-cd0:string-datum-value
                (record-field *receipt-at-p* "receipt" "terminal-digest"))
               (aref (prefix-report-frame-digests report) 0)))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE B — NC-5: revocation before grant, and the later grant.

(cnote "~%== store B: revocation-before-grant ==")

(defvar *b-directory* (merge-pathnames "store-b/" *scratch*))
(defvar *b* (create-journal *b-directory*
                            :nonce-octets (c-ascii "cap0-controls-bb")))
(defvar *boot-b* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *b*)))

(ccheck "NC-5a — a revocation committed for a capability NEVER granted ~
         receives the precise disposition :revocation-without-grant; the ~
         query refuses capability-missing and SURFACES the dangling ~
         revocation event identity in the receipt"
  (lambda ()
    (append-event *b* (revocation "r-c01" "custodia"))
    (let ((record (capability-history *b* *boot-b* '("cap" "custodia")))
          (receipt (ask *b* *boot-b* "custodia" "q-dangling")))
      (and record
           (null (capability-record-grant-ordinal record))
           (let ((disposition (first (capability-record-dispositions
                                      record))))
             (and (eq :revocation-without-grant
                      (getf disposition :disposition))
                  (eql 1 (getf disposition :ordinal))))
           (eq :refused (receipt-decision receipt))
           (string= "capability-missing" (receipt-reason receipt))
           (let ((dangling (record-field receipt "receipt"
                                         "dangling-revocation-event-ids")))
             (and dangling
                  (= 1 (lisp-plus-cd0:sequence-datum-length dangling))
                  (datum= (lisp-plus-cd0:sequence-datum-ref dangling 0)
                          (identifier-from-segments
                           '("cap0-event" "r-c01")))))))))

(ccheck "NC-5b — a LATER grant of that identity IS live: revocation is an ~
         act upon existing authority, not a standing prohibition against ~
         future minting (a forward-reaching ban would be policy, out of /0 ~
         scope; documented in the RETURN); the dangling revocation stays ~
         visible as history"
  (lambda ()
    (append-event *b* (grant "g-c01" "custodia"))
    (let ((record (capability-history *b* *boot-b* '("cap" "custodia")))
          (receipt (ask *b* *boot-b* "custodia" "q-after-dangling")))
      (and (eq :authorized (receipt-decision receipt))
           (eql 2 (capability-record-grant-ordinal record))
           (null (capability-record-revocation-ordinal record))
           (eq :revocation-without-grant
               (getf (first (capability-record-dispositions record))
                     :disposition))))))

(ccheck "presenting a CURRENT receipt is not a free pass either: the answer ~
         is RE-DERIVED by a fresh fold over the receipt's terms (the ~
         returned receipt is a new derivation whose decision agrees because ~
         the fold does, not because the card was trusted)"
  (lambda ()
    (let* ((receipt (ask *b* *boot-b* "custodia" "q-present-current"))
           (fresh (present-receipt-as-present-authority *b* *boot-b*
                                                        receipt)))
      (and (eq :authorized (receipt-decision fresh))
           (receipt-current-p fresh (validate-journal *b*)
                              :store-id (journal-store-store-id *b*))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE C/D — LAW 9 / NC-10: the torn-tail revocation.

(cnote "~%== stores C and D: the torn-tail revocation (derived byte state, ~
        labelled derived) ==")

(defvar *c-directory* (merge-pathnames "store-c/" *scratch*))
(defvar *c* (create-journal *c-directory*
                            :nonce-octets (c-ascii "cap0-controls-cc")))
(defvar *boot-c* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *c*)))

(append-event *c* (grant "g-t01" "porta"))
(defvar *c-one-frame-octets*
  (c-read-octets (merge-pathnames "EVENTS.pj0" *c-directory*)))
(append-event *c* (revocation "r-t01" "porta"))
(defvar *c-two-frame-octets*
  (c-read-octets (merge-pathnames "EVENTS.pj0" *c-directory*)))

(defvar *d-directory* (merge-pathnames "store-d/" *scratch*))
(ensure-directories-exist *d-directory*)
(dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
  (c-write-octets (merge-pathnames name *d-directory*)
                  (c-read-octets (merge-pathnames name *c-directory*))))
(c-write-octets (merge-pathnames "EVENTS.pj0" *d-directory*)
                (subseq *c-two-frame-octets*
                        0 (- (length *c-two-frame-octets*) 7)))

(ccheck "LAW 9 / NC-10 — a TORN-TAIL revocation cannot silently revoke: ~
         over the derived store (revocation frame's last 7 octets removed) ~
         the reader classifies :torn-tail with 1 valid frame, the query ~
         answers :authorized from the valid prefix, AND the receipt ~
         SURFACES the excluded tail (offset = valid byte count, tail ~
         sha256 rendered) — the evidence is visible, never buried, never ~
         promoted to a committed revocation"
  (lambda ()
    (let* ((store-d (open-store *d-directory*))
           (boot-d (declare-bootstrap-authority
                    *issuer* (journal-store-store-id store-d)))
           (report (validate-journal store-d))
           (receipt (ask store-d boot-d "porta" "q-torn")))
      (and (eq :torn-tail (prefix-report-status report))
           (= 1 (prefix-report-frame-count report))
           (eq :authorized (receipt-decision receipt))
           (= (prefix-report-tail-offset report)
              (lisp-plus-cd0:integer-datum-value
               (record-field receipt "receipt" "tail-offset")))
           (string= (prefix-report-tail-sha256 report)
                    (lisp-plus-cd0:string-datum-value
                     (record-field receipt "receipt" "tail-sha256")))
           ;; the tail evidence names bytes that ARE the truncated
           ;; revocation frame's prefix — evidence, not commitment.
           (= (prefix-report-tail-offset report)
              (length *c-one-frame-octets*))))))

(ccheck "LAW 9 (contrast that carries it) — the SAME revocation, fully ~
         committed in the source store, DOES revoke: the underived store C ~
         refuses capability-revoked.  Only commitment revokes; a torn tail ~
         is not commitment"
  (lambda ()
    (let ((receipt (ask *c* *boot-c* "porta" "q-committed")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE E — LAW 10 / NC-9: interior corruption refuses liveness outright.

(cnote "~%== store E: interior corruption (derived byte state) ==")

(defvar *e-directory* (merge-pathnames "store-e/" *scratch*))
(defvar *e* (create-journal *e-directory*
                            :nonce-octets (c-ascii "cap0-controls-ee")))
(defvar *boot-e* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *e*)))

(append-event *e* (grant "g-e01" "horreum"))
(append-event *e* (revocation "r-e01" "horreum"))
(append-event *e* (unrelated "u-e01" "one more frame beyond the damage"))

;;; Corrupt ONE payload byte INSIDE frame 2 (the revocation): flip the
;;; first octet of "revoked" (the kind segment unique to frame 2) to "Revoked".
(defvar *e-octets* (c-read-octets (merge-pathnames "EVENTS.pj0"
                                                   *e-directory*)))
(defvar *e-offset* (search (c-ascii "revoked") *e-octets*))
(setf (aref *e-octets* *e-offset*) (char-code #\R))
(c-write-octets (merge-pathnames "EVENTS.pj0" *e-directory*) *e-octets*)

(ccheck "LAW 10 / NC-9 — an INVALID INTERIOR frame prevents authority ~
         derivation past that point, by TYPED REFUSAL and not by silent ~
         truncation-and-answer: the reader classifies :corruption with 1 ~
         valid frame, and the query signals kernel0's ~
         JOURNAL-PREFIX-INVALID instead of answering :authorized from the ~
         pre-corruption prefix (which a truncate-and-answer would do, since ~
         the grant IS in that prefix).  Adjudication: a torn tail was never ~
         a committed event, but interior corruption can conceal COMMITTED ~
         frames beyond it — a revocation could be buried past the damage, ~
         so no liveness claim is bounded (L13); this deliberately diverges ~
         from journal0's reconstruct, which answers HISTORY questions at a ~
         named prefix"
  (lambda ()
    (let* ((store (open-store *e-directory*))
           (bootstrap (declare-bootstrap-authority
                       *issuer* (journal-store-store-id store)))
           (report (validate-journal store)))
      (and (eq :corruption (prefix-report-status report))
           (= 1 (prefix-report-frame-count report))
           (expects lisp-plus-kernel0:journal-prefix-invalid
             (ask store bootstrap "horreum" "q-corrupt"))))))

(ccheck "LAW 10 (teeth for the check itself) — the same query over the ~
         UNCORRUPTED twin bytes would have answered: restoring the ~
         original octet makes the store :valid again and the query a ~
         governed :refused capability-revoked (so the refusal above was ~
         the corruption's doing, not a constant of the harness)"
  (lambda ()
    (setf (aref *e-octets* *e-offset*) (char-code #\r))
    (c-write-octets (merge-pathnames "EVENTS.pj0" *e-directory*) *e-octets*)
    (let* ((store (open-store *e-directory*))
           (report (validate-journal store))
           (receipt (ask store *boot-e* "horreum" "q-restored")))
      (and (eq :valid (prefix-report-status report))
           (= 3 (prefix-report-frame-count report))
           (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; LAW 11 — origin discipline (unit form; the specimen executes the restart).

(ccheck "LAW 11 — a derivation declared :reconstructed renders origin ~
         (id \"origin\" \"reconstructed\") and NO receipt byte sequence ~
         contains \"observed\"; the :observed origin is refused in code ~
         (closed ecase)"
  (lambda ()
    (let ((receipt (ask *b* *boot-b* "custodia" "q-origin"
                        :origin :reconstructed)))
      (and (string= "origin:reconstructed"
                    (identifier-segment-string
                     (record-field receipt "receipt" "origin")))
           (null (search "observed" (c-octets-string
                                     (encode-pjs0 receipt))))
           (expects type-error
             (ask *b* *boot-b* "custodia" "q-observed"
                  :origin :observed))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; GATE TEETH — this runner shown able to fail, and shown detectable when
;;; truncated (NC-12's controls-side form; the specimen has the process form).

(when (sb-posix:getenv "CAP0_CONTROLS_PLANT_FAULT")
  (ccheck "PLANTED FAULT (CAP0_CONTROLS_PLANT_FAULT): this check is false ~
           by construction"
    (lambda () nil)))

(unless (or (sb-posix:getenv "CAP0_CONTROLS_PLANT_FAULT")
            (sb-posix:getenv "CAP0_CONTROLS_DIE"))
  (ccheck "gate teeth (fault) — a child run with a planted fault exits 1 ~
           and its transcript carries the FAIL line: this suite CAN go red"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability0/capability0-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP0_CONTROLS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (ccheck "gate teeth (truncation) / NC-12 — a child killed mid-run before ~
           any verdict exits 3 with NO RESULT sentinel, and the detection ~
           is exactly that pair: an unfinished run must never read as a ~
           clean one"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability0/capability0-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP0_CONTROLS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (null (search "RESULT:" text))
             (search "dying mid-run" text))))))

;;; ---------------------------------------------------------------------------
;;; Teardown + derived result.

(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%capability0-controls: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(format t "laws executed: 1 2 3 4 5 6 7 8a 8b 9 10 11 12 · negative ~
           controls: term/identity mismatches, revocation-before-grant, ~
           sibling revocation, duplicate identities, interior corruption, ~
           torn tail, stale receipt, bootstrap absence/mismatch/usurper, ~
           planted fault, truncated child~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
