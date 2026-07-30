;;;; capability1-controls.lisp — the owner's vertical EXECUTED, plus the
;;;; exact negative controls.  Every control proves its INTENDED predicate —
;;;; the typed condition or decision with its identifying fields, never
;;;; "some error occurred".
;;;;
;;;; Run:  sbcl --script mneme/capability1/capability1-controls.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: fixed store nonces (declared PJ-META-1 deviation; test
;;;; fixtures, never production identities); no timestamps, pids, or
;;;; absolute paths printed.  Two runs produce byte-identical transcripts.
;;;;
;;;; GATE TEETH: CAP1_CONTROLS_PLANT_FAULT=1 plants one false check;
;;;; CAP1_CONTROLS_DIE=1 kills the run before any verdict and before the
;;;; RESULT sentinel.  This runner spawns itself once under each variable
;;;; and asserts the fault fires / the truncation is detectable.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability1)

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

;;; Truncation child hook: die before any verdict, before the sentinel.
(when (sb-posix:getenv "CAP1_CONTROLS_DIE")
  (cnote "child control: dying mid-run before any verdict (planted)")
  (sb-ext:exit :code 3))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defvar *scratch* #p"mneme/capability1/scratch-controls/")
(fresh-directory *scratch*)

(cnote "capability1-controls — the minting-bridge vertical, executed")
(cnote "governing sentence: a receipt may explain why a key was minted; it ~
        is not the key, and its description cannot forge one.~%")

;;; ---------------------------------------------------------------------------
;;; Fixture vocabulary.

(defvar *issuer* '("cap1-issuer" "radix"))
(defvar *minter* '("cap1-minter" "claviger"))
(defvar *subject* '("subj" "ianitor"))
(defvar *action* '("act" "aperire"))
(defvar *resource* '("res" "ianua-prima"))
(defvar *scope* '("scope" "exact"))

(defun grant (event-name capability-name)
  (make-grant-event :event-id (list "cap0-event" event-name)
                    :capability-id (list "cap" capability-name)
                    :subject *subject* :action *action*
                    :resource *resource* :scope *scope*
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
          (identifier-from-segments '("cap1-controls" "noted")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "body"))
          (lisp-plus-cd0:make-string-datum body)))))

(defun ask (store bootstrap capability-name query-name)
  (query-live-authority store bootstrap
                        :capability-id (list "cap" capability-name)
                        :subject *subject* :action *action*
                        :resource *resource* :scope *scope*
                        :query-id (list "cap0-query" query-name)))

(defun show (store bootstrap context object presentation-name
             &key (subject *subject*) (action *action*)
                  (resource *resource*) (scope *scope*) defect)
  (present-live-capability store bootstrap context object
                           :subject subject :action action
                           :resource resource :scope scope
                           :presentation-id (list "cap1-present"
                                                  presentation-name)
                           :defect defect))

(defun forge-counterfeit (object)
  "Every public field copied, through the internal constructor — the
deliberately-named hostile path.  If description forged keys, this would."
  (%make-live-capability
   :public-id (live-capability-public-id object)
   :occurrence-id (live-capability-occurrence-id object)
   :subject (live-capability-subject object)
   :action (live-capability-action object)
   :resource (live-capability-resource object)
   :scope (live-capability-scope object)
   :minter (live-capability-minter object)
   :store-id (live-capability-store-id object)
   :terminal-ordinal (live-capability-terminal-ordinal object)
   :valid-byte-count (live-capability-valid-byte-count object)
   :terminal-digest (live-capability-terminal-digest object)))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE A — THE INHABITED VERTICAL (the owner's charge, in order).

(cnote "== store A: the inhabited vertical ==")

(defvar *a-directory* (merge-pathnames "store-a/" *scratch*))
(defvar *a* (create-journal *a-directory*
                            :nonce-octets (c-ascii "cap1-controls-aa")))
(defvar *boot-a* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *a*)))
(append-event *a* (grant "g-a01" "clavis"))
(defvar *ctx* (make-minting-context :label "alpha"))

(defvar *auth-1* (ask *a* *boot-a* "clavis" "q-a1"))
(defvar *key-1* nil)
(defvar *mint-receipt-1* nil)

(ccheck "VERTICAL 1 — fresh /0 authority query at validated prefix P ~
         (ordinal 1): decision :authorized, receipt bound to P ~
         (receipt-current-p against a fresh report)"
  (lambda ()
    (and (eq :authorized (receipt-decision *auth-1*))
         (receipt-current-p *auth-1* (validate-journal *a*)
                            :store-id (journal-store-store-id *a*)))))

(ccheck "VERTICAL 2 — explicit minting occurrence: the bridge mints an ~
         opaque live capability + a public minting receipt; the object is ~
         recognized by its context and bound to P's four facets"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *a* *boot-a* *ctx* *auth-1*
                                 :minter *minter*)
      (setf *key-1* object *mint-receipt-1* receipt)
      (let ((report (validate-journal *a*)))
        (and (live-capability-p object)
             (context-recognizes-p *ctx* object)
             (= 1 (live-capability-terminal-ordinal object))
             (string= (journal-store-store-id *a*)
                      (live-capability-store-id object))
             (= (prefix-report-valid-byte-count report)
                (live-capability-valid-byte-count object))
             (string= (prefix-report-terminal-digest report)
                      (live-capability-terminal-digest object)))))))

(ccheck "VERTICAL 3 — the minting receipt is truthful public testimony: ~
         canonical CD/0 record naming the occurrence identity, the ~
         capability public identity, the minter, the authorizing query ~
         identity, the grant event (g-a01), all four terms, P's four ~
         facets, and the identified scope + mint procedures"
  (lambda ()
    (multiple-value-bind (decoded status)
        (decode-pjs0 (encode-pjs0 *mint-receipt-1*))
      (and decoded (eq :canonical status)
           (string= "cap1:minting"
                    (identifier-segment-string
                     (record-field decoded "receipt" "kind")))
           (datum= (record-field decoded "receipt" "occurrence-id")
                   (live-capability-occurrence-id *key-1*))
           (datum= (record-field decoded "receipt" "capability-public-id")
                   (live-capability-public-id *key-1*))
           (datum= (record-field decoded "receipt" "minter")
                   (identifier-from-segments *minter*))
           (datum= (record-field decoded "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-a01")))
           (datum= (record-field decoded "receipt" "authorizing-query-id")
                   (identifier-from-segments '("cap0-query" "q-a1")))
           (datum= (record-field decoded "receipt" "subject")
                   (identifier-from-segments *subject*))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field decoded "receipt" "terminal-ordinal")))
           (string= (live-capability-terminal-digest *key-1*)
                    (lisp-plus-cd0:string-datum-value
                     (record-field decoded "receipt" "terminal-digest")))
           (string= "cap1-scope:exact-from-authorization"
                    (identifier-segment-string
                     (record-field decoded "receipt" "scope-procedure")))
           (string= "lisp-plus-capability1:mint-from-authorization"
                    (identifier-segment-string
                     (record-field decoded "receipt" "procedure-id")))))))

