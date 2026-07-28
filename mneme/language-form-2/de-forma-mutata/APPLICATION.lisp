;;;; APPLICATION.lisp — de forma mutata: concerning the changed form.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH — read this first, because it is the part a
;;;; reader is most likely to supply for himself if nobody says it.
;;;;
;;;;   Nothing here establishes that any transformation PRESERVED anything.
;;;;   Form /2 says WHERE and WHAT.  It never says better, same, or right.
;;;;   A transformation receipt is an ACCOUNT, not an AUTHENTICATION: it does
;;;;   not establish completeness, order, unique lineage, or authenticity of any
;;;;   receipt set, and nothing prevents a fabricated edge between any two data.
;;;;
;;;; THESIS.  A form may be rewritten, and the rewrite may not impersonate
;;;; validation or equivalence.  The successor inherits NOTHING and must re-enter
;;;; the Form /1 pipeline as a new candidate, on its own merits.
;;;;
;;;; FORM /2 IS NOT MODIFIED BY THIS PROGRAM, AND NEITHER IS FORM /1.  Form /2
;;;; loads CD/0 only.  This application loads Form /1 as a CLIENT, so that the
;;;; neighbour can accept or refuse in its own voice instead of Form /2
;;;; impersonating it.
;;;;
;;;; THE DIVISION OF LABOUR, WHICH IS THE WHOLE POINT.  Candidates C and D now
;;;; run the complete path through PUBLIC DERIVE/2, and the three layers each
;;;; establish exactly one thing and no more:
;;;;
;;;;   Form /2   establishes that A REFERENCE CHANGED.
;;;;   Form /1   establishes that BOTH DATUMS ARE LAWFUL PETITIONS.
;;;;   Slice /2  ALONE establishes THE TWO GOVERNED OUTCOMES.
;;;;
;;;; No evidence-admission approximation is implemented here.  The schema, the
;;;; admission contract, the witnesses and the receiver context are the real
;;;; public Slice /0/1/2 objects, following de-forma-petente as executable
;;;; precedent.  Form /2 never sees any of them: it moves a reference inside an
;;;; inert datum and knows nothing about what the reference denotes.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((here (or *load-truename* *default-pathname-defaults*))
        (*error-output* (make-broadcast-stream)))
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "../form2.lisp" here))
      (load (merge-pathnames "../../language-form-1/form1.lisp" here)))))

