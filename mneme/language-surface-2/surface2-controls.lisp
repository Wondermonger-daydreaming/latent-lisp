;;;; surface2-controls.lisp — Language Surface /2, the TEETH (contract §6):
;;;; every refusal fired live, every mutant killed, the Surface /1
;;;; negative control run against the REAL Surface /1.
;;;;
;;;; A gate that has never fired is untested, not passing.
;;;;
;;;; Run:  sbcl --script mneme/language-surface-2/surface2-controls.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; Loads (all READ-ONLY to this lane): surface2.lisp; the real
;;;; Surface /1 (mneme/language-surface-1/surface1.lisp, for the negative
;;;; control); the census-only Vertical /0 chain (for the predecessor
;;;; reader whose one-NIL this lane's typed readings are measured
;;;; against).  Mutated fixtures are SYNTHESIZED in a scratch store under
;;;; /tmp — the preserved campaign-1 journal is never appended to, and its
;;;; digest is compared before/after.
;;;;
;;;; DETERMINISM: nothing time-, pid-, or path-dependent is printed.
;;;; Gate teeth: SURFACE2_CONTROLS_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; SURFACE2_CONTROLS_DIE=1 exits 3 mid-run, no RESULT sentinel.
;;;;
;;;; — GLOSSATOR (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "surface2.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../language-surface-1/surface1.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../vertical0/reconstruction/load-census-only.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:surface2-controls
  (:use #:cl #:lisp-plus-surface2))
(in-package #:surface2-controls)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[C~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[C~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defun refusal-of (thunk)
  "The RETAINED refusal object a thunk's refusal carries, or NIL."
  (handler-case (progn (funcall thunk) nil)
    (surface2-expansion-refused (c) (expansion-condition-refusal c))))

(defun code-of (thunk)
  (let ((r (refusal-of thunk)))
    (and r (expansion-refusal-code r))))

(note "surface2-controls — the teeth, each fired live")

;;; ---------------------------------------------------------------------------
(note "~%== fixtures ==")

(defvar *exec*
  (merge-pathnames "../vertical0/runs/campaign-1/exec/"
                   (make-pathname :name nil :type nil
                                  :defaults *load-truename*)))

(defun file-sha256 (pathname)
  (with-open-file (s pathname :element-type '(unsigned-byte 8))
    (let ((octets (make-array (file-length s)
                              :element-type '(unsigned-byte 8))))
      (read-sequence octets s)
      (lisp-plus-journal0:sha256-hex octets))))

(defvar *journal-digest-before*
  (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))

(defvar *store* (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" *exec*)))
(defvar *config* (lisp-plus-vertical0:read-vertical-config
                  (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" *exec*)))
(defvar *events* (validated-store-events *store*))

;;; The census truth, derived by the UNTOUCHED old path in this process.
(defvar *census-truth* (lisp-plus-vertical0:census-outcomes *store* *config*))

(defun truth-of (seat-id)
  (find seat-id *census-truth*
        :key (lambda (plist) (getf plist :seat)) :test #'equal))

(defun outcome-of (seat-id) (derive-seat-outcome *store* *events* seat-id))

(check "1 the untouched census path yields the twelve campaign seats"
  (lambda () (= 12 (length *census-truth*))))

;;; ---------------------------------------------------------------------------
(note "~%== expansion-time structural refusals, each fired ==")

(check "2 :NON-EXHAUSTIVE-MATCH fires — a match without OTHERWISE refuses ~
        AT EXPANSION, with the code retained on the refusal object"
  (lambda ()
    (let ((r (refusal-of (lambda ()
                           (macroexpand-1
                            '(match-outcome o ((:execution :settled) 1)))))))
      (and r (eq :non-exhaustive-match (expansion-refusal-code r))
           (eq :expansion (expansion-refusal-phase r))
           (eq :protocol-refusal (expansion-refusal-category r))))))

(check "3 :NON-EXHAUSTIVE-MATCH also fires for the empty match"
  (lambda ()
    (eq :non-exhaustive-match
        (code-of (lambda () (macroexpand-1 '(match-outcome o)))))))

(check "4 :DUPLICATE-PATTERN fires — one pattern written twice"
  (lambda ()
    (eq :duplicate-pattern
        (code-of (lambda ()
                   (macroexpand-1 '(match-outcome o
                                    ((:execution :settled) 1)
                                    ((:execution :settled) 2)
                                    (otherwise 3))))))))

(check "5 :DUPLICATE-PATTERN sees through spelling: a conjunction in a ~
        different order and a refusal name as symbol vs string are ONE ~
        pattern"
  (lambda ()
    (and (eq :duplicate-pattern
             (code-of (lambda ()
                        (macroexpand-1
                         '(match-outcome o
                           ((:and (:execution :settled) (:provenance :live)) 1)
                           ((:and (:provenance :live) (:execution :settled)) 2)
                           (otherwise 3))))))
         (eq :duplicate-pattern
             (code-of (lambda ()
                        (macroexpand-1
                         '(match-outcome o
                           ((:refusal budget-ceiling-exceeded) 1)
                           ((:refusal "budget-ceiling-exceeded") 2)
                           (otherwise 3)))))))))

(check "6 :UNREACHABLE-PATTERN fires — a narrower conjunction after its ~
        wider prefix can never run"
  (lambda ()
    (eq :unreachable-pattern
        (code-of (lambda ()
                   (macroexpand-1 '(match-outcome o
                                    ((:execution :settled) 1)
                                    ((:and (:execution :settled)
                                           (:provenance :live)) 2)
                                    (otherwise 3))))))))

(check "7 :UNREACHABLE-PATTERN fires for a clause written after OTHERWISE"
  (lambda ()
    (eq :unreachable-pattern
        (code-of (lambda ()
                   (macroexpand-1 '(match-outcome o
                                    ((:execution :settled) 1)
                                    (otherwise 2)
                                    ((:provenance :live) 3))))))))

(check "8 :PATTERN-NOT-IN-GRAMMAR fires on the forbidden-inference ~
        vocabulary — :success, :truth, :retry-safe, :cost do not exist ~
        as axes and cannot be minted from outside"
  (lambda ()
    (every (lambda (pattern)
             (eq :pattern-not-in-grammar
                 (code-of (lambda ()
                            (macroexpand-1
                             `(match-outcome o (,pattern 1) (otherwise 2)))))))
           '((:success t) (:truth t) (:retry-safe t) (:cost 0)
             (:execution-from-manifestation "present")))))

(check "9 :PATTERN-NOT-IN-GRAMMAR fires on an unlawful value for a known ~
        axis (:execution :flourished is no cap2 standing)"
  (lambda ()
    (eq :pattern-not-in-grammar
        (code-of (lambda ()
                   (macroexpand-1 '(match-outcome o
                                    ((:execution :flourished) 1)
                                    (otherwise 2))))))))

(check "10 :MATCH-VAR-NOT-A-SYMBOL, :WITH-OUTCOME-BINDING-MALFORMED and ~
        :FACET-BINDING-MALFORMED each fire"
  (lambda ()
    (and (eq :match-var-not-a-symbol
             (code-of (lambda ()
                        (macroexpand-1 '(match-outcome 42 (otherwise 1))))))
         (eq :with-outcome-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1 '(with-outcome (:o (list)) 1)))))
         (eq :facet-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1 '(match-outcome o
                                         ((:execution :settled)
                                          :facets ((x :no-such-axis)) x)
                                         (otherwise 2)))))))))

;;; ---------------------------------------------------------------------------
(note "~%== the runtime typed refusal ==")

(check "11 SURFACE2-NOT-AN-OUTCOME fires when WITH-OUTCOME binds a ~
        non-outcome, carries code :NOT-A-SEAT-OUTCOME, and IS a ~
        SURFACE2-EXPANSION-REFUSED (one handler catches the family)"
  (lambda ()
    (handler-case (progn (with-outcome (o (list 1 2)) o) nil)
      (surface2-not-an-outcome (c)
        (and (typep c 'surface2-expansion-refused)
             (eq :not-a-seat-outcome
                 (expansion-refusal-code (expansion-condition-refusal c))))))))

(check "12 MATCH-OUTCOME refuses the same way on a non-outcome — never a ~
        silent NIL dispatch"
  (lambda ()
    (handler-case (let ((o 42))
                    (match-outcome o ((:execution :settled) 1) (otherwise 2))
                    nil)
      (surface2-not-an-outcome (c)
        (eq :not-a-seat-outcome
            (expansion-refusal-code (expansion-condition-refusal c)))))))

;;; ---------------------------------------------------------------------------
(note "~%== door-phase refusals, each fired ==")

(defvar *tag* (lisp-plus-journal0:identifier-from-segments
               '("surface2-controls" "occurrence" "c1")))

(check "13 request-phase refusals fire: not-a-call, head-not-a-symbol, ~
        operation-not-declared, occurrence-tag-not-identifier"
  (lambda ()
    (and (eq :source-form-not-a-call
             (code-of (lambda () (request-expansion 42 :macroexpand-1 *tag*))))
         (eq :source-form-head-not-a-symbol
             (code-of (lambda () (request-expansion '((1) 2) :macroexpand-1
                                                    *tag*))))
         (eq :operation-not-declared
             (code-of (lambda () (request-expansion '(cl:list) :expand *tag*))))
         (eq :occurrence-tag-not-identifier
             (code-of (lambda () (request-expansion '(cl:list) :macroexpand-1
                                                    "not-a-datum")))))))

(check "14 term-grammar refusals fire: an unrepresentable term, shared ~
        structure, the depth ceiling, the node ceiling, the octet ceiling"
  (lambda ()
    (let ((shared (let ((cell (list 1))) (list 'head cell cell)))
          (deep (let ((form 'x))
                  (dotimes (i 60 form) (setf form (list form)))))
          (wide (cons 'head (make-list 20001 :initial-element 1)))
          (fat (list 'head (make-string 262200 :initial-element #\a))))
      (and (eq :source-term-unrepresentable
               (code-of (lambda () (request-expansion (list 'head #(1 2))
                                                      :macroexpand-1 *tag*))))
           (eq :source-term-shared-structure
               (code-of (lambda () (request-expansion shared :macroexpand-1
                                                      *tag*))))
           (eq :source-depth-exceeded
               (code-of (lambda () (request-expansion (list 'head deep)
                                                      :macroexpand-1 *tag*))))
           (eq :source-nodes-exceeded
               (code-of (lambda () (request-expansion wide :macroexpand-1
                                                      *tag*))))
           (eq :source-term-octets-exceeded
               (code-of (lambda () (request-expansion fat :macroexpand-1
                                                      *tag*))))))))

(check "15 :NOT-A-KNOWN-SURFACE2-CONSTRUCT fires at Door 2 for a head ~
        outside the two-row table, and NOTHING is minted"
  (lambda ()
    (let ((request (request-expansion '(cl:list 1 2) :macroexpand-1 *tag*)))
      (multiple-value-bind (receipt expanded refusal)
          (try-perform-expansion request)
        (and (null receipt) (null expanded) refusal
             (eq :not-a-known-surface2-construct
                 (expansion-refusal-code refusal)))))))

(check "16 :SOURCE-NOT-RECONSTRUCTIBLE fires publicly: a head whose home ~
        package is deleted between the doors leaves a datum this image ~
        can no longer rebuild"
  (lambda ()
    (let* ((pkg (make-package '#:surface2-victim :use nil))
           (head (intern "VANISHING-HEAD" pkg))
           (request (request-expansion (list head 1) :macroexpand-1 *tag*)))
      (delete-package pkg)
      (eq :source-not-reconstructible
          (code-of (lambda () (perform-expansion request)))))))

(check "17 a structurally refused MATCH-OUTCOME refuses through the doors ~
        too: try-perform on a non-exhaustive match answers ~
        (NIL NIL refusal) with :NON-EXHAUSTIVE-MATCH — nothing minted ~
        for a refused expansion"
  (lambda ()
    (let ((request (request-expansion
                    '(lisp-plus-surface2:match-outcome o
                      ((:execution :settled) 1))
                    :macroexpand-1 *tag*)))
      (multiple-value-bind (receipt expanded refusal)
          (try-perform-expansion request)
        (and (null receipt) (null expanded) refusal
             (eq :non-exhaustive-match (expansion-refusal-code refusal)))))))

;;; ---------------------------------------------------------------------------
(note "~%== receipt integrity alarms, fired through the planted-fault hooks ==")

(defvar *lawful-form*
  '(lisp-plus-surface2:match-outcome o
    ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id o))
    (otherwise o)))

(check "18 :SOURCE-IDENTITY-PROJECTION-MISMATCH fires when the planted ~
        fault feeds the mint a foreign source identity"
  (lambda ()
    (let ((request (request-expansion *lawful-form* :macroexpand-1 *tag*))
          (lisp-plus-surface2::*%fault-source-identity*
            (lisp-plus-surface2::%identity
             (lisp-plus-surface2::%text "not the source"))))
      (eq :source-identity-projection-mismatch
          (code-of (lambda () (perform-expansion request)))))))

(check "19 :EXPANDED-IDENTITY-PROJECTION-MISMATCH fires the same way on ~
        the expanded side"
  (lambda ()
    (let ((request (request-expansion *lawful-form* :macroexpand-1 *tag*))
          (lisp-plus-surface2::*%fault-expanded-identity*
            (lisp-plus-surface2::%identity
             (lisp-plus-surface2::%text "not the expansion"))))
      (eq :expanded-identity-projection-mismatch
          (code-of (lambda () (perform-expansion request)))))))

(check "20 the missing-receipt mutant is CAUGHT: with the skip-receipt ~
        fault planted, the perform answers no receipt and VERIFY-RECEIPT ~
        refuses :RECEIPT-NOT-MINTED — the checking discipline, not luck"
  (lambda ()
    (let ((request (request-expansion *lawful-form* :macroexpand-1 *tag*))
          (lisp-plus-surface2::*%fault-skip-receipt* t))
      (multiple-value-bind (receipt expanded) (perform-expansion request)
        (and (null receipt) (consp expanded)
             (eq :receipt-not-minted
                 (code-of (lambda () (verify-receipt receipt)))))))))

(check "21 without the fault the SAME request mints, and the receipt's ~
        digests re-derive"
  (lambda ()
    (let ((request (request-expansion *lawful-form* :macroexpand-1 *tag*)))
      (multiple-value-bind (receipt) (perform-expansion request)
        (verify-receipt receipt)))))

;;; ---------------------------------------------------------------------------
(note "~%== the payload-or-NIL planted defect (contract §6) ==")

(defvar *half-song* (outcome-of "seat-half-song"))

(defun full-bodied-match (o)
  (match-outcome o
    ((:evidence-class :closure) :facets ((chunks :chunks-preserved))
     (list :closed (seat-outcome-seat-id o) chunks
           (seat-outcome-execution-standing o)))
    (otherwise :other)))

(check "22 the TRUE expansion keeps the parent outcome bound: the body ~
        reads seat id, chunk custody AND the execution axis from it"
  (lambda ()
    (equal '(:closed "seat-half-song" 1 :settled)
           (full-bodied-match *half-song*))))

(check "23 the payload-or-NIL mutant is the planted defect and it is ~
        KILLED: under the fault hook the same match collapses to the bare ~
        manifestation string — seat id, chunk custody and execution axis ~
        all lost — and the comparison against the true result catches it"
  (lambda ()
    (let* ((mutant
             (let ((lisp-plus-surface2::*%fault-project-payload-or-nil* t))
               (eval '(lambda (o)
                       (lisp-plus-surface2:match-outcome o
                         ((:evidence-class :closure)
                          :facets ((chunks :chunks-preserved))
                          (list :closed
                                (lisp-plus-surface2:seat-outcome-seat-id o)
                                chunks))
                         (otherwise :other))))))
           (mutant-result (funcall mutant *half-song*))
           (true-result (full-bodied-match *half-song*)))
      (and (equal mutant-result "present-partial")
           (not (equal mutant-result true-result))
           (not (member 1 (list mutant-result)))
           (not (search "seat-half-song" mutant-result))))))

;;; ---------------------------------------------------------------------------
(note "~%== mutant classifiers killed against the census truth ==")

(check "24 branch-discarding-the-effect-axis is KILLED on seat-half-song: ~
        a mutant that consumes manifestation \"present-partial\" and ~
        writes the effect conclusion \"settled\" contradicts the census ~
        truth \"crossed-unsettled-partial-closed\""
  (lambda ()
    (let* ((mutant-claim
             (let ((m (nth-value 0 (seat-outcome-manifestation *half-song*))))
               ;; the mutant: any present* manifestation => effect settled
               (when (eql 0 (search "present" m)) "settled")))
           (truth (getf (truth-of "seat-half-song") :effect)))
      (and (equal mutant-claim "settled")
           (equal truth "crossed-unsettled-partial-closed")
           (not (equal mutant-claim truth))))))

(check "25 absent-manifestation-means-failed-execution is KILLED on ~
        seat-burned-draft: manifestation reads \"absent\" while the ~
        execution axis holds :SETTLED — the mutant's verdict contradicts ~
        the retained axis"
  (lambda ()
    (let* ((draft (outcome-of "seat-burned-draft"))
           (mutant-claim
             (when (equal "absent"
                          (nth-value 0 (seat-outcome-manifestation draft)))
               :execution-failed)))
      (and (eq mutant-claim :execution-failed)
           (eq :settled (seat-outcome-execution-standing draft))
           (equal "settled" (getf (truth-of "seat-burned-draft") :effect))))))

(check "26 present-invalid-treated-as-absence is KILLED on ~
        seat-broken-glass: the census truth says \"present-invalid\", the ~
        outcome retains it :PRESENT with interpretation \"invalid\" — the ~
        mutant's \"absent\" is a different fact"
  (lambda ()
    (let* ((glass (outcome-of "seat-broken-glass"))
           (mutant-claim "absent")
           (truth (getf (truth-of "seat-broken-glass") :manifestation)))
      (and (equal truth "present-invalid")
           (multiple-value-bind (v s) (seat-outcome-manifestation glass)
             (and (equal v "present-invalid") (eq s :present)))
           (equal "invalid"
                  (nth-value 0 (seat-outcome-interpretation-class glass)))
           (not (equal mutant-claim truth))))))

;;; ---------------------------------------------------------------------------
(note "~%== retry of an uncertain effect: exposure, not affordance ==")

(check "27 the surface EXPOSES :UNCERTAIN-UNRESOLVED on seat-torn-crossing ~
        and the CAP2-W1 pre-declaration scan still REFUSES a fresh ~
        dispatch over durable bytes alone"
  (lambda ()
    (let ((torn (outcome-of "seat-torn-crossing")))
      (and (eq :uncertain-unresolved (seat-outcome-execution-standing torn))
           (handler-case
               (progn (lisp-plus-capability2:check-retry-safety-from-store
                       *store* :seat-name "seat-torn-crossing"
                       :candidate-attempt-name "a-seat-torn-crossing-surface2-scan")
                      nil)
             (lisp-plus-kernel0:unsafe-retry () t))))))

(check "28 the surface adds NO retry affordance: no exported symbol of ~
        LISP-PLUS-SURFACE2 speaks of retry, resume or dispatch"
  (lambda ()
    (let ((offenders nil))
      (do-external-symbols (symbol '#:lisp-plus-surface2)
        (let ((name (symbol-name symbol)))
          (when (or (search "RETRY" name) (search "RESUME" name)
                    (search "DISPATCH" name))
            (push symbol offenders))))
      (null offenders))))

;;; ---------------------------------------------------------------------------
(note "~%== the synthesized scratch store: typed readings vs the one-NIL ==")

(defvar *scratch* #p"/tmp/surface2-controls-scratch/")
(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(defun id* (&rest segments)
  (lisp-plus-journal0:identifier-from-segments segments))
(defun str* (s) (lisp-plus-cd0:make-string-datum s))
(defun rec* (&rest pairs)
  (lisp-plus-cd0:make-record-datum
   (loop for (key datum) on pairs by #'cddr
         collect (lisp-plus-cd0:make-record-entry
                  (lisp-plus-journal0:identifier-from-segments key)
                  datum))))

(defvar *sstore*
  (lisp-plus-journal0:create-journal
   (merge-pathnames "store/" *scratch*)
   :nonce-octets (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                      "surface2-control")))

;; seat-wrong-type: a stream closure whose chunk-custody field is a STRING.
(lisp-plus-journal0:append-event
 *sstore*
 (rec* '("event" "event-id") (id* "vertical-event"
                                  "e-seat-wrong-type-stream-closure")
       '("event" "kind") (id* "vertical-record" "stream-closure")
       '("event" "origin") (id* "origin" "asserted")
       '("event" "body") (rec* '("vertical" "seat-id") (str* "seat-wrong-type")
                               '("vertical" "chunks-preserved") (str* "one"))))

;; seat-no-field: a stream closure with NO chunk-custody field at all.
(lisp-plus-journal0:append-event
 *sstore*
 (rec* '("event" "event-id") (id* "vertical-event"
                                  "e-seat-no-field-stream-closure")
       '("event" "kind") (id* "vertical-record" "stream-closure")
       '("event" "origin") (id* "origin" "asserted")
       '("event" "body") (rec* '("vertical" "seat-id") (str* "seat-no-field"))))

;; seat-poison2: cap2 prepared + frontier-crossed, nothing after — the
;; attempt stands :CROSSED-UNSETTLED in durable evidence.
(lisp-plus-journal0:append-event
 *sstore*
 (rec* '("event" "event-id") (id* "cap2-event" "e-a-seat-poison2-prepared")
       '("event" "kind") (id* "attempt" "prepared")
       '("event" "attempt") (id* "attempt" "a-seat-poison2")
       '("event" "body") (rec* '("cap2" "note") (str* "synthesized"))))
(lisp-plus-journal0:append-event
 *sstore*
 (rec* '("event" "event-id") (id* "cap2-event" "e-a-seat-poison2-frontier")
       '("event" "kind") (id* "attempt" "frontier-crossed")
       '("event" "attempt") (id* "attempt" "a-seat-poison2")
       '("event" "body") (rec* '("cap2" "note") (str* "synthesized"))))

(defvar *sevents* (validated-store-events *sstore*))

(check "29 wrong-typed field vs absent field are DIFFERENT answers here: ~
        a string in the chunk-custody slot reads ~
        :MALFORMED-IN-EVIDENCE, a missing slot reads ~
        :ABSENT-FROM-EVIDENCE"
  (lambda ()
    (let ((wrong (derive-seat-outcome *sstore* *sevents* "seat-wrong-type"))
          (missing (derive-seat-outcome *sstore* *sevents* "seat-no-field")))
      (and (multiple-value-bind (v s) (seat-outcome-chunks-preserved wrong)
             (and (null v) (eq s :malformed-in-evidence)))
           (multiple-value-bind (v s) (seat-outcome-chunks-preserved missing)
             (and (null v) (eq s :absent-from-evidence)))))))

(check "30 the predecessor reader CANNOT tell them apart: BODY-INTEGER ~
        answers one NIL for both bodies — the pun this surface makes ~
        structurally impossible, demonstrated on the same bytes"
  (lambda ()
    (flet ((closure-body (seat)
             (lisp-plus-vertical0::event-body
              (lisp-plus-vertical0::find-event
               *sevents*
               :event-id (format nil "vertical-event:e-~a-stream-closure"
                                 seat)))))
      (and (null (lisp-plus-vertical0::body-integer
                  (closure-body "seat-wrong-type") "vertical"
                  "chunks-preserved"))
           (null (lisp-plus-vertical0::body-integer
                  (closure-body "seat-no-field") "vertical"
                  "chunks-preserved"))))))

(check "31 the surface exposes :CROSSED-UNSETTLED as itself on the ~
        synthesized seat — never softened into a completion or a failure"
  (lambda ()
    (let ((poison (derive-seat-outcome *sstore* *sevents* "seat-poison2")))
      (and (eq :crossed-unsettled (seat-outcome-execution-standing poison))
           (multiple-value-bind (v s) (seat-outcome-manifestation poison)
             (and (null v) (eq s :absent-from-evidence)))
           (eq :none (seat-outcome-evidence-class poison))))))

;;; ---------------------------------------------------------------------------
(note "~%== the forbidden-vocabulary guard, fired ==")

(check "32 the lexical guard FIRES on a planted dirty disposition string ~
        and stays quiet on a clean one"
  (lambda ()
    (and (handler-case
             (progn (surface2-vocabulary-guard
                     (list "a verified disposition") :context "planted")
                    nil)
           (error () t))
         (handler-case
             (progn (surface2-vocabulary-guard
                     (list "a planted hyphenated well-repaired title")
                     :context "planted")
                    nil)
           (error () t))
         (surface2-vocabulary-guard
          (list "expanded-once" "what form became what other form")
          :context "clean sample"))))

;;; ---------------------------------------------------------------------------
(note "~%== the Surface /1 negative control: the REAL Surface /1 refuses ~
       this lane's heads ==")

(defvar *s1-tag* (lisp-plus-cd0:make-identifier-datum
                  '("surface2-controls") '("s1-negative")))

(defvar *s1-request* nil)

(check "33 the real Surface /1 Door 1 mints a request for a MATCH-OUTCOME ~
        form (an unknown head is a lawful request; it has no construct ~
        identity to record)"
  (lambda ()
    (setf *s1-request*
          (lisp-plus-surface1:request-expansion
           '(lisp-plus-surface2:match-outcome o
             ((:execution :settled) 1)
             (otherwise 2))
           :macroexpand-1 *s1-tag*))
    (and (lisp-plus-surface1:expansion-request-p *s1-request*)
         (null (lisp-plus-surface1:expansion-request-construct-identity
                *s1-request*)))))

(check "34 the real Surface /1 Door 2 REFUSES it ~
        :NOT-A-KNOWN-SURFACE-CONSTRUCT — no receipt, no expansion, no ~
        occurrence minted; the refusal object is retained with phase ~
        :PERFORM"
  (lambda ()
    (multiple-value-bind (receipt expanded refusal)
        (lisp-plus-surface1:try-perform-expansion *s1-request*)
      (and (null receipt) (null expanded)
           (lisp-plus-surface1:expansion-refusal-p refusal)
           (eq :not-a-known-surface-construct
               (lisp-plus-surface1:expansion-refusal-code refusal))
           (eq :perform (lisp-plus-surface1:expansion-refusal-phase refusal))))))

(check "35 the signalling door agrees: PERFORM-EXPANSION raises Surface ~
        /1's own EXPANSION-REFUSED carrying the same code — and ~
        WITH-OUTCOME refuses identically"
  (lambda ()
    (flet ((s1-code (form)
             (handler-case
                 (progn (lisp-plus-surface1:perform-expansion
                         (lisp-plus-surface1:request-expansion
                          form :macroexpand-1 *s1-tag*))
                        nil)
               (lisp-plus-surface1:expansion-refused (c)
                 (lisp-plus-surface1:expansion-refusal-code
                  (lisp-plus-surface1:expansion-condition-refusal c))))))
      (and (eq :not-a-known-surface-construct
               (s1-code '(lisp-plus-surface2:match-outcome o (otherwise 1))))
           (eq :not-a-known-surface-construct
               (s1-code '(lisp-plus-surface2:with-outcome (o (cl:list)) o)))))))

;;; ---------------------------------------------------------------------------
(note "~%== read-only proof ==")

(check "36 the campaign-1 journal's bytes are untouched by everything ~
        above (the scratch store took every append)"
  (lambda ()
    (equal *journal-digest-before*
           (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "SURFACE2_CONTROLS_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "SURFACE2_CONTROLS_DIE") "1")
  (note "SURFACE2_CONTROLS_DIE=1 — dying mid-run WITHOUT a RESULT ~
         sentinel (planted truncation)")
  (sb-ext:exit :code 3))

(unless (equal (sb-ext:posix-getenv "SURFACE2_CONTROLS_PLANT_FAULT") "1")
  (check "37 the planted-fault gate FIRES: a child with ~
          SURFACE2_CONTROLS_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "SURFACE2_CONTROLS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "38 runner truncation is detectable as exactly the pair (exit 3, ~
          no RESULT sentinel): a child with SURFACE2_CONTROLS_DIE=1"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "SURFACE2_CONTROLS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------
;;; Scratch hygiene: the mutated fixtures do not outlive the run.
(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%surface2-controls: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