(ccheck "VERTICAL 4 — successful presentation while P remains current: ~
         presentation receipt decision cap1:presented, bound to the same ~
         four facets, naming the key's public identity"
  (lambda ()
    (let ((receipt (show *a* *boot-a* *ctx* *key-1* "p-a1")))
      (and (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field receipt "receipt" "decision")))
           (datum= (record-field receipt "receipt" "capability-public-id")
                   (live-capability-public-id *key-1*))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field receipt "receipt" "terminal-ordinal")))))))

(append-event *a* (unrelated "u-a01" "the world turned"))

(ccheck "VERTICAL 5 / NC-5 — the journal advances (unrelated event, ordinal ~
         2): the old key refuses as STALE by type, cap1-stale-capability ~
         naming BOTH prefixes (binding ordinal 1 vs present ordinal 2, ~
         digests distinct, present digest equal to the fresh report's)"
  (lambda ()
    (handler-case (progn (show *a* *boot-a* *ctx* *key-1* "p-a2") nil)
      (cap1-stale-capability (condition)
        (and (eql 1 (cap1-stale-capability-capability-terminal-ordinal
                     condition))
             (eql 2 (cap1-stale-capability-present-terminal-ordinal
                     condition))
             (not (string=
                   (cap1-stale-capability-capability-terminal-digest
                    condition)
                   (cap1-stale-capability-present-terminal-digest
                    condition)))
             (string= (cap1-stale-capability-present-terminal-digest
                       condition)
                      (prefix-report-terminal-digest
                       (validate-journal *a*))))))))

