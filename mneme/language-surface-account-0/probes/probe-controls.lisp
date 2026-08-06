;;;; probe-controls.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE FIXED CONTROLS, part A: controls 1, 2, 3, 4, 5 and 7.  Control 6
;;;; redefines provider declarations and therefore runs in an image of its own
;;;; (probe-control-6.lisp).
;;;;
;;;; NO FURTHER TEETH ARE ADDED HERE.  The commission fixes seven and forbids an
;;;; eighth without an explicit defect finding; nothing below is an eighth.
;;;;
;;;; EVERY CONTROL HAS TWO ARMS AND SHOWS ITS PLANTED ARM FIRING.  A gate that
;;;; has never fired is untested, not passing — so each control SHOWS the fault
;;;; being detected beside its clean case.  (For the route-mutation detector,
;;;; Control 4, the quiescent clean arm necessarily runs first: a detector must
;;;; be shown silent before the mutation is planted.)  A clean
;;;; arm alone would be a green with nothing behind it.

(in-package #:cl-user)

;;; ==========================================================================
;;; CONTROL 1 — a same-print-name head from the WRONG package is FOREIGN.
;;; ==========================================================================

(defparameter *derive-case-text*
  "(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
     (lisp-plus-slice1:derive :schema-name :x)
     (:granted cl-user::c) (:refused (cl-user::e) cl-user::e))")

(defparameter *match-outcome-text*
  "(lisp-plus-surface2:match-outcome cl-user::o
     ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id cl-user::o))
     (otherwise cl-user::o))")

