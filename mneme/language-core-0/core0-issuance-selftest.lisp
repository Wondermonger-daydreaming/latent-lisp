;;;; core0-issuance-selftest.lisp — teeth for Core /0 evidence issuance.
;;;;
;;;; Governed by CORE0-EVIDENCE-ISSUANCE-ERRATUM-0.md (owner-adopted,
;;;; 2026-07-25).  Companion to core0-selftest.lisp, which is unchanged: this
;;;; file adds the issuance floor and weakens nothing in the existing one.
;;;;
;;;; What it asserts, in the erratum's own terms:
;;;;   R-ISSUANCE-0.1  a coherent caller-built account is not issued
;;;;   R-ISSUANCE-0.2  authenticity belongs to CONTENT, not object identity
;;;;   R-ISSUANCE-0.5  continue-from refuses unissued content BEFORE the ledger
;;;;   R-ISSUANCE-0.7  one public predicate, with an exact ceiling
;;;;   R-ISSUANCE-0.8  every internal minting path registers
;;;;
;;;; ALL greens here are SELF-CONSISTENCY CERTIFICATION, never independent
;;;; conformance.  Nothing here claims durability, cross-image standing,
;;;; serialization authenticity, or any cryptographic property.
;;;;
;;;; Run: sbcl --non-interactive --load core0-issuance-selftest.lisp
;;;;      (exit 0 on all-pass)

(handler-bind ((style-warning (lambda (w) (muffle-warning w))))
  (load (merge-pathnames "fake-courier.lisp" *load-truename*)))

