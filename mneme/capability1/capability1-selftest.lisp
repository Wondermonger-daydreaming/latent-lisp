;;;; capability1-selftest.lisp — unit teeth for Capability /1.
;;;;
;;;; Run:  sbcl --script mneme/capability1/capability1-selftest.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: fixed store nonces (declared PJ-META-1 deviation, exactly
;;;; as journal0's and capability0's fixtures declared it: test fixtures,
;;;; never production identities); no timestamps, pids, or absolute paths
;;;; printed.  Two runs produce byte-identical transcripts.
;;;;
;;;; GATE TEETH (journal0 §28 discipline, applied to this runner itself):
;;;; CAP1_SELFTEST_PLANT_FAULT=1 plants one deliberately false check; the
;;;; runner spawns itself once under that variable and asserts the planted
;;;; fault FIRES (exit 1 + the FAIL line).  A selftest that has never been
;;;; seen to fail is untested.
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

(defun tcheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun tnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defmacro expects (condition-type &body body)
  `(handler-case (progn ,@body nil)
     (,condition-type () t)
     (error () nil)))

(defun t-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun t-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defvar *scratch* #p"mneme/capability1/scratch-selftest/")
(fresh-directory *scratch*)

(tnote "capability1-selftest — unit teeth")
(tnote "governing sentence: a receipt may explain why a key was minted; it ~
        is not the key, and its description cannot forge one.~%")

;;; ---------------------------------------------------------------------------
;;; Shared fixture vocabulary.

(defvar *issuer-segments* '("cap1-issuer" "radix"))
(defvar *minter-segments* '("cap1-minter" "claviger"))
(defvar *subject-segments* '("subj" "ianitor"))
(defvar *action-segments* '("act" "aperire"))
(defvar *resource-segments* '("res" "ianua-prima"))
(defvar *scope-segments* '("scope" "exact"))

(defun test-grant (&key (event-id '("cap0-event" "g-001"))
                        (capability-id '("cap" "clavis"))
                        (subject *subject-segments*)
                        (action *action-segments*)
                        (resource *resource-segments*)
                        (scope *scope-segments*)
                        (issuer *issuer-segments*))
  (make-grant-event :event-id event-id :capability-id capability-id
                    :subject subject :action action :resource resource
                    :scope scope :issuer issuer))

(defun test-unrelated (name)
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments (list "cap0-event" name)))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments '("cap1-selftest" "noted"))))))

(defun ask (store bootstrap capability-name query-name)
  (query-live-authority store bootstrap
                        :capability-id (list "cap" capability-name)
                        :subject *subject-segments*
                        :action *action-segments*
                        :resource *resource-segments*
                        :scope *scope-segments*
                        :query-id (list "cap0-query" query-name)))

(defun show (store bootstrap context object presentation-name
             &key (subject *subject-segments*) (action *action-segments*)
                  (resource *resource-segments*) (scope *scope-segments*)
                  defect)
  (present-live-capability store bootstrap context object
                           :subject subject :action action
                           :resource resource :scope scope
                           :presentation-id (list "cap1-present"
                                                  presentation-name)
                           :defect defect))

;;; ---------------------------------------------------------------------------
;;; 1. The minting context.

(tcheck "make-minting-context builds an explicit context: minting-context-p ~
         true, label carried, ZERO objects minted, and it recognizes ~
         nothing (a fresh recognizer grants nothing)"
  (lambda ()
    (let ((context (make-minting-context :label "probe")))
      (and (minting-context-p context)
           (string= "probe" (minting-context-label context))
           (zerop (minting-context-minted-count context))
           (not (context-recognizes-p context (list "anything")))))))

(tcheck "the context label reader is defensive: mutating the returned ~
         string does not change the context's label"
  (lambda ()
    (let* ((context (make-minting-context :label "probe"))
           (label (minting-context-label context)))
      (setf (char label 0) #\X)
      (string= "probe" (minting-context-label context)))))

;;; ---------------------------------------------------------------------------
;;; 2. Store A — the living fixture.

(defvar *a-directory* (merge-pathnames "store-a/" *scratch*))
(defvar *a* (create-journal *a-directory*
                            :nonce-octets (t-ascii "cap1-selftest-a!")))
(defvar *boot-a* (declare-bootstrap-authority
                  *issuer-segments* (journal-store-store-id *a*)))
(append-event *a* (test-grant))
(defvar *ctx* (make-minting-context :label "alpha"))

(tcheck "mint/present without an explicit context refuse with ~
         cap1-context-missing (nil and a non-context both refused; nothing ~
         runs on ambient recognition)"
  (lambda ()
    (let ((receipt (ask *a* *boot-a* "clavis" "q-ctx")))
      (and (expects cap1-context-missing
             (mint-from-authorization *a* *boot-a* nil receipt
                                      :minter *minter-segments*))
           (expects cap1-context-missing
             (mint-from-authorization *a* *boot-a* "not-a-context" receipt
                                      :minter *minter-segments*))
           (expects cap1-context-missing
             (present-live-capability *a* *boot-a* 42 receipt
                                      :presentation-id '("cap1-present"
                                                         "p-ctx")))))))

(defvar *receipt-at-p* (ask *a* *boot-a* "clavis" "q-mint-1"))
(defvar *object* nil)
(defvar *mint-receipt* nil)

(tcheck "the minting bridge mints from a truthful :authorized receipt: ~
         returns a live-capability + a minting receipt; the object is ~
         recognized by ITS context (EQ membership), and the minted count ~
         is now 1"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *a* *boot-a* *ctx* *receipt-at-p*
                                 :minter *minter-segments*)
      (setf *object* object *mint-receipt* receipt)
      (and (live-capability-p object)
           (lisp-plus-cd0:record-datum-p receipt)
           (context-recognizes-p *ctx* object)
           (= 1 (minting-context-minted-count *ctx*))))))

(tcheck "occurrence and public identities are exactly the documented ~
         derivation: (\"cap1-mint\"|\"cap1-key\") + sha256 of the FRESH ~
         authorization receipt's canonical bytes + this context's serial 1 ~
         — identity is a recomputable name, never a secret"
  (lambda ()
    ;; The fresh receipt the bridge derived is byte-reproducible: same
    ;; store, same prefix, same terms, same query-id, same origin.
    (let ((expected-sha (sha256-hex (encode-pjs0
                                     (ask *a* *boot-a* "clavis"
                                          "q-mint-1")))))
      (and (datum= (live-capability-occurrence-id *object*)
                   (identifier-from-segments
                    (list "cap1-mint" expected-sha "1")))
           (datum= (live-capability-public-id *object*)
                   (identifier-from-segments
                    (list "cap1-key" expected-sha "1")))))))

(tcheck "the object binds the EXACT validated prefix of its mint (all four ~
         facets equal the authorization receipt's binding: store-id, ~
         terminal ordinal 1, valid byte count, terminal digest)"
  (lambda ()
    (let ((report (validate-journal *a*)))
      (and (string= (live-capability-store-id *object*)
                    (journal-store-store-id *a*))
           (= 1 (live-capability-terminal-ordinal *object*))
           (= (prefix-report-valid-byte-count report)
              (live-capability-valid-byte-count *object*))
           (string= (prefix-report-terminal-digest report)
                    (live-capability-terminal-digest *object*))))))

;;; ---------------------------------------------------------------------------
;;; 3. Printing and reading — testimony, never a key.

(tcheck "print-object shows ONLY the public identity: the printed form ~
         names the public id, is #<-unreadable, is deterministic across ~
         prints, and contains neither the terminal digest, the store id, ~
         nor any term"
  (lambda ()
    (let ((printed (princ-to-string *object*)))
      (and (search (identifier-segment-string
                    (%live-capability-public-id *object*))
                   printed)
           (string= "#<" (subseq printed 0 2))
           (string= printed (princ-to-string *object*))
           (null (search (live-capability-terminal-digest *object*)
                         printed))
           (null (search (live-capability-store-id *object*) printed))
           (null (search "ianitor" printed))))))

(tcheck "the printed form cannot be read back at all: READ-FROM-STRING on ~
         it signals (the #< syntax is reader-rejected); a printed key is a ~
         label on a corpse, not a resurrection"
  (lambda ()
    (expects error (read-from-string (princ-to-string *object*)))))

;;; ---------------------------------------------------------------------------
;;; 4. Defensive readers (§11.5).

(tcheck "datum readers are defensive copies: two reads of the scope are ~
         canonically equal but NOT EQ, and neither is EQ to a third read ~
         (mutation of a returned value cannot reach live authority)"
  (lambda ()
    (let ((first-read (live-capability-scope *object*))
          (second-read (live-capability-scope *object*)))
      (and (datum= first-read second-read)
           (not (eq first-read second-read))
           (not (eq first-read (live-capability-scope *object*)))))))

(tcheck "string readers are defensive copies: mutating a returned store-id ~
         or terminal-digest string leaves subsequent reads unchanged"
  (lambda ()
    (let ((store-id (live-capability-store-id *object*))
          (digest (live-capability-terminal-digest *object*)))
      (setf (char store-id 0) #\X
            (char digest 0) #\X)
      (and (not (string= store-id (live-capability-store-id *object*)))
           (not (string= digest (live-capability-terminal-digest *object*)))
           (string= (live-capability-store-id *object*)
                    (journal-store-store-id *a*))))))

;;; ---------------------------------------------------------------------------
;;; 5. Presentation while the prefix is current.

(tcheck "presentation succeeds while the minted prefix is current: the ~
         presentation receipt renders decision cap1:presented, names the ~
         capability's public id and occurrence id, and binds the SAME four ~
         prefix facets"
  (lambda ()
    (let ((receipt (show *a* *boot-a* *ctx* *object* "p-001")))
      (and (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field receipt "receipt" "decision")))
           (datum= (record-field receipt "receipt" "capability-public-id")
                   (live-capability-public-id *object*))
           (datum= (record-field receipt "receipt" "occurrence-id")
                   (live-capability-occurrence-id *object*))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field receipt "receipt" "terminal-ordinal")))
           (string= (live-capability-terminal-digest *object*)
                    (lisp-plus-cd0:string-datum-value
                     (record-field receipt "receipt" "terminal-digest")))))))

(tcheck "term discipline is exact and total: a wrong resource refuses ~
         cap1-term-mismatch naming exactly (\"resource\"); an omitted ~
         action refuses naming \"action\"; the condition carries the ~
         capability's public identity"
  (lambda ()
    (and (handler-case
             (progn (show *a* *boot-a* *ctx* *object* "p-wrong"
                          :resource '("res" "ianua-aliena"))
                    nil)
           (cap1-term-mismatch (condition)
             (and (equal '("resource")
                         (cap1-term-mismatch-mismatched-terms condition))
                  (search "cap1-key"
                          (cap1-term-mismatch-capability-public-id
                           condition)))))
         (handler-case
             (progn (show *a* *boot-a* *ctx* *object* "p-omitted"
                          :action nil)
                    nil)
           (cap1-term-mismatch (condition)
             (equal '("action")
                    (cap1-term-mismatch-mismatched-terms condition)))))))

;;; ---------------------------------------------------------------------------
;;; 6. Recognition refusals — descriptions are not keys.

(tcheck "the AUTHORIZATION receipt presented as a capability refuses with ~
         cap1-unrecognized-object (presented-type recorded; the receipt ~
         that justified the mint is not the key it justified)"
  (lambda ()
    (handler-case
        (progn (show *a* *boot-a* *ctx* *receipt-at-p* "p-auth") nil)
      (cap1-unrecognized-object (condition)
        (and (not (eq 'live-capability
                      (cap1-unrecognized-object-presented-type condition)))
             (string= "alpha"
                      (cap1-unrecognized-object-context-label condition)))))))

(tcheck "the MINTING receipt presented as a capability refuses with ~
         cap1-unrecognized-object, and its claimed public identity is ~
         reported as a claim (the receipt names the key; naming is not ~
         holding)"
  (lambda ()
    (handler-case
        (progn (show *a* *boot-a* *ctx* *mint-receipt* "p-mintr") nil)
      (cap1-unrecognized-object (condition)
        (and (cap1-unrecognized-object-presented-public-id condition)
             (search "cap1-key"
                     (cap1-unrecognized-object-presented-public-id
                      condition)))))))

(defun counterfeit-of (object)
  "A struct with EVERY public field copied off OBJECT — built through the
lane's own internal constructor, reached deliberately via the :: hostile
path this test is entitled to as a same-package suite.  If description
could forge a key, this would be the forge."
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

(tcheck "a counterfeit with EVERY public field copied — built through the ~
         REAL internal constructor — refuses with cap1-unrecognized-object: ~
         recognition is EQ membership, so even the constructor grants ~
         nothing; only this context's own minting does"
  (lambda ()
    (let ((counterfeit (counterfeit-of *object*)))
      (and (live-capability-p counterfeit)
           (datum= (live-capability-public-id counterfeit)
                   (live-capability-public-id *object*))
           (not (context-recognizes-p *ctx* counterfeit))
           (expects cap1-unrecognized-object
             (show *a* *boot-a* *ctx* counterfeit "p-fake"))))))

(tcheck "a GENUINE capability presented to a DIFFERENT minting context ~
         refuses with cap1-unrecognized-object carrying the refusing ~
         context's label: recognition does not travel between recognizers"
  (lambda ()
    (let ((other (make-minting-context :label "beta")))
      (handler-case
          (progn (show *a* *boot-a* other *object* "p-cross") nil)
        (cap1-unrecognized-object (condition)
          (string= "beta"
                   (cap1-unrecognized-object-context-label condition)))))))

;;; ---------------------------------------------------------------------------
;;; 7. Staleness — the journal decides.

(append-event *a* (test-unrelated "u-001"))

(tcheck "after ANY journal advance the capability refuses as STALE: ~
         cap1-stale-capability names BOTH prefixes (binding ordinal 1 vs ~
         present ordinal 2; digests distinct; present digest equal to the ~
         fresh report's)"
  (lambda ()
    (handler-case
        (progn (show *a* *boot-a* *ctx* *object* "p-stale") nil)
      (cap1-stale-capability (condition)
        (and (eql 1 (cap1-stale-capability-capability-terminal-ordinal
                     condition))
             (eql 2 (cap1-stale-capability-present-terminal-ordinal
                     condition))
             (not (string= (cap1-stale-capability-capability-terminal-digest
                            condition)
                           (cap1-stale-capability-present-terminal-digest
                            condition)))
             (string= (cap1-stale-capability-present-terminal-digest
                       condition)
                      (prefix-report-terminal-digest
                       (validate-journal *a*))))))))

(tcheck "recognition is NOT liveness: after the stale refusal the context ~
         STILL recognizes the object (context-recognizes-p true) and ~
         presentation STILL refuses — the context recognizes; the journal ~
         decides"
  (lambda ()
    (and (context-recognizes-p *ctx* *object*)
         (expects cap1-stale-capability
           (show *a* *boot-a* *ctx* *object* "p-stale2")))))

(defvar *object-2* nil)

(tcheck "a fresh derivation re-mints at the moved prefix: NEW occurrence ~
         identity, NEW public identity (serial 2, different fresh-receipt ~
         sha), SAME grant event linked in both minting receipts — the ~
         authority lineage is the journal's, the key is this life's"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *a* *boot-a* *ctx*
                                 (ask *a* *boot-a* "clavis" "q-mint-2")
                                 :minter *minter-segments*)
      (setf *object-2* object)
      (and (not (datum= (live-capability-public-id object)
                        (live-capability-public-id *object*)))
           (not (datum= (live-capability-occurrence-id object)
                        (live-capability-occurrence-id *object*)))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (record-field *mint-receipt* "receipt" "grant-event-id"))
           (= 2 (live-capability-terminal-ordinal object))
           (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field (show *a* *boot-a* *ctx* object "p-002")
                                   "receipt" "decision")))))))

;;; ---------------------------------------------------------------------------
;;; 8. Mint refusals — the bridge trusts the fold, never the description.

(tcheck "a /0 REFUSAL receipt cannot authorize minting: ~
         cap1-mint-refused with basis :receipt-not-authorized (the refusal ~
         is truthful testimony AGAINST the mint)"
  (lambda ()
    (let ((refusal (ask *a* *boot-a* "umbra" "q-missing")))
      (and (eq :refused (receipt-decision refusal))
           (handler-case
               (progn (mint-from-authorization *a* *boot-a* *ctx* refusal
                                               :minter *minter-segments*)
                      nil)
             (cap1-mint-refused (condition)
               (eq :receipt-not-authorized
                   (cap1-mint-refused-basis condition))))))))

(tcheck "non-receipts cannot authorize minting: a grant EVENT, the MINTING ~
         receipt, and NIL each refuse with basis :not-an-authority-receipt"
  (lambda ()
    (flet ((refused-p (thing)
             (handler-case
                 (progn (mint-from-authorization *a* *boot-a* *ctx* thing
                                                 :minter *minter-segments*)
                        nil)
               (cap1-mint-refused (condition)
                 (eq :not-an-authority-receipt
                     (cap1-mint-refused-basis condition))))))
      (and (refused-p (test-grant :event-id '("cap0-event" "g-junk")))
           (refused-p *mint-receipt*)
           (refused-p nil)))))

(tcheck "a DOCTORED receipt — decision :authorized for a NEVER-GRANTED ~
         capability, bound to the CURRENT prefix — refuses with basis ~
         :fresh-derivation-refused, fresh reason capability-missing: the ~
         description claimed a key and the fold said no (the governing ~
         sentence, executed)"
  (lambda ()
    (let* ((report (validate-journal *a*))
           (forged (make-authority-receipt
                    :store *a* :report report
                    :decision :authorized
                    :reason "grant-live-at-validated-prefix"
                    :capability-id '("cap" "umbra")
                    :query-id '("cap0-query" "q-forged")
                    :subject *subject-segments*
                    :action *action-segments*
                    :resource *resource-segments*
                    :scope *scope-segments*)))
      (handler-case
          (progn (mint-from-authorization *a* *boot-a* *ctx* forged
                                          :minter *minter-segments*)
                 nil)
        (cap1-mint-refused (condition)
          (and (eq :fresh-derivation-refused
                   (cap1-mint-refused-basis condition))
               (string= "capability-missing"
                        (cap1-mint-refused-fresh-reason condition))
               (eq :refused (receipt-decision
                             (cap1-mint-refused-fresh-receipt
                              condition)))))))))

(tcheck "a STALE authorization receipt refuses the mint with /0's OWN ~
         cap0-stale-receipt naming both prefixes (ordinal 1 vs 2): the ~
         bridge inherits /0's present-receipt discipline unchanged"
  (lambda ()
    (handler-case
        (progn (mint-from-authorization *a* *boot-a* *ctx* *receipt-at-p*
                                        :minter *minter-segments*)
               nil)
      (cap0-stale-receipt (condition)
        (and (eql 1 (lisp-plus-capability0:cap0-stale-receipt-receipt-terminal-ordinal
                     condition))
             (eql 2 (lisp-plus-capability0:cap0-stale-receipt-present-terminal-ordinal
                     condition)))))))

(tcheck "/0's bootstrap refusals propagate through the bridge: minting with ~
         NIL bootstrap refuses cap0-bootstrap-missing; presentation with a ~
         wrong-store bootstrap refuses cap0-bootstrap-store-mismatch (this ~
         lane signals /0's exported types for the identical meaning)"
  (lambda ()
    (and (expects cap0-bootstrap-missing
           (mint-from-authorization *a* nil *ctx*
                                    (ask *a* *boot-a* "clavis" "q-boot")
                                    :minter *minter-segments*))
         (expects cap0-bootstrap-missing
           (present-live-capability *a* nil *ctx* *object-2*
                                    :presentation-id '("cap1-present"
                                                       "p-noboot")))
         (expects cap0-bootstrap-store-mismatch
           (present-live-capability
            *a* (declare-bootstrap-authority *issuer-segments*
                                             "pj0-store:aliena")
            *ctx* *object-2*
            :presentation-id '("cap1-present" "p-alien"))))))

;;; ---------------------------------------------------------------------------
;;; 9. No public constructor; no copier.

(tcheck "the object constructor is package-internal: %MAKE-LIVE-CAPABILITY ~
         exists with :internal status, MAKE-LIVE-CAPABILITY and ~
         COPY-LIVE-CAPABILITY do not exist at all, and NO external symbol ~
         of the package names a live-capability constructor or copier ~
         (package discipline shown, its limits named in the RETURN)"
  (lambda ()
    (multiple-value-bind (symbol status)
        (find-symbol "%MAKE-LIVE-CAPABILITY" :lisp-plus-capability1)
      (and symbol (eq :internal status)
           (null (find-symbol "MAKE-LIVE-CAPABILITY"
                              :lisp-plus-capability1))
           (null (find-symbol "COPY-LIVE-CAPABILITY"
                              :lisp-plus-capability1))
           (block scan
             (do-external-symbols (external :lisp-plus-capability1 t)
               (when (search "LIVE-CAPABILITY" (symbol-name external))
                 (unless (or (string= "LIVE-CAPABILITY-P"
                                      (symbol-name external))
                             (eql 0 (search "LIVE-CAPABILITY-"
                                            (symbol-name external)))
                             (string= "PRESENT-LIVE-CAPABILITY"
                                      (symbol-name external)))
                   (return-from scan nil)))))))))

;;; ---------------------------------------------------------------------------
;;; 10. Planted mutants — each killed.

(defvar *m-directory* (merge-pathnames "store-m/" *scratch*))
(defvar *m* (create-journal *m-directory*
                            :nonce-octets (t-ascii "cap1-selftest-m!")))
(defvar *boot-m* (declare-bootstrap-authority
                  *issuer-segments* (journal-store-store-id *m*)))
(append-event *m* (test-grant :event-id '("cap0-event" "g-m01")))
(defvar *ctx-m* (make-minting-context :label "mu"))
(defvar *object-m* (mint-from-authorization *m* *boot-m* *ctx-m*
                                            (ask *m* *boot-m* "clavis"
                                                 "q-m1")
                                            :minter *minter-segments*))

(tcheck "planted mutant :serializable-authority is KILLED: a mimic whose ~
         public identity was parsed back out of the genuine object's ~
         PRINTED form is refused by the strict path (unrecognized) and ~
         accepted by the mutant — printed testimony got up and unlocked ~
         the mutant's door, and only the mutant's"
  (lambda ()
    (let* ((printed (princ-to-string *object-m*))
           (start (+ (search "live-capability " printed) 16))
           (end (position #\> printed :from-end t))
           (id-string (subseq printed start end))
           (segments (loop with segment-start = 0
                           for index = (position #\: id-string
                                                 :start segment-start)
                           collect (subseq id-string segment-start index)
                           while index
                           do (setf segment-start (1+ index))))
           (mimic (counterfeit-of *object-m*)))
      ;; the mimic's public id IS the printed one (both copied truthfully).
      (and (datum= (live-capability-public-id mimic)
                   (identifier-from-segments segments))
           (multiple-value-bind (killed strict mutant)
               (run-mutant-kill :serializable-authority *m* *boot-m*
                                *ctx-m* mimic
                                :subject *subject-segments*
                                :action *action-segments*
                                :resource *resource-segments*
                                :scope *scope-segments*)
             (and killed
                  (eq :cap1-unrecognized-object strict)
                  (eq :presented mutant)))))))

(tcheck "planted mutant :public-constructor is KILLED: a hand-built struct ~
         with a foreign public identity is refused by the strict path and ~
         accepted by the type-recognizing mutant — constructing the struct ~
         must never be minting"
  (lambda ()
    (let ((forged (%make-live-capability
                   :public-id (identifier-from-segments
                               '("cap1-key" "forged" "99"))
                   :occurrence-id (identifier-from-segments
                                   '("cap1-mint" "forged" "99"))
                   :subject (live-capability-subject *object-m*)
                   :action (live-capability-action *object-m*)
                   :resource (live-capability-resource *object-m*)
                   :scope (live-capability-scope *object-m*)
                   :minter (live-capability-minter *object-m*)
                   :store-id (live-capability-store-id *object-m*)
                   :terminal-ordinal (live-capability-terminal-ordinal
                                      *object-m*)
                   :valid-byte-count (live-capability-valid-byte-count
                                      *object-m*)
                   :terminal-digest (live-capability-terminal-digest
                                     *object-m*))))
      (multiple-value-bind (killed strict mutant)
          (run-mutant-kill :public-constructor *m* *boot-m* *ctx-m* forged
                           :subject *subject-segments*
                           :action *action-segments*
                           :resource *resource-segments*
                           :scope *scope-segments*)
        (and killed
             (eq :cap1-unrecognized-object strict)
             (eq :presented mutant))))))

(tcheck "planted mutant :context-as-liveness-cache is KILLED: the journal ~
         advances under a minted key — the strict path refuses STALE ~
         (fresh validation, every presentation), the mutant still presents ~
         from recognition alone (the standing cache this lane forbids, ~
         demonstrated fatal; the control that kills it is a journal ~
         advance, the same vehicle a committed revocation rides in)"
  (lambda ()
    (append-event *m* (test-unrelated "u-m01"))
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :context-as-liveness-cache *m* *boot-m* *ctx-m*
                         *object-m*
                         :subject *subject-segments*
                         :action *action-segments*
                         :resource *resource-segments*
                         :scope *scope-segments*)
      (and killed
           (eq :cap1-stale-capability strict)
           (eq :presented mutant)))))

;;; ---------------------------------------------------------------------------
;;; 11. Nothing is written; nothing is journaled.

(tcheck "minting and presenting write NOTHING: EVENTS.pj0 is byte-identical ~
         (sha256) across a fresh mint, a successful presentation, a stale ~
         refusal, and a mint refusal — mint occurrences are process-local; ~
         the journaled facts remain /0's events (L9)"
  (lambda ()
    (let ((before (sha256-hex (t-read-octets
                               (merge-pathnames "EVENTS.pj0"
                                                *a-directory*)))))
      (let ((object (mint-from-authorization *a* *boot-a* *ctx*
                                             (ask *a* *boot-a* "clavis"
                                                  "q-ro")
                                             :minter *minter-segments*)))
        (show *a* *boot-a* *ctx* object "p-ro")
        (expects cap1-stale-capability
          (show *a* *boot-a* *ctx* *object* "p-ro-stale"))
        (expects cap1-mint-refused
          (mint-from-authorization *a* *boot-a* *ctx* *mint-receipt*
                                   :minter *minter-segments*)))
      (string= before
               (sha256-hex (t-read-octets
                            (merge-pathnames "EVENTS.pj0"
                                             *a-directory*)))))))

;;; ---------------------------------------------------------------------------
;;; 12. Gate teeth — this runner shown able to fail.

(when (sb-posix:getenv "CAP1_SELFTEST_PLANT_FAULT")
  (tcheck "PLANTED FAULT (CAP1_SELFTEST_PLANT_FAULT): this check is false ~
           by construction"
    (lambda () nil)))

(unless (sb-posix:getenv "CAP1_SELFTEST_PLANT_FAULT")
  (tcheck "gate teeth: this selftest CAN fail — a child run with a planted ~
           fault exits 1 and its transcript carries the FAIL line (a suite ~
           that has never been seen red certifies nothing)"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability1/capability1-selftest.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP1_SELFTEST_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text))))))

;;; ---------------------------------------------------------------------------
;;; Teardown + derived result.

(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%capability1-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