(defvar *auth-2* (ask *a* *boot-a* "clavis" "q-a2"))
(defvar *key-2* nil)
(defvar *mint-receipt-2* nil)

(ccheck "VERTICAL 6 — authority is still live at the moved prefix: fresh ~
         query :authorized; fresh mint yields a NEW key with a NEW ~
         occurrence identity and NEW public identity, LINKED to the SAME ~
         grant (g-a01) in both minting receipts"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *a* *boot-a* *ctx* *auth-2*
                                 :minter *minter*)
      (setf *key-2* object *mint-receipt-2* receipt)
      (and (eq :authorized (receipt-decision *auth-2*))
           (not (datum= (live-capability-public-id object)
                        (live-capability-public-id *key-1*)))
           (not (datum= (live-capability-occurrence-id object)
                        (live-capability-occurrence-id *key-1*)))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (record-field *mint-receipt-1* "receipt"
                                 "grant-event-id"))
           (= 2 (live-capability-terminal-ordinal object))))))

(ccheck "VERTICAL 7 — the new key presents successfully at the current ~
         prefix (ordinal 2)"
  (lambda ()
    (string= "cap1:presented"
             (identifier-segment-string
              (record-field (show *a* *boot-a* *ctx* *key-2* "p-a3")
                            "receipt" "decision")))))

(append-event *a* (revocation "r-a01" "clavis"))

(ccheck "VERTICAL 8 / NC-6a — revocation commits (ordinal 3): the live key ~
         refuses as STALE (the adjudicated subsumption: under exact prefix ~
         binding, the advance CONTAINING the revocation is itself a ~
         binding mismatch; revocation distinctly governs minting, next ~
         checks)"
  (lambda ()
    (handler-case (progn (show *a* *boot-a* *ctx* *key-2* "p-a4") nil)
      (cap1-stale-capability (condition)
        (and (eql 2 (cap1-stale-capability-capability-terminal-ordinal
                     condition))
             (eql 3 (cap1-stale-capability-present-terminal-ordinal
                     condition)))))))