(in-package #:lisp-plus-core0)

(defvar *ipass* 0)
(defvar *ifail* 0)

(defun iok (name bool &optional detail)
  (if bool
      (progn (incf *ipass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *ifail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defmacro ifires (name expected-type &body body)
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (iok ,name nil "no condition fired (expected a refusal)"))
       (,expected-type (,c)
         (iok ,name t (format nil "bit: caught ~A" (type-of ,c))))
       (error (,c)
         (iok ,name nil (format nil "wrong condition: ~A" (type-of ,c)))))))

;;; ------------------------------------------------------------------
;;; An INSTRUMENTED adapter.  Its ledger-query bumps a counter, so "the ledger
;;; was not consulted" is a MEASUREMENT, not an inference from a row count.

(defvar *ledger-queries* 0)
(defvar *rows* '())

(defun reset-world () (setf *ledger-queries* 0 *rows* '()))

(defun instrumented-adapter (&key (script :clean-commit) (name :fake-courier))
  (make-adapter
   :name name
   :identity (lisp-plus-kernel0:make-identity
              :principal (format nil "fake-courier/~A/v0" name))
   :version 0
   :dispatch
   (lambda (a request attempt-id)
     (declare (ignore a))
     (ecase script
       (:refuse-before-frontier
        (list :crossed nil :committed nil :acknowledged nil :ledger-token nil
              :manifestation-status :absent :local-record-lands nil
              :reason :adapter-refused-pre-frontier))
       ((:clean-commit :kill-after-commit)
        (let ((token (format nil "fake:courier:~4,'0D" (1+ (length *rows*)))))
          (push (list (lisp-plus-kernel0:identity-key attempt-id) token
                      (copy-tree request))
                *rows*)
          (if (eq script :clean-commit)
              (list :crossed t :committed t :acknowledged t :ledger-token token
                    :manifestation-status :present :local-record-lands t
                    :reason :ok)
              (list :crossed t :committed t :acknowledged t :ledger-token token
                    :manifestation-status :withheld :local-record-lands nil
                    :reason :killed-before-local-record))))))
   :ledger-query
   (lambda (a attempt-id request)
     (declare (ignore a request))
     (incf *ledger-queries*)
     (let ((row (find (lisp-plus-kernel0:identity-key attempt-id) *rows*
                      :key #'first :test #'string=)))
       (if row (list :answered :committed (second row))
           (list :answered :not-committed))))))

(defparameter +req+ '(:predicate :deliver (:payload "The orchard remembers.")))

(defun cap (&key (predicates '(:deliver)) (adapter :fake-courier))
  (mint-capability :ruling (fixture-sealed-ruling :adapter-name adapter
                                                  :predicates predicates)))

(defun genuine-commit (&optional (label "issuance/clean"))
  "A clean-commit account.  Returns (values EVIDENCE ADAPTER)."
  (let ((adapter (instrumented-adapter :script :clean-commit)))
    (multiple-value-bind (outcome evidence)
        (perform :adapter adapter :request +req+ :authority (cap)
                 :process (process-context :label label))
      (declare (ignore outcome))
      (values evidence adapter))))

(defun genuine-w1 (&optional (label "issuance/w1"))
  "A W1-shaped interrupted account.  Returns (values EVIDENCE ADAPTER)."
  (let ((adapter (instrumented-adapter :script :kill-after-commit)))
    (handler-case
        (progn (perform :adapter adapter :request +req+ :authority (cap)
                        :process (process-context :label label))
               (values nil adapter))
      (core0-interrupted (c)
        (values (core0-condition-evidence c) adapter)))))

;;; A caller-built account: content from PUBLIC kernel0 constructors, installed
;;; through the host object model.  This is the construction route the erratum
;;; is about; it is a lawful thing for a client to do, and the point of the
;;; repair is that doing it does not confer issuance.

(defun built-w1-events (process seat attempt)
  (let* ((operation (process-context-logical-operation-id process))
         (pid (process-context-process-id process))
         (effect (lisp-plus-kernel0:make-identity :effect "issuance/built/effect"))
         (attempt-record
           (lisp-plus-kernel0:make-attempt
            :attempt-id attempt :logical-operation-id operation :seat-id seat
            :process-id pid :predecessor-attempts nil
            :machine-configuration-id nil :supersession-records nil))
         (uncertain
           (lisp-plus-kernel0:make-uncertain-effect
            :kind :provider-call :attempt attempt
            :external-request '(:unavailable :reason :killed-before-local-record)
            :possible-effects '(:delivered :not-delivered) :known-facts nil
            :reconciliation-procedure
            (lisp-plus-kernel0:make-identity :procedure "core0/reconcile-courier")))
         (ev (lambda (type &rest kw)
               (apply #'lisp-plus-kernel0:make-kernel0-event
                      :event-type type :process-id pid kw))))
    (list (funcall ev :process-created)
          (funcall ev :seat-reserved :seat-id seat)
          (funcall ev :attempt-begun :seat-id seat :attempt-id attempt
                      :logical-operation-id operation
                      :payload (list :attempt attempt-record))
          (funcall ev :effect-prepared :seat-id seat :attempt-id attempt
                      :effect-id effect)
          (funcall ev :frontier-crossed :seat-id seat :attempt-id attempt
                      :effect-id effect)
          (funcall ev :request-acknowledged :seat-id seat :attempt-id attempt
                      :external-request-id
                      (lisp-plus-kernel0:make-identity
                       :external-request "issuance/built/req"))
          (funcall ev :effect-bounded :seat-id seat :attempt-id attempt
                      :effect-id effect :payload (list :uncertain-effect uncertain))
          (funcall ev :attempt-failed :seat-id seat :attempt-id attempt))))

(defun built-account (&key attempt label)
  (let* ((process (process-context :label label))
         (seat (process-context-seat-id process))
         (obj (make-instance 'core0-evidence)))
    (setf (slot-value obj 'process) process
          (slot-value obj 'attempt-id) attempt
          (slot-value obj 'seat-id) seat
          (slot-value obj 'adapter-identity)
          (lisp-plus-kernel0:make-identity
           :principal "fake-courier/FAKE-COURIER/v0")
          (slot-value obj 'request) (lisp-plus-slice1:proposition +req+)
          (slot-value obj 'events) (built-w1-events process seat attempt))
    obj))

(format t "~%== Core /0 evidence-issuance teeth (self-consistency certification) ==~%")

;;; ==================================================================
;;; I1 — every internal minting path registers (R-ISSUANCE-0.8)

(format t "~%-- I1: the four evidence-minting paths all register --~%")
(reset-world)

(multiple-value-bind (e0 adapter) (genuine-commit)
  (declare (ignore adapter))
  (iok "I1a clean committed perform issues its account"
       (core0-evidence-current-image-issued-p e0)))

(multiple-value-bind (e0w adapter) (genuine-w1)
  (declare (ignore adapter))
  (iok "I1b interrupted (unresolved) perform issues its surviving account"
       (core0-evidence-current-image-issued-p e0w)))

;; a refused perform that RETURNS evidence — the pre-frontier refusal carries an
;; account out inside its typed condition, and that account is issued too.
(handler-case
    (perform :adapter (instrumented-adapter :script :clean-commit)
             :request '(:predicate :shred (:payload "x"))
             :authority (cap :predicates '(:deliver))
             :process (process-context :label "issuance/refused"))
  (core0-refused (c)
    (iok "I1c refused perform issues the evidence its refusal carries"
         (core0-evidence-current-image-issued-p (core0-condition-evidence c)))))

(handler-case
    (perform :adapter (instrumented-adapter :script :refuse-before-frontier)
             :request +req+ :authority (cap)
             :process (process-context :label "issuance/adapter-refused"))
  (core0-refused (c)
    (iok "I1c' adapter-refused-pre-frontier issues its account too"
         (core0-evidence-current-image-issued-p (core0-condition-evidence c)))))

(multiple-value-bind (e0w adapter) (genuine-w1 "issuance/w1-replacement")
  (let ((r (continue-from e0w :adapter adapter :authority (cap))))
    (iok "I1d setup: a validated continue-from reconciled"
         (eq (continuation-result-disposition r) :reconciled))
    (iok "I1d validated continue-from issues its REPLACEMENT evidence"
         (core0-evidence-current-image-issued-p
          (continuation-result-evidence r)))))

;;; ==================================================================
;;; I2 — the required post-cure sensitivity table (R-ISSUANCE-0.7)

(format t "~%-- I2: the issuance predicate's required sensitivity --~%")
(reset-world)

(multiple-value-bind (e0 adapter) (genuine-commit "issuance/table")
  (declare (ignore adapter))
  (let* ((e2 (copy-structure e0))
         (e1 (make-instance 'core0-evidence))
         (e6 (built-account :attempt (lisp-plus-kernel0:make-identity
                                      :attempt "issuance/never-ran/1")
                            :label "issuance/built6"))
         (e8 (built-account :attempt (lisp-plus-kernel0:make-identity
                                      :attempt "issuance/fresh/8")
                            :label "issuance/built8")))
    (iok "I2 E0 genuine account            issued -> true"
         (core0-evidence-current-image-issued-p e0))
    (iok "I2 E2 exact COPY-STRUCTURE       issued -> true"
         (core0-evidence-current-image-issued-p e2))
    (iok "I2 E2 is NOT the same object (so this is not an EQ registry)"
         (not (eq e2 e0)))
    (iok "I2 E1 blank object               issued -> false"
         (not (core0-evidence-current-image-issued-p e1)))
    (iok "I2 E1 is nevertheless core0-evidence-p (type != issuance)"
         (core0-evidence-p e1))
    (iok "I2 E6 coherent caller-built      issued -> false"
         (not (core0-evidence-current-image-issued-p e6)))
    (iok "I2 E6 nevertheless VALIDATES structurally (validation != issuance)"
         (eq t (lisp-plus-kernel0:validate-event-sequence
                (core0-evidence-events e6))))
    (iok "I2 E8 fresh-identity built       issued -> false"
         (not (core0-evidence-current-image-issued-p e8)))
    ;; E9 — the genuine object, mutated and then restored EXACTLY
    (let ((original (slot-value e0 'ledger-token)))
      (setf (slot-value e0 'ledger-token) "fake:courier:6666")
      (iok "I2 E9 mutated genuine account   issued -> false"
           (not (core0-evidence-current-image-issued-p e0)))
      (setf (slot-value e0 'ledger-token) original)
      (iok "I2 E9 restored exactly          issued -> true"
           (core0-evidence-current-image-issued-p e0)))
    ;; mutation is detected in NESTED content too, not only at a top slot
    (let ((original (slot-value e0 'events)))
      (setf (slot-value e0 'events) (butlast original))
      (iok "I2 E9' nested content mutation (an event dropped) -> false"
           (not (core0-evidence-current-image-issued-p e0)))
      (setf (slot-value e0 'events) original)
      (iok "I2 E9' nested content restored exactly -> true"
           (core0-evidence-current-image-issued-p e0)))))

;; E7 — a caller-built account reusing a GENUINE unresolved attempt identity
(reset-world)
(multiple-value-bind (e0w adapter) (genuine-w1 "issuance/e7-source")
  (declare (ignore adapter))
  (let ((e7 (built-account :attempt (core0-evidence-attempt-id e0w)
                           :label "issuance/built7")))
    (iok "I2 E7 genuine-attempt-id reuse   issued -> false"
         (not (core0-evidence-current-image-issued-p e7)))
    (iok "I2 E7 carries the genuine attempt identity (the reuse is real)"
         (lisp-plus-kernel0:identity= (core0-evidence-attempt-id e7)
                                      (core0-evidence-attempt-id e0w)))
    (iok "I2 E0w (the genuine source) is issued"
         (core0-evidence-current-image-issued-p e0w))))

;;; ==================================================================
;;; I3 — continue-from: refusal BEFORE the ledger (R-ISSUANCE-0.5)

(format t "~%-- I3: continue-from refuses unissued content before the ledger --~%")
(reset-world)

(multiple-value-bind (e0w adapter) (genuine-w1 "issuance/i3")
  (let ((e7 (built-account :attempt (core0-evidence-attempt-id e0w)
                           :label "issuance/i3-built7"))
        (e8 (built-account :attempt (lisp-plus-kernel0:make-identity
                                     :attempt "issuance/i3-fresh")
                           :label "issuance/i3-built8"))
        (e1 (make-instance 'core0-evidence)))
    (setf *ledger-queries* 0)
    (ifires "I3a E7 (genuine attempt id, caller-built) is refused" unissued-evidence
      (continue-from e7 :adapter adapter :authority (cap)))
    (iok "I3a the adapter's ledger was NOT consulted (measured, not inferred)"
         (zerop *ledger-queries*) (format nil "ledger-queries=~D" *ledger-queries*))
    (iok "I3a no ledger row was added" (= 1 (length *rows*))
         (format nil "rows=~D" (length *rows*)))
    (iok "I3a the refusal did NOT register the caller-built input"
         (not (core0-evidence-current-image-issued-p e7)))

    (setf *ledger-queries* 0)
    (ifires "I3b E8 (fresh identity, caller-built) is refused" unissued-evidence
      (continue-from e8 :adapter adapter :authority (cap)))
    (iok "I3b the ledger was NOT consulted" (zerop *ledger-queries*))
    (iok "I3b the refusal did NOT register the caller-built input"
         (not (core0-evidence-current-image-issued-p e8)))

    (setf *ledger-queries* 0)
    (ifires "I3c a blank object is refused (typed, not a host error)"
        unissued-evidence
      (continue-from e1 :adapter adapter :authority (cap)))
    (iok "I3c the ledger was NOT consulted" (zerop *ledger-queries*))

    ;; the check precedes the AUTHORITY check too: unissued content with no
    ;; authority at all still refuses for the issuance reason, and still
    ;; reaches nothing authority-bearing.
    (setf *ledger-queries* 0)
    (ifires "I3d unissued content + no authority: refused as unissued, earliest"
        unissued-evidence
      (continue-from e7 :adapter adapter :authority nil))
    (iok "I3d the ledger was NOT consulted" (zerop *ledger-queries*))

    ;; and the GENUINE account still works, on the same adapter, right after
    (setf *ledger-queries* 0)
    (let ((r (continue-from e0w :adapter adapter :authority (cap))))
      (iok "I3e cure: the genuine unresolved account still reconciles"
           (eq (continuation-result-disposition r) :reconciled))
      (iok "I3e and the ledger WAS consulted for it (the counter is live)"
           (= 1 *ledger-queries*) (format nil "ledger-queries=~D" *ledger-queries*))
      (iok "I3e a reconciliation receipt was minted for the genuine account"
           (not (null (continuation-result-reconciliation-receipt r))))
      (iok "I3e the ledger still holds exactly one row" (= 1 (length *rows*))))))

;;; ==================================================================
;;; I4 — copy behavior: continue-from accepts an exact copy wherever it
;;; accepts the original (R-ISSUANCE-0.2 / R-ISSUANCE-0.6)

(format t "~%-- I4: an exact copy is accepted wherever the original is --~%")
(reset-world)

(multiple-value-bind (e0w adapter) (genuine-w1 "issuance/i4")
  (let* ((copy (copy-structure e0w))
         (r-copy (continue-from copy :adapter adapter :authority (cap))))
    (iok "I4a the copy is not EQ to the original" (not (eq copy e0w)))
    (iok "I4b continue-from RECONCILES from the exact copy"
         (eq (continuation-result-disposition r-copy) :reconciled))
    (iok "I4c the copy's continuation minted a receipt"
         (not (null (continuation-result-reconciliation-receipt r-copy))))
    (iok "I4d the original is still accepted as well"
         (eq (continuation-result-disposition
              (continue-from e0w :adapter adapter :authority (cap)))
             :reconciled))))

;; the clean-commit case: the copy behaves exactly as the original does
(reset-world)
(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i4-clean")
  (let ((copy (copy-structure e0)))
    (iok "I4e a copy of a settled account takes the SAME continue-from path"
         (eq (continuation-result-disposition
              (continue-from copy :adapter adapter :authority (cap)))
             (continuation-result-disposition
              (continue-from e0 :adapter adapter :authority (cap)))))))

;;; ==================================================================
;;; I5 — the predicate's own discipline (R-ISSUANCE-0.7)

(format t "~%-- I5: the predicate consults, and does nothing else --~%")
(reset-world)

(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i5")
  (declare (ignore adapter))
  (let ((e6 (built-account :attempt (lisp-plus-kernel0:make-identity
                                     :attempt "issuance/i5-built")
                           :label "issuance/i5-built")))
    (setf *ledger-queries* 0)
    (core0-evidence-current-image-issued-p e0)
    (core0-evidence-current-image-issued-p e6)
    (iok "I5a the predicate does not consult the adapter's ledger"
         (zerop *ledger-queries*))
    (let ((before (hash-table-count *core0-issuance-registry*)))
      (dotimes (i 5)
        (core0-evidence-current-image-issued-p e6)
        (core0-evidence-current-image-issued-p e0))
      (iok "I5b the predicate does not mutate the registry"
           (= before (hash-table-count *core0-issuance-registry*))
           (format nil "entries before=~D after=~D"
                   before (hash-table-count *core0-issuance-registry*))))
    (iok "I5c asking about unissued content never makes it issued"
         (not (core0-evidence-current-image-issued-p e6)))
    (iok "I5d the predicate answers false, not signals, for a non-evidence"
         (and (not (core0-evidence-current-image-issued-p nil))
              (not (core0-evidence-current-image-issued-p 42))
              (not (core0-evidence-current-image-issued-p "an account"))))
    ;; issuance is inferred from NO proxy: E6 has a valid event sequence, a
    ;; folding standing, a registered adapter identity, and a lawful attempt
    ;; identity, and is still not issued.
    (iok "I5e no proxy confers issuance (events validate, fold folds, ids lawful)"
         (and (eq t (lisp-plus-kernel0:validate-event-sequence
                     (core0-evidence-events e6)))
              (lisp-plus-kernel0:durable-identity-p
               (core0-evidence-attempt-id e6))
              (lisp-plus-kernel0:durable-identity-p
               (core0-evidence-adapter-identity e6))
              (not (core0-evidence-current-image-issued-p e6))))))

;;; ==================================================================
;;; I6 — the canonical content itself

(format t "~%-- I6: canonical issuance content --~%")
(reset-world)

(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i6")
  (declare (ignore adapter))
  (let ((d1 (%core0-evidence-issuance-datum e0))
        (d2 (%core0-evidence-issuance-datum e0)))
    (iok "I6a the canonical content is a CD/0 datum" (lisp-plus-cd0:datum-p d1))
    (iok "I6b it is deterministic across two constructions"
         (lisp-plus-cd0:equal-datum d1 d2))
    (multiple-value-bind (k1 o1) (%core0-issuance-content e0)
      (multiple-value-bind (k2 o2) (%core0-issuance-content e0)
        (iok "I6c its exact octets are stable across two encodings"
             (and (string= k1 k2) (%core0-octets-identical-p o1 o2)))
        (iok "I6d the index is the exact-octet hex (lossless, index-only)"
             (string= k1 (lisp-plus-cd0:octets-to-hex
                          (lisp-plus-cd0:canonical-octets d1))))
        (iok "I6e the stored value is a fresh copy, not the caller's vector"
             (not (eq o1 o2)))))
    ;; the canonical request IS bound into the content without being readable
    (iok "I6f the canonical request is bound (changing it changes the content)"
         (let* ((before (nth-value 0 (%core0-issuance-content e0)))
                (original (slot-value e0 'request)))
           (setf (slot-value e0 'request)
                 (lisp-plus-slice1:proposition
                  '(:predicate :deliver (:payload "a different subject"))))
           (let ((after (nth-value 0 (%core0-issuance-content e0))))
             (setf (slot-value e0 'request) original)
             (not (string= before after)))))
    (iok "I6g core0-evidence-request is still NOT exported (subject stays internal)"
         (not (eq :external
                  (nth-value 1 (find-symbol "CORE0-EVIDENCE-REQUEST"
                                            :lisp-plus-core0)))))))

;;; ==================================================================
;;; I7 — registry hygiene: image-local, internal, order-independent

(format t "~%-- I7: registry hygiene --~%")

(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i7")
  (declare (ignore adapter))
  (iok "I7a issued before the reset" (core0-evidence-current-image-issued-p e0))
  (%clear-core0-issuance-registry)
  (iok "I7b a registry reset withdraws current-image standing (R-ISSUANCE-0.9)"
       (not (core0-evidence-current-image-issued-p e0)))
  (%issue-core0-evidence e0)
  (iok "I7c re-issuing the same content restores the answer"
       (core0-evidence-current-image-issued-p e0)))

(iok "I7d no public registry access is exported"
     (let ((leaked '()))
       (do-external-symbols (s :lisp-plus-core0)
         (let ((n (symbol-name s)))
           (when (or (search "REGISTRY" n) (search "ISSUANCE-DATUM" n)
                     (search "ISSUE-CORE0" n))
             (push n leaked))))
       (null leaked)))

(iok "I7e exactly ONE new public operation + ONE new typed refusal"
     (let ((new '()))
       (do-external-symbols (s :lisp-plus-core0)
         (let ((n (symbol-name s)))
           (when (member n '("CORE0-EVIDENCE-CURRENT-IMAGE-ISSUED-P"
                             "UNISSUED-EVIDENCE")
                         :test #'string=)
             (push n new))))
       (= 2 (length new))))

(iok "I7f the new refusal is a core0-refused (the existing refusal family)"
     (subtypep 'unissued-evidence 'core0-refused))

;;; ==================================================================
;;; I8 — the REQUEST-BOUND companion predicate (Slice /2 Work Order /0, D2-0.7).
;;;
;;;   core0-evidence-current-image-issued-for-request-p
;;;
;;; It is the CONJUNCTION of the I1–I7 issuance question and an exact request
;;; comparison.  These checks exercise BOTH halves independently — an issued
;;; account against the wrong request, and the right request against an account
;;; that was never issued — because a conjunction whose halves are never tested
;;; apart is a conjunction only in the docstring.

(format t "~%-- I8: the request-bound companion (D2-0.7) --~%")

(defparameter +other-req+ '(:predicate :deliver (:payload "A different errand.")))

(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i8")
  (declare (ignore adapter))
  (iok "I8a a genuine account answers TRUE for the request it was performed for"
       (core0-evidence-current-image-issued-for-request-p e0 +req+))
  (iok "I8b role order does not matter — comparison is on NORMAL FORMS"
       (core0-evidence-current-image-issued-for-request-p
        e0 (lisp-plus-slice1:proposition +req+)))
  ;; HALF ONE ALONE: issued, wrong request.
  (iok "I8c an ISSUED account answers FALSE for a different request"
       (and (core0-evidence-current-image-issued-p e0)
            (not (core0-evidence-current-image-issued-for-request-p e0 +other-req+))))
  (iok "I8d a request differing only in its PAYLOAD STRING answers FALSE"
       (not (core0-evidence-current-image-issued-for-request-p
             e0 '(:predicate :deliver (:payload "The orchard remembers")))))
  (iok "I8e a request differing only in its PREDICATE answers FALSE"
       (not (core0-evidence-current-image-issued-for-request-p
             e0 '(:predicate :reserve (:payload "The orchard remembers.")))))
  ;; HALF TWO ALONE: right request, never issued.
  (let ((built (built-account
                :attempt (core0-evidence-attempt-id e0)   ; a GENUINE attempt id
                :label "issuance/i8-built")))
    (iok "I8f a caller-built account carrying the RIGHT request and a GENUINE attempt identity answers FALSE"
         (and (core0-evidence-p built)
              (not (core0-evidence-current-image-issued-p built))
              (not (core0-evidence-current-image-issued-for-request-p built +req+))))))

;;; The exact-copy sensitivity R-ISSUANCE-0.7 requires, carried onto the
;;; request-bound form: authenticity is a property of CONTENT (R-ISSUANCE-0.2),
;;; so a copy answers exactly as the original does — on BOTH questions.
(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i8-copy")
  (declare (ignore adapter))
  (let ((copy (%make-core0-evidence
               :process (%core0-evidence-process e0)
               :attempt-id (%core0-evidence-attempt-id e0)
               :seat-id (%core0-evidence-seat-id e0)
               :adapter-identity (%core0-evidence-adapter-identity e0)
               :adapter (%core0-evidence-adapter e0)
               :request (%core0-evidence-request e0)
               :events (%core0-evidence-events e0)
               :manifestation (%core0-evidence-manifestation e0)
               :ledger-token (%core0-evidence-ledger-token e0)
               :reconciliation-receipts (%core0-evidence-reconciliation-receipts e0)
               :refusal-reason (%core0-evidence-refusal-reason e0))))
    (iok "I8g an EXACT CONTENT COPY answers TRUE for the same request (R-ISSUANCE-0.2)"
         (and (not (eq copy e0))
              (core0-evidence-current-image-issued-for-request-p copy +req+)))
    (iok "I8h and the copy answers FALSE for a different request, exactly as the original does"
         (not (core0-evidence-current-image-issued-for-request-p copy +other-req+)))))

;;; It ANSWERS rather than signals for junk, and it does not mutate the registry.
(multiple-value-bind (e0 adapter) (genuine-commit "issuance/i8-total")
  (declare (ignore adapter))
  (iok "I8i a non-evidence value answers FALSE, never signals"
       (and (not (core0-evidence-current-image-issued-for-request-p 17 +req+))
            (not (core0-evidence-current-image-issued-for-request-p nil +req+))
            (not (core0-evidence-current-image-issued-for-request-p "x" +req+))))
  (iok "I8j a MALFORMED or non-ground request answers FALSE, never signals"
       (and (not (core0-evidence-current-image-issued-for-request-p e0 :not-a-proposition))
            (not (core0-evidence-current-image-issued-for-request-p e0 nil))
            ;; a raw (:var …) is not ground and PROPOSITION refuses it
            (not (core0-evidence-current-image-issued-for-request-p
                  e0 '(:predicate :deliver (:payload (:var :x)))))))
  (iok "I8k it CONSULTS and does not mutate: repeated calls, and a false one, leave the answer unchanged"
       (let ((before (hash-table-count *core0-issuance-registry*)))
         (core0-evidence-current-image-issued-for-request-p e0 +req+)
         (core0-evidence-current-image-issued-for-request-p e0 +other-req+)
         (core0-evidence-current-image-issued-for-request-p e0 +req+)
         (and (= before (hash-table-count *core0-issuance-registry*))
              (core0-evidence-current-image-issued-for-request-p e0 +req+))))
  (iok "I8l it consults NO ledger (the instrumented query counter does not move)"
       (let ((before *ledger-queries*))
         (core0-evidence-current-image-issued-for-request-p e0 +req+)
         (core0-evidence-current-image-issued-for-request-p e0 +other-req+)
         (= before *ledger-queries*))))

;;; R-ISSUANCE-0.11 / R-SOURCE-1.10 — NOT repaired here, and the check is
;;; mechanical rather than a promise in a comment.
(iok "I8m the internal request reader is STILL NOT exported (R-ISSUANCE-0.11 intact)"
     (eq :internal (nth-value 1 (find-symbol "CORE0-EVIDENCE-REQUEST" :lisp-plus-core0))))

(iok "I8n Core /0's public surface grew by EXACTLY ONE operation for this movement"
     (let ((n 0))
       (do-external-symbols (s :lisp-plus-core0)
         (when (search "ISSUED-FOR-REQUEST" (symbol-name s)) (incf n)))
       (= 1 n)))

;;; ==================================================================
;;; Tally + exit.

(format t "~%== Core /0 issuance teeth: ~D passed / ~D failed ==~%" *ipass* *ifail*)
(format t "(self-consistency certification — image-local only; no durability, ~
cross-image, serialization, or cryptographic claim)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *ifail*) 0 1))