(defpackage #:de-forma-mutata (:use #:common-lisp))
(in-package #:de-forma-mutata)

(defmacro f2 (name &rest args) `(,(intern (string name) '#:lisp-plus-form2) ,@args))
(defmacro f1 (name &rest args) `(,(intern (string name) '#:lisp-plus-form1) ,@args))
(defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))

(defparameter *checks* 0)
(defparameter *failed* 0)
(defparameter *census* (make-hash-table :test #'equal))

(defun section (title) (format t "~%── ~A~%" title))
(defun desk (control &rest args) (format t "  ~A~%" (apply #'format nil control args)))
(defun check (condition label)
  (incf *checks*)
  (if condition
      (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*) (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(defun txt (s) (cd0 make-string-datum s))
(defun occ-tag (&rest path)
  "Form /1 requires a CD/0 IDENTIFIER occurrence tag, with no default."
  (cd0 make-identifier-datum '("de-forma-mutata") path))
(defun same (a b) (cd0 equal-datum a b))
(defun full-hex (d) (cd0 octets-to-hex (cd0 canonical-octets d)))

;;; THE ABBREVIATION IS ITSELF UNDER TEST.  An abbreviation nobody has tested is
;;; a diagnostic that can lie: naive prefixes of lossless identities collapse,
;;; because two identities that share a long head differ only far into the tail.
;;; Every identity PRINTED here registers into *CENSUS* as a side effect of
;;; printing, so nothing displayed can escape the discrimination check at the
;;; foot of the program.
(defparameter +head+ 24)
(defparameter +tail+ 24)

(defun id! (datum)
  (let ((hex (full-hex datum)))
    (setf (gethash hex *census*) t)
    (if (<= (length hex) (+ +head+ +tail+ 3))
        hex
        (format nil "~A…~A [~D]" (subseq hex 0 +head+)
                (subseq hex (- (length hex) +tail+)) (length hex)))))

(format t "~&DE FORMA MUTATA — concerning the changed form~%")
(format t "SBCL ~A · Form /2 policy v~D · Form /1 policy v~D~%"
        (lisp-implementation-version)
        (f2 transformation-policy-version)
        (f1 petition-policy-version))

;;; ------------------------------------------------------------------
;;; The principal inhabitant: a Form /1 petition datum.
;;; ------------------------------------------------------------------

(defun petition-of (&key (support "clearance"))
  (f1 petition-datum
      :schema (f1 schema-reference "s")
      :conclusion (f1 conclusion-reference "c")
      :supports (list (f1 support-reference support))
      :receiver (f1 receiver-reference "r")))

;;; ══════════════════════════════════════════════════════════════════
;;; THE LIVE FIXTURE — one reading-room desk with one governed question.
;;;
;;; One premise, discharged by an asserted witness of an exact mode and kind, so
;;; that the rewritten petition can supply a witness of the RIGHT species, mode
;;; and kind concerning the WRONG SUBJECT.  A fixture that got the species wrong
;;; would test the classifier and not the premise, and the premise is the point.
;;;
;;; Following de-forma-petente as EXECUTABLE PRECEDENT.  Nothing here is a
;;; private approximation of admission: these are the public Slice /0/1/2 APIs.

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defun install-schema ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :volume-may-be-issued :version 1
    :conclusion (pp '(:predicate :volume-may-be-issued (:volume (:var :volume))))
    :premises (list (pp '(:predicate :volume-cleared-by-conservator
                          (:volume (:var :volume))))))))

(defun clearance-contract ()
  ;; :RECEIVER-ACCESSIBILITY is chosen DELIBERATELY; the constructor's own
  ;; default is :REQUIRED, and a default silently inherited is a decision
  ;; nobody made.
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :clearance-receiver-required
   :receiver-accessibility :required
   :accepted-clauses '((:asserted-witness :mode :direct
                        :kind :conservator-inspection
                        :truth-ceiling :asserted))))

(defun schema-wrapper ()
  ;; Built over what RESOLVE-SCHEMA returns, never over a locally kept handle:
  ;; DERIVE/2 compares the registered schema with EQ.
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :volume-may-be-issued/2
   :base-schema (lisp-plus-slice1:resolve-schema :volume-may-be-issued 1)
   :premise-contracts (list (list 0 (clearance-contract)))))

(defun clearance-witness (volume)
  (lisp-plus-slice0:witness
   :for (np `(:predicate :volume-cleared-by-conservator (:volume ,volume)))
   :mode :direct :kind :conservator-inspection :source :conservator))

(defun reading-room (witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id :reading-room
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))

(defun governed-declaration (identity) (lisp-plus-kernel0:identity->datum identity))
(defun witness-declaration (w) (governed-declaration (lisp-plus-slice0:witness-id w)))
(defun schema-declaration (wrapper)
  (governed-declaration
   (lisp-plus-slice1:judgment-schema-identity
    (lisp-plus-slice2:slice2-schema-base-schema wrapper))))

(install-schema)

(defparameter *wrapper* (schema-wrapper))
(defparameter *conclusion* (np '(:predicate :volume-may-be-issued (:volume "PLUT-7"))))

;;; THE TWO SUPPORTS.  Same species, same mode, same kind.  Different SUBJECT.
(defparameter *right-subject-witness* (clearance-witness "PLUT-7"))
(defparameter *wrong-subject-witness* (clearance-witness "PLUT-9"))

;;; ONE SEALED CONTEXT carrying BOTH support references, so the only thing that
;;; differs between the original and the successor is which reference the
;;; PETITION NAMES — not what the context contains.
(defparameter *context*
  (let ((ctx (f1 bind-conclusion-reference
                 (f1 bind-schema-reference (f1 make-derivation-resolution-context)
                     (f1 schema-reference "s") *wrapper* (schema-declaration *wrapper*))
                 (f1 conclusion-reference "c") *conclusion*
                 ;; No governed identity exists for a ground proposition, so the
                 ;; host declares it with its own durable identifier.  It must
                 ;; NOT mention a volume: the conclusion is fixed, and it is the
                 ;; WITNESS that varies by subject.
                 (occ-tag "denotation" "conclusion" "volume-may-be-issued"))))
    (setf ctx (f1 bind-support-reference ctx (f1 support-reference "clearance")
                  *right-subject-witness* (witness-declaration *right-subject-witness*)))
    (setf ctx (f1 bind-support-reference ctx (f1 support-reference "wrong-subject")
                  *wrong-subject-witness* (witness-declaration *wrong-subject-witness*)))
    (setf ctx (f1 bind-receiver-reference ctx (f1 receiver-reference "r")
                  (reading-room (list *right-subject-witness* *wrong-subject-witness*))
                  (occ-tag "denotation" "receiver" "reading-room")))
    (f1 seal-resolution-context ctx (occ-tag "ctx" "desk"))))

;;; DERIVE/2 INVOCATION COUNTING.  A Slice /2 receipt identity is an IMAGE-LOCAL
;;; ORDINAL name — a property of Slice /2's naming, read here as an instrument
;;; and never recorded as though it were durable.  The delta across a pair of
;;; submissions is how many times DERIVE/2 actually ran.
(defun slice2-ordinal (receipt)
  (let ((name (lisp-plus-kernel0:durable-identity-name
               (lisp-plus-slice2:slice2-receipt-identity receipt))))
    (parse-integer name :start (1+ (position #\- name :from-end t)))))

(defparameter *derive-invocations* 0)

(defstruct row
  name
  (f2-proposal nil) (f2-refusal nil) (successor nil) (receipt nil)
  (proposed nil) (propose-refusal nil)
  (validated nil) (validate-refusal nil)
  (petition nil) (materialize-refusal nil)
  (outcome nil) (submit-refusal nil))

(defun transform (name &key input path expected replacement tag)
  "Walk one candidate through Form /2, retaining every refusal as an object."
  (let ((r (make-row :name name)))
    (multiple-value-bind (proposal refusal)
        (f2 try-propose-replacement
            (f2 replacement-proposal-datum
                :input input :path path :expected-old expected
                :replacement replacement :occurrence-tag (txt tag)))
      (setf (row-f2-proposal r) proposal (row-f2-refusal r) refusal)
      (when proposal
        (multiple-value-bind (successor receipt refusal2) (f2 try-apply-replacement proposal)
          (setf (row-successor r) successor
                (row-receipt r) receipt
                (row-f2-refusal r) (or refusal2 (row-f2-refusal r))))))
    r))

(defun re-enter (r)
  "Hand the SUCCESSOR to Form /1 as a NEW CANDIDATE.  Nothing is carried across:
Form /1 receives a bare datum and owes it nothing."
  (when (row-successor r)
    (multiple-value-bind (proposed refusal) (f1 try-propose-petition (row-successor r))
      (setf (row-proposed r) proposed (row-propose-refusal r) refusal)
      (when proposed
        (multiple-value-bind (validated refusal) (f1 try-validate-petition proposed)
          (setf (row-validated r) validated (row-validate-refusal r) refusal)
          (when validated
            (multiple-value-bind (petition receipt refusal)
                (f1 try-materialize-petition validated
                                             (occ-tag "occ" (string-downcase (string (row-name r)))))
              (declare (ignore receipt))
              (setf (row-petition r) petition (row-materialize-refusal r) refusal)))))))
  r)

(defun submit (r act)
  "Explicit public Form /1 submission.  Form /2 is not in this call at all."
  (when (row-petition r)
    (multiple-value-bind (outcome refusal)
        (f1 try-submit-petition (row-petition r) *context*
            :by :reading-room-clerk :by-id (occ-tag "by" "clerk")
            :act-id (occ-tag "act" act))
      (setf (row-outcome r) outcome (row-submit-refusal r) refusal)
      (when (and outcome (f1 petition-submission-outcome-slice2-receipt outcome))
        (incf *derive-invocations*))))
  r)

(defun outcome-kind (r)
  (and (row-outcome r) (f1 petition-submission-outcome-kind (row-outcome r))))

(defun print-row (r)
  (desk "~12A f2: ~A" (row-name r)
        (cond ((row-receipt r) (format nil "REPLACED  receipt ~A" (id! (f2 form-transformation-receipt-identity (row-receipt r)))))
              ((row-f2-refusal r) (format nil "REFUSED   ~A" (f2 form-transformation-refusal-code (row-f2-refusal r))))
              (t "not reached")))
  (desk "~12A f1: propose ~A · validate ~A · materialize ~A" ""
        (cond ((row-propose-refusal r) (format nil "REFUSED ~A" (f1 petition-refusal-code (row-propose-refusal r))))
              ((row-proposed r) "held") (t "not reached"))
        (cond ((row-validate-refusal r) (format nil "REFUSED ~A" (f1 petition-refusal-code (row-validate-refusal r))))
              ((row-validated r) "held") (t "not reached"))
        (cond ((row-materialize-refusal r) (format nil "REFUSED ~A" (f1 petition-refusal-code (row-materialize-refusal r))))
              ((row-petition r) "held") (t "not reached"))))

(defparameter *base* (petition-of))
(defparameter *support-path*
  (f2 path-datum (f2 index-step 1)
      (f2 key-step (cd0 make-identifier-datum '("lisp-plus-form1") '("field" "supports")))
      (f2 index-step 0)))

;;; ==================================================================
(section "CANDIDATE A — STALE PRECONDITION")
;;; ==================================================================
(desk "The declared expected-old is not what is actually at the path.")

(defparameter *a*
  (transform :a :input *base* :path *support-path*
             :expected (f1 support-reference "SOMETHING-ELSE")
             :replacement (f1 support-reference "second-opinion")
             :tag "a"))
(print-row *a*)
(check (null (row-successor *a*)) "A no successor")
(check (null (row-receipt *a*)) "A NO RECEIPT EXISTS — nothing happened, so nothing is accounted")
(check (eq :expected-old-mismatch (f2 form-transformation-refusal-code (row-f2-refusal *a*)))
       "A refuses on the precondition")
(check (same (cd0 decode-exact (cd0 canonical-octets *base*)) *base*)
       "A the input is untouched")

;;; ==================================================================
(section "CANDIDATE B — STRUCTURAL SUCCESS, FORM FAILURE")
;;; ==================================================================
(desk "Replace the production HEAD with a structurally lawful CD/0 value that")
(desk "is not a lawful Form /1 petition head.  This is the layer's thesis in")
(desk "one fixture: a receipt for a real structural event, sitting beside a")
(desk "refusal of the thing that event produced, neither contaminating the other.")

(defparameter *b*
  (re-enter (transform :b :input *base* :path (f2 path-datum (f2 index-step 0))
                       :expected (f1 petition-head-identifier)
                       :replacement (cd0 make-identifier-datum '("not-form1") '("some" "other"))
                       :tag "b")))
(print-row *b*)
(check (row-successor *b*) "B the transformation SUCCEEDS structurally")
(check (row-receipt *b*) "B a receipt exists for it")
(check (eq :replaced-at-path (f2 form-transformation-receipt-disposition (row-receipt *b*)))
       "B the disposition names the operation and claims nothing else")
(check (row-propose-refusal *b*) "B Form /1 REFUSES the successor")
(check (eq :not-a-derivation-petition (f1 petition-refusal-code (row-propose-refusal *b*)))
       "B and refuses it in ITS OWN voice, with its own code")
(check (null (row-proposed *b*)) "B no Form /1 proposal exists")
(desk "the receipt does not impersonate grammar admission: it names a structural")
(desk "event at a path, and Form /1's refusal of the result is a separate fact.")

;;; ==================================================================
(section "CANDIDATE C — CONSEQUENCE-CHANGING REFERENCE REWRITE")
;;; ==================================================================
(desk "Replace one support reference with another that is ALSO bound in the same")
(desk "sealed context — same species, same mode, same kind, WRONG SUBJECT.")
(desk "Both petitions are submitted.  DERIVE/2 judges both.  Form /2 judges neither.")

;;; The ORIGINAL walks Form /1 on its own, with no Form /2 anywhere in its path.
(defparameter *c-original*
  (let ((r (make-row :name :c-original)))
    (multiple-value-bind (proposed refusal) (f1 try-propose-petition *base*)
      (setf (row-proposed r) proposed (row-propose-refusal r) refusal)
      (when proposed
        (multiple-value-bind (validated refusal) (f1 try-validate-petition proposed)
          (setf (row-validated r) validated (row-validate-refusal r) refusal)
          (when validated
            (multiple-value-bind (petition receipt refusal)
                (f1 try-materialize-petition validated (occ-tag "occ" "c" "original"))
              (declare (ignore receipt))
              (setf (row-petition r) petition (row-materialize-refusal r) refusal))))))
    r))
(check (row-petition *c-original*)
       "C the ORIGINAL petition datum independently proposes, validates and materializes")

(defparameter *c*
  (re-enter (transform :c :input *base* :path *support-path*
                       :expected (f1 support-reference "clearance")
                       :replacement (f1 support-reference "wrong-subject")
                       :tag "c")))
(print-row *c*)
(check (row-receipt *c*) "C the Form /2 replacement succeeds")
(check (row-petition *c*)
       "C the SUCCESSOR independently proposes, validates and materializes under Form /1")
(desk "no validation was inherited: Form /1 received a bare datum and owed it nothing.")

;;; Form /2 changed ONE field.  Everything else in the datum is byte-identical.
(check (same (cd0 sequence-datum-ref *base* 0) (cd0 sequence-datum-ref (row-successor *c*) 0))
       "C the production head is untouched")
(let ((ob (cd0 sequence-datum-ref *base* 1))
      (os (cd0 sequence-datum-ref (row-successor *c*) 1)))
  (dolist (field '("schema" "conclusion" "receiver"))
    (check (same (cd0 record-datum-ref ob (cd0 make-identifier-datum
                                               '("lisp-plus-form1") (list "field" field)))
                 (cd0 record-datum-ref os (cd0 make-identifier-datum
                                               '("lisp-plus-form1") (list "field" field))))
           (format nil "C the ~A field is untouched — only the support reference moved" field))))

;;; ── BOTH SUBMITTED.  This is where the governed outcomes come from. ──
(let ((before *derive-invocations*))
  (submit *c-original* "c-original")
  (submit *c* "c-successor")
  (check (= 2 (- *derive-invocations* before))
         "C DERIVE/2 was invoked TWICE — once for each petition"))

(desk "original  outcome ~A" (outcome-kind *c-original*))
(desk "successor outcome ~A" (outcome-kind *c*))
(check (eq :granted (outcome-kind *c-original*))
       "C the ORIGINAL is :GRANTED — its support concerns the right subject")
(check (eq :governed-refusal (outcome-kind *c*))
       "C the SUCCESSOR is :GOVERNED-REFUSAL — right species, WRONG SUBJECT")
(check (not (eq (outcome-kind *c-original*) (outcome-kind *c*)))
       "C THE TWO GOVERNED OUTCOMES DIFFER, because the resolved evidence differs")

;;; The wrong-subject evidence REACHED DERIVE/2.  Form /2 did not filter it, and
;;; Form /1 did not filter it: it was ADMITTED and then JUDGED.
(check (f1 petition-submission-outcome-slice2-receipt (row-outcome *c*))
       "C the wrong-subject evidence REACHED DERIVE/2 rather than being filtered out")
(defparameter *c-orig-receipt* (f1 petition-submission-outcome-slice2-receipt (row-outcome *c-original*)))
(defparameter *c-succ-receipt* (f1 petition-submission-outcome-slice2-receipt (row-outcome *c*)))
(check (and *c-orig-receipt* *c-succ-receipt*) "C both exact Slice /2 receipts are retained")
(check (eq :granted (lisp-plus-slice2:slice2-receipt-decision *c-orig-receipt*))
       "C the original's Slice /2 receipt decides :GRANTED")
(check (eq :refused (lisp-plus-slice2:slice2-receipt-decision *c-succ-receipt*))
       "C the successor's Slice /2 receipt decides :REFUSED")
(check (null (f1 petition-submission-outcome-claim (row-outcome *c*)))
       "C no claim exists on the governed-refusal path")
(check (f1 petition-submission-outcome-claim (row-outcome *c-original*))
       "C a claim exists on the granted path")

;;; ── AND FORM /2 SAID NONE OF IT. ──
(let ((rc (row-receipt *c*)))
  (check (eq :replaced-at-path (f2 form-transformation-receipt-disposition rc))
         "C Form /2's receipt says only :REPLACED-AT-PATH")
  (check (not (member (f2 form-transformation-receipt-disposition rc)
                      '(:improved :preserved :corrected :equivalent :repaired)))
         "C it asserts nothing about change, improvement or preservation"))

(desk "")
(desk "Form /2 established that a reference changed.")
(desk "Form /1 established that both datums are lawful petitions.")
(desk "Slice /2 ALONE established the two governed outcomes.")

;;; ==================================================================
(section "CANDIDATE D — RESOLVABLE-REFERENCE REWRITE")
;;; ==================================================================
(desk "Not 'repair'.  'Repair' asserts the successor is BETTER, which this layer")
(desk "may never say.  What happens is exact: a reference absent from the sealed")
(desk "context is replaced by one present in it, and submission then resolves.")

(defparameter *d-input* (petition-of :support "absent-from-context"))

;;; The ORIGINAL validates and materializes — and then REFUSES AT SUBMISSION,
;;; BEFORE DERIVE/2, because one reference does not resolve in the sealed context.
(defparameter *d-original*
  (let ((r (make-row :name :d-original)))
    (multiple-value-bind (proposed refusal) (f1 try-propose-petition *d-input*)
      (setf (row-proposed r) proposed (row-propose-refusal r) refusal)
      (when proposed
        (multiple-value-bind (validated refusal) (f1 try-validate-petition proposed)
          (setf (row-validated r) validated (row-validate-refusal r) refusal)
          (when validated
            (multiple-value-bind (petition receipt refusal)
                (f1 try-materialize-petition validated (occ-tag "occ" "d" "original"))
              (declare (ignore receipt))
              (setf (row-petition r) petition (row-materialize-refusal r) refusal))))))
    r))
(check (row-petition *d-original*)
       "D the ORIGINAL validates and materializes — the reference is well-formed")

(let ((before *derive-invocations*))
  (submit *d-original* "d-original")
  (check (= 0 (- *derive-invocations* before))
         "D the ORIGINAL submission refuses BEFORE DERIVE/2 — zero invocations"))
(check (row-submit-refusal *d-original*) "D and the refusal is retained as an object")
(check (eq :unresolved-support-reference
           (f1 petition-refusal-code (row-submit-refusal *d-original*)))
       "D the reason is exact: the support reference does not resolve")
(check (null (row-outcome *d-original*)) "D no outcome, hence no claim and no derivation basis")

;;; Form /2 replaces the unresolvable reference with one the same context carries.
(defparameter *d*
  (re-enter (transform :d :input *d-input* :path *support-path*
                       :expected (f1 support-reference "absent-from-context")
                       :replacement (f1 support-reference "clearance")
                       :tag "d")))
(print-row *d*)
(check (row-receipt *d*) "D the Form /2 replacement succeeds")
(check (row-petition *d*) "D the successor independently re-enters Form /1 and materializes")

(let ((before *derive-invocations*))
  (submit *d* "d-successor")
  (check (= 1 (- *derive-invocations* before))
         "D the SUCCESSOR submission resolves every reference and INVOKES DERIVE/2"))
(check (null (row-submit-refusal *d*)) "D no Form /1 submission refusal")
(desk "successor outcome ~A" (outcome-kind *d*))
(check (member (outcome-kind *d*) '(:granted :governed-refusal))
       "D DERIVE/2 returns the ordinary governed result")

(section "D — THE FULL LINEAGE, AND WHICH WAY IT FLOWS")
(let ((rc (row-receipt *d*)))
  (desk "original inert datum      ~A" (id! (f2 form-transformation-receipt-input-datum-identity rc)))
  (desk "  Form /2 proposal        ~A" (id! (f2 form-transformation-receipt-proposal-identity rc)))
  (desk "  Form /2 occurrence      ~A" (id! (f2 form-transformation-receipt-occurrence-identity rc)))
  (desk "  Form /2 receipt         ~A" (id! (f2 form-transformation-receipt-identity rc)))
  (desk "successor inert datum     ~A" (id! (f2 form-transformation-receipt-output-datum-identity rc)))
  (desk "  Form /1 proposed        ~A" (id! (f1 proposed-petition-form-identity (row-proposed *d*))))
  (desk "  Form /1 validated       ~A" (id! (f1 validated-petition-form-identity (row-validated *d*))))
  (desk "  derivation petition     ~A" (id! (f1 derivation-petition-occurrence-identity (row-petition *d*))))
  (let ((sr (f1 petition-submission-outcome-receipt (row-outcome *d*))))
    (desk "  Form /1 submission rcpt ~A" (id! (f1 petition-submission-receipt-identity sr)))
    (check (not (same (f1 petition-submission-receipt-identity sr)
                      (f2 form-transformation-receipt-identity rc)))
           "D the Form /1 submission receipt is DISTINCT from the Form /2 receipt"))
  (let ((s2 (f1 petition-submission-outcome-slice2-receipt (row-outcome *d*))))
    (desk "  Slice /2 receipt        image-local ordinal ~D · decision ~A"
          (slice2-ordinal s2) (lisp-plus-slice2:slice2-receipt-decision s2))
    (check s2 "D the exact Slice /2 receipt is retained"))
  ;; NOTHING FLOWS BACKWARD.
  (check (string= (full-hex (f2 form-transformation-receipt-identity rc))
                  (full-hex (f2 form-transformation-receipt-identity (row-receipt *d*))))
         "D the transformation receipt is byte-identical after all downstream activity"))

;;; ==================================================================
(section "THE ABBREVIATION DISCRIMINATES")
;;; ==================================================================
(let* ((full (loop for k being the hash-keys of *census* collect k))
       (short (remove-duplicates
               (mapcar (lambda (h) (if (<= (length h) (+ +head+ +tail+ 3)) h
                                       (concatenate 'string (subseq h 0 +head+)
                                                    (subseq h (- (length h) +tail+)))))
                       full)
               :test #'string=)))
  (desk "identities printed: ~D distinct full · ~D distinct abbreviated"
        (length full) (length short))
  (check (= (length full) (length short))
         "every abbreviation printed above discriminates every full identity"))

;;; ==================================================================
(section "WHAT THIS PROGRAM DOES NOT ESTABLISH")
;;; ==================================================================
(desk "Not semantic preservation, equivalence, correctness or improvement.")
(desk "Not that a receipt set is complete, ordered, unique or authentic.")
(desk "Not that DERIVE/2 would judge any of these differently — no submission ran.")
(desk "Not that Form /2 is adopted, frozen, or on any governing floor.")
(desk "Every green here is SELF-CONSISTENCY CERTIFICATION.  The stranger audit is OWED.")

(format t "~%— a rewrite remembers what changed~%")
(format t "— it does not decide what the change means~%")
(format t "— and the receipt for a refusal is that there is none~%")

(format t "~%== de-forma-mutata: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)
(when (plusp *failed*) (sb-ext:exit :code 1))