(ccheck "VERTICAL 9 / NC-6b — the fresh /0 query now REFUSES: decision ~
         :refused, reason capability-revoked, naming the historical grant ~
         (g-a01) AND the revoking event (r-a01)"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-a3")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-a01")))
           (datum= (record-field receipt "receipt" "revoking-event-id")
                   (identifier-from-segments '("cap0-event" "r-a01")))))))

(ccheck "VERTICAL 10 / NC-6c / NC-10 — NO key can be freshly minted after ~
         revocation, on typed bases: (i) the pre-revocation authorization ~
         receipt refuses the mint with /0's cap0-stale-receipt (ordinal 2 ~
         vs 3); (ii) a DOCTORED receipt claiming :authorized at the ~
         CURRENT prefix refuses with cap1-mint-refused ~
         :fresh-derivation-refused, fresh reason capability-revoked, the ~
         fresh refusal naming the revoking event r-a01 — the receipt's ~
         description could not forge the key"
  (lambda ()
    (and (handler-case
             (progn (mint-from-authorization *a* *boot-a* *ctx* *auth-2*
                                             :minter *minter*)
                    nil)
           (cap0-stale-receipt (condition)
             (and (eql 2 (lisp-plus-capability0:cap0-stale-receipt-receipt-terminal-ordinal
                          condition))
                  (eql 3 (lisp-plus-capability0:cap0-stale-receipt-present-terminal-ordinal
                          condition)))))
         (let ((forged (make-authority-receipt
                        :store *a* :report (validate-journal *a*)
                        :decision :authorized
                        :reason "grant-live-at-validated-prefix"
                        :capability-id '("cap" "clavis")
                        :query-id '("cap0-query" "q-forged")
                        :subject *subject* :action *action*
                        :resource *resource* :scope *scope*)))
           (handler-case
               (progn (mint-from-authorization *a* *boot-a* *ctx* forged
                                               :minter *minter*)
                      nil)
             (cap1-mint-refused (condition)
               (and (eq :fresh-derivation-refused
                        (cap1-mint-refused-basis condition))
                    (string= "capability-revoked"
                             (cap1-mint-refused-fresh-reason condition))
                    (datum= (record-field
                             (cap1-mint-refused-fresh-receipt condition)
                             "receipt" "revoking-event-id")
                            (identifier-from-segments
                             '("cap0-event" "r-a01"))))))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; NEGATIVE CONTROLS 1-4 + 8: descriptions, mimics, foreign contexts, terms.

(cnote "~%== store B: recognition controls (a fresh live world) ==")

(defvar *b-directory* (merge-pathnames "store-b/" *scratch*))
(defvar *b* (create-journal *b-directory*
                            :nonce-octets (c-ascii "cap1-controls-bb")))
(defvar *boot-b* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *b*)))
(append-event *b* (grant "g-b01" "sigillum"))

(defvar *ctx-b* (make-minting-context :label "beta"))
(defvar *auth-b* (query-live-authority *b* *boot-b*
                                       :capability-id '("cap" "sigillum")
                                       :subject *subject* :action *action*
                                       :resource *resource* :scope *scope*
                                       :query-id '("cap0-query" "q-b1")))
(defvar *key-b* nil)
(defvar *mint-receipt-b* nil)

(multiple-value-bind (object receipt)
    (mint-from-authorization *b* *boot-b* *ctx-b* *auth-b* :minter *minter*)
  (setf *key-b* object *mint-receipt-b* receipt))

(defun show-b (object name &rest overrides)
  (apply #'show *b* *boot-b* *ctx-b* object name overrides))

(ccheck "NC-1 — the AUTHORIZATION receipt presented as a capability: ~
         cap1-unrecognized-object (adjudication executed: recognition ~
         refuses ANY object the context did not mint, record datums ~
         included; presented-type is the record type, not live-capability)"
  (lambda ()
    (handler-case (progn (show-b *auth-b* "p-b-auth") nil)
      (cap1-unrecognized-object (condition)
        (and (not (eq 'live-capability
                      (cap1-unrecognized-object-presented-type condition)))
             (string= "beta"
                      (cap1-unrecognized-object-context-label condition)))))))

(ccheck "NC-2 — the MINTING receipt presented as a capability: ~
         cap1-unrecognized-object, with the receipt's claimed public ~
         identity reported as a claim (the minting receipt records ~
         everything public about the key and still opens nothing)"
  (lambda ()
    (handler-case (progn (show-b *mint-receipt-b* "p-b-mintr") nil)
      (cap1-unrecognized-object (condition)
        (and (cap1-unrecognized-object-presented-public-id condition)
             (search "cap1-key"
                     (cap1-unrecognized-object-presented-public-id
                      condition)))))))

(ccheck "NC-3 — a hand-constructed object with EVERY public field copied ~
         (built through the internal constructor, the named hostile path): ~
         refused by recognition, cap1-unrecognized-object carrying the ~
         copied public identity as a CLAIM — identical description, no ~
         membership"
  (lambda ()
    (let ((counterfeit (forge-counterfeit *key-b*)))
      (handler-case (progn (show-b counterfeit "p-b-fake") nil)
        (cap1-unrecognized-object (condition)
          (and (eq 'live-capability
                   (cap1-unrecognized-object-presented-type condition))
               (string= (identifier-segment-string
                         (live-capability-public-id *key-b*))
                        (cap1-unrecognized-object-presented-public-id
                         condition))))))))

(ccheck "NC-4 — a capability from ANOTHER minting context (two contexts, ~
         one process): the GENUINE key-b refuses at context gamma with ~
         cap1-unrecognized-object labeled gamma; and it still presents ~
         fine at beta (the refusal was the context's, not the key's)"
  (lambda ()
    (let ((gamma (make-minting-context :label "gamma")))
      (and (handler-case
               (progn (show *b* *boot-b* gamma *key-b* "p-b-gamma") nil)
             (cap1-unrecognized-object (condition)
               (string= "gamma"
                        (cap1-unrecognized-object-context-label
                         condition))))
           (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field (show-b *key-b* "p-b-again")
                                   "receipt" "decision")))))))

(ccheck "NC-8 — foreign terms at presentation: a wrong action refuses ~
         cap1-term-mismatch naming exactly (\"action\"); wrong action AND ~
         resource name both, declaration order; the adjudicated reading is ~
         the stricter one — the caller states its requested terms and ALL ~
         four must equal the minted terms exactly"
  (lambda ()
    (and (handler-case
             (progn (show-b *key-b* "p-b-terms"
                            :action '("act" "claudere"))
                    nil)
           (cap1-term-mismatch (condition)
             (equal '("action")
                    (cap1-term-mismatch-mismatched-terms condition))))
         (handler-case
             (progn (show-b *key-b* "p-b-terms2"
                            :action '("act" "claudere")
                            :resource '("res" "ianua-aliena"))
                    nil)
           (cap1-term-mismatch (condition)
             (equal '("action" "resource")
                    (cap1-term-mismatch-mismatched-terms condition)))))))

(ccheck "NC-9 — a /0 REFUSAL receipt handed to the mint: cap1-mint-refused ~
         basis :receipt-not-authorized (a truthful refusal is testimony ~
         against the mint, and its own decision field is honored as a ~
         claim shape, then refused as standing)"
  (lambda ()
    (let ((refusal (query-live-authority
                    *b* *boot-b*
                    :capability-id '("cap" "umbra")
                    :subject *subject* :action *action*
                    :resource *resource* :scope *scope*
                    :query-id '("cap0-query" "q-b-missing"))))
      (and (eq :refused (receipt-decision refusal))
           (handler-case
               (progn (mint-from-authorization *b* *boot-b* *ctx-b* refusal
                                               :minter *minter*)
                      nil)
             (cap1-mint-refused (condition)
               (eq :receipt-not-authorized
                   (cap1-mint-refused-basis condition))))))))

(ccheck "NC-9b — non-receipts handed to the mint (a grant event; a bare ~
         string datum): cap1-mint-refused basis :not-an-authority-receipt ~
         for each"
  (lambda ()
    (flet ((refused-p (thing)
             (handler-case
                 (progn (mint-from-authorization *b* *boot-b* *ctx-b* thing
                                                 :minter *minter*)
                        nil)
               (cap1-mint-refused (condition)
                 (eq :not-an-authority-receipt
                     (cap1-mint-refused-basis condition))))))
      (and (refused-p (grant "g-junk" "umbra"))
           (refused-p (lisp-plus-cd0:make-string-datum "not a receipt"))))))

(ccheck "NC-11 — /0's own refusals propagate through the bridge: mint with ~
         NO bootstrap refuses cap0-bootstrap-missing; mint with a ~
         WRONG-STORE bootstrap refuses cap0-bootstrap-store-mismatch ~
         (expected/actual carried); presentation checks the same discipline"
  (lambda ()
    (and (expects cap0-bootstrap-missing
           (mint-from-authorization *b* nil *ctx-b* *auth-b*
                                    :minter *minter*))
         (handler-case
             (progn (mint-from-authorization
                     *b* (declare-bootstrap-authority *issuer*
                                                      "pj0-store:aliena")
                     *ctx-b* *auth-b* :minter *minter*)
                    nil)
           (cap0-bootstrap-store-mismatch (condition)
             (string= "pj0-store:aliena"
                      (lisp-plus-capability0:cap0-bootstrap-store-mismatch-expected
                       condition))))
         (expects cap0-bootstrap-missing
           (present-live-capability *b* nil *ctx-b* *key-b*
                                    :presentation-id '("cap1-present"
                                                       "p-b-noboot"))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE C — torn tail at presentation (derived byte state, labelled derived).

(cnote "~%== store C: the torn tail under a minted key (derived byte ~
        state) ==")

(defvar *c-directory* (merge-pathnames "store-c/" *scratch*))
(defvar *c* (create-journal *c-directory*
                            :nonce-octets (c-ascii "cap1-controls-cc")))
(defvar *boot-c* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *c*)))
(append-event *c* (grant "g-c01" "porta"))
(defvar *ctx-c* (make-minting-context :label "gamma-c"))
(defvar *key-c* (mint-from-authorization
                 *c* *boot-c* *ctx-c*
                 (ask *c* *boot-c* "porta" "q-c1")
                 :minter *minter*))
(defvar *c-one-frame-octets*
  (c-read-octets (merge-pathnames "EVENTS.pj0" *c-directory*)))
(append-event *c* (revocation "r-c01" "porta"))
(defvar *c-two-frame-octets*
  (c-read-octets (merge-pathnames "EVENTS.pj0" *c-directory*)))
;; tear the trailing frame: drop its last 7 octets (PJ0 §13 torn tail).
(c-write-octets (merge-pathnames "EVENTS.pj0" *c-directory*)
                (subseq *c-two-frame-octets*
                        0 (- (length *c-two-frame-octets*) 7)))

(ccheck "NC-torn — a TORN TAIL does not stale the key and cannot silently ~
         revoke it: the reader classifies :torn-tail with the valid prefix ~
         = the minted prefix (all four facets equal), the presentation ~
         SUCCEEDS, and the receipt SURFACES the excluded tail (offset = ~
         valid byte count = the one-frame length; sha rendered) — an ~
         incomplete trailing frame was never a committed advance ~
         (adjudication mirrors /0's law 9)"
  (lambda ()
    (let* ((store (open-store *c-directory*))
           (report (validate-journal store))
           (receipt (show store *boot-c* *ctx-c* *key-c* "p-c-torn")))
      (and (eq :torn-tail (prefix-report-status report))
           (= 1 (prefix-report-frame-count report))
           (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field receipt "receipt" "decision")))
           (= (prefix-report-tail-offset report)
              (lisp-plus-cd0:integer-datum-value
               (record-field receipt "receipt" "tail-offset")))
           (string= (prefix-report-tail-sha256 report)
                    (lisp-plus-cd0:string-datum-value
                     (record-field receipt "receipt" "tail-sha256")))
           (= (prefix-report-tail-offset report)
              (length *c-one-frame-octets*))))))

(ccheck "NC-torn (contrast that carries it) — the SAME revocation, fully ~
         committed on the twin (bytes restored), DOES stale the key: ~
         cap1-stale-capability ordinal 1 vs 2, and the fresh /0 query ~
         refuses capability-revoked (only commitment moves the prefix)"
  (lambda ()
    (c-write-octets (merge-pathnames "EVENTS.pj0" *c-directory*)
                    *c-two-frame-octets*)
    (let ((store (open-store *c-directory*)))
      (and (handler-case
               (progn (show store *boot-c* *ctx-c* *key-c* "p-c-committed")
                      nil)
             (cap1-stale-capability (condition)
               (and (eql 1 (cap1-stale-capability-capability-terminal-ordinal
                            condition))
                    (eql 2 (cap1-stale-capability-present-terminal-ordinal
                            condition)))))
           (string= "capability-revoked"
                    (receipt-reason (ask store *boot-c* "porta"
                                         "q-c-committed")))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; STORE D — interior corruption refuses presentation outright.

(cnote "~%== store D: interior corruption at presentation (derived byte ~
        state) ==")

(defvar *d-directory* (merge-pathnames "store-d/" *scratch*))
(defvar *d* (create-journal *d-directory*
                            :nonce-octets (c-ascii "cap1-controls-dd")))
(defvar *boot-d* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *d*)))
(append-event *d* (grant "g-d01" "custodia"))
(append-event *d* (unrelated "u-d01" "second frame, soon to be damaged"))
(defvar *ctx-d* (make-minting-context :label "delta"))
(defvar *key-d* (mint-from-authorization
                 *d* *boot-d* *ctx-d*
                 (ask *d* *boot-d* "custodia" "q-d1")
                 :minter *minter*))
(defvar *d-octets* (c-read-octets (merge-pathnames "EVENTS.pj0"
                                                   *d-directory*)))
(defvar *d-offset* (search (c-ascii "soon to be damaged") *d-octets*))

(ccheck "NC-corr — an INVALID INTERIOR frame refuses presentation outright ~
         by TYPED refusal, kernel0's JOURNAL-PREFIX-INVALID (one payload ~
         byte of frame 2 flipped; the reader classifies :corruption): no ~
         staleness comparison is attempted against an unbounded prefix ~
         (the /0 fold adjudication, adopted at the presentation frontier)"
  (lambda ()
    (let ((damaged (copy-seq *d-octets*)))
      (setf (aref damaged *d-offset*) (char-code #\S))
      (c-write-octets (merge-pathnames "EVENTS.pj0" *d-directory*) damaged))
    (let ((store (open-store *d-directory*)))
      (and (eq :corruption (prefix-report-status (validate-journal store)))
           (expects lisp-plus-kernel0:journal-prefix-invalid
             (show store *boot-d* *ctx-d* *key-d* "p-d-corrupt"))))))

(ccheck "NC-corr (teeth for the check itself) — restoring the original ~
         octet makes the store :valid again and the SAME presentation ~
         succeeds: the refusal above was the corruption's doing, not a ~
         constant of the harness"
  (lambda ()
    (c-write-octets (merge-pathnames "EVENTS.pj0" *d-directory*) *d-octets*)
    (let ((store (open-store *d-directory*)))
      (and (eq :valid (prefix-report-status (validate-journal store)))
           (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field (show store *boot-d* *ctx-d* *key-d*
                                         "p-d-restored")
                                   "receipt" "decision")))))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; NC-12 — the three planted mutants, killed over a fresh live world.

(cnote "~%== store E: the planted mutants ==")

(defvar *e-directory* (merge-pathnames "store-e/" *scratch*))
(defvar *e* (create-journal *e-directory*
                            :nonce-octets (c-ascii "cap1-controls-ee")))
(defvar *boot-e* (declare-bootstrap-authority
                  *issuer* (journal-store-store-id *e*)))
(append-event *e* (grant "g-e01" "fenestra"))
(defvar *ctx-e* (make-minting-context :label "epsilon"))
(defvar *key-e* (mint-from-authorization
                 *e* *boot-e* *ctx-e*
                 (query-live-authority *e* *boot-e*
                                       :capability-id '("cap" "fenestra")
                                       :subject *subject* :action *action*
                                       :resource *resource* :scope *scope*
                                       :query-id '("cap0-query" "q-e1"))
                 :minter *minter*))

(ccheck "NC-12a — planted mutant :serializable-authority KILLED at the ~
         current prefix: a counterfeit with the genuine key's public ~
         fields is refused by the strict path (unrecognized) and PRESENTED ~
         by the description-recognizing mutant — the exact world §11.2 ~
         forbids, demonstrated fatal"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :serializable-authority *e* *boot-e* *ctx-e*
                         (forge-counterfeit *key-e*)
                         :subject *subject* :action *action*
                         :resource *resource* :scope *scope*)
      (and killed
           (eq :cap1-unrecognized-object strict)
           (eq :presented mutant)))))

(ccheck "NC-12b — planted mutant :public-constructor KILLED at the current ~
         prefix: a hand-built struct with a FOREIGN public identity is ~
         refused by the strict path and PRESENTED by the type-recognizing ~
         mutant — constructing is not minting"
  (lambda ()
    (let ((forged (%make-live-capability
                   :public-id (identifier-from-segments
                               '("cap1-key" "ex-nihilo" "1"))
                   :occurrence-id (identifier-from-segments
                                   '("cap1-mint" "ex-nihilo" "1"))
                   :subject (live-capability-subject *key-e*)
                   :action (live-capability-action *key-e*)
                   :resource (live-capability-resource *key-e*)
                   :scope (live-capability-scope *key-e*)
                   :minter (live-capability-minter *key-e*)
                   :store-id (live-capability-store-id *key-e*)
                   :terminal-ordinal (live-capability-terminal-ordinal
                                      *key-e*)
                   :valid-byte-count (live-capability-valid-byte-count
                                      *key-e*)
                   :terminal-digest (live-capability-terminal-digest
                                     *key-e*))))
      (multiple-value-bind (killed strict mutant)
          (run-mutant-kill :public-constructor *e* *boot-e* *ctx-e* forged
                           :subject *subject* :action *action*
                           :resource *resource* :scope *scope*)
        (and killed
             (eq :cap1-unrecognized-object strict)
             (eq :presented mutant))))))

(ccheck "NC-12c — planted mutant :context-as-liveness-cache KILLED by a ~
         journal advance: the strict path re-validates fresh and refuses ~
         STALE; the mutant answers from recognition alone and still ~
         presents — a recognition context that decays into a liveness ~
         cache waves keys past the journal, demonstrated fatal (and a ~
         committed revocation would ride the same advance it just waved ~
         through)"
  (lambda ()
    (append-event *e* (unrelated "u-e01" "the advance the cache ignores"))
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :context-as-liveness-cache *e* *boot-e* *ctx-e*
                         *key-e*
                         :subject *subject* :action *action*
                         :resource *resource* :scope *scope*)
      (and killed
           (eq :cap1-stale-capability strict)
           (eq :presented mutant)))))

;;; ═══════════════════════════════════════════════════════════════════════════
;;; GATE TEETH — this runner shown able to fail, and shown detectable when
;;; truncated (NC-13's controls-side form; the specimen has the process form).

(when (sb-posix:getenv "CAP1_CONTROLS_PLANT_FAULT")
  (ccheck "PLANTED FAULT (CAP1_CONTROLS_PLANT_FAULT): this check is false ~
           by construction"
    (lambda () nil)))

(unless (or (sb-posix:getenv "CAP1_CONTROLS_PLANT_FAULT")
            (sb-posix:getenv "CAP1_CONTROLS_DIE"))
  (ccheck "gate teeth (fault) — a child run with a planted fault exits 1 ~
           and its transcript carries the FAIL line: this suite CAN go red"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability1/capability1-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP1_CONTROLS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (ccheck "gate teeth (truncation) / NC-13 — a child killed mid-run before ~
           any verdict exits 3 with NO RESULT sentinel, and the detection ~
           is exactly that pair: an unfinished run must never read as a ~
           clean one"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability1/capability1-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP1_CONTROLS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (null (search "RESULT:" text))
             (search "dying mid-run" text))))))

;;; ---------------------------------------------------------------------------
;;; Teardown + derived result.

(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%capability1-controls: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(format t "vertical executed: query - mint - present - advance - stale - ~
           re-mint - revoke - fresh-query-refuses - no-fresh-mint · ~
           controls: receipts-as-keys, counterfeit, cross-context, foreign ~
           terms, refusal/non-receipt/doctored/stale mints, bootstrap ~
           absence/mismatch, torn tail, interior corruption, three planted ~
           mutants, planted fault, truncated child~%")
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