(defun control-1 ()
  (rule #\=)
  (p "CONTROL 1 — a same-print-name head from the WRONG package is FOREIGN")
  (rule #\=)
  (let* ((scratch (scratch-package))
         (fake-derive-case (intern "DERIVE-CASE" scratch))
         (fake-match-outcome (intern "MATCH-OUTCOME" scratch)))
    (kv "scratch package" (package-name scratch))
    (kv "scratch symbol 1" (format nil "~A:~A" (package-name (symbol-package fake-derive-case))
                                   (symbol-name fake-derive-case)))
    (kv "print-names identical to admitted heads"
        (and (string= (symbol-name fake-derive-case) "DERIVE-CASE")
             (string= (symbol-name fake-match-outcome) "MATCH-OUTCOME")))
    ;; ---- PLANTED ARM: the impostors ----
    (arm "PLANTED" "the two impostor heads are presented to the head-keying")
    (kv "S1 construct-identity-for(SA0-PROBE-SCRATCH, DERIVE-CASE)"
        (or (lisp-plus-surface1:construct-identity-for "SA0-PROBE-SCRATCH" "DERIVE-CASE")
            "NIL — FOREIGN"))
    (kv "S2 surface2-construct-identity-for(SA0-PROBE-SCRATCH, MATCH-OUTCOME)"
        (or (lisp-plus-surface2:surface2-construct-identity-for "SA0-PROBE-SCRATCH" "MATCH-OUTCOME")
            "NIL — FOREIGN"))
    (probe-check "C1-PLANTED-S1-NO-IDENTITY" "C1 planted: S1 head-keying returns NO identity for the impostor"
                 (null (lisp-plus-surface1:construct-identity-for "SA0-PROBE-SCRATCH" "DERIVE-CASE")))
    (probe-check "C1-PLANTED-S2-NO-IDENTITY" "C1 planted: S2 head-keying returns NO identity for the impostor"
                 (null (lisp-plus-surface2:surface2-construct-identity-for "SA0-PROBE-SCRATCH" "MATCH-OUTCOME")))
    ;; and drive the real doors with an impostor-headed form
    (let* ((real (read-fixture *derive-case-text*))
           (impostor (cons fake-derive-case (cdr real)))
           (req (lisp-plus-surface1:request-expansion impostor :macroexpand-1 (tag-for "c1-s1"))))
      (kv "S1 Door 1 on impostor" "ACCEPTED (an unperformable request is still lawful)")
      (kv "S1 request construct-identity"
          (or (lisp-plus-surface1:expansion-request-construct-identity req) "NIL — FOREIGN"))
      (multiple-value-bind (receipt expanded refusal)
          (lisp-plus-surface1:try-perform-expansion req)
        (declare (ignore expanded))
        (kv "S1 Door 2 on impostor" (if receipt "RECEIPT (WRONG)" "REFUSED"))
        (when refusal
          (kv "  code" (lisp-plus-surface1:expansion-refusal-code refusal))
          (kv "  detail" (lisp-plus-surface1:expansion-refusal-detail refusal)))
        (probe-check "C1-PLANTED-S1-DOOR2-REFUSES" "C1 planted: S1 Door 2 REFUSES the impostor and mints nothing"
                     (and (null receipt) refusal))))
    (let* ((real2 (read-fixture *match-outcome-text*))
           (impostor2 (cons fake-match-outcome (cdr real2)))
           (req2 (lisp-plus-surface2:request-expansion impostor2 :macroexpand-1 (tag-for "c1-s2"))))
      (multiple-value-bind (receipt expanded refusal)
          (lisp-plus-surface2:try-perform-expansion req2)
        (declare (ignore expanded))
        (kv "S2 Door 2 on impostor" (if receipt "RECEIPT (WRONG)" "REFUSED"))
        (when refusal
          (kv "  code" (lisp-plus-surface2:expansion-refusal-code refusal)))
        (probe-check "C1-PLANTED-S2-DOOR2-REFUSES" "C1 planted: S2 Door 2 REFUSES the impostor and mints nothing"
                     (and (null receipt) refusal))))
    ;; ---- CLEAN ARM: the genuine heads ----
    (arm "CLEAN" "the genuine heads, same print-names, right packages")
    (probe-check "C1-CLEAN-S1-HEAD-IDENTIFIED" "C1 clean: S1 head-keying DOES identify LISP-PLUS-SURFACE0:DERIVE-CASE"
                 (not (null (lisp-plus-surface1:construct-identity-for
                             "LISP-PLUS-SURFACE0" "DERIVE-CASE"))))
    (probe-check "C1-CLEAN-S2-HEAD-IDENTIFIED" "C1 clean: S2 head-keying DOES identify LISP-PLUS-SURFACE2:MATCH-OUTCOME"
                 (not (null (lisp-plus-surface2:surface2-construct-identity-for
                             "LISP-PLUS-SURFACE2" "MATCH-OUTCOME"))))
    (probe-check "C1-CLEAN-S1-RECEIPT-MINTED" "C1 clean: S1 Door 2 mints a receipt for the genuine head"
                 (lisp-plus-surface1:expansion-receipt-p
                  (lisp-plus-surface1:perform-expansion
                   (lisp-plus-surface1:request-expansion
                    (read-fixture *derive-case-text*) :macroexpand-1 (tag-for "c1-clean-s1")))))))

;;; ==========================================================================
;;; CONTROL 2 — an unrelated INSTALLED HOST MACRO is FOREIGN.
;;; ==========================================================================

(defun control-2 ()
  (rule #\=)
  (p "CONTROL 2 — an unrelated installed host macro is FOREIGN")
  (rule #\=)
  (let ((form (read-fixture "(cl:when cl-user::x cl-user::y)")))
    (kv "the host macro" "COMMON-LISP:WHEN")
    (kv "it IS a live macro in this image" (and (macro-function 'cl:when) t))
    (arm "PLANTED" "a genuinely installed, genuinely unrelated host macro")
    (multiple-value-bind (receipt expanded refusal)
        (lisp-plus-surface1:try-perform-expansion
         (lisp-plus-surface1:request-expansion form :macroexpand-1 (tag-for "c2-s1")))
      (declare (ignore expanded))
      (kv "S1 Door 2 on CL:WHEN" (if receipt "RECEIPT (WRONG)" "REFUSED"))
      (when refusal (kv "  code" (lisp-plus-surface1:expansion-refusal-code refusal)))
      (probe-check "C2-PLANTED-S1-REFUSES-CL-WHEN" "C2 planted: S1 refuses CL:WHEN and mints nothing"
                   (and (null receipt) refusal)))
    (multiple-value-bind (receipt expanded refusal)
        (lisp-plus-surface2:try-perform-expansion
         (lisp-plus-surface2:request-expansion form :macroexpand-1 (tag-for "c2-s2")))
      (declare (ignore expanded))
      (kv "S2 Door 2 on CL:WHEN" (if receipt "RECEIPT (WRONG)" "REFUSED"))
      (when refusal (kv "  code" (lisp-plus-surface2:expansion-refusal-code refusal)))
      (probe-check "C2-PLANTED-S2-REFUSES-CL-WHEN" "C2 planted: S2 refuses CL:WHEN and mints nothing"
                   (and (null receipt) refusal)))
    (arm "CLEAN" "an admitted head in the same image still completes")
    (probe-check "C2-CLEAN-S2-RECEIPT-MINTED" "C2 clean: S2 Door 2 mints a receipt for MATCH-OUTCOME"
                 (lisp-plus-surface2:expansion-receipt-p
                  (lisp-plus-surface2:perform-expansion
                   (lisp-plus-surface2:request-expansion
                    (read-fixture *match-outcome-text*) :macroexpand-1 (tag-for "c2-clean")))))))

;;; ==========================================================================
;;; CONTROL 3 — a DUPLICATED manifest key is a COLLISION.  No first-row-wins.
;;; ==========================================================================
;;;
;;; Exercised on a PROBE-LOCAL TABLE LITERAL, because no production manifest may
;;; exist in this round.  The table below is a probe-local rehearsal of the
;;; seven-row union, nothing more: it is not a manifest, it is not exported, and
;;; nothing consults it outside this file.

(defparameter *union-rows*
  '(("LISP-PLUS-SURFACE0" "DEFINE-JUDGMENT-SCHEMA"    :s1)
    ("LISP-PLUS-SURFACE0" "DEFINE-ADMISSION-CONTRACT" :s1)
    ("LISP-PLUS-SURFACE0" "DEFINE-SLICE2-SCHEMA"      :s1)
    ("LISP-PLUS-SURFACE0" "DERIVE-CASE"               :s1)
    ("LISP-PLUS-SURFACE0" "DERIVE/2-CASE"             :s1)
    ("LISP-PLUS-SURFACE2" "WITH-OUTCOME"              :s2)
    ("LISP-PLUS-SURFACE2" "MATCH-OUTCOME"             :s2)))

(define-condition probe-key-collision (error)
  ((key :initarg :key :reader collision-key)
   (count :initarg :count :reader collision-count)))

(defun row-key (row) (format nil "~A:~A" (first row) (second row)))

(defun table-collisions (rows)
  "Every key carried by more than one row, with its multiplicity."
  (let ((counts (make-hash-table :test #'equal)) (dups nil))
    (dolist (r rows) (incf (gethash (row-key r) counts 0)))
    (maphash (lambda (k n) (when (> n 1) (push (cons k n) dups))) counts)
    (sort dups #'string< :key #'car)))

(defun resolve-row (rows key)
  "Resolve KEY against ROWS.  A duplicated key SIGNALS.  It does not return the
first matching row, and there is no path here by which it could: the count is
taken before any row is selected."
  (let ((matching (remove-if-not (lambda (r) (string= key (row-key r))) rows)))
    (when (> (length matching) 1)
      (error 'probe-key-collision :key key :count (length matching)))
    (first matching)))

(defun control-3 ()
  (rule #\=)
  (p "CONTROL 3 — a duplicated manifest key is a COLLISION; no first-row-wins")
  (rule #\=)
  (let* ((dup-row '("LISP-PLUS-SURFACE0" "DERIVE-CASE" :s2))
         (planted (append *union-rows* (list dup-row))))
    (arm "PLANTED" "the seven-row union plus one duplicate DERIVE-CASE row routed elsewhere")
    (kv "planted table rows" (length planted))
    (kv "collisions found" (table-collisions planted))
    (probe-check "C3-PLANTED-COLLISION-FOUND" "C3 planted: the collision detector FINDS the duplicated key"
                 (equal '(("LISP-PLUS-SURFACE0:DERIVE-CASE" . 2)) (table-collisions planted)))
    (let ((signalled nil) (returned nil))
      (handler-case (setf returned (resolve-row planted "LISP-PLUS-SURFACE0:DERIVE-CASE"))
        (probe-key-collision (c)
          (setf signalled (list (collision-key c) (collision-count c)))))
      (kv "resolve-row signalled" (or signalled "NOTHING"))
      (kv "resolve-row returned" (or returned "NOTHING"))
      (probe-check "C3-PLANTED-RESOLUTION-SIGNALS" "C3 planted: resolution SIGNALS rather than returning a row"
                   (and signalled (null returned)))
      (probe-check "C3-PLANTED-NO-FIRST-ROW-WINS" "C3 planted: NO first-row-wins — no row of either provider was chosen"
                   (null returned)))
    ;; a same-print-name row in a DIFFERENT package is a DIFFERENT key, not a collision
    (let ((foreign (append *union-rows* (list '("SA0-PROBE-SCRATCH" "DERIVE-CASE" :s1)))))
      (kv "same print-name, other package: collisions" (or (table-collisions foreign) "NONE"))
      (probe-check "C3-SAME-PRINT-NAME-DISTINCT-KEY" "C3: a same-print-name row in another package is a DISTINCT key, not a collision"
                   (null (table-collisions foreign))))
    (arm "CLEAN" "the exact seven-row union")
    (kv "clean table rows" (length *union-rows*))
    (kv "collisions found" (or (table-collisions *union-rows*) "NONE"))
    (probe-check "C3-CLEAN-UNION-NO-COLLISION" "C3 clean: the seven-row union carries no collision"
                 (null (table-collisions *union-rows*)))
    (probe-check "C3-CLEAN-SEVEN-KEYS-RESOLVE" "C3 clean: all seven keys resolve to exactly one row each"
                 (every (lambda (r) (equal r (resolve-row *union-rows* (row-key r))))
                        *union-rows*))))

;;; ==========================================================================
;;; CONTROL 4 — a PLANTED ROUTE MUTATION changes a measured victim, DETECTED.
;;; ==========================================================================
;;;
;;; The "route" is the probe-local head-key -> provider mapping of control 3.
;;; The DETECTOR compares the route's rendered text against a frozen expected
;;; text.  The VICTIM is a measured outcome that depends on the route.
;;;
;;; HOST SCAR OBSERVED: the canary must land in a global that is PRINTED, or the
;;; compiler is free to drop a discarded read and the tooth never fires.  Both
;;; the route text and the victim measurement are stored in specials below and
;;; printed before they are compared.

(defvar *observed-route-text* nil)
(defvar *observed-victim* nil)

(defun route-text (rows)
  (with-output-to-string (s)
    (dolist (r (sort (copy-list rows) #'string< :key #'row-key))
      (format s "~A=>~A;" (row-key r) (third r)))))

(defparameter *frozen-route-text* (route-text *union-rows*))

(defun measure-victim (rows)
  "The victim: what happens when WITH-OUTCOME/:MACROEXPAND-1 is driven through
whichever provider the route names.  Returns a short printable description."
  (let* ((row (resolve-row rows "LISP-PLUS-SURFACE2:WITH-OUTCOME"))
         (provider (third row))
         (form (read-fixture "(lisp-plus-surface2:with-outcome (cl-user::o (identity cl-user::o2)) cl-user::o)")))
    (ecase provider
      (:s2 (multiple-value-bind (receipt expanded refusal)
               (lisp-plus-surface2:try-perform-expansion
                (lisp-plus-surface2:request-expansion form :macroexpand-1 (tag-for "c4-s2")))
             (declare (ignore expanded))
             (if receipt
                 (format nil "S2 RECEIPT expansion-octets=~D"
                         (lisp-plus-surface2:identity-octets
                          (lisp-plus-surface2:expansion-receipt-expanded-form-datum receipt)))
                 (format nil "S2 REFUSED ~A" (lisp-plus-surface2:expansion-refusal-code refusal)))))
      (:s1 (multiple-value-bind (receipt expanded refusal)
               (lisp-plus-surface1:try-perform-expansion
                (lisp-plus-surface1:request-expansion form :macroexpand-1 (tag-for "c4-s1")))
             (declare (ignore expanded))
             (if receipt
                 (format nil "S1 RECEIPT expansion-octets=~D"
                         (lisp-plus-surface1:identity-octets
                          (lisp-plus-surface1:expansion-receipt-expanded-form-datum receipt)))
                 (format nil "S1 REFUSED ~A" (lisp-plus-surface1:expansion-refusal-code refusal))))))))

(defun control-4 ()
  (rule #\=)
  (p "CONTROL 4 — a planted route mutation changes a measured victim, and is detected")
  (rule #\=)
  (kv "frozen route text" *frozen-route-text*)
  ;; ---- CLEAN measurement taken FIRST so the planted arm has a baseline ----
  (arm "CLEAN" "the unmutated route")
  (setf *observed-route-text* (route-text *union-rows*)
        *observed-victim* (measure-victim *union-rows*))
  (kv "observed route text" *observed-route-text*)
  (kv "observed victim" *observed-victim*)
  (probe-check "C4-CLEAN-DETECTOR-SILENT" "C4 clean: the route detector reports NO mutation"
               (string= *observed-route-text* *frozen-route-text*))
  (let ((clean-victim *observed-victim*))
    ;; ---- PLANTED ARM ----
    (arm "PLANTED" "WITH-OUTCOME re-routed from its owner S2 to S1")
    (let ((mutated (substitute '("LISP-PLUS-SURFACE2" "WITH-OUTCOME" :s1)
                               '("LISP-PLUS-SURFACE2" "WITH-OUTCOME" :s2)
                               *union-rows* :test #'equal)))
      (setf *observed-route-text* (route-text mutated)
            *observed-victim* (measure-victim mutated))
      (kv "observed route text" *observed-route-text*)
      (kv "observed victim" *observed-victim*)
      (probe-check "C4-PLANTED-DETECTOR-FIRES" "C4 planted: the DETECTOR fires — route text differs from frozen"
                   (not (string= *observed-route-text* *frozen-route-text*)))
      (probe-check "C4-PLANTED-VICTIM-CHANGED" "C4 planted: the VICTIM actually changed — a silent mutation is not possible here"
                   (not (string= clean-victim *observed-victim*)))
      (kv "victim before" clean-victim)
      (kv "victim after" *observed-victim*))))

;;; ==========================================================================
;;; CONTROL 5 — NO-NEW-GRAMMAR ARM.
;;; ==========================================================================
;;;
;;; WHICH ARM WAS EXERCISED, STATED PLAINLY: this round proposes NO new term
;;; grammar.  It is therefore the second arm of the control that applies —
;;; PROVE THAT FOREIGN NATIVE DATUMS ARE NOT NORMALIZED THROUGH A GUESSED COMMON
;;; CODEC.  The two providers' term grammars are structurally analogous and
;;; NEVER interchangeable: S1 keys its records under TERM/… and TERMKIND/…, S2
;;; under TERM2/… and TERM2KIND/….  A common codec would have to guess, and the
;;; measurement below shows what happens when one tries.

(defun try-decode (thunk)
  (handler-case (list :decoded (funcall thunk))
    (condition (c) (multiple-value-bind (name pkg) (condition-species c)
                     (list :refused pkg name)))))

(defun control-5 ()
  (rule #\=)
  (p "CONTROL 5 — no new grammar is proposed; foreign native datums are NOT")
  (p "            normalized through a guessed common codec")
  (rule #\=)
  (kv "ARM EXERCISED" "no-new-grammar (this round proposes no term grammar of its own)")
  (let* ((f1 (read-fixture *derive-case-text*))
         (f2 (read-fixture *match-outcome-text*))
         (d1 (lisp-plus-surface1:encode-term f1))
         (d2 (lisp-plus-surface2:encode-term2 f2))
         (o1 (lisp-plus-surface1:identity-octets d1))
         (o2 (lisp-plus-surface2:identity-octets d2)))
    ;; the SAME host form encoded by both providers is not the same datum
    (let* ((same-form (read-fixture "(cl-user::a 1 \"s\" (cl-user::b))"))
           (a (lisp-plus-surface1:encode-term same-form))
           (b (lisp-plus-surface2:encode-term2 same-form)))
      (kv "one host form, S1 canonical octets" (lisp-plus-surface1:identity-octets a))
      (kv "one host form, S2 canonical octets" (lisp-plus-surface2:identity-octets b))
      (probe-check "C5-GRAMMARS-DISAGREE-OCTETS" "C5: the two native grammars do not agree octet-for-octet on one host form"
                   (/= (lisp-plus-surface1:identity-octets a)
                       (lisp-plus-surface2:identity-octets b))))
    (arm "PLANTED" "each provider's decoder is offered the OTHER provider's native datum")
    (let ((s1-on-s2 (try-decode (lambda () (lisp-plus-surface1:decode-term d2))))
          (s2-on-s1 (try-decode (lambda () (lisp-plus-surface2:decode-term2 d1)))))
      (kv "S1 decode-term on an S2 term2 datum" s1-on-s2)
      (kv "S2 decode-term2 on an S1 term datum" s2-on-s1)
      (probe-check "C5-PLANTED-S1-REFUSES-FOREIGN" "C5 planted: S1's decoder REFUSES a foreign S2 datum — no silent normalization"
                   (eq :refused (first s1-on-s2)))
      (probe-check "C5-PLANTED-S2-REFUSES-FOREIGN" "C5 planted: S2's decoder REFUSES a foreign S1 datum — no silent normalization"
                   (eq :refused (first s2-on-s1))))
    ;; no printed-representation fallback: an unrepresentable host object refuses
    (let ((withchar (list (read-fixture "cl-user::a") #\x)))
      (let ((r1 (try-decode (lambda () (lisp-plus-surface1:encode-term withchar))))
            (r2 (try-decode (lambda () (lisp-plus-surface2:encode-term2 withchar)))))
        (kv "S1 encode of a form containing a CHARACTER" r1)
        (kv "S2 encode of a form containing a CHARACTER" r2)
        (probe-check "C5-PLANTED-NO-PRINTED-FALLBACK" "C5 planted: neither grammar has a printed-representation fallback"
                     (and (eq :refused (first r1)) (eq :refused (first r2))))))
    ;; no INTERN: a datum naming a package that does not exist must refuse AND
    ;; must not bring that package or symbol into being.
    (let* ((absent "SA0-PROBE-ABSENT-PACKAGE")
           (fake-s1 (lisp-plus-cd0:make-record-datum
                     (list (lisp-plus-cd0:make-record-entry
                            (lisp-plus-cd0:make-identifier-datum '("TERM") '("KIND"))
                            (lisp-plus-cd0:make-identifier-datum '("TERMKIND") '("SYMBOL")))
                           (lisp-plus-cd0:make-record-entry
                            (lisp-plus-cd0:make-identifier-datum '("TERM") '("VALUE"))
                            (lisp-plus-cd0:make-identifier-datum (list absent) '("FOO"))))))
           (fake-s2 (lisp-plus-cd0:make-record-datum
                     (list (lisp-plus-cd0:make-record-entry
                            (lisp-plus-cd0:make-identifier-datum '("TERM2") '("KIND"))
                            (lisp-plus-cd0:make-identifier-datum '("TERM2KIND") '("SYMBOL")))
                           (lisp-plus-cd0:make-record-entry
                            (lisp-plus-cd0:make-identifier-datum '("TERM2") '("VALUE"))
                            (lisp-plus-cd0:make-identifier-datum (list absent) '("FOO")))))))
      (kv "package absent before decode" (null (find-package absent)))
      (let ((r1 (try-decode (lambda () (lisp-plus-surface1:decode-term fake-s1))))
            (r2 (try-decode (lambda () (lisp-plus-surface2:decode-term2 fake-s2)))))
        (kv "S1 decode naming an absent package" r1)
        (kv "S2 decode naming an absent package" r2)
        (kv "package still absent after decode" (null (find-package absent)))
        (probe-check "C5-PLANTED-BOTH-REFUSE-ABSENT-NAME" "C5 planted: both decoders REFUSE a name this image does not carry"
                     (and (eq :refused (first r1)) (eq :refused (first r2))))
        (probe-check "C5-PLANTED-NO-INTERN-HAPPENED" "C5 planted: no INTERN happened — the absent package is still absent"
                     (null (find-package absent)))))
    (arm "CLEAN" "each decoder round-trips its OWN datum")
    (probe-check "C5-CLEAN-S1-ROUND-TRIP" "C5 clean: S1 decode-term round-trips its own datum EQUAL"
                 (equal f1 (lisp-plus-surface1:decode-term d1)))
    (probe-check "C5-CLEAN-S2-ROUND-TRIP" "C5 clean: S2 decode-term2 round-trips its own datum EQUAL"
                 (equal f2 (lisp-plus-surface2:decode-term2 d2)))
    (kv "S1 own-datum octets" o1)
    (kv "S2 own-datum octets" o2)))

;;; ==========================================================================
;;; CONTROL 7 — a syntactically ADMITTED head whose NATIVE MACRO GRAMMAR
;;;             refuses: the provider-owned condition escapes in its ORIGINAL
;;;             SPECIES; no substitute account refusal, no completion fact.
;;; ==========================================================================
;;;
;;; R1 TIGHTENING.  R0's S2 assertion was "an S2-owned condition with a
;;; non-NIL phase".  That predicate is satisfied by nearly every refusal this
;;; provider can raise, including ones whose jurisdiction is the OPPOSITE of
;;; the one under test, so it could not tell the measured case from a
;;; different one.  The R1 assertion requires the EXACT shape:
;;;
;;;     species  SURFACE2-EXPANSION-REFUSED
;;;     owner    LISP-PLUS-SURFACE2
;;;     category :PROTOCOL-REFUSAL
;;;     phase    :EXPANSION
;;;     code     :NON-EXHAUSTIVE-MATCH
;;;
;;; and a PLANTED-WRONG arm presents a genuinely different S2 refusal to both
;;; predicates, so the transcript shows the loose one accepting what the tight
;;; one refuses.  A tightening that has never rejected anything is a claim,
;;; not a gate.
;;;
;;; THE PARTITION IS CATEGORY FIRST, THEN PHASE (owner adjudication, section B):
;;;
;;;     :integrity-alarm                       -> re-signal original unchanged
;;;     :protocol-refusal + :request / :perform -> account-domain
;;;     :protocol-refusal + :expansion / :runtime / anything unanticipated
;;;                                            -> re-signal original unchanged
;;;
;;; Phase is consulted ONLY after the category has been read, and only for
;;; :protocol-refusal.  The sentence "phase is the only separator" survives in
;;; this file exactly once, explicitly restricted to S2 PROTOCOL-REFUSAL rows.

;;; The R1 partition, written once and used for every caught S2 condition.
(defun s2-jurisdiction (category phase)
  "CATEGORY FIRST, THEN PHASE.  Returns :ACCOUNT-DOMAIN or
:RE-SIGNAL-ORIGINAL-UNCHANGED.  Anything unanticipated re-signals: an account
that does not recognise a category has no standing to reclassify it."
  (cond ((eq category :integrity-alarm) :re-signal-original-unchanged)
        ((eq category :protocol-refusal)
         (if (member phase '(:request :perform))
             :account-domain
             :re-signal-original-unchanged))
        (t :re-signal-original-unchanged)))

(defun s2-caught-shape (c)
  "The EXACT shape of a caught S2 condition: species, owning package, and —
when the condition carries a retained refusal — its category, phase and code.
No field is inferred from another."
  (multiple-value-bind (species owner) (condition-species c)
    (let ((r (ignore-errors (lisp-plus-surface2:expansion-condition-refusal c))))
      (list :species species
            :owner owner
            :category (and r (lisp-plus-surface2:expansion-refusal-category r))
            :phase (and r (lisp-plus-surface2:expansion-refusal-phase r))
            :code (and r (lisp-plus-surface2:expansion-refusal-code r))))))

(defun report-shape (prefix shape)
  (kv (format nil "~A condition class" prefix) (or (getf shape :species) "NONE"))
  (kv (format nil "~A owning package" prefix) (or (getf shape :owner) "NONE"))
  (kv (format nil "~A refusal category" prefix) (or (getf shape :category) "NONE"))
  (kv (format nil "~A refusal phase" prefix) (or (getf shape :phase) "NONE"))
  (kv (format nil "~A refusal code" prefix) (or (getf shape :code) "NONE"))
  (kv (format nil "~A jurisdiction [category-first-then-phase]" prefix)
      (s2-jurisdiction (getf shape :category) (getf shape :phase))))

(defun c7-s2-exact-shape-p (shape)
  "THE R1 ASSERTION.  All five fields, exactly."
  (and (equal (getf shape :owner) "LISP-PLUS-SURFACE2")
       (equal (getf shape :species) "SURFACE2-EXPANSION-REFUSED")
       (eq (getf shape :category) :protocol-refusal)
       (eq (getf shape :phase) :expansion)
       (eq (getf shape :code) :non-exhaustive-match)))

(defun c7-s2-loose-r0-p (shape)
  "THE R0 ASSERTION, kept only so the planted-wrong arm can show what it let
through: an S2-owned condition with a non-NIL phase."
  (and (equal (getf shape :owner) "LISP-PLUS-SURFACE2")
       (not (null (getf shape :phase)))))

(defun catch-s2-perform (text)
  "Drive S2's SIGNALLING door and return (values minted shape).  A completion
fact where a refusal was expected is itself reportable, so MINTED is returned
rather than discarded."
  (let ((minted nil) (shape nil))
    (handler-case
        (setf minted (lisp-plus-surface2:perform-expansion
                      (lisp-plus-surface2:request-expansion
                       (read-fixture text) :macroexpand-1 (tag-for "c7-s2-shape"))))
      (condition (c) (setf shape (s2-caught-shape c))))
    (values minted shape)))

(defun control-7 ()
  (rule #\=)
  (p "CONTROL 7 — an admitted head whose native macro grammar refuses")
  (rule #\=)
  ;; ---- S1 side: the head is admitted; SURFACE /0's own grammar refuses ----
  (arm "PLANTED" "LISP-PLUS-SURFACE0:DERIVE-CASE wrapping the WRONG operation")
  (let* ((bad (read-fixture
               "(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                  (lisp-plus-slice2:derive/2 :schema nil)
                  (:granted nil) (:refused (cl-user::e) nil))"))
         (req (lisp-plus-surface1:request-expansion bad :macroexpand-1 (tag-for "c7-s1")))
         (minted nil) (account-refusal nil) (species nil) (owner nil) (reason nil))
    (kv "S1 Door 1" "ACCEPTED — the head IS an admitted one")
    (kv "S1 request construct-identity"
        (if (lisp-plus-surface1:expansion-request-construct-identity req) "PRESENT" "ABSENT"))
    ;; the SIGNALLING door
    (handler-case (setf minted (lisp-plus-surface1:perform-expansion req))
      (lisp-plus-surface1:expansion-refused (c)
        (setf account-refusal (lisp-plus-surface1:expansion-condition-refusal c)))
      (condition (c)
        (multiple-value-setq (species owner) (condition-species c))
        (setf reason (ignore-errors (lisp-plus-surface0:surface-syntax-refused-reason c)))))
    (kv "condition class" (or species "NONE"))
    (kv "owning package" (or owner "NONE"))
    (kv "SURFACE /0's own reason field" (or reason "NONE"))
    (kv "an account refusal appeared" (if account-refusal "YES (WRONG)" "NO"))
    (kv "a receipt / completion fact appeared" (if minted "YES (WRONG)" "NO"))
    (probe-check "C7-PLANTED-ORIGINAL-SPECIES" "C7 planted: the condition escapes in its ORIGINAL SPECIES (LISP-PLUS-SURFACE0)"
                 (and (equal owner "LISP-PLUS-SURFACE0")
                      (equal species "SURFACE-SYNTAX-REFUSED")))
    (probe-check "C7-PLANTED-NO-SUBSTITUTE-REFUSAL" "C7 planted: NO substitute account refusal was minted"
                 (null account-refusal))
    (probe-check "C7-PLANTED-NO-COMPLETION-FACT" "C7 planted: NO completion fact was minted"
                 (null minted))
    ;; and the non-signalling door does not launder it either
    (let ((leaked nil) (species2 nil) (owner2 nil))
      (handler-case (multiple-value-bind (r e ref)
                        (lisp-plus-surface1:try-perform-expansion
                         (lisp-plus-surface1:request-expansion bad :macroexpand-1 (tag-for "c7-s1b")))
                      (declare (ignore e))
                      (setf leaked (list :receipt (and r t) :refusal (and ref t))))
        (condition (c) (multiple-value-setq (species2 owner2) (condition-species c))))
      (kv "S1 TRY- door outcome" (or leaked "CONDITION ESCAPED"))
      (kv "S1 TRY- door escaping species" (if owner2 (format nil "~A:~A" owner2 species2) "NONE"))
      (probe-check "C7-PLANTED-TRY-DOOR-NO-CONVERSION" "C7 planted: even the TRY- door does not convert a macro-owned condition"
                   (and (null leaked) (equal owner2 "LISP-PLUS-SURFACE0")))))
  ;; ---- S2 side: measured, and the answer is DIFFERENT.  Reported, not hidden.
  (p "C7-S2-EXACT-SHAPE")
  (arm "PLANTED" "LISP-PLUS-SURFACE2:MATCH-OUTCOME with no OTHERWISE clause")
  (multiple-value-bind (minted shape)
      (catch-s2-perform "(lisp-plus-surface2:match-outcome cl-user::o
                            ((:execution :settled) cl-user::o))")
    (report-shape "C7-S2-MEASURED" shape)
    (kv "C7-S2-MEASURED a receipt / completion fact appeared" (if minted "YES (WRONG)" "NO"))
    (probe-check "C7-PLANTED-S2-CONDITION-ESCAPES" "C7 planted: S2's macro-owned condition escapes as itself and mints nothing"
                 (and (null minted) (equal (getf shape :owner) "LISP-PLUS-SURFACE2")))
    ;; THE R1 ASSERTION — all five fields, exactly.
    (probe-check "C7-S2-EXACT-SHAPE-SPECIES-CATEGORY-PHASE-CODE" "C7 planted [R1 TIGHTENED]: EXACT shape — LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED, category :PROTOCOL-REFUSAL, phase :EXPANSION, code :NON-EXHAUSTIVE-MATCH"
                 (c7-s2-exact-shape-p shape))
    (probe-check "C7-S2-EXACT-SHAPE-OUTSIDE-ACCOUNT-DOMAIN" "C7 planted: category-first-then-phase puts this row OUTSIDE the account domain (re-signal original unchanged)"
                 (eq :re-signal-original-unchanged
                     (s2-jurisdiction (getf shape :category) (getf shape :phase))))

    ;; ---- THE TIGHTENING'S OWN TOOTH -------------------------------------
    ;; A genuinely DIFFERENT S2 refusal, presented to both predicates.  If the
    ;; tightened predicate accepted this too, the tightening would be
    ;; decoration.  (This is not an eighth control: it is the planted-wrong arm
    ;; of Control 7's own S2 assertion, without which that assertion has never
    ;; rejected anything.)
    (arm "PLANTED-WRONG" "a DIFFERENT S2 refusal — an unknown head, refused at :PERFORM")
    (multiple-value-bind (minted2 shape2)
        (catch-s2-perform "(cl:when cl-user::x cl-user::y)")
      (report-shape "C7-S2-PLANTED-WRONG" shape2)
      (kv "C7-S2-PLANTED-WRONG a receipt appeared" (if minted2 "YES (WRONG)" "NO"))
      (probe-check "C7-PLANTED-WRONG-DIFFERENT-REFUSAL" "C7 planted-wrong: this really is a DIFFERENT refusal (different code from the measured one)"
                   (and shape2 (not (eq (getf shape2 :code) (getf shape :code)))))
      (probe-check "C7-PLANTED-WRONG-LOOSE-PREDICATE-ACCEPTS" "C7 planted-wrong: the LOOSE R0 predicate ACCEPTS it — which is why it was too loose"
                   (c7-s2-loose-r0-p shape2))
      (probe-check "C7-PLANTED-WRONG-TIGHTENED-PREDICATE-REFUSES" "C7 planted-wrong: the R1 TIGHTENED predicate REFUSES it — the tightening bites"
                   (not (c7-s2-exact-shape-p shape2)))
      (probe-check "C7-PLANTED-WRONG-INSIDE-ACCOUNT-DOMAIN" "C7 planted-wrong: and category-first-then-phase places THIS row INSIDE the account domain (:protocol-refusal + :perform)"
                   (eq :account-domain
                       (s2-jurisdiction (getf shape2 :category) (getf shape2 :phase)))))

    (p "  MEASURED ASYMMETRY, REPORTED NOT SMOOTHED:")
    (p "    S1 macro-owned condition  LISP-PLUS-SURFACE0:SURFACE-SYNTAX-REFUSED")
    (p "    S1 account refusal        LISP-PLUS-SURFACE1:EXPANSION-REFUSED")
    (p "      => distinguishable BY CLASS.")
    (p "    S2 macro-owned condition  LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED")
    (p "    S2 account refusal        LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED")
    (p "      => the SAME CLASS.  The partition therefore reads the CATEGORY")
    (p "      field first: an :INTEGRITY-ALARM is never an account refusal, and")
    (p "      is re-signalled unchanged whatever its phase.  RESTRICTED TO S2")
    (p "      PROTOCOL-REFUSAL ROWS, and only there, the PHASE field is the only")
    (p "      separator — and S2's TRY- door returns a macro-owned refusal in the")
    (p "      refusal position, so phase must be read there too.")
    (probe-check "C7-CATEGORY-READ-FIRST" "C7: the category field is present and read FIRST; phase separates only within :protocol-refusal"
                 (and (eq (getf shape :category) :protocol-refusal)
                      (not (null (getf shape :phase))))))

  ;; The partition is TOTAL over this provider's own declared catalogue rows —
  ;; printed, so a reader can check the jurisdiction of every code S2 declares
  ;; rather than trusting the two rows this control happened to raise.
  (p "C7-S2-JURISDICTION-TABLE  (category first, then phase; over S2's public catalogue)")
  (let ((rows 0) (alarms 0) (account 0) (resignal 0))
    (dolist (e (lisp-plus-surface2:surface2-refusal-code-catalog))
      (let* ((code (lisp-plus-surface2:refusal-catalog-entry-code e))
             (class (lisp-plus-surface2:refusal-catalog-entry-class e))
             (phase (lisp-plus-surface2:refusal-catalog-entry-phase e))
             (j (s2-jurisdiction class phase)))
        (incf rows)
        (when (eq class :integrity-alarm) (incf alarms))
        (if (eq j :account-domain) (incf account) (incf resignal))
        (p "    ~40A ~18A ~12A ~A" code class phase j)))
    (kv "C7-S2-CATALOGUE-ROWS" rows)
    (kv "C7-S2-INTEGRITY-ALARM-ROWS" alarms)
    (kv "C7-S2-ACCOUNT-DOMAIN-ROWS" account)
    (kv "C7-S2-RE-SIGNAL-ROWS" resignal)
    (probe-check "C7-JURISDICTION-PARTITION-TOTAL" "C7: the category-first partition is TOTAL over S2's declared catalogue (every row lands in exactly one jurisdiction)"
                 (and (> rows 0) (= rows (+ account resignal))))
    (probe-check "C7-NO-INTEGRITY-ALARM-IN-ACCOUNT-DOMAIN" "C7: NO :integrity-alarm row is ever placed in the account domain"
                 (every (lambda (e)
                          (or (not (eq (lisp-plus-surface2:refusal-catalog-entry-class e) :integrity-alarm))
                              (eq :re-signal-original-unchanged
                                  (s2-jurisdiction (lisp-plus-surface2:refusal-catalog-entry-class e)
                                                   (lisp-plus-surface2:refusal-catalog-entry-phase e)))))
                        (lisp-plus-surface2:surface2-refusal-code-catalog))))
  (p "END-C7-S2-EXACT-SHAPE")
  (arm "CLEAN" "an admitted, well-formed form still completes on both providers")
  (probe-check "C7-CLEAN-S1-RECEIPT-MINTED" "C7 clean: S1 mints a receipt for a well-formed DERIVE-CASE"
               (lisp-plus-surface1:expansion-receipt-p
                (lisp-plus-surface1:perform-expansion
                 (lisp-plus-surface1:request-expansion
                  (read-fixture *derive-case-text*) :macroexpand-1 (tag-for "c7-clean-s1")))))
  (probe-check "C7-CLEAN-S2-RECEIPT-MINTED" "C7 clean: S2 mints a receipt for a well-formed MATCH-OUTCOME"
               (lisp-plus-surface2:expansion-receipt-p
                (lisp-plus-surface2:perform-expansion
                 (lisp-plus-surface2:request-expansion
                  (read-fixture *match-outcome-text*) :macroexpand-1 (tag-for "c7-clean-s2"))))))

;;; ==========================================================================
;;; RUN.
;;; ==========================================================================

(probe-header "FIXED CONTROLS PART A — controls 1, 2, 3, 4, 5, 7")
(control-1)
(control-2)
(control-3)
(control-4)
(control-5)
(control-7)
(when (plant-failure-requested-p)
  (p "  !! PLANTED FAILURE ARM ACTIVE — the next check is deliberately false")
  (probe-check "CONTROLS-A-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))
(probe-footer "CONTROLS-A")
(probe-exit)
